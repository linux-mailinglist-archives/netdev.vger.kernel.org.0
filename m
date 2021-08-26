Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80213F825D
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 08:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238990AbhHZGVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 02:21:10 -0400
Received: from mail-eopbgr1400117.outbound.protection.outlook.com ([40.107.140.117]:32400
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237805AbhHZGVI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 02:21:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjJ6fgLZmRgLN4qV32mIpTqMpkOh5GIoQ0h/ECID8p9QB5LvRi2BYZjZYj/yUaelMmsPIaf7erPDcUzinkFyGRNJ/FPpC928KSaYP+4hoo1QIJoXJo7qLjr0lxODLeIAD5SpvjN2uoLQIurD3yVz7V0lSuGB/T9QLZFCou6Nh8lO9+vae2wq4Nf1P8HbqWriodPcR0sRk9WH9B6zhPuE4oLvd1Q1yMUvAvjZ2x18xuBRZMQ6kc84giUq1A445qJi/AtFDnoX8he7K34J3Sy79rIUoe4StTV0jJFHUX/0ubLRsO6fzLEtUxCdjHCNt/IKWVUWWdfKDSaf0ReZApRyCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U5Tln46IKcuBg+KIQxLLJyDwmKe7ynC0pEZTe0+gWCw=;
 b=UBbX2DkinwlISdt9sx+BG8MVlrLnz8iE9k8L5a41WywMBdqbXbUyprw4Sx9leuzvps8oT60xmipT3sZeIWtdE9ZKWgGb7XEOgr3sIDy1xO/5aOqRSm1gBhDLH9Joj6XrPjcFrzLvVgeBS8Rca+AnnuOmTOJF+QRialNc7gug5AwSja3+5ZqwWICNaEQuCtFYY4ApBiQ1i/rbJacNsRTWw0vhekcABcqd9TKFamdd+oOw8+1LwuE1JPhl8yt6VRm3b6B73xQmq0TrhSjbGkEL7U8/843lc0NloSEWKN/IjveWUJNOV4eeE+shwl9GEchqE9/y/Qg3890VUKnZD4v1wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U5Tln46IKcuBg+KIQxLLJyDwmKe7ynC0pEZTe0+gWCw=;
 b=Cg9HS4btXPj2fEz+v1P8uuYwBjYnM4hfkLqlilCbT+Nwww//N60o/ZZxd3XBC3E8D2uN4cQ8GgCLSmeO2moGFYmT23ct+dHow70f6HMxTArZBvAJ8O5YT4aPT905Yfk1LGdmnP2SpjZrrLoQSH097/edRUu5QdeLuSDBS9v47es=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB2530.jpnprd01.prod.outlook.com (2603:1096:604:3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Thu, 26 Aug
 2021 06:20:19 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98%3]) with mapi id 15.20.4436.025; Thu, 26 Aug 2021
 06:20:19 +0000
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
Subject: RE: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
 ravb_hw_info
Thread-Topic: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
 ravb_hw_info
Thread-Index: AQHXmX8jVvjbtjTRLEe2lQMMRo0BcquEr1UAgAChqBA=
Date:   Thu, 26 Aug 2021 06:20:19 +0000
Message-ID: <OS0PR01MB59220BCAE40B6C8226E4177986C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-5-biju.das.jz@bp.renesas.com>
 <777c30b1-e94e-e241-b10c-ecd4d557bc06@omp.ru>
In-Reply-To: <777c30b1-e94e-e241-b10c-ecd4d557bc06@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61afa5a4-579f-4c11-6b5c-08d968599405
x-ms-traffictypediagnostic: OSAPR01MB2530:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB2530B6750E9C2350B33ED45886C79@OSAPR01MB2530.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o++YNmjhSr55qmxBusriI/q3A2+1N0lujbB4JBgTL3mSeFLdPd/uMXrno+JQxBEsbxuJIM85/7LKchnv8vrM9k4JbZWYniiFq1NF5y2qRsidyfFO9TlUYcpAEd372rR3+16RjsVw3MMGRgzCEyBbfQ7Qg/iIEsHp5YKjsoenUSFhIsvbCxvZC+EyVcY/ynN5NnyQMD9Xr3ncXv41qGfGbEMRS8XXf9NTINNEsDlxCB3lwaS3HMo6Z5EGaztIS4VbGbqmG/OnG8qfbLRR3jPXAtdhusbSFPs+R0zJSeZaHh8sjGkK5432L7R5FwFiBgI4THhdY9MdHT6s5PJjn8LguA7q3oz6XlOwUHm88PAD+9lESHbFIwFGiDlnJdAzFcarMFVk9kSlpUmX1NRSUIfxPiVqeDps5IKSZaO3qb5MpEQDoLn4SsqoVjWzTOXLPEFnBCbAu7EC7/+k5P7gKsJ+Ppxl1BVrx5JbMVmCPK2AX81FyU2lnk0J4mfT20dMcHUzftMSdBLjgkm1SOxYbqCVlMFVyBm7nUHOqOdx1ZbwgZ29y9hSPdEgQfAY1dQymQdugLEXF3x8LyfhApPim44L9J3+qy7rNsyvP/pumH+SEzAAQCw+fl1C5cOPZNsxK4Gf68cXltX200Y0OvBCWPGpaxN3EBXh3tpeRc5ACYVgLcrQ2vI7FPw20OKHM4uzTqlObrZsHqzueZY5gs3TU0QoSxta+nUWbSAOOu7E73u8fYAN5vWYdvbQhftEz1TNOYRXH75at0cAI67n6ULxH9bGl0r7FjKwqHTiXON6em21REM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(33656002)(107886003)(122000001)(6506007)(7696005)(53546011)(186003)(38100700002)(86362001)(83380400001)(71200400001)(55016002)(9686003)(66476007)(966005)(64756008)(52536014)(66946007)(66556008)(508600001)(66446008)(26005)(76116006)(5660300002)(8936002)(54906003)(110136005)(38070700005)(8676002)(2906002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1JGYkZlRFNqMHBhN0pqdFN2bVN4UFhRd1B6Q0ZQWmNYeDVobklYVGMvc1ZD?=
 =?utf-8?B?azg5YnZOcmtMUHh4SGQ0S3F5WVNWeFFMVnNPUWdMbXVXc2t3cHp1aUh6Mmt4?=
 =?utf-8?B?eHdjRnV3MVdTS0ZOU1hzaFNTb1kvRFR2MVdQOGxvOENYWXNWMVVGdS9lYlVr?=
 =?utf-8?B?NXRHV2pkWVBVcXpJMzJLRWNyaDViV3NUM3h3aXV5Y3htSXZyaFRUbnMvUDlQ?=
 =?utf-8?B?M29lYkNmTWNiWjJ0VmViMVdrcWl0V1Q4RVprWUpHeG9KbTBQRzJKZXBBY0VL?=
 =?utf-8?B?bGo1c1FpT2xTMjVPcFBxczJSRGhGdXZSSTdFR1oxMFpSUVd0d2cva2E4MHVp?=
 =?utf-8?B?aitSTTZxWGwxd3psNThXWjlOZnp5bWVQYWxxMzJuZzRjSWV0L2gyT3pycVdG?=
 =?utf-8?B?RmkraE51TmpZbC9KRlUrY29xaDI0dmdGVWs3ZEFWWGFlMTNpT05xUzh4OXpj?=
 =?utf-8?B?Mjk3NGdIcktVV3kybzl1VnJSZHJkekI3WHNPY2VxbG1vZHhqK0Z0UTJJNXZQ?=
 =?utf-8?B?QVhkd0hURXUrWU1IdEJOdXVEVHJBTlRMZGZEa2g2dnNZYmtPQkc4RmNkOHIr?=
 =?utf-8?B?WEtrZWZhK2ZySTlNRVlxeXNldkQzQ2FpUU1GQVJnWUxFVm1BM29jQkN2MUN2?=
 =?utf-8?B?T0VsRk94Wmdad21SRU1QbGk3aGhrNzd4bU5PNGg4M0MySlRxS29ZR24wMXhy?=
 =?utf-8?B?MTh0dDVzY0czWXY1bkt6S3gydDU1RHVOeHhseE5zb1JOdjNMMWxFcWtKNm5v?=
 =?utf-8?B?Smd6QkwyVFI5MytrT2xyV05TeHFvVnNoaTZKRXRCd0RVaVVYMGg3cTV2eFNW?=
 =?utf-8?B?TnNZeituZGp2T1FLTzdZbENNUSsvdzBXYUpjdFYrSkhmK3FrODJmY1gzRllP?=
 =?utf-8?B?ZzJnY2hEeGhacE9QV1o1SVBlYUNmZFlHM255SWhIWjJQWE9HeGx2dVV3eFUy?=
 =?utf-8?B?N3UzSW9vRTE0WU1laDB1bHNQWmdqN2lKN1RjZ25yN0VXTk1pdTBSQ2MyZHVD?=
 =?utf-8?B?UUtYQ0ZibS92d29uRytnT0tUQ2tDOTZxbUpQTlNuMnlUcFYreGszdzFrVVp2?=
 =?utf-8?B?TjFNaEQ4UXpQM0MvdFJZd1UwMkFQRXVwb2s0c2tPTUpVVkR4d2FhWmVvN0lM?=
 =?utf-8?B?WC80RWhFUG5zdVExTHlhUkdPSFpSNGhlWDNrYUVKdGN1OVZIamRETFdMTFRp?=
 =?utf-8?B?Z0pRRVhIdUZ6bUpNSmZQUU5aRVVCckZXdGJNK0M0SG91Y0s3YjdiNmVHS1lI?=
 =?utf-8?B?UUx6ZFBRSElpWnRKYWZwSHR3bmZUNjVrNDVlRHVQMTB2UFFCNHZBcDRPUkpS?=
 =?utf-8?B?bkdLclppdzlnTTRMeGxGdTVVbTJxQlREQUd5UVN1VFQzdFJLSGJlNC9lNXA3?=
 =?utf-8?B?NEg5MndpYmxTZnYxQmo0S2FTc0tac2tVNndSWnVhc0t1V3JwWW5iUUhmV1po?=
 =?utf-8?B?Z3NWNkRZUjVzSlNQdERYVS80cjk0Yy85SE1Pc2xHWm1nTGV3ZU1iOWw0M2F1?=
 =?utf-8?B?UGFCOFh1RUZQM25QM3FjWTJKUFNpQTZUaVB6bzFMUnRRZ0xpbW5UQnJTdmlC?=
 =?utf-8?B?bTc3c1d5TnFaRXZwL0ozMjFBYzZiM3lSSUMzYmNhdkRhd3FlZk13Wkd0MElW?=
 =?utf-8?B?QTY4aHdub0RsbjRMaHJTRS8rUE0rY2xqNGt6U0FWd3JadDlnNEMzUU56ZVF4?=
 =?utf-8?B?d29JR1JIWTBNU25DQmdKcTBpZEU0enNxazVZSUJSV2sycWozQmtQc0U5cDk0?=
 =?utf-8?Q?Vx456QmYQAxAeeKIvJerQskoKCemM71RW+I7KNR?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61afa5a4-579f-4c11-6b5c-08d968599405
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 06:20:19.2724
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8zbfJbD/xutKm4rkjjwEjvWBUrBzYH0B+ZrwcqpcSIpMDmREzF1pfTc/zD0KpSJZ+FF+ShpgsA7ezjwYf/7F3pwrsBCbHDZDgZgZw2eMqh0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2530
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IDA0LzEzXSByYXZiOiBBZGQgcHRwX2NmZ19hY3RpdmUgdG8gc3RydWN0
DQo+IHJhdmJfaHdfaW5mbw0KPiANCj4gT24gOC8yNS8yMSAxMDowMSBBTSwgQmlqdSBEYXMgd3Jv
dGU6DQo+IA0KPiA+IFRoZXJlIGFyZSBzb21lIEgvVyBkaWZmZXJlbmNlcyBmb3IgdGhlIGdQVFAg
ZmVhdHVyZSBiZXR3ZWVuIFItQ2FyDQo+ID4gR2VuMywgUi1DYXIgR2VuMiwgYW5kIFJaL0cyTCBh
cyBiZWxvdy4NCj4gPg0KPiA+IDEpIE9uIFItQ2FyIEdlbjMsIGdQVFAgc3VwcG9ydCBpcyBhY3Rp
dmUgaW4gY29uZmlnIG1vZGUuDQo+ID4gMikgT24gUi1DYXIgR2VuMiwgZ1BUUCBzdXBwb3J0IGlz
IG5vdCBhY3RpdmUgaW4gY29uZmlnIG1vZGUuDQo+ID4gMykgUlovRzJMIGRvZXMgbm90IHN1cHBv
cnQgdGhlIGdQVFAgZmVhdHVyZS4NCj4gPg0KPiA+IEFkZCBhIHB0cF9jZmdfYWN0aXZlIGh3IGZl
YXR1cmUgYml0IHRvIHN0cnVjdCByYXZiX2h3X2luZm8gZm9yDQo+ID4gc3VwcG9ydGluZyBnUFRQ
IGFjdGl2ZSBpbiBjb25maWcgbW9kZSBmb3IgUi1DYXIgR2VuMy4NCj4gDQo+ICAgIFdhaXQsIHdl
J3ZlIGp1c3QgZG9uZSB0aGlzIGlvbiB0aGUgcHJldmlvdXMgcGF0Y2ghDQo+IA0KPiA+IFRoaXMg
cGF0Y2ggYWxzbyByZW1vdmVzIGVudW0gcmF2Yl9jaGlwX2lkLCBjaGlwX2lkIGZyb20gYm90aCBz
dHJ1Y3QNCj4gPiByYXZiX2h3X2luZm8gYW5kIHN0cnVjdCByYXZiX3ByaXZhdGUsIGFzIGl0IGlz
IHVudXNlZC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBi
cC5yZW5lc2FzLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogTGFkIFByYWJoYWthciA8cHJhYmhha2Fy
Lm1haGFkZXYtbGFkLnJqQGJwLnJlbmVzYXMuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25l
dC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaCAgICAgIHwgIDggKy0tLS0tLS0NCj4gPiAgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8IDEyICsrKysrLS0tLS0tLQ0KPiA+
ICAyIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMTQgZGVsZXRpb25zKC0pDQo+ID4N
Cj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4g
PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gaW5kZXggOWVjZjFh
OGMzY2E4Li4yMDllMDMwOTM1YWEgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2Fz
L3JhdmIuaA0KPiA+IEBAIC05NzksMTcgKzk3OSwxMSBAQCBzdHJ1Y3QgcmF2Yl9wdHAgew0KPiA+
ICAJc3RydWN0IHJhdmJfcHRwX3Blcm91dCBwZXJvdXRbTl9QRVJfT1VUXTsgIH07DQo+ID4NCj4g
PiAtZW51bSByYXZiX2NoaXBfaWQgew0KPiA+IC0JUkNBUl9HRU4yLA0KPiA+IC0JUkNBUl9HRU4z
LA0KPiA+IC19Ow0KPiA+IC0NCj4gPiAgc3RydWN0IHJhdmJfaHdfaW5mbyB7DQo+ID4gIAljb25z
dCBjaGFyICgqZ3N0cmluZ3Nfc3RhdHMpW0VUSF9HU1RSSU5HX0xFTl07DQo+ID4gIAlzaXplX3Qg
Z3N0cmluZ3Nfc2l6ZTsNCj4gPiAgCW5ldGRldl9mZWF0dXJlc190IG5ldF9od19mZWF0dXJlczsN
Cj4gPiAgCW5ldGRldl9mZWF0dXJlc190IG5ldF9mZWF0dXJlczsNCj4gPiAtCWVudW0gcmF2Yl9j
aGlwX2lkIGNoaXBfaWQ7DQo+ID4gIAlpbnQgc3RhdHNfbGVuOw0KPiA+ICAJc2l6ZV90IG1heF9y
eF9sZW47DQo+IA0KPiAgICBJIHdvdWxkIHB1dCB0aGUgYWJvdmUgaW4gYSBzcGVhcnRlIHBhdGNo
Li4uDQo+IA0KPiA+ICAJdW5zaWduZWQgYWxpZ25lZF90eDogMTsNCj4gPiBAQCAtOTk5LDYgKzk5
Myw3IEBAIHN0cnVjdCByYXZiX2h3X2luZm8gew0KPiA+ICAJdW5zaWduZWQgdHhfY291bnRlcnM6
MTsJCS8qIEUtTUFDIGhhcyBUWCBjb3VudGVycyAqLw0KPiA+ICAJdW5zaWduZWQgbXVsdGlfaXJx
czoxOwkJLyogQVZCLURNQUMgYW5kIEUtTUFDIGhhcyBtdWx0aXBsZQ0KPiBpcnFzICovDQo+ID4g
IAl1bnNpZ25lZCBub19wdHBfY2ZnX2FjdGl2ZToxOwkvKiBBVkItRE1BQyBkb2VzIG5vdCBzdXBw
b3J0IGdQVFANCj4gYWN0aXZlIGluIGNvbmZpZyBtb2RlICovDQo+ID4gKwl1bnNpZ25lZCBwdHBf
Y2ZnX2FjdGl2ZToxOwkvKiBBVkItRE1BQyBoYXMgZ1BUUCBzdXBwb3J0IGFjdGl2ZSBpbg0KPiBj
b25maWcgbW9kZSAqLw0KPiANCj4gICAgSHVoPw0KPiANCj4gPiAgfTsNCj4gPg0KPiA+ICBzdHJ1
Y3QgcmF2Yl9wcml2YXRlIHsNCj4gWy4uLl0NCj4gPiBAQCAtMjIxNiw3ICsyMjEzLDcgQEAgc3Rh
dGljIGludCByYXZiX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UNCj4gKnBkZXYpDQo+ID4g
IAlJTklUX0xJU1RfSEVBRCgmcHJpdi0+dHNfc2tiX2xpc3QpOw0KPiA+DQo+ID4gIAkvKiBJbml0
aWFsaXNlIFBUUCBDbG9jayBkcml2ZXIgKi8NCj4gPiAtCWlmIChpbmZvLT5jaGlwX2lkICE9IFJD
QVJfR0VOMikNCj4gPiArCWlmIChpbmZvLT5wdHBfY2ZnX2FjdGl2ZSkNCj4gPiAgCQlyYXZiX3B0
cF9pbml0KG5kZXYsIHBkZXYpOw0KPiANCj4gICAgV2hhdCdzIHRoYXQ/IERpZG4ndCB5b3UgdG91
Y2ggdGhpcyBsaWUgaW4gcGF0Y2ggIzM/DQo+IA0KPiAgICBUaGlzIHNlZW1zIGxpZSBhIE5BSyBi
YWl0Li4uIDotKA0KDQpQbGVhc2UgcmVmZXIgdGhlIG9yaWdpbmFsIHBhdGNoWzFdIHdoaWNoIGlu
dHJvZHVjZWQgZ1BUUCBzdXBwb3J0IGFjdGl2ZSBpbiBjb25maWcgbW9kZS4NCkkgYW0gc3VyZSB0
aGlzIHdpbGwgY2xlYXIgYWxsIHlvdXIgZG91YnRzLg0KDQpbMV0gaHR0cHM6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbmV4dC9saW51eC1uZXh0LmdpdC9jb21taXQv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYz9oPW5leHQtMjAyMTA4MjUm
aWQ9ZjVkNzgzN2Y5NmU1M2E4YzliNmM0OWUxYmM5NWNmMGFlODhiOTllOA0KDQpSZWdhcmRzLA0K
QmlqdQ0KDQo+IA0KPiBNQlIsIFNlcmdleQ0K
