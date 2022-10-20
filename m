Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA476059E8
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 10:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiJTIdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 04:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiJTIdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 04:33:39 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278B918D469;
        Thu, 20 Oct 2022 01:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=V+1ef8CY4rNU4mQk37SBqFAMHnpg/IcaHQ4AFvuNoks=; b=GIL9tOLjjdtmPdIM56MUg3cw+p
        q/vk9cqNJnqbmMS7KTOWoEWU83QMLOIuz74N0QNs5F4IdZEXwhpuQnnMnEg+kS1Vwj4ESaMeTsZ6v
        thzoxV6W6b7tBNawqRCx/aPDaRFAvnA4wZ6+9X3pWX9CHgN/qQJplDRGtQQVIAh/BTUOr1Tabszl8
        v4N2z+vPWDHo/wbwHxfbWgL46ZgPHJ47CWnDFgPn+DJPR5I+C57B6kHquYYsZdWhd6LUwhCXlbuOc
        VrecXyGNCXTUMtamT+vZRsTcwYVr9hH9ueUauV1KTejAlhZWpcUtupe2JxRTbZughvjkLuVLTU8t0
        q60AoVvQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34818)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1olQzP-0006j5-TT; Thu, 20 Oct 2022 09:33:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1olQzL-00031C-LG; Thu, 20 Oct 2022 09:33:15 +0100
Date:   Thu, 20 Oct 2022 09:33:15 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mtk_sgmii: implement mtk_pcs_ops
Message-ID: <Y1EHy0t5nXOF/3Mw@shell.armlinux.org.uk>
References: <20221018153506.60944-1-linux@fw-web.de>
 <Y07Wpd1A1xxLhIVc@shell.armlinux.org.uk>
 <949F5EE5-B22D-40E2-9783-0F75ACFE2C1F@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <949F5EE5-B22D-40E2-9783-0F75ACFE2C1F@public-files.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 07:54:49AM +0200, Frank Wunderlich wrote:
> Am 18. Oktober 2022 18:39:01 MESZ schrieb "Russell King (Oracle)" <linux@armlinux.org.uk>:
> >Hi,
> >
> >A couple of points:
> >
> >On Tue, Oct 18, 2022 at 05:35:06PM +0200, Frank Wunderlich wrote:
> 
> >> +	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &val);
> >> +	state->an_complete = !!(val & SGMII_AN_COMPLETE);
> >> +	state->link = !!(val & SGMII_LINK_STATYS);
> >> +	state->pause = 0;
> >
> >Finally, something approaching a reasonable implementation for this!
> >Two points however:
> >1) There's no need to set state->pause if there is no way to get that
> >   state.
> >2) There should also be a setting for state->pause.
> 
> Currently it looks like pause cannot be controlled in sgmii-mode so we disabled it here to not leave it undefined. Should i drop assignment here?

Why do you think it would be undefined?

static void phylink_mac_pcs_get_state(struct phylink *pl,
                                      struct phylink_link_state *state)
{
...
        if  (state->an_enabled) {
...
                state->pause = MLO_PAUSE_NONE;
        } else {
,,,
                state->pause = pl->link_config.pause;
	}
...
        if (pl->pcs)
                pl->pcs->ops->pcs_get_state(pl->pcs, state);

So, phylink will call your pcs_get_state() function having initialised
it to something sensible.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
