Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8FE6AF7B4
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbjCGVbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbjCGVbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:31:39 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2804BA400D;
        Tue,  7 Mar 2023 13:31:38 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id h19so16050072qtk.7;
        Tue, 07 Mar 2023 13:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678224697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/iHtE2tw64SM6OF7PMkqYu16FzPep7pukGcXdQ+vlQ4=;
        b=KtwmLGXzb4ksSL0ZHuf8FeQ6ycwIGCrfw8EOKtcMTs0wzqvXNZ2glFpatY1q8mvpir
         v/aeuzX4OLkBoQGtnBIVJN22O94RRC00CRghFx2P82pVZAX1tnePLHr6h6+3INiMJnUo
         x+gdno2QMEOA0TxuQiNSX8pciGN2cycKA7aw8wYJ3r9XjQ+znGarQN1vaFS/X9utN1aE
         F4Q6mASjcsBHwoUPgqTgR7N0FerTFfKCdnaSWmTXnIVQ0lBaynmJrJjI/w6wgY9IhDcd
         3wfmrXceBDkxZ6EmTcW/Vf3AXUuI9If1Hx2mJMO9QXeug8+mphqhD7oFQFFB5vrR/ZsZ
         3mdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678224697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/iHtE2tw64SM6OF7PMkqYu16FzPep7pukGcXdQ+vlQ4=;
        b=MtBLB+dFsYPhopAqBxHkeK2472NYCbnQLkmAmGprItMPD7qVwt1X8ojId2x7Ktku22
         y3Vau5WMvgxJADJWcGSItoGVjnNBPLkTA9FmWbc+J4CqBjiD1eIP2v/WS81uT6VjGaU3
         Uu1L/CeKSmhQ3gPA2ck2k2zudhidRM1GLElDwKjuCDC025WtvryPckZlfIwc520zqXn5
         MbVejpsAwBC1wTwHp/1N60dgBahv5DdsyXUAUckIvJEoLA2BSPTnOcf5sIOE6y+L6T4L
         u9Vmis5akqxP9XzOPewFY7FTiui5XKnD4I0FTq7fIottT2bxdeTzgIKS0/jTruVbrDx/
         WwLw==
X-Gm-Message-State: AO0yUKXI5qoHWaJYzgu8KOdd7HsMpD1iW+3sHyNsFbC6Nobfi0SMLe2k
        yz4H5P++12WVdWvzPodbvp8u5xRRAWby7Q==
X-Google-Smtp-Source: AK7set85ZQtLJfKnloGg64oxBR/hZModB46KXwQIcaUFx0mwR7LR+1j+yLNu6jD7eOgJh2Y0THZwoQ==
X-Received: by 2002:a05:622a:58e:b0:3b9:bf7f:66ff with SMTP id c14-20020a05622a058e00b003b9bf7f66ffmr25701044qtb.67.1678224697070;
        Tue, 07 Mar 2023 13:31:37 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id r125-20020a374483000000b006fcb77f3bd6sm10269329qka.98.2023.03.07.13.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 13:31:36 -0800 (PST)
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
Subject: [PATCHv2 nf-next 3/6] netfilter: bridge: move pskb_trim_rcsum out of br_nf_check_hbh_len
Date:   Tue,  7 Mar 2023 16:31:29 -0500
Message-Id: <8b829c2e59f486705fcaf0b5981f7d830638bba0.1678224658.git.lucien.xin@gmail.com>
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

br_nf_check_hbh_len() is a function to check the Hop-by-hop option
header, and shouldn't do pskb_trim_rcsum() there. This patch is to
pass pkt_len out to br_validate_ipv6() and do pskb_trim_rcsum()
after calling br_validate_ipv6() instead.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
---
 net/bridge/br_netfilter_ipv6.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index 8be3c5c8b925..a0d6dfb3e255 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -43,11 +43,10 @@
 /* We only check the length. A bridge shouldn't do any hop-by-hop stuff
  * anyway
  */
-static int br_nf_check_hbh_len(struct sk_buff *skb)
+static int br_nf_check_hbh_len(struct sk_buff *skb, u32 *plen)
 {
 	int len, off = sizeof(struct ipv6hdr);
 	unsigned char *nh;
-	u32 pkt_len;
 
 	if (!pskb_may_pull(skb, off + 8))
 		return -1;
@@ -75,6 +74,8 @@ static int br_nf_check_hbh_len(struct sk_buff *skb)
 			return -1;
 
 		if (nh[off] == IPV6_TLV_JUMBO) {
+			u32 pkt_len;
+
 			if (nh[off + 1] != 4 || (off & 3) != 2)
 				return -1;
 			pkt_len = ntohl(*(__be32 *)(nh + off + 2));
@@ -83,10 +84,7 @@ static int br_nf_check_hbh_len(struct sk_buff *skb)
 				return -1;
 			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
 				return -1;
-			if (pskb_trim_rcsum(skb,
-					    pkt_len + sizeof(struct ipv6hdr)))
-				return -1;
-			nh = skb_network_header(skb);
+			*plen = pkt_len;
 		}
 		off += optlen;
 		len -= optlen;
@@ -114,22 +112,19 @@ int br_validate_ipv6(struct net *net, struct sk_buff *skb)
 		goto inhdr_error;
 
 	pkt_len = ntohs(hdr->payload_len);
+	if (hdr->nexthdr == NEXTHDR_HOP && br_nf_check_hbh_len(skb, &pkt_len))
+		goto drop;
 
-	if (pkt_len || hdr->nexthdr != NEXTHDR_HOP) {
-		if (pkt_len + ip6h_len > skb->len) {
-			__IP6_INC_STATS(net, idev,
-					IPSTATS_MIB_INTRUNCATEDPKTS);
-			goto drop;
-		}
-		if (pskb_trim_rcsum(skb, pkt_len + ip6h_len)) {
-			__IP6_INC_STATS(net, idev,
-					IPSTATS_MIB_INDISCARDS);
-			goto drop;
-		}
-		hdr = ipv6_hdr(skb);
+	if (pkt_len + ip6h_len > skb->len) {
+		__IP6_INC_STATS(net, idev,
+				IPSTATS_MIB_INTRUNCATEDPKTS);
+		goto drop;
 	}
-	if (hdr->nexthdr == NEXTHDR_HOP && br_nf_check_hbh_len(skb))
+	if (pskb_trim_rcsum(skb, pkt_len + ip6h_len)) {
+		__IP6_INC_STATS(net, idev,
+				IPSTATS_MIB_INDISCARDS);
 		goto drop;
+	}
 
 	memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
 	/* No IP options in IPv6 header; however it should be
-- 
2.39.1

