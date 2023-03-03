Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D5C6A9A41
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 16:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjCCPJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 10:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbjCCPJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 10:09:21 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3943C12F13
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 07:09:20 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso1478524wmo.0
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 07:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677856158;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UrrwJPkFd0S1Re+XqTQZpJcc+TxHQ0A8Rp4cbauFo18=;
        b=SsLpc76smhv7GBOH7gxTQZlcMdq3XZFrMjgr8HVzZlLg2gYzjOqYvVU+Q7dmlM4E0R
         g4ePb++hj4qcG+87fEeBH/gDOq7SZ7FY2cXQidfkr+E+DGz1Mss1cGujzM+s/+ko6Ox9
         qx13qwyG+3FNIiKZ4VQmjtjvKtGXQ1heI84WBSxssCxQXqol6Z7ourT/y2D2bh76VTNO
         5q/BZ2YQ3MYCQJPVdTQaYDxEQb+DWEYuI+em7uYQLRj0uwfRXEiTcy6Dh5h/E1+HXcOr
         AfDJdgF6+SMkOqERssBChfPAi7UEhbABqjKqnF7lVQh0x7V/mvDsm8HLOTMy7K+eOLUN
         gssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677856158;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UrrwJPkFd0S1Re+XqTQZpJcc+TxHQ0A8Rp4cbauFo18=;
        b=G7hiSvI/ZquT3EX6zzuJkJfpoL+rYY8ti+OXBQV332RxqUcKky1bxV/2XOUXOtRYau
         tAATrSMsjGx9989Te/Ovtl5D1mGjOJJp3sWhdqG9GbQppHewmqQm0FOhMyh/1oDTs0mz
         OhCA36PgMKVGyaWkssZakmxWdwi3lko+RSeDjnwKegBFLgteGUUP1XQrWmsWFu3SyGWD
         OLdAf5kd4DhJrP68QGm9JSoqp7COo59tcVzH9a8u38y+4tk5SC0j4hUc/astARrRTk51
         RlcibzgEyQGHm4gXoAxsmwut8Zt8OHZJUW89ZS+Mib3/B7wEvvRHHqbiC1eiixto4t1A
         rwTw==
X-Gm-Message-State: AO0yUKXnV293WfcuSYsq+6RjWCp0OroZbqrx5nEk8FvM33ifbAsddAxI
        LcDPBh+2gTozDD2WHhZipZFTQRNEgZKkJfikMFY=
X-Google-Smtp-Source: AK7set/AJZ7j/MVuYcsxS7J29cli2QDD2mwX9i+TusBa+IrMGuMRDK9mDHpAkO6XQ4k5Ul4aLb/ffg==
X-Received: by 2002:a05:600c:4587:b0:3ea:d611:e1 with SMTP id r7-20020a05600c458700b003ead61100e1mr1908418wmo.21.1677856158219;
        Fri, 03 Mar 2023 07:09:18 -0800 (PST)
Received: from localhost.localdomain ([2001:b07:5d37:537d:5e25:9ef5:7977:d60c])
        by smtp.gmail.com with ESMTPSA id t21-20020a1c7715000000b003e2096da239sm5965211wmi.7.2023.03.03.07.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 07:09:17 -0800 (PST)
From:   Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH v1] netdevice: use ifmap isteand of plain fields
Date:   Fri,  3 Mar 2023 16:08:18 +0100
Message-Id: <20230303150818.132386-1-vincenzopalazzodev@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clean the code by using the ifmap instead of plain fields,
and avoid code duplication.

P.S: I'm giving credit to the author of the FIXME commit.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c |  4 ++--
 include/linux/netdevice.h                  |  8 +-------
 net/core/dev_ioctl.c                       | 12 ++++++------
 net/core/rtnetlink.c                       |  6 +++---
 4 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index e1eb1de88bf9..059ff8bcdbbc 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7476,8 +7476,8 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netif_napi_add(netdev, &adapter->napi, e1000e_poll);
 	strscpy(netdev->name, pci_name(pdev), sizeof(netdev->name));
 
-	netdev->mem_start = mmio_start;
-	netdev->mem_end = mmio_start + mmio_len;
+	netdev->dev_mapping.mem_start = mmio_start;
+	netdev->dev_mapping.mem_end = mmio_start + mmio_len;
 
 	adapter->bd_number = cards_found++;
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6a14b7b11766..c5987e90a078 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2031,13 +2031,7 @@ struct net_device {
 	char			name[IFNAMSIZ];
 	struct netdev_name_node	*name_node;
 	struct dev_ifalias	__rcu *ifalias;
-	/*
-	 *	I/O specific fields
-	 *	FIXME: Merge these and struct ifmap into one
-	 */
-	unsigned long		mem_end;
-	unsigned long		mem_start;
-	unsigned long		base_addr;
+	struct ifmap dev_mapping;
 
 	/*
 	 *	Some hardware also needs these fields (state,dev_list,
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 5cdbfbf9a7dc..89469cb97e35 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -88,9 +88,9 @@ static int dev_getifmap(struct net_device *dev, struct ifreq *ifr)
 	if (in_compat_syscall()) {
 		struct compat_ifmap *cifmap = (struct compat_ifmap *)ifmap;
 
-		cifmap->mem_start = dev->mem_start;
-		cifmap->mem_end   = dev->mem_end;
-		cifmap->base_addr = dev->base_addr;
+		cifmap->mem_start = dev->dev_mapping.mem_start;
+		cifmap->mem_end   = dev->dev_mapping.mem_end;
+		cifmap->base_addr = dev->dev_mapping.base_addr;
 		cifmap->irq       = dev->irq;
 		cifmap->dma       = dev->dma;
 		cifmap->port      = dev->if_port;
@@ -98,9 +98,9 @@ static int dev_getifmap(struct net_device *dev, struct ifreq *ifr)
 		return 0;
 	}
 
-	ifmap->mem_start  = dev->mem_start;
-	ifmap->mem_end    = dev->mem_end;
-	ifmap->base_addr  = dev->base_addr;
+	ifmap->mem_start  = dev->dev_mapping.mem_start;
+	ifmap->mem_end    = dev->dev_mapping.mem_end;
+	ifmap->base_addr  = dev->dev_mapping.base_addr;
 	ifmap->irq        = dev->irq;
 	ifmap->dma        = dev->dma;
 	ifmap->port       = dev->if_port;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 5d8eb57867a9..ff8fc1bbda31 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1445,9 +1445,9 @@ static int rtnl_fill_link_ifmap(struct sk_buff *skb, struct net_device *dev)
 	struct rtnl_link_ifmap map;
 
 	memset(&map, 0, sizeof(map));
-	map.mem_start   = dev->mem_start;
-	map.mem_end     = dev->mem_end;
-	map.base_addr   = dev->base_addr;
+	map.mem_start   = dev->dev_mapping.mem_start;
+	map.mem_end     = dev->dev_mapping.mem_end;
+	map.base_addr   = dev->dev_mapping.base_addr;
 	map.irq         = dev->irq;
 	map.dma         = dev->dma;
 	map.port        = dev->if_port;
-- 
2.39.2

