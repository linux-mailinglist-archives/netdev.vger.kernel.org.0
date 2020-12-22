Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE912E0E3B
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 19:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgLVSal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 13:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgLVSal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 13:30:41 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1509C0613D3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 10:30:00 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id c7so13826299edv.6
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 10:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5PwN6uJTV4B7BW+Uvq7f2g8JtJm8nJD2bKKP6L0u4A0=;
        b=I6b0p4TlZmszOupC+2JiS5kuLEGBMdVh9bm+Uu8L6RR17LhHL5cGqp4rBd1K+cZg1x
         RO8M36kLl2uAWRqJhc1p4uZdvj9Kxl9lObnQXztFJOYpGg+1KLiZHwuyqjlNWuaWVzs8
         lVOeBu6+yTpSRsrPQXfdCqXWPjEhF/MfpA1YH6K6w1V5UQKuHc0Fw82X4PLbSRco425z
         gJlcdeSHa8EM/0KZQbEV8c/Z0pzjn1qvTCuNEmod9Y2h+Ybt8V6oUBmhyvxAXx1oOJ2s
         1NwRdROPn/xFnmEA/VudVHz5+1Hi8+zkF9TbJuACvombW00ttI3z+IS5L8l6aDoX0cpv
         ciVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5PwN6uJTV4B7BW+Uvq7f2g8JtJm8nJD2bKKP6L0u4A0=;
        b=LH1OG+mSeyvcg5cz50E/MKgfsj5F3HhUlY71V4dP5tJyetXsmenpBMGNXDK39ACuT5
         fcKVzaUKKAk/dAws4p1F17Fg6nd+bHdmIqIPUMt05xD3pRYaHA2sca6WzEV8BJtmN2Mn
         R68s1oDHCslFZ+nmXe0GWx2cU289XpvNHOl0kReG0uSPCWTNxcYHTtKvgUU5rvRPvrA9
         pJ1PfAtjlGExnjSb8+xgJx2UkdUzkRD4gTGpIH/5W4Kkj4izcYt0kDbBK4MfzQeceIqm
         EM/lysRgDFvQpVo/kcAkKpDM7+0JALpmXJYZA/AH2AjcEeQo9I9QwE/driQaJV4wfaz6
         o2XQ==
X-Gm-Message-State: AOAM530IozSaNKwVGzA9jDp43+sHF8WYOMhyDIjyxtLzPR8oJmTxnpKn
        svGeSTHoHB36xj0BNANFKOjOazqE/RfAp1PnD5Y=
X-Google-Smtp-Source: ABdhPJyupP0s//NzWDAPyNEgvbXjyRqsQC1M8QIuPHGlDjloaxcj3W0SYrARwtcwBsqYh3FbANj5h0SZoSOPMzi91GI=
X-Received: by 2002:a50:ee8e:: with SMTP id f14mr21097565edr.176.1608661799348;
 Tue, 22 Dec 2020 10:29:59 -0800 (PST)
MIME-Version: 1.0
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
 <20201222000926.1054993-10-jonathan.lemon@gmail.com> <CAF=yD-+W93Gz4QygA=J0zME=sxVwzkKw3Q9BviwzNwkjziXPmg@mail.gmail.com>
 <20201222181704.cnpphtbrf7372szo@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201222181704.cnpphtbrf7372szo@bsd-mbp.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 22 Dec 2020 13:29:23 -0500
Message-ID: <CAF=yD-+si68K5YhHW1omgSEVUw7yFpwo8ku2e-+PXT5xJgxAsQ@mail.gmail.com>
Subject: Re: [PATCH 09/12 v2 RFC] skbuff: add zc_flags to ubuf_info for ubuf setup
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 1:17 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> On Tue, Dec 22, 2020 at 10:00:37AM -0500, Willem de Bruijn wrote:
> > On Mon, Dec 21, 2020 at 7:09 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > >
> > > From: Jonathan Lemon <bsd@fb.com>
> > >
> > > Currently, an ubuf is attached to a new skb, the skb zc_flags
> > > is initialized to a fixed value.  Instead of doing this, set
> > > the default zc_flags in the ubuf, and have new skb's inherit
> > > from this default.
> > >
> > > This is needed when setting up different zerocopy types.
> > >
> > > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > > ---
> > >  include/linux/skbuff.h | 3 ++-
> > >  net/core/skbuff.c      | 1 +
> > >  2 files changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > > index da0c1dddd0da..b90be4b0b2de 100644
> > > --- a/include/linux/skbuff.h
> > > +++ b/include/linux/skbuff.h
> > > @@ -478,6 +478,7 @@ struct ubuf_info {
> > >                 };
> > >         };
> > >         refcount_t refcnt;
> > > +       u8 zc_flags;
> > >
> > >         struct mmpin {
> > >                 struct user_struct *user;
> >
> > When allocating ubuf_info for msg_zerocopy, we actually allocate the
> > notification skb, to be sure that notifications won't be dropped due
> > to memory pressure at notification time. We actually allocate the skb
> > and place ubuf_info in skb->cb[].
> >
> > The struct is exactly 48 bytes on 64-bit platforms, filling all of cb.
> > This new field fills a 4B hole, so it should still be fine.
>
> Yes, I was careful not to increase the size.  I have future changes
> for this structure, moving 'struct mmpin' into a union.   Making the
> flags 16 bits shouldn't be a problem either.
>
>
> > Just being very explicit, as this is a fragile bit of code. Come to
> > think of it, this probably deserves a BUILD_BUG_ON.
>
> You mean like the one which exists in sock_zerocopy_alloc()?
>
>         BUILD_BUG_ON(sizeof(*uarg) > sizeof(skb->cb));

Ah good. Yes. I should have remembered that was there.
