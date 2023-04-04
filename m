Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22AAF6D5CDF
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 12:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbjDDKQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 06:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233732AbjDDKQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 06:16:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B048F
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 03:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bR7JA1m6vKaw/lFY8Ll2anUUppgEYGPaYhXrsoarV2k=; b=koUeZrAnvZEsIlD/wiKtthHIcp
        4uVsOvuMlBnoUFCv7RKMetA+VYOU8TRtnYnMOAn+i2adYqfP8Av9WVRQ97jJmLc2cH5Yo1TBMiLFg
        C/FQKRJ+gbBZoKuqipraEP9NiaQh+xXeWQdM/op11dxNv4x+e1RuGJtmERfGxGJgD3XnMVmBCjskq
        VwApgrg/ItZ4JVZV975Tub8wVtn4UmjAdTmF0eTyV+pPz+9VLbK804g1w2W8fDr+j9DfbWWqqvi/d
        bDwhaK9eLgETO/7FiRM9YNIJhXohFJXjYivGyAdS9/8SdEHIbRFSrMIqm9W5mxSPY93yE+kLqxK1k
        u6dwfcLw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43874)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pjdiT-0003up-Ny; Tue, 04 Apr 2023 11:16:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pjdiN-0005BV-Gl; Tue, 04 Apr 2023 11:16:35 +0100
Date:   Tue, 4 Apr 2023 11:16:35 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexander 'lynxis' Couzens <lynxis@fe80.eu>,
        Chukun Pan <amadeus@jmu.edu.cn>,
        John Crispin <john@phrozen.org>
Subject: Re: Convention regarding SGMII in-band autonegotiation
Message-ID: <ZCv5Awt1tQic2Ygj@shell.armlinux.org.uk>
References: <ZCtvaxY2d74XLK6F@makrotopia.org>
 <a0570b00-669f-120d-2700-a97317466727@gmail.com>
 <ZCvqJAVjOdogEZKD@makrotopia.org>
 <539986da-0bf7-8dd3-73d7-a2a584846f18@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539986da-0bf7-8dd3-73d7-a2a584846f18@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 11:56:45AM +0200, Heiner Kallweit wrote:
> On 04.04.2023 11:13, Daniel Golle wrote:
> > On Tue, Apr 04, 2023 at 08:31:12AM +0200, Heiner Kallweit wrote:
> >> Ideas from the patches can be re-used. Some patches itself are not ready
> >> for mainline (replace magic numbers with proper constants (as far as
> >> documented by Realtek), inappropriate use of phy_modify_mmd_changed,
> >> read_status() being wrong place for updating interface mode).
> > 
> > Where is updating the interface mode supposed to happen?
> > 
> > I was looking at drivers/net/phy/mxl-gpy.c which calls its
> > gpy_update_interface() function also from gpy_read_status(). If that is
> > wrong it should probably be fixed in mxl-gpy.c as well...
> > 
> 
> Right, several drivers use the read_status() callback for this, I think
> the link_change_notify() callback would be sufficient.

Sorry, but that's too late.

The problem is that phy_check_link_status() reads the link status, and
then immediately acts on it calling phy_link_up() or phy_link_down()
as appropriate. While the phy state changes at the same time, we're
still in the state machine switch() here, and it's only after that
switch() that we then call link_change_notify() - and that will be
_after_ phylink or MAC driver's adjust_link callback has happened.

So, using link_change_notify() would mean that the phylib user will
be informed of the new media parameters except for the interface mode,
_then_ link_change_notify() will be called, and only then would
phydev->interface change - and there's no callback to the phylib
user to inform them that something changed.

In any case, we do _not_ want two callbacks into the phylib user for
the state change, especially not one where the first is "link is up"
and the second is "oh by the way the interface changed".

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
