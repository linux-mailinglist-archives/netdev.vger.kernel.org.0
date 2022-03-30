Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3194EBFCB
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 13:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343648AbiC3LdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 07:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343643AbiC3LdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 07:33:22 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA8B1C231D
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 04:31:36 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id t25so35245388lfg.7
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 04:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R6SYnlxuRJUnQ044oq3rRjwQ6cE1Wd5ZXrBDlK5s8is=;
        b=Joi+WSFBTIXAYTlNZSxtQJP4uJKvooZCzckiphSrQHPFq3T2LaF8RIWdeqLhf+gXhE
         JuhAP1ZlQH58v3360eww5GPqFQ8PTGtW1rHGq8vEsahSYthtBx3UybHtUqiaMzWg5spk
         m6tcI3941+zGqzDFyos5WBIbbxlCWd/AROYGZZTC1xLYR18kmQlMPTtDqTyGl5XIACRc
         jaoAyz69cnK5PofHq6zjCO14T8SrlKGXVLaGS7k50iLyv4lLE3UcBWgZUu/6SMDg7Ngj
         keDxBHug3W5RlHYSp6nkPeaymleNqMt+v5ES1i+DdEcEFlZwQwdawoCMewj5dfPjYonf
         ZFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R6SYnlxuRJUnQ044oq3rRjwQ6cE1Wd5ZXrBDlK5s8is=;
        b=douanPFNL+TzE9Xep/035okUbACi06eKBbC2RnuRh6RV7rlUoxJisveebFTUTmSGWf
         aHGax94wL2E49JaM+I9kefjshq+tXYVcTuh2buuZUUsEQMay2endQWUYlKDJ5KIvPZkk
         N4KvoDpe9K3TKnFMb4sJPtH0OLzdxOCVsK9OnEkVcygtef4/kx2dIb8Z4TYMSCTO+dL9
         +IPO9ttzWQOFoowynvvxpKaSQt0k8+dcvq4xxdz7ztZ7SGtj8WlzaLICwr2FQ3ehIpUB
         Q78jhhr0RTKn9EUCD1OpC0XyAixqKTRYfzzyxCmpP71A9VuGRdNBg55LIp1PdK9bQCgw
         evLA==
X-Gm-Message-State: AOAM533BoIhMU2locp4HuBEmP1tdoMsUWkth5ASJI+WeiQyqgu9xO77c
        n9zBfBDgPzOX2lO95IoSS8n3PzP8Xa6CFsjx
X-Google-Smtp-Source: ABdhPJxRaRkzgHCY/Zm7ntDPcimjeLQ20KU3Ss3fbGpEqNaSGxXlYzSOPunL2rC7xyemZDwGa4LGeg==
X-Received: by 2002:ac2:50c8:0:b0:44a:1e22:85cd with SMTP id h8-20020ac250c8000000b0044a1e2285cdmr6553810lfm.500.1648639890805;
        Wed, 30 Mar 2022 04:31:30 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id l3-20020a056512332300b0044a34844974sm2305909lfe.12.2022.03.30.04.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 04:31:29 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [RFC PATCH net-next 2/2] net: dsa: Implement tc offloading for drop target.
Date:   Wed, 30 Mar 2022 13:31:16 +0200
Message-Id: <20220330113116.3166219-3-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220330113116.3166219-1-mattias.forsblad@gmail.com>
References: <20220330113116.3166219-1-mattias.forsblad@gmail.com>
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

Add the ability to handle tc matchall drop HW offloading for Marvell
switches.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 64f4fdd02902..82a8d66520f9 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1436,7 +1436,7 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	 * bridge group.
 	 */
 	dsa_switch_for_each_port(other_dp, ds)
-		if (other_dp->type == DSA_PORT_TYPE_CPU ||
+		if ((other_dp->type == DSA_PORT_TYPE_CPU && dp->bridge->local_rcv) ||
 		    other_dp->type == DSA_PORT_TYPE_DSA ||
 		    dsa_port_bridge_same(dp, other_dp))
 			pvlan |= BIT(other_dp->index);
@@ -6439,6 +6439,26 @@ static void mv88e6xxx_port_mirror_del(struct dsa_switch *ds, int port,
 	mutex_unlock(&chip->reg_lock);
 }
 
+static int mv88e6xxx_bridge_local_rcv(struct dsa_switch *ds, int port,
+				      struct dsa_mall_drop_tc_entry *drop)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct dsa_port *dp;
+	int err;
+
+	dp = dsa_to_port(ds, port);
+	if (!dp)
+		return -EINVAL;
+
+	mutex_lock(&chip->reg_lock);
+
+	err = mv88e6xxx_bridge_map(chip, *dp->bridge);
+
+	mutex_unlock(&chip->reg_lock);
+
+	return err;
+}
+
 static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
 					   struct switchdev_brport_flags flags,
 					   struct netlink_ext_ack *extack)
@@ -6837,6 +6857,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_mdb_del           = mv88e6xxx_port_mdb_del,
 	.port_mirror_add	= mv88e6xxx_port_mirror_add,
 	.port_mirror_del	= mv88e6xxx_port_mirror_del,
+	.bridge_local_rcv	= mv88e6xxx_bridge_local_rcv,
 	.crosschip_bridge_join	= mv88e6xxx_crosschip_bridge_join,
 	.crosschip_bridge_leave	= mv88e6xxx_crosschip_bridge_leave,
 	.port_hwtstamp_set	= mv88e6xxx_port_hwtstamp_set,
-- 
2.25.1

