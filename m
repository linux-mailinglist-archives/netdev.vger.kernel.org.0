Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F203B622948
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 11:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiKIKyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 05:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiKIKyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 05:54:06 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107E2112C
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 02:53:32 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221109105331epoutp0391d5d4357378c47d78352895d4e077e6~l5StUZC-W1577715777epoutp03Q
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:53:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221109105331epoutp0391d5d4357378c47d78352895d4e077e6~l5StUZC-W1577715777epoutp03Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667991211;
        bh=xTZZTrBUXFmgKPdovTdxJ19yWCYaot2LY2cprLmo7fQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/iHYZa4VidNzthkxDMv97aXMD43V4My31gjKVt32VNvHaL4kehdD+lgWEICr+Y/b
         nDQLf7uxJe+5ISCJOpqCun/xC8jDhO7mUy6pufWNWlMyyzyB/oOUFBms38kR6MNi/R
         L4xw4/SpNs7nJ2nrU2biuKlq9xNOOd7teJJIwDqM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20221109105330epcas5p2a7a9c3a9e65c2e6abf0518c611d36b04~l5SssDu1y2391823918epcas5p2A;
        Wed,  9 Nov 2022 10:53:30 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4N6hf01b2lz4x9Px; Wed,  9 Nov
        2022 10:53:28 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1D.57.39477.8A68B636; Wed,  9 Nov 2022 19:53:28 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20221109100309epcas5p4bc1ddd62048098d681ba8af8d35e2e73~l4muyQeYT3190631906epcas5p4O;
        Wed,  9 Nov 2022 10:03:09 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221109100309epsmtrp1b0629e4a7e48535f2207f1159c07d8b4~l4muxPv5y0841808418epsmtrp1F;
        Wed,  9 Nov 2022 10:03:09 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-3f-636b86a81d69
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EF.E0.14392.CDA7B636; Wed,  9 Nov 2022 19:03:09 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221109100306epsmtip2160e21a08f75553dfa3b0c9f80beda18~l4mr2ryGp1918919189epsmtip2D;
        Wed,  9 Nov 2022 10:03:05 +0000 (GMT)
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
Subject: [PATCH v2 6/6] arm64: dts: fsd: Add support for error correction
 code for message RAM
Date:   Wed,  9 Nov 2022 15:39:28 +0530
Message-Id: <20221109100928.109478-7-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221109100928.109478-1-vivek.2311@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJsWRmVeSWpSXmKPExsWy7bCmpu6Ktuxkg48HuCwezNvGZnFo81Z2
        iznnW1gs5h85x2rx9Ngjdou+Fw+ZLS5s62O12PT4GqvFqu9TmS0evgq3uLxrDpvFjPP7mCzW
        L5rCYnFsgZjFt9NvGC0Wbf3CbvHwwx52i1kXdrBatO49wm5x+806VotfCw+zWCy9t5PVQcxj
        y8qbTB4LNpV6fLx0m9Fj06pONo871/aweWxeUu/R/9fA4/2+q2wefVtWMXr8a5rL7vF5k1wA
        d1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Qq0oK
        ZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLSvHS9vNQSK0MDAyNToMKE
        7IyetR1MBZ38FZ1zV7M3MM7i6WLk5JAQMJHYv24BE4gtJLCbUeLBlLwuRi4g+xOjxL9rd6ES
        3xglpu3QgWnYeOQOG0TRXkaJ8/9/QzmtTBK/bp1kBqliE9CSeNy5gAUkISKwmkliy+eHjCAO
        s8AsJoklzbdYQKqEBRIkDvxqBdvBIqAqMWn5PnYQm1fARmLW1NvsEPvkJVZvOAA0lYODU8BW
        4uFCA5A5EgIPOCRaWs6yQNS4SOzfdwGqXlji1fEtULaUxMv+Nig7WWLHv05WCDtDYsHEPYwQ
        tr3EgStzWEDmMwtoSqzfpQ8RlpWYemod2GnMAnwSvb+fMEHEeSV2zIOxVSRefJ7ACtIKsqr3
        nDBE2EPiyYnnzJBAmcAosW3vAdYJjHKzEDYsYGRcxSiZWlCcm55abFpglJdaDo+05PzcTYzg
        1KzltYPx4YMPeocYmTgYDzFKcDArifBya2QnC/GmJFZWpRblxxeV5qQWH2I0BQbfRGYp0eR8
        YHbIK4k3NLE0MDEzMzOxNDYzVBLnXTxDK1lIID2xJDU7NbUgtQimj4mDU6qBaZ4Hg0wv40Ep
        lvdmizeEvnrvYtajG/eVxbvMTPSx0I7dPM0qCWeD1dYovbXSmrKh4+XC2a5JfN+YF1d/vHb+
        dIfUU0vHwozwJu6wKR/+yjXqeyf+aWu28H8UtO/943N3L7u67QvQfOXzyyE5S2ahIr/wgT1/
        dt7c2l7yZbvE9+at+2N9ZnJ4aVyeyvA8xz6Mf5bRdF3Lo5PX8T5RYr984DNrQ33jtszV7xMr
        Ln7ry7u3e46fspCKtF/3PtF5/+YKrF7Kp3vI9e7cgJ99lx89itCOzWv7JcJx8w2P2stXU0uq
        arMfO50V9tBdd6lqr86nCbMtKg33l6pcMsrObMnkU5IRrvo2S1vu+kXloOM7lViKMxINtZiL
        ihMBSoYgh1YEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWy7bCSvO7dquxkg7nPWSwezNvGZnFo81Z2
        iznnW1gs5h85x2rx9Ngjdou+Fw+ZLS5s62O12PT4GqvFqu9TmS0evgq3uLxrDpvFjPP7mCzW
        L5rCYnFsgZjFt9NvGC0Wbf3CbvHwwx52i1kXdrBatO49wm5x+806VotfCw+zWCy9t5PVQcxj
        y8qbTB4LNpV6fLx0m9Fj06pONo871/aweWxeUu/R/9fA4/2+q2wefVtWMXr8a5rL7vF5k1wA
        dxSXTUpqTmZZapG+XQJXRs/aDqaCTv6Kzrmr2RsYZ/F0MXJySAiYSGw8coeti5GLQ0hgN6PE
        p5mbmCASUhJTzrxkgbCFJVb+e84OYgsJNDNJzLxQAGKzCWhJPO5cwALSLCKwm0nibfdcdhCH
        WWARk8TLK73MIFXCAnESv/pPgNksAqoSk5bvA5vEK2AjMWvqbXaIDfISqzccAKrh4OAUsJV4
        uNAAYpmNxPPbixgnMPItYGRYxSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHD9amjsY
        t6/6oHeIkYmD8RCjBAezkggvt0Z2shBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNL
        UrNTUwtSi2CyTBycUg1Mxtdy2aoXMu7ZqyXGseC4Ys62nEk2t7h4j9ndtV0+P1G36HH2038H
        5/obnsmyX9fcq5fmdkO2aUlcnbhRmkK/Xop9y74qpycmapYpF1e1/vzqEhGQcD43/FKti5N/
        TrjfnSdW0Yu/b34i+uFwCftlhgksMVvyzJoE+FRXbC75z2Bn+eYp/6S/+UynrY4oV1zS/71W
        pdUovih/xUdO43ehHzUyF90V/8npFabz81hFgsnUTboXts6TMU0uX/HGMsJUSODdw7lVEk1/
        tH4mb7jrVVHvf+TgpBffizvL3p3a7OH59/uds+/XXvSP75j5yKj6YN6nKEXVZyfdvd9vNDZP
        nr7jlcLvqY8ClKK/X7NTYinOSDTUYi4qTgQAl4VxyQ4DAAA=
X-CMS-MailID: 20221109100309epcas5p4bc1ddd62048098d681ba8af8d35e2e73
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221109100309epcas5p4bc1ddd62048098d681ba8af8d35e2e73
References: <20221109100928.109478-1-vivek.2311@samsung.com>
        <CGME20221109100309epcas5p4bc1ddd62048098d681ba8af8d35e2e73@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add mram-ecc-cfg property which indicates the error correction code config
and enable the same for FSD platform.

In FSD, error correction code (ECC) is configured via PERIC SYSREG
registers.

Signed-off-by: Chandrasekar R <rcsekar@samsung.com>
Cc: devicetree@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
---
 arch/arm64/boot/dts/tesla/fsd.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/tesla/fsd.dtsi b/arch/arm64/boot/dts/tesla/fsd.dtsi
index 154fd3fc5895..6483bbf521e5 100644
--- a/arch/arm64/boot/dts/tesla/fsd.dtsi
+++ b/arch/arm64/boot/dts/tesla/fsd.dtsi
@@ -778,6 +778,7 @@
 			clocks = <&clock_peric PERIC_MCAN0_IPCLKPORT_PCLK>,
 				<&clock_peric PERIC_MCAN0_IPCLKPORT_CCLK>;
 			clock-names = "hclk", "cclk";
+			tesla,mram-ecc-cfg = <&sysreg_peric 0x700>;
 			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
 			status = "disabled";
 		};
@@ -795,6 +796,7 @@
 			clocks = <&clock_peric PERIC_MCAN1_IPCLKPORT_PCLK>,
 				<&clock_peric PERIC_MCAN1_IPCLKPORT_CCLK>;
 			clock-names = "hclk", "cclk";
+			tesla,mram-ecc-cfg = <&sysreg_peric 0x704>;
 			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
 			status = "disabled";
 		};
@@ -812,6 +814,7 @@
 			clocks = <&clock_peric PERIC_MCAN2_IPCLKPORT_PCLK>,
 				<&clock_peric PERIC_MCAN2_IPCLKPORT_CCLK>;
 			clock-names = "hclk", "cclk";
+			tesla,mram-ecc-cfg = <&sysreg_peric 0x708>;
 			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
 			status = "disabled";
 		};
@@ -829,6 +832,7 @@
 			clocks = <&clock_peric PERIC_MCAN3_IPCLKPORT_PCLK>,
 				<&clock_peric PERIC_MCAN3_IPCLKPORT_CCLK>;
 			clock-names = "hclk", "cclk";
+			tesla,mram-ecc-cfg = <&sysreg_peric 0x70c>;
 			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
 			status = "disabled";
 		};
-- 
2.17.1

