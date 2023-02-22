Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F3D69ED08
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 03:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbjBVCsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 21:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjBVCsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 21:48:11 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E980B30EB4;
        Tue, 21 Feb 2023 18:47:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kt4OCZvu9U/qWD3nkBCtayZFQQGva2XKDxiFbXIgXevatT6NihdSa1XDkHP2b6xz19E5uwXGwYaBTW55mHsuRn7K6F9uuy5Y3BCSQ/92Iu7jo3P07q/02ObzJo51n6QvFXlxivOB6f3mXTIcyiN+JG7AheoAChiSd2sbTz8BCCBfLDSfY63gsbGIKLT0bgjqKatVMEJp3j5Tw8hw3tQGpHo7yC6M6pvA9KxOaA65qPjFKU8fH5ANm4MoIDajhjBmOQwdksmHaMzYzwusQk9F8aXPrt3nwJIVpoZwBUlL5VXk0wdoy3sI1lfld4U8y+C+XlDDVysNEW99d2uvXnlaag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YNRDE4WDToc3dyrXk1ptYjkxFTLrHme53J2gGE7kWKM=;
 b=ebvRnqfsXzvRaw6rAVk69NwI4dJtTsTmplvPfoJsNXLWetRnoON1jKJAKfdsYI2CXZ6BWTe7J4UpNlfANfL4zCPHDOs4OS5EojpcDTNoZ21dDjlbsn4FGunVJyJiB9O7YaXEOpLviwEZfKP+A2CCswm54fbW2D6xOU7MnzAAUHIkRypSA7ozE5c9LerWe4KS7mWT1F7VI+roVWM772yzXuoTCaM5vWh2NHKCVwqQ1+tnyTynzFaKuNHs4Hw3AbJf/lBku/+h8OlRotvsFzAqnqaf3MZYOsns1Yx5ihclNYAXltAshRU8BhamgSvIPOR/mN1fI8RIA4N07h47kkhP8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNRDE4WDToc3dyrXk1ptYjkxFTLrHme53J2gGE7kWKM=;
 b=Wr52J/+0/DtUVYZjQvRhMy8qzig9Ep72FmsqXnYtmlIdVQidvWl7YfVA7alSLEyCDwlnFt1N021ApOws1Y5hAnhY3WhrRZlkSth8y8eluGXYm4MnPjWXCvj9hiEDLvurQG3+U2MK1HcWcJSaDeIdlmCjCPDAkxkqVKTlPJy26Pk9ztHw5PMDqe3lmc4fYkuWzAyu1q4L93Roam+6LPVBYtfR1O/Wmpg3l0rrVznpdu1j33vfSIKJOPIb4WX/a/okhUJU/cpm+DMdqT4QZE539hc/JfWgfyj53LxAE2rvr3Amnp3GPFUD9ZQUlr+gOUVb4SexIdMmPMwLIi4ShKl13w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by PH8PR12MB7279.namprd12.prod.outlook.com (2603:10b6:510:221::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 02:47:55 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b%4]) with mapi id 15.20.6111.019; Wed, 22 Feb 2023
 02:47:54 +0000
Message-ID: <7b791f3d-6ddf-fbd4-6b09-daf1833a06fe@nvidia.com>
Date:   Wed, 22 Feb 2023 10:47:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v3 4/5] ip_tunnel: constify input argument of
 ip_tunnel_info_opts( )
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
References: <20230217033925.160195-1-gavinl@nvidia.com>
 <20230217033925.160195-5-gavinl@nvidia.com> <Y/KGJvFutRN0YjFr@corigine.com>
 <Y/KKiNHnJ5vHqWrf@corigine.com>
Content-Language: en-US
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <Y/KKiNHnJ5vHqWrf@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0077.apcprd01.prod.exchangelabs.com
 (2603:1096:820:2::17) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3835:EE_|PH8PR12MB7279:EE_
X-MS-Office365-Filtering-Correlation-Id: 7841b4e4-581d-4400-d4d4-08db147f324f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ilW5QpRMUPuRmBaSF331nHJ61FhAK1Eg4meOnZhEYBB83aHs7uMUw8sUK+x9DfOhQkM7nzbmW4lomBww8I0fnwElZIjd5Wo0udBvDdFxhmxOJCyI6DpUO0l0LR/bLnur34FLtk5xZbpB7QcLPvVV8SEpleCL7QtoftRly7x2ZUV9oxDeKDlC41kuhtRRdPb0kwNLibbCy/fnc8sgkgIuc24VQKr1F/ztIsLK+HTuE8W7jbPjCkpCf0ggJAn7J5dk0xWZ+UnzwbZ3Ok5zSBX8BpmKXFIhAAyYsHdlJ3BG/1aVF58SEHol+1MIJt56WSpSdIl5AGjuQ0P0PSO6KyMtLzmAUgspUwkn2/mzY7OyBLwPEaatmby5AhPRbgeOZBoVCDH1Az3r4L1VpgebJedYMaywBYX19msbkHJd/htx7mR0+dfwkDa5fmde0JgPtAmaSxhhzpk3pvq47MjmkFF/zFGRpMLBcZJgtRQRsZLV+7OaSUSCw9M1DAqJg6NvvnK3Xo0zvgOWMk0tvPo7vxeEqs8CVd2TslWyovI5VSJoXhUACGMJuYxTMyLYuiL5WNB60wXCuha70JspwecevCTysPk8NvWVbqiNzTYtFvxrC7Pan67an+seSO5L4uGAo1/mgctOY8tEjX/uxziCI4ZIXBUH8GE7ge8s4CKpHTc2j4bDn75t3tsduCPEdXi9JPmPxwth7thBvLnyIA1a0xWa3MgtXGHPrdMks0QOCwKMM5I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199018)(107886003)(83380400001)(6666004)(66946007)(66476007)(66556008)(2906002)(31696002)(316002)(86362001)(478600001)(36756003)(8676002)(41300700001)(38100700002)(6486002)(8936002)(26005)(186003)(2616005)(5660300002)(4326008)(6916009)(6512007)(31686004)(6506007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajBGUllYY2p4RlFVL015bmZ6eXd6RVZ3NkllOCtOSlFtTVFXa1Z6U3lLVFh3?=
 =?utf-8?B?R2FUY0hJLzVodGd2SjloY0xreWJZcTY2TGdOTEVjZ2VhODNXYTRDQnp5YWZy?=
 =?utf-8?B?TE5aYzM5Nkl1a2hPUEdSbE8xb1lLKzFuTi93OTdBdnV5NjJoTjg5VHIzN284?=
 =?utf-8?B?dUhNUThKVWlETnkvVER2NENUdVlIbjRueHNvY1p4Zm1BRUVzVFk5ZkF4Q2FI?=
 =?utf-8?B?MVR5MVc2b0ZxMmk3eVVsWUk4MGtScktNcWRsV3VseFFvcVFzc0gwMDRVeThY?=
 =?utf-8?B?Z2hmQWxhTVFhdWFRZ1JXMjF5QlJiRGNlZTdVaGNhNGJCbzQ2Q0ZMZTZtZUtQ?=
 =?utf-8?B?ZGIwU24rcXg0UHUzQTVmVklGRmZGTzBDSXNFeFhiR1EyYStCdUJucDJyTFhF?=
 =?utf-8?B?WmRHUnFlSStYU2hDVGgzaFJEbHFLY1RUakgxR25jTUdSSVdTR3c5YTl3RWND?=
 =?utf-8?B?U2QyQlYrbXQ3ZElXV2J1WkpuWGRiSW5JcWRGb2RqQ2VwS1lMUjNScHJaaUVz?=
 =?utf-8?B?SU1DYUxWSFJoZ05nVmg5ai9lZDFhdkw3NVBldEhEVklKOTRMTFlMOHhZZzFG?=
 =?utf-8?B?Qlk0all2YjJXZ0Vpb3VFVUhDSW9RVHVQb2VMK3hyVU11YVhjbEhDc1g3K2d3?=
 =?utf-8?B?djU3cjVudnJBYUVRczJRVlB6RHhQeDFCWEhONDM3aTFRaDBQWHNsSFdLaDdQ?=
 =?utf-8?B?QlBTMURaMnBmZnBLN0ZmZXoyZ281Vzh1SUNrNGZUcDV5a0hQQkdxZDE4NGdY?=
 =?utf-8?B?NU1kMzBXdlcvWU5VOEkvVDNJVDdwdmk2TEh3K2ZDc3pYSUYxSW5SdHcwK2lM?=
 =?utf-8?B?NGkvV0E2TDVIVlc5bTRoYnlRREM5TDNmRjVuSllnTUwyVVVtemJOV2ltM3RZ?=
 =?utf-8?B?bW4xbkZjSHkvV1hJMm9hN29wRXBKZmtOaEt2a3VCQ0kxakJ3bG93NS9OZzdN?=
 =?utf-8?B?VHNPYjJZODJDbkVmVVJYNk1CeURwOUxFR2dXNG95V0VkVEJDaFMxSTRmRk0r?=
 =?utf-8?B?bW1xRWtPVGR6TE1DMzY3UDVBTG12ZUFDaXN4eGJiREVtSWV6dWM3ZlQxMklT?=
 =?utf-8?B?anBRaWRkVmIyQjZiRlV5WGRmTzQ5OCtVWWxMbmpCVk9vTjNNL0kzWGRXY2tR?=
 =?utf-8?B?cDN3aWhMQms4SEIzaGxiWUd3ZTJoT1k1MkVBN1FiYmJGdTJmaW5pVjJWSDNC?=
 =?utf-8?B?N0I4dEtNOEtYbjBIQnV2Mm1KOUdndmx3Z1l3VTg0TzR0MEdLY1d0bGtPRVRy?=
 =?utf-8?B?d1J0TFFTUENXZklGaVVya05MdEI1dEpRNjZObWFQN1cwbk5SaG5lUVVhUkxW?=
 =?utf-8?B?YW1lQlJvclZuK2d1VW5pWkJvVGN3NUU0ZDlmOURqdnpvdW8reStPOUQyMU9B?=
 =?utf-8?B?UTdEMmUyOXpyMTFhSndmUzBUNGpQcjNQenl2NDk4dzE2ZkxyT0ttcjVZSi9w?=
 =?utf-8?B?NUUvazFoS1BUWHZDejY5TXdIakhBYVlwUm1wQ2hlZHprY0NEZHUyeTBDYzcr?=
 =?utf-8?B?aU9QUlBaeW1xN2V1V2UzOXo2K0xZZEVvOTYvajhjVHVOZy85NXdrZDI3SlJq?=
 =?utf-8?B?aXVSdlpjVThocmVhRmllMEdWK2ZLZllhTHpoUWxWYm5yUlpkV1YwMnE2WnBM?=
 =?utf-8?B?NVl5UjVqTW5PajREaVlRVzR1S3dYQTR6SVRJWFRwZzJna2RnR243SFRhOGdy?=
 =?utf-8?B?QmUzQ0IySWFjQ1JwYmVDTnRqbFlYTkdHQ1JraFVjRkJlV01BS3IxNi9JbC96?=
 =?utf-8?B?Q1ZMK2R0c3E3b1JuZ2JSTDR3NXFNWEljdjIzaWd6c1V1bnFLR01jcTNSaDBD?=
 =?utf-8?B?dWdXWjFiSmU2dUFIVVZ2cGw4dXlqaEQ3TUZ2Wk1YenVoOU13OGE2NGpkWExs?=
 =?utf-8?B?RGNmT1dtRVlFUkIrSW10aXVHNlo5U0VVcStQbHFUd2dPU2ZGK0lCUEFJaWlT?=
 =?utf-8?B?VTgrMnpFSlVkbWpzS2NqaVJLMDAxbjJxajVIaWltd1U3ajhOUkpta0NmVWVr?=
 =?utf-8?B?cTVUaVU3elBFdE1BMDRLMmN6eGtYWkFwdFEwdmNkb3JHTGhFT2lRak9NeFFS?=
 =?utf-8?B?cXE3SnNEaFY1NC9Ka0paNjBQZ1UzM0dpZ2FyZHpxazBtRW96MHF0alY4QjBH?=
 =?utf-8?Q?bj7c98OXJdAdls4p6qj/3MZkz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7841b4e4-581d-4400-d4d4-08db147f324f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 02:47:54.4613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g0x8aXnWB22Y5e/oL+dLReMtbtQOSkqs04Km8B4rmPhARXE9pRA85k9qzjTGZH3d/AktATCjZFgPFMVwr6LtAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7279
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/20/2023 4:46 AM, Simon Horman wrote:
> External email: Use caution opening links or attachments
>
>
> On Sun, Feb 19, 2023 at 09:29:21PM +0100, Simon Horman wrote:
>> On Fri, Feb 17, 2023 at 05:39:24AM +0200, Gavin Li wrote:
>>> Constify input argument(i.e. struct ip_tunnel_info *info) of
>>> ip_tunnel_info_opts( ) so that it wouldn't be needed to W/A it each time
>>> in each driver.
>>>
>>> Signed-off-by: Gavin Li <gavinl@nvidia.com>
>>> ---
>>>   include/net/ip_tunnels.h | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
>>> index fca357679816..32c77f149c6e 100644
>>> --- a/include/net/ip_tunnels.h
>>> +++ b/include/net/ip_tunnels.h
>>> @@ -485,9 +485,9 @@ static inline void iptunnel_xmit_stats(struct net_device *dev, int pkt_len)
>>>      }
>>>   }
>>>
>>> -static inline void *ip_tunnel_info_opts(struct ip_tunnel_info *info)
>>> +static inline void *ip_tunnel_info_opts(const struct ip_tunnel_info *info)
>>>   {
>>> -   return info + 1;
>>> +   return (void *)(info + 1);
>> I'm unclear on what problem this is trying to solve,
>> but info being const, and then returning (info +1)
>> as non-const feels like it is masking rather than fixing a problem.
> I now see that an example of the problem is added by path 5/5.
>
> ...
>    CC [M]  drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.o
> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c: In function 'mlx5e_gen_ip_tunnel_header_vxlan':
> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c:103:43: error: passing argument 1 of 'ip_tunnel_info_opts' discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]
>    103 |                 md = ip_tunnel_info_opts(e->tun_info);
>        |                                          ~^~~~~~~~~~
> In file included from drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c:4:
> ./include/net/ip_tunnels.h:488:64: note: expected 'struct ip_tunnel_info *' but argument is of type 'const struct ip_tunnel_info *'
>    488 | static inline void *ip_tunnel_info_opts(struct ip_tunnel_info *info)
>        |                                         ~~~~~~~~~~~~~~~~~~~~~~~^~~~
> ...
>
> But I really do wonder if this patch masks rather than fixes the problem.
ACK
>
>>>   }
>>>
>>>   static inline void ip_tunnel_info_opts_get(void *to,
>>> --
>>> 2.31.1
>>>
