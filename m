Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F77D25E500
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 03:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgIEB5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 21:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgIEB5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 21:57:40 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38680C061244;
        Fri,  4 Sep 2020 18:57:39 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 31so5180121pgy.13;
        Fri, 04 Sep 2020 18:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RyQJwHrGSIVSTLClykihDJ8SgQVVB4xZyNAi/4QjuPU=;
        b=LMy/q7W2rePDkk9NscKsx4a3JdLsPa3+1BU/IkFaBzOrPN/BU4IEm4XUWaWZeLa2Yd
         aNAWcGQwx0rajltIwajdf0kSNqIAoBZElI8NMXfmb18jt0d8VjgMmuN+NDlPnOyu6juB
         j1R7H4MZ3jFXBYpG9U3Mop2LKZsJt+GUdyZX8+k2KN4EUdsGHKHpIcDT+4s6wlDtq2dQ
         quqmdA5BmGTOrFZPbJAMTzlsKz8djeUYUxa5qVKReajJpvdaKVeNgI6xHn28aYQx6WbE
         iGCI+w6ycUJtLeX4SI6wNopkwMp7NgIR1ad8YS6wGV1Oze05DZV7z5NrvPnncN3u/lY7
         Kr/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RyQJwHrGSIVSTLClykihDJ8SgQVVB4xZyNAi/4QjuPU=;
        b=BCs9LWJVogwCW4k7o3ebFZ8LDBSMs40KivIcDjaag00PU1g/bCWy9Pj271YwWaygmD
         aQ5BPeq0SwFdDSrKwqq3OVWm0yuShNCVSWSJtFnVuBIsK8tNRlejfiZW8bUugi99mpon
         ioTGLuX7w2cdfSO1EXk7S8xK93KPvzEsynQLmlnbS8+l5WDZVn0rxi/KIUBGcwEfk+sA
         BzxXJZD7y51zGhd9ki541mAbyxsS8g2P0FvE6WPoZAeO9iE+fpR4BDUI2poEjnk3ZN6d
         Owu8zXZvd3cvKWXFe2GsMM7oMK/1bYJ3PjVdqXxNKaj57Es/i5mkYyAfyUGf7npsgatS
         mxjg==
X-Gm-Message-State: AOAM533H1Exjo0A0KVG3fZ41wkm5IqO/jU0DQfbuj5hY6O7DMeINGNrE
        UTghY6EsAN6G8IQC/J2TPY+gu3jOzPvYm8dn+TWVIhUszcY=
X-Google-Smtp-Source: ABdhPJy+e3ctpzwE7UW7BpqWEQmQmfaEB3JKQ9jY23PrT4ZdgQawG8OvcRn6MAg/ZAlGfqFl6vrWGDTH5eMxsQoPIXU=
X-Received: by 2002:a63:b24b:: with SMTP id t11mr9334548pgo.233.1599271058264;
 Fri, 04 Sep 2020 18:57:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200903000658.89944-1-xie.he.0141@gmail.com> <20200904151441.27c97d80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EN+=WTuduvm43_Lq=XWL78AcF5q6Zoyg8S5fao_udL=+Q@mail.gmail.com>
In-Reply-To: <CAJht_EN+=WTuduvm43_Lq=XWL78AcF5q6Zoyg8S5fao_udL=+Q@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 4 Sep 2020 18:57:27 -0700
Message-ID: <CAJht_ENKyfMm7wAxcVSThEG63oVe72FvMs-5VaLWemKvveY+dQ@mail.gmail.com>
Subject: Re: [PATCH net v2] drivers/net/wan/hdlc_fr: Add needed_headroom for
 PVC devices
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Krzysztof Halasa <khc@pm.waw.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 4, 2020 at 6:28 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> The HDLC device is not actually prepending any header when it is used
> with this driver. When the PVC device has prepended its header and
> handed over the skb to the HDLC device, the HDLC device just hands it
> over to the hardware driver for transmission without prepending any
> header.
>
> If we grep "header_ops" and "skb_push" in "hdlc.c" and "hdlc_fr.c", we
> can see there is no "header_ops" implemented in these two files and
> all "skb_push" happen in the PVC device in hdlc_fr.c.

I want to provide a little more information about the flow after an
HDLC device's ndo_start_xmit is called.

An HDLC hardware driver's ndo_start_xmit is required to point to
hdlc_start_xmit in hdlc.c. When a HDLC device receives a call to its
ndo_start_xmit, hdlc_start_xmit will check if the protocol driver has
provided a xmit function. If it has provided this function,
hdlc_start_xmit will call it to start transmission. If it has not,
hdlc_start_xmit will directly call the hardware driver's function to
start transmission. This driver (hdlc_fr) has not provided a xmit
function in its hdlc_proto struct, so hdlc_start_xmit will directly
call the hardware driver's function to transmit.

So no header will be prepended after ndo_start_xmit is called.

There would not be any header prepended before ndo_start_xmit is
called, either, because there is no header_ops implemented in either
hdlc.c or hdlc_fr.c.

On Fri, Sep 4, 2020 at 6:28 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> Thank you for your email, Jakub!
>
> On Fri, Sep 4, 2020 at 3:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Since this is a tunnel protocol on top of HDLC interfaces, and
> > hdlc_setup_dev() sets dev->hard_header_len = 16; should we actually
> > set the needed_headroom to 10 + 16 = 26? I'm not clear on where/if
> > hdlc devices actually prepend 16 bytes of header, though.
>
> The HDLC device is not actually prepending any header when it is used
> with this driver. When the PVC device has prepended its header and
> handed over the skb to the HDLC device, the HDLC device just hands it
> over to the hardware driver for transmission without prepending any
> header.
>
> If we grep "header_ops" and "skb_push" in "hdlc.c" and "hdlc_fr.c", we
> can see there is no "header_ops" implemented in these two files and
> all "skb_push" happen in the PVC device in hdlc_fr.c.
>
> For this reason, I have previously submitted a patch to change the
> value of hard_header_len of the HDLC device from 16 to 0, because it
> is not actually used.
>
> See:
> 2b7bcd967a0f (drivers/net/wan/hdlc: Change the default of hard_header_len to 0)
>
> > > diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
> > > index 9acad651ea1f..12b35404cd8e 100644
> > > --- a/drivers/net/wan/hdlc_fr.c
> > > +++ b/drivers/net/wan/hdlc_fr.c
> > > @@ -1041,7 +1041,7 @@ static void pvc_setup(struct net_device *dev)
> > >  {
> > >       dev->type = ARPHRD_DLCI;
> > >       dev->flags = IFF_POINTOPOINT;
> > > -     dev->hard_header_len = 10;
> > > +     dev->hard_header_len = 0;
> >
> > Is there a need to set this to 0? Will it not be zero after allocation?
>
> Oh. I understand your point. Theoretically we don't need to set it to
> 0 because it already has the default value of 0. I'm setting it to 0
> only because I want to tell future developers that this value is
> intentionally set to 0, and it is not carelessly missed out.
