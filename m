Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A301027D3
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 16:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbfKSPOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 10:14:47 -0500
Received: from mail-eopbgr10067.outbound.protection.outlook.com ([40.107.1.67]:6048
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727505AbfKSPOr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 10:14:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5QClEmC3R6y9CgbdZUmR8ajKulmtPDrWZ3WqaYVLbCcKxynC7aHQYUaPvClrfu1yoSUGnDBA/77i8i4g3x/3HnhgW9C1UxO8Ik56KoBupswQF9hUsy5bLQ285yiqsv/uu4TOnaNDxBJYQ8WgV8buoIS9Pr5FsosiKXtFgdgwNjSyvxYY6zpm4KanodW9x7YFafzN24JmbQpI1LEMsXFHg0fR4bA5GKU7MgsYCgzk1Cxjr4lrHay2zRD+tpG1m+zeEhoJWgowLVT8YSkofemJ8DFS/QiWojBqG+0wG3pell8SLVUbCK7Ci8XjAA2MTYIGYGKLwjuSu+yewuELNHJ6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KXu5ioHB6VqFL16p1baqNAJffeFAgyezFLzTUdjfb8=;
 b=l0SN51sj2HkCkxIABfDVh6YJIeevCbDw1crc2xnz6Q8rttWtNoFANL1h4+XrneG372zPxa0zK20bQkBIHIRHVpyY0d7dBXfefW9nAp6ijIWKStRZr21vIm7sDgZkDlC4OG79VaInoqJeNua0fRmz6yy61/l1rT1zvWHwP3TG9hck8EqQ899gljzwTZgtmnWqXHMH14ljpwpodQ2JRLK5CC6//quF0E3sgec1aiMK/VrieKX6TQOR3U2nAy2L7HPwhTUUQuCokXE7e2cQ4Q4oeDbhBdC4bVdbuZG7M5OLVzF7PjwPZVfO9rFpV5BbrQxWwPYMBqW7gxuO56EHRH8zpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KXu5ioHB6VqFL16p1baqNAJffeFAgyezFLzTUdjfb8=;
 b=Ykk2wBgg4g+COvqK0zeUAUuuexgTjoSEff8XejjDmvVrsEAY6d2HyWjZuGQ7GM+uDYjeCyERKLpC9wkbxxFPhqvm5W6gTvm4on7ZnNBFoFf8zkHFkaahfhnhRliG1OvvW2efc6+Wso1EZsZo6cHVhNhiS1a7RvlS6A4gemeRLcM=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4641.eurprd05.prod.outlook.com (52.133.52.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.30; Tue, 19 Nov 2019 15:14:41 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2451.029; Tue, 19 Nov 2019
 15:14:40 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Kiran Patil <kiran.patil@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVnATItanP+SK9PEuJkGaYy2/dTKeM1NrAgAURC4CAAAcf0IAAJnyAgAAC1aCAAAnmgIAAf31Q
Date:   Tue, 19 Nov 2019 15:14:40 +0000
Message-ID: <AM0PR05MB486605742430D120769F6C45D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
 <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com>
 <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com>
In-Reply-To: <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:39af:a615:5da7:ed8f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dbfd6dbc-d0da-4896-7caf-08d76d033353
x-ms-traffictypediagnostic: AM0PR05MB4641:
x-microsoft-antispam-prvs: <AM0PR05MB464151B1A7EAB2AC79D9E7E3D14C0@AM0PR05MB4641.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(199004)(189003)(486006)(25786009)(86362001)(7416002)(54906003)(8676002)(2501003)(76116006)(66476007)(256004)(64756008)(66556008)(66946007)(66446008)(110136005)(2201001)(71200400001)(71190400001)(305945005)(7736002)(74316002)(2906002)(6436002)(99286004)(46003)(6116002)(14454004)(81166006)(229853002)(8936002)(7696005)(316002)(76176011)(81156014)(4326008)(478600001)(6506007)(11346002)(55016002)(33656002)(102836004)(5660300002)(52536014)(476003)(186003)(6246003)(9686003)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4641;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HGtuOfievCFhYhZrWAUqFl3nTl4MgUVycCvQNyf5gcPHIBRdEjgLkgWgx6CLFwejavy4qHmBwj6uYWzbE2RJS4Qwj1ZDS3r4WTPp9MLzoKflKmpaw+9CN2KLRFPUjOHi+hGoVPygcSKQLUrACmjm0mUlVBGWR0drxMEQRT+HfyCF63ptD0C+1kMkeQ//JAKYepE6dkuQAA0rhaRVLA7KA2VYmxY55evuaPrOpgHx8l36VorUeLvyVRKn0TIGWY4vPRvxzTMKKlBoynsuqCXd5dnu4aaQ18nyN708HkRFN5r+cqQfWqYoZ7S1clVHNKdSXAKZ7cbNQD9bM0leWBxAEoiSlm1tpRdpmztT2DoCFSMbAkKVcw8WLEPfxlMcIq3nWwDrCgCMn4mFQOFI9wmDqzW5LC+1elj+wDaE2ohGaWeQnGy0JmLFiCjoB1AaWxMJ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbfd6dbc-d0da-4896-7caf-08d76d033353
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 15:14:40.8733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xm2lUPytCdlWvALrJ93TWG/wHYeK/j32Abn8AeHH7tLdVCwffhEkS2Eg2SpSWS0FCHgE2xJFjoq2DZYCmLhp+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4641
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gU2VudDogVHVl
c2RheSwgTm92ZW1iZXIgMTksIDIwMTkgMTozNyBBTQ0KPiANCj4gT24gMjAxOS8xMS8xOSDkuIvl
jYgzOjEzLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4+IEZyb206IEphc29uIFdhbmcgPGphc293
YW5nQHJlZGhhdC5jb20+DQo+ID4+IFN1YmplY3Q6IFJlOiBbbmV0LW5leHQgdjIgMS8xXSB2aXJ0
dWFsLWJ1czogSW1wbGVtZW50YXRpb24gb2YgVmlydHVhbA0KPiA+PiBCdXMNCj4gPj4NCj4gPj4N
Cj4gPiBbLi5dDQo+ID4NCj4gPj4gUHJvYmFibHksIGZvciB2aXJ0aW8gbWRldiB3ZSBuZWVkIG1v
cmUgdGhhbiBqdXN0IG1hdGNoaW5nOiBsaWZlIGN5Y2xlDQo+ID4+IG1hbmFnZW1lbnQsIGNvb3Bl
cmF0aW9uIHdpdGggVkZJTyBhbmQgd2UgYWxzbyB3YW50IHRvIGJlIHByZXBhcmVkIGZvcg0KPiA+
PiB0aGUgZGV2aWNlIHNsaWNpbmcgKGxpa2Ugc3ViIGZ1bmN0aW9ucykuDQo+ID4gV2VsbCBJIGFt
IHJldmlzaW5nIG15IHBhdGNoZXMgdG8gbGlmZSBjeWNsZSBzdWIgZnVuY3Rpb25zIHZpYSBkZXZs
aW5rDQo+ID4gaW50ZXJmYWNlIGZvciBmZXcgcmVhc29ucywgYXMNCj4gPg0KPiA+IChhKSBhdm9p
ZCBtZGV2IGJ1cyBhYnVzZSAoc3RpbGwgbmFtZWQgYXMgbWRldiBpbiB5b3VyIHYxMyBzZXJpZXMs
DQo+ID4gdGhvdWdoIGl0IGlzIGFjdHVhbGx5IGZvciB2ZmlvLW1kZXYpDQo+IA0KPiANCj4gWWVz
LCBidXQgaXQgY291bGQgYmUgc2ltcGx5IHJlbmFtZWQgdG8gInZmaW8tbWRldiIuDQo+IA0KPiAN
Cj4gPiAoYikgc3VwcG9ydCBpb21tdQ0KPiANCj4gDQo+IFRoYXQgaXMgYWxyZWFkeSBzdXBwb3J0
ZWQgYnkgbWRldi4NCj4gDQo+IA0KPiA+IChjKSBtYW5hZ2UgYW5kIGhhdmUgY291cGxpbmcgd2l0
aCBkZXZsaW5rIGVzd2l0Y2ggZnJhbWV3b3JrLCB3aGljaCBpcw0KPiA+IHZlcnkgcmljaCBpbiBz
ZXZlcmFsIGFzcGVjdHMNCj4gDQo+IA0KPiBHb29kIHBvaW50Lg0KPiANCj4gDQo+ID4gKGQpIGdl
dCByaWQgb2YgbGltaXRlZCBzeXNmcyBpbnRlcmZhY2UgZm9yIG1kZXYgY3JlYXRpb24sIGFzIG5l
dGxpbmsgaXMNCj4gc3RhbmRhcmQgYW5kIGZsZXhpYmxlIHRvIGFkZCBwYXJhbXMgZXRjLg0KPiAN
Cj4gDQo+IFN0YW5kYXJkIGJ1dCBuZXQgc3BlY2lmaWMuDQo+IA0KPiANCj4gPg0KPiA+IElmIHlv
dSB3YW50IHRvIGdldCBhIGdsaW1wc2Ugb2Ygb2xkIFJGQyB3b3JrIG9mIG15IHJldmlzZWQgc2Vy
aWVzLCBwbGVhc2UNCj4gcmVmZXIgdG8gWzFdLg0KPiANCj4gDQo+IFdpbGwgZG8uDQo+IA0KPiAN
Cj4gPg0KPiA+IEppcmksIEphc29uLCBtZSB0aGluayB0aGF0IGV2ZW4gdmlydGlvIGFjY2VsZXJh
dGVkIGRldmljZXMgd2lsbCBuZWVkIGVzd2l0Y2gNCj4gc3VwcG9ydC4gQW5kIGhlbmNlLCBsaWZl
IGN5Y2xpbmcgdmlydGlvIGFjY2VsZXJhdGVkIGRldmljZXMgdmlhIGRldmxpbmsgbWFrZXMgYQ0K
PiBsb3Qgb2Ygc2Vuc2UgdG8gdXMuDQo+ID4gVGhpcyB3YXkgdXNlciBoYXMgc2luZ2xlIHRvb2wg
dG8gY2hvb3NlIHdoYXQgdHlwZSBvZiBkZXZpY2UgaGUgd2FudCB0byB1c2UNCj4gKHNpbWlsYXIg
dG8gaXAgbGluayBhZGQgbGluayB0eXBlKS4NCj4gPiBTbyBzdWIgZnVuY3Rpb24gZmxhdm91ciB3
aWxsIGJlIHNvbWV0aGluZyBsaWtlICh2aXJ0aW8gb3Igc2YpLg0KPiANCj4gDQo+IE5ldHdvcmtp
bmcgaXMgb25seSBvbmUgb2YgdGhlIHR5cGVzIHRoYXQgaXMgc3VwcG9ydGVkIGluIHZpcnRpby1t
ZGV2Lg0KPiBUaGUgY29kZXMgYXJlIGdlbmVyaWMgZW5vdWdoIHRvIHN1cHBvcnQgYW55IGtpbmQg
b2YgdmlydGlvIGRldmljZSAoYmxvY2ssDQo+IHNjc2ksIGNyeXB0byBldGMpLiBTeXNmcyBpcyBs
ZXNzIGZsZXhpYmxlIGJ1dCB0eXBlIGluZGVwZW5kZW50Lg0KPiBJIGFncmVlIHRoYXQgZGV2bGlu
ayBpcyBzdGFuZGFyZCBhbmQgZmVhdHVyZSByaWNoZXIgYnV0IHN0aWxsIG5ldHdvcmsgc3BlY2lm
aWMuDQo+IEl0J3MgcHJvYmFibHkgaGFyZCB0byBhZGQgZGV2bGluayB0byBvdGhlciB0eXBlIG9m
IHBoeXNpY2FsIGRyaXZlcnMuIEknbQ0KPiB0aGlua2luZyB3aGV0aGVyIGl0J3MgcG9zc2libGUg
dG8gY29tYmluZSBzeWZzIGFuZCBkZXZsaW5rOg0KPiBlLmcgdGhlIG1kZXYgaXMgYXZhaWxhYmxl
IG9ubHkgYWZ0ZXIgdGhlIHN1YiBmdWN0aW9uIGlzIGNyZWF0ZWQgYW5kIGZ1bGx5DQo+IGNvbmZp
Z3VyZWQgYnkgZGV2bGluay4NCj4gDQoNCk5vcC4gRGV2bGluayBpcyBOT1QgbmV0IHNwZWNpZmlj
LiBJdCB3b3JrcyBhdCB0aGUgYnVzL2RldmljZSBsZXZlbC4NCkFueSBibG9jay9zY3NpL2NyeXB0
byBjYW4gcmVnaXN0ZXIgZGV2bGluayBpbnN0YW5jZSBhbmQgaW1wbGVtZW50IHRoZSBuZWNlc3Nh
cnkgb3BzIGFzIGxvbmcgYXMgZGV2aWNlIGhhcyBidXMuDQo=
