Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90A03244A9
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 20:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbhBXTcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 14:32:24 -0500
Received: from mail-dm6nam10on2084.outbound.protection.outlook.com ([40.107.93.84]:7936
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231638AbhBXTcH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 14:32:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FaoD2TzWwfZH4q8KPXcRnkbf+9WKau94DvpbB3LyZVoAT1j6GMKnIBeLASQMU2Ha1GNhMKEJEtwlP2XYzbTdQerOR5ajFyNAQ2nL2ASwFs/4ieyV2Mg7/r7/pxPO9HBOj48gHoRtLy8BTQzS74qdvUE5ukDPqWQKhDV3lopeA5hP0OqhG85wryCn51qxNmRxrjiLIDJMaI1C/t03nIKJWnGSDP5GPPuBkqLZImbrBLcUGUWlfemErThPuytOeEvBOaYL1hGcXs8hlJ2wQ+PWRsWg5DWnM7QvtyrxH+VwfNok2AXuWCb4BwdY18Rg/bgODXZP+sK7n+wwf4Cm/HntYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cErGVgxsQak98/mIEG9ghB+EClKxs0NMW0DjmHf6Tpo=;
 b=IApyCp0Ewi0N1SdRkV6y/2Iocf+m/0zArzsDi6iom70E0c+vs+v863Jyk7sw1OXCjarFQdTP8lwpzqPujdCqyOuD20exJJsNm+zjM2m+tCqs0jlw2TVYa3SMxO68+lBWPsuDWc/yTsc7JAhYNol50Sls5b1vj4dpVPGuRet0yrpnDkgCv2q/mkW0Tdi7jxpXYUYce+tXcz5DdE2DReYjox9BvJgbYqh2btuD+zLGE598ZSEUDTB7LpiQLVGeewTT9gfGAsiCxtIPcWGrLpo7iTrVUPm14IxZZ1rmBAOZB1e32ccvSSe/XFKIKv597qQTN++I6Sdjrq/ZD7FLYqmJtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cErGVgxsQak98/mIEG9ghB+EClKxs0NMW0DjmHf6Tpo=;
 b=hPqA0vANOoRMDr2i4+dTnMirrBG1hxqGtqUCaSE0jrnfB3Xm6y9o6cHv/NZHYHZaZCi7DMIxzpFgzr4gO0eMD96nl9OYeHWCC09dLH843ITFrMKxX7Fj5UKPtX2jdGz4hHklBh16evmfQDH9d7odTP3eVhPpGEfSZb+QkpMMqr8=
Received: from BYAPR05MB4470.namprd05.prod.outlook.com (2603:10b6:a02:fc::24)
 by BYAPR05MB6613.namprd05.prod.outlook.com (2603:10b6:a03:f0::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.12; Wed, 24 Feb
 2021 19:31:06 +0000
Received: from BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::5d18:d12d:f88:e695]) by BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::5d18:d12d:f88:e695%6]) with mapi id 15.20.3890.012; Wed, 24 Feb 2021
 19:31:06 +0000
From:   Ronak Doshi <doshir@vmware.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Todd Sabin <tsabin@vmware.com>, Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Dongseok Yi <dseok.yi@samsung.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Keerthana Kalyanasundaram <keerthanak@vmware.com>
Subject: Re: [PATCH net-next] avoid fragmenting page memory with
 netdev_alloc_cache
Thread-Topic: [PATCH net-next] avoid fragmenting page memory with
 netdev_alloc_cache
Thread-Index: AQHXANSilGAx+qFws0aktHnAqC4Np6pnP2gA
Date:   Wed, 24 Feb 2021 19:31:05 +0000
Message-ID: <0722D5BF-C05C-4D3B-96C7-71D2FBE6991E@vmware.com>
References: <20210212001842.32714-1-doshir@vmware.com>
In-Reply-To: <20210212001842.32714-1-doshir@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.40.20081000
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:646:8b00:a90:d0aa:5fa5:40a7:284e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 562422ec-dd52-4822-6acc-08d8d8fabb0c
x-ms-traffictypediagnostic: BYAPR05MB6613:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR05MB66130082E2E11764D2576223A49F9@BYAPR05MB6613.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FQPq1u+EEeg5vJBYX8NGJQDfxWfcuk6kUf7SZs+OI5L8anxXowTtiOjndBTm/2KS6hmkB6IN2tJ+liMgku67Zj/a0dLOJfq/E54oZz6lc8U2vOGmnHiFE5YutzttpaQm8LQZpW+KpR/f2L2XA3c//hxfsEZSAAitWbJ4YRydnrJ37nn8fQHXbAnPLBreyhHVfT22yB0z6igwST2vc0+ZvZfQKnf4VAO5ycGw46BCAvvPZh+8s3aV8AoCyoxxkAJJW8H6w90Bzkg+uE0oKvvBvG1r/SQ6BZgGpjJ/cwgZS6hjEwlP1fIgsynmw0fmcK3gpR9imrczEAUHiHHNxnCNHBz01RSDuLKy/RaJYsvygKAQsau9uqI8q3epDBd2D+0D4UaNkK13xDz4lWbGrt2AL9lKQKQc7fpUQKKogosBor9Bz+mCAX5mJnzCvTph0T6xLxS40cVrFyPGKS6zC8KIlkcAXiWghALRtEGmTsiko5leGxQ/eGrbj8mc1/r4ZvWaTqy1f4pYsN0h68DppS6RwXDZaO5idmUV3yXT8mwKmXO0iyA0ApGWoFDpj3pQr9RORLjaS9/8dlTdofCRCO0lMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4470.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(54906003)(6916009)(5660300002)(33656002)(66556008)(4326008)(6506007)(6486002)(7416002)(71200400001)(107886003)(36756003)(64756008)(8936002)(66446008)(86362001)(66476007)(186003)(6512007)(76116006)(8676002)(83380400001)(2906002)(2616005)(316002)(478600001)(66946007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?LzFaWjUrUHJZM2ZjUmM3c0hJZ280L25UTkl0S1JrdG5GTWtUU21aVE9GSVov?=
 =?utf-8?B?ZDJGNTRPMUZ0U2czcEUyZ3VHUWk2RnFaT2U2NFAzYWNOQUpYRXgwMmJwcDRV?=
 =?utf-8?B?NHlmZnhIdzRBbk1SNFd0bm9adEhyZUVDcERZNnh6b1o5NFIwMis5ZWdwTW9Q?=
 =?utf-8?B?cyt5aXU1bnRxY0lXNXRub2o3S0NydnVFclQxa3F2WFV0a01WK2M4bis1YnhX?=
 =?utf-8?B?cjh5cHlhZzlwMmlEVVpNTVNNRTJJU1NyeU1zazMyQnBKb01ybmtEbk9wdkpz?=
 =?utf-8?B?eC82QmcvOE5MMm0wUElnaHRyY2pzdXNGY2V2OHIrVlNzV1ArOG15dGZpQVh0?=
 =?utf-8?B?dlpaUXFnSzQ3RTZPWWpHdkFBQ0tzaXpkNmVaQk94ejdMRGZwS0srdVo3dXV1?=
 =?utf-8?B?T3BXcVZaU0hSZjREaTIrc1o0L1FuWnM3SXJTN1pDaTNsancvaWM0ZzVqdUFo?=
 =?utf-8?B?bDVZczg3N1VUblpQUzRldXNJb1RBWFRQaTczT3Vlajd2OWd4bnZLbmtOUDhr?=
 =?utf-8?B?T2x2WEhxbDdIc05leXpRMkZ6cGo2L3Z1SFNsazJRNElyaldHWVhnVEZqYmRq?=
 =?utf-8?B?VE1wWDFOdGY2YjMxTzVBVkhVU3pycGRNZ1ZvaC95ZDVHdURQSDhuNTRvdGpz?=
 =?utf-8?B?WDNRQisvblpVZHRUYkdQOXlCVE0vVWEyOVpyNDhXUzFDM2VNbXh0MEJ5MXhn?=
 =?utf-8?B?WWNvYVpxTG5lT1p3K3FoOEpnbHhzdnpwaXVXck5GaGthVHkwVWY2MHlvd05K?=
 =?utf-8?B?cnZnTUlXL1hNWDZ2Z3E5WWwzb3BweWdlYmhRYUo2TUJGRThyRnNXRk0rRkhs?=
 =?utf-8?B?UzlsRVVVOXl3MTVzNnpyZkZWcll3em5MNVA4MXNFYWxGUGdCTVp3VllRRHpR?=
 =?utf-8?B?Z3c2Vll4WGFiZjkydTlIRjkyUXA4V0pzdUoySkpraGxzdzRKR3FBaEE3bzhw?=
 =?utf-8?B?MndFUkhoT1N4LzNOKzRLMzR0TnZpbGxLWk9QZFhBTitlY2UyTGsxaGNtd2xw?=
 =?utf-8?B?SDltT2t3bXA3UWxaTUgrTWs5amtQcFdEQ3grQVZ2cVBENFBGMDg0QTdUc0Vr?=
 =?utf-8?B?L3hzU0JreG9zSkRIMEo2WFJza0F2cG1GOEJtQ0s3REVNT3dCbDNmSnRJeXJu?=
 =?utf-8?B?eHRHSXhibVhkU3RCU3NoWC8zYTQ1c1dLM3JFRFQ1NGtvMEV5YUZYZW1sSUl4?=
 =?utf-8?B?Z01LMWtrYTJPaUZiYS9oOFAzZlFNaFRNMWlCTzc2NHRnOXgzTnR2UlF3ck96?=
 =?utf-8?B?MkZNSGw0Z0F5SnJpZVVwcjhHTng5eW82WGJNaDMwSGJJYWNwUHVpVytVOWxp?=
 =?utf-8?B?aDRyNDd3UDYxMHQyL25CcFFXL096ZzJKbml2QkhNVW1aNWJLNG1DUTc0WWE3?=
 =?utf-8?B?QXU4OUlZeGRZNk5NVmUzeTVJdUZzbDlkZktaQzhLT0FtdTdpSU1nWklNWXFy?=
 =?utf-8?B?dGRNaVdOM0t4L3U5azZ4TzljcE0rNEtkS3h2T09uQUpURnpjVDJBMUhUMkZs?=
 =?utf-8?B?aUJwZVIvd1E3ZEo4cXFRVm5EUTl6cVBPdjl4TWwzSVN4dmtlOTNJNHNXTTVY?=
 =?utf-8?B?aXM4RjVTTXh1UXp3R0YwRkowa1I3L21jN2RVV1Y0bUJnTEhmdy9tMUhZMGRm?=
 =?utf-8?B?UG01UXRkVTF4Vk5GTittbmhndEgrKzZ2dnEwZWJIT1I1SXBGa2w5Nk9YNVNo?=
 =?utf-8?B?dDN2YnRuVWMrOWd0Y1kweFhPUFQzbHE2eUpjY1dydHNFTnpkQjl2NzVzelQy?=
 =?utf-8?B?cGg0Q3JXWURSQW91d0ovSzRxZlZYRG9ONmdBMkUzWHl2OEZTSCtXL2xiSWFh?=
 =?utf-8?B?eVBrcEMweWhNcDVkUmhicjFrMkl1VFhCcmhDTzBYSmF0QkFtbk8yV2ZkalJa?=
 =?utf-8?Q?MsBOxmxSnFsQD?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D071FAA0732AB4A9EE54AD7DABD7C6D@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4470.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 562422ec-dd52-4822-6acc-08d8d8fabb0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 19:31:06.2772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uGwxcYf7tzAlM31AHp4jsUYF8vQDwMC8hVvDT2rFc5MfjQvSTF9ltMh0EtkD1pGTnswL+er9YAsp3ogRw7bEhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB6613
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQrvu79PbiAyLzExLzIxLCA0OjE4IFBNLCAiUm9uYWsgRG9zaGkiIDxkb3NoaXJAdm13YXJlLmNv
bT4gd3JvdGU6DQo+ICAgIEZyb206IFRvZGQgU2FiaW4gPHRzYWJpbkB2bXdhcmUuY29tPg0KPg0K
PiAgICBMaW51eCBuZXR3b3JrIHN0YWNrIHVzZXMgYW4gYWxsb2NhdGlvbiBwYWdlIGNhY2hlIGZv
ciBza2JzLiAgVGhlDQo+ICAgcHVycG9zZSBpcyB0byByZWR1Y2UgdGhlIG51bWJlciBvZiBwYWdl
IGFsbG9jYXRpb25zIHRoYXQgaXQgbmVlZHMgdG8NCj4gICAgbWFrZSwgYW5kIGl0IHdvcmtzIGJ5
IGFsbG9jYXRpbmcgYSBncm91cCBvZiBwYWdlcywgYW5kIHRoZW4NCj4gICAgc3ViLWFsbG9jYXRp
bmcgc2tiIG1lbW9yeSBmcm9tIHRoZW0uICBXaGVuIGFsbCBza2JzIHJlZmVyZW5jaW5nIHRoZQ0K
PiAgICBzaGFyZWQgcGFnZXMgYXJlIGZyZWVkLCB0aGVuIHRoZSBibG9jayBvZiBwYWdlcyBpcyBm
aW5hbGx5IGZyZWVkLg0KPg0KPiAgICBXaGVuIHRoZXNlIHNrYnMgYXJlIGFsbCBmcmVlZCBjbG9z
ZSB0b2dldGhlciBpbiB0aW1lLCB0aGlzIHdvcmtzIGZpbmUuDQo+ICAgIEhvd2V2ZXIsIHdoYXQg
Y2FuIGhhcHBlbiBpcyB0aGF0IHRoZXJlIGFyZSBtdWx0aXBsZSBuaWNzIChvciBtdWx0aXBsZQ0K
PiAgICByeC1xdWV1ZXMgaW4gYSBzaW5nbGUgbmljKSwgYW5kIHRoZSBza2JzIGFyZSBhbGxvY2F0
ZWQgdG8gZmlsbCB0aGUgcngNCj4gICAgcmluZyhzKS4gSWYgc29tZSBuaWNzIG9yIHF1ZXVlcyBh
cmUgZmFyIG1vcmUgYWN0aXZlIHRoYW4gb3RoZXJzLCB0aGUNCj4gICAgZW50cmllcyBpbiB0aGUg
bGVzcyBidXN5IG5pYy9xdWV1ZSBtYXkgZW5kIHVwIHJlZmVyZW5jaW5nIGEgcGFnZQ0KPiAgICBi
bG9jaywgd2hpbGUgYWxsIG9mIHRoZSBvdGhlciBwYWNrZXRzIHRoYXQgcmVmZXJlbmNlZCB0aGF0
IGJsb2NrIG9mDQo+ICAgIHBhZ2VzIGFyZSBmcmVlZC4NCj4NCj4gICAgVGhlIHJlc3VsdCBvZiB0
aGlzIGlzIHRoYXQgdGhlIG1lbW9yeSB1c2VkIGJ5IGFuIGFwcGxpYW5jZSBmb3IgaXRzIHJ4DQo+
ICAgIHJpbmdzIGNhbiBzbG93bHkgZ3JvdyB0byBiZSBtdWNoIGdyZWF0ZXIgdGhhbiBpdCB3YXMg
b3JpZ2luYWxseS4NCj4NCj4gICAgVGhpcyBwYXRjaCBmaXhlcyB0aGF0IGJ5IGdpdmluZyBlYWNo
IHZteG5ldDMgZGV2aWNlIGEgcGVyLXJ4LXF1ZXVlIHBhZ2UNCj4gICAgY2FjaGUuDQo+DQo+ICAg
IFNpZ25lZC1vZmYtYnk6IFRvZGQgU2FiaW4gPHRzYWJpbkB2bXdhcmUuY29tPg0KPiAgICBTaWdu
ZWQtb2ZmLWJ5OiBSb25hayBEb3NoaSA8ZG9zaGlyQHZtd2FyZS5jb20+DQo+ICAgIC0tLQ0KPiAg
ICAgZHJpdmVycy9uZXQvdm14bmV0My92bXhuZXQzX2Rydi5jIHwgMzAgKysrKysrKysrKysrKysr
KysrKysrKysrLS0tLS0tDQo+ICAgICBkcml2ZXJzL25ldC92bXhuZXQzL3ZteG5ldDNfaW50Lmgg
fCAgMiArKw0KPiAgICAgaW5jbHVkZS9saW51eC9za2J1ZmYuaCAgICAgICAgICAgIHwgIDIgKysN
Cj4gICAgIG5ldC9jb3JlL3NrYnVmZi5jICAgICAgICAgICAgICAgICB8IDIxICsrKysrKysrKysr
KysrKy0tLS0tLQ0KPiAgICAgNCBmaWxlcyBjaGFuZ2VkLCA0MyBpbnNlcnRpb25zKCspLCAxMiBk
ZWxldGlvbnMoLSkNCg0KQW55IHVwZGF0ZSBvbiB0aGlzIHBhdGNoPw0KDQpUaGFua3MsDQpSb25h
aw0KDQo=
