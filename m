Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263305B0B1B
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 19:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiIGRJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 13:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiIGRJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 13:09:50 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1723AB3E;
        Wed,  7 Sep 2022 10:09:47 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id AF6883200805;
        Wed,  7 Sep 2022 13:09:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 07 Sep 2022 13:09:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1662570583; x=1662656983; bh=lEMgyuskMd
        HHSxUE4iU5Q9az2x12J7mJ4G0YEW9bdmY=; b=6DdqzQcWCUDxwh08S9lzK0/F3/
        2T4RE5qzIZGJmTYC/BMZRp4yprwzfDorrdR6aGj7WLZqZ309f0JVA9tvMYzNdSti
        DGyMzqkzCehl1khYrIWhQuKquRyPMfSaVyIHq9VG0GUTp1w07Twmxp4RbdhdkcuX
        rnyfdPu+6mYOkcCbeEaq5gXeTL44E5KgPv56xvOAOOJp4N7y9T0Nck6U7Vi3sKqB
        7AhvaVN8Y0CE3J+Qj4g4zg2C8XOOorU0+Or4CYTrX+vhGgbvSBHhLvtiCKBVah1i
        Q8TO+i/K4J/aLZMo96fD7AOgNibf6P1+4Q257fwpgvtkbMc6CkuWL3HVEhPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1662570583; x=1662656983; bh=lEMgyuskMdHHSxUE4iU5Q9az2x12J7mJ4G0
        YEW9bdmY=; b=1xyVMiCf/OS3T6kbat1VPmsNuBWqnWvuMY05PBBxzFePRrkIW+H
        DPYJPyTVGWGfCHmzMfmC0eezzk1tdd8o5Jaw1+yTqampY0OiPAHJ+EygSgFyc4eT
        vaiyOjUyaWZxSLqNzAZ2PCZz96WP2Vf42jpWnb/Y5lbg45Zk5OTUhcwNsjLWpuln
        lNSwhxUtLqtjzVxOYZf+9Y054QQZXOvn+bGFKL1Dxe458X04RLHXdm3d/jTN87Ey
        beiNT024ky8y3mXi9tDmov6+/Zwnh2B95oGGsAGKjMkKA0iICy2ABUxbpKePg8rC
        CA5YdX/WQsZZRRptsUB7F+rABNTnNYd6v3g==
X-ME-Sender: <xms:VtAYY0Dgw1jmikCM9R2W3EmOj3BcSIsQbOYQvuzDlvPyztERjaH_wg>
    <xme:VtAYY2gX1knX2Do8O6baN2Ho4_2VOV8awORVpxvyjPo77tqDAztY3-EpMDFQZV_ab
    oWJZCySPepuTulEDqA>
X-ME-Received: <xmr:VtAYY3m_b4Su6M3qVwvoVB9mQdsc9Op5l2wS1tkFoPTnycpAsCSNcw-lL4mXDcbyeiHRL6EmAgrzixVZq4WY5Fx4NZmd57xP_OOoHbDF0tf4jdhhHtnu-uk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedttddguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefuvhgvnhcu
    rfgvthgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrthhtvg
    hrnhepgfegudffudelfeeugedtjeeugeehueffudevveegveektdfhueehueeufeelheev
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehsvhgvnhesshhvvghnphgvthgvrhdruggvvh
X-ME-Proxy: <xmx:VtAYY6yoCoD1eaLJHNOVLnZ9Bv_wYUTeOujxDM7vBAZjG4HTjYiLuQ>
    <xmx:VtAYY5Qd6PrPh_22--TkK7QQ1RtJVbKvoGLxXoLB3WlNjCWMWF5m3w>
    <xmx:VtAYY1YsvnwDQYodwF7cNNzrzP5MYRgBsHHyDTwAVsQ7KnLy3Fp-Pg>
    <xmx:V9AYY6BJTNJ6kioNeMu14tXHSdvm8MPK4kHpl0BoNRHahGHQ4Mb_NQ>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Sep 2022 13:09:39 -0400 (EDT)
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
Subject: [PATCH v2 0/5] Broadcom/Apple Bluetooth driver for Apple Silicon
Date:   Wed,  7 Sep 2022 19:09:30 +0200
Message-Id: <20220907170935.11757-1-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

v1: https://lore.kernel.org/asahi/20220801103633.27772-1-sven@svenpeter.dev/

Here's v2 of the Apple/Broadcom Bluetooth series. Most changes from
v1 are only related to the device tree bindings. Other than that I fixed
a few minor bugs and adjusted some commit messages to make checkpatch
happier.


Best,


Sven

Sven Peter (5):
  dt-bindings: net: Add generic Bluetooth controller
  dt-bindings: net: Add Broadcom BCM4377 family PCIe Bluetooth
  Bluetooth: hci_event: Add quirk to ignore byte in LE Extended Adv
    Report
  Bluetooth: Add quirk to disable extended scanning
  Bluetooth: hci_bcm4377: Add new driver for BCM4377 PCI boards

 .../bindings/net/bluetooth-controller.yaml    |   30 +
 .../devicetree/bindings/net/bluetooth.txt     |    5 -
 .../bindings/net/brcm,bcm4377-bluetooth.yaml  |   78 +
 .../bindings/net/qualcomm-bluetooth.yaml      |    4 +-
 .../bindings/soc/qcom/qcom,wcnss.yaml         |    8 +-
 MAINTAINERS                                   |    2 +
 drivers/bluetooth/Kconfig                     |   12 +
 drivers/bluetooth/Makefile                    |    1 +
 drivers/bluetooth/hci_bcm4377.c               | 2515 +++++++++++++++++
 include/net/bluetooth/hci.h                   |   21 +
 include/net/bluetooth/hci_core.h              |    4 +-
 net/bluetooth/hci_event.c                     |    4 +
 12 files changed, 2671 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth-controller.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/bluetooth.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
 create mode 100644 drivers/bluetooth/hci_bcm4377.c

-- 
2.25.1

