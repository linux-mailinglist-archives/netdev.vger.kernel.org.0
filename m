Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE5C344A16
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhCVQAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:00:40 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54391 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230251AbhCVQAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 12:00:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 802985C004B;
        Mon, 22 Mar 2021 12:00:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 22 Mar 2021 12:00:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=KKi2tfCx4H5KC/pXiyMWAjuhW2y1h3VCh6+R9kt4R/E=; b=GIB2UNyM
        XratdgRfX5Z5+OxXhsMDOQKj/2ecWrOzBRgsCkj5mHkHR+zU+Ql+2Vy+aWzcrEeg
        Ao7vcwwe10oF2Lx9JlEnKakYCoMupczwSounc4VXdJgByIBu+f3Pecd+ZAvieUQu
        EBll05I1IpKuek07uJ4bOIxJDBTBkRR5i9rrUVN1lYTbbVRH7bMZb3yc3ThmlNb+
        zQMbjLNhB3/481IMZ8WKhlhU8L9BkldZk7rnT5v+NCiSJ9kPxuxKE+qvpycAGh+E
        bhRRLzzvVnouKwaVHk6cZHFhqGj0LOmHU7sQw3cmr55OJX/y9QAc6JUfriCGVdOQ
        /cxT7hWRZ98XEQ==
X-ME-Sender: <xms:B79YYL-QmzVoBscDgkSbjNdKMDLQJmB1VDfi1nyyYkdajS8tVv09Ww>
    <xme:B79YYJumfiW1ESz51ag1C0Nga3aYLXeibeSLyRnzw16ffvh0CF_wpuls-FxFXiLe1
    AqzaMrxgpMXW4o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepleenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:B79YYCaz9SlGddMCrokaSR-NY1DGt0-Ekg3AyRM45oM45VeL2UpCRQ>
    <xmx:B79YYJpgvliSKAP_ssKPBnpRWzqGW2qZZt2NPW1Rltv1-oxlyqk73w>
    <xmx:B79YYH9qfC_jTigvPf9YR16RAMmD2LUkIdMGFFF5EPOYDXhdcRmDYg>
    <xmx:B79YYHre9rR9eHV4W7k-e5gdH7Sg3wq3rw4J1T0urRMpY9D-cOYuXw>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id ED9E41080066;
        Mon, 22 Mar 2021 12:00:04 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 13/14] mlxsw: spectrum_router: Encode adjacency group size ranges in an array
Date:   Mon, 22 Mar 2021 17:58:54 +0200
Message-Id: <20210322155855.3164151-14-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322155855.3164151-1-idosch@idosch.org>
References: <20210322155855.3164151-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The device supports a fixed set of adjacency group sizes. Encode these
sizes in an array, so that the next patch will be able to split it
between Spectrum-1 and Spectrum-{2,3}, which support different size
ranges.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 65 +++++++++++++------
 1 file changed, 44 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index dd3fb5ca5c32..a142d6d3e77d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3559,34 +3559,57 @@ mlxsw_sp_nexthop_fib_entries_update(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
+struct mlxsw_sp_adj_grp_size_range {
+	u16 start; /* Inclusive */
+	u16 end; /* Inclusive */
+};
+
+/* Ordered by range start value */
+static const struct mlxsw_sp_adj_grp_size_range
+mlxsw_sp_adj_grp_size_ranges[] = {
+	{ .start = 1, .end = 64 },
+	{ .start = 512, .end = 512 },
+	{ .start = 1024, .end = 1024 },
+	{ .start = 2048, .end = 2048 },
+	{ .start = 4096, .end = 4096 },
+};
+
 static void mlxsw_sp_adj_grp_size_round_up(u16 *p_adj_grp_size)
 {
-	/* Valid sizes for an adjacency group are:
-	 * 1-64, 512, 1024, 2048 and 4096.
-	 */
-	if (*p_adj_grp_size <= 64)
-		return;
-	else if (*p_adj_grp_size <= 512)
-		*p_adj_grp_size = 512;
-	else if (*p_adj_grp_size <= 1024)
-		*p_adj_grp_size = 1024;
-	else if (*p_adj_grp_size <= 2048)
-		*p_adj_grp_size = 2048;
-	else
-		*p_adj_grp_size = 4096;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_adj_grp_size_ranges); i++) {
+		const struct mlxsw_sp_adj_grp_size_range *size_range;
+
+		size_range = &mlxsw_sp_adj_grp_size_ranges[i];
+
+		if (*p_adj_grp_size >= size_range->start &&
+		    *p_adj_grp_size <= size_range->end)
+			return;
+
+		if (*p_adj_grp_size <= size_range->end) {
+			*p_adj_grp_size = size_range->end;
+			return;
+		}
+	}
 }
 
 static void mlxsw_sp_adj_grp_size_round_down(u16 *p_adj_grp_size,
 					     unsigned int alloc_size)
 {
-	if (alloc_size >= 4096)
-		*p_adj_grp_size = 4096;
-	else if (alloc_size >= 2048)
-		*p_adj_grp_size = 2048;
-	else if (alloc_size >= 1024)
-		*p_adj_grp_size = 1024;
-	else if (alloc_size >= 512)
-		*p_adj_grp_size = 512;
+	size_t arr_size = ARRAY_SIZE(mlxsw_sp_adj_grp_size_ranges);
+	int i;
+
+	for (i = arr_size - 1; i >= 0; i--) {
+		const struct mlxsw_sp_adj_grp_size_range *size_range;
+
+		size_range = &mlxsw_sp_adj_grp_size_ranges[i];
+
+		if (alloc_size >= size_range->end) {
+			*p_adj_grp_size = size_range->end;
+			return;
+		}
+	}
 }
 
 static int mlxsw_sp_fix_adj_grp_size(struct mlxsw_sp *mlxsw_sp,
-- 
2.29.2

