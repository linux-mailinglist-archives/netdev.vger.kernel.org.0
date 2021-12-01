Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40386465551
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 19:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352380AbhLAS0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352464AbhLAS0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:26:41 -0500
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01076C06175C
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 10:23:20 -0800 (PST)
Received: by mail-vk1-xa30.google.com with SMTP id 188so16771142vku.8
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 10:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DQVCGyJnIZNoZkWp8xmt+/uwpERfY6xGl5pPa1paKWo=;
        b=lck4Z6PTlbNZeqt8KTJLkFTnzbWdeEXNMPXXl07ARHleDkCASMgYbPnUSJt4PxTbf4
         5WCTo7V205sALDuCOndhHv5GXsP/fHVem9k3VyuRgX86cQcgG+CK4Gx1rHndTS6GvfSv
         o4s48n0l3scaBh6napb0/RA10prn3Yed/emPMeiKP0LG/Z91pav6793OG5cOg+TyWn4b
         dMKFKBtNuZneb9vFT/9r4dwrTjGBldPCNhQae7qNtE+cAz+8tFXsMmRuapazXo0LJmob
         MIk5zGJ7F+vTwahhfe3t1tj6ToZQqImgUokY4xUwozmVBqngQJlpXFaOFCMVtUaNbYEV
         vkOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DQVCGyJnIZNoZkWp8xmt+/uwpERfY6xGl5pPa1paKWo=;
        b=hMKhQZfBIAnN5r93fKcVU9tXjlhV7HEUhVXV7ZBpZJ40ldzOpmgS4oXHPiWBYGeZPA
         DLGw7WU01mR5w1I+sU+MxlpSjsdhHa0dJTfb+rYO+Dt71oOMXl0fxpW//ZdO3IHlJyty
         BjZYQQ9XpJDzfKtS/29nYjESUry8gB+hd/HWzbFBMp0ffb+V2I8wB+NLL02Wr5Etv9Jw
         +KJMmYBM7aybFT5P8IVQmkbMPP7bFD6SeMEAuag21NJGY+81iJ1PceRpy9koCR6XgpB6
         dE4FHUYUhbY/FkkKG7EFFc9bMQBOgWnObMKlIBFW2FiFuKU3orp5E+HTPwsa5CsmuglL
         EjLQ==
X-Gm-Message-State: AOAM533Glkh/9se/2R4BOO/fKiG0KJ8Lk4nVFkUWTiWg0YywDF2fKOhN
        IkgOwascpOTF/1PKdMSIl2He8NOOM/ZZJQ==
X-Google-Smtp-Source: ABdhPJwVYsr7WvO1hFiPxG4Q+j0TxNoBsS3fpUuO3KyY+9TQjmyEVAUzAWDWMJoQzUm91ww3EVkU2Q==
X-Received: by 2002:a1f:2d8:: with SMTP id 207mr10128222vkc.30.1638382999172;
        Wed, 01 Dec 2021 10:23:19 -0800 (PST)
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com. [209.85.221.177])
        by smtp.gmail.com with ESMTPSA id l11sm227564uak.4.2021.12.01.10.23.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 10:23:18 -0800 (PST)
Received: by mail-vk1-f177.google.com with SMTP id h1so9578165vkh.0
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 10:23:18 -0800 (PST)
X-Received: by 2002:ac5:cfca:: with SMTP id m10mr9811625vkf.29.1638382998087;
 Wed, 01 Dec 2021 10:23:18 -0800 (PST)
MIME-Version: 1.0
References: <20211201163245.3629254-1-andrew@lunn.ch> <20211201163245.3629254-3-andrew@lunn.ch>
 <CA+FuTSfLxEic2ZtD8ygzUQMrftLkRyfjdf7GH6Pf8ioSRjHrOg@mail.gmail.com> <Yae6lGvTt8sCtLJX@lunn.ch>
In-Reply-To: <Yae6lGvTt8sCtLJX@lunn.ch>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 1 Dec 2021 10:22:38 -0800
X-Gmail-Original-Message-ID: <CA+FuTSce_Q=uyn9brCDmwijf5-zOp3G9QDqSAaU=PC7=oCxUPQ@mail.gmail.com>
Message-ID: <CA+FuTSce_Q=uyn9brCDmwijf5-zOp3G9QDqSAaU=PC7=oCxUPQ@mail.gmail.com>
Subject: Re: [patch RFC net-next 2/3] icmp: ICMPV6: Examine invoking packet
 for Segment Route Headers.
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static void icmpv6_notify_srh(struct sk_buff *skb, struct inet6_skb_parm *opt)
> > > +{
> > > +       struct sk_buff *skb_orig;
> > > +       struct ipv6_sr_hdr *srh;
> > > +
> > > +       skb_orig = skb_clone(skb, GFP_ATOMIC);
> > > +       if (!skb_orig)
> > > +               return;
> >
> > Is this to be allowed to write to skb->cb? Or because seg6_get_srh
> > calls pskb_may_pull to parse the headers?
>
> This is an ICMP error message. So we have an IP packet, skb, which
> contains in the message body the IP packet which invoked the error. If
> we pass skb to seg6_get_srh() it will look in the received ICMP
> packet. But we actually want to find the SRH in the packet which
> invoked the error, the one which is in the message body. So the code
> makes a clone of the skb, and then updates the pointers so that it
> points to the invoking packet within the ICMP packet. Then we can use
> seg6_get_srh() on this inner packet, since it just looks like an
> ordinary IP packet.

Ah of course. I clearly did not appreciate the importance of that
skb_reset_network_header.

> > It is unlikely (not impossible) in this path for the packet to be
> > shared or cloned. Avoid this operation when it isn't? Most packets
> > will not actually have segment routing, so this imposes significant
> > cost on the common case (if in the not common ICMP processing path).
> >
> > nit: I found the name skb_orig confusing, as it is not in the meaning
> > of preserve the original skb as at function entry.
>
> skb_invoking? That seems to be the ICMP terminology?

Sounds good, thanks.

> > > +       skb_dst_drop(skb_orig);
> > > +       skb_reset_network_header(skb_orig);
> > > +
> > > +       srh = seg6_get_srh(skb_orig, 0);
> > > +       if (!srh)
> > > +               goto out;
> > > +
> > > +       if (srh->type != IPV6_SRCRT_TYPE_4)
> > > +               goto out;
> > > +
> > > +       opt->flags |= IP6SKB_SEG6;
> > > +       opt->srhoff = (unsigned char *)srh - skb->data;
> >
> > Should this offset be against skb->head, in case other data move
> > operations could occur?
>
> I copied the idea from get_srh(). It does:
>
> srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
>
> So i'm just undoing it.
>
> > Also, what happens if the header was in a frags that was pulled by
> > pskb_may_pull in seg6_get_srh.
>
> Yes, i checked that. Because the skb has been cloned, if it needs to
> rearrange the packet because it goes over a fragment boundary,
> pskb_may_pull() will return false. And then we won't find the
> SRH.

Great. So the feature only works if the SRH is in the linear header.

Then if the packet is not shared, you can just temporarily reset the
network header and revert it after?

> Nothing bad happens, traceroute is till broken as before.  What
> is a typical fragment size?

The question here is not the size in frags[], but that of the linear
section. This is really device driver and mtu specific. For many
devices and 1500 B mtu, the entire packet in linear seems quite
likely.
