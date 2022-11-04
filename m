Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B13A61A2F8
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 22:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiKDVNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 17:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiKDVNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 17:13:18 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D7F49B75;
        Fri,  4 Nov 2022 14:13:17 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 68AD232003CE;
        Fri,  4 Nov 2022 17:13:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 04 Nov 2022 17:13:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1667596394; x=1667682794; bh=TqGMxywMgm
        HuJraQB6n7bVGxu69m0CQn0z5Ubyt0RJs=; b=mkR1+bjB7aKu/2IufpfGFVld1k
        uqkK2Eyyx2FCVKVFzI6L76ic4oi+1HM7U9xXRFiLD/OG3BYBDVCcRtSk08/0X2J8
        OwE+lZOdJYeveVb52DRnoW3MbWFtFw5qR2ngwelJa56SrXi8EXMeS2/oEF7USHk0
        O+J2A6vm0qVE7K5g79iSOMZvo4KpJ4bx9YyylzMmElpdqICNmM1mPPPelvVk6g2W
        Sef6Qr8VJdv/gmXkFuEwTzQQfwXOKV+tGjbpP3LhwtwQOLXcZnhaYwxovjl+6/es
        L6TRXdGkTBsoqGfVNGH/gqZNozV/V70Nesk1jxlWy9GdJtRfyMolUruIAKxQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1667596394; x=1667682794; bh=TqGMxywMgmHuJraQB6n7bVGxu69m0CQn0z5
        Ubyt0RJs=; b=YFVFfaCEDgjRKDRWis7goaAkn1Ti/JigxYb/RJ1Q1hmmGJyd2fv
        vhllWsTG6ZRsT13Mk7yNkGtmIBNXjE1X99a1gUAX9yhvpJckq5n8s/3f3wRW23m4
        NDsAm6X3qZcKdKPOkCF7PgEioJDDwOZrMgsybs9L2BbD6GhMhAn4iJ+0emvh4AXg
        K1wZoTBK2Z5JORLz/MFCD2juVJI3ppQiTDDIeuNu4z38Z7ACWySXshejHbyRZDaJ
        He1h77p7RevBJFsk//ni8d4d4K0uujQ4E1T5HDYnYGtdNNHFzeegWAymT0EKOWpM
        jSZmoFuauEKP7UwDpMzNzTvX09MAfU7eBgQ==
X-ME-Sender: <xms:aYBlY0zLda49tx_gjsifAPLvY0SMoV9aCEy7vFxwscfw6zZ7FakqJg>
    <xme:aYBlY4Tz07Zz7NuvBBjYCahbVJ6iWtuPEhEy1CCfV-0f3zedxLbaWjdCd9QiH9pnx
    eHUoY_q-ESB6z1INC4>
X-ME-Received: <xmr:aYBlY2WfFzIP7SSyDi03MMpM26WwIHHuOr1pAj3GxT32O_VEgRW_NwJXo3xHnpibm7D6zsGBWoWqMpIQeVO4WxmpmDPL_VptlmfXhmpxf8NbCaVpCAB0mx0yypJbFA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvddugddugeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepufhvvghnucfr
    vghtvghruceoshhvvghnsehsvhgvnhhpvghtvghrrdguvghvqeenucggtffrrghtthgvrh
    hnpefggeduffduleefueegtdejueegheeuffduveevgeevkedthfeuheeuueefleehveen
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepshhvvghnsehsvhgvnhhpvghtvghrrdguvghv
X-ME-Proxy: <xmx:aYBlYygIQ1mE5rVGfcfJO2zfdmYFjCsTMx1V7C1lkpVVaOtvO9HqUA>
    <xmx:aYBlY2AtAqwTnQvCezi-K-42r_CpjQmLlmY81dG_dLXVRDQTW__hOg>
    <xmx:aYBlYzIuGMe9i4LdqORhbfdUuc8HA0-O9b8j4EBe1g2ODEI2Z7iK4w>
    <xmx:aoBlYwzuzurPG4ogtasRi-BJKjYnzJMSWKac2Urwl2WbPih3KXlPXQ>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Nov 2022 17:13:10 -0400 (EDT)
From:   Sven Peter <sven@svenpeter.dev>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/7] Broadcom/Apple Bluetooth driver for Apple Silicon
Date:   Fri,  4 Nov 2022 22:12:56 +0100
Message-Id: <20221104211303.70222-1-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

v1: https://lore.kernel.org/asahi/20220801103633.27772-1-sven@svenpeter.dev/
v2: https://lore.kernel.org/asahi/20220907170935.11757-1-sven@svenpeter.dev/
v3: https://lore.kernel.org/asahi/20220919164834.62739-1-sven@svenpeter.dev/
v4: https://lore.kernel.org/asahi/20221027150822.26120-1-sven@svenpeter.dev/

Here's v5 of the Apple/Broadcom Bluetooth series. Even less changes this
time: I only added a macro for the MWS transport config quirk.


Best,


Sven

Sven Peter (7):
  dt-bindings: net: Add generic Bluetooth controller
  dt-bindings: net: Add Broadcom BCM4377 family PCIe Bluetooth
  arm64: dts: apple: t8103: Add Bluetooth controller
  Bluetooth: hci_event: Ignore reserved bits in LE Extended Adv Report
  Bluetooth: Add quirk to disable extended scanning
  Bluetooth: Add quirk to disable MWS Transport Configuration
  Bluetooth: hci_bcm4377: Add new driver for BCM4377 PCIe boards

 .../devicetree/bindings/net/bluetooth.txt     |    5 -
 .../net/bluetooth/bluetooth-controller.yaml   |   29 +
 .../net/bluetooth/brcm,bcm4377-bluetooth.yaml |   81 +
 .../{ => bluetooth}/qualcomm-bluetooth.yaml   |    6 +-
 .../bindings/soc/qcom/qcom,wcnss.yaml         |    8 +-
 MAINTAINERS                                   |    2 +
 arch/arm64/boot/dts/apple/t8103-j274.dts      |    4 +
 arch/arm64/boot/dts/apple/t8103-j293.dts      |    4 +
 arch/arm64/boot/dts/apple/t8103-j313.dts      |    4 +
 arch/arm64/boot/dts/apple/t8103-j456.dts      |    4 +
 arch/arm64/boot/dts/apple/t8103-j457.dts      |    4 +
 arch/arm64/boot/dts/apple/t8103-jxxx.dtsi     |    8 +
 drivers/bluetooth/Kconfig                     |   12 +
 drivers/bluetooth/Makefile                    |    1 +
 drivers/bluetooth/hci_bcm4377.c               | 2514 +++++++++++++++++
 include/net/bluetooth/hci.h                   |   21 +
 include/net/bluetooth/hci_core.h              |    7 +-
 net/bluetooth/hci_event.c                     |    2 +-
 net/bluetooth/hci_sync.c                      |    2 +-
 19 files changed, 2702 insertions(+), 16 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/bluetooth.txt
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/bluetooth-controller.yaml
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/brcm,bcm4377-bluetooth.yaml
 rename Documentation/devicetree/bindings/net/{ => bluetooth}/qualcomm-bluetooth.yaml (96%)
 create mode 100644 drivers/bluetooth/hci_bcm4377.c

-- 
2.25.1

