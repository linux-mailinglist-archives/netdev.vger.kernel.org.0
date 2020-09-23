Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBCB52750C5
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 08:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgIWGGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 02:06:35 -0400
Received: from mail-m973.mail.163.com ([123.126.97.3]:53688 "EHLO
        mail-m973.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbgIWGGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 02:06:21 -0400
X-Greylist: delayed 916 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2020 02:06:19 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=ldeUR
        Yewu2fM70h0EcU97t98Qm0u/6Ht4u3dUu5od6Y=; b=MLF42AACz3rkP1GNgHZK/
        srL2AkQcuHuQxZjKikGuEcoZjhrqQhtHdAxLmncCzw8tMv5QeDLh6njaM67t5S33
        XlAgSIraM/OdUnHgWYWIuXJ8U1bv3Foj6OKs/EvVwHfERJNT08p14bpOZo7xGQ3r
        l0wJ/C1vQtH5wRyDKQpW0I=
Received: from localhost.localdomain (unknown [111.202.93.98])
        by smtp3 (Coremail) with SMTP id G9xpCgC37aAO4mpfz4khDw--.2743S2;
        Wed, 23 Sep 2020 13:50:06 +0800 (CST)
From:   "longguang.yue" <bigclouds@163.com>
Cc:     ylg <bigclouds@163.com>, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipvs: adjust the debug order of src and dst
Date:   Wed, 23 Sep 2020 13:49:59 +0800
Message-Id: <20200923055000.82748-1-bigclouds@163.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: G9xpCgC37aAO4mpfz4khDw--.2743S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrurWUGFWUXr1kZF47Zr1fWFg_yoWftwcEya
        92vF95WF1UX3WUAa1UGr48X34xGrW7Ja1FvryvqFyjv345C3y0y3yv9rnavr43Wan0gF1r
        tr92gry2k3ZrKjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUZjjPUUUUU==
X-Originating-IP: [111.202.93.98]
X-CM-SenderInfo: peljuzprxg2qqrwthudrp/xtbBZA6oQ1QHKz5e-QAAsk
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: ylg <bigclouds@163.com>

adjust the debug order of src and dst when tcp state changes

Signed-off-by: ylg <bigclouds@163.com>
---
 net/netfilter/ipvs/ip_vs_proto_tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index dc2e7da2742a..6567eb45a234 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -548,10 +548,10 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 			      th->fin ? 'F' : '.',
 			      th->ack ? 'A' : '.',
 			      th->rst ? 'R' : '.',
-			      IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
-			      ntohs(cp->dport),
 			      IP_VS_DBG_ADDR(cp->af, &cp->caddr),
 			      ntohs(cp->cport),
+			      IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
+			      ntohs(cp->dport),
 			      tcp_state_name(cp->state),
 			      tcp_state_name(new_state),
 			      refcount_read(&cp->refcnt));
-- 
2.20.1 (Apple Git-117)

