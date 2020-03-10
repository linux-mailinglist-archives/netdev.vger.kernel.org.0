Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE5C9180973
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 21:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbgCJUpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 16:45:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:27462 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbgCJUpi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 16:45:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 13:45:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,538,1574150400"; 
   d="scan'208";a="441430994"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005.fm.intel.com with ESMTP; 10 Mar 2020 13:45:37 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 06/15] ice: Display Link detected via Ethtool in safe mode
Date:   Tue, 10 Mar 2020 13:45:25 -0700
Message-Id: <20200310204534.2071912-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310204534.2071912-1-jeffrey.t.kirsher@intel.com>
References: <20200310204534.2071912-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently the "Link detected" field is not shown when the device goes
into safe mode. This is because the safe mode Ethtool ops does not set the
get_link function. Fix this by setting the safe mode Ethtool op get_link
function.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index a016ab1f7f09..419e3d488012 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3813,6 +3813,7 @@ static const struct ethtool_ops ice_ethtool_safe_mode_ops = {
 	.get_regs		= ice_get_regs,
 	.get_msglevel		= ice_get_msglevel,
 	.set_msglevel		= ice_set_msglevel,
+	.get_link		= ethtool_op_get_link,
 	.get_eeprom_len		= ice_get_eeprom_len,
 	.get_eeprom		= ice_get_eeprom,
 	.get_strings		= ice_get_strings,
-- 
2.24.1

