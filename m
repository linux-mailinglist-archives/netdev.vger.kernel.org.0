Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D19ED98504
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 22:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730272AbfHUUAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 16:00:48 -0400
Received: from mout.web.de ([212.227.17.11]:36649 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728231AbfHUUAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 16:00:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1566417621;
        bh=UhJ5i7TA1V0uuPUEJy3RpLR3oAsEV5c3daK+sRLgryc=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=Uk8PJJPceFLQVrrW11QgDdA7pZbQcmr1waaerb+4a20Ee4cHWaIh6BPUaEkxmMjHB
         eLWXDBT8M9F8ZBEq6P2i4D0/wmWpWua1OcQvo1Dyj17dw+K0TwyapajyANjVu/OYBC
         VHQT1NVJ8/eyPn6JTX8/MFrcDTk1d9RCKBOnDROM=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.9.44]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0Lr2dj-1iVTk60KkV-00egv3; Wed, 21
 Aug 2019 22:00:21 +0200
To:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        Allison Randal <allison@lohutok.net>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Richard Fontana <rfontana@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: =?UTF-8?Q?=5bPATCH=5d_hamradio=3a_Delete_unnecessary_checks_before_?=
 =?UTF-8?B?dGhlIG1hY3JvIGNhbGwg4oCcZGV2X2tmcmVlX3NrYuKAnQ==?=
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <61fc7b82-dbc0-93e4-bf43-9856eb4c6688@web.de>
Date:   Wed, 21 Aug 2019 22:00:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:C5op8ec1ZG6f10wzneSxJYJOWijCKZevj2CyHL3ZNPOKGNKH9n2
 xQAKyQ79n0/m0cnjLjVhVgTEFhf1xynQLpK9FRx+Ek1aNAV/42kvpPe+Mtbjc5qmll1kUrp
 yb02DDmnc9AzagCHLymkvcXf2Umsa1XU1lbhTC1F7zZg98qkRTdrpYIFLpT9znmAprH26hv
 JoCO577L86mOpjX2fdD9g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4+phC+F1Jmo=:0Ag5hNhC1LhU3cJoxwsR7n
 QCg2Ljhxudp7Y47tQ2fLs58W/k16LPUyrPL3DL8zXohxeLdygEt1+Mst4p+iqOLLsMG1Q8dBV
 QEo+XDOo9NMHI89nBH3/+grHPKNTZPR39P1/nbXR4g2kNN8b8BX86Oj2YT3kRYoB9upIL1JNP
 njFYjAz/0f1Vu6q8KHddWW+FRySapY8azNlh5MLYQSUa+wKAh3kLu/RoheSS98+UuWFhs5K1O
 5lcgat0lNzwBl7Vytj7Eku5LokNxLkmPKihqSrAgAq2gMP2U+lVXOzFxqr5MTJhcnaVVh2sMe
 pn+1yiKbgTG70lk4+VepL+4MYMJvErIuS0ljZrWu3+5EoHC9z3uHHzNM777MARqBMpIgzE6vm
 6GcWXWrubPzhF4+2xDzJ2EsB3SQGB5TYWzc7mPWuYCy/HMg23ECKTgmuZmoQVx2TMF1FHZDFq
 Wdh4IuA7mYK9GnzM5tFqvqRgj5ozph89ZtW9PzrM6zKu5HddmiSVQzIOoyvIqDtqTQCwytelW
 sCAYi9y2VgpCcvlSYBnvOcsz1RbxhhzO7nTZk4jsnV3Z1MnI2+tQaVbMmcpIVvfMrcP29F+dQ
 xJJKoTTwIGzSqePN4MEo44j91+xLb2ITVoW8iJM7AoVb0pb19AOmVm31DqT2IiqcNGgTR/UQU
 6Nb3fV/Aeytt71hB+M4rtcYy8BU761PG2U1moqojKNPbfgMdi3OiKlyFwXu3+hHDKK6fvlvX+
 9teCoZnUTa75HAsOCUSTnxTHaqP6q/OoBVnq4+oyDr3KJROuMhFmR1hT1BZViwxncVRDA84YQ
 7P/3GrKfsYKPyMG80nBEZr0u+irLEQ+n51AesV9P+nIKvhrBXyDQf/Gcao0P+LMofcxHyHoqx
 HrPprs56m7FtQjPwtmaJnBtClgYCao9cc4vBAdcfxMXPwlDa/9f7iK7BfnShTz6uJQx1u+O6m
 52Z6QOrKcUL/XnJ2O7Lxc4MXsVodBVhzBu3EnSZZD88H9oKgkXKbJjUt5PLnBsgQOdRCmrfSS
 crHQVAU+eg/ydJYI0A7UNxepZcmvW1b3rCiyAhE+DLqcdSHJph5knVfwEozIQZp+CURRHg5iQ
 CADIMznYhLw46xmVOwf8jNN9mYnZcY+hrQ/Sw9mV9coWHkejNOe32UZB/dn7VNoRdHx8cKT4s
 i/ArtGYJwadFMjcjNiVkUnQUGoAzeEjw0vzGVdVNQsoMQFaQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 21 Aug 2019 21:48:46 +0200

The dev_kfree_skb() function performs also input parameter validation.
Thus the test around the shown calls is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/net/hamradio/baycom_epp.c | 3 +--
 drivers/net/hamradio/hdlcdrv.c    | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/bayc=
om_epp.c
index 9303aeb2595f..4476491b58f9 100644
=2D-- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -961,8 +961,7 @@ static int epp_close(struct net_device *dev)
 	parport_write_control(pp, 0); /* reset the adapter */
         parport_release(bc->pdev);
         parport_unregister_device(bc->pdev);
-	if (bc->skb)
-		dev_kfree_skb(bc->skb);
+	dev_kfree_skb(bc->skb);
 	bc->skb =3D NULL;
 	printk(KERN_INFO "%s: close epp at iobase 0x%lx irq %u\n",
 	       bc_drvname, dev->base_addr, dev->irq);
diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv=
.c
index c6f83e0df0a3..df495b5595f5 100644
=2D-- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -475,8 +475,7 @@ static int hdlcdrv_close(struct net_device *dev)

 	if (s->ops && s->ops->close)
 		i =3D s->ops->close(dev);
-	if (s->skb)
-		dev_kfree_skb(s->skb);
+	dev_kfree_skb(s->skb);
 	s->skb =3D NULL;
 	s->opened =3D 0;
 	return i;
=2D-
2.23.0

