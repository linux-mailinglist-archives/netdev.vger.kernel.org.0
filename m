Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978EA6AA622
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 01:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjCDAMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 19:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjCDAMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 19:12:48 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9105C1F4A2;
        Fri,  3 Mar 2023 16:12:47 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id o3so2934937qvr.1;
        Fri, 03 Mar 2023 16:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677888766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iu9clajkpxoMBkwULICMZCHvn1ew485ofbrS/sXvEbM=;
        b=LPCQzyf5sjmMz8m9ro+wRBl5g7QULngvpFJfFKL8C2pqwYtADGNEYVveijPdDJF9RA
         UrPrnh2BbHsgsZNKOBr/r2rV8QQfBPnPXLQks+UprFI1vvuBZchykfiJ5FLthZCdbhCg
         YiNQwXhCG4a5BIJciJ21/+djPldvf8knJWjc4KeJmtwGC02ce7rLrohYfaQsxoBXdIXo
         dhSd8u0wV4UlNV7JoDToYnjMfcelDAXk9WYofft4dzJnQzrkf9+Lv6L8fmvEwZd8/Geu
         jC722TlZEX6laevDPpm+3DeDe/F5yxa6ol9wnMqkMBi30PQNsdgmejqOieGX1gpYS05W
         yAWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677888766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iu9clajkpxoMBkwULICMZCHvn1ew485ofbrS/sXvEbM=;
        b=H8JbJWV+w3dsMIxqyx/HgXnEqilhSyh3LXV9Kc6tq0OAHKKy3FpGj7sS/hmwyaGQ32
         q9/lux/QP+44CCIXashno+7AQY5T0BgyHLOJOMTNUt5hku7ANuYKR6NJ8fS8NPjUI4kT
         ekT6BAH+T15biGwLo8i5rWgMTwns3OG9gILWvzKLYXYovB7GiqQB3+xxoMJXGp4T2CVh
         XjXHJf7Ikb+EaOFJkAvqkP04jyxfP7cxZNf3v6+4j67gHbnp8q3Hx8e6p1IbFpMiXc6t
         9VWyBi6DMcd2LCW4rmuDEPO3Kb2DQj24rBBMCuzUtPFgjEjkn2GdKlLL8t2t0lrXIf79
         B8bA==
X-Gm-Message-State: AO0yUKUqaGOfURfmnRy7VOoV4qT2TzxleyQqNoj0teHL8OiP/C/smP5H
        uGHqICH5gI5rAuk2j0T8aY2tF8+ho//wcA==
X-Google-Smtp-Source: AK7set8w8MAveRC4LAY9ALJREi0Q2Ou3jLtaHPbUkmhWE5uBJjuKFfTnAjljzEyZK+BQMkFA6DFX8A==
X-Received: by 2002:a05:6214:5299:b0:56e:f05c:9c70 with SMTP id kj25-20020a056214529900b0056ef05c9c70mr5815683qvb.44.1677888766484;
        Fri, 03 Mar 2023 16:12:46 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d79-20020ae9ef52000000b007296805f607sm2749242qkg.17.2023.03.03.16.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:12:46 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCH nf-next 2/6] netfilter: bridge: check len before accessing more nh data
Date:   Fri,  3 Mar 2023 19:12:38 -0500
Message-Id: <e5ea0147b3314ad9db5140c7b307472efbd114bd.1677888566.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677888566.git.lucien.xin@gmail.com>
References: <cover.1677888566.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the while loop of br_nf_check_hbh_len(), similar to ip6_parse_tlv(),
before accessing 'nh[off + 1]', it should add a check 'len < 2'; and
before parsing IPV6_TLV_JUMBO, it should add a check 'optlen > len',
in case of overflows.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/bridge/br_netfilter_ipv6.c | 47 ++++++++++++++++------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index 5cd3e4c35123..50f564c33551 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -50,54 +50,51 @@ static int br_nf_check_hbh_len(struct sk_buff *skb)
 	u32 pkt_len;
 
 	if (!pskb_may_pull(skb, off + 8))
-		goto bad;
+		return -1;
 	nh = (u8 *)(ipv6_hdr(skb) + 1);
 	len = (nh[1] + 1) << 3;
 
 	if (!pskb_may_pull(skb, off + len))
-		goto bad;
+		return -1;
 	nh = skb_network_header(skb);
 
 	off += 2;
 	len -= 2;
-
 	while (len > 0) {
-		int optlen = nh[off + 1] + 2;
-
-		switch (nh[off]) {
-		case IPV6_TLV_PAD1:
-			optlen = 1;
-			break;
+		int optlen;
 
-		case IPV6_TLV_PADN:
-			break;
+		if (nh[off] == IPV6_TLV_PAD1) {
+			off++;
+			len--;
+			continue;
+		}
+		if (len < 2)
+			return -1;
+		optlen = nh[off + 1] + 2;
+		if (optlen > len)
+			return -1;
 
-		case IPV6_TLV_JUMBO:
+		if (nh[off] == IPV6_TLV_JUMBO) {
 			if (nh[off + 1] != 4 || (off & 3) != 2)
-				goto bad;
+				return -1;
 			pkt_len = ntohl(*(__be32 *)(nh + off + 2));
 			if (pkt_len <= IPV6_MAXPLEN ||
 			    ipv6_hdr(skb)->payload_len)
-				goto bad;
+				return -1;
 			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
-				goto bad;
+				return -1;
 			if (pskb_trim_rcsum(skb,
 					    pkt_len + sizeof(struct ipv6hdr)))
-				goto bad;
+				return -1;
 			nh = skb_network_header(skb);
-			break;
-		default:
-			if (optlen > len)
-				goto bad;
-			break;
 		}
 		off += optlen;
 		len -= optlen;
 	}
-	if (len == 0)
-		return 0;
-bad:
-	return -1;
+	if (len)
+		return -1;
+
+	return 0;
 }
 
 int br_validate_ipv6(struct net *net, struct sk_buff *skb)
-- 
2.39.1

