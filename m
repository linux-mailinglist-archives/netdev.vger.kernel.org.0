Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8892FA5F9
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406643AbhARQVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406484AbhARQTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 11:19:17 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2950C061794
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:58 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id rv9so5670855ejb.13
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FgC+gJBzNrfOgZ38vxsWoSTCI98/LwIX2fEQMIekyAs=;
        b=cHRodv2WCB2dAn+SvfM+X+A/Gmudte6vtrpjSreRIg/PMs16BABfS2yd7QpXslG0yO
         0wek4nTCy1JF6Mq/JB9+pMVtv301iR1vsVHu9Kv3GqDMtqcBWhPv6KXJkobpHxuvcllr
         FVYkzcvDtm6GTYoPX5T/AIDgQcl/oSVVn3m/RZz1mmu5cDLOdM8b1OB8xuIHyScgr1e+
         Tll7FdpKnBzYW2o3v+1Lpfa6c8EMDUflQ6ovVIr1oQc9BInC+EpsK01zInshBtWjb3Js
         eCGlrGrwTWx1PQvadc09hKmGNbS5NidSTkzZ+tha5b5ZRdSTIKB4afGAmeaAzu7prHYj
         THDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FgC+gJBzNrfOgZ38vxsWoSTCI98/LwIX2fEQMIekyAs=;
        b=qXU1p2+ZHbpvC9Z3o0hE9RngWZCIQiB/wVFd8nhtLXLa7gTwPBPWhAZGUXocwsjWkk
         JDvpPbsHqX0vHQAGzBd87z6QmrW69xuLidZhtvXYqUPXOgL3qx0LTfGOwlRq54dCOZIP
         cdC7G1iKVDtdKxw0qHPmgHi8p2VQhbm8E5FJrn2fEDJdgOmXIQkW6waLkuBgWXn+gY1A
         fQ1z2+b0yzb51Epl2miXSAIdWZROMC5SmexRH4ydLq1jA7YsiZoHYIUtpC7WXbZuZ4tq
         rxGbSYfTFzTth+9vGp1iUiUZ0OOEPjTplg7gWNkJd0+MtF2PKtT7o1oanOOuWl1PN32w
         2auA==
X-Gm-Message-State: AOAM530977lM84euhibSqAkp+c6GxMEmAqFaJh240QGTg56Ntk8JM+eu
        Ls8YdD8Skf2lI4F+iZKRBrs=
X-Google-Smtp-Source: ABdhPJzn5Qw+KoSDV7j5rAdvd32ENQ7ztpx/5sEUo4+EqRmiJTI5joBDiTbs7ZKA2+CI1gb7kkn0Cw==
X-Received: by 2002:a17:906:934c:: with SMTP id p12mr281405ejw.269.1610986677409;
        Mon, 18 Jan 2021 08:17:57 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u23sm6093781edt.78.2021.01.18.08.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 08:17:56 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 11/15] net: mscc: ocelot: export struct ocelot_frame_info
Date:   Mon, 18 Jan 2021 18:17:27 +0200
Message-Id: <20210118161731.2837700-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118161731.2837700-1-olteanv@gmail.com>
References: <20210118161731.2837700-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Because felix DSA must now be able to extract a frame in 2 stages over
MMIO (first the XFH then the frame data), it needs access to this
internal ocelot structure that holds the unpacked information from the
Extraction Frame Header.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot.c         | 4 ++--
 drivers/net/ethernet/mscc/ocelot.h         | 9 ---------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 4 ++--
 include/soc/mscc/ocelot.h                  | 9 +++++++++
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7aba384fe6bf..e32a7f869faa 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -571,7 +571,7 @@ EXPORT_SYMBOL(ocelot_get_txtstamp);
  * bit 16: tag type 0: C-tag, 1: S-tag
  * bit 0-11: VID
  */
-static int ocelot_gen_ifh(u32 *ifh, struct frame_info *info)
+static int ocelot_gen_ifh(u32 *ifh, struct ocelot_frame_info *info)
 {
 	ifh[0] = IFH_INJ_BYPASS | ((0x1ff & info->rew_op) << 21);
 	ifh[1] = (0xf00 & info->port) >> 8;
@@ -596,7 +596,7 @@ bool ocelot_can_inject(struct ocelot *ocelot, int grp)
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb)
 {
-	struct frame_info info = {};
+	struct ocelot_frame_info info = {};
 	u32 ifh[OCELOT_TAG_LEN / 4];
 	unsigned int i, count, last;
 
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index cf6493e55eab..5d80682e3b43 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -32,15 +32,6 @@
 
 #define OCELOT_PTP_QUEUE_SZ	128
 
-struct frame_info {
-	u32 len;
-	u16 port;
-	u16 vid;
-	u8 tag_type;
-	u16 rew_op;
-	u32 timestamp;	/* rew_val */
-};
-
 struct ocelot_port_tc {
 	bool block_shared;
 	unsigned long offload_cnt;
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index e5d0dfc0aec5..a34f0a025710 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -532,7 +532,7 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	return 0;
 }
 
-static int ocelot_parse_ifh(u32 *_ifh, struct frame_info *info)
+static int ocelot_parse_ifh(u32 *_ifh, struct ocelot_frame_info *info)
 {
 	u8 llen, wlen;
 	u64 ifh[2];
@@ -606,10 +606,10 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 
 	while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp)) {
 		struct skb_shared_hwtstamps *shhwtstamps;
+		struct ocelot_frame_info info = {};
 		struct ocelot_port_private *priv;
 		struct ocelot_port *ocelot_port;
 		u64 tod_in_ns, full_ts_in_ns;
-		struct frame_info info = {};
 		struct net_device *dev;
 		u32 ifh[4], val, *buf;
 		struct timespec64 ts;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 360615c36ab9..ba803afcc55c 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -688,6 +688,15 @@ struct ocelot_policer {
 	u32 burst; /* bytes */
 };
 
+struct ocelot_frame_info {
+	u32 len;
+	u16 port;
+	u16 vid;
+	u8 tag_type;
+	u16 rew_op;
+	u32 timestamp;	/* rew_val */
+};
+
 #define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
 #define ocelot_read_gix(ocelot, reg, gi) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
 #define ocelot_read_rix(ocelot, reg, ri) __ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
-- 
2.25.1

