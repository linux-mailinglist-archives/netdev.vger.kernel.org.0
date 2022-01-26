Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBDF49D207
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 19:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244303AbiAZSru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 13:47:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:63127 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244209AbiAZSrp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 13:47:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643222865; x=1674758865;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/WLvTKLHrBo4nY/CpzoGBhSFn0WzlDpL6Ni4Wn8/jEc=;
  b=FSHuBqPjHADKpCyOV0bZ+Y+8/Peqb5TmKPxRAJSnlTt52qOlfn0fOwOT
   lR0gNE+MxsrXk7PreDz4mJy9RbZZfOOCQexTId8IlHiYWAzgUA+HCT5+Q
   k4HgkQl3pUYhv8uDVr/gpjjH7mmh+q4qyCXLMohAjK+VjZDfTTeiUftqX
   epxzVIZhpYskODwqnxwMtaJta7ggUWC75UghfHvMiaqTxtWS3v4zRIy6r
   HT9R8Ia3bIkW1IT+yeAYV+MzGhrjIiC51fq2r98fxMoHqAox8UkeJsfzI
   D5P0EBfq+H1qIK5BqOZ8m43j18RXgfiPP2URrWgC/9plz8v7KZSrwA5Mj
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="244221501"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="244221501"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 10:47:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="477569148"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 26 Jan 2022 10:47:41 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20QIlVda000727;
        Wed, 26 Jan 2022 18:47:40 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com
Subject: [RFC PATCH net-next 2/5] gtp: Add support for checking GTP device type
Date:   Wed, 26 Jan 2022 19:43:55 +0100
Message-Id: <20220126184358.6505-3-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220126184358.6505-1-marcin.szycik@linux.intel.com>
References: <20220126184358.6505-1-marcin.szycik@linux.intel.com>
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

