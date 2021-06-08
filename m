Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3882939EE1A
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 07:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhFHF2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 01:28:05 -0400
Received: from mail-mw2nam12on2079.outbound.protection.outlook.com ([40.107.244.79]:57441
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229512AbhFHF2E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 01:28:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4zf1lnyatpPpV6cOfVzw1rnkkzFcowhjNuiyw1yGMifZwIzo7rgE/HicU4Uz3nsIi5JJZXhQIpaoDRnn96XMNF3fT5eoLkItSUV5lNR8mZI8RayQpJxhaCogLseJIv4iGKNu7foXLoeq8AxaRQMhhZXR5oc1rh0ycmNA4JapNVkHWhsf54XNKD7qubSzY7JMUh2jjMxZ9F+dXJ7Ap5T6GqJK8Y/vn+hgFZ7ynNZL7GdvJf+IyFk/aixbBQM+8jXgnnIZwBz/eBWSj/XHscMjZUxhjRHJC4RxqZIwMN9LybdkIWkyX0qoVX6IV1GnXnGIj3ZUv2lJlKT5jPXccfGzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1updrIP3yUB3rqBPoPVURxAs41le/HGP2VYM/QibcE=;
 b=U/NXGj5H64ZIFGNORe4QxmkB7Opru6jCEuLs2RCjYsRn1CPG6NqQSyVq2rql1LbZCfcNg/tWEpwdgICbavuKV5jFl4rXFRvLUFDRB/e/pVfrz41bsScyYgGp7DlDXWzvz5MIqhUxBTW3SYX4Hc6nJf8NJBjrvpYfm2juWeEQGU3ND8xdvNCaw92f5F1+v6/7yJalhUi6MHd1F9c+9rTMzw0W4uaXLuv6dy74ET58D5FUcQ4TOUsWtT1kYY7IFJTy0zvRY/ctJCfWrnaYMVAE5OLkjmnAOioHc2tiOiDZ/vSbvo0S5/VlVxmyUUy8gmWn+oOzDkLrCcsW1NIqdAjYjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1updrIP3yUB3rqBPoPVURxAs41le/HGP2VYM/QibcE=;
 b=q5VACBMUfQHvluTFGZE+cl/cT08SpgVicAnh92GhsREPtL3lt5azWyx5mvHrQ8JMJOmMl88MDAcMM5CTa5SNIGkAOmvBL2jFAIx7kYyCzoga+hmAw/5m7Nfj+JjGSjeW4qVlS1xQ1aGrzMEMJ00V+GC/gsfmCeO/ORi/RKrRwZMSSbCYiB3yAeIaA/7BGltmXWAkXdoir/P0GoySa3R0npXcZl15+I2MzSaoQl6gVtjQtonoPboTig4rV7P1THvINJ5ITD2jfpWn8lwBRSpkmXwOSklCmPW4GhQHGJ8uULtnNFBc8omwm6NMs58tdLgq8UuLLMyC9Xn83Zaj0HuwSA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5499.namprd12.prod.outlook.com (2603:10b6:510:d5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 8 Jun
 2021 05:26:11 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344%6]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 05:26:11 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>,
        "moyufeng@huawei.com" <moyufeng@huawei.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
Thread-Topic: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
Thread-Index: AQHXWGpNwXhSEOm/yUu2yThJsUjGQKsDErIAgAN3H5CAAWCHgIAAKVuQgABTHoCAAAD4EIABE+eAgAAfZ7A=
Date:   Tue, 8 Jun 2021 05:26:11 +0000
Message-ID: <PH0PR12MB5481EA2EB1B78BC7DD92FD19DC379@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20210603111901.9888-1-parav@nvidia.com>
 <c50ebdd6-a388-4d39-4052-50b4966def2e@huawei.com>
 <PH0PR12MB548115AC5D6005781BAEC217DC399@PH0PR12MB5481.namprd12.prod.outlook.com>
 <a1b853ef-0c94-ba51-cf31-f1f194610204@huawei.com>
 <PH0PR12MB5481A9B54850A62DF80E3EC1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
 <338a2463-eb3a-f642-a288-9ae45f721992@huawei.com>
 <PH0PR12MB5481FB8528A90E34FA3578C1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
 <8c3e48ce-f5ed-d35d-4f5e-1b572f251bd1@huawei.com>
In-Reply-To: <8c3e48ce-f5ed-d35d-4f5e-1b572f251bd1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.202.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f45280bc-5293-4c41-a1e6-08d92a3ded57
x-ms-traffictypediagnostic: PH0PR12MB5499:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR12MB549964827B5F3F4E1F9FA7EADC379@PH0PR12MB5499.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w6l7/6zg4emUkxBSq90kJPUZ9W0WIBUmh68BjIM5O9gE43M80I1IQlFhNMlyw4fyxaU03tnepl4I4eRjvI0XsvpE6G5wTGaUKiieAU/61T8uvZYW0KoGu6/90D+tr2Q2Q7AloQrZDRqbRXXq1NVOlBlt5EDzZ4jyl5joYy66pyLEKjZ2hgeqz3A4fTb4PfgP+ymCmebVNhrkKGSbl0TMIcfETxHx2chSPdIHXsrV2mRQ4aQVgof1Tg/lvnhURei05+o7eoCzM+WDeNtrGq8T+gzhb0k+zxxFf2sRwO5c8DGXthrfxkpBTSCTJP7oUgiI6S0q5VNo4IiuDLNVQNPrIsWd54eCJ7eRfeJGkGrNslRJMVD9sxz5yew8u+xAX82tuhs9ObWOqsRU3DTVUNRHiLRF3F8B5Wqb9AkZq0L+H70oyrUYDWexQ/Kr+065KbWwTJAyA8rnl8OPeJ9JklllT+6e7QvW3g2oXjvL9srPvAlKylwaMWmX7hUtFxYLSIaG5Ad8e0DMAfBcaWglvMAAufoaKhvEuJhO2Rfdy7e0+p8A6sY0O8RAvb5D5s1+vf/l5Es6k9W9/k0CR2IrSOQgmP5tsuyH4dNYwnlEIHNpQ60=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(38100700002)(9686003)(122000001)(83380400001)(55016002)(5660300002)(66946007)(86362001)(52536014)(76116006)(71200400001)(66476007)(66446008)(64756008)(33656002)(7696005)(53546011)(66556008)(8936002)(55236004)(316002)(54906003)(110136005)(8676002)(478600001)(186003)(6506007)(26005)(2906002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SExaZ3hJMFY3ZzAvdlpWdWJnbUZxR2FaYTNGd3B5NG40VWJ6SGdMWEFwY1Z0?=
 =?utf-8?B?SGVaZm1HNnNvVGtXS2c0Sm1vMjI5U0JUZS9VREZSUk9PNGNWdDcyYVRPaklK?=
 =?utf-8?B?R0lkRlY1akdiaGRPaUF0Q2dXYzg2aWwvWFZPeTNpbFBpQkdyMk9CYjYyclpl?=
 =?utf-8?B?Zk5TcVNKbEFxL09jeUNoNEs4dFY0cXM5YW5VRVRGZEpSbEw1dVc2YmNFYTN6?=
 =?utf-8?B?YUh0a3U4V1NIajQ5Zys1QnJiNlBldnR3NEs2ZmpPbGY0L1NUa2d6VlAvYUF6?=
 =?utf-8?B?M09uMkhtV2pWZXJDcDdiTVF2d2lTNThXRHJGUDdZaXRXUkNGSy8zTFFDekZs?=
 =?utf-8?B?M1NncjYwZDltTm9LL1RjdzNhcjNOTVVTcms3Y01pTXl6U2I3c2hwUlVzeWZu?=
 =?utf-8?B?RWIxNzhjZVBkOEwxZXhrWHNvcU1HaEV5SzZJVjQvTkxVMTUwdS8xM051SUhn?=
 =?utf-8?B?UnFHK2Z3d2IzdkdseGNaL3JwcHl6YTJsRUNHSDlId21oRmhMZnppSGlJMWRG?=
 =?utf-8?B?ZVh6SUlSYnduSE0vMWJacHpKNGtSVEhHQlM0bldjM0lmclpWckd4cGpHbEJm?=
 =?utf-8?B?MmhnalVyZjVIOWZHT1dHditsSjdiSjUwY0JmS2tOclM2OVp4QmF2L05QU1BE?=
 =?utf-8?B?NThweHJCOEZtckNJYW0wL2NITjVlWkdLZnlqRWpmTmUySzVJVGtCQ0tzYW5G?=
 =?utf-8?B?OWlkUDNBZ09UelB4ZXdWNi95M3F5bVNac1NBTTV4Z1JLV0RPVS9aend3bkcx?=
 =?utf-8?B?U1ZUNitKbEVBOUxKeWJDVFFxbnYzMU1OS1VJMUlwbUQ4MFJOZGpoSnNvMllV?=
 =?utf-8?B?NExsa0Q1T01mWXhsL3AyTWZ5aHBRMGNmRnhralpzS2ZoN2hLejRwY21WRE03?=
 =?utf-8?B?WGg5UUs2cmFLZ09SNGVST1Z5MEJJWkd2dWFmaERGa1YreUtMaHVvbWFzN0N4?=
 =?utf-8?B?SmtjNGQrakczUitOcW9aRGNWZlpzM1FhQndoYzV5ajRxU1ZPQnk2YXhRV2RZ?=
 =?utf-8?B?b0FJMVlWdUhkNmxmclF0OFVuaWdCWTZiNnNnK0NvOFpzZCtzbHpCMERKbFJq?=
 =?utf-8?B?Sm1IN1pHazN1Q3ZGRHRiZk00SHRyRW1lcWZDbTdCbHVFb1VjbjhSYkpoQkR6?=
 =?utf-8?B?eGtYQ2FqUWdXdFZWL1Zjb21iS1ZHMFN4MWNsd2F0aEZWb1pOdmx3ZlpaWTBW?=
 =?utf-8?B?bnppaUxOOTA4ZHFLci93RDNtd0ZXLzI4MVUvNzcvem1qVTRDbWFWT2NlZ2gw?=
 =?utf-8?B?VkxRNFRIZUxpTi9sNG5nWnZ5ZEpvUlpNcFJvUU1EcGk5TEhVWU1naHpuRmV4?=
 =?utf-8?B?OWUzWElidTdkOFQwdEQxYjhqUm1OZk9TYWVtWWpXUlQ0VWZjTjB3OC9oRVFx?=
 =?utf-8?B?UUl6d2VNb3hGcGlLbHRsQjhYbG5aU3l1TllDek4xZG0zOVpkQVIya2tMdktr?=
 =?utf-8?B?cnlRWUhWdVNSbGYwSVRPVGozTWRKZGt4NGFSTUR5UEd1bThWYVpwbUJMZXFJ?=
 =?utf-8?B?Z2pncHRXUnoyWVpKMEkyKzd5ak9DVDNnMHhjMWpVWnJHelhjUUZpdHU3NDds?=
 =?utf-8?B?bndYeXB4TjZmZXBnK2lTL2hJaGZGZ3ZCNFJON1NBREMrbDhqbFVYcm1ESnZB?=
 =?utf-8?B?Mjl4Zkx3TW5WV0dERmlHb1lSUUM1VTlpTXhCOVpYckExYVhwczdXQkQraW0y?=
 =?utf-8?B?clUrREg0UkdQamtMTDgxZ2NpLzVIaS9IL2Q1ZFIrUWIzOGtsUWd3bzBQL2hn?=
 =?utf-8?Q?jGmc5wcC97IYDVej89YJxQn7E32FjauogFpoDpP?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f45280bc-5293-4c41-a1e6-08d92a3ded57
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 05:26:11.2064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aJh2darBGUdxlQqXjLcRQZAhNUllbFfEE4zu61khvz+xLyNAsuTcUbuotty9n+G4I5DcH3NqMuq/FoPgOc2OQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5499
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogWXVuc2hlbmcgTGluIDxsaW55dW5zaGVuZ0BodWF3ZWkuY29tPg0KPiBTZW50
OiBUdWVzZGF5LCBKdW5lIDgsIDIwMjEgODo1OCBBTQ0KPiANCj4gT24gMjAyMS82LzcgMTk6MTIs
IFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPj4gRnJvbTogWXVuc2hlbmcgTGluIDxsaW55dW5zaGVu
Z0BodWF3ZWkuY29tPg0KPiA+PiBTZW50OiBNb25kYXksIEp1bmUgNywgMjAyMSA0OjI3IFBNDQo+
ID4+DQo+IA0KPiBbLi5dDQo+IA0KPiA+Pj4NCj4gPj4+PiAyLiBlYWNoIFBGJ3MgZGV2bGluayBp
bnN0YW5jZSBoYXMgdGhyZWUgdHlwZXMgb2YgcG9ydCwgd2hpY2ggaXMNCj4gPj4+PiAgICBGTEFW
T1VSX1BIWVNJQ0FMLCBGTEFWT1VSX1BDSV9QRiBhbmQNCj4gPj4gRkxBVk9VUl9QQ0lfVkYoc3Vw
cG9zaW5nIEkNCj4gPj4+PiB1bmRlcnN0YW5kDQo+ID4+Pj4gICAgcG9ydCBmbGF2b3VyIGNvcnJl
Y3RseSkuDQo+ID4+Pj4NCj4gPj4+IEZMQVZPVVJfUENJX3tQRixWRixTRn0gYmVsb25ncyB0byBl
c3dpdGNoIChyZXByZXNlbnRvcikgc2lkZSBvbg0KPiA+PiBzd2l0Y2hkZXYgZGV2aWNlLg0KPiA+
Pg0KPiA+PiBJZiBkZXZsaW5rIGluc3RhbmNlIG9yIGVzd2l0Y2ggaXMgaW4gREVWTElOS19FU1dJ
VENIX01PREVfTEVHQUNZDQo+ID4+IG1vZGUsIHRoZSBGTEFWT1VSX1BDSV97UEYsVkYsU0Z9IHBv
cnQgaW5zdGFuY2UgZG9lcyBub3QgbmVlZCB0bw0KPiBjcmVhdGVkPw0KPiA+IE5vLiBpbiBlc3dp
dGNoIGxlZ2FjeSwgdGhlcmUgYXJlIG5vIHJlcHJlc2VudG9yIG5ldGRldmljZSBvciBkZXZsaW5r
IHBvcnRzLg0KPiANCj4gSXQgc2VlbXMgZWFjaCBkZXZsaW5rIHBvcnQgaW5zdGFuY2UgY29ycmVz
cG9uZHMgdG8gYSBuZXRkZXZpY2UuDQo+IE1vcmUgc3BlY2lmaWNseSwgdGhlIGRldmxpbmsgaW5z
dGFuY2UgaXMgY3JlYXRlZCBpbiB0aGUgc3RydWN0IHBjaV9kcml2ZXInIHByb2JlDQo+IGZ1bmN0
aW9uIG9mIGEgcGNpIGZ1bmN0aW9uLCBhIGRldmxpbmsgcG9ydCBpbnN0YW5jZSBpcyBjcmVhdGVk
IGFuZCByZWdpc3RlcmVkIHRvDQo+IHRoYXQgZGV2bGluayBpbnN0YW5jZSB3aGVuIGEgbmV0ZGV2
IG9mIHRoYXQgcGNpIGZ1bmN0aW9uIGlzIGNyZWF0ZWQ/DQo+IA0KWWVzLg0KDQo+IEFzIGluIGRp
YWdyYW0gWzFdLCB0aGUgZGV2bGluayBwb3J0IGluc3RhbmNlKGZsYXZvdXIgRkxBVk9VUl9QSFlT
SUNBTCkgZm9yDQo+IGN0cmwtMC1wZjAgaXMgY3JlYXRlZCB3aGVuIHRoZSBuZXRkZXYgb2YgY3Ry
bC0wLXBmMCBpcyBjcmVhdGVkIGluIHRoZSBob3N0IG9mDQo+IHNtYXJ0TklDLCB0aGUgZGV2bGlu
ayBwb3J0IGluc3RhbmNlKGZsYXZvdXIgRkxBVk9VUl9WSVJUVUFMKSBmb3IgY3RybC0wLQ0KPiBw
ZjB2Zk4gaXMgY3JlYXRlZCB3aGVuIHRoZSBuZXRkZXYgb2YgY3RybC0wLXBmMHZmTiBpcyBjcmVh
dGVkIGluIHRoZSBob3N0IG9mDQo+IHNtYXJ0TklDLCByaWdodD8NCj4gDQpDdHJsLTAtcGYwdmZO
LCBjdHJsLTAtcGYwIHBvcnRzIGFyZSBlc3dpdGNoIHBvcnRzLiBUaGV5IGFyZSBjcmVhdGVkIHdo
ZXJlIHRoZXJlIGlzIGVzd2l0Y2guDQpVc3VhbGx5IGluIHNtYXJ0bmljIHdoZXJlIGVzd2l0Y2gg
aXMgbG9jYXRlZC4NCg0KPiBXaGVuIGVzd2l0Y2ggbW9kZSBpcyBzZXQgdG8gREVWTElOS19FU1dJ
VENIX01PREVfU1dJVENIREVWLCB0aGUNCj4gcmVwcmVzZW50b3IgbmV0ZGV2IGZvciBQRi9WRiBp
biAiY29udHJvbGxlcl9udW09MSIgaXMgY3JlYXRlZCBpbiB0aGUgaG9zdCBvZg0KPiBzbWFydE5J
Qywgc28gaXMgdGhlIGRldmxpbmsgcG9ydCBpbnN0YW5jZShGTEFWT1VSX1BDSV97UEYsVkYsU0Z9
KQ0KPiBjb3JyZXNwb25kaW5nIHRvIHRoYXQgcmVwcmVzZW50b3IgbmV0ZGV2IGp1c3QgY3JlYXRl
ZCBpbiB0aGUgaG9zdCBvZg0KPiBzbWFydE5JQz8gTW9yZSBzcGVjaWZpY2x5LCBkZXZsaW5rIHBv
cnQgaW5zdGFuY2UoZmxhdm91ciBGTEFWT1VSX1BDSV9QRikNCj4gZm9yIGN0cmwtMS1wZjAgYW5k
IGRldmxpbmsgcG9ydCBpbnN0YW5jZSAoZmxhdm91ciBGTEFWT1VSX1BDSV9WRilmb3IgY3RybC0x
LQ0KPiBwZjB2Zk4/DQo+IA0KSSBkbyBub3Qga25vdyB3aGF0IHlvdSBtZWFuIGJ5ICJob3N0IG9m
IHNtYXJ0bmljIi4gQnV0IGFzIGNsYXJpZmllZCBpbiBkaWFncmFtIGFuZCBhYm92ZSwNClRoZXkg
YXJlIGNyZWF0ZWQgb24gdGhlIGVzd2l0Y2ggZGV2aWNlLg0KDQo+IFdoZW4gImNvbnRyb2xsZXJf
bnVtPTEiIGlzIHBsdWdnZWQgdG8gYSBzZXJ2ZXIsIHRoZSBzZXJ2ZXIgaG9zdCBjcmVhdGVzDQo+
IGRldmxpbmsgaW5zdGFuY2UgYW5kIGRldmxpbmsgcG9ydCBpbnN0YW5jZSBpbiB0aGUgaG9zdCBv
ZiBzZXJ2ZXIgYXMgc2ltaWxhciBhcw0KPiB0aGUgY3RybC0wLXBmMCBhbmQgY3RybC0wLXBmMHZm
TiBpbiB0aGUgaG9zdCBvZiBzbWFydE5JQz8NClNpbmNlIGVzd2l0Y2ggaXMgbm90IGluIHRoZSBj
b250cm9sbGVyPTEsIGNvbnRyb2xsZXIgMSBpcyBqdXN0IGhvc3RpbmcgUENJIFBGLCBWRiwgU0Yg
ZnVuY3Rpb25zLg0KRWl0aGVyIGl0IGhhcyBQSFlTSUNBTCBvciBWSVJUVUFMIHBvcnRzIGFsb25n
IHdpdGggaXRzIG5ldGRldmljZSBhbmQgZGV2bGluayBpbnN0YW5jZS4NCg0KPiA+PiBPciBkZXZs
aW5rIGluc3RhbmNlIGRvZXMgZXhpc3QgaW4gdGhlIGhvc3QgY29ycmVzcG9uZGluZyB0bw0KPiA+
PiAiY29udHJvbGxlcl9udW09MSIsIGJ1dCB0aGUgbW9kZSBvZiB0aGF0IGRldmxpbmsgaW5zdGFu
Y2UgaXMNCj4gPj4gREVWTElOS19FU1dJVENIX01PREVfTEVHQUNZIGluIGRpYWdyYW0gWzFdPw0K
PiA+IEFzIHlvdSBjYW4gc2VlIHRoYXQgZXN3aXRjaCBpcyBsb2NhdGVkIG9ubHkgb24gY29udHJv
bGxlcj0wLg0KPiA+IFRoaXMgZXN3aXRjaCBpcyBzZXJ2aW5nIFBGLCBWRiwgU0ZzIG9mIGNvbnRy
b2xsZXI9MSArIGNvbnRyb2xsb2xlcj0wIGFzIHdlbGwuDQo+IA0KPiBIb3cgZG8gd2UgZGVjaWRl
IHdoZXJlIGVzd2l0Y2ggaXMgbG9jYXRlZD8gdGhyb3VnaCBzb21lIGZ3L2h3DQo+IGNvbmZpZ3Vy
YXRpb24/DQpUaGlzIGlzIHVzdWFsbHkgZGVjaWRlZCBieSB0aGUgaGFyZHdhcmUuDQoNCj4gDQo+
IEl0IHNlZW1zIGlmIHRoZSBlc3dpdGNoIGlzIGVuYWJsZWQgb24gImNvbnRyb2xsZXI9MSIsIHRo
YXQgaXMgYSBuZXN0ZWQgZXN3aXRjaA0KPiB0b28sIHdoaWNoIHlvdSBtZW50aW9uZWQgYmVsb3c/
DQpZZXMuDQoNCj4gDQo+ID4+DQo+ID4+IEFsc28sIGVzd2l0Y2ggbW9kZSBjYW4gb25seSBiZSBz
ZXQgb24gdGhlIGRldmxpbmsgaW5zdGFuY2UNCj4gPj4gY29ycmVzcG9uZGluZyB0byBQRiwgYnV0
IG5vdCBmb3IgVkYvU0Yoc3VwcG9zaW5nIHRoYXQgVkYvU0YgY291bGQNCj4gPj4gaGF2ZSBpdCdz
IG93biBkZXZsaW5rIGluc3RhbmNlIHRvbyksIHJpZ2h0Pw0KPiA+IFllcy4gRXN3aXRjaCBjYW4g
YmUgbG9jYXRlZCBvbiB0aGUgVkYgdG9vLiBNbHg1IGRyaXZlciBkb2Vzbid0IGhhdmUgaXQgeWV0
DQo+IG9uIFZGLg0KPiA+IFRoaXMgbWF5IGJlIHNvbWUgbmVzdGVkIGVzd2l0Y2ggaW4gZnV0dXJl
LiBJIGRvIG5vdCBrbm93IHdoZW4uDQo+ID4NCj4gPj4gYnkgdGhlIG5ldHdvcmsvc3lzYWRtaW4u
DQo+ID4+PiBXaGlsZSBkZXZsaW5rIGluc3RhbmNlIG9mIGEgZ2l2ZW4gUEYsVkYsU0YgaXMgbWFu
YWdlZCBieSB0aGUgdXNlciBvZg0KPiA+Pj4gc3VjaA0KPiA+PiBmdW5jdGlvbiBpdHNlbGYuDQo+
ID4+DQo+ID4+ICdkZXZsaW5rIHBvcnQgZnVuY3Rpb24nIG1lYW5zICJzdHJ1Y3QgZGV2bGlua19w
b3J0IiwgcmlnaHQ/DQo+ID4gJ2Z1bmN0aW9uJyBpcyB0aGUgb2JqZWN0IG1hbmFnaW5nIHRoZSBm
dW5jdGlvbiBjb25uZWN0ZWQgb24gdGhlIG90aGVyc2lkZQ0KPiBvZiB0aGlzIHBvcnQuDQo+ID4g
VGhpcyBpbmNsdWRlcyBpdHMgaHdfYWRkciwgcmF0ZSwgc3RhdGUsIG9wZXJhdGlvbmFsIHN0YXRl
Lg0KPiANCj4gRG9lcyAib3RoZXIgc2lkZSBvZiB0aGlzIHBvcnQiIG1lYW5zIHRoZSBwY2kgZnVu
Y3Rpb24gdGhhdCBpcyBtb3N0IGxpa2VseSBoYXZlDQo+IGJlZW4gcGFzc2VkIHRocm91Z2ggdG8g
YSBWTT8NCj4gDQpZZXMuDQoNCj4gImRldmxpbmsgcG9ydCIgd2l0aG91dCB0aGUgImZ1bmN0aW9u
IiByZXByZXNlbnRzIHRoZSByZXByZXNlbnRvciBuZXRkZXYgb24NCj4gdGhlIGhvc3Qgd2hlcmUg
ZXN3aXRjaCBpcyBsb2NhdGVkPw0KPiANClllcy4NCg0KPiA+DQo+ID4+IEl0IHNlZW1zICdkZXZs
aW5rIHBvcnQgZnVuY3Rpb24nIGluIHRoZSBob3N0IGlzIHJlcHJlc2VudGluZyBhIFZGDQo+ID4+
IHdoZW4gZGV2bGluayBpbnN0YW5jZSBvZiB0aGF0IFZGIGlzIGluIHRoZSBWTT8NCj4gPiBSaWdo
dC4NCj4gPj4NCj4gPj4+IEZvciBleGFtcGxlIHdoZW4gYSBWRiBpcyBtYXBwZWQgdG8gYSBWTSwg
ZGV2bGluayBpbnN0YW5jZSBvZiB0aGlzIFZGDQo+ID4+IHJlc2lkZXMgaW4gdGhlIFZNIG1hbmFn
ZWQgYnkgdGhlIGd1ZXN0IFZNLg0KPiA+Pg0KPiA+PiBEb2VzIHRoZSB1c2VyIGluIFZNIHJlYWxs
eSBjYXJlIGFib3V0IGRldmxpbmsgaW5mbyBvciBjb25maWd1cmF0aW9uDQo+ID4+IHdoZW4gbmV0
d29yay9zeXNhZG1pbiBoYXMgY29uZmlndXJlZCB0aGUgVkYgdGhyb3VnaCAnZGV2bGluayBwb3J0
DQo+IGZ1bmN0aW9uJw0KPiA+PiBpbiB0aGUgaG9zdD8NCj4gPiBZZXMuIGRldmxpbmsgaW5zdGFu
Y2Ugb2ZmZXJzIG1hbnkga25vYnMgaW4gdW5pZm9ybSB3YXkgb24gUEYsIFZGLCBTRi4NCj4gPiBU
aGV5IGFyZSBpbiB1c2UgaW4gbWx4NSBmb3IgZGV2bGluayBwYXJhbXMsIHJlbG9hZCwgbmV0IG5z
Lg0KPiANCj4gIm5ldCBucyIgcmVmZXIgdG8gIm5ldCBuYW1lc3BhY2UiLCByaWdodD8NClllcy4N
Cg0KPiBJIGFtIG5vdCBzdXJlIGhvdyBkZXZsaW5rIGluc3RhbmNlIHJlbGF0ZWQgdG8gbmV0IG5h
bWVzcGFjZSB5ZXQuDQo+IEkgdGhvdWdodCBkZXZsaW5rIGlzIG5vdCBsaW1pdGVkIHRvIG5ldHdv
cmtpbmcsIGl0IGNhbiBiZSB1c2VkIGluIG90aGVyIHBjaWUNCj4gZGV2aWNlIG90aGVyIHRoYW4g
ZXRoZXJuZXQgZGV2aWNlPw0KSXQgY2FuIGJlLiBBbmQgaXQgY2FuIGJlIHVzZWQgZm9yIG5ldHdv
cmtpbmcgZGV2aWNlcyB0b28gYW5kIGhlbmNlIGl0IGlzIGF0dGFjaGVkIHRvIHNpbmdsZSBuZXQg
bnMuDQo=
