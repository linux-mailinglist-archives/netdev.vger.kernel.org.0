Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1FA69C8D2
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 11:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjBTKme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 05:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjBTKmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 05:42:33 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101C4CF;
        Mon, 20 Feb 2023 02:42:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nqHgexgaDrch3kZEDmveSg4XvCRIX16m0qwnZd5QDhe9APMXq/t9RrBUR7W6MwqeaoaYuAyigCkBrtxd4iwm0ASYuCYUXM3Ru4mSZJtLtmYWFerte7Kqfidi1zw+JVVgq50F41FgTg7ch+G8kIv1KXItzZshVmT8WaUOPLG7aFMBemqxWIzy8Nxob2MCOIa27Pqd9ELSMx9kFFnQhmKRejr0OpDFKTGXXfLlGLxlaN0KbqC3Rs+tVt3C9FIkhNXqOFC/ErRtdTN7eqXe5ace/7PF30bOXsY84jDKQk68WypVd1t07FC4y6HDBpNEq9OcDtbrz22Y/ccXMdXhv64rEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ThTyLQ4xg4ygdHg5bCFXWTXEd/JPAHDencMxN9mYb0A=;
 b=j2fp5v0m+Tk3zEKgp5SC+XBpsYJIiuUODENmAgKzPl2x3ZtgRw97l4n+7P4jKIVRiiQefQEtDQnC/zfqwVZ5LG2z4HOnDBb6ZfP9nUhXUnoUP9QkiHS9DHYQ61V1cUYMpfKqrJYv31T2y+9Sxc6M2YaLY4tJKF4l0cQcd1n1HBZwFI+nN01NPQndqMj3v+omTac0zibkyyu98HvmaGIs3vB/X3rxfI50r7JXmiLz19DIlu5X82j/eR6fYVXLFOeNawB1FTsNwfR9hTSKnZrRdnyTUEpyfgriZ4QMJY3ki/AtiCJqCcWXjI1TV3ag4wkOjhjsKaHWNRkJslH9bjkFhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThTyLQ4xg4ygdHg5bCFXWTXEd/JPAHDencMxN9mYb0A=;
 b=GU97yY8kKtFjzHOgnGSmBWIWLa3wvGhHcSmoKMj6bdqmKQfPU7jr1a0N4yon7c9NY9HlS+99G5n9mu9ov4nR0+0sKmDNxQ7P1r/iiY78M7NA6oqgUc5I3y4ZKQBbdlip2jbvRXs0oF6bERd+Xzyt9Kzq5Oi+4Oj6KPH/C9vihfK2Lo7De/KuMvWFKQKMy5zc7/RdCGC6Q2Bn8rX1CLCrBDVdkOsNahqCakjyAcRnTtT32eoZ2EAisxf8j3PPmNSOdEqU4z2IUGTyPWjmjDhOM2Fa9ArJHzCxCddwQHrVhvPo34zO2JWbzIBBWkcICcxyGwMewrt5h4Zt3MK0HQVGnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by BN9PR12MB5354.namprd12.prod.outlook.com (2603:10b6:408:103::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 10:42:29 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b%4]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 10:42:29 +0000
Message-ID: <021dd47a-03e6-6d27-af3d-c7ff179fe0bd@nvidia.com>
Date:   Mon, 20 Feb 2023 18:42:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v3 4/5] ip_tunnel: constify input argument of
 ip_tunnel_info_opts( )
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
References: <20230217033925.160195-1-gavinl@nvidia.com>
 <20230217033925.160195-5-gavinl@nvidia.com> <Y/KGJvFutRN0YjFr@corigine.com>
 <Y/KKiNHnJ5vHqWrf@corigine.com>
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <Y/KKiNHnJ5vHqWrf@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0187.apcprd04.prod.outlook.com
 (2603:1096:4:14::25) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3835:EE_|BN9PR12MB5354:EE_
X-MS-Office365-Filtering-Correlation-Id: b2b78153-c259-4659-2213-08db132f29c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GrgkiepMtXnBcoHmbOBtl3rk0UzZANfUAg2phK8QikgdDQpTDiBOcR6sggWPhZEzxxRX5dFkAVxm9blqOehEn5Y4U+L8bfCJJWX7BPnGRKMbF7CQrZLcjrCPvG74p66Ur+1edzWomx4MvFjvggsAV2469BmI5iySbS8qZGp+Yi6m9/vxR7DfRcvL3yLEWDS+AjIc03FIMxInvQkcEO5ipGbGE3rQ+BPAcgk8tXI1s0/lGqWo8f6P6UwkdLfH1F7pzUKAdzavvNQo8TAMlDkI9sAf405Ac9SEUAhzLB2MUbBWTnP6OgjzNA1wJ4X+57nN+rsJdc+uNOtlIfsrdoNQ/KzMj/cgBwi+V0fxRG6n7ZItX8DncJ9yOQQQfMYtqz8ezwKpK08QTSaBApzXeGNcdGbHpUMBl25at1axOIV4Qw+5GOLX99X5rD4hAQ3YhvofZLBcO+vZfJgnCwwCOxonlvITRF7xKWDO2XThlS6hfNAMxfnuNti3oLFZQGrPNL4QdEk7cR+WRxKNd6/HN8lstp0s0EZ1TGJHcwsLEsTQDxH/2DgFmRc26D7b34rvSiiW0R1ZCqZvPFH3atpp1cfm+ETfAi5Q+N5Wt8A12XGlJ5K9ckhnCAece5opacCmq2lp0Xa4r8VIl0/6f0K9HJpcP+od/YlVD7ueizL+bt3G2hAr+Yk3cCOqNHowU0KNo/tk3vYQEt5wy6Siz74sa4GSEL8X6FHG3nqhrBlfCInOIAc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199018)(110136005)(66556008)(316002)(66476007)(8936002)(41300700001)(8676002)(66946007)(6506007)(4326008)(6666004)(107886003)(2616005)(83380400001)(53546011)(26005)(186003)(6512007)(478600001)(6486002)(36756003)(31696002)(86362001)(2906002)(5660300002)(7416002)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0tvdXNLRHJ2UkJjMnVacElHL3NmQ0RTZ0xwNTVxeHJXektwU2ZRK20vT0Vw?=
 =?utf-8?B?cWQzTzJvaDFScXFKMnF6ZStGMUNLU3dLS01ITUt6S1pVc09ZQUxUYmx4WFNQ?=
 =?utf-8?B?cnV6ZFcxcmtMRG5ibGpjckxNUHM1WXg3K2ZYQTBhTUhDcVBtejV3b2craFhU?=
 =?utf-8?B?c3Z3NklyNXMycHp3V2htdXRsRXdQcFdVWFhjdGJUVll5K3BnYldhdjlJQzAr?=
 =?utf-8?B?RjZWODlsd085eTZ5UzMwZktuNDkxaTBZeGZVM3h1WjI2V3pER1hIWXBzWlRy?=
 =?utf-8?B?bjBBWlV1WHdLK280U0JDWkNIY1RsVmhKdnNucDM2cmY3M09UOTdGRlZicFJC?=
 =?utf-8?B?Y1hjSTBSdmNkcHJENFFINkV0S1FlYm5zbkg4V3BnUUJtUkRTSGNYSGQwd0hy?=
 =?utf-8?B?MEIzY2kvMjg0VXdySERZbnZpM3hNMkpTWGF1Z09PY2pRMHFCcVBYRDJRZHBS?=
 =?utf-8?B?TTlEUlJld1VEQlhVV0dFMzA0alJZRE1wZ0NWeTYzZW54VUtZeGFmQStKN3JS?=
 =?utf-8?B?dEFaVXdHbkQxR1kzcytjMzlXT0Z6VU0wWFVnYUdqNktPd1haalZmelBGM241?=
 =?utf-8?B?Y1Rid3U5ODlmQ0pFd2o2NndyREp0UEN0WXV4cSt6dEF2WlBjbzNVMCtTcHox?=
 =?utf-8?B?MHJzYytaM0hEZEdOcVhhQkVVVFhPRThHRElLTk1xVEhzMmNzZVovbW9BdHVw?=
 =?utf-8?B?bmZjbzl4MVNWSSt5Y09JcWVhZFdCYjNqS1ByU1JNcHczNE5xTkRDSnZldXlp?=
 =?utf-8?B?dndCdmxmZkIrcVB4VWI3NWFDVlhxZ3BORiswbklDdTJ6aWx0NnU2UUR1aUdx?=
 =?utf-8?B?ZHBZNmVORnYyMEdPNitSbzB0RmdCMG5vMUZvcFEycE56TjFLTklqS1J0ZkZq?=
 =?utf-8?B?ZlNZMUF4cWZvcHd1Skl1bmRUYzdINm9EeCtYRXUvY0kvaTR0ZkpjQUZ6b3FK?=
 =?utf-8?B?MjhpdkE0MXo5aTJUaGVpbXc2a0p2a0pEUFRZM3Q4NTc2NjRwTDJ1ZlRzN2tX?=
 =?utf-8?B?NUxEN1R6UFQ4eEpSNzhLWE9lQlhJcWZHS0FMM1UwOU9MZUxXTjlvY0szU21S?=
 =?utf-8?B?NTFGalczeFd0eHpsd0Jwc1J5M21qR2ZOK01BMUpEV1h1SUsrdzJkaVhpendj?=
 =?utf-8?B?cEhsR2c2K2ZKV3dZV2FRZHhSc2FGZjJjMzQ3d0p5SEhjeGtkTlhmdUtCTWVo?=
 =?utf-8?B?VC9QUVdubjM4RFNjLzdGV0VSNEVIVk5TazhBK29BNDdpaGx5N3B2cTFXVTZx?=
 =?utf-8?B?NTM0ekozUXhrbHN4MzI0N0xiR0MvckF1aStGRE9vQkxpMEdMY1dSSDdvY2tB?=
 =?utf-8?B?WUxTYko2RVo4UjNzVnc4ZW4rNitFRnJxd3dMeVdzaFpuc2RMenNXQXVTdGdq?=
 =?utf-8?B?TC9CNkxFNzhZbzFYdXJKemw0eHBCbUg5bzBlaHpvbmkxdXBXK0hFVVB2bjcr?=
 =?utf-8?B?MWpIL2lhbHVVZHBVVUVTQ2RQNitnTGVWNlZOQVBuRGgwbjNGRkVnd3pXa1o2?=
 =?utf-8?B?Rmw3NEVLdkx2R1BXZS9pZU5Sc2loUG9wQk1FUjRnd0x1dDY0djhnY1ljYyts?=
 =?utf-8?B?U1JjRGJ4TVlDelpYZTlWN3hBSDBIQWRCdXZSVEFSeEU4MmFmRlJibERWcFhI?=
 =?utf-8?B?bGg3a0lBOXNYVzFtWVJUYnNvZmhtSUhtWEMxTVhDN1p5WmNpdGpmSnJTZGph?=
 =?utf-8?B?Ym5JZ2xycTdTLzJJcTZ2RXcrVnY3czlrdWVEbGhSbC9NcjN2YmdRdmtpcE5N?=
 =?utf-8?B?Wldib0ZnelByYW5VRlJLY2hINmtJUW1RNlRSeFBQcW1udFV5L202YXNZa2NG?=
 =?utf-8?B?UGRGeGpRTTFOODJ4M3RVUVZkNWwwaHUvU2c5ajF5RE5JRXNTek9TWjNPYk16?=
 =?utf-8?B?eHVVY0RGY0NJMkpXN1FJSHl0VzFlZW9SNDJVZHYyY2htQzl3S09wb1JiZHZj?=
 =?utf-8?B?TGpFdDljM1p5NWVRNlRXV3ZjWGZHSms2VlhPOXVZQmV1LzIxQzZyNHhwMy9v?=
 =?utf-8?B?SElXRmtUM1VSK1BueHZwWGc1Qi9OY0VJbFF1QUt5RE95M2VDT295dU9EeHhy?=
 =?utf-8?B?NVlWRHRBeEhIeGIzaWVBaVcyZWMwclNnWnZ6UFRkWjFadkxIS1VmRVRHOGtK?=
 =?utf-8?Q?uHPy/pUADJAcz73qZKVboZFNq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2b78153-c259-4659-2213-08db132f29c1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 10:42:28.9845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YLlgJMXPTAWXYTDDi3Pc/mVps3ZU6lDWsx6RkYYKqop2WfxdGWY9VbuI9087BbceyIXQTm3+sLP9e4DaCjUs+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5354
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
Hi Olek, any comment?
>
>>>   }
>>>
>>>   static inline void ip_tunnel_info_opts_get(void *to,
>>> --
>>> 2.31.1
>>>
