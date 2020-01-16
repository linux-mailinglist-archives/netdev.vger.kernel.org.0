Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C242D13DF95
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgAPQFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:05:22 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:35080 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgAPQFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 11:05:22 -0500
Received: by mail-yb1-f196.google.com with SMTP id q190so4725297ybq.2
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 08:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fGcEiYHhzVO82PmGKP17PrR78XJsiKH57a5PJPN0C9A=;
        b=jiO2AxxFgt1tgd0TrLf/liV3yUxKE6gdTtomAfMYjICYsu/7GXlSGUr6PlK5Z9CjzS
         w8rD9pZTUuC2iOWqCl5aTRlAQe8yPZBtk+rhRBP+db1g+szawq+IAJ64+RlinGcttDlQ
         0FcaNsNCM5aMWi9WIVBFykzoibPzoUAimwnBiXrI4NZ2gd1BocQAOEYsWD2WLu9XahGT
         ClEdQOcS8A3qMhBovqizSeaUPDgk7Gww2PRHv0sTJBHJNce8/sOODbtyLXDKeoAuAtN+
         uP4hEPR5CaDZwIHBe1WhZkp7dJ/b3zTNfVkw2R2HB3oz8LB+IbjB3FmeCsLqiAg7jZm9
         kgkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fGcEiYHhzVO82PmGKP17PrR78XJsiKH57a5PJPN0C9A=;
        b=U+SX5RyUaU+wvnLNXtmA1OJaXfnZ9HkLG2EOMR8WjGNoKP4ik2S+wcomxr8pGo0DQx
         XL1uRRgzHJRwVl7wzYb754Sc8yh/CUrSNEHXqJOz2KcHAEC/c4WqA2D/lb3CAOpS2kVJ
         u5VhpT6YyjxZBt/+gwX5ARsJF6g7olTElr9BopKnH1mWskKLBzk/eEeyn5+vpIUH+y16
         jSRQru7574zC6IR4BEuJ4GBdoan8rmESe/2QtMluC4789kvgGcc+OTu0kRoLcK3QbhBl
         zh1d2U2OZL0sfJ+0MxzzI9LreAma2BKPhJySJ3VkSeBMAqdgSzW9kESGaBRDIH2mlXKX
         BhJw==
X-Gm-Message-State: APjAAAVAp+WU0k1ZL4K/lP2QoZqUs19ndDULAFDnLB0LnWIi9/88Gx8p
        /mLD9N+0Ga+HpivUBP4EAbaH3u924bhMUR+uakACSQ==
X-Google-Smtp-Source: APXvYqze0Q8fWqOsYvy4vJatJraQHOBLOf1jF796PwEXsy1IEsL88t8qt/iWCMjjkliFAYo/hyHoWsnsbBYqJgHLZzA=
X-Received: by 2002:a25:8385:: with SMTP id t5mr15404565ybk.380.1579190720178;
 Thu, 16 Jan 2020 08:05:20 -0800 (PST)
MIME-Version: 1.0
References: <20200113172711.122918-1-edumazet@google.com> <CAE_XsMK1B+6FdmM1oNVJ4QnuPUZv5FxOh135TmZtfqPFXDLodw@mail.gmail.com>
In-Reply-To: <CAE_XsMK1B+6FdmM1oNVJ4QnuPUZv5FxOh135TmZtfqPFXDLodw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 16 Jan 2020 08:05:08 -0800
Message-ID: <CANn89iKMw-ucEyFfi3o08rVb1Stmt9zpTx4KhRQNa+cxP8tPxw@mail.gmail.com>
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

On Thu, Jan 16, 2020 at 6:26 AM James Hughes
<james.hughes@raspberrypi.org> wrote:
>
> Following on from Eric comment below, is this patch suitable for the
> forwarded packets case? I'm not familiar enough to be sure, and not
> aware of any way to test it. I've testing ethernet functionality on a
> Pi3B+ and see no regressions.
>
> Content of format patch of the commit, if it seems OK I'll submit a
> proper patch email.
>
> From b7f06bf6298904b106c38b4bac06a6fcebeee47e Mon Sep 17 00:00:00 2001
> From: James Hughes <james.hughes@raspberrypi.org>
> Date: Wed, 15 Jan 2020 13:41:54 +0000
> Subject: [PATCH] net: usb: lan78xx: Add .ndo_features_check
>
> As reported by Eric Dumazet, the driver does not handle skb's
> over a certain size in all possible cases. Most cases have been fixed,
> this patch should ensure that forwarded TSO packets that are greater than
> MAX_SINGLE_PACKET_SIZE - header size are software segmented and handled
> correctly.
>
> Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
> ---
>  drivers/net/usb/lan78xx.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
> index bc572b921fe1..3c721dc1fc10 100644
> --- a/drivers/net/usb/lan78xx.c
> +++ b/drivers/net/usb/lan78xx.c
> @@ -31,6 +31,7 @@
>  #include <linux/mdio.h>
>  #include <linux/phy.h>
>  #include <net/ip6_checksum.h>
> +#include <net/vxlan.h>
>  #include <linux/interrupt.h>
>  #include <linux/irqdomain.h>
>  #include <linux/irq.h>
> @@ -3733,6 +3734,19 @@ static void lan78xx_tx_timeout(struct net_device *net)
>   tasklet_schedule(&dev->bh);
>  }
>
> +static netdev_features_t lan78xx_features_check(struct sk_buff *skb,
> + struct net_device *netdev,
> + netdev_features_t features)
> +{
> + if (skb_shinfo(skb)->gso_size > MAX_SINGLE_PACKET_SIZE - MAX_HEADER)
> + features &= ~NETIF_F_TSO;
>

Here gso_size is the payload size of each segment (typically around 1428 bytes)

What you need here is testing the whole packet length (no need to care
about MAX_HEADER btw)

Also prefer ~NETIF_F_GSO_MASK (otherwise IPv6 will still be broken)

if (skb->len > MAX_SINGLE_PACKET_SIZE)
    features &= ~NETIF_F_GSO_MASK;

 +
> + features = vlan_features_check(skb, features);
> + features = vxlan_features_check(skb, features);
> +
> + return features;
> +}
> +
>  static const struct net_device_ops lan78xx_netdev_ops = {
>   .ndo_open = lan78xx_open,
>   .ndo_stop = lan78xx_stop,
> @@ -3746,6 +3760,7 @@ static const struct net_device_ops lan78xx_netdev_ops = {
>   .ndo_set_features = lan78xx_set_features,
>   .ndo_vlan_rx_add_vid = lan78xx_vlan_rx_add_vid,
>   .ndo_vlan_rx_kill_vid = lan78xx_vlan_rx_kill_vid,
> + .ndo_features_check = lan78xx_features_check,
>  };
>
>  static void lan78xx_stat_monitor(struct timer_list *t)
> --
> 2.17.1
>
>
> On Mon, 13 Jan 2020 at 17:27, Eric Dumazet <edumazet@google.com> wrote:
> >
> > lan78xx_tx_bh() makes sure to not exceed MAX_SINGLE_PACKET_SIZE
> > bytes in the aggregated packets it builds, but does
> > nothing to prevent large GSO packets being submitted.
> >
> > Pierre-Francois reported various hangs when/if TSO is enabled.
> >
> > For localy generated packets, we can use netif_set_gso_max_size()
> > to limit the size of TSO packets.
> >
> > Note that forwarded packets could still hit the issue,
> > so a complete fix might require implementing .ndo_features_check
> > for this driver, forcing a software segmentation if the size
> > of the TSO packet exceeds MAX_SINGLE_PACKET_SIZE.
> >
> > Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: RENARD Pierre-Francois <pfrenard@gmail.com>
> > Tested-by: RENARD Pierre-Francois <pfrenard@gmail.com>
> > Cc: Stefan Wahren <stefan.wahren@i2se.com>
> > Cc: Woojung Huh <woojung.huh@microchip.com>
> > Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> > ---
> >  drivers/net/usb/lan78xx.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
> > index fb4781080d6dec2af22f41c5e064350ea74130b3..75bdfae5f3e20afef3d2880171c7c6e8511546c5 100644
> > --- a/drivers/net/usb/lan78xx.c
> > +++ b/drivers/net/usb/lan78xx.c
> > @@ -3750,6 +3750,7 @@ static int lan78xx_probe(struct usb_interface *intf,
> >
> >         /* MTU range: 68 - 9000 */
> >         netdev->max_mtu = MAX_SINGLE_PACKET_SIZE;
> > +       netif_set_gso_max_size(netdev, MAX_SINGLE_PACKET_SIZE - MAX_HEADER);
> >
> >         dev->ep_blkin = (intf->cur_altsetting)->endpoint + 0;
> >         dev->ep_blkout = (intf->cur_altsetting)->endpoint + 1;
> > --
> > 2.25.0.rc1.283.g88dfdc4193-goog
> >
>
>
> --
> James Hughes
> Principal Software Engineer,
> Raspberry Pi (Trading) Ltd
