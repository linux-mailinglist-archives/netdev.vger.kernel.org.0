Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36F86EBCA4
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 05:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjDWD3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 23:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjDWD3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 23:29:12 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CD0210E
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 20:29:10 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-7606ce89ebcso99031139f.0
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 20:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682220550; x=1684812550;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hP8bu5KOGUVN1Wbdd5TILgIDJzXdQwhiwCS7uGeLOsE=;
        b=m3yuMWdg9ldpkx0UEOT4e2xZole3qgCHBSLuqnC+E497JhhQRFh5Owuu1ateZ8plYk
         jv+l6Tae8J7p6TrKyg9zdtzU38jYzD0IZ+1lt7WJU+kCksxEF3YQZ7QSS8qkce3Qmu+C
         ZBSoZcCtpDJhBu7nwhPHbAmwIW/qcikMz/Vjgtu8cbLW/08X+ajvP7dHasADe4+77kIc
         F9Qk1POQnoFIgDXa2oJYJcZqaUX0nMtzhLUugeAWzlFvOebquCQanLUBj12MSCVemVTN
         e6baY6OXR1PxIgQDWjEBG0We0CkTYD8wtV9/eEKJ48qkOruNij2qT3Q57lh877vnck6F
         kwXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682220550; x=1684812550;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hP8bu5KOGUVN1Wbdd5TILgIDJzXdQwhiwCS7uGeLOsE=;
        b=Rd4Huq8EHI4bRvfwhb73e7BzeOYVWXgEMIZvhniXskfb8/VFSHIhWgjkqR4wKuvKMf
         dnzR5iIWuNLMsjAEnvolEgAk94sX3GBkxIO9Ak88wr0TE7V4XIzj95Ag0sxX30jS5vQx
         GM3MYhEDTkH9UGIBS/viHL1sBgjrCwNVJUNn6weYVZTaIGjwSvgYr0lSOWGxLpWgl0be
         V0T9igWcjDEWfiyUxGaHNR6UZ2eVvDnO34Q3iYZQkDi4dMLGXyWDACByfq5D45WFeVu7
         faqQSynNL/cBZoRi9VFSqKnd1xunIBh2rP6DjZ2RjOsXJjZ5tmWG4lFoTNj0YXwv1+DH
         zsAg==
X-Gm-Message-State: AAQBX9d0cmb+fajV1StjajRaBz8HcxL2pGYnE1g/okjxINqiVCCQiPcC
        Jm6uqMhlTcOF1iMwmBCPBVE=
X-Google-Smtp-Source: AKy350ae5i5mVNWfg/T4rv6HIo+7HqCOrAr4q9tdxQpm7U+oIeeS9Hzg8bNZgJbmebJaHfW3JhgxqQ==
X-Received: by 2002:a92:cc12:0:b0:328:18af:df0 with SMTP id s18-20020a92cc12000000b0032818af0df0mr2896816ilp.23.1682220550106;
        Sat, 22 Apr 2023 20:29:10 -0700 (PDT)
Received: from lenovot480s.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id v4-20020a056e0213c400b0031796c6d735sm2134561ilj.41.2023.04.22.20.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 20:29:09 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: [RFC PATCH v4 5/5] Implement ndo_hwtstamp_get/set methods in netdevsim driver
Date:   Sat, 22 Apr 2023 21:29:08 -0600
Message-Id: <20230423032908.285475-1-glipus@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implementing ndo_hwtstamp_get/set methods in  netdevsim driver
to use the newly introduced ndo_hwtstamp_get/setmake it respond to
 SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs.
 Also adding .get_ts_info ethtool method allowing to monitor
 HW timestamp configuration values set using SIOCSHWTSTAMP·IOCTL.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maxim Georgiev <glipus@gmail.com>
---

Notes:
  Changes in V4:
  - Implemented .get_ts_info·ethtool·method.
  - Tested the patch using  hwstamp_ctl and ethtool:

[root@centosvm kernel-net-next]# ethtool -T eni0np1
Time stamping parameters for eni0np1:
Capabilities:
        software-transmit
        software-receive
        software-system-clock
PTP Hardware Clock: none
Hardware Transmit Timestamp Modes: none
Hardware Receive Filter Modes: none
[root@centosvm kernel-net-next]# hwstamp_ctl -i eni0np1 -t 1 -r 0
current settings:
tx_type 0
rx_filter 0
new settings:
tx_type 1
rx_filter 0
[root@centosvm kernel-net-next]# ethtool -T eni0np1
Time stamping parameters for eni0np1:
Capabilities:
        software-transmit
        software-receive
        software-system-clock
PTP Hardware Clock: none
Hardware Transmit Timestamp Modes:
        off
Hardware Receive Filter Modes: none
[root@centosvm kernel-net-next]# hwstamp_ctl -i eni0np1 -t 1 -r 14
current settings:
tx_type 1
rx_filter 0
new settings:
tx_type 1
rx_filter 14
[root@centosvm kernel-net-next]# ethtool -T eni0np1
Time stamping parameters for eni0np1:
Capabilities:
        software-transmit
        software-receive
        software-system-clock
PTP Hardware Clock: none
Hardware Transmit Timestamp Modes:
        off
Hardware Receive Filter Modes:
        all
        some
        ptpv1-l4-event
---
 drivers/net/netdevsim/ethtool.c   | 11 +++++++++++
 drivers/net/netdevsim/netdev.c    | 24 ++++++++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  1 +
 3 files changed, 36 insertions(+)

diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index ffd9f84b6644..cbb8e261b759 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -140,6 +140,16 @@ nsim_set_fecparam(struct net_device *dev, struct ethtool_fecparam *fecparam)
 	return 0;
 }
 
+static int nsim_get_ts_info(struct net_device *netdev,
+			    struct ethtool_ts_info *info)
+{
+	struct netdevsim *ns = netdev_priv(netdev);
+
+	info->tx_types = ns->hw_tstamp_config.tx_type;
+	info->rx_filters = ns->hw_tstamp_config.rx_filter;
+	return ethtool_op_get_ts_info(netdev, info);
+}
+
 static const struct ethtool_ops nsim_ethtool_ops = {
 	.supported_coalesce_params	= ETHTOOL_COALESCE_ALL_PARAMS,
 	.get_pause_stats	        = nsim_get_pause_stats,
@@ -153,6 +163,7 @@ static const struct ethtool_ops nsim_ethtool_ops = {
 	.set_channels			= nsim_set_channels,
 	.get_fecparam			= nsim_get_fecparam,
 	.set_fecparam			= nsim_set_fecparam,
+	.get_ts_info			= nsim_get_ts_info,
 };
 
 static void nsim_ethtool_ring_init(struct netdevsim *ns)
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

