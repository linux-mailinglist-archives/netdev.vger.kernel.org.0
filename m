Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE613A32CE
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhFJSQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFJSQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:16:34 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA10C0617A6
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:14:37 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id i13so34149139edb.9
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KCR8dHVfkxsy8Qv/PLlN91+8tb1cZfMC3aCXsrl922Q=;
        b=CO4HcQ0wNR3Ty0SA0pmMA2WHBcqkwI09GQskUsK+a4JqPHX1iO3AFMStcOj3ZJE22B
         Ekn6DE8LhhXCvakWkzCPuQY7vneAl5benJe0cDTe36hkzBiBHapL+97ArsFGB94m03nF
         Vz3Y73aFlXrBqy/LRur9XvBPg6Zz/tv1JbEZHw5m/DFztl5IP4Kub538JCTNM7ljBts7
         NJwmcykoxDjK3oZjJTNRScz1DFKXAQ+H5ruzH0mJUxsogLlTyQ29DWcK1XklMvPqYvWz
         n78GIDfhafN3MZVveDzfaRT8sGM2bOhjzJvMXQYKeoIZCsApskq8+GeQMwcHxvL3VVm2
         /mwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KCR8dHVfkxsy8Qv/PLlN91+8tb1cZfMC3aCXsrl922Q=;
        b=JGOVeJmMUD+34JZpGYB20UfbgzU5LnG0LR84/aSsbz5TAnvKRHZd8vlOQint8vLpEj
         6VH1HGIEHLvWYuk8/au5Cog/AiZTTLCQmo7DsnL3jqMeI2HIrz+V5e6etgPApeM1N+eD
         2AbzkQrEGpqIB+ns0NovPY8VU/eIilVGNC5fS6ajQKhWSNCY6UWY/EsAk1zeMVch5P2K
         bLOW9o9M/aJfeyU24tt8JVoQ7J/i9YMkiWdEAG5yeqCw9JcGTN7SNndi4oJMyNl0ZVU+
         mxT7o0Yu4PsPnePo8lvH3jzHfdcnzhqG8cUfRxqo+8eYJk1C2Rn2dQGDkBFmS2K3Sq0A
         Ahpg==
X-Gm-Message-State: AOAM533IdZ5XbkRaP5EIG1bKH2W1nVw/QJm+cfxUJW3vbu9g1mSpjOTB
        dzBruV7WNbEYkBBkMC+Sb6g=
X-Google-Smtp-Source: ABdhPJy6GZl7TyIS1sRalkqXci5wJ7BCYGDPUqMrXQFbKwxOEZZhOqWfBTsXWk2x5RDn5rdctzQblg==
X-Received: by 2002:a05:6402:26c2:: with SMTP id x2mr815279edd.124.1623348876210;
        Thu, 10 Jun 2021 11:14:36 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id dh18sm1705660edb.92.2021.06.10.11.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 11:14:35 -0700 (PDT)
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
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 06/13] net: pcs: xpcs: also ignore phy id if it's all ones
Date:   Thu, 10 Jun 2021 21:14:03 +0300
Message-Id: <20210610181410.1886658-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610181410.1886658-1-olteanv@gmail.com>
References: <20210610181410.1886658-1-olteanv@gmail.com>
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

