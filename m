Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF902267895
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 09:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbgILHhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 03:37:51 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:63865 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbgILHht (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Sep 2020 03:37:49 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5c7aca0000>; Sat, 12 Sep 2020 15:37:46 +0800
Received: from HKMAIL103.nvidia.com ([10.18.16.12])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Sat, 12 Sep 2020 00:37:46 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Sat, 12 Sep 2020 00:37:46 -0700
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 12 Sep
 2020 07:37:45 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sat, 12 Sep 2020 07:37:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PezGKzOLURobZzEGaLM60ylBRuaWEwIviumZwv+6t9o1bKKOlA56jcF95I2C6chvT6AYZf10xI7/BVz1bMmnMn5cQrrZ0si16j33G4ZaU+9VlZI0xKW3QkiJq07XtJJ0yvQI9KuNbZqta1FMsAsMlJ/qlPve1tTwm7zit8nX/cA7pTGrHD0n3VC7pCpWIlnNWZxgSbyd+vAE7cqUtz6kdDnJsinMFJOjKHZAzzXhwl81sZj9HD4OUK5r5FLH72BxjHMCd39SL3EiD0K+0CNiEGgY3SAgiBOqrbgB4kY8GpcK2ntZomW4/pAfVvEqSGMYl8k/m0G41b2usRydJqQp5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bvfg+yBWGy4Bl34ERhoJMjUbmBOWW0PqkfnqJmfaAk4=;
 b=jDXM0+hDQOnIgORBUR+0j32CNtpMqaFnIMgfKSLFEjMxF2s/XFacwsoPRoQYjktR0nuskx/n3vNU6E3q9XJuIqXuUEG8M5MM9i2vM8L7Bcks+LwbyfRYXDXjIgW8pS342QSV6tIe33Wep+89oRHTGkLXGOf+lLNQtPE7jgSa6jsgFA9u8WqfgbNzd5Iyo2Ob2vdfkNRkd7Se5sgdTjeGv/udthUZ/WdgYsESgRdqF0+KE3qGFI2CZBpGG5DRZ/KG6OSI3eHUr3Aaz1x9u/f798oexwf/uT7LvarRbFipmjVnGhO+nP3Iq3Lbxs+qhrU7pHMCaXFUlnOmbZD3Gvvorw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BYAPR12MB2823.namprd12.prod.outlook.com (2603:10b6:a03:96::33)
 by BYAPR12MB3192.namprd12.prod.outlook.com (2603:10b6:a03:139::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Sat, 12 Sep
 2020 07:37:42 +0000
Received: from BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b]) by BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b%6]) with mapi id 15.20.3348.019; Sat, 12 Sep 2020
 07:37:42 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "olteanv@gmail.com" <olteanv@gmail.com>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH net-next] net: bridge: pop vlan from skb if filtering is
 disabled but it's a pvid
Thread-Topic: [PATCH net-next] net: bridge: pop vlan from skb if filtering is
 disabled but it's a pvid
Thread-Index: AQHWiJGYqt2ABPNtfE6Zj34+KHfdVqlkknWAgAAHgACAAAQYgA==
Date:   Sat, 12 Sep 2020 07:37:42 +0000
Message-ID: <ce71707b0a4065cc0fc5c5b61ee397152491ba48.camel@nvidia.com>
References: <20200911231619.2876486-1-olteanv@gmail.com>
         <ddfecf408d3d1b7e4af97cb3b1c1c63506e4218e.camel@nvidia.com>
         <20200912072302.xaoxbgusqeesrzaq@skbuf>
In-Reply-To: <20200912072302.xaoxbgusqeesrzaq@skbuf>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a98d98a-6758-44a6-a306-08d856eebb91
x-ms-traffictypediagnostic: BYAPR12MB3192:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB319282773194BA2DE651F6F8DF250@BYAPR12MB3192.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hR72tOYwjmG1MpAm8QdymZMQ/9Qa5+Jyz6eHpfdMiXJLvQ7du7D4CIIM3c8WoU1rfM+YgkHWTtqHP9b1pm4qHhxyALXRuUkv5VzWbybBhdm0gtqobA6YmwJzjN0Z4INpLHzYqpZFKyx7fka3TKlzVlyIOX03dPdRFw9YsI6ChuMKxcMt6cDhskZzexlkqn+3Irgeo0sPr52ub2YEsZUzr3KV1TInqFKsh9dZQZSnd+QlnJohuFDURzQZcfj9MSxQtaWd92lNMImJKYvpi3Mb2NCU3rFxcyPmwfsR6kIDtGc1W8v28cVoXyNqdvnbcXB3VfRJh+eighOHy+YtnueCILXwrGkQgQ4JZO/AxmTRk3eCTMIxXiw8oL6Hz/66AxS8rIDGVWNrJ8luUV6pJIfl/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2823.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(6506007)(316002)(6916009)(86362001)(2906002)(6512007)(107886003)(4326008)(8936002)(966005)(36756003)(83380400001)(54906003)(6486002)(478600001)(2616005)(66946007)(186003)(5660300002)(64756008)(76116006)(66556008)(26005)(66476007)(8676002)(66446008)(91956017)(3450700001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: dQ10doaGnngb4z0ynT1mcjLI9vt+zN6e3w2IdcAWn8MmwF0faGNCxuWDHO2PQHh80MmgIfQPrgeuCE4vjqhPzC62S7IGUazzBUXP5QiOUtCyils5Ls+9sZv+E6yKRqqaLVD670h2z1uOV5ZdKh9hd8T/SlxvVhmhgLHsY1P15t+uqR+hPfwdgovEZkYOjGZjnx1myWs1M7WFc4xL4A6//LGwvWQceqX08/D9LO4rQXJ+tNSU4WyR0Uv2aLJM8f3BCuvZDMlejY8gtL7Uv6DLv078V4wYOFPfqfrse6cFGu5kE/tqsewWC78bAPxmMo0vtsKhDKJWtrips1x0MEkb/jJL4VCAcnUd9WU5wPNjQ6RwqLzO9lW58tSP85rXQ/FqNBG47MtfiJLr2hMjSdHv8G/9YXHISO6wiCLmj281Z95iA4VERTTN0EYdZCAVljQBOlGKd5xmqNvufFPTBAaU7Whh4GtIUrdwZN1Jpfus4e5fuN1X6t43R8z/cKOOX3u1NZDXpT7QN2LjPlL+O+v6p2R16TFzIlER4CFEtw2gAhlW7k72KcoobhlyIStgy5Lgv2BsrJAyJQ9JtNts7yPmj34XgVIZKE9fvN4cUH+QM5LoQx8u001wYPg+Vii5+xNEiRu86G9r3MyPlNzUbqOo8A==
Content-Type: text/plain; charset="utf-8"
Content-ID: <E31C94D022079E4495D655FE8C9E1E08@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2823.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a98d98a-6758-44a6-a306-08d856eebb91
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2020 07:37:42.1054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0L8nnSazmZ7LpGjBxv1SIZAHooDSKQ3Oe+bbLz/6CobLrZjxfCc8Rxw7oYeIRzNQ5DVKNgqLJRy4lTmzSZR2tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3192
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599896266; bh=Bvfg+yBWGy4Bl34ERhoJMjUbmBOWW0PqkfnqJmfaAk4=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:user-agent:authentication-results:
         x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-ID:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=eIdPqgf2PlBPZPmV4Q0A1fcYPcP8+wC/9JOEtZjkmR7R4E+/jczYtMnBdIvm96yKo
         qHBzFsKsusBYwzpRkkNjoQHbhNz5cVLTTSys63q+yNwHQAbh8Yf3UESaZkf5XR3k1L
         ts5+lqP4QVDozSO1/c0lZqRvo2mTziilkQxRlf4dGVbnySqYe6a3EdKse4/E4FshBa
         9aTB8OtLXKIK7AcNLecvSbgn8n3/w7rRt2zD4eRN135k0jxIR4Cb2QsD0tlI5nmqEu
         z9qdW2f89LQBjZ9z68Itw34b2cdbsOTz2gqevL8BLZWNp3m51owKCenbGEdwDGZFcy
         cCR8zaFjLEi1A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIwLTA5LTEyIGF0IDEwOjIzICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IE9uIFNhdCwgU2VwIDEyLCAyMDIwIGF0IDA2OjU2OjEyQU0gKzAwMDAsIE5pa29sYXkgQWxl
a3NhbmRyb3Ygd3JvdGU6DQo+ID4gQ291bGQgeW91IHBvaW50IG1lIHRvIGEgdGhyZWFkIHdoZXJl
IHRoZXNlIHByb2JsZW1zIHdlcmUgZGlzY3Vzc2VkIGFuZCB3aHkNCj4gPiB0aGV5IGNvdWxkbid0
IGJlIHJlc29sdmVkIHdpdGhpbiBEU0EgaW4gZGV0YWlsID8NCj4gDQo+IFNlZSBteSBkaXNjdXNz
aW9uIHdpdGggRmxvcmlhbiBpbiB0aGlzIHRocmVhZDoNCj4gaHR0cDovL3BhdGNod29yay5vemxh
YnMub3JnL3Byb2plY3QvbmV0ZGV2L3BhdGNoLzIwMjAwOTA3MTgyOTEwLjEyODU0OTYtNS1vbHRl
YW52QGdtYWlsLmNvbS8NCj4gVGhlcmUncyBhIGJ1bmNoIG9mIHVucmVsYXRlZCBzdHVmZiBnb2lu
ZyBvbiB0aGVyZSwgaG9wZSB5b3UnbGwgbWFuYWdlLg0KPiANCg0KVGhhbmtzIQ0KSSdtIHRyYXZl
bGluZyBhbmQgd2lsbCBiZSBiYWNrIG9uIFN1biBldmVuaW5nLCB3aWxsIGdvIHRocm91Z2ggdGhl
IHRocmVhZCB0aGVuLg0KDQo+ID4gPiAtIHRoZSBicmlkZ2UgQVBJIG9ubHkgb2ZmZXJzIGEgcmFj
ZS1mcmVlIEFQSSBmb3IgZGV0ZXJtaW5pbmcgdGhlIHB2aWQgb2YNCj4gPiA+ICAgYSBwb3J0LCBi
cl92bGFuX2dldF9wdmlkKCksIHVuZGVyIFJUTkwuDQo+ID4gPiANCj4gPiANCj4gPiBUaGUgQVBJ
IGNhbiBiZSBlYXNpbHkgZXh0ZW5kZWQuDQo+ID4gDQo+IA0KPiBJZiB5b3UgY2FuIGhlbHAsIGNv
b2wuDQo+IA0KPiA+ID4gQW5kIGluIGZhY3QgdGhpcyBtaWdodCBub3QgZXZlbiBiZSBhIHNpdHVh
dGlvbiB1bmlxdWUgdG8gRFNBLiBBbnkgZHJpdmVyDQo+ID4gPiB0aGF0IHJlY2VpdmVzIHVudGFn
Z2VkIGZyYW1lcyBhcyBwdmlkLXRhZ2dlZCBpcyBub3cgYWJsZSB0byBjb21tdW5pY2F0ZQ0KPiA+
ID4gd2l0aG91dCBuZWVkaW5nIGFuIDgwMjFxIHVwcGVyIGZvciB0aGUgcHZpZC4NCj4gPiA+IA0K
PiA+IA0KPiA+IEkgd291bGQgcHJlZmVyIHdlIGRvbid0IGFkZCBoYXJkd2FyZS9kcml2ZXItc3Bl
Y2lmaWMgZml4ZXMgaW4gdGhlIGJyaWRnZSwgd2hlbg0KPiA+IHZsYW4gZmlsdGVyaW5nIGlzIGRp
c2FibGVkIHRoZXJlIHNob3VsZCBiZSBubyB2bGFuIG1hbmlwdWxhdGlvbi9maWx0ZXJpbmcgZG9u
ZQ0KPiA+IGJ5IHRoZSBicmlkZ2UuIFRoaXMgY291bGQgcG90ZW50aWFsbHkgYnJlYWsgdXNlcnMg
d2hvIGhhdmUgYWRkZWQgODAyMXEgZGV2aWNlcw0KPiA+IGFzIGJyaWRnZSBwb3J0cy4gQXQgdGhl
IHZlcnkgbGVhc3QgdGhpcyBuZWVkcyB0byBiZSBoaWRkZW4gYmVoaW5kIGEgbmV3IG9wdGlvbiwN
Cj4gPiBidXQgSSB3b3VsZCBsaWtlIHRvIGZpbmQgYSB3YXkgdG8gYWN0dWFsbHkgcHVzaCBpdCBi
YWNrIHRvIERTQS4gQnV0IGFnYWluIGFkZGluZw0KPiA+IGhhcmR3YXJlL2RyaXZlci1zcGVjaWZp
YyBvcHRpb25zIHNob3VsZCBiZSBhdm9pZGVkLg0KPiA+IA0KPiA+IENhbiB5b3UgdXNlIHRjIHRv
IHBvcCB0aGUgdmxhbiBvbiBpbmdyZXNzID8gSSBtZWFuIHRoZSBjYXNlcyBhYm92ZSBhcmUgdmlz
aWJsZQ0KPiA+IHRvIHRoZSB1c2VyLCBzbyB0aGV5IG1pZ2h0IGRlY2lkZSB0byBhZGQgdGhlIGlu
Z3Jlc3MgdmxhbiBydWxlLg0KPiA+IA0KPiA+IFRoYW5rcywNCj4gPiAgTmlrDQo+IA0KPiBJIGNh
biwgYnV0IEkgdGhpbmsgdGhhdCBhbGwgaW4gYWxsIGl0J3MgYSBiaXQgc3RyYW5nZSBmb3IgdGhl
IGJyaWRnZSB0bw0KPiBub3QgdW50YWcgcHZpZC10YWdnZWQgZnJhbWVzLg0KPiANCj4gVGhhbmtz
IQ0KPiAtVmxhZGltaXINCg0KSWYgdmxhbiBmaWx0ZXJpbmcgaXMgZGlzYWJsZWQgdGhlIGJyaWRn
ZSBzaG91bGRuJ3QgZG8gYW55IHZsYW4gcHJvY2Vzc2luZywNCnRoYXQncyB0aGUgZXhwZWN0ZWQg
YmVoYXZpb3VyLiBJZiB0YyBpcyBhIHZpYWJsZSBvcHRpb24gdGhlbiBJJ2QgZXhwbG9yZSB0aGF0
DQpmdXJ0aGVyIGFuZCBhdm9pZCBhZGRpbmcgbW9yZSBjb2RlLg0KDQoNCg==
