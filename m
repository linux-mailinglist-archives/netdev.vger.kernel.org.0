Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E00947C615
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241066AbhLUSNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:13:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:10068 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241058AbhLUSNw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 13:13:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640110432; x=1671646432;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/XXf0DiVLZHUZwd4iTfpc6XurNPougGuurqOmq8CIoE=;
  b=Gml/GDCMhUXFY6D06m4GR9UPNR8TUEP9bLCS6vaLhG7BvcDE8Y/1Ow2z
   RzKSH8MIY+47Q44qNug0TlTz4GqpMvsEOJ3Gz0NXVv6hV6YrEhYwg0tg7
   G55ycWwVTLjXW2CmC4oyZIYd+/gsCPTOp4X0d0AepXe/Di6t8+YOWW8nf
   RxIP9kvAsBqK3FQRfxcnPPT/bo06JiutnGdUDRpQ4y9nhybGcrUk7Np3H
   ywqyOmfNRzs8QJk95IeDVJLGxI+NVMk92wrFY2OiR9rSh8BLHD2HLOQJP
   fKDHK7a4NkU7bPfVYaAkpQZmAClcZPNFHG4kwa/hj/M6fFmCCpzK/k0Az
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240267193"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="240267193"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 10:02:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="613557860"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 21 Dec 2021 10:02:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Karen Sornek <karen.sornek@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net-next 7/8] igbvf: Refactor trace
Date:   Tue, 21 Dec 2021 10:01:59 -0800
Message-Id: <20211221180200.3176851-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
References: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karen Sornek <karen.sornek@intel.com>

Refactoring "PF still resetting" message, because previous version looked
like a bug - it informed about changes that worked as designed but might
confuse users. Changes requested to make message more user-friendly.

Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igbvf/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 4d988da68394..b78407289741 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -1520,7 +1520,7 @@ static void igbvf_reset(struct igbvf_adapter *adapter)
 
 	/* Allow time for pending master requests to run */
 	if (mac->ops.reset_hw(hw))
-		dev_warn(&adapter->pdev->dev, "PF still resetting\n");
+		dev_info(&adapter->pdev->dev, "PF still resetting\n");
 
 	mac->ops.init_hw(hw);
 
-- 
2.31.1

