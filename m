Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389F529E561
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgJ2HYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgJ2HYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:35 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDC9C08EA77;
        Thu, 29 Oct 2020 00:07:00 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id t6so844824plq.11;
        Thu, 29 Oct 2020 00:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=zpcgNpTt1Eopd9QaDKGy8sWqns6Rwfi4+2UKE6Sn+wQ=;
        b=Q7+giLlNKoF160T/yzSVjfsWohl/xR3ljN0+h3zMKnLx7RFxPmbEf/Js5stKpNEazL
         I1rLmTugUiaq/DgxVX0aXjnE5IYw7RidPAtLjt7yp7AyhlxJLQxiv3etIssygiMCrb9w
         j+voa5udkhf0MWawBxZ9VB0PRj9GN30UZiP7yjj0QVeizRCWmTT1rI/PBL6LIETsnSAg
         6AuqN7XKA+9LIRbaTrC+RgLNZwVc2Z0oUVME0k1DsOAAgNo8sQ/SK0clICqnk6inj9XZ
         C+6vCOb+KwM4QRG3wN7igRZLfTtJvPEuSRtkNI0ih+e4ZrfKS0P56W23FoToJlSxtoXx
         JMQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=zpcgNpTt1Eopd9QaDKGy8sWqns6Rwfi4+2UKE6Sn+wQ=;
        b=mtvqZXWYCWa5DLPpwDdW6RfjI87+hiypZXr+tMSGP2At/N+L43oySkRugd2qhL1I80
         NIf5D1UB2/3kAk0R6a0sy41Tz7wh3W2PNlB4Ms1kcVwLJEBC3n4QrHuLj519aC0X59W9
         SBz+SzxsuX0nirJYYeHb6vaclr8XRjKe0GlOo0J50St//78xrE2+5ZvXkdY7jgF8w0kW
         FJkEVggAalqjr2ahQHLG+mZTBQSRBU39HF1cMcEnxdHtZzPmC0IJ9JeEWOfDcfRCnent
         yiIJvKyPs8WYjFxCuF8Ip+zHmqJcPK6tW6EZ3d+7tJGl+78BiduP4oVi0kBT9ZDL7gM8
         178g==
X-Gm-Message-State: AOAM530C6zbTChAiEhGQW8jDLzTjAbp6IY9WU4bMk8gt5iHqgING/eMh
        FyuB9KTpO8fIb6Dw9MFPtu8lxHj5/hg=
X-Google-Smtp-Source: ABdhPJxXMihVeP+9OnWl7WNFYm2QTskUkiIS7VzmJiRSC+9NTeJcIHKuxK9METWpJ8+3EbbYiPeTig==
X-Received: by 2002:a17:902:ee53:b029:d6:ff1:d569 with SMTP id 19-20020a170902ee53b02900d60ff1d569mr2711512plo.23.1603955220240;
        Thu, 29 Oct 2020 00:07:00 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u4sm1635835pjy.19.2020.10.29.00.06.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Oct 2020 00:06:59 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com
Subject: [PATCHv5 net-next 13/16] sctp: support for sending packet over udp6 sock
Date:   Thu, 29 Oct 2020 15:05:07 +0800
Message-Id: <dcea42706709242930ae2d019355f27e7ca745d3.1603955041.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <88a89930e9ab2d1b2300ca81d7023feaaa818727.1603955041.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
 <48053c3bf48a46899bc0130dc43adca1e6925581.1603955040.git.lucien.xin@gmail.com>
 <4f439ed717442a649ba78dc0efc6f121208a9995.1603955040.git.lucien.xin@gmail.com>
 <e7575f9fea2b867bf0c7c3e8541e8a6101610055.1603955040.git.lucien.xin@gmail.com>
 <1cfd9ca0154d35389b25f68457ea2943a19e7da2.1603955040.git.lucien.xin@gmail.com>
 <3c26801d36575d0e9c9bd260e6c1f1b67e4b721e.1603955040.git.lucien.xin@gmail.com>
 <279d266bc34ebc439114f39da983dc08845ea37a.1603955040.git.lucien.xin@gmail.com>
 <066bbdcf83188bbc62b6c458f2a0fd8f06f41640.1603955040.git.lucien.xin@gmail.com>
 <e72ab91d56df2ced82efb0c9d26d29f47d0747f7.1603955040.git.lucien.xin@gmail.com>
 <2b2703eb6a2cc84b7762ee7484a9a57408db162b.1603955040.git.lucien.xin@gmail.com>
 <1032fd094f807a870ca965e8355daf0be068008d.1603955041.git.lucien.xin@gmail.com>
 <e23bd6fddaea6641348e2115877afec5a4e2cf19.1603955041.git.lucien.xin@gmail.com>
 <88a89930e9ab2d1b2300ca81d7023feaaa818727.1603955041.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
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

