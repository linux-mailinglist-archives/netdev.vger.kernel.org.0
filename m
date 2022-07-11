Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDC8570164
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 13:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiGKL6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 07:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiGKL6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 07:58:21 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A2332BBC
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 04:58:19 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id o19-20020a05600c511300b003a2de48b4bbso3501603wms.5
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 04:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BQEPX2oLS4VAKW2DD0EGpgirZ7z4jyQAcpaLby2W2Ts=;
        b=bhB6lDedVM5GCtm3RN67vsyj7pGah/TwUoSfOWdn7V8TyJdb5ImGupDVq4LfeiheP/
         KOAscNuTWRp2WFA0yWg6PBhk4UflvQSCKtdrR/o8DmDJnusIQpGZ6X3sv8hq/HcnTaDl
         UtPSJxS5OjS6SFYzs67C1X9WJm5wy4Vg1T7GbPv+2+l8mJdvsv/0KEw799t1lHz+KPcl
         2tUeYFJNL2DMko4SuvFPGuwDrxN3x+WMThq2y+xZ6IuXke/gdPqPJpkNJ5rXUe1N+twN
         zblYstSj4Q0P9QIlaE91xbdF6b9AYALeUc/uVmOc8QXcW+gRehj/bEfrOrWSY+4fibSw
         OCcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BQEPX2oLS4VAKW2DD0EGpgirZ7z4jyQAcpaLby2W2Ts=;
        b=MP4JmTSQhmQqEhe1px3nAeOkH5o+WUhx06YOx+a8fYUYnC14r2984jFpJOLtCo1PGz
         w785H7G8aMsocjVJ0lW45p4bPiC5oLG6vrXVwwONwYPNeQFILPA+eClhx+R8a78V9Upk
         6fe+2yoFLOiARd0fCcwWM0C123ILepUonFBfJ5QhQVb45OEoQZpH5KFr8csc/2pwHTn+
         b4+Wkgeu3oDatjh/7oV1au7M1hvZ+HKnjbmJZ5fiOQnDU0OVDkByPBjMe0MnoiyHC5Eh
         TvbBKTfv97OxluVJOKHWhR9Wf9BDgqmzaweMsjUlrj/IRSBn/nNtQbZd4TQUAkjQ3gbk
         IMLQ==
X-Gm-Message-State: AJIora9r11Z8wkX8v1XYFS2E0W+6Wx9nGuR65SEM2QHf4+YcdFejFhdg
        XbEV0/Sei9mH7UNLN+Vs97Ydjw==
X-Google-Smtp-Source: AGRyM1uEchsOaegipf3GjUUvcb3Np4cRU36PBEf3G1M1h2oadk+gzl6uHqzdYQujNkpiR2MHW0tajg==
X-Received: by 2002:a05:600c:1e10:b0:3a2:e35c:f5fb with SMTP id ay16-20020a05600c1e1000b003a2e35cf5fbmr10434045wmb.27.1657540698361;
        Mon, 11 Jul 2022 04:58:18 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id ch9-20020a5d5d09000000b0021da4b6c6f7sm2898365wrb.40.2022.07.11.04.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 04:58:17 -0700 (PDT)
Date:   Mon, 11 Jul 2022 12:57:52 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Will Deacon <will@kernel.org>, KP Singh <kpsingh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Hou Tao <houtao1@huawei.com>,
        Jason Wang <wangborong@cdjrlc.com>
Subject: Re: [PATCH bpf-next v7 4/4] bpf, arm64: bpf trampoline for arm64
Message-ID: <YswQQG7CUoTXCbDa@myrica>
References: <20220708093032.1832755-1-xukuohai@huawei.com>
 <20220708093032.1832755-5-xukuohai@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708093032.1832755-5-xukuohai@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 05:30:32AM -0400, Xu Kuohai wrote:
> +static void invoke_bpf_prog(struct jit_ctx *ctx, struct bpf_tramp_link *l,
> +			    int args_off, int retval_off, int run_ctx_off,
> +			    bool save_ret)
> +{
> +	u32 *branch;
> +	u64 enter_prog;
> +	u64 exit_prog;
> +	u8 r0 = bpf2a64[BPF_REG_0];
> +	struct bpf_prog *p = l->link.prog;
> +	int cookie_off = offsetof(struct bpf_tramp_run_ctx, bpf_cookie);
> +
> +	if (p->aux->sleepable) {
> +		enter_prog = (u64)__bpf_prog_enter_sleepable;
> +		exit_prog = (u64)__bpf_prog_exit_sleepable;
> +	} else {
> +		enter_prog = (u64)__bpf_prog_enter;
> +		exit_prog = (u64)__bpf_prog_exit;
> +	}
> +
> +	if (l->cookie == 0) {
> +		/* if cookie is zero, one instruction is enough to store it */
> +		emit(A64_STR64I(A64_ZR, A64_SP, run_ctx_off + cookie_off), ctx);
> +	} else {
> +		emit_a64_mov_i64(A64_R(10), l->cookie, ctx);
> +		emit(A64_STR64I(A64_R(10), A64_SP, run_ctx_off + cookie_off),
> +		     ctx);
> +	}
> +
> +	/* save p to callee saved register x19 to avoid loading p with mov_i64
> +	 * each time.
> +	 */
> +	emit_addr_mov_i64(A64_R(19), (const u64)p, ctx);
> +
> +	/* arg1: prog */
> +	emit(A64_MOV(1, A64_R(0), A64_R(19)), ctx);
> +	/* arg2: &run_ctx */
> +	emit(A64_ADD_I(1, A64_R(1), A64_SP, run_ctx_off), ctx);
> +
> +	emit_call(enter_prog, ctx);
> +
> +	/* if (__bpf_prog_enter(prog) == 0)
> +	 *         goto skip_exec_of_prog;
> +	 */
> +	branch = ctx->image + ctx->idx;
> +	emit(A64_NOP, ctx);
> +
> +	/* save return value to callee saved register x20 */
> +	emit(A64_MOV(1, A64_R(20), A64_R(0)), ctx);
> +
> +	emit(A64_ADD_I(1, A64_R(0), A64_SP, args_off), ctx);
> +	if (!p->jited)
> +		emit_addr_mov_i64(A64_R(1), (const u64)p->insnsi, ctx);
> +
> +	emit_call((const u64)p->bpf_func, ctx);
> +
> +	/* store return value, which is held in r0 for JIT and in x0
> +	 * for interpreter.
> +	 */
> +	if (save_ret)
> +		emit(A64_STR64I(p->jited ? r0 : A64_R(0), A64_SP, retval_off),
> +		     ctx);

This should be only A64_R(0), not r0. r0 happens to equal A64_R(0) when
jitted due to the way build_epilogue() builds the function at the moment,
but we shouldn't rely on that.

Apart from that, for the series

Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

