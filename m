Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDFF398FD7
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhFBQXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 12:23:32 -0400
Received: from mail-ej1-f50.google.com ([209.85.218.50]:37758 "EHLO
        mail-ej1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhFBQXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 12:23:31 -0400
Received: by mail-ej1-f50.google.com with SMTP id ce15so4722875ejb.4
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 09:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6/ymcweiCG9wNftH8hsgp74pwu5eqC/48ceLEiARYPM=;
        b=tzdXGrsC6odo0fnJCxXY6HVlddqLHTitRdJqqh3yP6HxyiHEbdqrZGrWSWqo1nTIJr
         q7iR9cdPRBVPAMymJsmg6T77VmMQ4ONJ8qiUakGOOirghh0BFVD5+4hdy7iTESwotNWZ
         HdNbthCD9486m/59r/aim9CvHA2fKTFDlsf+P4HNci+zc+0qLwtAugI8xK+So5ZJvkvI
         5+twkW0ZxJLUUBfHiOM4t35LC/oOB5v0TJa09zlQ5SFlHJeNRjfpyqAQhwpqLnYcCQUb
         BaNcQsMrvoZKr0Leb9kAr7CqWd+C9BImoVO3FBldNUsk15gqVRN5jzHpCP+66qcxVTu6
         mp+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6/ymcweiCG9wNftH8hsgp74pwu5eqC/48ceLEiARYPM=;
        b=bqOsHiOCyILR+XPdlZOO0ad3o8ib47MxRIcm8wHjd/C8y7oQhX3cGEcCMVxHXGtSCT
         3EFzSzm8SXDX6xduHQAeSAm/+5aosCVRb+vjEV8FlRueHzFZag+sX4YVj7j6qBe4CbuW
         sgsZ5o/qzRCwXTYTw8+NyPHcNh+HtK8kKjCK42+3iooxjn/ARZuGe6v3XT8cqI3OB5QB
         nsZEcqmd/LQ5jNb0bi5fdAhEg8uG2by8mnFeXbxrnkJVNl9+QnPS8yAV09YFt0qOlFT4
         EYFnnsxK5SXPm18fjunwObzBDzdSvefc9LPGgY45rzUaxdP+DJNuZhSKMI8mo4KjCSyC
         I4sQ==
X-Gm-Message-State: AOAM5305JMjTV4wPwsj+TZBgrHQyVZ65gZN4MB2hYmwI4RqieEgTg/ls
        YEddRWFEBdhRfaiO7rYwwBMTsJw5oys=
X-Google-Smtp-Source: ABdhPJwwf970YPDqXsb/s5DWSwR3Tgw5zq9R9OuMungtZVLSqJXQ++3qIxvYpHnfKCp66LqGhnjhgA==
X-Received: by 2002:a17:906:b794:: with SMTP id dt20mr34729729ejb.521.1622650834311;
        Wed, 02 Jun 2021 09:20:34 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id m12sm228078edc.40.2021.06.02.09.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 09:20:34 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 2/9] net: pcs: xpcs: there is only one PHY ID
Date:   Wed,  2 Jun 2021 19:20:12 +0300
Message-Id: <20210602162019.2201925-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210602162019.2201925-1-olteanv@gmail.com>
References: <20210602162019.2201925-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The xpcs driver has an apparently inadequate structure for the actual
hardware it drives.

These defines and the xpcs_probe() function would suggest that there is
one PHY ID per supported PHY interface type, and the driver simply
validates whether the mode it should operate in (the argument of
xpcs_probe) matches what the hardware is capable of:

	#define SYNOPSYS_XPCS_USXGMII_ID	0x7996ced0
	#define SYNOPSYS_XPCS_10GKR_ID		0x7996ced0
	#define SYNOPSYS_XPCS_XLGMII_ID		0x7996ced0
	#define SYNOPSYS_XPCS_SGMII_ID		0x7996ced0
	#define SYNOPSYS_XPCS_MASK		0xffffffff

but that is not the case, because upon closer inspection, all the above
4 PHY ID definitions are in fact equal.

So it is the same XPCS that is compatible with all 4 sets of PHY
interface types.

This change introduces an array of struct xpcs_compat which is populated
by the single struct xpcs_id instance. It also eliminates the bogus
defines for multiple Synopsys XPCS PHY IDs and replaces them with a
single XPCS_ID, which better reflects the way in which the hardware
operates.

Because we are touching this area of the code anyway, the new array of
struct xpcs_compat, as well as the array of xpcs_id, have been moved
towards the end of the file, since they are variable declarations not
definitions. If whichever of struct xpcs_compat or struct xpcs_id need
to gain a function pointer member in the future, it is easier to
reference functions (no forward declarations needed) if we have the
const variable declarations at the end of the file.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new
v2->v3: move the xpcs_compat and xpcs_id declarations at the end, as
        well as note this in the commit message (needed for sja1105
        support)

 drivers/net/pcs/pcs-xpcs.c | 129 ++++++++++++++++++++++---------------
 1 file changed, 78 insertions(+), 51 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index aa985a5aae8d..9f2da9e873c4 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -12,10 +12,7 @@
 #include <linux/phylink.h>
 #include <linux/workqueue.h>
 
-#define SYNOPSYS_XPCS_USXGMII_ID	0x7996ced0
-#define SYNOPSYS_XPCS_10GKR_ID		0x7996ced0
-#define SYNOPSYS_XPCS_XLGMII_ID		0x7996ced0
-#define SYNOPSYS_XPCS_SGMII_ID		0x7996ced0
+#define SYNOPSYS_XPCS_ID		0x7996ced0
 #define SYNOPSYS_XPCS_MASK		0xffffffff
 
 /* Vendor regs access */
@@ -163,56 +160,39 @@ static const int xpcs_sgmii_features[] = {
 
 static const phy_interface_t xpcs_usxgmii_interfaces[] = {
 	PHY_INTERFACE_MODE_USXGMII,
-	PHY_INTERFACE_MODE_MAX,
 };
 
 static const phy_interface_t xpcs_10gkr_interfaces[] = {
 	PHY_INTERFACE_MODE_10GKR,
-	PHY_INTERFACE_MODE_MAX,
 };
 
 static const phy_interface_t xpcs_xlgmii_interfaces[] = {
 	PHY_INTERFACE_MODE_XLGMII,
-	PHY_INTERFACE_MODE_MAX,
 };
 
 static const phy_interface_t xpcs_sgmii_interfaces[] = {
 	PHY_INTERFACE_MODE_SGMII,
-	PHY_INTERFACE_MODE_MAX,
 };
 
-static struct xpcs_id {
-	u32 id;
-	u32 mask;
+enum {
+	DW_XPCS_USXGMII,
+	DW_XPCS_10GKR,
+	DW_XPCS_XLGMII,
+	DW_XPCS_SGMII,
+	DW_XPCS_INTERFACE_MAX,
+};
+
+struct xpcs_compat {
 	const int *supported;
 	const phy_interface_t *interface;
+	int num_interfaces;
 	int an_mode;
-} xpcs_id_list[] = {
-	{
-		.id = SYNOPSYS_XPCS_USXGMII_ID,
-		.mask = SYNOPSYS_XPCS_MASK,
-		.supported = xpcs_usxgmii_features,
-		.interface = xpcs_usxgmii_interfaces,
-		.an_mode = DW_AN_C73,
-	}, {
-		.id = SYNOPSYS_XPCS_10GKR_ID,
-		.mask = SYNOPSYS_XPCS_MASK,
-		.supported = xpcs_10gkr_features,
-		.interface = xpcs_10gkr_interfaces,
-		.an_mode = DW_AN_C73,
-	}, {
-		.id = SYNOPSYS_XPCS_XLGMII_ID,
-		.mask = SYNOPSYS_XPCS_MASK,
-		.supported = xpcs_xlgmii_features,
-		.interface = xpcs_xlgmii_interfaces,
-		.an_mode = DW_AN_C73,
-	}, {
-		.id = SYNOPSYS_XPCS_SGMII_ID,
-		.mask = SYNOPSYS_XPCS_MASK,
-		.supported = xpcs_sgmii_features,
-		.interface = xpcs_sgmii_interfaces,
-		.an_mode = DW_AN_C37_SGMII,
-	},
+};
+
+struct xpcs_id {
+	u32 id;
+	u32 mask;
+	const struct xpcs_compat *compat;
 };
 
 static int xpcs_read(struct mdio_xpcs_args *xpcs, int dev, u32 reg)
@@ -911,35 +891,82 @@ static u32 xpcs_get_id(struct mdio_xpcs_args *xpcs)
 }
 
 static bool xpcs_check_features(struct mdio_xpcs_args *xpcs,
-				struct xpcs_id *match,
+				const struct xpcs_id *match,
 				phy_interface_t interface)
 {
-	int i;
+	int i, j;
 
-	for (i = 0; match->interface[i] != PHY_INTERFACE_MODE_MAX; i++) {
-		if (match->interface[i] == interface)
-			break;
-	}
+	for (i = 0; i < DW_XPCS_INTERFACE_MAX; i++) {
+		const struct xpcs_compat *compat = &match->compat[i];
+		bool supports_interface = false;
 
-	if (match->interface[i] == PHY_INTERFACE_MODE_MAX)
-		return false;
+		for (j = 0; j < compat->num_interfaces; j++) {
+			if (compat->interface[j] == interface) {
+				supports_interface = true;
+				break;
+			}
+		}
+
+		if (!supports_interface)
+			continue;
 
-	for (i = 0; match->supported[i] != __ETHTOOL_LINK_MODE_MASK_NBITS; i++)
-		set_bit(match->supported[i], xpcs->supported);
+		/* Populate the supported link modes for this
+		 * PHY interface type
+		 */
+		for (j = 0; compat->supported[j] != __ETHTOOL_LINK_MODE_MASK_NBITS; j++)
+			set_bit(compat->supported[j], xpcs->supported);
 
-	xpcs->an_mode = match->an_mode;
+		xpcs->an_mode = compat->an_mode;
 
-	return true;
+		return true;
+	}
+
+	return false;
 }
 
+static const struct xpcs_compat synopsys_xpcs_compat[DW_XPCS_INTERFACE_MAX] = {
+	[DW_XPCS_USXGMII] = {
+		.supported = xpcs_usxgmii_features,
+		.interface = xpcs_usxgmii_interfaces,
+		.num_interfaces = ARRAY_SIZE(xpcs_usxgmii_interfaces),
+		.an_mode = DW_AN_C73,
+	},
+	[DW_XPCS_10GKR] = {
+		.supported = xpcs_10gkr_features,
+		.interface = xpcs_10gkr_interfaces,
+		.num_interfaces = ARRAY_SIZE(xpcs_10gkr_interfaces),
+		.an_mode = DW_AN_C73,
+	},
+	[DW_XPCS_XLGMII] = {
+		.supported = xpcs_xlgmii_features,
+		.interface = xpcs_xlgmii_interfaces,
+		.num_interfaces = ARRAY_SIZE(xpcs_xlgmii_interfaces),
+		.an_mode = DW_AN_C73,
+	},
+	[DW_XPCS_SGMII] = {
+		.supported = xpcs_sgmii_features,
+		.interface = xpcs_sgmii_interfaces,
+		.num_interfaces = ARRAY_SIZE(xpcs_sgmii_interfaces),
+		.an_mode = DW_AN_C37_SGMII,
+	},
+};
+
+static const struct xpcs_id xpcs_id_list[] = {
+	{
+		.id = SYNOPSYS_XPCS_ID,
+		.mask = SYNOPSYS_XPCS_MASK,
+		.compat = synopsys_xpcs_compat,
+	},
+};
+
 static int xpcs_probe(struct mdio_xpcs_args *xpcs, phy_interface_t interface)
 {
+	const struct xpcs_id *match = NULL;
 	u32 xpcs_id = xpcs_get_id(xpcs);
-	struct xpcs_id *match = NULL;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(xpcs_id_list); i++) {
-		struct xpcs_id *entry = &xpcs_id_list[i];
+		const struct xpcs_id *entry = &xpcs_id_list[i];
 
 		if ((xpcs_id & entry->mask) == entry->id) {
 			match = entry;
-- 
2.25.1

