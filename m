Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9423826BD51
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgIPGgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:36:45 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:39417 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726349AbgIPGgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:36:02 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id B60DB5E2;
        Wed, 16 Sep 2020 02:36:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Sep 2020 02:36:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=WSGNvkByzeb/lbBtJj+i+6H8ytW3VRMsH7JnoI5+m30=; b=czZ0vIw0
        Qmd7wskc9Ywnpw1VI5uJ8mjVoHxn+JLc9rtitWyJT+n/ih5F3eCqYJwfwBS40R3L
        HaBvRGAksukGDWVv4hTNpQan7NOROOtAZE4QsNwSHJgUTeqBcG6+SJamXwilpFFO
        IAiNttdj9YeN5SkrF1mR0LCGxWESHW64AOwy/dblWPY/1hM44AISrB053eA22Pv4
        pmfbU11YEltuY2s/2yO1wI9tJ+qeV5Ny5I65y99jS8rwOsp4ulU14UTa6jonkKgI
        F4B/2E7WgJkmvC6u+sLTqJOgfu6ugee37UdpY+CFbCj1hkB+xzGFuPayboZwp0nM
        xDclcDWLTQDUQg==
X-ME-Sender: <xms:UbJhXzazJs-2FiX4WmVVvlOUm4Vf1IeDLJ1p6vMHIZHeGwG6N2Vyhg>
    <xme:UbJhXybuOkqh0Z82JDsv5aGMcWkgvCAnkoD4qNm2svtA-0WF3mElA6S82tCw_BzB6
    tWUniTljdKn4VM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:UbJhX1_idQOmGPCL-sY0VtxvPs1eAKKfvVqxXh_G6aT6ljTlBfbb4A>
    <xmx:UbJhX5ooCrlSEcuGIPO_YBpz7ABaIzZPSGxDi8RP8tYLRCNXpS8GDg>
    <xmx:UbJhX-ppCSASRvU3jH4iuQnuKqZqW_sOmUibylrXdtFjSaunVReURw>
    <xmx:UbJhXxUBe3XmcJ7pikPVWnaiC8X8cdJzG2QhdqfOrj9lBQWpPnU_1g>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B15B3064683;
        Wed, 16 Sep 2020 02:35:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/15] mlxsw: spectrum: Track buffer sizes in struct mlxsw_sp_hdroom
Date:   Wed, 16 Sep 2020 09:35:19 +0300
Message-Id: <20200916063528.116624-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916063528.116624-1-idosch@idosch.org>
References: <20200916063528.116624-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

So far, port buffers were always autoconfigured. When dcbnl_setbuffer
callback is implemented, it will allow the user to change the buffer size
configuration by hand. The sizes therefore need to be a configuration
parameter, not always deduced, and therefore belong to struct
mlxsw_sp_hdroom, where the configuration routine should take them from.

Update mlxsw_sp_port_headroom_set() to update these sizes. Have the
function update the sizes even for the case that a given buffer is not
used.

Additionally, change the loop iteration end to DCBX_MAX_BUFFERS instead of
IEEE_8021QAZ_MAX_TCS. The value is the same, but the semantics differ.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 19 ++++++++++++++-----
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  2 ++
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index f891ddf19dbc..533793a15621 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -671,19 +671,28 @@ int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (err)
 		return err;
 
-	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+	for (i = 0; i < DCBX_MAX_BUFFERS; i++) {
 		struct mlxsw_sp_hdroom_buf *buf = &hdroom->bufs.buf[i];
 		u16 thres_cells;
 		u16 delay_cells;
 		u16 total_cells;
 
-		if (!mlxsw_sp_hdroom_buf_is_used(hdroom, i))
-			continue;
+		if (!mlxsw_sp_hdroom_buf_is_used(hdroom, i)) {
+			thres_cells = 0;
+			delay_cells = 0;
+		} else if (buf->lossy) {
+			thres_cells = mlxsw_sp_pg_buf_threshold_get(mlxsw_sp, hdroom->mtu);
+			delay_cells = 0;
+		} else {
+			thres_cells = mlxsw_sp_pg_buf_threshold_get(mlxsw_sp, hdroom->mtu);
+			delay_cells = mlxsw_sp_hdroom_buf_delay_get(mlxsw_sp, hdroom);
+		}
 
-		thres_cells = mlxsw_sp_pg_buf_threshold_get(mlxsw_sp, hdroom->mtu);
 		thres_cells = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, thres_cells);
-		delay_cells = mlxsw_sp_hdroom_buf_delay_get(mlxsw_sp, hdroom);
 		delay_cells = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, delay_cells);
+
+		buf->thres_cells = thres_cells;
+		buf->size_cells = thres_cells + delay_cells;
 		total_cells = thres_cells + delay_cells;
 
 		taken_headroom_cells += total_cells;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 5245367d6fb2..b3c9cdcc7a06 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -447,6 +447,8 @@ struct mlxsw_sp_hdroom_prio {
 };
 
 struct mlxsw_sp_hdroom_buf {
+	u32 thres_cells;
+	u32 size_cells;
 	bool lossy;
 };
 
-- 
2.26.2

