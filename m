Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD652EA565
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 07:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbhAEGXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 01:23:38 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9690 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728013AbhAEGXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 01:23:38 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff405c10000>; Mon, 04 Jan 2021 22:22:57 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 Jan
 2021 06:22:57 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 5 Jan 2021 06:22:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SpMKjaLwl1rtIgXIke/haQ3MOAIlcn6yksGEzxUqtzuydGzTmJpH0t9evXSx22OufhevfPzMa3lIQY4GalPqPh/VNFNRP7yYDXLthl9fQdJFgHcSgiznhu1S7ohggT0fcHtuj4xohCuV2afdkXUOAY123ODJLjYUwn4pP/DOI1zpumTruHBPCgEaIP9YbHqy2okCE0DlMJGugniJPe6mSEP6tzbW1Sx8oWpTJeXnMmKgI5CXEUN+CD/8BhK3vGvK6Rn7uaygGkViGE6u0xHE9qPa184+ow2rgiP2w1XcKKwHPF/onUAgIlZeOLQeFiF1dOxPMU0hWMLxtJTWk9tERA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G9JC+mNsTz3kwG1NaFcOltGCoLPm7hBYzMBYRO0MAek=;
 b=C8/U/l61kmPVl4i4oY5JTgOWD20XWunZo5IWoK5ImxV7QPWAWCSbl7s9uMMhgL5JQI/f9jeo5H3h9XhFJ0yT47Zl+WoiUojO3A0Lv0/QyaFi9Ci2U5WlBRAYtYg1gOJdyDde1aqyYydoYFigcmvOPEl/L1a6Id6UDfOeQ+11vnzvrBsc8j4Vxq4qgvsi2Uc5qXS8VfCIUx9esSKBwyJkahN53sEUoe9HwfsdLKtbPX1nQV9SlpPhu5EtIkS0eRUc6QgZQF+qKg4mt6FcWuSw3z8jirVk6K2EOeuKF2XrgL9bVGXoDT+ZPhlYWcC/3OAHnke/DX9d8hcVikNkbThGLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3111.namprd12.prod.outlook.com (2603:10b6:a03:dd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.21; Tue, 5 Jan
 2021 06:22:55 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%5]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 06:22:55 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
CC:     "mst@redhat.com" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-next v2 7/7] vdpa_sim_net: Add support for user
 supported devices
Thread-Topic: [PATCH linux-next v2 7/7] vdpa_sim_net: Add support for user
 supported devices
Thread-Index: AQHW4ko9h0JE1/siD0Ci/a57He1kKKoXC0cAgAAD48CAAVxwgIAAJfLQ
Date:   Tue, 5 Jan 2021 06:22:55 +0000
Message-ID: <BY5PR12MB4322AC0586A759C44CA44268DCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210104033141.105876-1-parav@nvidia.com>
 <20210104033141.105876-8-parav@nvidia.com>
 <ea07c16e-6bc5-0371-4b53-4bf4c75d5af8@redhat.com>
 <BY5PR12MB43227F9431227959051B90B1DCD20@BY5PR12MB4322.namprd12.prod.outlook.com>
 <2e052c52-44e2-a066-3872-0e20805760f2@redhat.com>
In-Reply-To: <2e052c52-44e2-a066-3872-0e20805760f2@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.222.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc1c304f-43ce-4339-a1ec-08d8b14256c8
x-ms-traffictypediagnostic: BYAPR12MB3111:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3111CDBA09F34E93B66A3327DCD10@BYAPR12MB3111.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: svpFSUwjpI79SZHq31DmFhmxf10ROFyTnEJYiMKoVro+lkvTEQfM+yAYvWv3ymG4IL66sfb9SJ1Wyd4KRhhht0rPeIG1nTP0Gxk+ctoX+V3bQuVs7qKdTQkZ/G500ffFSp+Z7eqzhO2m9f2l7xBOjwQIIVb5lk7Ntmd2Alo0qiv9KZYDk19znZbnNspTiYCZWnIFciyEAux77Ozx+SsAJEzEClPtxkp5IseVGta94IetXEqDA9f03xtOiPhYip9dmBPs3GbhK7dnXKP8WVskggwqdjt+l/3/OXhKIcEmhdzspEyCIav4pVbqbsMVk3xEULnrxiuaCkxDAYj8NsKCxZ9dXiUm0qfG5Y01k2/6QAlYDkA3ad41oOUmzmZnksSzwG9GjG4dAdJAUszo7pn/ow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(366004)(346002)(396003)(136003)(26005)(9686003)(55016002)(64756008)(66476007)(33656002)(2906002)(186003)(110136005)(66446008)(86362001)(6506007)(71200400001)(4326008)(478600001)(66556008)(54906003)(7696005)(66946007)(316002)(76116006)(5660300002)(52536014)(55236004)(8676002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?aXhxSHA2dzVRTFZJaGhqNTB3ZThXU1hheU16cUhnRnNrOHNDRTdkbzhsMUkz?=
 =?utf-8?B?TnE2WnNUT1ZURWplWmZieEZEMmFpSVQ3cjlUTm5XM0Y2bzF2SXh3d3FiRGth?=
 =?utf-8?B?ZmFrUUZuQkl1bFF6Q0FuSEpvY3hYa1VUUFVHcDlEYkk2QzRhd05DSlRBOUNu?=
 =?utf-8?B?UXJxOENIVHlSNjR5NS9zem9icCtQZjIyRlhaZkFMQU56RGNFaVNSczl3aU10?=
 =?utf-8?B?dDA0OE9PY2J3MUhtYzNzU1MzTnErSU1CM1BXbVIyVURMK3E2ZHhEZy9udnhF?=
 =?utf-8?B?aUtLdzN0SGprRWNNZmJGUHdCOWVNZGVLOXFEQjZmRmUzOVhIaTdsMTBNTHdP?=
 =?utf-8?B?S1REbEVjUGxRRC8wellwNWZYQ1R1RXp1elI0YlUwQUF0SEI5YmFRdnNuUUR6?=
 =?utf-8?B?RFpZVGJBL1pXY2hhbnVIK0JKSzlibDVrZ0p3R0RHY2tCeTErMldZMmtad0xO?=
 =?utf-8?B?R3lJZEp4c3haSklPeUVHRURVWnFoLzhBS05OOWJqUGhlMlBBdmw2dm9FVWFE?=
 =?utf-8?B?V2hZQW9zNU1nOUZxVUJsc3Zncm9TdUh3Yi81cy9qWk9VSkNuQnAzVktBeCtT?=
 =?utf-8?B?R3ZlM3V6YWN0MzZ6dUt1ZXBsdzFGc1hzVFY4Q1hyZzU3QXVXdlFCSTVzVEZN?=
 =?utf-8?B?N2FyallKcTVkK1VpOG1kS1llek1iZmpzcC9BVUJrN2VtS1NvM2hKZHdLSTFO?=
 =?utf-8?B?UGpEZXhUTVRRM0NJcFNlMytqWHFoUEJacjA1MldxeFMwNFlPdWNqTWFDNC9L?=
 =?utf-8?B?ZnlwemV1Uy95cTZZUTVPYkVCS3pqaG1aWnUxYzdNUWhxYThLWU4yOE04T2Ex?=
 =?utf-8?B?TDliYVlHNWxjVmZRZFBlY1Z0YXZEeXlxUGlhZ2gxd2d1ZUJ6L21DRnZPQURk?=
 =?utf-8?B?SmRkNEVxeUF4dkFtMmJSYmFHaGNxVFRKR0xGbnlQS1dXbnJZYTg4NnJPZ0py?=
 =?utf-8?B?M05GMW1TcHpaenFwQm1kV2tuUWpQYWxjT2UzaUo1eVB4NDdVcDFGRTlhSzN3?=
 =?utf-8?B?N2RoN3RwWkFyZzNaamdrYmg2YzMwUmV6akZ0QXNGYjhsKzd1OHNIZTdOYkNQ?=
 =?utf-8?B?T2ViVnZBYSsxTGlmVDFhdk94cmdWLzhJay9pOUJKajVpVlJYdE1ZTE1vV3lX?=
 =?utf-8?B?VUhjMzFMWTMrVnBnTlVYNEF5dTBWdmtQMks1M09obWIxbjBHaWlXSm1YU09l?=
 =?utf-8?B?alpHMmpYYTdvbnUxc0RXMHhLOUVUOHRxZE84S1BHYkdJbmNyQTVvR3k4Z204?=
 =?utf-8?B?Y0IvYWM5THRrS0dCM0lhaEJ0WXF6cHpYZElyUHJxdjRZbklLNHlkZWVQL3h4?=
 =?utf-8?Q?0S8PDFKbfwGeY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc1c304f-43ce-4339-a1ec-08d8b14256c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 06:22:55.3617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d1znomYXEldqZEKrXt6Oz+3IJ3ICzdZv7HVXiPuLbNWAJ0P9W4jGFdbev1HZyptBgSsKDd5u6TofQGR2eP1ePg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3111
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609827777; bh=G9JC+mNsTz3kwG1NaFcOltGCoLPm7hBYzMBYRO0MAek=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
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
        b=XU+mqJkr9ez5GnJHHMXRXttDKGTwWVPmdPZ84RaJbjX9ngoKSQ7zEmtTEW2tCqEy3
         aNt4Xausy3S+Cm622T3h8uNqe28orj/qBg7lmFd7xu/Hhue6pF/4FQiLcI/JnHo4nR
         t1muF0ZQDVj++hFxLkWbn71rbCcrv13/2BcWDBhsbWL0kN4b37r8Oep2+YFtaSZf6p
         svl75RfenJxoLZ2Bu4nLOxgQ/9l8/ORoPizwJGBVUWOEbMubB4CD/XKckn/C19uKEf
         dJ4MBDOig0ENWDnCx3oMCRxL5Cop3v6uaHAyBGy4Tq1LWEmIhFVH4f5DzOnxCzmPwl
         HxtlYop7EXJQg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gU2VudDogVHVl
c2RheSwgSmFudWFyeSA1LCAyMDIxIDk6MzYgQU0NCj4gDQo+IA0KPiBPbiAyMDIxLzEvNCDkuIvl
jYgzOjIxLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4NCj4gPj4gRnJvbTogSmFzb24gV2FuZyA8
amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gPj4gU2VudDogTW9uZGF5LCBKYW51YXJ5IDQsIDIwMjEg
MTI6MzUgUE0NCj4gPj4NCj4gPj4gT24gMjAyMS8xLzQg5LiK5Y2IMTE6MzEsIFBhcmF2IFBhbmRp
dCB3cm90ZToNCj4gPj4+ICAgIHN0YXRpYyBpbnQgX19pbml0IHZkcGFzaW1fbmV0X2luaXQodm9p
ZCkNCj4gPj4+ICAgIHsNCj4gPj4+ICAgIAlpbnQgcmV0ID0gMDsNCj4gPj4+IEBAIC0xNzYsNiAr
MjY0LDggQEAgc3RhdGljIGludCBfX2luaXQgdmRwYXNpbV9uZXRfaW5pdCh2b2lkKQ0KPiA+Pj4N
Cj4gPj4+ICAgIAlpZiAoZGVmYXVsdF9kZXZpY2UpDQo+ID4+PiAgICAJCXJldCA9IHZkcGFzaW1f
bmV0X2RlZmF1bHRfZGV2X3JlZ2lzdGVyKCk7DQo+ID4+PiArCWVsc2UNCj4gPj4+ICsJCXJldCA9
IHZkcGFzaW1fbmV0X21nbXRkZXZfaW5pdCgpOw0KPiA+Pj4gICAgCXJldHVybiByZXQ7DQo+ID4+
PiAgICB9DQo+ID4+Pg0KPiA+Pj4gQEAgLTE4Myw2ICsyNzMsOCBAQCBzdGF0aWMgdm9pZCBfX2V4
aXQgdmRwYXNpbV9uZXRfZXhpdCh2b2lkKQ0KPiA+Pj4gICAgew0KPiA+Pj4gICAgCWlmIChkZWZh
dWx0X2RldmljZSkNCj4gPj4+ICAgIAkJdmRwYXNpbV9uZXRfZGVmYXVsdF9kZXZfdW5yZWdpc3Rl
cigpOw0KPiA+Pj4gKwllbHNlDQo+ID4+PiArCQl2ZHBhc2ltX25ldF9tZ210ZGV2X2NsZWFudXAo
KTsNCj4gPj4+ICAgIH0NCj4gPj4+DQo+ID4+PiAgICBtb2R1bGVfaW5pdCh2ZHBhc2ltX25ldF9p
bml0KTsNCj4gPj4+IC0tIDIuMjYuMg0KPiA+Pg0KPiA+PiBJIHdvbmRlciB3aGF0J3MgdGhlIHZh
bHVlIG9mIGtlZXBpbmcgdGhlIGRlZmF1bHQgZGV2aWNlIHRoYXQgaXMgb3V0DQo+ID4+IG9mIHRo
ZSBjb250cm9sIG9mIG1hbmFnZW1lbnQgQVBJLg0KPiA+IEkgdGhpbmsgd2UgY2FuIHJlbW92ZSBp
dCBsaWtlIGhvdyBJIGRpZCBpbiB0aGUgdjEgdmVyc2lvbi4gQW5kIGFjdHVhbCB2ZW5kb3INCj4g
ZHJpdmVycyBsaWtlIG1seDVfdmRwYSB3aWxsIGxpa2VseSBzaG91bGQgZG8gb25seSB1c2VyIGNy
ZWF0ZWQgZGV2aWNlcy4NCj4gPiBJIGFkZGVkIG9ubHkgZm9yIGJhY2t3YXJkIGNvbXBhdGliaWxp
dHkgcHVycG9zZSwgYnV0IHdlIGNhbiByZW1vdmUgdGhlDQo+IGRlZmF1bHQgc2ltdWxhdGVkIHZk
cGEgbmV0IGRldmljZS4NCj4gPiBXaGF0IGRvIHlvdSByZWNvbW1lbmQ/DQo+IA0KPiANCj4gSSB0
aGluayB3ZSdkIGJldHRlciBtYW5kYXRlIHRoaXMgbWFuYWdlbWVudCBBUEkuIFRoaXMgY2FuIGF2
b2lkIHZlbmRvcg0KPiBzcGVjaWZpYyBjb25maWd1cmF0aW9uIHRoYXQgbWF5IGNvbXBsZXggbWFu
YWdlbWVudCBsYXllci4NCj4gDQpTb3VuZHMgZ29vZC4NCkkgd2lsbCBkcm9wIHRoZSBwYXRjaCB0
aGF0IGFsbG93cyB2ZHBhc2ltX25ldCBkZWZhdWx0IGRldmljZSB2aWEgbW9kdWxlIHBhcmFtZXRl
ci4gV2lsbCBwb3N0IHYzIHdpdGggdGhhdCByZW1vdmFsLg0K
