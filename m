Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB8822430F
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgGQSWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:22:02 -0400
Received: from mout.gmx.net ([212.227.15.19]:52171 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgGQSWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 14:22:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1595010112;
        bh=EApLx+17E+EoSzjy7BnwJMd4tAGAvlBm62Q1cL1lhAk=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=hUmd/RP1AOub48SPzv7wntaZQIUXk2ypYnko0Uq+Mgw8C2IU0RZRUyJXKCiNOPBar
         thkRAHWMC+Xcb496gEfvv4r9bwfRQii5cTH7tIctFgwsi0T6PM8UQXaVWP9npay9S4
         nq207HaoZ0CXBXflLRK9OKz6jD7u9hLGIEwoE6vQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd ([84.154.209.231]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MBDnI-1k96SM0PaI-00Cjdm; Fri, 17
 Jul 2020 20:21:52 +0200
Date:   Fri, 17 Jul 2020 20:21:48 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] ne2k-pci: Use netif_msg_init to initialize
 msg_enable bits
Message-ID: <20200717182148.GA4905@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:fJKLG82cRwJJgqBxWQrH1e7irdAk6d3gs8D9Qn5NeHb2jD/Ku5m
 wRe2vQVYEOF7pGj8R1MX2QuZxGyDHZYzkklRZ4GrM0Y3JIvXqLYDmYndH2cUfGnOYtMTpxA
 XBqU/lDglvBP7F1/jCOlP8sH99l6qxyC7A0wfCJ6BYo47S9z/JIz/gKyQY0+sleJbfAJZf5
 xqCmP1vOlxvmAOHSzzd1A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:s5CnKN7x6Lw=:SnDs89ItbKeMXtr5Xpoklt
 CmV3rvJOoaiuW6dOMINQV1NM5jhwBiU01qcNdH8Et+mXnPNVQLZOE4j+xvrt/faj7FMmmTBTp
 3N2kXdPgZtQ0i4/d2AYOeW1FRp7J10FVuy1IarwxyhnAd1ZNbS3Cq6jVedn889w7u2LzUoDHI
 D8e5qJLU+43D9z0UTGBrrVC0LRiNl+DfXdJX+28MjxGMDH3cuf0pofCiUoQWI71/waq683kWs
 zyHijB0d1BAcsaHUGT7chHyQcm/f9M+ZX79GyCYNiowE+tJNAkMiG5kmxUiin7T0/9hbzuoyu
 +WjRRe9Ad5OTkh7OaKxprYnhAo59KrOFktnNV3rPVeH/Gws8vKaR2JmUX1ECaC5PcespagZGg
 +cG4JtPzyIolOkBincK4X0VX6HpHIk+CDEMY5nNgZ+w0+fkg93sdnyxDxf5dBVhQTbjNLH+Tn
 KjF4LGzpGJOheMafZKKKquD6syno3C4+gsEI9EJ0uFg48s3wPIKuV4CgMa4HOk7JGdypYOxc8
 3p8XVwOCjI2dFo7XRxbzw0P+FpWHDCzUHsyCaYfZsUM2/aNEtNbcwFtwdUVv0Vb0LlSyq27Px
 xkgrMxLLAAuGesQtESTa/H6dWpMHtC0QwdqTaAHaPx6/3dFXxL+KV7JVkaxlZAwcv64rxWHjA
 TSxBG38lq8Jx08gGZVAYi/uKwQ1KO1pvmzjpQth9Tdub5FIl4fLyst+c+Zv8bEg0rPAPE2Bat
 32GDDp7QbSwtJoO0ylghR83E21DCln7ih9pLckjmTa1lp0LUh9H/oy8tOSmibdNUyl/cBYaTv
 yDwOlwS+Ie6bkYSrS9xT7CRuMzywned+yanWM5Qr42Lz+CSNX18ZO2AvbX+Sa1M/bEXXZNlNb
 qHl2v/fVAxTnw/CIn5sru4iwu23ndAsCm4h8aKSK+VuxndCo3M3CEZxeNmJYJmixsFO3Xbt9c
 y3jw3eSUvQ/Z2USFbSu2PetudtvGx1MhCvWgZtW5CGWldLv+yRtbPXux/lZzazCI2ib71JlcA
 klPpSdk26wLL0l6vmMIgdCBCqMsGyK7kLy7FDmQouZKWe3rsCaZ00fXWLSkeQHsvY6shOJqir
 Ej99e9NE8OqXGTkoQafPVswjlHGa0X2KXM54Pr3f0HboJ9fVtnXr29uF3LEg5juHoIs7wRiHr
 4YEEokpRpVWa3zwqL0c2L2gmux2QJQzKfO1SjZFo6kQjXmMfx8A0hjQJw+QsVVLjtbpFHheCt
 Po6bJyd57L+D3CyEr
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netif_msg_enable() to process param settings.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/ethernet/8390/ne2k-pci.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/8390/ne2k-pci.c b/drivers/net/ethernet/8=
390/ne2k-pci.c
index e500f0c05725..bc6edb3f1af3 100644
=2D-- a/drivers/net/ethernet/8390/ne2k-pci.c
+++ b/drivers/net/ethernet/8390/ne2k-pci.c
@@ -62,7 +62,10 @@ static int options[MAX_UNITS];

 #include "8390.h"

-static u32 ne2k_msg_enable;
+static int ne2k_msg_enable;
+
+static const int default_msg_level =3D (NETIF_MSG_DRV | NETIF_MSG_PROBE |
+				      NETIF_MSG_RX_ERR | NETIF_MSG_TX_ERR);

 #if defined(__powerpc__)
 #define inl_le(addr)  le32_to_cpu(inl(addr))
@@ -74,7 +77,7 @@ MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL");

-module_param_named(msg_enable, ne2k_msg_enable, uint, 0444);
+module_param_named(msg_enable, ne2k_msg_enable, int, 0444);
 module_param_array(options, int, NULL, 0);
 module_param_array(full_duplex, int, NULL, 0);
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h =
for bitmap)");
@@ -282,7 +285,7 @@ static int ne2k_pci_init_one(struct pci_dev *pdev,
 	}
 	dev->netdev_ops =3D &ne2k_netdev_ops;
 	ei_local =3D netdev_priv(dev);
-	ei_local->msg_enable =3D ne2k_msg_enable;
+	ei_local->msg_enable =3D netif_msg_init(ne2k_msg_enable, default_msg_lev=
el);

 	SET_NETDEV_DEV(dev, &pdev->dev);

=2D-
2.20.1

