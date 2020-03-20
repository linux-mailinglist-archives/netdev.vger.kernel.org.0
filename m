Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51A8D18C407
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 01:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbgCTABQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 20:01:16 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39979 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbgCTABO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 20:01:14 -0400
Received: by mail-wr1-f66.google.com with SMTP id f3so5462082wrw.7
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 17:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zNATRfnetzSaqNr3rIW9NjzHsY0CwLOC6uIsF71xsTM=;
        b=BDdOaZyxGm+6fEm6oylbZjjabMZKIllSLDT/UxizSXVuve/WdN5q6MVR7e8j3niPCZ
         w3gUdcXbB/hKyUbIynlIDwT01kknB2+TL6kkF+JhfWpl4a22o0ibFgVb2zcSVZO5DKW/
         F4INJkgr5M7lWoek9SH3u9La09b4WSmU8+uICcmzlQ3Rsl2f85C29E9/0DEt+0g81M9e
         pRNwUb8RdWpd/9GF+9EeZ1uMzh1xMEBleSejwv7FnSlmBiJRVANIAmr0R31ZpdwvM3fs
         Km/wcopZZzdugoJOAUXbGEgZuIzOolS3Ad3e5oiRN1YauSK+xK3rMi34TCgLQTkkn2vg
         cjcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zNATRfnetzSaqNr3rIW9NjzHsY0CwLOC6uIsF71xsTM=;
        b=WlrTERFgnIG9rVSZe7qciKpSrZe5eJCZwQkw/c0goIsn+CVKAzHeAHwUwn3/ygGLNP
         Km7TrGvzCHP13WSX77vzxw/oEBR5dbvx/EIo5t8SuhKrrdvHCdmZQWW7lnp6cRi99kFU
         GWRWOY6mveOfjOKG7RPyXz2hAbGT7ZtUd9aMJQ/MYFT9XLfXPudaVLpPUHuvWE7E0XEG
         qq/4dUWqdOjTutlrUt/+rADA8LcXob0IWQ7Aa3AFpW2RCk+ILC/AVlDh2ARtf7QfAQlS
         IaTtSbe8Sam0/2RAj6j4BDvwOHFmvCYEq20Vn43u6QKCgw1oC9TWQu7z5Wr4ARtQ98XD
         YDfg==
X-Gm-Message-State: ANhLgQ1B75wX7G6UL4IcdukR8KVyPaP2FRR1AgrorRTDV7TcWdb/eV+W
        4N8XiTJXV40eifgUPFBzd4c=
X-Google-Smtp-Source: ADFU+vvV9oqchK98fRazaOx0Bk3xYJLllR4c9w4xP6gr2y/b/juwY1CcxO9KG7MR/MTpN7/hDCjPAg==
X-Received: by 2002:adf:f6c8:: with SMTP id y8mr7631515wrp.403.1584662471040;
        Thu, 19 Mar 2020 17:01:11 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id t126sm5670418wmb.27.2020.03.19.17.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 17:01:10 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: [PATCH net 3/3] net: dsa: tag_8021q: get rid of dsa_8021q_xmit
Date:   Fri, 20 Mar 2020 02:00:51 +0200
Message-Id: <20200320000051.28548-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320000051.28548-1-olteanv@gmail.com>
References: <20200320000051.28548-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Calling vlan_insert_tag is easy enough that having a dedicated function
in tag_8021q does not bring any benefit at all.

Fixes: f9bbe4477c30 ("net: dsa: Optional VLAN-based port separation for switches without tagging")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/dsa/8021q.h |  9 ---------
 net/dsa/tag_8021q.c       | 10 ----------
 net/dsa/tag_sja1105.c     |  8 ++++++--
 3 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index c620d9139c28..ac2e5cc2c238 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -17,9 +17,6 @@ struct packet_type;
 int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
 				 bool enabled);
 
-struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
-			       u16 tpid, u16 tci);
-
 u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port);
 
 u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port);
@@ -36,12 +33,6 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
 	return 0;
 }
 
-struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
-			       u16 tpid, u16 tci)
-{
-	return NULL;
-}
-
 u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port)
 {
 	return 0;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 0d51d4974826..1ccd3069f977 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -286,14 +286,4 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 }
 EXPORT_SYMBOL_GPL(dsa_port_setup_8021q_tagging);
 
-struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
-			       u16 tpid, u16 tci)
-{
-	/* skb->data points at skb_mac_header, which
-	 * is fine for vlan_insert_tag.
-	 */
-	return vlan_insert_tag(skb, htons(tpid), tci);
-}
-EXPORT_SYMBOL_GPL(dsa_8021q_xmit);
-
 MODULE_LICENSE("GPL v2");
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index d553bf36bd41..ad1cbeb1146f 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -103,6 +103,8 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	u16 tci = (pcp << VLAN_PRIO_SHIFT) | tx_vid;
+	u16 tpid = ETH_P_SJA1105;
 
 	/* Transmitting management traffic does not rely upon switch tagging,
 	 * but instead SPI-installed management routes. Part 2 of this
@@ -119,8 +121,10 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 	if (dsa_port_is_vlan_filtering(dp))
 		return skb;
 
-	return dsa_8021q_xmit(skb, netdev, ETH_P_SJA1105,
-			     ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
+	/* skb->data points at skb_mac_header, which
+	 * is fine for vlan_insert_tag.
+	 */
+	return vlan_insert_tag(skb, htons(tpid), tci);
 }
 
 static void sja1105_transfer_meta(struct sk_buff *skb,
-- 
2.17.1

