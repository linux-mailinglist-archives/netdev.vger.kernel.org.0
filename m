Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E5A665640
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbjAKIjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjAKIj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:39:29 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65247CE01
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:39:25 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230111083921epoutp02082773173eb58f5320a9960699cde845~5NGjU446N2552925529epoutp02h
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 08:39:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230111083921epoutp02082773173eb58f5320a9960699cde845~5NGjU446N2552925529epoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1673426361;
        bh=B3TS1rkuqLCLHXTax7VaPalrznXw22OvtyJ1ylhbsRs=;
        h=From:To:Cc:Subject:Date:References:From;
        b=AiD/brVU00Hpb9Yu2+y6jj/w15S0X5aEpYagklSDYcb56plWXbw8x3uB9cDT7pu9j
         JgEguRdlwdgoepWSZKkyxwN2YqZl8NNt3tWTLaoHoj3d/6K8o8qcjUTUkDNhhfTnXN
         mwhwT78Q9z3L/3dLa6uztwLjC9nk8ZdLXCVpmx4s=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230111083920epcas5p100a0165ed8760b3b5660d2e102799d3c~5NGit-Cgt2765327653epcas5p1C;
        Wed, 11 Jan 2023 08:39:20 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4NsLh65q9Bz4x9QF; Wed, 11 Jan
        2023 08:39:18 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        25.CE.02301.6B57EB36; Wed, 11 Jan 2023 17:39:18 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230111075438epcas5p44ac566fdedff7c59bd416b7de28f3922~5MfgXPnn01062510625epcas5p4T;
        Wed, 11 Jan 2023 07:54:38 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230111075438epsmtrp2c14f9bb26ad7066b50b2a30d852b3778~5MfgWH3vO0511105111epsmtrp2J;
        Wed, 11 Jan 2023 07:54:38 +0000 (GMT)
X-AuditID: b6c32a49-201ff700000108fd-31-63be75b67e7d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6D.16.02211.D3B6EB36; Wed, 11 Jan 2023 16:54:37 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230111075435epsmtip1f26d49d1cf61d7c302365369f0d9f7f1~5MfeE7A4B2668326683epsmtip1j;
        Wed, 11 Jan 2023 07:54:35 +0000 (GMT)
From:   Sriranjani P <sriranjani.p@samsung.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, alexandre.torgue@foss.st.com,
        peppe.cavallaro@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, pankaj.dubey@samsung.com,
        alim.akhtar@samsung.com, ravi.patel@samsung.com,
        Sriranjani P <sriranjani.p@samsung.com>
Subject: [PATCH v2 0/4] net: stmmac: dwc-qos: Add FSD EQoS support
Date:   Wed, 11 Jan 2023 13:24:18 +0530
Message-Id: <20230111075422.107173-1-sriranjani.p@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMJsWRmVeSWpSXmKPExsWy7bCmlu620n3JBvsb9Cx+vpzGaPFg3jY2
        iznnW1gs5h85x2rx9Ngjdot7i96xWvS9eMhscWFbH6vF5V1z2Czm/V3LanFsgZjFt9NvGC0W
        bf3CbvH/9VZGi4cf9rBbtO49wm5x+806VgdBjy0rbzJ5PO3fyu6xc9Zddo8Fm0o9Nq3qZPO4
        c20Pm8f7fVfZPPq2rGL0ePpjL7PHlv2fGT0+b5IL4I7KtslITUxJLVJIzUvOT8nMS7dV8g6O
        d443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBekpJoSwxpxQoFJBYXKykb2dTlF9akqqQkV9c
        YquUWpCSU2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ0x+e8iloJtPBV/3s1nbGDs5Opi5OSQ
        EDCRmHZwN2sXIxeHkMBuRokTO2axQzifGCVOn+xjAqkSEvjGKPFinw5Mx5kn+6CK9jJKfPkw
        gQ3CaWWSOHX2LTNIFZuArkTrtc9MIAkRgS+MEtfXdIC1MAucY5RY966PDaRKWMBJ4uON36wg
        NouAqkTL0X/sIDavgJ3E67eTmSD2yUus3nCAGaRZQmAhh8SjjVegEi4S83d3sUDYwhKvjm9h
        h7ClJD6/28sGYadLbD6ymRXCzpHoaGpmhrDtJQ5cmQPUywF0kabE+l36EGFZiamn1oGNZxbg
        k+j9/QRqFa/EjnkwtprE4kedULaMxNpHn6DGe0i8ONzDCAmvWIlzC5exTWCUnYWwYQEj4ypG
        ydSC4tz01GLTAsO81HJ4VCXn525iBKdWLc8djHcffNA7xMjEwXiIUYKDWUmEdyXnnmQh3pTE
        yqrUovz4otKc1OJDjKbAMJvILCWanA9M7nkl8YYmlgYmZmZmJpbGZoZK4rypW+cnCwmkJ5ak
        ZqemFqQWwfQxcXBKNTDFHZh9xftuScO9Ne/7Qx/X5hcV/vkz5zTbgVt1TzcE2ngsPBsQ0ha7
        ds3Gz/0sDlVWZ8Juuyz9tHb5kTnT9zzV8BScfGum6Kl7Hvlvlt2d9zhs3cnDTLL/TT8Y57M9
        TqyfcnDTtAePap3aV0eyTDP0WBz0YtpdOWYd04ijxvme2fNmlzjYZT8U/BwpkfPKJOV35Iqz
        WRZKUnf8AreKbJhzRdjOomC1vPPReJvs9ctOGYnfvRBl4mttecT36gHj68FfLR5aLvBZevSo
        5PawH3eWOy8WUs+8s/4h16Wgjap3/KpDv5eGmgQFHLRlM/JVz51tNGPRtaUBl7fsdLx4Ybni
        pNotbr3Gq7Um9F94VvfukBJLcUaioRZzUXEiALbEz+42BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsWy7bCSnK5d9r5kg0UpFj9fTmO0eDBvG5vF
        nPMtLBbzj5xjtXh67BG7xb1F71gt+l48ZLa4sK2P1eLyrjlsFvP+rmW1OLZAzOLb6TeMFou2
        fmG3+P96K6PFww972C1a9x5ht7j9Zh2rg6DHlpU3mTye9m9l99g56y67x4JNpR6bVnWyedy5
        tofN4/2+q2wefVtWMXo8/bGX2WPL/s+MHp83yQVwR3HZpKTmZJalFunbJXBlTP67iKVgG0/F
        n3fzGRsYO7m6GDk5JARMJM482cfexcjFISSwm1Fi05UN7BAJGYmTD5YwQ9jCEiv/PYcqamaS
        2Hy5gxUkwSagK9F67TMTiC0i0MAkMX92NojNLHCFUeLIMxkQW1jASeLjjd9g9SwCqhItR/+B
        LeAVsJN4/XYyE8QCeYnVGw4wT2DkWcDIsIpRMrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cT
        IzjAtTR3MG5f9UHvECMTB+MhRgkOZiUR3pWce5KFeFMSK6tSi/Lji0pzUosPMUpzsCiJ817o
        OhkvJJCeWJKanZpakFoEk2Xi4JRqYLILFLiow52T6XDdVtONo+MhZ5miZ43SQTY1kRr12k2X
        J7m8P7dqvn+HYr5HUg9b6lf5h69N3Tr2bbTo3uyxYrGB3upHs+U8fhwyumZ5dKvrZuG09ewl
        YvdmJGbtsXb4Ovunr3yy863UlDM7fOYVSucEhh06+rPKbU0Lx33nbSvVc1/01L/+d6Fv+4RA
        i+eNt/+rKSzc0+3cm6svfNTH/YLollXLkkv5Jms+mP7NQ6ZTbb/fhdyXbt8q9SINlDzefV78
        IZPT72LOXM6vszpPW++6lGPlJvG2adap0yy7ou88c3y557b3T/ZYR8Ydhz+z2K84ondv1ZfM
        HXa++2ed1Jl3bkeWtfLs23/fWN90PqjEUpyRaKjFXFScCABbrkQU3wIAAA==
X-CMS-MailID: 20230111075438epcas5p44ac566fdedff7c59bd416b7de28f3922
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230111075438epcas5p44ac566fdedff7c59bd416b7de28f3922
References: <CGME20230111075438epcas5p44ac566fdedff7c59bd416b7de28f3922@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FSD platform has two instances of EQoS IP, one is in FSYS0 block and
another one is in PERIC block. This patch series add required DT binding,
DT file modifications and platform driver specific changes for the same.

This series needs following two patches [1,2] posted as part of SYSREG
controller support for FSD platform.

[1]: https://git.kernel.org/krzk/linux/c/7e03ca7429b23105b740eb79364dc410f214848b
[2]: https://git.kernel.org/krzk/linux/c/beaf55952d46fb14387d92de280bed7985ea85e5

Changes since v1:
1. Addressed all the review comments suggested by Krzysztof with respect to
DT files.
2. Updated dwc_eqos_setup_rxclock() function as per the review comments
given by Andrew.

Sriranjani P (4):
  dt-bindings: net: Add FSD EQoS device tree bindings
  net: stmmac: dwc-qos: Add FSD EQoS support
  arm64: dts: fsd: Add Ethernet support for FSYS0 Block of FSD SoC
  arm64: dts: fsd: Add Ethernet support for PERIC Block of FSD SoC

 .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
 .../net/tesla,dwc-qos-ethernet-4.21.yaml      | 103 ++++++++
 arch/arm64/boot/dts/tesla/fsd-evb.dts         |  18 ++
 arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi    | 112 +++++++++
 arch/arm64/boot/dts/tesla/fsd.dtsi            |  51 ++++
 .../stmicro/stmmac/dwmac-dwc-qos-eth.c        | 227 ++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  20 ++
 include/linux/stmmac.h                        |   1 +
 8 files changed, 533 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/tesla,dwc-qos-ethernet-4.21.yaml

-- 
2.17.1

