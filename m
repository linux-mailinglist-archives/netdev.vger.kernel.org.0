Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B486AF7AF
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbjCGVbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjCGVbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:31:38 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27162193FA;
        Tue,  7 Mar 2023 13:31:37 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id z6so16144846qtv.0;
        Tue, 07 Mar 2023 13:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678224696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ogYvOem5ByGIupaTnmQOmli663SH44C06UoSXA/Fe2g=;
        b=TThzENbMIZ27EdGdcalTZwwHWizlepPmyTF4TAn40HDqIjeeVnu4yqWPVTdEHAFt+M
         UybjdykILgtpLjRbPdpzOiwGetUC/DjbEKHMy2zxzFFq8BY2iOAHi+o5k1hVdglF0AoR
         xlsviVz9LU8NnJLn4N3rKQyiKplwI4b1bYPYKRB+dnRfWte/6AePJIebdHh60stuboWU
         AHAo4ZKSm3Yl6n8v4miRoDQze0mHiby9luXiHTCZ8t5IdGooHjxD89x17MzCKT84KaDm
         zVcvTA5hCiUB3+Ryh/xNNq46/l7P1AGI3u4tzyjdxpAuITrkAHt8WU2kq7H1gK6HLXZI
         98Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678224696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ogYvOem5ByGIupaTnmQOmli663SH44C06UoSXA/Fe2g=;
        b=Dy6dSpmgdNxSNORRyBfyOa3CrsLuUqCA0XRUpsFdRU8k+CXaXacN+4MvN5+pB3sRqn
         GxsBgKQXnAxhPqYNyBFFOA1XInDW3alvcQ0XrdQjjNzp70jhATcOfM2Iq28NqShy7BAs
         GVFeeYhddbtIW53a+/bbF9mpgFcP7kBftj3jJnF0yO1+Ulv4HPgytSC+oB9Vg86YCO8C
         fV6bwyj57jIX7h+MpAg5Ym4WWgknN/zsSOt/WUFvPpVH3haTZ4kbmRzOOwej67u8JJ32
         T0LMPy/KPka0jRy6nod4/hPtOHJfFBl5bpSHtuiFTG9Ahej93B8XOYuMrEob1prOUS+i
         nUAA==
X-Gm-Message-State: AO0yUKX5lXzyqC2fqxwQlfBbDt9Mw/JloBZwIHSvl1vH3HU+2X0HDTc2
        PH0Evj5nzkpsTHrDZ9bHqwapyBXD/01cQg==
X-Google-Smtp-Source: AK7set9NRPVu6LmVeT1Yejqwo7vNEr7UkxdQhN16sHKrzd9OtIoziBfXsk5EqfrmGbjFVEVsj5XK3w==
X-Received: by 2002:ac8:5c90:0:b0:3b6:9c63:5ca1 with SMTP id r16-20020ac85c90000000b003b69c635ca1mr27495526qta.43.1678224696074;
        Tue, 07 Mar 2023 13:31:36 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id r125-20020a374483000000b006fcb77f3bd6sm10269329qka.98.2023.03.07.13.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 13:31:35 -0800 (PST)
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
        Aaron Conole <aconole@redhat.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCHv2 nf-next 2/6] netfilter: bridge: check len before accessing more nh data
Date:   Tue,  7 Mar 2023 16:31:28 -0500
Message-Id: <886b94408ada2f8c92eeb679425a0c7cb9422901.1678224658.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1678224658.git.lucien.xin@gmail.com>
References: <cover.1678224658.git.lucien.xin@gmail.com>
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
---
 net/bridge/br_netfilter_ipv6.c | 45 +++++++++++++++-------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index afd1c718b683..8be3c5c8b925 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -50,54 +50,49 @@ static int br_nf_check_hbh_len(struct sk_buff *skb)
 	u32 pkt_len;
 
 	if (!pskb_may_pull(skb, off + 8))
-		goto bad;
+		return -1;
 	nh = (unsigned char *)(ipv6_hdr(skb) + 1);
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
+
+	return len ? -1 : 0;
 }
 
 int br_validate_ipv6(struct net *net, struct sk_buff *skb)
-- 
2.39.1

