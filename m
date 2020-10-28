Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326C429DCD1
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387438AbgJ1W2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387813AbgJ1W2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:28:03 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC71EC0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:28:03 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id p10so1124744ile.3
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D3j6AI8+nDJ5Q3LO1v72Tb+MRe7d3arn791p76Lb9zI=;
        b=mSiRVy7CoJ9krzDQDoKmwtwXL58VbEBa1WQkT/PEXG/McX4J3z+p134OL+821tE2fN
         zIkxdYJAirF7DjvmzkV46u+O7ncVNNoneHX5vQvkjPtJr7Jp/EGOe+5zbxHLJsAu+n0H
         80ezCbPv+5tsXN2As/eHcnhlqSwTHFy8XQAn9tjWIs2SVGt1mpJoAFy7LeaHcpg3sbT1
         t7uOn26xFEfD3sHLreJOfVdx8ZvESU4VrgLFbCNCI9rU0WefZicyX7H78CA4BBtYqbTj
         hoLHCzMetn6j4KfCHxuHM5oXZzWxzTkbkcQFu+eP1jnP+ALilfyKIILSvrQqdYlwsXxp
         8Rfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D3j6AI8+nDJ5Q3LO1v72Tb+MRe7d3arn791p76Lb9zI=;
        b=riA349VyaQGS0hkj8L+RS/nXXoRQPtiBrN2I7stqIdZ1cqbajvwutTd+8chKr2uxlg
         asVCCjCkxrtgk7UGGSsZmJxZjllo/OMRY0KseZ6a9Tv6vRsteTZAXmbPfUWwagVN9oxw
         PBifnxsbVgj2tU0iGxFgiZZEzL7uS7p3qQyXR3f0dXhLovJFYgJ8AFqLdgfIpe6rPney
         RGjm/EkhEMEfO/uQTIn8jY4E9fx6hnr1avHoaWraC1ILxM5drHKvHWkICxHkM6pevL2G
         5NFJ+9q3968ghHZ4fnUCfOXMIZKiWKRzehomNMY4H3nmFo6anQFiN34HI6pJmFJA+nbd
         IQ0A==
X-Gm-Message-State: AOAM530F7L9n/WoZfGX54GWSN34ol52HzyYWmXG/o+ruMomqHyuSORi5
        tyLp3Pf8DHnSFL3A7T9JPtSlSRzzdh+mD9S4BW8=
X-Google-Smtp-Source: ABdhPJxrj25xueHZ/hjMyyerzMjbAtSGpIEU79zHRRBo3/BPR1ZoS0v2l5MExQIT4sjmH2zguSUuwQ==
X-Received: by 2002:a63:f5a:: with SMTP id 26mr559378pgp.221.1603908750576;
        Wed, 28 Oct 2020 11:12:30 -0700 (PDT)
Received: from container-ubuntu.lan ([171.211.27.43])
        by smtp.gmail.com with ESMTPSA id d7sm78962pjx.33.2020.10.28.11.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 11:12:29 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH] net: dsa: mt7530: support setting MTU
Date:   Thu, 29 Oct 2020 02:12:21 +0800
Message-Id: <20201028181221.30419-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MT7530/7531 has a global RX packet length register, which can be used
to set MTU.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 36 ++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/mt7530.h | 12 ++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index de7692b763d8..7764c66a47c9 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1021,6 +1021,40 @@ mt7530_port_disable(struct dsa_switch *ds, int port)
 	mutex_unlock(&priv->reg_mutex);
 }
 
+static int
+mt7530_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
+{
+	struct mt7530_priv *priv = ds->priv;
+	int length;
+
+	/* When a new MTU is set, DSA always set the CPU port's MTU to the largest MTU
+	 * of the slave ports. Because the switch only has a global RX length register,
+	 * only allowing CPU port here is enough.
+	 */
+	if (!dsa_is_cpu_port(ds, port))
+		return 0;
+
+	/* RX length also includes Ethernet header, MTK tag, and FCS length */
+	length = new_mtu + ETH_HLEN + MTK_HDR_LEN + ETH_FCS_LEN;
+	if (length <= 1522)
+		mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_PKT_LEN_MASK, MAX_RX_PKT_LEN_1522);
+	else if (length <= 1536)
+		mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_PKT_LEN_MASK, MAX_RX_PKT_LEN_1536);
+	else if (length <= 1552)
+		mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_PKT_LEN_MASK, MAX_RX_PKT_LEN_1552);
+	else
+		mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_JUMBO_MASK | MAX_RX_PKT_LEN_MASK,
+			MAX_RX_JUMBO(DIV_ROUND_UP(length, 1024)) | MAX_RX_PKT_LEN_JUMBO);
+
+	return 0;
+}
+
+static int
+mt7530_port_max_mtu(struct dsa_switch *ds, int port)
+{
+	return MT7530_MAX_MTU;
+}
+
 static void
 mt7530_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 {
@@ -2519,6 +2553,8 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.get_sset_count		= mt7530_get_sset_count,
 	.port_enable		= mt7530_port_enable,
 	.port_disable		= mt7530_port_disable,
+	.port_change_mtu	= mt7530_port_change_mtu,
+	.port_max_mtu		= mt7530_port_max_mtu,
 	.port_stp_state_set	= mt7530_stp_state_set,
 	.port_bridge_join	= mt7530_port_bridge_join,
 	.port_bridge_leave	= mt7530_port_bridge_leave,
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 9278a8e3d04e..77a6222d2635 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -11,6 +11,9 @@
 #define MT7530_NUM_FDB_RECORDS		2048
 #define MT7530_ALL_MEMBERS		0xff
 
+#define MTK_HDR_LEN			4
+#define MT7530_MAX_MTU			(15 * 1024 - ETH_HLEN - ETH_FCS_LEN - MTK_HDR_LEN)
+
 enum mt753x_id {
 	ID_MT7530 = 0,
 	ID_MT7621 = 1,
@@ -289,6 +292,15 @@ enum mt7530_vlan_port_attr {
 #define MT7531_DBG_CNT(x)		(0x3018 + (x) * 0x100)
 #define  MT7531_DIS_CLR			BIT(31)
 
+#define MT7530_GMACCR			0x30e0
+#define  MAX_RX_JUMBO(x)		((x) << 2)
+#define  MAX_RX_JUMBO_MASK		GENMASK(5, 2)
+#define  MAX_RX_PKT_LEN_MASK		GENMASK(1, 0)
+#define  MAX_RX_PKT_LEN_1522		0x0
+#define  MAX_RX_PKT_LEN_1536		0x1
+#define  MAX_RX_PKT_LEN_1552		0x2
+#define  MAX_RX_PKT_LEN_JUMBO		0x3
+
 /* Register for MIB */
 #define MT7530_PORT_MIB_COUNTER(x)	(0x4000 + (x) * 0x100)
 #define MT7530_MIB_CCR			0x4fe0
-- 
2.25.1

