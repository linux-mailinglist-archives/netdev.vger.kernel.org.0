Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA1123D721
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 09:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgHFHBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 03:01:54 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:36886 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbgHFHBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 03:01:12 -0400
Date:   Thu, 06 Aug 2020 07:00:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1596697223; bh=3nGtUTmS9BNtTtM1gkpxEQZptO+mShCiS6N0ZC8pKhg=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=D7VX6z0rsvk+TzSk0VFjsgW9P0xgKDCJSDNLxIsHE1KqJNyKX5m5ztlSXDfPg4wTL
         5WSz/Mq9cIUb8lxWHmE+XPlwF1saSMxeJkFjc4jb0SaIjKmE21EjoIcjs13G2nw/bt
         QIILriMfFvp+OWgmHeMBx/8t5e+Dg8Xjb0JSvf0//tCqqZlM6yvUJtNSeNMV556X1U
         lGNIjpR2tdNekmgLN+IkdmFjpVwV250W7CwSnzocZdIrCoI5Ek69UM8prH0Bti/yvh
         xE2OWOGTUlqKMk9qeBxPrYmk9lwnRuVGSPpvqHTxZS5oeM/eWFoGgxXPkRfknXKqtA
         XiKGNArlbggAg==
To:     Ido Schimmel <idosch@idosch.org>
From:   Swarm NameRedacted <thesw4rm@pm.me>
Cc:     netdev@vger.kernel.org
Reply-To: Swarm NameRedacted <thesw4rm@pm.me>
Subject: Re: Packet not rerouting via different bridge interface after modifying destination IP in TC ingress hook
Message-ID: <20200806070011.fmqvd4hekpehx425@chillin-at-nou.localdomain>
In-Reply-To: <20200806063336.GA2621096@shredder>
References: <20200805081951.4iznjdgudulitamc@chillin-at-nou.localdomain> <20200805133922.GB1960434@lunn.ch> <20200805201204.vsnav57fmgqkkpxf@chillin-at-nou.localdomain> <20200806063336.GA2621096@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not sure this applies. There's no NAT since everything is on the same
subnet.=20

On Thu, Aug 06, 2020 at 09:33:36AM +0300, Ido Schimmel wrote:
>=20
> On Wed, Aug 05, 2020 at 08:12:08PM +0000, Swarm NameRedacted wrote:
> > All fair points, I'll address them one by one.
> > 1) The subnet size on everything is /16; everything is on the same
> > subnet (hence the bridge) except for the client which sends the initial
> > SYN packet. Modifying the destination MAC address was definitely
> > something I overlooked and that did get the packet running through the
> > correct interface. I got a bit thrown off that the bridge has it's own
> > MAC address that is identical to the LAN interface and couldn't
> > visualize it as an L2 switch. However, the packet is still being
> > dropped; I suspect it might be a checksum error but the only incorrect
> > checksum is TCP. Might have accidentally disabled checksum offloading. =
I'm not
> > sure
>=20
> You might need to enable hairpin on eth0:
>=20
> # ip link set dev eth0 type bridge_slave hairpin on

