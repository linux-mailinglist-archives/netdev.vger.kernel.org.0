Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEAAA5F8812
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 00:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiJHWJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 18:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiJHWJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 18:09:19 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A0230F42
        for <netdev@vger.kernel.org>; Sat,  8 Oct 2022 15:09:03 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-98-KtAFQuLTPeKLVd871cru4Q-1; Sat, 08 Oct 2022 23:08:05 +0100
X-MC-Unique: KtAFQuLTPeKLVd871cru4Q-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sat, 8 Oct
 2022 23:08:03 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Sat, 8 Oct 2022 23:08:03 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Jason A. Donenfeld'" <Jason@zx2c4.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>
CC:     Andreas Noever <andreas.noever@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        =?utf-8?B?Q2hyaXN0b3BoIELDtmhtd2FsZGVy?= 
        <christoph.boehmwalder@linbit.com>, Christoph Hellwig <hch@lst.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dave Airlie <airlied@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Helge Deller <deller@gmx.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Huacai Chen <chenhuacai@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jan Kara <jack@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Richard Weinberger" <richard@nod.at>,
        Russell King <linux@armlinux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        WANG Xuerui <kernel@xen0n.name>, Will Deacon <will@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Jan Kara <jack@suse.cz>
Subject: RE: [PATCH v4 2/6] treewide: use prandom_u32_max() when possible
Thread-Topic: [PATCH v4 2/6] treewide: use prandom_u32_max() when possible
Thread-Index: AQHY2ncm2NigVNsUqkWyNH5TWnqFQK4FDn2g
Date:   Sat, 8 Oct 2022 22:08:03 +0000
Message-ID: <01fafe0e56554b1c9c934c458b93473a@AcuMS.aculab.com>
References: <20221007180107.216067-1-Jason@zx2c4.com>
 <20221007180107.216067-3-Jason@zx2c4.com>
In-Reply-To: <20221007180107.216067-3-Jason@zx2c4.com>
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
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmFzb24gQS4gRG9uZW5mZWxkDQo+IFNlbnQ6IDA3IE9jdG9iZXIgMjAyMiAxOTowMQ0K
PiANCj4gUmF0aGVyIHRoYW4gaW5jdXJyaW5nIGEgZGl2aXNpb24gb3IgcmVxdWVzdGluZyB0b28g
bWFueSByYW5kb20gYnl0ZXMgZm9yDQo+IHRoZSBnaXZlbiByYW5nZSwgdXNlIHRoZSBwcmFuZG9t
X3UzMl9tYXgoKSBmdW5jdGlvbiwgd2hpY2ggb25seSB0YWtlcw0KPiB0aGUgbWluaW11bSByZXF1
aXJlZCBieXRlcyBmcm9tIHRoZSBSTkcgYW5kIGF2b2lkcyBkaXZpc2lvbnMuDQo+IA0KLi4uDQo+
IC0tLSBhL2xpYi9jbWRsaW5lX2t1bml0LmMNCj4gKysrIGIvbGliL2NtZGxpbmVfa3VuaXQuYw0K
PiBAQCAtNzYsNyArNzYsNyBAQCBzdGF0aWMgdm9pZCBjbWRsaW5lX3Rlc3RfbGVhZF9pbnQoc3Ry
dWN0IGt1bml0ICp0ZXN0KQ0KPiAgCQlpbnQgcmMgPSBjbWRsaW5lX3Rlc3RfdmFsdWVzW2ldOw0K
PiAgCQlpbnQgb2Zmc2V0Ow0KPiANCj4gLQkJc3ByaW50ZihpbiwgIiV1JXMiLCBwcmFuZG9tX3Uz
Ml9tYXgoMjU2KSwgc3RyKTsNCj4gKwkJc3ByaW50ZihpbiwgIiV1JXMiLCBnZXRfcmFuZG9tX2lu
dCgpICUgMjU2LCBzdHIpOw0KPiAgCQkvKiBPbmx5IGZpcnN0ICctJyBhZnRlciB0aGUgbnVtYmVy
IHdpbGwgYWR2YW5jZSB0aGUgcG9pbnRlciAqLw0KPiAgCQlvZmZzZXQgPSBzdHJsZW4oaW4pIC0g
c3RybGVuKHN0cikgKyAhIShyYyA9PSAyKTsNCj4gIAkJY21kbGluZV9kb19vbmVfdGVzdCh0ZXN0
LCBpbiwgcmMsIG9mZnNldCk7DQo+IEBAIC05NCw3ICs5NCw3IEBAIHN0YXRpYyB2b2lkIGNtZGxp
bmVfdGVzdF90YWlsX2ludChzdHJ1Y3Qga3VuaXQgKnRlc3QpDQo+ICAJCWludCByYyA9IHN0cmNt
cChzdHIsICIiKSA/IChzdHJjbXAoc3RyLCAiLSIpID8gMCA6IDEpIDogMTsNCj4gIAkJaW50IG9m
ZnNldDsNCj4gDQo+IC0JCXNwcmludGYoaW4sICIlcyV1Iiwgc3RyLCBwcmFuZG9tX3UzMl9tYXgo
MjU2KSk7DQo+ICsJCXNwcmludGYoaW4sICIlcyV1Iiwgc3RyLCBnZXRfcmFuZG9tX2ludCgpICUg
MjU2KTsNCj4gIAkJLyoNCj4gIAkJICogT25seSBmaXJzdCBhbmQgbGVhZGluZyAnLScgbm90IGZv
bGxvd2VkIGJ5IGludGVnZXINCj4gIAkJICogd2lsbCBhZHZhbmNlIHRoZSBwb2ludGVyLg0KDQpT
b21ldGhpbmcgaGFzIGdvbmUgYmFja3dhcmRzIGhlcmUuLi4uDQpBbmQgZ2V0X3JhbmRvbV91OCgp
IGxvb2tzIGEgYmV0dGVyIGZpdC4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBM
YWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBU
LCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

