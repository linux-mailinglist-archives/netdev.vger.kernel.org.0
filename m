Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9A47AF955
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 11:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfIKJqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 05:46:10 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53780 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfIKJqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 05:46:10 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbeckett)
        with ESMTPSA id 4F0AE28D801
Message-ID: <3f265c5afcb2eea48410ec607d65e8f4e6a20373.camel@collabora.com>
Subject: Re: [PATCH 0/7] net: dsa: mv88e6xxx: features to handle network
 storms
From:   Robert Beckett <bob.beckett@collabora.com>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, bob.beckett@collabora.com
Date:   Wed, 11 Sep 2019 10:46:05 +0100
In-Reply-To: <20190910131951.GM32337@t480s.localdomain>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
         <20190910131951.GM32337@t480s.localdomain>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-09-10 at 13:19 -0400, Vivien Didelot wrote:
> Hi Robert,
> 
> On Tue, 10 Sep 2019 16:41:46 +0100, Robert Beckett <
> bob.beckett@collabora.com> wrote:
> > This patch-set adds support for some features of the Marvell switch
> > chips that can be used to handle packet storms.
> > 
> > The rationale for this was a setup that requires the ability to
> > receive
> > traffic from one port, while a packet storm is occuring on another
> > port
> > (via an external switch with a deliberate loop). This is needed to
> > ensure vital data delivery from a specific port, while mitigating
> > any
> > loops or DoS that a user may introduce on another port (can't
> > guarantee
> > sensible users).
> > 
> > [patch 1/7] configures auto negotiation for CPU ports connected
> > with
> > phys to enable pause frame propogation.
> > 
> > [patch 2/7] allows setting of port's default output queue priority
> > for
> > any ingressing packets on that port.
> > 
> > [patch 3/7] dt-bindings for patch 2.
> > 
> > [patch 4/7] allows setting of a port's queue scheduling so that it
> > can
> > prioritise egress of traffic routed from high priority ports.
> > 
> > [patch 5/7] dt-bindings for patch 4.
> > 
> > [patch 6/7] allows ports to rate limit their egress. This can be
> > used to
> > stop the host CPU from becoming swamped by packet delivery and
> > exhasting
> > descriptors.
> > 
> > [patch 7/7] dt-bindings for patch 6.
> > 
> > 
> > Robert Beckett (7):
> >   net/dsa: configure autoneg for CPU port
> >   net: dsa: mv88e6xxx: add ability to set default queue priorities
> > per
> >     port
> >   dt-bindings: mv88e6xxx: add ability to set default queue
> > priorities
> >     per port
> >   net: dsa: mv88e6xxx: add ability to set queue scheduling
> >   dt-bindings: mv88e6xxx: add ability to set queue scheduling
> >   net: dsa: mv88e6xxx: add egress rate limiting
> >   dt-bindings: mv88e6xxx: add egress rate limiting
> > 
> >  .../devicetree/bindings/net/dsa/marvell.txt   |  38 +++++
> >  drivers/net/dsa/mv88e6xxx/chip.c              | 122 ++++++++++++
> > ---
> >  drivers/net/dsa/mv88e6xxx/chip.h              |   5 +-
> >  drivers/net/dsa/mv88e6xxx/port.c              | 140
> > +++++++++++++++++-
> >  drivers/net/dsa/mv88e6xxx/port.h              |  24 ++-
> >  include/dt-bindings/net/dsa-mv88e6xxx.h       |  22 +++
> >  net/dsa/port.c                                |  10 ++
> >  7 files changed, 327 insertions(+), 34 deletions(-)
> >  create mode 100644 include/dt-bindings/net/dsa-mv88e6xxx.h
> 
> Feature series targeting netdev must be prefixed "PATCH net-next". As

Thanks for the info. Out of curiosity, where should I have gleaned this
info from? This is my first contribution to netdev, so I wasnt familiar
with the etiquette.

> this approach was a PoC, sending it as "RFC net-next" would be even
> more
> appropriate.
> 
> 
> Thank you,
> 
> 	Vivien

