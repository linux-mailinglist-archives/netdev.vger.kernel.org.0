Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081424C8BA4
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 13:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbiCAMcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 07:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbiCAMcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 07:32:00 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F4157154
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 04:31:19 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id i11so26616186lfu.3
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 04:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J0rKdVpN1zJbCddDzfZ8gqZ9iGgeFZuK48Px54tScXY=;
        b=cKJcQvAkunhUjecgJQCCoUXAFhgJmdmUCL5HTgdJCwi4gleU3sUYilfniyOrQNL9K8
         8YGNmcpl/ZA2CbU1rsEMsz+qJJ/V8HSf5JJMD0sUSFMgUL5D44V5bP6juWcQWZh+zxbm
         tq+E6jIKqfT1XEFgAiyr7QvA8r4tY9sZ0Cc6AIzviXMW9nZWGB1ktFP16TfTpxCpBHZz
         OdaLI+pj1ESTBso7OeOFldwJgAsSuxJ5frqVphq7nD0D1qvZXB2T6Y3fU5m2hPRPghjW
         mXU6yxunoo4ezhjH/yt0H8ZBNgq4E0M0BxrKRFjqtefU4bX0mGbjJzC9mh7YND8EdiFl
         J4qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J0rKdVpN1zJbCddDzfZ8gqZ9iGgeFZuK48Px54tScXY=;
        b=Xmlbf/3e1emx5gvm+9h98ZOE84u2nlWWC84RT0xgIAs2jwnDZdyaHuQpwnPe2WnRvA
         jJN2FyxfkTXtIrfDugzh9lyJe2E3d4U4hzQufmBdEyFql5aXqECoQja++CE93FguFrjA
         UMmnlJ+X8wTp13OjprTslTl0NPaKH1EEuoOe0RznJkWMjqnZiV/phi1i52JgzSa9ba1q
         vN69pVuciTdPKSAECvfcqGw99z1QnSfKCUpB1nN4o8kdscTMQhE5lYARp3Q+r8U0ulQd
         2dfJqd0sMzrp5MoELKwU82CTM6VDhmbXLe7AhA6e0ZQzDrKBOUZAnlvJar0JzxL1kYKO
         58Tg==
X-Gm-Message-State: AOAM533OWS32LAWKZBBLeged/9ah9Tuv2lsDli1qryMVyI1XiOmC+hJh
        ZKrWMQXCC+mbqahxnjmW4dRlhOxdwvfRY2zxOyc=
X-Google-Smtp-Source: ABdhPJzPPApjXZtzdx/PSq1l+5H6Tw4D8NbompHK8QzqhqwJQR7a2zRLv73CZRgkMrGNs566MjWC7Q==
X-Received: by 2002:ac2:44b8:0:b0:430:2ad7:2a21 with SMTP id c24-20020ac244b8000000b004302ad72a21mr14833841lfm.410.1646137877140;
        Tue, 01 Mar 2022 04:31:17 -0800 (PST)
Received: from wse-c0089.westermo.com (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id i8-20020a0565123e0800b0044312b4112dsm1470459lfv.52.2022.03.01.04.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 04:31:16 -0800 (PST)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
X-Google-Original-From: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
Subject: [PATCH 2/3] dsa: Handle the local_receive flag in the DSA layer.
Date:   Tue,  1 Mar 2022 13:31:03 +0100
Message-Id: <20220301123104.226731-3-mattias.forsblad+netdev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
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

Add infrastructure to be able to handle the local_receive
flag to the DSA layer.

Signed-off-by: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
---
 include/net/dsa.h  |  6 ++++++
 net/dsa/dsa_priv.h |  1 +
 net/dsa/slave.c    | 16 ++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index cfedcfb86350..3abd7cfad7a0 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -925,6 +925,12 @@ struct dsa_switch_ops {
 	void	(*get_regs)(struct dsa_switch *ds, int port,
 			    struct ethtool_regs *regs, void *p);
 
+	/*
+	 * Local receive
+	 */
+	int	(*set_local_receive)(struct dsa_switch *ds, int port,
+				     struct net_device *bridge, bool enable);
+
 	/*
 	 * Upper device tracking.
 	 */
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 07c0ad52395a..33e607615e63 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -217,6 +217,7 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct netlink_ext_ack *extack);
 bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
 int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
+int dsa_port_set_local_receive(struct dsa_port *dp, struct net_device *br, bool enable);
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
 			bool targeted_match);
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 089616206b11..50f88b0bd851 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -295,6 +295,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
 		ret = dsa_port_vlan_filtering(dp, attr->u.vlan_filtering,
 					      extack);
 		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_LOCAL_RECEIVE:
+		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
+		ret = dsa_port_set_local_receive(dp, attr->orig_dev, attr->u.local_receive);
+		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
 		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
 			return -EOPNOTSUPP;
@@ -671,6 +677,16 @@ dsa_slave_get_regs(struct net_device *dev, struct ethtool_regs *regs, void *_p)
 		ds->ops->get_regs(ds, dp->index, regs, _p);
 }
 
+int dsa_port_set_local_receive(struct dsa_port *dp, struct net_device *br, bool enable)
+{
+	struct dsa_switch *ds = dp->ds;
+
+	if (ds->ops->set_local_receive)
+		return ds->ops->set_local_receive(ds, dp->index, br, enable);
+
+	return 0;
+}
+
 static int dsa_slave_nway_reset(struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-- 
2.25.1

