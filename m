Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B991031D5C8
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 08:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhBQHhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 02:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbhBQHhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 02:37:06 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0830BC06174A;
        Tue, 16 Feb 2021 23:36:26 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id u11so6949418plg.13;
        Tue, 16 Feb 2021 23:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zxtM6eqeEhrdSssmUehvYw5PkJaJYEt+Y3uOFUDI4qY=;
        b=Ve9VK+l9eu3sKwzSnRbPPYCeNx4Zy9TdUEdZRbPyNTUcDtuEKagwPtDNUAfz/BjBXO
         Tuj0Z3ZTHo0CPJ5Skz6VTP2nqvwjgnFzF/20z3NsjERm8FGgcEaDHcWTTNEJLPdfvhUy
         Tak0w9SAt9GRtrrPFkjAyo4PupLA58TxWVujDyS0s5P215Mfh/dcMQuGDC4dkkfox23Q
         nH6NblgqUbboCVFrxOO/XW38kUdVcoUoViAzLxj9ztN+9rCT4l57NK7GVPHlyGoAnLgG
         OGiGmuDIcNLZPMv025fIt7OgmJyfxYUubRHphdlZSgjbl0JXlaSKhJRbGJ4CuurMEoLv
         ZEPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zxtM6eqeEhrdSssmUehvYw5PkJaJYEt+Y3uOFUDI4qY=;
        b=HtdMz6PkAos+BkhL6we9AlJ5OLMoplzivwocuJvsSpgEFJaS+1cjkRtxUcOxho57qu
         Z875fhANehUuCxY+QnMvrjYnTqOlb0Pi0Wtglodb4cmjlLr9SgCMmEHr6TURhKttM81M
         sVhN25Q/MIUJLw+cZvNBOPl8h3urFxjNTLMPGD0sdhOBdYv0TzCBBFgWhZh4iEgnykov
         JuxCnd8D+BUm4XM6wjV2KlEp8YVLz+FWPbTxEWUqB4ioCPqA2WnPGuIE9AF8ip/S7o11
         MQg69uMpCDFJ7ViF/+TPFDSqQ+FZVDWIHFWDKnhzNiPrzi2AoV0j3NgFr3dpr/IvKJLj
         DaVQ==
X-Gm-Message-State: AOAM532LAwyCzH5fNZhjUn3YFi6jSvMco78RwSDAPETDWnMRlaykDlgB
        1uDxy0behjMdjwU9bExo2io5oFFbYXoT/Y3yWys=
X-Google-Smtp-Source: ABdhPJx2bQNhr0lLnxEadgxiVXWIWsBKtq9oKMvsm1dY7KgqfhwFYPr5uBCQkkMwCNpIMDVj7YDEwvDOxn8zeEtpjU0=
X-Received: by 2002:a17:90a:7286:: with SMTP id e6mr1302455pjg.117.1613547385596;
 Tue, 16 Feb 2021 23:36:25 -0800 (PST)
MIME-Version: 1.0
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com> <87eehhcl9x.fsf@toke.dk>
 <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com> <602ad80c566ea_3ed4120871@john-XPS-13-9370.notmuch>
 <8735xxc8pf.fsf@toke.dk> <6e9842b289ff2c54e528eb89d69a9b4f678c65da.camel@coverfire.com>
 <CAJ8uoz0QqR97qEYYK=VVCE9A=V=k2tKnH6wNM48jeak2RAmL0A@mail.gmail.com>
In-Reply-To: <CAJ8uoz0QqR97qEYYK=VVCE9A=V=k2tKnH6wNM48jeak2RAmL0A@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 17 Feb 2021 08:36:14 +0100
Message-ID: <CAJ8uoz0WAM8oSag5b4uuLgUdQHNVdHjm0EmUtXyQ6XW0RFgKFA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
To:     Dan Siemon <dan@coverfire.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Ciara Loftus <ciara.loftus@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 8:16 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Wed, Feb 17, 2021 at 3:26 AM Dan Siemon <dan@coverfire.com> wrote:
> >
> > On Mon, 2021-02-15 at 22:38 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wro=
te:
> > > The idea is to keep libbpf focused on bpf, and move the AF_XDP stuff
> > > to
> > > libxdp (so the socket stuff in xsk.h). We're adding the existing code
> > > wholesale, and keeping API compatibility during the move, so all
> > > that's
> > > needed is adding -lxdp when compiling. And obviously the existing
> > > libbpf
> > > code isn't going anywhere until such a time as there's a general
> > > backwards compatibility-breaking deprecation in libbpf (which I
> > > believe
> > > Andrii is planning to do in an upcoming and as-of-yet unannounced
> > > v1.0
> > > release).
> >
> > I maintain a Rust binding to the AF_XDP parts of libbpf [1][2]. On the
> > chance that more significant changes can be entertained in the switch
> > to libxdp... The fact that many required functions like the ring access
> > functions exist only in xsk.h makes building a binding more difficult
> > because we need to wrap it with an extra C function [3]. From that
> > perspective, it would be great if those could move to xsk.c.
>
> The only reason they were put in xsk.h is performance. But with LTO
> (link-time optimizations) being present in most C-compilers these
> days, it might not be a valid argument anymore. I will perform some
> experiments and let you know. As you say, it would be much nicer to
> hide away these functions in the library proper and make your life
> easier.

I would be very grateful for any more suggested changes that users out
there would like to see. Now, when we move to libxdp is the perfect
chance to fix those things. We might even decide to partially break
compatibility or change some behavior if the gain is large enough.

> > [1] - https://github.com/aterlo/afxdp-rs
> > [2] - https://github.com/alexforster/libbpf-sys
> > [3] - https://github.com/alexforster/libbpf-sys/blob/master/bindings.c
> >
