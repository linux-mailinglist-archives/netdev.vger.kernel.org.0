Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14BC81975F8
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbgC3Hso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:48:44 -0400
Received: from mail-eopbgr00082.outbound.protection.outlook.com ([40.107.0.82]:56836
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728766AbgC3Hso (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 03:48:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiPXmno6+pXH4W3MDxWP5WQ8YdqEP4Ld+HRm80uA9QFyTpfQqHScPXfaygBK4SR5X3FdzDRyqQpBEbrGmPLrsJZBXzMUyOM3SAbu0FAaCmPd+E4oPCiIoNa+/fgEUH7RTtO/HhoIV5wlMNYB4NBPus16CJ6u4LRDF2XL0+NTDmykcUmdnvgOKDDCwBEaqk+wsODQdYnc8tyGCOnXeeyI5KovB1ijda8bC/dZF2AwwP8RpvjWz3dtHRAgfahCMd6yfae/EmKzMrtx+PHtTaNCDEQPQvrF6P91m7jgQP/9ALaDKYFjq3jcaIEWzM02L33Vw805ZMmyJaUPYFbADsreMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSukeuJX/JRsOSyPpsIavZ2uv6JC4dY5CIIKmp2dp1g=;
 b=d558Zpz9Tgqf1/re8iR3ccw7xtb/HDEFLwJNaE4OOZ1OcP/C6w0Hpo7JhaBGcFjzQPC2Z8loHnEeTOO90G6OFhFZ6NFzNOl6fLego77wSb/3LDfL1ouZIt9tohJrjJvg9n55AIYMuPaIXn2neSxgHWtTWiuLFhg3PPTYTbbjE8+XLOkbP6R8chLGeMbVwMa09xPNW83QRQA0UREAJWe1NUTm8Dkir4Q5x0lm1OIy1Q427OijFSET4F5yn7ZncFRJUHTgTwCAAjnvZQbhAQ87GDWKOT/A0SHBhdAqD17AB7zJqVZly39veAneJyXHudziVdz6rOmf2lYEiUQ4aUzODQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSukeuJX/JRsOSyPpsIavZ2uv6JC4dY5CIIKmp2dp1g=;
 b=M3UqsY900NvJQnEEphGXBZNJk2JQYyO5QG7uQhBXC459j9eMowwDZU3BoetlV/GshurNrhwRAiHQW932zjlXpTvUkpMUzDESlY00Pdh1fckWVka3x+LEgm1wXauoUZWHiKUJPlZ0xGJpoM7gi6fGVlcLLZ03JAn9jYUIStgTm/4=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4897.eurprd05.prod.outlook.com (20.177.42.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.19; Mon, 30 Mar 2020 07:48:39 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 07:48:39 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Yuval Avnery <yuvalav@mellanox.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Alex Vesker <valex@mellanox.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "lihong.yang@intel.com" <lihong.yang@intel.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
Subject: Re: [RFC] current devlink extension plan for NICs
Thread-Topic: [RFC] current devlink extension plan for NICs
Thread-Index: AQHV/iRsiKU58im38Um7T8fyNtLerKhQ1DGAgABD54CAAOeuAIAAzAqAgAPIYYCABGpggIAAAUoAgABegoCAAL1QAIAAlFSAgAQi9AA=
Date:   Mon, 30 Mar 2020 07:48:39 +0000
Message-ID: <35e8353f-2bfc-5685-a60e-030cd2d2dd24@mellanox.com>
References: <20200319192719.GD11304@nanopsycho.orion>
 <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
 <20200320073555.GE11304@nanopsycho.orion>
 <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
 <20200321093525.GJ11304@nanopsycho.orion>
 <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200326144709.GW11304@nanopsycho.orion>
 <20200326145146.GX11304@nanopsycho.orion>
 <20200326133001.1b2694c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200327074736.GJ11304@nanopsycho.orion>
 <20200327093829.76140a98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200327093829.76140a98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [49.207.58.93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ef05d5c0-5891-4d2c-f490-08d7d47ec29b
x-ms-traffictypediagnostic: AM0PR05MB4897:|AM0PR05MB4897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4897848DC846474FD29AEF71D1CB0@AM0PR05MB4897.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0358535363
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(26005)(6506007)(186003)(55236004)(53546011)(2616005)(36756003)(31686004)(2906002)(7416002)(6512007)(6486002)(8936002)(81156014)(81166006)(66446008)(64756008)(66556008)(4326008)(66476007)(66946007)(54906003)(8676002)(86362001)(76116006)(91956017)(71200400001)(316002)(110136005)(478600001)(5660300002)(31696002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XIyTZuQ1lJwmmL20r+GQRDQwXQKO6XttlUkZBTTSE8vzjI7yqCuFg2gP/4Bj+b5jMZ2r5TuDxqr6Pg/LUtalc7IYJaYTLn92Fo1OUlOEIGjbnq2ln6ZEbBqTf1JUTY3Al9f3jQ2H6s5A23/N7bnT2d6C62jjAjwiIBFrMz/h/wmVvrPe7cvhnO9Hsgrk9PHBppCX7XXctN3xSqxrw2zNfn/FrOBIyhgqtzylpLFVtxmrkPT/rGgnXUBeksktC5+hG8NDTbIcfolY+XpYJ3W4yV6IToQy3FY4yHpXaObveLNX6FRyM2dY0U+n9ZLdlmH2hwRYVx/hrBNlT6XFpVD3QWSVK9kwfYWwwjfb0PRlEIf58lBO7VpwVtXozc1WEusRi9nH5HE3loUBR7G3ScpnAlsAqGJTZKdad+dcwHi+KB/wKFrXTbsNE3KxlxmFqSDx
x-ms-exchange-antispam-messagedata: yOFOD2Me936GU3cvnlO3Oh281/uUuMB10wYSr4Dn2MAxIBMxai4QKg0tkn2ogdTLeSHywhpnIaQOURb5+MvOow6/+8iw7Oh6FyrHuT9zlnNy3dsVYUpTOlY6Q44DjPQZ7Gx0A4WKIBs9ky9lHf7qoQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <6EA0508687FAFB4094E6CE104A51DD1A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef05d5c0-5891-4d2c-f490-08d7d47ec29b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2020 07:48:39.0503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OjMZRv5d3R4cKR0dNpdXGqfmbNJijFExEIVSAR0+xXxNJWqVDhswa1I9a4Jb9O4ZEgOX/Oi+lMRoOPZXzi1QKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4897
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrdWIsDQoNCk9uIDMvMjcvMjAyMCAxMDowOCBQTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6
DQo+IE9uIEZyaSwgMjcgTWFyIDIwMjAgMDg6NDc6MzYgKzAxMDAgSmlyaSBQaXJrbyB3cm90ZToN
Cj4+PiBTbyB0aGUgcXVldWVzLCBpbnRlcnJ1cHRzLCBhbmQgb3RoZXIgcmVzb3VyY2VzIGFyZSBh
bHNvIHBhcnQgDQo+Pj4gb2YgdGhlIHNsaWNlIHRoZW4/ICANCj4+DQo+PiBZZXAsIHRoYXQgc2Vl
bXMgdG8gbWFrZSBzZW5zZS4NCj4+DQo+Pj4gSG93IGRvIHNsaWNlIHBhcmFtZXRlcnMgbGlrZSBy
YXRlIGFwcGx5IHRvIE5WTWU/ICANCj4+DQo+PiBOb3QgcmVhbGx5Lg0KPj4NCj4+PiBBcmUgcG9y
dHMgYWx3YXlzIGV0aGVybmV0PyBhbmQgc2xpY2VzIGFsc28gY292ZXIgZW5kcG9pbnRzIHdpdGgN
Cj4+PiB0cmFuc3BvcnQgc3RhY2sgb2ZmbG9hZGVkIHRvIHRoZSBOSUM/ICANCj4+DQo+PiBkZXZs
aW5rX3BvcnQgbm93IGNhbiBiZSBlaXRoZXIgImV0aGVybmV0IiBvciAiaW5maW5pYmFuZCIuIFBl
cmhhcHMsDQo+PiB0aGVyZSBjYW4gYmUgcG9ydCB0eXBlICJudmUiIHdoaWNoIHdvdWxkIGNvbnRh
aW4gb25seSBzb21lIG9mIHRoZQ0KPj4gY29uZmlnIG9wdGlvbnMgYW5kIHdvdWxkIG5vdCBoYXZl
IGEgcmVwcmVzZW50b3IgIm5ldGRldi9pYmRldiIgbGlua2VkLg0KPj4gSSBkb24ndCBrbm93Lg0K
PiANCj4gSSBob25lc3RseSBmaW5kIGl0IGhhcmQgdG8gdW5kZXJzdGFuZCB3aGF0IHRoYXQgc2xp
Y2UgYWJzdHJhY3Rpb24gaXMsDQo+IGFuZCB3aGljaCB0aGluZ3MgYmVsb25nIHRvIHNsaWNlcyBh
bmQgd2hpY2ggdG8gUENJIHBvcnRzIChvciB3aHkgd2UgZXZlbg0KPiBoYXZlIHRoZW0pLg0KPiAN
CkluIGFuIGFsdGVybmF0aXZlLCBkZXZsaW5rIHBvcnQgY2FuIGJlIG92ZXJsb2FkZWQvcmV0cm9m
aXQgdG8gZG8gYWxsDQp0aGluZ3MgdGhhdCBzbGljZSBkZXNpcmVzIHRvIGRvLg0KRm9yIHRoYXQg
bWF0dGVyIHJlcHJlc2VudG9yIG5ldGRldiBjYW4gYmUgb3ZlcmxvYWRlZC9leHRlbmRlZCB0byBk
byB3aGF0DQpzbGljZSBkZXNpcmUgdG8gZG8gKGluc3RlYWQgb2YgZGV2bGluayBwb3J0KS4NCg0K
Q2FuIHlvdSBwbGVhc2UgZXhwbGFpbiB3aHkgeW91IHRoaW5rIGRldmxpbmsgcG9ydCBzaG91bGQg
YmUgb3ZlcmxvYWRlZA0KaW5zdGVhZCBvZiBuZXRkZXYgb3IgYW55IG90aGVyIGtlcm5lbCBvYmpl
Y3Q/DQpEbyB5b3UgaGF2ZSBhbiBleGFtcGxlIG9mIHN1Y2ggb3ZlcmxvYWRlZCBmdW5jdGlvbmFs
aXR5IG9mIGEga2VybmVsIG9iamVjdD8NCkxpa2Ugd2h5IG1hY3ZsYW4gYW5kIHZsYW4gZHJpdmVy
cyBhcmUgbm90IGNvbWJpbmVkIHRvIGluIHNpbmdsZSBkcml2ZXINCm9iamVjdD8gV2h5IHRlYW1p
bmcgYW5kIGJvbmRpbmcgZHJpdmVyIGFyZSBjb21iaW5lZCBpbiBzaW5nbGUgZHJpdmVyDQpvYmpl
Y3Q/Li4uDQoNClVzZXIgc2hvdWxkIGJlIGFibGUgdG8gY3JlYXRlLCBjb25maWd1cmUsIGRlcGxv
eSwgZGVsZXRlIGEgJ3BvcnRpb24gb2YNCnRoZSBkZXZpY2UnIHdpdGgvd2l0aG91dCBlc3dpdGNo
Lg0KV2Ugc2hvdWxkbid0IGJlIHN0YXJ0aW5nIHdpdGggcmVzdHJpY3RpdmUvbmFycm93IHZpZXcg
b2YgZGV2bGluayBwb3J0Lg0KDQpJbnRlcm5hbGx5IHdpdGggSmlyaSBhbmQgb3RoZXJzLCB3ZSBh
bHNvIGV4cGxvcmVkIHRoZSBwb3NzaWJpbGl0eSB0bw0KaGF2ZSAnbWdtdHZmJywgJ21nbXRwZics
ICAnbWdtdHNmJyBwb3J0IGZsYXZvdXJzIGJ5IG92ZXJsb2FkaW5nIHBvcnQgdG8NCmRvIGFsbCB0
aGluZ3MgYXMgdGhhdCBvZiBzbGljZS4NCkl0IHdhc24ndCBlbGVnYW50IGVub3VnaC4gV2h5IG5v
dCBjcmVhdGUgcmlnaHQgb2JqZWN0Pw0KDQpBZGRpdGlvbmFsbHkgZGV2bGluayBwb3J0IG9iamVj
dCBkb2Vzbid0IGdvIHRocm91Z2ggdGhlIHNhbWUgc3RhdGUNCm1hY2hpbmUgYXMgdGhhdCB3aGF0
IHNsaWNlIGhhcyB0byBnbyB0aHJvdWdoLg0KU28gaXRzIHdlaXJkIHRoYXQgc29tZSBkZXZsaW5r
IHBvcnQgaGFzIHN0YXRlIG1hY2hpbmUgYW5kIHNvbWUgZG9lc24ndC4NCg0KPiBXaXRoIGRldmlj
ZXMgbGlrZSBORlAgYW5kIE1lbGxhbm94IENYMyB3aGljaCBoYXZlIG9uZSBQQ0kgUEYgbWF5YmUg
aXQNCj4gd291bGQgaGF2ZSBtYWRlIHNlbnNlIHRvIGhhdmUgYSBzbGljZSB0aGF0IGNvdmVycyBt
dWx0aXBsZSBwb3J0cywgYnV0DQo+IGl0IHNlZW1zIHRoZSBwcm9wb3NhbCBpcyB0byBoYXZlIHBv
cnQgdG8gc2xpY2UgbWFwcGluZyBiZSAxOjEuIEFuZCByYXRlDQo+IGluIHRob3NlIGRldmljZXMg
c2hvdWxkIHN0aWxsIGJlIHBlciBwb3J0IG5vdCBwZXIgc2xpY2UuDQo+IA0KU2xpY2UgY2FuIGhh
dmUgbXVsdGlwbGUgcG9ydHMuIHNsaWNlIG9iamVjdCBkb2Vzbid0IHJlc3RyaWN0IGl0LiBVc2Vy
DQpjYW4gYWx3YXlzIHNwbGl0IHRoZSBwb3J0IGZvciBhIGRldmljZSwgaWYgZGV2aWNlIHN1cHBv
cnQgaXQuDQoNCj4gQnV0IHRoaXMga2VlcHMgY29taW5nIGJhY2ssIGFuZCBzaW5jZSB5b3UgZ3V5
cyBhcmUgZG9pbmcgYWxsIHRoZSB3b3JrLA0KPiBpZiB5b3UgcmVhbGx5IHJlYWxseSBuZWVkIGl0
Li4NCj4NCg==
