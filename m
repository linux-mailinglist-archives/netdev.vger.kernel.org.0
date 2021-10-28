Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA73943E801
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 20:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhJ1SLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 14:11:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:46220 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230526AbhJ1SLL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 14:11:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10151"; a="230427778"
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="230427778"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2021 11:08:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="725849080"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 28 Oct 2021 11:08:42 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Marcin Szycik <marcin.szycik@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 6/9] ice: Add support for changing MTU on PR in switchdev mode
Date:   Thu, 28 Oct 2021 11:06:56 -0700
Message-Id: <20211028180659.218912-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211028180659.218912-1-anthony.l.nguyen@intel.com>
References: <20211028180659.218912-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcin Szycik <marcin.szycik@intel.com>

This change adds support for changing MTU on port representor in
switchdev mode, by setting the min/max MTU values on port representor
netdev. Before it was possible to change the MTU only in a limited,
default range (68-1500).

Signed-off-by: Marcin Szycik <marcin.szycik@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_repr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index c49eeea7cb67..af8e6ef5f571 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -267,6 +267,9 @@ static int ice_repr_add(struct ice_vf *vf)
 	if (err)
 		goto err_devlink;
 
+	repr->netdev->min_mtu = ETH_MIN_MTU;
+	repr->netdev->max_mtu = ICE_MAX_MTU;
+
 	err = ice_repr_reg_netdev(repr->netdev);
 	if (err)
 		goto err_netdev;
-- 
2.31.1

