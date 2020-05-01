Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F93D1C1DDD
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 21:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgEAT2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 15:28:21 -0400
Received: from mail-eopbgr80042.outbound.protection.outlook.com ([40.107.8.42]:48103
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726394AbgEAT2U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 15:28:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XzrK08SMbklRTeK1D58z574hVtzFMHLqH6oC+YW4DnDmXPDpFEzEbAzGrJcGyzsVoKJLr4Gxx7U/ke8D31EpanQOrllI3bsSytTM/uydaksoUf9XlERl/hUnpeHD7ffDADgFmDnHN8B/m2VWsJD0YE4ghHwbZySQ/dLbZWPK0WMxN/T0S8Yrd0AaeWB/nxEo7Tgd4mZAfVVM9evifkHVpuaabYXcbWo6PCc6GbIjojVfpwCVnPk60K0V4MToZEd+7756TKsWHz0ZlArVxN+ZNhHSiFZEvAMsWGXVFQpRic/DSEskKgzFAYGkvn6Sas+bvp9j9qsKFKcYlScOrAEmhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovt6n3fAKxUz65JaYii97606QZ8WhgRCGIqUFNsY9v8=;
 b=Pbj/zwbLZGJXD2R62Kf5wG5rMcYie5x9ltt1bPhl2VegeUj0MJExtdcwqRUlGXh1c5im0Fj3TmSxFbaYPeacViuZR4B0DDkUtJamSvBzMPKRtpTZZZM4CbHNrjsvlDd0gB9kMlZNofMaZK2+qtQniwq/XH1FzLVA8Wz539Y2qzVDpLe3wRZO5buKFmHQlLcs1f1LRMyshIQpLHDSqgjj4yZKQ7MtQ198lbnrRhRCa1cSqplT1pphL7MAinmi+nMuf5pon3dD6ki+d6XjUugPCt7cPxU/mjtiaj5l6Nxtv3pviN9a4W7+2dDOBPmk52Yx8ID22qXDcD9n3mcU8ZFESg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovt6n3fAKxUz65JaYii97606QZ8WhgRCGIqUFNsY9v8=;
 b=fXEaN1t3qHHbuygSUUbt+10BFKthQTgbZ/qIVxl1MWyrlsCPEts3WIXFeqeQxZLN5bENx05aAU6R5dpbzqahfu4TrX/KhjBycxOejQBWmFCD1kWtvk7daI2SN3+Y7JNTxGR0OUxYMVYQ5mWVLE7mKn32z2fm77s9xs4jIFB/BOM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5407.eurprd05.prod.outlook.com (2603:10a6:803:93::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Fri, 1 May
 2020 19:28:15 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Fri, 1 May 2020
 19:28:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Maor Gottlieb <maorg@mellanox.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Leon Romanovsky <leonro@mellanox.com>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Alex Rosenbaum <alexr@mellanox.com>
Subject: Re: [PATCH V8 mlx5-next 00/16] Add support to get xmit slave
Thread-Topic: [PATCH V8 mlx5-next 00/16] Add support to get xmit slave
Thread-Index: AQHWHyScsE87mY/giUqzQedJvoid5aiTT9YAgABPLgA=
Date:   Fri, 1 May 2020 19:28:14 +0000
Message-ID: <3bee27c7f4b28d55ef73e5be5c2024d90d7949b9.camel@mellanox.com>
References: <20200430192146.12863-1-maorg@mellanox.com>
         <20200501144448.GO26002@ziepe.ca>
In-Reply-To: <20200501144448.GO26002@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a8dde4af-9a75-437a-4ad5-08d7ee05cb4a
x-ms-traffictypediagnostic: VI1PR05MB5407:|VI1PR05MB5407:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB54072E40A0961D015512CAFEBEAB0@VI1PR05MB5407.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0390DB4BDA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(478600001)(36756003)(107886003)(110136005)(26005)(54906003)(5660300002)(316002)(66556008)(66446008)(66946007)(64756008)(6512007)(91956017)(186003)(66476007)(6506007)(76116006)(966005)(2616005)(6486002)(8676002)(2906002)(71200400001)(86362001)(7416002)(8936002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MSY7B94eFteVzi0kwD+8AQIUrCBXQbJhDafoWzgjzsqnvp448DttHSUcL+o5TymdqpRI7VukhTzvaEvDM6bFSy+VOubLNvBbMjjwMPLVsLk5ncQxdIQPI54i6bONaZCWyjgj9HDkpSzfEgsjYd/ZDetWuJbhoETiPrTwNAcynDLy7O8uJSA68JyzUcBneYgcwbsUGE4QPdaOxq3QPv1eRzZtgP2YEfdu9vXR3d++vv8SWLyKa/yRx/mWZMMnZEWqGB/bxT5Ji/7WLeE4I3ZL8sa3p95dLe3/FgOKg7oC/GO6AVSbvSSbm4BbloO9Xs1zEmnWburXX374WAvivEsyaQRsQaglZYhYirSFUlYLBqp8UbZAU6aq1IuKWL6inx8mmrXmVoTU0ZpPgkqYFAGzK8Vy0fn1XRwQVvcY6lDpFMk8jPtIn6JkX/ejltUZnmKsLFQeVlX0HB1kAp+5kgkFF1XAJgyfsdyYQMIpLXCsS7iq9SvmcUw6oPx7hMa2dXny2IFXt3TPSNjtyfxL25imOQ==
x-ms-exchange-antispam-messagedata: ulmnosznA1Yy6BkXloqY/a3oSl9HbvJoP/YE22nh3VESSkyWlKD0+5JMBvLJ2fMr76QwIa+KuOMRhdi8NN9TchgNWBchpt5LTz5CHwFUuYh0sN7mZM7lXtxzbMa81ATedTSF9MlKvcIkffM71EELfvHfX+Npnlprr0rZdksn9wd0QoDTKvp840X4PJFGcbZjfFMWIsc8HsmdxBJr1NcNmu5hsIlgukVAcgqZtyFXcfdraq03K2jzCuUhVHzwsfMUigkKBHwZaV1Ddq8P9ZG0+aAvZIP/vNlsVUu9YE+ZHUvV+5DASe0oS4c5SgUJxB9Xz7aNJfHixBgnab4IJRJO3ODFXG7Rnp8DdirEI+iY2QxO3Gbtgastc/s9NVJYMClMkxwkjQEt2IjwTuuWDfz1808xskPD5qkcTW75yuNiiKXvGJ8xy5JM3Zi9/leUgNZ5vHCLK6KmMrAFjg7MVIzko+/Y7wVL9mQnGl5ZUhGnqeLmn3PeetYFWXIh5NeHT9aM42ySgRNT7aLcz6wAMH6BKUEGaSiHpLgdHYFULEYteN71J1KQz3PtE3bVehAHOVgWxt0Zl6bBynocBAhI2ot+1OqRrbkwC7RaFmmxDMmyjdEWf9CQwnkNachXFGwqN8+6bGLzwXiJC7nSA7XMA1jZ9CaILIShse5ibGfsK4TjmkbTk06klAt1CWFPhNk8z7SdfRs1vcL73YNW8oNmouoxFyNoOHorYHdawEloYgR3bgL/JPqVdhTWoLPHsOjPJc5bidMSQioWuCf5H4WzeD2nzJum1Uw1KSeTs0eDrvOtE98=
Content-Type: text/plain; charset="utf-8"
Content-ID: <70EBC5ECF19B2440BE2DC09C546AB5BE@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8dde4af-9a75-437a-4ad5-08d7ee05cb4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2020 19:28:14.7356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LMf6XCK8t+prFy3u/FHjAQaL6QB1tWAQ9lLh8efZvXemaLgnZ1GzHri3fBrEFo6Z+LNgm+cAaBhMeNGC58/vgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5407
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA1LTAxIGF0IDExOjQ0IC0wMzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIFRodSwgQXByIDMwLCAyMDIwIGF0IDEwOjIxOjMwUE0gKzAzMDAsIE1hb3IgR290dGxp
ZWIgd3JvdGU6DQo+ID4gSGkgRGF2ZSwNCj4gPiANCj4gPiBUaGlzIHNlcmllcyBpcyBhIGNvbWJp
bmF0aW9uIG9mIG5ldGRldiBhbmQgUkRNQSwgc28gaW4gb3JkZXIgdG8NCj4gPiBhdm9pZA0KPiA+
IGNvbmZsaWN0cywgd2Ugd291bGQgbGlrZSB0byBhc2sgeW91IHRvIHJvdXRlIHRoaXMgc2VyaWVz
IHRocm91Z2gNCj4gPiBtbHg1LW5leHQgc2hhcmVkIGJyYW5jaC4gSXQgaXMgYmFzZWQgb24gdjUu
Ny1yYzIgdGFnLg0KPiA+IA0KPiA+IA0KPiA+IFRoZSBmb2xsb3dpbmcgc2VyaWVzIGFkZHMgc3Vw
cG9ydCB0byBnZXQgdGhlIExBRyBtYXN0ZXIgeG1pdCBzbGF2ZQ0KPiA+IGJ5DQo+ID4gaW50cm9k
dWNpbmcgbmV3IC5uZG8gLSBuZG9fZ2V0X3htaXRfc2xhdmUuIEV2ZXJ5IExBRyBtb2R1bGUgY2Fu
DQo+ID4gaW1wbGVtZW50IGl0IGFuZCBpdCBmaXJzdCBpbXBsZW1lbnRlZCBpbiB0aGUgYm9uZCBk
cml2ZXIuIA0KPiA+IFRoaXMgaXMgZm9sbG93LXVwIHRvIHRoZSBSRkMgZGlzY3Vzc2lvbiBbMV0u
DQo+ID4gDQo+ID4gVGhlIG1haW4gbW90aXZhdGlvbiBmb3IgZG9pbmcgdGhpcyBpcyBmb3IgZHJp
dmVycyB0aGF0IG9mZmxvYWQgcGFydA0KPiA+IG9mIHRoZSBMQUcgZnVuY3Rpb25hbGl0eS4gRm9y
IGV4YW1wbGUsIE1lbGxhbm94IENvbm5lY3QtWCBoYXJkd2FyZQ0KPiA+IGltcGxlbWVudHMgUm9D
RSBMQUcgd2hpY2ggc2VsZWN0cyB0aGUgVFggYWZmaW5pdHkgd2hlbiB0aGUNCj4gPiByZXNvdXJj
ZXMNCj4gPiBhcmUgY3JlYXRlZCBhbmQgcG9ydCBpcyByZW1hcHBlZCB3aGVuIGl0IGdvZXMgZG93
bi4NCj4gPiANCj4gPiBUaGUgZmlyc3QgcGFydCBvZiB0aGlzIHBhdGNoc2V0IGludHJvZHVjZXMg
dGhlIG5ldyAubmRvIGFuZCBhZGQgdGhlDQo+ID4gc3VwcG9ydCB0byB0aGUgYm9uZGluZyBtb2R1
bGUuDQo+ID4gDQo+ID4gVGhlIHNlY29uZCBwYXJ0IGFkZHMgc3VwcG9ydCB0byBnZXQgdGhlIFJv
Q0UgTEFHIHhtaXQgc2xhdmUgYnkNCj4gPiBidWlsZGluZw0KPiA+IHNrYiBvZiB0aGUgUm9DRSBw
YWNrZXQgYmFzZWQgb24gdGhlIEFIIGF0dHJpYnV0ZXMgYW5kIGNhbGwgdG8gdGhlDQo+ID4gbmV3
DQo+ID4gLm5kby4NCj4gPiANCj4gPiBUaGUgdGhpcmQgcGFydCBjaGFuZ2UgdGhlIG1seDUgZHJp
dmVyIGRyaXZlciB0byBzZXQgdGhlIFFQJ3MNCj4gPiBhZmZpbml0eQ0KPiA+IHBvcnQgYWNjb3Jk
aW5nIHRvIHRoZSBzbGF2ZSB3aGljaCBmb3VuZCBieSB0aGUgLm5kby4NCj4gPiANCj4gPiBUaGFu
a3MNCj4gPiANCj4gPiBbMV0NCj4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAy
MDAxMjYxMzIxMjYuOTk4MS0xLW1hb3JnQHh4eHh4eHh4eHh4eC8NCj4gDQo+IHdoZXJlIGRpZCB0
aGVzZSB4eHh4eCdzIGNvbWUgZnJvbT8NCj4gDQo+ID4gQ2hhbmdlIGxvZzoNCj4gPiB2ODogRml4
IGJhZCBudW1iZXJpbmcgb2YgdjcuIA0KPiA+IHY3OiBDaGFuZ2Ugb25seSBpbiBSRE1BIHBhcnQ6
DQo+ID4gCS0gcmV0dXJuIHNsYXZlIGFuZCBhcyBvdXRwdXQNCj4gPiAJLSBEb24ndCBob2xkIGxv
Y2sgd2hpbGUgYWxsb2NhdGluZyBza2IuDQo+ID4gICAgIEluIGFkZGl0aW9uLCByZW9yZGVyIHBh
dGNoZXMsIHNvIG1seDUgcGF0Y2hlcyBhcmUgYmVmb3JlIFJETUEuDQo+ID4gdjY6IHBhdGNoIDEg
LSBGaXggY29tbWl0IG1lc3NhZ2UgYW5kIGFkZCBmdW5jdGlvbiBkZXNjcmlwdGlvbi4gDQo+ID4g
ICAgIHBhdGNoIDEwIC0gS2VlcCB1ZGF0YSBhcyBmdW5jdGlvbiBhcmd1bWVudC4NCj4gPiB2NTog
cGF0Y2ggMSAtIFJlbW92ZSByY3UgbG9jay4NCj4gPiAgICAgcGF0Y2ggMTAgLSBSZWZhY3RvciBw
YXRjaCB0aGF0IGdyb3VwIHRoZSBBSCBhdHRyaWJ1dGVzIGluDQo+ID4gc3RydWN0Lg0KPiA+ICAg
ICBwYXRjaCAxMSAtIGNhbGwgdGhlIG5kbyB3aGlsZSBob2xkaW5nIHRoZSByY3UgYW5kIGluaXRp
YWxpemUNCj4gPiB4bWl0X3NsYXZlLg0KPiA+ICAgICBwYXRjaCAxMiAtIFN0b3JlIHRoZSB4bWl0
IHNsYXZlIGluIHJkbWFfYWhfaW5pdF9hdHRyIGFuZA0KPiA+IHFwX2F0dHIuDQo+ID4gDQo+ID4g
djQ6IDEuIFJlbmFtZSBtYXN0ZXJfZ2V0X3htaXRfc2xhdmUgdG8gbmV0ZGV2X2dldF94bWl0X3Ns
YXZlIGFuZA0KPiA+IG1vdmUNCj4gPiB0aGUgaW1wbGVtZW50YXRpb24gdG8gZGV2LmMgDQo+ID4g
ICAgIDIuIFJlbW92ZSB1bm5lY2Vzc2FyeSBjaGVjayBvZiBOVUxMIHBvaW50ZXIuDQo+ID4gICAg
IDMuIEZpeCB0eXBvLg0KPiA+IHYzOiAxLiBNb3ZlIG1hc3Rlcl9nZXRfeG1pdF9zbGF2ZSB0byBu
ZXRkZXZpY2UuaCBhbmQgY2hhbmdlIHRoZQ0KPiA+IGZsYWdzDQo+ID4gYXJnLg0KPiA+IHRvIGJv
b2wuDQo+ID4gICAgIDIuIFNwbGl0IGhlbHBlciBmdW5jdGlvbnMgY29tbWl0IHRvIG11bHRpcGxl
IGNvbW1pdHMgZm9yIGVhY2gNCj4gPiBib25kDQo+ID4gbW9kZS4NCj4gPiAgICAgMy4gRXh0cmFj
dCByZWZjb3RyaW5nIGNoYW5nZXMgdG8gc2VwZXJhdGUgY29tbWl0cy4NCj4gPiB2MjogVGhlIGZp
cnN0IHBhdGNoIHdhc24ndCBzZW50IGluIHYxLg0KPiA+IHYxOg0KPiA+IGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL25ldGRldi9hYzM3MzQ1Ni1iODM4LTI5Y2YtNjQ1Zi1iMWVhMWE5M2UzYjBAeHh4
eHh4eHh4L1QvI3QgDQo+ID4gDQo+ID4gTWFvciBHb3R0bGllYiAoMTYpOg0KPiA+ICAgbmV0L2Nv
cmU6IEludHJvZHVjZSBuZXRkZXZfZ2V0X3htaXRfc2xhdmUNCj4gPiAgIGJvbmRpbmc6IEV4cG9y
dCBza2lwIHNsYXZlIGxvZ2ljIHRvIGZ1bmN0aW9uDQo+ID4gICBib25kaW5nOiBSZW5hbWUgc2xh
dmVfYXJyIHRvIHVzYWJsZV9zbGF2ZXMNCj4gPiAgIGJvbmRpbmcvYWxiOiBBZGQgaGVscGVyIGZ1
bmN0aW9ucyB0byBnZXQgdGhlIHhtaXQgc2xhdmUNCj4gPiAgIGJvbmRpbmc6IEFkZCBoZWxwZXIg
ZnVuY3Rpb24gdG8gZ2V0IHRoZSB4bWl0IHNsYXZlIGJhc2VkIG9uIGhhc2gNCj4gPiAgIGJvbmRp
bmc6IEFkZCBoZWxwZXIgZnVuY3Rpb24gdG8gZ2V0IHRoZSB4bWl0IHNsYXZlIGluIHJyIG1vZGUN
Cj4gPiAgIGJvbmRpbmc6IEFkZCBmdW5jdGlvbiB0byBnZXQgdGhlIHhtaXQgc2xhdmUgaW4gYWN0
aXZlLWJhY2t1cCBtb2RlDQo+ID4gICBib25kaW5nOiBBZGQgYXJyYXkgb2YgYWxsIHNsYXZlcw0K
PiA+ICAgYm9uZGluZzogSW1wbGVtZW50IG5kb19nZXRfeG1pdF9zbGF2ZQ0KPiA+ICAgbmV0L21s
eDU6IENoYW5nZSBsYWcgbXV0ZXggbG9jayB0byBzcGluIGxvY2sNCj4gPiAgIG5ldC9tbHg1OiBB
ZGQgc3VwcG9ydCB0byBnZXQgbGFnIHBoeXNpY2FsIHBvcnQNCj4gPiAgIFJETUE6IEdyb3VwIGNy
ZWF0ZSBBSCBhcmd1bWVudHMgaW4gc3RydWN0DQo+ID4gICBSRE1BL2NvcmU6IEFkZCBMQUcgZnVu
Y3Rpb25hbGl0eQ0KPiA+ICAgUkRNQS9jb3JlOiBHZXQgeG1pdCBzbGF2ZSBmb3IgTEFHDQo+ID4g
ICBSRE1BL21seDU6IFJlZmFjdG9yIGFmZmluaXR5IHJlbGF0ZWQgY29kZQ0KPiA+ICAgUkRNQS9t
bHg1OiBTZXQgbGFnIHR4IGFmZmluaXR5IGFjY29yZGluZyB0byBzbGF2ZQ0KPiANCj4gSXQgc2Vl
bXMgZmluZSB0byBtZSB0b28sIFNhZWVkLCBjYW4geW91IGFwcGx5IHRoZSBuZXQgcGFydHMgdG8g
dGhlDQo+IG1seDUgc2hhcmVkIGJyYW5jaCB3aXRoIERhdmVNJ3MgYWNrPyBUaGFua3MNCj4gDQoN
CkRvbmU6DQoNCmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0
L21lbGxhbm94L2xpbnV4LmdpdC9sb2cvP2g9bWx4NS1uZXh0DQoNCg0KSSB3aWxsIHNlbmQgYSBm
b3JtYWwgcHVsbCByZXF1ZXN0IHNvb24sIGZlZWwgZnJlZSB0byBwdWxsIHRoaXMgYmVmb3JlDQpp
ZiB5b3Ugd2lzaCB0by4NCg0KU2FlZWQNCg==
