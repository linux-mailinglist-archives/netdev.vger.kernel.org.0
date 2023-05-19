Return-Path: <netdev+bounces-3959-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DF36709D46
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:05:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16D1A1C21314
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15363125C6;
	Fri, 19 May 2023 17:04:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE8D125B1
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:04:44 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309C618F
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 10:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684515868; x=1716051868;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5yreXFFleswgsT6vZyb04PQnA50+9v47AaKJGPh7uIE=;
  b=nsjwzkSi//cyW8QJUu4OL35JEzEINpNPsCZGPPGWFnwFYSJHM0X9ulFy
   dVyqU1SPVA1gL2uzxPpFKxWUXDcPUah/BadEiFyaDoawXQggGG0f26FLg
   E69mhKiQ2tbMV3ykHUEMlEpoFj0SaQAjMyt+ckGYUd1N3MzhjbA+mybX5
   wXl7txEjxUNhDvIhIfYNjaos53b7Xcj0yIbfOHU0xVfz4HIRU9EPmBxPL
   R3aHWvXFCRLM65HSY/yV/deMqVwPpObobJomviZ1XFt9P1y3sI4kdWyYD
   cVhAoVBp9CJcGFwmdJmqtwR2CSJ9UKfQl0Pm3b5uJbex5xMWYe56O5AQZ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="337017661"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="337017661"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:04:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="846950279"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="846950279"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga001.fm.intel.com with ESMTP; 19 May 2023 10:04:14 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	anthony.l.nguyen@intel.com,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Simon Horman <simon.horman@corigine.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Subject: [PATCH net-next 3/5] ice: specify field names in ice_prot_ext init
Date: Fri, 19 May 2023 10:00:16 -0700
Message-Id: <20230519170018.2820322-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230519170018.2820322-1-anthony.l.nguyen@intel.com>
References: <20230519170018.2820322-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Anonymous initializers are now discouraged. Define ICE_PROTCOL_ENTRY
macro to rewrite anonymous initializers to named one. No functional
changes here.

Suggested-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 51 +++++++++++----------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index e806dfe69b90..baa61a2b82f0 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -4540,6 +4540,11 @@ ice_free_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
 	return status;
 }
 
+#define ICE_PROTOCOL_ENTRY(id, ...) {		\
+	.prot_type	= id,			\
+	.offs		= {__VA_ARGS__},	\
+}
+
 /* This is mapping table entry that maps every word within a given protocol
  * structure to the real byte offset as per the specification of that
  * protocol header.
@@ -4550,29 +4555,29 @@ ice_free_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
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
 };
 
 static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
-- 
2.38.1


