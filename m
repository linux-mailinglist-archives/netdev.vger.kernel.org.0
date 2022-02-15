Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E162A4B6ADB
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237159AbiBOLaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:30:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237175AbiBOLas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:30:48 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FD2108BE4;
        Tue, 15 Feb 2022 03:30:39 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id y5so34381819pfe.4;
        Tue, 15 Feb 2022 03:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JnniAd21EY8afdlsgFug6BUpPk02YT/3Ko5AD7mlY8M=;
        b=EzWLPid2Z+SJowrlIhoOYMZgdSusGpE4xyNsetMY5ULLe7gEFA1qDLG9ruIGswluyr
         UgwrHEVJb4/SiE24t7zTOny9xYaw4QT56+ihTUnSEdHjGsOGHUte4NUcfTIXoc+SCyyM
         OXqH/KcjZSOi5hiyLeJc3nsDslMKWd2x+dLdWhv+scVS/uiTCe7nXDxpXoLmNSvpEPOs
         1T7092/hePMomU5FSTeNJxlyyiTam/obQDkPXUqDWBijrhVIxgbOoQk/ArjRwNEFAPub
         BEkYAFfNzoOZ4SU7SsZ/eG4MMsRk7SJ49Ut5tz/WOVfnJFQ6IX4e50Yf2uAOaBonQn6H
         vdrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JnniAd21EY8afdlsgFug6BUpPk02YT/3Ko5AD7mlY8M=;
        b=uAqoJvf5gvbkOcsrHheKXTxZ2ED/IFeSFj78FxK1vuE88tZYsJdYbIWZLw/fu6GMX1
         k2o0RLMl+kZTjHZ20kAneYePQoZlgaCQ9xmyscFW9z6ChXO3jVnGbDCANxKUlx6H0Brd
         eE+aCvjCNfcbu5NaXd88hFZ+R+p13O5NG22bLYhH7P6TCx48sUKPQjXnYbyyS9ElV4fY
         Y4lO/f6C3ilsMxamz8bjIc5JfGq/c0uTfVe95kwlgcPgW7lCU0kwx6jCzYR8qxulU43j
         JSl6tkCMTn8NGhO2Dg0AIrH5lq9RwRck6MzG29UYg4kaD1N18PyOiYDtRRDh34D/GZoZ
         rKLQ==
X-Gm-Message-State: AOAM531228G5yEBRYJ3sTGgGi3nDn4AxTsm0zFlDGRGoKSgMbHCPPCm5
        s3xhO69hfjCKIOA+Q56D1Ro=
X-Google-Smtp-Source: ABdhPJwN5Ih91tdIz/KopWZlUuhmNrw3qjN8BS1BAPwVKdVyzfSefMsGZEzRYHv/YQeK+QKN5tM20Q==
X-Received: by 2002:a63:f508:: with SMTP id w8mr3230195pgh.236.1644924638566;
        Tue, 15 Feb 2022 03:30:38 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:30:38 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@redhat.com, yoshfuji@linux-ipv6.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        imagedong@tencent.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org, alobakin@pm.me,
        memxor@gmail.com, atenart@kernel.org, bigeasy@linutronix.de,
        pabeni@redhat.com, linyunsheng@huawei.com, arnd@arndb.de,
        yajun.deng@linux.dev, roopa@nvidia.com, willemb@google.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, flyingpeng@tencent.com
Subject: [PATCH net-next 02/19] net: tcp: add skb drop reasons to tcp_v4_rcv()
Date:   Tue, 15 Feb 2022 19:27:55 +0800
Message-Id: <20220215112812.2093852-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215112812.2093852-1-imagedong@tencent.com>
References: <20220215112812.2093852-1-imagedong@tencent.com>
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

Use kfree_skb_reason() for some path in tcp_v4_rcv() that missed before,
including:

SKB_DROP_REASON_SOCKET_FILTER
SKB_DROP_REASON_XFRM_POLICY

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/ipv4/tcp_ipv4.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6873f46fc8ba..a93921fb498f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2057,6 +2057,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			iph = ip_hdr(skb);
 			tcp_v4_fill_cb(skb, iph, th);
 			nsk = tcp_check_req(sk, skb, req, false, &req_stolen);
+		} else {
+			drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		}
 		if (!nsk) {
 			reqsk_put(req);
@@ -2092,8 +2094,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		}
 	}
 
-	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
+	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb)) {
+		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		goto discard_and_relse;
+	}
 
 	if (tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))
 		goto discard_and_relse;
@@ -2137,8 +2141,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 no_tcp_socket:
 	drop_reason = SKB_DROP_REASON_NO_SOCKET;
-	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
+	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb)) {
+		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		goto discard_it;
+	}
 
 	tcp_v4_fill_cb(skb, iph, th);
 
@@ -2166,6 +2172,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 do_time_wait:
 	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb)) {
+		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		inet_twsk_put(inet_twsk(sk));
 		goto discard_it;
 	}
-- 
2.34.1

