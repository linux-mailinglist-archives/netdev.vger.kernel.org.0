Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451D36C5F66
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 07:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjCWGFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 02:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbjCWGFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 02:05:31 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0A827D71
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 23:05:15 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 5B85D3200923;
        Thu, 23 Mar 2023 02:05:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 23 Mar 2023 02:05:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1679551512; x=1679637912; bh=eicSvungqF
        ZvOs2KCetmQ0qyZ6lq0y8dWHlamvZXGq0=; b=Nde3glQpog2PfQsScLzHHxSndB
        R7wLK4Cq/+sXurUQQv47fCjrFA4Zwa3N4uKFqDzhXMxufGfrofrSFxbiI0mU2ZCE
        Eizb5TNwaj3wEvkCb8KFnTGMxCNYGmScVGH+B8CfQghcssuS7OqPL4IfPi2GzRB7
        ieGmKVvlDHpxhfr0LjQPm2hhFPeLWUHObrOifmgat4Yg8mmq/vysdv87PjEW2NmV
        WeCREXXf6J0X1tLyN2ONi9H1dmW032NgZGAHbDjyCzNLm3ee+3ADnQRhtXW8QxCD
        97nuK47/dnxuP+mL7JpPDNooYcidJhrxo4roCpmOe4lRhxoDY+DxqxpuRvrA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1679551512; x=1679637912; bh=eicSvungqFZvO
        s2KCetmQ0qyZ6lq0y8dWHlamvZXGq0=; b=mTmLlw2vg7HcIE+YPpUYWhhVKU8aM
        d8Cn/feSVjCM/qs5wb4jlQVFILIDa5agJczWjBpAxPjWld24HmMth4oSG7ssTbzw
        +oCSt7+BvXz1M+xVG+R1vILmHXh3A4U1ThGGKj9pHi/60tzsU+qHt5dKi8FlIEq6
        E+9lmSiDQ3MKggix6OyBi4F58y0xkM24LOv6qdvaftF6X2GmDrN+DJHk8UasyfVR
        JIxch43IRKfv8TB/mDVlXlLNlhNWa6yRR84rJfEYDmSqNlRUHZCt7aALevhqUfNd
        JWdQnNGTuDPMtZV1AZAT5uCy0I7cx5Fdbj/U4RLT0qPelOo6/3G9vu/WA==
X-ME-Sender: <xms:GOwbZAvGR4frAgID-lV4y2UJfYL3KF_pU4ATKhcqsvz47ERSPAmYFg>
    <xme:GOwbZNdQl3kw5skGh8NOskHpCeawZ70b98PTZyrlkubhmxDUkuwW70qBlmbBGak1D
    ttdEmz98F8bNsOxULE>
X-ME-Received: <xmr:GOwbZLztoqfuaNw2GpyFNj1njk6jBz2E8gXVwQi0OzcUsqCFLDZZVmyYsG369EYuf3JmNQ0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdegfedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    evufffkffoggfgsedtkeertdertddtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhi
    shhhkhhinhcuoehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrg
    htthgvrhhnpeevjeetfeeftefhffelvefgteelieehveehgeeltdettedvtdekffelgeeg
    iedtveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hvlhgrughimhhirhesnhhikhhishhhkhhinhdrphif
X-ME-Proxy: <xmx:GOwbZDONKThCWLcg4ix0L998mRtmDsou_Z6pi8DNbmP2fKoM-LElng>
    <xmx:GOwbZA-11N9xqArVwTFhY2brrPi7uv-OprHnftvyUxhjD0sDnEvveQ>
    <xmx:GOwbZLUt99TZAQRkn5FE82wtgOrwPWaYUUoVzONSI5pbpv1jKcmvuA>
    <xmx:GOwbZLUXuNXiXm8OYsnPe_3PNFdoYuRZREvVo24SP4w3m-sYz_zazQ>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Mar 2023 02:05:04 -0400 (EDT)
From:   Vladimir Nikishkin <vladimir@nikishkin.pw>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
        gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
        liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com,
        Vladimir Nikishkin <vladimir@nikishkin.pw>
Subject: [PATCH iproute2-next v1 1/1 v1] ip-link: add support for nolocalbypass in vxlan
Date:   Thu, 23 Mar 2023 14:04:51 +0800
Message-Id: <20230323060451.24280-1-vladimir@nikishkin.pw>
X-Mailer: git-send-email 2.35.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
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

This commit has a corresponding patch in the net-next list.

Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
---
 include/uapi/linux/if_link.h |  1 +
 ip/iplink_vxlan.c            | 18 ++++++++++++++++++
 man/man8/ip-link.8.in        |  8 ++++++++
 3 files changed, 27 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index d61bd32d..fd390b40 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -824,6 +824,7 @@ enum {
 	IFLA_VXLAN_TTL_INHERIT,
 	IFLA_VXLAN_DF,
 	IFLA_VXLAN_VNIFILTER, /* only applicable with COLLECT_METADATA mode */
+	IFLA_VXLAN_LOCALBYPASS,
 	__IFLA_VXLAN_MAX
 };
 #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index c7e0e1c4..17fa5cf7 100644
--- a/ip/iplink_vxlan.c
+++ b/ip/iplink_vxlan.c
@@ -276,6 +276,12 @@ static int vxlan_parse_opt(struct link_util *lu, int argc, char **argv,
 		} else if (!matches(*argv, "noudpcsum")) {
 			check_duparg(&attrs, IFLA_VXLAN_UDP_CSUM, *argv, *argv);
 			addattr8(n, 1024, IFLA_VXLAN_UDP_CSUM, 0);
+		} else if (!matches(*argv, "localbypass")) {
+			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS, *argv, *argv);
+			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 1);
+		} else if (!matches(*argv, "nolocalbypass")) {
+			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS, *argv, *argv);
+			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 0);
 		} else if (!matches(*argv, "udp6zerocsumtx")) {
 			check_duparg(&attrs, IFLA_VXLAN_UDP_ZERO_CSUM6_TX,
 				     *argv, *argv);
@@ -613,6 +619,18 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
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

