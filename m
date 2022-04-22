Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5936350C330
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbiDVWir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiDVWi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:38:28 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E132E7090;
        Fri, 22 Apr 2022 14:46:12 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id y11so5852699ilp.4;
        Fri, 22 Apr 2022 14:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nkDUZxbdA+hWXU65q6VAaFr0TzgsldQALWu4ZWoYD0M=;
        b=bJee/rEr6BUaMfw59k5TozahkYw7co4nWcHIgP7F/BLY3AQxJmRDWGyNmCqMgHqNnd
         Flea4d5Up76qniaRAJ4C2k/8sMCcT3ykbdFE9NS1awQ+KBF4SAfKVcz6OM7j9P52Ay9K
         LRuKC2wwfBFW+3nlRGuKNTjUY7noZf0V4lL3zErNRVJ6tCkYZ1xSvDr4POoVqIbAfrv2
         v4YeKLBVoeDDntDlhumrNv5qsXIS8IXCIElGtvrMcmWpLMMymhHA63TPkjazsM4RiYd3
         zvaBuErlj2qcOgVugdIdb5az3E5zUktuiO3B3D7lXFqXw14jX2AbQaJQ3I7NBMnnb0xq
         57zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nkDUZxbdA+hWXU65q6VAaFr0TzgsldQALWu4ZWoYD0M=;
        b=YDPmwEnGEB6xZgIbUgHMmVBBk7BBR+YXdOlpF3B8LUn6zwrn2j0RVvf2YkMyxISGSS
         kZrlwXBPb1z1lMbrraHsKg9RoPucS8qJIiE/Pe7pTuTh6cooNUeh3a4vLD2zJYa33z5J
         KWT+QFkZJ/Y/b2yLp0ox0N71Vs04gBBlbeUYrR8MhnTXfBAFzCc/eN1NVbo59htmhFHX
         Bgvz3LORsRm6atlVu0VMIMXL+DyqDS+QcX41BnsDymcf4jxDYljUsIMKu2vQ1QcVuPKl
         j/HwBhz+MMCryin1HraSgRwvmgXe/krXsLY7hLjKbMKDEzJhxanjFbQJLTMMUKPDF/rC
         qMrg==
X-Gm-Message-State: AOAM5337vw9s6gfvkAG37ElAkWYHdQMP+ExE2ig5MllWVUBYCWgMwkSD
        yzC9v2o9ryDHPEybDX/qOxC4uAL1z6HVyq25Uhg=
X-Google-Smtp-Source: ABdhPJzNGJm4jcKbD/R3aBuDb2M63BaNg5fLvioWsh96gpit7/9Ok02JoYIVS32OS5cVounn+0kxBToAAOEfAI254hY=
X-Received: by 2002:a92:cd8d:0:b0:2cd:81ce:79bd with SMTP id
 r13-20020a92cd8d000000b002cd81ce79bdmr221037ilb.252.1650663972085; Fri, 22
 Apr 2022 14:46:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220421130056.2510372-1-cuigaosheng1@huawei.com>
 <CAEf4Bza3inoAHsS0w=nKXNgxyFqzPXJVyDHq03Foody6Vgp7=Q@mail.gmail.com> <60b4e208-efed-c2fb-d1e0-125e5409c861@huawei.com>
In-Reply-To: <60b4e208-efed-c2fb-d1e0-125e5409c861@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 Apr 2022 14:46:01 -0700
Message-ID: <CAEf4BzY3j8=uNvvwZXsFEANR84bXMWY2OH+eZi_sSsiLutYhVQ@mail.gmail.com>
Subject: Re: [PATCH -next] libbpf: Add additional null-pointer checking in make_parent_dir
To:     cuigaosheng <cuigaosheng1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        gongruiqi1@huawei.com, wangweiyang2@huawei.com
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

On Thu, Apr 21, 2022 at 7:55 PM cuigaosheng <cuigaosheng1@huawei.com> wrote=
:
>
> This email adjusts the code format.
>
> I don't understand why we don't check path for NULL, bpf_link__pin is an
> external
> interface, It will be called by external functions and provide input
> parameters,

that external interface expects non-NULL string as input argument,
which is a default throughout libbpf's API. You will get SIGSEGV in
lots of cases if you pass NULL where you are not supposed to, e.g.,
bpf_object__open_file() and many others. It doesn't mean that libbpf
should check any pointer argument for NULL.

You can argue that strdup(NULL) shouldn't crash but it doesn't. It's
because strdup() has a contract that it shouldn't be passed NULL. So
is the case here.


> for example in samples/bpf/hbm.c:
>
> > 201         link =3D bpf_program__attach_cgroup(bpf_prog, cg1);
> > 202         if (libbpf_get_error(link)) {
> > 203                 fprintf(stderr, "ERROR: bpf_program__attach_cgroup
> > failed\n");
> > 204                 goto err;
> > 205         }
> > 206
> > 207         sprintf(cg_pin_path, "/sys/fs/bpf/hbm%d", cg_id);
> > 208         rc =3D bpf_link__pin(link, cg_pin_path);
> > 209         if (rc < 0) {
> > 210                 printf("ERROR: bpf_link__pin failed: %d\n", rc);
> > 211                 goto err;
> > 212         }
>
> if cg_pin_path is NULL, strdup(NULL) will trigger a segmentation fault in
> make_parent_dir, I think we should avoid this and add null-pointer checki=
ng
> for path, just like check_path:
> >  7673 static int check_path(const char *path)
> >  7674 {
> >  7675         char *cp, errmsg[STRERR_BUFSIZE];
> >  7676         struct statfs st_fs;
> >  7677         char *dname, *dir;
> >  7678         int err =3D 0;
> >  7679
> >  7680         if (path =3D=3D NULL)
> >  7681                 return -EINVAL;
> >  7682
> >  7683         dname =3D strdup(path);
> >  7684         if (dname =3D=3D NULL)
> >  7685                 return -ENOMEM;
> >  7686
> >  7687         dir =3D dirname(dname);
> >  7688         if (statfs(dir, &st_fs)) {
> >  7689                 cp =3D libbpf_strerror_r(errno, errmsg,
> > sizeof(errmsg));
> >  7690                 pr_warn("failed to statfs %s: %s\n", dir, cp);
> >  7691                 err =3D -errno;
> >  7692         }
> >  7693         free(dname);
> >  7694
> >  7695         if (!err && st_fs.f_type !=3D BPF_FS_MAGIC) {
> >  7696                 pr_warn("specified path %s is not on BPF FS\n",
> > path);
> >  7697                 err =3D -EINVAL;
> >  7698         }
> >  7699
> >  7700         return err;
> >  7701 }
>
> Thanks.
>
>
> =E5=9C=A8 2022/4/22 0:55, Andrii Nakryiko =E5=86=99=E9=81=93:
> > On Thu, Apr 21, 2022 at 6:01 AM Gaosheng Cui <cuigaosheng1@huawei.com> =
wrote:
> >> The make_parent_dir is called without null-pointer checking for path,
> >> such as bpf_link__pin. To ensure there is no null-pointer dereference
> >> in make_parent_dir, so make_parent_dir requires additional null-pointe=
r
> >> checking for path.
> >>
> >> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> >> ---
> >>   tools/lib/bpf/libbpf.c | 3 +++
> >>   1 file changed, 3 insertions(+)
> >>
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index b53e51884f9e..5786e6184bf5 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -7634,6 +7634,9 @@ static int make_parent_dir(const char *path)
> >>          char *dname, *dir;
> >>          int err =3D 0;
> >>
> >> +       if (path =3D=3D NULL)
> >> +               return -EINVAL;
> >> +
> > API contract is that path shouldn't be NULL. Just like we don't check
> > link, obj, prog for NULL in every single API, I don't think we need to
> > do it here, unless I'm missing something?
> >
> >>          dname =3D strdup(path);
> >>          if (dname =3D=3D NULL)
> >>                  return -ENOMEM;
> >> --
> >> 2.25.1
> >>
> > .
