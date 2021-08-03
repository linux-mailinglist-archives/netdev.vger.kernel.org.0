Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A1C3DF368
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237603AbhHCRBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237518AbhHCQ5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:57:52 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C879C0617A0
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 09:56:03 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id x14so29805059edr.12
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 09:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qNwutdTPtPzMvhFLvrhFDo49zFNUEnkpKIp2KgXt3ys=;
        b=JR0LMPPDEy0WxQgKw3Kv9H7GdseDx9ecjZelGhl+OTeQUJfFGPabmjisCwFQgGB70F
         BGIlk7+7xJXjiarmoHaUfUDr5Ct5B2SGBC0/b3QwVPNPOfYCJ1dAjwpM4No0F5Etx3zF
         a2zGSrE6mewE3QsCkolo1UfvrAULlJMNj/eavTHmzguKeCoUnLc02CzirykFqU45bZtL
         UmeG7b5O/56S1vtuEo5Jo9zQZT9l60O3Xf7HZkCt3fQjR6WbRKRkl4K6F8x9gN5WbLL0
         fyfjZnxhXfxMMqg+XkZ+vVkQkryhrbs+bRrIDDoYqyh/smKkVCBItvxK+44qDnCDSXlC
         CFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qNwutdTPtPzMvhFLvrhFDo49zFNUEnkpKIp2KgXt3ys=;
        b=OjPGzUHfG8IAdJ2ywylYRJO6bLzH1tY/aoR5JEIpdHcYVCt/i9WXn3hqRlQoyEYWHl
         EAgKcNGNdVfxznAFPrC/k6kDAU2CiMH/QKWbbxM7isbrN0MuHSRTvw3wfGrAZwtGScHl
         /RKVgzUwReehOntjBYsp+Nstz4YtvtrFvSSzrDwcQFVOstGbHYyiAd2nO1U/gK3T5e3c
         9iRDvMbr2f0dfb11FzpGK7MYOn3rGcnLRIfmwjiPkaGR5SL6T7rnClKN9pIZO8J9QBRN
         XpWHj3yZPezfTJZnIjh/f03KHLWruUMygEMXbsNmCuTHtz7EUJuBEJv2u2Wpzip6eE9I
         9dag==
X-Gm-Message-State: AOAM533qMhngDJqs08m4FewPOBjTzUvGPIoeZUWVdcuAp05L1WpkxfGf
        QOjLXko73tQUEJ1Mshoia0Y=
X-Google-Smtp-Source: ABdhPJzFwLGEbKPV0sIZv+Ms1iOo5mjOdrdTV17rtQedJCSR2hI4Bzh0zv6TE6Z6AkDgWbpmP8MRtg==
X-Received: by 2002:a50:fe10:: with SMTP id f16mr26930875edt.208.1628009761748;
        Tue, 03 Aug 2021 09:56:01 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id e7sm8754630edk.3.2021.08.03.09.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:56:01 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 8/8] dpaa2-switch: export MAC statistics in ethtool
Date:   Tue,  3 Aug 2021 19:57:45 +0300
Message-Id: <20210803165745.138175-9-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803165745.138175-1-ciorneiioana@gmail.com>
References: <20210803165745.138175-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

If a switch port is connected to a MAC, use the common dpaa2-mac support
for exporting the available MAC statistics.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../freescale/dpaa2/dpaa2-switch-ethtool.c    | 24 +++++++++++++++----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
index 20912fb67b9e..720c9230cab5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
@@ -142,11 +142,17 @@ dpaa2_switch_set_link_ksettings(struct net_device *netdev,
 	return err;
 }
 
-static int dpaa2_switch_ethtool_get_sset_count(struct net_device *dev, int sset)
+static int
+dpaa2_switch_ethtool_get_sset_count(struct net_device *netdev, int sset)
 {
+	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
+	int num_ss_stats = DPAA2_SWITCH_NUM_COUNTERS;
+
 	switch (sset) {
 	case ETH_SS_STATS:
-		return DPAA2_SWITCH_NUM_COUNTERS;
+		if (port_priv->mac)
+			num_ss_stats += dpaa2_mac_get_sset_count();
+		return num_ss_stats;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -155,14 +161,19 @@ static int dpaa2_switch_ethtool_get_sset_count(struct net_device *dev, int sset)
 static void dpaa2_switch_ethtool_get_strings(struct net_device *netdev,
 					     u32 stringset, u8 *data)
 {
+	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
+	u8 *p = data;
 	int i;
 
 	switch (stringset) {
 	case ETH_SS_STATS:
-		for (i = 0; i < DPAA2_SWITCH_NUM_COUNTERS; i++)
-			memcpy(data + i * ETH_GSTRING_LEN,
-			       dpaa2_switch_ethtool_counters[i].name,
+		for (i = 0; i < DPAA2_SWITCH_NUM_COUNTERS; i++) {
+			memcpy(p, dpaa2_switch_ethtool_counters[i].name,
 			       ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+		if (port_priv->mac)
+			dpaa2_mac_get_strings(p);
 		break;
 	}
 }
@@ -184,6 +195,9 @@ static void dpaa2_switch_ethtool_get_stats(struct net_device *netdev,
 			netdev_err(netdev, "dpsw_if_get_counter[%s] err %d\n",
 				   dpaa2_switch_ethtool_counters[i].name, err);
 	}
+
+	if (port_priv->mac)
+		dpaa2_mac_get_ethtool_stats(port_priv->mac, data + i);
 }
 
 const struct ethtool_ops dpaa2_switch_port_ethtool_ops = {
-- 
2.31.1

