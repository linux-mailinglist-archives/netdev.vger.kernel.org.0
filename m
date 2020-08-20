Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F38124BA05
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 13:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgHTL7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 07:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730491AbgHTL6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 07:58:20 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F9BC061387
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 04:58:20 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id e6so1611217oii.4
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 04:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WYTZ5oggGW4vnzG+aCQEqmegKWwKj3jml6L7NHXjNYI=;
        b=PbHlW3SVBwPWT6+JRJN2hRCld4WOZY3LufJi+ZUjHgO7SHb8ZadSRR5VI/+sG/8kq3
         Vs/Djz3hkKLDwPtYDjJ1Ldm2wll4UIRbjwalRzWoSB/3cGRWrxBmYSmhZGDLy1Lh2UgJ
         oSB7vNuDglyUp4UxSkWaTOPZAX8HVOnuueN1Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WYTZ5oggGW4vnzG+aCQEqmegKWwKj3jml6L7NHXjNYI=;
        b=rkxn9+TJ8cH/DFiJYbCW6euurcidtxidObx1Z93GgJT33rRtxMgKmW39C022xZZ5Dn
         u1EmnJqH76DK5zKKZnTScnuWKsfH2OKN6jz6p7RHO5bXwCQsXVIrrJpnjnLlHvrzYotf
         9juUk5r4PBf5m/Ot9Y231pBICULW/LA04f7YHUh7TLEg7s3k/ZlYFShJ2WguDqvenIn/
         JNMr+WBSXPUOCbPhZLcDoHxONmnDbD3NSc6Fo+oWQcIlz6/r74k7vvGxmtmsi5tJCrdg
         8oFVXtwFJ5qZFgeOzkwFz9g7j2DVW+iFUHOGMg3nYd9Sc1TILU+WYWiFR4UWeFbjs3cw
         Mrtg==
X-Gm-Message-State: AOAM533J9gdHxtn/WVrf+q0TmQL2nFamfTZX5Fp3KpqZfRV3oqMpx6QD
        VpgWE7HiqjBeEMySXLeyrfFwd+e2vsTYDIiSmt1GlA==
X-Google-Smtp-Source: ABdhPJxtaCKs7uJ1rcTpGij31O041fZY6yd8YrzYEQJZp4JbbiPOA8mscbMD5ZiT845VViNeDV7NvyTljs97E5UPVZ8=
X-Received: by 2002:aca:a88e:: with SMTP id r136mr1516559oie.110.1597924699316;
 Thu, 20 Aug 2020 04:58:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200819092436.58232-1-lmb@cloudflare.com> <20200819092436.58232-7-lmb@cloudflare.com>
 <1ad29823-1925-01ee-f042-20b422a62a73@fb.com>
In-Reply-To: <1ad29823-1925-01ee-f042-20b422a62a73@fb.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 20 Aug 2020 12:58:07 +0100
Message-ID: <CACAyw9-ORs29Gt0c02qsco9ah_h88OqQh5cq36SpDCD19x89uw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/6] selftests: bpf: test sockmap update from BPF
To:     Yonghong Song <yhs@fb.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 at 21:46, Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/19/20 2:24 AM, Lorenz Bauer wrote:
> > Add a test which copies a socket from a sockmap into another sockmap
> > or sockhash. This excercises bpf_map_update_elem support from BPF
> > context. Compare the socket cookies from source and destination to
> > ensure that the copy succeeded.
> >
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > ---
> >   .../selftests/bpf/prog_tests/sockmap_basic.c  | 76 +++++++++++++++++++
> >   .../selftests/bpf/progs/test_sockmap_copy.c   | 48 ++++++++++++
> >   2 files changed, 124 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_copy.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> > index 96e7b7f84c65..d30cabc00e9e 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> > @@ -4,6 +4,7 @@
> >
> >   #include "test_progs.h"
> >   #include "test_skmsg_load_helpers.skel.h"
> > +#include "test_sockmap_copy.skel.h"
> >
> >   #define TCP_REPAIR          19      /* TCP sock is under repair right now */
> >
> > @@ -101,6 +102,77 @@ static void test_skmsg_helpers(enum bpf_map_type map_type)
> >       test_skmsg_load_helpers__destroy(skel);
> >   }
> >
> > +static void test_sockmap_copy(enum bpf_map_type map_type)
> > +{
> > +     struct bpf_prog_test_run_attr attr;
> > +     struct test_sockmap_copy *skel;
> > +     __u64 src_cookie, dst_cookie;
> > +     int err, prog, s, src, dst;
> > +     const __u32 zero = 0;
> > +     char dummy[14] = {0};
> > +
> > +     s = connected_socket_v4();
>
> Maybe change variable name to "sk" for better clarity?

Yup!

>
> > +     if (CHECK_FAIL(s == -1))
> > +             return;
> > +
> > +     skel = test_sockmap_copy__open_and_load();
> > +     if (CHECK_FAIL(!skel)) {
> > +             close(s);
> > +             perror("test_sockmap_copy__open_and_load");
> > +             return;
> > +     }
>
> Could you use CHECK instead of CHECK_FAIL?
> With CHECK, you can print additional information without perror.

I avoid CHECK because it requires `duration`, which doesn't make sense
for most things that I call CHECK_FAIL on here. So either it outputs 0
nsec (which is bogus) or it outputs the value from the last
bpf_prog_test_run call (which is also bogus). How do other tests
handle this? Just ignore it?

>
>
> > +
> > +     prog = bpf_program__fd(skel->progs.copy_sock_map);
> > +     src = bpf_map__fd(skel->maps.src);
> > +     if (map_type == BPF_MAP_TYPE_SOCKMAP)
> > +             dst = bpf_map__fd(skel->maps.dst_sock_map);
> > +     else
> > +             dst = bpf_map__fd(skel->maps.dst_sock_hash);
> > +
> > +     err = bpf_map_update_elem(src, &zero, &s, BPF_NOEXIST);
>
> The map defined in bpf program is __u64 and here "s" is int.
> Any potential issues?

Hm, good point. This is a quirk of the sockmap API, I need to dig into
this a bit.

>
> > +     if (CHECK_FAIL(err)) {
> > +             perror("bpf_map_update");
> > +             goto out;
> > +     }
> > +
> > +     err = bpf_map_lookup_elem(src, &zero, &src_cookie);
> > +     if (CHECK_FAIL(err)) {
> > +             perror("bpf_map_lookup_elem(src)");
> > +             goto out;
> > +     }
> > +
> > +     attr = (struct bpf_prog_test_run_attr){
> > +             .prog_fd = prog,
> > +             .repeat = 1,
> > +             .data_in = dummy,
> > +             .data_size_in = sizeof(dummy),
> > +     };
> > +
> > +     err = bpf_prog_test_run_xattr(&attr);
> > +     if (err) {
>
> You can use CHECK macro here.
>
> > +             test__fail();
> > +             perror("bpf_prog_test_run");
> > +             goto out;
> > +     } else if (!attr.retval) {
> > +             PRINT_FAIL("bpf_prog_test_run: program returned %u\n",
> > +                        attr.retval);
> > +             goto out;
> > +     }
> > +
> > +     err = bpf_map_lookup_elem(dst, &zero, &dst_cookie);
> > +     if (CHECK_FAIL(err)) {
> > +             perror("bpf_map_lookup_elem(dst)");
> > +             goto out;
> > +     }
> > +
> > +     if (dst_cookie != src_cookie)
> > +             PRINT_FAIL("cookie %llu != %llu\n", dst_cookie, src_cookie);
>
> Just replace the whole if statement with a CHECK macro.

See above, re duration.

>
> > +
> > +out:
> > +     close(s);
> > +     test_sockmap_copy__destroy(skel);
> > +}
> > +
> >   void test_sockmap_basic(void)
> >   {
> >       if (test__start_subtest("sockmap create_update_free"))
> > @@ -111,4 +183,8 @@ void test_sockmap_basic(void)
> >               test_skmsg_helpers(BPF_MAP_TYPE_SOCKMAP);
> >       if (test__start_subtest("sockhash sk_msg load helpers"))
> >               test_skmsg_helpers(BPF_MAP_TYPE_SOCKHASH);
> > +     if (test__start_subtest("sockmap copy"))
> > +             test_sockmap_copy(BPF_MAP_TYPE_SOCKMAP);
> > +     if (test__start_subtest("sockhash copy"))
> > +             test_sockmap_copy(BPF_MAP_TYPE_SOCKHASH);
> >   }
> > diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_copy.c b/tools/testing/selftests/bpf/progs/test_sockmap_copy.c
> > new file mode 100644
> > index 000000000000..9d0c9f28cab2
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_sockmap_copy.c
> > @@ -0,0 +1,48 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// Copyright (c) 2020 Cloudflare
> > +#include "vmlinux.h"
> > +#include <bpf/bpf_helpers.h>
> > +
> > +struct {
> > +     __uint(type, BPF_MAP_TYPE_SOCKMAP);
> > +     __uint(max_entries, 1);
> > +     __type(key, __u32);
> > +     __type(value, __u64);
> > +} src SEC(".maps");
> > +
> > +struct {
> > +     __uint(type, BPF_MAP_TYPE_SOCKMAP);
> > +     __uint(max_entries, 1);
> > +     __type(key, __u32);
> > +     __type(value, __u64);
> > +} dst_sock_map SEC(".maps");
> > +
> > +struct {
> > +     __uint(type, BPF_MAP_TYPE_SOCKHASH);
> > +     __uint(max_entries, 1);
> > +     __type(key, __u32);
> > +     __type(value, __u64);
> > +} dst_sock_hash SEC(".maps");
> > +
> > +SEC("classifier/copy_sock_map")
> > +int copy_sock_map(void *ctx)
> > +{
> > +     struct bpf_sock *sk;
> > +     bool failed = false;
> > +     __u32 key = 0;
> > +
> > +     sk = bpf_map_lookup_elem(&src, &key);
> > +     if (!sk)
> > +             return SK_DROP;
> > +
> > +     if (bpf_map_update_elem(&dst_sock_map, &key, sk, 0))
> > +             failed = true;
> > +
> > +     if (bpf_map_update_elem(&dst_sock_hash, &key, sk, 0))
> > +             failed = true;
> > +
> > +     bpf_sk_release(sk);
> > +     return failed ? SK_DROP : SK_PASS;
> > +}
> > +
> > +char _license[] SEC("license") = "GPL";
> >



-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
