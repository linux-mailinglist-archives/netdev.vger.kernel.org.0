Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F1CF3D9D
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 02:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbfKHBtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 20:49:16 -0500
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:57907
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725928AbfKHBtQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 20:49:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L72fqbR5wxmmJttZByaRvT0NL0DqFm5XBldJpzmOuAsPvxBe3sEB1Ghhkew5bXwSkbxtlcJ1G9L2BGeDE4fWpOqP5PD+UpLQKdill/YuvVx9k416JBUya+vp1B4zNj5JVMf6tMIvROYo8p0PoYil9rnY0nOebL/hNe6VBvcaN4fwQUbYtJLkD3nAH6z9JiFjZ+th/+/F0t4fWmmOEz0Pf1DIO6+ZTRf8JBk077gKUyq9CvrcWNPrM2liD4VMkTsf8KVVZZ9M9dLZVxeMxjwv67EnbjZ/Ya2nEZzjtWvHhQudo1NXUYSwcErT8VeL+BZ5oB0mR/gjO37V+W8YWSGRVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5VQa1T/N1wsGq5grn0VKm9WTOb0NlMO6LUfelJqqWe8=;
 b=bf42qUAGh4d2jV7wHptm4+x0C+1gTJzeMcr2jQCDV12TOu+//EL7oFDiTpoHtfhsLpNzFucs/cxlZcK94Qi1x8NHT5nQIzW3dnkvAaxWEV16rMfc21/HSt+l83NF3hrE8R6bFHhJZ66V9FAsRlFdVWP3aqRGAI/SwAY2fc/aKnxqwvIarXodOzoG9ZcZwg1UEkKnleNNC0m03K/nnp+BnkYtf0kEJJcI2UFVbg74DthEZ9oOycIMukBhf6dbVGuU1mOTX2ajmPDrphET00xVE2vn4LwK4yLvqUprtha5B/e492Mv6nuQfOVF/QgM7coSTbu0gL+PO28v04a0UKqZ3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5VQa1T/N1wsGq5grn0VKm9WTOb0NlMO6LUfelJqqWe8=;
 b=L4rFzjcGZ3037pSlM7L7Jmxrv2lhTs2ZWPvti7+C1v3zJAXP2ZR3RXs4jwVLm6eZB0unK0QLCPfXLA4OD2Qti4mJYe24GiK9Tvp1QOqSEeVfNJp0pOJIL8IXOEx3Lg+T2U/dSGatk/e2+N8TEyf8Ie6FYmpON5fArVFEVpq401s=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5682.eurprd05.prod.outlook.com (20.178.114.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.23; Fri, 8 Nov 2019 01:49:09 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 01:49:09 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: RE: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Topic: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Index: AQHVlYUoVUzzBv4k4UmQHUerp08scaeAKe4AgAAC5uCAAExrgIAACDeA
Date:   Fri, 8 Nov 2019 01:49:09 +0000
Message-ID: <AM0PR05MB48668E29F1811F496602079ED17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <AM0PR05MB4866A2B92A64DDF345DB14F5D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107201627.68728686@cakuba>
In-Reply-To: <20191107201627.68728686@cakuba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:4df9:9131:e74:fff7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 69ece8f2-72f0-489e-c1d7-08d763edd91d
x-ms-traffictypediagnostic: AM0PR05MB5682:|AM0PR05MB5682:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB56828A03E4F9A56815767C2DD17B0@AM0PR05MB5682.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(199004)(189003)(13464003)(6246003)(6116002)(305945005)(53546011)(6506007)(99286004)(7736002)(86362001)(476003)(446003)(74316002)(66556008)(66476007)(64756008)(4326008)(81156014)(33656002)(81166006)(5660300002)(54906003)(256004)(66946007)(9686003)(25786009)(11346002)(102836004)(52536014)(478600001)(66446008)(186003)(6916009)(71190400001)(71200400001)(55016002)(8676002)(76116006)(6436002)(7416002)(7696005)(76176011)(2906002)(229853002)(316002)(14454004)(8936002)(46003)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5682;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DvB97rnL/9TEaN9ob3lF9MuBWQXrSeEskeFvZMaebPORavz3R8wxyo5F2it43iucOKPl8H9UnB37ioLXrI7ctgHs+AxzDIW6BQmhZQpouxfWV2BAUhyHEfd6bpBOrfDr+TWHmzBNyValDqFK8ik3YQ6bjnG/HPK2ZI6QIl4iLz2n5alvQ6KxR/U24DGZAQZzfDWOr2BEWqBs2JJk9nZ4H0h4LtY5rS1mAgViU44dQ2i3dIY5D+OfhBcYmlL1HrC/fJRo4o369eeYs3W/3so0BggAE8UuJ4jZ2kAtFtw4YYy8l3uOKFu8BFzgWGHCUuSKXo+Rbb0Y6oZyCpuGkeJeO6RolniuACtxT9Ct3f4tf+9X1hguPls3pJiQA/PZsqi2Ojz4v7DjGyrsdeh7YGix1HIgmy5DdgEqNM5whmTEg0GKMmtXmP7lTwGnROViT/7G
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ece8f2-72f0-489e-c1d7-08d763edd91d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 01:49:09.6150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mu9vKY+kGNulJI0GZRVaPPA5qv31JRNpddCqEX9mRLzmOtqvXF2Nz+syEdyj13KbbVbP9QZFZMfAJVbJ9/7vVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5682
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGpha3ViLmtpY2luc2tpQG5ldHJvbm9tZS5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBOb3ZlbWJl
ciA3LCAyMDE5IDc6MTYgUE0NCj4gVG86IFBhcmF2IFBhbmRpdCA8cGFyYXZAbWVsbGFub3guY29t
Pg0KPiBDYzogYWxleC53aWxsaWFtc29uQHJlZGhhdC5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7
DQo+IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IFNhZWVkIE1h
aGFtZWVkDQo+IDxzYWVlZG1AbWVsbGFub3guY29tPjsga3dhbmtoZWRlQG52aWRpYS5jb207IGxl
b25Aa2VybmVsLm9yZzsNCj4gY29odWNrQHJlZGhhdC5jb207IEppcmkgUGlya28gPGppcmlAbWVs
bGFub3guY29tPjsgbGludXgtDQo+IHJkbWFAdmdlci5rZXJuZWwub3JnOyBPciBHZXJsaXR6IDxn
ZXJsaXR6Lm9yQGdtYWlsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAwMC8x
OV0gTWVsbGFub3gsIG1seDUgc3ViIGZ1bmN0aW9uIHN1cHBvcnQNCj4gDQo+IE9uIFRodSwgNyBO
b3YgMjAxOSAyMDo1MjoyOSArMDAwMCwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+ID4gT24gVGh1
LCAgNyBOb3YgMjAxOSAxMDowNDo0OCAtMDYwMCwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+ID4g
PiBNZWxsYW5veCBzdWIgZnVuY3Rpb24gY2FwYWJpbGl0eSBhbGxvd3MgdXNlcnMgdG8gY3JlYXRl
IHNldmVyYWwNCj4gPiA+ID4gaHVuZHJlZHMgb2YgbmV0d29ya2luZyBhbmQvb3IgcmRtYSBkZXZp
Y2VzIHdpdGhvdXQgZGVwZW5kaW5nIG9uDQo+ID4gPiA+IFBDSSBTUi0NCj4gPiA+IElPViBzdXBw
b3J0Lg0KPiA+ID4NCj4gPiA+IFlvdSBjYWxsIHRoZSBuZXcgcG9ydCB0eXBlICJzdWIgZnVuY3Rp
b24iIGJ1dCB0aGUgZGV2bGluayBwb3J0IGZsYXZvdXIgaXMNCj4gbWRldi4NCj4gPiA+DQo+ID4g
U3ViIGZ1bmN0aW9uIGlzIHRoZSBpbnRlcm5hbCBkcml2ZXIgc3RydWN0dXJlLiBUaGUgYWJzdHJh
Y3QgZW50aXR5IGF0IHVzZXIgYW5kDQo+IHN0YWNrIGxldmVsIGlzIG1kZXYuDQo+ID4gSGVuY2Ug
dGhlIHBvcnQgZmxhdm91ciBpcyBtZGV2Lg0KPiANCj4gRldJVyBJIGFncmVlIG1kZXYgYXMgZmxh
dm91ciBzZWVtcyBsaWtlIHRoZSByaWdodCBjaG9pY2UuDQo+DQpPay4NCiANCj4gPiA+IEFzIEkn
bSBzdXJlIHlvdSByZW1lbWJlciB5b3UgbmFja2VkIG15IHBhdGNoZXMgZXhwb3NpbmcgTkZQJ3Mg
UENJDQo+ID4gPiBzdWIgZnVuY3Rpb25zIHdoaWNoIGFyZSBqdXN0IHJlZ2lvbnMgb2YgdGhlIEJB
UiB3aXRob3V0IGFueSBtZGV2DQo+ID4gPiBjYXBhYmlsaXR5LiBBbSBJIGluIHRoZSBjbGVhciB0
byByZXBvc3QgdGhvc2Ugbm93PyBKaXJpPw0KPiA+ID4NCj4gPiBGb3Igc3VyZSBJIGRpZG4ndCBu
YWNrIGl0LiA6LSkNCj4gDQo+IFdlbGwsIG1heWJlIHRoZSB3b3JkICJuYWNrIiB3YXNuJ3QgZXhh
Y3RseSB1c2VkIDopDQo+IA0KPiA+IFdoYXQgSSByZW1lbWJlciBkaXNjdXNzaW5nIG9mZmxpbmUv
bWFpbGluZyBsaXN0IGlzDQo+ID4gKGEpIGV4cG9zaW5nIG1kZXYvc3ViIGZ1Y3Rpb25zIGFzIGRl
dmxpbmsgc3ViIHBvcnRzIGlzIG5vdCBzbyBnb29kDQo+ID4gYWJzdHJhY3Rpb24NCj4gPiAoYikg
dXNlciBjcmVhdGluZy9kZWxldGluZyBlc3dpdGNoIHN1YiBwb3J0cyB3b3VsZCBiZSBoYXJkIHRv
IGZpdCBpbg0KPiA+IHRoZSB3aG9sZSB1c2FnZSBtb2RlbA0KPiANCj4gT2theSwgc28gSSBjYW4g
cmVwb3N0IHRoZSAiYmFzaWMiIHN1YiBmdW5jdGlvbnM/DQo+IA0KSSB0aGluayBzby4gV291bGQg
eW91IGxpa2UgcG9zdCBvbiB0b3Agb2YgdGhpcyBzZXJpZXMgYXMgcG9ydCBmbGF2b3VyIGV0YyB3
b3VsZCBjb21lIGJ5IGRlZmF1bHQ/DQpBbHNvIHRoZXJlIGlzIHZmaW8vbWRldiBkZXBlbmRlbmN5
IGV4aXN0IGluIHRoaXMgc2VyaWVzLi4uDQoNCj4gPiA+ID4gT3ZlcnZpZXc6DQo+ID4gPiA+IC0t
LS0tLS0tLQ0KPiA+ID4gPiBNZWxsYW5veCBDb25uZWN0WCBzdWIgZnVuY3Rpb25zIGFyZSBleHBv
c2VkIHRvIHVzZXIgYXMgYSBtZWRpYXRlZA0KPiA+ID4gPiBkZXZpY2UgKG1kZXYpIFsyXSBhcyBk
aXNjdXNzZWQgaW4gUkZDIFszXSBhbmQgZnVydGhlciBkdXJpbmcNCj4gPiA+ID4gbmV0ZGV2Y29u
ZjB4MTMgYXQgWzRdLg0KPiA+ID4gPg0KPiA+ID4gPiBtbHg1IG1lZGlhdGVkIGRldmljZSAobWRl
dikgZW5hYmxlcyB1c2VycyB0byBjcmVhdGUgbXVsdGlwbGUNCj4gPiA+ID4gbmV0ZGV2aWNlcyBh
bmQvb3IgUkRNQSBkZXZpY2VzIGZyb20gc2luZ2xlIFBDSSBmdW5jdGlvbi4NCj4gPiA+ID4NCj4g
PiA+ID4gRWFjaCBtZGV2IG1hcHMgdG8gYSBtbHg1IHN1YiBmdW5jdGlvbi4NCj4gPiA+ID4gbWx4
NSBzdWIgZnVuY3Rpb24gaXMgc2ltaWxhciB0byBQQ0kgVkYuIEhvd2V2ZXIgaXQgZG9lc24ndCBo
YXZlDQo+ID4gPiA+IGl0cyBvd24gUENJIGZ1bmN0aW9uIGFuZCBNU0ktWCB2ZWN0b3JzLg0KPiA+
ID4gPg0KPiA+ID4gPiBtbHg1IG1kZXZzIHNoYXJlIGNvbW1vbiBQQ0kgcmVzb3VyY2VzIHN1Y2gg
YXMgUENJIEJBUiByZWdpb24sDQo+ID4gPiA+IE1TSS1YIGludGVycnVwdHMuDQo+ID4gPiA+DQo+
ID4gPiA+IEVhY2ggbWRldiBoYXMgaXRzIG93biB3aW5kb3cgaW4gdGhlIFBDSSBCQVIgcmVnaW9u
LCB3aGljaCBpcw0KPiA+ID4gPiBhY2Nlc3NpYmxlIG9ubHkgdG8gdGhhdCBtZGV2IGFuZCBhcHBs
aWNhdGlvbnMgdXNpbmcgaXQuDQo+ID4gPiA+DQo+ID4gPiA+IEVhY2ggbWx4NSBzdWIgZnVuY3Rp
b24gaGFzIGl0cyBvd24gcmVzb3VyY2UgbmFtZXNwYWNlIGZvciBSRE1BDQo+IHJlc291cmNlcy4N
Cj4gPiA+ID4NCj4gPiA+ID4gbWRldnMgYXJlIHN1cHBvcnRlZCB3aGVuIGVzd2l0Y2ggbW9kZSBv
ZiB0aGUgZGV2bGluayBpbnN0YW5jZSBpcw0KPiA+ID4gPiBpbiBzd2l0Y2hkZXYgbW9kZSBkZXNj
cmliZWQgaW4gZGV2bGluayBkb2N1bWVudGF0aW9uIFs1XS4NCj4gPiA+DQo+ID4gPiBTbyBwcmVz
dW1hYmx5IHRoZSBtZGV2cyBkb24ndCBzcGF3biB0aGVpciBvd24gZGV2bGluayBpbnN0YW5jZQ0K
PiA+ID4gdG9kYXksIGJ1dCBvbmNlIG1hcHBlZCB2aWEgVklSVElPIHRvIGEgVk0gdGhleSB3aWxs
IGNyZWF0ZSBvbmU/DQo+ID4gPg0KPiA+IG1kZXYgZG9lc24ndCBzcGF3biB0aGUgZGV2bGluayBp
bnN0YW5jZSB0b2RheSB3aGVuIG1kZXYgaXMgY3JlYXRlZCBieQ0KPiB1c2VyLCBsaWtlIFBDSS4N
Cj4gPiBXaGVuIFBDSSBidXMgZHJpdmVyIGVudW1lcmF0ZXMgYW5kIGNyZWF0ZXMgUENJIGRldmlj
ZSwgdGhlcmUgaXNuJ3QgYQ0KPiBkZXZsaW5rIGluc3RhbmNlIGZvciBpdC4NCj4gPg0KPiA+IEJ1
dCwgbWRldidzIGRldmxpbmsgaW5zdGFuY2UgaXMgY3JlYXRlZCB3aGVuIG1seDVfY29yZSBkcml2
ZXIgYmluZHMgdG8gdGhlDQo+IG1kZXYgZGV2aWNlLg0KPiA+IChhZ2FpbiBzaW1pbGFyIHRvIFBD
SSwgd2hlbiBtbHg1X2NvcmUgZHJpdmVyIGJpbmRzIHRvIFBDSSwgaXRzIGRldmxpbmsNCj4gaW5z
dGFuY2UgaXMgY3JlYXRlZCApLg0KPiA+DQo+ID4gSSBzaG91bGQgaGF2ZSBwdXQgdGhlIGV4YW1w
bGUgaW4gcGF0Y2gtMTUgd2hpY2ggY3JlYXRlcy9kZWxldGVzIGRldmxpbmsNCj4gaW5zdGFuY2Ug
b2YgbWRldi4NCj4gPiBJIHdpbGwgcmV2aXNlIHRoZSBjb21taXQgbG9nIG9mIHBhdGNoLTE1IHRv
IGluY2x1ZGUgdGhhdC4NCj4gPiBHb29kIHBvaW50Lg0KPiANCj4gVGhhbmtzLg0KPiANCj4gPiA+
IEl0IGNvdWxkIGJlIHVzZWZ1bCB0byBzcGVjaWZ5Lg0KPiA+ID4NCj4gPiBZZXMsIGl0cyBjZXJ0
YWlubHkgdXNlZnVsLiBJIG1pc3NlZCB0byBwdXQgdGhlIGV4YW1wbGUgaW4gY29tbWl0IGxvZyBv
Zg0KPiBwYXRjaC0xNS4NCj4gPg0KPiA+ID4gPiBOZXR3b3JrIHNpZGU6DQo+ID4gPiA+IC0gQnkg
ZGVmYXVsdCB0aGUgbmV0ZGV2aWNlIGFuZCB0aGUgcmRtYSBkZXZpY2Ugb2YgbWx4NSBtZGV2IGNh
bm5vdA0KPiA+ID4gPiBzZW5kIG9yIHJlY2VpdmUgYW55IHBhY2tldHMgb3ZlciB0aGUgbmV0d29y
ayBvciB0byBhbnkgb3RoZXIgbWx4NQ0KPiBtZGV2Lg0KPiA+ID4NCj4gPiA+IERvZXMgdGhpcyBt
ZWFuIHRoZSBmcmFtZXMgZG9uJ3QgZmFsbCBiYWNrIHRvIHRoZSByZXByIGJ5IGRlZmF1bHQ/DQo+
ID4gUHJvYmFibHkgSSB3YXNuJ3QgY2xlYXIuDQo+ID4gV2hhdCBJIHdhbnRlZCB0byBzYXkgaXMs
IHRoYXQgZnJhbWVzIHRyYW5zbWl0dGVkIGJ5IG1kZXYncyBuZXRkZXZpY2UgYW5kDQo+IHJkbWEg
ZGV2aWNlcyBkb24ndCBnbyB0byBuZXR3b3JrLg0KPiA+IFRoZXNlIGZyYW1lcyBnb2VzIHRvIHJl
cHJlc2VudG9yIGRldmljZS4NCj4gPiBVc2VyIG11c3QgY29uZmlndXJlIHJlcHJlc2VudG9yIHRv
IHNlbmQvcmVjZWl2ZS9zdGVlciB0cmFmZmljIHRvIG1kZXYuDQo+IA0KPiDwn5GNDQo=
