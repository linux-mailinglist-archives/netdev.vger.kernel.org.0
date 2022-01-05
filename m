Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97CC48541B
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240575AbiAEOKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:10:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38880 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240572AbiAEOKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:10:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641391837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NlQ/iPBEfAfoA23wZcas2lBzyY7TNPetcM4L9SBqmXA=;
        b=GFvNLSBqNTCWtP3zcIMfN6kukSVWzRVqE/YtS94gfjs2CFbs73LgvOHAhplnNeXSpOlgch
        ORyYm7sPv8vTK7O36TWraf6ZZBs3pAdL7tksIuBG+yR/U4Jew7CVBttEvr1Zg0rl3wFG9z
        Wa7mlXxZdbOs12feD63Sd/HEyZA7zeQ=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-qKd_2Vs9PzS9QiUagJIyBg-1; Wed, 05 Jan 2022 09:10:36 -0500
X-MC-Unique: qKd_2Vs9PzS9QiUagJIyBg-1
Received: by mail-ot1-f72.google.com with SMTP id e59-20020a9d2ac1000000b0058f1da0d3f1so10098903otb.15
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 06:10:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NlQ/iPBEfAfoA23wZcas2lBzyY7TNPetcM4L9SBqmXA=;
        b=y/G1NgugYCU47lcwLSWZQZ6OTTNmhYJkzqzEVcZmsdDr5HHiqeLur3J4ln3hO1bFaz
         aDtnM4ByjNYT7GHvm77ftDDN1xAi/PVgxPv9RvZhR3i08X3IwEYAXFfjDCINokcq8+Ay
         gdt4QsNnlOf0hOWS2iGjzaH+Z1gqT2iXqL5lmSu0gvbBFOyHVGSGNRYRXVzKxcZxXETv
         ZqXcHuftlDEOGe/4zJFqRnveMDsQJGItgfKZngkg5JKE1et/uv0PlNqOH0WPeNTpM8Zu
         2ThQVSBOi/lSbRpzSNK+iD4eXFWCY0i42GjXzuRmZSzCKcIqLrcOhONLrW1HNXNvHDWd
         TDfQ==
X-Gm-Message-State: AOAM5309y5IrrfciXO6QG1L68OiSXUF/DWszWRrFP6UlQTQDW6ScyKro
        Pj79HkYEDmHTcUF4bjYbLn91e061vuuzD0S55PZimAizj0MUYFqVOqbsKITdWfLfUPNVrPcT8oq
        jRw+ie17C4abf3oZg
X-Received: by 2002:a05:6808:a84:: with SMTP id q4mr2559827oij.28.1641391835674;
        Wed, 05 Jan 2022 06:10:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwWBhuU3WElHiaxFDGPLjyE+aT1ltvIPzv9WejzLCdA8z9si6UvEo9ovc8kAf5jYm53VGhXqA==
X-Received: by 2002:a05:6808:a84:: with SMTP id q4mr2559789oij.28.1641391835120;
        Wed, 05 Jan 2022 06:10:35 -0800 (PST)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id bg38sm10563593oib.40.2022.01.05.06.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 06:10:34 -0800 (PST)
From:   trix@redhat.com
To:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        arnd@arndb.de, danieller@nvidia.com, gustavoars@kernel.org,
        hkallweit1@gmail.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] ethtool: use phydev variable
Date:   Wed,  5 Jan 2022 06:10:20 -0800
Message-Id: <20220105141020.3793409-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

In ethtool_get_phy_stats(), the phydev varaible is set to
dev->phydev but dev->phydev is still used.  Replace
dev->phydev uses with phydev.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/ethtool/ioctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index b2cdba1b4aaec..326e14ee05dbf 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2096,9 +2096,9 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 	if (!phydev && (!ops->get_ethtool_phy_stats || !ops->get_sset_count))
 		return -EOPNOTSUPP;
 
-	if (dev->phydev && !ops->get_ethtool_phy_stats &&
+	if (phydev && !ops->get_ethtool_phy_stats &&
 	    phy_ops && phy_ops->get_sset_count)
-		n_stats = phy_ops->get_sset_count(dev->phydev);
+		n_stats = phy_ops->get_sset_count(phydev);
 	else
 		n_stats = ops->get_sset_count(dev, ETH_SS_PHY_STATS);
 	if (n_stats < 0)
@@ -2117,9 +2117,9 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 		if (!data)
 			return -ENOMEM;
 
-		if (dev->phydev && !ops->get_ethtool_phy_stats &&
+		if (phydev && !ops->get_ethtool_phy_stats &&
 		    phy_ops && phy_ops->get_stats) {
-			ret = phy_ops->get_stats(dev->phydev, &stats, data);
+			ret = phy_ops->get_stats(phydev, &stats, data);
 			if (ret < 0)
 				goto out;
 		} else {
-- 
2.26.3

