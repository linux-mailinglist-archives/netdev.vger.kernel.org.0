Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4071126E5E6
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 21:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgIQT6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 15:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbgIQT57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 15:57:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CA3C061223;
        Thu, 17 Sep 2020 12:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=f1R3VqxnNoImr58s5Ei6XYjbvhxFKPOcc7dIvuhbrlk=; b=PZGDndu5AS2FRze2eHvet2zuzo
        cmdlFZAEpwsPBLMOzBqyUaDNZk7t2ToNmb+1AW/mBqBvRCp3p4HrF9F83r4BQPBZdeA9K7EK5lgeE
        jWe6HJGT9ns8/h3ymoxMQimvbU4N8kjKwj88ARAW35nEOcq2jB6wBzStkn0jHWONvQEFnRMeOsgQa
        4200ap5xB0AUCC/MHgli9L7ZnBxtf3bKZUg7BLfnvk3rdmb8312swauZpsUbI/BnRhlxm0nvMJfgK
        g92/x9EGihCuiwaiaMihocH3zzHHWTmfFjUwain8psOQnfi16CP/FYBmg1NRWQsAF2qbzn/I2Bo5l
        lgIjYYSA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIzqs-0003P2-P6; Thu, 17 Sep 2020 19:45:55 +0000
To:     virtualization@lists.linux-foundation.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v2 -next] vdpa: mlx5: change Kconfig depends to fix build
 errors
Message-ID: <22a2bd60-d895-2bfb-50be-4ac3d131ed82@infradead.org>
Date:   Thu, 17 Sep 2020 12:45:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

drivers/vdpa/mlx5/ uses vhost_iotlb*() interfaces, so add a dependency
on VHOST to eliminate build errors.

ld: drivers/vdpa/mlx5/core/mr.o: in function `add_direct_chain':
mr.c:(.text+0x106): undefined reference to `vhost_iotlb_itree_first'
ld: mr.c:(.text+0x1cf): undefined reference to `vhost_iotlb_itree_next'
ld: mr.c:(.text+0x30d): undefined reference to `vhost_iotlb_itree_first'
ld: mr.c:(.text+0x3e8): undefined reference to `vhost_iotlb_itree_next'
ld: drivers/vdpa/mlx5/core/mr.o: in function `_mlx5_vdpa_create_mr':
mr.c:(.text+0x908): undefined reference to `vhost_iotlb_itree_first'
ld: mr.c:(.text+0x9e6): undefined reference to `vhost_iotlb_itree_next'
ld: drivers/vdpa/mlx5/core/mr.o: in function `mlx5_vdpa_handle_set_map':
mr.c:(.text+0xf1d): undefined reference to `vhost_iotlb_itree_first'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: netdev@vger.kernel.org
---
v2: change from select to depends (Saeed)

 drivers/vdpa/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200917.orig/drivers/vdpa/Kconfig
+++ linux-next-20200917/drivers/vdpa/Kconfig
@@ -31,7 +31,7 @@ config IFCVF
 
 config MLX5_VDPA
 	bool "MLX5 VDPA support library for ConnectX devices"
-	depends on MLX5_CORE
+	depends on VHOST && MLX5_CORE
 	default n
 	help
 	  Support library for Mellanox VDPA drivers. Provides code that is

