Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5EE3485EB
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 01:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239323AbhCYAau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 20:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239347AbhCYAai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 20:30:38 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEC0C06174A;
        Wed, 24 Mar 2021 17:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wzF7zOfjgNRiGIjG30S+ieAvDYKwu1j+DZ3l+40Yn3c=; b=pg3dTiLbimLtuQbRtZ3vTBT2A
        9Rez2ywOpaVjq72V8p240DRg7lj1eVlQ7kLlR3Ihuyo4XVnPMMuI26mNQVWLNTXWZR8GwxQVvaRM8
        p3WcKRqPoMh9jNk82jg9qQnJahvQZ0PCMFVtNZQQCYqWyft+YIrpjSonXzZr32MmGdUxv7pmnS9Db
        cH5jvlHk/ood4TcbJbvVKXqH43mUCBpysKb5u/DNK5WV93qW9DmLrwTtgOr2tewVEgoWxCMIeb2FE
        7/ZNwMCoMnapgKu3GqlsESkQRbKrHtEqTUWPFychdXr54ecgOBqxLTio5SMDTZrX1vD4umfq+SDNk
        psHrb9ihg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51690)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lPDtU-00013i-8n; Thu, 25 Mar 2021 00:30:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lPDtU-0005UK-1z; Thu, 25 Mar 2021 00:30:36 +0000
Date:   Thu, 25 Mar 2021 00:30:36 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        pali@kernel.org
Subject: Re: [PATCH net-next 0/2] dt-bindings: define property describing
 supported ethernet PHY modes
Message-ID: <20210325003035.GJ1463@shell.armlinux.org.uk>
References: <20210324103556.11338-1-kabel@kernel.org>
 <e4e088a4-1538-1e7d-241d-e43b69742811@gmail.com>
 <20210325000007.19a38bce@thinkpad>
 <755130b4-2fab-2b53-456f-e2304b1922f2@gmail.com>
 <20210325004525.734f3040@thinkpad>
 <5fc6fea9-d4c1-bb7e-8f0d-da38c7147825@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fc6fea9-d4c1-bb7e-8f0d-da38c7147825@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 05:11:25PM -0700, Florian Fainelli wrote:
> > And if you use rate matching mode, and the copper side is
> > linked in lower speed (2.5g for example), and the MAC will start
> > sending too many packets, the internal buffer in the PHY is only 16 KB,
> > so it will fill up quickly. So you need pause frames support. But this
> > is broken for speeds <= 1g, according to erratum.
> > 
> > So you really want to change modes. The rate matching mode is
> > basically useless.
> 
> OK, so whenever there is a link change you are presumably reading the
> mode in which the PHY has been reconfigured to, asking the MAC to
> configured itself appropriately based on that, and if there is no
> intersection, error out?

The 88x3310 already tells the MAC what the interface mode is.

I think what Marc is trying to do is to program the PHY to use the
appropriate _group_ of modes for the MAC connection and then letting
the PHY get on with it, rather than explicitly trying to resolve the
mode (which likely won't work for the 88x3310, since changing the
MAC side mode requires resetting the entire PHY - which will cause
any media side link to be dropped.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
