Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19F6381278
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbhENVDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbhENVCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:02:03 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8FAC061353;
        Fri, 14 May 2021 14:00:40 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id t15so33748edr.11;
        Fri, 14 May 2021 14:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6RjWESHDfj0DrKyCYgS1JZFX794WyKjuGdF5hu3Dq1o=;
        b=pmP8NAgMjdNughx/3ojz//hBaQebQZR2BJY+2nf5riK6me/MNzzKlFmKmqEdUBE9ih
         XR/WQueVEG2/wZc+z/3+RJINsossj7lpT4sw8DhUym1RssmTkbMrO2ZBiAASWx/vfQeK
         dyIlREMEOHNc5e9qLF4tz7xAZK3vaehqQGORdkQ9pDceKuwkgkyz6pXtLciE4uBrENOf
         k2x3I6qbGkvvUNMUmmYOFc3WMXWgPMzOfieeiJfDO/lccEp9RyTNqSksmQXe83fS59ue
         gpeBPHZOwKkbCgRLk1pefFFf0hg4kUJParTDEIwkO4EhnUT4yH6JY5vwsHcv//xDcWmz
         PKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6RjWESHDfj0DrKyCYgS1JZFX794WyKjuGdF5hu3Dq1o=;
        b=dPz3Zu1s4wqWskwiZRmvOOrmALykR/6Dd7NzG64AWS2eu/JFupuCak2uts4bO7mGs4
         +2iO8WmoR9EkRNOrPFlBe0tSoQmM6Vg6rWLW3uycJqUcWGazT3/7QtlpHH37p7F7Hw1h
         jAR53KmZB8N436EKNGpSOr5ceAScCOrNkVfdEdplIrLVIUr8Jly57tSyuOvdrQQRmfXp
         RzJoYBdboNjGZlyQ0YC8k3KeJJu803+HqnrPPbVwmXT4NoSyqdpvRNBREi97EEwoiljC
         ZxDskA87tCyeu/AYRrADxbKHuK27gbWKSrt8XYtr8P6bdltQ73Qv3imJ5zJai9qFHh9F
         JpPA==
X-Gm-Message-State: AOAM532USUW9nXDvHFCjW0o0oz4AP/2/I3CxsiexUDKODcuOOZtS4Oz+
        qHU+3EH74Kjw/3TBLK1wgRA=
X-Google-Smtp-Source: ABdhPJwoYCGrpNxmCUCgci3YuOms/bfS2EpM4c5rlPV2wu/KrjgYxVFftJsjtRS6iBAn85s1vxEyFg==
X-Received: by 2002:a05:6402:12d3:: with SMTP id k19mr57614229edx.52.1621026039661;
        Fri, 14 May 2021 14:00:39 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:39 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next v6 23/25] net: dsa: qca8k: pass switch_revision info to phy dev_flags
Date:   Fri, 14 May 2021 23:00:13 +0200
Message-Id: <20210514210015.18142-24-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define get_phy_flags to pass switch_Revision needed to tweak the
internal PHY with debug values based on the revision.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/qca8k.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index ccb3d89cf58c..4753228f02b3 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1732,6 +1732,22 @@ qca8k_port_vlan_del(struct dsa_switch *ds, int port,
 	return ret;
 }
 
+static u32 qca8k_get_phy_flags(struct dsa_switch *ds, int port)
+{
+	struct qca8k_priv *priv = ds->priv;
+
+	/* Communicate to the phy internal driver the switch revision.
+	 * Based on the switch revision different values needs to be
+	 * set to the dbg and mmd reg on the phy.
+	 * The first 2 bit are used to communicate the switch revision
+	 * to the phy driver.
+	 */
+	if (port > 0 && port < 6)
+		return priv->switch_revision;
+
+	return 0;
+}
+
 static enum dsa_tag_protocol
 qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
 		       enum dsa_tag_protocol mp)
@@ -1765,6 +1781,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.phylink_mac_config	= qca8k_phylink_mac_config,
 	.phylink_mac_link_down	= qca8k_phylink_mac_link_down,
 	.phylink_mac_link_up	= qca8k_phylink_mac_link_up,
+	.get_phy_flags		= qca8k_get_phy_flags,
 };
 
 static int qca8k_read_switch_id(struct qca8k_priv *priv)
-- 
2.30.2

