Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2381242D676
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 11:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhJNJyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 05:54:55 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:22452 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229468AbhJNJyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 05:54:54 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-281-0kZEbeCKOrajOVXG60QEgw-1; Thu, 14 Oct 2021 10:52:48 +0100
X-MC-Unique: 0kZEbeCKOrajOVXG60QEgw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Thu, 14 Oct 2021 10:52:47 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Thu, 14 Oct 2021 10:52:47 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christophe Leroy' <christophe.leroy@csgroup.eu>,
        'Hari Bathini' <hbathini@linux.ibm.com>,
        "naveen.n.rao@linux.ibm.com" <naveen.n.rao@linux.ibm.com>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "paulus@samba.org" <paulus@samba.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [RESEND PATCH v4 0/8] bpf powerpc: Add BPF_PROBE_MEM support in
 powerpc JIT compiler
Thread-Topic: [RESEND PATCH v4 0/8] bpf powerpc: Add BPF_PROBE_MEM support in
 powerpc JIT compiler
Thread-Index: AQHXv2X2sg2Hg8STAUWVvVtx4py8mavSKAQw///02QCAACVDAA==
Date:   Thu, 14 Oct 2021 09:52:46 +0000
Message-ID: <edd852c0f36145b6a2967086bbb589fb@AcuMS.aculab.com>
References: <20211012123056.485795-1-hbathini@linux.ibm.com>
 <8091e1294ad343a88aa399417ff91aee@AcuMS.aculab.com>
 <61bc0e8e-8ab9-f837-1b44-1e193567fff7@csgroup.eu>
In-Reply-To: <61bc0e8e-8ab9-f837-1b44-1e193567fff7@csgroup.eu>
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

RnJvbTogQ2hyaXN0b3BoZSBMZXJveQ0KPiBTZW50OiAxNCBPY3RvYmVyIDIwMjEgMDk6MzQNCj4g
DQo+IExlIDE0LzEwLzIwMjEgw6AgMTA6MTUsIERhdmlkIExhaWdodCBhIMOpY3JpdMKgOg0KPiA+
IEZyb206IEhhcmkgQmF0aGluaQ0KPiA+PiBTZW50OiAxMiBPY3RvYmVyIDIwMjEgMTM6MzENCj4g
Pj4NCj4gPj4gUGF0Y2ggIzEgJiAjMiBhcmUgc2ltcGxlIGNsZWFudXAgcGF0Y2hlcy4gUGF0Y2gg
IzMgcmVmYWN0b3JzIEpJVA0KPiA+PiBjb21waWxlciBjb2RlIHdpdGggdGhlIGFpbSB0byBzaW1w
bGlmeSBhZGRpbmcgQlBGX1BST0JFX01FTSBzdXBwb3J0Lg0KPiA+PiBQYXRjaCAjNCBpbnRyb2R1
Y2VzIFBQQ19SQVdfQlJBTkNIKCkgbWFjcm8gaW5zdGVhZCBvZiBvcGVuIGNvZGluZw0KPiA+PiBi
cmFuY2ggaW5zdHJ1Y3Rpb24uIFBhdGNoICM1ICYgIzcgYWRkIEJQRl9QUk9CRV9NRU0gc3VwcG9y
dCBmb3IgUFBDNjQNCj4gPj4gJiBQUEMzMiBKSVQgY29tcGlsZXJzIHJlc3BlY3RpdmVseS4gUGF0
Y2ggIzYgJiAjOCBoYW5kbGUgYmFkIHVzZXJzcGFjZQ0KPiA+PiBwb2ludGVycyBmb3IgUFBDNjQg
JiBQUEMzMiBjYXNlcyByZXNwZWN0aXZlbHkuDQo+ID4NCj4gPiBJIHRob3VnaHQgdGhhdCBCUEYg
d2FzIG9ubHkgYWxsb3dlZCB0byBkbyBmYWlybHkgcmVzdHJpY3RlZA0KPiA+IG1lbW9yeSBhY2Nl
c3NlcyAtIHNvIFdURiBkb2VzIGl0IG5lZWQgYSBCUEZfUFJPQkVfTUVNIGluc3RydWN0aW9uPw0K
PiA+DQo+IA0KPiANCj4gTG9va3MgbGlrZSBpdCdzIGJlZW4gYWRkZWQgYnkgY29tbWl0IDJhMDI3
NTllZjVmOCAoImJwZjogQWRkIHN1cHBvcnQgZm9yDQo+IEJURiBwb2ludGVycyB0byBpbnRlcnBy
ZXRlciIpDQo+IA0KPiBUaGV5IHNheSBpbiB0aGUgbG9nOg0KPiANCj4gICAgICBQb2ludGVyIHRv
IEJURiBvYmplY3QgaXMgYSBwb2ludGVyIHRvIGtlcm5lbCBvYmplY3Qgb3IgTlVMTC4NCj4gICAg
ICBUaGUgbWVtb3J5IGFjY2VzcyBpbiB0aGUgaW50ZXJwcmV0ZXIgaGFzIHRvIGJlIGRvbmUgdmlh
DQo+ICAgICAgcHJvYmVfa2VybmVsX3JlYWQgdG8gYXZvaWQgcGFnZSBmYXVsdHMuDQoNCkhtbW0u
Li4uDQoNCkVpdGhlciB0aGUgcG9pbnRlciBzaG91bGQgYmUgdmFsaWQgKGlmIG5vdCBOVUxMKSBv
ciB0aGV5IHNob3VsZA0KdmVyaWZ5IHRoYXQgaXQgaXMgdGhlIGFkZHJlc3Mgb2YgYW4gaW50ZXJw
cmV0ZXIuDQpJZiB0aGUgdmFsdWUgaXMgYmVpbmcgcGFzc2VkIHRvL2Zyb20gdXNlcnNwYWNlIHRo
ZW4gdGhleQ0KYXJlIGxlYWtpbmcga2VybmVsIGFkZHJlc3MgLSBhbmQgdGhhdCBuZWVkcyB0byBi
ZSBzcXVhc2hlZC4NCg0KVGhleSBzaG91bGQgYmUgdXNpbmcgYW4gb3BhcXVlIGlkZW50aWZpZXIg
Zm9yIHRoZSBpbnRlcnByZXRlci4NCg0KTXkgZ3V0IGZlZWxpbmcgaXMgdGhhdCBhIGxvdCBvZiB0
aGUgY2hhbmdlcyB0byBicGYgb3ZlciB0aGUgbGFzdA0KZmV3IHllYXJzIG1lYW5zIHRoYXQgaXQg
aXMgbm8gbG9uZ2VyIGEgdmVyaWZpYWJseSBzYWZlIHNpbXBsZQ0KZmlsdGVyIGVuZ2luZS4NCkFz
IHN1Y2ggdGhlIHlvdSBtaWdodCBhcyB3ZWxsIGxvYWQgYSBub3JtYWwga2VybmVsIG1vZHVsZS4N
Cg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2Fk
LCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5v
OiAxMzk3Mzg2IChXYWxlcykNCg==

