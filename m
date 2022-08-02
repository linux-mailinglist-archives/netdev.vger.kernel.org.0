Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBF5587684
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 06:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbiHBE6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 00:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiHBE6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 00:58:37 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5C720F70;
        Mon,  1 Aug 2022 21:58:36 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id f11so11408977pgj.7;
        Mon, 01 Aug 2022 21:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DyhaeTW9f5GhYzErI4fBnQUAn6U1BD6Waal2X1wlIWI=;
        b=GzGtHUHQ1BP1in16d7bw7qQU6eCUeOZ/9m9lb4K1GIvcEXYEMCaMJLOkRYnLUZkzXq
         e5HZi6x1AUE/NiBdCAaiTJ9MlaBRT6+DFWyCxH2oXmv2rBPswVqbG1dKbi7TYwWhYjWV
         zn/ITHoNbRYuxw/3LciM+RvA/oFoqLVvIhAWjZUJUqehxISW5KL3mRpYb59Rw17HpjZH
         rjYlDQywscRleUrgMNnWeQBdNMJBO9MXB42gdtfPmleSeYoBsqBjwlWwVe8GtszH7lIe
         nCb4EpMM7kr/2aUoE23jRviyHoNSzI3N/YmuL/oeDAuAtYXcmC7y3E5YZx6E+Y8nBogu
         NY/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DyhaeTW9f5GhYzErI4fBnQUAn6U1BD6Waal2X1wlIWI=;
        b=AOZ53O7SVn4kmew2iwPQFzhr4AMc+JK3ngHJG3cJ9hZBwC12I/0sEz41ziSA0rVKRy
         Y0AlWDWmOT5XxHb5ImiGz4HdsV5TIayGl34XvNlJjkgOiZwaRwCkpUMgy2TUGiwXwGjm
         Tuk2kWjKu2aXHDoHuue1ljWclzdcEBvNvLr8vcVtorlOZ5ywMkbo1LC8Fh25TGSVHiLO
         Xgp07UCe7ZKa1OpLHukGA6Z1/UHOw73v/Bo55J2eSH+VfcbswATYdWLHcVlBxuTF9oQl
         u2T5iYflgqB6sZXKcz1wWkDgVDvnvU5DBoWTIXxFLB9KWgucZDnQgGBkpV3MVPJsfqpm
         n2CQ==
X-Gm-Message-State: AJIora+D09S6Vjuo+YLxlRJEWdywuwHK2+JvH8JVf1dBRF0x6unyyQku
        c2DS9390jocohUSvBACxtAA=
X-Google-Smtp-Source: AGRyM1tLzYwvaGNFxnzUI4wHKeMIi2r2mPIFVQgRez5sy9rQtLdF35p6pqm9Y6GrlIaAEGbW7T9jlQ==
X-Received: by 2002:a63:f446:0:b0:41a:d6cb:5296 with SMTP id p6-20020a63f446000000b0041ad6cb5296mr15572370pgk.426.1659416316071;
        Mon, 01 Aug 2022 21:58:36 -0700 (PDT)
Received: from macbook-pro-3.dhcp.thefacebook.com ([2620:10d:c090:400::5:f128])
        by smtp.gmail.com with ESMTPSA id u12-20020a62790c000000b005252a06750esm5341861pfc.182.2022.08.01.21.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 21:58:35 -0700 (PDT)
Date:   Mon, 1 Aug 2022 21:58:32 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH bpf-next 05/15] bpf: Introduce helpers for container
 of struct bpf_map
Message-ID: <20220802045832.fcgzvkenet7cmvy7@macbook-pro-3.dhcp.thefacebook.com>
References: <20220729152316.58205-1-laoar.shao@gmail.com>
 <20220729152316.58205-6-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729152316.58205-6-laoar.shao@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 03:23:06PM +0000, Yafang Shao wrote:
> Currently bpf_map_area_alloc() is used to allocate a container of struct
> bpf_map or members in this container. To distinguish the map creation
> and other members, let split it into two different helpers,
>   - bpf_map_container_alloc()
>     Used to allocate a container of struct bpf_map, the container is as
>     follows,
>       struct bpf_map_container {
>         struct bpf_map map;  // the map must be the first member
>         ....
>       };
>     Pls. note that the struct bpf_map_contianer is a abstract one, which
>     can be struct bpf_array, struct bpf_bloom_filter and etc.
> 
>     In this helper, it will call bpf_map_save_memcg() to init memcg
>     relevant data in the bpf map. And these data will be cleared in
>     bpf_map_container_free().
> 
>   - bpf_map_area_alloc()
>     Now it is used to allocate the members in a contianer only.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  include/linux/bpf.h  |  4 ++++
>  kernel/bpf/syscall.c | 56 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 20c26aed7896..2d971b0eb24b 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1634,9 +1634,13 @@ void bpf_map_inc_with_uref(struct bpf_map *map);
>  struct bpf_map * __must_check bpf_map_inc_not_zero(struct bpf_map *map);
>  void bpf_map_put_with_uref(struct bpf_map *map);
>  void bpf_map_put(struct bpf_map *map);
> +void *bpf_map_container_alloc(u64 size, int numa_node);
> +void *bpf_map_container_mmapable_alloc(u64 size, int numa_node,
> +				       u32 align, u32 offset);
>  void *bpf_map_area_alloc(u64 size, int numa_node);
>  void *bpf_map_area_mmapable_alloc(u64 size, int numa_node);
>  void bpf_map_area_free(void *base);
> +void bpf_map_container_free(void *base);
>  bool bpf_map_write_active(const struct bpf_map *map);
>  void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
>  int  generic_map_lookup_batch(struct bpf_map *map,
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 83c7136c5788..1a1a81a11b37 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -495,6 +495,62 @@ static void bpf_map_release_memcg(struct bpf_map *map)
>  }
>  #endif
>  
> +/*
> + * The return pointer is a bpf_map container, as follow,
> + *   struct bpf_map_container {
> + *       struct bpf_map map;
> + *       ...
> + *   };
> + *
> + * It is used in map creation path.
> + */
> +void *bpf_map_container_alloc(u64 size, int numa_node)
> +{
> +	struct bpf_map *map;
> +	void *container;
> +
> +	container = __bpf_map_area_alloc(size, numa_node, false);
> +	if (!container)
> +		return NULL;
> +
> +	map = (struct bpf_map *)container;
> +	bpf_map_save_memcg(map);
> +
> +	return container;
> +}
> +
> +void *bpf_map_container_mmapable_alloc(u64 size, int numa_node, u32 align,
> +				       u32 offset)
> +{
> +	struct bpf_map *map;
> +	void *container;
> +	void *ptr;
> +
> +	/* kmalloc'ed memory can't be mmap'ed, use explicit vmalloc */
> +	ptr = __bpf_map_area_alloc(size, numa_node, true);
> +	if (!ptr)
> +		return NULL;
> +
> +	container = ptr + align - offset;
> +	map = (struct bpf_map *)container;
> +	bpf_map_save_memcg(map);

This is very error prone.
I don't think the container concept is necessary.
bpf_map_area_alloc() can just take extra memcg_fd argument.

> +
> +	return ptr;
> +}
> +
> +void bpf_map_container_free(void *container)
> +{
> +	struct bpf_map *map;
> +
> +	if (!container)
> +		return;
> +
> +	map = (struct bpf_map *)container;
> +	bpf_map_release_memcg(map);
> +
> +	kvfree(container);
> +}
> +
>  static int bpf_map_kptr_off_cmp(const void *a, const void *b)
>  {
>  	const struct bpf_map_value_off_desc *off_desc1 = a, *off_desc2 = b;
> -- 
> 2.17.1
> 
