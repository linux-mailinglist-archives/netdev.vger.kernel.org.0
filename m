Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E32542391D
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 09:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237582AbhJFHpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 03:45:54 -0400
Received: from mail-eopbgr1410111.outbound.protection.outlook.com ([40.107.141.111]:49024
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237508AbhJFHpw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 03:45:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEwlLWbyAuKK6NvzD23IzHvy/0d89yHho+HGwWWW/KHlM52fhdtKqYfuC735+A7Q3jxQYtwGjx35mZcsRUiyzb9nZksOaZij3J5QSROWEEAm3fjXw8LfHeuNjUW+4R3xGrKQF++tuJ9k4QoUGKEji2DuZqh7EvHqXiLCSYtxfWOjIv6IEf5QzmrRJsflvXBLZqHMcPfWC8m0v15BEm6KrvslGNGp7DTZjo/X9DQ8IdQiDwk/aQHSBZ+2UU50CpngWvsl34duYsayFQM3uoXEL2a6JxYYwO7IXdW6DzXBl52zQLcwQsjpcAFexE6GaU4y6WWJfaXOI9L5f8qXaJY28w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a25mplLVkMFMGLLiN7r/zpFdAdpIGxMQqCuqPhQr5Zo=;
 b=eatqf0LgT0N5pTCuBvZTpo/6LJlzvtXPu7TRnM80JkA2sUhdkmhzNSoRpTO3QAZl3HfkFmjQPZNJsHKaXdwIBUbhs8hj2jc/35Z61CZF36xAr6EXK4r+wQqWmlfL4BQd9ii4Qb3J4gaykfC61nEJ8qD9MvRazXvHzr901rhRbCWIR9yf4HUBtKQaGTCkHKlNhDUJnrsags/PJji+ViFPyAkjxiNyWgOImvnaxI3AM9I3UuFtgR5z4aMR1LJHTSIejr66HdQDxLRJW169nAm+7/F4CWzN0BsV8xTCbnPTdN/gGbQGR7USBL9SPtVlvVWz03er8G4MFzz3AZB/xk+BTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a25mplLVkMFMGLLiN7r/zpFdAdpIGxMQqCuqPhQr5Zo=;
 b=bDGMu8T20kHpl5Y8GWDXhjN++ydHYw/4bY7BMmkRFfDlDcJ1RnBYp77zERdXnwpjE/gUeqhbbn9rOkvb6gR0/U6Pjep+AK5+EARL+hzt+hfrStdmgDuaIWFgmaPdmomHI+v0ChuTPJ1XbJefHeFKtbA5k6DFzIeHATTrEgOmNKQ=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB4081.jpnprd01.prod.outlook.com (2603:1096:604:31::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 6 Oct
 2021 07:43:56 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.018; Wed, 6 Oct 2021
 07:43:56 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
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
Subject: RE: [RFC 03/12] ravb: Fillup ravb_set_features_gbeth() stub
Thread-Topic: [RFC 03/12] ravb: Fillup ravb_set_features_gbeth() stub
Thread-Index: AQHXudkfXI2W6zxlnkCipKWTBPO9NavEwo2AgADUVkA=
Date:   Wed, 6 Oct 2021 07:43:55 +0000
Message-ID: <OS0PR01MB59223E020F4AEE30CD13F9E786B09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-4-biju.das.jz@bp.renesas.com>
 <17eb621c-05f8-155b-24ed-5445f445c6ce@omp.ru>
In-Reply-To: <17eb621c-05f8-155b-24ed-5445f445c6ce@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1da2ce08-e21f-4ba1-2d31-08d9889d0d1c
x-ms-traffictypediagnostic: OSAPR01MB4081:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB40814D39167E9DEC7C78125986B09@OSAPR01MB4081.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y3nrS1WxD57ng5u95FAVmurFY+UGyjf2Mw73UY2LDjE2z1xBCoFbtVtbLUdiweVXgbCUvdDSjoOAsVIEvYnsQlc6cgXRg0dMEVbpX2zs0sJaMzSdQBhzZ2YAQs9MbW2W2TDlHEEL+VzWDvS/FX9hiNPz5UALIH+FzTCICkR13yk8Hx5KoTVcliekZOvVR5Q6bvZRMUPbYu/3ZtjBHgM+jgZENqFDD1/7/v8s51isBXWVvRqypYqDgjXjhjoS02FN4VVMaXx7vuEgnewADgN4dbac32PtTJrC0DYeABZHghD4vld7MGs+nJbL1Y9u+B/LPHWkg/TcocZaWCOZWj3O2g/ZcT6vrmecWuCWnwEAV0XLyvXe5xexV0dmRapRgps/t3tWh1ZlG3EyPt/hjQNZgfAwufwx1OvwvHY9mIBfHCXseZFINMtHax/mP5ZmQ8TAnSgLziFgjZsT3aZR7UJxAiwlzAwtKUFUpuJEK9Ijv+wEquekUmz2+LtSZSauWf264RAPnUpk0c08RvqoFmNn1aLalLUoBcHo5BUX3z7imZJ80GVyuER4hDVWIkq6hZ7T6PIDLS1tzkfdK38RzvfV6DuJdxOZXZUIiwjL3SgHE/gq/wbmPr/Z8WksfILSiBo4Koyf/TTeWb+3z3Tty30jJhkeBTu1I6AwheHYmEhJnZgu98zSzqr6NUt6SzDCyhIZOgX/MBNW1Um+em9qR0VXng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(66556008)(76116006)(4326008)(66946007)(66476007)(107886003)(64756008)(186003)(33656002)(9686003)(66446008)(55016002)(86362001)(52536014)(26005)(316002)(38100700002)(8936002)(8676002)(122000001)(38070700005)(2906002)(53546011)(110136005)(5660300002)(6506007)(71200400001)(7696005)(54906003)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?anI1YTkwSDNrZnloQmQvM2ZvaC9wYkhRdVdIdjNURFNSWG5GdndHZDRqaW9v?=
 =?utf-8?B?bkdvYTdrdmtFejIzQlhUbHljVC92VTFGRTYxN3Bwa1RINXdGdkZycDRsV0RI?=
 =?utf-8?B?dFViblloSkV3T0dmekFKcGVIWWhCeldYV09ocTlKbVFaeHNPR01iNlE1cnZG?=
 =?utf-8?B?Ry8ycUUzellmTFlxNzRVM29XSXE5UkgrZmNCd2FPUGpnSjZGbjZSZFdvSFVV?=
 =?utf-8?B?emVIdkdQOEFHSmZrOGdlVEFObjhDQXZudHF5bkF0OW5RWHlyRytidjd6M1p1?=
 =?utf-8?B?cWVlVjBZcFZ0VkZVZjRkNE9GMTl0MjBRTmpnQ2Q5Ymg3Q1JBL3daWU9mc1Ft?=
 =?utf-8?B?Mm9MVlZ2WUNCZU5BbnJ2NFQzc1kzdGprWHAxVWdwM2hPU245NmNZeXZFVTBG?=
 =?utf-8?B?ZjlRdGlPRUVxa2NHc09UWmVtY09jdkNLS2VkRHVKWHBDVGRUQnFPUVd4QnJq?=
 =?utf-8?B?V2VXSlZGRXJ2MnhEQVl5Q1NTeDQvQ1dFaEp2eGxWNGlRWW0rdncxUVhYeGtl?=
 =?utf-8?B?MCtwM0U1dmZjelpzalZlaDdGT1NsWG9MMGdsUUFVUTlEWVdxbGR6cUlnYVVJ?=
 =?utf-8?B?NmR4OWJyRDVhVURpdGY2eFJrSjJtbXliSzZEaCttZ1c4cVRRTXZhYk96YlNv?=
 =?utf-8?B?cURPUmZpTlhROVZOV3RDbU5KQW0wRnBsa3RCMitEdG5zTGhFbk9mZnk2cnhh?=
 =?utf-8?B?TEhRYTIrQ3dGdCtGRjU4QnhDYlRHeUlhdnNXeFdDVTVUTk5rMEdiUXF6RmtE?=
 =?utf-8?B?YlU1a1FUY25DK2JYZ2ZXUFBBcU1wZkx2dG82YVJCUEl0VTU4eEVXK1dCdGRQ?=
 =?utf-8?B?bFNoSzU2TXdaMlFHZCtxL2dxYlF2RlZpS2F4RnE0NnNPMHl5eDBRaWhwam50?=
 =?utf-8?B?ODNSSER3Nm55MnNPTnNXb1Z1OE9sNkhqbmdyZGJmOUNQS2lONWdHUnpxMnA3?=
 =?utf-8?B?aHFIUzlGNEJzM3FLUjVvQUliR3ZKYU4yL0gvVUNLdHA2Nklxdm9UOFNwRXR2?=
 =?utf-8?B?UnpwbTlERHpoemU5SDc4RjNzN1Uxb1lkZThPM0lKb2FtWi9GMzlTY2xJWkln?=
 =?utf-8?B?Zno1SFNxMWxCQTd4ME1QMU1nMitSWHl6ZytKR0c1Y2gyR3FoOWpTT0YxOHlK?=
 =?utf-8?B?cTg5ZkZxeTVsdXJ4K0VFNEVOQ2s1U0dCWDBJY1JiRHFjTnhqUTltSVZkREhs?=
 =?utf-8?B?V2FNc05GSlFtcHQyTXR6eUdmeGt2QlkrOUdwMXdhR0V4T25scEQ1MVpqQWR6?=
 =?utf-8?B?TjFIQWNuYWRaSzJOUERYaWdKOFMvejd3QVVHMFJGOG5FQUYwYURNU1FoUHY4?=
 =?utf-8?B?RGp2TUlPdHdLZXN4c0xDMUphNGNNQ1cwbVdTTWVqaTJnUC9IZnN3ZUZYY2VE?=
 =?utf-8?B?YXV2dm1zeUZmQ1JmMWtLMzZQZmNXZGsvZ3Z1VzhNYXdodlkyWklTT3lDWXNC?=
 =?utf-8?B?VUQyUVhMMDNicm1KVU9jZlZjZXRGQzlyNUdQVzQzZXhiK01DNVFrNEJ2U1hq?=
 =?utf-8?B?elRtQytacis4TEd1cEZvaVZwZ29qOGd4Y2hHVjdXWC93eWhTeWlacVBPU0Fj?=
 =?utf-8?B?RlY5cURTRnZ5eG9jN0RYYlBKb0VDdmdrY2RYYk9HM1FzelJxTzR0dXh1NW1p?=
 =?utf-8?B?eHZBZWdHZktyVE5MSWlLc1hpOFZQai9hN2tWZkVKbUtZQ0FlbGlFQUtzb0Ft?=
 =?utf-8?B?SjVZY0dTclM4dG5tTWtNelNRN3JhNGNlTG1FbU1KNUxSTVkzbmhWSHNvY3cr?=
 =?utf-8?Q?9EqYFmcIlYmFXqlebU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1da2ce08-e21f-4ba1-2d31-08d9889d0d1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2021 07:43:55.9634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RRJx2Ro4IKS9hGIdl5v90rHj5qAOpbKpKPccqbhLXgykVEwO3G8DkR1+9Fbnjvh/cBlwYQYQO/4iZxSBCurLSjwMUDi2ddEDNRkcWufFW9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1JGQyAwMy8xMl0gcmF2YjogRmlsbHVwIHJhdmJfc2V0X2ZlYXR1cmVzX2diZXRoKCkgc3R1Yg0K
PiANCj4gT24gMTAvNS8yMSAyOjA2IFBNLCBCaWp1IERhcyB3cm90ZToNCj4gDQo+ID4gRmlsbHVw
IHJhdmJfc2V0X2ZlYXR1cmVzX2diZXRoKCkgZnVuY3Rpb24gdG8gc3VwcG9ydCBSWi9HMkwuDQo+
ID4gQWxzbyBzZXQgdGhlIG5ldF9od19mZWF0dXJlcyBiaXRzIHN1cHBvcnRlZCBieSBHYkV0aGVy
bmV0DQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVu
ZXNhcy5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IExhZCBQcmFiaGFrYXIgPHByYWJoYWthci5tYWhh
ZGV2LWxhZC5yakBicC5yZW5lc2FzLmNvbT4NCj4gWy4uLl0NCj4gDQo+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBpbmRleCBlZDAzMjhhOTAyMDAu
LjM3ZjUwYzA0MTExNCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5l
c2FzL3JhdmJfbWFpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiX21haW4uYw0KPiBbLi4uXQ0KPiA+IEBAIC0yMDg2LDcgKzIwODcsMzcgQEAgc3RhdGljIHZv
aWQgcmF2Yl9zZXRfcnhfY3N1bShzdHJ1Y3QgbmV0X2RldmljZQ0KPiA+ICpuZGV2LCBib29sIGVu
YWJsZSkgIHN0YXRpYyBpbnQgcmF2Yl9zZXRfZmVhdHVyZXNfZ2JldGgoc3RydWN0DQo+IG5ldF9k
ZXZpY2UgKm5kZXYsDQo+ID4gIAkJCQkgICBuZXRkZXZfZmVhdHVyZXNfdCBmZWF0dXJlcykNCj4g
PiAgew0KPiA+IC0JLyogUGxhY2UgaG9sZGVyICovDQo+ID4gKwluZXRkZXZfZmVhdHVyZXNfdCBj
aGFuZ2VkID0gZmVhdHVyZXMgXiBuZGV2LT5mZWF0dXJlczsNCj4gPiArCWludCBlcnJvcjsNCj4g
PiArCXUzMiBjc3IwOw0KPiA+ICsNCj4gPiArCWNzcjAgPSByYXZiX3JlYWQobmRldiwgQ1NSMCk7
DQo+ID4gKwlyYXZiX3dyaXRlKG5kZXYsIGNzcjAgJiB+KENTUjBfUlBFIHwgQ1NSMF9UUEUpLCBD
U1IwKTsNCj4gPiArCWVycm9yID0gcmF2Yl93YWl0KG5kZXYsIENTUjAsIENTUjBfUlBFIHwgQ1NS
MF9UUEUsIDApOw0KPiA+ICsJaWYgKGVycm9yKSB7DQo+ID4gKwkJcmF2Yl93cml0ZShuZGV2LCBj
c3IwLCBDU1IwKTsNCj4gPiArCQlyZXR1cm4gZXJyb3I7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJ
aWYgKGNoYW5nZWQgJiBORVRJRl9GX1JYQ1NVTSkgew0KPiA+ICsJCWlmIChmZWF0dXJlcyAmIE5F
VElGX0ZfUlhDU1VNKQ0KPiA+ICsJCQlyYXZiX3dyaXRlKG5kZXYsIENTUjJfQUxMLCBDU1IyKTsN
Cj4gPiArCQllbHNlDQo+ID4gKwkJCXJhdmJfd3JpdGUobmRldiwgMCwgQ1NSMik7DQo+ID4gKwl9
DQo+ID4gKw0KPiA+ICsJaWYgKGNoYW5nZWQgJiBORVRJRl9GX0hXX0NTVU0pIHsNCj4gPiArCQlp
ZiAoZmVhdHVyZXMgJiBORVRJRl9GX0hXX0NTVU0pIHsNCj4gPiArCQkJcmF2Yl93cml0ZShuZGV2
LCBDU1IxX0FMTCwgQ1NSMSk7DQo+ID4gKwkJCW5kZXYtPmZlYXR1cmVzIHw9IE5FVElGX0ZfQ1NV
TV9NQVNLOw0KPiANCj4gICAgSG0sIHRoZSA+bGludXgvbmV0ZGV2X2ZlYXR1cmVzLmg+IHNheXMg
dGhvc2UgYXJlIGNvbnRyYWRpY3RvcnkgdG8gaGF2ZQ0KPiBib3RoIE5FVElGX0ZfSFdfQ1NVTSBh
bmQgTkVUSUZfRl9DU1VNX01BU0sgc2V0Li4uDQoNCkl0IGlzIGEgbWlzdGFrZSBmcm9tIG15IHNp
ZGUsIEkgYW0gdGFraW5nIG91dCB0aGlzIHNldHRpbmcuIEFueSB3YXkgYmVsb3cgY29kZSBvdmVy
cmlkZXMgaXQuDQpUaGlzIHdpbGwgYW5zd2VyIGFsbCB5b3VyIGNvbW1lbnRzIGJlbG93Lg0KDQpS
ZWdhcmRzLA0KQmlqdQ0KDQo+IA0KPiA+ICsJCX0gZWxzZSB7DQo+ID4gKwkJCXJhdmJfd3JpdGUo
bmRldiwgMCwgQ1NSMSk7DQo+IA0KPiAgICBObyBuZWVkIHRvIG1hc2sgb2ZmIHRoZSAnZmVhdHVy
ZXMnIGZpZWxkPw0KPiANCj4gPiArCQl9DQo+ID4gKwl9DQo+ID4gKwlyYXZiX3dyaXRlKG5kZXYs
IGNzcjAsIENTUjApOw0KPiA+ICsNCj4gPiArCW5kZXYtPmZlYXR1cmVzID0gZmVhdHVyZXM7DQo+
IA0KPiAgICBNaG0sIGRvZXNuJ3QgdGhhdCBjbGVhciBORVRJRl9GX0NTVU1fTUFTSz8NCj4gDQo+
IFsuLi5dDQo+IA0KPiBNQlIsIFNlcmdleQ0K
