Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DD02E7834
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 12:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgL3LoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 06:44:00 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:52161 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726203AbgL3Ln7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 06:43:59 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 09EF1AFB;
        Wed, 30 Dec 2020 06:43:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 30 Dec 2020 06:43:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=rqZN38f4IL3zOVZP7
        gM9ewsKQG2aBF42mdbZ/MNtjew=; b=YtUzuwWjn+GeHuf0NsnimHk+aIPFKDd4t
        Q1PWCEW2VIDV5iFfKb3NcTMd6wYojHABivICUnjYW3jhaLAziZW4df+JixGRwqWd
        QdezVQuGjoOY2Fjmn8O0H54VGOj6JXLDRIYaaZgBU6QnHs8h18jq4m2vvY1THcYc
        iSIcxRZa4rpiqaBWGsrZ++Xmd7PV0IyTAS6HnC1kB4TWn2hX5ZWjhj0VPmFPaFOD
        BOsvnjyZ0oly1n4I3DM+v5ya+XuZvFQH3TYeKLivBnsqSt9B+cSiPNdv5C9V1jWf
        kQdxNUJeexyePx2IyzqLOj3iKQcKb+74RzvJBtF/uc6xWlE68Jltg==
X-ME-Sender: <xms:0WfsX10E2A_MNA6jPovB2CVZZCn-1svCIY2t_xh__kvyhPu4GfvH6g>
    <xme:0WfsX8GFl8b8OWX1w_49sxHJs53tyNGst__RLGjhR-kzbVBvIbg35IfpSXc3UdTpg
    pLUu6a7vwnhYeM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddvfedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrgeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:0WfsX16x-1PcexL7CelFtwWhd1W0PA616dlHCiyvQVrIdSKcO6QxzA>
    <xmx:0WfsXy1lEC-YqFHSkf2v3s7z1fdWCAHG29eN_tRKfNL_m674780t8w>
    <xmx:0WfsX4FGoUzOviUoy4rdgCWuzFgYrMTDsrtSrRuP_CJbYYW5NNWY5g>
    <xmx:0WfsX9RCBBhdMY4Ix9y3Q7M-f8VFyYZbckoakgsuedF2tDWQjVg4PQ>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7D50024005D;
        Wed, 30 Dec 2020 06:43:11 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] selftests: mlxsw: Set headroom size of correct port
Date:   Wed, 30 Dec 2020 13:42:51 +0200
Message-Id: <20201230114251.394009-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The test was setting the headroom size of the wrong port. This was not
visible because of a firmware bug that canceled this bug.

Set the headroom size of the correct port, so that the test will pass
with both old and new firmware versions.

Fixes: bfa804784e32 ("selftests: mlxsw: Add a PFC test")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
index 4d900bc1f76c..5c7700212f75 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
@@ -230,7 +230,7 @@ switch_create()
 	__mlnx_qos -i $swp4 --pfc=0,1,0,0,0,0,0,0 >/dev/null
 	# PG0 will get autoconfigured to Xoff, give PG1 arbitrarily 100K, which
 	# is (-2*MTU) about 80K of delay provision.
-	__mlnx_qos -i $swp3 --buffer_size=0,$_100KB,0,0,0,0,0,0 >/dev/null
+	__mlnx_qos -i $swp4 --buffer_size=0,$_100KB,0,0,0,0,0,0 >/dev/null
 
 	# bridges
 	# -------
-- 
2.29.2

