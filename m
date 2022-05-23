Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26AA8530FC0
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbiEWKnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234183AbiEWKnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:43:24 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523022BD6
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:18 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id y13so27139744eje.2
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lk4CKsVvL554+L9fQG+qTH0J4TsxGfQO7J7jsNhiAjc=;
        b=Dg6bulwu1nrikxDun85V5sdoDDHbkXYoFb5WINlSG0Ufwrum5pC1cZO2/Tn0+xV9RV
         h/wqE2y0ifEs3defl34ylkub1TOSqTWs7bK/jF03n6yzPUp3NYyFXB8HaLi9Z1XZw++9
         nBkqc13JBeKDBNPoFeUlR7x7nWuYvTxY6VAyKp8SkPjEQQ/QoRgZwIRSPxzNavE4dlty
         epb7vTP6hcL5jnMQ5CkLwSWTQz6XSrDDdg3SUWpzkJBxNI5+QSvR9WMOylOLOQiigEPr
         cYdyeXeIvTdLKuX92AoNR3WvKQprBFHqruTFdmQgxpNJnZT4ioSAsEECKmB3xU1dxSET
         lJ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lk4CKsVvL554+L9fQG+qTH0J4TsxGfQO7J7jsNhiAjc=;
        b=ESQPJCC1RXSEzgVAzgdPDtFjsczu/u4FxlEc+MCQQ+mp9vn+2STkyTKAPn+O8+OwWT
         OZMhpLqeqgvG4G/DwAmwrC3UMkl0wUoZ1goD1la2mdq5jXF1pBwONc5bmIhgEZeS+f57
         gfMEABuM6QhGLUPIYqIBrOyVNXYkPujF+XbsSSA6nLxJqRtgJcD9n8fJuaEWJo05wvNC
         ylofN/lWTXLTXZXhYR7cQDqsb4AHumKcWl26R0/PiKeMnpQ8JsnJkwDJMShZPq5bUlmj
         2ApPZt/HIGgGSkBBcN8VdeyMWrx6o1AIwYbdGWaRE+h6NZGp2rOBTVViynALAPvDf9HL
         BUUA==
X-Gm-Message-State: AOAM5328cKfVIbL2k74MLor5vLSbyFgJdiXk0cO5RsI5Eh07dMjzuLjK
        01UGwhJfYXfsu/oo//Ok07i5lL0TzV8=
X-Google-Smtp-Source: ABdhPJw1Uj320czDjbKI1lh3+C9TFhTXSx7sDx0nyMBY/QZgUQkEZDd1+Vk+xQbVK3snI+JxhgM9Jg==
X-Received: by 2002:a17:907:7f19:b0:6fe:ce26:8f0d with SMTP id qf25-20020a1709077f1900b006fece268f0dmr5448261ejc.27.1653302597032;
        Mon, 23 May 2022 03:43:17 -0700 (PDT)
Received: from localhost.localdomain ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id j18-20020a1709066dd200b006feb875503fsm2584822ejt.78.2022.05.23.03.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 03:43:15 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 08/12] net: dsa: use dsa_tree_for_each_cpu_port in dsa_tree_{setup,teardown}_master
Date:   Mon, 23 May 2022 13:42:52 +0300
Message-Id: <20220523104256.3556016-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220523104256.3556016-1-olteanv@gmail.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
MIME-Version: 1.0
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

More logic will be added to dsa_tree_setup_master() and
dsa_tree_teardown_master() in upcoming changes.

Reduce the indentation by one level in these functions by introducing
and using a dedicated iterator for CPU ports of a tree.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h |  4 ++++
 net/dsa/dsa2.c    | 46 +++++++++++++++++++++-------------------------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 14f07275852b..ad345fa17297 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -555,6 +555,10 @@ static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
 	list_for_each_entry((_dp), &(_dst)->ports, list) \
 		if (dsa_port_is_user((_dp)))
 
+#define dsa_tree_for_each_cpu_port(_dp, _dst) \
+	list_for_each_entry((_dp), &(_dst)->ports, list) \
+		if (dsa_port_is_cpu((_dp)))
+
 #define dsa_switch_for_each_port(_dp, _ds) \
 	list_for_each_entry((_dp), &(_ds)->dst->ports, list) \
 		if ((_dp)->ds == (_ds))
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 4f0042339d4f..74167bf0fbe5 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1043,26 +1043,24 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 
 static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 {
-	struct dsa_port *dp;
+	struct dsa_port *cpu_dp;
 	int err = 0;
 
 	rtnl_lock();
 
-	list_for_each_entry(dp, &dst->ports, list) {
-		if (dsa_port_is_cpu(dp)) {
-			struct net_device *master = dp->master;
-			bool admin_up = (master->flags & IFF_UP) &&
-					!qdisc_tx_is_noop(master);
+	dsa_tree_for_each_cpu_port(cpu_dp, dst) {
+		struct net_device *master = cpu_dp->master;
+		bool admin_up = (master->flags & IFF_UP) &&
+				!qdisc_tx_is_noop(master);
 
-			err = dsa_master_setup(master, dp);
-			if (err)
-				break;
+		err = dsa_master_setup(master, cpu_dp);
+		if (err)
+			break;
 
-			/* Replay master state event */
-			dsa_tree_master_admin_state_change(dst, master, admin_up);
-			dsa_tree_master_oper_state_change(dst, master,
-							  netif_oper_up(master));
-		}
+		/* Replay master state event */
+		dsa_tree_master_admin_state_change(dst, master, admin_up);
+		dsa_tree_master_oper_state_change(dst, master,
+						  netif_oper_up(master));
 	}
 
 	rtnl_unlock();
@@ -1072,22 +1070,20 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 
 static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 {
-	struct dsa_port *dp;
+	struct dsa_port *cpu_dp;
 
 	rtnl_lock();
 
-	list_for_each_entry(dp, &dst->ports, list) {
-		if (dsa_port_is_cpu(dp)) {
-			struct net_device *master = dp->master;
+	dsa_tree_for_each_cpu_port(cpu_dp, dst) {
+		struct net_device *master = cpu_dp->master;
 
-			/* Synthesizing an "admin down" state is sufficient for
-			 * the switches to get a notification if the master is
-			 * currently up and running.
-			 */
-			dsa_tree_master_admin_state_change(dst, master, false);
+		/* Synthesizing an "admin down" state is sufficient for
+		 * the switches to get a notification if the master is
+		 * currently up and running.
+		 */
+		dsa_tree_master_admin_state_change(dst, master, false);
 
-			dsa_master_teardown(master);
-		}
+		dsa_master_teardown(master);
 	}
 
 	rtnl_unlock();
-- 
2.25.1

