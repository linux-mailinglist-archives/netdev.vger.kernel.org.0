Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5D645D376
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 04:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344446AbhKYDNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 22:13:36 -0500
Received: from mail-psaapc01on2139.outbound.protection.outlook.com ([40.107.255.139]:41697
        "EHLO APC01-PSA-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231406AbhKYDLg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 22:11:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W5Q7mKTEGEQQEz9clvJftnXvTauO6JSAK2yMKhlAr3tQhG8MqMrOy0weIiT1ZldKpUgTKwZ0tOPclAbzcs6vQ42sWQrfr2xe73aQZ+K+Wb6+JxYgiRUr70PnK/yQTB4gsm8zFHlWQ9sLmFY2S9tr+SqxUIqfLM3T1Aq3+hcVjGZVx0OD7cVcPjEAhaQvqLXfatwvsRJQj4a2sf+haQJfQmPzIlTrnZ/BHGXiGi+Z/56XHtIeXx9aIaPjwv6MIeCOKeBAGZsVqaSNuoqnYsdMAC4i/uEwuMKM9W+lrqI8ui3ZTW4oOUv9alDB5nr76onZYkJpdg8WnfCyoK8Y//5iQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aDYRsMJVSj/iIIWe0hAvsayN+C2C8Y1S/DkPgO2H9bU=;
 b=I2e0aS4GGAmgniwI3R7SvU1MIQ++yzapKVX5RrQI8iEkdWl7RIP4JewqWgRWZkbUqYBdsmPyuQoUK6o7o+FCIQZN3KUXUFsd+NEDCKkY0Em3EkCMvKpehrtg1267wa77EuokAUAG+Ql+iY4lUjkLT5Pqlz4oDviv3Ynr/AZChjNIs5sxl/D0RYCck9+rDp+u05cEbllCBcQIw3W8B2iGDjjTXHCbY1T9hOHGPfvBeOtD7ve0oWvoYWApzBPk/n7zqBCkzBuqgR5VOTr/JtTkrc+JNf1VeDHUtdY/q5613gQxpWfo6/5tOLxTFLR1cb3kCPMes/J2HGFQ4P7H00aMZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aDYRsMJVSj/iIIWe0hAvsayN+C2C8Y1S/DkPgO2H9bU=;
 b=y4hkouNM3j49M/NkOtWSRBh0ARaS5+CF90kcNAUQGPJ/B9C/XX/VEg/pM33do4uQPHdcB6ubcyCzPPCzjcviKmL4X6uICkE0gRCYdsVXKbe0OHaNpJx5h5+IcpplFUZiG3OpG7dG5JuGgGTXV/+4g84CidQP2OE8hlSruKz2p/ejiM7VnUYEoajGKmZA8Z2sOOomS5ecSpJVO65s5ed73tIyrWoViGRJhnfFz0CIRKsmCVTzNLTel/0g3ggXtJSaX/7Z+AW6QboHnHCdzoxtr4+kzDcar/qcl3wQbcjShcXJM8nB/+Bvehka5BY5H20PqQ8ZyQJmLzM84O48uxJYTQ==
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com (2603:1096:203:5c::20)
 by HK2PR06MB3572.apcprd06.prod.outlook.com (2603:1096:202:33::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Thu, 25 Nov
 2021 03:08:22 +0000
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::3c8b:f0ed:47b2:15f5]) by HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::3c8b:f0ed:47b2:15f5%6]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 03:08:22 +0000
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     Andrew Lunn <andrew@lunn.ch>, Joel Stanley <joel@jms.id.au>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Networking <netdev@vger.kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        BMC-SW <BMC-SW@aspeedtech.com>
Subject: RE: [PATCH] net:phy: Fix "Link is Down" issue
Thread-Topic: [PATCH] net:phy: Fix "Link is Down" issue
Thread-Index: AQHX4PoOvlh8YFTKU0S4du3aOuQLJKwSc72AgABakwCAAMKTwA==
Date:   Thu, 25 Nov 2021 03:08:22 +0000
Message-ID: <HK0PR06MB283498AF35B397F05CC627A99C629@HK0PR06MB2834.apcprd06.prod.outlook.com>
References: <20211124061057.12555-1-dylan_hung@aspeedtech.com>
 <CACPK8Xc8aD8nY0M442=BdvrpRhYNS1HW7BNQgAQ+ExTfQMsMyQ@mail.gmail.com>
 <YZ5adFBpaJzPwfvc@lunn.ch>
In-Reply-To: <YZ5adFBpaJzPwfvc@lunn.ch>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb9804b6-5115-4181-3b0b-08d9afc0d71d
x-ms-traffictypediagnostic: HK2PR06MB3572:
x-microsoft-antispam-prvs: <HK2PR06MB3572B7F5D4958AD777B5C5539C629@HK2PR06MB3572.apcprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EP6EGaIIT5ROLtk47wsaYuoF2NMON1qZoD2GIInIokaQUHFo/RI7MI+sAOo+BvC6GSIs/r5k+Isc6hLVY0i+V1iUNMZ+657vtsyP9oXUfqKd01ydWgps0CC5IDNCN5H+QN+X/YWN0CjuS0zsmXqXPGj9v027bWwO5N5OnDVlbAKZj87sSALUGE+6zEL4rfl51vqbr+k6py9z0RhAvgCZP5WXhu9fXBhWI+3A1YbPIzIJbfmaHQS6c7n952Tx6Xw7As9FcPXyLvXJVEMNHB2l5lf556ellINPyA5/QFxkpAY1/93Iz/9hDI877XbS0WX72PaMMGRZ6a7R6Nc1Z21Tle0sQTqGEB526wn5qQUzNk93ljuWLMm2NHNRUj/xZdrxApNtuOtGOTh5aKmt9S2iyfaLpiTLsi8AVICjCvSS9hXN+/ZkfhOarmpXY5lP5t9Y7YQIjvbR0f0HGlVxs6UplHfAC6sdT0NMOUYVxYZOjjYau+LSHBk89Rc0jn6Z5QTy7Li9OIS9pNhxheFXcspcR1MEphzqDoyz4QfEhpiDzolDsmjD6ZVfNfj41q47FefwqUpolVJJnN7mVvGQXrdkOLnrmPNaO1+o+QgnlFTo81W8jGKhOqczai6uO2vj1uA7FcLDGGN+ytbbp78ZHE/6Rijw1EUNeSZp9LVUAAwNV9DRRZA+JM/TTI9SVI+HWr5tDDmGwEoO4kfSU3T2ay5LCrf5CY64ElDaHVwLkoZ1nW/8ovcso5b8x6/yn5XgPgNmYCP3aqVs8I/zd7o1Hirm9jK2DBN9OP00Kmq7Lt55xZQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR06MB2834.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(136003)(39840400004)(396003)(83380400001)(107886003)(76116006)(8676002)(38100700002)(55016003)(122000001)(33656002)(7416002)(4326008)(4744005)(316002)(5660300002)(508600001)(6506007)(7696005)(38070700005)(966005)(26005)(9686003)(54906003)(66946007)(66476007)(66556008)(64756008)(66446008)(2906002)(186003)(71200400001)(110136005)(8936002)(52536014)(86362001)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?big5?B?eDE5ZDVkS2lWQ1NNRFpHQmpOT2IxUkdvM2Jma2RvUEhSL3Q4SGVROUp6VkRqM1d3?=
 =?big5?B?b1ZzWnRoTnlRaXRYSWNVWFRJbkNTY3hkMG9WY2NlU083N3VFYUdrZW5LYVFNbXMr?=
 =?big5?B?QW02UWdZSC9JQngzbEhzQXBGZURNT2VUZTdXY3F4RGtveWVEcnp0b1AzMFdOYy9M?=
 =?big5?B?eU1rdmpPaldpRTlzSHdLcFBQaGM0aFFJTnZkOTA0Q3NCQThSbGxXdjNabjJMRWNa?=
 =?big5?B?MmFTVm55WGtWeUZvQmpNOGk2c2NRci8wdC9ua3JJMlM0WmpDUFp6ampXL0Vxb2Fn?=
 =?big5?B?M1Jsc3R0Ymd4dExuZ1BrMzh3cEFKS2huZ01VY1YrZVRWUDEvMXMyVDZLTVdNTUJk?=
 =?big5?B?VlVqOVppZ1lRbk1qM3JZQ242Y2Q0RE9KUXNMK2hCOTNKTDZiKzJZcVdjT1NWdElz?=
 =?big5?B?ZjMyMi9hdDcyTUJUeG9IVURwLzhiREx4SUJOa2s4SzZKUmEwalp1QzB5NVpvMUNM?=
 =?big5?B?Sk9NcFhnejV0R3l2bGV6Rm9aRndaQ0RnK2d3TGdYYlVRM1JRc0ZaRzhJQnpEd3ly?=
 =?big5?B?R0JkQTJvM1QvcjRZUTdoSVgwMUNQWFVQODNHSTlLdCttaGo1TXBQemcrOEh4bUE4?=
 =?big5?B?QVYzL0l1dTJSajZsbkN0NjBuRFpXblBzb0pjMUJqWFJLd0VRSDZrWXp3MzZJb3U2?=
 =?big5?B?NjNSdWJ2bmk1ek12VVBWYmZPeTgrVUM3Lzg2MmVpSnBDNTBBMkJKVXFsL1N6QXl6?=
 =?big5?B?eklObjJiK3ZyN3dUWHRBRGc2UHllQk5BTnRHUHFmMDFCN05GdUJrNFgxZUk3UXRM?=
 =?big5?B?ajFTVk1EMnhtaFJkUnZHalFHVzNWbXRHRW1xTnhyQzlKaHJsa2hsdXlicVZSSmEz?=
 =?big5?B?OVZJTElQcVZmK0tDSUhlQ0tlUDdSRXcyU2czK2lrMmR1NVp0dmRDNXRwaE5IQzIv?=
 =?big5?B?a1FBTmJ3ekJXalZuZXYxekZjLzZIY3lwRktJWXhCb056akd0SlBMeENUcHN2VTd2?=
 =?big5?B?MnY1anFEdG0rZStmMTFuSlhoN29iSmRQd3JNQmoyRk81Z1VUajRTak9DWEFrNGxI?=
 =?big5?B?Vk5jNGxQWjBqdll5SFpnV29uMXJlUXppUldQUFJkSWxpOHRMbDZlRjZOZUtTaE9m?=
 =?big5?B?bXd2TmZzVHBQTHg4TkVJUEhlTTdkWTExQ3FPZkZtSGJLd3VQY0JBZkVZTmVucjIr?=
 =?big5?B?U0NVbERjRTBoM0NDak5PekliMkM2OGFZcjM5NDVNdmcwN1djVU1oQ1Y5ZVNlcTFz?=
 =?big5?B?Zy9ybUpYejJTQWkzSHByTjhPMXY1Sm5pUjhtc1pTV01BUnYxT3ZkZjBXR2NJd3J6?=
 =?big5?B?QkZTZm9ra2NKdVlIUHZBVW1uZEhWcDZmZEZmSitEbzFzM2Q1YXRudzB6dmNTbWhO?=
 =?big5?B?djE2VENQSDRBdUhUamVLNDBlTUdhdldZUkIwQm5KdjhnVnBETDE3ZFhjQm5MN1Zy?=
 =?big5?B?N0UrSXZ2Y3pKQThTR251Y1VPSWVBUTA2TStFQXUrT1RiSDVPdlExWnFNbVM3NUxr?=
 =?big5?B?eW9EQmVQdzg2NUx1KzJWN1hHTmVjYzlYVENvVXladTdJTU9pWFhhTTRHeWZ2UG5B?=
 =?big5?B?bHI2MTQyNmgyR2hub1dMMVdnd041RmI0TnVHNUwvZ0tkaVBycERzb3FJdk9lejBI?=
 =?big5?B?d0plcmQ5WldNUDg5SzRHdGRia2ZqR2MvU1VHNVBFQlcvZ2Nzc29UbWJHdDgwelA5?=
 =?big5?B?VytJdW1uZVhGMVZoVzF3L1o0dnFXZUVvZ2lJRHdMSDBpelVMTVh0Mnl4M1BuYWtq?=
 =?big5?B?V3I0dlBkMGlVYWx1Z1hRMmx6UjdEaFJINys0WVdSd1p2ZEtnRG16dXZaanhpZUtk?=
 =?big5?B?UkxPNnI0YkhiRUNuSnhBMGdxYkpXaHpNZk5la3hFY1VFcm9HTXpMQkpTTW1BaFpr?=
 =?big5?B?bFc3MCs2bWFFTVZYY0pVTy9uaHZTenNQWTRvNytobG1Yc2NTNStZcnJtVUU4ajhX?=
 =?big5?B?ZVgvcDNudTRmNkhIOFMybERiNEYyZ0JSekZjeGhKMWtmS0ROZ3liOGVUOHpOZzdp?=
 =?big5?B?eVZ1Q2IxMGlOQVQxakx6SjFkOTdiWnZsbHRuQkRPUzY1OG1SNCs5eC9IVCszcVpx?=
 =?big5?B?WkI5NUsxY2RFSjlIemdqWmNBS2xUZG1YVlhKbnRIV3dYTVMzZmZkUVVBQXpDdW1i?=
 =?big5?B?ZVVFMFdTK08rckFacDBNQVN0aHY1UWVESStUY3I2ZlRQYUw2TUphSWViVlFYaExU?=
 =?big5?B?aE4zN09BPT0=?=
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR06MB2834.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb9804b6-5115-4181-3b0b-08d9afc0d71d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2021 03:08:22.6015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gInJLCH68nFJvsESq1A2o1bkKs5rgU9Iy0fq4fDDqWQ7Usl58DMbcXwEDAeJs55EmIUH6QRHiNeVHiI57v0pObsunwPqp9uGgOy+hXi1LA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2PR06MB3572
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmRyZXcgTHVubiBbbWFpbHRv
OmFuZHJld0BsdW5uLmNoXQ0KPiBTZW50OiAyMDIxpn4xMaTrMjSk6SAxMTozMCBQTQ0KPiBUbzog
Sm9lbCBTdGFubGV5IDxqb2VsQGptcy5pZC5hdT4NCj4gQ2M6IER5bGFuIEh1bmcgPGR5bGFuX2h1
bmdAYXNwZWVkdGVjaC5jb20+OyBMaW51eCBLZXJuZWwgTWFpbGluZyBMaXN0DQo+IDxsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnPjsgbGludXgtYXNwZWVkIDxsaW51eC1hc3BlZWRAbGlzdHMu
b3psYWJzLm9yZz47DQo+IExpbnV4IEFSTSA8bGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRl
YWQub3JnPjsgTmV0d29ya2luZw0KPiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IEFuZHJldyBK
ZWZmZXJ5IDxhbmRyZXdAYWouaWQuYXU+OyBKYWt1YiBLaWNpbnNraQ0KPiA8a3ViYUBrZXJuZWwu
b3JnPjsgRGF2aWQgUyAuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IFJ1c3NlbGwgS2lu
Zw0KPiA8bGludXhAYXJtbGludXgub3JnLnVrPjsgaGthbGx3ZWl0MUBnbWFpbC5jb207IEJNQy1T
Vw0KPiA8Qk1DLVNXQGFzcGVlZHRlY2guY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBuZXQ6
cGh5OiBGaXggIkxpbmsgaXMgRG93biIgaXNzdWUNCj4gDQo+ID4gV2Ugc2hvdWxkIGNjIHN0YWJs
ZSB0b28uDQo+IA0KPiBodHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9odG1sL3Y1LjEyL25ldHdv
cmtpbmcvbmV0ZGV2LUZBUS5odG1sI2hvdy1kby0NCj4gaS1pbmRpY2F0ZS13aGljaC10cmVlLW5l
dC12cy1uZXQtbmV4dC1teS1wYXRjaC1zaG91bGQtYmUtaW4NCj4gDQo+IAlBbmRyZXcNCg0KU29y
cnksIEkgZ290IHRoaXMgbWFpbCBhZnRlciBJIHNlbnQgdjIgb3V0LiAgU2hvdWxkIEkgcHJlcGFy
ZSBwYXRjaCB2MyB3aXRoIC0tc3ViamVjdC1wcmVmaXg9J1BBVENIIG5ldCc/DQo=
