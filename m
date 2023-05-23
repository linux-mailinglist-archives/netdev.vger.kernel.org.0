Return-Path: <netdev+bounces-4526-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BCEF70D2F5
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:48:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A83128123C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:48:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 111115397;
	Tue, 23 May 2023 04:48:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5F4A55
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 04:48:37 +0000 (UTC)
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30954189
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 21:48:26 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.west.internal (Postfix) with ESMTP id 1B12D3200201;
	Tue, 23 May 2023 00:48:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 23 May 2023 00:48:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to; s=fm1; t=1684817302; x=1684903702; bh=F6bjh9ezeS
	abUnTg2A7rrDoGm/AeRQsA0aA6DJzQNQM=; b=jUJnqdsru6dJyDYsC1LbmNohaD
	BLPN/nAYJm8dVmdcI/rXqoWB1hpYry77e4ivZsaJCkfgLtN0EA2EX3Vm7r91DAe8
	Z7URFqV3lQ0kojgjYVSgGNP+BvSEquES8iWzpYvNWO55LGEOjfZNWe8yPNf5iOr2
	tuLVnqcxMZPs3Toi4t2AWr08a9+k4Co8ahwZdG8fqkMjA7Twia4EgGKXh6cR8DHH
	u7ZolcqRAFWXS1ScwdHSFPtUSmlrlc9aTAFmk5txsFFexjl4DwWXNTJ0oiyf8um3
	CuvG3uV8Dnq0jRdv3E0W4Qj8gkGYtdg+W4ePL8ZU++Tpo/3imvplwkfCN22g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684817302; x=1684903702; bh=F6bjh9ezeSabU
	nTg2A7rrDoGm/AeRQsA0aA6DJzQNQM=; b=o2Viq6QILgYziYUujB1BhOvYTaT3R
	gQQSbzrWa4+dlyKbTR5LouOBnGSPryPZx8OjvpphuiKp3EHcVCw7Zvm+t1n5/m1l
	Cm1UKRKcG59sDhYoBfd9M+90ORDgTFP0eEsrinUjTImYYqaVH/mjPtzpk3ZLRS+B
	lDaR17XjwVSYSgTgMIwwM5pPWCvRRp9MVLEGan1n6t1u78+KMDwJaNXpPOxyQDdw
	XkeEkq+5e72Ze7Wio1k4+LVUveJOzHxh2mslPjLNC+rezWRGnajri1eA9RsIzW5H
	ntx2iaGsLpS4BewxhJVUinJIP4PCLOcwPtEGqyDWZMuJ9IB7eqiPWGu4A==
X-ME-Sender: <xms:lkVsZKMsoV2kywbmcYIHz0H_szkQ5ewrDOcg4STeMJ5oqJKiYfGZ7w>
    <xme:lkVsZI-P9HMKRzUqu8XjSdrDvOKUZnzRc3ttenu5LDdf5PcgjZ7PULxijrSS8P0Sz
    AK-b9r_A02gGLdCRYU>
X-ME-Received: <xmr:lkVsZBTyT2nO8dDxfh95ADxdU0nDmsZY5gY3X_C-dMtxBLrm92-mVhatimAW499DXIw0BUjeQLs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeejvddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    evufffkffoggfgsedtkeertdertddtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhi
    shhhkhhinhcuoehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrg
    htthgvrhhnpeevjeetfeeftefhffelvefgteelieehveehgeeltdettedvtdekffelgeeg
    iedtveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hvlhgrughimhhirhesnhhikhhishhhkhhinhdrphif
X-ME-Proxy: <xmx:lkVsZKt223FVel5kuup6Ej5ngRtS9d_Zpv9l6tGoFg-wSh3tC6zVQw>
    <xmx:lkVsZCft9pJtvwu1dlhjlDIYil5uF_O1_MlYqSQutRNwAs2Ta6VhIQ>
    <xmx:lkVsZO2fDl9QnSuHg8kTdhNNhklU688tGSY5mGIeMekgkxNQMAkf0A>
    <xmx:lkVsZO2H8NXYbqmHIU7TKJmCidzW8ceqkVlmnaGnTEPQAKeBshHTAg>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 May 2023 00:48:18 -0400 (EDT)
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
Subject: [PATCH iproute2-next v6] ip-link: add support for nolocalbypass in vxlan
Date: Tue, 23 May 2023 12:48:05 +0800
Message-Id: <20230523044805.22211-1-vladimir@nikishkin.pw>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
v5=>v6: 1. ip-link:Print nolocalbypass option like the "learning" one.

This patch is not changing how the other options are printed.

 ip/iplink_vxlan.c     | 17 +++++++++++++++++
 man/man8/ip-link.8.in | 10 ++++++++++
 2 files changed, 27 insertions(+)

diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index c7e0e1c4..cd332555 100644
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
@@ -613,6 +622,14 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		}
 	}
 
+	if (tb[IFLA_VXLAN_LOCALBYPASS]) {
+		__u8 localbypass = rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]);
+
+		print_bool(PRINT_JSON, "localbypass", NULL, localbypass);
+		if (!localbypass)
+			print_bool(PRINT_FP, NULL, "nolocalbypass ", true);
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


