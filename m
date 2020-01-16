Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 451B813DD5C
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 15:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgAPO0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 09:26:44 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44349 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgAPO0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 09:26:43 -0500
Received: by mail-ot1-f68.google.com with SMTP id h9so19444813otj.11
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 06:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tciukWlTb/mGTCXlGLFSDCZEjCRr1mm8EZtYNHOEM3o=;
        b=H7ldjFHqZoPvalX/H6DVnF3f3zSkg/vv2XwjRNBYzjKYQKBQJYMDNB8UwadoXsm4tC
         TzefIG8QqpqRUldXjXuHq/99u2xnWBZbyhLT20Dd2DUbaCwNLSMv/5khRbadMxkfiXSA
         37s4FbHC+oMGpkA+aoah+CnJNgi/tyligv0N/kSHEX/zZDbR+TgJpb4+oOBIfuIhfRGU
         ndTJt1NJfI+9GN9MkYuGka1TN5JprgZXuZRZqcg8wuzjiars8+xyNI5pgEjHGrKxVeaN
         L24MiKrC0BKsppr1bNn7Krq47Uho0weDWyOZeAh/EHkZ42h7IHPdYLVx6RRN4PgBvSO+
         eBkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tciukWlTb/mGTCXlGLFSDCZEjCRr1mm8EZtYNHOEM3o=;
        b=ABzqv8OffiZdHg9GGdKI4V7xZrXpBXl9mzIWOYQLnIFX4BHUosD4UF1fMt+yl4a+0D
         VFeOT+0etSgagIkiyiy+6m2zJn0tn/U3qfFT8zqKDtJlnnwGG158O8NuEg+TTTRwRdqE
         ujTscGChtAZB6qWfhvnUzEMYTM3GLe6aW6lEGaH9T+vbZ2prxVKPf7fhYluJxE4tFNcc
         thfsMkrbgiMB+InnFp5AGq6WsyuDlYjx5lSiCtH6wuqWoOJzegxfXBnmEhq/aWpY/SW0
         fL1cCXszolfSsBGCxli4Y1Jx4elwxNkBSCjdmyCbRtYL/s/4GtTPd5ve7bChJNlvF491
         VXFg==
X-Gm-Message-State: APjAAAWEr1mjYzDmBWpiTEpG9e8S02RhHoSB8FKA8JvdGmVTL4ZXHL9v
        mxWbSTN9I4RsJh5iGBHoDO23HUn1oPY430FFZLQ4vg==
X-Google-Smtp-Source: APXvYqzIvLLLmTaU3bWmHnrela//z06vxWkECVOVsarr784aGRRhgI7sx66I5LULARUtSpT+YmqDvifXfD6R3Eqd5UU=
X-Received: by 2002:a9d:6398:: with SMTP id w24mr2104415otk.15.1579184802470;
 Thu, 16 Jan 2020 06:26:42 -0800 (PST)
MIME-Version: 1.0
References: <20200113172711.122918-1-edumazet@google.com>
In-Reply-To: <20200113172711.122918-1-edumazet@google.com>
From:   James Hughes <james.hughes@raspberrypi.org>
Date:   Thu, 16 Jan 2020 14:26:31 +0000
Message-ID: <CAE_XsMK1B+6FdmM1oNVJ4QnuPUZv5FxOh135TmZtfqPFXDLodw@mail.gmail.com>
Subject: Re: [PATCH net] net: usb: lan78xx: limit size of local TSO packets
To:     Eric Dumazet <edumazet@google.com>
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

Following on from Eric comment below, is this patch suitable for the
forwarded packets case? I'm not familiar enough to be sure, and not
aware of any way to test it. I've testing ethernet functionality on a
Pi3B+ and see no regressions.

Content of format patch of the commit, if it seems OK I'll submit a
proper patch email.

From b7f06bf6298904b106c38b4bac06a6fcebeee47e Mon Sep 17 00:00:00 2001
From: James Hughes <james.hughes@raspberrypi.org>
Date: Wed, 15 Jan 2020 13:41:54 +0000
Subject: [PATCH] net: usb: lan78xx: Add .ndo_features_check

As reported by Eric Dumazet, the driver does not handle skb's
over a certain size in all possible cases. Most cases have been fixed,
this patch should ensure that forwarded TSO packets that are greater than
MAX_SINGLE_PACKET_SIZE - header size are software segmented and handled
correctly.

Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
---
 drivers/net/usb/lan78xx.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index bc572b921fe1..3c721dc1fc10 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -31,6 +31,7 @@
 #include <linux/mdio.h>
 #include <linux/phy.h>
 #include <net/ip6_checksum.h>
+#include <net/vxlan.h>
 #include <linux/interrupt.h>
 #include <linux/irqdomain.h>
 #include <linux/irq.h>
@@ -3733,6 +3734,19 @@ static void lan78xx_tx_timeout(struct net_device *net)
  tasklet_schedule(&dev->bh);
 }

+static netdev_features_t lan78xx_features_check(struct sk_buff *skb,
+ struct net_device *netdev,
+ netdev_features_t features)
+{
+ if (skb_shinfo(skb)->gso_size > MAX_SINGLE_PACKET_SIZE - MAX_HEADER)
+ features &= ~NETIF_F_TSO;
+
+ features = vlan_features_check(skb, features);
+ features = vxlan_features_check(skb, features);
+
+ return features;
+}
+
 static const struct net_device_ops lan78xx_netdev_ops = {
  .ndo_open = lan78xx_open,
  .ndo_stop = lan78xx_stop,
@@ -3746,6 +3760,7 @@ static const struct net_device_ops lan78xx_netdev_ops = {
  .ndo_set_features = lan78xx_set_features,
  .ndo_vlan_rx_add_vid = lan78xx_vlan_rx_add_vid,
  .ndo_vlan_rx_kill_vid = lan78xx_vlan_rx_kill_vid,
+ .ndo_features_check = lan78xx_features_check,
 };

 static void lan78xx_stat_monitor(struct timer_list *t)
-- 
2.17.1


On Mon, 13 Jan 2020 at 17:27, Eric Dumazet <edumazet@google.com> wrote:
>
> lan78xx_tx_bh() makes sure to not exceed MAX_SINGLE_PACKET_SIZE
> bytes in the aggregated packets it builds, but does
> nothing to prevent large GSO packets being submitted.
>
> Pierre-Francois reported various hangs when/if TSO is enabled.
>
> For localy generated packets, we can use netif_set_gso_max_size()
> to limit the size of TSO packets.
>
> Note that forwarded packets could still hit the issue,
> so a complete fix might require implementing .ndo_features_check
> for this driver, forcing a software segmentation if the size
> of the TSO packet exceeds MAX_SINGLE_PACKET_SIZE.
>
> Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: RENARD Pierre-Francois <pfrenard@gmail.com>
> Tested-by: RENARD Pierre-Francois <pfrenard@gmail.com>
> Cc: Stefan Wahren <stefan.wahren@i2se.com>
> Cc: Woojung Huh <woojung.huh@microchip.com>
> Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> ---
>  drivers/net/usb/lan78xx.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
> index fb4781080d6dec2af22f41c5e064350ea74130b3..75bdfae5f3e20afef3d2880171c7c6e8511546c5 100644
> --- a/drivers/net/usb/lan78xx.c
> +++ b/drivers/net/usb/lan78xx.c
> @@ -3750,6 +3750,7 @@ static int lan78xx_probe(struct usb_interface *intf,
>
>         /* MTU range: 68 - 9000 */
>         netdev->max_mtu = MAX_SINGLE_PACKET_SIZE;
> +       netif_set_gso_max_size(netdev, MAX_SINGLE_PACKET_SIZE - MAX_HEADER);
>
>         dev->ep_blkin = (intf->cur_altsetting)->endpoint + 0;
>         dev->ep_blkout = (intf->cur_altsetting)->endpoint + 1;
> --
> 2.25.0.rc1.283.g88dfdc4193-goog
>


-- 
James Hughes
Principal Software Engineer,
Raspberry Pi (Trading) Ltd
