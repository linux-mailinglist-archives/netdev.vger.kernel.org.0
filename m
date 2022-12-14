Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE9E64D01E
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 20:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237752AbiLNTf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 14:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiLNTf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 14:35:28 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D088F124;
        Wed, 14 Dec 2022 11:35:26 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id kw15so47026384ejc.10;
        Wed, 14 Dec 2022 11:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GXfw3emYMkZf6BSorUXvbBQuPX16o2thlPz71megX9E=;
        b=MRNsQ/twOilW3jYA4nkpN79LB6I6yaMe4RFzZfwf1koZOyoz7wNJtftKStdDBcWcvN
         379f6Gl5+TZsd4+qIJ/yUU9MJ3+rYE/jxejIjejZNtCh93hahEkO+XO2U5NKtTIHMoKo
         9bAFTIrwWBzEN4+5bX0uGzJNjV8E4KaYsmMNMFWAdIuS2+JTEBHFgOsble7xyVuWqaTI
         g3XPdhWrQI/e3zhh32L3vUFF2gLoRTDbb8g6LSbjK5p6lqMiD/q8HbaIpw/C98fkFDG5
         3JY5h8hnuIc5qSksnETTd5pVKVF/kue0A+Jm1M/NKWF+rW+hA1zCaWS5HN+OZGuC35tg
         NQCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GXfw3emYMkZf6BSorUXvbBQuPX16o2thlPz71megX9E=;
        b=v6kKKL/mm2i6C2i5VZRjk/qZ/BiRT0XFxpUBUAMe5vi3fj53S77n3d24U9Kunuu5EQ
         nmt5WxhtCKmsYHDYDxxuDiKdWT2JLyoj7AZj4WOy9MRR6jUs6t70/NaC2cQjtXPwePbk
         8fKOXIn4p+bG4D6RketnPrE7GeZz9V49/o5UodKtKx6MjPOxwmVmOY/zkfoonELSHg0u
         73x/45hcvaW4KUx6eYG7xo3fOIOwns7n9n4n2Yx5Xgb6XCsssbYSdUaIwyuo+J+8Ia/S
         3JmtiAFsvdj0/1SZVrNykVaJtGxQ6dRigep800ERnBDLWH18Lhy3bn38D/YD1LABB8Ij
         91xQ==
X-Gm-Message-State: ANoB5pnJSTpddMNSO8+YSJH2RU37d1dgMUInMVfw2hM6XQy+mlw479Ze
        4CJfq7IOm4i/akgT+0IO4yb4UTC0COJXBn/iJp8=
X-Google-Smtp-Source: AA0mqf7ZRJF6xBj++V4WSuTsncIpxb1GQQFJ+ucgg1kFoi8DVSYFTem69Okmr0CyD/gLmy3y2XIOgpOPZu4ht3T0qkg=
X-Received: by 2002:a17:906:94e:b0:7ba:4617:3f17 with SMTP id
 j14-20020a170906094e00b007ba46173f17mr59534592ejd.226.1671046525315; Wed, 14
 Dec 2022 11:35:25 -0800 (PST)
MIME-Version: 1.0
References: <20221214010517.668943-1-toke@redhat.com> <20221214010517.668943-2-toke@redhat.com>
In-Reply-To: <20221214010517.668943-2-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Dec 2022 11:35:13 -0800
Message-ID: <CAEf4BzYMNgfmnKzAo==Rs8E-S6cTsVv4mj_17yfKmQ5S_KzXuQ@mail.gmail.com>
Subject: Re: [PATCH bpf v4 2/2] selftests/bpf: Add a test for using a cpumap
 from an freplace-to-XDP program
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 5:05 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> This adds a simple test for inserting an XDP program into a cpumap that i=
s
> "owned" by an XDP program that was loaded as PROG_TYPE_EXT (as libxdp
> does). Prior to the kernel fix this would fail because the map type
> ownership would be set to PROG_TYPE_EXT instead of being resolved to
> PROG_TYPE_XDP.
>
> v4:
> - Use skeletons for selftest
> v3:
> - Update comment to better explain the cause
> - Add Yonghong's ACK
>
> Acked-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 54 +++++++++++++++++++
>  .../selftests/bpf/progs/freplace_progmap.c    | 24 +++++++++
>  2 files changed, 78 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/freplace_progmap.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/too=
ls/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> index d1e32e792536..efa1fc65840d 100644
> --- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> @@ -4,6 +4,8 @@
>  #include <network_helpers.h>
>  #include <bpf/btf.h>
>  #include "bind4_prog.skel.h"
> +#include "freplace_progmap.skel.h"
> +#include "xdp_dummy.skel.h"
>
>  typedef int (*test_cb)(struct bpf_object *obj);
>
> @@ -500,6 +502,56 @@ static void test_fentry_to_cgroup_bpf(void)
>         bind4_prog__destroy(skel);
>  }
>
> +static void test_func_replace_progmap(void)
> +{
> +       struct bpf_cpumap_val value =3D { .qsize =3D 1 };
> +       struct freplace_progmap *skel =3D NULL;
> +       struct xdp_dummy *tgt_skel =3D NULL;
> +       int err, tgt_fd;
> +       __u32 key =3D 0;
> +
> +       skel =3D freplace_progmap__open();
> +       if (!ASSERT_OK_PTR(skel, "prog_open"))
> +               return;
> +
> +       tgt_skel =3D xdp_dummy__open_and_load();
> +       if (!ASSERT_OK_PTR(tgt_skel, "tgt_prog_load"))
> +               goto out;
> +
> +       tgt_fd =3D bpf_program__fd(tgt_skel->progs.xdp_dummy_prog);
> +
> +       /* Change the 'redirect' program type to be a PROG_TYPE_EXT
> +        * with an XDP target
> +        */
> +       bpf_program__set_type(skel->progs.xdp_cpumap_prog, BPF_PROG_TYPE_=
EXT);
> +       bpf_program__set_expected_attach_type(skel->progs.xdp_cpumap_prog=
, 0);

you shouldn't need this manual override if you mark xdp_cpumap_prog as
SEC("freplace"), or am I missing something?

but other than this minor thing looks good to me, thanks

Acked-by: Andrii Nakryiko <andrii@kernel.org>



> +       err =3D bpf_program__set_attach_target(skel->progs.xdp_cpumap_pro=
g,
> +                                            tgt_fd, "xdp_dummy_prog");
> +       if (!ASSERT_OK(err, "set_attach_target"))
> +               goto out;
> +
> +       err =3D freplace_progmap__load(skel);
> +       if (!ASSERT_OK(err, "obj_load"))
> +               goto out;
> +
> +       /* Prior to fixing the kernel, loading the PROG_TYPE_EXT 'redirec=
t'
> +        * program above will cause the map owner type of 'cpumap' to be =
set to
> +        * PROG_TYPE_EXT. This in turn will cause the bpf_map_update_elem=
()
> +        * below to fail, because the program we are inserting into the m=
ap is
> +        * of PROG_TYPE_XDP. After fixing the kernel, the initial ownersh=
ip will
> +        * be correctly resolved to the *target* of the PROG_TYPE_EXT pro=
gram
> +        * (i.e., PROG_TYPE_XDP) and the map update will succeed.
> +        */
> +       value.bpf_prog.fd =3D bpf_program__fd(skel->progs.xdp_drop_prog);
> +       err =3D bpf_map_update_elem(bpf_map__fd(skel->maps.cpu_map),
> +                                 &key, &value, 0);
> +       ASSERT_OK(err, "map_update");
> +
> +out:
> +       xdp_dummy__destroy(tgt_skel);
> +       freplace_progmap__destroy(skel);
> +}
> +
>  /* NOTE: affect other tests, must run in serial mode */
>  void serial_test_fexit_bpf2bpf(void)
>  {
> @@ -525,4 +577,6 @@ void serial_test_fexit_bpf2bpf(void)
>                 test_func_replace_global_func();
>         if (test__start_subtest("fentry_to_cgroup_bpf"))
>                 test_fentry_to_cgroup_bpf();
> +       if (test__start_subtest("func_replace_progmap"))
> +               test_func_replace_progmap();
>  }
> diff --git a/tools/testing/selftests/bpf/progs/freplace_progmap.c b/tools=
/testing/selftests/bpf/progs/freplace_progmap.c
> new file mode 100644
> index 000000000000..68174c3d7b37
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/freplace_progmap.c
> @@ -0,0 +1,24 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_CPUMAP);
> +       __uint(key_size, sizeof(__u32));
> +       __uint(value_size, sizeof(struct bpf_cpumap_val));

ok, another minor nit which you ignored, libbpf should be smart enough to a=
ccept

__type(key, __u32);
__type(value, struct bpf_cpumap_val);

And if it's not it would be good to know that it's not (and trivially fix i=
t).

> +       __uint(max_entries, 1);
> +} cpu_map SEC(".maps");
> +
> +SEC("xdp/cpumap")
> +int xdp_drop_prog(struct xdp_md *ctx)
> +{
> +       return XDP_DROP;
> +}
> +
> +SEC("xdp")
> +int xdp_cpumap_prog(struct xdp_md *ctx)
> +{
> +       return bpf_redirect_map(&cpu_map, 0, XDP_PASS);
> +}
> +
> +char _license[] SEC("license") =3D "GPL";
> --
> 2.38.1
>
