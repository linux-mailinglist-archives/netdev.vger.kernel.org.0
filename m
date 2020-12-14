Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F002DA32B
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 23:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440530AbgLNWQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 17:16:45 -0500
Received: from smtp-outgoing.laposte.net ([160.92.124.106]:51123 "EHLO
        smtp-outgoing.laposte.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440085AbgLNWQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 17:16:22 -0500
X-mail-filterd: {"version":"1.2.0","queueID":"4CvwYf6pTxz14K0Z","contextId":"5ad60ae5-0adb-4a61-8f43-5548b330c63c"}
Received: from outgoing-mail.laposte.net (localhost.localdomain [127.0.0.1])
        by mlpnf0109.laposte.net (SMTP Server) with ESMTP id 4CvwYf6pTxz14K0Z;
        Mon, 14 Dec 2020 23:10:14 +0100 (CET)
X-mail-filterd: {"version":"1.2.0","queueID":"4CvwYf5C2zz14K0Y","contextId":"92eebd32-b65c-4692-81e1-11509830ca81"}
X-lpn-mailing: LEGIT
X-lpn-spamrating: 36
X-lpn-spamlevel: not-spam
X-lpn-spamcause: OK, (-100)(0000)gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgudehlecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfntefrqffuvffgpdfqfgfvpdggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgjfhggtgfgsehtkeertdertdejnecuhfhrohhmpeggihhntggvnhhtucfuthgvhhhlrocuoehvihhntggvnhhtrdhsthgvhhhlvgeslhgrphhoshhtvgdrnhgvtheqnecuggftrfgrthhtvghrnhepleejhfdtjeekvdelhfeiteduheeuveeugedtveejieejvdegkefgheevkeevtdefnecukfhppeekkedruddvuddrudegledrgeelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghloheprhhomhhurghlugdrsggvrhhgvghrihgvpdhinhgvthepkeekrdduvddurddugeelrdegledpmhgrihhlfhhrohhmpehvihhntggvnhhtrdhsthgvhhhlvgeslhgrphhoshhtvgdrnhgvthdprhgtphhtthhopegurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtohepkhhusggrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehvihhntggvnhhtrdhsthgvhhhlvgeslhgrphhoshhtvgdrnhgvthdprhgtphhtthhopehjfihisehlihhnuhigrdhisghmrdgtohhmpdhrtghpthhtohepfhhlohhrihgrnhdrfhgrihhnvghllhhisehtvghlvggto
 hhmihhnthdrvghupdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Received: from romuald.bergerie (unknown [88.121.149.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mlpnf0109.laposte.net (SMTP Server) with ESMTPSA id 4CvwYf5C2zz14K0Y;
        Mon, 14 Dec 2020 23:10:14 +0100 (CET)
Received: from radicelle.bergerie (radicelle.bergerie [192.168.124.12])
        by romuald.bergerie (Postfix) with ESMTPS id 377313DFACBE;
        Mon, 14 Dec 2020 23:10:14 +0100 (CET)
Received: from vincent by radicelle.bergerie with local (Exim 4.94)
        (envelope-from <vincent@radicelle.bergerie>)
        id 1kow2n-0005F1-V1; Mon, 14 Dec 2020 23:10:13 +0100
From:   =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <florian.fainelli@telecomint.eu>
Subject: [PATCH v2] net: korina: fix return value
Date:   Mon, 14 Dec 2020 23:09:52 +0100
Message-Id: <20201214220952.19935-1-vincent.stehle@laposte.net>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214130832.7bedb230@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201214130832.7bedb230@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=laposte.net; s=lpn-wlmd; t=1607983816; bh=Eqp7OqU6UYHB3kLsmTmi2wd+ZeXuzYEo6/9CG3irLxg=; h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding; b=rYv/FQ4QQh5J+bShwpNd7RMeqB5RNh5vm4e7dVwnMazfDvTNbnd0UmuqJ2RAY/Px4Q+0nk8O63i4prwNdz2ZmJsx9OTKngZCuqKiLgwnt7GdFhwacqQD80NcRtd/LrhXIZGIFhUuqFeqzy09GgB0kvlWrTbWv7CzWO8yYxwf7GbyEMomAJFBPIUBqrxoG/s1OZzpr+ipBk8kr/IB/dZdQ8AADbycX5Vpt9b4leAahMbedxz3cCnOA+uhwfmye43hCVQR9AleJEkUYPnX9DMx0VA2Jg+x2aFuuOMLzS+li/A3XQkgQ5bJBStKk7VnFATVevBEpD3/HH5mTvQnSeEfMw==;
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ndo_start_xmit() method must not attempt to free the skb to transmit
when returning NETDEV_TX_BUSY. Therefore, make sure the
korina_send_packet() function returns NETDEV_TX_OK when it frees a packet=
.

Fixes: ef11291bcd5f ("Add support the Korina (IDT RC32434) Ethernet MAC")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vincent Stehl=C3=A9 <vincent.stehle@laposte.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>
---


Changes since v1:
- Keep freeing the packet but return NETDEV_TX_OK, as suggested by Jakub


 drivers/net/ethernet/korina.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.=
c
index bf48f0ded9c7d..925161959b9ba 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -219,7 +219,7 @@ static int korina_send_packet(struct sk_buff *skb, st=
ruct net_device *dev)
 			dev_kfree_skb_any(skb);
 			spin_unlock_irqrestore(&lp->lock, flags);
=20
-			return NETDEV_TX_BUSY;
+			return NETDEV_TX_OK;
 		}
 	}
=20
--=20
2.29.2

