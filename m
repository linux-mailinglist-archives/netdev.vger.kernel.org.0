Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8529446B059
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237363AbhLGCBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 21:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhLGCBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 21:01:35 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C312C061746;
        Mon,  6 Dec 2021 17:58:06 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id z5so51080337edd.3;
        Mon, 06 Dec 2021 17:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zNxM0TnCCI4+N6maswyUrhx++VXdxKrv5kQxG8am6OA=;
        b=PdHFYs54vb5yFj6SkIYzXSB/rjqxhLfr+2KG6nFwaGzGsrj9YYuSY0QJ5RDLsY/H2v
         Z8DyzvIGiLhBugZ2Nr2nK7NbwG37sDH0LK6pTtkfvpR9QiQcPHrl7L/JQICg8b8KF10A
         NJCXuRDfH26gq/spmWQJM8PKqp1uy88VEpyVtYCIZTcuf0mz083oBwQRds6efQ5ieEX6
         /gxguQ7TyvDoee6n2x6O1ROG2XYSv+ZklJxaBbfk/0A7B38vIRO4Gt/aZTCLrCPjHe20
         ZVSrAVEdtM8xq69R3qFJfZMXUg32OBdDUbr2ptu8+5H7pXiftoSqdA2jAvvIqvMm5E+e
         4zrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zNxM0TnCCI4+N6maswyUrhx++VXdxKrv5kQxG8am6OA=;
        b=uchfNaqsM781AXvvsDu/KGZoCqvCat+kARdiixReSQNnKlZrivLTJnRayqiRScWMwA
         rJN68mBpjMfk64teE1vcMeEixTu07ZRE7qq90huw7w67aeawnLQNipG/EHl5XVQIqcHH
         LTeO6BX6a0mWS0jdy6wHus57NcmjfEfadTcmlNBOzOm/0WHTkDLDzM2FdH0kdQzZSNyJ
         19ThNt30Gasob95Knk9w2sYkBNskez2/j61OFD8D5G1q23MfMunHJS6QuGOIi24HG9mw
         NJhBO8tcOIQ34fsEZr3MwdqjrVjZaVTi3Zr6LRubWRi1E61U47UzsXwL+vxwCT27sD2b
         QlRA==
X-Gm-Message-State: AOAM5314Z3XTMHep1TU36W7LG/6zkMh0WvwY2gBwvd5+ct+05JGrMT5W
        3FIboY0Y3C0zDe67r94KJQOgdJH38chr5gvlyqg=
X-Google-Smtp-Source: ABdhPJwWlKAxgTrspUiJGcPjdMYN2NmpMxed1+oRVH1Rs0AWVo752Qk/ja0lS/gDpCtg2Wvb8kBody5BeorTldPJBJs=
X-Received: by 2002:a05:6402:154:: with SMTP id s20mr4598396edu.148.1638842284779;
 Mon, 06 Dec 2021 17:58:04 -0800 (PST)
MIME-Version: 1.0
References: <20211205045041.129716-1-imagedong@tencent.com> <CAEf4BzbqhccBOSiBRehnf6V35u48N+f67tmgYUR_EJhpv6HptA@mail.gmail.com>
In-Reply-To: <CAEf4BzbqhccBOSiBRehnf6V35u48N+f67tmgYUR_EJhpv6HptA@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Tue, 7 Dec 2021 09:55:46 +0800
Message-ID: <CADxym3ZS7u12-hjbH2n9zw+FwLwbqx0YmE+SG+OAcJ0osVhMxw@mail.gmail.com>
Subject: Re: [PATCH] bpftool: add support of pin prog by name
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Cong Wang <cong.wang@bytedance.com>, liujian56@huawei.com,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 7, 2021 at 5:22 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Dec 4, 2021 at 8:51 PM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > For now, the command 'bpftool prog loadall' use section name as the
> > name of the pin file. However, once there are prog with the same
> > section name in ELF file, this command will failed with the error
> > 'File Exist'.
> >
> > So, add the support of pin prog by function name with the 'pinbyname'
> > argument.
> >
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
>
> Doesn't [0] do that already?
>
>   [0] https://patchwork.kernel.org/project/netdevbpf/patch/20211021214814.1236114-2-sdf@google.com/
>

Ops....Sorry, I didn't notice that patch :/

> >  tools/bpf/bpftool/prog.c | 7 +++++++
> >  tools/lib/bpf/libbpf.c   | 5 +++++
> >  tools/lib/bpf/libbpf.h   | 2 ++
> >  3 files changed, 14 insertions(+)
> >
> > diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> > index e47e8b06cc3d..74e0aaebfefc 100644
> > --- a/tools/bpf/bpftool/prog.c
> > +++ b/tools/bpf/bpftool/prog.c
> > @@ -1471,6 +1471,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
> >         unsigned int old_map_fds = 0;
> >         const char *pinmaps = NULL;
> >         struct bpf_object *obj;
> > +       bool pinbyname = false;
> >         struct bpf_map *map;
> >         const char *pinfile;
> >         unsigned int i, j;
> > @@ -1589,6 +1590,9 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
> >                                 goto err_free_reuse_maps;
> >
> >                         pinmaps = GET_ARG();
> > +               } else if (is_prefix(*argv, "pinbyname")) {
> > +                       pinbyname = true;
> > +                       NEXT_ARG();
> >                 } else {
> >                         p_err("expected no more arguments, 'type', 'map' or 'dev', got: '%s'?",
> >                               *argv);
> > @@ -1616,6 +1620,9 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
> >                                 goto err_close_obj;
> >                 }
> >
> > +               if (pinbyname)
> > +                       bpf_program__set_pinname(pos,
> > +                                                (char *)bpf_program__name(pos));
> >                 bpf_program__set_ifindex(pos, ifindex);
> >                 bpf_program__set_type(pos, prog_type);
> >                 bpf_program__set_expected_attach_type(pos, expected_attach_type);
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index f6faa33c80fa..e8fc1d0fe16e 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -8119,6 +8119,11 @@ void bpf_program__set_ifindex(struct bpf_program *prog, __u32 ifindex)
> >         prog->prog_ifindex = ifindex;
> >  }
> >
> > +void bpf_program__set_pinname(struct bpf_program *prog, char *name)
> > +{
> > +       prog->pin_name = name;
>
> BPF maps have bpf_map__set_pin_path(), setting a full path is more
> flexible approach, I think, so if we had to do something here, it's
> better to add bpf_program__set_ping_path().

Yeah, I think it's a good idea. I'll do something about it.

Thanks!
Menglong Dong

>
>
> > +}
> > +
> >  const char *bpf_program__name(const struct bpf_program *prog)
> >  {
> >         return prog->name;
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index 4ec69f224342..107cf736c2bb 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -216,6 +216,8 @@ LIBBPF_API int bpf_program__set_priv(struct bpf_program *prog, void *priv,
> >  LIBBPF_API void *bpf_program__priv(const struct bpf_program *prog);
> >  LIBBPF_API void bpf_program__set_ifindex(struct bpf_program *prog,
> >                                          __u32 ifindex);
> > +LIBBPF_API void bpf_program__set_pinname(struct bpf_program *prog,
> > +                                        char *name);
> >
> >  LIBBPF_API const char *bpf_program__name(const struct bpf_program *prog);
> >  LIBBPF_API const char *bpf_program__section_name(const struct bpf_program *prog);
> > --
> > 2.30.2
> >
