Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75023F1F2E
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 19:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhHSRdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 13:33:55 -0400
Received: from mail-eopbgr1410109.outbound.protection.outlook.com ([40.107.141.109]:47232
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231714AbhHSRdy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 13:33:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FttX4v2HSjR+S+dJl72I6IcmzMT0ZCwGQEeWcu0s6DdgnyktlswIV4LRu8PYsYsKzZlLcVprvogLQ7swBKwPakclcabYTLZLiArQs2OY8CO9mVvJ0ysj1QKyluwMA1Dp9Cu42R0PkU9AB5WeIpG/OZ874WLzEvZYpDsopoxZls4u1q+nYOYpPTtdWD34G1ednPxIu0GWsRrG0AuJ58as5dnJJs/yD8hmOvz5AdSRzxwTg7txfKZiOFv6Zc77Lrki7IiWn8ERKXWXF7jBFHm/97v8ROTsdoS/+1wyptOjfTDFulDzmGQvK7T1v3cfU0yofcPx/LsHynFD0McS76jBaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sc5MmcxZpmoX/SvQMSp5APtM+jE0kVH4JlOlxj3PywU=;
 b=V3M//HHjIQPat2gJRUKvXvSXhOzCfM4pwtZIgpyRF+1Gnd2uFnqKjYeha71ldJViocGj5iXHOWzd54KTNDnHn7Ttq00NkQG19mwGOrQMfgL1sOb3BVIFAIoSsoQmTf5MP4AsJhtvQ7dunDyi9fgu7YUB6VZKp+3WTwFGsoCCCnltiMo0/jRjoXjj/668aWII4dF3nmeUzFbqYBlTxKXLDrTlZbHtupqCj6SWUu4EWd0+08i4kgj+IHghPaxhJzoyRnIXr1IbwmEMkcGZKe2M6tT32NTBkKuDdusd8thoz71BtG+U7bMGj5TO8+WZUoFkS+O9Xus3+vlit/4Jq66KQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sc5MmcxZpmoX/SvQMSp5APtM+jE0kVH4JlOlxj3PywU=;
 b=bjSgMv/nTCDcVn0iBN8lcUTJfqc1hNPq+DscZMXT2Hs1C6iNb5Et8Hjm5f1Fee0XvPK+A/JQVSI+YVdaiJrMsnX/02KlVd0kcsW/ZXwaUWOYV+wiNdcM06FwlmAqGL+x09IoME294VjrxPSg6U2PpushpprPb3epGUXYtEmwaUc=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB2675.jpnprd01.prod.outlook.com (2603:1096:604:8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Thu, 19 Aug
 2021 17:33:15 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4415.024; Thu, 19 Aug 2021
 17:33:15 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
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
Subject: RE: [PATCH net-next v3 2/9] ravb: Add struct ravb_hw_info to driver
 data
Thread-Topic: [PATCH net-next v3 2/9] ravb: Add struct ravb_hw_info to driver
 data
Thread-Index: AQHXlGRmebHvAK0ckUmJ6xprhg3pVat7AyUAgAARjoA=
Date:   Thu, 19 Aug 2021 17:33:15 +0000
Message-ID: <OS0PR01MB59222DD93A66863B561C69C086C09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210818190800.20191-1-biju.das.jz@bp.renesas.com>
 <20210818190800.20191-3-biju.das.jz@bp.renesas.com>
 <6ddde794-1ee4-e57a-c768-8e67d68a004f@omp.ru>
In-Reply-To: <6ddde794-1ee4-e57a-c768-8e67d68a004f@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8752bd1e-586c-406c-4dd3-08d963376cfc
x-ms-traffictypediagnostic: OSAPR01MB2675:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB2675323CB45975513FCB1C6F86C09@OSAPR01MB2675.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 45KBCC/uVyj5Q7/00eGbzNNzQBJ+PMA1kBeMdfv25AJ0ve+xrs/3R/nN5Bgk++y7TgrV3vkjOvj4JFWjEirs68SlMFxCAlYi0Dp0GOt2Ytml/AMjQWtj6nczw6WpbPnBxgrSbwjdGdM+twDOQ8cUy/rxedmnK7YhxuDwvqLRDyqEkshmQt8JdgdkFTnpBXtbJzuJ+YhasjXpwh3MvZN7+9r3ilkGdTMObgJjHfCU7d5Y8SLW+w9qSCSZvuXf6T8aiXUrJPmIAdsbLoQ6NpYwo+5DgfH2Z8X2tZAit+zlSkPkbhVWz/HIUm76ujLrnnQb4ufclhUlMP3hXmxNiEVCYzRc37OTQfyro3Wc50RnccRpeHRe0FFrir5O0kcK98GxRjFuZVFrnOUB6HapJrJVR97A+swUl/RJ5VZ6tjteOtr/X5l59JQaPtKuDnPBldgGt3o2Pd0KxzPyCuy6Aep7KG1+22w1lrFgnnr2DH+a92CkP05Y2cCIFf+G3Z4Xl02CCuTi1NSbCGIxQEGF9PCd5Kb2cxzdVHmmCRGpGXIb5oYzttwGusQ8EABoa9ml9gyl4Gosa94jrekQ4UzT9+xOssSnj+2JRxxNJO50rEJudk92VWD7bPtPuT/HGH+yHDmQLMa/teQCobc2sF/WqhgBxlOJO3GQruUsAegOm+nM+HlSsqyCwYP8BF/7kPd14SnCI4CCEjY17U6lztMEEfBs8VYL0YMtsYmEF0xwSK7EpTZTn8ddUCj5+Ijft+My2nePyCd/L+B0sRCL2S0pIlh7+GOQZFrMaaz9V9RqBO2ICrQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(39850400004)(376002)(346002)(33656002)(52536014)(6506007)(122000001)(9686003)(26005)(86362001)(53546011)(38070700005)(55016002)(5660300002)(66946007)(83380400001)(8936002)(66446008)(8676002)(76116006)(64756008)(66476007)(478600001)(107886003)(110136005)(71200400001)(7696005)(7416002)(186003)(2906002)(4326008)(316002)(54906003)(38100700002)(966005)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SHBEUWljUUwwUjl4TnJ5UnorQU83MktSUVdqWDhvOEFSYzdGcnhWUHNJcnJX?=
 =?utf-8?B?ZnhGNHA1alNwRmxxZWxkdE9NK0dpVEVMc1ByalZLNDRQZERBVG4vYTFvRjdG?=
 =?utf-8?B?b3AyVUNRSDVhcThBbmFRaUNDa2J4VzVDMkFtN0J4ZlpETkc5K1JBVEprTmxt?=
 =?utf-8?B?Q1VHRno5czQ1ay9vQ3dGTm9XU2hLL3FIYVVGaVVtOEhzRU1oS2lqaU5TUi9x?=
 =?utf-8?B?aEhKWGZXNnZ2SCtQT3ZmdG11U2F6TWc2L21Td2NZTlBiOXYyaFdzWXBHVFhH?=
 =?utf-8?B?cnY3aUFPTHBxZFpzMjNxVFlZYVQzZUFMWkt0UDRPdHVaLzVrc2FJZ0pPZEQv?=
 =?utf-8?B?MW9RdzR2WkUvYVF0M2EvaG1SSzY4TklnRFJUb2o3UEx5d0JNZ05LdkE2d0JQ?=
 =?utf-8?B?MllWT0prRENFeUl4V1NpN2ZzZDhxZmt1ZDJJdC9nZGY1SG10YmdPOGVuY2Q3?=
 =?utf-8?B?eFlCUnMwL0hQMnk0aktMeG1MNGExMnN6bEVYcGFmY2U3aW85VFp6ZFVMYVVv?=
 =?utf-8?B?dWc4c004R2NraEJLVVZuWnlHMUNYaHVZQTZpSTNlZzAvSXBXTmUrL3FBRGI1?=
 =?utf-8?B?Qlo0Wms3aE5PaGFWa0FlaWY0TzE0YS94WXY4UjBmelZKUDFZSS92ZmFnUGpv?=
 =?utf-8?B?NWVRSHA5bjJpY1l2VmJINktJa0JEOVdCM2tucFpDWmFHODFsdWNsY3B2ZmFl?=
 =?utf-8?B?MlJHKzlrNjM0UStBU2t6MW92UnphNjZ0Ukd1NllqZW80MnM0UG84SXI5WlBO?=
 =?utf-8?B?aVN0VXRpelhNeTVFYjlMNE8rY0xEUU10UUpsbG1rN21YR1V5L0E1MDVqWDRG?=
 =?utf-8?B?UWo4U0pJWmpsNjRTK0NOLzVMQkhqMnNnTzV1ZzNMVkhya2dVYmNUSVBxZmxX?=
 =?utf-8?B?UUNjdkNlUVFhRmwxaU44TEpJUVBSNlczTjhuaWVpRFltcGlQQitoeEo4SUJ2?=
 =?utf-8?B?d2s3UlQzcmZaVDhlSUV5bkNLRUV5SmtpcVpvOHZ0cGc1bHZHcVBOU0FTUTNH?=
 =?utf-8?B?RmNtVDRVVHZSMU9jWjF0V0w1UWRTaTVVUXE4S3owSzZxODNZV1NUYjZOdDJ5?=
 =?utf-8?B?UW1WQzJQWnk3NVhRdTNLUVA4bytZa3BFbER4RFpSZ3kvY2VRemI5U2U0clBH?=
 =?utf-8?B?dGlVSEdUTHozMndwNFdJQTZ2QjhTKzh4UUxtZTVzYmh5TlpvSkl4SHRqT1BW?=
 =?utf-8?B?RnFuNEFpbGsrTWJtV1loeVlSQ0JISWl0TXlkVDJIVlRkd2FNamw1WnlWOTNM?=
 =?utf-8?B?WktDUmZTZ251WFZ3T1VOS2Z6cVEvM0lBOVdzc1RiTGl1eFUzT0dHY2NlbWFL?=
 =?utf-8?B?NXJ6NlRmWXlMdkcvWnIxZ2IvaFpya1VuWVA3YUkvUWw3enlEUjBYeGNxT0VL?=
 =?utf-8?B?dDZqNlJmdDZrQmcxRlpTZTY3eVlPbCszaEhsQy9RSkp0RTVBeVZ1M1ora1Z0?=
 =?utf-8?B?NE9XYkZOMEQ1cUtlVmZGVHpXbSs4WW5RbjdQVzNLMXFzQlA0eHRVVlV5Ynk3?=
 =?utf-8?B?cW00MUdVRDNmMzRJZ2crQ2Y1TG9oU3hkT2F4bDJwdEdUQVpXSzU5OGFONWZI?=
 =?utf-8?B?VmcyTit5UE4wTjRoVHdMWlVmeXhMZEFPSlQ4dmtESTFTamtvck1NOFhXN3Z4?=
 =?utf-8?B?ekF5aUQ5SVB4OWVhRlJvbEF0Sk9OUkRESWZJbmJsVXl2OG9Ocm0rZmk5Tkw3?=
 =?utf-8?B?d1lZd1krN1hlNUNkZVNPRUNjcFE5bkE4QUVmbTJWRUQ0NEFha2ZLUXVFanFE?=
 =?utf-8?Q?vWH7DBozF8OyWy7sYk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8752bd1e-586c-406c-4dd3-08d963376cfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 17:33:15.0649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rnGxW2oUcTURUqeXz5Q2if7kjHR/bwbjzxmd94/z/5zVYS3DzTioj2UdL+eiApCNzezAeoLdXVmfac1p5VJZTsxiedmRl1fhQwu0LBSUwMA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2675
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjMgMi85XSByYXZi
OiBBZGQgc3RydWN0IHJhdmJfaHdfaW5mbyB0bw0KPiBkcml2ZXIgZGF0YQ0KPiANCj4gT24gOC8x
OC8yMSAxMDowNyBQTSwgQmlqdSBEYXMgd3JvdGU6DQo+IA0KPiA+IFRoZSBETUFDIGFuZCBFTUFD
IGJsb2NrcyBvZiBHaWdhYml0IEV0aGVybmV0IElQIGZvdW5kIG9uIFJaL0cyTCBTb0MNCj4gPiBh
cmUgc2ltaWxhciB0byB0aGUgUi1DYXIgRXRoZXJuZXQgQVZCIElQLiBXaXRoIGEgZmV3IGNoYW5n
ZXMgaW4gdGhlDQo+ID4gZHJpdmVyIHdlIGNhbiBzdXBwb3J0IGJvdGggSVBzLg0KPiA+DQo+ID4g
VGhpcyBwYXRjaCBhZGRzIHRoZSBzdHJ1Y3QgcmF2Yl9od19pbmZvIHRvIGhvbGQgaHcgZmVhdHVy
ZXMsIGRyaXZlcg0KPiA+IGRhdGEgYW5kIGZ1bmN0aW9uIHBvaW50ZXJzIHRvIHN1cHBvcnQgYm90
aCB0aGUgSVBzLiBJdCBhbHNvIHJlcGxhY2VzDQo+ID4gdGhlIGRyaXZlciBkYXRhIGNoaXAgdHlw
ZSB3aXRoIHN0cnVjdCByYXZiX2h3X2luZm8gYnkgbW92aW5nIGNoaXAgdHlwZQ0KPiB0byBpdC4N
Cj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2Fz
LmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogTGFkIFByYWJoYWthciA8cHJhYmhha2FyLm1haGFkZXYt
bGFkLnJqQGJwLnJlbmVzYXMuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBBbmRyZXcgTHVubiA8YW5k
cmV3QGx1bm4uY2g+DQo+ID4gLS0tDQo+ID4gdjItPnYzOg0KPiA+ICAqIFJldGFpbmVkIFJiIHRh
ZyBmcm9tIEFuZHJldywgc2luY2UgdGhlcmUgaXMgbm8gZnVuY3Rpb25hbGl0eSBjaGFuZ2UNCj4g
PiAgICBhcGFydCBmcm9tIGp1c3Qgc3BsaXR0aW5nIHRoZSBwYXRjaCBpbnRvIDIuIEFsc28gdXBk
YXRlZCB0aGUgY29tbWl0DQo+ID4gICAgZGVzY3JpcHRpb24uDQo+ID4gdjI6DQo+ID4gICogSW5j
b3Jwb3JhdGVkIEFuZHJldyBhbmQgU2VyZ2VpJ3MgcmV2aWV3IGNvbW1lbnRzIGZvciBtYWtpbmcg
aXQNCj4gc21hbGxlciBwYXRjaA0KPiA+ICAgIGFuZCBwcm92aWRlZCBkZXRhaWxlZCBkZXNjcmlw
dGlvbi4NCj4gDQo+IFsuLi5dDQo+ID4gIHN0YXRpYyBpbmxpbmUgdTMyIHJhdmJfcmVhZChzdHJ1
Y3QgbmV0X2RldmljZSAqbmRldiwgZW51bSByYXZiX3JlZw0KPiA+IHJlZykgZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBpbmRleCA5NGViOTEzNjc1MmQu
LmI2NTU0ZTVlMTNhZiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5l
c2FzL3JhdmJfbWFpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiX21haW4uYw0KPiBbLi4uXQ0KPiA+IEBAIC0yMTEzLDcgKzIxMjIsNyBAQCBzdGF0aWMgaW50
IHJhdmJfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZQ0KPiAqcGRldikNCj4gPiAgCQl9DQo+
ID4gIAl9DQo+ID4NCj4gPiAtCXByaXYtPmNoaXBfaWQgPSBjaGlwX2lkOw0KPiA+ICsJcHJpdi0+
Y2hpcF9pZCA9IGluZm8tPmNoaXBfaWQ7DQo+IA0KPiAgICBEbyB3ZSBzdGlsbCBuZWVkIHByaXYt
PmNoaXBfaWQ/DQoNClRoZSBwYXRjaCBjdXJyZW50bHkgbWVyZ2VkIGlzIHByZXBhcmF0aW9uIHBh
dGNoLCBzdWJzZXF1ZW50IHBhdGNoIHdpbGwgcmVwbGFjZQ0KYWxsIHRoZSBjaGlwX2lkIGluIHJh
dmJfbWFpbiB3aXRoIGhhcmR3YXJlIGZlYXR1cmVzIGFuZCBkcml2ZXIgZmVhdHVyZXMuDQpBZnRl
ciB0aGF0IGJvdGggcHJpdi0+Y2hpcF9pZCBhbmQgaW5mb19jaGlwaWQgaXMgbm90IHJlcXVpcmVk
IGZvciByYXZiX21haW4uYw0KDQpIb3dldmVyIHB0cCBkcml2ZXJbMV0gc3RpbGwgdXNlcyBpdCwg
YnkgYWRkaW5nIGEgZmVhdHVyZSBiaXQgd2UgY2FuIHJlcGxhY2UNCnRoYXQgYXMgd2VsbC4gU28g
Z29pbmcgZm9yd2FyZCwgdGhlcmUgd29uJ3QgYmUgYW55IHByaXYtPmNoaXBfaWQgb3IgaW5mby0+
Y2hpcF9pZC4NCg0KRG9lcyBpdCBtYWtlcyBzZW5zZT8NCg0KWzFdIGh0dHBzOi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC90cmVlL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9wdHAuYz9oPXY1LjE0LXJjNiNuMjAwDQoN
ClJlZ2FyZHMsDQpCaWp1DQoNCj4gDQo+ID4gIAlwcml2LT5jbGsgPSBkZXZtX2Nsa19nZXQoJnBk
ZXYtPmRldiwgTlVMTCk7DQo+ID4gIAlpZiAoSVNfRVJSKHByaXYtPmNsaykpIHsNCj4gWy4uLl0N
Cj4gDQo+IFJldmlld2VkLWJ5OiBTZXJnZXkgU2h0eWx5b3YgPHMuc2h0eWx5b3ZAb21wLnJ1Pg0K
PiANCj4gWy4uLl0NCj4gDQo+IE1CUiwgU2VyZ2V5DQo=
