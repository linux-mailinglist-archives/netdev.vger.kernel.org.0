Return-Path: <netdev+bounces-4090-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 827E670AC8B
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 07:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30D231C2099F
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 05:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10429A48;
	Sun, 21 May 2023 05:50:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03712A29
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 05:50:22 +0000 (UTC)
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DF4D7
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 22:50:21 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id 1EBD95C00BD;
	Sun, 21 May 2023 01:50:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 21 May 2023 01:50:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to; s=fm1; t=1684648219; x=1684734619; bh=PiP8QzRkrP
	n9kUF+P6ZLI895Ylh+B0/9QUouNK+r9kk=; b=vAVMnt/B2PCGQkhA2qpq0r5MMR
	4JH0TRwhBmNxumxlpFPUr9rnYonEFxPkwEnraH2f3xNstyXKYRFmYY6MUkyBjp8k
	Y/NJ/8bw2k/Sc2ErKcENtQRZYrur8WoE3a2hue1aGnLk06zEWBWlfyv2j3hzSxqM
	/KMDI3AaepeYLaUbW/h63A4WR+pdUe4ROovt+AkhnXo5NLkwztCFLw0Dxzm2aGnL
	UQrTWq/OosHMWY87NsTlKxsYvEI1wSbtPRr+qocVvUVj8aGjBW/ktjF386xwn+WG
	5SnVePrWnsgd3jBlUii/f8u6PTMDFkd7JBr+Xtl4drHb05+Rb2OEZruYFmrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684648219; x=1684734619; bh=PiP8QzRkrPn9k
	UF+P6ZLI895Ylh+B0/9QUouNK+r9kk=; b=tqZVRUWbUdQTcjcxzsaY9Ww/t+v/D
	rS4cx5zwFEwjCZLy9KkiTUfCBwbmUxj4fdnMaGjHhG+MkwojDVFmJ+JI7d/9XTBl
	rcIcp6RidUp3emzVN/4xuBedgRm08Sg8b97S+r26zk07R9SEoWEHQgrtkzwolcb5
	rDVpPZ+Qb3qaNIdXVtF5AM3+HygLgVYpe7DuNaIgsFrSM/AvrgdhcgQe/kaUFskP
	DpPxu5jETyqst1bRTNve3wL0l2jnOBaahgbAch+UBUBhHExHgBU6hU0iAEtiyQE5
	IVlkwCZHBGduq/V62yUb73An54YBkv51YoOnfMlBkdeaB6X2IRO3WSSrg==
X-ME-Sender: <xms:GrFpZCIZ5JnmwO9HCrwFybJRTOdPFocEmzTh8ACeOy_i8HipO7VZkg>
    <xme:GrFpZKJbAWRuIakbTMquYGQhPvsZGVnrh38SEJL3kNnNs1UhDQyVxRI3WI2JY1Tyj
    bAhDdzu7HQaBYa5T08>
X-ME-Received: <xmr:GrFpZCvon7lt114f9JZcDatlY9tQT_Wq_jIys-R5iNH42c1Tg0QzkoaBidtS8sXGZBdNeawI65k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeikedgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    evufffkffoggfgsedtkeertdertddtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhi
    shhhkhhinhcuoehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrg
    htthgvrhhnpeevjeetfeeftefhffelvefgteelieehveehgeeltdettedvtdekffelgeeg
    iedtveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hvlhgrughimhhirhesnhhikhhishhhkhhinhdrphif
X-ME-Proxy: <xmx:GrFpZHboM0pz1FbyJR33AXAIBNsRvHWtYEaN20kB79QvCGG79NwLHw>
    <xmx:GrFpZJbC_xeE7k_gqZTiECE6vJ1-YLIPIpxrF8g1pluZQMlFDEvVng>
    <xmx:GrFpZDA65_dTCA7e-CeEwDvSTu5hHcLx8O4XQu3opscM2ZfEb5b6Nw>
    <xmx:G7FpZPA4gFw3wv3T1qtv1s8OyWZm01U8hTDOI3giDVBAgekyNBRSfQ>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 21 May 2023 01:50:14 -0400 (EDT)
From: Vladimir Nikishkin <vladimir@nikishkin.pw>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com,
	gnault@redhat.com,
	razor@blackwall.org,
	idosch@nvidia.com,
	liuhangbin@gmail.com,
	eyal.birger@gmail.com,
	jtoppins@redhat.com,
	Vladimir Nikishkin <vladimir@nikishkin.pw>
Subject: [PATCH iproute2-next v5] ip-link: add support for nolocalbypass in vxlan
Date: Sun, 21 May 2023 13:49:48 +0800
Message-Id: <20230521054948.22753-1-vladimir@nikishkin.pw>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add userspace support for the [no]localbypass vxlan netlink
attribute. With localbypass on (default), the vxlan driver processes
the packets destined to the local machine by itself, bypassing the
userspace nework stack. With nolocalbypass the packets are always
forwarded to the userspace network stack, so userspace programs,
such as tcpdump have a chance to process them.

Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
---
v4=>v5: Change the way nolocalbypass option status is printed
        in ip-link to the "new way".

 this patch matches
 commit 69474a8a5837be63f13c6f60a7d622b98ed5c539
 in the main tree

ip/iplink_vxlan.c     | 14 ++++++++++++++
 man/man8/ip-link.8.in | 10 ++++++++++
 2 files changed, 24 insertions(+)

diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index c7e0e1c4..14142fda 100644
--- a/ip/iplink_vxlan.c
+++ b/ip/iplink_vxlan.c
@@ -45,6 +45,7 @@ static void print_explain(FILE *f)
 		"		[ [no]remcsumtx ] [ [no]remcsumrx ]\n"
 		"		[ [no]external ] [ gbp ] [ gpe ]\n"
 		"		[ [no]vnifilter ]\n"
+		"		[ [no]localbypass ]\n"
 		"\n"
 		"Where:	VNI	:= 0-16777215\n"
 		"	ADDR	:= { IP_ADDRESS | any }\n"
@@ -276,6 +277,14 @@ static int vxlan_parse_opt(struct link_util *lu, int argc, char **argv,
 		} else if (!matches(*argv, "noudpcsum")) {
 			check_duparg(&attrs, IFLA_VXLAN_UDP_CSUM, *argv, *argv);
 			addattr8(n, 1024, IFLA_VXLAN_UDP_CSUM, 0);
+		} else if (strcmp(*argv, "localbypass") == 0) {
+			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS,
+				     *argv, *argv);
+			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 1);
+		} else if (strcmp(*argv, "nolocalbypass") == 0) {
+			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS,
+				     *argv, *argv);
+			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 0);
 		} else if (!matches(*argv, "udp6zerocsumtx")) {
 			check_duparg(&attrs, IFLA_VXLAN_UDP_ZERO_CSUM6_TX,
 				     *argv, *argv);
@@ -613,6 +622,11 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		}
 	}
 
+	if (tb[IFLA_VXLAN_LOCALBYPASS] &&
+	   rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS])) {
+		print_bool(PRINT_ANY, "localbypass", "localbypass", true);
+	}
+
 	if (tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
 		__u8 csum6 = rta_getattr_u8(tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]);
 
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index bf3605a9..27ebeeac 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -630,6 +630,8 @@ the following additional arguments are supported:
 ] [
 .RB [ no ] udpcsum
 ] [
+.RB [ no ] localbypass
+] [
 .RB [ no ] udp6zerocsumtx
 ] [
 .RB [ no ] udp6zerocsumrx
@@ -734,6 +736,14 @@ are entered into the VXLAN device forwarding database.
 .RB [ no ] udpcsum
 - specifies if UDP checksum is calculated for transmitted packets over IPv4.
 
+.sp
+.RB [ no ] localbypass
+- if FDB destination is local, with nolocalbypass set, forward encapsulated
+packets to the userspace network stack. If there is a userspace process
+listening for these packets, it will have a chance to process them. If
+localbypass is active (default), bypass the kernel network stack and
+inject the packets into the target VXLAN device, assuming one exists.
+
 .sp
 .RB [ no ] udp6zerocsumtx
 - skip UDP checksum calculation for transmitted packets over IPv6.
-- 
2.35.8

--
Fastmail.


