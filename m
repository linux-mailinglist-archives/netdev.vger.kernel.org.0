Return-Path: <netdev+bounces-2326-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3705C7013FF
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 04:37:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BD7A1C212CD
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 02:37:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD1F0EA4;
	Sat, 13 May 2023 02:37:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7DA7E8;
	Sat, 13 May 2023 02:37:15 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A164696;
	Fri, 12 May 2023 19:37:10 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34D0wB0I019186;
	Fri, 12 May 2023 19:36:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=oTl0oM5jCCmy/r0FH+WRDbxmJ5XI9DLWWcA0Wl8G/XI=;
 b=NuvHWjeNn0+VGFvFcbNjUnCxvack2EJ9xM2Ncubp4YwaHSRPcaKNx60u4DXzmEbiItie
 0tlOX48+E2JsULvLPySGbyxa2aYt6V515hj4MOV+xYakr/VpO1AgPPRFWPBZD9vM8/li
 rVJZ5/E+fHsLkGzFER4EKxJVd9krRM0p759iqbQfQ4/IMYG0m6qPQQIIitdUq4ConrNY
 BVimrA6N004AV8dS9UpqV7RjkYSzaGGhQWG7b8Jh0+9ZK7JnOUegbifPGrWxSpBF9zDZ
 Gbm+jWnqPOO4YabQrJOWCTya25Sh8+sHEBdVAm9zbgNuInrEbRvFbVSVdTMQ80yTmNQN Gg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qhaxwkue6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 May 2023 19:36:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Be5eYexbMH6juH9ArtMmHH/gGlAIbnT+tnOWoFS0t6pr8lJ9gkw2/PfI28V9+NuyPFuI/5CFuNkCg3hVashSCnsfDGMvCXD1IjgqB5LCkcSvPEn496bESdBMy8ohSCQ4B3ZQSFjEDXnH2c6yJC7bTjWPuZF99fD7NQLit2vOUz0V5Qf+8f/oHveDznmqDqkGHcJo6d9zokLU7w7hp7+5Aoa4Ju6+fReRknDHj+FNs1/A2n7+iTb0xQxOfEer3W20Eq1n2nD/ZBTnyWU7w9YJB5x2sM1pdpriYYKvyJusDR5o/yjTHYxkeM5QnF5Ufdy5OE6xcM3X6uxzapiw8m+/Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oTl0oM5jCCmy/r0FH+WRDbxmJ5XI9DLWWcA0Wl8G/XI=;
 b=ITMcWW3mZ0Roi59g3TZMuGUFN86Sw81NdKslx/NSBmhL/22Kcuf+v5L7NILSOexGLMQQYBdvFsc0vcFNl292aWlM6yn3RcG21R2q8l3sS+Xkk8FMISN6UgA0/+sitXOii29YhpXS2u1BzlMjWYOR4aLy6vOKZWD8TxA2pfKRFbXNeF/k2r98luYwLxfAIqyjuzGe2raNc6j6b4JTDdDUas7YvfqweVZ9lpGSyvU3wgCe94lDdo99SxQJL1fQXzu39q7dalg3MT757teXp1jNzCLE4w/YIPNDAEhNu7mt+gH9SALjwvqgd3MmMotMKuc02nlMv4o9SblZmqn/0U1Gew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by CO6PR15MB4147.namprd15.prod.outlook.com (2603:10b6:5:353::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.27; Sat, 13 May
 2023 02:36:37 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53%6]) with mapi id 15.20.6363.032; Sat, 13 May 2023
 02:36:37 +0000
Message-ID: <a6c18615-7c48-2dc8-baff-9e64f64e2f18@meta.com>
Date: Fri, 12 May 2023 19:36:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH bpf-next v1 4/5] bpf: add smc negotiator support in BPF
 struct_ops
To: "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        pabeni@redhat.com, song@kernel.org, sdf@google.com, haoluo@google.com,
        yhs@fb.com, edumazet@google.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, jolsa@kernel.org, guwen@linux.alibaba.com
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
References: <1683872684-64872-1-git-send-email-alibuda@linux.alibaba.com>
 <1683872684-64872-5-git-send-email-alibuda@linux.alibaba.com>
Content-Language: en-US
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <1683872684-64872-5-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:254::13) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|CO6PR15MB4147:EE_
X-MS-Office365-Filtering-Correlation-Id: ce6edc31-716b-4791-a3bb-08db535adfc6
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	bJhMNTpO+Rx3l8gFnxySvr5Eu34d/VJKK5NG4pk7AQ9sxIIgJqe/WlQ5KL9FyFz97bQoO+zmkMu2EgAtKWs6efGdupuQWpZi2DEMZ+dQu+dfXCyRTYPUxQeMsriE8VDPnEJGI/mH6WLAAY7qjc5DxHtAu1KraJwgaCowweBTzcbqVjH6TgT23uc1ZtZaEYDyy1PDM5B0xeFJZNSBBMq6701BpWdLy2GSXCrPvFBING5hAKBPMgmPbPjOcvwA0il+sKR7qeu8tBtvveaLu30hHKPN8ANvI/HEvv0ZeoH3c3DH9MLMhhe9qzYnNvrO2vD5WfErAGCTSfPO5vtQVYo0YzW0L4+xLTmkdIjkQpR8/OHWjOCF7ahAeLUIEiOnX46YcCewQgg/DZRsW6HjJ3b8oIwX6jTUnuHbXNTl27rTxA1oGD3F1t3MqZynt+wRHlsNxhtKH3dJI6ARVsVAk6h+ETdJnl7PzfbbPBeoPICg9Q9JOAlDltd9kw1D6ioS71SStkJ9JbI3/ytKiqk6Oeqn1MAllgU9qupncFIB/zg1/uXIMPWBy4wklSh4ZA2Dq5gFaitFINYMkC7aEjlNpDuqGkRXsz3gXhfOEGdJsIZIKW1XUbPQ0YWOiDHlYYnlxJe204NfF6myMGqn8Z0pjXa3K4GAHr+iGtzuWK5fzo3btdo=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(39860400002)(346002)(136003)(451199021)(478600001)(6512007)(6506007)(186003)(53546011)(36756003)(6666004)(6486002)(5660300002)(8936002)(41300700001)(8676002)(2906002)(7416002)(66946007)(66556008)(66476007)(4326008)(316002)(31686004)(86362001)(921005)(38100700002)(2616005)(31696002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UG1LbnVsSzhJN0pNNC9hTzFvZWVVbS9kblFWakptY2o5UGh0TTZUaG1vVUh2?=
 =?utf-8?B?M3M1QnVab0VLZEVRUjBER2xGRUFRWUFRV01EemhMME1iU0lYVDZpTUsrcDRv?=
 =?utf-8?B?eU1LcUFFZm9XcEd4ZzBnQVhuejJXRkR4K21XMHpkaXZGUU03THNPYlNTZFpU?=
 =?utf-8?B?NkVoOTlzK3NvMk5CNkNYYVd3YitNc0ZML3lQQkhuWXp6VERPYXJINGFvN2Nl?=
 =?utf-8?B?UmsxTk9GUTR0MnRlQ0gyZWR6MThWbE94TWIwRlVBUDZUcUg4N2FqQVA1VWZy?=
 =?utf-8?B?U05nWW0wZHhHSk0vZkc4Zk9Kd2ZtWHAxYmFmZTZoTTAzM2NjRzllL3BFK0Vl?=
 =?utf-8?B?OG5qUTg5VDR3N3B5MHkzUkU3eXVtbjlTYkFNcWJjN3JrT0N3TlYxbnJLNXdD?=
 =?utf-8?B?QktKZHk5Zlo3WlNRenZ6T2RSQ0JTbWVTZ1VBNXBVUjhFeUdCcWlYd3Q1Wmhr?=
 =?utf-8?B?OHZhbFFKZkhpZDdxajR2NVNsSllVdmZKT2lja3EzbjFBaG41blRkdzBOOXFn?=
 =?utf-8?B?NUMwOU1MNTlXZDVWZms2M01EeGJZWm4rRGdoeGNUS0JaZkVGamtXVmp5ay9Q?=
 =?utf-8?B?ejFWbVVsaExTQWxXZHI0UVdPc1ZXaG1tNE5UUTU5dzZ4QzdSK04zczNuZXFq?=
 =?utf-8?B?YVljU1VmQU9DdkFzSlpWOUtsdXVQdEx3QTQ0dS8yY01NQUhqU2I2cGQzeEFv?=
 =?utf-8?B?VTllbkZkMW9HQWNMQ0swYzlCc3psc1h2L29OWWIwcmNzandZdC9KejFpQ2dB?=
 =?utf-8?B?QWlqQmwwL0J1TjZ1WjhzYktuekVpRW5uUTJPQUFCVXRoaVRTeUhRbW44Qytz?=
 =?utf-8?B?cTZYK0t3ZllKci9rQjRGSEpsS01STTFERGt5ZmwwUUo0M2FiMVN0amlIT1I1?=
 =?utf-8?B?cDZLRXBUMEE1RU1naTBMcmxNMXVoc3RqK2tUemhHUE81V2FEK2VaMjZyV1dn?=
 =?utf-8?B?U3B6OFc5Sjg4TEVwb0I2cnFmWFRTcjFoSVZ0K2J6MldKQ3lGcVBHSXFnSlpY?=
 =?utf-8?B?cmc5c2tTNkFjMnBPa1A3OFpZN2RmbTFRWjZrMnJvNE5HTStsNUVaOVhkalNK?=
 =?utf-8?B?ZzRRN1E5dW5PVGloQ0d5Uk5QZm95dmNReHVKS1FsMnFaemNML0xTV1ZBZmNZ?=
 =?utf-8?B?MmVNU2tHWjBiT2hyMkZiWnB1VGZzK2cvWDdGYVVZMFd4aHVNU3ptVmlvT3JZ?=
 =?utf-8?B?M2ZrVlFoMXBSSVorVEFyU1JzRFpOMDFLbm4vK3FTTEdBZkljLzMzWmgvMDNn?=
 =?utf-8?B?N3g2MldqYmwrOERaaWltdm5MUiszRzdHRjJXK05mUGxsM0NIMmpkZ3pIRDhW?=
 =?utf-8?B?WDArNWRKTFM1U3U0TGc4UHpDVDRtSHhmNlB5ZVdEL2lENEhocjd3SzRIbVNr?=
 =?utf-8?B?aW04eWVCQy9TVVU3S2sxek1ZMnc0aTcyK29yN3VuZUhHQVowUzdkbll0UlhO?=
 =?utf-8?B?cDFLRGlvWEZXa1VOMkRQd1FpVktBMTREZmZscCtTbzYvbWFFVVVVamU1RmVI?=
 =?utf-8?B?Y1VLK1VFRzljaVNyaXR2ejB4THV5WjhFS1JRc2U5UEk5S3Q0R2FQWERmOElX?=
 =?utf-8?B?ayt2NkpjM21UTlBuby9SenR1cmJRb3FWaWQzbk96RmNwaVBBRllJcWxrL0Zs?=
 =?utf-8?B?bStjOEZldHJCaWZ4VEZlNFRYeEVqZEw3ejZ6TEhETjNMU05zY0RPMzBvbVRt?=
 =?utf-8?B?d2kwNHpTU0dlWGFGdDV1Z0N3NE9tdnU4VWRzZG5wUGNpLzEyc2lIUExKZ005?=
 =?utf-8?B?dGhGOTJ6dnNTa3RDMUFsWTYxTmlwMTJjRWUwbDRKVjZTSGdlQ2w1YmJEalov?=
 =?utf-8?B?SWxsRGlXMXVnVmNQL0I0T09QMU4zUHNGT2FMMnhmWXR2ZE1tczc0b0h0dmtQ?=
 =?utf-8?B?aVhYeFRzL1hvYWo1RVJkVndTMnp3a2h3U3IzUWZhR0RyVVM2a041WVVFNUY0?=
 =?utf-8?B?ckpmSEJvdzhoTSsyNnEzTEt6anNOSHl0bFhqeGl1cDRSWG12YTc1L1A3cTQx?=
 =?utf-8?B?ektzUzhrTFh4UktUMHdZYy9VNldUYWVjR3loYkZ2ckUyRkV6UHpsc0htS2dj?=
 =?utf-8?B?TGVXbjZpNHRTaFJsM3RsMTltRVlqa2RlQ1dacUZEcnF4bDJRb2xIcVE0RVVv?=
 =?utf-8?B?SlpKUXllVThEQWlCWThlRDRQY3ppZnNYLzU5cjRyVDhscGdGNEpXejJuSHBn?=
 =?utf-8?B?YXc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce6edc31-716b-4791-a3bb-08db535adfc6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2023 02:36:37.1165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jf6HP1kADYWk86fPCBpBajsGui2TTwL+46xmKzHtB0ei7QQ8G7meIq+ujO2eUhvy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR15MB4147
X-Proofpoint-GUID: mAfpCdtTnxIwrwUrmktunVKEMhhl2T9X
X-Proofpoint-ORIG-GUID: mAfpCdtTnxIwrwUrmktunVKEMhhl2T9X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_16,2023-05-05_01,2023-02-09_01
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/11/23 11:24 PM, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> This PATCH attempts to introduce BPF injection capability for SMC.
> Considering that the SMC protocol is not suitable for all scenarios,
> especially for short-lived. However, for most applications, they cannot
> guarantee that there are no such scenarios at all. Therefore, apps
> may need some specific strategies to decide shall we need to use SMC
> or not, for example, apps can limit the scope of the SMC to a specific
> IP address or port.
> 
> Based on the consideration of transparent replacement, we hope that apps
> can remain transparent even if they need to formulate some specific
> strategies for SMC using. That is, do not need to recompile their code.
> 
> On the other hand, we need to ensure the scalability of strategies
> implementation. Although it is simple to use socket options or sysctl,
> it will bring more complexity to subsequent expansion.
> 
> Fortunately, BPF can solve these concerns very well, users can write
> thire own strategies in eBPF to choose whether to use SMC or not.
> And it's quite easy for them to modify their strategies in the future.
> 
> This PATCH implement injection capability for SMC via struct_ops.
> In that way, we can add new injection scenarios in the future.
> 
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
>   kernel/bpf/bpf_struct_ops_types.h |   4 +
>   net/Makefile                      |   2 +-
>   net/smc/bpf_smc.c                 | 171 ++++++++++++++++++++++++++++++++++++++
>   3 files changed, 176 insertions(+), 1 deletion(-)
>   create mode 100644 net/smc/bpf_smc.c
> 
> diff --git a/kernel/bpf/bpf_struct_ops_types.h b/kernel/bpf/bpf_struct_ops_types.h
> index 5678a9d..d952b85 100644
> --- a/kernel/bpf/bpf_struct_ops_types.h
> +++ b/kernel/bpf/bpf_struct_ops_types.h
> @@ -9,4 +9,8 @@
>   #include <net/tcp.h>
>   BPF_STRUCT_OPS_TYPE(tcp_congestion_ops)
>   #endif
> +#if IS_ENABLED(CONFIG_SMC_BPF)
> +#include <net/smc.h>
> +BPF_STRUCT_OPS_TYPE(smc_sock_negotiator_ops)
> +#endif
>   #endif
> diff --git a/net/Makefile b/net/Makefile
> index 222916a..2139fa4 100644
> --- a/net/Makefile
> +++ b/net/Makefile
> @@ -52,7 +52,7 @@ obj-$(CONFIG_TIPC)		+= tipc/
>   obj-$(CONFIG_NETLABEL)		+= netlabel/
>   obj-$(CONFIG_IUCV)		+= iucv/
>   obj-$(CONFIG_SMC)		+= smc/
> -obj-$(CONFIG_SMC_BPF)		+= smc/smc_negotiator.o
> +obj-$(CONFIG_SMC_BPF)		+= smc/smc_negotiator.o smc/bpf_smc.o
>   obj-$(CONFIG_RFKILL)		+= rfkill/
>   obj-$(CONFIG_NET_9P)		+= 9p/
>   obj-$(CONFIG_CAIF)		+= caif/
> diff --git a/net/smc/bpf_smc.c b/net/smc/bpf_smc.c
> new file mode 100644
> index 0000000..ac9a9ae91
> --- /dev/null
> +++ b/net/smc/bpf_smc.c
> @@ -0,0 +1,171 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + *  Support eBPF for Shared Memory Communications over RDMA (SMC-R) and RoCE
> + *
> + *  Copyright IBM Corp. 2016, 2018

The above description and copyright sound very wierd.

> + *
> + *  Author(s):  D. Wythe <alibuda@linux.alibaba.com>

One author, so just "Author: ...".
> + */
> +
> +#include <linux/bpf_verifier.h>
> +#include <linux/btf_ids.h>
> +#include <linux/kernel.h>
> +#include <linux/bpf.h>
> +#include <linux/btf.h>
> +#include "smc_negotiator.h"
> +
> +extern struct bpf_struct_ops bpf_smc_sock_negotiator_ops;
> +static u32 smc_sock_id, sock_id;
> +
> +static int bpf_smc_negotiator_init(struct btf *btf)
> +{
> +	s32 type_id;
> +
> +	type_id = btf_find_by_name_kind(btf, "sock", BTF_KIND_STRUCT);
> +	if (type_id < 0)
> +		return -EINVAL;
> +	sock_id = type_id;
> +
> +	type_id = btf_find_by_name_kind(btf, "smc_sock", BTF_KIND_STRUCT);
> +	if (type_id < 0)
> +		return -EINVAL;
> +	smc_sock_id = type_id;
> +
> +	return 0;
> +}
> +
> +/* register ops */
> +static int bpf_smc_negotiator_reg(void *kdata)
> +{
> +	return smc_sock_register_negotiator_ops(kdata);
> +}
> +
> +/* unregister ops */
> +static void bpf_smc_negotiator_unreg(void *kdata)
> +{
> +	smc_sock_unregister_negotiator_ops(kdata);
> +}
> +
> +/* unregister ops */

update ops?
Also I think the above comments like
'register ops', 'unregister ops' and 'update ops' are not
necessary. The code itself is self-explanary.

> +static int bpf_smc_negotiator_update(void *kdata, void *old_kdata)
> +{
> +	return smc_sock_update_negotiator_ops(kdata, old_kdata);
> +}
> +
> +static int bpf_smc_negotiator_validate(void *kdata)
> +{
> +	return smc_sock_validate_negotiator_ops(kdata);
> +}
> +
> +static int bpf_smc_negotiator_check_member(const struct btf_type *t,
> +					   const struct btf_member *member,
> +					   const struct bpf_prog *prog)
> +{
> +	return 0;
> +}
> +
> +static int bpf_smc_negotiator_init_member(const struct btf_type *t,
> +					  const struct btf_member *member,
> +					  void *kdata, const void *udata)
> +{
> +	const struct smc_sock_negotiator_ops *uops;
> +	struct smc_sock_negotiator_ops *ops;
> +	u32 moff;
> +
> +	uops = (const struct smc_sock_negotiator_ops *)udata;
> +	ops = (struct smc_sock_negotiator_ops *)kdata;
> +
> +	moff = __btf_member_bit_offset(t, member) / 8;
> +
> +	/* init name */
> +	if (moff ==  offsetof(struct smc_sock_negotiator_ops, name)) {
> +		if (bpf_obj_name_cpy(ops->name, uops->name,
> +				     sizeof(uops->name)) <= 0)
> +			return -EINVAL;
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +BPF_CALL_1(bpf_smc_skc_to_tcp_sock, struct sock *, sk)
> +{
> +	if (sk && sk_fullsock(sk) && sk->sk_family == AF_SMC)
> +		return (unsigned long)((struct smc_sock *)(sk))->clcsock->sk;
> +
> +	return (unsigned long)NULL;
> +}
> +
> +static const struct bpf_func_proto bpf_smc_skc_to_tcp_sock_proto = {
> +	.func			= bpf_smc_skc_to_tcp_sock,
> +	.gpl_only		= false,
> +	.ret_type		= RET_PTR_TO_BTF_ID_OR_NULL,
> +	.arg1_type		= ARG_PTR_TO_BTF_ID_SOCK_COMMON,
> +	.ret_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_TCP],
> +};
> +
> +static const struct bpf_func_proto *
> +smc_negotiator_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> +{
> +	const struct btf_member *m;
> +	const struct btf_type *t;
> +	u32 midx, moff;
> +
> +	midx = prog->expected_attach_type;
> +	t = bpf_smc_sock_negotiator_ops.type;
> +	m = &btf_type_member(t)[midx];
> +
> +	moff = __btf_member_bit_offset(t, m) / 8;
> +
> +	switch (func_id) {
> +	case BPF_FUNC_setsockopt:
> +		switch (moff) {
> +		/* Avoid potential deadloop risk */
> +		case offsetof(struct smc_sock_negotiator_ops, init):
> +			fallthrough;

I am not sure whether a 'fallthrough' is needed here or since the case
itself does not have any code. Any warning will show up if
'fallthrough;' is removed?

> +		/* Avoid potential leak risk */

I think more detailed explanation about 'deadloop risk' and 'leak risk'
is necessary.

> +		case offsetof(struct smc_sock_negotiator_ops, release):
> +			return NULL;
> +		}
> +		return &bpf_sk_setsockopt_proto;
> +	case BPF_FUNC_getsockopt:
> +		return &bpf_sk_getsockopt_proto;
> +	case BPF_FUNC_skc_to_tcp_sock:
> +		return &bpf_smc_skc_to_tcp_sock_proto;
> +	default:
> +		return bpf_base_func_proto(func_id);
> +	}
> +}
> +
> +static bool smc_negotiator_prog_is_valid_access(int off, int size, enum bpf_access_type type,
> +						const struct bpf_prog *prog,
> +						struct bpf_insn_access_aux *info)
> +{
> +	if (!bpf_tracing_btf_ctx_access(off, size, type, prog, info))
> +		return false;
> +
> +	/* promote it to smc_sock */
> +	if (base_type(info->reg_type) == PTR_TO_BTF_ID &&
> +	    !bpf_type_has_unsafe_modifiers(info->reg_type) &&
> +	    info->btf_id == sock_id)
> +		info->btf_id = smc_sock_id;
> +
> +	return true;
> +}
> +
> +static const struct bpf_verifier_ops bpf_smc_negotiator_verifier_ops = {
> +	.get_func_proto  = smc_negotiator_prog_func_proto,
> +	.is_valid_access = smc_negotiator_prog_is_valid_access,
> +};
> +
> +struct bpf_struct_ops bpf_smc_sock_negotiator_ops = {
> +	.verifier_ops = &bpf_smc_negotiator_verifier_ops,
> +	.init = bpf_smc_negotiator_init,
> +	.check_member = bpf_smc_negotiator_check_member,
> +	.init_member = bpf_smc_negotiator_init_member,
> +	.reg = bpf_smc_negotiator_reg,
> +	.update = bpf_smc_negotiator_update,
> +	.unreg = bpf_smc_negotiator_unreg,
> +	.validate = bpf_smc_negotiator_validate,
> +	.name = "smc_sock_negotiator_ops",
> +};
> \ No newline at end of file

Empty line at the end?


