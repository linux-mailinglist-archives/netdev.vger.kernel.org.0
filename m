Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FA1484728
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235907AbiADRnq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Jan 2022 12:43:46 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:39485 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234403AbiADRnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 12:43:45 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id B0983200002;
        Tue,  4 Jan 2022 17:43:41 +0000 (UTC)
Date:   Tue, 4 Jan 2022 18:43:40 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Nicolas Schodet <nico@ni.fr.eu.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [net-next 12/18] net: mac802154: Handle scan requests
Message-ID: <20220104184340.0e977727@xps13>
In-Reply-To: <CAB_54W41ZEoXzoD2_wadfMTY8anv9D9e2T5wRckdXjs7jKTTCA@mail.gmail.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
        <20211222155743.256280-13-miquel.raynal@bootlin.com>
        <CAB_54W6AZ+LGTcFsQjNx7uq=+R5v_kdF0Xm5kwWQ8ONtfOrmAw@mail.gmail.com>
        <Ycx0mwQcFsmVqWVH@ni.fr.eu.org>
        <CAB_54W41ZEoXzoD2_wadfMTY8anv9D9e2T5wRckdXjs7jKTTCA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

> I see that beacons are sent out with
> "local->beacon.mhr.fc.dest_addr_mode = IEEE802154_NO_ADDRESSING;"
> shouldn't that be a broadcast destination?

In the case of a beacon, 7.3.1.2 Beacon frame MHR field indicate:

	When the Frame Version field is 0b00–0b01:
		— The Destination Addressing mode field shall be set to
		indicated that the Destination Address and Destination
		PAN ID fields are not present.

So I think the NO_ADDRESSING choice here is legit. The destination
field however is useful in the Enhanced beacon frame case, but that's
not yet supported.

Thanks,
Miquèl
