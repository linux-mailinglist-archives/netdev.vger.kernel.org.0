Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB155F87A1
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 23:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJHVyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 17:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJHVyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 17:54:06 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA8C32B8C
        for <netdev@vger.kernel.org>; Sat,  8 Oct 2022 14:54:03 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-322-B0KkuonxN4-iDxIJpOcDbw-1; Sat, 08 Oct 2022 22:53:36 +0100
X-MC-Unique: B0KkuonxN4-iDxIJpOcDbw-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sat, 8 Oct
 2022 22:53:33 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Sat, 8 Oct 2022 22:53:33 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Jason A. Donenfeld'" <Jason@zx2c4.com>,
        Kees Cook <keescook@chromium.org>
CC:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Andreas Noever <andreas.noever@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?utf-8?B?Q2hyaXN0b3BoIELDtmhtd2FsZGVy?= 
        <christoph.boehmwalder@linbit.com>, Christoph Hellwig <hch@lst.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Dave Airlie" <airlied@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "Heiko Carstens" <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Huacai Chen <chenhuacai@kernel.org>,
        "Hugh Dickins" <hughd@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jan Kara <jack@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jonathan Corbet <corbet@lwn.net>,
        "Jozsef Kadlecsik" <kadlec@netfilter.org>,
        KP Singh <kpsingh@kernel.org>, Marco Elver <elver@google.com>,
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
        "x86@kernel.org" <x86@kernel.org>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Chuck Lever <chuck.lever@oracle.com>, Jan Kara <jack@suse.cz>
Subject: RE: [PATCH v3 3/5] treewide: use get_random_u32() when possible
Thread-Topic: [PATCH v3 3/5] treewide: use get_random_u32() when possible
Thread-Index: AQHY2nYZ0LDp17FxT0u8eu+L+6kCF64FCBzw
Date:   Sat, 8 Oct 2022 21:53:33 +0000
Message-ID: <69080fb8cace486db4e28e2e90f1d550@AcuMS.aculab.com>
References: <20221006165346.73159-1-Jason@zx2c4.com>
 <20221006165346.73159-4-Jason@zx2c4.com>
 <848ed24c-13ef-6c38-fd13-639b33809194@csgroup.eu>
 <CAHmME9raQ4E00r9r8NyWJ17iSXE_KniTG0onCNAfMmfcGar1eg@mail.gmail.com>
 <f10fcfbf-2da6-cf2d-6027-fbf8b52803e9@csgroup.eu>
 <6396875c-146a-acf5-dd9e-7f93ba1b4bc3@csgroup.eu>
 <CAHmME9pE4saqnwxhsAwt-xegYGjsavPOGnHCbZhUXD7kaJ+GAA@mail.gmail.com>
 <501b0fc3-6c67-657f-781e-25ee0283bc2e@csgroup.eu>
 <Y0Ayvov/KQmrIwTS@zx2c4.com> <202210071010.52C672FA9@keescook>
 <Y0BoQmVauPLC2uW5@zx2c4.com>
In-Reply-To: <Y0BoQmVauPLC2uW5@zx2c4.com>
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

RnJvbTogSmFzb24gQS4gRG9uZW5mZWxkDQo+IFNlbnQ6IDA3IE9jdG9iZXIgMjAyMiAxODo1Ng0K
Li4uDQo+ID4gR2l2ZW4gdGhlc2Uga2luZHMgb2YgbGVzcyBtZWNoYW5pY2FsIGNoYW5nZXMsIGl0
IG1heSBtYWtlIHNlbnNlIHRvIHNwbGl0DQo+ID4gdGhlc2UgZnJvbSB0aGUgInRyaXZpYWwiIGNv
bnZlcnNpb25zIGluIGEgdHJlZXdpZGUgcGF0Y2guIFRoZSBjaGFuY2Ugb2YNCj4gPiBuZWVkaW5n
IGEgcmV2ZXJ0IGZyb20gdGhlIHNpbXBsZSAxOjEgY29udmVyc2lvbnMgaXMgbXVjaCBsb3dlciB0
aGFuIHRoZQ0KPiA+IG5lZWQgdG8gcmV2ZXJ0IGJ5LWhhbmQgY2hhbmdlcy4NCj4gPg0KPiA+IFRo
ZSBDb2NjaSBzY3JpcHQgSSBzdWdnZXN0ZWQgaW4gbXkgdjEgcmV2aWV3IGdldHMgODAlIG9mIHRo
ZSBmaXJzdA0KPiA+IHBhdGNoLCBmb3IgZXhhbXBsZS4NCj4gDQo+IEknbGwgc3BsaXQgdGhpbmdz
IHVwIGludG8gYSBtZWNoYW5pY2FsIHN0ZXAgYW5kIGEgbm9uLW1lY2hhbmljYWwgc3RlcC4NCj4g
R29vZCBpZGVhLg0KDQpJJ2QgYWxzbyBkbyBzb21ldGhpbmcgYWJvdXQgdGhlICdnZXRfcmFuZG9t
X2ludCgpICYgMycgY2FzZXMuDQooaWUgcmVtYWluZGVyIGJ5IDJebi0xKQ0KVGhlc2UgY2FuIGJl
IGNvbnZlcnRlZCB0byAnZ2V0X3JhbmRvbV91OCgpICYgMycgKGV0YykuDQpTbyB0aGV5IG9ubHkg
bmVlZCBvbmUgcmFuZG9tIGJ5dGUgKG5vdCA0KSBhbmQgbm8gbXVsdGlwbHkuDQoNClBvc3NpYmx5
IHNvbWV0aGluZyBiYXNlZCBvbiAodGhlIHF1aWNrbHkgdHlwZWQsIGFuZCBub3QgQyk6DQojZGVm
aW5lIGdldF9yYW5kb21fYmVsb3codmFsKSBbDQoJaWYgKGJ1aWx0aW5fY29uc3RhbnQodmFsKSkN
CgkJQlVJTERfQlVHX09OKCF2YWwgfHwgdmFsID4gMHgxMDAwMDAwMDB1bGwpDQoJCWlmICghKHZh
bCAmICh2YWwgLSAxKSkgew0KCQkJaWYgKHZhbCA8PSAweDEwMCkNCgkJCQlyZXR1cm4gZ2V0X3Jh
bmRvbV91OCgpICYgKHZhbCAtIDEpOw0KCQkJaWYgKHZhbCA8PSAweDEwMDAwKQ0KCQkJCXJldHVy
biBnZXRfcmFuZG9tX3UxNigpICYgKHZhbCAtIDEpOw0KCQkJcmV0dXJuIGdldF9yYW5kb21fdTMy
KCkgJiAodmFsIC0gMSk7DQoJCX0NCgl9DQoJQlVJTERfQlVHX09OKHNpemVvZiAodmFsKSA+IDQp
Ow0KCXJldHVybiAoKHU2NClnZXRfcmFuZG9tX3UzMigpICogdmFsKSA+PiAzMjsNCn0NCg0KZ2V0
X3JhbmRvbV9iZWxvdygpIGlzIGEgbXVjaCBiZXR0ZXIgbmFtZSB0aGFuIHByYW5kb21fdTMyX21h
eCgpLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5
IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRp
b24gTm86IDEzOTczODYgKFdhbGVzKQ0K

