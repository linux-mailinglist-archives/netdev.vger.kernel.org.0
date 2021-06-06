Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74D439CE22
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 10:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhFFI1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 04:27:09 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45791 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230173AbhFFI1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 04:27:08 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 5AA975C01BE;
        Sun,  6 Jun 2021 04:25:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 06 Jun 2021 04:25:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=LNC4xXpjlzYd/eDuyRy/5LWGY/VIxVQ/+ONtELlagz0=; b=EHKB7uKm
        ixDg7UWsmyW9nZQFk0EwIZfaSY44hSWluZftL69A9v6GTx3rc6/5+vHrlokLkqS4
        N43uU0E0A3ibg7JCHgvTCXaUAYGtdBBE4LMX3ml/x9jNZ34HMC1YEC8D1mYskbu2
        t2GKKxEVuzThecBlmd6yEnNcHszlo80XHvIogbB27r76yxMtnN0yvfVimiB68lk4
        SfmAyiYa6Lfxw0lxK36BIe6EB9T1glQPSWm0hMFZrDpnevQZkyMPa8ssNuu7/04i
        +cVzm0m1BMV3QF1hffNdZkObmMzB+M/coKH1PzlI0tjpu+coHiA63zJITPebsEUO
        juVavPTkvTVMfg==
X-ME-Sender: <xms:b4a8YAu4_zJjXkl-xdInX77itCd_Dnbbed8mq09SmEKHvlf-t-JIfQ>
    <xme:b4a8YNdaVfKXsocTFXC59Y3KACwy8snVjWHM9kV3FVTy2WW9Fu1m51fPiWZu7QclN
    XZXpO-uKlFVwa0>
X-ME-Received: <xmr:b4a8YLwviQX4l5qvrRtMgd4YBIz5t7FKBmqucWj1drWjoIL-9RXSTmO9pvYVE7aa4eBoUuS4YuAN>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedthedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:b4a8YDOnf-rl8UECrNuGNHD-wWDEbi9sjDV3ndUPFcuIS003vHxMSA>
    <xmx:b4a8YA_H2SHXxXuvZaQqQ402MOtbgcRXMnOm1NXynv0rUNSbUFaXzw>
    <xmx:b4a8YLXXSxdtt24fV10Xd-YFNtkEckRdl5Se8PGd7wTqpbrgOxSmXw>
    <xmx:b4a8YEZSLe9IW66UD0-H_svCFutDtEjpG9Jte5Q_b9e9-2MHM1N2qA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 6 Jun 2021 04:25:17 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 2/3] mlxsw: spectrum_qdisc: Pass handle, not band number to find_class()
Date:   Sun,  6 Jun 2021 11:24:31 +0300
Message-Id: <20210606082432.1463577-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210606082432.1463577-1-idosch@idosch.org>
References: <20210606082432.1463577-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

In mlxsw Qdisc offload, find_class() is an operation that yields a qdisc
offload descriptor given a parental qdisc descriptor and a class handle. In
__mlxsw_sp_qdisc_ets_graft() however, a band number is passed to that
function instead of a handle. This can lead to a trigger of a WARN_ON
with the following splat:

 WARNING: CPU: 3 PID: 808 at drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c:1356 __mlxsw_sp_qdisc_ets_graft+0x115/0x130 [mlxsw_spectrum]
 [...]
 Call Trace:
  mlxsw_sp_setup_tc_prio+0xe3/0x100 [mlxsw_spectrum]
  qdisc_offload_graft_helper+0x35/0xa0
  prio_graft+0x176/0x290 [sch_prio]
  qdisc_graft+0xb3/0x540
  tc_modify_qdisc+0x56a/0x8a0
  rtnetlink_rcv_msg+0x12c/0x370
  netlink_rcv_skb+0x49/0xf0
  netlink_unicast+0x1f6/0x2b0
  netlink_sendmsg+0x1fb/0x410
  ____sys_sendmsg+0x1f3/0x220
  ___sys_sendmsg+0x70/0xb0
  __sys_sendmsg+0x54/0xa0
  do_syscall_64+0x3a/0x70
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Since the parent handle is not passed with the offload information, compute
it from the band number and qdisc handle.

Fixes: 28052e618b04 ("mlxsw: spectrum_qdisc: Track children per qdisc")
Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 04672eb5c7f3..9958d503bf0e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -1332,6 +1332,7 @@ __mlxsw_sp_qdisc_ets_graft(struct mlxsw_sp_port *mlxsw_sp_port,
 			   u8 band, u32 child_handle)
 {
 	struct mlxsw_sp_qdisc *old_qdisc;
+	u32 parent;
 
 	if (band < mlxsw_sp_qdisc->num_classes &&
 	    mlxsw_sp_qdisc->qdiscs[band].handle == child_handle)
@@ -1352,7 +1353,9 @@ __mlxsw_sp_qdisc_ets_graft(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (old_qdisc)
 		mlxsw_sp_qdisc_destroy(mlxsw_sp_port, old_qdisc);
 
-	mlxsw_sp_qdisc = mlxsw_sp_qdisc->ops->find_class(mlxsw_sp_qdisc, band);
+	parent = TC_H_MAKE(mlxsw_sp_qdisc->handle, band + 1);
+	mlxsw_sp_qdisc = mlxsw_sp_qdisc->ops->find_class(mlxsw_sp_qdisc,
+							 parent);
 	if (!WARN_ON(!mlxsw_sp_qdisc))
 		mlxsw_sp_qdisc_destroy(mlxsw_sp_port, mlxsw_sp_qdisc);
 
-- 
2.31.1

