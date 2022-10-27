Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C93D60FB3A
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 17:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235848AbiJ0PIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 11:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235875AbiJ0PIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 11:08:37 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C006718F0E9;
        Thu, 27 Oct 2022 08:08:33 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id D77B232007F9;
        Thu, 27 Oct 2022 11:08:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 27 Oct 2022 11:08:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1666883311; x=1666969711; bh=vC4EJLdx4T
        Hqc58ycxGM/foR8da3d1iXJ0tw75QGCxM=; b=P4Y9IkypgiQFH2P4QbCJdfibEw
        sym3gHqN0WnfXFlua3ywxKU52tv24gAQHkiBixMnfw8O+W9aRZHCXe+NgH5g0I6w
        RWa9HTZinjcSImobmPGJXvFIWa18gv7y/iEyClKj3VHav3S5ZcrGcDEf3rLPZJ//
        wKMIpJkgQL8xlLh5z9R84M+jKIWVezwXQFCo18xfC3X7u4PODu4C5X0IjghdxXW0
        qPUAFwuR0WEUEEyNvcCBsgNaojSpm+1a0QpdioYRmypCTYbw1Erz2V3nL0/PiY4t
        n44/QY75bwlCLRt7PTrEREx/b07a2B3IeqO7E5c+0jspMtPLNShQ03RVBwqA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1666883311; x=1666969711; bh=vC4EJLdx4THqc58ycxGM/foR8da3d1iXJ0t
        w75QGCxM=; b=oTLERddpI5B6yecHwlVQA4APnAUOMqQTVdRSHvmsFIOJ2QJZxBd
        aXJVIVQW4yCr5CBYu3FuhOknknE5lVWe8gDOOySWUOfE+n2pQHBNoGY7S+CjEiTF
        BB+T/l4sKsFjMoK+hNDpZoAowH64wP/2FtAsHgDrIXr6M74DYqcvDFaBROmST33Z
        K9R+27oGvA4FyA0Nj3ZnkxXqvx/VmVTb7gPCwRqw4aih8fwuEj0iO9xt8r44w/nj
        /TM4l7eRpFK8shYF04EJkghdYn6MW+TlF445rh8rMFHFgFDcocn1EqKpsLcCPjYI
        KmGCdO1r64hFBpkY4rVuV9O/K66hUu+q/fA==
X-ME-Sender: <xms:7J5aYzCqjdEffKZIPz13VojvXF_6sCIbJsRnS6H3hdw1VFwdjz3rhA>
    <xme:7J5aY5iybkyXc-yxoyHq017XEKq6ZiSzCBSN2hBAjmwIGGoXoMk7wAVWCreyfcQfF
    7lz3ZZJAII7awgXLgk>
X-ME-Received: <xmr:7J5aY-nyFmsyJiUAlZJYLd7nZeBJOd2-5gUA42WHjppRctgZq-2ABZdKXI8fdsFMp43TQmKdWLM0IAJwsBii3L_NDpOgGXjA96TgqHd3eR5iU2NZm_Ex5DA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdeggdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefuvhgvnhcurfgv
    thgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrthhtvghrnh
    epgfegudffudelfeeugedtjeeugeehueffudevveegveektdfhueehueeufeelheevnecu
    ffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehsvhgvnhesshhvvghnphgvthgvrhdruggvvh
X-ME-Proxy: <xmx:7J5aY1wvsnjLBTpLMsc0RV8XRxk7GH_KepDE6MBwFsT8cw2WDEbsOg>
    <xmx:7J5aY4SWfiduWwA0ZDOJE0FFIXCBs69wp05dckwxQpal57ThwBNZFA>
    <xmx:7J5aY4ZKt0ZEhfPTP234B8wk734AVsdjrovLVS-mU5JpDOg2hF54-A>
    <xmx:755aYxC3KxmlMAQPPW8-jSRVEAoBEvKxKueYodMNG4luFOZ0nUqUuQ>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Oct 2022 11:08:26 -0400 (EDT)
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
Subject: [PATCH v4 0/7] Broadcom/Apple Bluetooth driver for Apple Silicon
Date:   Thu, 27 Oct 2022 17:08:15 +0200
Message-Id: <20221027150822.26120-1-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

v1: https://lore.kernel.org/asahi/20220801103633.27772-1-sven@svenpeter.dev/
v2: https://lore.kernel.org/asahi/20220907170935.11757-1-sven@svenpeter.dev/
v3: https://lore.kernel.org/asahi/20220919164834.62739-1-sven@svenpeter.dev/

Here's v4 of the Apple/Broadcom Bluetooth series. Not many changes this
time: I rebased on 6.1, added Rob's r-b tags and fixed bcm4377_send_ptb
for newer firmware versions where that command claims to fail but is
still sent by macOS.


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
 include/net/bluetooth/hci_core.h              |    4 +-
 net/bluetooth/hci_event.c                     |    2 +-
 net/bluetooth/hci_sync.c                      |    2 +
 19 files changed, 2700 insertions(+), 15 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/bluetooth.txt
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/bluetooth-controller.yaml
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/brcm,bcm4377-bluetooth.yaml
 rename Documentation/devicetree/bindings/net/{ => bluetooth}/qualcomm-bluetooth.yaml (96%)
 create mode 100644 drivers/bluetooth/hci_bcm4377.c

-- 
2.25.1

