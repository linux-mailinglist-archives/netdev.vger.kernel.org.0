Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24971318370
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 03:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhBKCID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 21:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhBKCH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 21:07:56 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4CDC061574;
        Wed, 10 Feb 2021 18:07:16 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id v5so4108387ybi.3;
        Wed, 10 Feb 2021 18:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=asgTdyriWT2fI9Zyqcc8Nzc7uivOy6Y7UCwzlHhmiX4=;
        b=WuLdy7/DQDl8ThsrSxJLujCcXcs6AMRegcBGj3rLCrFMluKHXsAyT9o6pWBZ2yUaAs
         /CS2qqvOYjGACVBWTL9pluAbhoM/BrRG3Qsb8PeOHT2yKjrl76gKs32/lCsekvnIQl73
         H/Verwt4MYtVkCoezQUMCSIV3pT7wGcRn2QfARfLnr0jk9e7GZIFj3UZ55sGDX3dC2bT
         PKkETQNONXYdDyg6Xqi8xmikezXfslssWY+0GWNVts0j8nPjyYGeFj/5nXA7A57LR7Mo
         jJVeHd1swE+FcjIhFSiy0lfyJUhw7JbLxjKAFw5AL2d0hDpnQjw9TGh5Tva178WBfHy1
         Ek8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=asgTdyriWT2fI9Zyqcc8Nzc7uivOy6Y7UCwzlHhmiX4=;
        b=sRyd8el46Egv8mf5wng+qAcdUVdh/y5d0xTdd6LqovmtyGRutSud0otdqg3v2+48BG
         sRDgqG9FwkfjE2l3hScyy2avuKA6PnaOiEezYGDfPcyDcfzsiFGhqQqXgsoO/6au6RwN
         LIZZHmKXXQGh35S3K2MmZu0J1OUmu1NbWPAe9aCR8Gam5kaKhzTTbteezB+PglOg9oPs
         hgeza5UGMh3lqmJy1NLcHsCi77s8Ls/1Uu1JI6PBK8LeIBveV818Ny/eTQ/k4TnrpI61
         kqujgdbw37URthJp0Fw81kqrf2qDcnHccC+zTO6pbEoYTBjXnPRKZxgEWMC5M5n2ao0h
         BlSA==
X-Gm-Message-State: AOAM531SAHyIthWrTDlXEecka0BSASvAttYZJosOz9Eye7tsgsteWJsK
        sutCq2DT5R96Vm12iWYlXC3C9qpSsyOw8GQdxltq5srPM3g=
X-Google-Smtp-Source: ABdhPJy9MbkpnZmkTomU5wvsCF/4u9h9B5x28LF+DlPKwXL55Z9dZxUBbyu3bVI22TfIVI3hjj6UV8iOpyMuX10+jtA=
X-Received: by 2002:a25:4b86:: with SMTP id y128mr8045350yba.403.1613009235546;
 Wed, 10 Feb 2021 18:07:15 -0800 (PST)
MIME-Version: 1.0
References: <20210209193105.1752743-1-kafai@fb.com> <20210209193112.1752976-1-kafai@fb.com>
 <CAEf4BzbZmmezSxYLCOdeeA4zW+vdDvQH57wQ-qpFSKiMcE1tVw@mail.gmail.com>
 <20210210211735.4snmhc7gofo6zrp5@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbhBng6k5e_=p0+mFSpQS7=BM_ute9eskViw-VCMTcYYA@mail.gmail.com> <20210211015510.zd7tn6efiimfel3v@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210211015510.zd7tn6efiimfel3v@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Feb 2021 18:07:04 -0800
Message-ID: <CAEf4Bza_cNDTuu8jQ3K4qeb3e_nMEasmGqZqePy4B=XJqyXuMg@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] bpf: selftests: Add non function pointer test to struct_ops
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 5:55 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Feb 10, 2021 at 02:54:40PM -0800, Andrii Nakryiko wrote:
> > On Wed, Feb 10, 2021 at 1:17 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Wed, Feb 10, 2021 at 12:27:38PM -0800, Andrii Nakryiko wrote:
> > > > On Tue, Feb 9, 2021 at 12:11 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > >
> > > > > This patch adds a "void *owner" member.  The existing
> > > > > bpf_tcp_ca test will ensure the bpf_cubic.o and bpf_dctcp.o
> > > > > can be loaded.
> > > > >
> > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > ---
> > > >
> > > > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > > >
> > > > What will happen if BPF code initializes such non-func ptr member?
> > > > Will libbpf complain or just ignore those values? Ignoring initialized
> > > > members isn't great.
> > > The latter. libbpf will ignore non-func ptr member.  The non-func ptr
> > > member stays zero when it is passed to the kernel.
> > >
> > > libbpf can be changed to copy this non-func ptr value.
> > > The kernel will decide what to do with it.  It will
> > > then be consistent with int/array member like ".name"
> > > and ".flags" where the kernel will verify the value.
> > > I can spin v2 to do that.
> >
> > I was thinking about erroring out on non-zero fields, but if you think
> > it's useful to pass through values, it could be done, but will require
> > more and careful code, probably. So, basically, don't feel obligated
> > to do this in this patch set.
> You meant it needs different handling in copying ptr value
> than copying int/char[]?

Hm.. If we are talking about copying pointer values, then I don't see
how you can provide a valid kernel pointer from the BPF program?...
But if we are talking about copying field values in general, then
you'll need to handle enums, struct/union, etc, no? If int/char[] is
supported (I probably missed that it is), that might be the only
things you'd need to support. So for non function pointers, I'd just
enforce zeroes.
