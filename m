Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1856D6C43D0
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 08:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjCVHEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 03:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCVHEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 03:04:39 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4CC570B0
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 00:04:37 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 0AEC35C01CF;
        Wed, 22 Mar 2023 03:04:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 22 Mar 2023 03:04:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1679468676; x=1679555076; bh=I5oUCWPMcj
        /7komxv2zT55piJ8IITdiBzsVlLSQXRvQ=; b=RBLhI1+z6I5VsJluW3RD+626le
        PLQfYkG6ouuia7KA+okVveMAoyDeVPHmJhuh31d5bv6y/9lAob2WkFqIfgrgxJkS
        MdPLTnWBQy3huoXns/+7Ov1a79S9LR4FqLwGtaC8X5SlJgPANtFenu/0JbWUjdK9
        yfXPMEOgduwLdU9xblJrUlfBNgJkl74R1x/FJSzdHE97AvKSz6stu77JDK4MOpRG
        lkHfnUs2zucNRBUHOcNx3TrRpOqOo87dQVTWGua+V5OtP3Ei3FmCFcniJiC3TD3Z
        q4WKAc0ms/khOgMbjphGY3j0tn5YNzOn7KZBkR5MMR8j9RifOJsI+3FmaP/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1679468676; x=1679555076; bh=I5oUCWPMcj/7k
        omxv2zT55piJ8IITdiBzsVlLSQXRvQ=; b=blfCEcF5Emz1WuSQ2lqpuSk/lh/+3
        b1bxBc/euFUPq4Be5DnpPZZGH2n7ErhmURFY1b8X3O902xpsFCwaT/Jrgf6nTa1G
        nA/4wQK4hUULlyQ7LpJ0MAiR55/shoabrnNPzFUv7S/wTDEhCKyQDScTpqQDS2cV
        rkxeMqLogsiF5u1kT3KleaVzzZtACxGM+g2FRKOp3VJv4GrCCn1d5x5ZKatKncLe
        T2XjbnnaRKZAaUdnuiKTfdc8i2u/3y4sf4BgB+gB4lHvLF2nf77DRyzTmYFSNijI
        SHQN9pgKEchFtO+8didDUbW1wfAg6SG+Mv2Y/QHIw8cCt3ey6LmDnCHjw==
X-ME-Sender: <xms:g6gaZEtCqwT0q3Y5ctloUHiKym5ovuMCzukul8707P3c5AaAaqrA5Q>
    <xme:g6gaZBe4lEni8DzRcuaXBMNjLdui3MNT5CxcY3nbTOOm-ICl-GckTWE37qboJCDjG
    QliPaE7ygLmRPJn5Qk>
X-ME-Received: <xmr:g6gaZPxjS5A-rP-GV6W8Hr1vTYWyEcKVdL7rMYARxA9S8eKlfha_HVTE1J3Lm68O8zXv_8s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeguddguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephf
    fvvefufffkofgggfestdekredtredttdenucfhrhhomhepgghlrgguihhmihhrucfpihhk
    ihhshhhkihhnuceovhhlrgguihhmihhrsehnihhkihhshhhkihhnrdhpfieqnecuggftrf
    grthhtvghrnhepveejteeffeethfffleevgfetleeiheevheegledtteetvddtkeffleeg
    geeitdevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epvhhlrgguihhmihhrsehnihhkihhshhhkihhnrdhpfi
X-ME-Proxy: <xmx:g6gaZHNmISUmMorqsOznCO2eZ0WkwrXWEjj0SoEdV1gWRd81NPtI_A>
    <xmx:g6gaZE-1izmrS_G8vy-NSSA2CVBemF6D6ra_mn5b8BSlp64q7zV4Hw>
    <xmx:g6gaZPXIGy1byZ4JE_0ZNg72PNlodgUndirJbBtPLUB479H9_TDPKw>
    <xmx:hKgaZBN2CNXYmYfBSSMhp4GVEoRhI_MbyEOY2v16MZWeBYnMPQzQwg>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Mar 2023 03:04:27 -0400 (EDT)
From:   Vladimir Nikishkin <vladimir@nikishkin.pw>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
        gnault@redhat.com, razor@blackwall.org,
        Vladimir Nikishkin <vladimir@nikishkin.pw>
Subject: [PATCH net-next v4] vxlan: try to send a packet normally if local bypass fails
Date:   Wed, 22 Mar 2023 15:04:14 +0800
Message-Id: <20230322070414.21257-1-vladimir@nikishkin.pw>
X-Mailer: git-send-email 2.35.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vxlan_core, if an fdb entry is pointing to a local
address with some port, the system tries to get the packet to
deliver the packet to the vxlan directly, bypassing the network
stack.

This patch makes it still try canonical delivery, if there is no
linux kernel vxlan listening on this port. This will be useful
for the cases when there is some userspace daemon expecting
vxlan packets for post-processing, or some other implementation
of vxlan.

Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
---
 Documentation/networking/vxlan.rst | 13 ++++++++++
 drivers/net/vxlan/vxlan_core.c     | 39 ++++++++++++++++++++++++++++--
 2 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/vxlan.rst b/Documentation/networking/vxlan.rst
index 2759dc1cc525..0ac5681093ef 100644
--- a/Documentation/networking/vxlan.rst
+++ b/Documentation/networking/vxlan.rst
@@ -86,3 +86,16 @@ offloaded ports can be interrogated with `ethtool`::
       Types: geneve, vxlan-gpe
       Entries (1):
           port 1230, vxlan-gpe
+
+=================
+Sysctls
+=================
+
+One sysctl influences the behaviour of the vxlan driver.
+
+ - `vxlan.disable_local_bypass`
+
+If set to 1, and if there is a packet destined to the local address, for which the
+driver cannot find a corresponding vni, it is forwarded to the userspace networking
+stack. This is useful if there is some userspace UDP tunnel waiting for such
+packets.
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 561fe1b314f5..cef15b9d3c9e 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -15,6 +15,7 @@
 #include <linux/igmp.h>
 #include <linux/if_ether.h>
 #include <linux/ethtool.h>
+#include <linux/sysctl.h>
 #include <net/arp.h>
 #include <net/ndisc.h>
 #include <net/gro.h>
@@ -53,6 +54,30 @@ static bool log_ecn_error = true;
 module_param(log_ecn_error, bool, 0644);
 MODULE_PARM_DESC(log_ecn_error, "Log packets received with corrupted ECN");
 
+static int disable_local_bypass;
+struct ctl_table_header *vxlan_sysctl_header;
+static struct ctl_table vxlan_sysctl_child[] = {
+	{
+		.procname = "disable_local_bypass",
+		.data = &disable_local_bypass,
+		.maxlen = sizeof(int),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec_minmax,
+		.extra1 = SYSCTL_ZERO,
+		.extra2 = SYSCTL_ONE,
+	},
+	{}
+};
+
+static struct ctl_table vxlan_sysctl_parent[] = {
+	{
+		.procname = "vxlan",
+		.mode = 0555,
+		.child = vxlan_sysctl_child,
+	},
+	{}
+};
+
 unsigned int vxlan_net_id;
 
 const u8 all_zeros_mac[ETH_ALEN + 2];
@@ -2355,18 +2380,21 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 	    !(rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))) {
 		struct vxlan_dev *dst_vxlan;
 
-		dst_release(dst);
 		dst_vxlan = vxlan_find_vni(vxlan->net, dst_ifindex, vni,
 					   daddr->sa.sa_family, dst_port,
 					   vxlan->cfg.flags);
-		if (!dst_vxlan) {
+		if (!dst_vxlan && !disable_local_bypass) {
+			dst_release(dst);
 			dev->stats.tx_errors++;
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_TX_ERRORS, 0);
 			kfree_skb(skb);
 
 			return -ENOENT;
+		} else if (!dst_vxlan && disable_local_bypass) {
+			return 0;
 		}
+		dst_release(dst);
 		vxlan_encap_bypass(skb, vxlan, dst_vxlan, vni, true);
 		return 1;
 	}
@@ -4671,6 +4699,12 @@ static struct pernet_operations vxlan_net_ops = {
 static int __init vxlan_init_module(void)
 {
 	int rc;
+	vxlan_sysctl_header =
+		register_sysctl_table(vxlan_sysctl_parent);
+	if (!vxlan_sysctl_header) {
+		pr_alert("Error: Failed to register vxlan sysctl subtree\n");
+		return -EFAULT;
+	}
 
 	get_random_bytes(&vxlan_salt, sizeof(vxlan_salt));
 
@@ -4706,6 +4740,7 @@ late_initcall(vxlan_init_module);
 
 static void __exit vxlan_cleanup_module(void)
 {
+	unregister_sysctl_table(vxlan_sysctl_header);
 	vxlan_vnifilter_uninit();
 	rtnl_link_unregister(&vxlan_link_ops);
 	unregister_switchdev_notifier(&vxlan_switchdev_notifier_block);
-- 
2.35.7

--
Fastmail.

