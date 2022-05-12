Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC5B5252DF
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356606AbiELQoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356115AbiELQoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:44:03 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB82268229;
        Thu, 12 May 2022 09:44:01 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id e15so6004344iob.3;
        Thu, 12 May 2022 09:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lkhXXJwy6RO4RAT0nnf3gRFFygYd/fLPLB7ki9oicS4=;
        b=nFRkwomtukkcjDhkPazmWQ25VJXK2SMyNsXkRTv3EihOIfwRChwP/dN+teLmBp8XUN
         SH+8/0xXcckAln8F7H7T5sjgjXTKYvES/vr21tUaZV1cEhg+9wmUL1lngnMMNCBXI5UI
         92L0UEmxAHkbqk6J4I57FeaGDAoAKN2IVVycPgU4ATPTMf1QLmee4wzlKFrtlqdSEyjN
         crO4L1BsD7v+f50PUpQZYBIjvlI3lFyPlZQwAy806/MT4M4bA/vDjxWXy/aDGEZXBKqi
         aooxFzBC1Bwrg77rpWYAjUG7sEvKEzg9j7HwOVkrdO7zXGXut+IIX0AB0U0uLxImO0ud
         2x/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lkhXXJwy6RO4RAT0nnf3gRFFygYd/fLPLB7ki9oicS4=;
        b=KK42eGS4ni+3AcWvps0ZQukzsjvh08U26egVSkXrmff2J0iOBCxG5Nd2SA1JjssX1Z
         Dyty+s0TmkoeDzcjOK399xEJKOgxPZNafv1hHkfjIH5cN5q6k9dThyYwergdL0k4Unix
         p6OI3420LpEh8Au+Nmm268kBJ9+8+28iM12RXvjA+mys0Y79jHvJdWp29W9Ffp71noKB
         UZPTNl5WB13ewHGUaOy8ZAikwg5/jd11w9bOWMxDFx8n24uD5uwTrWU4R1KdvBGtTcJP
         OIZRLmxiku2eMpLkSBm/COhL6hdMY6MyZMHJXkVL1nUPQAdgG22y0KVckMToxizb38JB
         t7GA==
X-Gm-Message-State: AOAM53030ISUD3+Z1AlJIC1EBbXHKm0KbE65yP/WIrXNBVvELh4yRehU
        Fp9OzkIu3IhdJ0Ch3Jm2n7s6yUl7P2zmMgAG/fw=
X-Google-Smtp-Source: ABdhPJzHfSGvC3Ai3IAHEVPBzmdFYjSS4OyYCGZFcc84Sg3MxcfhQH1wF1QBTQF/y/jwCot5hweElEALaKpJXwIrDdk=
X-Received: by 2002:a05:6638:468e:b0:32b:fe5f:d73f with SMTP id
 bq14-20020a056638468e00b0032bfe5fd73fmr476945jab.234.1652373841065; Thu, 12
 May 2022 09:44:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220511093854.411-1-zhoufeng.zf@bytedance.com>
 <20220511093854.411-3-zhoufeng.zf@bytedance.com> <CAEf4BzZL85C7KUwKv9i5cdLSDzM175cLjiW4EDjOqNfcxbLO+A@mail.gmail.com>
 <731c281a-9911-fa86-fec2-a3c1a3954461@bytedance.com>
In-Reply-To: <731c281a-9911-fa86-fec2-a3c1a3954461@bytedance.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 12 May 2022 09:43:49 -0700
Message-ID: <CAEf4BzY5HmNVgUH_bmoXfCubgosmmJ3N1gip_vrLGQEo=XV8gg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH bpf-next v2 2/2] selftests/bpf: add test
 case for bpf_map_lookup_percpu_elem
To:     Feng Zhou <zhoufeng.zf@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joanne Koong <joannekoong@fb.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        zhouchengming@bytedance.com, yosryahmed@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 8:58 PM Feng Zhou <zhoufeng.zf@bytedance.com> wrote=
:
>
> =E5=9C=A8 2022/5/12 =E4=B8=8A=E5=8D=8811:34, Andrii Nakryiko =E5=86=99=E9=
=81=93:
> > On Wed, May 11, 2022 at 2:39 AM Feng zhou <zhoufeng.zf@bytedance.com> w=
rote:
> >> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> >>
> >> test_progs:
> >> Tests new ebpf helpers bpf_map_lookup_percpu_elem.
> >>
> >> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> >> ---
> >>   .../bpf/prog_tests/map_lookup_percpu_elem.c   | 46 ++++++++++++++++
> >>   .../bpf/progs/test_map_lookup_percpu_elem.c   | 54 +++++++++++++++++=
++
> >>   2 files changed, 100 insertions(+)
> >>   create mode 100644 tools/testing/selftests/bpf/prog_tests/map_lookup=
_percpu_elem.c
> >>   create mode 100644 tools/testing/selftests/bpf/progs/test_map_lookup=
_percpu_elem.c
> >>
> >> diff --git a/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_=
elem.c b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
> >> new file mode 100644
> >> index 000000000000..58b24c2112b0
> >> --- /dev/null
> >> +++ b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
> >> @@ -0,0 +1,46 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +// Copyright (c) 2022 Bytedance
> > /* */ instead of //
>
> Ok, I will do. Thanks.
>
>
> >
> >> +
> >> +#include <test_progs.h>
> >> +
> >> +#include "test_map_lookup_percpu_elem.skel.h"
> >> +
> >> +#define TEST_VALUE  1
> >> +
> >> +void test_map_lookup_percpu_elem(void)
> >> +{
> >> +       struct test_map_lookup_percpu_elem *skel;
> >> +       int key =3D 0, ret;
> >> +       int nr_cpus =3D sysconf(_SC_NPROCESSORS_ONLN);
> > I think this is actually wrong and will break selftests on systems
> > with offline CPUs. Please use libbpf_num_possible_cpus() instead.
>
>
> Ok, I will do. Thanks.
>
>
> >
> >> +       int *buf;
> >> +
> >> +       buf =3D (int *)malloc(nr_cpus*sizeof(int));
> >> +       if (!ASSERT_OK_PTR(buf, "malloc"))
> >> +               return;
> >> +       memset(buf, 0, nr_cpus*sizeof(int));
> > this is wrong, kernel expects to have roundup(sz, 8) per each CPU,
> > while you have just 4 bytes per each element
> >
> > please also have spaces around multiplication operator here and above
>
>
> Ok, I will use 8 bytes for key and val. Thanks.
>
>
> >> +       buf[0] =3D TEST_VALUE;
> >> +
> >> +       skel =3D test_map_lookup_percpu_elem__open_and_load();
> >> +       if (!ASSERT_OK_PTR(skel, "test_map_lookup_percpu_elem__open_an=
d_load"))
> >> +               return;
> > buf leaking here
>
>
> Yes, sorry for my negligence.
>
>
> >
> >> +       ret =3D test_map_lookup_percpu_elem__attach(skel);
> >> +       ASSERT_OK(ret, "test_map_lookup_percpu_elem__attach");
> >> +
> >> +       ret =3D bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_arra=
y_map), &key, buf, 0);
> >> +       ASSERT_OK(ret, "percpu_array_map update");
> >> +
> >> +       ret =3D bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_hash=
_map), &key, buf, 0);
> >> +       ASSERT_OK(ret, "percpu_hash_map update");
> >> +
> >> +       ret =3D bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_lru_=
hash_map), &key, buf, 0);
> >> +       ASSERT_OK(ret, "percpu_lru_hash_map update");
> >> +
> >> +       syscall(__NR_getuid);
> >> +
> >> +       ret =3D skel->bss->percpu_array_elem_val =3D=3D TEST_VALUE &&
> >> +             skel->bss->percpu_hash_elem_val =3D=3D TEST_VALUE &&
> >> +             skel->bss->percpu_lru_hash_elem_val =3D=3D TEST_VALUE;
> >> +       ASSERT_OK(!ret, "bpf_map_lookup_percpu_elem success");
> > this would be better done as three separate ASSERT_EQ(), combining
> > into opaque true/false isn't helpful if something breaks
>
>
> Good suggestion.
>
>
> >
> >> +
> >> +       test_map_lookup_percpu_elem__destroy(skel);
> >> +}
> >> diff --git a/tools/testing/selftests/bpf/progs/test_map_lookup_percpu_=
elem.c b/tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c
> >> new file mode 100644
> >> index 000000000000..5d4ef86cbf48
> >> --- /dev/null
> >> +++ b/tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c
> >> @@ -0,0 +1,54 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +// Copyright (c) 2022 Bytedance
> > /* */ instead of //
>
>
> Ok, I will do. Thanks.
>
>
> >
> >> +
> >> +#include "vmlinux.h"
> >> +#include <bpf/bpf_helpers.h>
> >> +
> >> +int percpu_array_elem_val =3D 0;
> >> +int percpu_hash_elem_val =3D 0;
> >> +int percpu_lru_hash_elem_val =3D 0;
> >> +
> >> +struct {
> >> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> >> +       __uint(max_entries, 1);
> >> +       __type(key, __u32);
> >> +       __type(value, __u32);
> >> +} percpu_array_map SEC(".maps");
> >> +
> >> +struct {
> >> +       __uint(type, BPF_MAP_TYPE_PERCPU_HASH);
> >> +       __uint(max_entries, 1);
> >> +       __type(key, __u32);
> >> +       __type(value, __u32);
> >> +} percpu_hash_map SEC(".maps");
> >> +
> >> +struct {
> >> +       __uint(type, BPF_MAP_TYPE_LRU_PERCPU_HASH);
> >> +       __uint(max_entries, 1);
> >> +       __type(key, __u32);
> >> +       __type(value, __u32);
> >> +} percpu_lru_hash_map SEC(".maps");
> >> +
> >> +SEC("tp/syscalls/sys_enter_getuid")
> >> +int sysenter_getuid(const void *ctx)
> >> +{
> >> +       __u32 key =3D 0;
> >> +       __u32 cpu =3D 0;
> >> +       __u32 *value;
> >> +
> >> +       value =3D bpf_map_lookup_percpu_elem(&percpu_array_map, &key, =
cpu);
> >> +       if (value)
> >> +               percpu_array_elem_val =3D *value;
> >> +
> >> +       value =3D bpf_map_lookup_percpu_elem(&percpu_hash_map, &key, c=
pu);
> >> +       if (value)
> >> +               percpu_hash_elem_val =3D *value;
> >> +
> >> +       value =3D bpf_map_lookup_percpu_elem(&percpu_lru_hash_map, &ke=
y, cpu);
> >> +       if (value)
> >> +               percpu_lru_hash_elem_val =3D *value;
> >> +
> > if the test happens to run on CPU 0 then the test doesn't really test
> > much. It would be more interesting to have a bpf_loop() iteration that
> > would fetch values on each possible CPU instead and do something with
> > it.
>
>
> Good suggestion. I check the code and find no bpf helper function to get
> possible CPU nums.
>
> I think for the test function, read cpu0 elem value correctly should be
> considered to be no problem.
>
> Or is it necessary to add a new helper function to get num_possible_cpus =
?
>
>

You can pass number of CPUs from user-space to BPF program through
read-only variable (search for `const volatile` under progs/ for
examples)

> >
> >> +       return 0;
> >> +}
> >> +
> >> +char _license[] SEC("license") =3D "GPL";
> >> --
> >> 2.20.1
> >>
>
