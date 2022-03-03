Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B732E4CC45A
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbiCCRuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235548AbiCCRt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:49:57 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0516D87E;
        Thu,  3 Mar 2022 09:49:08 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id e13so5231277plh.3;
        Thu, 03 Mar 2022 09:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ruUEYX+oGrKbn1ZFxR7e2X74GRqZCSY8RPwITu5sMBQ=;
        b=U8UL49W6S95k93kWUmUrZFOzV7AbqOjJ1bvHbZte2nKkMImfo75O4/DPZLqHC3elEp
         c+LZNgdegz2lHbu/RdR6vG9Ln7uG/fSitvZ+uxszFFHomApmFxo+8Lcz2+48izzHzbf4
         UiOBTkVeiHLPhO0AhY+CCq8jEARbdisLO4M1/Qio4qV7PEdJmuzR5LNMnCfVzQXSKh6F
         CspWJg5YFdFl7tbLlAByeDrhMJV6OruBTPfRuxH9AuHQo+iUO+D20ot/ll3ZcwpDlDJI
         Ua2+yPUkeHalmu+tZdRjZawPc6L5eGbNH78deLTVZx78YQdW0fCfMYTLg7rXDAhE4o5z
         x5Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ruUEYX+oGrKbn1ZFxR7e2X74GRqZCSY8RPwITu5sMBQ=;
        b=pTJifR9+MbYeLJoW/empF7Hs+1DYx98wgjMKwmByw2ibuq7spHUrZyxURaql0a07My
         NCHyQrYEAmIEvnSZ//xNh3QbAkg6BUVQrNNx/m8hJqvZXHweHhAgF3n5LZJatLTsPfiZ
         tnxjRYBjrOxHG52HADJdDkDrRGVGaK9sU80XqsSKx9A8VCLHKTCcFW+bma+8/CYVIZYF
         EXbZCM4aaJNB7QqQ5oIuhTLbddYkTJxD0LJNhNd6WYj7AOaYW+nZrPHF3pOR6FKISvi3
         wewukAUjpdkxSJ6NNu08jZrGBQJFFpW8TIwZ7v8ljOfc0QiFbiUxw1SUu75W1x8FVr7k
         w1bg==
X-Gm-Message-State: AOAM533fOeeyG8o4pkBaxQ7uCgAP4gc93Y56xD2WmVbbTiEuTTbgMzIS
        DpWhLtZ4yqudYiIJwebHCFc=
X-Google-Smtp-Source: ABdhPJzYUCmgCQ43Sq8ZW/63tx2sfXwtI21Xs+ZjEulnRLAPyr/CB2m3mSf68xNzY2i7M7IZsAqTyA==
X-Received: by 2002:a17:902:ec8c:b0:151:b231:70da with SMTP id x12-20020a170902ec8c00b00151b23170damr2229816plg.5.1646329747662;
        Thu, 03 Mar 2022 09:49:07 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.116])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f0f0f852a4sm3209395pfx.77.2022.03.03.09.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 09:49:07 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, imagedong@tencent.com,
        edumazet@google.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com, atenart@kernel.org,
        bigeasy@linutronix.de, memxor@gmail.com, arnd@arndb.de,
        pabeni@redhat.com, willemb@google.com, vvs@virtuozzo.com,
        cong.wang@bytedance.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH net-next 7/7] net: dev: use kfree_skb_reason() for __netif_receive_skb_core()
Date:   Fri,  4 Mar 2022 01:47:07 +0800
Message-Id: <20220303174707.40431-8-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220303174707.40431-1-imagedong@tencent.com>
References: <20220303174707.40431-1-imagedong@tencent.com>
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

Add reason for skb drops to __netif_receive_skb_core() when packet_type
not found to handle the skb. For this purpose, the drop reason
SKB_DROP_REASON_PTYPE_ABSENT is introduced. Take ether packets for
example, this case mainly happens when L3 protocol is not supported.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h | 5 +++++
 net/core/dev.c         | 8 +++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 04508d15152e..f3945d21cecf 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -413,6 +413,11 @@ enum skb_drop_reason {
 					 * failed (maybe an eBPF program
 					 * is tricking?)
 					 */
+	SKB_DROP_REASON_PTYPE_ABSENT,	/* not packet_type found to handle
+					 * the skb. For an etner packet,
+					 * this means that L3 protocol is
+					 * not supported
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 429ad8265e8c..0bdea7d113f5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5330,11 +5330,13 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 		*ppt_prev = pt_prev;
 	} else {
 drop:
-		if (!deliver_exact)
+		if (!deliver_exact) {
 			atomic_long_inc(&skb->dev->rx_dropped);
-		else
+			kfree_skb_reason(skb, SKB_DROP_REASON_PTYPE_ABSENT);
+		} else {
 			atomic_long_inc(&skb->dev->rx_nohandler);
-		kfree_skb(skb);
+			kfree_skb(skb);
+		}
 		/* Jamal, now you will not able to escape explaining
 		 * me how you were going to use this. :-)
 		 */
-- 
2.35.1

