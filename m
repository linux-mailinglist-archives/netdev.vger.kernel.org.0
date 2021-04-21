Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97133664A1
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 06:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbhDUErW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 00:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbhDUErV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 00:47:21 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8C7C06174A;
        Tue, 20 Apr 2021 21:46:47 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id c17so27529407pfn.6;
        Tue, 20 Apr 2021 21:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p2NPnR+CWZyiy1MnvLCcfSHpmjZGdfrjRhj3DHgLE28=;
        b=SJS/IVB5N5hg3XTypiaDMf6d9pD+hGytZoBb/V0DPiNbDJTnl4hGpnd7mhR5tYWOBF
         Elgq4uLsrULPtk8FP3TZocAbF5e2EfmALZ8sboROFkI8067fWpTPP4zZ1rum7/Kgy4dl
         Ym23hdVqf2FxCMUXuorMxP/S6xf6XCEMX2q58wwZPWyVySNT9KHZANdLnsck1nEIsvBu
         /tfdeaouxBQc2oNmSsU3fm4HsC+CnNrcBNaAldPq6O5kXCi+UqLtV/bAmgsHsu+gXODG
         jCgRVwITM1iwZhvRA5mxFXbqXCRjM71kZfBvuh8artN0uvliTAQIXR3uHhMBQD/WKI3D
         jfQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p2NPnR+CWZyiy1MnvLCcfSHpmjZGdfrjRhj3DHgLE28=;
        b=QSUvgL1AedNUinxfmEgNseRt7xAu8Sy4JrCcBhmCK6bkOVLrhULHK/gNTSIQg6AJY9
         KpFZJQwqDZzg2X62VdWB1qcgdF31EPcExfDrZFL9IaVIhJ/Q6SFSVLx4D2+xtci3/I3Z
         wuF1ch3R5XwKpL32HIDfuh7GaIG/LQVrzKOOzSHcXFgmCaGyeKJh11aCPeLupX3eQOKB
         9e5AbQVppSbF/ZEu0sxSPWx8iss/iXSf3uwOlaB0xkvvHGEj9LrQzD0cjjOc3R6CE5Kg
         Ak6JS08vkE5dhsdgu30HJhOE4uXX+G7ND+DJxtzC6K/N7a0jjEkEaCuezAokirUraur8
         7G9w==
X-Gm-Message-State: AOAM531Mp/C6jEdSyt24jY0ij2oQtv+Y8CyyAIEAOgbO/fPa7js0gaSe
        NSQhmSz0nTl3jHIsJ1vyrrc=
X-Google-Smtp-Source: ABdhPJxzO9MMDOmZR/OKFqlPpb4yxcPtJwqUgGy/zgnU1RHPu14Y3NAmQbg6AEeN5mj0cW/iLZ3Hgw==
X-Received: by 2002:a17:90b:915:: with SMTP id bo21mr8678413pjb.118.1618980407215;
        Tue, 20 Apr 2021 21:46:47 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f3c3])
        by smtp.gmail.com with ESMTPSA id a185sm518599pfd.70.2021.04.20.21.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 21:46:46 -0700 (PDT)
Date:   Tue, 20 Apr 2021 21:46:43 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 13/15] libbpf: Generate loader program out of
 BPF ELF file.
Message-ID: <20210421044643.mqb4lnbqtgxmkcl4@ast-mbp.dhcp.thefacebook.com>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
 <20210417033224.8063-14-alexei.starovoitov@gmail.com>
 <a63a54c3-e04a-e557-3fe1-dacfece1e359@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a63a54c3-e04a-e557-3fe1-dacfece1e359@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 06:34:11PM -0700, Yonghong Song wrote:
> > 
> > kconfig, typeless ksym, struct_ops and CO-RE are not supported yet.
> 
> Beyond this, currently libbpf has a lot of flexibility between prog open
> and load, change program type, key/value size, pin maps, max_entries, reuse
> map, etc. it is worthwhile to mention this in the cover letter.
> It is possible that these changes may defeat the purpose of signing the
> program though.

Right. We'd need to decide which ones are ok to change after signature
verification. I think max_entries gotta be allowed, since tools
actively change it. The other fields selftest change too, but I'm not sure
it's a good thing to allow for signed progs. TBD.

> > +	if (gen->error)
> > +		return -ENOMEM;
> 
> return gen->error?

right

> > +	if (off + size > UINT32_MAX) {
> > +		gen->error = -ERANGE;
> > +		return -ERANGE;
> > +	}
> > +	gen->insn_start = realloc(gen->insn_start, off + size);
> > +	if (!gen->insn_start) {
> > +		gen->error = -ENOMEM;
> > +		return -ENOMEM;
> > +	}
> > +	gen->insn_cur = gen->insn_start + off;
> > +	return 0;
> > +}
> > +
> > +static int bpf_gen__realloc_data_buf(struct bpf_gen *gen, __u32 size)
> 
> Maybe change the return type to size_t? Esp. in the below
> we have off + size > UINT32_MAX.

return type? it's 0 or error. you mean argument type?
I think u32 is better. The prog size and all other ways
the bpf_gen__add_data is called with 32-bit values.

> > +{
> > +	size_t off = gen->data_cur - gen->data_start;
> > +
> > +	if (gen->error)
> > +		return -ENOMEM;
> 
> return gen->error?

right

> > +	if (off + size > UINT32_MAX) {
> > +		gen->error = -ERANGE;
> > +		return -ERANGE;
> > +	}
> > +	gen->data_start = realloc(gen->data_start, off + size);
> > +	if (!gen->data_start) {
> > +		gen->error = -ENOMEM;
> > +		return -ENOMEM;
> > +	}
> > +	gen->data_cur = gen->data_start + off;
> > +	return 0;
> > +}
> > +
> > +static void bpf_gen__emit(struct bpf_gen *gen, struct bpf_insn insn)
> > +{
> > +	if (bpf_gen__realloc_insn_buf(gen, sizeof(insn)))
> > +		return;
> > +	memcpy(gen->insn_cur, &insn, sizeof(insn));
> > +	gen->insn_cur += sizeof(insn);
> > +}
> > +
> > +static void bpf_gen__emit2(struct bpf_gen *gen, struct bpf_insn insn1, struct bpf_insn insn2)
> > +{
> > +	bpf_gen__emit(gen, insn1);
> > +	bpf_gen__emit(gen, insn2);
> > +}
> > +
> > +void bpf_gen__init(struct bpf_gen *gen, int log_level)
> > +{
> > +	gen->log_level = log_level;
> > +	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_6, BPF_REG_1));
> > +	bpf_gen__emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_10, stack_off(last_attach_btf_obj_fd), 0));
> 
> Here we initialize last_attach_btf_obj_fd, do we need to initialize
> last_btf_id?

Not sure why I inited it. Probably left over. I'll remove it.

> > +}
> > +
> > +static int bpf_gen__add_data(struct bpf_gen *gen, const void *data, __u32 size)
> > +{
> > +	void *prev;
> > +
> > +	if (bpf_gen__realloc_data_buf(gen, size))
> > +		return 0;
> > +	prev = gen->data_cur;
> > +	memcpy(gen->data_cur, data, size);
> > +	gen->data_cur += size;
> > +	return prev - gen->data_start;
> > +}
> > +
> > +static int insn_bytes_to_bpf_size(__u32 sz)
> > +{
> > +	switch (sz) {
> > +	case 8: return BPF_DW;
> > +	case 4: return BPF_W;
> > +	case 2: return BPF_H;
> > +	case 1: return BPF_B;
> > +	default: return -1;
> > +	}
> > +}
> > +
> [...]
> > +
> > +static void __bpf_gen__debug(struct bpf_gen *gen, int reg1, int reg2, const char *fmt, va_list args)
> > +{
> > +	char buf[1024];
> > +	int addr, len, ret;
> > +
> > +	if (!gen->log_level)
> > +		return;
> > +	ret = vsnprintf(buf, sizeof(buf), fmt, args);
> > +	if (ret < 1024 - 7 && reg1 >= 0 && reg2 < 0)
> > +		strcat(buf, " r=%d");
> 
> Why only for reg1 >= 0 && reg2 < 0?

To avoid specifying BPF_REG_7 and adding " r=%%d" to printks explicitly.
Just to make bpf_gen__debug_ret() short and less verbose.

> > +	len = strlen(buf) + 1;
> > +	addr = bpf_gen__add_data(gen, buf, len);
> > +
> > +	bpf_gen__emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, addr));
> > +	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_2, len));
> > +	if (reg1 >= 0)
> > +		bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_3, reg1));
> > +	if (reg2 >= 0)
> > +		bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_4, reg2));
> > +	bpf_gen__emit(gen, BPF_EMIT_CALL(BPF_FUNC_trace_printk));
> > +}
> > +
> > +static void bpf_gen__debug_regs(struct bpf_gen *gen, int reg1, int reg2, const char *fmt, ...)
> > +{
> > +	va_list args;
> > +
> > +	va_start(args, fmt);
> > +	__bpf_gen__debug(gen, reg1, reg2, fmt, args);
> > +	va_end(args);
> > +}
> > +
> > +static void bpf_gen__debug_ret(struct bpf_gen *gen, const char *fmt, ...)
> > +{
> > +	va_list args;
> > +
> > +	va_start(args, fmt);
> > +	__bpf_gen__debug(gen, BPF_REG_7, -1, fmt, args);
> > +	va_end(args);
> > +}
> > +
> > +static void bpf_gen__emit_sys_close(struct bpf_gen *gen, int stack_off)
> > +{
> > +	bpf_gen__emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_10, stack_off));
> > +	bpf_gen__emit(gen, BPF_JMP_IMM(BPF_JSLE, BPF_REG_1, 0, 2 + (gen->log_level ? 6 : 0)));
> 
> The number "6" is magic. This refers the number of insns generated below
> with
>    bpf_gen__debug_regs(gen, BPF_REG_9, BPF_REG_0, "close(%%d) = %%d");
> At least some comment will be better.

good point. will add a comment.

> 
> > +	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_9, BPF_REG_1));
> > +	bpf_gen__emit(gen, BPF_EMIT_CALL(BPF_FUNC_sys_close));
> > +	bpf_gen__debug_regs(gen, BPF_REG_9, BPF_REG_0, "close(%%d) = %%d");
> > +}
> > +
> > +int bpf_gen__finish(struct bpf_gen *gen)
> > +{
> > +	int i;
> > +
> > +	bpf_gen__emit_sys_close(gen, stack_off(btf_fd));
> > +	for (i = 0; i < gen->nr_progs; i++)
> > +		bpf_gen__move_stack2ctx(gen, offsetof(struct bpf_loader_ctx,
> > +						      u[gen->nr_maps + i].map_fd), 4,
> 
> Maybe u[gen->nr_maps + i].prog_fd?
> u[..] is a union, but prog_fd better reflects what it is.

ohh. right.

> > +					stack_off(prog_fd[i]));
> > +	for (i = 0; i < gen->nr_maps; i++)
> > +		bpf_gen__move_stack2ctx(gen, offsetof(struct bpf_loader_ctx,
> > +						      u[i].prog_fd), 4,
> 
> u[i].map_fd?

right.

> > +	/* remember map_fd in the stack, if successful */
> > +	if (map_idx < 0) {
> > +		bpf_gen__emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7, stack_off(inner_map_fd)));
> 
> Some comments here to indicate map_idx < 0 is for inner map creation will
> help understand the code.

will do.

> > +	/* store btf_id into insn[insn_idx].imm */
> > +	insn = (int)(long)&((struct bpf_insn *)(long)insns)[relo->insn_idx].imm;
> 
> This is really fancy. Maybe something like
> 	insn = insns + sizeof(struct bpf_insn) * relo->insn_idx + offsetof(struct
> bpf_insn, imm).
> Does this sound better?

yeah. much better.

> > +static void mark_feat_supported(enum kern_feature_id last_feat)
> > +{
> > +	struct kern_feature_desc *feat;
> > +	int i;
> > +
> > +	for (i = 0; i <= last_feat; i++) {
> > +		feat = &feature_probes[i];
> > +		WRITE_ONCE(feat->res, FEAT_SUPPORTED);
> > +	}
> 
> This assumes all earlier features than FD_IDX are supported. I think this is
> probably fine although it may not work for some weird backport.
> Did you see any issues if we don't explicitly set previous features
> supported?

This helper is only used as mark_feat_supported(FEAT_FD_IDX)
to tell libbpf that it shouldn't probe anything.
Otherwise probing via prog_load screw up gen_trace completely.
May be it will be mark_all_feat_supported(void), but that seems less flexible.

> > @@ -9383,7 +9512,13 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog, int *btf_obj_fd,
> >   	}
> >   	/* kernel/module BTF ID */
> > -	err = find_kernel_btf_id(prog->obj, attach_name, attach_type, btf_obj_fd, btf_type_id);
> > +	if (prog->obj->gen_trace) {
> > +		bpf_gen__record_find_name(prog->obj->gen_trace, attach_name, attach_type);
> > +		*btf_obj_fd = 0;
> > +		*btf_type_id = 1;
> 
> We have quite some codes like this and may add more to support more
> features. I am wondering whether we could have some kind of callbacks
> to make the code more streamlined. But I am not sure how easy it is.

you mean find_kernel_btf_id() in general?
This 'find' operation is translated differently for
prog name as seen in this hunk via bpf_gen__record_find_name()
and via bpf_gen__record_extern() in another place.
For libbpf it's all find_kernel_btf_id(), but semantically they are different,
so they cannot map as-is to gen trace bpf_gen__find_kernel_btf_id (if there was
such thing).
Because such 'generic' callback wouldn't convey the meaning of what to do
with the result of the find.

> > +	} else {
> > +		err = find_kernel_btf_id(prog->obj, attach_name, attach_type, btf_obj_fd, btf_type_id);
> > +	}
> >   	if (err) {
> >   		pr_warn("failed to find kernel BTF type ID of '%s': %d\n", attach_name, err);
> >   		return err;
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index b9b29baf1df8..a5dffc0a3369 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -361,4 +361,5 @@ LIBBPF_0.4.0 {
> >   		bpf_linker__new;
> >   		bpf_map__inner_map;
> >   		bpf_object__set_kversion;
> > +		bpf_load;
> 
> Based on alphabet ordering, this should move a few places earlier.
> 
> I will need to go through the patch again for better understanding ...

Thanks a lot for the review.

I'll address these comments and those that I got offline and will post v2.
This gen stuff will look quite different.
I hope bpf_load will not be a part of uapi anymore.
And 'struct bpf_gen' will not be exposed to bpftool directly.
