Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A985B642D6D
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 17:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbiLEQqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 11:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiLEQph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 11:45:37 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1494D1F60C
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 08:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+V7OCLtb9oDJVdRIgMtde0jyEN7h5vIe201els4Nkd8=; b=p7sGQHWyKNAFvw38bhEaXu6QmZ
        LELP/h7JO4o6ASX9THQdbHm9JzSKQQ9CakaOd17Tsc7Pe3EzGdYyqrWjgcnDcU5UHb7V29oDori4t
        sgLv0d++d3tfuW9/Rw202+afAs64Q8GS1s9z2MiIElqLDSWuOX4Nd8P0nocQDP8HLDys=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2EZn-004QOJ-1W; Mon, 05 Dec 2022 17:44:19 +0100
Date:   Mon, 5 Dec 2022 17:44:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev <netdev@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: phy: swphy: Support all normal speeds when
 link down
Message-ID: <Y44f4/volEMs+0Uo@lunn.ch>
References: <20221204174103.1033005-1-andrew@lunn.ch>
 <Y44WhXU+Lq+MEM7A@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y44WhXU+Lq+MEM7A@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 04:04:21PM +0000, Russell King (Oracle) wrote:
> On Sun, Dec 04, 2022 at 06:41:03PM +0100, Andrew Lunn wrote:
> > The software PHY emulator validation function is happy to accept any
> > link speed if the link is down. swphy_read_reg() however triggers a
> > WARN_ON(). Change this to report all the standard 1G link speeds are
> > supported. Once the speed is known the supported link modes will
> > change, which is a bit odd, but for emulation is probably O.K.
> > 
> > Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
> 
> This isn't what I suggested. I suggested restoring the old behaviour of
> fixed_phy before commit 5ae68b0ce134 ("phy: move fixed_phy MII register
> generation to a library") which did _not_ report all speeds, but
> reported no supported speeds in BMSR.

O.K.

Which is better. No speeds, or all speeds? I think all speeds is more
like what a real PHY does.

     Andrew
