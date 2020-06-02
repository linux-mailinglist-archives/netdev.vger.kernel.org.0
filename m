Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15101EC414
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 22:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgFBUzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 16:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728344AbgFBUza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 16:55:30 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92140C08C5C1
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 13:55:29 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id x27so7026681lfg.9
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 13:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DAGbGvKTFRgsrcbWvEMabetSYmagh9X/tluny71DaEI=;
        b=ic1iGGw3YK+VZfTt6Cvec421xVeXIIukkEJqi6yfGCu19J6bYL1UHgU5xcoULsdj1q
         e+ta8yutZwixinlgzNjn+MfT4w7B6omeSUpLDUykcZ2p9FhBaa0Ej61XeSV9Nxpf2ipL
         wnP03n8OTVVqmhzTenEE8Lxg0r01ieFEZNFvffw0kOAlAzJwooaNlFSc7XSDBwiQRw0X
         UZeJS63ckco6/0VuJ3lng9tUivoUFKTzv0k57Q0zbFPk6tWipBOd3dib+s5awXzRot/e
         zom+KFHhTb0C2Ul+UzfXH0Ws21AmHAusKkyVJ5X2r6EKh2Kh99rlF0JM94KcIiTcKNEk
         dfOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DAGbGvKTFRgsrcbWvEMabetSYmagh9X/tluny71DaEI=;
        b=s48vVm4YEieAYlzEYerNJyNxglWOWB68drG0TqPYeFPI5jQzUfR/8O0Kvt1MdfG02y
         LSawQaDmWB+2IWSyOT6vPmkDZuCPTY8QUK826APr7Bdqk2K8ZC/owyXxlHj9zaICN0GV
         sodxxf/xZZ+ORpb5Ngz7om/A0BT/h89pT/gqLG/7rVX42e9Q+3AcMuqM78TnhgDsCDTO
         r/jI5xq4Mwcd0AfMzrOKaQtDkv8YW7VXelKU0xXXL856FZN5WH4Nh2rSl+H32BcjAJtA
         qJ6dsFGa5W7PGTeGNtlrd7um7SIMu5WS2wA/9iMksfBQbkxPoVSmX45YFHvY8zCO22MO
         h4jg==
X-Gm-Message-State: AOAM531UtRPGm5H6oWJRbQT5tJV1z6wYpyvZ8nxtTTCWdRomyzKrN+EV
        iGY0YFuk2klmo71w0l989hikfQ==
X-Google-Smtp-Source: ABdhPJyLY5SxKgpXxKFBFP37u12X4ZqV98OZnkLlWvWljVY4M/Q/9fzU2aEZRYZS+IqLqiPumPJ9fg==
X-Received: by 2002:ac2:5466:: with SMTP id e6mr592690lfn.175.1591131328012;
        Tue, 02 Jun 2020 13:55:28 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-8cdb225c.014-348-6c756e10.bbcust.telenor.se. [92.34.219.140])
        by smtp.gmail.com with ESMTPSA id t5sm41962lff.39.2020.06.02.13.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 13:55:27 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [net-next PATCH 4/5] net: dsa: rtl8366: VLAN 0 as disable tagging
Date:   Tue,  2 Jun 2020 22:54:55 +0200
Message-Id: <20200602205456.2392024-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200602205456.2392024-1-linus.walleij@linaro.org>
References: <20200602205456.2392024-1-linus.walleij@linaro.org>
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
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/rtl8366.c | 65 +++++++++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 66bd1241204c..7f0691a6da13 100644
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

