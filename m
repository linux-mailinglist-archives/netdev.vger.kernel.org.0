Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11EBF3EEB8E
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 13:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbhHQLZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 07:25:30 -0400
Received: from mail-eopbgr1400113.outbound.protection.outlook.com ([40.107.140.113]:1216
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236541AbhHQLZ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 07:25:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kz/TkxZ8jWspkxpB+xlinZeMGjU5pFg1uLyx92ozPOhUd29Y8ZbKWX6mSuwYjME8pWQ0N5hELqd8eoxrQL15DZ8ZdnP6LhVoe3HFFUcWbv7BGQhwAab8pu28Bg0CYmK43HxdSeUqUS8LPbsP+7WTH+iBKwaeXl1VyYF7PFerxPSSkqWWP4S119LCq2R020LKoSwtZdEoT+Jwq2rZNiYM7CgJfyoZFq8DFMF7Oe64eMiMLB4gtedoIURiWJ9ehs9QpRLqmWipVOyFrINWH94rr6ZfLyGKzE4D4xdC3E5a25VsQG9tO0MkfZ29F1gHzg2h4fFxd1gB/haz4GQqI+GTDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AN83d7s6QH4oVluvJwk9W857tSsJ5VROIpHpPGDEpIQ=;
 b=TxQWLsnhQ5zTVS/tKi/BNnSSlH0TWAPDdZ9+8XcHbkyoigEEfO70yF/7bYoFwT0Pv9J+Kii8yfhMJ6JN3LfS2Idf52NrPafxS/zGt65n0I4WPOyN5Et26aJ/TGqiLTxWG0+Dxf9BjcLlCp/ldRwLyR/ODpX6NLIRHi6Pis8u7SliNoXmcP1IuVMqLIpWeCE9JOjCJJUFOHoVeotkTrV/PCbOFwyTKRtCXmIEQXMFOthSM8GPhSxEs+Zv/U9xO3VIwNTp3CkEpdyfO00Y7u5m/J4tcopAjovBGP0BrLzvl/1lzo8W5f5q5x5+3KekWFfsr8wtg6Tik6loh49wK5B+Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AN83d7s6QH4oVluvJwk9W857tSsJ5VROIpHpPGDEpIQ=;
 b=reINUx6tCVDYYWZ2Vea1SomRFUq6l0S2hyEB65ZEEa3+/JzoYS7aihVTKX7Y5ukAmAssxlBIsR4skw8VBMgYa6LYssxDpL6K00jnZnJdClMwsrB1EzHusA7eTD2Dj9sdkAuelFw06Mf3XUlPLAV+1USaROEKkPc6kKlRCwKwfOE=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB4344.jpnprd01.prod.outlook.com (2603:1096:604:7f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Tue, 17 Aug
 2021 11:24:53 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 11:24:53 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH net-next v2 1/8] ravb: Add struct ravb_hw_info to driver
 data
Thread-Topic: [PATCH net-next v2 1/8] ravb: Add struct ravb_hw_info to driver
 data
Thread-Index: AQHXh4j0+2cGRDLtLUyHm25tLRdYvKtrHuUAgARm9NCAAArSgIAAA4CAgAgRGKA=
Date:   Tue, 17 Aug 2021 11:24:53 +0000
Message-ID: <OS0PR01MB5922A841D2C8E38D93A8E95086FE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-2-biju.das.jz@bp.renesas.com>
 <CAMuHMdWuoLFDRbJZqpvT48q1zbH05tqerWMs50aFDa6pR+ecAg@mail.gmail.com>
 <OS0PR01MB5922BF48F95DD5576A79994F86F99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <CAMuHMdVCyMD6u2KxKb_c2LR8DGAY86F69=TSRDK0C5GPwrO7Eg@mail.gmail.com>
 <OS0PR01MB5922C336CBB008F9D7DA36B786F99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB5922C336CBB008F9D7DA36B786F99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a7d0b31-3bd0-4f8c-7549-08d96171a24d
x-ms-traffictypediagnostic: OSBPR01MB4344:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB4344EAE48E5026747085A42686FE9@OSBPR01MB4344.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jmeZ09+gg/ZhdL+PGXtnjidnA+N8hD/zxc1jVFXzx0L2JU3aD/WD1t53hDgg5pBGuASiiVRhFJQZ/x/ZiYmxLGWJw3lehFXRS+2COKOvfhnhb/Mts9cuq7avEM9R0BGAJIYVNnoH8xlycgoNJtg9yGUR2BkUTMTv8pIYO5FdPG1AGRbJh8RJvQRPrpjSQhiJcCmO+/HrchATaLQHT5RUy2UVjitQ9gnYbkBMho+VUMnLNkT2CHP4TLxnxmZbkoSF18UXgSzspRxOKQyCdkEE9uP78KJTO8wK+6Hl7pB6JwJ5g4Q9c9b/z3KtqpU934CYwd1UNHG5BmUjk+EedQ11HXRThLZxn+TY2KJiQW8j4MjphD8Yi9cT5H6wtwzesvI/Q6V/Su0Q7VgT3pLm8405VKiBJnxd/QxPWxTZJNRIANg73U+Cp9v2b52MxJvbHRTF/CQDaEKPfzqNsihBke1RinwG0DFpvMPKTXkIHbf/ATWkNW1zqwoJN/jLf2rPn8xMIm9aBEklv4FAAdPFrF2gE7G+3D/6DGBBoLSYzrG/Yo0+BEo0C9M7HPzC0MnH2x/T2Hzby6KQT1WFPgSwOI9VvNUFmlWwXLO4vvEESPYOjD4LGnc3k9yMJS31eN2a41IhsmUJIoFGpwJVmSewrwkFN/jGc17Ft4xCzRPM1Ptr4P2VAi26GZGFjUzyrgAlJi0ljWac+gT0g6iMFYi7IxG7JA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(7416002)(33656002)(26005)(110136005)(4326008)(52536014)(55016002)(54906003)(9686003)(86362001)(186003)(38070700005)(8936002)(64756008)(66556008)(66446008)(8676002)(66476007)(122000001)(2906002)(38100700002)(5660300002)(76116006)(53546011)(6506007)(66946007)(316002)(478600001)(7696005)(71200400001)(107886003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SGxNWm5FYnJodHIyWk5nQlhRdm1OTWtVWklKbEhpV3NBd1creUhNZ1IyejBD?=
 =?utf-8?B?NzFwU2p3T0VVZXBIQTNRM2EwWHUzMkh5bWVOTkE4bGdvUThWN3VwbFhUSDdr?=
 =?utf-8?B?ODdKa1VTTVY5RmhEMFNsNktaWG9qQyttVE1raXhQeGgzUnZXbUJmYWVuSitX?=
 =?utf-8?B?RjNYZTN1V29YR3RIZksyc0d6SnJLOUFDTE1oa2ZhS1NVQWh1RnhoWks3NXRX?=
 =?utf-8?B?ekNvZVd1ZVJNNmhvYWYzelNMaCtncEtWYXdiN0p6cUl2OThtcHlSZ00zTm9H?=
 =?utf-8?B?cm5kRTFORkx3Zk5GRTlQTG43QmdSWEtxem4yYnpGRTBjdzdZTWlENmd6bGpZ?=
 =?utf-8?B?MGtuakREVEZJTlB5OXpPc3ZIZXU4RG4zeWQ5YXNaRW44d0QwZFZuaXB2ajhy?=
 =?utf-8?B?RDBmUlJiR1ZpWjlKK20yVEh6cWJORTFoWDJMVkxKV0JOcnhzaUNTM1RoL2px?=
 =?utf-8?B?bDAxNFFqYjN2VGl3NmVWZ0pIMTFHQjI3T04xU05xSGN1Y1N4KzBxOWNnaDY5?=
 =?utf-8?B?OUdSSXZselJlTFRmdms0anpqclhucjZwMjFQRVAvQm1HUURNa3I0TjZRQ0R1?=
 =?utf-8?B?Mk9SdmgxWGZSMGNOZEQ5dHNaSXo3eUFwOHhoSFduNXc0UFVYOHVpTWZTYlQ5?=
 =?utf-8?B?c1VGUkprcVphak1JbGhiL1FwWURZRjJudkllZXYvUEtsUWVVZnY0TlJCWHN5?=
 =?utf-8?B?V2hHSWMrcms1UkNERWo5V04yZU9uOGF6S21aUytBeHJ5bFJwS1orTk1sQlhn?=
 =?utf-8?B?azFsNDJFZG5NWGxHMThVSzZWdVMvWllydUZBejkzdWdxRDY3VllVbW0rbnVX?=
 =?utf-8?B?SFI4cDZ2YUtMOENGRzZld3NoOWdZdGZPSmVyK1MxYk5BSXRUelJqRVhjbVJH?=
 =?utf-8?B?NjQ4ZDQ4TmFlbHh6bWVYVnd2ZWJ2bUU5ZHhFZzJBUmR0SElTdm9RZ2VGVzEx?=
 =?utf-8?B?WFFnYzduTlR5MnBvRmRleHR4NmhQTnVsK0ZhdlI0UmRTVy92eDhPb0VFNDFZ?=
 =?utf-8?B?UnBxYzl4Y2h3dlBkbFBOSWRpK1UxdFlJR2xjUTRYWkdMZGlDQkZObkN4YnRp?=
 =?utf-8?B?Tzl6T2VVU25OL3JBQXZiaksxWXZoTnpWZWtOUVVyWCtnU1RwZGRVY0tzNGF2?=
 =?utf-8?B?V2UyOU01Mllmd2lyOS80R2M0bzVGaThqenErTTZFZytnT3p6dXlPd3ZTS3VE?=
 =?utf-8?B?S3BzanB6Y1JRQUN2RzJCZWR3b3NKRGhDcFo0M2hVcHVQQzJHMGFrejNhSHJF?=
 =?utf-8?B?Z2Nrc01YYlVZRFlzZ3RjejRSV0JBSmgzdkNxQWppVTJNQmhZc1BMcTR1RWkv?=
 =?utf-8?B?SWRRQ3diM3lLU05NdjhkV2NEKzBKT3V2UmZEUW9Xa1Yvalg4U2c5eWhjMWFu?=
 =?utf-8?B?NDRzbnBQbTBnSnZEQzRmRVo4VE10SmpoczNTZU5EcDJoS2dhU3B3RWkvQndC?=
 =?utf-8?B?T0V0SFFDYTg2NURJZnBTamkwVUltWkRTVnZxOHljbS80c2xUb3pPcXczQkZX?=
 =?utf-8?B?NVdmWHpTUXduOVJkYUJsOCtlaEtybEhESVJtTFFMRUgzZlA2M1Qya203Skor?=
 =?utf-8?B?ZURRYXljOXdRN0VzSFVzcjdmSjduVTFleFlXREsxdHBYUTFFbkJuSml4Ympy?=
 =?utf-8?B?c0pLdzYwcEQ1YzZtemlzY3JGa2V5bGJCVzlldC9YYUZTeFk3RFJSQ1luNlpW?=
 =?utf-8?B?QlZyS1ZwSGpkUXJrKzBxNHpRQXFIUWM3Z2RXM1BqcFBSNkpGRlgxa1ljanNR?=
 =?utf-8?Q?DUGs2pB53jQMolcBgrYEfGvNi76Ovs2qVtUFt0+?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a7d0b31-3bd0-4f8c-7549-08d96171a24d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 11:24:53.0430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jQOW9wshzDXK6/br+aPAlJixCS2nvlixU/7icrlKCU48uzLxQLPgbk2VYP+FKzbKfxdwg2g9X4FYbtTB50jUKVECvqqkTRPtt2UgoHgKCrQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB4344
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgYWxsLA0KDQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggbmV0LW5leHQgdjIgMS84XSByYXZiOiBB
ZGQgc3RydWN0IHJhdmJfaHdfaW5mbyB0bw0KPiBkcml2ZXIgZGF0YQ0KPiANCj4gSGkgR2VlcnQs
DQo+IA0KPiBUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCj4gDQo+ID4gU3ViamVjdDogUmU6IFtQ
QVRDSCBuZXQtbmV4dCB2MiAxLzhdIHJhdmI6IEFkZCBzdHJ1Y3QgcmF2Yl9od19pbmZvIHRvDQo+
ID4gZHJpdmVyIGRhdGENCj4gPg0KPiA+IEhpIEJpanUsDQo+ID4NCj4gPiBPbiBUaHUsIEF1ZyAx
MiwgMjAyMSBhdCA5OjI2IEFNIEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4N
Cj4gPiB3cm90ZToNCj4gPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+ID4g
T24gTW9uLCBBdWcgMiwgMjAyMSBhdCAxMjoyNyBQTSBCaWp1IERhcw0KPiA+ID4gPiA8YmlqdS5k
YXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4gPiA+IHdyb3RlOg0KPiA+ID4gPiA+IFRoZSBETUFD
IGFuZCBFTUFDIGJsb2NrcyBvZiBHaWdhYml0IEV0aGVybmV0IElQIGZvdW5kIG9uIFJaL0cyTA0K
PiA+ID4gPiA+IFNvQyBhcmUgc2ltaWxhciB0byB0aGUgUi1DYXIgRXRoZXJuZXQgQVZCIElQLiBX
aXRoIGEgZmV3IGNoYW5nZXMNCj4gPiA+ID4gPiBpbiB0aGUgZHJpdmVyIHdlIGNhbiBzdXBwb3J0
IGJvdGggSVBzLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gQ3VycmVudGx5IGEgcnVudGltZSBkZWNp
c2lvbiBiYXNlZCBvbiB0aGUgY2hpcCB0eXBlIGlzIHVzZWQgdG8NCj4gPiA+ID4gPiBkaXN0aW5n
dWlzaCB0aGUgSFcgZGlmZmVyZW5jZXMgYmV0d2VlbiB0aGUgU29DIGZhbWlsaWVzLg0KPiA+ID4g
PiA+DQo+ID4gPiA+ID4gVGhlIG51bWJlciBvZiBUWCBkZXNjcmlwdG9ycyBmb3IgUi1DYXIgR2Vu
MyBpcyAxIHdoZXJlYXMgb24NCj4gPiA+ID4gPiBSLUNhcg0KPiA+ID4gPiA+IEdlbjIgYW5kIFJa
L0cyTCBpdCBpcyAyLiBGb3IgY2FzZXMgbGlrZSB0aGlzIGl0IGlzIGJldHRlciB0bw0KPiA+ID4g
PiA+IHNlbGVjdCB0aGUgbnVtYmVyIG9mIFRYIGRlc2NyaXB0b3JzIGJ5IHVzaW5nIGEgc3RydWN0
dXJlIHdpdGggYQ0KPiA+ID4gPiA+IHZhbHVlLCByYXRoZXIgdGhhbiBhIHJ1bnRpbWUgZGVjaXNp
b24gYmFzZWQgb24gdGhlIGNoaXAgdHlwZS4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IFRoaXMgcGF0
Y2ggYWRkcyB0aGUgbnVtX3R4X2Rlc2MgdmFyaWFibGUgdG8gc3RydWN0IHJhdmJfaHdfaW5mbw0K
PiA+ID4gPiA+IGFuZCBhbHNvIHJlcGxhY2VzIHRoZSBkcml2ZXIgZGF0YSBjaGlwIHR5cGUgd2l0
aCBzdHJ1Y3QNCj4gPiA+ID4gPiByYXZiX2h3X2luZm8gYnkgbW92aW5nIGNoaXAgdHlwZSB0byBp
dC4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRh
cy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiA+ID4gPiBSZXZpZXdlZC1ieTogTGFkIFByYWJoYWth
cg0KPiA+ID4gPiA+IDxwcmFiaGFrYXIubWFoYWRldi1sYWQucmpAYnAucmVuZXNhcy5jb20+DQo+
ID4gPiA+DQo+ID4gPiA+IFRoYW5rcyBmb3IgeW91ciBwYXRjaCENCj4gPiA+ID4NCj4gPiA+ID4g
PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+ID4gPiA+ICsr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gPiA+ID4gQEAgLTk4
OCw2ICs5ODgsMTEgQEAgZW51bSByYXZiX2NoaXBfaWQgew0KPiA+ID4gPiA+ICAgICAgICAgUkNB
Ul9HRU4zLA0KPiA+ID4gPiA+ICB9Ow0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gK3N0cnVjdCByYXZi
X2h3X2luZm8gew0KPiA+ID4gPiA+ICsgICAgICAgZW51bSByYXZiX2NoaXBfaWQgY2hpcF9pZDsN
Cj4gPiA+ID4gPiArICAgICAgIGludCBudW1fdHhfZGVzYzsNCj4gPiA+ID4NCj4gPiA+ID4gV2h5
IG5vdCAidW5zaWduZWQgaW50Ij8gLi4uDQo+ID4gPiA+IFRoaXMgY29tbWVudCBhcHBsaWVzIHRv
IGEgZmV3IG1vcmUgc3Vic2VxdWVudCBwYXRjaGVzLg0KPiA+ID4NCj4gPiA+IFRvIGF2b2lkIHNp
Z25lZCBhbmQgdW5zaWduZWQgY29tcGFyaXNvbiB3YXJuaW5ncy4NCj4gPiA+DQo+ID4gPiA+DQo+
ID4gPiA+ID4gK307DQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ICBzdHJ1Y3QgcmF2Yl9wcml2YXRl
IHsNCj4gPiA+ID4gPiAgICAgICAgIHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2Ow0KPiA+ID4gPiA+
ICAgICAgICAgc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldjsgQEAgLTEwNDAsNiArMTA0NSw4
IEBADQo+ID4gPiA+ID4gc3RydWN0IHJhdmJfcHJpdmF0ZSB7DQo+ID4gPiA+ID4gICAgICAgICB1
bnNpZ25lZCB0eGNpZG06MTsgICAgICAgICAgICAgIC8qIFRYIENsb2NrIEludGVybmFsIERlbGF5
DQo+ID4gTW9kZQ0KPiA+ID4gPiAqLw0KPiA+ID4gPiA+ICAgICAgICAgdW5zaWduZWQgcmdtaWlf
b3ZlcnJpZGU6MTsgICAgICAvKiBEZXByZWNhdGVkIHJnbWlpLSppZA0KPiA+IGJlaGF2aW9yDQo+
ID4gPiA+ICovDQo+ID4gPiA+ID4gICAgICAgICBpbnQgbnVtX3R4X2Rlc2M7ICAgICAgICAgICAg
ICAgIC8qIFRYIGRlc2NyaXB0b3JzIHBlcg0KPiBwYWNrZXQNCj4gPiAqLw0KPiA+ID4gPg0KPiA+
ID4gPiAuLi4gb2gsIGhlcmUncyB0aGUgb3JpZ2luYWwgY3VscHJpdC4NCj4gPiA+DQo+ID4gPiBF
eGFjdGx5LCB0aGlzIHRoZSByZWFzb24uDQo+ID4gPg0KPiA+ID4gRG8geW91IHdhbnQgbWUgdG8g
Y2hhbmdlIHRoaXMgaW50byB1bnNpZ25lZCBpbnQ/IFBsZWFzZSBsZXQgbWUga25vdy4NCj4gPg0K
PiA+IFVwIHRvIHlvdSAob3IgdGhlIG1haW50YWluZXI/IDstKQ0KPiA+DQo+ID4gRm9yIG5ldyBm
aWVsZHMgKGluIHRoZSBvdGhlciBwYXRjaGVzKSwgSSB3b3VsZCB1c2UgdW5zaWduZWQgZm9yIGFs
bA0KPiA+IHVuc2lnbmVkIHZhbHVlcy4gIFNpZ25lZCB2YWx1ZXMgaGF2ZSBtb3JlIHBpdGZhbGxz
IHJlbGF0ZWQgdG8NCj4gPiB1bmRlZmluZWQgYmVoYXZpb3IuDQo+IA0KPiBTZXJnZWksIFdoYXQg
aXMgeW91ciB0aG91Z2h0cyBoZXJlPyBQbGVhc2UgbGV0IG1lIGtub3cuDQoNCkhlcmUgaXMgbXkg
cGxhbi4NCg0KSSB3aWxsIHNwbGl0IHRoaXMgcGF0Y2ggaW50byB0d28gYXMgQW5kcmV3IHN1Z2dl
c3RlZCBhbmQgDQoNClRoZW4gb24gdGhlIHNlY29uZCBwYXRjaCB3aWxsIGFkZCBhcyBpbmZvLT51
bmFsaWduZWRfdHggYXMgU2VyZ2VpIHN1Z2dlc3RlZC4NCg0KTm93IHRoZSBvbmx5IG9wZW4gcG9p
bnQgaXMgcmVsYXRlZCB0byB0aGUgZGF0YSB0eXBlIG9mICJpbnQgbnVtX3R4X2Rlc2MiDQphbmQg
dG8gYWxpZ24gd2l0aCBzaF9ldGggZHJpdmVyIEkgd2lsbCBrZWVwIGludC4NCg0KUmVnYXJkcywN
CkJpanUNCg==
