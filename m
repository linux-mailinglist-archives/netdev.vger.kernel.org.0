Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B003D6F3CC0
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 06:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbjEBEcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 00:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbjEBEcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 00:32:00 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACEE449E
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 21:31:59 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-32a7770f7baso8806065ab.2
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 21:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683001918; x=1685593918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/oNmPdGypaQsPeyiAflmaKyny/t3TVT2+8BbOja89Xg=;
        b=NWV0HQlWxDbvfQeYhA/yKsas+6emXes99/x/PNcUHvNeHjSfs41sA2WBZp5U1y/J8e
         Ah/sfs5lXVDwvoG/k50+auNJqaEeTPRWWvG0CGFchDH6Dd1fUYz3hAzXlt8ORXQN3VHw
         zDxSCtPbqt+isXT+0Kba88bIYH9Q2gDQZ6gxDHBmA5JJIyphcMVOV1hrIqzvQXZAsMCj
         Bt7+cFAoRlELc7V5jMEa3PVt3nBmEwgPxudpaw7rfpBNPl1mDEFH4yBK8Z/XmiD5Ys4O
         v+mYFN7WN2GYHPd0v/feglWOkHsbXsi5/41perdLoWl0FUyo0z0dyrtmVa6HIRnq+vZV
         USjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683001918; x=1685593918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/oNmPdGypaQsPeyiAflmaKyny/t3TVT2+8BbOja89Xg=;
        b=X6aVgChDRr0fMYQwTSo827FenwKiplqwvnK2kE9/FrYKbrgBi3KuCQklAUCkBBZI4+
         gLp5mWrE8ALrBcruWfiBd46P4bRuLEJvxKIXtzG7pYYCrvbm8N0TrXoCObcgAxYLrgMa
         9r/E8mdhu/40rU0akq6xHQeag6SaFE3NDzz3dh2nYoMCC5K73Knc8+XyBKGUVPs+0Qmb
         JhS6Q6t5WgnBZM6NliJbucswc3qo4iop40TAjNHQM5esezqLOghejoiF+HsyjQiNP2Wz
         DQIyVtRy/X9fc+tyxZrdyfV+nukDxpetTrZ1o8hfjAO50W1tG1hdYSzaiujdHCxDZCqL
         AO0g==
X-Gm-Message-State: AC+VfDz50bJl1oJoNSXoXmNC6tDaVmn9hZZaazYSs5CCY4xRgNDsqVQk
        bwRwD8X1UI1G8bIK30XgVQU=
X-Google-Smtp-Source: ACHHUZ5ivVTTEXl1lP9Ft7p2TX+gmktfGyBbJdF+jrDgoHX31GYh1UnuiySLqMgFikKsqGpluIJ4nw==
X-Received: by 2002:a05:6e02:78a:b0:323:ced:cffe with SMTP id q10-20020a056e02078a00b003230cedcffemr10292039ils.12.1683001918438;
        Mon, 01 May 2023 21:31:58 -0700 (PDT)
Received: from lenovot480s.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id a10-20020a5d980a000000b0076373f90e46sm8239781iol.33.2023.05.01.21.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 21:31:58 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, liuhangbin@gmail.com
Subject: [RFC PATCH net-next v6 5/5] netdevsim: Implement ndo_hwtstamp_get/set methods in netdevsim driver
Date:   Mon,  1 May 2023 22:31:50 -0600
Message-Id: <20230502043150.17097-6-glipus@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230502043150.17097-1-glipus@gmail.com>
References: <20230502043150.17097-1-glipus@gmail.com>
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

Implementing ndo_hwtstamp_get/set methods in netdevsim driver
to use the newly introduced ndo_hwtstamp_get/setmake it respond to
 SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs.
 Also adding .get_ts_info ethtool method allowing to monitor
 HW timestamp configuration values set using SIOCSHWTSTAMP·IOCTL.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maxim Georgiev <glipus@gmail.com>
---

Notes:
  Changes in v6:
  - Patch title was updated. No code changes.
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
2.40.1

