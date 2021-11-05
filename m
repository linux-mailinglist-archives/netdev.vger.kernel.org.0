Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D800445D8D
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 02:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhKEBwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 21:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbhKEBwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 21:52:37 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA54DC061203
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 18:49:58 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id j128-20020a1c2386000000b003301a98dd62so8511501wmj.5
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 18:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dNwZbIKE8lWneBjLIglBIBwD0K8M5nQ1YwG5fYxV9yQ=;
        b=S6873E77/TJAfAk2C/saKYt/6NEm0CteTcVWlSBIfx1IWNTD7Q8bjsrowiXO88I7S+
         LEH+nrIQC8MQCABpuao3qyBTNN9A278yGM3a1irACwfOGwcc1q+uIqfLfRACZq0tiJzk
         ovBpHKT6QjjaXbDQVDrOPug+/QiRYxUMaM6bdh3UHjaW1FekQyY9xh4+TT6CJHnQs/zO
         H5mJcJFblppVgwfKrU81pamfcy160SDTTyPFBxLoMUtXfhxncvJK1zWzJuWdiBhCelIz
         ahUuGr5fxFkbdaBsh0NRLVDKc13euXGU3uqc4pR8j3wHmfMLsY5I/FhfMNxBYtWo42JB
         0xzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dNwZbIKE8lWneBjLIglBIBwD0K8M5nQ1YwG5fYxV9yQ=;
        b=5mVRdRni1CGPK5aj3NQ1VgLaCg5yNZbnSHlW1EVDX1F4Dy5n+bZFifeU4+/Kqtmjsx
         VKqM6jz2tSzjQo2g+5rnWl2Kxa5+of8qBxaZ4YjTiu3C1KNqnGRJ0+2t1jRMMclaI5vF
         XeRy1LD+hFqqmR/1Yx73nQ1eBpHS5qbzkZzf4fhP31xFJN7mAyW0dRbGmrhrDut8vU+2
         g17kEf4GzC3VBU3fYIJzq6a4sL0sXebzjLofmPFWCjWKyuBTgItGpShpRcxZlBeyZSEy
         Ja4CPgEDR0oPrJg6SHwEfdg8Kv7q7w7sENuyewzOcic3JjpCU07eWcJ5rHGR5H2UUD94
         Ac/A==
X-Gm-Message-State: AOAM533P1yIPYDxqDcLWmpcFCwv3r+MrXVk/zVugGmbNCTjTR7RAh+D0
        23Oec6/eDcI9Ws8WSAQm1mA6Yg==
X-Google-Smtp-Source: ABdhPJyMGEIoev86k8g8uhwR4iMxEaS98FgaftBQIKbdzzTI4hjx8cTbU0bLfu9OlD5UJTes221/6A==
X-Received: by 2002:a05:600c:4f0f:: with SMTP id l15mr9170724wmq.25.1636076997577;
        Thu, 04 Nov 2021 18:49:57 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c6sm7202421wmq.46.2021.11.04.18.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 18:49:57 -0700 (PDT)
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
Subject: [PATCH 2/5] tcp/md5: Don't leak ahash in OOM
Date:   Fri,  5 Nov 2021 01:49:50 +0000
Message-Id: <20211105014953.972946-3-dima@arista.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211105014953.972946-1-dima@arista.com>
References: <20211105014953.972946-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In quite unlikely scenario when __tcp_alloc_md5sig_pool() succeeded in
crypto_alloc_ahash(), but later failed to allocate per-cpu request or
scratch area ahash will be leaked.
In theory it can happen multiple times in OOM condition for every
setsockopt(TCP_MD5SIG{,_EXT}).

Add a clean-up path to free ahash.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/ipv4/tcp.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c0856a6af9f5..eb478028b1ea 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4276,15 +4276,13 @@ static void __tcp_alloc_md5sig_pool(void)
 					       GFP_KERNEL,
 					       cpu_to_node(cpu));
 			if (!scratch)
-				return;
+				goto out_free;
 			per_cpu(tcp_md5sig_pool, cpu).scratch = scratch;
 		}
-		if (per_cpu(tcp_md5sig_pool, cpu).md5_req)
-			continue;
 
 		req = ahash_request_alloc(hash, GFP_KERNEL);
 		if (!req)
-			return;
+			goto out_free;
 
 		ahash_request_set_callback(req, 0, NULL, NULL);
 
@@ -4295,6 +4293,16 @@ static void __tcp_alloc_md5sig_pool(void)
 	 */
 	smp_wmb();
 	tcp_md5sig_pool_populated = true;
+	return;
+
+out_free:
+	for_each_possible_cpu(cpu) {
+		if (per_cpu(tcp_md5sig_pool, cpu).md5_req == NULL)
+			break;
+		ahash_request_free(per_cpu(tcp_md5sig_pool, cpu).md5_req);
+		per_cpu(tcp_md5sig_pool, cpu).md5_req = NULL;
+	}
+	crypto_free_ahash(hash);
 }
 
 bool tcp_alloc_md5sig_pool(void)
-- 
2.33.1

