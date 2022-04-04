Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691E04F0F71
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 08:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377484AbiDDGfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 02:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377473AbiDDGfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 02:35:32 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7149BBC90
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 23:33:36 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id d5so15281933lfj.9
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 23:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kugPTravw/pWjMItvRqIfrO55/1h/afpYQ2vDHdA2dc=;
        b=PormARcG8FAWF8dAQqF/sYJ31IFoLhesZOcUS6CcZaAJjbwZ3wWgXFcLGcfPlarM5r
         Hk0AjcUKhZa86KSZimXGVgII0jvLhoIds8pI9SPTxyf95oJrfZ3o+k+ABKZvKB6hZEkS
         k87bCmYBmkA0EKYOa03telKFHP+aIRsG8/E7gzJ4iSk5IcDmp3GtH7sapYjpXv0UZVBi
         XQlWQJXb+BuRBlGv4cIBGMxSZ5XZaYNOogl2Qz95bMSySsV+IWejjqN7tmuG1VeHGGqs
         621WYRDwpsmqH1sX5Oll2tRo1BEfkamttHDzUiHtck89ZUPuOkFAa0I3u2EvZuiRPEiq
         O5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kugPTravw/pWjMItvRqIfrO55/1h/afpYQ2vDHdA2dc=;
        b=L2xwwLmE+8radVKCWbTZPFF7yk9R6THZCwv/rK1LTy3km2xi7CxHKDWWUeyr2v7VAW
         +HYTmcJcVSesOjocDARmGx8bjMdASGYAU12mhZ9v/WmZqsLATJTuOLiRMMx2fVoVfYRT
         z+XNBRnVlWSmBLrlr/sWCpgTtTST3yNG8zgDqoQ+yVG+QdNHnJRNn8mBQVlmMmEdpNF3
         xFPPpgVKYHvBn6+h556DuW4JDiHi4dclGw+bqOBLWnhh5kMAo9kwSWp5FtNS7aZW6nlW
         prPqteMKIUs3WVDTFHDjSaRVq0N6mmecdE+J+WfnmQcBj9j+dKn9sUZQMINKVAhbjcOo
         52CQ==
X-Gm-Message-State: AOAM533Qpa7xBL6L9Gw2/4b/mC0bzwuO8SGGx7ebl4cojZfjt+loAsMo
        o1pqDNO1CnqIC7L+S8NlbCV+vwYSS5exvg==
X-Google-Smtp-Source: ABdhPJzMazE6z44oYekvghG0gzq+fLGcObK3eOhG86QN9sa8kmjxKB+5b79tafryHq6jNXdFeNNUeQ==
X-Received: by 2002:ac2:485b:0:b0:44a:23d5:d4bd with SMTP id 27-20020ac2485b000000b0044a23d5d4bdmr21562656lfy.214.1649054014536;
        Sun, 03 Apr 2022 23:33:34 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id d17-20020a194f11000000b0044a30825a6fsm1033771lfb.42.2022.04.03.23.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 23:33:33 -0700 (PDT)
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
Subject: [PATCH v2 net-next 2/2] net: dsa: Implement tc offloading for drop target.
Date:   Mon,  4 Apr 2022 08:33:27 +0200
Message-Id: <20220404063327.1017157-3-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220404063327.1017157-1-mattias.forsblad@gmail.com>
References: <20220404063327.1017157-1-mattias.forsblad@gmail.com>
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
index 64f4fdd02902..84e319520d36 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1436,7 +1436,7 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	 * bridge group.
 	 */
 	dsa_switch_for_each_port(other_dp, ds)
-		if (other_dp->type == DSA_PORT_TYPE_CPU ||
+		if ((other_dp->type == DSA_PORT_TYPE_CPU && dp->bridge->local_rcv_effective) ||
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

