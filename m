Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261543EFCC2
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238169AbhHRGad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:30:33 -0400
Received: from mail-eopbgr1410120.outbound.protection.outlook.com ([40.107.141.120]:48836
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237998AbhHRGac (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 02:30:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nK6wFpVCCaAmHyyyLG3HSCuSwg0yX6oQdc0xfLfAsPIST92U4d8LohH+yygTSTA5zJ/3ijO3HkVYnF4sZLPWNcyGAen48GxTOlmmu3a45mzD81a/7slP/MBP/TJ+pMLnFbNQdTNdyKuxmeLVVxhNiU5SJOGvnZA8f0l89MX+kCItKqqp3lwiNEJvfFY0vAwXU1NYm5VrRVU5XNuOL2NKJ+ODrBez0Ka4ClnMcSvFk429B90EPOZycjTNVINLZ9LeOfod3tBcqj2E/jD8tiAWWhwOGxu0Mltvc06DHGLegQil3zqz7PqK6vxaffkkbpWqlGX8Q/CzLuVbuJlAaGJXrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0eozmQIfpEqKbEO/oZUEcGR8A1sZqRGVlxHYseQu2kM=;
 b=QLXLgn7k1rBohPjgr+zAuogeIqWWEh0GjSX44InQCL5TvdHfqWNfW9I3IGZpcN9j3LicTvSGQEjiAD2Zu3ZOUOwYp0I9cKbLGZcrzRIm1HZEkZZ/YSEQMq0Uo3vnnZpCKB3AZDTn7JOYwiktIhjKTkUcmaQNMJHMqdh3JOgh2IijSHZ75hMdEF1+xn9YsfSvavNlbuv1i4v6wSEtlvwPknuZxR0K1qT1XJ2CLyzt1o6i9sIlaF2P4QeN9igh5o9qMG/KKii3NNNUIeegYE9h+V+yI95JQuHrLpWbTBvOTIRnWaUFLOs7NUtZW8CqbFb/pgHbEk5MDMxC9bjHXPtALQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0eozmQIfpEqKbEO/oZUEcGR8A1sZqRGVlxHYseQu2kM=;
 b=aq5aOUDAbOUwAjWSOmPAD0TeDpBSh1cs9xb2irxDxNavGz46ug9Xch1F1y2TTeob0A2FaRfSDeD1rVGnRAxihT1Nmv05umFEKGLoKWyc9gQbvmK52wS51y4XI0Z9nXw1vTv8wwmQqiCwn/X8hwvRaaxffvz27vBZkQJHr72yzD4=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSZPR01MB7068.jpnprd01.prod.outlook.com (2603:1096:604:11a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Wed, 18 Aug
 2021 06:29:55 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 06:29:55 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
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
Thread-Index: AQHXh4j0+2cGRDLtLUyHm25tLRdYvKtrHuUAgARm9NCAAArSgIAAA4CAgAgRGKCAAJOwAIAAqShA
Date:   Wed, 18 Aug 2021 06:29:54 +0000
Message-ID: <OS0PR01MB59225D98CEA7E2E0FD959B3186FF9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-2-biju.das.jz@bp.renesas.com>
 <CAMuHMdWuoLFDRbJZqpvT48q1zbH05tqerWMs50aFDa6pR+ecAg@mail.gmail.com>
 <OS0PR01MB5922BF48F95DD5576A79994F86F99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <CAMuHMdVCyMD6u2KxKb_c2LR8DGAY86F69=TSRDK0C5GPwrO7Eg@mail.gmail.com>
 <OS0PR01MB5922C336CBB008F9D7DA36B786F99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <OS0PR01MB5922A841D2C8E38D93A8E95086FE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <071f3fd9-7280-f518-3e38-6456632cc11e@omp.ru>
In-Reply-To: <071f3fd9-7280-f518-3e38-6456632cc11e@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 775faeab-f9e7-4dcb-79e1-08d9621197ff
x-ms-traffictypediagnostic: OSZPR01MB7068:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSZPR01MB7068D8DA0DD3CD9FEB7E386086FF9@OSZPR01MB7068.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uwpvufNh2ScQaHXlJTCkYxdVXcCpk9Pm0hq4kEFmngiLzI/Y1sIUOkKtVy3cMW/40xtQhltuSq1CvUtiBo6Z7H6hq4LFBF9V9/ajYwR9dX68ZuRblQUWOaTkWmLt+ssmYUuN7VmvsjlbbaZgX0f0Ow8qR9/DYRhR1lMot3vpceHTqOF63ZQK/L4rwvgCZeerLxF35QlLjU6tpxKyBuVSXul4llxLU06NrJYSe+fADOK00pipI5W7tAq9msRdU+iS+fCDLkkn6kcg6IGJq1z7wS3XYfrw1r6ha9O2JqpZj6Nd5ol3fZD0FrlTvLlWHTEDYu801c6gulfAVuJVtmPuiaaZxiw9cvuFuTJ1Vo8ulEO2GyGm0fX070MtuecqaFq+QrnydKooNgAFIsRQTA4bRO72bnKQ81dpaY17Rw/SycyBSTODhxSDgzJHi/peVaU/W3P1VMVO0kZBeYlHVpbDvcZ9jVCVXe4yR6uKWk5xHEEFNLp80GoIpQOHhj1pIQ9xQZQI1HqpgyNX+4A9zbFiP64jV3bd2mQtaYTNtjMi7LC55M25Ezp+1SCf4AfSPjymq7Mf00T2MxECIuf7kk4PsrfKAWvzkJI7Fx3PxsTS+UC8UGa1XgOO/DWQOZsF9MD4hKI9UVl7VT7yDef65p+hkneGUI14Yr8xEbld4P08QPVNBTc3oGrgBuVZWXBe53hdGwQ7O9UTpRsmi0kgKF7O7g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(39850400004)(396003)(376002)(38070700005)(71200400001)(110136005)(7696005)(54906003)(33656002)(107886003)(7416002)(38100700002)(186003)(53546011)(122000001)(478600001)(55016002)(5660300002)(6506007)(2906002)(52536014)(8936002)(86362001)(4326008)(316002)(66446008)(66476007)(66556008)(64756008)(8676002)(83380400001)(66946007)(76116006)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFlIdDB3c2h1UzFvVXNYV1dZcFdPRVJVQUozT1BRQ0piZXFZNU1lZHA0bUVW?=
 =?utf-8?B?dkdTZDhmTGt5Nk05ZHpvbWYwNDcyYUxMTmhmMVZJQnIzb0VpZHJoL21pcVp6?=
 =?utf-8?B?VmRFQmcxRnpOMTVzbmpQeUYwb0tQSHM3cWFHRmkxT1U3V2h2RzgzRjh4MWhS?=
 =?utf-8?B?UjRQV2RsaW41eG1YejdXTS9ueDJxVHdrREdRckl5Sjkxc053RkNjQjdjTWFC?=
 =?utf-8?B?YzU3alEvcWREN3dWb1Q1WUNCaVRvYVVPejZzZlR0ZFdFTUVSbEhvZUhHemIw?=
 =?utf-8?B?M1MrMmU2aGlGbGUwOENoMHVFVGJjK0x0VWppQXY1WTBDVmoxbHlxMFMwVXFt?=
 =?utf-8?B?UkhGUmFMenlHK3p0MnF6RUQwZ2NpU0tnNEdVai9ucEhncUFBNit6QUZ3OCtE?=
 =?utf-8?B?OTZqNWJ6TXZMS3A1WVFVRGhpdzdVa3hXYm4yREh6WmZnWEVhbVJJWGxaUDB2?=
 =?utf-8?B?MHhxS2xJem95dmZ4YjdxckJhN2g0Smo0d245VXlLRW5qU3JIVmoxSTJ3azZO?=
 =?utf-8?B?bzQ1UjlRSHhMNUl3TUNkdElOdzBra0I1OVZlR2lGcStjN0NTeW9zYkxYZDdi?=
 =?utf-8?B?Zys4d2ErcVR0c013WGtLVjdQQVFXMTVtM2kwK0tIbzJrUDNVYjBtdmhud2Uw?=
 =?utf-8?B?aTVIRDNHUDBSS0ZGMEVabm5OWEhFTzJobC93MWVqODhiNFY4aC9nU1FGSGU0?=
 =?utf-8?B?Rm5IcElnMk5VeHJwOFh2SXY2bkZPeFdCSGlMU1p1TmRLOUl5dGRxOTZDamYx?=
 =?utf-8?B?UEQzeG5WbDJOT0ZpN0N3QUd4RmRxVTBoRXFYVU1xVkdtOFBvOG5Gc0ZwQ0RC?=
 =?utf-8?B?ek95M1BGL0R3WkZick9ScEMvUnF5Wk1kUVBEbGdMdGdNR0NVV215cEJTVGVt?=
 =?utf-8?B?ZzgwK3kyTTFCNzltQmtEQTJRWUJuSnZ3RUp1VnZUYWg1UEhSQ1AxYTVqNnp5?=
 =?utf-8?B?azV1Rjd6UWhhb2hDL1Q0SmlkYm9vTlNHblRwRWI3ZFp2NElCVUVmUmx2MDcr?=
 =?utf-8?B?UXBQNTl6Mkw2bllwK2N1Zm9pZk1JZlpESDBmSWNmY1BKU21hTVdOR09QZWJ6?=
 =?utf-8?B?eFp0enVhM0pwS2xFd1lhbStBeGV6S3pRK29hUy9adDZZd2VSSlVIMmh1VUEv?=
 =?utf-8?B?a0FheWNYTjFOSW9BdzUwSHVlRlMrVXFXKzN5eXpmcm82OFYveUs3bmlpc0FZ?=
 =?utf-8?B?Z3dnRXkrVnNsN21sMHNpQ2o1TngwcUNxNW9nS1NROGdKUytZV3Y2UHBzbWhz?=
 =?utf-8?B?aXZGbE5xZjQyVStmTzNBTGQxTmtwSmJtV21pQTJGWEd5WE0zZ1Z2UHNxK3B3?=
 =?utf-8?B?SlVISi9QNGNPa2JZRnVZL0xOOWM3ZXFXeWxvcEZGNzNZbFJYbTNqYytjNU5S?=
 =?utf-8?B?d2p4NnptdERLTXJtV091MTRSRVNIYmIwdXhFdjQ5Z1N5NWVXWnZuUGdTNm9K?=
 =?utf-8?B?WmpPK1FheUxYaXErVUVoeUNJbG16K0NPZ3ZRbDl4dEUvYTArVCtQcElLdXlH?=
 =?utf-8?B?V3hvc3lyQ2dMcDh4YjF5ZlU4L1FkSFFuOEJSRGRMT2p6Q0ZaYXQwMXZLYldZ?=
 =?utf-8?B?N2t1elhxRGM2VVZ3RStnQVdUdFpMeUM5UG1YZy9EYldLaWNsd05XaUQ5enly?=
 =?utf-8?B?SmpkZXN3NzVVT1FMdEVEK2ZiQjhVSndrVnpWSEZ5aTBLNFIwZk9IOU15bGN4?=
 =?utf-8?B?MitSTE84QUhnZWRkSnROY3ZxcDZVNFZGTnJVa2hQWEdyTVNya1VWRjA5NkJV?=
 =?utf-8?Q?Oex/25+xDQInafsxxiDV2FPfiwMbsQhnAnGqSmO?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 775faeab-f9e7-4dcb-79e1-08d9621197ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2021 06:29:55.0881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: voJ9RfhTe2ryBc8sddytE50jJiGX5+yItQ+gmgUuBnd3Yu9dA843GUaeX8Nv/Emdx0nDAOM8vdAWUa+D9APkaFY0S1+7a87CcgaKizTzFdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB7068
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IHYyIDEvOF0gcmF2YjogQWRkIHN0cnVjdCByYXZiX2h3X2luZm8gdG8N
Cj4gZHJpdmVyIGRhdGENCj4gDQo+IE9uIDgvMTcvMjEgMjoyNCBQTSwgQmlqdSBEYXMgd3JvdGU6
DQo+IA0KPiBbLi4uXQ0KPiA+Pj4+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+Pj4+
PiBPbiBNb24sIEF1ZyAyLCAyMDIxIGF0IDEyOjI3IFBNIEJpanUgRGFzDQo+ID4+Pj4+IDxiaWp1
LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPj4+Pj4gd3JvdGU6DQo+ID4+Pj4+PiBUaGUgRE1B
QyBhbmQgRU1BQyBibG9ja3Mgb2YgR2lnYWJpdCBFdGhlcm5ldCBJUCBmb3VuZCBvbiBSWi9HMkwN
Cj4gPj4+Pj4+IFNvQyBhcmUgc2ltaWxhciB0byB0aGUgUi1DYXIgRXRoZXJuZXQgQVZCIElQLiBX
aXRoIGEgZmV3IGNoYW5nZXMNCj4gPj4+Pj4+IGluIHRoZSBkcml2ZXIgd2UgY2FuIHN1cHBvcnQg
Ym90aCBJUHMuDQo+ID4+Pj4+Pg0KPiA+Pj4+Pj4gQ3VycmVudGx5IGEgcnVudGltZSBkZWNpc2lv
biBiYXNlZCBvbiB0aGUgY2hpcCB0eXBlIGlzIHVzZWQgdG8NCj4gPj4+Pj4+IGRpc3Rpbmd1aXNo
IHRoZSBIVyBkaWZmZXJlbmNlcyBiZXR3ZWVuIHRoZSBTb0MgZmFtaWxpZXMuDQo+ID4+Pj4+Pg0K
PiA+Pj4+Pj4gVGhlIG51bWJlciBvZiBUWCBkZXNjcmlwdG9ycyBmb3IgUi1DYXIgR2VuMyBpcyAx
IHdoZXJlYXMgb24gUi1DYXINCj4gPj4+Pj4+IEdlbjIgYW5kIFJaL0cyTCBpdCBpcyAyLiBGb3Ig
Y2FzZXMgbGlrZSB0aGlzIGl0IGlzIGJldHRlciB0bw0KPiA+Pj4+Pj4gc2VsZWN0IHRoZSBudW1i
ZXIgb2YgVFggZGVzY3JpcHRvcnMgYnkgdXNpbmcgYSBzdHJ1Y3R1cmUgd2l0aCBhDQo+ID4+Pj4+
PiB2YWx1ZSwgcmF0aGVyIHRoYW4gYSBydW50aW1lIGRlY2lzaW9uIGJhc2VkIG9uIHRoZSBjaGlw
IHR5cGUuDQo+ID4+Pj4+Pg0KPiA+Pj4+Pj4gVGhpcyBwYXRjaCBhZGRzIHRoZSBudW1fdHhfZGVz
YyB2YXJpYWJsZSB0byBzdHJ1Y3QgcmF2Yl9od19pbmZvDQo+ID4+Pj4+PiBhbmQgYWxzbyByZXBs
YWNlcyB0aGUgZHJpdmVyIGRhdGEgY2hpcCB0eXBlIHdpdGggc3RydWN0DQo+ID4+Pj4+PiByYXZi
X2h3X2luZm8gYnkgbW92aW5nIGNoaXAgdHlwZSB0byBpdC4NCj4gPj4+Pj4+DQo+ID4+Pj4+PiBT
aWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4+
Pj4+PiBSZXZpZXdlZC1ieTogTGFkIFByYWJoYWthcg0KPiA+Pj4+Pj4gPHByYWJoYWthci5tYWhh
ZGV2LWxhZC5yakBicC5yZW5lc2FzLmNvbT4NCj4gPj4+Pj4NCj4gPj4+Pj4gVGhhbmtzIGZvciB5
b3VyIHBhdGNoIQ0KPiA+Pj4+Pg0KPiA+Pj4+Pj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVuZXNhcy9yYXZiLmgNCj4gPj4+Pj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcmF2Yi5oDQo+ID4+Pj4+PiBAQCAtOTg4LDYgKzk4OCwxMSBAQCBlbnVtIHJhdmJfY2hpcF9p
ZCB7DQo+ID4+Pj4+PiAgICAgICAgIFJDQVJfR0VOMywNCj4gPj4+Pj4+ICB9Ow0KPiA+Pj4+Pj4N
Cj4gPj4+Pj4+ICtzdHJ1Y3QgcmF2Yl9od19pbmZvIHsNCj4gPj4+Pj4+ICsgICAgICAgZW51bSBy
YXZiX2NoaXBfaWQgY2hpcF9pZDsNCj4gPj4+Pj4+ICsgICAgICAgaW50IG51bV90eF9kZXNjOw0K
PiA+Pj4+Pg0KPiA+Pj4+PiBXaHkgbm90ICJ1bnNpZ25lZCBpbnQiPyAuLi4NCj4gPj4+Pj4gVGhp
cyBjb21tZW50IGFwcGxpZXMgdG8gYSBmZXcgbW9yZSBzdWJzZXF1ZW50IHBhdGNoZXMuDQo+ID4+
Pj4NCj4gPj4+PiBUbyBhdm9pZCBzaWduZWQgYW5kIHVuc2lnbmVkIGNvbXBhcmlzb24gd2Fybmlu
Z3MuDQo+ID4+Pj4NCj4gPj4+Pj4NCj4gPj4+Pj4+ICt9Ow0KPiA+Pj4+Pj4gKw0KPiA+Pj4+Pj4g
IHN0cnVjdCByYXZiX3ByaXZhdGUgew0KPiA+Pj4+Pj4gICAgICAgICBzdHJ1Y3QgbmV0X2Rldmlj
ZSAqbmRldjsNCj4gPj4+Pj4+ICAgICAgICAgc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldjsg
QEAgLTEwNDAsNiArMTA0NSw4IEBADQo+ID4+Pj4+PiBzdHJ1Y3QgcmF2Yl9wcml2YXRlIHsNCj4g
Pj4+Pj4+ICAgICAgICAgdW5zaWduZWQgdHhjaWRtOjE7ICAgICAgICAgICAgICAvKiBUWCBDbG9j
ayBJbnRlcm5hbCBEZWxheQ0KPiA+Pj4gTW9kZQ0KPiA+Pj4+PiAqLw0KPiA+Pj4+Pj4gICAgICAg
ICB1bnNpZ25lZCByZ21paV9vdmVycmlkZToxOyAgICAgIC8qIERlcHJlY2F0ZWQgcmdtaWktKmlk
DQo+ID4+PiBiZWhhdmlvcg0KPiA+Pj4+PiAqLw0KPiA+Pj4+Pj4gICAgICAgICBpbnQgbnVtX3R4
X2Rlc2M7ICAgICAgICAgICAgICAgIC8qIFRYIGRlc2NyaXB0b3JzIHBlcg0KPiA+PiBwYWNrZXQN
Cj4gPj4+ICovDQo+ID4+Pj4+DQo+ID4+Pj4+IC4uLiBvaCwgaGVyZSdzIHRoZSBvcmlnaW5hbCBj
dWxwcml0Lg0KPiA+Pj4+DQo+ID4+Pj4gRXhhY3RseSwgdGhpcyB0aGUgcmVhc29uLg0KPiA+Pj4+
DQo+ID4+Pj4gRG8geW91IHdhbnQgbWUgdG8gY2hhbmdlIHRoaXMgaW50byB1bnNpZ25lZCBpbnQ/
IFBsZWFzZSBsZXQgbWUga25vdy4NCj4gPj4+DQo+ID4+PiBVcCB0byB5b3UgKG9yIHRoZSBtYWlu
dGFpbmVyPyA7LSkNCj4gPj4+DQo+ID4+PiBGb3IgbmV3IGZpZWxkcyAoaW4gdGhlIG90aGVyIHBh
dGNoZXMpLCBJIHdvdWxkIHVzZSB1bnNpZ25lZCBmb3IgYWxsDQo+ID4+PiB1bnNpZ25lZCB2YWx1
ZXMuICBTaWduZWQgdmFsdWVzIGhhdmUgbW9yZSBwaXRmYWxscyByZWxhdGVkIHRvDQo+ID4+PiB1
bmRlZmluZWQgYmVoYXZpb3IuDQo+ID4+DQo+ID4+IFNlcmdlaSwgV2hhdCBpcyB5b3VyIHRob3Vn
aHRzIGhlcmU/IFBsZWFzZSBsZXQgbWUga25vdy4NCj4gPg0KPiA+IEhlcmUgaXMgbXkgcGxhbi4N
Cj4gPg0KPiA+IEkgd2lsbCBzcGxpdCB0aGlzIHBhdGNoIGludG8gdHdvIGFzIEFuZHJldyBzdWdn
ZXN0ZWQgYW5kDQo+IA0KPiAgICBJZiB5b3UgbXJhbiBjaGFuZ2luZyB0aGUgcmF2Yl9wcml2YXRl
OjpudW1fdHhfZGVzYyB0byAqdW5zaWduZWQqLCBpdCdsbA0KPiBiZSBhIGdvb2QgY2xlYW51cC4g
V2hhdCdzIHdvdWxkIGJlIHRoZSAybmQgcGFydCB0aG8/DQoNCk9LIGluIHRoYXQgY2FzZSwgSSB3
aWxsIHNwbGl0IHRoaXMgcGF0Y2ggaW50byAzLg0KDQpGaXJzdCBwYXRjaCBmb3IgYWRkaW5nIHN0
cnVjdCByYXZiX2h3X2luZm8gdG8gZHJpdmVyIGRhdGEgYW5kIHJlcGxhY2UgDQpkcml2ZXIgZGF0
YSBjaGlwIHR5cGUgd2l0aCBzdHJ1Y3QgcmF2Yl9od19pbmZvDQoNClNlY29uZCBwYXRjaCBmb3Ig
Y2hhbmdpbmcgcmF2Yl9wcml2YXRlOjpudW1fdHhfZGVzYyBmcm9tIGludCB0byB1bnNpZ25lZCBp
bnQuDQoNClRoaXJkIHBhdGNoIGZvciBhZGRpbmcgYWxpZ25lZF90eCB0byBzdHJ1Y3QgcmF2Yl9o
d19pbmZvLg0KDQpSZWdhcmRzLA0KQmlqdQ0K
