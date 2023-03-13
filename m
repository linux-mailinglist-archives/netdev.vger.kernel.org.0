Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4286B6B806D
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjCMS0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjCMSZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:25:25 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2CE60D7B
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678731922; x=1710267922;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8U0mrCpe8fD1qiVLWj5I+FfCIMN7JHgB56v/+/Ef34c=;
  b=nzkrnNWYhV+LtlpqtxpFvigA/EWLCJYRvcuaVmQmrY6n+ktJEUCRuUFA
   OxQl/GAKVsHw8jUcOB5t2IskcFEvaATkII/gV6r9TXppqUiXPdiYO1nwg
   FSKmnFFcTk5p5wa1WghCQTfbqTxQUrTtGOjpoN7IC3EfowdBagBqp+GX5
   U3ZJ+WwEfhTsUrXbTFzyVub4Lr/iMViPp0iR+n+e0wMiJytoDyFfnhyht
   PcKAXGJwm01+89texpirpIhhVbZzzC/caenDwRU7hRNDwpJvxNqa8NnJ1
   wQu4EcsTKSbpVsvGsOz+xYWCTtEGECmIH7pUDpWp2JqDPYYi2VzKLK7qu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="338772386"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="338772386"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 11:23:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="767809078"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="767809078"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Mar 2023 11:23:03 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 08/14] ice: declare ice_vc_process_vf_msg in ice_virtchnl.h
Date:   Mon, 13 Mar 2023 11:21:17 -0700
Message-Id: <20230313182123.483057-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
References: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_vc_process_vf_msg function is the main entry point for handling
virtchnl messages. This function is defined in ice_virtchnl.c but its
declaration is still in ice_sriov.c

The ice_sriov.c file used to contain all of the virtualization logic until
commit bf93bf791cec ("ice: introduce ice_virtchnl.c and ice_virtchnl.h")
moved the virtchnl logic to its own file.

The ice_vc_process_vf_msg function should have had its declaration moved to
ice_virtchnl.h then. Fix this.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.h    | 3 ---
 drivers/net/ethernet/intel/ice/ice_virtchnl.h | 6 ++++++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.h b/drivers/net/ethernet/intel/ice/ice_sriov.h
index 955ab810a198..1082b0691a3f 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.h
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.h
@@ -33,7 +33,6 @@ int
 ice_get_vf_cfg(struct net_device *netdev, int vf_id, struct ifla_vf_info *ivi);
 
 void ice_free_vfs(struct ice_pf *pf);
-void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event);
 void ice_restore_all_vfs_msi_state(struct pci_dev *pdev);
 bool
 ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
@@ -68,8 +67,6 @@ ice_vc_validate_pattern(struct ice_vf *vf, struct virtchnl_proto_hdrs *proto);
 static inline void ice_process_vflr_event(struct ice_pf *pf) { }
 static inline void ice_free_vfs(struct ice_pf *pf) { }
 static inline
-void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event) { }
-static inline
 void ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event) { }
 static inline void ice_print_vfs_mdd_events(struct ice_pf *pf) { }
 static inline void ice_print_vf_rx_mdd_event(struct ice_vf *vf) { }
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.h b/drivers/net/ethernet/intel/ice/ice_virtchnl.h
index b454654d7b0c..6d5af29c855e 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.h
@@ -63,6 +63,7 @@ int
 ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
 		      enum virtchnl_status_code v_retval, u8 *msg, u16 msglen);
 bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id);
+void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event);
 #else /* CONFIG_PCI_IOV */
 static inline void ice_virtchnl_set_dflt_ops(struct ice_vf *vf) { }
 static inline void ice_virtchnl_set_repr_ops(struct ice_vf *vf) { }
@@ -81,6 +82,11 @@ static inline bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id)
 {
 	return false;
 }
+
+static inline void
+ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
+{
+}
 #endif /* !CONFIG_PCI_IOV */
 
 #endif /* _ICE_VIRTCHNL_H_ */
-- 
2.38.1

