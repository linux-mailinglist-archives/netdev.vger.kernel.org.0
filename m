Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9540414DE04
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 16:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbgA3PkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 10:40:22 -0500
Received: from mail-eopbgr50069.outbound.protection.outlook.com ([40.107.5.69]:18080
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727158AbgA3PkW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 10:40:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZGZKX8mHnNofFL2ayV0s1ijqSzd0VsJgG1WbTarQRizSmegTcCszOo5fGMlGglDcaTtF4C2+Nh1IZwcmxdE0DIsFYVHqvH86SXc53y9cL9iHfe/oepsEE5Fz+uFhuFKCCFGh73uc7m8f99XKRc8fjVUIi4LCx3/z5OnlPsGbNAwO5se7wr/dScnH1zmM+vbPUFdScyVuuOWx/Ma8BtHwtjMEGwPzwDoKwpsnERw+uap52GFuZUX2mugBFd3nR00qNFwDq6xAhXZojRSY88MrCrNJOa5jaTa5+dlUEVMxRHihqWuuKGIHep0MwE+5ePHUQkWWP0Cc7D7MykrhkOkww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xe33jDIA/1GLgmrH9NbOw5Kx8yxB2uZoGuaO++Na7uE=;
 b=Qy2fdvJ4TAel12JUvpk5PmqfYLlI4zx7t9qmKDQBKwn8nNk3jfqD19xB8iy0ELtuIGzXF4aCJTMCDsTXCM2xeCeZT64QPk0zNpkD1pkN2V1UOwoNY0flgzuah6QvQD6smnRECffuADlceNKdBJLvd2kTJWgy9Bq/Qepdy2gWCaq3ZiIrm8md8J34dTswzZDZrbob59RiPbt9PVrFs1hLZRi5cW5glx4qLUONHFmopnGH4CIxSsKBk6sHac5qKKeZQ+KNcbBI8Ff+Oxwf6mrB4UcsmM+AiPERh6Qn0r5Elqnn3dV7AZL4YnaGDGRcKUpKcDqcLrCAbzlZySwi2nClTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xe33jDIA/1GLgmrH9NbOw5Kx8yxB2uZoGuaO++Na7uE=;
 b=fDKlerZauaBiGNWoZOQljdZrpBkT0ddJncLzXIOnS/Bff9RjckhWrCSqY3UYsuUZUszMdQGEum4aNX/9Veue/QRbzpKFx8yNqn6pUatd6G1QQYdu64lsBr3wLJ7P67osF+96o78B+x2G3UG3CufgJk8JeS5TZMCu7mAoLAn/RiQ=
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com (20.178.117.153) by
 AM0PR05MB4291.eurprd05.prod.outlook.com (52.134.91.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.23; Thu, 30 Jan 2020 15:40:18 +0000
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::a556:1de2:ef6c:9192]) by AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::a556:1de2:ef6c:9192%4]) with mapi id 15.20.2665.027; Thu, 30 Jan 2020
 15:40:18 +0000
Received: from [10.80.3.21] (193.47.165.251) by AM0PR01CA0002.eurprd01.prod.exchangelabs.com (2603:10a6:208:69::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.27 via Frontend Transport; Thu, 30 Jan 2020 15:40:17 +0000
From:   Maor Gottlieb <maorg@mellanox.com>
To:     Gal Pressman <galpress@amazon.com>
CC:     "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [RFC PATCH 1/4] net/core: Introduce master_xmit_slave_get
Thread-Topic: [RFC PATCH 1/4] net/core: Introduce master_xmit_slave_get
Thread-Index: AQHV1EuKLCoxBRwfe0u3WHSan58lh6gBbGWAgAHyJYA=
Date:   Thu, 30 Jan 2020 15:40:18 +0000
Message-ID: <0c72c634-14ef-3e24-6f83-6a1783170b83@mellanox.com>
References: <20200126132126.9981-1-maorg@mellanox.com>
 <20200126132126.9981-2-maorg@mellanox.com>
 <f27d00e8-e6b5-51a2-fd70-5ed3e5f97610@amazon.com>
In-Reply-To: <f27d00e8-e6b5-51a2-fd70-5ed3e5f97610@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
x-clientproxiedby: AM0PR01CA0002.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:69::15) To AM0PR05MB5873.eurprd05.prod.outlook.com
 (2603:10a6:208:125::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maorg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5d9c2ae0-157e-4e79-1ced-08d7a59ab590
x-ms-traffictypediagnostic: AM0PR05MB4291:|AM0PR05MB4291:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB42919F651776345F6E4A547FD3040@AM0PR05MB4291.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 02981BE340
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(39860400002)(376002)(396003)(189003)(199004)(186003)(81156014)(16526019)(2616005)(81166006)(8676002)(2906002)(5660300002)(52116002)(26005)(6916009)(31686004)(71200400001)(956004)(54906003)(6486002)(8936002)(66946007)(316002)(66476007)(86362001)(53546011)(66446008)(36756003)(4326008)(478600001)(66556008)(64756008)(31696002)(16576012);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4291;H:AM0PR05MB5873.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1mAd/gxxHujWBZxRM3NLu3M9vJnPe8d4wYFZ6HdwL74uYfI1tJu4kFOj2NeyxwjIzoMZ7ovxSS0/r48MokNVbAV92u0+V3XCEZieYWfBzQ8kJBjjyTVX+zfSXtFhUCYJAjtEfZm7RfksIUQYKfWKaAsN9piCExEx6fZEgtDKcJ1V+Ne4wvM34ojjN3p+Y8JHtnp4ev+6BIGYGJw8BTBs93lnk5tRTRMHoRUiuNhyVzpF0ThORlXnrshtgtvytA9pU2xM1AS0AZ1eRXadBxN1e8noizHIKSdh2QZDKsraWTKvdSabHIclRQwOzbxa2iiEdvCm0lrWBKv5BKHFyG2Whbb/uBOgXuFMFBx++4hLUCtZ7rjOdix0YV1QOGyiTivnx3BVBqc61IYQkM9lmthUPjYFRyoaqZNv/A/I+Av2+jX82aqE45ST1YTOaj3gtfzE
x-ms-exchange-antispam-messagedata: /VWQbOFEO7rZsloLogohprgY3y/mc+BdTmE4yaqbdIxRuTsTRnEh3Q79VjaFOwJQJFPEn7YM5SxbWy4X8vUibPBRDpnSzJ6GzkvSA1SHoYVT5o7cLqi3ivzlmoLLHKxWttpGGt0bBVbQ/QzDNWZvrQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED785B5C13BAC148A8C756A176D07096@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d9c2ae0-157e-4e79-1ced-08d7a59ab590
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2020 15:40:18.8130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TgjoQXR1wRdKG3TJDAlx7st9Azub6PHEwj+sb8PZ3S+Bcqokyt61HaVzFpSJKXk39QCq2v+iCNlZHcseySMdwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4291
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzI5LzIwMjAgMTE6NTcgQU0sIEdhbCBQcmVzc21hbiB3cm90ZToNCj4gT24gMjYvMDEv
MjAyMCAxNToyMSwgTWFvciBHb3R0bGllYiB3cm90ZToNCj4+IEFkZCBuZXcgbmRvIHRvIGdldCB0
aGUgeG1pdCBzbGF2ZSBvZiBtYXN0ZXIgZGV2aWNlLg0KPj4gV2hlbiBzbGF2ZSBzZWxlY3Rpb24g
bWV0aG9kIGlzIGJhc2VkIG9uIGhhc2gsIHRoZW4gdGhlIHVzZXIgY2FuIGFzayB0bw0KPj4gZ2V0
IHRoZSB4bWl0IHNsYXZlIGFzc3VtZSBhbGwgdGhlIHNsYXZlcyBjYW4gdHJhbnNtaXQgYnkgc2V0
dGluZyB0aGUNCj4+IExBR19GTEFHU19IQVNIX0FMTF9TTEFWRVMgYml0IGluIHRoZSBmbGFncyBh
cmd1bWVudC4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBNYW9yIEdvdHRsaWViIDxtYW9yZ0BtZWxs
YW5veC5jb20+DQo+PiAtLS0NCj4+ICAgaW5jbHVkZS9saW51eC9uZXRkZXZpY2UuaCB8ICAzICsr
Kw0KPj4gICBpbmNsdWRlL25ldC9sYWcuaCAgICAgICAgIHwgMTkgKysrKysrKysrKysrKysrKysr
Kw0KPj4gICAyIGZpbGVzIGNoYW5nZWQsIDIyIGluc2VydGlvbnMoKykNCj4+DQo+PiBkaWZmIC0t
Z2l0IGEvaW5jbHVkZS9saW51eC9uZXRkZXZpY2UuaCBiL2luY2x1ZGUvbGludXgvbmV0ZGV2aWNl
LmgNCj4+IGluZGV4IDExYmRmNmNiMzBiZC4uZmFiYTRhYTA5NGU1IDEwMDY0NA0KPj4gLS0tIGEv
aW5jbHVkZS9saW51eC9uZXRkZXZpY2UuaA0KPj4gKysrIGIvaW5jbHVkZS9saW51eC9uZXRkZXZp
Y2UuaA0KPj4gQEAgLTEzNzksNiArMTM3OSw5IEBAIHN0cnVjdCBuZXRfZGV2aWNlX29wcyB7DQo+
PiAgIAkJCQkJCSBzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2spOw0KPj4gICAJaW50CQkJ
KCpuZG9fZGVsX3NsYXZlKShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KPj4gICAJCQkJCQkgc3Ry
dWN0IG5ldF9kZXZpY2UgKnNsYXZlX2Rldik7DQo+PiArCXN0cnVjdCBuZXRfZGV2aWNlKgkoKm5k
b194bWl0X3NsYXZlX2dldCkoc3RydWN0IG5ldF9kZXZpY2UgKm1hc3Rlcl9kZXYsDQo+PiArCQkJ
CQkJICAgICAgc3RydWN0IHNrX2J1ZmYgKnNrYiwNCj4+ICsJCQkJCQkgICAgICBpbnQgbGFnKTsN
Cj4gSGV5IE1hb3IsDQo+IFNob3VsZCBsYWcgYmUgbmFtZWQgZmxhZ3M/DQo+IEFsc28sIGJldHRl
ciB0byB1c2UgdW5zaWduZWQgdHlwZSBmb3IgaXQuDQoNClllYWgsIHdpbGwgY2hhbmdlIGl0Lg0K
