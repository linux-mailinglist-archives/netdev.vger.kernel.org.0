Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCC93FBF79
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 01:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238914AbhH3Xga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 19:36:30 -0400
Received: from mail-db8eur05on2092.outbound.protection.outlook.com ([40.107.20.92]:36321
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231601AbhH3Xg3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 19:36:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nluijS0Utb4m/KN+PwTKHud7uohodhWPj3VpRqFZtCLXWEEyV+Ro7BUVXZ17SAP69GF8rErbxFazmndVxAU3TjmKOySmAmeytev/6ibNk9X1GzA/3xwgPfpsUdwZK8fomYbHvocuQO86exOHS+YVQCu9btK+3Q9CZDumSm20LjTomnGyMF/wB5dIbz3F5MnGfjqvGtfSfEMnVncDblj1i5a4z3S+Sd8+rk4amqU6VF0Ehd+utr6OuIp0txg+bPQYzfv3Hsn4XSF+IhWtHxp5dRsa4kdNmBB6Bv6MAyt8akMOQcBbfCAJ/L//GARXktCuFq9cKcHRAsKdm23judVXgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hbatZHAlEHolF9chOToilROgLkTxw40IIEXlqYm4Los=;
 b=edM8Xs5FjjLvsLPffwuQ6TDmahJG3scbInFYFDQosRs9TpRV0LkPHjYRs9EqkgDAEKhTmkQF2Cvm/Dch/WpVw0QXX+NW9fD7VZc2RMItYPZJ0U+yZz7Poy7wAq+gm2zfm/JC4o0B/b4zqpABwTB55kj+R8CBF70q8F5iIDT6+Pc9AxhmPMe2rpxVdR4TIiW11ZLPW/9kKUnG1RTq+zcMszm13oYnx17RBPCWW6eJqmubFYKJ92gCMp8WG9oFIRgqhXnhy3VX/KcsaAJREExkhnTSM0e1njJuPS5o3mopKBYNDWTxpvGjWbHgMvJydsz8LafI4PUlW2AOF2Q3VSlPDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hbatZHAlEHolF9chOToilROgLkTxw40IIEXlqYm4Los=;
 b=PyIex0rtjGJwFGQ4Kj5Hxhtnx8zCeHtkbx1B0xPfI5r17R0clSVO82Nyk7z+dTLB9JYHoV1HY2mJocbP5PoIVA29tB+Rc8bNrZTjxWBtSl/f7VNf+zPbhwzfBq6AY84XqLezeHu0BX2d9cVKamUfy5zKbaeoC0eCfyLSWbPLH4c=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR03MB3162.eurprd03.prod.outlook.com (2603:10a6:7:55::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4457.24; Mon, 30 Aug 2021 23:35:31 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167%6]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 23:35:31 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 4/5 v2] net: dsa: rtl8366rb: Support flood
 control
Thread-Topic: [PATCH net-next 4/5 v2] net: dsa: rtl8366rb: Support flood
 control
Thread-Index: AQHXnelkqN+BwVACr0G0pffGeJ2ISauMs50A
Date:   Mon, 30 Aug 2021 23:35:31 +0000
Message-ID: <a9430bbd-7d84-e857-b98a-3662a23db012@bang-olufsen.dk>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-5-linus.walleij@linaro.org>
In-Reply-To: <20210830214859.403100-5-linus.walleij@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0689625-0c73-4031-51d9-08d96c0edb49
x-ms-traffictypediagnostic: HE1PR03MB3162:
x-microsoft-antispam-prvs: <HE1PR03MB31624B0F0C2503C9E255AC3A83CB9@HE1PR03MB3162.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tcU8+2PN9ZuOmd4W9fNTIcSDai4V3t1iuYLZcCnj1gfhW7Vv0Ed+ehV3OT9aosrPCO/lrCW5VZIyasvnk9Mi6g4iw4ysvE5FD+lj5e4cgTHlz5rp9DELExE+VQMes1tzPLFF2AjtvkvUdiThvfwz68Fdg1uCoR14xqNU22zQ1BSJ9y3Q60uTp/0AecuBGyGSDUtLy/tSK0A20+L1WAfO+A95YrBqCs35+1zQp1E4ZGBsMWTi7cqg7m7Rek/kosMS/vXyj6KUpOEihTUxYJ8fSOQAcl0rwCHAnEq2eQk8K74YU2Q45E0+ykyOJitQo9p3Tz6EqMpQcCfav3Z1gGwg+y6k1k6P+ztNMfPc0vToHHSzk2aYpf71r0syjshJivqiMgPhLVjot8Rg34F5DdCMP5aDOYHXya7iMhrw9C4UxpUpIV1meZlJGJeYMv0iX+hgmVbGlKXUjs4pEpDVB9tHq6+s2MeX7B3Dyaw3Bh3H1PTzPB2qRTG5ZMg06ENspNAz04m0U+bw45unatqzVl8fpXlCeLPSZr6U248asO8E8PhVLG6rdmQPFr38IBi/dfLo9gN/EcahU3suZCkfogg6kgHSsx/PmZQVuzjhwiNOdkWt7frIXWc09eq2HbNmIYHbSIldCnZp0E0Vr/vgMbjLmH5TRDIkD61thB5OgoKkzS9bmfJ/92/q3C+JK22uI7gRWvFDRWSj83k7++etv+nSOShZ4Xj+AoE6m3hBPffxYj8MMlXl0P3RGYz7bcQSO5rC4KA22NdDE4bKFO4bxEQO5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(31686004)(54906003)(31696002)(36756003)(66476007)(64756008)(38100700002)(26005)(5660300002)(85182001)(6506007)(110136005)(85202003)(53546011)(316002)(122000001)(508600001)(2616005)(38070700005)(66556008)(86362001)(66446008)(7416002)(76116006)(91956017)(66574015)(83380400001)(2906002)(8976002)(66946007)(8936002)(4326008)(8676002)(71200400001)(6512007)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1UvVVowZEt0ajBQZkRZZ25ucGZhaUxzcW9WUWU0UURDc1BHYXVNMDhtQThz?=
 =?utf-8?B?NHVuUlZNTU9ZeDBIK20zVjFydWIxUStYVmR4eXgzaXBPOTRFbk5VVld1WnZQ?=
 =?utf-8?B?ZjgzOGZFbmRqNXlLdExYMDlzV3pCbUdldXNSM2RjQ2g0WHJDdzc0MGFrZlFV?=
 =?utf-8?B?akpDTjF5WWpBTmNvckY5Z1huYWFDSDVmT0NNdUFKNnhXVGRraFZ4emRPZ0ZL?=
 =?utf-8?B?ZWpJUzZxcUNJdVB4WVhNUmZVVnZlbDFPd01IVC8vd2lRc1E0WjNjeXVlN1BY?=
 =?utf-8?B?YnM1SkFPRGtIejhEWFYrTERzZGhKNGM3Q21UOVorOE8rZVpoMEtYMURlbjhS?=
 =?utf-8?B?RXBVRjliZXdLZFdDWmlIYVM1cXZFeldaRjBSak84cGFnc1JROGhrMlRTSlVM?=
 =?utf-8?B?bi92UmlKTVNLbHlZRFBXQzVpaXdsZi9RSTMxYmwraENJSGJBQ0R6Q0ZkdkRF?=
 =?utf-8?B?Q3JKUU5td1VOSjNBcnAvV0lONUN2QkFhK1NVdnQ1SFc5UlVVbjNZa1RackNI?=
 =?utf-8?B?UUVkYnlyT2wwSkZYY2RMK2R4Z1IvbEJrdG1vTENOMVJJeEZ1ODViRVhNUWFV?=
 =?utf-8?B?cE05V0ZoQk5vd1cva01SeTU1L3RMYVprbUovWll1MEdCQTc1SW54RWloTFdm?=
 =?utf-8?B?NWtEbWcrZTZ4K3FrQUlrS0k2emNRMituUjg0Ymp6cU1ZbEtYa3d2WXFKYXFh?=
 =?utf-8?B?MnZjUktPVDg2Uy9aaEtKc0VuOXV0c2Q4eXVxSWlZamJzT3lNTFNkNURSaVBS?=
 =?utf-8?B?NEU0dmtXdmVHRXl4b2xJOXBJaXgyUTRmYmVNdHFrdnVwS0ZrRWVGbWxyTkcr?=
 =?utf-8?B?bTYxMFhNQUxCZVRkSUoyRDRJNHh1UVFjblA1ZysrN2dlYS9PR0gzVTN4aTRF?=
 =?utf-8?B?eUh4Mk8yUHdrRzNwQ2tHSWdWYW10TDVhNHlJMG95ZFp1UDZjVzh3VFF1b3kw?=
 =?utf-8?B?NlI4V09aNCtCREJEMm1xdUNvM2RlNGhmNjF1a0F4Kzdad1NsWjQ2eUVLVCta?=
 =?utf-8?B?VmpUZHZtckRkamUrRmpWYm9xR2FLU1FXdFVYQThSTlhlNjJ5K3cwY1lHMW1D?=
 =?utf-8?B?K09SdW9ITzhod05PRzY3WU5iRjNWaEtHU3JlYU1MNzZuV1JabzJpQXl1eFdD?=
 =?utf-8?B?aTZqQnhldWl0ZHlvSXRIMnFNV3FMdnh4V2EyVkhMM29HaG9ncnBZaDdvbXJT?=
 =?utf-8?B?Ym9RSWhCQ044MlNUNjFWV1YrRE95NzJoMnRrUmlEUWZLOUNKa1c2U3gxTG8v?=
 =?utf-8?B?UXNiMUgvMy9wcmo1WG54blBlVXo3bkUyeUdlWUFBc21qam1Za253STNlODY2?=
 =?utf-8?B?a2lTNXd4OElISEdJNUhwYzU5S215ajVMeDBRSTFxUVR1WVpmOW83bWJxWjV5?=
 =?utf-8?B?cFpiMnBsUEVWUzZ4YTcxY25hNHRNTmlXY3JVd0NySnQ1SW9FUkIyckNPUlll?=
 =?utf-8?B?dSthbkNzckIxRWdCYmtEeXBaSUc1dGtLenB2ZmREN3hGM1VFRjVHMTNwUlZI?=
 =?utf-8?B?NU5WajBMQTFBT0pDUFkvbzBWSWttZ2k1M3RGUndnMVAzVHI5bm9wVmdrVTcy?=
 =?utf-8?B?b3p6dWdsK1JDeHE3Ny9DZ29ua05yRmhVZzNDbGNPMHRKRlNiK3VkakpMNmk2?=
 =?utf-8?B?aW5RVmVFNERhcXp0M09BMENMeHJtaXA4T0F4c2pybk5veHJBaHUyWGd2WFBC?=
 =?utf-8?B?TjNpUjFrMkowRTdmRlR1cWppL0N0T3VKUEsxWi9lSlRZMjRQaWd2bXdvM3Vu?=
 =?utf-8?Q?P23yBhFnaqkXx28fTlTMFp4ZwFkghb4APq8eWFK?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A7F4EB98569244A8129EF34260B0EC3@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0689625-0c73-4031-51d9-08d96c0edb49
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2021 23:35:31.1934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F2l/jU91qiKz1mtsFekluUN27NJrIJIHvE3zCz4KSJ+JkNl7XZVXUwDCAAgrtvhv4PZMrDMxvdTkSRRWqFMXzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR03MB3162
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8zMC8yMSAxMTo0OCBQTSwgTGludXMgV2FsbGVpaiB3cm90ZToNCj4gTm93IHRoYXQgd2Ug
aGF2ZSBpbXBsZW1lbnRlZCBicmlkZ2UgZmxhZyBoYW5kbGluZyB3ZSBjYW4gZWFzaWx5DQo+IHN1
cHBvcnQgZmxvb2QgKHN0b3JtKSBjb250cm9sIGFzIHdlbGwgc28gbGV0J3MgZG8gaXQuDQo+IA0K
PiBDYzogVmxhZGltaXIgT2x0ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT4NCj4gQ2M6IEFsdmluIMWg
aXByYWdhIDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4NCj4gQ2M6IE1hdXJpIFNhbmRiZXJnIDxzYW5k
YmVyZ0BtYWlsZmVuY2UuY29tPg0KPiBDYzogREVORyBRaW5nZmFuZyA8ZHFmZXh0QGdtYWlsLmNv
bT4NCj4gU2lnbmVkLW9mZi1ieTogTGludXMgV2FsbGVpaiA8bGludXMud2FsbGVpakBsaW5hcm8u
b3JnPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IEFsdmluIMWgaXByYWdhIDxhbHNpQGJhbmctb2x1
ZnNlbi5kaz4NCg0KPiBDaGFuZ2VMb2cgdjEtPnYyOg0KPiAtIE5ldyBwYXRjaA0KPiAtLS0NCj4g
ICBkcml2ZXJzL25ldC9kc2EvcnRsODM2NnJiLmMgfCAzOCArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKystDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDM3IGluc2VydGlvbnMoKyksIDEg
ZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvcnRsODM2NnJi
LmMgYi9kcml2ZXJzL25ldC9kc2EvcnRsODM2NnJiLmMNCj4gaW5kZXggMmNhZGQzZTU3ZThiLi40
Y2IwZTMzNmNlNmIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9ydGw4MzY2cmIuYw0K
PiArKysgYi9kcml2ZXJzL25ldC9kc2EvcnRsODM2NnJiLmMNCj4gQEAgLTE0OSw2ICsxNDksMTEg
QEANCj4gICANCj4gICAjZGVmaW5lIFJUTDgzNjZSQl9WTEFOX0lOR1JFU1NfQ1RSTDJfUkVHCTB4
MDM3Zg0KPiAgIA0KPiArI2RlZmluZSBSVEw4MzY2UkJfU1RPUk1fQkNfQ1RSTAkJCTB4MDNlMA0K
PiArI2RlZmluZSBSVEw4MzY2UkJfU1RPUk1fTUNfQ1RSTAkJCTB4MDNlMQ0KPiArI2RlZmluZSBS
VEw4MzY2UkJfU1RPUk1fVU5EQV9DVFJMCQkweDAzZTINCj4gKyNkZWZpbmUgUlRMODM2NlJCX1NU
T1JNX1VOTUNfQ1RSTAkJMHgwM2UzDQo+ICsNCj4gICAvKiBMRUQgY29udHJvbCByZWdpc3RlcnMg
Ki8NCj4gICAjZGVmaW5lIFJUTDgzNjZSQl9MRURfQkxJTktSQVRFX1JFRwkJMHgwNDMwDQo+ICAg
I2RlZmluZSBSVEw4MzY2UkJfTEVEX0JMSU5LUkFURV9NQVNLCQkweDAwMDcNCj4gQEAgLTExNTgs
NyArMTE2Myw4IEBAIHJ0bDgzNjZyYl9wb3J0X3ByZV9icmlkZ2VfZmxhZ3Moc3RydWN0IGRzYV9z
d2l0Y2ggKmRzLCBpbnQgcG9ydCwNCj4gICAJCQkJc3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0
YWNrKQ0KPiAgIHsNCj4gICAJLyogV2Ugc3VwcG9ydCBlbmFibGluZy9kaXNhYmxpbmcgbGVhcm5p
bmcgKi8NCg0KUGVyaGFwcyB5b3UgY2FuIHJlbW92ZSB0aGlzIGNvbW1lbnQgYWx0b2dldGhlciwg
c2luY2Ugd2Ugc3VwcG9ydCBtb3JlIA0KdGhpbmdzIG5vdywgYW5kIGl0IGlzIHNlbGYgZXZpZGVu
dCBhbnl3YXkuDQoNCj4gLQlpZiAoZmxhZ3MubWFzayAmIH4oQlJfTEVBUk5JTkcpKQ0KPiArCWlm
IChmbGFncy5tYXNrICYgfihCUl9MRUFSTklORyB8IEJSX0JDQVNUX0ZMT09EIHwNCj4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgIEJSX01DQVNUX0ZMT09EIHwgQlJfRkxPT0QpKQ0KPiAgIAkJ
cmV0dXJuIC1FSU5WQUw7DQo+ICAgDQo+ICAgCXJldHVybiAwOw0KPiBAQCAtMTE4MCw2ICsxMTg2
LDM2IEBAIHJ0bDgzNjZyYl9wb3J0X2JyaWRnZV9mbGFncyhzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMs
IGludCBwb3J0LA0KPiAgIAkJCXJldHVybiByZXQ7DQo+ICAgCX0NCj4gICANCj4gKwlpZiAoZmxh
Z3MubWFzayAmIEJSX0JDQVNUX0ZMT09EKSB7DQo+ICsJCXJldCA9IHJlZ21hcF91cGRhdGVfYml0
cyhzbWktPm1hcCwgUlRMODM2NlJCX1NUT1JNX0JDX0NUUkwsDQo+ICsJCQkJCSBCSVQocG9ydCks
DQo+ICsJCQkJCSAoZmxhZ3MudmFsICYgQlJfQkNBU1RfRkxPT0QpID8gQklUKHBvcnQpIDogMCk7
DQo+ICsJCWlmIChyZXQpDQo+ICsJCQlyZXR1cm4gcmV0Ow0KPiArCX0NCj4gKw0KPiArCWlmIChm
bGFncy5tYXNrICYgQlJfTUNBU1RfRkxPT0QpIHsNCj4gKwkJcmV0ID0gcmVnbWFwX3VwZGF0ZV9i
aXRzKHNtaS0+bWFwLCBSVEw4MzY2UkJfU1RPUk1fTUNfQ1RSTCwNCj4gKwkJCQkJIEJJVChwb3J0
KSwNCj4gKwkJCQkJIChmbGFncy52YWwgJiBCUl9NQ0FTVF9GTE9PRCkgPyBCSVQocG9ydCkgOiAw
KTsNCj4gKwkJaWYgKHJldCkNCj4gKwkJCXJldHVybiByZXQ7DQo+ICsJfQ0KPiArDQo+ICsJLyog
RW5hYmxlL2Rpc2FibGUgYm90aCB0eXBlcyBvZiB1bmljYXN0IGZsb29kcyAqLw0KPiArCWlmIChm
bGFncy5tYXNrICYgQlJfRkxPT0QpIHsNCj4gKwkJcmV0ID0gcmVnbWFwX3VwZGF0ZV9iaXRzKHNt
aS0+bWFwLCBSVEw4MzY2UkJfU1RPUk1fVU5EQV9DVFJMLA0KPiArCQkJCQkgQklUKHBvcnQpLA0K
PiArCQkJCQkgKGZsYWdzLnZhbCAmIEJSX0ZMT09EKSA/IEJJVChwb3J0KSA6IDApOw0KPiArCQlp
ZiAocmV0KQ0KPiArCQkJcmV0dXJuIHJldDsNCj4gKwkJcmV0ID0gcmVnbWFwX3VwZGF0ZV9iaXRz
KHNtaS0+bWFwLCBSVEw4MzY2UkJfU1RPUk1fVU5NQ19DVFJMLA0KPiArCQkJCQkgQklUKHBvcnQp
LA0KPiArCQkJCQkgKGZsYWdzLnZhbCAmIEJSX0ZMT09EKSA/IEJJVChwb3J0KSA6IDApOw0KPiAr
CQlpZiAocmV0KQ0KPiArCQkJcmV0dXJuIHJldDsNCj4gKwl9DQo+ICsNCj4gICAJcmV0dXJuIDA7
DQo+ICAgfQ0KPiAgIA0KPiANCg==
