Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED80C1FB5D0
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 17:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729560AbgFPPPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 11:15:21 -0400
Received: from mail-eopbgr760088.outbound.protection.outlook.com ([40.107.76.88]:43684
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729212AbgFPPPT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 11:15:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAJ4m16sME53F9srTi7jW6E/BZfQGTLst2VqyPCXwtxxuTB3wk4QlEtUkyQRVlYFSTJw7vRZjNWN/nMpaoF6elxzr06Rg5Cjsiekhj+mpAz9jIeOzlQfTAM3AME1zI6Fod9qhrzsxUH1edUwXqPvtxcwaPn9YbHd4QE4eAM8BySi88vEnxKKnCAInN0W7JprTdMunSb1mWc5j56NPwLbbbU1IaHFF9WYnf+wSuVMdwwzrPNAOxDMObIyDJ8Azf+uy0HDXNtjR6hR6xDYN9eKhZn6uXZC7amK9dIR+3165RWRQFNqWDi1ii0VWxR4zhP59oIYRrX10FqAhYY+5FMxDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVxhUS9rA4k8PQ68ee4FEaiGv9u7wXFOulVV+kZDl00=;
 b=CmTdMubirPd5Z5nnAj+Oy3IB8ACXGvYY7sBNxHfVoI+e+4sQiGCKxrYDJIK2bupdmuQVUFlatMh040sfyv73LAIm5SjGd7Q7VLXaJCqEum+ttmtXHNz7uxhAA185CHA/AgjCiIgQDFYfT8xexpWmIGQkiqBv9AN/M91ooQ6L7Chew5YCJcN/k7HRMaaIwRoRDblmZg5hpkkZrSFJrC6xTxPaRLPllyw142U0PStCIUVdZrDDAkxb1pSpPxyaqedCswBe5szVe0fKsksbJUlje0Qn+zPXTCYvh30LZIoVPfTNE1jLXC9X9bwu94h7YrN8w9NPA3A8FfhIPNPEv0rVqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVxhUS9rA4k8PQ68ee4FEaiGv9u7wXFOulVV+kZDl00=;
 b=VeLsFYC3Ou3zG+Y9WY7P88PuMk8+anYfMp9cNLDr5g01q9U3lpC4H4qc6ajgo2zJMl+NDYSnWzCybGd9y2DBCx44yFYdoFYvBZbiWsKL7A0HlDKJcrlOhka+o+ooEicHcNw7DWEonOXnl4SJdHJwFxN5S+imdSe4Kicrcq7IkXY=
Received: from MWHPR1001MB2190.namprd10.prod.outlook.com
 (2603:10b6:301:2e::20) by MWHPR1001MB2222.namprd10.prod.outlook.com
 (2603:10b6:301:2d::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.26; Tue, 16 Jun
 2020 15:15:16 +0000
Received: from MWHPR1001MB2190.namprd10.prod.outlook.com
 ([fe80::b439:ba0:98d6:c2d1]) by MWHPR1001MB2190.namprd10.prod.outlook.com
 ([fe80::b439:ba0:98d6:c2d1%5]) with mapi id 15.20.3088.028; Tue, 16 Jun 2020
 15:15:16 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "olteanv@gmail.com" <olteanv@gmail.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fido_max@inbox.ru" <fido_max@inbox.ru>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "madalin.bucur@oss.nxp.com" <madalin.bucur@oss.nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH net 2/2] dpaa_eth: fix usage as DSA master, try 4
Thread-Topic: [PATCH net 2/2] dpaa_eth: fix usage as DSA master, try 4
Thread-Index: AQHWQ+w4YATHUwfoUU+FfDKFMLwXTKjbU2QAgAABVoCAAAJQgIAAAQiAgAABQwCAAACygA==
Date:   Tue, 16 Jun 2020 15:15:16 +0000
Message-ID: <ccd7c203fe1bd9a16dfc47394d8ff565548fa673.camel@infinera.com>
References: <20200616144118.3902244-1-olteanv@gmail.com>
         <20200616144118.3902244-3-olteanv@gmail.com>
         <acb765da28bde4dff4fc2cd9ea661fa1b3486947.camel@infinera.com>
         <CA+h21hoz_LJgvCiVeuPTUVHN2Nu9wWAVnzz9GS2bo=y+Y1hLJA@mail.gmail.com>
         <d02301e1e7fa9bee3486ea8b9e3d445863bf49c8.camel@infinera.com>
         <CA+h21hqyV5RMip8etVvSWpQU0scPpXDNbMJgP9piXrn1maSMbw@mail.gmail.com>
         <CA+h21hq6iA0H25tHs=_EFNW9BVJBYMjkVGb8_hi82Gm=ei8Vdg@mail.gmail.com>
In-Reply-To: <CA+h21hq6iA0H25tHs=_EFNW9BVJBYMjkVGb8_hi82Gm=ei8Vdg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b88a0cc-ed20-4efb-29fb-08d81208135a
x-ms-traffictypediagnostic: MWHPR1001MB2222:
x-microsoft-antispam-prvs: <MWHPR1001MB2222AA1EC52FE3C9820FD85BF49D0@MWHPR1001MB2222.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 04362AC73B
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ISEUbp3nTi4vJSWj2XKAkx/0StOoMkN3W5hGfGIgGike5fLBTfLR3gs+AoyJUWQMRYHsOVF5OMM1eWsbY1I6ckxh8i1zeFkGa9Jok6qorXq+FCJYhHW+O6bcfDPFInsBr0l5H7dO0lewcSN30zEryLwCTDt7V4Mg/23xz5L0RtEzp25ZyN7ta7M2A5u85DG48A4rrx+Aof+/Vezso6f/ZUWmYDVYB1Q2VsdlvhPt3OpJaHRcVJ//VkAny0d/J3Vgh7xpBhfONfISFPvM8Nt4+LK2G7q8yA4BH4YiTezJxsN29NKeZnHhK3JG2PygHhpchoaTX3hkTVUldyEL6XbPhA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2190.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(2906002)(2616005)(26005)(8676002)(8936002)(316002)(6916009)(54906003)(5660300002)(6512007)(6486002)(4326008)(66946007)(6506007)(36756003)(86362001)(91956017)(76116006)(71200400001)(478600001)(66556008)(64756008)(66476007)(186003)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: i/K4PccrM0067IsynZLWJrh8ehgdnNSMlSk/Ks1stzeqyePjCeFC+z24KyV4B0jT1nX+GPYoPBfpLQBLnLbQqEXCk1Fj0XTPe1ZQ6ausjsWp2dwVADHsubLlwnnbQsFAWRE28T/5z5jiC9YKcBIUOY6NEMBuJf2Jv3hNNSYk2eqMnDR3yt+fOugXc6gwUYOHRqsbV+jtcZ9O5LHruDEAxLMUat3utbk2LqSEAV0LVq9zc5MyxPwkApBf2uTlLm7dC/wJZ4SWaT5ZK6i8fSnosuOgeznHHeXHQhyV6Mvene/UGEYQ1wdZTlOvkQLbnjdKO5k+b7IqWiWG6h3JZPc3Ctn7yw/BxE57Z2So2Iam2AC18EtTXx3Cfp052yHadOdKa/C90MEHwF2l8HHtbrcHcQFfTRJo2JY5l/XnwFAuPRQ7is6CudCVd5oHiVmMAfI2cSSRm5+IzYcDBZEC78OE1FEWXU8tkbjDkjDKbP/44ZZKjQ/1vqmPG936mAJsOxDr
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <457CF5EDCA0C5545B7133A50BAE2064F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b88a0cc-ed20-4efb-29fb-08d81208135a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2020 15:15:16.3681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OiUVf/GI38oQdMmYT8T5l6Z4lYesnAZ+8M1yarEtkVZL1NtZE+P/6ZzHCuVjaYqOM2I1uegQT6K+DFo7HhAf9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2222
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA2LTE2IGF0IDE4OjEyICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IE9uIFR1ZSwgMTYgSnVuIDIwMjAgYXQgMTg6MDgsIFZsYWRpbWlyIE9sdGVhbiA8b2x0ZWFu
dkBnbWFpbC5jb20+IHdyb3RlOg0KPiA+IE9uIFR1ZSwgMTYgSnVuIDIwMjAgYXQgMTg6MDQsIEpv
YWtpbSBUamVybmx1bmQNCj4gPiA8Sm9ha2ltLlRqZXJubHVuZEBpbmZpbmVyYS5jb20+IHdyb3Rl
Og0KPiA+ID4gT24gVHVlLCAyMDIwLTA2LTE2IGF0IDE3OjU2ICswMzAwLCBWbGFkaW1pciBPbHRl
YW4gd3JvdGU6DQo+ID4gPiA+IENBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91
dHNpZGUgb2YgdGhlIG9yZ2FuaXphdGlvbi4gRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0
YWNobWVudHMgdW5sZXNzIHlvdSByZWNvZ25pemUgdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29u
dGVudCBpcyBzYWZlLg0KPiA+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+IEhpIEpvYWtpbSwNCj4g
PiA+ID4gDQo+ID4gPiA+IE9uIFR1ZSwgMTYgSnVuIDIwMjAgYXQgMTc6NTEsIEpvYWtpbSBUamVy
bmx1bmQNCj4gPiA+ID4gPEpvYWtpbS5UamVybmx1bmRAaW5maW5lcmEuY29tPiB3cm90ZToNCj4g
PiA+ID4gPiBPbiBUdWUsIDIwMjAtMDYtMTYgYXQgMTc6NDEgKzAzMDAsIFZsYWRpbWlyIE9sdGVh
biB3cm90ZToNCj4gPiA+ID4gPiA+IEZyb206IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0
ZWFuQG54cC5jb20+DQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IFRoZSBkcGFhLWV0aCBkcml2
ZXIgcHJvYmVzIG9uIGNvbXBhdGlibGUgc3RyaW5nIGZvciB0aGUgTUFDIG5vZGUsIGFuZA0KPiA+
ID4gPiA+ID4gdGhlIGZtYW4vbWFjLmMgZHJpdmVyIGFsbG9jYXRlcyBhIGRwYWEtZXRoZXJuZXQg
cGxhdGZvcm0gZGV2aWNlIHRoYXQNCj4gPiA+ID4gPiA+IHRyaWdnZXJzIHRoZSBwcm9iaW5nIG9m
IHRoZSBkcGFhLWV0aCBuZXQgZGV2aWNlIGRyaXZlci4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+
ID4gQWxsIG9mIHRoaXMgaXMgZmluZSwgYnV0IHRoZSBwcm9ibGVtIGlzIHRoYXQgdGhlIHN0cnVj
dCBkZXZpY2Ugb2YgdGhlDQo+ID4gPiA+ID4gPiBkcGFhX2V0aCBuZXRfZGV2aWNlIGlzIDIgcGFy
ZW50cyBhd2F5IGZyb20gdGhlIE1BQyB3aGljaCBjYW4gYmUNCj4gPiA+ID4gPiA+IHJlZmVyZW5j
ZWQgdmlhIG9mX25vZGUuIFNvIG9mX2ZpbmRfbmV0X2RldmljZV9ieV9ub2RlIGNhbid0IGZpbmQg
aXQsIGFuZA0KPiA+ID4gPiA+ID4gRFNBIHN3aXRjaGVzIHdvbid0IGJlIGFibGUgdG8gcHJvYmUg
b24gdG9wIG9mIEZNYW4gcG9ydHMuDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IEl0IHdvdWxk
IGJlIGEgYml0IHNpbGx5IHRvIG1vZGlmeSBhIGNvcmUgZnVuY3Rpb24NCj4gPiA+ID4gPiA+IChv
Zl9maW5kX25ldF9kZXZpY2VfYnlfbm9kZSkgdG8gbG9vayBmb3IgZGV2LT5wYXJlbnQtPnBhcmVu
dC0+b2Zfbm9kZQ0KPiA+ID4gPiA+ID4ganVzdCBmb3Igb25lIGRyaXZlci4gV2UncmUganVzdCAx
IHN0ZXAgYXdheSBmcm9tIGltcGxlbWVudGluZyBmdWxsDQo+ID4gPiA+ID4gPiByZWN1cnNpb24u
DQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IE9uIFQxMDQwLCB0aGUgL3N5cy9jbGFzcy9uZXQv
ZXRoMCBzeW1saW5rIGN1cnJlbnRseSBwb2ludHMgdG86DQo+ID4gPiA+ID4gPiANCj4gPiA+ID4g
PiA+IC4uLy4uL2RldmljZXMvcGxhdGZvcm0vZmZlMDAwMDAwLnNvYy9mZmU0MDAwMDAuZm1hbi9m
ZmU0ZTYwMDAuZXRoZXJuZXQvbmV0L2V0aDANCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBKdXN0IHdh
bnQgdG8gcG9pbnQgb3V0IHRoYXQgb24gNC4xOS54LCB0aGUgYWJvdmUgcGF0Y2ggc3RpbGwgZXhp
c3RzOg0KPiA+ID4gPiA+IGNkIC9zeXMNCj4gPiA+ID4gPiBmaW5kIC1uYW1lIGV0aDANCj4gPiA+
ID4gPiAuL2RldmljZXMvcGxhdGZvcm0vZmZlMDAwMDAwLnNvYy9mZmU0MDAwMDAuZm1hbi9mZmU0
ZTYwMDAuZXRoZXJuZXQvbmV0L2V0aDANCj4gPiA+ID4gPiAuL2NsYXNzL25ldC9ldGgNCj4gPiA+
ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+IEJ5ICdjdXJyZW50JyBJIG1lYW4gJ3RoZSBuZXQgdHJl
ZSBqdXN0IGJlZm9yZSB0aGlzIHBhdGNoIGlzIGFwcGxpZWQnLA0KPiA+ID4gPiBpLmUuIGEgdjUu
NyB0cmVlIHdpdGggImRwYWFfZXRoOiBmaXggdXNhZ2UgYXMgRFNBIG1hc3RlciwgdHJ5IDMiDQo+
ID4gPiA+IHJldmVydGVkLg0KPiA+ID4gDQo+ID4gPiBDb25mdXNlZCwgd2l0aCBwYXRjaCByZXZl
cnRlZChhbmQgRFNBIHdvcmtpbmcpIGluIDQuMTksIEkgaGF2ZQ0KPiA+ID4gICAuLi8uLi9kZXZp
Y2VzL3BsYXRmb3JtL2ZmZTAwMDAwMC5zb2MvZmZlNDAwMDAwLmZtYW4vZmZlNGU2MDAwLmV0aGVy
bmV0L25ldC9ldGgwDQo+ID4gPiBJcyB0aGF0IHRoZSB3YW50ZWQgcGF0aD8gQmVjYXVzZSBJIGZp
Z3VyZWQgeW91IHdhbnRlZCB0byBjaGFuZ2UgaXQgdG8gdGhlIHBhdGggZnVydGhlciBkb3duIGlu
IHRoaXMgZW1haWw/DQo+ID4gPiANCj4gPiA+ICBKb2NrZQ0KPiA+IA0KPiA+IFllcywgdGhpcyBp
cyB0aGUgd2FudGVkIHBhdGguDQo+ID4gVGhlIHBhdGggaXMgZmluZSBmb3IgYW55dGhpbmcgYmVs
b3cgY29tbWl0IDA2MGFkNjZmOTc5NSAoImRwYWFfZXRoOg0KPiA+IGNoYW5nZSBETUEgZGV2aWNl
IiksIGluY2x1ZGluZyB5b3VyIHY0LjE5LnksIHRoYXQncyB0aGUgcG9pbnQuIEJ5DQo+ID4gc3Bl
Y2lmeWluZyB0aGF0IGNvbW1pdCBpbiB0aGUgRml4ZXM6IHRhZywgcGVvcGxlIHdobyBkZWFsIHdp
dGgNCj4gPiBiYWNrcG9ydGluZyB0byBzdGFibGUgdHJlZXMga25vdyB0byBub3QgYmFja3BvcnQg
aXQgYmVsb3cgdGhhdCBjb21taXQuDQo+ID4gU28geW91ciBzdGFibGUgdHJlZSB3aWxsIG9ubHkg
Z2V0IHRoZSByZXZlcnQgcGF0Y2guDQo+ID4gDQo+ID4gLVZsYWRpbWlyDQo+IA0KPiBPaCwgc29y
cnksIG5vdyBJIHNlZSB3aGF0IHlvdSB3ZXJlIHNheWluZy4gVGhlIHBhdGhzIGFyZSByZXZlcnNl
ZCBpbg0KPiB0aGUgY29tbWl0IGRlc2NyaXB0aW9uLiBJdCBzaG91bGQgYmU6DQo+IA0KPiBHb29k
Og0KPiANCj4gLi4vLi4vZGV2aWNlcy9wbGF0Zm9ybS9mZmUwMDAwMDAuc29jL2ZmZTQwMDAwMC5m
bWFuL2ZmZTRlNjAwMC5ldGhlcm5ldC9uZXQvZXRoMA0KPiANCj4gQmFkOg0KPiANCj4gLi4vLi4v
ZGV2aWNlcy9wbGF0Zm9ybS9mZmUwMDAwMDAuc29jL2ZmZTQwMDAwMC5mbWFuL2ZmZTRlNjAwMC5l
dGhlcm5ldC9kcGFhLWV0aGVybmV0LjAvbmV0L2V0aDANCj4gDQo+IFNvIEkgbmVlZCB0byBzcGlu
IGFub3RoZXIgdmVyc2lvbi4NCg0KVGhhbmsgeW91LCBJIHdhcyBkb3VidGluZyBteShub24gbmF0
aXZlKSB1bmRlcnN0YW5kaW5nIG9mIEVuZ2xpc2ggOikNCg0KIEpvY2tlDQo=
