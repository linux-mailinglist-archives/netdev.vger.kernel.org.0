Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A27682D2BB
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfE2AR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:17:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:59372 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbfE2AR0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 20:17:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 May 2019 17:17:26 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2019 17:17:26 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/10] igb: mark expected switch fall-through
Date:   Tue, 28 May 2019 17:17:18 -0700
Message-Id: <20190529001726.26097-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529001726.26097-1-jeffrey.t.kirsher@intel.com>
References: <20190529001726.26097-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

This patch fixes the following warning:

drivers/net/ethernet/intel/igb/igb_main.c: In function ‘__igb_notify_dca’:
drivers/net/ethernet/intel/igb/igb_main.c:6694:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
   if (dca_add_requester(dev) == 0) {
      ^
drivers/net/ethernet/intel/igb/igb_main.c:6701:2: note: here
  case DCA_PROVIDER_REMOVE:
  ^~~~

Warning level 3 was used: -Wimplicit-fallthrough=3

Notice that, in this particular case, the code comment is modified
in accordance with what GCC is expecting to find.

This patch is part of the ongoing efforts to enable
-Wimplicit-fallthrough.

Signed-off-by: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index e5b7e638df28..fc925adbd9fa 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6696,7 +6696,7 @@ static int __igb_notify_dca(struct device *dev, void *data)
 			igb_setup_dca(adapter);
 			break;
 		}
-		/* Fall Through since DCA is disabled. */
+		/* Fall Through - since DCA is disabled. */
 	case DCA_PROVIDER_REMOVE:
 		if (adapter->flags & IGB_FLAG_DCA_ENABLED) {
 			/* without this a class_device is left
-- 
2.21.0

