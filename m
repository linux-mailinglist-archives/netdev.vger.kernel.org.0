Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD8338C6D2
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 14:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbhEUMub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 08:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhEUMua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 08:50:30 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670A9C061763
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 05:49:07 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 29so3039336pgu.11
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 05:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pGuPc/FWKOVvjhaHRN43mHg/w+5OJaPMhcuzSdmouas=;
        b=SsyTMFiRSBaxbEGOPNJk2PsZEN+4hTeX/8abTCA5DUXF83GqcbK4L3mi2tLPQj9Ep0
         8DJYTXH9XZC5Vp+ZWOASmVWucLMA9lLwn9jpYZhfS6LawydoUt8UUoHcpIPdXbicVgxH
         VIXprSTWEfwWNINvuSYOPa/Zw0vOS4aGrZizqs8TZEHV2CBobhxoyif/muGrupWz2+Wo
         HBDNKFTaRf1Gpa3WomeNKwqgwdQkpRQq5cR9bxtX4ZSRLubqhiG9zMWxCCEiCWVBeajQ
         KqxYjAMCBCJnTTxsqPAACqw1zv4yHPqeJnPJpaXGxv9IIHS1tw/zqchHq1kYFKXsklPk
         T/XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pGuPc/FWKOVvjhaHRN43mHg/w+5OJaPMhcuzSdmouas=;
        b=uf5zOe/u38+YBM9zCL/mjiUltel0txzzHVGKJ09o6bX09GhoTsSFbmM+RJKhIMTs0m
         EGoZSXc5ZXDleZ9IJEQv+hU9XGNpdAndwSUZgF6Ye1tQqh0rABAcbZ27iuqOX1/0ofne
         55vM//R/qNL43nnYkwg604q6eO3V7gmFK3mRYaWQgi5qLc1jqLwhS6KDhi3kcYa+HxCp
         XtYnps5pXk68GU8chNsKcleaC35YBdbcFl3u7pQvCIsNV22Gi8jNDJMaoSX1mHncH5OP
         KjnOiqBUgOdiAQPz4EtTkRMU5kuuey7eSFmreNU7KpQWvLYJnWfgnqpWuKxcgBHHXGB6
         yaKg==
X-Gm-Message-State: AOAM530X0P7/INoMBjPwpwVRgSnghNKu1LHE7TYs6ihvfhTj08exFu2q
        kjfDi0i1YNB7zPHCr5Qn2MUOug==
X-Google-Smtp-Source: ABdhPJx4ca0fPgEFRiDgD2lJUNF0Ana9vfd7DuRLBFrZ5qcbxuD40fXoDaL43ZLv/B0Q7cEo2irrPw==
X-Received: by 2002:a62:bd14:0:b029:2de:8bf7:2df8 with SMTP id a20-20020a62bd140000b02902de8bf72df8mr10185713pff.60.1621601346960;
        Fri, 21 May 2021 05:49:06 -0700 (PDT)
Received: from hsinchu02.internal.sifive.com (59-124-168-89.HINET-IP.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d10sm4271419pfo.65.2021.05.21.05.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 05:49:06 -0700 (PDT)
From:   Zong Li <zong.li@sifive.com>
To:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, palmer@dabbelt.com,
        paul.walmsley@sifive.com, schwab@linux-m68k.org, sboyd@kernel.org,
        aou@eecs.berkeley.edu, mturquette@baylibre.com,
        geert@linux-m68k.org, yixun.lan@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Cc:     Zong Li <zong.li@sifive.com>
Subject: [PATCH] net: macb: ensure the device is available before accessing GEMGXL control registers
Date:   Fri, 21 May 2021 20:48:59 +0800
Message-Id: <20210521124859.101012-1-zong.li@sifive.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If runtime power menagement is enabled, the gigabit ethernet PLL would
be disabled after macb_probe(). During this period of time, the system
would hang up if we try to access GEMGXL control registers.

We can't put runtime_pm_get/runtime_pm_put/ there due to the issue of
sleep inside atomic section (7fa2955ff70ce453 ("sh_eth: Fix sleeping
function called from invalid context"). Add the similar flag to ensure
the device is available before accessing GEMGXL device.

Signed-off-by: Zong Li <zong.li@sifive.com>
---
 drivers/net/ethernet/cadence/macb.h      | 2 ++
 drivers/net/ethernet/cadence/macb_main.c | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index d8d87213697c..acf5242ce715 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1309,6 +1309,8 @@ struct macb {
 
 	u32	rx_intr_mask;
 
+	unsigned int is_opened;
+
 	struct macb_pm_data pm_data;
 	const struct macb_usrio_config *usrio;
 };
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 6bc7d41d519b..e079ed10ad91 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2781,6 +2781,8 @@ static int macb_open(struct net_device *dev)
 	if (bp->ptp_info)
 		bp->ptp_info->ptp_init(dev);
 
+	bp->is_opened = 1;
+
 	return 0;
 
 reset_hw:
@@ -2818,6 +2820,8 @@ static int macb_close(struct net_device *dev)
 	if (bp->ptp_info)
 		bp->ptp_info->ptp_remove(dev);
 
+	bp->is_opened = 0;
+
 	pm_runtime_put(&bp->pdev->dev);
 
 	return 0;
@@ -2867,6 +2871,9 @@ static struct net_device_stats *gem_get_stats(struct macb *bp)
 	struct gem_stats *hwstat = &bp->hw_stats.gem;
 	struct net_device_stats *nstat = &bp->dev->stats;
 
+	if (!bp->is_opened)
+		return nstat;
+
 	gem_update_stats(bp);
 
 	nstat->rx_errors = (hwstat->rx_frame_check_sequence_errors +
-- 
2.31.1

