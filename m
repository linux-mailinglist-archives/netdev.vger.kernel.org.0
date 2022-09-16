Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C515BB0AE
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiIPQBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiIPQBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:01:51 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E00BB5309;
        Fri, 16 Sep 2022 09:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3EsgdYxv3bAdply+WFCCtrGgnDOEs6JuczlAlI2uTl4=; b=kEetesxUQx2vEXBflfgLiCWQim
        ZEzzOcc/JoyjhMYKsDlBNmcX7LkGLuyRPB8pT3TSf4inL5UhWAcEN2SjGZj4ZTuX7wZHL1LZGpj96
        /D2a8xLAIj/2rJ+jZ8gnkOU3gCwwOjEZGogV53m0L7pAdNSsLLwEzqEIR8UGyr3CEyrOEUe8JJMFD
        wxhqv7MkYzv6O3rd0o/4Jhq2WxvAzHOrQ8uVLda1rWehoR/iwYhpaIcetQflkolQJ3knqwcAl03+D
        fWQwzLGd6sn7aUxCX3mseU7b0mYNExNuJ7s7t7a0d6U3YVxEbJZ6GnC+S2MFoRhaxAotbjAlgPqnO
        FDdvGeBw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34366)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oZDmc-0006sb-Ql; Fri, 16 Sep 2022 17:01:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oZDmY-0003fR-A3; Fri, 16 Sep 2022 17:01:34 +0100
Date:   Fri, 16 Sep 2022 17:01:34 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Cc:     Alyssa Rosenzweig <alyssa@rosenzweig.io>, asahi@lists.linux.dev,
        brcm80211-dev-list.pdl@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        SHA-cyfmac-dev-list@infineon.com, Sven Peter <sven@svenpeter.dev>,
        van Spriel <arend@broadcom.com>
Subject: [PATCH wireless-next v3 0/12] Add support for bcm4378 on Apple
 platforms
Message-ID: <YySd3pASZKUh4leX@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series adds support for bcm4378 found on Apple platforms, and has
been tested on the Apple Mac Mini. It is a re-posting of a subset of
Hector's previous 38 patch series, and it is believed that the comments
from that review were addressed.

Note: this is part of a larger patch set. The DT bindings are used on
OpenBSD, and all properties, including brcm,cal-blob, are in use there,
and will be used by further patches for Linux.

(I'm just the middle man; please don't complain if something has been
missed.)

v3:
- removed blank line in patch 7
- added description of "strip_mac" in patch 8
- added reviewed-bys and acked-bys
- added explanantion of "brcm,cal-blob" to cover message
v2:
- sending for wireless-next
- fixed up %ld -> %zd for size_t
- added reviewed-bys

 .../bindings/net/wireless/brcm,bcm4329-fmac.yaml   |  39 +-
 arch/arm64/boot/dts/apple/t8103-j274.dts           |   4 +
 arch/arm64/boot/dts/apple/t8103-j293.dts           |   4 +
 arch/arm64/boot/dts/apple/t8103-j313.dts           |   4 +
 arch/arm64/boot/dts/apple/t8103-j456.dts           |   4 +
 arch/arm64/boot/dts/apple/t8103-j457.dts           |   4 +
 arch/arm64/boot/dts/apple/t8103-jxxx.dtsi          |   2 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  19 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  12 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |   1 +
 .../broadcom/brcm80211/brcmfmac/firmware.c         | 116 ++++--
 .../broadcom/brcm80211/brcmfmac/firmware.h         |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.h  |   4 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |  12 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 430 +++++++++++++++++++--
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  38 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |   2 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  23 +-
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |   2 +
 include/linux/bcma/bcma_driver_chipcommon.h        |   1 +
 21 files changed, 610 insertions(+), 117 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
