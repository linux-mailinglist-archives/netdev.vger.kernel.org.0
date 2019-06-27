Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E52588C8
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfF0RkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:40:03 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33983 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfF0RkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:40:02 -0400
Received: by mail-pf1-f196.google.com with SMTP id c85so1596068pfc.1;
        Thu, 27 Jun 2019 10:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sTaNIRgFBqMQPDw0TPcpG7R1iaHcLwdE4qgc0/lS9Dk=;
        b=DFjSpVI+QyiqRRwnKxUVzTbhIPMReAv5xG9MDT2+gqDowmz/pv9J/9oe/9ATvtWKm2
         CFWmBbLxSHh7rUj6QzUdDcYhBXL92prABGBWr0MiwWyx/+SpdnGZCQiMjZQYc9Hw7j7s
         /L0RBB5JX8rO2YKrg6a736ylnh3i9J4BLG0CR80tAP2vX9KuyXa6fWH6TemWm1B6yaR6
         HrK3EftUi2rsPEEe0PLz9p/HLeo34KgGhDGEqXE7VI1YBjTH+4QTc7l2OY1kkFK/Rpc5
         R4ewKRt0BsitJzky/9+gdzN+gm+zSZBgdF51GrgUqfs5z3xMpg0/t9fLrynE+WG1k4KZ
         Ak0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sTaNIRgFBqMQPDw0TPcpG7R1iaHcLwdE4qgc0/lS9Dk=;
        b=FA61a+PZgqcilzNjLePq/hqQmgHXiuq0Me5wntfy5gFod3lVNYeS2It1XnaNKZCaoD
         nPJcgY5+g+vAuDFMi5QXTpGfIpabBCbvnXYmG5c2+Gpy6qTVl5USYzfTPBDWWcpEN7ym
         bUBPEfWKb+VTE3Knd1YK5IFSxA+d9lT/eFXKf4NswMKuiZsYplmpDG1IYNKFyeySNuDE
         v2Ke7uaLkKigHdU86US1O1Ki8WX9O9Ss0q5GRPg8lHOApqTrn1N1D8tX1vXM/QrA/3kK
         QNvHWVnjv4TYyFnoqVqwsGrqKg9xwZvErEQKY5cSKG4utLWMucQWgwluqVhNZ7xwA5Ix
         3NhA==
X-Gm-Message-State: APjAAAWD+xr129v0FPy8NHLM5jN/wxfKMQVdeKU4TIcIcIN04R05iPYD
        TxupCaZ6E1G3ubbNHFzbc5M=
X-Google-Smtp-Source: APXvYqyv44uwLwZ85+ZWtuNVuMXPbhhpAeuFG0N8jYFYoehGCLNQEDxGQjrXZnFlRHg6p3HAlO3XUw==
X-Received: by 2002:a63:d0:: with SMTP id 199mr4884238pga.85.1561657201964;
        Thu, 27 Jun 2019 10:40:01 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id n89sm11449259pjc.0.2019.06.27.10.39.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:40:01 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 40/87] ethernet: cavium: replace vmalloc and memset with vzalloc
Date:   Fri, 28 Jun 2019 01:39:54 +0800
Message-Id: <20190627173954.3943-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vmalloc + memset(0) -> vzalloc

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c | 4 +---
 drivers/net/ethernet/cavium/liquidio/cn23xx_vf_device.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
index 43d11c38b38a..cf3835da32c8 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
@@ -719,12 +719,10 @@ static int cn23xx_setup_pf_mbox(struct octeon_device *oct)
 	for (i = 0; i < oct->sriov_info.max_vfs; i++) {
 		q_no = i * oct->sriov_info.rings_per_vf;
 
-		mbox = vmalloc(sizeof(*mbox));
+		mbox = vzalloc(sizeof(*mbox));
 		if (!mbox)
 			goto free_mbox;
 
-		memset(mbox, 0, sizeof(struct octeon_mbox));
-
 		spin_lock_init(&mbox->lock);
 
 		mbox->oct_dev = oct;
diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_device.c b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_device.c
index fda49404968c..b3bd2767d3dd 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_device.c
@@ -279,12 +279,10 @@ static int cn23xx_setup_vf_mbox(struct octeon_device *oct)
 {
 	struct octeon_mbox *mbox = NULL;
 
-	mbox = vmalloc(sizeof(*mbox));
+	mbox = vzalloc(sizeof(*mbox));
 	if (!mbox)
 		return 1;
 
-	memset(mbox, 0, sizeof(struct octeon_mbox));
-
 	spin_lock_init(&mbox->lock);
 
 	mbox->oct_dev = oct;
-- 
2.11.0

