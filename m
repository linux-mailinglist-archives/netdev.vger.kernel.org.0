Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62B44E6293
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 12:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349699AbiCXLke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 07:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349838AbiCXLk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 07:40:29 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB87515BF
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 04:38:57 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id m26-20020a05600c3b1a00b0038c8b999f58so7047296wms.1
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 04:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :organization:content-transfer-encoding;
        bh=ryCQnqioYNtD1D24H47sRT1GeeyvXYMQeLTVA5GHrBU=;
        b=NmKKo9mKFv+tys+zofsAWjUjl68308mYqaEK1V/LUHeFxge+2Ju4S14fqtiFx7hZt2
         WHCSp94P8AJWF4kiLTTNKTafxdGtN+CvYHcIlOnGNFK6tf7GuVbgk1+aWHsHQEs1tlxc
         botyDEdwrHKbKGXaeOXVqcP3RTTtVbQEg0IjA0qhf/WTUYTVvvXUMKW/kIIEAS+vGkuJ
         euOp0NFYh3fTUtdYGwfIzAzujnFoCrdPqMQaNNiwSeLbLXtSlA9GmrbtRk4HI2noEOoh
         JqliYF5CO3DJaGPWeAYc1St7Ayw7XJRdohEdKRRULYdPLSpCJRDeLA0koBG/5ucwPBSS
         M5ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=ryCQnqioYNtD1D24H47sRT1GeeyvXYMQeLTVA5GHrBU=;
        b=jZ0NoYidnkbV6YWLGVMEeW98Kdi7ux8OXZNazmbeGSGSx1vzicPVWpGAqacwz18j6D
         AiZNURixeU1Ol9/ynIzPUllNC/M0261gXxZVxP4Pb0RgpdFyYI/ppCtV2MZYAz3PtAub
         e6gPP1cErzrEnuNmkPGRzUt8xwy2f39BMm9Y+V5zTHwpWB4aI4rOk4iv6X/TA0z8T4G7
         XmRGbODc0CRa/vKHHfnAxeOeGFOXYFmE1+j4msVgh0IJJcdza2VIcC2LOhxdHe4JVIqa
         scSaCZ+kSCtFWsRsDCyWbUmPVABGHIrHlKm73iAkjnI0JBMGwZ83Gzjc6qlTmpMPDIDS
         ZX1g==
X-Gm-Message-State: AOAM531sqQenN/FVAvaYdtu3/E2Hxm37mjhFPvB4SKMK+uw89sZ5xmWw
        +V1LrnVbEUXDDTUOKF7PEwo=
X-Google-Smtp-Source: ABdhPJwtEiIkkFuxy/qC7RAkMX+Q0nk9Qe/5+iDpRX1lV4D2Zf6h9tjjkyRIoOrQTK8elcre2AtQmA==
X-Received: by 2002:a1c:7302:0:b0:38c:bb21:faf7 with SMTP id d2-20020a1c7302000000b0038cbb21faf7mr12409666wmb.31.1648121935912;
        Thu, 24 Mar 2022 04:38:55 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g1-20020a1c4e01000000b003899c8053e1sm2472498wmh.41.2022.03.24.04.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 04:38:55 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: sparx5: Remove unused GLAG handling in PGID
Date:   Thu, 24 Mar 2022 12:38:52 +0100
Message-Id: <20220324113853.576803-2-casper.casan@gmail.com>
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

Removes PGID handling for GLAG since it is not used
yet. According to feedback on previous patch.
https://lore.kernel.org/netdev/20220322081823.wqbx7vud4q7qtjuq@wse-c0155/T/#t

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 .../net/ethernet/microchip/sparx5/sparx5_main.h |  4 ----
 .../net/ethernet/microchip/sparx5/sparx5_pgid.c | 17 -----------------
 2 files changed, 21 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 7a04b8f2a546..8e77d7ee8e68 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -69,9 +69,6 @@ enum sparx5_vlan_port_type {
 #define PGID_TABLE_SIZE	       3290
 
 #define PGID_MCAST_START 65
-#define PGID_GLAG_START 833
-#define PGID_GLAG_END 1088
-
 #define IFH_LEN                9 /* 36 bytes */
 #define NULL_VID               0
 #define SPX5_MACT_PULL_DELAY   (2 * HZ)
@@ -374,7 +371,6 @@ enum sparx5_pgid_type {
 	SPX5_PGID_FREE,
 	SPX5_PGID_RESERVED,
 	SPX5_PGID_MULTICAST,
-	SPX5_PGID_GLAG
 };
 
 void sparx5_pgid_init(struct sparx5 *spx5);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c b/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
index 90366fcb9958..851a559269e1 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
@@ -15,28 +15,11 @@ void sparx5_pgid_init(struct sparx5 *spx5)
 		spx5->pgid_map[i] = SPX5_PGID_RESERVED;
 }
 
-int sparx5_pgid_alloc_glag(struct sparx5 *spx5, u16 *idx)
-{
-	int i;
-
-	for (i = PGID_GLAG_START; i <= PGID_GLAG_END; i++)
-		if (spx5->pgid_map[i] == SPX5_PGID_FREE) {
-			spx5->pgid_map[i] = SPX5_PGID_GLAG;
-			*idx = i;
-			return 0;
-		}
-
-	return -EBUSY;
-}
-
 int sparx5_pgid_alloc_mcast(struct sparx5 *spx5, u16 *idx)
 {
 	int i;
 
 	for (i = PGID_MCAST_START; i < PGID_TABLE_SIZE; i++) {
-		if (i == PGID_GLAG_START)
-			i = PGID_GLAG_END + 1;
-
 		if (spx5->pgid_map[i] == SPX5_PGID_FREE) {
 			spx5->pgid_map[i] = SPX5_PGID_MULTICAST;
 			*idx = i;
-- 
2.30.2

