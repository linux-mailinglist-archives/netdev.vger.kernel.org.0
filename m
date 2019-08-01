Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEBE77E597
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 00:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731961AbfHAWZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 18:25:58 -0400
Received: from mga07.intel.com ([134.134.136.100]:14637 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731436AbfHAWZy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 18:25:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 15:25:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,335,1559545200"; 
   d="scan'208";a="324384867"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 01 Aug 2019 15:25:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/11] fm10k: reduce scope of *p local variable
Date:   Thu,  1 Aug 2019 15:25:39 -0700
Message-Id: <20190801222548.15975-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801222548.15975-1-jeffrey.t.kirsher@intel.com>
References: <20190801222548.15975-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Reduce the scope of the char *p local variable to only the block where
it is used.

This was detected by cppcheck and resolves the following style warning
produced by that tool:

[fm10k_ethtool.c:229]: (style) The scope of the variable 'p' can be
reduced.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
index 4895dd83dd08..7b9440c0aee1 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright(c) 2013 - 2018 Intel Corporation. */
+/* Copyright(c) 2013 - 2019 Intel Corporation. */
 
 #include <linux/vmalloc.h>
 
@@ -222,7 +222,6 @@ static void __fm10k_add_ethtool_stats(u64 **data, void *pointer,
 				      const unsigned int size)
 {
 	unsigned int i;
-	char *p;
 
 	if (!pointer) {
 		/* memory is not zero allocated so we have to clear it */
@@ -232,7 +231,7 @@ static void __fm10k_add_ethtool_stats(u64 **data, void *pointer,
 	}
 
 	for (i = 0; i < size; i++) {
-		p = (char *)pointer + stats[i].stat_offset;
+		char *p = (char *)pointer + stats[i].stat_offset;
 
 		switch (stats[i].sizeof_stat) {
 		case sizeof(u64):
-- 
2.21.0

