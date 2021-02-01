Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D1830B1AC
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 21:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhBAUnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 15:43:40 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12903 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbhBAUni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 15:43:38 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601867d00001>; Mon, 01 Feb 2021 12:42:56 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 20:42:55 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 20:42:53 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 1 Feb 2021 20:42:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0FZ4iaNKrrVjh4zMApAZg7uBapca5Sm51gsYxxkIr6mZWsrSI9r+u+lRDncrv5q2u66DswUd9rY2BVrqJIhLndZWYWFq/Ua4ybynbsi8KLapahfpeuFfzjlxeTlLkSygvh7JUVwznzNk/F7ofhb1LwZ19yaktEOLlZrXAbbWeDkzJe5E7cc48Fj1mS/Luo8Kwk5v7Gn8f6sdDPUhDEb3czp9kANFBMAJIYnP8S5P1ng6UQb9adSAQr9kVo/ZORSWUdv++ttKXHJKNrJugPDDsvOm+G0DsRB/8VhbIc+H83CaFr8897evWjIVEj6iTbZr3vpHpLtGekLeFzuFvjHtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XITn6zlszAZxBcg+JwLuMFFh91YMVXUtpUlbruMJatg=;
 b=LQjdnXuZIbdAIdErx+Rl4Qcd90y04kHP6usDv7wP/E48X/ttZ3FoLAYRsk69vfgN4YP8bN/ufJ2n9e3qVMBrams7PFHuI+1IvGKuQms8cnfMn4BKNb4WLcTg5ImQ8soSr5o4MRmMTptaj9t5H3i7qYfxjhvXlCeEZ56UdkqfF7cxKMZ2fD+2z//obbxGGt1ufIINZ6zNd1NF6HzuhQEWP1Vh38XAIdox01DtW8LZ5QxuAskVnlx1pqNYDNZnRIAffpEJakS+oruhRJSF9RUkHEKdEybm21o7dCBt4YRu6h0ykIwJTaqBl+Oe+zlf+/guRqkUHhAEf5ZKE9DIYHJQEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3320.namprd12.prod.outlook.com (2603:10b6:a03:d7::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Mon, 1 Feb
 2021 20:42:48 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%3]) with mapi id 15.20.3805.026; Mon, 1 Feb 2021
 20:42:48 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH iproute2-next 3/5] devlink: Supporting add and delete of
 devlink port
Thread-Topic: [PATCH iproute2-next 3/5] devlink: Supporting add and delete of
 devlink port
Thread-Index: AQHW9l/LbCR+RXOe4Ee0p+RxmstF46pB/6MAgAHI7WA=
Date:   Mon, 1 Feb 2021 20:42:48 +0000
Message-ID: <BY5PR12MB432293F4F99B09F370085925DCB69@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210129165608.134965-1-parav@nvidia.com>
 <20210129165608.134965-4-parav@nvidia.com>
 <81d8561c-a9a2-f61f-6e84-414779147e60@gmail.com>
In-Reply-To: <81d8561c-a9a2-f61f-6e84-414779147e60@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89273147-0779-4c7a-bf15-08d8c6f1efd2
x-ms-traffictypediagnostic: BYAPR12MB3320:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3320B3CB748C69F51B863AF9DCB69@BYAPR12MB3320.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gEciz/j++IJji/EzlUQj2l5GJJa6basXslWoriycpk5nXadUIr5uZ86BgRecECAVDhjfT06+qDkCyfNyaXB5FCjOVNOGErNVdQzTvIx/E5KktU8qPy/7deHhhlnD80CIoCYjEgdblMCfnozwCyIk6aiPI/PUe4rVItw9PxmJiNrtti9+zv/kku5GTRIR5OjZ9MRS+coV/mPVFfIG+ou5aP9kw9X9FVkcqxKnK0GPlJ162dNTTt4HaNry1AufBMQGVTFLWNB4ob/uc9FgXbBXgWrv7K2f7S+kF/6xR+4I7TaJOnQW0bRSMhQ5z+gh/dju9JP/3xG3drqXoLT7lEN6qymXPrDqEaXLBF6hAe65lfTkzvTAodcwdbgAIKlTzx4x0EW/JiReGuhJb5hbHuXm8kJ3jMhQykZVYhPzu2wz2B/EqXdAdPyrDFe9jiMqUcrL7GH/Z4ws9Zk44shlpA5MOUrzIKZvbROsxUYyEKBbwtVVWMYLPGZWvCWTar9vVY8daSbFrRvmMOX7UEW20uV7mw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(83380400001)(86362001)(7696005)(110136005)(5660300002)(4326008)(2906002)(8676002)(66446008)(64756008)(66556008)(66476007)(71200400001)(316002)(33656002)(107886003)(76116006)(66946007)(52536014)(186003)(26005)(55016002)(478600001)(8936002)(9686003)(6506007)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TWQwb1ExK1NxQTBNbmJnOVVVd1dvTHFDMzV6dklleVFzc0M2aHYydzlUVS9L?=
 =?utf-8?B?Tjc2emNvTzZURVJkSnVwbmIrdU5GcUNSelFTSmRaVERORloxK2lyN1FwNmhP?=
 =?utf-8?B?eXZMamN1MEN1dHc0MDFFRTdkbzZKV0lKaDFvZzE0MWwza3lRYlcyeUZERE16?=
 =?utf-8?B?blhXbmU4cTBoSmhjWXhMSnBaaFJ4UjliQm1jT1Y5a05SMkNoZTRUMkw0TEtI?=
 =?utf-8?B?bDhEeGpxeGhqUm1YQzNBRFNlK3dEMEVkUVZxejJBSnorY2dhMmtsdVVYQ0E1?=
 =?utf-8?B?dUo0TFVQSmM5NHNQSktQNEJZSW0xditKZEsxUEVqVlZUYXhWVDV1WVRucGRq?=
 =?utf-8?B?bVpTZXppZm95VngwQlJuVWpHelFxblBiZ25qbVlkMXVLUk1scFdiSW9YblQ4?=
 =?utf-8?B?QjJzYVJPeGRtMWludExzQm9FOHhXV3VBUTVoZjNuVnJINGNzeEo5b0ZCeWMz?=
 =?utf-8?B?L3VoWk9JdStlYWxzQjd2b21wQjlzYkZaaThDdGNiRlhReitNcXROL0JtQ253?=
 =?utf-8?B?MGRtNnlCSnd6djlURHp3b0NGQUxnd2tXdjhOZHBjSXkwOElyVlF1cVd5RUpm?=
 =?utf-8?B?ajk4TkkxZDFabkh4aytRakJvU2hIN3RiYnFtQ2FUVEZ3ZXBIRnJDcDJSQWNx?=
 =?utf-8?B?VDg0SW9jSXEwWElJRXFWY21ZMm41TnBuWEUxdmRWOEMwQjdjK1RxRnBmWUM1?=
 =?utf-8?B?OFlKZ09oL2syb0VYNlkrS0RpcFFialRuT2dTNll1Y3RMWTM1Ry9YTU5sajZq?=
 =?utf-8?B?cGl2ZDArU2p6VkN0Q3FXUFRSVG1HWDg1aVB2dU5SS3BaaDIzVzVOK2YrTmwz?=
 =?utf-8?B?cmU0M3V2L0ZYMXVyVW1wN1FMQ1llU3BNVk9mYnhqWjVZL1NZeVY5NTdMZUVS?=
 =?utf-8?B?KzZiMmlaSXZDTlFVKytxcDArUkZGZ2pqZy9FTHI3YkNNTGR6eElvdGRWREVJ?=
 =?utf-8?B?RkRQcWdhR0wvOTFOcHpHNlF5bHBVNEZ1d2Yvc0Q4dEJZalhzT1YyMUM3YXpl?=
 =?utf-8?B?VTBLMG9KMkZaQ0ZlN2dhOFhwV0FrMHFVSkg4Rkx6YXF4cFJ3UmY3c2tGT0VT?=
 =?utf-8?B?RWIxRUxSUVo3UGx6QUtQQlBwT3grL0R3TnJ1cnUycStWMm1sckY5NDJWOUFu?=
 =?utf-8?B?QjdjNXZDbDc3eE5wRXJCMWp4NEQ1dmhGZklLYkhKbC80OXRZTGM2ZTh5R2hP?=
 =?utf-8?B?ejBCMjNCSy9wSXUzQTE4SnlrV0I2QVRxVGVpcDJFUlpwNXkwejlXcnVuSGZZ?=
 =?utf-8?B?WDdDbTJidmhYVUpaTHRNaUhIZW9UbnNyNXhHRjFEZ0sxLytKQUdta2Q1WGVG?=
 =?utf-8?B?N2dtQXZFQVZPakVvdU5YOWpKU0lsdVZodTl0eksxRW1NMjRKZWdPVzFkNXJZ?=
 =?utf-8?B?ZUFNNm8wb3Q4czU3b0M2TzNQK0srY2hZRzlNcXE2aXU1UjNraUJ6azBQYTJk?=
 =?utf-8?Q?OKI2Mr2P?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89273147-0779-4c7a-bf15-08d8c6f1efd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 20:42:48.4983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cno254FRWtD3lkMmlo2FFi2aqTP0tT+tsCeDn+kbccko9IF+Z/xLCUBwPh0LoapbeOMpFV8zxPZ6HZWTcdtADA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3320
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612212176; bh=XITn6zlszAZxBcg+JwLuMFFh91YMVXUtpUlbruMJatg=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-header:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=OLpK+mTOI2Fxj4kRoD/vHttYdp3o8NGzkaCXbBjgjRvzyOyhTXMQi+9E08SQkVvEo
         grWRC3VoDmFmY0ZpqJ1WWVu5ZYZLsNcRfcGFiC93xHWKVl3ljQdCyLbHm9LcJfkQJl
         /DJXVs+v6VxvFpMByHadrwx8gmvpuOC2p49rQmKhKNIqToKBmXHkQ+izxBDrT+JRM4
         H9hNBjPV1WDMAOlZjlbb1g0eOCwvWnyRTRm77B6PFXr+AROZNp63Sp8DY40OuRq5qq
         lDD8YAfSt3nWjR/3ZlqM6Kfs6XN8+MnsAcKl+MEETKtBZn1MIcwxhvKGY27LMVgKXn
         LLO/KTwHznvHQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBTdW5k
YXksIEphbnVhcnkgMzEsIDIwMjEgMTA6NTYgUE0NCj4gDQo+IE9uIDEvMjkvMjEgOTo1NiBBTSwg
UGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+IEBAIC0xMzgzLDYgKzEzODksMzcgQEAgc3RhdGljIGlu
dCByZWxvYWRfbGltaXRfZ2V0KHN0cnVjdCBkbCAqZGwsIGNvbnN0DQo+IGNoYXIgKmxpbWl0c3Ry
LA0KPiA+ICAJcmV0dXJuIDA7DQo+ID4gIH0NCj4gPg0KPiA+ICtzdGF0aWMgaW50IHBvcnRfZmxh
dm91cl9wYXJzZShjb25zdCBjaGFyICpmbGF2b3VyLCB1aW50MTZfdCAqdmFsdWUpIHsNCj4gPiAr
CWlmICghZmxhdm91cikNCj4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiArDQo+ID4gKwlpZiAo
c3RyY21wKGZsYXZvdXIsICJwaHlzaWNhbCIpID09IDApIHsNCj4gPiArCQkqdmFsdWUgPSBERVZM
SU5LX1BPUlRfRkxBVk9VUl9QSFlTSUNBTDsNCj4gPiArCQlyZXR1cm4gMDsNCj4gPiArCX0gZWxz
ZSBpZiAoc3RyY21wKGZsYXZvdXIsICJjcHUiKSA9PSAwKSB7DQo+ID4gKwkJKnZhbHVlID0gREVW
TElOS19QT1JUX0ZMQVZPVVJfQ1BVOw0KPiA+ICsJCXJldHVybiAwOw0KPiA+ICsJfSBlbHNlIGlm
IChzdHJjbXAoZmxhdm91ciwgImRzYSIpID09IDApIHsNCj4gPiArCQkqdmFsdWUgPSBERVZMSU5L
X1BPUlRfRkxBVk9VUl9EU0E7DQo+ID4gKwkJcmV0dXJuIDA7DQo+ID4gKwl9IGVsc2UgaWYgKHN0
cmNtcChmbGF2b3VyLCAicGNpcGYiKSA9PSAwKSB7DQo+ID4gKwkJKnZhbHVlID0gREVWTElOS19Q
T1JUX0ZMQVZPVVJfUENJX1BGOw0KPiA+ICsJCXJldHVybiAwOw0KPiA+ICsJfSBlbHNlIGlmIChz
dHJjbXAoZmxhdm91ciwgInBjaXZmIikgPT0gMCkgew0KPiA+ICsJCSp2YWx1ZSA9IERFVkxJTktf
UE9SVF9GTEFWT1VSX1BDSV9WRjsNCj4gPiArCQlyZXR1cm4gMDsNCj4gPiArCX0gZWxzZSBpZiAo
c3RyY21wKGZsYXZvdXIsICJwY2lzZiIpID09IDApIHsNCj4gPiArCQkqdmFsdWUgPSBERVZMSU5L
X1BPUlRfRkxBVk9VUl9QQ0lfU0Y7DQo+ID4gKwkJcmV0dXJuIDA7DQo+ID4gKwl9IGVsc2UgaWYg
KHN0cmNtcChmbGF2b3VyLCAidmlydHVhbCIpID09IDApIHsNCj4gPiArCQkqdmFsdWUgPSBERVZM
SU5LX1BPUlRfRkxBVk9VUl9WSVJUVUFMOw0KPiA+ICsJCXJldHVybiAwOw0KPiA+ICsJfSBlbHNl
IHsNCj4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiArCX0NCj4gPiArfQ0KPiB1c2UgYSBzdHJ1
Y3QgZm9yIHRoZSBzdHJpbmcgLSB2YWx1ZSBjb252ZXJzaW9uczsgdGhhdCBzaG91bGQgaGF2ZSBi
ZWVuIGRvbmUNCj4gZm9yIHBvcnRfZmxhdm91cl9uYW1lIHNvIGl0IGNhbiBiZSByZWZhY3RvcmVk
IHRvIHVzZSB0aGF0IGtpbmQgb2YNCj4gcmVsYXRpb25zaGlwLiBUaGlzIGZ1bmN0aW9uIGlzIGp1
c3QgdGhlIGludmVyc2Ugb2YgaXQuDQpZZXAuIERvaW5nIGl0IGluIHYyLiBBZGRlZCB1dGlscyBy
b3V0aW5lIGZvciBpdC4NCkZldyBtb3JlIGZ1bmN0aW9ucyB3aWxsIGJlbmVmaXQgZnJvbSB0aGlz
IGhlbHBlciByb3V0aW5lIHBvc3QgdGhpcyBzZXJpZXMuDQo=
