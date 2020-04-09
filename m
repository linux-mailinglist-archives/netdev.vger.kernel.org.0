Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFFDD1A3C42
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 00:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgDIWK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 18:10:29 -0400
Received: from mail-am6eur05on2051.outbound.protection.outlook.com ([40.107.22.51]:6085
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726632AbgDIWK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 18:10:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j0htHblgOM8kSCRFgVuxbz/d2hAKfg6E0bcveYObjr+EhQgetcxEDHaQIbpoNPL0ZY33ksXP7FFMP4QlOoX4Uw/WeGeHY7rjeCC8lVlfnt/bnKEmu6gB/tfowx8MW0R4KZ3/ZAQ2qmo9fKb8JPI21J/34ZPSAYW6nfV6jb+49aQGGgx9DQoRiHOBVXDathorZtZ4Uci2NUkP8Hzg33V8axfxre4Oyf2bnSyVCdKedHMfRZcryP6g98pxeIoVK3jcHc+9B1E2Jdwk7aq4GjpFOHMddCQyNNtdkjbbpN2DpzEZYWqju3rD8g8sv4ueXoW+eaT5Nuz+oRAzXRYpQEOkPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hr9lT5bbZJAYZ3bYxPA035NYzLku7av2VrI9z5Wsj2M=;
 b=hJDk+nxlnmcldZjLevdYqROabogXuttJgiZ2E/0MYRh93+8lTUUK0ehYABdLUOZDGKL8jjQhSQpJef9wF7ZOqz2vVZfJ6rJ+YhzIx0n/iGISWTCmsgavZb7NMJrXQw0Ae/rs7vgjf6ogmMgTYTABVBeRolv2mwh8a71pyAyIxxBpUrGjzZ67vbOWpwWZCjjdLJAoqQnpNgSaMXO6GY3FBcVfkLCG+xadMozyuk2X+x/qWSZwfJJ4q6nKqR90lVz2dvNXOxTaJW1NLW2hRWhxKecWMnqGbO4b0UM5HhVRi8Z1Dqdd6ZwYTjFtjs35tnatO7LNWIIVtf+dtDN6OtRWCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hr9lT5bbZJAYZ3bYxPA035NYzLku7av2VrI9z5Wsj2M=;
 b=rXK++T8F+E5ysWLgWEaUz0osuFGlubNAeKuR+2GBGWq/S5KSld1xwQ0pYF0J6FIaMjVSrFyjtZJfUtb1SNK0z+wOBCrn14kLB+VSoJSViZYIoxd0ka91i8KiRw2HB5jfr/iAezLuwhUI8YNGy2hh17soRM5n0XDCZrnOrA3sJyk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3245.eurprd05.prod.outlook.com (2603:10a6:802:1f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Thu, 9 Apr
 2020 22:10:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Thu, 9 Apr 2020
 22:10:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "schnelle@linux.ibm.com" <schnelle@linux.ibm.com>
CC:     Eran Ben Elisha <eranbe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH] net/mlx5: Fix failing fw tracer allocation on s390
Thread-Topic: [PATCH] net/mlx5: Fix failing fw tracer allocation on s390
Thread-Index: AQHWDkL7hiMao+/zmECyHLa1VBxLVqhxWs0A
Date:   Thu, 9 Apr 2020 22:10:25 +0000
Message-ID: <2b92b2d716397a26dc54da96ced2e74b0ecc2bf8.camel@mellanox.com>
References: <20200409074620.43054-1-schnelle@linux.ibm.com>
In-Reply-To: <20200409074620.43054-1-schnelle@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a428ce34-834c-4b98-3a24-08d7dcd2ce87
x-ms-traffictypediagnostic: VI1PR05MB3245:|VI1PR05MB3245:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB324590C4F8E449DCD01D72CEBEC10@VI1PR05MB3245.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0368E78B5B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(6916009)(36756003)(8676002)(81156014)(8936002)(71200400001)(6506007)(2616005)(4744005)(5660300002)(26005)(186003)(66476007)(66556008)(66946007)(66446008)(64756008)(6486002)(6512007)(478600001)(2906002)(107886003)(54906003)(316002)(4326008)(76116006)(91956017)(81166007)(86362001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ndkvbUnahSn+WW77ytU6ET8Zu7llOHGzJdaQwJUMmBmNP9lNy9QaT2JLKrpLyofm3bMBvFYkJICggc+U9SSYi/P44mAtjdGAbDnHFFSFzGkR/PTATgg/5Kgg6CEwbz7ZLXg7+AKzrEX5vB/Vqg3EwMcbB5etlLtGg5GzlEW2cw5xtkMpFV7GTPW/ZD6Lzjy8kVMxUmPgUcfGpuL7gpvSrCxKbBZDzGGjO/KrJuTLVPt7p7KkstBlm6uKjiDPc36fGBvJZiCPcI4hNYqNUm0XSFBJkFEhbuGfYK8jLMl6cEjH9jQQzpv24xZHTXh4nw5Xs3A49q87/unqL65iIoCjQjURw7A7d+l/ZVmcqEoqmBnCu0rHZIrWZw4qf+08INFFmbTMscmES/SDX8vq1o3Wtztsi1Z6zW3WyUK5HygjfUz+hcSEWZsHy+NtrdLd/tD5
x-ms-exchange-antispam-messagedata: QJmfRix2UK+3kawMalQhWbmg7u8CASUzEGQTmo0VcqI2yXYmwPpG0sz7Habz+taQ9AklhcliQNbS2fPNSERBsRomIJhEDmJcSlLkXsMIUOiSFydFSb6TrZgs0XZXEVBpwgd52zzOvBMmS90vNfhlOQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8F6A18A1D47D54BA4F1A9B69B6051E7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a428ce34-834c-4b98-3a24-08d7dcd2ce87
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2020 22:10:26.0167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2V2lqVvmgIpzSiqmue4HncxlbHiKw+1NTQ4dam1vx3KRNc+wAVEHc3zvMxlwYuYpm0XM7WvzqbVpXiNnNICcNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3245
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA0LTA5IGF0IDA5OjQ2ICswMjAwLCBOaWtsYXMgU2NobmVsbGUgd3JvdGU6
DQo+IE9uIHMzOTAgRk9SQ0VfTUFYX1pPTkVPUkRFUiBpcyA5IGluc3RlYWQgb2YgMTEsIHRodXMg
YSBsYXJnZXINCj4ga3phbGxvYygpDQo+IGFsbG9jYXRpb24gYXMgZG9uZSBmb3IgdGhlIGZpcm13
YXJlIHRyYWNlciB3aWxsIGFsd2F5cyBmYWlsLg0KPiANCj4gTG9va2luZyBhdCBtbHg1X2Z3X3Ry
YWNlcl9zYXZlX3RyYWNlKCksIGl0IGlzIGFjdHVhbGx5IHRoZSBkcml2ZXINCj4gaXRzZWxmDQo+
IHRoYXQgY29waWVzIHRoZSBkZWJ1ZyBkYXRhIGludG8gdGhlIHRyYWNlIGFycmF5IGFuZCB0aGVy
ZSBpcyBubyBuZWVkDQo+IGZvcg0KPiB0aGUgYWxsb2NhdGlvbiB0byBiZSBjb250aWd1b3VzIGlu
IHBoeXNpY2FsIG1lbW9yeS4gV2UgY2FuIHRoZXJlZm9yDQo+IHVzZQ0KPiBrdnphbGxvYygpIGlu
c3RlYWQgb2Yga3phbGxvYygpIGFuZCBnZXQgcmlkIG9mIHRoZSBsYXJnZSBjb250aWd1b3VzDQo+
IGFsbGNvYXRpb24uDQo+IA0KPiBGaXhlczogZjUzYWFhMzFjY2U3ICgibmV0L21seDU6IEZXIHRy
YWNlciwgaW1wbGVtZW50IHRyYWNlciBsb2dpYyIpDQo+IFNpZ25lZC1vZmYtYnk6IE5pa2xhcyBT
Y2huZWxsZSA8c2NobmVsbGVAbGludXguaWJtLmNvbT4NCg0KQXBwbGllZCB0byBuZXQtbWx4NSwg
d2lsbCBiZSBzdWJtaXR0ZWQgdG8gbmV0IGluIG15IG5leHQgcHVsbCByZXF1ZXN0Lg0KDQpUaGFu
a3MsDQpTYWVlZC4NCg==
