Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E846C30E8E1
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbhBDArq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:47:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:40026 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234397AbhBDAoc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:44:32 -0500
IronPort-SDR: T61OxW5m5I4yGIkkOCu3BU7CAVcL7HyHJAAYzlPgwuHoyzRBK6os+XnpXjqzUttHfLPhIWHn6U
 Chxv+5JPmTSA==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="177638229"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="177638229"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:42:13 -0800
IronPort-SDR: i7U+1lMwQbjB5ROnAMK1XWJcEyddOk95K6bq0DiUiAYU6OZW4WqxunT5Ktu6IXHXsHRYkJ1NDc
 PsNARKbh/BCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="579687496"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2021 16:42:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 07/15] igc: Prefer strscpy over strlcpy
Date:   Wed,  3 Feb 2021 16:42:51 -0800
Message-Id: <20210204004259.3662059-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
References: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Use the strscpy method instead of strlcpy method.

See: https://lore.kernel.org/r/CAHk-=wgfRnXz0W3D37d01q3JFkr
_i_uTL=V6A6G1oUZcprmknw@mail.gmail.com/

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index a3811d7e59bc..824a6c454bca 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -150,7 +150,7 @@ static void igc_ethtool_get_drvinfo(struct net_device *netdev,
 	strscpy(drvinfo->fw_version, adapter->fw_version,
 		sizeof(drvinfo->fw_version));
 
-	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strscpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 
 	drvinfo->n_priv_flags = IGC_PRIV_FLAGS_STR_LEN;
-- 
2.26.2

