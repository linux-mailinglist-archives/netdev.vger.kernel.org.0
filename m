Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE87218532
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 12:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgGHKns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 06:43:48 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:16867
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728104AbgGHKnr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 06:43:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWNytMkBTmj1aVILRsQpKF9nDa4+qKZe86J+3O/BVGTj/2d9nNpFH8TYwkjihHifgPtHKTP4gD+yANnvq5UtHWiQsE2oBjYF4d79D042q1z+TU6Og/B4zSI98byhMg5fJH9tNW8I9am9nI4PhM6XQUGx/LD3Y5YxfYg3Ls8uj+l6nybDmYbrV503OjN1RbgfeTZDPei8hiddLBLWMe81Q+RhUAzRtLr5duIHryfJPedveidVfsRNRehx31/3ueBWjRbJo3JU4+bmJaCTY8IyypDlHo993JBukXO1G8JSxn6Y+7GuzfDCPAJZV6kQ+i6XuwVglP/ukcNj+RQW2bQxmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3lg1XSR7Dh8xmmSKwWVic+nahzPpRldr++PJxvFjm4=;
 b=UBELGFmd+3j0w0gkBRIdbyR6GkUpdagQMVd6On2oQCXjiUR2Tl2S2evbkBC1fH6SPqXHUg/ntn9KrBLNMT+NP/amMvnR4nS+0PPWBDJHldN6iUG2zDwQkaoZDFr0K/QAnd/UyQ901P+WSG4Rs9IdiiCtdAZIrvVoq2gr/cyZIv7wgV5b49Xe1wSJGglKWCeTgQlpc7O6P+azjTkJo0wOx7gBLCjKF9xxPRIOLOl5wnE5faYmxFiXBtMnNQAbY/FAhMcJoKW+bA4qP9ZW0Szdhqvm/UM/d/xudWOsQsLxO+l9JCE56IUb23ql/wVya0KaysVcFho1MJo41Gf2ertkwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3lg1XSR7Dh8xmmSKwWVic+nahzPpRldr++PJxvFjm4=;
 b=ht6OuAuIUJS+Kp+QaKWR/xboTuw6a4yipU6zsazF9bOvTD109065qGf4PYSWGXIA/uPFsfwpdl6tTVLOaqREjUvkGedkLQfE0eZtIB3851t6rHtS5+GhgZRrdPoRRpFwZv2DNJRUfQgNjOSvylUxs0JiItBGZnOhlX9GfBQXbow=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB4354.eurprd05.prod.outlook.com (2603:10a6:208:56::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Wed, 8 Jul
 2020 10:43:43 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3153.029; Wed, 8 Jul 2020
 10:43:43 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ubraun@linux.ibm.com" <ubraun@linux.ibm.com>,
        "kgraul@linux.ibm.com" <kgraul@linux.ibm.com>,
        "raspl@de.ibm.com" <raspl@de.ibm.com>
Subject: RE: [REGRESSION] mlx5: Driver remove during hot unplug is broken
Thread-Topic: [REGRESSION] mlx5: Driver remove during hot unplug is broken
Thread-Index: AQHWQLrGbNXD35X8/0i/OqCLS1MuKqjViLcAgAPttwCAJC+e4A==
Date:   Wed, 8 Jul 2020 10:43:43 +0000
Message-ID: <AM0PR05MB4866585FF543DA370E78B992D1670@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <f942d546-ee7e-60f6-612a-ae093a9459a5@linux.ibm.com>
 <7660d8e0d2cb1fbd40cf89ea4c9a0eff4807157c.camel@mellanox.com>
 <26dedb23-819f-8121-6e04-72677110f3cc@linux.ibm.com>
In-Reply-To: <26dedb23-819f-8121-6e04-72677110f3cc@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [106.51.28.254]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fb10452b-2e78-4352-b4c1-08d8232bc8fb
x-ms-traffictypediagnostic: AM0PR05MB4354:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB43549D622197085CA17EA02ED1670@AM0PR05MB4354.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2E9brQjJc8XbaXLX8zr0IymLm+5cDH+FXrQqvcmCIn8Tk5jYsCL9d4imMrUIgBFcnYGpH3cmh64FeaaBhXZrGb8sNNflID5Q2ZFF4HWkpwmCjgsj2BOb/nX51C1csgIzSlmrCDo/0ym01ZDut/o7XeNwIWcHxY90WR7cT4rGDCKLWoY4Kd0Wg5z4hsWeZQVxMtsnKl05SfeZ8A9/H9djyZKRR1wioiYcLUCuS23qfQZqC6kucRTGxw/4P44cDyxxYGlxQ8GGkLbWrGaARun/P/DdCjxPrqmZ/88/Ydf8W8Rwemv2E/ypD3Ys/7djGwLIzOKZpzdI9jFHDyX/SK6WGb2EFDwPhOc8kSuD11ECre8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(39860400002)(396003)(376002)(136003)(186003)(66476007)(66556008)(71200400001)(64756008)(66446008)(55236004)(54906003)(52536014)(53546011)(66946007)(86362001)(6506007)(83380400001)(966005)(110136005)(76116006)(33656002)(7696005)(9686003)(8676002)(55016002)(4326008)(6636002)(316002)(8936002)(478600001)(5660300002)(2906002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 7UHmAxZQaqgyahEKfYRkQoUopxzUJg0esPDHt6LtBAiRVy3XVDeDtMKOurPJEc7riKEFLcbjtc4LP8m6Tgc3nb9jylxKVi2z6ktPAR5jhI4ZgEMJwXWsMPSxd6+104HWNSMZkA1u7fglfX0dthiSbUtlHKDZkG/lKEpmwsK4SzBBxKgI56pOpnQfEdtUoa+rbFofj81CICvGxImwXjw9eXKoL6KZ9+XhNwfj+ghfn8LMPpLn8AQTPzbISZ3dWutUXT1tyz99Xbg6JuaKrSc0WQhF/vVPXvoZK1Ohq0KJ0U3jeXwR9pqwZjd3mRA6gWddZHlZVXzm00EHljGIMhZmhZRxFMlaqgzt8ijJ2e/jntASl1vhw46c3k18Cr+JGyVhldDgmvKIJ2f6c6QJL6sTnL0Hv9a9RMn+kzcejCCIo7ht7vtpEcpWvBNQxyUmHhwmWxC7nKj/0JOpK4Q8b+i3Bd/8cBz4Q+PMVxSNAkh+iwbJXo+SA1l+j9LMU+2HjZxe
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb10452b-2e78-4352-b4c1-08d8232bc8fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 10:43:43.4350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OKNu7ETPdIFBrpGD0PFxA+cXoRBIk7hNisFybtcvTd2nChtJEr9CJW9W9ZYkFI94qywDV/h1hPrz3yE2vardfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTmlrbGFzLA0KDQo+IEZyb206IE5pa2xhcyBTY2huZWxsZSA8c2NobmVsbGVAbGludXguaWJt
LmNvbT4NCj4gU2VudDogTW9uZGF5LCBKdW5lIDE1LCAyMDIwIDM6MzIgUE0NCj4gDQo+IEhlbGxv
IFNhZWVkLA0KPiANCj4gT24gNi8xMy8yMCAxMjowMSBBTSwgU2FlZWQgTWFoYW1lZWQgd3JvdGU6
DQo+ID4gT24gRnJpLCAyMDIwLTA2LTEyIGF0IDE1OjA5ICswMjAwLCBOaWtsYXMgU2NobmVsbGUg
d3JvdGU6DQo+ID4+IEhlbGxvIFBhcmF2LCBIZWxsbyBTYWVlZCwNCj4gPj4NCj4gLi4uIHNuaXAg
Li4uDQo+ID4+DQo+ID4+IFNvIHdpdGhvdXQgcmVhbGx5IGtub3dpbmcgYW55dGhpbmcgYWJvdXQg
dGhlc2UgZnVuY3Rpb25zIEkgd291bGQNCj4gPj4gZ3Vlc3MgdGhhdCB3aXRoIHRoZSBkZXZpY2Ug
c3RpbGwgcmVnaXN0ZXJlZCB0aGUgZHJhaW5lZCBxdWV1ZSBkb2VzDQo+ID4+IG5vdCByZW1haW4g
ZW1wdHkgYXMgbmV3IGVudHJpZXMgYXJlIGFkZGVkLg0KPiA+PiBEb2VzIHRoYXQgc291bmQgcGxh
dXNpYmxlIHRvIHlvdT8NCj4gPj4NCj4gPg0KPiA+IEkgZG9uJ3QgdGhpbmsgaXQgaXMgcmVsYXRl
ZCwgbWF5YmUgdGhpcyBpcyBzaW1pbGFyIHRvIHNvbWUgaXNzdWVzDQo+ID4gYWRkcmVzc2VkIGxh
dGVseSBieSBTaGF5J3MgcGF0Y2hlczoNCj4gPg0KPiA+DQo+IGh0dHBzOi8vcGF0Y2h3b3JrLm96
bGFicy5vcmcvcHJvamVjdC9uZXRkZXYvcGF0Y2gvMjAyMDA2MTEyMjQ3MDguMjM1MDENCj4gPiA0
LTItc2FlZWRtQG1lbGxhbm94LmNvbS8NCj4gPg0KPiBodHRwczovL3BhdGNod29yay5vemxhYnMu
b3JnL3Byb2plY3QvbmV0ZGV2L3BhdGNoLzIwMjAwNjExMjI0NzA4LjIzNTAxDQo+ID4gNC0zLXNh
ZWVkbUBtZWxsYW5veC5jb20vDQo+ID4NCj4gPiBuZXQvbWx4NTogZHJhaW4gaGVhbHRoIHdvcmtx
dWV1ZSBpbiBjYXNlIG9mIGRyaXZlciBsb2FkIGVycm9yDQo+ID4gbmV0L21seDU6IEZpeCBmYXRh
bCBlcnJvciBoYW5kbGluZyBkdXJpbmcgZGV2aWNlIGxvYWQNCj4gDQo+IEkgYWdyZWUgd2l0aCB5
b3VyIHNpbWlsYXJpdHkgYXNzZXNzbWVudCBlc3BlY2lhbGx5IGZvciB0aGUgZmlyc3QgY29tbWl0
Lg0KPiBUaGVzZSBkbyBub3QgZml4IHRoZSBpc3N1ZSB0aG91Z2gsIHdpdGggbWFpbmxpbmUgdjUu
OC1yYzEgd2hpY2ggaGFzIGJvdGggSSdtDQo+IHN0aWxsIGdldHRpbmcgYSBoYW5nIG92ZXIgNTAl
IG9mIHRoZSB0aW1lIHdpdGggdGhlIGZvbGxvd2luZyBkZXRhY2ggc2VxdWVuY2UNCj4gb24gei9W
TToNCj4gDQo+IHZtY3AgZGV0YWNoIHBjaWYgPG1seF9maWQ+OyBlY2hvIDEgPiAvcHJvYy9jaW9f
c2V0dGxlDQo+IA0KPiBTaW5jZSBub3cgdGhlIGNvbW1pdCA0MTc5OGRmOWJmY2EgKCJuZXQvbWx4
NTogRHJhaW4gd3EgZmlyc3QgZHVyaW5nIFBDSQ0KPiBkZXZpY2UgcmVtb3ZhbCIpIG5vIGxvbmdl
ciByZXZlcnRzIGNsZWFubHkgSSB1c2VkIHRoZSBmb2xsb3dpbmcgZGlmZiB0byBtb3ZlDQo+IHRo
ZSBtbHg1X2RyYWluX2hlYWx0aF93cShkZXYpIGFmdGVyIHRoZSBtbHg1X3VucmVnaXN0ZXJfZGV2
aWNlcyhkZXYpLg0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9tYWluLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvbWFpbi5jDQo+IGluZGV4IDhiNjU4OTA4ZjA0NC4uNjNhMTk2ZmQ4ZTY4IDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5j
DQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLmMN
Cj4gQEAgLTEzODIsOCArMTM4Miw4IEBAIHN0YXRpYyB2b2lkIHJlbW92ZV9vbmUoc3RydWN0IHBj
aV9kZXYgKnBkZXYpDQo+IA0KPiAgICAgICAgIGRldmxpbmtfcmVsb2FkX2Rpc2FibGUoZGV2bGlu
ayk7DQo+ICAgICAgICAgbWx4NV9jcmR1bXBfZGlzYWJsZShkZXYpOw0KPiAtICAgICAgIG1seDVf
ZHJhaW5faGVhbHRoX3dxKGRldik7DQo+ICAgICAgICAgbWx4NV91bmxvYWRfb25lKGRldiwgdHJ1
ZSk7DQo+ICsgICAgICAgbWx4NV9kcmFpbl9oZWFsdGhfd3EoZGV2KTsNCj4gICAgICAgICBtbHg1
X3BjaV9jbG9zZShkZXYpOw0KPiAgICAgICAgIG1seDVfbWRldl91bmluaXQoZGV2KTsNCj4gICAg
ICAgICBtbHg1X2RldmxpbmtfZnJlZShkZXZsaW5rKTsNCj4gDQo+IA0KPiBOb3RlIHRoYXQgdGhp
cyBjaGFuZ2VkIG9yZGVyIGFsc28gbWF0Y2hlcyB0aGUgY2FsbCBvcmRlciBpbg0KPiBtbHg1X3Bj
aV9lcnJfZGV0ZWN0ZWQoKS4NCj4gV2l0aCB0aGF0IGNoYW5nZSBJJ3ZlIG5vdyBkb25lIG92ZXIg
dHdvIGRvemVuIGRldGFjaG1lbnRzIHdpdGggdmFyeWluZw0KPiB0aW1lIGJldHdlZW4gYXR0YWNo
IGFuZCBkZXRhY2ggdG8gaGF2ZSB0aGUgZHJpdmVyIGF0IGRpZmZlcmVudCBzdGFnZXMgb2YNCj4g
aW5pdGlhbGl6YXRpb24uDQo+IFdpdGggdGhlIGNoYW5nZSBhbGwgd29ya2VkIHdpdGhvdXQgYSBo
aXRjaC4NCj4gDQo+IEJlc3QgcmVnYXJkcywNCj4gTmlrbGFzIFNjaG5lbGxlDQo+ID4NCg0KU29y
cnkgZm9yIG15IGxhdGUgcmVzcG9uc2UuDQpZZXMsIHRoaXMgbG9va3MgZ29vZCBhbmQgSSBhbHNv
IGZvdW5kIHNhbWUgaW4gbXkgYW5hbHlzaXMuDQpXaXRoIGxhdGVzdCBjb2RlIG1seDVfcGNpX2Ns
b3NlKCkgYWxyZWFkeSBkb2VzIGRyYWluX2hlYWx0aF93cSgpLCBzbyB0aGUgYWRkaXRpb25hbCBj
YWxsIGluIHJlbW92ZV9vbmUoKSBpcyByZWR1bmRhbnQuDQpJdCBzaG91bGQgYmUganVzdCByZW1v
dmVkLg0KSWYgeW91IGNhbiB2ZXJpZnkgYmVsb3cgaHVuayBpbiB5b3VyIHNldHVwLCBpdCB3aWxs
IGJlIHJlYWxseSBoZWxwZnVsLg0KWW91IHN0aWxsIG5lZWQgcGF0Y2ggNDJlYTlmMWI1YzYgaW4g
eW91ciB0cmVlLg0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9tYWluLmMNCmluZGV4IDhiNjU4OTA4ZjA0NC4uZWJlYzIzMThkYmM0IDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4uYw0KKysrIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4uYw0KQEAgLTEzODIsNyAr
MTM4Miw2IEBAIHN0YXRpYyB2b2lkIHJlbW92ZV9vbmUoc3RydWN0IHBjaV9kZXYgKnBkZXYpDQoN
CiAgICAgICAgZGV2bGlua19yZWxvYWRfZGlzYWJsZShkZXZsaW5rKTsNCiAgICAgICAgbWx4NV9j
cmR1bXBfZGlzYWJsZShkZXYpOw0KLSAgICAgICBtbHg1X2RyYWluX2hlYWx0aF93cShkZXYpOw0K
ICAgICAgICBtbHg1X3VubG9hZF9vbmUoZGV2LCB0cnVlKTsNCiAgICAgICAgbWx4NV9wY2lfY2xv
c2UoZGV2KTsNCiAgICAgICAgbWx4NV9tZGV2X3VuaW5pdChkZXYpOw0K
