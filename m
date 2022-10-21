Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B01B6076FB
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJUMiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiJUMh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:37:59 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E885F263B79
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:37:56 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221021123752epoutp02bebe5a1277ebef3f6beac63e5f5b807d~gFdZZfnVl2912929129epoutp02b
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:37:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221021123752epoutp02bebe5a1277ebef3f6beac63e5f5b807d~gFdZZfnVl2912929129epoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666355872;
        bh=kBb3AafMz4fyorpuxMlNBEFcJ47hkEFxnJeRveVxoKE=;
        h=From:To:Cc:Subject:Date:References:From;
        b=t9A8LYnKW8hvhiyYirWFebmrZuAfINI+Wj7sKXy/axZmEq3SoW+o7z/BoXXEsJJbd
         xj/SjBWxkSIiNwXzEUOBXFfcOZG3Lz1GdG0KLmMsipdUAwn5HWDe+iwFxwKEfrYy9q
         zemmjrzqoYqgEUYyPowoJxVUYQzZ69NcClBoRFMU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221021123751epcas5p46c65236dd5e0735fe4f833a9d6350173~gFdYszwRq2985729857epcas5p47;
        Fri, 21 Oct 2022 12:37:51 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Mv3s974rTz4x9Pr; Fri, 21 Oct
        2022 12:37:49 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        58.DB.20812.D9292536; Fri, 21 Oct 2022 21:37:49 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221021102614epcas5p18bcb932e697a378a8244bd91065c5496~gDqd-YE4c0532605326epcas5p1L;
        Fri, 21 Oct 2022 10:26:14 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221021102614epsmtrp1a2d8d9399a4a8eeb01bbddcbf355f461~gDqd_dKDG1811718117epsmtrp1c;
        Fri, 21 Oct 2022 10:26:14 +0000 (GMT)
X-AuditID: b6c32a49-b09f97000001514c-ff-6352929d1a87
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5F.16.14392.6C372536; Fri, 21 Oct 2022 19:26:14 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221021102612epsmtip1249235bdcd1827a021762fdd79807251~gDqb8188m2573525735epsmtip1B;
        Fri, 21 Oct 2022 10:26:12 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, alim.akhtar@samsung.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vivek Yadav <vivek.2311@samsung.com>
Subject: [PATCH 0/7] can: mcan: Add MCAN support for FSD SoC
Date:   Fri, 21 Oct 2022 15:28:26 +0530
Message-Id: <20221021095833.62406-1-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42LZdlhTQ3fupKBkgwM/zSwezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFr8
        WniYxWLpvZ2sDnweW1beZPJYsKnU4+Ol24wem1Z1snn0/zXweL/vKptH35ZVjB6fN8kFcERl
        22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAXa2kUJaY
        UwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM44
        cPIga0EbV8XZx6uZGxivsXcxcnJICJhIbHnSwdLFyMUhJLCbUaK7YRMThPOJUWL3hH2MEM43
        Rokjt7+ywrT8n3EeKrGXUeLLl+/MEE4rk0TH613MIFVsAloSjzsXsIDYIgJ3GSWuLc7sYuTg
        YBaoljhwhA8kLCxgIzFj216wO1gEVCVWbdkM1sorYC2xYc9ZZohl8hKrNxwAmy8h8JVdov3l
        UhaIhIvE4dNroJ4Qlnh1fAuULSXxsr8Nyk6W2PGvE+rqDIkFE/cwQtj2EgeuzGGBuEdTYv0u
        fYiwrMTUU+uYQGxmAT6J3t9PmCDivBI75sHYKhIvPk9gBWkFWdV7Thgi7CFx9OMXsK1CArES
        vdOaWCcwys5CWLCAkXEVo2RqQXFuemqxaYFhXmo5PJ6S83M3MYLTopbnDsa7Dz7oHWJk4mA8
        xCjBwawkwmtRF5QsxJuSWFmVWpQfX1Sak1p8iNEUGGQTmaVEk/OBiTmvJN7QxNLAxMzMzMTS
        2MxQSZx38QytZCGB9MSS1OzU1ILUIpg+Jg5OqQamBNPH3n4bOV/lz8uf23Oy+vmB8w0l3c9q
        uJkPv9kcPCno0LxJG42EwmZqbC/X3nZoBX+j60Qd1l8uZvEVed1XbvRarbwZfmcx+9GQ6rjc
        /2nL7l+r2mR5sJa9QH2a/r7aTXHHVp1IrPZ/uSvp+ePXwhFb4/yEXWRDinNtyk/EcZm+ebhE
        k53px0Hty3kWkgqnWCx/TWndoBj5VmZpFCfzVKFgiRI9Wdc6fjV19X8aTCUXlMX6Xsy8prTT
        /q+GTFtkle8JtYutB5fl8UUWB9i3h4mLPt17SGTryZ+d84/fEf14frFhyImjkyVqNQSmr9Ip
        ZGYx40xvFa68ctm//mm7s0drjl0j/6V7mtaF3kosxRmJhlrMRcWJAKRxzi4UBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsWy7bCSnO6x4qBkg8nb5C0ezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFr8
        WniYxWLpvZ2sDnweW1beZPJYsKnU4+Ol24wem1Z1snn0/zXweL/vKptH35ZVjB6fN8kFcERx
        2aSk5mSWpRbp2yVwZRw4eZC1oI2r4uzj1cwNjNfYuxg5OSQETCT+zzjP2MXIxSEksJtR4vWq
        A1AJKYkpZ16yQNjCEiv/PWeHKGpmkvj38z4TSIJNQEvicecCsCIRgZeMEi1n2UBsZoF6iXdn
        boINEhawkZixbS+YzSKgKrFqy2ZmEJtXwFpiw56zzBAL5CVWbzjAPIGRZwEjwypGydSC4tz0
        3GLDAsO81HK94sTc4tK8dL3k/NxNjOAg1dLcwbh91Qe9Q4xMHIyHGCU4mJVEeAveBSQL8aYk
        VlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwNRm5XX7xAmDhrm+
        X93S0y5Ov782LCmqOUNkOs/UwN7iFiausnOHnRV2CK1OzWpdNMFk6c6zTE8+uq77MXuKg8l0
        77eVDpKr+Mu+R4qp9MbOYVhaY2nxvUQ3UmSrcl7wKZ17HH9vnTp6ZX7JNrf+StbjMZuq2oTi
        PXMt/unNOP+lk3t71byr+57Yp6hOcWlb5fCHSW/CY1FNw8zbOepzA4NCP99R5f7HuVOtsSN6
        wZ12qdnsRv9jvujcdyz4u5llDauuYeyS2avTZuxYZzNRZuKjsLNLhB22dIqGRXAtyjrPOzdo
        If+iNcyeukvW3OqP+23p1l5revRVqP59JvWXBybt2rN5Pt+zwsfCh/8pliuxFGckGmoxFxUn
        AgAtwbJfwQIAAA==
X-CMS-MailID: 20221021102614epcas5p18bcb932e697a378a8244bd91065c5496
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021102614epcas5p18bcb932e697a378a8244bd91065c5496
References: <CGME20221021102614epcas5p18bcb932e697a378a8244bd91065c5496@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MCAN instances present on the FSD platform.
Also add support for handling error correction code (ECC) for MCAN message RAM.

Sriranjani P (2):
  dt-bindings: Document the SYSREG specific compatibles found on FSD SoC
  arm64: dts: fsd: add sysreg device node

Vivek Yadav (5):
  dt-bindings: can: mcan: Add ECC functionality to message ram
  can: mcan: enable peripheral clk to access mram
  arm64: dts: fsd: Add MCAN device node
  can: m_can: Add ECC functionality for message RAM
  arm64: dts: fsd: Add support for error correction code for message RAM

 .../devicetree/bindings/arm/tesla-sysreg.yaml | 50 +++++++++++
 .../bindings/net/can/bosch,m_can.yaml         |  4 +
 MAINTAINERS                                   |  1 +
 arch/arm64/boot/dts/tesla/fsd-evb.dts         | 16 ++++
 arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi    | 28 +++++++
 arch/arm64/boot/dts/tesla/fsd.dtsi            | 82 +++++++++++++++++++
 drivers/net/can/m_can/m_can.c                 | 73 +++++++++++++++++
 drivers/net/can/m_can/m_can.h                 | 24 ++++++
 drivers/net/can/m_can/m_can_platform.c        | 11 ++-
 9 files changed, 288 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/arm/tesla-sysreg.yaml

-- 
2.17.1

