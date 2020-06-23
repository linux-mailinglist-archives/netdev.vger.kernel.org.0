Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B022062C8
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391680AbgFWVHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:07:52 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:33650 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391651AbgFWUfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:35:03 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05NKYxmW019548;
        Tue, 23 Jun 2020 13:35:00 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net 09/12] cxgb4: move DCB version extern to header file
Date:   Wed, 24 Jun 2020 01:51:39 +0530
Message-Id: <8e1fdae0ffd671406e9c7e154d3ca9317b9012dc.1592942138.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the DCB version string array extern to header file.

Fixes following sparse warning:
cxgb4_dcb.c:13:12: warning: symbol 'dcb_ver_array' was not declared.
Should it be static?

Fixes: ebddd97afb89 ("cxgb4: add support to display DCB info")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.h     | 3 +++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 1 -
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.h
index d3c654b9989b..80c6627fe981 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.h
@@ -136,6 +136,9 @@ static inline __u8 bitswap_1(unsigned char val)
 	       ((val & 0x02) << 5) |
 	       ((val & 0x01) << 7);
 }
+
+extern const char * const dcb_ver_array[];
+
 #define CXGB4_DCB_ENABLED true
 
 #else /* !CONFIG_CHELSIO_T4_DCB */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 828499256004..b477b8842905 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -2379,7 +2379,6 @@ static const struct file_operations rss_vf_config_debugfs_fops = {
 };
 
 #ifdef CONFIG_CHELSIO_T4_DCB
-extern char *dcb_ver_array[];
 
 /* Data Center Briging information for each port.
  */
-- 
2.24.0

