Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74ECF350A87
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 01:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhCaXHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 19:07:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:62995 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230349AbhCaXH0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:26 -0400
IronPort-SDR: ygJDBCi+Izh5ZMo55nDtrSQN9iaBwqHA/JJhnevTkBYKPX0mcmqxTWqNL/+f6nCA75uRRif/LJ
 diZz17fZc11A==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="191587981"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="191587981"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 16:07:24 -0700
IronPort-SDR: 1mB4HUQjwKyphJXy/cWARMu+t7ILql+1haPpARmyvDOgFkarEAEgRu5su8Ja34wv9SfbKRrVz0
 LuCQQsb6iYow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="610680125"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 31 Mar 2021 16:07:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 08/15] ice: correct memory allocation call
Date:   Wed, 31 Mar 2021 16:08:51 -0700
Message-Id: <20210331230858.782492-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
References: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Use *malloc() instead of *calloc() when allocating only a single object as
opposed to an array of objects.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 67c965a3f5d2..5e5683a3eb23 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -920,7 +920,7 @@ ice_create_vsi_list_map(struct ice_hw *hw, u16 *vsi_handle_arr, u16 num_vsi,
 	struct ice_vsi_list_map_info *v_map;
 	int i;
 
-	v_map = devm_kcalloc(ice_hw_to_dev(hw), 1, sizeof(*v_map), GFP_KERNEL);
+	v_map = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*v_map), GFP_KERNEL);
 	if (!v_map)
 		return NULL;
 
-- 
2.26.2

