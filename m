Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40D74BF235
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 07:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbiBVGqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 01:46:49 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiBVGqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 01:46:48 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DC4111198;
        Mon, 21 Feb 2022 22:46:23 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v8-20020a17090a634800b001bb78857ccdso1453689pjs.1;
        Mon, 21 Feb 2022 22:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xw3owQ+OgY/xBBOrr6vG4BqI5NvglT+Cry2gByHAY6g=;
        b=cNcLKRk+dUtXxbIu7XAICoW8HlRAdIC8ZgjKfDKrErNRyRPfvFCY2KTKsi1CKa7F7M
         x5U02j1c9nZt/oQmxAShQ9iFDOKKeIjCkKDWOnRE50vwLxZG+sn4IsmvZeQavdwBA8wT
         KBLv6va3LJJ89gk4o5pX5b1LiIy69CnndMCJfUSZzCpyoDs8d2CibxDU0XIsE5M4j9ao
         LD+SRMleaZ+vtDCLARw4nQGCNwKbvJ6+fbKKVEXuNHK357PG9uSBYsmSNNPqDSvSYGNM
         bJiqv4k5EjxRtM2t6VpS6vlVmxnyPTEky71BQtAsYOqdoIXb5ndVv3zMpgWOP8hwqAt8
         GyQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xw3owQ+OgY/xBBOrr6vG4BqI5NvglT+Cry2gByHAY6g=;
        b=3Fff3CAhBKtv9WegBHM6fZ64ano/e5W5/KWX8hqceAJlMvzYJT47Tg17SatTZ7eFnq
         4/g9501PqouZNT7BmfTslth/c5PI6+98MfCX2LOw1ftfDXZSHK3HDPRyrMhr56MqmMuz
         1Gwyui9aHheCqvdEh2VtabcwbdCNQK22v4sBXIlJ6DanQ3pvdY+WIgpNzngOqkcZ+C+g
         mVNogcA3RgH80kShcxjNBb1zxVZHhs1MK0c9Gy3x8XunO8LcHRsmdjZwQ+94b/i8Higo
         dXIGbS9RthVyDfjctNWHqIHCk7gYPHvEFSKW8vuiVDxEuD7h0e6mMqlULoaVfV7GLV0q
         z31w==
X-Gm-Message-State: AOAM531m1szSl+Kr7vi+c9QYBQnP7akLUh3F/lQsoOAII2C2Y9m7v2pE
        rbMqDynOloYVRqRKU2r8kYE=
X-Google-Smtp-Source: ABdhPJwS52vf+VV4THnFaJY/kPVR+RtCfcVTgzsRMvSqhihFW30xoNl0XM+WVzKwWAA8OBIGbmvKDQ==
X-Received: by 2002:a17:90a:578a:b0:1bb:f070:bf47 with SMTP id g10-20020a17090a578a00b001bbf070bf47mr2716933pji.58.1645512382842;
        Mon, 21 Feb 2022 22:46:22 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e2d6])
        by smtp.gmail.com with ESMTPSA id a9sm14773654pfl.124.2022.02.21.22.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 22:46:22 -0800 (PST)
Date:   Mon, 21 Feb 2022 22:46:19 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 03/15] bpf: Allow storing PTR_TO_BTF_ID in map
Message-ID: <20220222064619.hsadxbwzeg3go6jb@ast-mbp.dhcp.thefacebook.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
 <20220220134813.3411982-4-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220220134813.3411982-4-memxor@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 20, 2022 at 07:18:01PM +0530, Kumar Kartikeya Dwivedi wrote:
> This patch allows user to embed PTR_TO_BTF_ID in map value, such that
> loading it marks the destination register as having the appropriate
> register type and such a pointer can be dereferenced like usual
> PTR_TO_BTF_ID and be passed to various BPF helpers.
> 
> This feature can be useful to store an object in a map for a long time,
> and then inspect it later. Since PTR_TO_BTF_ID is safe against invalid
> access, verifier doesn't need to perform any complex lifetime checks. It
> can be useful in cases where user already knows pointer will remain
> valid, so any dereference at a later time (possibly in entirely
> different BPF program invocation) will yield correct results as far the
> data read from kernel memory is concerned.
> 
> Note that it is quite possible such BTF ID pointer is invalid, in this
> case the verifier's built-in exception handling mechanism where it
> converts loads into PTR_TO_BTF_ID into PROBE_MEM loads, would handle the
> invalid case. Next patch which adds referenced PTR_TO_BTF_ID would need
> to take more care in ensuring a correct value is stored in the BPF map.
> 
> The user indicates that a certain pointer must be treated as
> PTR_TO_BTF_ID by using a BTF type tag 'btf_id' on the pointed to type of
> the pointer. Then, this information is recorded in the object BTF which
> will be passed into the kernel by way of map's BTF information.
> 
> The kernel then records the type, and offset of all such pointers, and
> finds their corresponding built-in kernel type by the name and BTF kind.
> 
> Later, during verification this information is used that access to such
> pointers is sized correctly, and done at a proper offset into the map
> value. Only BPF_LDX, BPF_STX, and BPF_ST with 0 (to denote NULL) are
> allowed instructions that can access such a pointer. On BPF_LDX, the
> destination register is updated to be a PTR_TO_BTF_ID, and on BPF_STX,
> it is checked whether the source register type is same PTR_TO_BTF_ID,
> and whether the BTF ID (reg->btf and reg->btf_id) matches the type
> specified in the map value's definition.
> 
> Hence, the verifier allows flexible access to kernel data across program
> invocations in a type safe manner, without compromising on the runtime
> safety of the kernel.
> 
> Next patch will extend this support to referenced PTR_TO_BTF_ID.
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/bpf.h     |  30 +++++++-
>  include/linux/btf.h     |   3 +
>  kernel/bpf/btf.c        | 127 ++++++++++++++++++++++++++++++++++
>  kernel/bpf/map_in_map.c |   5 +-
>  kernel/bpf/syscall.c    | 137 ++++++++++++++++++++++++++++++++++++-
>  kernel/bpf/verifier.c   | 148 ++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 446 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index f19abc59b6cd..ce45ffb79f82 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -155,6 +155,23 @@ struct bpf_map_ops {
>  	const struct bpf_iter_seq_info *iter_seq_info;
>  };
>  
> +enum {
> +	/* Support at most 8 pointers in a BPF map value */
> +	BPF_MAP_VALUE_OFF_MAX = 8,
> +};
> +
> +struct bpf_map_value_off_desc {
> +	u32 offset;
> +	u32 btf_id;
> +	struct btf *btf;
> +	struct module *module;
> +};
> +
> +struct bpf_map_value_off {
> +	u32 nr_off;
> +	struct bpf_map_value_off_desc off[];
> +};
> +
>  struct bpf_map {
>  	/* The first two cachelines with read-mostly members of which some
>  	 * are also accessed in fast-path (e.g. ops, max_entries).
> @@ -171,6 +188,7 @@ struct bpf_map {
>  	u64 map_extra; /* any per-map-type extra fields */
>  	u32 map_flags;
>  	int spin_lock_off; /* >=0 valid offset, <0 error */
> +	struct bpf_map_value_off *ptr_off_tab;
>  	int timer_off; /* >=0 valid offset, <0 error */
>  	u32 id;
>  	int numa_node;
> @@ -184,7 +202,7 @@ struct bpf_map {
>  	char name[BPF_OBJ_NAME_LEN];
>  	bool bypass_spec_v1;
>  	bool frozen; /* write-once; write-protected by freeze_mutex */
> -	/* 14 bytes hole */
> +	/* 6 bytes hole */
>  
>  	/* The 3rd and 4th cacheline with misc members to avoid false sharing
>  	 * particularly with refcounting.
> @@ -217,6 +235,11 @@ static inline bool map_value_has_timer(const struct bpf_map *map)
>  	return map->timer_off >= 0;
>  }
>  
> +static inline bool map_value_has_ptr_to_btf_id(const struct bpf_map *map)
> +{
> +	return !IS_ERR_OR_NULL(map->ptr_off_tab);
> +}
> +
>  static inline void check_and_init_map_value(struct bpf_map *map, void *dst)
>  {
>  	if (unlikely(map_value_has_spin_lock(map)))
> @@ -1490,6 +1513,11 @@ void bpf_prog_put(struct bpf_prog *prog);
>  void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock);
>  void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock);
>  
> +struct bpf_map_value_off_desc *bpf_map_ptr_off_contains(struct bpf_map *map, u32 offset);
> +void bpf_map_free_ptr_off_tab(struct bpf_map *map);
> +struct bpf_map_value_off *bpf_map_copy_ptr_off_tab(const struct bpf_map *map);
> +bool bpf_map_equal_ptr_off_tab(const struct bpf_map *map_a, const struct bpf_map *map_b);
> +
>  struct bpf_map *bpf_map_get(u32 ufd);
>  struct bpf_map *bpf_map_get_with_uref(u32 ufd);
>  struct bpf_map *__bpf_map_get(struct fd f);
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 36bc09b8e890..6592183aeb23 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -26,6 +26,7 @@ struct btf_type;
>  union bpf_attr;
>  struct btf_show;
>  struct btf_id_set;
> +struct bpf_map;
>  
>  struct btf_kfunc_id_set {
>  	struct module *owner;
> @@ -123,6 +124,8 @@ bool btf_member_is_reg_int(const struct btf *btf, const struct btf_type *s,
>  			   u32 expected_offset, u32 expected_size);
>  int btf_find_spin_lock(const struct btf *btf, const struct btf_type *t);
>  int btf_find_timer(const struct btf *btf, const struct btf_type *t);
> +int btf_find_ptr_to_btf_id(const struct btf *btf, const struct btf_type *t,
> +			   struct bpf_map *map);
>  bool btf_type_is_void(const struct btf_type *t);
>  s32 btf_find_by_name_kind(const struct btf *btf, const char *name, u8 kind);
>  const struct btf_type *btf_type_skip_modifiers(const struct btf *btf,
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 55f6ccac3388..1edb5710e155 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3122,6 +3122,7 @@ static void btf_struct_log(struct btf_verifier_env *env,
>  enum {
>  	BTF_FIELD_SPIN_LOCK,
>  	BTF_FIELD_TIMER,
> +	BTF_FIELD_KPTR,
>  };
>  
>  static int btf_find_field_struct(const struct btf *btf, const struct btf_type *t,
> @@ -3140,6 +3141,106 @@ static int btf_find_field_struct(const struct btf *btf, const struct btf_type *t
>  	return 0;
>  }
>  
> +static s32 btf_find_by_name_kind_all(const char *name, u32 kind, struct btf **btfp);
> +
> +static int btf_find_field_kptr(const struct btf *btf, const struct btf_type *t,
> +			       u32 off, int sz, void *data)
> +{
> +	struct bpf_map_value_off *tab;
> +	struct bpf_map *map = data;
> +	struct module *mod = NULL;
> +	bool btf_id_tag = false;
> +	struct btf *kernel_btf;
> +	int nr_off, ret;
> +	s32 id;
> +
> +	/* For PTR, sz is always == 8 */
> +	if (!btf_type_is_ptr(t))
> +		return 0;
> +	t = btf_type_by_id(btf, t->type);
> +
> +	while (btf_type_is_type_tag(t)) {
> +		if (!strcmp("kernel.bpf.btf_id", __btf_name_by_offset(btf, t->name_off))) {

All of these strings consume space.
Multiple tags consume space too.
I would just do:
#define __kptr __attribute__((btf_type_tag("kptr")))
#define __kptr_ref __attribute__((btf_type_tag("kptr_ref")))
#define __kptr_percpu __attribute__((btf_type_tag("kptr_percpu")))
#define __kptr_user __attribute__((btf_type_tag("kptr_user")))

> +			/* repeated tag */
> +			if (btf_id_tag) {
> +				ret = -EINVAL;
> +				goto end;
> +			}
> +			btf_id_tag = true;
> +		} else if (!strncmp("kernel.", __btf_name_by_offset(btf, t->name_off),
> +			   sizeof("kernel.") - 1)) {
> +			/* TODO: Should we reject these when loading BTF? */
> +			/* Unavailable tag in reserved tag namespace */

I don't think we need to reserve the tag space.
There is little risk to break progs with future tags.
I would just drop this 'if'.

> +			ret = -EACCES;
> +			goto end;
> +		}
> +		/* Look for next tag */
> +		t = btf_type_by_id(btf, t->type);
> +	}
> +	if (!btf_id_tag)
> +		return 0;
> +
> +	/* Get the base type */
> +	if (btf_type_is_modifier(t))
> +		t = btf_type_skip_modifiers(btf, t->type, NULL);
> +	/* Only pointer to struct is allowed */
> +	if (!__btf_type_is_struct(t)) {
> +		ret = -EINVAL;
> +		goto end;
> +	}
> +
> +	id = btf_find_by_name_kind_all(__btf_name_by_offset(btf, t->name_off),
> +				       BTF_INFO_KIND(t->info), &kernel_btf);
> +	if (id < 0) {
> +		ret = id;
> +		goto end;
> +	}
> +
> +	nr_off = map->ptr_off_tab ? map->ptr_off_tab->nr_off : 0;
> +	if (nr_off == BPF_MAP_VALUE_OFF_MAX) {
> +		ret = -E2BIG;
> +		goto end_btf;
> +	}
> +
> +	tab = krealloc(map->ptr_off_tab, offsetof(struct bpf_map_value_off, off[nr_off + 1]),
> +		       GFP_KERNEL | __GFP_NOWARN);

Argh.
If the function is called btf_find_field() it should do 'find' and only 'find'.
It should be side effect free and should find _one_ field.
If you want a function with side effcts it should be called something like btf_walk_fields.

For this case how about side effect free btf_find_fieldS() that will populate array
struct bpf_field_info {
  struct btf *type; /* set for spin_lock, timer, kptr */
  u32 off;
  int flags; /* ref|percpu|user for kptr */
};

cnt = btf_find_fields(prog_btf, value_type, BTF_FIELD_SPIN_LOCK|TIMER|KPTR, fields);

btf_find_struct_field/btf_find_datasec_var will keep the count and will error
when it reaches BPF_MAP_VALUE_OFF_MAX. 
switch (field_type) {
case BTF_FIELD_SPIN_LOCK:
   btf_find_field_struct(... "bpf_spin_lock",
                             sizeof(struct bpf_spin_lock),
                             __alignof__(struct bpf_spin_lock),
                             fields + i);
case BTF_FIELD_TIMER:
   btf_find_field_struct(... "bpf_timer", sizeof, alignof, fields + i);
case BTF_FIELD_KPTR:
   btf_find_field_kptr(... fields + i);
}

btf_find_by_name_kind_all (or new name bpf_find_btf_id)
will be done after btf_find_fields() is over.
dtor will be found after as well.
struct bpf_map_value_off will be allocated once.

> +	if (!tab) {
> +		ret = -ENOMEM;
> +		goto end_btf;
> +	}
> +	/* Initialize nr_off for newly allocated ptr_off_tab */
> +	if (!map->ptr_off_tab)
> +		tab->nr_off = 0;
> +	map->ptr_off_tab = tab;
> +
> +	/* We take reference to make sure valid pointers into module data don't
> +	 * become invalid across program invocation.
> +	 */

what is the point of grabbing mod ref?
This patch needs btf only and its refcnt will be incremented by bpf_find_btf_id.
Is that because of future dtor ?
Then it should be part of that patch.

> +	if (btf_is_module(kernel_btf)) {
> +		mod = btf_try_get_module(kernel_btf);
> +		if (!mod) {
> +			ret = -ENXIO;
> +			goto end_btf;
> +		}
> +	}
> +
> +	tab->off[nr_off].offset = off;
> +	tab->off[nr_off].btf_id = id;
> +	tab->off[nr_off].btf    = kernel_btf;
> +	tab->off[nr_off].module = mod;
> +	tab->nr_off++;
> +
> +	return 0;
> +end_btf:
> +	/* Reference is only raised for module BTF */
> +	if (btf_is_module(kernel_btf))
> +		btf_put(kernel_btf);

see earlier suggestion. this 'if' can be dropped if we btf_get for vmlinux_btf too.

> +end:
> +	bpf_map_free_ptr_off_tab(map);
> +	map->ptr_off_tab = ERR_PTR(ret);
> +	return ret;
> +}
