Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 582C02721E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 00:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbfEVWPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 18:15:20 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40701 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbfEVWPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 18:15:20 -0400
Received: by mail-qk1-f194.google.com with SMTP id q197so2584180qke.7;
        Wed, 22 May 2019 15:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7G0970qJSpzszSvLhbR4ww8RyJ40f+NZcLWzQEV3WXI=;
        b=K6dCJbdfFv4GmwxowcKDL1/QKAHuqy1Rxek9V9ByE1j0xEvn/j0aaovvrIKYyhNEEK
         JeTLHoiqHnw7e0PYlpLP0kDkBZj57Rg+AZMl2O/AG8s04igu98MS/MDZ6/sKt3qAkM4C
         gRVIcpibgM3QyboVcUjevev5dBv9fnRNmhKGtCShxYy+1lP//s8iD6oFVTo4wnWXc5rc
         gJb2aZLPH3wXL73znD1EkzalvHyjpycx8IMLYge4/SMsIVeTkB3kO70A2YE1hqwHIIzH
         Mk/OdaadB6cZUxsYuhK207dXvgnTISu1lBNdv54ZBW/paW3yIt0uDuSPcPFQZPMxgqRu
         gl+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7G0970qJSpzszSvLhbR4ww8RyJ40f+NZcLWzQEV3WXI=;
        b=Fk89h5nsP8WVjQEt2idwNmvQ2516z3yyzc+buVvZgm4oPEBV1yst5GkAZuzdzAsbbp
         V7oJDY7tVySOUzUUHFPNsHezv2nnTVk3jy5SQNNNHc9GishdUQDfCknO9Jmm6adeDKj5
         zMS5ZCmQCzV/ZpwUMAkbSjgFFmYo9WzJgvvcs3orLitTP5I9D02qUZRclJsDZOXXgNR5
         9HHj61jTzbHheASYIqENNHTGKVFj5mwQO9oSoGPEyY9n9SDcM4wrb4jAq0Q9AxDuOJH6
         DB4MGeWUVWHfplyO7w325Z1hAdHgvkV55mSfqo8kbH9UshnRFY0egkuAF2JT3fnJmE9L
         8E8A==
X-Gm-Message-State: APjAAAXiq2FcGu6p/VQFIfpqpyffEb/fTXfUq9Y3s5NNlR2ormCQeazh
        uQyk1U4soeKadO/9RONzpgGOdAP2kR6d/5q2oWE=
X-Google-Smtp-Source: APXvYqwPxjUKm8fHTkSrnS7WTHscAm0npZebyBnpaB4en4kuS5V46ONLQZIuL8hum2d9Ryu2iTFSVGLxrXcR7bFRmV8=
X-Received: by 2002:a05:620a:1035:: with SMTP id a21mr3116438qkk.172.1558563319067;
 Wed, 22 May 2019 15:15:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190522195053.4017624-1-andriin@fb.com> <20190522195053.4017624-7-andriin@fb.com>
 <20190522203146.GP10244@mini-arch>
In-Reply-To: <20190522203146.GP10244@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 May 2019 15:15:07 -0700
Message-ID: <CAEf4Bzb-JH2PhNPmZ9s=9BNVUrsdL+6ZLZ5rm-xHOGnKnQJQvA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 06/12] selftests/bpf: add tests for libbpf's hashmap
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 1:31 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 05/22, Andrii Nakryiko wrote:
> > Test all APIs for internal hashmap implementation.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/testing/selftests/bpf/.gitignore     |   1 +
> >  tools/testing/selftests/bpf/Makefile       |   2 +-
> >  tools/testing/selftests/bpf/test_hashmap.c | 382 +++++++++++++++++++++
> >  3 files changed, 384 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/bpf/test_hashmap.c
> >
> > diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
> > index dd5d69529382..138b6c063916 100644
> > --- a/tools/testing/selftests/bpf/.gitignore
> > +++ b/tools/testing/selftests/bpf/.gitignore
> > @@ -35,3 +35,4 @@ test_sysctl
> >  alu32
> >  libbpf.pc
> >  libbpf.so.*
> > +test_hashmap
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 66f2dca1dee1..ddae06498a00 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -23,7 +23,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
> >       test_align test_verifier_log test_dev_cgroup test_tcpbpf_user \
> >       test_sock test_btf test_sockmap test_lirc_mode2_user get_cgroup_id_user \
> >       test_socket_cookie test_cgroup_storage test_select_reuseport test_section_names \
> > -     test_netcnt test_tcpnotify_user test_sock_fields test_sysctl
> > +     test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap
> >
> >  BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
> >  TEST_GEN_FILES = $(BPF_OBJ_FILES)
> > diff --git a/tools/testing/selftests/bpf/test_hashmap.c b/tools/testing/selftests/bpf/test_hashmap.c
> > new file mode 100644
> > index 000000000000..b64094c981e3
> > --- /dev/null
> [..]
> > +++ b/tools/testing/selftests/bpf/test_hashmap.c
> Any reason against putting it in bpf/prog_tests? No need for your own
> CHECK macro and no Makefile changes.

I didn't know they are special and I assumed they are mostly for
loading BPF programs and testing them. I'll check that set up and will
move there, if it makes sense.

>
> > @@ -0,0 +1,382 @@
> > +// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> > +
> > +/*
> > + * Tests for libbpf's hashmap.
> > + *
> > + * Copyright (c) 2019 Facebook
> > + */
> > +#include <stdio.h>
> > +#include <errno.h>
> > +#include <linux/err.h>
> > +#include "hashmap.h"
> > +
> > +#define CHECK(condition, format...) ({                                       \
> > +     int __ret = !!(condition);                                      \
> > +     if (__ret) {                                                    \
> > +             fprintf(stderr, "%s:%d:FAIL ", __func__, __LINE__);     \
> > +             fprintf(stderr, format);                                \
> > +     }                                                               \
> > +     __ret;                                                          \
> > +})
> > +
> > +size_t hash_fn(const void *k, void *ctx)
> > +{
> > +     return (long)k;
> > +}
> > +
> > +bool equal_fn(const void *a, const void *b, void *ctx)
> > +{
> > +     return (long)a == (long)b;
> > +}
> > +
> > +static inline size_t next_pow_2(size_t n)
> > +{
> > +     size_t r = 1;
> > +
> > +     while (r < n)
> > +             r <<= 1;
> > +     return r;
> > +}
> > +
> > +static inline size_t exp_cap(size_t sz)
> > +{
> > +     size_t r = next_pow_2(sz);
> > +
> > +     if (sz * 4 / 3 > r)
> > +             r <<= 1;
> > +     return r;
> > +}
> > +
> > +#define ELEM_CNT 62
> > +
> > +int test_hashmap_generic(void)
> > +{
> > +     struct hashmap_entry *entry, *tmp;
> > +     int err, bkt, found_cnt, i;
> > +     long long found_msk;
> > +     struct hashmap *map;
> > +
> > +     fprintf(stderr, "%s: ", __func__);
> > +
> > +     map = hashmap__new(hash_fn, equal_fn, NULL);
> > +     if (CHECK(IS_ERR(map), "failed to create map: %ld\n", PTR_ERR(map)))
> > +             return 1;
> > +
> > +     for (i = 0; i < ELEM_CNT; i++) {
> > +             const void *oldk, *k = (const void *)(long)i;
> > +             void *oldv, *v = (void *)(long)(1024 + i);
> > +
> > +             err = hashmap__update(map, k, v, &oldk, &oldv);
> > +             if (CHECK(err != -ENOENT, "unexpected result: %d\n", err))
> > +                     return 1;
> > +
> > +             if (i % 2) {
> > +                     err = hashmap__add(map, k, v);
> > +             } else {
> > +                     err = hashmap__set(map, k, v, &oldk, &oldv);
> > +                     if (CHECK(oldk != NULL || oldv != NULL,
> > +                               "unexpected k/v: %p=%p\n", oldk, oldv))
> > +                             return 1;
> > +             }
> > +
> > +             if (CHECK(err, "failed to add k/v %ld = %ld: %d\n",
> > +                            (long)k, (long)v, err))
> > +                     return 1;
> > +
> > +             if (CHECK(!hashmap__find(map, k, &oldv),
> > +                       "failed to find key %ld\n", (long)k))
> > +                     return 1;
> > +             if (CHECK(oldv != v, "found value is wrong: %ld\n", (long)oldv))
> > +                     return 1;
> > +     }
> > +
> > +     if (CHECK(hashmap__size(map) != ELEM_CNT,
> > +               "invalid map size: %zu\n", hashmap__size(map)))
> > +             return 1;
> > +     if (CHECK(hashmap__capacity(map) != exp_cap(hashmap__size(map)),
> > +               "unexpected map capacity: %zu\n", hashmap__capacity(map)))
> > +             return 1;
> > +
> > +     found_msk = 0;
> > +     hashmap__for_each_entry(map, entry, bkt) {
> > +             long k = (long)entry->key;
> > +             long v = (long)entry->value;
> > +
> > +             found_msk |= 1ULL << k;
> > +             if (CHECK(v - k != 1024, "invalid k/v pair: %ld = %ld\n", k, v))
> > +                     return 1;
> > +     }
> > +     if (CHECK(found_msk != (1ULL << ELEM_CNT) - 1,
> > +               "not all keys iterated: %llx\n", found_msk))
> > +             return 1;
> > +
> > +     for (i = 0; i < ELEM_CNT; i++) {
> > +             const void *oldk, *k = (const void *)(long)i;
> > +             void *oldv, *v = (void *)(long)(256 + i);
> > +
> > +             err = hashmap__add(map, k, v);
> > +             if (CHECK(err != -EEXIST, "unexpected add result: %d\n", err))
> > +                     return 1;
> > +
> > +             if (i % 2)
> > +                     err = hashmap__update(map, k, v, &oldk, &oldv);
> > +             else
> > +                     err = hashmap__set(map, k, v, &oldk, &oldv);
> > +
> > +             if (CHECK(err, "failed to update k/v %ld = %ld: %d\n",
> > +                            (long)k, (long)v, err))
> > +                     return 1;
> > +             if (CHECK(!hashmap__find(map, k, &oldv),
> > +                       "failed to find key %ld\n", (long)k))
> > +                     return 1;
> > +             if (CHECK(oldv != v, "found value is wrong: %ld\n", (long)oldv))
> > +                     return 1;
> > +     }
> > +
> > +     if (CHECK(hashmap__size(map) != ELEM_CNT,
> > +               "invalid updated map size: %zu\n", hashmap__size(map)))
> > +             return 1;
> > +     if (CHECK(hashmap__capacity(map) != exp_cap(hashmap__size(map)),
> > +               "unexpected map capacity: %zu\n", hashmap__capacity(map)))
> > +             return 1;
> > +
> > +     found_msk = 0;
> > +     hashmap__for_each_entry_safe(map, entry, tmp, bkt) {
> > +             long k = (long)entry->key;
> > +             long v = (long)entry->value;
> > +
> > +             found_msk |= 1ULL << k;
> > +             if (CHECK(v - k != 256,
> > +                       "invalid updated k/v pair: %ld = %ld\n", k, v))
> > +                     return 1;
> > +     }
> > +     if (CHECK(found_msk != (1ULL << ELEM_CNT) - 1,
> > +               "not all keys iterated after update: %llx\n", found_msk))
> > +             return 1;
> > +
> > +     found_cnt = 0;
> > +     hashmap__for_each_key_entry(map, entry, (void *)0) {
> > +             found_cnt++;
> > +     }
> > +     if (CHECK(!found_cnt, "didn't find any entries for key 0\n"))
> > +             return 1;
> > +
> > +     found_msk = 0;
> > +     found_cnt = 0;
> > +     hashmap__for_each_key_entry_safe(map, entry, tmp, (void *)0) {
> > +             const void *oldk, *k;
> > +             void *oldv, *v;
> > +
> > +             k = entry->key;
> > +             v = entry->value;
> > +
> > +             found_cnt++;
> > +             found_msk |= 1ULL << (long)k;
> > +
> > +             if (CHECK(!hashmap__delete(map, k, &oldk, &oldv),
> > +                       "failed to delete k/v %ld = %ld\n",
> > +                       (long)k, (long)v))
> > +                     return 1;
> > +             if (CHECK(oldk != k || oldv != v,
> > +                       "invalid deleted k/v: expected %ld = %ld, got %ld = %ld\n",
> > +                       (long)k, (long)v, (long)oldk, (long)oldv))
> > +                     return 1;
> > +             if (CHECK(hashmap__delete(map, k, &oldk, &oldv),
> > +                       "unexpectedly deleted k/v %ld = %ld\n",
> > +                       (long)oldk, (long)oldv))
> > +                     return 1;
> > +     }
> > +
> > +     if (CHECK(!found_cnt || !found_msk,
> > +               "didn't delete any key entries\n"))
> > +             return 1;
> > +     if (CHECK(hashmap__size(map) != ELEM_CNT - found_cnt,
> > +               "invalid updated map size (already deleted: %d): %zu\n",
> > +               found_cnt, hashmap__size(map)))
> > +             return 1;
> > +     if (CHECK(hashmap__capacity(map) != exp_cap(hashmap__size(map)),
> > +               "unexpected map capacity: %zu\n", hashmap__capacity(map)))
> > +             return 1;
> > +
> > +     hashmap__for_each_entry_safe(map, entry, tmp, bkt) {
> > +             const void *oldk, *k;
> > +             void *oldv, *v;
> > +
> > +             k = entry->key;
> > +             v = entry->value;
> > +
> > +             found_cnt++;
> > +             found_msk |= 1ULL << (long)k;
> > +
> > +             if (CHECK(!hashmap__delete(map, k, &oldk, &oldv),
> > +                       "failed to delete k/v %ld = %ld\n",
> > +                       (long)k, (long)v))
> > +                     return 1;
> > +             if (CHECK(oldk != k || oldv != v,
> > +                       "invalid old k/v: expect %ld = %ld, got %ld = %ld\n",
> > +                       (long)k, (long)v, (long)oldk, (long)oldv))
> > +                     return 1;
> > +             if (CHECK(hashmap__delete(map, k, &oldk, &oldv),
> > +                       "unexpectedly deleted k/v %ld = %ld\n",
> > +                       (long)k, (long)v))
> > +                     return 1;
> > +     }
> > +
> > +     if (CHECK(found_cnt != ELEM_CNT || found_msk != (1ULL << ELEM_CNT) - 1,
> > +               "not all keys were deleted: found_cnt:%d, found_msk:%llx\n",
> > +               found_cnt, found_msk))
> > +             return 1;
> > +     if (CHECK(hashmap__size(map) != 0,
> > +               "invalid updated map size (already deleted: %d): %zu\n",
> > +               found_cnt, hashmap__size(map)))
> > +             return 1;
> > +
> > +     found_cnt = 0;
> > +     hashmap__for_each_entry(map, entry, bkt) {
> > +             CHECK(false, "unexpected map entries left: %ld = %ld\n",
> > +                          (long)entry->key, (long)entry->value);
> > +             return 1;
> > +     }
> > +
> > +     hashmap__free(map);
> > +     hashmap__for_each_entry(map, entry, bkt) {
> > +             CHECK(false, "unexpected map entries left: %ld = %ld\n",
> > +                          (long)entry->key, (long)entry->value);
> > +             return 1;
> > +     }
> > +
> > +     fprintf(stderr, "OK\n");
> > +     return 0;
> > +}
> > +
> > +size_t collision_hash_fn(const void *k, void *ctx)
> > +{
> > +     return 0;
> > +}
> > +
> > +int test_hashmap_multimap(void)
> > +{
> > +     void *k1 = (void *)0, *k2 = (void *)1;
> > +     struct hashmap_entry *entry;
> > +     struct hashmap *map;
> > +     long found_msk;
> > +     int err, bkt;
> > +
> > +     fprintf(stderr, "%s: ", __func__);
> > +
> > +     /* force collisions */
> > +     map = hashmap__new(collision_hash_fn, equal_fn, NULL);
> > +     if (CHECK(IS_ERR(map), "failed to create map: %ld\n", PTR_ERR(map)))
> > +             return 1;
> > +
> > +
> > +     /* set up multimap:
> > +      * [0] -> 1, 2, 4;
> > +      * [1] -> 8, 16, 32;
> > +      */
> > +     err = hashmap__append(map, k1, (void *)1);
> > +     if (CHECK(err, "failed to add k/v: %d\n", err))
> > +             return 1;
> > +     err = hashmap__append(map, k1, (void *)2);
> > +     if (CHECK(err, "failed to add k/v: %d\n", err))
> > +             return 1;
> > +     err = hashmap__append(map, k1, (void *)4);
> > +     if (CHECK(err, "failed to add k/v: %d\n", err))
> > +             return 1;
> > +
> > +     err = hashmap__append(map, k2, (void *)8);
> > +     if (CHECK(err, "failed to add k/v: %d\n", err))
> > +             return 1;
> > +     err = hashmap__append(map, k2, (void *)16);
> > +     if (CHECK(err, "failed to add k/v: %d\n", err))
> > +             return 1;
> > +     err = hashmap__append(map, k2, (void *)32);
> > +     if (CHECK(err, "failed to add k/v: %d\n", err))
> > +             return 1;
> > +
> > +     if (CHECK(hashmap__size(map) != 6,
> > +               "invalid map size: %zu\n", hashmap__size(map)))
> > +             return 1;
> > +
> > +     /* verify global iteration still works and sees all values */
> > +     found_msk = 0;
> > +     hashmap__for_each_entry(map, entry, bkt) {
> > +             found_msk |= (long)entry->value;
> > +     }
> > +     if (CHECK(found_msk != (1 << 6) - 1,
> > +               "not all keys iterated: %lx\n", found_msk))
> > +             return 1;
> > +
> > +     /* iterate values for key 1 */
> > +     found_msk = 0;
> > +     hashmap__for_each_key_entry(map, entry, k1) {
> > +             found_msk |= (long)entry->value;
> > +     }
> > +     if (CHECK(found_msk != (1 | 2 | 4),
> > +               "invalid k1 values: %lx\n", found_msk))
> > +             return 1;
> > +
> > +     /* iterate values for key 2 */
> > +     found_msk = 0;
> > +     hashmap__for_each_key_entry(map, entry, k2) {
> > +             found_msk |= (long)entry->value;
> > +     }
> > +     if (CHECK(found_msk != (8 | 16 | 32),
> > +               "invalid k2 values: %lx\n", found_msk))
> > +             return 1;
> > +
> > +     fprintf(stderr, "OK\n");
> > +     return 0;
> > +}
> > +
> > +int test_hashmap_empty()
> > +{
> > +     struct hashmap_entry *entry;
> > +     int bkt;
> > +     struct hashmap *map;
> > +     void *k = (void *)0;
> > +
> > +     fprintf(stderr, "%s: ", __func__);
> > +
> > +     /* force collisions */
> > +     map = hashmap__new(hash_fn, equal_fn, NULL);
> > +     if (CHECK(IS_ERR(map), "failed to create map: %ld\n", PTR_ERR(map)))
> > +             return 1;
> > +
> > +     if (CHECK(hashmap__size(map) != 0,
> > +               "invalid map size: %zu\n", hashmap__size(map)))
> > +             return 1;
> > +     if (CHECK(hashmap__capacity(map) != 0,
> > +               "invalid map capacity: %zu\n", hashmap__capacity(map)))
> > +             return 1;
> > +     if (CHECK(hashmap__find(map, k, NULL), "unexpected find\n"))
> > +             return 1;
> > +     if (CHECK(hashmap__delete(map, k, NULL, NULL), "unexpected delete\n"))
> > +             return 1;
> > +
> > +     hashmap__for_each_entry(map, entry, bkt) {
> > +             CHECK(false, "unexpected iterated entry\n");
> > +             return 1;
> > +     }
> > +     hashmap__for_each_key_entry(map, entry, k) {
> > +             CHECK(false, "unexpected key entry\n");
> > +             return 1;
> > +     }
> > +
> > +     fprintf(stderr, "OK\n");
> > +     return 0;
> > +}
> > +
> > +int main(int argc, char **argv)
> > +{
> > +     bool failed = false;
> > +
> > +     if (test_hashmap_generic())
> > +             failed = true;
> > +     if (test_hashmap_multimap())
> > +             failed = true;
> > +     if (test_hashmap_empty())
> > +             failed = true;
> > +
> > +     return failed;
> > +}
> > --
> > 2.17.1
> >
