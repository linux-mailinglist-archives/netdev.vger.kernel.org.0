Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2C622564E
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 05:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgGTDuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 23:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgGTDuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 23:50:09 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AEBC0619D4;
        Sun, 19 Jul 2020 20:50:09 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id gc9so9497102pjb.2;
        Sun, 19 Jul 2020 20:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nG0iPsD5QdkdQaph/ibFlBdWV0TfbW/UttIf3Q4vXdA=;
        b=jViuHJvrdhaQg3FS2W9I3rv84tB4aLPhLI24ZW+zHZOYroh3hmghwhhaWfmGcUhoEM
         EzDrkgOA0EtoZTqqCb8R/lkm9WTeNzQd6gvP8RmSqhs4l6WrxHb+0hwDW+Gyu9WJGlsU
         vyLDQ1ZCM3Qvk7yhttgnoC+uoD1rm2Ibf8RYSjwggtjDnAa/SnnxlGhPkVQBmS2eyxw0
         QDjPaflW20UIuQdt9ijtJs2HSSaI2RUW13NqGIWILx21eGP0DNSzgXqpgNf9DjgSy0wx
         BcODhOpJIXvyIPMEUk1N8PsTAltTcbQIPMuOn71RCapv5JmulHHTE4DClOKK9989we70
         VHWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nG0iPsD5QdkdQaph/ibFlBdWV0TfbW/UttIf3Q4vXdA=;
        b=st1jC5dGmpTRohJkenfuKAmLA3SWfMl8V1zRmpNYpUx9wLLSpt2fMXz7HqaRV210sb
         pwFjGluJmk35KxXP/jJz9u7xyUguFOBFrqWSSRbOvpnrsNp3s8EKG2qnBtEAKWD/8rV2
         3+Nsd0DwxgjD1R2QgNvqMHPJsYQ9f832n3p/p+JQ6yW9UW3mXZOGkcs+6t3DCOUDkyaW
         kBqS+OfRX6eVGpfXKc93YAU7C/fDBQEanD5R6rlThudffhRhPKLJhK6mzIWuSnuA4g4f
         vEpjBZC6bJucJLHr5L0Arwl76GJuVKSWZwQzUIwhjP+2LUovS5qYVsq+L2RCQL9Sz4j5
         0BWA==
X-Gm-Message-State: AOAM533IvfHsptSwifORPSJNo54oBKa5YHCXmNbuv/eIGOsvb3OuvKD5
        cpfpjwzGR3EOreZJC9+CKlhxJ/BT
X-Google-Smtp-Source: ABdhPJwf8BzhJpEXLmJ/cI0ofcipsewX/PEGNwbcMs2ksgdgIZVORiXquhl5ZYtY2fUMnpcopdIi0A==
X-Received: by 2002:a17:90b:4d0f:: with SMTP id mw15mr21480190pjb.68.1595217008347;
        Sun, 19 Jul 2020 20:50:08 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id z11sm15183445pfj.104.2020.07.19.20.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2020 20:50:07 -0700 (PDT)
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
        linux-kernel@vger.kernel.org (open list), olteanv@gmail.com
Subject: [PATCH net-next v2 4/4] net: dsa: Setup dsa_netdev_ops
Date:   Sun, 19 Jul 2020 20:49:54 -0700
Message-Id: <20200720034954.66895-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720034954.66895-1-f.fainelli@gmail.com>
References: <20200720034954.66895-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have all the infrastructure in place for calling into the
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
index 343642ca4f63..f1b63d06d132 100644
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

