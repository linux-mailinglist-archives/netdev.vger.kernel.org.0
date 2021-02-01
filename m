Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD4B30B1BC
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 21:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhBAUvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 15:51:21 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14200 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbhBAUvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 15:51:19 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6018699f0004>; Mon, 01 Feb 2021 12:50:39 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 20:50:38 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 20:50:36 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 1 Feb 2021 20:50:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKUrIII+vwPWMyGCePmsAYhl6CUrR65V0km2AuAqz+kAjY+9igp35HYZKgqHLYdsDgcelWYN+O4xVb/WZb9K/XczJHBjqzRmVO5M5De4ZHctlHAn6yjynigmnT1yY/+b06LvyxZMNyIt5Wr7qDsPvu05762RQRJAiQDcEinyQPyMosxWSZwuHYC3icnJuQ9+rQAfNk+l5Jo+5HMFs8sVZY8+dwh/g3eOI2y1LP7cHA6iTyIU7EK+WY6D4riqYHoxlMnBILAM2fX/9f7lmpKYWjDuKcNVsurms3fL1QRq9xNhkNtobY3kAJ8/9wSojFxs+WUxj986V9z4D0Lu+WMgiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCVDQyF0dxj2wf+4BVoYAoHqR1+qDi1ph98bnfRgQWg=;
 b=fAy7x77zMED3CYQW1laUde597noGGrUbJDjk9g6V8CMuCHvbqEa+1ZnokvRfiaaqTN24jUXBiaymcWA/Rs7Kji389Q+3AQqYjqS/kisvCelzNShbMuxCaPJEBBvU1wWCNsFldVrVZlWctT5oKqkrWuoJS/W9D9SeHgTewFeWrYwoVFxOSK/s6NlVQT80b82ysKPxp+C1I8FxWSg/t7TMISXWo3vZ6fX/V/OqNHRMNZ4eAwoo81aTe1qwePjqD4tQg67dekJY7iqGdAUFC1SExCUtRduoyooBKEd0aGt4kMFYQqaNO0le6bW7AAoPZnjdSDQADU78+Z0YQsRhU3FcbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3320.namprd12.prod.outlook.com (2603:10b6:a03:d7::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Mon, 1 Feb
 2021 20:50:34 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%3]) with mapi id 15.20.3805.026; Mon, 1 Feb 2021
 20:50:34 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH iproute2-next 5/5] devlink: Support set of port function
 state
Thread-Topic: [PATCH iproute2-next 5/5] devlink: Support set of port function
 state
Thread-Index: AQHW9l/KMlzXfOifskWoZc67tmwHuapCANWAgAHIw4A=
Date:   Mon, 1 Feb 2021 20:50:33 +0000
Message-ID: <BY5PR12MB4322E41AB919F5F5AF4AF40CDCB69@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210129165608.134965-1-parav@nvidia.com>
 <20210129165608.134965-6-parav@nvidia.com>
 <c197fd9c-c6a8-0ad1-1dce-c439d891354c@gmail.com>
In-Reply-To: <c197fd9c-c6a8-0ad1-1dce-c439d891354c@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84afa568-6010-4448-b7d3-08d8c6f3053e
x-ms-traffictypediagnostic: BYAPR12MB3320:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3320D5AB630A699A6EFA76F9DCB69@BYAPR12MB3320.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1oagJE5iqKdOpHwWlceuArhr7yQL9bNu7A0Huvjt+89U7VXa5gr1QYyK1piekwWhUQkQcID52QczWlT85MeZj+B/zIopKU10kXcbH7EpBXzX/W5VEdcLgg+pjx2R+BzkWWsFxAfbq6ijvGIBJ7B04cGH+MnKdde2WUeyHm3fgqq6UZti7iiGr/7wWiIRRX1Y8x3FJDZEatJEty8zujejLsMqTqrlHN97N+PLkverpDppCGO1Dpm+du8wX2TkOtWSZdxHF7iCKfrBCuUV9eVsn/HWXjFSjAZWoQU+5xkT2HLRoMTMHh6rrzE2cyQE7fFyw8aGz3cu5ZCfRPTn9CQ9SobL+UoT4b4ua1dKDI1H1V+6lYDMlaEJzOq9uY5AKFqmk5PWZHNqYq4m1vOrdbSJBuPIBW+Y2rSvUu9NjzgRHKhaOum4Lg3GUrI8je+tZG5E05ZIgP+/uFeaWae9VDWOWhIwQDoIxhsmmQYCbwobGC7rkYG2vKEAA16lu6UjYlmVYrBElPlBt+ETNxe7q44HBg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(86362001)(7696005)(110136005)(5660300002)(4326008)(2906002)(8676002)(66446008)(64756008)(66556008)(66476007)(71200400001)(316002)(33656002)(107886003)(76116006)(66946007)(52536014)(186003)(26005)(55016002)(478600001)(8936002)(9686003)(6506007)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TGJsdGhsSGw1TjRkL2V5WTJuMWxQUnRDM1JjSWRZRkw3NklRcExQSjV5RnhJ?=
 =?utf-8?B?MTdqR05TS3ViS25DNkwxeDBJdmh1UGJGcnJwWkI5cGhwQ0gyd0xEV2d5RlFj?=
 =?utf-8?B?Qk1xczdoaVRXdnVvTUcweXNJaEFTaDRGZHM1Y1pINThDbXFNQWZBOElWc1Nn?=
 =?utf-8?B?N3d3aHZ3aThheXFWOWdma0UzRVhrMTJvbXJ5NVoxRmNGTmlkNkVkbkVCdDdl?=
 =?utf-8?B?eEVrdTF1OFA2UlZNYXlYVndieTVqT25NMFJERk12MzljMGpYUmZHMlc3VWRo?=
 =?utf-8?B?SDAwdzMvdUpSaWNsSC9KUHVGM2prbGFDWlMvQlJ0UFo3UWtKNHdnQTIrd0dM?=
 =?utf-8?B?Y1d2WUFpUWpScU5wZFhyRnhtNVhmaUR2aDZvRVd4anFIekl3ekFXZzRYL3NZ?=
 =?utf-8?B?cnJJQWgxRjh3bFhZdis3aVp5eVZTUTJPbUhBR1pER1lQeTdoRUpFSm5OZkdF?=
 =?utf-8?B?MWlpYWxOUzlDbzFjNnlqNmVJYnBKMjIrMG9wZnBqTVczeGduSytlbm5TL3I3?=
 =?utf-8?B?TGZMM0puRzB1TGoyUDgyVkZiaW9vRWhkdWNKZmd5aFI5aWdnNTJ2M0EwdTYr?=
 =?utf-8?B?RGNoZGhSR1RWRU9rN05hZDJXUXpQRDJUU09IblQ1MzJRZUZjSnVueVJsSU4x?=
 =?utf-8?B?VUxJVkd2ZmRGZTRTdTVxRlpSOVgvK1J0a2dhQTZRdUNHV2p0OGZ4TDk4SjZt?=
 =?utf-8?B?d2I2bWYrZXJpZlo3UmxaZUpEMnE1MTJPODlEelFnSkZNUXY2dlZjNnlGYjdz?=
 =?utf-8?B?MEd6cmlsV0tQTitzNmUyakw4UkNFRXV5K2RtWkprOEcrV2Y2UnlCUUZVbHY5?=
 =?utf-8?B?WDhJazAwUm8wWlBTQlBsT1hkc0Y3NTA3UFFCMFdqZzhFRXg1VUcxRkVpaCtz?=
 =?utf-8?B?a3NwQnhaR2VqN2ZRdVVRTXJkYWNVSnU5cHl2dXRwd21veXdYcDFYSmNUS3M2?=
 =?utf-8?B?UjJTYm9uempoN2wxMzZ3TVNmZCtGSVpzcUZ2ZWxHaUJHMWdJaERSQmtiTHdI?=
 =?utf-8?B?bVN0TlE3MDJ6bmdvZVkrVnpJcHB5U2ljaDVSZjZ5UTZxNjJyQWZHaWdKN1Z1?=
 =?utf-8?B?aGg5VzBRQzlwOEFQaEFXSjl6ZXNjc2xoc3ZHUFJaWTNYWlNoVlhSbDMzTnJM?=
 =?utf-8?B?TFUzSjMydzVqaXo5MCs0TzJqdFZuS3dWTnM5VUUzaHI4elJIaTAxZ1ZaTnNQ?=
 =?utf-8?B?SUdJY0tjVHVHVFZtU0RZWWpHZkhzdXdmL3RWanpEajdKOS9xbmtCbjhHZ2g1?=
 =?utf-8?B?YUlOQmNjcGpkME10bHI4RllhdUFiSWcvc05UTUs0UGgrK3NlVU9VblhTQTBD?=
 =?utf-8?B?OU91aWo5K3d3ellMSnFLWWQzSmVGWUNZTERxMERMY3EwV082bFQ0WmdqVkE5?=
 =?utf-8?B?cytqaXVGcGgzSmxMM1Z6NWNpbnlBTWgza1VTaVhac2VEMmJMUzFQSElLbVZh?=
 =?utf-8?Q?LYKxFPxk?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84afa568-6010-4448-b7d3-08d8c6f3053e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 20:50:33.9477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rrbz9WCIs7EAJSP5t3oZQRI5FXY1XL3PPXyUgObxnPYbd3pmabTUeVfU8VYXsP4ZoJXoPH53X5GAzpR5KJczTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3320
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612212639; bh=fCVDQyF0dxj2wf+4BVoYAoHqR1+qDi1ph98bnfRgQWg=;
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
        b=Rc7mcQxTRpgqWclZaJs5Hp5DqJQ031n9IumWEcFeXLLQgtIcF5FBLD0T42n4hfkiy
         VfbJpsuoLpsQq4TvSccb3CTnuTodqgBJEH0g8icH4MB4mFGJI6l7fNYRjBd7nq9V2X
         c0hb1NYoOsg3d4AHDlUcuusaovOrYLUXfA+xP1kR/qIXw+u39q+clXrInSjulYpz18
         1ub4Y3/s/t23Xp6CuNztqt/s45BIcBZYUHGE/FDhQm47Fjgsn4PAXKv/neVkWrBiOq
         uuHlnd/gb4V7ADtQCMjWvFtm03b0VeroceNpzFMKzAzojGqz0bQ/w/rY3jHoYlYD6s
         ny4xHFdTShj3A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBTdW5k
YXksIEphbnVhcnkgMzEsIDIwMjEgMTE6MDEgUE0NCj4gDQo+IE9uIDEvMjkvMjEgOTo1NiBBTSwg
UGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+IEBAIC0xNDIwLDYgKzE0MjMsMjIgQEAgc3RhdGljIGlu
dCBwb3J0X2ZsYXZvdXJfcGFyc2UoY29uc3QgY2hhcg0KPiAqZmxhdm91ciwgdWludDE2X3QgKnZh
bHVlKQ0KPiA+ICAJfQ0KPiA+ICB9DQo+ID4NCj4gPiArc3RhdGljIGludCBwb3J0X2Z1bmN0aW9u
X3N0YXRlX3BhcnNlKGNvbnN0IGNoYXIgKnN0YXRlc3RyLCB1aW50OF90DQo+ID4gKypzdGF0ZSkg
ew0KPiA+ICsJaWYgKCFzdGF0ZXN0cikNCj4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiArDQo+
ID4gKwlpZiAoc3RyY21wKHN0YXRlc3RyLCAiaW5hY3RpdmUiKSA9PSAwKSB7DQo+ID4gKwkJKnN0
YXRlID0gREVWTElOS19QT1JUX0ZOX1NUQVRFX0lOQUNUSVZFOw0KPiA+ICsJCXJldHVybiAwOw0K
PiA+ICsJfSBlbHNlIGlmIChzdHJjbXAoc3RhdGVzdHIsICJhY3RpdmUiKSA9PSAwKSB7DQo+ID4g
KwkJKnN0YXRlID0gREVWTElOS19QT1JUX0ZOX1NUQVRFX0FDVElWRTsNCj4gPiArCQlyZXR1cm4g
MDsNCj4gPiArCX0gZWxzZSB7DQo+ID4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ID4gKwl9DQo+ID4g
K30NCj4gPiArDQo+IA0KPiBpZiBhbm90aGVyIHN0YXRlIGdldHMgYWRkZWQgdGhpcyB0b28gc2hv
dWxkIGJlIHRhYmxlIGRyaXZlbiAtIHN0cmluZyB0byB0eXBlDQo+IGhlcmUgYW5kIHRoZSBpbnZl
cnNlIGluIHRoZSBwcmV2aW91cyBwYXRjaC4NCj4NClllcy4gV2lsbCByZXVzZSB0aGUgaGVscGVy
IHRoYXQgSSBhbSBpbnRyb2R1Y2luZyBmb3IgcG9ydCBmbGF2b3VyIGluIHYyLg0KIA0KPiA+ICBz
dHJ1Y3QgZGxfYXJnc19tZXRhZGF0YSB7DQo+ID4gIAl1aW50NjRfdCBvX2ZsYWc7DQo+ID4gIAlj
aGFyIGVycl9tc2dbRExfQVJHU19SRVFVSVJFRF9NQVhfRVJSX0xFTl07DQo+IA0KPiANCj4gDQo+
ID4gQEAgLTM4OTcsNyArMzkzNCw2IEBAIHN0YXRpYyB2b2lkIHByX291dF9wb3J0X2Z1bmN0aW9u
KHN0cnVjdCBkbCAqZGwsDQo+ID4gc3RydWN0IG5sYXR0ciAqKnRiX3BvcnQpDQo+ID4NCj4gPiAg
CQlwcmludF9zdHJpbmcoUFJJTlRfQU5ZLCAib3BzdGF0ZSIsICIgb3BzdGF0ZSAlcyIsDQo+IHBv
cnRfZnVuY3Rpb25fb3BzdGF0ZShzdGF0ZSkpOw0KPiA+ICAJfQ0KPiA+IC0NCj4gPiAgCWlmICgh
ZGwtPmpzb25fb3V0cHV0KQ0KPiA+ICAJCV9fcHJfb3V0X2luZGVudF9kZWMoKTsNCj4gPiAgCXBy
X291dF9vYmplY3RfZW5kKGRsKTsNCj4gDQo+IFJlbW92aW5nIHRoZSBuZXdsaW5lIGludGVudGlv
bmFsPw0KPiANCk9vcHMuIFdpbGwgYWRkIGJhY2suDQo+IA0KPiANCg0K
