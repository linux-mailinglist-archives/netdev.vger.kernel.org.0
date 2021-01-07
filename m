Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46EC2ED3A5
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 16:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbhAGPim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 10:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbhAGPil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 10:38:41 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157EBC0612FB
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 07:37:47 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id 6so10280298ejz.5
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 07:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZY/T6YdPW1/bQWWcd/QhJNN8iMR6alYEWPKJqFBra74=;
        b=SmdBpjh67Jf1QkYiCGQJenk/9mZ50F6CGn6X9IWvM5fuDbAUqttwkNShdQwsGSxnVe
         /aTybtX+omNiCY4N4lg8mQ/iSni84PuqpcahnXZEQzDyZtyxr2e8ig8Ukp6jgGxYR2DG
         E77EvuKIEChfhHOVo7KRnfJhNisID9X7r5O/CMHv6ybILcipSF9vLNYtCJS4jd+C6LU7
         55LN/40LGm+Dadv6ZdDHfP06iQZDByNOS4Hl7fkJEwH6T4VeW78lvmK77k/aKJC1nuUC
         j+rKBCY3pJdb4tZMxFJCiuDtSiO4B84Kr3Hl0f5O2ZLlApkmcuZrzON2yOSwGVLWea+R
         6kmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZY/T6YdPW1/bQWWcd/QhJNN8iMR6alYEWPKJqFBra74=;
        b=WFnn9GnPJEiXPXX4NTQ4t6uyI5V3/cnMb24o0HBRyIPWVZTYnGsXYJ0eSGH7xYUM3A
         UelfYayIUUpsGFiepzjPWMGPOGBCGxGoMqnVnJD4gz/W4dAwkdnIHGSudtL7btw1DTFn
         +1yvN4IjlXxENbs8OMCCNvkiowhlyOVAf4KuN10eV6o/HX1wYLtV1MJZV6o6Yp0ZMVMg
         Ga2AJtKMNbE7HoKQ7/M0V6cddhq5wopoRyWDbmRotGyo97g0Wr5QoLvo1koneEmfbzPB
         JiLrbytVZ8w/k/f1yZq99EB0MX2xk+Un4yTi5BK4CFMV1VZUCFHb2cFeyjLXjX5O6p5o
         nKKw==
X-Gm-Message-State: AOAM532hwI+++I34RCOw4+OZBT+PJIfGVssG9saxkP60Ab+ANOtBEv18
        NifKQ2fo+KAAZIAVOlXkrM4dj5xtxvERnw==
X-Google-Smtp-Source: ABdhPJwDdnfAR9hUEcUOu5Cfi9wj7cmhoKP5Z7l9nrMaY9GqIZy1fn6xk7GQrjzzcqk2x1uGv+Rtew==
X-Received: by 2002:a17:906:653:: with SMTP id t19mr2491567ejb.44.1610033865796;
        Thu, 07 Jan 2021 07:37:45 -0800 (PST)
Received: from yoga-910.localhost (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z9sm2574898eju.123.2021.01.07.07.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 07:37:45 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 5/6] dpaa2-mac: remove an unnecessary check
Date:   Thu,  7 Jan 2021 17:36:37 +0200
Message-Id: <20210107153638.753942-6-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107153638.753942-1-ciorneiioana@gmail.com>
References: <20210107153638.753942-1-ciorneiioana@gmail.com>
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
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 43 ++++++++-----------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 666bc88c178f..40aa81eb3c4b 100644
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

