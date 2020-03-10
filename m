Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5572D180063
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 15:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgCJOju convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 10 Mar 2020 10:39:50 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:39361 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbgCJOju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 10:39:50 -0400
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id CC5BF40015;
        Tue, 10 Mar 2020 14:39:47 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200310132402.GF5932@lunn.ch>
References: <20200310090720.521745-1-antoine.tenart@bootlin.com> <20200310090720.521745-3-antoine.tenart@bootlin.com> <20200310132402.GF5932@lunn.ch>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Re: [PATCH net-next 2/3] net: phy: mscc: split the driver into separate files
To:     Andrew Lunn <andrew@lunn.ch>
Message-ID: <158385110464.511694.2184737961207511908@kwain>
Date:   Tue, 10 Mar 2020 15:38:34 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

Quoting Andrew Lunn (2020-03-10 14:24:02)
> On Tue, Mar 10, 2020 at 10:07:19AM +0100, Antoine Tenart wrote:
> > +++ b/drivers/net/phy/mscc/mscc.h
> > @@ -0,0 +1,451 @@
> > +/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
> > +/*
> > + * Driver for Microsemi VSC85xx PHYs
> > + *
> > + * Copyright (c) 2016 Microsemi Corporation
> > + */
> > +
> > +#ifndef _MSCC_PHY_H_
> > +#define _MSCC_PHY_H_
> > +
> > +#if IS_ENABLED(CONFIG_MACSEC)
> > +#include <net/macsec.h>
> > +#include "mscc_macsec.h"
> > +#endif
> 
> > +#if IS_ENABLED(CONFIG_MACSEC)
> > +struct macsec_flow {
> > +     struct list_head list;
> > +     enum mscc_macsec_destination_ports port;
> > +     enum macsec_bank bank;
> > +     u32 index;
> > +     int assoc_num;
> > +     bool has_transformation;
> > +
> > +     /* Highest takes precedence [0..15] */
> > +     u8 priority;
> > +
> > +     u8 key[MACSEC_KEYID_LEN];
> > +
> > +     union {
> > +             struct macsec_rx_sa *rx_sa;
> > +             struct macsec_tx_sa *tx_sa;
> > +     };
> > +
> > +     /* Matching */
> > +     struct {
> > +             u8 sci:1;
> > +             u8 tagged:1;
> > +             u8 untagged:1;
> > +             u8 etype:1;
> > +     } match;
> > +
> > +     u16 etype;
> > +
> > +     /* Action */
> > +     struct {
> > +             u8 bypass:1;
> > +             u8 drop:1;
> > +     } action;
> > +
> > +};
> > +#endif
> 
> Could some of this be moved into mscc_macsec.h? It would reduce the
> number of #ifdefs.

You're right, will do in v2.

Do you also want the '#if IS_ENABLED(MACSEC)' to be in the mscc_macsec.h
file, for the whole file, or do I keep its inclusion conditional here?

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
