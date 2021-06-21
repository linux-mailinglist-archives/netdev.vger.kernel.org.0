Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3ACB3AEA61
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbhFUNw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhFUNw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:52:26 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5515DC061574;
        Mon, 21 Jun 2021 06:50:11 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id t32so2341811pfg.2;
        Mon, 21 Jun 2021 06:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DBou2U3DbdBx2HAvE0ysMUQo/yZWXheADNN9pWctBks=;
        b=GWKNw1JcmWis30OKyHO71+fBGmI3NbAib4vqlDZAp7UkhXBybqg12/Fq1WMl046P99
         N2PqLpoPFKSwx+3e7bdgHm7l9jBeB37OhjxaalKlZG5wv1WzHcOuoCb5+LEIoCZwqhuP
         jfNpsDSGY7RMwCsS6IiZlEa3OrkudQPsp1t3TudPBH2j30JIt8uyKvMApEF13ZS9GbpI
         UHuHOQZdE/DvRLvEL93OpmUxC9/WXGLGuZF9DKaowQyDnxtHaYPyE/KB9pXskdBASjOq
         U8k/mX83ZPGNuhDAINrYs8SSsEay1XwCeRvrvr17KZSGgTysvuc6P+nvTwM3rwPzf/gC
         NYuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DBou2U3DbdBx2HAvE0ysMUQo/yZWXheADNN9pWctBks=;
        b=LGlq9ee6WhmDkBs5jHvnK3QghbkkUbbl/YduhlHTO7gG7tvNmCD+OqxPMm78AGpN9K
         v7I4u8++r01MAW4wvli4C0lNmB6gcRusH+d5lrbMG3sqiqASELY4zdDbDkxEPNVr7whQ
         KS9O6LThNL2U5tJARd2Kc7N2FOPBmtk68YT+4qjc79KrKAWbHPZ4YYjLNaOPffQEqa0d
         sGeOe9jTzmxN7KJw6pHZnTglshLQnYWc3yhMXQrgcmSn6kqNcx5OU2ExMfAyIwl+GLyU
         Kg+/MYPY1/dqDQe0c5ZL5mP4UGe1DC3BxEg2F6GFslfH3MY5BAvO1t/DdWFF5jDMtA6D
         O8ww==
X-Gm-Message-State: AOAM530Wpl638rw6E1tTKHrfYJNiYbfOzCZhZWOkBx40/hQq1qyR2xGG
        Xva4yOZKJCjucGsE6j+/xe8=
X-Google-Smtp-Source: ABdhPJzmU9VIYcBXi5sAGEdgbXP6fDRUJGxHEedFTshK6heS/TZJbo1xbXtw69UFb3nHPDQuBUzYng==
X-Received: by 2002:a63:d909:: with SMTP id r9mr24445084pgg.285.1624283410868;
        Mon, 21 Jun 2021 06:50:10 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u11sm12723177pjf.46.2021.06.21.06.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:50:10 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 06/19] staging: qlge: disable flow control by default
Date:   Mon, 21 Jun 2021 21:48:49 +0800
Message-Id: <20210621134902.83587-7-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621134902.83587-1-coiby.xu@gmail.com>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the TODO item,
> * the flow control implementation in firmware is buggy (sends a flood of pause
>   frames, resets the link, device and driver buffer queues become
>   desynchronized), disable it by default

Currently, qlge_mpi_port_cfg_work calls qlge_mb_get_port_cfg which gets
the link config from the firmware and saves it to qdev->link_config. By
default, flow control is enabled. This commit writes the
save the pause parameter of qdev->link_config and don't let it
overwritten by link settings of current port. Since qdev->link_config=0
when qdev is initialized, this could disable flow control by default and
the pause parameter value could also survive MPI resetting,
    $ ethtool -a enp94s0f0
    Pause parameters for enp94s0f0:
    Autonegotiate:  off
    RX:             off
    TX:             off

The follow control can be enabled manually,

    $ ethtool -A enp94s0f0 rx on tx on
    $ ethtool -a enp94s0f0
    Pause parameters for enp94s0f0:
    Autonegotiate:  off
    RX:             on
    TX:             on

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/TODO       |  3 ---
 drivers/staging/qlge/qlge_mpi.c | 11 ++++++++++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
index b7a60425fcd2..8c84160b5993 100644
--- a/drivers/staging/qlge/TODO
+++ b/drivers/staging/qlge/TODO
@@ -4,9 +4,6 @@
   ql_build_rx_skb(). That function is now used exclusively to handle packets
   that underwent header splitting but it still contains code to handle non
   split cases.
-* the flow control implementation in firmware is buggy (sends a flood of pause
-  frames, resets the link, device and driver buffer queues become
-  desynchronized), disable it by default
 * some structures are initialized redundantly (ex. memset 0 after
   alloc_etherdev())
 * the driver has a habit of using runtime checks where compile time checks are
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index 2630ebf50341..0f1c7da80413 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -806,6 +806,7 @@ int qlge_mb_get_port_cfg(struct qlge_adapter *qdev)
 {
 	struct mbox_params mbc;
 	struct mbox_params *mbcp = &mbc;
+	u32 saved_pause_link_config = 0;
 	int status = 0;
 
 	memset(mbcp, 0, sizeof(struct mbox_params));
@@ -826,7 +827,15 @@ int qlge_mb_get_port_cfg(struct qlge_adapter *qdev)
 	} else	{
 		netif_printk(qdev, drv, KERN_DEBUG, qdev->ndev,
 			     "Passed Get Port Configuration.\n");
-		qdev->link_config = mbcp->mbox_out[1];
+		/*
+		 * Don't let the pause parameter be overwritten by
+		 *
+		 * In this way, follow control can be disabled by default
+		 * and the setting could also survive the MPI reset
+		 */
+		saved_pause_link_config = qdev->link_config & CFG_PAUSE_STD;
+		qdev->link_config = ~CFG_PAUSE_STD & mbcp->mbox_out[1];
+		qdev->link_config |= saved_pause_link_config;
 		qdev->max_frame_size = mbcp->mbox_out[2];
 	}
 	return status;
-- 
2.32.0

