Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2C33671B8
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244903AbhDURrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243182AbhDURrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 13:47:31 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A140BC06174A;
        Wed, 21 Apr 2021 10:46:58 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 82so48188312yby.7;
        Wed, 21 Apr 2021 10:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ajNoWf0uybliHenzMMDZ39qNU3aYx9OE6nsIWmk4T38=;
        b=oVB3+vFixU99UCiF6XnpitUF8W0P9v77MEoqoT2oO7E5nkOUcpVwFOgcaf4mfTYUFb
         TQIKeTxxFFgevrIcpvh3EfIy/PMEYoeA6WbW64MYXAHkbFmUowHTK5mMJReOdeJqMc3k
         8yEw2aRwhZKgch8wc5Gjfk5ph07Sak++P+BZpU6XGXjmNijUNF/KqjAcDdVXkVZYA63M
         xiI8Rcc0cTU8OporYp4TFSkwZKKygsIxs3/9iJ5FcOlM6J1ekG9P2mTnQ4rJNckQvWpa
         ExN3fLe4TuXWX6albXUB9ZkKBU2CcibKklsYGhSwyC55sBRjwbu1symT7XS83Xt2qS6N
         M96A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ajNoWf0uybliHenzMMDZ39qNU3aYx9OE6nsIWmk4T38=;
        b=jkFEzcwK7qVnSg2DGERPW7wdqd/Ba4aX2qay/oEprIECkDQHeiV7B+vXxSNluGM4et
         Pq0bAPyHmsxwZDFYz5ewKHiURwZVNsGQql9r8QGwH/NjhHwuCSpPsxBbxfS98LOzo5dJ
         ZgFRi0dW3ROllnSOppDP5Un4zm5xsmddNyIx0k82affIxaXfxGhIwXFr3kvnkM53T/cD
         xOxqqGjEBTFJqRpvIpl1nECN4zz6ceJ0MtA4uJXxOG3qzA4m+t74Sje+wovP0wBie/M0
         693I1WCQCWA1NgtePuti4Eqh7+XI0YifaVXcCnSD/aSqlM9BPZ6nAwCSHoqP6nR5Vxi5
         /lDA==
X-Gm-Message-State: AOAM5327ZiiO86rTzz92OSFMkCdL8HP/4N5xo2HFGKFxjLK4UXezsCjP
        73+XSPGWrSxqqM4g48h1ayCfKZzBqm1mHugpsKA=
X-Google-Smtp-Source: ABdhPJyScZ0/qx0XK1tsey3tOC1tREPx/Tks3oNOdx/ERLEo8gtZWubFflLR5f9cTOC2OiqTvzBkY3JoR3IaMJqHbxA=
X-Received: by 2002:a25:dc46:: with SMTP id y67mr34112320ybe.27.1619027217971;
 Wed, 21 Apr 2021 10:46:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
 <20210417033224.8063-14-alexei.starovoitov@gmail.com> <a63a54c3-e04a-e557-3fe1-dacfece1e359@fb.com>
 <20210421044643.mqb4lnbqtgxmkcl4@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210421044643.mqb4lnbqtgxmkcl4@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 21 Apr 2021 10:46:46 -0700
Message-ID: <CAEf4BzY6AQznGOyfp1j54pp-9pJ_SpWZZo6GWMENnDng8aizig@mail.gmail.com>
Subject: Re: [PATCH bpf-next 13/15] libbpf: Generate loader program out of BPF
 ELF file.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 9:46 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Apr 20, 2021 at 06:34:11PM -0700, Yonghong Song wrote:
> > >
> > > kconfig, typeless ksym, struct_ops and CO-RE are not supported yet.
> >
> > Beyond this, currently libbpf has a lot of flexibility between prog open
> > and load, change program type, key/value size, pin maps, max_entries, reuse
> > map, etc. it is worthwhile to mention this in the cover letter.
> > It is possible that these changes may defeat the purpose of signing the
> > program though.
>
> Right. We'd need to decide which ones are ok to change after signature
> verification. I think max_entries gotta be allowed, since tools
> actively change it. The other fields selftest change too, but I'm not sure
> it's a good thing to allow for signed progs. TBD.
>

[...]

>
> > > +static void mark_feat_supported(enum kern_feature_id last_feat)
> > > +{
> > > +   struct kern_feature_desc *feat;
> > > +   int i;
> > > +
> > > +   for (i = 0; i <= last_feat; i++) {
> > > +           feat = &feature_probes[i];
> > > +           WRITE_ONCE(feat->res, FEAT_SUPPORTED);
> > > +   }
> >
> > This assumes all earlier features than FD_IDX are supported. I think this is
> > probably fine although it may not work for some weird backport.
> > Did you see any issues if we don't explicitly set previous features
> > supported?
>
> This helper is only used as mark_feat_supported(FEAT_FD_IDX)
> to tell libbpf that it shouldn't probe anything.
> Otherwise probing via prog_load screw up gen_trace completely.
> May be it will be mark_all_feat_supported(void), but that seems less flexible.


mark_feat_supported() is changing global state irreversibly, which is
not great. I think it will be cleaner to just pass bpf_object * into
kernel_supports() helper, and there return true if obj->gen_trace is
set. That way it won't affect any other use cases that can happen in
the same process (not that there are any right now, but still). I
checked and in all current places there is obj available or it can be
accessed through prog->obj, so this shouldn't be a problem.


[...]
