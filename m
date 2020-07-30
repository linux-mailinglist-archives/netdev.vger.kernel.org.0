Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0CE2339BF
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 22:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbgG3Uh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 16:37:28 -0400
Received: from mga14.intel.com ([192.55.52.115]:30890 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730357AbgG3Uh1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 16:37:27 -0400
IronPort-SDR: 20hRez6Dm/q/jDC+FOekUJcdAWkFfKBT2peUcs2nhXNFYz8TXk3Q6MPYuatqk82SM0em0ONFGb
 bmwpNpVCF5+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="150885533"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="150885533"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 13:37:25 -0700
IronPort-SDR: OKMlNagBp5mbx+7Mzu9XIQjJSckgAoSk4H+fXeaSyRsUTMeo4/ijFZc9Z9ECb79+cNvTx6aZhb
 StRk/sm0aDLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="274324265"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jul 2020 13:37:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Suraj Upadhyay <usuraj35@gmail.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 07/12] e1000e: Remove unnecessary usages of memset
Date:   Thu, 30 Jul 2020 13:37:15 -0700
Message-Id: <20200730203720.3843018-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200730203720.3843018-1-anthony.l.nguyen@intel.com>
References: <20200730203720.3843018-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Suraj Upadhyay <usuraj35@gmail.com>

Replace memsets of 1 byte with simple assignments.
Issue found with checkpatch.pl

Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 64f684dc6c7a..a8fc9208382c 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -1608,8 +1608,8 @@ static void e1000_create_lbtest_frame(struct sk_buff *skb,
 	memset(skb->data, 0xFF, frame_size);
 	frame_size &= ~1;
 	memset(&skb->data[frame_size / 2], 0xAA, frame_size / 2 - 1);
-	memset(&skb->data[frame_size / 2 + 10], 0xBE, 1);
-	memset(&skb->data[frame_size / 2 + 12], 0xAF, 1);
+	skb->data[frame_size / 2 + 10] = 0xBE;
+	skb->data[frame_size / 2 + 12] = 0xAF;
 }
 
 static int e1000_check_lbtest_frame(struct sk_buff *skb,
-- 
2.26.2

