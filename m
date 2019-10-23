Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45BFE226D
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 20:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389179AbfJWSYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 14:24:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:14900 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388971AbfJWSYa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 14:24:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 11:24:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,221,1569308400"; 
   d="scan'208";a="202075946"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 23 Oct 2019 11:24:28 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/11] i40e: allow ethtool to report SW and FW versions in recovery mode
Date:   Wed, 23 Oct 2019 11:24:23 -0700
Message-Id: <20191023182426.13233-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191023182426.13233-1-jeffrey.t.kirsher@intel.com>
References: <20191023182426.13233-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Piotr Kwapulinski <piotr.kwapulinski@intel.com>

Let ethtool print driver and firmware versions when NIC is in
recovery mode.  Assign i40e_get_drvinfo() operation to ethtool
recovery mode operations.  Previously ethtool did not report
driver and firmware versions when NIC was in recovery mode.

Signed-off-by: Piotr Kwapulinski <piotr.kwapulinski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 883b43ac9816..001a2fad297d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -5375,6 +5375,7 @@ static int i40e_set_eee(struct net_device *netdev, struct ethtool_eee *edata)
 }
 
 static const struct ethtool_ops i40e_ethtool_recovery_mode_ops = {
+	.get_drvinfo		= i40e_get_drvinfo,
 	.set_eeprom		= i40e_set_eeprom,
 	.get_eeprom_len		= i40e_get_eeprom_len,
 	.get_eeprom		= i40e_get_eeprom,
-- 
2.21.0

