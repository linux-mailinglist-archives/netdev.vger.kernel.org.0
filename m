Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05C444376E
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 21:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhKBUob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 16:44:31 -0400
Received: from mail-co1nam11on2087.outbound.protection.outlook.com ([40.107.220.87]:13750
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229813AbhKBUob (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 16:44:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hsD5wC15MWn0qdO/voJbS3rKkW4DZ64sI0m4dHTqPlSQqHISPSi0wVtiMMqrv7xPJSk4jH3XyzjIst16vNXLEDJYGgO36AHb/bQJngWVkl8AE3nduNvmu2EqL2jqXp99KtjhXT0axJrO1i+0JdqTJaXjwNt/ZJMejDcBMIvCqr9kBZaMy3dp0WBlBsTEVXuPRmNn5g2o49iufrLD1otqWmFXRWoHdygEQOCrSasxtG6GdSRH9JttweKwc382XFiMPYZ/qMopEKBuC6lLWoeso76Q6ey+bR0FbAOBKDjky8NtOsAMe9sS4CuKAOHauWIRh+svd6SfcepV2lTMxUogCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K5zl4Mr/YbAlUVcXiy+1bTTWFHQXMkkUHPpa0OpfMWo=;
 b=dGfoNRxq0ihzq8Rx0IyHUhx/UQX1Uhq9d9rQtvYA4Vf7W3xB1y8Ai9n9jbXKGgg/zMaeccNj3KJdxUvOK4LCuKux1pkAxBrHC3L3KGBYhoVYxZ1WkcH6Crtu71Gt2VlyfTttGia0+AQjCxpHe3/KdlVTR+qSPV9dRz2GeiEvv+dXvI4z12csmWxwOlh4nUNDldLm+H+estcbsUnfsqKN8SRAfKVAja6RisFIrv9G7jlYg0zy9+2WkT2ZGiOA33twAYssqZsm9VI4JwG2vZ+ApPk6Hi+UFdbXO1m5fSsUWc6J2emiW4/N/73/CIyvoyYtpI1M4b+mJQwO40zd5wbUDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5zl4Mr/YbAlUVcXiy+1bTTWFHQXMkkUHPpa0OpfMWo=;
 b=fd8+uAYfAKgTtwZT27+Et3ue7Aeie9I6QXV4tFV1b7pnbfG0mmtT0bjlvTSZZ0+zxpsQwAWr7RqGq8cdHvs4SdpcAvFTluVM85i0gjIpl8D7XUterQNsKR6+JjBEgkZh43W9CWxz3htCkOR8iHA87g5nxcjeTYZwhSvX6A/YvmwBGLr3vtDEMsl6emxcq+spn0qrqnLfh3wEds8W9ahTagnZvLvQgeJaagImqKFm0QUC5E+rckS/5Os8uCjuNecvF0PACKZjcXofYvyQrIwSFva6E7gxGRoiq8V/v0z8zOVZcA6sNsKHc8zkdwSBgnVfN6csaebkvOX/Dw/yddQ2lA==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3592.namprd12.prod.outlook.com (2603:10b6:a03:db::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Tue, 2 Nov
 2021 20:41:54 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%7]) with mapi id 15.20.4669.010; Tue, 2 Nov 2021
 20:41:54 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net] ethtool: fix ethtool msg len calculation for pause
 stats
Thread-Topic: [PATCH net] ethtool: fix ethtool msg len calculation for pause
 stats
Thread-Index: AQHXz6EZjp05BCw+C0ei8dTnJmF0uavwaJeAgAAh9YCAACpUgA==
Date:   Tue, 2 Nov 2021 20:41:54 +0000
Message-ID: <03479b6cdf2be2eb1da5336e858c44452bc5d88d.camel@nvidia.com>
References: <20211102042120.3595389-1-kuba@kernel.org>
         <502b2fdb44dfb579eaa00ca912b836eb8075e367.camel@nvidia.com>
         <20211102111023.6ed54026@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20211102111023.6ed54026@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb9b7af5-041a-4a63-f421-08d99e4134aa
x-ms-traffictypediagnostic: BYAPR12MB3592:
x-microsoft-antispam-prvs: <BYAPR12MB359296EDDD972F04E255BB7FB38B9@BYAPR12MB3592.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LS1Hc9ndwRqkn6FEGzbe7XcUMiQclX8pkG+8pUYYjwAIoo0sF/Exc+Z7w0AasBqkLHne5X8+/Alg0/DbRRMHFcUmltS8Boa141geT+NNCufGR2nrgOpsn5WWviWkUJJf1ng4XGeuX0Rgo9wrWg+Z6Q9P+B3dep7TdwGxk16wTroj41eb1k6Dj1wHP3B5XtVwuCxzH9+BFWM8POnXfIv7C+3V0fupQV1MQTaqJMX05ff0RZL7dJwnRMeHNgmTtrz0jBp9EOowfYRj3nc7OTXb8vtQ+kwjk0E7t3QsLT3xYbbLvKJJaghDi7uIsrLL+VNhB0UKGjTLMAZE0NzfoiXiZfIn9522qO1TNqV55itOK7gUAjUeGRcFOvTQeQLfoODbfzCAoxdqt0j6noa9SXrU0+9aumtmD87Q2DH+aLEhSpRUoX1P2R9eBLEfHDUfQAhFOngPm1ENK7V2uNtkFU9jJihLdWVl3I35PrjGROhFz6WfuVtLrEswYXiq2qq9JGSr+J7G9utnDNg0uL2eTH2xo7LKxA2jQdC/Crn4zOuBuOHTHXwOmaWh4usOXeXPvEwRP0J/I7c4cEL7zu0hFj2vhHjqxaQ4ev79R9gKLC8DDuEtxxE9XeZPMV6AO2c2IPR+jUmZBHygEBi/86//1PSv6cztHNgOGI0Wfudz0u2ymZTHo0oHp6DJa379g/UC1cdT23UnTfQf2XfOsmt02Axq8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(26005)(186003)(4326008)(508600001)(54906003)(86362001)(38070700005)(6916009)(2906002)(316002)(5660300002)(76116006)(66946007)(6486002)(66446008)(66556008)(66476007)(36756003)(2616005)(64756008)(71200400001)(8936002)(8676002)(38100700002)(6506007)(4744005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXVEZGs5Wk4xSTRRSzU0K3BFYnpINEZtcDdPenkrancxRWZJNGdjK1lKZkp1?=
 =?utf-8?B?bUhRUnB5LzVGdXB0NVpQL3haTjRIS2ozV1E3RWRBYmJKbDZuUndqWVFQQktv?=
 =?utf-8?B?aU40d0M4TXlMY2FsSDFsb3BkZnFhL3krOHlHajdwMG41OEpVNXU0QmZEYXZD?=
 =?utf-8?B?akNsOERBR29tM2VIOWtieHJFSE1ZU0dFeEFudmJoa3hQbFdMaUxsY0tJV3Br?=
 =?utf-8?B?UThvMUQ3Y1RMcll5d2xQbTlvWmZrVm82L1hWNVo0MExGWkY1UzVkTzhIeVJN?=
 =?utf-8?B?a3N6aG1BUmZ4ZmlWZS9Ndmw0U04xdThycEJSelJLNUpCOHEySGYwbkJMY3Rs?=
 =?utf-8?B?T2dRaFZZQkh5b1RGVjhDN1NKditEdVMvMU9KZDJFMXZnU2tuZGpwNkV4dVV1?=
 =?utf-8?B?NmFQSHErazFJY0lXaTIrNEpYYjl4MEdQd3IzWU5WeEtDSkx3SnBPeFJhVGNO?=
 =?utf-8?B?QWNJd1BFUEUrcW5ldjFOMURhb2RxVUhXY0FxZm5zcUFTWnN0YWYxVmRLVUpE?=
 =?utf-8?B?T3AxcmFxMVRPQ1huUzZsZG9BaXp5eDN2VGhDU3Z2bmdyU0E1bG4vRXJvVnlR?=
 =?utf-8?B?enJBOHV2V2NDUXlHUy9qNElBME1HYlorQ05HcS9RZzZkSCtOWGh1OGRKWTNy?=
 =?utf-8?B?dng3OXBNTlZ3SHpDL0JEMjRwdDRXTm9xdFJmNzBuZ0x4NjZRTDc5dXNjZ2VU?=
 =?utf-8?B?OXhaVDJRRVJNMHR3NFR6MklRUFFFMXczeVRlSk5JRmgzQ1NBMUdNZ01DT0Fi?=
 =?utf-8?B?dnlCSytoSmVFYk1FdHNtRUFCclBwbHlxR05OaVZGRVBKS3BpMWIrZ0ZnWHpX?=
 =?utf-8?B?Ujl0RitQeTM4T1pyNXpSZGdsUkM4THI3SlZTdDNJSVFQRGI4R3MwTGNQVUxq?=
 =?utf-8?B?clg0Z3labUpmM0ZWRXg3NWdlR1B5Mm1nek5MZEdXb3ZhWjdpRDFNMG5FNXl5?=
 =?utf-8?B?MXg4eVgzYVJhRjNhREVMSzhPQmM5bGw1RTlTQXBqMDBvNkI1S1p1b1NZdEE1?=
 =?utf-8?B?d215V3QwUWs1N25aTCtKYjdDSDhqRGgrK1l3dDEraTUzTlJPMWtlV3VmNVlH?=
 =?utf-8?B?Zm1QYlpCMUVxbEc1dDBRODJwVTYrWTF1YUE4ZmRSMDROZGQwSTRUSnlraGo1?=
 =?utf-8?B?V0tXYVdyZDRnQkhVUDhhUTdOYnJtQnM4RkZ0Q1dnV2g2L3V1UFdSUGJWQ3pS?=
 =?utf-8?B?NS9RMS9pUG5BeEJmdmNRQm1QeHdaa0RzZjIyYlluQldETG1JK0tGMzBYRlJN?=
 =?utf-8?B?QmtkcTVjRmRPdWh0bXk5dnNYT291VjV4aCtIMGNKNUpWSWc0WENmZ2Q2SzdW?=
 =?utf-8?B?ZFZKNld1c2JKZVhIVit0VmU1T1JNZk1jOXZsbi9ITDN4Y0U4aGdCdkVOUUR5?=
 =?utf-8?B?UGIzdUFUMFVkU0daaEdXNXR1Y0dxN001anJ1RVFQclRtUUNsbGt2Mk5LU1M1?=
 =?utf-8?B?OXVlNjZnMi9DOHBsUnZ6RlY3THE0T2l3a1dPeHB2NjAyUTU1ZDJOOERtaEwr?=
 =?utf-8?B?N3E1a0x4R0RUdW5zcUwvS0puQkFQaVBRV00xVTJqU3NPT2NlbmUrZnNKY0w4?=
 =?utf-8?B?bmhQcEZ4VUQxUVgxclNwUElDbG5nUldXUHpTYUxwQUlOMGVaNHVBeFIxYjc1?=
 =?utf-8?B?ZzVDSS9RK1RRRUl1QThMS0Nsc1YzYUNtSDdYYjI3MFA2WG16MVBzMHFZTlpj?=
 =?utf-8?B?UWNVRFdJd0VXS1cyQ2ZmVGFoSlJuTXBWcTBvZTk1bzIrQ212ZW14UDIxVEVP?=
 =?utf-8?B?c0ZiRmpmay80STNjUmFjM1I3ZTVHZVdWS1pKS1UvalJSVHFNMUQrM2EvMmVT?=
 =?utf-8?B?R2I3TU94TjRRaWlLajhxVUpoWVJHTEp6eGEwbnZ0M1FzcnF4c1kwRXBBQ25Y?=
 =?utf-8?B?V3d4WDZsZTJBa2JpVUNyYXJuVFVHL2llRzNEaWhTTjJkQytWVTErK0cyQ1BY?=
 =?utf-8?B?T25xbFVtWUUxTXFoeEtERWNPYVRzTGp4L1BmMmllRjNTRWtnYVE1NnpmeGZn?=
 =?utf-8?B?dWd0YUx6RTYvM3g2Qmgzc2xFT2ppR2tLN0hLRk5wQTBUTHNXcUhkcGdubFkv?=
 =?utf-8?B?Mkk4QzBlRXNlMGtwbkhKVUVsZXJaS1FVQ0VhQVkzWjVXMVY4blgyU1dGV2g0?=
 =?utf-8?B?Z2xMQWpLWUVKdDd4ZjFhcjFSR1Y1VW1lNXpmMVg2dE90MHVmMlM5Tnh3emlp?=
 =?utf-8?Q?0EZzsiz9VFpx1s/5KdjA33D7Vmp85gif2y6iOYHdwCW+?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F6C28370E553FB45B7AF9A01BBFED901@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb9b7af5-041a-4a63-f421-08d99e4134aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 20:41:54.2590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9X4foOl92f0EnDOZ3H0OTZ+RqSr81cZaNx1XayMCY2Bsk+pZHiKs3uqnsHG18onhuV+knlQEunzl3NP/PTkiCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3592
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTExLTAyIGF0IDExOjEwIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToK
PiBPbiBUdWUsIDIgTm92IDIwMjEgMTY6MDg6NTIgKzAwMDAgU2FlZWQgTWFoYW1lZWQgd3JvdGU6
Cj4gPiA+IAouLi4KCj4gPiAKPiA+IG1heWJlIHdlIG5lZWQgdG8gc2VwYXJhdGUgc3RhdHMgZnJv
bSBub24tc3RhdHMsIG9yIGRlZmluZQo+ID4gRVRIVE9PTF9BX1BBVVNFX1NUQVRfQ05UIHdoZXJl
IGl0IG5lZWRzIHRvIGJlIGRlZmluZWQuCj4gCj4gRmFpciBwb2ludCwgc29tZXRoaW5nIGxpa2Ug
dGhpcz8KPiAKCkxHVE0KCj4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2V0aHRvb2xfbmV0bGlu
ay5oCj4gQEAgLTQxMSwxMCArNDExLDE0IEBAIGVudW0gewo+IMKgwqDCoMKgwqDCoMKgIEVUSFRP
T0xfQV9QQVVTRV9TVEFUX1RYX0ZSQU1FUywKPiDCoMKgwqDCoMKgwqDCoCBFVEhUT09MX0FfUEFV
U0VfU1RBVF9SWF9GUkFNRVMsCj4gwqAKPiAtwqDCoMKgwqDCoMKgIC8qIGFkZCBuZXcgY29uc3Rh
bnRzIGFib3ZlIGhlcmUgKi8KPiArwqDCoMKgwqDCoMKgIC8qIGFkZCBuZXcgY29uc3RhbnRzIGFi
b3ZlIGhlcmUKPiArwqDCoMKgwqDCoMKgwqAgKiBhZGp1c3QgRVRIVE9PTF9QQVVTRV9TVEFUX0NO
VCBpZiBhZGRpbmcgbm9uLXN0YXRzIQo+ICvCoMKgwqDCoMKgwqDCoCAqLwo+IMKgwqDCoMKgwqDC
oMKgIF9fRVRIVE9PTF9BX1BBVVNFX1NUQVRfQ05ULAo+IMKgwqDCoMKgwqDCoMKgIEVUSFRPT0xf
QV9QQVVTRV9TVEFUX01BWCA9IChfX0VUSFRPT0xfQV9QQVVTRV9TVEFUX0NOVCAtIDEpCj4gwqB9
Owo+ICsjZGVmaW5lIEVUSFRPT0xfUEFVU0VfU1RBVF9DTlQgKF9fRVRIVE9PTF9BX1BBVVNFX1NU
QVRfQ05UIC0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEVUSFRPT0xfQV9QQVVT
RV9TVEFUX1RYX0ZSQU1FUykKPiDCoAo+IMKgLyogRUVFICovCj4gwqAKPiAKCg==
