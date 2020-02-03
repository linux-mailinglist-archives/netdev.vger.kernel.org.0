Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2143150183
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 06:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgBCFkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 00:40:33 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:32864 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbgBCFkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 00:40:32 -0500
Received: by mail-pg1-f194.google.com with SMTP id 6so7199807pgk.0
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 21:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=rPRpNGjAtmV+9EMirzN/MFqZHoHhz6RJIaiuinK+MO4=;
        b=PFsQ1/0Qi17TctDtzfTC0nLHjlqjM3N2RYh82widrB5wjKq52DKieDhQnLhDpwlH8M
         hDNXv3oK8v/ks7J9fxegZ8bs60L8ceOypND+K9baN1n3ImSf/1cJwrLfr6uOLMMQ58V+
         2IVBbKY3AXLqrWHPzh4U/RwV6RM5Newq/72F+wp4xu4xNNsnNXORNfHiMKkCuja8KoyV
         aEf/lI9dXPd498nS6FP7f5+G2AuZ7TQhyYnuBWj/bfyb486qQIwWPmPV17Eb0nIYDABO
         HRZ/BTk3bLh9vpmCH/LT7dG1U8h4/dcpYsJaHi3WDL1mKAAppGDll4OvKSHl2baTHYaR
         Td6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=rPRpNGjAtmV+9EMirzN/MFqZHoHhz6RJIaiuinK+MO4=;
        b=nWrFsp6J893vbmH8WGhZNM3/IpWH7rS+HUKWNg1qhTjwVyIvvPg+DlWwbfXLRp+khh
         KyeT5C67LbqfWeI3CWcuqa0XbGrxGrysLfZEFJ7aRjFAja53+LHFnOXpw/Vwn66KqGhC
         zXE6OjRYpe+sT9Z3/wNTN4D85z4cHC9tAgRQB7YwAsd/Xs5U3vUE6VFzw0dGsIBOQQdS
         K32AQA7bA3ZrDDCKsRvKtbUtAgJIbTIeu3wMgFXp4V53VM+BjdyB0czvK57Z9Wpwiy9L
         tpYwUimH3+9mzL+4c5iP5vEecr1REzAt+bey1Rg+cifYTjU8mfBGUelSdp4xsJdW4L4v
         lh1g==
X-Gm-Message-State: APjAAAVZ2kdjoBlJXQ2Lm5zDwVPIsEzDLFHk1qesSKjN4BzpH2QS2hWo
        mwSFQXd/X0MV2j6y90gRC8CzxZ5J
X-Google-Smtp-Source: APXvYqxzlkkbvLZ0o8bydNWNF7YRsD8eI9/fHPr70wrg6QzRmERDlp9jGn975OU/dCzyLcj9fRuhpg==
X-Received: by 2002:a62:c541:: with SMTP id j62mr23530777pfg.237.1580708431760;
        Sun, 02 Feb 2020 21:40:31 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id az9sm18616726pjb.3.2020.02.02.21.40.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Feb 2020 21:40:31 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: [PATCH iproute2-next 3/7] iproute_lwtunnel: add options support for erspan metadata
Date:   Mon,  3 Feb 2020 13:39:54 +0800
Message-Id: <7d0842940d1d0eb6bc6d39707a378facd8ecb456.1580708369.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <85a6a30aac8eeab7c408fdadfa5419dc1596cf5d.1580708369.git.lucien.xin@gmail.com>
References: <cover.1580708369.git.lucien.xin@gmail.com>
 <93e7cebfeda666b17c6a1b2bb8b5065bdab4814c.1580708369.git.lucien.xin@gmail.com>
 <85a6a30aac8eeab7c408fdadfa5419dc1596cf5d.1580708369.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1580708369.git.lucien.xin@gmail.com>
References: <cover.1580708369.git.lucien.xin@gmail.com>
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

  # ip net d a; ip net d b; ip net a a; ip net a b
  # ip -n a l a eth0 type veth peer name eth0 netns b
  # ip -n a l s eth0 up; ip -n b link set eth0 up
  # ip -n a a a 10.1.0.1/24 dev eth0; ip -n b a a 10.1.0.2/24 dev eth0
  # ip -n b l a erspan1 type erspan key 1 seq erspan 123 \
    local 10.1.0.2 remote 10.1.0.1
  # ip -n b a a 1.1.1.1/24 dev erspan1; ip -n b l s erspan1 up
  # ip -n b r a 2.1.1.0/24 dev erspan1
  # ip -n a l a erspan1 type erspan key 1 seq local 10.1.0.1 external
  # ip -n a a a 2.1.1.1/24 dev erspan1; ip -n a l s erspan1 up
  # ip -n a r a 1.1.1.0/24 encap ip id 1 \
    erspan_opts 2:123:1:2 dst 10.1.0.2 dev erspan1
  # ip -n a r s; ip net exec a ping 1.1.1.1 -c 1

   1.1.1.0/24  encap ip id 1 src 0.0.0.0 dst 10.1.0.2 ttl 0 tos 0
     erspan_opts 02:00000000:01:02 dev erspan1 scope link

   PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
   64 bytes from 1.1.1.1: icmp_seq=1 ttl=64 time=0.124 ms

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 ip/iproute_lwtunnel.c | 132 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 132 insertions(+)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 741569e..ff913b1 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -333,6 +333,29 @@ static void lwtunnel_print_vxlan_opts(struct rtattr *attr, char *opt)
 	print_string(PRINT_FP, "enc_opt", "\n  vxlan_opts %s ", opt);
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
+	print_string(PRINT_FP, "enc_opt", "\n  erspan_opts %s ", opt);
+}
+
 static void lwtunnel_print_opts(struct rtattr *attr)
 {
 	struct rtattr *tb_opt[LWTUNNEL_IP_OPTS_MAX + 1];
@@ -348,6 +371,9 @@ static void lwtunnel_print_opts(struct rtattr *attr)
 					   opt);
 	else if (tb_opt[LWTUNNEL_IP_OPTS_VXLAN])
 		lwtunnel_print_vxlan_opts(tb_opt[LWTUNNEL_IP_OPTS_VXLAN], opt);
+	else if (tb_opt[LWTUNNEL_IP_OPTS_ERSPAN])
+		lwtunnel_print_erspan_opts(tb_opt[LWTUNNEL_IP_OPTS_ERSPAN],
+					   opt);
 
 	free(opt);
 }
@@ -964,6 +990,82 @@ static int lwtunnel_parse_vxlan_opts(char *str, size_t len, struct rtattr *rta)
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
@@ -1050,6 +1152,21 @@ static int parse_encap_ip(struct rtattr *rta, size_t len,
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
@@ -1249,6 +1366,21 @@ static int parse_encap_ip6(struct rtattr *rta, size_t len,
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

