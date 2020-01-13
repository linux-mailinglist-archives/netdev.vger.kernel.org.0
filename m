Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF555139425
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 15:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgAMO7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 09:59:51 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:58355 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728843AbgAMO7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 09:59:50 -0500
X-Originating-IP: 90.76.211.102
Received: from localhost (lfbn-tou-1-1151-102.w90-76.abo.wanadoo.fr [90.76.211.102])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 2075F1BF216;
        Mon, 13 Jan 2020 14:59:47 +0000 (UTC)
Date:   Mon, 13 Jan 2020 15:59:47 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        sd@queasysnail.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        camelia.groza@nxp.com, Simon.Edelhaus@aquantia.com,
        Igor.Russkikh@aquantia.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v5 05/15] net: macsec: hardware offloading
 infrastructure
Message-ID: <20200113145947.GC3078@kwain>
References: <20200110162010.338611-1-antoine.tenart@bootlin.com>
 <20200110162010.338611-6-antoine.tenart@bootlin.com>
 <20200113143452.GA2131@nanopsycho>
 <20200113145758.GB3078@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200113145758.GB3078@kwain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 03:57:58PM +0100, Antoine Tenart wrote:
> On Mon, Jan 13, 2020 at 03:34:52PM +0100, Jiri Pirko wrote:
> > Fri, Jan 10, 2020 at 05:20:00PM CET, antoine.tenart@bootlin.com wrote:
> 
> > >+/* Checks if underlying layers implement MACsec offloading functions. */
> > >+static bool macsec_check_offload(enum macsec_offload offload,
> > >+				 struct macsec_dev *macsec)
> > >+{
> > >+	if (!macsec || !macsec->real_dev)
> > >+		return false;
> > >+
> > >+	if (offload == MACSEC_OFFLOAD_PHY)
> > 
> > You have a helper for this already - macsec_is_offloaded(). No need for
> > "offload" arg then.
> 
> Same here, except the _PHY case is different from the _MAC one. So the
> check needs to be specific to _PHY.

Also 'offload' here can be different from the one stored in the macsec
structure.

> 
> > >+		return macsec->real_dev->phydev &&
> > >+		       macsec->real_dev->phydev->macsec_ops;
> > >+
> > >+	return false;
> > >+}

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
