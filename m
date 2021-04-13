Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD72835E395
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbhDMQOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:14:51 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:56294 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236853AbhDMQOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 12:14:50 -0400
Received: by mail-pj1-f42.google.com with SMTP id s14so3881320pjl.5
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 09:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=iSAfcoXWMcp4vIO/hmP8WHU5ueIesuk/x+qaS/FwD28=;
        b=BtidDkLLGIu+jp9iK3VeFKCjdOyRXZx5m7XZDr3g/gHUUw4k2ioqWw35c07iaZjziZ
         MgO09/kn20sSoiH2VuSHc6Dd5SzL6Jg07mS7uWA8CeSUl3uuwdNiwAN6HaBESBBLzkU9
         kortkwHm+YyZQZ9jYqxYIWQ15yVLhb487nJVLc2mpx7j+gd05x85zeHUtAHPZYvOhcAM
         I0Z6E8M9//u7GnlVdUv24ajao3RGBJ1jjNdGnrd3pDdx0U1kv4xFmTCxy0Uuykk3QnDB
         o6Vz4IebYEne8ZuGCrJuYPQ8k+xvoEmv8fUmqwafayn/LuBh7DUHtrckEjZgFB0JtHNn
         kWJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iSAfcoXWMcp4vIO/hmP8WHU5ueIesuk/x+qaS/FwD28=;
        b=Fc5+MYJrQS7Hqe7azbzRBAXYxecJz3z3qP1jXGeUWOpPrwyiBQSjSe0IwQRLSsNyEf
         ls94GQ/Ngz1YzuoHPm/bNIB6JbxHaqabRzEo/YIKGko+ZiwE2AESOcMEpZk9ccK3AmCm
         rKy+YOVMM/LDctAs8PHXXqLBqLvVl48XKKf/yd2tIRpGXFO1a8gHWZC8W6aMdwkMW/A/
         BfMDlXH31UmwNwtpWGTkh4tSQpv26x7Jkyp1Sxx3HBSQf+pQGmZrQYJ2c2xmC8Ae5gGO
         wRrtI63n/S5nyoE/GrCbexj5vTTS4TNtO+gagAxfXlKkb/o2DaW3pwNLDYXv8qlVtStz
         zURA==
X-Gm-Message-State: AOAM532y9IXQ/AP3ZWZevrvq+YrwBtevMGjDAqq3ORrctmGzA9xSz5zh
        gm3+CR5IDPU2NLmKr6FuwOAPM+6F17BRXyiq
X-Google-Smtp-Source: ABdhPJyKq/xNG1hmOWytuYeCXzopeCQbOkOQcY22viA7KmjY8TXGsGhZozrZWZ3FQ2lkAxtWJ4AZxQ==
X-Received: by 2002:a17:902:6b81:b029:ea:dcc5:b841 with SMTP id p1-20020a1709026b81b02900eadcc5b841mr15045253plk.29.1618330410493;
        Tue, 13 Apr 2021 09:13:30 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id y189sm12645187pfy.8.2021.04.13.09.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 09:13:29 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, dan.carpenter@oracle.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH] ionic: git_ts_info bit shifters
Date:   Tue, 13 Apr 2021 09:13:02 -0700
Message-Id: <20210413161302.28315-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the uses of HWTSTAMP_FILTER_* values need to be
bit shifters, not straight values.

Fixes: f8ba81da73fc ("ionic: add ethtool support for PTP")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
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

