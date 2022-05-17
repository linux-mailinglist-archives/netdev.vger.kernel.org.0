Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7DFF529D45
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244257AbiEQJFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243995AbiEQJEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:04:53 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9DFCF49695;
        Tue, 17 May 2022 02:04:52 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 85E9C20F722D; Tue, 17 May 2022 02:04:52 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 85E9C20F722D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1652778292;
        bh=3vVr+K4NDmssO2e4KeqmSxjJfA0f8IyEGQ1NHgRJqnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=VWGLLjOgzh/fPLu0QFAgzkQGCAFRydSbyjC61R28ddpA+6/K0Rc3p/eXRcxaYxmXP
         DKhJPhMaLwJV7+P3pcVgIuwK8wCbIpc6UijKKmWa3UZWfyPcTuw4wff0SLTbP5pgBA
         q03WoQKVHc2GAXfOWPyGPpc4JwwZ4GAuX0+HluAM=
From:   longli@linuxonhyperv.com
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Long Li <longli@microsoft.com>
Subject: [PATCH 09/12] net: mana: Move header files to a common location
Date:   Tue, 17 May 2022 02:04:33 -0700
Message-Id: <1652778276-2986-10-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
References: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Long Li <longli@microsoft.com>

In preparation to add MANA RDMA driver, move all the required header files
to a common location for use by both Ethernet and RDMA drivers.

Signed-off-by: Long Li <longli@microsoft.com>
---
 MAINTAINERS                                                   | 1 +
 drivers/net/ethernet/microsoft/mana/gdma_main.c               | 2 +-
 drivers/net/ethernet/microsoft/mana/hw_channel.c              | 4 ++--
 drivers/net/ethernet/microsoft/mana/mana_bpf.c                | 2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c                 | 2 +-
 drivers/net/ethernet/microsoft/mana/mana_ethtool.c            | 2 +-
 drivers/net/ethernet/microsoft/mana/shm_channel.c             | 2 +-
 {drivers/net/ethernet/microsoft => include/linux}/mana/gdma.h | 0
 .../ethernet/microsoft => include/linux}/mana/hw_channel.h    | 0
 {drivers/net/ethernet/microsoft => include/linux}/mana/mana.h | 0
 .../ethernet/microsoft => include/linux}/mana/shm_channel.h   | 0
 11 files changed, 8 insertions(+), 7 deletions(-)
 rename {drivers/net/ethernet/microsoft => include/linux}/mana/gdma.h (100%)
 rename {drivers/net/ethernet/microsoft => include/linux}/mana/hw_channel.h (100%)
 rename {drivers/net/ethernet/microsoft => include/linux}/mana/mana.h (100%)
 rename {drivers/net/ethernet/microsoft => include/linux}/mana/shm_channel.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 40fa1955ca3f..268c68dc40dc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9108,6 +9108,7 @@ F:	include/asm-generic/hyperv-tlfs.h
 F:	include/asm-generic/mshyperv.h
 F:	include/clocksource/hyperv_timer.h
 F:	include/linux/hyperv.h
+F:	include/mana/
 F:	include/uapi/linux/hyperv.h
 F:	net/vmw_vsock/hyperv_transport.c
 F:	tools/hv/
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 9c93d7a403ea..96edf8491ebd 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -6,7 +6,7 @@
 #include <linux/utsname.h>
 #include <linux/version.h>
 
-#include "mana.h"
+#include <linux/mana/mana.h>
 
 static u32 mana_gd_r32(struct gdma_context *g, u64 offset)
 {
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 078d6a5a0768..609cd714dcc0 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /* Copyright (c) 2021, Microsoft Corporation. */
 
-#include "gdma.h"
-#include "hw_channel.h"
+#include <linux/mana/gdma.h>
+#include <linux/mana/hw_channel.h>
 
 static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
 {
diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 1d2f948b5c00..7476f21e5f37 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -8,7 +8,7 @@
 #include <linux/bpf_trace.h>
 #include <net/xdp.h>
 
-#include "mana.h"
+#include <linux/mana/mana.h>
 
 void mana_xdp_tx(struct sk_buff *skb, struct net_device *ndev)
 {
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 6bb38c90b008..928b14a7ee1f 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -11,7 +11,7 @@
 #include <net/checksum.h>
 #include <net/ip6_checksum.h>
 
-#include "mana.h"
+#include <linux/mana/mana.h>
 
 static DEFINE_IDA(mana_adev_ida);
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index e13f2453eabb..c2ecb5154139 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -5,7 +5,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 
-#include "mana.h"
+#include <linux/mana/mana.h>
 
 static const struct {
 	char name[ETH_GSTRING_LEN];
diff --git a/drivers/net/ethernet/microsoft/mana/shm_channel.c b/drivers/net/ethernet/microsoft/mana/shm_channel.c
index da255da62176..161a4e6ba32a 100644
--- a/drivers/net/ethernet/microsoft/mana/shm_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/shm_channel.c
@@ -6,7 +6,7 @@
 #include <linux/io.h>
 #include <linux/mm.h>
 
-#include "shm_channel.h"
+#include <linux/mana/shm_channel.h>
 
 #define PAGE_FRAME_L48_WIDTH_BYTES 6
 #define PAGE_FRAME_L48_WIDTH_BITS (PAGE_FRAME_L48_WIDTH_BYTES * 8)
diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/include/linux/mana/gdma.h
similarity index 100%
rename from drivers/net/ethernet/microsoft/mana/gdma.h
rename to include/linux/mana/gdma.h
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.h b/include/linux/mana/hw_channel.h
similarity index 100%
rename from drivers/net/ethernet/microsoft/mana/hw_channel.h
rename to include/linux/mana/hw_channel.h
diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/include/linux/mana/mana.h
similarity index 100%
rename from drivers/net/ethernet/microsoft/mana/mana.h
rename to include/linux/mana/mana.h
diff --git a/drivers/net/ethernet/microsoft/mana/shm_channel.h b/include/linux/mana/shm_channel.h
similarity index 100%
rename from drivers/net/ethernet/microsoft/mana/shm_channel.h
rename to include/linux/mana/shm_channel.h
-- 
2.17.1

