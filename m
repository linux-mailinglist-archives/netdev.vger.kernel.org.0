Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0D52FC480
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbhASXKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728500AbhASXJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 18:09:16 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3473BC0613D6
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:08 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id g1so22897581edu.4
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FyMTgb9nXcUn+Nig+R0DDfuzanqX3vWBV8/pW6EP1RU=;
        b=IJdNZFEeUhDJl21QjRW0H2CTv8si0NnHK12wvlcWUZZERsq+HE8i9XdVvMC+IMv+E2
         d8V2uJD3CrcI+0fNKc/zxtAXwwvLe25dqr0ClAK0YjfPdNr05wPMsDWhECjjfiYYFDzL
         PqSWG32w6EM+jf/vTOSv6BnOkWDA/OsLkbpyD92MrBt9CqvUn6UShurEGWbfKhEq3Jot
         RNapcNJRJgKHtOJSyvbxgKLGDsnVxRLcNbzZVFD6FTmWZHor50aTkkpPhsBSadz5oaVj
         /psyLHYRLWhlvcRMIeZhcjkWWwVKHU2NDMuI9K+aVBJFt2wCusiFnQWmztTlThf3tdax
         5O+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FyMTgb9nXcUn+Nig+R0DDfuzanqX3vWBV8/pW6EP1RU=;
        b=SPe2uR2PViCCACI8/ybinYhN/yyJXQqoaAwMlNZmnT2Wgzj6wvg8NotLtRCmIQWqrU
         3bWFxnokpeGV8euIjhH9HxNalCVIOeptsjZMb6t3Gz7Bjvz8ukLq5NMCaZaC1fHaLaZA
         ZOj9s5vQFTsvEqTot66ZrfYLh0saqyYcW9WpkPNX9oyctaMvr4wgkuEXTjTLPxbCImmv
         V1PegKoKhykttmMcW+1WvAQF1auAINA+tXFWN3r8PkF7XyZRurF1aDgHbufWBiapgco8
         7ccX04AJLXTOlV8GWVN46t9YNcOQ2t8IgTGY4glf+SM+yNjG+n/ZwoHcJNag0HhQDuqh
         BQ3g==
X-Gm-Message-State: AOAM531wSL2fh2J7su03eQuNFklBr6j438QpbQL2B6e+wdsQlyZg7P35
        Gyaris5z4WYc23m0fLTwK3w=
X-Google-Smtp-Source: ABdhPJx65tCya4gFQH4/StpgmHTKMm0rna2WcTqxz2V0z5tpFlOvHMFYpIghHbK9/Cf5+TqXttlzYw==
X-Received: by 2002:a50:acc1:: with SMTP id x59mr5150463edc.43.1611097686930;
        Tue, 19 Jan 2021 15:08:06 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id lh26sm94197ejb.119.2021.01.19.15.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:08:06 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 05/16] net: mscc: ocelot: don't use NPI tag prefix for the CPU port module
Date:   Wed, 20 Jan 2021 01:07:38 +0200
Message-Id: <20210119230749.1178874-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119230749.1178874-1-olteanv@gmail.com>
References: <20210119230749.1178874-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Context: Ocelot switches put the injection/extraction frame header in
front of the Ethernet header. When used in NPI mode, a DSA master would
see junk instead of the destination MAC address, and it would most
likely drop the packets. So the Ocelot frame header can have an optional
prefix, which is just "ff:ff:ff:ff:ff:fe > ff:ff:ff:ff:ff:ff" padding
put before the actual tag (still before the real Ethernet header) such
that the DSA master thinks it's looking at a broadcast frame with a
strange EtherType.

Unfortunately, a lesson learned in commit 69df578c5f4b ("net: mscc:
ocelot: eliminate confusion between CPU and NPI port") seems to have
been forgotten in the meanwhile.

The CPU port module and the NPI port have independent settings for the
length of the tag prefix. However, the driver is using the same variable
to program both of them.

There is no reason really to use any tag prefix with the CPU port
module, since that is not connected to any Ethernet port. So this patch
makes the inj_prefix and xtr_prefix variables apply only to the NPI
port (which the switchdev ocelot_vsc7514 driver does not use).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
Patch is new.

 drivers/net/dsa/ocelot/felix.c             |  8 ++++----
 drivers/net/ethernet/mscc/ocelot.c         | 12 ++++++------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  2 --
 include/soc/mscc/ocelot.h                  |  4 ++--
 4 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 767cbdccdb3e..054e57dd4383 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -425,8 +425,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->num_mact_rows	= felix->info->num_mact_rows;
 	ocelot->vcap		= felix->info->vcap;
 	ocelot->ops		= felix->info->ops;
-	ocelot->inj_prefix	= OCELOT_TAG_PREFIX_SHORT;
-	ocelot->xtr_prefix	= OCELOT_TAG_PREFIX_SHORT;
+	ocelot->npi_inj_prefix	= OCELOT_TAG_PREFIX_SHORT;
+	ocelot->npi_xtr_prefix	= OCELOT_TAG_PREFIX_SHORT;
 	ocelot->devlink		= felix->ds->devlink;
 
 	port_phy_modes = kcalloc(num_phys_ports, sizeof(phy_interface_t),
@@ -541,9 +541,9 @@ static void felix_npi_port_init(struct ocelot *ocelot, int port)
 
 	/* NPI port Injection/Extraction configuration */
 	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_XTR_HDR,
-			    ocelot->xtr_prefix);
+			    ocelot->npi_xtr_prefix);
 	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_INJ_HDR,
-			    ocelot->inj_prefix);
+			    ocelot->npi_inj_prefix);
 
 	/* Disable transmission of pause frames */
 	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 0);
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 42d92a5b475d..acf7ef00e56b 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1346,9 +1346,9 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 	if (port == ocelot->npi) {
 		maxlen += OCELOT_TAG_LEN;
 
-		if (ocelot->inj_prefix == OCELOT_TAG_PREFIX_SHORT)
+		if (ocelot->npi_inj_prefix == OCELOT_TAG_PREFIX_SHORT)
 			maxlen += OCELOT_SHORT_PREFIX_LEN;
-		else if (ocelot->inj_prefix == OCELOT_TAG_PREFIX_LONG)
+		else if (ocelot->npi_inj_prefix == OCELOT_TAG_PREFIX_LONG)
 			maxlen += OCELOT_LONG_PREFIX_LEN;
 	}
 
@@ -1378,9 +1378,9 @@ int ocelot_get_max_mtu(struct ocelot *ocelot, int port)
 	if (port == ocelot->npi) {
 		max_mtu -= OCELOT_TAG_LEN;
 
-		if (ocelot->inj_prefix == OCELOT_TAG_PREFIX_SHORT)
+		if (ocelot->npi_inj_prefix == OCELOT_TAG_PREFIX_SHORT)
 			max_mtu -= OCELOT_SHORT_PREFIX_LEN;
-		else if (ocelot->inj_prefix == OCELOT_TAG_PREFIX_LONG)
+		else if (ocelot->npi_inj_prefix == OCELOT_TAG_PREFIX_LONG)
 			max_mtu -= OCELOT_LONG_PREFIX_LEN;
 	}
 
@@ -1465,9 +1465,9 @@ static void ocelot_cpu_port_init(struct ocelot *ocelot)
 	ocelot_fields_write(ocelot, cpu, QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
 	/* CPU port Injection/Extraction configuration */
 	ocelot_fields_write(ocelot, cpu, SYS_PORT_MODE_INCL_XTR_HDR,
-			    ocelot->xtr_prefix);
+			    OCELOT_TAG_PREFIX_NONE);
 	ocelot_fields_write(ocelot, cpu, SYS_PORT_MODE_INCL_INJ_HDR,
-			    ocelot->inj_prefix);
+			    OCELOT_TAG_PREFIX_NONE);
 
 	/* Configure the CPU port to be VLAN aware */
 	ocelot_write_gix(ocelot, ANA_PORT_VLAN_CFG_VLAN_VID(0) |
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 30a38df08a21..407244fe5b17 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1347,8 +1347,6 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	ocelot->num_flooding_pgids = 1;
 
 	ocelot->vcap = vsc7514_vcap_props;
-	ocelot->inj_prefix = OCELOT_TAG_PREFIX_NONE;
-	ocelot->xtr_prefix = OCELOT_TAG_PREFIX_NONE;
 	ocelot->npi = -1;
 
 	err = ocelot_init(ocelot);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index cdc33fa05660..93c22627dedd 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -651,8 +651,8 @@ struct ocelot {
 
 	int				npi;
 
-	enum ocelot_tag_prefix		inj_prefix;
-	enum ocelot_tag_prefix		xtr_prefix;
+	enum ocelot_tag_prefix		npi_inj_prefix;
+	enum ocelot_tag_prefix		npi_xtr_prefix;
 
 	u32				*lags;
 
-- 
2.25.1

