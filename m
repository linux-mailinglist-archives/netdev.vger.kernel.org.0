Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C418A2B825A
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbgKRQv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:51:57 -0500
Received: from mout.gmx.net ([212.227.15.19]:56939 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727522AbgKRQv4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 11:51:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1605718305;
        bh=9PdZgdrJapiK1z1oJaC3HBy6vk5e/Yz7ao2IblRp2Dc=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=SM8fZCN6twvwNW4XnkUmYqOiVBtKnPTBWOLGAZ7zwCwQYt9ggEpNmmak17idIegfS
         fTfRnGuWawZVetdeF8N8RNk5SYAmU+LTPBHhGm3q8/eOwy/l7kr7DfUS+lmP4BA/mG
         NPHQyacsBkaPLA1GnPs5EpNnXSbqGpSLgN4hUjYA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from MX-Linux-Intel.fritz.box ([79.242.191.181]) by mail.gmx.com
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MV63g-1kneQZ2wIo-00S7Kl; Wed, 18 Nov 2020 17:51:45 +0100
From:   Armin Wolf <W_Armin@gmx.de>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        joe@perches.com
Subject: [PATCH net-next v2 1/2] lib8390: Use eth_skb_pad()
Date:   Wed, 18 Nov 2020 17:51:06 +0100
Message-Id: <20201118165107.12419-2-W_Armin@gmx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201118165107.12419-1-W_Armin@gmx.de>
References: <20201118165107.12419-1-W_Armin@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:UI0q0o1fkVoauqLNrWKc/F6agW3V0iV2UuMi/0LMCCTB26wksUb
 ZRDTkiyNS6S9NF4iEzTBMRZlT9omszEml8qNgUstMu+QSQXh0lPmBM4LFSix0X6NKbESsYz
 R7gwjvmcaZ15xqLXPvY6WQl7Jyfj9SZPfB58FrCXkHmBtV5gDHHhrWFFvMs1p7wsSRYL/f1
 5smzQ4Flt6uNq0BGNxzmw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Tfm6nAiZ7U8=:y+zhPLvstETBIfcDzByDWr
 aQZVzq6lgFmwEPZmLUACuGY2GRN/dc5Ggu6VY+Y+PHG4t4W+w06XNGMeSnK/wlT+Q15H8TC54
 tGrRpawESKkXcmk6ArATBpGzCvJ19SLAChHw/dgS6SZ+hxyvK9FbyCe0pE7q3MmqzQlbSVvtr
 PLFWKGKOSiy7kO7+4LDpxFEZXPHp4GZkuTyv7TCYi8GDa2JzqhZWNNV6WHOkwLUd3p4TSQIXw
 D2taH4ElmCRa0fIZFFku8T1CR6GfkpiIKntqcCI8JFJ+5tZ2kByct1L299ZRZdLEcDe+v78w1
 KeXEcUavPiPr4AnE+4V4ELIi+WV2puKNxcc3sUh28eTez2rO/B7F5gqUbOOO6h5ZC7CZdAatW
 s4a4hq4i5t6BHka+EgbLsgJGKB3BXGhSBF19EUkd1d95u6vSJ2GB1wMmYx6IeCnCTQi0upkBp
 fJxn6HRiWqOvdnosFoKNQ0pbTq9NGBlsLxt5ynzACoQ7TItJikS5aeZ4HxB47Y93ASS46/CXu
 x2f9Vc0h4fqxLb448vQ7c99TBQbuxtOiTuuLJaXQZP81IKPN6kdMUR6tuqTvHbypMQ7ITt9Mm
 q0OwvAwGwf0sqm+qsnQlVg4TTOJzgG0oDtfL+oaVAmKjfsQYDE/oIif9NWiHN3/Id9kYPwmIj
 ApmkGTjh+HifZGTk+S8JyF5A1H0MjQW/bpZ5uI3B7X3ZQihfsTKfFEL8JSoOpqQlY1SWvgPAF
 jNFf/T8/9yiT7DB5hp7G9/HSNk7jzkdnU2HYhc8ClkrInTPyvtAwU+Wfmg4mVDQB+Wd0r1vEi
 5Ez2jbvqI8FLeY7kZNw7U+wMD0heQWHAr6a9OGsh0y2bdIOytjyC5qQ0lNp/a4IhUYtcgtY16
 UAnFZwEMyIBxi0/NFSEw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Joe Perches, this bit seems less than optimal
because it overwrites already zeroed content. But instead of
fixing the custom padding solution, replace them entirely
with generic eth_skb_pad().

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/ethernet/8390/lib8390.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/83=
90/lib8390.c
index e84021282edf..b3499714f7e0 100644
=2D-- a/drivers/net/ethernet/8390/lib8390.c
+++ b/drivers/net/ethernet/8390/lib8390.c
@@ -305,17 +305,17 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *s=
kb,
 {
 	unsigned long e8390_base =3D dev->base_addr;
 	struct ei_device *ei_local =3D netdev_priv(dev);
-	int send_length =3D skb->len, output_page;
+	int send_length, output_page;
 	unsigned long flags;
-	char buf[ETH_ZLEN];
-	char *data =3D skb->data;
-
-	if (skb->len < ETH_ZLEN) {
-		memset(buf, 0, ETH_ZLEN);	/* more efficient than doing just the needed =
bits */
-		memcpy(buf, data, skb->len);
-		send_length =3D ETH_ZLEN;
-		data =3D buf;
+	char *data;
+
+	/* The Hardware does not pad undersized frames */
+	if (eth_skb_pad(skb)) {
+		dev->stats.tx_dropped++;
+		return NETDEV_TX_OK;
 	}
+	data =3D skb->data;
+	send_length =3D skb->len;

 	/* Mask interrupts from the ethercard.
 	   SMP: We have to grab the lock here otherwise the IRQ handler
=2D-
2.20.1

