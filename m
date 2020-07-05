Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584AC215053
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 01:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgGEXQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 19:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727970AbgGEXQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 19:16:05 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD84FC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 16:16:04 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id q7so29994943ljm.1
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 16:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oRQbxGVGZRD34g3pn9EV0X0GK2Ho/RF1IeE++Md7qkI=;
        b=QP7cfWz/ldEhdIAeGCP3P75O8pe555+s8FMGP+meZ9ys8vIeT7CKdwoLtYE46MMcQt
         sEV9isfe6GBIcNQqB7lxVTaoF6uA+keLUDPc9+BeHljI7RS61ALlN8D0GukHoKtC3ijP
         5+CzMbZ19UN34bySHn+iTe+lz7wJgxkKfrbteuufet9mTjgY0ZkarIZNfdKge12sKk4Q
         YZA0aOrHMN3sLsXbRIYlepd2LgTDUGVa7A/39IzIOdLGDrT5kdm6/1VihKWc1/wwu66s
         +z5mQVm9vHjkahkjJVTRvfEDvrRWCOuMrS5kmmEfdrFxgSInu11TIAZ0+JX7eMxnM8CG
         J2Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oRQbxGVGZRD34g3pn9EV0X0GK2Ho/RF1IeE++Md7qkI=;
        b=VwXnINp/S02J/oJPT+pqfVSrYxef5TKflaPfhO7PKmOOHASUL/FjluNJvMwriknes7
         e05+neAcBtuJ/nlKN38zqUOYgi+2v4kaGSTmqxwNKvAELuVeU2ETgEjHOLnXkPnt4y9T
         hMIfQr3OstArTGEajDze9CAkeS2LXqiAc5Gz4/A0zg/RSTPqhbaMlFAG2dikYKxTIy7F
         nN6TcUvyYxIroJNbJaVLsKyYWeWECdDMcKvZQMWcSubIuc7Z6SpiFSxFhznMbd/z74LG
         BMwAHrMKN+k+fOmoXx/q7Azg14FXhGQcZ7tWFhYoVg5GOYnp+e1mLUGVBnfhQD5DWNvC
         E0Ow==
X-Gm-Message-State: AOAM532JShbXRK2Ooqo0ACnJndcpGT63fpWqJyTKjTrXJUDC8w/j4CC/
        UV6pId3g94jDHUD7SYrHf77gLw==
X-Google-Smtp-Source: ABdhPJzdMIc7XF9Yx44g2WLMaZnxLbk94+vFhOcwcUvRhYt4pjwr7KeWRg77A74xziq2r5mZo1M23w==
X-Received: by 2002:a2e:9641:: with SMTP id z1mr22542348ljh.173.1593990963210;
        Sun, 05 Jul 2020 16:16:03 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id f14sm8439410lfa.35.2020.07.05.16.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 16:16:02 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [net-next PATCH 4/5 v3] net: dsa: rtl8366: VLAN 0 as disable tagging
Date:   Mon,  6 Jul 2020 01:15:49 +0200
Message-Id: <20200705231550.77946-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200705231550.77946-1-linus.walleij@linaro.org>
References: <20200705231550.77946-1-linus.walleij@linaro.org>
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

