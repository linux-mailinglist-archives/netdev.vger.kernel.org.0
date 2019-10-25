Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B467E554C
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 22:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbfJYUm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 16:42:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:22523 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728574AbfJYUmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 16:42:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 13:42:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,229,1569308400"; 
   d="scan'208";a="202713971"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 25 Oct 2019 13:42:44 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 6/9] i40e: allow ethtool to report SW and FW versions in recovery mode
Date:   Fri, 25 Oct 2019 13:42:39 -0700
Message-Id: <20191025204242.10535-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191025204242.10535-1-jeffrey.t.kirsher@intel.com>
References: <20191025204242.10535-1-jeffrey.t.kirsher@intel.com>
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
index 2ceb87fa853c..d24d8731bef0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -5242,6 +5242,7 @@ static int i40e_set_eee(struct net_device *netdev, struct ethtool_eee *edata)
 }
 
 static const struct ethtool_ops i40e_ethtool_recovery_mode_ops = {
+	.get_drvinfo		= i40e_get_drvinfo,
 	.set_eeprom		= i40e_set_eeprom,
 	.get_eeprom_len		= i40e_get_eeprom_len,
 	.get_eeprom		= i40e_get_eeprom,
-- 
2.21.0

