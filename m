Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6D1467B61
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 17:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353064AbhLCQeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 11:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241840AbhLCQeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 11:34:02 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0523C061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 08:30:38 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id g17so10791736ybe.13
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 08:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=snUWL4jcFAokxNSpqHyAIRUQq9NnERvTw1khrF1c2OY=;
        b=Fim59aE3Hy51fLn0iKjfDBwxEzlCjHC1Knp4E0Ilo2mOFQKNdYBmKV4jgT/ZD2z0go
         lIxIkdb6M9FcEw8Hwhc6sJbqpcSYadUrYYeZ/J0+mDGPEfJykz1pe+Hz8vth+4SsC0gi
         4fvAsXeCsK57GKLccaXwU9UUXwLe1Kwf+uTpjIM12giCcE1uqLBK1GXOaas4L0Ttmbhp
         GdDpwjwRiVe/B/P7KAX/8P+6cgIPJQC+yC8/SmrrsYYiqVSH1EZKTNY3+I8kNYgW5ueV
         WGDIS3swshI6h+eyf0WHeIp35ahrWsrEpjsJGpDKXxElFhWAf16FhNJmcaNxE+9GgB9d
         Fzsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=snUWL4jcFAokxNSpqHyAIRUQq9NnERvTw1khrF1c2OY=;
        b=KBqx6oeACILSOmTyfjGR8Jfgx61WaTEi15+MHCH2PtAWi3X1msjm5vizw46j/ShZOj
         BtVQr4f0RgkgZYwA1ZjCeSsDayabh0PSBnBoZzRL1Iqazde2qEeaI3CbhiX++vHYpzyl
         hr7S/Kjnn76b7KTualZjaX1t6Bu6FeloR8+Psl9yn7jpo5wvkP8iHd+iHd3z2G5fKV0v
         7pifqHx9iYITZi8ImCKKSz1NMZtN9VCJH2ZnPtWEBo0PTeclWtS8keMLfav53U8crg2u
         68+BDg5xzNN++8cCGl8p2/wzEcfuZAT2dvjAlmhemcoZ1IhtOIAIjhV5/gS3KTBqSda+
         HKFQ==
X-Gm-Message-State: AOAM531DFo1/2PSNTjkXA6gMxQiD51JkyQaprVOuRrcWV876Ulm1hmls
        GX+HFUMhuf6oi8WnX8a+kWb1m9vwYL0EI5WneJrOf7YnzIQ=
X-Google-Smtp-Source: ABdhPJxOqlAZIpn/Uxv4SPm3XpDDOsj57xIWXmXAtWO4ZoFZnLiDRPVlr/PcTYraNlML1zbpPe1j1qZ3uw9R1xZT3H4=
X-Received: by 2002:a05:6902:1025:: with SMTP id x5mr24481374ybt.156.1638549037440;
 Fri, 03 Dec 2021 08:30:37 -0800 (PST)
MIME-Version: 1.0
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
 <20211124202446.2917972-3-eric.dumazet@gmail.com> <20211202131040.rdxzbfwh2slhftg5@skbuf>
 <CANn89iLW4kwKf0x094epVeCaKhB4GtYgbDwE2=Fp0HnW8UdKzw@mail.gmail.com>
 <20211202162916.ieb2wn35z5h4aubh@skbuf> <CANn89iJEfDL_3C39Gp9eD=yPDqW4MGcVm7AyUBcTVdakS-X2dg@mail.gmail.com>
 <20211202204036.negad3mnrm2gogjd@skbuf> <9eefc224988841c9b1a0b6c6eb3348b8@AcuMS.aculab.com>
 <20211202214009.5hm3diwom4qsbsjd@skbuf> <eb25fee06370430d8cd14e25dff5e653@AcuMS.aculab.com>
 <20211203161429.htqt4vuzd22rlwkf@skbuf>
In-Reply-To: <20211203161429.htqt4vuzd22rlwkf@skbuf>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 3 Dec 2021 08:30:26 -0800
Message-ID: <CANn89iKk=DZEbwAeaborF-Q5pE9=Jahc0TP1_wk59s2eqB0o1A@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 3, 2021 at 8:14 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Fri, Dec 03, 2021 at 02:57:04PM +0000, David Laight wrote:
> > From: Vladimir Oltean
> > > Sent: 02 December 2021 21:40
> > ...
> > > >
> > > > Try replacing both ~ with -.
> > > > So replace:
> > > >           skb->csum = ~csum_partial(start, len, ~skb->csum);
> > > > with:
> > > >           skb->csum = -csum_partial(start, len, -skb->csum);
> > > >
> > > > That should geneate ~0u instead 0 (if I've got my maths right).
> > >
> > > Indeed, replacing both one's complement operations with two's complement
> > > seems to produce correct results (consistent with old code) in all cases
> > > that I am testing with (ICMP, TCP, UDP). Thanks!
> >
> > You need to generate (or persuade Eric to generate) a patch.
> > I don't have the right source tree.
> >
> > Any code that does ~csum_partial() is 'dubious' unless followed
> > by a check for 0.
> > The two's compliment negate save the conditional - provided the
> > offset of 1 can be added in earlier.
> >
> >       David
> >
> > -
> > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > Registration No: 1397386 (Wales)
> >
>
> Eric, could you please send a patch with this change?

Sure, I will do this today, after more testing.

> If you want and if it helps, I can also help you reproduce this locally
> using the dsa_loop mockup driver.

No need, thanks !
