Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57339616F76
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbiKBVOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiKBVOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:14:03 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06489CE7
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:14:00 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id j15so87857wrq.3
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 14:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mqJckVrQg7Ntll0dZ6IL+1cA9p9Fyu8BflY8RBnW50o=;
        b=Ev2+grcy4sVBMYH5Elr6o9GmomnMLZkIfCvEtFjRHVabXHNCB/jkDZvul+CUXWw4HU
         gK4/A7o5m4dTUOK7vrjKMfsJ68hlP/OHdgXyyPyYPTKoxyvtMTLcwdt25ibf9m++U0eb
         MMuqn1/CH8QcevlEX3HKsYmpHGBxaRCEVwwF95DuYhuB+Ypo6EybUldqxtdpAHGNxCTq
         sy8dT/zBrICqWFGYq1min4dLWGXpYno/3dawfXwNOPTsOItMiZGk6OiPBc4iukaFIbe8
         DdrRwYX193RPlLGB6l3MFFtL9RJY0pTuaeyhyspS2Tcx6blx8ZFeeMMgNC6Tb6ruEKHh
         qaWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mqJckVrQg7Ntll0dZ6IL+1cA9p9Fyu8BflY8RBnW50o=;
        b=XIddiUQ3hdSW3AAt82jEyOlAqREuptSNqgdR/yNSVFfRV/gRkAG+bzYUro/VFF6/L/
         EjRXxCtGe6ctmapxXoB3RiIJZGDNSirxMWxsUEu1nX2fNSG4Ria9tY2zoj/zh/DBKxgV
         TWFFXMPNdx1ahaL06NhA7zXHkLRQl9iZsX9DxTwssk/DHqKWgWE4w7xBgWKkHrHh/C/7
         32wmYMf3fQ7mqO7zMWq+UQoqXWWBvos3CKujeUO8Y8y93HOvx7Caspb3e5udHoCZFpdD
         /O09mz9LwZPCjLbVpvlS61JVM3RrwavycFY+bYUgQ2tYOo1CBvkFw/jmGdwvbpfwiXE1
         DEKw==
X-Gm-Message-State: ACrzQf0pHcWPhdRSK1lQWqX00Psv0dY2C2bzUtvcpOTNwHZ0yuyNTWAw
        dyX8fyOLY95qge7yEO/QYEtfiw==
X-Google-Smtp-Source: AMsMyM7qno6C26hDyGI9a03/SiPW07MZ14SsbCw1GZZz+hfoB584vF0zSvPUU3DcNdMyFReSAuoHkA==
X-Received: by 2002:a5d:5410:0:b0:236:fe1:bb74 with SMTP id g16-20020a5d5410000000b002360fe1bb74mr16433511wrv.512.1667423638531;
        Wed, 02 Nov 2022 14:13:58 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id cc6-20020a5d5c06000000b002364835caacsm14179851wrb.112.2022.11.02.14.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 14:13:58 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Subject: [PATCH 1/2] net/tcp: Separate tcp_md5sig_info allocation into tcp_md5sig_info_add()
Date:   Wed,  2 Nov 2022 21:13:49 +0000
Message-Id: <20221102211350.625011-2-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102211350.625011-1-dima@arista.com>
References: <20221102211350.625011-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to allocate tcp_md5sig_info, that will help later to
do/allocate things when info allocated, once per socket.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/ipv4/tcp_ipv4.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 87d440f47a70..fae80b1a1796 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1172,6 +1172,24 @@ struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
 }
 EXPORT_SYMBOL(tcp_v4_md5_lookup);
 
+static int tcp_md5sig_info_add(struct sock *sk, gfp_t gfp)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_md5sig_info *md5sig;
+
+	if (rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk)))
+		return 0;
+
+	md5sig = kmalloc(sizeof(*md5sig), gfp);
+	if (!md5sig)
+		return -ENOMEM;
+
+	sk_gso_disable(sk);
+	INIT_HLIST_HEAD(&md5sig->head);
+	rcu_assign_pointer(tp->md5sig_info, md5sig);
+	return 0;
+}
+
 /* This can be called on a newly created socket, from other files */
 int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		   int family, u8 prefixlen, int l3index, u8 flags,
@@ -1202,17 +1220,11 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		return 0;
 	}
 
+	if (tcp_md5sig_info_add(sk, gfp))
+		return -ENOMEM;
+
 	md5sig = rcu_dereference_protected(tp->md5sig_info,
 					   lockdep_sock_is_held(sk));
-	if (!md5sig) {
-		md5sig = kmalloc(sizeof(*md5sig), gfp);
-		if (!md5sig)
-			return -ENOMEM;
-
-		sk_gso_disable(sk);
-		INIT_HLIST_HEAD(&md5sig->head);
-		rcu_assign_pointer(tp->md5sig_info, md5sig);
-	}
 
 	key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
 	if (!key)
-- 
2.38.1

