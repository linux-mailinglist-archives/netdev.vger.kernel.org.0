Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90EEB401A86
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 13:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241263AbhIFLXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 07:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbhIFLXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 07:23:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7ECEC061575
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 04:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dLFz4/w0sUZswHb75ccRWmx4KirS+zbLOF9I69Q2X6k=; b=evcAILJMiDg2JcD4Vt+LZcGmaE
        PrmDvgYSTQlEVWkukc8LcVw5HHzhKyG/HRmbGflAuuyvUfLdz3ELjCKVTF7E+j3tEJ0zgCPuVN1ab
        /F4xS7xKOZqw23mNgD8MEufFLanpLIpw6JiOWiM480Rjzg7YvqSkW8SANDQPpsS8il0moqYMao3mL
        OhPa8yQRIY21cWOItjLwAkn5Exg9YQp4BKzuGvukq87z4McbpJfmj4eS456Ch9RFNbDFbFZbMcBk7
        djWwGoMBFRhRs5Ye+fZp93uUtGpkNrubk/tI176IYKOyOVMS/MnCL+bU5TNCYt97f/xZlG+2eBA6y
        RnXkLf9g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44974)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mNChQ-0001dT-CD; Mon, 06 Sep 2021 12:22:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mNChL-0003EW-UG; Mon, 06 Sep 2021 12:21:59 +0100
Date:   Mon, 6 Sep 2021 12:21:59 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Message-ID: <YTX515RMVNmT4q+o@shell.armlinux.org.uk>
References: <DB8PR04MB6795C36B8211EE1A1C0280D9E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903080147.GS22278@shell.armlinux.org.uk>
 <DB8PR04MB679518228AB7B2C5CD47A1B3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903093246.GT22278@shell.armlinux.org.uk>
 <DB8PR04MB6795EE2FA03451AB5D73EFC3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903120127.GW22278@shell.armlinux.org.uk>
 <20210903201210.GF1350@shell.armlinux.org.uk>
 <DB8PR04MB6795FC58C1D0E2481E2BC35EE6D29@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YTXgqBRMRvYdPyJU@shell.armlinux.org.uk>
 <DB8PR04MB67958E22A85B15FFCA7CDA70E6D29@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB67958E22A85B15FFCA7CDA70E6D29@DB8PR04MB6795.eurprd04.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 06, 2021 at 10:41:48AM +0000, Joakim Zhang wrote:
> Hi Russell,
> 
> Thanks Russell, it works as we are expected, I test both MAC-based WoL active and inactive cases.

Yay!

> And I get the point you mentioned before, if link parameters changed during system suspended, what would happen?

That's a problem with any setup that uses the MAC to detect WoL packets,
and the MAC requires software to run if the link state changes. It is
one of the fundamental problems of MAC-side WoL detection.

I see two possible solutions to this problem:

1) If the link changes, the PHY needs to wake the system up from suspend
   so that software can run to reprogram the MAC for the new link
   parameters, and then go back to sleep.

2) We need to set the link to a state which reduces the chances of the
   link parameters changing.

I don't think we have any support in the kernel for (1) - we assume if
we are woken up than the system as a whole will become operational, so
there's no automatic "go back to sleep".

We do have the ability to place the link into the slowest mutually
supported speed via phy(link)?_speed_down(). This has the advantage of
reducing the power used to keep the link active while in suspend (which
is its primary purpose) but also reduces the possible link modes that
could be autonegotiated with the partner.

I think I'd suggest to Andrew that phy_speed_down() should only
advertise one capability, not "everything we support below the minimum
mutually supported capability" - that way, if a link change is attempted
on the partner while the system is suspended, the link will not come up
and its obvious it isn't going to work.

I think this is an issue for a separate patch set.

> Since net-next is closed, so I would cook a patch set (keep you as the
> phylink patch author) after it re-open, could you accept it? Or you plan
> to prepare this patch set for stmmac?

As the bug was introduced in v5.7, this is a regression, and the fix
isn't too complex. I believe it's suitable for the net tree.

I'll prepare a proper patch for the net tree for phylink, which I'll
send you, so you can include with your patch set.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
