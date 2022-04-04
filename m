Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271784F1349
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 12:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358156AbiDDKul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 06:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356525AbiDDKui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 06:50:38 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B119654C
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 03:48:41 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id bx37so8553480ljb.4
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 03:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kugPTravw/pWjMItvRqIfrO55/1h/afpYQ2vDHdA2dc=;
        b=oVzJQfcUcPwBbe4Qh5m0kNzVn6PRseS6MnNj6OTOWlJrlPy5pqK6fzPWB59C5t7Wpr
         v2g7V6v6tSJBvZ/CfVIcJedHSflijHj802/DahM07N2o+E4VHjUzKcKfLJgA+q0Kzana
         W5WEcvk5v/TGMvTkAPP4mIa+DWO71V5WSrNtg1bDH3Ek0MS8TgrxXqhoywZL5FFi37mX
         bGh5NJum4tllL4cCbOwUFWkek6VzubnAoad/elp72IRANy+2qpvOgiAQpYrxEMT4XEmy
         AGkpO1kcvm5k07xJaTkO0376O1a2Jd58k5sYRlxrsrBFe2kjfalu4eB5mlKTMcCWDTm4
         YZMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kugPTravw/pWjMItvRqIfrO55/1h/afpYQ2vDHdA2dc=;
        b=FPq7o3MCS1tSdLqaNgEnAwkp7ixZw+8JBEB5aCi6MlL4RcXjAGRhJxb2vPJUvzKrmW
         nQsXbX3luXAc/wrlOmLL1B9KhxrKaKQksWGYZLPXRzc+gow+I1RTS+vqrFI89VC0maS6
         lJ4QirAkhR9ONZyOG06vLzwz/wN/+D5znHK+FdAlVTmMIjXPHNc2kqmCqo0WQw4FXdJG
         Uhn+uUf67ISNZOXzcc7kpSWStBCJIzTektrZqClNapGD+lHq7xkgWaEZoz/bSqfH9GEm
         nu5UeNGwBp+7O2FOJ3Cy4vaauN4VCfdTqH/D0nKBwe6r0cJEKgFmbQh9Ttb737+IJrvc
         pQQQ==
X-Gm-Message-State: AOAM533yhDlGvfr+RyFMjB63GDw/jHskpD8h2M/gHrmT7Y8GpYzU5GvC
        6vNUfUEqD6r5lng1HpNWYyWK14vM1SszJw==
X-Google-Smtp-Source: ABdhPJz7M1EyJACucq6/y3I+RQZTKhE+JJf+Y430vjVbZOxaGcK7mTevajUirC6aAYHS8Y6oWxu58g==
X-Received: by 2002:a2e:900a:0:b0:24a:f37e:8994 with SMTP id h10-20020a2e900a000000b0024af37e8994mr14057553ljg.376.1649069318992;
        Mon, 04 Apr 2022 03:48:38 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id b26-20020a056512061a00b0044a57b38530sm1098116lfe.164.2022.04.04.03.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 03:48:37 -0700 (PDT)
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
Subject: [PATCH v3 net-next 2/2] net: dsa: Implement tc offloading for drop target.
Date:   Mon,  4 Apr 2022 12:48:26 +0200
Message-Id: <20220404104826.1902292-3-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220404104826.1902292-1-mattias.forsblad@gmail.com>
References: <20220404104826.1902292-1-mattias.forsblad@gmail.com>
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

