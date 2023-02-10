Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6807869246C
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 18:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbjBJRaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 12:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbjBJR37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 12:29:59 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884197359C;
        Fri, 10 Feb 2023 09:29:58 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id sa10so17741275ejc.9;
        Fri, 10 Feb 2023 09:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U/Rg7Y2Cd3DV/2GRO230U++3RvJzdHwXmYI8F8wAihQ=;
        b=IE3QHEw9KsJ7k3KXpeht2hSePlfSCcLFuPDa4FkyH7H0VUy3rfQbOLsC6yJYoHfxSX
         OiwMXwi+rZ71+iEIQm79QPoB0F2ELJT6OHFHvf5C9vOL8occKcSDvmeQymhTmfVvWryt
         g1wlTRsVY+Kn48Cs+Y8axQzsANT1+W26aGtzTvguCm/0uYG8KjFPNnRC2LKINM/eRrLW
         NEuskPHjbYiiMJB627QdRlE15wlnHrpHPFhWZBcxVbF7Urhi+BZKPvJnDJhPFLQdcWR7
         sdjgBZgj5YYoS/l1VilZ6WvAZ0wpMi/XeGqDmVjht9f4OEUpCXhjUtm7O8S1/7LE2p+o
         Cy/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U/Rg7Y2Cd3DV/2GRO230U++3RvJzdHwXmYI8F8wAihQ=;
        b=DBPmQzjMQv5grLJpINxptdHes+cQCmI0PGaMdDqUkdzUrJiuEmJ1ttxqvMTSrwDJJn
         7wwG0Vo0cW2oRyKxd9clHqUpyADQOohfzs/+7Z39NpKUyXnywZ7WRLZ2Y72fV1B1qXyf
         PLpwQBrLbX9ne1xh31fN+i4rgWBYvV06XXFBqEoRdL6JKuwDKFw9gN5ek68U4R2oCu8n
         XPzSTL2yH9cyTOk1JnM/+lUyIK16qnYLi7YsOxmek40JRWWMv4Qs4MeQ+TApDgq0CUzb
         7zVJ/+YnccmFIBxq+swNZpDitw+muUNw5sMY36xDCFDDPu4prv7iYnvdK4ocarz+OBRJ
         9FoA==
X-Gm-Message-State: AO0yUKWtMWskaQiqLpmuTe2ifb1O7zxedE420JBjvJ4moqNfEfDxg78l
        bR7fgFEjI34fc2QI6kOo+kI=
X-Google-Smtp-Source: AK7set++lLCPWpCH3WbC2pUXuZJG0NEFE1TSogb4t4CmGQevcuwiO9xdmyic1hbqdqcVh/rNSWkTxQ==
X-Received: by 2002:a17:906:ca2:b0:887:7871:2b2f with SMTP id k2-20020a1709060ca200b0088778712b2fmr16348414ejh.61.1676050197130;
        Fri, 10 Feb 2023 09:29:57 -0800 (PST)
Received: from arinc9-PC.lan ([37.120.152.236])
        by smtp.gmail.com with ESMTPSA id v24-20020a170906859800b0088c224bf5b5sm2660729ejx.148.2023.02.10.09.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 09:29:55 -0800 (PST)
From:   arinc9.unal@gmail.com
X-Google-Original-From: richard@routerhints.com
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     Richard van Schagen <richard@routerhints.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, erkin.bozoglu@xeront.com
Subject: [PATCH net-next] net: dsa: mt7530: add support for changing DSA master
Date:   Fri, 10 Feb 2023 20:29:43 +0300
Message-Id: <20230210172942.13290-1-richard@routerhints.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard van Schagen <richard@routerhints.com>

Add support for changing the master of a port on the MT7530 DSA subdriver.

[ arinc.unal@arinc9.com: Wrote subject and changelog ]

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Richard van Schagen <richard@routerhints.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index b5ad4b4fc00c..04bb4986454e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1072,6 +1072,38 @@ mt7530_port_disable(struct dsa_switch *ds, int port)
 	mutex_unlock(&priv->reg_mutex);
 }
 
+static int
+mt7530_port_change_master(struct dsa_switch *ds, int port,
+				       struct net_device *master,
+				       struct netlink_ext_ack *extack)
+{
+	struct mt7530_priv *priv = ds->priv;
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_port *cpu_dp = master->dsa_ptr;
+	int old_cpu = dp->cpu_dp->index;
+	int new_cpu = cpu_dp->index;
+
+	mutex_lock(&priv->reg_mutex);
+
+	/* Move old to new cpu on User port */
+	priv->ports[port].pm &= ~PCR_MATRIX(BIT(old_cpu));
+	priv->ports[port].pm |= PCR_MATRIX(BIT(new_cpu));
+
+	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_MATRIX_MASK,
+		   priv->ports[port].pm);
+
+	/* Move user port from old cpu to new cpu */
+	priv->ports[old_cpu].pm &= ~PCR_MATRIX(BIT(port));
+	priv->ports[new_cpu].pm |= PCR_MATRIX(BIT(port));
+
+	mt7530_write(priv, MT7530_PCR_P(old_cpu), priv->ports[old_cpu].pm);
+	mt7530_write(priv, MT7530_PCR_P(new_cpu), priv->ports[new_cpu].pm);
+
+	mutex_unlock(&priv->reg_mutex);
+
+	return 0;
+}
+
 static int
 mt7530_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
@@ -3157,6 +3189,7 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.set_ageing_time	= mt7530_set_ageing_time,
 	.port_enable		= mt7530_port_enable,
 	.port_disable		= mt7530_port_disable,
+	.port_change_master	= mt7530_port_change_master,
 	.port_change_mtu	= mt7530_port_change_mtu,
 	.port_max_mtu		= mt7530_port_max_mtu,
 	.port_stp_state_set	= mt7530_stp_state_set,
-- 
2.37.2

