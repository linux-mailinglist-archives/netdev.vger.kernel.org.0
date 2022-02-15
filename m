Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD344B6AD5
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237132AbiBOLab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:30:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiBOLaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:30:30 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6ECB108740;
        Tue, 15 Feb 2022 03:30:20 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id d187so34342894pfa.10;
        Tue, 15 Feb 2022 03:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PWCUxhFuetzy8XEMuMabWi0zcJlDPvaSTrXNtpeJPaI=;
        b=lLHLOb7cfmsVYE4qnodW8UZMp0zmQobrutooS/4fuSrgfadDXtEfs6ItYYp0Xjwzo/
         ba5d94hP7FEpKar6l/A3lE0p24tPUSZjw2dmkT7/FnrV6KOSvkw31Jnq4N6tlH5eD7/E
         j7v4YqHw69mfRRj8TTBjAOhVhSxngO/nHCxMSKmxnCtzUm54n+8MJ4Q9h5iXTp6uGG95
         LIGCH3baiUTPyEJ7Zon4IY/54Wqk8v4W7FPzQxcY5NjShpQHLI7/eNYcL8CTSzv1+lzU
         L6a9KKc3NBgHwq3qpxmjXHi19LncG7pSGgnpbCtalPN6GVJOaykc3QOKwjLK9d1psuB5
         YVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PWCUxhFuetzy8XEMuMabWi0zcJlDPvaSTrXNtpeJPaI=;
        b=4PcnAv8gTIc5NUM2s19jpm5FlnEECXSIGwc/pJQQ3MUX+yZJnvV6IfyqNS7apvkmbN
         fByXdmqJyHxhB39fh4qtOVH7OhJ+628cngiBC2WyH1UyjhrW5VVdEDmBnsLEVcEK/vCp
         6Vwt1LmGDXnt45KHldvClLvqNdKLo9AFCtto3NfZTBk/YXohm0DAI616uo20w1UclMzf
         GsIMFmGt86UiUa/NroSo2BFZ1sgOBzHa5IQ+OckLZPGnnPvSd2qf2W5Lu52jz19zfzPo
         aocAzwRZ52bJwujf7nPI4TOdt6kDu0j7FzgxGYsTa6TF8N3LA3SWBQJPa1fQ7u8MHQHC
         HSMQ==
X-Gm-Message-State: AOAM531UGjPDSnZz05ESk6Ux4azp2+iqKQQerBkVUhdofiTrbc07ARKw
        8eQEDUd7EH7n5Q7u2EzsELs=
X-Google-Smtp-Source: ABdhPJzfrxFnswR6qy7o+5ZC0YryaUAyDk3vPX+gtBzTwCEo60c2pdc4Y5kwMymWKbi5g+NUFF8a/w==
X-Received: by 2002:a62:6d01:: with SMTP id i1mr3475506pfc.45.1644924620400;
        Tue, 15 Feb 2022 03:30:20 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:30:19 -0800 (PST)
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
Subject: [PATCH net-next 01/19] net: tcp: introduce tcp_drop_reason()
Date:   Tue, 15 Feb 2022 19:27:54 +0800
Message-Id: <20220215112812.2093852-2-imagedong@tencent.com>
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

For TCP protocol, tcp_drop() is used to free the skb when it needs
to be dropped. To make use of kfree_skb_reason() and collect drop
reasons, introduce the function tcp_drop_reason().

tcp_drop_reason() will finally call kfree_skb_reason() and pass the
drop reason to 'kfree_skb' tracepoint.

PS: __kfree_skb() was used in tcp_drop(), I'm not sure if it's ok
to replace it with kfree_skb_reason().

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/ipv4/tcp_input.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index af94a6d22a9d..e3811afd1756 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4684,10 +4684,19 @@ static bool tcp_ooo_try_coalesce(struct sock *sk,
 	return res;
 }
 
-static void tcp_drop(struct sock *sk, struct sk_buff *skb)
+static void tcp_drop_reason(struct sock *sk, struct sk_buff *skb,
+			    enum skb_drop_reason reason)
 {
 	sk_drops_add(sk, skb);
-	__kfree_skb(skb);
+	/* why __kfree_skb() used here before, other than kfree_skb()?
+	 * confusing......
+	 */
+	kfree_skb_reason(skb, reason);
+}
+
+static inline void tcp_drop(struct sock *sk, struct sk_buff *skb)
+{
+	tcp_drop_reason(sk, skb, SKB_DROP_REASON_NOT_SPECIFIED);
 }
 
 /* This one checks to see if we can put data from the
-- 
2.34.1

