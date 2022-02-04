Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1C24A9D2A
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 17:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376672AbiBDQyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 11:54:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:29045 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376666AbiBDQyG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 11:54:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643993646; x=1675529646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/WLvTKLHrBo4nY/CpzoGBhSFn0WzlDpL6Ni4Wn8/jEc=;
  b=k1yQjwnn3T7+OsoLPW1sEROJrA13hhkE5jgjgpdxYG3uTWU7YI32tiVX
   PvtUL0q4+JS93U2B201Bygk8e99yFeTNWM4CbMB5NWV2nQquyIGJjEvaT
   MNfLy5tP+RV7ifICRfCY9UxSRyi1CUSwwq79D8+fupSl+PfqImd/9Xzw3
   OYn+DtoZ3LVAMo10DICkcIIMz1WMZAyEiMO225jePe9AokJhKR2c7x7CP
   YGQVq4s+QiiRAXyjuX0tqSVJVJL50z6hGRKjGBfbgR//iIh7SiE4vefaZ
   aZJuTGx2Nen0VuJeHIpgkK0vQwyitL5dyCIZ6EoDHtVc2HQDSOiVi9sGk
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10247"; a="235799673"
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="235799673"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 08:54:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="524366033"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 04 Feb 2022 08:54:00 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 214GrxMh026629;
        Fri, 4 Feb 2022 16:53:59 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, osmocom-net-gprs@lists.osmocom.org
Subject: [RFC PATCH net-next v4 2/6] gtp: Add support for checking GTP device type
Date:   Fri,  4 Feb 2022 17:50:56 +0100
Message-Id: <20220204165056.10572-1-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220204164929.10356-1-marcin.szycik@linux.intel.com>
References: <20220204164929.10356-1-marcin.szycik@linux.intel.com>
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

