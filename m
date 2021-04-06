Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D052035605B
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347496AbhDGAcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236581AbhDGAcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 20:32:50 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31861C06174A;
        Tue,  6 Apr 2021 17:32:42 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id hq27so24702562ejc.9;
        Tue, 06 Apr 2021 17:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GUQThEn8sqInS66KqVIDjGjd6mOI2+mllQKqLTHbLbY=;
        b=WUy991V6eZ4bHhDcSFjCMAlrehBfw9k6T9nmp2sOJjXR0k4/jHcYsYvyCXtiFUrUCc
         fpltRJI2Xc6AAVJy1CZGCxSpWt/tdKEDgT3FxrDPs1sVKvt/jU/XlknfeeualxtrPYOb
         xC3tAjgJFq6kOhSu0p4wjJATYO4JCanE2vl4mSo3EjoNAw3nOGNdnxbpZzR+pRgjRrcw
         SP7HFMfkbgYMMEea9CAqHXz/9q5+6kKz1pKrScdDtOUnjZqK3FnMPoPO2tM0Yoh1+CwQ
         khz01Hqk8KDazBQscAV77XEZtJJmWtb2N2X9B6FASJHK5N5S4LIHHYfgMJbtYl9JdGth
         ejBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GUQThEn8sqInS66KqVIDjGjd6mOI2+mllQKqLTHbLbY=;
        b=OxwhJ4dg6ZTJhYJb12garaaT77Uu/ELZBABTmIehgdGnH8Co+Cq56KDo2Ws6Su3SJo
         QvmvPLozSXjGet0+9RbTg2ylpl/OqR+63vZTIBuI992fCmj23TpOVjXaavJjLSXCxqYb
         PM1UUow88vdMIcEHN5EjpWeG7bhywiQBkY2iQ4lJie1smmcM0BOeGiavE5/3VfccnZpy
         r6TfDx365n0qFkVLa6uAaAkxll7o2NGpdTOeWvOQj5VCZoBh3VgcngagKFj8KrIXT7Ad
         b4XCf5qBo8Ar0hNYyyaNhLs2ukiGYN7O079HDCyv3tlX05dtPvWwTPcMoOhzURhWAUBN
         iwiA==
X-Gm-Message-State: AOAM53195kYv8b99eJ+IQTDSld1rplOMAos8kiasORESBfuikSkHcTKo
        r99hfA9ohGGPTfH1BUxX+gKw/z0kFJI=
X-Google-Smtp-Source: ABdhPJwyxLTf3N4eXJhyW/24P5R97qQTDnBMFC2a5oLJGobCwlAYkktMolHBOeTuUbvhu4MWmsOmyg==
X-Received: by 2002:a17:906:a049:: with SMTP id bg9mr773877ejb.186.1617755560784;
        Tue, 06 Apr 2021 17:32:40 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-79-23-201-105.retail.telecomitalia.it. [79.23.201.105])
        by smtp.googlemail.com with ESMTPSA id j7sm7829644ejf.74.2021.04.06.17.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 17:32:40 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] drivers: net: dsa: qca8k: add support for multiple cpu port
Date:   Tue,  6 Apr 2021 06:50:40 +0200
Message-Id: <20210406045041.16283-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406045041.16283-1-ansuelsmth@gmail.com>
References: <20210406045041.16283-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k 83xx switch have 2 cpu ports. Rework the driver to support
multiple cpu port. All ports can access both cpu ports by default as
they support the same features.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 18 +++++++++---------
 drivers/net/dsa/qca8k.h |  2 --
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index cdaf9f85a2cb..942d2a75f709 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -724,11 +724,6 @@ qca8k_setup(struct dsa_switch *ds)
 	/* Enable MIB counters */
 	qca8k_mib_init(priv);
 
-	/* Enable QCA header mode on the cpu port */
-	qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(QCA8K_CPU_PORT),
-		    QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
-		    QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
-
 	/* Disable forwarding by default on all ports */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++)
 		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
@@ -749,7 +744,12 @@ qca8k_setup(struct dsa_switch *ds)
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		/* CPU port gets connected to all user ports of the switch */
 		if (dsa_is_cpu_port(ds, i)) {
-			qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(QCA8K_CPU_PORT),
+			/* Enable QCA header mode on the cpu port */
+			qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(i),
+				    QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
+					QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
+
+			qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
 				  QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
 		}
 
@@ -759,7 +759,7 @@ qca8k_setup(struct dsa_switch *ds)
 
 			qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
 				  QCA8K_PORT_LOOKUP_MEMBER,
-				  BIT(QCA8K_CPU_PORT));
+				  dsa_cpu_ports(ds));
 
 			/* Enable ARP Auto-learning by default */
 			qca8k_reg_set(priv, QCA8K_PORT_LOOKUP_CTRL(i),
@@ -1140,7 +1140,7 @@ static int
 qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	int port_mask = BIT(QCA8K_CPU_PORT);
+	int port_mask = dsa_cpu_ports(ds);
 	int i;
 
 	for (i = 1; i < QCA8K_NUM_PORTS; i++) {
@@ -1183,7 +1183,7 @@ qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
 	 * this port
 	 */
 	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-		  QCA8K_PORT_LOOKUP_MEMBER, BIT(QCA8K_CPU_PORT));
+		  QCA8K_PORT_LOOKUP_MEMBER, dsa_cpu_ports(ds));
 }
 
 static int
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 7ca4b93e0bb5..17bc643231c3 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -20,8 +20,6 @@
 
 #define QCA8K_NUM_FDB_RECORDS				2048
 
-#define QCA8K_CPU_PORT					0
-
 #define QCA8K_PORT_VID_DEF				1
 
 /* Global control registers */
-- 
2.30.2

