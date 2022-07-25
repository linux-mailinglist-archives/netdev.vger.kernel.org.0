Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AA857F925
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 07:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiGYFy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 01:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiGYFy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 01:54:27 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B16FD34
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 22:54:25 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id r8so1100935plh.8
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 22:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=CUnvk+Lk+BhBreaYLu6Ie/ZVU9GZUk+FaNJa6P9J/Vs=;
        b=d2VxcKhEZxa/EiJ8EzmqAvswfAAB7YS590sfaFGMD2zyBMBgVErcYK62Lxae1Tp5NO
         z2kV/ocqRIKD2/I1zrHwCSRY/iFv1pqxk/Zp+w695uCFWi+D7Xsgn0L4JceGqhTcogEV
         hWtyUB9rzOB+IPTTSXZjRLaW3DQKRD+Vbf+ww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=CUnvk+Lk+BhBreaYLu6Ie/ZVU9GZUk+FaNJa6P9J/Vs=;
        b=uPQ8BbW7dEs8SPLNbJcMw4t0dOtr1ZJrAXJZ67ezK00ol3Ugb8UqfBGFKkhSSOZISW
         aOTeYKGh3M3i5d8T65pBHkXJxLNHTDLmjVoUPmM1pSNGd8AZl9S0CmjqFZOCKbo3gxTi
         EgyCi34sNaZYn6quPsWvLe8ydZU148WxljhZtXkjx1BrJcDTEpyGc94Mh3j75BFUdLi1
         DBP2YgzTBWknGkfO7AjKm8joFoHjZMx/jK0Xpg+fU4NIKaVXo+51C59zood3sH4Wa5Pw
         nncfZQYrgYi+9o6Ze2ee5bJ+7nHYYNl+oE/TsMFYFWSvXSLiBGnh7uYSr7oevmmMhBFd
         7B+w==
X-Gm-Message-State: AJIora9u01hw13BVTQyKU7nON0qGCrMvlpaL8NsQjeXz2SVem0Ehj6Ct
        YP1waPOxSBY7p/y+hw+ryQ8fww==
X-Google-Smtp-Source: AGRyM1sYoEZ6EitovP2LZqqKLNHsNoQWEvqJ3kkwyghWLj+uEC3yJB+BbvOcaAOHcpDpXh1LUQXtVw==
X-Received: by 2002:a17:90b:1807:b0:1ef:8aa5:1158 with SMTP id lw7-20020a17090b180700b001ef8aa51158mr30666723pjb.163.1658728464761;
        Sun, 24 Jul 2022 22:54:24 -0700 (PDT)
Received: from ubuntu-22.localdomain ([192.19.222.250])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902bb8500b0016c4331e61csm8198910pls.137.2022.07.24.22.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 22:54:23 -0700 (PDT)
From:   William Zhang <william.zhang@broadcom.com>
To:     Linux ARM List <linux-arm-kernel@lists.infradead.org>
Cc:     joel.peshkin@broadcom.com, f.fainelli@gmail.com,
        Broadcom Kernel List <bcm-kernel-feedback-list@broadcom.com>,
        dan.beygelman@broadcom.com, anand.gore@broadcom.com,
        kursad.oney@broadcom.com, rafal@milecki.pl,
        krzysztof.kozlowski@linaro.org,
        William Zhang <william.zhang@broadcom.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-i2c@vger.kernel.org (open list:I2C SUBSYSTEM HOST DRIVERS),
        linux-mtd@lists.infradead.org (open list:MEMORY TECHNOLOGY DEVICES
        (MTD)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-pci@vger.kernel.org (open list:PCI NATIVE HOST BRIDGE AND
        ENDPOINT DRIVERS),
        linux-phy@lists.infradead.org (open list:GENERIC PHY FRAMEWORK),
        linux-gpio@vger.kernel.org (open list:PIN CONTROL SUBSYSTEM),
        linux-mips@vger.kernel.org (open list:BROADCOM BMIPS MIPS ARCHITECTURE),
        linux-serial@vger.kernel.org (open list:SERIAL DRIVERS),
        linux-watchdog@vger.kernel.org (open list:WATCHDOG DEVICE DRIVERS),
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v2 0/9] arm64: bcmbca: Move BCM4908 SoC support under ARCH_BCMBCA
Date:   Sun, 24 Jul 2022 22:53:53 -0700
Message-Id: <20220725055402.6013-1-william.zhang@broadcom.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f295e005e49ad011"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000f295e005e49ad011
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

BCM4908 is one of the Broadcom Broadband origin WLAN Router/Access
Pointer SoCs. It was originally added by Rafał before Broadcom started
to upstream the support for broadband SoCs. All other ARM based Broadcom
Broadband SoCs are now supported under arch ARCH_BCMBCA. This patch
series migrate the BCM4908 support to ARCH_BCMBCA.

Changes in v2:
- Add Acked-by tag
- Improve commit message with more details
- Insert the 4908 generic compatible string in alphabetical order

William Zhang (9):
  dt-bindings: arm64: bcmbca: Merge BCM4908 into BCMBCA
  dt-bindings: arm64: bcmbca: Update BCM4908 description
  arm64: dts: bcmbca: update BCM4908 board dts files
  arm64: dts: Move BCM4908 dts to bcmbca folder
  arm64: dts: Add BCM4908 generic board dts
  arm64: bcmbca: Make BCM4908 drivers depend on ARCH_BCMBCA
  arm64: bcmbca: Merge ARCH_BCM4908 to ARCH_BCMBCA
  MAINTAINERS: Add BCM4908 maintainer to BCMBCA entry
  arm64: defconfig: remove BCM4908

 .../bindings/arm/bcm/brcm,bcm4908.yaml        | 42 -------------------
 .../bindings/arm/bcm/brcm,bcmbca.yaml         | 25 +++++++++++
 MAINTAINERS                                   |  1 +
 arch/arm64/Kconfig.platforms                  | 10 +----
 arch/arm64/boot/dts/broadcom/Makefile         |  1 -
 arch/arm64/boot/dts/broadcom/bcm4908/Makefile |  5 ---
 arch/arm64/boot/dts/broadcom/bcmbca/Makefile  |  5 +++
 .../bcm4906-netgear-r8000p.dts                |  2 +-
 .../bcm4906-tplink-archer-c2300-v1.dts        |  2 +-
 .../broadcom/{bcm4908 => bcmbca}/bcm4906.dtsi |  0
 .../bcm4908-asus-gt-ac5300.dts                |  2 +-
 .../bcm4908-netgear-raxe500.dts               |  2 +-
 .../broadcom/{bcm4908 => bcmbca}/bcm4908.dtsi |  0
 .../boot/dts/broadcom/bcmbca/bcm94908.dts     | 30 +++++++++++++
 arch/arm64/configs/defconfig                  |  1 -
 drivers/i2c/busses/Kconfig                    |  4 +-
 drivers/mtd/parsers/Kconfig                   |  6 +--
 drivers/net/ethernet/broadcom/Kconfig         |  4 +-
 drivers/pci/controller/Kconfig                |  2 +-
 drivers/phy/broadcom/Kconfig                  |  4 +-
 drivers/pinctrl/bcm/Kconfig                   |  4 +-
 drivers/reset/Kconfig                         |  2 +-
 drivers/soc/bcm/bcm63xx/Kconfig               |  4 +-
 drivers/tty/serial/Kconfig                    |  4 +-
 drivers/watchdog/Kconfig                      |  2 +-
 25 files changed, 84 insertions(+), 80 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/bcm/brcm,bcm4908.yaml
 delete mode 100644 arch/arm64/boot/dts/broadcom/bcm4908/Makefile
 rename arch/arm64/boot/dts/broadcom/{bcm4908 => bcmbca}/bcm4906-netgear-r8000p.dts (96%)
 rename arch/arm64/boot/dts/broadcom/{bcm4908 => bcmbca}/bcm4906-tplink-archer-c2300-v1.dts (99%)
 rename arch/arm64/boot/dts/broadcom/{bcm4908 => bcmbca}/bcm4906.dtsi (100%)
 rename arch/arm64/boot/dts/broadcom/{bcm4908 => bcmbca}/bcm4908-asus-gt-ac5300.dts (97%)
 rename arch/arm64/boot/dts/broadcom/{bcm4908 => bcmbca}/bcm4908-netgear-raxe500.dts (89%)
 rename arch/arm64/boot/dts/broadcom/{bcm4908 => bcmbca}/bcm4908.dtsi (100%)
 create mode 100644 arch/arm64/boot/dts/broadcom/bcmbca/bcm94908.dts

-- 
2.34.1


--000000000000f295e005e49ad011
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
TltlrAeBKRJ1M9O/DY5v7L1Yrs//7XIRg/d2ZPAOSGBQzFYjYTFWwNBiR1s1zP0m2y56DPbS5gwj
fqAN/I4PJHIvTh3zUgHXNKadYoYRiPHXfaTWO9UhzysOpQIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRp3aWxsaWFtLnpoYW5nQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUohM5GmNlGWe5wpzDxzIy
+EgzbRswDQYJKoZIhvcNAQELBQADggEBACKu9JSQAYTlmC+JTniO/C/UcXGonATI/muBjWTxtkHc
abZtz0uwzzrRrpV+mbHLGVFFeRbXSLvcEzqHp8VomXifEZlfsE9LajSehzaqhd+np+tmUPz1RlI/
ibZ7vW+1VF18lfoL+wHs2H0fsG6JfoqZldEWYXASXnUrs0iTLgXxvwaQj69cSMuzfFm1X5kWqWCP
W0KkR8025J0L5L4yXfkSO6psD/k4VcTsMJHLN4RfMuaXIT6EM0cNO6h3GypyTuPf1N1X+F6WQPKb
1u+rvdML63P9fX7e7mwwGt5klRnf8aK2VU7mIdYCcrFHaKDTW3fkG6kIgrE1wWSgiZYL400xggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgw28eX6TfvsbNfu
SIMwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILer9jQuHf6pVnxUr9zSbV3iIn1S
jXq18F3fWWJ+K/4QMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIy
MDcyNTA1NTQyNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQAyXp/SrqjOvFbUtGATlB9CAN4BZxm2xl17vgYK6ySlmQUE
eAcGfcstrmfEFhBqfuyKiCvF1eue7ZwVaBKg1dsyxbk7JssWlaGY9f4Qobst6gWwAndIX4q88SZq
ggKvMZYHAM0ZGUHhVzF9UJ6dVPLrCspfq9OAPh/gFNgr/WQCl50zZmfTljEFBeAUCeh4u4smBrLF
pmhFVdjEf8tkHhifbNlac8b4lRKpALlN9IrsnMsFroXE6wT+CgHzay99Ox0SiWNgXFFTFw6nYxhZ
nEcU5AN/LFvi+Abt4mcim5ZcQHNJ/im/wZERDyAAoZrI+BgFeXwEm0kGWyPlXWl/makd
--000000000000f295e005e49ad011--
