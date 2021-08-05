Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32BE3E1C59
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242738AbhHETTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:19:23 -0400
Received: from mail-eopbgr1410099.outbound.protection.outlook.com ([40.107.141.99]:52128
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242897AbhHETTV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 15:19:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bm3OnFIGlXfdaIvYjC2/TAkePiSLdBMH+6jKqF8soTUrBI30BCsCPk9pELWhrtua4M3Ly3hu5ygp8rmvg26XkD3eOrWqBRa6lFmxWbTNOne7WBO/F8p2udGoB2qtO01HK+JJKsLtrSmsbuSkwsWw8PKS28Yur5Iz1i+aZuHfB8ud/YB8h4n3VNeFOrWuEYHt6oZhyiz94X1VD4fkBfWYUDEq/2iUmQiJV2t5NT+UrsY1767SxA4V05Kdshfz7Rzjj0JldG8jI7Kq1Ads97wbE6qyVUdau5yC5CYF0VVZDNMVj95tiqzHCXlLoUGFpwYHRO9WNe0zPP/YmWJ0lVzDsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nAEYEHpn0kD0YA60lv7DS/d5Gg2+R8lk0AyrzmVekUo=;
 b=ZoW95lI+IEahoBwXGY7vEmH3Ti3Iy+PfBhi0k4+ysGEgEFzIPIkCgjpBp6SuBCUWNIGSzO1XU3ZizkinpTzjJ1HkG9tUZ6eu2UI6h7Fi3QvACasxYC35MXhkDh2UQXG60Tsq1+X09Hme/VV5nwtLJG3Meai9Shq60lEpXARKiFRXvLZpqB29rUTVRLn/x6XYFE6x2/VqDCP4wbicFbm9bcFWdBhTsSci1oj0/BBiqNQPWQHEToCsokiu26Uv5xI00+7ewOa77XtFZ1ZdUiDIgVl0ETXgl9Bczm1fwnjzbZwB7Fp1xpjknzfGkkNx4My0fuLTGmEr7GTGiz6a8TENGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nAEYEHpn0kD0YA60lv7DS/d5Gg2+R8lk0AyrzmVekUo=;
 b=XM6yz6DZ+gncnNvgV29wHcJtgqFOyXVLS518et6I4QdLIY+GKT/v+EBeyeTZkfTFiF1lFdxin+gNB6LcOTn+v2OMEgissuF1o7qkvbMFlRjO4FG7LuC346IGDJu81zMKPVNSEV8/F3Ph1mb5GTXOljUqNXoyJhh7/ZVX0blyI/s=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS0PR01MB5409.jpnprd01.prod.outlook.com (2603:1096:604:ab::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.18; Thu, 5 Aug
 2021 19:18:56 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%8]) with mapi id 15.20.4373.026; Thu, 5 Aug 2021
 19:18:56 +0000
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
Subject: RE: [PATCH net-next v2 6/8] ravb: Add net_features and
 net_hw_features to struct ravb_hw_info
Thread-Topic: [PATCH net-next v2 6/8] ravb: Add net_features and
 net_hw_features to struct ravb_hw_info
Thread-Index: AQHXh4kFp+geaJbxPkSeNoy79C/vbatlSxwAgAABWNA=
Date:   Thu, 5 Aug 2021 19:18:56 +0000
Message-ID: <OS0PR01MB5922C5EE008113DEA3354BFA86F29@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-7-biju.das.jz@bp.renesas.com>
 <0daf8d07-b412-4cb0-cbfb-e8f8b84184e5@gmail.com>
In-Reply-To: <0daf8d07-b412-4cb0-cbfb-e8f8b84184e5@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1cd90fdc-1291-4723-7ff6-08d95845def0
x-ms-traffictypediagnostic: OS0PR01MB5409:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS0PR01MB540980919D6B0E92DA3B0A3386F29@OS0PR01MB5409.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dSyibuWNWSjnBwoEs6CU0GjcDq1P/8LJx9vu6AsRhRr/LNw88W8nxW+rLVvk12eAsXq7rVMr9+M1bQm6qQduXHBm3ujMT+tLlkaQnNFrcdA5wGcikxcqPSS0NhIMcokc/gudyXwLkNb/eMgVj2Fq9NeAvf0l5C0pEIhdNQ9pBsO6cXzdwG+AL1+gDHla3U4kpOiNKSJVGFNydYXZCi+lNQcZY49ArLyg1iFVFwPtURQRAirEigsi0gOKGIt0Ql6ScY3ZSO+lnf8QHTrpQorswOCKeXC2J3NX/9L/1T6wqQjmpx3UlUX5ijXDLBZf/seZKTorGQJkmK6IiASQVug2EagqOA9/JgVmuz2ViOCVnKshN0xj5cVzcuhVyC10ithMYtXlxxjkULNDCCnfv92E/Tsh2p8pLZ7l3ls/7B/N3nJOMCC4aTYyySjckVLDX/uu8QuC5DpB/sX6pUs3TWmzvVs5sifiLK2jXFBNbihf0/ylWZz+2i4ADpzBLigANsuWmYRHWdM01so5UjAR44g6FAHuTz3qXcaiZHjJufNbsd9moNuJVFRL8+HkSiMEF4kDFC/vjD1S90fcWa4FaS5+pChC35FgixukkrpBweqhcnVI1unGcbSb0Vj/26lcwrOe7Urf0Kt7pPJUZtv87pkj35H2nIn2FPtaGPlZtEM8/f616ZxNrDaO5aY2r7Eb6AohAvJMEm9Q9Z9WkKZGzUczfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39850400004)(396003)(376002)(366004)(4326008)(7416002)(38100700002)(122000001)(54906003)(76116006)(66946007)(110136005)(66476007)(316002)(64756008)(66446008)(52536014)(55016002)(9686003)(66556008)(7696005)(71200400001)(38070700005)(86362001)(2906002)(5660300002)(26005)(8936002)(107886003)(8676002)(186003)(53546011)(33656002)(6506007)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SGxWb0p5aHBmdERQak9nWGpSTW9oWmRxdXR4TWlmdWs3WlZiQW1EazZ1Q2Nj?=
 =?utf-8?B?bC81c3NMY3ArdW1YZ0IySlpBdkhEYm4vRFZaVStiVkpJWnRrRHIzbE9VTTN3?=
 =?utf-8?B?SnZ3RUZWMUgvaSsxVE9teW1XTlg4dlV3cG81Rk5vVEhLSTg3eDZoM2hKWjNh?=
 =?utf-8?B?K2ExYUtDelpzbVhhQ1FsTElMTUpBMENZVGJHcHcxeUtsaExxSHN4dk44NXhH?=
 =?utf-8?B?cSsrNjlubHBVSVpXczFIM0s0bkFrSGJNS1NFNlc0cHF3SDNVdk5uZ0ZWS29y?=
 =?utf-8?B?bzc5TWQxY2Z6RENTOVFrR2dyRnh2N3ZkV0VKTm54OTRQa252dFRuYlhWYkRM?=
 =?utf-8?B?ZzBRT1czK1A5MHZnYmJvdnVoSHNTRWNlZ1JRU1JNazlMeWlVYlBxLzVrelhI?=
 =?utf-8?B?N2dBd1psb2pTTjI0dzd2c2ErTjBFQXhuVGJTbzlsZVNCNEtoZTdsbTlHSGZj?=
 =?utf-8?B?NjV3TzNoYjFuVEl3S1NXV2NhdnZsSmoyd0E2S245dXRNOVNQSjFJQ0cvbFRz?=
 =?utf-8?B?SDVRTTlsUFBUOGNpbFBKYnMzdDBuZTlrdXJLaDdXTkRWRXlJZW9iRjdsMjV2?=
 =?utf-8?B?K2ZJWjlDQWJQZy9TWkU2TXVyS1c1UUN3WE9jVXYvaDhHZm9LTlFkdG55V1dV?=
 =?utf-8?B?QjYwRERla3dCdk83bTc4S3BYSmh5QWZYTzF3bzBwSUhzU2R6UW1sOXl6ZGMv?=
 =?utf-8?B?L2hFSElZbTk1L1puMFVnZ3JqNG5PWlNzSjZJVUYyZVpPWGRyY2hjRlpBUDVp?=
 =?utf-8?B?a2ZWL3N5T3hvNHgwbXJoRVk4dUxNTDVkcFNHS0laZE9wZm5DYUNRNHZTc2xz?=
 =?utf-8?B?SWx1Vkx1Y0FNZ2QyR3BWWFhhTzU0Zk9JM2tqNkpQTFRSWmZzanR0bVgyU3VH?=
 =?utf-8?B?QkhzRjFzTUljNU5XR3MrM3lEdlFobzYzdkxxaVZJK2g1SGRELzlpVXBTWGFm?=
 =?utf-8?B?bWJRa3VhM0tDWlRCTGgzN1NLQ2Z1V014WnIvYzRGNjBLOTdlRkh6L1pTeUh3?=
 =?utf-8?B?aTVQRXdsSU90RDdMdGExckFvYjZNbGt6aE51RGNZTXIrV2FQOFV4UzFEdG9J?=
 =?utf-8?B?MHpoMmdlVi9UUG0wMDMrZGdEZkxQeUxNQ0o0bHpOZ0RTR0pmRHdwdXVEeEhE?=
 =?utf-8?B?Q3ZjL1FrNElUNnQ2bDVVQmlISjBuODRlak5MT2YxaWVIZ0MwRXduR0FLNHl4?=
 =?utf-8?B?cEhSRGxnMjJuRDZhMVpUOUEyeVNoamNncTZBNlQxRFNGMHYvV3kzWndWL2U4?=
 =?utf-8?B?N3dxeEp1SnJJQ00wempiU2M0TFVqR1JQRkdOazdZKzdkVEVlRUIzanhCeFRq?=
 =?utf-8?B?aVdpc0g4WWlnZmpBSWJEYWdCcWNudUh5c3YrOENkY0pCTkdKOGk5V25Bc1k2?=
 =?utf-8?B?YmR5WnhxTkR6Uko4YW9lc2h5OFV6UkhkeThYWDJSby9PTjIzbWhxbTNrUjNk?=
 =?utf-8?B?TFplR3ZlelhjVzRtclZsblM3MEtiNGVsYUN6L1B3cjIvcTZ0cDRuVTFwanNV?=
 =?utf-8?B?Q2gyczl3K2xITlQ4WWhIdytKVXZNTjJzU2c0dFhua0xaNkFuVGdjRjZpQ3VS?=
 =?utf-8?B?ZCtxNlJGbkZKbU5Bejg0WW1lYkxHUHRDcVUxa045STBUb29EOXE0YldBZENm?=
 =?utf-8?B?b0VlWlVQOGpCbVF1cDVTUCt2VWFvOG5LUmttL283WkVZWUh2Y3hqQkkvL3cw?=
 =?utf-8?B?OVNRWGJXcEs5S0Q5eTJQZFF0M2VINWd5M1pKNVFmMThES3NJMXNjRXRiZmlI?=
 =?utf-8?Q?N30IC41LbxDGtjitW8k9tt1DJtnOgOH9E/PRs9I?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cd90fdc-1291-4723-7ff6-08d95845def0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 19:18:56.3985
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZIvlxOgsvuIOx7g/ekkwgdRSyFb3zVsAQGul+rSTpkb1T+hh63Uw0peX1LTgHtbIyXxqKCTAPg462cf//8P6JxFqHEkBeuKpYc1zIqIAt2Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5409
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IHYyIDYvOF0gcmF2YjogQWRkIG5ldF9mZWF0dXJlcyBhbmQNCj4gbmV0
X2h3X2ZlYXR1cmVzIHRvIHN0cnVjdCByYXZiX2h3X2luZm8NCj4gDQo+IE9uIDgvMi8yMSAxOjI2
IFBNLCBCaWp1IERhcyB3cm90ZToNCj4gDQo+ID4gT24gUi1DYXIgdGhlIGNoZWNrc3VtIGNhbGN1
bGF0aW9uIG9uIFJYIGZyYW1lcyBpcyBkb25lIGJ5IHRoZSBFLU1BQw0KPiA+IG1vZHVsZSwgd2hl
cmVhcyBvbiBSWi9HMkwgaXQgaXMgZG9uZSBieSB0aGUgVE9FLg0KPiA+DQo+ID4gVE9FIGNhbGN1
bGF0ZXMgdGhlIGNoZWNrc3VtIG9mIHJlY2VpdmVkIGZyYW1lcyBmcm9tIEUtTUFDIGFuZCBvdXRw
dXRzDQo+ID4gaXQgdG8gRE1BQy4gVE9FIGFsc28gY2FsY3VsYXRlcyB0aGUgY2hlY2tzdW0gb2Yg
dHJhbnNtaXNzaW9uIGZyYW1lcw0KPiA+IGZyb20gRE1BQyBhbmQgb3V0cHV0cyBpdCBFLU1BQy4N
Cj4gPg0KPiA+IEFkZCBuZXRfZmVhdHVyZXMgYW5kIG5ldF9od19mZWF0dXJlcyB0byBzdHJ1Y3Qg
cmF2Yl9od19pbmZvLCB0bw0KPiA+IHN1cHBvcnQgc3Vic2VxdWVudCBTb0NzIHdpdGhvdXQgYW55
IGNvZGUgY2hhbmdlcyBpbiB0aGUgcmF2Yl9wcm9iZQ0KPiBmdW5jdGlvbi4NCj4gPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiBS
ZXZpZXdlZC1ieTogTGFkIFByYWJoYWthciA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJwLnJl
bmVzYXMuY29tPg0KPiANCj4gWy4uLl0NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMv
cmF2Yi5oDQo+ID4gaW5kZXggYjc2NWIyYjdkOWU5Li4zZGY4MTNiMmUyNTMgMTAwNjQ0DQo+ID4g
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IEBAIC05OTEsNiArOTkxLDggQEAg
ZW51bSByYXZiX2NoaXBfaWQgeyAgc3RydWN0IHJhdmJfaHdfaW5mbyB7DQo+ID4gIAljb25zdCBj
aGFyICgqZ3N0cmluZ3Nfc3RhdHMpW0VUSF9HU1RSSU5HX0xFTl07DQo+ID4gIAlzaXplX3QgZ3N0
cmluZ3Nfc2l6ZTsNCj4gPiArCW5ldGRldl9mZWF0dXJlc190IG5ldF9od19mZWF0dXJlczsNCj4g
PiArCW5ldGRldl9mZWF0dXJlc190IG5ldF9mZWF0dXJlczsNCj4gDQo+ICAgIERvIHdlIHJlYWxs
eSBuZWVkIGJvdGggb2YgdGhlc2UgaGVyZT8gDQoNClItQ2FyIGhhcyBvbmx5IFJ4IENoZWNrc3Vt
IG9uIEUtTWFjLCB3aGVyZSBhcyBHZXRoIHN1cHBvcnRzIFJ4IENoZWNrIFN1bSBvbiBFLU1hYyBv
ciBSeC9UeCBDaGVja1N1bSBvbiBUT0UuDQpTbyB0aGVyZSBpcyBhIGh3IGRpZmZlcmVuY2UuIFBs
ZWFzZSBsZXQgbWUga25vdyB3aGF0IGlzIHRoZSBiZXN0IHdheSB0byBoYW5kbGUgdGhpcz8NCg0K
Pkl0IHNlZW1zIGxpa2UgdGhlICdmZWFydHVyZXMnDQo+IG1pcnJvcnMgdGhlIGVuYWJsZWQgZmVh
dHVyZXM/DQoNCkNhbiB5b3UgcGxlYXNlIGV4cGxhaW4gdGhpcyBsaXR0bGUgYml0Pw0KDQo+IA0K
PiA+ICAJZW51bSByYXZiX2NoaXBfaWQgY2hpcF9pZDsNCj4gPiAgCWludCBudW1fZ3N0YXRfcXVl
dWU7DQo+ID4gIAlpbnQgbnVtX3R4X2Rlc2M7DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBpbmRleCA3YTY5NjY4Y2I1MTIuLjJhYzk2MmI1Yjhm
YiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFp
bi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0K
PiBbLi4uXQ0KPiA+IEBAIC0yMDc3LDE0ICsyMDgxLDE0IEBAIHN0YXRpYyBpbnQgcmF2Yl9wcm9i
ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlDQo+ICpwZGV2KQ0KPiA+ICAJaWYgKCFuZGV2KQ0KPiA+
ICAJCXJldHVybiAtRU5PTUVNOw0KPiA+DQo+ID4gLQluZGV2LT5mZWF0dXJlcyA9IE5FVElGX0Zf
UlhDU1VNOw0KPiA+IC0JbmRldi0+aHdfZmVhdHVyZXMgPSBORVRJRl9GX1JYQ1NVTTsNCj4gPiAr
CWluZm8gPSBvZl9kZXZpY2VfZ2V0X21hdGNoX2RhdGEoJnBkZXYtPmRldik7DQo+ID4gKw0KPiA+
ICsJbmRldi0+ZmVhdHVyZXMgPSBpbmZvLT5uZXRfZmVhdHVyZXM7DQo+ID4gKwluZGV2LT5od19m
ZWF0dXJlcyA9IGluZm8tPm5ldF9od19mZWF0dXJlczsNCj4gDQo+ICAgIFdoYXQgdmFsdWUgeW91
IHBsYW4gdG8gc2V0IGhlciBmb3IgR2JFdGgsIE5FVElGX0ZfSFdfQ1NVTT8NCg0KWWVzLCBUaGF0
IGlzIHRoZSBwbGFuLg0KLm5ldF9od19mZWF0dXJlcyA9IChORVRJRl9GX0hXX0NTVU0gfCBORVRJ
Rl9GX1JYQ1NVTSksDQoNClJlZ2FyZHMsDQpCaWp1DQoNCj4gDQo+IFsuLi5dDQo+IA0KPiBNQlIs
IFNlcmdlaQ0K
