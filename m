Return-Path: <netdev+bounces-32-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D53F36F4CCE
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 00:13:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76196280D1A
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9438DBA22;
	Tue,  2 May 2023 22:13:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F527491
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 22:13:25 +0000 (UTC)
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53E41FEE
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 15:13:19 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-3ef64d8b2b4so20708181cf.2
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 15:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683065598; x=1685657598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BQTKNZUjF1tZVGzsl9hQectj2Dnc9g2sG5AnMqu9CLU=;
        b=OWbTSLdBEIonx0WubXyoi68LxibN9qqiIEq18zR0SPzGf2GpXzGG0ioTvwRGXyOI4j
         9OnN8CvG8lJNmsuvRrUOGcXDdrbWz3Cu9Ra1eEKgDXQoOBmzpLsIo4wxU9m9fde1dHud
         3/cn/uwGw7uSb6XMjKVikXPDe4guIZj2M1mS9++QwM/9/5RKJN6tKRrr05gZPsRST4cJ
         baUuSYN2p2RrP8uSva73CPahgmNOGjQX9LJWnyDMPrHk+xvliaKe1X2LTFGZIqZDKSX4
         YNcdh/5Kap20KdMs2uaDWYORDqN77uSGBO5enEo0yzbzojzRVQ8e9ln/hoBoh+qXuJA0
         RSeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683065598; x=1685657598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BQTKNZUjF1tZVGzsl9hQectj2Dnc9g2sG5AnMqu9CLU=;
        b=M39G1HxQPW0ygGqSOU4lYMD3AbnSjWOfGqYJ+dhGFUYT91ksXLM31I6U0+4MmgHL3u
         TrY5+2YMH+oKkjme2T5fOqagBFLvcHYrDGx0OX81+mEJ1aT0n+5rlmNLIe8y/IXxG9Us
         dZa47QUiU8zMRQZM+h0F84j5cETuinj5Hb1q4zDqJD0uf1ICgwctePra1VqjrrasDEjW
         RLyzVedNpJYVkKEI6obC9IYtVY6sPP+j4USFtP8St6IPeCIyclJxyEl33AShRcsJ9Tas
         GW3F8LLhSpxxeh0Z1rDKYO0R0rhnQacdpZOk7JPJzTxsfUPiwn6OJTmd2FkJ2HLxzkog
         NDkA==
X-Gm-Message-State: AC+VfDwq2doMH2X0LE+yfrbHs03vU+miDRxMKCDSzRUi4X2TM64+6aHT
	KlsmA61gmZHY86iD3NtXr3TflfQPbNKz8w==
X-Google-Smtp-Source: ACHHUZ63BGMHjXiAVrHuMCc/6e/tbSB08gjIepr2ta3bWxOPFfmtg7lmb9Pgh+bQz+w9NyidI9l+mg==
X-Received: by 2002:ac8:7f0c:0:b0:3ef:5221:5710 with SMTP id f12-20020ac87f0c000000b003ef52215710mr29353666qtk.47.1683065598281;
        Tue, 02 May 2023 15:13:18 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id cf23-20020a05622a401700b003ef58044a4bsm10362636qtb.34.2023.05.02.15.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 15:13:17 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	tipc-discussion@lists.sourceforge.net
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Tung Nguyen <tung.q.nguyen@dektech.com.au>
Subject: [PATCHv2 net 1/3] tipc: add tipc_bearer_min_mtu to calculate min mtu
Date: Tue,  2 May 2023 18:13:13 -0400
Message-Id: <8e3827ffaf71c0636541c01f76ff3a65868433ea.1683065352.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1683065352.git.lucien.xin@gmail.com>
References: <cover.1683065352.git.lucien.xin@gmail.com>
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

v1->v2:
 - use bearer_get() to avoid the open code.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
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


