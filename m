Return-Path: <netdev+bounces-4085-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEF3470AC35
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 05:45:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42D171C209B4
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 03:45:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C84F3819;
	Sun, 21 May 2023 03:45:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B73803;
	Sun, 21 May 2023 03:45:45 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2DDE66;
	Sat, 20 May 2023 20:45:43 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34KLVD5L019075;
	Sat, 20 May 2023 20:45:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=+bqz1OdnSQOlIp5S+fErTIAyODuBtNJ1zkHp2y8mKgo=;
 b=MqyHTLxYwgOmPNarMOOlb0UpzrfP9yX08EUorFNf5Dhmu0Hsr0VZIM4lzOT0/cEfOf81
 NUSlCYRqqJiXeOObEW99yPHF2P92YgrtDxPqPWNy6w5jTZG5yv6T7gAivdHT4BDfzu0p
 Ow18LXzXABb8E/Gx9dtO9wMEreKAb7woSnkro6OIgxbzDHuX9cZb0WxZippPvvaxW4yu
 kVLhePpHYyCvcDDtz0cWqjqutJu/MlUP9gasN1cILd0ycjRM2fbj3ldwxm/gbKAgVHJm
 HDiEc3fWXPk2f2xZfkzlKyFPfFDDf1yKk4vvinJpdi4+IhqszrEklKGz7fzZc/vvq3CI 7g== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qpuwqbn7r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 20 May 2023 20:45:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdSRW1iECy2f3JtdpBrpFPweCWxQS7Pczjqqprrx+GXMce1aOii/YoCfuqnGHXAAxZNtC4la/3z+UE3A15fBPRbBBKO3lIpjgXVNG7D0n92dEQ43H3wpwqrWA4y6fH5OfSf4ksBSAEKoIVOgYLtHeWPpWfJEl49oRLT2xsxAIxO7ZN1xylKPJ0ESULXYy+zEKWw8ofrqmn8CpyluaZxpFnvLcbSZfhVJXAdseayZ75/DvFJoXViIHMxYZ1r3HapJx04LMFJUA8kdKwoSS9+lPl59nGASedvnh62Z8LVPTPyqOo48kfUYK++xrRoZqlkgztFaHFKLxVvsqGpPlcxdTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+bqz1OdnSQOlIp5S+fErTIAyODuBtNJ1zkHp2y8mKgo=;
 b=TyKPO5mSEutUhomcQB8xgZzbwsIa4ISY+9+/6xeY1laC7Yh9yLtwH9Fww5ZNpbuQ5/8z6Jsv2ybCmMn5ksXetZYgZmolnLxgzbXwy9eJ3KJVJCtc9AYTRblrX+H2TtF+EW2rIT0brc38H0UkwvWjKCHy0bV88TvFcqhyrsSgdjLMGk1TFibxMYAPCfeR20QPphTyL2AzzDy2I8YJkAeQn7805HIjuZUPc6pIWSwg8Bo0HVTv29Eyutyog6Fr92KhoMohK5dzfzV88NKRVOJGYfkmZxGwn4roLrcvkCLPg4Oooktk0fzZa4UhaTOHJJXcG5ZCmm9opwIszJ+YNDZ0Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DS0PR15MB6037.namprd15.prod.outlook.com (2603:10b6:8:15f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Sun, 21 May
 2023 03:44:48 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53%7]) with mapi id 15.20.6411.027; Sun, 21 May 2023
 03:44:48 +0000
Message-ID: <57dc6a0e-6ba9-e77c-80ac-6bb0a6e2650a@meta.com>
Date: Sat, 20 May 2023 20:44:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [bug] kernel: bpf: syscall: a possible sleep-in-atomic bug in
 __bpf_prog_put()
To: Teng Qi <starmiku1207184332@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230516111823.2103536-1-starmiku1207184332@gmail.com>
 <e37c0a65-a3f6-e2e6-c2ad-367db20253a0@meta.com>
 <CALyQVax8X63qekZVhvRTmZFFs+ucPKRkBB7UnRZk6Hu3ggi7Og@mail.gmail.com>
Content-Language: en-US
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <CALyQVax8X63qekZVhvRTmZFFs+ucPKRkBB7UnRZk6Hu3ggi7Og@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR07CA0082.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|DS0PR15MB6037:EE_
X-MS-Office365-Filtering-Correlation-Id: eecaa809-0baf-456c-0ddb-08db59adb99a
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	N/KqOzAkAoxekScxuMy7vqt2MBlKrAH9BYFehxlboS2MpO2vcjplCnjBs4qPJoNr4gEldVMXLQsP4j7MFXacXP2dNCqaQM6Etbk/7uYOXQsrGCVopwYS6VsCvRrmdVyWVrF8jZGkmFfX0U95+Qw3N5cIkM1i8Z2CPLkfOvfJhZmb/tKzhwYi62thlnI9uyK6lsn7J79w1COXtZS1EXW58Sh3SsSJkjZz0ecscaAlJYbVR6AMP0mEzJDszRJSoOowfiBtqOo+ZJ31Xzj2IDRw9HwF7jeTG5ZE9MD/Vqb1pmeHbBxBkhg7YpTZUwbNWX2fOIUuXh+8XSM8tJjvvHzln2U3VLs8TNOWgAb3+jL5PE5aQXSuY9mM/C7G+EFMTF0xNPxTZf2VAKt3wq8tBZ+4yieTD6B8ATZPyVVg5LOJTnCNJC/Q5wuFpXjvWni2/ivhf9mehSqC0df0dXVGJKgMFZztrGPKYNV5z7yU1nTsKGx9qMdpdW76HTIkrx2fUXTOHMbmCyuMA4U3rZOVGsa9ttNdsd1zoszkwyyZwZkxnYPUF1tWMb/GhO9uTEECBmwff+EJ2D1+TBKeM0fvqzvRRVKypWuk8OiPA+2MBxwJ4XdqS+kZKz38BsbTlTYwXSB3DnlG/z0ixlWSeEGwJX+Lew==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(451199021)(6486002)(41300700001)(36756003)(38100700002)(6512007)(6506007)(53546011)(7416002)(5660300002)(31696002)(186003)(2616005)(83380400001)(86362001)(6666004)(2906002)(8676002)(8936002)(66476007)(66946007)(4326008)(6916009)(66556008)(31686004)(478600001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WkNtQVlBb3A4NmJHNi8ybjlaWHJDaG5JelB0YjQwWE9naVJWdE1nL3BxaURS?=
 =?utf-8?B?di84aGtPNWw5OHBQY0g1K2NvdktIM1RZa2t2MkRHbnFtY1FQaTlyVFdxbG9v?=
 =?utf-8?B?cjhjSFU2ZnpZeXlVYktYcVl2ZTV5a0Z2TGt4a3I1bmF6OHFBWmNCU2s1Wm5p?=
 =?utf-8?B?aFh1NzV2TkFwemZOcWdRZkJCQ0NCMlRvcFEyTE02VDF3bVdMQTZmZGhJRkNa?=
 =?utf-8?B?K0IvRnlPWkJ6NHU1VU5xd2RNV3kvOVhmWEZxRjN5YUwrWkQ1R0FtN3FzRFJ5?=
 =?utf-8?B?eVpJM1RHbEFHdmd4NVVubmhVd3NobXVHK25KR3dGR2ZqNjZYRjg1M3NEc24v?=
 =?utf-8?B?b3g5dGsrTURVMVBkOFV0ZUVQdWo3U0NoVjVNbzlNakJQTHNwTWJvY1l2V2dG?=
 =?utf-8?B?dUxmSXcxd0owN0JReTVucmtCNEg4T2xGY0x0RnhmVnc3dTZBcmxkVk8zZUV1?=
 =?utf-8?B?TDlLMmY0QTAxekx1a1ROYUFaTVJaNXdteUtZZEExcENpQ2w3SGpJM1dIWHZF?=
 =?utf-8?B?V0JCWlFRSU45aXIyd0tpVGR1R01uME1tV2J2aUhjRGJ4YmhGWVZHdlhaYk52?=
 =?utf-8?B?NUZUbDdvdjVHdk9OT2ZROVJSSkJLemdmT1VTYzdEekxSN2twOEpkdWt5bjRI?=
 =?utf-8?B?UE1wR1VrcHBnc0lORmZtc1NGamxZYlNWb0RIR2F5KzFLODNsUzNMRSs1QmNS?=
 =?utf-8?B?ZHcvSGNhV1ExZ3RMYnJnenZ2MUxrdGhUVkRSOS9lR2xBRyt6M0lOWlVEenoz?=
 =?utf-8?B?TVhNdkdrcmFqd2JkZmJmaFIwWHlFVEE2cWY2ZWk1Rjh6RWovNmhjKzlUR3pz?=
 =?utf-8?B?bG9RZGFpZG16Vm9tMW5UcGFyR1l0b2RmMVd1NEdiRzM3M3FLNnhLQnhSZytW?=
 =?utf-8?B?SklGRUlON2kzVHVQVk5oRW1jbzNYbFdBTjMzR0ZKdUZaZ1ZTVWVicHJsanEv?=
 =?utf-8?B?VFp0bXBQZFMvWkd2ck1JR0JuNlkxcytXaDJ6NzNOQkROZk5UOVZiRk5HQ0g4?=
 =?utf-8?B?bFplNnNJME1veUFYTWt2Zy94UVNIMmNvUnhyZFV1K3hzY3F3NU85d0NzczFF?=
 =?utf-8?B?a0Q2RVpXYW9Pd2ZNdUtZSW16b0YrMDhmM0hqWGNEczFrK0JRZlpGTHVGZkF4?=
 =?utf-8?B?OHRiTzBJZlF6bGhkK1VaWlJUQ0lqYTNidUF3ZnRKWmNzN1hkdyt1YTczOGVl?=
 =?utf-8?B?b0p1WnlVUDNsZUprRTZxb2NSNkkrajEvd0hQa3hUMVRTMjllNmx6RnF2R0x3?=
 =?utf-8?B?d2QzQ2d0OTB3RGJuanFJMjR4RTVrcUJVWVlPSGk4Vmh6cnNIbU1hMjkvTTBz?=
 =?utf-8?B?c0w2UTV2dzZWMzhaRHRmQkxPR1R1RFRNSm1Xem9MVGNKUFUxWnE4c1BGZDhX?=
 =?utf-8?B?UjBUTVFMWGlXdTRacmpFNjZSOWRYSzcrbVJ2TlNva2hyQzdoOTl3NmM0dmhs?=
 =?utf-8?B?dkRXK0RtcmxZRU1IOXRkNjNhc25RRExOckE1VnBkeUpETy9MeEhUNnVMTzla?=
 =?utf-8?B?TVlWdU1VSmdiMUFzaWxhd2VOa1hFb2VEVGZNZ2NDU1JWTTFJdmwzWHA3b3hj?=
 =?utf-8?B?V2MxY0pobFZyTVV0elVrcFRNRE4yZG92VzYrb3I5bk5HTE1CL3FSRW1QeE43?=
 =?utf-8?B?TFFITDkvVVZIUEFTSXR0VTYwZS9yUnBnZTBlOTgyNEhuck5VZzVJMU12SmIr?=
 =?utf-8?B?UDN1NmFhZ0M5ejRSa0pZOWVVWDdSZTNHQUY5Q05HRkJzUnhDNFhRcDJBNm91?=
 =?utf-8?B?UDhHQ3FuYXJqeXVKaTc2S2pnTXplVXJ5RE1ZRzNTT2tvK0tBMlgvQkZrQmps?=
 =?utf-8?B?S2F0YXl5UXowVGFMQXprUkovMmdKT0tIdjIzZjFsbVErKzg2UnNhY2FTTHRY?=
 =?utf-8?B?cE82QmtOendreHVHanczVWM0SzNNNDhlcysySEp1bGd3YzhLTHFMUFhWbVg2?=
 =?utf-8?B?TjE5M20wK1NZMVFxRnhidmFwTGNKL21ZUWFmaTN6aGRsS0pqMkNvMXhvb3dW?=
 =?utf-8?B?VzlNTXJNSkpxckVONnlrRW9DdUFBTldJQ01sUDR4ajhjVHU2d2NXYUo3TDYv?=
 =?utf-8?B?L0Y2TVdqbnRWei82Mzhid0R2YU1uUWxzdGkwMGNYazJCMzVQTzhuYXFNZHdX?=
 =?utf-8?B?a0VDbjlQQ2ZYdllYR2d2TXMzZFVYY0MxYkJrb0tSY1FvcUsyRnBweW52UVMr?=
 =?utf-8?B?V2c9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eecaa809-0baf-456c-0ddb-08db59adb99a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2023 03:44:48.2789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z/jubhW2fuqdA2y/9GjRy+6NF1GTj2nFJLWhLrfJC7QDwNymrFr2uh2VLsmpwEN7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR15MB6037
X-Proofpoint-ORIG-GUID: A6ABq2Bc0HUiZGE7SpvNmIpYAvmQVbHk
X-Proofpoint-GUID: A6ABq2Bc0HUiZGE7SpvNmIpYAvmQVbHk
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-21_01,2023-05-17_02,2023-02-09_01
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/19/23 7:18 AM, Teng Qi wrote:
> Thank you for your response.
>  > Looks like you only have suspicion here. Could you find a real violation
>  > here where __bpf_prog_put() is called with !in_irq() &&
>  > !irqs_disabled(), but inside spin_lock or rcu read lock? I have not seen
>  > things like that.
> 
> For the complex conditions to call bpf_prog_put() with 1 refcnt, we have 
> been
> unable to really trigger this atomic violation after trying to construct
> test cases manually. But we found that it is possible to show cases with
> !in_irq() && !irqs_disabled(), but inside spin_lock or rcu read lock.
> For example, even a failed case, one of selftest cases of bpf, netns_cookie,
> calls bpf_sock_map_update() and may indirectly call bpf_prog_put()
> only inside rcu read lock: The possible call stack is:
> net/core/sock_map.c: 615 bpf_sock_map_update()
> net/core/sock_map.c: 468 sock_map_update_common()
> net/core/sock_map.c:  217 sock_map_link()
> kernel/bpf/syscall.c: 2111 bpf_prog_put()
> 
> The files about netns_cookie include
> tools/testing/selftests/bpf/progs/netns_cookie_prog.c and
> tools/testing/selftests/bpf/prog_tests/netns_cookie.c. We inserted the
> following code in
> ‘net/core/sock_map.c: 468 sock_map_update_common()’:
> static int sock_map_update_common(..)
> {
>          int inIrq = in_irq();
>          int irqsDisabled = irqs_disabled();
>          int preemptBits = preempt_count();
>          int inAtomic = in_atomic();
>          int rcuHeld = rcu_read_lock_held();
>          printk("in_irq() %d, irqs_disabled() %d, preempt_count() %d,
>            in_atomic() %d, rcu_read_lock_held() %d", inIrq, irqsDisabled,
>            preemptBits, inAtomic, rcuHeld);
> }
> 
> The output message is as follows:
> root@(none):/root/bpf# ./test_progs -t netns_cookie
> [  137.639188] in_irq() 0, irqs_disabled() 0, preempt_count() 0, 
> in_atomic() 0,
>          rcu_read_lock_held() 1
> #113     netns_cookie:OK
> Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
> 
> We notice that there are numerous callers in kernel/, net/ and drivers/, 
> so we
> highly suggest modifying __bpf_prog_put() to address this gap. The gap 
> exists
> because __bpf_prog_put() is only safe under in_irq() || irqs_disabled()
> but not in_atomic() || rcu_read_lock_held(). The following code snippet may
> mislead developers into thinking that bpf_prog_put() is safe in all 
> contexts.
> if (in_irq() || irqs_disabled()) {
>          INIT_WORK(&aux->work, bpf_prog_put_deferred);
>          schedule_work(&aux->work);
> } else {
>          bpf_prog_put_deferred(&aux->work);
> }
> 
> Implicit dependency may lead to issues.
> 
>  > Any problem here?
> We mentioned it to demonstrate the possibility of kvfree() being
> called by __bpf_prog_put_noref().
> 
> Thanks.
> -- Teng Qi
> 
> On Wed, May 17, 2023 at 1:08 AM Yonghong Song <yhs@meta.com 
> <mailto:yhs@meta.com>> wrote:
> 
> 
> 
>     On 5/16/23 4:18 AM, starmiku1207184332@gmail.com
>     <mailto:starmiku1207184332@gmail.com> wrote:
>      > From: Teng Qi <starmiku1207184332@gmail.com
>     <mailto:starmiku1207184332@gmail.com>>
>      >
>      > Hi, bpf developers,
>      >
>      > We are developing a static tool to check the matching between
>     helpers and the
>      > context of hooks. During our analysis, we have discovered some
>     important
>      > findings that we would like to report.
>      >
>      > ‘kernel/bpf/syscall.c: 2097 __bpf_prog_put()’ shows that function
>      > bpf_prog_put_deferred() won`t be called in the condition of
>      > ‘in_irq() || irqs_disabled()’.
>      > if (in_irq() || irqs_disabled()) {
>      >      INIT_WORK(&aux->work, bpf_prog_put_deferred);
>      >      schedule_work(&aux->work);
>      > } else {
>      >
>      >      bpf_prog_put_deferred(&aux->work);
>      > }
>      >
>      > We suspect this condition exists because there might be sleepable
>     operations
>      > in the callees of the bpf_prog_put_deferred() function:
>      > kernel/bpf/syscall.c: 2097 __bpf_prog_put()
>      > kernel/bpf/syscall.c: 2084 bpf_prog_put_deferred()
>      > kernel/bpf/syscall.c: 2063 __bpf_prog_put_noref()
>      > kvfree(prog->aux->jited_linfo);
>      > kvfree(prog->aux->linfo);
> 
>     Looks like you only have suspicion here. Could you find a real
>     violation
>     here where __bpf_prog_put() is called with !in_irq() &&
>     !irqs_disabled(), but inside spin_lock or rcu read lock? I have not seen
>     things like that.
> 
>      >
>      > Additionally, we found that array prog->aux->jited_linfo is
>     initialized in
>      > ‘kernel/bpf/core.c: 157 bpf_prog_alloc_jited_linfo()’:
>      > prog->aux->jited_linfo = kvcalloc(prog->aux->nr_linfo,
>      >    sizeof(*prog->aux->jited_linfo), bpf_memcg_flags(GFP_KERNEL |
>     __GFP_NOWARN));
> 
>     Any problem here?
> 
>      >
>      > Our question is whether the condition 'in_irq() ||
>     irqs_disabled() == false' is
>      > sufficient for calling 'kvfree'. We are aware that calling
>     'kvfree' within the
>      > context of a spin lock or an RCU lock is unsafe.

Your above analysis makes sense if indeed that kvfree cannot appear
inside a spin lock region or RCU read lock region. But is it true?
I checked a few code paths in kvfree/kfree. It is either guarded
with local_irq_save/restore or by 
spin_lock_irqsave/spin_unlock_irqrestore, etc. Did I miss
anything? Are you talking about RT kernel here?


>      >
>      > Therefore, we propose modifying the condition to include
>     in_atomic(). Could we
>      > update the condition as follows: "in_irq() || irqs_disabled() ||
>     in_atomic()"?
>      >
>      > Thank you! We look forward to your feedback.
>      >
>      > Signed-off-by: Teng Qi <starmiku1207184332@gmail.com
>     <mailto:starmiku1207184332@gmail.com>>
> 

