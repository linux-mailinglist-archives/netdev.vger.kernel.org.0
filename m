Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330613A45AD
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 17:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbhFKPpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 11:45:39 -0400
Received: from mail-co1nam11on2073.outbound.protection.outlook.com ([40.107.220.73]:18497
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230409AbhFKPph (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 11:45:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bWo4iiCJdg55DPoWNlzaE0QG8Q1FXN/4b8WqTlIMlsK/z8uz8cqrjTo7/xn2PoolN/V6azc9Pu55HN57yXOLVoBqq83Q6esdpkN6vbR3wUxW31AzQONaC+NE+S1dlSuxXxOysrg5/BEDjVXUjvRJJtzGxNwmQZSDwEdnbFPsQmN/DXM7XIpkKX23rihqeRGs2uLvT9rYRDEpF5PsoDF4UW8hftdNYM9RtLaLwOWsVQtltNfgftH4FFAoJ11MROgIYnQAeMIKuVr+YrJ6QCzJ+HtOC6uVuU0Q5COz3/cJJriUlLnLVwFbDPmSHAj1jE63Yclo2sP2AgWCN5m5+N4Xow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQV73RKxtdv0HKVlUB+9jUsOc5uKb3emqeO1noTZWVI=;
 b=ivf3FOFbY7l1fUFVg6mUGFknSAhvqQWTGzy6GBwZ/ZAuqRAEmYSQGH83Nyp0xCaqCctc2kHSK+JBrpWAFtucezoKUhN01B7A5+Zr85KjVh7A1rFgTGxbFPOuret1SdfYruFTAfbaRK9V+DO7Si/Xt1TuT0zdWTRCIrTJ8pjxSH4QbEVYePYXJdYkvFd+5G2M7qv3uqF+E/GJuR/B/9lfniYkK7OS/QxDveq8vyILFSgLg7YZMa5LUcVw/HM8na+y7CWffW94QKPa9aPzpecjRki6RGuWPxlX5fqwAletGEiG+AOS/cr42+mIEb7sfVP6sLE//FBafoSZKaOkNC9FAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQV73RKxtdv0HKVlUB+9jUsOc5uKb3emqeO1noTZWVI=;
 b=KbrTyX4GDJBqypKySZVe4xWxL7rDOp8H0iY/M6BkRCkVBmP1Pf1f4I3B/BrGLH7ySGwXDbqo1mrHW09K61iPGwyIhflewAB2u6FDQPmV1ZXFqMhxtUrCdMF4gLTD/vrWh7hIhFQcK8MH4Y/cIihGy/KVijlUCvevZms2JH+iY16hkf2jouQ6wEfnAKcPRAgkp7/MGikHIxBQKlNnSR+BdY57Q6C5PQD0s12lNpJfOL7clsn7dYWtZl0OzFI7qKYgE9TgnTwG7o+MK0V18vsb/srHlLE+Jwaxb+nxjsd01lnGqD6sb5WEqUGdiY/MOAQ+AMztkkjjImRiV77XUQkrbw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5401.namprd12.prod.outlook.com (2603:10b6:510:d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Fri, 11 Jun
 2021 15:43:37 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdf9:42eb:ed3b:1cdb]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdf9:42eb:ed3b:1cdb%7]) with mapi id 15.20.4219.023; Fri, 11 Jun 2021
 15:43:37 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Loic Poulain <loic.poulain@linaro.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
Subject: RE: [PATCH net-next v2 2/3] rtnetlink: add
 IFLA_PARENT_[DEV|DEV_BUS]_NAME
Thread-Topic: [PATCH net-next v2 2/3] rtnetlink: add
 IFLA_PARENT_[DEV|DEV_BUS]_NAME
Thread-Index: AQHXXh74CfJ1JCE4JUaG6m7m5f+1aasOw8rwgAAm5gCAAAkqsA==
Date:   Fri, 11 Jun 2021 15:43:37 +0000
Message-ID: <PH0PR12MB5481A6766A62FD1EE29C95D2DC349@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <1623347089-28788-1-git-send-email-loic.poulain@linaro.org>
 <1623347089-28788-2-git-send-email-loic.poulain@linaro.org>
 <PH0PR12MB5481986BF646806E23909CD7DC349@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CAMZdPi_tv_MDFbSAx-hKTBsoi9=u7hQxcWNBcer5LQ+J37zgdw@mail.gmail.com>
In-Reply-To: <CAMZdPi_tv_MDFbSAx-hKTBsoi9=u7hQxcWNBcer5LQ+J37zgdw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.202.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb92dad9-9e85-4d56-5dc8-08d92cefadc2
x-ms-traffictypediagnostic: PH0PR12MB5401:
x-microsoft-antispam-prvs: <PH0PR12MB5401B17F3A076BFBC97F2A9CDC349@PH0PR12MB5401.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lXDR7jUHpNUjlzyNm2ts6EIhDU8tGhP1ATmTzPqOYLRjdf8kvsd0lXeh6sppFdCRT+R6+WXjElkeEjcJZ2X0cQIIBsEAIAaHbkjsZL6sT4E3b8VrJM2gbSJ1ibAvB7ZEYBnKMx8Ulj0EhJZSR7FXIzTN7LQx7z6MZ7vCPYxhY1bTxbZ2wIClzbnr/f7CvTuTKTYnFTXoXAP4EDURx9B2J3eeZT9cJWiO9yoThtCl5R7BnIsT+Eukp2xOWyY0PLP3IbYeRWZqaiviuQ62LKX8J5qPMRV8tQX186xKt1qwv0g3dejK0do8Z9eWbnmHcwJoWRd+DGnjRxa+EozIT7sGOIjwmRdifnVVL0FbGhKT66S9YH4iTfzJmtSIRTcGx2g4hiAooEDk8KKpl9KSGHe4q3FKbjfZrMtRCqzAxxYbKS5qgqX/qi5ZHAG1n4Mwn8wBCSuPXUCbO9t51MY1Nc3BVQANqqzERI22iJYMO3Fh1EjRLUPYlpOmnmpYBDWH9Oz+/id8QEXvtqea7VxIOjgtR+4FDRIbBWKuDNsGUP1P6PRqvXAa6EnZHDIz7R2SzSD4JNKspuBribhBo/wzhGonFj+U/xaXecnGYVVCLOyvdB4CKCqIGDXhx4sDbJtEg6SeatG338OMhYUI6IdOsx+Vcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(478600001)(66556008)(8676002)(71200400001)(66946007)(122000001)(38100700002)(6916009)(316002)(8936002)(6506007)(55236004)(5660300002)(7696005)(52536014)(33656002)(83380400001)(66476007)(4326008)(186003)(64756008)(55016002)(66446008)(9686003)(76116006)(54906003)(26005)(86362001)(2906002)(83133001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZTJhYzhBQm5WU1ZGVVBHT0pjU2FaVFI0dVdyaXg3KzN6dVlScGdNTHJKZGhD?=
 =?utf-8?B?S25Fdk90dnp0UkJSYzNnenJ4K00xSjJ5N2hxaENDTWNjSUZkY2t2cWxmaXZS?=
 =?utf-8?B?YXRxWlM2aGIrY2pmeGJGSG55Q2FvbUZ5eXpsem5qU3RiMWE1L3VsTCtGb01x?=
 =?utf-8?B?dncwVURaZ2Mxc05MeWRKVVNGTWhHYjRteXp4RlNsVFlOZGluL2dXTFVMeUhH?=
 =?utf-8?B?UEZJYjd6TEhEN3pCNWZHeWkvSllwWEdFVzRlUEd4SDhwTys3c201RVB6d2ha?=
 =?utf-8?B?UExjUGx0UWdKamtQeDNEU1NtRzFoM2xjVVNWWUxyZ00zMnZhUkFCVGNrbWp5?=
 =?utf-8?B?OFV2WHR4Q09zWlpISWtYMW9wOHI4V1F4eDZvNEMzeU9hWEc1Y2FpZkRIOWU4?=
 =?utf-8?B?bm1ybHE2R3Y2alREMnFHV0hsQll1K2xwcnRMeDFIMC9iWXk4VzZYUTcxekZy?=
 =?utf-8?B?M05wRGtRTG9BbFlWa0s3TVhZVTFVMkU0b3NpNTIzNExFemhuc0RvU2h5a2pw?=
 =?utf-8?B?UFI0SmJjR09pR1p3RzBmQVVWbDRwaEhPa1h1MVpjR1BBQW8xRmhxenhocEpH?=
 =?utf-8?B?TlJaYWFpU3RqU0ZqeEZYWWE1NExBck5jNS82dy9WNlVwZUw3eFB1M1ZCRW91?=
 =?utf-8?B?VEtWNHJmR1RiM2dHV3R1UkY5b2sybFB4WkJNdmZBS1JxSDlVZHB0cTlFT0g4?=
 =?utf-8?B?WmRqZWZTUi9pVE9yYnJrb1NFUURpMHNaeEo4dHFTMVFPWGM4MWx6bi9Yd2xu?=
 =?utf-8?B?aGxwZ2NQM0RUeExLZGxxS1BEQ3VtKzd6THoyeVhRSmRORUlPVHZleGh0K2Vr?=
 =?utf-8?B?d2Vxa2s1TmJSVVRQVWFZT2Y5NGFjcnFSMzNNd2VkYmxENUhqSW1SUlBpVUhO?=
 =?utf-8?B?dUNneDJ2cEVPYlRtaWF1ZmVxRDFmcDA4a0I4dVNPb2J0bUJWZ1FqbTZtQk11?=
 =?utf-8?B?eWRxUjZzZ29YYzR2ZmJwU25Edk5WaWVaOEhnTXB0c0VveHEwL0JMOHZhWGNl?=
 =?utf-8?B?Skk5SDE1TzFmR29HM0plYnhTN0gwWFNEZlNQRWFNV3RudGkxU21hd1A0MXpK?=
 =?utf-8?B?UEVYT0JtQ0p0L0U2L0lSM0dJM3VySWxGRWNnSWMwWnZHMWQ4dytweE14QnFN?=
 =?utf-8?B?T3h1Unc0K0pwRlFrUVRVNS9Sa0QzZGpPb3NPVGFiZHhHTmxHbjMyNFpGOTRj?=
 =?utf-8?B?NFhMN1BxQmxUTUVXdVNRY2ZKSkNRczZjVnkxVkJ2aW5Bb2xpM05rNWUxbFpO?=
 =?utf-8?B?cUY0RC8wS25GQTExQ0FINUFVTnpZamtZcDJLN0pLK0JnTmE0cUYyeDBVZnA4?=
 =?utf-8?B?RURLME5vMWFlQ2hoZVNLZTBHclBheFF6ejJ2NGw2UFZxVXVKLzRXQS9tSVc2?=
 =?utf-8?B?UndOV010T0VSNXhtQ3R4dytQOHAyUlVjNE9US3N5MEZTdGpRSXhITElxcWhV?=
 =?utf-8?B?R0lqOHVSUTJDUWh6aERLVCtWSmxwUUN2aTgyNTFyUUN3Qk5yLzgrQUlVSElS?=
 =?utf-8?B?bWZ4bndBb3RicnIzSXZwUzlQTHgrRC8wK2k1SlkrUzQrWlRUVE5VMkJTMExS?=
 =?utf-8?B?b0l0NThqK3Z0YnBSNlBPMm5PN1NNd2YvdkV0M0FxU0pZck14b2JjNkF0Rmoy?=
 =?utf-8?B?bTdtZTZUalJtbHBobmhVcWh3VTdlcTI0blAySFdQUUJ3TmdUOVMrZ3lhOTJi?=
 =?utf-8?B?Sm1xM09KNzdjYUZiQUVUMEdNOHdjZTNiNk1BV0dlaTREcVRyK2hzS2hseGdi?=
 =?utf-8?Q?F13581cVoxGdzDAYk9donB5YR59wK0pCdbzo73Z?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb92dad9-9e85-4d56-5dc8-08d92cefadc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2021 15:43:37.1786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MTTr4VSyTTimMpAYHGArOuT3DAPcMmIxj15IQzOa8S3G8wNoDqYKJ3tKpoeGRleMImHHSoXtU61Rskksu+SBbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5401
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IExvaWMgUG91bGFpbiA8bG9pYy5wb3VsYWluQGxpbmFyby5vcmc+DQo+IFNlbnQ6
IEZyaWRheSwgSnVuZSAxMSwgMjAyMSA4OjM3IFBNDQo+IA0KPiBIaSBQYXJhdiwNCj4gDQo+IE9u
IEZyaSwgMTEgSnVuIDIwMjEgYXQgMTU6MDEsIFBhcmF2IFBhbmRpdCA8cGFyYXZAbnZpZGlhLmNv
bT4gd3JvdGU6DQo+ID4NCj4gPg0KPiA+DQo+ID4gPiBGcm9tOiBMb2ljIFBvdWxhaW4gPGxvaWMu
cG91bGFpbkBsaW5hcm8ub3JnPg0KPiA+ID4gU2VudDogVGh1cnNkYXksIEp1bmUgMTAsIDIwMjEg
MTE6MTUgUE0NCj4gPiA+DQo+ID4gPiBGcm9tOiBKb2hhbm5lcyBCZXJnIDxqb2hhbm5lcy5iZXJn
QGludGVsLmNvbT4NCj4gPiA+DQo+ID4gPiBJbiBzb21lIGNhc2VzLCBmb3IgZXhhbXBsZSBpbiB0
aGUgdXBjb21pbmcgV1dBTiBmcmFtZXdvcmsgY2hhbmdlcywNCj4gPiA+IHRoZXJlJ3Mgbm8gbmF0
dXJhbCAicGFyZW50IG5ldGRldiIsIHNvIHNvbWV0aW1lcyBkdW1teSBuZXRkZXZzIGFyZQ0KPiA+
ID4gY3JlYXRlZCBvciBzaW1pbGFyLiBJRkxBX1BBUkVOVF9ERVZfTkFNRSBpcyBhIG5ldyBhdHRy
aWJ1dGUgaW50ZW5kZWQNCj4gPiA+IHRvIGNvbnRhaW4gYSBkZXZpY2UgKHN5c2ZzLCBzdHJ1Y3Qg
ZGV2aWNlKSBuYW1lIHRoYXQgY2FuIGJlIHVzZWQNCj4gPiA+IGluc3RlYWQgd2hlbiBjcmVhdGlu
ZyBhIG5ldyBuZXRkZXYsIGlmIHRoZSBydG5ldGxpbmsgZmFtaWx5IGltcGxlbWVudHMgaXQuDQo+
ID4gPg0KPiA+ID4gQXMgc3VnZ2VzdGVkIGJ5IFBhcmF2IFBhbmRpdCwgd2UgYWxzbyBpbnRyb2R1
Y2UNCj4gPiA+IElGTEFfUEFSRU5UX0RFVl9CVVNfTkFNRSBhdHRyaWJ1dGUgaW4gb3JkZXIgdG8g
dW5pcXVlbHkgaWRlbnRpZnkgYQ0KPiA+ID4gZGV2aWNlIG9uIHRoZSBzeXN0ZW0gKHdpdGggYnVz
L25hbWUgcGFpcikuDQo+ID4gPg0KPiA+ID4gaXAtbGluayg4KSBzdXBwb3J0IGZvciB0aGUgZ2Vu
ZXJpYyBwYXJlbnQgZGV2aWNlIGF0dHJpYnV0ZXMgd2lsbA0KPiA+ID4gaGVscCB1cyBhdm9pZCBj
b2RlIGR1cGxpY2F0aW9uLCBzbyBubyBvdGhlciBsaW5rIHR5cGUgd2lsbCByZXF1aXJlIGENCj4g
PiA+IGN1c3RvbSBjb2RlIHRvIGhhbmRsZSB0aGUgcGFyZW50IG5hbWUgYXR0cmlidXRlLiBFLmcu
IHRoZSBXV0FODQo+ID4gPiBpbnRlcmZhY2UgY3JlYXRpb24gY29tbWFuZCB3aWxsIGxvb2tzIGxp
a2UgdGhpczoNCj4gPiA+DQo+ID4gPiAkIGlwIGxpbmsgYWRkIHd3YW4wLTEgcGFyZW50LWRldiB3
d2FuMCB0eXBlIHd3YW4gY2hhbm5lbC1pZCAxDQo+ID4gPg0KPiA+ID4gU28sIHNvbWUgZnV0dXJl
IHN1YnN5c3RlbSAob3IgZHJpdmVyKSBGT08gd2lsbCBoYXZlIGFuIGludGVyZmFjZQ0KPiA+ID4g
Y3JlYXRpb24gY29tbWFuZCB0aGF0IGxvb2tzIGxpa2UgdGhpczoNCj4gPiA+DQo+ID4gPiAkIGlw
IGxpbmsgYWRkIGZvbzEtMyBwYXJlbnQtZGV2IGZvbzEgdHlwZSBmb28gYmFyLWlkIDMgYmF6LXR5
cGUgWQ0KPiA+ID4NCj4gPiA+IEJlbG93IGlzIGFuIGV4YW1wbGUgb2YgZHVtcGluZyBsaW5rIGlu
Zm8gb2YgYSByYW5kb20gZGV2aWNlIHdpdGgNCj4gPiA+IHRoZXNlIG5ldw0KPiA+ID4gYXR0cmli
dXRlczoNCj4gPiA+DQo+ID4gPiAkIGlwIC0tZGV0YWlscyBsaW5rIHNob3cgd2xwMHMyMGYzDQo+
ID4gPiAgIDQ6IHdscDBzMjBmMzogPEJST0FEQ0FTVCxNVUxUSUNBU1QsVVAsTE9XRVJfVVA+IG10
dSAxNTAwIHFkaXNjDQo+ID4gPiBub3F1ZXVlDQo+ID4gPiAgICAgIHN0YXRlIFVQIG1vZGUgRE9S
TUFOVCBncm91cCBkZWZhdWx0IHFsZW4gMTAwMA0KPiA+ID4gICAgICAuLi4NCj4gPiA+ICAgICAg
cGFyZW50X2Rldm5hbWUgMDAwMDowMDoxNC4zIHBhcmVudF9idXNuYW1lIHBjaQ0KPiA+DQo+ID4g
U2hvd2luZyBidXMgZmlyc3QgZm9sbG93ZWQgZGV2aWNlIGlzIG1vcmUgcHJlZmVycmVkIGFwcHJv
YWNoIHRvIHNlZQ0KPiBoaWVyYXJjaHkuDQo+ID4gUGxlYXNlIGNoYW5nZSB0aGVpciBzZXF1ZW5j
ZS4NCj4gPg0KPiA+IFlvdSBzaG91bGQgZHJvcCAibmFtZSIgc3VmZml4Lg0KPiA+ICJwYXJlbnRf
YnVzIiBhbmQgInBhcmVudF9kZXYiIGFyZSBqdXN0IGZpbmUuDQo+IA0KPiBEbyB5b3UgdGhpbmsg
aXQgY2FuIGFsc28gYmUgZHJvcHBlZCBmb3IgdGhlIElGTEEgc3ltYm9sIChJRkxBX1BBUkVOVF9E
RVYNCj4gJiYgSUZMQV9QQVJFTlRfQlVTX05BTUUpLg0KSUZMQSBzeW1ib2wgd2l0aCBfTkFNRSBp
cyBmaW5lIGFzIGl0IGNvdmVycyB3aGF0IHRoZSBmaWVsZCBpcy4NCg==
