Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11EC7418EEA
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 08:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhI0GMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 02:12:05 -0400
Received: from mail-eopbgr1410098.outbound.protection.outlook.com ([40.107.141.98]:19328
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232938AbhI0GMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 02:12:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hmk0k8CPKYnDvNTQZkTfaPvdi0h0u7Wb9T4BdpKKCrwsddduZhMcdDwNmSIRO2+6ZAr5BGa9CFq6qajRtIXMuTCb+DuoiqbfNdMjQxVyuK4G56tQoOus3UQAPIYM6k7Zw0PNO6M6XolifyC7DEW0L/i7TKufgGNHutnrDz/AwkFdqOWekmMJdhzQSoUsMYuyhCYCN3W90+VnjkGMUecXMPUjp7cTdQR1n49XCik7IuODnyMfhPcTNM1vtCwA1S2QehEmhV/zLJJ7bk6YDtoA72Q1xu/S9Nnd+/5X2pP6au/u7CQ1CY5bkcRAcnOrX7FLLN5nrO8N/d0Tl6adMkaUdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=8Pj3FwIIsQMnee1VX04PPhC74BcDAH4ib6z5ThznpWI=;
 b=UJMIU7EtHsq28EYjox5COK0a3vGNqyIOmXffjiq0Hxsyra9k5BJKLtPa1rTSS0W1h41JmZOfbyqMc48SRvAb8ZsHc4y5Qx6/QRDw1l1w5HUtjUkEF1PatXFW29JbchyqbWHLCg18KgRLNvqtwdhTEt7J1HmG4aPOWwIK/yOkBb3yZSMQ5pw4QHsrkqT32Gh67aUnv5cqgtgFAY0EB7YAaIHmLT8pOzEmgLKf4XFql2Go6eVSFahTnEQxs96wV4A2dcSWHycNg58R5RVyTudbFf3zIdlRRCFgJ1oxM4avgbYF4t5gfQ05lfI4h/iMqRtNGi2+FYT+ThCuurxx8Dl6QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Pj3FwIIsQMnee1VX04PPhC74BcDAH4ib6z5ThznpWI=;
 b=jXLPw/REivssJE4FdugNtR59T5TymYze1R/ilxKj3LUoJ6yDInjxuFMQXHColSKt/rc03RbsZUB7gQJwGdG5+nCPe4p74LLaQXz5Z6O0FE/2hWOG5dJeSf5FF4/B0fPuEwoLj6iJpN4ejUlZqpsVRdMKdFUVDW/XKh44qqS2wFw=
Received: from TYCPR01MB5933.jpnprd01.prod.outlook.com (2603:1096:400:47::11)
 by TYCPR01MB6755.jpnprd01.prod.outlook.com (2603:1096:400:b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 06:10:21 +0000
Received: from TYCPR01MB5933.jpnprd01.prod.outlook.com
 ([fe80::3d5f:8ca:b2a0:80a1]) by TYCPR01MB5933.jpnprd01.prod.outlook.com
 ([fe80::3d5f:8ca:b2a0:80a1%8]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 06:10:21 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC/PATCH 12/18] ravb: Add timestamp to struct ravb_hw_info
Thread-Topic: [RFC/PATCH 12/18] ravb: Add timestamp to struct ravb_hw_info
Thread-Index: AQHXsISOUUpjeBVcoEe6exCe5Ob9S6u1PXqAgACeaaCAAPIOAIAAAOAAgACbU8A=
Date:   Mon, 27 Sep 2021 06:10:21 +0000
Message-ID: <TYCPR01MB5933683E18B26882AC1C817686A79@TYCPR01MB5933.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-13-biju.das.jz@bp.renesas.com>
 <ef7c0a4c-cd4d-817a-d5af-3af1c058964f@omp.ru>
 <OS0PR01MB5922426AACFBDF176125A9AF86A69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <45c1dedb-6804-444f-703e-2aa1788e4360@omp.ru>
 <ea925b7f-fcc7-d21f-c3bb-6fb8d210bbb2@gmail.com>
In-Reply-To: <ea925b7f-fcc7-d21f-c3bb-6fb8d210bbb2@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1de4374c-7def-48c7-afe9-08d9817d7d0b
x-ms-traffictypediagnostic: TYCPR01MB6755:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TYCPR01MB675533272364CA129F96AB9A86A79@TYCPR01MB6755.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /Z55MwXa61bJ8ZnirL/wNAfFQdAF7oFtwkODLDd9vNCQFtNSv3v167vycOm8k6NX5k19QUZG2qAvojrfHU+a+dQrldPneShNUIxR9zonuZ+OcM4N1v8V8YrIulLU2JzoHNoWG64eV6IclRqoRRWLvRs+D7g0HuGnGBEatL4BwDKLLy75uAgp7e1stMECpK40IayjnnuO5Wvizy0EwhJcCW+YRBzH36yiht6xfdQggfR1hd5ZV/Doe9MMzzAmffJmGB0mGEogoqWTZpY8qJsGY1vFObSVPEpxb0IN7pGohzWZWKTgEX4XTTYjtuauTabB79A1Va/SoaplBT8mHftey+kwp9GpJb6ahAedPV5PJkGzYsIJipjkM/SOBKxEIfjQFA/eBRA5k0X3eXjwx1uMxN+mZAcjM22jr7fT96Rieu3yZYHBei25JVr1Pt1KXjG9YKsDo1JXk603uO2UAlzXnkABMoWBW0lryZGSJKFYSoc9LvkXn23NepAe7OafF7aRiHvUFPia1iNNImCz3PH/GNbTay7249Aj0YNihfLA/DbllfhIupdukZ1GhdYw2H6bDha4olpWHKwLFHOSY6ghdvJUNw/cfMMCyWJaeeDxNLDYPoSP6Je/kaAvSThxy5nYJrSpllpvHmbw4279mpNVIT/n7zndC3Pwrxqh63V2fTI4WfsnW5eYZAYv+pb7ko8RPE5LgOP7+QJ59m2pr0pjXirx1rmVbYOJyth92HFzXEg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB5933.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6506007)(9686003)(110136005)(38070700005)(26005)(8936002)(55016002)(83380400001)(7696005)(508600001)(54906003)(53546011)(316002)(66476007)(66446008)(64756008)(8676002)(4326008)(52536014)(71200400001)(5660300002)(107886003)(122000001)(66556008)(66946007)(38100700002)(76116006)(86362001)(33656002)(186003)(87944003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: PjJ5EV3M0lNFiN1dAmh1gPrNzHkPmYuGrCKoVLJ4AZyVYZrNrJaVCXdgSbZFSJtXlTpRR3UOL1mSshXNjDcp1kzIYf00g3MEHab/dPwgEvr2j5cO6aZ+rZ7uxkJ/Dn2frPYfM2jLif2Otd1Z+p6RmCustnj6QpS08cOo2ud687kvkyE4KyBTo+ni66RVTjgxVZGjy3k8bD2hD640NsPSGhnKZwGYlNM8lsKVXSW+6rxwnpSZ/LXjM/LzJwB9MuC9a9xI0ha6johQDksPfIOwlCvoQG4HLxV5fsY6jW1KxHdbmN6fdl3Nz3OW5zFYqoq3E8nMOWTP4yg+wLWzBAOHb6OkL76gOoqIfXQrmzSf4q7jq5DIlbpebiJVssLQ4UBDUU55T7WU3LpwQbq5qczCCRsNcy5fFB+WD5XgPazjXHeGTr+5/YCRzeTOoNnkszQB+Rk0D6L7i8USB16MAUjxozP3IGNphwWkPCiz67gSwPKWUeVu2ohSldSDBbOPhUsMVcjayh4mCSaNkDB0Atz28Jj3U9ytjX8nH2919UeDVubNc9mw+rYKbKyiC/A/+jbAjTRv9fkXC2WdL9TsrLhDMzt3XF0HS9FYs0BGkLtiziFbwrArE0zTLkbtetrf1WAh2uKe53gi5o07dEvsfYJqEI0WRJIO+G5ptvhNOqoIIq6x91H9HySXJ5g/LfyMTvNy4TVBs6hEI1C8F5ZU3TLeWU8WTlCTy9Uw8zAPEo7E4vI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB5933.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de4374c-7def-48c7-afe9-08d9817d7d0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2021 06:10:21.7284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A32beYc1NgL3DzRLKfWtSoe8F1gfofZtP/8nievlE19TKEIAMhQiRmH/fpIPtvOscvXx31OE6C5LyKGTq6CG/T2NmmahdLG6xqvrBzlwyIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB6755
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUkZDL1BBVENIIDEyLzE4XSByYXZiOiBBZGQg
dGltZXN0YW1wIHRvIHN0cnVjdCByYXZiX2h3X2luZm8NCj4gDQo+IE9uIDkvMjYvMjEgMTE6NDUg
UE0sIFNlcmdleSBTaHR5bHlvdiB3cm90ZToNCj4gDQo+ID4+PiAtLS0tLU9yaWdpbmFsIE1lc3Nh
Z2UtLS0tLQ0KPiA+Pj4gU3ViamVjdDogUmU6IFtSRkMvUEFUQ0ggMTIvMThdIHJhdmI6IEFkZCB0
aW1lc3RhbXAgdG8gc3RydWN0DQo+ID4+PiByYXZiX2h3X2luZm8NCj4gPj4+DQo+ID4+PiBPbiA5
LzIzLzIxIDU6MDggUE0sIEJpanUgRGFzIHdyb3RlOg0KPiA+Pj4NCj4gPj4+PiBSLUNhciBBVkIt
RE1BQyBzdXBwb3J0cyB0aW1lc3RhbXAgZmVhdHVyZS4NCj4gPj4+PiBBZGQgYSB0aW1lc3RhbXAg
aHcgZmVhdHVyZSBiaXQgdG8gc3RydWN0IHJhdmJfaHdfaW5mbyB0byBhZGQgdGhpcw0KPiA+Pj4+
IGZlYXR1cmUgb25seSBmb3IgUi1DYXIuDQo+ID4+Pj4NCj4gPj4+PiBTaWduZWQtb2ZmLWJ5OiBC
aWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4+Pj4gLS0tDQo+ID4+Pj4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAgICAgfCAgMiArDQo+ID4+Pj4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMgfCA2OA0KPiA+Pj4+ICsr
KysrKysrKysrKysrKy0tLS0tLS0tLQ0KPiA+Pj4+ICAyIGZpbGVzIGNoYW5nZWQsIDQ1IGluc2Vy
dGlvbnMoKyksIDI1IGRlbGV0aW9ucygtKQ0KPiA+Pj4+DQo+ID4+Pj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4+Pj4gYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+Pj4+IGluZGV4IGFiNDkwOTI0NDI3Ni4uMjUwNWRl
NWQ0YTI4IDEwMDY0NA0KPiA+Pj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMv
cmF2Yi5oDQo+ID4+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgN
Cj4gPj4+PiBAQCAtMTAzNCw2ICsxMDM0LDcgQEAgc3RydWN0IHJhdmJfaHdfaW5mbyB7DQo+ID4+
Pj4gIAl1bnNpZ25lZCBtaWlfcmdtaWlfc2VsZWN0aW9uOjE7CS8qIEUtTUFDIHN1cHBvcnRzDQo+
IG1paS9yZ21paQ0KPiA+Pj4gc2VsZWN0aW9uICovDQo+ID4+Pj4gIAl1bnNpZ25lZCBoYWxmX2R1
cGxleDoxOwkJLyogRS1NQUMgc3VwcG9ydHMgaGFsZiBkdXBsZXgNCj4gbW9kZSAqLw0KPiA+Pj4+
ICAJdW5zaWduZWQgcnhfMmtfYnVmZmVyczoxOwkvKiBBVkItRE1BQyBoYXMgTWF4IDJLIGJ1ZiBz
aXplDQo+IG9uIFJYDQo+ID4+PiAqLw0KPiA+Pj4+ICsJdW5zaWduZWQgdGltZXN0YW1wOjE7CQkv
KiBBVkItRE1BQyBoYXMgdGltZXN0YW1wICovDQo+ID4+Pg0KPiA+Pj4gICAgSXNuJ3QgdGhpcyBh
IG1hdHRlciBvZiB0aGUgZ1BUUCBzdXBwb3J0IGFzIHdlbGwsIGkuZS4gbm8gc2VwYXJhdGUNCj4g
Pj4+IGZsYWcgbmVlZGVkPw0KPiA+Pg0KPiA+PiBBZ3JlZWQuIFByZXZpb3VzbHkgaXQgaXMgc3Vn
Z2VzdGVkIHRvIHVzZSB0aW1lc3RhbXAuIEkgd2lsbCBjaGFuZ2UgaXQNCj4gdG8gYXMgcGFydCBv
ZiBnUFRQIHN1cHBvcnQgY2FzZXMuDQo+ID4NCj4gPiAgICBUSUEuIDotKQ0KPiA+DQo+ID4+Pg0K
PiA+Pj4gWy4uLl0NCj4gPj4+PiBAQCAtMTA4OSw2ICsxMDkwLDcgQEAgc3RydWN0IHJhdmJfcHJp
dmF0ZSB7DQo+ID4+Pj4gIAl1bnNpZ25lZCBpbnQgbnVtX3R4X2Rlc2M7CS8qIFRYIGRlc2NyaXB0
b3JzIHBlciBwYWNrZXQgKi8NCj4gPj4+Pg0KPiA+Pj4+ICAJaW50IGR1cGxleDsNCj4gPj4+PiAr
CXN0cnVjdCByYXZiX3J4X2Rlc2MgKnJnZXRoX3J4X3JpbmdbTlVNX1JYX1FVRVVFXTsNCj4gPj4+
DQo+ID4+PiAgICBTdHJhbmdlIHBsYWNlIHRvIGRlY2xhcmUgdGhpcy4uLg0KPiA+Pg0KPiA+PiBB
Z3JlZWQuIFRoaXMgaGFzIHRvIGJlIG9uIGxhdGVyIHBhdGNoLiBXaWxsIG1vdmUgaXQuDQo+ID4N
Cj4gPiAgICBJIG9ubHkgbWVhbnQgdGhhdCB0aGVzZSBmaWVsZHMgc2hvdWxkIGdvIHRvZ2V0aGVy
IHdpdGggcnhfcmluZ1tdLg0KPiA+IEFwcGFyZW50bHkNCj4gDQo+ICAgIFNvcnJ5LCB0aGlzIGZp
ZWxkLg0KDQpJdCBpcyBhIG1pc3Rha2UgZnJvbSBteSBzaWRlIHdoaWNoIGVuZGVkIHVwIHRoaXMg
dmFyaWFibGUgaW4gdGhpcyBwYXRjaC4NCg0KRnVuY3Rpb24gcG9pbnRlcnMgYXJlIGludHJvZHVj
ZWQgdG8gYXZvaWQgbW9yZSBjaGVja3MgYW5kIG9ubHkgcnggZnVuY3Rpb25zIHBmIFJaL0cyTCBh
cmUgdXNpbmcNCnRoaXMgdmFyaWFibGUuIA0KDQpJdCB3aWxsIGJlIGNsZWFyIHlvdSB0byBvbmNl
IHlvdSBmaW5pc2ggcmV2aWV3aW5nIHRoZSByZW1haW5pbmcgcGF0Y2hlcyhwYXRjaCAxMyAtIHBh
dGNoIDE4KS4NCg0KUmVnYXJkcywNCkJpanUNCg0KUmVnYXJkcywNCkJpanUNCg0KPiANCj4gPiB3
ZSBoYXZlIGEgY2FzZSBvZiB3cm9uZyBwYXRjaCBvcmRlcmluZyBoZXJlIChhcyB0aGlzIHBhdGNo
IG5lZWRzIHRoaXMNCj4gZmllbGQgZGVjbGFyZWQpLi4uDQo+IFsuLi5dDQo+IA0KPiA+PiBSZWdh
cmRzLA0KPiA+PiBCaWp1DQo+IA0KPiBNQlIsIFNlcmdleQ0K
