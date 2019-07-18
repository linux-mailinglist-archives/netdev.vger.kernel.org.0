Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19BD36C7FF
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 05:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389929AbfGRDfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 23:35:42 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44882 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbfGRDfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 23:35:41 -0400
Received: by mail-qt1-f193.google.com with SMTP id 44so25627233qtg.11;
        Wed, 17 Jul 2019 20:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rrajhYYyu5tY6xsgvIqYkwCQG451W2MbmJcgFQS84Ko=;
        b=N6wqSCMn/IjV6UXq25EQWmQ82UMGROsmsWh4Zyy1fTI+yDRFJ1W2U2nvWSRgUIip72
         UkoKz+0vBNyb5gO8pes2qNtBA+FjwyOWAT5gOibOYrERXf7NOHXeSNyRmtSbrReDcnVA
         A1/xq49RdjPlpzEBssjUumFcz8MeyJqQiQoBJ2tx1i0oppE/49p+/V2fKneuGVOE2Oxo
         gv+PJ4Jw1GJSNvQSUAqoanJRRvo0gptME+ju1N87aAkmb9Wza61PBU+8N4fx/9hkbDzy
         R1p3g4U1SJVdTrwpHI+tSQ7uMAXoDgJE+OI0CsX4yf1CGiKb0DHoLeQhermUwphG+LXK
         UPAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rrajhYYyu5tY6xsgvIqYkwCQG451W2MbmJcgFQS84Ko=;
        b=bALC5jOjkIjCfHAY+Zj+wmvmnnSd6KbhuOrWo0GaVHnlCT2iiTfNNMzb8LI/2HVcHl
         jGqc1hQZnB6oQwbZ3D771Dedy+vT5TtZ+LAZh6vqfY0x5/9qNCQ/PouVfWDKIbTdRsYi
         wALpgpO4M3JvWfqDxT2EBLSbyxcZh+Oghi97dng1j0wGR06PQteuUUzoBYOzbccqkRhN
         M1Ph4EcF1KlL0h8hEzCvaKB4c+CZi3AVLmdX3+HfkfStC40jF2KilIIGSWsM1uG5DVyr
         JVFpVTNWcy0bBK2r0wHBJze5EN8ddyK6efpATqj9wuMUnOFYx8lymeauwTxT/Epbfthj
         nMVQ==
X-Gm-Message-State: APjAAAXP0LBv75jYvDCB39MFoMaMrFSu9iKAgVky041/tZ0g6URcfIsc
        OLyoGn5cQ7shRM4gkJwMAjVaJocqybVKpRfO1ZQ=
X-Google-Smtp-Source: APXvYqwEqVsje7rJu0rKBKNz4Qk/25ijoZNsVvUUxVJozxdsc1KSHrN3PhE5Flrzv/W0/4vOvZOZI7bdZrEnV0mAyno=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr29754378qta.171.1563420939445;
 Wed, 17 Jul 2019 20:35:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190524185908.3562231-1-andriin@fb.com> <20190524185908.3562231-6-andriin@fb.com>
 <20190718002436.GA18962@kernel.org>
In-Reply-To: <20190718002436.GA18962@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 17 Jul 2019 20:35:28 -0700
Message-ID: <CAEf4BzZRzMNbKqz+ZLpGZWo1qZcZ1e+GsWO=sk2t+7CwSazkmw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 05/12] libbpf: add resizable non-thread safe
 internal hashmap
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        linux-perf-users@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 5:24 PM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Fri, May 24, 2019 at 11:59:00AM -0700, Andrii Nakryiko escreveu:
> > There is a need for fast point lookups inside libbpf for multiple use
> > cases (e.g., name resolution for BTF-to-C conversion, by-name lookups in
> > BTF for upcoming BPF CO-RE relocation support, etc). This patch
> > implements simple resizable non-thread safe hashmap using single linked
> > list chains.
>
> This is breaking the tools/perf build in some systems where __WORDSIZE use in
> tools/lib/bpf/hashmap.h is not finding the definition of __WORDSIZE,
> which I think requires using:
>
> #include <limits.h>
>
> Or perhaps
>
> #include <stdint.h>
>
> Non-exhaustive search on a fedora:30 system:
>
> [acme@quaco perf]$ grep "define.*__WORDSIZE" /usr/include/*/*.h
> /usr/include/bits/elfclass.h:#define __ELF_NATIVE_CLASS __WORDSIZE
> /usr/include/bits/siginfo-arch.h:#if defined __x86_64__ && __WORDSIZE == 32
> /usr/include/bits/timesize.h:# define __TIMESIZE        __WORDSIZE
> /usr/include/bits/wordsize.h:# define __WORDSIZE        64
> /usr/include/bits/wordsize.h:# define __WORDSIZE        32
> /usr/include/bits/wordsize.h:#define __WORDSIZE32_SIZE_ULONG            0
> /usr/include/bits/wordsize.h:#define __WORDSIZE32_PTRDIFF_LONG  0
> /usr/include/bits/wordsize.h:# define __WORDSIZE_TIME64_COMPAT32        1
> /usr/include/bits/wordsize.h:# define __WORDSIZE_TIME64_COMPAT32        0
> [acme@quaco perf]$ grep bits\/wordsize.h /usr/include/*.h
> /usr/include/bfd.h:#include <bits/wordsize.h>
> /usr/include/limits.h:#include <bits/wordsize.h>
> /usr/include/pthread.h:#include <bits/wordsize.h>
> /usr/include/stdint.h:#include <bits/wordsize.h>
> /usr/include/tiffconf.h:#include <bits/wordsize.h>
> [acme@quaco perf]$
>
> On fedora:30 it works, probably because some header included from there
> ends up adding the file that has that def, but these fail, for instance:
>
> [perfbuilder@quaco linux-perf-tools-build]$ export PERF_TARBALL=http://192.168.124.1/perf/perf-5.2.0.tar.xz
> [perfbuilder@quaco linux-perf-tools-build]$ time dm
>    1    13.57 alpine:3.4                    : FAIL gcc (Alpine 5.3.0) 5.3.0, clang version 3.8.0 (tags/RELEASE_380/final)
>    2    13.78 alpine:3.5                    : FAIL gcc (Alpine 6.2.1) 6.2.1 20160822, clang version 3.8.1 (tags/RELEASE_381/final)
>    3    12.42 alpine:3.6                    : FAIL gcc (Alpine 6.3.0) 6.3.0, clang version 4.0.0 (tags/RELEASE_400/final)
>    4    15.01 alpine:3.7                    : FAIL gcc (Alpine 6.4.0) 6.4.0, Alpine clang version 5.0.0 (tags/RELEASE_500/final) (based on LLVM 5.0.0)
>    5    13.80 alpine:3.8                    : FAIL gcc (Alpine 6.4.0) 6.4.0, Alpine clang version 5.0.1 (tags/RELEASE_501/final) (based on LLVM 5.0.1)
>    6    15.37 alpine:3.9                    : FAIL gcc (Alpine 8.3.0) 8.3.0, Alpine clang version 5.0.1 (tags/RELEASE_502/final) (based on LLVM 5.0.1)
>    7    15.10 alpine:3.10                   : FAIL gcc (Alpine 8.3.0) 8.3.0, Alpine clang version 8.0.0 (tags/RELEASE_800/final) (based on LLVM 8.0.0)
>    8    15.26 alpine:edge                   : FAIL gcc (Alpine 8.3.0) 8.3.0, Alpine clang version 7.0.1 (tags/RELEASE_701/final) (based on LLVM 7.0.1)
>    9: amazonlinux:1^C
>
> I'm trying to see if adding #include <limits.h> fixes the problems in
> all the distros in my container based build test suite.
>
> Lets see with at least alpine:3.4:
>
> Nope, didn't work, will try revisiting this tomorrow...
>
> I'll let it build anyway to see if this fails in other systems/libcs,
> BTW, Alpine uses musl libc.

So it seems like __WORDSIZE is declared in bits/wordsize.h for glibc
and in bits/reg.h for musl, so something like the following should fix
this issue, but I can't easily verify. Can you please see if these
changes fix the issue on your side?

#ifdef __GLIBC__
#include <bits/wordsize.h>
#else
#include <bits/reg.h>
#endif

>
> - Arnaldo
>
> > Four different insert strategies are supported:
> >  - HASHMAP_ADD - only add key/value if key doesn't exist yet;
> >  - HASHMAP_SET - add key/value pair if key doesn't exist yet; otherwise,
> >    update value;
> >  - HASHMAP_UPDATE - update value, if key already exists; otherwise, do
> >    nothing and return -ENOENT;
> >  - HASHMAP_APPEND - always add key/value pair, even if key already exists.
> >    This turns hashmap into a multimap by allowing multiple values to be
> >    associated with the same key. Most useful read API for such hashmap is
> >    hashmap__for_each_key_entry() iteration. If hashmap__find() is still
> >    used, it will return last inserted key/value entry (first in a bucket
> >    chain).
> >
> > For HASHMAP_SET and HASHMAP_UPDATE, old key/value pair is returned, so
> > that calling code can handle proper memory management, if necessary.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/Build     |   2 +-
> >  tools/lib/bpf/hashmap.c | 229 ++++++++++++++++++++++++++++++++++++++++
> >  tools/lib/bpf/hashmap.h | 173 ++++++++++++++++++++++++++++++
> >  3 files changed, 403 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/lib/bpf/hashmap.c
> >  create mode 100644 tools/lib/bpf/hashmap.h
> >
> > diff --git a/tools/lib/bpf/Build b/tools/lib/bpf/Build
> > index ee9d5362f35b..dcf0d36598e0 100644
> > --- a/tools/lib/bpf/Build
> > +++ b/tools/lib/bpf/Build
> > @@ -1 +1 @@
> > -libbpf-y := libbpf.o bpf.o nlattr.o btf.o libbpf_errno.o str_error.o netlink.o bpf_prog_linfo.o libbpf_probes.o xsk.o
> > +libbpf-y := libbpf.o bpf.o nlattr.o btf.o libbpf_errno.o str_error.o netlink.o bpf_prog_linfo.o libbpf_probes.o xsk.o hashmap.o
> > diff --git a/tools/lib/bpf/hashmap.c b/tools/lib/bpf/hashmap.c
> > new file mode 100644
> > index 000000000000..6122272943e6
> > --- /dev/null
> > +++ b/tools/lib/bpf/hashmap.c
> > @@ -0,0 +1,229 @@
> > +// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> > +
> > +/*
> > + * Generic non-thread safe hash map implementation.
> > + *
> > + * Copyright (c) 2019 Facebook
> > + */
> > +#include <stdint.h>
> > +#include <stdlib.h>
> > +#include <stdio.h>
> > +#include <errno.h>
> > +#include <linux/err.h>
> > +#include "hashmap.h"
> > +
> > +/* start with 4 buckets */
> > +#define HASHMAP_MIN_CAP_BITS 2
> > +
> > +static void hashmap_add_entry(struct hashmap_entry **pprev,
> > +                           struct hashmap_entry *entry)
> > +{
> > +     entry->next = *pprev;
> > +     *pprev = entry;
> > +}
> > +
> > +static void hashmap_del_entry(struct hashmap_entry **pprev,
> > +                           struct hashmap_entry *entry)
> > +{
> > +     *pprev = entry->next;
> > +     entry->next = NULL;
> > +}
> > +
> > +void hashmap__init(struct hashmap *map, hashmap_hash_fn hash_fn,
> > +                hashmap_equal_fn equal_fn, void *ctx)
> > +{
> > +     map->hash_fn = hash_fn;
> > +     map->equal_fn = equal_fn;
> > +     map->ctx = ctx;
> > +
> > +     map->buckets = NULL;
> > +     map->cap = 0;
> > +     map->cap_bits = 0;
> > +     map->sz = 0;
> > +}
> > +
> > +struct hashmap *hashmap__new(hashmap_hash_fn hash_fn,
> > +                          hashmap_equal_fn equal_fn,
> > +                          void *ctx)
> > +{
> > +     struct hashmap *map = malloc(sizeof(struct hashmap));
> > +
> > +     if (!map)
> > +             return ERR_PTR(-ENOMEM);
> > +     hashmap__init(map, hash_fn, equal_fn, ctx);
> > +     return map;
> > +}
> > +
> > +void hashmap__clear(struct hashmap *map)
> > +{
> > +     free(map->buckets);
> > +     map->cap = map->cap_bits = map->sz = 0;
> > +}
> > +
> > +void hashmap__free(struct hashmap *map)
> > +{
> > +     if (!map)
> > +             return;
> > +
> > +     hashmap__clear(map);
> > +     free(map);
> > +}
> > +
> > +size_t hashmap__size(const struct hashmap *map)
> > +{
> > +     return map->sz;
> > +}
> > +
> > +size_t hashmap__capacity(const struct hashmap *map)
> > +{
> > +     return map->cap;
> > +}
> > +
> > +static bool hashmap_needs_to_grow(struct hashmap *map)
> > +{
> > +     /* grow if empty or more than 75% filled */
> > +     return (map->cap == 0) || ((map->sz + 1) * 4 / 3 > map->cap);
> > +}
> > +
> > +static int hashmap_grow(struct hashmap *map)
> > +{
> > +     struct hashmap_entry **new_buckets;
> > +     struct hashmap_entry *cur, *tmp;
> > +     size_t new_cap_bits, new_cap;
> > +     size_t h;
> > +     int bkt;
> > +
> > +     new_cap_bits = map->cap_bits + 1;
> > +     if (new_cap_bits < HASHMAP_MIN_CAP_BITS)
> > +             new_cap_bits = HASHMAP_MIN_CAP_BITS;
> > +
> > +     new_cap = 1UL << new_cap_bits;
> > +     new_buckets = calloc(new_cap, sizeof(new_buckets[0]));
> > +     if (!new_buckets)
> > +             return -ENOMEM;
> > +
> > +     hashmap__for_each_entry_safe(map, cur, tmp, bkt) {
> > +             h = hash_bits(map->hash_fn(cur->key, map->ctx), new_cap_bits);
> > +             hashmap_add_entry(&new_buckets[h], cur);
> > +     }
> > +
> > +     map->cap = new_cap;
> > +     map->cap_bits = new_cap_bits;
> > +     free(map->buckets);
> > +     map->buckets = new_buckets;
> > +
> > +     return 0;
> > +}
> > +
> > +static bool hashmap_find_entry(const struct hashmap *map,
> > +                            const void *key, size_t hash,
> > +                            struct hashmap_entry ***pprev,
> > +                            struct hashmap_entry **entry)
> > +{
> > +     struct hashmap_entry *cur, **prev_ptr;
> > +
> > +     if (!map->buckets)
> > +             return false;
> > +
> > +     for (prev_ptr = &map->buckets[hash], cur = *prev_ptr;
> > +          cur;
> > +          prev_ptr = &cur->next, cur = cur->next) {
> > +             if (map->equal_fn(cur->key, key, map->ctx)) {
> > +                     if (pprev)
> > +                             *pprev = prev_ptr;
> > +                     *entry = cur;
> > +                     return true;
> > +             }
> > +     }
> > +
> > +     return false;
> > +}
> > +
> > +int hashmap__insert(struct hashmap *map, const void *key, void *value,
> > +                 enum hashmap_insert_strategy strategy,
> > +                 const void **old_key, void **old_value)
> > +{
> > +     struct hashmap_entry *entry;
> > +     size_t h;
> > +     int err;
> > +
> > +     if (old_key)
> > +             *old_key = NULL;
> > +     if (old_value)
> > +             *old_value = NULL;
> > +
> > +     h = hash_bits(map->hash_fn(key, map->ctx), map->cap_bits);
> > +     if (strategy != HASHMAP_APPEND &&
> > +         hashmap_find_entry(map, key, h, NULL, &entry)) {
> > +             if (old_key)
> > +                     *old_key = entry->key;
> > +             if (old_value)
> > +                     *old_value = entry->value;
> > +
> > +             if (strategy == HASHMAP_SET || strategy == HASHMAP_UPDATE) {
> > +                     entry->key = key;
> > +                     entry->value = value;
> > +                     return 0;
> > +             } else if (strategy == HASHMAP_ADD) {
> > +                     return -EEXIST;
> > +             }
> > +     }
> > +
> > +     if (strategy == HASHMAP_UPDATE)
> > +             return -ENOENT;
> > +
> > +     if (hashmap_needs_to_grow(map)) {
> > +             err = hashmap_grow(map);
> > +             if (err)
> > +                     return err;
> > +             h = hash_bits(map->hash_fn(key, map->ctx), map->cap_bits);
> > +     }
> > +
> > +     entry = malloc(sizeof(struct hashmap_entry));
> > +     if (!entry)
> > +             return -ENOMEM;
> > +
> > +     entry->key = key;
> > +     entry->value = value;
> > +     hashmap_add_entry(&map->buckets[h], entry);
> > +     map->sz++;
> > +
> > +     return 0;
> > +}
> > +
> > +bool hashmap__find(const struct hashmap *map, const void *key, void **value)
> > +{
> > +     struct hashmap_entry *entry;
> > +     size_t h;
> > +
> > +     h = hash_bits(map->hash_fn(key, map->ctx), map->cap_bits);
> > +     if (!hashmap_find_entry(map, key, h, NULL, &entry))
> > +             return false;
> > +
> > +     if (value)
> > +             *value = entry->value;
> > +     return true;
> > +}
> > +
> > +bool hashmap__delete(struct hashmap *map, const void *key,
> > +                  const void **old_key, void **old_value)
> > +{
> > +     struct hashmap_entry **pprev, *entry;
> > +     size_t h;
> > +
> > +     h = hash_bits(map->hash_fn(key, map->ctx), map->cap_bits);
> > +     if (!hashmap_find_entry(map, key, h, &pprev, &entry))
> > +             return false;
> > +
> > +     if (old_key)
> > +             *old_key = entry->key;
> > +     if (old_value)
> > +             *old_value = entry->value;
> > +
> > +     hashmap_del_entry(pprev, entry);
> > +     free(entry);
> > +     map->sz--;
> > +
> > +     return true;
> > +}
> > +
> > diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> > new file mode 100644
> > index 000000000000..03748a742146
> > --- /dev/null
> > +++ b/tools/lib/bpf/hashmap.h
> > @@ -0,0 +1,173 @@
> > +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
> > +
> > +/*
> > + * Generic non-thread safe hash map implementation.
> > + *
> > + * Copyright (c) 2019 Facebook
> > + */
> > +#ifndef __LIBBPF_HASHMAP_H
> > +#define __LIBBPF_HASHMAP_H
> > +
> > +#include <stdbool.h>
> > +#include <stddef.h>
> > +#include "libbpf_internal.h"
> > +
> > +static inline size_t hash_bits(size_t h, int bits)
> > +{
> > +     /* shuffle bits and return requested number of upper bits */
> > +     return (h * 11400714819323198485llu) >> (__WORDSIZE - bits);
> > +}
> > +
> > +typedef size_t (*hashmap_hash_fn)(const void *key, void *ctx);
> > +typedef bool (*hashmap_equal_fn)(const void *key1, const void *key2, void *ctx);
> > +
> > +struct hashmap_entry {
> > +     const void *key;
> > +     void *value;
> > +     struct hashmap_entry *next;
> > +};
> > +
> > +struct hashmap {
> > +     hashmap_hash_fn hash_fn;
> > +     hashmap_equal_fn equal_fn;
> > +     void *ctx;
> > +
> > +     struct hashmap_entry **buckets;
> > +     size_t cap;
> > +     size_t cap_bits;
> > +     size_t sz;
> > +};
> > +
> > +#define HASHMAP_INIT(hash_fn, equal_fn, ctx) {       \
> > +     .hash_fn = (hash_fn),                   \
> > +     .equal_fn = (equal_fn),                 \
> > +     .ctx = (ctx),                           \
> > +     .buckets = NULL,                        \
> > +     .cap = 0,                               \
> > +     .cap_bits = 0,                          \
> > +     .sz = 0,                                \
> > +}
> > +
> > +void hashmap__init(struct hashmap *map, hashmap_hash_fn hash_fn,
> > +                hashmap_equal_fn equal_fn, void *ctx);
> > +struct hashmap *hashmap__new(hashmap_hash_fn hash_fn,
> > +                          hashmap_equal_fn equal_fn,
> > +                          void *ctx);
> > +void hashmap__clear(struct hashmap *map);
> > +void hashmap__free(struct hashmap *map);
> > +
> > +size_t hashmap__size(const struct hashmap *map);
> > +size_t hashmap__capacity(const struct hashmap *map);
> > +
> > +/*
> > + * Hashmap insertion strategy:
> > + * - HASHMAP_ADD - only add key/value if key doesn't exist yet;
> > + * - HASHMAP_SET - add key/value pair if key doesn't exist yet; otherwise,
> > + *   update value;
> > + * - HASHMAP_UPDATE - update value, if key already exists; otherwise, do
> > + *   nothing and return -ENOENT;
> > + * - HASHMAP_APPEND - always add key/value pair, even if key already exists.
> > + *   This turns hashmap into a multimap by allowing multiple values to be
> > + *   associated with the same key. Most useful read API for such hashmap is
> > + *   hashmap__for_each_key_entry() iteration. If hashmap__find() is still
> > + *   used, it will return last inserted key/value entry (first in a bucket
> > + *   chain).
> > + */
> > +enum hashmap_insert_strategy {
> > +     HASHMAP_ADD,
> > +     HASHMAP_SET,
> > +     HASHMAP_UPDATE,
> > +     HASHMAP_APPEND,
> > +};
> > +
> > +/*
> > + * hashmap__insert() adds key/value entry w/ various semantics, depending on
> > + * provided strategy value. If a given key/value pair replaced already
> > + * existing key/value pair, both old key and old value will be returned
> > + * through old_key and old_value to allow calling code do proper memory
> > + * management.
> > + */
> > +int hashmap__insert(struct hashmap *map, const void *key, void *value,
> > +                 enum hashmap_insert_strategy strategy,
> > +                 const void **old_key, void **old_value);
> > +
> > +static inline int hashmap__add(struct hashmap *map,
> > +                            const void *key, void *value)
> > +{
> > +     return hashmap__insert(map, key, value, HASHMAP_ADD, NULL, NULL);
> > +}
> > +
> > +static inline int hashmap__set(struct hashmap *map,
> > +                            const void *key, void *value,
> > +                            const void **old_key, void **old_value)
> > +{
> > +     return hashmap__insert(map, key, value, HASHMAP_SET,
> > +                            old_key, old_value);
> > +}
> > +
> > +static inline int hashmap__update(struct hashmap *map,
> > +                               const void *key, void *value,
> > +                               const void **old_key, void **old_value)
> > +{
> > +     return hashmap__insert(map, key, value, HASHMAP_UPDATE,
> > +                            old_key, old_value);
> > +}
> > +
> > +static inline int hashmap__append(struct hashmap *map,
> > +                               const void *key, void *value)
> > +{
> > +     return hashmap__insert(map, key, value, HASHMAP_APPEND, NULL, NULL);
> > +}
> > +
> > +bool hashmap__delete(struct hashmap *map, const void *key,
> > +                  const void **old_key, void **old_value);
> > +
> > +bool hashmap__find(const struct hashmap *map, const void *key, void **value);
> > +
> > +/*
> > + * hashmap__for_each_entry - iterate over all entries in hashmap
> > + * @map: hashmap to iterate
> > + * @cur: struct hashmap_entry * used as a loop cursor
> > + * @bkt: integer used as a bucket loop cursor
> > + */
> > +#define hashmap__for_each_entry(map, cur, bkt)                                   \
> > +     for (bkt = 0; bkt < map->cap; bkt++)                                \
> > +             for (cur = map->buckets[bkt]; cur; cur = cur->next)
> > +
> > +/*
> > + * hashmap__for_each_entry_safe - iterate over all entries in hashmap, safe
> > + * against removals
> > + * @map: hashmap to iterate
> > + * @cur: struct hashmap_entry * used as a loop cursor
> > + * @tmp: struct hashmap_entry * used as a temporary next cursor storage
> > + * @bkt: integer used as a bucket loop cursor
> > + */
> > +#define hashmap__for_each_entry_safe(map, cur, tmp, bkt)                 \
> > +     for (bkt = 0; bkt < map->cap; bkt++)                                \
> > +             for (cur = map->buckets[bkt];                               \
> > +                  cur && ({tmp = cur->next; true; });                    \
> > +                  cur = tmp)
> > +
> > +/*
> > + * hashmap__for_each_key_entry - iterate over entries associated with given key
> > + * @map: hashmap to iterate
> > + * @cur: struct hashmap_entry * used as a loop cursor
> > + * @key: key to iterate entries for
> > + */
> > +#define hashmap__for_each_key_entry(map, cur, _key)                      \
> > +     for (cur = ({ size_t bkt = hash_bits(map->hash_fn((_key), map->ctx),\
> > +                                          map->cap_bits);                \
> > +                  map->buckets ? map->buckets[bkt] : NULL; });           \
> > +          cur;                                                           \
> > +          cur = cur->next)                                               \
> > +             if (map->equal_fn(cur->key, (_key), map->ctx))
> > +
> > +#define hashmap__for_each_key_entry_safe(map, cur, tmp, _key)                    \
> > +     for (cur = ({ size_t bkt = hash_bits(map->hash_fn((_key), map->ctx),\
> > +                                          map->cap_bits);                \
> > +                  cur = map->buckets ? map->buckets[bkt] : NULL; });     \
> > +          cur && ({ tmp = cur->next; true; });                           \
> > +          cur = tmp)                                                     \
> > +             if (map->equal_fn(cur->key, (_key), map->ctx))
> > +
> > +#endif /* __LIBBPF_HASHMAP_H */
> > --
> > 2.17.1
>
> --
>
> - Arnaldo
