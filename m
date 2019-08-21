Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E77698492
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 21:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730555AbfHUTc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 15:32:59 -0400
Received: from mout.web.de ([217.72.192.78]:56811 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729847AbfHUTas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 15:30:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1566415815;
        bh=3lpmHRFKH7F6csdOCSSofXDaB6xUBXTTVPtUFzk3mTQ=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=Q+kKxxvSwaDq2hNsdqqQrOm0qV1rsKFBiQ7a1GulpVT2UVzmbzl7oh3lKHKkt6M9z
         E6d3O3w/XwSZErQI3NY7EW7gG7i9JmKCNISmfMyhtvU4gYX5PIdoLGLeHzenYBi61N
         cwZsSLQzkC8FCf9M28INRuUM3S7LCZEMxN7mzz7k=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.9.44]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MFc1h-1i3Z7j3v5p-00Ef3a; Wed, 21
 Aug 2019 21:30:15 +0200
To:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Allison Randal <allison@lohutok.net>,
        "David S. Miller" <davem@davemloft.net>,
        Enrico Weigelt <lkml@metux.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Lukas Wunner <lukas@wunner.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sean Nyekjaer <sean@geanix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Weitao Hou <houweitaoo@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: =?UTF-8?Q?=5bPATCH=5d_can=3a_Delete_unnecessary_checks_before_the_m?=
 =?UTF-8?B?YWNybyBjYWxsIOKAnGRldl9rZnJlZV9za2LigJ0=?=
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <27674907-fd2a-7f0c-84fd-d8b5124739a9@web.de>
Date:   Wed, 21 Aug 2019 21:30:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3UUCaBDFFXjC3jkkiegfpEDT3e0kV/rF33z4mztvCPFs1e+I4pH
 zE8g62+GO6s/2u/BI4gYuH9TCH3+5p+Dx3QormIx/6A8L4RBX8L5Z7vvvuMPXZN72tXg8mr
 r9cN2+Bsoy2dtsuafeNJ/xmo9CCpg6dTQWouoQYc3OXtPMPU0OeJ3kq5tG+I47JVIzuCys+
 6uiya24Xc8uHJnkoi82yQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:mABiV/a9xtY=:gyp8l8IKQUYwASclxPRe5P
 CUhnE9HbmTH6u7c7VY6vQbal2VQKbfh9lBTQo6pB4ekLGFDQrCTG1p4Q1BFRhKGXdVQc8ZsAL
 BySH2RUwLNKhv39T7nMGa/Wvuju71HwZgn/qNQgiV4liV0Dfntf0XuZ1JykeqASgFGXzurcJD
 vmd/DbQQaVBm9y3LxWYGbDdBl3/eFV/TZs0QCmkTNtg6LX6BxZLzMsDqCkRa5Ly0++C9b+3Un
 WxpvT1s+ZOCTZ0MHa5/VHecliRKqYSRFKokrJt+yaT+MF25i8QuTI8HbtRbYe2CzpOJkpNIIT
 TpaH5NpAQWPvU6YhiWnhtagTyjglB5K2jfPAXcAhAjy9bqAQ0duFVepHIx9FWnMH6boID1WXz
 L5pSaRqa4jL6pr4upr2BDs2dDleRqvO/SYbq1VryW6XIg486L8pO2Pgt7ory4N5lN64sRkyMY
 yXUUvGByATsTEHIYQS5UX61ReJ9Hho+iSOf377Yn7KEY4i+ycXvQFcesMJD+PREcOQN/f4z3V
 H9zWkdJ/rYB7Q5NdegrMDGhrxfe1sNT3YGaK/JApHWNJXmUBPhOswm4OqnLaMioVX3RqH+4hD
 nvhF7J/4yTkCP5zZ7uaSmpN1XFDlX6Qsl11rrcaHo6BIKBEX6dlsLFmFmAuByrbs51gSLLWiN
 omPPXpNGccAboqcOUc8+n3qpxiPPKFdBgzzFtOVAMoMVb2QIwibKC8Z/de5EOQV7eYOOXpJVE
 IjjaXGGDAe8tq1w/JBCICAQnxYZHRtvP/dgFCQjol4OsinzryAOXN3ayuLiS9nilpwQdTWRnN
 M/2KL0mkyTyHQtVy6G4+yth8+4x2yb9mKACakfpdVtsg1zuS0UEuxBsHMiC2REKZK/soASgHk
 Zp0+p6UoNXMSBS9soIuC53Eg5jQ1fFQDaDYip4uimylmQ6sIjCu9VL75Qdd1NAQXl9699GZ3H
 Vt1++gPq4TZjLwfbCM/V0mLINvMeoK1vyo7eyB4g0G4+VKlqhC5xfUiTLod+PBbTPcJXmOo0W
 KlW1b49m7PoZsz6YZwp13M57WfYwrTcMFBak/ajqfy9ugcnEKAAeetHBQ2dMpNWS61nCPzz5Q
 Yn4m0KNZdGtfsS/On2aojRkO08/vcGy5mxX6hAErOZGV+0q8/zKXT9aohsLdDzjBSPE3yiqRn
 43d5g=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 21 Aug 2019 21:16:15 +0200

The dev_kfree_skb() function performs also input parameter validation.
Thus the test around the shown calls is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/net/can/spi/hi311x.c  | 3 +--
 drivers/net/can/spi/mcp251x.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 03a711c3221b..7c7c7e78214c 100644
=2D-- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -184,8 +184,7 @@ static void hi3110_clean(struct net_device *net)

 	if (priv->tx_skb || priv->tx_len)
 		net->stats.tx_errors++;
-	if (priv->tx_skb)
-		dev_kfree_skb(priv->tx_skb);
+	dev_kfree_skb(priv->tx_skb);
 	if (priv->tx_len)
 		can_free_echo_skb(priv->net, 0);
 	priv->tx_skb =3D NULL;
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 12358f06d194..1c496d2adb45 100644
=2D-- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -274,8 +274,7 @@ static void mcp251x_clean(struct net_device *net)

 	if (priv->tx_skb || priv->tx_len)
 		net->stats.tx_errors++;
-	if (priv->tx_skb)
-		dev_kfree_skb(priv->tx_skb);
+	dev_kfree_skb(priv->tx_skb);
 	if (priv->tx_len)
 		can_free_echo_skb(priv->net, 0);
 	priv->tx_skb =3D NULL;
=2D-
2.23.0

