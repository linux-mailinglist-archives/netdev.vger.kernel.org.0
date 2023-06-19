Return-Path: <netdev+bounces-12084-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66F04735F44
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 23:35:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16B59280FDC
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 21:35:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E4E114A9B;
	Mon, 19 Jun 2023 21:35:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAEDBA38
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 21:35:37 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26958F
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:35:35 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9891c73e0fbso22063366b.1
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1687210534; x=1689802534;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=YCqkuISzxGGbo9rv//qf2fPi/65/0UczXIIviBW/bnM=;
        b=NskgOPBrRQXGBB2zQ5wWM6/QVvjQ7Sa36N4avM3C2xxzdKpjtFhaNdemFR0/OA8J5W
         mrG+g18njmfDxoh1ppbXJxLQFMmUW//YbMDy7BKyouZ84RuVkD5/rZYHMtSpQrbUzNyQ
         kDeGOL0QmdQj89Os/p0H4MfWzQ+pUv4YVYsy+A6jAVbavNwKk+8rnD+cwjeRQ9itsx/h
         XB/LgOC6BVEWD5QBSE0f88rv2OtnKoTo0w5pJbgpBh5cjJ8BGPkLQV2uJyiQFXwr9dGX
         JCAhBvsiu2dHU96WPOc+d47VmjJ9oBM+meX9rDfnaqzUiWmrTZZNsyeOft6bZTazvqHI
         lpCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687210534; x=1689802534;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YCqkuISzxGGbo9rv//qf2fPi/65/0UczXIIviBW/bnM=;
        b=k05xUA1V9DYtU/x1fPsk+D/3evkrdiGTByWNrrjO3TKRTZ4D6KeEyARvSKoiI8XfHu
         kDStXel5YGbxF2OXIPdjwNpCJKBAXz+5jP0NGC/kz65ceuCoQHkyUVz9pKkkQSn+ftur
         mpsZZwauFq3A/JlTndeHPnEMAVIbFZUEZDDQpGnENiKRAnkEX3R+pWFvqUmguwMjp7ex
         V8vlHrUORjyl0WR5E1isR/ReRvU3+jye+F/HpOMLuYpllYSG0BxkcqTE6qBfUCUBmBPp
         86XLmUTw/P8Exsgll8Q+tf0hubjOaqQvJgpHtXFjlmNSVbWLmeMeUJ3+1CSdQuInGB3L
         r1OA==
X-Gm-Message-State: AC+VfDyLCOL7eNjrgcOp0byRjYr7RA7q3fEHVmFhow7jpTrYlwqzfBXp
	OFOURoeSFngGPyrgcm+wXUySQ+277zsZhQ==
X-Google-Smtp-Source: ACHHUZ7LipzOck7h92/jFQtShznsW3MXz0xwAsDTl5mJoGVAPBmNN6iM+wwVxIC1m5bDXH1fLohSKA==
X-Received: by 2002:a17:907:d26:b0:977:d468:827 with SMTP id gn38-20020a1709070d2600b00977d4680827mr10648248ejc.17.1687210534001;
        Mon, 19 Jun 2023 14:35:34 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id gs2-20020a170906f18200b00982943c7892sm216038ejb.134.2023.06.19.14.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 14:35:33 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From: Zahari Doychev <zahari.doychev@linux.com>
To: netdev@vger.kernel.org
Cc: dsahern@gmail.com,
	stephen@networkplumber.org,
	hmehrtens@maxlinear.com,
	aleksander.lobakin@intel.com,
	simon.horman@corigine.com,
	idosch@idosch.org,
	Zahari Doychev <zdoychev@maxlinear.com>
Subject: [PATCH iproute2-next] f_flower: add cfm support
Date: Mon, 19 Jun 2023 23:35:23 +0200
Message-ID: <20230619213523.520800-1-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Zahari Doychev <zdoychev@maxlinear.com>

Add support for matching on CFM Maintenance Domain level and opcode.

  # tc filter add dev ens6 ingress pref 1 proto cfm \
       flower cfm op 1 mdl 5 action ok

  # tc filter show dev ens6 ingress
    filter protocol cfm pref 1 flower chain 0
    filter protocol cfm pref 1 flower chain 0 handle 0x1
      eth_type 8902
      cfm mdl 5 op 1
      not_in_hw
            action order 1: gact action pass
             random type none pass val 0
             index 1 ref 1 bind 1

  # tc -j -p filter show dev ens6 ingress
    [ {
            "protocol": "cfm",
            "pref": 1,
            "kind": "flower",
            "chain": 0
        },{
            "protocol": "cfm",
            "pref": 1,
            "kind": "flower",
            "chain": 0,
            "options": {
                "handle": 1,
                "keys": {
                    "eth_type": "8902",
                    "cfm": {
                        "mdl": 5,
                        "op": 1
                    }
                },
                "not_in_hw": true,
                "actions": [ {
                        "order": 1,
                        "kind": "gact",
                        "control_action": {
                            "type": "pass"
                        },
                        "prob": {
                            "random_type": "none",
                            "control_action": {
                                "type": "pass"
                            },
                            "val": 0
                        },
                        "index": 1,
                        "ref": 1,
                        "bind": 1
                    } ]
            }
        } ]

Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
---
 include/uapi/linux/pkt_cls.h |  9 ++++
 lib/ll_proto.c               |  1 +
 man/man8/tc-flower.8         | 29 ++++++++++-
 tc/f_flower.c                | 98 +++++++++++++++++++++++++++++++++++-
 4 files changed, 135 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 00933dda..7865f5a9 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -596,6 +596,8 @@ enum {
 
 	TCA_FLOWER_L2_MISS,		/* u8 */
 
+	TCA_FLOWER_KEY_CFM,		/* nested */
+
 	__TCA_FLOWER_MAX,
 };
 
@@ -704,6 +706,13 @@ enum {
 	TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST = (1 << 1),
 };
 
+enum {
+	TCA_FLOWER_KEY_CFM_OPT_UNSPEC,
+	TCA_FLOWER_KEY_CFM_MD_LEVEL,
+	TCA_FLOWER_KEY_CFM_OPCODE,
+	TCA_FLOWER_KEY_CFM_OPT_MAX,
+};
+
 #define TCA_FLOWER_MASK_FLAGS_RANGE	(1 << 0) /* Range-based match */
 
 /* Match-all classifier */
diff --git a/lib/ll_proto.c b/lib/ll_proto.c
index 526e582f..5aacb5b4 100644
--- a/lib/ll_proto.c
+++ b/lib/ll_proto.c
@@ -78,6 +78,7 @@ __PF(8021AD,802.1ad)
 __PF(MPLS_UC,mpls_uc)
 __PF(MPLS_MC,mpls_mc)
 __PF(TEB,teb)
+__PF(CFM,cfm)
 
 { 0x8100, "802.1Q" },
 { 0x88cc, "LLDP" },
diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index cd997450..83245813 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -102,7 +102,9 @@ flower \- flow based traffic control filter
 .BR ip_flags
 .IR IP_FLAGS " | "
 .B l2_miss
-.IR L2_MISS " }"
+.IR L2_MISS " | "
+.BR cfm
+.IR CFM_OPTIONS " }"
 
 .ti -8
 .IR LSE_LIST " := [ " LSE_LIST " ] " LSE
@@ -120,6 +122,13 @@ flower \- flow based traffic control filter
 .B ttl
 .IR TTL " }"
 
+.ti -8
+.IR CFM " := "
+.B cfm mdl
+.IR LEVEL " | "
+.B op
+.IR OPCODE "
+
 .SH DESCRIPTION
 The
 .B flower
@@ -496,11 +505,29 @@ fragmented packet. firstfrag can be used to indicate the first fragmented
 packet. nofirstfrag can be used to indicates subsequent fragmented packets
 or non-fragmented packets.
 .TP
+
 .BI l2_miss " L2_MISS"
 Match on layer 2 miss in the bridge driver's FDB / MDB. \fIL2_MISS\fR may be 0
 or 1. When 1, match on packets that encountered a layer 2 miss. When 0, match
 on packets that were forwarded using an FDB / MDB entry. Note that broadcast
 packets do not encounter a miss since a lookup is not performed for them.
+.TP
+
+.BI cfm " CFM_OPTIONS"
+Match on Connectivity Fault Management (CFM) fields.
+.I CFM_OPTIONS
+is a list of options that describe the properties of the CFM information
+fields to match.
+.RS
+.TP
+.BI mdl " LEVEL "
+Match on the Maintenance Domain (MD) level field.
+\fILEVEL\fR is an unsigned 3 bit value in decimal format.
+.TP
+.BI op " OPCODE "
+Match on the CFM opcode field. \fIOPCODE\fR is an unsigned 8 bit value in
+decimal format.
+
 .SH NOTES
 As stated above where applicable, matches of a certain layer implicitly depend
 on the matches of the next lower layer. Precisely, layer one and two matches
diff --git a/tc/f_flower.c b/tc/f_flower.c
index b9fe6afb..cfff36c0 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -96,12 +96,14 @@ static void explain(void)
 		"			ct_state MASKED_CT_STATE |\n"
 		"			ct_label MASKED_CT_LABEL |\n"
 		"			ct_mark MASKED_CT_MARK |\n"
-		"			ct_zone MASKED_CT_ZONE }\n"
+		"			ct_zone MASKED_CT_ZONE |\n"
+		"			cfm CFM }\n"
 		"	LSE-LIST := [ LSE-LIST ] LSE\n"
 		"	LSE := lse depth DEPTH { label LABEL | tc TC | bos BOS | ttl TTL }\n"
 		"	FILTERID := X:Y:Z\n"
 		"	MASKED_LLADDR := { LLADDR | LLADDR/MASK | LLADDR/BITS }\n"
 		"	MASKED_CT_STATE := combination of {+|-} and flags trk,est,new,rel,rpl,inv\n"
+		"	CFM := { mdl LEVEL | op OPCODE }\n"
 		"	ACTION-SPEC := ... look at individual actions\n"
 		"\n"
 		"NOTE:	CLASSID, IP-PROTO are parsed as hexadecimal input.\n"
@@ -1447,6 +1449,57 @@ static int flower_parse_mpls(int *argc_p, char ***argv_p, struct nlmsghdr *nlh)
 	return 0;
 }
 
+static int flower_parse_cfm(int *argc_p, char ***argv_p, __be16 eth_type,
+			    struct nlmsghdr *n)
+{
+	struct rtattr *cfm_attr;
+	char **argv = *argv_p;
+	int argc = *argc_p;
+	int ret;
+
+	if (eth_type != htons(ETH_P_CFM)) {
+		fprintf(stderr,
+			"Can't set attribute if ethertype isn't CFM\n");
+		return -1;
+	}
+
+	cfm_attr = addattr_nest(n, MAX_MSG, TCA_FLOWER_KEY_CFM | NLA_F_NESTED);
+
+	while (argc > 0) {
+		if (matches(*argv, "mdl") == 0) {
+			__u8 val;
+
+			NEXT_ARG();
+			ret = get_u8(&val, *argv, 10);
+			if (ret < 0) {
+				fprintf(stderr, "Illegal \"cfm md level\"\n");
+				return -1;
+			}
+			addattr8(n, MAX_MSG, TCA_FLOWER_KEY_CFM_MD_LEVEL, val);
+		} else if (matches(*argv, "op") == 0) {
+			__u8 val;
+
+			NEXT_ARG();
+			ret = get_u8(&val, *argv, 10);
+			if (ret < 0) {
+				fprintf(stderr, "Illegal \"cfm opcode\"\n");
+				return -1;
+			}
+			addattr8(n, MAX_MSG, TCA_FLOWER_KEY_CFM_OPCODE, val);
+		} else {
+			break;
+		}
+		argc--; argv++;
+	}
+
+	addattr_nest_end(n, cfm_attr);
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
@@ -2065,6 +2118,12 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 				return -1;
 			}
 			continue;
+		} else if (matches(*argv, "cfm") == 0) {
+			NEXT_ARG();
+			ret = flower_parse_cfm(&argc, &argv, eth_type, n);
+			if (ret < 0)
+				return -1;
+			continue;
 		} else {
 			if (strcmp(*argv, "help") != 0)
 				fprintf(stderr, "What is \"%s\"?\n", *argv);
@@ -2754,6 +2813,41 @@ static void flower_print_arp_op(const char *name,
 			       flower_print_arp_op_to_name);
 }
 
+static void flower_print_cfm(struct rtattr *attr)
+{
+	struct rtattr *tb[TCA_FLOWER_KEY_CFM_OPT_MAX + 1];
+	struct rtattr *v;
+	SPRINT_BUF(out);
+	size_t sz = 0;
+
+	if (!attr || !(attr->rta_type & NLA_F_NESTED))
+		return;
+
+	parse_rtattr(tb, TCA_FLOWER_KEY_CFM_OPT_MAX, RTA_DATA(attr),
+		     RTA_PAYLOAD(attr));
+
+	print_nl();
+	print_string(PRINT_FP, NULL, "  cfm", NULL);
+	open_json_object("cfm");
+
+	v = tb[TCA_FLOWER_KEY_CFM_MD_LEVEL];
+	if (v) {
+		sz += sprintf(out, " mdl %u", rta_getattr_u8(v));
+		print_hhu(PRINT_JSON, "mdl", NULL, rta_getattr_u8(v));
+
+	}
+
+	v = tb[TCA_FLOWER_KEY_CFM_OPCODE];
+	if (v) {
+		sprintf(out + sz, " op %u", rta_getattr_u8(v));
+		print_hhu(PRINT_JSON, "op", NULL, rta_getattr_u8(v));
+
+	}
+
+	close_json_object();
+	print_string(PRINT_FP, "cfm", "%s", out);
+}
+
 static int flower_print_opt(struct filter_util *qu, FILE *f,
 			    struct rtattr *opt, __u32 handle)
 {
@@ -3010,6 +3104,8 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 	flower_print_ct_label(tb[TCA_FLOWER_KEY_CT_LABELS],
 			      tb[TCA_FLOWER_KEY_CT_LABELS_MASK]);
 
+	flower_print_cfm(tb[TCA_FLOWER_KEY_CFM]);
+
 	close_json_object();
 
 	if (tb[TCA_FLOWER_FLAGS]) {
-- 
2.41.0


