Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56115BD271
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 18:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiISQtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 12:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiISQte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 12:49:34 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C823E9C;
        Mon, 19 Sep 2022 09:49:32 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 46B275C03E7;
        Mon, 19 Sep 2022 12:49:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 19 Sep 2022 12:49:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1663606169; x=1663692569; bh=rvgpBluXZT
        aqb3vna+uXxT40xAPq8i61oRknfT3+QiA=; b=k1ff9CnKfVsS4VBMjTqgBD4j3A
        UOLsHp2MPoE5fmyt0z9n6+RoCn0MmiSG/YSvY5HhOISkFjHCewYpCOJBgkshDEHD
        enmX86JToHyUpTX4Fa1IKtoWTimfTTIQsfwycclE7ZF0BwuYnKme9lDMMQJpvA0n
        h1j687PK2gaYht9qGgyiAoAdZjG4yE4MB+99h+QUH6tcKI9H1uaQNDdrCgWjTumZ
        aWJxD3bjWt2X00Ld9JfwpsmPm0OOLDVkQZpzZW63kJEk5YnCIRh9TWQHLW4n91rG
        RFcbZ3ZrE3SAr1nup2dPpDjogOZ7fm1dWOQzc2meg60rTN28xFwcTsgE1XCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1663606169; x=1663692569; bh=rvgpBluXZTaqb3vna+uXxT40xAPq8i61oRk
        nfT3+QiA=; b=W+b6OIYTxMsmoRsH9ArlYD2aTT7HrtURx/WHqUAA2Kgjuitw0Iw
        nKccfgoSmQ0gXx9aFuHrq85zmU4AjIDn5MCRk9VVVnO6vPvsjLXhO2om8zCmBBHL
        UReNvnsG6ynCjWc3Slu971dR6WAYxWnMOpo5uhFReUQR7QHdIELFvtUFoOE6u/b5
        3/J+wiuu5w73B9I3pmtwNtVkJAqpDZGGwwBmlBMknjZ6v2rn1j7rYmFARqIyhM1z
        EIGvX6CCd+fUcS9kfT6lKLF6lTb9MKvLwHaGM26OnAu+837PmqClDhHfZcKAAYa9
        MfymZbfeAgx9g0JgN9XVhe0O/UmeuSrgTSQ==
X-ME-Sender: <xms:mJ0oY0iANcMMWK2y9a13EsaayPrqDnHueHs1npaN1Zpw4ORY1UAUyw>
    <xme:mJ0oY9BqXinZY8_1p4Ufd1g06UEz1CDLTm9b7UGjGrGpAy1hT5cqloneNwrJOgbtY
    jzr7Li9x1mf45HDoVM>
X-ME-Received: <xmr:mJ0oY8GySkBhq7srD9YXjKB7qs0xcs9L-fSMc5kdHTj6OuetBJG9OrBbUgi0vbNzubxsTWWldsX0y3zhxifud3nqueFSp_6U4PQi4l4OwaEHvKIFmhR9gyk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvjedguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefuvhgvnhcu
    rfgvthgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrthhtvg
    hrnhepgfegudffudelfeeugedtjeeugeehueffudevveegveektdfhueehueeufeelheev
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehsvhgvnhesshhvvghnphgvthgvrhdruggvvh
X-ME-Proxy: <xmx:mJ0oY1TuNuk8xtwnw6tW2a1beaaNcxvKRvqL5aWr_5NmDbeLsvN5NA>
    <xmx:mJ0oYxy2NnB40sXLpZ6pDdWW9_jV3taDz_7oJYhY8X9GkPQJyEpaZQ>
    <xmx:mJ0oYz5On5nutPy78fikvvmdCzAzN0OtvWOKhzFsuC6L0SSg3N4exw>
    <xmx:mZ0oY-j_lP21-bk-pDhx2M70EZMjQ1qPXJNNfBiuh_yKj70AtncKLQ>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Sep 2022 12:49:25 -0400 (EDT)
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
Subject: [PATCH v3 0/7] Broadcom/Apple Bluetooth driver for Apple Silicon
Date:   Mon, 19 Sep 2022 18:48:27 +0200
Message-Id: <20220919164834.62739-1-sven@svenpeter.dev>
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

Here's v3 of the Apple/Broadcom Bluetooth series. Again most changes are
to the device tree bindings. I've also included the changes to the dts files
that I forgot for the last two versions.

Additionally I had to introduce another quirk since these controllers also claim
to support MWS Pattern Configuration but then simply disallow that command. This
used to be silently ignored by the bluetooth core but fails during setup
now since b82a26d8633cc89367fac75beb3ec33061bea44a.


Best,


Sven

Sven Peter (7):
  dt-bindings: net: Add generic Bluetooth controller
  dt-bindings: net: Add Broadcom BCM4377 family PCIe Bluetooth
  arm64: dts: apple: t8103: Add Bluetooth controller
  Bluetooth: hci_event: Ignore reserved bits in LE Extended Adv Report
  Bluetooth: Add quirk to disable extended scanning
  Bluetooth: Add quirk to disable MWS Pattern Configuration
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
 drivers/bluetooth/hci_bcm4377.c               | 2513 +++++++++++++++++
 include/net/bluetooth/hci.h                   |   21 +
 include/net/bluetooth/hci_core.h              |    4 +-
 net/bluetooth/hci_event.c                     |    2 +-
 net/bluetooth/hci_sync.c                      |    2 +
 19 files changed, 2699 insertions(+), 15 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/bluetooth.txt
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/bluetooth-controller.yaml
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/brcm,bcm4377-bluetooth.yaml
 rename Documentation/devicetree/bindings/net/{ => bluetooth}/qualcomm-bluetooth.yaml (96%)
 create mode 100644 drivers/bluetooth/hci_bcm4377.c

-- 
2.25.1

