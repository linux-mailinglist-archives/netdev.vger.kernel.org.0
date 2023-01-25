Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201B267BE36
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 22:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236685AbjAYVYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 16:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236641AbjAYVYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 16:24:39 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB4846178
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674681878; x=1706217878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fJXqR4Pfmpk3ehfxr11DaDVbOEPR6AJWSkddWiatxYw=;
  b=F+bGYbwpV9ZrKWaszLPyBXjUg+Kz1A4nC7367D7xm/oUTeHiiEjJG4Gn
   1ztvsTCtrZ05dDsi3k7IMLfp6nZ2CQWORT4Ediv6kixCpNgr5SMHAP3/G
   qB6iY6BWKlwVnQWz+tm6vgmqzHebCk9lulALonWaqWTa9ywjeS0ChofnU
   NG30dGrYsPPOaIgovY5eIuK/Nb6iQp+XNNKagef5yhUjAAE7JMtai7lnv
   MWpubp5hgtn2rLvqn98Zr8WQgCTgg4I0wN9z/57MYTGSNbWgSTpbC3Yjh
   FzFFm0crySHVhb0OQOzH5fJRnQIk3TyP62/X3LaZqpya76m8sJngVZr+J
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="328767497"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="328767497"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 13:24:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="770894112"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="770894112"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga002.fm.intel.com with ESMTP; 25 Jan 2023 13:24:35 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 3/4] virtchnl: do structure hardening
Date:   Wed, 25 Jan 2023 13:24:40 -0800
Message-Id: <20230125212441.4030014-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230125212441.4030014-1-anthony.l.nguyen@intel.com>
References: <20230125212441.4030014-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The virtchnl interface can have a bunch of "soft" defined structures
hardened by using explicit sizes for declarations, and then referring to
the enum type that uses them in a comment. None of these changes should
change any of the structure sizes.

Also, remove a duplicate line in a switch statement and let two cases
uses the same code.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 include/linux/avf/virtchnl.h | 48 ++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 2e685aa37688..5c630c818370 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -214,7 +214,9 @@ enum virtchnl_vsi_type {
 struct virtchnl_vsi_resource {
 	u16 vsi_id;
 	u16 num_queue_pairs;
-	enum virtchnl_vsi_type vsi_type;
+
+	/* see enum virtchnl_vsi_type */
+	s32 vsi_type;
 	u16 qset_handle;
 	u8 default_mac_addr[ETH_ALEN];
 };
@@ -303,7 +305,9 @@ struct virtchnl_rxq_info {
 	u8 rxdid;
 	u8 pad1[2];
 	u64 dma_ring_addr;
-	enum virtchnl_rx_hsplit rx_split_pos; /* deprecated with AVF 1.0 */
+
+	/* see enum virtchnl_rx_hsplit; deprecated with AVF 1.0 */
+	s32 rx_split_pos;
 	u32 pad2;
 };
 
@@ -955,8 +959,12 @@ enum virtchnl_flow_type {
 struct virtchnl_filter {
 	union	virtchnl_flow_spec data;
 	union	virtchnl_flow_spec mask;
-	enum	virtchnl_flow_type flow_type;
-	enum	virtchnl_action action;
+
+	/* see enum virtchnl_flow_type */
+	s32	flow_type;
+
+	/* see enum virtchnl_action */
+	s32	action;
 	u32	action_meta;
 	u8	field_flags;
 	u8	pad[3];
@@ -984,7 +992,8 @@ enum virtchnl_event_codes {
 #define PF_EVENT_SEVERITY_CERTAIN_DOOM	255
 
 struct virtchnl_pf_event {
-	enum virtchnl_event_codes event;
+	/* see enum virtchnl_event_codes */
+	s32 event;
 	union {
 		/* If the PF driver does not support the new speed reporting
 		 * capabilities then use link_event else use link_event_adv to
@@ -997,6 +1006,7 @@ struct virtchnl_pf_event {
 		struct {
 			enum virtchnl_link_speed link_speed;
 			bool link_status;
+			u8 pad[3];
 		} link_event;
 		struct {
 			/* link_speed provided in Mbps */
@@ -1006,7 +1016,7 @@ struct virtchnl_pf_event {
 		} link_event_adv;
 	} event_data;
 
-	int severity;
+	s32 severity;
 };
 
 VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_pf_event);
@@ -1097,7 +1107,7 @@ enum virtchnl_rss_algorithm {
 #define VIRTCHNL_GET_PROTO_HDR_TYPE(hdr) \
 	(((hdr)->type) >> PROTO_HDR_SHIFT)
 #define VIRTCHNL_TEST_PROTO_HDR_TYPE(hdr, val) \
-	((hdr)->type == ((val) >> PROTO_HDR_SHIFT))
+	((hdr)->type == ((s32)((val) >> PROTO_HDR_SHIFT)))
 #define VIRTCHNL_TEST_PROTO_HDR(hdr, val) \
 	(VIRTCHNL_TEST_PROTO_HDR_TYPE((hdr), (val)) && \
 	 VIRTCHNL_TEST_PROTO_HDR_FIELD((hdr), (val)))
@@ -1193,7 +1203,8 @@ enum virtchnl_proto_hdr_field {
 };
 
 struct virtchnl_proto_hdr {
-	enum virtchnl_proto_hdr_type type;
+	/* see enum virtchnl_proto_hdr_type */
+	s32 type;
 	u32 field_selector; /* a bit mask to select field for header type */
 	u8 buffer[64];
 	/**
@@ -1223,15 +1234,18 @@ VIRTCHNL_CHECK_STRUCT_LEN(2312, virtchnl_proto_hdrs);
 
 struct virtchnl_rss_cfg {
 	struct virtchnl_proto_hdrs proto_hdrs;	   /* protocol headers */
-	enum virtchnl_rss_algorithm rss_algorithm; /* RSS algorithm type */
-	u8 reserved[128];			   /* reserve for future */
+
+	/* see enum virtchnl_rss_algorithm; rss algorithm type */
+	s32 rss_algorithm;
+	u8 reserved[128];                          /* reserve for future */
 };
 
 VIRTCHNL_CHECK_STRUCT_LEN(2444, virtchnl_rss_cfg);
 
 /* action configuration for FDIR */
 struct virtchnl_filter_action {
-	enum virtchnl_action type;
+	/* see enum virtchnl_action type */
+	s32 type;
 	union {
 		/* used for queue and qgroup action */
 		struct {
@@ -1319,7 +1333,9 @@ struct virtchnl_fdir_add {
 	u16 validate_only; /* INPUT */
 	u32 flow_id;       /* OUTPUT */
 	struct virtchnl_fdir_rule rule_cfg; /* INPUT */
-	enum virtchnl_fdir_prgm_status status; /* OUTPUT */
+
+	/* see enum virtchnl_fdir_prgm_status; OUTPUT */
+	s32 status;
 };
 
 VIRTCHNL_CHECK_STRUCT_LEN(2616, virtchnl_fdir_add);
@@ -1332,7 +1348,9 @@ struct virtchnl_fdir_del {
 	u16 vsi_id;  /* INPUT */
 	u16 pad;
 	u32 flow_id; /* INPUT */
-	enum virtchnl_fdir_prgm_status status; /* OUTPUT */
+
+	/* see enum virtchnl_fdir_prgm_status; OUTPUT */
+	s32 status;
 };
 
 VIRTCHNL_CHECK_STRUCT_LEN(12, virtchnl_fdir_del);
@@ -1351,7 +1369,7 @@ virtchnl_vc_validate_vf_msg(struct virtchnl_version_info *ver, u32 v_opcode,
 			    u8 *msg, u16 msglen)
 {
 	bool err_msg_format = false;
-	int valid_len = 0;
+	u32 valid_len = 0;
 
 	/* Validate message length. */
 	switch (v_opcode) {
@@ -1492,8 +1510,6 @@ virtchnl_vc_validate_vf_msg(struct virtchnl_version_info *ver, u32 v_opcode,
 	case VIRTCHNL_OP_DISABLE_CHANNELS:
 		break;
 	case VIRTCHNL_OP_ADD_CLOUD_FILTER:
-		valid_len = sizeof(struct virtchnl_filter);
-		break;
 	case VIRTCHNL_OP_DEL_CLOUD_FILTER:
 		valid_len = sizeof(struct virtchnl_filter);
 		break;
-- 
2.38.1

