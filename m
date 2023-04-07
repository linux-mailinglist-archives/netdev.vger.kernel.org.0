Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791456DACCA
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 14:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240274AbjDGMuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 08:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240656AbjDGMuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 08:50:46 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63F261BD;
        Fri,  7 Apr 2023 05:50:31 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id s13so23968019wmr.4;
        Fri, 07 Apr 2023 05:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680871830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PT2R/N8DSjvq3gCY4oulVlTU0UqMGHgaoluEuUjzZCA=;
        b=HWigBAGSs7yP+Us6sjpXun72uAtox3ewvDqYb32bkrgH8/iGinnU7rqUJ18vtGP7BF
         VTX7nZRKTUkPz3fm79umRlUTPBk8lSX0BfAWoh8Qns4HoP0JdQRW60q7jp3i8+SX0KNh
         tUEGjqmiuBSE2EkzQpGaqPK/qrShmVHHIAFwGvDaueuzAx+RF8MkmT/0TpPOdJTR9ivn
         u9NYwKyDc0l5oXljz6jV1EyTKXf6QYv56is/tz9gQi2KvhgelvRLXBHUfvnQR9xQUMTI
         8vmyZwUHtwtYywvHATxJXmnzXW5TNZ97jFFeMfmkQqpHsYY3s3YOCCOkw5hSnVfZ+EaY
         uNHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680871830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PT2R/N8DSjvq3gCY4oulVlTU0UqMGHgaoluEuUjzZCA=;
        b=OtdWKjl0qg4P5Enrs2x/Fj8y3odmcv/ppPZKB0AjXAT3lPO0p0UfY2iQB3wEtJUFMX
         bkmaiEqSvLr33OC9Y57tkJKBCo/BIJuFcA5hhMI+1NFdCuuAP7pCmdKAIJCgLhSiMKaJ
         VJQTTeoVPTpgvtjoKGmk8+2QfU4mAzbvNjer+T2OwR0k6Mvl9H0wB5ADBZEmjW2ZU5Q2
         RgcX9ps9+Knl0jF0fo71+g+Gmv/rXRLc2SRH+asZEMoayQI67Jgcz31H9t3sMowFU8R0
         Lna5rTZc79dMvfpsuMj/e3rBrwA7Qc+g/7Y8GKCfC4yxZ6dfutb6Ti9ITyZNfQimtGG9
         WRFg==
X-Gm-Message-State: AAQBX9elIMXoTmZUzA7w/Tgvz/ViKvzorvE084vcSqgntbiVbyWc8PGU
        HwCUtomGFMrOyzZmLLPEVcw=
X-Google-Smtp-Source: AKy350ZUvz2opaO63plSTQkaRGo/We03Acro9SeWKsVWVPci5sBss3eVrvBEdbUYYJH3O/X/VUGEJg==
X-Received: by 2002:a05:600c:3649:b0:3eb:39e7:3607 with SMTP id y9-20020a05600c364900b003eb39e73607mr1565229wmq.4.1680871829627;
        Fri, 07 Apr 2023 05:50:29 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id n37-20020a05600c3ba500b003f0652084b8sm8176596wms.20.2023.04.07.05.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 05:50:29 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 6/7] dt-bindings: net: dsa: mediatek,mt7530: disallow core-supply and io-supply
Date:   Fri,  7 Apr 2023 15:50:08 +0300
Message-Id: <20230407125008.42474-6-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230407125008.42474-1-arinc.unal@arinc9.com>
References: <20230407125008.42474-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

The core-supply and io-supply properties are used only on hardware that
uses the mediatek,mt7530 compatible string. Set them to false if the
compatible string is not mediatek,mt7530.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Daniel Golle <daniel@makrotopia.org>
---
 .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml          | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index b5db0f50aa59..3b85063d5b5a 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -291,6 +291,10 @@ allOf:
       required:
         - core-supply
         - io-supply
+    else:
+      properties:
+        core-supply: false
+        io-supply: false
 
   - if:
       properties:
-- 
2.37.2

