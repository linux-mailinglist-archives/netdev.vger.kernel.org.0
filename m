Return-Path: <netdev+bounces-10760-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84DCF730270
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:54:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3DEB1C20D7E
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03DFCDDCD;
	Wed, 14 Jun 2023 14:53:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE42DF6E
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 14:53:23 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D471BF3
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 07:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686754398; x=1718290398;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aiy2x7WzA9Zv0AUyWsyvj/l73+iJBj7g8yRezUPEHv4=;
  b=bAo14M4MXD2jnWQ0gwRC/LrE1hOB4eOlS3vqK1Cmr4oAjjdEI3e6Zgpm
   EtW6TEGFce+nxEPchZ2nwP4M7DO27jpmXVVBjZLbDvYfsi1mtkYafbk/Y
   HiLipOcF4ajlF+GGmJm6R5js+AVliA4seiKqIDr+wtpOCGOpbpDXDTFCm
   lfmJZ8yQX18bnjXAwX/x3XtfMcJV/IulOsSGcqtaKI3Z0wkfvdosl5ZB/
   iHfTaGIdRndGR/p+lAbIlEhWlrdAEFrONlJn2lU36yf66kA2bYBXdFPF/
   TYfUQEer2V5ACcjdMn5m5/6RUeD6LwTy0mRTAF7Rj8AggYn3g7L8yDhdw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="387040583"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="387040583"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 07:53:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="782114900"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="782114900"
Received: from pgardocx-mobl1.igk.intel.com ([10.237.95.41])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 07:53:16 -0700
From: Piotr Gardocki <piotrx.gardocki@intel.com>
To: netdev@vger.kernel.org
Cc: piotrx.gardocki@intel.com,
	intel-wired-lan@lists.osuosl.org,
	przemyslaw.kitszel@intel.com,
	michal.swiatkowski@linux.intel.com,
	pmenzel@molgen.mpg.de,
	kuba@kernel.org,
	maciej.fijalkowski@intel.com,
	anthony.l.nguyen@intel.com,
	simon.horman@corigine.com,
	aleksander.lobakin@intel.com
Subject: [PATCH net-next v3 3/3] ice: remove unnecessary check for old MAC == new MAC
Date: Wed, 14 Jun 2023 16:53:02 +0200
Message-Id: <20230614145302.902301-4-piotrx.gardocki@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230614145302.902301-1-piotrx.gardocki@intel.com>
References: <20230614145302.902301-1-piotrx.gardocki@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The check has been moved to core. The ndo_set_mac_address callback
is not being called with new MAC address equal to the old one anymore.

Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index caafb12d9cc7..f0ba896a3f46 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5624,11 +5624,6 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 	if (!is_valid_ether_addr(mac))
 		return -EADDRNOTAVAIL;
 
-	if (ether_addr_equal(netdev->dev_addr, mac)) {
-		netdev_dbg(netdev, "already using mac %pM\n", mac);
-		return 0;
-	}
-
 	if (test_bit(ICE_DOWN, pf->state) ||
 	    ice_is_reset_in_progress(pf->state)) {
 		netdev_err(netdev, "can't set mac %pM. device not ready\n",
-- 
2.34.1


