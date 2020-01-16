Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A57913DF98
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgAPQH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:07:57 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:40518 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgAPQH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 11:07:56 -0500
Received: by mail-yb1-f193.google.com with SMTP id l197so3066678ybf.7
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 08:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=keogvSx/J1fmsyBPq/ScLERkiKLKDRRMXYGgj/9LSMc=;
        b=SeSsC9ODd9Zq54DpLguvGF7iVDj8tL9nM2jDTSqWzIj/qeXdB9Mo6Klw2uovUBbYQh
         CfRErIClVsNnsgV2DOA8/mY3HM6ZyHcZ1ze9mTqUGKnSTCYjpT2m1jSPE37wE39TC5vI
         Y66ohwf50yLPVustrzk7+oCQ3FTuLwPgzf9c5yZDsQcXd2LJKkMysiI8iKgO8/rEX0Vp
         GMifROi99cA023hmJcD6DCmu/8hXUSjQQEjyc3pafANWcEw4ZnlDqZjXeD6zfA8yuK8g
         lTU0nA99fQFWU6ezGUOhHMyP4HoY8DUPoB6BgX0ceJodd8mhjHbZqHnEZIs+9DyfOFyc
         B6Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=keogvSx/J1fmsyBPq/ScLERkiKLKDRRMXYGgj/9LSMc=;
        b=rIfPQbYNec5rxzpzS3/yI/IIFNAVfVQc2phh1NEZVFlb2eajb/bK/DdrqJqCd6D6LX
         N21zWi5gkM5xdmi+/Lev8/jsz7/GiHSZn6iQBzfjtHWYynFtCK0P/8nRn+aLNCK6xY53
         4pkCQaxOp4LBcOG1uh+1zYOKInXjnxn55Jq7YEQKWjbXIGoY6s311gzTRUPgYg4sR6n9
         PYTebhWx0lwrqU0VYjjZHEY8iGzEnQ3dH85OX+vq8MP+FlzmWQvAD58EEsHCEgkObkkT
         UvKSp1uaGXkCvDe5EXFDcvsmhh0k3X4sIqRz/it5cJkXcIB0X3W9uuOkejSeHvAi/GdG
         mA5g==
X-Gm-Message-State: APjAAAXRPyQ8FnV6DysSLjSQvuqpWBN6tVh5TPK9B0Eem3xIjDqSmFCN
        a/fgGQazy1zH6sjiNPRD9RzAvnTcakIh3Vbp3d5u7w==
X-Google-Smtp-Source: APXvYqx2ybWpYPwIq4K6fhGYzVTZe73DZMxgGHU5EeSbczYBSgiPPkUk+5T39J/8EarC1uRNV7fEZEBGY1VHl/r+Nc0=
X-Received: by 2002:a25:7ec7:: with SMTP id z190mr23994840ybc.364.1579190875278;
 Thu, 16 Jan 2020 08:07:55 -0800 (PST)
MIME-Version: 1.0
References: <20200113172711.122918-1-edumazet@google.com> <CAE_XsMK1B+6FdmM1oNVJ4QnuPUZv5FxOh135TmZtfqPFXDLodw@mail.gmail.com>
 <CANn89iKMw-ucEyFfi3o08rVb1Stmt9zpTx4KhRQNa+cxP8tPxw@mail.gmail.com>
In-Reply-To: <CANn89iKMw-ucEyFfi3o08rVb1Stmt9zpTx4KhRQNa+cxP8tPxw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 16 Jan 2020 08:07:43 -0800
Message-ID: <CANn89iJ6pWQxmWqgTBtdCo4xbdbjR31cFZS0yVnoEiTKZ3XT6Q@mail.gmail.com>
Subject: Re: [PATCH net] net: usb: lan78xx: limit size of local TSO packets
To:     James Hughes <james.hughes@raspberrypi.org>
Cc:     netdev <netdev@vger.kernel.org>,
        RENARD Pierre-Francois <pfrenard@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 8:05 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Jan 16, 2020 at 6:26 AM James Hughes
> <james.hughes@raspberrypi.org> wrote:
> >
> > Following on from Eric comment below, is this patch suitable for the
> > forwarded packets case? I'm not familiar enough to be sure, and not
> > aware of any way to test it. I've testing ethernet functionality on a
> > Pi3B+ and see no regressions.
> >
> > Content of format patch of the commit, if it seems OK I'll submit a
> > proper patch email.
> >
> > From b7f06bf6298904b106c38b4bac06a6fcebeee47e Mon Sep 17 00:00:00 2001
> > From: James Hughes <james.hughes@raspberrypi.org>
> > Date: Wed, 15 Jan 2020 13:41:54 +0000
> > Subject: [PATCH] net: usb: lan78xx: Add .ndo_features_check
> >
> > As reported by Eric Dumazet, the driver does not handle skb's
> > over a certain size in all possible cases. Most cases have been fixed,
> > this patch should ensure that forwarded TSO packets that are greater than
> > MAX_SINGLE_PACKET_SIZE - header size are software segmented and handled
> > correctly.
> >
> > Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
> > ---
> >  drivers/net/usb/lan78xx.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
> > index bc572b921fe1..3c721dc1fc10 100644
> > --- a/drivers/net/usb/lan78xx.c
> > +++ b/drivers/net/usb/lan78xx.c
> > @@ -31,6 +31,7 @@
> >  #include <linux/mdio.h>
> >  #include <linux/phy.h>
> >  #include <net/ip6_checksum.h>
> > +#include <net/vxlan.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/irqdomain.h>
> >  #include <linux/irq.h>
> > @@ -3733,6 +3734,19 @@ static void lan78xx_tx_timeout(struct net_device *net)
> >   tasklet_schedule(&dev->bh);
> >  }
> >
> > +static netdev_features_t lan78xx_features_check(struct sk_buff *skb,
> > + struct net_device *netdev,
> > + netdev_features_t features)
> > +{
> > + if (skb_shinfo(skb)->gso_size > MAX_SINGLE_PACKET_SIZE - MAX_HEADER)
> > + features &= ~NETIF_F_TSO;
> >
>
> Here gso_size is the payload size of each segment (typically around 1428 bytes)
>
> What you need here is testing the whole packet length (no need to care
> about MAX_HEADER btw)
>
> Also prefer ~NETIF_F_GSO_MASK (otherwise IPv6 will still be broken)
>
> if (skb->len > MAX_SINGLE_PACKET_SIZE)

And it seems you need to account for TX_OVERHEAD (8 additional bytes)
that are added later in the ndo_start_xmit()

if (skb->len + TX_OVERHEAD > MAX_SINGLE_PACKET_SIZE)
....

>     features &= ~NETIF_F_GSO_MASK;
>
>  +
> > + features = vlan_features_check(skb, features);
> > + features = vxlan_features_check(skb, features);
> > +
> > + return features;
> > +}
> > +
> >  static const struct net_device_ops lan78xx_netdev_ops = {
> >   .ndo_open = lan78xx_open,
> >   .ndo_stop = lan78xx_stop,
> > @@ -3746,6 +3760,7 @@ static const struct net_device_ops lan78xx_netdev_ops = {
> >   .ndo_set_features = lan78xx_set_features,
> >   .ndo_vlan_rx_add_vid = lan78xx_vlan_rx_add_vid,
> >   .ndo_vlan_rx_kill_vid = lan78xx_vlan_rx_kill_vid,
> > + .ndo_features_check = lan78xx_features_check,
> >  };
> >
> >  static void lan78xx_stat_monitor(struct timer_list *t)
> > --
> > 2.17.1
> >
> >
> > On Mon, 13 Jan 2020 at 17:27, Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > lan78xx_tx_bh() makes sure to not exceed MAX_SINGLE_PACKET_SIZE
> > > bytes in the aggregated packets it builds, but does
> > > nothing to prevent large GSO packets being submitted.
> > >
> > > Pierre-Francois reported various hangs when/if TSO is enabled.
> > >
> > > For localy generated packets, we can use netif_set_gso_max_size()
> > > to limit the size of TSO packets.
> > >
> > > Note that forwarded packets could still hit the issue,
> > > so a complete fix might require implementing .ndo_features_check
> > > for this driver, forcing a software segmentation if the size
> > > of the TSO packet exceeds MAX_SINGLE_PACKET_SIZE.
> > >
> > > Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Reported-by: RENARD Pierre-Francois <pfrenard@gmail.com>
> > > Tested-by: RENARD Pierre-Francois <pfrenard@gmail.com>
> > > Cc: Stefan Wahren <stefan.wahren@i2se.com>
> > > Cc: Woojung Huh <woojung.huh@microchip.com>
> > > Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> > > ---
> > >  drivers/net/usb/lan78xx.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
> > > index fb4781080d6dec2af22f41c5e064350ea74130b3..75bdfae5f3e20afef3d2880171c7c6e8511546c5 100644
> > > --- a/drivers/net/usb/lan78xx.c
> > > +++ b/drivers/net/usb/lan78xx.c
> > > @@ -3750,6 +3750,7 @@ static int lan78xx_probe(struct usb_interface *intf,
> > >
> > >         /* MTU range: 68 - 9000 */
> > >         netdev->max_mtu = MAX_SINGLE_PACKET_SIZE;
> > > +       netif_set_gso_max_size(netdev, MAX_SINGLE_PACKET_SIZE - MAX_HEADER);
> > >
> > >         dev->ep_blkin = (intf->cur_altsetting)->endpoint + 0;
> > >         dev->ep_blkout = (intf->cur_altsetting)->endpoint + 1;
> > > --
> > > 2.25.0.rc1.283.g88dfdc4193-goog
> > >
> >
> >
> > --
> > James Hughes
> > Principal Software Engineer,
> > Raspberry Pi (Trading) Ltd
