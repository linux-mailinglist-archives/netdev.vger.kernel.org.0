Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067C930B0CE
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbhBATvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:51:25 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:50951 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232426AbhBATth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 14:49:37 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2BF3158050B;
        Mon,  1 Feb 2021 14:48:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 01 Feb 2021 14:48:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=GzJH4P7vNB9FbU509W/3WGfrgVzb/cfyCwSrKTqlnek=; b=qF1mfjB9
        4L4O0bCKTzips/s3Wdp3NhNhg15kExUudrw9rHBGED9RS78Tr7GsOp87baZtbAIv
        rfodqLARWLiLjQStVWAOdVraa3t9B9yLXujLcvnMQxav/HRCUwxkoLDlfGD5hzEq
        I2qIGEOzqyH1GMu1iR4711NWvTH+KZ+EIiuDM4+4VgEFcYojJRboqZHoxiYmhx2D
        CfErYf5nUfbXs7Xsxp6bVHcRv77t2tzNifRLLz8sN4Vg7vpQhUs6RQb5QJsz4DRt
        kX9csp/JJqCV3INQzMTN8X9vk7DnZw7zWKOq+EpUpdEdpgpdIdjrkDDTx2uebPoA
        HZQ6mkAfvlqBoQ==
X-ME-Sender: <xms:IlsYYODjAwjqklcJ3jwIE7DmU97BbSjS5MSkBOMZJhCogIZaa9r1rQ>
    <xme:IlsYYIhi2YKrKElqbwwUGmlyppuOn7N1anMm8UFNo3ma_KM647_XOjwsSpE5QKeQ_
    v9uNFSwOfrwmys>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgddufedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:IlsYYBl81cHH3LRw44bXBZWnZED891_VPnnO64KKumXmWSONLLOYtQ>
    <xmx:IlsYYMy4U6_PYuWAqsnFEGavaLAqK5zTtb93kqHjtxpRAyj-cItSwg>
    <xmx:IlsYYDS7AF8Ks4NNlOPZ8rZUjI2-w3F4jQO6IBjZr6OirpgBDkZIZg>
    <xmx:IlsYYOGcL7Uw9wd4isk4OuWHHC79dINgPx5Nekp5rWIKrg04s7yhtQ>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7256024005C;
        Mon,  1 Feb 2021 14:48:47 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        yoshfuji@linux-ipv6.org, jiri@nvidia.com, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 04/10] net: ipv4: Publish fib_nlmsg_size()
Date:   Mon,  1 Feb 2021 21:47:51 +0200
Message-Id: <20210201194757.3463461-5-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201194757.3463461-1-idosch@idosch.org>
References: <20210201194757.3463461-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Publish fib_nlmsg_size() to allow it to be used later on from
fib_alias_hw_flags_set().

Remove the inline keyword since it shouldn't be used inside C files.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 net/ipv4/fib_lookup.h    | 1 +
 net/ipv4/fib_semantics.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
index b75db4dcbf5e..aff454ef0fa3 100644
--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -42,6 +42,7 @@ int fib_dump_info(struct sk_buff *skb, u32 pid, u32 seq, int event,
 		  const struct fib_rt_info *fri, unsigned int flags);
 void rtmsg_fib(int event, __be32 key, struct fib_alias *fa, int dst_len,
 	       u32 tb_id, const struct nl_info *info, unsigned int nlm_flags);
+size_t fib_nlmsg_size(struct fib_info *fi);
 
 static inline void fib_result_assign(struct fib_result *res,
 				     struct fib_info *fi)
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index dba56fa5e2cd..4c38facf91c0 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -452,7 +452,7 @@ int ip_fib_check_default(__be32 gw, struct net_device *dev)
 	return -1;
 }
 
-static inline size_t fib_nlmsg_size(struct fib_info *fi)
+size_t fib_nlmsg_size(struct fib_info *fi)
 {
 	size_t payload = NLMSG_ALIGN(sizeof(struct rtmsg))
 			 + nla_total_size(4) /* RTA_TABLE */
-- 
2.29.2

