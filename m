Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D4618199D
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 14:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729625AbgCKNY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 09:24:58 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:44080 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729471AbgCKNY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 09:24:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1583933096; x=1615469096;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=B8jOMCqbDR7Zko2wwt5K6slWtjLqLe62QbciOrYB02A=;
  b=ImZXCPgBIb/sGlDFt8kfhHrwwisTC/OWCSwj2unbhuntMdF3i2kOtWN+
   3lE6BlKQAQl5apCoLAl5mVdDBOruWzpU2XufTLIzKqFdO31LX8whG/0sa
   DrmXtHnTrgSi/Nqf/YwWhToRGxNDpQVdK2YVzPF5kkweXUHmTHE26mJxJ
   w=;
IronPort-SDR: vpvvo3sE6lFS0hBuL6a3luEt9Z15gQHld8ekbtyhqP69tbJfNShd47P3KtUu3IcFjvIUzPYTSo
 OauNUXbEEF+w==
X-IronPort-AV: E=Sophos;i="5.70,541,1574121600"; 
   d="scan'208";a="30574430"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 11 Mar 2020 13:24:52 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id DC6FEA2033;
        Wed, 11 Mar 2020 13:24:51 +0000 (UTC)
Received: from EX13D08EUB003.ant.amazon.com (10.43.166.117) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Wed, 11 Mar 2020 13:24:51 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D08EUB003.ant.amazon.com (10.43.166.117) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 11 Mar 2020 13:24:49 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1497.006;
 Wed, 11 Mar 2020 13:24:49 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     "Machulsky, Zorik" <zorik@amazon.com>,
        Josh Triplett <josh@joshtriplett.org>
CC:     "Belgazal, Netanel" <netanel@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Re: [PATCH] ena: Speed up initialization 90x by reducing poll
 delays
Thread-Topic: Re: [PATCH] ena: Speed up initialization 90x by reducing poll
 delays
Thread-Index: AdX3p3qv2ZVxWOLdSTS1k/4T+/7Wlw==
Date:   Wed, 11 Mar 2020 13:24:17 +0000
Deferred-Delivery: Wed, 11 Mar 2020 13:23:58 +0000
Message-ID: <eb427583ff2444dcae18e1e37fb27918@EX13D11EUB003.ant.amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.12]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSm9zaCwNCg0KVGhhbmtzIGZvciB0YWtpbmcgdGhlIHRpbWUgdG8gd3JpdGUgdGhpcyBwYXRj
aC4gSSBoYXZlIGZhY2VkIGEgYnVnIHdoaWxlIHRlc3RpbmcgaXQgdGhhdCBJIGhhdmVuJ3QgcGlu
cG9pbnRlZCB5ZXQgdGhlIHJvb3QgY2F1c2Ugb2YgdGhlIGlzc3VlLCBidXQgaXQgc2VlbXMgdG8g
bWUgbGlrZSBhIHJhY2UgaW4gdGhlIG5ldGxpbmsgaW5mcmFzdHJ1Y3R1cmUuDQoNCkhlcmUgaXMg
dGhlIGJ1ZyBzY2VuYXJpbzoNCjEuIGNyZWF0ZWQgYWMgIGM1LjI0eGxhcmdlIGluc3RhbmNlIGlu
IEFXUyBpbiB2X3ZpcmdpbmlhIHJlZ2lvbiB1c2luZyB0aGUgZGVmYXVsdCBhbWF6b24gTGludXgg
MiBBTUkgDQoyLiBhcHBseSB5b3VyIHBhdGNoIHdvbiB0b3Agb2YgbmV0LW5leHQgdjUuMiBhbmQg
aW5zdGFsbCB0aGUga2VybmVsIChjdXJyZW50bHkgSSdtIGFibGUgdG8gYm9vdCBuZXQtbmV4dCB2
NS4yIG9ubHksIGhpZ2hlciB2ZXJzaW9ucyBvZiBuZXQtbmV4dCBzdWZmZXIgZnJvbSBlcnJvcnMg
ZHVyaW5nIGJvb3QgdGltZSkNCjMuIHJ1biAicm1tb2QgZW5hICYmIGluc21vZCBlbmEua28iIHR3
aWNlDQoNClJlc3VsdDoNClRoZSBpbnRlcmZhY2UgaXMgbm90IGluIHVwIHN0YXRlDQoNCkV4cGVj
dGVkIHJlc3VsdDoNClRoZSBpbnRlcmZhY2Ugc2hvdWxkIGJlIGluIHVwIHN0YXRlDQoNCldoYXQg
SSBrbm93IHNvIGZhcjoNCiogZW5hX3Byb2JlKCkgc2VlbXMgdG8gZmluaXNoIHdpdGggbm8gZXJy
b3JzIHdoYXRzb2V2ZXINCiogYWRkaW5nIHByaW50cyAvIGRlbGF5cyB0byBlbmFfcHJvYmUoKSBj
YXVzZXMgdGhlIGJ1ZyB0byB2YW5pc2ggb3IgbGVzcyBsaWtlbHkgdG8gb2NjdXIgZGVwZW5kaW5n
IG9uIHRoZSBhbW91bnQgb2YgZGVsYXlzIEkgYWRkDQoqIGVuYV91cCgpIGlzIG5vdCBjYWxsZWQg
YXQgYWxsIHdoZW4gdGhlIGJ1ZyBvY2N1cnMsIHNvIGl0J3Mgc29tZXRoaW5nIHRvIGRvIHdpdGgg
bmV0bGluayBub3QgaW52b2tpbmcgZGV2X29wZW4oKQ0KDQpEaWQgeW91IGZhY2Ugc3VjaCBpc3N1
ZXM/IERvIHlvdSBoYXZlIGFueSBpZGVhIHdoYXQgbWlnaHQgYmUgY2F1c2luZyB0aGlzPw0KDQo+
IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IGxpbnV4LWtlcm5lbC1vd25lckB2
Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWtlcm5lbC0NCj4gb3duZXJAdmdlci5rZXJuZWwub3JnPiBP
biBCZWhhbGYgT2YgTWFjaHVsc2t5LCBab3Jpaw0KPiA8em9yaWtAYW1hem9uLmNvbT4NCj4gU2Vu
dDogVHVlc2RheSwgTWFyY2ggMywgMjAyMCAyOjU0IEFNDQo+IFRvOiBKb3NoIFRyaXBsZXR0IDxq
b3NoQGpvc2h0cmlwbGV0dC5vcmc+DQo+IENjOiBCZWxnYXphbCwgTmV0YW5lbCA8bmV0YW5lbEBh
bWF6b24uY29tPjsgS2l5YW5vdnNraSwgQXJ0aHVyDQo+IDxha2l5YW5vQGFtYXpvbi5jb20+OyBU
emFsaWssIEd1eSA8Z3R6YWxpa0BhbWF6b24uY29tPjsgQnNoYXJhLCBTYWVlZA0KPiA8c2FlZWRi
QGFtYXpvbi5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4ga2VybmVsQHZn
ZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBlbmE6IFNwZWVkIHVwIGluaXRp
YWxpemF0aW9uIDkweCBieSByZWR1Y2luZyBwb2xsIGRlbGF5cw0KPiANCj4gDQo+IA0KPiDvu79P
biAzLzIvMjAsIDQ6NDAgUE0sICJKb3NoIFRyaXBsZXR0IiA8am9zaEBqb3NodHJpcGxldHQub3Jn
PiB3cm90ZToNCj4gDQo+IA0KPiAgICAgT24gTW9uLCBNYXIgMDIsIDIwMjAgYXQgMTE6MTY6MzJQ
TSArMDAwMCwgTWFjaHVsc2t5LCBab3JpayB3cm90ZToNCj4gICAgID4NCj4gICAgID4gT24gMi8y
OC8yMCwgNDoyOSBQTSwgIkpvc2ggVHJpcGxldHQiIDxqb3NoQGpvc2h0cmlwbGV0dC5vcmc+IHdy
b3RlOg0KPiAgICAgPg0KPiAgICAgPiAgICAgQmVmb3JlIGluaXRpYWxpemluZyBjb21wbGV0aW9u
IHF1ZXVlIGludGVycnVwdHMsIHRoZSBlbmEgZHJpdmVyIHVzZXMNCj4gICAgID4gICAgIHBvbGxp
bmcgdG8gd2FpdCBmb3IgcmVzcG9uc2VzIG9uIHRoZSBhZG1pbiBjb21tYW5kIHF1ZXVlLiBUaGUg
ZW5hDQo+IGRyaXZlcg0KPiAgICAgPiAgICAgd2FpdHMgNW1zIGJldHdlZW4gcG9sbHMsIGJ1dCB0
aGUgaGFyZHdhcmUgaGFzIGdlbmVyYWxseSBmaW5pc2hlZCBsb25nDQo+ICAgICA+ICAgICBiZWZv
cmUgdGhhdC4gUmVkdWNlIHRoZSBwb2xsIHRpbWUgdG8gMTB1cy4NCj4gICAgID4NCj4gICAgID4g
ICAgIE9uIGEgYzUuMTJ4bGFyZ2UsIHRoaXMgaW1wcm92ZXMgZW5hIGluaXRpYWxpemF0aW9uIHRp
bWUgZnJvbSAxNzMuNm1zIHRvDQo+ICAgICA+ICAgICAxLjkyMG1zLCBhbiBpbXByb3ZlbWVudCBv
ZiBtb3JlIHRoYW4gOTB4LiBUaGlzIGltcHJvdmVzIHNlcnZlciBib290DQo+IHRpbWUNCj4gICAg
ID4gICAgIGFuZCB0aW1lIHRvIG5ldHdvcmsgYnJpbmd1cC4NCj4gICAgID4NCj4gICAgID4gVGhh
bmtzIEpvc2gsDQo+ICAgICA+IFdlIGFncmVlIHRoYXQgcG9sbGluZyByYXRlIHNob3VsZCBiZSBp
bmNyZWFzZWQsIGJ1dCBwcmVmZXIgbm90IHRvIGRvIGl0DQo+IGFnZ3Jlc3NpdmVseSBhbmQgYmxp
bmRseS4NCj4gICAgID4gRm9yIGV4YW1wbGUgbGluZWFyIGJhY2tvZmYgYXBwcm9hY2ggbWlnaHQg
YmUgYSBiZXR0ZXIgY2hvaWNlLiBQbGVhc2UgbGV0DQo+IHVzIHJlLXdvcmsgYSBsaXR0bGUgdGhp
cw0KPiAgICAgPiBwYXRjaCBhbmQgYnJpbmcgaXQgdG8gcmV2aWV3LiBUaGFua3MhDQo+IA0KPiAg
ICAgVGhhdCdzIGZpbmUsIGFzIGxvbmcgYXMgaXQgaGFzIHRoZSBzYW1lIG5ldCBpbXByb3ZlbWVu
dCBvbiBib290IHRpbWUuDQo+IA0KPiAgICAgSSdkIGFwcHJlY2lhdGUgdGhlIG9wcG9ydHVuaXR5
IHRvIHRlc3QgYW55IGFsdGVybmF0ZSBhcHByb2FjaCB5b3UgbWlnaHQNCj4gICAgIGhhdmUuDQo+
IA0KPiAgICAgKEFsc28sIGFzIGxvbmcgYXMgeW91J3JlIHdvcmtpbmcgb24gdGhpcywgeW91IG1p
Z2h0IHdpc2ggdG8gbWFrZSBhDQo+ICAgICBzaW1pbGFyIGNoYW5nZSB0byB0aGUgRUZBIGRyaXZl
ciwgYW5kIHRvIHRoZSBGcmVlQlNEIGRyaXZlcnMuKQ0KPiANCj4gQWJzb2x1dGVseSEgQWxyZWFk
eSBmb3J3YXJkZWQgdGhpcyB0byB0aGUgb3duZXJzIG9mIHRoZXNlIGRyaXZlcnMuICBUaGFua3Mh
DQo+IA0KPiAgICAgPiAgICAgQmVmb3JlOg0KPiAgICAgPiAgICAgWyAgICAwLjUzMTcyMl0gY2Fs
bGluZyAgZW5hX2luaXQrMHgwLzB4NjMgQCAxDQo+ICAgICA+ICAgICBbICAgIDAuNTMxNzIyXSBl
bmE6IEVsYXN0aWMgTmV0d29yayBBZGFwdGVyIChFTkEpIHYyLjEuMEsNCj4gICAgID4gICAgIFsg
ICAgMC41MzE3NTFdIGVuYSAwMDAwOjAwOjA1LjA6IEVsYXN0aWMgTmV0d29yayBBZGFwdGVyIChF
TkEpIHYyLjEuMEsNCj4gICAgID4gICAgIFsgICAgMC41MzE5NDZdIFBDSSBJbnRlcnJ1cHQgTGlu
ayBbTE5LRF0gZW5hYmxlZCBhdCBJUlEgMTENCj4gICAgID4gICAgIFsgICAgMC41NDc0MjVdIGVu
YTogZW5hIGRldmljZSB2ZXJzaW9uOiAwLjEwDQo+ICAgICA+ICAgICBbICAgIDAuNTQ3NDI3XSBl
bmE6IGVuYSBjb250cm9sbGVyIHZlcnNpb246IDAuMC4xIGltcGxlbWVudGF0aW9uIHZlcnNpb24N
Cj4gMQ0KPiAgICAgPiAgICAgWyAgICAwLjcwOTQ5N10gZW5hIDAwMDA6MDA6MDUuMDogRWxhc3Rp
YyBOZXR3b3JrIEFkYXB0ZXIgKEVOQSkgZm91bmQgYXQNCj4gbWVtIGZlYmY0MDAwLCBtYWMgYWRk
ciAwNjpjNDoyMjowZTpkYzpkYSwgUGxhY2VtZW50IHBvbGljeTogTG93IExhdGVuY3kNCj4gICAg
ID4gICAgIFsgICAgMC43MDk1MDhdIGluaXRjYWxsIGVuYV9pbml0KzB4MC8weDYzIHJldHVybmVk
IDAgYWZ0ZXIgMTczNjE2IHVzZWNzDQo+ICAgICA+DQo+ICAgICA+ICAgICBBZnRlcjoNCj4gICAg
ID4gICAgIFsgICAgMC41MjY5NjVdIGNhbGxpbmcgIGVuYV9pbml0KzB4MC8weDYzIEAgMQ0KPiAg
ICAgPiAgICAgWyAgICAwLjUyNjk2Nl0gZW5hOiBFbGFzdGljIE5ldHdvcmsgQWRhcHRlciAoRU5B
KSB2Mi4xLjBLDQo+ICAgICA+ICAgICBbICAgIDAuNTI3MDU2XSBlbmEgMDAwMDowMDowNS4wOiBF
bGFzdGljIE5ldHdvcmsgQWRhcHRlciAoRU5BKSB2Mi4xLjBLDQo+ICAgICA+ICAgICBbICAgIDAu
NTI3MTk2XSBQQ0kgSW50ZXJydXB0IExpbmsgW0xOS0RdIGVuYWJsZWQgYXQgSVJRIDExDQo+ICAg
ICA+ICAgICBbICAgIDAuNTI3MjExXSBlbmE6IGVuYSBkZXZpY2UgdmVyc2lvbjogMC4xMA0KPiAg
ICAgPiAgICAgWyAgICAwLjUyNzIxMl0gZW5hOiBlbmEgY29udHJvbGxlciB2ZXJzaW9uOiAwLjAu
MSBpbXBsZW1lbnRhdGlvbiB2ZXJzaW9uDQo+IDENCj4gICAgID4gICAgIFsgICAgMC41Mjg5MjVd
IGVuYSAwMDAwOjAwOjA1LjA6IEVsYXN0aWMgTmV0d29yayBBZGFwdGVyIChFTkEpIGZvdW5kIGF0
DQo+IG1lbSBmZWJmNDAwMCwgbWFjIGFkZHIgMDY6YzQ6MjI6MGU6ZGM6ZGEsIFBsYWNlbWVudCBw
b2xpY3k6IExvdyBMYXRlbmN5DQo+ICAgICA+ICAgICBbICAgIDAuNTI4OTM0XSBpbml0Y2FsbCBl
bmFfaW5pdCsweDAvMHg2MyByZXR1cm5lZCAwIGFmdGVyIDE5MjAgdXNlY3MNCj4gDQoNCg==
