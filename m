Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0345C1DE048
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 08:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgEVG4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 02:56:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:18660 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728302AbgEVG4W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 02:56:22 -0400
IronPort-SDR: 3ZirWd//CfmyGxsBXeenoVy1FWgjy0nVbKGsUDMM/j7BnRCKS8E5Mf6TmxARHz/Eb3DKnGnnwv
 2a11O1+UrJ1Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 23:56:11 -0700
IronPort-SDR: 35kkeBJ8fEQr6LUeGtrH6bARHt+0XyyGDxtvuJM2e7+15F8wsYPNLUMUVxxfVqVIqzt6TMMZC8
 Mt/ne0N8emkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="290017777"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 21 May 2020 23:56:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/17] ice: remove unnecessary expression that is always true
Date:   Thu, 21 May 2020 23:56:04 -0700
Message-Id: <20200522065607.1680050-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
References: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

The else conditional expression is always true due to the if conditional
expression; remove it and add a comment to make it obvious still.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6ac3e5540119..fffb3433969c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -346,7 +346,8 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 				vsi->current_netdev_flags &= ~IFF_ALLMULTI;
 				goto out_promisc;
 			}
-		} else if (!(vsi->current_netdev_flags & IFF_ALLMULTI)) {
+		} else {
+			/* !(vsi->current_netdev_flags & IFF_ALLMULTI) */
 			if (vsi->vlan_ena)
 				promisc_m = ICE_MCAST_VLAN_PROMISC_BITS;
 			else
-- 
2.26.2

