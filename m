Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD678478B75
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 13:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236351AbhLQMe6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Dec 2021 07:34:58 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:34875 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233867AbhLQMe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 07:34:58 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-157-DNhCqrEmMiq0pBhWJMMNWw-1; Fri, 17 Dec 2021 12:34:55 +0000
X-MC-Unique: DNhCqrEmMiq0pBhWJMMNWw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Fri, 17 Dec 2021 12:34:53 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Fri, 17 Dec 2021 12:34:53 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Segher Boessenkool' <segher@kernel.crashing.org>,
        Ard Biesheuvel <ardb@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Rich Felker <dalias@libc.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "Richard Russon (FlatCap)" <ldm@flatcap.org>,
        X86 ML <x86@kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        James Morris <jmorris@namei.org>,
        Eric Dumazet <edumazet@google.com>,
        Paul Mackerras <paulus@samba.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:SPARC + UltraSPARC (sparc/sparc64)" 
        <sparclinux@vger.kernel.org>, Stafford Horne <shorne@gmail.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yoshinori Sato <ysato@users.osdn.me>,
        Russell King <linux@armlinux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Jonas Bonn <jonas@southpole.se>,
        "Kees Cook" <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "openrisc@lists.librecores.org" <openrisc@lists.librecores.org>,
        Borislav Petkov <bp@alien8.de>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Arnd Bergmann" <arnd@kernel.org>,
        John Johansen <john.johansen@canonical.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ntfs-dev@lists.sourceforge.net" 
        <linux-ntfs-dev@lists.sourceforge.net>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>
Subject: RE: [PATCH v2 00/13] Unify asm/unaligned.h around struct helper
Thread-Topic: [PATCH v2 00/13] Unify asm/unaligned.h around struct helper
Thread-Index: AQHX8q6cJnIWdY3H8E+V3sMdrqJgg6w2m38Q
Date:   Fri, 17 Dec 2021 12:34:53 +0000
Message-ID: <698cfc52a0d441f7b9f29424be82b2e8@AcuMS.aculab.com>
References: <20210514100106.3404011-1-arnd@kernel.org>
 <CAMj1kXG0CNomZ0aXxh_4094fT+g4bVWFCkrd7QwgTQgiqoxMWA@mail.gmail.com>
 <20211216185620.GP614@gate.crashing.org>
In-Reply-To: <20211216185620.GP614@gate.crashing.org>
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

From: Segher Boessenkool
> Sent: 16 December 2021 18:56
...
> > The only remaining problem here is reinterpreting a char* pointer to a
> > u32*, e.g., for accessing the IP address in an Ethernet frame when
> > NET_IP_ALIGN == 2, which could suffer from the same UB problem again,
> > as I understand it.
> 
> The problem is never casting a pointer to pointer to character type, and
> then later back to an appriopriate pointer type.
> These things are both required to work.

I think that is true of 'void *', not 'char *'.
'char' is special in that 'strict aliasing' doesn't apply to it.
(Which is actually a pain sometimes.)

> The problem always is accessing something as if it
> was something of another type, which is not valid C.  This however is
> exactly what -fno-strict-aliasing allows, so that works as well.

IIRC the C language only allows you to have pointers to valid data items.
(Since they can only be generated by the & operator on a valid item.)
Indirecting any other pointer is probably UB!

This (sort of) allows the compiler to 'look through' casts to find
what the actual type is (or might be).
It can then use that information to make optimisation choices.
This has caused grief with memcpy() calls that are trying to copy
a structure that the coder knows is misaligned to an aligned buffer.

So while *(unaligned_ptr *)char_ptr probably has to work.
If the compiler can see *(unaligned_ptr *)(char *)int_ptr it can
assume the alignment of the 'int_ptr' and do a single aligned access.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

