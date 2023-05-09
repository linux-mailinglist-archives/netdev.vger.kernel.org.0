Return-Path: <netdev+bounces-992-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 610316FBC91
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 03:37:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3157F281159
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 01:36:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B81384;
	Tue,  9 May 2023 01:36:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF947C;
	Tue,  9 May 2023 01:36:55 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BC24215;
	Mon,  8 May 2023 18:36:53 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64115e652eeso39002206b3a.0;
        Mon, 08 May 2023 18:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683596213; x=1686188213;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=v6zAQOTkWtDOOBZdrEkoRuGqVTQxApi39/8Os2AcncY=;
        b=jpAbZDt9KWJPk6nQW3VArhCf7JSp7ecP/vxzhAajETEIpFMXRZMLOttaTuIbZNfBAZ
         aD4RgnKnUV3XIy0lUMsmU8SjmyduuM89IfnlPpBUgU6vCt2YLsO1zLXxlEGweA/bVq6/
         GYarrZMWICsrDCvALlHKO49eCcwy4uB6s3rCSA89XUYjjMf0UjRIRcKUmRxo/fd3TFsL
         R6Q4vsX9KEXdPx1nd6tCqqIqwwuDyTY4FwniIj25Uh3hdhuLSqiWUYgwmj1lL0giCPuB
         AXG07nkM47imV/l4zId8hyepeIvt+TjRLpVb/bH95cWLsSXVIY9qRIlywrUOsEhB0siu
         XHFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683596213; x=1686188213;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v6zAQOTkWtDOOBZdrEkoRuGqVTQxApi39/8Os2AcncY=;
        b=YxPRA1IgQd9mD8JHxdr7dVHC3TIJjv6K5onQy3SeqvO6PfpepzNLOT9DDg5iJU8PnT
         LtIk7AvMTM0feTmW/H7aZI6tP17Nu+Mv4RN8+KHBb2tvtrCZ0jqgkngxeQvhc+1sfxqI
         DmaYa4BiEEb4s4FIQvDlaVMHbOp2uMAgfUmqLMO11QfB2vqHe8ocpGS0ZkmlNtv9uzxF
         qsuFJHk0fBNHWFjd/vjJgSmBK43nASJQa49JVRVhAhvcAHstSepyechUeC15tC67byVz
         VpCvQvoDLn2XZFKWp/70BXwq8S77bknR3EfvgtCFpemDiN8JJEf6ivJB1lg7w+twpXke
         LPJQ==
X-Gm-Message-State: AC+VfDy6uNMgeqRK30hkVnbKuZCvGv1meUio2f/j3Hj80w2cUKwqLJje
	UBTp0UOXQP7Qv+1YISzJXMI=
X-Google-Smtp-Source: ACHHUZ74JrQhvq5222wSbD6o0rqwph1ZEYmf2tn0416MlkouTB3b6ddDYWMFYGdcAoSGbaJh6w/vDw==
X-Received: by 2002:a17:903:1209:b0:1a9:7912:850e with SMTP id l9-20020a170903120900b001a97912850emr15316784plh.10.1683596213020;
        Mon, 08 May 2023 18:36:53 -0700 (PDT)
Received: from awk.. (arc.lsta.media.kyoto-u.ac.jp. [130.54.10.65])
        by smtp.gmail.com with ESMTPSA id p20-20020a170902a41400b0019aaab3f9d7sm138816plq.113.2023.05.08.18.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 18:36:52 -0700 (PDT)
From: Taichi Nishimura <awkrail01@gmail.com>
To: davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	Taichi Nishimura <awkrail01@gmail.com>
Subject: [PATCH] add braces to rt_type == RTN_BROADCAST case
Date: Tue,  9 May 2023 10:36:01 +0900
Message-Id: <20230509013601.2544346-1-awkrail01@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add braces to rt->rt_type == RTN_BROADCAST to make it easier
to grasp the if-else-if statement.
I think that it is ok to remove braces of rt_type == RTN_MULTICAST
because IP_UPD_PO_STATS is oneliner.

Signed-off-by: Taichi Nishimura <awkrail01@gmail.com>
---
 net/ipv4/ip_output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 61892268e8a6..8b761e1a9e24 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -203,8 +203,9 @@ static int ip_finish_output2(struct net *net, struct sock *sk, struct sk_buff *s
 
 	if (rt->rt_type == RTN_MULTICAST) {
 		IP_UPD_PO_STATS(net, IPSTATS_MIB_OUTMCAST, skb->len);
-	} else if (rt->rt_type == RTN_BROADCAST)
+	} else if (rt->rt_type == RTN_BROADCAST) {
 		IP_UPD_PO_STATS(net, IPSTATS_MIB_OUTBCAST, skb->len);
+	}
 
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
 		skb = skb_expand_head(skb, hh_len);
-- 
2.39.2


