Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D295C368689
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 20:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236889AbhDVSZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 14:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236752AbhDVSZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 14:25:07 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240ACC06174A;
        Thu, 22 Apr 2021 11:24:32 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id g38so52590117ybi.12;
        Thu, 22 Apr 2021 11:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MfrE6wI2+F1Lu7GMa4OdlJ/nbLn46XkmHbbsXfUYzWg=;
        b=Yga/eR6yaUEnUNX3MRQ1/cF+6GT33dHNMDQ6LY4DE/5Tr2q68L0ID+AEKTr15KbxSF
         r6ae9c3EL1sXpq0+RnOTEv4avROorfZ83HhN5m9n4BGYSZ0MyXQbGL5JEOlsTb1yyg61
         xV6Hd++xQyDmBSQBMl+x4ElRLgmc5MZ+z+SpgnreTU0/unTSOQrhlzcufeofC7l2cai2
         0dez9jcQa91dcAxQ6VK3HYnPS+T6SC1yeGUwIbupsVnZkejikxdYZcuEhmi4arV/Wpux
         p74GmxIGTlzPLGWOBpz8I/0hHh+FOp4MLA35um3ovMqyt/wOksxSLjCJ5FYQbsK5CMr5
         XMbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MfrE6wI2+F1Lu7GMa4OdlJ/nbLn46XkmHbbsXfUYzWg=;
        b=R+CxNvK5ADmCuxr7TGihgV7q0C16FnBstgSR/Z6XWKCMms57sLI3iG2lgnMFRXfAmn
         y3pqVUo3+NEn5PpW3kg/7E/gfgy+5d5pqzCu+fi1aS4wmpdyFehQmvXPvv8P+bOqWkmS
         g2PhBjYEpw3E7Gy9aK9xqwJsqUfkDPB/4I3N4sKV6iqTSursnaIFwS5jQXxpO5iwQcX0
         WJ25zHpOG1xRBYPxL+1IQA2udfeO3yQpch86lYHVLqK0lud9MhhbKU+E3ARVohMS1XWm
         N5FtpXk6GcQorePvJmxOSctahpq+Sn76izWCNU1+KpDXw2OfZB5nQ4rKtdLoH3VurUwM
         qEQw==
X-Gm-Message-State: AOAM531B/KuN1cqGCmtoUa/wZ00i9A7mItNWMdpix2FhrzjO2gKT+G7N
        zzjl05b0LP3uOTAkCvjarZVAoH+yVsq4C6llXaUOBTtx
X-Google-Smtp-Source: ABdhPJxL/o6Arev0t3cSufWh8eW1cB41AfLLR4+xMFemNqG1/W9OsjcnoUs+Z5cpJ0ZJN36hluuDZOO06jogFJ1H16o=
X-Received: by 2002:a25:9942:: with SMTP id n2mr7062527ybo.230.1619115871478;
 Thu, 22 Apr 2021 11:24:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-11-andrii@kernel.org>
 <c9f1cab3-2aba-bbfb-25bd-6d23f7191a5d@fb.com>
In-Reply-To: <c9f1cab3-2aba-bbfb-25bd-6d23f7191a5d@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Apr 2021 11:24:20 -0700
Message-ID: <CAEf4Bzai43dFxkZuh3FU0VrHZ008qT=GDDhhAsmOdgZuykkdTw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 10/17] libbpf: tighten BTF type ID rewriting
 with error checking
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 9:50 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> > It should never fail, but if it does, it's better to know about this rather
> > than end up with nonsensical type IDs.
>
> So this is defensive programming. Maybe do another round of
> audit of the callers and if you didn't find any issue, you
> do not need to check not-happening condition here?

It's far from obvious that this will never happen, because we do a
decently complicated BTF processing (we skip some types altogether
believing that they are not used, for example) and it will only get
more complicated with time. Just as there are "verifier bug" checks in
kernel, this prevents things from going wild if non-trivial bugs will
inevitably happen.

>
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >   tools/lib/bpf/linker.c | 9 +++++++++
> >   1 file changed, 9 insertions(+)
> >
> > diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
> > index 283249df9831..d5dc1d401f57 100644
> > --- a/tools/lib/bpf/linker.c
> > +++ b/tools/lib/bpf/linker.c
> > @@ -1423,6 +1423,15 @@ static int linker_fixup_btf(struct src_obj *obj)
> >   static int remap_type_id(__u32 *type_id, void *ctx)
> >   {
> >       int *id_map = ctx;
> > +     int new_id = id_map[*type_id];
> > +
> > +     if (*type_id == 0)
> > +             return 0;
> > +
> > +     if (new_id == 0) {
> > +             pr_warn("failed to find new ID mapping for original BTF type ID %u\n", *type_id);
> > +             return -EINVAL;
> > +     }
> >
> >       *type_id = id_map[*type_id];
> >
> >
