Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E72134BE3F
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 20:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhC1S3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 14:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhC1S3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 14:29:41 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF95C061756;
        Sun, 28 Mar 2021 11:29:39 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id a143so11453094ybg.7;
        Sun, 28 Mar 2021 11:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2SEim9L76qB4slGy1DZ0qon+JPi0q47C05XROFWg+cs=;
        b=S3NSFY+EtOn+7dAdEZSgKc5tMiq4Kc6cGkQdw5s3cmBEKQRBRIeuuv7kUAmlNygwRZ
         QtYSExPMgeSXuazlmVd0hARjX8gNaMr3ou2OYX9ZtsRZqq8My3rj/P/+1ioMd4Ozb93J
         iyWBx/VvJqPlCguBYTWXTXrYloS7b8vzdvL+rOqh9fWXEE7jwi+ah6XnKprmSHSgTKrI
         dsiyhlJ4D0KOmPuWlS5P9K2qvWHnDZRM7Y7Qm+T/eS5qIA7z4/ca4yWUOKV2eeNlkSuz
         VpBCRNTg54KIUUgDmZbag9/mFvEHQs9mSfGVnqVxEP3Vlk4zZV9d2TN/PyDQDSug5p6J
         brDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2SEim9L76qB4slGy1DZ0qon+JPi0q47C05XROFWg+cs=;
        b=LYrbRZRefmxcLLs8cSiRqGlfn76DuYMRGysc9X/aGvc3bGHav96eMElyCHoAm2A7ef
         gaZuFalcluN5O97nvtT6ARb6QKSokV42g+uSEP7ld0mhixnwHewGH057ZcT+qRfs77H0
         vvJmtmeQz5Jp2Pn9P+KLTvLiTrPvf3yoNMrMgq5cv/5BiYhmVDLIucrYO0AdruVmSZjj
         1fb7eqMuKXFZ/pNRloBRqQdCC9YHTU0IdFk64MqQJStaGb2ugIZGJjfeA6b6qREcSaS2
         V1FAkBihsEfXTkzKZ053hSIMeQ3VLaDDXhmeZ2uV7VBt4g1JiTScbxrWR19JvVK26zOb
         tUNw==
X-Gm-Message-State: AOAM530JnjkQ+bln9GQ3R+6+HzJ7tgTwdV+bXIUb+rk3IdIKcFpFXrVo
        SIq6g1KiN8jfaK44EcxuxkaOgrcs+S7n/EqA2qE=
X-Google-Smtp-Source: ABdhPJwiv3sLvUZTSAGtL6zbGbFxJ43psRL2irbOpeey5P9JDraX5z/wTTWXqTUERrOB01w7PGfe0DntAbPEmkCBNaM=
X-Received: by 2002:a25:ab03:: with SMTP id u3mr27617987ybi.347.1616956178370;
 Sun, 28 Mar 2021 11:29:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210318194036.3521577-1-andrii@kernel.org> <20210318194036.3521577-8-andrii@kernel.org>
 <YFTQExmhNhMcmNOb@krava> <CAEf4BzYKassG0AP372Q=Qsd+qqy7=YGe2XTXR4zG0c5oQ7Nkeg@mail.gmail.com>
 <YFT0Q+mVbTEI1rem@krava> <YGBwmlQTDUodxM0J@krava>
In-Reply-To: <YGBwmlQTDUodxM0J@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 28 Mar 2021 11:29:27 -0700
Message-ID: <CAEf4BzbeCOU+ScbycxUGwbmKhqjU5EWBj=dry-GXVOwOXe86ag@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 07/12] libbpf: add BPF static linker BTF and
 BTF.ext support
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 5:03 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Fri, Mar 19, 2021 at 07:58:13PM +0100, Jiri Olsa wrote:
> > On Fri, Mar 19, 2021 at 11:39:01AM -0700, Andrii Nakryiko wrote:
> > > On Fri, Mar 19, 2021 at 9:23 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > On Thu, Mar 18, 2021 at 12:40:31PM -0700, Andrii Nakryiko wrote:
> > > >
> > > > SNIP
> > > >
> > > > > +
> > > > > +     return NULL;
> > > > > +}
> > > > > +
> > > > > +static int linker_fixup_btf(struct src_obj *obj)
> > > > > +{
> > > > > +     const char *sec_name;
> > > > > +     struct src_sec *sec;
> > > > > +     int i, j, n, m;
> > > > > +
> > > > > +     n = btf__get_nr_types(obj->btf);
> > > >
> > > > hi,
> > > > I'm getting bpftool crash when building tests,
> > > >
> > > > looks like above obj->btf can be NULL:
> > >
> > > I lost if (!obj->btf) return 0; somewhere along the rebases. I'll send
> > > a fix shortly. But how did you end up with selftests BPF objects built
> > > without BTF?
> >
> > no idea.. I haven't even updated llvm for almost 3 days now ;-)
>
> sorry for late follow up on this, and it's actually forgotten empty
> object in progs directory that was causing this
>
> I wonder we should add empty object like below to catch these cases,

well, feel free to chime in on [0] then

  [0] https://patchwork.kernel.org/project/netdevbpf/patch/20210319205909.1748642-4-andrii@kernel.org/

> because there's another place that bpftool is crashing on with it
>
> I can send full patch for that if you think it's worth having

sure, but see my comment below

>
> jirka
>
>
> ---
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 7aad78dbb4b4..aecb6ca52bce 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3165,6 +3165,9 @@ static int add_dummy_ksym_var(struct btf *btf)
>         const struct btf_var_secinfo *vs;
>         const struct btf_type *sec;
>
> +       if (!btf)
> +               return 0;
> +

add_dummy_ksym_var() shouldn't be called, if there is no btf, so the
fix should be outside of this fix.

>         sec_btf_id = btf__find_by_name_kind(btf, KSYMS_SEC,
>                                             BTF_KIND_DATASEC);
>         if (sec_btf_id < 0)
> diff --git a/tools/testing/selftests/bpf/progs/empty.c b/tools/testing/selftests/bpf/progs/empty.c
> new file mode 100644
> index 000000000000..e69de29bb2d1
>
