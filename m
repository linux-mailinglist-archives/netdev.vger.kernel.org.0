Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456A2466801
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 17:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359611AbhLBQ3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 11:29:12 -0500
Received: from mail-eopbgr40122.outbound.protection.outlook.com ([40.107.4.122]:13230
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1359525AbhLBQ26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 11:28:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTD2N0q8KgLUi60bTM5NrF3HIvyAl+0aF6ExAisxiT4k5PMjVUyHtPe/PibnhKGwuiasK2ixUetxu9+3abQInWmTwm11Kf2GRh8RbqmmLYOoKLwafNIuSt5QXQ04L/MHhfLnxIP5d2BMsVkWNNG1x2RkSUkAYGtwGWXSK8RHmbWfI+GF06uIf/RZ8YV5Z5vbj+4K/m2UQCadOw0bQ5a94kc/l7G4rVN+qVBEL5sXLbJEcmwWVbZHe8GrkXy2sVF0hZL4OXbgSS1hmNWiBqKmWqJfpuwyuQaf4O6n91ITD8gcLPWnxkvpZmUvS5OiXurHlRfx4LY0Wh0uMHT8mK16jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h29FixEkX4oLFUeAB5Ztjq8WG9H/Ne+KFUBIZoUuCOo=;
 b=ADFL0Vt9lYmLEQh9UeMqfkrVuQbNBAEp5+BzY0QAAtmKXq5Y2lOuLsYXwsulhPKqL6P8DjDolhJVNqf+iFMFhfkufG1pYybZDeibqv6jtHEZWbeqwJmGREd1sBFka7yfIyGDpH+wpwsdjKGF0mjU8qKs4yJqBIVQ4zO1QG5LTKu8hPnMbQ6wNQN+N9+hKYdnPKlf7N4UFLWZE0I9E4BMavNTWOG2z5OsmnO5TrWWoxtnCW/NWNdOy+ZORyxEI0Vjiy6oQOMNCu950nO/2uUowyGfF//llKRsP9g5GZZeL5es7aXVQRm2O0eudRj3SWb3PcRo7HV2ZI4yyb8omzqwqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h29FixEkX4oLFUeAB5Ztjq8WG9H/Ne+KFUBIZoUuCOo=;
 b=oBdK7LcDcYTUQ2vQivoCn0rrN0LR+INomuLHz4goFWJ48QtxY1qmDWn5cgInnKvJR0Cqc1gYw2kNKXrFzEfHGrrC+pvaMDSNTaR2qiy3fNN3Zmjb9w4/07pwlRYMFzfic+7o4PFh+1KbmuTUNSJyq7PzF21l4RgRaLEJ43nwK5U=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR0302MB3461.eurprd03.prod.outlook.com (2603:10a6:209:20::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Thu, 2 Dec
 2021 16:25:29 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::9d54:99ff:d6f4:9c63]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::9d54:99ff:d6f4:9c63%3]) with mapi id 15.20.4755.017; Thu, 2 Dec 2021
 16:25:28 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
Subject: Re: [PATCH net v2 1/3] net: dsa: realtek-smi: don't log an error on
 EPROBE_DEFER
Thread-Topic: [PATCH net v2 1/3] net: dsa: realtek-smi: don't log an error on
 EPROBE_DEFER
Thread-Index: AQHX5Qwh0DvFj/fYf0Ksuiav1OduZqwad/uAgATwWoA=
Date:   Thu, 2 Dec 2021 16:25:28 +0000
Message-ID: <a9a00aeb-8ef6-40f2-6a4a-28bed699abf6@bang-olufsen.dk>
References: <20211129103019.1997018-1-alvin@pqrs.dk>
 <163819080945.6089.1370849061046653334.git-patchwork-notify@kernel.org>
In-Reply-To: <163819080945.6089.1370849061046653334.git-patchwork-notify@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e173c067-df9f-422d-a8fe-08d9b5b05aaf
x-ms-traffictypediagnostic: AM6PR0302MB3461:
x-microsoft-antispam-prvs: <AM6PR0302MB34612A1C839D5D451834D5B583699@AM6PR0302MB3461.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7jBZIaGSTkS6fAWMvyuM5y0D3gXePBgPwlbzN/tgGDuj/yMJimNirWSMQpAqvYv7/0M5AS6eSytfqvX08Rvfzh+71DLUcAhSHU72PIjEs8+sUYFuhYWKkZp2F6XlUuF7B5nIxOHTx8NzEh92I2qV2vXxyWcR2yo6O5rvsDFKKX80y2Ny88C/OWrU8Jj1I3YiAXXqM7Y5v2vSM3UhOeN9nA5szFqb45M6Mtd2ZCkXXmhg2nQgpVDa9ucrut0BPkw6bfRBacBYwAvejd+4SUuAFnBf9MdrJwJmTIq1QAAIz0Cy9jljNxhF2SqL8e03rULIIGEkQlhdiZJtgyZhV1Z+WtgtxvrjVmuv5QxrZilr6LHjm6rUaPRWkMvIoj/cS3aQ7yK/jCDLWUTldZeCH2UmH3AcbKxT+FUwA7Xa6tnl9Ch5f8D9e0fS22rqPpkhFEgACqRgAqjxPKlU56LFP0nT6CHccoQUN2cApBhXwNCPwsMGTHzmDzKUAiNslpmLsy6PLa0z3XRMbA2MWMRV+AD5x+Hnmhj4pCkcYBlu6odVyX892B4tyVLaGgTNtcQMG0zg4bHsG0j+Pf8SPDa7zoiUO8Qkt01d4Mz+rk9Duymgbtkt+PJJ4P9PIlJiFLaoYPmqOMhty0EC5cjrMdbynkG/HVzbF77eLb9lHUAXKXT7PXqZAKrwTA+5yV7G3wEkELlzvB+Jf3k386f616ndL7reGj0F08qup8wm4R/8tXp7XXXSdKmW1FFiOqRKfpfZM8JiWdXMlc2+P8u6F+mE2SsQxPwCcH/WekEfaYTZmJb+TkNI2USNGAkpa9X0OlEFmr6Ye2JIFXZQyCHhe+vnEplNoOlGxrwBQY0lxV+Ii60/dOs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(36756003)(6506007)(66556008)(66476007)(6512007)(66946007)(110136005)(53546011)(4326008)(66446008)(66574015)(86362001)(26005)(5660300002)(71200400001)(64756008)(316002)(85202003)(54906003)(76116006)(8676002)(91956017)(6486002)(508600001)(122000001)(186003)(31696002)(2616005)(31686004)(85182001)(8936002)(966005)(38100700002)(8976002)(83380400001)(38070700005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NkJodlJ2a3QyQ1hvVE5wQXFJNHhLVEFwa1NMemJ0aUV1RC9NRThqUmF0VlNa?=
 =?utf-8?B?c0Z1Zi9MMW5aZE8wSEFKcXpvYnZPNit4RFpLckVNYnowcDBzVlcyU21KL3Q3?=
 =?utf-8?B?WlBLL1JvS2JwbmFJOXcvNzgxN1VseXZoRXMyZFdJOUsrKzd0Sm53Wkxwd0xC?=
 =?utf-8?B?K2trdmdnK3Jid2RyTFh6ZEVrQVpSZVNCdS9sb3g4YkdPdk5LWW4yb29pWXVw?=
 =?utf-8?B?cENVUFlLcTRrVTdsUG5hWllEbVcxYnYwcldDTDRITmdQY1o1T1RMRW54bjRx?=
 =?utf-8?B?UmtPRkhBVVRxR0pBblRxYXhIdDlZblRscEhrMHc5R2FyeUpmYWthQmhrbmMz?=
 =?utf-8?B?T2ZXRzdOYVlsdk1ONWsyQXJtT3EyZkxvcGlCYnI3aGE5a09zcFdHTHNKdTN5?=
 =?utf-8?B?bldhem92cys2SnBGTERMQXRuRjdOeDFFd291NlgvK2hwSU5Rd2tZSStBSmp3?=
 =?utf-8?B?eUZ2cGd2RGRVbTJyc2YyMlNIT3hmSWg4dHBZNHJVOWFVL3hrU2dwall1ZWVj?=
 =?utf-8?B?OEhPL1h2Q1ZWVjFtc0NsaVF6eUxBVUVzWkVlaGtRWmlDdVl2MGlyNUY0K2U5?=
 =?utf-8?B?MEtvV2x6OGQvMmZkb1B3eGJoMmZpSzZYL2ZHR1FQVklwRWxVSXNQRzhScXJQ?=
 =?utf-8?B?YmlDREs2NUdyNHdDMFovSFNGbEFWWGFxTnl4eUdrSXJHckdHK2xOUmhVMTRU?=
 =?utf-8?B?eGVkd1B1Um8wQnlESmY4NGltYUVpRzNHNUlLTTNkNGppNndFNnp0WWFtSjRO?=
 =?utf-8?B?VHlkaHZyZGE2NW9VVGhmVm9FbEhWSlp5eHhyYjcxWG9tWEhSWXB5RGMxRFJq?=
 =?utf-8?B?Qk1xd0NkRy9BdUF6bnhKYkdCd2ZSd0NmWko4REE5aEtraXhLR00rWnJ6c1pV?=
 =?utf-8?B?T0Z6V1VHYm5wOE1IMThscis2U3cwYStTYi83aEFId0VkRyt1akZha0tOUng5?=
 =?utf-8?B?ajlReDIzSlF5MCtjS28xVEtnWUFLdmFycTJjZ05GZGZjaXhQc2xUUFc5NEVH?=
 =?utf-8?B?VDg0bDAzYVB0cEZkRlk1bjFTa2NRcVh6NE9leDZKV2piMjQ2NXNZWnZ6b0pZ?=
 =?utf-8?B?dkJEOTRiQVZaZGpWS1p3Z3JUYWRFK1hSNERGRnk4WkpSWHJ3Vmo3N3F1RzQy?=
 =?utf-8?B?SktPTDFmZXh4YmNpNzZpaElDSUxQSGhrWVNocHVodTZ2dzZGbjNqYUViOTFX?=
 =?utf-8?B?Yyt6cTNML1dBNk9KVzBDME13NzA0am1lUGd3OUhvVDdVQkMrejM0d2tiSEt0?=
 =?utf-8?B?MTlDcG1mOFpDTUZLZ0Q4ek5YRzdoSkQ4bWROL0dVb0dOVGVIcktQQ1lKd2ps?=
 =?utf-8?B?R2pUenk0bzdxU0RFMGM2dXNwMUxCOS9MOEhxZkNQOUJXUHNFRDVVeUNkZ1h5?=
 =?utf-8?B?Q2JjcWdvVkxFSVdtTWwveFhxZ2d3RGt4MkMxai9OSEhOcU1ZQzlYWFpnUVRs?=
 =?utf-8?B?WmVrZUlXREZLeTZYdm5iY01GMWR6MGVRaDVzb04wZE4wU2Iwc002bGlRTTZZ?=
 =?utf-8?B?blUydjdKd1pzdHNKWCt0U2NyMGhEKzJOUzQwcVBOVW12RVZLbFkxNEhCeU9s?=
 =?utf-8?B?VHlyUlI0bnk4VHdrbzdIN0M2MllHRHF1RmZhL0Myd1dMajAreUUrUVozWlZ0?=
 =?utf-8?B?TTJ3MmxxWEwxbnJaQ1ljTWdhV3cvZ2U4ZW44aUhzNzA3UFdyRUFoU3dXb0ps?=
 =?utf-8?B?SjhZZG9YcldBazM5UnNub1lFVWJiKzd5M0oyMUlSS1JKNU1IKzhBcFpxejZM?=
 =?utf-8?B?dzJrQjNBa0dtMHdKK285UHkyeHVsZjV5WTYwUXZKQUcraEZEci9QSklQY2w1?=
 =?utf-8?B?M3k1K1ZLUGlZRnZZS2s2TGN4NjRJdjNFSllpVGgzYkZrVzlja2FzNXRtSnJJ?=
 =?utf-8?B?ZGZZdk9EUzI5ZGtSQ2VPVlY5OTVhMHdyWVQxT3V5U211eFY1UUplb0JEZlYy?=
 =?utf-8?B?T1NNVEZUSkRSd0FmOGg2OW5YNDd4VVlZNit0anVld0p4V2FCaFh1QUM3U2lM?=
 =?utf-8?B?QU1NRnkxc2MybDludDBlR3dTWWxpNUZWMHVXZ2ZkTTNLbGREL2hhOVJEb2xB?=
 =?utf-8?B?MHQ0cDZHTTBtUDlNU3lDMVpuWTNya05hZFZiZTJsT0hRWGNSTkdsTXZFc1JJ?=
 =?utf-8?B?bTZRYW1BYXE1bjdOMS9vdzhjdC9wZVNWR3QvRXkrdFdoZzRTWGhJK21leGhr?=
 =?utf-8?Q?6ctzUpPFULS0Dj8wYCYr8yc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <18D717D019B9B940B33B02DF84928EBE@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e173c067-df9f-422d-a8fe-08d9b5b05aaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 16:25:28.9089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C8OKnXzrC+xkUIPXIhJiOj43R1obA2ITqxcfl+NZofgcUn6/TPD0CKXm+S5M0+cvV5y+/94Gevv6a2dKGW7BMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0302MB3461
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQgYW5kIEpha3ViLA0KDQpJIGp1c3Qgbm90aWNlZCB0aGVzZSBwYXRjaGVzIGFyZW4n
dCBpbiB0aGUgbmV0d29ya2luZyBwdWxsIHJlcXVlc3QgZm9yIA0KNS4xNi1yYzQuIEluZGVlZCwg
cGF0Y2h3b3JrIGJvdCBzYXlzIHRoYXQgdGhleSB3ZXJlIGFwcGxpZWQgdG8gbmV0LW5leHQgDQoo
ZGlkbid0IG5vdGljZSBiZWZvcmUpLiBJcyBpdCBub3cgdG9vIGxhdGUgZm9yIHRoZW0gdG8gbGFu
ZCBpbiA1LjE2Pw0KDQpJdCBpcyBub3QgYSBiaWcgZGVhbCwgYnV0IHRoZSBpbnRlcnByZXRhdGlv
biBvZiBkZXZpY2UgdHJlZS1zcGVjaWZpZWQgDQpSR01JSSBSWCBkZWxheSBpcyBkaWZmZXJlbnQg
YWZ0ZXIgdGhpcyBzZXJpZXMsIGhlbmNlIHdoeSBJIHdhbnRlZCB0byBnZXQgDQppdCBpbiBiZWZv
cmUgdGhlIGRyaXZlciBtYWtlcyBpdHMgd2F5IGludG8gYSByZWxlYXNlLg0KDQpNYXliZSBJIGRp
ZCBzb21ldGhpbmcgd3Jvbmc/IEkgYW0gcHJldHR5IG5ldyB0byBuZXRkZXYuIDotKQ0KDQpUaGFu
a3MhDQoNCglBbHZpbg0KDQpPbiAxMS8yOS8yMSAxNDowMCwgcGF0Y2h3b3JrLWJvdCtuZXRkZXZi
cGZAa2VybmVsLm9yZyB3cm90ZToNCj4gSGVsbG86DQo+IA0KPiBUaGlzIHNlcmllcyB3YXMgYXBw
bGllZCB0byBuZXRkZXYvbmV0LW5leHQuZ2l0IChtYXN0ZXIpDQo+IGJ5IERhdmlkIFMuIE1pbGxl
ciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD46DQo+IA0KPiBPbiBNb24sIDI5IE5vdiAyMDIxIDExOjMw
OjE3ICswMTAwIHlvdSB3cm90ZToNCj4+IEZyb206IEFsdmluIMWgaXByYWdhIDxhbHNpQGJhbmct
b2x1ZnNlbi5kaz4NCj4+DQo+PiBQcm9iZSBkZWZlcnJhbCBpcyBub3QgYW4gZXJyb3IsIHNvIGRv
bid0IGxvZyB0aGlzIGFzIGFuIGVycm9yOg0KPj4NCj4+IFswLjU5MDE1Nl0gcmVhbHRlay1zbWkg
ZXRoZXJuZXQtc3dpdGNoOiB1bmFibGUgdG8gcmVnaXN0ZXIgc3dpdGNoIHJldCA9IC01MTcNCj4+
DQo+PiBTaWduZWQtb2ZmLWJ5OiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZzZW4uZGs+
DQo+Pg0KPj4gWy4uLl0NCj4gDQo+IEhlcmUgaXMgdGhlIHN1bW1hcnkgd2l0aCBsaW5rczoNCj4g
ICAgLSBbbmV0LHYyLDEvM10gbmV0OiBkc2E6IHJlYWx0ZWstc21pOiBkb24ndCBsb2cgYW4gZXJy
b3Igb24gRVBST0JFX0RFRkVSDQo+ICAgICAgaHR0cHM6Ly9naXQua2VybmVsLm9yZy9uZXRkZXYv
bmV0LW5leHQvYy9iMDE0ODYxZDk2YTY+PiAgICAtIFtuZXQsdjIsMi8zXSBuZXQ6IGRzYTogcnRs
ODM2NW1iOiBmaXggZ2FyYmxlZCBjb21tZW50DQo+ICAgICAgaHR0cHM6Ly9naXQua2VybmVsLm9y
Zy9uZXRkZXYvbmV0LW5leHQvYy8xZWNhYjkzNzBlZWY+PiAgICAtIFtuZXQsdjIsMy8zXSBuZXQ6
IGRzYTogcnRsODM2NW1iOiBzZXQgUkdNSUkgUlggZGVsYXkgaW4gc3RlcHMgb2YgMC4zIG5zDQo+
ICAgICAgaHR0cHM6Ly9naXQua2VybmVsLm9yZy9uZXRkZXYvbmV0LW5leHQvYy9lZjEzNjgzN2Fh
ZjY+PiANCj4gWW91IGFyZSBhd2Vzb21lLCB0aGFuayB5b3UhDQo+IA0KDQo=
