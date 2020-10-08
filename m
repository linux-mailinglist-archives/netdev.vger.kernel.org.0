Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6F62871F0
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbgJHJuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgJHJuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:50:13 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BB3C061755;
        Thu,  8 Oct 2020 02:50:13 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 144so3549179pfb.4;
        Thu, 08 Oct 2020 02:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=zpcgNpTt1Eopd9QaDKGy8sWqns6Rwfi4+2UKE6Sn+wQ=;
        b=JSJqqg3E7gXGgbVdJAiyQkDh8yVQCW7EVdbcUpGBbH4WrXgGZhLTWrJmajUTmhPoEi
         mLuNKfTO5i1ghIgxb+4Ac+q57baqp0G6PBbpB6PV+awHWxltHN+Hvki9twl0pq018nSP
         AjhtxJyhxvtDFUyp3jfTkoZOE5F0+38Z4XjTOSrbJ5ClrfT9ZcQMJBH7cVjQYh8kp+Ot
         EfXqHJbEj2DgZ0hC/C5D6KBWmzj0sNGANUN1iA4HfOSqoFIxmqMR1VAAhaHPAwQisfju
         RY2l+4vf5GM3svUeJyHnIrAxqjFfOBYadHjMKPPx8daOmUvgnjWOboO6F8FK8D+6Ies4
         e3WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=zpcgNpTt1Eopd9QaDKGy8sWqns6Rwfi4+2UKE6Sn+wQ=;
        b=KvwSwG522L7JjnfOyUYxtWr8jtUwvijFh8BRkZUGIxc40T+0toVcjAOERbCmw7SnTI
         4X3k6RHK6NfAio82bf2JUSAWTFgg/D6zS5DFm0WzzTo5qUG2nxX1WARbBOHdbQr57uaI
         qIpCCC9ABZHUTWsT2gabLGaCG63lTHpf5bgCC1IjazSiXhdKyWeWIR5OcE/x2hd6xWyw
         8Hi1rqPEzuiMV0727zQSMbpwb4BbcqTy9h2dEpj2l8mNafjehPL7Qqrwxnno5q8kCXte
         uUwv0ZWdA1AxEXezUDjCJnwFig8y8cD4+H4WX90xqiBM3mF/awFjaPK9MFvFpRMbCDE5
         E/2w==
X-Gm-Message-State: AOAM531WhsrxPvcf2TZKAeB2vCFN85j1bfG9FbyiZEf/ZY91O/ykwNZ6
        4OjPMzwK+RCE8903IiunS5sdt/H7eJA=
X-Google-Smtp-Source: ABdhPJzhlaX/UapeJvm9Od3aYl3WQ6Up7e3sAJ9GUv2QQvWGlktPYrx8XGJm79YvoReBORwfmO9pzQ==
X-Received: by 2002:a17:90a:e697:: with SMTP id s23mr6984491pjy.16.1602150612658;
        Thu, 08 Oct 2020 02:50:12 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gk14sm6198727pjb.41.2020.10.08.02.50.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:50:12 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net
Subject: [PATCHv2 net-next 14/17] sctp: support for sending packet over udp6 sock
Date:   Thu,  8 Oct 2020 17:48:10 +0800
Message-Id: <5c0e9cf835f54c11f7e3014cab926bf10a47298d.1602150362.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1d1b2e92f958add640d5be1e6eaec1ac5e4581ce.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
 <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
 <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
 <483d9eec159b22172fe04dacd58d7f88dfc2f301.1602150362.git.lucien.xin@gmail.com>
 <17cab00046ea7fe36c8383925a4fc3fbc028c511.1602150362.git.lucien.xin@gmail.com>
 <6f5a15bba0e2b5d3da6be90fd222c5ee41691d32.1602150362.git.lucien.xin@gmail.com>
 <af7bd8219b32d7f864eaef8ed8e970fc9bde928c.1602150362.git.lucien.xin@gmail.com>
 <baba90f09cbb5de03a6216c9f6308d0e4fb2f3c1.1602150362.git.lucien.xin@gmail.com>
 <bcb5453d0f8abd3d499c8af467340ade1698af11.1602150362.git.lucien.xin@gmail.com>
 <bdbd57b89b92716d17fecce1f658c60cca261bee.1602150362.git.lucien.xin@gmail.com>
 <92d28810a72dee9d0d49e7433b65027cb52de191.1602150362.git.lucien.xin@gmail.com>
 <1128490426bfb52572ba338e7a631658da49f34c.1602150362.git.lucien.xin@gmail.com>
 <ad362276ba90a8af3178f19aba15a7e67107652f.1602150362.git.lucien.xin@gmail.com>
 <1d1b2e92f958add640d5be1e6eaec1ac5e4581ce.1602150362.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This one basically does the similar things in sctp_v6_xmit as does for
udp4 sock in the last patch, just note that:

  1. label needs to be calculated, as it's the param of
     udp_tunnel6_xmit_skb().

  2. The 'nocheck' param of udp_tunnel6_xmit_skb() is false, as
     required by RFC.

v1->v2:
  - Use sp->udp_port instead in sctp_v6_xmit(), which is more safe.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/ipv6.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index a064bf2..814754d 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -55,6 +55,7 @@
 #include <net/inet_common.h>
 #include <net/inet_ecn.h>
 #include <net/sctp/sctp.h>
+#include <net/udp_tunnel.h>
 
 #include <linux/uaccess.h>
 
@@ -191,33 +192,53 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	return ret;
 }
 
-static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *transport)
+static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *t)
 {
+	struct dst_entry *dst = dst_clone(t->dst);
+	struct flowi6 *fl6 = &t->fl.u.ip6;
 	struct sock *sk = skb->sk;
 	struct ipv6_pinfo *np = inet6_sk(sk);
-	struct flowi6 *fl6 = &transport->fl.u.ip6;
 	__u8 tclass = np->tclass;
-	int res;
+	__be32 label;
 
 	pr_debug("%s: skb:%p, len:%d, src:%pI6 dst:%pI6\n", __func__, skb,
 		 skb->len, &fl6->saddr, &fl6->daddr);
 
-	if (transport->dscp & SCTP_DSCP_SET_MASK)
-		tclass = transport->dscp & SCTP_DSCP_VAL_MASK;
+	if (t->dscp & SCTP_DSCP_SET_MASK)
+		tclass = t->dscp & SCTP_DSCP_VAL_MASK;
 
 	if (INET_ECN_is_capable(tclass))
 		IP6_ECN_flow_xmit(sk, fl6->flowlabel);
 
-	if (!(transport->param_flags & SPP_PMTUD_ENABLE))
+	if (!(t->param_flags & SPP_PMTUD_ENABLE))
 		skb->ignore_df = 1;
 
 	SCTP_INC_STATS(sock_net(sk), SCTP_MIB_OUTSCTPPACKS);
 
-	rcu_read_lock();
-	res = ip6_xmit(sk, skb, fl6, sk->sk_mark, rcu_dereference(np->opt),
-		       tclass, sk->sk_priority);
-	rcu_read_unlock();
-	return res;
+	if (!t->encap_port || !sctp_sk(sk)->udp_port) {
+		int res;
+
+		skb_dst_set(skb, dst);
+		rcu_read_lock();
+		res = ip6_xmit(sk, skb, fl6, sk->sk_mark,
+			       rcu_dereference(np->opt),
+			       tclass, sk->sk_priority);
+		rcu_read_unlock();
+		return res;
+	}
+
+	if (skb_is_gso(skb))
+		skb_shinfo(skb)->gso_type |= SKB_GSO_UDP_TUNNEL_CSUM;
+
+	skb->encapsulation = 1;
+	skb_reset_inner_mac_header(skb);
+	skb_reset_inner_transport_header(skb);
+	skb_set_inner_ipproto(skb, IPPROTO_SCTP);
+	label = ip6_make_flowlabel(sock_net(sk), skb, fl6->flowlabel, true, fl6);
+
+	return udp_tunnel6_xmit_skb(dst, sk, skb, NULL, &fl6->saddr,
+				    &fl6->daddr, tclass, ip6_dst_hoplimit(dst),
+				    label, sctp_sk(sk)->udp_port, t->encap_port, false);
 }
 
 /* Returns the dst cache entry for the given source and destination ip
-- 
2.1.0

