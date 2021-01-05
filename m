Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06A82EA579
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 07:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbhAEGeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 01:34:36 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10356 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbhAEGef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 01:34:35 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff408530001>; Mon, 04 Jan 2021 22:33:55 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 Jan
 2021 06:33:55 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.58) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 5 Jan 2021 06:33:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W67QDjPeWQyOKmk2qAE68J32+e8ACdeeOBvuVY+cy1Ywpo/9uTBhfb6gHq+wM8Nn/oklsZrIqo4jWXmyW0wXMw/EWbaL51A2H/Yvh7igCYZUxzd0PoszX3vTwVD+IOImhlHWuLxsLFIQBM7Nucig+llww3GQHc4J80tnD4dLdawBJxej//fdQrZwZJej/5LWmBmflVaTnC35xjZlnXqLgIJtiFETiuQL05R6pf0tiYXGaPp0eDyVSpuvndkazJGGvTJbF9gglIqfmZ5Elmkf6UoODdYzJfEkSOK6gl/en/p/wNAZzCA9YzaDlnAcWPVkH/cAuxANKn7JZUtpMECPQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QiiAEd++sC8TTqpXhz6oejNuFS/z5qpiihyBb8b9O6I=;
 b=lVhkh+wq7G30po+vSrSyuxvvLERKxMJ0gk66EEIOVhV6TUChYVItY+156xwOu18e8a46WzAW/VxXrfCkpPlMlu9VDAmBKXFNvDMU84HezDnm8LfRBVodqNQlupAYtVG1tt0dFjNBmA92WHevXXnNu8E807ixmI2eb3ZaiwSh6dJbE4KUUclBwl5DxrKM3kqBiTOI+kOYNtUzqB92HCOdLKtI4CI9DyANhcVR4BBfxZZNzOxBsmM6yYDx/ALa40i8liIvvLFVSe1yNFLWX4C85iyAqlRMH12HtsKwAhVj251Fn3K8cwEvWUJx+A4p2CAjy+04Xx5vPrB/9SS1cj/GEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2869.namprd12.prod.outlook.com (2603:10b6:a03:132::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.21; Tue, 5 Jan
 2021 06:33:53 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%5]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 06:33:53 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
CC:     "mst@redhat.com" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-next v2 4/7] vdpa: Define vdpa mgmt device, ops and
 a netlink interface
Thread-Topic: [PATCH linux-next v2 4/7] vdpa: Define vdpa mgmt device, ops and
 a netlink interface
Thread-Index: AQHW4ko6qlHRm93SwkGgKhE4ETo8PaoXCs2AgAAFMiCAAVyygIAAJWQA
Date:   Tue, 5 Jan 2021 06:33:53 +0000
Message-ID: <BY5PR12MB4322EB5AD78BBAB2311AD877DCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210104033141.105876-1-parav@nvidia.com>
 <20210104033141.105876-5-parav@nvidia.com>
 <b08ede5d-e393-b4f8-d1d8-2aa29e409872@redhat.com>
 <BY5PR12MB432236DE09EBC2E584C07FCDDCD20@BY5PR12MB4322.namprd12.prod.outlook.com>
 <b7a4602d-daae-dde1-a064-2ee07cf84309@redhat.com>
In-Reply-To: <b7a4602d-daae-dde1-a064-2ee07cf84309@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.222.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 64d8fb62-3354-462d-96af-08d8b143df19
x-ms-traffictypediagnostic: BYAPR12MB2869:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB28694FC3F405F5CFD53D47A0DCD10@BYAPR12MB2869.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rcqbLSX36YqQbR4Uu63iDvLhjxGBNN+G8SPJX5n5jaxQSbF0S5cMzrLfpuA05CspQvanSD1IFZIQJbC4D5ZKAoVw3ig+dSHJiBXu7SJx7BQl3JqanopX6McoOgVI8CnyhQ7hy4x6MFtMRQAm8HnxJWzmJjgyrNiEGONdL/dYLfshDmgHEJvbF6lXnQhofwI/uroT14Y3aTtsL3GAImKoz1rQMwvbr7SZg+10lUBUkvS+g1vYoB6hlQX5wJRj/omQrxABqL8qe3aKVBBknjmZJD4ARm9jt76SchAClkVdZnOOSZSQZ7XY/wHyKhI5KCjrBgztJ5fshJH2jgQJ60nN7nPWJvp76bD8oXQuUAO54IF6gWwlYoqx8KQDzR7FJ06Opk5HgE0xyz/GAbfbBbMXhA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(376002)(346002)(136003)(7696005)(8936002)(5660300002)(66946007)(4326008)(66476007)(76116006)(66446008)(55016002)(64756008)(26005)(83380400001)(2906002)(478600001)(316002)(86362001)(6506007)(186003)(33656002)(8676002)(66556008)(71200400001)(110136005)(55236004)(9686003)(52536014)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UnprS1NUYWdFYVJ1ekFmTVoyMnhSRTJWUHArajZ4Y2JpVnNiRzdrUWZLTm55?=
 =?utf-8?B?eGI4eHZIc2FCc3oyVmdlY3FzeWtVNDlKZWdOZ3BqdHgveUZiOVdQWDRaTkd6?=
 =?utf-8?B?S1J1aW9PTmhhUlJ2QjBQWUNtK2Q1dUQ3RUpnbEFmQzhtbFg2eFdhRC9RRXpZ?=
 =?utf-8?B?S0x3aHZOT2pJM21HS3VwZXc0V0hGb0JNeGtHdHQ3d1N4M1p6RkJidlFXTXk0?=
 =?utf-8?B?YVIwanJnN3VJUUZBaWt1UEZPNTRGY2lobHc1a1RjUzYwNloxbXcvOC9PZmJu?=
 =?utf-8?B?aE9xZmdRRE1kMGUzNS81UDZWTlF1R1FKd2pyVE5vQWU0MFNGbHBCdnl3NTcz?=
 =?utf-8?B?Y00xMEtsQ0ZKcTJCVUp1ZFlyNGl3SlRCNkl2aG4veGtqMDFJcDA4WDdqOUpC?=
 =?utf-8?B?RG44SVVPWHF2ajR6RE02dWgxNUt5MnIva01sVVRDVVhoUk9aWXFpVWpyZ3hw?=
 =?utf-8?B?VDFhVW5pZ014aHNTTWh1anVSUnZnV2t5V3VnclpwMVZRYUwwdjhFUlA3ODZC?=
 =?utf-8?B?S1NNd3M2blQzaTFGV1BXYXI5SlI0Q1dlcWhXbFlicU1TdVpHOExPWnR4VDRV?=
 =?utf-8?B?S3B2ZUxsUTNqVTFuNi9pNmpQRjBjenFkbW95K1ovN0srUlk3VHFkODR1aXBh?=
 =?utf-8?B?WmNienNuajFSRWJxU0NRWHp6NnJPWDBEdXVKVnYzS1E1cVMyNHpSRE8wZyt3?=
 =?utf-8?B?d1hYeTFkT0w2STNTZDhtYk5DbllleXZYbkVESVprKzlKOGtqQlc4UHI1Slc5?=
 =?utf-8?B?NWRXWjFob0hHMWdVNWhmQVN6N2lmbmtWZ0Y0YThUY3BUdTV0aE9LZER0NDVF?=
 =?utf-8?B?Nm9GdG4rVkIvSElqdFBWUDhpL1JIMVFtT3NLUW5OeXdvbWE2MWtPRit5M056?=
 =?utf-8?B?YjFHayt4YmNWdkhXbmN0dVRwUVhHRVM1aTI2aU1aRUlrTkkzbkVVOWZJMzdt?=
 =?utf-8?B?dTFaUGxWa3hmSjg3b3JmWXQ0M0E4UHdkbXhiMXVlSnphMG0rRTFtVlF2Q3JY?=
 =?utf-8?B?N1JjdDloR0xqT09CMXFodFJCQTFINVIwU1ZnSXN3aEpvY3RQNEZtK0pZZm10?=
 =?utf-8?B?dmRhZndabnQwRzN2ZkN4amJuVk9SZFlMVnNBT0VWMUZ2ZHZReUJoRWxOaXJK?=
 =?utf-8?B?VVJZbitmZjNjNXBscVFSTXdISUVhaHFPWXRYSmdscndNTlIwZm1scjdLYno5?=
 =?utf-8?B?c0E1NHFxcVdpR2tyWDA1aTV3KzRxUm9nd0xGc2pZMWUyZ2cvTmM3UlRNc0Fh?=
 =?utf-8?B?WEY3MUpTNXJ1VEdDTnBGanBVeWhRQjdRT0wyYXMwTSthY1Y3NG5kQlFxdWxa?=
 =?utf-8?Q?IlFjkgkFZufAM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64d8fb62-3354-462d-96af-08d8b143df19
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 06:33:53.5392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LdvCwqdNu7LBvxAA632LDsUVbX/fpoe/z5pL9Ii2qygJ9XCigvm3gGXagU0MnPMhh5qA3YLlFTDUUwLM6iXLQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2869
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609828435; bh=QiiAEd++sC8TTqpXhz6oejNuFS/z5qpiihyBb8b9O6I=;
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
        b=Z/oQTtZ9nnWNDpVvvVygnip5/ObDtjDhzMJL45uQ7KczeOfYB0uOHSpjVdReeSIKu
         3sg0PwVF8p4qwUu9KH2JEvci1FKlT9vIlAVc7BT05p3PU+LVC6ofF2S0hIEeIbt4OT
         28JeIsezv3hIm7ckYBOS3r6kcbQXrQwxgoG/bNU/xlrCVIyHqkoT5nBmjPVbOkn5Yi
         kfNd9IVTgjhYIzTRbLZYMLpE7YzI0YiuTNaaJNgYCk3pb1dUqOLmww8bksqzTEtDuf
         0aJLxbU1ytA1q5LYO96bdwfESQYNyeO4PMkMGPFzfgj7zMMzaeMVCQyqQaLcxF/7Bf
         eUH2qnxxh4Yzw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gU2VudDogVHVl
c2RheSwgSmFudWFyeSA1LCAyMDIxIDk6NDAgQU0NCj4gDQo+IE9uIDIwMjEvMS80IOS4i+WNiDM6
MjQsIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPg0KPiA+PiBGcm9tOiBKYXNvbiBXYW5nIDxqYXNv
d2FuZ0ByZWRoYXQuY29tPg0KPiA+PiBTZW50OiBNb25kYXksIEphbnVhcnkgNCwgMjAyMSAxMjoz
MyBQTQ0KPiA+Pg0KPiA+PiBPbiAyMDIxLzEvNCDkuIrljYgxMTozMSwgUGFyYXYgUGFuZGl0IHdy
b3RlOg0KPiA+Pj4gVG8gYWRkIG9uZSBvciBtb3JlIFZEUEEgZGV2aWNlcywgZGVmaW5lIGEgbWFu
YWdlbWVudCBkZXZpY2Ugd2hpY2gNCj4gPj4+IGFsbG93cyBhZGRpbmcgb3IgcmVtb3ZpbmcgdmRw
YSBkZXZpY2UuIEEgbWFuYWdlbWVudCBkZXZpY2UgZGVmaW5lcw0KPiA+Pj4gc2V0IG9mIGNhbGxi
YWNrcyB0byBtYW5hZ2UgdmRwYSBkZXZpY2VzLg0KPiA+Pj4NCj4gPj4+IFRvIGJlZ2luIHdpdGgs
IGl0IGRlZmluZXMgYWRkIGFuZCByZW1vdmUgY2FsbGJhY2tzIHRocm91Z2ggd2hpY2ggYQ0KPiA+
Pj4gdXNlciBkZWZpbmVkIHZkcGEgZGV2aWNlIGNhbiBiZSBhZGRlZCBvciByZW1vdmVkLg0KPiA+
Pj4NCj4gPj4+IEEgdW5pcXVlIG1hbmFnZW1lbnQgZGV2aWNlIGlzIGlkZW50aWZpZWQgYnkgaXRz
IHVuaXF1ZSBoYW5kbGUNCj4gPj4+IGlkZW50aWZpZWQgYnkgbWFuYWdlbWVudCBkZXZpY2UgbmFt
ZSBhbmQgb3B0aW9uYWxseSB0aGUgYnVzIG5hbWUuDQo+ID4+Pg0KPiA+Pj4gSGVuY2UsIGludHJv
ZHVjZSByb3V0aW5lIHRocm91Z2ggd2hpY2ggZHJpdmVyIGNhbiByZWdpc3RlciBhDQo+ID4+PiBt
YW5hZ2VtZW50IGRldmljZSBhbmQgaXRzIGNhbGxiYWNrIG9wZXJhdGlvbnMgZm9yIGFkZGluZyBh
bmQgcmVtb3ZlDQo+ID4+PiBhIHZkcGEgZGV2aWNlLg0KPiA+Pj4NCj4gPj4+IEludHJvZHVjZSB2
ZHBhIG5ldGxpbmsgc29ja2V0IGZhbWlseSBzbyB0aGF0IHVzZXIgY2FuIHF1ZXJ5DQo+ID4+PiBt
YW5hZ2VtZW50IGRldmljZSBhbmQgaXRzIGF0dHJpYnV0ZXMuDQo+ID4+Pg0KPiA+Pj4gRXhhbXBs
ZSBvZiBzaG93IHZkcGEgbWFuYWdlbWVudCBkZXZpY2Ugd2hpY2ggYWxsb3dzIGNyZWF0aW5nIHZk
cGENCj4gPj4+IGRldmljZSBvZiBuZXR3b3JraW5nIGNsYXNzIChkZXZpY2UgaWQgPSAweDEpIG9m
IHZpcnRpbyBzcGVjaWZpY2F0aW9uDQo+ID4+PiAxLjEgc2VjdGlvbiA1LjEuMS4NCj4gPj4+DQo+
ID4+PiAkIHZkcGEgbWdtdGRldiBzaG93DQo+ID4+PiB2ZHBhc2ltX25ldDoNCj4gPj4+ICAgICBz
dXBwb3J0ZWRfY2xhc3NlczoNCj4gPj4+ICAgICAgIG5ldA0KPiA+Pj4NCj4gPj4+IEV4YW1wbGUg
b2Ygc2hvd2luZyB2ZHBhIG1hbmFnZW1lbnQgZGV2aWNlIGluIEpTT04gZm9ybWF0Lg0KPiA+Pj4N
Cj4gPj4+ICQgdmRwYSBtZ210ZGV2IHNob3cgLWpwDQo+ID4+PiB7DQo+ID4+PiAgICAgICAic2hv
dyI6IHsNCj4gPj4+ICAgICAgICAgICAidmRwYXNpbV9uZXQiOiB7DQo+ID4+PiAgICAgICAgICAg
ICAgICJzdXBwb3J0ZWRfY2xhc3NlcyI6IFsgIm5ldCIgXQ0KPiA+Pj4gICAgICAgICAgIH0NCj4g
Pj4+ICAgICAgIH0NCj4gPj4+IH0NCj4gPj4+DQo+ID4+PiBTaWduZWQtb2ZmLWJ5OiBQYXJhdiBQ
YW5kaXQ8cGFyYXZAbnZpZGlhLmNvbT4NCj4gPj4+IFJldmlld2VkLWJ5OiBFbGkgQ29oZW48ZWxp
Y0BudmlkaWEuY29tPg0KPiA+Pj4gUmV2aWV3ZWQtYnk6IEphc29uIFdhbmc8amFzb3dhbmdAcmVk
aGF0LmNvbT4NCj4gPj4+IC0tLQ0KPiA+Pj4gQ2hhbmdlbG9nOg0KPiA+Pj4gdjEtPnYyOg0KPiA+
Pj4gICAgLSByZWJhc2VkDQo+ID4+PiAgICAtIHVwZGF0ZWQgY29tbWl0IGxvZyBleGFtcGxlIGZv
ciBtYW5hZ2VtZW50IGRldmljZSBuYW1lIGZyb20NCj4gPj4+ICAgICAgInZkcGFzaW0iIHRvICJ2
ZHBhc2ltX25ldCINCj4gPj4+ICAgIC0gcmVtb3ZlZCBkZXZpY2VfaWQgYXMgbmV0IGFuZCBibG9j
ayBtYW5hZ2VtZW50IGRldmljZXMgYXJlDQo+ID4+PiBzZXBhcmF0ZWQNCj4gPj4NCj4gPj4gU28g
SSB3b25kZXIgd2hldGhlciB0aGVyZSBjb3VsZCBiZSBhIHR5cGUgb2YgbWFuYWdlbWVudCBkZXZp
Y2VzIHRoYXQNCj4gPj4gY2FuIGRlYWwgd2l0aCBtdWx0aXBsZSB0eXBlcyBvZiB2aXJ0aW8gZGV2
aWNlcy4gSWYgeWVzLCB3ZSBwcm9iYWJseQ0KPiA+PiBuZWVkIHRvIGFkZCBkZXZpY2UgaWQgYmFj
ay4NCj4gPiBBdCB0aGlzIHBvaW50IG1seDUgcGxhbiB0byBzdXBwb3J0IG9ubHkgbmV0Lg0KPiA+
IEl0IGlzIHVzZWZ1bCB0byBzZWUgd2hhdCB0eXBlIG9mIHZkcGEgZGV2aWNlIGlzIHN1cHBvcnRl
ZCBieSBhIG1hbmFnZW1lbnQNCj4gZGV2aWNlLg0KPiA+DQo+ID4gSW4gZnV0dXJlIGlmIGEgbWdt
dCBkZXYgc3VwcG9ydHMgbXVsdGlwbGUgdHlwZXMsIHVzZXIgbmVlZHMgdG8gY2hvb3NlDQo+IGRl
c2lyZWQgdHlwZS4NCj4gPiBJIGd1ZXNzIHdlIGNhbiBkaWZmZXIgdGhpcyBvcHRpb25hbCB0eXBl
IHRvIGZ1dHVyZSwgd2hlbiBzdWNoIG1nbXQuIGRldmljZQ0KPiB3aWxsL21heSBiZSBhdmFpbGFi
bGUuDQo+IA0KPiANCj4gSSB3b3JyeSBpZiB3ZSByZW1vdmUgZGV2aWNlX2lkLCBpdCBtYXkgZ2l2
ZXMgYSBoaW50IHRoYXQgbXVsdGlwbGUgbWdtdA0KPiBkZXZpY2VzIG5lZWRzIHRvIGJlIHJlZ2lz
dGVyZWQgaWYgaXQgc3VwcG9ydHMgbXVsdGlwbGUgdHlwZXMuDQo+IA0KTm8gaXQgc2hvdWxkbid0
LiBiZWNhdXNlIHdlIGRvIGV4cG9zZSBtdWx0aXBsZSBzdXBwb3J0ZWQgdHlwZXMgaW4gbWdtdGRl
diBhdHRyaWJ1dGVzLg0KDQo+IFNvIGlmIHBvc3NpYmxlIEkgd291bGQgbGlrZSB0byBrZWVwIHRo
ZSBkZXZpY2VfaWQgaGVyZS4NCj4gDQpJdHMgcG9zc2libGUgdG8ga2VlcCBpdC4gQnV0IHdpdGgg
Y3VycmVudCBkcml2ZXJzLCBtYWlubHkgbWx4NSBhbmQgdmRwYV9zaW0sIGl0IGlzIHJlZHVuZGFu
dC4NCk5vdCBzdXJlIG9mIHRoZSBpZmMncyBwbGFuLg0KV2UgaGF2ZSBiZWVuIHNwbGl0dGluZyBt
b2R1bGVzIHRvIGhhbmRsZSBuZXQgYW5kIGJsb2NrIGRpZmZlcmVudGx5IGluIG1seDUgYXMgd2Vs
bCBhcyB2ZHBhX3NpbS4NClNvIGl0IGxvb2tzIHRvIG1lIHRoYXQgYm90aCBtYXkgYmUgc2VwYXJh
dGUgbWFuYWdlbWVudCBkcml2ZXJzIChhbmQgbWFuYWdlbWVudCBkZXZpY2VzKS4NClN1Y2ggYXMg
dmRwYXNpbV9uZXQgYW5kIHZkcGFzaW1fYmxvY2suDQptbHg1IGRvZXNuJ3QgaGF2ZSBwbGFuIGZv
ciBibG9jayB5ZXQuDQo=
