Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9D23732F1
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 02:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhEEACD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 20:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbhEEACD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 20:02:03 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFBCC061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 17:01:07 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id d29so487667pgd.4
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 17:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=4qybi5aiyECmcRN0sICrxQM/k6gdBjFkSlqlduJd4Sw=;
        b=GIIGe+PMEH35TnT/H/6U9f8Ga90pcO8q+xS9Vo91Yv+ToAztVStKtY6VEZZkkhd5Vk
         nq/vH3AURt0IUU3bGLeWdZTGQW+8Gyk2YYBdJ4b3NNeYpxa02claxuD4IYKQUdqtR3aH
         yIkOz+mZrQnGjKzwyGA12DGSMgT2W3zqUC09n5Fsg/pZDxrxQb6PaUJTC4jTaFp85DBC
         84bfk/8rWKn2PWZHrriaQk5iuUMvYwVIpJYN5QY1efgIBQq1hOyhEkMUyNlD8pfFmY+L
         Wl8VorIukhM9LOyo++ZIG91EnGjkMZ6YpN8kr97ImQAvY/c335Ow73depjAWzSyQ6B10
         jfbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4qybi5aiyECmcRN0sICrxQM/k6gdBjFkSlqlduJd4Sw=;
        b=ZOpzBfS7ajNv2ZRATKGZ3qJEZawvlcOou84zh3AQcoTWG0LbXi5/oIau2vHw9hxx/u
         hcpsQflbVPRr1sTvyreFFemrS8WJi0r5CMkIR7OpFtOPmfmbhUrrcRJ/MLc6+piOjMKD
         l7sLK2rohnOh/p+6TonvsfI/AEvbnBMM43rVtB9afTVieD753KCZuDhqyKqyVBtTTYgn
         Pz+YrDX8wL4wPMLzAo4oFTsLJZsMWeGDQf0j2S7X2AvCmXI9WooO5u+cDFFJvtjDlplm
         8YEwgFltRKLcPgtHezcN//uUgLoq4u+JLXKTiqZm1K1agE8FuOaB/+LDRknYWTFpRL74
         PB1A==
X-Gm-Message-State: AOAM531KmbMOsaC1aN5+EYPQyhh+aDwa4sywLEUZrUJbR+mY7BJFvVVp
        O1GTl5XTfYdRinH8u2SWWV9zP7J0eEsBSw==
X-Google-Smtp-Source: ABdhPJxmdB4ENWpCghiaAqFqmMKO52mY18Lqx6RWFDz0MMUmDkuLONWBH8wKIxBOS+U5Lg81y8wDiQ==
X-Received: by 2002:a17:90b:38f:: with SMTP id ga15mr30860515pjb.196.1620172867042;
        Tue, 04 May 2021 17:01:07 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id u129sm13297127pfb.8.2021.05.04.17.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 17:01:06 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net] ionic: fix ptp support config breakage
Date:   Tue,  4 May 2021 17:00:59 -0700
Message-Id: <20210505000059.59760-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver link failed with undefined references in some
kernel config variations.

v2 - added Fixes tag

Fixes: 61db421da31b ("ionic: link in the new hw timestamp code")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/Makefile    | 3 +--
 drivers/net/ethernet/pensando/ionic/ionic_phc.c | 3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
index 4e7642a2d25f..61c40169cb1f 100644
--- a/drivers/net/ethernet/pensando/ionic/Makefile
+++ b/drivers/net/ethernet/pensando/ionic/Makefile
@@ -5,5 +5,4 @@ obj-$(CONFIG_IONIC) := ionic.o
 
 ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
 	   ionic_debugfs.o ionic_lif.o ionic_rx_filter.o ionic_ethtool.o \
-	   ionic_txrx.o ionic_stats.o ionic_fw.o
-ionic-$(CONFIG_PTP_1588_CLOCK) += ionic_phc.o
+	   ionic_txrx.o ionic_stats.o ionic_fw.o ionic_phc.o
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
index a87c87e86aef..30c78808c45a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2017 - 2021 Pensando Systems, Inc */
 
+#if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
+
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 
@@ -613,3 +615,4 @@ void ionic_lif_free_phc(struct ionic_lif *lif)
 	devm_kfree(lif->ionic->dev, lif->phc);
 	lif->phc = NULL;
 }
+#endif /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */
-- 
2.17.1

