Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90ED41E995
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 11:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352875AbhJAJ2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 05:28:06 -0400
Received: from mail-eopbgr1400128.outbound.protection.outlook.com ([40.107.140.128]:30556
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229906AbhJAJ2F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 05:28:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cbv4bxia+b2yO5p+mDqudF8EXHa9N8e8Klq3pgkOKaryzRILGfcVQ1T9bDF6z9m1f0Xy1sTw2BqpswlLYSCIzc31sxHYOvoqseZ1MwXyqnXTi9/K/w3z1xrMsjXf49t/NmYCZ8KagIQtINOH5PH7IeRFQzLVwrRlK2kXkyorRiPNcDNLmp3BGk5MwsHTJyEBjN5RlC5zqNt6gVbZtdPpKJfYdoysaf5sNRVYG1mAghqc6gix8DgPW8tUoN8VJjUpFf/tADNTbydLUSz2vnvCN1va45ZtGHftQOo10yxdsIqs3DuSI7x3gStOEgnI+hH09+UsFY2L++P1LiZ2T52A5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7AcVsGVI679WgM3uJIgTsnK5pOC0FRBBYZez7wIH3Bk=;
 b=BifFdZzGgqs2bYosSXkF2DfCxEyQfF3DHhzAYJWnCX+6bYC/BcTlw/nE0A9GGoUbn7rbUeYEiK+11L6t3ygwhl1BLPMds+ERjB66qlX1IORu5D/7CxSeev0F7HK4SHnJmnYBiLPfZAXNGzxDixJkYNSAasUZ496liZVunWON2g6HtLhkN73oUg1O4soE3KUQsulyyu23HfXHm3mnyOyl+vfoFBVQylmezAtt9ckD5msJTNC1JzIym0kkH/O0bvutGZ3hKSaCiFWxXzU/kpp6Tp6QaGGZRCkvNh4rEPzcE9drX76DesuyU0iAUzZq3KOY7yDdFbl+NSCHJU7AVoQ+yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7AcVsGVI679WgM3uJIgTsnK5pOC0FRBBYZez7wIH3Bk=;
 b=iYec/LEWt2FXjoU9Fwo0+ZUwtI19zb8WPt6Yg6nWTv3deiDSU0hW+igAE076pGxURPQHawCJNiCibeacE/zkNBzNxBxmIW3qz4NEXBoS1bCeHQVQ4VrUQdgI1f1vUgvE3aQyqiMIK6lrs7EAiPFwambJAuk8K44QeJJcWQdHp48=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB4181.jpnprd01.prod.outlook.com (2603:1096:604:4d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Fri, 1 Oct
 2021 09:26:14 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4566.015; Fri, 1 Oct 2021
 09:26:14 +0000
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
Subject: RE: [RFC/PATCH 18/18] ravb: Add set_feature support for RZ/G2L
Thread-Topic: [RFC/PATCH 18/18] ravb: Add set_feature support for RZ/G2L
Thread-Index: AQHXsISbPS3JiQSpSkuqkXJbL6JsEau9FXsAgACdUCCAADVVAIAAAygQ
Date:   Fri, 1 Oct 2021 09:26:14 +0000
Message-ID: <OS0PR01MB5922BD6A46A3CA2031F0268686AB9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-19-biju.das.jz@bp.renesas.com>
 <b19b7b83-7b0b-2c48-afc2-6fbf36a5ad98@omp.ru>
 <OS0PR01MB59221BB67442BD5CA5898D9E86AB9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <3fb8b4e0-e9d6-5ddf-2eae-1d1117dd668f@omp.ru>
In-Reply-To: <3fb8b4e0-e9d6-5ddf-2eae-1d1117dd668f@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ca57ff3-d81f-41b6-423b-08d984bd83fa
x-ms-traffictypediagnostic: OSBPR01MB4181:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB41812B2F3E96BA466E88289286AB9@OSBPR01MB4181.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ntpe+OLFNYOdwqv0isKCbccfj7dnY2JDaT5hECO8/KZMcU9posdKZkgDHwpzh3Q4GG83Yfm1aTfrmrtp+rTxD4L6/abWuh0cGVUsScNu6gCMeeIeAP+Ut5uoN7bYAZRmAOQUSHIbk90l5f6mcELFptzBghnWYbBZ3n9r4Apv/V2rgn4PkeHTag1TLr7qs6PTcP6WGfCqz+vZavGDMNCrtWtmJP18YJP9ToKYbUsH2vlQCnDWG4bwJE9mw5AN0/HfZhSbybqyRMT0JtAv1X6n8vw5xuXiTiVDhO1K8kmJM5H89cFPhgf4IQSAm1q8Gh0SZkB9/77ErMmJO2nozGpxrgERAcxDRtu1wYd7WP6Z/9SEyJRJPaIXITM2Jyft+WaNO+6uwGjcLpRvei6LRtr+mNlixlJ6W/DxJ/0D80tjdV1yI1gwIXWAgvExJ1SLU2ZCpbtxptQuog4UGmCY2to5Dl/NdKDEGmFVJI9JquWTkOt0vkhKKXmAsd6EvRni3CivOCyle2V5BwHICXmb473ZbyAnTVuqQvfffIVx9JMapJbsQHXsg+fNdaTUylri0tzcmL0iX7ZDx2LVE5Zi+memkn/rM9y4VaQDW3rnedtVU9fGo2AkGaTR9o+IIazIVrYHAlC0VTSAU3p3fXWSYlbDQdhjjSsuleTi44zmQh5IvLIuoWr+1/xs8NAck7THPD0NnaK+VbPf9AeWhuAVQq8HpQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(66946007)(66446008)(66556008)(64756008)(66476007)(38070700005)(8676002)(86362001)(83380400001)(76116006)(26005)(107886003)(8936002)(186003)(5660300002)(110136005)(508600001)(71200400001)(4326008)(52536014)(54906003)(38100700002)(33656002)(53546011)(316002)(6506007)(55016002)(122000001)(7696005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UDJxSUZKS2ZBWU1xTVV6YnJaS0FnaFJiUlhuNXhEQ3J0QzhiQmgvWVZUekZI?=
 =?utf-8?B?TW4wWmkyakRxOUJmY3VOakEvUTR1SkxKRS9lU1pwSytFZ0dYL25FRlhxR21y?=
 =?utf-8?B?UDdlRjlnRHNXMUlGcTBGVVVibFIxU1RnWkg0UGNKODlkc3ZaVVpVVjdhdnV2?=
 =?utf-8?B?VmhHZ1c1K0RFdkZkaWNtZ252dFV3cmR5RDk1V1FjSVdqZjMycG9hbGtTNFhX?=
 =?utf-8?B?SWROR1Z3K3lQRmJUQnhtZkZyWkdvYzBPSjR1WkR5TEZDYVZJckg5SXNQMnc2?=
 =?utf-8?B?M093WmRtNXFRU2pybllOc1Q3enFWZEJvamE0VWhNc2pzSDNkajBRYkE4SSsz?=
 =?utf-8?B?RmxOOVpzTHJ0TWdSOUNvank2MUlZSk9nUjZLay9ML09vcU9MQ2lhTDNvQUpP?=
 =?utf-8?B?L2t1K3JwQzNzQ0xPZ09WNEVKOUJ0WTM0aXhxZk9LTTE1SnphbkVVRk9DbXdM?=
 =?utf-8?B?YUsvZGQ3a0Jpd2VNbUpXMUtTSmZ0YzdiU2V5T29WdFVqK1VPNk1Pcm1rR3pI?=
 =?utf-8?B?ZHRTdGpBd1JwZmcvaGhWMTZ1NEVFNEtTT3FGS1ZzamVVeFdCc2lSUGI2V3J6?=
 =?utf-8?B?Z1VUcS95eE92Ui9GLy8yN1BpTEg2MzFSYktnZmxjbTJZR2JyWFJKdVNGcTlz?=
 =?utf-8?B?NWRnQkc1MndJNmF3UjZhRGNzcDFhQzNSTFM5Z2hMcm5CVTdFSXVZRVd2NDcw?=
 =?utf-8?B?V1VHWGF6ZmxPdy9pajNLb1UweWFXbWN0OXBRdFFuMWYxMmZFSHJpV1NXNXA1?=
 =?utf-8?B?K3BlRmFmL3FCcWtXR2lhTzZwc1B4VUVZYWZzeDMxc2h0b2RHNnhYc0EwN1ll?=
 =?utf-8?B?dFNIL0xacnZDZkpPZm0vZTMvV1llV0pDem05L3FLZS9vUzhqdG5Ec3BYaUVY?=
 =?utf-8?B?U0VlbVRSU3RFR25LSFU1V0ltbGFZZnh6QkNvUDFXNlkxTEtnVi9RRVBjTGRr?=
 =?utf-8?B?L3ZPZnVSMSt6RWo4U2lFZC9aaytremlPZmtaT0N6UHcvSnVBMHB3aHp4NDc5?=
 =?utf-8?B?cENuenB4MVl6dk9xbWc2Q2ZUWUhlc2dYdC83dWM5Y2Vnamo5a1V2VlpMVi9B?=
 =?utf-8?B?OHFoVS9XRy82Uzh5QUpjb2E4NXF2RmdmdFd1c0NkS3o4OVlHWE42YXhjSlZI?=
 =?utf-8?B?ZjExZ3F4U1RKWlI1MVZSWHJYaGlnYVJuZFR4V2JrTmthYTQ0b3NSMUZjcDRE?=
 =?utf-8?B?TVlkTTdBRm5FMmIwWVZ0eExTd09LQXV6SnF5Q2Y4ZEtRay9FUndKMW1TZ0tr?=
 =?utf-8?B?T2ZIKzh3Z01IUkw1NCtFTXJYd0t3c21yMkRsSm1oUWhHNFFrbDhtN2F6K25U?=
 =?utf-8?B?SmpCdTR0OVE2OFB0RFpkdnJjL2U5NGhDTWFaMTV5YkxiMkRDN3I1NHAwY2NI?=
 =?utf-8?B?YUMwYVZMRFlJRWlka3NTU2tXZVpiYUVTakxIZlpYM0lxd095YVI3MDc3WW9w?=
 =?utf-8?B?MVgzb0tPZmVKeEdGQmdzaEo4N0F5cGZyN2s1ZFE2am9WbnNualdGUVlRZG5z?=
 =?utf-8?B?blQ1NFlPbUNIbms1dUF3VldjVEJ5Q3JlMUpZMlNEZ090bkVHRXJSYk9UTk95?=
 =?utf-8?B?TjJ5L3ZWU05oZWtxS1pQRWZ5MmppbE9OQy93RTlEcFF6L2hseVp2R2kyS0M1?=
 =?utf-8?B?Y1JhdDdGaFhFKzlQMzVSK1R4QS8vajhONk5va21zSUZsdUQzZ2hIVmk0RURJ?=
 =?utf-8?B?elF6SnZyQ3BSWGlmQU1FVDhhdWxqNnNsZEFGWmxrQUYyYi9TZmsvOVFNQURt?=
 =?utf-8?Q?rev5KGlAUxuMkTFr8g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ca57ff3-d81f-41b6-423b-08d984bd83fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2021 09:26:14.5854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 68H7LseZZn+DkDzt9IDs/fIRs4UIKO81ZA5H0qdsWijiMsy9NBFWQz2r4jqV+8DDD+NOeq+nVU3iJxkM85qH4CXVvLCod6/mUMiNkRj2M60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB4181
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSZTogW1JGQy9QQVRDSCAxOC8xOF0gcmF2YjogQWRkIHNldF9mZWF0dXJlIHN1
cHBvcnQgZm9yIFJaL0cyTA0KPiANCj4gT24gMDEuMTAuMjAyMSA5OjUzLCBCaWp1IERhcyB3cm90
ZToNCj4gDQo+IFsuLi5dDQo+ID4+PiBUaGlzIHBhdGNoIGFkZHMgc2V0X2ZlYXR1cmUgc3VwcG9y
dCBmb3IgUlovRzJMLg0KPiA+Pj4NCj4gPj4+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1
LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPj4+IC0tLQ0KPiA+Pj4gICBkcml2ZXJzL25ldC9l
dGhlcm5ldC9yZW5lc2FzL3JhdmIuaCAgICAgIHwgMzIgKysrKysrKysrKysrKysNCj4gPj4+ICAg
ZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8IDU2DQo+ID4+PiArKysr
KysrKysrKysrKysrKysrKysrKy0NCj4gPj4+ICAgMiBmaWxlcyBjaGFuZ2VkLCA4NyBpbnNlcnRp
b25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4+Pg0KPiA+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4+PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L3JlbmVzYXMvcmF2Yi5oDQo+ID4+PiBpbmRleCBkNDJlOGVhOTgxZGYuLjIyNzVmMjdjMDY3MiAx
MDA2NDQNCj4gPj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+
ID4+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+Pj4gQEAg
LTIwOSw2ICsyMDksOCBAQCBlbnVtIHJhdmJfcmVnIHsNCj4gPj4+ICAgCUNYUjU2CT0gMHgwNzcw
LAkvKiBEb2N1bWVudGVkIGZvciBSWi9HMkwgb25seSAqLw0KPiA+Pj4gICAJTUFGQ1IJPSAweDA3
NzgsDQo+ID4+PiAgIAlDU1IwICAgICA9IDB4MDgwMCwJLyogRG9jdW1lbnRlZCBmb3IgUlovRzJM
IG9ubHkgKi8NCj4gPj4+ICsJQ1NSMSAgICAgPSAweDA4MDQsCS8qIERvY3VtZW50ZWQgZm9yIFJa
L0cyTCBvbmx5ICovDQo+ID4+PiArCUNTUjIgICAgID0gMHgwODA4LAkvKiBEb2N1bWVudGVkIGZv
ciBSWi9HMkwgb25seSAqLw0KPiA+Pg0KPiA+PiAgICAgVGhlc2UgYXJlIHRoZSBUT0UgcmVncyAo
Q1NSMCBpbmNsdWRlZCksIHRoZXkgb25seSBleGlzdCBvbiBSWi9HMkwsDQo+IG5vPw0KPiA+DQo+
ID4gU2VlIGp1c3Qgb25lIGxpbmUgYWJvdmUgeW91IGNhbiBzZWUgQ1NSMCByZWdpc3RlcnMgYW5k
IGNvbW1lbnRzIG9uIHRoZQ0KPiA+IHJpZ2h0IGNsZWFybHkgbWVudGlvbnMgIi8qIERvY3VtZW50
ZWQgZm9yIFJaL0cyTCBvbmx5ICovDQo+IA0KPiAgICAgV2hhdCBJIG1lYW50IHdhcyBjb21tZW50
aW5nIG9uIHRoZW0gYXMgLyogUlovR0wyIG9ubHkgKi8gb3Igc29tZSBzdWNoLg0KPiBTb3JyeSBm
b3Igbm90IGJlaW5nIGNsZWFyIGVub3VnaC4NCj4gDQoNCk9LLg0KDQo+ID4gT0sgd2lsbCBkbyBD
U1IwIGluaXRpYWxpc2F0aW9uIGFzIHBhcnQgb2YgdGhpcyBwYXRjaCBpbnN0ZWFkIG9mIHBhdGNo
DQo+ICMxMC4NCj4gDQo+ICAgICBUSUEhDQo+IA0KPiA+PiBbLi4uXQ0KPiA+Pj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPj4+IGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+Pj4gaW5kZXggNzJhZWE1
ODc1YmM1Li42NDFhZTU1NTNiNjQgMTAwNjQ0DQo+ID4+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4+IFsuLi5dDQo+ID4+PiBAQCAtMjI5MCw3ICsyMzA4
LDM4IEBAIHN0YXRpYyB2b2lkIHJhdmJfc2V0X3J4X2NzdW0oc3RydWN0DQo+ID4+PiBuZXRfZGV2
aWNlICpuZGV2LCBib29sIGVuYWJsZSkgIHN0YXRpYyBpbnQNCj4gPj4+IHJhdmJfc2V0X2ZlYXR1
cmVzX3JnZXRoKHN0cnVjdA0KPiA+PiBuZXRfZGV2aWNlICpuZGV2LA0KPiA+Pj4gICAJCQkJICAg
bmV0ZGV2X2ZlYXR1cmVzX3QgZmVhdHVyZXMpDQo+ID4+PiAgIHsNCj4gPj4+IC0JLyogUGxhY2Ug
aG9sZGVyICovDQo+ID4+PiArCW5ldGRldl9mZWF0dXJlc190IGNoYW5nZWQgPSBmZWF0dXJlcyBe
IG5kZXYtPmZlYXR1cmVzOw0KPiA+Pj4gKwl1bnNpZ25lZCBpbnQgcmVnOw0KPiA+Pg0KPiA+PiAg
ICAgdTMyIHJlZzsNCj4gPj4NCj4gPj4+ICsJaW50IGVycm9yOw0KPiA+Pj4gKw0KPiA+Pj4gKwly
ZWcgPSByYXZiX3JlYWQobmRldiwgQ1NSMCk7DQo+ID4+DQo+ID4+ICAgICAuLi4gYXMgdGhpcyBm
dW5jdGlvbiByZXR1cm5zIHUzMi4NCj4gDQo+ICAgICBJJ20gZXZlbiBzdWdnZXN0aW5nIHRvIGNh
bGwgdGhpcyB2YXJpYWJsZSAnY3NyMCcuDQoNCk9LLiBXaWxsIGNoYW5nZSB0byB1MzIgY3NyMC4N
Cg0KPiANCj4gWy4uLl0NCj4gDQo+ID4gUmVnYXJkcywNCj4gPiBCaWp1DQo+IA0KPiBNQlIsIFNl
cmdleQ0K
