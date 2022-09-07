Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B355AFDE6
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiIGHrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiIGHrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:47:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C54A74E5;
        Wed,  7 Sep 2022 00:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=I+p6cUmDn7OtLSjJelOWcrfySN1QQyfUSzq1+9ZjAjo=; b=RUI5rrUHN+N7Isq/K41V0FL6me
        N5uzyGeW8ILYu+Pv7g+N5ybL9DjxUJmCuy+WcFKD7slDug3s6aFbVJgrsbOI2u6tbYfM1/fZWSWg5
        PLdf9qyWf4dL1DzxkfEE0eqFjhN+IINx5CqG6Dkb23nbofcBRlOZpQHZ2daWBbPX/lWWVBasuNtHT
        ZH6pogpbN+DgcZancUbZKCFfelIb4w7TSK0pD/MoCOXVH06WT+Rypt4TDXciEETQANfCI2Bt1tAv2
        7qmHTrnq0eZ8cxv+xoeyzuc5N+HeWlRL37J2FCJRwBk0TY+hZPVwaWHVb9T/DW+YZXwZeld8oP4MJ
        u6r7hKuw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34164)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oVplu-0004tr-42; Wed, 07 Sep 2022 08:46:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oVplp-0000nx-Jm; Wed, 07 Sep 2022 08:46:49 +0100
Date:   Wed, 7 Sep 2022 08:46:49 +0100
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
Subject: [PATCH net-next 0/12] Add support for bcm4378 on Apple platforms
Message-ID: <YxhMaYOfnM+7FG+W@shell.armlinux.org.uk>
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

 .../bindings/net/wireless/brcm,bcm4329-fmac.yaml   |  37 +-
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
 21 files changed, 609 insertions(+), 116 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
