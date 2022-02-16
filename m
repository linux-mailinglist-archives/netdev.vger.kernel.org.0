Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520DC4B7EF6
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 04:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245220AbiBPDz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 22:55:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245195AbiBPDzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 22:55:22 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5107DEB142;
        Tue, 15 Feb 2022 19:55:11 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id q132so1013160pgq.7;
        Tue, 15 Feb 2022 19:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JnniAd21EY8afdlsgFug6BUpPk02YT/3Ko5AD7mlY8M=;
        b=NfTBFGX7gvJvRiNCHTGTJDbDv/wEIRthB3YzRRXj0BesMCjUamTM5V1gTbt09ttcsU
         Va7dgtsPxqnQHyY9BXWaDMbB0SHWQ4kRUBGDhy3T/trasEzJHmKOnDSbpugHAQcbAcP4
         chKuv0O4an5RnxyR6Ri1koSPn/JiOn0j1qxAbiU9/ekEIsnujJbIxMBSp/nlpL9RmbOi
         yQE/I/XOqMrrPYxDB9Ba3gvkC1kG6aoRZDCnBPlzKiMiG2YCczHA4XLrYdGu7QRbQy9F
         zpUz9kVtfrJkxa1M/69iJMZI7myly7gga+Nw/WyRKdDBDQCsFz/U3DIksL43RHvxiNZj
         Hitg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JnniAd21EY8afdlsgFug6BUpPk02YT/3Ko5AD7mlY8M=;
        b=sAIMVOKyQ7Ri2TstdSWAvlgTVpdAV3J1Q8HCEvN3IXgx5+NIwWEA+0/1fUpq7UFNu2
         hMgOUUePYQcke3ICGb3VLMFpMYaXoGYe0ZWOof+rhe+ObFRnyqPZFAAcyq4WUl4BKW2z
         mUBsQJgUqnQQw0mvPUsQrZcNdWSbhOi7r6GkMkZt0krHj56cniUobe83mOExHfGfp4SI
         s3Cvs5N0Kj1/5g3loiyQmBOoD96881qHVGozRrQWBb16TrLtCgE6rKeOWRgnLSnpuJcU
         mNprSZMShCxCv95Az8Duxoh45AozYy8j+15uuu70VSR/toPmzfCorn0ziez9BNqYPHVy
         uXfg==
X-Gm-Message-State: AOAM531PNGaykvUoOuXDaQ1LHsh30/6OQf15NBgjA4YJOrCw0PBTcMN6
        p9xzWAtSv9yO3vJdCjCdIBc=
X-Google-Smtp-Source: ABdhPJz9gt4T2YB/tfTdjqKaq6JYEGVA4o+vErDCEW2PWFcC5woxon3gInnjc9VDb+1m4M9nC9Mc5Q==
X-Received: by 2002:a62:8f8f:0:b0:4e0:7729:2429 with SMTP id n137-20020a628f8f000000b004e077292429mr934328pfd.47.1644983710853;
        Tue, 15 Feb 2022 19:55:10 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.gmail.com with ESMTPSA id nn16sm19099668pjb.2.2022.02.15.19.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 19:55:10 -0800 (PST)
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
Subject: [PATCH net-next 2/9] net: tcp: add skb drop reasons to tcp_v4_rcv()
Date:   Wed, 16 Feb 2022 11:54:19 +0800
Message-Id: <20220216035426.2233808-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220216035426.2233808-1-imagedong@tencent.com>
References: <20220216035426.2233808-1-imagedong@tencent.com>
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

