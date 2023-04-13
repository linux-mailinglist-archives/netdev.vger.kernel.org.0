Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43AED6E00D6
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjDLV3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjDLV3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:29:23 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DFA7D9E;
        Wed, 12 Apr 2023 14:29:18 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id z26so12892087ljq.3;
        Wed, 12 Apr 2023 14:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681334957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=456QAvvtFsJz9MlnBR4BMWWfSHxyYmN8x4WUjQvR230=;
        b=ZEfLFAkeRU2gIWo8oNm4F2yRm3hBbNC/T914gFb4O09VoZ8GEaSwZ3KHPdWKgRGxfS
         6Xo2BbxEmF7YME+NVOP8MLjOvJK1uc+sRg5jlrZqvpA5TEqEy016BBKD1WgB4R4odsso
         TTY6mP7+SuTuNvxww/CMw47g1cfpEsaFZC/xYJGD/Pks1bCVDx4BmT1I/cspN7YxA3xl
         WqEj22ugjF5jCq6fKepkWWyvKpDtVwdvLhbBLsC23lUQNQQrb2Csj3GmmKr1ZVlS3u+Z
         7oAgi3fTGcVvQ97cYaivN3KXgKgc1+3Rd2DzCPUQhYKGtbJPlFU+mz0GgzSgfzgHFM/Q
         bqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681334957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=456QAvvtFsJz9MlnBR4BMWWfSHxyYmN8x4WUjQvR230=;
        b=EtFkwL7gApJXoRJ6ZHfGp6mxTSS8SpzHPXc+0tu5N+6Vgx49W9v8AyuJTLVksLJ4IG
         N32jx7lvQEHPKZ087a54DoZ4Lgb6cDv+vucIB6y/OOtbFn+BOigkN06bUKNTVWZXag4P
         DdabHap6GXQp+EdR913XZ/PdlgQRqwOzKH9bXECb8DPcmVHuBLvhJSmJaD95HNl6fS2n
         YSzuNqSaNDUD8GYSOwYLnWCgQzOu4VBr4+hE+sj9U+bel82kw6WNM/Z6GqRxFjCIdXfS
         UFYgavMFz7XXftzVjjtuDZ0sv3Pko2lyue+Ew838PHVY8w0ogdN53gEtteq5imWoQmtf
         QSHw==
X-Gm-Message-State: AAQBX9cYS7IKlJxTopdW+1yG4NHkPG06LIHWcp20x6nSbueXSLsnAsub
        Q8ngGJ/N66VKGWI6JLHllLM=
X-Google-Smtp-Source: AKy350Z/K5A6wvUUtoxhM9asteWT3QdOauvOoPj7FRaYuOul6Xh7e5It0qADBdsDxG0E+/CS74OGOQ==
X-Received: by 2002:a2e:9a83:0:b0:2a7:84b5:f360 with SMTP id p3-20020a2e9a83000000b002a784b5f360mr23112lji.39.1681334957269;
        Wed, 12 Apr 2023 14:29:17 -0700 (PDT)
Received: from localhost.localdomain (93-80-67-75.broadband.corbina.ru. [93.80.67.75])
        by smtp.googlemail.com with ESMTPSA id p14-20020a2e804e000000b002a7758b13c9sm1882481ljg.52.2023.04.12.14.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 14:29:16 -0700 (PDT)
From:   Ivan Mikhaylov <fr0st61te@gmail.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivan Mikhaylov <fr0st61te@gmail.com>,
        Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 3/4] net/ftgmac100: add mac-address-increment option for GMA command from NC-SI
Date:   Thu, 13 Apr 2023 00:29:04 +0000
Message-Id: <20230413002905.5513-4-fr0st61te@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230413002905.5513-1-fr0st61te@gmail.com>
References: <20230413002905.5513-1-fr0st61te@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add s32 mac-address-increment option for Get MAC Address command from
NC-SI.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>
---
 Documentation/devicetree/bindings/net/ftgmac100.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ftgmac100.txt b/Documentation/devicetree/bindings/net/ftgmac100.txt
index 29234021f601..7ef5329d888d 100644
--- a/Documentation/devicetree/bindings/net/ftgmac100.txt
+++ b/Documentation/devicetree/bindings/net/ftgmac100.txt
@@ -22,6 +22,10 @@ Optional properties:
 - use-ncsi: Use the NC-SI stack instead of an MDIO PHY. Currently assumes
   rmii (100bT) but kept as a separate property in case NC-SI grows support
   for a gigabit link.
+- mac-address-increment: Increment the MAC address taken by GMA command via
+  NC-SI. Specifies a signed number to be added to the host MAC address as
+  obtained by the OEM GMA command. If not specified, 1 is used by default
+  for Broadcom and Intel network cards, 0 otherwise.
 - no-hw-checksum: Used to disable HW checksum support. Here for backward
   compatibility as the driver now should have correct defaults based on
   the SoC.
-- 
2.40.0

