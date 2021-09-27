Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2AF418EDF
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 08:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbhI0GF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 02:05:58 -0400
Received: from mail-eopbgr1410124.outbound.protection.outlook.com ([40.107.141.124]:35864
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232924AbhI0GF5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 02:05:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hToQcAlGlvXYctYh0xPBFUauxv8RQD/DaC6JZV+HY0rWgvu3+uhmEaWlaJAVbVuuDL0GzHC0R8Bbyb3MhGHsEy/WU5ZpNMEqdUGFcqVWufefgQ/IC1Hz10qIbzh4pnToY9zAAzyMVn6CO63FMuE+aRzPN4zY5blpW/eBctDwEwL1sSfGTIevLatk9sS+i5O22IthHwkxbM4yMlXaw+fUoTMWsEyycEBh6cFA/+rNzM22uZp13mAqFhDCA+WPTkyENROKEcUYj6wVpTcxovAAb3f2Ix0jrsk+RsBr5kQf/K27og6HLhHbqo6VKv5zzbjqCOZTJIF25udZK0aSucECSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=E2/Iyd/cdt4eSgfwDNO+rHIoH8n5LT7WD/5hubRzSkQ=;
 b=QZc8aO32raKkm35b/93alOuVgqIizg6lZ+jhk01pyeSHaraCXEFw59muvaWMU3tPVeAuItj+jX1B1N80WP8GEqFUF9m69aGhON0LCgvsZdlzeMzXVGghH/4I85Ohm8oc2QIPMnyyUZPCgD9sav+Hr/HpOQCurPprefU3s0oPIM1SWmW5BdGKhBnoqUbtl0ZXxEl1WfEjylWLRZwlHmJ8DuubcAkUu09YOdHANgWOG6GRzRHD6Sgc/+PLM9U8posc2TEnKU7ZCoUkGehs1awj3g/rXBzH1vps1/cIKjI+ZwoiUq8CtJhTVbCbgVlYv3KWR/HEcR96XUMIc8rFgZIw2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2/Iyd/cdt4eSgfwDNO+rHIoH8n5LT7WD/5hubRzSkQ=;
 b=ItfF1iJhYuhm/RbLGZfyMnYyd5q3fDsc/CzGibCEbsK2H9t7kOccc31De4Eeb0PVUedasv3HTW+Ohl8XTauDc409c7etSQiDVvLWvQtrXrc+D3xVJsx7dXqgROtP+yVm9OaNXfdQNQEjb9Hqx+3RsR7G10XphEiwlAlkgaiHXVA=
Received: from TYCPR01MB5933.jpnprd01.prod.outlook.com (2603:1096:400:47::11)
 by TY2PR01MB3402.jpnprd01.prod.outlook.com (2603:1096:404:d2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Mon, 27 Sep
 2021 06:04:16 +0000
Received: from TYCPR01MB5933.jpnprd01.prod.outlook.com
 ([fe80::3d5f:8ca:b2a0:80a1]) by TYCPR01MB5933.jpnprd01.prod.outlook.com
 ([fe80::3d5f:8ca:b2a0:80a1%8]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 06:04:16 +0000
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
Subject: RE: [RFC/PATCH 12/18] ravb: Add timestamp to struct ravb_hw_info
Thread-Topic: [RFC/PATCH 12/18] ravb: Add timestamp to struct ravb_hw_info
Thread-Index: AQHXsISOUUpjeBVcoEe6exCe5Ob9S6u1PXqAgACeaaCAAPIOAIAAm4Dw
Date:   Mon, 27 Sep 2021 06:04:16 +0000
Message-ID: <TYCPR01MB5933E40A793E698F9AB82CD886A79@TYCPR01MB5933.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-13-biju.das.jz@bp.renesas.com>
 <ef7c0a4c-cd4d-817a-d5af-3af1c058964f@omp.ru>
 <OS0PR01MB5922426AACFBDF176125A9AF86A69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <45c1dedb-6804-444f-703e-2aa1788e4360@omp.ru>
In-Reply-To: <45c1dedb-6804-444f-703e-2aa1788e4360@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0cf5bd4-d09d-4e5b-7951-08d9817ca356
x-ms-traffictypediagnostic: TY2PR01MB3402:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TY2PR01MB3402DA12B553E190FA84DADB86A79@TY2PR01MB3402.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0cm3UaoxXeP884H5TiOEdsOlprVdhdQLEYzMcWs8VvqgtBhXzyXxWavl60etCdD3or4ExuKZY3GZvd0jU5GdlLUz+0zzMbHe1bCd0gOnMbSkZG8/eKINM1kd0/MITxCR6HnphZRCBL1WHl8aBylkfum28QSq+TYBH/p16inyVPPG3/kDY+MOvG7yue/HuRnVeuAi9EOma+fsAf41CeQ6FLvZ4xxPfgOAh5BVVzJIps3G8JLkIL02vIzDGHdp08n8N4ECw8lESksI8VOUw0g/QdlKoA5sJDbs/pcb+pPqudCBI9InJ27CM5f3rsjXPLP8dGefcwjFddUTP9O5NWtSLkAp7oNBzOqMpwzuebiMwTbtFl4b/ByTCkIkHAnKdrZOMRUXseYh177vTv0sOo3VHNd2Q6jcFcuauD9OjfgtuhkshrMcjUEM0kKHw4zKahwVGdAHRfazmshznDYyQZpm59WoKA0H91v+JuYgQ5sDmqu2/wuvE5YZfnp/NkZRnH7uQTf5Qxu3WVncV0UJj65X90oRP2QG9RGUGO+q/yQgj8+OBqQ9qkhIIS1iwghenkK7xDPf6srVnPlP2e5nSaYYGv100Se0hdRBr0TsgOAXqmVkZsg/1tHkhaE0WFbanBcYmXMOIWE1mctnDIp6+7nNNi9zloiQTfh4zl/Kh1b7IU9+bNKYY4y4zfBceFbDXWuFRWCi6rcAEL8o4gfqTnRL9UB0XFqlMaFeL2H0WQF0UjWL3reVeoCvtGLWWF+wkTXXKV9A6zhxqo8Bn80ZqFCY89XwKbKEShuVT7TC7M71TR8v03QuTuhD5uJJzv9E7Mzt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB5933.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(76116006)(9686003)(7696005)(66556008)(66476007)(83380400001)(66946007)(53546011)(508600001)(122000001)(2906002)(6506007)(55016002)(66446008)(107886003)(64756008)(4326008)(26005)(38100700002)(86362001)(52536014)(54906003)(110136005)(186003)(71200400001)(33656002)(8676002)(316002)(8936002)(5660300002)(87944003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: x72iuLRWf5T6nGrk3yKyGARwmAbaD425IG+2h/9UG/QcN2V3HJyFcmvEm/JcDmkaex8T/cGsP1lwkePVT7BSCecjaAwU+bIxyLwjjaEafzchz2QOGSC9lSo8njNw4FLzb1a66Lixw0qVzG1oywuPUSA4yH8ZxVrstYxfovlC/7+l3j4LSO9ssntiLTU2RVXylVANnuKQu8diA3jHj7fx+vmGoJiVnrcpZS4UMYaSNrk6P6WGkgzVqIvwKQBUaJ9HRN+XHrtlykmf1DOHIIxTGOX1hUAgRIhRiLLB5CY8A2TPOP3vROwqoChmehD+sLdDI2QRbt4WvyvBR1XERXkl48GGzL5d7uOtmZXK91jml8Vv+VK16ptfnlS+sK7dXNGMNvq32FrDTlPFObUp2Nq5pvViVzvVBk/0SGnTAAwNUbqRBoBXy/GshZB6mslRWlEtJxN2z+KyiGluDNat0C2Fu6TPbKSyjsRY1tZV+naMfbaOMhsqhd/qhT+NAwnldp5swYZR7d05MrJigFfqaA9mZiUgWXjdYix2d7/qvjdRfT6wsbavC0w6mDXfW1JC37qFX+cX9Dg/NFK4bEFWnqKrYY0b3Lg0Eb0crGM64bTE1TULJWpkwODDs3P9tzEtqtY3avZznvQ2aDdeYVnlvze9mg0zNMyaYC0AB240KemotadxBJt0TpOSCqMXLQLzEh0+jNzIPFtaH8tE8KMK0nyfr/HvxKue1XJFXuMs6oGAwhU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB5933.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0cf5bd4-d09d-4e5b-7951-08d9817ca356
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2021 06:04:16.4333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4e1gOIIKj+gy9OEBnmesRVsV9cy/hs6J8wC2eGi8U0rprJ/FJjduIjS/XsBiEywqSeBmel/YF7kfxVv3pey6TuvgrbhLpwO8hIuV+fIzlzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB3402
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUkZDL1BBVENIIDEyLzE4XSByYXZiOiBBZGQg
dGltZXN0YW1wIHRvIHN0cnVjdCByYXZiX2h3X2luZm8NCj4gDQo+IE9uIDkvMjYvMjEgOTozNCBB
TSwgQmlqdSBEYXMgd3JvdGU6DQo+IA0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
PiA+PiBTdWJqZWN0OiBSZTogW1JGQy9QQVRDSCAxMi8xOF0gcmF2YjogQWRkIHRpbWVzdGFtcCB0
byBzdHJ1Y3QNCj4gPj4gcmF2Yl9od19pbmZvDQo+ID4+DQo+ID4+IE9uIDkvMjMvMjEgNTowOCBQ
TSwgQmlqdSBEYXMgd3JvdGU6DQo+ID4+DQo+ID4+PiBSLUNhciBBVkItRE1BQyBzdXBwb3J0cyB0
aW1lc3RhbXAgZmVhdHVyZS4NCj4gPj4+IEFkZCBhIHRpbWVzdGFtcCBodyBmZWF0dXJlIGJpdCB0
byBzdHJ1Y3QgcmF2Yl9od19pbmZvIHRvIGFkZCB0aGlzDQo+ID4+PiBmZWF0dXJlIG9ubHkgZm9y
IFItQ2FyLg0KPiA+Pj4NCj4gPj4+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5q
ekBicC5yZW5lc2FzLmNvbT4NCj4gPj4+IC0tLQ0KPiA+Pj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0
L3JlbmVzYXMvcmF2Yi5oICAgICAgfCAgMiArDQo+ID4+PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVuZXNhcy9yYXZiX21haW4uYyB8IDY4DQo+ID4+PiArKysrKysrKysrKysrKystLS0tLS0tLS0N
Cj4gPj4+ICAyIGZpbGVzIGNoYW5nZWQsIDQ1IGluc2VydGlvbnMoKyksIDI1IGRlbGV0aW9ucygt
KQ0KPiA+Pj4NCj4gPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2Fz
L3JhdmIuaA0KPiA+Pj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+
Pj4gaW5kZXggYWI0OTA5MjQ0Mjc2Li4yNTA1ZGU1ZDRhMjggMTAwNjQ0DQo+ID4+PiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+Pj4gKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPj4+IEBAIC0xMDM0LDYgKzEwMzQsNyBAQCBz
dHJ1Y3QgcmF2Yl9od19pbmZvIHsNCj4gPj4+ICAJdW5zaWduZWQgbWlpX3JnbWlpX3NlbGVjdGlv
bjoxOwkvKiBFLU1BQyBzdXBwb3J0cyBtaWkvcmdtaWkNCj4gPj4gc2VsZWN0aW9uICovDQo+ID4+
PiAgCXVuc2lnbmVkIGhhbGZfZHVwbGV4OjE7CQkvKiBFLU1BQyBzdXBwb3J0cyBoYWxmIGR1cGxl
eCBtb2RlICovDQo+ID4+PiAgCXVuc2lnbmVkIHJ4XzJrX2J1ZmZlcnM6MTsJLyogQVZCLURNQUMg
aGFzIE1heCAySyBidWYgc2l6ZSBvbiBSWA0KPiA+PiAqLw0KPiA+Pj4gKwl1bnNpZ25lZCB0aW1l
c3RhbXA6MTsJCS8qIEFWQi1ETUFDIGhhcyB0aW1lc3RhbXAgKi8NCj4gPj4NCj4gPj4gICAgSXNu
J3QgdGhpcyBhIG1hdHRlciBvZiB0aGUgZ1BUUCBzdXBwb3J0IGFzIHdlbGwsIGkuZS4gbm8gc2Vw
YXJhdGUNCj4gPj4gZmxhZyBuZWVkZWQ/DQo+ID4NCj4gPiBBZ3JlZWQuIFByZXZpb3VzbHkgaXQg
aXMgc3VnZ2VzdGVkIHRvIHVzZSB0aW1lc3RhbXAuIEkgd2lsbCBjaGFuZ2UgaXQgdG8NCj4gYXMg
cGFydCBvZiBnUFRQIHN1cHBvcnQgY2FzZXMuDQo+IA0KPiAgICBUSUEuIDotKQ0KPiANCj4gPj4N
Cj4gPj4gWy4uLl0NCj4gPj4+IEBAIC0xMDg5LDYgKzEwOTAsNyBAQCBzdHJ1Y3QgcmF2Yl9wcml2
YXRlIHsNCj4gPj4+ICAJdW5zaWduZWQgaW50IG51bV90eF9kZXNjOwkvKiBUWCBkZXNjcmlwdG9y
cyBwZXIgcGFja2V0ICovDQo+ID4+Pg0KPiA+Pj4gIAlpbnQgZHVwbGV4Ow0KPiA+Pj4gKwlzdHJ1
Y3QgcmF2Yl9yeF9kZXNjICpyZ2V0aF9yeF9yaW5nW05VTV9SWF9RVUVVRV07DQo+ID4+DQo+ID4+
ICAgIFN0cmFuZ2UgcGxhY2UgdG8gZGVjbGFyZSB0aGlzLi4uDQo+ID4NCj4gPiBBZ3JlZWQuIFRo
aXMgaGFzIHRvIGJlIG9uIGxhdGVyIHBhdGNoLiBXaWxsIG1vdmUgaXQuDQo+IA0KPiAgICBJIG9u
bHkgbWVhbnQgdGhhdCB0aGVzZSBmaWVsZHMgc2hvdWxkIGdvIHRvZ2V0aGVyIHdpdGggcnhfcmlu
Z1tdLg0KPiBBcHBhcmVudGx5IHdlIGhhdmUgYSBjYXNlIG9mIHdyb25nIHBhdGNoIG9yZGVyaW5n
IGhlcmUgKGFzIHRoaXMgcGF0Y2gNCj4gbmVlZHMgdGhpcyBmaWVsZCBkZWNsYXJlZCkuLi4NCg0K
RXhhY3RseSB0aGF0IGlzIHRoZSBjYXNlLCBpdCBpcyBtb3ZlZCB0byBsYXRlciBwYXRjaCAoaHR0
cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L2xpbnV4LXJlbmVzYXMtc29jL3BhdGNo
LzIwMjEwOTIzMTQwODEzLjEzNTQxLTE0LWJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tLykgd2hp
Y2ggaXMgdGhlIGZpcnN0IHVzZXIgb2YNClRoaXMgdmFyaWFibGUuDQoNClJlZ2FyZHMsDQpCaWp1
DQo+IA0KPiA+Pj4gIAljb25zdCBzdHJ1Y3QgcmF2Yl9od19pbmZvICppbmZvOw0KPiA+Pj4gIAlz
dHJ1Y3QgcmVzZXRfY29udHJvbCAqcnN0YzsNCj4gPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4+PiBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPj4+IGluZGV4IDljMGQzNWY0YjIyMS4uMmMzNzUw
MDJlYmNiIDEwMDY0NA0KPiA+Pj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiX21haW4uYw0KPiA+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZi
X21haW4uYw0KPiA+Pj4gQEAgLTk0OSwxMSArOTQ5LDE0IEBAIHN0YXRpYyBib29sIHJhdmJfcXVl
dWVfaW50ZXJydXB0KHN0cnVjdA0KPiA+Pj4gbmV0X2RldmljZSAqbmRldiwgaW50IHEpDQo+ID4+
Pg0KPiA+Pj4gIHN0YXRpYyBib29sIHJhdmJfdGltZXN0YW1wX2ludGVycnVwdChzdHJ1Y3QgbmV0
X2RldmljZSAqbmRldikgIHsNCj4gPj4+ICsJc3RydWN0IHJhdmJfcHJpdmF0ZSAqcHJpdiA9IG5l
dGRldl9wcml2KG5kZXYpOw0KPiA+Pj4gKwljb25zdCBzdHJ1Y3QgcmF2Yl9od19pbmZvICppbmZv
ID0gcHJpdi0+aW5mbzsNCj4gPj4+ICAJdTMyIHRpcyA9IHJhdmJfcmVhZChuZGV2LCBUSVMpOw0K
PiA+Pj4NCj4gPj4+ICAJaWYgKHRpcyAmIFRJU19URlVGKSB7DQo+ID4+PiAgCQlyYXZiX3dyaXRl
KG5kZXYsIH4oVElTX1RGVUYgfCBUSVNfUkVTRVJWRUQpLCBUSVMpOw0KPiA+Pj4gLQkJcmF2Yl9n
ZXRfdHhfdHN0YW1wKG5kZXYpOw0KPiA+Pj4gKwkJaWYgKGluZm8tPnRpbWVzdGFtcCkNCj4gPj4+
ICsJCQlyYXZiX2dldF90eF90c3RhbXAobmRldik7DQo+ID4+DQo+ID4+ICAgIFNob3VsZG4ndCB3
ZSBqdXN0IGRpc2FibGUgVElTLlRGVUYgcGVybWFuZW50bHkgaW5zdGVhZCBmb3IgdGhlDQo+ID4+
IG5vbi1nUFRQIGNhc2U/DQo+ID4NCj4gPiBHb29kIGNhdGNoLiBBcyByYXZiX2RtYWNfaW5pdF9y
Z2V0aCh3aWxsIGJlIHJlbmFtZWQgdG8NCj4gInJhdmJfZG1hY19pbml0X2diZXRoIikgaXMgbm90
IGVuYWJsaW5nIHRoaXMgaW50ZXJydXB0IGFzIGl0IGlzIG5vdA0KPiBkb2N1bWVudGVkIGluIFJa
L0cyTCBoYXJkd2FyZSBtYW51YWwuDQo+ID4gU28gdGhpcyBmdW5jdGlvbiBuZXZlciBnZXRzIGNh
bGxlZCBmb3Igbm9uLWdQVFAgY2FzZS4NCj4gPg0KPiA+IEkgd2lsbCByZW1vdmUgdGhpcyBjaGVj
ay4NCj4gDQo+ICAgIFRJQSENCj4gDQo+ID4gUmVnYXJkcywNCj4gPiBCaWp1DQo+IA0KPiBNQlIs
IFNlcmdleQ0K
