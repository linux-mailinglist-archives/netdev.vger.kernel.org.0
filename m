Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC631E937E
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 21:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgE3Tro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 15:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE3Tro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 15:47:44 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D01C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 12:47:44 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id g28so4787769qkl.0
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 12:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U6hRICItJRMEn7ocO4ao+94oFk1oNiI22gcGdaZMmpg=;
        b=lJHZJruOVRbOQv1H0WtUMT96Jv0PkUA2MIYdj6IGEmNBkGKbM5mUffiz/XbvALidDH
         9ZovXJqUYXQeMiAJeAYMhW0IvTYQae5KmDPcmrTrlVZXZDc3ijpZ1dX41RTuDuDoYsNH
         M1tdU/WW5N+5txcvPQ8Kqg5dIAjbBWasfJjPPZhUE+tipAeeDE6MiiYJ0UIljpmCT8CV
         ILmjWwYRFJOQMR8cydx6/5obscFEawjDBORFNckuCv2Wv2knCKRKIG8dLFosfmAkGTc6
         PpXLbrbP8D+FLmahMVkb7tMaDDmgwzUxydMkOpwXao7dwXRfsbsiP08csHgEd0Z4z4cV
         stEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U6hRICItJRMEn7ocO4ao+94oFk1oNiI22gcGdaZMmpg=;
        b=s2Vb33MvRB8JNM4ZTDioawULsjzMCdVXq3C7tlz3niXpyhoDWrmTX9APCNLfDQdMrG
         RkfQWx2sjBy/UmdDiYS5Amv9oqSUipnydlJOvtTvlzt/ZFSx9GUScupW4DRftjoKapB0
         5pWuMMzv8bv+VumU0sLngOltIdsmNPbPlnsdjKFHV+edX158m890aoBvDiwa3tnH8Xdj
         uvDU/BgSwnsVGiFvjeJ+aXsPTx6ZvWntSO9m3L8bLeVhGzNEYcqeY4F9Cz2beaTzqlK4
         ByR6C7hmWvm2yWZ+v+sLLg2KjWO7W9oM37TLLtm4XV/8QFY9s9p5vOpLXFdMoTM6hL+7
         lpZw==
X-Gm-Message-State: AOAM533fpikHO1QDD+bz23tqvqEE+c+NeapWaDQ1LdwOXMi8jcPDf42t
        i30CM7y2h/gUAn6rryWV20e3ZnND
X-Google-Smtp-Source: ABdhPJx4qrQIv5HN3T4qKx/X+m0b9nZcvh0XJXhVeQq8MNQWosIUKCVk49g4S3QK4B+K0MPG/2EPSA==
X-Received: by 2002:a05:620a:15e8:: with SMTP id p8mr3080188qkm.333.1590868063162;
        Sat, 30 May 2020 12:47:43 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id f7sm9125639qkk.88.2020.05.30.12.47.42
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 12:47:42 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id b62so2990333ybh.8
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 12:47:42 -0700 (PDT)
X-Received: by 2002:a25:3187:: with SMTP id x129mr23703667ybx.428.1590868061820;
 Sat, 30 May 2020 12:47:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200528170532.215352-1-willemdebruijn.kernel@gmail.com>
 <20200529.172719.1001521060083156258.davem@davemloft.net> <CA+FuTSdmRQem9d8amUdYg=pdZCDHiMVHjCCmKh-3dxoKk3th9g@mail.gmail.com>
In-Reply-To: <CA+FuTSdmRQem9d8amUdYg=pdZCDHiMVHjCCmKh-3dxoKk3th9g@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 30 May 2020 15:47:04 -0400
X-Gmail-Original-Message-ID: <CA+FuTScnmJ3aSA06+FndrLvCFSNN_JwPxvtUqPh0xx_+aGd+8A@mail.gmail.com>
Message-ID: <CA+FuTScnmJ3aSA06+FndrLvCFSNN_JwPxvtUqPh0xx_+aGd+8A@mail.gmail.com>
Subject: Re: [PATCH net] tun: correct header offsets in napi frags mode
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 11:14 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Fri, May 29, 2020 at 8:27 PM David Miller <davem@davemloft.net> wrote:
> >
> > From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > Date: Thu, 28 May 2020 13:05:32 -0400
> >
> > > Temporarily pull ETH_HLEN to make control flow the same for frags and
> > > not frags. Then push the header just before calling napi_gro_frags.
> >  ...
> > >       case IFF_TAP:
> > > -             if (!frags)
> > > -                     skb->protocol = eth_type_trans(skb, tun->dev);
> > > +             if (frags && !pskb_may_pull(skb, ETH_HLEN)) {
> > > +                     err = -ENOMEM;
> > > +                     goto drop;
> > > +             }
> > > +             skb->protocol = eth_type_trans(skb, tun->dev);
> >  ...
> > >               /* Exercise flow dissector code path. */
> > > -             u32 headlen = eth_get_headlen(tun->dev, skb->data,
> > > -                                           skb_headlen(skb));
> > > +             skb_push(skb, ETH_HLEN);
> > > +             headlen = eth_get_headlen(tun->dev, skb->data,
> > > +                                       skb_headlen(skb));
> >
> > I hate to be a stickler on wording in the commit message, but the
> > change is not really "pulling" the ethernet header from the SKB.
> >
> > Instead it is invoking pskb_may_pull() which just makes sure the
> > header is there in the linear SKB data area.
> >
> > Can you please refine this description and resubmit?
>
> Of course. How is this
>
> "
>     Ensure the link layer header lies in linear as eth_type_trans pulls
>     ETH_HLEN. Then take the same code paths for frags as for not frags.
>     Push the link layer header back just before calling napi_gro_frags.
>
>     By pulling up to ETH_HLEN from frag0 into linear, this disables the
>     frag0 optimization in the special case when IFF_NAPI_FRAGS is
>     called with zero length iov[0] (and thus empty skb->linear).
> "
>
> Seemed good to add the extra clarification. I don't see a reasonable way
> to avoid that consequence, especially as I cannot restore the first skb frag
> (iov[1]) if it was exactly ETH_HLEN bytes and thus freed by __skb_pull_tail.

Sent. Probably faster that way. Do let me know if still too fast and
loose with wording. I can always do a v3.

Or to add some frags gymnastics to try to maintain the frag0 optimization
when iov[1] > ETH_LEN and frag0 thus can be restored. That just makes
for a more complicated fix.
