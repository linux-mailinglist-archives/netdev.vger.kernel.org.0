Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63CC261301
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 23:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfGFVL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 17:11:58 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35461 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726531AbfGFVL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 17:11:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id B716720A0D;
        Sat,  6 Jul 2019 17:11:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 06 Jul 2019 17:11:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=MGvLmdm5LjR5HS39ZbeXFrBF/c
        mLSMfASS4SmLVg23k=; b=iwTbjtAUgiX7ZBfpY1a3VOd6dXQvRzppxadyhzCThO
        aKvGg8+8lppYu2/TQ83usL4LYmZUQry1qrcqj7V06GazsTgtK5MgoX3CowvpgV4v
        ZShrPkPu+wAogPpKwe4KcGl5a4j1Zk5UfDL5AmydA7lkWuJ8rmk2lWnHBHRnRYEH
        OwdV02Ix9dE85TnQofGlh9JUAtE0MK1VP0hbRa7qBVFDXMLJKdV7WasMJcMVi3Z5
        c5+CYC9s2ymsleA+kAmJH0T8L3va+tIbJGNUqjWENjt8b4HbMCrxGr+MXn+wpxK2
        uJjWKcf5bwtezth5tjDwAVciGRT5+kKZH7LKEN5VAZrA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=MGvLmdm5LjR5HS39Z
        beXFrBF/cmLSMfASS4SmLVg23k=; b=m+TzLkiIlIyQp0nhCNTPxhq5Df3oGWXt4
        Qd1zm/6nC0h5he7d9Htbyoz66K3v6GKPOjW7Uix94kOUuMVWq8xbKuh+sIBcD+uw
        xI1fT1TzBPKnwitytP7zHhP5ow0WyZpHw3REQWs0hfMyZPzV0K3Z8faCgVJzgYpH
        2hZ4mHsD337brV656ToaVSWVYnzWAMqpe87QJc32+62OkFST1osGgiHwFY+KRtBQ
        ORqXTLSXf8LCd8L7JufxfLFh5XtWGY0fH8rhBPEfw6l6f2u7nvS3DfY+F0B1V+QJ
        JCei24SoAbLEIP4ajMoT3chP6/PtgWlDCJHmlmywGlzgyspS55hDA==
X-ME-Sender: <xms:mw4hXQWFonGAIQNleks4WHC1ENCDsH1sR4RPheFv9C-ffN4sa8EqXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeeigdduheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeggihhntggvnhht
    uceuvghrnhgrthcuoehvihhntggvnhhtsegsvghrnhgrthdrtghhqeenucfkphepkeekrd
    duvddurdeigedrieegnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgrtheslhhu
    fhhfhidrtgignecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:mw4hXaEXsATyKJm8u1Fi23MdbQTCbmnKTiRXkpjVjYJHoShLSF7sew>
    <xmx:mw4hXXEfI7U0HA7KZSqOKX-XjAZ_kcw-hsjrln-skxIdOoRF1XU_SA>
    <xmx:mw4hXctojqgEe32bS3vWk3jR-RHjZHr5wP6EA0vWN-AuTPRNzAlNmw>
    <xmx:nA4hXcCiAbEJO5cExepxJAO24OGPSyAdcLxczSzdtbNsNrmkldiO0Q>
Received: from zoro.luffy.cx (4vh54-1-88-121-64-64.fbx.proxad.net [88.121.64.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8A23580061;
        Sat,  6 Jul 2019 17:11:55 -0400 (EDT)
Received: by zoro.luffy.cx (Postfix, from userid 1000)
        id D324AECE; Sat,  6 Jul 2019 23:11:53 +0200 (CEST)
From:   Vincent Bernat <vincent@bernat.ch>
To:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Vincent Bernat <vincent@bernat.ch>
Subject: [PATCH iproute2-next] ip: bond: add peer notification delay support
Date:   Sat,  6 Jul 2019 23:11:45 +0200
Message-Id: <20190706211145.16438-1-vincent@bernat.ch>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ability to tweak the delay between gratuitous ND/ARP packets has been
added in kernel commit 07a4ddec3ce9 ("bonding: add an option to
specify a delay between peer notifications"), through
IFLA_BOND_PEER_NOTIF_DELAY attribute. Add support to set and show this
value.

Example:

    $ ip -d link set bond0 type bond peer_notif_delay 1000
    $ ip -d link l dev bond0
    2: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue
    state UP mode DEFAULT group default qlen 1000
        link/ether 50:54:33:00:00:01 brd ff:ff:ff:ff:ff:ff
        bond mode active-backup active_slave eth0 miimon 100 updelay 0
    downdelay 0 peer_notif_delay 1000 use_carrier 1 arp_interval 0
    arp_validate none arp_all_targets any primary eth0
    primary_reselect always fail_over_mac active xmit_hash_policy
    layer2 resend_igmp 1 num_grat_arp 5 all_slaves_active 0 min_links
    0 lp_interval 1 packets_per_slave 1 lacp_rate slow ad_select
    stable tlb_dynamic_lb 1 addrgenmode eu

Signed-off-by: Vincent Bernat <vincent@bernat.ch>
---
 include/uapi/linux/if_link.h |  1 +
 ip/iplink_bond.c             | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index b59554dd55cb..d36919fb4024 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -634,6 +634,7 @@ enum {
 	IFLA_BOND_AD_USER_PORT_KEY,
 	IFLA_BOND_AD_ACTOR_SYSTEM,
 	IFLA_BOND_TLB_DYNAMIC_LB,
+	IFLA_BOND_PEER_NOTIF_DELAY,
 	__IFLA_BOND_MAX,
 };
 
diff --git a/ip/iplink_bond.c b/ip/iplink_bond.c
index c60f0e8ad0a0..fb62c955631e 100644
--- a/ip/iplink_bond.c
+++ b/ip/iplink_bond.c
@@ -120,6 +120,7 @@ static void print_explain(FILE *f)
 		"Usage: ... bond [ mode BONDMODE ] [ active_slave SLAVE_DEV ]\n"
 		"                [ clear_active_slave ] [ miimon MIIMON ]\n"
 		"                [ updelay UPDELAY ] [ downdelay DOWNDELAY ]\n"
+		"                [ peer_notif_delay DELAY ]\n"
 		"                [ use_carrier USE_CARRIER ]\n"
 		"                [ arp_interval ARP_INTERVAL ]\n"
 		"                [ arp_validate ARP_VALIDATE ]\n"
@@ -165,7 +166,7 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 	__u8 xmit_hash_policy, num_peer_notif, all_slaves_active;
 	__u8 lacp_rate, ad_select, tlb_dynamic_lb;
 	__u16 ad_user_port_key, ad_actor_sys_prio;
-	__u32 miimon, updelay, downdelay, arp_interval, arp_validate;
+	__u32 miimon, updelay, downdelay, peer_notif_delay, arp_interval, arp_validate;
 	__u32 arp_all_targets, resend_igmp, min_links, lp_interval;
 	__u32 packets_per_slave;
 	unsigned int ifindex;
@@ -200,6 +201,11 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 			if (get_u32(&downdelay, *argv, 0))
 				invarg("invalid downdelay", *argv);
 			addattr32(n, 1024, IFLA_BOND_DOWNDELAY, downdelay);
+		} else if (matches(*argv, "peer_notif_delay") == 0) {
+			NEXT_ARG();
+			if (get_u32(&peer_notif_delay, *argv, 0))
+				invarg("invalid peer_notif_delay", *argv);
+			addattr32(n, 1024, IFLA_BOND_PEER_NOTIF_DELAY, peer_notif_delay);
 		} else if (matches(*argv, "use_carrier") == 0) {
 			NEXT_ARG();
 			if (get_u8(&use_carrier, *argv, 0))
@@ -410,6 +416,12 @@ static void bond_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			   "downdelay %u ",
 			   rta_getattr_u32(tb[IFLA_BOND_DOWNDELAY]));
 
+	if (tb[IFLA_BOND_PEER_NOTIF_DELAY])
+		print_uint(PRINT_ANY,
+			   "peer_notif_delay",
+			   "peer_notif_delay %u ",
+			   rta_getattr_u32(tb[IFLA_BOND_PEER_NOTIF_DELAY]));
+
 	if (tb[IFLA_BOND_USE_CARRIER])
 		print_uint(PRINT_ANY,
 			   "use_carrier",
-- 
2.20.1

