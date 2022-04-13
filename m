Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D642E4FF270
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbiDMIqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbiDMIqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:46:22 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38C050451;
        Wed, 13 Apr 2022 01:44:01 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id bo5so1400883pfb.4;
        Wed, 13 Apr 2022 01:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4o5EcjhV1ntEcnMfw6o2JdoUkLMHz1SETARxygG+inQ=;
        b=KVz8cgc3YDNrRA0ZTjAV9MopFjQyAe4MAoEAX0TfcoQLlX8UgjSxubDBxK/gk2hCGm
         TCq+lqj1a1rKFgqgv6MHJMq/pOJm/1bC5ur14LZyoocPqImthkavYdbCkOT5lhPnZ+V+
         E8SfYfMGhnN311ep8JcC+OliD7Wkmp0kWDUn4MqCN+tDWgRGibArCFo9GbR8vk2hLxKA
         3U7PIEAmv8uYHMsvaYX3jUHKc8gajGmm5ZKfOvXa4hGMSySE7WzjohAWap2+kg1doq9y
         nGQso623acNpcPOCcNIxyvhCf/7eg5Xp7LZuDmz2oHIXzLcNvYgLOpqPaRU7VzQ9EhL3
         /c9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4o5EcjhV1ntEcnMfw6o2JdoUkLMHz1SETARxygG+inQ=;
        b=ylC5z+jJ21o3ixpywQnePavftxxG22aWtk/ZUTp77tYBZdTcK7JetQ2WaTe7ATAqjM
         3tHXvDndJtwCumI1C0k1MSmFUOvpaI1YhKV8GfHmJGnTqzlK3frZ4gQ2bQOWS5ujo35T
         LIiDlsZ+XfOcJCLqQMmjDRe/1qpGSXj37TvEzCQyqtnuEV/XEw2vmiAlufJZHi3u8TX8
         hMG8FAYoFJUCkq8tJgXZpWAMYcRRRY5mvputV+9q9FyEZMt7RnJ5rPycPiwFIjl8dENQ
         7WGEy0uLfRgbHgPJMozF+h9cr1nuG7shQKEQAbtrcmKAyXGTLku+4mwUh1Iq8z/vBtfP
         RpRw==
X-Gm-Message-State: AOAM530djTYOmAZgJ2vpzUpFGehEDQDgKL17Tci2nqXRurn40Ac4G1fn
        y1IUHd1u9B2aPpQy0aKqDNo=
X-Google-Smtp-Source: ABdhPJzWt1ssM6+YxN1n7evbSBKW+yeV//8jQPxQfwQ8OSWECmKMvfdeb/sQYW5feDXYKgGtiTljnA==
X-Received: by 2002:a62:3341:0:b0:505:a1d2:fbe6 with SMTP id z62-20020a623341000000b00505a1d2fbe6mr19849327pfz.9.1649839441521;
        Wed, 13 Apr 2022 01:44:01 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.119])
        by smtp.gmail.com with ESMTPSA id l5-20020a63f305000000b0039daaa10a1fsm2410335pgh.65.2022.04.13.01.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 01:44:01 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com,
        benbjiang@tencent.com, flyingpeng@tencent.com,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        mengensun@tencent.com, dongli.zhang@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 3/9] net: ipv6: add skb drop reasons to ip6_pkt_drop()
Date:   Wed, 13 Apr 2022 16:15:54 +0800
Message-Id: <20220413081600.187339-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413081600.187339-1-imagedong@tencent.com>
References: <20220413081600.187339-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() used in ip6_pkt_drop() with kfree_skb_reason().
No new reason is added.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
---
 net/ipv6/route.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 169e9df6d172..9471ab4421c8 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4482,6 +4482,7 @@ static int ip6_pkt_drop(struct sk_buff *skb, u8 code, int ipstats_mib_noroutes)
 	struct dst_entry *dst = skb_dst(skb);
 	struct net *net = dev_net(dst->dev);
 	struct inet6_dev *idev;
+	SKB_DR(reason);
 	int type;
 
 	if (netif_is_l3_master(skb->dev) ||
@@ -4494,11 +4495,14 @@ static int ip6_pkt_drop(struct sk_buff *skb, u8 code, int ipstats_mib_noroutes)
 	case IPSTATS_MIB_INNOROUTES:
 		type = ipv6_addr_type(&ipv6_hdr(skb)->daddr);
 		if (type == IPV6_ADDR_ANY) {
+			SKB_DR_SET(reason, IP_INADDRERRORS);
 			IP6_INC_STATS(net, idev, IPSTATS_MIB_INADDRERRORS);
 			break;
 		}
+		SKB_DR_SET(reason, IP_INNOROUTES);
 		fallthrough;
 	case IPSTATS_MIB_OUTNOROUTES:
+		SKB_DR_OR(reason, IP_OUTNOROUTES);
 		IP6_INC_STATS(net, idev, ipstats_mib_noroutes);
 		break;
 	}
@@ -4508,7 +4512,7 @@ static int ip6_pkt_drop(struct sk_buff *skb, u8 code, int ipstats_mib_noroutes)
 		skb_dst_drop(skb);
 
 	icmpv6_send(skb, ICMPV6_DEST_UNREACH, code, 0);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return 0;
 }
 
-- 
2.35.1

