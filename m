Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07FE0BDD86
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 13:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405110AbfIYL6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 07:58:04 -0400
Received: from mail-eopbgr800083.outbound.protection.outlook.com ([40.107.80.83]:28744
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728674AbfIYL6D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 07:58:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6GaI/ddBbpMd8diYxHY3m4/ZGSaeHXHOzYnqklcDtZf4cAAoAmigoWJCzVgtm4hPPvD8Gnj6EsKfDXxyLypX7lQY7u37YBJPIOjB731nnp/UYaICEoHrEc4/aqmPoQ5i7L0MEu+vCsszCLuFqNAilzyMDW6pLavvOFZ0McWyRRISV17Mi1+TvWTc+uSKGsKf0DcUkz033SVS5HXH0qoRCt+KafqcWfrxDcNG9ev4MTAfjUG4ubdtsoLMa9vadozb0LPZNQfOBVLbCmGRuGHAnw7JoiVQ6CqlIZPKBMSyHT9CckU0JvHlcbF9sOhHvgcEEIhiVRRzFWhNa1UTJoXbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Boh3Aus3iOMbmuR4y5ZWU17y+1JFrMIjbOkL+j+UNvE=;
 b=MUYYBS/gixJQD/yhE2Ggd/GYdHQa3C90DopemD1WcXx6JvTVhzj5yZsAahgxw8pbFODtggiofQFGdnaqgKUtelduLcAEkRB+WeEVbFWWdzfLN4OqP274Yt42UsxleS+whLW8nYYqLbzSp98sfAnGbNABKkeob1/cG36WOLi2PZqT1cT+TU4xB3x1uZoTRyDVGByfRrQhNnBG9HS249Xzba1ETksluRswcg4kubmxDY7Ur1P4l95ZaEZlaeUOTUrBekF6KNG8rAOnklXVvtmo6awYpdQuzWEmiFKYJLlpc86NU0xNaWvkiYGPcL+SxwjJcENrRKDv3YFLgbRgP4hWJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Boh3Aus3iOMbmuR4y5ZWU17y+1JFrMIjbOkL+j+UNvE=;
 b=YUBCenapp20V3GD1BaXYtFDDXn7UK/5F9fAijaGdneitl2vozWYM445vUQiUnGCOsCGJ0jpeS5/HU/yaTZ60WkMNxaXGP4VyQwtlx9fYk4g5urJfluo4yQ0a2hNpt+n5Nm/ktPUrwsytYbDIqxX2PAOpcwGz2fbzpmO/AfYdbFQ=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3553.namprd11.prod.outlook.com (20.178.218.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Wed, 25 Sep 2019 11:57:59 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::391a:d43a:162:c96a]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::391a:d43a:162:c96a%7]) with mapi id 15.20.2284.023; Wed, 25 Sep 2019
 11:57:59 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        David VomLehn <vomlehn@texas.net>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net] net: aquantia: Fix aq_vec_isr_legacy() return value
Thread-Topic: [PATCH net] net: aquantia: Fix aq_vec_isr_legacy() return value
Thread-Index: AQHVc4+lVaq0AY8wiEKaLB/33tvJAac8Sc0A
Date:   Wed, 25 Sep 2019 11:57:59 +0000
Message-ID: <f5be37aa-4744-3976-f899-fafb4b822e3a@aquantia.com>
References: <20190925105430.GA3264@mwanda>
In-Reply-To: <20190925105430.GA3264@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MRXP264CA0029.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:14::17) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 669c9a14-2f47-407f-f353-08d741af9c5a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR11MB3553;
x-ms-traffictypediagnostic: BN8PR11MB3553:
x-microsoft-antispam-prvs: <BN8PR11MB35537CD573A7B835D41CBB2E98870@BN8PR11MB3553.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(396003)(39850400004)(366004)(189003)(199004)(305945005)(2906002)(508600001)(66556008)(102836004)(31686004)(110136005)(53546011)(44832011)(2616005)(316002)(476003)(99286004)(25786009)(66946007)(4326008)(4744005)(54906003)(186003)(446003)(386003)(76176011)(6506007)(26005)(31696002)(52116002)(5660300002)(14444005)(486006)(66066001)(6436002)(71190400001)(66476007)(8676002)(14454004)(64756008)(36756003)(66446008)(6116002)(6486002)(71200400001)(3846002)(11346002)(229853002)(86362001)(6512007)(8936002)(81166006)(256004)(7736002)(81156014)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3553;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SOMx1TGdnBYVugzwZ2HF7fvNT4fFQz/CjsnZYZo3JKIjHoQXNfUgk/s5L/UV2c+aJZxUDbD7w37TdOZcgbQeJy5FifOv1fjzI+dMrgVHkSK6wj9c22hbdoXNMudiprEzho4uQ7CvmNtGZONiD3PFy0zzjGKo2rk43//wm3vuZJlAkCX6FbIL4GGr12axWeoKXTB4jSFXN10AM6G6CHFMnb9QbDPJBHcWoy52xH7ZAAQa4N8a5bUpYucwx459G8BuHMajmltgwpcgmNOqDN7448o1u0DbYuGb5TJTjRi/VyGdIfovWd1yFAxFTqCX/w87ZAjKLFoxLChnEmiIZto6HOpFdIleo8AyNoACpRYx3ktBSoB+R/Q6AnutYsAiGcRyvrQJ1PVGAhd5l0Hv7vg6M+8kKvZ8JfBMSwzgPTvl/QQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <906701E3A49FC6419AF076125AEA5E2F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 669c9a14-2f47-407f-f353-08d741af9c5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2019 11:57:59.6311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8k5jIP0ZjGabr2uLHYYbopQ+F9Pb+FdR7YZv0Lu5ndNhFv+yi+uyTdOFpo6MiWuGQF/6a/gX2rnym2sGec4Z6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3553
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDI1LjA5LjIwMTkgMTM6NTQsIERhbiBDYXJwZW50ZXIgd3JvdGU6DQo+IFRoZSBpcnFy
ZXR1cm5fdCB0eXBlIGlzIGFuIGVudW0gb3IgYW4gdW5zaWduZWQgaW50IGluIEdDQy4gIFRoYXQN
Cj4gY3JlYXRlcyB0byBwcm9ibGVtcyBiZWNhdXNlIGl0IGNhbid0IGRldGVjdCBpZiB0aGUNCj4g
c2VsZi0+YXFfaHdfb3BzLT5od19pcnFfcmVhZCgpIGNhbGwgZmFpbHMgYW5kIGF0IHRoZSBlbmQg
dGhlIGZ1bmN0aW9uDQo+IGFsd2F5cyByZXR1cm5zIElSUV9IQU5ETEVELg0KDQpUaGFua3MgZm9y
IG5vdGljaW5nIHRoaXMsIERhbiENCg0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9h
dGxhbnRpYy9hcV92ZWMuYzozMTYgYXFfdmVjX2lzcl9sZWdhY3koKSB3YXJuOiB1bnNpZ25lZCAn
ZXJyJyBpcyBuZXZlciBsZXNzIHRoYW4gemVyby4NCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1
YW50aWEvYXRsYW50aWMvYXFfdmVjLmM6MzI5IGFxX3ZlY19pc3JfbGVnYWN5KCkgd2FybjogYWx3
YXlzIHRydWUgY29uZGl0aW9uICcoZXJyID49IDApID0+ICgwLXUzMm1heCA+PSAwKScNCj4gDQo+
IEZpeGVzOiA5NzBhMmU5ODY0YjAgKCJuZXQ6IGV0aGVybmV0OiBhcXVhbnRpYTogVmVjdG9yIG9w
ZXJhdGlvbnMiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBEYW4gQ2FycGVudGVyIDxkYW4uY2FycGVudGVy
QG9yYWNsZS5jb20+DQoNClJldmlld2VkLWJ5OiBJZ29yIFJ1c3NraWtoIDxpZ29yLnJ1c3NraWto
QGFxdWFudGlhLmNvbT4NCg0KDQpSZWdhcmRzLA0KICBJZ29yDQo=
