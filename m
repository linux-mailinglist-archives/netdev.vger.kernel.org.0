Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09301DFA57
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 20:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgEWSpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 14:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgEWSpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 14:45:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F65C061A0E;
        Sat, 23 May 2020 11:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mW3ziBANfOA6tQR2fKdApXgEQabJf6SOIrMw3Ry5F9A=; b=bIEfG5FSrJFTd1xqQ1DU8eWxu
        feiZU+6NpRIBXKKtvb5moyXlZMWpFqIjxioB3VDIc6GyWtkPYAQQrBxzz1HUtMdjBSc8/wDxSIIJ6
        P95HzRS3oApRHmfu26N4xrc77k03MWQiMwYW21UK77ttFYLkTEyD0WbHO92oZN/PmtKhD2mIdW4tD
        4dIzQuS45YiFlunX2MvgBg6VajOV/U+q9XqX3yqoN59clBlW97PdmxFsOxjY+623JJkp9d0t5XYQx
        /p3R/pzoNoIrqGN94pYJoddt4cnlyiM/aUtABdU3w3yNistbA1Zt3symetVBPMWMllhp0xr+wudUL
        Nsi9+6BRA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36034)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jcZ8n-0000VD-A8; Sat, 23 May 2020 19:45:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jcZ8l-0002Ua-TW; Sat, 23 May 2020 19:44:59 +0100
Date:   Sat, 23 May 2020 19:44:59 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 07/11] net: phy: reset invalid phy reads of 0 back to
 0xffffffff
Message-ID: <20200523184459.GA1551@shell.armlinux.org.uk>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-8-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522213059.1535892-8-jeremy.linton@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 04:30:55PM -0500, Jeremy Linton wrote:
> MMD's in the device list sometimes return 0 for their id.
> When that happens lets reset the id back to 0xfffffff so
> that we don't get a stub device created for it.
> 
> This is a questionable commit, but i'm tossing it out
> there along with the comment that reading the spec
> seems to indicate that maybe there are further registers
> that could be probed in an attempt to resolve some futher
> "bad" phys. It sort of comes down to do we want unused phy
> devices floating around (potentially unmatched in dt) or
> do we want to cut them off early and let DT create them
> directly.

I'm not sure what you mean "stub device" or "unused phy devices
floating around" - the individual MMDs are not treated as separate
"phy devices", but as one PHY device as a whole.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
