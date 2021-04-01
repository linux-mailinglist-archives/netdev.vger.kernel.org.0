Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8784B351F55
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236393AbhDATF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240138AbhDATEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:04:06 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC39C03D20A
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 10:56:35 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so3500030pjb.0
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 10:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QU+/yIXvO+plGLGdb6Eou3LsEzYGxOH2fALgRHWg/6I=;
        b=genrHoOFPkBa/LxVFvUBx8helwVw3DMQzULg6Cng3sF8Gf9xD0V/aoFdFnpAxxtiSB
         TuEb55TBNfirGbYBMB3WY0APb91lYGhCyZtcQ+K4yPCgjZskG/2JEPZPF4StZiBPhSzE
         OQCVgP62yeHhXBJ+K0a5ZgglLZ4hupM/hLWms4ZS4XHciL6hKMOQK+jgWpiFCCrT7TYJ
         HJhM4MQLotlG2ahuIZJHo4mqYZSuf9Lzrntgzd82z3djypn9yncxYs37mCzF06qcG1bH
         qj3xgeylsUGRxZDa7HKOZZfecwHr3wS+kewawkn0cw9lvidFZP0SbW6mWE7t2aui1iPd
         BL+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QU+/yIXvO+plGLGdb6Eou3LsEzYGxOH2fALgRHWg/6I=;
        b=ljZXyzMHHVDxuXAryhdVWCIzti6iZnqqD8y9K6tDKYHUOg45Gr15FleQ9DiOSUSQN7
         CIhLNJIvplAvjIUs4e+pkXDJUq6ISBKOldPYIddGQLklabNIfvbnWdou/bpOTfulMnsE
         HapQza4JmVote6e0ASck/tXQ4X6bXhQQqyXxf+FlPDQfxk74nQ9Gce7r3AugRqVLVHXP
         Z4Kn5qE+FbU37EiKOVY3jOhrOkj4TRUp0ggClnyeKZxlVaVCN1WGFRuWGcS8xDOHmivS
         i6iE8K8tc+r4De1/vUpuLWVoOltLZQ1JTg19FU61n2GVTQEqvFw8Otfu6SY/1nRb8j2I
         wtrA==
X-Gm-Message-State: AOAM5324Tz0Pk+tGpLxEk3Pn6+Aew3UIEwDJg5L2hHyCF7QK1smK3gT2
        dSukyF6J43CBXpAV87PKVllZ6izgzANtPg==
X-Google-Smtp-Source: ABdhPJynY2Z/qGINrjEBw8utgtQFgnz7RjOppzBHCh+RSN4R0ThCRQibTvJXXB7mZpsvg3zyelnaFQ==
X-Received: by 2002:a17:90a:de90:: with SMTP id n16mr10098346pjv.10.1617299794942;
        Thu, 01 Apr 2021 10:56:34 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n5sm6195909pfq.44.2021.04.01.10.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 10:56:34 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>,
        Allen Hubbe <allenbh@pensando.io>
Subject: [PATCH net-next 12/12] ionic: advertise support for hardware timestamps
Date:   Thu,  1 Apr 2021 10:56:10 -0700
Message-Id: <20210401175610.44431-13-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210401175610.44431-1-snelson@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let the network stack know we've got support for timestamping
the packets.

Signed-off-by: Allen Hubbe <allenbh@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index e14c93fbbd68..ee56fed12e07 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1540,6 +1540,9 @@ static int ionic_set_nic_features(struct ionic_lif *lif,
 
 	ctx.cmd.lif_setattr.features = ionic_netdev_features_to_nic(features);
 
+	if (lif->phc)
+		ctx.cmd.lif_setattr.features |= cpu_to_le64(IONIC_ETH_HW_TIMESTAMP);
+
 	err = ionic_adminq_post_wait(lif, &ctx);
 	if (err)
 		return err;
@@ -1587,6 +1590,8 @@ static int ionic_set_nic_features(struct ionic_lif *lif,
 		dev_dbg(dev, "feature ETH_HW_TSO_UDP\n");
 	if (lif->hw_features & IONIC_ETH_HW_TSO_UDP_CSUM)
 		dev_dbg(dev, "feature ETH_HW_TSO_UDP_CSUM\n");
+	if (lif->hw_features & IONIC_ETH_HW_TIMESTAMP)
+		dev_dbg(dev, "feature ETH_HW_TIMESTAMP\n");
 
 	return 0;
 }
@@ -2260,6 +2265,20 @@ static int ionic_stop(struct net_device *netdev)
 	return 0;
 }
 
+static int ionic_do_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		return ionic_lif_hwstamp_set(lif, ifr);
+	case SIOCGHWTSTAMP:
+		return ionic_lif_hwstamp_get(lif, ifr);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int ionic_get_vf_config(struct net_device *netdev,
 			       int vf, struct ifla_vf_info *ivf)
 {
@@ -2508,6 +2527,7 @@ static int ionic_set_vf_link_state(struct net_device *netdev, int vf, int set)
 static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_open               = ionic_open,
 	.ndo_stop               = ionic_stop,
+	.ndo_do_ioctl		= ionic_do_ioctl,
 	.ndo_start_xmit		= ionic_start_xmit,
 	.ndo_get_stats64	= ionic_get_stats64,
 	.ndo_set_rx_mode	= ionic_ndo_set_rx_mode,
@@ -3331,6 +3351,8 @@ int ionic_lif_register(struct ionic_lif *lif)
 {
 	int err;
 
+	ionic_lif_register_phc(lif);
+
 	INIT_WORK(&lif->ionic->nb_work, ionic_lif_notify_work);
 
 	lif->ionic->nb.notifier_call = ionic_lif_notify;
@@ -3343,6 +3365,7 @@ int ionic_lif_register(struct ionic_lif *lif)
 	err = register_netdev(lif->netdev);
 	if (err) {
 		dev_err(lif->ionic->dev, "Cannot register net device, aborting\n");
+		ionic_lif_unregister_phc(lif);
 		return err;
 	}
 
@@ -3364,6 +3387,8 @@ void ionic_lif_unregister(struct ionic_lif *lif)
 	if (lif->netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(lif->netdev);
 
+	ionic_lif_unregister_phc(lif);
+
 	lif->registered = false;
 }
 
-- 
2.17.1

