Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1615EE6A7
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 22:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbiI1Ucj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 16:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbiI1Ucg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 16:32:36 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E6FCBAF4
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 13:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664397155; x=1695933155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ng4k08ntgHQmCjbL5IYMK+tFZfxR8bxPT3xHz5Keluk=;
  b=LwXZcc7joD+9k8Lp0sazENs51tnI4Dcnm729F6nD2pNLObmGmKWlsp1h
   Q7KRRZJFwx5E7n3WxUpcbXteHzLPKs4glPaJFZ4OHM0c9zGQ49SQ4jpH7
   yCiRkIEErtlhO9wQLCvfMWc9CDyWyhmW+Hw4ywFHtbVf+gdI5Qj/tFZac
   XF0/l/4byxL0gkyZ71yCeBDso83KLASAEonYN80ihn4oGDp40nX929ajA
   8bbexEbTE0cQoUsx7J/NauR6wlGK624ZhysdVXT19vXMOaaffjzySZz+m
   EmB6QABN8/Y+eFJcOm/POrwm3pDaDwGRZM/JaC2dDUalWfveuDm+FNfeT
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="299308078"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="299308078"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 13:32:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="726099959"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="726099959"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 28 Sep 2022 13:32:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/3] ice: support features on new E810T variants
Date:   Wed, 28 Sep 2022 13:32:16 -0700
Message-Id: <20220928203217.411078-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220928203217.411078-1-anthony.l.nguyen@intel.com>
References: <20220928203217.411078-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

Add new sub-device ids required for proper initialization of features
on E810T devices supported by ice driver.

Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 18 ++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_devids.h |  5 +++++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 3cbfe0bf8e74..039342a0ed15 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -182,9 +182,23 @@ bool ice_is_e810t(struct ice_hw *hw)
 {
 	switch (hw->device_id) {
 	case ICE_DEV_ID_E810C_SFP:
-		if (hw->subsystem_device_id == ICE_SUBDEV_ID_E810T ||
-		    hw->subsystem_device_id == ICE_SUBDEV_ID_E810T2)
+		switch (hw->subsystem_device_id) {
+		case ICE_SUBDEV_ID_E810T:
+		case ICE_SUBDEV_ID_E810T2:
+		case ICE_SUBDEV_ID_E810T3:
+		case ICE_SUBDEV_ID_E810T4:
+		case ICE_SUBDEV_ID_E810T6:
+		case ICE_SUBDEV_ID_E810T7:
 			return true;
+		}
+		break;
+	case ICE_DEV_ID_E810C_QSFP:
+		switch (hw->subsystem_device_id) {
+		case ICE_SUBDEV_ID_E810T2:
+		case ICE_SUBDEV_ID_E810T3:
+		case ICE_SUBDEV_ID_E810T5:
+			return true;
+		}
 		break;
 	default:
 		break;
diff --git a/drivers/net/ethernet/intel/ice/ice_devids.h b/drivers/net/ethernet/intel/ice/ice_devids.h
index b41bc3dc1745..6d560d1c74a4 100644
--- a/drivers/net/ethernet/intel/ice/ice_devids.h
+++ b/drivers/net/ethernet/intel/ice/ice_devids.h
@@ -24,6 +24,11 @@
 #define ICE_DEV_ID_E810C_SFP		0x1593
 #define ICE_SUBDEV_ID_E810T		0x000E
 #define ICE_SUBDEV_ID_E810T2		0x000F
+#define ICE_SUBDEV_ID_E810T3		0x0010
+#define ICE_SUBDEV_ID_E810T4		0x0011
+#define ICE_SUBDEV_ID_E810T5		0x0012
+#define ICE_SUBDEV_ID_E810T6		0x02E9
+#define ICE_SUBDEV_ID_E810T7		0x02EA
 /* Intel(R) Ethernet Controller E810-XXV for backplane */
 #define ICE_DEV_ID_E810_XXV_BACKPLANE	0x1599
 /* Intel(R) Ethernet Controller E810-XXV for QSFP */
-- 
2.35.1

