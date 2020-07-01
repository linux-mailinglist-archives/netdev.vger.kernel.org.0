Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DDE2113E0
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 21:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgGATt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 15:49:27 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39988 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725771AbgGATt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 15:49:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593632964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=X5kxlBKm7ppar/j05UGP0OVwW28Xk/+y0/0xnYVWrEE=;
        b=HCupR5TFh/V1OXdM0lgOgNeux5aZsCaJ4P2wYprlHO8vA+vhWOUxSFe6sY4c2Z2bXrdxPB
        2NNBfXik8fChToLbNPB2T/9Nd2RkD8QyUs5R0iX2ZEiaVTk7ejJPdBLvbAUpApfKgEd2Ha
        xzq8hadk6cMMYz686/zLyC+pdvfGcjU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-rlmXyjCgO-2O0JO5KxKcyg-1; Wed, 01 Jul 2020 15:49:22 -0400
X-MC-Unique: rlmXyjCgO-2O0JO5KxKcyg-1
Received: by mail-wm1-f71.google.com with SMTP id v11so6314724wmb.1
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 12:49:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=X5kxlBKm7ppar/j05UGP0OVwW28Xk/+y0/0xnYVWrEE=;
        b=NwoyPiqdtBVonqSVB+9OYOMHv+3VNjfDGffkuVl7q1u+d6eF0MtJ0xzEnkqIwK7QeN
         kC1YGWpik/DBIaZdUeOLTpPaDMhs9b3O4wJ4HQp5yscu4b1KV8gUHA33Z/+zl19p9Rss
         d0hmdnUQNKeE4VLt0YChIH2JuhjVi4GEbRJnB/txmgPKB6zjc63Mo3TxCPF1wc2FAdle
         0K2CSU5+7PS/+mbpExuVJndsM3bRYFsEgty3cLpZM57bsuuVozvrRcJtPGdOfF86L0BJ
         dS7/iW+TP4BOlABDJJbdUcTCGkiUOPwc3UatHFvjAZKPv+Ysm0gMOemVfOKZ4c3JCFY2
         s8Tw==
X-Gm-Message-State: AOAM530G1lzSLfuW26DWnr0mRK50k02XS5JFgRLNvGr7kt47D4vp/TYH
        uTNtxO76J+SZCxOKE7w3kbpjKJ7SY0oKZoZ19RitZpQXS+KvlfEPvR/K0rHPdHUcVzRtkLXsI7l
        UKa1bYmjQ4uoqmY/A
X-Received: by 2002:a5d:4202:: with SMTP id n2mr27323222wrq.171.1593632960729;
        Wed, 01 Jul 2020 12:49:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4cVka9rg1VEkfqhI7XCmJYD1JVqtFmScqjmXtLG++NHnaOFRpxwXs3aiFKe/Tmwk8KUyzpg==
X-Received: by 2002:a5d:4202:: with SMTP id n2mr27323209wrq.171.1593632960365;
        Wed, 01 Jul 2020 12:49:20 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id e25sm8684078wrc.69.2020.07.01.12.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 12:49:19 -0700 (PDT)
Date:   Wed, 1 Jul 2020 21:49:18 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Andrea Claudi <aclaudi@redhat.com>
Subject: [PATCH iproute2 v2] tc: flower: support multiple MPLS LSE match
Message-ID: <4c59a4a8f59184be8ee48fec5bfe4e1310c34761.1593598030.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the new "mpls" keyword that can be used to match MPLS fields in
arbitrary Label Stack Entries.
LSEs are introduced by the "lse" keyword and followed by LSE options:
"depth", "label", "tc", "bos" and "ttl". The depth is manadtory, the
other options are optionals.

For example, the following filter drops MPLS packets having two labels,
where the first label is 21 and has TTL 64 and the second label is 22:

$ tc filter add dev ethX ingress proto mpls_uc flower mpls \
    lse depth 1 label 21 ttl 64 \
    lse depth 2 label 22 bos 1 \
    action drop

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 man/man8/tc-flower.8 |  73 +++++++++++++-
 tc/f_flower.c        | 221 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 292 insertions(+), 2 deletions(-)

v2: s/limitted/limited/ in man page.

diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index 4d32ff1b..b5bcfd1d 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -46,6 +46,8 @@ flower \- flow based traffic control filter
 .IR PRIORITY " | "
 .BR cvlan_ethtype " { " ipv4 " | " ipv6 " | "
 .IR ETH_TYPE " } | "
+.B mpls
+.IR LSE_LIST " | "
 .B mpls_label
 .IR LABEL " | "
 .B mpls_tc
@@ -96,7 +98,24 @@ flower \- flow based traffic control filter
 }
 .IR OPTIONS " | "
 .BR ip_flags
-.IR IP_FLAGS
+.IR IP_FLAGS " }"
+
+.ti -8
+.IR LSE_LIST " := [ " LSE_LIST " ] " LSE
+
+.ti -8
+.IR LSE " := "
+.B lse depth
+.IR DEPTH " { "
+.B label
+.IR LABEL " | "
+.B tc
+.IR TC " | "
+.B bos
+.IR BOS " | "
+.B ttl
+.IR TTL " }"
+
 .SH DESCRIPTION
 The
 .B flower
@@ -182,6 +201,56 @@ Match on QinQ layer three protocol.
 may be either
 .BR ipv4 ", " ipv6
 or an unsigned 16bit value in hexadecimal format.
+
+.TP
+.BI mpls " LSE_LIST"
+Match on the MPLS label stack.
+.I LSE_LIST
+is a list of Label Stack Entries, each introduced by the
+.BR lse " keyword."
+This option can't be used together with the standalone
+.BR mpls_label ", " mpls_tc ", " mpls_bos " and " mpls_ttl " options."
+.RS
+.TP
+.BI lse " LSE_OPTIONS"
+Match on an MPLS Label Stack Entry.
+.I LSE_OPTIONS
+is a list of options that describe the properties of the LSE to match.
+.RS
+.TP
+.BI depth " DEPTH"
+The depth of the Label Stack Entry to consider. Depth starts at 1 (the
+outermost Label Stack Entry). The maximum usable depth may be limited by the
+kernel. This option is mandatory.
+.I DEPTH
+is an unsigned 8 bit value in decimal format.
+.TP
+.BI label " LABEL"
+Match on the MPLS Label field at the specified
+.BR depth .
+.I LABEL
+is an unsigned 20 bit value in decimal format.
+.TP
+.BI tc " TC"
+Match on the MPLS Traffic Class field at the specified
+.BR depth .
+.I TC
+is an unsigned 3 bit value in decimal format.
+.TP
+.BI bos " BOS"
+Match on the MPLS Bottom Of Stack field at the specified
+.BR depth .
+.I BOS
+is a 1 bit value in decimal format.
+.TP
+.BI ttl " TTL"
+Match on the MPLS Time To Live field at the specified
+.BR depth .
+.I TTL
+is an unsigned 8 bit value in decimal format.
+.RE
+.RE
+
 .TP
 .BI mpls_label " LABEL"
 Match the label id in the outermost MPLS label stack entry.
@@ -393,7 +462,7 @@ on the matches of the next lower layer. Precisely, layer one and two matches
 (\fBindev\fR,  \fBdst_mac\fR and \fBsrc_mac\fR)
 have no dependency,
 MPLS and layer three matches
-(\fBmpls_label\fR, \fBmpls_tc\fR, \fBmpls_bos\fR, \fBmpls_ttl\fR,
+(\fBmpls\fR, \fBmpls_label\fR, \fBmpls_tc\fR, \fBmpls_bos\fR, \fBmpls_ttl\fR,
 \fBip_proto\fR, \fBdst_ip\fR, \fBsrc_ip\fR, \fBarp_tip\fR, \fBarp_sip\fR,
 \fBarp_op\fR, \fBarp_tha\fR, \fBarp_sha\fR and \fBip_flags\fR)
 depend on the
diff --git a/tc/f_flower.c b/tc/f_flower.c
index fc136911..00c919fd 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -59,6 +59,7 @@ static void explain(void)
 		"			ip_proto [tcp | udp | sctp | icmp | icmpv6 | IP-PROTO ] |\n"
 		"			ip_tos MASKED-IP_TOS |\n"
 		"			ip_ttl MASKED-IP_TTL |\n"
+		"			mpls LSE-LIST |\n"
 		"			mpls_label LABEL |\n"
 		"			mpls_tc TC |\n"
 		"			mpls_bos BOS |\n"
@@ -89,6 +90,8 @@ static void explain(void)
 		"			ct_label MASKED_CT_LABEL |\n"
 		"			ct_mark MASKED_CT_MARK |\n"
 		"			ct_zone MASKED_CT_ZONE }\n"
+		"	LSE-LIST := [ LSE-LIST ] LSE\n"
+		"	LSE := lse depth DEPTH { label LABEL | tc TC | bos BOS | ttl TTL }\n"
 		"	FILTERID := X:Y:Z\n"
 		"	MASKED_LLADDR := { LLADDR | LLADDR/MASK | LLADDR/BITS }\n"
 		"	MASKED_CT_STATE := combination of {+|-} and flags trk,est,new\n"
@@ -1199,11 +1202,127 @@ static int flower_parse_enc_opts_erspan(char *str, struct nlmsghdr *n)
 	return 0;
 }
 
+static int flower_parse_mpls_lse(int *argc_p, char ***argv_p,
+				 struct nlmsghdr *nlh)
+{
+	struct rtattr *lse_attr;
+	char **argv = *argv_p;
+	int argc = *argc_p;
+	__u8 depth = 0;
+	int ret;
+
+	lse_attr = addattr_nest(nlh, MAX_MSG,
+				TCA_FLOWER_KEY_MPLS_OPTS_LSE | NLA_F_NESTED);
+
+	while (argc > 0) {
+		if (matches(*argv, "depth") == 0) {
+			NEXT_ARG();
+			ret = get_u8(&depth, *argv, 10);
+			if (ret < 0 || depth < 1) {
+				fprintf(stderr, "Illegal \"depth\"\n");
+				return -1;
+			}
+			addattr8(nlh, MAX_MSG,
+				 TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH, depth);
+		} else if (matches(*argv, "label") == 0) {
+			__u32 label;
+
+			NEXT_ARG();
+			ret = get_u32(&label, *argv, 10);
+			if (ret < 0 ||
+			    label & ~(MPLS_LS_LABEL_MASK >> MPLS_LS_LABEL_SHIFT)) {
+				fprintf(stderr, "Illegal \"label\"\n");
+				return -1;
+			}
+			addattr32(nlh, MAX_MSG,
+				  TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL, label);
+		} else if (matches(*argv, "tc") == 0) {
+			__u8 tc;
+
+			NEXT_ARG();
+			ret = get_u8(&tc, *argv, 10);
+			if (ret < 0 ||
+			    tc & ~(MPLS_LS_TC_MASK >> MPLS_LS_TC_SHIFT)) {
+				fprintf(stderr, "Illegal \"tc\"\n");
+				return -1;
+			}
+			addattr8(nlh, MAX_MSG, TCA_FLOWER_KEY_MPLS_OPT_LSE_TC,
+				 tc);
+		} else if (matches(*argv, "bos") == 0) {
+			__u8 bos;
+
+			NEXT_ARG();
+			ret = get_u8(&bos, *argv, 10);
+			if (ret < 0 || bos & ~(MPLS_LS_S_MASK >> MPLS_LS_S_SHIFT)) {
+				fprintf(stderr, "Illegal \"bos\"\n");
+				return -1;
+			}
+			addattr8(nlh, MAX_MSG, TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS,
+				 bos);
+		} else if (matches(*argv, "ttl") == 0) {
+			__u8 ttl;
+
+			NEXT_ARG();
+			ret = get_u8(&ttl, *argv, 10);
+			if (ret < 0 || ttl & ~(MPLS_LS_TTL_MASK >> MPLS_LS_TTL_SHIFT)) {
+				fprintf(stderr, "Illegal \"ttl\"\n");
+				return -1;
+			}
+			addattr8(nlh, MAX_MSG, TCA_FLOWER_KEY_MPLS_OPT_LSE_TTL,
+				 ttl);
+		} else {
+			break;
+		}
+		argc--; argv++;
+	}
+
+	if (!depth) {
+		missarg("depth");
+		return -1;
+	}
+
+	addattr_nest_end(nlh, lse_attr);
+
+	*argc_p = argc;
+	*argv_p = argv;
+
+	return 0;
+}
+
+static int flower_parse_mpls(int *argc_p, char ***argv_p, struct nlmsghdr *nlh)
+{
+	struct rtattr *mpls_attr;
+	char **argv = *argv_p;
+	int argc = *argc_p;
+
+	mpls_attr = addattr_nest(nlh, MAX_MSG,
+				 TCA_FLOWER_KEY_MPLS_OPTS | NLA_F_NESTED);
+
+	while (argc > 0) {
+		if (matches(*argv, "lse") == 0) {
+			NEXT_ARG();
+			if (flower_parse_mpls_lse(&argc, &argv, nlh) < 0)
+				return -1;
+		} else {
+			break;
+		}
+	}
+
+	addattr_nest_end(nlh, mpls_attr);
+
+	*argc_p = argc;
+	*argv_p = argv;
+
+	return 0;
+}
+
 static int flower_parse_opt(struct filter_util *qu, char *handle,
 			    int argc, char **argv, struct nlmsghdr *n)
 {
 	int ret;
 	struct tcmsg *t = NLMSG_DATA(n);
+	bool mpls_format_old = false;
+	bool mpls_format_new = false;
 	struct rtattr *tail;
 	__be16 eth_type = TC_H_MIN(t->tcm_info);
 	__be16 vlan_ethtype = 0;
@@ -1381,6 +1500,23 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 						 &cvlan_ethtype, n);
 			if (ret < 0)
 				return -1;
+		} else if (matches(*argv, "mpls") == 0) {
+			NEXT_ARG();
+			if (eth_type != htons(ETH_P_MPLS_UC) &&
+			    eth_type != htons(ETH_P_MPLS_MC)) {
+				fprintf(stderr,
+					"Can't set \"mpls\" if ethertype isn't MPLS\n");
+				return -1;
+			}
+			if (mpls_format_old) {
+				fprintf(stderr,
+					"Can't set \"mpls\" if \"mpls_label\", \"mpls_tc\", \"mpls_bos\" or \"mpls_ttl\" is set\n");
+				return -1;
+			}
+			mpls_format_new = true;
+			if (flower_parse_mpls(&argc, &argv, n) < 0)
+				return -1;
+			continue;
 		} else if (matches(*argv, "mpls_label") == 0) {
 			__u32 label;
 
@@ -1391,6 +1527,12 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 					"Can't set \"mpls_label\" if ethertype isn't MPLS\n");
 				return -1;
 			}
+			if (mpls_format_new) {
+				fprintf(stderr,
+					"Can't set \"mpls_label\" if \"mpls\" is set\n");
+				return -1;
+			}
+			mpls_format_old = true;
 			ret = get_u32(&label, *argv, 10);
 			if (ret < 0 || label & ~(MPLS_LS_LABEL_MASK >> MPLS_LS_LABEL_SHIFT)) {
 				fprintf(stderr, "Illegal \"mpls_label\"\n");
@@ -1407,6 +1549,12 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 					"Can't set \"mpls_tc\" if ethertype isn't MPLS\n");
 				return -1;
 			}
+			if (mpls_format_new) {
+				fprintf(stderr,
+					"Can't set \"mpls_tc\" if \"mpls\" is set\n");
+				return -1;
+			}
+			mpls_format_old = true;
 			ret = get_u8(&tc, *argv, 10);
 			if (ret < 0 || tc & ~(MPLS_LS_TC_MASK >> MPLS_LS_TC_SHIFT)) {
 				fprintf(stderr, "Illegal \"mpls_tc\"\n");
@@ -1423,6 +1571,12 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 					"Can't set \"mpls_bos\" if ethertype isn't MPLS\n");
 				return -1;
 			}
+			if (mpls_format_new) {
+				fprintf(stderr,
+					"Can't set \"mpls_bos\" if \"mpls\" is set\n");
+				return -1;
+			}
+			mpls_format_old = true;
 			ret = get_u8(&bos, *argv, 10);
 			if (ret < 0 || bos & ~(MPLS_LS_S_MASK >> MPLS_LS_S_SHIFT)) {
 				fprintf(stderr, "Illegal \"mpls_bos\"\n");
@@ -1439,6 +1593,12 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 					"Can't set \"mpls_ttl\" if ethertype isn't MPLS\n");
 				return -1;
 			}
+			if (mpls_format_new) {
+				fprintf(stderr,
+					"Can't set \"mpls_ttl\" if \"mpls\" is set\n");
+				return -1;
+			}
+			mpls_format_old = true;
 			ret = get_u8(&ttl, *argv, 10);
 			if (ret < 0 || ttl & ~(MPLS_LS_TTL_MASK >> MPLS_LS_TTL_SHIFT)) {
 				fprintf(stderr, "Illegal \"mpls_ttl\"\n");
@@ -2316,6 +2476,66 @@ static void flower_print_u32(const char *name, struct rtattr *attr)
 	print_uint(PRINT_ANY, name, namefrm, rta_getattr_u32(attr));
 }
 
+static void flower_print_mpls_opt_lse(const char *name, struct rtattr *lse)
+{
+	struct rtattr *tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1];
+	struct rtattr *attr;
+
+	if (lse->rta_type != (TCA_FLOWER_KEY_MPLS_OPTS_LSE | NLA_F_NESTED)) {
+		fprintf(stderr, "rta_type 0x%x, expecting 0x%x (0x%x & 0x%x)\n",
+		       lse->rta_type,
+		       TCA_FLOWER_KEY_MPLS_OPTS_LSE & NLA_F_NESTED,
+		       TCA_FLOWER_KEY_MPLS_OPTS_LSE, NLA_F_NESTED);
+		return;
+	}
+
+	parse_rtattr(tb, TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX, RTA_DATA(lse),
+		     RTA_PAYLOAD(lse));
+
+	print_nl();
+	open_json_array(PRINT_ANY, name);
+	attr = tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH];
+	if (attr)
+		print_hhu(PRINT_ANY, "depth", " depth %u",
+			  rta_getattr_u8(attr));
+	attr = tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL];
+	if (attr)
+		print_uint(PRINT_ANY, "label", " label %u",
+			   rta_getattr_u32(attr));
+	attr = tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_TC];
+	if (attr)
+		print_hhu(PRINT_ANY, "tc", " tc %u", rta_getattr_u8(attr));
+	attr = tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS];
+	if (attr)
+		print_hhu(PRINT_ANY, "bos", " bos %u", rta_getattr_u8(attr));
+	attr = tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_TTL];
+	if (attr)
+		print_hhu(PRINT_ANY, "ttl", " ttl %u", rta_getattr_u8(attr));
+	close_json_array(PRINT_JSON, NULL);
+}
+
+static void flower_print_mpls_opts(const char *name, struct rtattr *attr)
+{
+	struct rtattr *lse;
+	int rem;
+
+	if (!attr || !(attr->rta_type & NLA_F_NESTED))
+		return;
+
+	print_nl();
+	open_json_array(PRINT_ANY, name);
+	rem = RTA_PAYLOAD(attr);
+	lse = RTA_DATA(attr);
+	while (RTA_OK(lse, rem)) {
+		flower_print_mpls_opt_lse("    lse", lse);
+		lse = RTA_NEXT(lse, rem);
+	};
+	if (rem)
+		fprintf(stderr, "!!!Deficit %d, rta_len=%d\n",
+			rem, lse->rta_len);
+	close_json_array(PRINT_JSON, NULL);
+}
+
 static void flower_print_arp_op(const char *name,
 				struct rtattr *op_attr,
 				struct rtattr *mask_attr)
@@ -2430,6 +2650,7 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 	flower_print_ip_attr("ip_ttl", tb[TCA_FLOWER_KEY_IP_TTL],
 			    tb[TCA_FLOWER_KEY_IP_TTL_MASK]);
 
+	flower_print_mpls_opts("  mpls", tb[TCA_FLOWER_KEY_MPLS_OPTS]);
 	flower_print_u32("mpls_label", tb[TCA_FLOWER_KEY_MPLS_LABEL]);
 	flower_print_u8("mpls_tc", tb[TCA_FLOWER_KEY_MPLS_TC]);
 	flower_print_u8("mpls_bos", tb[TCA_FLOWER_KEY_MPLS_BOS]);
-- 
2.21.3

