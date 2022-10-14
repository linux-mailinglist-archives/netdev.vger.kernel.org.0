Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72025FEA8C
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 10:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiJNIaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 04:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiJNIai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 04:30:38 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2054.outbound.protection.outlook.com [40.107.101.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA75180264
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 01:30:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2ucaM/wcIwXRGpNOR/E9R+T2a3TEBVTqsJ0yTkmpDEw7vxQs3DkprsCCLOxKZgd04I1EpoOanWrDJqxfcFvirQR8VNBY5HWkak+JW33hovRt95KGubOBnWOhkftCcFKGOIGhDWnQzyuTalLauTOkmJaJEwhoVybVwIbM6Y1ZSiUeR+8GFRkkP4xptorArVmlgS7XeixbOtWDQAL+HFlEblJFDG5HGi++PNFwKPdJreRnnCz/sRtxR/wmnPv8+5DD7L7EtgHALPq55byFV3fBNsNypeTvRT2Oqy+Yxz9n7NROGh56Dw4DOZk87TubB7ynlneFEx+fX+AsxnTCHBSLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=34mtaRvemF7Qp3djCSQpZX7HWNAQbxphXXJnHjwHmCI=;
 b=GWFJBKXkZqhDLJhubcNhTYiGqT2ZGEQaZRt6bGp5fwfIQ/1L0VCl44RpR1gy5St6qBXeMEL/nULWKxVHyDtSMGnowP4hK1LfvvfAPb39W5wmoVmQRgkmnMsQWk63JnYkVq8+rcHXNcpEbwy/Mlhyvh6aMKOFGdqu7E7uvbdswsMttYKgDxzStv4BluAgn41fzWTTPZcpyxy8CYNhL5ELdVkUnNxthf5EpWbHZ8vNVAR+dP84ZF9zl6Ka590LSm5Pln86kWKLEXO1rn2vA/OIwVJFxBOYIB8iw3kN19ieWmyTPq1sZHL55Ub2978Itc88Obq3pScEZkYFpJSPrYi6jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34mtaRvemF7Qp3djCSQpZX7HWNAQbxphXXJnHjwHmCI=;
 b=RNumhxnzYi4DBimpibRd8VRYcXWInBlCNwwtJ+ElNFZ/4WvqTuf2F9dVYh32grOH5Gc82Iy7jvjbPL8pLHLO5RlfJH+eLbxrH2Yl47PR7sMziWY0Le4CccTGpwoQX5w8pzBJOsM2s+DE87EbgZjFLuGghOa/KuR4RlyZ0/SD+4M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW2PR12MB2379.namprd12.prod.outlook.com (2603:10b6:907:9::24)
 by MN2PR12MB4472.namprd12.prod.outlook.com (2603:10b6:208:267::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Fri, 14 Oct
 2022 08:30:31 +0000
Received: from MW2PR12MB2379.namprd12.prod.outlook.com
 ([fe80::2e7d:cda3:bb38:a1ce]) by MW2PR12MB2379.namprd12.prod.outlook.com
 ([fe80::2e7d:cda3:bb38:a1ce%6]) with mapi id 15.20.5723.022; Fri, 14 Oct 2022
 08:30:29 +0000
Message-ID: <e9ad936f-a091-e3ed-3e18-335bc0ff009e@amd.com>
Date:   Fri, 14 Oct 2022 14:00:12 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next 6/7] net: keep sk->sk_forward_alloc as small as
 possible
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Gautham Shenoy <gautham.shenoy@amd.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Chen Yu <yu.c.chen@intel.com>,
        Abel Wu <wuyun.abel@bytedance.com>,
        Yicong Yang <yangyicong@hisilicon.com>
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
 <20220609063412.2205738-7-eric.dumazet@gmail.com>
 <684c6220-9288-3838-a938-0792b57c5968@amd.com>
 <CANn89iKpaJsqeMDQYySmUr2=n8D+dyXKtK0u7hF_8kW10mMm1A@mail.gmail.com>
From:   K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <CANn89iKpaJsqeMDQYySmUr2=n8D+dyXKtK0u7hF_8kW10mMm1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::13) To MW2PR12MB2379.namprd12.prod.outlook.com
 (2603:10b6:907:9::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2PR12MB2379:EE_|MN2PR12MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: bc4d0b67-4a1d-4408-4497-08daadbe5a21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 45h2OvtpioEDHhoUacuWd4wAsyXpc7CNBTNxXqzZY6rQUEfUZkJ9qHrLSFQ1OKF7kZiEp3qbbcucwzT1lZDFQi6O+PGf4/hUV1puEXq9J3TZXCwRdQa90D3XOjTYZCu4j7g6UQXGDmHC58hno/fIJy/g9VL4w/KLSmcwoUjkZg0Irve1fQw38/1Mut83qcG6Qrk9A0FVv1ICfxZ8f2fX/3VvWPzC8bb8uBGXFZRnPYKvbZDSUxDLF3SDEzuZW1zMBV+KT2KBM6oxG9neHoEGHkr8l7fPGzVhQ1qBhb4FJY03gPBWFXAxxdXzuQ1Iv0oP5Oju9gqSZQhscycoG+dXciqZBi2vx/NFWV6/YZhRST1/dtVuSdIBPGFzRaLRkERgwzzsQNEhdplcajt54G6eQl2ro0pEv43Xjr+HM+p+gFlrz+bBatQIEyaNUgyOWXa2ClVKc0dvL6yEUQ1GU1mJS9zuyp2TmyEBot12SHBR9IdOzFQlRB+bsE5v1jbDZKedPkmqYLtExOgFHHHP8DYAn0XtIUEKoNiYZCq097BH8NmW4QHEvO3ASoHobqgd8UY9SsFdEwKz1M3cQxtGLgitzyV1envGiHwPKh4IexHWbyl9irPMxMX9zgaqPMxupAAYL1dAKo1LZE7ioR7QiRdoPEyynAYffLjI2/PN1yqGd2DNM+u8fI9RZ3q45xxElAYh5xC5YBuIOj2ig+6+86lmtKNV8FW1ZybQuZOAdNYnzXPoAbDkEWuupjCwJFOZyOqZyFpAX3t+KP08ZSzXYCvM6RK0T/NwL95+leNDpiaTlPm8Ay+gZUS6wLhUXUTXZVNE19dScMCrqLSPGiMUYOKAsWpd6aATaLonhPg4VhrqEYg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB2379.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(396003)(346002)(39860400002)(376002)(451199015)(26005)(31686004)(86362001)(2616005)(966005)(7416002)(31696002)(478600001)(186003)(5660300002)(6486002)(38100700002)(8936002)(6666004)(66556008)(6916009)(8676002)(4326008)(66476007)(66946007)(36756003)(316002)(54906003)(6512007)(2906002)(83380400001)(53546011)(41300700001)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDZsalEzMG1VTUwrY0RHM1A3eFA2c2Z1RTBDeHRYNG9uS0NwNmNVMHp2SkxK?=
 =?utf-8?B?am1pcDl6N01OYWJrMFNzNnMrNll6dUFaZm5lZnl5WmxsU0p2VmpuTWdyVXdt?=
 =?utf-8?B?b1g4T2RKYjEvOVBoQ3lVMjRqWGRibkhtVzlnT0RQRzFBM3pZMVhtTnNaYkNO?=
 =?utf-8?B?NldSZDdzUUtoZ1BuNVZMN2U1anIzeGs2cHR0Y08wcW1qNkpxWTVOa3BnL3Nt?=
 =?utf-8?B?eW1vdXExMWtGUGx2cFU4R2dUQVJKSFQ2a1FJUmVoQmVRQ3ZKd2J3Y1VQWnhQ?=
 =?utf-8?B?N2NlcVFYN0JJUm5XVXg2VU1XSkltWExTRFpTdDJhMEU1NlZBU2NSa0ZocXBR?=
 =?utf-8?B?MjdjNFY1NEpQOHJoMkI5T2JxcWdMVXozUGkxN1IzSXVPV2xPWkQ4R1kwbDBx?=
 =?utf-8?B?ZGlTeWZnalJieEhJei9ZaVVUVk5DTkZ5Q25UL3V1RXdpVlMyZlpTVjhlVUs1?=
 =?utf-8?B?Uk0zNEJkYnZRTDhnQ3JvbWxXV280bjlHQmZobEVUVXZjZlQ2ZE5IREw4Ykhz?=
 =?utf-8?B?ZnNmY3NvY0pmVFJ3Q2VJUklFdjBRQ3dQRWQra0JYa3ZBejNSSFFpeUlxdUcv?=
 =?utf-8?B?d2hKQ1pBZUxMb01Dai8raVRmR3dmY25yRDNDMzE3Q0RKWUgwbG1JdnhpbDFU?=
 =?utf-8?B?QmVteGdUOVQ5UVNIYlROS1ZiMUpNTHFlSlNxUzJJTFRpanRkTGZMWjNjaGVz?=
 =?utf-8?B?UDJ1Q2U3Zmo3YlRuR3lzWUJVcnpOOUZzTUM5bDgwbERzdkN3WmpVR2Q4N0FV?=
 =?utf-8?B?YzV4QW84NU5USkZ5MXZ3L0REeDRoZHNQeEdLcmtyaEcweTVKNXprVXNLczl4?=
 =?utf-8?B?eVFpZnNnTXcxY3kvZFBaaGo3dEFPZlFKT2FjR0EzNnZzd3pabUJWcmNiSjIw?=
 =?utf-8?B?bWpkY2wzTlZwK25HVjRNQzJickdGSTNHdlFpWUdHRHEySjVyMjJDdXVGMmJZ?=
 =?utf-8?B?WGRNc2NIMXdOTkw4b3pxNHNrZjRraGhWQ3BSUENXVDNvakpLeWR6Z0VtWEw1?=
 =?utf-8?B?K2Rubnl2UUl0dzlPYTRBVlFRUGI2NjlVaHRMNjhvWkROejVBWGprYThqMnBz?=
 =?utf-8?B?OXl3QkFvQzRma3B2WHluaElHRW4wSkNqaWRTT0ZQdGg2TCsxcTFleksxMURJ?=
 =?utf-8?B?LzJPUG50UlNldFV4UDR1SXBMeTNRN0JPb2J3UjQ2MzZiYldXTEpRLzY3VkY3?=
 =?utf-8?B?a3NGaXJXQ2NCMEhhS0F4Tllmc3F5R2t0dFlpVDRpUE1rbjhDSDNzdnJkRm9w?=
 =?utf-8?B?ZGFUL0RrZGFWdmNQSGhrWXF1SHBCQkRXanAvTFJNMUQyMVZnNWR4UFZUamxa?=
 =?utf-8?B?UCtYZm9BNVVGL01SbFF4YWh3akl3SUw3d0NDMGo1SkFTRThSVmV5cWxXMXZZ?=
 =?utf-8?B?c1poOG9HRTd0UXRpSysyTllETVY2VTEzRWVZY3NaNy9ZQms2NnlqNFZSWTk3?=
 =?utf-8?B?SUJpV2cxNmhTa1hoMWZmOXNTaW9IbGVhaDlkWG9VTVlPdWUrMHowUXNpK3dK?=
 =?utf-8?B?Y1hCZklBS0Q5NTkrQWF2bnFxVGp1cHJqMmJRTzNlaDRFN3JGTjFwU2RSMG9D?=
 =?utf-8?B?SnZXZ2JkNzhia1pQbm9LbG1KNEtPaHI5cU80MC9LOXN6Uzl4TFZ4aTI3bkNh?=
 =?utf-8?B?TVlEK0JCYllSVUFvTG5sSU9qSEswMGpka3ZqMHBkWmdqRk5IWHE1REFMQ01L?=
 =?utf-8?B?T05RbDltN0IvcGlMS0psYllBZ3Y3czVtOU0zbGhSejBQbi96VzduL3lUdXRU?=
 =?utf-8?B?V3JUQ2o2YWtUYitWV0hhRGhFWjZlbENoQ04zRC9wQkdqUGxtTXE0YUZseG5Q?=
 =?utf-8?B?UDNXcy9oeFEwOFlCZXpKK1dFeVpvZlJuUms4eVB1VVFPemRiRXAzY2Q5VUJh?=
 =?utf-8?B?RHlRTWlZOFVOOEdUa2lVa3hRNkVHd2R1Vk91aURmT3lmQWdDSzdwVTVnWDU2?=
 =?utf-8?B?U2c3b1JxaTdEMHJmQkpySFNwU2tkRnlvMHZBUExiRCtwUDM2cXhWWkQ4eDlD?=
 =?utf-8?B?SUI0RDdiejBob1Z3czNrV2pFUXVrSTh1VU0yeEZmblcrNWRyLzJyZDQ1akk1?=
 =?utf-8?B?aStLZ3BYZ2xwYlZuTHh2UFhuV2paTVB6N2dnNWJXaWdyOEpTRG1NSVBXV0pk?=
 =?utf-8?Q?bsrV/PE7MQUj7m4afhlA9t3B2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc4d0b67-4a1d-4408-4497-08daadbe5a21
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB2379.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 08:30:29.7773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ywdg7d6Pyi3nNuTIFMN+Llhlx+PVdzDfrlQEqYc+zmC78JF1JBVWj4vHWT72uiQrwV7Zogh3rvlNBT/P0KUIBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4472
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Eric,

Thank you for taking a look at the report.

On 10/13/2022 8:05 PM, Eric Dumazet wrote:
> On Thu, Oct 13, 2022 at 6:16 AM K Prateek Nayak <kprateek.nayak@amd.com> wrote:
>>
>> Hello Eric,
>>
>> I might have stumbled upon a possible performance regression observed in
>> some microbenchmarks caused by this series.
>>
>> tl;dr
>>
>> o When performing regression test against tip:sched/core, I noticed a
>>   regression in tbench for the baseline kernel. After ruling out
>>   scheduler changes, bisecting on tip:sched/core, then on Linus' tree and
>>   then on netdev/net-next led me to this series. Patch 6 of the series
>>   which makes changes based on the new reclaim strategy seem to be exact
>>   commit where the regression first started. Regression is also observed
>>   for netperf-tcp but not for netperf-udp after applying this series.
>>
> 
> Hi Prateek
> 
> Thanks for this detailed report.
> 
> Possibly your version of netperf is still using very small writes ?

netperf indeed does small writes. In the report

Hmean     256       6803.96 (   0.00%)     6427.55 *  -5.53%*

           ^
           |

This is the number of bytes per message sent / received
per call passed to netperf via the -m and -M option.
(https://hewlettpackard.github.io/netperf/doc/netperf.html#Options-common-to-TCP-UDP-and-SCTP-tests)
I'm running netperf from mmtests (https://github.com/gormanm/mmtests)
tbench too only sends short messages.

> netperf uses /proc/sys/net/ipv4/tcp_wmem, to read tcp_wmem[1],
> and we have increased years ago /proc/sys/net/ipv4/tcp_wmem
> to match modern era needs.
> 
> # cat /proc/sys/net/ipv4/tcp_wmem
> 4096 262144 67108864

I noticed defaults on my machine was:

$ cat /proc/sys/net/ipv4/tcp_wmem
4096    16384   4194304

I've reran tbench after modifying it to the following value:

cat /proc/sys/net/ipv4/tcp_wmem
4096    262144  67108864

Following are the results:

Clients:      good                 good + series         good  +series + larger wmem
    1    574.93 (0.00 pct)       554.42 (-3.56 pct)      552.92 (-3.82 pct)
    2    1135.60 (0.00 pct)      1034.76 (-8.87 pct)     1036.94 (-8.68 pct)
    4    2117.29 (0.00 pct)      1796.97 (-15.12 pct)    1539.21 (-27.30 pct)
    8    3799.57 (0.00 pct)      3020.87 (-20.49 pct)    2797.98 (-26.36 pct)
   16    6129.79 (0.00 pct)      4536.99 (-25.98 pct)    4301.20 (-29.83 pct)
   32    11630.67 (0.00 pct)     8674.74 (-25.41 pct)    8199.28 (-29.50 pct)
   64    20895.77 (0.00 pct)     14417.26 (-31.00 pct)   14473.34 (-30.73 pct)
  128    31989.55 (0.00 pct)     20611.47 (-35.56 pct)   19671.08 (-38.50 pct)
  256    56388.57 (0.00 pct)     48822.72 (-13.41 pct)   48455.77 (-14.06 pct)
  512    59326.33 (0.00 pct)     43960.03 (-25.90 pct)   43968.59 (-25.88 pct)
 1024    58281.10 (0.00 pct)     41256.18 (-29.21 pct)   40550.97 (-30.42 pct)

Given the message size is small, I think wmem size does not
impact the benchmark results much.

> 
> (Well written applications tend to use large sendmsg() sizes)
> 
> What kind of NIC is used ? It seems it does not use GRO ?

For tbench and netperf, both the client and servers are
running on the same machine using the loopback interface. I'm
not sure if NIC comes into picture but following is detail
gathered by running
$ lspci | egrep -i --color 'network|ethernet|wireless|wi-fi'

Ethernet controller: Broadcom Inc. and subsidiaries NetXtreme BCM5720 Gigabit Ethernet PCIe


> The only regression that has been noticed was when memcg was in the picture.
> Shakeel Butt sent patches to address this specific mm issue.
> Not sure what happened to the series (
> https://patchwork.kernel.org/project/linux-mm/list/?series=669584 )

I'm not running the benchmark in a cgroup / container so I doubt
if I'm hitting this issue. Based on Shakeel's suggestion, I'll
rerun the tests on v6.0-rc1

> 
> We were aware of the possible performance implications, depending on the setup.
> At Google, we use RFS (Documentation/networking/scaling.rst) so that
> incoming ACK are handled on the cpu
> who did the sendmsg(), so the same per-cpu cache is used for the
> charge/uncharge.

I've noticed tbench tasks migrate quite a bit in the system. For
2-clients it is in the 100s, for 32 clients it is in 1000s and for
128-clients, I observe 8325405 task migration over a 60 second run.
I can try some strategic pinning and see if things change.

> 
> Thanks
> 
> [..snip..]
>
 
--
Thanks and Regards,
Prateek
