Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6F02567F0
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 15:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgH2NhP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 29 Aug 2020 09:37:15 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:58058 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728069AbgH2NhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 09:37:06 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-260-sruLeLQHO6G7wRvBN5rGQw-1; Sat, 29 Aug 2020 14:37:02 +0100
X-MC-Unique: sruLeLQHO6G7wRvBN5rGQw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sat, 29 Aug 2020 14:37:02 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sat, 29 Aug 2020 14:37:02 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Bart Groeneveld' <avi@bartavi.nl>,
        Patches internal <patches.internal@link.bartavi.nl>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] net: Use standardized (IANA) local port range
Thread-Topic: [PATCH v2] net: Use standardized (IANA) local port range
Thread-Index: AQHWfXt8zR3om+J6ikuVkMpiekBWLKlPFWkw
Date:   Sat, 29 Aug 2020 13:37:01 +0000
Message-ID: <30c8e904e2114204a4381034e7ee06c7@AcuMS.aculab.com>
References: <20200821142533.45694-1-avi@bartavi.nl>
 <20200828203959.32010-1-avi@bartavi.nl>
In-Reply-To: <20200828203959.32010-1-avi@bartavi.nl>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bart Groeneveld
> Sent: 28 August 2020 21:40
> 
> IANA specifies User ports as 1024-49151,
> and Private ports (local/ephemeral/dynamic/w/e) as 49152-65535 [1].
> 
> This means Linux uses 32768-49151 'illegally'.
> This is not just a matter of following specifications:
> IANA actually assigns numbers in this range [1].

Linux is using the 'historic' values.
IANA shouldn't really have 'grabbed' half the port number space.
Really the 'problem' of TCP port numbers identifying the service
as well as the connection should have been addresses by some other
means (eg using port 1023 and a TCP option to select the serivce).

Changing the default base from 32k to 48k will break some existing
systems if/when a kernel upgrade is installed.

You are also changing the numbers for UDP.
Anyone doing a lot of RTP (which typically requires 2 adjacent
UDP ports) is already constrained by the availability or ports.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

