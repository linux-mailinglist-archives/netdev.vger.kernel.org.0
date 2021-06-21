Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21CC3AF84D
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhFUWNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhFUWNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 18:13:14 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B6FC061574;
        Mon, 21 Jun 2021 15:10:58 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id e20so15318746pgg.0;
        Mon, 21 Jun 2021 15:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UF4/JJqG6JXnFjCPq71Sx5BtNeVSInrBkeRyP6YGuP8=;
        b=ZVUi5rMMu9e8N20YsHUrih7hDTgSGkWPZN7wCDYc8AVmkWcSf9J1mbZGy4QOzmEaLb
         BeQKcrKQRBilqUJgxGpAJ6cBcwL0l5/YY1w5jYkCFCu8NuwBARzKf3BrESrUjLDQCH5p
         XGepzKRzk8KQXmOEC59rDlkVUT4wH3v+fmHCE0HceL2+WwXkM+1exgcwShbKZr6pONnK
         Ddo4rE17wqrhLF99VPZkX1IbhO0QuC0EOeuMp7djZT+a4bYJKPziVODD+/AYuGwNbCIS
         p77jzdAu5+CLVc2n+JpRC7LJHz8SoNZoIwE45VZIkYl+Wb/UKabZynqmJbkD/Wflzi8U
         MXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UF4/JJqG6JXnFjCPq71Sx5BtNeVSInrBkeRyP6YGuP8=;
        b=mq5tkElvsC0K5EueOSoP68LThvnrqiX5+ZRgqupQ+Ac3rmSGvvXRMqUoIzf8Vu06CT
         +0Vqb+w20BaK7XRH6QevNZz3/2MB3P2i88B83Cy5v5vjkK8WLLrkGTySgkmDc1LW3pNr
         4QfMufAh9kNrzgvAS5c83YJ74b/KZd2Vaxnh9q4bGGUH1PXOLwKNGQO4o2AUF8c+PfWu
         28W+/Rc6XwjN8nDfSha5PXfedwvjxG3Q4nQwOuuorjCksTJbCdxgL5VMvVLJK/aFBXHO
         GkCMoH5Kx0j+4QaTL5vSObvT14PU2Qd+U+yDLyC4iBaf5ez+fxQSeuGScw97rBGmcAbz
         s+Cw==
X-Gm-Message-State: AOAM530v8JH10/M3jM2MFjUGr9HT4yy30xiVeraIPPFoA2mzYj/QneDj
        nwEIFhK1xXJkyfYDKf2QA2HTVo80fqw=
X-Google-Smtp-Source: ABdhPJxmAZNHrmc5d9ModStTgJeuMjkjt3YAmpLXR75ph+zdA5U9g++LQvjn6vpnAas4bbrgqcEewQ==
X-Received: by 2002:aa7:8509:0:b029:2e5:8cfe:bc17 with SMTP id v9-20020aa785090000b02902e58cfebc17mr398740pfn.2.1624313458063;
        Mon, 21 Jun 2021 15:10:58 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v6sm16484470pfi.46.2021.06.21.15.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 15:10:57 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2] net: dsa: b53: Create default VLAN entry explicitly
Date:   Mon, 21 Jun 2021 15:10:55 -0700
Message-Id: <20210621221055.958628-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case CONFIG_VLAN_8021Q is not set, there will be no call down to the
b53 driver to ensure that the default PVID VLAN entry will be configured
with the appropriate untagged attribute towards the CPU port. We were
implicitly relying on dsa_slave_vlan_rx_add_vid() to do that for us,
instead make it explicit.

Reported-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

- use b53_vlan_port_needs_forced_tagged() as suggested by Vladimir in
  his review

 drivers/net/dsa/b53/b53_common.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 6e199454e41d..b23e3488695b 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -728,6 +728,13 @@ static u16 b53_default_pvid(struct b53_device *dev)
 		return 0;
 }
 
+static bool b53_vlan_port_needs_forced_tagged(struct dsa_switch *ds, int port)
+{
+	struct b53_device *dev = ds->priv;
+
+	return dev->tag_protocol == DSA_TAG_PROTO_NONE && dsa_is_cpu_port(ds, port);
+}
+
 int b53_configure_vlan(struct dsa_switch *ds)
 {
 	struct b53_device *dev = ds->priv;
@@ -748,9 +755,20 @@ int b53_configure_vlan(struct dsa_switch *ds)
 
 	b53_enable_vlan(dev, -1, dev->vlan_enabled, ds->vlan_filtering);
 
-	b53_for_each_port(dev, i)
+	/* Create an untagged VLAN entry for the default PVID in case
+	 * CONFIG_VLAN_8021Q is disabled and there are no calls to
+	 * dsa_slave_vlan_rx_add_vid() to create the default VLAN
+	 * entry. Do this only when the tagging protocol is not
+	 * DSA_TAG_PROTO_NONE
+	 */
+	b53_for_each_port(dev, i) {
+		v = &dev->vlans[def_vid];
+		v->members |= BIT(i);
+		if (!b53_vlan_port_needs_forced_tagged(ds, i))
+			v->untag = v->members;
 		b53_write16(dev, B53_VLAN_PAGE,
 			    B53_VLAN_PORT_DEF_TAG(i), def_vid);
+	}
 
 	/* Upon initial call we have not set-up any VLANs, but upon
 	 * system resume, we need to restore all VLAN entries.
@@ -1460,13 +1478,6 @@ static int b53_vlan_prepare(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static bool b53_vlan_port_needs_forced_tagged(struct dsa_switch *ds, int port)
-{
-	struct b53_device *dev = ds->priv;
-
-	return dev->tag_protocol == DSA_TAG_PROTO_NONE && dsa_is_cpu_port(ds, port);
-}
-
 int b53_vlan_add(struct dsa_switch *ds, int port,
 		 const struct switchdev_obj_port_vlan *vlan,
 		 struct netlink_ext_ack *extack)
-- 
2.25.1

