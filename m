Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDFF96D7684
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 10:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237377AbjDEILT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 04:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237427AbjDEILH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 04:11:07 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A138855B3
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 01:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680682248; x=1712218248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f9kZWSoj2+QokfXDMwh3Hc004hMjldoGCh4xjerbVDU=;
  b=O2NVwMxLxfRLR3JH2JU9Q8cI6c2g9TrnQmLu+p5uEJFI4pRnV75nntgp
   q6hv9YpxV4zyVs6V0ds6ygq4rcK3R0js9yHxyg3SjqBkGuz3F5wZZ6Mqv
   ty2ocRcMmctQT2f1914llY23837AVNtQCLaOhWLd8iI0D/oo7Z6D5/8rb
   lGFGjVM9zYNItmgiBHI2ZqOHBNleBgpxy+1T7bmX07ggyi1H+gQtJYi0a
   iySw7QO3PrwMq+utdDqQ8+L5ksU2Izh9meeOS4t5G9KbncGZgMPj2w0My
   0JCIDchEiOp3xJb/7uzBJLiGDiSUAIbIMaUijMQwTNMIblqZwC9I4RQrh
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="428681521"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="428681521"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 01:10:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="775961374"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="775961374"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Apr 2023 01:10:12 -0700
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, wojciech.drewek@intel.com,
        piotr.raczynski@intel.com, pmenzel@molgen.mpg.de,
        aleksander.lobakin@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v3 4/5] ice: specify field names in ice_prot_ext init
Date:   Wed,  5 Apr 2023 09:51:12 +0200
Message-Id: <20230405075113.455662-5-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405075113.455662-1-michal.swiatkowski@linux.intel.com>
References: <20230405075113.455662-1-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Anonymous initializers are now discouraged. Define ICE_PROTCOL_ENTRY
macro to rewrite anonymous initializers to named one. No functional
changes here.

Suggested-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 68 +++++++++++----------
 1 file changed, 36 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index b55cdb9a009f..8872e26d1368 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -4540,6 +4540,11 @@ ice_free_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
 	return status;
 }
 
+#define ICE_PROTOCOL_ENTRY(id, ...) {	\
+	.prot_type = id,		\
+	.offs	   = {__VA_ARGS__},	\
+}
+
 /* This is mapping table entry that maps every word within a given protocol
  * structure to the real byte offset as per the specification of that
  * protocol header.
@@ -4550,38 +4555,37 @@ ice_free_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
  * structure is added to that union.
  */
 static const struct ice_prot_ext_tbl_entry ice_prot_ext[ICE_PROTOCOL_LAST] = {
-	{ ICE_MAC_OFOS,		{ 0, 2, 4, 6, 8, 10, 12 } },
-	{ ICE_MAC_IL,		{ 0, 2, 4, 6, 8, 10, 12 } },
-	{ ICE_ETYPE_OL,		{ 0 } },
-	{ ICE_ETYPE_IL,		{ 0 } },
-	{ ICE_VLAN_OFOS,	{ 2, 0 } },
-	{ ICE_IPV4_OFOS,	{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18 } },
-	{ ICE_IPV4_IL,		{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18 } },
-	{ ICE_IPV6_OFOS,	{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24,
-				 26, 28, 30, 32, 34, 36, 38 } },
-	{ ICE_IPV6_IL,		{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24,
-				 26, 28, 30, 32, 34, 36, 38 } },
-	{ ICE_TCP_IL,		{ 0, 2 } },
-	{ ICE_UDP_OF,		{ 0, 2 } },
-	{ ICE_UDP_ILOS,		{ 0, 2 } },
-	{ ICE_VXLAN,		{ 8, 10, 12, 14 } },
-	{ ICE_GENEVE,		{ 8, 10, 12, 14 } },
-	{ ICE_NVGRE,		{ 0, 2, 4, 6 } },
-	{ ICE_GTP,		{ 8, 10, 12, 14, 16, 18, 20, 22 } },
-	{ ICE_GTP_NO_PAY,	{ 8, 10, 12, 14 } },
-	{ ICE_PPPOE,		{ 0, 2, 4, 6 } },
-	{ ICE_L2TPV3,		{ 0, 2, 4, 6, 8, 10 } },
-	{ ICE_VLAN_EX,          { 2, 0 } },
-	{ ICE_VLAN_IN,          { 2, 0 } },
-	{ ICE_HW_METADATA,	{ ICE_SOURCE_PORT_MDID_OFFSET,
-				  ICE_PTYPE_MDID_OFFSET,
-				  ICE_PACKET_LENGTH_MDID_OFFSET,
-				  ICE_SOURCE_VSI_MDID_OFFSET,
-				  ICE_PKT_VLAN_MDID_OFFSET,
-				  ICE_PKT_TUNNEL_MDID_OFFSET,
-				  ICE_PKT_TCP_MDID_OFFSET,
-				  ICE_PKT_ERROR_MDID_OFFSET,
-				}},
+	ICE_PROTOCOL_ENTRY(ICE_MAC_OFOS, 0, 2, 4, 6, 8, 10, 12),
+	ICE_PROTOCOL_ENTRY(ICE_MAC_IL, 0, 2, 4, 6, 8, 10, 12),
+	ICE_PROTOCOL_ENTRY(ICE_ETYPE_OL, 0),
+	ICE_PROTOCOL_ENTRY(ICE_ETYPE_IL, 0),
+	ICE_PROTOCOL_ENTRY(ICE_VLAN_OFOS, 2, 0),
+	ICE_PROTOCOL_ENTRY(ICE_IPV4_OFOS, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18),
+	ICE_PROTOCOL_ENTRY(ICE_IPV4_IL,	0, 2, 4, 6, 8, 10, 12, 14, 16, 18),
+	ICE_PROTOCOL_ENTRY(ICE_IPV6_OFOS, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18,
+			   20, 22, 24, 26, 28, 30, 32, 34, 36, 38),
+	ICE_PROTOCOL_ENTRY(ICE_IPV6_IL, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20,
+			   22, 24, 26, 28, 30, 32, 34, 36, 38),
+	ICE_PROTOCOL_ENTRY(ICE_TCP_IL, 0, 2),
+	ICE_PROTOCOL_ENTRY(ICE_UDP_OF, 0, 2),
+	ICE_PROTOCOL_ENTRY(ICE_UDP_ILOS, 0, 2),
+	ICE_PROTOCOL_ENTRY(ICE_VXLAN, 8, 10, 12, 14),
+	ICE_PROTOCOL_ENTRY(ICE_GENEVE, 8, 10, 12, 14),
+	ICE_PROTOCOL_ENTRY(ICE_NVGRE, 0, 2, 4, 6),
+	ICE_PROTOCOL_ENTRY(ICE_GTP, 8, 10, 12, 14, 16, 18, 20, 22),
+	ICE_PROTOCOL_ENTRY(ICE_GTP_NO_PAY, 8, 10, 12, 14),
+	ICE_PROTOCOL_ENTRY(ICE_PPPOE, 0, 2, 4, 6),
+	ICE_PROTOCOL_ENTRY(ICE_L2TPV3, 0, 2, 4, 6, 8, 10),
+	ICE_PROTOCOL_ENTRY(ICE_VLAN_EX, 2, 0),
+	ICE_PROTOCOL_ENTRY(ICE_VLAN_IN, 2, 0),
+	ICE_PROTOCOL_ENTRY(ICE_HW_METADATA, ICE_SOURCE_PORT_MDID_OFFSET,
+			   ICE_PTYPE_MDID_OFFSET,
+			   ICE_PACKET_LENGTH_MDID_OFFSET,
+			   ICE_SOURCE_VSI_MDID_OFFSET,
+			   ICE_PKT_VLAN_MDID_OFFSET,
+			   ICE_PKT_TUNNEL_MDID_OFFSET,
+			   ICE_PKT_TCP_MDID_OFFSET,
+			   ICE_PKT_ERROR_MDID_OFFSET),
 };
 
 static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
-- 
2.39.2

