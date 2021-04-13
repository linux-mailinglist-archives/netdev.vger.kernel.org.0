Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB5B35E4F6
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 19:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbhDMRYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 13:24:52 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:44638 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347172AbhDMRXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 13:23:55 -0400
Received: by mail-pg1-f172.google.com with SMTP id y32so12407361pga.11
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 10:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ensXxHe6GeOmADhf8FqIc8ASkNEA88IFt82kF5XQ9U4=;
        b=VLwUYzDQVC06uCrGw2TukVe5D/5ZCM0kv+Lv+oWtuNhFaXUgp3Xn58yE8gm62xCqAj
         793hWKfxHCzkKKBWwnuL5193lQpGwE5C1GSmQLP2skF9i1q6WH/ff+joazfrEtxxhRM/
         HMJV//Dn1jzIGbrnQiMNGCaC5my9hu5bTyfEhztvSSE3flNAy7LVr2/q2AZrZklbVjWV
         aq11h9gGXzqecZ3GsvJbjPZYUYHobsFxnBd48NnxxOSKts3ESEeBCL7UVMWN3jByb5Ha
         KHFuoVc4T9X3r/Pb2zNPo7CNaGfqp0khU02IjmZolFVU7UVeVqoAYnLEEFetrsilg4JI
         pkTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ensXxHe6GeOmADhf8FqIc8ASkNEA88IFt82kF5XQ9U4=;
        b=Hr4lMloZaYydWSoFXocPcbpkTbz04tFpDksajjIclCk0oxK1ok6taKmGi1Yl+Vga5t
         qQy6h8pF4e1hp1tAAGMMj49uY4ZS943RY57nOCwKCjBE4F9IkXS3vDyW+FS3UNsrzLCf
         /ztxb/DFXfJG/cy9FMfp1WQDdNtVvMWW9ud4bOTHBWySe0PQGeda+sqUSuMIy/SflSP8
         eFZV/7akSxESV/SYpbk2dmimSdfxwOr4UB0YnXWBEY3WW3QskSJfWlwY+2BryEawRwGN
         EnG/arr/0POwVcDgpUP3b3GZ1I1XeFEnKYNH727XaTFNnTQEOwB9yrgCxyabpN9CjbIL
         DMEA==
X-Gm-Message-State: AOAM533E1VYtMHhSQCZUpNZs9A6tQWg02qv+/kCGZ1D8xhFFeHhsGVh1
        CRSZux49LSj+ct1FBKuYc4YJZjRBCUgTFVHw
X-Google-Smtp-Source: ABdhPJxvilxB+o8w12TQ8AlfOay6nqNHQaNYyFDMHpktPr8pJpuh63u++ftKLJgK4WkybSrVXadsrg==
X-Received: by 2002:a62:62c6:0:b029:249:2545:4f91 with SMTP id w189-20020a6262c60000b029024925454f91mr16572000pfb.21.1618334554677;
        Tue, 13 Apr 2021 10:22:34 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h18sm14988036pgj.51.2021.04.13.10.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:22:34 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Allen Hubbe <allenbh@pensando.io>
Subject: [PATCH v2 net-next] ionic: git_ts_info bit shifters
Date:   Tue, 13 Apr 2021 10:22:16 -0700
Message-Id: <20210413172216.59026-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the uses of HWTSTAMP_FILTER_* values need to be
bit shifters, not straight values.

v2: fixed subject and added Cc Dan and SoB Allen

Fixes: f8ba81da73fc ("ionic: add ethtool support for PTP")
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: Allen Hubbe <allenbh@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 26 +++++++++----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 71db1e2c7d8a..6583be570e45 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -888,55 +888,55 @@ static int ionic_get_ts_info(struct net_device *netdev,
 
 	mask = cpu_to_le64(IONIC_PKT_CLS_NTP_ALL);
 	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
-		info->rx_filters |= HWTSTAMP_FILTER_NTP_ALL;
+		info->rx_filters |= BIT(HWTSTAMP_FILTER_NTP_ALL);
 
 	mask = cpu_to_le64(IONIC_PKT_CLS_PTP1_SYNC);
 	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
-		info->rx_filters |= HWTSTAMP_FILTER_PTP_V1_L4_SYNC;
+		info->rx_filters |= BIT(HWTSTAMP_FILTER_PTP_V1_L4_SYNC);
 
 	mask = cpu_to_le64(IONIC_PKT_CLS_PTP1_DREQ);
 	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
-		info->rx_filters |= HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ;
+		info->rx_filters |= BIT(HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ);
 
 	mask = cpu_to_le64(IONIC_PKT_CLS_PTP1_ALL);
 	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
-		info->rx_filters |= HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
+		info->rx_filters |= BIT(HWTSTAMP_FILTER_PTP_V1_L4_EVENT);
 
 	mask = cpu_to_le64(IONIC_PKT_CLS_PTP2_L4_SYNC);
 	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
-		info->rx_filters |= HWTSTAMP_FILTER_PTP_V2_L4_SYNC;
+		info->rx_filters |= BIT(HWTSTAMP_FILTER_PTP_V2_L4_SYNC);
 
 	mask = cpu_to_le64(IONIC_PKT_CLS_PTP2_L4_DREQ);
 	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
-		info->rx_filters |= HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ;
+		info->rx_filters |= BIT(HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ);
 
 	mask = cpu_to_le64(IONIC_PKT_CLS_PTP2_L4_ALL);
 	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
-		info->rx_filters |= HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
+		info->rx_filters |= BIT(HWTSTAMP_FILTER_PTP_V2_L4_EVENT);
 
 	mask = cpu_to_le64(IONIC_PKT_CLS_PTP2_L2_SYNC);
 	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
-		info->rx_filters |= HWTSTAMP_FILTER_PTP_V2_L2_SYNC;
+		info->rx_filters |= BIT(HWTSTAMP_FILTER_PTP_V2_L2_SYNC);
 
 	mask = cpu_to_le64(IONIC_PKT_CLS_PTP2_L2_DREQ);
 	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
-		info->rx_filters |= HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ;
+		info->rx_filters |= BIT(HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ);
 
 	mask = cpu_to_le64(IONIC_PKT_CLS_PTP2_L2_ALL);
 	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
-		info->rx_filters |= HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
+		info->rx_filters |= BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT);
 
 	mask = cpu_to_le64(IONIC_PKT_CLS_PTP2_SYNC);
 	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
-		info->rx_filters |= HWTSTAMP_FILTER_PTP_V2_SYNC;
+		info->rx_filters |= BIT(HWTSTAMP_FILTER_PTP_V2_SYNC);
 
 	mask = cpu_to_le64(IONIC_PKT_CLS_PTP2_DREQ);
 	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
-		info->rx_filters |= HWTSTAMP_FILTER_PTP_V2_DELAY_REQ;
+		info->rx_filters |= BIT(HWTSTAMP_FILTER_PTP_V2_DELAY_REQ);
 
 	mask = cpu_to_le64(IONIC_PKT_CLS_PTP2_ALL);
 	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
-		info->rx_filters |= HWTSTAMP_FILTER_PTP_V2_EVENT;
+		info->rx_filters |= BIT(HWTSTAMP_FILTER_PTP_V2_EVENT);
 
 	return 0;
 }
-- 
2.17.1

