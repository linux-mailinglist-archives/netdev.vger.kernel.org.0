Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793C0448021
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 14:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239863AbhKHNTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 08:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbhKHNTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 08:19:32 -0500
X-Greylist: delayed 999 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 08 Nov 2021 05:16:48 PST
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84975C061570
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 05:16:48 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1mk4Fo-0008Ra-Cr; Mon, 08 Nov 2021 14:00:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@gnumonks.org>)
        id 1mk46x-004ORa-A2;
        Mon, 08 Nov 2021 13:50:55 +0100
Date:   Mon, 8 Nov 2021 13:50:55 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Networking <netdev@vger.kernel.org>,
        Tilman Schmidt <tilman@imap.cc>,
        Karsten Keil <isdn@linux-pingi.de>,
        gigaset307x-common@lists.sourceforge.net,
        Marcel Holtmann <marcel@holtmann.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        isdn4linux@listserv.isdn4linux.de,
        Al Viro <viro@zeniv.linux.org.uk>,
        Holger Schurig <holgerschurig@googlemail.com>
Subject: Re: [PATCH v2 5/5] isdn: move capi drivers to staging
Message-ID: <YYkdL2AsV84J950k@nataraja>
References: <20190426195849.4111040-1-arnd@arndb.de>
 <20190426195849.4111040-6-arnd@arndb.de>
 <20211108094845.cytlyen5nptv4elu@intra2net.com>
 <CAK8P3a0=+w-CR_3uUr3Vi8E7v1z1O40K81pZU6y67u5ns8tCHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0=+w-CR_3uUr3Vi8E7v1z1O40K81pZU6y67u5ns8tCHA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On Mon, Nov 08, 2021 at 11:58:23AM +0100, Arnd Bergmann wrote:
> When removal of mISDN came up last, Harald Welte mentioned that some
> of the code is still used by Osmocom/OpenBSC[1] to drive the E1 line cards.
> I'm not sure if this is still the case, of if they have since migrated
> to another driver.

In Osmocom (specifically, libosmo-abis which is used in osmo-bsc and
osmo-mgw) We currently support E1 interfaces via three drivers:

1) mISDN
2) DAHDI
3) our new open source hardware / gateware / firmware USB-E1 adapter icE1usb
   https://osmocom.org/projects/e1-t1-adapter/wiki/IcE1usb via the
   all-userspace libusb based driver osmo-e1d
   https://osmocom.org/projects/osmo-e1d/wiki/Wiki

The days of the use of TDM/E1 interface are also still far from over in
the cellular telecom operator industry - particularly so in
not-so-wealthy countries.  At my company we regularly have projects that
involve the requirement to drive E1 interfaces (typically 3GPP Abis, A and
Gb interface), even in 2021.

From my point of view, mISDN is certainly the least used driver at the
moment, given that [as far as I know] the only E1/PRI interface chipsets
it supports were for classic parallel PCI bus, which is hard to find
both in terms of E1 adapters as well as in mainboards.  Also, the cards
never supported more than 1 or 2 E1 ports, as far as I know.

I would expect the majority of the users are using DAHDI based
deployments (up to 8x E1 per PCIe slot), with some adventurous ones
requiring few portsgoing for our icE1usb.

I will inquire on the appropriate osmocom mailing list whether there are
people still using mISDN.

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
