Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405623C9CA4
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 12:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241314AbhGOKeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 06:34:20 -0400
Received: from mail-eopbgr1410095.outbound.protection.outlook.com ([40.107.141.95]:44533
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231672AbhGOKeU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 06:34:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lR0KKJXkKxOQ5PN01vPXijb7U29KaFAswcjOmIXwKyrPQf+C59eC7mNG4aGwPLoDXOfbs5iLso8WWN3SZDpLBw/LP3LOc0aYq0SoHc/9d2Qm0sm1w9GbBV6m6L4XPMVmMeJV4t0XiF6tZoCcSY/8sB5jcgi6cRSdpESMLXdYeUvj4ZvOa4zYY1HW5R/cRbq/xF3Z3YQ8r2rQhCt1odYYYSaJK/8FyvGQz73Z/Py1665d07B3m4IEWL/lnSPxwDvfI9K2kqfUNr9udqMtzA1OIxo9U5/ZcWzrSJ/ZQlAJ8PYCULHVK63pPeqKWD4PKcFhUdG0DBx7rFPgZaUWNi0kJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KI1tkC/yUiUsJzumbzGn1OSOge0MNnD6STt5zN+UHTk=;
 b=KSCzvpuBb+jXFdDIAj6q/9pmlpH9tIGWPi2oF1kr3FxsKpi8KzVkQ0CwmzoOUhtPbiLwljTj3/eZ+ZOYcjh8u6+7KGjYuZ5ynhKaA15eJr7nq2bb7UvMyJ/JHmVR5Z7sF5tJ+i8Ox+cgqm9PCXmx/Si4qXg+gNGmIMnJ4NAxGjLYjLVYiZ3CdbflfB7dbcAWVmgUL8a2LrBq36+UF6x/cyNgQVPxpEIo2QNRfj6Z2ha+2zhI59w600/lMPhHmRYRYK7G1t6eoMSDWFILVA4hb292mjnQMjh6DcaYV55nLhBt2uWW5EvvHNZ3op8BTJGm+utT26a20bdb9549FmLSQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KI1tkC/yUiUsJzumbzGn1OSOge0MNnD6STt5zN+UHTk=;
 b=accLS5Lhc0UszNwfGD+rzMswIruXZb3SFfDdPQkk+BbBbD6dCjm1cBfSSeQI+6bfgeyT079mGoiIfaXINyAOiqTlzO90qh/h8aJ9RpJB+8Z8MSb784uTWn4OadTH2afcc/VYL6IGSyZcj90Aw5Kl25LPJQNsGbZNPZHUHX9daIQ=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB6855.jpnprd01.prod.outlook.com (2603:1096:604:114::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Thu, 15 Jul
 2021 10:31:25 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4331.021; Thu, 15 Jul 2021
 10:31:25 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH/RFC 2/2] ravb: Add GbEthernet driver support
Thread-Topic: [PATCH/RFC 2/2] ravb: Add GbEthernet driver support
Thread-Index: AQHXeMAjAlRFQ0Sz3UilaOpIkkO4q6tD0oEAgAAECiA=
Date:   Thu, 15 Jul 2021 10:31:24 +0000
Message-ID: <OS0PR01MB59222DC66DFF9A363A60E40586129@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210714145408.4382-1-biju.das.jz@bp.renesas.com>
 <20210714145408.4382-3-biju.das.jz@bp.renesas.com>
 <CAMuHMdW-NeDqiNDzQzzqnmQB2qL0Bc1-m+NQu9v8bK+_+7HxWQ@mail.gmail.com>
In-Reply-To: <CAMuHMdW-NeDqiNDzQzzqnmQB2qL0Bc1-m+NQu9v8bK+_+7HxWQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux-m68k.org; dkim=none (message not signed)
 header.d=none;linux-m68k.org; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2605652f-1c71-435d-87b9-08d9477bb27b
x-ms-traffictypediagnostic: OS3PR01MB6855:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB6855EFEEA30835EF4BC20FE586129@OS3PR01MB6855.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xpAcjpEJIHmmmbXvXLKxJpDymggc6QK2xO7z44w7WiJTbo37XD+DGa9MsLOcges+xu21gYmXT9AOSfar0ltBrykniUI3hU5gnnDkCPGU/m0NgDSyGRy1/cYeJSn7bUSCkJQ25HYjiNm/DqGKRstbJrjuZeUwEUDEooP8I6vXZcejtdI6COLAb7HaAe/4K97kLZy0s1D8uiXnRNT8OocLqjj62auZPmxeA+QiYVz5bGsFBpn4LX39g4iYRlwHCmgb/NOfEoUhY0dB1cWwZZpKusGa1DxN9XAMbqI/mli+4runs5uxrjG9g7NbnMvkC/IjLcAx3EaIB5NO5YYvslASjAiU1GGdN5oNnfH6hXORepmmZsSNZCr478BInLgWfn6AKq5R2ljm3ccOk0gbhOTvTn775lQTx26G0VWGylq8pi97vG0M/thDUVfIxP1xoa/Qd6ZJnuXmr3AwLW4Jy0MPcaoza4GtPzlaOgGNO6BKiK0xwd4IfsBIZ86ZJK+Ir6xc+0XUsRXACuPL7nrQgRFqJB6/5ejXBorif3AC4oiN+tpYHL5UUiuXwWgtdHtfV+jVaEYmO/hqBZ1OL1pI1m+eipGturRw9NPkE/s3odiojd2pq4NDjZv8rpD+ylJeStvC70FB2NCqKnceAf/xr/L3xopt3VQEucdSf7eNqR4037O/Of5irBmxYNxMCnLUb8lBzqMswP1BuEv7Piy/d/Mk3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(346002)(376002)(396003)(39850400004)(136003)(366004)(122000001)(33656002)(316002)(186003)(86362001)(52536014)(6506007)(7696005)(71200400001)(26005)(53546011)(478600001)(6916009)(54906003)(5660300002)(83380400001)(76116006)(9686003)(8676002)(107886003)(7416002)(66446008)(8936002)(66556008)(2906002)(66946007)(55016002)(38100700002)(66476007)(64756008)(4326008)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SGcxTTE4a3dnWmdrQjJOVjZJSzhaSkZQNTVKU1ZyN01sMWRVRjdPOFIraVkx?=
 =?utf-8?B?Wlh0dWpzWnJmWmFQL3RHenhtU3IvWVFleFFqNllacHlXRkF1YXlVdEcwNDNu?=
 =?utf-8?B?WHZock96MytBTmpXZkx4bFAyV0xGR3F6NmVsRnFCMlZFTTdpcGhYVlBMakxu?=
 =?utf-8?B?dkJlOXkzTERzTGJ6STdlc0E3cU9HejNIc01OOXNXNCtRd00vVnpsaUVhUndx?=
 =?utf-8?B?cUtUbGozZUcvL09lRk1SOFZUdXZhcEt1blphenV0SmtSRklIczRuR2x6SkRQ?=
 =?utf-8?B?cVhQb0tLYnJ1WFdoZjZ6cFdFVlRzZjlNZWsyUXpUc3B4b1IvUmU3eW1RZ3ZY?=
 =?utf-8?B?WHg5MU9XVkpaSTN3T0FoVDY0QmhKU1ZQeUZlRjdqOEM5QWp3QzZLcHVrQWpD?=
 =?utf-8?B?a3F0MDZrNDM4T3VIQUtranFVNlYyUnRhaUxoL2ZKQ2RYVTFrYTBRcE01RkRv?=
 =?utf-8?B?clo1YXlkUjhFUHVCaHpVdy93UDg5UVBQRkR4U005Tlp2MjNqcnZic0lCRVdR?=
 =?utf-8?B?aGRkWjVDVm81N2FFdkw4VVdnZTdPQ1V3WWNZZE5QWm1nV1hFbU1KcGVMaHJ5?=
 =?utf-8?B?NlErbU5hV0xYVEhHL0phZVNsZ2g0UThsSjBoMnpTb2FCK0krK1RFS3RWNnh0?=
 =?utf-8?B?YTlmSWVGZExFYzVZTTBvNXB6OWs5SEpQV1VzUmNUSFozWlpPTG9tNThZb3M0?=
 =?utf-8?B?MU5KRUNHbTRZRFdsNmkwUU1rVFp2NmJnaEZGbjhBL0hRbm80SE1IL3FEcWdy?=
 =?utf-8?B?eXJHS21ZTDNweCtDdUlOOXZqdUcvWkJoT2JPbFl6bGN6Q1ZabnRTN29sQmt0?=
 =?utf-8?B?Mlp0QmtjUkFnaUtzZHlMVDR5Vmp4OTU1NkJubVNPcDlnZm5EQ1VHTkFMWXBs?=
 =?utf-8?B?ZEx4SWlmcVo1UlhrZDAxaTVWVzBWcndBSWlUWmphNUpuWWlidHZPUjdPRDho?=
 =?utf-8?B?SmJ5UUthOUY4ZXNpMDZHaEhqU0NwemZyWnNvZzJCRk5ZVWFEdHd3eFJxZVlW?=
 =?utf-8?B?ODhGNHE0MEZSVndHSnFrakZNSG0wSnlLZVhTb0pMdFpWK0c1ZEdKOUwrQno3?=
 =?utf-8?B?a2lTRWFlTDFQYzhBTzNSR3NMS0IxT1FoZGpGbFU4c2FNSTJVVnhLYzdYTnQ3?=
 =?utf-8?B?T2tMbEc0QUkzeW54b1ZCMFk0Nnk1cG5mWUNKWDlJN3VwbjU3L1hpNU0yK21O?=
 =?utf-8?B?UzVWMTgzVlJxWkNaaTVIdWtOdHBLQzV5Q1BjVkVXVXpFRTlTcGsyL0swWFlG?=
 =?utf-8?B?VzVuUm9IbFFYOHJKZkZNaVlzdS9sUFQxTFFpVUVGZlNmRVZKS3BKZzhWQ0pU?=
 =?utf-8?B?aHp5QU96UlVGMnhwSWF3SDhQcTZCMEpySDFiWTN6VkY4UTYvZ1B2eXJTdFF3?=
 =?utf-8?B?MnlnT08xK2gxQzN1ZldVdCsraEdkeWNKMzYrS3k2aTI0MVhyMUpiTU5Kemx1?=
 =?utf-8?B?NnRXczU5YWFMVTZMWTh2QTFldHhWTGdTcmxGRE9uUnBoc2JwYzd2RHpmTDI5?=
 =?utf-8?B?TnBTZGZBeGxyYzlvaEdzNEZzUW1kaW02eG9BOEVrbTlEbUFKaWZMUEZISUI0?=
 =?utf-8?B?eVR1MlFXQ2ZBU0ZZUFp2Yjd3cC9yc0RZeEw3c1Q0TXRYRkwrbWFTQmhYN3hz?=
 =?utf-8?B?QTdZK1h2cXdBcnl6cnk4U1lXeU9WeDdERys0emp4bzFncm56QWZ3aHpnY2pv?=
 =?utf-8?B?TWM0ZWtkaEtRbFNmeUdtbEdjNFo1d2lSMkVCSHpJeWtSQ09sNHpTdXBmcWVR?=
 =?utf-8?Q?aX4KN9zoFcxXySQJXcAIAAd0CQRH9OEBon2YXBp?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2605652f-1c71-435d-87b9-08d9477bb27b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2021 10:31:24.8803
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WN6P4wVSAEqwg7usabIajpFLoeXVQUSJhogyUNx4Qtr3JH9SlQvBV2OiFmEmDWAWAhcKblHACzLzy102FPouRbTo7SmVF1pfKr9KtufDMt8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6855
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQsDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0gvUkZDIDIvMl0gcmF2YjogQWRkIEdiRXRoZXJuZXQgZHJpdmVyIHN1cHBvcnQNCj4gDQo+
IEhpIEJpanUsDQo+IA0KPiBPbiBXZWQsIEp1bCAxNCwgMjAyMSBhdCA0OjU0IFBNIEJpanUgRGFz
IDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gd3JvdGU6DQo+ID4gQWRkIEdpZ2FiaXQg
RXRoZXJuZXQgZHJpdmVyIHN1cHBvcnQuDQo+ID4NCj4gPiBUaGUgR2lnYWJpdCBFdGhlcm5lciBJ
UCBjb25zaXN0cyBvZiBFdGhlcm5ldCBjb250cm9sbGVyIChFLU1BQyksDQo+ID4gSW50ZXJuYWwg
VENQL0lQIE9mZmxvYWQgRW5naW5lIChUT0UpIGFuZCBEZWRpY2F0ZWQgRGlyZWN0IG1lbW9yeQ0K
PiA+IGFjY2VzcyBjb250cm9sbGVyIChETUFDKS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJp
anUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gDQo+IFRoYW5rcyBmb3IgeW91
ciBwYXRjaCENCj4gDQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZi
LmgNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiANCj4g
PiBAQCAtOTg2LDYgKzEwNjgsNyBAQCBzdHJ1Y3QgcmF2Yl9wdHAgeyAgZW51bSByYXZiX2NoaXBf
aWQgew0KPiA+ICAgICAgICAgUkNBUl9HRU4yLA0KPiA+ICAgICAgICAgUkNBUl9HRU4zLA0KPiA+
ICsgICAgICAgUlpfRzJMLA0KPiA+ICB9Ow0KPiANCj4gSW5zdGVhZCBvZiBhZGRpbmcgYW5vdGhl
ciBjaGlwIHR5cGUsIGl0IG1heSBiZSBiZXR0ZXIgdG8gcmVwbGFjZSB0aGUgY2hpcA0KPiB0eXBl
IGJ5IGEgc3RydWN0dXJlIHdpdGggZmVhdHVyZSBiaXRzLCB2YWx1ZXMsIGFuZCBmdW5jdGlvbiBw
b2ludGVycyAoc2VlDQo+IGV4YW1wbGVzIGJlbG93KS4NCiANCj4gQlRXIGdpdmVuIHRoZSByYXZi
IGRyaXZlciBpcyBiYXNlZCBvbiB0aGUgc2hfZXRoIGRyaXZlciAoIkV0aGVybmV0IEFWQg0KPiBp
bmNsdWRlcyBhbiBHaWdhYml0IEV0aGVybmV0IGNvbnRyb2xsZXIgKEUtTUFDKSB0aGF0IGlzIGJh
c2ljYWxseQ0KPiBjb21wYXRpYmxlIHdpdGggU3VwZXJIIEdpZ2FiaXQgRXRoZXJuZXQgRS1NQUMi
KSwgYW5kIHNlZWluZyB0aGUgYW1vdW50IG9mDQo+IGNoYW5nZXMsIEknbSB3b25kZXJpbmcgaWYg
cmdldGggaXMgY2xvc2VyIHRvIHNoX2V0aD8gOy0pDQoNCldpdGggc2hfZXRoIGRyaXZlcixXZSBj
YW4gcmV1c2Ugb25seSBFLU1BQyBJUC4gQnV0IHdpdGggUkFWQiB3ZSBjYW4gcmV1c2UgYm90aCBE
TUFDIGFuZCBFLU1BQy4NCkhlbmNlIEkgYmVsaWV2ZSBpdCBpcyBjbG9zZXIgdG8gQVZCLg0KDQo+
IA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4g
PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+IA0KPiA+
IEBAIC0yNDcsOCArMjg4LDEyIEBAIHN0YXRpYyB2b2lkIHJhdmJfcmluZ19mcmVlKHN0cnVjdCBu
ZXRfZGV2aWNlICpuZGV2LA0KPiBpbnQgcSkNCj4gPiAgICAgICAgIGludCByaW5nX3NpemU7DQo+
ID4gICAgICAgICBpbnQgaTsNCj4gPg0KPiA+IC0gICAgICAgaWYgKHByaXYtPnJ4X3JpbmdbcV0p
IHsNCj4gPiAtICAgICAgICAgICAgICAgcmF2Yl9yaW5nX2ZyZWVfZXgobmRldiwgcSk7DQo+ID4g
KyAgICAgICBpZiAocHJpdi0+Y2hpcF9pZCA9PSBSWl9HMkwpIHsNCj4gPiArICAgICAgICAgICAg
ICAgaWYgKHByaXYtPnJnZXRoX3J4X3JpbmdbcV0pDQo+ID4gKyAgICAgICAgICAgICAgICAgICAg
ICAgcmdldGhfcmluZ19mcmVlX2V4KG5kZXYsIHEpOw0KPiA+ICsgICAgICAgfSBlbHNlIHsNCj4g
PiArICAgICAgICAgICAgICAgaWYgKHByaXYtPnJ4X3JpbmdbcV0pDQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgcmF2Yl9yaW5nX2ZyZWVfZXgobmRldiwgcSk7DQo+ID4gICAgICAgICB9DQo+
IA0KPiBDb3VsZCBiZSBjYWxsZWQgdGhyb3VnaCBhIGZ1bmN0aW9uIHBvaW50ZXIgaW5zdGVhZC4N
Cg0KT0suDQo+IA0KPiA+IEBAIC0zNTYsNyArNDM0LDcgQEAgc3RhdGljIHZvaWQgcmF2Yl9yaW5n
X2Zvcm1hdChzdHJ1Y3QgbmV0X2RldmljZQ0KPiA+ICpuZGV2LCBpbnQgcSkgIHN0YXRpYyBpbnQg
cmF2Yl9yaW5nX2luaXQoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIGludA0KPiA+IHEpICB7DQo+
ID4gICAgICAgICBzdHJ1Y3QgcmF2Yl9wcml2YXRlICpwcml2ID0gbmV0ZGV2X3ByaXYobmRldik7
DQo+ID4gLSAgICAgICBzaXplX3Qgc2tiX3N6ID0gUlhfQlVGX1NaOw0KPiA+ICsgICAgICAgc2l6
ZV90IHNrYl9zeiA9IChwcml2LT5jaGlwX2lkID09IFJaX0cyTCkgPyBSR0VUSF9SQ1ZfQlVGRl9N
QVgNCj4gPiArIDogUlhfQlVGX1NaOw0KPiANCj4gQ291bGQgdXNlIGEgdmFsdWUgaW4gdGhlIHN0
cnVjdHVyZS4NCk9LLg0KPiANCj4gPiBAQCAtNzMwLDcgKzEwNTQsNyBAQCBzdGF0aWMgdm9pZCBy
YXZiX2VtYWNfaW50ZXJydXB0X3VubG9ja2VkKHN0cnVjdA0KPiBuZXRfZGV2aWNlICpuZGV2KQ0K
PiA+ICAgICAgICAgZWNzciA9IHJhdmJfcmVhZChuZGV2LCBFQ1NSKTsNCj4gPiAgICAgICAgIHJh
dmJfd3JpdGUobmRldiwgZWNzciwgRUNTUik7ICAgLyogY2xlYXIgaW50ZXJydXB0ICovDQo+ID4N
Cj4gPiAtICAgICAgIGlmIChlY3NyICYgRUNTUl9NUEQpDQo+ID4gKyAgICAgICBpZiAocHJpdi0+
Y2hpcF9pZCAhPSBSWl9HMkwgJiYgKGVjc3IgJiBFQ1NSX01QRCkpDQo+IA0KPiBDb3VsZCB1c2Ug
YSBmZWF0dXJlIGJpdC4NCg0KT0suDQoNCj4gDQo+ID4gQEAgLTIxMDQsMTEgKzI1NzgsMTkgQEAg
c3RhdGljIGludCByYXZiX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UNCj4gKnBkZXYpDQo+
ID4gICAgICAgICBwcml2ID0gbmV0ZGV2X3ByaXYobmRldik7DQo+ID4gICAgICAgICBwcml2LT5j
aGlwX2lkID0gY2hpcF9pZDsNCj4gPg0KPiA+IC0gICAgICAgbmRldi0+ZmVhdHVyZXMgPSBORVRJ
Rl9GX1JYQ1NVTTsNCj4gPiAtICAgICAgIG5kZXYtPmh3X2ZlYXR1cmVzID0gTkVUSUZfRl9SWENT
VU07DQo+ID4gLQ0KPiA+IC0gICAgICAgcG1fcnVudGltZV9lbmFibGUoJnBkZXYtPmRldik7DQo+
ID4gLSAgICAgICBwbV9ydW50aW1lX2dldF9zeW5jKCZwZGV2LT5kZXYpOw0KPiA+ICsgICAgICAg
aWYgKGNoaXBfaWQgPT0gUlpfRzJMKSB7DQo+ID4gKyAgICAgICAgICAgICAgIG5kZXYtPmh3X2Zl
YXR1cmVzIHw9IChORVRJRl9GX0hXX0NTVU0gfCBORVRJRl9GX1JYQ1NVTSk7DQo+ID4gKyAgICAg
ICAgICAgICAgIHByaXYtPnJzdGMgPSBkZXZtX3Jlc2V0X2NvbnRyb2xfZ2V0KCZwZGV2LT5kZXYs
IE5VTEwpOw0KPiANCj4gUi1DYXIgR2VuMiBhbmQgR2VuMyBkZXNjcmliZSBhIHJlc2V0IGluIERU
LCB0b28uDQo+IERvZXMgaXQgaHVydCB0byBhbHdheXMgdXNlIHRoZSByZXNldD8NCg0KT0sgd2ls
bCB1c2UgcmVzZXQuDQoNCg0KPiANCj4gPiArICAgICAgICAgICAgICAgaWYgKElTX0VSUihwcml2
LT5yc3RjKSkgew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIGRldl9lcnIoJnBkZXYtPmRl
diwgImZhaWxlZCB0byBnZXQgY3BnDQo+ID4gKyByZXNldFxuIik7DQo+IA0KPiBkZXZfZXJyX3By
b2JlKCksIHRvIGF2b2lkIHByaW50aW5nIGFuIGVycm9yIG9uIC1FUFJPQkVfREVGRVIuDQoNCk9L
Lg0KDQoNClJlZ2FyZHMsDQpCaWp1DQoNCj4gDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
ZnJlZV9uZXRkZXYobmRldik7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIFBU
Ul9FUlIocHJpdi0+cnN0Yyk7DQo+ID4gKyAgICAgICAgICAgICAgIH0NCj4gPiArICAgICAgICAg
ICAgICAgcmVzZXRfY29udHJvbF9kZWFzc2VydChwcml2LT5yc3RjKTsNCj4gPiArICAgICAgIH0g
ZWxzZSB7DQo+ID4gKyAgICAgICAgICAgICAgIG5kZXYtPmZlYXR1cmVzID0gTkVUSUZfRl9SWENT
VU07DQo+ID4gKyAgICAgICAgICAgICAgIG5kZXYtPmh3X2ZlYXR1cmVzID0gTkVUSUZfRl9SWENT
VU07DQo+ID4gKyAgICAgICB9DQo+IA0KPiANCj4gR3J7b2V0amUsZWV0aW5nfXMsDQo+IA0KPiAg
ICAgICAgICAgICAgICAgICAgICAgICBHZWVydA0KPiANCj4gLS0NCj4gR2VlcnQgVXl0dGVyaG9l
dmVuIC0tIFRoZXJlJ3MgbG90cyBvZiBMaW51eCBiZXlvbmQgaWEzMiAtLSBnZWVydEBsaW51eC0N
Cj4gbTY4ay5vcmcNCj4gDQo+IEluIHBlcnNvbmFsIGNvbnZlcnNhdGlvbnMgd2l0aCB0ZWNobmlj
YWwgcGVvcGxlLCBJIGNhbGwgbXlzZWxmIGEgaGFja2VyLg0KPiBCdXQgd2hlbiBJJ20gdGFsa2lu
ZyB0byBqb3VybmFsaXN0cyBJIGp1c3Qgc2F5ICJwcm9ncmFtbWVyIiBvciBzb21ldGhpbmcNCj4g
bGlrZSB0aGF0Lg0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC0tIExpbnVzIFRv
cnZhbGRzDQo=
