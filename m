Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752EF3DE666
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 07:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbhHCF5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 01:57:43 -0400
Received: from mail-eopbgr1400119.outbound.protection.outlook.com ([40.107.140.119]:48963
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230096AbhHCF5m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 01:57:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eb5B2iC4mo8ohmSSO2npbh2JovpC6Gp2PMpwrG9Ky6Mgk4LdbLqZ6CuwiK3lpvyG86PGSBfBjqDDxTFD7HQzLW7GDaHMq/CFS6m+mZiHbFdPtay4cnwqaEF8PMuG5IVn3Fbbeu8hINoKIiFqrGaeHnlRkdtYIAcMDL+ZJTsCsp2UU7ApzH2EhKYzi2t98BklFlRrNahaWJF1Ye7GmwSSHje64tMH2eGDNBPelw9QKff8nNzbIV87ZOemlDIouRuNDuQpLFBYpyNK3vFV+Ux5HeV4UZfTpcrV1371Gatc7JwaboLriW5eAAg9o+goPWRQQOJCLNzEoU9FTo4QgRf10w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYQmKxJBu7ukdYDK5MUKDBQBkd7r8HdxvU2Uz9HaZXQ=;
 b=HbCOnDipy4pTfP7IFlUbdqmOEvdrlgtimhkORY0/FeQ27jaCGbi7XXnrYeqeFuf1TXg4u/pjWtIY3hHb5oG7yDd/6OmaFVWzScTMGnfoTCFXvChlUkiXF/gROYTtkM3lORgCqs8AEsDCdML0Gq5EkCgPSdeT0Kj1DCNQdD0sr+Y7tHPgBkiKWsXNU1lOe31L1lqETIABHFWsrhpdE0F1yYDooZIggq6BcXj7psIrXDN2MS+TpsV4EvUWcvglO0hFszAkPCtDWvwd3er9kjpKZ2oQJq/+fpkVXgpAFbUka6AtB54mNcJXZQBPuYmWn2GpbiURSrw9tx4kR1UlzUxExQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYQmKxJBu7ukdYDK5MUKDBQBkd7r8HdxvU2Uz9HaZXQ=;
 b=fCTJwDX5jFcnuAk+WACA+zxxj6toW7COzDOmcc/ybWJl+GeollXeq6HCKhOy8Hc1Glp7ugYAc85Sv7UoJn4ycSd+S7ctvOu4xUfC8K9cWk3y71zcInMw68pFazi5aB3x7roz421nt7Lcp8xTSkm7HBkcUsPyY8/snMQzgB8lqSY=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB3861.jpnprd01.prod.outlook.com (2603:1096:604:44::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Tue, 3 Aug
 2021 05:57:28 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%8]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 05:57:28 +0000
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
Subject: RE: [PATCH net-next v2 1/8] ravb: Add struct ravb_hw_info to driver
 data
Thread-Topic: [PATCH net-next v2 1/8] ravb: Add struct ravb_hw_info to driver
 data
Thread-Index: AQHXh4j0+2cGRDLtLUyHm25tLRdYvKtgrrIAgACX9QA=
Date:   Tue, 3 Aug 2021 05:57:28 +0000
Message-ID: <OS0PR01MB592289FDA9AA20E5B033451E86F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-2-biju.das.jz@bp.renesas.com>
 <e740c0ee-dcf0-caf5-e80e-9588605a30b3@gmail.com>
In-Reply-To: <e740c0ee-dcf0-caf5-e80e-9588605a30b3@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2596dc37-8f03-40b6-9616-08d95643934a
x-ms-traffictypediagnostic: OSBPR01MB3861:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB386137E6A4557546374E7F3786F09@OSBPR01MB3861.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4LvsamVos0LT7DFjymnhhaZIL2kp0cmPGlauD+bbiZhZt8mb3p4K6p6JtDFN0LvI3Rf5a+C89/+tWrYJ+XjhyR2x3fZE/Xfr2gooUofy65nzpcdrsqyPn4uSRFLFCgDCKKf6/tYNPQp/+3rcNrKs4CUVS6whg0VY4ToK7Ypz8tUOJtExMFPxH55SDX88GlBkLZ8twODcKQxAQzQgGbJqMttpa5/17HFu1ZNyPTTQVE4p7xVx2EXhas+jbzQhHyZ2r3l5X/MvYMf9SIo6DpPHB4SYLhCRpCyaXutA5PPaSGcnXpLiXTxc4WgQ155Du2lQW0sMmvhnF5nMrHlo5gST/FS7hoZ4j9TqHuJwPxlS09Y5q9DvZ2EU7iJfS/i1DVdHS8ifGEi9bTxEvA6ZxF9+sp1P+M30eLgAbr3JNxpJSlBpObNVwcoboBawoJ3tOmFAa7RnwMqLtL1eJYs/wkgPMw1bZTaTLG07j5bza/w5SN3vlPlJmeyNu148XRWu2JALVNuYg2/rITkaDdYPtz9xGlYnvu9/HF0T3m690vx25JscMTo8KBvzk2QsV5RAp8Grcd8wRwZC1rz3NWGFu/8skKPxRpabuq14L+dDW2kio456tvAt3LSj4hcj2u+QzV537nVP28+x+LDn4t0y4IngSZYWCLdBCeVIuce+HwYaEoJZGzCBHGNLDMZdEo+VpQGLBOlyZzCy6BiudiT350ErOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(4326008)(2906002)(7416002)(54906003)(33656002)(71200400001)(38100700002)(316002)(86362001)(66446008)(64756008)(122000001)(5660300002)(110136005)(83380400001)(66476007)(66556008)(66946007)(6506007)(53546011)(26005)(38070700005)(186003)(52536014)(8676002)(76116006)(8936002)(7696005)(478600001)(9686003)(55016002)(107886003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N1dyTzdkRmN2eWtacmV0d1FFcnJNTlNIUUpyRlZKK2VNeXJwL0hIV2REVnAz?=
 =?utf-8?B?MVFpYmFtak1ENmROWlRFdmpoMHl0cnhNRGNwTTd1VDRFa2hHR05YWERDSll1?=
 =?utf-8?B?L1NqYis3eVhTdE9oaUozWnlHb3paaTY3L2VySGIxRUpWK0VpWlJtS3I4UnhJ?=
 =?utf-8?B?SHdTWmduaW5INVBQUmZZU0VBMjNUZEpGV0hyMXpMRklYenRpK0FTVHVScnVO?=
 =?utf-8?B?NkpoWHdiQUpuWHQ4SFNET21vcWZiZDZnNlNpQUZmeWc3dmZMZGpSc0w3QWhu?=
 =?utf-8?B?V09xQllGUFlSbXkvaENzMUlIeW91Wnd6Mmhybmd2YkFLcWFlM2lSSTQweU5H?=
 =?utf-8?B?U0VaMm9SQnVtNTMyNDFqdjFHL1Z3TE4rbC93SGdqelRRbDAwZUdvVW43M09p?=
 =?utf-8?B?SjlZVXpuZjQvem5IU09KNnZpVHRUWXRSWm1McFZOQ2FhOTVtRXpOMmljZDhS?=
 =?utf-8?B?QjBiTXVrODY3U3lTSFRpeko0N0pITmlXOFUzRnBUUWtrZjZiZk5ZWDJETE5t?=
 =?utf-8?B?ZkVVQlhHSkswdkR2dWl0NFR0RVhubTRQUWFYMnF2NVpzS3czc0dISzJnR0tD?=
 =?utf-8?B?NUE4WHpyRDdjZWQyaXN6QjQ4aFBPYjlDemRyYm9MVmdYTXI3bU5QTWJ6K0lC?=
 =?utf-8?B?YVZ2NnJRcGE4UkhDWFhNdi9YbHpzdmdqQlVSbDFxZ3ZZM1J2aDlzSWJiTjRw?=
 =?utf-8?B?RVJDaDAxbGUxSHp5MHlTb3gvRWJSR3d1U0RGSnREdC9QZTlTcEw2TXdBL3FS?=
 =?utf-8?B?dUxobG5BVUpmL1VoWmhscURFSERjQUVEcTVDeGNublpHeEZCTUFWNGRsa1VU?=
 =?utf-8?B?V0dvL1c0U3V0b3VlWHVsa2dxeE00RjQ4K0RpUlhGNDBhYVEvdGp2aWhQYUtz?=
 =?utf-8?B?SUpCRVNrMEd2c2tsVjBXUEdDampWL3B6a1oxOFNnWENvdzhvbUt4YlBQcU9D?=
 =?utf-8?B?QUJyQmVGdFF1TDZ0dzI5NklBR3Q4M2RLM1lJQ0xLSndHNnZPUjBic0ZsbEho?=
 =?utf-8?B?aVlJRTFFaWRJZWxiM0dvSmFTaFBNbVI4YzQzbjU2LzRSb0NnTTBJOGpoMmgr?=
 =?utf-8?B?WU5ibGZTTlp5SkVFS3hWSmxsVFVweDRuUUdyQTJ2NXBtUVd5N2p3cC8xOVV0?=
 =?utf-8?B?d1ZBTVdaMkUxYUFpV1V2Nng0SHUzY1hDT2R5U0tJV3cwUlh2SmN1empGN2o1?=
 =?utf-8?B?Szh0UXR4WDdOYWkrNmVDNnR2TTh0TGx3NE5qQ3J6NmNsYWJoM1c1OFh6Qjcz?=
 =?utf-8?B?dGo2aHcwQTlFZStKeHlHR05Galk3MWZqRmVpOWNCNFF2MHFWaUdJZW5xcUls?=
 =?utf-8?B?bXZyR0FSa0hzSDhBSkx2bGlpTU9KYVhPUytRcWsrYlNSeHY2d2dMcTFKeGdF?=
 =?utf-8?B?TGoxV0JtaE4zeFRnVERlZnZyb1BiTS9jVnhVU2xka3k1UklzT2lsZ0IvODZC?=
 =?utf-8?B?QzBTTTIyMFJWT3pSM2hsaUh4dUxteW9jQk56R2dRbitYK3k4czlTemlmWFRl?=
 =?utf-8?B?ZjNiSGJDSFBXaVN6LzI4OUhCNGJPN2xhd1ZWdVl4ajNodXMwSGtOT1lYUlYw?=
 =?utf-8?B?UXhHT2V4NEFzT1RHdlB6VUdGUG1FbWVXUk5RY0xCN2Q3UkpWY3ZBUGtkd2Zt?=
 =?utf-8?B?d3Z6ckRmVkZRakhsRUVRdTZScWw0NWdhZG53bWY4T2NTbG94a3JJSXZvRW45?=
 =?utf-8?B?dFpBak5NcnlmdG5hMDJvV21wVUZRbXp1L25RYjdRRDBSZW16ajdOV25zL3Rm?=
 =?utf-8?Q?s8Dj9SYP4P02MR+Kcy2AXeHhPPk5LzoIlkNSosu?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2596dc37-8f03-40b6-9616-08d95643934a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 05:57:28.1093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZB1n6LEzZPuPepB9J8IXGA8RmDwN8PLuP295M9DiGqhG+u5K2+xQCcVeh3ttC0YgGvn5ePJlYl/GQClkZg/xuTvrq01K78d3pnEjx7k9Fr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IHYyIDEvOF0gcmF2YjogQWRkIHN0cnVjdCByYXZiX2h3X2luZm8gdG8N
Cj4gZHJpdmVyIGRhdGENCj4gDQo+IE9uIDgvMi8yMSAxOjI2IFBNLCBCaWp1IERhcyB3cm90ZToN
Cj4gDQo+ID4gVGhlIERNQUMgYW5kIEVNQUMgYmxvY2tzIG9mIEdpZ2FiaXQgRXRoZXJuZXQgSVAg
Zm91bmQgb24gUlovRzJMIFNvQw0KPiA+IGFyZSBzaW1pbGFyIHRvIHRoZSBSLUNhciBFdGhlcm5l
dCBBVkIgSVAuIFdpdGggYSBmZXcgY2hhbmdlcyBpbiB0aGUNCj4gPiBkcml2ZXIgd2UgY2FuIHN1
cHBvcnQgYm90aCBJUHMuDQo+ID4NCj4gPiBDdXJyZW50bHkgYSBydW50aW1lIGRlY2lzaW9uIGJh
c2VkIG9uIHRoZSBjaGlwIHR5cGUgaXMgdXNlZCB0bw0KPiA+IGRpc3Rpbmd1aXNoIHRoZSBIVyBk
aWZmZXJlbmNlcyBiZXR3ZWVuIHRoZSBTb0MgZmFtaWxpZXMuDQo+ID4NCj4gPiBUaGUgbnVtYmVy
IG9mIFRYIGRlc2NyaXB0b3JzIGZvciBSLUNhciBHZW4zIGlzIDEgd2hlcmVhcyBvbiBSLUNhciBH
ZW4yDQo+ID4gYW5kIFJaL0cyTCBpdCBpcyAyLiBGb3IgY2FzZXMgbGlrZSB0aGlzIGl0IGlzIGJl
dHRlciB0byBzZWxlY3QgdGhlDQo+ID4gbnVtYmVyIG9mIFRYIGRlc2NyaXB0b3JzIGJ5IHVzaW5n
IGEgc3RydWN0dXJlIHdpdGggYSB2YWx1ZSwgcmF0aGVyDQo+ID4gdGhhbiBhIHJ1bnRpbWUgZGVj
aXNpb24gYmFzZWQgb24gdGhlIGNoaXAgdHlwZS4NCj4gPg0KPiA+IFRoaXMgcGF0Y2ggYWRkcyB0
aGUgbnVtX3R4X2Rlc2MgdmFyaWFibGUgdG8gc3RydWN0IHJhdmJfaHdfaW5mbyBhbmQNCj4gPiBh
bHNvIHJlcGxhY2VzIHRoZSBkcml2ZXIgZGF0YSBjaGlwIHR5cGUgd2l0aCBzdHJ1Y3QgcmF2Yl9o
d19pbmZvIGJ5DQo+ID4gbW92aW5nIGNoaXAgdHlwZSB0byBpdC4NCj4gPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiBSZXZpZXdl
ZC1ieTogTGFkIFByYWJoYWthciA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJwLnJlbmVzYXMu
Y29tPg0KPiA+IC0tLQ0KPiA+IHYyOg0KPiA+ICAqIEluY29ycG9yYXRlZCBBbmRyZXcgYW5kIFNl
cmdlaSdzIHJldmlldyBjb21tZW50cyBmb3IgbWFraW5nIGl0DQo+IHNtYWxsZXIgcGF0Y2gNCj4g
PiAgICBhbmQgcHJvdmlkZWQgZGV0YWlsZWQgZGVzY3JpcHRpb24uDQo+ID4gLS0tDQo+ID4gIGRy
aXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAgICAgfCAgNyArKysrKw0KPiA+ICBk
cml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jIHwgMzgNCj4gPiArKysrKysr
KysrKysrKystLS0tLS0tLS0NCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAzMSBpbnNlcnRpb25zKCsp
LCAxNCBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiLmgNCj4gPiBpbmRleCA4MGU2MmNhMmUzZDMuLmNmYjk3MmMwNWIzNCAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+ICsrKyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gQEAgLTk4OCw2ICs5ODgsMTEgQEAg
ZW51bSByYXZiX2NoaXBfaWQgew0KPiA+ICAJUkNBUl9HRU4zLA0KPiA+ICB9Ow0KPiA+DQo+ID4g
K3N0cnVjdCByYXZiX2h3X2luZm8gew0KPiA+ICsJZW51bSByYXZiX2NoaXBfaWQgY2hpcF9pZDsN
Cj4gPiArCWludCBudW1fdHhfZGVzYzsNCj4gDQo+ICAgIEkgdGhpbmsgdGhpcyBpcyByYXRoZXIg
dGhlIGRyaXZlcidzIGNob2ljZSwgdGhhbiB0aGUgaC93IGZlYXR1cmUuLi4NCj4gUGVyaGFwcyBh
IHJlbmFtZSB3b3VsZCBoZWxwIHdpdGggdGhhdD8gOi0pDQoNCkl0IGlzIGNvbnNpc3RlbnQgd2l0
aCBjdXJyZW50IG5hbWluZyBjb252ZW50aW9uIHVzZWQgYnkgdGhlIGRyaXZlci4gTlVNX1RYX0RF
U0MgbWFjcm8gaXMgcmVwbGFjZWQgYnkgbnVtX3R4X2Rlc2MgYW5kICB0aGUgYmVsb3cgcnVuIHRp
bWUgZGVjaXNpb24gYmFzZWQgb24gY2hpcCB0eXBlIGZvciBIL1cgY29uZmlndXJhdGlvbiBmb3Ig
R2VuMi9HZW4zIGlzIHJlcGxhY2VkIGJ5IGluZm8tPm51bV90eF9kZXNjLg0KDQpwcml2LT5udW1f
dHhfZGVzYyA9IGNoaXBfaWQgPT0gUkNBUl9HRU4yID8gTlVNX1RYX0RFU0NfR0VOMiA6IE5VTV9U
WF9ERVNDX0dFTjM7DQoNClBsZWFzZSBsZXQgbWUga25vdywgaWYgSSBhbSBtaXNzaW5nIGFueXRo
aW5nLA0KDQpQcmV2aW91c2x5IHRoZXJlIGlzIGEgc3VnZ2VzdGlvbiB0byBjaGFuZ2UgdGhlIGdl
bmVyaWMgc3RydWN0IHJhdmJfZHJpdmVyX2RhdGEod2hpY2ggaG9sZHMgZHJpdmVyIGRpZmZlcmVu
Y2VzIGFuZCBIVyBmZWF0dXJlcykgd2l0aCBzdHJ1Y3QgcmF2Yl9od19pbmZvLiANCg0KUmVnYXJk
cywNCkJpanUNCg0KPiANCj4gWy4uLl0NCj4gDQo+IE1CUiwgU2VyZ2VpDQo=
