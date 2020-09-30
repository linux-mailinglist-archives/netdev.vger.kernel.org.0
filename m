Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12F027F37F
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730338AbgI3UpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:45:22 -0400
Received: from mout.gmx.net ([212.227.15.18]:50355 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgI3UpW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 16:45:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601498714;
        bh=L3Lh304G7fBEOXSlQveILmfZEqq4Fgy4Yp939qsGUZs=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=cVm6gVNZV+z0JDdB3iXXUyM/3pH6OpML0korbjjX8b0vQPwC4tKYf0dkuHx59xgms
         tjkwrZC6nyLOO6IQ9jGkAHz8rgKUTxw805Qu2cCPVkIFVSz5SA89fkFgC+OSyfb0jI
         I9thziIXHZJfHCKBPNWO/gZjpElANiYdlS5R3qnM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd.fritz.box ([79.242.183.5]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1Mv31W-1kf7Kk2wzY-00r1xL; Wed, 30 Sep 2020 22:45:14 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] lib8390: Use netif_msg_init to initialize msg_enable bits
Date:   Wed, 30 Sep 2020 22:44:56 +0200
Message-Id: <20200930204456.10756-1-W_Armin@gmx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:zERM3dCF3AYlAYwMERQChJ5F3tEx/VVCCoK/dmpNaA8AHoJTyQw
 DojhsH+6LJ8s6ycCUnE9cO8NizniVj7krB02einy9k2j70ViuZT8SQ2LMG1Npt1sHDFWk/d
 wuMBSMIFHqcJxvzd2U+GnlKmg9DKD51NnSmRZCp6fG7i4I3/NLQBHLICruarUPeFVA6xjIt
 LoMgKgxr2i1zlOKblb/iQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5+kNY5063Ls=:UDC6nggHn3Xf8AvaZmKGte
 yRm/uhnpMQhNEWyQxRuSJkq8v/YbcydMWnW/fvKET5uhn4gyjtC8l3Qfb2igLi3o1ygYv8vXL
 yEjFzE0MCyheoRvn+jsKTc8yhq2TfEJYSu/FFG5PyC7FB92j/fmNqsHDpj9CIvBMvUm2Ph8xS
 +2HM7Tt8oAIYLkVsBZ4qhJDG9Wa2fxsv6xY7fcr5VoLWgLYqXgVLfndRVoZXbekZOTCTJqaNc
 NDNxgzLQ4d06aKMITC6Aaeq/Zax7vY0CHSKlswHpf/3bR3MWV4VbLOxcXsr0op/dnl1iHT7QP
 n64n4jPAy2cIS4xPpq1hhxA2t6OXLV+3gC+5AwLSdVerxSPWIgZhwEZUSqZoXxyOApdcFip+t
 Wpilq29pvxTIi0p1QoJ19kQQpNngg4jBgYuoDBOsNCETi0tvd3KhiKOLS6zQueCuehIcUgyZn
 av1lak9H1Xc2Bu7c6j9f/TxnFZJDynYCaQA3MJvjnkL5uoMdiT8fhhgF/5S62Hjo66CT5D1aq
 aGZbTMvycisRiOmDrn7CNdLDzM1LeCiUMzQSukZONDHESFbUhgHd26NbkaZm3oZrvvpLfSzHR
 i8E6c7Y2m9y8Ha7NEO/JwuKI2KtKSJskOF69nWPzYqV6WipPcP/sP4XWGIOQ9h9oLaa5JoNT9
 HOf3g7bE4/gantyyLsuT/tmGMBYMirrB88549sKo/c/zO71I4nKOcC9mU8fX79Mgphf2agXRM
 6mFbBCEyMjltHWt2JPF6GfkVI7Z0br7NYKY9tf+fMh5H+ich5Nxnd342xsl3FFhTsaMDKuKVE
 zUuu1pPTe3YOvfBJm1fkiXI7147ryWH7KXBBglvfx95tuhJmBu7fqCDlHa+jzdfVIRVpSJm4Q
 OmfUCQTLBU1HwrOabf5NmG97VmSKte7alI79CibmFdAPyAaYZEm+KVxW5qEi68YAvrfGPR8F0
 5IEef4TwFu4q2sbcJe0KaN+gq2nOdncJYv3odS/awgQqyJLXZWb50xmCkXao7Fr3GZEe0elrL
 SkTRw3Ibsy35aQJsoMJWwpCMdLWGa0aH67ZW5SfSSjl52mB6w5mBS8faKAQ3NRMH4GltKRHfo
 eUIgCP/y8WR5aVVPf4m+Jvstui8+t81xwZjSoCJi7fMVy9TWnCGT0RPSRjDPCnTL2fbqV/3CV
 mn/ygSHYjzt84j4R1ppPEjbbgLwkW+dZN77y178192PrO9D8eVAhO4Xs9oK9joBQLddN/YSqk
 M4ne/tqtqhOReBst6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netif_msg_init() to process param settings
and use only the proper initialized value of
ei_local->msg_level for later processing;

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/ethernet/8390/lib8390.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/83=
90/lib8390.c
index deba94d2c909..e84021282edf 100644
=2D-- a/drivers/net/ethernet/8390/lib8390.c
+++ b/drivers/net/ethernet/8390/lib8390.c
@@ -113,8 +113,10 @@ static void do_set_multicast_list(struct net_device *=
dev);
 static void __NS8390_init(struct net_device *dev, int startp);

 static unsigned version_printed;
-static u32 msg_enable;
-module_param(msg_enable, uint, 0444);
+static int msg_enable;
+static const int default_msg_level =3D (NETIF_MSG_DRV | NETIF_MSG_PROBE |=
 NETIF_MSG_RX_ERR |
+				     NETIF_MSG_TX_ERR);
+module_param(msg_enable, int, 0444);
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h =
for bitmap)");

 /*
@@ -974,14 +976,14 @@ static void ethdev_setup(struct net_device *dev)
 {
 	struct ei_device *ei_local =3D netdev_priv(dev);

-	if ((msg_enable & NETIF_MSG_DRV) && (version_printed++ =3D=3D 0))
-		pr_info("%s", version);
-
 	ether_setup(dev);

 	spin_lock_init(&ei_local->page_lock);

-	ei_local->msg_enable =3D msg_enable;
+	ei_local->msg_enable =3D netif_msg_init(msg_enable, default_msg_level);
+
+	if (netif_msg_drv(ei_local) && (version_printed++ =3D=3D 0))
+		pr_info("%s", version);
 }

 /**
=2D-
2.20.1

