Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24446634F8A
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 06:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbiKWFbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 00:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235797AbiKWFbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 00:31:00 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C3DED70D
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 21:30:53 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221123053051epoutp040505b41b05f20293c58d05ac2f06f1a7~qH6_ed3r01473714737epoutp04t
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 05:30:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221123053051epoutp040505b41b05f20293c58d05ac2f06f1a7~qH6_ed3r01473714737epoutp04t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669181451;
        bh=PeHQNfRsUuOEDOm6P6LGWXjKFyyfkz97NfHAPd4GyJk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=OKGLrMTNAmhLFO+hxfbBS1ciXMd7ISYOhgKdbS0aDMmO3rEwwMUrY9J+uUT3SsWmT
         62kYfsoh0uvabKJDZv3/ZjSXYPdC4b2N8yP365HwzDOA7g8Hg7kEHNbpFkfPg/psMe
         uPG+tJEv07iqCkBuP/aLhPxRbfRF3nWdCkx/VwVk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221123053050epcas5p4b4875f16ba7b937d64c4e5e59a17ea2d~qH690mLxB2883728837epcas5p4W;
        Wed, 23 Nov 2022 05:30:50 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4NH8qD0kJ3z4x9QH; Wed, 23 Nov
        2022 05:30:48 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        37.67.56352.700BD736; Wed, 23 Nov 2022 14:30:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221122105017epcas5p269e97219d3ebe2eaf37fa428a7275f35~p4omNphOz2771827718epcas5p2B;
        Tue, 22 Nov 2022 10:50:17 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221122105017epsmtrp1f2069736b62669576daefbcaaba036d9~p4omMCJIE0938009380epsmtrp1q;
        Tue, 22 Nov 2022 10:50:17 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-37-637db0073ed9
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        34.72.14392.969AC736; Tue, 22 Nov 2022 19:50:17 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221122105014epsmtip1c52304a7e24ac748f20a126b140ec795~p4ojVM-ao0766107661epsmtip1R;
        Tue, 22 Nov 2022 10:50:14 +0000 (GMT)
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
Subject: [PATCH v3 0/2] can: mcan: Add MCAN support for FSD SoC
Date:   Tue, 22 Nov 2022 16:24:53 +0530
Message-Id: <20221122105455.39294-1-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOJsWRmVeSWpSXmKPExsWy7bCmli77htpkgw97rC0ezNvGZnFo81Z2
        iznnW1gs5h85x2rx9Ngjdou+Fw+ZLS5s62O12PT4GqvFqu9TmS0evgq3uLxrDpvFjPP7mCzW
        L5rCYnFsgZjFt9NvGC0Wbf3CbvHwwx52i1kXdrBatO49wm5x+806VotfCw+zWCy9t5PVQcxj
        y8qbTB4LNpV6fLx0m9Fj06pONo871/aweWxeUu/R/9fA4/2+q2wefVtWMXr8a5rL7vF5k1wA
        d1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Qq0oK
        ZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLSvHS9vNQSK0MDAyNToMKE
        7IylOxcxF9zSqGj9uYe5gfGEfBcjJ4eEgInE/jtnmbsYuTiEBHYzSjyZPxvK+cQo8XFlCyuE
        841RYuq+e4wwLfd/X2aBSOxllJh08TwbhNPKJLH4/FdmkCo2AS2Jx50LwKpEBFYzSWz5/JAR
        xGEWmMUksaT5FgtIlbCAvcSHn23sIDaLgKrEvD0dTCA2r4C1RN/Oc+wQ++QlVm84wAxhn+CQ
        eL5LDcJ2kTix7TYbhC0s8er4Fqh6KYmX/W1QdrLEjn+drBB2hsSCiXugfrCXOHBlDtANHEAH
        aUqs36UPEZaVmHpqHdgJzAJ8Er2/nzBBxHkldsyDsVUkXnyewArSCrKq95wwRNhDYk/jQ2aQ
        sJBArETnRN0JjLKzEOYvYGRcxSiZWlCcm55abFpgnJdaDo+o5PzcTYzgFKzlvYPx0YMPeocY
        mTgYDzFKcDArifDWe9YkC/GmJFZWpRblxxeV5qQWH2I0BQbYRGYp0eR8YBbIK4k3NLE0MDEz
        MzOxNDYzVBLnXTxDK1lIID2xJDU7NbUgtQimj4mDU6qB6an0bMfdvjlf3ks9KMu67mLgNqN0
        L8vBTg5Go56oPN3la/WvrQ+atdPohlRmsKBb06ZvF2bu220u+3qVt+OUpCWex4x4312osGpZ
        5rfWwWGZB+9JK9VNeyT3mR1Y9EH/UfyimOc7hQ8vsW5r5PIx9F209lVo8c9ZX7XN4s/whL87
        pHCmZ8u387+tXY58aOjenuj9cEGapkyKdtn2m3cX//Y7+PrfkhcdJ/vnqgq7nfCIqvROPLS5
        6obWseZ/Z/s4d/jqS/ZpnWS4vkBZ4QozL/u0G0sFHcpuC7jb/th9fV79jmt7Fj93Wh4SeV74
        aGFG/RyDGfLOB4N/Vh6re6/1dKttrJPkFK2Dyn13pjx6Za3EUpyRaKjFXFScCAD/h8/wSgQA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSnG7myppkg48fOSwezNvGZnFo81Z2
        iznnW1gs5h85x2rx9Ngjdou+Fw+ZLS5s62O12PT4GqvFqu9TmS0evgq3uLxrDpvFjPP7mCzW
        L5rCYnFsgZjFt9NvGC0Wbf3CbvHwwx52i1kXdrBatO49wm5x+806VotfCw+zWCy9t5PVQcxj
        y8qbTB4LNpV6fLx0m9Fj06pONo871/aweWxeUu/R/9fA4/2+q2wefVtWMXr8a5rL7vF5k1wA
        dxSXTUpqTmZZapG+XQJXxtKdi5gLbmlUtP7cw9zAeEK+i5GTQ0LAROL+78ssXYxcHEICuxkl
        fqzYygKRkJKYcuYllC0ssfLfc3aIomYmib6NUxhBEmwCWhKPOxeAdYsI7GaSeNs9F6yKWWAR
        k8TLK73MIFXCAvYSH362sYPYLAKqEvP2dDCB2LwC1hJ9O8+xQ6yQl1i94QDzBEaeBYwMqxgl
        UwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxgmNCS3MH4/ZVH/QOMTJxMB5ilOBgVhLhrfes
        SRbiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomDU6qBiffjgu1q
        3x5Ns0t6pC8lnTO/+J/64urdC7dPeeoQ4iX8b9ejn3avWB8tX3IsZ9N7plO+CcdcTkr89L9+
        rXCCwk3fPQvtbAp/yXjpsDk/vr5FsV37imA/b5SIuIv+VJkFMVo/bUPnT3RX/tikFbJ2RfdW
        5TSdiFurZvNoRngtrwh9P+OGpDOvzuQbH7by1MlIX4rnMDn3UUVu1f8lV+4fPrsh2r5laYZz
        ztPpLnyLpV8/W+MhpMP+f8fe/9XX3VenPD1lmKWRrTzx2SeD82kX7q+f2Wg0SULiyepPZ8Un
        zGY0mHcx66TVIhvZSbN9MhvSRQzck0tPFZSXBqlsFW2pPv2ca+H7phuzrZwF+paxmiuxFGck
        GmoxFxUnAgAFlijH+AIAAA==
X-CMS-MailID: 20221122105017epcas5p269e97219d3ebe2eaf37fa428a7275f35
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221122105017epcas5p269e97219d3ebe2eaf37fa428a7275f35
References: <CGME20221122105017epcas5p269e97219d3ebe2eaf37fa428a7275f35@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MCAN instances present on the FSD platform.

Vivek Yadav (2):
  can: m_can: Move mram init to mcan device setup
  arm64: dts: fsd: Add MCAN device node

changes since v2:

[PATCH v2 1/6] dt-bindings: Document the SYSREG specific compatibles found
on FSD SoC
link:
https://lore.kernel.org/lkml/20221109100928.109478-2-vivek.2311@samsung.com/
    1: Addressed review comment given by Krzysztof Kozlowski
        a) As per suggestion separated this patch and posted separately.
          ref: https://www.spinics.net/lists/kernel/msg4597970.html 

[PATCH v2 2/6] dt-bindings: can: mcan: Add ECC functionality to message ram
link: 
https://lore.kernel.org/lkml/20221109100928.109478-3-vivek.2311@samsung.com/
    1: Addressed review comment given by Krzysztof Kozlowski
       a) For now I am dropping this. I will reconsider the implementation and
          will resend as separate patch.

[PATCH v2 3/6] arm64: dts: fsd: add sysreg device node
link:
https://lore.kernel.org/lkml/20221109100928.109478-4-vivek.2311@samsung.com/
    1: Addressed review comment given by Krzysztof Kozlowski
       a) Dropped Cc from commit message.
       b) As per suggestion separated this and corresponding DT-binding
	  patch and posted separately.
          ref: https://www.spinics.net/lists/kernel/msg4597921.html

[PATCH v2 4/6] arm64: dts: fsd: Add MCAN device node
link: 
https://lore.kernel.org/lkml/20221109100928.109478-5-vivek.2311@samsung.com/
    1: Addressed review comment given by Krzysztof Kozlowski
       a) Aligned the lines.

[PATCH v2 5/6] can: m_can: Add ECC functionality for message RAM
link: 
https://lore.kernel.org/lkml/20221109100928.109478-6-vivek.2311@samsung.com/
    1: Addressed review comment given by Krzysztof Kozlowski
       a) We are dropping this for now and will reconsider it's
          implementation and resend as separate patch.

[PATCH v2 6/6] arm64: dts: fsd: Add support for error correction code for
message RAM
link: 
https://lore.kernel.org/lkml/20221109100928.109478-7-vivek.2311@samsung.com/
    1: Addressed review comment given by Krzysztof Kozlowski
       a) Subject is updated and patch go via ARM SOC tree, we will
          resend this as separate patch along with ECC patch.

changes since v1:

[PATCH 0/7] can: mcan: Add MCAN support for FSD SoC 
    1: Addressed review comment given by  Marc Kleine-Budde
       a) Added my signed off.

[PATCH 2/7] dt-bindings: can: mcan: Add ECC functionality to message ram
link: 
https://lore.kernel.org/netdev/87k04oxsvb.fsf@hardanger.blackshift.org/ 
    1: Addressed review comment given by  Marc Kleine-Budde
       a) Added an example to the yaml that makes use of the 
          mram-ecc-cfg property.
       b) Added prefix to "mram-ecc-cfg" property and
          "$ref: /schemas/types.yaml#/definitions/phandle".

[PATCH 4/7] can: mcan: enable peripheral clk to access mram
link:
https://lore.kernel.org/netdev/20221021095833.62406-5-vivek.2311@samsung.com/
    1: Addressed review comment given by  Marc Kleine-Budde
       a) Moved mram init into m_can_dev_setup function by then
          clocks are enabled and prevent probe failure.
       b) Added the platform init ops in m_can_plat_ops and
          moved mram init into it.

[PATCH 5/7] arm64: dts: fsd: Add MCAN device node
link:
https://lore.kernel.org/netdev/20221021095833.62406-6-vivek.2311@samsung.com/
    1: Addressed review comment given by  Marc Kleine-Budde
       a) Added the DT people on Cc.

[PATCH 6/7] can: m_can: Add ECC functionality for message RAM
link:
https://lore.kernel.org/netdev/20221021095833.62406-7-vivek.2311@samsung.com/
    1: Addressed review comment given by kernel test robot.
       a) Addressed missing prototypes warnings.

    2: Addressed review comment given by  Marc Kleine-Budde
       a) Sorted the declaration of local variable by reverse Christmas 
          tree.
       b) Used syscon_regmap_lookup_by_phandle_args to get the syscon
          Base Address and offset.
       c) Used FIELD_PREP instead of logical operation.
       d) Used regmap_read_poll_timeout API to give timeout condition
          for ECC cfg done status instead of using while loop counter.
       e) Moved all the ECC mcaros in m_can.c file and changed the name
          with a common prefix M_CAN.
       f) Moved ECC init into platform init function called during m_can
          device setup.
 

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

