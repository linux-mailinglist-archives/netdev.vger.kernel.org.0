Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD592339C6
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 22:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgG3Uhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 16:37:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:30885 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730337AbgG3Uh1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 16:37:27 -0400
IronPort-SDR: NDLPwmUuEDvo7GrzpTb3QQYCPNCu4hYLk/0WY80N+cdDzgbU9XyUfLKd7QUSuqVgqES2BEEORm
 WnJkJg35nDcw==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="150885531"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="150885531"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 13:37:25 -0700
IronPort-SDR: QCoRIubNGQKRGPvzDzxG7Z8TjaC8t4lN0mKTbzKqaDlvDSRzJCfbP7W/J9veS9g/cXT718YSpU
 CwLNii5C6xfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="274324262"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jul 2020 13:37:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Suraj Upadhyay <usuraj35@gmail.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 06/12] e1000: Remove unnecessary usages of memset
Date:   Thu, 30 Jul 2020 13:37:14 -0700
Message-Id: <20200730203720.3843018-7-anthony.l.nguyen@intel.com>
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
Issue reported by checkpatch.pl.

Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index 0b4196d2cdd4..f976e9daa3d8 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -1356,8 +1356,8 @@ static void e1000_create_lbtest_frame(struct sk_buff *skb,
 	memset(skb->data, 0xFF, frame_size);
 	frame_size &= ~1;
 	memset(&skb->data[frame_size / 2], 0xAA, frame_size / 2 - 1);
-	memset(&skb->data[frame_size / 2 + 10], 0xBE, 1);
-	memset(&skb->data[frame_size / 2 + 12], 0xAF, 1);
+	skb->data[frame_size / 2 + 10] = 0xBE;
+	skb->data[frame_size / 2 + 12] = 0xAF;
 }
 
 static int e1000_check_lbtest_frame(const unsigned char *data,
-- 
2.26.2

