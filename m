Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3A4260E73
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgIHJNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:13:16 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:40663 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729026AbgIHJLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 7AA04F6F;
        Tue,  8 Sep 2020 05:11:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=NXVXvH9DUmyYV80vW5FFNLrW2Z1u8+itSr5swRE3ylM=; b=TQmpkNFp
        0VzbI2NXmu+uZTI8PegKIhqlLg2kL2ezek7Eu1xZUxCtVVj/ATCLIzxKH9E0wpZF
        1aZtwcGp9L0pDYuDAY4TA+wj4Nhq+4ccqeRiLeHERtx+uwJz3KOcd7U7JM11duX3
        oBbZEdmN31MX4s72GyM5hQRlyEoSGajV2ZkLy9nfQvBHcDSjBjUs05K74X7TU+tz
        iQoLTlYazQe+T9PeBkRnUzqmPjZn0EVY4maNLcM3WnKiNcVmK8kZu2LF+Ro91hHT
        F7mji/KvYg3OO1q6LdLAeeo+hDh9eJRN89QLv34zom+DLv0gF2F7GCA/aqoF4mcS
        oz+UMT0Y65EXqw==
X-ME-Sender: <xms:xUpXXwNbvdi1heUYFsLUcXb5oP6v0xBTlo2ezaOxhhrXmuLRNpQMjQ>
    <xme:xUpXX2-OHjHIqmpJd8v6vniCvRYBD4y72EBT7TR8AQC8fBpH_AubUezmLJfODbu_j
    SFdLf0vv-wqECc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:xUpXX3S3ruWdR9c6-wrF6bfNkYbmXRmEQbH0XdO2sYQOBgpXkb6tcA>
    <xmx:xUpXX4vACcBcpeJhOYhrMesVmkwuS4MrmLB2uhf_QAUEMj6arPqgQA>
    <xmx:xUpXX4ehi80ADsWHyYnuyB4Hx9ytoIRZ2S0CTgm6VpXZ7dK8V2XrsA>
    <xmx:xUpXXw7_P6G4j_x18Joc6SJdhwtORdwSB-3pTX2rdGL1W_xmigFbZw>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id B365F306467D;
        Tue,  8 Sep 2020 05:11:31 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 05/22] nexthop: Add nexthop notification data structures
Date:   Tue,  8 Sep 2020 12:10:20 +0300
Message-Id: <20200908091037.2709823-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908091037.2709823-1-idosch@idosch.org>
References: <20200908091037.2709823-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add data structures that will be used for nexthop replace and delete
notifications in the previously introduced nexthop notification chain.

New data structures are added instead of passing the existing nexthop
code structures directly for several reasons.

First, the existing structures encode a lot of bookkeeping information
which is irrelevant for listeners of the notification chain.

Second, the existing structures can be changed without worrying about
introducing regressions in listeners since they are not accessed
directly by them.

Third, listeners of the notification chain do not need to each parse the
relatively complex nexthop code structures. They are passing the
required information in a simplified way.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/nexthop.h | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 2e44efe5709b..0bde1aa867c0 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -109,6 +109,41 @@ enum nexthop_event_type {
 	NEXTHOP_EVENT_DEL
 };
 
+struct nh_notifier_single_info {
+	struct net_device *dev;
+	u8 gw_family;
+	union {
+		__be32 ipv4;
+		struct in6_addr ipv6;
+	};
+	u8 is_reject:1,
+	   is_fdb:1,
+	   is_encap:1;
+};
+
+struct nh_notifier_grp_entry_info {
+	u8 weight;
+	u32 id;
+	struct nh_notifier_single_info nh;
+};
+
+struct nh_notifier_grp_info {
+	u16 num_nh;
+	bool is_fdb;
+	struct nh_notifier_grp_entry_info nh_entries[];
+};
+
+struct nh_notifier_info {
+	struct net *net;
+	struct netlink_ext_ack *extack;
+	u32 id;
+	bool is_grp;
+	union {
+		struct nh_notifier_single_info *nh;
+		struct nh_notifier_grp_info *nh_grp;
+	};
+};
+
 int register_nexthop_notifier(struct net *net, struct notifier_block *nb);
 int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb);
 
-- 
2.26.2

