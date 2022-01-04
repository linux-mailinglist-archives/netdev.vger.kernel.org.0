Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCBF84846D7
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbiADRQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:16:29 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:37492 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234294AbiADRQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 12:16:27 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 204GIfiV014246;
        Tue, 4 Jan 2022 17:16:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=fHL9fZ6CiFsAkBrMDUbDbI0wE+i30WqRzn5M8pP++WI=;
 b=IMpYv7Bw6D3WNXHjrmY4/TheDQm9lvz1RMdMWG02SNGy+VlrMTod7fePvWjHd70c7v0x
 kRn5EjXGxU3kb5+sAu7R2WJD9F6VQQ0UOwUyo9ZHVCN+180hCVN8Xk8aNTPl4qBC8SvS
 dP7RrdiCxB9LwLeUWMYWQ76Kc2xT4dvz3THx1RLLkbWyZrV1H6+ME4GHvUNR6QT0B79x
 5oI0GOC0lfnvoNkQeKaxK3AO/PCEb+FFA7DKzPibGh/Hky/BkP34OJ8/p2UjLPvy1sZ4
 919pWeKvMmWUp1k/M+6vOYanD5R8aYUPSldCCc88c+6rXHbN2Oq7L/cXR7+/knRraYy+ mA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc9d91x9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jan 2022 17:16:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 204HFbPZ022447;
        Tue, 4 Jan 2022 17:16:02 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by aserp3020.oracle.com with ESMTP id 3daes3yuac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jan 2022 17:16:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wh7y/xPt8EsaBG3vB2wWpifnCj3W5eEIYNfFBtFyemfdOdg/gA9ZKplZPUMpEl6ezxKShqcNwNpTwYGawUAnOJbQnRNiaN8PqkoHo7mEL6ap0fg9szfllnli0UybSIMcT+8wQNJJC/4WN1brzR0vOyUXq7eHhbtFY8YoG+CN6vQyuSFJ+d5gn3abuCGmKYF6e6KOvjiXNdDC0oGp4BLMrwSPZHael6Q6DUNNGJyXFJzUYsYXgesMmosJu+wIawtw8au8KlaBhcQUp/L0kyfStFIIXU8m0efX3zMjR6r7mZhiAgqs9I4DRyeZ6CR3P+0OomcG6SigteOjpMBW42VjTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fHL9fZ6CiFsAkBrMDUbDbI0wE+i30WqRzn5M8pP++WI=;
 b=JfBrf6dp5MjhLMeUVtFJGZDYmz6ON/HfAqqS8GJXR35CIbmxQMQYjP4d7WKChQks3wFIosAE3wXStF3aYiUmZw6jKpyPjt6NzGoKp6MZ7ccLg4E22e6yO0n41+4V1l3Zs9AvhwetmeAp9yKmAOU6QAceZ65FXuFA2J/vzTXmWDFriHDDFhMNVgimZtlVw8P0LDiJ29Flo/uimU2qiFwL+NPlHeZ+O4yYFXh6FbyMjWPYXSouiifPr/8C9ft5GTZ6IzAz8BFZVhs+b0CsxLbq+oX6DGOcXpTmZjaamTPnIGi4B9yA72Xet+m13KNwwknW+v3moiq0zta+sieORACH1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHL9fZ6CiFsAkBrMDUbDbI0wE+i30WqRzn5M8pP++WI=;
 b=lslgiRGpKrcVEz4LrG78amZiCXSFd//mPgmcWYU+OzLnd+O2jauDlmYY3dHGA3+e2krY+vJYsKEzVWUvd6zVPED6s9QTfVIBlcwECLtV275Elx6vN8ZKRA/GyFNpSPpT0b19Kq4Tjdbjh+fssWFFNr+2scBMJBhN78a/y12Djws=
Received: from SN6PR10MB2975.namprd10.prod.outlook.com (2603:10b6:805:d2::10)
 by SN6PR10MB2974.namprd10.prod.outlook.com (2603:10b6:805:cb::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Tue, 4 Jan
 2022 17:16:00 +0000
Received: from SN6PR10MB2975.namprd10.prod.outlook.com
 ([fe80::208b:c637:9c1b:758f]) by SN6PR10MB2975.namprd10.prod.outlook.com
 ([fe80::208b:c637:9c1b:758f%6]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 17:16:00 +0000
Date:   Tue, 4 Jan 2022 12:15:57 -0500
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v7 bpf-next 08/11] bpf: Implement verifier support for
 validation of async callbacks.
Message-ID: <20220104171557.GB1559@oracle.com>
References: <20210715005417.78572-1-alexei.starovoitov@gmail.com>
 <20210715005417.78572-9-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715005417.78572-9-alexei.starovoitov@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: BYAPR07CA0059.namprd07.prod.outlook.com
 (2603:10b6:a03:60::36) To SN6PR10MB2975.namprd10.prod.outlook.com
 (2603:10b6:805:d2::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76215d26-81e6-498f-b3a3-08d9cfa5e0fc
X-MS-TrafficTypeDiagnostic: SN6PR10MB2974:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB29742DC7ECC8EAFD55EDEF7DC24A9@SN6PR10MB2974.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yU4zKVkzIpJ7Ax1ZcsPFudYNLE9k/K1oM5UxWm+42GZECFpq6eLl57iq0igx7LcSAEy41bFKZE7WYemkYfRooWZ6hdRA8opuEG3YPTi7kGXd2Kt3f8S9FXy70sqJo4TiZMmd0zmwuyy2tF4lniNTlGRMM6fcA2S3e8g2euLaaBvsmEEUlwHe9U1HDcm1uq42/4fbboO+EgN/yZopj7VaNWEkoFzSvGLSmz2lCHJnt9y5tWMdIvW7rz/6mUMFJ/jjHH86CscbOGPGS9TivCKoxOO2yYl8tUvtV7X1btAONcv+SwEBmZ81/MCV0TZDygfc+70fpWVG6wKE8iiajdV4hGlkTK7aicEihfhMWwy/aKsJJTQNpW6WfUwsrMzeyfIuLb+h5gfn4b0TM+RahcZswQWdn6K5q54qbiF3cVkBsUhJp/j631/Oo69fgIM7eStcm3jpRsJn4J4d3IORw4YWYskXSW8sNhwR6ZWLSUaHGyTA6iuuObjOdHtTaj9JLQ72inBjffB8cxc+yblra4p8JFjtGZQlNGVZdPP+tmbydlDe0QEuQqSe236gxBJWRzmaJO/gOnZKVNvAgtto6vWPgmL6yJbqK7RQENTlnCmlMrwbpdhk/TeqaA80guBradFSQnaK38i2WOGAraYDzODzzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2975.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(316002)(30864003)(2906002)(38100700002)(6486002)(8936002)(2616005)(6512007)(5660300002)(6916009)(66556008)(66476007)(33656002)(66946007)(52116002)(186003)(1076003)(36756003)(508600001)(86362001)(83380400001)(4326008)(8676002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bsDzA5EkUZilN5woT3nvprfzL5DzOT69QRMiA9PAsMtG+HrpxQWGdUksn2uj?=
 =?us-ascii?Q?LsIYEfIgP0M33abtJSW6gOEBCYF3XD2iWnCa5Xe6hKOoPDgVuNFunEHXpAkP?=
 =?us-ascii?Q?Gny5w++6uXqMPpDW4bzyCNAtlgyM4PdlWEIKCH2l9DRrqmNzCF0t/IR7I4m2?=
 =?us-ascii?Q?QHuUsMBCdLJaUeMfYtuinE7/5ZDzhzwkuv86lMKU4+FjywrB6zog2nvOj6fC?=
 =?us-ascii?Q?pZS4Whtx6lZ93oNtoL4ynhz93n3nyRi8Iytz7KlBJGfiXhMWyoUIhqf5SWUe?=
 =?us-ascii?Q?6USYmHZ3oamnYHHFyjssFRBNIZcdvtPji8tk2f/5e3dJ/xbnAOzP2HJOg/dG?=
 =?us-ascii?Q?SiXWngS6Empnd0VrtZgWdypAJyWxicgZrHF3agre+cMIii8XH0MYGOiGSnFN?=
 =?us-ascii?Q?eNfDUeTrEEEdjx5MU45oQhG3vDpY0GP9/HEq+1W0ifd2I1mooj0nyF2Z0pR2?=
 =?us-ascii?Q?ad7isa6/4G6H13DIsXWgBLB+bIJdr+6WwHQm26TZmnGlUYmzA+3rVlxfuidN?=
 =?us-ascii?Q?zXnSVa0cKFf6xANCOMtlyj4kqWUrcwvTHJ5RCQ51J0xx+diCtzRGeVBlMfiX?=
 =?us-ascii?Q?i95mRwP8w9wOeVyecg8JGvkJCPGmPKMpCSxLjowX7IvrZtRZysaRz7cuNFOT?=
 =?us-ascii?Q?nOFcZ1E3IxVldjEpKHbWh13zUFZjw6ybX5Cp9lweIMT19NE0bUsdh/AoQ4sF?=
 =?us-ascii?Q?0kDNlD2Ry+lwaDVZQH8TFu/ZGuhuW9PK4tcEFyvMFio8jbk5P/o75zuCaxBH?=
 =?us-ascii?Q?dDmXxB09Cj/lnDPW2GTjGiggaehUQ/GoF5mitGqW9efxeNEKv5siabfH4q8v?=
 =?us-ascii?Q?QWfloVm2zfIkaP5rmVWrmp0fu6clraq7hwoo5G5goYv7AhrH2wGFBi0prweY?=
 =?us-ascii?Q?hD6EgSBSxmOHTBz6IyYKUCJQUJTHo8jZJw9H9KAu/giXoNixHiomtebQFvpn?=
 =?us-ascii?Q?VWSu2eyRg5u4mpJdGGz48KP8aLCbZe3tgAfi6As3VfgXC12PC1d5yqHuF74T?=
 =?us-ascii?Q?pVmMmgymhsFt+0QUsblvB3npkVRuyz/xYE9bMcelD6Sdj6QT4hyfDXHKF5cs?=
 =?us-ascii?Q?yoBuWA+mqpnoFqwghczCBXM17A2EY/no+sm8WGUEEfx4xXmr8dscpXmgRzSi?=
 =?us-ascii?Q?pvb3quzQCBMG68BDWnzquCDfrL+WEYfMdcWeET88bl/6A5KqhKHcP5tlx+jt?=
 =?us-ascii?Q?7ZJnsORJuZDJ6biBVpzymzBtmR2fcDwhwHstjWvA6lRVvmBTUf3wWTCcQmZx?=
 =?us-ascii?Q?zrtoPHm0SCDQRpqxtGav8bUizML+yB4Mfkr0etO7huDMdquQlTd+02MN6Yx8?=
 =?us-ascii?Q?R5WAgHvcB4BukcJZpE9lmfdTnSEznDUW8SIQos8kcq5yAm+1UmCG4gPMQxWc?=
 =?us-ascii?Q?xPF5rf+P823xJBPPle0CmzgUJpC+YJQPHzX8WjbDy4qkB52SN43neZjmcRKC?=
 =?us-ascii?Q?W8uvdoRGorbjmmnc1mIgGKXm2Agqz4npnGJbYLwEvLtNYcl4GSQjryOPKOyH?=
 =?us-ascii?Q?eelWNBxi/vr8Y8EfhOGjkG3m5R8xnJX5j/g6ldrr4XgOI5Ph6R/Kf5PJmGuV?=
 =?us-ascii?Q?gCpWNBj/tf/SU/ygR4psW9XNLtUCNtp2UZCTgefc5wSqat4/KtGt2M5BNqcY?=
 =?us-ascii?Q?yrUssbWtqrlAp7buU0KoT5VrhYosbiC3ycW+aut2lWqf6ekPDQ5L5twjelrS?=
 =?us-ascii?Q?JAy9jUzINuw/KELP2MFrvpxOfeYSzr2Rodx6CC4ypOYlM+T2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76215d26-81e6-498f-b3a3-08d9cfa5e0fc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2975.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 17:16:00.4596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8XUWJy/Xk5awUOziLznjpIbTVUNwYvYBv6mvT1PQbfJDvqxNNfFQ2ifUk9vH8eSA/+6MqHysEHjgPJLZ5zgSPOI5XYIEYsYy6fejHQZdrI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2974
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10216 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201040116
X-Proofpoint-ORIG-GUID: bfHY0OkK_dN2LiiSX9T5CEAnhJfJB0Ns
X-Proofpoint-GUID: bfHY0OkK_dN2LiiSX9T5CEAnhJfJB0Ns
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I ran into a problem due to this patch.  Specifically, the test in the
__check_func_call() function is flaweed because it can actually mis-interpret
a regular BPF-to-BPF pseudo-call as a callback call.

Consider the conditional in the code:

	if (insn->code == (BPF_JMP | BPF_CALL) &&
	    insn->imm == BPF_FUNC_timer_set_callback) {

The BPF_FUNC_timer_set_callback has value 170.  This means that if you have
a BPF program that contains a pseudo-call with an instruction delta of 170,
this conditional will be found to be true by the verifier, and it will
interpret the pseudo-call as a callback.  This leads to a mess with the
verification of the program because it makes the wrong assumptions about the
nature of this call.

As far as I can see, the solution is simple.  Include an explicit check to
ensure that src_reg is not a pseudo-call.  I.e. make the conditional:

	if (insn->code == (BPF_JMP | BPF_CALL) &&
	    insn->src_reg != BPF_PSEUDO_CALL &&
	    insn->imm == BPF_FUNC_timer_set_callback) {

It is of course a pretty rare case that this would go wrong, but since my
code makes extensive use of BPF-to-BPF pseudo-calls, it was only a matter of
time before I would run into a call with instruction delta 170.

	Kris

On Wed, Jul 14, 2021 at 05:54:14PM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> bpf_for_each_map_elem() and bpf_timer_set_callback() helpers are relying on
> PTR_TO_FUNC infra in the verifier to validate addresses to subprograms
> and pass them into the helpers as function callbacks.
> In case of bpf_for_each_map_elem() the callback is invoked synchronously
> and the verifier treats it as a normal subprogram call by adding another
> bpf_func_state and new frame in __check_func_call().
> bpf_timer_set_callback() doesn't invoke the callback directly.
> The subprogram will be called asynchronously from bpf_timer_cb().
> Teach the verifier to validate such async callbacks as special kind
> of jump by pushing verifier state into stack and let pop_stack() process it.
> 
> Special care needs to be taken during state pruning.
> The call insn doing bpf_timer_set_callback has to be a prune_point.
> Otherwise short timer callbacks might not have prune points in front of
> bpf_timer_set_callback() which means is_state_visited() will be called
> after this call insn is processed in __check_func_call(). Which means that
> another async_cb state will be pushed to be walked later and the verifier
> will eventually hit BPF_COMPLEXITY_LIMIT_JMP_SEQ limit.
> Since push_async_cb() looks like another push_stack() branch the
> infinite loop detection will trigger false positive. To recognize
> this case mark such states as in_async_callback_fn.
> To distinguish infinite loop in async callback vs the same callback called
> with different arguments for different map and timer add async_entry_cnt
> to bpf_func_state.
> 
> Enforce return zero from async callbacks.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  include/linux/bpf_verifier.h |   9 ++-
>  kernel/bpf/helpers.c         |   8 +--
>  kernel/bpf/verifier.c        | 123 ++++++++++++++++++++++++++++++++++-
>  3 files changed, 131 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index 5d3169b57e6e..242d0b1a0772 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -208,12 +208,19 @@ struct bpf_func_state {
>  	 * zero == main subprog
>  	 */
>  	u32 subprogno;
> +	/* Every bpf_timer_start will increment async_entry_cnt.
> +	 * It's used to distinguish:
> +	 * void foo(void) { for(;;); }
> +	 * void foo(void) { bpf_timer_set_callback(,foo); }
> +	 */
> +	u32 async_entry_cnt;
> +	bool in_callback_fn;
> +	bool in_async_callback_fn;
>  
>  	/* The following fields should be last. See copy_func_state() */
>  	int acquired_refs;
>  	struct bpf_reference_state *refs;
>  	int allocated_stack;
> -	bool in_callback_fn;
>  	struct bpf_stack_state *stack;
>  };
>  
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 74b16593983d..9fe846ec6bd1 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -1043,7 +1043,6 @@ static enum hrtimer_restart bpf_timer_cb(struct hrtimer *hrtimer)
>  	void *callback_fn;
>  	void *key;
>  	u32 idx;
> -	int ret;
>  
>  	callback_fn = rcu_dereference_check(t->callback_fn, rcu_read_lock_bh_held());
>  	if (!callback_fn)
> @@ -1066,10 +1065,9 @@ static enum hrtimer_restart bpf_timer_cb(struct hrtimer *hrtimer)
>  		key = value - round_up(map->key_size, 8);
>  	}
>  
> -	ret = BPF_CAST_CALL(callback_fn)((u64)(long)map,
> -					 (u64)(long)key,
> -					 (u64)(long)value, 0, 0);
> -	WARN_ON(ret != 0); /* Next patch moves this check into the verifier */
> +	BPF_CAST_CALL(callback_fn)((u64)(long)map, (u64)(long)key,
> +				   (u64)(long)value, 0, 0);
> +	/* The verifier checked that return value is zero. */
>  
>  	this_cpu_write(hrtimer_running, NULL);
>  out:
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 1511f92b4cf4..ab6ce598a652 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -735,6 +735,10 @@ static void print_verifier_state(struct bpf_verifier_env *env,
>  			if (state->refs[i].id)
>  				verbose(env, ",%d", state->refs[i].id);
>  	}
> +	if (state->in_callback_fn)
> +		verbose(env, " cb");
> +	if (state->in_async_callback_fn)
> +		verbose(env, " async_cb");
>  	verbose(env, "\n");
>  }
>  
> @@ -1527,6 +1531,54 @@ static void init_func_state(struct bpf_verifier_env *env,
>  	init_reg_state(env, state);
>  }
>  
> +/* Similar to push_stack(), but for async callbacks */
> +static struct bpf_verifier_state *push_async_cb(struct bpf_verifier_env *env,
> +						int insn_idx, int prev_insn_idx,
> +						int subprog)
> +{
> +	struct bpf_verifier_stack_elem *elem;
> +	struct bpf_func_state *frame;
> +
> +	elem = kzalloc(sizeof(struct bpf_verifier_stack_elem), GFP_KERNEL);
> +	if (!elem)
> +		goto err;
> +
> +	elem->insn_idx = insn_idx;
> +	elem->prev_insn_idx = prev_insn_idx;
> +	elem->next = env->head;
> +	elem->log_pos = env->log.len_used;
> +	env->head = elem;
> +	env->stack_size++;
> +	if (env->stack_size > BPF_COMPLEXITY_LIMIT_JMP_SEQ) {
> +		verbose(env,
> +			"The sequence of %d jumps is too complex for async cb.\n",
> +			env->stack_size);
> +		goto err;
> +	}
> +	/* Unlike push_stack() do not copy_verifier_state().
> +	 * The caller state doesn't matter.
> +	 * This is async callback. It starts in a fresh stack.
> +	 * Initialize it similar to do_check_common().
> +	 */
> +	elem->st.branches = 1;
> +	frame = kzalloc(sizeof(*frame), GFP_KERNEL);
> +	if (!frame)
> +		goto err;
> +	init_func_state(env, frame,
> +			BPF_MAIN_FUNC /* callsite */,
> +			0 /* frameno within this callchain */,
> +			subprog /* subprog number within this prog */);
> +	elem->st.frame[0] = frame;
> +	return &elem->st;
> +err:
> +	free_verifier_state(env->cur_state, true);
> +	env->cur_state = NULL;
> +	/* pop all elements and return */
> +	while (!pop_stack(env, NULL, NULL, false));
> +	return NULL;
> +}
> +
> +
>  enum reg_arg_type {
>  	SRC_OP,		/* register is used as source operand */
>  	DST_OP,		/* register is used as destination operand */
> @@ -5704,6 +5756,30 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
>  		}
>  	}
>  
> +	if (insn->code == (BPF_JMP | BPF_CALL) &&
> +	    insn->imm == BPF_FUNC_timer_set_callback) {
> +		struct bpf_verifier_state *async_cb;
> +
> +		/* there is no real recursion here. timer callbacks are async */
> +		async_cb = push_async_cb(env, env->subprog_info[subprog].start,
> +					 *insn_idx, subprog);
> +		if (!async_cb)
> +			return -EFAULT;
> +		callee = async_cb->frame[0];
> +		callee->async_entry_cnt = caller->async_entry_cnt + 1;
> +
> +		/* Convert bpf_timer_set_callback() args into timer callback args */
> +		err = set_callee_state_cb(env, caller, callee, *insn_idx);
> +		if (err)
> +			return err;
> +
> +		clear_caller_saved_regs(env, caller->regs);
> +		mark_reg_unknown(env, caller->regs, BPF_REG_0);
> +		caller->regs[BPF_REG_0].subreg_def = DEF_NOT_SUBREG;
> +		/* continue with next insn after call */
> +		return 0;
> +	}
> +
>  	callee = kzalloc(sizeof(*callee), GFP_KERNEL);
>  	if (!callee)
>  		return -ENOMEM;
> @@ -5856,6 +5932,7 @@ static int set_timer_callback_state(struct bpf_verifier_env *env,
>  	/* unused */
>  	__mark_reg_not_init(env, &callee->regs[BPF_REG_4]);
>  	__mark_reg_not_init(env, &callee->regs[BPF_REG_5]);
> +	callee->in_async_callback_fn = true;
>  	return 0;
>  }
>  
> @@ -9224,7 +9301,8 @@ static int check_return_code(struct bpf_verifier_env *env)
>  	struct tnum range = tnum_range(0, 1);
>  	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
>  	int err;
> -	const bool is_subprog = env->cur_state->frame[0]->subprogno;
> +	struct bpf_func_state *frame = env->cur_state->frame[0];
> +	const bool is_subprog = frame->subprogno;
>  
>  	/* LSM and struct_ops func-ptr's return type could be "void" */
>  	if (!is_subprog &&
> @@ -9249,6 +9327,22 @@ static int check_return_code(struct bpf_verifier_env *env)
>  	}
>  
>  	reg = cur_regs(env) + BPF_REG_0;
> +
> +	if (frame->in_async_callback_fn) {
> +		/* enforce return zero from async callbacks like timer */
> +		if (reg->type != SCALAR_VALUE) {
> +			verbose(env, "In async callback the register R0 is not a known value (%s)\n",
> +				reg_type_str[reg->type]);
> +			return -EINVAL;
> +		}
> +
> +		if (!tnum_in(tnum_const(0), reg->var_off)) {
> +			verbose_invalid_scalar(env, reg, &range, "async callback", "R0");
> +			return -EINVAL;
> +		}
> +		return 0;
> +	}
> +
>  	if (is_subprog) {
>  		if (reg->type != SCALAR_VALUE) {
>  			verbose(env, "At subprogram exit the register R0 is not a scalar value (%s)\n",
> @@ -9496,6 +9590,13 @@ static int visit_insn(int t, int insn_cnt, struct bpf_verifier_env *env)
>  		return DONE_EXPLORING;
>  
>  	case BPF_CALL:
> +		if (insns[t].imm == BPF_FUNC_timer_set_callback)
> +			/* Mark this call insn to trigger is_state_visited() check
> +			 * before call itself is processed by __check_func_call().
> +			 * Otherwise new async state will be pushed for further
> +			 * exploration.
> +			 */
> +			init_explored_state(env, t);
>  		return visit_func_call_insn(t, insn_cnt, insns, env,
>  					    insns[t].src_reg == BPF_PSEUDO_CALL);
>  
> @@ -10503,9 +10604,25 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
>  		states_cnt++;
>  		if (sl->state.insn_idx != insn_idx)
>  			goto next;
> +
>  		if (sl->state.branches) {
> -			if (states_maybe_looping(&sl->state, cur) &&
> -			    states_equal(env, &sl->state, cur)) {
> +			struct bpf_func_state *frame = sl->state.frame[sl->state.curframe];
> +
> +			if (frame->in_async_callback_fn &&
> +			    frame->async_entry_cnt != cur->frame[cur->curframe]->async_entry_cnt) {
> +				/* Different async_entry_cnt means that the verifier is
> +				 * processing another entry into async callback.
> +				 * Seeing the same state is not an indication of infinite
> +				 * loop or infinite recursion.
> +				 * But finding the same state doesn't mean that it's safe
> +				 * to stop processing the current state. The previous state
> +				 * hasn't yet reached bpf_exit, since state.branches > 0.
> +				 * Checking in_async_callback_fn alone is not enough either.
> +				 * Since the verifier still needs to catch infinite loops
> +				 * inside async callbacks.
> +				 */
> +			} else if (states_maybe_looping(&sl->state, cur) &&
> +				   states_equal(env, &sl->state, cur)) {
>  				verbose_linfo(env, insn_idx, "; ");
>  				verbose(env, "infinite loop detected at insn %d\n", insn_idx);
>  				return -EINVAL;
> -- 
> 2.30.2
