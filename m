Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459D4202DB8
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 01:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730938AbgFUXok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 19:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbgFUXoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 19:44:39 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD69C061794
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 16:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=s9VNi/dZhd3qFNgmjAM+3nS18d8quoTwMfIFiL77wOY=; b=p/SW3MX4xWT6yJyEA3xo2mXVu
        BkM6oCxGjsnxYgVkCSxHXrdlmWC+TQwTKamY51ggjiEehZEvFLaAMUmLVlc1hmP7sbHqVGtJDCx/v
        8vkrhH7tlxOKoCuBQoHKvuU1mMlBZDuR2oQ71pRhu8eTFcTE95UBGOcoRpsSStr5eNtBkr84Hqw9q
        WZR9kg3V/IXq0dRcMUP82ziGhdJPzbiipEnEoiLY8c1s8FkRLFyNuyZMPtu79fpcBYUloNo4yfS65
        9llgxNElyegOEn86Bku/tORmCmqNEY9Bpgh+8HKoi+6G4tE9UIcKmAFBqMCXsfVXPb8yAy6ESoM4I
        Yioud1B3g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58924)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jn9da-0008C9-2q; Mon, 22 Jun 2020 00:44:34 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jn9dX-0007wa-Fw; Mon, 22 Jun 2020 00:44:31 +0100
Date:   Mon, 22 Jun 2020 00:44:31 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Colton Lewis <colton.w.lewis@protonmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: FWD: [PATCH 3/3] net: phylink: correct trivial kernel-doc
 inconsistencies
Message-ID: <20200621234431.GZ1551@shell.armlinux.org.uk>
References: <20200621154248.GB338481@lunn.ch>
 <20200621155345.GV1551@shell.armlinux.org.uk>
 <3315816.iIbC2pHGDl@laptop.coltonlewis.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3315816.iIbC2pHGDl@laptop.coltonlewis.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 21, 2020 at 11:02:30PM +0000, Colton Lewis wrote:
> On Sunday, June 21, 2020 10:53:45 AM CDT Russell King - ARM Linux admin wrote:
> > > ---
> > >   */
> > >  struct phylink_config {
> > >  	struct device *dev;
> > > @@ -331,7 +333,7 @@ void pcs_get_state(struct phylink_config *config,
> > >   *
> > >   * For most 10GBASE-R, there is no advertisement.
> > >   */
> > > -int (*pcs_config)(struct phylink_config *config, unsigned int mode,
> > > +int *pcs_config(struct phylink_config *config, unsigned int mode,
> > >  		  phy_interface_t interface, const unsigned long *advertising);
> > 
> > *Definitely* a NAK on this and two changes below.  You're changing the
> > function signature to be incorrect.  If the documentation can't parse
> > a legitimate C function pointer declaration and allow it to be
> > documented, then that's a problem with the documentation's parsing of
> > C code, rather than a problem with the C code itself.
> 
> I realize this changes the signature, but this declaration is not compiled. It is under an #if 0 with a comment stating it exists for kernel-doc purposes only. The *real* function pointer declaration exists in struct phylink_pcs_ops.
> 
> Given the declaration is there exclusively for documentation, it makes sense to change it so the documentation system can parse it.

My objection is that you are changing the return type from (e.g.)
"int" to "int *", which will then end up in the documentation as
such, and the documentation will, therefore, be incorrect.

I have subsequently realised that I didn't follow my own pattern
for documenting phylink_mac_ops - a correct solution would be to
drop the parens _and_ the "*" preceding the function name, so:

int pcs_config(struct phylink_config *config, unsigned int mode,
...

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
