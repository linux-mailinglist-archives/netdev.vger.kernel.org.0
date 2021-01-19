Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5112FBE3F
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 18:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391496AbhASRsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 12:48:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47790 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728793AbhASOwx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 09:52:53 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l1sMH-001Smm-U4; Tue, 19 Jan 2021 15:51:49 +0100
Date:   Tue, 19 Jan 2021 15:51:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <YAbyBbEE7lbhpFkw@lunn.ch>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <X/+nVtRrC2lconET@lunn.ch>
 <20210119115610.GZ3565223@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119115610.GZ3565223@nanopsycho.orion>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 12:56:10PM +0100, Jiri Pirko wrote:
> Thu, Jan 14, 2021 at 03:07:18AM CET, andrew@lunn.ch wrote:
> >> $ devlink lc provision netdevsim/netdevsim10 lc 0 type card4ports
> >> $ devlink lc
> >> netdevsim/netdevsim10:
> >>   lc 0 state provisioned type card4ports
> >>     supported_types:
> >>        card1port card2ports card4ports
> >>   lc 1 state unprovisioned
> >>     supported_types:
> >>        card1port card2ports card4ports
> >
> >Hi Jiri
> >
> >> # Now activate the line card using debugfs. That emulates plug-in event
> >> # on real hardware:
> >> $ echo "Y"> /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/active
> >> $ ip link show eni10nl0p1
> >> 165: eni10nl0p1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
> >>     link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff
> >> # The carrier is UP now.
> >
> >What is missing from the devlink lc view is what line card is actually
> >in the slot. Say if i provision for a card4port, but actually insert a
> >card2port. It would be nice to have something like:
> 
> I checked, our hw does not support that. Only provides info that
> linecard activation was/wasn't successful.

Hi Jiri

Is this a firmware limitation? There is no API to extract the
information from the firmware to the host? The firmware itself knows
there is a mismatch and refuses to configure the line card, and
prevents the MAC going up?

Even if you cannot do this now, it seems likely in future firmware
versions you will be able to, so maybe at least define the netlink
attributes now? As well as attributes indicating activation was
successful.

	Andrew
