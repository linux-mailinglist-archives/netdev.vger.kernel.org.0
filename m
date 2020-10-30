Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D67D2A0FA5
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 21:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbgJ3Ui2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 16:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727366AbgJ3Ui1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 16:38:27 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBA0C0613CF;
        Fri, 30 Oct 2020 13:38:27 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id z6so6151105qkz.4;
        Fri, 30 Oct 2020 13:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PduwTWItCxNftAk0oyv+w/Vg2mUdPmGVkrLR8E6k2NQ=;
        b=gdxjngGj6cuGY/zDICXmiBva4+A5f1PBieMyOIZNjEOVWK0reiF9nLnjgv2OaQb4w0
         3ndH50g8TkwviAztCAhmBIpnKgksRwd/HfMAw8VdHAZ0qfXl6Mk8PYcMVa/hFtNcUJHH
         ixQPtKW74LUy+YECvUoAhUTSJpBV05owibXWpCch56kBG8mwHysi7FuwpY9HqikOOxL6
         d3KumNMkdTup4Btjj6XyPhZKVfIpyGUh3gYy+aL9PjlLuKfg+duj25dMGQnbqhJoMzov
         JHc/H6TBhFmG2J8XFSB+hc5uZEuhV4ePH0t9uIBd8yEa6magfmCXuxDhw+PNnikXix49
         xjGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PduwTWItCxNftAk0oyv+w/Vg2mUdPmGVkrLR8E6k2NQ=;
        b=piErmCAetP4QbzWXMcZdfEngpCLYW6YDMZzijXKRAHzP9sDM+lcYH8GTc/P4O/QbWk
         4J5sgmlB50kgVWf6VhG7s6loQOmTyYLB16vBxhQb9VEnIi+MMVeRLjiVee9ogsmaDQav
         SQCdl3LUgT1TNlS7s4FEL3TWdBIPPpvsRo656AyfBI97n9J/zCB8khDTQXD2G85yQ77f
         Eplj4c2EnIMCbm7fvilUdivimSLEjgknnjwRzofOZiu1uh4dLVDhJsydpB6eL8iVUpJA
         mL3H4ikLFGb6rn5tlPo2wajiB8Tlri2jHltok6n5fm9wsUMYi3cljJdIT2KJ1ZyxT59y
         iMrg==
X-Gm-Message-State: AOAM530yg8l1dtr4DL3nX7RIwlvfcYyIeOpAI4PyEmLJfN7MpVAtWDL7
        8CNuQWTI6bqG5QTl6LKNknu4lKztHH2RU0/R
X-Google-Smtp-Source: ABdhPJzagaSxB2mA/eAeCTCSZR4G9/1UGYR2gACo97956YAHd9D4Irk5KqdTaPNmxd/+zPXABjk/mQ==
X-Received: by 2002:a05:620a:221:: with SMTP id u1mr4179248qkm.234.1604090306709;
        Fri, 30 Oct 2020 13:38:26 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:65d2:4353:ac6f:ca54:8430:45f8])
        by smtp.gmail.com with ESMTPSA id j50sm648840qtc.5.2020.10.30.13.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 13:38:26 -0700 (PDT)
From:   Cezar Sa Espinola <cezarsa@gmail.com>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Cezar Sa Espinola <cezarsa@gmail.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:IPVS),
        lvs-devel@vger.kernel.org (open list:IPVS),
        linux-kernel@vger.kernel.org (open list),
        netfilter-devel@vger.kernel.org (open list:NETFILTER),
        coreteam@netfilter.org (open list:NETFILTER)
Subject: [PATCH RFC] ipvs: add genetlink cmd to dump all services and destinations
Date:   Fri, 30 Oct 2020 17:27:27 -0300
Message-Id: <20201030202727.1053534-1-cezarsa@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A common operation for userspace applications managing ipvs is to dump
all services and all destinations and then sort out what needs to be
done. Previously this could only be accomplished by issuing 1 netlink
IPVS_CMD_GET_SERVICE dump command followed by N IPVS_CMD_GET_DEST dump
commands. For a dynamic system with a very large number of services this
could be cause a performance impact.

This patch introduces a new way of dumping all services and destinations
with the new IPVS_CMD_GET_SERVICE_DEST command. A dump call for this
command will send the services as IPVS_CMD_NEW_SERVICE messages
imediatelly followed by its destinations as multiple IPVS_CMD_NEW_DEST
messages. It's also possible to dump a single service and its
destinations by sending a IPVS_CMD_ATTR_SERVICE argument to the dump
command.

Signed-off-by: Cezar Sa Espinola <cezarsa@gmail.com>
---

To ensure that this patch improves performance I decided to also patch
ipvsadm in order to run some benchmarks comparing 'ipvsadm -Sn' with the
unpatched version. The ipvsadm patch is available on github in [1] for
now but I intend to submit it if this RFC goes forward.

The benchmarks look nice and detailed results and some scripts to allow
reproducing then are available in another github repository [2]. The
summary of the benchmarks is:

svcs  | dsts | run time compared to unpatched
----- | ---- | ------------------------------
 1000 |    4 | -60.63%
 2000 |    2 | -71.10%
 8000 |    2 | -52.83%
16000 |    1 | -54.13%
  100 |  100 |  -4.76%

[1] - https://github.com/cezarsa/ipvsadm/compare/master...dump-svc-ds
[2] - https://github.com/cezarsa/ipvsadm-validate#benchmark-results

 include/uapi/linux/ip_vs.h     |   2 +
 net/netfilter/ipvs/ip_vs_ctl.c | 109 +++++++++++++++++++++++++++++++++
 2 files changed, 111 insertions(+)

diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
index 4102ddcb4e14..353548cb7b81 100644
--- a/include/uapi/linux/ip_vs.h
+++ b/include/uapi/linux/ip_vs.h
@@ -331,6 +331,8 @@ enum {
 	IPVS_CMD_ZERO,			/* zero all counters and stats */
 	IPVS_CMD_FLUSH,			/* flush services and dests */
 
+	IPVS_CMD_GET_SERVICE_DEST,	/* get service and destination info */
+
 	__IPVS_CMD_MAX,
 };
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index e279ded4e306..09a7dd823dc0 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3396,6 +3396,109 @@ static int ip_vs_genl_dump_dests(struct sk_buff *skb,
 	return skb->len;
 }
 
+struct dump_services_dests_ctx {
+	struct ip_vs_service	*last_svc;
+	int			idx_svc;
+	int			idx_dest;
+	int			start_svc;
+	int			start_dest;
+};
+
+static int ip_vs_genl_dump_service_destinations(struct sk_buff *skb,
+						struct netlink_callback *cb,
+						struct ip_vs_service *svc,
+						struct dump_services_dests_ctx *ctx)
+{
+	struct ip_vs_dest *dest;
+
+	if (++ctx->idx_svc < ctx->start_svc)
+		return 0;
+
+	if (ctx->idx_svc == ctx->start_svc && ctx->last_svc != svc)
+		return 0;
+
+	if (ctx->idx_svc > ctx->start_svc) {
+		if (ip_vs_genl_dump_service(skb, svc, cb) < 0) {
+			ctx->idx_svc--;
+			return -EMSGSIZE;
+		}
+		ctx->last_svc = svc;
+		ctx->start_dest = 0;
+	}
+
+	ctx->idx_dest = 0;
+	list_for_each_entry(dest, &svc->destinations, n_list) {
+		if (++ctx->idx_dest <= ctx->start_dest)
+			continue;
+		if (ip_vs_genl_dump_dest(skb, dest, cb) < 0) {
+			ctx->idx_dest--;
+			return -EMSGSIZE;
+		}
+	}
+
+	return 0;
+}
+
+static int ip_vs_genl_dump_services_destinations(struct sk_buff *skb,
+						 struct netlink_callback *cb)
+{
+	/* Besides usual index based counters, saving a pointer to the last
+	 * dumped service is useful to ensure we only dump destinations that
+	 * belong to it, even when services are removed while the dump is still
+	 * running causing indexes to shift.
+	 */
+	struct dump_services_dests_ctx ctx = {
+		.idx_svc = 0,
+		.idx_dest = 0,
+		.start_svc = cb->args[0],
+		.start_dest = cb->args[1],
+		.last_svc = (struct ip_vs_service *)(cb->args[2]),
+	};
+	struct net *net = sock_net(skb->sk);
+	struct netns_ipvs *ipvs = net_ipvs(net);
+	struct ip_vs_service *svc = NULL;
+	struct nlattr *attrs[IPVS_CMD_ATTR_MAX + 1];
+	int i;
+
+	mutex_lock(&__ip_vs_mutex);
+
+	if (nlmsg_parse_deprecated(cb->nlh, GENL_HDRLEN, attrs, IPVS_CMD_ATTR_MAX,
+				   ip_vs_cmd_policy, cb->extack) == 0) {
+		svc = ip_vs_genl_find_service(ipvs, attrs[IPVS_CMD_ATTR_SERVICE]);
+
+		if (!IS_ERR_OR_NULL(svc)) {
+			ip_vs_genl_dump_service_destinations(skb, cb, svc, &ctx);
+			goto nla_put_failure;
+		}
+	}
+
+	for (i = 0; i < IP_VS_SVC_TAB_SIZE; i++) {
+		hlist_for_each_entry(svc, &ip_vs_svc_table[i], s_list) {
+			if (svc->ipvs != ipvs)
+				continue;
+			if (ip_vs_genl_dump_service_destinations(skb, cb, svc, &ctx) < 0)
+				goto nla_put_failure;
+		}
+	}
+
+	for (i = 0; i < IP_VS_SVC_TAB_SIZE; i++) {
+		hlist_for_each_entry(svc, &ip_vs_svc_fwm_table[i], s_list) {
+			if (svc->ipvs != ipvs)
+				continue;
+			if (ip_vs_genl_dump_service_destinations(skb, cb, svc, &ctx) < 0)
+				goto nla_put_failure;
+		}
+	}
+
+nla_put_failure:
+	mutex_unlock(&__ip_vs_mutex);
+	cb->args[0] = ctx.idx_svc;
+	cb->args[1] = ctx.idx_dest;
+	cb->args[2] = (long)ctx.last_svc;
+
+	return skb->len;
+}
+
 static int ip_vs_genl_parse_dest(struct ip_vs_dest_user_kern *udest,
 				 struct nlattr *nla, bool full_entry)
 {
@@ -3991,6 +4094,12 @@ static const struct genl_small_ops ip_vs_genl_ops[] = {
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= ip_vs_genl_set_cmd,
 	},
+	{
+		.cmd	= IPVS_CMD_GET_SERVICE_DEST,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.flags	= GENL_ADMIN_PERM,
+		.dumpit	= ip_vs_genl_dump_services_destinations,
+	},
 };
 
 static struct genl_family ip_vs_genl_family __ro_after_init = {
-- 
2.25.1

