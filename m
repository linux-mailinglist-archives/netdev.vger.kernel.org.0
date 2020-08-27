Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461E62548B9
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgH0PLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:11:00 -0400
Received: from mx20.baidu.com ([111.202.115.85]:36622 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728496AbgH0LpS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 07:45:18 -0400
Received: from BC-Mail-Ex14.internal.baidu.com (unknown [172.31.51.54])
        by Forcepoint Email with ESMTPS id 1F5F2BB29EC50F6C44C7;
        Thu, 27 Aug 2020 18:55:00 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex14.internal.baidu.com (172.31.51.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1979.3; Thu, 27 Aug 2020 18:55:00 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1979.003; Thu, 27 Aug 2020 18:55:00 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH] iavf: use kvzalloc instead of kzalloc for rx/tx_bi buffer
Thread-Topic: [PATCH] iavf: use kvzalloc instead of kzalloc for rx/tx_bi
 buffer
Thread-Index: AQHWfEuob38P5Px0rUW6ibAXXc3666lLpEvg//+NZACAAJSiUA==
Date:   Thu, 27 Aug 2020 10:54:59 +0000
Message-ID: <0c34de62642e412fbb7ff4bf2c1b123a@baidu.com>
References: <1598514788-31039-1-git-send-email-lirongqing@baidu.com>
 <6d89955c-78a2-fa00-9f39-78648d3558a0@gmail.com>
 <4557d3ad541b4272bc1286480af5e562@baidu.com>
 <cadd738c-b7a3-fd68-4883-2f23a07fb0ae@gmail.com>
In-Reply-To: <cadd738c-b7a3-fd68-4883-2f23a07fb0ae@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.19]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex14_2020-08-27 18:55:00:187
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJpYyBEdW1hemV0IFtt
YWlsdG86ZXJpYy5kdW1hemV0QGdtYWlsLmNvbV0NCj4gU2VudDogVGh1cnNkYXksIEF1Z3VzdCAy
NywgMjAyMCA1OjU1IFBNDQo+IFRvOiBMaSxSb25ncWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+
OyBFcmljIER1bWF6ZXQNCj4gPGVyaWMuZHVtYXpldEBnbWFpbC5jb20+OyBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOw0KPiBpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZw0KPiBTdWJqZWN0
OiBSZTogW1BBVENIXSBpYXZmOiB1c2Uga3Z6YWxsb2MgaW5zdGVhZCBvZiBremFsbG9jIGZvciBy
eC90eF9iaSBidWZmZXINCj4gDQo+IA0KPiANCj4gT24gOC8yNy8yMCAxOjUzIEFNLCBMaSxSb25n
cWluZyB3cm90ZToNCj4gPg0KPiA+DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+
ID4+IEZyb206IEVyaWMgRHVtYXpldCBbbWFpbHRvOmVyaWMuZHVtYXpldEBnbWFpbC5jb21dDQo+
ID4+IFNlbnQ6IFRodXJzZGF5LCBBdWd1c3QgMjcsIDIwMjAgNDoyNiBQTQ0KPiA+PiBUbzogTGks
Um9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsN
Cj4gPj4gaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmcNCj4gPj4gU3ViamVjdDogUmU6
IFtQQVRDSF0gaWF2ZjogdXNlIGt2emFsbG9jIGluc3RlYWQgb2Yga3phbGxvYyBmb3INCj4gPj4g
cngvdHhfYmkgYnVmZmVyDQo+ID4+DQo+ID4+DQo+ID4+DQo+ID4+IE9uIDgvMjcvMjAgMTI6NTMg
QU0sIExpIFJvbmdRaW5nIHdyb3RlOg0KPiA+Pj4gd2hlbiBjaGFuZ2VzIHRoZSByeC90eCByaW5n
IHRvIDQwOTYsIGt6YWxsb2MgbWF5IGZhaWwgZHVlIHRvIGENCj4gPj4+IHRlbXBvcmFyeSBzaG9y
dGFnZSBvbiBzbGFiIGVudHJpZXMuDQo+ID4+Pg0KPiA+Pj4ga3ZtYWxsb2MgaXMgdXNlZCB0byBh
bGxvY2F0ZSB0aGlzIG1lbW9yeSBhcyB0aGVyZSBpcyBubyBuZWVkIHRvIGhhdmUNCj4gPj4+IHRo
aXMgbWVtb3J5IGFyZWEgcGh5c2ljYWwgY29udGludW91c2x5Lg0KPiA+Pj4NCj4gPj4+IFNpZ25l
ZC1vZmYtYnk6IExpIFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gPj4+IC0tLQ0K
PiA+Pg0KPiA+Pg0KPiA+PiBXZWxsLCBmYWxsYmFjayB0byB2bWFsbG9jKCkgb3ZlcmhlYWQgYmVj
YXVzZSBvcmRlci0xIHBhZ2VzIGFyZSBub3QNCj4gPj4gcmVhZGlseSBhdmFpbGFibGUgd2hlbiB0
aGUgTklDIGlzIHNldHVwICh1c3VhbGx5IG9uZSB0aW1lIHBlciBib290KQ0KPiA+PiBpcyBhZGRp
bmcgVExCIGNvc3QgYXQgcnVuIHRpbWUsIGZvciBiaWxsaW9ucyBvZiBwYWNrZXRzIHRvIGNvbWUs
IG1heWJlIGZvcg0KPiBtb250aHMuDQo+ID4+DQo+ID4+IFN1cmVseSB0cnlpbmcgYSBiaXQgaGFy
ZGVyIHRvIGdldCBvcmRlci0xIHBhZ2VzIGlzIGRlc2lyYWJsZS4NCj4gPj4NCj4gPj4gIF9fR0ZQ
X1JFVFJZX01BWUZBSUwgaXMgc3VwcG9zZWQgdG8gaGVscCBoZXJlLg0KPiA+DQo+ID4gQ291bGQg
d2UgYWRkIF9fR0ZQX1JFVFJZX01BWUZBSUwgdG8ga3ZtYWxsb2MsIHRvIGVuc3VyZSB0aGUgYWxs
b2NhdGlvbg0KPiBzdWNjZXNzID8NCj4gDQo+IF9fR0ZQX1JFVFJZX01BWUZBSUwgZG9lcyBub3Qg
X2Vuc3VyZV8gdGhlIGFsbG9jYXRpb24gc3VjY2Vzcy4NCj4gDQo+IFRoZSBpZGVhIGhlcmUgaXMg
dGhhdCBmb3IgbGFyZ2UgYWxsb2NhdGlvbnMgKGJpZ2dlciB0aGFuIFBBR0VfU0laRSksDQo+IGt2
bWFsbG9jX25vZGUoKSB3aWxsIG5vdCBmb3JjZSBfX0dGUF9OT1JFVFJZLCBtZWFuaW5nIHRoYXQg
cGFnZSBhbGxvY2F0b3INCj4gd2lsbCBub3QgYmFpbG91dCBpbW1lZGlhdGVseSBpbiBjYXNlIG9m
IG1lbW9yeSBwcmVzc3VyZS4NCj4gDQo+IFRoaXMgZ2l2ZXMgYSBjaGFuY2UgZm9yIHBhZ2UgcmVj
bGFpbXMgdG8gaGFwcGVuLCBhbmQgZXZlbnR1YWxseSB0aGUgaGlnaCBvcmRlcg0KPiBwYWdlIGFs
bG9jYXRpb24gd2lsbCBzdWNjZWVkIHVuZGVyIG5vcm1hbCBjaXJjdW1zdGFuY2VzLg0KPiANCj4g
SXQgaXMgYSB0cmFkZS1vZmYsIGFuZCBvbmx5IHdvcnRoIGl0IGZvciBsb25nIGxpdmluZyBhbGxv
Y2F0aW9ucy4NCg0KVGhhbmtzLCBFcmljOyANCkkgd2lsbCBjaGFuZ2UgaXQgYXMgYmVsb3csIHRo
YXQga21hbGxvYyB3aWxsIGJlIHVzZWQgaW4gbW9zdCB0aW1lLCBhbmQgZW5zdXJlIGFsbG9jYXRp
b24gc3VjY2VzcyBpZiBmYWlsIHRvIHJlY2xhaW0gbWVtb3J5IHVuZGVyIG1lbW9yeSBwcmVzc3Vy
ZS4NCg0KQEAgLTYyMiw3ICs2MjIsNyBAQCBpbnQgaWF2Zl9zZXR1cF90eF9kZXNjcmlwdG9ycyhz
dHJ1Y3QgaWF2Zl9yaW5nICp0eF9yaW5nKQ0KICAgICAgICAvKiB3YXJuIGlmIHdlIGFyZSBhYm91
dCB0byBvdmVyd3JpdGUgdGhlIHBvaW50ZXIgKi8NCiAgICAgICAgV0FSTl9PTih0eF9yaW5nLT50
eF9iaSk7DQogICAgICAgIGJpX3NpemUgPSBzaXplb2Yoc3RydWN0IGlhdmZfdHhfYnVmZmVyKSAq
IHR4X3JpbmctPmNvdW50Ow0KLSAgICAgICB0eF9yaW5nLT50eF9iaSA9IGt6YWxsb2MoYmlfc2l6
ZSwgR0ZQX0tFUk5FTCk7DQorICAgICAgIHR4X3JpbmctPnR4X2JpID0ga3Z6YWxsb2MoYmlfc2l6
ZSwgR0ZQX0tFUk5FTHxfX0dGUF9SRVRSWV9NQVlGQUlMKTsNCiAgICAgICAgaWYgKCF0eF9yaW5n
LT50eF9iaSkNCiAgICAgICAgICAgICAgICBnb3RvIGVycjsNCiANCkBAIC02NDMsNyArNjQzLDcg
QEAgaW50IGlhdmZfc2V0dXBfdHhfZGVzY3JpcHRvcnMoc3RydWN0IGlhdmZfcmluZyAqdHhfcmlu
ZykNCg0KDQotTGkNCg==
