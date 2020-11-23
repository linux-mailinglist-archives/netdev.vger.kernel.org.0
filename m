Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFF92C0E6F
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389356AbgKWPGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:06:22 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35222 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731153AbgKWPGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:06:22 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id CB8A61F44B7F
Message-ID: <c0e98111cafbdbb5d4d29e5e87ae779144370cf6.camel@collabora.com>
Subject: Re: [PATCH] dpaa2-eth: Fix compile error due to missing devlink
 support
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "kernel@collabora.com" <kernel@collabora.com>
Date:   Mon, 23 Nov 2020 12:06:14 -0300
In-Reply-To: <20201123093928.pfvlpcdssjaxa37d@skbuf>
References: <20201122002336.79912-1-ezequiel@collabora.com>
         <20201123093928.pfvlpcdssjaxa37d@skbuf>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana,

On Mon, 2020-11-23 at 09:39 +0000, Ioana Ciornei wrote:
> Hi Ezequiel,
> 
> Thanks a lot for the fix, I overlooked this when adding devlink support.
> 

No worries :)

> On Sat, Nov 21, 2020 at 09:23:36PM -0300, Ezequiel Garcia wrote:
> > The dpaa2 driver depends on devlink, so it should select
> > NET_DEVLINK in order to fix compile errors, such as:
> > 
> > drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.o: in function `dpaa2_eth_rx_err':
> > dpaa2-eth.c:(.text+0x3cec): undefined reference to `devlink_trap_report'
> > drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.o: in function `dpaa2_eth_dl_info_get':
> > dpaa2-eth-devlink.c:(.text+0x160): undefined reference to `devlink_info_driver_name_put'
> > 
> 
> What tree is this intended for?
> 

Oops, I forgot about netdev rules. I guess I haven't sent
a net patch in a long time.

This patch is a fix, so I guess it's for the 'net' tree.
 
> Maybe add a fixes tag and send this towards the net tree?
> 

Would you mind too much taking care of this, putting the
Fixes you think matches best?

That would be really appreciated!

Thanks,
Ezequiel

> Ioana
> 
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> >  drivers/net/ethernet/freescale/dpaa2/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/ethernet/freescale/dpaa2/Kconfig
> > index cfd369cf4c8c..aee59ead7250 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
> > +++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
> > @@ -2,6 +2,7 @@
> >  config FSL_DPAA2_ETH
> >       tristate "Freescale DPAA2 Ethernet"
> >       depends on FSL_MC_BUS && FSL_MC_DPIO
> > +     select NET_DEVLINK
> >       select PHYLINK
> >       select PCS_LYNX
> >       help
> > --
> > 2.27.0


