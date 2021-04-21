Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1175A3671F2
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244882AbhDURvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244993AbhDURuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 13:50:54 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F1AC06174A;
        Wed, 21 Apr 2021 10:50:19 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id n138so68219930lfa.3;
        Wed, 21 Apr 2021 10:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+xzGjYcp7C0YcgVwskPlICNzjooI5BNf8nDqaEgMnL4=;
        b=IbwEpWq0nP9+JTii+NThZtLb0RYQQjW3UpHA1dgWKrJS62fzCj0lcfYcMpMUZSig2Y
         q8iMY6EfHwGfAuw/c/RDFuSHY1u0SyILf9OuVfkULLLVNUi+hECg785O/ou6o1/k9+zo
         2/MWkJuRelivngfKMSExIQvQx8YFOGA8K2vd5VpR28X6iz/nnHAY7t0PHOKpkUyvUlYd
         L8I1E32G/XPv3cPQIO6/p3UWOi8Jq/wQvekllmiUDiCAyV90Cg5gBAttM5b8zOBt+UF0
         djUOiZr1s9Myx9S9VPMtWnuwkT+kAIcIOnIwIz0IuwrrDkUTYqWYDI9pgr1rgu1FbiRI
         M6ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+xzGjYcp7C0YcgVwskPlICNzjooI5BNf8nDqaEgMnL4=;
        b=OXrfgopBRg8iyxkevKEebhiI4Asjtb9un4j/87wzmu5AozUoAf7Ubl0E25DGocjlGg
         TTbg6y1e2YDbEip2zNzxXGyFje2jbiiL+vgXlrJ/ZTTvfk79Y42Rws8XW2iOHuU3wdP9
         oLreTD+a1feHQS5AS5VriutT1N79eWrNMw+pWLazvpZNC8oPXs0iBhQNrZYfVZ0hCfc2
         3Y6svbVh15bwzDIVsnM1RZh9vypBsN4GFOdK00odH29rAS5eeR+mkdE5/CoN0bHTwO7y
         +HQINFCLPITiCYsamDB5SKw4VZHsWMDyhCjbNEOgL6kjEcLNPBIsQ6ze+/hF5kP7/rii
         t6kQ==
X-Gm-Message-State: AOAM530ncjxFY0U4/lLTro092bk6A5geG4r89/szuTlaPe4A4xDkV/AR
        K3cv/ak+Zpa0/CwBI3d4BTRUvyTcR/zHRuDyK7k=
X-Google-Smtp-Source: ABdhPJwpPLOR78h3r0MaowLW9JErdCTU7Ej1MpZbAaz0ea5+//8LqJiSzq/56e0IE+kgREhh2DfjRAXFBVTRlGDdPxE=
X-Received: by 2002:a05:6512:3f93:: with SMTP id x19mr20288601lfa.182.1619027417606;
 Wed, 21 Apr 2021 10:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
 <20210417033224.8063-14-alexei.starovoitov@gmail.com> <a63a54c3-e04a-e557-3fe1-dacfece1e359@fb.com>
 <20210421044643.mqb4lnbqtgxmkcl4@ast-mbp.dhcp.thefacebook.com> <CAEf4BzY6AQznGOyfp1j54pp-9pJ_SpWZZo6GWMENnDng8aizig@mail.gmail.com>
In-Reply-To: <CAEf4BzY6AQznGOyfp1j54pp-9pJ_SpWZZo6GWMENnDng8aizig@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 21 Apr 2021 10:50:06 -0700
Message-ID: <CAADnVQKF7bn80sq2ofNHhOL7XFNAppRdBkAr9XbY4rm2pPpfXw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 13/15] libbpf: Generate loader program out of BPF
 ELF file.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Wed, Apr 21, 2021 at 10:46 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Apr 20, 2021 at 9:46 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Apr 20, 2021 at 06:34:11PM -0700, Yonghong Song wrote:
> > > >
> > > > kconfig, typeless ksym, struct_ops and CO-RE are not supported yet.
> > >
> > > Beyond this, currently libbpf has a lot of flexibility between prog open
> > > and load, change program type, key/value size, pin maps, max_entries, reuse
> > > map, etc. it is worthwhile to mention this in the cover letter.
> > > It is possible that these changes may defeat the purpose of signing the
> > > program though.
> >
> > Right. We'd need to decide which ones are ok to change after signature
> > verification. I think max_entries gotta be allowed, since tools
> > actively change it. The other fields selftest change too, but I'm not sure
> > it's a good thing to allow for signed progs. TBD.
> >
>
> [...]
>
> >
> > > > +static void mark_feat_supported(enum kern_feature_id last_feat)
> > > > +{
> > > > +   struct kern_feature_desc *feat;
> > > > +   int i;
> > > > +
> > > > +   for (i = 0; i <= last_feat; i++) {
> > > > +           feat = &feature_probes[i];
> > > > +           WRITE_ONCE(feat->res, FEAT_SUPPORTED);
> > > > +   }
> > >
> > > This assumes all earlier features than FD_IDX are supported. I think this is
> > > probably fine although it may not work for some weird backport.
> > > Did you see any issues if we don't explicitly set previous features
> > > supported?
> >
> > This helper is only used as mark_feat_supported(FEAT_FD_IDX)
> > to tell libbpf that it shouldn't probe anything.
> > Otherwise probing via prog_load screw up gen_trace completely.
> > May be it will be mark_all_feat_supported(void), but that seems less flexible.
>
>
> mark_feat_supported() is changing global state irreversibly, which is
> not great. I think it will be cleaner to just pass bpf_object * into
> kernel_supports() helper, and there return true if obj->gen_trace is
> set. That way it won't affect any other use cases that can happen in
> the same process (not that there are any right now, but still). I
> checked and in all current places there is obj available or it can be
> accessed through prog->obj, so this shouldn't be a problem.

sure. Will use that.
