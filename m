Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138EB2145EA
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 14:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgGDMpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 08:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgGDMp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 08:45:29 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DCDC061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 05:45:29 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id w6so37250906ejq.6
        for <netdev@vger.kernel.org>; Sat, 04 Jul 2020 05:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O+O8SWajzOmww2WQh1LfPXn4BW3djglpBsXVmmWeTPo=;
        b=TDFVSWxtbV/JZhOF3icIFzTzCO72goFZkuLwbXOYuZOtemrV3PbQkJ/N+EU9D1NuCo
         rQ2mjrQ3G9WI+Eq+8SOSmWsCkfnMn1Vw5cDziKg1i7vX93VdZTwFOPiKY3+QSORNnLZt
         liMLBhnvsMP/wpQymwiWO/KNAG6y4LVdVZghz3HrMRvkEZYk7vtjCnpb6hK2L6T8N/tx
         ERGlOs6dKENsltY+bB9rABK8ZoGWKanRMU7Pgim1XxwmPNfw7L8anDM970Gv2fg9/Llj
         GjNOEyHHTXTIEPZN2iHpRU9fVYitWW+I9Z+A6grFhZSYECBn9R7AGrFx+BZFeD3nBSVc
         7j9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O+O8SWajzOmww2WQh1LfPXn4BW3djglpBsXVmmWeTPo=;
        b=fdtSB7S/DLV8dPTbdayilaTPA9P+Nk47ZCee4oO764AFnWLiTa9OhqVJQmefYT51Rn
         O1rpz+2IZXrBf3RTIDQ3PujRjjw/4iXXmDv2QUVva1ii1p6m1uiXeN8pJ4NTsfNF2+/S
         sHJxwLbjUe16D+mWLQ2I5Gguab9EBAzcPJFBrueIt3seIkRYRgn4i+bCCxExctHjWHg2
         e0gJJl8P86mEbvc+Ql1k22gl0P675F1ObrhRzFDES4oXBW9n/6a3AqNXVI5HYaaTZkCY
         ltzHRpr3vSohROmmTruc9rzsLD1p4lx39FKShYP4/2U8zl4SVt00W1k9SONxwpL/aWh2
         1fCg==
X-Gm-Message-State: AOAM533bdaNaYesCMcqLfzKC9hFQJuVGy1MycDvpmVZPdXzR8XjUEYZ/
        xYmUZobyKKPJUdG/gQmeVNc=
X-Google-Smtp-Source: ABdhPJz2eSnAiPtv9VEv6/fjXTQ5ONmPpVu+l0qtbpyOA0twO+n4gMcoS4TTdcdw1MH9vMkb2+2/KQ==
X-Received: by 2002:a17:906:e215:: with SMTP id gf21mr30298660ejb.310.1593866727877;
        Sat, 04 Jul 2020 05:45:27 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id dm1sm12983851ejc.99.2020.07.04.05.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2020 05:45:27 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH v2 net-next 1/6] net: dsa: felix: clarify the intention of writes to MII_BMCR
Date:   Sat,  4 Jul 2020 15:45:02 +0300
Message-Id: <20200704124507.3336497-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200704124507.3336497-1-olteanv@gmail.com>
References: <20200704124507.3336497-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The driver appears to write to BMCR_SPEED and BMCR_DUPLEX, fields which
are read-only, since they are actually configured through the
vendor-specific IF_MODE (0x14) register.

But the reason we're writing back the read-only values of MII_BMCR is to
alter these writable fields:

BMCR_RESET
BMCR_LOOPBACK
BMCR_ANENABLE
BMCR_PDOWN
BMCR_ISOLATE
BMCR_ANRESTART

In particular, the only field which is really relevant to this driver is
BMCR_ANENABLE. Clarify that intention by spelling it out, using
phy_set_bits and phy_clear_bits.

The driver also made a few writes to BMCR_RESET and BMCR_ANRESTART which
are unnecessary and may temporarily disrupt the link to the PHY. Remove
them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix_vsc9959.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2067776773f7..9f4c8343652f 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -815,7 +815,7 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
 		phy_write(pcs, ENETC_PCS_LINK_TIMER2,
 			  ENETC_PCS_LINK_TIMER2_VAL);
 
-		phy_write(pcs, MII_BMCR, BMCR_ANRESTART | BMCR_ANENABLE);
+		phy_set_bits(pcs, MII_BMCR, BMCR_ANENABLE);
 	} else {
 		int speed;
 
@@ -845,10 +845,7 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
 			  ENETC_PCS_IF_MODE_SGMII_EN |
 			  ENETC_PCS_IF_MODE_SGMII_SPEED(speed));
 
-		/* Yes, not a mistake: speed is given by IF_MODE. */
-		phy_write(pcs, MII_BMCR, BMCR_RESET |
-					 BMCR_SPEED1000 |
-					 BMCR_FULLDPLX);
+		phy_clear_bits(pcs, MII_BMCR, BMCR_ANENABLE);
 	}
 }
 
@@ -882,9 +879,7 @@ static void vsc9959_pcs_init_2500basex(struct phy_device *pcs,
 		  ENETC_PCS_IF_MODE_SGMII_EN |
 		  ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_2500));
 
-	phy_write(pcs, MII_BMCR, BMCR_SPEED1000 |
-				 BMCR_FULLDPLX |
-				 BMCR_RESET);
+	phy_clear_bits(pcs, MII_BMCR, BMCR_ANENABLE);
 }
 
 static void vsc9959_pcs_init_usxgmii(struct phy_device *pcs,
-- 
2.25.1

