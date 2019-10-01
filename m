Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21445C33ED
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 14:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732884AbfJAMM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 08:12:57 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:36831 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfJAMM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 08:12:57 -0400
Received: by mail-yb1-f194.google.com with SMTP id r2so698418ybg.3
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 05:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I4Mdc+KHRmiJRV6C+crVgSLNEDyy26MxkoplOWMBObM=;
        b=VDRgcEMQQ007Et7imYJoGrNOfs8aCz1lhJAEq77NZgMxzN+onKdDtifHNFtiKOBqJ9
         31AuU/OfKm8GD0NASS3+yTjv/fuIKPdYCWx8rMzOE0lw8Bntc3P82s3+otS0FG0EdMRf
         nHXJoWtv/Hfaxkl503dMigzYMGlBL4mHdq97xPZwcx8MoDhotWf9Dhj5KpINSvl9/JoS
         QfbygzokK6pczm6BHnxo84uBCo3iI6j6fPndEju9UT/jphJsBzewD/5Qfcrz7lngN6m6
         ImDZrsT15QgbY4r8j11R9h9lgT+uK4ywn5bMeApaHpzcy34+HoA1hbmmOpu37QN4Z22l
         BxcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I4Mdc+KHRmiJRV6C+crVgSLNEDyy26MxkoplOWMBObM=;
        b=lemSuh6UKjgRhBldSzkmyMyraXnmDqLdondCgowuwqNfBCY1mNVb/h3D/OL4mxnBp6
         qMmSS5Ve5u2kecb7EyVQRMjPZtDRGTWBsRAdwqQ5ChxwtAX2rAsVbLw4HyBXEESZE2b+
         HEqW4hHDcj/OBaNfNqj05kXtE7GtmvOaZPPUvOJnVpMh7tc+hkXdFbOzmdOiJniT2lHz
         xyY946Z7Rqh+EIzkIr7RVhcAw5Xp/Cm3d8m+TVYCI/vj28a1zvYuhBck6EsOIPKl3d+M
         SuEauGIj1SxAHvXPFZlci8Zf9Dx1UPGrjbmTsK2DUIga6UTQNfWy6CtnLZA0jPd6sk30
         H7og==
X-Gm-Message-State: APjAAAXggjAqv9yr42wdeZaz5rDm/l8E/3TM6CnEPOy5zIGZaRe4I2sD
        T/iewtJayEGn+TFy4DUCyzsXQlf+
X-Google-Smtp-Source: APXvYqzbzYe4mewy4ReLnjdvHDzn1zrBgQSxPFWciBqlKVswjLFOMfU8xe/Q5IW/tp5w4dnt3l3Wqw==
X-Received: by 2002:a25:dac4:: with SMTP id n187mr19365274ybf.16.1569931975335;
        Tue, 01 Oct 2019 05:12:55 -0700 (PDT)
Received: from mail-yw1-f51.google.com (mail-yw1-f51.google.com. [209.85.161.51])
        by smtp.gmail.com with ESMTPSA id d66sm3547246ywe.31.2019.10.01.05.12.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Oct 2019 05:12:54 -0700 (PDT)
Received: by mail-yw1-f51.google.com with SMTP id r134so4727699ywg.2
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 05:12:54 -0700 (PDT)
X-Received: by 2002:a81:6f8a:: with SMTP id k132mr16242672ywc.275.1569931973764;
 Tue, 01 Oct 2019 05:12:53 -0700 (PDT)
MIME-Version: 1.0
References: <1569881518-21885-1-git-send-email-johunt@akamai.com> <CAKgT0Ue092M4pMa8EjrqdF6KADK8WtFhA=17K3fuqW5=xKAeNg@mail.gmail.com>
In-Reply-To: <CAKgT0Ue092M4pMa8EjrqdF6KADK8WtFhA=17K3fuqW5=xKAeNg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 1 Oct 2019 08:12:16 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdkBpKtm48maiTWrRDuW0_ntvpkgXA_TvYZ6uOhf06duw@mail.gmail.com>
Message-ID: <CA+FuTSdkBpKtm48maiTWrRDuW0_ntvpkgXA_TvYZ6uOhf06duw@mail.gmail.com>
Subject: Re: [PATCH 1/2] udp: fix gso_segs calculations
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Josh Hunt <johunt@akamai.com>, David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 7:51 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Mon, Sep 30, 2019 at 3:15 PM Josh Hunt <johunt@akamai.com> wrote:
> >
> > Commit dfec0ee22c0a ("udp: Record gso_segs when supporting UDP segmentation offload")
> > added gso_segs calculation, but incorrectly got sizeof() the pointer and
> > not the underlying data type. It also does not account for v6 UDP GSO segs.
> >
> > Fixes: dfec0ee22c0a ("udp: Record gso_segs when supporting UDP segmentation offload")
> > Signed-off-by: Josh Hunt <johunt@akamai.com>
> > ---
> >  net/ipv4/udp.c | 2 +-
> >  net/ipv6/udp.c | 2 ++
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index cf755156a684..be98d0b8f014 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -856,7 +856,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
> >
> >                 skb_shinfo(skb)->gso_size = cork->gso_size;
> >                 skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
> > -               skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(uh),
> > +               skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(*uh),
> >                                                          cork->gso_size);
> >                 goto csum_partial;
> >         }
> > diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> > index aae4938f3dea..eb9a9934ac05 100644
> > --- a/net/ipv6/udp.c
> > +++ b/net/ipv6/udp.c
> > @@ -1143,6 +1143,8 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
> >
> >                 skb_shinfo(skb)->gso_size = cork->gso_size;
> >                 skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
> > +               skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(*uh),
> > +                                                        cork->gso_size);
> >                 goto csum_partial;
> >         }
> >
>
> Fix looks good to me.
>
> You might also want to add the original commit since you are also
> addressing IPv6 changes which are unrelated to my commit that your
> referenced:
> Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
>
> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Acked-by: Willem de Bruijn <willemb@google.com>

If resending, please target net: [PATCH net v2]
