Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF0B6E3F04
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 07:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjDQFfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 01:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjDQFfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 01:35:39 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1793ABB;
        Sun, 16 Apr 2023 22:35:23 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f09ec7a65dso6489565e9.1;
        Sun, 16 Apr 2023 22:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681709714; x=1684301714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3EZgTfpxT+noYLmWhc7PR95/MhTWkfjB4CE9GtMigN8=;
        b=N2Ocb4awtWdd8Gyu+twK9QLkrcK+IhEHtxYVHrV/If19M++/zmcFCqFumMrGVKH+4h
         q44NI7XaEXgHEpoPFBaSUKZ623jQQXzL0UJv162kNjrhhLusMbwu0LSnBnWP8aGUUuE6
         IUjwVNC6yHoCufNztFWneVkDEBYiZ9IYAn0kdoGcU7alikZnXvMmqvjstm+i79r2/kV3
         f8CdSut5mJsP3qpQMPstiuY+fWmQ8UxM2WGET/QW1q8lMdUmJLHFxMzGk1wIbhJo4XP3
         ddprlLAcs5uLe9hLEB7R3VDBilUB9x93XFiUbEfab+tZ9ksHJtcD9L0JvsN9OozQkOAU
         upNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681709714; x=1684301714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3EZgTfpxT+noYLmWhc7PR95/MhTWkfjB4CE9GtMigN8=;
        b=AES19d3hnl3Ien/j9LgKn6Lo7y6NfDuzJXmsyIkDUJMLx+deznWEK/V73ePm+Dv4PO
         yenW54rJUAzSn4+VWRxrmdw4EhVZnO3U6hSvTV70fFi6QUVPFuDP0f5+94hDV/HqWN6l
         ukZ0oMYQTvA9UH/QyjjpoTCe6VDVeUvL4YRWBSTahx+pGMmmTofFZIBqEC4U7bctQL6/
         m+7KuCcN6Y1RG3WXnAiIDWc/WiBhsTlt1bshTQrTr+eINubkBiZCoIWzcxLlaGUendho
         2989MQm9kSoo0ykG88a2VijrwTMtbJSX9sRCxtvDXlgCNQvsXz18Ifa9L88CNKlHT9Qo
         lhWQ==
X-Gm-Message-State: AAQBX9eAZfWxOtK/C7VbevV8A9r9jVoRzIxxDi+3ci/YkN75ZwKm5Lap
        yk9mijLyBlADgQ2pTFlEKoM=
X-Google-Smtp-Source: AKy350a9z+2DbPBcjMzQ/DJre87l/zmpCtRmq1O7CCQXoDFEzLkhNyHqc5S0lKQhsqSTYqPdgG6YVg==
X-Received: by 2002:a5d:4105:0:b0:2f0:58a:db82 with SMTP id l5-20020a5d4105000000b002f0058adb82mr4049926wrp.36.1681709713930;
        Sun, 16 Apr 2023 22:35:13 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id w16-20020a5d6810000000b002e5ff05765esm9632493wru.73.2023.04.16.22.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 22:35:13 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     f.fainelli@gmail.com, jonas.gorski@gmail.com, nbd@nbd.name,
        toke@toke.dk, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        chunkeey@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH v2 1/2] dt-bindings: net: wireless: ath9k: document endian check
Date:   Mon, 17 Apr 2023 07:35:08 +0200
Message-Id: <20230417053509.4808-2-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230417053509.4808-1-noltari@gmail.com>
References: <20230417053509.4808-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document new endian check flag to allow checking the endianness of EEPROM and
swap its values if needed.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 .../devicetree/bindings/net/wireless/qca,ath9k.yaml          | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
index 0e5412cff2bc..ff9ca5e3674b 100644
--- a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
@@ -44,6 +44,11 @@ properties:
 
   ieee80211-freq-limit: true
 
+  qca,endian-check:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      Indicates that the EEPROM endianness should be checked
+
   qca,no-eeprom:
     $ref: /schemas/types.yaml#/definitions/flag
     description:
-- 
2.30.2

