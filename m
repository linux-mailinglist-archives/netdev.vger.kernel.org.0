Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED54E2A31A6
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 18:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgKBRec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 12:34:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:54476 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727227AbgKBReb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 12:34:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E1E56AC6A;
        Mon,  2 Nov 2020 17:34:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5EFE7DA7D2; Mon,  2 Nov 2020 18:32:52 +0100 (CET)
Date:   Mon, 2 Nov 2020 18:32:50 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Pujin Shi <shipujin.t@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: ethernet: mscc: fix missing brace warning for old
 compilers
Message-ID: <20201102173250.GJ6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Pujin Shi <shipujin.t@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20201102134136.2565-1-shipujin.t@gmail.com>
 <20201102135654.gs2fa7q2y3i3sc5k@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102135654.gs2fa7q2y3i3sc5k@skbuf>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 01:56:55PM +0000, Vladimir Oltean wrote:
> On Mon, Nov 02, 2020 at 09:41:36PM +0800, Pujin Shi wrote:
> > For older versions of gcc, the array = {0}; will cause warnings:
> > 
> > drivers/net/ethernet/mscc/ocelot_vcap.c: In function 'is1_entry_set':
> > drivers/net/ethernet/mscc/ocelot_vcap.c:755:11: warning: missing braces around initializer [-Wmissing-braces]
> >     struct ocelot_vcap_u16 etype = {0};
> >            ^
> > drivers/net/ethernet/mscc/ocelot_vcap.c:755:11: warning: (near initialization for 'etype.value') [-Wmissing-braces]
> > 
> > 1 warnings generated
> > 
> > Fixes: 75944fda1dfe ("net: mscc: ocelot: offload ingress skbedit and vlan actions to VCAP IS1")
> > Signed-off-by: Pujin Shi <shipujin.t@gmail.com>
> > ---
> >  drivers/net/ethernet/mscc/ocelot_vcap.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
> > index d8c778ee6f1b..b96eab4583e7 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_vcap.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
> > @@ -752,7 +752,7 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
> >  					     dport);
> >  		} else {
> >  			/* IPv4 "other" frame */
> > -			struct ocelot_vcap_u16 etype = {0};
> > +			struct ocelot_vcap_u16 etype = {};
> >  
> >  			/* Overloaded field */
> >  			etype.value[0] = proto.value[0];
> 
> Sorry, I don't understand what the problem is, or why your patch fixes
> it. What version of gcc are you testing with?

Nothing wrong and { 0 } is the right initializer, the reports must be
from some ancient gcc but we weren't told which one either.

https://lore.kernel.org/linux-btrfs/fbddb15a-6e46-3f21-23ba-b18f66e3448a@suse.com/
