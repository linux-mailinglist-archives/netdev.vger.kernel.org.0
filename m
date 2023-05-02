Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94756F3CC1
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 06:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbjEBEcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 00:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbjEBEb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 00:31:59 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8F04483
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 21:31:58 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-763c3429aa6so261646539f.2
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 21:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683001917; x=1685593917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uXD+xT+8WJbTZw9PPdSypLYGLQQDJ6OoxlPkrP0zNaU=;
        b=mdkWUgFzw1mjM6S0YXMlQQgh/umlqnFB9x8HAoVYdg2huis+jhdarKLQjfifBBAc3/
         x1yT8fA5tvQEajo1OuVbnAbx5zfzeWgqd3OXNmBmP4iwcUhzwtQRjoyIk70xGfPIB7ur
         /BRmFqzVQFk8LTwuj9X756GXlK2MKNCOJJ5o/lye2OyjbrNzD3RdxlDGBGVVYmcllV63
         bIkAdfcMIFffpG5tSEZ0Lq+WJvKSDakcOT2j8xcXacBLSNP+gQJiIpWtpkeP3bdEBQr2
         Sn/Fg12kMhUtJP3ow/G27vMlu1jG/pY5oCmaSo7VPIsVQkYnPobRXRfl2AlIE2sgoJuQ
         1oVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683001917; x=1685593917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uXD+xT+8WJbTZw9PPdSypLYGLQQDJ6OoxlPkrP0zNaU=;
        b=MpCPR6IBsP0n+Yz2dh+gu11pTiMY8v2H2+6Kv6TiiuWx2K+sI1IH+nnkHVn/bE2U2Y
         gzdTmHcmw6XG0sqtNwOjy94Hpj7ZWQWSFR2FsQ26ur+JDMab2kCKuHBldwKTYfAdgfDC
         A90Epe6yQe1VxikxbmDjc9HlF6gVN3N/UE2Swm+2je6Xyj7e0Pf53o6FBMQeb38wYH5C
         oGwCrciiY79gVjeQQ9FINRRR/zaYa1n64WkOOguFNTx9cufGz+8zZOjHDeTr+VzPsD7b
         TJoUcBvtfq9NoAZ6yKe8cFG4C+QwuuPvQp09DHapph1R3OLKvwvFx90fwG7dMedfj4gI
         rf5A==
X-Gm-Message-State: AC+VfDxjoAsS47s219La5SRaRXNR11VTm9658uU0L8QRI2bJ8/ip4YkY
        5b6oQ+px5/Jn/QTOCstmu4Y=
X-Google-Smtp-Source: ACHHUZ7qqh5xFveMnzp5aHUtyQp4VDEghn1P4X0NXMksfHGRVBamkpSGElG022IsXh2MuHzkuprD1w==
X-Received: by 2002:a6b:ed05:0:b0:763:a593:68fc with SMTP id n5-20020a6bed05000000b00763a59368fcmr8965587iog.6.1683001917453;
        Mon, 01 May 2023 21:31:57 -0700 (PDT)
Received: from lenovot480s.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id a10-20020a5d980a000000b0076373f90e46sm8239781iol.33.2023.05.01.21.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 21:31:57 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, liuhangbin@gmail.com
Subject: [RFC PATCH net-next v6 4/5] bond: Add ndo_hwtstamp_get/set support to bond driver
Date:   Mon,  1 May 2023 22:31:49 -0600
Message-Id: <20230502043150.17097-5-glipus@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230502043150.17097-1-glipus@gmail.com>
References: <20230502043150.17097-1-glipus@gmail.com>
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
implement ndo_hwtstamp_get/set functions. Otherwise Bonding
subsystem falls back to calling ndo_eth_ioctl.

Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Maxim Georgiev <glipus@gmail.com>
---
Notes:
  Changes in v6:
  - Patch title was updated. No code changes.
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
2.40.1

