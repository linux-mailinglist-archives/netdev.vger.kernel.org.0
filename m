Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067EC4D85FE
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 14:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241778AbiCNNej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 09:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiCNNeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 09:34:37 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE102253D;
        Mon, 14 Mar 2022 06:33:26 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mm23-20020a17090b359700b001bfceefd8c6so11223537pjb.3;
        Mon, 14 Mar 2022 06:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S2Xi0UNkmhH1SiHzQ0OJsnrkGPKnQIQ41FuqC3G+W84=;
        b=bqm02ungY3sYMsECrb5nTVfb9VQa5eSRGRN/2gddzZY2RU78R4rr1ezDD2DsB9VM/k
         kewpxEE3hID23/6Uz35rPUqu4WoAOBGvP+fE1sn3Gwga2jmeN7xj++MFwSFSSqgH2zbZ
         Wq3uwa4V05T8bn7cIBz2FR4vRMNUzJZVnBRo2d3UZKYE/EcNhvrLsL9bj7ujiE3PBCli
         Tzj6rfzwVmWu2G/fB/C1n3CO3kcXdqmAkMzBvT0xadx2/9P66vxv2bd6dFs0J1zixqg/
         ikOCm+PjYTod0SUmvdDQ+5bA31P9wa6OqNZ6W6ypLgErTa+d9SXvaHsqdXLqXiUkOwsM
         kZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S2Xi0UNkmhH1SiHzQ0OJsnrkGPKnQIQ41FuqC3G+W84=;
        b=pkuekt64XePQgWdIclp64DTwIJI+eDpZYOZkTBKG5sN+P8qRS4At2w9wyssfXYr4ZW
         DYAimDDW8rm6LWE6C+N9Cgt4f6RsvnAKPrXVIVSTm3mwcYG3PJN+JLL3BK4JyPtWFFdv
         IOgGHIaDNyVCO8nImpysRrGAHu9LL1v95ouiAECerTwjJ5YVWk+r3Gh3pUxNHAo5ZvuN
         HoFPhQHJPpGVaDJEQKNaVg0etDhnGQqqRTqscE7/si8JTjrxY3dAk44jOvDDfCJIIuZD
         rS0IuSovXAqdhdn6lKUKKJhnuIVKi9ySCzMTsVCPr9da6BlsUAynuseZI1p+Yr2O22Bq
         NCcg==
X-Gm-Message-State: AOAM530cwp6ICrwIo7zOzBj0NIojoOb4iVnBw71plQ8KV6L8CEOj0kWO
        sZu1+M3O4JipoFnGVQMn1FM=
X-Google-Smtp-Source: ABdhPJzZrZPI0t6T6jAmt+CoDI7He3CyW2wQNvn4nNsHxsuDL1TVapFhZ7JGyglA9xQ5Bn8pN0ZmEA==
X-Received: by 2002:a17:90a:5b0d:b0:1bc:7e66:2970 with SMTP id o13-20020a17090a5b0d00b001bc7e662970mr25177192pji.12.1647264806451;
        Mon, 14 Mar 2022 06:33:26 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id j13-20020a056a00130d00b004f1025a4361sm22118722pfu.202.2022.03.14.06.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 06:33:26 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, xeb@mail.ru,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Biao Jiang <benbjiang@tencent.com>
Subject: [PATCH net-next 1/3] net: gre_demux: add skb drop reasons to gre_rcv()
Date:   Mon, 14 Mar 2022 21:33:10 +0800
Message-Id: <20220314133312.336653-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314133312.336653-1-imagedong@tencent.com>
References: <20220314133312.336653-1-imagedong@tencent.com>
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

Replace kfree_skb() used in gre_rcv() with kfree_skb_reason(). Following
new drop reasons are added:

SKB_DROP_REASON_GRE_VERSION
SKB_DROP_REASON_GRE_NOHANDLER

Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Reviewed-by: Biao Jiang <benbjiang@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     |  4 ++++
 include/trace/events/skb.h |  2 ++
 net/ipv4/gre_demux.c       | 12 +++++++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 26538ceb4b01..5edb704af5bb 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -444,6 +444,10 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TAP_TXFILTER,	/* dropped by tx filter implemented
 					 * at tun/tap, e.g., check_filter()
 					 */
+	SKB_DROP_REASON_GRE_VERSION,	/* GRE version not supported */
+	SKB_DROP_REASON_GRE_NOHANDLER,	/* no handler found (version not
+					 * supported?)
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index e1670e1e4934..f2bcffdc4bae 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -61,6 +61,8 @@
 	EM(SKB_DROP_REASON_HDR_TRUNC, HDR_TRUNC)		\
 	EM(SKB_DROP_REASON_TAP_FILTER, TAP_FILTER)		\
 	EM(SKB_DROP_REASON_TAP_TXFILTER, TAP_TXFILTER)		\
+	EM(SKB_DROP_REASON_GRE_VERSION, GRE_VERSION)		\
+	EM(SKB_DROP_REASON_GRE_NOHANDLER, GRE_NOHANDLER)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/gre_demux.c b/net/ipv4/gre_demux.c
index cbb2b4bb0dfa..066cbaadc52a 100644
--- a/net/ipv4/gre_demux.c
+++ b/net/ipv4/gre_demux.c
@@ -146,20 +146,26 @@ EXPORT_SYMBOL(gre_parse_header);
 static int gre_rcv(struct sk_buff *skb)
 {
 	const struct gre_protocol *proto;
+	enum skb_drop_reason reason;
 	u8 ver;
 	int ret;
 
+	reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (!pskb_may_pull(skb, 12))
 		goto drop;
 
 	ver = skb->data[1]&0x7f;
-	if (ver >= GREPROTO_MAX)
+	if (ver >= GREPROTO_MAX) {
+		reason = SKB_DROP_REASON_GRE_VERSION;
 		goto drop;
+	}
 
 	rcu_read_lock();
 	proto = rcu_dereference(gre_proto[ver]);
-	if (!proto || !proto->handler)
+	if (!proto || !proto->handler) {
+		reason = SKB_DROP_REASON_GRE_NOHANDLER;
 		goto drop_unlock;
+	}
 	ret = proto->handler(skb);
 	rcu_read_unlock();
 	return ret;
@@ -167,7 +173,7 @@ static int gre_rcv(struct sk_buff *skb)
 drop_unlock:
 	rcu_read_unlock();
 drop:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return NET_RX_DROP;
 }
 
-- 
2.35.1

