Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7CD4935DA
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 08:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352236AbiASHxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 02:53:13 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:38506
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352196AbiASHxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 02:53:09 -0500
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 6077F3F323
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 07:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642578788;
        bh=OSgZIsl6KSiVLFhGjCsmJG0C27mMplYwxlAMHo9H3Hk=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=tsu6/141bd5ZU9kliqnn43n9NcWILUIUArk75RTHVkwpVy10EbJ4b1VU5lOUvJEkH
         KQG8miHroWX53bnSSM3AdPrASmwAF7q9uk3DyoTYYHFyRJkBAYJ+6lJjbJixidWa8/
         oLqO3zHKJJat3Qs/ETA3KwiaBi4cHso7r//YiqyJLwmtV0gC2AHlzjBJac3rgsWUxZ
         r6WWi0dBcV/oBtr92cWtm6rPe5qlzZxjc56054HsLXhCEzyDtpmDRfv536+be6PgaU
         hBDBJIwFvYf/5gvxVJL4e9lQSZbnuM8Xgy//w287qMnxIs30kxfY0ADI6u555rFxoh
         hbEM6dpC7aTuQ==
Received: by mail-ed1-f70.google.com with SMTP id cf15-20020a0564020b8f00b0040284b671c6so1447616edb.22
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 23:53:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OSgZIsl6KSiVLFhGjCsmJG0C27mMplYwxlAMHo9H3Hk=;
        b=wPkH2FsASr7W2FPrUL3HJ2w4u3M8LpZB1Apnt8MVp+tQiNGzINbwY8tIl8RL+qdxV2
         fK/TRTzrGli16W9ixQwKUgW3PdgQgwyXkg+fhWoSdnnPj1JttdCiAXxqOwBZETjBqXtl
         WmQQsV3YBr5MEZbQ/TIoXpsViYaycsb8uEJMjbgOg3FIdcc1fXda3ZPdamiUMyQSHV9n
         Z6gIHTIcDs+LpiFwWiSM8pNyu/Ic5zinYQM/y6TduAMASl494jMu/t4A2Y6aR3YSk/oF
         GNiRMGjwFiGPF/it2qp9NRgWmpGoFGeeFT3NIh1964ZwCzEAbVJow1we+v2oafBmFt+c
         UZeA==
X-Gm-Message-State: AOAM531yPZ5DVUqlRkR+kzJhm/1ee6iFKa7kNdRLoRF32vZMZLZq1+gA
        xc7ZnyU8jrCUh5yhEn/kQGZIW3VUiPz9LKRQ+9RvDubLu+KuL54EXQWWC1osEfm/d4+GxZL4Vw9
        RKxVDBw0iLngYbj50aImexZz0SS4hq2JQrQ==
X-Received: by 2002:a05:6402:3591:: with SMTP id y17mr29760633edc.386.1642578787482;
        Tue, 18 Jan 2022 23:53:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx9+Xw3bqoaTUBpvw/QShf3ZRnJ6GIKmG4TS+FJXRB9XTPyk9rcHOG6g0FjU5rSXoXNUEWc/Q==
X-Received: by 2002:a05:6402:3591:: with SMTP id y17mr29760621edc.386.1642578787366;
        Tue, 18 Jan 2022 23:53:07 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id w17sm805286edr.68.2022.01.18.23.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 23:53:06 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/6] nfc: llcp: use centralized exiting of bind on errors
Date:   Wed, 19 Jan 2022 08:52:58 +0100
Message-Id: <20220119075301.7346-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220119075301.7346-1-krzysztof.kozlowski@canonical.com>
References: <20220119075301.7346-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coding style encourages centralized exiting of functions, so rewrite
llcp_sock_bind() error paths to use such pattern.  This reduces the
duplicated cleanup code, make success path visually shorter and also
cleans up the errors in proper order (in reversed way from
initialization).

No functional impact expected.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/llcp_sock.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index a1b245b399f8..60985d1834a5 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -108,21 +108,13 @@ static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 					  llcp_sock->service_name_len,
 					  GFP_KERNEL);
 	if (!llcp_sock->service_name) {
-		nfc_llcp_local_put(llcp_sock->local);
-		llcp_sock->local = NULL;
-		llcp_sock->dev = NULL;
 		ret = -ENOMEM;
-		goto put_dev;
+		goto sock_llcp_put_local;
 	}
 	llcp_sock->ssap = nfc_llcp_get_sdp_ssap(local, llcp_sock);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
-		nfc_llcp_local_put(llcp_sock->local);
-		llcp_sock->local = NULL;
-		kfree(llcp_sock->service_name);
-		llcp_sock->service_name = NULL;
-		llcp_sock->dev = NULL;
 		ret = -EADDRINUSE;
-		goto put_dev;
+		goto free_service_name;
 	}
 
 	llcp_sock->reserved_ssap = llcp_sock->ssap;
@@ -132,6 +124,19 @@ static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 	pr_debug("Socket bound to SAP %d\n", llcp_sock->ssap);
 
 	sk->sk_state = LLCP_BOUND;
+	nfc_put_device(dev);
+	release_sock(sk);
+
+	return 0;
+
+free_service_name:
+	kfree(llcp_sock->service_name);
+	llcp_sock->service_name = NULL;
+
+sock_llcp_put_local:
+	nfc_llcp_local_put(llcp_sock->local);
+	llcp_sock->local = NULL;
+	llcp_sock->dev = NULL;
 
 put_dev:
 	nfc_put_device(dev);
-- 
2.32.0

