Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE27B4195E1
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 16:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbhI0OF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 10:05:56 -0400
Received: from mail-bn8nam11on2086.outbound.protection.outlook.com ([40.107.236.86]:27979
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234612AbhI0OFu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 10:05:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KoEb+54XGDqJknocO1iA7A26uc+WISJVFkODlAERDTWVEn9q6r1lewT2Vav9o6ORe7pMwTUdhAU1+v75rkXG+c4ZrOn19OeD0DiQCjZfD8vKdUdgzP2gwBKhNJgypGIrxKfskFYUJGoYFBOexG2HhhFn7zwsIW8pAkvabZ75vGn7cMYDpw46fHbE17IRAd8X+Xd1nKrQrMjzFqfAkQIlawg0L2cn+oRlT31CfDICKNkoDdAemFI4oaV1/59WvkwlL+r9IV5vYAOViZcTccXrqwj7Yl4A9GjFjDMy8drv+Hy1znXjdMccGPvGMr6m+WBXF8lSh7Dvncs86UbfcQZO1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=4ye8T/GViWz0R3OMeuidbXy9mssvFELctarsbEF/zKI=;
 b=heTsc/bQ7fUO52A9Lz3C6iiIdId1/yaqN1jyYV1rByqh6wE7Zt1HiAr+Cx34xVeEzE5P5ywmdo8j2R4QsdIVMdQXPC/kpmG8OWAj7vh4uA39vwhbybsLx/sbSqQ8H50P7Vwoj9MyoszEhA4l/Sj8aUR0UNF12XExHBKrntWiFAHVupv1hs6bFXbwQVGyb/b9byfHUx1/WVxXnCyJtfUhoG9djtIi6KGiaXowAVXi8cBlkt9g3PWur16Z65ybkJLiW5jBzyiGDm+PDBnwfz6sn880ouay/wdeQvA+45dknZ8Octd1LheptNk1cFahRow8GCBJhkIWukVovR1gB1imzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ye8T/GViWz0R3OMeuidbXy9mssvFELctarsbEF/zKI=;
 b=NFb/kaE5kum7F6AbmSc0jWkVeDlIco86CKh3QB2u6hK2hgY+Jj3ESrn+V+IBAKNuyNQDjTlPpgk0Q1uU0JDOa0P2oyHbIjnT6KAyYhrFaiBPh138iN//Lnlu/KNwwHFRWj7cgRqsa+mXbIkNuLpF6wMF6N8llyFanTwn2PAkak0JVTPALOHSTLwOIoOFgWz4dKGHbiE78pXMnZ0wjP5L4JeNcaHIQwVlr9mkKWPyleoVI6xh9mQfyXmU5ZNrc9P+HEegPYze4fzVSRxc8EuAFNADPEESdX45XdQ4PatfbDTIwWsYBfRrA2YUdrPDmRrtHxAs411ZRYqqVP9cf/iAsg==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB3687.namprd12.prod.outlook.com (2603:10b6:610:2b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Mon, 27 Sep
 2021 14:04:08 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142%5]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 14:04:07 +0000
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Thompson <davthompson@nvidia.com>
Subject: RE: [PATCH v3 1/2] gpio: mlxbf2: Introduce IRQ support
Thread-Topic: [PATCH v3 1/2] gpio: mlxbf2: Introduce IRQ support
Thread-Index: AQHXsLi5/ezHFM2t80qMnoiP1wWjOauzEi0AgADJmACABBI7EA==
Date:   Mon, 27 Sep 2021 14:04:07 +0000
Message-ID: <CH2PR12MB38951F2326196AB5B573A73DD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210923202216.16091-1-asmaa@nvidia.com>
 <20210923202216.16091-2-asmaa@nvidia.com> <YU26lIUayYXU/x9l@lunn.ch>
 <CACRpkdbUJF6VUPk9kCMPBvjeL3frJAbHq+h0-z7P-a1pSU+fiw@mail.gmail.com>
In-Reply-To: <CACRpkdbUJF6VUPk9kCMPBvjeL3frJAbHq+h0-z7P-a1pSU+fiw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c84f542-413d-402d-99f4-08d981bfac53
x-ms-traffictypediagnostic: CH2PR12MB3687:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB368738BC04AAE35D9D8BF345D7A79@CH2PR12MB3687.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3JcK30nWtPfGJUrimkXCzSS1/Ir+1vpMVP+CyiCj30rql/U4liM5KAMeTgeEH0o+Ph3j0SrVKpZ+TcIGmFgNr2Y3X6k45GWC8obJ5+h96eS0TVH/DjSrgOCUwolObD8OVSKH/ydBBbVvYQImK+P1bF2qVY2F9cHpMCNDE9Tv2tlvKXVO7ykqzL8/QPiLWutf1JF/1aHGQUeuizqkDIKKpU86WnHlX0x2w2qY93a9zXbRlvPnItjVquE7VSrWkSqtQANHGrjbb7D5xYV7TljSK1qCfFfBRsx8ceGoeM+TRb1VYV543iMgdUHV+2x56h8HdVSOohIfk84aRc9U+UjJrFZMvmPwW0EBWdhrRXwgmXQV7oMRGARklizApZGIESJ92UYwJXMPAOihllhiwNpLAJbmnmxWDfQg97KfDFONzg+5Nq6mHNQLm47MWCpftttsyuRl7q2qm/N/kEcnbaWmg8395B+8oFwWUABaCu+Z3rPNG6X/egtZHwqPHLVNOT1qb4MN76EfxkgrxW6wjgGRi1J+UElRYD8vi2vnO2xmYpZt+7AgP/3NVEzZI31d52ir0SymbGKEzf1dthBTyx8hBzZMfFOSPPSf6p4smCOaXBs2KTYlb69ORxwl8SBxW5D1Weid6ryp/g2Ta5MuSEpb3OplxINecognvbk9TD+kW8WfX9HPnsavJeLjRQ2zsNuUyFZnxjJXool9HFA5zKVtCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(54906003)(110136005)(122000001)(76116006)(316002)(508600001)(83380400001)(38100700002)(66946007)(86362001)(2906002)(8936002)(7696005)(4326008)(26005)(5660300002)(107886003)(33656002)(38070700005)(66446008)(64756008)(7416002)(52536014)(6506007)(9686003)(55016002)(8676002)(186003)(71200400001)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkpLM3U2MVMrNWNxOXMrTmJSU0NPMm1NSUl5djhVQzdTWnpVU2RMYjBkbmVT?=
 =?utf-8?B?cExIakhmQ1RVRmR2dkVhQzRLcGR4Y0dwRzY2UWQrNVBIMnFsS0FXZThmbnB0?=
 =?utf-8?B?RUpBclpZOGVFaWtPS3BPWHJYMTY1Qkw1d3I5U2tybE9sQ3I0SlFza0VGL0dB?=
 =?utf-8?B?c0FQNHB3MUdQelJub2J6WG5vS24rWEdTL0hFMzR1WWozVVdKeHZlOTVqQXph?=
 =?utf-8?B?MkZ6TXZQeHVWRWZiNVZDbXVvQnNLVXZCQWw4TVhKbkg3LzBmaGQ1V2R3Rm5k?=
 =?utf-8?B?ZWxPeTRJVzBVZGFMUDVnNlNNOHFWYUxsTjZldHJsckJEaTVSRmdXV0hpZ1ZM?=
 =?utf-8?B?OGM1ZmRkbnZIMUxtbjQ3ZUNJVHFmTXVLNU1zanJvcW05emN6LysvS3M4T0tp?=
 =?utf-8?B?NVJBMmc3OVZZOTN1emNXcndwR2NJMFNtY0JyNWlPRS9RSTBKMWYxWUY1Vkw1?=
 =?utf-8?B?bE05RWVjSFEzUHh3MFR5L291L0xWUWIrVW0xb0FMS1BRUzdjWCsvSGR0Rllx?=
 =?utf-8?B?YytxVDR4bk5NZDZaUGJKSVBTWkl5U1NaRnlSK3Z3Y1A2bnZkcnB6VS9Ob2tM?=
 =?utf-8?B?V0xSU0xPeDU5K1NNTTUwQVVjaDVsWnFRZW01TkRLQUhCNUI3VlV4WksvbXkv?=
 =?utf-8?B?R2tvbytYMVRVSnpPZnZQd3k2L3VUN0hEYmp0Smt0alpUaDJRT0dyaUFaL01l?=
 =?utf-8?B?WHZmaklFYnc3bmVJbm9IelV0UFpHMXE5ZVp0VlpyNFpja1J0cVZPdVdhVURw?=
 =?utf-8?B?T3o3U3ZkYUJQeUFTU1hWTmEvU2VsYlJ1ZWJDV0tXeEh0WGhmTDB2QkU1K0J2?=
 =?utf-8?B?Wms0a2JlQ2Y5bG1CSGw3STM3ekF2aVlJQk5qMnZIeFl6cjdyc0ZaTU9YaERi?=
 =?utf-8?B?VnJnSEFRR09LekEra3NYOXNMTTcycTNiOEdVYlBmNEw4aXJ3OExpbzU1UU1B?=
 =?utf-8?B?ck1aTEsvRUxJbmFjU1ZYREFXUjByR2FaN1MxTGhCaHZ5Qm9RZXdQRzl5aVNm?=
 =?utf-8?B?TTVIVER0cUFoeGxUenhiQkRrZlN4YUZTUDJ3UzR4R2JwT3ZKUFpUVGlheHM5?=
 =?utf-8?B?eGEwVXphRGZLU1VLNGxWMURTWjRPakVhclZmRHowVVF2U0NpMjA5Z1hoWFdW?=
 =?utf-8?B?ZVhZMUgyaGNnYXpaOFhtdHVpbHcwcG9WVWlRNlNDNGpMRHc3VUhTR3pmS0Z3?=
 =?utf-8?B?am9NUW9DNm9OUFA3Wm1KcFY0cExpSnhpL2I5dEZSTHdOSXRNclB6aUpnaHBa?=
 =?utf-8?B?L3pHMG9UeWhJYjlBdC9RcUhGOXJMMG10U3dzS2cwL1RDcjdrcnEreUYyN3pB?=
 =?utf-8?B?SFgzRy9PcThwYm94eHp4VVZyQVhYVVpGaklnNzFoMlFpMW9kWnV1RXc2SDND?=
 =?utf-8?B?a2o1NFgzdFVGdjM3dmRhcGY4QUNKLy9iRkRuOU1oUFhOUFJvUEpKaWl4R2Fx?=
 =?utf-8?B?dCtXYnRvYWdrOGxnem5Cc0FkWkxySkFwL2ZRdEpHRDB0a2pUVldWMGhha3hI?=
 =?utf-8?B?ZlN0dDJQakhMcy80Sk93ODFrR2JBTTd4cVd6YnRJeEFhN3BZaW1CQ3BCeisw?=
 =?utf-8?B?Zk4vYzdERUxNeHBBZWc2WGhNUkR1bVFtTVZsd3laZ1hXeHdwSndrMnVEVjFy?=
 =?utf-8?B?QnNFaWowN1ZVdm1zUnpQbk4weWVXTDFxdU9vMXhqRG41Rmx4aFlKeVdzRWo0?=
 =?utf-8?B?YmdDWmM4Vm5iRzRTVFBIL2xHajVtKzF1MzNwaVdhVjhzbjZsc2NyeW5XU0JY?=
 =?utf-8?Q?5BS9PkNN4pl83J2rVvFQRWpMRWfGn4w9wG0zs/U?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c84f542-413d-402d-99f4-08d981bfac53
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2021 14:04:07.8683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FTI60A5Ct48+nEDWwGQi8HNmztglS4fQLawQNq2iakLO40bbL1w22FhwE/N9E2X4CeDC5AxNrvgWqqGn32irWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+ICtzdGF0aWMgaW50DQo+ID4gK21seGJmMl9ncGlvX2lycV9zZXRfdHlwZShzdHJ1Y3QgaXJx
X2RhdGEgKmlycWQsIHVuc2lnbmVkIGludCB0eXBlKSANCj4gPiArew0KPiA+ICsgICAgIHN0cnVj
dCBncGlvX2NoaXAgKmdjID0gaXJxX2RhdGFfZ2V0X2lycV9jaGlwX2RhdGEoaXJxZCk7DQo+ID4g
KyAgICAgc3RydWN0IG1seGJmMl9ncGlvX2NvbnRleHQgKmdzID0gZ3Bpb2NoaXBfZ2V0X2RhdGEo
Z2MpOw0KPiA+ICsgICAgIGludCBvZmZzZXQgPSBpcnFkX3RvX2h3aXJxKGlycWQpOw0KPiA+ICsg
ICAgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+ID4gKyAgICAgYm9vbCBmYWxsID0gZmFsc2U7DQo+
ID4gKyAgICAgYm9vbCByaXNlID0gZmFsc2U7DQo+ID4gKyAgICAgdTMyIHZhbDsNCj4gPiArDQo+
ID4gKyAgICAgc3dpdGNoICh0eXBlICYgSVJRX1RZUEVfU0VOU0VfTUFTSykgew0KPiA+ICsgICAg
IGNhc2UgSVJRX1RZUEVfRURHRV9CT1RIOg0KPiA+ICsgICAgIGNhc2UgSVJRX1RZUEVfTEVWRUxf
TUFTSzoNCj4gPiArICAgICAgICAgICAgIGZhbGwgPSB0cnVlOw0KPiA+ICsgICAgICAgICAgICAg
cmlzZSA9IHRydWU7DQo+ID4gKyAgICAgICAgICAgICBicmVhazsNCj4gPiArICAgICBjYXNlIElS
UV9UWVBFX0VER0VfUklTSU5HOg0KPiA+ICsgICAgIGNhc2UgSVJRX1RZUEVfTEVWRUxfSElHSDoN
Cj4gPiArICAgICAgICAgICAgIHJpc2UgPSB0cnVlOw0KPiA+ICsgICAgICAgICAgICAgYnJlYWs7
DQo+ID4gKyAgICAgY2FzZSBJUlFfVFlQRV9FREdFX0ZBTExJTkc6DQo+ID4gKyAgICAgY2FzZSBJ
UlFfVFlQRV9MRVZFTF9MT1c6DQo+ID4gKyAgICAgICAgICAgICBmYWxsID0gdHJ1ZTsNCj4gPiAr
ICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICsgICAgIGRlZmF1bHQ6DQo+ID4gKyAgICAgICAgICAg
ICByZXR1cm4gLUVJTlZBTDsNCj4gPiArICAgICB9DQo+DQo+IEknbSBzdGlsbCBub3QgY29udmlu
Y2VkIHRoaXMgaXMgY29ycmVjdC4gUmlzaW5nIGVkZ2UgaXMgZGlmZmVyZW50IHRvIA0KPiBoaWdo
LiBSaXNpbmcgZWRnZSBvbmx5IGV2ZXIgaW50ZXJydXB0cyBvbmNlLCBsZXZlbCBrZWVwcyBpbnRl
cnJ1cHRpbmcgDQo+IHVudGlsIHRoZSBzb3VyY2UgaXMgY2xlYXJlZC4gWW91IGNhbm5vdCBzdG9y
ZSB0aGUgZm91ciBkaWZmZXJlbnQgDQo+IG9wdGlvbnMgaW4gdHdvIGJpdHMuDQo+DQo+IExpbnVz
LCBoYXZlIHlvdSBzZWVuIGFueXRoaW5nIGxpa2UgdGhpcyBiZWZvcmU/DQoNCj4gTm8sIGFuZCBJ
IGFncmVlIGl0IGxvb2tzIHdlaXJkLg0KDQo+IFRoZXJlIG11c3QgYmUgc29tZSBleHBsYW5hdGlv
biwgd2hhdCBkb2VzIHRoZSBkYXRhc2hlZXQgc2F5Pw0KDQpJIGhhdmUgY29uc3VsdGVkIHRoZSBI
VyBmb2xrcyBhYm91dCB0aGlzLCBhbmQgdGhleSBjb25maXJtZWQgdGhhdA0KT3VyIGludGVybmFs
IEdQSU8gSFcgZGV0ZWN0cyB0aGUgZmFsbGluZyBlZGdlLg0KSU5UX04gc2lnbmFsIChLU1o5MDMx
KSAtLS1jb25uZWN0ZWQgdG8tLS0tID4gQmx1ZUZpZWxkIEdQSU85IChvciBHUElPMTIpDQpFdmVu
IGlmIElOVF9OIGlzIGFuIGFjdGl2ZSBsZXZlbCBpbnRlcnJ1cHQsIHRoZSBHUElPIEhXIGFsd2F5
cyBkZXRlY3RzDQp0aGUgZmFsbGluZyBlZGdlLiBUaGlzIGlzIHdoeSB0aGUgb3JpZ2luYWwgc2ln
bmFsIGRvZXNu4oCZdCByZWFsbHkgbWF0dGVyLg0KVGhlIEJsdWVGaWVsZCBHUElPIEhXIG9ubHkg
c3VwcG9ydCBFZGdlIGludGVycnVwdHMuDQoNCg==
