Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B6E3410D0
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhCRXTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbhCRXSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:18:52 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B24C06174A;
        Thu, 18 Mar 2021 16:18:51 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id b16so8699796eds.7;
        Thu, 18 Mar 2021 16:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zlfAvXNWE3S7CXSOBmWtvk2P2IUMmzDXPio79UgCm6k=;
        b=k6zUNDmDdn3I8P+IfOO6WpFjxdRcg9w0ahG57RtMRI2bCbT+Dfmj2RoHvYHmDyKyGz
         UAoepk3+P5MxBsoQrmk8mvXNo95cs1MGTrUeUxQuRfMJIpvMod/18fxvx6MTc2Ad3oXT
         YlAS7812SNiIgJWjPsQ/rhKMBfD2NQ0ND955zM23raNIJcYutRb68GL1SyxwxvQ1ayUg
         +lhf/KEvINnTFokZgaaHyK/qyc16Dd9m82gR2AzWds7ZAoC8gWHRfQv5cjJStlqb5q5b
         /1zwpMFHxt/iAJjSkBm7QnAc9ecPqdT5h1DerFMXdEbvnCzayo3ZdQ+BJW5XSpk0URDf
         bVZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zlfAvXNWE3S7CXSOBmWtvk2P2IUMmzDXPio79UgCm6k=;
        b=WpWZWfheG9J1cn9ryLroMLVmfNctpvNxdH6LG5pm56t4Vh6lrK9ceywAO2ellVu9kD
         gJ57leXfZk1hCwtFXe84HM2fiYc1JI4w4GHjFRNg4vyByU3N94OPGCr8LxYPOsriWCgW
         nJnnt3/zNyOGzx3rBcoR8kKjyPLVsSV4HmV3aDI1LnXjBoGba2g03vj5/9fdEhAkhgfe
         ONy6r57cCLc5J7g3sErJkhuN+4uO5zDst7i3JcA5Z6SBGPVz9CpYUbuFb9XHCc1qdpRt
         7umoTR3CyK4ZfKkd4YmHHusfZvZvVdgqXGOWen7MuyB7N3u7Cl7r6xBD/N4N/ADbCZFE
         Y/Ag==
X-Gm-Message-State: AOAM530vA6j3v9X2TKox1BU0JE/hDQBaWsP0dXo9WRGwC0VuYGjiWxCY
        Xww6r6+m5HGGKzKjJeb+uLk=
X-Google-Smtp-Source: ABdhPJzwEKH7YXmMxBVXRY+8vgrTT4x7bB17yM3RVWRZ20cVG/sgku1Ne5gzlK1b7VSgeIFbZ786Cg==
X-Received: by 2002:a50:d753:: with SMTP id i19mr6475521edj.43.1616109530821;
        Thu, 18 Mar 2021 16:18:50 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bx24sm2801131ejc.88.2021.03.18.16.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 16:18:50 -0700 (PDT)
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
Subject: [RFC PATCH v2 net-next 05/16] net: dsa: sync up VLAN filtering state when joining the bridge
Date:   Fri, 19 Mar 2021 01:18:18 +0200
Message-Id: <20210318231829.3892920-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318231829.3892920-1-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is the same situation as for other switchdev port attributes: if we
join an already-created bridge port, such as a bond master interface,
then we can miss the initial switchdev notification emitted by the
bridge for this port.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 785374744462..ac1afe182c3b 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -172,6 +172,7 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 				   struct netlink_ext_ack *extack)
 {
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
+	struct net_device *br = dp->bridge_dev;
 	u8 stp_state;
 	int err;
 
@@ -184,6 +185,10 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
+	err = dsa_port_vlan_filtering(dp, br, extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	return 0;
 }
 
@@ -205,6 +210,8 @@ static void dsa_port_switchdev_unsync(struct dsa_port *dp)
 	 * so allow it to be in BR_STATE_FORWARDING to be kept functional
 	 */
 	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
+
+	/* VLAN filtering is handled by dsa_switch_bridge_leave */
 }
 
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
-- 
2.25.1

