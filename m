Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857C52C50D6
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 10:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389062AbgKZI6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 03:58:49 -0500
Received: from mail-eopbgr20117.outbound.protection.outlook.com ([40.107.2.117]:45019
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730093AbgKZI6t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 03:58:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ObkK74eep6I5jpP5K3uFRfY7X6LHR8FMMx71pI9O7uVOtGs6v6LKZeiLAJoC3rQgZan2gMU0rF8y8l17AcDfYnji9yK9SznJqKKry+TL29/m4sq8LQcUNA8AsM+OpxO6NQX0uFsVlkVlto4fuo3vRws3vTXpWmSsJr2AKzgmn3lhEK7U2sV/nsDBV19E+394pl02AbcmJgs4ma+7y2/AU0RerZCApybOstoe7wKEXtGpQ7dVoLXvAo90DSfQG+8olE9W/fniP4fd97I+BC7mIK2tCUMLxhqO7FLDiDEkQaIywg9+3mRg8GtxK0QRC3IoI45w9s1gzFHr0PfhCjK+1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFM6F945EzB5zD4yaDDYmjgn9ATs3g+tdRRLjJnConE=;
 b=SP5SEexo3NCA50o/EKANaFreLDazESTyKrdhQDoF0ISMC1p3eYctQzANZGhoIcRSaswnq0n19kK2Qd1Rdbj4RIyOmEAioGsYHkqFccKWWNDin2c0tePpGOTYbIYaRV8l1n9E6b72YqO7ncdLeo/VkdiQMJWxZg9Lwt/uDHVLazibuGSn1ETwHNkdUOH/5xpjizxGBd8kewW/sTH021g/ZcqWsKg0gUvYSrQfF3QS2RPKM1Hhl4zkONzELIK6TJpKghpzKeDUS9ZUOjxk5rHYLxXPMA3c4BKLe0oyqivC5gPA+bzgLE1ANboiHwUcRGhUDSoQcuG3i6gxKkbOjyKXSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=exaring.de; dmarc=pass action=none header.from=exaring.de;
 dkim=pass header.d=exaring.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Exaring.onmicrosoft.com; s=selector2-Exaring-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFM6F945EzB5zD4yaDDYmjgn9ATs3g+tdRRLjJnConE=;
 b=Qwkw0LMJzvb1zLY4i1s8H7TOCIBCiAZ6Wvpc6oGsCYsYD3ExM2tHxN/esdokyTBFvshRkrzJCsYJvNRDjVd5HCFEogKVQrEm8j6ABCfV/q8CryvhlYojCL3Ww3gyT2w2XSdp4mTbir8pxAcNLZhpSz4pvY0wqZYLaB33Fcu/J8E=
Received: from AM4P190MB0036.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:5e::19)
 by AM0P190MB0771.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:199::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.21; Thu, 26 Nov
 2020 08:58:45 +0000
Received: from AM4P190MB0036.EURP190.PROD.OUTLOOK.COM
 ([fe80::909e:4696:4a97:fec4]) by AM4P190MB0036.EURP190.PROD.OUTLOOK.COM
 ([fe80::909e:4696:4a97:fec4%9]) with mapi id 15.20.3589.032; Thu, 26 Nov 2020
 08:58:45 +0000
From:   Annika Wickert <annika.wickert@exaring.de>
To:     Sven Eckelmann <sven@narfation.org>,
        "b.a.t.m.a.n@lists.open-mesh.org" <b.a.t.m.a.n@lists.open-mesh.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>
Subject: Re: [RFC PATCH] batman-adv: Reserve needed_headroom for fragments
Thread-Topic: [RFC PATCH] batman-adv: Reserve needed_headroom for fragments
Thread-Index: AQHWwyX/JTPUwjaqYkCnrWlqcoT/1qnZi+sAgACIMwCAABsFgA==
Date:   Thu, 26 Nov 2020 08:58:45 +0000
Message-ID: <73D4D29E-C26E-471B-91CC-442B046F08AE@exaring.de>
References: <20201125122438.955972-1-sven@narfation.org>
 <16FAA2FE-92FA-421E-9134-27AECE426F55@exaring.de>
 <5658440.UjTJXf6HLC@sven-edge>
In-Reply-To: <5658440.UjTJXf6HLC@sven-edge>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: narfation.org; dkim=none (message not signed)
 header.d=none;narfation.org; dmarc=none action=none header.from=exaring.de;
x-originating-ip: [2003:dc:df03:4c01:41f7:edc5:a464:5b73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4fb4f395-f4cd-4e82-fe65-08d891e97b43
x-ms-traffictypediagnostic: AM0P190MB0771:
x-microsoft-antispam-prvs: <AM0P190MB07717A04A94715B91BFB116FE2F90@AM0P190MB0771.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MiYsWBMzUQRQAoKMzJN6UgayBfhiLX4kGHCr1WO1HzgC10asErIvFKATe4vDskCKKQPHJOdDyazfo3hO1VRnwizN6+7Jz+nnLcYjxV4ZznDNC6dazo/xIK/XIDwoWTGQp0GjCzz6PHVIoybB8jdQ3Nhc8AdqNyjxy1j5MyieOKWIcv+KQBWpaUkPJ+mq2QqoqD+x8aP/5/Wt/DJkE5JtzC0zeGjZvYZL+KgSXZV7fDUyFdxKngI+jbv9lYbGVWQAFWYeqNSaExzd5r/7kD/aEHWAsMvtXrDImj0thOtj3nEdkBoVLl/KA6hfzx9ZfwA4inXNCFrvsozlkw7fk6dOeZkfqAw+Z/+hokmWbcKwCZnahQXLwXHuMS20+dBc+1mB8F8OQxsQmk+gDYN8POiD6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4P190MB0036.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(136003)(39850400004)(366004)(376002)(346002)(6486002)(6506007)(64756008)(6512007)(66476007)(71200400001)(66556008)(66446008)(478600001)(66946007)(76116006)(36756003)(966005)(91956017)(8936002)(5660300002)(2616005)(83380400001)(186003)(44832011)(8676002)(33656002)(2906002)(86362001)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bHlxUDRhQjRIU1E5TFdiQzdXbWw2MXQ4UjI0VitCSHZDRWlpdWlZWFhrVTln?=
 =?utf-8?B?bGNiMXNyTVRFSXRRMW04MExrQU5Uekk1Wi9mYjFlOW1XL05jVC9lYVIybmVi?=
 =?utf-8?B?QUY2SjVwdVZNemRBOXd5R1ZNZ3hrRUl5MlRnK1lYNmIyWk9DVUIrMVFES00z?=
 =?utf-8?B?clAwN0ptWEFraW84NWJVZ2dYY1Y4RFYvYkNWYjRSMGZTNUN2bW1IeGFPOHFT?=
 =?utf-8?B?WUovaG85dFcvYjBsNlFadnJOek9OMGkxME84VE1lZndIdEdJelFrR2dnYmxP?=
 =?utf-8?B?elN0SURLV1Zlc2VYY3hITE82YThtTkxnczFvZHVkN1ZvaDJIcTRsMFR5dkdK?=
 =?utf-8?B?ZEc4SnVjaFVmblpjQWpBWittOHhwdUYyNjU0ajNNYkt2R0FGZFlFR1NGWTVW?=
 =?utf-8?B?cVNjRTdGT1Vwa0lycVNKVWJqWmxvTjg2LzJpcHdHSm9JNGJVTmlvb1YxYjhI?=
 =?utf-8?B?SXFNcE1idmVxeHJiWmpuRmsraGcya2FjVzAydWhMc1luMW9tdGJlQTd2ZHdI?=
 =?utf-8?B?REdsVldZSm92RUFIaEo5bXl0ZXVUalBIclpSdzZZbjd3d0QrZkxMS3VOc0tm?=
 =?utf-8?B?c0k0UVExR284WEpZdzduSjQ5bThGUVVQQ0Joa2kzSGExanFvRUpPZFpPREpv?=
 =?utf-8?B?NVNTaU5lWWxsZ0dNVFpPWTN4cGJoWFdIcEZuWTZIbEFnWmxBUExOY0IvOWlT?=
 =?utf-8?B?bG1qS2pyK1VWWnM1MW1MOThSZnpFSVNaR3BNQXlwOGVpczdBa0xMUFpYTzJI?=
 =?utf-8?B?bmtpdklNZFVBOVNia1IwY0lBTlFmSGl1RHhMZXNaaGNaQmVPMjFnK2hGbnV5?=
 =?utf-8?B?RXdhTmpGR2JleFBzS2NYbFZnQ2hMSjllNitPN2toTW14OElPTlM5ZmkzWmU5?=
 =?utf-8?B?SEdObml2cnhYbFpjVjhuNUNYMXhnUzZNeWJSNzFHSkRQd2ZkYVdxc3Urdm1D?=
 =?utf-8?B?bWc0Kzg1WndSQUtnWXVzYlp2N1RGbmtFbCt2UDZJWjlvM3FEdHI4K2NOWUtQ?=
 =?utf-8?B?N3ViRWM0WWF3SkdESkxLUGpGZS9IZVJnekRYMTB1Y2ZicDVYNEQ0aHcraExt?=
 =?utf-8?B?NnQ1SDdTZjQzSmtLVW1INmVXTVdPTUtON1VJak9HMWF6UkdOUTEvZmo4N2di?=
 =?utf-8?B?Tyt1MWl2RjlubEdRdVNmSUdKSHJDU2RZQUFvSWhXN0tPZkN0U0VaaTBHdFoy?=
 =?utf-8?B?N2VEQVhyZEsrYmYxTkNrVmlGV0krOTV5cFNzNUlNUzNHSUg2b3daYnV1MzAx?=
 =?utf-8?B?S1dxOWhaQTBaczIxWngwUjdnT3V3K3VvaDdoTElMZ1JUSklZMHk2SnNHRmV5?=
 =?utf-8?B?K3o5V2Zia0ZvOHgvNU84MjlqV3FoV055Y3pFK05uMW9QK0FlNG9RdU1ZKzZM?=
 =?utf-8?B?N0FMeFJyd1U1eEtodk9kREo0YXF2OW14QkVaa1RHeFhLc2p5S3pIVC9oS1ZV?=
 =?utf-8?Q?sY30hiDf?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <ECCDDA0856F4B44F9CC49815289ED32C@EURP190.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: exaring.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4P190MB0036.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fb4f395-f4cd-4e82-fe65-08d891e97b43
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2020 08:58:45.3136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 37f2d5fb-1abb-4498-b725-9a67ff628e81
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rf8In3aHQhc28t9aJ58e89EJK+Y31Nr/jjbaNueoNzf/dSuPLMtsNRkwewsPKkC/ExYn+gTuZPZy6R59YFKB+xIqMr+6Q4vvnc0P2mZo+Lk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0771
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCiAgICBIaSwNCg0KICAgPkkgZmluZCB5b3VyIG91dHB1dCBzbGlnaHRseSBjb25mdXNp
bmcuIE1heWJlIHlvdSBjYW4gY2hhbmdlIHlvdXIgcHJpbnRrIHN0dWZmIA0KICAgPiB0byBzb21l
dGhpbmcgbW9yZSBsaWtlOg0KDQogICA+cHJpbnRrKCIlcyAlczoldSBtYXhfaGVhZHJvb20gJXVc
biIsIF9fRklMRV9fLCBfX2Z1bmNfXywgX19MSU5FX18sIG1heF9oZWFkcm9vbSk7DQoNCldpbGwg
YWRkIHRoaXMgdGh4Lg0KDQogICAgPk9uIFRodXJzZGF5LCAyNiBOb3ZlbWJlciAyMDIwIDAwOjE0
OjM1IENFVCBBbm5pa2EgV2lja2VydCB3cm90ZToNCiAgICA+PiBUaGlzIGlzIHdoYXQgSSBnZXQg
ZnJvbSB0aGUgYnJpZGdlIHdoZW4gYmF0MCBpcyBlbnNsYXZlZCB3aXRoIHRoZSB2eGxhbiBpbnRl
cmZhY2UgYXMgbWVtYmVyIG9mIGJhdG1hbiAoIGh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xp
bnV4L2xhdGVzdC9zb3VyY2UvbmV0L2JyaWRnZS9icl9pZi5jI0wzMTEgKQ0KICAgID4+IFsgICAz
Ni45NTk1NDddIEJyaWRnZSBmaXJld2FsbGluZyByZWdpc3RlcmVkDQogICAgPj4gWyAgNTIyLjIy
MTc2N10gU0tCIEJyaWRnZSBicl9pZi5jOiBtYXhfaGVhZHJvb20gMA0KICAgID4+IFsgIDUyMi4y
MjE3ODFdIFNLQiBCcmlkZ2UgYnJfaWYuYzogbmV3X2hyIDANCiAgICA+PiBbICA2MjcuMTg2MTI5
XSBTS0IgQnJpZGdlIGJyX2lmLmM6IG1heF9oZWFkcm9vbSAwDQogICAgPj4gWyAgNjI3LjE4NjEz
OV0gU0tCIEJyaWRnZSBicl9pZi5jOiBuZXdfaHIgMA0KICAgID4+IFsgIDYyNy42MTY2NTBdIFNL
QiBCcmlkZ2UgYnJfaWYuYzogbmV3X2hyIDEwMg0KDQogICAgPldoZW4gaXMgdGhpcyBzaG93bj8g
RG9lcyB0aGUgYmF0YWR2IGludGVyZmFjZSBhbHJlYWR5IGhhdmUgaXRzIGhhcmRpZiAoc2xhdmUp
IA0KICAgID5pbnRlcmZhY2VzIGF0dGFjaGVkIGF0IHRoYXQgcG9pbnQ/IEFuZCBkaWQgdGhlIHZ4
bGFuIHJlcG9ydCB0aGUgY29ycmVjdCANCiAgICA+bmVlZGVkX2hlYWRyb29tIHRvIGJhdGFkdiBi
ZWZvcmUgeW91J3ZlIHRyaWVkIHRvIGF0dGFjaCB0aGUgYmF0YWR2IGludGVyZmFjZSANCiAgICA+
dG8gdGhlIGJyaWRnZT8NCg0KQkFUTUFOIGFscmVhZHkgaGFzIHRoZSB2eGxhbiBpbnRlcmZhY2Ug
YXMgaGFyZGlmIGhlcmUgaXMgdGhlIHNjcmlwdCBJIHVzZSB0byBnZW5lcmF0ZSB0aGUgY29uZmln
Og0KDQppcCBsaW5rIGFkZCBtZXNoLXZwbiB0eXBlIHZ4bGFuIGlkIDQ4MzE1ODMgbG9jYWwgZmU4
MDo6MmUwOjJmZmY6ZmUxODpkYzJmIHJlbW90ZSBmZTgwOjoyODE6OGVmZjpmZWYwOjczYWEgIGRz
dHBvcnQgODQ3MiBkZXYgd2ctdXBsaW5rDQppcCBsaW5rIGRlbCBiYXQtd2VsdCANCnJtbW9kIGJh
dG1hbi1hZHYNCm1vZHByb2JlIGJhdG1hbi1hZHYNCiBiYXRjdGwgcmEgQkFUTUFOX1YNCiBiYXRj
dGwgbWVzaGlmIGJhdC13ZWx0IGludGVyZmFjZSBhZGQgbWVzaC12cG4NCiBpcCBsaW5rIHNldCB1
cCBiYXQtd2VsdA0KIGlwIGxpbmsgc2V0IGRldiBiYXQtd2VsdCBtYXN0ZXIgYnItd2VsdA0KDQog
ICA+IEJlY2F1c2UgdGhlIGJyaWRnZSBjYW4gYWxzbyBvbmx5IGNoYW5nZSBpdHMgbmVlZGVkX2hl
YWRyb29tIG9uIGludGVyZmFjZSBhZGQgDQogICA+b3IgZGVsZXRlLg0KDQogICAgPj4gQWxzbyBC
QVRNQU4gcmVwb3J0cyBpdHNlbGYgd2hlbiBpbml0aWFsaXplZCBhbmQgc2VlbXMgbm90IHRvIHBy
b3BhZ2F0ZSBzdHVmZiB1cCB0aGUgc3RhY2sgb24gY2hhbmdlPzogKGh0dHBzOi8vZ2l0aHViLmNv
bS9vcGVuLW1lc2gtbWlycm9yL2JhdG1hbi1hZHYvYmxvYi9tYXN0ZXIvbmV0L2JhdG1hbi1hZHYv
aGFyZC1pbnRlcmZhY2UuYyNMNTU1ICApDQogICAgPj4gWyAzMzUwLjIxMjExNl0gU0tCIGhhcmQt
aW50ZXJmYWNlLmg6IGxvd2VyX2hlYWRyb29tIDcwDQogICAgPj4gWyAzMzUwLjIxMjEyNl0gU0tC
IGhhcmQtaW50ZXJmYWNlLmg6IG5lZWRlZF9oZWFkcm9vbSAxMDINCg0KICAgID5BZmFpaywgaXQg
aXMgInByb3BhZ2F0aW5nIiBpdHMgc3R1ZmYgYnkgYWRqdXN0aW5nIGl0cyBvd24gbmVlZGVkX2hl
YWRyb29tLw0KICAgID50YWlscm9vbSBhdCB0aGlzIHBvaW50LiBCdXQgdGhlcmUgaXMgbm8gd2F5
IHRvIG5vdGlmeSB0aGF0IHRoZSBoZWFkcm9vbS8NCiAgICA+dGFpbHJvb20gd2FzIGNoYW5nZWQg
YW5kIHRoZSB1cHBlciBsYXllcnMgc2hvdWxkIHJlY2FsY3VsYXRlIGl0Lg0KDQpXaGljaCBzaG91
bGQgYWxyZWFkeSBpbmNsdWRlIHRoZSBoZWFkcm9vbSBuZWVkZWQgYnkgdnhsYW4gYXMgaXQncyBh
bHJlYWR5IHByZXNlbnQgYXMgaGFyZGlmLiANCg0KICAgID5JZiB5b3UgbmVlZCBzb21ldGhpbmcg
bGlrZSB0aGlzIHRoZW4gd2UgbWlnaHQgdG8gaGF2ZSBhIG5ldyANCiAgICA+TkVUREVWX1JFU0VS
VkVEX1NQQUNFX0NIQU5HRSAob3IgYSBiZXR0ZXIgbmFtZSBPUiBtYXliZSB1c2UgYSBuZXRkZXZf
Y21kIHdpdGggDQogICAgPmEgc2ltaWxhciBtZWFuaW5nKS4gQW5kIHRoZW4gY2FsbCB0aGlzIHdo
ZW5ldmVyIHRoZSBuZWVkZWRfaGVhZHJvb20vDQogICAgPnRhaWxyb29tLy4uLiBvZiBhbiBpbnRl
cmZhY2UgY2hhbmdlcyBkdXJpbmcgaXRzIGxpZmV0aW1lLiBBbmQgYnJpZGdlL2JhdG1hbi0NCiAg
ICA+YWR2L292cy8uLi4gaGF2ZSB0byBjaGVjayB0aGUgaGVhZHJvb20gaW4gdGhlaXIgbm90aWZp
ZXJfY2FsbCBhZ2FpbiB3aGVuIHRoZXkgDQogICAgPnJlY2VpdmUgdGhpcyBldmVudC4NCg0KICAg
ID5Db3VsZCBpdCBiZSB0aGF0IHRoZSB2eGxhbiBkaWRuJ3QgaGFkIHRoZSBjb3JyZWN0IG5lZWRl
ZF9oZWFkcm9vbSB3aGVuIHlvdSd2ZSANCiAgICA+YWRkZWQgaXQgdG8geW91IGJhdGFkdiBpbnRl
cmZhY2U/IE9yIHRoYXQgdGhlIHZ4bGFuIGludGVyZmFjZSBkaWRuJ3Qgc2V0IHRoZSANCiAgICA+
Y29ycmVjdCBuZWVkZWRfaGVhZHJvb20gZm9yIGl0cyBsb3dlcl9kZXYgKHNlZSB2eGxhbl9jb25m
aWdfYXBwbHkpPw0KDQogIFRoZSB2eGxhbiBpbnRlcmZhY2Ugd2FzIGFkZGVkIGZpcnN0LiBTbyBp
dCBzaG91bGQgcHJvcGFnYXRlIGl0Pw0KDQogICAgPklmIHlvdSBoYXZlIHRoZSAic2xvdyIgc2V0
dXAsIGNhbiB5b3UgcGxlYXNlIGRvIGZvbGxvd2luZyBzdGVwczoNCg0KICAgID4qIGtlZXAgdnhs
YW4gYXMgaXMgKEkgaG9wZSB5b3Ugc3BlY2lmeSBhIGZpeGVkIGxvd2VyZGV2KQ0KDQogICAgPi0g
YnV0IHRyeSB0byBwcmludCB0aGUgbmVlZGVkIGhlYWRyb29tIGluIHZ4bGFuX2NvbmZpZ19hcHBs
eSBhbmQgY29tcGFyZSBpdCANCiAgICA+ICB0byB0aGUgb25lcyBmcm9tIHZ4bGFuX2J1aWxkX3Nr
Yg0KDQogICAgPiogcmVtb3ZlIHRoZSB2eGxhbiBmcm9tIHlvdXIgYmF0YWR2IGludGVyZmFjZQ0K
ICAgID4qIGFkZCB5b3VyIHZ4bGFuIGFnYWluIGZyb20gdGhlIGJhdGFkdiBpbnRlcmZhY2UNCg0K
ICAgID4gLSBjaGVjayBpZiB0aGUgaGVhZHJvb20gbnVtYmVycyBhcmUgbm93IGxvb2tpbmcgYmV0
dGVyIGluIA0KICAgID4gICAgYmF0YWR2X2hhcmRpZl9yZWNhbGNfZXh0cmFfc2ticm9vbQ0KDQog
ICAgPiAqIHJlbW92ZSBiYXRhZHYgaW50ZXJmYWNlIGZyb20gdGhlIGJyaWRnZQ0KICAgID4gKiBh
ZGQgeW91ciBiYXRhZHYgaW50ZXJmYWNlIGFnYWluIHRvIHRoZSBicmlkZ2UNCg0KICAgICA+IC0g
aXMgdXBkYXRlX2hlYWRyb29tKCkgbm93IHVzaW5nIHRoZSBjb3JyZWN0IGhlYWRyb29tIGluZm9y
bWF0aW9uPw0KDQoNCkFzIHRoZSBzZXR1cCBpcyBhbHdheXMgZG9pbmcgdGhlIHBza2JfZXhwYW5k
X2hlYWQoKSBpdCBzaG91bGQgYmUgcG9zc2libGUgdG8gdGVzdCB0aGlzLg0KDQpCZXN0IEFubmlr
YQ0KDQo=
