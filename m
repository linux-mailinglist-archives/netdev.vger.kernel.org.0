Return-Path: <netdev+bounces-9954-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEA9772B4E1
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 02:02:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 704341C20A07
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 00:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33231179;
	Mon, 12 Jun 2023 00:02:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103592C9E;
	Mon, 12 Jun 2023 00:02:28 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529151AE;
	Sun, 11 Jun 2023 17:02:26 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35BDmIYl019958;
	Sun, 11 Jun 2023 17:02:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=X7Xqa3amq6S0rMYAgM7uZUL0+ltwDP9HX4y4OAvGeY8=;
 b=KNnN+sSdbXZkASRtl9MD1pV8x6XoTYnLoMkZJSnCJzlNoT9hkLE9q6xAwUG1EWDmfwU9
 /GG4eHTR6QukFvlmW1mRb7VgKrMcNEGIENnaN7jSVZxXQugZcLvaLGuW37DFQv2UgHWB
 8+tQXZzRRIkj8eRNvq2Fqp6psyi0ZKflbMv4NC+ZOrSbbDWV9IvAUCbNoKYvJklezUZ3
 +V5CX/ULRVN0Pd+3KDmuKZbrNnbvcQwnNsoqgLILLPvm1ghwPFC+DZ9psD6wdcCfgMcD
 pnDuR3DJnh9RLrO4IhozhfxSLUAW7snpyPp4nsTH35DruPOejjVLWZbIbazSVT2NSmQu JA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3r4n7m8xhy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 11 Jun 2023 17:02:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+Y71XXhytQXVavHM999Ldqna29rufpwySe/KPViks8vFhZFdUgIRXLD1nEOh8SYM+uM7LGX/pJLoDPSZxZtJIP86O7J97DK5AEN4FxjPW1nxdHo6Q0vLRB9aypk629BVv79VRnlTnDtEVY4sjBUwow6VJuADXEDuSV2WnranLDWL6cbF5erJ1XRzZgBtHHYHMH4L658xC7OHwv722hYgo9K35pVz4xOitS2uACgprrGng3Aehb6N9iLHPThx489CSvJeAubMhcOfvxo0xWhnhdTFsgNLOV+MvTKnXLtxcbvctjCzYFRwMww5H3HphO+cDv2Qu3nV72Y9CfwjhtA/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7Xqa3amq6S0rMYAgM7uZUL0+ltwDP9HX4y4OAvGeY8=;
 b=LJ+9EGOHffefGHqkwjqG88KoOsndNS5OsCoJlj+l8Vk2XWzWdwxHVM/99UcwWireg71mBOe+Iz/QFpTSXvASh0AoNREHjniXYjI5rmgbZNgQTal41LI28FWNn4rDE5XBDjLxnIrGTCkPV3H2oM4HBD1BnCV9stb0FVIQKVKJJYPu+DrCS9q8akcaj30qijX362qC3XetDxj0ISUDCVQwJoJHvAn3VrhDGcQ1VVU5BpS8MDoYSizeHcferyfVM5tzOZKWl9kirIfWrRmDIPvcstYDjmvnf+QaN0xBBYGso0zWIU1oY6ofNQXRNnpwN7btJAXzho98jJjFyTACb6+4lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3792.namprd15.prod.outlook.com (2603:10b6:806:8a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Mon, 12 Jun
 2023 00:02:03 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::428f:acec:2c1f:c812]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::428f:acec:2c1f:c812%6]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 00:02:02 +0000
Message-ID: <c6e4aa90-aa35-fa42-1196-a71c88994620@meta.com>
Date: Sun, 11 Jun 2023 17:01:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [bug] kernel: bpf: syscall: a possible sleep-in-atomic bug in
 __bpf_prog_put()
Content-Language: en-US
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
 <57dc6a0e-6ba9-e77c-80ac-6bb0a6e2650a@meta.com>
 <CALyQVazb=D1ejapiFdTnan6JbjFJA2q9ifhSsmF4OC9MDz3oAw@mail.gmail.com>
 <d027cb6b-e32c-36ad-3aba-9a7b1177f89f@meta.com>
 <CALyQVayW7e4FPbaMNNuOmYGYt5pcd47zsx2xVkrekEDaVm7H2g@mail.gmail.com>
 <113dc8c1-0840-9ee3-2840-28246731604c@meta.com>
 <CALyQVaxFKisZ_4DjofVE9PH+nFcOKSMJG4XDkn1znsqU+EnYHw@mail.gmail.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <CALyQVaxFKisZ_4DjofVE9PH+nFcOKSMJG4XDkn1znsqU+EnYHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR02CA0039.namprd02.prod.outlook.com
 (2603:10b6:a03:54::16) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SA0PR15MB3792:EE_
X-MS-Office365-Filtering-Correlation-Id: eb3de251-5336-4967-8d96-08db6ad8402d
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	IAMJji3psNiaiX3zZjZIqToOUWBH8pYl03xv5FtjbIAAwMf9UJQX2RsWo1AIkwe4TydSsezkf2bD3Hw1juiSyqMLMFRFqXmvLKpLGUWdy3rLw6b7ngNd9IikOmEaa3RnLHUlv7loab4aSbiJgk4/ICbLfUDZxanAXicdDp08DejzO5yS4DAZ+HxSZgXThnQ2HJOVxmm/6QZhtQQXyjaVkT3jdRyXzameoO+V42Y3vfcFaQtZLne343HHM0UnLm5+qgTMHg48n3+ShqPvkPPaJ4HexLuXhb0t2sFNDPw6k89M5cUZfJjwcuBfW+L0LSaTYV7IS3Z1xht4+yhoB4I3WIQnNGS03ugWpp63XLMOE6oTz0bV066vikCS2AYBHQVbZQ1aUzjznlCwQ1l4K94ik4F8Ta8WVRPLqTsgDdbhAm/5DSkYS+vGosbOiprl9dYKoBa0w/YI/RbLPW6ZCgIYMVibC4V4OUf9fNJs/MYOWAjWX9UpRP5p/lWChIXZH4aUQvjn2xi2LLm12abpTmgqmjxpKx4tu2l3cxUauwi4+ine1bekk1iW+7Jaiju7l4YGs4iGPms0BwuZY8tk8Zp74nl4t4b7iD+J6AfYfNSqNs5HK+pJ+mIi90I8MvzKBLPqY3BpqoPOZO5KiZHb0WU4vA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(39860400002)(346002)(366004)(451199021)(53546011)(6506007)(6512007)(186003)(2616005)(31686004)(83380400001)(6666004)(66556008)(2906002)(66946007)(66476007)(30864003)(41300700001)(6486002)(38100700002)(5660300002)(8936002)(36756003)(8676002)(31696002)(86362001)(478600001)(7416002)(316002)(6916009)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MVFVcFc1Qnd3MXRkUGVEbHpWQ2dTUUEvZWlIWnFCZFFCK1IyOWlTbVQxU1py?=
 =?utf-8?B?YkVoSGJkYW9lK2kvUkY4ZHdOakZVZnJnZzl5aDdvTXZBT1AycWZHRXNkdnUx?=
 =?utf-8?B?MnpNMEtYS2RzTmNRMEx2Wm54bnJyVlV0VnB5MmNIUWE3eTR5bUZSS0lLMEJQ?=
 =?utf-8?B?L2dvMnN5S1dMU3FVdjdibzlKMjBFUHd2L2hHdHczUW41Wk5BS1NEeE1EQzhL?=
 =?utf-8?B?Nms1Sjh1ckZJcnBJenhBTjM1RDZDNGNYOTV2U2FmWHNkVDh4S0FIKzRkbmhR?=
 =?utf-8?B?ZjB5d3ZWVENjc2VpZW1UQ1hnUFRreU1kQ2hKcDN1eWpuWEo0MzVQdlUxRHFu?=
 =?utf-8?B?ZDhlL01hcFRwZHZqWEZTYTNma05aeldzZXVFWENYLzZpR3cvbUJ2L0Vad0sz?=
 =?utf-8?B?R1FmM3B0UlpTcjNLMUMzV0tvSzlNdWZtYWc1MEIwaXc3UDZ4enVOUkQxbXVH?=
 =?utf-8?B?bFViU0tsYzRZK3A4U0J4TGdaZnFkSW9RNS84VXhSUHdwOU9mK3FuUnBydUdz?=
 =?utf-8?B?WG16am5YTHJmU2ViYzRBUHdMU3NhNkd4RzY0aXVyTGVUc3VFb1Z0R0tMQjdv?=
 =?utf-8?B?cTFFOHYrdGMwSkVrai8wcHJlZ096Wk5RaWdaNGowWEpUbG1KdDlqS1JnYWda?=
 =?utf-8?B?b0djUTg4akRWeFlKR09TVSs1SVk3TGNCRHVDZzFHRDV4blFTM0Zwd044Q3lN?=
 =?utf-8?B?TWJMZ0xIcFU1RkMwSEZ5OFVoWG55L1ZqV1FPS3NZb29LWnVVV0lURmN6N2Q5?=
 =?utf-8?B?cEN6ME9qSTdzWjZnQkRlQTFqRnIxL081a1R4MEFDdG9mY3NjblVHWHpFZFpu?=
 =?utf-8?B?TC93RlRaSFprUUtjYy80cWtGSEQ0U0VqZDQwVS9BWk92YTBaTGxibnVXNk8v?=
 =?utf-8?B?bmZZcC85cGdHTFVCRlE5NTA0eGxTQ2d6NXR6bkhobzV4VzRhUTVrT095Mjgr?=
 =?utf-8?B?YUdxSFpCek1objZQUFJCMDlUS2YzeThabVdDM2YyLzNSZ1lPdlpjZ3FZK3dV?=
 =?utf-8?B?VDg1L3RYdUV0ZVZWdjdzb25UT0h4ZWlQRWI4aGU1Y1laVm9MMGFOVW9FNWl1?=
 =?utf-8?B?VVhuaUtkVXcwcHBLSDZTejZZRE1MeTlZaWE1MERvSzFBZkdObFpZYmRKOUhw?=
 =?utf-8?B?KzQ4UDF1bWFNaUw3MGtJTk5vUk9Femg1ZDJvYXlyTnBvSHVERUF5RXBrTStG?=
 =?utf-8?B?eDEyN2xWMFJIY1BzU2lXMi9BMXdyQUJ6Um1mVjVYbDRpU2N2SFhKUDVDSVBh?=
 =?utf-8?B?b09TTGZ1Q2pFek1aUjRpVEtCeFpLU01KSU9ZVjNXRE0xejYweWtGaE8wRzZU?=
 =?utf-8?B?S29DaVdrUEZScEpEVStuTTU4bXRrODJDNEhqVGpiYnlKUmdkUEVDdkNPMFN0?=
 =?utf-8?B?bEtnUkkrQWVEUE9MdjUzeGIvbm41ekVrd1huYUtteGMrOUZQM1RMa0E0UERn?=
 =?utf-8?B?d0piUkgrZEZCemVVanlUaHhQRG5nbWNFZUgyTnlmNWdtZXNpSDhGS2tVWHlJ?=
 =?utf-8?B?QzZzT3AvSjRrM3JzQ2ZhMW9xMDBiR2tPTGZWR1o4cnZsQkFkbEJlYmNKejA3?=
 =?utf-8?B?eDc3eE9kUEFzZDFjSEk2QVFvTXBaTm03czE0ZlI3Q2NQZmRmbzVhZ2kzUG9Y?=
 =?utf-8?B?NVMxaks4cmhiazJNOC9rdndDK0lYT01YUUFDNnlRNTVMU0pET0dteDJ6ZFEr?=
 =?utf-8?B?LzN1WkkrMHdaeE8zVjNHME12NEd5dW1yRGNuaFJ1T2pqS3EwL0JwbVVkaFJl?=
 =?utf-8?B?aEtTVU45cEd5RllKSjByS1A4ZjA0M2wyMFQyR0lyZmM4YTZXWitkdTg1bWNr?=
 =?utf-8?B?dW85Y1VKTDFvS1BuTlZaWEc4bjlScmRKV0ZPNk9LUjc1cStIWVJydXNXNXli?=
 =?utf-8?B?Mk1nL3Z3aE1KM2VNbjgwNXRtWC9VbUo3THRSdHl0ZUxEaStkYjh6VStJT2Ev?=
 =?utf-8?B?a29tV0l4UFJWR3phcklYR3F1eGo5NWV1YlpPOU5JZ3RYM0hGenNvdHNidnNs?=
 =?utf-8?B?aXVPOWdzSWtubTY1NjQrNGtiV1ZITjYvbXBKUHlFbnU4SVFvcm5hZnhwK2Jn?=
 =?utf-8?B?MFF0QjlaZEZQRkd3UUE3NzVBMCtBbkZqVFRCWmZhY2twbEtWNGc2N3lHbSt3?=
 =?utf-8?B?UEhCbXhGTmFNRkNNUStZNDB6RUVHQ2lyVm9rWnAvMUc1blpHTG9MSU9ERmZL?=
 =?utf-8?B?VFE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb3de251-5336-4967-8d96-08db6ad8402d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 00:02:02.6908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8IcAJVDVGvlO90UwBxtOm5/3o8t8hzLNRrKMH0yUPvyZzJaNFgUCqxuAJHowqQ4C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3792
X-Proofpoint-GUID: OaPi8iwB8RpsMMXrSmdNxl1arNjdVfFK
X-Proofpoint-ORIG-GUID: OaPi8iwB8RpsMMXrSmdNxl1arNjdVfFK
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-11_18,2023-06-09_01,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/11/23 6:02 AM, Teng Qi wrote:
> Hello!
>> BTW, please do create a test case, e.g, sockmap test case which
>> can show the problem with existing code base.
> 
> I add a printk in bpf_prog_put_deferred():
> static void bpf_prog_put_deferred(struct work_struct *work)
> {
>          // . . .
>          int inIrq = in_irq();
>          int irqsDisabled = irqs_disabled();
>          int preemptBits = preempt_count();
>          int inAtomic = in_atomic();
>          int rcuHeld = rcu_read_lock_held();
>          printk("bpf_prog_put: in_irq() %d, irqs_disabled() %d, preempt_count()
>           %d, in_atomic() %d, rcu_read_lock_held() %d",
>          inIrq, irqsDisabled, preemptBits, inAtomic, rcuHeld);
>          // . . .
> }
> 
> When running the selftest, I see the following output:
> [255340.388339] bpf_prog_put: in_irq() 0, irqs_disabled() 0,
>          preempt_count() 256, in_atomic() 1, rcu_read_lock_held() 1
> [255393.237632] bpf_prog_put: in_irq() 0, irqs_disabled() 0,
>          preempt_count() 0, in_atomic() 0, rcu_read_lock_held() 1

It would be great if you also print out in_interrupt() value, so we know
whether softirq or nmi is enabled or not.

We cannot really WARN with !rcu_read_lock_held() since the 
__bpf_prog_put funciton is called in different contexts.

Also, note that rcu_read_lock_held() may not be reliable. rcu subsystem
will return 1 if not tracked or not sure about the result.

> 
> Based on this output, I believe it is sufficient to construct a self-test case
> for bpf_prog_put_deferred() called under preempt disabled or rcu read lock
> region. However, I'm a bit confused about what I should do to build the
> self-test case. Are we looking to create a checker that verifies the
> context of bpf_prog_put_deferred() is valid? Or do we need a test case that
> can trigger this bug?
> 
> Could you show me more ideas to construct a self test case? I am not familiar
> with it and have no idea.

Okay, I see. It seems hard to create a test case with warnings since
bpf_prog_put_deferred is called in different context. So some
examples for possible issues (through code analysis) should be good enough.

> 
> -- Teng Qi
> 
> On Thu, May 25, 2023 at 3:34 AM Yonghong Song <yhs@meta.com> wrote:
>>
>>
>>
>> On 5/24/23 5:42 AM, Teng Qi wrote:
>>> Thank you.
>>>
>>>> We cannot use rcu_read_lock_held() in the 'if' statement. The return
>>>> value rcu_read_lock_held() could be 1 for some configurations regardless
>>>> whether rcu_read_lock() is really held or not. In most cases,
>>>> rcu_read_lock_held() is used in issuing potential warnings.
>>>> Maybe there are other ways to record whether rcu_read_lock() is held or not?
>>>
>>> Sorry. I was not aware of the dependency of configurations of
>>> rcu_read_lock_held().
>>>
>>>> If we cannot resolve rcu_read_lock() presence issue, maybe the condition
>>>> can be !in_interrupt(), so any process-context will go to a workqueue.
>>>
>>> I agree that using !in_interrupt() as a condition is an acceptable solution.
>>
>> This should work although it could be conservative.
>>
>>>
>>>> Alternatively, we could have another solution. We could add another
>>>> function e.g., bpf_prog_put_rcu(), which indicates that bpf_prog_put()
>>>> will be done in rcu context.
>>>
>>> Implementing a new function like bpf_prog_put_rcu() is a solution that involves
>>> more significant changes.
>>
>> Maybe we can change signature of bpf_prog_put instead? Like
>>      void bpf_prog_put(struct bpf_prog *prog, bool in_rcu)
>> and inside bpf_prog_put we can add
>>      WARN_ON_ONCE(in_rcu && !bpf_rcu_lock_held());
>>
>>>
>>>> So if in_interrupt(), do kvfree, otherwise,
>>>> put into a workqueue.
>>>
>>> Shall we proceed with submitting a patch following this approach?
>>
>> You could choose either of the above although I think with newer
>> bpf_prog_put() is better.
>>
>> BTW, please do create a test case, e.g, sockmap test case which
>> can show the problem with existing code base.
>>
>>>
>>> I would like to mention something unrelated to the possible bug. At this
>>> moment, things seem to be more puzzling. vfree() is safe under in_interrupt()
>>> but not safe under other atomic contexts.
>>> This disorder challenges our conventional belief, a monotonic incrementation
>>> of limitations of the hierarchical atomic contexts, that programer needs
>>> to be more and more careful to write code under rcu read lock, spin lock,
>>> bh disable, interrupt...
>>> This disorder can lead to unexpected consequences, such as code being safe
>>> under interrupts but not safe under spin locks.
>>> The disorder makes kernel programming more complex and may result in more bugs.
>>> Even though we find a way to resolve the possible bug about the bpf_prog_put(),
>>> I feel sad for undermining of kernel`s maintainability and disorder of
>>> hierarchy of atomic contexts.
>>>
>>> -- Teng Qi
>>>
>>> On Tue, May 23, 2023 at 12:33 PM Yonghong Song <yhs@meta.com> wrote:
>>>>
>>>>
>>>>
>>>> On 5/21/23 6:39 AM, Teng Qi wrote:
>>>>> Thank you.
>>>>>
>>>>>    > Your above analysis makes sense if indeed that kvfree cannot appear
>>>>>    > inside a spin lock region or RCU read lock region. But is it true?
>>>>>    > I checked a few code paths in kvfree/kfree. It is either guarded
>>>>>    > with local_irq_save/restore or by
>>>>>    > spin_lock_irqsave/spin_unlock_
>>>>>    > irqrestore, etc. Did I miss
>>>>>    > anything? Are you talking about RT kernel here?
>>>>>
>>>>> To see the sleepable possibility of kvfree, it is important to analyze the
>>>>> following calling stack:
>>>>> mm/util.c: 645 kvfree()
>>>>> mm/vmalloc.c: 2763 vfree()
>>>>>
>>>>> In kvfree(), to call vfree, if the pointer addr points to memory
>>>>> allocated by
>>>>> vmalloc(), it calls vfree().
>>>>> void kvfree(const void *addr)
>>>>> {
>>>>>            if (is_vmalloc_addr(addr))
>>>>>                    vfree(addr);
>>>>>            else
>>>>>                    kfree(addr);
>>>>> }
>>>>>
>>>>> In vfree(), in_interrupt() and might_sleep() need to be considered.
>>>>> void vfree(const void *addr)
>>>>> {
>>>>>            // ...
>>>>>            if (unlikely(in_interrupt()))
>>>>>            {
>>>>>                    vfree_atomic(addr);
>>>>>                    return;
>>>>>            }
>>>>>            // ...
>>>>>            might_sleep();
>>>>>            // ...
>>>>> }
>>>>
>>>> Sorry. I didn't check vfree path. So it does look like that
>>>> we need to pay special attention to non interrupt part.
>>>>
>>>>>
>>>>> The vfree() may sleep if in_interrupt() == false. The RCU read lock region
>>>>> could have in_interrupt() == false and spin lock region which only disables
>>>>> preemption also has in_interrupt() == false. So the kvfree() cannot appear
>>>>> inside a spin lock region or RCU read lock region if the pointer addr points
>>>>> to memory allocated by vmalloc().
>>>>>
>>>>>    > > Therefore, we propose modifying the condition to include
>>>>>    > > in_atomic(). Could we
>>>>>    > > update the condition as follows: "in_irq() || irqs_disabled() ||
>>>>>    > > in_atomic()"?
>>>>>    > Thank you! We look forward to your feedback.
>>>>>
>>>>> We now think that ‘irqs_disabled() || in_atomic() ||
>>>>> rcu_read_lock_held()’ is
>>>>> more proper. irqs_disabled() is for irq flag reg, in_atomic() is for
>>>>> preempt count and rcu_read_lock_held() is for RCU read lock region.
>>>>
>>>> We cannot use rcu_read_lock_held() in the 'if' statement. The return
>>>> value rcu_read_lock_held() could be 1 for some configuraitons regardless
>>>> whether rcu_read_lock() is really held or not. In most cases,
>>>> rcu_read_lock_held() is used in issuing potential warnings.
>>>> Maybe there are other ways to record whether rcu_read_lock() is held or not?
>>>>
>>>> I agree with your that 'irqs_disabled() || in_atomic()' makes sense
>>>> since it covers process context local_irq_save() and spin_lock() cases.
>>>>
>>>> If we cannot resolve rcu_read_lock() presence issue, maybe the condition
>>>> can be !in_interrupt(), so any process-context will go to a workqueue.
>>>>
>>>> Alternatively, we could have another solution. We could add another
>>>> function e.g., bpf_prog_put_rcu(), which indicates that bpf_prog_put()
>>>> will be done in rcu context. So if in_interrupt(), do kvfree, otherwise,
>>>> put into a workqueue.
>>>>
>>>>
>>>>>
>>>>> -- Teng Qi
>>>>>
>>>>> On Sun, May 21, 2023 at 11:45 AM Yonghong Song <yhs@meta.com
>>>>> <mailto:yhs@meta.com>> wrote:
>>>>>
>>>>>
>>>>>
>>>>>       On 5/19/23 7:18 AM, Teng Qi wrote:
>>>>>        > Thank you for your response.
>>>>>        >  > Looks like you only have suspicion here. Could you find a real
>>>>>       violation
>>>>>        >  > here where __bpf_prog_put() is called with !in_irq() &&
>>>>>        >  > !irqs_disabled(), but inside spin_lock or rcu read lock? I
>>>>>       have not seen
>>>>>        >  > things like that.
>>>>>        >
>>>>>        > For the complex conditions to call bpf_prog_put() with 1 refcnt,
>>>>>       we have
>>>>>        > been
>>>>>        > unable to really trigger this atomic violation after trying to
>>>>>       construct
>>>>>        > test cases manually. But we found that it is possible to show
>>>>>       cases with
>>>>>        > !in_irq() && !irqs_disabled(), but inside spin_lock or rcu read lock.
>>>>>        > For example, even a failed case, one of selftest cases of bpf,
>>>>>       netns_cookie,
>>>>>        > calls bpf_sock_map_update() and may indirectly call bpf_prog_put()
>>>>>        > only inside rcu read lock: The possible call stack is:
>>>>>        > net/core/sock_map.c: 615 bpf_sock_map_update()
>>>>>        > net/core/sock_map.c: 468 sock_map_update_common()
>>>>>        > net/core/sock_map.c:  217 sock_map_link()
>>>>>        > kernel/bpf/syscall.c: 2111 bpf_prog_put()
>>>>>        >
>>>>>        > The files about netns_cookie include
>>>>>        > tools/testing/selftests/bpf/progs/netns_cookie_prog.c and
>>>>>        > tools/testing/selftests/bpf/prog_tests/netns_cookie.c. We
>>>>>       inserted the
>>>>>        > following code in
>>>>>        > ‘net/core/sock_map.c: 468 sock_map_update_common()’:
>>>>>        > static int sock_map_update_common(..)
>>>>>        > {
>>>>>        >          int inIrq = in_irq();
>>>>>        >          int irqsDisabled = irqs_disabled();
>>>>>        >          int preemptBits = preempt_count();
>>>>>        >          int inAtomic = in_atomic();
>>>>>        >          int rcuHeld = rcu_read_lock_held();
>>>>>        >          printk("in_irq() %d, irqs_disabled() %d, preempt_count() %d,
>>>>>        >            in_atomic() %d, rcu_read_lock_held() %d", inIrq,
>>>>>       irqsDisabled,
>>>>>        >            preemptBits, inAtomic, rcuHeld);
>>>>>        > }
>>>>>        >
>>>>>        > The output message is as follows:
>>>>>        > root@(none):/root/bpf# ./test_progs -t netns_cookie
>>>>>        > [  137.639188] in_irq() 0, irqs_disabled() 0, preempt_count() 0,
>>>>>        > in_atomic() 0,
>>>>>        >          rcu_read_lock_held() 1
>>>>>        > #113     netns_cookie:OK
>>>>>        > Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>>>>>        >
>>>>>        > We notice that there are numerous callers in kernel/, net/ and
>>>>>       drivers/,
>>>>>        > so we
>>>>>        > highly suggest modifying __bpf_prog_put() to address this gap.
>>>>>       The gap
>>>>>        > exists
>>>>>        > because __bpf_prog_put() is only safe under in_irq() ||
>>>>>       irqs_disabled()
>>>>>        > but not in_atomic() || rcu_read_lock_held(). The following code
>>>>>       snippet may
>>>>>        > mislead developers into thinking that bpf_prog_put() is safe in all
>>>>>        > contexts.
>>>>>        > if (in_irq() || irqs_disabled()) {
>>>>>        >          INIT_WORK(&aux->work, bpf_prog_put_deferred);
>>>>>        >          schedule_work(&aux->work);
>>>>>        > } else {
>>>>>        >          bpf_prog_put_deferred(&aux->work);
>>>>>        > }
>>>>>        >
>>>>>        > Implicit dependency may lead to issues.
>>>>>        >
>>>>>        >  > Any problem here?
>>>>>        > We mentioned it to demonstrate the possibility of kvfree() being
>>>>>        > called by __bpf_prog_put_noref().
>>>>>        >
>>>>>        > Thanks.
>>>>>        > -- Teng Qi
>>>>>        >
>>>>>        > On Wed, May 17, 2023 at 1:08 AM Yonghong Song <yhs@meta.com
>>>>>       <mailto:yhs@meta.com>
>>>>>        > <mailto:yhs@meta.com <mailto:yhs@meta.com>>> wrote:
>>>>>        >
>>>>>        >
>>>>>        >
>>>>>        >     On 5/16/23 4:18 AM, starmiku1207184332@gmail.com
>>>>>       <mailto:starmiku1207184332@gmail.com>
>>>>>        >     <mailto:starmiku1207184332@gmail.com
>>>>>       <mailto:starmiku1207184332@gmail.com>> wrote:
>>>>>        >      > From: Teng Qi <starmiku1207184332@gmail.com
>>>>>       <mailto:starmiku1207184332@gmail.com>
>>>>>        >     <mailto:starmiku1207184332@gmail.com
>>>>>       <mailto:starmiku1207184332@gmail.com>>>
>>>>>        >      >
>>>>>        >      > Hi, bpf developers,
>>>>>        >      >
>>>>>        >      > We are developing a static tool to check the matching between
>>>>>        >     helpers and the
>>>>>        >      > context of hooks. During our analysis, we have discovered some
>>>>>        >     important
>>>>>        >      > findings that we would like to report.
>>>>>        >      >
>>>>>        >      > ‘kernel/bpf/syscall.c: 2097 __bpf_prog_put()’ shows that
>>>>>       function
>>>>>        >      > bpf_prog_put_deferred() won`t be called in the condition of
>>>>>        >      > ‘in_irq() || irqs_disabled()’.
>>>>>        >      > if (in_irq() || irqs_disabled()) {
>>>>>        >      >      INIT_WORK(&aux->work, bpf_prog_put_deferred);
>>>>>        >      >      schedule_work(&aux->work);
>>>>>        >      > } else {
>>>>>        >      >
>>>>>        >      >      bpf_prog_put_deferred(&aux->work);
>>>>>        >      > }
>>>>>        >      >
>>>>>        >      > We suspect this condition exists because there might be
>>>>>       sleepable
>>>>>        >     operations
>>>>>        >      > in the callees of the bpf_prog_put_deferred() function:
>>>>>        >      > kernel/bpf/syscall.c: 2097 __bpf_prog_put()
>>>>>        >      > kernel/bpf/syscall.c: 2084 bpf_prog_put_deferred()
>>>>>        >      > kernel/bpf/syscall.c: 2063 __bpf_prog_put_noref()
>>>>>        >      > kvfree(prog->aux->jited_linfo);
>>>>>        >      > kvfree(prog->aux->linfo);
>>>>>        >
>>>>>        >     Looks like you only have suspicion here. Could you find a real
>>>>>        >     violation
>>>>>        >     here where __bpf_prog_put() is called with !in_irq() &&
>>>>>        >     !irqs_disabled(), but inside spin_lock or rcu read lock? I
>>>>>       have not seen
>>>>>        >     things like that.
>>>>>        >
>>>>>        >      >
>>>>>        >      > Additionally, we found that array prog->aux->jited_linfo is
>>>>>        >     initialized in
>>>>>        >      > ‘kernel/bpf/core.c: 157 bpf_prog_alloc_jited_linfo()’:
>>>>>        >      > prog->aux->jited_linfo = kvcalloc(prog->aux->nr_linfo,
>>>>>        >      >    sizeof(*prog->aux->jited_linfo),
>>>>>       bpf_memcg_flags(GFP_KERNEL |
>>>>>        >     __GFP_NOWARN));
>>>>>        >
>>>>>        >     Any problem here?
>>>>>        >
>>>>>        >      >
>>>>>        >      > Our question is whether the condition 'in_irq() ||
>>>>>        >     irqs_disabled() == false' is
>>>>>        >      > sufficient for calling 'kvfree'. We are aware that calling
>>>>>        >     'kvfree' within the
>>>>>        >      > context of a spin lock or an RCU lock is unsafe.
>>>>>
>>>>>       Your above analysis makes sense if indeed that kvfree cannot appear
>>>>>       inside a spin lock region or RCU read lock region. But is it true?
>>>>>       I checked a few code paths in kvfree/kfree. It is either guarded
>>>>>       with local_irq_save/restore or by
>>>>>       spin_lock_irqsave/spin_unlock_irqrestore, etc. Did I miss
>>>>>       anything? Are you talking about RT kernel here?
>>>>>
>>>>>
>>>>>        >      >
>>>>>        >      > Therefore, we propose modifying the condition to include
>>>>>        >     in_atomic(). Could we
>>>>>        >      > update the condition as follows: "in_irq() ||
>>>>>       irqs_disabled() ||
>>>>>        >     in_atomic()"?
>>>>>        >      >
>>>>>        >      > Thank you! We look forward to your feedback.
>>>>>        >      >
>>>>>        >      > Signed-off-by: Teng Qi <starmiku1207184332@gmail.com
>>>>>       <mailto:starmiku1207184332@gmail.com>
>>>>>        >     <mailto:starmiku1207184332@gmail.com
>>>>>       <mailto:starmiku1207184332@gmail.com>>>
>>>>>        >
>>>>>

