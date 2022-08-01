Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B557586798
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 12:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbiHAKjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 06:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiHAKju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 06:39:50 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C6A371AC;
        Mon,  1 Aug 2022 03:39:48 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 552EC5C00AD;
        Mon,  1 Aug 2022 06:39:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Aug 2022 06:39:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1659350386; x=1659436786; bh=5N+P+uu34i
        ZeTYcpkg2jYR2uZmItonEos0m6YTpfzu0=; b=mCzer7m4QsB1e3qgd83IDCkYsx
        iQRbKpSzQEZdQ7TOd0MDVQNXvZHiEikPYo38IIYcs7xninbSOCKHNU5jeSau6TEu
        YIVM0uyoq9htXPkHYveG+FPHKVljqDE4QE4ucf+OgIluZiSpDmFyS35xFcUnMnOf
        yLdzs/memsn4BCFn6SgHokspsAyqOyi5CWKcRAfcmYauRdEMOTh+A2Esa15uSsMZ
        e2IqQ2eBXgeT2yUjpgPy25nTiI9ofe4jpnA/9oPejRIxcGGIRsv8NNYPvvrenaHo
        uCkmTeqWNnj+av/F8QMS3EWyhIuFLlkFnX8jJrC+k9cH6fo52yBGyuGMhCgA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1659350386; x=1659436786; bh=5N+P+uu34iZeTYcpkg2jYR2uZmItonEos0m
        6YTpfzu0=; b=DHhj3QgQZkrTRktkHBPA/kaxSeR1BbODhdr83U/jsX7JIBA4g54
        wA50Ze3sWbrZ1EO8Vm6Nevvd+TkcKqcjuo1th3bOdx95FiFQ5dPZwUUXBZEc0VM2
        SaCzjD+3S2TB/onEeYl3c+oK0GZg3ay2SVQGZL4Kyu7dOpYT2v7vKtKDCJBNDcSM
        3J0jMcVqcfrPhhsVofR55vn6RBMZ+YBStk6lGyLkhwE38GdIPGBf/KTIckBbKDmE
        i/GK4kLJmDpt5W83HcwWo/3E1TImbP44+TLPgvCJrB01mKloOCbSZ+uaC7JDsVKm
        7uZgzuptjsvduiA28EQ0IrJElvdHypwx/Rg==
X-ME-Sender: <xms:ca3nYu_pkB-zgCcevLJJyx1KVgALjeg3DpI_hKj8hOa_qUk3ith9Cw>
    <xme:ca3nYutwKtW-u-9GlJDZNDlPwypOp5jfiO6hyg0O17dJmn6WasybJxlRgt_0gzmtg
    EM5skbEqsE27mq7wiU>
X-ME-Received: <xmr:ca3nYkCOib7Q5Dldn7wFt9M4_KOgd9xzp3agTHl3lCZppIzHJ-7AUeKX2bgxDr136Fe370WEt-kdhBgMpBlgCxhsjtzDRguEJQh9uxySpAS1W3tYTKkawTU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddvfedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepufhvvghnucfr
    vghtvghruceoshhvvghnsehsvhgvnhhpvghtvghrrdguvghvqeenucggtffrrghtthgvrh
    hnpeejuefgheejlefhvdffudefjeevveehteetuddtgfekgeejtdfhhfdvleehueeiveen
    ucffohhmrghinhepghhithhhuhgsrdgtohhmpdgslhhuvghtohhothhhrdhphienucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsvhgvnhesshhv
    vghnphgvthgvrhdruggvvh
X-ME-Proxy: <xmx:ca3nYmd9Qp5Wd3NHhVbnP77MXjNbmRb7Hd9tegNdBlYdp_o-HENrTQ>
    <xmx:ca3nYjOzMUivhaQK0aAicFXYUVUQEJFftAWGPoRWz1BLbsmBOPYcew>
    <xmx:ca3nYgm7E1IfWhzg-Wvht6ffKXYQ5BgLPeS8kzenBBzmplLtOWyF9g>
    <xmx:cq3nYgcCDuhOSx4e8itk-bzhL45xldfDm-sR_NXMW7pdhsO_InZQNg>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Aug 2022 06:39:43 -0400 (EDT)
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
Subject: [PATCH 0/5] Broadcom/Apple Bluetooth driver for Apple Silicon
Date:   Mon,  1 Aug 2022 12:36:28 +0200
Message-Id: <20220801103633.27772-1-sven@svenpeter.dev>
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

This series adds support for the Broadcom 4377/4378/4387 PCIe Bluetooth
controllers found in some Apple x86 and all Apple M1/M2 machines.
These are part of the Bluetooth/WiFi module connected via PCIe which exposes
two functions.

Unlike regular Broadcom chips attached over UART or SDIO these no longer
support the usual patchram / minidriver firmware loading. Instead the
firmware is just directly mapped to the PCIe device and then booted.
In general the entire PCIe configuration space is similar to brcmfmac (or the
Android downstream bcmdhd driver). There are not many similarities with UART
Broadcom devices.


The firmware naming itself is a bit annoying but similar to the WiFi
function / brcmfmac: We need the chip id (e.g. 4377), the chip stepping
(e.g. b3), the module name (e.g. apple,atlantisb) and the antenna vendor (e.g.
m for Murata) to select the correct firmware file.

For 4377 so far only one board type exists and unlike WiFi there's no ACPI
companion from which we could get it. It's just hardcoded in the driver for
now but if you prefer I could also use DMI matching to get it.

For 4378/4387 found in Apple Silicon machines we store the board name and some
calibration data in the device tree. Unlike 4377 they also need the BD address
to be manually configured. I've added a generic Bluetooth controller binding to
replace bluetooth.txt for that.

The other parameters can be read from the OTP exposed in one of the BARs.

We unfortunately can't distribute the firmware itself but we can extract it from
the official macOS update packages Apple distributes. Our installer for
M1/M2 extracts the latest firmware and prepares it for Linux (and BSD)
automatically [1].

These chips use a protocol called "Converged IPC" based on shared memory
to transport messages to and from the host. It's unclear if this is all
Broadcom or a collaboration between Broadcom and Apple since some strings
in the debug output of macOS call the protocol "Apple Converged IPC" instead.

Once the chips have been booted and set up correctly the HCI packets themselves
are simply transported using ring buffers. Two quirks are required though:

	- BCM4377 claims to support extended scanning but then doesn't implement
	  the commands. The first quirk just disables it.

	- BCM4378/4387 use the upper byte of the event type field in the
	  LE Extended Advertising Report to store the channel on which the
	  frame was received. It's unclear if this is intentional or a bug
	  in the firmware. Usually these bits are reserved and should be set
	  to zero and the quirk just masks them to ensure the rest of the stack
	  can handle the packets.


This has been tested by quite a few people on various M1/M2 machines and a few
people with x86 T2 machines.
So far we only know that WiFi/Bluetooth coexistence is not working yet, but that
needs to be configured inside brcmfmac as far as we can tell.

There was also a single report on a T2 macbook where brcmfmac didn't work when
it was loaded before this driver but I haven't been able to investigate this in
detail. Other people reported no such issues and either way this driver
won't change much even if this issue was confirmed.



Best,


Sven


[1] https://github.com/AsahiLinux/asahi-installer/blob/main/asahi_firmware/bluetooth.py

Sven Peter (5):
  dt-bindings: net: Add generic Bluetooth controller
  dt-bindings: net: Add Broadcom BCM4377 family PCI Bluetooth
  Bluetooth: hci_event: Add quirk to ignore byte in LE Extended Adv
    Report
  Bluetooth: Add quirk to disable extended scanning
  Bluetooth: hci_bcm4377: Add new driver for BCM4377 PCI boards

 .../bindings/net/bluetooth-controller.yaml    |   30 +
 .../devicetree/bindings/net/bluetooth.txt     |    6 +-
 .../bindings/net/brcm,bcm4377-bluetooth.yaml  |   77 +
 MAINTAINERS                                   |    2 +
 drivers/bluetooth/Kconfig                     |   12 +
 drivers/bluetooth/Makefile                    |    1 +
 drivers/bluetooth/hci_bcm4377.c               | 2466 +++++++++++++++++
 include/net/bluetooth/hci.h                   |   21 +
 include/net/bluetooth/hci_core.h              |    4 +-
 net/bluetooth/hci_event.c                     |    4 +
 10 files changed, 2617 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth-controller.yaml
 create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
 create mode 100644 drivers/bluetooth/hci_bcm4377.c

-- 
2.25.1

