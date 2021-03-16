Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4C533DE7A
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 21:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhCPUP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 16:15:56 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:20095 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbhCPUPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 16:15:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615925722; x=1647461722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IZ8iSP+H8+VECzHX0mSifhGWRhzujX8K+n86bpv75N8=;
  b=mzANH7PESUH1yifees109OACAULLj3N1kLeJtQYuXdE4JZLkz0twHt8o
   EEdMTrj/Gi34JSoWKyJWACjOgP3jlNntG6HaU9JyHxDXbeYAIK87n7jLu
   /JsE+Wr5vFnr/Emu7UUVOUDMm4bC2EEk4BKjR2H9K3kYmobt/hBIHmvnH
   YF/SPQ0zyeNxWCXAdvN449AaLsN4Kh/IHcisx3n19ul1gcjNzFgk9w14Z
   6y82sI/nLFZPvmZXI9Efhvq4EJON8cHT5j12bO9kZet3K4djT4KpRccFY
   XoLy6mrQ5zCMR8v2tl9awLXXN1Ol2ZQP4SABO13C2OwYX/EmdFufvMzSa
   w==;
IronPort-SDR: OoGuwPs1eYdW6FyZksshVaZIxrlFXADiS+jroMmgtNubvC1jBB5ptJk6CkEitDV3s1PYIwY4+c
 3+OgEnSKK9jFBbfwfpfiCYJG0QcHQ6PxTBY+9R3C5jN16cW6NwaXwldWtayPfwTshF6iPU1QhA
 G3st6Ohb91kuQv+6BhkSNjZY26euCI/82Mp1+TXkKZXcr84FhTN3mXz2NzshmEGRZsYa97v4mc
 oB/9QjtbzXBXBUGo8B0W4XHBJCk2YhwFn9ll2bo8tb5+Iq0uzZXsOKZ902ad6K9bvi9V+emjZp
 vHk=
X-IronPort-AV: E=Sophos;i="5.81,254,1610434800"; 
   d="scan'208";a="107434275"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2021 13:15:21 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 16 Mar 2021 13:15:15 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 16 Mar 2021 13:15:13 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
        <alexandre.belloni@bootlin.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 3/3] net: ocelot: Remove ocelot_xfh_get_cpuq
Date:   Tue, 16 Mar 2021 21:10:19 +0100
Message-ID: <20210316201019.3081237-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316201019.3081237-1-horatiu.vultur@microchip.com>
References: <20210316201019.3081237-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now when extracting frames from CPU the cpuq is not used anymore so
remove it.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 3 +--
 include/linux/dsa/ocelot.h         | 5 -----
 net/dsa/tag_ocelot.c               | 2 --
 3 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 9cc9378157e4..9f0c9bdd9f5d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -687,7 +687,7 @@ static int ocelot_xtr_poll_xfh(struct ocelot *ocelot, int grp, u32 *xfh)
 int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
 {
 	struct skb_shared_hwtstamps *shhwtstamps;
-	u64 tod_in_ns, full_ts_in_ns, cpuq;
+	u64 tod_in_ns, full_ts_in_ns;
 	u64 timestamp, src_port, len;
 	u32 xfh[OCELOT_TAG_LEN / 4];
 	struct net_device *dev;
@@ -704,7 +704,6 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
 	ocelot_xfh_get_src_port(xfh, &src_port);
 	ocelot_xfh_get_len(xfh, &len);
 	ocelot_xfh_get_rew_val(xfh, &timestamp);
-	ocelot_xfh_get_cpuq(xfh, &cpuq);
 
 	if (WARN_ON(src_port >= ocelot->num_phys_ports))
 		return -EINVAL;
diff --git a/include/linux/dsa/ocelot.h b/include/linux/dsa/ocelot.h
index 4265f328681a..c6bc45ae5e03 100644
--- a/include/linux/dsa/ocelot.h
+++ b/include/linux/dsa/ocelot.h
@@ -160,11 +160,6 @@ static inline void ocelot_xfh_get_src_port(void *extraction, u64 *src_port)
 	packing(extraction, src_port, 46, 43, OCELOT_TAG_LEN, UNPACK, 0);
 }
 
-static inline void ocelot_xfh_get_cpuq(void *extraction, u64 *cpuq)
-{
-	packing(extraction, cpuq, 28, 20, OCELOT_TAG_LEN, UNPACK, 0);
-}
-
 static inline void ocelot_xfh_get_qos_class(void *extraction, u64 *qos_class)
 {
 	packing(extraction, qos_class, 19, 17, OCELOT_TAG_LEN, UNPACK, 0);
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 157f95689d8d..f9df9cac81c5 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -83,7 +83,6 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	struct dsa_port *dp;
 	u8 *extraction;
 	u16 vlan_tpid;
-	u64 cpuq;
 
 	/* Revert skb->data by the amount consumed by the DSA master,
 	 * so it points to the beginning of the frame.
@@ -113,7 +112,6 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	ocelot_xfh_get_qos_class(extraction, &qos_class);
 	ocelot_xfh_get_tag_type(extraction, &tag_type);
 	ocelot_xfh_get_vlan_tci(extraction, &vlan_tci);
-	ocelot_xfh_get_cpuq(extraction, &cpuq);
 
 	skb->dev = dsa_master_find_slave(netdev, 0, src_port);
 	if (!skb->dev)
-- 
2.30.1

