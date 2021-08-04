Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4F63DFAF2
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 07:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbhHDFN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 01:13:28 -0400
Received: from mail-eopbgr1410109.outbound.protection.outlook.com ([40.107.141.109]:49024
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229910AbhHDFN1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 01:13:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTIdSI0UUqf2NzY1VPhb2mT3WIIYo+qtfZohaK/Yo47PjW6HnL5EMQzwbPBSOt7nECK0RlTS2HPS5FtoMMcQkqZruxEG4pMIZNVY2NFFz/nyjQpb8fKIQW7gVaHnVef60rVGp8O9Og3yp2du7IMbsnfv+q56lrmuxfvDTt1XvWLE9oakZO/kiNSxltU0vMJ7RpHifN01WUsC4jJdhn99m8N8FCPBZ1z3N8b03Sr/COlpdsBPoFBqutCgqXIWmwg8+fMgZ4il528UpSHFOC0owYPPCozGffk8zcO0S7/yx71jRUAqzSS4ID2xYHQdNuKQ0RNYKKwyh3iPL3+Tk0utBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNuxLG9peIbQdKgYCKc3om2eeX+ueMKFAOdWUMi+i9Q=;
 b=m7PofNWZIqV3aQboDV6BbJFRb4Hw5C+/BcaF66sT72EpeTrrCmrUyNNZPK8v2SGQrz7Z4y+yIqN2p2Cd+rCZts1w+UtyyXZkkW7qr6n08FT5fkJhkKBkPFRhPbSMSkIKRph44nJXQW4Ixtr+hamjYl1NOpk1KdSFMjjU3wAFfX5HIypPapmjZCvPLsE4XUiokewChgNmHln4OgfpqdaEa74QyGqIp7vligELwIhqFV20+aUfP5rcz3gIyr8tV2TuUW30nyQpP4s/4YNefHFaY2TqP1ngtO6G3z5bHHJgX8xwHr/d1K2CybBzqrtFaceRiIW3mH1TQnRDvRZJjSdIfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNuxLG9peIbQdKgYCKc3om2eeX+ueMKFAOdWUMi+i9Q=;
 b=Q5uuZB+qI7FyGLMmtg/sqZd6AU8gxldJrfONXJWsS54QfeoNgnTW75KAS9mUZ51Djb2wbTRA+ZzfWbCh7527DQ8paQKeK++Z+ctyGSF4Tg/o2Mto6s5UstPnK29s/akubEQ1cUDoSmDmBo7S9FE5aNWk0NeLiQlnte3WafVrj2c=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB4801.jpnprd01.prod.outlook.com (2603:1096:604:6d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Wed, 4 Aug
 2021 05:13:12 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%8]) with mapi id 15.20.4373.026; Wed, 4 Aug 2021
 05:13:12 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
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
Thread-Index: AQHXh4kJVg2tFXlcHEytJvY9Z7FsDqtiSZqAgACEk/A=
Date:   Wed, 4 Aug 2021 05:13:12 +0000
Message-ID: <OS0PR01MB5922974FA17E6ABB4697B6B986F19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-8-biju.das.jz@bp.renesas.com>
 <ad727120-3ae6-4db7-e368-f06c82cfa759@gmail.com>
In-Reply-To: <ad727120-3ae6-4db7-e368-f06c82cfa759@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4640d51a-47a3-4645-e5f4-08d957068e9e
x-ms-traffictypediagnostic: OSAPR01MB4801:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB48011B7F1481A687259EE8BA86F19@OSAPR01MB4801.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zw5rL4rNIVRZyMB76PGs94te2FrSh82ZyQx6CMYEidrirnq6yYW71nDH+Xj3Jpzr6YlvrKNBtSzaFX10VhxwX9Fi9LjAmNzXLM6PVCBQVaDc1B5rT7konn6XjIXOpszycOO9ia67Dhkk3UrmKlcfjEKeflF3k4Njjij4+pMFyKIyCoI2lPD1V34r7lbPILEIVE6ilMJdjT1NX2PJ0C8g3jHcuksqE9jedk85l5WRG9Lr5oHwk/jzQx0KWQGNORlxYaiHsOAXDFEB4iuO6TiBfLpsjqY9JLPwj7XomtT9Hb2EvnGKb0+6ADHKoCNbbLiPyem1NH5hQkJh5RZjpPlxFDkpHkakXLig1+IcXIsuyBZYraQTzMPCxHc8wQWSw5nVxangw97WKSlno7ZNtOet/ujBhA1hkys49uC92tcKQpHHqGlUn7uOJ84OZjlbvzQJlBmM8RYXDLBxAOSWEeKCDnK20iq/x77kD6Y03iDA5ajhC9QJYFVzd0IjmDxj/lOCHMi260J4LoRE1os7t5MfmelgQ2eOerXe9Z6W9hKhdVhILbhpman+0Pe2/0On5UNEkw9TssI+JU0N5LpjxMWI79S1/mtJzclglpdEjuURfHsPr2p9mU3Z4FYQuKNhqwxTiQfBqCxDYG+voem/yuRimxYmoVyoMgcZ9tNsw0JxnxVGXm1P1YL5aGgS50adNUEba6ENE5h36IIHaH7qeCu4Cg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(33656002)(6506007)(478600001)(71200400001)(66476007)(107886003)(316002)(54906003)(122000001)(7416002)(110136005)(26005)(86362001)(38100700002)(66556008)(66946007)(76116006)(9686003)(64756008)(66446008)(7696005)(5660300002)(4326008)(186003)(2906002)(52536014)(8676002)(38070700005)(8936002)(55016002)(83380400001)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3VGbXVHZjB5UHJJYXI4SnhRZURDaWo4dTZQRG1kbDMwbDBWZEVFeFcrTHhm?=
 =?utf-8?B?WVBaNSt4N2hWRGVyTkFUSTVQSUlpRHBkMUJSWEdSQWlTOXNyemtLRmoxbm5i?=
 =?utf-8?B?UEZVUldSOWcrOFdLWGc0YWI2OG1HSE0vY09Yd2o0azNzbHBFcWpXMEk2NFND?=
 =?utf-8?B?RXhlN1dTd0ZPVVFGSFUzaFFiNVhPbUpRZ0praFljVndsNlVZcEJPajFiM0I2?=
 =?utf-8?B?NDJRbjRNbmdiMURReWhRNmt5WkRac1lNcnpJdmpPZHlQZGlYOE5WbUVoR1FS?=
 =?utf-8?B?bk43K3N6NWZqRGdXTUk4T3Z5TXowaWxsSjVIc0RySEhKbmxWRWNYdVVPTWQw?=
 =?utf-8?B?U3MrT0puWFE1cVppWFFPK2d0WEFYdDZkN2UrZDd5em5yRzBIa2tqcjE2a1Bo?=
 =?utf-8?B?YWczZlJlSmdHSHdlTzZIOUVPYUQ4SnR2UmhDbERndi9Tb09XemtBMnlLNk9H?=
 =?utf-8?B?a29nbjRVTCtNSW9RNGNNK1NiZ2FyelRqV3h3NjJQV3UzWkFqNFEvOGJPVTJP?=
 =?utf-8?B?Y05YNnZBQmJXQVNUWHZiYXdGRnVrVmpUUm04dGtiNS9NbndEV1AzbFAwQnI3?=
 =?utf-8?B?RHRCc2NFcFVOWU9zdUoxSDZmR0dOaXhNQmpaYjNJMmtWSTJabFJKNlZEak01?=
 =?utf-8?B?bG00OTdjZVlJTU43ZVQ4TzhmdVdhcTJVUlh1aElYNG8wb2VSWDVmbTE0b05M?=
 =?utf-8?B?am1VK01KMFhORzlmMnZEN08waUNJVHorN3I4V3d1RXJUZHZZYTJVV3ZROWJL?=
 =?utf-8?B?ZmloZUVPREYwd29jMWdINWU3TDJLa21VTzB3SG9UL0VmcU1Ya1ByQ2VMam9w?=
 =?utf-8?B?YmpjVWpnN0RHMHYycGJEbmg5K1ArU0JBMEwrSlZwTS9BUVBuWXJ3RkpYOHNY?=
 =?utf-8?B?VldONzBvTm1RTmR5RGRLaWQzdk1RWGlpbVkwUGhLeWl5WEF5aUFYcFpFTzdX?=
 =?utf-8?B?djNYZWFMN3NkaFVzeHZlL0tTeFY4YkpIZmhvVG1kcmZXSjk5OERHa3BnR1F2?=
 =?utf-8?B?WjdWdXVQcEhxMHErYWsvUnRRa21DMGhQcXJFc0JXMGVGL3liUTZsWFpiWExk?=
 =?utf-8?B?Zi9aVnRHRDBRU000cmFvU08xODR3bU5kYnpwK2laaGNqdFdiaVJpa2dtZnBV?=
 =?utf-8?B?L3EwcmFmdCtadVlrQkRxbjdsN01HTzlwaUhsMVNkaDYyS0ZxaGVVOUc4MTFw?=
 =?utf-8?B?UHhPZWN3M2pZWFFoL09vcHZpRlRjTkI0SDloM01nN09rdkI2elREeitzcm00?=
 =?utf-8?B?VlNOcnlha1Y0ek9xc2RCVCtNWDFWTFBQRFFFRkIrbGl0RmlNUktnTVdYdjZh?=
 =?utf-8?B?OEhBOElIRnFGZm5PeUE4M3BHaXZuMlJML1NvcnkxSENQSm9FYmx5WGYwMUh2?=
 =?utf-8?B?cE5GSS96N09NS280VW9KdHJtZkpYa2NVWDNMV0R6Q3hpYlNvK1FuRm0vRHEx?=
 =?utf-8?B?ck1iQjFVTnAzRDVWYW5jc1N4RjVhbHZ6NXNZVmtCaG5wWGFuYmMyY1ZVeXZW?=
 =?utf-8?B?K3RNbE1aN0xBdDFQWnMxOGVITkNmOVlNcGZiRCtGem9jUk5ockNUdUNvQzBR?=
 =?utf-8?B?TGxKZXRnLys1eUsvdlNHRDlQQUo5Z3BTZXlCanJaZU9yK052RG5yOWFyaHgv?=
 =?utf-8?B?ZTRLZFZMRjVWaGRqODJuUzBWNDZVUWh2YlBEc3E1UnVPVE9nbjBybGRhRkVZ?=
 =?utf-8?B?akFXM3RGR3NrNENEU1dMYUNLcEJJZGowSEMydGJZYnhkc3FsRTl1UStDYTJQ?=
 =?utf-8?Q?4aKAP1F9uwrJTG/vQC51KmQxzCu0MGXUpQz3HMo?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4640d51a-47a3-4645-e5f4-08d957068e9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2021 05:13:12.0867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YjRNqbDp4Remj4vq80koKnb14yhN82g46p54Em4AO5wR7bM01fiYWDUstA5Vl88EyTqj7/IqgoeWgq2LcmDZLIa0/4XaLRoGdZx8nkVZZag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4801
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjaw0KDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggbmV0LW5leHQgdjIgNy84XSByYXZiOiBBZGQgaW50ZXJuYWwgZGVsYXkgaHcgZmVhdHVy
ZQ0KPiB0byBzdHJ1Y3QgcmF2Yl9od19pbmZvDQo+IA0KPiBPbiA4LzIvMjEgMToyNiBQTSwgQmlq
dSBEYXMgd3JvdGU6DQo+IA0KPiA+IFItQ2FyIEdlbjMgc3VwcG9ydHMgVFggYW5kIFJYIGNsb2Nr
IGludGVybmFsIGRlbGF5IG1vZGVzLCB3aGVyZWFzDQo+ID4gUi1DYXINCj4gPiBHZW4yIGFuZCBS
Wi9HMkwgZG8gbm90IHN1cHBvcnQgaXQuDQo+ID4gQWRkIGFuIGludGVybmFsX2RlbGF5IGh3IGZl
YXR1cmUgYml0IHRvIHN0cnVjdCByYXZiX2h3X2luZm8gdG8gZW5hYmxlDQo+ID4gdGhpcyBvbmx5
IGZvciBSLUNhciBHZW4zLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUu
ZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBMYWQgUHJhYmhha2FyIDxw
cmFiaGFrYXIubWFoYWRldi1sYWQucmpAYnAucmVuZXNhcy5jb20+DQo+ID4gLS0tDQo+ID4gdjI6
DQo+ID4gICogSW5jb3Jwb3JhdGVkIEFuZHJldyBhbmQgU2VyZ2VpJ3MgcmV2aWV3IGNvbW1lbnRz
IGZvciBtYWtpbmcgaXQNCj4gc21hbGxlciBwYXRjaA0KPiA+ICAgIGFuZCBwcm92aWRlZCBkZXRh
aWxlZCBkZXNjcmlwdGlvbi4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVu
ZXNhcy9yYXZiLmggICAgICB8IDMgKysrDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcmF2Yl9tYWluLmMgfCA2ICsrKystLQ0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDcgaW5zZXJ0
aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVu
ZXNhcy9yYXZiLmgNCj4gPiBpbmRleCAzZGY4MTNiMmUyNTMuLjBkNjQwZGJlMWVlZCAxMDA2NDQN
Cj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+ICsrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gQEAgLTk5OCw2ICs5OTgs
OSBAQCBzdHJ1Y3QgcmF2Yl9od19pbmZvIHsNCj4gPiAgCWludCBudW1fdHhfZGVzYzsNCj4gPiAg
CWludCBzdGF0c19sZW47DQo+ID4gIAlzaXplX3Qgc2tiX3N6Ow0KPiA+ICsNCj4gPiArCS8qIGhh
cmR3YXJlIGZlYXR1cmVzICovDQo+ID4gKwl1bnNpZ25lZCBpbnRlcm5hbF9kZWxheToxOwkvKiBS
QVZCIGhhcyBpbnRlcm5hbCBkZWxheXMgKi8NCj4gDQo+ICAgIE9vcHMsIG1pc3NlZCBpdCBpbml0
aWFsbHk6DQo+ICAgIFJBVkI/IFRoYXQncyBub3QgYSBkZXZpY2UgbmFtZSwgYWNjb3JkaW5nIHRv
IHRoZSBtYW51YWxzLiBJdCBzZWVtcyB0bw0KPiBiZSB0aGUgZHJpdmVyJ3MgbmFtZS4NCg0KT0su
IHdpbGwgY2hhbmdlIGl0IHRvIEFWQi1ETUFDIGhhcyBpbnRlcm5hbCBkZWxheXMuDQoNCkNoZWVy
cywNCkJpanUNCg0K
