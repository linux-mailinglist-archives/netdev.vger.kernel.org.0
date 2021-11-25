Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50EC45D280
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 02:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345816AbhKYBrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 20:47:24 -0500
Received: from mail-sgaapc01on2095.outbound.protection.outlook.com ([40.107.215.95]:58336
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347654AbhKYBpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 20:45:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUc7gEenI9pQcBSx2KkY2/m9m1j6brIo1WRolvCBCiCwo+S0AapLw5rrBDpR2wuVLtoaJdn0dZw4T2P7+lH/GIjLM67px1LujNgM44FRIxBVbkB327MXdyYn5Uyq8MrTcv53PeQTwWxtfa8iSjpbDRJmMhSEO9yeoHuShv3rMe4+DtfKboaiA1S/u5BBoKvnCzJUHplI8Y7HVCMTvxquuceKdC/5YSqzNaybrFr+4YlelvlxOiLB+juKmGEi6r4CQgBVQCyyRBF+wYiBKrfIpgmASPvSuI41l59//+ZHsaa8eZDkxe0lXZzU+Uc/zxMYzUHr6w+W6CWodHpsptqC9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VGtP0kgJPXklnOf0mimGaBtFZLaf/U8v70icRB58YN4=;
 b=mXcYUbhTtowR4cAvVfz0KitQMO3LZBjoZJAqVPgtlsG1bkihxgu+EA2nE9hIjy6EtJQkwWUK+MaHwm4K/8k9ly4x7u3Ywoo6oHDoZvJYNCXUOm6hkYhn10JlrvYV+XksYqRYivFTT0DbB6Pow+2p7Jz7qkHxDnPemYDnV3+Qz20FK+awoMQSca3r/fMAsewEXz08vmDCi8v02k7CcLb/PN5GYAp3iNXEgeLpGqJXp82yZLkaGuk1Q3R2JW9HGlEPyFmFxaanrMgFVzWh0bcwqlc9qXAfTdOyNVIzbeMUmu02TPSEs0zHHZogIIx7DZO00R+n/h3gcPLrndRwhpFYHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGtP0kgJPXklnOf0mimGaBtFZLaf/U8v70icRB58YN4=;
 b=Ofa2h9uhfhpTMTMY1DqO7qyil0LBRaU/vUOArIi9+mVooSBz7NMeK3Q/Sb8siu7J0FK7gbT9y9+pgECelhXpLtHgjhVVUPvnlVoN311eUIWGb8afi8G2Qcm6mFSdxyHBxZrM4vzX7Y4aWmjsCrhxuuDx8kNuOrqektgWeZEdqie3I+O0qGf2cyqo+eoaDoN3xEAk4vke7lNyUzDB7Qq4LWvL0iTu+Gs8LNvklvSjUBFiMcsm47ezLTV2DXFyL4yE+a7RSu3yJzHpc0nzVmUEPQkjN43Por06t5cK4/T5ygZUJFBGJZQCDt9O86uzH6BvRTr/NU3+QwnY/7NRt+7MrQ==
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com (2603:1096:203:5c::20)
 by HK0PR06MB2580.apcprd06.prod.outlook.com (2603:1096:203:67::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Thu, 25 Nov
 2021 01:42:08 +0000
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::3c8b:f0ed:47b2:15f5]) by HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::3c8b:f0ed:47b2:15f5%6]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 01:42:08 +0000
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@aj.id.au" <andrew@aj.id.au>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>, BMC-SW <BMC-SW@aspeedtech.com>
Subject: RE: [PATCH] net:phy: Fix "Link is Down" issue
Thread-Topic: [PATCH] net:phy: Fix "Link is Down" issue
Thread-Index: AQHX4PoOvlh8YFTKU0S4du3aOuQLJKwTVKMAgAAidvA=
Date:   Thu, 25 Nov 2021 01:42:08 +0000
Message-ID: <HK0PR06MB2834A8D8845F53F6CE228F019C629@HK0PR06MB2834.apcprd06.prod.outlook.com>
References: <20211124061057.12555-1-dylan_hung@aspeedtech.com>
 <20211124153042.54d164dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124153042.54d164dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38b637dd-d66c-46cf-55ab-08d9afb4cb16
x-ms-traffictypediagnostic: HK0PR06MB2580:
x-microsoft-antispam-prvs: <HK0PR06MB2580B8180B9DC8C0AFCE1AD39C629@HK0PR06MB2580.apcprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9xEKzjdeBi/S2dh5Q5+IvHhhwJDDXA40VQfp/hCWGoBq8Yw+9FsHIhra1KUJ2z9V35peGcYrNSZidZLwCiOnsbKe4YcrLD5O97PsqPt6BZQwiitIIoedNfyEVZ8WJDeuBps1jRJuOypCviOzZEV8lzay9LcUyiZbbrtsyvi3/szYpHXoe5vJ0M7va+DVv4SK0sUjn7h6ScxfUF+pEXX4OhKBGmk232acon7t1prvC6NWRc9NTyjmb922PodrIMVqvrkqZrqRTukrbsjmqaxnZgm9GYG8Sbozm6Xda8FoXdOG6Mu44NeYvUNrr83YkaXCHJycMUhgAaJri3HTesW/+LXleSqJzH8m3xagBrrezfV1nj1FS0CZwlc50iFKBlHQEhtiFWRNYZkSihEXnlo7+9IwfVLSrKKRBtoW8bODGVk8CFeZ1xA24fmzH+FEyQvoeNDyj3qQpzCvTX82AWij9P2hRpsu3PImrgbL37Vw1I2ihIeoHN/eajDZ1IFhqFSKFB4ocXnAFU5WX8xnd/v1kJZT+YReE/LWtZtje2MIHi+h6BqEQvUmNgpeVNJkx2PIWE4TrfnV6z+Kss2dEYdxI4DnhOlqUbK7rOkbuqORzH0mdva31NFS13Geo19UjepqmI+U2oHnldHuof7u7WCKHFiY4l5WrW7+xKuesKL5JTIri5UQrVlZ/DGavKBm//Wh9ZbMnFyZMToyAriJ3urrGw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR06MB2834.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39850400004)(396003)(366004)(346002)(2906002)(4326008)(107886003)(7416002)(86362001)(508600001)(7696005)(33656002)(122000001)(71200400001)(9686003)(53546011)(6506007)(55016003)(83380400001)(38100700002)(6916009)(186003)(52536014)(8936002)(5660300002)(76116006)(66946007)(66556008)(64756008)(66446008)(316002)(66476007)(8676002)(4744005)(38070700005)(26005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?big5?B?MGs3QWdQNnhWRW5tbE5oMjZMQko3K3NNWnVHR0RTRG1zS0x2cFJBdFlSaVNiOGo3?=
 =?big5?B?NWUxamhmMEw4czRRb3pJVmVvQXNjc3BMSWVsMUViaGFUay9lQkJHNzg1b1pkNVY0?=
 =?big5?B?VUNPYXpjZitwc2JKMUp5K2lsRmozMHQrZHpaV2JSWkRoVklMdXJkU3B2eHA4U1hD?=
 =?big5?B?TUpBeUw0U1dxZGRGa3ZlSGRrQ3pMMEJUeVJqWkFUVE5VZnpaRnNDVkFlR1dKWmpz?=
 =?big5?B?ZGZSRmI2VGhQWXNqOHQ5SENFamExOHRLQkJWSThsNjk0Sk4rQlFXSVI3dy9WQVJj?=
 =?big5?B?N0lTREFOQzhHeHhzYXBTYWtXYTZ4U1ZDRnE2RkVKend3YWdVdkJqY1owaHZlRGJM?=
 =?big5?B?VC9jNllNMG8vbnJNcE5mdDVSaUJXNnlweTdnN0FNSHlPTWk4UUZLVXZlb1dlUnhT?=
 =?big5?B?bHV2YUNPYkpyVjRzWEw2N3VtUmxFYlYzWk10TnJSZWZ5c2l4QXQyMWxEN1grQTYv?=
 =?big5?B?bVpPM1dCL1BwTG1uQURGbzRMSWJ5c3JDNVhPMDI2Z2ZJYWhuMVZBM0U4dndlc2N3?=
 =?big5?B?K2dMNmNPTWJNcUo5aHNEb3FpNEpSaVZCUENPbmxZdWlFV3YxV3pqdENrM3dSaVhk?=
 =?big5?B?NzVOZ2VUU1I1TVFUMENVWGRMcUFha3pzdW8vSXJPWlhQbzg3dzdqNUZSMFgyYm1P?=
 =?big5?B?WFI1cTBVdGZCM1FlVlc1VXRmblR2bjRWSXB3YjhtWWxHM0F0Ynd2RlBweEJ1cEM0?=
 =?big5?B?QWF2b3hJdE40bUUwb0FwNmc4NXRHRjIvN0N0aXhrU09MNExvL2xaZENsWjBUV3BX?=
 =?big5?B?S3haWmtEMklldTJUOUFWYzJJa3ZBU0JzUEtIYk1JRHRqdkFyZWpxWFlBZllHQ0RF?=
 =?big5?B?NFVqZ0gvcGZ0ZTFFVEhCUG1TeWlEWC9TUG5oRUkyUzI4Q1FzeXowZDFRRWpGcUR5?=
 =?big5?B?cjl2TEdWOVVveFllb1IwWlBHb2o0LzhHU1FMTkkyVjRDRUlMNXp6aXNpS0xQaTh4?=
 =?big5?B?dGt0QmJCNnJwTXR2Q21WaHJxTFlwWGFYYlc4M3lZa0JrdFFQWjIwZnI3eTdLSWp5?=
 =?big5?B?YXd6NFZxajJRYUl0eSs4WFUyOXp1bHEwUTdlczlCR2gwcWVuK2J5cUlreXRKTFQ0?=
 =?big5?B?MktvY09zSnVpbXFZUkJtWTI0NEhvbUpCbDRRNW92UHhaTnBudGlZaWgrTGhTbkhP?=
 =?big5?B?S0xCWGpjbTlpRDN0VFdyRHBvamJ5emhZMVB0OEVhd1lXNFU2VC9ZM2NwY3lDZkRX?=
 =?big5?B?NmIyNXVscnZWQ0tQSjhEb3NvdzV5Vm0xMVpUa3dQMkNiOG1mREJOZlh6QXBkS0lO?=
 =?big5?B?ekhwalN5WUVON3FEU29jcjZ6cUNjTG1xR2kxQkNFM0pPaWdWV2hxNktySmoyb0w0?=
 =?big5?B?OWhIYUZ6ZVArRzZudCttNzdxY1dsTG42WE9WMUlmbllTajJPV2hlYXprL1d1Zjhw?=
 =?big5?B?cDZqUis3YzNZWTdlWkxrWlYxY2RieE5OenFWTmUxTk9zV3ZDUkNYeFQ3TTBzS21t?=
 =?big5?B?T1NJcXpzb3lqTGRKYkF4RTBXSWpTeG51RUtET013VXRqTzA5UHIyUllORCttbjVP?=
 =?big5?B?S0ZESitPWUJrdno2RlJpcUYxMFRXcFFYcEsyZjNEd0NSTWh3SzRRWlNEdmt6aUlo?=
 =?big5?B?RDMyVGlaVHJ6dG9lWG5zSkpzVS9tUkd6bm04VXVRQ1dIUWpES3JJQXhFMm1XY21L?=
 =?big5?B?V0xvTU5VV0NmZWJkVTkxZFFvOXpNSkhQQUZMRndKSEpYcnhyRmJZUGdJVm1xbm95?=
 =?big5?B?dk1DdXZ4T0lQMmxtSlEzblRGZ3lDUFBGa0hmdzA1bWQvVWR4SmVjTWhFYStENlEw?=
 =?big5?B?amdnSVNtM1NZK01kQUFkWlluNEpCQjVmdkkrM1NCT2d0L2ViZjRXQ2RhVENBYmU1?=
 =?big5?B?SUlXenRmRHVyR216WUlhaVI3SlNnNVNyekxvN3E0N2V4djJEZHQwUkFHc2wzV1dZ?=
 =?big5?B?ajA2RTIxd3FiaitSUUdEU0cxWVV6Y0FIYncyaFpYOXoxMWNvUEhDTlpBbytQVDU4?=
 =?big5?B?OWZoS3M2aGdnaU9iNWpPZlNrTEZmd1lxUG9WSjZBT3ZxeEhjbE9OWWdEWEpoZWhw?=
 =?big5?B?WGk4VXRrTXJQR0pNTmtTOTZvditQM3I0YUoyZ2VhcDRDTTV1MmkxaHM0STIwdnYy?=
 =?big5?B?VXQ2a1hxeCtTdnY5L0V5aVBMNVdtVzNoRXVEUlVpTitOeEZCL2JyQU93T1MyeE9w?=
 =?big5?B?bW00RmJRPT0=?=
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR06MB2834.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38b637dd-d66c-46cf-55ab-08d9afb4cb16
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2021 01:42:08.3859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TRDXLEHEAi0r787BY0RkN+dCmKxr3t+zgE5VcwV9hOjsD8Mefhhx59olfifrAkLH5j+OcL0fBf/jXpeNcB4y+wy3kZlVLV5jCqHXrsJC8ss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2580
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYWt1YiBLaWNpbnNraSBbbWFp
bHRvOmt1YmFAa2VybmVsLm9yZ10NCj4gU2VudDogMjAyMaZ+MTGk6zI1pOkgNzozMSBBTQ0KPiBU
bzogRHlsYW4gSHVuZyA8ZHlsYW5faHVuZ0Bhc3BlZWR0ZWNoLmNvbT4NCj4gQ2M6IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWFzcGVlZEBsaXN0cy5vemxhYnMub3JnOw0KPiBs
aW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7DQo+IGFuZHJld0Bhai5pZC5hdTsgam9lbEBqbXMuaWQuYXU7IGRhdmVtQGRhdmVtbG9mdC5u
ZXQ7DQo+IGxpbnV4QGFybWxpbnV4Lm9yZy51azsgaGthbGx3ZWl0MUBnbWFpbC5jb207IGFuZHJl
d0BsdW5uLmNoOyBCTUMtU1cNCj4gPEJNQy1TV0Bhc3BlZWR0ZWNoLmNvbT4NCj4gU3ViamVjdDog
UmU6IFtQQVRDSF0gbmV0OnBoeTogRml4ICJMaW5rIGlzIERvd24iIGlzc3VlDQo+IA0KPiBPbiBX
ZWQsIDI0IE5vdiAyMDIxIDE0OjEwOjU3ICswODAwIER5bGFuIEh1bmcgd3JvdGU6DQo+ID4gU3Vi
amVjdDogW1BBVENIXSBuZXQ6cGh5OiBGaXggIkxpbmsgaXMgRG93biIgaXNzdWUNCj4gDQo+IFNp
bmNlIHRoZXJlIHdpbGwgYmUgdjIsIHBsZWFzZSBhbHNvIGFkZCBhIHNwYWNlIGJldHdlZW4gbmV0
OiBhbmQgcGh5Oi4NCg0KU2hvdWxkIEkgdXNlICJuZXQ6IG1kaW86ICIgaW5zdGVhZCBvZiAibmV0
OiBwaHk6ICI/IFNpbmNlIHRoaXMgZmlsZSB3YXMgbW92ZWQgZnJvbSBuZXQvcGh5IHRvIG5ldC9t
ZGlvIGJ5IGNvbW1pdCBhOTc3MGVhYzUxMWEuDQo=
