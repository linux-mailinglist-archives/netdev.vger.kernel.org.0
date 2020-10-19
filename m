Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAAA5292A4B
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 17:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbgJSPXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 11:23:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59309 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729544AbgJSPXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 11:23:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603120994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sJwXmzzMyOw4qGH5eXtIWO50NChhci9hr6Ql5rqWahM=;
        b=eOjS1oV2dPk2sR9YgZ9x2rKuBHzBZEFBOCCMex3mVXHg65GS65TO3dS1w7W+BLq63sNSVs
        tQ3chrlE9YTemtw7SWz7/wRI7O1Nr2HCIN6HaM6QlyI5A10WFK9VeOhnvp5PFgx6Ex5TaS
        l9Jiu2DjlYgT6V2er18J90LWJuSgeWI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-PebY647mOkuKgg9J9_IZSQ-1; Mon, 19 Oct 2020 11:23:12 -0400
X-MC-Unique: PebY647mOkuKgg9J9_IZSQ-1
Received: by mail-wr1-f70.google.com with SMTP id h8so13508wrt.9
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 08:23:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sJwXmzzMyOw4qGH5eXtIWO50NChhci9hr6Ql5rqWahM=;
        b=EiBhyqOA6KFmGcH0usePmuNdTYfZVEpd/YVn1pAB9m1abjoIQfIJeDX9H+2pWdzhlQ
         hGtBo4Vds8RLtq3ZJftvKGeTS8VZO1yklFUhvU8fNVedNGc1OzGqkz6UMrMCXPIyXRfj
         Y2vsmcskLp/UtV6PSoDA35y3rXmjOWUnpDbq+wCxqglkqhieyMQrpTfsLVQJVVHOVT8k
         ptaRxWnKYKkdg95k+JEkAIVOK1uGWTR+zm6wFmzm09p3T26Pc3Ig+y9GJvLSpUeC7xAz
         X6LLYelyIDcduTfvYthYlG1GFWckJkDLoqEn+Wayju5P8Jh+12n3F/kl2benCRBHZfcj
         gpNw==
X-Gm-Message-State: AOAM5312mhbg7QbGBCIvExd9zWEfkamefQFntkE+7y+dibBsav6ygfkY
        S3X3DXJzmURZNiMeZWLRjUrDEQD8YBOuMVthJ4yMrLWDbMzqMu9ihIog9hQaijtMF9erofBkEoY
        F5UV5EY1mZDbLrpGM
X-Received: by 2002:a1c:c2c5:: with SMTP id s188mr56024wmf.174.1603120991386;
        Mon, 19 Oct 2020 08:23:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwID5Yn9kQdVwEZ4FemTZtKEfo9W8ftsXE9K3ydABcHVR8tLrJi3cEfZLAzta+ovhJfaZVegQ==
X-Received: by 2002:a1c:c2c5:: with SMTP id s188mr55996wmf.174.1603120991099;
        Mon, 19 Oct 2020 08:23:11 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id x21sm317443wmi.3.2020.10.19.08.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 08:23:10 -0700 (PDT)
Date:   Mon, 19 Oct 2020 17:23:08 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, martin.varghese@nokia.com
Subject: [PATCH v2 iproute2-next 2/2] m_mpls: add mac_push action
Message-ID: <1c2ba44853cc5db1107d38d541b56e8c78dabd04.1603120726.git.gnault@redhat.com>
References: <cover.1603120726.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1603120726.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the new TCA_MPLS_ACT_MAC_PUSH action (kernel commit
a45294af9e96 ("net/sched: act_mpls: Add action to push MPLS LSE before
Ethernet header")). This action let TC push an MPLS header before the
MAC header of a frame.

Example (encapsulate all outgoing frames with label 20, then add an
outer Ethernet header):
 # tc filter add dev ethX matchall \
       action mpls mac_push label 20 ttl 64 \
       action vlan push_eth dst_mac 0a:00:00:00:00:02 \
                            src_mac 0a:00:00:00:00:01

This patch also adds an alias for ETH_P_TEB, since it is useful when
decapsulating MPLS packets that contain an Ethernet frame.

With MAC_PUSH, there's no previous Ethertype to modify. However, the
"protocol" option is still needed, because the kernel uses it to set
skb->protocol. So rename can_modify_ethtype() to can_set_ethtype().

Also add a test suite for m_mpls, which covers the new action and the
pre-existing ones.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 lib/ll_proto.c            |  1 +
 man/man8/tc-mpls.8        | 44 +++++++++++++++++++++++--
 man/man8/tc-vlan.8        |  5 ++-
 tc/m_mpls.c               | 43 ++++++++++++++++--------
 testsuite/tests/tc/mpls.t | 69 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 145 insertions(+), 17 deletions(-)
 create mode 100755 testsuite/tests/tc/mpls.t

diff --git a/lib/ll_proto.c b/lib/ll_proto.c
index 2a0c1cb3..78179311 100644
--- a/lib/ll_proto.c
+++ b/lib/ll_proto.c
@@ -80,6 +80,7 @@ __PF(8021Q,802.1Q)
 __PF(8021AD,802.1ad)
 __PF(MPLS_UC,mpls_uc)
 __PF(MPLS_MC,mpls_mc)
+__PF(TEB,teb)
 
 { 0x8100, "802.1Q" },
 { 0x88cc, "LLDP" },
diff --git a/man/man8/tc-mpls.8 b/man/man8/tc-mpls.8
index 84ef2ef1..9e563e98 100644
--- a/man/man8/tc-mpls.8
+++ b/man/man8/tc-mpls.8
@@ -17,7 +17,7 @@ mpls - mpls manipulation module
 
 .ti -8
 .IR PUSH " := "
-.BR push " [ " protocol
+.RB "{ " push " | " mac_push " } [ " protocol
 .IR MPLS_PROTO " ]"
 .RB " [ " tc
 .IR MPLS_TC " ] "
@@ -64,7 +64,14 @@ requires no arguments and simply subtracts 1 from the MPLS header TTL field.
 Decapsulation mode. Requires the protocol of the next header.
 .TP
 .B push
-Encapsulation mode. Requires at least the
+Encapsulation mode. Adds the MPLS header between the MAC and the network
+headers. Requires at least the
+.B label
+option.
+.TP
+.B mac_push
+Encapsulation mode. Adds the MPLS header before the MAC header. Requires at
+least the
 .B label
 option.
 .TP
@@ -152,5 +159,36 @@ ip packets and output to eth1:
 .EE
 .RE
 
+Here is another example, where incoming Ethernet frames are encapsulated into
+MPLS with label 123 and TTL 64. Then, an outer Ethernet header is added and the
+resulting frame is finally sent on eth1:
+
+.RS
+.EX
+#tc qdisc add dev eth0 ingress
+#tc filter add dev eth0 ingress matchall \\
+	action mpls mac_push label 123 ttl 64 \\
+	action vlan push_eth \\
+		dst_mac 02:00:00:00:00:02 \\
+		src_mac 02:00:00:00:00:01 \\
+	action mirred egress redirect dev eth1
+.EE
+.RE
+
+The following example assumes that incoming MPLS packets with label 123
+transport Ethernet frames. The outer Ethernet and the MPLS headers are
+stripped, then the inner Ethernet frame is sent on eth1:
+
+.RS
+.EX
+#tc qdisc add dev eth0 ingress
+#tc filter add dev eth0 ingress protocol mpls_uc \\
+	flower mpls_label 123 mpls_bos 1 \\
+	action vlan pop_eth \\
+	action mpls pop protocol teb \\
+	action mirred egress redirect dev eth1
+.EE
+.RE
+
 .SH SEE ALSO
-.BR tc (8)
+.BR tc "(8), " tc-mirred "(8), " tc-vlan (8)
diff --git a/man/man8/tc-vlan.8 b/man/man8/tc-vlan.8
index 5c2808b1..264053d3 100644
--- a/man/man8/tc-vlan.8
+++ b/man/man8/tc-vlan.8
@@ -157,5 +157,8 @@ process then restarted for the plain packet:
 .EE
 .RE
 
+For an example of the
+.BR pop_eth " and " push_eth " modes, see " tc-mpls (8).
+
 .SH SEE ALSO
-.BR tc (8)
+.BR tc "(8), " tc-mpls (8)
diff --git a/tc/m_mpls.c b/tc/m_mpls.c
index 3d5d9b25..cb8019b1 100644
--- a/tc/m_mpls.c
+++ b/tc/m_mpls.c
@@ -17,6 +17,7 @@ static const char * const action_names[] = {
 	[TCA_MPLS_ACT_PUSH] = "push",
 	[TCA_MPLS_ACT_MODIFY] = "modify",
 	[TCA_MPLS_ACT_DEC_TTL] = "dec_ttl",
+	[TCA_MPLS_ACT_MAC_PUSH] = "mac_push",
 };
 
 static void explain(void)
@@ -25,9 +26,11 @@ static void explain(void)
 		"Usage: mpls pop [ protocol MPLS_PROTO ]\n"
 		"       mpls push [ protocol MPLS_PROTO ] [ label MPLS_LABEL ] [ tc MPLS_TC ]\n"
 		"                 [ ttl MPLS_TTL ] [ bos MPLS_BOS ] [CONTROL]\n"
+		"       mpls mac_push [ protocol MPLS_PROTO ] [ label MPLS_LABEL ] [ tc MPLS_TC ]\n"
+		"                     [ ttl MPLS_TTL ] [ bos MPLS_BOS ] [CONTROL]\n"
 		"       mpls modify [ label MPLS_LABEL ] [ tc MPLS_TC ] [ ttl MPLS_TTL ] [CONTROL]\n"
-		"           for pop MPLS_PROTO is next header of packet - e.g. ip or mpls_uc\n"
-		"           for push MPLS_PROTO is one of mpls_uc or mpls_mc\n"
+		"           for pop, MPLS_PROTO is next header of packet - e.g. ip or mpls_uc\n"
+		"           for push and mac_push, MPLS_PROTO is one of mpls_uc or mpls_mc\n"
 		"               with default: mpls_uc\n"
 		"       CONTROL := reclassify | pipe | drop | continue | pass |\n"
 		"                  goto chain <CHAIN_INDEX>\n");
@@ -41,12 +44,14 @@ static void usage(void)
 
 static bool can_modify_mpls_fields(unsigned int action)
 {
-	return action == TCA_MPLS_ACT_PUSH || action == TCA_MPLS_ACT_MODIFY;
+	return action == TCA_MPLS_ACT_PUSH || action == TCA_MPLS_ACT_MAC_PUSH ||
+		action == TCA_MPLS_ACT_MODIFY;
 }
 
-static bool can_modify_ethtype(unsigned int action)
+static bool can_set_ethtype(unsigned int action)
 {
-	return action == TCA_MPLS_ACT_PUSH || action == TCA_MPLS_ACT_POP;
+	return action == TCA_MPLS_ACT_PUSH || action == TCA_MPLS_ACT_MAC_PUSH ||
+		action == TCA_MPLS_ACT_POP;
 }
 
 static bool is_valid_label(__u32 label)
@@ -94,6 +99,10 @@ static int parse_mpls(struct action_util *a, int *argc_p, char ***argv_p,
 			if (check_double_action(action, *argv))
 				return -1;
 			action = TCA_MPLS_ACT_PUSH;
+		} else if (matches(*argv, "mac_push") == 0) {
+			if (check_double_action(action, *argv))
+				return -1;
+			action = TCA_MPLS_ACT_MAC_PUSH;
 		} else if (matches(*argv, "modify") == 0) {
 			if (check_double_action(action, *argv))
 				return -1;
@@ -104,31 +113,36 @@ static int parse_mpls(struct action_util *a, int *argc_p, char ***argv_p,
 			action = TCA_MPLS_ACT_DEC_TTL;
 		} else if (matches(*argv, "label") == 0) {
 			if (!can_modify_mpls_fields(action))
-				invarg("only valid for push/modify", *argv);
+				invarg("only valid for push, mac_push and modify",
+				       *argv);
 			NEXT_ARG();
 			if (get_u32(&label, *argv, 0) || !is_valid_label(label))
 				invarg("label must be <=0xFFFFF", *argv);
 		} else if (matches(*argv, "tc") == 0) {
 			if (!can_modify_mpls_fields(action))
-				invarg("only valid for push/modify", *argv);
+				invarg("only valid for push, mac_push and modify",
+				       *argv);
 			NEXT_ARG();
 			if (get_u8(&tc, *argv, 0) || (tc & ~0x7))
 				invarg("tc field is 3 bits max", *argv);
 		} else if (matches(*argv, "ttl") == 0) {
 			if (!can_modify_mpls_fields(action))
-				invarg("only valid for push/modify", *argv);
+				invarg("only valid for push, mac_push and modify",
+				       *argv);
 			NEXT_ARG();
 			if (get_u8(&ttl, *argv, 0) || !ttl)
 				invarg("ttl must be >0 and <=255", *argv);
 		} else if (matches(*argv, "bos") == 0) {
 			if (!can_modify_mpls_fields(action))
-				invarg("only valid for push/modify", *argv);
+				invarg("only valid for push, mac_push and modify",
+				       *argv);
 			NEXT_ARG();
 			if (get_u8(&bos, *argv, 0) || (bos & ~0x1))
 				invarg("bos must be 0 or 1", *argv);
 		} else if (matches(*argv, "protocol") == 0) {
-			if (!can_modify_ethtype(action))
-				invarg("only valid for push/pop", *argv);
+			if (!can_set_ethtype(action))
+				invarg("only valid for push, mac_push and pop",
+				       *argv);
 			NEXT_ARG();
 			if (ll_proto_a2n(&proto, *argv))
 				invarg("protocol is invalid", *argv);
@@ -159,10 +173,12 @@ static int parse_mpls(struct action_util *a, int *argc_p, char ***argv_p,
 	if (action == TCA_MPLS_ACT_PUSH && label == 0xffffffff)
 		missarg("label");
 
-	if (action == TCA_MPLS_ACT_PUSH && proto &&
+	if ((action == TCA_MPLS_ACT_PUSH || action == TCA_MPLS_ACT_MAC_PUSH) &&
+	    proto &&
 	    proto != htons(ETH_P_MPLS_UC) && proto != htons(ETH_P_MPLS_MC)) {
 		fprintf(stderr,
-			"invalid push protocol \"0x%04x\" - use mpls_(uc|mc)\n",
+			"invalid %spush protocol \"0x%04x\" - use mpls_(uc|mc)\n",
+			action == TCA_MPLS_ACT_MAC_PUSH ? "mac_" : "",
 			ntohs(proto));
 		return -1;
 	}
@@ -223,6 +239,7 @@ static int print_mpls(struct action_util *au, FILE *f, struct rtattr *arg)
 		}
 		break;
 	case TCA_MPLS_ACT_PUSH:
+	case TCA_MPLS_ACT_MAC_PUSH:
 		if (tb[TCA_MPLS_PROTO]) {
 			__u16 proto;
 
diff --git a/testsuite/tests/tc/mpls.t b/testsuite/tests/tc/mpls.t
new file mode 100755
index 00000000..cb25f361
--- /dev/null
+++ b/testsuite/tests/tc/mpls.t
@@ -0,0 +1,69 @@
+#!/bin/sh
+
+. lib/generic.sh
+
+DEV="$(rand_dev)"
+ts_ip "$0" "Add $DEV dummy interface" link add dev $DEV up type dummy
+ts_tc "$0" "Add ingress qdisc" qdisc add dev $DEV ingress
+
+reset_qdisc()
+{
+	ts_tc "$0" "Remove ingress qdisc" qdisc del dev $DEV ingress
+	ts_tc "$0" "Add ingress qdisc" qdisc add dev $DEV ingress
+}
+
+ts_tc "$0" "Add mpls action pop"                              \
+	filter add dev $DEV ingress protocol mpls_uc matchall \
+	action mpls pop protocol ip
+ts_tc "$0" "Show ingress filters" filter show dev $DEV ingress
+test_on "mpls"
+test_on "pop protocol ip pipe"
+
+reset_qdisc
+ts_tc "$0" "Add mpls action push"                        \
+	filter add dev $DEV ingress protocol ip matchall \
+	action mpls push protocol mpls_uc label 20 tc 3 bos 1 ttl 64
+ts_tc "$0" "Show ingress filters" filter show dev $DEV ingress
+test_on "mpls"
+test_on "push"
+test_on "protocol mpls_uc"
+test_on "label 20"
+test_on "tc 3"
+test_on "bos 1"
+test_on "ttl 64"
+test_on "pipe"
+
+reset_qdisc
+ts_tc "$0" "Add mpls action mac_push"        \
+	filter add dev $DEV ingress matchall \
+	action mpls mac_push protocol mpls_uc label 20 tc 3 bos 1 ttl 64
+ts_tc "$0" "Show ingress filters" filter show dev $DEV ingress
+test_on "mpls"
+test_on "mac_push"
+test_on "protocol mpls_uc"
+test_on "label 20"
+test_on "tc 3"
+test_on "bos 1"
+test_on "ttl 64"
+test_on "pipe"
+
+reset_qdisc
+ts_tc "$0" "Add mpls action modify"                           \
+	filter add dev $DEV ingress protocol mpls_uc matchall \
+	action mpls modify label 20 tc 3 ttl 64
+ts_tc "$0" "Show ingress filters" filter show dev $DEV ingress
+test_on "mpls"
+test_on "modify"
+test_on "label 20"
+test_on "tc 3"
+test_on "ttl 64"
+test_on "pipe"
+
+reset_qdisc
+ts_tc "$0" "Add mpls action dec_ttl"                          \
+	filter add dev $DEV ingress protocol mpls_uc matchall \
+	action mpls dec_ttl
+ts_tc "$0" "Show ingress filters" filter show dev $DEV ingress
+test_on "mpls"
+test_on "dec_ttl"
+test_on "pipe"
-- 
2.21.3

