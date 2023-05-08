Return-Path: <netdev+bounces-898-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89E276FB48A
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 17:58:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E86691C209C2
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 15:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D324F441B;
	Mon,  8 May 2023 15:58:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C043020F9
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 15:58:40 +0000 (UTC)
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6E040D4;
	Mon,  8 May 2023 08:58:39 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f00d41df22so29644816e87.1;
        Mon, 08 May 2023 08:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683561517; x=1686153517;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qoKeBGVLOBu4DrLK/qM8cN/bO+eEqfiWPQ9nbUj9vHo=;
        b=njc2uBhQTwCCXVHXm/oE2IOFTW4zhdBqaTkEe+Jkvty3fbq0HmDNIHQ+Dtnov5JE5B
         DlCRgIXF4wRZsVTIxt/In6dIIJjr93rvVkJbdIsGM0WJCVM2PkZZP6nK3YzraVbSFXZ/
         y1axOGjBwCE6LLrV2/3hb3EdM9u2ked3GmCe5fNpfHcYDPSYlh20egY3TJDc/69WfH/S
         JxsccU+FleZQKxQ98hjZKKI9ARdJDrE+RaZG1h0IycyLct/DXTCWhglMwDQ/8TryxT10
         x6tdLtYXTIzB2e7w21vFDYkqfD65okleWow13EfeXpkPHi+Q2wdW6Wp9I8giWU6MD12i
         BE7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683561517; x=1686153517;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qoKeBGVLOBu4DrLK/qM8cN/bO+eEqfiWPQ9nbUj9vHo=;
        b=VU3FADEDuY01raMw91lD/L4S9sUuOURItKEASwE1vIWy/6GSoOiGuy/KSa6gWCvRbT
         8AwJvpMIXqW+XY3nRMi2sWEfUzh7YAiokIWiG0rUxgHwqILQAM0AoCX663rHo1ZOJ0M2
         eOOAaqSGmQwUqs0b3+8Bq/r7WoRuZfcfU3vXEs97ZBZasFuFEiwRBZl0KWQqbH5gs1AJ
         Vew9rY7K/vd35NDgDzQ4psPwlb6WDDWpaBgUpyFA9AYLis1BrtyYW67pa0nHOETs3Hrr
         d23hQttWWUSlM5ZXQFVclDbJLUl7DiMVkAasDU5ZF850J9eKecRXtPAo1C6uQeJQmKz6
         IE8w==
X-Gm-Message-State: AC+VfDyIYnfKRXbu6jOBF84j6s0GTpAQ+8utGr55Wrf+UFY+EJKMn4oP
	0yzXiQPgUDlYbRyQLb2cOFY=
X-Google-Smtp-Source: ACHHUZ6pT3RD+p8XzST+vQ2EfJpmtSMjPL9zzBcCqUFO+eXzEx90tVk4CD3LshCQFBxntLgVrASleA==
X-Received: by 2002:a05:6512:3b14:b0:4f1:b38d:bfb8 with SMTP id f20-20020a0565123b1400b004f1b38dbfb8mr1765747lfv.24.1683561517097;
        Mon, 08 May 2023 08:58:37 -0700 (PDT)
Received: from localhost.lan (031011218106.poznan.vectranet.pl. [31.11.218.106])
        by smtp.gmail.com with ESMTPSA id b29-20020ac25e9d000000b004edce1d338csm30878lfq.89.2023.05.08.08.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:58:36 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Kalle Valo <kvalo@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Christian Marangi <ansuelsmth@gmail.com>
Subject: [PATCH] dt-bindings: mt76: support pointing to EEPROM using NVMEM cell
Date: Mon,  8 May 2023 17:58:20 +0200
Message-Id: <20230508155820.9963-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Rafał Miłecki <rafal@milecki.pl>

All kind of calibration data should be described as NVMEM cells of NVMEM
devices. That is more generic solution than "mediatek,mtd-eeprom" which
is MTD specific.

Add support for EEPROM NVMEM cells and deprecate existing MTD-based
property.

Cc: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
Ansuel is working on mt76 driver support for NVMEM based EEPROM access:
https://github.com/openwrt/mt76/pull/765

I took the liberty to propose this binding patch.

One important difference: my binding uses "eeprom" while Ansuel went
with "precal". I found a lot of "eeprom" references and only one
"precal". If you think however "precal" fits better please comment.
---
 .../bindings/net/wireless/mediatek,mt76.yaml         | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
index 67b63f119f64..0500caa4107c 100644
--- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
@@ -71,6 +71,14 @@ properties:
 
   ieee80211-freq-limit: true
 
+  nvmem-cells:
+    items:
+      - description: NVMEM cell with EEPROM
+
+  nvmem-cell-names:
+    items:
+      - const: eeprom
+
   mediatek,eeprom-data:
     $ref: /schemas/types.yaml#/definitions/uint32-array
     description:
@@ -84,6 +92,7 @@ properties:
           - description: offset containing EEPROM data
     description:
       Phandle to a MTD partition + offset containing EEPROM data
+    deprecated: true
 
   big-endian:
     $ref: /schemas/types.yaml#/definitions/flag
@@ -258,7 +267,8 @@ examples:
       interrupt-parent = <&cpuintc>;
       interrupts = <6>;
 
-      mediatek,mtd-eeprom = <&factory 0x0>;
+      nvmem-cells = <&eeprom>;
+      nvmem-cell-names = "eeprom";
     };
 
   - |
-- 
2.35.3


