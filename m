Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0042E8D54
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 17:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbhACQ4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 11:56:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47568 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727650AbhACQ4l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 11:56:41 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kw6ff-00Fo7T-Ku; Sun, 03 Jan 2021 17:55:59 +0100
Date:   Sun, 3 Jan 2021 17:55:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 1/2] net: phy: micrel: Add KS8851 PHY support
Message-ID: <X/H3H1hr66tU0g7V@lunn.ch>
References: <20201230125358.1023502-1-marex@denx.de>
 <X+ygLXjVd3rr8Vbf@lunn.ch>
 <19fac48e-dd17-26d8-0ebc-c08b51876861@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19fac48e-dd17-26d8-0ebc-c08b51876861@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 03, 2021 at 01:55:22PM +0100, Marek Vasut wrote:
> On 12/30/20 4:43 PM, Andrew Lunn wrote:
> > On Wed, Dec 30, 2020 at 01:53:57PM +0100, Marek Vasut wrote:
> > > The KS8851 has a reduced internal PHY, which is accessible through its
> > > registers at offset 0xe4. The PHY is compatible with KS886x PHY present
> > > in Micrel switches, except the PHY ID Low/High registers are swapped.
> > 
> > Can you intercept the reads in the KS8851 driver and swap them back
> > again? The mv88e6xxx driver does something similar. The mv88e6393
> > family of switches have PHYs with the Marvell OUI but no device ID. So
> > the code traps these reads and provides an ID.
> 
> I would prefer to keep this as-is, since then the PHY driver can match on
> these swapped IDs and discern the PHY from PHY present in the KS886x switch.

The problem is, this ID contains an OUI. Well, part of an OUI, the top
two bits of the OUI are removed, leaving 22 bits of a 24 bit
OUI. These OUIs are assigned to companies, well organisations. If you
look at the reversed PHY ID, what are the 4 possible OUIs? Who are
they assigned to? Are they ever likely to manufacture a PHY?

	 Andrew
