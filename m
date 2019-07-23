Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2C671A07
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 16:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390469AbfGWOPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 10:15:22 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40271 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfGWOPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 10:15:21 -0400
Received: by mail-pg1-f193.google.com with SMTP id w10so19510531pgj.7;
        Tue, 23 Jul 2019 07:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0BVMTUlp2bfNRSz5dz/R36KBXDX+K7L4DCHaXHFSPt8=;
        b=rT8A+1VGxtNVUW8o8mxCW/NcaATjGkEd9EatcSBS5FLLGzx+Qz+YiTn9i2sFqD0/Qd
         BzLZVW3Qg+WCegTSu9Yt9i3UOJlHSP06RinE5r1jIYZX0c+6cuuajA40G+2geW54IL9t
         j9/ZPdwL1i4lND6Spz01YfoiAJxTU7eQB0UdtrgNPMv9L2dj4eJfn50gK2JmHruLQXPc
         4Su2iSG0w+6RJPNzuzEesd5TATN+zbo7iuTbExnfpfZoBS/jKCi8RMHAZfedni4mr7uz
         sWMBRJ4ZswBMrP2DCneVyhcbDHQJey8wkhWefM5+T6cLzyzOIxl9Z/FlVxf9F2c2FGvo
         JZ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0BVMTUlp2bfNRSz5dz/R36KBXDX+K7L4DCHaXHFSPt8=;
        b=NiQdd4PgkNTmI6ot9Lr5QMwltkJvWoM4c/wMPKmA+OsfcLSiedvtrtfN1BNHAuJEA4
         PcHmhJo6VfhLE8p+5maWbZYXZpZ5JutM/qbo7XZhwezxhsSp4PLJ7DPwOntG0MuDzPy4
         qLn064EwDK8mEQ7UIXzK4LSYCysC9HqZ6ywYFi7bzIgpSEKKRKNd3oZEKR5OhfjylrSv
         ExH1UdeD9YgeDL1mL2MYVy+30rDQG5bRW8hqmnP+yhkLwOVk/x+titP3InGB9uNu4huQ
         9Z8WIjGJQIVSX+zRjtOCkm9LDEyBhKxGg1kxiWCMQjoK8uwRLEpfl0HvAG+vil/gJdtG
         12RA==
X-Gm-Message-State: APjAAAW5wBcgt8Q+Xtd4HwnSbwXwXbTWCt6+J3Ob4TdwyNq82OLvJ6us
        oMwVVuhV5570ZXTpqPBR8f4=
X-Google-Smtp-Source: APXvYqzC27mCAEmKlo9WKJde4cIOGMtKbosyOsAzkOawPbrvyYJwreSVs7qNA6HSigDFyqSXBiw3Pw==
X-Received: by 2002:a17:90a:214e:: with SMTP id a72mr41119575pje.0.1563891321169;
        Tue, 23 Jul 2019 07:15:21 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id q63sm56749233pfb.81.2019.07.23.07.15.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 07:15:20 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] e1000e: Use dev_get_drvdata where possible
Date:   Tue, 23 Jul 2019 22:15:13 +0800
Message-Id: <20190723141513.5749-1-hslester96@gmail.com>
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
 drivers/net/ethernet/intel/e1000e/netdev.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index e4baa13b3cda..fa2755849c54 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6297,7 +6297,7 @@ static void e1000e_flush_lpic(struct pci_dev *pdev)
 
 static int e1000e_pm_freeze(struct device *dev)
 {
-	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
+	struct net_device *netdev = dev_get_drvdata(dev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
 	netif_device_detach(netdev);
@@ -6630,7 +6630,7 @@ static int __e1000_resume(struct pci_dev *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int e1000e_pm_thaw(struct device *dev)
 {
-	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
+	struct net_device *netdev = dev_get_drvdata(dev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
 	e1000e_set_interrupt_capability(adapter);
@@ -6679,8 +6679,7 @@ static int e1000e_pm_resume(struct device *dev)
 
 static int e1000e_pm_runtime_idle(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	u16 eee_lp;
 
-- 
2.20.1

