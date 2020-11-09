Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4432ABC06
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 14:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731975AbgKINdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 08:33:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42850 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732249AbgKINdA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 08:33:00 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kc7Hq-0065hb-8j; Mon, 09 Nov 2020 14:32:46 +0100
Date:   Mon, 9 Nov 2020 14:32:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>
Subject: Re: [PATCH net-next 1/1] net: phy: Allow mdio buses to probe C45
 before falling back to C22
Message-ID: <20201109133246.GC1429655@lunn.ch>
References: <20201109124347.13087-1-vee.khee.wong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109124347.13087-1-vee.khee.wong@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 08:43:47PM +0800, Wong Vee Khee wrote:
> This patch makes mdiobus_scan() to try on C45 first as C45 can access
> all devices. This allows the function available for the PHY that
> supports for both C45 and C22.
> 
> Reviewed-by: Voon Weifeng <weifeng.voon@intel.com>
> Reviewed-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>

Hi

You need to add a user of this.

And i would like to see a more detailed explanation of why it is
needed. The PHY driver is free to do either C45 or C22 transfers.
Why does it care how the device was found?
Plus you can generally access C45 registers via the C45 over C22.  If
the PHY does not allow C45 over C22, then i expect the driver needs to
be aware of if the PHY can be access either way, and it needs to do
different things. And there is no PHY driver that i know of which does
this.

So before this goes any further, we need to see the bigger picture.

   Andrew
