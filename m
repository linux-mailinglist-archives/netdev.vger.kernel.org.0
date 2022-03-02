Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5474CAEA6
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239724AbiCBT0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238866AbiCBT0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:26:16 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDEEC12C8
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:25:32 -0800 (PST)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 8263D3F1CB
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 19:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646249130;
        bh=ePWS8huBNB8mOLwzP5l9zhhnqwr/R2aV/N6dfRb+pkA=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=OqDB+l+JRV4MPEmDj4lf32cqG+Pt9SxR6kg7Ds+fid5NhbPhKD2YmaOcgycudK/jb
         AHMMF+l7d1/ic2htSTd8NfnotJGKiyLYH5GDXu29JSrNsoJxIEbaW5IbfoHoQ08+s0
         Iw+ZvwLnEijCMPmyuSp6qyXE6dsBNVsrxCiCNUCd+EseiO9/b491j39JmkA7ohEmp8
         y2XvzR+0ebxKudBRT87KoIvZD3RAgT9Bz7LEXfwoUsTfP+OKVVV+T4brfWKceAsdIT
         ROCqOZOebBsUTko+zdZ3rEymQl8VUdMsw3qZtnuK0Tw1sBHFX8S/9bQww2u/5bk5Z3
         2XiDAZLP9bk5w==
Received: by mail-ed1-f70.google.com with SMTP id o20-20020aa7dd54000000b00413bc19ad08so1552298edw.7
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 11:25:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ePWS8huBNB8mOLwzP5l9zhhnqwr/R2aV/N6dfRb+pkA=;
        b=15MWlB6ExP7EOLk1KlhvWKgIDKqFI9F/oKnQwmmXJ0aesxBKd7YwsPzCYylS9jh+do
         h+ZY6wKpx0UWzSpxy/z4Xd+T7Hg56O2B6SL4M1TTHmkXwDm1kArM37f17tciPmhVehQr
         WL532JIdK0LH8RE4cyv8S0UctR+99e0V7Wj0YN9fXBC/B0RSo2gmSf5luO6CxKVoV1pX
         j0Haka+2POIYbfcXgpw+cAoPPPiesDMk8StxyvZiWkZHyXxm5QOAAbGku97mCBmub6vZ
         GLzIdDjsPJtvbGdFVVSC+M/wKcReUNe1BjRFQ12lVBbfNpPyfBkFK3fD4VrCJkN76rBs
         kYZw==
X-Gm-Message-State: AOAM531D5SOICouqQh87r5Lua+rdGScSIXhtT4ydrv/87brW1ltk/g0w
        seVIv33oKeEbmIdc2l4mPBFoEzh80ZiK49VfFVmlQ3E70vj1nUshsWSOckfg8wwnkS0I9fMSqal
        1dB0Xx784ExhdWuXPHp7bygtYV7yM/JJN3w==
X-Received: by 2002:aa7:d706:0:b0:415:a00b:4ee with SMTP id t6-20020aa7d706000000b00415a00b04eemr7325272edq.373.1646249129875;
        Wed, 02 Mar 2022 11:25:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxFEFY4wLULZr/eBfkoQpBWjtr5OGYAVw5KfG35wQ8ZmBORByJ1wBNLn5MUEWgSX4YDGpFhpg==
X-Received: by 2002:aa7:d706:0:b0:415:a00b:4ee with SMTP id t6-20020aa7d706000000b00415a00b04eemr7325252edq.373.1646249129662;
        Wed, 02 Mar 2022 11:25:29 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id i14-20020a50cfce000000b00415b0730921sm1482765edk.42.2022.03.02.11.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 11:25:28 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v2 2/6] nfc: llcp: simplify llcp_sock_connect() error paths
Date:   Wed,  2 Mar 2022 20:25:19 +0100
Message-Id: <20220302192523.57444-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302192523.57444-1-krzysztof.kozlowski@canonical.com>
References: <20220302192523.57444-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The llcp_sock_connect() error paths were using a mixed way of central
exit (goto) and cleanup

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/llcp_sock.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index e92440c0c4c7..fdf0856182c6 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -712,10 +712,8 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 	llcp_sock->local = nfc_llcp_local_get(local);
 	llcp_sock->ssap = nfc_llcp_get_local_ssap(local);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
-		nfc_llcp_local_put(llcp_sock->local);
-		llcp_sock->local = NULL;
 		ret = -ENOMEM;
-		goto put_dev;
+		goto sock_llcp_put_local;
 	}
 
 	llcp_sock->reserved_ssap = llcp_sock->ssap;
@@ -760,11 +758,13 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 
 sock_llcp_release:
 	nfc_llcp_put_ssap(local, llcp_sock->ssap);
+
+sock_llcp_put_local:
 	nfc_llcp_local_put(llcp_sock->local);
 	llcp_sock->local = NULL;
+	llcp_sock->dev = NULL;
 
 put_dev:
-	llcp_sock->dev = NULL;
 	nfc_put_device(dev);
 
 error:
-- 
2.32.0

