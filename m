Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783A54C4CDC
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiBYRt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiBYRt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:49:56 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2071.outbound.protection.outlook.com [40.107.100.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADE02177F8
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:49:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJGqdKrY/nHZVWrxIseQPXwYLTX1oe9QDHRGj2sTtFEiNldiTwIANDdrRjCxJyECFH5nwI9rP9Cw6dD2eqtxTidfQsrlNgejHukMhxASjyXNApi6lX8uJkSwOK+ttKkXJiV+isMM5ZVB2Vi1hFXOYZ2YnbgsW2LSHfFSXiZM7/0GUhVvk0VSRdW3LGnUNzLin6NuhglTjmKGFcXZsqwti5L+ypRTZtU1KBKTxmUIvR7BhcxpTtEY0hnL+N7743MFy7bVZwejamUa/Kpc7EoRVgSXD1Ev4SpDzu9zxeJhlorEeH1bmDBU20lpgWdD6/KCTCxOUJkZ2p4iVxavhueipw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ORL3q1S1bFvocqP9eO0oaIol2Pqikb9oGtRHF1pfups=;
 b=DZdUP3OdkkwZ7K3+/8DXBDEo/blgDmYZa5j3iHIgN6daHiz5SidjEeuPI/mDmLLO5QeaXEk3A8oDjxXWJD9A7FFlBR0WomHdQYez2pbKefJ7xuVmHkKvFbnZtV68rKw88WXwdNiDICeYuzxd62AyiqIQf+tnzJghQmJH6qZuhc887VE7UdOKZDL5AHcHr2oP4pHgTXpXdTDAdlpuGzyZN8n6qs3Z8az2PkCFkOnSA5EKPNtrjaouIxzqneJoMZKeW/H3eSrsswCsCw3TwmXBVcnCFSmAkCiGuhfQWBv/W+JImxpb5v69RJcbHjnF2uvz9fHz0cpUSgC2g8Cf2ThIqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ORL3q1S1bFvocqP9eO0oaIol2Pqikb9oGtRHF1pfups=;
 b=Whn6E0g7fZQIC8feATUsPkfDnWfsz683Iel7nCWIVB3OrVdJPv6Rs28DAVbE8hr8z2QoERccWCXLqnV7PKGQFuEoagL/I2sWVBZZbR50zzwdDn4XKffv5bNvgs2cEx0xlJfgQQtE4zolOULaAQ8M2mi6TeDcfgRhQSpTDBx4TgObquLqMqK3FgkOwDzGloHvn2/2bhnF7Wfhz/5zf0hlyfSplUUP8n7qXegKU6UeIwPBj4WCWXSyPohNi9DikaPZm+gZxSBh9pTZhRJQzeqomrikgl8yk8Tb7tDfSjw/KsI51Klkx3NjfOOIx508llM87PniEl5GgbtLASxigsSMuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by CH0PR12MB5268.namprd12.prod.outlook.com (2603:10b6:610:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Fri, 25 Feb
 2022 17:49:20 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::9cc:9f51:a623:30c6]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::9cc:9f51:a623:30c6%7]) with mapi id 15.20.5017.026; Fri, 25 Feb 2022
 17:49:20 +0000
Message-ID: <79eed237-4659-7e86-ed26-93f70b1d47bc@nvidia.com>
Date:   Fri, 25 Feb 2022 09:49:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v2 11/12] drivers: vxlan: vnifilter: per vni
 stats
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        stephen@networkplumber.org, nikolay@cumulusnetworks.com,
        idosch@nvidia.com, dsahern@gmail.com, bpoirier@nvidia.com
References: <20220222025230.2119189-1-roopa@nvidia.com>
 <20220222025230.2119189-12-roopa@nvidia.com>
 <20220223200206.20169386@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220223200206.20169386@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0037.namprd07.prod.outlook.com
 (2603:10b6:a03:60::14) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 572ceff2-6ee4-4775-1a2d-08d9f88726c4
X-MS-TrafficTypeDiagnostic: CH0PR12MB5268:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5268A00D51F5913069DDAECECB3E9@CH0PR12MB5268.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gOAcxQcJMVsneADTkdLJ7Zr/LLjs71/EDpHtYyptE/I9PekVeKIlIkA8KQYJGSmp4Dr5/ZHTvNemlUWZJObV24GIzKbT64xLK4/06cj5pd5aD7NS7O1oi/eKmEtyBYUpq3jbd7dKXsx++4nRff/Dy2xhhuxhnmsIfwhBXHpqN/im9obK45edC/J/O8lPRDxCJ5FKT2vwzarJp0C+uf/bUGPPS/KZPybx72NKTksK6SVS1QpFqJFlNLbIj8ncaHjTTLDusH9UD0eqx6iLk2ZDyq/jhdS7qZP9slWA/e1R6YqpKR4kylaCQ+GuYKGDwGMM0Le9wZb/ri7bMPiik82+0ytuAz3PdJdZ+PwjfM8AwT4+0cc8dDma5NMvqH3s4pbufaKgeTA+fsGPlsBwbbCbWaiCrAcEaORv2/U32/gJxXrPqJrHWOvOuDzNZJVw8bgKT99tc750WyUbg7H+bKRCX9/qkXW2JM+qxno6T9LrknbTfOkcrOdjUBlOari+SeSnUSXqmYJPj5V9z5d6y7rnxHg2t8Ev4RN3aatl+CvZ3dSNkYOSmWStx/PJhFSEZXUkCgUXNwmF3cljp+AknqUB0t2TnhMdOdy3e60Dq/7yu2h2L4a4ZToTkzoK8biaBNzQ0J0gZ4AIGZ8c4iid0WLqO19UaCXK3UyFg6o+4efnwQiZ3kEMi7LMLRSuGEkdeOEZcvxXRyocd98zaNU6nI3BAthKjF37VCbJBrR9fvabFpZThc3/z7PquHRoFjTFRHwt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(31696002)(31686004)(6486002)(316002)(36756003)(6916009)(508600001)(8676002)(2906002)(2616005)(107886003)(6506007)(4326008)(53546011)(86362001)(66476007)(186003)(66946007)(66556008)(38100700002)(5660300002)(4744005)(6512007)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDlUZEhMams4RmpSUHd2cFkrS1lQWU5BN0RPRWZLUDh1TVdPTGhPNjZObHNI?=
 =?utf-8?B?aGozYlFsOXp1TjM4MW9qRHFnN0x2b0ErU1FCdTlJMG1VUSs2SW1XNGtVS3Jr?=
 =?utf-8?B?bUgvd2duVU5lRHNMNXRqODBwRkRPQXlyZVdYNVUzNDdvdldmUEdEYWJ3cmVX?=
 =?utf-8?B?cXFsOGNveWhyaHEwVGxieXUrbnVNNWMvc1lxZ3ZNZmdublVHZHJ5aXh1d09H?=
 =?utf-8?B?YkFsanFSYXJJUnNqeTdxMDhjVUx5MncyNlc1YzRoRjlpeElvMitNZFV4TlFn?=
 =?utf-8?B?WWZ2cjVBeW9hYThoZWZtZjRaZDE4djBMM0MvYXJyakx0ZFRXV0tVQmdWc0Uw?=
 =?utf-8?B?dHdCRkptdXBnSTl0Y0VuZ0xTV01PMXR2SHY1L0ExbW5WbGRDalpsOFBLYVNQ?=
 =?utf-8?B?eStnNlNtdGd0K2lXd2JVNmlvb2o2UEplNldQOHJwMWlsa09UUjhuYXJRaks1?=
 =?utf-8?B?bkpFNVRXMFR2NXQ1OFVGNm52TGNXN2tGQXNRZ0g2TytYcjEzZG82SUJ3aWlS?=
 =?utf-8?B?d29PZEZxM2hmZndFZzlvcXZyTVp4ZTNCRnBob2NtMTJaNnV3dHAzazY0bWl1?=
 =?utf-8?B?cmNud005cW5ad0RqbURBK29UL21YZ29VTy9TWmdydnpkSVRmUllqNkJDSDBL?=
 =?utf-8?B?RHZRSVZFbnlDMTdTR3JJK0EzU1E0MHlQT1hkTXdSMmhwNFBtY1dld2dsZXVi?=
 =?utf-8?B?ZVJESUVhN0o5T0srZHdSbnZKSWpyR3U5cmFtUXBGeWtOQnFVdUtrUWVreHps?=
 =?utf-8?B?azZ1QXI3VURWN1RhblVjS2s1ZkV1UTQ3RU5RWDdQMHRTRGJRbk0zSk9ITlh2?=
 =?utf-8?B?anpVK1FCcFQ4R2g2OXo4elpNQ2FhM1ZMeDVNbTYrYW1RM3h1RXVkTWVSK1d4?=
 =?utf-8?B?OVNCS2d2Sm8yeDY0eDZZZVFURnJtWXY5bk1EanFtMWd2QzBiVXZVVWEwb1d4?=
 =?utf-8?B?akNCcG1WUUVBNXJOQ29tTnpXeVk0WFhCZSt5UTZQT29jc25Ea3ROcWFOOWQ3?=
 =?utf-8?B?OG1OeFk1MEg2S28zRWk3VHZ4ektRNnNISk9UdXFVd2RPZzY3ZmMvYVRMMnZ6?=
 =?utf-8?B?Q3dQd0IxdENjeHpLYVlkN0p5STQ3UThhUllOWUVJWk1EQnNNTysrK1lLQkFQ?=
 =?utf-8?B?cjJvczExUlFjUjR0THoyQWVrbTF0cW55cVpWbVFLS0hZem1tNWttSVlvYncy?=
 =?utf-8?B?N0dKV3RyTThid3RkUzhtZzlIVVFNNXZDMjlKOGtqVDRxVTFEa2hITmhSTVRF?=
 =?utf-8?B?cSs5Z1kvY2FZWFc4TG93cTVFMCt0ekVlNmkwNFBTUmFQVU9lYks5RTZDTExu?=
 =?utf-8?B?UmMrTk41d2FidkRCcHY0N3A0MWt4VGJvdHliWFZpYTBXNnZveVhGZi9welpa?=
 =?utf-8?B?V2NoWDNLZHcrYm82bEFUSnFHOWFhZXpWV3UrSmNGdTdHNnBWeTZ2QVZ5NVpz?=
 =?utf-8?B?Skc1WEZHK0ZWczk3cHpraWFiRE9rNE41MnBUOExNa0FKanBpSUcwdmxkU1NZ?=
 =?utf-8?B?OU04TUs2YzZLVUNkMVMrUHVTMWZyYldlZERKaExpMVZVSkJzWFlYalBnb2F6?=
 =?utf-8?B?dmVQYkVxN1FlN0hTZXlUY2NNa2lqcjVFY0c0TDNuTnpTQVhxbTBFM04vR0VP?=
 =?utf-8?B?clFleFFiallFeGVOS3JMbVQ5VGNaSzR1OVZtei9wY3Q5d0pSalFMSXM4b2ZF?=
 =?utf-8?B?SW1FN2kyYW41QXRyazEzUkRQL3NWQy9EZVlVdHpCNnNZVmRmU1JUWVR1eEpq?=
 =?utf-8?B?d0ZwVVFkMXVOa3V6dWN6NmNzb1VYY1pia0FOMUh5b0RlZnpJbzRzZ2dOZDE5?=
 =?utf-8?B?WVF6Y21PSGlseWFGUnRnRVFzQ0JxMDNHZW1PaGpvbnNYOVdpdXZJb3IxZmpQ?=
 =?utf-8?B?eDJwbHo4SUFmY0hkVU82enNRaDJPOUNWdERwdUxvaUxsMTVkTnFMcUtBMlM0?=
 =?utf-8?B?NTV6bXM5WlpvLy9ydGFQQ1NmL0ZSdnVaRzdQNzcyTFFTTGZMR2R0R1BCTWp1?=
 =?utf-8?B?cVdGcVNpTTllSFYxYTZkalZDRDZETkc5ZjNJejlGOExzeG1vVzI2SWFPczNO?=
 =?utf-8?B?RE1hK2ZtTGZnWFp6dTlqQStDVkE2aXp3eVgvY3lrcU41ZjVoRWtZZDdhVlJG?=
 =?utf-8?B?UElOTlpQYURLM1EvS2FMNUMrTDhRL1BOMUNyZUZPWDZVWE44OVhnQ0ptK0Mw?=
 =?utf-8?B?U0dUQlBtU3VrZjRMeTcxaWxMeFdTNE8rb1ZyZXdzdnJrQUd2djJWYWxTYXNi?=
 =?utf-8?Q?Okiw3Is9ngvHzpVMXT7GCob5VqHi2C5zqgC0kdKOKc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 572ceff2-6ee4-4775-1a2d-08d9f88726c4
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 17:49:20.6950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1GrDrN80we5MNlYIuOCzxi7UKOy9aVWsscPoO6vIiciFmg4ZOhQ9zRtkcgxzglEhnnW9B61Ka7/knGcTHhNGOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5268
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/23/22 20:02, Jakub Kicinski wrote:
> On Tue, 22 Feb 2022 02:52:29 +0000 Roopa Prabhu wrote:
>> @@ -164,7 +166,6 @@ int vxlan_vnilist_update_group(struct vxlan_dev *vxlan,
>>   			       union vxlan_addr *new_remote_ip,
>>   			       struct netlink_ext_ack *extack);
>>   
>> -
> spurious
>
>>   /* vxlan_multicast.c */
>>   int vxlan_multicast_join(struct vxlan_dev *vxlan);
>>   int vxlan_multicast_leave(struct vxlan_dev *vxlan);
>> +void vxlan_vnifilter_count(struct vxlan_dev *vxlan, __be32 vni,
>> +			   int type, unsigned int len)
>> +{
>> +	struct vxlan_vni_node *vninode;
>> +
>> +	if (!(vxlan->cfg.flags & VXLAN_F_VNIFILTER))
>> +		return;
>> +
>> +	vninode = vxlan_vnifilter_lookup(vxlan, vni);
>> +	if (!vninode)
>> +		return;
> Don't we end up calling vxlan_vnifilter_lookup() multiple times for
> every packet? Can't we remember the vninode from vxlan_vs_find_vni()?
>
you are right, its done this way to not propagate vninode into vxlan_rcv.

let me see what we can do here.thanks


