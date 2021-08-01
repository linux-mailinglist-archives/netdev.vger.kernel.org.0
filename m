Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF3C3DCCDA
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 19:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhHARNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 13:13:01 -0400
Received: from mout.gmx.net ([212.227.15.19]:50781 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229680AbhHARNA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Aug 2021 13:13:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1627837961;
        bh=xtUEr+ekAW0WAiuNsLNrEiRPpwS+f47iJkTrheQXOVM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=Op97yEQA2weqmNoErqEAF+rCg9pYtKEDJdET5VzRiFxIJIbha5eZg9ag5/scZhldC
         KZXlsJJa0iv4X+scnxsXTFpSSCPKONA3ggVgqaLU9jFQOgNLyxp871U8pmP00R7OAh
         HTNtp5tSEOnmPU9jrBYc4hmSrE0rk1VzHKH/Q5gQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.150.72.99]) by mail.gmx.net
 (mrgmx004 [212.227.17.184]) with ESMTPSA (Nemesis) id
 1MOA3P-1mYdeq2whN-00ObJ5; Sun, 01 Aug 2021 19:12:41 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>
Cc:     Len Baker <len.baker@gmx.com>,
        Yves-Alexis Perez <corsac@corsac.net>,
        linux-hardening@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net/usb: Remove all strcpy() uses
Date:   Sun,  1 Aug 2021 19:12:26 +0200
Message-Id: <20210801171226.17917-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:aNEQxA0ncX6BkzImAoKubQRd2aRGPwbNk6UwMdO1UGBgXm4JR/q
 s7jZaI5ya4z3C8KMGVy16qTHerJs8h5tJNbdqnKnVzsdX2Q3eRoB2y6/cOaOzfNvVO95JXF
 zB/a+PcJZzOlBWbItmqkWolUWOkezhcHEbmJQcJHzei5qv6sh8khP0kaVBHpFampgts5mgH
 Y89YuxNdWXU52hqJ3IBFA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:i2ZRFUa/4II=:xASLozsIXLy0ysItC9gDuV
 cKYL8mwceJg1AnoTtgpb1W/cUsQq8g0bX9/6FYl8r1IxR52w/z4cRGRGVDgg74usvpw2SfM5I
 3k3p/pxohD00oMBmcKvkiBE794GfkaeeyDEGlX4mN6adZN4dgfyywn3KVPI3/rGl6nVrI77i8
 PuSRQNN88tZTBQe9qTsayFAWwiZFtMj2bynfZu0n/CI5fNCRu9Bn9M7aViogfMIPs1xRW9ITv
 FWPEdohjWB3s1uDxhzbBYSsHDIXFAfWjWozBxAah1qWMs34/5mhwQNOKNxBbfbsCS2esMFLTf
 btcJpzVGoelMO5jUHTS4X2GpofBqkcEjqeXpDbBXK2UsyHyw1lupD4q83AV/Hzg4EgxmX96Sd
 iJP/Fsbl4UTsKYCMjKZAWavVCEYUd8KgiifSCfONKkruTrdtuRHh8qt7Mi82j70Eye32+ZEgz
 odHnvpO/zMXroHfiBVPcOe1WzJUBT3+vr/YqE87v2QGfteaczhDM665asqTC5ECyB+GsSqvek
 OBIVfuCXgevT9ctdcAEMWzTON9Og/+o91HIlhkP8w0x1MEsOJjOLckBqAn5D2Xso3mEchVkXS
 rgo/0elfuGnS8XJQy3QFJzErwMQxRInqlYsewNCJVLTS28DdCYkxyd4mD2pCOA46RZdfGtv4G
 Sa2K4gxjBrsG3jQ0kgmugH5kDQtBr5hjmK9+XAh4zAgd8LhOF2VQVboyb+ylKbtzVN68bk1YZ
 u1q0ao7lOpQJJnrWVinq7yuYyX8cZyJLdzges90bZTfCzBhClY5xOYyCPB3Wn1aEO8EtI0fmO
 Cs930I4izqh1nW4doeol1jrgDHGe7Bf0HvvNRE2XD+QXhz7zod0a3xJJ1m+hE/p+oLTMdGxgd
 p+wZue4iscbHXnAKMmWUF74NxPfpTnioUPs4+wfurBrHKlXzBAQgcRi6TlhDu3NHDH8tl1b5z
 SGA7rdZuSxJdJXNeWRv4QXjFdWO5bG39CjXKiELZk9h44IqGAGG9RWkeWvbH57gHZi+aPolCZ
 SoIp7zRFFbCQl10u9Rs9F/fQrAcYvgJVng/AYM5mLFHRQlpgEFKFu6/3Eho77zFKM7wL6yOTH
 gA0YSu+C1slrvDNNIa8lwHG8dTRc0hqEb5N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

strcpy() performs no bounds checking on the destination buffer. This
could result in linear overflows beyond the end of the buffer, leading
to all kinds of misbehaviors. The safe replacement is strscpy().

Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
This is a task of the KSPP [1]

[1] https://github.com/KSPP/linux/issues/88

 drivers/net/usb/ipheth.c | 2 +-
 drivers/net/usb/usbnet.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 207e59e74935..06e2181e5810 100644
=2D-- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -443,7 +443,7 @@ static int ipheth_probe(struct usb_interface *intf,

 	netdev->netdev_ops =3D &ipheth_netdev_ops;
 	netdev->watchdog_timeo =3D IPHETH_TX_TIMEOUT;
-	strcpy(netdev->name, "eth%d");
+	strscpy(netdev->name, "eth%d", sizeof(netdev->name));

 	dev =3D netdev_priv(netdev);
 	dev->udev =3D udev;
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 470e1c1e6353..840c1c2ab16a 100644
=2D-- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1725,7 +1725,7 @@ usbnet_probe (struct usb_interface *udev, const stru=
ct usb_device_id *prod)
 	dev->interrupt_count =3D 0;

 	dev->net =3D net;
-	strcpy (net->name, "usb%d");
+	strscpy(net->name, "usb%d", sizeof(net->name));
 	memcpy (net->dev_addr, node_id, sizeof node_id);

 	/* rx and tx sides can use different message sizes;
@@ -1752,13 +1752,13 @@ usbnet_probe (struct usb_interface *udev, const st=
ruct usb_device_id *prod)
 		if ((dev->driver_info->flags & FLAG_ETHER) !=3D 0 &&
 		    ((dev->driver_info->flags & FLAG_POINTTOPOINT) =3D=3D 0 ||
 		     (net->dev_addr [0] & 0x02) =3D=3D 0))
-			strcpy (net->name, "eth%d");
+			strscpy(net->name, "eth%d", sizeof(net->name));
 		/* WLAN devices should always be named "wlan%d" */
 		if ((dev->driver_info->flags & FLAG_WLAN) !=3D 0)
-			strcpy(net->name, "wlan%d");
+			strscpy(net->name, "wlan%d", sizeof(net->name));
 		/* WWAN devices should always be named "wwan%d" */
 		if ((dev->driver_info->flags & FLAG_WWAN) !=3D 0)
-			strcpy(net->name, "wwan%d");
+			strscpy(net->name, "wwan%d", sizeof(net->name));

 		/* devices that cannot do ARP */
 		if ((dev->driver_info->flags & FLAG_NOARP) !=3D 0)
=2D-
2.25.1

