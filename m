Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A863212072
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgGBJ6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbgGBJ6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:58:22 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6433CC08C5C1;
        Thu,  2 Jul 2020 02:58:22 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id k18so13470126ybm.13;
        Thu, 02 Jul 2020 02:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q4Q8t7uL35sXBBCoF+XW2mk0lJ0GhsK/RQJ/uVmPN1Y=;
        b=JAQYYi7FuUZDX5GDNMeehGaTB6YVByiX8/Z2IOkFvMFiNU/13MA8qwVNa4ZS36kKr1
         RlIAznCGEiPOPo8DZukWbd4+/sMY+JXYlUd6PzL042Fxs58UsSSic+UY2WmjHWavgual
         FS+PaKIHUYiMO8hBurOd4E7FhF/u7iVVhhaGZNqB2NJXbsNDGuyC/Pz5a2mDfODXNVxi
         oW95lwxOLhJHy5Qovd6scaaUeUNUXWMjaTnEL7dCsHbj6dYBEVpRbvYBvwaKp1nkmli4
         ahVwEtUfxOTglZvgCEP/GDCALpArd1mxTNH4ez8bLJIkQ/FxRBybe0KTsHiuLRIgUql9
         vsmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q4Q8t7uL35sXBBCoF+XW2mk0lJ0GhsK/RQJ/uVmPN1Y=;
        b=FDEtWbODi2pZIAMoiPo85/MMHFZpabVX0WwU+hu6D0zCsc7W0vpzn99GWdBAYV0Eah
         h3msGFuRji/yGElYqTXqr2Twhx1myWA7IW94ZNXyDzcDrgIcczmtKothMGn3cW1ZXmmg
         1QdAdhLYqkmHbKJUfSK7DmvOgk18shXDNcknrkriYWMm6bv1/Avk+i268gfQ4jfqR8V5
         +1XU5T2tz8SylTJjbwY9CqHcPyyXjMvA5ZyKs74tJk23g+BrZF8SdQceMwt7EVhdkuDB
         0gW8E8p7dE0Y44c8Bab79oURw6nFN5rXdPtS3WZr67JRc8s/H8JrIY/NmIf4MlLEVl9y
         v9Bg==
X-Gm-Message-State: AOAM530mcNORXD9yz7JYvK3fu8v7iMGgEBnSrwCWrvaI/RzvXxrII1xm
        Rk7uulzwMAuuZ9oYF48ZRzu5suzH5tvFpvYqMQ==
X-Google-Smtp-Source: ABdhPJz13ndccTnHFXkGvxoOr5/ecUVDsDLiLXqJ4ALKVf9Z+Kto2x87ZHtWCLuLv536HeWa0R4MA4wlwAbUYv2xofQ=
X-Received: by 2002:a25:c507:: with SMTP id v7mr46475765ybe.306.1593683901579;
 Thu, 02 Jul 2020 02:58:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200702021646.90347-1-danieltimlee@gmail.com>
 <20200702021646.90347-3-danieltimlee@gmail.com> <CAEf4BzbtsHdRWWu__ri17e8PMRW-RcNc1g3okH8+U9RW=BVdig@mail.gmail.com>
In-Reply-To: <CAEf4BzbtsHdRWWu__ri17e8PMRW-RcNc1g3okH8+U9RW=BVdig@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Thu, 2 Jul 2020 18:58:01 +0900
Message-ID: <CAEKGpzhDjReJmmWXdtDct3KiuMzk127FdBbz4eM4jNakcsNxQQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] samples: bpf: refactor BPF map in map test
 with libbpf
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 1:26 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Jul 1, 2020 at 7:17 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > From commit 646f02ffdd49 ("libbpf: Add BTF-defined map-in-map
> > support"), a way to define internal map in BTF-defined map has been
> > added.
> >
> > Instead of using previous 'inner_map_idx' definition, the structure to
> > be used for the inner map can be directly defined using array directive.
> >
> >     __array(values, struct inner_map)
> >
> > This commit refactors map in map test program with libbpf by explicitly
> > defining inner map with BTF-defined format.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  samples/bpf/Makefile               |  2 +-
> >  samples/bpf/test_map_in_map_kern.c | 85 +++++++++++++++---------------
> >  samples/bpf/test_map_in_map_user.c | 53 +++++++++++++++++--
> >  3 files changed, 91 insertions(+), 49 deletions(-)
> >
>
> [...]
>
> > -       if (load_bpf_file(filename)) {
> > -               printf("%s", bpf_log_buf);
> > -               return 1;
> > +       prog = bpf_object__find_program_by_name(obj, "trace_sys_connect");
> > +       if (libbpf_get_error(prog)) {
>
> still wrong, just `if (!prog)`
>

Oops, my bad.
Will fix right away.

Thanks for your time and effort for the review.
Daniel.

> > +               printf("finding a prog in obj file failed\n");
> > +               goto cleanup;
> > +       }
> > +
>
> [...]
