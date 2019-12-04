Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7E7113838
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 00:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbfLDXaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 18:30:04 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:44212 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbfLDXaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 18:30:03 -0500
Received: by mail-pj1-f68.google.com with SMTP id w5so446179pjh.11
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 15:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x4ldvkcJR4BHODKfG7i7sIj0NkfUyHTNL1WyoZOjiMQ=;
        b=cu5jIFa0DgLNRTxro2rqr94C9Rltwkru5l1VNIum3NnZZStviFjgjHiqzZR2tsTEc0
         8tKdNvAeCzOOxZZjWBbOGfg65YT5hUAEWaamT+679Gf2jJ5p9dVNxaHmiuC2taRq5MjM
         /JKce6eFys/2MZuAcV7vLdVDR5wh4BE0f84CRhQeIB5focjjOVonxW45lJCTwd5UjO8n
         w0XhLdP6Siq80hutiwgp1VozNE7rIv5We5DcjbwGGOeQ0Ar8yGg6S7codeVotqp+OnvG
         3CCqPRW+2k5a0Irdd7JLSnK3pLHzXRG/NKLzBtLCWcTWclLxMYGQv6RwNPIV3i/Epgwy
         NjJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x4ldvkcJR4BHODKfG7i7sIj0NkfUyHTNL1WyoZOjiMQ=;
        b=PWuY8AHsXAPOMDe0zn+T7h02MSyYFjx6YSnzHZ0Ea348KVNRh/ujmBU2nLXe+o/Yld
         pfQFOMhTPvU83ZjdxvpLG5Qv3vkouR/LFIZ8ZgVV+g8gdZoZCfXs7eQEMfhOq9CQx1PS
         HppTwfDeoEhEjp/gEWbZVTBYRVTz1MACXkYwIlMQkCBZ6Golu2MpiPA6UvHFyZ5Uc01N
         +Q2BN7+OjUwgy1LDMfMgsnHcyrdxfR13SYmgVEnrrLiqGvSXZ0rd12optuS/hkphi4eC
         AtjevNghn3Qwnfj7bJGsLlEZ7OKwx2OdYJfkNF9/N7hvgW/F82pkkVmnhhV9I24rFd3l
         M7nA==
X-Gm-Message-State: APjAAAXcYbdGalKDnsVb9W7ha7eaMoJbfjGSFNNK4DIqBZ3eGPVSYEUG
        9ViaCcwb3RZad1JrjpIAMo70sQF9ghH8NA==
X-Google-Smtp-Source: APXvYqzn9tb5IfepCgvc7AMxFfwD6jcL7LOLfTj2HGXzbBwo2M6ExI5qC7hBbi9N1hid/PBzJVr/tA==
X-Received: by 2002:a17:902:c509:: with SMTP id o9mr5899515plx.112.1575502202212;
        Wed, 04 Dec 2019 15:30:02 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a3sm7451519pjh.31.2019.12.04.15.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 15:30:00 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next] tc: do not output newline in oneline mode
Date:   Wed,  4 Dec 2019 15:29:52 -0800
Message-Id: <20191204232952.30628-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In oneline mode the line seperator should be \
but several parts of tc aren't doing it right.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/f_flower.c     | 66 +++++++++++++++++++++++++++++++----------------
 tc/m_csum.c       |  4 +--
 tc/m_ct.c         |  5 ++--
 tc/m_gact.c       |  8 +++---
 tc/m_mirred.c     |  5 ++--
 tc/m_mpls.c       |  3 ++-
 tc/m_pedit.c      |  2 +-
 tc/m_simple.c     |  2 +-
 tc/m_tunnel_key.c |  3 ++-
 tc/m_vlan.c       |  5 ++--
 tc/m_xt.c         |  2 +-
 tc/q_cake.c       |  4 +--
 tc/q_fq_codel.c   |  3 ++-
 tc/tc_qdisc.c     |  2 +-
 14 files changed, 72 insertions(+), 42 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index a193c0eca22a..ce057a72cc7c 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -1624,7 +1624,8 @@ static void flower_print_eth_type(__be16 *p_eth_type,
 	else
 		sprintf(out, "%04x", ntohs(eth_type));
 
-	print_string(PRINT_ANY, "eth_type", "\n  eth_type %s", out);
+	print_nl();
+	print_string(PRINT_ANY, "eth_type", "  eth_type %s", out);
 	*p_eth_type = eth_type;
 }
 
@@ -1651,7 +1652,8 @@ static void flower_print_ip_proto(__u8 *p_ip_proto,
 	else
 		sprintf(out, "%02x", ip_proto);
 
-	print_string(PRINT_ANY, "ip_proto", "\n  ip_proto %s", out);
+	print_nl();
+	print_string(PRINT_ANY, "ip_proto", "  ip_proto %s", out);
 	*p_ip_proto = ip_proto;
 }
 
@@ -1682,7 +1684,8 @@ static void flower_print_matching_flags(char *name,
 			continue;
 		if (mtf_mask & flags_str[i].flag) {
 			if (++count == 1) {
-				print_string(PRINT_FP, NULL, "\n  %s ", name);
+				print_nl();
+				print_string(PRINT_FP, NULL, "  %s ", name);
 				open_json_object(name);
 			} else {
 				print_string(PRINT_FP, NULL, "/", NULL);
@@ -1829,7 +1832,8 @@ static void flower_print_ct_state(struct rtattr *flags_attr,
 					flower_ct_states[i].str);
 	}
 
-	print_string(PRINT_ANY, "ct_state", "\n  ct_state %s", out);
+	print_nl();
+	print_string(PRINT_ANY, "ct_state", "  ct_state %s", out);
 }
 
 static void flower_print_ct_label(struct rtattr *attr,
@@ -1864,7 +1868,8 @@ static void flower_print_ct_label(struct rtattr *attr,
 	}
 	*p = '\0';
 
-	print_string(PRINT_ANY, "ct_label", "\n  ct_label %s", out);
+	print_nl();
+	print_string(PRINT_ANY, "ct_label", "  ct_label %s", out);
 }
 
 static void flower_print_ct_zone(struct rtattr *attr,
@@ -1886,7 +1891,8 @@ static void flower_print_key_id(const char *name, struct rtattr *attr)
 	if (!attr)
 		return;
 
-	sprintf(namefrm,"\n  %s %%u", name);
+	print_nl();
+	sprintf(namefrm, "  %s %%u", name);
 	print_uint(PRINT_ANY, name, namefrm, rta_getattr_be32(attr));
 }
 
@@ -1934,7 +1940,7 @@ static void flower_print_geneve_opts(const char *name, struct rtattr *attr,
 static void flower_print_geneve_parts(const char *name, struct rtattr *attr,
 				      char *key, char *mask)
 {
-	char *namefrm = "\n  geneve_opt %s";
+	char *namefrm = "  geneve_opt %s";
 	char *key_token, *mask_token, *out;
 	int len;
 
@@ -1952,6 +1958,7 @@ static void flower_print_geneve_parts(const char *name, struct rtattr *attr,
 	}
 
 	out[len - 1] = '\0';
+	print_nl();
 	print_string(PRINT_FP, name, namefrm, out);
 	free(out);
 }
@@ -2015,7 +2022,8 @@ static void flower_print_masked_u8(const char *name, struct rtattr *attr,
 	if (mask != UINT8_MAX)
 		sprintf(out + done, "/%d", mask);
 
-	sprintf(namefrm,"\n  %s %%s", name);
+	print_nl();
+	sprintf(namefrm, "  %s %%s", name);
 	print_string(PRINT_ANY, name, namefrm, out);
 }
 
@@ -2031,7 +2039,8 @@ static void flower_print_u32(const char *name, struct rtattr *attr)
 	if (!attr)
 		return;
 
-	sprintf(namefrm,"\n  %s %%u", name);
+	print_nl();
+	sprintf(namefrm, "  %s %%u", name);
 	print_uint(PRINT_ANY, name, namefrm, rta_getattr_u32(attr));
 }
 
@@ -2086,14 +2095,16 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 	if (tb[TCA_FLOWER_KEY_VLAN_ID]) {
 		struct rtattr *attr = tb[TCA_FLOWER_KEY_VLAN_ID];
 
-		print_uint(PRINT_ANY, "vlan_id", "\n  vlan_id %u",
+		print_nl();
+		print_uint(PRINT_ANY, "vlan_id", "  vlan_id %u",
 			   rta_getattr_u16(attr));
 	}
 
 	if (tb[TCA_FLOWER_KEY_VLAN_PRIO]) {
 		struct rtattr *attr = tb[TCA_FLOWER_KEY_VLAN_PRIO];
 
-		print_uint(PRINT_ANY, "vlan_prio", "\n  vlan_prio %d",
+		print_nl();
+		print_uint(PRINT_ANY, "vlan_prio", "  vlan_prio %d",
 			   rta_getattr_u8(attr));
 	}
 
@@ -2101,7 +2112,8 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 		SPRINT_BUF(buf);
 		struct rtattr *attr = tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE];
 
-		print_string(PRINT_ANY, "vlan_ethtype", "\n  vlan_ethtype %s",
+		print_nl();
+		print_string(PRINT_ANY, "vlan_ethtype", "  vlan_ethtype %s",
 			     ll_proto_n2a(rta_getattr_u16(attr),
 			     buf, sizeof(buf)));
 	}
@@ -2109,14 +2121,16 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 	if (tb[TCA_FLOWER_KEY_CVLAN_ID]) {
 		struct rtattr *attr = tb[TCA_FLOWER_KEY_CVLAN_ID];
 
-		print_uint(PRINT_ANY, "cvlan_id", "\n  cvlan_id %u",
+		print_nl();
+		print_uint(PRINT_ANY, "cvlan_id", "  cvlan_id %u",
 			   rta_getattr_u16(attr));
 	}
 
 	if (tb[TCA_FLOWER_KEY_CVLAN_PRIO]) {
 		struct rtattr *attr = tb[TCA_FLOWER_KEY_CVLAN_PRIO];
 
-		print_uint(PRINT_ANY, "cvlan_prio", "\n  cvlan_prio %d",
+		print_nl();
+		print_uint(PRINT_ANY, "cvlan_prio", "  cvlan_prio %d",
 			   rta_getattr_u8(attr));
 	}
 
@@ -2124,7 +2138,8 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 		SPRINT_BUF(buf);
 		struct rtattr *attr = tb[TCA_FLOWER_KEY_CVLAN_ETH_TYPE];
 
-		print_string(PRINT_ANY, "cvlan_ethtype", "\n  cvlan_ethtype %s",
+		print_nl();
+		print_string(PRINT_ANY, "cvlan_ethtype", "  cvlan_ethtype %s",
 			     ll_proto_n2a(rta_getattr_u16(attr),
 			     buf, sizeof(buf)));
 	}
@@ -2254,13 +2269,18 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 	if (tb[TCA_FLOWER_FLAGS]) {
 		__u32 flags = rta_getattr_u32(tb[TCA_FLOWER_FLAGS]);
 
-		if (flags & TCA_CLS_FLAGS_SKIP_HW)
-			print_bool(PRINT_ANY, "skip_hw", "\n  skip_hw", true);
-		if (flags & TCA_CLS_FLAGS_SKIP_SW)
-			print_bool(PRINT_ANY, "skip_sw", "\n  skip_sw", true);
+		if (flags & TCA_CLS_FLAGS_SKIP_HW) {
+			print_nl();
+			print_bool(PRINT_ANY, "skip_hw", "  skip_hw", true);
+		}
+		if (flags & TCA_CLS_FLAGS_SKIP_SW) {
+			print_nl();
+			print_bool(PRINT_ANY, "skip_sw", "  skip_sw", true);
+		}
 
 		if (flags & TCA_CLS_FLAGS_IN_HW) {
-			print_bool(PRINT_ANY, "in_hw", "\n  in_hw", true);
+			print_nl();
+			print_bool(PRINT_ANY, "in_hw", "  in_hw", true);
 
 			if (tb[TCA_FLOWER_IN_HW_COUNT]) {
 				__u32 count = rta_getattr_u32(tb[TCA_FLOWER_IN_HW_COUNT]);
@@ -2269,8 +2289,10 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 					   " in_hw_count %u", count);
 			}
 		}
-		else if (flags & TCA_CLS_FLAGS_NOT_IN_HW)
-			print_bool(PRINT_ANY, "not_in_hw", "\n  not_in_hw", true);
+		else if (flags & TCA_CLS_FLAGS_NOT_IN_HW) {
+			print_nl();
+			print_bool(PRINT_ANY, "not_in_hw", "  not_in_hw", true);
+		}
 	}
 
 	if (tb[TCA_FLOWER_ACT])
diff --git a/tc/m_csum.c b/tc/m_csum.c
index 3e3dc251ea38..afbee9c8de0f 100644
--- a/tc/m_csum.c
+++ b/tc/m_csum.c
@@ -205,7 +205,7 @@ print_csum(struct action_util *au, FILE *f, struct rtattr *arg)
 		 uflag_4, uflag_5, uflag_6, uflag_7);
 	print_string(PRINT_ANY, "csum", "(%s) ", buf);
 
-	print_action_control(f, "action ", sel->action, "\n");
+	print_action_control(f, "action ", sel->action, _SL_);
 	print_uint(PRINT_ANY, "index", "\tindex %u", sel->index);
 	print_int(PRINT_ANY, "ref", " ref %d", sel->refcnt);
 	print_int(PRINT_ANY, "bind", " bind %d", sel->bindcnt);
@@ -217,7 +217,7 @@ print_csum(struct action_util *au, FILE *f, struct rtattr *arg)
 			print_tm(f, tm);
 		}
 	}
-	print_string(PRINT_FP, NULL, "%s", "\n");
+	print_nl();
 
 	return 0;
 }
diff --git a/tc/m_ct.c b/tc/m_ct.c
index 8df2f6103601..b36e55d9c5cd 100644
--- a/tc/m_ct.c
+++ b/tc/m_ct.c
@@ -473,7 +473,8 @@ static int print_ct(struct action_util *au, FILE *f, struct rtattr *arg)
 
 	print_action_control(f, " ", p->action, "");
 
-	print_uint(PRINT_ANY, "index", "\n\t index %u", p->index);
+	print_nl();
+	print_uint(PRINT_ANY, "index", "\t index %u", p->index);
 	print_int(PRINT_ANY, "ref", " ref %d", p->refcnt);
 	print_int(PRINT_ANY, "bind", " bind %d", p->bindcnt);
 
@@ -484,7 +485,7 @@ static int print_ct(struct action_util *au, FILE *f, struct rtattr *arg)
 			print_tm(f, tm);
 		}
 	}
-	print_string(PRINT_FP, NULL, "%s", "\n ");
+	print_nl();
 
 	return 0;
 }
diff --git a/tc/m_gact.c b/tc/m_gact.c
index b06e8ee95818..33f326f823d1 100644
--- a/tc/m_gact.c
+++ b/tc/m_gact.c
@@ -193,13 +193,15 @@ print_gact(struct action_util *au, FILE *f, struct rtattr *arg)
 		pp = &pp_dummy;
 	}
 	open_json_object("prob");
-	print_string(PRINT_ANY, "random_type", "\n\t random type %s",
+	print_nl();
+	print_string(PRINT_ANY, "random_type", "\t random type %s",
 		     prob_n2a(pp->ptype));
 	print_action_control(f, " ", pp->paction, " ");
 	print_int(PRINT_ANY, "val", "val %d", pp->pval);
 	close_json_object();
 #endif
-	print_uint(PRINT_ANY, "index", "\n\t index %u", p->index);
+	print_nl();
+	print_uint(PRINT_ANY, "index", "\t index %u", p->index);
 	print_int(PRINT_ANY, "ref", " ref %d", p->refcnt);
 	print_int(PRINT_ANY, "bind", " bind %d", p->bindcnt);
 	if (show_stats) {
@@ -209,7 +211,7 @@ print_gact(struct action_util *au, FILE *f, struct rtattr *arg)
 			print_tm(f, tm);
 		}
 	}
-	print_string(PRINT_FP, NULL, "%s", "\n");
+	print_nl();
 	return 0;
 }
 
diff --git a/tc/m_mirred.c b/tc/m_mirred.c
index 132095237929..d2bdf4074a73 100644
--- a/tc/m_mirred.c
+++ b/tc/m_mirred.c
@@ -307,7 +307,8 @@ print_mirred(struct action_util *au, FILE *f, struct rtattr *arg)
 	print_string(PRINT_ANY, "to_dev", " to device %s)", dev);
 	print_action_control(f, " ", p->action, "");
 
-	print_uint(PRINT_ANY, "index", "\n \tindex %u", p->index);
+	print_nl();
+	print_uint(PRINT_ANY, "index", "\tindex %u", p->index);
 	print_int(PRINT_ANY, "ref", " ref %d", p->refcnt);
 	print_int(PRINT_ANY, "bind", " bind %d", p->bindcnt);
 
@@ -318,7 +319,7 @@ print_mirred(struct action_util *au, FILE *f, struct rtattr *arg)
 			print_tm(f, tm);
 		}
 	}
-	print_string(PRINT_FP, NULL, "%s", "\n ");
+	print_nl();
 	return 0;
 }
 
diff --git a/tc/m_mpls.c b/tc/m_mpls.c
index 4b1ec70e3b4a..6f3a39f43ce1 100644
--- a/tc/m_mpls.c
+++ b/tc/m_mpls.c
@@ -252,7 +252,8 @@ static int print_mpls(struct action_util *au, FILE *f, struct rtattr *arg)
 	}
 	print_action_control(f, " ", parm->action, "");
 
-	print_uint(PRINT_ANY, "index", "\n\t index %u", parm->index);
+	print_nl();
+	print_uint(PRINT_ANY, "index", "\t index %u", parm->index);
 	print_int(PRINT_ANY, "ref", " ref %d", parm->refcnt);
 	print_int(PRINT_ANY, "bind", " bind %d", parm->bindcnt);
 
diff --git a/tc/m_pedit.c b/tc/m_pedit.c
index 1cd2d162fc2a..fccfd17ca270 100644
--- a/tc/m_pedit.c
+++ b/tc/m_pedit.c
@@ -820,7 +820,7 @@ static int print_pedit(struct action_util *au, FILE *f, struct rtattr *arg)
 			sel->nkeys);
 	}
 
-	fprintf(f, "\n ");
+	print_nl();
 
 	free(keys_ex);
 	return 0;
diff --git a/tc/m_simple.c b/tc/m_simple.c
index 49e250472e04..70897d6b7c13 100644
--- a/tc/m_simple.c
+++ b/tc/m_simple.c
@@ -194,7 +194,7 @@ static int print_simple(struct action_util *au, FILE *f, struct rtattr *arg)
 			print_tm(f, tm);
 		}
 	}
-	fprintf(f, "\n");
+	print_nl();
 
 	return 0;
 }
diff --git a/tc/m_tunnel_key.c b/tc/m_tunnel_key.c
index 4e65e444776a..8fde689137fd 100644
--- a/tc/m_tunnel_key.c
+++ b/tc/m_tunnel_key.c
@@ -420,7 +420,8 @@ static void tunnel_key_print_geneve_options(const char *name,
 	uint8_t type;
 
 	open_json_array(PRINT_JSON, name);
-	print_string(PRINT_FP, name, "\n\t%s ", "geneve_opt");
+	print_nl();
+	print_string(PRINT_FP, name, "\t%s ", "geneve_opt");
 
 	while (rem) {
 		parse_rtattr(tb, TCA_TUNNEL_KEY_ENC_OPT_GENEVE_MAX, i, rem);
diff --git a/tc/m_vlan.c b/tc/m_vlan.c
index 9c8071e9dbbe..1096ba0fbf12 100644
--- a/tc/m_vlan.c
+++ b/tc/m_vlan.c
@@ -219,7 +219,8 @@ static int print_vlan(struct action_util *au, FILE *f, struct rtattr *arg)
 	}
 	print_action_control(f, " ", parm->action, "");
 
-	print_uint(PRINT_ANY, "index", "\n\t index %u", parm->index);
+	print_nl();
+	print_uint(PRINT_ANY, "index", "\t index %u", parm->index);
 	print_int(PRINT_ANY, "ref", " ref %d", parm->refcnt);
 	print_int(PRINT_ANY, "bind", " bind %d", parm->bindcnt);
 
@@ -231,7 +232,7 @@ static int print_vlan(struct action_util *au, FILE *f, struct rtattr *arg)
 		}
 	}
 
-	print_string(PRINT_FP, NULL, "%s", "\n");
+	print_nl();
 
 	return 0;
 }
diff --git a/tc/m_xt.c b/tc/m_xt.c
index bf0db2be99a4..487ba25ad391 100644
--- a/tc/m_xt.c
+++ b/tc/m_xt.c
@@ -391,7 +391,7 @@ print_ipt(struct action_util *au, FILE *f, struct rtattr *arg)
 			print_tm(f, tm);
 		}
 	}
-	fprintf(f, "\n");
+	print_nl();
 
 	xtables_free_opts(1);
 
diff --git a/tc/q_cake.c b/tc/q_cake.c
index 65ea07ef6cb5..3c78b1767e0b 100644
--- a/tc/q_cake.c
+++ b/tc/q_cake.c
@@ -766,7 +766,7 @@ static int cake_print_xstats(struct qdisc_util *qu, FILE *f,
 			fprintf(f, "          ");
 			for (i = 0; i < num_tins; i++)
 				fprintf(f, "        Tin %u", i);
-			fprintf(f, "\n");
+			fprintf(f, "%s", _SL_);
 		};
 
 #define GET_TSTAT(i, attr) (tstat[i][TCA_CAKE_TIN_STATS_ ## attr])
@@ -775,7 +775,7 @@ static int cake_print_xstats(struct qdisc_util *qu, FILE *f,
 				fprintf(f, name);		\
 				for (i = 0; i < num_tins; i++)	\
 					fprintf(f, " %12" fmts,	val);	\
-				fprintf(f, "\n");			\
+				fprintf(f, "%s", _SL_);			\
 			}						\
 		} while (0)
 
diff --git a/tc/q_fq_codel.c b/tc/q_fq_codel.c
index 376ac50da1a5..12ce3fbfd203 100644
--- a/tc/q_fq_codel.c
+++ b/tc/q_fq_codel.c
@@ -257,7 +257,8 @@ static int fq_codel_print_xstats(struct qdisc_util *qu, FILE *f,
 		if (st->qdisc_stats.drop_overmemory)
 			print_uint(PRINT_ANY, "drop_overmemory", " drop_overmemory %u",
 				st->qdisc_stats.drop_overmemory);
-		print_uint(PRINT_ANY, "new_flows_len", "\n  new_flows_len %u",
+		print_nl();
+		print_uint(PRINT_ANY, "new_flows_len", "  new_flows_len %u",
 			st->qdisc_stats.new_flows_len);
 		print_uint(PRINT_ANY, "old_flows_len", " old_flows_len %u",
 			st->qdisc_stats.old_flows_len);
diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
index 17e399830a75..77aaaff6d220 100644
--- a/tc/tc_qdisc.c
+++ b/tc/tc_qdisc.c
@@ -317,7 +317,7 @@ int print_qdisc(struct nlmsghdr *n, void *arg)
 	}
 	close_json_object();
 
-	print_string(PRINT_FP, NULL, "\n", NULL);
+	print_nl();
 
 	if (show_details && tb[TCA_STAB]) {
 		print_size_table(fp, " ", tb[TCA_STAB]);
-- 
2.20.1

