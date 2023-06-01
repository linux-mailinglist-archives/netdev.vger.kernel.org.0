Return-Path: <netdev+bounces-7242-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B59BF71F481
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 23:17:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1CF32818C8
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 21:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A31923D75;
	Thu,  1 Jun 2023 21:17:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E66733DF
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 21:17:35 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8328E196
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 14:17:34 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5618857518dso18292187b3.2
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 14:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685654253; x=1688246253;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HGHwbUSNPfodDaTVsYK4YLV6cTXrbYqDf+m4CaU+Vj4=;
        b=FeHTSyEYXgZUPtaQBBfIK/izkLSI5S2u739eRp+AMnOqO6rnwYDeLC5nU6fIts0NoV
         MonSvMrArTKzAnGnwaWZurE/8pZJMSYbW2Q5h4Ja3yAKskVBVbNA/RBZ+MWv1n6I7cfJ
         XAznJ4vzRrBfBtRegO6dtRMefvigTuay+ei5WlOw5+DupuONnxzmHhaDBNm3LfMj993i
         HEPUDcb5cNpvIQRaN1Q2QScq0FxGap+u+b2Rwzlstu8efzBKLPd+8dHjNkNQReoZ4StV
         yAfbRs7ejut39mQ5HFk9vKAjDHsxa4EW5zeabwGNRcu0mOfKIN3m8f9fTcq637q52Iuv
         mbpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685654253; x=1688246253;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HGHwbUSNPfodDaTVsYK4YLV6cTXrbYqDf+m4CaU+Vj4=;
        b=OZrkRShuFEWyq1MvKiyrUZ1aEnjz4gEP0tYxW3mCS/3E3xea+ZZFdhY0pcZxOZWC7Z
         0voSI74grFkVIxxusT7BZXP3lifolrUiW3D+gI9rHEqu0KgHdP270jrYatUh6N5xnDrm
         Shc7mLppTGJPtWIc2WdqwnGEYOru56zsladNP+ZREdpjp+NJ8nWLYSF9/cPsePmMeNJj
         uHFif0CGSWE3xWW0wCbpKB5AtSloqns/K6DVDAa+Wl8/SDRFy8CdLAMlQDWmpuVbDQTB
         x1fWZCBgXzd+2Pfc20j9JaXaA/MiXes2ee/A6Pl316ADeqCxdjZzsX8mqCiGHh8vMFVr
         tF7g==
X-Gm-Message-State: AC+VfDxv+59djffQfknWOFFSzomdhvLDrcUGb520rV5iwXzqm2/c1ci8
	JyTTPWx11U4VJlE87lXjuJd4zr9iFOg64w==
X-Google-Smtp-Source: ACHHUZ4LqLbYypBDPmSzws3Xwmx2TTmmdlVLUof8sSPY18i+jvP6PIsTW2l7ljfzNOrCOkH3e3pTVtdnwEjshA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:ae45:0:b0:566:861:e451 with SMTP id
 g5-20020a81ae45000000b005660861e451mr6080268ywk.7.1685654253754; Thu, 01 Jun
 2023 14:17:33 -0700 (PDT)
Date: Thu,  1 Jun 2023 21:17:32 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230601211732.1606062-1-edumazet@google.com>
Subject: [PATCH net] tcp: gso: really support BIG TCP
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, Xin Long <lucien.xin@gmail.com>, 
	David Ahern <dsahern@kernel.org>, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We missed that tcp_gso_segment() was assuming skb->len was smaller than 65535 :

oldlen = (u16)~skb->len;

This part came with commit 0718bcc09b35 ("[NET]: Fix CHECKSUM_HW GSO problems.")

This leads to wrong TCP checksum.

Simply use csum_fold() to support 32bit packet lengthes.

oldlen name is a bit misleading, as it is the contribution
of skb->len on the input skb TCP checksum. I added a comment
to clarify this point.

Fixes: 09f3d1a3a52c ("ipv6/gso: remove temporary HBH/jumbo header")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexander Duyck <alexanderduyck@fb.com>
---
 net/ipv4/tcp_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 45dda788938704c3f762256266d9ea29b6ded4a5..5a1a163b2d859696df8f204b50e3fc76c14b64e9 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -75,7 +75,8 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	if (!pskb_may_pull(skb, thlen))
 		goto out;
 
-	oldlen = (u16)~skb->len;
+	/* Contribution of skb->len in current TCP checksum */
+	oldlen = (__force u32)csum_fold((__force __wsum)skb->len);
 	__skb_pull(skb, thlen);
 
 	mss = skb_shinfo(skb)->gso_size;
-- 
2.41.0.rc0.172.g3f132b7071-goog


