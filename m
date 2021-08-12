Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284FD3EA05E
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 10:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235020AbhHLINs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 04:13:48 -0400
Received: from mail-eopbgr1400119.outbound.protection.outlook.com ([40.107.140.119]:6639
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234573AbhHLINr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 04:13:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+dk5j+1hIc/WDZjvWsPpdo/3Cvm1QWHQUpTnP1dr8fAumzEnPtr6LBn3QD7dZDfA9y5z9EPMF+1PqSQWCHqqnaKrfKNI1TPeCvLr0XvaXyXRL6jVhOkpGe4nwv7yg1Nxp9bgBMxEIc7YQTat5daIibT3HLGWOaX5YZoXZkl9eiQLntYKD5Q4DuHYy5WJMk76fXsVC2nD4b8wcNHb6xSsO0u9dgFnV45tuLjpJVHkxAmXvPH05JNV+3OMoqhlBZWEMvOrHv3lrJJoW7mv/BhWcpMlCcXbg9SrxmimIUvkDUePS32mIxtPenlR0OKr5aA6n03MlDvL2h8jT0oFOFO4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NyM3GD7TTCl6QsujV4VfjEDixTkXGZOQVUVxx+VktyI=;
 b=O0Nudea3JlDVuRBnX3BslhoUL1qgR2BLJB7f+2JQQDv9cXb3IrAEKLznpj4V9OBYJhVHYKRLMAIGFN+vVAnq3ZiW47+ZE+i61eLazM6a9duuWseiPd8sTbVhqw7s32lg2HI0/tliVFQlKawnlAVpBvwtX2FF38OUN8QSvXmwUgvzAzjf98IONyme/84Okf8/RVhxutweI8Ey4ujAIODknIfWmADMO2Uvk6KlKPLeR4GtKhAxlRy1X3BEoYceeOBYaNq9pda203xeApgFwMQlwon+ndC6w4sIO90JJ7pZqYKfh5SBvow/tAlqDdt9ubqQ9ehfk2o0sMGG/N+xLWKk5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NyM3GD7TTCl6QsujV4VfjEDixTkXGZOQVUVxx+VktyI=;
 b=YWVEL48ALt6qQbqS4A4zFcYIiC58VJQYCS6H5SWnUbs31evVcB4BXillqExCUijjxHQyj3PFQO6A4wv55uhvKbeJ8sVTDHX4fQr/aiICJ8R3dvgGW1soeh/v04MGndBiAb0Mn5nZuTsesYhRRWLxqQOasAfhGY/0oOhrlR8mv14=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB2708.jpnprd01.prod.outlook.com (2603:1096:603:38::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Thu, 12 Aug
 2021 08:13:18 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4415.017; Thu, 12 Aug 2021
 08:13:18 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
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
Thread-Index: AQHXh4j0+2cGRDLtLUyHm25tLRdYvKtrHuUAgARm9NCAAArSgIAAA4CA
Date:   Thu, 12 Aug 2021 08:13:17 +0000
Message-ID: <OS0PR01MB5922C336CBB008F9D7DA36B786F99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-2-biju.das.jz@bp.renesas.com>
 <CAMuHMdWuoLFDRbJZqpvT48q1zbH05tqerWMs50aFDa6pR+ecAg@mail.gmail.com>
 <OS0PR01MB5922BF48F95DD5576A79994F86F99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <CAMuHMdVCyMD6u2KxKb_c2LR8DGAY86F69=TSRDK0C5GPwrO7Eg@mail.gmail.com>
In-Reply-To: <CAMuHMdVCyMD6u2KxKb_c2LR8DGAY86F69=TSRDK0C5GPwrO7Eg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux-m68k.org; dkim=none (message not signed)
 header.d=none;linux-m68k.org; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12adca23-87dc-4118-24f9-08d95d690aa4
x-ms-traffictypediagnostic: OSAPR01MB2708:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB27082B9D685E244F7554AB1C86F99@OSAPR01MB2708.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y40CVplX44AKOt72HfJuANnc6l0DJb+WEXRvXpM4sp/mIBzL3nAx76dwhJQWF5ToTlI4RfA9U0ksoYmvy6IeeqFMW5oCbtedv2J9gxfo3ETrxlEobGYnY8jAWOPHdQd3vGm9mKL0XG68/jCqRMsbRGdyxA1EnGh2/Z5bwa8gNSEnnrq6pTUp8BkJjSAFjnLX585T+xRj7QfPhleGMv26t+U9syu2xtiTJen1c7IwOAkw+TXVQaFv0VpDLKTVr0/U2jcI0vkC5k2//qEv+qwwrbmN7BrchqB66JZfTKzsiEMXQxGKgGjLeAU+72qlPSGg+vtuzF1wfutGodmD/aYlDdWhKLAjDoaO75cUVyiOOsPBU7oEgn6RYwtPJQKx2tIujaQZFCCHB0mEpo7Cn+YVB/M1MhqEgBNDtd2gDWQXkeWRRU03sBpUcnHP3F9wxGlS7Mc2IhVC908wQPJoIJl4UFNoqYyJO9YrULFQWo4qkUy/rF/9N3Nv8PbFfnwva4T4+xHiHzQAI4WdYqLkh+L8IYngBinp1UWufTBBYRAUCmeY4XC4rRUixLPCz5FW6q2xrf0Q1iCQb2KXe/AsO1eDqsnZfjssbNI6sbdll3HSteFiiabjXtaF9GEtI2mMn51q6+pvRHzD6Crruo7azLDs26HG0tWIpEuHlsHVhOc7XtqOicNGKf54L6NBDkB+Lsxv68Jn1fnPwi+T6OtI4Qr4mg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(83380400001)(86362001)(55016002)(7416002)(110136005)(26005)(107886003)(38100700002)(122000001)(9686003)(186003)(66556008)(33656002)(5660300002)(4326008)(71200400001)(76116006)(52536014)(8936002)(54906003)(66446008)(64756008)(8676002)(478600001)(66946007)(7696005)(6506007)(316002)(53546011)(2906002)(38070700005)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aU9yKzNMeC9aYnJEOTFxQ1pmVlI3ZkVkUDFsNWJBaFhDU1JncDRQNlJ2cEh4?=
 =?utf-8?B?eUl2WSsxRVc2czQyN0JGMENBSnJxYlk0RzRwNUlGRjcvSHR1aHgreUNnTFF6?=
 =?utf-8?B?RWwwK0Y4RUh1L2hmZDRhTmp6RUtWMGxmNzZPWHVtUUd1ZENqTVZJb1QxRjFU?=
 =?utf-8?B?bWNNN3hiRDdUelZjVk1WZHh5TldpWDhDV010dU1razN1UnVaNk41ZHhXVlFJ?=
 =?utf-8?B?UUZWNXJaTTJCOVh1aG9yQXFnalJuajBoUEx1RWphelNMYjR0SjBIcy93YjZq?=
 =?utf-8?B?Tm1BNmV5Mjk2a0ZLK2FFL2k2M2lEaVJoQitqb1lSdm43azdpYVpXL3VLR25n?=
 =?utf-8?B?dVltcHVoUTNUbFNQK2F3dnRqcEVOdENTRy95Qlg5RTVFYmJHMmNURVJIN29o?=
 =?utf-8?B?RHdzdEhnL0E5QkJmU1o0UmxzZFErbVZsVDJaK1NSY2wyZ0JLTXUwY3pyeWdx?=
 =?utf-8?B?V1lRYlBrSzVhN2hFZGN4amRaVytHRGs4MmVuVHRHTGltMGhZU2UrUVNscHZY?=
 =?utf-8?B?U3lqVGU4d3ptNjhoUEFpdFhxWWhtNVhMemR1N1hDdGxuV3IwVHkvQVVSV25l?=
 =?utf-8?B?Vmk3TVBPeUZ4M3ZqVGpGVlVmM3RZZFptcHpxK0ludmxqR21NandEWGtNaWdK?=
 =?utf-8?B?bDdPanVBbHJMS0hhL1lHK3ZNMm5iUWkwYy8yWmRsQnFQL0tmNkhjNGdiaVN5?=
 =?utf-8?B?WFdSd0M0a1lKWXUxdW5kRHMzMzNaZkIxQklzSHBoRkZ6R0NmdTVoeVNDMkFQ?=
 =?utf-8?B?MnZBTjdFRUxBUFVnMVpFUmhhZW9BeU5FNm9rYUxaV0Z6Qi9KTSt6OVRQeVcv?=
 =?utf-8?B?bkhLc3NsUGNiOHhYV0UzMGo3SW5TZVBrNVBqcHVBaWdMRnFxZUdPSEJxUzFH?=
 =?utf-8?B?RllMNDhMUnhPK0NFS3ZaNVZsaTgzQlNTWUpTd09haldBdUUzbXJpTjN3Vmdl?=
 =?utf-8?B?blFrMEFabW1JQVo2U1N3OGt1akVJc01uVmVhQWdyT0R0N1h2VGI0THFGOWZv?=
 =?utf-8?B?MEVEazBWUDRQeWlnanRUVmV6ZFR3RnhqeFpINjdVclN0eUsxd2VVZmo2UTdj?=
 =?utf-8?B?dlEvZDQ5eUx0eGx1WkV0UTJGVnZXcGVwQUNoNEliVWlyVkczNktqaDU2Vyti?=
 =?utf-8?B?SUhKU0pGMUxjaDJGVUxrM0lYeVA0czJjS0MwMG13QUtWUTN5U2VIZVhtU3RT?=
 =?utf-8?B?eXlKdHJ3UkJmQXNNZnBBc0o5TmRPdjFJN2V3Rnc1M1FGME44eUw0Z3ZDVGtB?=
 =?utf-8?B?dFVVZS9sVjJWeWx4MXJSbkJKVm1BNU9QeGVmak5salUxZlRDK0hhdzExMjE3?=
 =?utf-8?B?TUQrME9yTDlKMFJQUUpETk1kclBSNXVjNWo5eVg1MExraVkwN245ekhqd1pP?=
 =?utf-8?B?cHVBYzQ4d2xOTXNtZ3hjZm9wbVZmNXZCMXcraDNLV3ZrbE95THQ1OVpSY2R6?=
 =?utf-8?B?RTFCWlpWeUpaT09adVVmeWpsZGRyUlBGMUZidE52K0taWmZnUnVwNzY2cnBt?=
 =?utf-8?B?a0RpNXIycE5oc2lXcURCN2JVbXhtZDN0bmxMMUxGUzI4U3JkS1JIVXhRMzBp?=
 =?utf-8?B?NXRTUGg5YjlFQkNNWVRuSG5TNFlaLzU1Rk1vT1U3ZWgwanRDVkVXUURrTlgx?=
 =?utf-8?B?K3pWRlFzZnJrWUhkc09hbjFoaFhiVS9BZzVlVVBnRjR2d05NWDZsb3g2SDRu?=
 =?utf-8?B?L2JzUzdKVHRYWDBOdnFYZGJ0UEVGdysvV2lJZks5QjBJc1gyQ3NBQW1jWldQ?=
 =?utf-8?Q?9MAPPq2v1oWmmEL2/cmve13DA4EOWBbWwawSSFD?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12adca23-87dc-4118-24f9-08d95d690aa4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 08:13:17.9636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VdXuWLMrXM0p1+929l5GMbK8ob2NhmDS/zjgXsec7tSaXA1twjqLeu1yfWknUN0kI4jOBjTAruteMxessSCH9RsgDabLTwo5ZYIglrdMJHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2708
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQsDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggbmV0LW5leHQgdjIgMS84XSByYXZiOiBBZGQgc3RydWN0IHJhdmJfaHdfaW5mbyB0bw0K
PiBkcml2ZXIgZGF0YQ0KPiANCj4gSGkgQmlqdSwNCj4gDQo+IE9uIFRodSwgQXVnIDEyLCAyMDIx
IGF0IDk6MjYgQU0gQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiB3cm90
ZToNCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBPbiBNb24sIEF1ZyAy
LCAyMDIxIGF0IDEyOjI3IFBNIEJpanUgRGFzDQo+ID4gPiA8YmlqdS5kYXMuanpAYnAucmVuZXNh
cy5jb20+DQo+ID4gPiB3cm90ZToNCj4gPiA+ID4gVGhlIERNQUMgYW5kIEVNQUMgYmxvY2tzIG9m
IEdpZ2FiaXQgRXRoZXJuZXQgSVAgZm91bmQgb24gUlovRzJMDQo+ID4gPiA+IFNvQyBhcmUgc2lt
aWxhciB0byB0aGUgUi1DYXIgRXRoZXJuZXQgQVZCIElQLiBXaXRoIGEgZmV3IGNoYW5nZXMNCj4g
PiA+ID4gaW4gdGhlIGRyaXZlciB3ZSBjYW4gc3VwcG9ydCBib3RoIElQcy4NCj4gPiA+ID4NCj4g
PiA+ID4gQ3VycmVudGx5IGEgcnVudGltZSBkZWNpc2lvbiBiYXNlZCBvbiB0aGUgY2hpcCB0eXBl
IGlzIHVzZWQgdG8NCj4gPiA+ID4gZGlzdGluZ3Vpc2ggdGhlIEhXIGRpZmZlcmVuY2VzIGJldHdl
ZW4gdGhlIFNvQyBmYW1pbGllcy4NCj4gPiA+ID4NCj4gPiA+ID4gVGhlIG51bWJlciBvZiBUWCBk
ZXNjcmlwdG9ycyBmb3IgUi1DYXIgR2VuMyBpcyAxIHdoZXJlYXMgb24gUi1DYXINCj4gPiA+ID4g
R2VuMiBhbmQgUlovRzJMIGl0IGlzIDIuIEZvciBjYXNlcyBsaWtlIHRoaXMgaXQgaXMgYmV0dGVy
IHRvDQo+ID4gPiA+IHNlbGVjdCB0aGUgbnVtYmVyIG9mIFRYIGRlc2NyaXB0b3JzIGJ5IHVzaW5n
IGEgc3RydWN0dXJlIHdpdGggYQ0KPiA+ID4gPiB2YWx1ZSwgcmF0aGVyIHRoYW4gYSBydW50aW1l
IGRlY2lzaW9uIGJhc2VkIG9uIHRoZSBjaGlwIHR5cGUuDQo+ID4gPiA+DQo+ID4gPiA+IFRoaXMg
cGF0Y2ggYWRkcyB0aGUgbnVtX3R4X2Rlc2MgdmFyaWFibGUgdG8gc3RydWN0IHJhdmJfaHdfaW5m
bw0KPiA+ID4gPiBhbmQgYWxzbyByZXBsYWNlcyB0aGUgZHJpdmVyIGRhdGEgY2hpcCB0eXBlIHdp
dGggc3RydWN0DQo+ID4gPiA+IHJhdmJfaHdfaW5mbyBieSBtb3ZpbmcgY2hpcCB0eXBlIHRvIGl0
Lg0KPiA+ID4gPg0KPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpA
YnAucmVuZXNhcy5jb20+DQo+ID4gPiA+IFJldmlld2VkLWJ5OiBMYWQgUHJhYmhha2FyDQo+ID4g
PiA+IDxwcmFiaGFrYXIubWFoYWRldi1sYWQucmpAYnAucmVuZXNhcy5jb20+DQo+ID4gPg0KPiA+
ID4gVGhhbmtzIGZvciB5b3VyIHBhdGNoIQ0KPiA+ID4NCj4gPiA+ID4gLS0tIGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiA+ID4gQEAgLTk4OCw2ICs5ODgsMTEgQEAgZW51bSBy
YXZiX2NoaXBfaWQgew0KPiA+ID4gPiAgICAgICAgIFJDQVJfR0VOMywNCj4gPiA+ID4gIH07DQo+
ID4gPiA+DQo+ID4gPiA+ICtzdHJ1Y3QgcmF2Yl9od19pbmZvIHsNCj4gPiA+ID4gKyAgICAgICBl
bnVtIHJhdmJfY2hpcF9pZCBjaGlwX2lkOw0KPiA+ID4gPiArICAgICAgIGludCBudW1fdHhfZGVz
YzsNCj4gPiA+DQo+ID4gPiBXaHkgbm90ICJ1bnNpZ25lZCBpbnQiPyAuLi4NCj4gPiA+IFRoaXMg
Y29tbWVudCBhcHBsaWVzIHRvIGEgZmV3IG1vcmUgc3Vic2VxdWVudCBwYXRjaGVzLg0KPiA+DQo+
ID4gVG8gYXZvaWQgc2lnbmVkIGFuZCB1bnNpZ25lZCBjb21wYXJpc29uIHdhcm5pbmdzLg0KPiA+
DQo+ID4gPg0KPiA+ID4gPiArfTsNCj4gPiA+ID4gKw0KPiA+ID4gPiAgc3RydWN0IHJhdmJfcHJp
dmF0ZSB7DQo+ID4gPiA+ICAgICAgICAgc3RydWN0IG5ldF9kZXZpY2UgKm5kZXY7DQo+ID4gPiA+
ICAgICAgICAgc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldjsgQEAgLTEwNDAsNiArMTA0NSw4
IEBAIHN0cnVjdA0KPiA+ID4gPiByYXZiX3ByaXZhdGUgew0KPiA+ID4gPiAgICAgICAgIHVuc2ln
bmVkIHR4Y2lkbToxOyAgICAgICAgICAgICAgLyogVFggQ2xvY2sgSW50ZXJuYWwgRGVsYXkNCj4g
TW9kZQ0KPiA+ID4gKi8NCj4gPiA+ID4gICAgICAgICB1bnNpZ25lZCByZ21paV9vdmVycmlkZTox
OyAgICAgIC8qIERlcHJlY2F0ZWQgcmdtaWktKmlkDQo+IGJlaGF2aW9yDQo+ID4gPiAqLw0KPiA+
ID4gPiAgICAgICAgIGludCBudW1fdHhfZGVzYzsgICAgICAgICAgICAgICAgLyogVFggZGVzY3Jp
cHRvcnMgcGVyIHBhY2tldA0KPiAqLw0KPiA+ID4NCj4gPiA+IC4uLiBvaCwgaGVyZSdzIHRoZSBv
cmlnaW5hbCBjdWxwcml0Lg0KPiA+DQo+ID4gRXhhY3RseSwgdGhpcyB0aGUgcmVhc29uLg0KPiA+
DQo+ID4gRG8geW91IHdhbnQgbWUgdG8gY2hhbmdlIHRoaXMgaW50byB1bnNpZ25lZCBpbnQ/IFBs
ZWFzZSBsZXQgbWUga25vdy4NCj4gDQo+IFVwIHRvIHlvdSAob3IgdGhlIG1haW50YWluZXI/IDst
KQ0KPiANCj4gRm9yIG5ldyBmaWVsZHMgKGluIHRoZSBvdGhlciBwYXRjaGVzKSwgSSB3b3VsZCB1
c2UgdW5zaWduZWQgZm9yIGFsbA0KPiB1bnNpZ25lZCB2YWx1ZXMuICBTaWduZWQgdmFsdWVzIGhh
dmUgbW9yZSBwaXRmYWxscyByZWxhdGVkIHRvIHVuZGVmaW5lZA0KPiBiZWhhdmlvci4NCg0KU2Vy
Z2VpLCBXaGF0IGlzIHlvdXIgdGhvdWdodHMgaGVyZT8gUGxlYXNlIGxldCBtZSBrbm93Lg0KDQpD
aGVlcnMsDQpCaWp1DQo=
