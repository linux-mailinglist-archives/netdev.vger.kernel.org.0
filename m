Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20AC416B90
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 08:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244186AbhIXG0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 02:26:11 -0400
Received: from mail-eopbgr1400105.outbound.protection.outlook.com ([40.107.140.105]:40224
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244176AbhIXG0I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 02:26:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rag5YDtA0il7oI3ASVF04a5akSZFt3Qxd2kz25keFKfUpYvC/a6SV56zzkiKw99xLzQgPz/lgUB1g3ZItDJY3tw81RUpwS1w8ipkMS7hQrYZOSL56vQZW5r0Cwjs7u4aoIjyPMzW/jrOHpk3yO9rb8E+Q6krCIuBRahWj81RvAtfpOHd7yonrBVLS47u7R9ttuTlW1ZflDc/VCmUKoyoX1wRGRcQj/lQHyBHw3183I2qr7HiFIyf0FrkziJ308YZ+J5j4oImFcV880rtqRd0aR1EWM0AL9piHLwdFeQQ99VL7vvluz0eyLwXRbc4x6/x+xrTiz4Rd2IJqi52xC7UGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ubUcEsfcCB+nd3FvS/r47BUGzuaqXxYH26l+WUNAQWY=;
 b=JpCkztGCb+D8eiBfLkMJbQR1peN/JVax1gkxt0pPa+1dqbHTim4IsAxtVj1jsqfMNrzRBbu5luKxNXwYplf2UW/+ekLs/frY3Zjc2viVK2sSRGTis1fi5VENUzjWMInHwQv9wVnR4ZdxQJEuLBv/xycPRN9kMCufBhLsuKFauGYrV0PE67HW0I7Aj0frnlr7MwMkgBGmMA66Vv4ioQfEfnZIH19FWyOW7ujJvsa7MCWKd7vCCpBfSISTiNsYeU6dLBBDC4ucIcCoF4vd7+3o1JBxA27HnMPJGj+4kvN217qO+aJnQbrDZQ49ItYOC7oEREMtVTk8Dvf3/evqgv4Udw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubUcEsfcCB+nd3FvS/r47BUGzuaqXxYH26l+WUNAQWY=;
 b=Vtl8LfRSWtyWkETCOVVhHUXPVlFB7VwCNlZ0usZhUBnEfR0MrxLfVD4ovS3w+N9d++JwijRifPop7IiVhJpvjJ5ZBTP8SFS0s2Pezwv2ndYj2QICtSMlafFEnmgD3+ROQeZcF87LRhCXB/4qkX3nwTQ4vnGfBsfrQ1+Clf/ICaA=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB6967.jpnprd01.prod.outlook.com (2603:1096:604:120::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Fri, 24 Sep
 2021 06:24:34 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097%9]) with mapi id 15.20.4544.018; Fri, 24 Sep 2021
 06:24:33 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC/PATCH 07/18] ravb: Add magic_pkt to struct ravb_hw_info
Thread-Topic: [RFC/PATCH 07/18] ravb: Add magic_pkt to struct ravb_hw_info
Thread-Index: AQHXsISFpoqrwDdNgk21tf8nTdCLNKuyFfWAgACha9A=
Date:   Fri, 24 Sep 2021 06:24:33 +0000
Message-ID: <OS0PR01MB5922800C5282BDB42985A11286A49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-8-biju.das.jz@bp.renesas.com>
 <6bb4004f-2770-b67e-10ce-a438cb939148@omp.ru>
In-Reply-To: <6bb4004f-2770-b67e-10ce-a438cb939148@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1c21193-0de1-4e43-1f42-08d97f23f9b8
x-ms-traffictypediagnostic: OS3PR01MB6967:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB6967E4D24D0764168B0C3FC386A49@OS3PR01MB6967.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VFLHQH/+vwHtTnzArk3HayNUif00G1R3Hb/Ghma+Q1PXG1T2FtSOfCw2dWkuDdMIvwbste5B8wcb4vOjnMKv1zH0reaiZTMrkMwBL9Z5Mcequf8XlYRN9Hm3M4VqsSY1qB9ud6GZrbdXlUwKBIt9yS8/B+YkndsTcgw6vFVeyVgVf1MNRE8yIWNWA8y4UJvIEvvcALGWhq3rwQXrEXkrjEy37Pffs49lZujA/k23BLedxmSDg9dqG2TgkpokKMrDLUztfYTgP9gg9R+z/rTnfIpvM0TbK1qnX1+WHeOThIt/HZvBfrYOY0lYdoDnT+CMMqoa+aPidQuRN8pzNESAwlKIieNskksly3KvD6UbwKoikD4DeYUr9kZNmRwc7l2l179y+H3RBQnXcReMYgK1cQb/yzBfp9cMzFuUYJtDhzereomtjqP2FrUPIV+/CUo2I+EI1FVOycHdZfVDepBMp7/0dglheMMid6xDfvcIDVMq+hJVTvgjsBw/sNKJHkrKgYup9rXTH8r4u/HAvbGiFwS1P6ah1VuUKMgV86pBpFS1z3K9DLpc+K5JU7nDOhTZz3jR8PaLqNc2DB27s1t809Hyh8KguqTdUIOq2fzgWUhQTCvp1JtKZULP+L33OImp0/LDZu1PsOGkjxXVjF2iFpMqC+qXSjubnoDBuJ6JH9sL/pHz3P5p+3iuA7nDmQNn1YkAnR8lHwNnsuYvTRYqNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(107886003)(8936002)(33656002)(83380400001)(76116006)(52536014)(110136005)(122000001)(38100700002)(5660300002)(186003)(9686003)(6506007)(55016002)(64756008)(66446008)(38070700005)(66556008)(4326008)(66476007)(66946007)(508600001)(316002)(7696005)(86362001)(71200400001)(53546011)(8676002)(54906003)(2906002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dTg4R2l5TE5oK09JRmdPUnNrM3d1eUlWNVk4OThzR1kvVWVPM3dsZDhpUVBi?=
 =?utf-8?B?V3VWTzZlV2FtamhrN3l5QjF0VGEwYmFMaWJ1NUI5dlBFK25lZjU0UDhBWGsw?=
 =?utf-8?B?eFgvSWM3U2xCY3ZoU3gwWTA4RXlQYlZoM0MzUXZDUjFUSHFpZjRCaUFyUWZY?=
 =?utf-8?B?YThyVzJwSDhtRlFMTWRGdkh5VEF6RjYrUzdPcXpiaEhxUmZWeFA5Mm05WitN?=
 =?utf-8?B?TjFRMEd0cDZwRmxpeml1eWhmUHVyMm92RllLRkVzZXZXYkZMQWtmWVdoaVU0?=
 =?utf-8?B?VERIemU4bWlWcUxnK0JBQ0ZvNFRCVTg0dnp6V29DQ3RHWTFyREFIeHc3aTJI?=
 =?utf-8?B?RFE5MTNHc2JiN3ZteHNmS1hucUdlOVlEZUpsWG9nRlZUcGdVbm82azJ3TU9T?=
 =?utf-8?B?NGZmaVJ0SnltUG1UdXA5dzJ6aSswM21YV2c0NlBzOEwvNHl2S1JFb2svT205?=
 =?utf-8?B?ajlZRlYwUmVMRng3QndIZlJTd3pKdW95dVA1aVdRd1lRODdMempVZ0xqRXZX?=
 =?utf-8?B?Y1E1WFRTVVBpNVIvVENQUURaLzNUUDZReHM3a0Y0VFRFYmIrc2hlKzRBZWtZ?=
 =?utf-8?B?NjlOUzFrMDZ0bkJaa1JyNXdKVndwdlZPT2MwN1pPVC9JTTZZMGxLY1RuTTNr?=
 =?utf-8?B?aDdsWTU3TDVvME1EN1lDcjAyY1dWZkdLUnZaRjBqRUVZVGpIejZEVTRYSTBS?=
 =?utf-8?B?R21YVUd0NjFWTS9tR2g0ZHZXZnFpK0R3eDE3TWVSZ3VUeHVKZmdXWWtzZGJx?=
 =?utf-8?B?M1VsWldzYlU3ZHgvODh4bk8rUjhkdGJQWHRBcXVFUGRiNkpMQU1COW9QWFV0?=
 =?utf-8?B?R1dLV01HVUFVbzk3ZGNSRk9tanNDTzNPakFaeXpTY2U1aWErTTk4ZzV4enY3?=
 =?utf-8?B?NjM3VTNQcGJRUnNJeWNnWVorZEtGSmd0Q0dWa05CTnN3VWgrNC90LzZmUUZW?=
 =?utf-8?B?dkkxQnZOaCtUazRqQm1sZkZTR24vYVprN1hhZFhydWFmZzR5azZ3bU1mQW5K?=
 =?utf-8?B?bEZoUW55L2FDOEVNdlBzRk5tT2RIL0FmMER2THBFdzlNbGFWSkwwV3o3bTM0?=
 =?utf-8?B?T3E3YmJNL3NJL3B0ZlJQZzE0UDVQenlnZDB6SElyYkdodlBaemZLdE4yVjRW?=
 =?utf-8?B?OUpBcGtGaEdSYnFjODVYSzRXeEtmbnlmVGM1Y2NKZjdoWG4wWW5KNEJoc0M4?=
 =?utf-8?B?c2tPMG43VHRjTmpEWXZxV2tTOEFFUWFQQlIyQkJhY3pDVHZmVE5LNzBkdUNU?=
 =?utf-8?B?NkN3ZCtTMXhKUUxVYWZjUEJBQy9aVVdqY3hpUGJUcXRNTkNpeEhWTUhhNkRS?=
 =?utf-8?B?MVd1RDZEOHJSQXgvQ2JQUERFdTJ5bEFzUS9jYVFiUlgyN3lkVHdIUksvR0VI?=
 =?utf-8?B?d1djRVVWNWZFa0tneXpEZTRLdFZNQmNrREJtcmxoeXo4NVlTV3dpWE1pbzJK?=
 =?utf-8?B?ZWZaNm1jd1JzUWJqTmlteFMrOC9jcnpHQWlNQXZtZXFRMzRVOFhiTmlTQllL?=
 =?utf-8?B?SUhWWkd1d3dRZWc5eEdvc3g5VUdrV3RDL2FBNkpleUMzVnRydW1oREZMRHJ6?=
 =?utf-8?B?Vm5vOC93dnJTY0hmZUg4WndkWmN0VEN4clJSVG9UYnpiUlI4empWa05QQ3N5?=
 =?utf-8?B?VWRRbXNmcEQyN2VFVGVITjMvOHdkWVpVLzNtNndjam41eXBRWnoxalM5dXgy?=
 =?utf-8?B?OFdIdHNleExJWjFKUEdDRkxNVFNNYVBFQk1LUHZHV2hBZVRqYXdnNnRxWVRJ?=
 =?utf-8?Q?jmDt44GMGw3OHe+7kEl83PbQFOgvDZVinO1FcYQ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1c21193-0de1-4e43-1f42-08d97f23f9b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2021 06:24:33.8517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c8iJd3+GHI3eLWg2LDCLju+Bc1h8ceTEi+U+zkstfmt6D8D1MbAlD2sF7b8V5GFPmjaYK+CZO2c73AEA2pP2HEtOf/b8sLdNp+yJPMX0TyU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1JGQy9QQVRDSCAwNy8xOF0gcmF2YjogQWRkIG1hZ2ljX3BrdCB0byBzdHJ1Y3QgcmF2Yl9od19p
bmZvDQo+IA0KPiBPbiA5LzIzLzIxIDU6MDggUE0sIEJpanUgRGFzIHdyb3RlOg0KPiANCj4gPiBF
LU1BQyBvbiBSLUNhciBzdXBwb3J0cyBtYWdpYyBwYWNrZXQgZGV0ZWN0aW9uLCB3aGVyZWFzIFJa
L0cyTCBkbyBub3QNCj4gPiBzdXBwb3J0IHRoaXMgZmVhdHVyZS4gQWRkIG1hZ2ljX3BrdCB0byBz
dHJ1Y3QgcmF2Yl9od19pbmZvIGFuZCBlbmFibGUNCj4gPiB0aGlzIGZlYXR1cmUgb25seSBmb3Ig
Ui1DYXIuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAu
cmVuZXNhcy5jb20+DQo+IFsuLi5dDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcmF2Yl9tYWluLmMNCj4gPiBpbmRleCBkMzdkNzNmNmQ5ODQuLjUyOTM2NGQ4ZjdmYiAxMDA2
NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+
ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IEBA
IC04MTEsMTIgKzgxMSwxMyBAQCBzdGF0aWMgaW50IHJhdmJfc3RvcF9kbWEoc3RydWN0IG5ldF9k
ZXZpY2UNCj4gPiAqbmRldikgIHN0YXRpYyB2b2lkIHJhdmJfZW1hY19pbnRlcnJ1cHRfdW5sb2Nr
ZWQoc3RydWN0IG5ldF9kZXZpY2UNCj4gPiAqbmRldikgIHsNCj4gPiAgCXN0cnVjdCByYXZiX3By
aXZhdGUgKnByaXYgPSBuZXRkZXZfcHJpdihuZGV2KTsNCj4gPiArCWNvbnN0IHN0cnVjdCByYXZi
X2h3X2luZm8gKmluZm8gPSBwcml2LT5pbmZvOw0KPiA+ICAJdTMyIGVjc3IsIHBzcjsNCj4gPg0K
PiA+ICAJZWNzciA9IHJhdmJfcmVhZChuZGV2LCBFQ1NSKTsNCj4gPiAgCXJhdmJfd3JpdGUobmRl
diwgZWNzciwgRUNTUik7CS8qIGNsZWFyIGludGVycnVwdCAqLw0KPiA+DQo+ID4gLQlpZiAoZWNz
ciAmIEVDU1JfTVBEKQ0KPiA+ICsJaWYgKGluZm8tPm1hZ2ljX3BrdCAmJiAoZWNzciAmIEVDU1Jf
TVBEKSkNCj4gDQo+ICAgIEkgdGhpbmsgbWFza2luZyB0aGUgTVBEIGludGVycnVwdCB3b3VsZCBi
ZSBlbm91Z2guDQoNCkFncmVlZC4NCg0KPiANCj4gPiAgCQlwbV93YWtldXBfZXZlbnQoJnByaXYt
PnBkZXYtPmRldiwgMCk7DQo+ID4gIAlpZiAoZWNzciAmIEVDU1JfSUNEKQ0KPiA+ICAJCW5kZXYt
PnN0YXRzLnR4X2NhcnJpZXJfZXJyb3JzKys7DQo+ID4gQEAgLTE0MTYsOCArMTQxNyw5IEBAIHN0
YXRpYyB2b2lkIHJhdmJfZ2V0X3dvbChzdHJ1Y3QgbmV0X2RldmljZQ0KPiA+ICpuZGV2LCBzdHJ1
Y3QgZXRodG9vbF93b2xpbmZvICp3b2wpDQo+IA0KPiAgICBEaWRuJ3QgeW91IG1pc3MgcmF2Yl9n
ZXRfd29sKCkgLS0gaXQgbmVlZHMgYSBjaGFuZ2UgYXMgd2VsbC4uLg0KDQpJIGRvbid0IHRoaW5r
IGl0IGlzIHJlcXVpcmVkLiBGcmFtZXdvcmsgaXMgdGFraW5nIGNhcmUgb2YgdGhpcy4gUGxlYXNl
IHNlZSB0aGUgb3V0cHV0IGZyb20gdGFyZ2V0Lg0KDQpyb290QHNtYXJjLXJ6ZzJsOn4jIGV0aHRv
b2wgLXMgZXRoMCB3b2wgZw0KbmV0bGluayBlcnJvcjogT3BlcmF0aW9uIG5vdCBzdXBwb3J0ZWQN
CnJvb3RAc21hcmMtcnpnMmw6fiMNCg0KDQpSZWdhcmRzLA0KQmlqdQ0KDQo+IA0KPiA+ICBzdGF0
aWMgaW50IHJhdmJfc2V0X3dvbChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwgc3RydWN0DQo+ID4g
ZXRodG9vbF93b2xpbmZvICp3b2wpICB7DQo+ID4gIAlzdHJ1Y3QgcmF2Yl9wcml2YXRlICpwcml2
ID0gbmV0ZGV2X3ByaXYobmRldik7DQo+ID4gKwljb25zdCBzdHJ1Y3QgcmF2Yl9od19pbmZvICpp
bmZvID0gcHJpdi0+aW5mbzsNCj4gPg0KPiA+IC0JaWYgKHdvbC0+d29sb3B0cyAmIH5XQUtFX01B
R0lDKQ0KPiA+ICsJaWYgKCFpbmZvLT5tYWdpY19wa3QgfHwgKHdvbC0+d29sb3B0cyAmIH5XQUtF
X01BR0lDKSkNCj4gPiAgCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+ID4NCj4gPiAgCXByaXYtPndv
bF9lbmFibGVkID0gISEod29sLT53b2xvcHRzICYgV0FLRV9NQUdJQyk7DQo+IFsuLi5dDQo+IA0K
PiBNQlIsIFNlcmdleQ0K
