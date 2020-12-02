Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC4C2CBD47
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 13:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbgLBMr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 07:47:57 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:36391 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbgLBMr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 07:47:56 -0500
Received: from orion.localdomain ([77.7.48.174]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1N33AR-1k3DzE0tCf-013NEE; Wed, 02 Dec 2020 13:45:17 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: 8021q: use netdev_info() instead of pr_info()
Date:   Wed,  2 Dec 2020 13:45:15 +0100
Message-Id: <20201202124515.24110-1-info@metux.net>
X-Mailer: git-send-email 2.11.0
X-Provags-ID: V03:K1:Ev0LCPSlNfr1RQglGncq5UuBZUinOsQbC525n0A9w2SclTZR3Y4
 i7lb4jN7Wn4voh7k8n8S7sAcD942f3fCPdPthlaE4b6Dtf9CBCP9cmkTW+taPaVUgRoFnAf
 WVX4KjAT744ifJKKsW8lk9GxNo2tde4kRibrPDDVyWfc/tKgKs//rcrCXz4BngJz9EiS5YY
 sesQCqXX8Qf8GVDBUgdtQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6rINA4B8yB8=:Mwr64lwY5k8J3FhY/TulIw
 bG3uWh1qLZb20RN/zoQilRKZv9h0GLDRstKDHM9Rice6lO2q30IPO2cw9zTprVYpDgkbDoxN/
 1iaUV7Hx9BWTJvQ18KSup1/3jALCZMsCIGo8z+pEtv+5qgcQR1NqhX/5XMhaAnfW10Pluhb1R
 UmD8BWvqp5/8uYzTdyZk+iWWeKOzrlxuOADbuiAmwUU7enjuqSS7aO3v2r1kkxONumtErN01J
 aEoWqGG40FCyN0iqNx6hlrhAKqr9fpLQFoiBudTX34SzK2Zo2Rsy5whoTQkZ5L/fZSufWTQ8o
 YgTICSQ1ChTeP1fbfzCo+dwm3Z7YNihaQZam6ZFcMU9ah/WhVyuP7mhCTC0tdwVTvbajYGHxF
 Z52/xrImA5pd5ByN56vJZ8tl+t0XwT4sS8OJ6xjcqZSSJxfiE3iBTrXtuetTF
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_info() instead of pr_info() for more consistent log output.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 net/8021q/vlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index f292e0267bb9..d3a6f4ffdaef 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -132,7 +132,7 @@ int vlan_check_real_dev(struct net_device *real_dev,
 	const char *name = real_dev->name;
 
 	if (real_dev->features & NETIF_F_VLAN_CHALLENGED) {
-		pr_info("VLANs not supported on %s\n", name);
+		netdev_info(real_dev, "VLANs not supported on %s\n", name);
 		NL_SET_ERR_MSG_MOD(extack, "VLANs not supported on device");
 		return -EOPNOTSUPP;
 	}
@@ -385,7 +385,7 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
 
 	if ((event == NETDEV_UP) &&
 	    (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)) {
-		pr_info("adding VLAN 0 to HW filter on device %s\n",
+		netdev_info(dev, "adding VLAN 0 to HW filter on device %s\n",
 			dev->name);
 		vlan_vid_add(dev, htons(ETH_P_8021Q), 0);
 	}
-- 
2.11.0

