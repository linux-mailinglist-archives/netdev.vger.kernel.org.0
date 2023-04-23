Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4706EBCA3
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 05:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjDWD2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 23:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjDWD2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 23:28:52 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D40268C
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 20:28:51 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-32b1c8ff598so29320575ab.3
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 20:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682220531; x=1684812531;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p2zQDhkK5lKaWRelWoXh0mPSTQhbApTm4KvEZpVaTCM=;
        b=Gcos/7Gp4huSTIB/us95wVt+1ewWc/oBcO2HoJliiwTkRK6zrdd7zYp0jPL9hLhZqu
         VOBpQXsVf/0u/Sa3flVhRlzQMmTDZ5UBaKwBzdqEO38dgfwVsyVl/Ezqh8aLC4Z/LuE2
         FBODO8RAGt7MjJDrCOt/Dqh34ldMISQdPavY1afZsJWKvqGebJxq3ZjKPbPMm8sMsBZ5
         sUoDJleDONHkJ8jE1RKp+Uu+tsmlLAxHovGTb52YV54VVkwEaOjqVp3n7TuAHt/54Dk+
         p8yD/eGPb6roZpDJwcQBy0wIaCRDXC0g1FLNByDVJrZ7zwPnKwNoDzzc9NCX8frNpbRl
         e3Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682220531; x=1684812531;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p2zQDhkK5lKaWRelWoXh0mPSTQhbApTm4KvEZpVaTCM=;
        b=gtnTqBEtLIqW2frrMXNA1tLUxV4fdKDTrmYTf7Hf/n1Aiw+dVE+sQ1PVIfRDsagyHA
         MJzMPWWv2nh0dZz3J6AOEm+phDCrf8B8dpwui0ig5GOeVnTP/YXfUIghjynmd1HYuxIT
         G+owmP9liqV4mTi20gMR3Gvsfc4Ljv+Vy83Fs9+OFNp0neYf1oh7yNoiCL2obRbFhRw0
         4sD++3nLP6pt8lbeVoL2ZdWq2hxPu34pRG1GQ3JVdhhkz8dOwLPukVzcLaGxh2FgMuVi
         TBPEhqV6i5shbogFjawqD1Aww/rGqiTQ9semZw3n0LcG00BY5Qy3UShhYFcE4xYF+mgp
         Fs9Q==
X-Gm-Message-State: AAQBX9dtpsFiYNscvexcDR8NGnDZYQfaawgpuvlf8Eep9YO99b2UIxZG
        aprHdcAJ1sOL2VUVXEGR41o=
X-Google-Smtp-Source: AKy350bdEYGE3/kxoQJeOoK4GCIYKOnh0diW7zH7tuiLqIplXSGXyqVGB0nzN+W+tMVuR2sEznL3tA==
X-Received: by 2002:a92:da86:0:b0:325:eb13:1045 with SMTP id u6-20020a92da86000000b00325eb131045mr2973988iln.2.1682220531055;
        Sat, 22 Apr 2023 20:28:51 -0700 (PDT)
Received: from lenovot480s.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id cx27-20020a056638491b00b0040fa19472bcsm2384977jab.92.2023.04.22.20.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 20:28:50 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: [RFC PATCH v4 4/5] Add ndo_hwtstamp_get/set support to bond driver
Date:   Sat, 22 Apr 2023 21:28:49 -0600
Message-Id: <20230423032849.285441-1-glipus@gmail.com>
X-Mailer: git-send-email 2.39.2
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

This patch changes bonding net driver to use the newly
introduced ndo_hwtstamp_get/set API to pass hw timestamp
requests to underlying NIC drivers in case if these drivers
implement ndo_hwtstamp_get/set functions. Otherwise VLAN subsystem
falls back to calling ndo_eth_ioctl.

Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Maxim Georgiev <glipus@gmail.com>
---
 drivers/net/bonding/bond_main.c | 106 ++++++++++++++++++++------------
 1 file changed, 66 insertions(+), 40 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 710548dbd0c1..21969afff2a9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4408,11 +4408,6 @@ static int bond_eth_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cm
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct mii_ioctl_data *mii = NULL;
-	const struct net_device_ops *ops;
-	struct net_device *real_dev;
-	struct hwtstamp_config cfg;
-	struct ifreq ifrr;
-	int res = 0;
 
 	netdev_dbg(bond_dev, "bond_eth_ioctl: cmd=%d\n", cmd);
 
@@ -4439,44 +4434,11 @@ static int bond_eth_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cm
 		}
 
 		break;
-	case SIOCSHWTSTAMP:
-		if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
-			return -EFAULT;
-
-		if (!(cfg.flags & HWTSTAMP_FLAG_BONDED_PHC_INDEX))
-			return -EOPNOTSUPP;
-
-		fallthrough;
-	case SIOCGHWTSTAMP:
-		real_dev = bond_option_active_slave_get_rcu(bond);
-		if (!real_dev)
-			return -EOPNOTSUPP;
-
-		strscpy_pad(ifrr.ifr_name, real_dev->name, IFNAMSIZ);
-		ifrr.ifr_ifru = ifr->ifr_ifru;
-
-		ops = real_dev->netdev_ops;
-		if (netif_device_present(real_dev) && ops->ndo_eth_ioctl) {
-			res = ops->ndo_eth_ioctl(real_dev, &ifrr, cmd);
-			if (res)
-				return res;
-
-			ifr->ifr_ifru = ifrr.ifr_ifru;
-			if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
-				return -EFAULT;
-
-			/* Set the BOND_PHC_INDEX flag to notify user space */
-			cfg.flags |= HWTSTAMP_FLAG_BONDED_PHC_INDEX;
-
-			return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ?
-				-EFAULT : 0;
-		}
-		fallthrough;
 	default:
-		res = -EOPNOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
-	return res;
+	return 0;
 }
 
 static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd)
@@ -5650,6 +5612,68 @@ static u32 bond_mode_bcast_speed(struct slave *slave, u32 speed)
 	return speed;
 }
 
+static int bond_set_phc_index_flag(struct kernel_hwtstamp_config *kernel_cfg)
+{
+	struct ifreq *ifr = kernel_cfg->ifr;
+	struct hwtstamp_config cfg;
+
+	if (kernel_cfg->kernel_flags & KERNEL_HWTSTAMP_FLAG_IFR_RESULT) {
+		if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+			return -EFAULT;
+
+		cfg.flags |= HWTSTAMP_FLAG_BONDED_PHC_INDEX;
+		if (copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)))
+			return -EFAULT;
+	} else {
+		kernel_cfg->flags |= HWTSTAMP_FLAG_BONDED_PHC_INDEX;
+	}
+
+	return 0;
+}
+
+static int bond_hwtstamp_get(struct net_device *dev,
+			     struct kernel_hwtstamp_config *cfg,
+			     struct netlink_ext_ack *extack)
+{
+	struct bonding *bond = netdev_priv(dev);
+	struct net_device *real_dev;
+	int err;
+
+	real_dev = bond_option_active_slave_get_rcu(bond);
+	if (!real_dev)
+		return -EOPNOTSUPP;
+
+	err = generic_hwtstamp_get_lower(real_dev, cfg, extack);
+	if (err)
+		return err;
+
+	/* Set the BOND_PHC_INDEX flag to notify user space */
+	return bond_set_phc_index_flag(cfg);
+}
+
+static int bond_hwtstamp_set(struct net_device *dev,
+			     struct kernel_hwtstamp_config *kernel_cfg,
+			     struct netlink_ext_ack *extack)
+{
+	struct bonding *bond = netdev_priv(dev);
+	struct net_device *real_dev;
+	int err;
+
+	if (!(kernel_cfg->flags & HWTSTAMP_FLAG_BONDED_PHC_INDEX))
+		return -EOPNOTSUPP;
+
+	real_dev = bond_option_active_slave_get_rcu(bond);
+	if (!real_dev)
+		return -EOPNOTSUPP;
+
+	err = generic_hwtstamp_set_lower(real_dev, kernel_cfg, extack);
+	if (err)
+		return err;
+
+	/* Set the BOND_PHC_INDEX flag to notify user space */
+	return bond_set_phc_index_flag(kernel_cfg);
+}
+
 static int bond_ethtool_get_link_ksettings(struct net_device *bond_dev,
 					   struct ethtool_link_ksettings *cmd)
 {
@@ -5798,6 +5822,8 @@ static const struct net_device_ops bond_netdev_ops = {
 	.ndo_bpf		= bond_xdp,
 	.ndo_xdp_xmit           = bond_xdp_xmit,
 	.ndo_xdp_get_xmit_slave = bond_xdp_get_xmit_slave,
+	.ndo_hwtstamp_get	= bond_hwtstamp_get,
+	.ndo_hwtstamp_set	= bond_hwtstamp_set,
 };
 
 static const struct device_type bond_type = {
-- 
2.39.2

