Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3882339C4
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 22:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730492AbgG3Uhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 16:37:39 -0400
Received: from mga14.intel.com ([192.55.52.115]:30885 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730370AbgG3Uh1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 16:37:27 -0400
IronPort-SDR: q6mdIxKm3xBxNP+j4ydKjzN9MMz3svK+qPGVLCjXYCFhOYP0TrOC23ICXWIdFozbdYXeXjLRK4
 Ep7Hfy/DYQfQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="150885534"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="150885534"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 13:37:25 -0700
IronPort-SDR: HCbDONFi44ZAR9FRpU3OlOeYtp5nBQYz6fxwgu/O1x1N3Ea2ZdmJKnp3wVqLW3vAOgF3eIzz4/
 m4S0nDpf4AGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="274324269"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jul 2020 13:37:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Suraj Upadhyay <usuraj35@gmail.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 08/12] igb: Remove unnecessary usages of memset
Date:   Thu, 30 Jul 2020 13:37:16 -0700
Message-Id: <20200730203720.3843018-9-anthony.l.nguyen@intel.com>
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

Replace memsets of 1 byte with simple assignment.
Issue found with checkpatch.pl

Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index c2cf414d126b..6e8231c1ddf0 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -1782,8 +1782,8 @@ static void igb_create_lbtest_frame(struct sk_buff *skb,
 	memset(skb->data, 0xFF, frame_size);
 	frame_size /= 2;
 	memset(&skb->data[frame_size], 0xAA, frame_size - 1);
-	memset(&skb->data[frame_size + 10], 0xBE, 1);
-	memset(&skb->data[frame_size + 12], 0xAF, 1);
+	skb->data[frame_size + 10] = 0xBE;
+	skb->data[frame_size + 12] = 0xAF;
 }
 
 static int igb_check_lbtest_frame(struct igb_rx_buffer *rx_buffer,
-- 
2.26.2

