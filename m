Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F423845DEBC
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 17:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356498AbhKYQuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 11:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356503AbhKYQsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 11:48:10 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E909AC06175C
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 08:30:57 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id gt5so5515076pjb.1
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 08:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kB1Q0F8u/V5RhkU5JZvou2ANlULc8WAu+CSGoVVasUk=;
        b=Or63XuPzdxcE5ruCTLYDFPHT9EeuQMMyjMC7dS5b1J2X8MYuGIXayN+fXSTNF64jtX
         +zKfzDLwxRTXkmMkCVN+G7E++Iisw/2spDprb1ZyDsbypeMihy0ZEJQvMUgNjLIkE1CB
         oL1yObbQdE/JP4GmVyUvZxkBuR89+PcdG+3l5J2v1zVtLuVqN8W7/fCEy/1HYy+hD/QJ
         PU/iKQS4c2+Y4SvpQVWX4TGOf3DIaw/mg458k1PFwWyUl9W9SU8WYVgUvDfwDXaxfig2
         cjs0oxekSCkV7ox5rTvlTTsIZYYbtf517VCxabd3ra24e3R0KCKp+0bZR4HOHvICzPY8
         yFpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kB1Q0F8u/V5RhkU5JZvou2ANlULc8WAu+CSGoVVasUk=;
        b=QiEt6aWTQBvA5EhROO6j6lLqC9soe8xr9xwWNI/qg/w7sw7CurJ8HtesU7wlJTAi/d
         le1z3FCYaBtJq5QaJkwZYziT/919qCLw0XSn92ALajso/EnJiYOwsTeHAcyZY50Ca8e0
         JZupi99dOxI2W8zSk6bMbBiX/VWX2LEWvpklQgSuSFfL+F2AjY4ZTJycf15otUwqNbL3
         Fqld++UXDNUpf3kycFxJ70LofZrI9LUd3eZWnlgv/kLjXNsnCEtUJpCQUoDdcBVzOU3Z
         bWtHAh8yrU8vsoXXOl6oLLeFaVat+8PX3Qna7VbFgcsjrzhWBJh0/2w3c7x6iZ/4t/he
         ODAg==
X-Gm-Message-State: AOAM533J/15zdeo6sc+E5wKmKAn50CLxaM0arDucRWWNazX7nJeRMGgu
        EW7ECvVT1j3xPjT4dywa2Q1ZksbfCslmwrzn
X-Google-Smtp-Source: ABdhPJzSsmxkw2bNrOzMEJVYVjnDMA2Ya0i57l/6U1rlRtfhCVRXqflEejH5K/fEkYitXUcf95A7tA==
X-Received: by 2002:a17:90b:105:: with SMTP id p5mr8777962pjz.60.1637857857002;
        Thu, 25 Nov 2021 08:30:57 -0800 (PST)
Received: from localhost.localdomain ([111.201.150.233])
        by smtp.gmail.com with ESMTPSA id o6sm3773863pfh.70.2021.11.25.08.30.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Nov 2021 08:30:56 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hao Chen <chenhao288@hisilicon.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Danielle Ratson <danieller@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next v3] net: ethtool: set a default driver name
Date:   Fri, 26 Nov 2021 00:30:49 +0800
Message-Id: <20211125163049.84970-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The netdev (e.g. ifb, bareudp), which not support ethtool ops
(e.g. .get_drvinfo), we can use the rtnl kind as a default name.

ifb netdev may be created by others prefix, not ifbX.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Hao Chen <chenhao288@hisilicon.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Danielle Ratson <danieller@nvidia.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
v2: remove unnecessary white line
v1: https://lore.kernel.org/all/20211124181858.6c4668db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/ 
---
 net/ethtool/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index af2d4e022076..3d7bff407580 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -734,6 +734,9 @@ ethtool_get_drvinfo(struct net_device *dev, struct ethtool_devlink_compat *rsp)
 			sizeof(rsp->info.bus_info));
 		strlcpy(rsp->info.driver, dev->dev.parent->driver->name,
 			sizeof(rsp->info.driver));
+	} else if (dev->rtnl_link_ops) {
+		strlcpy(rsp->info.driver, dev->rtnl_link_ops->kind,
+			sizeof(rsp->info.driver));
 	} else {
 		return -EOPNOTSUPP;
 	}
-- 
2.27.0

