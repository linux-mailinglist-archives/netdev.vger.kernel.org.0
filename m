Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C95CF15BE11
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 12:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729909AbgBML5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 06:57:41 -0500
Received: from mail-pl1-f182.google.com ([209.85.214.182]:38326 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729531AbgBML5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 06:57:41 -0500
Received: by mail-pl1-f182.google.com with SMTP id t6so2265269plj.5
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 03:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=9oIzHBzlS1sZpCYlRe6xBuHIv2bBp84NhUD0Z0Z1Sc8=;
        b=TVHO320STMjFDnGgkNDoqr6btkLi8frTL+LAGUK/bPI1arAT22aj90/Kjk0T72oeSm
         0QYLEmCb21LQx9Taj7sLN+I+NgWPCA3ACn027q+DDqqYyrvwlLp/j9ytU9OYCpiENI1a
         AkZmG9tF5ENia/c3vYYQFsRi8PRJGfOcvzvvOOGkZ4C/5uDasTpR4a0AofxFGPr2llqG
         ZGNcIOq0l1wSwNC+jZd/oY4pLciHudj4lrfG/7fCW/08nQtBK74+m6r5OBmdPMel10Gw
         kv3sT/SgS0vEn6rtcg0pqK6zwhv6/Y/Q0qAZWN+/cAe6AdJlq2GVSt3BhiUZlpR71Wfp
         pV2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=9oIzHBzlS1sZpCYlRe6xBuHIv2bBp84NhUD0Z0Z1Sc8=;
        b=lC02ZeDp0hwCBRCLP0/+CgzIuKsNFouU2owSiaYt6uKu5Y3MB++tOZK/KO67jGJqPA
         p/47ZMgeV+Sd+oJ+Xi3SZcOOpXepm9Gpq2dFp/z0Q9bSp9g4p+z6pjmqMJLhfm+r0/fi
         FtN7RjZCyb23HK0VYbmCGVxBwHjs0BVO35U6+bxrF0wNEoUkek2fkdMMKp7nxCpTahrq
         ojJcyWoGF6OD4ZkhuXQUqSLMKVAKfrwVOZS1t68R/sT++TtKiD4wOvy+lrxtui0I8Zth
         W1DcYki0ShvzLRmbhoPpWveq2PJb1wjL3gb3YYB6ulimHPubv/joCbE4H6unoFSGrTpq
         wFLA==
X-Gm-Message-State: APjAAAVrTfeznR6NxVZ/cRvQAII89rrhZONFJBSXqXw7VG1nCGcqj3HP
        GA3l+JsKZ0hUXT2HHO2+jxWvn3cm
X-Google-Smtp-Source: APXvYqxVcNBvJ8Hq5zXtlE4Lnv1OVHeoY29lVQDwP7bRcD+fUzHvcQbZrfEv9P9CwHdAbOieixog1g==
X-Received: by 2002:a17:902:34a:: with SMTP id 68mr12704709pld.250.1581595058748;
        Thu, 13 Feb 2020 03:57:38 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 200sm2892168pfz.121.2020.02.13.03.57.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Feb 2020 03:57:38 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>
Subject: [PATCHv2 iproute2-next 3/7] iproute_lwtunnel: add options support for erspan metadata
Date:   Thu, 13 Feb 2020 19:57:01 +0800
Message-Id: <f34d6f4b5002bba1433958b73e193843d1b06d86.1581594682.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <0bf376a8304996ec0edf0b14111a2c924a44b5ff.1581594682.git.lucien.xin@gmail.com>
References: <cover.1581594682.git.lucien.xin@gmail.com>
 <0fd1ae76c7689ab4fbd7c9f9fb85adf063154bdb.1581594682.git.lucien.xin@gmail.com>
 <0bf376a8304996ec0edf0b14111a2c924a44b5ff.1581594682.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1581594682.git.lucien.xin@gmail.com>
References: <cover.1581594682.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add LWTUNNEL_IP_OPTS_ERSPAN's parse and print to implement
erspan options support in iproute_lwtunnel.

Option is expressed as version:index:dir:hwid, dir and hwid will be parsed
when version is 2, while index will be parsed when version is 1. erspan
doesn't support multiple options.

With this patch, users can add and dump erspan options like:

  # ip netns add a
  # ip netns add b
  # ip -n a link add eth0 type veth peer name eth0 netns b
  # ip -n a link set eth0 up
  # ip -n b link set eth0 up
  # ip -n a addr add 10.1.0.1/24 dev eth0
  # ip -n b addr add 10.1.0.2/24 dev eth0
  # ip -n b link add erspan1 type erspan key 1 seq erspan 123 \
    local 10.1.0.2 remote 10.1.0.1
  # ip -n b addr add 1.1.1.1/24 dev erspan1
  # ip -n b link set erspan1 up
  # ip -n b route add 2.1.1.0/24 dev erspan1
  # ip -n a link add erspan1 type erspan key 1 seq local 10.1.0.1 external
  # ip -n a addr add 2.1.1.1/24 dev erspan1
  # ip -n a link set erspan1 up
  # ip -n a route add 1.1.1.0/24 encap ip id 1 \
    erspan_opts 2:123:1:2 dst 10.1.0.2 dev erspan1
  # ip -n a route show
  # ip netns exec a ping 1.1.1.1 -c 1

   1.1.1.0/24  encap ip id 1 src 0.0.0.0 dst 10.1.0.2 ttl 0 tos 0
     erspan_opts 02:00000000:01:02 dev erspan1 scope link

   PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
   64 bytes from 1.1.1.1: icmp_seq=1 ttl=64 time=0.124 ms

v1->v2:
  - improve the changelog.
  - use PRINT_ANY to support dumping with json format.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 ip/iproute_lwtunnel.c | 133 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 14224b7..22a754b 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -334,6 +334,30 @@ static void lwtunnel_print_vxlan_opts(struct rtattr *attr, char *opt)
 	print_uint(PRINT_ANY, "vxlan_opts", "  vxlan_opts 0x%x ", gbp);
 }
 
+static void lwtunnel_print_erspan_opts(struct rtattr *attr, char *opt)
+{
+	struct rtattr *tb[LWTUNNEL_IP_OPT_ERSPAN_MAX + 1];
+	__u8 ver, hwid, dir;
+	__u32 index;
+
+	parse_rtattr(tb, LWTUNNEL_IP_OPT_ERSPAN_MAX, RTA_DATA(attr),
+		     RTA_PAYLOAD(attr));
+	ver = rta_getattr_u8(tb[LWTUNNEL_IP_OPT_ERSPAN_VER]);
+	if (ver == 1) {
+		index = rta_getattr_be32(tb[LWTUNNEL_IP_OPT_ERSPAN_INDEX]);
+		hwid = 0;
+		dir = 0;
+	} else {
+		index = 0;
+		hwid = rta_getattr_u8(tb[LWTUNNEL_IP_OPT_ERSPAN_HWID]);
+		dir = rta_getattr_u8(tb[LWTUNNEL_IP_OPT_ERSPAN_DIR]);
+	}
+
+	sprintf(opt, "%02x:%08x:%02x:%02x", ver, index, dir, hwid);
+	print_nl();
+	print_string(PRINT_ANY, "erspan_opts", "  erspan_opts %s ", opt);
+}
+
 static void lwtunnel_print_opts(struct rtattr *attr)
 {
 	struct rtattr *tb_opt[LWTUNNEL_IP_OPTS_MAX + 1];
@@ -349,6 +373,9 @@ static void lwtunnel_print_opts(struct rtattr *attr)
 					   opt);
 	else if (tb_opt[LWTUNNEL_IP_OPTS_VXLAN])
 		lwtunnel_print_vxlan_opts(tb_opt[LWTUNNEL_IP_OPTS_VXLAN], opt);
+	else if (tb_opt[LWTUNNEL_IP_OPTS_ERSPAN])
+		lwtunnel_print_erspan_opts(tb_opt[LWTUNNEL_IP_OPTS_ERSPAN],
+					   opt);
 
 	free(opt);
 }
@@ -965,6 +992,82 @@ static int lwtunnel_parse_vxlan_opts(char *str, size_t len, struct rtattr *rta)
 	return 0;
 }
 
+static int lwtunnel_parse_erspan_opts(char *str, size_t len, struct rtattr *rta)
+{
+	struct rtattr *nest;
+	char *token;
+	int i, err;
+
+	nest = rta_nest(rta, len, LWTUNNEL_IP_OPTS_ERSPAN | NLA_F_NESTED);
+	i = 1;
+	token = strsep(&str, ":");
+	while (token) {
+		switch (i) {
+		case LWTUNNEL_IP_OPT_ERSPAN_VER:
+		{
+			__u8 opt_type;
+
+			if (!strlen(token))
+				break;
+			err = get_u8(&opt_type, token, 16);
+			if (err)
+				return err;
+
+			rta_addattr8(rta, len, i, opt_type);
+			break;
+		}
+		case LWTUNNEL_IP_OPT_ERSPAN_INDEX:
+		{
+			__be32 opt_class;
+
+			if (!strlen(token))
+				break;
+			err = get_be32(&opt_class, token, 16);
+			if (err)
+				return err;
+
+			rta_addattr32(rta, len, i, opt_class);
+			break;
+		}
+		case LWTUNNEL_IP_OPT_ERSPAN_DIR:
+		{
+			__u8 opt_type;
+
+			if (!strlen(token))
+				break;
+			err = get_u8(&opt_type, token, 16);
+			if (err)
+				return err;
+
+			rta_addattr8(rta, len, i, opt_type);
+			break;
+		}
+		case LWTUNNEL_IP_OPT_ERSPAN_HWID:
+		{
+			__u8 opt_type;
+
+			if (!strlen(token))
+				break;
+			err = get_u8(&opt_type, token, 16);
+			if (err)
+				return err;
+
+			rta_addattr8(rta, len, i, opt_type);
+			break;
+		}
+		default:
+			fprintf(stderr, "Unknown \"geneve_opts\" type\n");
+			return -1;
+		}
+
+		token = strsep(&str, ":");
+		i++;
+	}
+
+	rta_nest_end(rta, nest);
+	return 0;
+}
+
 static int parse_encap_ip(struct rtattr *rta, size_t len,
 			  int *argcp, char ***argvp)
 {
@@ -1051,6 +1154,21 @@ static int parse_encap_ip(struct rtattr *rta, size_t len,
 				invarg("\"vxlan_opts\" value is invalid\n",
 				       *argv);
 			rta_nest_end(rta, nest);
+		} else if (strcmp(*argv, "erspan_opts") == 0) {
+			struct rtattr *nest;
+
+			if (opts_ok++)
+				duparg2("opts", *argv);
+
+			NEXT_ARG();
+
+			nest = rta_nest(rta, len,
+					LWTUNNEL_IP_OPTS | NLA_F_NESTED);
+			ret = lwtunnel_parse_erspan_opts(*argv, len, rta);
+			if (ret)
+				invarg("\"erspan_opts\" value is invalid\n",
+				       *argv);
+			rta_nest_end(rta, nest);
 		} else if (strcmp(*argv, "key") == 0) {
 			if (key_ok++)
 				duparg2("key", *argv);
@@ -1250,6 +1368,21 @@ static int parse_encap_ip6(struct rtattr *rta, size_t len,
 				invarg("\"vxlan_opts\" value is invalid\n",
 				       *argv);
 			rta_nest_end(rta, nest);
+		} else if (strcmp(*argv, "erspan_opts") == 0) {
+			struct rtattr *nest;
+
+			if (opts_ok++)
+				duparg2("opts", *argv);
+
+			NEXT_ARG();
+
+			nest = rta_nest(rta, len,
+					LWTUNNEL_IP_OPTS | NLA_F_NESTED);
+			ret = lwtunnel_parse_erspan_opts(*argv, len, rta);
+			if (ret)
+				invarg("\"erspan_opts\" value is invalid\n",
+				       *argv);
+			rta_nest_end(rta, nest);
 		} else if (strcmp(*argv, "key") == 0) {
 			if (key_ok++)
 				duparg2("key", *argv);
-- 
2.1.0

