Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A32B3536
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbfIPHK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:10:56 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42623 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730480AbfIPHKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:10:54 -0400
Received: by mail-pf1-f193.google.com with SMTP id q12so2110026pff.9
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 00:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=XeqeRvViHTLurBdfVnuCQjabXl9mX1x41fqyJbmvAjI=;
        b=BD7Amx8Y+XUkEkjr1dbPSrjHX8DASbeU4HRXJlqmPndNT9cyCTIqYlQcDne8Zawg8I
         XkltWRtCMHoMWf2g8OBN2SvjESi1UJJiWzPmBzZaDvhx0oxv68aWmyWDa/9FItZN/qen
         GQW6nkakDPo7jNo+npdeAEinzSngvOwJAEt0MV9VqYjnUnkG3mSmaHU39H/UQQCyJyoo
         43BdjQ/eLyBa7b5u9InzmI8r17P+r9P1fOJSV3hyle3wUP7kK+/02+Xg4mBqra7ZfRNG
         gQlVwaIYMXUIyZbzZf6MG/4sKUXrZ0Zb+/zhaTdLMgXc+F3B9CL8Enf9/aJ1TsTE5qWO
         ENTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=XeqeRvViHTLurBdfVnuCQjabXl9mX1x41fqyJbmvAjI=;
        b=JBMmiFu1v5+VpXpkjRyKiWao+/i2ofYYluoOf6c0ea9VP+YBP7ed8OFk65tvKAckcx
         gn1pdTvBW447T/V87wsNPiqBwEppzbEwMEK2vEiuZUPtr0YRagCy9P4wVBfU3RbZXaVQ
         /bT4mibMP85q6kFdnSokn7TZnOq8XgcXv835GKgbAFtKoCJmyY98NMCki8n2p3FLVXwJ
         g57Ki4HFyErH1QlyBB3Wh/RF0zlwI7U63eJ6QK71Fw3by057m3sFyBnr0tszcezu/pC9
         pmOlKq27tnGlVdB92CGAild6tkCxQJPrOKU5hqyJLZPT7VMNEB7zmu971V7hPlXufuoL
         gTdQ==
X-Gm-Message-State: APjAAAUARWTvgLvIHUDdID+1JVjGf6/SpPIHkibCLc8GHO6U/w4FPI05
        APyyuv19av2gT2zFtqTNM/vAdU/yO28=
X-Google-Smtp-Source: APXvYqzGQfbVjFGVcRYnSB5wwZWy97xhhgUPya/l3k7Ns5MODku5N95Wg2Xy6LhsZQqA31ZrASd0Zg==
X-Received: by 2002:a17:90a:890c:: with SMTP id u12mr19171188pjn.117.1568617853867;
        Mon, 16 Sep 2019 00:10:53 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w134sm40326382pfd.4.2019.09.16.00.10.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 00:10:53 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jiri Benc <jbenc@redhat.com>,
        Thomas Graf <tgraf@suug.ch>, u9012063@gmail.com
Subject: [PATCH net-next 3/6] lwtunnel: add LWTUNNEL_IP6_OPTS support for lwtunnel_ip6
Date:   Mon, 16 Sep 2019 15:10:17 +0800
Message-Id: <25b60ddb9a54413e20d5a55e9e03454c82e4561d.1568617721.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <c8ce746cdbfe59ef332997e1ad87e88af49aac5b.1568617721.git.lucien.xin@gmail.com>
References: <cover.1568617721.git.lucien.xin@gmail.com>
 <ec8435ca550a364b793bd8f307d6c2751931e684.1568617721.git.lucien.xin@gmail.com>
 <c8ce746cdbfe59ef332997e1ad87e88af49aac5b.1568617721.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1568617721.git.lucien.xin@gmail.com>
References: <cover.1568617721.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to lwtunnel_ip, this patch is to add options set/dump support
for lwtunnel_ip6.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/lwtunnel.h |  1 +
 net/ipv4/ip_tunnel_core.c     | 22 ++++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/lwtunnel.h b/include/uapi/linux/lwtunnel.h
index 93f2c05..4bed5e6 100644
--- a/include/uapi/linux/lwtunnel.h
+++ b/include/uapi/linux/lwtunnel.h
@@ -42,6 +42,7 @@ enum lwtunnel_ip6_t {
 	LWTUNNEL_IP6_TC,
 	LWTUNNEL_IP6_FLAGS,
 	LWTUNNEL_IP6_PAD,
+	LWTUNNEL_IP6_OPTS,
 	__LWTUNNEL_IP6_MAX,
 };
 
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index d9b7188..c8f5375a 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -353,6 +353,7 @@ static const struct nla_policy ip6_tun_policy[LWTUNNEL_IP6_MAX + 1] = {
 	[LWTUNNEL_IP6_HOPLIMIT]		= { .type = NLA_U8 },
 	[LWTUNNEL_IP6_TC]		= { .type = NLA_U8 },
 	[LWTUNNEL_IP6_FLAGS]		= { .type = NLA_U16 },
+	[LWTUNNEL_IP6_OPTS]		= { .type = NLA_BINARY },
 };
 
 static int ip6_tun_build_state(struct nlattr *attr,
@@ -363,14 +364,20 @@ static int ip6_tun_build_state(struct nlattr *attr,
 	struct ip_tunnel_info *tun_info;
 	struct lwtunnel_state *new_state;
 	struct nlattr *tb[LWTUNNEL_IP6_MAX + 1];
-	int err;
+	int err, opts_len = 0;
+	void *opts;
 
 	err = nla_parse_nested_deprecated(tb, LWTUNNEL_IP6_MAX, attr,
 					  ip6_tun_policy, extack);
 	if (err < 0)
 		return err;
 
-	new_state = lwtunnel_state_alloc(sizeof(*tun_info));
+	if (tb[LWTUNNEL_IP6_OPTS]) {
+		opts = nla_data(tb[LWTUNNEL_IP6_OPTS]);
+		opts_len = nla_len(tb[LWTUNNEL_IP6_OPTS]);
+	}
+
+	new_state = lwtunnel_state_alloc(sizeof(*tun_info)  + opts_len);
 	if (!new_state)
 		return -ENOMEM;
 
@@ -396,8 +403,10 @@ static int ip6_tun_build_state(struct nlattr *attr,
 	if (tb[LWTUNNEL_IP6_FLAGS])
 		tun_info->key.tun_flags = nla_get_be16(tb[LWTUNNEL_IP6_FLAGS]);
 
+	if (opts_len)
+		ip_tunnel_info_opts_set(tun_info, opts, opts_len, 0);
+
 	tun_info->mode = IP_TUNNEL_INFO_TX | IP_TUNNEL_INFO_IPV6;
-	tun_info->options_len = 0;
 
 	*ts = new_state;
 
@@ -417,6 +426,10 @@ static int ip6_tun_fill_encap_info(struct sk_buff *skb,
 	    nla_put_u8(skb, LWTUNNEL_IP6_HOPLIMIT, tun_info->key.ttl) ||
 	    nla_put_be16(skb, LWTUNNEL_IP6_FLAGS, tun_info->key.tun_flags))
 		return -ENOMEM;
+	if (tun_info->options_len &&
+	    nla_put(skb, LWTUNNEL_IP6_OPTS,
+		    tun_info->options_len, ip_tunnel_info_opts(tun_info)))
+		return -ENOMEM;
 
 	return 0;
 }
@@ -428,7 +441,8 @@ static int ip6_tun_encap_nlsize(struct lwtunnel_state *lwtstate)
 		+ nla_total_size(16)	/* LWTUNNEL_IP6_SRC */
 		+ nla_total_size(1)	/* LWTUNNEL_IP6_HOPLIMIT */
 		+ nla_total_size(1)	/* LWTUNNEL_IP6_TC */
-		+ nla_total_size(2);	/* LWTUNNEL_IP6_FLAGS */
+		+ nla_total_size(2)	/* LWTUNNEL_IP6_FLAGS */
+		+ lwt_tun_info(lwtstate)->options_len;  /* LWTUNNEL_IP6_OPTS */
 }
 
 static const struct lwtunnel_encap_ops ip6_tun_lwt_ops = {
-- 
2.1.0

