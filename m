Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68945AD185
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 13:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbiIELZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 07:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236506AbiIELZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 07:25:44 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EB957239
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 04:25:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/cFNZ0UC8Z69PugRrBYM8nAS3YzWGy8FoX+aMxRgW7ZxEPFZ+IsQWKuNPZHt8R5rjcVgsmk3ZVk60cTLRYwMtAHGcq31KU1r/BwDYaTskX433DCJHcEXk9uvp3cPwANRu2nKzjyp+ZB5xS5thtfIvzebJS3Ej08fDiqVx3SDNkFmm5QkyQ91pUJoxapf2RneENPqLJewn7bGvyFyaBcAGFuOrPYhfbeZEVHZEy+mMsQo8xjeiHXjl+q9tsWnM3PaEnS7tgVdpyBMfhfutcybpjnZ9d9QARD9wstgOBDAZdcRjTwnieJzZaFqG8m9ii7k+5imGIjB0udaoEyS4zikg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nlLk6cCViIFxaPCpwecW7tWVn4A9AKFp/m0TYRsP9Z4=;
 b=Q8LVSEjs7CRnMhYgDirNFAfdjG5layYpkIiGfUBYc7MzTh/QZUctPdr8q5dRHBJT42pDbI3/sPx9jFnAX+91Oxv1ztuw8DV3GPRlq37/Rh/AVmqR+TyS8geysgOB3jUPFexCHRLWRttYabtDt+DrPOEk/Bw5se8kDEVpFJve3PVdrTULEA41hOZSerW0pl3crdO0kQj/zbUvOXJvSubLKeCQqPDnkCgjfoq4ECMp8zjotHM8mzmyoVbpDLTOtIGbenf7JoTOkGFZJ8oSyjXV+mTMqL+mrWM3mjP4lp19ONTlwAjuxsNPTiZAq/ryVLwpIiacWm3G9P2rYGjmn/vg3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlLk6cCViIFxaPCpwecW7tWVn4A9AKFp/m0TYRsP9Z4=;
 b=MgrynJbr2rqh/trtEmlYxRfH25qnzQbFTJXku/ugmiBYae0dVLTLhUhO3mKXvWR4mquVfK87P6y4gBgVLvunqw8Ip9lFBnRHjScpD9D7fud54+i6z4I9VR9yNK1AATXqXxF0iaZwqv94ryXkUZOERH04lcOFTIyK4b1VKkKtoEJbkaX3QySt2RqjJ4YWTRp7UrT+GEr5mTJev6RnOYn3wwsfIJKN+hdsTdpy2/1L7O1mOdaaJtYyqYu9BudDIEgTYIKr2RZoYSeYjwzA2vPRZvDH6z4w6SoHmfuaT22o/RaB0xnnOxdUFTUbkhapTWWzBUti4pC3d4Ghb1FYr5RJlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 BN9PR12MB5084.namprd12.prod.outlook.com (2603:10b6:408:135::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Mon, 5 Sep
 2022 11:25:41 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c470:ce6c:1ab6:3e1a]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c470:ce6c:1ab6:3e1a%8]) with mapi id 15.20.5588.017; Mon, 5 Sep 2022
 11:25:41 +0000
Message-ID: <b3ea50f1-184a-f3f9-571b-a9dd4d8ab0df@nvidia.com>
Date:   Mon, 5 Sep 2022 14:25:34 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Andy Gospodarek <andy@greyhouse.net>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
 <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
 <20220825092957.26171986@kernel.org>
 <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825103027.53fed750@kernel.org>
 <CO1PR11MB50891983ACE664FB101F2BAAD6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825133425.7bfb34e9@kernel.org>
 <bcdfe60a-0eb7-b1cf-15c8-5be7740716a1@intel.com>
 <20220825180107.38915c09@kernel.org>
 <9d962e38-1aa9-d0ed-261e-eb77c82b186b@intel.com>
 <20220826165711.015e7827@kernel.org>
 <b1c03626-1df1-e4e5-815e-f35c6346cbed@nvidia.com>
 <SA2PR11MB51005070A0E456D7DD169A1FD6769@SA2PR11MB5100.namprd11.prod.outlook.com>
 <b20f0964-42b7-53af-fe24-540d6cd011de@nvidia.com>
 <3f72e038-016d-8b1c-a215-243199bac033@intel.com>
 <26384052-86fa-dc29-51d8-f154a0a71561@intel.com>
 <20220830144451.64fb8ea8@kernel.org>
 <923e103e-b770-163b-f8b6-ff57305f8811@nvidia.com>
 <20220831103624.4ce0207b@kernel.org>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220831103624.4ce0207b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0080.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::13) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 752d1932-d20a-4a20-66a7-08da8f315d54
X-MS-TrafficTypeDiagnostic: BN9PR12MB5084:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pj1AqMZ7ZGbiu1merBlgxAwzthHlfzwGbG98aRf7jc4RsnzgatKScMeB02UiSNLCWHV5stXUh5Szd0idHn96vdo/hOihQfhCa22lf9G1KYEnf+EfLEApYuqqyIWLccI1i5VidEazdPZQB9H0YNglMuv4E0wWuknz9t4hsYucjePiEPLYFKEXJ3xPB2o6xql/8tRaalfyMOlYEXrJFD0fH4XVj7vGkWUe5HjwlHtb8SB3/du2CuWNCLLoscWj0+XDE5+2alGBAFLJLeeR/zhja31fLo8DvYLy4ELAQceUFC9EjqIpKj+HKHx249lz54bS6DKzXM+bnXfo7iElywc/uvC5Ar+32fqbOzGLszSWReN+N+iVGoRFzkDlNcgIniPIoeSwwQ2+89nVtNoj7toP4ggHBNe2CYsTn3nbFlFVLpaBRHtQV3HtNj3xFlTe+kNMrdOsumtxBBCVqPY2i1taxWDEvWw0MnzDrJ9L6GhbCNtMV1SJI8lxYZ9A44viM/0A7eUTbV/M7NuCbGzvVHlEiKfrpef2V4Ne57vD+FbE6Z2mGinC8uJJHNfAtJTYB6FLgtej7T0kGo6RgmIa1CWOul5lBcVGddbTMbCk+8/ynPDMJM2j2sakGdJb4J/KcmFHCYbZkjAZ5XMcm0ObE8C8YsSwqWI3X7sFNp8+ij/Pv8uKwMfG8fkORpI28NzyU8ejaySdYCnmaNqgO60bDZdqDOZe2RU4qwTduYiPUC3MVcuyLW01wnV7hBkIev9AUbKP+GVWTmon0fnonXaMGqGt6NHxL2UGHqkTn/FCuCtiSnDuE3NNNNZYQKNE7KgqWYdzwhlcydYYm8EKOcLQJNxVaN2nyypWIPKvqF/23NjSP6qRnCJ5DKn85zSMbms/rJNy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(316002)(31686004)(36756003)(38100700002)(54906003)(6916009)(186003)(2616005)(83380400001)(6486002)(966005)(86362001)(4326008)(66476007)(66946007)(8676002)(31696002)(66556008)(53546011)(6506007)(26005)(8936002)(5660300002)(6666004)(6512007)(2906002)(478600001)(41300700001)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1pvOTh3NXd3L0x3Tm81RDlKYlQ2b2p3M3E0THdUK0ZJUVpMUXBlSDRsMGVN?=
 =?utf-8?B?Y3o5NmQvUGVMcXhmeGZKWWFCTisxMEtCdmdiQVFBdFpiWHluWUFDMzFpc21P?=
 =?utf-8?B?aU5pSVIvN2dJQlVudG9xWnp1Y3NXM2dBWC9QK3gwQ3BiRGpHNERydmRXYXI0?=
 =?utf-8?B?YVdLRmI3amlGcC9OYUFObXphSWp4YTdNVFBFVjQ3WGlob3ZYNDByYTJYWEFE?=
 =?utf-8?B?Z3k3M2E4NncwMTVqUTVPQkxHSk8rbysyVWI0UUgyQ3FZekM3NytmMEozVDhR?=
 =?utf-8?B?c3pTUk9IRzNWdURUdm1uKzVhcEZhL25ZTG1rTk9SRFNoR3B0SWh1Q0lVVWU0?=
 =?utf-8?B?S0diYUMvZ3hyWXo5OFFVbGd6dGIwdEduME5taFBGbHNEdkNNY3B3RVkxenVy?=
 =?utf-8?B?SmpYK3ZWM3pRQ1BVRkFJMHJPSnFHMURtakZML0huQXluQlVNYWdTV2xEWU1I?=
 =?utf-8?B?ODlndjFNUTRIUlJETnJwYkpWN1FTUlVtcnJ0SzZDb1JnSFlpeHQ0dWpjOW9Y?=
 =?utf-8?B?NnBVbjBoc043cnRIOEQ3d2pwWWk4enpKZ2M2OG12WDcyWmFweHdOOWx5OXFY?=
 =?utf-8?B?K254OG55K3h4OTdhUFUzWGFqTC9wUDdCd1Qwd01NZGE1aWx0QmxaSCtSaUNE?=
 =?utf-8?B?OWN4T3cwc1pENGZkNjhTTGZVZWNJR3JMdXBIVUZUMS93eGNCUnhydVdoek80?=
 =?utf-8?B?Uy9JNE1FbnJoS20za0Y5T1Z6cUc3UTlRMXN4RHRSK2dVMHdRN1U4TEQycGpN?=
 =?utf-8?B?dzBacy8weVRXeTNpa0NNNUdFV2g3akV3QVNLaEZEOSs3TnZjRkk0T0l1M3lv?=
 =?utf-8?B?UXZwbmlZV2RzOXJmOXoxcUs3MGZJMkdFVHpnQVQvVWF2bTJ3ZTJrOHNOUTJE?=
 =?utf-8?B?a25TMkNzS2tvcVB3QnNmU1B2amFEWlVHVFN2Mmx3NUswRWxoeWZuMy9OQUl3?=
 =?utf-8?B?T0I3bVdPa0hydzZ6V3BmSUNxN3E4ajFFY1VwZERmRmUvdm1VWEdqRkRZUU1s?=
 =?utf-8?B?RERYOUZqcUFTRll3d1IrdzRUU0k1ZFk0QTE2eThaWDlrVjBXSVRDZmx4dVdR?=
 =?utf-8?B?T05lK1pGVFk3bEp3dTU5QlA2ZkVzcHRFdGRKMEJLMkdSNHlRc21qVzhGaHlN?=
 =?utf-8?B?NklKcWgxWk52Z2IyTllKTi9udllWQ3RGVmVSSjl2SFFMZzNNY21NVnVQaTVx?=
 =?utf-8?B?R0NKalBCeFhKM2F2MmJLYmhBRFNoZXQwVmN2RHdhNUhPMzVoSjZzYzZhKzFw?=
 =?utf-8?B?Qy95c0ZLUlg1enF4Qmt6d0hCbzd1bUlpT1pTTVMweG14anlPU1ZaOTVWM1E4?=
 =?utf-8?B?dnFoVHRCUklaWVVxRDV0TkpDMlFTb2lmM0xDMzNBTVhmeFliKzRtazVZUzds?=
 =?utf-8?B?MDBlMTZmei9uejRlRTlRTUxLNGgzNjkwcnJ3NUh0OSsxRkNZT2JtQjRqcWZD?=
 =?utf-8?B?TkREYUtxVVEwVEZCNGdKRmxnck9RcVVKUEJxTUE3OGl1Nk9NaENGV3lrUUtz?=
 =?utf-8?B?OENnZXNrWGZiTG9TbUx5VHJNejZLUzZPV21nK21oMWdudGNoSDQwR2tjZHNV?=
 =?utf-8?B?by9xY0lGZHBpZVBocmk4b2lWdE1IeHN0eUhUUnZSK2F6WHVoRmdGQlk1c1hm?=
 =?utf-8?B?TXQyYzUxY0R5ajdONVVWWjBTR0kxNWpYR0tKVVZMY28wWkU5U3lLS3BnNUhE?=
 =?utf-8?B?b1k3azZ2YjJ2c0k5VklYUWFzdTJxejJwRFNoSEdndXFZK29iQW53bVQraUk0?=
 =?utf-8?B?TnlKZnIxQ2FvWTJiYjNiU0hnRXc2VXZqRHA1d1c2Y1o0WFNYclkrVElKV2NE?=
 =?utf-8?B?QVpLYjRnYkd5RmRTWFk2alJ6cjRiQzcvcTJYUG96SGtybVlWRUR0ZkNKVkN5?=
 =?utf-8?B?UzJlTWQ5UERFdFROMTltMUpCK2IvQStRL1hzMzNJWURMNVNNYXQ1ZEVXVEVQ?=
 =?utf-8?B?engyWEFrSzBVZ2ZwZzd0REllTnZ5RE4ySncyQWVFM2wxODdkdVJOd04yMGlK?=
 =?utf-8?B?UFQvb0R3aFczUGJ3RE5rSXdlSWtyalUycmszMkZNQTF3NytzRGVCalpWaE02?=
 =?utf-8?B?Z0tiOGFKS2lBNE1QUG5qa2I5amxOYzhCWWVydlhEOUliWnpQZmdPdlRZcmdp?=
 =?utf-8?Q?zND4kBgKmKCau02Rd5F1k1cUG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 752d1932-d20a-4a20-66a7-08da8f315d54
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 11:25:41.0217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QbMqmDMSgKeeFHTWlCRbB8DhAN2qzuwYvLAEYeFw/QWy6y7kMbKjk23q19LPnR1N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5084
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/08/2022 20:36, Jakub Kicinski wrote:
> On Wed, 31 Aug 2022 14:01:10 +0300 Gal Pressman wrote:
>> When autoneg is disabled (and auto fec enabled), the firmware chooses
>> one of the supported modes according to the spec. 
> Would you be able to provide the pointer in the spec / section which
> defines the behavior?  It may be helpful to add that to the kdoc for 
> ETHTOOL_FEC_AUTO_BIT.

I have been directed to:
https://www.snia.org/technology-communities/sff/specifications?field_doc_status_value=All&combine=8024&field_release_date_value_2%5Bvalue%5D%5Bdate%5D=&field_release_date_value%5Bvalue%5D%5Bdate%5D=&items_per_page=20

SFF-8024 SFF Module Management Reference Code Tables -> Table 4-4
Extended Specification Compliance Codes.
