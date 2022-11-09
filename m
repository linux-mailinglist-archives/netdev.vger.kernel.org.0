Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26B1622926
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 11:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbiKIKx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 05:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiKIKwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 05:52:53 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41C427FE4
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 02:52:47 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221109105246epoutp01c9e927e2612335a4de2d5b07555ffc4f~l5SDhOK5v0109301093epoutp01e
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:52:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221109105246epoutp01c9e927e2612335a4de2d5b07555ffc4f~l5SDhOK5v0109301093epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667991166;
        bh=cuGZVz4FIhuzdAfWl8rgVOUhOMLdb5/nmbhIZx7irik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgOE4oYh60AX5ZvHuqEBC6uCEgNrVF3FZcMHlubYoCdPcbbvoB1tGCFr0Djx0hNrJ
         8zpnEdWigN60R/4kDZS0SVZpc0KTL9dXroyxxIA25PPbNH6ehmVzkGiLXdVOU6G/aO
         UCfVl+gS2iE6Ue1LyCG63+T+uwZxvRJ+Ky1YteoA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221109105245epcas5p40fff769aac1c87b0724955c96166dd07~l5SC1wPwg0925809258epcas5p4w;
        Wed,  9 Nov 2022 10:52:45 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4N6hd71dtRz4x9Pt; Wed,  9 Nov
        2022 10:52:43 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C9.31.01710.B768B636; Wed,  9 Nov 2022 19:52:43 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20221109100245epcas5p38a01aed025f491d39a09508ebcdcef84~l4mYcPO1F0950009500epcas5p33;
        Wed,  9 Nov 2022 10:02:45 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221109100245epsmtrp2af633d327b72b3b0316ecf51ffd72eac~l4mYa3idD1470214702epsmtrp2O;
        Wed,  9 Nov 2022 10:02:45 +0000 (GMT)
X-AuditID: b6c32a49-c9ffa700000006ae-4b-636b867b85aa
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A3.E0.14392.4CA7B636; Wed,  9 Nov 2022 19:02:45 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221109100242epsmtip23606948220b4375261e0ec2d7bee2dea~l4mViXYTC1466814668epsmtip2X;
        Wed,  9 Nov 2022 10:02:41 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, krzysztof.kozlowski+dt@linaro.org,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        alim.akhtar@samsung.com, linux-fsd@tesla.com, robh+dt@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com,
        Vivek Yadav <vivek.2311@samsung.com>
Subject: [PATCH v2 1/6] dt-bindings: Document the SYSREG specific
 compatibles found on FSD SoC
Date:   Wed,  9 Nov 2022 15:39:23 +0530
Message-Id: <20221109100928.109478-2-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221109100928.109478-1-vivek.2311@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0WTe0xbVRzHPbe3twVEL6/uSCaWbkMGAdpR8GCousjwzldItsA0S0pTbigB
        2qa3VaskDsZYqCmPCQERoZ3gBiNslscKo4g89jIDpjzcGIQKi4QgIs8pj9nSov99ft/f73t+
        +f3OOVyWbz8RyM1QammNUpYlIDzx9r7DYRGfFWTKha12LpquaSdQb0sbB1UP5eOotn+QjR7f
        /I2DiubsLDTcXsRGlpkxNmrcKGch+3wK+qWzmkCVQ90YunqxDEc3TTy0/tMCQBfbVjnIvtTF
        QVXDVjY6Z+vnoImFZjb6x9yHo/qpDvYbPKq14QFGmSw66q+fJwBlaSwkqEdjXQTVUvc5Vbwt
        pP7sHiWootZGQO3kfcOhVixBSV4fZsYraFkareHTSrkqLUOZLhG8c0L6pjQmViiKEMWhVwR8
        pSyblggS3k2KSMzIcowq4H8ky9I5pCQZwwiiXovXqHRamq9QMVqJgFanZanF6khGls3olOmR
        Slr7qkgoPBLjKEzNVIz+UIyrewI+MeR142dApY8BeHAhKYbWIQPhZF/yBoATtREG4OngZQD7
        zAvAFawD2DI7z95zNJ//w52wAZibf4njCs5h0FxuBM4qggyDM4Um3JnwJ69gsHXFvmthkVUY
        rDv7EHdW+ZGpsLF2eNeBk4dg/epXu7o3GQ+Nl8Y5rn4vwSvXelgGwOV6kBJoNwud50Bymgvz
        Lj911yTAne/73ewH52+1ujkQrizaCBfLoXWn0D2DAppKu4CLX4c9I9W483wWeRhe7YxyyS/C
        8rvNmJNZ5HPQuDmLuXRvaK3Z44NwbqWE7bQ6WxkH/VwyBcdvN7g3VAJg54wdKwFBVf93MAHQ
        CF6g1Ux2Os3EqEVK+uP/bk2uyraA3eccdtwKJqeXInsBxgW9AHJZAn9vr9BMua93mkz/Ka1R
        STW6LJrpBTGO9ZWyAgPkKsd/UGqlInGcUBwbGyuOi44VCfZ5f1sZJvcl02VaOpOm1bRmz4dx
        PQLPYPrVY2RqtHyzoNJzUd0Wknt64FaF8fcLZ/cPbT0zNmeu1SZjPxY8PmkJsl27PrrmbxrI
        RWvKKrOkI3/t1DgjDJ7UJN7IGFF/+d7t8ooHpen3LkQPH03bnvKpTgrf+GDS2tQS/vfRy8Xx
        0yljkT7g9OiBhLeJkwFd8ZyNrRPjXzQ8uT97TPWoQdfGucOTxuk8Q3rudS3Xfyfb3L/YCRW8
        5oz7qwnPS3jbp/ThFYalasryZGHQa9rz5Z3gkILNubLe9bsDox0p4uRDbz0rD72jr5sKXU4u
        1B7ZirLl2Eak7/+6OFgj1D/MyeGfP3ggOBHjzTY1afd9fbxMH/d02Fx+3T/CKMAZhUwUxtIw
        sn8B1FM45lcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWy7bCSvO7Rquxkg8fPGC0ezNvGZnFo81Z2
        iznnW1gs5h85x2rx9Ngjdou+Fw+ZLS5s62O12PT4GqvFqu9TmS0evgq3uLxrDpvFjPP7mCzW
        L5rCYnFsgZjFt9NvGC0Wbf3CbvHwwx52i1kXdrBatO49wm5x+806VotfCw+zWCy9t5PVQcxj
        y8qbTB4LNpV6fLx0m9Fj06pONo871/aweWxeUu/R/9fA4/2+q2wefVtWMXr8a5rL7vF5k1wA
        dxSXTUpqTmZZapG+XQJXxtX9/SwFB0Qrupr2sTQwzhDsYuTkkBAwkVjX/pYRxBYS2M0ocWSq
        N0RcSmLKmZcsELawxMp/z9m7GLmAapqZJOZsfcwEkmAT0JJ43LmABSQhIrCbSeJt91ywKmaB
        RUwSL6/0MoNUCQvESVx6vZ8VxGYRUJVY+mUm2FheARuJ3uXX2SFWyEus3nAAqJ6Dg1PAVuLh
        QgOIi2wknt9exDiBkW8BI8MqRsnUguLc9NxiwwLDvNRyveLE3OLSvHS95PzcTYzg+NHS3MG4
        fdUHvUOMTByMhxglOJiVRHi5NbKThXhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliS
        mp2aWpBaBJNl4uCUamDatn7zp1jPq5NsXhrlpU0KmOjQrcZl/sDl259LT9S/1/2Wbv9wybV+
        +bt1744lSIudM4w/oPjvamTBjx/m99J2iq+1ZT1mxcJg3PfLccX1isQ7YT/6XBrcO493xLs6
        LMprNHC/t//pUlv5u/NXih2YdyXuXWl4Xn7kdalLE547tue/fBCwdXVp0cEn9eLbP4qIcrkH
        7v0X6bH4IU/BzIQp7Qc5ZD7YmekWpMiquHyYsX19yv6zUyrX3H+Q8lFLzHXF7EcZqh5BSfus
        ZgYd5w6Yc/vXoSzOBZYcH91YAzXclS5ZTC+15H42Q2PDzZoT5+Lk/sVXF1+Z3ix9Wq1l+eO2
        3TvEGthO9055s7muNThbiaU4I9FQi7moOBEA3FLSUQ4DAAA=
X-CMS-MailID: 20221109100245epcas5p38a01aed025f491d39a09508ebcdcef84
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221109100245epcas5p38a01aed025f491d39a09508ebcdcef84
References: <20221109100928.109478-1-vivek.2311@samsung.com>
        <CGME20221109100245epcas5p38a01aed025f491d39a09508ebcdcef84@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriranjani P <sriranjani.p@samsung.com>

Describe the compatible properties for SYSREG controllers found on
FSD SoC.

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Pankaj Kumar Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Ravi Patel <ravi.patel@samsung.com>
Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
Cc: devicetree@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
---
 .../devicetree/bindings/arm/tesla-sysreg.yaml | 50 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 51 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/tesla-sysreg.yaml

diff --git a/Documentation/devicetree/bindings/arm/tesla-sysreg.yaml b/Documentation/devicetree/bindings/arm/tesla-sysreg.yaml
new file mode 100644
index 000000000000..bbcc6dd75918
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/tesla-sysreg.yaml
@@ -0,0 +1,50 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/arm/tesla-sysreg.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Tesla Full Self-Driving platform's system registers
+
+maintainers:
+  - Alim Akhtar <alim.akhtar@samsung.com>
+
+description: |
+  This is a system control registers block, providing multiple low level
+  platform functions like board detection and identification, software
+  interrupt generation.
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+          - enum:
+              - tesla,sysreg_fsys0
+              - tesla,sysreg_peric
+          - const: syscon
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+
+      sysreg_fsys0: system-controller@15030000 {
+            compatible = "tesla,sysreg_fsys0", "syscon";
+            reg = <0x0 0x15030000 0x0 0x1000>;
+      };
+
+      sysreg_peric: system-controller@14030000 {
+            compatible = "tesla,sysreg_peric", "syscon";
+            reg = <0x0 0x14030000 0x0 0x1000>;
+      };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index a198da986146..56995e7d63ad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2943,6 +2943,7 @@ M:	linux-fsd@tesla.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	linux-samsung-soc@vger.kernel.org
 S:	Maintained
+F:	Documentation/devicetree/bindings/arm/tesla-sysreg.yaml
 F:	arch/arm64/boot/dts/tesla*
 
 ARM/TETON BGA MACHINE SUPPORT
-- 
2.17.1

