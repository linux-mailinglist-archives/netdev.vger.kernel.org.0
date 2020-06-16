Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136A21FB563
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 17:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbgFPPEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 11:04:39 -0400
Received: from mail-dm6nam12on2088.outbound.protection.outlook.com ([40.107.243.88]:57728
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729167AbgFPPEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 11:04:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jodnGC6F/a0hiSgkQr8xIfRsyQKjK7AXgIQlkzbd/YqoXEgTIP0esHbqL8flOwrmmuE1+3HHuJKXUpVQLGyUf9IScBhutMHC2/vUE169xRDOqAaBYjEtO0LTv5GI8Fd3RfuOCpTcf1kljI2SPINzryOEOu1Xp8jqhi1ZZbSEyqCO71xhgyZXvq3Sw1QT+5IvoacGPyhbCdqAciqqHvd+DdR/SzyIQSYbc+R76vRI5Mlu0eabJV8h41TEAw5NJtvEZI4RAc61sMewVjvrN8UGZwZ/rmsBGs/yWl/gqM1L4p6R9SUdyEIkAfv2KvRBV36VuApz3r2HhZTy00UiuYslDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HTRYEt50ApPfh8u8gTwafAHLfcT1U1GY6WKxIwLdNo=;
 b=KNHv0o1KxwJ+B5dQGi7sJ89jKZXn3ogSQBjfJUH+cFZnYKYLTkZRluM1+5exyt7HeVQbZJFKeBhoGHGKknQ8CcErOmyL/wjsVkyJJPnUVguEBDC7EPGhcUDD6XfrjNFGnT5FBrW90XrPnf5HpIfCb3Fr+oKTQEGUdJAxfj+01ZWxju39m70E6zX8KpHO7aS1KLy0GNaN09F9EtBF7f7sPc/f5W46jM+gIuHly528L+NvOnG6tjKtEzTTD8JTJz+So4jN4iQ3Vqurk6iYP3CbP0Lw8ATO/a/6Iak5bjz3xnRIEDGR+yAJ1JnNmdpsQ29PQz7oNaA4Ip2DByTFxsXdQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HTRYEt50ApPfh8u8gTwafAHLfcT1U1GY6WKxIwLdNo=;
 b=TyTKYxhIim+A49DR/QRC1052sd1WXRZNcMDveOg7kQE5Scp0ne21kJ1YOyGEOT/3Tl+l9RAOVSk5fZwKwZ/CvPQBaUMjh5rymO+JFdYQSmZ/NqNIQOprWzVyWmohlMYb0PNT6LlnXtZ7FZTwHdjSLJLOQAt/5rGh2Cb5BVMPuw0=
Received: from MWHPR1001MB2190.namprd10.prod.outlook.com
 (2603:10b6:301:2e::20) by MWHPR10MB1438.namprd10.prod.outlook.com
 (2603:10b6:300:24::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Tue, 16 Jun
 2020 15:04:34 +0000
Received: from MWHPR1001MB2190.namprd10.prod.outlook.com
 ([fe80::b439:ba0:98d6:c2d1]) by MWHPR1001MB2190.namprd10.prod.outlook.com
 ([fe80::b439:ba0:98d6:c2d1%5]) with mapi id 15.20.3088.028; Tue, 16 Jun 2020
 15:04:34 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "olteanv@gmail.com" <olteanv@gmail.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fido_max@inbox.ru" <fido_max@inbox.ru>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "madalin.bucur@oss.nxp.com" <madalin.bucur@oss.nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 2/2] dpaa_eth: fix usage as DSA master, try 4
Thread-Topic: [PATCH net 2/2] dpaa_eth: fix usage as DSA master, try 4
Thread-Index: AQHWQ+w4YATHUwfoUU+FfDKFMLwXTKjbU2QAgAABVoCAAAJQgA==
Date:   Tue, 16 Jun 2020 15:04:34 +0000
Message-ID: <d02301e1e7fa9bee3486ea8b9e3d445863bf49c8.camel@infinera.com>
References: <20200616144118.3902244-1-olteanv@gmail.com>
         <20200616144118.3902244-3-olteanv@gmail.com>
         <acb765da28bde4dff4fc2cd9ea661fa1b3486947.camel@infinera.com>
         <CA+h21hoz_LJgvCiVeuPTUVHN2Nu9wWAVnzz9GS2bo=y+Y1hLJA@mail.gmail.com>
In-Reply-To: <CA+h21hoz_LJgvCiVeuPTUVHN2Nu9wWAVnzz9GS2bo=y+Y1hLJA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5cc82572-2b30-4419-67a2-08d8120694c0
x-ms-traffictypediagnostic: MWHPR10MB1438:
x-microsoft-antispam-prvs: <MWHPR10MB14384C6EBA998B084C202928F49D0@MWHPR10MB1438.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 04362AC73B
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ia/jnMRJkxsu56CV6wEVJE4xae5R8VRyOcOxAh31t02yveRIV6PTgW4u0z4CBpoPW5xa3/jgpe4VWaqvyWvYfY5fi4pgLr+YNam2G0x5F9DHfb8NVdMFR69Q35mwtjsrBCaNDoVa5z768ZXTfbw6md7tokMVz/v0lVGZXvLT9JiwKqajIX4n6mxdHOoU2yq85LuYG00PQRKaXoQMOZQglgYig3PwXXS+fYHhGqGr732pNc3IlSJpdv6xLD30Ct48Ex88zqWqrd/o/5tO8+3oc+09t7tLPgDpk0RassvSGCU4+xkDePaoyRgkBmh24PI6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2190.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(8936002)(2906002)(76116006)(5660300002)(64756008)(66446008)(66946007)(66556008)(66476007)(6512007)(316002)(4326008)(91956017)(71200400001)(36756003)(86362001)(2616005)(478600001)(6916009)(8676002)(6506007)(26005)(6486002)(83380400001)(186003)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: sr2w+P1H8g95fFGzvtlA2pogfZ16t+5BJgRpnuGONW0jLrSxVMU9Dfz3chyiqcU+w9mpLtdpuObqYxMz1uSe2vx6u2UZ+czgQxXuYsddNJbLQ6GnQpul6cLZ7U8761iKcCY0sDIrMymN4UNetj4o825xnpn6okaYMLxBnb1c9bXgYvuYztaVeLXke3tf3h7022QbKd8rvCRG49zAYb7RI3C90EUFdxVxXc2WAVxDh4MB4XFuZpwDcCYW6a9HxnA4nSkxBaT3s34tPQ17kV2sPMWKulWYaBG+ZlgWWcWNQbMrHGhUaAQbQ3Zk9Yvt6Jonirzd3FkPIga0gXWKrO3zkFdLyyl4A5LQziEIKTCgT6bMMBWK0AEF9Sd/n/b7zNdeyw4tdoyEp5yKnIJlEckIld3F20h51ivCMEZCmkbuNfo+P9FcnenAM2fu6v4qx8xN4+lhGxjB7R1D1YL6UWC3xfmbHhym+ePiUkT1xd4Q8vPmUMCNLYt4fYejTzuwsFVN
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6316BD4684FFB94BA85FD0ABEE33547B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cc82572-2b30-4419-67a2-08d8120694c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2020 15:04:34.5107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sy5ZYVAQqTwxeuJYvdVBFmXSkcy8pZkQqsfu02QsFk5LopvduzWyCroMxtYtWLQsg/K2i0h7ezeqtWIPnVBDHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1438
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA2LTE2IGF0IDE3OjU2ICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IENBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9y
Z2FuaXphdGlvbi4gRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSByZWNvZ25pemUgdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLg0K
PiANCj4gDQo+IEhpIEpvYWtpbSwNCj4gDQo+IE9uIFR1ZSwgMTYgSnVuIDIwMjAgYXQgMTc6NTEs
IEpvYWtpbSBUamVybmx1bmQNCj4gPEpvYWtpbS5UamVybmx1bmRAaW5maW5lcmEuY29tPiB3cm90
ZToNCj4gPiBPbiBUdWUsIDIwMjAtMDYtMTYgYXQgMTc6NDEgKzAzMDAsIFZsYWRpbWlyIE9sdGVh
biB3cm90ZToNCj4gPiA+IEZyb206IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54
cC5jb20+DQo+ID4gPiANCj4gPiA+IFRoZSBkcGFhLWV0aCBkcml2ZXIgcHJvYmVzIG9uIGNvbXBh
dGlibGUgc3RyaW5nIGZvciB0aGUgTUFDIG5vZGUsIGFuZA0KPiA+ID4gdGhlIGZtYW4vbWFjLmMg
ZHJpdmVyIGFsbG9jYXRlcyBhIGRwYWEtZXRoZXJuZXQgcGxhdGZvcm0gZGV2aWNlIHRoYXQNCj4g
PiA+IHRyaWdnZXJzIHRoZSBwcm9iaW5nIG9mIHRoZSBkcGFhLWV0aCBuZXQgZGV2aWNlIGRyaXZl
ci4NCj4gPiA+IA0KPiA+ID4gQWxsIG9mIHRoaXMgaXMgZmluZSwgYnV0IHRoZSBwcm9ibGVtIGlz
IHRoYXQgdGhlIHN0cnVjdCBkZXZpY2Ugb2YgdGhlDQo+ID4gPiBkcGFhX2V0aCBuZXRfZGV2aWNl
IGlzIDIgcGFyZW50cyBhd2F5IGZyb20gdGhlIE1BQyB3aGljaCBjYW4gYmUNCj4gPiA+IHJlZmVy
ZW5jZWQgdmlhIG9mX25vZGUuIFNvIG9mX2ZpbmRfbmV0X2RldmljZV9ieV9ub2RlIGNhbid0IGZp
bmQgaXQsIGFuZA0KPiA+ID4gRFNBIHN3aXRjaGVzIHdvbid0IGJlIGFibGUgdG8gcHJvYmUgb24g
dG9wIG9mIEZNYW4gcG9ydHMuDQo+ID4gPiANCj4gPiA+IEl0IHdvdWxkIGJlIGEgYml0IHNpbGx5
IHRvIG1vZGlmeSBhIGNvcmUgZnVuY3Rpb24NCj4gPiA+IChvZl9maW5kX25ldF9kZXZpY2VfYnlf
bm9kZSkgdG8gbG9vayBmb3IgZGV2LT5wYXJlbnQtPnBhcmVudC0+b2Zfbm9kZQ0KPiA+ID4ganVz
dCBmb3Igb25lIGRyaXZlci4gV2UncmUganVzdCAxIHN0ZXAgYXdheSBmcm9tIGltcGxlbWVudGlu
ZyBmdWxsDQo+ID4gPiByZWN1cnNpb24uDQo+ID4gPiANCj4gPiA+IE9uIFQxMDQwLCB0aGUgL3N5
cy9jbGFzcy9uZXQvZXRoMCBzeW1saW5rIGN1cnJlbnRseSBwb2ludHMgdG86DQo+ID4gPiANCj4g
PiA+IC4uLy4uL2RldmljZXMvcGxhdGZvcm0vZmZlMDAwMDAwLnNvYy9mZmU0MDAwMDAuZm1hbi9m
ZmU0ZTYwMDAuZXRoZXJuZXQvbmV0L2V0aDANCj4gPiANCj4gPiBKdXN0IHdhbnQgdG8gcG9pbnQg
b3V0IHRoYXQgb24gNC4xOS54LCB0aGUgYWJvdmUgcGF0Y2ggc3RpbGwgZXhpc3RzOg0KPiA+IGNk
IC9zeXMNCj4gPiBmaW5kIC1uYW1lIGV0aDANCj4gPiAuL2RldmljZXMvcGxhdGZvcm0vZmZlMDAw
MDAwLnNvYy9mZmU0MDAwMDAuZm1hbi9mZmU0ZTYwMDAuZXRoZXJuZXQvbmV0L2V0aDANCj4gPiAu
L2NsYXNzL25ldC9ldGgNCj4gPiANCj4gDQo+IEJ5ICdjdXJyZW50JyBJIG1lYW4gJ3RoZSBuZXQg
dHJlZSBqdXN0IGJlZm9yZSB0aGlzIHBhdGNoIGlzIGFwcGxpZWQnLA0KPiBpLmUuIGEgdjUuNyB0
cmVlIHdpdGggImRwYWFfZXRoOiBmaXggdXNhZ2UgYXMgRFNBIG1hc3RlciwgdHJ5IDMiDQo+IHJl
dmVydGVkLg0KDQpDb25mdXNlZCwgd2l0aCBwYXRjaCByZXZlcnRlZChhbmQgRFNBIHdvcmtpbmcp
IGluIDQuMTksIEkgaGF2ZSANCiAgLi4vLi4vZGV2aWNlcy9wbGF0Zm9ybS9mZmUwMDAwMDAuc29j
L2ZmZTQwMDAwMC5mbWFuL2ZmZTRlNjAwMC5ldGhlcm5ldC9uZXQvZXRoMA0KSXMgdGhhdCB0aGUg
d2FudGVkIHBhdGg/IEJlY2F1c2UgSSBmaWd1cmVkIHlvdSB3YW50ZWQgdG8gY2hhbmdlIGl0IHRv
IHRoZSBwYXRoIGZ1cnRoZXIgZG93biBpbiB0aGlzIGVtYWlsPw0KDQogSm9ja2UNCj4gDQo+ID4g
PiB3aGljaCBwcmV0dHkgbXVjaCBpbGx1c3RyYXRlcyB0aGUgcHJvYmxlbS4gVGhlIGNsb3Nlc3Qg
b2Zfbm9kZSB3ZSd2ZSBnb3QNCj4gPiA+IGlzIHRoZSAiZnNsLGZtYW4tbWVtYWMiIGF0IC9zb2NA
ZmZlMDAwMDAwL2ZtYW5ANDAwMDAwL2V0aGVybmV0QGU2MDAwLA0KPiA+ID4gd2hpY2ggaXMgd2hh
dCB3ZSdkIGxpa2UgdG8gYmUgYWJsZSB0byByZWZlcmVuY2UgZnJvbSBEU0EgYXMgaG9zdCBwb3J0
Lg0KPiA+ID4gDQo+ID4gPiBGb3Igb2ZfZmluZF9uZXRfZGV2aWNlX2J5X25vZGUgdG8gZmluZCB0
aGUgZXRoMCBwb3J0LCB3ZSB3b3VsZCBuZWVkIHRoZQ0KPiA+ID4gcGFyZW50IG9mIHRoZSBldGgw
IG5ldF9kZXZpY2UgdG8gbm90IGJlIHRoZSAiZHBhYS1ldGhlcm5ldCIgcGxhdGZvcm0NCj4gPiA+
IGRldmljZSwgYnV0IHRvIHBvaW50IDEgbGV2ZWwgaGlnaGVyLCBha2EgdGhlICJmc2wsZm1hbi1t
ZW1hYyIgbm9kZQ0KPiA+ID4gZGlyZWN0bHkuIFRoZSBuZXcgc3lzZnMgcGF0aCB3b3VsZCBsb29r
IGxpa2UgdGhpczoNCj4gPiA+IA0KPiA+ID4gLi4vLi4vZGV2aWNlcy9wbGF0Zm9ybS9mZmUwMDAw
MDAuc29jL2ZmZTQwMDAwMC5mbWFuL2ZmZTRlNjAwMC5ldGhlcm5ldC9kcGFhLWV0aGVybmV0LjAv
bmV0L2V0aDANCj4gPiA+IA0KPiA+ID4gQWN0dWFsbHkgdGhpcyBoYXMgd29ya2VkIGJlZm9yZSwg
dGhyb3VnaCB0aGUgU0VUX05FVERFVl9ERVYgbWVjaGFuaXNtLA0KPiA+ID4gd2hpY2ggc2V0cyB0
aGUgcGFyZW50IG9mIHRoZSBuZXRfZGV2aWNlIGFzIHRoZSBwYXJlbnQgb2YgdGhlIHBsYXRmb3Jt
DQo+ID4gPiBkZXZpY2UuIEJ1dCB0aGUgZGV2aWNlIHdoaWNoIHdhcyBzZXQgYXMgc3lzZnMgcGFy
ZW50IHdhcyBpbmFkdmVydGVudGx5DQo+ID4gPiBjaGFuZ2VkIHRocm91Z2ggY29tbWl0IDA2MGFk
NjZmOTc5NSAoImRwYWFfZXRoOiBjaGFuZ2UgRE1BIGRldmljZSIpLA0KPiA+ID4gd2hpY2ggZGlk
IG5vdCB0YWtlIGludG8gY29uc2lkZXJhdGlvbiB0aGUgZWZmZWN0IGl0IHdvdWxkIGhhdmUgdXBv
bg0KPiA+ID4gb2ZfZmluZF9uZXRfZGV2aWNlX2J5X25vZGUuIFNvIHJlc3RvcmUgdGhlIG9sZCBz
eXNmcyBwYXJlbnQgdG8gbWFrZSB0aGF0DQo+ID4gPiB3b3JrIGNvcnJlY3RseS4NCj4gPiA+IA0K
PiA+ID4gRml4ZXM6IDA2MGFkNjZmOTc5NSAoImRwYWFfZXRoOiBjaGFuZ2UgRE1BIGRldmljZSIp
DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBWbGFkaW1pciBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBu
eHAuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxl
L2RwYWEvZHBhYV9ldGguYyB8IDIgKy0NCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkNCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFhL2RwYWFfZXRoLmMgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9mcmVlc2NhbGUvZHBhYS9kcGFhX2V0aC5jDQo+ID4gPiBpbmRleCBjNDQxNmE1Zjg4MTYu
LjI5NzIyNDRlNmViMCAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Zy
ZWVzY2FsZS9kcGFhL2RwYWFfZXRoLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ZyZWVzY2FsZS9kcGFhL2RwYWFfZXRoLmMNCj4gPiA+IEBAIC0yOTE0LDcgKzI5MTQsNyBAQCBz
dGF0aWMgaW50IGRwYWFfZXRoX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+
ID4gPiAgICAgICAgIH0NCj4gPiA+IA0KPiA+ID4gICAgICAgICAvKiBEbyB0aGlzIGhlcmUsIHNv
IHdlIGNhbiBiZSB2ZXJib3NlIGVhcmx5ICovDQo+ID4gPiAtICAgICAgIFNFVF9ORVRERVZfREVW
KG5ldF9kZXYsIGRldik7DQo+ID4gPiArICAgICAgIFNFVF9ORVRERVZfREVWKG5ldF9kZXYsIGRl
di0+cGFyZW50KTsNCj4gPiA+ICAgICAgICAgZGV2X3NldF9kcnZkYXRhKGRldiwgbmV0X2Rldik7
DQo+ID4gPiANCj4gPiA+ICAgICAgICAgcHJpdiA9IG5ldGRldl9wcml2KG5ldF9kZXYpOw0KPiA+
ID4gLS0NCj4gPiA+IDIuMjUuMQ0KPiA+ID4gDQo+IA0KPiBUaGFua3MsDQo+IC1WbGFkaW1pcg0K
DQo=
