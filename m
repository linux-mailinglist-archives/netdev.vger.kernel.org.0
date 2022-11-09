Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EDD622933
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 11:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiKIKyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 05:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiKIKxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 05:53:23 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE65D28E3F
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 02:53:02 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221109105301epoutp03a688edcda694413c3c3224877b620201~l5SRfTTLc1283012830epoutp03k
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:53:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221109105301epoutp03a688edcda694413c3c3224877b620201~l5SRfTTLc1283012830epoutp03k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667991181;
        bh=8tJbVmcalInqjr8002K5YdNiHoVQ5bDHN1OlG4dZ7VI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRW7xcU44/JeDzX96KgulpOCsqqZ7jcaqm9PLoI2IJ+ZqjC+erVy2cPh4O5I5dF9C
         MheGYW7sWxVpGopJRk8UI1Hw34GdPgtjEr0Ospch3yJQTR97DNJszCQ00gX6YtbU43
         /Pfp4LFaOBNrXgH6IYGHIDvUfp5Kx/XY/bNhgolw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20221109105300epcas5p3dc38c1dce7325d8eaa97f320febd5d5b~l5SQ5vusB0093000930epcas5p3X;
        Wed,  9 Nov 2022 10:53:00 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4N6hdQ4ZVfz4x9Q1; Wed,  9 Nov
        2022 10:52:58 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DC.37.39477.A868B636; Wed,  9 Nov 2022 19:52:58 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221109100249epcas5p142a0a9f7e822c466f7ca778cd341e6d9~l4mc1Pwen0651406514epcas5p10;
        Wed,  9 Nov 2022 10:02:49 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221109100249epsmtrp20d91aa3791ac1d0547d711acfc0def13~l4mc0PmRO1459514595epsmtrp2f;
        Wed,  9 Nov 2022 10:02:49 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-df-636b868a50c7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F5.E0.14392.9CA7B636; Wed,  9 Nov 2022 19:02:49 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221109100246epsmtip275237e780508fbf6ad5796f05eaae93c~l4mZ_LXyt1466814668epsmtip2a;
        Wed,  9 Nov 2022 10:02:46 +0000 (GMT)
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
Subject: [PATCH v2 2/6] dt-bindings: can: mcan: Add ECC functionality to
 message ram
Date:   Wed,  9 Nov 2022 15:39:24 +0530
Message-Id: <20221109100928.109478-3-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221109100928.109478-1-vivek.2311@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0VTe0xTVxjPubcvanBXcHggzJGmC9hZaLF0B0aHyXTeDTabGHRxRryWS0v6
        XG/RMZeJTNzAycOMABXlIZuIG2Ip74e8AmFMYIrEzQ0oMDWkG0gdRDfcWgrbf7/v9/1+3/ed
        75zDw/26OUG8VIOFNhsonYDDZzX2bgsT55zRqiQrthA0damRg3rqG7iodOQ0C5X1DbPRb/3T
        XJT7yIGj0cZcNrLNjLNRzXIhjhxzB9Cd1lIOKh7pxND1yq9YqL88AC0NOQGqbHjCRY6Fdi6y
        jjazUVZHHxfdd9ay0bOKXhb6eqKFvTOAtF/9CSPLbWnk49v3AWmryeaQv4y3c8j6qpNk3oqE
        nO+8yyFz7TWAfJ55kUu6bFuVGw5qYzU0lUybQ2iDypicalArBPH7kt5MipJLpGJpNHpNEGKg
        9LRCsCtBKX4rVec+qiDkGKVLc1NKimEEEW/Emo1pFjpEY2QsCgFtStaZZKZwhtIzaQZ1uIG2
        xEglksgot/CIVrM4KjI5/T+aWzqeASpeyAE+PEjIYMkpB8eD/Yg2AIebA3IA340XASxbzMC9
        wRKAp3/PAuuOW65altfRAaC9DfOKsjA40/KM60lwCBGcyS5neRKbiWsYtLscwBPghBWDVZ/9
        vGr3J/bD+czzq5hFvAIfDHnL+hKxsHOkjuNt9zK8VtflnoPH8yEU0FEh8dSBxD0etFqn1jS7
        4IWqvrXx/OHcgJ3rxUHQ9UfHmkYFm59ns71YA8sL2tf0cbBrrJTlqY8T2+D11ggv/RIs/L4W
        82Cc2AjP/TWLeXlf2HxpHQvhI1c+22P1tDo37O+lSThSf2ZtKfkATuR9juWDrdb/O5QDUAMC
        aROjV9NMlCnSQB//78pURr0NrL5l0TvNwDG1EN4DMB7oAZCHCzb7bgjTqvx8k6n0j2mzMcmc
        pqOZHhDlXl8BHvSiyuj+DAZLklQWLZHJ5XJZ9A65VLDF93KxSOVHqCkLraVpE21e92E8n6AM
        rKJ3YvbOseDEjjpHsPKb+u7qwBuTxZPx3/3z9wq/YTdmzroy2ZEw+F6KPfSI7df2W2eteGJR
        tFD84Ze1R19/9UBK8rzzkO0D5+Ul6l1hyWDTQf6KQ/xDUcbNp9q7uU2x6fPkJ/du7DtRaUpg
        NNoBxY7BnqIEIO8OTslTLz/sGyfV+oWYvbtXph/6X0nfMttqFZXF9wcruqqpocLEk+JM3bdP
        fZrY7eM/njhv2/T+8oRy/mhk/8AX+slQy8Dj0KVD+xe18j03meWz2NuB2gjhxsMVeekXkgJP
        jZW4Yg4XbK92/NkyfbUgrpO/c/HTB+m3K7fLlsPgkynGGdO2t07YMEbGaQUsRkNJRbiZof4F
        92BkxFQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsWy7bCSvO7Jquxkg+u7DS0ezNvGZnFo81Z2
        iznnW1gs5h85x2rx9Ngjdou+Fw+ZLS5s62O12PT4GqvFqu9TmS0evgq3uLxrDpvFjPP7mCzW
        L5rCYnFsgZjFt9NvGC0Wbf3CbvHwwx52i1kXdrBatO49wm5x+806VotfCw+zWCy9t5PVQcxj
        y8qbTB4LNpV6fLx0m9Fj06pONo871/aweWxeUu/R/9fA4/2+q2wefVtWMXr8a5rL7vF5k1wA
        dxSXTUpqTmZZapG+XQJXxqcLWgVvhCtefStvYFzI38XIySEhYCJx9vM6li5GLg4hgd2MEoe2
        P2aBSEhJTDnzEsoWllj57zk7RFEzk8TMY6vYQBJsAloSjzsXgHWLCOxmknjbPResillgEZPE
        yyu9zCBVwgIhEq/uHQCzWQRUJZ6dXgc2llfARmLf+Q1sECvkJVZvAKnh4OAUsJV4uNAAJCwE
        VPL89iLGCYx8CxgZVjFKphYU56bnFhsWGOallusVJ+YWl+al6yXn525iBEePluYOxu2rPugd
        YmTiYDzEKMHBrCTCy62RnSzEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC
        1CKYLBMHp1QD0zneHJbI2p/R+wRkm4NMHt0Tqf5x8M0T7g0OcUvTvuxMSzvktlydYc+XTIe+
        F16MczUebXQ/rDT7wU2hKpvXPyaK6UzQ3cS20GUt4/zJO4xYDsades3D5WUxQWzf48dvv3N3
        LH476U1PxpvYU1ZF90rvmC2qqLld+XJ5r129e9rPtQ/kDk/dy+9fZVOwi7vgHMNO40B+ke9F
        rVyyUWbXdgQuSNhcftZZKOIl/4S13AfuXRAu3HrkTsG2A/XxMTdush1x35mtNEtO191d7sa3
        ynWit4zl7qc9Ptan9K5sc8vZpfaOmcVqQb+tePek3TmlzzTft00og92Z/xSrWqG77+lw9c06
        93c5aujp2N0oVGIpzkg01GIuKk4EAIgOjpcNAwAA
X-CMS-MailID: 20221109100249epcas5p142a0a9f7e822c466f7ca778cd341e6d9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221109100249epcas5p142a0a9f7e822c466f7ca778cd341e6d9
References: <20221109100928.109478-1-vivek.2311@samsung.com>
        <CGME20221109100249epcas5p142a0a9f7e822c466f7ca778cd341e6d9@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever the data is transferred or stored on message ram, there are
inherent risks of it being lost or corruption known as single-bit errors.

ECC constantly scans data as it is processed to the message ram, using a
method known as parity checking and raise the error signals for corruption.

Add error correction code config property to enable/disable the
error correction code (ECC) functionality for Message RAM used to create
valid ECC checksums.

Signed-off-by: Chandrasekar R <rcsekar@samsung.com>
Cc: devicetree@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
---
 .../bindings/net/can/bosch,m_can.yaml         | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
index 26aa0830eea1..91dc458ec33f 100644
--- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
+++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
@@ -50,6 +50,12 @@ properties:
       - const: hclk
       - const: cclk
 
+  tesla,mram-ecc-cfg:
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    description:
+      Handle to system control region that contains the ECC INIT register
+      and register offset to the ECC INIT register.
+
   bosch,mram-cfg:
     description: |
       Message RAM configuration data.
@@ -149,4 +155,29 @@ examples:
       };
     };
 
+  # Example 2: m_can on the FSD SoC
+  - |
+    #include <dt-bindings/clock/fsd-clk.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+      can@14088000 {
+        compatible = "bosch,m_can";
+        reg = <0x0 0x14088000 0x0 0x0200>,
+              <0x0 0x14080000 0x0 0x8000>;
+        reg-names = "m_can", "message_ram";
+        interrupts = <GIC_SPI 159 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-names = "int0", "int1";
+        pinctrl-names = "default";
+        pinctrl-0 = <&m_can0_bus>;
+        clocks = <&clock_peric PERIC_MCAN0_IPCLKPORT_PCLK>,
+                 <&clock_peric PERIC_MCAN0_IPCLKPORT_CCLK>;
+        clock-names = "hclk", "cclk";
+        tesla,mram-ecc-cfg = <&sysreg_peric 0x708>;
+        bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
+      };
+    };
 ...
-- 
2.17.1

