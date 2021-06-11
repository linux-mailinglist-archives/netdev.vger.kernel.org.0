Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1873A49D0
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhFKUHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbhFKUHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:07:55 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2017C0613A2
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:05:56 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ho18so6234424ejc.8
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hYLxhuwHVg89Dl/lCk/ypB8Gf9ORlIGXC8Igf4TEJuo=;
        b=uj2ns78lP9PM5eOEarBfs0nLqIBqapJ9u+ITOjY5yDGMfB68oDYGduL3ZjEiOai6q3
         ieD5L03FqpCCvrkqcJUuEvlMUdWbSdacCFt8oszPbLIvCkCVsD6pedceB2r36zC1GpWd
         G+omc13Mbvh+pRqGokXT1nub1cQtWOnNvqr57DJRKlO5eMs7h8M2qu3R0Lj1Eocy+o4m
         Cs5wy8p16HNdhaPTRkRzxm5aRpEL0iY+DDOXQkDDDiAkQIg0KYrAniCAsRspx/iQ8+QK
         tn8LhK42B2CNWT97FeQTGnI8ncPq2k7rKoRZBm+sVvPIlZkHX2ndRoDyjzEWkcLfslCF
         IX9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hYLxhuwHVg89Dl/lCk/ypB8Gf9ORlIGXC8Igf4TEJuo=;
        b=LJ663xXAkRvk/aBA+DdRM2ELRl2oPxgvEjBnlg77xAm4xx00ucLBym9cWKt2B7gRQG
         sybzTBHWW5cw7mhAoowPwwUVRN8Fy7JUqp3jW3ukNoJM93Lja2ZeweGeEreklzJqvysO
         6YOONNTJDMQ4ItD1e4ANvecYLnvfYS+DLjKX95osMFjc32f7OD/zp0nXrlaK0DsMHRrM
         Z4DOf5X+SS1NqUOoD/C7MBTdtq5D3ACM9bVTX2KF/Qd1GrnaWLhKPmyXbrjiuAVBk5Ki
         PvcJrwYIiGNsAL4E/EO1z+MH3g8zdiOiY71KuDoG/1/1sal6QWT7FqvE016B5Zfd7Kcn
         5nTQ==
X-Gm-Message-State: AOAM531tn8dmD/aox9eOXJvOVTyQMx3SSGjZfVKNK3Dhjt/kWkBZ9V3X
        mCYZ0nUKnXMbsETMznMiNo4=
X-Google-Smtp-Source: ABdhPJwoPXlVRrU44Dx3Wfyg7Y5dBhlDaehsaVMJPlrsyPJ20Zt4U5vH54p9acY15RLnrafahtXwpw==
X-Received: by 2002:a17:907:92e:: with SMTP id au14mr5043497ejc.194.1623441955250;
        Fri, 11 Jun 2021 13:05:55 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id w2sm2392084ejn.118.2021.06.11.13.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 13:05:54 -0700 (PDT)
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
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 06/13] net: pcs: xpcs: also ignore phy id if it's all ones
Date:   Fri, 11 Jun 2021 23:05:24 +0300
Message-Id: <20210611200531.2384819-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611200531.2384819-1-olteanv@gmail.com>
References: <20210611200531.2384819-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

xpcs_get_id() searches multiple MMDs for a known PHY ID, starting with
MDIO_MMD_PCS (3). However not all integrators might have implemented
that MMD on their MDIO bus. For example, the NXP SJA1105 and SJA1110
switches only implement vendor-specific MMD 1 and 2.

When there is nothing on an MDIO bus at a certain address, traditionally
the bus returns 0xffff, which means that the bus remained in its default
pull-up state for the duration of the MDIO transaction. The 0xffff value
is widely used in drivers/net/phy/phy_device.c (see get_phy_c22_id for
example) to denote a missing device.

So it makes sense for the xpcs to ignore this value as well, and
continue its search, eventually finding the proper PHY ID in the
vendor-specific MMDs.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: none

 drivers/net/pcs/pcs-xpcs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 743b53734eeb..ecf5011977d3 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -965,8 +965,10 @@ static u32 xpcs_get_id(struct dw_xpcs *xpcs)
 	if (ret < 0)
 		return 0xffffffff;
 
-	/* If Device IDs are not all zeros, we found C73 AN-type device */
-	if (id | ret)
+	/* If Device IDs are not all zeros or all ones,
+	 * we found C73 AN-type device
+	 */
+	if ((id | ret) && (id | ret) != 0xffffffff)
 		return id | ret;
 
 	/* Next, search C37 PCS using Vendor-Specific MII MMD */
-- 
2.25.1

