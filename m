Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D0D4CAEA7
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239281AbiCBT0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238968AbiCBT0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:26:18 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902A7C12CA
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:25:34 -0800 (PST)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 509133F60D
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 19:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646249133;
        bh=XW443xLXNMd7fKnAwsj5MsweNUN/P9g1RwySZfWsL7A=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=CoWC2CRVBw5eVtEJaGeO7G7K9OT1T57bup82Nx394K6Ru+mm25uq9SwpBnpyDPGzR
         GXEH4mSru/px83ABd44dGfLi4oPYWzys9X7M4TGgBWTkEAgvkuOrLHTk0ju3w3u1Qh
         JfOleiEZg9cCt5qvqRGXFKsqju7S+1oymCIp603Y+XdarJ7wbMqsXt7mL6W8wM9NWb
         N4d3JWxW6kWwXRE9tQFjUX43XKZ7Efod5Ir2SxhcOTAGd2pfnAScjwfjd9ych2BFeX
         +rDHH2ju3E4hYo7Qmq2Q+Djp0EX6ZtFdgQba7EVC52LVVtXY3xvFcj4RQs9l6KWMb7
         VbajMnazn6xmQ==
Received: by mail-ej1-f71.google.com with SMTP id x2-20020a1709065ac200b006d9b316257fso1489668ejs.12
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 11:25:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XW443xLXNMd7fKnAwsj5MsweNUN/P9g1RwySZfWsL7A=;
        b=YmHUnxiQkvxeYBkraOZLVHimzIolWSBFWR0PoxsOVpu14kYFuHxbOadVMeVwuO3NTX
         q0txU/VZJtnO/6ZTnmIidvvMnDQvgALRrjuSNh8KbCDyLQUgxpHjFixbbYSE+3VU00xl
         O/vs01CcabgWSo7SMABSJjxFP1nNw0YMgfnkuKgRVG3oyiwMlBMqViZ+I+5ct9d2hPOe
         /Q+u/EUhMTdlqQoaH/RKgz78gbHyQ1+kO36HwGkOfYIOExWgVsiXWhP9f8T7oh3m5Lsr
         HDsSeZ8cyEofFYoaah1AltWj/jl7K4en/C6LN1rAdqN1pMFqWBDzmZJlVEBceBj9E8fn
         vvLw==
X-Gm-Message-State: AOAM530j+xJRdpz0L+sOb0smIUFeDtsW660mkF7a2bAEprAlbtQfaSAg
        wUNB32XE0OP/K9F6oXctH1KsHq6zXMkl6WS3q3fgDv4crmTlrWVeAqMzH7bcX6tYRec5bjbhWjq
        ZmpsyIIN6H6xtDpgYsGD1E8b2PlfB2M65xw==
X-Received: by 2002:a17:906:2f97:b0:6ce:3ef6:94be with SMTP id w23-20020a1709062f9700b006ce3ef694bemr24638077eji.136.1646249131054;
        Wed, 02 Mar 2022 11:25:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzsRBR/F3xyyehjGQgAe0B+0iZQvBRbcdylldzaOvYG3TOQZ1QZiyO7oXqhYToX9C8yGar/7A==
X-Received: by 2002:a17:906:2f97:b0:6ce:3ef6:94be with SMTP id w23-20020a1709062f9700b006ce3ef694bemr24638059eji.136.1646249130844;
        Wed, 02 Mar 2022 11:25:30 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id i14-20020a50cfce000000b00415b0730921sm1482765edk.42.2022.03.02.11.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 11:25:30 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v2 3/6] nfc: llcp: use centralized exiting of bind on errors
Date:   Wed,  2 Mar 2022 20:25:20 +0100
Message-Id: <20220302192523.57444-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302192523.57444-1-krzysztof.kozlowski@canonical.com>
References: <20220302192523.57444-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index fdf0856182c6..c9d5c427f035 100644
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

