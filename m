Return-Path: <netdev+bounces-3653-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90C78708317
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:46:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9D982817EE
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39F6717ACA;
	Thu, 18 May 2023 13:46:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25420125AD
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 13:46:27 +0000 (UTC)
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E853DE42
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 06:46:16 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 4B0705C00E0;
	Thu, 18 May 2023 09:46:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 18 May 2023 09:46:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to; s=fm1; t=1684417576; x=1684503976; bh=va348yYaQJ
	RLRzVoKNMqgxiaWgiZRJW1MkSAMYZ62qQ=; b=cSt5VVv2qUKJ7HICB/kBG3Zf8/
	Rlc+P6Q7Immg+zVBCWaLxLzrkymiphik1HcpP2W+tR19rbVkUkXeg+DAZTFw0fXs
	inAZVbETQp9PyqYUhI3GKelZ2USQhALZ1DDN/0fGcmvjduNZZlHmSfEljaJs5Uq9
	hIx9fm27WM4/VAxJuNyG1sUKra7TOBOJA3vpU62WlSUjneOp4gENKSydBCMe5IsH
	WlpjccQdsf5P3saHsaARhXo92MxhzVSGAywaL9twFodvXyqZtyAftn3mmTj8y/Pu
	S24CLDk25VturxM6rWmlVx5/J+tszIXOx4P+vC83T9bxkstL2QPV3z3DGetQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684417576; x=1684503976; bh=va348yYaQJRLR
	zVoKNMqgxiaWgiZRJW1MkSAMYZ62qQ=; b=THMdQ6lhAO+7GNA0a+TDHFMs8BYbw
	8HhB9ymtF9o6Fyko2brTVodv/RHJe3ohjXScqiNeRJXx5lPa7r+QOAljn7F65ClB
	HZ+mVmeL7IGKHDkYAvlw/G9cQTlA2Or/PxJU7oOdQOm05bkN/Q2lgLc/TTzCbbLa
	f5wczo/BQmQTSdxThMG0lUBaIdZrUG+lxI9mxQSSNorcU5MwM8pQyszHM4IBGlMa
	FpY4IJwVnx5+m7olyRhrXO5llSVnw/21ze+SvJC/fpj+oLqbZRKput7f6Bg8/f/v
	aGBCqCcNNIRevQAeo2jhnrgX56SPoIC/V2gAqxOJeNk6SBJGaI9cbFMKQ==
X-ME-Sender: <xms:JyxmZEcJHIr7jPzm0b3yIJes95zSzG1PuI6WuL5BRaPiN2T7maRoYQ>
    <xme:JyxmZGPZr2WbXGbM33tQ-c9ufGBu4q-tXLOfoxDeua1jLBlr3-ay32FYeYDsK3gif
    xea_16vXlKj45QK3Lc>
X-ME-Received: <xmr:JyxmZFjZ0oGM9U_lP4S4VQS4NVvCHWN-ebEN1vfkhArPZY1MaN5taiyUOjEQhcem2J3AzAC8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeifedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    evufffkffoggfgsedtkeertdertddtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhi
    shhhkhhinhcuoehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrg
    htthgvrhhnpeevjeetfeeftefhffelvefgteelieehveehgeeltdettedvtdekffelgeeg
    iedtveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hvlhgrughimhhirhesnhhikhhishhhkhhinhdrphif
X-ME-Proxy: <xmx:JyxmZJ8GD6iXAHi5YsFt7ruks8mqv1_427yKFmE2qWaRZKeQTbPV1g>
    <xmx:JyxmZAtwMEfg9T40P05OkwOUaeQdDHHRqXTpQMxw_iz15sAR1m2YkQ>
    <xmx:JyxmZAEzVCk9tO6o_rlDGUfTfiwdDK_R31Ugd5QP5hk20c5obnPo2Q>
    <xmx:KCxmZAEI0eGOs83JHYyyWbCW_tNA8hggLwqmkg4ocT_psQj4KP37UQ>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 May 2023 09:46:11 -0400 (EDT)
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
Subject: [PATCH iproute2-next v4] ip-link: add support for nolocalbypass in vxlan
Date: Thu, 18 May 2023 21:46:01 +0800
Message-Id: <20230518134601.17873-1-vladimir@nikishkin.pw>
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
v2=>v3: 1. replace fputs with print_string
        2. fix 77 char line length
	3. fix typos and improve man page
	4. reformat strcmp usage this patch matches commit
 69474a8a5837be63f13c6f60a7d622b98ed5c539 in the main tree.
v3=>v4: 1. fix typos in man/man8/ip-link.8.in

 ip/iplink_vxlan.c     | 20 ++++++++++++++++++++
 man/man8/ip-link.8.in | 10 ++++++++++
 2 files changed, 30 insertions(+)

diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index c7e0e1c4..966b0daf 100644
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
@@ -613,6 +622,17 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		}
 	}
 
+	if (tb[IFLA_VXLAN_LOCALBYPASS]) {
+		__u8 localbypass = rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]);
+
+		print_bool(PRINT_JSON, "localbypass", NULL, localbypass);
+		if (localbypass) {
+			print_string(PRINT_FP, NULL, "localbypass ", NULL);
+		} else {
+			print_string(PRINT_FP, NULL, "nolocalbypass ", NULL);
+		}
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


