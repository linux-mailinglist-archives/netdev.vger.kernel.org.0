Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3A50105BC0
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 22:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfKUVQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 16:16:42 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35645 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfKUVQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 16:16:27 -0500
Received: by mail-qt1-f196.google.com with SMTP id n4so5372902qte.2
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 13:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HjVA+vfOa4cuhOG7ZZQ5ZOYhaog/Hi6+sxpMWojKdbQ=;
        b=dW/31UQR9TpIGK0h/XcisPIhwMkzpKxBQKFvP9I/80AGreRgtSo21q/f23Qm4fF29i
         Snb0rG7W/Yw6tti1jiLmA8UP7gbcoZAogGZqJXvsU9PtwMiYrNyYVzRjLSka1nf4IqdO
         ZpDyuLYtxk+M4IeJAnrFALGGYHFTUsmViuXfPRTXyE6kBtj74q/l7HyZxFznr4uslg5K
         TXuR05iyDt4V5T+OSn6U6Hi0f172P6hoSY/GiKJcN3LYcZ1c+eQWigm5M8ogznXqInn5
         ROI/zSaIQVEsvJEJqiXA+vSHzJeqBeiy9xdCRKP6epYQuoqLzRZFLoTptiNcyppn+C0v
         n73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HjVA+vfOa4cuhOG7ZZQ5ZOYhaog/Hi6+sxpMWojKdbQ=;
        b=uNMKDMXOvuYj81Vspkz+agKbMn7ql+TDIbybBwvFRIx+eEdwukuu5bEaR/RM4dfqmt
         TCqVPBVlsLNMb77TilMU0VvLJ/tC0Y/JGqIa7kgbAUClXkKGc6zo4tGrayPkQm2bsxUO
         NDpAIdeG5JPy9NC2wK7Yt+6LfH5i6yJqdAJu9kHK1US69g3YkrgF8EPW+RapxTEuoBHG
         6An4LsYa0K//cmeEDrIpsw6/JbJONtlQd/olwB+kBBQaXLCIzF34kUmphNDReAaKM0CL
         C4qdEwZg62CeO22moEOw7Q2VCimQn7MKJuvwGF434KmRR8UskkSBRyXS1sgKj1v+Zy+S
         x8DA==
X-Gm-Message-State: APjAAAUsZo//SjENUT2R4NVyyz3jShubFwBj/O4X7TzNg0irtdRRGeK7
        WfOozPvwYKG57qf7WB7JDEpuOOWH+7ZiMJ6j/8flMw==
X-Google-Smtp-Source: APXvYqxq7xEzAax5FVtLsPdRun5uqgKjwBTSdow7Rdb+nnIKX2At/wV1oBd6VwfO5SfYKpELtEaDmhqbzJSm2Jr8dkE=
X-Received: by 2002:aed:31e7:: with SMTP id 94mr4875902qth.71.1574370983986;
 Thu, 21 Nov 2019 13:16:23 -0800 (PST)
MIME-Version: 1.0
References: <20191119193036.92831-1-brianvv@google.com> <20191119193036.92831-9-brianvv@google.com>
 <9f80a432-9825-9a39-cc90-d1358e0fc40f@fb.com>
In-Reply-To: <9f80a432-9825-9a39-cc90-d1358e0fc40f@fb.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Thu, 21 Nov 2019 13:16:12 -0800
Message-ID: <CAMzD94Sc5oWxKVoCrXQyM1Zy1FEtxod6x+0UEVkUcE8p8ZX14g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 8/9] selftests/bpf: add batch ops testing for
 hmap and hmap_percpu
To:     Yonghong Song <yhs@fb.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 10:36 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 11/19/19 11:30 AM, Brian Vazquez wrote:
> > From: Yonghong Song <yhs@fb.com>
> >
> > Tested bpf_map_lookup_and_delete_batch() and bpf_map_update_batch()
> > functionality.
> >    $ ./test_maps
> >      ...
> >        test_hmap_lookup_and_delete_batch:PASS
> >        test_pcpu_hmap_lookup_and_delete_batch:PASS
> >      ...
>
> Maybe you can add another tests for lookup_batch() and delete_batch()
> so all new APIs get tested?

I did test lookup_batch() and the code is there, I will add
delete_batch() testing and change the name of the tests to better
reflect what is being tested.

>
> >
> > Signed-off-by: Yonghong Song <yhs@fb.com>
> > Signed-off-by: Brian Vazquez <brianvv@google.com>
> > ---
> >   .../map_lookup_and_delete_batch_htab.c        | 257 ++++++++++++++++++
> >   1 file changed, 257 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_htab.c
> >
> > diff --git a/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_htab.c b/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_htab.c
> > new file mode 100644
> > index 0000000000000..93e024cb85c60
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_htab.c
> > @@ -0,0 +1,257 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2019 Facebook  */
> > +#include <stdio.h>
> > +#include <errno.h>
> > +#include <string.h>
> > +
> > +#include <bpf/bpf.h>
> > +#include <bpf/libbpf.h>
> > +
> > +#include <bpf_util.h>
> > +#include <test_maps.h>
> > +
> > +static void map_batch_update(int map_fd, __u32 max_entries, int *keys,
> > +                          void *values, bool is_pcpu)
> > +{
> > +     typedef BPF_DECLARE_PERCPU(int, value);
> > +     int i, j, err;
> > +     value *v;
> > +
> > +     if (is_pcpu)
> > +             v = (value *)values;
> > +
> > +     for (i = 0; i < max_entries; i++) {
> > +             keys[i] = i + 1;
> > +             if (is_pcpu)
> > +                     for (j = 0; j < bpf_num_possible_cpus(); j++)
> > +                             bpf_percpu(v[i], j) = i + 2 + j;
> > +             else
> > +                     ((int *)values)[i] = i + 2;
> > +     }
> > +
> > +     err = bpf_map_update_batch(map_fd, keys, values, &max_entries, 0, 0);
> > +     CHECK(err, "bpf_map_update_batch()", "error:%s\n", strerror(errno));
> > +}
> > +
> > +static void map_batch_verify(int *visited, __u32 max_entries,
> > +                          int *keys, void *values, bool is_pcpu)
> > +{
> > +     typedef BPF_DECLARE_PERCPU(int, value);
> > +     value *v;
> > +     int i, j;
> > +
> > +     if (is_pcpu)
> > +             v = (value *)values;
> > +
> > +     memset(visited, 0, max_entries * sizeof(*visited));
> > +     for (i = 0; i < max_entries; i++) {
> > +
> > +             if (is_pcpu) {
> > +                     for (j = 0; j < bpf_num_possible_cpus(); j++) {
> > +                             CHECK(keys[i] + 1 + j != bpf_percpu(v[i], j),
> > +                                   "key/value checking",
> > +                                   "error: i %d j %d key %d value %d\n",
> > +                                   i, j, keys[i], bpf_percpu(v[i],  j));
> > +                     }
> > +             } else {
> > +                     CHECK(keys[i] + 1 != ((int *)values)[i],
> > +                           "key/value checking",
> > +                           "error: i %d key %d value %d\n", i, keys[i],
> > +                           ((int *)values)[i]);
> > +             }
> > +
> > +             visited[i] = 1;
> > +
> > +     }
> > +     for (i = 0; i < max_entries; i++) {
> > +             CHECK(visited[i] != 1, "visited checking",
> > +                   "error: keys array at index %d missing\n", i);
> > +     }
> > +}
> > +
> > +void __test_map_lookup_and_delete_batch(bool is_pcpu)
> > +{
> > +     int map_type = is_pcpu ? BPF_MAP_TYPE_PERCPU_HASH : BPF_MAP_TYPE_HASH;
> > +     struct bpf_create_map_attr xattr = {
> > +             .name = "hash_map",
> > +             .map_type = map_type,
> > +             .key_size = sizeof(int),
> > +             .value_size = sizeof(int),
> > +     };
> > +     typedef BPF_DECLARE_PERCPU(int, value);
> > +     int map_fd, *keys, *visited, key;
> > +     __u32 batch = 0, count, total, total_success;
> > +     const __u32 max_entries = 10;
> > +     int err, i, step, value_size;
> > +     value pcpu_values[10];
> > +     bool nospace_err;
> > +     void *values;
> > +
> > +     xattr.max_entries = max_entries;
> > +     map_fd = bpf_create_map_xattr(&xattr);
> > +     CHECK(map_fd == -1,
> > +           "bpf_create_map_xattr()", "error:%s\n", strerror(errno));
> > +
> > +     value_size = is_pcpu ? sizeof(value) : sizeof(int);
> > +     keys = malloc(max_entries * sizeof(int));
> > +     if (is_pcpu)
> > +             values = pcpu_values;
> > +     else
> > +             values = malloc(max_entries * sizeof(int));
> > +     visited = malloc(max_entries * sizeof(int));
> > +     CHECK(!keys || !values || !visited, "malloc()",
> > +           "error:%s\n", strerror(errno));
> > +
> > +     /* test 1: lookup/delete an empty hash table, -ENOENT */
> > +     count = max_entries;
> > +     err = bpf_map_lookup_and_delete_batch(map_fd, NULL, &batch, keys,
> > +                                           values, &count, 0, 0);
> > +     CHECK((err && errno != ENOENT), "empty map",
> > +           "error: %s\n", strerror(errno));
> > +
> > +     /* populate elements to the map */
> > +     map_batch_update(map_fd, max_entries, keys, values, is_pcpu);
> > +
> > +     /* test 2: lookup/delete with count = 0, success */
> > +     batch = 0;
> > +     count = 0;
> > +     err = bpf_map_lookup_and_delete_batch(map_fd, NULL, &batch, keys,
> > +                                           values, &count, 0, 0);
> > +     CHECK(err, "count = 0", "error: %s\n", strerror(errno));
> > +
> > +     /* test 3: lookup/delete with count = max_entries, success */
> > +     memset(keys, 0, max_entries * sizeof(*keys));
> > +     memset(values, 0, max_entries * value_size);
> > +     count = max_entries;
> > +     batch = 0;
> > +     err = bpf_map_lookup_and_delete_batch(map_fd, NULL, &batch, keys,
> > +                                           values, &count, 0, 0);
> > +     CHECK((err && errno != ENOENT), "count = max_entries",
> > +            "error: %s\n", strerror(errno));
> > +     CHECK(count != max_entries, "count = max_entries",
> > +           "count = %u, max_entries = %u\n", count, max_entries);
> > +     map_batch_verify(visited, max_entries, keys, values, is_pcpu);
> > +
> > +     /* bpf_map_get_next_key() should return -ENOENT for an empty map. */
> > +     err = bpf_map_get_next_key(map_fd, NULL, &key);
> > +     CHECK(!err, "bpf_map_get_next_key()", "error: %s\n", strerror(errno));
> > +
> > +     /* test 4: lookup/delete in a loop with various steps. */
> > +     total_success = 0;
> > +     for (step = 1; step < max_entries; step++) {
> > +             map_batch_update(map_fd, max_entries, keys, values, is_pcpu);
> > +             memset(keys, 0, max_entries * sizeof(*keys));
> > +             memset(values, 0, max_entries * value_size);
> > +             batch = 0;
> > +             total = 0;
> > +             i = 0;
> > +             /* iteratively lookup/delete elements with 'step'
> > +              * elements each
> > +              */
> > +             count = step;
> > +             nospace_err = false;
> > +             while (true) {
> > +                     err = bpf_map_lookup_batch(map_fd,
> > +                                                total ? &batch : NULL,
> > +                                                &batch, keys + total,
> > +                                                values +
> > +                                                total * value_size,
> > +                                                &count, 0, 0);
> > +                     /* It is possible that we are failing due to buffer size
> > +                      * not big enough. In such cases, let us just exit and
> > +                      * go with large steps. Not that a buffer size with
> > +                      * max_entries should always work.
> > +                      */
> > +                     if (err && errno == ENOSPC) {
> > +                             nospace_err = true;
> > +                             break;
> > +                     }
> > +
> > +
> > +                     CHECK((err && errno != ENOENT), "lookup with steps",
> > +                           "error: %s\n", strerror(errno));
> > +
> > +                     total += count;
> > +                     if (err)
> > +                             break;
> > +
> > +                     i++;
> > +             }
> > +             if (nospace_err == true)
> > +                     continue;
> > +
> > +             CHECK(total != max_entries, "lookup with steps",
> > +                   "total = %u, max_entries = %u\n", total, max_entries);
> > +             map_batch_verify(visited, max_entries, keys, values, is_pcpu);
> > +
> > +             memset(keys, 0, max_entries * sizeof(*keys));
> > +             memset(values, 0, max_entries * value_size);
> > +             batch = 0;
> > +             total = 0;
> > +             i = 0;
> > +             /* iteratively lookup/delete elements with 'step'
> > +              * elements each
> > +              */
> > +             count = step;
> > +             nospace_err = false;
> > +             while (true) {
> > +                     err = bpf_map_lookup_and_delete_batch(map_fd,
> > +                                                     total ? &batch : NULL,
> > +                                                     &batch, keys + total,
> > +                                                     values +
> > +                                                     total * value_size,
> > +                                                     &count, 0, 0);
> > +                     /* It is possible that we are failing due to buffer size
> > +                      * not big enough. In such cases, let us just exit and
> > +                      * go with large steps. Not that a buffer size with
> > +                      * max_entries should always work.
> > +                      */
> > +                     if (err && errno == ENOSPC) {
> > +                             nospace_err = true;
> > +                             break;
> > +                     }
> > +
> > +                     CHECK((err && errno != ENOENT), "lookup with steps",
> > +                           "error: %s\n", strerror(errno));
> > +
> > +                     total += count;
> > +                     if (err)
> > +                             break;
> > +                     i++;
> > +             }
> > +
> > +             if (nospace_err == true)
> > +                     continue;
> > +
> > +             CHECK(total != max_entries, "lookup/delete with steps",
> > +                   "total = %u, max_entries = %u\n", total, max_entries);
> > +
> > +             map_batch_verify(visited, max_entries, keys, values, is_pcpu);
> > +             err = bpf_map_get_next_key(map_fd, NULL, &key);
> > +             CHECK(!err, "bpf_map_get_next_key()", "error: %s\n",
> > +                   strerror(errno));
> > +
> > +             total_success++;
> > +     }
> > +
> > +     CHECK(total_success == 0, "check total_success",
> > +           "unexpected failure\n");
> > +}
> > +
> > +void test_hmap_lookup_and_delete_batch(void)
> > +{
> > +     __test_map_lookup_and_delete_batch(false);
> > +     printf("%s:PASS\n", __func__);
> > +}
> > +
> > +void test_pcpu_hmap_lookup_and_delete_batch(void)
> > +{
> > +     __test_map_lookup_and_delete_batch(true);
> > +     printf("%s:PASS\n", __func__);
> > +}
> > +
> > +void test_map_lookup_and_delete_batch_htab(void)
> > +{
> > +     test_hmap_lookup_and_delete_batch();
> > +     test_pcpu_hmap_lookup_and_delete_batch();
> > +}
> >
