Return-Path: <netdev+bounces-2354-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C561170167F
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 13:49:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6D092819B0
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 11:49:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CCD71C3B;
	Sat, 13 May 2023 11:49:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114091846
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 11:49:45 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D90910D0
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 04:49:42 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so97101917a12.0
        for <netdev@vger.kernel.org>; Sat, 13 May 2023 04:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683978580; x=1686570580;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZiSbSUosuiUZqcS7c/GQgLfHatjAKKg2yNJfrvJFGcQ=;
        b=B5dZsgqCdQYJvBqGfHIpCDUvgxGam71ot87mOSUr0/tfzT8jM+bIz3yHlLZQY2wgkV
         cYJD8PUSpUNYvyU3wbVDQXwNpYD0qpFpPROmKsYihdBwcq5wZoI0bfhN8sttQeXefp+n
         z5UMK9Z/0N+Yn+awIDU/yqNDDTEaWBi9I2htvUbZ9WOGCQ2E8tPp/V9adn6ZoKvzm8e2
         mxGtlsssxprUOn1cBiTCnLhg5ALVRfw/+O1u1ac8dMYyxIkhf+nIgD/UNmyvmXgR1u5w
         BVW6LWUOHdiUu/OdTezHqhdVTc6wtQvr5EmgwWE6njl4+eXAdw/Bl16njMkBmon3RYYc
         4RWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683978580; x=1686570580;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZiSbSUosuiUZqcS7c/GQgLfHatjAKKg2yNJfrvJFGcQ=;
        b=Lea1MWqwsRTCD7EaLF31qJsEPW/eegl3V0KXHKsS1pniWSrlWTBj+WK3fe1RKvqQF6
         kQiQ7T1Jryr5c/YtK/0YwB2/e9ylGFi4pBwLNaAP0ZUfJLhmAU2giHRBB8uGi8u27n7/
         CKUFhgO4ZNZpNSAXXIcT0ADaTANGhTDYSXFUCcn0PSE/ol2rc2wxzSCrGA6u5tKPCdPk
         sO/XMr1l7fJUmQ2o3taBE0nfNFpqzyjB9gggauXC83eYhxi4IQ5knyKD/XyAqmzB3puD
         oov+fQpokGXC92dzK2gfAyGiW4OOTxl2FDauDllah5aGvm4vISDX6yun1MQsABestoEF
         bM1Q==
X-Gm-Message-State: AC+VfDz7+wtm7Pt5hX/QoTjlk+yHmFODSg2v4RqiNKdvsDbKue0bm6pJ
	A3OxbzjdOIUyoeHsgCrErL6H4w==
X-Google-Smtp-Source: ACHHUZ5sSHT7qRhmXbBrwI11dOVCUtFfCHNEv4gFh2QnxQ87UJKKz1+Yf4dbmDsgeemez0wJK8BPfQ==
X-Received: by 2002:a50:ee0c:0:b0:50b:c56c:43d0 with SMTP id g12-20020a50ee0c000000b0050bc56c43d0mr25205160eds.1.1683978580503;
        Sat, 13 May 2023 04:49:40 -0700 (PDT)
Received: from krzk-bin.. ([2a02:810d:15c0:828:a3aa:fd4:f432:676b])
        by smtp.gmail.com with ESMTPSA id n25-20020a056402061900b0050a276e7ba8sm5030638edv.36.2023.05.13.04.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 May 2023 04:49:39 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Thierry Escande <thierry.escande@collabora.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nfx: llcp: fix possible use of uninitialized variable in nfc_llcp_send_connect()
Date: Sat, 13 May 2023 13:49:38 +0200
Message-Id: <20230513114938.179085-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

If sock->service_name is NULL, the local variable
service_name_tlv_length will not be assigned by nfc_llcp_build_tlv(),
later leading to using value frmo the stack.  Smatch warning:

  net/nfc/llcp_commands.c:442 nfc_llcp_send_connect() error: uninitialized symbol 'service_name_tlv_length'.

Fixes: de9e5aeb4f40 ("NFC: llcp: Fix usage of llcp_add_tlv()")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 net/nfc/llcp_commands.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
index 41e3a20c8935..cdb001de0692 100644
--- a/net/nfc/llcp_commands.c
+++ b/net/nfc/llcp_commands.c
@@ -390,7 +390,8 @@ int nfc_llcp_send_connect(struct nfc_llcp_sock *sock)
 	const u8 *service_name_tlv = NULL;
 	const u8 *miux_tlv = NULL;
 	const u8 *rw_tlv = NULL;
-	u8 service_name_tlv_length, miux_tlv_length,  rw_tlv_length, rw;
+	u8 service_name_tlv_length = 0;
+	u8 miux_tlv_length,  rw_tlv_length, rw;
 	int err;
 	u16 size = 0;
 	__be16 miux;
-- 
2.34.1


