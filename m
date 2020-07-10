Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48F121B765
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgGJN6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:58:43 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:45879 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728212AbgGJN6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:58:41 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id ED13258058A;
        Fri, 10 Jul 2020 09:58:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 10 Jul 2020 09:58:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=xAw5wtejAkxmVhl45XYwlhOXAeuxG9k8SIO5DVKAuoY=; b=b1jZ3QnD
        rwgx1mLSWKO+sDgMjoBXMuMK0ATB6uyXyE6853wpaxAbposUo2pT8pCyLsZjpEPS
        mYF1z0IGyB6P8ZL9sK7IL+i2hBpd6DYnn/z5SAT14prLoMh+mKEPB3DthaX0G76+
        JY0L/6WhmjDsPveUDyXJI1Y3X+SrkrSposHHSIVYBMOqy+kSaLIqLbI7Sv+jSaeU
        be5ht9fsuJkdnVD07g2QzBDLDwn2SR9oecen0TEzLpfOUhDokozDo2WqxLYFwEUn
        E9Dyyq5y2pA7D2vendd3KPCHiLtJYGvkZXbVDYNbOV3PwTnPUuliHSZoCLn8kom8
        qvr2isPwjzWGIw==
X-ME-Sender: <xms:EHQIXxxqKMtCpsKFJMyt7k9qRvF2IB2-X7RX-h4eAhlakJDC_metQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddugdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpedutdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:EHQIXxRyUDFkn00J220ku4dIEgnquITvTsBy6ILeos2sj560ogM8DQ>
    <xmx:EHQIX7Xijr8Vvq7xf1U74Ah8pnNEzHPCxh7IFTavf14lqdYjIzrwcg>
    <xmx:EHQIXziRRClM7ocxA4a9cPi6ALflcWTaoEZg9YVoS6mIgAhwVgTfVA>
    <xmx:EHQIXwINn9Q5Lzz3TWJiHhha41byDiHyleGMUNJ9PRsBZ5Vb6Z0IEQ>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8FA1B328005D;
        Fri, 10 Jul 2020 09:58:34 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 11/13] mlxsw: spectrum_flow: Promote binder-type dispatch to spectrum.c
Date:   Fri, 10 Jul 2020 16:57:04 +0300
Message-Id: <20200710135706.601409-12-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710135706.601409-1-idosch@idosch.org>
References: <20200710135706.601409-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Two RED qevents have been introduced recently. From the point of view of a
driver, qevents are simply blocks with unusual binder types. However they
need to be handled by different logic than ACL-like flows.

Thus rename mlxsw_sp_setup_tc_block() to mlxsw_sp_setup_tc_block_clsact()
and move the binder-type dispatch from there to spectrum.c into a new
function of the original name. The new dispatcher is easier to extend with
new binder types.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     | 13 +++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |  5 +++--
 .../net/ethernet/mellanox/mlxsw/spectrum_flow.c    | 14 +++-----------
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 636dd09cbbbc..2235c4bf330d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1329,6 +1329,19 @@ static int mlxsw_sp_port_kill_vid(struct net_device *dev,
 	return 0;
 }
 
+static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
+				   struct flow_block_offload *f)
+{
+	switch (f->binder_type) {
+	case FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS:
+		return mlxsw_sp_setup_tc_block_clsact(mlxsw_sp_port, f, true);
+	case FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS:
+		return mlxsw_sp_setup_tc_block_clsact(mlxsw_sp_port, f, false);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int mlxsw_sp_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			     void *type_data)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 51047b1aa23a..ee9a19f28b97 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -767,8 +767,9 @@ mlxsw_sp_flow_block_is_mixed_bound(const struct mlxsw_sp_flow_block *block)
 struct mlxsw_sp_flow_block *mlxsw_sp_flow_block_create(struct mlxsw_sp *mlxsw_sp,
 						       struct net *net);
 void mlxsw_sp_flow_block_destroy(struct mlxsw_sp_flow_block *block);
-int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
-			    struct flow_block_offload *f);
+int mlxsw_sp_setup_tc_block_clsact(struct mlxsw_sp_port *mlxsw_sp_port,
+				   struct flow_block_offload *f,
+				   bool ingress);
 
 /* spectrum_acl.c */
 struct mlxsw_sp_acl_ruleset;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
index 421581a85cd6..0456cda33808 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
@@ -277,18 +277,10 @@ static void mlxsw_sp_setup_tc_block_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 }
 
-int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
-			    struct flow_block_offload *f)
+int mlxsw_sp_setup_tc_block_clsact(struct mlxsw_sp_port *mlxsw_sp_port,
+				   struct flow_block_offload *f,
+				   bool ingress)
 {
-	bool ingress;
-
-	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		ingress = true;
-	else if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
-		ingress = false;
-	else
-		return -EOPNOTSUPP;
-
 	f->driver_block_list = &mlxsw_sp_block_cb_list;
 
 	switch (f->command) {
-- 
2.26.2

