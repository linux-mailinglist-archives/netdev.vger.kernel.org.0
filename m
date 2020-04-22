Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81F11B3A49
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgDVIj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:39:58 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:47372 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbgDVIj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:39:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587544797; x=1619080797;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=5HSl+RgDiEJ1HnZOnd1JtwP11Ny6Jipvj1yDOa13F9s=;
  b=Nc9VA71Ywg/vMtDDb+InXKgC9KYzumPGzPhqK96VL/67j1JtVSSCe7Ca
   0FJ1IUwo9f4LjwuO4I9IqecnEUB6YaiXz0A2zmYj4CGJyLY1Tk3QNtmfN
   C4OHi2ATFDtZQ0gCenzCFcbeI8fKwMTg9B3WW5X62i/8wr1pecNxEa0B2
   Q=;
IronPort-SDR: vSwhIC/7q7yxJH80eXzEFK1GJDGlxnjuvQtAvYO3q2B4HsqADTvm+3Rk1lKjJ2yVRYgcwNUDcW
 5udIqJaijYzg==
X-IronPort-AV: E=Sophos;i="5.72,413,1580774400"; 
   d="scan'208";a="40121212"
Subject: RE: [PATCH RFC v2 15/33] ena: add XDP frame size to amazon NIC driver
Thread-Topic: [PATCH RFC v2 15/33] ena: add XDP frame size to amazon NIC driver
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 22 Apr 2020 08:39:57 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id BCD67A1F68;
        Wed, 22 Apr 2020 08:39:55 +0000 (UTC)
Received: from EX13D08EUB003.ant.amazon.com (10.43.166.117) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:39:55 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D08EUB003.ant.amazon.com (10.43.166.117) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:39:54 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1497.006;
 Wed, 22 Apr 2020 08:39:54 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Daniel Borkmann" <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        "Willem de Bruijn" <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "Saeed Mahameed" <saeedm@mellanox.com>
Thread-Index: AQHWDZw7uC9ZFp8qsEi7EawEaduGtKiE52Rg
Date:   Wed, 22 Apr 2020 08:39:45 +0000
Deferred-Delivery: Wed, 22 Apr 2020 08:39:04 +0000
Message-ID: <b8a1365d043543debcb6d9f6553dee22@EX13D11EUB003.ant.amazon.com>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
 <158634671052.707275.5680515403770560550.stgit@firesoul>
In-Reply-To: <158634671052.707275.5680515403770560550.stgit@firesoul>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.178]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWNrZWQtYnk6IFNhbWVlaCBKdWJyYW4gPHNhbWVlaGpAYW1hem9uLmNvbT4NCg0KPiAtLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVyIDxicm91
ZXJAcmVkaGF0LmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBBcHJpbCA4LCAyMDIwIDI6NTIgUE0N
Cj4gVG86IEp1YnJhbiwgU2FtaWggPHNhbWVlaGpAYW1hem9uLmNvbT4NCj4gQ2M6IEtpeWFub3Zz
a2ksIEFydGh1ciA8YWtpeWFub0BhbWF6b24uY29tPjsgSmVzcGVyIERhbmdhYXJkIEJyb3Vlcg0K
PiA8YnJvdWVyQHJlZGhhdC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBicGZAdmdlci5r
ZXJuZWwub3JnOw0KPiBNYWNodWxza3ksIFpvcmlrIDx6b3Jpa0BhbWF6b24uY29tPjsgS2l5YW5v
dnNraSwgQXJ0aHVyDQo+IDxha2l5YW5vQGFtYXpvbi5jb20+OyBUemFsaWssIEd1eSA8Z3R6YWxp
a0BhbWF6b24uY29tPjsgVG9rZSBIw7hpbGFuZC0NCj4gSsO4cmdlbnNlbiA8dG9rZUByZWRoYXQu
Y29tPjsgRGFuaWVsIEJvcmttYW5uDQo+IDxib3JrbWFubkBpb2dlYXJib3gubmV0PjsgQWxleGVp
IFN0YXJvdm9pdG92DQo+IDxhbGV4ZWkuc3Rhcm92b2l0b3ZAZ21haWwuY29tPjsgSm9obiBGYXN0
YWJlbmQNCj4gPGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbT47IEFsZXhhbmRlciBEdXljaw0KPiA8
YWxleGFuZGVyLmR1eWNrQGdtYWlsLmNvbT47IEplZmYgS2lyc2hlciA8amVmZnJleS50LmtpcnNo
ZXJAaW50ZWwuY29tPjsNCj4gRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPjsgV2lsbGVt
IGRlIEJydWlqbg0KPiA8d2lsbGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNvbT47IElsaWFzIEFw
YWxvZGltYXMNCj4gPGlsaWFzLmFwYWxvZGltYXNAbGluYXJvLm9yZz47IExvcmVuem8gQmlhbmNv
bmkgPGxvcmVuem9Aa2VybmVsLm9yZz47DQo+IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFu
b3guY29tPg0KPiBTdWJqZWN0OiBbRVhURVJOQUxdIFtQQVRDSCBSRkMgdjIgMTUvMzNdIGVuYTog
YWRkIFhEUCBmcmFtZSBzaXplIHRvDQo+IGFtYXpvbiBOSUMgZHJpdmVyDQo+IA0KPiBDQVVUSU9O
OiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24u
IERvIG5vdCBjbGljaw0KPiBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2Fu
IGNvbmZpcm0gdGhlIHNlbmRlciBhbmQga25vdyB0aGUNCj4gY29udGVudCBpcyBzYWZlLg0KPiAN
Cj4gDQo+IA0KPiBGcmFtZSBzaXplIEVOQV9QQUdFX1NJWkUgaXMgbGltaXRlZCB0byAxNksgb24g
c3lzdGVtcyB3aXRoIGxhcmdlcg0KPiBQQUdFX1NJWkUgdGhhbiAxNksuIENoYW5nZSBFTkFfWERQ
X01BWF9NVFUgdG8gYWxzbyB0YWtlIGludG8gYWNjb3VudA0KPiB0aGUgcmVzZXJ2ZWQgdGFpbHJv
b20uDQo+IA0KPiBDYzogQXJ0aHVyIEtpeWFub3Zza2kgPGFraXlhbm9AYW1hem9uLmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogSmVzcGVyIERhbmdhYXJkIEJyb3VlciA8YnJvdWVyQHJlZGhhdC5jb20+
DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9uL2VuYS9lbmFfbmV0ZGV2LmMg
fCAgICAxICsNCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2FtYXpvbi9lbmEvZW5hX25ldGRldi5o
IHwgICAgNSArKystLQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDIgZGVs
ZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9u
L2VuYS9lbmFfbmV0ZGV2LmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hbWF6b24vZW5hL2Vu
YV9uZXRkZXYuYw0KPiBpbmRleCAyY2M3NjVkZjhkYTMuLjBmZDdkYjE3NjlmOCAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9uL2VuYS9lbmFfbmV0ZGV2LmMNCj4gKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9uL2VuYS9lbmFfbmV0ZGV2LmMNCj4gQEAgLTE2
MDYsNiArMTYwNiw3IEBAIHN0YXRpYyBpbnQgZW5hX2NsZWFuX3J4X2lycShzdHJ1Y3QgZW5hX3Jp
bmcNCj4gKnJ4X3JpbmcsIHN0cnVjdCBuYXBpX3N0cnVjdCAqbmFwaSwNCj4gICAgICAgICAgICAg
ICAgICAgIiVzIHFpZCAlZFxuIiwgX19mdW5jX18sIHJ4X3JpbmctPnFpZCk7DQo+ICAgICAgICAg
cmVzX2J1ZGdldCA9IGJ1ZGdldDsNCj4gICAgICAgICB4ZHAucnhxID0gJnJ4X3JpbmctPnhkcF9y
eHE7DQo+ICsgICAgICAgeGRwLmZyYW1lX3N6ID0gRU5BX1BBR0VfU0laRTsNCj4gDQo+ICAgICAg
ICAgZG8gew0KPiAgICAgICAgICAgICAgICAgeGRwX3ZlcmRpY3QgPSBYRFBfUEFTUzsNCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FtYXpvbi9lbmEvZW5hX25ldGRldi5oDQo+
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9uL2VuYS9lbmFfbmV0ZGV2LmgNCj4gaW5kZXgg
OTdkZmQwYzY3ZTg0Li5kZDAwMTI3ZGZlOWYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2FtYXpvbi9lbmEvZW5hX25ldGRldi5oDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2FtYXpvbi9lbmEvZW5hX25ldGRldi5oDQo+IEBAIC0xNTEsOCArMTUxLDkgQEANCj4gICAq
IFRoZSBidWZmZXIgc2l6ZSB3ZSBzaGFyZSB3aXRoIHRoZSBkZXZpY2UgaXMgZGVmaW5lZCB0byBi
ZSBFTkFfUEFHRV9TSVpFDQo+ICAgKi8NCj4gDQo+IC0jZGVmaW5lIEVOQV9YRFBfTUFYX01UVSAo
RU5BX1BBR0VfU0laRSAtIEVUSF9ITEVOIC0gRVRIX0ZDU19MRU4NCj4gLSBcDQo+IC0gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgVkxBTl9ITEVOIC0gWERQX1BBQ0tFVF9IRUFEUk9PTSkN
Cj4gKyNkZWZpbmUgRU5BX1hEUF9NQVhfTVRVIChFTkFfUEFHRV9TSVpFIC0gRVRIX0hMRU4gLQ0K
PiBFVEhfRkNTX0xFTiAtICAgICAgXA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgVkxBTl9I
TEVOIC0gWERQX1BBQ0tFVF9IRUFEUk9PTSAtICAgICAgICAgICAgICBcDQo+ICsgICAgICAgICAg
ICAgICAgICAgICAgICBTS0JfREFUQV9BTElHTihzaXplb2Yoc3RydWN0IHNrYl9zaGFyZWRfaW5m
bykpKQ0KPiANCj4gICNkZWZpbmUgRU5BX0lTX1hEUF9JTkRFWChhZGFwdGVyLCBpbmRleCkgKCgo
aW5kZXgpID49IChhZGFwdGVyKS0NCj4gPnhkcF9maXJzdF9yaW5nKSAmJiBcDQo+ICAgICAgICAg
KChpbmRleCkgPCAoYWRhcHRlciktPnhkcF9maXJzdF9yaW5nICsgKGFkYXB0ZXIpLT54ZHBfbnVt
X3F1ZXVlcykpDQo+IA0KDQo=
