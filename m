Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12104BCCF0
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 08:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243586AbiBTHJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 02:09:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243443AbiBTHJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 02:09:07 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B843A4D9EB;
        Sat, 19 Feb 2022 23:08:46 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id 12so7978775pgd.0;
        Sat, 19 Feb 2022 23:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XJ39oTdHw30Rs1eV+6bRzBftzJyi2esQlImZGRiJ6OY=;
        b=ger11xmyvB1IycXNx0x2jaxHbAZdUN5ZIuftitPOlIt/gNqHcMCh3/8477+tRltGMy
         Njr+CyRG6cAMiCydj26116yp0/l56bkrujMGlqz+egRxjJv033T5Jek8GKGiKZdrip+B
         pPJf0xrxL4zFpo1GVTFYzq9aHOe6ghE/T4zcdXXW40hzD0jaCD2azw7W45Ibb9+WuAAX
         39fBHAyKbp+mUhOCRCSyA5uWvwT14dgau1fE8Ng8ouAaK9jd2p9ffDlkyuaOM4y4f3P9
         p74+ftajA5pRYNdN00DZdUew7CwtJsCOCckiKxWj9jyHIKt4ECn2etnuq/dQEAUimBJl
         pjtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XJ39oTdHw30Rs1eV+6bRzBftzJyi2esQlImZGRiJ6OY=;
        b=SMvilKhV6wpYKbgrz44rx01ms/xpDYqLrl7OqvoOdSoi0i2hnumwFCViXGeuRnkxMD
         Zcg27u+oYuHM9g3dO1j+TBnbJMWHedY6IeMex6NfKM/0ZpKn9DEtIMHhcqPfOegyj1bp
         liCbCcDTa4EphR76dlI0wpuHUrpewWmYOqR0WXCAMUBQs4/HUjFw2CjAoTM/PHlpqwJJ
         ZfWEwL8Y1XlfJNAyC7aDg5u5edN+0p9xJvT0Z+Ib1Jq19oEx27E3H6hCi2l1E2obsMNv
         wucS/jWIdSfe+Bzhc+2tojBLqjBJzC1XjH5X2eGcBDVAsvWITTVDNvlZu1fMYxYiksxE
         2ZBQ==
X-Gm-Message-State: AOAM533RNQaz17CbaE3JYWnK91vsRNXcsOtC8pC8rReVb1qOXB79Qnnk
        4KgWF7RSFjWI/HrIk0+TCmc=
X-Google-Smtp-Source: ABdhPJyPSa2up5yX8s7plzb+RE2ck9N9uBEzzJ53XXLH1HkzixnoSE1/4CpZiBlNEThszSJOC7bO8A==
X-Received: by 2002:a65:52cc:0:b0:374:3ee6:c632 with SMTP id z12-20020a6552cc000000b003743ee6c632mr373131pgp.91.1645340926221;
        Sat, 19 Feb 2022 23:08:46 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id p1sm8351326pfo.212.2022.02.19.23.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 23:08:45 -0800 (PST)
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
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        flyingpeng@tencent.com, mengensun@tencent.com
Subject: [PATCH net-next v3 9/9] net: tcp: use tcp_drop_reason() for tcp_data_queue_ofo()
Date:   Sun, 20 Feb 2022 15:06:37 +0800
Message-Id: <20220220070637.162720-10-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220070637.162720-1-imagedong@tencent.com>
References: <20220220070637.162720-1-imagedong@tencent.com>
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

Replace tcp_drop() used in tcp_data_queue_ofo with tcp_drop_reason().
Following drop reasons are introduced:

SKB_DROP_REASON_TCP_OFOMERGE

Reviewed-by: Mengen Sun <mengensun@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 include/linux/skbuff.h     |  4 ++++
 include/trace/events/skb.h |  1 +
 net/ipv4/tcp_input.c       | 10 ++++++----
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 554ef2c848ee..a3e90efe6586 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -376,6 +376,10 @@ enum skb_drop_reason {
 					 * the right edges of receive
 					 * window
 					 */
+	SKB_DROP_REASON_TCP_OFOMERGE,	/* the data of skb is already in
+					 * the ofo queue, corresponding to
+					 * LINUX_MIB_TCPOFOMERGE
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index cc1c8f7eaf72..2ab7193313aa 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -36,6 +36,7 @@
 	EM(SKB_DROP_REASON_TCP_ZEROWINDOW, TCP_ZEROWINDOW)	\
 	EM(SKB_DROP_REASON_TCP_OLD_DATA, TCP_OLD_DATA)		\
 	EM(SKB_DROP_REASON_TCP_OVERWINDOW, TCP_OVERWINDOW)	\
+	EM(SKB_DROP_REASON_TCP_OFOMERGE, TCP_OFOMERGE)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 4da636aa9282..d3d7a7bef463 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4779,7 +4779,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFODROP);
 		sk->sk_data_ready(sk);
-		tcp_drop(sk, skb);
+		tcp_drop_reason(sk, skb, SKB_DROP_REASON_PROTO_MEM);
 		return;
 	}
 
@@ -4842,7 +4842,8 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 				/* All the bits are present. Drop. */
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPOFOMERGE);
-				tcp_drop(sk, skb);
+				tcp_drop_reason(sk, skb,
+						SKB_DROP_REASON_TCP_OFOMERGE);
 				skb = NULL;
 				tcp_dsack_set(sk, seq, end_seq);
 				goto add_sack;
@@ -4861,7 +4862,8 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 						 TCP_SKB_CB(skb1)->end_seq);
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPOFOMERGE);
-				tcp_drop(sk, skb1);
+				tcp_drop_reason(sk, skb1,
+						SKB_DROP_REASON_TCP_OFOMERGE);
 				goto merge_right;
 			}
 		} else if (tcp_ooo_try_coalesce(sk, skb1,
@@ -4889,7 +4891,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		tcp_dsack_extend(sk, TCP_SKB_CB(skb1)->seq,
 				 TCP_SKB_CB(skb1)->end_seq);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFOMERGE);
-		tcp_drop(sk, skb1);
+		tcp_drop_reason(sk, skb1, SKB_DROP_REASON_TCP_OFOMERGE);
 	}
 	/* If there is no skb after us, we are the last_skb ! */
 	if (!skb1)
-- 
2.35.1

