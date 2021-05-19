Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95E9388D98
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 14:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353358AbhESMLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 08:11:03 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38627 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353351AbhESMK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 08:10:58 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 367735C019B;
        Wed, 19 May 2021 08:09:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 May 2021 08:09:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Sy6zMrC3er3jc4OA8c1rIsd0myDChEJOAcoZ47zLAN4=; b=cxbGUBOK
        2xXF4iZmK3F84tAQXHxyudTltE5aLap9/1k4x4WMy3Du/N/06ZicZvLRpIrm575Q
        0JxRLelfADsYk6XR7HmpZiAHiUXfSIjlvhnTSVNsvQ+CWQauh5EHVP5+GhwxGZ9g
        L1UDiNOCJ8pMiVdZxwG3CKX52F0XMD977jXc0exn+lKAhaObt0I1xN2p3Lpzwla0
        rAkYBuf+tbuolzDgjzOkWdsw4otN8MerdFuR/rmDtIWXoDHfa4ACBLGljBwy6vqi
        1aa9chR33xtpSpUA9Xt6ThxU4hkskXC1BFfr3r2/brWRn+HKxbP3h10rPSuYaNdJ
        +Zaho6a7EN/xTw==
X-ME-Sender: <xms:AgClYJ8sOTnAMSa5nzyapjXCnPeWvwF8T8Hwzor0m_sn6aIYAsUNIw>
    <xme:AgClYNv1-Afcn_vwazTDkhWS5sbqP2WzqYu3Bz2NHNECvgdarRWSrdW4tl-CVnyOv
    is3sns_O7pDpt0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeiledggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrudek
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:AgClYHDIJ5lsCMx2p-XtwA4GRILIgChfyBGVp8CF8OKVwgowN0foIA>
    <xmx:AgClYNdjKCCD_5NFe_7XpyzugD2LVtjciWnCq6hjS1gWLz8uTc_CnA>
    <xmx:AgClYONwXbOQbJ3orp9rcR-SmrUznxwC0r58nzmnwn7I0dpEiKVjSA>
    <xmx:AgClYLrM-tPfPkDniJ8beLqwN0Kd454877a_rh6B9JyaqL58SmXmOw>
Received: from shredder.mellanox.com (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 19 May 2021 08:09:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/7] mlxsw: reg: Add inner packet fields to RECRv2 register
Date:   Wed, 19 May 2021 15:08:21 +0300
Message-Id: <20210519120824.302191-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519120824.302191-1-idosch@idosch.org>
References: <20210519120824.302191-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The RECRv2 register is used for setting up the router's ECMP hash
configuration. Extend it with inner packet fields to allow the ECMP hash
to be calculated based on inner flow information.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 42 +++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 4039c9d21824..f9419cc53480 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8351,6 +8351,48 @@ enum {
  */
 MLXSW_ITEM_BIT_ARRAY(reg, recr2, outer_header_fields_enable, 0x14, 0x14, 1);
 
+/* reg_recr2_inner_header_enables
+ * Bit mask where each bit enables a specific inner layer to be included in the
+ * hash calculation. Same values as reg_recr2_outer_header_enables.
+ * Access: RW
+ */
+MLXSW_ITEM_BIT_ARRAY(reg, recr2, inner_header_enables, 0x2C, 0x04, 1);
+
+enum {
+	/* Inner IPv4 Source IP */
+	MLXSW_REG_RECR2_INNER_IPV4_SIP0			= 3,
+	MLXSW_REG_RECR2_INNER_IPV4_SIP3			= 6,
+	/* Inner IPv4 Destination IP */
+	MLXSW_REG_RECR2_INNER_IPV4_DIP0			= 7,
+	MLXSW_REG_RECR2_INNER_IPV4_DIP3			= 10,
+	/* Inner IP Protocol */
+	MLXSW_REG_RECR2_INNER_IPV4_PROTOCOL		= 11,
+	/* Inner IPv6 Source IP */
+	MLXSW_REG_RECR2_INNER_IPV6_SIP0_7		= 12,
+	MLXSW_REG_RECR2_INNER_IPV6_SIP8			= 20,
+	MLXSW_REG_RECR2_INNER_IPV6_SIP15		= 27,
+	/* Inner IPv6 Destination IP */
+	MLXSW_REG_RECR2_INNER_IPV6_DIP0_7		= 28,
+	MLXSW_REG_RECR2_INNER_IPV6_DIP8			= 36,
+	MLXSW_REG_RECR2_INNER_IPV6_DIP15		= 43,
+	/* Inner IPv6 Next Header */
+	MLXSW_REG_RECR2_INNER_IPV6_NEXT_HEADER		= 44,
+	/* Inner IPv6 Flow Label */
+	MLXSW_REG_RECR2_INNER_IPV6_FLOW_LABEL		= 45,
+	/* Inner TCP/UDP Source Port */
+	MLXSW_REG_RECR2_INNER_TCP_UDP_SPORT		= 46,
+	/* Inner TCP/UDP Destination Port */
+	MLXSW_REG_RECR2_INNER_TCP_UDP_DPORT		= 47,
+
+	__MLXSW_REG_RECR2_INNER_FIELD_CNT,
+};
+
+/* reg_recr2_inner_header_fields_enable
+ * Inner packet fields to enable for ECMP hash subject to inner_header_enables.
+ * Access: RW
+ */
+MLXSW_ITEM_BIT_ARRAY(reg, recr2, inner_header_fields_enable, 0x30, 0x08, 1);
+
 static inline void mlxsw_reg_recr2_pack(char *payload, u32 seed)
 {
 	MLXSW_REG_ZERO(recr2, payload);
-- 
2.31.1

