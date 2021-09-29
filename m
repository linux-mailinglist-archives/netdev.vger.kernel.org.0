Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A3541BB87
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 02:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243344AbhI2ACo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 20:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243210AbhI2ACo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 20:02:44 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14460C06161C;
        Tue, 28 Sep 2021 17:01:04 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so416782pjb.5;
        Tue, 28 Sep 2021 17:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d856QFAuhml8JTPyS/F9IvEem7SqsiXz6VsE+v3zqQo=;
        b=lyTwq9qSZx1IrxYJnJ8AEfwCaH55lfCCIIH2PPP0qsE0sSRImC4XAmd1U7xwcdSpqW
         Byvf5HjlR8nB70A6YUk9FYN+DHmSoZeFaFrG7TvOwYj+auqhDQouP9R8sH14TyziEh+E
         EIx99CCvzctLCwd6enGtapQ3RSTZCEP8a5nSI1LIme/ribBGtEhojm3U+LYDp4Cy/tOz
         gmv9s3RXCmKccTaKG49VBGVWvc8RHgNuJilB5B6pdSTJW4eohaLYPysbqeNGpXpb/yvJ
         whpQklWqGxbtor+rUCfndyIQne+r/ss+szFsgouumFUhMazjuBSMp+WfyRTgBZLLHLVD
         hPOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d856QFAuhml8JTPyS/F9IvEem7SqsiXz6VsE+v3zqQo=;
        b=uQeetUUEN5k0GOfnmwk7d5SmGfdUT3QWQcaTbi9NdceRn8F32JUotpmarf/F0pSBTO
         mjz59SIL4aJ8XS3+XH92bLzk+AisaIVqBB+/d6vu6vlNkbWjmkFo0BfY/sMxT4HzwXkb
         7GfGKBE4140lKgjyJsIB9tmiznE0rYJiuGKvkYds8ZUKRWtaehAnRICON/A4zWRQ+dVn
         MS1iobtVKWkZ28dCv/CYBvSluq//VttVNtlDosLTcSDftEYFPkBQXhJiewq/tp7yRgh0
         pmNesl3VDbf1LRx5FhDZb/fYTVFbN6nQjqd3h1EQnbbscs4q0TaKe2kRsZh6R9drYqKI
         v/XQ==
X-Gm-Message-State: AOAM533IhX8Hig/+xe8g6ZS2AtdUUL6lhCu5piwQZz8nKqEutcuHqO3R
        085kFFY6So81p6dlojXgFhw=
X-Google-Smtp-Source: ABdhPJygTow4SlkMLWKEO6S9BKhW/dGgeNUFLTKK6BxmpK1zg3aHSSy0xZ91AK5dbGF8Exc1kubqRg==
X-Received: by 2002:a17:90a:de94:: with SMTP id n20mr2952461pjv.48.1632873663509;
        Tue, 28 Sep 2021 17:01:03 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f891])
        by smtp.gmail.com with ESMTPSA id y3sm237401pfr.140.2021.09.28.17.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 17:01:03 -0700 (PDT)
Date:   Tue, 28 Sep 2021 17:01:00 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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
Message-ID: <20210929000100.5ysbbe7jb3abgrdl@ast-mbp.dhcp.thefacebook.com>
References: <20210927145941.1383001-1-memxor@gmail.com>
 <20210927145941.1383001-10-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927145941.1383001-10-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 08:29:38PM +0530, Kumar Kartikeya Dwivedi wrote:
> +static void emit_relo_kfunc_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn)
> +{
> +	struct kfunc_desc *kdesc;
> +	int btf_fd_idx;
> +
> +	kdesc = get_kfunc_desc(gen, relo->name);
> +	if (!kdesc)
> +		return;
> +
> +	btf_fd_idx = kdesc->ref > 1 ? kdesc->off : add_kfunc_btf_fd(gen);
> +	if (btf_fd_idx > INT16_MAX) {
> +		pr_warn("BTF fd off %d for kfunc %s exceeds INT16_MAX, cannot process relocation\n",
> +			btf_fd_idx, relo->name);
> +		gen->error = -E2BIG;
> +		return;
> +	}
> +	/* load slot pointer */
> +	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_8, BPF_PSEUDO_MAP_IDX_VALUE,
> +					 0, 0, 0, blob_fd_array_off(gen, btf_fd_idx)));
> +	/* Try to map one insn->off to one insn->imm */
> +	if (kdesc->ref > 1) {
> +		emit(gen, BPF_MOV64_REG(BPF_REG_9, BPF_REG_7));
> +		goto skip_btf_fd;
> +	} else {
> +		/* cannot use index == 0 */
> +		if (!btf_fd_idx) {
> +			btf_fd_idx = add_kfunc_btf_fd(gen);
> +			/* shift to next slot */
> +			emit(gen, BPF_ALU64_IMM(BPF_ADD, BPF_REG_8, sizeof(int)));
> +		}
> +		kdesc->off = btf_fd_idx;
> +	}
> +
> +	/* set a default value */
> +	emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_8, 0, 0));
> +	emit(gen, BPF_MOV64_REG(BPF_REG_9, BPF_REG_7));
> +	/* store BTF fd if ret < 0 */
> +	emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 3));
> +	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_7, 32));
> +	/* store BTF fd in slot */
> +	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7, 0));
> +	emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_9));
> +skip_btf_fd:
> +	/* remember BTF fd to skip insn->off store for vmlinux case */
> +	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_9, 32));
> +	/* set a default value */
> +	emit(gen, BPF_ST_MEM(BPF_H, BPF_REG_0, offsetof(struct bpf_insn, off), 0));
> +	/* skip insn->off store if ret < 0 */
> +	emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 2));
> +	/* skip if vmlinux BTF */
> +	emit(gen, BPF_JMP_IMM(BPF_JEQ, BPF_REG_9, 0, 1));
> +	/* store index into insn[insn_idx].off */
> +	emit(gen, BPF_ST_MEM(BPF_H, BPF_REG_0, offsetof(struct bpf_insn, off), btf_fd_idx));
> +	/* close fd that we skipped storing in fd_array */
> +	if (kdesc->ref > 1) {
> +		emit(gen, BPF_MOV64_REG(BPF_REG_1, BPF_REG_9));
> +		__emit_sys_close(gen);
> +	}

kdesc->ref optimization is neat, but I wonder why it's done half way.
The generated code still calls bpf_btf_find_by_name_kind() and the kernel
allocates the new FD. Then the loader prog simply ignores that FD and closes it.
May be don't call the helper at all and just copy imm+off pair from
already populated insn?
I was thinking to do this optimization for emit_relo() for other cases,
but didn't have time to do it.
Since the code is doing this optimization I think it's worth doing it cleanly.
Or just don't do it at all.
It's great that there is a test for it in the patch 12 :)
