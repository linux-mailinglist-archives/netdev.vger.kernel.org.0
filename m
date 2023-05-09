Return-Path: <netdev+bounces-1273-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DE3E6FD27D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 00:17:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E78A1C20ADC
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 22:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C56CD19E4E;
	Tue,  9 May 2023 22:16:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B654319E4B
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 22:16:22 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D36E3AA6
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:16:21 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f475366514so729425e9.2
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 15:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1683670580; x=1686262580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a/2L5rqcnCY6pJiEs4sYnqk/1S9TSMsv5FXuRy9b2gE=;
        b=beOko3byXbdOnNTmosIZ66QrQuc7sGYZ1Hb4jRKE0TRj+CwIdJ1NsLQPcPJY2tA3yd
         iZtEbrPF2PiOhDJ+SGX8Q/eMIFsJW4MpBdKyifrhpNZn40mbfMUqKRdfKKYpCXPlNcGB
         IuEkSj9NRDVLKmrBC4j3z0xCegPt/y3Lmkr/oXFQvIdwygSyEdR4M4CR5Kjm5A93rqKy
         F5EDPsDFYgKUwVOa7e/CSxma6pFk3rPUXgLeMMblSqHBC6CYMzgwM9qU406EYwk6X8LC
         FV6Mksp9h48SK4X1mBgzZo2XFPDz3Fnb4NLdsKzN0f9c9cRHFuPHzWF9Sed2w2vrZBTC
         yopQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683670580; x=1686262580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a/2L5rqcnCY6pJiEs4sYnqk/1S9TSMsv5FXuRy9b2gE=;
        b=LqF9JLYAUpbVa6ca6X11MbrhuqVQ8Eqtp9OSzF9vcU397KdJLTvkyXa1mKjRhH8XId
         kGUJGyq2UlY9/HC1T9e2wwLesovHz+M73jK8t1qEcBElqeXW7NCEkbWVg/16vxp0pofF
         4kF9m4f/NtN5eBbdPAhSWQ0oPe/Or01R6o5uFHH3n+4dNT9BIxolD8yR+sWLuUfow7cx
         nxZdF345ptJ6JQMFhIg9QVBrFXgCNX+KO8T40dXlX8d4xKvSbccN8mH6jsWgM59u2rdl
         rRIiCOFKN+wYfMTsJ/owCWmKhxIE7W4NF/6no+4if8fA0CcUw/UC/2v9j6rJBX8lkrXk
         MsFw==
X-Gm-Message-State: AC+VfDyZfhhCKY+G01k2u31TJnjQT/FSruHsw7iGzBikTSoPkCQLlwTd
	fcrUt16uLCEuORHuQZoqK5okug==
X-Google-Smtp-Source: ACHHUZ44MM2LCMZLgMRP8Z+AX7U/DZPqWqAdrTIXXH9RoyWVD5BYoYHRnM3KqsGHM7ylGeMXxwjNVQ==
X-Received: by 2002:a1c:f711:0:b0:3ee:775:c573 with SMTP id v17-20020a1cf711000000b003ee0775c573mr10201854wmh.20.1683670579827;
        Tue, 09 May 2023 15:16:19 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id t25-20020a7bc3d9000000b003f42d3111b8sm2052888wmj.30.2023.05.09.15.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 15:16:19 -0700 (PDT)
From: Dmitry Safonov <dima@arista.com>
To: linux-kernel@vger.kernel.org,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <dima@arista.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>,
	netdev@vger.kernel.org
Subject: [RFC 4/5] net/tcp-md5: Don't send RST if key (dis)appeared
Date: Tue,  9 May 2023 23:16:07 +0100
Message-Id: <20230509221608.2569333-5-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230509221608.2569333-1-dima@arista.com>
References: <20230509221608.2569333-1-dima@arista.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Seems cheap at this place as both key and hash_location were looked up
until now.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/ipv4/tcp_ipv4.c | 10 ++++++++++
 net/ipv6/tcp_ipv6.c |  8 ++++++++
 2 files changed, 18 insertions(+)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f5b870943dcb..d94cd5e70d58 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -686,6 +686,16 @@ static bool tcp_v4_md5_sign_reset(struct net *net, const struct sock *sk,
 		l3index = tcp_v4_sdif(skb) ? inet_iif(skb) : 0;
 		addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
 		key = tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
+		/* This segment should have been already verified by
+		 * tcp_inbound_md5_hash(). But that might raced with userspace
+		 * adding or deleting keys. So, follow the logic of
+		 * tcp_inbound_md5_hash() and avoid replying with TCP-MD5 sign
+		 * on non-signed segments and vice-versa.
+		 */
+		if (unlikely(!!key != !!hash_location)) {
+			rcu_read_unlock();
+			return true;
+		}
 	} else if (hash_location) {
 		const union tcp_md5_addr *addr;
 		int sdif = tcp_v4_sdif(skb);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 3756a43367a3..498dfa194b8b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -993,6 +993,14 @@ static int tcp_v6_md5_lookup_reset_key(struct net *net, const struct sock *sk,
 		 */
 		l3index = tcp_v6_sdif(skb) ? tcp_v6_iif_l3_slave(skb) : 0;
 		*key = tcp_v6_md5_do_lookup(sk, &ipv6h->saddr, l3index);
+		/* This segment should have been already verified by
+		 * tcp_inbound_md5_hash(). But that might raced with userspace
+		 * adding or deleting keys. So, follow the logic of
+		 * tcp_inbound_md5_hash() and avoid replying with TCP-MD5 sign
+		 * on non-signed segments and vice-versa.
+		 */
+		if (unlikely(!!*key != !!hash_location))
+			return -ENOKEY;
 	} else if (hash_location) {
 		int dif = tcp_v6_iif_l3_slave(skb);
 		int sdif = tcp_v6_sdif(skb);
-- 
2.40.0


