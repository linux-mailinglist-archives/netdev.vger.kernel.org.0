Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EABF3B027F
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 13:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhFVLPS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Jun 2021 07:15:18 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:44485 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229907AbhFVLPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 07:15:09 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-248-470f9WPFPfOPrVuVhG1iDQ-1; Tue, 22 Jun 2021 12:12:50 +0100
X-MC-Unique: 470f9WPFPfOPrVuVhG1iDQ-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Jun
 2021 12:12:50 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Tue, 22 Jun 2021 12:12:50 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Maciej W. Rozycki'" <macro@orcam.me.uk>,
        Arnd Bergmann <arnd@kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Nikolai Zhubr <zhubr.2@gmail.com>,
        netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: RE: Realtek 8139 problem on 486.
Thread-Topic: Realtek 8139 problem on 486.
Thread-Index: AQHXZqun9ddGhoaceUiSd9Xuse9vp6sf31wg
Date:   Tue, 22 Jun 2021 11:12:49 +0000
Message-ID: <15eaef22bc2a4929a0d82fd98b2097c2@AcuMS.aculab.com>
References: <60B24AC2.9050505@gmail.com> <60B2E0FF.4030705@gmail.com>
 <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com>
 <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
 <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com>
 <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
 <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
 <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
 <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
 <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk>
 <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com>
 <877dipgyrb.ffs@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk>
 <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com>
 <alpine.DEB.2.21.2106211623090.779@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2106211623090.779@angie.orcam.me.uk>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej W. Rozycki
> Sent: 21 June 2021 15:42
...
>  The rule of thumb is to acknowledge early in the handler, and to work
> around broken configurations it may be desirable to also briefly mask all
> the interrupt sources with the device so as to make sure it deasserts its
> IRQ line even if another interrupt has already been queued.  OTOH if IRQ
> sharing is to be supported a device absolutely has to have an interrupt
> mask register, as the system cannot rely on masking at the interrupt
> controller if multiple devices are to be handled with a single line.  I
> suspect many of our drivers do not do such precautionary masking though.

Typically you need to:
1) stop the chip driving IRQ low.
2) process all the completed RX and TX entries.
3) clear the chip's interrupt pending bits (often write to clear).
4) check for completed RX/TX entries, back to 2 if found.
5) enable driving IRQ.

The loop (4) is needed because of the timing window between
(2) and (3).
You can swap (2) and (3) over - but then you get an additional
interrupt if packets arrive during processing - which is common.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

