Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A02762292E
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 11:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiKIKyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 05:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiKIKxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 05:53:22 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEC628E27
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 02:52:57 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221109105256epoutp02e9b6715a6574d233713ade7a5d505cf2~l5SMvnJ8h1943319433epoutp02F
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:52:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221109105256epoutp02e9b6715a6574d233713ade7a5d505cf2~l5SMvnJ8h1943319433epoutp02F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667991176;
        bh=Yr1834k8OXNcWRYEnFhzVRrz47mefcJuT76a97OR0og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joY41sYNSsUTzsd6vNOREnKVAjy1bF/RU+/v1SO4RiHZFDaXy8l75hxRyJOnjBZxr
         cx14vsSN3us4rQjXzlQu+3dECx9n41olJGxZVUZ8u0hCYP9wfzLI7EvVkpxXqU4stR
         /MAHE+wNji2MTiAJ4hKfcH/Wzb6w6+dsoPrKeVzU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20221109105255epcas5p35a2099d8b8f9eaea18695a3fc450e53a~l5SMKfeSq0093000930epcas5p3Q;
        Wed,  9 Nov 2022 10:52:55 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4N6hdK2Y49z4x9Pv; Wed,  9 Nov
        2022 10:52:53 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        51.41.01710.5868B636; Wed,  9 Nov 2022 19:52:53 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20221109100254epcas5p48c574876756f899875df8ac71464ce11~l4mgyDo7n0799307993epcas5p4z;
        Wed,  9 Nov 2022 10:02:54 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221109100254epsmtrp25dd745ebedb0822bb1a534f908dd79ab~l4mgw1_3q1470214702epsmtrp2U;
        Wed,  9 Nov 2022 10:02:54 +0000 (GMT)
X-AuditID: b6c32a49-a41ff700000006ae-62-636b86854a18
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        6E.69.18644.DCA7B636; Wed,  9 Nov 2022 19:02:54 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221109100251epsmtip2005330859f2ac45bb34aa021674f2ca5~l4meCnU511466814668epsmtip2c;
        Wed,  9 Nov 2022 10:02:51 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, krzysztof.kozlowski+dt@linaro.org,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        alim.akhtar@samsung.com, linux-fsd@tesla.com, robh+dt@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com
Subject: [PATCH v2 3/6] arm64: dts: fsd: add sysreg device node
Date:   Wed,  9 Nov 2022 15:39:25 +0530
Message-Id: <20221109100928.109478-4-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221109100928.109478-1-vivek.2311@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0WTf0wbZRjHfe961wNScha6vaKbeGMwUFgLpTuUHy7iPDeNZLgs/kiwKSdF
        yrXptUy3GMm0Kgwq6EgIA4bAmIAMVgp2/IYxiBJggrAhDlaGAxciYx2QbI7Yckz/+z5PPs/3
        m/d535dApd14AJHOmVgjp9ZRuLeo9XJoSLjlywyNfL7hSfpmeStO9zW3iOnS0S9E9Nn+EYz+
        c2BOTFsXnSh9tdWK0bZbkxhdt16E0s47R+nxtlKcLh7tQujGytMieqBiG702tAToypb7Ytp5
        t0NMl1x1YLSls19MTy9dwOhzM5ewl2WMvXYKYSpsZmZlbBowtrocnPljsgNnmqs/Y755JGeW
        uyZwxmqvA8zGyTIx47LtTPJ5NyNWy6pTWWMgy2n0qelcWhx1KDnllZRolVwRroih91GBnDqT
        jaMS30gKP5Cuc5+SCsxS68zuVpKa56m98bFGvdnEBmr1vCmOYg2pOoPSEMGrM3kzlxbBsaYX
        FXJ5ZLQb/CBDO2FdxwwLXh83LSyIskEZkQu8CEgq4fBZK8gF3oSUbAdwevUaJhT3ALyd24J4
        KCnpArC5fv/jiZn2YpEAtQFoeehAhMKCwCuzg6iHwskweCunYpPyJ+sRaHc5N0NQj29bexnw
        UH5kApydLMM9WkTuhr/axzbzJGQsrGloEAt5z8L6ph63K0F4kXHQ+b3c4wPJ6wSs+nYGEZhE
        2PLjz5ig/eCdQfvWbAB0/d2JC1oDHRs5W4wWVhR2AEEnwJ7fSkUef5QMhY1te4X2Dlj0y4VN
        e5T0hfkP57eiJNBR/lgHwUVXAeYZ9UTlj/gJbQbO91vEwlIKABzvuwgKwM6S/xMqAKgDT7EG
        PjON5aMNCo499t+tafSZNrD5ksNed4AbN+9G9AGEAH0AEijlL/HZk6GRSlLVnxxnjfoUo1nH
        8n0g2r2+QjRAptG7vwJnSlEoY+RKlUqljIlSKajtkqriMI2UTFOb2AyWNbDGx3MI4RWQjVBv
        vTd/5Lyp0f8Q9twicsnfp3Xs09CRhP23NUVJ0idq5Ot/7XH6Vla9s/r2krc5v9d3170bkcH5
        y934SM9E7WrvT4md8en6YbLUut37sLT2/QfF1Q8MDsM5SXy3a9eQ3de141FkVx264WhM+vCi
        d9BLyiYZOLhCqbRI8wmLYWr5d/HuzLlmfdAzvdSplVxl3n2x+Z+vfWIiC2Ht59Nrzx8Zmlo+
        0Y99Jzuf9WbitlPZw40cfybvGr7he6V3/PC+5QMfWarjee7kIPlV8plja+lRId3XuYDKtdOd
        ybPBiyO6Fy7PyyYSZK9GvXbwh5LRKlFgyNPHy4/mZZlqa4Jtijmsa4AS8Vq1Igw18up/Afa0
        7pVSBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWy7bCSvO65quxkg4OvmC0ezNvGZnFo81Z2
        iznnW1gs5h85x2rx9Ngjdou+Fw+ZLS5s62O12PT4GqvFqu9TmS0evgq3uLxrDpvFjPP7mCzW
        L5rCYnFsgZjFt9NvGC0Wbf3CbvHwwx52i1kXdrBatO49wm5x+806Voul93ayOoh6bFl5k8lj
        waZSj4+XbjN6bFrVyeZx59oeNo/NS+o9+v8aeLzfd5XNo2/LKkaPf01z2T0+b5IL4I7isklJ
        zcksSy3St0vgyrja95214DlnxYbnz1kaGOdydDFyckgImEjc2z2DpYuRi0NIYAejxNmWnewQ
        CSmJKWdeskDYwhIr/z1nhyhqZpJ4s2sjE0iCTUBL4nHnArBuEYHdTBJvu+eCVTEL/AIata+H
        FaRKWMBe4v61uWwgNouAqsTFLZfAunkFbCSWrV0LtU5eYvWGA8xdjBwcnAK2Eg8XGoCEhYBK
        nt9exDiBkW8BI8MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzguNHS2sG4Z9UHvUOM
        TByMhxglOJiVRHi5NbKThXhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBa
        BJNl4uCUamCaNK3W/3//3S6ps5/Uti6/ZMIn6nR35UfNSTv/7LK59nqC0gqR44evX70dFLKq
        h93e+8qxw9MmmPrcvbZzx8RfL8W2Su5eIznt/gfZupspu3Y+FopNCjlvcLv2pvOkXK73HDcX
        KomvjjsymeOSP2tAvNZR1a6QqJk/V79fOuFB6v/erw9qZELsK17qxp8U3mr1P6/Z5aVWaPRV
        kZjFOxZ7HNL+xlVyhsGCc5KnJk8dkypLE4PC37fMbE02zhNlxFnan2Zqe8TMil+VNPvvC2s7
        xU/3+g6l37Likd2yZfO/G9fZIm8vCOde/L+nsf/Kja/rF3D9ZjZyT7w58fMX1/C8Qz7cS1be
        Ob/6BasFR16hmBJLcUaioRZzUXEiAJ4+vjcKAwAA
X-CMS-MailID: 20221109100254epcas5p48c574876756f899875df8ac71464ce11
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221109100254epcas5p48c574876756f899875df8ac71464ce11
References: <20221109100928.109478-1-vivek.2311@samsung.com>
        <CGME20221109100254epcas5p48c574876756f899875df8ac71464ce11@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriranjani P <sriranjani.p@samsung.com>

Add SYSREG controller device node, which is available in PERIC and FSYS0
block of FSD SoC.

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Pankaj Kumar Dubey <pankaj.dubey@samsung.com>
Cc: devicetree@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
---
 arch/arm64/boot/dts/tesla/fsd.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/tesla/fsd.dtsi b/arch/arm64/boot/dts/tesla/fsd.dtsi
index f35bc5a288c2..3d8ebbfc27f4 100644
--- a/arch/arm64/boot/dts/tesla/fsd.dtsi
+++ b/arch/arm64/boot/dts/tesla/fsd.dtsi
@@ -518,6 +518,16 @@
 				"dout_cmu_fsys1_shared0div4";
 		};
 
+		sysreg_peric: system-controller@14030000 {
+			compatible = "tesla,sysreg_peric", "syscon";
+			reg = <0x0 0x14030000 0x0 0x1000>;
+		};
+
+		sysreg_fsys0: system-controller@15030000 {
+			compatible = "tesla,sysreg_fsys0", "syscon";
+			reg = <0x0 0x15030000 0x0 0x1000>;
+		};
+
 		mdma0: dma-controller@10100000 {
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x0 0x10100000 0x0 0x1000>;
-- 
2.17.1

