Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C81545AEB
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 12:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfFNKu3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Jun 2019 06:50:29 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:60460 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727054AbfFNKu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 06:50:28 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-84-SRaRB_jZPHixQ5QjJdckwQ-1; Fri, 14 Jun 2019 11:50:24 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 14 Jun 2019 11:50:23 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 14 Jun 2019 11:50:23 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alexei Starovoitov' <alexei.starovoitov@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        "Kairui Song" <kasong@redhat.com>
Subject: RE: [PATCH 6/9] x86/bpf: Fix JIT frame pointer usage
Thread-Topic: [PATCH 6/9] x86/bpf: Fix JIT frame pointer usage
Thread-Index: AQHVIjMat8Fq1dO6sUKm4aXwvliIEKaa+Ndg
Date:   Fri, 14 Jun 2019 10:50:23 +0000
Message-ID: <57f6e69da6b3461a9c39d71aa1b58662@AcuMS.aculab.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <03ddea21a533b7b0e471c1d73ebff19dacdcf7e3.1560431531.git.jpoimboe@redhat.com>
 <20190613215807.wjcop6eaadirz5xm@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190613215807.wjcop6eaadirz5xm@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: SRaRB_jZPHixQ5QjJdckwQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 08:21:03AM -0500, Josh Poimboeuf wrote:
> The BPF JIT code clobbers RBP.  This breaks frame pointer convention and
> thus prevents the FP unwinder from unwinding through JIT generated code.
>
> RBP is currently used as the BPF stack frame pointer register.  The
> actual register used is opaque to the user, as long as it's a
> callee-saved register.  Change it to use R12 instead.

Could you maintain the system %rbp chain through the BPF stack?
It might even be possible to put something relevant in the %rip
location.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

