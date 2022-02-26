Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C8E4C534E
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 03:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiBZCQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 21:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiBZCQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 21:16:20 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F071BAF3E
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 18:15:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIbDpOkmpZ/Q2LOfMkKPy9JkyhYeXiqLQSAm8OYlouJNJmqNCHFAx/7RmesK+u1aPiNZ0u1a58htPo0HH46xPMFctpcPBZhqLF0Vvdgpw46TACoKlPiEw3ovWN+EWqwj8kCooi+QFpMOagakFq3CAZP9u+uVn7XJKV4ukSGTCQYrJD5BRNi3oGqfDgvaeE6zG1xfy1osWVmYuzTcdYDq/wyTaB7HisVN/gLvUU9b9TMMBVQx09lHcGcxhnzhc2uLPe/GvqqBHDidjY4q0aQ4bqBF2Hf43B93eLemZwH63W3aJQ0w7vAoFqxVDRZSSfX7WRJbQaqpfOYKFvrOYyJD3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aKhZGHaWmOBb09zntM/9oyyIrvnqQ+z3CW/lkf1Pi04=;
 b=PkFcMIIpMjfQIsK8Tfq9UgWqFOnRSpZMTeGS8htJSL+00f7wYkNgwe3ozv1QhLKK6pJjyWKgZSJHjvJ22RpC2eZrPIfhZIOCeK4j57ZJy2HZGPfLRZi5juBlQa13NRDnSH0Q8b87NY2BJCXrF/zs2KreLCdMucm9X0Ici3RK6B07vXlINQpt4MSvwgIozUUo/er6SPA9gNyzPVDpFhzWMij4gQUHOmFJ8C96AOdo0yGPB2tscdYdb5BaWytq9lEDgiHwXtp1eyrQJGPZkhE8OpbcLWSY7sSJxtX4AlfwS+SNWruGg2otZt9e3tbN2LGOqXJsTHsmxcSvT1g3rGxVUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKhZGHaWmOBb09zntM/9oyyIrvnqQ+z3CW/lkf1Pi04=;
 b=qNxTB2EOMlf4Yj9FM/Yy20bC8615tHNxQCaeX5UJS0oNkbN50jjaOOtJI4RaLTIPutSZ5sxaIcIgmQCq2nIG+yMy0/b7Xe76XDp/Qh8srRi7cEHO6dub6H0Au+pqanb3B3IuKOGuVitEbn/NmoJnVtQ6m9UxmDjedgLP4Auv8pvGOxr0GKCSdUHzLh9fU0c8lF+Z4Efhj9AeWvyH9Jh/Mf7HiRJ/AvQLGeSqleG9sjrTddyfbppbRzcDCDGFDq8BG3EIaIhxdv1T016NLKIr/j/KMUVAqtKMjrrX3hCFCA9Yj7J4FRweHfB7cIOGdQ4sivUi8FBw139tfgjm3X3Qew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by CH2PR12MB3766.namprd12.prod.outlook.com (2603:10b6:610:16::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Sat, 26 Feb
 2022 02:15:44 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::9cc:9f51:a623:30c6]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::9cc:9f51:a623:30c6%7]) with mapi id 15.20.5017.026; Sat, 26 Feb 2022
 02:15:44 +0000
Message-ID: <159409c8-c958-7ae0-c6dc-f353ecedcc26@nvidia.com>
Date:   Fri, 25 Feb 2022 18:15:42 -0800
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
 <79eed237-4659-7e86-ed26-93f70b1d47bc@nvidia.com>
 <20220225143431.716256c9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220225143431.716256c9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0042.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::17) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4db3d9fb-9727-43f7-b5d1-08d9f8cde50f
X-MS-TrafficTypeDiagnostic: CH2PR12MB3766:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB37664154953EC94A846CA355CB3F9@CH2PR12MB3766.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZNege6gZ+H27dOzpX24dkkDSafoUarRuOScbW4j7YX+8s2kr7H7OGpuJ/4Prn3eQkne8nfNB08VuaiSR5Kiwo2xSDh9qQV71V+ydkLUvKhkq8viQF1U6IV0GOMVdYg0I70KDAa2CJKZk/buVAzXFjb+ynMFAeXft6Gy0mCz6KY6LIeqdWgH03w2BlWxT/I2XyJQHaJFrxwf6z/VWJGm24dD/8qfsijbCsw15Ql74M/V/USEELeKlSN8evtTipQrhqogoTZgkzR/uPGfHNnT3INvRVXQgzv+e1VBJ7DhJKvYFQGPYuwLtI1nABEyTx5SZyQNJqeQOj9Tu88J0uKma2Sl7gBVvxJN9WKMDiL2r8MI/q22A0a3j2zn0v+G1TxET2BMjMifSYw79Sd/+W4bfDaOfMJ5jYIb3X1U2bNDK7yUwaUKRWWaRUs72RG+sJBG6qcYbKRF0inzyb8nt+78VPEknKOb9YFfUevtyh6GBS4c1rCTduYRhGrubj15krbqUcLyfUGSQwZ201TcE2zyKJh+cE1uGoU+Rf2wUGyi7iIBpgW8M++J5BDmkHd5ou1OUrCPe7H7jq8xCcqpKXkaM7pJAr9JP/fKQ8oIh1f9HDh8dNOXZSYQ1nNQWw/+xHyqiblx8l/S1HS6Cs2WUS4e4xXrp4v54pzgReq//XIO5so5MEhohfKlSF3ARR4ZQKMdEzrv3RenkhtAbAyHHCU5BBSyPLznb2+RV7dyRfgsoFBc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(316002)(8676002)(36756003)(66946007)(66476007)(66556008)(83380400001)(31686004)(31696002)(53546011)(5660300002)(107886003)(6512007)(6506007)(4326008)(2906002)(26005)(8936002)(186003)(2616005)(38100700002)(508600001)(86362001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXFQenV0cW0yOTlWVHU0OXNjcTlTc1FFSHFNUkxLZEQ1WEVYQzVGSUl1eUpW?=
 =?utf-8?B?Ym02enlJQ2VEaWtvazVXSklUWUlkWUdQTTE1UHdYNnFpcnlhUmFVWDJKWkFk?=
 =?utf-8?B?enVoNWtXL21yeitOZ1E3Z0FzY2NnTEE0S00xa002SXU1L2wxVjRFa3lrVnNr?=
 =?utf-8?B?NmZ3Z24wQmVPY0JNQmxGY0JnVzVaeERjcG1hTGJpYVZXZnYzb2dYZU1nM1VY?=
 =?utf-8?B?NFZXMGgrd0J4OGNlZ0hZMmNiL0UvQ09sSTBHVkpuM1ZxUXNpUEFnR285ampv?=
 =?utf-8?B?eC85bnJoVE1VK0dMWkFQNGlKV1ZFODgzL0FDUk9uY21rUm9iMXB1aDRXUGpm?=
 =?utf-8?B?dlZWb3ZzbTFZbnh6RTNkQnBMeWNpaUwxdndVdFl5UTI1aTZOS3BZUEwvMkpZ?=
 =?utf-8?B?UzA3d05vK2Nja1BLcXN5eXBQZlcwQVpWWTg4MHJoWnhlZmVTNHY1ckxxMCtv?=
 =?utf-8?B?NTZDdHp5VFhTYjRib2h0QlR5V3psdlo1U0JYcnJHYUNLelQ4TXNFRnNvUmo5?=
 =?utf-8?B?Qit1ZHFtWjN0VzZWNm9LNjZ1YjM2VFBrYzRNV2hoYWFza2JScUNBZ1JVTXpm?=
 =?utf-8?B?RERCcWhrTU5EQ0UvSTNSSWxsd3RtZXJhaWJONzJLN3IxSzkyMGZQRk9TUHV6?=
 =?utf-8?B?MUJ0Yzh4cmsydjdPUDRBUXYzREhiL0x6OXMzMm56eEI0cHRXOEREMnNQYTNW?=
 =?utf-8?B?elZKa0xCdHFzQm9ySDFnVjhFUDZRKzJzMEEyY2VLUkY2WUViMXcyTVFCdFRl?=
 =?utf-8?B?MVlZdGo3VUxkNTN0SGRTdURHVjcwSjFZVGlEQ2ppOWpRK01VTVpJaFNsbkZw?=
 =?utf-8?B?NVdkamdURzI3VXYxaGVlcitEeVZjYW1JbnY2ZUlqYld0ZDNHMTdtRms2OWVz?=
 =?utf-8?B?MThkWHpmWUlTU3dRcWVHWGlpNVl2R0JDNjNiTWE1UndmYlVUY1M4RUNTZEt4?=
 =?utf-8?B?eHdpdEdnWFR1REFuUzZaSWsyV1JhTWZiU3IvVDFDdkFqTG9WQmxqRVJQK1Ey?=
 =?utf-8?B?MXh2emtSZTh5eXExMVBTdHpnZWRVRjJNWGxGRFQxSlhKQmtxKy81RVZ1NGZQ?=
 =?utf-8?B?SFdwOTFlOHpsVEdLQXJQMTRQS2J6R0d2cUY5eldtS21GaXBHSkJZNEpLaDJ5?=
 =?utf-8?B?dnNrUnc1RlNIZEdjUjhSTlZZOWZPK0dnME8zUUdYdnppS1g1ZFBCWWVqQmpS?=
 =?utf-8?B?aTQwRE9XY0NsR3BqK0IyUjJ0bElvMVBWY09xaERtL0FnbFVsQWFJeXU5YTJu?=
 =?utf-8?B?dENyK0ZwZk1QMkhKNGpiVi9WQUhmRkpPemIzRHZwWGVRZUd0dS9Pb0xJdVdO?=
 =?utf-8?B?RXAwMnc0YmgvRmk4SW1FWEVnNGIvdjNzZTRuMElIZEpsL2tzcFhteTQ5Y0Jm?=
 =?utf-8?B?aUNzemV0TlEwU3ZobTVScVJqN0RDc3NKbFBSYUFha0E5STBhQmlJc3B1U2JV?=
 =?utf-8?B?dHhabnJaVXA1THhoMUdsRElQSHhZZjBtT1Z4V2Q1T3orYUJ5cFU0RkI1Y1pz?=
 =?utf-8?B?Y0l2d3NVUXZUd2VMaXdBSmFrT0JoUlFIN2d0VDg2Z3JsZlF3TGM4eXdWZGlT?=
 =?utf-8?B?Z0VWRlVETzJORHlkb0o4K2pZR1U0V2tHbG9zRG9ad2xXbXNMWUs3Q0h5a3hX?=
 =?utf-8?B?VTZ4RUY1eTNYbi9HVC9MRWlWVmJqS0NvVXNkOU1tbXlUWlFESmpvQ01YUVlC?=
 =?utf-8?B?Mkh3ZldWWGxhN1dQN0d5WElLUkdpa3pwMmhOUjRMd1V0cmVDbW5iTHZvbFJz?=
 =?utf-8?B?RXFzUTJoOGNmN2xSbHFYVTRzd29jblRQMVBIZFY1OUl1Q2tDUzIvVUFDaVBr?=
 =?utf-8?B?R1ljUllLVTBSbUErNEZxdWFUTFRmNGthbmVWNlRpTHlQUW84VHVHUDVrdllU?=
 =?utf-8?B?RFNUYTFJNjB2L0V2S3ZiTkxzWk5pTVA3NHVYMnk5aktjdUF6eTh4ZlduZG9m?=
 =?utf-8?B?RlAyZzJxMlJmN0luT2FlNmpQRm03YUdBbzBPSEtmdDNMRWwzRnFCZm44emdJ?=
 =?utf-8?B?d3RYVnVHRHQzMDVGcU5ZbzRaV2NGR3pDdVZmREFBL0lRdmY2d05qK1h0UGJ4?=
 =?utf-8?B?bi9KeWp4Mi90YU5CRjg1QU5WSUhJcjdXbDdEK0o2NnIvMDBHL2UzZ0g1eDhE?=
 =?utf-8?B?a3JWU29kRjV4b21SVWNNMjc2dkZkSG9YYmRzdmtUY1BIVE1JdWdmdnE0M2VJ?=
 =?utf-8?Q?t0Fu166iAiecq6b6ZnKM0Xw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4db3d9fb-9727-43f7-b5d1-08d9f8cde50f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2022 02:15:44.5725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aEkrEJ8v3dkPAkaKOvmUsMy+cmpvGbFqQYcffSwPSsBMV928a5WtW+EAJOutpof3oJ08AkZJvNz4TbYIpPrc3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3766
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


On 2/25/22 14:34, Jakub Kicinski wrote:
> On Fri, 25 Feb 2022 09:49:20 -0800 Roopa Prabhu wrote:
>> On 2/23/22 20:02, Jakub Kicinski wrote:
>>> On Tue, 22 Feb 2022 02:52:29 +0000 Roopa Prabhu wrote:
>>>>    /* vxlan_multicast.c */
>>>>    int vxlan_multicast_join(struct vxlan_dev *vxlan);
>>>>    int vxlan_multicast_leave(struct vxlan_dev *vxlan);
>>>> +void vxlan_vnifilter_count(struct vxlan_dev *vxlan, __be32 vni,
>>>> +			   int type, unsigned int len)
>>>> +{
>>>> +	struct vxlan_vni_node *vninode;
>>>> +
>>>> +	if (!(vxlan->cfg.flags & VXLAN_F_VNIFILTER))
>>>> +		return;
>>>> +
>>>> +	vninode = vxlan_vnifilter_lookup(vxlan, vni);
>>>> +	if (!vninode)
>>>> +		return;
>>> Don't we end up calling vxlan_vnifilter_lookup() multiple times for
>>> every packet? Can't we remember the vninode from vxlan_vs_find_vni()?
>>>   
>> you are right, its done this way to not propagate vninode into vxlan_rcv.
>>
>> let me see what we can do here.thanks
> Thanks for making the changes, BTW there was also a transient warning
> here about vxlan_vnifilter_stats_get() being defined but not used.
> Maybe move it to the next patch?

yes, will do, thanks.


