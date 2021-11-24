Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011BE45CE70
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240489AbhKXUzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238237AbhKXUzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 15:55:47 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310DAC061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:52:37 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id o29so3670777wms.2
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4I6KzcrFicYo9LeloddfjBs4kzCZjK+ASgbiJWwrco8=;
        b=LO32Wu7vI58qtm1ao/u9r4oX3neFJzQhyqizjGbMv6EOEsGA7f6YdBeMJnSNc9tyM8
         r1LrbuxPbvl309U9NaylmG3Gh0xOK4GZUybtNkXKxUCUdWrLD8IgVfrcg4lvzTN+UuF9
         lMIAvW+77YyLeL/tCvDFGFar6zyvT0m1zOZBDrKpaJKeAHkbHs5IX8z5z9qYN0HvzAP9
         SblN8+mXgD07tKjkDcBZ+GYpPRziQpWm73+hXZKiUe88IpSJp7pUUCJFVm5V/yblbyEo
         szut8DzUaLVYrQvRRLndhk3Gw6ZzY3hzCtV6igvqn5wOznBH27s+fvt7edLFhSVdrOos
         gUzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4I6KzcrFicYo9LeloddfjBs4kzCZjK+ASgbiJWwrco8=;
        b=UaIUHTL1WoXyBzuAgzGr2TQSvYj4cX2TGrZAzpQn/t663w3W1rDI8umhtHR7AVmmCR
         TUKSUXCbWshDtFiadQwY7tvV4NkE3hnObhu3wzqY2hjVU7Vvsj1IuPhI/MzUn4hLGbna
         2kGRLgQ/E7Gi6KjiNAELgK5ToFyvgopMRUELkY1TLk/9Nndh9qF+TZTYchUs0v2rlkdX
         bP6+NuXlyo/8qBcBt4eLx0ZOmLsY9ZtzSeSp3MaJC/mAQS0AXOux1j1YI856vZboZmn5
         I05KZxdhmxcZ42fkrymj5iiSMk1MYAUYgqGOsoxFRlPuwBa+DrjYroDe/EIXXuElx1ht
         OT3Q==
X-Gm-Message-State: AOAM5322nPunlQ8yArBekf0vz8QUOhkoxtuUhUYNEfep/39BNd+W6VZx
        zx220xvl74uGdkVRCejMHPGx2iquN0H4I9/Abtk=
X-Google-Smtp-Source: ABdhPJyRmwLn6JhsXlRtKwlDt6xTdBQvObBNtfuNj+2zvupJNizfuh3iNsmBHGCt0OPG3+AiFOhg8g==
X-Received: by 2002:a05:600c:1548:: with SMTP id f8mr20714061wmg.20.1637787155828;
        Wed, 24 Nov 2021 12:52:35 -0800 (PST)
Received: from hornet.engleder.at (dynamic-2ent3hb60johxrmi81-pd01.res.v6.highway.a1.net. [2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id d6sm846691wrn.53.2021.11.24.12.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 12:52:35 -0800 (PST)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, yang.lee@linux.alibaba.com
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        kernel test robot <lkp@intel.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH net-next] tsnep: Fix resource_size cocci warning
Date:   Wed, 24 Nov 2021 21:52:25 +0100
Message-Id: <20211124205225.13985-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerhard Engleder <gerhard@engleder-embedded.com>

The following warning is fixed, by removing the unused resource size:

drivers/net/ethernet/engleder/tsnep_main.c:1155:21-24:
WARNING: Suspicious code. resource_size is maybe missing with io

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h      | 1 -
 drivers/net/ethernet/engleder/tsnep_main.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index d19fa175e3d9..23bbece6b7de 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -125,7 +125,6 @@ struct tsnep_adapter {
 	struct platform_device *pdev;
 	struct device *dmadev;
 	void __iomem *addr;
-	unsigned long size;
 	int irq;
 
 	bool gate_control;
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 8333313dd706..3847368adbeb 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1152,7 +1152,6 @@ static int tsnep_probe(struct platform_device *pdev)
 	adapter->addr = devm_ioremap_resource(&pdev->dev, io);
 	if (IS_ERR(adapter->addr))
 		return PTR_ERR(adapter->addr);
-	adapter->size = io->end - io->start + 1;
 	adapter->irq = platform_get_irq(pdev, 0);
 	netdev->mem_start = io->start;
 	netdev->mem_end = io->end;
-- 
2.20.1

