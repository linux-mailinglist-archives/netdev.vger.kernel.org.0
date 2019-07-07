Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E73D615BF
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 19:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfGGRve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 13:51:34 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42499 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725928AbfGGRve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 13:51:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5E6BF21B42;
        Sun,  7 Jul 2019 13:51:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 07 Jul 2019 13:51:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=sOYn2endOy5xl
        RY2fufL7+orzL+e/Qe8puaG+NUFk9U=; b=Goxdeq9oRoNBkWBjskJeNkfBmjjo5
        dArUU/cK2XZmoxmBTLEf2Tag0VR+xSlLu+y2cZfjQlQdfo4T5kXnXCMir7VYkVJL
        rRhgm128MIfWNZH4U3XR+UJHDlZPPPKzgIxhfvprdIaZu3Cn+BVuCeRVOCCwPIKn
        OVw1vJCvni3UTplfjN7UqhbkUSHeiZDnaNQMQjS5aYci7BTkvmNzibVXKuzeZtIY
        2n71mpWxBtOGliqYMB2SoAWtipVXhia+aOV9GiWM+tDhFN94wXKQ4hvr9gQWmQ04
        elV9Skiwx4mn6FOn/DN3UIxsfiGGr1JrS7ks+RNYhE0xKhTzFzRtot+fw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=sOYn2endOy5xlRY2fufL7+orzL+e/Qe8puaG+NUFk9U=; b=ATQdxE8B
        2C6LsAHcQVgzp6Z/28V6cR2OVj4s8gf9OwA/28z9uWU/qWOqfB9tnIqpuXRmOjbs
        TTb4M6zWtMj3KX/iCZ5fqTDQws3LLPuGDUXyABkM78I9Fyeh20mDxCPptWztre34
        EPOOpsaNf/cD5JSrgrf7R4B0A58SHu6K8BdHWwY8VQDt4guR+VYKEE121ctr5leg
        xOaxw5yUAccaPJwssXgMOtLUtxvNuesVvJVczADEEon7JS5J6hVDhsz+NqSxyB+z
        xjBWi50hRsh5uj41F2n5PAw2dm6dptGzNPELo8KgS+UR4WJtJoOc4S4655oBqiRy
        iUUHPmUTQnWs4A==
X-ME-Sender: <xms:IzEiXVNCvrXRlVGuDs4RpLvF0g7aGapU3MaM5KhRBpEA99VVj7jwtA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeekgdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeggihhntggv
    nhhtuceuvghrnhgrthcuoehvihhntggvnhhtsegsvghrnhgrthdrtghhqeenucfkphepke
    ekrdduvddurdeigedrieegnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgrthes
    lhhufhhfhidrtgignecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:IzEiXUZQrFNzNDi3Xbm_z3InljvD9dKLkvrepdO1JEe_hOB24Aeafw>
    <xmx:IzEiXbhc4y-WfIkacLJC-A-jN4WZvh6hdcYaM63evgGVKHO29B3MaA>
    <xmx:IzEiXYPmEHCWTMoziL1Rynr9epcbuxWj4fiYFruFWXq43tq2dmrPIg>
    <xmx:JDEiXU0eyPONA8aIrT7GFJJa0f8LoF2Trd9wh5XsikaYuRAKurSw5Q>
Received: from zoro.luffy.cx (4vh54-1-88-121-64-64.fbx.proxad.net [88.121.64.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1183D380079;
        Sun,  7 Jul 2019 13:51:31 -0400 (EDT)
Received: by zoro.luffy.cx (Postfix, from userid 1000)
        id B7011F1C; Sun,  7 Jul 2019 19:51:28 +0200 (CEST)
From:   Vincent Bernat <vincent@bernat.ch>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     Vincent Bernat <vincent@bernat.ch>
Subject: [PATCH iproute2-next] ip: bond: add peer notification delay support
Date:   Sun,  7 Jul 2019 19:51:15 +0200
Message-Id: <20190707175115.3704-1-vincent@bernat.ch>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707094141.1b98f3f4@hermes.lan>
References: <20190707094141.1b98f3f4@hermes.lan>
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

    $ ip -d link set bond0 type bond peer_notify_delay 1000
    $ ip -d link l dev bond0
    2: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue
    state UP mode DEFAULT group default qlen 1000
        link/ether 50:54:33:00:00:01 brd ff:ff:ff:ff:ff:ff
        bond mode active-backup active_slave eth0 miimon 100 updelay 0
    downdelay 0 peer_notify_delay 1000 use_carrier 1 arp_interval 0
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
index c60f0e8ad0a0..585b6be14c81 100644
--- a/ip/iplink_bond.c
+++ b/ip/iplink_bond.c
@@ -120,6 +120,7 @@ static void print_explain(FILE *f)
 		"Usage: ... bond [ mode BONDMODE ] [ active_slave SLAVE_DEV ]\n"
 		"                [ clear_active_slave ] [ miimon MIIMON ]\n"
 		"                [ updelay UPDELAY ] [ downdelay DOWNDELAY ]\n"
+		"                [ peer_notify_delay DELAY ]\n"
 		"                [ use_carrier USE_CARRIER ]\n"
 		"                [ arp_interval ARP_INTERVAL ]\n"
 		"                [ arp_validate ARP_VALIDATE ]\n"
@@ -165,7 +166,7 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 	__u8 xmit_hash_policy, num_peer_notif, all_slaves_active;
 	__u8 lacp_rate, ad_select, tlb_dynamic_lb;
 	__u16 ad_user_port_key, ad_actor_sys_prio;
-	__u32 miimon, updelay, downdelay, arp_interval, arp_validate;
+	__u32 miimon, updelay, downdelay, peer_notify_delay, arp_interval, arp_validate;
 	__u32 arp_all_targets, resend_igmp, min_links, lp_interval;
 	__u32 packets_per_slave;
 	unsigned int ifindex;
@@ -200,6 +201,11 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 			if (get_u32(&downdelay, *argv, 0))
 				invarg("invalid downdelay", *argv);
 			addattr32(n, 1024, IFLA_BOND_DOWNDELAY, downdelay);
+		} else if (matches(*argv, "peer_notify_delay") == 0) {
+			NEXT_ARG();
+			if (get_u32(&peer_notify_delay, *argv, 0))
+				invarg("invalid peer_notify_delay", *argv);
+			addattr32(n, 1024, IFLA_BOND_PEER_NOTIF_DELAY, peer_notify_delay);
 		} else if (matches(*argv, "use_carrier") == 0) {
 			NEXT_ARG();
 			if (get_u8(&use_carrier, *argv, 0))
@@ -410,6 +416,12 @@ static void bond_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			   "downdelay %u ",
 			   rta_getattr_u32(tb[IFLA_BOND_DOWNDELAY]));
 
+	if (tb[IFLA_BOND_PEER_NOTIF_DELAY])
+		print_uint(PRINT_ANY,
+			   "peer_notify_delay",
+			   "peer_notify_delay %u ",
+			   rta_getattr_u32(tb[IFLA_BOND_PEER_NOTIF_DELAY]));
+
 	if (tb[IFLA_BOND_USE_CARRIER])
 		print_uint(PRINT_ANY,
 			   "use_carrier",
-- 
2.20.1

