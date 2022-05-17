Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0DB9529BF6
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242677AbiEQINO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242664AbiEQIMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:12:38 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62913EB8D;
        Tue, 17 May 2022 01:12:09 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m12so16694536plb.4;
        Tue, 17 May 2022 01:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DJeIXN/OmSuazHjh5yZaGLXJ2vumkN5BeouJnoUdK54=;
        b=E1u6mLaXt7yirm/Pa4BNRXXeqEQ+kTpEzhxju4U1WANBDwQfSOv9XtN5r9qg5fozcw
         +hLztqhaQcgTqxUVaMujMGvFR118bKGG3sYYb6GACkUWUwE92ZgnWH+uTgPGF7LakwCf
         MJfbPHuA2F3HTw0hkkoqGebfiLfrZV9YUAsqGIJ5Wpx983zzDZX5X2LQgm2jkNq5klJA
         8HhwJMtet6WfMzhAb7NMCL4/LwVpvVyWegfVVrTq2ofKZICh8s2pisBl2Sv1JJ+B8ToQ
         MySoq6iHss0HliOoVeRiPX3vg6P7jt5zOYlJITg6TlelDsKXsoKlgurqCgaZWVsbYs2C
         SrxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DJeIXN/OmSuazHjh5yZaGLXJ2vumkN5BeouJnoUdK54=;
        b=KO3AhXixqE0Xi/vgo520GPn5AjYp/kBwlwS2lIH2pD0aVrmyHjr1qWAwIZZnsTLcHA
         qnggr4b1s+CVD1ALoN1DqnOS9r8KB57w26GViMIynMGbM/WmdsYxgg2+2fUOAvaweqw2
         TJW4E3DqzPXo07tbysKCthwO83tzkLMlAdFGgIvT6Kr10kxlrN1C8iLLsHBkxbwrF3LN
         c4+6KmLZwqMuNy3EHFhmzC4Mn6udSKKqWDsNHw9O5Gg3dE7Qb0K7PSw+FMht/oIkHMPo
         CR99UQ79p0JyjFOyoWxYK9PlntKefkbBjQshf+gZqgqaG0Cy9YUnzQS2L2oX5+MhCM4H
         5JNg==
X-Gm-Message-State: AOAM531MD1gvFgq9KZI7bq0nJdEsfMuSEi90vYW7a4IM76CJomcdQs3a
        P3XXWHqNnZ0PqjDdf9kF6tk=
X-Google-Smtp-Source: ABdhPJzv/CGo0C0NQKrOa3ABeuJCxhjWLTJ2BFztKcVi0eHBrp3g7KYPb/PTtY6ea0yZvE55i6KImg==
X-Received: by 2002:a17:90a:764b:b0:1df:58f2:784c with SMTP id s11-20020a17090a764b00b001df58f2784cmr8944224pjl.122.1652775129184;
        Tue, 17 May 2022 01:12:09 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.20])
        by smtp.gmail.com with ESMTPSA id c14-20020a170902c2ce00b0015e8d4eb2easm8336306pla.308.2022.05.17.01.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 01:12:08 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: [PATCH net-next v2 5/9] net: tcp: make tcp_rcv_synsent_state_process() return drop reasons
Date:   Tue, 17 May 2022 16:10:04 +0800
Message-Id: <20220517081008.294325-6-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220517081008.294325-1-imagedong@tencent.com>
References: <20220517081008.294325-1-imagedong@tencent.com>
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

The return value of tcp_rcv_synsent_state_process() can be -1, 0 or 1:

- -1: free skb silently
- 0: success and skb is already freed
- 1: drop packet and send a RST

Therefore, we can make it return skb drop reasons on 'reset_and_undo'
path, which will not impact the caller.

The new reason 'TCP_PAWSACTIVEREJECTED' is added, which is corresponding
to LINUX_MIB_PAWSACTIVEREJECTED.

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h | 1 +
 net/ipv4/tcp_input.c   | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3c7b1e9aabbb..36e0971f4cc9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -619,6 +619,7 @@ struct sk_buff;
 	FN(IP_INNOROUTES)		\
 	FN(PKT_TOO_BIG)			\
 	FN(SOCKET_DESTROYED)		\
+	FN(TCP_PAWSACTIVEREJECTED)	\
 	FN(MAX)
 
 /* The reason of skb drop, which is used in kfree_skb_reason().
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 97cfcd85f84e..e8d26a68bc45 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6174,6 +6174,10 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 				inet_csk_reset_xmit_timer(sk,
 						ICSK_TIME_RETRANS,
 						TCP_TIMEOUT_MIN, TCP_RTO_MAX);
+			if (after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt))
+				SKB_DR_SET(reason, TCP_ACK_UNSENT_DATA);
+			else
+				SKB_DR_SET(reason, TCP_TOO_OLD_ACK);
 			goto reset_and_undo;
 		}
 
@@ -6182,6 +6186,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 			     tcp_time_stamp(tp))) {
 			NET_INC_STATS(sock_net(sk),
 					LINUX_MIB_PAWSACTIVEREJECTED);
+			SKB_DR_SET(reason, TCP_PAWSACTIVEREJECTED);
 			goto reset_and_undo;
 		}
 
@@ -6375,7 +6380,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 reset_and_undo:
 	tcp_clear_options(&tp->rx_opt);
 	tp->rx_opt.mss_clamp = saved_clamp;
-	return 1;
+	return reason;
 }
 
 static void tcp_rcv_synrecv_state_fastopen(struct sock *sk)
-- 
2.36.1

