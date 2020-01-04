Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9671300DD
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 05:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgADEzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 23:55:21 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:40473 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgADEzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 23:55:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1578113719; x=1609649719;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kP4sCmrq563hBvsQ1CxlJ8oUsULsWLiR2l6pu2/els4=;
  b=rFVYx/7+v7dcl8NhNY1RSoPtJFB2dvVQKV2Yq0aDpproe5ZP7KknCy5W
   GjcHjh8+nHf0cx2ouUI/FVwkbsM8YoTTXePv8z9RPLnQ3xh8MemtyRnGu
   La+MYLgkYI21f04IyDY3lGid6PFNUBBXY9T4N/b9bdkumIYvhXYB37v7A
   Y=;
IronPort-SDR: J6+ff2zek42Nlux8lJIBM5yzblkPkPqE6Kif8DCjM3WH/nbY3VUhq6MjoXXfr2XAWCaiVQLEqs
 47SMrcPXfKDA==
X-IronPort-AV: E=Sophos;i="5.69,393,1571702400"; 
   d="scan'208";a="10966427"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 04 Jan 2020 04:55:18 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 45392C4F89;
        Sat,  4 Jan 2020 04:55:17 +0000 (UTC)
Received: from EX13D22EUB003.ant.amazon.com (10.43.166.142) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sat, 4 Jan 2020 04:55:16 +0000
Received: from EX13D10EUB001.ant.amazon.com (10.43.166.211) by
 EX13D22EUB003.ant.amazon.com (10.43.166.142) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sat, 4 Jan 2020 04:55:15 +0000
Received: from EX13D10EUB001.ant.amazon.com ([10.43.166.211]) by
 EX13D10EUB001.ant.amazon.com ([10.43.166.211]) with mapi id 15.00.1367.000;
 Sat, 4 Jan 2020 04:55:15 +0000
From:   "Machulsky, Zorik" <zorik@amazon.com>
To:     Liran Alon <liran.alon@oracle.com>
CC:     "Belgazal, Netanel" <netanel@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "Chauskin, Igor" <igorch@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Schmeilin, Evgeny" <evgenys@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Pressman, Gal" <galpress@amazon.com>,
        =?utf-8?B?SMOla29uIEJ1Z2dl?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH 2/2] net: AWS ENA: Flush WCBs before writing new SQ tail
 to doorbell
Thread-Topic: [PATCH 2/2] net: AWS ENA: Flush WCBs before writing new SQ tail
 to doorbell
Thread-Index: AQHVwZiwVYcDgfG5FUWUZkteLBnWXKfZSREAgAAj7gA=
Date:   Sat, 4 Jan 2020 04:55:15 +0000
Message-ID: <2BB3E76D-CAF7-4539-A8E3-540CDB253742@amazon.com>
References: <20200102180830.66676-1-liran.alon@oracle.com>
 <20200102180830.66676-3-liran.alon@oracle.com>
 <37DACE68-F4B4-4297-9FE0-F12461D1FDC6@oracle.com>
In-Reply-To: <37DACE68-F4B4-4297-9FE0-F12461D1FDC6@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.227]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E1D2C4752838A14491E5075E70149EC2@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDEvMy8yMCwgMTo0NyBQTSwgIkxpcmFuIEFsb24iIDxsaXJhbi5hbG9uQG9yYWNs
ZS5jb20+IHdyb3RlOg0KDQogICAgDQogICAgDQogICAgPiBPbiAyIEphbiAyMDIwLCBhdCAyMDow
OCwgTGlyYW4gQWxvbiA8bGlyYW4uYWxvbkBvcmFjbGUuY29tPiB3cm90ZToNCiAgICA+IA0KICAg
ID4gQVdTIEVOQSBOSUMgc3VwcG9ydHMgVHggU1EgaW4gTG93IExhdGVuY3kgUXVldWUgKExMUSkg
bW9kZSAoQWxzbw0KICAgID4gcmVmZXJyZWQgdG8gYXMgInB1c2gtbW9kZSIpLiBJbiB0aGlzIG1v
ZGUsIHRoZSBkcml2ZXIgcHVzaGVzIHRoZQ0KICAgID4gdHJhbnNtaXQgZGVzY3JpcHRvcnMgYW5k
IHRoZSBmaXJzdCAxMjggYnl0ZXMgb2YgdGhlIHBhY2tldCBkaXJlY3RseQ0KICAgID4gdG8gdGhl
IEVOQSBkZXZpY2UgbWVtb3J5IHNwYWNlLCB3aGlsZSB0aGUgcmVzdCBvZiB0aGUgcGFja2V0IHBh
eWxvYWQNCiAgICA+IGlzIGZldGNoZWQgYnkgdGhlIGRldmljZSBmcm9tIGhvc3QgbWVtb3J5LiBG
b3IgdGhpcyBvcGVyYXRpb24gbW9kZSwNCiAgICA+IHRoZSBkcml2ZXIgdXNlcyBhIGRlZGljYXRl
ZCBQQ0kgQkFSIHdoaWNoIGlzIG1hcHBlZCBhcyBXQyBtZW1vcnkuDQogICAgPiANCiAgICA+IFRo
ZSBmdW5jdGlvbiBlbmFfY29tX3dyaXRlX2JvdW5jZV9idWZmZXJfdG9fZGV2KCkgaXMgcmVzcG9u
c2libGUNCiAgICA+IHRvIHdyaXRlIHRvIHRoZSBhYm92ZSBtZW50aW9uZWQgUENJIEJBUi4NCiAg
ICA+IA0KICAgID4gV2hlbiB0aGUgd3JpdGUgb2YgbmV3IFNRIHRhaWwgdG8gZG9vcmJlbGwgaXMg
dmlzaWJsZSB0byBkZXZpY2UsIGRldmljZQ0KICAgID4gZXhwZWN0cyB0byBiZSBhYmxlIHRvIHJl
YWQgcmVsZXZhbnQgdHJhbnNtaXQgZGVzY3JpcHRvcnMgYW5kIHBhY2tldHMNCiAgICA+IGhlYWRl
cnMgZnJvbSBkZXZpY2UgbWVtb3J5LiBUaGVyZWZvcmUsIGRyaXZlciBzaG91bGQgZW5zdXJlDQog
ICAgPiB3cml0ZS1jb21iaW5lZCBidWZmZXJzIChXQ0JzKSBhcmUgZmx1c2hlZCBiZWZvcmUgdGhl
IHdyaXRlIHRvIGRvb3JiZWxsDQogICAgPiBpcyB2aXNpYmxlIHRvIHRoZSBkZXZpY2UuDQogICAg
PiANCiAgICA+IEZvciBzb21lIENQVXMsIHRoaXMgd2lsbCBiZSB0YWtlbiBjYXJlIG9mIGJ5IHdy
aXRlbCgpLiBGb3IgZXhhbXBsZSwNCiAgICA+IHg4NiBJbnRlbCBDUFVzIGZsdXNoZXMgd3JpdGUt
Y29tYmluZWQgYnVmZmVycyB3aGVuIGEgcmVhZCBvciB3cml0ZQ0KICAgID4gaXMgZG9uZSB0byBV
QyBtZW1vcnkgKEluIG91ciBjYXNlLCB0aGUgZG9vcmJlbGwpLiBTZWUgSW50ZWwgU0RNIHNlY3Rp
b24NCiAgICA+IDExLjMgTUVUSE9EUyBPRiBDQUNISU5HIEFWQUlMQUJMRToNCiAgICA+ICJJZiB0
aGUgV0MgYnVmZmVyIGlzIHBhcnRpYWxseSBmaWxsZWQsIHRoZSB3cml0ZXMgbWF5IGJlIGRlbGF5
ZWQgdW50aWwNCiAgICA+IHRoZSBuZXh0IG9jY3VycmVuY2Ugb2YgYSBzZXJpYWxpemluZyBldmVu
dDsgc3VjaCBhcywgYW4gU0ZFTkNFIG9yIE1GRU5DRQ0KICAgID4gaW5zdHJ1Y3Rpb24sIENQVUlE
IGV4ZWN1dGlvbiwgYSByZWFkIG9yIHdyaXRlIHRvIHVuY2FjaGVkIG1lbW9yeSwgYW4NCiAgICA+
IGludGVycnVwdCBvY2N1cnJlbmNlLCBvciBhIExPQ0sgaW5zdHJ1Y3Rpb24gZXhlY3V0aW9uLuKA
nQ0KICAgID4gDQogICAgPiBIb3dldmVyLCBvdGhlciBDUFVzIGRvIG5vdCBwcm92aWRlIHRoaXMg
Z3VhcmFudGVlLiBGb3IgZXhhbXBsZSwgeDg2DQogICAgPiBBTUQgQ1BVcyBmbHVzaCB3cml0ZS1j
b21iaW5lZCBidWZmZXJzIG9ubHkgb24gYSByZWFkIGZyb20gVUMgbWVtb3J5Lg0KICAgID4gTm90
IGEgd3JpdGUgdG8gVUMgbWVtb3J5LiBTZWUgQU1EIFNvZnR3YXJlIE9wdGltaXNhdGlvbiBHdWlk
ZSBmb3IgQU1EDQogICAgPiBGYW1pbHkgMTdoIFByb2Nlc3NvcnMgc2VjdGlvbiAyLjEzLjMgV3Jp
dGUtQ29tYmluaW5nIE9wZXJhdGlvbnMuDQogICAgDQogICAgQWN0dWFsbHkuLi4gQWZ0ZXIgcmUt
cmVhZGluZyBBTUQgT3B0aW1pemF0aW9uIEd1aWRlIFNETSwgSSBzZWUgaXQgaXMgZ3VhcmFudGVl
ZCB0aGF0Og0KICAgIOKAnFdyaXRlLWNvbWJpbmluZyBpcyBjbG9zZWQgaWYgYWxsIDY0IGJ5dGVz
IG9mIHRoZSB3cml0ZSBidWZmZXIgYXJlIHZhbGlk4oCdLg0KICAgIEFuZCB0aGlzIGlzIGluZGVl
ZCBhbHdheXMgdGhlIGNhc2UgZm9yIEFXUyBFTkEgTExRLiBCZWNhdXNlIGFzIGNhbiBiZSBzZWVu
IGF0DQogICAgZW5hX2NvbV9jb25maWdfbGxxX2luZm8oKSwgZGVzY19saXN0X2VudHJ5X3NpemUg
aXMgZWl0aGVyIDEyOCwgMTkyIG9yIDI1Ni4gaS5lLiBBbHdheXMNCiAgICBhIG11bHRpcGxlIG9m
IDY0IGJ5dGVzLg0KICAgIA0KICAgIFNvIHRoaXMgcGF0Y2ggaW4gdGhlb3J5IGNvdWxkIG1heWJl
IGJlIGRyb3BwZWQgYXMgZm9yIHg4NiBJbnRlbCAmIEFNRCBhbmQgQVJNNjQgd2l0aA0KICAgIGN1
cnJlbnQgZGVzY19saXN0X2VudHJ5X3NpemUsIGl0IGlzbuKAmXQgc3RyaWN0bHkgbmVjZXNzYXJ5
IHRvIGd1YXJhbnRlZSB0aGF0IFdDIGJ1ZmZlcnMgYXJlIGZsdXNoZWQuDQogICAgDQogICAgSSB3
aWxsIGxldCBBV1MgZm9sa3MgdG8gZGVjaWRlIGlmIHRoZXkgcHJlZmVyIHRvIGFwcGx5IHRoaXMg
cGF0Y2ggYW55d2F5IHRvIG1ha2UgV0MgZmx1c2ggZXhwbGljaXQNCiAgICBhbmQgdG8gYXZvaWQg
aGFyZC10by1kZWJ1ZyBpc3N1ZXMgaW4gY2FzZSBvZiBuZXcgbm9uLTY0LW11bHRpcGx5IHNpemUg
YXBwZWFyIGluIHRoZSBmdXR1cmUuIE9yDQogICAgdG8gZHJvcCB0aGlzIHBhdGNoIGFuZCBpbnN0
ZWFkIGFkZCBhIFdBUk5fT04oKSB0byBlbmFfY29tX2NvbmZpZ19sbHFfaW5mbygpIGluIGNhc2Ug
ZGVzY19saXN0X2VudHJ5X3NpemUNCiAgICBpcyBub3QgYSBtdWx0aXBsZSBvZiA2NCBieXRlcy4g
VG8gYXZvaWQgdGFraW5nIHBlcmYgaGl0IGZvciBubyByZWFsIHZhbHVlLg0KICANCkxpcmFuLCB0
aGFua3MgZm9yIHRoaXMgaW1wb3J0YW50IGluZm8uIElmIHRoaXMgaXMgdGhlIGNhc2UsIEkgYmVs
aWV2ZSB3ZSBzaG91bGQgZHJvcCB0aGlzIHBhdGNoIGFzIGl0IGludHJvZHVjZXMgdW5uZWNlc3Nh
cnkgYnJhbmNoIA0KaW4gZGF0YSBwYXRoLiBBZ3JlZSB3aXRoIHlvdXIgV0FSTl9PTigpIHN1Z2dl
c3Rpb24uIA0KICANCiAgICAtTGlyYW4NCiAgICANCiAgICANCg0K
