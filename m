Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9C64E6292
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 12:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbiCXLkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 07:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349839AbiCXLka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 07:40:30 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D59C517D0
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 04:38:58 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id p189so2541513wmp.3
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 04:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :organization:content-transfer-encoding;
        bh=McYpIPcOqn1kFEJLNrxWs2ZO2U3irSb8P/mJouiG8Rg=;
        b=RwLISiLKQak+cY5l8inWF4ReSExuvAGgQvypBa3MxbUaRzPkL2sWsxVggcfqZiM0OD
         vTMU/fLX+mLtsNJXFBEHClAIwZivQzTz+xTiVlkvqVJ5Emb2d6m02kDZkVSVWinBSoqT
         FYUQcJlcKI9AtCGGjqypQqnm0Bwm/9sf3NZPcYx+7tl2l02yHTHb1ohjGI6o9qNSYkBF
         7h7lmam76E5m88hSFLK70o4RN5q0ZdI2lJQcCDUw077fF45C9mYQ3Ua3SgAjIAUXvqBU
         gdPqyGqY69j8JEwtlb8NYrPstrKtyXVthK9ZWWTa1G6i/orp4WkxAuVxQKAlVcwaBIlu
         kk3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=McYpIPcOqn1kFEJLNrxWs2ZO2U3irSb8P/mJouiG8Rg=;
        b=1v/wZwDXsJl8/IHmUDB8OKWwbBDqGo2VA8JZoAoVXDgY+h/12s7b91nlFMe6xNOqcW
         ykyQBQwHwST+X93AzEI4A+GsPBJ3DCXircAwFaNdOAUymMpUzAnAS+jmhA19rFyd+Fmy
         P1vFD1i78AP+mPnKLs0PRk5F0Xb6lpGcePOjLyklnmTL3YsJ9tuJnarRl2X4ZKiB5oLG
         xLFsIBJocJgkrWuYOGuAuAaoCUpFQ6SKFYTF8iWLyWKeGYUuSzoO9VLkfb+cbAQcMzzZ
         Wh1wTfLxRx5gwEXAYrGwN2pgmdOMVImFwaubHKUk/89sDXtPjCNdeGKqRf75N0gsZm//
         67Dg==
X-Gm-Message-State: AOAM533DB86fOOVeDxe3U96GYCuMkvz3LMc/gjV1Uv//LiMPT+cejqv9
        rGvHk4cgTuqsrbSRSLvGD24kNtc4NAM=
X-Google-Smtp-Source: ABdhPJy2YqCt/OnmCzOrwp4t80T85E3l1C9HaximAtdjDyBWWgurIPCnJmHkIJVAIWFywM7QlU1PiA==
X-Received: by 2002:a1c:7312:0:b0:38c:6f75:ab28 with SMTP id d18-20020a1c7312000000b0038c6f75ab28mr13971032wmb.19.1648121936835;
        Thu, 24 Mar 2022 04:38:56 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g1-20020a1c4e01000000b003899c8053e1sm2472498wmh.41.2022.03.24.04.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 04:38:56 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: sparx5: Refactor mdb handling according to feedback
Date:   Thu, 24 Mar 2022 12:38:53 +0100
Message-Id: <20220324113853.576803-3-casper.casan@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220324113853.576803-1-casper.casan@gmail.com>
References: <20220324113853.576803-1-casper.casan@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Remove mact_lookup and use new mact_find instead.
- Make pgid_read_mask function.
- Set PGID arbiter to start searching at PGID_BASE + 8.

This is according to feedback on previous patch.
https://lore.kernel.org/netdev/20220322081823.wqbx7vud4q7qtjuq@wse-c0155/T/#t

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 .../microchip/sparx5/sparx5_mactable.c        | 19 ++++---------------
 .../ethernet/microchip/sparx5/sparx5_main.h   |  3 ++-
 .../ethernet/microchip/sparx5/sparx5_pgid.c   |  3 +++
 .../microchip/sparx5/sparx5_switchdev.c       | 18 ++++++++----------
 .../ethernet/microchip/sparx5/sparx5_vlan.c   |  7 +++++++
 5 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
index 35abb3d0ce19..a5837dbe0c7e 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
@@ -212,19 +212,7 @@ bool sparx5_mact_find(struct sparx5 *sparx5,
 
 	mutex_unlock(&sparx5->lock);
 
-	return ret == 0;
-}
-
-static int sparx5_mact_lookup(struct sparx5 *sparx5,
-			      const unsigned char mac[ETH_ALEN],
-			      u16 vid)
-{
-	u32 pcfg2;
-
-	if (sparx5_mact_find(sparx5, mac, vid, &pcfg2))
-		return 1;
-
-	return 0;
+	return ret;
 }
 
 int sparx5_mact_forget(struct sparx5 *sparx5,
@@ -305,9 +293,10 @@ int sparx5_add_mact_entry(struct sparx5 *sparx5,
 {
 	struct sparx5_mact_entry *mact_entry;
 	int ret;
+	u32 cfg2;
 
-	ret = sparx5_mact_lookup(sparx5, addr, vid);
-	if (ret)
+	ret = sparx5_mact_find(sparx5, addr, vid, &cfg2);
+	if (!ret)
 		return 0;
 
 	/* In case the entry already exists, don't add it again to SW,
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 8e77d7ee8e68..b197129044b5 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -65,10 +65,10 @@ enum sparx5_vlan_port_type {
 #define PGID_IPV6_MC_CTRL      (PGID_BASE + 5)
 #define PGID_BCAST	       (PGID_BASE + 6)
 #define PGID_CPU	       (PGID_BASE + 7)
+#define PGID_MCAST_START       (PGID_BASE + 8)
 
 #define PGID_TABLE_SIZE	       3290
 
-#define PGID_MCAST_START 65
 #define IFH_LEN                9 /* 36 bytes */
 #define NULL_VID               0
 #define SPX5_MACT_PULL_DELAY   (2 * HZ)
@@ -325,6 +325,7 @@ void sparx5_mact_init(struct sparx5 *sparx5);
 
 /* sparx5_vlan.c */
 void sparx5_pgid_update_mask(struct sparx5_port *port, int pgid, bool enable);
+void sparx5_pgid_read_mask(struct sparx5 *sparx5, int pgid, u32 portmask[3]);
 void sparx5_update_fwd(struct sparx5 *sparx5);
 void sparx5_vlan_init(struct sparx5 *sparx5);
 void sparx5_vlan_port_setup(struct sparx5 *sparx5, int portno);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c b/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
index 851a559269e1..af8b435009f4 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
@@ -19,6 +19,9 @@ int sparx5_pgid_alloc_mcast(struct sparx5 *spx5, u16 *idx)
 {
 	int i;
 
+	/* The multicast area starts at index 65, but the first 7
+	 * are reserved for flood masks and CPU. Start alloc after that.
+	 */
 	for (i = PGID_MCAST_START; i < PGID_TABLE_SIZE; i++) {
 		if (spx5->pgid_map[i] == SPX5_PGID_FREE) {
 			spx5->pgid_map[i] = SPX5_PGID_MULTICAST;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 2d8e0b81c839..5389fffc694a 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -406,11 +406,11 @@ static int sparx5_handle_port_mdb_add(struct net_device *dev,
 
 	res = sparx5_mact_find(spx5, v->addr, vid, &mact_entry);
 
-	if (res) {
+	if (res == 0) {
 		pgid_idx = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_GET(mact_entry);
 
-		/* MC_IDX has an offset of 65 in the PGID table. */
-		pgid_idx += PGID_MCAST_START;
+		/* MC_IDX starts after the port masks in the PGID table */
+		pgid_idx += SPX5_PORTS;
 		sparx5_pgid_update_mask(port, pgid_idx, true);
 	} else {
 		err = sparx5_pgid_alloc_mcast(spx5, &pgid_idx);
@@ -468,17 +468,15 @@ static int sparx5_handle_port_mdb_del(struct net_device *dev,
 
 	res = sparx5_mact_find(spx5, v->addr, vid, &mact_entry);
 
-	if (res) {
+	if (res == 0) {
 		pgid_idx = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_GET(mact_entry);
 
-		/* MC_IDX has an offset of 65 in the PGID table. */
-		pgid_idx += PGID_MCAST_START;
+		/* MC_IDX starts after the port masks in the PGID table */
+		pgid_idx += SPX5_PORTS;
 		sparx5_pgid_update_mask(port, pgid_idx, false);
 
-		pgid_entry[0] = spx5_rd(spx5, ANA_AC_PGID_CFG(pgid_idx));
-		pgid_entry[1] = spx5_rd(spx5, ANA_AC_PGID_CFG1(pgid_idx));
-		pgid_entry[2] = spx5_rd(spx5, ANA_AC_PGID_CFG2(pgid_idx));
-		if (pgid_entry[0] == 0 && pgid_entry[1] == 0 && pgid_entry[2] == 0) {
+		sparx5_pgid_read_mask(spx5, pgid_idx, pgid_entry);
+		if (bitmap_empty((unsigned long *)pgid_entry, SPX5_PORTS)) {
 			/* No ports are in MC group. Remove entry */
 			err = sparx5_mdb_del_entry(dev, spx5, v->addr, vid, pgid_idx);
 			if (err)
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
index 8e56ffa1c4f7..37e4ac965849 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
@@ -138,6 +138,13 @@ void sparx5_pgid_update_mask(struct sparx5_port *port, int pgid, bool enable)
 	}
 }
 
+void sparx5_pgid_read_mask(struct sparx5 *spx5, int pgid, u32 portmask[3])
+{
+	portmask[0] = spx5_rd(spx5, ANA_AC_PGID_CFG(pgid));
+	portmask[1] = spx5_rd(spx5, ANA_AC_PGID_CFG1(pgid));
+	portmask[2] = spx5_rd(spx5, ANA_AC_PGID_CFG2(pgid));
+}
+
 void sparx5_update_fwd(struct sparx5 *sparx5)
 {
 	DECLARE_BITMAP(workmask, SPX5_PORTS);
-- 
2.30.2

