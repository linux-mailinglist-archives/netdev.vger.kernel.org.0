Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6121C0FF5
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 10:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgEAIro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 04:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728363AbgEAIrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 04:47:42 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA9FC035494
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 01:47:42 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a5so2081474pjh.2
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 01:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tw5oCh9AoMmVS4y1YMkvCQB5FhyJvKIrUmuZ1CiSgyQ=;
        b=LE3kSfgVhQ5ijq3y8olBtz7vne5o0Ch1EfrluNr58ZeLgN0XM9AFrw2SBZRUBGqXWK
         OwyhW//jpkWdXgZ52S3FC3TcJGXO9QMBaju6NXv/MHh0O/cefynOXhNQ36bDrI+BPUGW
         s+7wM3KUCUeK4vDId8GiHkF/Y/F3Cv9JxAN/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tw5oCh9AoMmVS4y1YMkvCQB5FhyJvKIrUmuZ1CiSgyQ=;
        b=oLc2ByMrx9Am06hJj/jc/MdQfT1uricQGvX8dv7LByQVRi2JNp64U7/S2BySWxfmV0
         BKqRhgdm3YBMZMtZJHwsWd6OmQ24XIi2XTldrZyqMiI/cZCUFY67hkKgO6gQyiz0lkJX
         1BzF03xQoD/sZ771grPIyDRAkqF2xy4aG5Xqjm9Sb3w2QYfmy+OUHEhsQyfF04MUEuRN
         bQMKI+nq9E+TGzpQGifmVe5lRcEjtJDokE6pVkyah5AKvmbIsDw2BXn1Ol2pjGX0QYS1
         rwkDusv7mS1qBzXnTKezajfmUjn42Uecbq7VWIU2KSaIbWa7TforfwDK+ckJrFgeshFl
         Er5Q==
X-Gm-Message-State: AGi0PuZsGZYArKmutUdlnjaP/ElG7XvPSYWhFRfBjiDoUryoLQTYKPws
        via0yfaOhBA0jJW4mAB9EG+FDbHu5cw=
X-Google-Smtp-Source: APiQypLspjlPFYjHnv9D2vwxqB1ogBPA93njvm4OcwQeATS1xnjr0KerrL2MUTHZvNd+9+eXpGk9CA==
X-Received: by 2002:a17:90a:ead6:: with SMTP id ev22mr3412058pjb.94.1588322861624;
        Fri, 01 May 2020 01:47:41 -0700 (PDT)
Received: from f3.synalogic.ca (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id mj4sm1578460pjb.0.2020.05.01.01.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 01:47:41 -0700 (PDT)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH iproute2 v2 6/6] Replace open-coded instances of print_nl()
Date:   Fri,  1 May 2020 17:47:20 +0900
Message-Id: <20200501084720.138421-7-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200501084720.138421-1-bpoirier@cumulusnetworks.com>
References: <20200501084720.138421-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 bridge/vlan.c     |  4 ++--
 tc/m_action.c     | 14 +++++++-------
 tc/m_connmark.c   |  4 ++--
 tc/m_ctinfo.c     |  4 ++--
 tc/m_ife.c        |  4 ++--
 tc/m_mpls.c       |  2 +-
 tc/m_nat.c        |  4 ++--
 tc/m_sample.c     |  4 ++--
 tc/m_skbedit.c    |  4 ++--
 tc/m_tunnel_key.c | 16 ++++++++--------
 tc/q_taprio.c     |  8 ++++----
 tc/tc_util.c      |  4 ++--
 12 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 8753d4c3..0d142bc9 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -360,7 +360,7 @@ static void print_vlan_tunnel_info(struct rtattr *tb, int ifindex)
 		}
 		print_range("tunid", last_tunid_start, tunnel_id);
 		close_json_object();
-		print_string(PRINT_FP, NULL, "%s", _SL_);
+		print_nl();
 	}
 
 	if (opened)
@@ -644,7 +644,7 @@ void print_vlan_info(struct rtattr *tb, int ifindex)
 
 		print_vlan_flags(vinfo->flags);
 		close_json_object();
-		print_string(PRINT_FP, NULL, "%s", _SL_);
+		print_nl();
 	}
 
 	if (opened)
diff --git a/tc/m_action.c b/tc/m_action.c
index b41782de..66e67245 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -177,7 +177,7 @@ static void print_hw_stats(const struct rtattr *arg, bool print_used)
 			print_string(PRINT_ANY, NULL, " %s", item->str);
 	}
 	close_json_array(PRINT_JSON, NULL);
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 }
 
 static int parse_hw_stats(const char *str, struct nlmsghdr *n)
@@ -376,11 +376,11 @@ static int tc_print_one_action(FILE *f, struct rtattr *arg)
 
 	if (show_stats && tb[TCA_ACT_STATS]) {
 		print_string(PRINT_FP, NULL, "\tAction statistics:", NULL);
-		print_string(PRINT_FP, NULL, "%s", _SL_);
+		print_nl();
 		open_json_object("stats");
 		print_tcstats2_attr(f, tb[TCA_ACT_STATS], "\t", NULL);
 		close_json_object();
-		print_string(PRINT_FP, NULL, "%s", _SL_);
+		print_nl();
 	}
 	if (tb[TCA_ACT_COOKIE]) {
 		int strsz = RTA_PAYLOAD(tb[TCA_ACT_COOKIE]);
@@ -389,7 +389,7 @@ static int tc_print_one_action(FILE *f, struct rtattr *arg)
 		print_string(PRINT_ANY, "cookie", "\tcookie %s",
 			     hexstring_n2a(RTA_DATA(tb[TCA_ACT_COOKIE]),
 					   strsz, b1, sizeof(b1)));
-		print_string(PRINT_FP, NULL, "%s", _SL_);
+		print_nl();
 	}
 	if (tb[TCA_ACT_FLAGS]) {
 		struct nla_bitfield32 *flags = RTA_DATA(tb[TCA_ACT_FLAGS]);
@@ -398,7 +398,7 @@ static int tc_print_one_action(FILE *f, struct rtattr *arg)
 			print_bool(PRINT_ANY, "no_percpu", "\tno_percpu",
 				   flags->value &
 				   TCA_ACT_FLAGS_NO_PERCPU_STATS);
-		print_string(PRINT_FP, NULL, "%s", _SL_);
+		print_nl();
 	}
 	if (tb[TCA_ACT_HW_STATS])
 		print_hw_stats(tb[TCA_ACT_HW_STATS], false);
@@ -458,7 +458,7 @@ tc_print_action(FILE *f, const struct rtattr *arg, unsigned short tot_acts)
 	for (i = 0; i <= tot_acts; i++) {
 		if (tb[i]) {
 			open_json_object(NULL);
-			print_string(PRINT_FP, NULL, "%s", _SL_);
+			print_nl();
 			print_uint(PRINT_ANY, "order",
 				   "\taction order %u: ", i);
 			if (tc_print_one_action(f, tb[i]) < 0) {
@@ -497,7 +497,7 @@ int print_action(struct nlmsghdr *n, void *arg)
 	open_json_object(NULL);
 	print_uint(PRINT_ANY, "total acts", "total acts %u",
 		   tot_acts ? *tot_acts : 0);
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 	close_json_object();
 	if (tb[TCA_ACT_TAB] == NULL) {
 		if (n->nlmsg_type != RTM_GETACTION)
diff --git a/tc/m_connmark.c b/tc/m_connmark.c
index eac23489..4b2dc4e2 100644
--- a/tc/m_connmark.c
+++ b/tc/m_connmark.c
@@ -125,7 +125,7 @@ static int print_connmark(struct action_util *au, FILE *f, struct rtattr *arg)
 	print_uint(PRINT_ANY, "zone", "zone %u", ci->zone);
 	print_action_control(f, " ", ci->action, "");
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 	print_uint(PRINT_ANY, "index", "\t index %u", ci->index);
 	print_int(PRINT_ANY, "ref", " ref %d", ci->refcnt);
 	print_int(PRINT_ANY, "bind", " bind %d", ci->bindcnt);
@@ -137,7 +137,7 @@ static int print_connmark(struct action_util *au, FILE *f, struct rtattr *arg)
 			print_tm(f, tm);
 		}
 	}
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 
 	return 0;
 }
diff --git a/tc/m_ctinfo.c b/tc/m_ctinfo.c
index 5e451f87..e5c1b436 100644
--- a/tc/m_ctinfo.c
+++ b/tc/m_ctinfo.c
@@ -238,7 +238,7 @@ static int print_ctinfo(struct action_util *au, FILE *f, struct rtattr *arg)
 	print_hu(PRINT_ANY, "zone", "zone %u", zone);
 	print_action_control(f, " ", ci->action, "");
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 	print_uint(PRINT_ANY, "index", "\t index %u", ci->index);
 	print_int(PRINT_ANY, "ref", " ref %d", ci->refcnt);
 	print_int(PRINT_ANY, "bind", " bind %d", ci->bindcnt);
@@ -256,7 +256,7 @@ static int print_ctinfo(struct action_util *au, FILE *f, struct rtattr *arg)
 	if (show_stats)
 		print_ctinfo_stats(f, tb);
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 
 	return 0;
 }
diff --git a/tc/m_ife.c b/tc/m_ife.c
index 7c612c02..6a85e087 100644
--- a/tc/m_ife.c
+++ b/tc/m_ife.c
@@ -311,7 +311,7 @@ static int print_ife(struct action_util *au, FILE *f, struct rtattr *arg)
 					 sizeof(b2)));
 	}
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 	print_uint(PRINT_ANY, "index", "\t index %u", p->index);
 	print_int(PRINT_ANY, "ref", " ref %d", p->refcnt);
 	print_int(PRINT_ANY, "bind", " bind %d", p->bindcnt);
@@ -324,7 +324,7 @@ static int print_ife(struct action_util *au, FILE *f, struct rtattr *arg)
 		}
 	}
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 
 	return 0;
 }
diff --git a/tc/m_mpls.c b/tc/m_mpls.c
index 50eba01c..3d5d9b25 100644
--- a/tc/m_mpls.c
+++ b/tc/m_mpls.c
@@ -265,7 +265,7 @@ static int print_mpls(struct action_util *au, FILE *f, struct rtattr *arg)
 		}
 	}
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 
 	return 0;
 }
diff --git a/tc/m_nat.c b/tc/m_nat.c
index c4b02a83..56e8f47c 100644
--- a/tc/m_nat.c
+++ b/tc/m_nat.c
@@ -172,7 +172,7 @@ print_nat(struct action_util *au, FILE * f, struct rtattr *arg)
 		     format_host_r(AF_INET, 4, &sel->new_addr, buf1, sizeof(buf1)));
 
 	print_action_control(f, " ", sel->action, "");
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 	print_uint(PRINT_ANY, "index", "\t index %u", sel->index);
 	print_int(PRINT_ANY, "ref", " ref %d", sel->refcnt);
 	print_int(PRINT_ANY, "bind", " bind %d", sel->bindcnt);
@@ -185,7 +185,7 @@ print_nat(struct action_util *au, FILE * f, struct rtattr *arg)
 		}
 	}
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 
 	return 0;
 }
diff --git a/tc/m_sample.c b/tc/m_sample.c
index c068e632..4a30513a 100644
--- a/tc/m_sample.c
+++ b/tc/m_sample.c
@@ -167,7 +167,7 @@ static int print_sample(struct action_util *au, FILE *f, struct rtattr *arg)
 
 	print_action_control(f, " ", p->action, "");
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 	print_uint(PRINT_ANY, "index", "\t index %u", p->index);
 	print_int(PRINT_ANY, "ref", " ref %d", p->refcnt);
 	print_int(PRINT_ANY, "bind", " bind %d", p->bindcnt);
@@ -179,7 +179,7 @@ static int print_sample(struct action_util *au, FILE *f, struct rtattr *arg)
 			print_tm(f, tm);
 		}
 	}
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 	return 0;
 }
 
diff --git a/tc/m_skbedit.c b/tc/m_skbedit.c
index 761cad58..9afe2f0c 100644
--- a/tc/m_skbedit.c
+++ b/tc/m_skbedit.c
@@ -254,7 +254,7 @@ static int print_skbedit(struct action_util *au, FILE *f, struct rtattr *arg)
 
 	print_action_control(f, " ", p->action, "");
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 	print_uint(PRINT_ANY, "index", "\t index %u", p->index);
 	print_int(PRINT_ANY, "ref", " ref %d", p->refcnt);
 	print_int(PRINT_ANY, "bind", " bind %d", p->bindcnt);
@@ -267,7 +267,7 @@ static int print_skbedit(struct action_util *au, FILE *f, struct rtattr *arg)
 		}
 	}
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 
 	return 0;
 }
diff --git a/tc/m_tunnel_key.c b/tc/m_tunnel_key.c
index 8fde6891..1f6921f3 100644
--- a/tc/m_tunnel_key.c
+++ b/tc/m_tunnel_key.c
@@ -367,7 +367,7 @@ static void tunnel_key_print_ip_addr(FILE *f, const char *name,
 	else
 		return;
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 	if (matches(name, "src_ip") == 0)
 		print_string(PRINT_ANY, "src_ip", "\tsrc_ip %s",
 			     rt_addr_n2a_rta(family, attr));
@@ -381,7 +381,7 @@ static void tunnel_key_print_key_id(FILE *f, const char *name,
 {
 	if (!attr)
 		return;
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 	print_uint(PRINT_ANY, "key_id", "\tkey_id %u", rta_getattr_be32(attr));
 }
 
@@ -390,7 +390,7 @@ static void tunnel_key_print_dst_port(FILE *f, char *name,
 {
 	if (!attr)
 		return;
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 	print_uint(PRINT_ANY, "dst_port", "\tdst_port %u",
 		   rta_getattr_be16(attr));
 }
@@ -401,7 +401,7 @@ static void tunnel_key_print_flag(FILE *f, const char *name_on,
 {
 	if (!attr)
 		return;
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 	print_string(PRINT_ANY, "flag", "\t%s",
 		     rta_getattr_u8(attr) ? name_on : name_off);
 }
@@ -473,11 +473,11 @@ static void tunnel_key_print_tos_ttl(FILE *f, char *name,
 		return;
 
 	if (matches(name, "tos") == 0 && rta_getattr_u8(attr) != 0) {
-		print_string(PRINT_FP, NULL, "%s", _SL_);
+		print_nl();
 		print_uint(PRINT_ANY, "tos", "\ttos 0x%x",
 			   rta_getattr_u8(attr));
 	} else if (matches(name, "ttl") == 0 && rta_getattr_u8(attr) != 0) {
-		print_string(PRINT_FP, NULL, "%s", _SL_);
+		print_nl();
 		print_uint(PRINT_ANY, "ttl", "\tttl %u",
 			   rta_getattr_u8(attr));
 	}
@@ -531,7 +531,7 @@ static int print_tunnel_key(struct action_util *au, FILE *f, struct rtattr *arg)
 	}
 	print_action_control(f, " ", parm->action, "");
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 	print_uint(PRINT_ANY, "index", "\t index %u", parm->index);
 	print_int(PRINT_ANY, "ref", " ref %d", parm->refcnt);
 	print_int(PRINT_ANY, "bind", " bind %d", parm->bindcnt);
@@ -544,7 +544,7 @@ static int print_tunnel_key(struct action_util *au, FILE *f, struct rtattr *arg)
 		}
 	}
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 
 	return 0;
 }
diff --git a/tc/q_taprio.c b/tc/q_taprio.c
index b9954436..e43db9d0 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -368,7 +368,7 @@ static int print_sched_list(FILE *f, struct rtattr *list)
 
 	open_json_array(PRINT_JSON, "schedule");
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 
 	for (item = RTA_DATA(list); RTA_OK(item, rem); item = RTA_NEXT(item, rem)) {
 		struct rtattr *tb[TCA_TAPRIO_SCHED_ENTRY_MAX + 1];
@@ -396,7 +396,7 @@ static int print_sched_list(FILE *f, struct rtattr *list)
 		print_uint(PRINT_ANY, "interval", " interval %u", interval);
 		close_json_object();
 
-		print_string(PRINT_FP, NULL, "%s", _SL_);
+		print_nl();
 	}
 
 	close_json_array(PRINT_ANY, "");
@@ -454,7 +454,7 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		print_uint(PRINT_ANY, NULL, " %u", qopt->prio_tc_map[i]);
 	close_json_array(PRINT_ANY, "");
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 
 	open_json_array(PRINT_ANY, "queues");
 	for (i = 0; i < qopt->num_tc; i++) {
@@ -465,7 +465,7 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	}
 	close_json_array(PRINT_ANY, "");
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 
 	if (tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID])
 		clockid = rta_getattr_s32(tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]);
diff --git a/tc/tc_util.c b/tc/tc_util.c
index 68938fb0..12f865cc 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -788,7 +788,7 @@ static void print_tcstats_basic_hw(struct rtattr **tbs, char *prefix)
 			   sizeof(bs)));
 
 		if (bs.bytes >= bs_hw.bytes && bs.packets >= bs_hw.packets) {
-			print_string(PRINT_FP, NULL, "%s", _SL_);
+			print_nl();
 			print_string(PRINT_FP, NULL, "%s", prefix);
 			print_lluint(PRINT_ANY, "sw_bytes",
 				     "Sent software %llu bytes",
@@ -798,7 +798,7 @@ static void print_tcstats_basic_hw(struct rtattr **tbs, char *prefix)
 		}
 	}
 
-	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_nl();
 	print_string(PRINT_FP, NULL, "%s", prefix);
 	print_lluint(PRINT_ANY, "hw_bytes", "Sent hardware %llu bytes",
 		     bs_hw.bytes);
-- 
2.26.0

