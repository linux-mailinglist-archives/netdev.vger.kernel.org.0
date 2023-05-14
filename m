Return-Path: <netdev+bounces-2437-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18E25701F53
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 21:52:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 226751C209C2
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 19:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A0F2BA45;
	Sun, 14 May 2023 19:52:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DBCBA34
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 19:52:36 +0000 (UTC)
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635FA199
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 12:52:33 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id af79cd13be357-75773a7bd66so892468485a.1
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 12:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684093952; x=1686685952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N2YNf79EHZ/wWVYoLYruhucyvo6J0n3PYGo32c70cl8=;
        b=I76ZJyyjVOjLuaPIid/NIl3DuaVtujV5dgh9xjm1ui12zreo28ge11Zex/iCjqYYLK
         A6EYAQEK2EX/b4ruY/Xb3Fvxp4cL/6nHm72Xl0pnlAimsY2OpeuHuzaXRnsFGQAuyXcb
         4BAEV4f2YcxbAzW57TpQeK0PgKZ8gUxWEN7NstA0HEfb9/aDL0MnhxmBx8Kcc0dx1qhu
         5wcBK0y2uAGfCLEbuts8d1ud8/sXTlr7MtOLGE1kAWp9R+veatEEH2sk3D6b3howGMLo
         /CgV9nbZ5DoCwDtMln9tRVwaE2NkTeFDlQ067wfQN0RYsKa29OSl1pGfFFuuTvFV8LNQ
         LbOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684093952; x=1686685952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N2YNf79EHZ/wWVYoLYruhucyvo6J0n3PYGo32c70cl8=;
        b=KNRXYaW2vUIf+Ji9Wu3Z2ZK9Zow4m5IuihJjmr7be8PUYjZOMBLKPTBsy9rwHEzPxw
         uqNJT8fqp4c/3NP2ZvE6b5U5t1NftgPyduh0sl9JOtZH0PVlTOQ5zizzTu77TK9eIRLG
         YEo62OErsqHhCOa6WcYbxwfPkVQRHeudYPcWsQfFuETxH5sowvYPMV512Rt4aE6aFnuQ
         KpufkXpz85uNDUsJ8WFuBp1nLlp3rB6nzEZ3DE8fZI0QDN039ftgq3SQfg4q86GlHAEV
         17bwsz/jreJHrDZl8DfIYYJ8vbswK0Yd2yJKIhXoX3ObD8nPeU1XOFTrKvfnmX7NOi7K
         KX7A==
X-Gm-Message-State: AC+VfDwMTK9OdGuAq/oImS0Mcbo8De/DOtyTR70FPNzELphUCSQNaZJZ
	wIINbR2DOMiCwiv6Ffb/zRuP62wtO7N+ew==
X-Google-Smtp-Source: ACHHUZ4j4WTwa7ZaOAUJ0hHBs0VrbljPC857FzHqp1V/spauKkMqN2byGgcoH8QYOgVH5o0UZuIXbQ==
X-Received: by 2002:a05:622a:4d2:b0:3f4:dec2:76cc with SMTP id q18-20020a05622a04d200b003f4dec276ccmr27493816qtx.49.1684093952289;
        Sun, 14 May 2023 12:52:32 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id fa11-20020a05622a4ccb00b003f517e1fed2sm1069444qtb.15.2023.05.14.12.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 12:52:31 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	tipc-discussion@lists.sourceforge.net
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Tung Nguyen <tung.q.nguyen@dektech.com.au>
Subject: [PATCHv3 net 1/3] tipc: add tipc_bearer_min_mtu to calculate min mtu
Date: Sun, 14 May 2023 15:52:27 -0400
Message-Id: <580bc5fa36dd1454a5c111e5490907521d63d060.1684093873.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1684093873.git.lucien.xin@gmail.com>
References: <cover.1684093873.git.lucien.xin@gmail.com>
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

As different media may requires different min mtu, and even the
same media with different net family requires different min mtu,
add tipc_bearer_min_mtu() to calculate min mtu accordingly.

This API will be used to check the new mtu when doing the link
mtu negotiation in the next patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
v2:
- use bearer_get() to avoid the open code.
v3:
- move the change history under ---, as Tung suggested.
---
 net/tipc/bearer.c    | 13 +++++++++++++
 net/tipc/bearer.h    |  3 +++
 net/tipc/udp_media.c |  5 +++--
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 35cac7733fd3..0e9a29e1536b 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -541,6 +541,19 @@ int tipc_bearer_mtu(struct net *net, u32 bearer_id)
 	return mtu;
 }
 
+int tipc_bearer_min_mtu(struct net *net, u32 bearer_id)
+{
+	int mtu = TIPC_MIN_BEARER_MTU;
+	struct tipc_bearer *b;
+
+	rcu_read_lock();
+	b = bearer_get(net, bearer_id);
+	if (b)
+		mtu += b->encap_hlen;
+	rcu_read_unlock();
+	return mtu;
+}
+
 /* tipc_bearer_xmit_skb - sends buffer to destination over bearer
  */
 void tipc_bearer_xmit_skb(struct net *net, u32 bearer_id,
diff --git a/net/tipc/bearer.h b/net/tipc/bearer.h
index 490ad6e5f7a3..bd0cc5c287ef 100644
--- a/net/tipc/bearer.h
+++ b/net/tipc/bearer.h
@@ -146,6 +146,7 @@ struct tipc_media {
  * @identity: array index of this bearer within TIPC bearer array
  * @disc: ptr to link setup request
  * @net_plane: network plane ('A' through 'H') currently associated with bearer
+ * @encap_hlen: encap headers length
  * @up: bearer up flag (bit 0)
  * @refcnt: tipc_bearer reference counter
  *
@@ -170,6 +171,7 @@ struct tipc_bearer {
 	u32 identity;
 	struct tipc_discoverer *disc;
 	char net_plane;
+	u16 encap_hlen;
 	unsigned long up;
 	refcount_t refcnt;
 };
@@ -232,6 +234,7 @@ int tipc_bearer_setup(void);
 void tipc_bearer_cleanup(void);
 void tipc_bearer_stop(struct net *net);
 int tipc_bearer_mtu(struct net *net, u32 bearer_id);
+int tipc_bearer_min_mtu(struct net *net, u32 bearer_id);
 bool tipc_bearer_bcast_support(struct net *net, u32 bearer_id);
 void tipc_bearer_xmit_skb(struct net *net, u32 bearer_id,
 			  struct sk_buff *skb,
diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index c2bb818704c8..0a85244fd618 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -738,8 +738,8 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
 			udp_conf.local_ip.s_addr = local.ipv4.s_addr;
 		udp_conf.use_udp_checksums = false;
 		ub->ifindex = dev->ifindex;
-		if (tipc_mtu_bad(dev, sizeof(struct iphdr) +
-				      sizeof(struct udphdr))) {
+		b->encap_hlen = sizeof(struct iphdr) + sizeof(struct udphdr);
+		if (tipc_mtu_bad(dev, b->encap_hlen)) {
 			err = -EINVAL;
 			goto err;
 		}
@@ -760,6 +760,7 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
 		else
 			udp_conf.local_ip6 = local.ipv6;
 		ub->ifindex = dev->ifindex;
+		b->encap_hlen = sizeof(struct ipv6hdr) + sizeof(struct udphdr);
 		b->mtu = 1280;
 #endif
 	} else {
-- 
2.39.1


