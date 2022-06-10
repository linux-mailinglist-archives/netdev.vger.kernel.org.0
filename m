Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA744545ABD
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 05:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346198AbiFJDpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 23:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346216AbiFJDpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 23:45:02 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C2B3835AB;
        Thu,  9 Jun 2022 20:45:00 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id o6-20020a17090a0a0600b001e2c6566046so1129693pjo.0;
        Thu, 09 Jun 2022 20:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QJe7PVbXz86Kb4R4oqK5wg/U0E77BJ26lLBZaQP/WYU=;
        b=FifS37iwKw0BYE4KXEq1ksVTy8m0AGIKwe5a3eqfgb6SP6J5YiXHUmrAq/JVQlo8+J
         NzBwz3XzNO4BJJsO+bpH6oN4ez2qrB0bvvTW1vteXIisgtrcsJU7lZg3odgRI8ynR4er
         r4MlDdHnDrwVVAHu4UU6/9pQRcE5iA6sWNBNCWFZDLfhbK3Ui2JzgVbEB4gYOOf9QdJp
         i2Onts3mzVsVFWNDoIKkYAzBKixChoElVwNsgpNzXuTzzgLpWuT+i7Ni0cKixT8Op3u6
         w/8KmNoJso2KXn6Zv1/LNUP+SBwcIq4KzJNbMRvasjvyGHU5CTxAH0U6eY4bAk+PopEZ
         r3ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QJe7PVbXz86Kb4R4oqK5wg/U0E77BJ26lLBZaQP/WYU=;
        b=PuMsc/R9O0Oul+ZiSEM1bwWo0KKqlrMF9B2BKxWpClgt+kopTaX9TtLzM8Y3Ky9RI2
         7Y7FPZkX1vk5rYyASg47rJNyo8b/FhLHuVnOwCaxQt4idgxovgSr7nxMdyDDLuu9XOmy
         NzNLWGynQqkmXKymIpl17Tl7GWHItL5KlfVFNAPCOvbB8jDnjZOi0bc9CPpz/EJ5P9os
         mxdpmcAzfuKVqoQbcBc4tjJTxw6lnDK2RVEhh/mjnl6s4jbqc0CUk4V4X58nAMU6UGx9
         d5rDnqZI/hB6jOjfihTXnRHgIRP02qW1jsW4m3tPwqIWYk4ve0mk1cBuPbP+XH+JtBU7
         MgOg==
X-Gm-Message-State: AOAM530ogPLS5/BaBL3X0bpf652Sf5nTAfMS9r8lOT5WPhr2AetA09jK
        irAbqD4uJmIEuErg5hUC3ZI=
X-Google-Smtp-Source: ABdhPJz1hoVe76gMHZ11Cdff4NKjceUwtcRuooFagV6mePqvzotGsEvysuDDhiKiHHiDdxnERpeYAQ==
X-Received: by 2002:a17:902:f650:b0:15f:3a10:a020 with SMTP id m16-20020a170902f65000b0015f3a10a020mr42377378plg.61.1654832700353;
        Thu, 09 Jun 2022 20:45:00 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id u30-20020a63b55e000000b003fc136f9a7dsm5908368pgo.38.2022.06.09.20.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 20:44:59 -0700 (PDT)
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
Subject: [PATCH net-next v3 4/9] net: tcp: make tcp_rcv_synsent_state_process() return drop reasons
Date:   Fri, 10 Jun 2022 11:41:59 +0800
Message-Id: <20220610034204.67901-5-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220610034204.67901-1-imagedong@tencent.com>
References: <20220610034204.67901-1-imagedong@tencent.com>
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

Therefore, we can make it return skb drop reasons instead of '1' on
'reset_and_undo' path, which will not impact the caller.

The new reason 'TCP_PAWSACTIVEREJECTED' is added, which is corresponding
to LINUX_MIB_PAWSACTIVEREJECTED.

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/net/dropreason.h | 6 ++++++
 net/ipv4/tcp_input.c     | 7 ++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 3c6f1e299c35..c60913aba0e9 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -236,6 +236,12 @@ enum skb_drop_reason {
 	 * skb in its receive or send queue are all dropped
 	 */
 	SKB_DROP_REASON_SOCKET_DESTROYED,
+	/**
+	 * @SKB_DROP_REASON_TCP_PAWSACTIVEREJECTED: PAWS check failed for
+	 * active TCP connection, corresponding to
+	 * LINUX_MIB_PAWSACTIVEREJECTED
+	 */
+	SKB_DROP_REASON_TCP_PAWSACTIVEREJECTED,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2e2a9ece9af2..9254f14def43 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6177,6 +6177,10 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 				inet_csk_reset_xmit_timer(sk,
 						ICSK_TIME_RETRANS,
 						TCP_TIMEOUT_MIN, TCP_RTO_MAX);
+			if (after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt))
+				SKB_DR_SET(reason, TCP_ACK_UNSENT_DATA);
+			else
+				SKB_DR_SET(reason, TCP_TOO_OLD_ACK);
 			goto reset_and_undo;
 		}
 
@@ -6185,6 +6189,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 			     tcp_time_stamp(tp))) {
 			NET_INC_STATS(sock_net(sk),
 					LINUX_MIB_PAWSACTIVEREJECTED);
+			SKB_DR_SET(reason, TCP_PAWSACTIVEREJECTED);
 			goto reset_and_undo;
 		}
 
@@ -6378,7 +6383,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 reset_and_undo:
 	tcp_clear_options(&tp->rx_opt);
 	tp->rx_opt.mss_clamp = saved_clamp;
-	return 1;
+	return reason;
 }
 
 static void tcp_rcv_synrecv_state_fastopen(struct sock *sk)
-- 
2.36.1

