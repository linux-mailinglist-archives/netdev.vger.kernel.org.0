Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26642472FAC
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 15:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239706AbhLMOnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 09:43:52 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:23625 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239684AbhLMOnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 09:43:52 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-54-zFq3ZrzlNPa02HnbPWuBlQ-1; Mon, 13 Dec 2021 14:43:50 +0000
X-MC-Unique: zFq3ZrzlNPa02HnbPWuBlQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Mon, 13 Dec 2021 14:43:48 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Mon, 13 Dec 2021 14:43:48 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Noah Goldstein' <goldstein.w.n@gmail.com>,
        Eric Dumazet <edumazet@google.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "alexanderduyck@fb.com" <alexanderduyck@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: [PATCH] x86/lib: Remove the special case for odd-aligned buffers in
 csum_partial.c
Thread-Topic: [PATCH] x86/lib: Remove the special case for odd-aligned buffers
 in csum_partial.c
Thread-Index: AdfwL8CqMU0zbyVyQYmiKOZRxmZfsg==
Date:   Mon, 13 Dec 2021 14:43:48 +0000
Message-ID: <45d12aa0c95049a392d52ff239d42d83@AcuMS.aculab.com>
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
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlcmUgaXMgbm8gbmVlZCB0byBzcGVjaWFsIGNhc2UgdGhlIHZlcnkgdW51c3VhbCBvZGQtYWxp
Z25lZCBidWZmZXJzLg0KVGhleSBhcmUgbm8gd29yc2UgdGhhbiA0bisyIGFsaWduZWQgYnVmZmVy
cy4NCg0KU2lnbmVkLW9mZi1ieTogRGF2aWQgTGFpZ2h0IDxkYXZpZC5sYWlnaHRAYWN1bGFiLmNv
bT4NCi0tLQ0KDQpPbiBhbiBpNy03NzAwIG1pc2FsaWduZWQgYnVmZmVycyBhZGQgMiBvciAzIGNs
b2NrcyAoaW4gMTE1KSB0byBhIDUxMiBieXRlDQogIGNoZWNrc3VtLg0KVGhhdCBpcyBqdXN0IG1l
YXN1cmluZyB0aGUgbWFpbiBsb29wIHdpdGggYW4gbGZlbmNlIHByaW9yIHRvIHJkcG1jIHRvDQpy
ZWFkIFBFUkZfQ09VTlRfSFdfQ1BVX0NZQ0xFUy4NCg0KIGFyY2gveDg2L2xpYi9jc3VtLXBhcnRp
YWxfNjQuYyB8IDE2ICstLS0tLS0tLS0tLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDE1IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvbGliL2NzdW0t
cGFydGlhbF82NC5jIGIvYXJjaC94ODYvbGliL2NzdW0tcGFydGlhbF82NC5jDQppbmRleCA0MGI1
MjdiYTFkYTEuLmFiZjgxOWRkODUyNSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2xpYi9jc3VtLXBh
cnRpYWxfNjQuYw0KKysrIGIvYXJjaC94ODYvbGliL2NzdW0tcGFydGlhbF82NC5jDQpAQCAtMzUs
MTcgKzM1LDcgQEAgc3RhdGljIGlubGluZSB1bnNpZ25lZCBzaG9ydCBmcm9tMzJ0bzE2KHVuc2ln
bmVkIGEpDQogX193c3VtIGNzdW1fcGFydGlhbChjb25zdCB2b2lkICpidWZmLCBpbnQgbGVuLCBf
X3dzdW0gc3VtKQ0KIHsNCiAJdTY0IHRlbXA2NCA9IChfX2ZvcmNlIHU2NClzdW07DQotCXVuc2ln
bmVkIG9kZCwgcmVzdWx0Ow0KLQ0KLQlvZGQgPSAxICYgKHVuc2lnbmVkIGxvbmcpIGJ1ZmY7DQot
CWlmICh1bmxpa2VseShvZGQpKSB7DQotCQlpZiAodW5saWtlbHkobGVuID09IDApKQ0KLQkJCXJl
dHVybiBzdW07DQotCQl0ZW1wNjQgPSByb3IzMigoX19mb3JjZSB1MzIpc3VtLCA4KTsNCi0JCXRl
bXA2NCArPSAoKih1bnNpZ25lZCBjaGFyICopYnVmZiA8PCA4KTsNCi0JCWxlbi0tOw0KLQkJYnVm
ZisrOw0KLQl9DQorCXVuc2lnbmVkIHJlc3VsdDsNCiANCiAJd2hpbGUgKHVubGlrZWx5KGxlbiA+
PSA2NCkpIHsNCiAJCWFzbSgiYWRkcSAwKjgoJVtzcmNdKSwlW3Jlc11cblx0Ig0KQEAgLTEzMCwx
MCArMTIwLDYgQEAgX193c3VtIGNzdW1fcGFydGlhbChjb25zdCB2b2lkICpidWZmLCBpbnQgbGVu
LCBfX3dzdW0gc3VtKQ0KICNlbmRpZg0KIAl9DQogCXJlc3VsdCA9IGFkZDMyX3dpdGhfY2Fycnko
dGVtcDY0ID4+IDMyLCB0ZW1wNjQgJiAweGZmZmZmZmZmKTsNCi0JaWYgKHVubGlrZWx5KG9kZCkp
IHsgDQotCQlyZXN1bHQgPSBmcm9tMzJ0bzE2KHJlc3VsdCk7DQotCQlyZXN1bHQgPSAoKHJlc3Vs
dCA+PiA4KSAmIDB4ZmYpIHwgKChyZXN1bHQgJiAweGZmKSA8PCA4KTsNCi0JfQ0KIAlyZXR1cm4g
KF9fZm9yY2UgX193c3VtKXJlc3VsdDsNCiB9DQogRVhQT1JUX1NZTUJPTChjc3VtX3BhcnRpYWwp
Ow0KLS0gDQoyLjE3LjENCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5
IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRp
b24gTm86IDEzOTczODYgKFdhbGVzKQ0K

