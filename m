Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83BE41BBA1
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 02:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243285AbhI2ALx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 20:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhI2ALw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 20:11:52 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2C7C06161C;
        Tue, 28 Sep 2021 17:10:12 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id n23so431590pfv.4;
        Tue, 28 Sep 2021 17:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f8dYfh9sGypf5J5IWzBcG6k4k6CHlFYv07CjFTv0HWw=;
        b=TxLXhf9+hu1D/roEJDz0ipqX+btSUps32isUUxmXQKih+kusqxCtQTailyKocEzRI0
         DLVGNjFw3SFH7b1zhd9O+f0pjzoU/Pcrv6u7RvPSeU/amt3CvizMUuzXsq7d8bxJwqxm
         5lVEe0piAjsXzOtsIVKQ3rBHtnRmes5KuryLNbZrce8DIoTfabPH3DnPuTxAalqLniFO
         4rhbKJ5aIfK5/6tL0Spg9sGW3BdmO6yN7T7WtRYgfrVG81YN9dOpQtJBaS3GIdcPhT3a
         1yGCP2Hof9rDxZeFxdhjoLDcgSp9tZ6J3WIX0/kjvtcWZKTnN1QE5373qt8dxFD2C7Nt
         Liww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f8dYfh9sGypf5J5IWzBcG6k4k6CHlFYv07CjFTv0HWw=;
        b=FVgO7MWccJZ0+ZS7suNzXNoUFypF8csnKMj0pqJ7ybGAFK3eAHwTZZQXuzCM7rpFJs
         4FL/xbBWY7Xn2rYXoDZ5WYXyHyj/A2FWSkV0niMZLKtuKh2bhH1WfGYNPCe1Gin8TVnP
         Qf437iKxvx96TFCp2fx3jjqqK2/cbHz6Wvg1DY+2623CoqXd7uyZS70tY9gq02bBefWw
         Oj/9MBiC7bMLKJEQ/BBWxNjCSA5M+pjV4ZuLvRlV5r+ZP0JJ8UbKFu+52OzGxTECG7g3
         eDQR7q6WmXc+OkUlZh5V6Zk6B6NhUuh40g1LpMxvQtQSdmxhBiwRW5ZC/Gw0I3CrswvZ
         1HCA==
X-Gm-Message-State: AOAM530thVuhQyMjeTgbW/PD/IXEaW6C/30W+XLWHCTMeApbUid9ycsz
        RBxZayxkr28yHYoIKXAQ3As=
X-Google-Smtp-Source: ABdhPJxxuUTMeq4gtDDyLtSVcUzQIMCN15fvpecBF7/u750vwoO27U/HSPpxFpB8vqier9e/t12yjg==
X-Received: by 2002:a62:f241:0:b0:44b:3078:d7f5 with SMTP id y1-20020a62f241000000b0044b3078d7f5mr8321980pfl.58.1632874212216;
        Tue, 28 Sep 2021 17:10:12 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id p189sm233846pfp.167.2021.09.28.17.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 17:10:11 -0700 (PDT)
Date:   Wed, 29 Sep 2021 05:40:09 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 09/12] libbpf: Update gen_loader to emit
 BTF_KIND_FUNC relocations
Message-ID: <20210929001009.uslizph7vq7qh47e@apollo.localdomain>
References: <20210927145941.1383001-1-memxor@gmail.com>
 <20210927145941.1383001-10-memxor@gmail.com>
 <20210929000100.5ysbbe7jb3abgrdl@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929000100.5ysbbe7jb3abgrdl@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 05:31:00AM IST, Alexei Starovoitov wrote:
> On Mon, Sep 27, 2021 at 08:29:38PM +0530, Kumar Kartikeya Dwivedi wrote:
> > +static void emit_relo_kfunc_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn)
> > +{
> > +	struct kfunc_desc *kdesc;
> > +	int btf_fd_idx;
> > +
> > +	kdesc = get_kfunc_desc(gen, relo->name);
> > +	if (!kdesc)
> > +		return;
> > +
> > +	btf_fd_idx = kdesc->ref > 1 ? kdesc->off : add_kfunc_btf_fd(gen);
> > +	if (btf_fd_idx > INT16_MAX) {
> > +		pr_warn("BTF fd off %d for kfunc %s exceeds INT16_MAX, cannot process relocation\n",
> > +			btf_fd_idx, relo->name);
> > +		gen->error = -E2BIG;
> > +		return;
> > +	}
> > +	/* load slot pointer */
> > +	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_8, BPF_PSEUDO_MAP_IDX_VALUE,
> > +					 0, 0, 0, blob_fd_array_off(gen, btf_fd_idx)));
> > +	/* Try to map one insn->off to one insn->imm */
> > +	if (kdesc->ref > 1) {
> > +		emit(gen, BPF_MOV64_REG(BPF_REG_9, BPF_REG_7));
> > +		goto skip_btf_fd;
> > +	} else {
> > +		/* cannot use index == 0 */
> > +		if (!btf_fd_idx) {
> > +			btf_fd_idx = add_kfunc_btf_fd(gen);
> > +			/* shift to next slot */
> > +			emit(gen, BPF_ALU64_IMM(BPF_ADD, BPF_REG_8, sizeof(int)));
> > +		}
> > +		kdesc->off = btf_fd_idx;
> > +	}
> > +
> > +	/* set a default value */
> > +	emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_8, 0, 0));
> > +	emit(gen, BPF_MOV64_REG(BPF_REG_9, BPF_REG_7));
> > +	/* store BTF fd if ret < 0 */
> > +	emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 3));
> > +	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_7, 32));
> > +	/* store BTF fd in slot */
> > +	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7, 0));
> > +	emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_9));
> > +skip_btf_fd:
> > +	/* remember BTF fd to skip insn->off store for vmlinux case */
> > +	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_9, 32));
> > +	/* set a default value */
> > +	emit(gen, BPF_ST_MEM(BPF_H, BPF_REG_0, offsetof(struct bpf_insn, off), 0));
> > +	/* skip insn->off store if ret < 0 */
> > +	emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 2));
> > +	/* skip if vmlinux BTF */
> > +	emit(gen, BPF_JMP_IMM(BPF_JEQ, BPF_REG_9, 0, 1));
> > +	/* store index into insn[insn_idx].off */
> > +	emit(gen, BPF_ST_MEM(BPF_H, BPF_REG_0, offsetof(struct bpf_insn, off), btf_fd_idx));
> > +	/* close fd that we skipped storing in fd_array */
> > +	if (kdesc->ref > 1) {
> > +		emit(gen, BPF_MOV64_REG(BPF_REG_1, BPF_REG_9));
> > +		__emit_sys_close(gen);
> > +	}
>
> kdesc->ref optimization is neat, but I wonder why it's done half way.
> The generated code still calls bpf_btf_find_by_name_kind() and the kernel
> allocates the new FD. Then the loader prog simply ignores that FD and closes it.
> May be don't call the helper at all and just copy imm+off pair from
> already populated insn?

Good idea, I'll fix this in v6.

> I was thinking to do this optimization for emit_relo() for other cases,
> but didn't have time to do it.
> Since the code is doing this optimization I think it's worth doing it cleanly.
> Or just don't do it at all.
> It's great that there is a test for it in the patch 12 :)

--
Kartikeya
