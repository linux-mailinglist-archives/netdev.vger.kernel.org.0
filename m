Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4072D6491
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 19:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392668AbgLJSL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 13:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403968AbgLJSLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 13:11:51 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3629C0613D6;
        Thu, 10 Dec 2020 10:11:10 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id i9so6502666ioo.2;
        Thu, 10 Dec 2020 10:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wiJyrbtaj/a+/f7ClmrTZqeyRbQUwU/QHd41NceO6Ak=;
        b=HpRads/agzQPixVMMvlKUhwA46ta/X5A9Fz0VZeATTxhXJ3EyBDBovdNHUkV74xtLf
         LNikz/KZBB263UmPHwZR4DclSUtDqC4fcY+K1aec/RJTs6YL3n91Gatum90Wf4+16nSU
         2+XnjqTquXSmjoAIzShQbFxgfBYLqX5KWTmZ+Ln+rlJgZ3+GPbSVyYu8/KEw65JrZXSl
         7BMR8qgawDhN6fVaEFYhWy/kUrb5GMDbd5b78lQj/1QaVhaV4uTeZ8EK1Bl2h7SXrGGn
         9Vzdzm9Q+ZjyNGZpqylZ1mzS3lnbRWWbI5OuNyh5N3ZAnzAYHMsk6jV5dsPIZLrE1iJB
         1pYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wiJyrbtaj/a+/f7ClmrTZqeyRbQUwU/QHd41NceO6Ak=;
        b=t8CKOhdkEVWIXu13M5d4Bwfa74aY7Sm+iA3bUR2UbiKbolfzg+gcc3kCqYZdw8Lh6i
         j8jcMJLz6giEDgaq4YKr+Z2jS6g/f4zaT5JcYos6Z8FWCie/mrPSC3pLupfSzH2EeKY6
         uikXoijfERB8yTTvglW/vhaig7ok95PNb0WJktp72dcq9a+FWTXnh/IWeZW22mOEQksf
         FQkky/s8atatl+9eW9+M/DAdAYl6xQNjhs2wWkfPTcp7iOrPBoR72c21iWg9l7SdIfMK
         Fr+9JKvr+335St86frVMH8uJH10uZFJi1ZcQDzIlMDlmh3kBw27A8xGiYnUD36nsAxY/
         oAzw==
X-Gm-Message-State: AOAM5320xLbXc6qfcy8U0sWHSB7EK1Ed5H64YBCXFwM+rNaT3a0tMhFd
        bjogIpFjAFC6JblfTVaC2H0YcE+thm62OVlFymk=
X-Google-Smtp-Source: ABdhPJw4yxYoYUEAVmN0wbSFbKI/msBiu93FC/hr5M+7mw+1y0w8XNWcSciqUWx46G+dCgCL1s1rinCbU2QK7JYewr4=
X-Received: by 2002:a05:6602:150b:: with SMTP id g11mr9410411iow.88.1607623870123;
 Thu, 10 Dec 2020 10:11:10 -0800 (PST)
MIME-Version: 1.0
References: <e54fb61ff17c21f022392f1bb46ec951c9b909cc.1607615094.git.lorenzo@kernel.org>
 <20201210160507.GC45760@ranger.igk.intel.com> <20201210163241.GA462213@lore-desk>
 <20201210165556.GA46492@ranger.igk.intel.com>
In-Reply-To: <20201210165556.GA46492@ranger.igk.intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 10 Dec 2020 10:10:58 -0800
Message-ID: <CAKgT0UcM14JSZnfjr_Nc=+Y0ZLvaT3wz9VZyDW3mjTJJuptR8A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] net: xdp: introduce xdp_init_buff utility routine
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        lorenzo.bianconi@redhat.com, Saeed Mahameed <saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 9:05 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Thu, Dec 10, 2020 at 05:32:41PM +0100, Lorenzo Bianconi wrote:
> > > On Thu, Dec 10, 2020 at 04:50:42PM +0100, Lorenzo Bianconi wrote:
> > > > Introduce xdp_init_buff utility routine to initialize xdp_buff data
> > > > structure. Rely on xdp_init_buff in all XDP capable drivers.
> > >
> > > Hm, Jesper was suggesting two helpers, one that you implemented for things
> > > that are set once per NAPI and the other that is set per each buffer.
> > >
> > > Not sure about the naming for a second one - xdp_prepare_buff ?
> > > xdp_init_buff that you have feels ok.
> >
> > ack, so we can have xdp_init_buff() for initialization done once per NAPI run and
> > xdp_prepare_buff() for per-NAPI iteration initialization, e.g.
> >
> > static inline void
> > xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
> >                int headroom, int data_len)
> > {
> >       xdp->data_hard_start = hard_start;
> >       xdp->data = hard_start + headroom;
> >       xdp->data_end = xdp->data + data_len;
> >       xdp_set_data_meta_invalid(xdp);
> > }
>
> I think we should allow for setting the data_meta as well.
> x64 calling convention states that first four args are placed onto
> registers, so to keep it fast maybe have a third helper:
>
> static inline void
> xdp_prepare_buff_meta(struct xdp_buff *xdp, unsigned char *hard_start,
>                       int headroom, int data_len)
> {
>         xdp->data_hard_start = hard_start;
>         xdp->data = hard_start + headroom;
>         xdp->data_end = xdp->data + data_len;
>         xdp->data_meta = xdp->data;
> }
>
> Thoughts?

We only really need the 2, init and prepare. Also this is inline so I
don't think the arguments passed really play much of a role since
values like the headroom are likely to be constants and treated as
such.

- Alex
