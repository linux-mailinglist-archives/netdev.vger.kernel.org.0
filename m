Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB594269753
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgINVDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:03:10 -0400
Received: from mout.gmx.net ([212.227.17.21]:47655 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgINVCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 17:02:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1600117315;
        bh=kGRQWhPI+Cf2yxVKOgTlBYhZIF+EdN1wZoaV17WreKc=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Q961NUYVmWyXnPBsbf9zBSrpvzZ6DySylCiHUvQ9yu/2bSIWG0klbcQPSyuplAIQs
         LozuDyVNV2UVVJFdbKOC4O+HdqfIxdh+Ot4xiPbyz32z5lwR3KfR4YHCvh14pBd2cn
         QRSFAPw9d4OkfD6bsd75eG0a+/Yvwjkpgg5I51j8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd.fritz.box ([79.242.188.32]) by mail.gmx.com
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1N4Qwg-1kgVVt2NN8-011SRk; Mon, 14 Sep 2020 23:01:55 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v5 2/6] lib8390: Replace pr_cont() with SMP-safe construct
Date:   Mon, 14 Sep 2020 23:01:24 +0200
Message-Id: <20200914210128.7741-3-W_Armin@gmx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200914210128.7741-1-W_Armin@gmx.de>
References: <20200914210128.7741-1-W_Armin@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:pjgcWdPH6oYu3fjGJgmv5zRKuV2SMvfKGyXiwHr9pAed2ac2Gr/
 8H48KRdfV8INJnWXoZbhm9096brBsY2NSGDDfG3QWGfzVWQc5lFCnRGlg0GoOPfGwojcHha
 6JSTu53So48EdrQte2mXWM5ZLElPx1eZxCfMzGC28BzC6tsNXkmUDVwza/Xxnnj94XkglIo
 gH2ovdoy+nhInfJd4bnhA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0tUwk5nWPds=:xiOjJWVTe+2Fqz9yHf34me
 tyzcyUm/EHixVp2WuhGQQh1Ayt90gw9E8Q6nWlI2FcE+8ZPwgyEGv8ZdqCCFfQ92VSneVhYTc
 4CuwlGuVIZ1mHSy9QGZBScRQRv77TPouF6JSQwQXhEwbwAn9r3s7wJM5NYQvVVyQOpuGQByWq
 efUqEJliPvOamDQKM4s8o1iBMQpN2CELIBYoj5yk6VuA11AT0tbzkh3LJz32h1LOjRggbq/F+
 NL+APm0Qeyx+PgchYneJrjVBfETDgGcutKEq61iodYbJ+V2rAWXu1HfL1fVl/AzTNSk1OPtBY
 tPDLb8A/jVhS/yYHRllrLo/Z2MBpd6h8K6dT4Kz1kscKwcBlaRXUm6qiBeiKd+mKMxDUf0xFb
 +E42kX7Ol0KZeQ2dVRemeTxuwAN86156qXLOdMc+EFAAmi3fLOg+SBLMyG+UvI2CWQorBjeOb
 JjxT6wVmvxHkZmeqCszxG4Cwyp0mk9euRtQYt9CxmGZ6MfUrw/Kqga99A/rGI2tAIA3CW9PMw
 Kt5dCb74TDOYmWDnGF8zkczua/5w5f/8L+3wBqWvrd95FJsCWMCI+2++HMsY8mD91PVYVsSFI
 lZtiK4IwqzR3l8WcniJZ1fFx8Wwvsx9YoV10DEWtn+9eP4hGh7OAH4xsxk8rwirdKx0S48BO9
 e6NY8BnSzecCLmJliv6UudRgtzC7Aloy6j6ZFA+ss9FQtOaSK8Xk8LL+yb4qrjr4fMr4NAGQX
 zkZxeOiMRCx+e7ASz0ZEy6O7eixYUpVvNQgp/JnrYw/VKXBK5tRN3shh0a83WIpIx77Bn2CMn
 opxY5+T2sHWHFM5MaB78C/N4QuUAAOLYn/VHzC+n+5bpmEjGEsUP3QsKVQ/R/wR7hvsiAFSCo
 3pATLRjWu3fc2nDJz7DcqGHt+sIC4sKwPATDpsUOYXF8ckny8bPsHp9h7Lr2iQZahig61Ds7T
 dVZuJakRH8e+IJOUT2qv/Gux0bevZysbaldGEA16YwGxq0oArkh10+CLA0Oz+cu3erzeN7WDI
 mv78vSt1K3Qum2MgaClwN08ycga/oUoOKbtVNHgYTIEgnA/YL0cWhOFARc8HweB2nB0dykenn
 awdo3fMJz63OkHWjfDOEvXVresRUFLh4Rq8ChMraqDCV1Vxmts0cgngUur4g6ZKeghlqwKuTk
 yJujwbjujlDhktQIWec/4nHSG8mDV3mWfRnC2/VK45zVetLlceO/fTAprt/eWaPqNfYCrePP3
 uqPXsBr0gEj5s+tdD
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace pr_cont() with SMP-safe construct.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/ethernet/8390/lib8390.c | 31 +++++++++++------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/83=
90/lib8390.c
index 3a2b1e33a47a..e8a323352c40 100644
=2D-- a/drivers/net/ethernet/8390/lib8390.c
+++ b/drivers/net/ethernet/8390/lib8390.c
@@ -518,25 +518,18 @@ static void ei_tx_err(struct net_device *dev)
 {
 	unsigned long e8390_base =3D dev->base_addr;
 	/* ei_local is used on some platforms via the EI_SHIFT macro */
-	struct ei_device *ei_local __maybe_unused =3D netdev_priv(dev);
-	unsigned char txsr =3D ei_inb_p(e8390_base+EN0_TSR);
-	unsigned char tx_was_aborted =3D txsr & (ENTSR_ABT+ENTSR_FU);
-
-#ifdef VERBOSE_ERROR_DUMP
-	netdev_dbg(dev, "transmitter error (%#2x):", txsr);
-	if (txsr & ENTSR_ABT)
-		pr_cont(" excess-collisions ");
-	if (txsr & ENTSR_ND)
-		pr_cont(" non-deferral ");
-	if (txsr & ENTSR_CRS)
-		pr_cont(" lost-carrier ");
-	if (txsr & ENTSR_FU)
-		pr_cont(" FIFO-underrun ");
-	if (txsr & ENTSR_CDH)
-		pr_cont(" lost-heartbeat ");
-	pr_cont("\n");
-#endif
-
+	struct ei_device *ei_local =3D netdev_priv(dev);
+	unsigned char txsr =3D ei_inb_p(e8390_base + EN0_TSR);
+	unsigned char tx_was_aborted =3D txsr & (ENTSR_ABT + ENTSR_FU);
+
+	if (netif_msg_tx_err(ei_local)) {
+		netdev_err(dev, "Transmitter error %#2x ( %s%s%s%s%s)", txsr,
+			   (txsr & ENTSR_ABT) ? "excess-collisions " : "",
+			   (txsr & ENTSR_ND) ? "non-deferral " : "",
+			   (txsr & ENTSR_CRS) ? "lost-carrier " : "",
+			   (txsr & ENTSR_FU) ? "FIFO-underrun " : "",
+			   (txsr & ENTSR_CDH) ? "lost-heartbeat " : "");
+	}
 	ei_outb_p(ENISR_TX_ERR, e8390_base + EN0_ISR); /* Ack intr. */
 	if (tx_was_aborted) {
 		ei_tx_intr(dev);
=2D-
2.20.1

