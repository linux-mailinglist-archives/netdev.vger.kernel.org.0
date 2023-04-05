Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E35FC6D7469
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 08:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236912AbjDEGdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 02:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237073AbjDEGdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 02:33:35 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93BB4693
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 23:33:32 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id o12so15440498iow.6
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 23:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680676412;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7TaIEn3IKeNSqnukSFhOIbi52j1qTH9Yw+ZNAcS+2YE=;
        b=jBUcLX2y9uDGiI8lmM9HmaOHTkPgVFAGxBPZO76rQbkxG/fZtA9jpx3Tr7VoYtdeCJ
         lS/W4qSTn/U1bgf9PXdfwwCoVJZWEFTT/LX1lVf203ygvAojUvmxH5KP/tVgvjH4y0MU
         qL8npnqQHW9xXGNr9WDhbb5v7KLo/8dCDYYCJQxJ5RagOQpU52FcHvXSHryNrDeMcyHH
         uxeSitWksf0lMHKTQmI76U+LVEmYIQxoFzhDIFgcxd5ncb+nl60WhOTx1HxSuDXuonho
         OehszL4yPZ2yLFFIUC9eNA8fZJ3DgfGeO8+3WIqjubZcSx0zPzjPUmlJlgs+3NHc8OLj
         CwrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680676412;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7TaIEn3IKeNSqnukSFhOIbi52j1qTH9Yw+ZNAcS+2YE=;
        b=7o2AXPl/d9hR7QUIQ6Pw3FO+kMv9TLZ3t5Ont6glc4jkqQLIN9t3yOTH1VuXXYh+Vo
         ATD1f+5vq+euIE2TlvGmg5kEbPHOzhjDqIVoYZ92d+xad0EM3U5dzeyYByIYcSHLSBW6
         2hdt6O9ALV/V1etVfiDzwGejktZ/bUBdMfY1z66j0kmM0PEQKD6wzL77foGx9GF6UaRR
         xHyktpkjTOUahEWr2GFmcRFnbKeBZc2dnfOIiKWm2UQ+oOIMTkA/y4poRpqiFj6+ACyw
         FhLVwOMc3D4zCacfZdjO9Q9pmfVHmpuIv+QlKvL0lPMO/vhv0GvCVE/eUWYjWm1xOWnL
         qWAQ==
X-Gm-Message-State: AAQBX9cfmdGv3I3Z+SgVBHDEdAM613YG5erALckN3Ve9yutEudSEm6H2
        zkkdw4xq/sM1jsrY/1YsLxA=
X-Google-Smtp-Source: AKy350YUhlZUwspJQ8BmQiBJICi8fMTrONGbbXhZxYtHrH11kBVRSgQlzgEzVw801Fgxgu4wTTXcdQ==
X-Received: by 2002:a6b:ce0d:0:b0:74c:c47e:e338 with SMTP id p13-20020a6bce0d000000b0074cc47ee338mr3806484iob.1.1680676412161;
        Tue, 04 Apr 2023 23:33:32 -0700 (PDT)
Received: from fedora.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id ce6-20020a0566381a8600b00374bf3b62a0sm3648562jab.99.2023.04.04.23.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 23:33:31 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: [RFC PATCH v3 4/5] Convert netdevsim driver to use ndo_hwtstamp_get/set for hw timestamp requests
Date:   Wed,  5 Apr 2023 00:33:30 -0600
Message-Id: <20230405063330.36287-1-glipus@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changing netdevsim driver to use the newly introduced ndo_hwtstamp_get/set
callback functions instead of implementing full-blown SIOCGHWTSTAMP/
SIOCSHWTSTAMP IOCTLs handling logic.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maxim Georgiev <glipus@gmail.com>
---
 drivers/net/netdevsim/netdev.c    | 24 ++++++++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 35fa1ca98671..6c29dfa3bb4e 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -238,6 +238,28 @@ nsim_set_features(struct net_device *dev, netdev_features_t features)
 	return 0;
 }
 
+static int
+nsim_hwtstamp_get(struct net_device *dev,
+		  struct kernel_hwtstamp_config *kernel_config,
+		  struct netlink_ext_ack *extack)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	*kernel_config = ns->hw_tstamp_config;
+	return 0;
+}
+
+static int
+nsim_hwtstamp_set(struct net_device *dev,
+		  struct kernel_hwtstamp_config *kernel_config,
+		  struct netlink_ext_ack *extack)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	ns->hw_tstamp_config = *kernel_config;
+	return 0;
+}
+
 static const struct net_device_ops nsim_netdev_ops = {
 	.ndo_start_xmit		= nsim_start_xmit,
 	.ndo_set_rx_mode	= nsim_set_rx_mode,
@@ -256,6 +278,8 @@ static const struct net_device_ops nsim_netdev_ops = {
 	.ndo_setup_tc		= nsim_setup_tc,
 	.ndo_set_features	= nsim_set_features,
 	.ndo_bpf		= nsim_bpf,
+	.ndo_hwtstamp_get	= nsim_hwtstamp_get,
+	.ndo_hwtstamp_set	= nsim_hwtstamp_set,
 };
 
 static const struct net_device_ops nsim_vf_netdev_ops = {
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 7d8ed8d8df5c..e78e88a0baa1 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -102,6 +102,7 @@ struct netdevsim {
 	} udp_ports;
 
 	struct nsim_ethtool ethtool;
+	struct kernel_hwtstamp_config hw_tstamp_config;
 };
 
 struct netdevsim *
-- 
2.39.2

