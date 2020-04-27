Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686421BA11B
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 12:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgD0K2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 06:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727015AbgD0K2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 06:28:41 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B746C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:28:41 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id h69so8499940pgc.8
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=BgXpzzOB5OtOu3Qgjg87TBST69OVi4QcEqcXnUkKtnA=;
        b=lmsY+bCkhwAYLl/CsIog7v7t75V3mog/aTPoCXVTF0Uhtf8Z+vStrWYSOnJMgJV7bj
         l0rLu7r743aHs4KkNJrkosqmv1D0DQhpr8YueWmTAe6kemdUeYUhYJc887hle2iZCJEA
         /sSrQYMHs8ja4l5q5WObf72maNRB8ggmdldHaZk3KmiA8SIi2dDFLLsY5Sa1cnceYCtp
         5ERmWc0a5zt6l3L/r409JIUhpbneyXrwdVyDl9bDhJh7cSu1tyZxUXRNtS+z84AkRMFN
         2F/UOsxBJDxv3tr+jQ8VrpsruvqAmP3XkPRixars7OO5FP2BQl6vnrCdysC7wFc/jC9X
         jsyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=BgXpzzOB5OtOu3Qgjg87TBST69OVi4QcEqcXnUkKtnA=;
        b=KSOL2whHY8UcZpxnj5sNeHqgbUg+ir517jXkLwKUXo3s9ip9+Dnlo8dUnpqwcY0dcu
         +9eI+K6lmCFiFsEjxG7LUGvZ5us9Yosk0UzYxMKf3c3ZsKQdaViDi7ihej0QIaGJXEaj
         PpCID3bmOPvYrCdqcMofVFvKtwudmZuRQs/FK0b6sVrlG1k4b+IqtXLeMYo6vtodtqyu
         sHK2iVT3vUyTNDLK6lJAdD9VjFslfjoYqR++RlCjogCtHEOE8S7R9twTl70DCLPntHqw
         4I9yRHZU/anuNhEgB5hHtcErQZAs0Iv5AGFCDpubCFtbQ3SnXOLcte14KRB7NMrpsaNJ
         PKYw==
X-Gm-Message-State: AGi0PuZYtRTqXQoVLEu3ObQTmEWrCG4/APDWEAfZmGhU6WsOOJPf0kpr
        06Fp1qaHAiZvD/b7J4VrUC1PB4ir
X-Google-Smtp-Source: APiQypJkPJBJDR0jaaEcr4VpQkW2PaskeAO7v64/i+f9Yn4j5QxPpYLEKakuGkjK6h8uUSZJ4KbHlg==
X-Received: by 2002:aa7:979b:: with SMTP id o27mr10775154pfp.192.1587983319978;
        Mon, 27 Apr 2020 03:28:39 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o12sm10188054pgl.87.2020.04.27.03.28.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 03:28:39 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCHv4 iproute2-next 5/7] tc: m_tunnel_key: add options support for erpsan
Date:   Mon, 27 Apr 2020 18:27:49 +0800
Message-Id: <0225abc4c546f25972bd31fcab52511c54f96ba1.1587983178.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <916fda0179fa618e310a672314dc6091452b0d97.1587983178.git.lucien.xin@gmail.com>
References: <cover.1587983178.git.lucien.xin@gmail.com>
 <a06922f5bd35b674caee4bd5919186ea1323202a.1587983178.git.lucien.xin@gmail.com>
 <838c55576eabd17db407a95bc6609c05bf5e174b.1587983178.git.lucien.xin@gmail.com>
 <4ae2ca59ac4262b19212a16ee7474189ae5eca72.1587983178.git.lucien.xin@gmail.com>
 <916fda0179fa618e310a672314dc6091452b0d97.1587983178.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1587983178.git.lucien.xin@gmail.com>
References: <cover.1587983178.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN's parse and
print to implement erspan options support in m_tunnel_key, like
Commit 6217917a3826 ("tc: m_tunnel_key: Add tunnel option support
to act_tunnel_key") for geneve options support.

Option is expressed as version:index:dir:hwid, dir and hwid will
be parsed when version is 2, while index will be parsed when
version is 1. erspan doesn't support multiple options.

With this patch, users can add and dump erspan options like:

  # ip link add name erspan1 type erspan external
  # tc qdisc add dev eth0 ingress
  # tc filter add dev eth0 protocol ip parent ffff: \
      flower indev eth0 \
        ip_proto udp \
        action tunnel_key \
          set src_ip 10.0.99.192 \
          dst_ip 10.0.99.193 \
          dst_port 6081 \
          id 11 \
          erspan_opts 1:2:0:0 \
      action mirred egress redirect dev erspan1
  # tc -s filter show dev eth0 parent ffff:

     filter protocol ip pref 49151 flower chain 0 handle 0x1
       indev eth0
       eth_type ipv4
       ip_proto udp
       not_in_hw
         action order 1: tunnel_key  set
         src_ip 10.0.99.192
         dst_ip 10.0.99.193
         key_id 11
         dst_port 6081
         erspan_opts 1:2:0:0
         csum pipe
           index 2 ref 1 bind 1
         ...
v1->v2:
  - no change.
v2->v3:
  - no change.
v3->v4:
  - keep the same format between input and output, json and non json.
  - print version, index, dir and hwid as uint.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 man/man8/tc-tunnel_key.8 |  12 ++++-
 tc/m_tunnel_key.c        | 117 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 127 insertions(+), 2 deletions(-)

diff --git a/man/man8/tc-tunnel_key.8 b/man/man8/tc-tunnel_key.8
index c208e2c..ad99724 100644
--- a/man/man8/tc-tunnel_key.8
+++ b/man/man8/tc-tunnel_key.8
@@ -68,8 +68,10 @@ options.
 .B dst_port
 ,
 .B geneve_opts
-and
+,
 .B vxlan_opts
+and
+.B erspan_opts
 are optional.
 .RS
 .TP
@@ -99,6 +101,14 @@ Vxlan metatdata options.
 is specified in the form GBP, as a 32bit number. Multiple options is not
 supported.
 .TP
+.B erspan_opts
+Erspan metatdata options.
+.B erspan_opts
+is specified in the form VERSION:INDEX:DIR:HWID, where VERSION is represented
+as a 8bit number, INDEX as an 32bit number, DIR and HWID as a 8bit number.
+Multiple options is not supported. Note INDEX is used when VERSION is 1,
+and DIR and HWID are used when VERSION is 2.
+.TP
 .B tos
 Outer header TOS
 .TP
diff --git a/tc/m_tunnel_key.c b/tc/m_tunnel_key.c
index 11ec55d..2ebf2ed 100644
--- a/tc/m_tunnel_key.c
+++ b/tc/m_tunnel_key.c
@@ -29,7 +29,7 @@ static void explain(void)
 		"src_ip <IP> (mandatory)\n"
 		"dst_ip <IP> (mandatory)\n"
 		"dst_port <UDP_PORT>\n"
-		"geneve_opts | vxlan_opts <OPTIONS>\n"
+		"geneve_opts | vxlan_opts | erspan_opts <OPTIONS>\n"
 		"csum | nocsum (default is \"csum\")\n");
 }
 
@@ -97,6 +97,21 @@ static int tunnel_key_parse_be16(char *str, int base, int type,
 	return 0;
 }
 
+static int tunnel_key_parse_be32(char *str, int base, int type,
+				 struct nlmsghdr *n)
+{
+	__be32 value;
+	int ret;
+
+	ret = get_be32(&value, str, base);
+	if (ret)
+		return ret;
+
+	addattr32(n, MAX_MSG, type, value);
+
+	return 0;
+}
+
 static int tunnel_key_parse_u8(char *str, int base, int type,
 			       struct nlmsghdr *n)
 {
@@ -226,6 +241,63 @@ static int tunnel_key_parse_vxlan_opt(char *str, struct nlmsghdr *n)
 	return 0;
 }
 
+static int tunnel_key_parse_erspan_opt(char *str, struct nlmsghdr *n)
+{
+	char *token, *saveptr = NULL;
+	struct rtattr *encap, *nest;
+	int i, ret;
+
+	encap = addattr_nest(n, MAX_MSG,
+			     TCA_TUNNEL_KEY_ENC_OPTS | NLA_F_NESTED);
+	nest = addattr_nest(n, MAX_MSG,
+			    TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN | NLA_F_NESTED);
+
+	token = strtok_r(str, ":", &saveptr);
+	i = 1;
+	while (token) {
+		switch (i) {
+		case TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_VER:
+		{
+			ret = tunnel_key_parse_u8(token, 0, i, n);
+			if (ret)
+				return ret;
+			break;
+		}
+		case TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_INDEX:
+		{
+			ret = tunnel_key_parse_be32(token, 0, i, n);
+			if (ret)
+				return ret;
+			break;
+		}
+		case TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_DIR:
+		{
+			ret = tunnel_key_parse_u8(token, 0, i, n);
+			if (ret)
+				return ret;
+			break;
+		}
+		case TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_HWID:
+		{
+			ret = tunnel_key_parse_u8(token, 0, i, n);
+			if (ret)
+				return ret;
+			break;
+		}
+		default:
+			return -1;
+		}
+
+		token = strtok_r(NULL, ":", &saveptr);
+		i++;
+	}
+
+	addattr_nest_end(n, nest);
+	addattr_nest_end(n, encap);
+
+	return 0;
+}
+
 static int tunnel_key_parse_tos_ttl(char *str, int type, struct nlmsghdr *n)
 {
 	int ret;
@@ -330,6 +402,13 @@ static int parse_tunnel_key(struct action_util *a, int *argc_p, char ***argv_p,
 				fprintf(stderr, "Illegal \"vxlan_opts\"\n");
 				return -1;
 			}
+		} else if (matches(*argv, "erspan_opts") == 0) {
+			NEXT_ARG();
+
+			if (tunnel_key_parse_erspan_opt(*argv, n)) {
+				fprintf(stderr, "Illegal \"erspan_opts\"\n");
+				return -1;
+			}
 		} else if (matches(*argv, "tos") == 0) {
 			NEXT_ARG();
 			ret = tunnel_key_parse_tos_ttl(*argv,
@@ -517,6 +596,39 @@ static void tunnel_key_print_vxlan_options(struct rtattr *attr)
 	close_json_array(PRINT_JSON, name);
 }
 
+static void tunnel_key_print_erspan_options(struct rtattr *attr)
+{
+	struct rtattr *tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_MAX + 1];
+	struct rtattr *i = RTA_DATA(attr);
+	int rem = RTA_PAYLOAD(attr);
+	char *name = "erspan_opts";
+	__u8 ver, hwid, dir;
+	__u32 idx;
+
+	parse_rtattr(tb, TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_MAX, i, rem);
+	ver = rta_getattr_u8(tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_VER]);
+	if (ver == 1) {
+		idx = rta_getattr_be32(tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_INDEX]);
+		dir = 0;
+		hwid = 0;
+	} else {
+		idx = 0;
+		dir = rta_getattr_u8(tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_DIR]);
+		hwid = rta_getattr_u8(tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_HWID]);
+	}
+
+	print_nl();
+	print_string(PRINT_FP, name, "\t%s ", name);
+	open_json_array(PRINT_JSON, name);
+	open_json_object(NULL);
+	print_uint(PRINT_ANY, "ver", "%u", ver);
+	print_uint(PRINT_ANY, "index", ":%u", idx);
+	print_uint(PRINT_ANY, "dir", ":%u", dir);
+	print_uint(PRINT_ANY, "hwid", ":%u", hwid);
+	close_json_object();
+	close_json_array(PRINT_JSON, name);
+}
+
 static void tunnel_key_print_key_opt(struct rtattr *attr)
 {
 	struct rtattr *tb[TCA_TUNNEL_KEY_ENC_OPTS_MAX + 1];
@@ -531,6 +643,9 @@ static void tunnel_key_print_key_opt(struct rtattr *attr)
 	else if (tb[TCA_TUNNEL_KEY_ENC_OPTS_VXLAN])
 		tunnel_key_print_vxlan_options(
 			tb[TCA_TUNNEL_KEY_ENC_OPTS_VXLAN]);
+	else if (tb[TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN])
+		tunnel_key_print_erspan_options(
+			tb[TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN]);
 }
 
 static void tunnel_key_print_tos_ttl(FILE *f, char *name,
-- 
2.1.0

