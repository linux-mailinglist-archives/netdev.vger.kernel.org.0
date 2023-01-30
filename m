Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BABA6816D1
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235814AbjA3QsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjA3QsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:48:15 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005C514E8E;
        Mon, 30 Jan 2023 08:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iSppJpmbh5yY9f1++jDLbK6EHrj4YtdTjVgqiD7xZtE=; b=t143gCujAMScBKZumahGmYIUKE
        114PPBcgvsfprD7++/4HiAGm2f5MmIwhvQtm7RERN5nPjqZLRBTM90n3Zi2GY+iLiDMfHdYF7TyPe
        79RQjd+C2bS2B3fYBvpM6fMEn/R0UzuDPgqa83Pfn5nWUHmJr7EJ74RR/08NkmtFY/0zovKiWfotM
        5QYrH6huVb2H+AltAwCBc/akCxpdER69TrIdkVUfhewCLawK4Z+U80TeY7bdxon9YEqmLNGij+0o6
        pYrNRhFvqvw1B8EncYI9jKlveG0FjAVNPtlEhaH5wBK8MeelowRmpYHCQr8nqJ4NCWSPLF61VtEnS
        zJjznd3A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36362)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pMXK9-0003Vy-Fz; Mon, 30 Jan 2023 16:48:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pMXK6-0003HB-KP; Mon, 30 Jan 2023 16:48:02 +0000
Date:   Mon, 30 Jan 2023 16:48:02 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH net-next v4 4/4] net: ethernet: renesas: rswitch: Add
 phy_power_{on,off}() calling
Message-ID: <Y9f0wm1sV6B1/ymC@shell.armlinux.org.uk>
References: <20230127142621.1761278-1-yoshihiro.shimoda.uh@renesas.com>
 <20230127142621.1761278-5-yoshihiro.shimoda.uh@renesas.com>
 <Y9PrDPPbtIClVtB4@shell.armlinux.org.uk>
 <TYBPR01MB534129FDE16A6DB654486671D8D39@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <Y9e05RJWrzFO7z4T@shell.armlinux.org.uk>
 <20230130173048.520f3f3e@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230130173048.520f3f3e@thinkpad>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 05:30:48PM +0100, Marek Behún wrote:
> But rswitch already uses phylink, so should Yoshihiro convert it whole
> back to phylib? (I am not sure how much phylink API is used, maybe it
> can stay that way and the new phylib function as proposed in Yoshihiro's
> previous proposal can just be added.)

In terms of "how much phylink API is used"... well, all the phylink
ops functions are currently entirely empty. So, phylink in this case
is just being nothing more than a shim between the driver and the
corresponding phylib functions.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
