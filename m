Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4462822483A
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 05:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgGRDFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 23:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728970AbgGRDFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 23:05:52 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03172C0619D2;
        Fri, 17 Jul 2020 20:05:52 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id s26so6266672pfm.4;
        Fri, 17 Jul 2020 20:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IwiSc8ny1eiqFoZFL5UVikvl9/Kv6xkm+XtoA/y4ccI=;
        b=HoniX5YxiN+/rdvP/6xfbQHUK5ubUPWgsAMQf85wATqoauNmTPR03IkbUsoOFzBxYD
         6t5VU+ynh6FV7GsLQnDWNBDVKaP+cLk7WBxCATaXLs3t2xTQPq+kDYrrsZU8Kyz3qL90
         B4C5r4lTH97ibG7tq7dyfCccAtqmTjoeSQDU3DAhoyS4oM337CNWgp++j/P/CYwBOskS
         5WTsO8xSiVVYXYv5G2fraq0varfzCjmI9RKg17RjXmVr6jCOQd1ADOVEb7tS5kK/LdhD
         BURun2TKckqhWKHYjsyCIFTxERdTizPTWP/8ExMqi83j/rEHj35z5NbIKn5EJoiKc8Yy
         y1Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IwiSc8ny1eiqFoZFL5UVikvl9/Kv6xkm+XtoA/y4ccI=;
        b=KxoJZAldSL8/EylpU7/G30a+nyP+xm94bKivglG8egKDtZFNhiUxqchqlOPilEKOrO
         wRWPsYK9OHJhjGNFPo06DQNJxUzZDwyRlgKPd4V2zdmdgDgdxuHQH3WU83hfjJltK2Vo
         EdmKhCm7SwB+7V1MOB0o0FzReDLZWPIVUixU/mHBLcG9+16rjRNQQa10R4pkM804K5ZD
         b7b1L352u3n5Q1tAIgeDx4OAdjPVqctO8F1OfoExA+rgnfUCMh+Ya6igM+qR+Rn62Vo6
         wIY6mhEMLpOejbd3T12qalcwc8BRqLP716rMYGgJS8/2EYwBR20NZk7az2Xn+1CIWfTP
         t8Gw==
X-Gm-Message-State: AOAM5304NmV8XcBySDTZBxo9QQfMPVhf8Tq6z/cP13oGwwM0UkdSvvyt
        qNqRaNzCt13lYiIn0F2c9V67R8ME
X-Google-Smtp-Source: ABdhPJwBSyti78al7Z9WVBUxUhtUwxeX+t2Y91nI/T9uOnPC8zG3je1GXa4klFoyTAE7iTNJoxwmsg==
X-Received: by 2002:a62:834c:: with SMTP id h73mr10908926pfe.221.1595041551056;
        Fri, 17 Jul 2020 20:05:51 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id c9sm617331pjr.35.2020.07.17.20.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 20:05:50 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 4/4] net: dsa: Setup dsa_netdev_ops
Date:   Fri, 17 Jul 2020 20:05:33 -0700
Message-Id: <20200718030533.171556-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200718030533.171556-1-f.fainelli@gmail.com>
References: <20200718030533.171556-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we hav all the infrastructure in place for calling into the
dsa_ptr->netdev_ops function pointers, install them when we configure
the DSA CPU/management interface and tear them down. The flow is
unchanged from before, but now we preserve equality of tests when
network device drivers do tests like dev->netdev_ops == &foo_ops which
was not the case before since we were allocating an entirely new
structure.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/net/dsa.h |  1 -
 net/dsa/master.c  | 52 ++++++++++++-----------------------------------
 2 files changed, 13 insertions(+), 40 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 681ba2752514..c9f350303947 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -230,7 +230,6 @@ struct dsa_port {
 	 * Original copy of the master netdev net_device_ops
 	 */
 	const struct dsa_netdevice_ops *netdev_ops;
-	const struct net_device_ops *orig_ndo_ops;
 
 	bool setup;
 };
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 480a61460c23..0a90911ae31b 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -220,12 +220,17 @@ static int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		break;
 	}
 
-	if (cpu_dp->orig_ndo_ops && cpu_dp->orig_ndo_ops->ndo_do_ioctl)
-		err = cpu_dp->orig_ndo_ops->ndo_do_ioctl(dev, ifr, cmd);
+	if (dev->netdev_ops->ndo_do_ioctl)
+		err = dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
 
 	return err;
 }
 
+static const struct dsa_netdevice_ops dsa_netdev_ops = {
+	.ndo_do_ioctl = dsa_master_ioctl,
+	.ndo_get_phys_port_name = dsa_master_get_phys_port_name,
+};
+
 static int dsa_master_ethtool_setup(struct net_device *dev)
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
@@ -260,38 +265,10 @@ static void dsa_master_ethtool_teardown(struct net_device *dev)
 	cpu_dp->orig_ethtool_ops = NULL;
 }
 
-static int dsa_master_ndo_setup(struct net_device *dev)
-{
-	struct dsa_port *cpu_dp = dev->dsa_ptr;
-	struct dsa_switch *ds = cpu_dp->ds;
-	struct net_device_ops *ops;
-
-	if (dev->netdev_ops->ndo_get_phys_port_name)
-		return 0;
-
-	ops = devm_kzalloc(ds->dev, sizeof(*ops), GFP_KERNEL);
-	if (!ops)
-		return -ENOMEM;
-
-	cpu_dp->orig_ndo_ops = dev->netdev_ops;
-	if (cpu_dp->orig_ndo_ops)
-		memcpy(ops, cpu_dp->orig_ndo_ops, sizeof(*ops));
-
-	ops->ndo_get_phys_port_name = dsa_master_get_phys_port_name;
-	ops->ndo_do_ioctl = dsa_master_ioctl;
-
-	dev->netdev_ops  = ops;
-
-	return 0;
-}
-
-static void dsa_master_ndo_teardown(struct net_device *dev)
+static void dsa_netdev_ops_set(struct net_device *dev,
+			       const struct dsa_netdevice_ops *ops)
 {
-	struct dsa_port *cpu_dp = dev->dsa_ptr;
-
-	if (cpu_dp->orig_ndo_ops)
-		dev->netdev_ops = cpu_dp->orig_ndo_ops;
-	cpu_dp->orig_ndo_ops = NULL;
+	dev->dsa_ptr->netdev_ops = ops;
 }
 
 static ssize_t tagging_show(struct device *d, struct device_attribute *attr,
@@ -353,9 +330,7 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 	if (ret)
 		return ret;
 
-	ret = dsa_master_ndo_setup(dev);
-	if (ret)
-		goto out_err_ethtool_teardown;
+	dsa_netdev_ops_set(dev, &dsa_netdev_ops);
 
 	ret = sysfs_create_group(&dev->dev.kobj, &dsa_group);
 	if (ret)
@@ -364,8 +339,7 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 	return ret;
 
 out_err_ndo_teardown:
-	dsa_master_ndo_teardown(dev);
-out_err_ethtool_teardown:
+	dsa_netdev_ops_set(dev, NULL);
 	dsa_master_ethtool_teardown(dev);
 	return ret;
 }
@@ -373,7 +347,7 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 void dsa_master_teardown(struct net_device *dev)
 {
 	sysfs_remove_group(&dev->dev.kobj, &dsa_group);
-	dsa_master_ndo_teardown(dev);
+	dsa_netdev_ops_set(dev, NULL);
 	dsa_master_ethtool_teardown(dev);
 	dsa_master_reset_mtu(dev);
 
-- 
2.25.1

