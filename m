Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23799466A23
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 20:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376637AbhLBTKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 14:10:10 -0500
Received: from mail-dm6nam11on2061.outbound.protection.outlook.com ([40.107.223.61]:34455
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348377AbhLBTKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 14:10:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPkxfh++Vj+cYlATU8vG0u1ZZlnnu55UAu+5m+pgTz+uCdcBXDzCKqv43LDSSHqlfwfUsRbt/kxwx5ZFMT0YXIx2ZtBGPSNrnJIp1cK0tAfnhi3vSf2yvjexuIGFYVENOHTB8ujqekB1szHK20zVfkMYPNyiWnjte1XmwJeGIDVnC5Bqf/POZPIUILnSYbfIhgPYASEY532LbynYOGsCWV3izSH2nuYnKk+FACsJXNdUPiVnevUG81QgeWwWSpUB4xEHEUqj8542KFrhfDR0uE/sNtA2rF0TVLYNXvQQ+6L2B6UUa4QF3lFhlsZP6l96nHlujQNFeDkFNKtAhX5xZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TwpuUD96355YhuhFdcbL368s4m4G3rMhpi7sxvOlTQA=;
 b=cCvSCpOr8jTLvihajFSuEQlZN/77cZIyftI8TXeE/mHaPJMdE4csySE82vk6KZEU55WFHzBJK0g7roNmOSSoKxgFDvS+P1pXajogHBBVWnIs7vr+sMyED89ssc7W9+XQu0CY1wRgisw5DwVrhS0HPv2NUBGC8GwUmV3p0qEHpIdNfZQLBTkYQUUmzafQgaSwE5m/OoJxDEt4HzrHYP2t379pRZjLHF39d4dpDNqhj5bKOgsxG9hPEmn1kuBVUROKrHonaA2Xf+KohXYw/LxkVsKWY0K0uOMGxMEx5YmOfVnS+dSqJKei8obVSxkJfjv/xRpE/CDq7BXOLneJ7rynag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwpuUD96355YhuhFdcbL368s4m4G3rMhpi7sxvOlTQA=;
 b=de1fDkGbZ95uich4X9wMZq8MAzNhOKIqlfxUVFNHFlGig/z7Vqu55vIuh9XJEoRnxByc5TV4oXB+BRi9MnhF+O8lyhpM76Of8b9pM405DbJlmBaOUtXYxqqUFLIsf4t0KhHV54Q6vurITk+BPNbmXL2su60QkR9XIINZi6xAou4cgBMV0g8mrO/Yf+VJaC9ke/XGsJPmk/Iyf49OG1ZhG6pX8lmWXg3EUCxTx1CJVj3farjGttHyfXB9qZWtWZTnvvz630oenMvYLD6BQ9LQIQo99sAcGZcEWFXWUHSkRFIvnXQ58bvMf5ohbuXqZb4IeIcL5uF8KI0sAXfGJ1H48A==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB3745.namprd12.prod.outlook.com (2603:10b6:a03:1ae::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 2 Dec
 2021 19:06:36 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2%5]) with mapi id 15.20.4734.028; Thu, 2 Dec 2021
 19:06:36 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function as
 trusted
Thread-Topic: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Thread-Index: AQHX369esocIlp2uqECAMRBwa0Q32qwQUeyAgAxe1YCAAFJzgIAAQYMAgAJAtACAABqpgA==
Date:   Thu, 2 Dec 2021 19:06:36 +0000
Message-ID: <97075a76229d9a8a0abc32df37d7cb610c2f1357.camel@nvidia.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
         <20211122144307.218021-2-sunrani@nvidia.com>
         <20211122172257.1227ce08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <SN1PR12MB25744BA7C347FC4C6F371CE4D4679@SN1PR12MB2574.namprd12.prod.outlook.com>
         <20211130191235.0af15022@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <5c4b51aecd1c5100bffdfab03bc76ef380c9799d.camel@nvidia.com>
         <20211202093110.2a3e69e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211202093110.2a3e69e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9fdd726-6f58-4859-c653-08d9b5c6dd10
x-ms-traffictypediagnostic: BY5PR12MB3745:
x-microsoft-antispam-prvs: <BY5PR12MB37459218085A00BAFFE440AFB3699@BY5PR12MB3745.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sVqv7eG/m0HbbFFH+BXk/cbmsw2YxkSeS6Qj4wjcRZeWRzvlCc4IMIOxds+fL6BpBh2TMSIsW7Ysi1LHg4w3k7AjmZiq2OwGunQfCBLUSoU+PqbDd8GlIeVVRZSWCfRRhOe3WrFWiK7DIhkV5BO6vLdc6AX2ps1aeU0EpIEcSz1LYK2fyzn3SrO6spP/iHa+B2sc64bW4M4RPRS98y0m/CGa95mzp70a9c4qV2Dj0yZU3i/NH5lvSR4m9YGp6LnwoRgaRRQSm9qCclhWIWxDmfNYpwkMbC3kARuTsVneuW0B5gvdPeD6pnvy/aOlbkDY/6T7OQdP0khfUqhJjP1eVEfiWd9jXVxVrOlMhzTY0Y2yZhvr57oA1tldQ+ds9cV7LQ2O5q49InCbthZEtLsWzQLOXU6/KnieU6vV9jGKEFYi5vD59+TP8ErkSzOEVhZ+qP5gAPbojfqzhmaw1S5BWc+/6V5b6WZiq7bafXGWXmb4ncq27zh2r0DXb1hXdZDZv0g8ptolnM8R+E21L5k7KbEzssGlp2FVr8A1ywu0vowFATZ5mHZ9+lT6It9viOVZYycqnBGhssX+Ht4UeZaJ0lF7/lGBFFQf1E0LngRpdEsUeT07QjwTLAA0cd54UeU4TpO96zg92qKzIuUsKKQ/ZzhCI24Aaravy4Yo62KkdP5SiM35H5vavTprJsf1/Z6VnXA8PIzCGol5NY7wv1ubzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(64756008)(76116006)(186003)(66946007)(122000001)(5660300002)(66556008)(4001150100001)(4326008)(66446008)(2616005)(8676002)(38100700002)(508600001)(38070700005)(8936002)(54906003)(316002)(6916009)(26005)(107886003)(86362001)(71200400001)(83380400001)(6506007)(36756003)(2906002)(6512007)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bEVHYWJXTnM1K04ycnlBNXJPSFpHeFhmNXdvMGthNUw4Z3ZieG5IcmM0UGxh?=
 =?utf-8?B?NUZYUWQzSDYzaElKTklFdEt3eXZXc013bzBQV3dmR2VjQnF4QlpHOGFGOXZB?=
 =?utf-8?B?UC82UDVneFBwa3owbkNEM3lVMkxmQzc4SW5iQlYrWmZxL2dydjBFbWRYcnVi?=
 =?utf-8?B?QStqNVNIdGpEckxIVDhsbVlpZE9wRUdjNlRqZE9hdUZ0Y1pJSFN0ajZleURj?=
 =?utf-8?B?WTZuS1VJRnJWSUhiT3hiNmNJeTg3T0dJWHd0NVRSOWlsOFNLWGg2aUg3RTBn?=
 =?utf-8?B?U0k1dGNzeGhRSGU5NXdRVzB3SHRqVHg3c0lsMGVrRjN6OGd3Q1RKaXNRSUUx?=
 =?utf-8?B?ZnY4bFZ2Yms1Z24wTUNwWTQ5eFNjVEJScGhtSmc1VzEzeCthdmkvelFSU3dx?=
 =?utf-8?B?aHpWQzIySG0xczhNdGNPNjRGRFdjWFBLQ3lYeDArQitwNHBDVUF2QzVKTTF2?=
 =?utf-8?B?Wm9WaUZtZ1dMdytMdXRaSkUwN2kvSDhHeHhmdEpSZ1h1ZFNTa0szT2wwdzhL?=
 =?utf-8?B?T0xSMmM0WjZIaksvVU9OWWh6ZmVZeTZONzRGZklZTEdPN0x3Vm0ybU1Rd2Zl?=
 =?utf-8?B?WFhrSENlemY4V3l5UUVibXJ1TFRGRklEV0tvY2ZXOWdjL2hETWZMd1FvVDhR?=
 =?utf-8?B?Q0p0WjdwK2gza3p5V2M0UjhLcDdzQXNKVnR1VWMrM0I1OE1xSkRnVHVWWmpZ?=
 =?utf-8?B?eWdjSHJRaXJySkM5ZThMUmlMQUo1ZXZXajJvSmpVYWhmS3hIcXp3WjN0YlNn?=
 =?utf-8?B?aFlVMW8yZGt5V3JTTklJRnhGNjdOSmlMNnNneHVSaHFjR014bm1KdEJpL2hZ?=
 =?utf-8?B?UmVBVFpzZ1RSWk53YzFyMnlDWW8yVHdHenAwbFlQYVB2dzRBUXhxc3RlOGRH?=
 =?utf-8?B?d3VjdEpvUUtaTzVSSHdTeUo5UnIwMnZNbFRkZ3NEOE1Hd1hHQW1OZjdjREtR?=
 =?utf-8?B?MWRJUjlOdTYydkZqdnZkUC9zN0U4aFJZRXpITk1EeDNUM21JTURFTzBNV2hj?=
 =?utf-8?B?bUV2TzBlU1R1OEJ4N2M1WkYvN0RrN1pBU3owVVZQN1ZCekQ2Zjh2Z2xaR3Zu?=
 =?utf-8?B?ZVRLQ1FmVC96ZmZwQXdRZW1ldWRmL2pyQVRCYWxrckNhdm55MUU4aXBxaEUv?=
 =?utf-8?B?alRYNXg4akVrNmVKMGVxdzAxNEdaaWU3UmV1WU50Q0VRd2EzWHV1bUVEcmtJ?=
 =?utf-8?B?WVp1MmR5TWlsRU1IUnBZWGw1OWZZa1J2eFdsckpLeTlXUC9wMXRoVXdkU2pC?=
 =?utf-8?B?TVV5cVZaeFJSdC9zK1M1UjhhWXBuaFZxNUJMaHV5UGVNK3AyTXdRZUtEZVh5?=
 =?utf-8?B?dHQvNmRaTlhnYnUvVDFTZ3QxVjFWZG5UTVdlNTg0Y2RjbnMxZ3hsYStwd2xS?=
 =?utf-8?B?ZkkzQ0QwZkdqMTZlMi9kTmRzajlnVjh5cGVNUXZBam9hUngySFpUUnkxRTRP?=
 =?utf-8?B?MnYraWlyTzFzd0RFT0ZSY1BrVjFVaXhoell2YWRMY0szSzFFcnpwb1NsbVVz?=
 =?utf-8?B?aXIwRExMZytpY3JWYVlPdmtzRHc3RHlHcW1QWUQ5QjZXYlBZWHdBUXk2SGZL?=
 =?utf-8?B?QnZFZnJWWERrbjNtamY4TkNEUFVLdWlIWk4xd1FyQXVocWY3SGRZeTB6V3ZH?=
 =?utf-8?B?NGgrcGh4V01vWkE1WFU1VWRSZU5UZ0RnWG5XLzNhcnozZHNxSTU2SVhxV0w1?=
 =?utf-8?B?amltMzF4bFlIYzZOb2pjVkJWdnRJbS8xNzlhMEllU1V3ejQrTStmTmR6WmFs?=
 =?utf-8?B?RENiMGtFRjB1bExjTElWUE1vY2FBQ3JvUGx6bzV4YVJoWDlxR1hiUDdMRWwr?=
 =?utf-8?B?TGtZVUk4OE90MCtvMzVjbm8vc1JqaWhGWVo4TGtXNTh1eFdYTXY5R2I3R01Y?=
 =?utf-8?B?QS84UnpVWlJzckxvWGZCN01FUlN2bTlWS1R3Tm9hdE82RFZkdGlQMGZDb3Nu?=
 =?utf-8?B?eWRldFFmZ0pMc0ZkcUQ0NGZlNzRUOTlHeU9MZVhsU3VGZzZ3aDBPckRwVG81?=
 =?utf-8?B?VGhoWXcvZ3hvWUxhNXhINVJaclBmekdHMm9EekVobzI1aTFFOFVWUHJpZ2pW?=
 =?utf-8?B?M2FyM0doK2YzYjhtbkYxTXpMYndIR1VGZnpoMitkKzFybEg2dlFCaVEvb0Nz?=
 =?utf-8?B?WGg1SFNPUm9oRmZ3Q0IvZzJ3NDNSMmZhNW80R0haa25FWC8yb0JhakZ3NjYr?=
 =?utf-8?Q?meJOJ/gtqHkh36TH4RnqiuA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <82EA8AB129580C42915890DE8297F049@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9fdd726-6f58-4859-c653-08d9b5c6dd10
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 19:06:36.4471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8+S3Wx5Pb69WXpuxz1d9BgFMB2gMxmb5T/9P4vv4gJeBYcKF+BDas44mMWELD6xUudI7j0cWCSmGqDYcfCs06g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3745
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTEyLTAyIGF0IDA5OjMxIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAxIERlYyAyMDIxIDA3OjA3OjA1ICswMDAwIFNhZWVkIE1haGFtZWVkIHdyb3Rl
Og0KPiA+IE9uIFR1ZSwgMjAyMS0xMS0zMCBhdCAxOToxMiAtMDgwMCwgSmFrdWIgS2ljaW5za2kg
d3JvdGU6DQo+ID4gPiBPbiBUdWUsIDMwIE5vdiAyMDIxIDIyOjE3OjI5ICswMDAwIFN1bmlsIFN1
ZGhha2FyIFJhbmkgd3JvdGU6wqAgDQo+ID4gPiA+IFNvcnJ5IGZvciB0aGUgbGF0ZSByZXNwb25z
ZS4gV2UgYWdyZWUgdGhhdCB0aGUgY3VycmVudA0KPiA+ID4gPiBkZWZpbml0aW9uDQo+ID4gPiA+
IGlzIHZhZ3VlLg0KPiA+ID4gPiANCj4gPiA+ID4gV2hhdCB3ZSBtZWFudCBpcyB0aGF0IHRoZSBl
bmZvcmNlbWVudCBpcyBkb25lIGJ5IGRldmljZS9GVy4NCj4gPiA+ID4gV2Ugc2ltcGx5IHdhbnQg
dG8gYWxsb3cgVkYvU0YgdG8gYWNjZXNzIHByaXZpbGVnZWQgb3INCj4gPiA+ID4gcmVzdHJpY3Rl
ZA0KPiA+ID4gPiByZXNvdXJjZSBzdWNoIGFzIHBoeXNpY2FsIHBvcnQgY291bnRlcnMuDQo+ID4g
PiA+IFNvIGhvdyBhYm91dCBkZWZpbmluZyB0aGUgYXBpIHN1Y2ggdGhhdDoNCj4gPiA+ID4gVGhp
cyBrbm9iIGFsbG93cyB0aGUgVkYvU0YgdG8gYWNjZXNzIHJlc3RyaWN0ZWQgcmVzb3VyY2Ugc3Vj
aA0KPiA+ID4gPiBhcw0KPiA+ID4gPiBwaHlzaWNhbCBwb3J0IGNvdW50ZXJzLsKgIA0KPiA+ID4g
DQo+ID4gPiBZb3UgbmVlZCB0byBzYXkgbW9yZSBhYm91dCB0aGUgdXNlIGNhc2UsIEkgZG9uJ3Qg
dW5kZXJzdGFuZCANCj4gPiA+IHdoYXQgeW91J3JlIGRvaW5nLsKgIA0KPiA+IA0KPiA+IFNvbWUg
ZGV2aWNlIGZlYXR1cmVzL3JlZ2lzdGVycy91bml0cyBhcmUgbm90IGF2YWlsYWJsZSBieSBkZWZh
dWx0DQo+ID4gdG8NCj4gPiBWRnMvU0ZzIChlLmcgcmVzdHJpY3RlZCksIGV4YW1wbGVzIGFyZTog
cGh5c2ljYWwgcG9ydA0KPiA+IHJlZ2lzdGVycy9jb3VudGVycyBhbmQgc2ltaWxhciBnbG9iYWwg
YXR0cmlidXRlcy4NCj4gPiANCj4gPiBTb21lIGN1c3RvbWVycyB3YW50IHRvIHVzZSBTRi9WRiBp
biBzcGVjaWFsaXplZCBWTS9jb250YWluZXIgZm9yDQo+ID4gbWFuYWdlbWVudCBhbmQgbW9uaXRv
cmluZywgdGh1cyB0aGV5IHdhbnQgU0YvVkYgdG8gaGF2ZSBzaW1pbGFyDQo+ID4gcHJpdmlsZWdl
cyB0byBQRiBpbiB0ZXJtcyBvZiBhY2Nlc3MgdG8gcmVzdHJpY3RlZCByZXNvdXJjZXMuDQo+ID4g
DQo+ID4gTm90ZTogdGhpcyBkb2Vzbid0IGJyZWFrIHRoZSBzcmlvdi9zZiBtb2RlbCwgdHJ1c3Rl
ZCBTRi9WRiB3aWxsIG5vdA0KPiA+IGJlDQo+ID4gYWxsb3dlZCB0byBhbHRlciBkZXZpY2UgYXR0
cmlidXRlcywgdGhleSB3aWxsIHNpbXBseSBlbmpveSBhY2Nlc3MNCj4gPiB0bw0KPiA+IG1vcmUg
cmVzb3VyY2VzL2ZlYXR1cmVzLg0KPiANCj4gTm9uZSBvZiB0aGlzIGV4cGxhaW5zIHRoZSB1c2Ug
Y2FzZS4gSXQncyBwcmV0dHkgbXVjaCB3aGF0IFN1bmlsDQo+IGFscmVhZHkNCj4gc3RhdGVkLiAN
Cj4gDQo+IA0KOikgRmFpciBlbm91Z2guDQoNCg==
