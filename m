Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333F52E02AC
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 23:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgLUWx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 17:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgLUWx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 17:53:27 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FBFC0613D3
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 14:52:47 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id g20so15738306ejb.1
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 14:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ox5TzoTHMtdWbHv4xTgjnIvx1T97+yZzFTx7OcIVlm8=;
        b=BbU3vriKrCEZojB9ga0DouWLDCaZFBHg0C3kOEPNg81DmDwJEuudEuDHeBqnKMjV6l
         D0PxDrlY14Or22zC2/LQcpoYEQhnGr6O2zrs6mV8ztKzC6SA1oMttqbXsdUBD77ZitUC
         v+nDaDqX4DzpF/BUVTn4AxByv7IKORD28uVxykqBJLvK3a7oY+FP8dhDMAD4vmDnlCRG
         iMRSKyRMENExuqmvmj3WHtJknIXRUc/dAnqQySKRgq9L8Sk98CoJhalTHnc9NpfVn7XB
         cGAIBeTFt7QWx1I7eUlIXPpCmFJk2f325IIkIgpRamVd80E1OZO9kC2mTMR/wPPkB5hv
         4hwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ox5TzoTHMtdWbHv4xTgjnIvx1T97+yZzFTx7OcIVlm8=;
        b=UO6b5lQUR+yO8Sfs4+AjgIsUv9VRdw2EUGcsA+Gr3zxUQSYRkDLw+Jlckpo9yKK+nA
         9WaTxMzvgnBqmeBgWSJjoqn6Ry8c00wCs/WXjx0cPkzkMXufZ5QfC8RenvntiaFdX7XS
         WHwHI3mhEWBMC+7i01VptOwSUYauuZR67HOjcUE+7UDO7m6maZLUxviVwmSX9of1TSsk
         NR0duOffkB2GajA/ix2UnDnCfDtcAGiDFmSRwNCxxS1aA6BXBzMb0aPGNth1lT0y3s9B
         p/+s7XW3wgWo1+roAcHPic1F3+tRdgiEkF0l/PmS51K5G7xG8luh2qkSim7qeNmU4AzA
         WXRw==
X-Gm-Message-State: AOAM532Wm3pmlMW/fAs1r4Av0S8MpxmNhVem7D2GvdkrYbIVCsgYYIru
        YaaGtU/QentPju8qvBH1c86aJh80QO5kDF2VGUY=
X-Google-Smtp-Source: ABdhPJwdev8fo+8Vc+dnTts4hXdMLxAYQS6guged+HUJONTT10pe+ze5l/Ge9Fh+YwArPVJwwXzrVB1xc94fu2NrN1c=
X-Received: by 2002:a17:906:3f8d:: with SMTP id b13mr4305229ejj.464.1608591166064;
 Mon, 21 Dec 2020 14:52:46 -0800 (PST)
MIME-Version: 1.0
References: <20201218201633.2735367-1-jonathan.lemon@gmail.com>
 <CA+FuTSeM0pqj=LywVUUpNyekRDmpES1y8ksSi5PJ==rw2-=cug@mail.gmail.com>
 <20201218211648.rh5ktnkm333sw4hf@bsd-mbp.dhcp.thefacebook.com>
 <CA+FuTSfcxCncqzUsQh22A5Kdha_+wXmE=tqPk4SiJ3+CEui_Vw@mail.gmail.com> <20201221195009.kmo32xt4wyz2atkg@bsd-mbp>
In-Reply-To: <20201221195009.kmo32xt4wyz2atkg@bsd-mbp>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 21 Dec 2020 17:52:08 -0500
Message-ID: <CAF=yD-+bVFBHPfFB+E1s4Qae5PZGQJaiarAN9hwpP2aTs1f_jg@mail.gmail.com>
Subject: Re: [PATCH 0/9 v1 RFC] Generic zcopy_* functions
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >   - marking the skb data as inaccessible so skb_condense()
> > >     and skb_zeroocopy_clone() leave it alone.
> >
> > Yep. Skipping content access on the Rx path will be interesting. I
> > wonder if that should be a separate opaque skb feature, independent
> > from whether the data is owned by userspace, peripheral memory, the
> > page cache or anything else.
>
> Would that be indicated by a bit on the skb (like pfmemalloc), or
> a bit in the skb_shared structure, as I'm leaning towards doing here?

I would guide it in part by avoiding cold cacheline accesses. That
might be hard if using skb_shinfo. OTOH, you don't have to worry about
copying the bit during clone operations.

> > > > If anything, eating up the last 8 bits in skb_shared_info should be last resort.
> > >
> > > I would like to add 2 more bits in the future, which is why I
> > > moved them.  Is there a compelling reason to leave the bits alone?
> >
> > Opportunity cost.
> >
> > We cannot grow skb_shared_info due to colocation with MTU sized linear
> > skbuff's in half a page.
> >
> > It took me quite some effort to free up a few bytes in commit
> > 4d276eb6a478 ("net: remove deprecated syststamp timestamp").
> >
> > If we are very frugal, we could shadow some bits to have different
> > meaning in different paths. SKBTX_IN_PROGRESS is transmit only, I
> > think. But otherwise we'll have to just dedicate the byte to more
> > flags. Yours are likely not to be the last anyway.
>
> The zerocopy/enable flags could be encoded in one of the lower 3 bits
> in the destructor_arg, (similar to nouarg) but that seems messy.

Agreed :)

Let's just expand the flags for now. It may be better to have one
general purpose 16 bit flags bitmap, rather than reserving 8 bits
specifically to zerocopy features.
