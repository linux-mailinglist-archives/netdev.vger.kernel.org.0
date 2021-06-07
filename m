Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CB939EA7A
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 01:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhFGX7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 19:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhFGX7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 19:59:37 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C5FC061574;
        Mon,  7 Jun 2021 16:57:31 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id n133so27556594ybf.6;
        Mon, 07 Jun 2021 16:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=x3zJJ5nkdyylLHqsLzPp8G+AsfkdmX8PbkXlCWveIxE=;
        b=np80f27h7tYZhE61kUm3efv8yXNx+VEugnkmNWzNtAAnCOch4U5XMewQiHZwAHc7xr
         styhWHqieDIn2ctXL2Ceovm1hNtu4BiitSFZuogvzRViKPrCfF1KETM/qreT5427p11p
         k814ljZiipmmcbtjVOYeB2QY7niPuZ4daZqt6jOAzUrAPud7+ubVHDOg5dz61I4xZC9o
         fYmlDZ7/gjKaq6yeztRsRnhymkYof5jNESZ5WnjjlshjCSHI/wakOmjNffLciEfEcytW
         lCCDlEP3wzLCfO9RfpV99lLik4s6qUu+f3dGg7EjvUfcuJKXX41etvWV0+RDhgNaCeB0
         QFmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=x3zJJ5nkdyylLHqsLzPp8G+AsfkdmX8PbkXlCWveIxE=;
        b=Y/ccRqNTPO3m9jdUPjTsPU10R5RocvY92mFh2TqMgYImrO6iunfFZ/Wa2KWweKtrkk
         4M+MZCMJTRroKdZbr3J6X0ZSRR9dnSy3YvxqdpxQg4pmnApOPZJd4gdS9f3G0yLijLVa
         3EVkSsMAtUyy+0KcZ+hkgpCXKO8dxPup2U60GDR31wGV6cXBPCo9SsUkx5TwOJ3VSXFa
         WSgNRqwApgYeipvIIOMXUqN9f81Y6ZBxH5rfcynZwnWLIsB+F16/WLTbPVN2kok81c7G
         u2cNCGC18vaMOIf6jwGOKAB2zpzhgjRB2lE44nsFAvtgm82SZbTOntCta4VN/mftBk2/
         kSMQ==
X-Gm-Message-State: AOAM531iVf2H7keFWUV9kLdPTxHwLD0trGT9mxjtNNb3wQ1CblhZBA09
        tWgLARJGzYpIfcYrm2bEWBX0U4/9bKJhWJxMq5I=
X-Google-Smtp-Source: ABdhPJwdAJc+8fjqVmL6x9FJ8EujTlSIDLqwYnJ9cajfL2ZOLxqsdsa/vuMn7i9jTLMKu3y0888d3ijjqQ2MoS2u2f4=
X-Received: by 2002:a25:9942:: with SMTP id n2mr27998805ybo.230.1623110250943;
 Mon, 07 Jun 2021 16:57:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210604063116.234316-1-memxor@gmail.com> <20210604063116.234316-8-memxor@gmail.com>
In-Reply-To: <20210604063116.234316-8-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Jun 2021 16:57:19 -0700
Message-ID: <CAEf4BzYdO=uZcW4PLySPUq8hv7qTdT2B0=s_8w+RVv53FvqfSg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 7/7] libbpf: add selftest for bpf_link based
 TC-BPF management API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 3, 2021 at 11:32 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This covers basic attach/detach/update, and tests interaction with the
> netlink API. It also exercises the bpf_link_info and fdinfo codepaths.
>
> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>.
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  .../selftests/bpf/prog_tests/tc_bpf_link.c    | 285 ++++++++++++++++++
>  1 file changed, 285 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c
>

[...]

> +static int test_tc_bpf_link_netlink_interaction(struct bpf_tc_hook *hook=
,
> +                                               struct bpf_program *prog)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_link_update_opts, lopts,
> +                           .old_prog_fd =3D bpf_program__fd(prog));
> +       DECLARE_LIBBPF_OPTS(bpf_tc_link_opts, opts, .handle =3D 1, .prior=
ity =3D 1);
> +       DECLARE_LIBBPF_OPTS(bpf_tc_opts, nopts, .handle =3D 1, .priority =
=3D 1);
> +       DECLARE_LIBBPF_OPTS(bpf_tc_opts, dopts, .handle =3D 1, .priority =
=3D 1);
> +       struct bpf_link *link;
> +       int ret;
> +
> +       /* We need to test the following cases:
> +        *      1. BPF link owned filter cannot be replaced by netlink
> +        *      2. Netlink owned filter cannot be replaced by BPF link
> +        *      3. Netlink cannot do targeted delete of BPF link owned fi=
lter
> +        *      4. Filter is actually deleted (with chain cleanup)
> +        *         We actually (ab)use the kernel behavior of returning E=
INVAL when
> +        *         target chain doesn't exist on tc_get_tfilter (which ma=
ps to
> +        *         bpf_tc_query) here, to know if the chain was really cl=
eaned
> +        *         up on tcf_proto destruction. Our setup is so that ther=
e is
> +        *         only one reference to the chain.
> +        *
> +        *         So on query, chain ? (filter ?: ENOENT) : EINVAL
> +        */
> +
> +       link =3D bpf_program__attach_tc(prog, hook, &opts);
> +       if (!ASSERT_OK_PTR(link, "bpf_program__attach_tc"))
> +               return PTR_ERR(link);
> +
> +       nopts.prog_fd =3D bpf_program__fd(prog);
> +       ret =3D bpf_tc_attach(hook, &nopts);
> +       if (!ASSERT_EQ(ret, -EEXIST, "bpf_tc_attach without replace"))
> +               goto end;
> +
> +       nopts.flags =3D BPF_TC_F_REPLACE;
> +       ret =3D bpf_tc_attach(hook, &nopts);
> +       if (!ASSERT_EQ(ret, -EPERM, "bpf_tc_attach with replace"))
> +               goto end;
> +
> +       ret =3D bpf_tc_detach(hook, &dopts);
> +       if (!ASSERT_EQ(ret, -EPERM, "bpf_tc_detach"))
> +               goto end;
> +
> +       lopts.flags =3D BPF_F_REPLACE;
> +       ret =3D bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog)=
,
> +                             &lopts);
> +       ASSERT_OK(ret, "bpf_link_update");
> +       ret =3D ret < 0 ? -errno : ret;

all selftests run in libbpf 1.0 mode, so you get actual error
directly, so no need to deal with -errno here.

> +
> +end:
> +       bpf_link__destroy(link);
> +       if (!ret && !ASSERT_EQ(bpf_tc_query(hook, &dopts), -EINVAL,
> +                              "chain empty delete"))
> +               ret =3D -EINVAL;
> +       return ret;
> +}
> +
> +static int test_tc_bpf_link_update_ways(struct bpf_tc_hook *hook,
> +                                       struct bpf_program *prog)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_tc_link_opts, opts, .handle =3D 1, .prior=
ity =3D 1);
> +       DECLARE_LIBBPF_OPTS(bpf_link_update_opts, uopts, 0);
> +       struct test_tc_bpf *skel;
> +       struct bpf_link *link;
> +       int ret;
> +
> +       skel =3D test_tc_bpf__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "test_tc_bpf__open_and_load"))
> +               return PTR_ERR(skel);
> +
> +       link =3D bpf_program__attach_tc(prog, hook, &opts);
> +       if (!ASSERT_OK_PTR(link, "bpf_program__attach_tc")) {
> +               ret =3D PTR_ERR(link);
> +               goto end;
> +       }
> +
> +       ret =3D bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog)=
,
> +                             &uopts);
> +       if (!ASSERT_OK(ret, "bpf_link_update no old prog"))
> +               goto end;
> +
> +       uopts.old_prog_fd =3D bpf_program__fd(prog);
> +       ret =3D bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog)=
,
> +                             &uopts);

please keep all such calls single-line, they aren't excessively long at all

> +       if (!ASSERT_TRUE(ret < 0 && errno =3D=3D EINVAL,
> +                        "bpf_link_update with old prog without BPF_F_REP=
LACE")) {

same as above, ret should already be -EINVAL, so just check directly

> +               ret =3D -EINVAL;
> +               goto end;
> +       }
> +
> +       uopts.flags =3D BPF_F_REPLACE;
> +       ret =3D bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog)=
,
> +                             &uopts);
> +       if (!ASSERT_OK(ret, "bpf_link_update with old prog with BPF_F_REP=
LACE"))
> +               goto end;
> +
> +       uopts.old_prog_fd =3D bpf_program__fd(skel->progs.cls);
> +       ret =3D bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog)=
,
> +                             &uopts);
> +       if (!ASSERT_TRUE(ret < 0 && errno =3D=3D EINVAL,
> +                        "bpf_link_update with wrong old prog")) {

and here

> +               ret =3D -EINVAL;
> +               goto end;
> +       }
> +       ret =3D 0;
> +
> +end:
> +       test_tc_bpf__destroy(skel);
> +       return ret;
> +}
> +
> +static int test_tc_bpf_link_info_api(struct bpf_tc_hook *hook,
> +                                    struct bpf_program *prog)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_tc_link_opts, opts, .handle =3D 1, .prior=
ity =3D 1);
> +       __u32 ifindex, parent, handle, gen_flags, priority;
> +       char buf[4096], path[256], *begin;
> +       struct bpf_link_info info =3D {};
> +       __u32 info_len =3D sizeof(info);
> +       struct bpf_link *link;
> +       int ret, fdinfo;
> +
> +       link =3D bpf_program__attach_tc(prog, hook, &opts);
> +       if (!ASSERT_OK_PTR(link, "bpf_program__attach_tc"))
> +               return PTR_ERR(link);
> +
> +       ret =3D bpf_obj_get_info_by_fd(bpf_link__fd(link), &info, &info_l=
en);
> +       if (!ASSERT_OK(ret, "bpf_obj_get_info_by_fd"))
> +               goto end;
> +
> +       ret =3D snprintf(path, sizeof(path), "/proc/self/fdinfo/%d",
> +                      bpf_link__fd(link));
> +       if (!ASSERT_TRUE(!ret || ret < sizeof(path), "snprintf pathname")=
)
> +               goto end;

ASSERT_TRUE is very generic, it's better to do ASSERT_LT(ret,
sizeof(path), "snprintf") here

not sure why `!ret` is allowed?..

> +
> +       fdinfo =3D open(path, O_RDONLY);
> +       if (!ASSERT_GT(fdinfo, -1, "open fdinfo"))
> +               goto end;
> +
> +       ret =3D read(fdinfo, buf, sizeof(buf));
> +       if (!ASSERT_GT(ret, 0, "read fdinfo")) {
> +               ret =3D -EINVAL;
> +               goto end_file;
> +       }
> +
> +       begin =3D strstr(buf, "ifindex");
> +       if (!ASSERT_OK_PTR(begin, "find beginning of fdinfo info")) {
> +               ret =3D -EINVAL;
> +               goto end_file;
> +       }
> +
> +       ret =3D sscanf(begin, "ifindex:\t%u\n"
> +                           "parent:\t%u\n"
> +                           "handle:\t%u\n"
> +                           "priority:\t%u\n"
> +                           "gen_flags:\t%u\n",
> +                           &ifindex, &parent, &handle, &priority, &gen_f=
lags);
> +       if (!ASSERT_EQ(ret, 5, "sscanf fdinfo")) {
> +               ret =3D -EINVAL;
> +               goto end_file;
> +       }
> +
> +       ret =3D -EINVAL;
> +
> +#define X(a, b, c) (!ASSERT_EQ(a, b, #a " =3D=3D " #b) || !ASSERT_EQ(b, =
c, #b " =3D=3D " #c))
> +       if (X(info.tc.ifindex, ifindex, 1) ||
> +           X(info.tc.parent, parent,
> +             TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)) ||
> +           X(info.tc.handle, handle, 1) ||
> +           X(info.tc.gen_flags, gen_flags, TCA_CLS_FLAGS_NOT_IN_HW) ||
> +           X(info.tc.priority, priority, 1))
> +#undef X

This seems to be a bit too convoluted and over-engineered. Just
validate all the equalities unconditionally.

ASSERT_EQ(info.tc.ifindex, 1, "info.tc.ifindex");
ASSERT_EQ(ifindex, 1, "fdinfo.ifindex");
ASSERT_EQ(info.tc.parent, TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS),
"info.tc.parent");

and so on.

Then, you don't really need to propagate errors from
test_tc_bpf_link_info_api, because each ASSERT_EQ() marks the test (or
subtest) as failed, so you don't have to do that below in
test_tc_bpf_link.

> +               goto end_file;
> +
> +       ret =3D 0;
> +
> +end_file:
> +       close(fdinfo);
> +end:
> +       bpf_link__destroy(link);
> +       return ret;
> +}
> +
> +void test_tc_bpf_link(void)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex =3D LO_IFINDEX,
> +                           .attach_point =3D BPF_TC_INGRESS);
> +       struct test_tc_bpf *skel =3D NULL;
> +       bool hook_created =3D false;
> +       int ret;
> +
> +       skel =3D test_tc_bpf__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "test_tc_bpf__open_and_load"))
> +               return;
> +
> +       ret =3D bpf_tc_hook_create(&hook);
> +       if (ret =3D=3D 0)
> +               hook_created =3D true;
> +
> +       ret =3D ret =3D=3D -EEXIST ? 0 : ret;
> +       if (!ASSERT_OK(ret, "bpf_tc_hook_create(BPF_TC_INGRESS)"))
> +               goto end;
> +
> +       ret =3D test_tc_bpf_link_basic(&hook, skel->progs.cls);
> +       if (!ASSERT_OK(ret, "test_tc_bpf_link_basic"))
> +               goto end;
> +
> +       bpf_tc_hook_destroy(&hook);
> +
> +       hook.attach_point =3D BPF_TC_EGRESS;
> +       ret =3D test_tc_bpf_link_basic(&hook, skel->progs.cls);
> +       if (!ASSERT_OK(ret, "test_tc_bpf_link_basic"))
> +               goto end;
> +
> +       bpf_tc_hook_destroy(&hook);
> +
> +       ret =3D test_tc_bpf_link_netlink_interaction(&hook, skel->progs.c=
ls);
> +       if (!ASSERT_OK(ret, "test_tc_bpf_link_netlink_interaction"))
> +               goto end;
> +
> +       bpf_tc_hook_destroy(&hook);
> +
> +       ret =3D test_tc_bpf_link_update_ways(&hook, skel->progs.cls);
> +       if (!ASSERT_OK(ret, "test_tc_bpf_link_update_ways"))
> +               goto end;
> +
> +       bpf_tc_hook_destroy(&hook);
> +
> +       ret =3D test_tc_bpf_link_info_api(&hook, skel->progs.cls);
> +       if (!ASSERT_OK(ret, "test_tc_bpf_link_info_api"))

I was talking about this above, it's completely unnecessary and
redundant. Just complicates everything.

> +               goto end;
> +
> +end:
> +       if (hook_created) {
> +               hook.attach_point =3D BPF_TC_INGRESS | BPF_TC_EGRESS;
> +               bpf_tc_hook_destroy(&hook);
> +       }
> +       test_tc_bpf__destroy(skel);
> +}
> --
> 2.31.1
>
