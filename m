Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B59C871A13
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 16:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390524AbfGWOQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 10:16:31 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46316 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfGWOQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 10:16:30 -0400
Received: by mail-pg1-f196.google.com with SMTP id k189so468294pgk.13;
        Tue, 23 Jul 2019 07:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vnMp4KQz5A+KQDSXbk5N3b4UMi/Pfkv+7tT/nF0GEF0=;
        b=lVziAEHMQ5C5tS+95c5MdMdXA7umqy9khg7ApB8F/o4zEhNHi+cHu/GTSOnmgB4WAz
         pq556e+4IcQ3NPrwnnevxiFu/rCOCLETNhX8Z/FDElzdXAxmhlZmUlGs+WhUjj7ad7za
         9CF2OlvkJ5s150aw4pVd0uN3UQYTKcLn4VSEezIeXH9LJqpxiPFglmLtmk0K2ieFiNQa
         Jo3i1iKVF/gva/CFRGTiwS3z0K6VjR71+AuC708lUFqjJTXJ8d3at8/5CxRv0VALIb57
         SN4wgvIXE1V4WudvP8BT3/d+K6ae7DR5huI33T2uICKGQgbi4hMJ8X3+HairVndBob7l
         7IqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vnMp4KQz5A+KQDSXbk5N3b4UMi/Pfkv+7tT/nF0GEF0=;
        b=PmmCObzLhPST1IEptWJRRvdiLtm8V7/tmfP7HbkVGdVZbWtRMCtqPauhcvQ5E5nseC
         2XDfO37B7i0Z4q/AAOfQ8VF7OuingzZbTua8o0QcByka5K3RAkk2+YTNP4+iuSSjjURG
         YSOGyhw0CDhaU2QS36AHXOuHVT5vXpFP9yCOi2huGGOvrCiH84E09D2fHyBMn8KcjSWs
         jsUgW6OKjWGqqQSiIep+W9cpta1z7tdoTnmLA7blD59+bkbIyn9SsAJQEDIdeVWDngZ9
         3QQg0LTAAQRR0hfwTTvNgt6HnBJJME43ZkdmftronDxHGZF/jIjUDcM8HCbsOx9Rnqhn
         ExXw==
X-Gm-Message-State: APjAAAWzPi6xDRHQsrym5Slv6hknr1aEMEU1TBtfiy3fgP1aYx2fNvUD
        B80XN1i9/ERGri7rOIQQ++0=
X-Google-Smtp-Source: APXvYqxxoi6imH4gkqFil+us4JdezGtYIycjUbaLAvzxc5zK9SSNRiLSYowqscOtebT+Z39Bh2KCCg==
X-Received: by 2002:aa7:82da:: with SMTP id f26mr6071283pfn.82.1563891390353;
        Tue, 23 Jul 2019 07:16:30 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id h6sm40857737pfb.20.2019.07.23.07.16.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 07:16:29 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] igb: Use dev_get_drvdata where possible
Date:   Tue, 23 Jul 2019 22:16:24 +0800
Message-Id: <20190723141624.5911-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using to_pci_dev + pci_get_drvdata,
use dev_get_drvdata to make code simpler.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index b4df3e319467..145f58ee0451 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8879,8 +8879,7 @@ static int __maybe_unused igb_resume(struct device *dev)
 
 static int __maybe_unused igb_runtime_idle(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev);
 	struct igb_adapter *adapter = netdev_priv(netdev);
 
 	if (!igb_has_link(adapter))
-- 
2.20.1

