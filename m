Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1876D7399
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 07:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbjDEFDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 01:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236534AbjDEFDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 01:03:13 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8882D7D
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 22:03:13 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 62EE53200A81;
        Wed,  5 Apr 2023 01:03:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 05 Apr 2023 01:03:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1680670990; x=1680757390; bh=e+gJbS/xmk
        ipTy+DJXQ/LEt1VqMwCQcF3ixZiuvDl4o=; b=mQ9P/PI2QGew5vS3IivlIzNu/5
        314lE/4V0eZnJtXrmXHgmndRp0Xy2GxNwXykvVdD+YSU0hiInSBgapVR3Gvc1KbR
        WzYV2exF3U5amIAdI2OoF0FjamerUFxixjZB1+yC6hG9e5qU4t1oh2lO2goFT9RL
        4hkwB7vQexz7cOw2M1JKbVFqrCC8syv3lgXUfXqOlUmu8l1MSQK1WBR7OMlNljAb
        9U/gHUxQHXbxfiLBMkHBgyto7yF3giU/G29Avxhg7uXMiePOoUpYJkZ0ONNZE+Eb
        acSS24J9VMED9woImXA90EM/KrRBlBDj9Su7TqHPBeZI8QwzQ0hCtIa98arA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680670990; x=1680757390; bh=e+gJbS/xmkipT
        y+DJXQ/LEt1VqMwCQcF3ixZiuvDl4o=; b=agzfNsNVundHLD0gkUtMMz6Q1+3mv
        X3eg+1WbneFhLoUKY/T/l+tPVZJ0gY/y8A1kqsonTfcyust8COJOffNc22jGep2x
        rx8fV2ozwyj7gL7LANr9jUU927ZsK9se3nL3t9foQAMqmURqKhAyFdpVWTMRUgH2
        yjJhjllO2YFraXbd1iwlVAy2Lf99mRW5IU9jAAjXsUNgY7mdotHh3tjU3LHlpFvP
        ZaTbICUl30du8CN/LyDAaB83BhMiToTgUjGyHXLIgEexHYM6JHwq8BYyEp5/IrUy
        4uaj4OMENpogvw4Im1TBvD/TGmDgf05pw5WF2M6m1O4mPNhV5H3WONobQ==
X-ME-Sender: <xms:DgEtZGYG5qXBnbJ2fiLaKlma-PmrKzL1TFKLGT3Mq8cM6NDZfRU3zg>
    <xme:DgEtZJZ5ru5GY7l_FFrRWsYcIe2FYu_YesnPNtTinoP9w5HatbrVAhqhbMT6xen1Y
    4ea5UW3DzkhiyCv4_w>
X-ME-Received: <xmr:DgEtZA_hLoOaEcGh4MJ_RmU5a1jWna1KqHAGHRZ3KFn-Verk-86D3BWoLxRAeKvAgLlOoUNXSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdejtddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    evufffkffoggfgsedtkeertdertddtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhi
    shhhkhhinhcuoehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrg
    htthgvrhhnpeevjeetfeeftefhffelvefgteelieehveehgeeltdettedvtdekffelgeeg
    iedtveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hvlhgrughimhhirhesnhhikhhishhhkhhinhdrphif
X-ME-Proxy: <xmx:DgEtZIq54LlP5Zre51eHbfBEelcWzmu-sr7DMCNpxvSe8rjMjO9_Zg>
    <xmx:DgEtZBrA3P5Jh0z3SxjDVd_3rDqHOZdT2lg6wwa-6d4hWBoEhxangA>
    <xmx:DgEtZGTDc_3tL7Rzo60Zmj6eSMunYw1mjGuUt03cwUP6isQYN1dSTQ>
    <xmx:DgEtZCR30Ymq6dDujg40-R5u4g2CrC2nL5b4N2hcomoyPOh2Z1OeuA>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Apr 2023 01:03:06 -0400 (EDT)
From:   Vladimir Nikishkin <vladimir@nikishkin.pw>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
        gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
        liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com,
        Vladimir Nikishkin <vladimir@nikishkin.pw>
Subject: [PATCH iproute2-next v2 v1] ip-link: add support for nolocalbypass in vxlan
Date:   Wed,  5 Apr 2023 13:03:00 +0800
Message-Id: <20230405050300.17303-1-vladimir@nikishkin.pw>
X-Mailer: git-send-email 2.35.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add userspace support for the nolocalbypass vxlan netlink
attribute. With nolocalbypass, if an entry is pointing to the
local machine, but the system driver is not listening on this
port, the driver will not drop packets, but will forward them
to the userspace network stack instead.

Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
---
 ip/iplink_vxlan.c     | 19 +++++++++++++++++++
 man/man8/ip-link.8.in |  8 ++++++++
 2 files changed, 27 insertions(+)

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
index c8c65657..c78dc9dd 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -623,6 +623,8 @@ the following additional arguments are supported:
 ] [
 .RB [ no ] udpcsum
 ] [
+.RB [ no ] localbypass
+] [
 .RB [ no ] udp6zerocsumtx
 ] [
 .RB [ no ] udp6zerocsumrx
@@ -727,6 +729,12 @@ are entered into the VXLAN device forwarding database.
 .RB [ no ] udpcsum
 - specifies if UDP checksum is calculated for transmitted packets over IPv4.
 
+.sp
+.RB [ no ] localbypass
+- if fdb destination is local, but there is no corresponding vni, forward packets
+to the userspace network stack. Supposedly, there may be a userspace process
+listening for these packets.
+
 .sp
 .RB [ no ] udp6zerocsumtx
 - skip UDP checksum calculation for transmitted packets over IPv6.
-- 
2.35.7

--
Fastmail.

