Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9626A9E2B
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 19:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbjCCSJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 13:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbjCCSJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 13:09:47 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE39113CB
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 10:09:45 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id j19-20020a05600c1c1300b003e9b564fae9so4522588wms.2
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 10:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677866983;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u37BUiqVfqrO2g1C0p7SHL4Rg4pvcPK9tYwoGI/HO3M=;
        b=Lsc142JPIawJVGB4o/tc8fQxZJXiiZm6kcw5EUuJFv2SRnxqVKjx0xxHpB1rbA5ajW
         mGo7wdl4JOJsr26lfudesGTFg0Uq7BmqaBOTivHBfkQpfhhdnt2goqnDYuMblgyun9Um
         DJP7JiaV4/nBNFDUECKP8YyW1tJQ8d5E7WsBb7X5tD5XBUY9WhERh2tWCXQ4w1YUqqBJ
         kf8lVkFKdh3aJprPXvDjhg4fIUhdScB5W4ujb/eJx/8iqS4n4ZooWkmx9akVehS2JXEP
         aZhqxgeSBvvjVPFbwIQLZGqfFLOmYiFY0M6AqjOL1ooZu6xHLogN+Zcr/EX+xX4CqO7h
         Wz2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677866983;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u37BUiqVfqrO2g1C0p7SHL4Rg4pvcPK9tYwoGI/HO3M=;
        b=gClqaK1hSrXiTyrH5IGqpQPBz7dYkvFVkbTmr+qkJfw/+/oQnTX6V12SSm2K/J7jJh
         Pc5RHGNQRTMmaXQThrmRgACCK4nzsXapWDNTe+FXVYRO2qxO6gQ26neU/IVz5DIVNu35
         u4VBJ7m0jQsnY+J9bzvcuuUeEjXZrVzTN8Pf7BJ00Q3y7vhKKgSWwo7O0Shq3ZkQg8Dz
         PpX80jHey5FdmnZY5N2yO6ZE0KR9PLY/ojOvg128UuyqzXXnI46Ft8GhxtCc50aLflMQ
         zzO60oKHCX/PDIuvJq4SZHJUhX1nZVuTV3vLNLuqLOPez+v4U6Vsj+sjXTTH80Nj3hTn
         QEmg==
X-Gm-Message-State: AO0yUKUKKHhVNV4ylv4TGh8uix/XTXFs2NQe2suZVK9O/effs11yCaKz
        oSMCagGAP8A2m2ZlSPTsX8HrfoA/kiz7kxbs2lY=
X-Google-Smtp-Source: AK7set/YtUomOQPXQVcIghVlu+EccsrABmhpcldiGMVUGn/xmHgV4vmNVNeGXL7y+cFbOJIJzb4A7g==
X-Received: by 2002:a05:600c:1550:b0:3e9:c2f4:8ad4 with SMTP id f16-20020a05600c155000b003e9c2f48ad4mr2413026wmg.8.1677866983577;
        Fri, 03 Mar 2023 10:09:43 -0800 (PST)
Received: from localhost.localdomain ([2001:b07:5d37:537d:5e25:9ef5:7977:d60c])
        by smtp.gmail.com with ESMTPSA id o11-20020a05600c4fcb00b003e8f0334db8sm7458083wmq.5.2023.03.03.10.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 10:09:43 -0800 (PST)
From:   Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Subject: [PATCH v2] netdevice: use ifmap instead of plain fields
Date:   Fri,  3 Mar 2023 19:09:26 +0100
Message-Id: <20230303180926.142107-1-vincenzopalazzodev@gmail.com>
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

