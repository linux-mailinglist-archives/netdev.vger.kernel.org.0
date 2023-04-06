Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33116DA609
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 00:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239399AbjDFW7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 18:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239314AbjDFW7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 18:59:44 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA24A3
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 15:59:42 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 163DF2C0580;
        Fri,  7 Apr 2023 10:59:35 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1680821975;
        bh=DCVQy/4aUCcqjlIwJbqgMuRMIMGXNmkWAzo+9Vb0FW0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=CD9Xq3UEDoPnT/jqjL67cTMfWFHCQjowvx7tTD8zjWHtopB902tClxqNKV5CuyNba
         lilcmlk6eX67vao5kRSOZS8Bq1OdcqKRxBX1EbyNAPidSY+vGc8JAENFMB0Z3BAKKb
         re/TQuIGsqzRAPGq9UdjjEjpxiVjeCYfXWAwQ2LTtK/Un4W4smJ7yZKul6grHVqc3n
         LpF6igZz6OCfkTeXXR4k5TyQzz8Jx1r2lcYgqVRAWhrzlkk+DHD3i/coS9ZeYUL7gE
         +pQ6hgvgZgvYgjyzITBykE2fkMpcPzt5jqh2GPxTwO6tdOIDRNEo4lpdA9rLBewRda
         lKpCNBGT+3byQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B642f4ed60000>; Fri, 07 Apr 2023 10:59:34 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 7 Apr 2023 10:59:33 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.048; Fri, 7 Apr 2023 10:59:33 +1200
From:   Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
To:     "ashumnik9@gmail.com" <ashumnik9@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "edumazet@google.com" <edumazet@google.com>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "a@unstable.cc" <a@unstable.cc>
Subject: Re: [BUG] gre interface incorrectly generates link-local addresses
Thread-Topic: [BUG] gre interface incorrectly generates link-local addresses
Thread-Index: AQHZXqDEeI+88FfXw0GKYKB5JOW0Tq8dq8aAgACEbgA=
Date:   Thu, 6 Apr 2023 22:59:33 +0000
Message-ID: <be4cd6bf2103caa42f475739a3dc6a841e1c6542.camel@alliedtelesis.co.nz>
References: <CAJGXZLhL-LLjiA-ge8O5A5NDoZ5JABqZHqix0y-8ThcJjBSe=A@mail.gmail.com>
         <20230324153407.096d6248@kernel.org>
         <CAJGXZLi7LedV_MYr==1RsN6goth73Y4txA=neci_QQcwa5Oqvw@mail.gmail.com>
In-Reply-To: <CAJGXZLi7LedV_MYr==1RsN6goth73Y4txA=neci_QQcwa5Oqvw@mail.gmail.com>
Accept-Language: en-GB, en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:25:642:1aff:fe08:1270]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B82BCFD318C7654CAFF14BAF7DC1C539@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=NayYKFL4 c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dKHAf1wccvYA:10 a=VwQbUJbxAAAA:8 a=NEAV23lmAAAA:8 a=jJc_k--Hmfcm_WrrQZUA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gQWxla3NleSwNCg0KU29ycnksIEkgd2FzIG9uIGxlYXZlIGR1cmluZyBNYXJjaCBzbyBv
bmx5IGdldHRpbmcgdG8gdGhpcyBub3cuIEkgd2lsbA0KaGF2ZSBhIHByb3BlciBsb29rIGF0IHRo
aXMgd2hlbiBJIGdldCBiYWNrIHRvIHdvcmsgb24gVHVlc2RheSBhbmQgdHJ5DQp0byByZXByb2R1
Y2UgeW91ciBpc3N1ZS4NCg0KTXkgaXNzdWUgd2FzIG9uIG91ciByb3V0ZXJzIHVzaW5nIGtlcm5l
bCA1LjE1Ljg5IGFuZCB3ZSBkb24ndA0KdXNlIC9ldGMvbmV0d29yay9pbnRlcmZhY2VzIGZvciBj
b25maWd1cmF0aW9uLiBUaGUgdHVubmVsIHdhcyBjcmVhdGVkDQp3aXRoIG5ldGxpbmsgbWVzc2Fn
ZXMgbGlrZSB3aXRoIHRoZSAiaXAgbGluayIgY29tbWFuZCBhbmQgYW4gSVB2NiBsaW5rDQpsb2Nh
bCBhZGRyZXNzIGlzIGdlbmVyYXRlZCBieQ0Kc2V0dGluZyAvcHJvYy9zeXMvbmV0L2lwdjYvY29u
Zi90dW5uZWwwL2FkZHJfZ2VuX21vZGUgYnV0IHRoaXMgYnJva2UNCmFmdGVyIGNvbW1pdCBlNWRk
NzI5NDYwY2EuIEkgZGlkIG5vdCBzZWUgYW55IGhhbmdpbmcgYWRkcmVzc2VzIGxpa2UgeW91DQpk
ZXNjcmliZWQuDQoNClJlZ2FyZHMsDQpUaG9tYXMNCg0KT24gVGh1LCAyMDIzLTA0LTA2IGF0IDE4
OjA0ICswMzAwLCBBbGVrc2V5IFNodW1uaWsgd3JvdGU6DQo+IERlYXIgbWFpbnRhaW5lcnMsDQo+
IA0KPiBJIHJlbWluZCB5b3UgdGhhdCB0aGUgcHJvYmxlbSBpcyBzdGlsbCByZWxldmFudC4NCj4g
VGhlIHByb2JsZW0gaXMgbm90IG9ubHkgaW4gZ2VuZXJhdGluZyB0aGUgbnVtYmVyIG9mIGxpbmst
bG9jYWwNCj4gYWRkcmVzc2VzIGluIGFuIGFtb3VudCBlcXVhbCB0byB0aGUgbnVtYmVyIG9mIGFk
ZHJlc3NlcyBvbiBhbGwNCj4gaW50ZXJmYWNlcyBkZWZpbmVkIGluIC9ldGMvbmV0d29yay9pbnRl
cmZhY2VzIGJlZm9yZSB0aGUgZ3JlDQo+IGludGVyZmFjZS4NCj4gRHVlIHRvIHRoZSBuZXcgbWV0
aG9kIG9mIGxpbmstbG9jYWwgYWRkcmVzcyBnZW5lcmF0aW9uLCB0aGUgc2FtZQ0KPiBsaW5rLWxv
Y2FsIGFkZHJlc3MgbWF5IGJlIGZvcm1lZCBvbiBzZXZlcmFsIGdyZSBpbnRlcmZhY2VzLCB3aGlj
aCBtYXkNCj4gbGVhZCB0byBlcnJvcnMgaW4gdGhlIG9wZXJhdGlvbiBvZiBzb21lIG5ldHdvcmsg
c2VydmljZXMNCj4gDQo+IFdvdWxkIHlvdSBwbGVhc2UgYW5zd2VyIHRoZSBmb2xsb3dpbmcgcXVl
c3Rpb25zDQo+ID4gV2hpY2ggbGludXggZGlzdHJpYnV0aW9uIGRpZCB5b3UgdXNlIHdoZW4geW91
IGZvdW5kIGFuIGVycm9yIHdpdGgNCj4gPiB0aGUNCj4gPiBsYWNrIG9mIGxpbmstbG9jYWwgYWRk
cmVzcyBnZW5lcmF0aW9uIG9uIHRoZSBncmUgaW50ZXJmYWNlPw0KPiA+IEFmdGVyIGZpeGluZyB0
aGUgZXJyb3IsIG9ubHkgb25lIGxpbmstbG9jYWwgYWRkcmVzcyBpcyBnZW5lcmF0ZWQ/DQo+IElz
IHRoaXMgYSBidWcgb3IgYW4gZXhwZWN0ZWQgYmVoYXZpb3I/DQo+IA0KPiBPbiBTYXQsIE1hciAy
NSwgMjAyMyBhdCAxOjM04oCvQU0gSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4g
d3JvdGU6DQo+ID4gQWRkaW5nIFRob21hcyBhcyB3ZWxsLg0KPiA+IA0KPiA+IE9uIEZyaSwgMjQg
TWFyIDIwMjMgMTk6MzU6MDYgKzAzMDAgQWxla3NleSBTaHVtbmlrIHdyb3RlOg0KPiA+ID4gRGVh
ciBNYWludGFpbmVycywNCj4gPiA+IA0KPiA+ID4gSSBmb3VuZCB0aGF0IEdSRSBhcmJpdHJhcmls
eSBoYW5ncyBJUCBhZGRyZXNzZXMgZnJvbSBvdGhlcg0KPiA+ID4gaW50ZXJmYWNlcw0KPiA+ID4g
ZGVzY3JpYmVkIGluIC9ldGMvbmV0d29yay9pbnRlcmZhY2VzIGFib3ZlIGl0c2VsZiAoZnJvbSBi
b3R0b20gdG8NCj4gPiA+IHRvcCkuIE1vcmVvdmVyLCB0aGlzIGVycm9yIG9jY3VycyBvbiBib3Ro
IGlwNGdyZSBhbmQgaXA2Z3JlLg0KPiA+ID4gDQo+ID4gPiBFeGFtcGxlIG9mIG1ncmUgaW50ZXJm
YWNlOg0KPiA+ID4gDQo+ID4gPiAxMzogbWdyZTFATk9ORTogPE1VTFRJQ0FTVCxOT0FSUCxVUCxM
T1dFUl9VUD4gbXR1IDE0MDAgcWRpc2MNCj4gPiA+IG5vcXVldWUNCj4gPiA+IHN0YXRlIFVOS05P
V04gZ3JvdXAgZGVmYXVsdCBxbGVuIDEwMDANCj4gPiA+ICAgICBsaW5rL2dyZSAwLjAuMC4wIGJy
ZCAwLjAuMC4wDQo+ID4gPiAgICAgaW5ldCAxMC4xMC4xMC4xMDAvOCBicmQgMTAuMjU1LjI1NS4y
NTUgc2NvcGUgZ2xvYmFsIG1ncmUxDQo+ID4gPiAgICAgICAgdmFsaWRfbGZ0IGZvcmV2ZXIgcHJl
ZmVycmVkX2xmdCBmb3JldmVyDQo+ID4gPiAgICAgaW5ldDYgZmU4MDo6YTBhOmE2NC82NCBzY29w
ZSBsaW5rDQo+ID4gPiAgICAgICAgdmFsaWRfbGZ0IGZvcmV2ZXIgcHJlZmVycmVkX2xmdCBmb3Jl
dmVyDQo+ID4gPiAgICAgaW5ldDYgZmU4MDo6N2YwMDoxLzY0IHNjb3BlIGhvc3QNCj4gPiA+ICAg
ICAgICB2YWxpZF9sZnQgZm9yZXZlciBwcmVmZXJyZWRfbGZ0IGZvcmV2ZXINCj4gPiA+ICAgICBp
bmV0NiBmZTgwOjphMDo2ODQyLzY0IHNjb3BlIGhvc3QNCj4gPiA+ICAgICAgICB2YWxpZF9sZnQg
Zm9yZXZlciBwcmVmZXJyZWRfbGZ0IGZvcmV2ZXINCj4gPiA+ICAgICBpbmV0NiBmZTgwOjpjMGE4
OjEyNjQvNjQgc2NvcGUgaG9zdA0KPiA+ID4gICAgICAgIHZhbGlkX2xmdCBmb3JldmVyIHByZWZl
cnJlZF9sZnQgZm9yZXZlcg0KPiA+ID4gDQo+ID4gPiBJdCBzZWVtcyB0aGF0IGFmdGVyIHRoZSBj
b3JyZWN0aW9ucyBpbiB0aGUgZm9sbG93aW5nIGNvbW1pdHMNCj4gPiA+IGh0dHBzOi8vZ2l0aHVi
LmNvbS90b3J2YWxkcy9saW51eC9jb21taXQvZTVkZDcyOTQ2MGNhOGQyZGEwMjAyOGRiZjI2NGI2
NWJlOGNkNGI1Zg0KPiA+ID4gaHR0cHM6Ly9naXRodWIuY29tL3RvcnZhbGRzL2xpbnV4L2NvbW1p
dC8zMGUyMjkxZjYxZjkzZjcxMzJjMDYwMTkwZjgzNjBkZjUyNjQ0ZWMxDQo+ID4gPiBodHRwczov
L2dpdGh1Yi5jb20vdG9ydmFsZHMvbGludXgvY29tbWl0LzIzY2EwYzJjOTM0MDZiZGIxMTUwNjU5
ZTcyMGJkYTFjZWMxZmFkMDQNCj4gPiA+IA0KPiA+ID4gaW4gZnVuY3Rpb24gYWRkX3Y0X2FkZHJz
KCkgaW5zdGVhZCBvZiBzdG9wcGluZyBhZnRlciB0aGlzIGNoZWNrOg0KPiA+ID4gDQo+ID4gPiBp
ZiAoYWRkci5zNl9hZGRyMzJbM10pIHsNCj4gPiA+ICAgICAgICAgICAgICAgICBhZGRfYWRkcihp
ZGV2LCAmYWRkciwgcGxlbiwgc2NvcGUsDQo+ID4gPiBJRkFQUk9UX1VOU1BFQyk7DQo+ID4gPiAg
ICAgICAgICAgICAgICAgYWRkcmNvbmZfcHJlZml4X3JvdXRlKCZhZGRyLCBwbGVuLCAwLCBpZGV2
LT5kZXYsDQo+ID4gPiAwLCBwZmxhZ3MsDQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgRw0KPiA+ID4gRlBfS0VSTkVM
KTsNCj4gPiA+ICAgICAgICAgICAgICAgICAgcmV0dXJuOw0KPiA+ID4gfQ0KPiA+ID4gDQo+ID4g
PiBpdCBnb2VzIGZ1cnRoZXIgYW5kIGluIHRoaXMgY3ljbGUgaGFuZ3MgYWRkcmVzc2VzIGZyb20g
YWxsDQo+ID4gPiBpbnRlcmZhY2VzIG9uIHRoZSBncmUNCj4gPiA+IA0KPiA+ID4gZm9yX2VhY2hf
bmV0ZGV2KG5ldCwgZGV2KSB7DQo+ID4gPiAgICAgICBzdHJ1Y3QgaW5fZGV2aWNlICppbl9kZXYg
PSBfX2luX2Rldl9nZXRfcnRubChkZXYpOw0KPiA+ID4gICAgICAgaWYgKGluX2RldiAmJiAoZGV2
LT5mbGFncyAmIElGRl9VUCkpIHsNCj4gPiA+ICAgICAgIHN0cnVjdCBpbl9pZmFkZHIgKmlmYTsN
Cj4gPiA+ICAgICAgIGludCBmbGFnID0gc2NvcGU7DQo+ID4gPiAgICAgICBpbl9kZXZfZm9yX2Vh
Y2hfaWZhX3J0bmwoaWZhLCBpbl9kZXYpIHsNCj4gPiA+ICAgICAgICAgICAgIGFkZHIuczZfYWRk
cjMyWzNdID0gaWZhLT5pZmFfbG9jYWw7DQo+ID4gPiAgICAgICAgICAgICBpZiAoaWZhLT5pZmFf
c2NvcGUgPT0gUlRfU0NPUEVfTElOSykNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgIGNvbnRp
bnVlOw0KPiA+ID4gICAgICAgICAgICAgaWYgKGlmYS0+aWZhX3Njb3BlID49IFJUX1NDT1BFX0hP
U1QpIHsNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgIGlmIChpZGV2LT5kZXYtPmZsYWdzJklG
Rl9QT0lOVE9QT0lOVCkNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnRp
bnVlOw0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAgZmxhZyB8PSBJRkFfSE9TVDsNCj4gPiA+
ICAgICAgICAgICAgIH0NCj4gPiA+ICAgICAgICAgICAgIGFkZF9hZGRyKGlkZXYsICZhZGRyLCBw
bGVuLCBmbGFnLA0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgSUZB
UFJPVF9VTlNQRUMpOw0KPiA+ID4gICAgICAgICAgICAgYWRkcmNvbmZfcHJlZml4X3JvdXRlKCZh
ZGRyLCBwbGVuLCAwLCBpZGV2LT5kZXYsDQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgMCwgcGZsYWdzLCBHRlBfS0VSTkVMKTsNCj4gPiA+ICAgICAgICAgICAgIH0N
Cj4gPiA+IH0NCj4gPiA+IA0KPiA+ID4gTW9yZW92ZXIsIGJlZm9yZSBzd2l0Y2hpbmcgdG8gRGVi
aWFuIDEyIGtlcm5lbCB2ZXJzaW9uIDYuMS4xNSwgSQ0KPiA+ID4gdXNlZA0KPiA+ID4gRGViaWFu
IDExIG9uIDUuMTAuMTQwLCBhbmQgdGhlcmUgd2FzIG5vIGVycm9yIGRlc2NyaWJlZCBpbiB0aGUN
Cj4gPiA+IGNvbW1pdA0KPiA+ID4gaHR0cHM6Ly9naXRodWIuY29tL3RvcnZhbGRzL2xpbnV4L2Nv
bW1pdC9lNWRkNzI5NDYwY2E4ZDJkYTAyMDI4ZGJmMjY0YjY1YmU4Y2Q0YjVmLg0KPiA+ID4gT25l
IGxpbmstbG9jYWwgYWRkcmVzcyB3YXMgYWx3YXlzIGdlbmVyYXRlZCBvbiB0aGUgZ3JlIGludGVy
ZmFjZSwNCj4gPiA+IHJlZ2FyZGxlc3Mgb2Ygd2hldGhlciB0aGUgZGVzdGluYXRpb24gb3IgdGhl
IGxvY2FsIGFkZHJlc3Mgb2YgdGhlDQo+ID4gPiB0dW5uZWwgd2FzIHNwZWNpZmllZC4NCj4gPiA+
IA0KPiA+ID4gV2hpY2ggbGludXggZGlzdHJpYnV0aW9uIGRpZCB5b3UgdXNlIHdoZW4geW91IGZv
dW5kIGFuIGVycm9yIHdpdGgNCj4gPiA+IHRoZQ0KPiA+ID4gbGFjayBvZiBsaW5rLWxvY2FsIGFk
ZHJlc3MgZ2VuZXJhdGlvbiBvbiB0aGUgZ3JlIGludGVyZmFjZT8NCj4gPiA+IEFmdGVyIGZpeGlu
ZyB0aGUgZXJyb3IsIG9ubHkgb25lIGxpbmstbG9jYWwgYWRkcmVzcyBpcyBnZW5lcmF0ZWQ/DQo+
ID4gPiBJIHRoaW5rIHRoaXMgaXMgYSBidWcgYW5kIG1vc3QgbGlrZWx5IHRoZSBwcm9ibGVtIGlz
IGluDQo+ID4gPiBnZW5lcmF0aW5nDQo+ID4gPiBkZXYtPmRldl9hZGRyLCBzaW5jZSBsaW5rLWxv
Y2FsIGlzIGZvcm1lZCBmcm9tIGl0Lg0KPiA+ID4gDQo+ID4gPiBJIHN1Z2dlc3Qgc29sdmluZyB0
aGlzIHByb2JsZW0gb3Igcm9sbCBiYWNrIHRoZSBjb2RlIGNoYW5nZXMgbWFkZQ0KPiA+ID4gaW4N
Cj4gPiA+IHRoZSBjb21tZW50cyBhYm92ZS4NCg==
