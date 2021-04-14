Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72E835FD9C
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 00:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhDNWP7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Apr 2021 18:15:59 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:59604 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231190AbhDNWP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 18:15:56 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-25--oniYePLPMOd-9P8htIOKg-1; Wed, 14 Apr 2021 23:15:31 +0100
X-MC-Unique: -oniYePLPMOd-9P8htIOKg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Wed, 14 Apr 2021 23:15:30 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.012; Wed, 14 Apr 2021 23:15:30 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andrii Nakryiko' <andrii@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@fb.com" <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "kernel-team@fb.com" <kernel-team@fb.com>
Subject: RE: [PATCH bpf-next 13/17] selftests/bpf: use -O0 instead of -Og in
 selftests builds
Thread-Topic: [PATCH bpf-next 13/17] selftests/bpf: use -O0 instead of -Og in
 selftests builds
Thread-Index: AQHXMWkm74DPrT5OVUW9u8EB2lisO6q0k5Aw
Date:   Wed, 14 Apr 2021 22:15:30 +0000
Message-ID: <00d978e4cf484fecb907a7035201c975@AcuMS.aculab.com>
References: <20210414200146.2663044-1-andrii@kernel.org>
 <20210414200146.2663044-14-andrii@kernel.org>
In-Reply-To: <20210414200146.2663044-14-andrii@kernel.org>
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

From: Andrii Nakryiko
> Sent: 14 April 2021 21:02
> 
> While -Og is designed to work well with debugger, it's still inferior to -O0
> in terms of debuggability experience. It will cause some variables to still be
> inlined, it will also prevent single-stepping some statements and otherwise
> interfere with debugging experience. So switch to -O0 which turns off any
> optimization and provides the best debugging experience.

Surely the selftests need to use the normal compiler options
so the compiler is generating the same type of code.
Otherwise you are likely to miss out some instructions completely.

For normal code I actually prefer using -O2 when dubugging.
If/when you need to look at the generated code you can see
the wood for the trees, with -O0 the code is typically
full of memory read/write to/from the stack.

About the only annoying thing is tail-calls.
They can get confusing.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

