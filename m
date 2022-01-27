Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784C549E302
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 14:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241454AbiA0NBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 08:01:39 -0500
Received: from mga18.intel.com ([134.134.136.126]:1942 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238381AbiA0NBj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 08:01:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643288499; x=1674824499;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/WLvTKLHrBo4nY/CpzoGBhSFn0WzlDpL6Ni4Wn8/jEc=;
  b=RNwhT6Dac75c85IHSSndxUJoO26kQPdWW87WA2vKGxpli4MYZdPoMNBn
   adylkr5lI7zMadzHJL9HM+EKSrEPRA3s9b2tyoCd8CFAOMdxpOKeHNPd0
   TJDAo+pUZ8VJEbFD8qgTZvB6WIJC/Uwx4tCFfbV2diS0ekwyvE+PO0sm9
   U56CwRK3i6ExSJ3SM26SwbGBbey/pRPcGwEkUNY/W1D0hs9mlPXfqE6Hp
   7R0AKFz4uXG0C8sHTah6C+wji/JRR7lxUxeVOZHD4r/K1rQhjBsW6byyd
   kobKbf3AVE8PWvWuJ46Rnr6Jw6KTAWlyVEcWbOFJR8ijAH9XOzZVyAi6s
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="230415263"
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="230415263"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 05:01:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="495715708"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 27 Jan 2022 05:00:25 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20RD0MBl020392;
        Thu, 27 Jan 2022 13:00:22 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, osmocom-net-gprs@lists.osmocom.org
Subject: [RFC PATCH net-next v2 2/5] gtp: Add support for checking GTP device type
Date:   Thu, 27 Jan 2022 13:57:32 +0100
Message-Id: <20220127125732.125965-1-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

Add a function that checks if a net device type is GTP.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 include/net/gtp.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/net/gtp.h b/include/net/gtp.h
index 0e16ebb2a82d..ae915dd33d20 100644
--- a/include/net/gtp.h
+++ b/include/net/gtp.h
@@ -27,6 +27,12 @@ struct gtp1_header {	/* According to 3GPP TS 29.060. */
 	__be32	tid;
 } __attribute__ ((packed));
 
+static inline bool netif_is_gtp(const struct net_device *dev)
+{
+	return dev->rtnl_link_ops &&
+		!strcmp(dev->rtnl_link_ops->kind, "gtp");
+}
+
 #define GTP1_F_NPDU	0x01
 #define GTP1_F_SEQ	0x02
 #define GTP1_F_EXTHDR	0x04
-- 
2.31.1

