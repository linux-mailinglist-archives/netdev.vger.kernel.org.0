Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0027C6A62B6
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 23:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjB1WpK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Feb 2023 17:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjB1WpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 17:45:09 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7CC30B1D
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 14:45:06 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-71-ecQdmCC0MlGQuDzZDzZ6eg-1; Tue, 28 Feb 2023 22:45:02 +0000
X-MC-Unique: ecQdmCC0MlGQuDzZDzZ6eg-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.47; Tue, 28 Feb
 2023 22:45:00 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.047; Tue, 28 Feb 2023 22:45:00 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Russell King' <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@kernel.org>
CC:     Dominik Brodowski <linux@dominikbrodowski.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        "Ian Abbott" <abbotti@mev.co.uk>, Jakub Kicinski <kuba@kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "Olof Johansson" <olof@lixom.net>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        "YOKOTA Hiroshi" <yokota@netlab.is.tsukuba.ac.jp>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC 0/6] pcmcia: separate 16-bit support from cardbus
Thread-Topic: [RFC 0/6] pcmcia: separate 16-bit support from cardbus
Thread-Index: AQHZSuhWwIxyEez/qUesuC2XWPglYq7k9JKQ
Date:   Tue, 28 Feb 2023 22:45:00 +0000
Message-ID: <b75b24146c114e948bb2d325a8d27fda@AcuMS.aculab.com>
References: <20230227133457.431729-1-arnd@kernel.org>
 <Y/0PbJzvrzpvLbcW@shell.armlinux.org.uk>
In-Reply-To: <Y/0PbJzvrzpvLbcW@shell.armlinux.org.uk>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,PDS_BAD_THREAD_QP_64,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King
> Sent: 27 February 2023 20:16
> 
> On Mon, Feb 27, 2023 at 02:34:51PM +0100, Arnd Bergmann wrote:
> > I don't expect this to be a problem normal laptop support, as the last
> > PC models that predate Cardbus support (e.g. 1997 ThinkPad 380ED) are
> > all limited to i586MMX CPUs and 80MB of RAM. This is barely enough to
> > boot Tiny Core Linux but not a regular distro.
> 
> Am I understanding that the argument you're putting forward here is
> "cardbus started in year X, so from year X we can ignore 16-bit
> PCMCIA support" ?
> 
> Given that PCMCIA support has been present in x86 hardware at least
> up to 2010, I don't see how that is any basis for making a decision
> about 16-bit PCMCIA support.
> 
> Isn't the relevant factor here whether 16-bit PCMCIA cards are still
> in use on hardware that can run a modern distro? (And yes, x86
> machines that have 16-bit PCMCIA can still run Debian Stable today.)

Or, more specifically, are any people using 16-bit PCMCIA cards
in cardbus-capable sockets with a current kernel.
They might be using unusual cards that aren't available as
cardbus - perhaps 56k modems (does anyone still use those?).

I'm pretty sure I've used sparc systems that had slots that
would take both pcmcia and cardbus cards.
Would have been 20 years ago - but they were 64MHz PCI so wouldn't
have been that slow (I can't remember which cpu it was).
They ran Solaris, but weren't made by Sun.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

