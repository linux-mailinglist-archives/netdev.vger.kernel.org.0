Return-Path: <netdev+bounces-12297-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6AA3737075
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 17:30:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA61E1C20BCF
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1BF1174DD;
	Tue, 20 Jun 2023 15:30:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C422F168CA
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 15:30:50 +0000 (UTC)
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D6412C;
	Tue, 20 Jun 2023 08:30:49 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-30fcde6a73cso4212687f8f.2;
        Tue, 20 Jun 2023 08:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687275047; x=1689867047;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ae2LgDthYgLW0wGsnuwxcKqUllQXntc3z/XI8MH0us0=;
        b=W4B4js9sbTcYqkHFBdWrlEW67dJIQ9ckcPv3hPGn/p071Qp/UkvdZ9UFNo9T/jNTEM
         5OgLCijugVYQ6kxDF09bgxasUp+fxMlv0ImlJ1Whqwhz7O0frsxVRP6n0LA5rQOrskYr
         K8ILGvMXdU0FT/bH24OkYOsPgFXp/xF17LMfHrHYGSDUl5gwQ0rO0bzaORXP5iIQd+2X
         VsTKVHKp3lu3zzTY0QFTpSKrADnZX35ZufllZkaBKXgExlE1DjwqNFCV1z8zolqZWbMv
         Tu05fUWqidjmjzXBxm+gq0CfcszOg/dYUyD0YzDci0DFk1E3SnVSOAZ9L8i6nkKjXUcA
         3lTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687275047; x=1689867047;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ae2LgDthYgLW0wGsnuwxcKqUllQXntc3z/XI8MH0us0=;
        b=X+p4h8ISsGB0FO+K/xOpZrv71KcM0i41s71MAazO3S4sn/E2EdgfokfzkWtS2gZHzp
         GgjH/cxlup2Z83q3IZxjf4dXTmSytkGvqFnR3vWuVjscqNUvsb0Je+k4JXPmxbMiQLkj
         AcJgBCcFeiQp6ZBpdlUVd5GT+rHJ7tWaRa4tUKB7L8RlT9YL0+7tTzCs+tMaVRWEQcBe
         cmFUEL3Ieq5c6hGmNzgIda38f3CCaEMObpY+bqoOwFATnijZq2lCoIHJ3eksp7Uy4o6n
         OdvPSHMCme9vFRMnbVah3z7n1H/0Jy+aI7QfMg607tx1rWsn/p/I1EZC/D7WUSC/xw94
         XVvw==
X-Gm-Message-State: AC+VfDzUnTIq1AwzYix2AYDdmTTrikNuWFzGK7Bmo8MbX8vxIYGnEdng
	gAjDA5FilZLqNLLWYVeIBJg=
X-Google-Smtp-Source: ACHHUZ5GnHcfugDgd0XE3cZekfe53P+lJWs+b2hSpyP+EXbIooCMVZdL2AP0/hH7Ju6xeohECP4deQ==
X-Received: by 2002:adf:f289:0:b0:30a:c341:920a with SMTP id k9-20020adff289000000b0030ac341920amr8897925wro.28.1687275047270;
        Tue, 20 Jun 2023 08:30:47 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id k10-20020adff5ca000000b0030ae87bd3e3sm2265887wrp.18.2023.06.20.08.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 08:30:46 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [net-next PATCH] net: dsa: qca8k: add support for port_change_master
Date: Tue, 20 Jun 2023 08:37:47 +0200
Message-Id: <20230620063747.19175-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for port_change_master to permit assigning an alternative
CPU port if the switch have both CPU port connected or create a LAG on
both CPU port and assign the LAG as DSA master.

On port change master request, we check if the master is a LAG.
With LAG we compose the cpu_port_mask with the CPU port in the LAG, if
master is a simple dsa_port, we derive the index.

Finally we apply the new cpu_port_mask to the LOOKUP MEMBER to permit
the port to receive packet by the new CPU port setup for the port and
we reenable the target port previously disabled.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 54 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h      |  1 +
 2 files changed, 55 insertions(+)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index dee7b6579916..435b69c1c552 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1713,6 +1713,59 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
 	return DSA_TAG_PROTO_QCA;
 }
 
+static int qca8k_port_change_master(struct dsa_switch *ds, int port,
+				    struct net_device *master,
+				    struct netlink_ext_ack *extack)
+{
+	struct qca8k_priv *priv = ds->priv;
+	u32 val, cpu_port_mask = 0;
+	struct dsa_port *dp;
+	int ret;
+
+	/* With LAG of CPU port, compose the mask for LOOKUP MEMBER */
+	if (netif_is_lag_master(master)) {
+		struct dsa_lag *lag;
+		int id;
+
+		id = dsa_lag_id(ds->dst, master);
+		lag = dsa_lag_by_id(ds->dst, id);
+
+		dsa_lag_foreach_port(dp, ds->dst, lag)
+			if (dsa_port_is_cpu(dp))
+				cpu_port_mask |= BIT(dp->index);
+	} else {
+		dp = dsa_port_from_netdev(master);
+		cpu_port_mask |= BIT(dp->index);
+	}
+
+	/* Disable port */
+	qca8k_port_set_status(priv, port, 0);
+
+	/* Connect it to new cpu port */
+	ret = qca8k_read(priv, QCA8K_PORT_LOOKUP_CTRL(port), &val);
+	if (ret)
+		return ret;
+
+	/* Reset connected CPU port in LOOKUP MEMBER */
+	val &= QCA8K_PORT_LOOKUP_USER_MEMBER;
+	/* Assign the new CPU port in LOOKUP MEMBER */
+	val |= cpu_port_mask;
+
+	ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+			QCA8K_PORT_LOOKUP_MEMBER,
+			val);
+	if (ret)
+		return ret;
+
+	/* Fast Age the port to flush FDB table */
+	qca8k_port_fast_age(ds, port);
+
+	/* Reenable port */
+	qca8k_port_set_status(priv, port, 1);
+
+	return 0;
+}
+
 static void
 qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
 		    bool operational)
@@ -1996,6 +2049,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_phy_flags		= qca8k_get_phy_flags,
 	.port_lag_join		= qca8k_port_lag_join,
 	.port_lag_leave		= qca8k_port_lag_leave,
+	.port_change_master	= qca8k_port_change_master,
 	.master_state_change	= qca8k_master_change,
 	.connect_tag_protocol	= qca8k_connect_tag_protocol,
 };
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index c5cc8a172d65..424f851db881 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -250,6 +250,7 @@
 #define   QCA8K_GLOBAL_FW_CTRL1_MC_DP_MASK		GENMASK(14, 8)
 #define   QCA8K_GLOBAL_FW_CTRL1_UC_DP_MASK		GENMASK(6, 0)
 #define QCA8K_PORT_LOOKUP_CTRL(_i)			(0x660 + (_i) * 0xc)
+#define   QCA8K_PORT_LOOKUP_USER_MEMBER			GENMASK(5, 1)
 #define   QCA8K_PORT_LOOKUP_MEMBER			GENMASK(6, 0)
 #define   QCA8K_PORT_LOOKUP_VLAN_MODE_MASK		GENMASK(9, 8)
 #define   QCA8K_PORT_LOOKUP_VLAN_MODE(x)		FIELD_PREP(QCA8K_PORT_LOOKUP_VLAN_MODE_MASK, x)
-- 
2.40.1


