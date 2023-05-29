Return-Path: <netdev+bounces-6087-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DD84714C7F
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:52:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1D59280D65
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 14:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E47D78C03;
	Mon, 29 May 2023 14:52:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74346ADE
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 14:52:18 +0000 (UTC)
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C976C4
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:52:16 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id d75a77b69052e-3f6a3a76665so23228521cf.1
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685371935; x=1687963935;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xBCgv7WbMymKJnkbMIchawS9T+PNFDhr0/gk+2wKVRo=;
        b=i+KCjm5IaJQXMNNARuPfp14pJSZ9DWx3gdJ9JXGYShBpZKJDtpGosTPDjQgJav9scs
         MOC7qg5KdXER8mB70bgDp2cQU0RjVmP8sKBkfBt2dJQr0e78BdVjWoPKmKLsWilrKE33
         G4208AWPJGvALZDlEtuVMA5SaxF3ywTDQp8PjemTzvqzGP3y8hp4NqWflwhZtOzUWdLr
         kvv6QLV/NhS5vg/KquMX60jzd+Wq96j3qik0t5s6HDyx5tZcwBIrT90geOFrPVWsFspI
         imQGS20nFDEMbEb4LGe4LRZXTIPjQtnEHBMnybrG3kvs21tRVug6/7n7bsNyVOiIkYC/
         ne6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685371935; x=1687963935;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xBCgv7WbMymKJnkbMIchawS9T+PNFDhr0/gk+2wKVRo=;
        b=fNEOeqdg/S8VElTNl4R5G9FQlspX9ogDnDHT/XOw2qpDkQ+w6j0pC7ZqLNauux7a8U
         GMODg/KDRlModAtBDlM3gdEr1GdNIEChASqnXH8nwkrx4rQhSmexWTPIxsx0eoL/mAqQ
         oLqh7SZ8jwOlkiZ/v/Wi9ugItCfouvoQtX2q5H2qr/2M1V6vdolKuZyKUJ+RWhSLUCUL
         Mxn9VvLpnRvOM8rbMT3Lhvs9r2CBAhqUTF69yqhQ6qhKVSHDMz4Z2GBUt6i1OdW/tXkT
         XUduXXAXM7gEB0I82TqjCfG6itebqCWFX+1uZVmDbAX37r+nihJfyp56F6axvJvHkZWj
         rv0w==
X-Gm-Message-State: AC+VfDyFa3zfjz5NH1s6o7HAY9FsNgGxZ1lRjhqk73P/8AbBpUkh+SM/
	OzrNvD+wXJOxwDctr0q+8B9CjgzrEmM=
X-Google-Smtp-Source: ACHHUZ6rr8bThFmx3E9F+9SwIPyp2OwUlsVkYY3J+P1ZIH7Ws17BCndcgvQV32Cq2JkOyg7vObt38w==
X-Received: by 2002:ac8:574a:0:b0:3f8:25c:c434 with SMTP id 10-20020ac8574a000000b003f8025cc434mr7635413qtx.19.1685371935007;
        Mon, 29 May 2023 07:52:15 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id ey6-20020a05622a4c0600b003f6bdc221e6sm3916109qtb.53.2023.05.29.07.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 07:52:14 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	tipc-discussion@lists.sourceforge.net
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Tung Nguyen <tung.q.nguyen@dektech.com.au>
Subject: [PATCH net-next] tipc: delete tipc_mtu_bad from tipc_udp_enable
Date: Mon, 29 May 2023 10:52:13 -0400
Message-Id: <282f1f5cc40e6cad385aa1c60569e6c5b70e2fb3.1685371933.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
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

Since commit a4dfa72d0acd ("tipc: set default MTU for UDP media"), it's
been no longer using dev->mtu for b->mtu, and the issue described in
commit 3de81b758853 ("tipc: check minimum bearer MTU") doesn't exist
in UDP bearer any more.

Besides, dev->mtu can still be changed to a too small mtu after the UDP
bearer is created even with tipc_mtu_bad() check in tipc_udp_enable().
Note that NETDEV_CHANGEMTU event processing in tipc_l2_device_event()
doesn't really work for UDP bearer.

So this patch deletes the unnecessary tipc_mtu_bad from tipc_udp_enable.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/bearer.c    | 4 ++--
 net/tipc/bearer.h    | 4 ++--
 net/tipc/udp_media.c | 4 ----
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 53881406e200..114140c49108 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -431,7 +431,7 @@ int tipc_enable_l2_media(struct net *net, struct tipc_bearer *b,
 	dev = dev_get_by_name(net, dev_name);
 	if (!dev)
 		return -ENODEV;
-	if (tipc_mtu_bad(dev, 0)) {
+	if (tipc_mtu_bad(dev)) {
 		dev_put(dev);
 		return -EINVAL;
 	}
@@ -708,7 +708,7 @@ static int tipc_l2_device_event(struct notifier_block *nb, unsigned long evt,
 		test_and_set_bit_lock(0, &b->up);
 		break;
 	case NETDEV_CHANGEMTU:
-		if (tipc_mtu_bad(dev, 0)) {
+		if (tipc_mtu_bad(dev)) {
 			bearer_disable(net, b);
 			break;
 		}
diff --git a/net/tipc/bearer.h b/net/tipc/bearer.h
index bd0cc5c287ef..1ee60649bd17 100644
--- a/net/tipc/bearer.h
+++ b/net/tipc/bearer.h
@@ -257,9 +257,9 @@ static inline void tipc_loopback_trace(struct net *net,
 }
 
 /* check if device MTU is too low for tipc headers */
-static inline bool tipc_mtu_bad(struct net_device *dev, unsigned int reserve)
+static inline bool tipc_mtu_bad(struct net_device *dev)
 {
-	if (dev->mtu >= TIPC_MIN_BEARER_MTU + reserve)
+	if (dev->mtu >= TIPC_MIN_BEARER_MTU)
 		return false;
 	netdev_warn(dev, "MTU too low for tipc bearer\n");
 	return true;
diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index 0a85244fd618..926232557e77 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -739,10 +739,6 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
 		udp_conf.use_udp_checksums = false;
 		ub->ifindex = dev->ifindex;
 		b->encap_hlen = sizeof(struct iphdr) + sizeof(struct udphdr);
-		if (tipc_mtu_bad(dev, b->encap_hlen)) {
-			err = -EINVAL;
-			goto err;
-		}
 		b->mtu = b->media->mtu;
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (local.proto == htons(ETH_P_IPV6)) {
-- 
2.39.1


