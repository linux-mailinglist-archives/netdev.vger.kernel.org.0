Return-Path: <netdev+bounces-3348-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DE0C70686E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:42:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE9781C20EF0
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39F3F18B1D;
	Wed, 17 May 2023 12:42:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA84156EA
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:42:16 +0000 (UTC)
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB151BF;
	Wed, 17 May 2023 05:42:14 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d2e1a72fcca58-64384274895so497182b3a.2;
        Wed, 17 May 2023 05:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684327334; x=1686919334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2/0OAhjGOHrmxWrbN9W3gRqX+XIbc1pmgYwBMpZEkis=;
        b=Y2JdKOfL1Y+jzb6X3BwIf/rxj42QRt8mwa4OtrOo0pu0hjdph/vy9O7eH+P3bIA/Wu
         ObzfpTrmVyGvCJORHYgUYs63ox5JQQv/FRwl9SFocNMVExF5lLaAQG9UiPlCG0Jv7s8G
         6LMlcqfLrmNaXeg0l4kft5e1G1DmFygQR4JE0vv3Dw0/+gu1CJglcwWjV9sAL777wQWF
         zgr7s1jXiNG48TH1iYBF9fwp0zpib2gLE8KvL3Jfux1bEOuSqajB7oeNgg7YzCJ1ehdo
         sLmmu6yhcGPYxOvDNgsmSJxp6ej8BVPuFWKC9iNYrKSmZJPY/iNfhZ4KCEtIKCuF6jQH
         +3FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684327334; x=1686919334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2/0OAhjGOHrmxWrbN9W3gRqX+XIbc1pmgYwBMpZEkis=;
        b=RmG2sAtCxUGALczBSP0DB/C13TIwPnqdOtcUm2TMBZYVf72Kvb2UfK+sWwT+wMOb3E
         YDawev2Yq2QOEAGVDUM9VoUHu5YBhLDPOnnSbleximUlvAGJqpEYmfFl9qpVEMoLWdW0
         Fifc239w3DEjxhJQpYTid/xjwJ8ErfSDIJ2TWvW4eJwD84ttQTq4W7TFZAwfoQhuaEuA
         3z8kezc2knXTsTPoOjWiJy8pkI9nIZrMunQtqsMTWrd+Nv0oJZaRxOjVWj2brVwL49ns
         bQXB05QFX4YyEk4R7XiuHSnsp/lvDmA30T9UPGdsFF5hM1zX/2QJFY6vAyl1CGU+VUY2
         J5pw==
X-Gm-Message-State: AC+VfDw90wgJerrvxaud1oPY7oUm80haSgOWLCXf0iXtH2rmlcZWF6NF
	RaWBP7mX8rb4NubmVE1T3DU=
X-Google-Smtp-Source: ACHHUZ5Xclg3N4WSLv1+naH6PK6QsV3ODhQj3peOYplty+jdFtJZ+SsKXw/ZRTCtlBayT25szg+Dxw==
X-Received: by 2002:a05:6a00:1308:b0:647:f128:c4f5 with SMTP id j8-20020a056a00130800b00647f128c4f5mr873899pfu.22.1684327333721;
        Wed, 17 May 2023 05:42:13 -0700 (PDT)
Received: from localhost.localdomain ([81.70.217.19])
        by smtp.gmail.com with ESMTPSA id u23-20020aa78497000000b0064aea45b040sm9244224pfn.168.2023.05.17.05.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 05:42:13 -0700 (PDT)
From: menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To: kuba@kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	dsahern@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Menglong Dong <imagedong@tencent.com>
Subject: [PATCH net-next 2/3] net: tcp: send zero-window when no memory
Date: Wed, 17 May 2023 20:42:00 +0800
Message-Id: <20230517124201.441634-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230517124201.441634-1-imagedong@tencent.com>
References: <20230517124201.441634-1-imagedong@tencent.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Menglong Dong <imagedong@tencent.com>

For now, skb will be dropped when no memory, which makes client keep
retrans util timeout and it's not friendly to the users.

Therefore, now we force to receive one packet on current socket when
the protocol memory is out of the limitation. Then, this socket will
stay in 'no mem' status, util protocol memory is available.

When a socket is in 'no mem' status, it's receive window will become
0, which means window shrink happens. And the sender need to handle
such window shrink properly, which is done in the next commit.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/net/sock.h    |  1 +
 net/ipv4/tcp_input.c  | 12 ++++++++++++
 net/ipv4/tcp_output.c |  7 +++++++
 3 files changed, 20 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 5edf0038867c..90db8a1d7f31 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -957,6 +957,7 @@ enum sock_flags {
 	SOCK_XDP, /* XDP is attached */
 	SOCK_TSTAMP_NEW, /* Indicates 64 bit timestamps always */
 	SOCK_RCVMARK, /* Receive SO_MARK  ancillary data with packet */
+	SOCK_NO_MEM, /* protocol memory limitation happened */
 };
 
 #define SK_FLAGS_TIMESTAMP ((1UL << SOCK_TIMESTAMP) | (1UL << SOCK_TIMESTAMPING_RX_SOFTWARE))
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a057330d6f59..56e395cb4554 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5047,10 +5047,22 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 		if (skb_queue_len(&sk->sk_receive_queue) == 0)
 			sk_forced_mem_schedule(sk, skb->truesize);
 		else if (tcp_try_rmem_schedule(sk, skb, skb->truesize)) {
+			if (sysctl_tcp_wnd_shrink)
+				goto do_wnd_shrink;
+
 			reason = SKB_DROP_REASON_PROTO_MEM;
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRCVQDROP);
 			sk->sk_data_ready(sk);
 			goto drop;
+do_wnd_shrink:
+			if (sock_flag(sk, SOCK_NO_MEM)) {
+				NET_INC_STATS(sock_net(sk),
+					      LINUX_MIB_TCPRCVQDROP);
+				sk->sk_data_ready(sk);
+				goto out_of_window;
+			}
+			sk_forced_mem_schedule(sk, skb->truesize);
+			sock_set_flag(sk, SOCK_NO_MEM);
 		}
 
 		eaten = tcp_queue_rcv(sk, skb, &fragstolen);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index cfe128b81a01..21dc4f7e0a12 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -300,6 +300,13 @@ static u16 tcp_select_window(struct sock *sk)
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPFROMZEROWINDOWADV);
 	}
 
+	if (sock_flag(sk, SOCK_NO_MEM)) {
+		if (sk_memory_allocated(sk) < sk_prot_mem_limits(sk, 2))
+			sock_reset_flag(sk, SOCK_NO_MEM);
+		else
+			new_win = 0;
+	}
+
 	return new_win;
 }
 
-- 
2.40.1


