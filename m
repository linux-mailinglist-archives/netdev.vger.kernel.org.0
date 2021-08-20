Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98AA3F2F82
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241049AbhHTPc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:32:59 -0400
Received: from mail-eopbgr1400098.outbound.protection.outlook.com ([40.107.140.98]:64977
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241033AbhHTPc6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 11:32:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/bmKPwUyjkL3TUo60pDrpMPxgsKMdYeSS62wZi0LOFnUI4YdWB5qJV7UslkRO87S2q3+MtQ+yM4ZdwTAdfL36R7falUE1zvKE5rW3Bwf9CWTjPwER8rwqXx2wLSBIWHgjW8FNTUyHNBWjfnb4ZH1VpShMH4DlJTrvvtsWxIVFj5KVV0SQfjQwGCVQIjL9WflhYwnIYjwxBvixcT3P71Dw9MhPjUzEvk3A5B/Dzp2UpEtE6i/CLzF0AW1HhGe6eIQ6Gyhikg65vPCtG6cPa7yx+qinu0luOqoKPfZIjlV9rNyc2Hhdd2i9mEz2hsIyOFzHij2alQB1s10Jj27x6V6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CriTP3iUFPfCZYiXp6VdqhHzaakHQjZjjifViP37E8=;
 b=TRN8oWZxhoTkQ46+U4OZwoz/+z0UCCtMbAXBa3HoayQcQ4+DKldjRweD56fRJEvu4QKSC9/MH7Nbfno9kJ8j+0iT4EG1hmL6fd+Z5Odszr9m8rRgm1MNtXpoyzz8/C0x1Dpe7HUQNVY6R31/309uyHI4e9mp8ZQ5Q5+I5a2t1T8XChgECfa7Ha1On8LatNLFpX4Xuz4rZyqgdSZ6hqGmZkkyPjsofnAW30Aj3jV/EAgsxwsTMvqShJB+4eQGCZabE4PlkjT6G+5xHargJvt+AXXaMYXQsOfv9qVAaU0apwoVl5bgOeOKuFk40aAV0IjyE+1WCpmhjxN34Ns/ahMzUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CriTP3iUFPfCZYiXp6VdqhHzaakHQjZjjifViP37E8=;
 b=juM/k/ZWEM1Fz+X4PJESmeTkQGFsAYRnx7XhlRqFwDt4upX2gnB0MlwKMum8sMMWr4ciCX59ALDAvukBMEYcveFYsSQddbHFYJq7VbMN/MWw95meVoS/2TQ3zj5/OoH1xnu32OusxV5GSSfr89MPLbielOjbu7EI4zqqSCE0XJA=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB5154.jpnprd01.prod.outlook.com (2603:1096:604:65::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 15:32:18 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4415.024; Fri, 20 Aug 2021
 15:32:18 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
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
Subject: RE: [PATCH net-next 09/18] ravb: Factorise ravb_ring_free function
Thread-Topic: [PATCH net-next 09/18] ravb: Factorise ravb_ring_free function
Thread-Index: AQHXfwPjvuoODNA+h0GIn7mNUk+qV6taSdWAgADKeACAIZ4gQA==
Date:   Fri, 20 Aug 2021 15:32:18 +0000
Message-ID: <OS0PR01MB5922BBACBBF4A394A1376E8C86C19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <20210722141351.13668-10-biju.das.jz@bp.renesas.com>
 <a0d1bb7e-0e0a-8237-c30a-e4533b5580dd@gmail.com>
 <OS0PR01MB59223D88215676866ABD813586EC9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB59223D88215676866ABD813586EC9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 385eb5df-db77-402a-e2dd-08d963efb1e0
x-ms-traffictypediagnostic: OSAPR01MB5154:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB51548F6FD5830BE0AD2CAF1586C19@OSAPR01MB5154.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j1itnwnhiWKs2QZXkY3sDvLonUFo6ZN4nJNW2BeCqQOku07zDJWt4M/UA74G+xeXrZ/BKuqadSKBYUuUyvtPB8lArtnzvnbxw48LUcBfk4j24/G/hCRkQ27N1Rb3JWSDJ826j4wixQYF8PIsMI+GIMo/KQzj3b1leX3z1KAOb4sVJkK0Acxx7DSHIDf1CwckwXWO/R38GYCsZZ24l6EJhs02raUWokR30N1WSNrhFrpmy3nbJe46qNyjLMm6A8ZGexnH2wXyTHdBg8qMiX8O3ItuX2yXgyGZccTaI3TwQACBqhmJ2a8dsh1Wx8vFTRiiy0rMA0sxPVVykZycgjiaDzibz72cWKNO6gu478BGl54EsvMz9tCHYWpjqHLPjlGsNKZej7xxzlkOoJdcwZrMx8BR+/4jOv/1VzF2C4KHtlmnnuaMEij0/KEz1B1fZtsPJrvg9ROHAP3dxO2EiLPGslPuxiGRHKmhM6mgkY2j5FXvRc8AnJwdKcGewlNWR4eeMUbDlofRHN5MeiB6YacmwggRxXNv1UQuVpLMI4qglH4ta2iSFmaLPgP9cHXDOizc0zVwdsdTJzwlOgb9VLBKepCkLthnc4ml5uso1QlnpH7DCiGsYwTT4QtQAeX92c0K+J2E1Ry1yGNcIk0Jx3n43oXZjS6pVHFupFmq/HQCZMlNQBX5g+tzGgWTP2jsJ4KHJWB/QgFZuWiD/QalbrpYgg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(39850400004)(136003)(4326008)(66476007)(66556008)(66446008)(52536014)(5660300002)(186003)(76116006)(7416002)(122000001)(2906002)(66946007)(6506007)(107886003)(53546011)(7696005)(8936002)(9686003)(8676002)(38100700002)(83380400001)(316002)(55016002)(26005)(33656002)(54906003)(86362001)(71200400001)(110136005)(478600001)(64756008)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUZpczVrL2diLzZ2VzAyeEhUM2Nkd0NlbThLcnNiMFFDNmxadVpmZ3ZYU1Jv?=
 =?utf-8?B?SmpSeittUmxudWc3K2JyU09sMERrNWpHVjZVN2k0VUpKWGZ2SjgwNzBYUFBU?=
 =?utf-8?B?bHZDd1N5STExUENLbmY1QzYwd01DZWFKRFlWcFVwaFVOOThITm1sZUpyZGN5?=
 =?utf-8?B?a2dlMUEwSjRtQllhM1hBS05kWDducEgxbnZIaHdMWnlQL2lzNXg3M2JuZnNP?=
 =?utf-8?B?bzRnQnNUVDdPb1pPVFU0c2hYaDFpT0VyV1B0Ti9RWUNRR1ZIQjlmMlFGNyt6?=
 =?utf-8?B?eThhQzdDMG9QZ1V6VHBhSnB5QzhEV3hqNTVGdjUyaFJtQnhoaGVKVFNzUHFo?=
 =?utf-8?B?Zld6N0Frd1ExNjI3QmhlcysyaDFEZFpyVGJ6NjVZaWxTNXd2aEcrTS80THMz?=
 =?utf-8?B?N003bTVwSTFHNWhnMXZTVVNJOTFNV3JqUUFpNGNHRFRWY2t1MWdKMk5kQVow?=
 =?utf-8?B?cmRmTHBvQkdiWjR2akM1N1dSZE5abk5uSGhWQkk0eGVIQnAxRk11UUZwc2p2?=
 =?utf-8?B?UHZrVzVrQng1WEx0ZmdleWxiWEVGWnB5WkpFZDhtcTBJY0o0Q2xvSDdkWUhn?=
 =?utf-8?B?V2h0Ui9TVk80ZFdYWkJtaFFjOTBuK0NLOTdqbkNKV01MWWk5a1dhekpaeHZ2?=
 =?utf-8?B?bDZiL1hucFFzTTROVW5mekhqUkUxZHozVGhEYmVVV3NienRHL0M1L1dqRzg4?=
 =?utf-8?B?Rjh1dlNRajhtRlNPdkxTZU41WHcvRmhvaGZGRFJHSENMS0xRcHFVb0czUU9P?=
 =?utf-8?B?clA0K0poQmNOMzBFRC8vaXgzL2svZlFscG05WXpiWU9qRmRqTU9sSmxENVk2?=
 =?utf-8?B?R1J4LzBrMjMvclovakU4MWFHcVIyU1kvWHhMZUYzcUc5RmtzVW5oNVFET2Ji?=
 =?utf-8?B?ODR3ZTgvS0xCcDZCNzlMS3l3UzNkSHJjUVovUUc2S2RtTkE3S3VYb2FBcCtk?=
 =?utf-8?B?a25NVjZnNHBSYkZmWGhySEhVUkt0bkMvdmZvazlqRjJWS1RRelVXTlZpeGd0?=
 =?utf-8?B?d09vMGJtMVRRZzlOa3J2bUF0SWhsVXc2amE4SktiVFFDdEUzVmhqNks3Z3pW?=
 =?utf-8?B?UWZiSFRNL2R5RlhyZjBodjVsbitkeUphdEhhYU9KSWI4Y09jdVdoTE15VUtv?=
 =?utf-8?B?VTZMUU11UFFaTXdtOUFSMWNhaDlPRjVDZnIwYlZScFR2WG5IbzdJQWxnTFZS?=
 =?utf-8?B?ay9qSDdTNEIvTFROSEdpUjBBT0xLQStMM2hVY1BzbGlOVThmdVBQM3dlVHJu?=
 =?utf-8?B?b0liOFFFQ21FSnR6K2lLTE5BbTVQZmN1NEhZaVBMRHg0MytMVkxVREdKVC8r?=
 =?utf-8?B?OGxZTTZrL0NWRmwzTnBaUlprVUNHRElqTlFpR3dzM3Vua2pGRjRwaGRTZzNr?=
 =?utf-8?B?THQxSGJjSEZEbkdCTnVoRHNzVC9Hc2lOeWZ5ekc3L01LNkVsNkN0TXBUekpI?=
 =?utf-8?B?Y0RJNW1rNi9jZTVPZkJzN2RLSEpET282QTBlUmlwLzZodlBGZWNRclNEQ2FR?=
 =?utf-8?B?OHlGWEx0Wk5UMEZ3VDRUYXlQOEhMRHUzSXhjZFFXVEZ3N1UxTHd2UW5YdWVa?=
 =?utf-8?B?WVRDdXE1L1JtSnJzdFE1NjVNZ2ZoRXJwc3lWTFc3ZFJOY3dCUjZGOEdpalU0?=
 =?utf-8?B?UUVjbDdoTGk4NnJOSEVlSlRsbTNTTUorZmNkRXJNTU81WTcyRjAwbklFcFI3?=
 =?utf-8?B?UVNoMWZoZ2VkK3hwTGQ0ZFlwNXgxU3AxVHp3RC83WjRVdG8wNVZ0ODZqWk9Z?=
 =?utf-8?Q?6w6IGcF0GwwpYsP1EE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 385eb5df-db77-402a-e2dd-08d963efb1e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2021 15:32:18.0836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hOTIM9aWua13t6IXxNSvCFXGJ9niCRwHyHb/gZ55y2LS677veuzbXq5symmFlIanciNo03zJd2sYK9zr8HAf4BMSwFZuxv+Q+4O9goMSi2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB5154
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQoNCj4gU3ViamVjdDogUkU6IFtQQVRDSCBuZXQtbmV4dCAwOS8xOF0gcmF2
YjogRmFjdG9yaXNlIHJhdmJfcmluZ19mcmVlDQo+IGZ1bmN0aW9uDQo+IA0KPiBIaSBTZXJnZWks
DQo+IA0KPiBUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCj4gDQo+ID4gU3ViamVjdDogUmU6IFtQ
QVRDSCBuZXQtbmV4dCAwOS8xOF0gcmF2YjogRmFjdG9yaXNlIHJhdmJfcmluZ19mcmVlDQo+ID4g
ZnVuY3Rpb24NCj4gPg0KPiA+IEhlbGxvIQ0KPiA+DQo+ID4gT24gNy8yMi8yMSA1OjEzIFBNLCBC
aWp1IERhcyB3cm90ZToNCj4gPg0KPiA+ID4gRXh0ZW5kZWQgZGVzY3JpcHRvciBzdXBwb3J0IGlu
IFJYIGlzIGF2YWlsYWJsZSBmb3IgUi1DYXIgd2hlcmUgYXMgaXQNCj4gPiA+IGlzIGEgbm9ybWFs
IGRlc2NyaXB0b3IgZm9yIFJaL0cyTC4gRmFjdG9yaXNlIHJhdmJfcmluZ19mcmVlIGZ1bmN0aW9u
DQo+ID4gPiBzbyB0aGF0IGl0IGNhbiBzdXBwb3J0IGxhdGVyIFNvQy4NCj4gPiA+DQo+ID4gPiBT
aWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4g
PiBSZXZpZXdlZC1ieTogTGFkIFByYWJoYWthciA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJw
LnJlbmVzYXMuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVu
ZXNhcy9yYXZiLmggICAgICB8ICA1ICsrKw0KPiA+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3Jl
bmVzYXMvcmF2Yl9tYWluLmMgfCA0OQ0KPiA+ID4gKysrKysrKysrKysrKysrKy0tLS0tLS0tDQo+
ID4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAzNyBpbnNlcnRpb25zKCspLCAxNyBkZWxldGlvbnMoLSkN
Cj4gPiA+DQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiLmgNCj4gPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiA+
IGluZGV4IGE0NzRlZDY4ZGIyMi4uM2E5Y2Y2ZTg2NzFhIDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gPiBAQCAtOTg4LDcgKzk4OCwxMiBAQCBlbnVt
IHJhdmJfY2hpcF9pZCB7DQo+ID4gPiAgCVJDQVJfR0VOMywNCj4gPiA+ICB9Ow0KPiA+ID4NCj4g
PiA+ICtzdHJ1Y3QgcmF2Yl9vcHMgew0KPiA+ID4gKwl2b2lkICgqcmluZ19mcmVlKShzdHJ1Y3Qg
bmV0X2RldmljZSAqbmRldiwgaW50IHEpOw0KPiA+DQo+ID4gICAgSG1tLCB3aHkgbm90IHN0b3Jl
IGl0IHJpZ2h0IGluIHRoZSAqc3RydWN0KiByYXZiX2Rydl9kYXRhPw0KPiANCj4gT0suDQo+IA0K
PiA+DQo+ID4gPiArfTsNCj4gPiA+ICsNCj4gPiA+ICBzdHJ1Y3QgcmF2Yl9kcnZfZGF0YSB7DQo+
ID4gPiArCWNvbnN0IHN0cnVjdCByYXZiX29wcyAqcmF2Yl9vcHM7DQo+ID4gPiAgCW5ldGRldl9m
ZWF0dXJlc190IG5ldF9mZWF0dXJlczsNCj4gPiA+ICAJbmV0ZGV2X2ZlYXR1cmVzX3QgbmV0X2h3
X2ZlYXR1cmVzOw0KPiA+ID4gIAljb25zdCBjaGFyICgqZ3N0cmluZ3Nfc3RhdHMpW0VUSF9HU1RS
SU5HX0xFTl07DQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNh
cy9yYXZiX21haW4uYw0KPiA+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJf
bWFpbi5jDQo+ID4gPiBpbmRleCA0ZWYyNTY1NTM0ZDIuLmEzYjhiMjQzZmQ1NCAxMDA2NDQNCj4g
PiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiA+
ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiA+IEBA
IC0yNDcsMzAgKzI0NywzOSBAQCBzdGF0aWMgaW50IHJhdmJfdHhfZnJlZShzdHJ1Y3QgbmV0X2Rl
dmljZQ0KPiA+ID4gKm5kZXYsIGludCBxLCBib29sIGZyZWVfdHhlZF9vbmx5KSAgfQ0KPiA+ID4N
Cj4gPiA+ICAvKiBGcmVlIHNrYidzIGFuZCBETUEgYnVmZmVycyBmb3IgRXRoZXJuZXQgQVZCICov
IC1zdGF0aWMgdm9pZA0KPiA+ID4gcmF2Yl9yaW5nX2ZyZWUoc3RydWN0IG5ldF9kZXZpY2UgKm5k
ZXYsIGludCBxKQ0KPiA+ID4gK3N0YXRpYyB2b2lkIHJhdmJfcmluZ19mcmVlX3J4KHN0cnVjdCBu
ZXRfZGV2aWNlICpuZGV2LCBpbnQgcSkNCj4gPg0KPiA+ICAgIEhvdyBhYm91dCByYXZiX3J4X3Jp
bmdfZnJlZSgpIGluc3RlYWQ/DQo+IEFncmVlZC4NCj4gDQo+ID4NCj4gPiA+ICB7DQo+ID4gPiAg
CXN0cnVjdCByYXZiX3ByaXZhdGUgKnByaXYgPSBuZXRkZXZfcHJpdihuZGV2KTsNCj4gPiA+IC0J
aW50IG51bV90eF9kZXNjID0gcHJpdi0+bnVtX3R4X2Rlc2M7DQo+ID4gPiAgCWludCByaW5nX3Np
emU7DQo+ID4gPiAgCWludCBpOw0KPiA+ID4NCj4gPiA+IC0JaWYgKHByaXYtPnJ4X3JpbmdbcV0p
IHsNCj4gPiA+IC0JCWZvciAoaSA9IDA7IGkgPCBwcml2LT5udW1fcnhfcmluZ1txXTsgaSsrKSB7
DQo+ID4gPiAtCQkJc3RydWN0IHJhdmJfZXhfcnhfZGVzYyAqZGVzYyA9ICZwcml2LT5yeF9yaW5n
W3FdW2ldOw0KPiA+ID4gKwlmb3IgKGkgPSAwOyBpIDwgcHJpdi0+bnVtX3J4X3JpbmdbcV07IGkr
Kykgew0KPiA+ID4gKwkJc3RydWN0IHJhdmJfZXhfcnhfZGVzYyAqZGVzYyA9ICZwcml2LT5yeF9y
aW5nW3FdW2ldOw0KPiA+ID4NCj4gPiA+IC0JCQlpZiAoIWRtYV9tYXBwaW5nX2Vycm9yKG5kZXYt
PmRldi5wYXJlbnQsDQo+ID4gPiAtCQkJCQkgICAgICAgbGUzMl90b19jcHUoZGVzYy0+ZHB0cikp
KQ0KPiA+ID4gLQkJCQlkbWFfdW5tYXBfc2luZ2xlKG5kZXYtPmRldi5wYXJlbnQsDQo+ID4gPiAt
CQkJCQkJIGxlMzJfdG9fY3B1KGRlc2MtPmRwdHIpLA0KPiA+ID4gLQkJCQkJCSBSWF9CVUZfU1os
DQo+ID4gPiAtCQkJCQkJIERNQV9GUk9NX0RFVklDRSk7DQo+ID4gPiAtCQl9DQo+ID4gPiAtCQly
aW5nX3NpemUgPSBzaXplb2Yoc3RydWN0IHJhdmJfZXhfcnhfZGVzYykgKg0KPiA+ID4gLQkJCSAg
ICAocHJpdi0+bnVtX3J4X3JpbmdbcV0gKyAxKTsNCj4gPiA+IC0JCWRtYV9mcmVlX2NvaGVyZW50
KG5kZXYtPmRldi5wYXJlbnQsIHJpbmdfc2l6ZSwgcHJpdi0NCj4gPiA+cnhfcmluZ1txXSwNCj4g
PiA+IC0JCQkJICBwcml2LT5yeF9kZXNjX2RtYVtxXSk7DQo+ID4gPiAtCQlwcml2LT5yeF9yaW5n
W3FdID0gTlVMTDsNCj4gPiA+ICsJCWlmICghZG1hX21hcHBpbmdfZXJyb3IobmRldi0+ZGV2LnBh
cmVudCwNCj4gPiA+ICsJCQkJICAgICAgIGxlMzJfdG9fY3B1KGRlc2MtPmRwdHIpKSkNCj4gPiA+
ICsJCQlkbWFfdW5tYXBfc2luZ2xlKG5kZXYtPmRldi5wYXJlbnQsDQo+ID4gPiArCQkJCQkgbGUz
Ml90b19jcHUoZGVzYy0+ZHB0ciksDQo+ID4gPiArCQkJCQkgUlhfQlVGX1NaLA0KPiA+ID4gKwkJ
CQkJIERNQV9GUk9NX0RFVklDRSk7DQo+ID4gPiAgCX0NCj4gPiA+ICsJcmluZ19zaXplID0gc2l6
ZW9mKHN0cnVjdCByYXZiX2V4X3J4X2Rlc2MpICoNCj4gPiA+ICsJCSAgICAocHJpdi0+bnVtX3J4
X3JpbmdbcV0gKyAxKTsNCj4gPiA+ICsJZG1hX2ZyZWVfY29oZXJlbnQobmRldi0+ZGV2LnBhcmVu
dCwgcmluZ19zaXplLCBwcml2LT5yeF9yaW5nW3FdLA0KPiA+ID4gKwkJCSAgcHJpdi0+cnhfZGVz
Y19kbWFbcV0pOw0KPiA+ID4gKwlwcml2LT5yeF9yaW5nW3FdID0gTlVMTDsNCj4gPg0KPiA+ICAg
IENvdWxkbid0IHRoaXMgYmUgbW92ZWQgaW50byB0aGUgbmV3IHJhdmJfcmluZ19mcmVlKCksIGxp
a2UgdGhlDQo+ID4gaW5pdGlhbCBOVUxMIGNoZWNrPw0KPiANCj4gRm9yIFJaL0cyTCwgaXQgaXMg
cHJpdi0+cmdldGhfcnhfcmluZywgdGhhdCBpcyB0aGUgcmVhc29uLg0KPiANCj4gSSBjYW4gbW92
ZSB0aGUgaW5pdGlhbCBOVUxMIGNoZWNrIGhlcmUsIHNvIHRoZSBnZW5lcmljIHJhdmJfcmluZ19m
cmVlIGRvZXMNCj4gbm90IGRpZmZlcmVudGlhdGUgYmV0d2Vlbg0KPiBwcml2LT5yeF9yaW5nIGFu
ZCBwcml2LT5yZ2V0aF9yeF9yaW5nLiBTZWUgYmVsb3cuDQo+IA0KPiA+DQo+ID4gPiArfQ0KPiA+
ID4gKw0KPiA+ID4gK3N0YXRpYyB2b2lkIHJhdmJfcmluZ19mcmVlKHN0cnVjdCBuZXRfZGV2aWNl
ICpuZGV2LCBpbnQgcSkgew0KPiA+ID4gKwlzdHJ1Y3QgcmF2Yl9wcml2YXRlICpwcml2ID0gbmV0
ZGV2X3ByaXYobmRldik7DQo+ID4gPiArCWNvbnN0IHN0cnVjdCByYXZiX2Rydl9kYXRhICppbmZv
ID0gcHJpdi0+aW5mbzsNCj4gPiA+ICsJaW50IG51bV90eF9kZXNjID0gcHJpdi0+bnVtX3R4X2Rl
c2M7DQo+ID4gPiArCWludCByaW5nX3NpemU7DQo+ID4gPiArCWludCBpOw0KPiA+ID4gKw0KPiA+
ID4gKwlpZiAocHJpdi0+cnhfcmluZ1txXSkNCj4gPiA+ICsJCWluZm8tPnJhdmJfb3BzLT5yaW5n
X2ZyZWUobmRldiwgcSk7DQo+ID4NCj4gPiAgICAuLi4gaGVyZT8NCj4gDQo+ICAgICAgSXQgd2ls
bCBiZSBqdXN0ICBpbmZvLT5yYXZiX29wcy0+cmluZ19mcmVlKG5kZXYsIHEpOyBBbmQgTlVMTCBj
aGVjaw0KPiB3aWxsIGJlIGhhbmRsZWQgcmVzcGVjdGl2ZSByeCBoZWxwZXIgZnVuY3Rpb24uDQoN
Ckkgd2lsbCBiZSBzZW5kaW5nIG5leHQgc2V0IG9mIHBhdGNoZXMgaW5jb3Jwb3JhdGluZyB0aGUg
YWJvdmUgY29tbWVudHMNCndpdGhpbiBjb3VwbGUgb2YgZGF5cy4NCg0KUmVnYXJkcywNCkJpanUN
Cg==
