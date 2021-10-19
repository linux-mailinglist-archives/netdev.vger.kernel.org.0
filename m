Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C081B4339A1
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhJSPEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbhJSPEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 11:04:39 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC26C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 08:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0xczBOFznEKiydkdssDmvhHhjjkJOIO47q11K7PlmOE=; b=dgYh5TGyOjs2hQjFHexqlzXdR6
        i4YogkbSQWJNCp5Ecs3QGVxA/qR3GKU3ZjrpH5XcfLNU94vKGwmNi/uc2MuG644ESv2tL9S+3cyHu
        9l92I0Na50lhUX4zAePZeY1FEcLg9xihSMPpeQ9nd1LDp0eWkbDnJm2GoqFQ1W6z0h6GOKjh/v/GW
        oY3XXy1Ke/2KQ7ApZLCyZneICUnTewxRe4zlKADiFpSpyFgdGODGGyzF3oAek8Obbm7wCxdbQYwYI
        NIKhS1fOeqSpdXvux/7o1HoaeIYqBjZdFDQks29vAXgcYk7U7NhpJL13bdiiINcR0gTBuH/IqKVxK
        fWBWpy1A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55192)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mcqdA-0006JD-Cv; Tue, 19 Oct 2021 16:02:20 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mcqd8-0006vC-Hy; Tue, 19 Oct 2021 16:02:18 +0100
Date:   Tue, 19 Oct 2021 16:02:18 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Antoine Tenart <atenart@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: Re: [PATCH v2 1/2] net: macb: Clean up macb_validate
Message-ID: <YW7d+qm/hnTZ80Ar@shell.armlinux.org.uk>
References: <20211011165517.2857893-1-sean.anderson@seco.com>
 <163402758460.4280.9175185858026827934@kwain>
 <YWhcEzZzrE5lMxD4@shell.armlinux.org.uk>
 <82025310-10f3-28fd-1b52-2b3969d5f00b@seco.com>
 <YWi4a5Jme5IDSuKE@shell.armlinux.org.uk>
 <95defe0f-542c-b93d-8d66-745130fbe580@seco.com>
 <YWoFAiCRZJGnkBJB@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWoFAiCRZJGnkBJB@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 11:47:30PM +0100, Russell King (Oracle) wrote:
> I have been working on it but haven't finished the patches yet. There's
> a few issues that came up with e.g. DSA and mvneta being able to switch
> between different speeds with some SFP modules that have needed other
> tweaks.

Okay, have a look at:

http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=net-queue

and the patches from "net: enetc: remove interface checks in
enetc_pl_mac_validate ()" down to the "net-merged" branch label.

That set of patches add the supported_interfaces bitmap, uses it for
validation purposes, converts all but one of the ethernet drivers
over to using it, and then simplifies the validate() implementations.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
