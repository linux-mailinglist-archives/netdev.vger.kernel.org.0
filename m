Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A58E418929
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 15:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhIZN4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 09:56:42 -0400
Received: from mail-eopbgr1410091.outbound.protection.outlook.com ([40.107.141.91]:19100
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231759AbhIZN4k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 09:56:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l/VEdrH8epeswm8CGzciWbiZYCiHCT+KJPCF+LBLdk8CxnuHxrDBDXZVoyU4CrLkdBQJoYpb99tOCOSWT0kLp0vi8VTzx1MHOoBT7uI1djGio0PcV4YelCq2gO/gW7Q5xLw4iHx0GXA0W2KSWO2EgaMjtwE1z1d9/DFlCJg328xII+dEKHCAY9kH26zDPKeJrI8aDojs2RnwQqOdhq+a6lnHRavTeQ/YfAjk9oxj6BFoelbeXFVSm0yCLExq9+o2wgmv9/b0dBUUxEKFqhT35nJlKxZ1jGP/tfzMMQl+Jwce/bwlCKJJy08GVw+RDvWg/vasoqFeUeRBNpUSDoNxgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=sjLcCFCIRuI2ysEcGFxGMjKEOAcEOpghFNQPi4BXpzU=;
 b=STkKb/sZLUH2CcUL4rLrmLmbmAZMtkkrnk6st7OJguE9y2Zi/QYUX6zVSk96G6A+c4hDAe994fHj/Xi0RTS1V+mfq1E1linTExc3qdCxC6cEY+61mgCs94bQR2cgiHVJRLcu4+wtHJHGBbcAZx8WhIwqxJ9N3B/LJonVaT+7ovRBw9k+SReT7JvWpVuvxdgOw6wvzSiQJkgW6pVs+f91NN/stMOpksWc5ikzePWAAfLDJsZs+Jqs/Vx55bJPQX2aIX6dUeDLmdsPm6Ql/MiiCxvDh1Q/7kA/vZV6kaep+CZPgFmhA4CTa6D2cOXTmf8CDmhHakRGzjRAh1lkwOD8Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sjLcCFCIRuI2ysEcGFxGMjKEOAcEOpghFNQPi4BXpzU=;
 b=Iph3eZ/2WFrB7tZnweaJkZSxxG8gww8RMC05/dlmHeLK2pcbm56Lqyn+aLiRYtc8P3qTUYdFTSRrMOyHOQDlllYFkA/EeidQoE4vPkRspWUgPxahe8U6dBvn8fveg6o5Z0FGCV3igN/LgGjIhGvcV2OW0wJgH1oSTTVsGNHIyJ8=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB2099.jpnprd01.prod.outlook.com (2603:1096:603:18::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Sun, 26 Sep
 2021 13:54:56 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262%7]) with mapi id 15.20.4544.021; Sun, 26 Sep 2021
 13:54:56 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
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
Subject: RE: [RFC/PATCH 06/18] ravb: Add multi_tsrq to struct ravb_hw_info
Thread-Topic: [RFC/PATCH 06/18] ravb: Add multi_tsrq to struct ravb_hw_info
Thread-Index: AQHXsISD1oySk6FFzkKsyCBHXOWNQquyD7OAgAClW1CAA6S5UA==
Date:   Sun, 26 Sep 2021 13:54:56 +0000
Message-ID: <OS0PR01MB592237144A680FEC1E7C013586A69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-7-biju.das.jz@bp.renesas.com>
 <9aa57bf1-44a5-6016-5445-4f2b8518ddfe@omp.ru>
 <OS0PR01MB5922135B7F17FDE3F4C6091A86A49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB5922135B7F17FDE3F4C6091A86A49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8101c4d3-05d0-4435-6394-08d980f53943
x-ms-traffictypediagnostic: OSAPR01MB2099:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB20999C0EF9B6F5C5718F65A286A69@OSAPR01MB2099.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H3ZrV3cdeBF8HiiFJrp9c9yzeYck0H2CDHs5zSa+eY/24bUFLFRn6R4F434jPUZKRSysMl8gxmvAuJdAARS6hOUDuZd5rPAZxK0l6xBDkSCWQT6o4186g4njmLHqZEwoLt4KTdjKKWfJfVH6h2WF1q87kYmN7eeoULOXfZCvqrGHJab12fXrAnDnuKMClDfjg8oFJfCXEaOogYgdCeNt9zVjiEU/X/RyrvxvNdZ0exoqfbJyuPgaww8ztARB58MsEH9y9nXoIzU4Q66F7KAM0XSuE39lpKL1A8hzKLsGP+SYDdemKnjbIbxOosqBpiUcnbM1lTxMv7Ec/wQ3uDe+iY5xA5F3wsj+fX+h1WxdKuxeK5VBQi+jCq2H7vfqN1mfIRbIbPU0fcDC3OqobzNM7KvhsKD/gkccCJDoDzBH0lY2faU3G8rC0HX7uPbIkKGxOPbxTXmzXLtonu1DOzY78SjKnEyj9E0oG1aTGRXLrmlgbo4JvmNX/xe/9xCp88HXeNgqOtfcqQP8nkU6wbLG5HA0JzJ08xmlV5URxXJ8XVguvn8ov5rtD4WNJguyMNO3hlwswZBapX2p/3GsV0OmqV9JUurB0eNwnMhSz9N0XbCdNN2EDt85WEkrb+y7g2vSKTEZdwkc/pBZH8ZpTY3dehWxq0q+79tznIataqVaQdv66m535uYQrrgbABtJXJwnpYJ4lN4gxp7NHO8z4SPfrPYObhpArnljQQERzp9sdA8BIGvVkhVvpA/VX533Yh5mAKRkIvVhozg1HEOD+tLydUgbDyu5U7+YCPbVBFA+lCM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(71200400001)(66446008)(66476007)(66556008)(64756008)(2906002)(966005)(66946007)(33656002)(316002)(186003)(83380400001)(52536014)(508600001)(26005)(9686003)(8676002)(107886003)(110136005)(54906003)(38070700005)(55016002)(38100700002)(53546011)(8936002)(122000001)(5660300002)(6506007)(86362001)(76116006)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?clMzZXlZUFdib21Cd21mWFdWYnZ0OGlxbW5QbkdZYkhtWkxUUkpDT3NPbW1N?=
 =?utf-8?B?SkgxRGUrWHp6UzZqNUlSVkFvZEx2MUpXRWNoU2V3ZnJnQjBOczN2VkVMcllQ?=
 =?utf-8?B?c3dIRFJhUVUyNU9jNGMycFhEcmIrRlF6REFUdGVUY3BVR2tnbjNGR1FRbUZT?=
 =?utf-8?B?MDlQN1hJdUxFZDdsaFFSZkZhTExsYVZrUFhORWk2VHdGOGp5YUpOODEydDY0?=
 =?utf-8?B?MVZuNy9oLzBqSHh1dFQ4R1M4WWR6WDl3SVQxcmphN1hPSzlPRXBYMHcxUFBY?=
 =?utf-8?B?R3M4SzJ0UHl6U3NPTGFNSWJkc0dhOHQ0TDFSTXdLN1YyUW03N3hDYWJ3MVY2?=
 =?utf-8?B?OG9iR0FxQytFRytGdTdaTnR0MmZJTk1DazZZTVZteFF2Z3ZNMVdMWjFpU2Zm?=
 =?utf-8?B?QTUyR1MzRFVjNVVKVEdPRWV3ZXFVaU8rdk54SENIa1pCWk5yRGUyNjB4NG1L?=
 =?utf-8?B?L1MwRVkySzk1d0lod1hMemx0aE03RmdxOUtKNkwwZ2FqbG1makVmc3Y1bW9j?=
 =?utf-8?B?L2w3dWlQRjZGU2pSNDFYSVU4Y3hHMGtwUU1KUTF6ZGk3c1hsWnlaY3pKb1hN?=
 =?utf-8?B?MHRnQXdRTGFJbUkzT2hRa01ybjN5QmozNDJ2Y1BqK29iM3dod0hGM1hWQlpt?=
 =?utf-8?B?L0NsT1BQeTUvczlJTWxJZmY5SkF5UFJXd0hGWFJTUjJQdjQwMm9BZm52UklU?=
 =?utf-8?B?MHNxYjRhREJvUkVjZWJzcVpsdEl6YUM1YTErTlRFZk5mNmtDV2R6a3JXVUVt?=
 =?utf-8?B?a0pkbU83cWM5djRhb2pCbVllNUlFbjNjOUdWQkhPdW4vTXFuOGtjWUJhUGNB?=
 =?utf-8?B?Mm5rWUp5dksvSzdCRFA5M1VIbXN3WlRyd3Y4ZjIvbXYxNU5EQ3VaaS8rczNx?=
 =?utf-8?B?cU5mV0xiOTgzUk5ZWHZPYWMvSmRXdmFyZU5GVjN6czlhSCtQR255dC9uRFBp?=
 =?utf-8?B?d0JVeE9tNW4zRjBkcmY5azl6TmRHNnJoQ2NKaHJzekpPZXg5MTdVQWcvK3g3?=
 =?utf-8?B?ZEpqbmtqblU5WnRZbVRmSmZoZURiZmVDRWpqb2NUQVlzQWtKb1U5ZjBreVlG?=
 =?utf-8?B?R3krSGtIdkRJVWV6Q1lGT2g2ZlE1RHlZZklyRDZ2d21LeDZHNjI4R0JxMGY2?=
 =?utf-8?B?Z0dZOVdoR3lEREhxOEF4TDQzQzFSVlNhVHBQTDI4T2NxbGFOWHdqNm9HendP?=
 =?utf-8?B?ZFJNYW0yNTdkRnRuaWpJcjYvMmtjdk9SR21EZXFwYU55b0V6cEZZcmZoRG9Y?=
 =?utf-8?B?NnJKV3dQamFvYjVRNTN0OGpOT3JDeE5xYlJacnhwYnVtRGdUcHFBeWducTUv?=
 =?utf-8?B?T2VkSTI1Y3FOcEtGQW5VbnJqR1AxZUx5REVYZ3lCWWZDUW5ibGhFTTI0NDBp?=
 =?utf-8?B?TWtQWmNUeHJ5ZmZveDgwOHJPV2xSUlRBV2JqbHkwMW50MjNpTGhCZWtocXdK?=
 =?utf-8?B?dWl6WXVQeVQrNUtIMzVCRC9odkpjaUt4MS9oMHNBSkM2V3F6MEZaRG5rK0F0?=
 =?utf-8?B?ZUh3emtuNHhMTXhXZlYvR2d4OTh1K2RFNWRUNFlTampNM2NPd1EwYmFJWEt2?=
 =?utf-8?B?SEg0eHY5RkV2NGZzZjFzdVREVnF1MnVsVHdHSDdaNGNGMGZLVGRjRDV0dGxI?=
 =?utf-8?B?Z2VINmNuSDhxVmtFNE84NmJvYTZFSjQyUzJGMHZiTzQ2OXgzeVlaS042Q0wr?=
 =?utf-8?B?VW83ZzFBZHF5UUg2WnFHL3ArNmxEWG51QUtmaTZOK3FiMmRKdEwyY3k5Vm9n?=
 =?utf-8?Q?nGt0FwiAmwlOzwN7fL2QHfxrCepY8ETgQuao+pY?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8101c4d3-05d0-4435-6394-08d980f53943
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2021 13:54:56.4481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 07MbOlD5SlX4XuXpxk6NjdrSk0PKe1rqW9RNFqFTM5e4NQRJA0p/c+q8dEaa/ROEM+gFMj2Z5mOpoQ9qi4h/smlfsuLI71+nkrDvL5GTXzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2099
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJFOiBbUkZDL1BBVENIIDA2LzE4XSByYXZiOiBBZGQg
bXVsdGlfdHNycSB0byBzdHJ1Y3QgcmF2Yl9od19pbmZvDQo+IA0KPiBIaSBTZXJnZWksDQo+IA0K
PiBUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCj4gDQo+ID4gU3ViamVjdDogUmU6IFtSRkMvUEFU
Q0ggMDYvMThdIHJhdmI6IEFkZCBtdWx0aV90c3JxIHRvIHN0cnVjdA0KPiA+IHJhdmJfaHdfaW5m
bw0KPiA+DQo+ID4gT24gOS8yMy8yMSA1OjA4IFBNLCBCaWp1IERhcyB3cm90ZToNCj4gPg0KPiA+
ID4gUi1DYXIgQVZCLURNQUMgaGFzIDQgVHJhbnNtaXQgc3RhcnQgUmVxdWVzdCBxdWV1ZXMsIHdo
ZXJlYXMgUlovRzJMDQo+ID4gPiBoYXMgb25seSAxIFRyYW5zbWl0IHN0YXJ0IFJlcXVlc3QgcXVl
dWUoQmVzdCBFZmZvcnQpDQo+ID4gPg0KPiA+ID4gQWRkIGEgbXVsdGlfdHNycSBodyBmZWF0dXJl
IGJpdCB0byBzdHJ1Y3QgcmF2Yl9od19pbmZvIHRvIGVuYWJsZQ0KPiA+ID4gdGhpcyBvbmx5IGZv
ciBSLUNhci4gVGhpcyB3aWxsIGFsbG93IHVzIHRvIGFkZCBzaW5nbGUgVFNSUSBzdXBwb3J0DQo+
ID4gPiBmb3IgUlovRzJMLg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxi
aWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGRyaXZlcnMvbmV0
L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAgICAgfCAgMSArDQo+ID4gPiAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8IDEyICsrKysrKysrKystLQ0KPiA+ID4gIDIg
ZmlsZXMgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPiA+DQo+
ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4g
PiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiA+IGluZGV4IGJi
OTI0NjlkNzcwZS4uYzA0M2VlNTU1YmU0IDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L3JlbmVzYXMvcmF2Yi5oDQo+ID4gPiBAQCAtMTAwNiw2ICsxMDA2LDcgQEAgc3RydWN0IHJhdmJf
aHdfaW5mbyB7DQo+ID4gPiAgCXVuc2lnbmVkIG11bHRpX2lycXM6MTsJCS8qIEFWQi1ETUFDIGFu
ZCBFLU1BQyBoYXMgbXVsdGlwbGUNCj4gPiBpcnFzICovDQo+ID4gPiAgCXVuc2lnbmVkIG5vX2dw
dHA6MTsJCS8qIEFWQi1ETUFDIGRvZXMgbm90IHN1cHBvcnQgZ1BUUA0KPiA+IGZlYXR1cmUgKi8N
Cj4gPiA+ICAJdW5zaWduZWQgY2NjX2dhYzoxOwkJLyogQVZCLURNQUMgaGFzIGdQVFAgc3VwcG9y
dCBhY3RpdmUgaW4NCj4gPiBjb25maWcgbW9kZSAqLw0KPiA+ID4gKwl1bnNpZ25lZCBtdWx0aV90
c3JxOjE7CQkvKiBBVkItRE1BQyBoYXMgTVVMVEkgVFNSUSAqLw0KPiA+DQo+ID4gICAgTWF5YmUg
J3NpbmdsZV90eF9xJyBpbnN0ZWFkPw0KPiANCj4gU2luY2UgaXQgaXMgY2FsbGVkIHRyYW5zbWl0
IHN0YXJ0IHJlcXVlc3QgcXVldWUsIGl0IGlzIGJldHRlciB0byBiZSBuYW1lZA0KPiBhcyBzaW5n
bGVfdHNycSB0byBtYXRjaCB3aXRoIGhhcmR3YXJlIG1hbnVhbCBhbmQgSSB3aWxsIHVwZGF0ZSB0
aGUgY29tbWVudA0KPiB3aXRoICJHYkV0aGVybmV0IERNQUMgaGFzIHNpbmdsZSBUU1JRIg0KPiBQ
bGVhc2UgbGV0IG1lIGtub3cgYXJlIHlvdSBvayB3aXRoIGl0LiBPdGhlciB3aXNlIEkgd291bGQg
bGlrZSB0byB1c2UNCj4gZXhpc3RpbmcgbmFtZS4NCg0KT24gdGhlIG5leHQgcmV2aXNpb24gYXMg
eW91IHByb3Bvc2VkIGZvciBbMV0sDQpJIHdpbGwgdXNlIGEgdTMyIHRzcnEsIGluc3RlYWQgb2Yg
Yml0LCB0aGVyZSBieSB3ZSBjYW4gYXZvaWQgYSBjaGVjay4NCg0KaHR0cHM6Ly9wYXRjaHdvcmsu
a2VybmVsLm9yZy9wcm9qZWN0L2xpbnV4LXJlbmVzYXMtc29jL3BhdGNoLzIwMjEwOTIzMTQwODEz
LjEzNTQxLTEyLWJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tLw0KPiANCj4gPg0KPiA+ID4gIH07
DQo+ID4gPg0KPiA+ID4gIHN0cnVjdCByYXZiX3ByaXZhdGUgew0KPiA+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiA+IGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ID4gaW5kZXggODY2M2Q4MzUw
N2EwLi5kMzdkNzNmNmQ5ODQgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gPiBAQCAtNzc2LDExICs3NzYsMTcgQEAgc3RhdGljIHZv
aWQgcmF2Yl9yY3Zfc25kX2VuYWJsZShzdHJ1Y3QNCj4gPiA+IG5ldF9kZXZpY2UgKm5kZXYpDQo+
ID4gPiAgLyogZnVuY3Rpb24gZm9yIHdhaXRpbmcgZG1hIHByb2Nlc3MgZmluaXNoZWQgKi8gIHN0
YXRpYyBpbnQNCj4gPiA+IHJhdmJfc3RvcF9kbWEoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpICB7
DQo+ID4gPiArCXN0cnVjdCByYXZiX3ByaXZhdGUgKnByaXYgPSBuZXRkZXZfcHJpdihuZGV2KTsN
Cj4gPiA+ICsJY29uc3Qgc3RydWN0IHJhdmJfaHdfaW5mbyAqaW5mbyA9IHByaXYtPmluZm87DQo+
ID4gPiAgCWludCBlcnJvcjsNCj4gPiA+DQo+ID4gPiAgCS8qIFdhaXQgZm9yIHN0b3BwaW5nIHRo
ZSBoYXJkd2FyZSBUWCBwcm9jZXNzICovDQo+ID4gPiAtCWVycm9yID0gcmF2Yl93YWl0KG5kZXYs
IFRDQ1IsDQo+ID4gPiAtCQkJICBUQ0NSX1RTUlEwIHwgVENDUl9UU1JRMSB8IFRDQ1JfVFNSUTIg
fCBUQ0NSX1RTUlEzLCAwKTsNCj4gPiA+ICsJaWYgKGluZm8tPm11bHRpX3RzcnEpDQo+ID4gPiAr
CQllcnJvciA9IHJhdmJfd2FpdChuZGV2LCBUQ0NSLA0KPiA+ID4gKwkJCQkgIFRDQ1JfVFNSUTAg
fCBUQ0NSX1RTUlExIHwgVENDUl9UU1JRMiB8DQo+ID4gVENDUl9UU1JRMywgMCk7DQo+ID4gPiAr
CWVsc2UNCj4gPiA+ICsJCWVycm9yID0gcmF2Yl93YWl0KG5kZXYsIFRDQ1IsIFRDQ1JfVFNSUTAs
IDApOw0KPiA+DQo+ID4gICAgQXJlbid0IHRoZSBUU1JRMS8yLzMgYml0cyByZXNlcnZlZCBvbiBS
Wi9HMkw/IElmIHNvLCB0aGlzIG5ldyBmbGFnDQo+ID4gYWRkcyBhIGxpdHRsZSB2YWx1ZSwgSSB0
aGluay4uLiB1bmxlc3MgeW91IHBsYW4gdG8gdXNlIHRoaXMgZmxhZw0KPiA+IGZ1cnRoZXIgaW4g
dGhlIHNlcmllcz8NCj4gDQo+IEl0IHdpbGwgYmUgY29uZnVzaW5nIGZvciBSWi9HMkwgdXNlcnMu
IEhXIG1hbnVhbCBkb2VzIG5vdCBkZXNjcmliZXMNCj4gVFNSUTEvMi8zIGFuZCB3ZSBhcmUgd3Jp
dGluZyB1bmRvY3VtZW50ZWQgcmVnaXN0ZXJzIHdoaWNoIGlzIHJlc2VydmVkLg0KPiANCj4gVG9t
b3Jyb3cgaXQgY2FuIGhhcHBlbiB0aGF0IHRoaXMgcmVzZXJ2ZWQgYml0cyg5MCUgaXQgd2lsbCBu
b3QgaGFwcGVuKQ0KPiB3aWxsIGJlIHVzZWQgZm9yIGRlc2NyaWJpbmcgc29tZXRoaW5nIGVsc2Uu
DQo+IA0KPiBJdCBpcyB1bnNhZmUgdG8gdXNlIHJlc2VydmVkIGJpdHMuIEFyZSB5b3UgYWdyZWVp
bmcgd2l0aCB0aGlzPw0KDQpBcyBwZXIgdGhlIGFib3ZlIGRpc2N1c3Npb24sIHdlIGNhbiByZXBs
YWNlIHRoZSBhYm92ZSBjaGVjayBhcyB5b3UgcHJvcG9zZWQgZm9yIFsxXQ0KDQplcnJvciA9IHJh
dmJfd2FpdChuZGV2LCBUQ0NSLCBpbmZvLT50c3JxLCAwKTsNCg0KWzFdIGh0dHBzOi8vcGF0Y2h3
b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9saW51eC1yZW5lc2FzLXNvYy9wYXRjaC8yMDIxMDkyMzE0
MDgxMy4xMzU0MS0xMi1iaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbS8NCg0KcmVnYXJkcywNCkJp
anUNCg==
