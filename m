Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DE13DFF18
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 12:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237501AbhHDKJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 06:09:10 -0400
Received: from mail-eopbgr1400105.outbound.protection.outlook.com ([40.107.140.105]:35376
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237472AbhHDKIs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 06:08:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7tr5+0Zwps3k+duCKb/C2l2OQCI6Xv7IPqf1qriNeZxKEVmPlwiM2eT/ZJDAWCjiXIYmY0CJjlZoPsCEoiikvw5u9D8PA2rM9+auffXR2KBcemlc+AwLDd3EUYoaUC0e46m4k+2XT7Vgk/GLapxOMu+RzcXO3de4PKhk8suPok87cYqzqgoBS/n8aY56p6SakkGrEH7gqZXYSWuv8P40u8ItegcntTfOERepOdslpBtW7falo/oWnjfYyAQy0+6uOkx5AdJvzLQgtjZuh2up0RgxgCSVyK6zg40qA5YfkKOPVh4wHOwZ53XzGIxuH+9P7I+y8EUZlOPRVOBT1Clkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OerD7Owmij73Zi7nm/4p/Gt8NtJUoG3PQhgmcFIOLoQ=;
 b=b3T3tmgNalQqdUHogjkE64tOdJOihZ4o4CUqTVmq7RGvAZaKkJl4VoCZ2+oMEMBPw1+1qPSyue/t56ddlimiXRwMQPVCZcbBNFHTDfwSvZZKkOD0919S4BqX4unCKcgrtv+prxj8IusnW+Vl/gpbWmTZ2hS8HgN5mCiruGojBDlds5WuoD3UHesK3pKI3XxxIpslKBqkaF6ERfMuC1Z/K4h1bw174RxohrZ1/zAHSqCHvG1Ve8jyVou1mR4JeB51WM43dX6XTuKQbB2BUwzCrGxSfht7+YKouaWea+wc46wayDYxCcgZXl1hD5NhhiB3V0LZjJ7U/xyAnngFNcCyow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OerD7Owmij73Zi7nm/4p/Gt8NtJUoG3PQhgmcFIOLoQ=;
 b=ZEOEUCvBDW4lBKS62sphj+sbhv8FFNYNIzD34wAbQcwKxG7XffqckDkpyEW1r+MRGwa/X0XCWr17i2ZGgxtHUBguPQMNAZwEAdWVea9s5BWiEY9fTOHNQKzab/2VY0u6I6NyyKs+Y9GadJ/cQaj5lg0jPZmY1dsl47ATu+Jh8pY=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB2134.jpnprd01.prod.outlook.com (2603:1096:603:26::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Wed, 4 Aug
 2021 10:08:15 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%8]) with mapi id 15.20.4373.026; Wed, 4 Aug 2021
 10:08:15 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH net-next v2 7/8] ravb: Add internal delay hw feature to
 struct ravb_hw_info
Thread-Topic: [PATCH net-next v2 7/8] ravb: Add internal delay hw feature to
 struct ravb_hw_info
Thread-Index: AQHXh4kJVg2tFXlcHEytJvY9Z7FsDqtiSZqAgACEk/CAAE9dgIAAAMXw
Date:   Wed, 4 Aug 2021 10:08:15 +0000
Message-ID: <OS0PR01MB5922F0ACBC41881139B3C03E86F19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-8-biju.das.jz@bp.renesas.com>
 <ad727120-3ae6-4db7-e368-f06c82cfa759@gmail.com>
 <OS0PR01MB5922974FA17E6ABB4697B6B986F19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <de0a9df3-11ac-0630-8933-922012b39264@omp.ru>
In-Reply-To: <de0a9df3-11ac-0630-8933-922012b39264@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36b75c53-8f0d-461e-e318-08d9572fc67f
x-ms-traffictypediagnostic: OSBPR01MB2134:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB213458FD7A87F7AB42D42B0E86F19@OSBPR01MB2134.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2GchnvXYde81Jqbu5q3wcgOzxgN3HOkDoMfDcutP9k4kKvLNN2fvkSqj0g7ABpicdRMEoFtWh/nRD7NxONMSLCW5pWMSpcQ8aeSqf0nOTKwoNbBB0hPoi/OE513EaI+KMyO+FG2P00ky7x8URmQIzBg9b9LKDuPbehop6UpDJEMkqKXsvqj3E9epDgSxdXeNrjXyUZYW7IO5mRTwIdOKbtatR7CsGP2Rnj72MWPB0fjRLG3zImI2uCMvDOfEyqZ3PkYreFAiu2uk7kwWuR6w7chEr+aMggFdXLGL/XxZdXVVsi9HakMYEyVEd2tDndwqgf4oF6qZyD/aBCR1xtVZ3/xNnPgSkqkiiojoNl96creuYdGCncAyWlWujIL6ljGsGnPYxqmeN55djr/qFhgASQYUF8ej4UR4xj6TkVCDqlj6SzlVjqT0WybHTLMsWzb6Ehfzolsdn8u3cBeKMiZlpQnoHnBkyeYCqI0oprTgLtABDBn1S9cgQRuYKfTU9+o8i8pHh503pjYB8KFGV3FHVYqMEv8Qw7fHIeCvxXOvIZE/Rty2fbBK5C9xSQECJn2MtjqlYn8rkort3eP+KI/BiETArMeIDmc84gfjmyszdoaBvUnx+XimzAZoDtpsAP8zzzwnI1BEyGtE5sUb/zSTbsj0nQRU6pNJhYdsw1UJnAC/14iYU8urkhXgf5IewfTdPab+UXkoGWXPTYp62fc0cg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(55016002)(9686003)(2906002)(7696005)(26005)(186003)(83380400001)(33656002)(53546011)(316002)(6506007)(7416002)(110136005)(54906003)(86362001)(8936002)(8676002)(4326008)(107886003)(5660300002)(71200400001)(478600001)(76116006)(66476007)(64756008)(38100700002)(52536014)(66946007)(66556008)(66446008)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Sk5ncVhYOHZEc2ZZR1pQRUxJazRCODYxY3JlT2NmcFZ1eU5oZWFjN2pzb3M5?=
 =?utf-8?B?MUU0YWJDeWJBQjAwbG9JTTRjVzRJVDRYRDVsUnhyekZJYnVUd01abVBsczZ6?=
 =?utf-8?B?RzIzUmVydjNZVXJDMzdCWFdrK0wwZllUenJ1RzJENWFQOWc5RXhCMkdEUGRI?=
 =?utf-8?B?emdFcFM4cnFlSDNibGRvQmwvUVhyM3l0UHJScHI2VmpWVFhZVDdLYkwxdWQr?=
 =?utf-8?B?cEtWUEkrY0Zmd0ZkRnpCU25tY0dEZDJPa2JjL3k2Vll5QjJzK0NzNGE2ODRj?=
 =?utf-8?B?Y2J0WGc0emJMV0NINGN6bStOMVVVbFdyOXN0aWR1dHQ5VEoxTXZMdTNBd3lm?=
 =?utf-8?B?b3NEYWh2Y1hMMUQ5UXlscHBsMlJxN0hKOERERnBFTDhLM3I1ZnlRNUl2QlRG?=
 =?utf-8?B?MHRmamp1aVd5bmVQTG1UbXVyeGhMM3dHSXlraDVQMXU2MSswSDYwWUp3bzA1?=
 =?utf-8?B?cDlGdDZDNWtVMTZPUlR1eHlZZ2Z1UTVmbzR0WG9ERGVTQWxvL0JEeHVXUndB?=
 =?utf-8?B?TEFWNHRLSktGeEs4OEtkREtXSUZEbUpDbXVZQUFqQzJueldYNlJNcHNUVVFm?=
 =?utf-8?B?YXdUYmx2SmVGdlFESklJK0tsSlF3eWJtWjdPaHhHOUIzcURVVVpzTVNXUDgx?=
 =?utf-8?B?UGRiZ3RkQUM3ZGVnSy9TQjdjWi9QMXJUNHdXd3ZKcTVJcGdDa3FtN0t2V2VZ?=
 =?utf-8?B?ODAxYVNwSzZJakdzUDNncE1jUUNIdTBtTkdOZE9DUXAra0tIa0ExY0Eya2Zn?=
 =?utf-8?B?L1lDVzZZaHp1NkloTnBEN3hjV0twSDVQWWFpU2VjUEdTMzR5ZFJvQkRDRXRN?=
 =?utf-8?B?ME1WRUZDa05GWTFYUERRaG1FWWlFaldZb1kwRjFnak1YWTduYkQrVmExVmZG?=
 =?utf-8?B?MzRaUGdUWGRCcmpGQkkzdEtSaG12OWpJQ2t5bmZGSGtIckxtbzJmeC90OFpT?=
 =?utf-8?B?SVZEYlY3Ri96dXJjNjBJUkFtYkR2eElsUk1rb1dVQmFQdlYrVkJxY0E3eHFL?=
 =?utf-8?B?WkJORkkwWWxpRVdnejlUUGpIWmhYVXIxdklYTm1MYWd2ejhQWnorblRBQkZz?=
 =?utf-8?B?b0tFMlp4WWN1OWRoSjc1Y1djYnBmZDEvVms5OGRKWUgrQXVXUHFZS3hjZGdQ?=
 =?utf-8?B?RDEyOGU4OHVTbHZOc25VdS9FQVNNN21iNVljbkFrbGpzVkxwTTZneURkcFpV?=
 =?utf-8?B?UnZ0VWJQNWcrVHVyV0x5NklIV25PTFZqTXVPdFo2bUk4aC9RQnpJVUFpYWhF?=
 =?utf-8?B?ZndHWEVxNmExQmxnVGN4ZUlYRU9zR0M5U3Y0TTlSemdaQUJ3a1F4UkM3bjhj?=
 =?utf-8?B?ZjlFUDFRU1lURkZjQjNxbWxpSXBXRVRvUU9ucElDM1lEd093dm1LQ2RmbmJQ?=
 =?utf-8?B?cWJnUGdEL09WaC9ERWVsWGM1Sk13MGRBQ09ZYytYQ29KUzVsdzk2OFNacWRK?=
 =?utf-8?B?dExPOHhjMXFXa1A3K3VTdWFVWllTNy9HS0VIRndHNjR4a2lMTmtlcm5FUkdz?=
 =?utf-8?B?R3NBUytlVlgvTTlVVEVHZEcwTThqeFpMUy9JVm9USVBLbWJUK01Kdjh4Z1ZW?=
 =?utf-8?B?WUZFYmZpbXVyVnBRTXJxZWEzdjI2R1YyRE5NZllEUUlQYnNkbFBrbnFqOGtl?=
 =?utf-8?B?T2FlM1RtdnpJdEo2TXVDUHJMUGtNZlRXUUZldTBkakowMmFQY1BlZzFjQWxu?=
 =?utf-8?B?SHVsaXE5Z2R0cjgzZUFDOUlMRmxCUEQvaEVMOHRvUnlWZWRzTzBhUklXWVVV?=
 =?utf-8?Q?kbRwgENiTBsRfE/54nulPYZ/zWvV4nNCt0bry8N?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b75c53-8f0d-461e-e318-08d9572fc67f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2021 10:08:15.3292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rn9vmi3zPYC5J9HLXoIl1x1chLGmpQbEqEqIdR9n6Xk1wxQaMwS7ZezVGVEUmuoxoTPCSqcO1OBdwlT7ZdO5ffJc6qA8hRpERSfi7YNS3M4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIGZlZWRiYWNrDQoNCj4gU3ViamVjdDogUmU6IFtQQVRD
SCBuZXQtbmV4dCB2MiA3LzhdIHJhdmI6IEFkZCBpbnRlcm5hbCBkZWxheSBodyBmZWF0dXJlDQo+
IHRvIHN0cnVjdCByYXZiX2h3X2luZm8NCj4gDQo+IE9uIDA0LjA4LjIwMjEgODoxMywgQmlqdSBE
YXMgd3JvdGU6DQo+ID4gSGkgU2VyZ2VpLA0KPiA+DQo+ID4gVGhhbmtzIGZvciB0aGUgZmVlZGJh
Y2sNCj4gPg0KPiA+PiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IHYyIDcvOF0gcmF2Yjog
QWRkIGludGVybmFsIGRlbGF5IGh3DQo+ID4+IGZlYXR1cmUgdG8gc3RydWN0IHJhdmJfaHdfaW5m
bw0KPiA+Pg0KPiA+PiBPbiA4LzIvMjEgMToyNiBQTSwgQmlqdSBEYXMgd3JvdGU6DQo+ID4+DQo+
ID4+PiBSLUNhciBHZW4zIHN1cHBvcnRzIFRYIGFuZCBSWCBjbG9jayBpbnRlcm5hbCBkZWxheSBt
b2Rlcywgd2hlcmVhcw0KPiA+Pj4gUi1DYXINCj4gPj4+IEdlbjIgYW5kIFJaL0cyTCBkbyBub3Qg
c3VwcG9ydCBpdC4NCj4gPj4+IEFkZCBhbiBpbnRlcm5hbF9kZWxheSBodyBmZWF0dXJlIGJpdCB0
byBzdHJ1Y3QgcmF2Yl9od19pbmZvIHRvDQo+ID4+PiBlbmFibGUgdGhpcyBvbmx5IGZvciBSLUNh
ciBHZW4zLg0KPiA+Pj4NCj4gPj4+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5q
ekBicC5yZW5lc2FzLmNvbT4NCj4gPj4+IFJldmlld2VkLWJ5OiBMYWQgUHJhYmhha2FyIDxwcmFi
aGFrYXIubWFoYWRldi1sYWQucmpAYnAucmVuZXNhcy5jb20+DQo+ID4+PiAtLS0NCj4gPj4+IHYy
Og0KPiA+Pj4gICAqIEluY29ycG9yYXRlZCBBbmRyZXcgYW5kIFNlcmdlaSdzIHJldmlldyBjb21t
ZW50cyBmb3IgbWFraW5nIGl0DQo+ID4+IHNtYWxsZXIgcGF0Y2gNCj4gPj4+ICAgICBhbmQgcHJv
dmlkZWQgZGV0YWlsZWQgZGVzY3JpcHRpb24uDQo+ID4+PiAtLS0NCj4gPj4+ICAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmggICAgICB8IDMgKysrDQo+ID4+PiAgIGRyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMgfCA2ICsrKystLQ0KPiA+Pj4gICAyIGZp
bGVzIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPj4+DQo+ID4+
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPj4+
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPj4+IGluZGV4IDNkZjgx
M2IyZTI1My4uMGQ2NDBkYmUxZWVkIDEwMDY0NA0KPiA+Pj4gLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Jl
bmVzYXMvcmF2Yi5oDQo+ID4+PiBAQCAtOTk4LDYgKzk5OCw5IEBAIHN0cnVjdCByYXZiX2h3X2lu
Zm8gew0KPiA+Pj4gICAJaW50IG51bV90eF9kZXNjOw0KPiA+Pj4gICAJaW50IHN0YXRzX2xlbjsN
Cj4gPj4+ICAgCXNpemVfdCBza2Jfc3o7DQo+ID4+PiArDQo+ID4+PiArCS8qIGhhcmR3YXJlIGZl
YXR1cmVzICovDQo+ID4+PiArCXVuc2lnbmVkIGludGVybmFsX2RlbGF5OjE7CS8qIFJBVkIgaGFz
IGludGVybmFsIGRlbGF5cyAqLw0KPiA+Pg0KPiA+PiAgICAgT29wcywgbWlzc2VkIGl0IGluaXRp
YWxseToNCj4gPj4gICAgIFJBVkI/IFRoYXQncyBub3QgYSBkZXZpY2UgbmFtZSwgYWNjb3JkaW5n
IHRvIHRoZSBtYW51YWxzLiBJdA0KPiA+PiBzZWVtcyB0byBiZSB0aGUgZHJpdmVyJ3MgbmFtZS4N
Cj4gPg0KPiA+IE9LLiB3aWxsIGNoYW5nZSBpdCB0byBBVkItRE1BQyBoYXMgaW50ZXJuYWwgZGVs
YXlzLg0KPiANCj4gICAgIFBsZWFzZSBkb24ndCAtLSBFLU1BQyBoYXMgdGhlbSwgbm90IEFWQi1E
TUFDLg0KDQpCeSBsb29raW5nIGF0IEhXIG1hbnVhbCBmb3IgUi1DYXIgQVZCLURNQUMgKEFQU1Ig
cmVnaXN0ZXIsIG9mZnNldDotMHgwOEMpIGhhcyBURE0gYW5kIFJETSByZWdpc3RlcnMgZm9yIFNl
dHRpbmcgaW50ZXJuYWwgZGVsYXkgbW9kZSB3aGljaCBjYW4gZ2l2ZSBUWCBjbG9jayBkZWxheSB1
cCB0byAyLjBucyBhbmQgUlggQ2xvY2sgZGVsYXkgMi44bnMuDQoNClBsZWFzZSBjb3JyZWN0IG1l
LCBpZiB0aGlzIGlzIG5vdCB0aGUgY2FzZS4NCg0KUmVnYXJkcywNCkJpanUNCg0KDQoNCj4gDQo+
ID4gQ2hlZXJzLA0KPiA+IEJpanUNCj4gDQo+IE5CUiwgU2VyZ2VpDQo=
