Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DAE69C409
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 03:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjBTCFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 21:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBTCFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 21:05:23 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAFDC15C;
        Sun, 19 Feb 2023 18:05:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=csbVLXQAgG0rcHu2ya9Y+m5G8JXItFKdu0GTb8tcYfPastGpkjbZYc9nPjA7pk7g/W6nNxOM/qRApvSia/zl6WmVqCvdcNboXMtNtKMfRACWlxF5zICPulMkQRhfCvgJzCfpq+oip7ZuC7Smn/iKyzTWJQcHIopxn8Ubwl2HMcsG8JlBYY0Nb+1PN2RY92Y7BbD+mWkdp0m+zpLLrL/E8e2DH71ApCf5P2hgbRu/CqZsQ4GVHSnTiGvgJUsAY+FerfJQeOd3ip8NqfpauTAn/qL7OND9U4My2MF7yTyeAgaOgYpU7MOa5Aw1szFEkwAb6PdnYipRZ10iPrnAzS6MUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=md66kyurNA7929Zoo7Io04OkKgepdtddxI1WsIQ9Du0=;
 b=Q24NaPn+esE+w/z+03aK7xWevEFfalBWIXc0MISnG4SeZrveTvY4LbFboJh9jxa6YZSb5U7IHxkB9iTGsNHW6sG0MS+LNRGRA7WeWKxRlWtvOAISr8gmX6mwo+vCDQb9K0LW8RPxVx3Lvuy9tFKfsaGtcvFSZVsAdhSrPsPb/FbXcJZaaQxb/sfmTdxC4NaouXiZnFA4hJAdpX/+faRhPR9K8VuuJUm3mAV+NnUsuiV+DD6lQdTHJ9opwwI4NiE7x4x5rTm0R76M02Za4/3sjpNDsgG9Aloiwgty4Ifcy/W0WYjDdpTDdJxeCvEzUw7DAZCXM+9XwnCH2ZdgG5QUgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=md66kyurNA7929Zoo7Io04OkKgepdtddxI1WsIQ9Du0=;
 b=jlBZ0klVb6qWuWIZ3LCMo9Xm5/S9+nK8L+dLLkiPufxOOaKSq3sKo/G1tS1iW1FFNUkqD63ksjCdU8nOBY/JXcdlicss6eVzf7L9x6JNy5lWRmkfFnx8fcNt9XCEXw8JVFk28MfKeP/EyX8XNM2PTNi6joJY7y4JvUs/8zijen8BpCiCVd7HWqNybpeZYW4As+2X+bcWpBMnAUVpCFXeWoj3G4o3Faaex+d6mxkeY4VpgJhp2Ja+JXPqzmWVgltEDWe0wwA5LXS8ifvXH+ZjSJMHwscu+F4uAALaOqi3bnueriOCfMVJDAf/hllGrk8ksIYiHsFDf2I8S/A995KTeA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by CH3PR12MB8534.namprd12.prod.outlook.com (2603:10b6:610:15a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 02:05:19 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b%4]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 02:05:18 +0000
Message-ID: <b0f07723-893a-5158-2a95-6570d3a0481c@nvidia.com>
Date:   Mon, 20 Feb 2023 10:05:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v3 2/5] vxlan: Expose helper vxlan_build_gbp_hdr
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
References: <20230217033925.160195-1-gavinl@nvidia.com>
 <20230217033925.160195-3-gavinl@nvidia.com> <Y/KHWxQWqyFbmi9Y@corigine.com>
Content-Language: en-US
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <Y/KHWxQWqyFbmi9Y@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:820:d::20) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3835:EE_|CH3PR12MB8534:EE_
X-MS-Office365-Filtering-Correlation-Id: 84028114-46dd-434e-6dce-08db12e6ea08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: APfwpP7IPzNOh0x5vv87xEXTf5ARvxRRDXuHZqgAQXJae0N+ZUmkz6OD3i6j8tXU7bGBb57GqcStfagkstFGftDY3MF75ph/UJAF5hOGDv6zdcxo9jold50DcWlwLUU4bzy3xDj4ZDj3ocKzkwXZixwWVhm393ORys234fGV3/xyrboi5uyIJ3PTGJcZjR+nNYWHsxxPaBfcTU+Dj884RJTFTBAQf09VTYx8KUlyx1EfqpLWCF/M+4AXZWNFs3cpjWqwDCQHWpH3n01NVn6swQs5XfbzeMP9VDSqrUScfJRJFEZ9EqE8P6sCKAZmSiCdPY6cqVfb+UhGaXgOvGtBdLmqHAVuVqMDyUTRW09F7bH11suGbGOzQ6p2lWSe9jd2ddVR3pwJxbQV3hdmnvXHN77zRlNl+HY4G5sNDpvg0rvfAosFjlQoiScsHDgsyVxFC3fSdtTSBEmx4L6Bt6JUoQCeojCl8d1DJW57ldNQU6j7A3trFY32m3erweUhyQr3k/JsKKxQDz7rBRw8PFxMNFqb8YXjUg0Fa5UpZM4sP73oPUqfWiAY0iJJyXZMKN914DCqi7B4ciwFYxhmDT+yADRYe4hiMHYvgcqiDjXhVDYhrbEqYwSqk/ay0kuiZdpJucPvK1M2nVUVm5W8q/Fei1bm4TUVkD48D7JmyOmqN7i9uMiQU55tGtKTv+gCioFZpZYjN1jkhVsW4K0FTaswv28zH/+UXStnTCPgGOMCF6k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199018)(316002)(66556008)(83380400001)(66476007)(8936002)(6916009)(8676002)(4326008)(41300700001)(107886003)(6666004)(2616005)(6506007)(66946007)(53546011)(26005)(6512007)(186003)(6486002)(478600001)(36756003)(86362001)(31696002)(2906002)(5660300002)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UExwdEltT3h5cHpPMmVaL0taSldXTjhRNkFwbUp0d1hzR0VXRm5ncmUrc0tl?=
 =?utf-8?B?MXV3ekkvVHF2a1pENlVBM0NtNDFwRkltVFZpcWZ6UGk0QUFQaTdYQ1RXT0lJ?=
 =?utf-8?B?UEM4ZElNZFNLNUJNb1Q1YW9RcExtbnladmlwR2Irck5OYmljVDNTbk16aTJu?=
 =?utf-8?B?VHYxQ3dQQnFobjJEZER6Q3E4Q2J6SVE3bVFyVy9CL1MxeFNmbjkrWGhZWksx?=
 =?utf-8?B?UVNqTnRrZjVnUks2TStaWTNvYklwQ3NrN3JvUlBQcm9iMVBSVWZwaVBrV1JM?=
 =?utf-8?B?V243RUJNUktSS2JkT2h5VFZGdVpRK1p5VHZFb0xQWWhvVEdaQStWcFBYbFpw?=
 =?utf-8?B?RXdiSHdWRGNFU0N6Y2M2WFVxTlpCa29LcU9OckZ1VEpIZ3N1OVRRYVNpRitz?=
 =?utf-8?B?WWpaQXNHS1FSSlE5YmVJL1BWWGtTb2ZNTUcxd2ZYUHpLWDR0VkI5OEdYbDhT?=
 =?utf-8?B?MllXakcxY2laa0x5c2J1LzZPQ0h2SWpCc1JLTE55b1cwZk1xamtpSWFYQkVK?=
 =?utf-8?B?ck5pczBxUU5jS2V1L1hFdEVSK0hEUjlWQzVRcnRTT3o3SWJiUTRyZW9LbFoz?=
 =?utf-8?B?NWxsc2FUcmEydUQ5Qll0M29CaW04N3RUeGpCYmZHelNsOHhRdnRVb3JRZ0dL?=
 =?utf-8?B?V3hpdVY0WW0rMHpqOEcvSDBRWVlONWxrOTc5ZVA2M2dINmdieXJOc1hDL2Yy?=
 =?utf-8?B?ZTdPeUoxNUxYcnIwRGkwNW1PUzZ4ejF1UWhaRnhPQ3AxRExvSEFSeHNnR3hj?=
 =?utf-8?B?QTNwTUpFaSs0TWowT1FRdlJrbHlOanB2d09rVHJQT2pLcGlMd0tWRzNlaVJQ?=
 =?utf-8?B?dWMrQ3ZlSGtRZmpIWUJYL09UeXN6TGFJYzNZRExLV3Q1NW5rR0dBekx3LzRH?=
 =?utf-8?B?R05reDVROTNkcWNqcDYyUHNOOWNpOHlnKzF1RlNvbDNQOTIzRTlMYjd1WDlo?=
 =?utf-8?B?T09RZVh5aWVMWW9RNE1SSVQvbXEzcmdYUlFMd0JYUExKdXZJaUFXOW51OFF4?=
 =?utf-8?B?RHRsTmJGaDVSY2FyaXFJclZJZVkzQjlVV3JwVUU5SEI2d1RHd1hCaWxiNDdr?=
 =?utf-8?B?QnN5MEphT1NNdmZZZ2VyWGs4dTF2T1RIQnVEanlVdzdpUmNBQ1JtSklKYVZo?=
 =?utf-8?B?RjRJMFZ3WTJDSUErTDVzRnI5NCtlNmlLckFTTy9ueXM4cGp0cERJMVpyUWF2?=
 =?utf-8?B?QUhld1BPTUdGQnJ6UUJ5cHVvQVB3aUlUalJzSmZ4aEx3OFUrbFFrQWVETUJI?=
 =?utf-8?B?SU5QV2ZYMm1MZUMrWWhRb3ptYkRHSzNBWmt1MGQxV3k1WGhhL3J5YUtJK1Bt?=
 =?utf-8?B?RkFHSm1YTHhBbWsvMXlpQk5jOWpTS2pWdXF1UmRzTTA0RjYwaThOK3RCN25B?=
 =?utf-8?B?UFVXQ1hRekE2UlBXUDYySzJvcjNnZWx2d3kvRU1JR0I4WHRUMHY4VzNob0d5?=
 =?utf-8?B?TjJTdWp0dWtBR2h6bUFsbld1ME0zV25Gc2FlZEhUdkp0MWtCdkxyUEpRcWlW?=
 =?utf-8?B?aVJndHl2dnFHUlNsQWpGMHpyQ2R1a1Y1RndaUXNPaGFtVVFvM2V6NDZpOXFa?=
 =?utf-8?B?aW82cU5UQ2kyVCsxZ09WN0RiWU5wdzBmQUZSWU5SMDIzUnhiYWliK2d4Y20w?=
 =?utf-8?B?RmJGajI4OC9WdGMyeGtDUmRXdXo2KzRBbWxGdlF4ai9JRWQ5U3pIMnJrNzZY?=
 =?utf-8?B?cHZSZ0xGSXRLVDRGQmtaZ0JJSExvVlBCSUFuOWthczV4RTQxa05jaENWelYv?=
 =?utf-8?B?Ny9JOU5EUTVRa1ZLcVlCZkZlK0pVWmZISnk2WU9QVHI0WHNNaVVPcW9wRWRJ?=
 =?utf-8?B?cGtsMFhoZ3luNVd0L0c3VUlBdW16WDRyVG1KK2h1NGkxY1ZhV3U0OGJWb2Zm?=
 =?utf-8?B?cTZDVFlrbGd4NHlNRlZkYk51ejE5WU9EWDl6NUUyWmFMOXZQckgyZjJwcmxJ?=
 =?utf-8?B?RTI0ZmVaSGQrVGx3MVhaYUd5WTdpV1BES1Z4c3NlYUpxMC9BUXRZZmR2WGM3?=
 =?utf-8?B?a2swVU00dXZkZXlxbGJVY29zaXNwK3FnbExFWmxLMUx0VktJZk1qU3NSaWdx?=
 =?utf-8?B?RjJ3WDlrbFhaMEZlNlNXM2dCZy81QndyWGQzUEZPU01ISjdTM2tjd1g3cUhR?=
 =?utf-8?Q?2qYxsrYrvTfgLqQlr9b3xSP8N?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84028114-46dd-434e-6dce-08db12e6ea08
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 02:05:18.5943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9d+F+G6F0bDQn7PjDZl0UB9syuKGww7YEg75zRckF1+JTQpCrNSU6C78mGs+YnbePA1QhXSp0V9cxJsxWJo13Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8534
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/20/2023 4:32 AM, Simon Horman wrote:
> External email: Use caution opening links or attachments
>
>
> On Fri, Feb 17, 2023 at 05:39:22AM +0200, Gavin Li wrote:
>> vxlan_build_gbp_hdr will be used by other modules to build gbp option in
>> vxlan header according to gbp flags.
>>
>> Signed-off-by: Gavin Li <gavinl@nvidia.com>
>> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
>> Reviewed-by: Roi Dayan <roid@nvidia.com>
>> Reviewed-by: Maor Dickman <maord@nvidia.com>
>> Acked-by: Saeed Mahameed <saeedm@nvidia.com>
> I do wonder if this needs to be a static inline function.
> But nonetheless,

Will get "unused-function" from gcc without "inline"

./include/net/vxlan.h:569:13: warning: ‘vxlan_build_gbp_hdr’ defined but 
not used [-Wunused-function]
  static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, const struct 
vxlan_metadata *md)

>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>
>> ---
>>   drivers/net/vxlan/vxlan_core.c | 19 -------------------
>>   include/net/vxlan.h            | 19 +++++++++++++++++++
>>   2 files changed, 19 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
>> index 86967277ab97..13faab36b3e1 100644
>> --- a/drivers/net/vxlan/vxlan_core.c
>> +++ b/drivers/net/vxlan/vxlan_core.c
>> @@ -2140,25 +2140,6 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
>>        return false;
>>   }
>>
>> -static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, struct vxlan_metadata *md)
>> -{
>> -     struct vxlanhdr_gbp *gbp;
>> -
>> -     if (!md->gbp)
>> -             return;
>> -
>> -     gbp = (struct vxlanhdr_gbp *)vxh;
>> -     vxh->vx_flags |= VXLAN_HF_GBP;
>> -
>> -     if (md->gbp & VXLAN_GBP_DONT_LEARN)
>> -             gbp->dont_learn = 1;
>> -
>> -     if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
>> -             gbp->policy_applied = 1;
>> -
>> -     gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
>> -}
>> -
>>   static int vxlan_build_gpe_hdr(struct vxlanhdr *vxh, __be16 protocol)
>>   {
>>        struct vxlanhdr_gpe *gpe = (struct vxlanhdr_gpe *)vxh;
>> diff --git a/include/net/vxlan.h b/include/net/vxlan.h
>> index bca5b01af247..b6d419fa7ab1 100644
>> --- a/include/net/vxlan.h
>> +++ b/include/net/vxlan.h
>> @@ -566,4 +566,23 @@ static inline bool vxlan_fdb_nh_path_select(struct nexthop *nh,
>>        return true;
>>   }
>>
>> +static inline void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, const struct vxlan_metadata *md)
>> +{
>> +     struct vxlanhdr_gbp *gbp;
>> +
>> +     if (!md->gbp)
>> +             return;
>> +
>> +     gbp = (struct vxlanhdr_gbp *)vxh;
>> +     vxh->vx_flags |= VXLAN_HF_GBP;
>> +
>> +     if (md->gbp & VXLAN_GBP_DONT_LEARN)
>> +             gbp->dont_learn = 1;
>> +
>> +     if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
>> +             gbp->policy_applied = 1;
>> +
>> +     gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
>> +}
>> +
>>   #endif
>> --
>> 2.31.1
>>
