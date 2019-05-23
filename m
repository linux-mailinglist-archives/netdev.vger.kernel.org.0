Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D1728D3C
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388761AbfEWWeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:34:01 -0400
Received: from mga12.intel.com ([192.55.52.136]:19070 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388552AbfEWWdh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 18:33:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 15:33:36 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 23 May 2019 15:33:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/15] ice: Cleanup an unnecessary variable initialization
Date:   Thu, 23 May 2019 15:33:28 -0700
Message-Id: <20190523223340.13449-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
References: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Commit 3463688e6ced ("ice: Add more validation in ice_vc_cfg_irq_map_msg")
added an assignment of vsi making the assignment during declaration
unnecessary.

Also, cleanup the declaration and assignment of irqmap_info to not use two
lines in the variable declaration section.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index a805cbdd69be..693f5d09326a 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1807,16 +1807,16 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
 {
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct virtchnl_irq_map_info *irqmap_info =
-	    (struct virtchnl_irq_map_info *)msg;
+	struct virtchnl_irq_map_info *irqmap_info;
 	u16 vsi_id, vsi_q_id, vector_id;
 	struct virtchnl_vector_map *map;
-	struct ice_vsi *vsi = NULL;
 	struct ice_pf *pf = vf->pf;
+	struct ice_vsi *vsi;
 	unsigned long qmap;
 	u16 num_q_vectors;
 	int i;
 
+	irqmap_info = (struct virtchnl_irq_map_info *)msg;
 	num_q_vectors = irqmap_info->num_vectors - ICE_NONQ_VECS_VF;
 	vsi = pf->vsi[vf->lan_vsi_idx];
 
-- 
2.21.0

