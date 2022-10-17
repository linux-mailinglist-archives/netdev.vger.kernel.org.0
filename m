Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218A56005EC
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 06:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbiJQEFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 00:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbiJQEFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 00:05:09 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2085.outbound.protection.outlook.com [40.107.96.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B69D31DDC
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 21:05:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjcT/Eta9OVvtLxCKlTAOq5awbwVLKw+75FeOki1bkYJQCSQbur5J9cOShyxjLSqEIeA10E5VN3psuJNux6+Sa3B0j9l56BddxwbvTTQkb6FROyDLElVUn+TWJTcw2ss7+nN/0Cp6CFOfNw5+kmejld44Ls5H+7gBiWDBBMoXVFrndR+AZoiiAdBh8nLQilRZCPKJPfYJdYqHzWe8Zx0oMKZtu2YdfbbvUB5rerIbQkmkVtlx6A92GCUpRwI2a9EkL/1EELZD/l4Vm078xHIy2VhXivZTGjlAg38pjOCTu9Fp+rRNMQSacLKVVep+9sZYFnd6SrHlJO5+SJIHCpxeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o581OMaKRl+wWteTFUVZ1eX78WqQbKj2NDSzXRA5iYo=;
 b=VH5JB/3DGF4P1FatKXX3t8KXy4Nysdm5uXKBhrDqbjRo1C53lTXMnRoXRkmKiZWAnjVT6aHYJUgYB8Lxvii7UmTIFNszhqSufk1S+FCquDOa4y5/qG4vuMlZE7XHKw9k3I6S6flWDyTJx5fD/G34gNR3KM/5YajfXg1DO4pUisekIURJ4oGSCupOHvjgQjBGHoiLILWW0QDcathqJc8R3spVIzL/PJk86Y0T9sW05NRDsHze7w/kOxQgui5QG+b74L6XYuVT13Fn1KAyBYTlg07OzpQ1RAJq09zN7wHGblMriv9VvdYPGj39GZBeY2Q7lOCfR0MxYUwQGEKss+m/rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o581OMaKRl+wWteTFUVZ1eX78WqQbKj2NDSzXRA5iYo=;
 b=fsI82Y6sVLc9ddhFRX2up3XWISoslRpquzVZgIpFkAQvDSbL3HZaCwjCS6jsdciHduQIIsM6b5b+GYa7WT6eP4h2f3HSa9eiz6q5TExLZjSlnwkifHJqke63q098seY365b3hawuZXHa9lHruf26ly+2CmisBtXZHAFmmV2CITk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW2PR12MB2379.namprd12.prod.outlook.com (2603:10b6:907:9::24)
 by BL1PR12MB5707.namprd12.prod.outlook.com (2603:10b6:208:386::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Mon, 17 Oct
 2022 04:05:04 +0000
Received: from MW2PR12MB2379.namprd12.prod.outlook.com
 ([fe80::2e7d:cda3:bb38:a1ce]) by MW2PR12MB2379.namprd12.prod.outlook.com
 ([fe80::2e7d:cda3:bb38:a1ce%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 04:05:02 +0000
Message-ID: <abf9aae5-1497-5a68-26cd-e49d54bbe0fd@amd.com>
Date:   Mon, 17 Oct 2022 09:34:52 +0530
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
 <e9ad936f-a091-e3ed-3e18-335bc0ff009e@amd.com>
 <CANn89iJF2sWcxEJQF8SN4+VuAfVGUmP-s7qFXZEGYJH28iQLWQ@mail.gmail.com>
From:   K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <CANn89iJF2sWcxEJQF8SN4+VuAfVGUmP-s7qFXZEGYJH28iQLWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0081.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9a::20) To MW2PR12MB2379.namprd12.prod.outlook.com
 (2603:10b6:907:9::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2PR12MB2379:EE_|BL1PR12MB5707:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ad753c5-d7aa-4886-6ad0-08daaff4c3f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rI5T8T+cxANTQxcLg0yHtqE8LX+OGwf4OXZv/k04CiDc9VvV8OaOM58N37JNJqIbhh3ETqNXGuQsnPoh8rZtVAMK9d6v4YwJR5fGVfbz6U5rj1mKXGf4oypGsHYvHAJDm9RRtXDmJzdoEBzCAKTswYx7zKfBMcK0jCzQSFEOARWcdFiNTwQaCt+0PJ+fBW5cwFgMc66dcCwtg97lRyfXoglwYD6PAbv/FvGHYfX3QKYr2tss6/D/+D6mxyy4L7Dfpz3dbK/qmlSwyfOPswkrgVSkGftE6J6B7EuCP+MtfGRguvtet45wV6/W+Kk+PDu/em3oqombTuJIbnfvkEErcV4JKJRhk6iTeKNK2K7JosdkSeXZjk4Ouqa/yxYTk5gIUCy3SWAF/SmPvfojSxXF5w4tGILLNDkpxzSiFn2LzYHKkuL3u41sikzmCsH46xnFbIUZ/Nd20VZHxFcHBByp/5YYQa+xBynapvlHvDYp/phRqra/G79tVYJENmEE+c1xTYKg3b2ehA8elwppU9C18TeCMBKiuudAo3BmmgdOu7LCdHXWKOHDrIS7H+zBtegdh96JyKCjfEyVONNxO9ZSiFlsdUVLzHE6K73jhzwXh8DDEezv9JqQ5UjjNkQyapph7HEAul4WNOKKM0rbHwBT6q/Pf09pzo+NgYJ86wZX+MiFYK2TzEtXWdrbmjf6ufShxRrfnYtx0shLhDTH340kSd4CPiMCKqrQEPtsZRZXmwMWqaDVaZYO/O5SFtFkiHfagXjYAYUYsHjjCu54wHgQdKfYMwmOaXRzwcBWgtiIefiM5WsECQmvqE9ZgDd+dLLAG7mPdj1ZLC9iv2uFiWRfNFHrQME0D1DM45Zw+op4d1rxGXpx7K3LiM7nQ0mPTQsA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB2379.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(451199015)(36756003)(38100700002)(31696002)(4326008)(66946007)(66556008)(66476007)(8676002)(54906003)(6916009)(53546011)(2906002)(41300700001)(5660300002)(7416002)(8936002)(2616005)(316002)(186003)(83380400001)(478600001)(6486002)(26005)(86362001)(6666004)(6512007)(31686004)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NThFN1ZzUVA2cjNtV25LakRxRjJJZmRsZllhQ21WNEgwNjhVcFY4Y1dHTDFr?=
 =?utf-8?B?SnlIK0IxckcyQ3NIZFlrZ2xJZ0RoeXZzdnJuQ0pRMEFHUFkzL0kwKzE4THdn?=
 =?utf-8?B?OTBaMWlJZCt4c1lOODV3R05DZ0NNb1IxUnU5RHdzck1KbnhKS0RUdG93eUtW?=
 =?utf-8?B?eStvc29IR3BMcUpKK3JTN2JlQjlFYUJBK043dHA1WDJvb0tYT2tJVWhMRlpM?=
 =?utf-8?B?Vm41RW13RmRPaHZzZ2NCb24zV1ZxV1RLdTlrNjU0S0hRRG1IY0RtVkVJb0RQ?=
 =?utf-8?B?NTFwclBnK2F3UXhoS2xzK2NiMmxaUHZCeUF0VWR6TlB4ZVM5VzFxOE9ONUhE?=
 =?utf-8?B?QTNpQnZCQWpqeFAyRWpuVFF5VDZ0cVN5bXp3OFdGMldWQlJybHBMOGh6MU1V?=
 =?utf-8?B?VjVyWTdhV0oxRDFmSFRiTlRnbWpGMWllTlJyQitDakY0Y0NaQUhZZDlYR1FZ?=
 =?utf-8?B?UTBPanV5V3duWVE2ZE5xVE56MVZmUHlaaUVncFgwLyt5OTVicitmeS92V3Rj?=
 =?utf-8?B?RTVLdG1ab2N0QjFRUWJObHZyaTlHd0R6Vnc2dFAvVEtaMW8zWEFDRlp5RElV?=
 =?utf-8?B?N0YyMG1kMnlEb21RKzdRRXlKcngwZFdrdkFyT2I3K2VraVdmWlZFV3h1YVZs?=
 =?utf-8?B?YzFsRnFvUEdZOW1JeHVKRzVKVmgrQjFwNTBlOFo0QjlLVTdrUmRpUC9HNWRh?=
 =?utf-8?B?WG14WTU1WHltKytVZlZHYjVQSDI3cmxhNHkzdTZnN3IzMXNwT05DMGpVbzR6?=
 =?utf-8?B?aTFiUS92bmFIeGxMKzljVmlITzNsVm45c2hjcGNhOTBTeGI5d3J0TXB5blBE?=
 =?utf-8?B?QUU4eGlFNSthTXBXY3FKYTFNMlkxVnhlNmtmbjE5aEQ4NkwvVUZuWnEwWVJQ?=
 =?utf-8?B?SE5MN0kvaFlwNHZmWWZMTDVJbERIQnVFdk1LNERYZG5oenBmNGt3WnNFZWZW?=
 =?utf-8?B?Qm8yZ3FHRjB4SmtNSktrNUI3eTBUYk9rYS9EMERoTXdkQ09BQ0puTmlaWmp0?=
 =?utf-8?B?dGJ0MlpwZVJQdlkwL0c0Nk1NblMxcnBuaUczaTBhb2lVTTlYcVdOcDJuZVpq?=
 =?utf-8?B?N1I0eUp3eDhyQ3VabmZKckRJd2xLelVSemdaQXdudUJiMklzNE9IZ2NLK3Fx?=
 =?utf-8?B?bU9pQ3kzbnU3bDFDazFjK1VuNUdUYVRON3hCM3ZYeVR6dkJXM1hsbVAxbzFs?=
 =?utf-8?B?NHhDUWZjNzFpK0FjWUgvTTJ3V08wTVZkL1lwa1VYL21pSGd6dzl3V1crMy9w?=
 =?utf-8?B?NjFXVkEzazZpOEpPNjcxS1pGM0VaSHBuciszQTlkOWZIUFhvQ3FERzBKQzFU?=
 =?utf-8?B?akxDd0pUa2x1aUFmc2hTMUpSRk1nc2I4QUVRMFJ1VGpnaUxZU1ZtRmpOSWNC?=
 =?utf-8?B?aHBSVHZ2TGtJS0trN2RIRSt0d01XaEZoWnYxMXV6UDZwak4vVkluV3lmbks1?=
 =?utf-8?B?bTI2c01Yd0ZISUd4Z2k0cFk4S0NIdm83OGFRckpyek5kWFlBeFUrZzZqN3ds?=
 =?utf-8?B?VXJDU3pvVmppQWhDUjhReDZMRGtJQitUTzFNNWpaOFByM05EQVpoNTczZTlE?=
 =?utf-8?B?elp1d0ZacmVXUHhqTFZGMzZKOUVHQnlCeEEvcnE5dDlMV1N2MVZiTHdUK2d4?=
 =?utf-8?B?Qk16eEVCVWRjUi9QWlNuWnprYWxDU01WbDVpTzRJVy9uWkU2aFQ0QzIzSFNs?=
 =?utf-8?B?NkJDMHN2TUhGQWtoUGpCVDZDbyttT1UzQjRFL25CMzNCRmFJT3ZNM1gybFZS?=
 =?utf-8?B?Yk5GZHNLVXQvQkdIMGpSUjY5TGhWUnhmRjdWbEE4L1hzYXJ3T21CcHMycjZD?=
 =?utf-8?B?ZU5RbjQyNlg4VzRWcEtndjlBcGgvTEJqdmR1dVlteGRPY045L0Y3dkZpemZj?=
 =?utf-8?B?aXdOcmRLNWtOd1RnRHczQ21paDZ6TXhQTGxYc2VHY1FvbmZMc0VVUHYrbmJW?=
 =?utf-8?B?SUJKSGsxUXY2b2FCNEZ1L0dIYVM4ZnR4cUZHbmVkWENiNk1rSm0zTkRnWHJR?=
 =?utf-8?B?bUJGcUw2dUtzZVRpOS8ySTRqUFVTYXFqWkxIbEwxRGxKV0VpamVGalAyNFJ3?=
 =?utf-8?B?eVZtTGZOa0d4cE9wdnVlUkx5VE42WHRCcW5YVVowZUNEMk5rNUJsK3BvRmVa?=
 =?utf-8?Q?V01W3aTUsZZj0hTOwu840SPDZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ad753c5-d7aa-4886-6ad0-08daaff4c3f5
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB2379.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 04:05:02.5243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VaRePzTD5NOuMxUlqpesJT9VZuEE1Zi/VTaDBRqflMMlNSC8x0OoNBkaXVMhBA6J1NkhsOjRoQC3Jw09pJJAeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5707
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Eric,

On 10/16/2022 1:49 AM, Eric Dumazet wrote:
> On Fri, Oct 14, 2022 at 1:30 AM K Prateek Nayak <kprateek.nayak@amd.com> wrote:
>>
>> Hello Eric,
> ...
>>
>> Following are the results:
>>
>> Clients:      good                 good + series         good  +series + larger wmem
>>     1    574.93 (0.00 pct)       554.42 (-3.56 pct)      552.92 (-3.82 pct)
>>     2    1135.60 (0.00 pct)      1034.76 (-8.87 pct)     1036.94 (-8.68 pct)
>>     4    2117.29 (0.00 pct)      1796.97 (-15.12 pct)    1539.21 (-27.30 pct)
>>     8    3799.57 (0.00 pct)      3020.87 (-20.49 pct)    2797.98 (-26.36 pct)
>>    16    6129.79 (0.00 pct)      4536.99 (-25.98 pct)    4301.20 (-29.83 pct)
>>    32    11630.67 (0.00 pct)     8674.74 (-25.41 pct)    8199.28 (-29.50 pct)
>>    64    20895.77 (0.00 pct)     14417.26 (-31.00 pct)   14473.34 (-30.73 pct)
>>   128    31989.55 (0.00 pct)     20611.47 (-35.56 pct)   19671.08 (-38.50 pct)
>>   256    56388.57 (0.00 pct)     48822.72 (-13.41 pct)   48455.77 (-14.06 pct)
>>   512    59326.33 (0.00 pct)     43960.03 (-25.90 pct)   43968.59 (-25.88 pct)
>>  1024    58281.10 (0.00 pct)     41256.18 (-29.21 pct)   40550.97 (-30.42 pct)
>>
>> Given the message size is small, I think wmem size does not
>> impact the benchmark results much.
> 
> Hmmm.
> 
> tldr; I can not really repro the issues (tested on AMD EPYC 7B12,
> NPS1) with CONFIG_PREEMPT_NONE=y
> 
> sendmsg(256 bytes)
>     grab 4096 bytes forward allocation from sk->sk_prot->per_cpu_fw_alloc
>    send skb, softirq handler immediately sends ACK back, and queues
> the packet into receiver socket (also grabbing bytes from
> sk->sk_prot->per_cpu_fw_alloc)
>      ACK releases the 4096 bytes to per-cpu
> sk->sk_prot->per_cpu_fw_alloc on sender TCP socket
> 
> per_cpu_fw_alloc have a 1MB cushion (per cpu), not sure why it is not
> enough in your case.
> Worst case would be one dirtying of tcp_memory_allocated every ~256 messages,
> but in more common cases we dirty this cache less often...
> 
> I wonder if NPS2/NPS4 could land per-cpu variables into the wrong NUMA
> node maybe ?
> (or on NPS1, incorrect NUMA information on your platform ?)
> Or maybe the small changes are enough for your system to hit a cliff.
> AMD systems are quite sensitive to mem-bw saturation.

We've observed some unintended side effects of introducing per-cpu
variables in the past that impacted tbench performance
(https://lore.kernel.org/lkml/e000b124-afd4-28e1-fde2-393b0e38ce19@amd.com/)

In those cases, the introduction of new per-cpu variables was enough
to see a regression but with this series, I only see the regression
from Patch 6 which is why I believed it was the changes in the reclaim
strategy that caused this. 

> 
>  I ran the following on an AMD host (NPS1) with two physical cpu (256 HT total)
> 
> for i in 1 2 4 8 16 32 64 128 192 256; do echo -n $i: ;
> ./super_netperf $i -H ::1 -l 10 -- -m 256 -M 256; done
> 
> Before patch series ( 5c281b4e529c )
> 1:   6956
> 2:  14169
> 4:  28311
> 8:  56519
> 16: 113621
> 32: 225317
> 64: 341658
> 128: 475131
> 192: 304515
> 256: 181754
> 
> After patch series, to me this looks very close or even much better at
> high number of threads.
> 1:   6963
> 2:  14166
> 4:  28095
> 8:  56878
> 16: 112723
> 32: 202417
> 64: 266744
> 128: 482031
> 192: 317876
> 256: 293169
> 
> And if we look at "ss -tm" while tests are running, it is clearly
> visible that the old kernels were pretty bad in terms of memory
> control.
> 
> Old kernel:
> ESTAB        0              55040
> [::1]:39474                                                [::1]:32891
> skmem:(r0,rb540000,t0,tb10243584,f1167104,w57600,o0,bl0,d0)
> ESTAB        36864          0
> [::1]:37733                                                [::1]:54752
> skmem:(r55040,rb8515000,t0,tb2626560,f1710336,w0,o0,bl0,d0)
> 
> These two sockets were holding 1167104+1710336 bytes of forward
> allocations, just to 'be efficient'
> Now think of servers with millions of TCP sockets :/
> 
> New kernel : No more extra forward allocations above 4096 bytes.
> sk_forward_alloc only holds the reminder of allocations,
> because memcg/tcp_memory_allocated granularity is in pages.
> 
> ESTAB   35328     0                             [::1]:36493
>                            [::1]:41394
> skmem:(r46848,rb7467000,t0,tb2626560,f2304,w0,o0,bl0,d0)
> ESTAB   0         54272                         [::1]:58680
>                            [::1]:47859
> skmem:(r0,rb540000,t0,tb6829056,f512,w56832,o0,bl0,d0)
> 
> Only when enabling CONFIG_PREEMPT=y I had some kind of spinlock contention
> in scheduler/rcu layers, making test results very flaky.

Thank you for trying to reproduce the issue on your system.
The results you shared are indeed promising. I've probably
overlooked something during my testing.

Can you please share the kernel config you used during your
testing? I would like to rule out any obvious setup errors
from my side.

--
Thanks and Regards,
Prateek

