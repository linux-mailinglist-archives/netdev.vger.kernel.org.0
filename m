Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B4E4280E3
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbhJJLmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:42:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59093 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232089AbhJJLmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:42:45 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id CEADF5C00DF;
        Sun, 10 Oct 2021 07:40:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 10 Oct 2021 07:40:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=EnSHZ420iOV0QeJ4IcMcM+5LoKvEWY+EgLv3l4Yv9Ko=; b=hy7dWqgd
        k4+G9oZTRhYQkOE9vHD99Bg2hVhc/NSyhEYpzUipwaZOqA8bmCDB6rMsZMpuEbSB
        S08atoY2ZSIbQbE/RQfVfNpFdJPYyMa39sl4wP4+VtvJR071cmY3wwfNWfL7iBjy
        r5FZufRfkj4prLwniwLUlwY+BFVz+o2UJpF3z/mhYw4/OLpPnV7QnsbkO4l2MT6/
        jxXhZIh9Buieg9vtfQyVPKIhtx4MR/fqJhxdNRSdfOM/3g058YRoDUTIBTdEUjiE
        g0bT5XLCt4SytMo3XFAoNdBZBpWVom/KR4taIy0swZNlD7hOiCTkTMfs/iqXrcE0
        I2hknPthUKB1nQ==
X-ME-Sender: <xms:PtFiYX3SknN3-vgEGKvK2Myw6GjCfTFnP-YteOs1i6ALKHcCcg1HnA>
    <xme:PtFiYWEJ0tcIOMERoLbZFda_4ZMgI3OXXjkTERZSbAmqyEDK-EbjfvA6J5R73PrFi
    XcGgjCzOJ--bNQ>
X-ME-Received: <xmr:PtFiYX58p1NOo5pPCHM8RXy255Atm7aYHKCjKETnH54Rtbr98ithzZa0Yt19LbX8ZPLIK0S5PX_9kN-yozAO-2C8z9uUki9eZ3uTrFlft14t5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtgedggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:PtFiYc2hNGVkfivGkGmhW3frOipmEwXOXt0lghWx-774j4VX8XubUQ>
    <xmx:PtFiYaHWBowsxIX42zx7Aiemyi6hUE3nbzMDzaYT7LsCDNpE47vfUA>
    <xmx:PtFiYd-kEL-aSZVMDLgxgEzlq3sIL6CGZq0V_KgBnpzdWsaQt7eGgA>
    <xmx:PtFiYWijx7tF86lAmFcMenWBuTr-KSSARG5dmS7kKamdAu_NYFoYJg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 Oct 2021 07:40:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/6] mlxsw: spectrum_qdisc: Offload RED qevent mark
Date:   Sun, 10 Oct 2021 14:40:16 +0300
Message-Id: <20211010114018.190266-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211010114018.190266-1-idosch@idosch.org>
References: <20211010114018.190266-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The RED "mark" qevent can be offloaded under similar conditions as the RED
"early_drop" qevent. Therefore recognize its binding type in the
TC_SETUP_BLOCK handler and translate to the right SPAN trigger, with the
right set of supported actions.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c       |  2 ++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h       |  2 ++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c | 10 ++++++++++
 3 files changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index d366786ce0f8..3c9844f2aa1d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1035,6 +1035,8 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 		return mlxsw_sp_setup_tc_block_clsact(mlxsw_sp_port, f, false);
 	case FLOW_BLOCK_BINDER_TYPE_RED_EARLY_DROP:
 		return mlxsw_sp_setup_tc_block_qevent_early_drop(mlxsw_sp_port, f);
+	case FLOW_BLOCK_BINDER_TYPE_RED_MARK:
+		return mlxsw_sp_setup_tc_block_qevent_mark(mlxsw_sp_port, f);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 0ebbd9b04b89..aae1aed5345b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -1195,6 +1195,8 @@ int mlxsw_sp_setup_tc_fifo(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct tc_fifo_qopt_offload *p);
 int mlxsw_sp_setup_tc_block_qevent_early_drop(struct mlxsw_sp_port *mlxsw_sp_port,
 					      struct flow_block_offload *f);
+int mlxsw_sp_setup_tc_block_qevent_mark(struct mlxsw_sp_port *mlxsw_sp_port,
+					struct flow_block_offload *f);
 
 /* spectrum_fid.c */
 bool mlxsw_sp_fid_is_dummy(struct mlxsw_sp *mlxsw_sp, u16 fid_index);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 2dfc9e38307d..e367c63e72bf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -2024,6 +2024,16 @@ int mlxsw_sp_setup_tc_block_qevent_early_drop(struct mlxsw_sp_port *mlxsw_sp_por
 					      action_mask);
 }
 
+int mlxsw_sp_setup_tc_block_qevent_mark(struct mlxsw_sp_port *mlxsw_sp_port,
+					struct flow_block_offload *f)
+{
+	unsigned int action_mask = BIT(MLXSW_SP_MALL_ACTION_TYPE_MIRROR);
+
+	return mlxsw_sp_setup_tc_block_qevent(mlxsw_sp_port, f,
+					      MLXSW_SP_SPAN_TRIGGER_ECN,
+					      action_mask);
+}
+
 int mlxsw_sp_tc_qdisc_init(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	struct mlxsw_sp_qdisc_state *qdisc_state;
-- 
2.31.1

