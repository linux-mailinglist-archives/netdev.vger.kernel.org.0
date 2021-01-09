Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BDA2F0180
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 17:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbhAIQ2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 11:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbhAIQ2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 11:28:46 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A448C061786;
        Sat,  9 Jan 2021 08:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=O/XD7xJpa0JpoEabIf++Vso8fJLTJb9fbYKc1Swo5w8=; b=mG9EFIRX3l3qITkxxx8NZ/GM4
        nx/KH5hc9L5ZMjUyGgC4bOYRQWliOq0odWK/go8E/QyXz/8nfbl44xmLfmF1zdMCjzxvCK6CrMV9N
        0Uh6/JfFlVQaS1o0mmQkqerOdy83XACMKJmE0Elgx5/4dwLFKNPAhyGSboHwwqoNfyrWR/XXpUv2M
        vkm1U4veiJ8W1UJlcgBdmSq+KK+zJQoEAftDdlx99TmSAntcEAgDXtV1TbjWp06hu55SSDfrvBLOe
        o0BsHjBtmHgvExuhKdEpR8Y/L0HqmolFTXKDIQ4p65pFJO1kMQH2+mTJm1xdmkCNwrex6LRI+XhVg
        nyLI3RbJQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45782)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kyH5d-0005CN-G8; Sat, 09 Jan 2021 16:27:45 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kyH5c-0003Jy-5Q; Sat, 09 Jan 2021 16:27:44 +0000
Date:   Sat, 9 Jan 2021 16:27:44 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] net: sfp: assume that LOS is not implemented if
 both LOS normal and inverted is set
Message-ID: <20210109162744.GA1551@shell.armlinux.org.uk>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210106153749.6748-1-pali@kernel.org>
 <20210106153749.6748-3-pali@kernel.org>
 <X/c8xJcwj8Y1t3u4@lunn.ch>
 <20210109154601.GZ1551@shell.armlinux.org.uk>
 <X/nRrgR12bETcMEO@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <X/nRrgR12bETcMEO@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 09, 2021 at 04:54:22PM +0100, Andrew Lunn wrote:
> On Sat, Jan 09, 2021 at 03:46:01PM +0000, Russell King - ARM Linux admin wrote:
> > On Thu, Jan 07, 2021 at 05:54:28PM +0100, Andrew Lunn wrote:
> > > On Wed, Jan 06, 2021 at 04:37:48PM +0100, Pali Rohár wrote:
> > > > From: Russell King <rmk+kernel@armlinux.org.uk>
> > > > 
> > > > Some GPON SFP modules (e.g. Ubiquiti U-Fiber Instant) have set both
> > > > SFP_OPTIONS_LOS_INVERTED and SFP_OPTIONS_LOS_NORMAL bits in their EEPROM.
> > > > 
> > > > Such combination of bits is meaningless so assume that LOS signal is not
> > > > implemented.
> > > > 
> > > > This patch fixes link carrier for GPON SFP module Ubiquiti U-Fiber Instant.
> > > > 
> > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > 
> > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > 
> > I'd like to send this patch irrespective of discussion on the other
> > patches - I already have it committed in my repository with a different
> > description, but the patch content is the same.
> > 
> > Are you happy if I transfer Andrew's r-b tag
> 
> Hi Russell
> 
> If it is the same contest, no problem. I can always NACK it later...

The commit message is different:

   net: sfp: cope with SFPs that set both LOS normal and LOS inverted

   The SFP MSA defines two option bits in byte 65 to indicate how the
   Rx_LOS signal on SFP pin 8 behaves:

   bit 2 - Loss of Signal implemented, signal inverted from standard
           definition in SFP MSA (often called "Signal Detect").
   bit 1 - Loss of Signal implemented, signal as defined in SFP MSA
           (often called "Rx_LOS").

   Clearly, setting both bits results in a meaningless situation: it would
   mean that LOS is implemented in both the normal sense (1 = signal loss)
   and inverted sense (0 = signal loss).

   Unfortunately, there are modules out there which set both bits, which
   will be initially interpret as "inverted" sense, and then, if the LOS
   signal changes state, we will toggle between LINK_UP and WAIT_LOS
   states.

   Change our LOS handling to give well defined behaviour: only interpret
   these bits as meaningful if exactly one is set, otherwise treat it as
   if LOS is not implemented.

   Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

As I say, the actual patch is the same.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
