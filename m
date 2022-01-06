Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FBC486646
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 15:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240228AbiAFOps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 09:45:48 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:51960 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239677AbiAFOpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 09:45:47 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-167-S1Fja6XRP0mJDfamsb7scg-1; Thu, 06 Jan 2022 14:45:42 +0000
X-MC-Unique: S1Fja6XRP0mJDfamsb7scg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Thu, 6 Jan 2022 14:45:41 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Thu, 6 Jan 2022 14:45:41 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <edumazet@google.com>,
        Peter Zijlstra <peterz@infradead.org>
CC:     "'tglx@linutronix.de'" <tglx@linutronix.de>,
        "'mingo@redhat.com'" <mingo@redhat.com>,
        'Borislav Petkov' <bp@alien8.de>,
        "'dave.hansen@linux.intel.com'" <dave.hansen@linux.intel.com>,
        'X86 ML' <x86@kernel.org>, "'hpa@zytor.com'" <hpa@zytor.com>,
        "'alexanderduyck@fb.com'" <alexanderduyck@fb.com>,
        'open list' <linux-kernel@vger.kernel.org>,
        'netdev' <netdev@vger.kernel.org>,
        "'Noah Goldstein'" <goldstein.w.n@gmail.com>
Subject: [PATCH v2] x86/lib: Remove the special case for odd-aligned buffers
 in csum-partial_64.c
Thread-Topic: [PATCH v2] x86/lib: Remove the special case for odd-aligned
 buffers in csum-partial_64.c
Thread-Index: AdgDCwHV1n1J2N5MS6O6mkuVVrK4ag==
Date:   Thu, 6 Jan 2022 14:45:41 +0000
Message-ID: <e2864e9c5d794c79aa7ee7de4abbfc6d@AcuMS.aculab.com>
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
bT4NCkFja2VkLWJ5OiBFcmljIER1bWF6ZXQNCi0tLQ0KDQpyZXNlbmQgLSB2MSBzZWVtcyB0byBo
YXZlIGdvdCBsb3N0IDotKQ0KDQp2MjogQWxzbyBkZWxldGUgZnJvbTMydG8xNigpDQogICAgQWRk
IGFja2VkLWJ5IGZyb20gRXJpYyAoaGUgc2VudCBvbmUgYXQgc29tZSBwb2ludCkNCiAgICBGaXgg
cG9zc2libGUgd2hpdGVzcGFjZSBlcnJvciBpbiB0aGUgbGFzdCBodW5rLg0KDQpUaGUgcGVuYWx0
eSBmb3IgYW55IG1pc2FsaWduZWQgYWNjZXNzIHNlZW1zIHRvIGJlIG1pbmltYWwuDQpPbiBhbiBp
Ny03NzAwIG1pc2FsaWduZWQgYnVmZmVycyBhZGQgMiBvciAzIGNsb2NrcyAoaW4gMTE1KSB0byBh
IDUxMiBieXRlDQogIGNoZWNrc3VtLg0KVGhhdCBpcyBsZXNzIHRoYW4gMSBjbG9jayBmb3IgZWFj
aCBjYWNoZSBsaW5lIQ0KVGhhdCBpcyBqdXN0IG1lYXN1cmluZyB0aGUgbWFpbiBsb29wIHdpdGgg
YW4gbGZlbmNlIHByaW9yIHRvIHJkcG1jIHRvDQpyZWFkIFBFUkZfQ09VTlRfSFdfQ1BVX0NZQ0xF
Uy4NCg0KIGFyY2gveDg2L2xpYi9jc3VtLXBhcnRpYWxfNjQuYyB8IDI4ICsrLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyNiBkZWxl
dGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2xpYi9jc3VtLXBhcnRpYWxfNjQuYyBi
L2FyY2gveDg2L2xpYi9jc3VtLXBhcnRpYWxfNjQuYw0KaW5kZXggMWY4YThmODk1MTczLi4wNjFi
MWVkNzRkNmEgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9saWIvY3N1bS1wYXJ0aWFsXzY0LmMNCisr
KyBiL2FyY2gveDg2L2xpYi9jc3VtLXBhcnRpYWxfNjQuYw0KQEAgLTExLDE2ICsxMSw2IEBADQog
I2luY2x1ZGUgPGFzbS9jaGVja3N1bS5oPg0KICNpbmNsdWRlIDxhc20vd29yZC1hdC1hLXRpbWUu
aD4NCiANCi1zdGF0aWMgaW5saW5lIHVuc2lnbmVkIHNob3J0IGZyb20zMnRvMTYodW5zaWduZWQg
YSkgDQotew0KLQl1bnNpZ25lZCBzaG9ydCBiID0gYSA+PiAxNjsgDQotCWFzbSgiYWRkdyAldzIs
JXcwXG5cdCINCi0JICAgICJhZGN3ICQwLCV3MFxuIiANCi0JICAgIDogIj1yIiAoYikNCi0JICAg
IDogIjAiIChiKSwgInIiIChhKSk7DQotCXJldHVybiBiOw0KLX0NCi0NCiAvKg0KICAqIERvIGEg
Y2hlY2tzdW0gb24gYW4gYXJiaXRyYXJ5IG1lbW9yeSBhcmVhLg0KICAqIFJldHVybnMgYSAzMmJp
dCBjaGVja3N1bS4NCkBAIC0zMCwyMiArMjAsMTIgQEAgc3RhdGljIGlubGluZSB1bnNpZ25lZCBz
aG9ydCBmcm9tMzJ0bzE2KHVuc2lnbmVkIGEpDQogICoNCiAgKiBTdGlsbCwgd2l0aCBDSEVDS1NV
TV9DT01QTEVURSB0aGlzIGlzIGNhbGxlZCB0byBjb21wdXRlDQogICogY2hlY2tzdW1zIG9uIElQ
djYgaGVhZGVycyAoNDAgYnl0ZXMpIGFuZCBvdGhlciBzbWFsbCBwYXJ0cy4NCi0gKiBpdCdzIGJl
c3QgdG8gaGF2ZSBidWZmIGFsaWduZWQgb24gYSA2NC1iaXQgYm91bmRhcnkNCisgKiBUaGUgcGVu
YWx0eSBmb3IgbWlzYWxpZ25lZCBidWZmIGlzIG5lZ2xpZ2FibGUuDQogICovDQogX193c3VtIGNz
dW1fcGFydGlhbChjb25zdCB2b2lkICpidWZmLCBpbnQgbGVuLCBfX3dzdW0gc3VtKQ0KIHsNCiAJ
dTY0IHRlbXA2NCA9IChfX2ZvcmNlIHU2NClzdW07DQotCXVuc2lnbmVkIG9kZCwgcmVzdWx0Ow0K
LQ0KLQlvZGQgPSAxICYgKHVuc2lnbmVkIGxvbmcpIGJ1ZmY7DQotCWlmICh1bmxpa2VseShvZGQp
KSB7DQotCQlpZiAodW5saWtlbHkobGVuID09IDApKQ0KLQkJCXJldHVybiBzdW07DQotCQl0ZW1w
NjQgPSByb3IzMigoX19mb3JjZSB1MzIpc3VtLCA4KTsNCi0JCXRlbXA2NCArPSAoKih1bnNpZ25l
ZCBjaGFyICopYnVmZiA8PCA4KTsNCi0JCWxlbi0tOw0KLQkJYnVmZisrOw0KLQl9DQorCXVuc2ln
bmVkIHJlc3VsdDsNCiANCiAJd2hpbGUgKHVubGlrZWx5KGxlbiA+PSA2NCkpIHsNCiAJCWFzbSgi
YWRkcSAwKjgoJVtzcmNdKSwlW3Jlc11cblx0Ig0KQEAgLTEzMCwxMCArMTEwLDYgQEAgX193c3Vt
IGNzdW1fcGFydGlhbChjb25zdCB2b2lkICpidWZmLCBpbnQgbGVuLCBfX3dzdW0gc3VtKQ0KICNl
bmRpZg0KIAl9DQogCXJlc3VsdCA9IGFkZDMyX3dpdGhfY2FycnkodGVtcDY0ID4+IDMyLCB0ZW1w
NjQgJiAweGZmZmZmZmZmKTsNCi0JaWYgKHVubGlrZWx5KG9kZCkpIHsNCi0JCXJlc3VsdCA9IGZy
b20zMnRvMTYocmVzdWx0KTsNCi0JCXJlc3VsdCA9ICgocmVzdWx0ID4+IDgpICYgMHhmZikgfCAo
KHJlc3VsdCAmIDB4ZmYpIDw8IDgpOw0KLQl9DQogCXJldHVybiAoX19mb3JjZSBfX3dzdW0pcmVz
dWx0Ow0KIH0NCiBFWFBPUlRfU1lNQk9MKGNzdW1fcGFydGlhbCk7DQotLSANCjIuMTcuMQ0KDQot
DQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwg
TWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2Fs
ZXMpDQo=

