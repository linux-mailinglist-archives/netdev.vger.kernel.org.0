Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528871FC8AC
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 10:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgFQIby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 04:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbgFQIbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 04:31:50 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433DCC061573
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 01:31:50 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id c21so776449lfb.3
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 01:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R+fhW7L/u1g2GZLNXnrZ/DQIstEkMgoZ0j/B9QHwiHM=;
        b=aU1m5bSI59zbxyVgpp7MctbufSwfhKqhEkvfyDnkXFKW9zfziKvXsBb3svZs83R2t2
         iEqi5j3X3EVwamRvT5nKh+y28NBFO3xf7O3mAdw4e3H/2YPTUxtXYxr4yZMcLLiTPh/G
         xMR/erdDBdDR0+UwXIdH9Lg71kT9Ja77HBkFiS2hj40XaeujgzKsBWxL23ghO52/HQ3G
         eBvwxjbO+HnSYIUMOWyimE02fG43G36j5+CU1QFgTGFrHIGwSGHsjYNlwvgE4dmyh7ub
         9ezG57FDp0LL3CJ3+oknAkxNZdiWf3kU7fjniqszZA4cBYxKif9rkFto2cyfAG2Sa41T
         97TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R+fhW7L/u1g2GZLNXnrZ/DQIstEkMgoZ0j/B9QHwiHM=;
        b=F61ciAHVGO7TMSOZIO+ilUGWuafIOdhVLU0zhx+MC2gHZQ8dZplKfNQrWWnyb49EsA
         AqO7HCEToycvWz6YABBnnvZIbWRQbf5F3YbPIDKOKWhJ//p+YO0aVG5fDXKjcqqXJOFj
         50CEvctV1PwOoZ6LGiRBvZutSP6BpY7Iddt3qtT1cRef9KBebvVK2rZc0ZX0f8a+IBF2
         YcKXWNz6Gk8uDaNa7/phzD7r5PjqMfoMtwJm3V5NEeXpM2NsQDRh9LgEltM2t8cgSG4r
         u8Yvk9eFB2HkYI7E1pY1eaiEvJPP/sEBPxt39+QnKLW95CbrxLphQwBm03femQqmTYvQ
         xHlA==
X-Gm-Message-State: AOAM5329Fxyj/aNz+YrlsFrq6cDQTN1OwSmvuODm5xYoaMxdJBpgjpe0
        GuNeB/n+2+oMMDa6ERr0aindPw==
X-Google-Smtp-Source: ABdhPJyBN94pBKXm66Qz7pzHZr59a17h1BwbPsOcCHZHYFSGdqzcGmHEVi7RvFMLgEFAgRfdts63fQ==
X-Received: by 2002:a05:6512:104c:: with SMTP id c12mr3963492lfb.200.1592382708648;
        Wed, 17 Jun 2020 01:31:48 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id c3sm89554lfi.91.2020.06.17.01.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 01:31:48 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [net-next PATCH 4/5 v2] net: dsa: rtl8366: VLAN 0 as disable tagging
Date:   Wed, 17 Jun 2020 10:31:31 +0200
Message-Id: <20200617083132.1847234-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200617083132.1847234-1-linus.walleij@linaro.org>
References: <20200617083132.1847234-1-linus.walleij@linaro.org>
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
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Rebased on v5.8-rc1 and other changes.
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

