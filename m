Return-Path: <netdev+bounces-2683-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B41C27031A2
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 17:34:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A8141C20C25
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37459DF4D;
	Mon, 15 May 2023 15:34:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF6CC13E
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 15:34:34 +0000 (UTC)
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE45C19BE
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 08:34:32 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-52160f75920so8929810a12.2
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 08:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684164872; x=1686756872;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sKlpqW6SkLO1atiwFunHXyFc+yDte28mssL8B2LZ8z4=;
        b=CD5D5Lsj6ifP08W3U3hwvFEGNPNcpL2IDidYmzArP8xi37TsS3+jJuEjHy9iLOlgoq
         CMaySQR49vQSMXgoDJkNmIwH/DeyyWEbJMsBZfS2l46Rzrd9QbuyS7bzKEK6wG1UgD6J
         oaj+g4BKrkwaubMukJHzro5bnhoQu1DFKHk9dDzQRyjfyU3fYIzSmDmGuVPRxsSgNqAT
         zAN6kSNnXTkTAxryZc0l+R7jwYJD66XYKEb1GJxgQ/jpoAqf3cetqrSudNG3K+Q2n6j2
         2TJF3Tc0iX6mSW3NK1rHNhgt58DnzSFC042IbY4auLuf2iOsJ1Oua+8BzUmU3ZX3qTM0
         iNNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684164872; x=1686756872;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sKlpqW6SkLO1atiwFunHXyFc+yDte28mssL8B2LZ8z4=;
        b=elirjA5b5UG9ScdHCqydXzeH4doINmq7qToB66ScMvpbN5uyGkcRIU4yk6WVaErv3A
         mG9QyThZlh7+BF4WbdH0W7aD1qYinmBGqbNpZLBa0oAzfCUHZeDnPkidB0iHWFBXQORu
         2rke17WuZwhIabMRnKZEOMUsiqm34ZLHiSfF+3BdYtObYMUdTEJgeeTPvRUI39F5KssP
         2olQIgtQQudgW8LQI9isY2041HX4qKuMKbH6pK+JC8+/XoGIsAe1OdQzvZhpDehBO0vn
         wFdTNtY+Cr5644YuZ5H3n45CtRJ0N7duvkX9aefcvb2ETFucDM2nbUx0dBmqzHtxU2X5
         hQTw==
X-Gm-Message-State: AC+VfDyOh6QC5B2lAEDK7rD3P0rbgRb0XNV/5vhOdPi2s0p91JZRdXBr
	2g4+LUNEn3KMykHnzB2ivqc=
X-Google-Smtp-Source: ACHHUZ44JP02S5hbcwMoazbm0SSS2R377FI/959OeSxjurQMqnaFLY/zq4id7u2vf0L82ztEy2vv4Q==
X-Received: by 2002:a17:902:a9c4:b0:1ac:8def:db2a with SMTP id b4-20020a170902a9c400b001ac8defdb2amr22446834plr.0.1684164872294;
        Mon, 15 May 2023 08:34:32 -0700 (PDT)
Received: from cl2ap-vscp0012n.. ([122.28.179.114])
        by smtp.gmail.com with ESMTPSA id a10-20020a170902ee8a00b001a9873495f2sm13678490pld.233.2023.05.15.08.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 08:34:31 -0700 (PDT)
From: Yuya Tajima <yuya.tajimaa@gmail.com>
To: davem@davemloft.net,
	dsahern@kernel.org
Cc: netdev@vger.kernel.org,
	yuya.tajimaa@gmail.com
Subject: [PATCH net-next] seg6: Cleanup duplicates of skb_dst_drop calls
Date: Mon, 15 May 2023 15:34:27 +0000
Message-Id: <20230515153427.3385392-1-yuya.tajimaa@gmail.com>
X-Mailer: git-send-email 2.34.1
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

In processing IPv6 segment routing header (SRH), several functions call
skb_dst_drop before ip6_route_input. However, ip6_route_input calls
skb_dst_drop within it, so there is no need to call skb_dst_drop in advance.

Signed-off-by: Yuya Tajima <yuya.tajimaa@gmail.com>
---
 net/ipv6/exthdrs.c       | 3 ---
 net/ipv6/seg6_iptunnel.c | 3 +--
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index a8d961d3a477..04c14fc4b14d 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -458,8 +458,6 @@ static int ipv6_srh_rcv(struct sk_buff *skb)
 
 	ipv6_hdr(skb)->daddr = *addr;
 
-	skb_dst_drop(skb);
-
 	ip6_route_input(skb);
 
 	if (skb_dst(skb)->error) {
@@ -834,7 +832,6 @@ static int ipv6_rthdr_rcv(struct sk_buff *skb)
 	*addr = ipv6_hdr(skb)->daddr;
 	ipv6_hdr(skb)->daddr = daddr;
 
-	skb_dst_drop(skb);
 	ip6_route_input(skb);
 	if (skb_dst(skb)->error) {
 		skb_push(skb, skb->data - skb_network_header(skb));
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 34db881204d2..03b877ff4558 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -470,8 +470,6 @@ static int seg6_input_core(struct net *net, struct sock *sk,
 	dst = dst_cache_get(&slwt->cache);
 	preempt_enable();
 
-	skb_dst_drop(skb);
-
 	if (!dst) {
 		ip6_route_input(skb);
 		dst = skb_dst(skb);
@@ -482,6 +480,7 @@ static int seg6_input_core(struct net *net, struct sock *sk,
 			preempt_enable();
 		}
 	} else {
+		skb_dst_drop(skb);
 		skb_dst_set(skb, dst);
 	}
 
-- 
2.34.1


