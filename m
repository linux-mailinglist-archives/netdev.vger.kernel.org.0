Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A215B5778
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 11:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiILJwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 05:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiILJwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 05:52:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69082229E;
        Mon, 12 Sep 2022 02:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=i7scest9/GRb/SJTIXxI6p7sk+zo39k5Ettiz2gvQT0=; b=tRz4vOR8lAGwAn6YrCx+p6EKSw
        snonH391ow5yXmrkOBmGvfgdClNw4V5uJ5tywGTSBm3IVVBU2Z/1FsNfS2HhT6U5mhGydyO30vCij
        zsw438CFRgu2T9drmOt2gnRCME4fBwRo989z9W8rTRcIyLSSQ4m9vkTV6Eplu0wcJSLTpS6hBu56u
        ii5wo8Zgio3aZ5A7M4kwnAnMnq6dRozl3+6pHPEzUq1IxgNVeB4tn7aE5eFcGk4LoQotp/lnfaM+s
        l2AtwF5zjBQ9mE4zmpe0j7bHl9Cnngi21ZZWTKvkugRGlXeYeb1Vl1ZnaUxY6fwZc8f2TBh9qHfAJ
        HW1Pw7/Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34252)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oXg6o-0001Qx-Bb; Mon, 12 Sep 2022 10:52:06 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oXg6j-00080m-W7; Mon, 12 Sep 2022 10:52:02 +0100
Date:   Mon, 12 Sep 2022 10:52:01 +0100
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
Subject: [PATCH wireless-next v2 0/12] Add support for bcm4378 on Apple
 platforms
Message-ID: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

(I'm just the middle man; please don't complain if something has been
missed.)

v2:
- sending for wireless-next
- fixed up %ld -> %zd for size_t
- added reviewed-bys

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
 .../broadcom/brcm80211/brcmfmac/firmware.c         | 115 ++++--
 .../broadcom/brcm80211/brcmfmac/firmware.h         |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.h  |   4 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |  12 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 431 +++++++++++++++++++--
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  38 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |   2 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  23 +-
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |   2 +
 include/linux/bcma/bcma_driver_chipcommon.h        |   1 +
 21 files changed, 610 insertions(+), 117 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
