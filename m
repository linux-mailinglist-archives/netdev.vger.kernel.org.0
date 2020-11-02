Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF5F2A2613
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 09:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgKBI1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 03:27:24 -0500
Received: from mail-bn7nam10on2067.outbound.protection.outlook.com ([40.107.92.67]:12352
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728171AbgKBI1Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 03:27:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KOJDnh9AK3Hsn0sDnrwRyL7GV8D1M9/eTb7fZk8JaMf2ksjylZOmwVwbmxhcYoJTO8BXd/baed1geB/IUQKIjKn6b0P+sdV+sbLcWUYuj0ilYC6f5OLKxeM0BwP6aRqIih7+Gx0q346dZvIzZp4Lxe/Ue1NWN3LDpEwNMFfmGtQ4sMer2TS4WXl8pep+MCnW1CmNC5Ki6n6ORZ+YIlthMKQcoJYbluYK7GO9UzHJt3yXoopuEpo3lCfcP7Nw3lBa2d2UIchbcCBkgbcQEWMDJ8AGn6Uzrf2PzubEXjMuqltPNIOK4zKtObnUbu24/LNzGnPuACbSeC18e5VDmB0q2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqDg8SiuA3rATvZZ0y8IwrxHdD9g2l29Hqbon2JLf34=;
 b=eEZ+hdSEPo+2C1J8IpiyBZ0kgZ4/2KIQIODFEkMyonRrdX0pZosjzJi0nZtl6McAD6U8FSsEj9PYhz4RCoR2VfX13UJH2MN9kVo5JmQRxuWW0FseETP97dXQ7mKyLhRnPPWVic101ohxOizR4DKVoimslYc4vsnqwO+UM3bVmlRztgRJzeMMryYULm7tR/ircVaPvwWtrdNRdQ0zII8rjdhjYtUAhdexZpPNqFFVwo9s8eyt+BJT2d6PnDtJFy6sIGO/3aUOh3E+hJqKRhY6JyZ/gUoKahJSHelP2MlLAXDGturhkGRxIZSf6Lby1G/pQueTYhE59GrraJ/ql3/73A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqDg8SiuA3rATvZZ0y8IwrxHdD9g2l29Hqbon2JLf34=;
 b=HbOMsXQuTrD8cgXRlvL//ae6A8Cnsjnh3BqHLRHNs0Y7qWKQbkQLZhwYFuf8HLrECmPCht0fg4h0Xct5MGZ86dX7wXFlJxOJ28iOtuzpwQlnZwI3jr7kkCASau43WlR4Y3zIgasFzJ8AIzpofH/zh58CFVN2ga+IetfIFJneo80=
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 (2603:10b6:910:45::21) by CY4PR1001MB2167.namprd10.prod.outlook.com
 (2603:10b6:910:43::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Mon, 2 Nov
 2020 08:27:20 +0000
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::a4b0:cd03:3459:6853]) by CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::a4b0:cd03:3459:6853%2]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 08:27:20 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: arping stuck with ENOBUFS in 4.19.150
Thread-Topic: arping stuck with ENOBUFS in 4.19.150
Thread-Index: AQHWqIbAhm/w52lyHEuPPxU5ZaHMxKmp3kiAgABdAgCABG5JAIAAEvCAgACsogCAAKukgIAA6e6AgAOUMIA=
Date:   Mon, 2 Nov 2020 08:27:20 +0000
Message-ID: <b172b4dad96e519b2f49034ab627f1d666b3df63.camel@infinera.com>
References: <9bede0ef7e66729034988f2d01681ca88a5c52d6.camel@infinera.com>
         <e09b367a58a0499f3bb0394596a9f87cc20eb5de.camel@infinera.com>
         <777947a9-1a05-c51b-81fc-4338aca3af26@gmail.com>
         <97730e024e7279d67f3eca7e0ef24395e9e08bff.camel@infinera.com>
         <bf33dfc1-8e37-8ac0-7dcb-09002faadc7a@gmail.com>
         <4641f25f-7e7f-5d06-7e00-e1716cbdeddc@huawei.com>
         <0c9f0deeb50d7caef0013125353b3bf1260c03c4.camel@infinera.com>
         <0e69e590-ad4e-ade4-4ed3-f28e39e3d9c7@huawei.com>
In-Reply-To: <0e69e590-ad4e-ade4-4ed3-f28e39e3d9c7@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.1 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fccdb636-dfe1-43ba-178c-08d87f091df1
x-ms-traffictypediagnostic: CY4PR1001MB2167:
x-microsoft-antispam-prvs: <CY4PR1001MB2167FD6C45741B934877DAD5F4100@CY4PR1001MB2167.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: evAGhlps8ZLgFkVt4yjJqLBXLfx+zlFs9G6GvPnFNMDyXj5TR9eeEI6psNofJkSKIKj+v8OM8b8H8J0O1cHeog2Z1k3xnyGbSLVLlXGI0pYM9ob8axDPmSqr/GwxEPQnjezD2X3KVP2KsmjQq2bYT7VIuUwjqdBVf9pg5qNiZ4v8KaZ/ZkjhzQVgaVN2b2M7RAnK4sMvXYG98pCazmTZ32xnfLHM+XtJ+9hJkX6kgLuk9bG+8keBGJW7Q47MJcpp9v7ZZU4pNy/wozO4f5DcSeZLA+LehqJBMgJ+GRx2GQTiX5KCuinAZ8DOsPFqQek01GORRiWw7ceiX9+fBuJvkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2389.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39850400004)(376002)(366004)(2616005)(53546011)(26005)(6512007)(4001150100001)(36756003)(6506007)(86362001)(8676002)(2906002)(478600001)(6486002)(5660300002)(8936002)(64756008)(76116006)(316002)(91956017)(66446008)(66476007)(71200400001)(110136005)(186003)(66946007)(66556008)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: XTtV75H6hwRYowYwdRwdF09y/FLmMGjfkJre5D1EKJsElcPLsdXd53otdFzgSo22K9eAoUNdIUk/qMGFE/rIJnjx0Hcnm0jUr9DLPUMBhpOvpxdqhqHK1uCz6KpTkXgXhNvQ/NbvAkiILbpw30CVviVVkSJdFt16saz08m9mRWWMkNj3TMEjSs39Bq0f6yGeyWgEmPA3HJoErXBmDBLKuQ8MleliOtRij8pwtmEwG3VWfJeu2ksav54hdToE4rLptwsbg3HqsaUn1UBUpyVz9Xt1YM6jJLMk9pwL1JDEP46dUtDtv1NJvG7nrhnqckjo4pCfgEqmUSveSV9VOhmY71U/u79/r/+80fHkSP9kuP9PustKaqRNIXd/Ah8nK8UlIgd16SxKvyfuUXP0jtTWP3zv2YJVFEOMRUNC/lXa6t38+OpLIZeOzOgbU1brr1fWqQzO7FUAi/jnNutkgPmhZZb3LzThsD9EuvmINhl14udVEqXuOtr3UIfZ9JxGe0C+/G/i1NXzFgjU5Ynuc0US/3xSEYECtn3y3ERgKIXQliJUm3SqvVOUGmBOlpDNs3B1PzPR8qThTgFcK0/m6Jbv9LwGpJnUetFfwGd3KzPhp2p7BU0LnKGBUPvIJuFaHV0UYwJJF/8jxHi5EbVoHB4vTg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <070752C4D8B45C4CBB81C286ADBCF156@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2389.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fccdb636-dfe1-43ba-178c-08d87f091df1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2020 08:27:20.5788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SZ7Ei/XLoAxsIUahFuj4NE4vjoUdJKWl4p0xZj9ojbIX+JpMBG119MLdvPIKOM7zxx7BAx7QLcgm3QWCEkKVtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2167
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIwLTEwLTMxIGF0IDA5OjQ4ICswODAwLCBZdW5zaGVuZyBMaW4gd3JvdGU6DQo+
IE9uIDIwMjAvMTAvMzAgMTk6NTAsIEpvYWtpbSBUamVybmx1bmQgd3JvdGU6DQo+ID4gT24gRnJp
LCAyMDIwLTEwLTMwIGF0IDA5OjM2ICswODAwLCBZdW5zaGVuZyBMaW4gd3JvdGU6DQo+ID4gPiBD
QVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6
YXRpb24uIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Ug
cmVjb2duaXplIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4gPiA+
IA0KPiA+ID4gDQo+ID4gPiBPbiAyMDIwLzEwLzI5IDIzOjE4LCBEYXZpZCBBaGVybiB3cm90ZToN
Cj4gPiA+ID4gT24gMTAvMjkvMjAgODoxMCBBTSwgSm9ha2ltIFRqZXJubHVuZCB3cm90ZToNCj4g
PiA+ID4gPiBPSywgYmlzZWN0aW5nICh3YXMgYSBiaXQgb2YgYSBib3RoZXIgc2luY2Ugd2UgbWVy
Z2UgdXBzdHJlYW0gcmVsZWFzZXMgaW50byBvdXIgdHJlZSwgaXMgdGhlcmUgYSB3YXkgdG8ganVz
dCBiaXNlY3QgdGhhdD8pDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gUmVzdWx0IHdhcyBjb21taXQg
Im5ldDogc2NoX2dlbmVyaWM6IGF2aW9kIGNvbmN1cnJlbnQgcmVzZXQgYW5kIGVucXVldWUgb3Ag
Zm9yIGxvY2tsZXNzIHFkaXNjIiAgKDc0OWNjMGIwYzdmM2RjZGZlNTg0MmY5OThjMDI3NGU1NDk4
NzM4NGYpDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gUmV2ZXJ0aW5nIHRoYXQgY29tbWl0IG9uIHRv
cCBvZiBvdXIgdHJlZSBtYWRlIGl0IHdvcmsgYWdhaW4uIEhvdyB0byBmaXg/DQo+ID4gPiA+IA0K
PiA+ID4gPiBBZGRpbmcgdGhlIGF1dGhvciBvZiB0aGF0IHBhdGNoIChsaW55dW5zaGVuZ0BodWF3
ZWkuY29tKSB0byB0YWtlIGEgbG9vay4NCj4gPiA+ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiA+IA0K
PiA+ID4gPiA+IMKgSm9ja2UNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBPbiBNb24sIDIwMjAtMTAt
MjYgYXQgMTI6MzEgLTA2MDAsIERhdmlkIEFoZXJuIHdyb3RlOg0KPiA+ID4gPiA+ID4gDQo+ID4g
PiA+ID4gPiBPbiAxMC8yNi8yMCA2OjU4IEFNLCBKb2FraW0gVGplcm5sdW5kIHdyb3RlOg0KPiA+
ID4gPiA+ID4gPiBQaW5nICAobWF5YmUgaXQgc2hvdWxkIHJlYWQgImFycGluZyIgaW5zdGVhZCA6
KQ0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gwqBKb2NrZQ0KPiA+ID4gPiA+ID4gPiAN
Cj4gPiA+ID4gPiA+ID4gT24gVGh1LCAyMDIwLTEwLTIyIGF0IDE3OjE5ICswMjAwLCBKb2FraW0g
VGplcm5sdW5kIHdyb3RlOg0KPiA+ID4gPiA+ID4gPiA+IHN0cmFjZSBhcnBpbmcgLXEgLWMgMSAt
YiAtVSAgLUkgZXRoMSAwLjAuMC4wDQo+ID4gPiA+ID4gPiA+ID4gLi4uDQo+ID4gPiA+ID4gPiA+
ID4gc2VuZHRvKDMsICJcMFwxXDEwXDBcNlw0XDBcMVwwXDZcMjM0XHZcNiBcdlx2XHZcdlwzNzdc
Mzc3XDM3N1wzNzdcMzc3XDM3N1wwXDBcMFwwIiwgMjgsIDAsIHtzYV9mYW1pbHk9QUZfUEFDS0VU
LCBwcm90bz0weDgwNiwgaWY0LCBwa3R0eXBlPVBBQ0tFVF9IT1NULCBhZGRyKDYpPXsxLCBmZmZm
ZmZmZmZmZmZ9LA0KPiA+ID4gPiA+ID4gPiA+IDIwKSA9IC0xIEVOT0JVRlMgKE5vIGJ1ZmZlciBz
cGFjZSBhdmFpbGFibGUpDQo+ID4gPiA+ID4gPiA+ID4gLi4uLg0KPiA+ID4gPiA+ID4gPiA+IGFu
ZCB0aGVuIGFycGluZyBsb29wcy4NCj4gPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiBp
biA0LjE5LjEyNyBpdCB3YXM6DQo+ID4gPiA+ID4gPiA+ID4gc2VuZHRvKDMsICJcMFwxXDEwXDBc
Nlw0XDBcMVwwXDZcMjM0XDVcMjcxXDM2MlxuXDMyMlwyMTJFXDM3N1wzNzdcMzc3XDM3N1wzNzdc
Mzc3XDBcMFwwXDAiLCAyOCwgMCwge+KAi3NhX2ZhbWlseT1BRl9QQUNLRVQsIHByb3RvPTB4ODA2
LCBpZjQsIHBrdHR5cGU9UEFDS0VUX0hPU1QsIGFkZHIoNik9e+KAizEsDQo+ID4gPiA+ID4gPiA+
ID4gZmZmZmZmZmZmZmZmfeKAiywgMjApID0gMjgNCj4gPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4g
PiA+ID4gPiBTZWVtcyBsaWtlIHNvbWV0aGluZyBoYXMgY2hhbmdlZCB0aGUgSVAgYmVoYXZpb3Vy
IGJldHdlZW4gbm93IGFuZCB0aGVuID8NCj4gPiA+ID4gPiA+ID4gPiBldGgxIGlzIFVQIGJ1dCBu
b3QgUlVOTklORyBhbmQgaGFzIGFuIElQIGFkZHJlc3MuDQo+ID4gPiANCj4gPiA+ICJldGgxIGlz
IFVQIGJ1dCBub3QgUlVOTklORyIgdXN1YWxseSBtZWFuIHVzZXIgaGFzIGNvbmZpZ3VyZSB0aGUg
bmV0ZGV2IGFzIHVwLA0KPiA+ID4gYnV0IHRoZSBoYXJkd2FyZSBoYXMgbm90IGRldGVjdGVkIGEg
bGlua3VwIHlldC4NCj4gPiA+IA0KPiA+ID4gQWxzbyBXaGF0IGlzIHRoZSBvdXRwdXQgb2YgImV0
aHRvb2wgZXRoMSI/DQo+ID4gDQo+ID4gZWNobyAxID4gIC9zeXMvY2xhc3MvbmV0L2V0aDEvY2Fy
cmllcg0KPiA+IGN1My1qb2NrZSB+ICMgYXJwaW5nIC1xIC1jIDEgLWIgLVUgIC1JIGV0aDEgMC4w
LjAuMA0KPiA+IGN1My1qb2NrZSB+ICMgZWNobyAwID4gIC9zeXMvY2xhc3MvbmV0L2V0aDEvY2Fy
cmllcg0KPiA+IGN1My1qb2NrZSB+ICMgYXJwaW5nIC1xIC1jIDEgLWIgLVUgIC1JIGV0aDEgMC4w
LjAuMA0KPiA+IF5DY3UzLWpvY2tlIH4gIyBldGh0b29sIGV0aDENCj4gPiBTZXR0aW5ncyBmb3Ig
ZXRoMToNCj4gPiAJU3VwcG9ydGVkIHBvcnRzOiBbIE1JSSBdDQo+ID4gCVN1cHBvcnRlZCBsaW5r
IG1vZGVzOiAgIDEwMDBiYXNlVC9GdWxsIA0KPiA+IAlTdXBwb3J0ZWQgcGF1c2UgZnJhbWUgdXNl
OiBTeW1tZXRyaWMgUmVjZWl2ZS1vbmx5DQo+ID4gCVN1cHBvcnRzIGF1dG8tbmVnb3RpYXRpb246
IFllcw0KPiA+IAlBZHZlcnRpc2VkIGxpbmsgbW9kZXM6ICAxMDAwYmFzZVQvRnVsbCANCj4gPiAJ
QWR2ZXJ0aXNlZCBwYXVzZSBmcmFtZSB1c2U6IFN5bW1ldHJpYyBSZWNlaXZlLW9ubHkNCj4gPiAJ
QWR2ZXJ0aXNlZCBhdXRvLW5lZ290aWF0aW9uOiBZZXMNCj4gPiAJU3BlZWQ6IDEwTWIvcw0KPiA+
IAlEdXBsZXg6IEhhbGYNCj4gPiAJUG9ydDogTUlJDQo+ID4gCVBIWUFEOiAxDQo+ID4gCVRyYW5z
Y2VpdmVyOiBleHRlcm5hbA0KPiA+IAlBdXRvLW5lZ290aWF0aW9uOiBvbg0KPiA+IAlDdXJyZW50
IG1lc3NhZ2UgbGV2ZWw6IDB4MDAwMDAwMzcgKDU1KQ0KPiA+IAkJCSAgICAgICBkcnYgcHJvYmUg
bGluayBpZmRvd24gaWZ1cA0KPiA+IAlMaW5rIGRldGVjdGVkOiBubw0KPiA+IA0KPiA+IFdlIGhh
dmUgYSB3cml0ZWFibGUgY2FycmllciBzaW5jZSBldGggZGV2aWNlIGlzIFBIWSBsZXNzLiBNYXli
ZSB0aGF0IHBhdGggaXMgZGlmZmVyZW50ID8NCj4gPiBDaGVjayBkcml2ZXJzL25ldC9ldGhlcm5l
dC9mcmVlc2NhbGUvZHBhYS9kcGFfZXRoLmMNCj4gDQo+IFRoZSBhYm92ZSBkaWZmZXJlbmNlIGRv
ZXMgbm90IHNlZW1zIHRvIG1hdHRlci4NCj4gDQo+ID4gDQo+ID4gPiANCj4gPiA+IEl0IHdvdWxk
IGJlIGdvb2QgdG8gc2VlIHRoZSBzdGF0dXMgb2YgbmV0ZGV2IGJlZm9yZSBhbmQgYWZ0ZXIgZXhl
Y3V0aW5nIGFycGluZyBjbWQNCj4gPiA+IHRvby4NCj4gPiANCj4gPiBobW0sIGhvdyBkbyB5b3Ug
bWVhbj8NCj4gDQo+IEkgd2FzIHRyeWluZyB0byBmaW5kIG91dCB3aGVuIHRoZSBuZXRkZXYnIHN0
YXRlIGJlY2FtZSAiZXRoMSBpcyBVUCBidXQgbm90IFJVTk5JTkciLg0KPiANCj4gQW55d2F5LCB3
aGVuIEkgbG9va2VkIGF0IHRoZSBiYWNrcG9ydGVkIHBhdGNoLCBJIGRpZCBmaW5kIG5ldyBxZGlz
YyBhc3NpZ25tZW50IGlzDQo+IG1pc3NpbmcgZnJvbSB0aGUgdXBzdHJlYW0gcGF0Y2guDQo+IA0K
PiBQbGVhc2Ugc2VlIGlmIHRoZSBiZWxvdyBwYXRjaCBmaXggeW91ciBwcm9ibGVtLCB0aGFua3M6
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvbmV0L3NjaGVkL3NjaF9nZW5lcmljLmMgYi9uZXQvc2NoZWQv
c2NoX2dlbmVyaWMuYw0KPiBpbmRleCBiZDk2ZmQyLi40ZTE1OTEzIDEwMDY0NA0KPiAtLS0gYS9u
ZXQvc2NoZWQvc2NoX2dlbmVyaWMuYw0KPiArKysgYi9uZXQvc2NoZWQvc2NoX2dlbmVyaWMuYw0K
PiBAQCAtMTExNiwxMCArMTExNiwxMyBAQCBzdGF0aWMgdm9pZCBkZXZfZGVhY3RpdmF0ZV9xdWV1
ZShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB2b2lkICpfcWRpc2NfZGVmYXVs
dCkNCj4gwqB7DQo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgUWRpc2MgKnFkaXNjID0gcnRubF9k
ZXJlZmVyZW5jZShkZXZfcXVldWUtPnFkaXNjKTsNCj4gKyAgICAgICBzdHJ1Y3QgUWRpc2MgKnFk
aXNjX2RlZmF1bHQgPSBfcWRpc2NfZGVmYXVsdDsNCj4gDQo+IMKgwqDCoMKgwqDCoMKgwqBpZiAo
cWRpc2MpIHsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoIShxZGlzYy0+
ZmxhZ3MgJiBUQ1FfRl9CVUlMVElOKSkNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgc2V0X2JpdChfX1FESVNDX1NUQVRFX0RFQUNUSVZBVEVELCAmcWRp
c2MtPnN0YXRlKTsNCj4gKw0KPiArICAgICAgICAgICAgICAgcmN1X2Fzc2lnbl9wb2ludGVyKGRl
dl9xdWV1ZS0+cWRpc2MsIHFkaXNjX2RlZmF1bHQpOw0KPiDCoMKgwqDCoMKgwqDCoMKgfQ0KPiDC
oH0NCg0KVGhpcyBwYXRjaCBzZWVtIHRvIGhhdmUgcmVzb2x2ZWQgdGhlIHByb2JsZW0sIHRoYW5r
cy4NClBsZWFzZSBDQyBtZSBvbiB0aGUgZm9ybWFsIHBhdGNoIGZvciA0LjE5LngNCg0KIEpvY2tl
DQo=
