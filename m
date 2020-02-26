Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3894B170319
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 16:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgBZPuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 10:50:13 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:44991 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgBZPuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 10:50:13 -0500
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 231821BF217;
        Wed, 26 Feb 2020 15:50:10 +0000 (UTC)
Date:   Wed, 26 Feb 2020 16:50:10 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>
Subject: Re: [EXT] Re: [RFC 00/18] net: atlantic: MACSec support for AQC
 devices
Message-ID: <20200226155010.GC3190@kwain>
References: <20200214150258.390-1-irusskikh@marvell.com>
 <20200221145751.GA3530@kwain>
 <BYAPR18MB2630CB1BE0BCD0878612F86BB7EA0@BYAPR18MB2630.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BYAPR18MB2630CB1BE0BCD0878612F86BB7EA0@BYAPR18MB2630.namprd18.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Igor,

On Wed, Feb 26, 2020 at 08:12:31AM +0000, Igor Russkikh wrote:
> 
> I'd also like to stress on the following patch:
> 
> > > 1) patch 0008:
> > >   multicast/broadcast when offloading is needed to handle ARP requests,
> > >   because they have broadcast destination address;
> > >   With this patch we also match and encrypt/decrypt packets between
> > macsec
> > >   hw and realdev based on device's mac address.
> > >   This potentially can be used to support multiple macsec offloaded
> > interfaces
> > >   on top of one realdev.
> > >   On some environments however this could lead to problems, e.g. bridge
> > over
> > >   macsec configuration will expect packets with unknown src MAC
> > >   should come through macsec.
> > >   The patch is questionable, we've used it because our current hw setup
> > and
> > >   requirements assumes decryption is only done based on mac address
> > match.
> > >   This could be changed by encrypting/decripting all the traffic (except
> > control).
> 
> We now basically see two different approaches on macsec traffic
> routing between the devices.
> 
> If HW supports per mac decryption rules, this could be used to
> implement multiple secy channels, all offloaded.  But macsec code then
> should use dst MAC to route decrypted packets to the correct macsec
> device.
> 
> Another usecase we have to support in our system is having a bridge
> device on top of macsec device. To support this we had to
> encrypt/decrypt all the traffic against the single macsec dev (i.e.
> unconditionally, without mac addr filtering).
> And this imposes a limitation of having only a single secy.
> 
> Internally, we now separate these usecases basically by private module
> param (not in this patchset).
> 
> But it'd be good to hear from you and possibly other users if these
> are legitimate configurations and if this somehow should be supported
> in the offloading API.

I thought about those two use cases, and would be interested in having
more than a single secy per interface as well. I also came up with the
idea of using the dst MAC address to differentiate virtual interfaces
but as this would not work in some setups I decided not to implement it
at the time.

I don't have a good answer for this for now, except that having a
limitation in the upstream kernel is probably better than having known
non-working setups. But I would be interested in a solution for this :)

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
