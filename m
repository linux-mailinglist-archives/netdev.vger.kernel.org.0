Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F37207578
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 16:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389909AbgFXOR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 10:17:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58536 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388693AbgFXOR1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 10:17:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jo6DN-0022IO-QQ; Wed, 24 Jun 2020 16:17:25 +0200
Date:   Wed, 24 Jun 2020 16:17:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Mack <daniel@zonque.org>
Cc:     netdev@vger.kernel.org, jcobham@questertangent.com
Subject: Re: [PATCH v2] dsa: Allow forwarding of redirected IGMP traffic
Message-ID: <20200624141725.GG442307@lunn.ch>
References: <20200620193925.3166913-1-daniel@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200620193925.3166913-1-daniel@zonque.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 20, 2020 at 09:39:25PM +0200, Daniel Mack wrote:
> The driver for Marvell switches puts all ports in IGMP snooping mode
> which results in all IGMP/MLD frames that ingress on the ports to be
> forwarded to the CPU only.
> 
> The bridge code in the kernel can then interpret these frames and act
> upon them, for instance by updating the mdb in the switch to reflect
> multicast memberships of stations connected to the ports. However,
> the IGMP/MLD frames must then also be forwarded to other ports of the
> bridge so external IGMP queriers can track membership reports, and
> external multicast clients can receive query reports from foreign IGMP
> queriers.
> 
> Currently, this is impossible as the EDSA tagger sets offload_fwd_mark
> on the skb when it unwraps the tagged frames, and that will make the
> switchdev layer prevent the skb from egressing on any other port of
> the same switch.
> 
> To fix that, look at the To_CPU code in the DSA header and make
> forwarding of the frame possible for trapped IGMP packets.
> 
> Introduce some #defines for the frame types to make the code a bit more
> comprehensive.
> 
> This was tested on a Marvell 88E6352 variant.
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Andrew Lunn <andrew@lunn.ch>

The testing was simple regression testing, not IGMP specific.

    Andrew
