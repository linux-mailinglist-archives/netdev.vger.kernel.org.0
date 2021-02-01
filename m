Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962C730B0D1
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbhBATvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:51:47 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:51767 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232323AbhBATtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 14:49:33 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3EB3358050A;
        Mon,  1 Feb 2021 14:48:47 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 01 Feb 2021 14:48:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Z6kVOrWcFuPFHYHRKTOM4DCIFC/E9pzs1ewn1dOdbJM=; b=KqeGcIfS
        kjlahb2LHBC8DCNec7C7rfK9PkPx7nPFqgVS4VzLUoyGPdGpCFXgphnxUbUMceM0
        Gwq74RpVd/J/Lep4zwHiBR98FFvB6HCOBnbEaGOiMj0zqjWdGi8MTB+f0I5q8bTV
        eJANgSle4PnoIOyJvsXWmwHKW09ZWObtK09uNBdoXVMBlnid973kvhUFCcTVUAMM
        IyQ8dBUvwuUm527a4qYZDIwQ4oHvZxLCxIiONN0riFl1l+fLcNjkHbCF5uqq1gR0
        AVr1f/emsTrkUN5UjcwpYd1EcHqL/3uxmyYqnQbZ7zqq0CMr7mXnaaJ6EPjQTXnF
        kUJRVNpF1A6YcQ==
X-ME-Sender: <xms:H1sYYHJPohMeRmJXq8mF7SlZlwcGLOU2kqj5C4ywhY2wzxbEjiDa9Q>
    <xme:H1sYYLJbipBLMEoy6ESggfumfiqtgQdaOM-FMICj2jwJrZUfjOLtAKi_etKOHhLg-
    MexN_7wZcVwxr0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgddufedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:H1sYYPtOw7Tg1as49itQWeaEwWMp6-xRnIWw5fAw4vhvc8xsZ5DNUg>
    <xmx:H1sYYAaPZS6t6i4ipg0x2bkxbwQYFOnXePW5nO128Po9FBduK5dxVw>
    <xmx:H1sYYOYNiUmZRi6sEd_57yolg5QZf--DouUkuxcriZy9Gflrd1HTuQ>
    <xmx:H1sYYEPsn40B_5N77Os0DC-_JwYn05lfKoklWjbILXviRpxYx3yvWQ>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id B4ACB24005D;
        Mon,  1 Feb 2021 14:48:44 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        yoshfuji@linux-ipv6.org, jiri@nvidia.com, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 03/10] net: ipv4: Pass fib_rt_info as const to fib_dump_info()
Date:   Mon,  1 Feb 2021 21:47:50 +0200
Message-Id: <20210201194757.3463461-4-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201194757.3463461-1-idosch@idosch.org>
References: <20210201194757.3463461-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

fib_dump_info() does not change 'fri', so pass it as 'const'.
It will later allow us to invoke fib_dump_info() from
fib_alias_hw_flags_set().

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 net/ipv4/fib_lookup.h    | 2 +-
 net/ipv4/fib_semantics.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
index 818916b2a04d..b75db4dcbf5e 100644
--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -39,7 +39,7 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 		 struct netlink_ext_ack *extack);
 bool fib_metrics_match(struct fib_config *cfg, struct fib_info *fi);
 int fib_dump_info(struct sk_buff *skb, u32 pid, u32 seq, int event,
-		  struct fib_rt_info *fri, unsigned int flags);
+		  const struct fib_rt_info *fri, unsigned int flags);
 void rtmsg_fib(int event, __be32 key, struct fib_alias *fa, int dst_len,
 	       u32 tb_id, const struct nl_info *info, unsigned int nlm_flags);
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index b5400cec4f69..dba56fa5e2cd 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1733,7 +1733,7 @@ static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
 #endif
 
 int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
-		  struct fib_rt_info *fri, unsigned int flags)
+		  const struct fib_rt_info *fri, unsigned int flags)
 {
 	unsigned int nhs = fib_info_num_path(fri->fi);
 	struct fib_info *fi = fri->fi;
-- 
2.29.2

