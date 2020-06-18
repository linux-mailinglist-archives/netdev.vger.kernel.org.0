Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C483A1FFA8A
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 19:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgFRRvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 13:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728137AbgFRRvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 13:51:37 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD36C06174E;
        Thu, 18 Jun 2020 10:51:37 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 205so6436691qkg.3;
        Thu, 18 Jun 2020 10:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ys5CnaVKiZ7UIeGjVEj5eP6h3FjBhlvi3mOm/poeays=;
        b=bbZqDzy+VGzD9qFkd0z3+g06zLkRxmSqsmME+vqpz1pLRwv5so3ZfPJmx8qC7tc42A
         ZoKfxNROgf7jHoyL1+vpg4HzZm9TLDLXtUXJdyxrKVuXYNaS8nrCjlHe9gb/eHkgWHW4
         6rX17yCwtO5EsR7kJZcu19udM70TfF6SPmn5e4HvuabSGmtwh5Bkio5Gasx5zkw8h1Hk
         lhJ5wfjAfrC7Q8Ms6MRs5N5A6BGAiGWQkrQLSByksCqzHbsJuz9s4A6ywtqieLu4WiZB
         vIWSa3TndAd5fAPj4oGsTi9SAWG5n8V7+QoUTMqplFcLTPd2rcsZYZHufgoq7bQN+JBW
         tPLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ys5CnaVKiZ7UIeGjVEj5eP6h3FjBhlvi3mOm/poeays=;
        b=AuiltlRt2xwfgB4S3KWG5Uv229xn2lXxTaeuwruXi3It5WSCdfjhE082td5LrnTz6+
         XDhoZcCcwK//PwjCU42B5OME6bFlAjFqP/1nzbUJc2Udss1qKCFnxjsPbco08Ckd6IjD
         GVcKnHELWz6KnkZnbEFTgZvmTdcpChtO27Uz8fQMh26rFFHT5jxXsoILbz9BMb1PId9P
         hNLlGzTcdnnhOB0DyJjdm/Cwnzs7EHnjsrM3bCUMdNK7OJMVJmvuZsOI8wdcJ3dLUy+L
         vAsEqOfM047s6SXZgnM05jgW3YnlbqddSm+VN1Xj1ZwMdHBEDYfQlFl86YERxdjT1W/N
         b6rA==
X-Gm-Message-State: AOAM5317OstBNG9vVuWfWK1SHYbLjYBkYb5/z77hh683pnlzfInBKngZ
        5sq9shy/lRl/ULojvVdxTfvFqqXe8BQjSkR+Wec=
X-Google-Smtp-Source: ABdhPJz7sZzJk9AL5m9PxlNGhJlF1W/bRV21+0w9JZyNvNIodW9+9bt0WH6HAvSOmrQBQw+VQzErWBlDs99c30Q7BSw=
X-Received: by 2002:a37:a89:: with SMTP id 131mr33969qkk.92.1592502696279;
 Thu, 18 Jun 2020 10:51:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200617161832.1438371-1-andriin@fb.com> <20200617161832.1438371-2-andriin@fb.com>
 <CA+khW7i2vjHuqExnkgAYMeHe9e556pUccjZXti3DxuTjPjiQQQ@mail.gmail.com>
In-Reply-To: <CA+khW7i2vjHuqExnkgAYMeHe9e556pUccjZXti3DxuTjPjiQQQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 10:51:25 -0700
Message-ID: <CAEf4BzZzi8CJ=YWxcqVwQLu6uJvz556qZcryOjhWD59m1q9yCQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/9] libbpf: generalize libbpf externs support
To:     Hao Luo <haoluo@google.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 12:38 AM Hao Luo <haoluo@google.com> wrote:
>
> On Wed, Jun 17, 2020 at 9:21 AM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Switch existing Kconfig externs to be just one of few possible kinds of more
> > generic externs. This refactoring is in preparation for ksymbol extern
> > support, added in the follow up patch. There are no functional changes
> > intended.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
>
> [...]
>
> > @@ -5572,30 +5635,33 @@ static int bpf_object__resolve_externs(struct bpf_object *obj,
> >  {
> >         bool need_config = false;
> >         struct extern_desc *ext;
> > +       void *kcfg_data;
> >         int err, i;
> > -       void *data;
> >
> >         if (obj->nr_extern == 0)
> >                 return 0;
> >
> > -       data = obj->maps[obj->kconfig_map_idx].mmaped;
> > +       if (obj->kconfig_map_idx >= 0)
> > +               kcfg_data = obj->maps[obj->kconfig_map_idx].mmaped;
> >
> >         for (i = 0; i < obj->nr_extern; i++) {
> >                 ext = &obj->externs[i];
> >
> > -               if (strcmp(ext->name, "LINUX_KERNEL_VERSION") == 0) {
> > -                       void *ext_val = data + ext->data_off;
> > +               if (ext->type == EXT_KCFG &&
> > +                   strcmp(ext->name, "LINUX_KERNEL_VERSION") == 0) {
> > +                       void *ext_val = kcfg_data + ext->kcfg.data_off;
> >                         __u32 kver = get_kernel_version();
> >
> >                         if (!kver) {
> >                                 pr_warn("failed to get kernel version\n");
> >                                 return -EINVAL;
> >                         }
> > -                       err = set_ext_value_num(ext, ext_val, kver);
> > +                       err = set_kcfg_value_num(ext, ext_val, kver);
> >                         if (err)
> >                                 return err;
> > -                       pr_debug("extern %s=0x%x\n", ext->name, kver);
> > -               } else if (strncmp(ext->name, "CONFIG_", 7) == 0) {
> > +                       pr_debug("extern (kcfg) %s=0x%x\n", ext->name, kver);
> > +               } else if (ext->type == EXT_KCFG &&
> > +                          strncmp(ext->name, "CONFIG_", 7) == 0) {
> >                         need_config = true;
> >                 } else {
> >                         pr_warn("unrecognized extern '%s'\n", ext->name);
>
> Ah, we need to initialize kcfg_data, otherwise the compiler will give
> a warning on potentially uninitialized data.

yep, good catch
