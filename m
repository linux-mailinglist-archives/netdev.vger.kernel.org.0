Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89820B3535
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730544AbfIPHKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:10:48 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35482 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730480AbfIPHKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:10:47 -0400
Received: by mail-pg1-f193.google.com with SMTP id a24so122529pgj.2
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 00:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=pL1mMVannFuUhE4kdVAPe+CQbYFEE4wP/Rsat0voxjg=;
        b=bde28TcIgydOsuQBS8K+OAe9DozmeUnmXx+iNEluccJxJkgTHfv/sxt2vkuNaumGJF
         QCv0o4NzT6i+2YJpGjyelunl4OUYMKamMSKrlQu6oQ2UIukzF5HxbQQQ60ixRK9tSHLQ
         Gi9DbeThThI9Coe4B4rW/y5MeI3pcFbCD2ZecT86Crf5DnbZGTi5subxHQ6Kmm7zdvS8
         Hdomb6k5XbddRC01RJW66yeE1Z1kEqTCDWTRpnQRmCtlSft/XgYURoA+S2iyu0lSDNS2
         AH4HR9yBsyr9MAjJwZav6Nb6oJXuPJmHJQU4ahYCJghguTSzeIUaTx5q7dcuCmHTxbZS
         KyuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=pL1mMVannFuUhE4kdVAPe+CQbYFEE4wP/Rsat0voxjg=;
        b=PsYoP0oWufqP/nTMGASrGGNotQCQOx/J2Bsv628S7rE9ha+2Cq6Ifwzvm0w0c6Uu2N
         QlkThha5Lf26YfzQ8p1FRB326FFJpSJfNROSjWK8v+Cis3Nu61jSai5rO6zgdOmRYr7v
         4KmVwY4pQPpD0+0lFMsNR3Y5E9M1Q8o5xvT8u2Scr2ue/mk4I37lCWawDQihArspq8a/
         UU8KKWR/TAv6NsEjLOEAWOnCbQcySmOHiTRaeWi1S055tSSLybW3mumGvaMrGin5kuKm
         JjsEjIriWSn65yVwqBd1r7InEYW7ssNupfDm/1Aijk3psVmLTtB2m8d6bCdJ83h2UG3X
         /GsQ==
X-Gm-Message-State: APjAAAUy0JL1iK4/qqiBsWUJw7pw71siZ0AoN7DqskdCH2RpSRTSiuuP
        Cleatn6KKciqQJh1Yd2BV0xyq3P5VSE=
X-Google-Smtp-Source: APXvYqztAR6CY4PGpXidXsEfnqoJAtoBt00smjjKIsbzz3LRC/QIdyUshdyuZ3qaLxbBMA0P/gsadA==
X-Received: by 2002:a65:41cb:: with SMTP id b11mr23041333pgq.241.1568617845510;
        Mon, 16 Sep 2019 00:10:45 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k5sm30729413pgo.45.2019.09.16.00.10.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 00:10:44 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jiri Benc <jbenc@redhat.com>,
        Thomas Graf <tgraf@suug.ch>, u9012063@gmail.com
Subject: [PATCH net-next 2/6] lwtunnel: add LWTUNNEL_IP_OPTS support for lwtunnel_ip
Date:   Mon, 16 Sep 2019 15:10:16 +0800
Message-Id: <c8ce746cdbfe59ef332997e1ad87e88af49aac5b.1568617721.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <ec8435ca550a364b793bd8f307d6c2751931e684.1568617721.git.lucien.xin@gmail.com>
References: <cover.1568617721.git.lucien.xin@gmail.com>
 <ec8435ca550a364b793bd8f307d6c2751931e684.1568617721.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1568617721.git.lucien.xin@gmail.com>
References: <cover.1568617721.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add LWTUNNEL_IP_OPTS into lwtunnel_ip_t, by which
users will be able to set options for ip_tunnel_info by "ip route
encap" for erspan and vxlan's private metadata. Like one way to go
in iproute is:

  # ip route add 1.1.1.0/24 encap ip id 1 erspan ver 1 idx 123 \
      dst 10.1.0.2 dev erspan1
  # ip route show
    1.1.1.0/24  encap ip id 1 src 0.0.0.0 dst 10.1.0.2 ttl 0 \
      tos 0 erspan ver 1 idx 123 dev erspan1 scope link

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/lwtunnel.h |  1 +
 net/ipv4/ip_tunnel_core.c     | 30 ++++++++++++++++++++++++------
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/lwtunnel.h b/include/uapi/linux/lwtunnel.h
index de696ca..93f2c05 100644
--- a/include/uapi/linux/lwtunnel.h
+++ b/include/uapi/linux/lwtunnel.h
@@ -27,6 +27,7 @@ enum lwtunnel_ip_t {
 	LWTUNNEL_IP_TOS,
 	LWTUNNEL_IP_FLAGS,
 	LWTUNNEL_IP_PAD,
+	LWTUNNEL_IP_OPTS,
 	__LWTUNNEL_IP_MAX,
 };
 
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 10f0848..d9b7188 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -218,6 +218,7 @@ static const struct nla_policy ip_tun_policy[LWTUNNEL_IP_MAX + 1] = {
 	[LWTUNNEL_IP_TTL]	= { .type = NLA_U8 },
 	[LWTUNNEL_IP_TOS]	= { .type = NLA_U8 },
 	[LWTUNNEL_IP_FLAGS]	= { .type = NLA_U16 },
+	[LWTUNNEL_IP_OPTS]	= { .type = NLA_BINARY },
 };
 
 static int ip_tun_build_state(struct nlattr *attr,
@@ -228,14 +229,20 @@ static int ip_tun_build_state(struct nlattr *attr,
 	struct ip_tunnel_info *tun_info;
 	struct lwtunnel_state *new_state;
 	struct nlattr *tb[LWTUNNEL_IP_MAX + 1];
-	int err;
+	int err, opts_len = 0;
+	void *opts;
 
 	err = nla_parse_nested_deprecated(tb, LWTUNNEL_IP_MAX, attr,
 					  ip_tun_policy, extack);
 	if (err < 0)
 		return err;
 
-	new_state = lwtunnel_state_alloc(sizeof(*tun_info));
+	if (tb[LWTUNNEL_IP_OPTS]) {
+		opts = nla_data(tb[LWTUNNEL_IP_OPTS]);
+		opts_len = nla_len(tb[LWTUNNEL_IP_OPTS]);
+	}
+
+	new_state = lwtunnel_state_alloc(sizeof(*tun_info) + opts_len);
 	if (!new_state)
 		return -ENOMEM;
 
@@ -269,8 +276,10 @@ static int ip_tun_build_state(struct nlattr *attr,
 	if (tb[LWTUNNEL_IP_FLAGS])
 		tun_info->key.tun_flags = nla_get_be16(tb[LWTUNNEL_IP_FLAGS]);
 
+	if (opts_len)
+		ip_tunnel_info_opts_set(tun_info, opts, opts_len, 0);
+
 	tun_info->mode = IP_TUNNEL_INFO_TX;
-	tun_info->options_len = 0;
 
 	*ts = new_state;
 
@@ -299,6 +308,10 @@ static int ip_tun_fill_encap_info(struct sk_buff *skb,
 	    nla_put_u8(skb, LWTUNNEL_IP_TTL, tun_info->key.ttl) ||
 	    nla_put_be16(skb, LWTUNNEL_IP_FLAGS, tun_info->key.tun_flags))
 		return -ENOMEM;
+	if (tun_info->options_len &&
+	    nla_put(skb, LWTUNNEL_IP_OPTS,
+		    tun_info->options_len, ip_tunnel_info_opts(tun_info)))
+		return -ENOMEM;
 
 	return 0;
 }
@@ -310,13 +323,18 @@ static int ip_tun_encap_nlsize(struct lwtunnel_state *lwtstate)
 		+ nla_total_size(4)	/* LWTUNNEL_IP_SRC */
 		+ nla_total_size(1)	/* LWTUNNEL_IP_TOS */
 		+ nla_total_size(1)	/* LWTUNNEL_IP_TTL */
-		+ nla_total_size(2);	/* LWTUNNEL_IP_FLAGS */
+		+ nla_total_size(2)	/* LWTUNNEL_IP_FLAGS */
+		+ lwt_tun_info(lwtstate)->options_len;	/* LWTUNNEL_IP_OPTS */
 }
 
 static int ip_tun_cmp_encap(struct lwtunnel_state *a, struct lwtunnel_state *b)
 {
-	return memcmp(lwt_tun_info(a), lwt_tun_info(b),
-		      sizeof(struct ip_tunnel_info));
+	struct ip_tunnel_info *info_a = lwt_tun_info(a);
+	struct ip_tunnel_info *info_b = lwt_tun_info(b);
+	u8 opts_len;
+
+	opts_len = min(info_a->options_len, info_b->options_len);
+	return memcmp(info_a, info_b, sizeof(*info_a) + opts_len);
 }
 
 static const struct lwtunnel_encap_ops ip_tun_lwt_ops = {
-- 
2.1.0

