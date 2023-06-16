Return-Path: <netdev+bounces-11622-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FC6F733B90
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 23:30:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8F011C21077
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 21:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B74A6ADE;
	Fri, 16 Jun 2023 21:30:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A022109
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 21:30:52 +0000 (UTC)
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844D535A5;
	Fri, 16 Jun 2023 14:30:50 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2b448b24a61so16692461fa.1;
        Fri, 16 Jun 2023 14:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686951048; x=1689543048;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SlSbhPNbssIprDpHNOXePwMeZq9BONqa1optZho/VFA=;
        b=X2Oqo9eS3GakYna+Mz41cEIe+tLHSdc9nn9qX81F6dp1fe84pLTVlOKyUUKnleimWG
         d6G5FZPKEA9F1BJ2xInh7TSoGWeNJXcCRtD0D8y28iUNRojahSZZIvjg2ZmTegnQHZFE
         EtQJd7Cgbd8wALKiFqcDgijigm6JDhUtXaR9np0bIoBM0QMDappFhgj4l9yeFvXhMe2V
         JUYNJ6jplFilgm9wjP3yPV00CMaVIQXCjB8kYST6dwL/njBHL25N6BG2Tn95VfF0NTsF
         KuAadI8k7MFvjaruxjbeQq+LnTmuJaKW19E3b8vgFt6sMeANA/bYlp60TAh+gVQIyYv/
         AC1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686951048; x=1689543048;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SlSbhPNbssIprDpHNOXePwMeZq9BONqa1optZho/VFA=;
        b=E8ye0TKkTLD6ieUrPNmEZnVtmietSx22ZrAdSm6WJgveDyOvMKFMN7niAM8xqIPyCl
         GlLF1BQq8v3bfD8P5/p8W//jEKTN+CcKRHypu+scWPa8MG686QcIlq/mD35z4YVEVP9J
         kcm1LYn9watMlYzNRvS6SGoHP7JlSSaCG6XwklQ9hgTZgfCIIFcKW6biAcdLKOcUG1bc
         q7xnQrgsT7xajoGouXa9Mz6t9HyrbnySMHQ3xIr2onSpdpynBc6N7BWHz8LKVL3J+DLb
         qyZQI4HZGqjGPRW632dtpMvrB8EimCNo39rAsnH6q+WWFC3sY20pN4XagGrhJLepHN3r
         Rb/g==
X-Gm-Message-State: AC+VfDxPk62AInqTVRrnrjBkTp97Bw5s8BRIw6LRUszGX+xqF3VEt/or
	4wtNVZocjplbO4hqw777y68=
X-Google-Smtp-Source: ACHHUZ4AzhyGOtF7rvB9gv6YHMUR1Zu3KGBIF9HNAkK08t5zoh8CJKAb9ppOvrCPtQ5asfg4HI9Ilg==
X-Received: by 2002:a2e:3306:0:b0:2b4:5b21:a94e with SMTP id d6-20020a2e3306000000b002b45b21a94emr1951020ljc.7.1686951047501;
        Fri, 16 Jun 2023 14:30:47 -0700 (PDT)
Received: from localhost.lan (031011218106.poznan.vectranet.pl. [31.11.218.106])
        by smtp.gmail.com with ESMTPSA id o18-20020a2e90d2000000b002b445237affsm1060608ljg.58.2023.06.16.14.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 14:30:46 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	devicetree@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] dt-bindings: nvmem: fixed-cell: add compatibles for MAC cells
Date: Fri, 16 Jun 2023 23:30:33 +0200
Message-Id: <20230616213033.8451-1-zajec5@gmail.com>
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

A lot of home routers have NVMEM fixed cells containing MAC address that
need some further processing. In ~99% cases MAC needs to be:
1. Optionally parsed from ASCII format
2. Increased by a vendor-picked value

There was already an attempt to design a binding for that at NVMEM
device level in the past. It wasn't accepted though as it didn't really
fit NVMEM device layer.

The introduction of NVMEM fixed-cells layout seems to be an opportunity
to provide a relevant binding in a clean way.

This commit adds two *generic* compatible strings: "mac-base" and
"mac-ascii". As always those need to be carefully reviewed.

OpenWrt project currently supports ~300 home routers that would benefit
from the "mac-base" binding. Those devices are manufactured by multiple
vendors. There are TP-Link devices (76 of them), Netgear (19),
D-Link (11), OpenMesh (9), EnGenius (8), GL.iNet (8), ZTE (7),
Xiaomi (5), Ubiquiti (6) and more. Those devices don't share an
architecture or SoC.

Amount of devices to benefit from the "mac-ascii" is hard to determine
as not all of them were converted to DT yet. There are at least 200 of
such devices.

It would be impractical to provide unique "compatible" strings for NVMEM
layouts of all those devices. It seems like a valid case for allowing a
generic binding instead. Even if this binding will not be sufficient for
some further devices it seems to be useful enough as it is.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
If this binding gets approved I will still need a minor help with YAML.

For some reason my conditions in fixed-cell.yaml don't seem to work as
expected. I tried to make "#nvmem-cell-cells" required only for the
"mac-base" but it seems it got required for all cells:

  DTC_CHK Documentation/devicetree/bindings/nvmem/layouts/fixed-layout.example.dtb
Documentation/devicetree/bindings/nvmem/layouts/fixed-layout.example.dtb: nvmem-layout: calibration@4000: '#nvmem-cell-cells' is a required property
        From schema: Documentation/devicetree/bindings/nvmem/layouts/fixed-layout.yaml

Cell "calibration" doesn't have any "compatible" so it shouldn't require
"#nvmem-cell-cells".
Can someone hint me what I did wrong, please?
---
 .../bindings/nvmem/layouts/fixed-cell.yaml    | 35 +++++++++++++++++++
 .../bindings/nvmem/layouts/fixed-layout.yaml  | 12 +++++++
 .../devicetree/bindings/nvmem/nvmem.yaml      |  5 ++-
 3 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/nvmem/layouts/fixed-cell.yaml b/Documentation/devicetree/bindings/nvmem/layouts/fixed-cell.yaml
index e698098450e1..047e42438a4f 100644
--- a/Documentation/devicetree/bindings/nvmem/layouts/fixed-cell.yaml
+++ b/Documentation/devicetree/bindings/nvmem/layouts/fixed-cell.yaml
@@ -11,6 +11,17 @@ maintainers:
   - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
 
 properties:
+  compatible:
+    oneOf:
+      - const: mac-base
+        description: >
+          Cell with base MAC address to be used for calculating extra relative
+          addresses.
+      - const: mac-ascii
+        description: >
+          Cell with base MAC address stored in an ASCII format (like
+          "00:11:22:33:44:55").
+
   reg:
     maxItems: 1
 
@@ -25,6 +36,30 @@ properties:
         description:
           Size in bit within the address range specified by reg.
 
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: mac-base
+    then:
+      properties:
+        "#nvmem-cell-cells":
+          description: The first argument is a MAC address offset.
+          const: 1
+      required:
+        - "#nvmem-cell-cells"
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: mac-ascii
+    then:
+      properties:
+        "#nvmem-cell-cells":
+          description: The first argument is a MAC address offset.
+          const: 1
+
 required:
   - reg
 
diff --git a/Documentation/devicetree/bindings/nvmem/layouts/fixed-layout.yaml b/Documentation/devicetree/bindings/nvmem/layouts/fixed-layout.yaml
index c271537d0714..05b8230cd18c 100644
--- a/Documentation/devicetree/bindings/nvmem/layouts/fixed-layout.yaml
+++ b/Documentation/devicetree/bindings/nvmem/layouts/fixed-layout.yaml
@@ -44,6 +44,18 @@ examples:
         #address-cells = <1>;
         #size-cells = <1>;
 
+        mac@100 {
+            compatible = "mac-base";
+            reg = <0x100 0xc>;
+            #nvmem-cell-cells = <1>;
+        };
+
+        mac@110 {
+            compatible = "mac-ascii";
+            reg = <0x110 0x11>;
+            #nvmem-cell-cells = <1>;
+        };
+
         calibration@4000 {
             reg = <0x4000 0x100>;
         };
diff --git a/Documentation/devicetree/bindings/nvmem/nvmem.yaml b/Documentation/devicetree/bindings/nvmem/nvmem.yaml
index 980244100690..9f921d940142 100644
--- a/Documentation/devicetree/bindings/nvmem/nvmem.yaml
+++ b/Documentation/devicetree/bindings/nvmem/nvmem.yaml
@@ -49,7 +49,10 @@ properties:
 patternProperties:
   "@[0-9a-f]+(,[0-7])?$":
     type: object
-    $ref: layouts/fixed-cell.yaml
+    allOf:
+      - $ref: layouts/fixed-cell.yaml
+      - properties:
+          compatible: false
     deprecated: true
 
 additionalProperties: true
-- 
2.35.3


