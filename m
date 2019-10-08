Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C34CFD65
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 17:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbfJHPQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 11:16:51 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35676 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727503AbfJHPQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 11:16:51 -0400
Received: by mail-pl1-f195.google.com with SMTP id c3so7113153plo.2
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 08:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=XeqeRvViHTLurBdfVnuCQjabXl9mX1x41fqyJbmvAjI=;
        b=qgedUBgpBxkTNPPSYbtlcVlkvcTRPdBOFp0d7SQr5ZZYQg1nQs8bf89JKVTA/h0lh9
         2urw8JCtYhrKGuc0lpY/WcW0tIz+d9xoGnmS2p29UEl4UF+otqNXgq4mNA7L9W6M3WoI
         7k6nQZgxDsHtMc13Pf56UbczDUHNftFKEMXVDSQH8qSTRb8bYZA5O+xVrQuQTumiRVlw
         O2KDkV5CzBw8VOBakZFhIZndCJ0sHFETUbTr+HJaxa2nZuHGsBh+MR8k8mZ160NNxA7l
         srG7aIpxNB5ordhBjf0EJKWt80puGQvBYH/Lx9U+zaOnauIti+CF0rjoJos9MgcSLfq/
         zaXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=XeqeRvViHTLurBdfVnuCQjabXl9mX1x41fqyJbmvAjI=;
        b=MDcb5agkgyZL9CkGb/VUQmqsU5nbo67EMnpEqNgeFP87grQw45ek4LGhHCkuqmkgCf
         +PLGRb3gaH5Tz0HGUJ6hsPHS7tjSHsm/zAAzWFxo7yvdcskjkaqnkm8xbalEAtl+f4qm
         ZyJB8ZavAHDRW3MWj+Xmv0e/pnbNuMnfzOSvYHSKkf0CIVxX4JqJHNZYKZGZI2QDIuLq
         +heKGYQ7madMPKbHuy+CgyKxBKku8KfHOIUcn6U+YES6RbysWGfCw5sNmWzMuQdGwjDb
         iEAcQSlV/KEG/sdETAP04/0lilr77BucIQqS6YwDip4EXopd5nTh2KXuayC3deeZzSN7
         zTKQ==
X-Gm-Message-State: APjAAAXBTEGrwHTFzCVMtOL/3s4/5ivPibpe5tiveOqU+lSevjWO45XU
        iaOa0BoC/DdDWK8JpLmeyYaXK5AQ
X-Google-Smtp-Source: APXvYqzGaa7sRGkfFc/tJCtupeS5KeQW2lwMSfz66cpcmd3Eg6zf9prIe9qNi21yViKqXIIYBZ2aaQ==
X-Received: by 2002:a17:902:8bca:: with SMTP id r10mr35955919plo.233.1570547809772;
        Tue, 08 Oct 2019 08:16:49 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f15sm16803396pfd.141.2019.10.08.08.16.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 08:16:49 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jiri Benc <jbenc@redhat.com>,
        Thomas Graf <tgraf@suug.ch>, u9012063@gmail.com
Subject: [PATCHv2 net-next 3/6] lwtunnel: add LWTUNNEL_IP6_OPTS support for lwtunnel_ip6
Date:   Tue,  8 Oct 2019 23:16:13 +0800
Message-Id: <db1089611398f17980ddfb54568c95837928e5a9.1570547676.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <f73e560fafd61494146ff8f08bebead4b7ac6782.1570547676.git.lucien.xin@gmail.com>
References: <cover.1570547676.git.lucien.xin@gmail.com>
 <d29fbb1833cea0e9aff96317b9e49f230ca6d3dc.1570547676.git.lucien.xin@gmail.com>
 <f73e560fafd61494146ff8f08bebead4b7ac6782.1570547676.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1570547676.git.lucien.xin@gmail.com>
References: <cover.1570547676.git.lucien.xin@gmail.com>
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

