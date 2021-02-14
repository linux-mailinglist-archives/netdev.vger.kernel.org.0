Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562B631B106
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 16:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhBNPzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 10:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhBNPzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 10:55:12 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2E2C0613D6
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 07:54:31 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id n13so714078ejx.12
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 07:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w8uuS5lGKgU6bYXJs+VHgIg/y+o1fOn0rgEbBEtu94M=;
        b=S2BqRbtyQ728yMQiEDxSeY/Elh3NdLR3q+tHCXKVjX8aNIqO4KZFGjEIqK0oMLPheu
         7A2LOIw5czu91ToWoaNfarc7y3DvWbBYrguC1lAcFEiw8XTGdB5mECVpooLf9+4d9gtH
         wacGMwCkHBP+FXPfrPZdlw+lHLubGOioeU9hhgZ74dFRcAVFwEzsngUdW53lSwmBD9hB
         Mik66PGLgLWHjSIelx4heDl6GsbTsw8WtvlGJt+Q0hLzTeDbcU4nFl5zFohMqNhUXJuj
         nn+NpANsrsgYIfkEdU+v/daHlyWWPfEetpjjOnkJl6ylf4yZNvRgX7c3uqcoH+WBX03p
         ACig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w8uuS5lGKgU6bYXJs+VHgIg/y+o1fOn0rgEbBEtu94M=;
        b=U6CiIbaU2BNoNLkdGPrXYEFVlPkQ1kQhzPZ3nGHyJR8UQHOj1VcD9EyxNvR+qbDv2W
         JsT2LAZtip/ydI+2z84iwWPFHitlpcFteqzclXJUngBCMkqbkvhkub0MaBwI4X1jY6dx
         DJsHawsUTmfOmF7sFP9v7iZ5BpJCW4VShbdTC3RyhbUSatOMC7/GxyrLwUImnd+LgQtY
         lREHx1u6jIUfu2DBnmk24MndEmMgyTFrjf1rVaWaffE3QnYwaG5wcoWUMz7d4G2woOQP
         NHxFy8Z+wJ04CZw6wFfvC2GPf+ky7/vyJ4VY59tb/fJn73azpRaK0SQkn5iI11CkRXzJ
         ANwg==
X-Gm-Message-State: AOAM530jHibSRyBzoceoj5Cl9UVPdrsXx8zpeHJjOUy1JPEFpGzQ1rhR
        aoOYuYchCscnpr845UEIS40=
X-Google-Smtp-Source: ABdhPJzAxQ83I9qzxZM1X5yH0TNKBT64B99VoyY28cF4kEwKtiW15t51mz+HJT3EetNJLfKAw8iTiw==
X-Received: by 2002:a17:906:4c90:: with SMTP id q16mr12347463eju.49.1613318070550;
        Sun, 14 Feb 2021 07:54:30 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id cn18sm8576003edb.66.2021.02.14.07.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 07:54:30 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH net-next 2/4] net: dsa: reject switchdev objects centrally from dsa_slave_port_obj_{add,del}
Date:   Sun, 14 Feb 2021 17:53:24 +0200
Message-Id: <20210214155326.1783266-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210214155326.1783266-1-olteanv@gmail.com>
References: <20210214155326.1783266-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The dsa_port_offloads_netdev check is inside dsa_slave_vlan_{add,del},
but outside dsa_port_mdb_{add,del}. We can reduce the number of
occurrences of dsa_port_offloads_netdev by checking only once, at the
beginning of dsa_slave_port_obj_add and dsa_slave_port_obj_del.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 94bce3596eb6..8768b213c6e0 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -340,9 +340,6 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	struct switchdev_obj_port_vlan vlan;
 	int err;
 
-	if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
-		return -EOPNOTSUPP;
-
 	if (dsa_port_skip_vlan_configuration(dp)) {
 		NL_SET_ERR_MSG_MOD(extack, "skipping configuration of VLAN");
 		return 0;
@@ -385,10 +382,11 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int err;
 
+	if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+		return -EOPNOTSUPP;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
-			return -EOPNOTSUPP;
 		err = dsa_port_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
@@ -416,9 +414,6 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	struct switchdev_obj_port_vlan *vlan;
 	int err;
 
-	if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
-		return -EOPNOTSUPP;
-
 	if (dsa_port_skip_vlan_configuration(dp))
 		return 0;
 
@@ -442,10 +437,11 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int err;
 
+	if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+		return -EOPNOTSUPP;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
-			return -EOPNOTSUPP;
 		err = dsa_port_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
-- 
2.25.1

