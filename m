Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A991856FA
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbgCOBbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:31:11 -0400
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:48357
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725962AbgCOBbL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 21:31:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JDN/yfTAG7KTeMIQkGpM2wcAfZE8ykGK/fQveRpohjdwJ7i7Nm7Rpif4Ey5BrHxE4dP09uB7RyDxwT0BSyEdGIF+wOhvHmF/dDyqV/nRR6rXkIRSvxb7ai2MhM+/RzpCJFZFat45ZYe4h1mt9mOaaI73MJ20DWGHa/zWTLANT6zHmtmAfPwgbkUhrJSEHaeQU5Ga5B6Vo8K1bCYFXwx+pD6YUPoFbROpkCEkUE6P5F70+9rxJ48Zq35gcTBbXLGQeWrYwqsDHiqjfWNY07Pt6978ItOK0mwVBN/KNtw8xkHv7/LoTY0DWMi3nmT1ySdocIsrlRbgG8jCanieWzkniQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WGOqc/admVbk5l+sZeePGJnp3eyvyvL6Hb9n9kIrdUE=;
 b=kuy2O/BQICktcesoaGc+cQNW7dfSS4vlo4RTCubgmskkYkVAGcoS3+rtJu9IjHFtAQw+ZM25XB0UVpLaLS6NC3Y9Ezq0u90/LiLC2GTeRIHd/sl/ownBtfFLDKyNI1K/eJ57bymzHHthnyfcPpUgCr+VATRW7FE2QYQO6zxIh84HOf2QQA/XqYxvDnitOjQDK3GyQo8Xfh0KXjD8vuU6MIS3S4fIXxP6+qgkp5mjeNCk3hGYIkKnJFVsy5mmuOXQAK4KIeTuitPsZk+lf9PNqERWYEYWfCJAVX5MzWHEa1bO4IYAymRTBX3/IPsrdeLBRVfRQ1xJCIqQvUrIKWvKng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WGOqc/admVbk5l+sZeePGJnp3eyvyvL6Hb9n9kIrdUE=;
 b=pPdNIERKWHCn4KZ3l03WlXFkxcbyKdfsasGLAWNOuWELhf360Qr8QKLdGU7dVWyMXHZs5YgNWw91Lty14MX4TGh6v7IgxQ3dus0O1mj1lvzhXF0/vkuFS91g1PZrruzw7JNzV7jL1rl3ATbBfpinA/JrcK9crQhon0gRhs7otg0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5376.eurprd05.prod.outlook.com (20.178.9.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Sat, 14 Mar 2020 06:13:43 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 06:13:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>
Subject: Re: [net-next 07/14] net/mlx5: E-Switch, Update VF vports config when
 num of VFs changed
Thread-Topic: [net-next 07/14] net/mlx5: E-Switch, Update VF vports config
 when num of VFs changed
Thread-Index: AQHV+Z5Ct/oa0DPs5U2GJbkOmh9poqhHX4kAgAA8owA=
Date:   Sat, 14 Mar 2020 06:13:43 +0000
Message-ID: <82a53bad75c33302461a19953b962ca22089d7e2.camel@mellanox.com>
References: <20200314011622.64939-1-saeedm@mellanox.com>
         <20200314011622.64939-8-saeedm@mellanox.com>
         <20200313193638.6d9fdff8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200313193638.6d9fdff8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: 96dda191-5789-4c00-c37b-08d7c7ded910
x-ms-traffictypediagnostic: VI1PR05MB5376:|VI1PR05MB5376:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5376E67ABDE2764FEC9E4012BEFB0@VI1PR05MB5376.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 034215E98F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(199004)(64756008)(66446008)(71200400001)(66476007)(91956017)(76116006)(66946007)(5660300002)(54906003)(2906002)(66556008)(6506007)(8936002)(81166006)(316002)(8676002)(81156014)(15650500001)(6512007)(6486002)(4326008)(186003)(2616005)(26005)(6916009)(107886003)(36756003)(478600001)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5376;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7rrV449dxy5mY7EWlri0Pp2F/VQ0tTMCpidaeclO6c3T7w0k9fxJ2PRGscGJjiqiWoHKt1NjlvgZhtZVyoN88ASENyBMh1q+Ypqm6FylOW68h77qjE76MUY5xYC0ekHRUOaQmd5B69ilLDD3rK/ZdqZHuBv5oQSKVydRUHne3yd7wFY0RNz3i6+O4/LrFR+GtHzrwGiTfbv2BxaJPaBtWra1Jl254y6Zfl1AnZUOXqVWPrvRJYb8Kgv46Ov7CSjrkU8DJIKnDj203V0yM6IL8LUswcKwblnJ8i8wuioc0nNMxoigrq9/0gNlYtQEbWyrYt0Tr7/NdpsbMgx6Td7XhkhP8pSXe6w61EcAJIJxKS2+j5McAMHfZ3jZXwMhIR0EINMyWA/63a9w9sITrCWl/H3n0/iUm5+4h+J0Kwbmd35VYy9M0d4kcVbAzZvxjiA2
x-ms-exchange-antispam-messagedata: i8PkiuTVtzYb0u0bPRQjjQiPfMS6vEuzso7KIcPnDAsNyk2u0Uc1L/AAFUT19vCBd4VnXXKM3UmZJy2XYO5u5rmzYo6IAKfUI/j/iXkRu29wodqJYgDenF6cNHI441dNyjuT1ERm+g3x25n9svvqjQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <B38CB5D6455B2B4B8614DA352D82D76B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96dda191-5789-4c00-c37b-08d7c7ded910
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2020 06:13:43.2917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fYXpJofnVTFJGCwR3lA6XT0lykamaMjZaRQmcFa7+XdJzyegiWyGoHU3pUtwcNdpje5tlqLMmvRupwF+0f3x0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5376
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTAzLTEzIGF0IDE5OjM2IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCAxMyBNYXIgMjAyMCAxODoxNjoxNSAtMDcwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBGcm9tOiBCb2RvbmcgV2FuZyA8Ym9kb25nQG1lbGxhbm94LmNvbT4NCj4gPiANCj4g
PiBDdXJyZW50bHksIEVDUEYgZXN3aXRjaCBtYW5hZ2VyIGRvZXMgb25lLXRpbWUgb25seSBjb25m
aWd1cmF0aW9uDQo+ID4gZm9yDQo+ID4gVkYgdnBvcnRzIHdoZW4gZGV2aWNlIHN3aXRjaGVzIHRv
IG9mZmxvYWRzIG1vZGUuIEhvd2V2ZXIsIHdoZW4gbnVtDQo+ID4gb2YNCj4gPiBWRnMgY2hhbmdl
ZCBmcm9tIGhvc3Qgc2lkZSwgZHJpdmVyIGRvZXNuJ3QgdXBkYXRlIFZGIHZwb3J0cw0KPiA+IGNv
bmZpZ3VyYXRpb25zLg0KPiA+IA0KPiA+IEhlbmNlLCBwZXJmb3JtIFZGcyB2cG9ydCBjb25maWd1
cmF0aW9uIHVwZGF0ZSB3aGVuZXZlciBudW1fdmZzDQo+ID4gY2hhbmdlDQo+ID4gZXZlbnQgb2Nj
dXJzLg0KPiANCj4gT2gsIEkgdGhvdWdodCB5b3Uga2VwdCBtYXhfdmZzIG51bWJlciBvZiByZXBy
cyBvbiB0aGUgRUNQRiwgYWx3YXlzLg0KPiBPciB3YXMgdGhhdCBqdXN0IHRoZSBpbml0aWFsIHBs
YW4/DQoNCk5vLCBTbWFydG5pYydzIEVDUEYgc3dpdGNoZGV2IHdhcyByZXF1aXJlZCB0byBiZSBs
b2FkZWQgb25seSBhZnRlciBob3N0DQpQRiBlbmFibGVzIHNyaW92LCBzbyBpdCB3aWxsIGdldCB0
aGUgY29ycmVjdCBudW1fdmZzIGFuZCBpbml0aWFsaXplDQplc3dpdGNoIGFuZCByZXBzIGFjY29y
ZGluZ2x5Lg0KDQozIHJlYXNvbnMgdG8gY2hhbmdlIHRoaXM6DQoxLiBSZW1vdmUgdGhlIGRlcGVu
ZGVuY3kgb2Ygd2hlbiB0byBsb2FkIHRoZSBzd2l0Y2hkZXYgbW9kZSBpbiBFQ1BGIGFuZA0KbWFr
ZSB0aGUgYWRtaW4gbGlmZSBlYXNpZXINCjIuIGJldHRlciBjb2RlIGR5bmFtaWNzIGFuZCB2cG9y
dCBtYW5hZ2VtZW50Lg0KMy4gcGF2ZSB0aGUgd2F5IGZvciBmdXR1cmUgc3VwcG9ydCBvZiBkeW5h
bWljYWxseSBjcmVhdGVkIFN1Yi0NCmZ1bmN0aW9ucy4uICANCg==
