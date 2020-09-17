Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B5026D401
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 08:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgIQG42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 02:56:28 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:60507 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726279AbgIQG4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 02:56:24 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 02:56:23 EDT
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 13692605;
        Thu, 17 Sep 2020 02:50:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 17 Sep 2020 02:50:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=YAtZMiPt3aI4blXiy8x1tva3KE4h31URv94Gc6R0kBo=; b=DUQlhtiy
        riTo2YS8xhedoW2kqNWmwFe6cA7z6Mi5asG2MoGmO6CQZmC2og4vWSz5FQUCKAQd
        3bt41FG0djTiIgyQuoAK33+KVFZKRQP0qM90AjUJD3OpFKo8Z7AI8Yjf+E8XsA5T
        jFa5XWz0WuUuoknMNxZzaCpZZz2fOS6tLUYTzT3pyPzRxU72KZxwJXzyPCJclr1j
        SMQqrAp2ditMxriDk1Pj/HI4KeJloIyofvBQLG9dIh+D38A/UzFpERt+8owCJxgy
        +vFug5ZlvPUPK542PnEJZXLNv57fM+bxri+NpBXexmDu4H+/qYEnuEeVkWQEmUA+
        4sOEOrJBf+oyJw==
X-ME-Sender: <xms:IwdjX2LyapHaR8socRhMQ9A_EQALTA2wTAo1_y4yE8Jej8nILD0c-w>
    <xme:IwdjX-Jbm7aStWJW196BnRipx_2pKWqLNa6pqn22OY_F_IC7UmPIJZm7fBPq9bCBN
    sQjr98rnzPCqU8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtdefgdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:IwdjX2uDa_xFq4YsBmRfHvNXKYQDlEuTKhMZomI4TQtrR39Qe37_9Q>
    <xmx:IwdjX7aCYEd8FSJMHOIo2eJY7_NGiRyGu4F7aN1l_1LEQeU817IvhA>
    <xmx:IwdjX9bvkqkQ0Sx9eTP2ItWxzhHnijmTBOJKINCHQaVR7A6aQXVLyw>
    <xmx:IwdjXxHCOK5iNw0tZIGwyGW7t1EAuw632YqCzUO3w33EizvduKHWZA>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id A7DBB3064684;
        Thu, 17 Sep 2020 02:50:09 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/3] mlxsw: spectrum_dcb: Implement dcbnl_setbuffer / getbuffer
Date:   Thu, 17 Sep 2020 09:49:02 +0300
Message-Id: <20200917064903.260700-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200917064903.260700-1-idosch@idosch.org>
References: <20200917064903.260700-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Add dcbnl_setbuffer, which bounces requests if a headroom is in DCB mode.
Implement dcbnl_getbuffer such that it can always be used to determine
port-buffer configuration, regardless of headroom mode.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    | 59 +++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
index d9a556dbe85e..5f92b1691360 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -592,6 +592,62 @@ static int mlxsw_sp_dcbnl_ieee_setpfc(struct net_device *dev,
 	return err;
 }
 
+static int mlxsw_sp_dcbnl_getbuffer(struct net_device *dev, struct dcbnl_buffer *buf)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	struct mlxsw_sp_hdroom *hdroom = mlxsw_sp_port->hdroom;
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	int prio;
+	int i;
+
+	buf->total_size = 0;
+
+	BUILD_BUG_ON(DCBX_MAX_BUFFERS > MLXSW_SP_PB_COUNT);
+	for (i = 0; i < MLXSW_SP_PB_COUNT; i++) {
+		u32 bytes = mlxsw_sp_cells_bytes(mlxsw_sp, hdroom->bufs.buf[i].size_cells);
+
+		if (i < DCBX_MAX_BUFFERS)
+			buf->buffer_size[i] = bytes;
+		buf->total_size += bytes;
+	}
+
+	buf->total_size += mlxsw_sp_cells_bytes(mlxsw_sp, hdroom->int_buf.size_cells);
+
+	for (prio = 0; prio < IEEE_8021Q_MAX_PRIORITIES; prio++)
+		buf->prio2buffer[prio] = hdroom->prios.prio[prio].buf_idx;
+
+	return 0;
+}
+
+static int mlxsw_sp_dcbnl_setbuffer(struct net_device *dev, struct dcbnl_buffer *buf)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_hdroom hdroom;
+	int prio;
+	int i;
+
+	hdroom = *mlxsw_sp_port->hdroom;
+
+	if (hdroom.mode != MLXSW_SP_HDROOM_MODE_TC) {
+		netdev_err(dev, "The use of dcbnl_setbuffer is only allowed if egress is configured using TC\n");
+		return -EINVAL;
+	}
+
+	for (prio = 0; prio < IEEE_8021Q_MAX_PRIORITIES; prio++)
+		hdroom.prios.prio[prio].set_buf_idx = buf->prio2buffer[prio];
+
+	BUILD_BUG_ON(DCBX_MAX_BUFFERS > MLXSW_SP_PB_COUNT);
+	for (i = 0; i < DCBX_MAX_BUFFERS; i++)
+		hdroom.bufs.buf[i].set_size_cells = mlxsw_sp_bytes_cells(mlxsw_sp,
+									 buf->buffer_size[i]);
+
+	mlxsw_sp_hdroom_prios_reset_buf_idx(&hdroom);
+	mlxsw_sp_hdroom_bufs_reset_lossiness(&hdroom);
+	mlxsw_sp_hdroom_bufs_reset_sizes(mlxsw_sp_port, &hdroom);
+	return mlxsw_sp_hdroom_configure(mlxsw_sp_port, &hdroom);
+}
+
 static const struct dcbnl_rtnl_ops mlxsw_sp_dcbnl_ops = {
 	.ieee_getets		= mlxsw_sp_dcbnl_ieee_getets,
 	.ieee_setets		= mlxsw_sp_dcbnl_ieee_setets,
@@ -604,6 +660,9 @@ static const struct dcbnl_rtnl_ops mlxsw_sp_dcbnl_ops = {
 
 	.getdcbx		= mlxsw_sp_dcbnl_getdcbx,
 	.setdcbx		= mlxsw_sp_dcbnl_setdcbx,
+
+	.dcbnl_getbuffer	= mlxsw_sp_dcbnl_getbuffer,
+	.dcbnl_setbuffer	= mlxsw_sp_dcbnl_setbuffer,
 };
 
 static int mlxsw_sp_port_ets_init(struct mlxsw_sp_port *mlxsw_sp_port)
-- 
2.26.2

