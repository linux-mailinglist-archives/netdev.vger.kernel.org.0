Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C416A3F636A
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 18:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbhHXQxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 12:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbhHXQxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 12:53:48 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158F2C061757;
        Tue, 24 Aug 2021 09:53:04 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id fs6so1191459pjb.4;
        Tue, 24 Aug 2021 09:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4zUDFYhASAyj6uEGnniUrjXm0ESgZHjV/ksAROysTnI=;
        b=jBAIJufMr/bS3ImM6Lxg2oL7tGRqTlcoylgAcTaZw7dbvBIWMsoLcOSKasr//BYH5x
         XK5nNZoVwjca0/Rb+El2G8nOQQy2jMC7ENDV5ktju6tOjcrQ3Usig3bcAwjmaRw2qBaI
         VPi/pbbUD4Wurm64UKQUniWGT74NRhrqQ3X2hG00sP2EtM5MGDIL3ww3RZ3unOmuNG3q
         waI3iXMk6gCzcWnSetA4puOSidqyVAUXfKH0C0vjPlTjA4xrvylHsJOYTSfg5k4CLsO9
         ++jnyMQOOyQ9ChvOy9o3zE1yeMg7tYLEqFktzA4RmyaPAK9LU8MvN7ZZx4S9s4XE3ll3
         JcCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4zUDFYhASAyj6uEGnniUrjXm0ESgZHjV/ksAROysTnI=;
        b=kIQFQ9GIpUdb9lM78YrqWfO6BpGxjAy7hHbeYJvA+FZOYH28d4YFpA+0OkzEdXAZp6
         NJoonclQzezEiJBd24gpeZtCVZiOwj7PdMk3HjgS9S9ubx+EJ+W+ehj5b8XX+PbAUjKi
         cJqwlWG/uKbjAAQ+l5+UQb7KvvaCxL+l7EhMSZfH+gO0o2aKwOPAUDvPsEWFfm/ezIsY
         hcAwf+89DT+oLNXIcKHbsJ/BI5rpKQq0EtHfeBEBMcL6jHCXxtjpKPWDfdirh+zkcifK
         GahAhfRxWx4ELIyfUMrWn0/rC3lQECV4FWURCGuT+eesTqAHWikT6GiHLnMybxtdbfWX
         W6Dw==
X-Gm-Message-State: AOAM531RJvHYk995DZVX8HZSpF8dStByBC/SaQuM+w00iWn4GPmiazKG
        QmxSUmSramXTWuqlsTXWnbdt5nevz3JAKek8
X-Google-Smtp-Source: ABdhPJxe98BaiW8/mF2ES8BEf8/eZ0x7SRNfLw78J9qt2FTEadgzRDw9vP1be6irFZ24Awz0eKOxrQ==
X-Received: by 2002:a17:90a:c481:: with SMTP id j1mr5415108pjt.164.1629823983611;
        Tue, 24 Aug 2021 09:53:03 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id x19sm20275425pfo.40.2021.08.24.09.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 09:53:02 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:MEDIATEK SWITCH DRIVER),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: mt7530: manually set up VLAN ID 0
Date:   Wed, 25 Aug 2021 00:52:52 +0800
Message-Id: <20210824165253.1691315-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver was relying on dsa_slave_vlan_rx_add_vid to add VLAN ID 0. After
the blamed commit, VLAN ID 0 won't be set up anymore, breaking software
bridging fallback on VLAN-unaware bridges.

Manually set up VLAN ID 0 to fix this.

Fixes: 06cfb2df7eb0 ("net: dsa: don't advertise 'rx-vlan-filter' when not needed")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 25 +++++++++++++++++++++++++
 drivers/net/dsa/mt7530.h |  2 ++
 2 files changed, 27 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index d757d9dcba51..d0cba2d1cd68 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1599,6 +1599,21 @@ mt7530_hw_vlan_update(struct mt7530_priv *priv, u16 vid,
 	mt7530_vlan_cmd(priv, MT7530_VTCR_WR_VID, vid);
 }
 
+static int
+mt7530_setup_vlan0(struct mt7530_priv *priv)
+{
+	u32 val;
+
+	/* Validate the entry with independent learning, keep the original
+	 * ingress tag attribute.
+	 */
+	val = IVL_MAC | EG_CON | PORT_MEM(MT7530_ALL_MEMBERS) | FID(FID_BRIDGED) |
+	      VLAN_VALID;
+	mt7530_write(priv, MT7530_VAWD1, val);
+
+	return mt7530_vlan_cmd(priv, MT7530_VTCR_WR_VID, 0);
+}
+
 static int
 mt7530_port_vlan_add(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_vlan *vlan,
@@ -2174,6 +2189,11 @@ mt7530_setup(struct dsa_switch *ds)
 			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 
+	/* Setup VLAN ID 0 for VLAN-unaware bridges */
+	ret = mt7530_setup_vlan0(priv);
+	if (ret)
+		return ret;
+
 	/* Setup port 5 */
 	priv->p5_intf_sel = P5_DISABLED;
 	interface = PHY_INTERFACE_MODE_NA;
@@ -2346,6 +2366,11 @@ mt7531_setup(struct dsa_switch *ds)
 			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 
+	/* Setup VLAN ID 0 for VLAN-unaware bridges */
+	ret = mt7530_setup_vlan0(priv);
+	if (ret)
+		return ret;
+
 	ds->assisted_learning_on_cpu_port = true;
 	ds->mtu_enforcement_ingress = true;
 
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index fe4cd2ac26d0..91508e2feef9 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -145,6 +145,8 @@ enum mt7530_vlan_cmd {
 #define  PORT_STAG			BIT(31)
 /* Independent VLAN Learning */
 #define  IVL_MAC			BIT(30)
+/* Egress Tag Consistent */
+#define  EG_CON				BIT(29)
 /* Per VLAN Egress Tag Control */
 #define  VTAG_EN			BIT(28)
 /* VLAN Member Control */
-- 
2.25.1

