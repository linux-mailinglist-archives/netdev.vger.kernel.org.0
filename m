Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C742CFD63
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 17:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfJHPQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 11:16:43 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:40320 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfJHPQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 11:16:42 -0400
Received: by mail-pg1-f170.google.com with SMTP id d26so10410926pgl.7
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 08:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=pL1mMVannFuUhE4kdVAPe+CQbYFEE4wP/Rsat0voxjg=;
        b=Tkd1HHZZdZrPajzIgPzvPS4xokRkGLWWNL9ZTzpkUKLLWaHVyA/j3GJUV3B9igzZsd
         D6MAriJUut4wlN9YqM/kSmEV9RCUp/TVHxX0CQsRjsYHkj5MScYlK9Oogqjwc8UkHl3a
         N/2K4uqOYZy41q82GgCtFjn6Ll2jqZODBBBmFvqwLukEyidRmX2cdfV9vFvBIVkwkfdj
         kZG0xrv8CvRg8PDctb3g0iprwi8Y4amWp4n6nj4vQucc8FDJRrs0BiV7RAeSRL8/KyE0
         amhaM5eu+mjQ5yFbFG81Ybim/RNqsgQt9j7qVuyZFQoRmGVWhUWV+Fpf+cMxcoxoWpsT
         dChg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=pL1mMVannFuUhE4kdVAPe+CQbYFEE4wP/Rsat0voxjg=;
        b=fJPT+OqBOa99wISQ1mJiuOaCIJtzlA7L9C19JbZI7wXBzS+ES+43Js4Gu7KKs/bNhD
         hPufSO1DcwV6tlTQI/sYa6izWykiFHnuwXsqB7Nk449iC1QlAR59SvbR+hZRVtG23izi
         SFCSELPrNzj+Ni/uxdXJt2Bm4WTdkpoLHrccYgH04blDQ6tq2IfG9/7AShDUGp4EJzBg
         K3IO6izeB76+/v7vfBdpRwHnNDrdJl2K4g1frHiqLmsZJJ6EpfS0AnWR/32QQpPW7W2q
         0IOri0Y08YV4Gnw66rBQVlr6u+5g9/UDh4lMQs/WpWUF3OiXaFn+3LcvK04SfKlDaaHX
         jiKA==
X-Gm-Message-State: APjAAAXZ23HB+03gxWFN9DuRfnUCxenrISHyBckXnxDRGv+p9siFWqVp
        vXZK3uVsoPUu2CEtBDa7ZIaCiicI
X-Google-Smtp-Source: APXvYqyukPscHEOGxRWkRZVKVSUJKsRyc+6UklZFBaqxTYAaQ5RtX0aXa5h55UJ8hN8l0VLFm5RmMw==
X-Received: by 2002:a17:90a:8c15:: with SMTP id a21mr6181769pjo.99.1570547801456;
        Tue, 08 Oct 2019 08:16:41 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c64sm19073558pfc.19.2019.10.08.08.16.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 08:16:40 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jiri Benc <jbenc@redhat.com>,
        Thomas Graf <tgraf@suug.ch>, u9012063@gmail.com
Subject: [PATCHv2 net-next 2/6] lwtunnel: add LWTUNNEL_IP_OPTS support for lwtunnel_ip
Date:   Tue,  8 Oct 2019 23:16:12 +0800
Message-Id: <f73e560fafd61494146ff8f08bebead4b7ac6782.1570547676.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <d29fbb1833cea0e9aff96317b9e49f230ca6d3dc.1570547676.git.lucien.xin@gmail.com>
References: <cover.1570547676.git.lucien.xin@gmail.com>
 <d29fbb1833cea0e9aff96317b9e49f230ca6d3dc.1570547676.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1570547676.git.lucien.xin@gmail.com>
References: <cover.1570547676.git.lucien.xin@gmail.com>
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

