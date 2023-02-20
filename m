Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0ABC69C5E1
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 08:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjBTHPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 02:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBTHPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 02:15:44 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EF1AD11;
        Sun, 19 Feb 2023 23:15:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QP6NBI+Gyd8qckqBFliOedbZ5nzAE0RXBTmAmtYm38SVWzDBAhfGTJuIxs5OTwLOwr5p61m4DBmE4KoE/y1uDInqpx1WDaQIBi9aKxy8IRBEFF6MKfnE97xB2HNNKFyUypFzAMJwV9Na0tejyvZ+gyk44bRJ1HNlixUyIbTtCah/lntPTVd/kTYlp4RWiBQsHBUp99kA4RZRynK43phSnkbA2tnqdYne5amOKOLJumwG3aDXK+WSO3ZOgKZ4TtaE+B+vJsyk3d30PGkpawpz5SJJYqkQj8DXBJRmBE94US6PGrEGxXZTAx8/dy7a3lxJdg4fkrDsF+FTQ8+pDPIH3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KUmQRAbg8Hny3zfMCjDgVV3LQSW9YGDocZ/NVbaQh8k=;
 b=liNX20S+WTmBpqZbfKduCkstvdw5WeeM1NIGBJ8ZUp+3EAss29ru8KqKEMPWGZtMAF3DdLTge1qg/RKNvuEOIcmOBgUYAc/Qn5N17sniZmMBJA9lpQPxhGlSGrLjc3TYhdrbAXZyag3TMAB2zhkN95IN0dS2c6e4jxZAhmVJmWUoZas9bXkIkauyh0YfHZ9urVU822jA7tdLPHCdVjmLW8JD81OI3VU26e2NSdB4PjPGUzD15bke6/4OclJE5tQPnijuvdpmLcSohg7AQbQVfmB+0IAhMghiZ0UZv1cavhNfE7KmD1zTEM559rAsplB47/TVLxZDAHMtyslLsv7zWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUmQRAbg8Hny3zfMCjDgVV3LQSW9YGDocZ/NVbaQh8k=;
 b=KXF32JC9VkTASjhKJke8Tfbk7eHGFgBe/bjuAy+3iFcq3tbuLOzi02T37IKQUMMVbQjkznzAF9x0zcN0pG4W0xcmeMvxBwJ7yJ9jJFBcovP7wH7qvYtu8Y7b2G77nJPcP2jcRz3oInYcW4fENwBxl1/RQFqRIbY2uO2zPR60LYHwb456z8JqWtrvUrCvLJrw/uUjW+JlgKtUVaacDLfHUceGmIyIuQbRkjJWSxxjr99oDfNHeQekLkIvnsP5ntOOK9TTeWGQFZsfEzztFpJkHDhPujgHRS/WLS2gRwPrAMDMpXTtMWSlB0rdAylTV2fa7F5Pwc7+UQ8rpITVhlSmzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by SA1PR12MB8120.namprd12.prod.outlook.com (2603:10b6:806:331::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 07:15:40 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b%4]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 07:15:40 +0000
Message-ID: <c8fcebb5-4eba-71c8-e20c-cd7afd7e0d98@nvidia.com>
Date:   Mon, 20 Feb 2023 15:15:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v3 2/5] vxlan: Expose helper vxlan_build_gbp_hdr
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
References: <20230217033925.160195-1-gavinl@nvidia.com>
 <20230217033925.160195-3-gavinl@nvidia.com> <Y/KHWxQWqyFbmi9Y@corigine.com>
 <b0f07723-893a-5158-2a95-6570d3a0481c@nvidia.com>
 <Y/MV1JFn4NuptO9q@corigine.com>
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <Y/MV1JFn4NuptO9q@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0130.apcprd02.prod.outlook.com
 (2603:1096:4:188::8) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3835:EE_|SA1PR12MB8120:EE_
X-MS-Office365-Filtering-Correlation-Id: df32d6da-4b4e-4170-034d-08db1312457c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s+gY0sTutw3LoSiKBtWbLn1FXPJt4PltMaF7ITOiP2AbVFmNzb0uiFwIwXg1090sRmVvPpvsntj9XcuWgJYNxVBNeGvy0NPlX49MmsivE52lllqbsw2koNgwVI7MG/HDEJc4WAubWDVAq1Fl4IUauKvAKetwpGcfkiiG1yh3N+cViS0MjqVEMG+QxxNxK831X4cQTORdv7360nRPs3XlkDbZZnPVcujldMPuuE7BG81I3slGYjR9YBM48DXssueWrhyzO2SUfqLp2b5Vdx4heL8qj0+uPIa8hkaJv192xvo6eKdpFlQ3vsVqGFoYYwE87mEqwO+WJzBC0E4wrLHFaZ41rmy4AYbSgI5+6EzqXiVnOuuy8j0nlzj8uM40WcG3+SKe14Hk0nnKHcBinPc/LoSrr50e5RxLIl9J9bAMS8qqY16x4WowgJ1jh6Ssmb+fapVPp8s0cOSQ3RPEjT25XYOEob/UA+Zbjj1MMJZzV5X3+gww36J/zRXFYw88Zn6p3zdhYIndy+YKHnpExmzCzU8Ca23EDkMD+VlLi5O8samQMysGICcg4qWzkT6SCR5bOK4n8V8efZR9gfKCy3jwTsyN4M4aqiD8V82D3KlBNgIgVNFtCn0LxKrtNO7nmO1KgFOMZspNVU7PWPNG03bnym7YNhM63+QGLPgGnAni0zm43M//GZgHjKDmrWIYFJSAf8ITDWUVHkJLJGH7MCvdpu36CDExErvFjuc9J4aydm0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199018)(86362001)(2906002)(31686004)(38100700002)(6486002)(6506007)(53546011)(6512007)(186003)(478600001)(26005)(31696002)(36756003)(66946007)(83380400001)(66476007)(66556008)(6666004)(107886003)(8676002)(41300700001)(4326008)(6916009)(316002)(8936002)(2616005)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REpDUG5xYk4ra1VKZXVLSFRacndVdTl4RGQ3UTd4MUx5TGN0bHQwRTR6OGJE?=
 =?utf-8?B?ZDRzT3FrcmY5MW5NYUlWM01hL0NuZ2pKMjVEUE4veXJpS2YweUEzT2RKNjA1?=
 =?utf-8?B?NFVFRzQrVHpjVm1kMVkyNU01S0VVNytIVmpTOGJRbmJoL25VK2RRRkFVOFFj?=
 =?utf-8?B?Rmg0amFSR0tqVnVWNFpQQzh2N1dlYkgvRkJKZDV2ejdqSWdJWnhkbzV1MUdx?=
 =?utf-8?B?VmM4TEJ3M1RkejRFSnJiNGpnVlhQbXNOZ1RqQ2k3bHNQdERGUEg2S3RvS0hZ?=
 =?utf-8?B?MHVxVDd2YmxXN0hmdWN0QVN1MEMzbWZiUW5sK2VCRDB4S0MwdEVPQkhmUmNo?=
 =?utf-8?B?ZUZzTmEyMmQ5UGtjMEUvbm0rR2pSSHVIVDdDcWpBaWgzZExaNHpxQy9HV0gy?=
 =?utf-8?B?bXA4SUlucFl1KzZxTGZURVd1anNoUGp5MEVuOTgycklFaU8vTUNETFVLQStB?=
 =?utf-8?B?ZFZ5LzJvckIzbWpKckpRQ3lucnczbGY0RUY4aDhoSW1oaEVjY3dhdEoxMHBQ?=
 =?utf-8?B?OE5SUmdCVjRRWHBseGRFcEdmVmdRWHAzMTlhM1VmK0Y0U01kRE9OU3ZJd0N3?=
 =?utf-8?B?ZWhxYVVPL0dEekhNU2pQNHZTM1l0clZkTEFzNHZDT1hqSDF1eUt6bEJpWnFl?=
 =?utf-8?B?NnpmZlVhL1MvY1Z1bmpuc3lCdCtmTWRmb2VPUVhuU05IaWZZazduZ1FhbFRG?=
 =?utf-8?B?Sm5VeElERHZzZ2gvVldiblNBemo1SlNIc1A4ZG9DT1lFYjd2bmt5eUh1MWor?=
 =?utf-8?B?UWdQQmZXVHdGQXpob2hoeHRIbDBEQkFROUlGZlp1MEhVRktkRTRwYm5MdFAv?=
 =?utf-8?B?dk84QW9tZW82MUQ2WkNoelF4Z2dUM2l3ZjJ1MFp1NUd2emUxbm83QkJUUTk5?=
 =?utf-8?B?MmlBeXQzMEpucDNqcndQYy93Q3VQWW0zS3hFOHlERmlySStwei91YWRrMGln?=
 =?utf-8?B?ODRKeFpYcFlTTnN3NU14NThWUUhBbStVMHZaSWhCWmdDWFJGNGlnV1ZvOXJo?=
 =?utf-8?B?ck5VMkt5alBTUXdRSUthbVBQeVFZMGgwOThrRm5YVWd5cUZZNXd2MGdPQjBQ?=
 =?utf-8?B?dStMc29kTG5VeENsWU9FbWlpdTc0WlpvSHN0ek1ZSmNtakFodzBzWVN3MU52?=
 =?utf-8?B?aktrTUdxTWNCUC9aR0dIaS8wZEJyd2hnWkpsa3ZwR0FrVitURE5JMWgwQUVM?=
 =?utf-8?B?SzA1Z1duQnNzaHNWUzJUbUZkeGdOTWlzT1JWVEF6ZzVKT05sSFNRb1MwZ1Mx?=
 =?utf-8?B?Nm5tYXBvNk1VSjhTQU5wVEJVS3M2RGRZTWM4VXJSZlorUkNYQWgybGxnd0hj?=
 =?utf-8?B?S0NTUDB4TW5nYnBSRTNZb05CcSs4azhwTGg3TnVyU3NVcC9McG5CY1BJWFhS?=
 =?utf-8?B?T3RrRERGQXc2TUNVL3owWmpBcGplTGpiK3RlaURnWGtNL3VIUW53MkplR2RC?=
 =?utf-8?B?S2hPc3NzSVR3SC92dHUwdFdFOHcremxZN2MrSDhTdW5kanJ1UVNNdFUzalFj?=
 =?utf-8?B?eFZLTWcrcVh2OUtUdWpONkpmZFgvalM1NE0vcEJibExOdzU3SUR3Um5XZDA3?=
 =?utf-8?B?eFJMalk3VjJOczFUVDBhL0FBQmRkU3pyUGlBUmNnMnZvSVZ2Wm9ob1haRDZq?=
 =?utf-8?B?YXhhVzQ4amxxWDYyV3dGdEpkcU9NWmswa3Q0SzhZK3A3aXFZUzMvQzgwbHY4?=
 =?utf-8?B?MkJSdXV4c1JmcjdxUGhVVXIxdnIzeHluYmFBVUVKSE1xRTVLMkFBQ1hibzhS?=
 =?utf-8?B?b1FqWmhpSjI4bzFNaUlwSTJ2clBOYlV1dHdyU1l6d2gvSnlJU3dCRWtvSm9v?=
 =?utf-8?B?djk3bzh6dFlvazlCZEtaMzhKdDF0QW8zVmZleDN4dVptUmpFTEZEakllaERX?=
 =?utf-8?B?bnN6SDlpeUJXVXJOaERCeWRaYkc4MTk2Q0lmSjZUVXpCOFNDcm1pRlhsaWxi?=
 =?utf-8?B?STZ3VkpVMXZDSTJaSEM1UDZRd0Q3R0FOdXczV1lrRnFYYk1tVkhKR1lBQ21p?=
 =?utf-8?B?MmM2emVRdlN1aDBTZWJTZTVrSUNLQXVUY0lnTDdzK29aNTRCZEczTDZNeFc1?=
 =?utf-8?B?U01TZVc3YWE0eVdrWkkraEdjbmtUSVhRWWdEdnFEL2pTRFFmZ3IwUFdJMFB6?=
 =?utf-8?Q?jtMT/NmOlw5lPoJzS1BhSUozA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df32d6da-4b4e-4170-034d-08db1312457c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 07:15:40.1182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MySNFBFbtCrNGnFue3be+KTf3b0iI4GJmej/GgcrhMB+GxgRaGF8rqoavLSb41b7eC7NIQjZlbhJXS37mkPbpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8120
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/20/2023 2:40 PM, Simon Horman wrote:
> External email: Use caution opening links or attachments
>
>
> On Mon, Feb 20, 2023 at 10:05:00AM +0800, Gavin Li wrote:
>> On 2/20/2023 4:32 AM, Simon Horman wrote:
>>> External email: Use caution opening links or attachments
>>>
>>>
>>> On Fri, Feb 17, 2023 at 05:39:22AM +0200, Gavin Li wrote:
>>>> vxlan_build_gbp_hdr will be used by other modules to build gbp option in
>>>> vxlan header according to gbp flags.
>>>>
>>>> Signed-off-by: Gavin Li <gavinl@nvidia.com>
>>>> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
>>>> Reviewed-by: Roi Dayan <roid@nvidia.com>
>>>> Reviewed-by: Maor Dickman <maord@nvidia.com>
>>>> Acked-by: Saeed Mahameed <saeedm@nvidia.com>
>>> I do wonder if this needs to be a static inline function.
>>> But nonetheless,
>> Will get "unused-function" from gcc without "inline"
>>
>> ./include/net/vxlan.h:569:13: warning: ‘vxlan_build_gbp_hdr’ defined but not
>> used [-Wunused-function]
>>   static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, const struct
>> vxlan_metadata *md)
> Right. But what I was really wondering is if the definition
> of the function could stay in drivers/net/vxlan/vxlan_core.c,
> without being static. And have a declaration in include/net/vxlan.h

Tried that the first time the function was called by driver code. It 
would introduce dependency in linking between the driver and the kernel 
module.

Do you think it's OK to have such dependency?

>
>>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>>>
>>>> ---
>>>>    drivers/net/vxlan/vxlan_core.c | 19 -------------------
>>>>    include/net/vxlan.h            | 19 +++++++++++++++++++
>>>>    2 files changed, 19 insertions(+), 19 deletions(-)
>>>>
>>>> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
>>>> index 86967277ab97..13faab36b3e1 100644
>>>> --- a/drivers/net/vxlan/vxlan_core.c
>>>> +++ b/drivers/net/vxlan/vxlan_core.c
>>>> @@ -2140,25 +2140,6 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
>>>>         return false;
>>>>    }
>>>>
>>>> -static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, struct vxlan_metadata *md)
>>>> -{
>>>> -     struct vxlanhdr_gbp *gbp;
>>>> -
>>>> -     if (!md->gbp)
>>>> -             return;
>>>> -
>>>> -     gbp = (struct vxlanhdr_gbp *)vxh;
>>>> -     vxh->vx_flags |= VXLAN_HF_GBP;
>>>> -
>>>> -     if (md->gbp & VXLAN_GBP_DONT_LEARN)
>>>> -             gbp->dont_learn = 1;
>>>> -
>>>> -     if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
>>>> -             gbp->policy_applied = 1;
>>>> -
>>>> -     gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
>>>> -}
>>>> -
>>>>    static int vxlan_build_gpe_hdr(struct vxlanhdr *vxh, __be16 protocol)
>>>>    {
>>>>         struct vxlanhdr_gpe *gpe = (struct vxlanhdr_gpe *)vxh;
>>>> diff --git a/include/net/vxlan.h b/include/net/vxlan.h
>>>> index bca5b01af247..b6d419fa7ab1 100644
>>>> --- a/include/net/vxlan.h
>>>> +++ b/include/net/vxlan.h
>>>> @@ -566,4 +566,23 @@ static inline bool vxlan_fdb_nh_path_select(struct nexthop *nh,
>>>>         return true;
>>>>    }
>>>>
>>>> +static inline void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, const struct vxlan_metadata *md)
>>>> +{
>>>> +     struct vxlanhdr_gbp *gbp;
>>>> +
>>>> +     if (!md->gbp)
>>>> +             return;
>>>> +
>>>> +     gbp = (struct vxlanhdr_gbp *)vxh;
>>>> +     vxh->vx_flags |= VXLAN_HF_GBP;
>>>> +
>>>> +     if (md->gbp & VXLAN_GBP_DONT_LEARN)
>>>> +             gbp->dont_learn = 1;
>>>> +
>>>> +     if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
>>>> +             gbp->policy_applied = 1;
>>>> +
>>>> +     gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
>>>> +}
>>>> +
>>>>    #endif
>>>> --
>>>> 2.31.1
>>>>
