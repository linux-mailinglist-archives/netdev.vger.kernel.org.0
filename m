Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD5658767F
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 06:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbiHBEzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 00:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbiHBEzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 00:55:37 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2FE7659;
        Mon,  1 Aug 2022 21:55:36 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id iw1so12392390plb.6;
        Mon, 01 Aug 2022 21:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CfmpytoP729KBrN0HCzeLOcgvNe2bvNCsG8itxfX62A=;
        b=HutUsTmKqv1x84jl4mEIEyI3ISfnr19onU2OnC3p4Wu9LqhA/aldHwYOntlFOHEJ/c
         erYKWaw+04Bh0o3tWH8mFSR1GeEtQHps708aVOr9jybaBNoSdelKef28JcAyHME7Wj9V
         a0igeAWQ2inL0sN9BUS6LjKtvuEQ8C69IVgpz+hyv2nkV06hcrKuZHDdWTTAVJBeRmwY
         mmdP8kc68jZAYgcfp5Lag/6UlcUN9hgeqWNujtpjisUtNBh9ee5+r/gKzZMmw9zyw7NB
         c/JV+uFCnblP2k3htlaOBx6Nhh+2xIR5zwVNDRIsdkodKzaW8JKeBRffYOWUTNZIPjAf
         k6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CfmpytoP729KBrN0HCzeLOcgvNe2bvNCsG8itxfX62A=;
        b=nvQtdkWzbLC8UGlC7JXq+AR5g6S9gcyKdvRJbwx/4uD+uHCodUPSly+PgbOzZ8YuQt
         7Wm52eQUiprBDwQzUTe/koeYp9u5/jv0OTwcVbAFd321WeOpqoUBTCu2rGfCCVZ8c4Oa
         CJNIBPOHilvXsEOKqb4ZPdcXcQ59giGDYITF+2jpfNnE8Ygm5u9RwfrQ7zG6fbCXYW3a
         CXZnX22ysi6BaY2AQRshYeJRznqXTynJuJiAMjI4X/zLmuX9YhYfvr1d3Y3+cZVA0Xov
         ifWBRNzC6PRhdLx/th1Cf7S9WGtQdIUuspdxEhhXZ/+oghqWZPTyTFOSq2ULTFvTwgpi
         G5hg==
X-Gm-Message-State: ACgBeo3OgoTbqDE7ItAOi0ITR+HdiD9TteaeDgYh2eAJrKaKtaBzMsOx
        gHGhcuy6tvcWdTw//vP78o217QhrgpI=
X-Google-Smtp-Source: AA6agR5abzkookXYg+7B+7RpeEfKg6JXotSBK2J6TwDpU2O6h3YFjqgHl6wqe1OHdaTr3EOlS/w0Xw==
X-Received: by 2002:a17:902:db06:b0:16e:e5fc:56d8 with SMTP id m6-20020a170902db0600b0016ee5fc56d8mr9232424plx.100.1659416135598;
        Mon, 01 Aug 2022 21:55:35 -0700 (PDT)
Received: from macbook-pro-3.dhcp.thefacebook.com ([2620:10d:c090:400::5:f128])
        by smtp.gmail.com with ESMTPSA id v10-20020a1709028d8a00b0016bfbd99f64sm10537070plo.118.2022.08.01.21.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 21:55:35 -0700 (PDT)
Date:   Mon, 1 Aug 2022 21:55:31 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH bpf-next 15/15] bpf: Introduce selectable memcg for
 bpf map
Message-ID: <20220802045531.6oi2pt3fyjhotmjo@macbook-pro-3.dhcp.thefacebook.com>
References: <20220729152316.58205-1-laoar.shao@gmail.com>
 <20220729152316.58205-16-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729152316.58205-16-laoar.shao@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 03:23:16PM +0000, Yafang Shao wrote:
> A new member memcg_fd is introduced into bpf attr of BPF_MAP_CREATE
> command, which is the fd of an opened cgroup directory. In this cgroup,
> the memory subsystem must be enabled. This value is valid only when
> BPF_F_SELECTABLE_MEMCG is set in map_flags. Once the kernel get the
> memory cgroup from this fd, it will set this memcg into bpf map, then
> all the subsequent memory allocation of this map will be charge to the
> memcg.
> 
> The map creation paths in libbpf are also changed consequently.
> 
> Currently it is only supported for cgroup2 directory.
> 
> The usage of this new member as follows,
> 	struct bpf_map_create_opts map_opts = {
> 		.sz = sizeof(map_opts),
> 		.map_flags = BPF_F_SELECTABLE_MEMCG,
> 	};
> 	int memcg_fd, int map_fd;
> 	int key, value;
> 
> 	memcg_fd = open("/cgroup2", O_DIRECTORY);
> 	if (memcg_fd < 0) {
> 		perror("memcg dir open");
> 		return -1;
> 	}
> 
> 	map_opts.memcg_fd = memcg_fd;
> 	map_fd = bpf_map_create(BPF_MAP_TYPE_HASH, "map_for_memcg",
> 				sizeof(key), sizeof(value),
> 				1024, &map_opts);
> 	if (map_fd <= 0) {
> 		perror("map create");
> 		return -1;
> 	}

Overall the api extension makes sense.
The flexibility of selecting memcg is useful.

> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  include/uapi/linux/bpf.h       |  2 ++
>  kernel/bpf/syscall.c           | 47 ++++++++++++++++++++++++++--------
>  tools/include/uapi/linux/bpf.h |  2 ++
>  tools/lib/bpf/bpf.c            |  1 +
>  tools/lib/bpf/bpf.h            |  3 ++-
>  tools/lib/bpf/libbpf.c         |  2 ++
>  6 files changed, 46 insertions(+), 11 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index d5fc1ea70b59..a6e02c8be924 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1296,6 +1296,8 @@ union bpf_attr {
>  						   * struct stored as the
>  						   * map value
>  						   */
> +		__s32	memcg_fd;	/* selectable memcg */
> +		__s32	:32;		/* hole */

new fields cannot be inserted in the middle of uapi struct.

>  		/* Any per-map-type extra fields
>  		 *
>  		 * BPF_MAP_TYPE_BLOOM_FILTER - the lowest 4 bits indicate the
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 6401cc417fa9..9900e2b87315 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -402,14 +402,30 @@ void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock)
>  }
>  
>  #ifdef CONFIG_MEMCG_KMEM
> -static void bpf_map_save_memcg(struct bpf_map *map)
> +static int bpf_map_save_memcg(struct bpf_map *map, union bpf_attr *attr)
>  {
> -	/* Currently if a map is created by a process belonging to the root
> -	 * memory cgroup, get_obj_cgroup_from_current() will return NULL.
> -	 * So we have to check map->objcg for being NULL each time it's
> -	 * being used.
> -	 */
> -	map->objcg = get_obj_cgroup_from_current();
> +	struct obj_cgroup *objcg;
> +	struct cgroup *cgrp;
> +
> +	if (attr->map_flags & BPF_F_SELECTABLE_MEMCG) {

The flag is unnecessary. Just add memcg_fd to the end of attr and use != 0
as a condition that it should be used instead of get_obj_cgroup_from_current().
There are other parts of bpf uapi that have similar fd handling logic.

> +		cgrp = cgroup_get_from_fd(attr->memcg_fd);
> +		if (IS_ERR(cgrp))
> +			return -EINVAL;
> +
> +		objcg = get_obj_cgroup_from_cgroup(cgrp);
> +		if (IS_ERR(objcg))
> +			return PTR_ERR(objcg);
> +	} else {
> +		/* Currently if a map is created by a process belonging to the root
> +		 * memory cgroup, get_obj_cgroup_from_current() will return NULL.
> +		 * So we have to check map->objcg for being NULL each time it's
> +		 * being used.
> +		 */
> +		objcg = get_obj_cgroup_from_current();
> +	}
> +
> +	map->objcg = objcg;
> +	return 0;
>  }
>  
>  static void bpf_map_release_memcg(struct bpf_map *map)
> @@ -485,8 +501,9 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
>  }
>  
>  #else
> -static void bpf_map_save_memcg(struct bpf_map *map)
> +static int bpf_map_save_memcg(struct bpf_map *map, union bpf_attr *attr)
>  {
> +	return 0;
>  }
>  
>  static void bpf_map_release_memcg(struct bpf_map *map)
> @@ -530,13 +547,18 @@ void *bpf_map_container_alloc(union bpf_attr *attr, u64 size, int numa_node)

High level uapi struct should not be passed into low level helper like this.
Pls pass memcg_fd instead.

>  {
>  	struct bpf_map *map;
>  	void *container;
> +	int ret;
>  
>  	container = __bpf_map_area_alloc(size, numa_node, false);
>  	if (!container)
>  		return ERR_PTR(-ENOMEM);
>  
>  	map = (struct bpf_map *)container;
> -	bpf_map_save_memcg(map);
> +	ret = bpf_map_save_memcg(map, attr);
> +	if (ret) {
> +		bpf_map_area_free(container);
> +		return ERR_PTR(ret);
> +	}
>  
>  	return container;
>  }
> @@ -547,6 +569,7 @@ void *bpf_map_container_mmapable_alloc(union bpf_attr *attr, u64 size,
>  	struct bpf_map *map;
>  	void *container;
>  	void *ptr;
> +	int ret;
>  
>  	/* kmalloc'ed memory can't be mmap'ed, use explicit vmalloc */
>  	ptr = __bpf_map_area_alloc(size, numa_node, true);
> @@ -555,7 +578,11 @@ void *bpf_map_container_mmapable_alloc(union bpf_attr *attr, u64 size,
>  
>  	container = ptr + align - offset;
>  	map = (struct bpf_map *)container;
> -	bpf_map_save_memcg(map);
> +	ret = bpf_map_save_memcg(map, attr);
> +	if (ret) {
> +		bpf_map_area_free(ptr);
> +		return ERR_PTR(ret);
> +	}
>  
>  	return ptr;
>  }
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index d5fc1ea70b59..a6e02c8be924 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -1296,6 +1296,8 @@ union bpf_attr {
>  						   * struct stored as the
>  						   * map value
>  						   */
> +		__s32	memcg_fd;	/* selectable memcg */
> +		__s32	:32;		/* hole */
>  		/* Any per-map-type extra fields
>  		 *
>  		 * BPF_MAP_TYPE_BLOOM_FILTER - the lowest 4 bits indicate the
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 5eb0df90eb2b..662ce5808386 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -199,6 +199,7 @@ int bpf_map_create(enum bpf_map_type map_type,
>  	attr.map_extra = OPTS_GET(opts, map_extra, 0);
>  	attr.numa_node = OPTS_GET(opts, numa_node, 0);
>  	attr.map_ifindex = OPTS_GET(opts, map_ifindex, 0);
> +	attr.memcg_fd = OPTS_GET(opts, memcg_fd, 0);
>  
>  	fd = sys_bpf_fd(BPF_MAP_CREATE, &attr, attr_sz);
>  	return libbpf_err_errno(fd);
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index 88a7cc4bd76f..481aad49422b 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -51,8 +51,9 @@ struct bpf_map_create_opts {
>  
>  	__u32 numa_node;
>  	__u32 map_ifindex;
> +	__u32 memcg_fd;
>  };
> -#define bpf_map_create_opts__last_field map_ifindex
> +#define bpf_map_create_opts__last_field memcg_fd
>  
>  LIBBPF_API int bpf_map_create(enum bpf_map_type map_type,
>  			      const char *map_name,
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 50d41815f431..86916d550031 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -505,6 +505,7 @@ struct bpf_map {
>  	bool pinned;
>  	bool reused;
>  	bool autocreate;
> +	__s32 memcg_fd;
>  	__u64 map_extra;
>  };
>  
> @@ -4928,6 +4929,7 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, b
>  	create_attr.map_ifindex = map->map_ifindex;
>  	create_attr.map_flags = def->map_flags;
>  	create_attr.numa_node = map->numa_node;
> +	create_attr.memcg_fd = map->memcg_fd;
>  	create_attr.map_extra = map->map_extra;
>  
>  	if (bpf_map__is_struct_ops(map))
> -- 
> 2.17.1
> 
