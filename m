Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CC52EEF24
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbhAHJI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbhAHJI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 04:08:57 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3977C0612FA
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 01:07:41 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ga15so13610807ejb.4
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 01:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hR6oOKRaEb4xU9lNIaadoNIwqR0Ic8ORY/DFIm1kfxI=;
        b=dBSDn9DcrhL4zzx1oPMe8HqJHNEBiVoHHA+DDM1D5rukRiH00zLOYLgjHwAFUtmcxB
         iFPc/ksHQYOaTOi+Q9OJvYNepfqkRFCdDSydkFKIRGbFd32M11e7zfjgyroVVIDkphfL
         QCY6psec3j3BDr/E4N+ZYHjZfc3F1AWKs8Bhb9gtV6+8QWLHJUCjzRALGkaU9av37CEg
         Qn9VlMRTLiPHM6Gnys6rAuNCthiSxFOQ/rrx20f5ZfXX2mV5UwRC+xiiTHvGBiQtKozY
         SGvC/N2g2o7fGzlaYJ2jf3Exd9HnEDLl1sVf1KeXY/bWdyA3nfAPbpk38U4WLciV37QU
         R/NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hR6oOKRaEb4xU9lNIaadoNIwqR0Ic8ORY/DFIm1kfxI=;
        b=jv67ph0wW3P/M756UxP7Xcz3GAzVAzSOuR1L29H37TfKSaf6ntTyNwJjcsjkvQ95CI
         OCn5nnPeEGru99g0stO5OW/sx6x65ZyWoGVGWIk3/dm710GJxfUFks8LINIGGdwMd6kN
         mrFQdTZvd/FNo0DmSMwwVkAeQfINXJijG07eugKYp5BlN7F1c4lfZt4xdjw4wHwBJ3SY
         t7bTU0MDvvIzr8d42YVeT8a8lklDIV5CUhOO/1P0jQjpAG92NLcRf/WDT8UlXSgbRXGe
         0c9nO7mLnerI5U/nj8e+TcPENjWXyU90BzjG+wmJvEUzc36SAys9rn1mF8mtFx2qwNy5
         b7RA==
X-Gm-Message-State: AOAM532BGiAn1NZereU0qRHgaqypAngepiH3MNn9gwvqtaklptMC9RXD
        7tT+2HsXaEn5PSJud5DV/nU=
X-Google-Smtp-Source: ABdhPJyIBC7obYhylvbAd56r42e9SZzLFLW2/McZelmFBbTmsQs07L56vpZpsvNMC7urSrvlfQx2tQ==
X-Received: by 2002:a17:907:961d:: with SMTP id gb29mr2072781ejc.460.1610096860674;
        Fri, 08 Jan 2021 01:07:40 -0800 (PST)
Received: from yoga-910.localhost (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k16sm3307132ejd.78.2021.01.08.01.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 01:07:40 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 5/6] dpaa2-mac: remove an unnecessary check
Date:   Fri,  8 Jan 2021 11:07:26 +0200
Message-Id: <20210108090727.866283-6-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210108090727.866283-1-ciorneiioana@gmail.com>
References: <20210108090727.866283-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The dpaa2-eth driver has phylink integration only if the connected dpmac
object is in TYPE_PHY (aka the PCS/PHY etc link status is managed by
Linux instead of the firmware). The check is thus unnecessary because
the code path that reaches the .mac_link_up() callback is only with
TYPE_PHY dpmac objects.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 43 ++++++++-----------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 81b2822a7dc9..3869c38f3979 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -174,30 +174,25 @@ static void dpaa2_mac_link_up(struct phylink_config *config,
 
 	dpmac_state->up = 1;
 
-	if (mac->if_link_type == DPMAC_LINK_TYPE_PHY) {
-		/* If the DPMAC is configured for PHY mode, we need
-		 * to pass the link parameters to the MC firmware.
-		 */
-		dpmac_state->rate = speed;
-
-		if (duplex == DUPLEX_HALF)
-			dpmac_state->options |= DPMAC_LINK_OPT_HALF_DUPLEX;
-		else if (duplex == DUPLEX_FULL)
-			dpmac_state->options &= ~DPMAC_LINK_OPT_HALF_DUPLEX;
-
-		/* This is lossy; the firmware really should take the pause
-		 * enablement status rather than pause/asym pause status.
-		 */
-		if (rx_pause)
-			dpmac_state->options |= DPMAC_LINK_OPT_PAUSE;
-		else
-			dpmac_state->options &= ~DPMAC_LINK_OPT_PAUSE;
-
-		if (rx_pause ^ tx_pause)
-			dpmac_state->options |= DPMAC_LINK_OPT_ASYM_PAUSE;
-		else
-			dpmac_state->options &= ~DPMAC_LINK_OPT_ASYM_PAUSE;
-	}
+	dpmac_state->rate = speed;
+
+	if (duplex == DUPLEX_HALF)
+		dpmac_state->options |= DPMAC_LINK_OPT_HALF_DUPLEX;
+	else if (duplex == DUPLEX_FULL)
+		dpmac_state->options &= ~DPMAC_LINK_OPT_HALF_DUPLEX;
+
+	/* This is lossy; the firmware really should take the pause
+	 * enablement status rather than pause/asym pause status.
+	 */
+	if (rx_pause)
+		dpmac_state->options |= DPMAC_LINK_OPT_PAUSE;
+	else
+		dpmac_state->options &= ~DPMAC_LINK_OPT_PAUSE;
+
+	if (rx_pause ^ tx_pause)
+		dpmac_state->options |= DPMAC_LINK_OPT_ASYM_PAUSE;
+	else
+		dpmac_state->options &= ~DPMAC_LINK_OPT_ASYM_PAUSE;
 
 	err = dpmac_set_link_state(mac->mc_io, 0,
 				   mac->mc_dev->mc_handle, dpmac_state);
-- 
2.29.2

