Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315A152CB2B
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 06:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbiESEio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 00:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiESEil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 00:38:41 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534135BD3D;
        Wed, 18 May 2022 21:38:40 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id e15so4617399iob.3;
        Wed, 18 May 2022 21:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gxZjiYTaN4ezKLlxi7VUQHVQNtVzg+Slph/Lq3uj/4I=;
        b=DEx0kfEIQ0viEYpwSgupzdmCv9f6S1pVgkUjBRB2A1z7icJARW+u/y8u01Cqu+HfBy
         BAPVwAD/mcutOGfUJPJkYizgwR39E0iL9I9t6r9LYR8fsGpeLLA4wZLcr/TAdv0h5XFX
         JW8xZhxsJjSAUqb/B0u36itSTNPQvlYrg0Rw752iunh9sxO2b7ljGKU/EzX05zEsIyTh
         /hESa2z4xWeRlayS6ge/a+r+W7RJC1jtN/1ZDpMKWGgfR45VE4wJAH9vcvoajtmODchM
         JSDhlytoTpfaJW2mtSMNQPQ2Tq318zRVapM5mq6ygVZavJ59IzSUqAHYVcCladH++wDZ
         PvcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gxZjiYTaN4ezKLlxi7VUQHVQNtVzg+Slph/Lq3uj/4I=;
        b=DbS+EPetkAOfMDzBFXhiPEjCfU0sZQ5u/DUmQ69aOTn4g3FGl3Tm+Mp/Y6oCfNl1Qk
         PfMtrdZKSARopRbVLBzkqbQHUBUi7YfrqdgY5oIj3MtFcYMGmspi44VS9MXkwQ4wMyna
         z2dsPrOrJnVq59/DxvS1+tmUIaseo/wMISohP/wj/NdDHF3iGQxA2kA1Jj5t90kGzdft
         F9PFdny3ZUPCjtgG/4Ld7N4PCZv+lLoXR3f49A4J6lotRkThuUXsb2PkjEzArQBecfb/
         tVgWENmVV1NR/ZaNQ0goH1/rOFn+fGeJbehdDr1AVQ5OZAtSzrMVWyC0fc9AX+reRI0l
         YTWQ==
X-Gm-Message-State: AOAM530HZRoke4/ipoAhwISjtoZJL1XaK/CozK3Mh467SYlsh1rWC/dN
        UUZi+a0XpGCXTSbZav5FFMWhzK7O7o9XLPz1lYA=
X-Google-Smtp-Source: ABdhPJw22ffAQ9T+RrX0TY5bFNOry0J9oMO3fKkDKsDBJ988QAdDiXND6i6Nus6WHLG9t4c7c3TRmQl2lNjWPjEbKrw=
X-Received: by 2002:a05:6602:1695:b0:65d:cbd3:eed0 with SMTP id
 s21-20020a056602169500b0065dcbd3eed0mr1497971iow.144.1652935119729; Wed, 18
 May 2022 21:38:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220516022453.68420-1-zhoufeng.zf@bytedance.com>
 <CAEf4BzZ0eRh4ufQnc69B=6WQt_Oy3DNPL-TM-rsUW1KX--SBvQ@mail.gmail.com> <196f6ae9-f899-16c8-a5d3-a1c771fa9900@bytedance.com>
In-Reply-To: <196f6ae9-f899-16c8-a5d3-a1c771fa9900@bytedance.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 May 2022 21:38:28 -0700
Message-ID: <CAEf4BzabT5xdscH8jgTbAVhj415k=1MziKmAXTi6yfeo1DTBRw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH bpf-next] selftests/bpf: fix some bugs in
 map_lookup_percpu_elem testcase
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
        zhouchengming@bytedance.com, Yosry Ahmed <yosryahmed@google.com>
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

On Wed, May 18, 2022 at 8:27 PM Feng Zhou <zhoufeng.zf@bytedance.com> wrote=
:
>
> =E5=9C=A8 2022/5/19 =E4=B8=8A=E5=8D=888:17, Andrii Nakryiko =E5=86=99=E9=
=81=93:
> > On Sun, May 15, 2022 at 7:25 PM Feng zhou <zhoufeng.zf@bytedance.com> w=
rote:
> >> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> >>
> >> comments from Andrii Nakryiko, details in here:
> >> https://lore.kernel.org/lkml/20220511093854.411-1-zhoufeng.zf@bytedanc=
e.com/T/
> >>
> >> use /* */ instead of //
> >> use libbpf_num_possible_cpus() instead of sysconf(_SC_NPROCESSORS_ONLN=
)
> >> use 8 bytes for value size
> >> fix memory leak
> >> use ASSERT_EQ instead of ASSERT_OK
> >> add bpf_loop to fetch values on each possible CPU
> >>
> >> Fixes: ed7c13776e20c74486b0939a3c1de984c5efb6aa ("selftests/bpf: add t=
est case for bpf_map_lookup_percpu_elem")
> >> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> >> ---
> >>   .../bpf/prog_tests/map_lookup_percpu_elem.c   | 49 +++++++++------
> >>   .../bpf/progs/test_map_lookup_percpu_elem.c   | 61 ++++++++++++-----=
--
> >>   2 files changed, 70 insertions(+), 40 deletions(-)
> >>
> >> diff --git a/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_=
elem.c b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
> >> index 58b24c2112b0..89ca170f1c25 100644
> >> --- a/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
> >> +++ b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
> >> @@ -1,30 +1,39 @@
> >> -// SPDX-License-Identifier: GPL-2.0
> >> -// Copyright (c) 2022 Bytedance
> >> +/* SPDX-License-Identifier: GPL-2.0 */
> > heh, so for SPDX license comment the rule is to use // in .c files :)
> > so keep SPDX as // and all others as /* */
>
> will do. Thanks.
>
> >
> >> +/* Copyright (c) 2022 Bytedance */
> >>
> >>   #include <test_progs.h>
> >>
> >>   #include "test_map_lookup_percpu_elem.skel.h"
> >>
> >> -#define TEST_VALUE  1
> >> -
> >>   void test_map_lookup_percpu_elem(void)
> >>   {
> >>          struct test_map_lookup_percpu_elem *skel;
> >> -       int key =3D 0, ret;
> >> -       int nr_cpus =3D sysconf(_SC_NPROCESSORS_ONLN);
> >> -       int *buf;
> >> +       __u64 key =3D 0, sum;
> >> +       int ret, i;
> >> +       int nr_cpus =3D libbpf_num_possible_cpus();
> >> +       __u64 *buf;
> >>
> >> -       buf =3D (int *)malloc(nr_cpus*sizeof(int));
> >> +       buf =3D (__u64 *)malloc(nr_cpus*sizeof(__u64));
> > no need for casting
>
> casting means no '(__u64 *)'?
> just like this:
> 'buf =3D malloc(nr_cpus * sizeof(__u64));'
>

yes, in C you don't need to explicitly cast void * to other pointer types

> >
> >>          if (!ASSERT_OK_PTR(buf, "malloc"))
> >>                  return;
> >> -       memset(buf, 0, nr_cpus*sizeof(int));
> >> -       buf[0] =3D TEST_VALUE;
> >>
> >> -       skel =3D test_map_lookup_percpu_elem__open_and_load();
> >> -       if (!ASSERT_OK_PTR(skel, "test_map_lookup_percpu_elem__open_an=
d_load"))
> >> -               return;
> >> +       for (i=3D0; i<nr_cpus; i++)
> > spaces between operators
>
> will do. Thanks.
>
> >
> >> +               buf[i] =3D i;
> >> +       sum =3D (nr_cpus-1)*nr_cpus/2;
> > same, please follow kernel code style
>
> will do. Thanks.
>
> >
> >> +
> >> +       skel =3D test_map_lookup_percpu_elem__open();
> >> +       if (!ASSERT_OK_PTR(skel, "test_map_lookup_percpu_elem__open"))
> >> +               goto exit;
> >> +
> > nit: keep it simple, init skel to NULL and use single cleanup goto
> > label that will destroy skel unconditionally (it deals with NULL just
> > fine)
>
> will do. Thanks.
>
> >> +       skel->rodata->nr_cpus =3D nr_cpus;
> >> +
> >> +       ret =3D test_map_lookup_percpu_elem__load(skel);
> >> +       if (!ASSERT_OK(ret, "test_map_lookup_percpu_elem__load"))
> >> +               goto cleanup;
> >> +
> >>          ret =3D test_map_lookup_percpu_elem__attach(skel);
> >> -       ASSERT_OK(ret, "test_map_lookup_percpu_elem__attach");
> >> +       if (!ASSERT_OK(ret, "test_map_lookup_percpu_elem__attach"))
> >> +               goto cleanup;
> >>
> >>          ret =3D bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_arr=
ay_map), &key, buf, 0);
> >>          ASSERT_OK(ret, "percpu_array_map update");
> > [...]
>
>
