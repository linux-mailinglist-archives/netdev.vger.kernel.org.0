Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5FE3410C5
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhCRXSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhCRXSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:18:47 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3B7C06174A;
        Thu, 18 Mar 2021 16:18:47 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id va9so6625637ejb.12;
        Thu, 18 Mar 2021 16:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6JJj0ufaYQtmeqHh7qCdzdSBFSVuwqgC4NE6eUBZZsg=;
        b=NbGSDh8euvAZI83uy1QITKTUgbeeJ3jrE+1onViGajniGNSuFYdUlAB0hEBnlMIs7t
         xahpodQrqRCleHrQ89dCnFPh91TkkuUWplDkGkWvDjdoo+4D6Mggnr3QWVspX9t3Kei+
         MwFYUvu8SUdEpkYK6xphvrlMaduoGm5/5yfolUfc99ovd0okbpOx+ZCGLWvdM8+wyETM
         mPQV/3D7rAWrBZvIN6qTSEAfiOBgXQBNCdbujEcrcC0JKGoJkmzWNO7OtNgTZXflLkqG
         RMDu/0pSxtCokWXyss776PapcLgioaPVRJAYj7GgycVPAxrHufmJZFZdQ+Htj/JxDaCQ
         63hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6JJj0ufaYQtmeqHh7qCdzdSBFSVuwqgC4NE6eUBZZsg=;
        b=c6FqDWxSLVSlV5O5J5mY72qYF74SLHXTCH5kH63hyfOYfJmh2Ll96p4nnCrVb8H4JJ
         eJW9hbqVOa2MSH9XNcqEtXKtc3zFgYw9G3UO52fSDOik6ZZ+SQTEd3gRNLqwNu+uNCNn
         BR8ooXEmmQMqZC1pNPFfwdY8bd7rwEMkN5DCk2v3oeiwM07Rj+j4l5p4OTD9gS0/Zazt
         Zxew4CGrXg9O9iNw491+QA/APMFAKYgN420KzVAz/eIReeSZPCt5jgsca2X4s5pOQBeF
         mprAtoLcRAHSoH7aZbrHvQ/+X7w7pmLm6yS2FguOGXoKzGMciG9reCDK4uouGPNvJSXm
         2tXQ==
X-Gm-Message-State: AOAM5310bM9cUTZFc54C1KdOK16iJUiNN+n8P0FAlBrwadYaf/pnhHmU
        u/J4f6jXs4JA4Aa4gEegfb0=
X-Google-Smtp-Source: ABdhPJxjQ0IwyP/ieRX9H0WTErDWtC+Mz6a7nv6tSLBSPHPq4qWQVLKKGzL0cShB+cKgj+1P+mvP0A==
X-Received: by 2002:a17:906:2404:: with SMTP id z4mr1110414eja.14.1616109526342;
        Thu, 18 Mar 2021 16:18:46 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bx24sm2801131ejc.88.2021.03.18.16.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 16:18:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 02/16] net: dsa: pass extack to dsa_port_{bridge,lag}_join
Date:   Fri, 19 Mar 2021 01:18:15 +0200
Message-Id: <20210318231829.3892920-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318231829.3892920-1-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is a pretty noisy change that was broken out of the larger change
for replaying switchdev attributes and objects at bridge join time,
which is when these extack objects are actually used.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h | 6 ++++--
 net/dsa/port.c     | 8 +++++---
 net/dsa/slave.c    | 7 +++++--
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 4c43c5406834..b8778c5d8529 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -181,12 +181,14 @@ int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
 int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
 void dsa_port_disable_rt(struct dsa_port *dp);
 void dsa_port_disable(struct dsa_port *dp);
-int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br);
+int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
+			 struct netlink_ext_ack *extack);
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
 int dsa_port_lag_change(struct dsa_port *dp,
 			struct netdev_lag_lower_state_info *linfo);
 int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
-		      struct netdev_lag_upper_info *uinfo);
+		      struct netdev_lag_upper_info *uinfo,
+		      struct netlink_ext_ack *extack);
 void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev);
 int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct netlink_ext_ack *extack);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index d39262a9fe0e..fcbe5b1545b8 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -144,7 +144,8 @@ static void dsa_port_change_brport_flags(struct dsa_port *dp,
 	}
 }
 
-int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
+int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
+			 struct netlink_ext_ack *extack)
 {
 	struct dsa_notifier_bridge_info info = {
 		.tree_index = dp->ds->dst->index,
@@ -241,7 +242,8 @@ int dsa_port_lag_change(struct dsa_port *dp,
 }
 
 int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag,
-		      struct netdev_lag_upper_info *uinfo)
+		      struct netdev_lag_upper_info *uinfo,
+		      struct netlink_ext_ack *extack)
 {
 	struct dsa_notifier_lag_info info = {
 		.sw_index = dp->ds->index,
@@ -263,7 +265,7 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag,
 	if (!bridge_dev || !netif_is_bridge_master(bridge_dev))
 		return 0;
 
-	err = dsa_port_bridge_join(dp, bridge_dev);
+	err = dsa_port_bridge_join(dp, bridge_dev, extack);
 	if (err)
 		goto err_bridge_join;
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 992fcab4b552..1ff48be476bb 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1976,11 +1976,14 @@ static int dsa_slave_changeupper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct netlink_ext_ack *extack;
 	int err = NOTIFY_DONE;
 
+	extack = netdev_notifier_info_to_extack(&info->info);
+
 	if (netif_is_bridge_master(info->upper_dev)) {
 		if (info->linking) {
-			err = dsa_port_bridge_join(dp, info->upper_dev);
+			err = dsa_port_bridge_join(dp, info->upper_dev, extack);
 			if (!err)
 				dsa_bridge_mtu_normalization(dp);
 			err = notifier_from_errno(err);
@@ -1991,7 +1994,7 @@ static int dsa_slave_changeupper(struct net_device *dev,
 	} else if (netif_is_lag_master(info->upper_dev)) {
 		if (info->linking) {
 			err = dsa_port_lag_join(dp, info->upper_dev,
-						info->upper_info);
+						info->upper_info, extack);
 			if (err == -EOPNOTSUPP) {
 				NL_SET_ERR_MSG_MOD(info->info.extack,
 						   "Offloading not supported");
-- 
2.25.1

