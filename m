Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8AD4FBD16
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbiDKNcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbiDKNcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:32:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCCBEBD
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nWobsV/+KPeCMvMr9OiCUDsatbyuU3uq3Cjnj3cPUVU=; b=VYHOOaB6u7ojLHmk9jy8mqibh6
        2iOxiaMB9Bdk6ac9eYbKkbcEkzbsDkfDi0l3CzV+OWPZwTDQL4DQnlHQAWvafWnaI7dsFHIWGUGSA
        H6nPuA8JBp7qg9KJcqMwXyP2B5SuynGn1zgbMCAW3f/Le3mdILUs9rIZKrnwtZgqy3ByiR+Ty+Y0w
        n/I/pAV1LBd0/NotBa3SXCzB63S5Qap/ZnpLMcXPQo65cO/Pif70tRfxfT0gq5ZBIV4nNR0sVveyJ
        AMGvj8yuIBoSlNofyfqtqdy747Ck58OUm2rsv3x54yTpTIY1wJIko1Tjxql9T4bwtm3o9hpPmMQHC
        vE3P5jrA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58212)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ndu7c-0000aU-HX; Mon, 11 Apr 2022 14:30:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ndu7X-0001Rm-TU; Mon, 11 Apr 2022 14:30:19 +0100
Date:   Mon, 11 Apr 2022 14:30:19 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>, Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH RFC 00/12] mtk_eth_soc phylink updates
Message-ID: <YlQta3Qu1aM4De9n@shell.armlinux.org.uk>
References: <Yk2k9D40QojsRhoo@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yk2k9D40QojsRhoo@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A gentle reminder to those who either worked on or who look after
this driver to test this series and report back please.

Thanks.

On Wed, Apr 06, 2022 at 03:34:28PM +0100, Russell King (Oracle) wrote:
> Hi,
> 
> This series ultimately updates mtk_eth_soc to use phylink_pcs, with some
> fixes along the way.
> 
> Previous attempts to update this driver (which is now marked as legacy)
> have failed due to lack of testing. I am hoping that this time will be
> different; Marek can test RGMII modes, but not SGMII. So all that we
> know is that this patch series probably doesn't break RGMII.
> 
> 1) remove unused mac_mode and sgmii flags members from structures.
> 2) remove unnecessary interpretation of speed when configuring 1000
>    and 2500 Base-X
> 3) move configuration of SGMII duplex setting from mac_config() to
>    link_up()
> 4) only pass in interface mode to mtk_sgmii_setup_mode_force()
> 5) move decision about which mtk_sgmii_setup_mode_*() function to call
>    into mtk_sgmii.c
> 6) add a fixme comment for RGMII explaning why the call to
>    mtk_gmac0_rgmii_adjust() is completely wrong - this needs to be
>    addressed by someone who has the hardware and can test an appropriate
>    fix. This fixme means that the driver still can't become non-legacy.
> 7) move gmac setup from mac_config() to mac_finish() - this preserves
>    the order that we write to the hardware when we eventually convert to
>    phylink_pcs()
> 8) move configuration of syscfg0 in SGMII/802.3z mode to mac_finish()
>    for the same reasons as (7).
> 9) convert mtk_sgmii.c code structure and the mtk_sgmii structure to
>    suit conversion to phylink_pcs
> 10) finally convert to phylink_pcs
> 
> It would be nice to get these changes fully tested, but past experience
> has shown that for this driver, that's unfortunately very unlikely. So,
> I propose that the merging plan for this is that if there are no
> comments after three weeks to a month, I'll send this for inclusion in
> net-next.
> 
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 103 +++++++++-------
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h |  40 +++----
>  drivers/net/ethernet/mediatek/mtk_sgmii.c   | 174 ++++++++++++++++------------
>  3 files changed, 185 insertions(+), 132 deletions(-)
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
