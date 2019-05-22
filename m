Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7A4A270D5
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbfEVUaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:30:35 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44981 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbfEVUae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:30:34 -0400
Received: by mail-pf1-f193.google.com with SMTP id g9so1914025pfo.11
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 13:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zv1stCxCDfqHAk0Q2zXbt8NF9Ip7EGQM442Z37eRGmg=;
        b=SEfQf9ixDmKZrA+6h6gLaAOcQe4DS9cXmKtkIOvnoVf5RQibnz+y1P3CQJ1aTzSlMr
         BElggiAVuBgPZLKsnOMQnAtaZ/+edtwA2k4SAuQMTxVi6+22cdxAuDwH/CinLId13jPp
         fa3jjEUCK1GbWyqAAMmzBRgay3djTWVOd8LaVH/a8Mt1PuqrNEOyLypVijcK09v+lym2
         gyA5VmEtpdm5Fy1Mr89kUjtKOiGkqpTfmfkSF5v9U+81rlVc2xgUvYwF684hy/hqGm8L
         UpnXuYacZrRHf/s35HIAePiW4UGo88E2jJFE6mtgi6sQcCOxxb+a+H3N3rNfeaeI/7aR
         o+1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zv1stCxCDfqHAk0Q2zXbt8NF9Ip7EGQM442Z37eRGmg=;
        b=WJnGow8SqhyGMz2XrnTaZwnX5wCDAqq9tFVKPNt9E4TCwAsXYZGSvA0t0FrFBWLHjz
         gvgjfgrHKT83x68PXpImAJUWk48mMctfePYZX/UECFcRChQVPgTrG4wj+jGGXkGTy+Vx
         S4yCWliT5mxByU8W3BJ2i9VRMQB0qTe+NpSeu5TO2AKYE9ffo9pLzlZuS5nMI9RroxQJ
         U/WxFOxkCsJYDS9/DbMVD0wVC0GBW+DY7WnSbNmHV5CoCysQc9mNHDZsQI7qyEjjKw+6
         itdEC6MJGwQM9Xx1Mq81t4cuS37oyECLm9LDvXA4zxWNq3JPyluTqc/pnaWdAZK5HBvn
         9NEw==
X-Gm-Message-State: APjAAAWmC7fheua8Q1qr68mCNqi3sFE56Uq+m7U/wsrbx2plO8UAuIBy
        8dD9JE0VtBqrF9IsVUpDEZEew3JbYGA=
X-Google-Smtp-Source: APXvYqwjmTYJBhsi883Zl52ZmBnEQ2Kyv6a6+eR7G/T7iocdmRVfkxCR3Qv8z8vX2HZO3AfESSUdBA==
X-Received: by 2002:a63:8a4a:: with SMTP id y71mr92097907pgd.270.1558557033615;
        Wed, 22 May 2019 13:30:33 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id j5sm33243976pfa.15.2019.05.22.13.30.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 13:30:33 -0700 (PDT)
Date:   Wed, 22 May 2019 13:30:32 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, ast@fb.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 05/12] libbpf: add resizable non-thread safe
 internal hashmap
Message-ID: <20190522203032.GO10244@mini-arch>
References: <20190522195053.4017624-1-andriin@fb.com>
 <20190522195053.4017624-6-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522195053.4017624-6-andriin@fb.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/22, Andrii Nakryiko wrote:
> There is a need for fast point lookups inside libbpf for multiple use
> cases (e.g., name resolution for BTF-to-C conversion, by-name lookups in
> BTF for upcoming BPF CO-RE relocation support, etc). This patch
> implements simple resizable non-thread safe hashmap using single linked
> list chains.
Didn't really look into the details, but any reason you're not using
linux/hashtable.h? It's exported in tools/include and I think perf
is using it. It's probably not resizable, but should be easy to
implement rebalancing on top of it.

> Four different insert strategies are supported:
>  - HASHMAP_ADD - only add key/value if key doesn't exist yet;
>  - HASHMAP_SET - add key/value pair if key doesn't exist yet; otherwise,
>    update value;
>  - HASHMAP_UPDATE - update value, if key already exists; otherwise, do
>    nothing and return -ENOENT;
>  - HASHMAP_APPEND - always add key/value pair, even if key already exists.
>    This turns hashmap into a multimap by allowing multiple values to be
>    associated with the same key. Most useful read API for such hashmap is
>    hashmap__for_each_key_entry() iteration. If hashmap__find() is still
>    used, it will return last inserted key/value entry (first in a bucket
>    chain).
> 
> For HASHMAP_SET and HASHMAP_UPDATE, old key/value pair is returned, so
> that calling code can handle proper memory management, if necessary.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/Build     |   2 +-
>  tools/lib/bpf/hashmap.c | 229 ++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/hashmap.h | 173 ++++++++++++++++++++++++++++++
>  3 files changed, 403 insertions(+), 1 deletion(-)
>  create mode 100644 tools/lib/bpf/hashmap.c
>  create mode 100644 tools/lib/bpf/hashmap.h
> 
> diff --git a/tools/lib/bpf/Build b/tools/lib/bpf/Build
> index ee9d5362f35b..dcf0d36598e0 100644
> --- a/tools/lib/bpf/Build
> +++ b/tools/lib/bpf/Build
> @@ -1 +1 @@
> -libbpf-y := libbpf.o bpf.o nlattr.o btf.o libbpf_errno.o str_error.o netlink.o bpf_prog_linfo.o libbpf_probes.o xsk.o
> +libbpf-y := libbpf.o bpf.o nlattr.o btf.o libbpf_errno.o str_error.o netlink.o bpf_prog_linfo.o libbpf_probes.o xsk.o hashmap.o
> diff --git a/tools/lib/bpf/hashmap.c b/tools/lib/bpf/hashmap.c
> new file mode 100644
> index 000000000000..809afae42c59
> --- /dev/null
> +++ b/tools/lib/bpf/hashmap.c
> @@ -0,0 +1,229 @@
> +// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> +
> +/*
> + * Generic non-thread safe hash map implementation.
> + *
> + * Copyright (c) 2019 Facebook
> + */
> +#include <stdint.h>
> +#include <stdlib.h>
> +#include <stdio.h>
> +#include <errno.h>
> +#include <linux/err.h>
> +#include "hashmap.h"
> +
> +/* start with 4 buckets */
> +#define HASHMAP_MIN_CAP_BITS 2
> +
> +static inline void hashmap_add_entry(struct hashmap_entry **pprev,
> +				     struct hashmap_entry *entry)
> +{
> +	entry->next = *pprev;
> +	*pprev = entry;
> +}
> +
> +static inline void hashmap_del_entry(struct hashmap_entry **pprev,
> +				     struct hashmap_entry *entry)
> +{
> +	*pprev = entry->next;
> +	entry->next = NULL;
> +}
> +
> +void hashmap__init(struct hashmap *map, hashmap_hash_fn hash_fn,
> +		   hashmap_equal_fn equal_fn, void *ctx)
> +{
> +	map->hash_fn = hash_fn;
> +	map->equal_fn = equal_fn;
> +	map->ctx = ctx;
> +
> +	map->buckets = NULL;
> +	map->cap = 0;
> +	map->cap_bits = 0;
> +	map->sz = 0;
> +}
> +
> +struct hashmap *hashmap__new(hashmap_hash_fn hash_fn,
> +			     hashmap_equal_fn equal_fn,
> +			     void *ctx)
> +{
> +	struct hashmap *map = malloc(sizeof(struct hashmap));
> +
> +	if (!map)
> +		return ERR_PTR(-ENOMEM);
> +	hashmap__init(map, hash_fn, equal_fn, ctx);
> +	return map;
> +}
> +
> +void hashmap__clear(struct hashmap *map)
> +{
> +	free(map->buckets);
> +	map->cap = map->cap_bits = map->sz = 0;
> +}
> +
> +void hashmap__free(struct hashmap *map)
> +{
> +	if (!map)
> +		return;
> +
> +	hashmap__clear(map);
> +	free(map);
> +}
> +
> +size_t hashmap__size(const struct hashmap *map)
> +{
> +	return map->sz;
> +}
> +
> +size_t hashmap__capacity(const struct hashmap *map)
> +{
> +	return map->cap;
> +}
> +
> +static inline bool hashmap_needs_to_grow(struct hashmap *map)
> +{
> +	/* grow if empty or more than 75% filled */
> +	return (map->cap == 0) || ((map->sz + 1) * 4 / 3 > map->cap);
> +}
> +
> +static inline int hashmap_grow(struct hashmap *map)
> +{
> +	struct hashmap_entry **new_buckets;
> +	struct hashmap_entry *cur, *tmp;
> +	size_t new_cap_bits, new_cap;
> +	size_t h;
> +	int bkt;
> +
> +	new_cap_bits = map->cap_bits + 1;
> +	if (new_cap_bits < HASHMAP_MIN_CAP_BITS)
> +		new_cap_bits = HASHMAP_MIN_CAP_BITS;
> +
> +	new_cap = 1UL << new_cap_bits;
> +	new_buckets = calloc(new_cap, sizeof(new_buckets[0]));
> +	if (!new_buckets)
> +		return -ENOMEM;
> +
> +	hashmap__for_each_entry_safe(map, cur, tmp, bkt) {
> +		h = hash_bits(map->hash_fn(cur->key, map->ctx), new_cap_bits);
> +		hashmap_add_entry(&new_buckets[h], cur);
> +	}
> +
> +	map->cap = new_cap;
> +	map->cap_bits = new_cap_bits;
> +	free(map->buckets);
> +	map->buckets = new_buckets;
> +
> +	return 0;
> +}
> +
> +static inline bool hashmap_find_entry(const struct hashmap *map,
> +				      const void *key, size_t hash,
> +				      struct hashmap_entry ***pprev,
> +				      struct hashmap_entry **entry)
> +{
> +	struct hashmap_entry *cur, **prev_ptr;
> +
> +	if (!map->buckets)
> +		return false;
> +
> +	for (prev_ptr = &map->buckets[hash], cur = *prev_ptr;
> +	     cur;
> +	     prev_ptr = &cur->next, cur = cur->next) {
> +		if (map->equal_fn(cur->key, key, map->ctx)) {
> +			if (pprev)
> +				*pprev = prev_ptr;
> +			*entry = cur;
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +int hashmap__insert(struct hashmap *map, const void *key, void *value,
> +		    enum hashmap_insert_strategy strategy,
> +		    const void **old_key, void **old_value)
> +{
> +	struct hashmap_entry *entry;
> +	size_t h;
> +	int err;
> +
> +	if (old_key)
> +		*old_key = NULL;
> +	if (old_value)
> +		*old_value = NULL;
> +
> +	h = hash_bits(map->hash_fn(key, map->ctx), map->cap_bits);
> +	if (strategy != HASHMAP_APPEND &&
> +	    hashmap_find_entry(map, key, h, NULL, &entry)) {
> +		if (old_key)
> +			*old_key = entry->key;
> +		if (old_value)
> +			*old_value = entry->value;
> +
> +		if (strategy == HASHMAP_SET || strategy == HASHMAP_UPDATE) {
> +			entry->key = key;
> +			entry->value = value;
> +			return 0;
> +		} else if (strategy == HASHMAP_ADD) {
> +			return -EEXIST;
> +		}
> +	}
> +
> +	if (strategy == HASHMAP_UPDATE)
> +		return -ENOENT;
> +
> +	if (hashmap_needs_to_grow(map)) {
> +		err = hashmap_grow(map);
> +		if (err)
> +			return err;
> +		h = hash_bits(map->hash_fn(key, map->ctx), map->cap_bits);
> +	}
> +
> +	entry = malloc(sizeof(struct hashmap_entry));
> +	if (!entry)
> +		return -ENOMEM;
> +
> +	entry->key = key;
> +	entry->value = value;
> +	hashmap_add_entry(&map->buckets[h], entry);
> +	map->sz++;
> +
> +	return 0;
> +}
> +
> +bool hashmap__find(const struct hashmap *map, const void *key, void **value)
> +{
> +	struct hashmap_entry *entry;
> +	size_t h;
> +
> +	h = hash_bits(map->hash_fn(key, map->ctx), map->cap_bits);
> +	if (!hashmap_find_entry(map, key, h, NULL, &entry))
> +		return false;
> +
> +	if (value)
> +		*value = entry->value;
> +	return true;
> +}
> +
> +bool hashmap__delete(struct hashmap *map, const void *key,
> +		     const void **old_key, void **old_value)
> +{
> +	struct hashmap_entry **pprev, *entry;
> +	size_t h;
> +
> +	h = hash_bits(map->hash_fn(key, map->ctx), map->cap_bits);
> +	if (!hashmap_find_entry(map, key, h, &pprev, &entry))
> +		return false;
> +
> +	if (old_key)
> +		*old_key = entry->key;
> +	if (old_value)
> +		*old_value = entry->value;
> +
> +	hashmap_del_entry(pprev, entry);
> +	free(entry);
> +	map->sz--;
> +
> +	return true;
> +}
> +
> diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> new file mode 100644
> index 000000000000..03748a742146
> --- /dev/null
> +++ b/tools/lib/bpf/hashmap.h
> @@ -0,0 +1,173 @@
> +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
> +
> +/*
> + * Generic non-thread safe hash map implementation.
> + *
> + * Copyright (c) 2019 Facebook
> + */
> +#ifndef __LIBBPF_HASHMAP_H
> +#define __LIBBPF_HASHMAP_H
> +
> +#include <stdbool.h>
> +#include <stddef.h>
> +#include "libbpf_internal.h"
> +
> +static inline size_t hash_bits(size_t h, int bits)
> +{
> +	/* shuffle bits and return requested number of upper bits */
> +	return (h * 11400714819323198485llu) >> (__WORDSIZE - bits);
> +}
> +
> +typedef size_t (*hashmap_hash_fn)(const void *key, void *ctx);
> +typedef bool (*hashmap_equal_fn)(const void *key1, const void *key2, void *ctx);
> +
> +struct hashmap_entry {
> +	const void *key;
> +	void *value;
> +	struct hashmap_entry *next;
> +};
> +
> +struct hashmap {
> +	hashmap_hash_fn hash_fn;
> +	hashmap_equal_fn equal_fn;
> +	void *ctx;
> +
> +	struct hashmap_entry **buckets;
> +	size_t cap;
> +	size_t cap_bits;
> +	size_t sz;
> +};
> +
> +#define HASHMAP_INIT(hash_fn, equal_fn, ctx) {	\
> +	.hash_fn = (hash_fn),			\
> +	.equal_fn = (equal_fn),			\
> +	.ctx = (ctx),				\
> +	.buckets = NULL,			\
> +	.cap = 0,				\
> +	.cap_bits = 0,				\
> +	.sz = 0,				\
> +}
> +
> +void hashmap__init(struct hashmap *map, hashmap_hash_fn hash_fn,
> +		   hashmap_equal_fn equal_fn, void *ctx);
> +struct hashmap *hashmap__new(hashmap_hash_fn hash_fn,
> +			     hashmap_equal_fn equal_fn,
> +			     void *ctx);
> +void hashmap__clear(struct hashmap *map);
> +void hashmap__free(struct hashmap *map);
> +
> +size_t hashmap__size(const struct hashmap *map);
> +size_t hashmap__capacity(const struct hashmap *map);
> +
> +/*
> + * Hashmap insertion strategy:
> + * - HASHMAP_ADD - only add key/value if key doesn't exist yet;
> + * - HASHMAP_SET - add key/value pair if key doesn't exist yet; otherwise,
> + *   update value;
> + * - HASHMAP_UPDATE - update value, if key already exists; otherwise, do
> + *   nothing and return -ENOENT;
> + * - HASHMAP_APPEND - always add key/value pair, even if key already exists.
> + *   This turns hashmap into a multimap by allowing multiple values to be
> + *   associated with the same key. Most useful read API for such hashmap is
> + *   hashmap__for_each_key_entry() iteration. If hashmap__find() is still
> + *   used, it will return last inserted key/value entry (first in a bucket
> + *   chain).
> + */
> +enum hashmap_insert_strategy {
> +	HASHMAP_ADD,
> +	HASHMAP_SET,
> +	HASHMAP_UPDATE,
> +	HASHMAP_APPEND,
> +};
> +
> +/*
> + * hashmap__insert() adds key/value entry w/ various semantics, depending on
> + * provided strategy value. If a given key/value pair replaced already
> + * existing key/value pair, both old key and old value will be returned
> + * through old_key and old_value to allow calling code do proper memory
> + * management.
> + */
> +int hashmap__insert(struct hashmap *map, const void *key, void *value,
> +		    enum hashmap_insert_strategy strategy,
> +		    const void **old_key, void **old_value);
> +
> +static inline int hashmap__add(struct hashmap *map,
> +			       const void *key, void *value)
> +{
> +	return hashmap__insert(map, key, value, HASHMAP_ADD, NULL, NULL);
> +}
> +
> +static inline int hashmap__set(struct hashmap *map,
> +			       const void *key, void *value,
> +			       const void **old_key, void **old_value)
> +{
> +	return hashmap__insert(map, key, value, HASHMAP_SET,
> +			       old_key, old_value);
> +}
> +
> +static inline int hashmap__update(struct hashmap *map,
> +				  const void *key, void *value,
> +				  const void **old_key, void **old_value)
> +{
> +	return hashmap__insert(map, key, value, HASHMAP_UPDATE,
> +			       old_key, old_value);
> +}
> +
> +static inline int hashmap__append(struct hashmap *map,
> +				  const void *key, void *value)
> +{
> +	return hashmap__insert(map, key, value, HASHMAP_APPEND, NULL, NULL);
> +}
> +
> +bool hashmap__delete(struct hashmap *map, const void *key,
> +		     const void **old_key, void **old_value);
> +
> +bool hashmap__find(const struct hashmap *map, const void *key, void **value);
> +
> +/*
> + * hashmap__for_each_entry - iterate over all entries in hashmap
> + * @map: hashmap to iterate
> + * @cur: struct hashmap_entry * used as a loop cursor
> + * @bkt: integer used as a bucket loop cursor
> + */
> +#define hashmap__for_each_entry(map, cur, bkt)				    \
> +	for (bkt = 0; bkt < map->cap; bkt++)				    \
> +		for (cur = map->buckets[bkt]; cur; cur = cur->next)
> +
> +/*
> + * hashmap__for_each_entry_safe - iterate over all entries in hashmap, safe
> + * against removals
> + * @map: hashmap to iterate
> + * @cur: struct hashmap_entry * used as a loop cursor
> + * @tmp: struct hashmap_entry * used as a temporary next cursor storage
> + * @bkt: integer used as a bucket loop cursor
> + */
> +#define hashmap__for_each_entry_safe(map, cur, tmp, bkt)		    \
> +	for (bkt = 0; bkt < map->cap; bkt++)				    \
> +		for (cur = map->buckets[bkt];				    \
> +		     cur && ({tmp = cur->next; true; });		    \
> +		     cur = tmp)
> +
> +/*
> + * hashmap__for_each_key_entry - iterate over entries associated with given key
> + * @map: hashmap to iterate
> + * @cur: struct hashmap_entry * used as a loop cursor
> + * @key: key to iterate entries for
> + */
> +#define hashmap__for_each_key_entry(map, cur, _key)			    \
> +	for (cur = ({ size_t bkt = hash_bits(map->hash_fn((_key), map->ctx),\
> +					     map->cap_bits);		    \
> +		     map->buckets ? map->buckets[bkt] : NULL; });	    \
> +	     cur;							    \
> +	     cur = cur->next)						    \
> +		if (map->equal_fn(cur->key, (_key), map->ctx))
> +
> +#define hashmap__for_each_key_entry_safe(map, cur, tmp, _key)		    \
> +	for (cur = ({ size_t bkt = hash_bits(map->hash_fn((_key), map->ctx),\
> +					     map->cap_bits);		    \
> +		     cur = map->buckets ? map->buckets[bkt] : NULL; });	    \
> +	     cur && ({ tmp = cur->next; true; });			    \
> +	     cur = tmp)							    \
> +		if (map->equal_fn(cur->key, (_key), map->ctx))
> +
> +#endif /* __LIBBPF_HASHMAP_H */
> -- 
> 2.17.1
> 
