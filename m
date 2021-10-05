Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B77422159
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbhJEI4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:56:30 -0400
Received: from mail-eopbgr80094.outbound.protection.outlook.com ([40.107.8.94]:46791
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232971AbhJEI42 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 04:56:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIsRpmJJVF0+h0ajSufpI55eTOIhLQ+Z9e2/pOLsjg5zHzljI6ScQY1Zsy4l+UcjCaHJF754Q0K5wAelatIMXqx6AR4tSqJgRAN7zT6Ou5Rs+BqF7QOc4SjaalV6DTsQe0OLC5alTQnYP3C52mwPnEQgzWRhMXPfywvSETZlY6lGVek6IXFFSH9SGEGT+FhxLAW7Xj4jeLVjgB8Fn0A3QQ+riHvf8HRu1lwEsW/IsDxTvCDD7b6/WjUr2HrGU7+F+RboixuwTvVfc5gSRsocoFucQw9CEiWdAXzYPKiQUvb+WT9ViAcs0v+AZ671MUa0P5k3iu3CuCRyju8jsIDBCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2lEvAi+ol3K5vlG4fJ9dwAB1Yj1pxzEOzN+DH/QR3yE=;
 b=L4YHL7LJUJp5QUvmkMTwtK5wwzrPZWCLDWJpcd0nmvpCEz0/2wrKhhBhzIr/m3nQtVDBA+izdop7SG/fw20DWijdezeM0jKNuEKPE4Z/JMgCJvwOpeaGmtbeZ8vte7COehMM4RL0xHpf9gIbNxKPcyQ4tE9X8ZUtNjVpuYBBvAFl9k+RX5cbiNJmebvJW3dRdAfbZWvHoDwiOi9iV6wq7r5IbLYsSnY53g3R2yTFjeeFLr68ScwbB585utAjJLXCPwl+qh71s6q9GBnHoWiekMNWZydEy89ZKesOdYoYx9Rvmu1vGBjIk6IOfQ5G5ZEKFGPvekdFafVHz/APuIvGkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2lEvAi+ol3K5vlG4fJ9dwAB1Yj1pxzEOzN+DH/QR3yE=;
 b=iSY7b6dCD/+wIS3dU/wVNzKuhw6xBNfeWkfZc6T3lNYkEUb+yICNanzU0/1QVS0dFTQLxS1EtmP8jkZl+mAJjIQS7wjJvu9MMXzSCIit/C2r8tgBnzuoJSRtzny60Ii9fLfX5PjgEJ5dGOpqBfawCPtPMi1a0hWN2xuCEPslOlU=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0302MB2668.eurprd03.prod.outlook.com (2603:10a6:3:f1::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.22; Tue, 5 Oct 2021 08:54:34 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56%5]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 08:54:34 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: DSA: some questions regarding TX forwarding offload
Thread-Topic: DSA: some questions regarding TX forwarding offload
Thread-Index: AQHXucaemV05T+14+0C6ajjHlibfJQ==
Date:   Tue, 5 Oct 2021 08:54:34 +0000
Message-ID: <04d700b6-a4f7-b108-e711-d400ef01cc2e@bang-olufsen.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56760f76-76d7-4300-ddb2-08d987ddc11d
x-ms-traffictypediagnostic: HE1PR0302MB2668:
x-microsoft-antispam-prvs: <HE1PR0302MB26682E25C9B99D2A5E7EF1A283AF9@HE1PR0302MB2668.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ycaquy36rs+xGNYQGrghllMXU33+2TcvLa7fDylPmeSGtR8J/11V60DdlR0GIj2kX06QjB1twWXIqmrjjj1MbiJvlbMExcDLvaL8wWIhprA+Ku3yFw9r1o6QL0gznlAoCeWCR2mKDSAZVSySsw6p33+pealRXyaZvVmE9AMHcxZxF5uoI2/rzTYVjADPbJ0v9kC2IKman3WwLukl+Knbhz9k14xpF6wSmksYTg5lcMRPxi00ueEVpQnH4VsahB2ZgW6KRMqY6hVulvwgvDf6isKn8HiqTxaDr5uFb7IlJ3Ty2PX63JG6Nolfhz/6ZftNUELmnv+VXhJ+rjCkDC5EdsWnT+Wj+PHWMD1JF+DDfWdDS/t+SYKILbRTQnscCW0GsCGpe8w8QyqTmT/L7s/eMHsNTPzqOVYzNdbW2//lSSD2NneayAA9ZArM0yE7UJGC8SMmRhEoOWOEJYRYUSTaYpLe6Fenwsz0F7EoDSGmlswvc+XUpkC2qYNg8lQT+SRbRA14LdYKqzVYj0q39psBiM48c/3qsl+ozFvQ3Zs8LWetZLT0UUrV5hD3pkxfiYTecQJCz07bq0QX6roDx36FJYu4QJiqhiE5AGJ1xfmtzjCZRAWOqRMu7PGvWEVBXUCHfUZjpg0zoI1Q2H0nq309LtVx/mLK+czz85Z47051pQEqVNBVngXis8szs69B+peoKiJ9ipG/45hCpMvQuT0azEFepjjAlTkrxTNUYCxpzVq0CLI0F420ZHRo54qVac0ZdGAarhTtzTRSTfQ4jB6jJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(316002)(31686004)(6486002)(8936002)(66476007)(8676002)(66556008)(71200400001)(85182001)(76116006)(66946007)(86362001)(36756003)(4326008)(5660300002)(66446008)(64756008)(508600001)(186003)(8976002)(2616005)(2906002)(83380400001)(26005)(6512007)(6916009)(6506007)(54906003)(85202003)(38070700005)(38100700002)(122000001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXNWczFCS2dSR0ZUWHFodGxkaWgzeStTckhIb3poUU1WOGVWdHpNbWs0YTRq?=
 =?utf-8?B?SkNqUGRHcllFQzlMdTJVQmdGZGthb0N4KzZEWCt3NGVBaVJXaGZ4MlE2TVdS?=
 =?utf-8?B?Ylp4dW14a0VsS1RhM0Vtc2lZVDdxNzRkVzN6cUo4Vk5RV3hzaGFPMGFCcFpP?=
 =?utf-8?B?V2VLajZUZFhUZDl5dFd1Q0hISTJYaVZZVHdRdmJUdnR5RENwU0taRzVOWGJY?=
 =?utf-8?B?V2k2NVA2OU5mcU9KTWhUSmpSNElIck5yL3pJRWRCdWFLc2xOandhbS9jRWF1?=
 =?utf-8?B?dzh4d0JSVGFzYzI3cDA1UzF6enFQd0RGallHWEpLbTZNQndveDFPcE51Si9M?=
 =?utf-8?B?LzNTWTlkd0pxczBxZGZPdTFMVXd6REg3MGNLNStyRjdVT2Urb2F2N09JL1oz?=
 =?utf-8?B?YUxuL0JHVG5aRHM3ZFdoVW9kdW53QjNMelBQemM4Y2lYL2t5b25WeGZxQ3l6?=
 =?utf-8?B?S2VSSlNWcXloTTZzUEhqTXBBem5xK0NSRmlsU1hZZngzZG5QT0FqTkpIOW1Y?=
 =?utf-8?B?a3BIQ0tVNlNLZDhwaTNoMUl1d3VmanJtWHJXcUsyZVpyMlVERCtWaTVHQkhQ?=
 =?utf-8?B?VlhpOC9CSjhGS094U3ZRamY1UnhXUzYxb3AvVW1oWHlBSG5CZjBvVnc0OTNn?=
 =?utf-8?B?aXVMM0dvcDF0ZGdUMkU4OC82Uno1ZWxLcEFSczJodTZINmsrTWNFWHJTQnp2?=
 =?utf-8?B?RWs5d1pQS0tlajc5RC9XQ2R3RUlzR1g5M0VIZHhSamFPVkxmS3psdHJOQndm?=
 =?utf-8?B?VENNVGpYZ0Q2OERSOGFpMlVhTFNtNjU0dVZuOFRWbGxXL1JyRWNRR21Nd29i?=
 =?utf-8?B?NzM0OVZzdUt1L01RR25EL1BkN1Y0amh3S3o5WUgycVUrNkV3ODVuK0ExWjVU?=
 =?utf-8?B?cEU5TE5IVUI3bGhlNzk3b2RVT2RxRnY0eDhhVE9kTkdNbTJSZnR6OFFUQ0JL?=
 =?utf-8?B?cGtlWm1icko4N0VicWlnY2dYMUlvODdDellRWVhhdFQwckpDRzYySnlrSmR0?=
 =?utf-8?B?endrRlh4M2VvSWVhalZkS2tGMy9KejRxY0E2S25QMDRPekRpZWlmQUxBZnQr?=
 =?utf-8?B?WVU4Mjh5RjJIQlBFalhuZFZiMERwdWN6QVlPeXE1ay9pVHorV3lNc2lqRGhn?=
 =?utf-8?B?Nk0raFBhRGFSV3JlbWk4UlIxTTlQcCtIU0VLZFVlZ3BLU0U4UVBSZmYycDVG?=
 =?utf-8?B?L0FabUh6Z0hLRHBoZmxXeWY0ZlNCSTdmNXAzanFiVHY3VHl3UXlNTVBZS01s?=
 =?utf-8?B?OGRUVnAyT0pLTEh4cFRLa0hwakN3cVFSajdGOEo1a08rTjdYdktsTEtlYkh4?=
 =?utf-8?B?OTJ4d1hiUjRXVzRVUzgyQzZZYndvdG9RdWRUTGp6TzJNNDA5bmhnbndSMVFz?=
 =?utf-8?B?b2IwYis3WVltNFc2RDBPQUZuUTd3SlNRUG12RDRFdU5oTWJvbEUvL2krbDRx?=
 =?utf-8?B?ems1ay9oVGxYR1I5YmVZenBiWGo2S09zWGZ4UnBLTS9KRFZRYU00R3RWZUgy?=
 =?utf-8?B?eUQ5cnN2UmxZbnJ1ODRZNmovRlFPVVp6OGVWUTFSQ3R6dHBhdGdhbEZKeHh6?=
 =?utf-8?B?cmRYUFF2UTJKZWMycUVOUDZYZWNRblh1b3ZqT2ZqbVA2ZjBRd2JabVNUbnA1?=
 =?utf-8?B?RWdwSlBnd2xZaW83b2JEZEFrelNpVEN3Z2hhMmo0enpxT1JUdHJCVUtkNmlv?=
 =?utf-8?B?UysyWEJSRkVyQXhrWWFWcWJNOWErYVBJK3pkMXZvSjAwNU95amw5RXRaM2c4?=
 =?utf-8?Q?wTYSvyoT061JRlOTJdPDmdUv1Kq8gc9M+6sRm44?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E0085E273C86774CB0258C9265ECD0C4@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56760f76-76d7-4300-ddb2-08d987ddc11d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2021 08:54:34.5888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hk03OI8DL7ONi4yAABftVa4+FPKC/S/HoMo68MXgOaIhNSHqJLpzmB32bbslzpzLKT6rvXYWgk6hV4SEW20yLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0302MB2668
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCkkgYW0gdHJ5aW5nIHRvIGltcGxlbWVudCBUWCBmb3J3YXJkaW5nIG9mZmxvYWQgZm9y
IG15IGluLXByb2dyZXNzIA0KcnRsODM2NW1iIERTQSBkcml2ZXIuIEkgaGF2ZSBzb21lIHF1ZXN0
aW9ucyB3aGljaCBJIGNvdWxkIHVzZSBzb21lIA0KY2xhcmlmaWNhdGlvbiBvbi4gVGhleSBtaWdo
dCBiZSBzcGVjaWZpYyB0byBteSBoYXJkd2FyZSwgd2hpY2ggaXMgYWxzbyANCk9LLCBidXQgdGhl
biBzb21lIGFkdmljZSBvbiBob3cgdG8gcHJvY2VlZCB3b3VsZCBiZSBoZWxwZnVsLg0KDQpRMS4g
Q2FuIHRoZSB0YWdnaW5nIGRyaXZlciBzb21laG93IHJldHJpZXZlIGEgcG9ydCBtYXNrIGZyb20g
dGhlIERTQSANCnN3aXRjaCBkcml2ZXIgaW4gb3JkZXIgdG8gYXNzZW1ibGUgdGhlIENQVS0+c3dp
dGNoIHRhZyBvbiB4bWl0PyBJcyB0aGVyZSANCnNvbWUgaW5mcmFzdHJ1Y3R1cmUgaW4gcGxhY2Ug
dG8gc2hhcmUgc3VjaCBkYXRhIGJldHdlZW4gdGhlIHR3byBkcml2ZXJzPw0KDQpRMi4gSXMgaXQg
ZXhwZWN0ZWQgYnkgRFNBIHRoYXQgdHdvIGlzb2xhdGVkIHBvcnRzIChlLmcuIHR3byBwb3J0cyAN
CmJlbG9uZ2luZyB0byB0d28gc2VwYXJhdGUgYnJpZGdlcykgY2FuIGJlIG1lbWJlcnMgb2YgdGhl
IHNhbWUgVkxBTiANCndpdGhvdXQgaXNzdWU/DQoNCkJhY2tncm91bmQ6IFRoZSBSVEw4MzY1TUIn
cyBDUFUgdGFnIGluY2x1ZGVzIGFuIEFMTE9XIGZpZWxkIGZvbGxvd2VkIGJ5IA0KYSAicG9ydCBt
YXNrIiBmaWVsZC4gSWYgQUxMT1c9MSB0aGVuIC0gYmFzZWQgb24gdGhlIFZMQU4gdGFnIGluIHRo
ZSANCmZyYW1lIGFuZCB0aGUgcG9ydCBtYXNrIC0gdGhlIHN3aXRjaCB3aWxsIGF1dG9tYXRpY2Fs
bHkgcmVwbGljYXRlIHRoZSANCmZyYW1lIGFuZCBlZ3Jlc3MgaXQgb24gYWxsIHN1aXRhYmxlIHBv
cnRzLCBidXQgb25seSBwb3J0cyB3aGljaCBhcmUgaW4gDQp0aGUgcG9ydCBtYXNrLg0KDQpJZiBB
TExPVz0xLCBhbmQgaWYgdGhlIHBvcnQgbWFzayBpcyBhbGwgemVyb2VzIG9yIGFsbCBvbmVzLCB0
aGVuIHRoZSANCnN3aXRjaCB3aWxsIG1ha2UgaXRzIGZvcndhcmRpbmcgZGVjaXNpb24gYmFzZWQg
b25seSBvbiB0aGUgVkxBTiB0YWcgaW4gDQp0aGUgZnJhbWUgKGlmIGFueSkuIE5vdyBjb25zaWRl
ciBhIGNvbmZpZ3VyYXRpb24gYXMgZm9sbG93czoNCg0KICAgICAgICAgYnIwICAgICAgICAgICAg
YnIxDQogICAgICAgICAgKyAgICAgICAgICAgICAgKw0KICAgICAgICAgIHwgICAgICAgICAgICAg
IHwNCiAgICAgICstLS0rLS0tKyAgICAgICstLS0rLS0tKw0KICAgICAgfCAgICAgICB8ICAgICAg
fCAgICAgICB8DQogICAgIHN3cDAgICAgc3dwMSAgIHN3cDIgICAgc3dwMw0KDQouLi4gd2l0aCBi
b3RoIGJyaWRnZXMgY29udGFpbmluZyBzd2l0Y2ggcG9ydChzKSBiZWxvbmdpbmcgdG8gdGhlIHNh
bWUgDQpWTEFOIG4uIEhvdyBzaG91bGQgSSBwcmV2ZW50IC0gd2l0aCBUWCBmb3J3YXJkaW5nIG9m
ZmxvYWQgLSBhIHBhY2tldCANCndpdGggVklEPW4gZnJvbSBiZWluZyBlZ3Jlc3NlZCBvbiBhIHBv
cnQgb24gdGhlIG9wcG9zaXRlIGJyaWRnZSB3aGljaCANCmJlbG9uZ3MgdG8gdGhlIHNhbWUgVkxB
TiBuPw0KDQpJbiB0aGUgYWJvdmUgc2NlbmFyaW8sIGVpdGhlciBJIG11c3QgcmVmaW5lIHRoZSBD
UFUgdGFnICJwb3J0IG1hc2siIA0KKGhlbmNlIFExKSwgb3IgSSBtdXN0IHJlc3RyaWN0IHRoZSBo
YXJkd2FyZSBjb25maWd1cmF0aW9uIGluIHNvbWUgd2F5IA0KKGhlbmNlIFEyKSwgb3IgSSBtdXN0
IGNvbmNsdWRlIHRoYXQgVFggZm9yd2FyZGluZyBvZmZsb2FkIGlzIG5vdCANCnBvc3NpYmxlIHdp
dGggdGhlc2UgY29uc3RyYWludHMsIG9yIHRoZXJlIGlzIHNvbWUgYWx0ZXJuYXRpdmUgc29sdXRp
b24gDQpvciBudWFuY2UgdGhhdCBJIGhhdmUgbm90IHRob3VnaHQgb2YuDQoNClRoYW5rIHlvdSBp
biBhZHZhbmNlLA0KDQoJQWx2aW4=
