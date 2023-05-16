Return-Path: <netdev+bounces-3010-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DAEA70502A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:05:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F91128169F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:05:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19FE428C04;
	Tue, 16 May 2023 14:05:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B64D34CD9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 14:05:43 +0000 (UTC)
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637A835A0
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:05:42 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id 1859E5C027E;
	Tue, 16 May 2023 10:05:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 16 May 2023 10:05:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to; s=fm1; t=1684245941; x=1684332341; bh=mjJGBfGRSR
	2sjD48EoZZ6x4mW4h8idjxqLxd45R6IqM=; b=AEsD5dTPZ8tzIRRRmU1BN24W2E
	7IN0kD2KtBKQgDKJOO5JXhm940v+iCZ3zNSQvAbBgmKjpGctG0d7bdXTSLC9Mn6j
	v0qj5lHg/87JYXBwGj2eCGfLQphWYYpqE7DyTCs7blAnkyTquh6UgjLMglo+EPvH
	FnUc70ww5z8rKp8Y5/KegqED2nr8WkBOM7Tu6oj9zGAUlcBacjbmvWzDZLMvQfjX
	SopdJqgouAi0yHsr8Udr6K75Nil1h1+4RTa3S2SSDEnFVipcA+e54nM/MkAarNVY
	rBxYiFZnjDh4k24z7tg+L8tYzP5SMQChsxvn1Vi1O86k4V0gqLIVWbbNUbiw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684245941; x=1684332341; bh=mjJGBfGRSR2sj
	D48EoZZ6x4mW4h8idjxqLxd45R6IqM=; b=c02kenUKhZ4sgnSHcI7850e0vg76p
	H0fFqWRQPqd8oo9LQsX5mKwQawjahsKbSjyMyQS2ytNvbxwyF8X4HIsrK3OSJvMR
	dFad2hHpWcaFinSaPza4AQIgQSi+WY65Is9Jjj5UUkVUUH9alRA1EH5jUFSVcK4m
	lJghE8RZXUUvnHgcVURGcwrSEMIXtkhTvk9KsBF4SCiTJaFf8eMIkOyVirzKXYNi
	H7f06SrsYVh7iNPqEdgm276D+WwIhP0gV7zeI+w1YxZTbDUdM6G6QM/e/XePVnQI
	N3flTZef5iZFdmSMjhl8gEOyGSb1RqGY2zNXZhPptIn5F1dZ/dWJjMZiw==
X-ME-Sender: <xms:tI1jZAfoIZh5OfQ2jMIc-4UuR8mtgXDicIble6gcGUiwX8pNd_mfLQ>
    <xme:tI1jZCMxUH1-f7jgqf12s8sQZLv2-sGrZTiMNp9zlS0Yz1yOEmfSwvhsjhxd9UJWO
    F-pxleRP7t0zat1p1A>
X-ME-Received: <xmr:tI1jZBi27gT7jRs7QoEwZkO_OA0wt9IWLMwvjA8giI5hYwtCBIqUW_FLOuiXxfft0iCKKEUKEXo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeehledgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    evufffkffoggfgsedtkeertdertddtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhi
    shhhkhhinhcuoehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrg
    htthgvrhhnpeevjeetfeeftefhffelvefgteelieehveehgeeltdettedvtdekffelgeeg
    iedtveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hvlhgrughimhhirhesnhhikhhishhhkhhinhdrphif
X-ME-Proxy: <xmx:tI1jZF-EQIQDCXXmSGWjPAwqxz6h3TqNUVfoiPJv7VEW-3Co6dSPNg>
    <xmx:tI1jZMt6PeyVaVbD1s1u279xR8wE9FQVJ3i0V_10IMWX8sXd38Awdg>
    <xmx:tI1jZMFGipCxB-jzKcURff8rmrhKg4RllX75o5g_ctnHWrgXeRWygA>
    <xmx:tY1jZMGLs3VzIDVpEQ8-8hTHnMLo2ebtd06RYwrYjrfpNCq2_3Zh9A>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 16 May 2023 10:05:36 -0400 (EDT)
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
Subject: [PATCH iproute2-next v2] ip-link: add support for nolocalbypass in vxlan
Date: Tue, 16 May 2023 22:04:57 +0800
Message-Id: <20230516140457.22366-1-vladimir@nikishkin.pw>
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
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add userspace support for the [no]localbypass vxlan netlink
attribute. With localbypass on (default), the vxlan driver processes
the packets destined to the local machine by itself, bypassing the
nework stack. With nolocalbypass the packets are always forwarded to
the userspace network stack, so usepspace programs, such as tcpdump
have a chance to process them.

Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
---
v2: this patch matches commit 69474a8a5837be63f13c6f60a7d622b98ed5c539
in the main tree.

 ip/iplink_vxlan.c     | 19 +++++++++++++++++++
 man/man8/ip-link.8.in | 10 ++++++++++
 2 files changed, 29 insertions(+)

diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index c7e0e1c4..98fbc65c 100644
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
@@ -276,6 +277,12 @@ static int vxlan_parse_opt(struct link_util *lu, int argc, char **argv,
 		} else if (!matches(*argv, "noudpcsum")) {
 			check_duparg(&attrs, IFLA_VXLAN_UDP_CSUM, *argv, *argv);
 			addattr8(n, 1024, IFLA_VXLAN_UDP_CSUM, 0);
+		} else if (0 == strcmp(*argv, "localbypass")) {
+			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS, *argv, *argv);
+			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 1);
+		} else if (0 == strcmp(*argv, "nolocalbypass")) {
+			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS, *argv, *argv);
+			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 0);
 		} else if (!matches(*argv, "udp6zerocsumtx")) {
 			check_duparg(&attrs, IFLA_VXLAN_UDP_ZERO_CSUM6_TX,
 				     *argv, *argv);
@@ -613,6 +620,18 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		}
 	}
 
+	if (tb[IFLA_VXLAN_LOCALBYPASS]) {
+		__u8 localbypass = rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]);
+
+		if (is_json_context()) {
+			print_bool(PRINT_ANY, "localbypass", NULL, localbypass);
+		} else {
+			if (!localbypass)
+				fputs("no", f);
+			fputs("localbypass ", f);
+		}
+	}
+
 	if (tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
 		__u8 csum6 = rta_getattr_u8(tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]);
 
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index bf3605a9..e53efc45 100644
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
+- if fdb destination is local, with nolocalbypass set, forward packets
+to the userspace network stack. If there is a userspace process
+listening for these packets, it will have a chance to process them.
+If localbypass is active (default), bypass the network stack and
+inject the packet into the driver directly.
+
 .sp
 .RB [ no ] udp6zerocsumtx
 - skip UDP checksum calculation for transmitted packets over IPv6.
-- 
2.35.8

--
Fastmail.


