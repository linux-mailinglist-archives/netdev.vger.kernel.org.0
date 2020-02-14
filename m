Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 419FE15D5C7
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 11:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgBNKbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 05:31:41 -0500
Received: from mail-pg1-f170.google.com ([209.85.215.170]:33563 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729092AbgBNKbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 05:31:41 -0500
Received: by mail-pg1-f170.google.com with SMTP id 6so4766583pgk.0
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 02:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=XlETyvsuXezvKIT/wYv3+EJid9m4aCE0LCjC2TIcwG4=;
        b=npxMvLKesSFzWxRah7DTdw6q/HRF+DHIfl/65Rgr8WRQUqrlp3/VxTKxsFKy5LsqfV
         liObnv7N/WbLxrPtvzxkzXvuEv8nqsFOvOYZKrv1abzFfpZrOxo9RdotfjNDi8mbiWIW
         MzzocfInK2sVO4lxA5xaklxb55lkeywUDIBJWeIzfL7qgRaO3LsVckn9T9I/+PTneUqW
         tvhd74cNey86Uw+rBQewtlBLWeKAUQJevYDmtkFVucc65auks7wm7ropW9iwLw/OENRE
         V86kwqnERyGfT0RCJlhDz2McEE+YyvXuEHQbhAqEtGzt5uSGmf9MT0P6GJrSJQEOG7Fk
         JQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=XlETyvsuXezvKIT/wYv3+EJid9m4aCE0LCjC2TIcwG4=;
        b=e37qPM5zKzMAKMHjUCKFodcEDn5BmrSJqvRUaiJztXVUBPwDV2sEvR1P44qZfsqI8n
         CDR1a7h2MCOh7vssE//w8RYWqcGjT0mx5WYup0eFpX2fZ4WHdViQSpTtVePVTaejS+X/
         a/tgv2DdpUY+Ie5x6675Lx163rlOY6rJsVMdNlTMlBweaDlmNiQT58bvzUUJ9WRpU5mx
         dr+suOpjdG3w/JDsLwQFPSthpo0GfAjSDy5AaFPUDlvMX92YKENl70KM4sxryj6wyd1s
         ypcCibBKluuFJzM8ks0hj0Hodv3HwmaVa6W2SYDegNY2OJ9Q2ZvjWNYGqgbYhGsl5VE0
         L3Hw==
X-Gm-Message-State: APjAAAXm9832WzqDEzYX8L2PYBTU4LqAFQoWikLsb7cpNwT+hQ4iVEMb
        ytRbSJMklRF5bbAjXnDcBdj9EQRp
X-Google-Smtp-Source: APXvYqwMks7AUNwPf9k3iPSUp15ndVThSqkIVWGZcNfmBc/vXvzBjILdz82z8+7x8flwLz9VnhJYFQ==
X-Received: by 2002:a63:4d8:: with SMTP id 207mr2739621pge.269.1581676299900;
        Fri, 14 Feb 2020 02:31:39 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g7sm6461511pfq.33.2020.02.14.02.31.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Feb 2020 02:31:39 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCHv3 iproute2-next 5/7] tc: m_tunnel_key: add options support for erpsan
Date:   Fri, 14 Feb 2020 18:30:49 +0800
Message-Id: <0f971b9706f02adefbd2c6a4495d1ffc8c44310d.1581676056.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <2aadee844eb02bd2dd3254f75ff4a008e9f6e294.1581676056.git.lucien.xin@gmail.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
 <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
 <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
 <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
 <2aadee844eb02bd2dd3254f75ff4a008e9f6e294.1581676056.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1581676056.git.lucien.xin@gmail.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
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
         erspan_opts 01:00000002:00:00
         csum pipe
           index 2 ref 1 bind 1
         ...
v1->v2:
  - no change.
v2->v3:
  - no change.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 man/man8/tc-tunnel_key.8 |  12 ++++-
 tc/m_tunnel_key.c        | 121 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 131 insertions(+), 2 deletions(-)

diff --git a/man/man8/tc-tunnel_key.8 b/man/man8/tc-tunnel_key.8
index f78227c..bf2ebaa 100644
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
 is specified in the form GBP, as a 32bit hexadecimal value. Multiple options
 is not supported.
 .TP
+.B erspan_opts
+Erspan metatdata options.
+.B erspan_opts
+is specified in the form VERSION:INDEX:DIR:HWID, where VERSION is represented
+as a 8bit hexadecimal value, INDEX as an 32bit hexadecimal value, DIR and HWID
+as a 8bit hexadecimal value. Multiple options is not supported. Note INDEX is
+used when VERSION is 1, and DIR and HWID are used when VERSION is 2.
+.TP
 .B tos
 Outer header TOS
 .TP
diff --git a/tc/m_tunnel_key.c b/tc/m_tunnel_key.c
index e9c2a5a..164ae5c 100644
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
+			ret = tunnel_key_parse_u8(token, 16, i, n);
+			if (ret)
+				return ret;
+			break;
+		}
+		case TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_INDEX:
+		{
+			ret = tunnel_key_parse_be32(token, 16, i, n);
+			if (ret)
+				return ret;
+			break;
+		}
+		case TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_DIR:
+		{
+			ret = tunnel_key_parse_u8(token, 16, i, n);
+			if (ret)
+				return ret;
+			break;
+		}
+		case TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_HWID:
+		{
+			ret = tunnel_key_parse_u8(token, 16, i, n);
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
@@ -519,6 +598,43 @@ static void tunnel_key_print_vxlan_options(struct rtattr *attr)
 	print_uint(PRINT_FP, NULL, "0x%x", gbp);
 }
 
+static void tunnel_key_print_erspan_options(struct rtattr *attr)
+{
+	struct rtattr *tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_MAX + 1];
+	struct rtattr *i = RTA_DATA(attr);
+	int rem = RTA_PAYLOAD(attr);
+	char *name = "erspan_opts";
+	char strbuf[rem * 2 + 1];
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
+	open_json_array(PRINT_JSON, name);
+	open_json_object(NULL);
+	print_uint(PRINT_JSON, "ver", NULL, ver);
+	print_uint(PRINT_JSON, "index", NULL, idx);
+	print_uint(PRINT_JSON, "dir", NULL, dir);
+	print_uint(PRINT_JSON, "hwid", NULL, hwid);
+	close_json_object();
+	close_json_array(PRINT_JSON, name);
+
+	print_nl();
+	print_string(PRINT_FP, name, "\t%s ", name);
+	sprintf(strbuf, "%02x:%08x:%02x:%02x", ver, idx, dir, hwid);
+	print_string(PRINT_FP, NULL, "%s", strbuf);
+}
+
 static void tunnel_key_print_key_opt(struct rtattr *attr)
 {
 	struct rtattr *tb[TCA_TUNNEL_KEY_ENC_OPTS_MAX + 1];
@@ -533,6 +649,9 @@ static void tunnel_key_print_key_opt(struct rtattr *attr)
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

