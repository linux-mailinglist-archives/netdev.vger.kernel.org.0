Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEE921609F
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgGFUxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgGFUxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:53:04 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EC5C08C5DF
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 13:53:04 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id h19so47239372ljg.13
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 13:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qoKUfx+bRpgzp/ddkVCT09K2I1cceu5SICdacEnRFsc=;
        b=dXL2nwR1FHFz8hawRIFOqQ+ZRX40ODMEYiFqApVojfzJfKE9Tfa5UvJDg0BuPdeAg7
         DdT45jA4MoFvZBcnEbkJIgdQFvKOppIrA3I/0Zf1tyzyn+xYgrSlu7GEnKdN5Gi1euok
         ViAOWQdSrC/+1dsLi1YwILCPSLv0Y9KWC7MNhJ2xMkknSUbVwLYcAHQcAZNfCGKlmzqi
         XYQiBhpEJ/4nCDpxpYRmDMImUvoy2sA/pYbLC73s8EhOFoKUu5l73XSXYKjQjQvGm6E6
         UHG+dOwsEaCrIG9R5fqPwPQ1n99kwOKC76RstDpuj90KjEijhwkVxLwsFPkc/tmkIu2k
         3kiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qoKUfx+bRpgzp/ddkVCT09K2I1cceu5SICdacEnRFsc=;
        b=Pk/map70T45wWAu03lhz+m3gaQTZ5Fk4L8bmPLvqlrhnygVjM2sETmLDVtqF/jy3XO
         n+yaeIBqfbx0CmScVUIcIyLWQ4wT3pAfJ7YVZuqqss5K5rcY6yh8wjjqnPJ8MemtQasC
         G5gLs7s77+XvcUyXphxANzDreCtbq+fqsWH0QbX+iFdkJpQkkxGf1Ox/M9A1V6d0alkQ
         /J+x/8MeCqBEtJvp/rw15hXkItUWXyQhJjJT2OptNM7eLv642mbAYA/c8xpdFU6mi+xk
         AS2XXUVhAmGbMXbWUCKwHFmsIYP46A9RbH3YFMimj2PBOvlUUL2l0Lgp5fDlxT+R2gpl
         M7xg==
X-Gm-Message-State: AOAM532gGyF+iiAS/xh1PWPZSS3vhYTMEb17erNshFx6dvIubt/oVGP/
        cu8uCv/NVFEVlzIJvVUziHkKIQ==
X-Google-Smtp-Source: ABdhPJzlr2YZKW1pd/vWgz+UVr2d55yXoIDSOC6bDwdr3OUNQvcQIqvfVV8NS1f3uGGSoSqzKiP4GA==
X-Received: by 2002:a2e:9b41:: with SMTP id o1mr16107100ljj.360.1594068782597;
        Mon, 06 Jul 2020 13:53:02 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id t10sm624714ljg.60.2020.07.06.13.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 13:53:02 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [net-next PATCH 4/5 v4] net: dsa: rtl8366: VLAN 0 as disable tagging
Date:   Mon,  6 Jul 2020 22:52:44 +0200
Message-Id: <20200706205245.937091-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200706205245.937091-1-linus.walleij@linaro.org>
References: <20200706205245.937091-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code in net/8021q/vlan.c, vlan_device_event() sets
VLAN 0 for a VLAN-capable ethernet device when it
comes up.

Since the RTL8366 DSA switches must have a VLAN and
PVID set up for any packets to come through we have
already set up default VLAN for each port as part of
bringing the switch online.

Make sure that setting VLAN 0 has the same effect
and does not try to actually tell the hardware to use
VLAN 0 on the port because that will not work.

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v3->v4:
- Resend with the rest
ChangeLog v2->v3:
- Collected Andrew's review tag.
ChangeLog v1->v2:
- Rebased on v5.8-rc1 and other changes.
---
 drivers/net/dsa/rtl8366.c | 65 +++++++++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index b907c0ed9697..a000d458d121 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -355,15 +355,25 @@ int rtl8366_vlan_prepare(struct dsa_switch *ds, int port,
 			 const struct switchdev_obj_port_vlan *vlan)
 {
 	struct realtek_smi *smi = ds->priv;
+	u16 vid_begin = vlan->vid_begin;
+	u16 vid_end = vlan->vid_end;
 	u16 vid;
 	int ret;
 
-	for (vid = vlan->vid_begin; vid < vlan->vid_end; vid++)
+	if (vid_begin == 0) {
+		dev_info(smi->dev, "prepare VLAN 0 - ignored\n");
+		if (vid_end == 0)
+			return 0;
+		/* Skip VLAN 0 and start with VLAN 1 */
+		vid_begin = 1;
+	}
+
+	for (vid = vid_begin; vid < vid_end; vid++)
 		if (!smi->ops->is_vlan_valid(smi, vid))
 			return -EINVAL;
 
 	dev_info(smi->dev, "prepare VLANs %04x..%04x\n",
-		 vlan->vid_begin, vlan->vid_end);
+		 vid_begin, vid_end);
 
 	/* Enable VLAN in the hardware
 	 * FIXME: what's with this 4k business?
@@ -383,27 +393,46 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 	bool untagged = !!(vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED);
 	bool pvid = !!(vlan->flags & BRIDGE_VLAN_INFO_PVID);
 	struct realtek_smi *smi = ds->priv;
+	u16 vid_begin = vlan->vid_begin;
+	u16 vid_end = vlan->vid_end;
 	u32 member = 0;
 	u32 untag = 0;
 	u16 vid;
 	int ret;
 
-	for (vid = vlan->vid_begin; vid < vlan->vid_end; vid++)
-		if (!smi->ops->is_vlan_valid(smi, vid))
+	if (vid_begin == 0) {
+		dev_info(smi->dev, "set VLAN 0 on port %d = default VLAN\n",
+			 port);
+		/* Set up default tagging */
+		ret = rtl8366_set_default_vlan_and_pvid(smi, port);
+		if (ret) {
+			dev_err(smi->dev,
+				"error setting default VLAN on port %d\n",
+				port);
 			return;
+		}
+		if (vid_end == 0)
+			return;
+		/* Skip VLAN 0 and start with VLAN 1 */
+		vid_begin = 1;
+	}
 
-	dev_info(smi->dev, "add VLAN on port %d, %s, %s\n",
-		 port,
-		 untagged ? "untagged" : "tagged",
-		 pvid ? " PVID" : "no PVID");
+	for (vid = vid_begin; vid < vid_end; vid++)
+		if (!smi->ops->is_vlan_valid(smi, vid))
+			return;
 
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		dev_err(smi->dev, "port is DSA or CPU port\n");
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
+	for (vid = vid_begin; vid <= vid_end; ++vid) {
 		int pvid_val = 0;
 
-		dev_info(smi->dev, "add VLAN %04x\n", vid);
+		dev_info(smi->dev, "add VLAN %04x to port %d, %s, %s\n",
+			 vid,
+			 port,
+			 untagged ? "untagged" : "tagged",
+			 pvid ? " PVID" : "no PVID");
+
 		member |= BIT(port);
 
 		if (untagged)
@@ -437,15 +466,25 @@ int rtl8366_vlan_del(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_vlan *vlan)
 {
 	struct realtek_smi *smi = ds->priv;
+	u16 vid_begin = vlan->vid_begin;
+	u16 vid_end = vlan->vid_end;
 	u16 vid;
 	int ret;
 
-	dev_info(smi->dev, "del VLAN on port %d\n", port);
+	if (vid_begin == 0) {
+		dev_info(smi->dev, "remove port %d from VLAN 0 (no-op)\n",
+			 port);
+		if (vid_end == 0)
+			return 0;
+		/* Skip VLAN 0 and start with VLAN 1 */
+		vid_begin = 1;
+	}
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
+	for (vid = vid_begin; vid <= vid_end; ++vid) {
 		int i;
 
-		dev_info(smi->dev, "del VLAN %04x\n", vid);
+		dev_info(smi->dev, "remove VLAN %04x from port %d\n",
+			 vid, port);
 
 		for (i = 0; i < smi->num_vlan_mc; i++) {
 			struct rtl8366_vlan_mc vlanmc;
-- 
2.26.2

