Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D394F26CC04
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbgIPUiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728301AbgIPUh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 16:37:56 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D0EC06174A;
        Wed, 16 Sep 2020 13:37:55 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id x10so6328668ybj.13;
        Wed, 16 Sep 2020 13:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KF1Vj/GrUHdC3Iej6R3OIIzN4HD/yQo2mo/psmlHkQs=;
        b=lPBC0D/6M+E7UW1gXJNwCWVc0TOQrFgUrI01rXU0JwXh4DsbMs8ZFXye5PN3CtGkzq
         HoEat7T7934QMRVxZ2imxROpLu60PSYo3L4j/Mxh3YRa+BP52w7iZD3r+sSlv+ZNkcye
         c/zDPlHrdpe9NiAqUzVU4A4d4p5eL0DNKzpRRWq+xDkQ4EvkT2okzfWRT3pFRGXhqufX
         ku8q7OeSC+EcfTJ6XlE/4MeDBX/IWjz46V6BxaeKHojMXJpyNhPluFLeOmrbxa8JFEte
         m89sd5fvy0nszt52VuMQPYatkHJgU8inyeDED//8WhB1SqWiQhTmtvOwqrUQ07AQ5pXQ
         ikKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KF1Vj/GrUHdC3Iej6R3OIIzN4HD/yQo2mo/psmlHkQs=;
        b=XG1L1+wkuER4AqMrijeLiItMTKpO5FExAXX37+dyhsomB508fNCaS2R2tKzKSWZNg/
         OCODGHA7ey4BsiESnrUCaPySpMzb9pX/QGoBwt8ScjZnvSgscJRPO6KedvFMsszHw9J4
         0cLSpemJVZH9aY0PGDcH6bnGgckcMcKgvVn5ZgtHHUl+iC9DPMnoDWvmJeK/Remy3BtM
         MFshJd3g2gx0ANha6/ez5hPokF97JjkZdF0orTUr4gz4CF//t7eFi/3HqjIxLbAGBE2U
         RwnLGs8BKNTwDJ50Gnk9QNdApPuDt9IexwyU7TSz/8fzUkecNn+K33IdmO8UeF3n40xj
         zIXg==
X-Gm-Message-State: AOAM533shJ8mbg9hVAhjWp2i6DRmoci5wA2CzofFwBej/HaEMZxnDSVz
        BIPjSHpbflCCql0THXsY5Q2YWHZE0V2LQurdbSk=
X-Google-Smtp-Source: ABdhPJzoS4rJ5sZ5XZPnY306pGr4ee8GMKI2s1Sz4Ja6yEt531ttO2inkQp81qjE+RkRLcBdnozx+qxNnTXuCp6CqUs=
X-Received: by 2002:a25:8541:: with SMTP id f1mr6403037ybn.230.1600288675003;
 Wed, 16 Sep 2020 13:37:55 -0700 (PDT)
MIME-Version: 1.0
References: <160017005691.98230.13648200635390228683.stgit@toke.dk> <160017006352.98230.621859348254499900.stgit@toke.dk>
In-Reply-To: <160017006352.98230.621859348254499900.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Sep 2020 13:37:44 -0700
Message-ID: <CAEf4BzZx33sqDd2WU2j+Ht_njn2qfcV1C0ginPBde+wj8rROeQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 6/8] libbpf: add support for freplace
 attachment in bpf_link_create
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 5:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This adds support for supplying a target btf ID for the bpf_link_create()
> operation, and adds a new bpf_program__attach_freplace() high-level API f=
or
> attaching freplace functions with a target.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/bpf.c      |    1 +
>  tools/lib/bpf/bpf.h      |    3 ++-
>  tools/lib/bpf/libbpf.c   |   24 ++++++++++++++++++------
>  tools/lib/bpf/libbpf.h   |    3 +++
>  tools/lib/bpf/libbpf.map |    1 +
>  5 files changed, 25 insertions(+), 7 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 82b983ff6569..e928456c0dd6 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -599,6 +599,7 @@ int bpf_link_create(int prog_fd, int target_fd,
>         attr.link_create.iter_info =3D
>                 ptr_to_u64(OPTS_GET(opts, iter_info, (void *)0));
>         attr.link_create.iter_info_len =3D OPTS_GET(opts, iter_info_len, =
0);
> +       attr.link_create.target_btf_id =3D OPTS_GET(opts, target_btf_id, =
0);
>
>         return sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
>  }
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index 015d13f25fcc..f8dbf666b62b 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -174,8 +174,9 @@ struct bpf_link_create_opts {
>         __u32 flags;
>         union bpf_iter_link_info *iter_info;
>         __u32 iter_info_len;
> +       __u32 target_btf_id;
>  };
> -#define bpf_link_create_opts__last_field iter_info_len
> +#define bpf_link_create_opts__last_field target_btf_id
>
>  LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
>                                enum bpf_attach_type attach_type,
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 550950eb1860..165131c73f40 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -9322,12 +9322,14 @@ static struct bpf_link *attach_iter(const struct =
bpf_sec_def *sec,
>
>  static struct bpf_link *
>  bpf_program__attach_fd(struct bpf_program *prog, int target_fd,
> -                      const char *target_name)
> +                      int target_btf_id, const char *target_name)
>  {
>         enum bpf_attach_type attach_type;
>         char errmsg[STRERR_BUFSIZE];
>         struct bpf_link *link;
>         int prog_fd, link_fd;
> +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
> +                           .target_btf_id =3D target_btf_id);
>
>         prog_fd =3D bpf_program__fd(prog);
>         if (prog_fd < 0) {
> @@ -9340,8 +9342,12 @@ bpf_program__attach_fd(struct bpf_program *prog, i=
nt target_fd,
>                 return ERR_PTR(-ENOMEM);
>         link->detach =3D &bpf_link__detach_fd;
>
> -       attach_type =3D bpf_program__get_expected_attach_type(prog);
> -       link_fd =3D bpf_link_create(prog_fd, target_fd, attach_type, NULL=
);
> +       if (bpf_program__get_type(prog) =3D=3D BPF_PROG_TYPE_EXT)
> +               attach_type =3D BPF_TRACE_FREPLACE;

doing this unconditionally will break an old-style freplace without
target_fd/btf_id on older kernels. Safe and simple way would be to
continue using raw_tracepoint_open when there is no target_fd/btf_id,
and use LINK_CREATE for newer stuff. Alternatively, you'd need to do
feature detection, but it's still would be nice to handle old-style
attach through raw_tracepoint_open for bpf_program__attach_freplace.

so I suggest leaving bpf_program__attach_fd() as is and to create a
custom bpf_program__attach_freplace() implementation.

> +       else
> +               attach_type =3D bpf_program__get_expected_attach_type(pro=
g);
> +
> +       link_fd =3D bpf_link_create(prog_fd, target_fd, attach_type, &opt=
s);
>         if (link_fd < 0) {
>                 link_fd =3D -errno;
>                 free(link);
> @@ -9357,19 +9363,25 @@ bpf_program__attach_fd(struct bpf_program *prog, =
int target_fd,
>  struct bpf_link *
>  bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
>  {
> -       return bpf_program__attach_fd(prog, cgroup_fd, "cgroup");
> +       return bpf_program__attach_fd(prog, cgroup_fd, 0, "cgroup");
>  }
>
>  struct bpf_link *
>  bpf_program__attach_netns(struct bpf_program *prog, int netns_fd)
>  {
> -       return bpf_program__attach_fd(prog, netns_fd, "netns");
> +       return bpf_program__attach_fd(prog, netns_fd, 0, "netns");
>  }
>
>  struct bpf_link *bpf_program__attach_xdp(struct bpf_program *prog, int i=
findex)
>  {
>         /* target_fd/target_ifindex use the same field in LINK_CREATE */
> -       return bpf_program__attach_fd(prog, ifindex, "xdp");
> +       return bpf_program__attach_fd(prog, ifindex, 0, "xdp");
> +}
> +
> +struct bpf_link *bpf_program__attach_freplace(struct bpf_program *prog,
> +                                             int target_fd, int target_b=
tf_id)
> +{
> +       return bpf_program__attach_fd(prog, target_fd, target_btf_id, "fr=
eplace");
>  }
>
>  struct bpf_link *
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index a750f67a23f6..ce5add9b9203 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -261,6 +261,9 @@ LIBBPF_API struct bpf_link *
>  bpf_program__attach_netns(struct bpf_program *prog, int netns_fd);
>  LIBBPF_API struct bpf_link *
>  bpf_program__attach_xdp(struct bpf_program *prog, int ifindex);
> +LIBBPF_API struct bpf_link *
> +bpf_program__attach_freplace(struct bpf_program *prog,
> +                            int target_fd, int target_btf_id);

maybe a const char * function name instead of target_btf_id would be a
nicer API? Users won't have to deal with fetching target prog's BTF,
searching it, etc. That's all pretty straightforward for libbpf to do,
leaving users with more natural and simpler API.

>
>  struct bpf_map;
>
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 92ceb48a5ca2..3cc2c42f435d 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -302,6 +302,7 @@ LIBBPF_0.1.0 {
>
>  LIBBPF_0.2.0 {
>         global:
> +               bpf_program__attach_freplace;
>                 bpf_program__section_name;
>                 perf_buffer__buffer_cnt;
>                 perf_buffer__buffer_fd;
>
