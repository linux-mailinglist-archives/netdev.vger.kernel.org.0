Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF6749E7D1
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243976AbiA0QmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:42:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:21180 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244024AbiA0QmG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 11:42:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643301726; x=1674837726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/WLvTKLHrBo4nY/CpzoGBhSFn0WzlDpL6Ni4Wn8/jEc=;
  b=JNZ/0Hg69LJjBa+nUAgtlTDAVl69H0C2sdZB5YlekSxSeSR/ezJRPpCh
   f/7nE6dUD3Fu5XR7UpmU7qBRhFSX/294cBKNFyg157uN7sVq7NdRg/d32
   Hha9FhWF2U/xCoJApsiSLEUr2ZO35S288rJjq9zbv8ibzO1XK2Laoypon
   MNRNuee0+H3krPbjJvn07Y1K/LgzmzA0/5L6WCSIgvUu+7RfTQXSO4Y/x
   Ib/AU1fRlgwlexWcjeHEjKWAszD0Zfp7rl7DXmvjtOcz9rZqfQlE9f8Ek
   5iJh+Wad/YBSclKtzWvWJyDyFmPtP8h8bCVVf3Cb2cnuOPvC8swww5eCm
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="244509402"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="244509402"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 08:42:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="521302213"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 27 Jan 2022 08:42:03 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20RGg2pp011393;
        Thu, 27 Jan 2022 16:42:02 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, osmocom-net-gprs@lists.osmocom.org
Subject: [RFC PATCH net-next v3 2/5] gtp: Add support for checking GTP device type
Date:   Thu, 27 Jan 2022 17:39:09 +0100
Message-Id: <20220127163909.374697-1-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220127163749.374283-1-marcin.szycik@linux.intel.com>
References: <20220127163749.374283-1-marcin.szycik@linux.intel.com>
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

