Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9C441F5F2
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 21:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhJAT6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 15:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhJAT6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 15:58:34 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17599C061775;
        Fri,  1 Oct 2021 12:56:50 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id h3so10374458pgb.7;
        Fri, 01 Oct 2021 12:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1ntsq3FQ9UTdKRfa+yU3WAHX8y1S2z2zH6VtLmHpwe8=;
        b=KB45x1oQPw63vQYwAugjC4TVkWOUqUd9EBsnAnrj7xCdb6ODxPTnrHsbZotk0dfbam
         btPJjbeH705YY7kYpFfHYW80u3ImyNJlsugzQND529OdUgDS3ymCPDek5qyPxi+liCn2
         trwOxPZxfE6j4RQS07+pQssfefI7nkAwk7bNnbtzL0wbr5Jp+NtS1YVMlL6PWxoRa+Lr
         qBtnGN8Y5SOufshpuNi+Qru6grH4PvMEq4ld0x0CWCkLpaFbuaxSCBTNsnEXl4Lc0V/m
         eOHEbGXUtTRC2hA2A7z9WW7McAu8UtDWQUr1NKKBhauA9ZrKrw5v8V+goACev6FJiTy2
         G3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1ntsq3FQ9UTdKRfa+yU3WAHX8y1S2z2zH6VtLmHpwe8=;
        b=OHopl8S8Wbb2XyJ6uIrE1GtMeNeG8Xli1JCgtb2yvnl9O4dRDvHOx88vtwjM5w/ygy
         LyEoDDbETOspDIUlLzschZ+DjM89Skv38YakrHTT4IacqISB4ZZpcJbc1pDjOpQU6OWx
         FQMGRCFXT2qbFwrQiuUDTqQzCRjyQCxc8WcCNJMcJyDnJJChDlf0ACYAtwTzEZ/2izLs
         Bz/fB0uMrJuryBcvtbwhIFCckD0FWu/HQxvsEMWZ3wWib1G8xQSYWfIjDdi/YX+ZPI9W
         71UmmWZT3jsg35RIheUeR2P+YgOzdi9RdHp6hJndmsGxPnxq+/W8cPj96ctE+1fPwAd7
         Smiw==
X-Gm-Message-State: AOAM531Dnve/ITzcPAZ5xPlOr39XPzPBmVzaOgPce6a6z6w+z63pDx9n
        5CClmVXdf94ocguF9E1roaXFbY/lcuU=
X-Google-Smtp-Source: ABdhPJyiGiau42c6rWuYU0EhuOpqO3+PSRkaFCKKTOKZaR5ya6qqzfb4FlFOHKZvOtaykRWPNFassA==
X-Received: by 2002:a05:6a00:1826:b0:44b:e447:399c with SMTP id y38-20020a056a00182600b0044be447399cmr12887759pfa.59.1633118209377;
        Fri, 01 Oct 2021 12:56:49 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:500::3:8ca3])
        by smtp.gmail.com with ESMTPSA id i7sm7313485pgp.39.2021.10.01.12.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 12:56:48 -0700 (PDT)
Date:   Fri, 1 Oct 2021 12:56:46 -0700
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
Subject: Re: [PATCH bpf-next v6 8/9] libbpf: Update gen_loader to emit
 BTF_KIND_FUNC relocations
Message-ID: <20211001195646.7d5ycynrsivn3zxv@ast-mbp.dhcp.thefacebook.com>
References: <20210930062948.1843919-1-memxor@gmail.com>
 <20210930062948.1843919-9-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930062948.1843919-9-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 11:59:47AM +0530, Kumar Kartikeya Dwivedi wrote:
> This change updates the BPF syscall loader to relocate BTF_KIND_FUNC
> relocations, with support for weak kfunc relocations. The general idea
> is to move map_fds to loader map, and also use the data for storing
> kfunc BTF fds. Since both reuse the fd_array parameter, they need to be
> kept together.
> 
> For map_fds, we reserve MAX_USED_MAPS slots in a region, and for kfunc,
> we reserve MAX_KFUNC_DESCS. This is done so that insn->off has more
> chances of being <= INT16_MAX than treating data map as a sparse array
> and adding fd as needed.
> 
> When the MAX_KFUNC_DESCS limit is reached, we fall back to the sparse
> array model, so that as long as it does remain <= INT16_MAX, we pass an
> index relative to the start of fd_array.
> 
> We store all ksyms in an array where we try to avoid calling the
> bpf_btf_find_by_name_kind helper, and also reuse the BTF fd that was
> already stored. This also speeds up the loading process compared to
> emitting calls in all cases, in later tests.
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  tools/lib/bpf/bpf_gen_internal.h |  16 +-
>  tools/lib/bpf/gen_loader.c       | 323 ++++++++++++++++++++++++++-----
>  tools/lib/bpf/libbpf.c           |   8 +-
>  3 files changed, 292 insertions(+), 55 deletions(-)
> 
> diff --git a/tools/lib/bpf/bpf_gen_internal.h b/tools/lib/bpf/bpf_gen_internal.h
> index 615400391e57..70eccbffefb1 100644
> --- a/tools/lib/bpf/bpf_gen_internal.h
> +++ b/tools/lib/bpf/bpf_gen_internal.h
> @@ -7,6 +7,15 @@ struct ksym_relo_desc {
>  	const char *name;
>  	int kind;
>  	int insn_idx;
> +	bool is_weak;
> +};
> +
> +struct ksym_desc {
> +	const char *name;
> +	int ref;
> +	int kind;
> +	int off;
> +	int insn;
>  };
>  
>  struct bpf_gen {
> @@ -24,6 +33,10 @@ struct bpf_gen {
>  	int relo_cnt;
>  	char attach_target[128];
>  	int attach_kind;
> +	struct ksym_desc *ksyms;
> +	__u32 nr_ksyms;
> +	int fd_array;
> +	int nr_fd_array;
>  };
>  
>  void bpf_gen__init(struct bpf_gen *gen, int log_level);
> @@ -36,6 +49,7 @@ void bpf_gen__prog_load(struct bpf_gen *gen, struct bpf_prog_load_params *load_a
>  void bpf_gen__map_update_elem(struct bpf_gen *gen, int map_idx, void *value, __u32 value_size);
>  void bpf_gen__map_freeze(struct bpf_gen *gen, int map_idx);
>  void bpf_gen__record_attach_target(struct bpf_gen *gen, const char *name, enum bpf_attach_type type);
> -void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind, int insn_idx);
> +void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak, int kind,
> +			    int insn_idx);
>  
>  #endif
> diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
> index 80087b13877f..9902f2f47fb2 100644
> --- a/tools/lib/bpf/gen_loader.c
> +++ b/tools/lib/bpf/gen_loader.c
> @@ -14,8 +14,10 @@
>  #include "bpf_gen_internal.h"
>  #include "skel_internal.h"
>  
> -#define MAX_USED_MAPS 64
> -#define MAX_USED_PROGS 32
> +#define MAX_USED_MAPS	64
> +#define MAX_USED_PROGS	32
> +#define MAX_KFUNC_DESCS 256
> +#define MAX_FD_ARRAY_SZ (MAX_USED_PROGS + MAX_KFUNC_DESCS)
>  
>  /* The following structure describes the stack layout of the loader program.
>   * In addition R6 contains the pointer to context.
> @@ -30,7 +32,6 @@
>   */
>  struct loader_stack {
>  	__u32 btf_fd;
> -	__u32 map_fd[MAX_USED_MAPS];
>  	__u32 prog_fd[MAX_USED_PROGS];
>  	__u32 inner_map_fd;
>  };
> @@ -143,13 +144,58 @@ static int add_data(struct bpf_gen *gen, const void *data, __u32 size)
>  	if (realloc_data_buf(gen, size8))
>  		return 0;
>  	prev = gen->data_cur;
> -	memcpy(gen->data_cur, data, size);
> +	if (data)
> +		memcpy(gen->data_cur, data, size);

Manpage says that realloc doesn't init the memory.
Lets zero it here instead of leaving uninitialized.

>  	gen->data_cur += size;
>  	memcpy(gen->data_cur, &zero, size8 - size);
>  	gen->data_cur += size8 - size;
>  	return prev - gen->data_start;
>  }
>  
> +/* Get index for map_fd/btf_fd slot in reserved fd_array, or in data relative
> + * to start of fd_array. Caller can decide if it is usable or not.
> + */
> +static int fd_array_init(struct bpf_gen *gen)
> +{
> +	if (!gen->fd_array)
> +		gen->fd_array = add_data(gen, NULL, MAX_FD_ARRAY_SZ * sizeof(int));
> +	return gen->fd_array;
> +}
> +
> +static int add_map_fd(struct bpf_gen *gen)
> +{
> +	if (!fd_array_init(gen))
> +		return -1;

Pls drop the error check here and other places.
In out-of-mem situation gen->error will be set and all subsequent ops
will be using zero. The final check is in finish().

> +	if (gen->nr_maps == MAX_USED_MAPS) {
> +		pr_warn("Total maps exceeds %d\n", MAX_USED_MAPS);
> +		gen->error = -E2BIG;
> +		return -1;
> +	}
> +	return gen->nr_maps++;
> +}
> +
> +static int add_kfunc_btf_fd(struct bpf_gen *gen)
> +{
> +	int cur;
> +
> +	if (!fd_array_init(gen))
> +		return -1;

drop it.

> +	if (gen->nr_fd_array == MAX_KFUNC_DESCS) {
> +		cur = add_data(gen, NULL, sizeof(int));
> +		if (!cur)
> +			return -1;

drop it.

> +		return (cur - gen->fd_array) / sizeof(int);
> +	}
> +	return MAX_USED_MAPS + gen->nr_fd_array++;
> +}
> +
> +static int blob_fd_array_off(struct bpf_gen *gen, int index)
> +{
> +	if (!gen->fd_array)
> +		return 0;

drop it.

> +	return gen->fd_array + (index * sizeof(int));

no need for extra ()

> +}
> +
>  static int insn_bytes_to_bpf_size(__u32 sz)
>  {
>  	switch (sz) {
> @@ -171,14 +217,22 @@ static void emit_rel_store(struct bpf_gen *gen, int off, int data)
>  	emit(gen, BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 0));
>  }
>  
> -/* *(u64 *)(blob + off) = (u64)(void *)(%sp + stack_off) */
> -static void emit_rel_store_sp(struct bpf_gen *gen, int off, int stack_off)
> +static void move_blob2blob(struct bpf_gen *gen, int off, int size, int blob_off)
>  {
> -	emit(gen, BPF_MOV64_REG(BPF_REG_0, BPF_REG_10));
> -	emit(gen, BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, stack_off));
> +	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_2, BPF_PSEUDO_MAP_IDX_VALUE,
> +					 0, 0, 0, blob_off));
> +	emit(gen, BPF_LDX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_0, BPF_REG_2, 0));
>  	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
>  					 0, 0, 0, off));
> -	emit(gen, BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 0));
> +	emit(gen, BPF_STX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_1, BPF_REG_0, 0));
> +}
> +
> +static void move_blob2ctx(struct bpf_gen *gen, int ctx_off, int size, int blob_off)
> +{
> +	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
> +					 0, 0, 0, blob_off));
> +	emit(gen, BPF_LDX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_0, BPF_REG_1, 0));
> +	emit(gen, BPF_STX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_6, BPF_REG_0, ctx_off));
>  }
>  
>  static void move_ctx2blob(struct bpf_gen *gen, int off, int size, int ctx_off,
> @@ -326,11 +380,11 @@ int bpf_gen__finish(struct bpf_gen *gen)
>  			       offsetof(struct bpf_prog_desc, prog_fd), 4,
>  			       stack_off(prog_fd[i]));
>  	for (i = 0; i < gen->nr_maps; i++)
> -		move_stack2ctx(gen,
> -			       sizeof(struct bpf_loader_ctx) +
> -			       sizeof(struct bpf_map_desc) * i +
> -			       offsetof(struct bpf_map_desc, map_fd), 4,
> -			       stack_off(map_fd[i]));
> +		move_blob2ctx(gen,
> +			      sizeof(struct bpf_loader_ctx) +
> +			      sizeof(struct bpf_map_desc) * i +
> +			      offsetof(struct bpf_map_desc, map_fd), 4,
> +			      blob_fd_array_off(gen, i));
>  	emit(gen, BPF_MOV64_IMM(BPF_REG_0, 0));
>  	emit(gen, BPF_EXIT_INSN());
>  	pr_debug("gen: finish %d\n", gen->error);
> @@ -390,7 +444,7 @@ void bpf_gen__map_create(struct bpf_gen *gen,
>  {
>  	int attr_size = offsetofend(union bpf_attr, btf_vmlinux_value_type_id);
>  	bool close_inner_map_fd = false;
> -	int map_create_attr;
> +	int map_create_attr, idx;
>  	union bpf_attr attr;
>  
>  	memset(&attr, 0, attr_size);
> @@ -467,9 +521,13 @@ void bpf_gen__map_create(struct bpf_gen *gen,
>  		gen->error = -EDOM; /* internal bug */
>  		return;
>  	} else {
> -		emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7,
> -				      stack_off(map_fd[map_idx])));
> -		gen->nr_maps++;
> +		/* add_map_fd does gen->nr_maps++ */
> +		idx = add_map_fd(gen);
> +		if (idx < 0)
> +			return;

drop it.

> +		emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
> +						 0, 0, 0, blob_fd_array_off(gen, idx)));
> +		emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_7, 0));
>  	}
>  	if (close_inner_map_fd)
>  		emit_sys_close_stack(gen, stack_off(inner_map_fd));
> @@ -511,8 +569,8 @@ static void emit_find_attach_target(struct bpf_gen *gen)
>  	 */
>  }
>  
> -void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind,
> -			    int insn_idx)
> +void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak,
> +			    int kind, int insn_idx)
>  {
>  	struct ksym_relo_desc *relo;
>  
> @@ -524,38 +582,196 @@ void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind,
>  	gen->relos = relo;
>  	relo += gen->relo_cnt;
>  	relo->name = name;
> +	relo->is_weak = is_weak;
>  	relo->kind = kind;
>  	relo->insn_idx = insn_idx;
>  	gen->relo_cnt++;
>  }
>  
> -static void emit_relo(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insns)
> +/* returns existing ksym_desc with ref incremented, or inserts a new one */
> +static struct ksym_desc *get_ksym_desc(struct bpf_gen *gen, struct ksym_relo_desc *relo)
>  {
> -	int name, insn, len = strlen(relo->name) + 1;
> +	struct ksym_desc *kdesc;
>  
> -	pr_debug("gen: emit_relo: %s at %d\n", relo->name, relo->insn_idx);
> -	name = add_data(gen, relo->name, len);
> +	for (int i = 0; i < gen->nr_ksyms; i++) {
> +		if (!strcmp(gen->ksyms[i].name, relo->name)) {
> +			gen->ksyms[i].ref++;
> +			return &gen->ksyms[i];
> +		}
> +	}
> +	kdesc = libbpf_reallocarray(gen->ksyms, gen->nr_ksyms + 1, sizeof(*kdesc));
> +	if (!kdesc) {
> +		gen->error = -ENOMEM;
> +		return NULL;
> +	}
> +	gen->ksyms = kdesc;
> +	kdesc = &gen->ksyms[gen->nr_ksyms++];
> +	kdesc->name = relo->name;
> +	kdesc->kind = relo->kind;
> +	kdesc->ref = 1;
> +	kdesc->off = 0;
> +	kdesc->insn = 0;
> +	return kdesc;
> +}
> +
> +/* Overwrites BPF_REG_{0, 1, 2, 3, 4, 7}
> + * Returns result in BPF_REG_7
> + */
> +static void emit_bpf_find_by_name_kind(struct bpf_gen *gen, struct ksym_relo_desc *relo)
> +{
> +	int name_off, len = strlen(relo->name) + 1;
>  
> +	name_off = add_data(gen, relo->name, len);
> +	if (!name_off)
> +		return;

drop it.

>  	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
> -					 0, 0, 0, name));
> +					 0, 0, 0, name_off));
>  	emit(gen, BPF_MOV64_IMM(BPF_REG_2, len));
>  	emit(gen, BPF_MOV64_IMM(BPF_REG_3, relo->kind));
>  	emit(gen, BPF_MOV64_IMM(BPF_REG_4, 0));
>  	emit(gen, BPF_EMIT_CALL(BPF_FUNC_btf_find_by_name_kind));
>  	emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_0));
>  	debug_ret(gen, "find_by_name_kind(%s,%d)", relo->name, relo->kind);
> -	emit_check_err(gen);
> +}
> +
> +/* Expects:
> + * BPF_REG_8 - pointer to instruction
> + *
> + * We need to reuse BTF fd for same symbol otherwise each relocation takes a new
> + * index, while kernel limits total kfunc BTFs to 256. For duplicate symbols,
> + * this would mean a new BTF fd index for each entry. By pairing symbol name
> + * with index, we get the insn->imm, insn->off pairing that kernel uses for
> + * kfunc_tab, which becomes the effective limit even though all of them may
> + * share same index in fd_array (such that kfunc_btf_tab has 1 element).
> + */
> +static void emit_relo_kfunc_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn)
> +{
> +	struct ksym_desc *kdesc;
> +	int btf_fd_idx;
> +
> +	kdesc = get_ksym_desc(gen, relo);
> +	if (!kdesc)
> +		return;
> +	/* try to copy from existing bpf_insn */
> +	if (kdesc->ref > 1) {
> +		move_blob2blob(gen, insn + offsetof(struct bpf_insn, imm), 4,
> +			       kdesc->insn + offsetof(struct bpf_insn, imm));
> +		move_blob2blob(gen, insn + offsetof(struct bpf_insn, off), 2,
> +			       kdesc->insn + offsetof(struct bpf_insn, off));
> +		goto log;
> +	}
> +	/* remember insn offset, so we can copy BTF ID and FD later */
> +	kdesc->insn = insn;
> +	emit_bpf_find_by_name_kind(gen, relo);
> +	if (!relo->is_weak)
> +		emit_check_err(gen);
> +	/* get index in fd_array to store BTF FD at */
> +	btf_fd_idx = add_kfunc_btf_fd(gen);
> +	if (btf_fd_idx < 0)
> +		return;

drop it.

> +	if (btf_fd_idx > INT16_MAX) {
> +		pr_warn("BTF fd off %d for kfunc %s exceeds INT16_MAX, cannot process relocation\n",
> +			btf_fd_idx, relo->name);
> +		gen->error = -E2BIG;
> +		return;

this one is necessary. keep it.
