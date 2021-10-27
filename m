Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5F043CA3B
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 14:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242046AbhJ0NBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 09:01:25 -0400
Received: from mail-eopbgr00078.outbound.protection.outlook.com ([40.107.0.78]:1959
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235978AbhJ0NBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 09:01:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yp4nbxNM5BktN7Wfg4Ttz1EqGEr4DRc3YyBoG26Cd1TmGHuRH7c6EKgdGSQD6a8nLXG3fRdsYRCr87YPWsMlj+FlaTyEaoJU3/S8I3w879sxB/0z4G533+i++ztKFvZxV0CH+oVdNPKzNJFJyIozZOzSDsHegtH/nu5U0nxMpZrO5Eh+cMKtp9hfPwA9MnnhiBnOBrfrzVXBZopfosuDBFkFKjIrA/KGXFMOHGxUUXkk1lv5RqgRQlI/l1esc9R8uagwhwCEfYKRtx/Et9ELu1XPD4ENU6dFHG3jlmw+OtM0vw6BI1P2tUOD47SK7CShc/0c12WDQ5H1cZEZHM1cfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z8DSuvwV/u1u6i4bS51kFeNiUJIqOmDN1ePHPaLU4zI=;
 b=hrJn+E92kVPKP8eb04k1xJnrgohEm5wWfTv5knPpGtiU6lzzag4uTbDHYQeTPZTahIKFLNDv6AOs4/3gbmafSgy0JhaZQTf0vvaGw0ASWv1HsnUNtJeo+t+x9j8HIrQWoOJv6AOfc2uoWNiv3sXywhquhfAqVgtz+cD9PtwvlkCMK0NDZrCGjBDk/KbVZEqaB5+r5twkW7ymVZyYM15cVgTe9wcSU2hIK2HFkrxDfNFOBVPERXeniwYgh/aNN5R83r53tdl0kI9NaMXBpx1Yojdw3wt0tKd6MacOwtwjlFY0XYJ98ddHIiqjhr7OSo5EoNJhsq2iRoZcaSt7dCbhow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z8DSuvwV/u1u6i4bS51kFeNiUJIqOmDN1ePHPaLU4zI=;
 b=IhXRkpcUqWRqHzXIhcL+CvbUYd6L2YHNb8yeYeyRzjlPIwm5DXzfRfAy90lP+w5hl1IGow6qU5JrxmDzS9zIX9gKqjoDA9QfE1hxSdj67DeZV0Dj0WWopRlKHYOcfvUWxmX86DcE91OWtmeDrx5prTwcbXS8BQkY4pQr4b5G4c4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 12:58:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 12:58:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 6/8] net: bridge: move br_fdb_replay inside
 br_switchdev.c
Thread-Topic: [PATCH net-next 6/8] net: bridge: move br_fdb_replay inside
 br_switchdev.c
Thread-Index: AQHXynWzjMHxru/+PEOzqRDNrxzwF6vmgQIAgAADSICAAEuXAA==
Date:   Wed, 27 Oct 2021 12:58:57 +0000
Message-ID: <20211027125856.wypzqjpepceq3jsy@skbuf>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
 <20211026142743.1298877-7-vladimir.oltean@nxp.com>
 <YXkK5jp7FHwJEeuw@shredder> <b73e4afe-07a7-08df-cc29-c2490265f2f8@nvidia.com>
In-Reply-To: <b73e4afe-07a7-08df-cc29-c2490265f2f8@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87516ed5-d4c7-4996-b855-08d9994989f7
x-ms-traffictypediagnostic: VI1PR04MB4222:
x-microsoft-antispam-prvs: <VI1PR04MB4222591C1947BE760B1D0670E0859@VI1PR04MB4222.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GFDJKN9p/5kESBVsdcutli0QMC/AshPfj0fyr+vXz3DGaK3Q2OiS7yWttuRqBmUKS0IoQWVABHKTeSH5PDoLoPb72BIJFZljgH3v3u+gDXe2FRMF2DSfa6ozDlVM4auLE8k6NAuvCWgxqoqkwCRqQfT6LRxpThf7BVMKn1VD9s91O48ddJZowVhXFVgGYTi+x+Sr5XjkYZbCIbWsrXgC6n33oVdInT/XAQ8VIRElfV+PUXmOmRAXzptPCnUGyxsR8FVlaJEckE19P7IRSL8tyyJYPUkCgLqVA4t9Yt1PmQJj9NhLGqIWMhITJ52LfDw7ed8VwzTOTYgTjTSvCM3he9A8nAXk/BhYy7qiXGEgJ7KbmlUa1eurrNGVhKZekKt7ogmH8RbgU5ioxuce9AMJ7rJ5nLX7xnuCpzhheVij21CrfR2/8/dKFaLa2Wdo+e59Ek4Sq+BBs1uT9gNlvajng8glO7ZwcHkXaGhRZbYOK52CJ7RUPBUwhnmTgiW4tukuWsunmct0Gal3BY02lqlbR1ZQlfMI1OonGEV1GFZpr5zFUrMVKXY6hM3WI1WlnC7uT9KCH0wmjsNLtPsmf0QQHEbzuOotkAX6mTb5NdPzppNxOQaJWh5HH9AkpgPqmVC0qLV/rH2XkFE9nO51PJvw8Cu7aXmiw5BcGQqNAcNgNxSHP1y45VdioAZ54YVO+BEllD4Pk2C7JqDnrJOaNJEFqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(71200400001)(508600001)(44832011)(76116006)(38070700005)(1076003)(83380400001)(8676002)(2906002)(5660300002)(6512007)(53546011)(26005)(186003)(66476007)(54906003)(66946007)(7416002)(64756008)(33716001)(9686003)(6486002)(38100700002)(91956017)(316002)(6916009)(6506007)(66446008)(86362001)(66556008)(122000001)(8936002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dVRsUEJlRFBDbW9DWDZhd1V4RTY4UFlpdEdJQ0htOE9wVVRXempUOS93Y1oz?=
 =?utf-8?B?akFMcGhtUGc1VFVOZFNkWklRZXpvem1xQ29VU2cyUzVoT1FOVGVpYXNKQTNx?=
 =?utf-8?B?V21FNE93NlJKeVBCT0NhY21jWUR5am1GVERYTFo5YkY5VE5TK1RiNlpVNnZO?=
 =?utf-8?B?RmZRRG1CSzlYMVordVYxYndBb3lKREZEZXhqWjlnZXgybS9aTXhIbWMzY1FO?=
 =?utf-8?B?bzNpUzViQ2hmejVOMEExRVlPMEtWOTVDZDdYckNPM2pCQnJ6U0Q0UlRsVG9E?=
 =?utf-8?B?QzJ1aS9TVmJ0RHJaOGdsUXMrVWhoSGgvOGpOWmRIWnlvYTFRSTlXVkd2UzlW?=
 =?utf-8?B?K1BtOExoY0xFU2Zjb0R0NjRYM01CVVJCVjM2S0VLbk1HRERmZEtreGp1cGh1?=
 =?utf-8?B?RXVTbzVCam1Zb251QW9KTUsxdVR6YWNrMFlZNkNmSDlKRkQvWlJ4S1lqRlFL?=
 =?utf-8?B?WGF1ZjZEUlhzZGg4ekV6SWpBeWFrZCtwbEREZG16cTFoTzJXRlZmSGIyOFBv?=
 =?utf-8?B?RnhEdlZVSUxBa3VrRDFab04zbys3K0M3a1RlZzJpeEFNcWhjYjhSZUxRN3By?=
 =?utf-8?B?bEVVTDdyU2I1TnNZdE9LL2twZWhFcWg1eUp4UUlieXpuRGJjWk1aSUlGSmVx?=
 =?utf-8?B?QVNCVjQxZTlHeEtEOFZ2Wk1VNkxQSm0xSUJkWG1iNFFMYWh6RmRxcFduQmFu?=
 =?utf-8?B?M0xBMTF6OEdQVmtLUXRXNkpPcTEyemVrQ1dWQzdxcGZYUU92elIwbXoxY1RG?=
 =?utf-8?B?TDFNZDM5a0JmTUNFUnlWaC94U05YOHdLTTlzTDJhUm1HbWFFWWxVY001NnNS?=
 =?utf-8?B?NDFHbk1YbUU4bVFlZ0dRN3hsZlNwNVVPVHNIVWhWbEJtRGZkc3J0cyt6cXQr?=
 =?utf-8?B?Qk5jQ3dXbS9OT2M3K3hTbnZ5QTNZM3JXaG8vSjdEUU1CWkJrMzdYZElNQ1Az?=
 =?utf-8?B?UUUvcjYrdzFyOEtrT3FDUk5wdkhFVHg1bi84Z3FVcWV3V05zZWxTTyszZldF?=
 =?utf-8?B?RmE5Q05tQU5UcE1PTDBBRTVSZFNVdVRjMWRPTVBCa3VLaHhkN0xYdStSSVhx?=
 =?utf-8?B?R1Y5YkJvSUlDTUNTSzNnRm9IdFpmR3RHdmRyc0k4Qmw1d3dqVnZjbDNLSTcv?=
 =?utf-8?B?QTlodXNRbVljUWJjZXhlUVFWeDVjQWJVc21pTDZZMHA3VHBOYnFJQzlzUGhR?=
 =?utf-8?B?bis4azRKSUFlL2VzYnlBZUt3ZGtqYmlIL0dNZmN6c0JjVjRGUUlzcmFtOUYy?=
 =?utf-8?B?YUZYVmNLQ2lQdzZ2dVVwbkhVOW5MaXlNMWFrblFKZlNZeGJEeFRHZHVlZkFp?=
 =?utf-8?B?RkI1RzlaSDFMSHZ3SE5EeEhPcy9TOTVPdGZqUnFydXlFbkp1bXA1RkErY3pl?=
 =?utf-8?B?ZHJ0VG1KQWlaK1FGN3FIZlJwelZ5NUp4U2REbHo1dUJSMzlLSndQSFhrYmFC?=
 =?utf-8?B?eTliWEt1WFlOb2R0cWxRTFpDc1REeWl0WjZVcDJxTXdxSjN5bVFtNWhXam8x?=
 =?utf-8?B?MGZhbHF1ZmdKenNYMk5rOU5ZeldYUWZFZGxudkxCd1l1N0R3UFpWaFdXbVhI?=
 =?utf-8?B?VkV4eVllcmJrRzZRaml0cjhuMG5vVXJiQ05WbDdRWFZoT1l0dTNRZUJyeHkv?=
 =?utf-8?B?TGVsRXcrVjRHNXQ3SWdia3JpcTRPMzAwcWh2Y0I1WUtpencvZVROTjlaV1N5?=
 =?utf-8?B?WjFUdmI0eGlndWF6VGQ0Ym9uS3liaFFROXA5SjUvYU1LM3JLN2VqMHdoV1FZ?=
 =?utf-8?B?Rlp6TytyaTlpWHp6WENWd3NMZGYvSnNYeEJOSWI4VTkwczBvTnNiR0VRZHZi?=
 =?utf-8?B?bXBxM29DdmZNYnY5WVcrKzZOZ0E0akxyQmx2QlV6TlE3RHQ0R3pidk5WSEU4?=
 =?utf-8?B?S2xUaVA0a2l4Wmt2UWFwUmV3eWRnR0FEUGpBSGNVNlp6RTZTVGVJcmJBQjd5?=
 =?utf-8?B?N1Nta3ZUWE0zRGtMZlAvbjBId0h3S0d3Q05EcVZ5VWVjc3k2eVhEVFpJZWhr?=
 =?utf-8?B?QzVoT28zMXpSVHpSc2xTV21YeCtBV053dmQ4bkFpbGxGVGRNV3U0R3pyRHJk?=
 =?utf-8?B?a20zUHJ5Y05ScFh1cWdPS0U1LytFbzdjMUhzUHErczZpZ1BlSlorU3grWncy?=
 =?utf-8?B?WS9kc2laWXhwaUZ3RXhTNFBhSmZCSnNYMUtrK05PeUhqMkt4UjI5dnIyajJu?=
 =?utf-8?Q?j0NdZzm7boXUMolVvx2ujzs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <85BCC4A2413F5E49B44A7CBB5AFB0A50@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87516ed5-d4c7-4996-b855-08d9994989f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 12:58:57.5681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f4a9pDts65cPYeyOE4EeaViwRzBkurmFJC6g+RJCOKfcsxSl1aHckBwvu27QDwbRA1Iqxsd0nr18VdUePY/thg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBPY3QgMjcsIDIwMjEgYXQgMTE6Mjg6MjNBTSArMDMwMCwgTmlrb2xheSBBbGVrc2Fu
ZHJvdiB3cm90ZToNCj4gT24gMjcvMTAvMjAyMSAxMToxNiwgSWRvIFNjaGltbWVsIHdyb3RlOg0K
PiA+IE9uIFR1ZSwgT2N0IDI2LCAyMDIxIGF0IDA1OjI3OjQxUE0gKzAzMDAsIFZsYWRpbWlyIE9s
dGVhbiB3cm90ZToNCj4gPj4gYnJfZmRiX3JlcGxheSBpcyBvbmx5IGNhbGxlZCBmcm9tIHN3aXRj
aGRldiBjb2RlIHBhdGhzLCBzbyBpdCBtYWtlcw0KPiA+PiBzZW5zZSB0byBiZSBkaXNhYmxlZCBp
ZiBzd2l0Y2hkZXYgaXMgbm90IGVuYWJsZWQgaW4gdGhlIGZpcnN0IHBsYWNlLg0KPiA+Pg0KPiA+
PiBBcyBvcHBvc2VkIHRvIGJyX21kYl9yZXBsYXkgYW5kIGJyX3ZsYW5fcmVwbGF5IHdoaWNoIG1p
Z2h0IGJlIHR1cm5lZCBvZmYNCj4gPj4gZGVwZW5kaW5nIG9uIGJyaWRnZSBzdXBwb3J0IGZvciBt
dWx0aWNhc3QgYW5kIFZMQU5zLCBGREIgc3VwcG9ydCBpcw0KPiA+PiBhbHdheXMgb24uIFNvIG1v
dmluZyBicl9tZGJfcmVwbGF5IGFuZCBicl92bGFuX3JlcGxheSBpbnNpZGUNCj4gPj4gYnJfc3dp
dGNoZGV2LmMgd291bGQgbWVhbiBhZGRpbmcgc29tZSAjaWZkZWYncyBpbiBicl9zd2l0Y2hkZXYu
Yywgc28gd2UNCj4gPj4ga2VlcCB0aG9zZSB3aGVyZSB0aGV5IGFyZS4NCj4gPiANCj4gPiBUQkgs
IGZvciBjb25zaXN0ZW5jeSB3aXRoIGJyX21kYl9yZXBsYXkoKSBhbmQgYnJfdmxhbl9yZXBsYXko
KSwgaXQgd291bGQNCj4gPiBoYXZlIGJlZW4gZ29vZCB0byBrZWVwIGl0IHdoZXJlIGl0IGlzLCBi
dXQgLi4uDQo+ID4gDQo+ID4+DQo+ID4+IFRoZSByZWFzb24gZm9yIHRoZSBtb3ZlbWVudCBpcyB0
aGF0IGluIGZ1dHVyZSBjaGFuZ2VzIHRoZXJlIHdpbGwgYmUgc29tZQ0KPiA+PiBjb2RlIHJldXNl
IGJldHdlZW4gYnJfc3dpdGNoZGV2X2ZkYl9ub3RpZnkgYW5kIGJyX2ZkYl9yZXBsYXkuDQo+ID4g
DQo+ID4gdGhpcyBzZWVtcyBsaWtlIGEgZ29vZCByZWFzb24sIHNvOg0KPiA+IA0KPiA+IFJldmll
d2VkLWJ5OiBJZG8gU2NoaW1tZWwgPGlkb3NjaEBudmlkaWEuY29tPg0KPiA+IA0KPiA+IE5paywg
V0RZVD8NCj4gPiANCj4gDQo+IEdvb2QgcG9pbnQsIGl0J2QgYmUgbmljZSB0byBoYXZlIHRoZW0g
YWxsIGluIG9uZSBwbGFjZSwgc2luY2UgdGhleSBhbGwgZGVhbA0KPiBzcGVjaWZpY2FsbHkgd2l0
aCBzd2l0Y2hkZXYgd2UgY2FuIG1vdmUgdGhlbSB0byBicl9zd2l0Y2hkZXYuYy4gV2UgY2FuIGFs
c28NCj4gcmVuYW1lIHRoZW0gc2ltaWxhciB0byBvdGhlciBmdW5jdGlvbnMgaW4gYnJfc3dpdGNo
ZGV2LCBlLmcuIGJyX3N3aXRjaGRldl9mZGJfcmVwbGF5DQoNCkxvb2tzIGxpa2Ugd2UgY2FtIG1v
dmUgYSBzdXJwcmlzaW5nbHkgbGFyZ2UgYW1vdW50IG9mIGNvZGUgZnJvbSBicl9tZGIuYw0KdG8g
YnJfc3dpdGNoZGV2LmMuIFRoZSBvbmx5IHByb2JsZW0gaXM6DQoNCiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHRoaXMgdXNlZCB0byBiZSBjYWxsZWQgYnJfbWRiX2Nv
bXBsZXRlDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB8DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB2DQpuZXQvYnJpZGdlL2JyX3N3aXRjaGRldi5jOiBJbiBmdW5jdGlvbiDigJhi
cl9zd2l0Y2hkZXZfbWRiX2NvbXBsZXRl4oCZOg0KbmV0L2JyaWRnZS9icl9zd2l0Y2hkZXYuYzo0
Mzc6MjA6IGVycm9yOiDigJhzdHJ1Y3QgbmV0X2JyaWRnZeKAmSBoYXMgbm8gbWVtYmVyIG5hbWVk
IOKAmG11bHRpY2FzdF9sb2Nr4oCZOyBkaWQgeW91IG1lYW4g4oCYbXVsdGljYXN0X2N0eOKAmT8N
CiAgNDM3IHwgIHNwaW5fbG9ja19iaCgmYnItPm11bHRpY2FzdF9sb2NrKTsNCiAgICAgIHwgICAg
ICAgICAgICAgICAgICAgIF5+fn5+fn5+fn5+fn5+DQogICAgICB8ICAgICAgICAgICAgICAgICAg
ICBtdWx0aWNhc3RfY3R4DQoNCldvdWxkIHlvdSBsaWtlIG1lIHRvIGludHJvZHVjZSBhIHNldCBv
ZiBicl9tdWx0aWNhc3RfbG9jaygpIGFuZA0KYnJfbXVsdGljYXN0X3VubG9jaygpIGhlbHBlcnMg
dGhhdCBoYXZlIHNoaW0gZGVmaW5pdGlvbnMgc28gdGhhdCB0aGV5DQp3b3JrIHdoZW4gQ09ORklH
X0JSSURHRV9JR01QX1NOT09QSU5HIGlzIGRpc2FibGVkPw0KDQpBbnl3YXksIEknZCBsaWtlIHRv
IGRvIHRoaXMgc2Vjb25kIHBhcnQgb2YgcmVmYWN0b3JpbmcgaW4gYSBzZWNvbmQgcGF0Y2gNCnNl
cmllcywgaWYgeW91IGRvbid0IG1pbmQu
