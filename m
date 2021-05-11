Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC39379CB1
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhEKCK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbhEKCJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:09:27 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F830C061360;
        Mon, 10 May 2021 19:07:46 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id n2so18537629wrm.0;
        Mon, 10 May 2021 19:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DJf85nxR69z/IKM3e9jg3hcn7qldqV13DtN14Eg44tU=;
        b=Si1gonHqAV9KSijXAQKyMyRSkq8azzaeqXz/E/taqjYlarT8QL+9p/mmXlZkiCgdeW
         i55vTPrMVIADXTPiwc3V26bZcuPsqRN0z3f2icANjfiTh3H+rYNo8r0J4iZqki3/u7ig
         IRpXzZVXdNEI/fHlP8LUEi3eMmC6rCXDORU0CMw05+/AyUIwv1y1TSoE5ellgFNODU1b
         +R8WcRIfUtkLystMDi4/hVcEHPIx5jwLJfLCqDgvt7qZbMDSTuv9hjBXU77PfWAmmOXB
         9jQWPs800HgSK36JjKnLcoVy7H08BZ4FYNCl9ijbJD0x30LSj+YkNDTCvmKPyILLjsMp
         v/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DJf85nxR69z/IKM3e9jg3hcn7qldqV13DtN14Eg44tU=;
        b=ovAB/m+zcqqMCsl+ub7fNIt91KtjLPq228KcOFrhynlx0Oa58ksoRHCqS74QCyexZZ
         ErWkmy+edE/R9mFa7jKay8U6YabpF1g48p6rVRacVawBDflctEJj565wwN0mCWSxXklr
         3833rnBPb24t/7nWn2ootvqqIQ0d9tbm3TbhVpNJO+WsWJymxye8hQZO7hNFVVb74Vfl
         xunvAr92UxeWM3ywFiW2SqjEFr245tY9Ab6YScD94l3jeel+Txuo0Zsspe8PGz5sHFbm
         bG1PEV7EGLStulV/P09gG0WKzV4dRfRlC6Dz+bw2VGz6+OBXphDfdhbdHhVYJY6rYSQS
         H/hA==
X-Gm-Message-State: AOAM533IjbnYKCYacRFruBrTgBnavJHGPyai8GhLz8yO+OlYxMzpdPJm
        IuzjMMZrVREv3Z7H3l7wn10=
X-Google-Smtp-Source: ABdhPJxPKiDcLt04X5gfYU/QdVa+Qc3Bm+N1/auesDeSj2+Y5lit5NlrK4kI5G6mZvBIiyYyxnagBw==
X-Received: by 2002:a05:6000:508:: with SMTP id a8mr34298376wrf.315.1620698865027;
        Mon, 10 May 2021 19:07:45 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:44 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next v5 23/25] net: dsa: qca8k: pass switch_revision info to phy dev_flags
Date:   Tue, 11 May 2021 04:04:58 +0200
Message-Id: <20210511020500.17269-24-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
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
index 920cdb1ff2b9..9da7eccfa558 100644
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

