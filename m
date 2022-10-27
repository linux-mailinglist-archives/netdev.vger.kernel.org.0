Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7659A60F8F4
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbiJ0NYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235651AbiJ0NYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:24:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031D617A016
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ic5qV7VWLqe4+lahnJxOzORNAlLni3RZGNOdWJ0dyec=; b=SgfKVU45bIsDSc6qM2t+eq5mzz
        uygqYGqxeA23IDB81kxyy8p3Jol8JbrH7eJaCsAQfITFy1mv9Xs5K+km9oWnp8hSZW6rvlpGAeptr
        nNFYUBQ6nmV1FwbWjfEoJpmGQQ3HprGPM7sSBkHs5ZkeH/663GzkBS22Sq/utpJorCd5+OK3XzR7K
        /NnzTLvIjMsHNoyiqJR649acRIBm/9kZAyzKpwlP62VMgOklu+Cbvzg3+oZWz4MirlkSdWuCAyB0p
        AV6gCLker321KFUrpyXm/wPgL3pNESejKVO2ArmPH2VjVNxleOGO81ww0rL/uD/m8vlXjns5VVNOA
        4jdS+awA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34974)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oo2rZ-00072U-Ak; Thu, 27 Oct 2022 14:24:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oo2rW-0001aM-9x; Thu, 27 Oct 2022 14:23:58 +0100
Date:   Thu, 27 Oct 2022 14:23:58 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Frank Wunderlich <frank-w@public-files.de>
Cc:     Eric Dumazet <edumazet@google.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH net-next 00/11] net: mtk_eth_soc: improve PCS
 implementation
Message-ID: <Y1qGbrPZWNBt/78Z@shell.armlinux.org.uk>
References: <Y1qDMw+DJLAJHT40@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1qDMw+DJLAJHT40@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 02:10:11PM +0100, Russell King (Oracle) wrote:
> Hi,
> 
> As a result of invesigations from Frank Wunderlich, we know a lot more
> about the Mediatek "SGMII" PCS block, and can implement the PCS support
> correctly. This series achieves that, and Frank has tested the final
> result and reports that it works for him. The series could do with
> further testing by others, but I suspect that is unlikely to happen
> until it is merged based on past performances with this driver.

I forgot to say, many thanks to Frank for his efforts and patience in
testing various patches to discover how this PCS works.

> 
> Briefly, the patches in order:
> 
> 1. Add a new helper to get the link timer duration in nanoseconds
> 2. Add definitions for the newly discovered registers and updates to
>    bit definitions, including bitmasks for the BMCR, BMSR and two
>    advertisement registers.
> 3. Remove unnecessary/unused error handling (functions always returning
>    zero.)
> 4. Adding the missing pcs_get_state() implementation.
> 5. Converting the code to use regmap_update_bits() rather than
>    open-coding read-modify-write sequences.
> 6. Adding out-of-band speed and duplex forcing for all non-inband modes
>    not just the 802.3z link modes the code currently does.
> 7. Moving the release of the PHY power down to the main pcs_config()
>    function.
> 8. Moving the interface speed selection to the main pcs_config()
>    function.
> 9. Adding advertisement programming.
> 10. Adding correct link timer programming using the new helper in the
>     first patch.
> 11. Adding support for 802.3z negotiation.
> 
> There is one remaining issue - when configuring the PCS for in-band,
> for some reason the AN restart bit is always set. This should not be
> necessary, but requires further investigation with the hardware to
> find out whether it is really necessary. I suspect this was a work
> around for a previous poor implementation.
> 
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h |  13 ++-
>  drivers/net/ethernet/mediatek/mtk_sgmii.c   | 174 ++++++++++++++++------------
>  include/linux/phylink.h                     |  24 ++++
>  3 files changed, 134 insertions(+), 77 deletions(-)
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
