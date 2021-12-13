Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF37A4720DD
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 06:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbhLMF6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 00:58:51 -0500
Received: from mail-dm6nam11on2064.outbound.protection.outlook.com ([40.107.223.64]:17793
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229472AbhLMF6u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 00:58:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hvg/pv1m/FoE/KCsgQZMY7oj2xhmAz4ujgkLkYrj9e2qYRsxqFDoSRzdNq8U1giBfU6yBnpPb+68cOF6t17Ixo2p0cMOYdB0vYKWZdoOc1MNRnHfQgosqMzeE6OAKCaBMC6Tq4kMWJ1nstBMl3jr1A9yt2Zc7EVRIPLgBvq3LSjKc96hcg5ZPi8oChmr+7aefYy6qAawWNMBRQwifRY/P6mPTI+XGADgPvhOoNouaNIcpiwOaoVVqTLVK8eQ4e1iM6gHYorsoIq82mI7/lRHx61/yyCB0g4U23V+b+79x7qBhKa2Qj46AFXx3JC8s4J/GC9T8PsgYRmvLjJUpNRj8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZeTv+/X4G/epzxLwH0cROBn7D51MVm20gYoZYbAwQZo=;
 b=Hu1Q7uRk21e/HTJs7HWWqafaHyONY2wI9cNP0/0HIkpI2dkd9LQNXl0bUjA44xjN95hXDFvLpEFHW9rWu9F/583rHISz+By7tb0ywib63BHywijPYfxaWN+xAcGgCWDGjHlgM7Eambgs3BW5fja1LQKuvKXMd7l0BmioL+Rbe0GfO94eIC4mfvI8BnwUmaoyGWVlJRZqeMJlPpqxXngJDonV7jLesHEyoWphgq5nS4qIfmdssIWUcoriyb696StnGLfNz0YKvKi0lAdmixgwNMXegdfX/qpullC0VdY7W6JrHodGwIRhhfNTlhVvMhoifzYgSnElVagLyNZDjd+EYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZeTv+/X4G/epzxLwH0cROBn7D51MVm20gYoZYbAwQZo=;
 b=pJIIyJ9pjU2OmV53PHcrqvoiVUb6oDU0GhghhlbLbIChg+gpN7v/guI810CNdV/beVqRZMe6VV803PhYzBx0V3qwxGGS+W5omMM1S2ynxnezJ+5MXnQKw3M/ZtYNp//ClWkKKAPZvQ5BSr2/jvtBKnwt4wmrnGqktZRamVqdJ0tAwWduDg2Pgcc+46MtuzkQYuvIm8boo4tZvS682TIv4vkox81DxaydmtZYOtzlNU/Yof6m3O93q2NW/OL7sDwlpJkXfyFbZq+ycgypRmxdUkBGORmtULAeFKadCGqS0DxkSiaGEqzRG0G6HPQCLrROjh53kbgnKXxNKnGqFfqTBQ==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5499.namprd12.prod.outlook.com (2603:10b6:510:d5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14; Mon, 13 Dec
 2021 05:58:47 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::5ce0:ef86:a707:3c51]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::5ce0:ef86:a707:3c51%8]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 05:58:47 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [iproute2-next 0/4] vdpa tool to query and set config layout
Thread-Topic: [iproute2-next 0/4] vdpa tool to query and set config layout
Thread-Index: AQHX5zRJNZQkcZPsxEOh1JEFFqiR1awg/ySAgA7/GwA=
Date:   Mon, 13 Dec 2021 05:58:47 +0000
Message-ID: <PH0PR12MB5481F6E9E52E6563176C883DDC749@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211202042239.2454-1-parav@nvidia.com>
 <7472fe36-b0a9-d731-8c2f-20be0411b96c@gmail.com>
In-Reply-To: <7472fe36-b0a9-d731-8c2f-20be0411b96c@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 325e78ff-6db1-4215-0dd7-08d9bdfda13b
x-ms-traffictypediagnostic: PH0PR12MB5499:EE_
x-microsoft-antispam-prvs: <PH0PR12MB54999327B18F5C136FDDD7AEDC749@PH0PR12MB5499.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3aNwwWLCF5J0L6l6V8MkNspFcDFdFmzfKVveaP7v3kRH26OHrsvPMnCqi/zPuLaGw1fK7596GQKPxs6mRp9EMp8nzUSv3a9dFvMLDvwkCT8hUD7fNqmpxxkmTjm+HL3Ae9m1BnEyldA2t1Ev+9U+8TKbs6ZHz59/jhC7kjpZdhA2xPhNqYl1YYMloGqnH/Ws2zFWQ9qKVt/PVSEx7DmOhHr+VO7jIzOGvTLO3bZsPuj/r3hryJgfUwyhvsFl813K6+wmpK1F6vflFSnBQ4IRekBhAbtPnFnmzmvgI8fcLSw0ntiELog8egZl/Gt5yAz894LpSwEtATRUlJE5iUZu3hn4W6/BWbVml61Rzn+2j7YL0xvczPtvpjKsDBsR2TszgtqSNJsg8qYAl2h6oezXkZjgYNCofavjffCj/dXy7x8jJPGMGLtzS3YlEHHIBFpq9seJxBVjoRD8lQzxPvC8/jssT41nAXXCIzm/rhzigRwQuHNELrvasye23j4j9KkwppAi2WRdGdxs5kDgOcqGKhdVJhjENlMPNGlSug8CfwgAGl7ybEa9n5mUS0PK0hRfSRvpSqFDJak/kordbrGBV2IU5wYjt+hYZ27X5vtvb2CYrEJwjKVI26KtJGZyMD9+V21n8+pBbPLAQxhNJy41N9/oKK7InCKByNIs1FVIcmJ38KGCbPRrPMBw4ENbWmY/sUquzsjL9EQHeAAyL1buDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(186003)(7696005)(53546011)(122000001)(2906002)(71200400001)(9686003)(8676002)(55016003)(38100700002)(5660300002)(33656002)(64756008)(66476007)(86362001)(66946007)(6506007)(316002)(4326008)(66556008)(66446008)(26005)(52536014)(76116006)(8936002)(110136005)(508600001)(38070700005)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEFMai9OTnJLb21aSm9HNFpMc0NsVnpwbXd5bFdMVjR1cDZYdkUvallHSUZZ?=
 =?utf-8?B?STB6ZW5pQjZSRUlGWENVZ0RLZUd4NFR6RXVGVStGWWViRFZ1NUNRZ0ZOM2lL?=
 =?utf-8?B?Y0hiWHo3R1czWmRBaTl0TVNZSjFsenBQb1V1L1JJTk9VMng3RGwrZ25mUWkw?=
 =?utf-8?B?cUJOU3hueUhoVE1BWUV3TnVHTGw5Qlp1N1pKMXFEdlVtdWVpRlFvbXlWRm1Q?=
 =?utf-8?B?TkZ1cGtzN01KY2VkUUlQeGFCZTNLQU03Q0FMUUd5MG45bTFWTWNud21HRk9u?=
 =?utf-8?B?OFBMTHU5T3NZOE5hbURicWJTempta1VFd2h4eUYxUXFkOThLT3FZd2NXUHlI?=
 =?utf-8?B?c0ZXQ0I0a2wxUHRIMGlJSDB1M2NESlhHZjhNalJYWmw5NndIRUdVb1czakpB?=
 =?utf-8?B?azJXVWIyTUtXN1d4Nk4zZGpsR283eloxQTBNU2JUTGxtbEkyTFZTemdFeUN3?=
 =?utf-8?B?QUtuSmZPOXhuMTFoMm00Ynh1c2xYczlwR3NlWG9XR291bFBFYUxDYjBpTlRZ?=
 =?utf-8?B?dXNueUU2YVA3OHV1aTgyNWdNbUFBWVBKeGUvcTY1YzVuL1BDbVZBZWV4ZFZ2?=
 =?utf-8?B?RWZyZ1RuWVZyZndpYmlQbk0rTFhDblpvY09EUmt2TWJ5ZVA4VE9Fc2Nla1hP?=
 =?utf-8?B?dGlubzN4a2Q2MUpiaUdadk5XR29FY3B5NnNGMkg2TEdDaG9yNXFYM0lNRVUx?=
 =?utf-8?B?bThvS05DUDVzd0JNR0dvYU1vV3hUQUtLTDNNM3RpVVRlTU1FYVdFQUZ2eXZt?=
 =?utf-8?B?bmdUV3crdkFIWU50VUp2SDRYaDVKNUljbnNDRStnY2hLbHpFZEpvMGhaYjFh?=
 =?utf-8?B?N29IdFlDQVdpZmttV0NuNzZVTFpQZTl2T1BFbmJaUU5UMUdXRGhHNllVRmtk?=
 =?utf-8?B?QmRCMmRKdlJLdVlGcG5qdk1uT3ExbEJKWXhrNTdkU3k3SkhoczJQUFVvYmY1?=
 =?utf-8?B?MEhHQTlrcFh0dEFTZjA4a2JvMGkxMkRUMkxLOEdnc0pIQ1diV0xhL2lyTmZY?=
 =?utf-8?B?cEt4MS9UcitNYTZTMFBkRStreFBoYmwycWRSVnY4OUhKQ3lMdFdQeDgyc0lF?=
 =?utf-8?B?Qlk5djhpR2ZXckVzZDFrUnJQWTc1dWVuOHRNd3hXVU1IMGJBVG1oSm1HbFlZ?=
 =?utf-8?B?MjdtclJ5dzArd0huUUo1c3BDOEhVUzE3RTlzVmtBSkh4cVk2VVZDaHVpSUkz?=
 =?utf-8?B?NGJ2SWNselh1b1RHU1pGK3R3V3dTbGRKNzJKWEZBZmdsNlkrVWd4M2xDdy9D?=
 =?utf-8?B?QVV1K3ljKzNnRlVXQ3NIdFBLUEw0QVpNN0pURTVYUFhrQ2E0UVdMRzlNaXpl?=
 =?utf-8?B?dVpHci9tclJiS1JuMm1DMDVXOSs5Q3VQNTAxT3ZkV0lZVXVwdjN1bXVkdnpt?=
 =?utf-8?B?d3M2dTZPbnB6dWxTdlk5MTd1UVYzUWltazdhSGRrWlZMQ2Vmc1FqOE5ZM3B5?=
 =?utf-8?B?YnZvSm04c2tnTnUwUnFya0Q4aEc3SjVSRzFIVVlYMFg5YTd6WmQ1M2x1bWV6?=
 =?utf-8?B?ZXJEYzE5aE1Qc1JOdHppQlJ4cS9FcTZnVWJRUVVkTnhTaHFIWmVVNmdKdGRo?=
 =?utf-8?B?aDA3Tkptelg3WU5JNmtPQTd1dDJOOUlualBWcW5Sa1hGOCtLNkUzVHBOckNS?=
 =?utf-8?B?bXQ5ZlF0WjFOcDcvVTNoYTZ1dmRZSmZ5VWZLM0crb1NvOGRXUGZCbHZISm41?=
 =?utf-8?B?eW5kRk5tSTdoNEMxd3dVaG0rUU9mOUo2cHNlVVJKV2F0Qks1c1lkbmpPOTVk?=
 =?utf-8?B?YnJyRElBN1gvUG12aVVFdWR0OHVJelJ6Q1NJak9LeEFZMlphYXNZaFFUV1Q4?=
 =?utf-8?B?Q3NjSXF0SS9IQmJQWUhKN0xNZEw3djFFSlRoT1YyZGNpeFUrRXFJV3lDVmhm?=
 =?utf-8?B?R05Vb2FKQzBIS21qenVQVDJLMXQ4cVZ3NlhWSGJKSUlyWHg4eUZxcXpXMy9x?=
 =?utf-8?B?SXpySllxK2h6Umt3Um9sdG9KRUR4M1ZmYUZDeGFPMnRqVS9yTTIzalBGWkth?=
 =?utf-8?B?RXZuVisvdWxIUkVvMkx0SGc2K3prVXplQS9TRlRoRXZ5cVAzdzB2MjRsSnRw?=
 =?utf-8?B?RzVaZWQxeFRFeFJ5b0NXMDNHQW91cjhCU0o0YWVqdGRBQnV4MUdoajFqc0pM?=
 =?utf-8?B?cEJERWxVV1V0RzViTGRkV3J1ZW5nbHluMUNtZmJQTUsybGJSTlhsSEhKZFlD?=
 =?utf-8?Q?q66RJrXhNIMxY0zxl0pP0JQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 325e78ff-6db1-4215-0dd7-08d9bdfda13b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 05:58:47.7440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jIcNZljbsTfo4VdjW5J5FHSncqfAQZJneuyF9stQ2w3VQgKDs2QcfO3U19PfebE0XctXyEKR8EDuOOcIKKoWLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5499
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBGcmlk
YXksIERlY2VtYmVyIDMsIDIwMjEgMTA6MjcgUE0NCj4gDQo+IE9uIDEyLzEvMjEgOToyMiBQTSwg
UGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+IFRoaXMgc2VyaWVzIGltcGxlbWVudHMgcXVlcnlpbmcg
YW5kIHNldHRpbmcgb2YgdGhlIG1hYyBhZGRyZXNzIGFuZCBtdHUNCj4gPiBkZXZpY2UgY29uZmln
IGZpZWxkcyBvZiB0aGUgdmRwYSBkZXZpY2Ugb2YgdHlwZSBuZXQuDQo+ID4NCj4gPiBBbiBleGFt
cGxlIG9mIHF1ZXJ5IGFuZCBzZXQgYXMgYmVsb3cuDQo+ID4NCj4gPiAkIHZkcGEgZGV2IGFkZCBu
YW1lIGJhciBtZ210ZGV2IHZkcGFzaW1fbmV0IG1hYyAwMDoxMToyMjozMzo0NDo1NSBtdHUNCj4g
PiA5MDAwDQo+ID4NCj4gPiAkIHZkcGEgZGV2IGNvbmZpZyBzaG93DQo+ID4gYmFyOiBtYWMgMDA6
MTE6MjI6MzM6NDQ6NTUgbGluayB1cCBsaW5rX2Fubm91bmNlIGZhbHNlIG10dSA5MDAwDQo+ID4N
Cj4gPiAkIHZkcGEgZGV2IGNvbmZpZyBzaG93IC1qcA0KPiA+IHsNCj4gPiAgICAgImNvbmZpZyI6
IHsNCj4gPiAgICAgICAgICJiYXIiOiB7DQo+ID4gICAgICAgICAgICAgIm1hYyI6ICIwMDoxMToy
MjozMzo0NDo1NSIsDQo+ID4gICAgICAgICAgICAgImxpbmsgIjogInVwIiwNCj4gPiAgICAgICAg
ICAgICAibGlua19hbm5vdW5jZSAiOiBmYWxzZSwNCj4gPiAgICAgICAgICAgICAibXR1IjogMTUw
MCwNCj4gPiAgICAgICAgIH0NCj4gPiAgICAgfQ0KPiA+IH0NCj4gPg0KPiA+IHBhdGNoIHN1bW1h
cnk6DQo+ID4gcGF0Y2gtMSB1cGRhdGVzIHRoZSBrZXJuZWwgaGVhZGVycw0KPiA+IHBhdGNoLTIg
aW1wbGVtZW50cyB0aGUgcXVlcnkgY29tbWFuZA0KPiA+IHBhdGNoLTMgaW1wbGVtZW50cyBzZXR0
aW5nIHRoZSBtYWMgYWRkcmVzcyBvZiB2ZHBhIGRldiBjb25maWcgc3BhY2UNCj4gPiBwYXRjaC00
IGltcGxlbWVudHMgc2V0dGluZyB0aGUgbXR1IG9mIHZkcGEgZGV2IGNvbmZpZyBzcGFjZQ0KPiA+
DQo+ID4NCj4gPiBQYXJhdiBQYW5kaXQgKDQpOg0KPiA+ICAgdmRwYTogVXBkYXRlIGtlcm5lbCBo
ZWFkZXJzDQo+ID4gICB2ZHBhOiBFbmFibGUgdXNlciB0byBxdWVyeSB2ZHBhIGRldmljZSBjb25m
aWcgbGF5b3V0DQo+ID4gICB2ZHBhOiBFbmFibGUgdXNlciB0byBzZXQgbWFjIGFkZHJlc3Mgb2Yg
dmRwYSBkZXZpY2UNCj4gPiAgIHZkcGE6IEVuYWJsZSB1c2VyIHRvIHNldCBtdHUgb2YgdGhlIHZk
cGEgZGV2aWNlDQo+ID4NCj4gPiAgaW5jbHVkZS91YXBpL2xpbnV4L3ZpcnRpb19uZXQuaCB8ICA4
MSArKysrKysrKysrKysrDQo+ID4gIHZkcGEvaW5jbHVkZS91YXBpL2xpbnV4L3ZkcGEuaCAgfCAg
IDcgKysNCj4gPiAgdmRwYS92ZHBhLmMgICAgICAgICAgICAgICAgICAgICB8IDE5OCArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKystLQ0KPiA+ICAzIGZpbGVzIGNoYW5nZWQsIDI3NyBpbnNl
cnRpb25zKCspLCA5IGRlbGV0aW9ucygtKSAgY3JlYXRlIG1vZGUNCj4gPiAxMDA2NDQgaW5jbHVk
ZS91YXBpL2xpbnV4L3ZpcnRpb19uZXQuaA0KPiA+DQo+IA0KPiBwbGVhc2UgdXBkYXRlIG1hbiBw
YWdlKHMpDQpPay4gSSB3aWxsIHVwZGF0ZSB0aGVtIGFuZCBhbHNvIHVwZGF0ZSBwYXRjaGVzIHRv
IGFkZHJlc3MgY29tbWVudHMgaW4gb3RoZXIgdHdvIHBhdGNoZXMgaW4gdjIuDQpUaGFua3MuDQoN
Cg==
