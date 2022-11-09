Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94332622928
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 11:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiKIKxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 05:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiKIKwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 05:52:40 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86AB827919
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 02:52:38 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221109105237epoutp02d820115a38319f5ced8174abd697a8be~l5R61jNDR1956119561epoutp02g
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:52:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221109105237epoutp02d820115a38319f5ced8174abd697a8be~l5R61jNDR1956119561epoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667991157;
        bh=z+E5HOwpVaLUPurIkhl/FRNgw1X+/A6zDkiYtpOW8hc=;
        h=From:To:Cc:Subject:Date:References:From;
        b=H/xukJI1umwafV+JoSuLMq4kHwCJwxFtZNL+/qllK12NBKyD7ShC49POl9fBcWmbm
         6f3mH9OQ9lh0QdJR0xTBnxu4SlDPAYY/NXJ1+De8+EP0e8CfKEFhMDS/5lO+Im+vYb
         ef2YJG6plmX92zE8wauTDj7c2VAszfWUrXwlbNwg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20221109105236epcas5p25e5f59f7d7e5abea496dd7e03b72ed9f~l5R6S4kw41323213232epcas5p2m;
        Wed,  9 Nov 2022 10:52:36 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4N6hcy0VtCz4x9Pv; Wed,  9 Nov
        2022 10:52:34 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        59.27.39477.1768B636; Wed,  9 Nov 2022 19:52:33 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221109100240epcas5p2cdd73ae96d91a5e915f3ac9a42091620~l4mT3HANr2279622796epcas5p26;
        Wed,  9 Nov 2022 10:02:40 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221109100240epsmtrp11a7c4d2685c97764b105cad8fbaa7af9~l4mT2MZAh0841808418epsmtrp1o;
        Wed,  9 Nov 2022 10:02:40 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-a4-636b867197ae
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        91.E0.14392.0CA7B636; Wed,  9 Nov 2022 19:02:40 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221109100237epsmtip2e33db1ff0dafca202dd531bce4d413aa~l4mQ-ZAx31855218552epsmtip2X;
        Wed,  9 Nov 2022 10:02:37 +0000 (GMT)
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
Subject: [PATCH v2 0/6] can: mcan: Add MCAN support for FSD SoC
Date:   Wed,  9 Nov 2022 15:39:22 +0530
Message-Id: <20221109100928.109478-1-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA0VTbUxbVRj23HvbXkZKrgW2I8kmXiGTRqBlpTsgjBkWc8NEMQuZH0O8aa+U
        3NLWtkzljwhjCJGvDBgjOPnUrCgoA1YrTORry1AYzJExloay6bDyMagZCIPYUtB/z/O875Pn
        Pe85h8QlVmEQmakzc0Ydq6WFe4jugTBp+AdneZVsZSQWzVzsFqL+y10iVDd2hkBfDo4K0O/D
        syJUOufA0c3uUgHquD8pQJbVKhw5nCfRLVudENWMXcVQe2MlgYbr96LHI/MANXb9LUKORz0i
        VHvTKkAFvYMiND3fJkDrDQMEarH/IDi6l+m8NIUx9R3ZzPLENGA6LEVC5t5kj5C53PwJU7Yp
        Y5au3hYypZ0WwGzlfSFiXB0HUnzf5uM0HKvmjMGcTqVXZ+oy4unjJ9IT06OVMnm4PAYdpoN1
        bBYXTx97NSX8lUyt+6h08GlWm+2WUliTiY48EmfUZ5u5YI3eZI6nOYNaa1AYIkxslilblxGh
        48yxcpksKtrd+B6vsVxrEhkcPh/9dWkCzwU9omLgQ0JKAT9dWwfFYA8poX4EsH05T+AlKwCu
        O6Z2yGMAx5vHhLuW71fu7BR6Aeyc28C9pACDg93VhKdLSEnh/aJ6wlMIoFox2OlybKfgVC0G
        m/Pvuisk6U8lwKLpFI+BoELhhM0FPFhMxcG8yeu4N+5Z2Ppd33YCpK6T0OEc2hn9GGyprCW8
        2B86r3Xu6EHwz7KzO1gFrVtFAi/WwPqKHuDFCbDvt7rtGXAqDLbbIr3yflh1ow3zYJzygyUb
        DzCvLobWi7s4BM65ygUeqyeqZNTfKzNwoMCyvSEJlQbPFTYR5WB/7f8B9QBYwDOcwZSVwZmi
        DVE67sP/bkqlz+oA209YmmQFjplHEf0AI0E/gCROB4h9X+BVErGa/TiHM+rTjdlaztQPot0r
        q8CDAlV69x/QmdPlihiZQqlUKmIOKeX0PnFTjVQloTJYM8dznIEz7vow0icoFzOncfHTB59K
        kTpXmz6Leii33IoNDS3JSh+9MLRW803J6hvnCstiON2Tl/RD/Ql3hv4h/fIlT8/kLUZhPKNV
        HzmTkDbCN+anqZYWXyxrKF+wHX79rZOF33ZJnIaF12oOkH2Vz+WOf64kInsi+V9Xok6t7PNh
        nyS03B6mqjboo1hFYqk4J6ngl/NT5eITfg3JFk1RMeAXbL7O8SttW/lr1VO9p04fCjz+Tlv4
        YmLJz3fnNg9mOt5vWG6CV5YKpckzkp/46pCvA8Psi/avbswXLr052xsb63o5bK73XeJh2ppE
        tkkJHgj5C/cCXK2++UlM2R/2ZEW76/m4HPtaSGpq7mwqTZg0rFyKG03sv7u3KIRLBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWy7bCSvO6Bquxkg4uLOS0ezNvGZnFo81Z2
        iznnW1gs5h85x2rx9Ngjdou+Fw+ZLS5s62O12PT4GqvFqu9TmS0evgq3uLxrDpvFjPP7mCzW
        L5rCYnFsgZjFt9NvGC0Wbf3CbvHwwx52i1kXdrBatO49wm5x+806VotfCw+zWCy9t5PVQcxj
        y8qbTB4LNpV6fLx0m9Fj06pONo871/aweWxeUu/R/9fA4/2+q2wefVtWMXr8a5rL7vF5k1wA
        dxSXTUpqTmZZapG+XQJXxqrji9kLHnJWvF55ibmBcQ97FyMnh4SAicTGTzdYuxi5OIQEdjNK
        zJi+lA0iISUx5cxLFghbWGLlv+fsEEXNTBLvn21gBUmwCWhJPO5cwAKSEBHYzSTxtnsuWBWz
        wCImiZdXepm7GDk4hAXsJTpvB4A0sAioSlza9ZkRxOYVsJFounaCGWKDvMTqDQeYJzDyLGBk
        WMUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERwRWpo7GLev+qB3iJGJg/EQowQHs5II
        L7dGdrIQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTCLl
        B5PaXgvFPu0/kvK10iFQ6sRFgVB715PsUYvrog3Vt8u6/5xy8/Hnf29tnB9Iyndm383tfJeo
        nL2/6l7QrDX7mRSiZ/nvcFXOnfzUctKfSfxvQm2cs538eAQStk13TzjDfvpW5o/oQo0d2pL3
        n7DMVrM73OFhXRgav+m5/q+QDRuWPZBOtwqpXmAnomN9O/R0x/Zntx7lLo0prToTuOu7avSz
        vkfHV3sdf/MrNfW086zJD5jEOSO1DjYqHTzbMfd1iL1I3cT7XvHbyrgEqz/e6EnRmxh11tCh
        rl10iVZk5JPbx+Ot2da5b9d8vG9+174j60rPLKx75vFD2y0/JTwhpedCuWNSpvCMrMoHSizF
        GYmGWsxFxYkAKz36AfcCAAA=
X-CMS-MailID: 20221109100240epcas5p2cdd73ae96d91a5e915f3ac9a42091620
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221109100240epcas5p2cdd73ae96d91a5e915f3ac9a42091620
References: <CGME20221109100240epcas5p2cdd73ae96d91a5e915f3ac9a42091620@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MCAN instances present on the FSD platform.
Also add support for handling error correction code (ECC) for MCAN message
RAM.

Sriranjani P (2):
  dt-bindings: Document the SYSREG specific compatibles found on FSD SoC
  arm64: dts: fsd: add sysreg device node

Vivek Yadav (4):
  dt-bindings: can: mcan: Add ECC functionality to message ram
  arm64: dts: fsd: Add MCAN device node
  can: m_can: Add ECC functionality for message RAM
  arm64: dts: fsd: Add support for error correction code for message RAM

 .../devicetree/bindings/arm/tesla-sysreg.yaml | 50 +++++++++++
 .../bindings/net/can/bosch,m_can.yaml         | 31 +++++++
 MAINTAINERS                                   |  1 +
 arch/arm64/boot/dts/tesla/fsd-evb.dts         | 16 ++++
 arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi    | 28 +++++++
 arch/arm64/boot/dts/tesla/fsd.dtsi            | 82 +++++++++++++++++++
 drivers/net/can/m_can/m_can.c                 | 48 ++++++++++-
 drivers/net/can/m_can/m_can.h                 | 17 ++++
 drivers/net/can/m_can/m_can_platform.c        | 76 ++++++++++++++++-
 9 files changed, 343 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/tesla-sysreg.yaml

-- 
2.17.1

