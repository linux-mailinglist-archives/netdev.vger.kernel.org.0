Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194EF2C5EE1
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 04:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392288AbgK0DNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 22:13:21 -0500
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:26221 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388622AbgK0DNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 22:13:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1606446797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1DkTru/vaQLKyEfPYvqXCLt10fvXPbdCKCh3CmB5f40=;
        b=gYf+526qyYzCELn5C+h9MxyS8Cycn7yrx85rLKNl4TfE8TiqTmrZxgo5HguyUev04wG6ST
        z1866S9OBUesjeAzelFSh9+kfj+2v64Gj6s5ZVvG62ea+HULdiLO0vbqALyCZX6sX7Vbly
        Z5ZovSPpI8EBXQBtbpRKw+RJt9twbAE=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2168.outbound.protection.outlook.com [104.47.17.168])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-15-yvOEPemqMdCkD9pPNsgpOw-1; Fri, 27 Nov 2020 04:13:15 +0100
X-MC-Unique: yvOEPemqMdCkD9pPNsgpOw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yec/ZYaKE5/l+Bva8ijVQxMbJLb9KpGFWDWRMgs12nw0NxKrV+0u9PwPujaI2FTqIIpu/JA4USwlHNd3Or/JJ3pVuNKOmTtqk77regvHk2E4qjWiC/4c2x45FWNcCSFDSNnNFvaZfKtDGOFu34LUybQN5UGUv/r6HnrnddUvxWDlh+2JNhts4tU6Upb6cZxDAg0SDaPElQ6yfcdyoUVveFJQwjhZIJ3aFsqMyKyFqFVQ5C+iGILmq4BX0UPAw2qStTYOwMmS/pwAen1absdiZMD0ui3Stx+wz/CmaBstiRDEiOMOM8E81gDqMzqDA0YOz0fVh2ytakbFy9o5FVx45A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1DkTru/vaQLKyEfPYvqXCLt10fvXPbdCKCh3CmB5f40=;
 b=RTRlxw8WyGZT/AZKOvlt0TkW8xHhvTSufM7KqvCwCxCt1Mn0s+RvQouK4UMqRCTGJ8d/dMBCUwyy0NWkfnNOd59kY1ilEdzdYVQhEwEY0TTpqKFb3Rv9fCVVmbtieGkyvNpUBR4WLlY1RN5IS+od+hnuYar0GBtfgND98knfCmzxZ3sSuvZ8EEw8dopuRmVxZWQOytKkKcSpbN81bpH4PPTZQmS/fykkznTJZPei1l5lgxdqPTe3ayvY/eF9vqpe8D7IWKrPh6hjfhK7bnbLR5sppY774HJF05sfI+9RYA1Qj0cMA9LEWwDjDQwwr5oldHWDbPN52i4yN1NMFU4S3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB7PR04MB5387.eurprd04.prod.outlook.com (2603:10a6:10:8b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Fri, 27 Nov
 2020 03:13:14 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%7]) with mapi id 15.20.3589.029; Fri, 27 Nov 2020
 03:13:14 +0000
Date:   Fri, 27 Nov 2020 11:13:05 +0800
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        andreas.taschner@suse.com
Subject: Re: [RFC PATCH] bpf, x64: add extra passes and relax size
 convergence check
Message-ID: <20201127031305.GQ16653@GaryWorkstation>
References: <20201126080130.23303-1-glin@suse.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126080130.23303-1-glin@suse.com>
X-Originating-IP: [60.251.47.115]
X-ClientProxiedBy: AM3PR04CA0135.eurprd04.prod.outlook.com (2603:10a6:207::19)
 To DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryWorkstation (60.251.47.115) by AM3PR04CA0135.eurprd04.prod.outlook.com (2603:10a6:207::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Fri, 27 Nov 2020 03:13:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91e17afe-09c3-431f-5e2e-08d8928260bf
X-MS-TrafficTypeDiagnostic: DB7PR04MB5387:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB5387275509FED89581A74BA3A9F80@DB7PR04MB5387.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BsFwXOnFU00GxxqYXGXYlndgQjDNw8zSdVfkjc05NKK6KSp3weUHxDZLnPUlP+dcj10OkvstyWGHreTNzDb3/76+qEiQommBbuQX8vxJchmPEerALCeAvKbHnuF8jPU5ZeKa+qgz2Esxsqq60+D2q/VRfsJcchbXqTNj53fYd5m/liEtEV/dAcoX7YyW4AyxHObeFxLbemJfy2Dwo/jZsx78GFiYt33IG0SIwQM4PNli6QlBv+FWm/spsIJDNxELbjiHuL9eoIEK2yVvD3hjMGYtnt6pllfGPpWspuSmsBThWkNrJBN9oZhfliSxRoZYg1FxTZkfNiYw3B8Cf1WDIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(376002)(366004)(39860400002)(8936002)(52116002)(55016002)(316002)(55236004)(478600001)(956004)(83380400001)(86362001)(9686003)(2906002)(6496006)(4326008)(26005)(5660300002)(8676002)(33716001)(54906003)(66476007)(33656002)(1076003)(107886003)(66946007)(6666004)(66556008)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Yywd6WvE1zgD/I5QF2XaKhpMwQ/JjCf+kRyqi6LXSDiIiKw2AyLXMO8kxE68?=
 =?us-ascii?Q?gJDBTQ86vxFjqquY2fzTEs5jPd7MOYwXxCST+EEwSYRz+j12Yb1dePUDOtwo?=
 =?us-ascii?Q?+UBkUt55qMprGDaGdE1+5VyQpVJsUFFc7FweToAW0niWH0/q6uHwweqnh8U4?=
 =?us-ascii?Q?6HzvRh8F6W4HQRcONixU5rMBGVZ0M1KN2gaZ/ZmqF+atf37dkwd/LL3kG06/?=
 =?us-ascii?Q?K0vA7JyvjY5OrrSkVMnW9xAhE3oSgTvPiLoK/Cj6MBzuM0qV4dpe+hZEpXFJ?=
 =?us-ascii?Q?r0YBgtZ88R6mrni16OzgfwmY/JBQZTS7QVitWQCFrilYkoEdAkAlC5LHyXQ4?=
 =?us-ascii?Q?QOrm93JgV7ZJ1/wAzV9GYDLoYbOIeULBps3IRhQniPynaJtWQchIHA5H77Q6?=
 =?us-ascii?Q?czdi1ja0/euqxYCUi7mWVfa0ErNHdJIJD3dGhiTYLFN5F6DvoIdlh58seGqJ?=
 =?us-ascii?Q?Po2+KqJ1CniXBeXvVwKsV5AssGXIf1V1dgeNkpiiKcHNXU/3+4AHcFQiHR5v?=
 =?us-ascii?Q?ytCc4ft3EuqSPwlE6BkrrimuX14ikEhPr3EadBKTBXW0pZh2E3OipNjYSLYJ?=
 =?us-ascii?Q?7UBz0ie6MrQxYDerPgR21AmYEhFEyAQTfOgi1ULHLUGy73fjQ60ir6+QcagJ?=
 =?us-ascii?Q?8mBVF37E6LAgihZ/P8QsigrxJy9CmYaQzYtblcJsRyNQe+R0yEXV7m1Qgp46?=
 =?us-ascii?Q?wcIppV59525Qc5VMNg4HC8A2BeZB+Y9NrwOWuzoGFU09KrQO+cXVhD5IR+/a?=
 =?us-ascii?Q?j35n9rORaIXCOlDxLLwixmz2VZTNFYqVi4k+7yQiiK8/87OjWEtYfO+E8gMO?=
 =?us-ascii?Q?/b+0e/zxUL1vF0Mw4RA5P2tH29G2dTkrZslvO00Gphi25S8AddKZBcpmX2Qz?=
 =?us-ascii?Q?7xxx6TG/UbH/QoC1YMTmVUd8VLRqAVfMeDecDONzrmOQNZB9E8QF5yJ9fmO8?=
 =?us-ascii?Q?irQfEN9AFV2N2LatQeU+SGWmMBhStxQTo96q9V80BQ3VujiXcbMPTWDMMI8C?=
 =?us-ascii?Q?4Bh7?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e17afe-09c3-431f-5e2e-08d8928260bf
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2020 03:13:14.5976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NlueDQssdKm79hpCd9xxFkdTNFNoPy0x/2r2f8os47d1RJTeVxZPWHkvgSjw3as2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5387
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 04:01:30PM +0800, Gary Lin wrote:
> The x64 bpf jit expects bpf images converge within the given passes, but
> it could fail to do so with some corner cases. For example:
> 
>       l0:     ldh [4]
>       l1:     jeq #0x537d, l2, l40
>       l2:     ld [0]
>       l3:     jeq #0xfa163e0d, l4, l40
>       l4:     ldh [12]
>       l5:     ldx #0xe
>       l6:     jeq #0x86dd, l41, l7
>       l7:     jeq #0x800, l8, l41
>       l8:     ld [x+16]
>       l9:     ja 41
> 
>         [... repeated ja 41 ]
> 
>       l40:    ja 41
>       l41:    ret #0
>       l42:    ld #len
>       l43:    ret a
> 
> This bpf program contains 32 "ja 41" instructions which are effectivly
> NOPs and designed to be replaced with valid code dynamically. Ideally,
> bpf jit should optimize those "ja 41" instructions out when translating
> translating the bpf instrctions into x86_64 machine code. However,
> do_jit() can only remove one "ja 41" for offset==0 on each pass, so it
> requires at least 32 runs to eliminate those JMPs and exceeds the
> current limit of passes (20). In the end, the program got rejected when
> BPF_JIT_ALWAYS_ON is set even though it's legit as a classic socket
> filter.
> 
> To allow the not-converged images, one possible solution is to only use
> JMPs with imm32 to guarantee the correctness of jump offsets.
> 
> There are two goals of this commit:
>   1. reduce the size variance by generating only jumps with imm32
>   2. relax the requirement of size convergence
I went through the code again and found that size convergence is still
necessary or the offset change could still affect the correctness of the
generated machine code.

Instead of relaxing size convergence check, we can disable the jump
optimization in the extra passes, i.e. imm32 jump only and no more
nop optimization.

Will submit another patch.

Gary Lin

> 
> Since imm32 jump occupies 5 bytes compared with 2 bytes by imm8 jump,
> the image size may swell. To minimize the impact, 5 extra passes are
> introduced and the imm32-only rule is only applied to the extra passes,
> so the bpf images converge within the original 20 passes won't be
> affected.
> 
> If the image doesn't converge after the 5 extra passes, the image is
> still allocated and a warning is issued to notify the user.
> 
> Signed-off-by: Gary Lin <glin@suse.com>
> ---
>  arch/x86/net/bpf_jit_comp.c | 47 +++++++++++++++++++++++++++++--------
>  1 file changed, 37 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 796506dcfc42..6fe933e9e8c2 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -790,7 +790,8 @@ static void detect_reg_usage(struct bpf_insn *insn, int insn_cnt,
>  }
>  
>  static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
> -		  int oldproglen, struct jit_context *ctx)
> +		  int oldproglen, struct jit_context *ctx, bool force_jmp32,
> +		  bool allow_grow)
>  {
>  	bool tail_call_reachable = bpf_prog->aux->tail_call_reachable;
>  	struct bpf_insn *insn = bpf_prog->insnsi;
> @@ -1408,7 +1409,7 @@ xadd:			if (is_imm8(insn->off))
>  				return -EFAULT;
>  			}
>  			jmp_offset = addrs[i + insn->off] - addrs[i];
> -			if (is_imm8(jmp_offset)) {
> +			if (is_imm8(jmp_offset) && !force_jmp32) {
>  				EMIT2(jmp_cond, jmp_offset);
>  			} else if (is_simm32(jmp_offset)) {
>  				EMIT2_off32(0x0F, jmp_cond + 0x10, jmp_offset);
> @@ -1435,7 +1436,7 @@ xadd:			if (is_imm8(insn->off))
>  				/* Optimize out nop jumps */
>  				break;
>  emit_jmp:
> -			if (is_imm8(jmp_offset)) {
> +			if (is_imm8(jmp_offset) && !force_jmp32) {
>  				EMIT2(0xEB, jmp_offset);
>  			} else if (is_simm32(jmp_offset)) {
>  				EMIT1_off32(0xE9, jmp_offset);
> @@ -1476,7 +1477,7 @@ xadd:			if (is_imm8(insn->off))
>  		}
>  
>  		if (image) {
> -			if (unlikely(proglen + ilen > oldproglen)) {
> +			if (unlikely(proglen + ilen > oldproglen) && !allow_grow) {
>  				pr_err("bpf_jit: fatal error\n");
>  				return -EFAULT;
>  			}
> @@ -1972,6 +1973,9 @@ struct x64_jit_data {
>  	struct jit_context ctx;
>  };
>  
> +#define MAX_JIT_PASSES 25
> +#define JMP32_ONLY_PASSES 20
> +
>  struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>  {
>  	struct bpf_binary_header *header = NULL;
> @@ -1981,6 +1985,8 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>  	struct jit_context ctx = {};
>  	bool tmp_blinded = false;
>  	bool extra_pass = false;
> +	bool force_jmp32 = false;
> +	bool allow_grow = false;
>  	u8 *image = NULL;
>  	int *addrs;
>  	int pass;
> @@ -2042,8 +2048,24 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>  	 * may converge on the last pass. In such case do one more
>  	 * pass to emit the final image.
>  	 */
> -	for (pass = 0; pass < 20 || image; pass++) {
> -		proglen = do_jit(prog, addrs, image, oldproglen, &ctx);
> +	for (pass = 0; pass < MAX_JIT_PASSES || image; pass++) {
> +		/*
> +		 * On the 21th pass, if the image still doesn't converge,
> +		 * then force_jmp32 is set afterward to make do_jit() always
> +		 * generate 32bit offest JMP to reduce the chance of size
> +		 * variance. The side effect is that the image size may grow
> +		 * since the 8bit offset JMPs are now replaced with 32bit
> +		 * offset JMPs, so allow_grow is flipped to true only for
> +		 * this pass.
> +		 */
> +		if (pass == JMP32_ONLY_PASSES && !image) {
> +			force_jmp32 = true;
> +			allow_grow = true;
> +		} else {
> +			allow_grow = false;
> +		}
> +
> +		proglen = do_jit(prog, addrs, image, oldproglen, &ctx, force_jmp32, allow_grow);
>  		if (proglen <= 0) {
>  out_image:
>  			image = NULL;
> @@ -2054,13 +2076,18 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>  		}
>  		if (image) {
>  			if (proglen != oldproglen) {
> -				pr_err("bpf_jit: proglen=%d != oldproglen=%d\n",
> -				       proglen, oldproglen);
> -				goto out_image;
> +				if (pass < MAX_JIT_PASSES) {
> +					pr_err("bpf_jit: proglen=%d != oldproglen=%d\n",
> +					       proglen, oldproglen);
> +					goto out_image;
> +				} else {
> +					pr_warn("bpf_jit: proglen=%d != oldproglen=%d, pass=%d\n",
> +						proglen, oldproglen, pass);
> +				}
>  			}
>  			break;
>  		}
> -		if (proglen == oldproglen) {
> +		if (proglen == oldproglen || pass == (MAX_JIT_PASSES - 1)) {
>  			/*
>  			 * The number of entries in extable is the number of BPF_LDX
>  			 * insns that access kernel memory via "pointer to BTF type".
> -- 
> 2.28.0
> 

