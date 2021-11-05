Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41849445D90
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 02:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhKEBwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 21:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbhKEBwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 21:52:40 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACE9C06120B
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 18:50:00 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d24so11421602wra.0
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 18:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+ZX3pYJ1I/7ebtQwANMInsRgOc/yS6aTn3F+Fk+PiwA=;
        b=GsPk6IXOjNs0SPvXxuznhJg1YhpoxbWiSH6pSRXi8P/R0//AeMACHltL4qoPIRMz8P
         IrFp99b1IUUs5OTWeGsqg4lbJU6kkaOwjhbdS7M42pbe7et5jbVcyfJjSRJEOrwH1AeY
         yqfRuU3xh5UbfkIRxG3+1JCXO4+6VYi7pu+EE92plfdxuV37Eh9vRsu/AvhaUmyM9R27
         Vq1tmG6Vedja2BG0lsHyvSdEoOUZaaiXg2G02JHIWrQaeaW9zL10dRKuD4/SM5moGXGn
         maJY1f/+RHr5ekxuV7mYJq1dC4Yd5sS6HriL/BBrMrbBWP4y+i0MmG6sgBgINbT0iw9O
         q4SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+ZX3pYJ1I/7ebtQwANMInsRgOc/yS6aTn3F+Fk+PiwA=;
        b=fXCRLSyzLRyQuwlAJ4lD422kIwuUc+fFC3wBF8uzhzwD1EmRrBogj3ULribw5a3YgO
         zop1gAq7n8aEmVJ7rlauyFbHaDR+tXCBOgNwG0BFileVsjq3uCMDWePMIIPl4JWaqBX8
         46Yr/qg2V4gjMkvx9Qw9FFPewUFIAe2wl9JTPX5oEjMcc/i7ckE2kfAqc3ff1xkM+tb1
         7SxwvPPpk24oh9SaPlBIi7ahLCQUmL3teVrTkRoiQdIKn9OmZvm+xO4Yt94uepzpheAq
         Dax5qjgbS75cmwIT03RMURf+Iz+4cZzgHlIYjLRGK8kJlng0jWbrVGKTfxG5Szk+OcJJ
         VtVQ==
X-Gm-Message-State: AOAM5337Q5CgEf1NHTiSLW1ZyeW8bPIZkcmVksz87JOI+FucWP1InILR
        XMX9P11WdYSN4/2MdZ7BTST9vw==
X-Google-Smtp-Source: ABdhPJyTYh3Ig4SsaG9/lmxp6FpLNLdjOI6iWi6OA7zO5KbzwlTFLcjrRe7t+hJwW6ea2dbTESgj3g==
X-Received: by 2002:a5d:4107:: with SMTP id l7mr51155903wrp.209.1636076998744;
        Thu, 04 Nov 2021 18:49:58 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c6sm7202421wmq.46.2021.11.04.18.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 18:49:58 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 3/5] tcp/md5: Alloc tcp_md5sig_pool only in setsockopt()
Date:   Fri,  5 Nov 2021 01:49:51 +0000
Message-Id: <20211105014953.972946-4-dima@arista.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211105014953.972946-1-dima@arista.com>
References: <20211105014953.972946-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Besides setsockopt() tcp_md5_do_add() can be called from
tcp_v4_syn_recv_sock()/tcp_v6_syn_recv_sock().
If it is called from there, tcp_md5_do_lookup() has succeeded, which
means that md5 static key is enabled. Which makes this
tcp_alloc_md5sig_pool() call to be nop for any caller, but
tcp_v4_parse_md5_keys()/tcp_v6_parse_md5_keys().

tcp_alloc_md5sig_pool() can sleep if tcp_md5sig_pool hasn't been
populated, so if anything changes tcp_md5_do_add() may start sleeping in
atomic context.

Let's leave the check for tcp_md5sig_pool in tcp_md5_do_add(), but
intentionally call tcp_alloc_md5sig_pool() only from sleepable
setsockopt() syscall context.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/ipv4/tcp_ipv4.c | 5 ++++-
 net/ipv6/tcp_ipv6.c | 3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 13d868c43284..6a8ff9ab1cbc 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1190,7 +1190,7 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
 	if (!key)
 		return -ENOMEM;
-	if (!tcp_alloc_md5sig_pool()) {
+	if (WARN_ON_ONCE(!tcp_md5sig_pool_ready())) {
 		sock_kfree_s(sk, key, sizeof(*key));
 		return -ENOMEM;
 	}
@@ -1294,6 +1294,9 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 	if (cmd.tcpm_keylen > TCP_MD5SIG_MAXKEYLEN)
 		return -EINVAL;
 
+	if (!tcp_alloc_md5sig_pool())
+		return -ENOMEM;
+
 	return tcp_md5_do_add(sk, addr, AF_INET, prefixlen, l3index, flags,
 			      cmd.tcpm_key, cmd.tcpm_keylen, GFP_KERNEL);
 }
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 2cc9b0e53ad1..3af13bd6fed0 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -654,6 +654,9 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 	if (cmd.tcpm_keylen > TCP_MD5SIG_MAXKEYLEN)
 		return -EINVAL;
 
+	if (!tcp_alloc_md5sig_pool())
+		return -ENOMEM;
+
 	if (ipv6_addr_v4mapped(&sin6->sin6_addr))
 		return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin6->sin6_addr.s6_addr32[3],
 				      AF_INET, prefixlen, l3index, flags,
-- 
2.33.1

