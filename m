Return-Path: <netdev+bounces-4086-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92CC670AC44
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 05:59:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FB2F1C209AD
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 03:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C33B81D;
	Sun, 21 May 2023 03:59:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C63A819;
	Sun, 21 May 2023 03:59:20 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7ED103;
	Sat, 20 May 2023 20:59:19 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34L3lwbV020136;
	Sat, 20 May 2023 20:58:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=krOn2oJrQESUkVNcIzn/LOJAf78dVPtsRL13NvHjc9Y=;
 b=DK8/9YtvGIUOPdMU5koP3+c0jqJ0DkXomgkDjd3LYDVBAWeiKzb/sAJyV/V8HbzHgn/Q
 DpFuhrrcxhnILToINWL2LCDhcUYKwjnxT5uUS3R3tRPH8ll23dlJVFLqqTq0hMK7KHJl
 U86MKlndd1MeCiSBhver8GQZhcIl/qMyWg8SBUPIxIPkvExpM7o7SSDquw+HJhf5uYZm
 Z3td346vcND+L5CYh0JRKOC39kIg6xj0/TcoMRTwqmhGgDFMvoKSDPCzriKIetmD+rTQ
 nDmOdmGkFQ8HWbICpMTCk/nSaeiMhw/qKFYnWG1rGQwfTJKu5N1eZ/FCV2gquDffyBdW xg== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qpuwqbpgv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 20 May 2023 20:58:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjx2kAAXq/bKv9C60wk6j2MFhb3LLENAYPkHopfqeQl37HmkYapUCHQu6dju7DwCD/UuGH7+e5UXXCkBWzA5KOgMmG6igYjQkR7ro6l4ErxBp5BtsSnR28AqWonJtNIuvkeyHkXRIbh47fRRsm8uuhh1jvlifsEooDzziRrsC//auv/rA+qMsk3wgXVMT5m+Zh0Q8E6VhEi5tFNBu6Ix8hxwL5YEzKbJbcvmg1Tk0ar7VXd8yFrD7LK8NTxBHKD/YOTMFS33VY5Vq78NIAmgVGys69ZemIqpoCEpQTPBnZfcHwUbAzRSePqpsOLyaeARNE2U5d3nOO1XC1BLfzQ6Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=krOn2oJrQESUkVNcIzn/LOJAf78dVPtsRL13NvHjc9Y=;
 b=K8k8oVJBwjThfegtk/MkmBzqDBXVcOF7riOlW2bpSvbb1NnEFBMe+Bb+ohnslBSlqHKdMRq2f4VGdmuTg3X+FRgrka7Lh5HyYVKWMqoYtqOauYc+cuSNmUCVYhU85uWR1JcTWqzV0gx2djYJoaLjDxBqLbKqLPTHNzq9HAQfuheCUhmq7UfbRkbooAwYSp+q5yH5xprb+D7ZmfvrcStmwVVUJ2Z3b99rEAaDur7oLaaSF5Km56G2HECq46LWkg9hS/qIPH4ObRVejm0/k5KEJL13MIiDhLaANxvQmXRGkKUQNxHDXpBGclq+dVxdbfRIK3gUYejHPSda2T+4aoQPeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM6PR15MB3912.namprd15.prod.outlook.com (2603:10b6:5:2ba::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.27; Sun, 21 May
 2023 03:58:31 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53%7]) with mapi id 15.20.6411.027; Sun, 21 May 2023
 03:58:31 +0000
Message-ID: <b4f66729-90ab-080a-51ec-bf435ad6199d@meta.com>
Date: Sat, 20 May 2023 20:58:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re:
Content-Language: en-US
To: Ze Gao <zegao2021@gmail.com>, jolsa@kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, Hao Luo <haoluo@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>,
        Masami Hiramatsu <mhiramat@kernel.org>, Song Liu <song@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, kafai@fb.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, paulmck@kernel.org, songliubraving@fb.com,
        Ze Gao <zegao@tencent.com>
References: <20220515203653.4039075-1-jolsa@kernel.org>
 <20230520094722.5393-1-zegao@tencent.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <20230520094722.5393-1-zegao@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0233.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::28) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|DM6PR15MB3912:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a0e4438-c3a5-4b86-aa3d-08db59afa416
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	GXq90qkSZsjyUZkkibT5QmBP59O4aIJUKXjNxmHqBxyvzTO3cFqCRPSteG7Boryf4JuMgMxD0doe0+MRg+e9NuZVVDMtc/4qPa9BVfuUv3a+jTF92XmqnFn3n7frMBpuDbXDRpRP3+sSbNrlVM/8T5QT7Uy8JRd1WQ35WdwXJVuS+2uLYdp3YyNLS6jJWgdtW2Cp8buUtnZAATQA7VHZcrbVDMU4Sjsi24Yo+OLFJ2Pn5VcIwiPmIfpH4WiXqpisbV1nMsDOtc/P7FVjm4SBO6jhylGifeJOPDajDwNcU8m62obT8AS8fe/5cHXJzSPdgL7W3q7PSOMuP0cLdR71X1y9N3dhuigRgNxozIgJ4QHU4WcHYqzxVmHH3ZskH1FBHTOrjqiMZACXBjEJtcPPKlhpjEArMOf+a5D5ysESwQODISwnYsPuoTlz7/l3v3NKu5tkvy5Xhp6VVTxyyyR0uXZhJtf4rqxKPTJ+lwOOiHUCyLJzxPy4cJOt3av9ohPqp8Nk8jvTH8ly3J36tqBr+aVciOMMujm1ChUiohNTPWT3nhY+3G5YsAbu3tEYJujXSMxTOICG0huyF5zSmn6QMuIxo4S6fBYUTOEoFKuCfETtUQUYWu1RJjCwMJIo7iTWHLtE5YUy1dE/nJ/+1zFfyQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199021)(8936002)(8676002)(5660300002)(7116003)(7416002)(83380400001)(3480700007)(53546011)(186003)(6512007)(6506007)(2616005)(31696002)(86362001)(38100700002)(41300700001)(6666004)(6486002)(478600001)(66476007)(66556008)(66946007)(4326008)(316002)(36756003)(54906003)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?OTdpdk10SENHSTFoS2NHbTRtb2ZwQys5QnVCVUZMS3RHS2ZPaVZoV21uUDV1?=
 =?utf-8?B?cGljUFF1eWUweGIzN0xodlBDdmVianFBWWlmODRaUVYzV2pTNWRVVnBUakFs?=
 =?utf-8?B?TW9qenB6OFQ3alIwVTlQS0xWYmZIWUUwK0VoQkFHMGNxbmpjYTVwbEhmZWRw?=
 =?utf-8?B?UGdvb1oyTmN1aFdOc3J2OVB4UHU4a0x3d1o2dnZRYmVLWm9IbWJNam9XNm1w?=
 =?utf-8?B?RVhJVUpmbXA3QytucGk3dzFObnFVZWVDRmIyNFYzWlV1TzZqMUVoZm5GR0pI?=
 =?utf-8?B?NlFjNGgvUjF4NUFuWS9CWkY1VTNTVytpakh5QjhmL2EvcEYzMjJUNEc5V2tI?=
 =?utf-8?B?ZmNBMnE2Sk1TMG5zM3d1bDBra3plY2FiV0k5a2hyZmZtOHVKWVd6Z3hBN1lC?=
 =?utf-8?B?NC9oR29UNkgrTFZ1Y05GU1pXblZ5aXdTMzIyYzk2UGlnd1RRUEphY04wTDAr?=
 =?utf-8?B?SkNjVTRuSVlINHIzVHAzUWR3QzFORW1RcStJamlXTWJiYS9TWTJFTktjZENN?=
 =?utf-8?B?NThOVEwvWVNPR3dNaHdldXltditrRENKUGU2Si90RTEyWnlESUtrczFXQysx?=
 =?utf-8?B?Ty8yeC9Dd2dadFBuRE9WdU4ycFJtNVJieUNTMTlRcGRBaU9TVWVpUk1LNUZi?=
 =?utf-8?B?ekFUR0ozOWw4ZzdBMTI1bEhiT2xSWGp1WVkzQWVxbUlna1h4c0Fzdi9KTXUw?=
 =?utf-8?B?SU9XR2dKcUthQmpaaUdaS1habURKelMrRVEySEkzQzVqS0tFdXozcnlmYVhL?=
 =?utf-8?B?SUhjWlI2RklGd1NnWHdsYXBkdVdESy9kVDhvWm8wbVdpQmR0UHl3ZDFneks1?=
 =?utf-8?B?bXlUcGNwNmdTTkt0N2pLNnRKM0wyNnJMdjVOUGxocWtMQXpWeDVqb0o3YytM?=
 =?utf-8?B?ZThHWjJKNjBFLzd3dXNYM2hzMGRWRDN3ZDFpNlJ5RFZLNEZnbWZFQklrZ0Y0?=
 =?utf-8?B?SlRNK2pad1gvM3FRSFd6MTN3cnFKVVZBak9leE51TDBzZFd4eVVoU1ArZnA4?=
 =?utf-8?B?NUp0TmtjeGNsMmlNbGRSVGZFVjRmbnRNajJrWXlnT2M1MjNrb2xHazNFbWVk?=
 =?utf-8?B?N21LUGYreE53bks0OG9VR0xWUllENUVBSFhSTjZmYjJJaWRkMFdiSjVsSVV4?=
 =?utf-8?B?SUFkVytYTHJ2NWlheDRRZHZoUm84VHFTeHJvMFZOZWlXMVBFNlBUcGNPcEtn?=
 =?utf-8?B?eW4xQVdMOXRzVi9vUTN4c1VGV2tMczZNay95ZFgvOUJxUGJsYXdncVdEMm9y?=
 =?utf-8?B?Z1lyalpTRFU5TDZuVXF5OFZpZ0x1YXFJQVdNZGJ5V2IvS0g3YlRNa2tHUTF5?=
 =?utf-8?B?VXZvWUNwaTVPSHlxSUZkUVJCMFlLdmZhc0RvT0k0YVJzTjEzLzRzNWdjSERW?=
 =?utf-8?B?Q3BSZk1JZWVqekttYkNRaXU4WGwwSWhsOE1PNlpoSWZtVWc5bXF6OVVSQXVs?=
 =?utf-8?B?Nmk2K0psbEE3OFdjYUFzR3E4ZVg4b1RZMmdHcXozU2YyQnFZeERjVzdZQk9U?=
 =?utf-8?B?RVdhVmd5eFpMNGdCMHZnS3lKK3h0YkVTTzN2NFdOa3M1SDhFU29UM2lvU3lC?=
 =?utf-8?B?bnRuZlNDOWdZWmowRzZLczYrVGhyTUIxVmJWalJjUStCREZldndYNngxRHZF?=
 =?utf-8?B?TnVDYi9oVzJyQ2V0bW9RWGY1MSthWlFEbFJvMm9lZlpDWHBIRjF6VzB0VFpY?=
 =?utf-8?B?WjUzZ3Vhbm9WWDAyNVhKTE1KbzNpUWdpQWcxb3Zlbjh3U3F4akcwdndMS0RY?=
 =?utf-8?B?QWtaWDZzL1JRM3NqRTNScFFqWXlkbmtuQ1Zkaml1Z1ZibE1hSXo0bTIzUXY0?=
 =?utf-8?B?SUdZTmp2U2dVc1NwWTdPbDcrMm95cmtkdUZrcHBhOE05WEJHNkZrMmtKeWhw?=
 =?utf-8?B?OU4vUEFaT1FhYWs4R3dTQjNEdEhSZDlHbUd5OHgzY0hRK0IvV292TU94ZEl2?=
 =?utf-8?B?clV4cmVENE1WWjcvdVJxNGh5dXZtSk5sVE4yZDNyb0lMcTdQanlFZGlFcGNY?=
 =?utf-8?B?dHdMR0hRSElhMmdlZ3BqekZWekVYU0JvL0RVVnF1NVZjOWtaVjBvbEhuOTlv?=
 =?utf-8?B?eFAvZkFkUmlXTmYzd2pSMDRVWUQvLzJaVHdYM1RiYUR4NmtRbk1sSm9oOCth?=
 =?utf-8?B?YVZ3YUpxU2tlVEFPWm5RMXgzVDJxbGdDdGdnemVCZVJHZVBxTG1Qdk5XNmh4?=
 =?utf-8?B?SlE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a0e4438-c3a5-4b86-aa3d-08db59afa416
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2023 03:58:31.1530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YGw3PU7CgxNYG151VBjH0UfkHHq3hkAjhOFUnzjSfJZMdrEFREQm/xFBUnEYHZ9O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3912
X-Proofpoint-ORIG-GUID: SYnOvrOtduPz7Lulv5jIEqEXjk1szRyy
X-Proofpoint-GUID: SYnOvrOtduPz7Lulv5jIEqEXjk1szRyy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-21_01,2023-05-17_02,2023-02-09_01
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/20/23 2:47 AM, Ze Gao wrote:
> 
> Hi Jiri,
> 
> Would you like to consider to add rcu_is_watching check in
> to solve this from the viewpoint of kprobe_multi_link_prog_run
> itself? And accounting of missed runs can be added as well
> to imporve observability.
> 
> Regards,
> Ze
> 
> 
> -----------------
>  From 29fd3cd713e65461325c2703cf5246a6fae5d4fe Mon Sep 17 00:00:00 2001
> From: Ze Gao <zegao@tencent.com>
> Date: Sat, 20 May 2023 17:32:05 +0800
> Subject: [PATCH] bpf: kprobe_multi runs bpf progs only when rcu_is_watching
> 
>  From the perspective of kprobe_multi_link_prog_run, any traceable
> functions can be attached while bpf progs need specical care and
> ought to be under rcu protection. To solve the likely rcu lockdep
> warns once for good, when (future) functions in idle path were
> attached accidentally, we better paying some cost to check at least
> in kernel-side, and return when rcu is not watching, which helps
> to avoid any unpredictable results.

kprobe_multi/fprobe share the same set of attachments with fentry.
Currently, fentry does not filter with !rcu_is_watching, maybe
because this is an extreme corner case. Not sure whether it is
worthwhile or not.

Maybe if you can give a concrete example (e.g., attachment point)
with current code base to show what the issue you encountered and
it will make it easier to judge whether adding !rcu_is_watching()
is necessary or not.

> 
> Signed-off-by: Ze Gao <zegao@tencent.com>
> ---
>   kernel/trace/bpf_trace.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 9a050e36dc6c..3e6ea7274765 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2622,7 +2622,7 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
>   	struct bpf_run_ctx *old_run_ctx;
>   	int err;
>   
> -	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
> +	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1 || !rcu_is_watching())) {
>   		err = 0;
>   		goto out;
>   	}

