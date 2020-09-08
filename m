Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0ADC260E6B
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgIHJMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:12:49 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:46411 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729104AbgIHJLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:50 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 0A5F9E90;
        Tue,  8 Sep 2020 05:11:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=grpvxtswKn1FRucAYoFGKepjKc+1h1nkS6I1l9lTlMk=; b=pkdSa9PE
        PHtBXWuZ5BLJ4O/Gr4NO0mcbJZUmVDeNfuw59U/pVf9j1g3xDiYMrqMrwdkaDHbH
        Ejmz9pR4UC/XFw/5Mbm2MkrOx/6xNlqOXlkbeLI69NVlTUlQTgM0RCKi66VcUfWn
        GnU92A9bT4S4gghw4CrgjXWZG2ndYG8PnAiwMC0YvKOGaUfR5RAOsTeGe4KMyTiU
        WWQtuUQ6trgRAg9cAVbB7Bv1A97WU8ENMdmqArUBVqmD9V0FK8GPxvxPLVeylz7z
        BLGjfVp3p8M3ih9rG3u2VovIpti+KNDSWVP/iq1Qrxoxi7v0BT16gPSyzqKe+Raw
        zI4RaNegIGXmDg==
X-ME-Sender: <xms:1UpXX7wxe9DXieQlTopM3knNy1W3WDtXfAvC3tu5BHfJ5XVLB2TJBA>
    <xme:1UpXXzQxaZx2XL2wFBMy8o-S4ScMF8G21i3VFnkeCQMfl-_3n4Sv79SSJ0lg72XEC
    wINInUFUq4S32Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepudefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:1UpXX1UDT4ZoN1gm_UIDdQk2E4c4_IcJQtH7-mOcMaYxtxWP9w8cJQ>
    <xmx:1UpXX1g14jnyWEX2kyAMpkauoVaEA59W0dCZiTAVyRTBHAEmpqx59w>
    <xmx:1UpXX9CKoZqLfqPcKBYkdLRrLgM_BRnCL_ZkrZMaswS0tPe6YiXJUw>
    <xmx:1UpXX8M24YElI_edEzaZzhwU4QUv4p5hgAyg4TikFpc7N6UABj1-Jw>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id 437BD3064605;
        Tue,  8 Sep 2020 05:11:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 16/22] nexthop: Pass extack to register_nexthop_notifier()
Date:   Tue,  8 Sep 2020 12:10:31 +0300
Message-Id: <20200908091037.2709823-17-idosch@idosch.org>
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

This will be used by the next patch which extends the function to replay
all the existing nexthops to the notifier block being registered.

Device drivers will be able to pass extack to the function since it is
passed to them upon reload from devlink.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/vxlan.c   | 3 ++-
 include/net/nexthop.h | 3 ++-
 net/ipv4/nexthop.c    | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 29deedee6ef4..a850b39dd432 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -4717,7 +4717,8 @@ static __net_init int vxlan_init_net(struct net *net)
 	for (h = 0; h < PORT_HASH_SIZE; ++h)
 		INIT_HLIST_HEAD(&vn->sock_list[h]);
 
-	return register_nexthop_notifier(net, &vxlan_nexthop_notifier_block);
+	return register_nexthop_notifier(net, &vxlan_nexthop_notifier_block,
+					 NULL);
 }
 
 static void vxlan_destroy_tunnels(struct net *net, struct list_head *head)
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 6431ff8cdb89..c2dd20946825 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -145,7 +145,8 @@ struct nh_notifier_info {
 	};
 };
 
-int register_nexthop_notifier(struct net *net, struct notifier_block *nb);
+int register_nexthop_notifier(struct net *net, struct notifier_block *nb,
+			      struct netlink_ext_ack *extack);
 int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb);
 void nexthop_hw_flags_set(struct net *net, u32 id, bool offload, bool trap);
 
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 33f611bbce1f..b40c343ca969 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2116,7 +2116,8 @@ static struct notifier_block nh_netdev_notifier = {
 	.notifier_call = nh_netdev_event,
 };
 
-int register_nexthop_notifier(struct net *net, struct notifier_block *nb)
+int register_nexthop_notifier(struct net *net, struct notifier_block *nb,
+			      struct netlink_ext_ack *extack)
 {
 	return blocking_notifier_chain_register(&net->nexthop.notifier_chain,
 						nb);
-- 
2.26.2

