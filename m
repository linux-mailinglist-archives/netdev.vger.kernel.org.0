Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007061DF845
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 18:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgEWQfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 12:35:37 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47251 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728432AbgEWQfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 12:35:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590251733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hhM1Y+MGoqAFJ3IpHPrfoR0yN6XQba9p+73PbXVQYSE=;
        b=JNhYqfe0fqojUQDNMF4jnTts+gBTeY9mh0wXePV2XH56Pp5uZD1AiUHqkcLLebHX8Gz8mc
        gqOMfpQMq0Zf9DW1shvTS+MFAysjbZm7fs6uWeFTVNHFvyFxeiVPGO8cYB8aKooHoqucBu
        46tnOEdAugpGATsURja1rS9HzSgDW48=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-FIQBcMIoP0WXDWu1vhzrOA-1; Sat, 23 May 2020 12:35:31 -0400
X-MC-Unique: FIQBcMIoP0WXDWu1vhzrOA-1
Received: by mail-wr1-f72.google.com with SMTP id p2so5791108wrm.6
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 09:35:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hhM1Y+MGoqAFJ3IpHPrfoR0yN6XQba9p+73PbXVQYSE=;
        b=A3xqJzvM/D2KrjBtnxEkUJkQfqymLs/Ipbs9CCaJ6/UvyYNakNTYHjq1B50Ka22Y+7
         yVnyrS/3HhhZ/uOYhscQHq9XkRfkW8c2hhVI1aRRk0rba1YRxWHsd9CdPXMQ/IU6d2Vh
         9Z2qlLq/WyCLVtGlfwpy8Fo3U41WMJ7qyMLLC7X+6n0tqz5CUE25jSDYK9pqtUPBtmld
         pjzA/fECRGXIPUZVuV04sOFdMdouvwna5uqmumT37UH0S6elBrrsiKoDJswNtsJypr+R
         wDUk9O9j6ALr1JZCWNzXgc6LTDnbQiaZzHQB/hrrU3ATDr4kYIvddsfBGSuI+I1Oabz6
         L5PA==
X-Gm-Message-State: AOAM532blVO3k/r4PEcQxRVaaW8FLZQ2Q2UekQ31Hs/bduXl3kpenrNV
        VeEGG3aA+7ogJlHJQUqbk2hu29wOiizZ270azOvBNdZisnJ0Ks5MIalS+MNhqM9VPYjaFf0CaPc
        iBfvHZ1iX9ae6tXKF
X-Received: by 2002:a05:600c:2051:: with SMTP id p17mr1984527wmg.93.1590251730044;
        Sat, 23 May 2020 09:35:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnOsOP/fXLcouKK02kEpY8VzRhARM0NYN050cow2h/1nl+bEuWk+kMAADd5zka/BOqrp9yCA==
X-Received: by 2002:a05:600c:2051:: with SMTP id p17mr1984508wmg.93.1590251729607;
        Sat, 23 May 2020 09:35:29 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id v126sm14336058wma.9.2020.05.23.09.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 09:35:29 -0700 (PDT)
Date:   Sat, 23 May 2020 18:35:27 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Tom Herbert <tom@herbertland.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Liel Shoshan <liels@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>
Subject: Re: [PATCH net-next v2 0/2] flow_dissector, cls_flower: Add support
 for multiple MPLS Label Stack Entries
Message-ID: <20200523163527.GC20405@pc-3.home>
References: <cover.1590081480.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1590081480.git.gnault@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Dropping the @netronome.com addresses that bounce. ]

On Thu, May 21, 2020 at 07:47:12PM +0200, Guillaume Nault wrote:
> Currently, the flow dissector and the Flower classifier can only handle
> the first entry of an MPLS label stack. This patch series generalises
> the code to allow parsing and matching the Label Stack Entries that
> follow.
> 

Here's a draft patch, adding support for iproute2. I'll polish it and
submit it formally once the kernel part is merged.

It adds the new "mpls" keyword that can be used to match MPLS fields in
arbitrary Label Stack Entries.
LSEs are introduced by the "lse" keyword and followed by LSE options:
"depth", "label", "tc", "bos" and "ttl". The depth is manadtory but
other options are optionals.

For example, the following filter drops MPLS packets having two labels,
where the first label is 20 and has TTL 64 and the second label is 21:

$ tc filter add dev ethX ingress proto mpls_uc flower mpls \
    lse depth 1 label 20 ttl 64 \
    lse depth 2 label 21 bos 1 \
    action drop

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/uapi/linux/pkt_cls.h |  23 ++++
 man/man8/tc-flower.8         |  55 +++++++-
 tc/f_flower.c                | 244 ++++++++++++++++++++++++++++++++++-
 3 files changed, 317 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index fc672b23..7576209d 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -576,6 +576,8 @@ enum {
 	TCA_FLOWER_KEY_CT_LABELS,	/* u128 */
 	TCA_FLOWER_KEY_CT_LABELS_MASK,	/* u128 */
 
+	TCA_FLOWER_KEY_MPLS_OPTS,
+
 	__TCA_FLOWER_MAX,
 };
 
@@ -640,6 +642,27 @@ enum {
 #define TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX \
 		(__TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX - 1)
 
+enum {
+	TCA_FLOWER_KEY_MPLS_OPTS_UNSPEC,
+	TCA_FLOWER_KEY_MPLS_OPTS_LSE,
+	__TCA_FLOWER_KEY_MPLS_OPTS_MAX,
+};
+
+#define TCA_FLOWER_KEY_MPLS_OPTS_MAX (__TCA_FLOWER_KEY_MPLS_OPTS_MAX - 1)
+
+enum {
+	TCA_FLOWER_KEY_MPLS_OPT_LSE_UNSPEC,
+	TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH,
+	TCA_FLOWER_KEY_MPLS_OPT_LSE_TTL,
+	TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS,
+	TCA_FLOWER_KEY_MPLS_OPT_LSE_TC,
+	TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL,
+	__TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX,
+};
+
+#define TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX \
+		(__TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX - 1)
+
 enum {
 	TCA_FLOWER_KEY_FLAGS_IS_FRAGMENT = (1 << 0),
 	TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST = (1 << 1),
diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index b3dfcf68..a168fbfb 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -40,6 +40,8 @@ flower \- flow based traffic control filter
 .IR PRIORITY " | "
 .BR cvlan_ethtype " { " ipv4 " | " ipv6 " | "
 .IR ETH_TYPE " } | "
+.B mpls
+.IR LSE_LIST " | "
 .B mpls_label
 .IR LABEL " | "
 .B mpls_tc
@@ -90,7 +92,24 @@ flower \- flow based traffic control filter
 }
 .IR OPTIONS " | "
 .BR ip_flags
-.IR IP_FLAGS
+.IR IP_FLAGS " } "
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
@@ -176,6 +195,40 @@ Match on QinQ layer three protocol.
 may be either
 .BR ipv4 ", " ipv6
 or an unsigned 16bit value in hexadecimal format.
+
+.TP
+.BI mpls " LSE_LIST"
+Match an MPLS label stack.
+.I LSE_LIST
+is a list of Label Stack Entries, each introduced by the
+.BR lse " keyword."
+This is incompatible with the standalone
+.BR mpls_label ", " mpls_tc ", " mpls_bos " and " mpls_ttl " options."
+.RS
+.TP
+.BI lse " LSE_OPTIONS"
+Match an MPLS Label Stack Entry.
+.RS
+.TP
+.BI depth " DEPTH"
+The depth of the Label Stack Entry to consider. Depth starts at 1 (the
+outermost Label Stack Entry). The maximum usable depth may be limitted by the
+kernel. This option is mandatory.
+.TP
+.BI label " LABEL"
+Match the label id.
+.TP
+.BI tc " TC"
+Match the Traffic Class.
+.TP
+.BI bos " BOS"
+Match the Bottom Of Stack.
+.TP
+.BI ttl " TTL"
+Match the Time To Live.
+.RE
+.RE
+
 .TP
 .BI mpls_label " LABEL"
 Match the label id in the outermost MPLS label stack entry.
diff --git a/tc/f_flower.c b/tc/f_flower.c
index fc136911..1707812e 100644
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
@@ -1199,11 +1202,139 @@ static int flower_parse_enc_opts_erspan(char *str, struct nlmsghdr *n)
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
+	if (argc <= 0) {
+		fprintf(stderr, "Not enough information: \"label\", \"tc\", \"bos\" or \"ttl\" argument is required.\n");
+		return -1;
+	}
+
+	lse_attr = addattr_nest(nlh, MAX_MSG, TCA_FLOWER_KEY_MPLS_OPTS_LSE | NLA_F_NESTED);
+
+	while (argc > 0) {
+		if (strcmp(*argv, "depth") == 0) {
+			NEXT_ARG();
+			ret = get_u8(&depth, *argv, 0);
+			if (ret < 0 || depth < 1) {
+				fprintf(stderr, "Illegal \"depth\"\n");
+				return -1;
+			}
+			addattr8(nlh, MAX_MSG,
+				 TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH, depth);
+		} else if (strcmp(*argv, "label") == 0) {
+			__u32 label;
+
+			NEXT_ARG();
+			ret = get_u32(&label, *argv, 0);
+			if (ret < 0 ||
+			    label & ~(MPLS_LS_LABEL_MASK >> MPLS_LS_LABEL_SHIFT)) {
+				fprintf(stderr, "Illegal \"label\"\n");
+				return -1;
+			}
+			addattr32(nlh, MAX_MSG,
+				  TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL, label);
+		} else if (strcmp(*argv, "tc") == 0) {
+			__u8 tc;
+
+			NEXT_ARG();
+			ret = get_u8(&tc, *argv, 0);
+			if (ret < 0 ||
+			    tc & ~(MPLS_LS_TC_MASK >> MPLS_LS_TC_SHIFT)) {
+				fprintf(stderr, "Illegal \"tc\"\n");
+				return -1;
+			}
+			addattr8(nlh, MAX_MSG, TCA_FLOWER_KEY_MPLS_OPT_LSE_TC,
+				 tc);
+		} else if (strcmp(*argv, "bos") == 0) {
+			__u8 bos;
+
+			NEXT_ARG();
+			ret = get_u8(&bos, *argv, 0);
+			if (ret < 0 || bos & ~(MPLS_LS_S_MASK >> MPLS_LS_S_SHIFT)) {
+				fprintf(stderr, "Illegal \"bos\"\n");
+				return -1;
+			}
+			addattr8(nlh, MAX_MSG, TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS,
+				 bos);
+		} else if (strcmp(*argv, "ttl") == 0) {
+			__u8 ttl;
+
+			NEXT_ARG();
+
+			ret = get_u8(&ttl, *argv, 0);
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
+	if (argc <= 0) {
+		fprintf(stderr, "Not enough information: \"depth\" argument is required.\n");
+		return -1;
+	}
+
+	mpls_attr = addattr_nest(nlh, MAX_MSG, TCA_FLOWER_KEY_MPLS_OPTS | NLA_F_NESTED);
+
+	while (argc > 0) {
+		if (strcmp(*argv, "lse") == 0) {
+
+			NEXT_ARG();
+			if (flower_parse_mpls_lse(&argc, &argv, nlh) < 0)
+				return -1;
+			continue;
+		} else {
+			break;
+		}
+		argc--; argv++;
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
@@ -1381,6 +1512,23 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
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
 
@@ -1391,7 +1539,13 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 					"Can't set \"mpls_label\" if ethertype isn't MPLS\n");
 				return -1;
 			}
-			ret = get_u32(&label, *argv, 10);
+			if (mpls_format_new) {
+				fprintf(stderr,
+					"Can't set \"mpls_label\" if \"mpls\" is set\n");
+				return -1;
+			}
+			mpls_format_old = true;
+			ret = get_u32(&label, *argv, 0);
 			if (ret < 0 || label & ~(MPLS_LS_LABEL_MASK >> MPLS_LS_LABEL_SHIFT)) {
 				fprintf(stderr, "Illegal \"mpls_label\"\n");
 				return -1;
@@ -1407,7 +1561,13 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 					"Can't set \"mpls_tc\" if ethertype isn't MPLS\n");
 				return -1;
 			}
-			ret = get_u8(&tc, *argv, 10);
+			if (mpls_format_new) {
+				fprintf(stderr,
+					"Can't set \"mpls_tc\" if \"mpls\" is set\n");
+				return -1;
+			}
+			mpls_format_old = true;
+			ret = get_u8(&tc, *argv, 0);
 			if (ret < 0 || tc & ~(MPLS_LS_TC_MASK >> MPLS_LS_TC_SHIFT)) {
 				fprintf(stderr, "Illegal \"mpls_tc\"\n");
 				return -1;
@@ -1423,7 +1583,13 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 					"Can't set \"mpls_bos\" if ethertype isn't MPLS\n");
 				return -1;
 			}
-			ret = get_u8(&bos, *argv, 10);
+			if (mpls_format_new) {
+				fprintf(stderr,
+					"Can't set \"mpls_bos\" if \"mpls\" is set\n");
+				return -1;
+			}
+			mpls_format_old = true;
+			ret = get_u8(&bos, *argv, 0);
 			if (ret < 0 || bos & ~(MPLS_LS_S_MASK >> MPLS_LS_S_SHIFT)) {
 				fprintf(stderr, "Illegal \"mpls_bos\"\n");
 				return -1;
@@ -1439,7 +1605,13 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 					"Can't set \"mpls_ttl\" if ethertype isn't MPLS\n");
 				return -1;
 			}
-			ret = get_u8(&ttl, *argv, 10);
+			if (mpls_format_new) {
+				fprintf(stderr,
+					"Can't set \"mpls_ttl\" if \"mpls\" is set\n");
+				return -1;
+			}
+			mpls_format_old = true;
+			ret = get_u8(&ttl, *argv, 0);
 			if (ret < 0 || ttl & ~(MPLS_LS_TTL_MASK >> MPLS_LS_TTL_SHIFT)) {
 				fprintf(stderr, "Illegal \"mpls_ttl\"\n");
 				return -1;
@@ -2316,6 +2488,69 @@ static void flower_print_u32(const char *name, struct rtattr *attr)
 	print_uint(PRINT_ANY, name, namefrm, rta_getattr_u32(attr));
 }
 
+static void flower_print_mpls_opt_lse(const char *name, struct rtattr *lse)
+{
+	struct rtattr *tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1];
+	struct rtattr *attr;
+
+	if (lse->rta_type != (TCA_FLOWER_KEY_MPLS_OPTS_LSE | NLA_F_NESTED)) {
+		printf("rta_type 0x%x, expeting 0x%x (0x%x & 0x%x)\n",
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
+		if (lse->rta_type & NLA_F_NESTED)
+			flower_print_mpls_opt_lse("    lse", lse);
+		else
+			printf("rta_type 0x%x (no NLA_F_NESTED)\n", lse->rta_type);
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
@@ -2430,6 +2665,7 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 	flower_print_ip_attr("ip_ttl", tb[TCA_FLOWER_KEY_IP_TTL],
 			    tb[TCA_FLOWER_KEY_IP_TTL_MASK]);
 
+	flower_print_mpls_opts("  mpls", tb[TCA_FLOWER_KEY_MPLS_OPTS]);
 	flower_print_u32("mpls_label", tb[TCA_FLOWER_KEY_MPLS_LABEL]);
 	flower_print_u8("mpls_tc", tb[TCA_FLOWER_KEY_MPLS_TC]);
 	flower_print_u8("mpls_bos", tb[TCA_FLOWER_KEY_MPLS_BOS]);
-- 
2.21.1

