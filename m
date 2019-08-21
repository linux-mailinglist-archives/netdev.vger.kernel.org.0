Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39BA19858C
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 22:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbfHUUYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 16:24:31 -0400
Received: from mout.web.de ([212.227.17.12]:47619 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbfHUUYb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 16:24:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1566419058;
        bh=VNQY+ZmbCZzJoVAMnbzoqAo320qHdd8HBCfC8P3oEsQ=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=aR2HO5vCArAroXgeUrYAEDof3jwPLQ4+GRPz0nZmtBfU0GaZ4h4s+R1B9KawBDImi
         JAVXQ/qkgEZavUhye5m+Tn0+zlwJY0j7+ilR+RDLqRZoYJQMGBwX4wnAwcQpUzIqCv
         SycrrTogtL9XbPiWcKJErVy5v165vDXpdnU8f5fU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.9.44]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LpwB1-1iUOWM3bTL-00fnHN; Wed, 21
 Aug 2019 22:24:18 +0200
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Petko Manolov <petkan@nucleusys.com>,
        Steve Winslow <swinslow@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: =?UTF-8?Q?=5bPATCH=5d_net=3a_usb=3a_Delete_unnecessary_checks_befor?=
 =?UTF-8?B?ZSB0aGUgbWFjcm8gY2FsbCDigJxkZXZfa2ZyZWVfc2ti4oCd?=
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <425214be-355b-92c0-bc74-1d0ea899290f@web.de>
Date:   Wed, 21 Aug 2019 22:24:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:jFIJT+Q1Ibe/eal+vXdIE/RL9fhDs5LiS/YB/LPMcccmxCIaowF
 AymYymTWKvlURv0OvC4wVcSuchgR/fli/uf9UxivYf+etVEEY23eE/XhfxuqpGpuY+r94mz
 FG+c/3Egw+pwS98nVplYVkIah2HPQbFwgqSLLfMyWlHOyTrWhIMjMFQI2CpYdlGiBqsCUgB
 deisjnDMiH0p3ZIkdsDyw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:HzLO6KbUB5U=:YUaWhZVedtxrKGftc9oH9Z
 nwa1ox3jY/BFfqc3mv2JaFEgsFaUOiCRUKAzBaNR54MyqAgfPFiN/rgXzujtTtpleVlluON41
 sOgqQGStfpFOq+VzRxWSbnCkOt++8tts6wFlc00KD+qFlvwRMJ2WYcLQmJhvFI5wyvFbpDESi
 fFioWzIb4BH3CzMBJVd2gMYDr4bVitbVATXos3sKremDeOl5yQe2XD22lCEnGoFXDTx4XoKwl
 XzrLUO/TBYgaQjo9znDBNKA3kx4D0M2KgW22mdlPMF4rw0eUGjwfTJPtMTtoB8L5MTVEv6aM4
 x2dElgdDmq/BQBEkdLgBnnn+hT7XcUvRybe75xpHX50WyXPmtVpXU4TVbPRnBV3ox2hk+1PYS
 YBmATmMmqbkdEtoMBZXK+yaKny4Hb0CMFYH0slMqy3KrjfKxa3sG86wL3URSmhp6zbXDb+3jL
 uunRB2heRx1qwBilNkSP8o3E4HLGn3s0WBoLq+nBJ8oggz0RKiAlJ/4aO0RuBru8AHrMiaU7j
 uPobMsKlmaz/1uouvsfmSIlpWGOlvk7Se0efDjCx3XWnikGOL4wkG/n+uygsTR+c7vdwMeh2n
 Rba7gqs8aGhNEBvL0IQgELIllOAyn1DdS6zHDg3qnjUYEJ+9SNCh+5fU2dn3hhpPmSPsaOHe/
 L77nG+vbXyLJGh/Vs5vYqiu1HVVPAGawu3HcSOV0O5a79MxaBqLwm4mIplWYEhH9jqh28uVNv
 R2u7vhJ+1BzxV9U+mSXe3j92rjASQMgt56dJTrZSTyegUysP9TQ07jNAW/SfAsJCWXABEVJm0
 J4KNleb8J8PiBFxN/UtAZv0IwSaEFPU64ftGlQ5R2sfHo4uIS+BQzIQiyHkOnOQ01Cu8XRZf3
 F2PmdCf1NE89PrtZhQ1DY89yqGVBjZFqUGsaDpPMDqpQ/4CLdFZ0edcPLDFbqW8wZBeWokkna
 l/LZXx1O/SNUnU6GnFIWeaj+fNX3QLV+fRErdUWbu/ptWoXowGYmX7EaITGbsvx1nnbUoMcKQ
 6vtEgVou/2y5L16jl0ku4B/ho8ina24hPb7Ge57Jec3LNukpggEk25PZOodOL296ADe7W5cLE
 EfIfyDPecG4Ne6aE490WzagseNgnQ+5aXpjSssrCQJuD9K0+hgEdmeTry2v1XNAaRGFOr2gAn
 LNSHA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 21 Aug 2019 22:16:02 +0200

The dev_kfree_skb() function performs also input parameter validation.
Thus the test around the shown calls is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/net/usb/lg-vl600.c | 4 +---
 drivers/net/usb/rtl8150.c  | 6 ++----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/lg-vl600.c b/drivers/net/usb/lg-vl600.c
index 6c2b3e368efe..217a2d8fa47b 100644
=2D-- a/drivers/net/usb/lg-vl600.c
+++ b/drivers/net/usb/lg-vl600.c
@@ -87,9 +87,7 @@ static void vl600_unbind(struct usbnet *dev, struct usb_=
interface *intf)
 {
 	struct vl600_state *s =3D dev->driver_priv;

-	if (s->current_rx_buf)
-		dev_kfree_skb(s->current_rx_buf);
-
+	dev_kfree_skb(s->current_rx_buf);
 	kfree(s);

 	return usbnet_cdc_unbind(dev, intf);
diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 98f33e270af1..13e51ccf0214 100644
=2D-- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -586,8 +586,7 @@ static void free_skb_pool(rtl8150_t *dev)
 	int i;

 	for (i =3D 0; i < RX_SKB_POOL_SIZE; i++)
-		if (dev->rx_skb_pool[i])
-			dev_kfree_skb(dev->rx_skb_pool[i]);
+		dev_kfree_skb(dev->rx_skb_pool[i]);
 }

 static void rx_fixup(unsigned long data)
@@ -946,8 +945,7 @@ static void rtl8150_disconnect(struct usb_interface *i=
ntf)
 		unlink_all_urbs(dev);
 		free_all_urbs(dev);
 		free_skb_pool(dev);
-		if (dev->rx_skb)
-			dev_kfree_skb(dev->rx_skb);
+		dev_kfree_skb(dev->rx_skb);
 		kfree(dev->intr_buff);
 		free_netdev(dev->netdev);
 	}
=2D-
2.23.0

