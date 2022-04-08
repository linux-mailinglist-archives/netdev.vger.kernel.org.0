Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DA44F9FD5
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 01:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237256AbiDHXCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 19:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiDHXCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 19:02:11 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9D25EDFA;
        Fri,  8 Apr 2022 16:00:04 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id t4so8974910pgc.1;
        Fri, 08 Apr 2022 16:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z5SguUuwzzxEHV4Wd/7o+wYJyRcFlc93ZqC0gQZ1tro=;
        b=TX6EqgEkpiMeWOESQOu65B4Jl0svOBzuyTbSsYFk6Msj9fd8vemcvgbyLXkfvYLkT6
         CBEptoSmQ4/fM5bZ/so+kyuDe3DhR4ZfZgeE5oyT/jO0Tq6NNfHArsdR2+KH9nm8qn9p
         R55AeppyJ/U3WiGin9LhSoSCWoXWCDo9lyPr0S1159yzZQE/HBEXgHjM2VrN9dwQjFyy
         tmVoeqGFae/Lteke7+mh+6pV3iLd4tBjZmhCXqeEr03f7rxb0FNN5LmB5kOiRwGED66M
         u06K3DpJG0gU+/TPsdC2lsFJIZ68560MPlNtEjrS2yh4MPgaPk6TDR9HfxSBfjYz3plz
         DVjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z5SguUuwzzxEHV4Wd/7o+wYJyRcFlc93ZqC0gQZ1tro=;
        b=s44UgFoDJi64imcNLr2ytYMovvjR5X85BgBb2q7EvAZ3UbwUjISNDDqGGow//qDKCG
         9p2vwHx52BQBiZj4rzov0eC1ClfkRj3vfBUYX7ZPQRubEIel3Ea571ZwtbM8L3A4oMXX
         XREULHxRK9R5sQezFWUpVNgHq6YxfQ7WmZspX2GIIrrcpvTDWgDRU7dbX2w6b1fm9+Hr
         aNq/BE12F509+iEw0qh930Fd7mDvabsD92SixgFzxr4qp/IWlZJ3CuDPuhE4OGSoWDkI
         BjB9DBUGC0/8OCBoQ4eLKOCbO+yttIgHn0qaF+NE5HioB7HV8UwHGoRNFNetmb3HlBSO
         wZ8g==
X-Gm-Message-State: AOAM532M8g0dgAGp/TcTX2VZAjtbohB9EQWYz2T6n27DKJDNV24sHpVm
        LrQnGD+GjaIUJAK8fpl0Wgo=
X-Google-Smtp-Source: ABdhPJzOkvpH9KQqsrx+UL9Pu/xznjF+cRWhyf0csSpT413q/zU1MzXeeUT5qIeFQnXgayup5wPbmg==
X-Received: by 2002:a05:6a00:24cd:b0:4fd:9038:8aa4 with SMTP id d13-20020a056a0024cd00b004fd90388aa4mr21822622pfv.78.1649458803766;
        Fri, 08 Apr 2022 16:00:03 -0700 (PDT)
Received: from MBP-98dd607d3435.dhcp.thefacebook.com ([2620:10d:c090:400::5:4c4c])
        by smtp.gmail.com with ESMTPSA id n14-20020a17090a394e00b001c670d67b8esm13162104pjf.32.2022.04.08.16.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 16:00:03 -0700 (PDT)
Date:   Fri, 8 Apr 2022 16:00:00 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 1/2] bpf: Introduce ternary search tree for
 string key
Message-ID: <20220408230000.d3g3a2labycjbd7u@MBP-98dd607d3435.dhcp.thefacebook.com>
References: <20220331122822.14283-1-houtao1@huawei.com>
 <20220331122822.14283-2-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331122822.14283-2-houtao1@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 08:28:21PM +0800, Hou Tao wrote:
> Now for string key in hash-table, the storage size of key for each
> element is the size of longest string. If there are large differencies
> in string length and comm prefixes between these strings, there will be
> lots of space waste. So introduce a specific map for string key: ternary
> search tree.
> 
> Ternary search tree is a special trie where nodes are arranged in a
> manner similar to binary search tree, but with up to three children
> rather than two. The three children correpond to nodes whose value is
> less than, equal to, and greater than the value of current node
> respectively.
> 
> For each key in ternary search map, only the content before the
> terminated null byte is saved. And just like trie, the common prefixes
> between these strings are shared and it can reducee the memory usage
> significantly for hierarchical string (e.g. file path with lengthy
> prefix). But the space efficiency comes at a price: the lookup
> performance is about x2~x3 or more slower compared with hash table for
> small or medium data set.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  include/linux/bpf_types.h      |   1 +
>  include/uapi/linux/bpf.h       |   1 +
>  kernel/bpf/Makefile            |   1 +
>  kernel/bpf/bpf_tst.c           | 411 +++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |   1 +
>  5 files changed, 415 insertions(+)
>  create mode 100644 kernel/bpf/bpf_tst.c
> 
> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index 48a91c51c015..8ffb3ab7f337 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -126,6 +126,7 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
>  #endif
>  BPF_MAP_TYPE(BPF_MAP_TYPE_RINGBUF, ringbuf_map_ops)
>  BPF_MAP_TYPE(BPF_MAP_TYPE_BLOOM_FILTER, bloom_filter_map_ops)
> +BPF_MAP_TYPE(BPF_MAP_TYPE_TST, bpf_tst_map_ops)
>  
>  BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
>  BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b0383d371b9a..470bf9a9353d 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -907,6 +907,7 @@ enum bpf_map_type {
>  	BPF_MAP_TYPE_INODE_STORAGE,
>  	BPF_MAP_TYPE_TASK_STORAGE,
>  	BPF_MAP_TYPE_BLOOM_FILTER,
> +	BPF_MAP_TYPE_TST,
>  };
>  
>  /* Note that tracing related programs such as
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index c1a9be6a4b9f..65176d4e99bf 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -10,6 +10,7 @@ obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_i
>  obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o bloom_filter.o
>  obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
>  obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
> +obj-$(CONFIG_BPF_SYSCALL) += bpf_tst.o
>  obj-${CONFIG_BPF_LSM}	  += bpf_inode_storage.o
>  obj-$(CONFIG_BPF_SYSCALL) += disasm.o
>  obj-$(CONFIG_BPF_JIT) += trampoline.o
> diff --git a/kernel/bpf/bpf_tst.c b/kernel/bpf/bpf_tst.c
> new file mode 100644
> index 000000000000..ab82aecaa023
> --- /dev/null
> +++ b/kernel/bpf/bpf_tst.c
> @@ -0,0 +1,411 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (C) 2022. Huawei Technologies Co., Ltd */
> +#include <linux/bpf.h>
> +#include <linux/rcupdate.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +
> +/*
> + * Ternary search tree is a special trie where nodes are arranged in
> + * a manner similar to binary search tree, but with up to three children
> + * rather than two. The three children correpond to nodes whose value is
> + * less than, equal to, and greater than the value of current node
> + * respectively.
> + *
> + * The following are illustrations of ternary search tree during inserting
> + * hello, he, test, tea and team:
> + *
> + * 1. insert "hello"
> + *
> + *         [ hello ]
> + *
> + * 2. insert "he": need split "hello" into "he" and "llo"
> + *
> + *          [ he ]
> + *             |
> + *             *
> + *             |
> + *          [ llo ]
> + *
> + * 3. insert "test": add it as right child of "he"
> + *
> + *          [ he ]
> + *             |
> + *             *-------x
> + *             |       |
> + *          [ llo ] [ test ]
> + *
> + * 5. insert "tea": split "test" into "te" and "st",
> + *    and insert "a" as left child of "st"
> + *
> + *          [ he ]
> + *             |
> + *      x------*-------x
> + *      |      |       |
> + *   [ ah ] [ llo ] [ te ]
> + *                     |
> + *                     *
> + *                     |
> + *                  [ st ]
> + *                     |
> + *                x----*
> + *                |
> + *              [ a ]
> + *
> + * 6. insert "team": insert "m" as middle child of "a"
> + *
> + *          [ he ]
> + *             |
> + *             *-------x
> + *             |       |
> + *          [ llo ] [ te ]
> + *                     |
> + *                     *
> + *                     |
> + *                  [ st ]
> + *                     |
> + *                x----*
> + *                |
> + *              [ a ]
> + *                |
> + *                *
> + *                |
> + *              [ m ]
> + */
> +#define TST_CREATE_FLAG_MASK \
> +	(BPF_F_NUMA_NODE | BPF_F_NO_PREALLOC | BPF_F_ACCESS_MASK)
> +
> +struct bpf_tst_node;
> +
> +struct bpf_tst_node {
> +	struct rcu_head rcu;
> +	struct bpf_tst_node __rcu *child[3];
> +	u32 len;
> +	bool leaf;
> +	u8 key[];
> +};
> +
> +struct bpf_tst {
> +	struct bpf_map map;
> +	struct bpf_tst_node __rcu *root;
> +	size_t nr_entries;
> +	spinlock_t lock;
> +};
> +
> +/*
> + * match_prefix() - check whether prefix is fully matched
> + *
> + * @next: returns the position of next-to-compare character in str
> + *
> + * Return 0 if str has prefix, 1 if str > prefix and -1 if str < prefix
> + */
> +static int match_prefix(const unsigned char *prefix, int len,
> +			const unsigned char *str, int *next)
> +{
> +	int i;
> +
> +	for (i = 0; i < len; i++) {
> +		int cmp = str[i] - prefix[i];
> +
> +		if (cmp) {
> +			*next = i;
> +			return cmp > 0 ? 1 : -1;
> +		}
> +		if (!str[i])
> +			break;
> +	}
> +
> +	*next = len;
> +	return 0;
> +}
> +
> +/* Called from syscall or from eBPF program */
> +static void *tst_lookup_elem(struct bpf_map *map, void *key)
> +{
> +	struct bpf_tst *tst = container_of(map, struct bpf_tst, map);
> +	struct bpf_tst_node *node;
> +	const unsigned char *c = key;
> +
> +	/* A null terminated non-empty string */
> +	if (!c[0] || c[map->key_size - 1])
> +		return NULL;

Looks like map->key_size is only used to make sure that
strlen(c) doesn't go over key_size bytes that were guaranteed by the verifier.
Looks like the algorithm should work for any blob of bytes instead of a string.
Can we make 'key' to be variable length similar to lpm?
Where first u32 would be the length of the blob.

> +
> +	node = rcu_dereference_protected(tst->root, rcu_read_lock_held());
> +	while (node) {
> +		int cmp;
> +		int next;
> +
> +		cmp = match_prefix(node->key, node->len, c, &next);
> +		/* Partially match an internal node */
> +		if (cmp && next)
> +			return NULL;
> +
> +		c += next;
> +		/* Fully match */
> +		if (!cmp && !*c) {
> +			if (node->leaf)
> +				return node->key + node->len;
> +			return NULL;
> +		}
> +
> +		node = rcu_dereference_protected(node->child[cmp + 1],
> +						 rcu_read_lock_held());
> +	}
> +
> +	return NULL;
> +}
> +
> +/* Split node into two nodes */
> +static struct bpf_tst_node *
> +split_tst_node(struct bpf_map *map, struct bpf_tst_node *node, int next, void *value)
> +{
> +	struct bpf_tst_node *bot, *top;
> +	size_t size;
> +
> +	size = sizeof(*bot) + node->len - next;
> +	if (node->leaf)
> +		size += map->value_size;
> +	bot = bpf_map_kmalloc_node(map, size, GFP_ATOMIC | __GFP_NOWARN,
> +				   map->numa_node);
> +	if (!bot)
> +		return NULL;
> +
> +	bot->child[0] = NULL;
> +	/* node has been initialized, so no rcu_assign_pointer() */
> +	bot->child[1] = node->child[1];
> +	bot->child[2] = NULL;
> +	bot->len = node->len - next;
> +	bot->leaf = node->leaf;
> +	memcpy(bot->key, node->key + next, bot->len);
> +	if (bot->leaf)
> +		memcpy(bot->key + bot->len, node->key + node->len,
> +		       map->value_size);
> +
> +	size = sizeof(*top) + next;
> +	if (value)
> +		size += map->value_size;
> +	top = bpf_map_kmalloc_node(map, size, GFP_ATOMIC | __GFP_NOWARN,
> +				   map->numa_node);
> +	if (!top) {
> +		kfree(bot);
> +		return NULL;
> +	}
> +
> +	top->child[0] = node->child[0];
> +	rcu_assign_pointer(top->child[1], bot);
> +	top->child[2] = node->child[2];
> +	top->len = next;
> +	top->leaf = !!value;
> +	memcpy(top->key, node->key, next);
> +	if (value)
> +		memcpy(top->key + top->len, value, map->value_size);
> +
> +	return top;
> +}
> +
> +static struct bpf_tst_node *
> +new_leaf_node(struct bpf_map *map, struct bpf_tst_node *node, bool replace,
> +	      const void *c, void *value)
> +{
> +	struct bpf_tst_node *leaf;
> +	size_t size;
> +	unsigned int str_len;
> +
> +	/* Newly-created node or replace the original node */
> +	if (!replace)
> +		str_len = strlen(c);
> +	else
> +		str_len = node->len;
> +	size = sizeof(*leaf) + str_len + map->value_size;
> +	leaf = bpf_map_kmalloc_node(map, size, GFP_ATOMIC | __GFP_NOWARN,
> +				    map->numa_node);
> +	if (!leaf)
> +		return NULL;
> +
> +	if (!replace) {
> +		leaf->child[0] = leaf->child[1] = leaf->child[2] = NULL;
> +		leaf->len = str_len;
> +		memcpy(leaf->key, c, str_len);
> +	} else {
> +		memcpy(leaf, node, sizeof(*node) + str_len);
> +	}
> +	leaf->leaf = true;
> +	memcpy(leaf->key + str_len, value, map->value_size);
> +
> +	return leaf;
> +}
> +
> +/* Called from syscall or from eBPF program */
> +static int tst_update_elem(struct bpf_map *map, void *key, void *value, u64 flags)
> +{
> +	struct bpf_tst *tst = container_of(map, struct bpf_tst, map);
> +	struct bpf_tst_node __rcu **slot, **new_slot = NULL;
> +	struct bpf_tst_node *node, *new_node, *new_intn_node = NULL;
> +	unsigned long irq_flags;
> +	const unsigned char *c = key;
> +	bool replace;
> +	int err = 0;
> +
> +	if (!c[0] || c[map->key_size - 1])
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&tst->lock, irq_flags);

The global lock is one of the reasons LPM map is seldomly used.
As Andrii suggested can you tweak the algorithm to do a subtree lock?
Maybe the lock doesn't need to be taken until "split" action 
identified the spot. Then lock the parent and recheck the spot.
In other words would it be possible to move the lock into if (cmp && next) below?

> +	if (tst->nr_entries == map->max_entries) {
> +		err = -ENOSPC;
> +		goto out;
> +	}
> +
> +	slot = &tst->root;
> +	while ((node = rcu_dereference_protected(*slot, lockdep_is_held(&tst->lock)))) {
> +		int cmp;
> +		int next;
> +
> +		cmp = match_prefix(node->key, node->len, c, &next);
> +		c += next;
> +
> +		/* Split internal node */
> +		if (cmp && next) {
> +			/* The split top node is a leaf node */
> +			bool top_leaf = !*c;
> +
> +			new_node = split_tst_node(map, node, next,
> +						  top_leaf ? value : NULL);
> +			if (!new_node) {
> +				err = -ENOMEM;
> +				goto out;
> +			}
> +			if (top_leaf)
> +				goto done;
> +
> +			new_intn_node = new_node;
> +			new_slot = &new_node->child[1]->child[cmp + 1];
> +			break;
> +		}
> +
> +		/* Fully match */
> +		if (!cmp && !*c)
> +			break;
> +		slot = &node->child[cmp + 1];
> +	}
> +
> +	/* Replace the original node ? */
> +	replace = node && !new_intn_node;
> +	new_node = new_leaf_node(map, node, replace, c, value);
> +	if (!new_node) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	/* Don't increase if replace a leaf node */
> +	if (!replace || !node->leaf)
> +		tst->nr_entries++;
> +
> +	/* Graft the leaf node first for splitting */
> +	if (new_intn_node) {
> +		rcu_assign_pointer(*new_slot, new_node);
> +		new_node = new_intn_node;
> +	}
> +done:
> +	rcu_assign_pointer(*slot, new_node);
> +	spin_unlock_irqrestore(&tst->lock, irq_flags);
> +	kfree_rcu(node, rcu);
> +
> +	return 0;
> +out:
> +	if (new_intn_node) {
> +		kfree(new_intn_node->child[1]);
> +		kfree(new_intn_node);
> +	}
> +	spin_unlock_irqrestore(&tst->lock, irq_flags);
> +
> +	return err;
> +}
> +
> +static int tst_delete_elem(struct bpf_map *map, void *key)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static int tst_get_next_key(struct bpf_map *map, void *key, void *next_key)
> +{
> +	return -EOPNOTSUPP;
> +}

For the patches to land delete and get_next_key should be implemented.
We cannot leave them for later.

Could you do a bit more benchmarking to highlight the benefits of this data structure?
For example:
. store kallsyms in this map and compare memory usage vs existing kallsyms
. take vmlinux BTF and store all of it strings and compare the memory usage

I suspect in both cases raw strings in BTF and kallsyms consume less
space, but would be good to compare.
One of the reasons is that we need a fast string search in both cases.
Currently it's done via for_each linear loop which is inefficient.

Thanks for working on this.
Overall looks very promising.
