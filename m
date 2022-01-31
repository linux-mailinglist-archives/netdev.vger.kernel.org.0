Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8841D4A4DDA
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244357AbiAaSPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237774AbiAaSPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 13:15:14 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6048CC061714;
        Mon, 31 Jan 2022 10:15:14 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id f8so12965935pgf.8;
        Mon, 31 Jan 2022 10:15:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EYqIJEyyNz7ujllAdswrFOBF9LLHgV1FGx3WtXiHrHQ=;
        b=Kc5RCjufDrTav5PatyCfqH7PgOTjWS/V5RUQ88x5YhSOBy4moEY+GueyzGjhzx4GZj
         ftAWXmIphIbMK9frljtnbLUPfO8ouUfefnOabUN2MSOVFML5gmQI+juTf2l+xEc2AtVx
         7fWL246FoqQS4BaRTM4n5UA9v9wMeE6qOC4qs038uoXbzLPzkvqsA0tOm+6K19kfCxL8
         LLytE3dYGqh84+hb4OQ3cXeTgB2BFzAzf9v2CxnRijGN4sQWoGdPz+UWOb9u58w4GPqS
         OTof75YFh0FcSNYlpxnxBY7IMxvGxdB/b431VfWpfwhKQP0Vh2KAo8ouQl5+fgoH58vT
         8XAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EYqIJEyyNz7ujllAdswrFOBF9LLHgV1FGx3WtXiHrHQ=;
        b=WMWKeYGtj0eWGC8M52i82MbVfrrmA9neLjKPZUTX2EPykPahL12sTH63EHPr0AH3kH
         hgOYWB6svNmu9TO7kdj37PzlH+WEpLfi0PNW2iym0lKHN2nL2y1Y9TJe2XPfkDZHkvpl
         5PJLQ7azEcu2ZNad6ddYpUzBrnROAPQnPjPfP1MSTPjTexFiKbqqVj/gvRtHxosnqD2R
         wEzB/dPLq41iOp+cBGTIzHxhXtIXRzr0FaQniWGZKpiEE1MlsXxsKWN+EyPjDHBRrvDH
         OJhNfgozivMonxLToUmoF+wHB6PbpfZXsWO4qnM2LrcAGFbDi0evKk91R0fFrfsmFl1z
         FsoQ==
X-Gm-Message-State: AOAM533fhLi2p+CUxMKfNbW9m8t99Z0kSk/gVvz32Z552CukfxkhWzGJ
        Ne6+lfCo3VWKZNsRsTjcvzI=
X-Google-Smtp-Source: ABdhPJwxpDb9R9dDaCIYuXhbqIk9bI1RdMp8l6svviau6i4yQd+D3BHqLdnbwMEYU5OfeBDMhkFl4Q==
X-Received: by 2002:a63:2bc9:: with SMTP id r192mr7494518pgr.298.1643652913890;
        Mon, 31 Jan 2022 10:15:13 -0800 (PST)
Received: from jeffreyji1.c.googlers.com.com (173.84.105.34.bc.googleusercontent.com. [34.105.84.173])
        by smtp.gmail.com with ESMTPSA id w11sm19244282pfu.50.2022.01.31.10.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 10:15:13 -0800 (PST)
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
X-Google-Original-From: Jeffrey Ji <jeffreyji@google.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Brian Vazquez <brianvv@google.com>, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jeffreyji <jeffreyji@google.com>
Subject: [PATCH v5 net-next] net-core: add InMacErrors counter
Date:   Mon, 31 Jan 2022 18:15:07 +0000
Message-Id: <20220131181507.3470388-1-jeffreyji@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jeffreyji <jeffreyji@google.com>

Increment InMacErrors counter when packet dropped due to incorrect dest
MAC addr.

An example when this drop can occur is when manually crafting raw
packets that will be consumed by a user space application via a tap
device. For testing purposes local traffic was generated using trafgen
for the client and netcat to start a server

example output from nstat:
\~# nstat -a | grep InMac
Ip6InMacErrors                  0                  0.0
IpExtInMacErrors                1                  0.0

Tested: Created 2 netns, sent 1 packet using trafgen from 1 to the other
with "{eth(daddr=$INCORRECT_MAC...}", verified that nstat showed the
counter was incremented.

changelog:

v5:
Change from SKB_DROP_REASON_BAD_DEST_MAC to SKB_DROP_REASON_OTHERHOST

v3-4:
Remove Change-Id

v2:
Use skb_free_reason() for tracing
Add real-life example in patch msg

Signed-off-by: jeffreyji <jeffreyji@google.com>
---
 include/linux/skbuff.h    |  1 +
 include/uapi/linux/snmp.h |  1 +
 net/ipv4/ip_input.c       |  7 +++++--
 net/ipv4/proc.c           |  1 +
 net/ipv6/ip6_input.c      | 12 +++++++-----
 net/ipv6/proc.c           |  1 +
 6 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index bf11e1fbd69b..c831e3a502f2 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -320,6 +320,7 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_CSUM,
 	SKB_DROP_REASON_TCP_FILTER,
 	SKB_DROP_REASON_UDP_CSUM,
+	SKB_DROP_REASON_OTHERHOST,
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 904909d020e2..ac2fac12dd7d 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -57,6 +57,7 @@ enum
 	IPSTATS_MIB_ECT0PKTS,			/* InECT0Pkts */
 	IPSTATS_MIB_CEPKTS,			/* InCEPkts */
 	IPSTATS_MIB_REASM_OVERLAPS,		/* ReasmOverlaps */
+	IPSTATS_MIB_INMACERRORS,		/* InMacErrors */
 	__IPSTATS_MIB_MAX
 };
 
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 3a025c011971..780892526166 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -441,8 +441,11 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	/* When the interface is in promisc. mode, drop all the crap
 	 * that it receives, do not try to analyse it.
 	 */
-	if (skb->pkt_type == PACKET_OTHERHOST)
-		goto drop;
+	if (skb->pkt_type == PACKET_OTHERHOST) {
+		__IP_INC_STATS(net, IPSTATS_MIB_INMACERRORS);
+		kfree_skb_reason(skb, SKB_DROP_REASON_OTHERHOST);
+		return NULL;
+	}
 
 	__IP_UPD_PO_STATS(net, IPSTATS_MIB_IN, skb->len);
 
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index f30273afb539..dfe0a1dbf8e9 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -117,6 +117,7 @@ static const struct snmp_mib snmp4_ipextstats_list[] = {
 	SNMP_MIB_ITEM("InECT0Pkts", IPSTATS_MIB_ECT0PKTS),
 	SNMP_MIB_ITEM("InCEPkts", IPSTATS_MIB_CEPKTS),
 	SNMP_MIB_ITEM("ReasmOverlaps", IPSTATS_MIB_REASM_OVERLAPS),
+	SNMP_MIB_ITEM("InMacErrors", IPSTATS_MIB_INMACERRORS),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 80256717868e..da18d9159647 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -149,15 +149,17 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 	u32 pkt_len;
 	struct inet6_dev *idev;
 
-	if (skb->pkt_type == PACKET_OTHERHOST) {
-		kfree_skb(skb);
-		return NULL;
-	}
-
 	rcu_read_lock();
 
 	idev = __in6_dev_get(skb->dev);
 
+	if (skb->pkt_type == PACKET_OTHERHOST) {
+		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INMACERRORS);
+		rcu_read_unlock();
+		kfree_skb_reason(skb, SKB_DROP_REASON_OTHERHOST);
+		return NULL;
+	}
+
 	__IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_IN, skb->len);
 
 	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL ||
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index d6306aa46bb1..76e6119ba558 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -84,6 +84,7 @@ static const struct snmp_mib snmp6_ipstats_list[] = {
 	SNMP_MIB_ITEM("Ip6InECT1Pkts", IPSTATS_MIB_ECT1PKTS),
 	SNMP_MIB_ITEM("Ip6InECT0Pkts", IPSTATS_MIB_ECT0PKTS),
 	SNMP_MIB_ITEM("Ip6InCEPkts", IPSTATS_MIB_CEPKTS),
+	SNMP_MIB_ITEM("Ip6InMacErrors", IPSTATS_MIB_INMACERRORS),
 	SNMP_MIB_SENTINEL
 };
 
-- 
2.35.0.rc2.247.g8bbb082509-goog

