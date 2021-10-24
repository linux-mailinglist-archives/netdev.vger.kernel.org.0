Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE5D438C62
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 00:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhJXWhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 18:37:32 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52447 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231726AbhJXWha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 18:37:30 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 0D84E5C0767;
        Sun, 24 Oct 2021 03:19:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 24 Oct 2021 03:19:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=jyjp8ooEIEfLpIBv0MEsrf76JaiG81wZYe2oxL/5xkg=; b=PB1/kYc6
        5zf56BEGphB9NH91T7GGu8tUCy8GukmHbC2rbBbkwwLNZ2AQq/tekeEU/IS7p+v0
        A7ba84/caz/RVYITvrhT+yWNFa70UCKXuT0mYyG1FXL+cXj+9hcRXwwe6PFmzs5W
        p5vp3bw626wGKbSGSEvw68EOxmhsrVTmtSIuSakHylbi8lQDLwYsBF/qN+unkb2f
        /28c/C46uldgyz9CFxlchgfmmLE4kyilAHYATENLll0SAfDb9+Sk1taEQnsWvaVj
        Wmyt59cW8zVCarNLKMigk7zUKoGXdWCL08JSITLI1xCDz3Ska2Q8wvMd8DCAW7Fs
        r5Mh+0l2pCrQBA==
X-ME-Sender: <xms:Cwl1YfMfnF0JowHoCeExxRGd6GUTVE64fsMSUnu2E-JIqfkh5Gr-Sg>
    <xme:Cwl1YZ8IKJYstChH1sE_ywipFxYl2O4tLoviMKTm255-BbZzMfW_0Th414FbHGXfD
    BYvKTEPn_en2_k>
X-ME-Received: <xmr:Cwl1YeTdvrJEfVTVVYkce1zNlITsj_QzzhtkxAF17sA6_Z0N3lf5z1dJ-A7V8IVn_-CfZGUC5CRkYTifb54UAGNW1k2ccew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefvddgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Cwl1YTu-siGuAZ-tragxoPEOfIT1gJWN7X4RWx38B4F4gZLpas6a0Q>
    <xmx:Cwl1YXfFq7SXchwOnWN4gDTjad15ML5BAuvjV0seygNK6lY8m_RgZg>
    <xmx:Cwl1Yf2ZJv2FLI7IkhxgslTZbfX14veyER_4w7V5wPtTbmMdseRccA>
    <xmx:DAl1Ye4ntIz_icEBRDYW4EMiL2C2k5ZwD1um6-sU4fVW9ZM8VGPKjA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 24 Oct 2021 03:19:37 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/3] selftests: mlxsw: Use permanent neighbours instead of reachable ones
Date:   Sun, 24 Oct 2021 10:19:10 +0300
Message-Id: <20211024071911.1064322-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211024071911.1064322-1-idosch@idosch.org>
References: <20211024071911.1064322-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The nexthop objects tests configure dummy reachable neighbours so that
the nexthops will have a MAC address and be programmed to the device.

Since these are dummy reachable neighbours, they can be transitioned by
the kernel to a failed state if they are around for too long. This can
happen, for example, if the "TIMEOUT" variable is configured with a too
high value.

Make the tests more robust by configuring the neighbours as permanent,
so that the tests do not depend on the configured timeout value.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/rtnetlink.sh  | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh b/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
index a217f9f6775b..1075d70e8f25 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
@@ -779,7 +779,7 @@ nexthop_obj_offload_test()
 	setup_wait
 
 	ip nexthop add id 1 via 192.0.2.2 dev $swp1
-	ip neigh replace 192.0.2.2 lladdr 00:11:22:33:44:55 nud reachable \
+	ip neigh replace 192.0.2.2 lladdr 00:11:22:33:44:55 nud perm \
 		dev $swp1
 
 	busywait "$TIMEOUT" wait_for_offload \
@@ -791,7 +791,7 @@ nexthop_obj_offload_test()
 		ip nexthop show id 1
 	check_err $? "nexthop marked as offloaded after setting neigh to failed state"
 
-	ip neigh replace 192.0.2.2 lladdr 00:11:22:33:44:55 nud reachable \
+	ip neigh replace 192.0.2.2 lladdr 00:11:22:33:44:55 nud perm \
 		dev $swp1
 	busywait "$TIMEOUT" wait_for_offload \
 		ip nexthop show id 1
@@ -828,11 +828,11 @@ nexthop_obj_group_offload_test()
 	ip nexthop add id 1 via 192.0.2.2 dev $swp1
 	ip nexthop add id 2 via 2001:db8:1::2 dev $swp1
 	ip nexthop add id 10 group 1/2
-	ip neigh replace 192.0.2.2 lladdr 00:11:22:33:44:55 nud reachable \
+	ip neigh replace 192.0.2.2 lladdr 00:11:22:33:44:55 nud perm \
 		dev $swp1
-	ip neigh replace 192.0.2.3 lladdr 00:11:22:33:44:55 nud reachable \
+	ip neigh replace 192.0.2.3 lladdr 00:11:22:33:44:55 nud perm \
 		dev $swp1
-	ip neigh replace 2001:db8:1::2 lladdr 00:11:22:33:44:55 nud reachable \
+	ip neigh replace 2001:db8:1::2 lladdr 00:11:22:33:44:55 nud perm \
 		dev $swp1
 
 	busywait "$TIMEOUT" wait_for_offload \
@@ -888,11 +888,11 @@ nexthop_obj_bucket_offload_test()
 	ip nexthop add id 1 via 192.0.2.2 dev $swp1
 	ip nexthop add id 2 via 2001:db8:1::2 dev $swp1
 	ip nexthop add id 10 group 1/2 type resilient buckets 32 idle_timer 0
-	ip neigh replace 192.0.2.2 lladdr 00:11:22:33:44:55 nud reachable \
+	ip neigh replace 192.0.2.2 lladdr 00:11:22:33:44:55 nud perm \
 		dev $swp1
-	ip neigh replace 192.0.2.3 lladdr 00:11:22:33:44:55 nud reachable \
+	ip neigh replace 192.0.2.3 lladdr 00:11:22:33:44:55 nud perm \
 		dev $swp1
-	ip neigh replace 2001:db8:1::2 lladdr 00:11:22:33:44:55 nud reachable \
+	ip neigh replace 2001:db8:1::2 lladdr 00:11:22:33:44:55 nud perm \
 		dev $swp1
 
 	busywait "$TIMEOUT" wait_for_offload \
@@ -921,7 +921,7 @@ nexthop_obj_bucket_offload_test()
 	check_err $? "nexthop bucket not marked as offloaded after revalidating nexthop"
 
 	# Revalidate nexthop id 2 by changing its neighbour
-	ip neigh replace 2001:db8:1::2 lladdr 00:11:22:33:44:55 nud reachable \
+	ip neigh replace 2001:db8:1::2 lladdr 00:11:22:33:44:55 nud perm \
 		dev $swp1
 	busywait "$TIMEOUT" wait_for_offload \
 		ip nexthop bucket show nhid 2
@@ -971,9 +971,9 @@ nexthop_obj_route_offload_test()
 	setup_wait
 
 	ip nexthop add id 1 via 192.0.2.2 dev $swp1
-	ip neigh replace 192.0.2.2 lladdr 00:11:22:33:44:55 nud reachable \
+	ip neigh replace 192.0.2.2 lladdr 00:11:22:33:44:55 nud perm \
 		dev $swp1
-	ip neigh replace 192.0.2.3 lladdr 00:11:22:33:44:55 nud reachable \
+	ip neigh replace 192.0.2.3 lladdr 00:11:22:33:44:55 nud perm \
 		dev $swp1
 
 	ip route replace 198.51.100.0/24 nhid 1
-- 
2.31.1

