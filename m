Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10A63FBF83
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 01:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238914AbhH3Xny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 19:43:54 -0400
Received: from mail-eopbgr30110.outbound.protection.outlook.com ([40.107.3.110]:32026
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231601AbhH3Xnx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 19:43:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FvGZ8SmBwYWMclitOkHZ5qmHd+LH+/eYYWhuDKLfMZ7oCRix5E53hS2gzUrCqhg2f03YEhGOy+NV17ry+LAFQ2gNEB2g/de4TwtYuEenysmd1KyZti1bnTG7q4m2zLp9IZoZQJsThVPN1m/yrfrOavpRe8VCcVibfoKMm2paoi6kH/W+HPMlNruhYj9Ykzq8dKT9p0ivOfJFf2acmRYxKI164JHhOmFYCByoKY/DJVrNiExpwabFNs/xdZIo48J6dRW2Lbqe0W0w81nePcqgSuwAvviYt1I1Nx679PXfw9nmsYIZCRuNVLvOdGIG/CRRIyW3G7NHL7EKK3gGOMf1jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQCs5HEq9IisHohsP9rMaZBiKxN6Ekc0EJEOLrczFT8=;
 b=Xv66bgyYAFJjdCRL82JtOCrKXxKlbTFQZYkIzs4KAr5EGvELP3OpufGI+ObdDrRXVuiydWqRrEOnWP67F3aoSdUe933CAQoxOqtiaj7LXRADaMnJ806LaNDr8V5gGa/CoFXfbh3YIe6O3GJ3R2pfdsH725z4BpLnWZCoERfCNG9ns6yNvsUsXtanYjzdKeNm1prQgUmIEKjWfoec8H1af7hmgDxkSeCvyzN0pH1Pmc0WBi/QM444MnLaBlfqnopFqJCH9A5xMoM6UL/0Pev2s3Brg3UP36vO7Kj+/FUTP0ucvZvRB82jtcSRzEzn/VwQ0JdFDp/uBv5HIlx8jS/ztA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQCs5HEq9IisHohsP9rMaZBiKxN6Ekc0EJEOLrczFT8=;
 b=egv1BdaqS3pvKPNaqn5KTr7yc+2tECMHp/Ok3Uf2XfD9LmxxE7Q8p8FrpuZ4CjqKSUjDMjcauSRhtyJxKYPyszVvfsn44KjbfoAyMB6xtAz/HO7VvevfGNWrkhx+gMbZL7ga5z2laVT2kiB6Y/c/kQxISjg/e3uGH46yD1neC8E=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0302MB2777.eurprd03.prod.outlook.com (2603:10a6:3:eb::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4457.24; Mon, 30 Aug 2021 23:42:55 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167%6]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 23:42:55 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 4/5 v2] net: dsa: rtl8366rb: Support flood
 control
Thread-Topic: [PATCH net-next 4/5 v2] net: dsa: rtl8366rb: Support flood
 control
Thread-Index: AQHXnelkqN+BwVACr0G0pffGeJ2ISauMpSqAgAAQhYA=
Date:   Mon, 30 Aug 2021 23:42:55 +0000
Message-ID: <06adb47b-45a7-175d-759b-a2f22d208a27@bang-olufsen.dk>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-5-linus.walleij@linaro.org>
 <20210830224347.3ihtdgs56enz2ju3@skbuf>
In-Reply-To: <20210830224347.3ihtdgs56enz2ju3@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 796788e4-7f3c-46c5-5798-08d96c0fe421
x-ms-traffictypediagnostic: HE1PR0302MB2777:
x-microsoft-antispam-prvs: <HE1PR0302MB2777882C64AB6283772D372F83CB9@HE1PR0302MB2777.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:854;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CVxKRCl5UK0guMCqko9aoTVOLjgEBkQh6R+Cb0/0mdBVw4+9S5Lb8Smf69EAZ57nasqu8Yecr7KpTW4o9Tg2uX48A5nwp7hxkqlr6GhAlEAazoZ7WDTi4usxzXW6ITbmH2h/zXLhqS3wXHQ0bN8GJxj3QLfg0oknthqrWAbt3uKflt0cw2ewH2kb+G3uRkyJyEbi/SF0quWhQekOANmoSl06bR9HcZLOqqNg01XE/Qws/Np0/KJBQPt+9CjiUZlGTl4gCGGQeLNzgnnjLYN1I8QVm1zGpsDVqIOnuNjXu0SBZ+tj2EQd/SvFykI+itWMGMNhSkfbAb+mY5tM/BTUecK80eZ76RdUvsyo9ulhG2NiPHhfPAfX3iBqzj4DMQrM4i+eo+M9+/hF+6glUZ0xBOXC0Rw5rQDg990JRrYkimKqXnNArdgExGAKdQBmqdEAUc4mIu81RgAVHu5YaI8rkcQaRK42vH0LhAV2A5krpu7Guop/MWB/Q1fNENOoVCMaJnJu/SgGIFid/huK5TCGj6+RWL1MtM/XNL3wbK232zCeyPIk8Jh/5kSrut96cCx1kADU441dkYQVgJS7RjAynZW3+B64FmJ5hXMTTe5KDb+RE4lwiY/0BMvc8HaVwAylcfR66R3pNxx3PBfkTL0uWp0Slfh8KTh8lhZ5kWrgqMHpm9W1Tc5RLiuFkQrTNhSAuMhbBv3M61f+zMb90VuKqiiAmimdD6JRBsnTdE9CAEgcTxbNr6SR7VasJttPkEgNlm6AB6xi3QXVbCG1GlAaUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(26005)(5660300002)(86362001)(66446008)(316002)(31696002)(66574015)(54906003)(186003)(71200400001)(66476007)(66556008)(53546011)(110136005)(64756008)(76116006)(6506007)(508600001)(91956017)(4326008)(6512007)(2906002)(122000001)(38070700005)(83380400001)(8936002)(38100700002)(8676002)(7416002)(85202003)(8976002)(31686004)(6486002)(36756003)(2616005)(85182001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFA3RUFBaWNFOGxYMU1lUXFXMUYrWmI5b0xOUHBUc2M5bmxpTUJuMEN5K3pl?=
 =?utf-8?B?eTl4QmpKOFVnVTF5WEJWaktWbDBCdFI5RThhR0ZwTUtyR2dlL1NReEl4V1FX?=
 =?utf-8?B?OVo3ZElkbXJobzN5UDNRMHErVDhSUFQ1bENTN3ZGcmNTTS9KSjNhVkdWb1o5?=
 =?utf-8?B?OVNMVnVxVHJFMUhyZ1NsQzZxYzZuU2FWNU5kUHozenFnWHJycEdEMnAyMlho?=
 =?utf-8?B?Qmpwb0tMK1hUMkFBVGYvYWxpYjFBempmTXdxOVdqWmN2d1V5QWRJaXpaWmY5?=
 =?utf-8?B?RmFnc2o3aktHT2JFSm5iT3F1STYvSTFwaGZVV1JOSDgzSVhEWnJpekFpZXZn?=
 =?utf-8?B?Sit3azZmQ3J5MXlnWHc5RzNhK0lyTWZlWXJac0Y1YUVyc3dqWTZPaE9wSDUv?=
 =?utf-8?B?WWRvbUFEQWt0RHduUXdWY2RzYTUyUWMxVXd4VzF3eE1zYytxdUo2UGE5bzdM?=
 =?utf-8?B?ZWNaWWlyQUMzaEJRVUhNYWZBUEw4Q0lFSDZkRmg2QTUzVmR4QnRSOGdwem0r?=
 =?utf-8?B?c01JOVhJY0VUNzJrL0NCVklyb3FlQTRNRVB5d3dlY3JqMHdqTnRMTWE1eUxo?=
 =?utf-8?B?NXhEOUtCb21QMzhJaFE3anJxMDJnVkdBYnRyV09wTEJFYldPTXhuVmo5M0oy?=
 =?utf-8?B?c2hJOU1idTJxSjRoMWZTYTFDQUxwWk83ek5NWWdad0YvTDF4S0lYbVU4K3h2?=
 =?utf-8?B?YTVuZHQ1RlNqMDh3VUtVdEJsM0Z0ajBwWnhaRDZYTC85aGRiSTgrc1hDZVVB?=
 =?utf-8?B?TVlUSlJvWXkxd05aZ2l5YTN0cElhYmltZ2xXVDZGeVgzRC9GQUgzWHRlTzhl?=
 =?utf-8?B?ME0vMnBCeUtCRjdqVjdPdGhTdVN0RFJRdDNqdlh4ZlRlR3BJV2RMcldhQndz?=
 =?utf-8?B?K0VDak8wTHRONzZDV0JDYm9vdWRSSlgrUGFrcFl6L0tYcEZmaThsNysxSkhV?=
 =?utf-8?B?TlNFclcrS2F2SEI5L1g3YWhVZmxzZFdoNEU3S3gzbnNLQTQ0UnF3UEtFWHV1?=
 =?utf-8?B?RDdsb29MajE4c1ZocUM4VWlyV3dhY3oyNnNLSlJLdzBDWUsyZEx6RXdCSlJJ?=
 =?utf-8?B?a05zUGlxOGlZcnRCMEZhNmZVUXVKb2lleTRSd2FtQzYzSFdmV1gxVTd1WkYy?=
 =?utf-8?B?RCtqQ25YUUZaWm56TjROL2VWUzY4N3FJZno2T1pVYUNZai9TVHZLWGVUMEd2?=
 =?utf-8?B?TTd6Z2pHa3ljaVhIb3lHY05TSDhZdkFVTml4TFh1VVpsR3ZEVmZQTmRUeTBm?=
 =?utf-8?B?aGM5czY4ek1QaWhRS3c3RnVzUW5nYVB5VFpMeEFzcDBxclJ1VFR1SWNXem1Z?=
 =?utf-8?B?R1dmOEllcVVId1llemVLeWttQlEvZHZqUEhjOVZzZWp1L1Q5OVZuTGFMNEtl?=
 =?utf-8?B?WloxR3laU1lmK1FVdHRiSzRKekFwTy9QUExGd2puU0lSNjFuVVhxM1F2ZnMr?=
 =?utf-8?B?QmNxSWlHb2tyeHQ5cDh6MnV2VWs1OGZxWDJhWXgyNC9DQlJlZWd1RGR3NWFU?=
 =?utf-8?B?SDBleWRsTGlPWnZBL1BWNlJFNERPVW52UDI0N1RPUTFXbXBjUlJGVS9JcHo2?=
 =?utf-8?B?Smxmd0VvbWNsYnNXS3N3TFcrSjZCcEI3elFkVWZyK29SbWdnT2pQOTNHSEI2?=
 =?utf-8?B?TXkwVUp2SzVGaEczR0xHZ29zYnlPU3RvUGFxQ2N0S0FsNGY1QnJ0Y1Vzc1VH?=
 =?utf-8?B?TXpmU295Z0dzSUtJNGF4SE10dFU5bjhLanRyb3BHV3lnZlNVYXdVYjZCbFA0?=
 =?utf-8?Q?mIRtjaC5B1RuwBo68POqq+y3Zjz7IDoE1y6PqGL?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <65F2BC7ABF52F442A2B11B1B9B399EA7@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 796788e4-7f3c-46c5-5798-08d96c0fe421
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2021 23:42:55.6076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3KbaVj30nAn+gmCEl+HNCLf2rbHkeZUxugJJfVM1mbH4HgnJbeS/badM5YNWLuXgiYu/6z6GAH4mJnaklfglHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0302MB2777
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8zMS8yMSAxMjo0MyBBTSwgVmxhZGltaXIgT2x0ZWFuIHdyb3RlOg0KPiBPbiBNb24sIEF1
ZyAzMCwgMjAyMSBhdCAxMTo0ODo1OFBNICswMjAwLCBMaW51cyBXYWxsZWlqIHdyb3RlOg0KPj4g
Tm93IHRoYXQgd2UgaGF2ZSBpbXBsZW1lbnRlZCBicmlkZ2UgZmxhZyBoYW5kbGluZyB3ZSBjYW4g
ZWFzaWx5DQo+PiBzdXBwb3J0IGZsb29kIChzdG9ybSkgY29udHJvbCBhcyB3ZWxsIHNvIGxldCdz
IGRvIGl0Lg0KPj4NCj4+IENjOiBWbGFkaW1pciBPbHRlYW4gPG9sdGVhbnZAZ21haWwuY29tPg0K
Pj4gQ2M6IEFsdmluIMWgaXByYWdhIDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4NCj4+IENjOiBNYXVy
aSBTYW5kYmVyZyA8c2FuZGJlcmdAbWFpbGZlbmNlLmNvbT4NCj4+IENjOiBERU5HIFFpbmdmYW5n
IDxkcWZleHRAZ21haWwuY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogTGludXMgV2FsbGVpaiA8bGlu
dXMud2FsbGVpakBsaW5hcm8ub3JnPg0KPj4gLS0tDQo+PiBDaGFuZ2VMb2cgdjEtPnYyOg0KPj4g
LSBOZXcgcGF0Y2gNCj4+IC0tLQ0KPj4gICBkcml2ZXJzL25ldC9kc2EvcnRsODM2NnJiLmMgfCAz
OCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystDQo+PiAgIDEgZmlsZSBjaGFu
Z2VkLCAzNyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2RzYS9ydGw4MzY2cmIuYyBiL2RyaXZlcnMvbmV0L2RzYS9ydGw4MzY2cmIu
Yw0KPj4gaW5kZXggMmNhZGQzZTU3ZThiLi40Y2IwZTMzNmNlNmIgMTAwNjQ0DQo+PiAtLS0gYS9k
cml2ZXJzL25ldC9kc2EvcnRsODM2NnJiLmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9ydGw4
MzY2cmIuYw0KPj4gQEAgLTE0OSw2ICsxNDksMTEgQEANCj4+ICAgDQo+PiAgICNkZWZpbmUgUlRM
ODM2NlJCX1ZMQU5fSU5HUkVTU19DVFJMMl9SRUcJMHgwMzdmDQo+PiAgIA0KPj4gKyNkZWZpbmUg
UlRMODM2NlJCX1NUT1JNX0JDX0NUUkwJCQkweDAzZTANCj4+ICsjZGVmaW5lIFJUTDgzNjZSQl9T
VE9STV9NQ19DVFJMCQkJMHgwM2UxDQo+PiArI2RlZmluZSBSVEw4MzY2UkJfU1RPUk1fVU5EQV9D
VFJMCQkweDAzZTINCj4+ICsjZGVmaW5lIFJUTDgzNjZSQl9TVE9STV9VTk1DX0NUUkwJCTB4MDNl
Mw0KPj4gKw0KPj4gICAvKiBMRUQgY29udHJvbCByZWdpc3RlcnMgKi8NCj4+ICAgI2RlZmluZSBS
VEw4MzY2UkJfTEVEX0JMSU5LUkFURV9SRUcJCTB4MDQzMA0KPj4gICAjZGVmaW5lIFJUTDgzNjZS
Ql9MRURfQkxJTktSQVRFX01BU0sJCTB4MDAwNw0KPj4gQEAgLTExNTgsNyArMTE2Myw4IEBAIHJ0
bDgzNjZyYl9wb3J0X3ByZV9icmlkZ2VfZmxhZ3Moc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQg
cG9ydCwNCj4+ICAgCQkJCXN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4dGFjaykNCj4+ICAgew0K
Pj4gICAJLyogV2Ugc3VwcG9ydCBlbmFibGluZy9kaXNhYmxpbmcgbGVhcm5pbmcgKi8NCj4+IC0J
aWYgKGZsYWdzLm1hc2sgJiB+KEJSX0xFQVJOSU5HKSkNCj4+ICsJaWYgKGZsYWdzLm1hc2sgJiB+
KEJSX0xFQVJOSU5HIHwgQlJfQkNBU1RfRkxPT0QgfA0KPj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgIEJSX01DQVNUX0ZMT09EIHwgQlJfRkxPT0QpKQ0KPiANCj4gU3BhY2VzIGluc3RlYWQg
b2YgdGFicyBoZXJlPw0KPiANCj4+ICAgCQlyZXR1cm4gLUVJTlZBTDsNCj4+ICAgDQo+PiAgIAly
ZXR1cm4gMDsNCj4+IEBAIC0xMTgwLDYgKzExODYsMzYgQEAgcnRsODM2NnJiX3BvcnRfYnJpZGdl
X2ZsYWdzKHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQsDQo+PiAgIAkJCXJldHVybiBy
ZXQ7DQo+PiAgIAl9DQo+PiAgIA0KPj4gKwlpZiAoZmxhZ3MubWFzayAmIEJSX0JDQVNUX0ZMT09E
KSB7DQo+PiArCQlyZXQgPSByZWdtYXBfdXBkYXRlX2JpdHMoc21pLT5tYXAsIFJUTDgzNjZSQl9T
VE9STV9CQ19DVFJMLA0KPj4gKwkJCQkJIEJJVChwb3J0KSwNCj4+ICsJCQkJCSAoZmxhZ3MudmFs
ICYgQlJfQkNBU1RfRkxPT0QpID8gQklUKHBvcnQpIDogMCk7DQo+PiArCQlpZiAocmV0KQ0KPj4g
KwkJCXJldHVybiByZXQ7DQo+PiArCX0NCj4+ICsNCj4+ICsJaWYgKGZsYWdzLm1hc2sgJiBCUl9N
Q0FTVF9GTE9PRCkgew0KPj4gKwkJcmV0ID0gcmVnbWFwX3VwZGF0ZV9iaXRzKHNtaS0+bWFwLCBS
VEw4MzY2UkJfU1RPUk1fTUNfQ1RSTCwNCj4+ICsJCQkJCSBCSVQocG9ydCksDQo+PiArCQkJCQkg
KGZsYWdzLnZhbCAmIEJSX01DQVNUX0ZMT09EKSA/IEJJVChwb3J0KSA6IDApOw0KPj4gKwkJaWYg
KHJldCkNCj4+ICsJCQlyZXR1cm4gcmV0Ow0KPj4gKwl9DQo+PiArDQo+PiArCS8qIEVuYWJsZS9k
aXNhYmxlIGJvdGggdHlwZXMgb2YgdW5pY2FzdCBmbG9vZHMgKi8NCj4+ICsJaWYgKGZsYWdzLm1h
c2sgJiBCUl9GTE9PRCkgew0KPj4gKwkJcmV0ID0gcmVnbWFwX3VwZGF0ZV9iaXRzKHNtaS0+bWFw
LCBSVEw4MzY2UkJfU1RPUk1fVU5EQV9DVFJMLA0KPj4gKwkJCQkJIEJJVChwb3J0KSwNCj4+ICsJ
CQkJCSAoZmxhZ3MudmFsICYgQlJfRkxPT0QpID8gQklUKHBvcnQpIDogMCk7DQo+PiArCQlpZiAo
cmV0KQ0KPj4gKwkJCXJldHVybiByZXQ7DQo+PiArCQlyZXQgPSByZWdtYXBfdXBkYXRlX2JpdHMo
c21pLT5tYXAsIFJUTDgzNjZSQl9TVE9STV9VTk1DX0NUUkwsDQo+PiArCQkJCQkgQklUKHBvcnQp
LA0KPj4gKwkJCQkJIChmbGFncy52YWwgJiBCUl9GTE9PRCkgPyBCSVQocG9ydCkgOiAwKTsNCj4+
ICsJCWlmIChyZXQpDQo+PiArCQkJcmV0dXJuIHJldDsNCj4gDQo+IFVOREEgYW5kIFVOTUM/DQoN
CkFoLCBJIHdhcyBhbHNvIGZvb2xlZCBieSB0aGlzLiBVTiBpcyBub3QgdW5pY2FzdC4gSXQgbWVh
bnMgInVua25vd24gDQpkZXN0aW5hdGlvbiBhZGRyZXNzIiBhbmQgInVua25vd24gbXVsdGljYXN0
IGFkZHJlc3MiLg0KDQpTbywgVU5NQyBzaG91bGQgZ28gdW5kZXIgQlJfTUNBU1RfRkxPT0Q/DQoN
Cj4gDQo+PiArCX0NCj4+ICsNCj4+ICAgCXJldHVybiAwOw0KPj4gICB9DQo+PiAgIA0KPj4gLS0g
DQo+PiAyLjMxLjENCj4+DQo+IA0K
