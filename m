Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D45144617
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 21:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgAUUvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 15:51:55 -0500
Received: from mail-eopbgr40052.outbound.protection.outlook.com ([40.107.4.52]:7143
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727360AbgAUUvz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 15:51:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mxc8MJmxe7ggmfM1Vi3Og4BmceI+c1z1z5aymIB31yIF+Z2aHt+9FyttENEQAdL+RLlMvyZvERL1yfd0c1dOI0dfgAr6ktYD069M7d3aTZYw3BH0BiwhyTNnc/c1iXUArGIz6ECQTlBgX17H/+qdNS9PhY6JPDX3CzlznPNuSpHs7HeRzM9eyru2oldmZ3oT50ss+9mkQFj3Jj9s++z+mhgGixOuyf/TUVcZtxKKvQnpwem7ldaBE/+wddiy5LFfdiB3GCiLZYvKr4DK1iCBpZXTD7sNf0WZ18XCfYdhrf/5vssYowPme2nAGFQRV45wTcI2LaTPsFNFwyM21+nPvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LWC2EF/p/VQGts/WF57OJLZlfZocESE604FRvnjLFgQ=;
 b=Y81fGe+SnIInVmlmBtLvNpmMB+x5bl7GiohwfrhO7sv9IiciAdrXqgMoA6WyNY/uRcx6tcpy5jfS9+foVeUqLeutMot6O9ztMUT02yWp1S9A3NSDingxKPlc+9OG1TvUBCyTjRTarm4TFLY6agk63hmdyQqa+Q2eOl92jZcoLE12XQL6iYBUinlocbrnRidGiA7FmGphj0upHD3B3dHRwajS8WrD1pWJKgDpgfF+j2YCtF0vSaTf1YcId/FlX5hbrIx8AkTYkiYm3wQoQSiwv/Xbt4L/IKqJt3l2qFuafjN/GpPhIe3dtTH6em9gndW3ePZk9Rx9YyC4hmzbt0PTaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LWC2EF/p/VQGts/WF57OJLZlfZocESE604FRvnjLFgQ=;
 b=mc1C1XTtmfAaeR3NcD+Pu8qKjL9WxFgfMO8voYhxd2RwyN844PxIguFpr9gWzPyuzSkYyVtT0q/1ZRLpwKhN47Z1n/ZIBhrCdiyr2fGjUHSgf41xNg02G0b+KqkrMleUE/6dGA/b5xIII6b14HWA8WP7fxfb+duRJtd1wFvsRh8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4381.eurprd05.prod.outlook.com (52.133.13.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.25; Tue, 21 Jan 2020 20:51:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Tue, 21 Jan 2020
 20:51:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        Moshe Shemesh <moshe@mellanox.com>
CC:     "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] devlink: Add health recover notifications on
 devlink flows
Thread-Topic: [PATCH net-next] devlink: Add health recover notifications on
 devlink flows
Thread-Index: AQHVztnRsDQzlo/oHESjyf9Do8M2O6fzUGKAgAJLHAA=
Date:   Tue, 21 Jan 2020 20:51:51 +0000
Message-ID: <b03ae6bfd49fea39e6a99d8bf921122d3740a88a.camel@mellanox.com>
References: <1579446268-26540-1-git-send-email-moshe@mellanox.com>
         <20200120.105027.695127072650482577.davem@davemloft.net>
In-Reply-To: <20200120.105027.695127072650482577.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e84514c9-48bf-4acc-fd2e-08d79eb3bdcc
x-ms-traffictypediagnostic: VI1PR05MB4381:|VI1PR05MB4381:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB43817BDC330BD376722A679ABE0D0@VI1PR05MB4381.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(189003)(199004)(91956017)(81166006)(66446008)(81156014)(66556008)(15650500001)(4326008)(86362001)(8676002)(66476007)(66946007)(8936002)(64756008)(76116006)(2616005)(6506007)(26005)(186003)(316002)(54906003)(110136005)(5660300002)(36756003)(6486002)(6636002)(478600001)(2906002)(6512007)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4381;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0QFyR2Pu78U5HtwJe8dGQ5CSPxhLxR2bXWTpfrmV1ch+gdlbeCpQemW7oN7oIz6SE1WRBvYofjf8KhZHOiiquln2XXtmnsl57GFbDeUDDuhr3unpJnQp62sorVHFSIT93t0b7+A/4B4AWe2h1WKmk+/IjGD7fsKkoHqcm4ap9sKH2Z2W02CNZcMJN0ObUCGe2N3YrVzuukUUPwUslCtyPgg7kpkMEpGHwIVRrF3RIG9dVDu1hDnYpRrRmtfIGK7G1UJxFQX+EPQzbNBl6iUmi40BrS3XpNSwTq2UP5rnZR7T3vIzZ4JnlXDUMN2Bo0QJ0uKD7FIn9kg5EuAQ5mKNyIE8c8CNSyHgm/MF9Yg+iUxeKYnonjjAm6b9PaEYXzxqWqtY6gy+77npV0ov/dGPJW4zi3+NvZHtndwiSUqpQ54IeHf/bnTS0uUrjNux4Oqn
Content-Type: text/plain; charset="utf-8"
Content-ID: <902FC8B3001DF04DA29A0D12615DA77C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e84514c9-48bf-4acc-fd2e-08d79eb3bdcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 20:51:51.5108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i1jVcqwEgKLmkRSm6G7xr7a3KUxUwvpTHbTBQlUcCu/XnLB+/ZiN2q1/vjkug3e6J9oxt+KtQw084+TojZVm1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4381
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTAxLTIwIGF0IDEwOjUwICswMTAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IE1vc2hlIFNoZW1lc2ggPG1vc2hlQG1lbGxhbm94LmNvbT4NCj4gRGF0ZTogU3VuLCAx
OSBKYW4gMjAyMCAxNzowNDoyOCArMDIwMA0KPiANCj4gPiBEZXZsaW5rIGhlYWx0aCByZWNvdmVy
IG5vdGlmaWNhdGlvbnMgd2VyZSBhZGRlZCBvbmx5IG9uIGRyaXZlcg0KPiBkaXJlY3QNCj4gPiB1
cGRhdGVzIG9mIGhlYWx0aF9zdGF0ZSB0aHJvdWdoDQo+IGRldmxpbmtfaGVhbHRoX3JlcG9ydGVy
X3N0YXRlX3VwZGF0ZSgpLg0KPiA+IEFkZCBub3RpZmljYXRpb25zIG9uIHVwZGF0ZXMgb2YgaGVh
bHRoX3N0YXRlIGJ5IGRldmxpbmsgZmxvd3Mgb2YNCj4gcmVwb3J0DQo+ID4gYW5kIHJlY292ZXIu
DQo+ID4gDQo+ID4gRml4ZXM6IDk3ZmYzYmQzN2ZhYyAoImRldmxpbms6IGFkZCBkZXZpbmsgbm90
aWZpY2F0aW9uIHdoZW4NCj4gcmVwb3J0ZXIgdXBkYXRlIGhlYWx0aCBzdGF0ZSIpDQo+ID4gU2ln
bmVkLW9mZi1ieTogTW9zaGUgU2hlbWVzaCA8bW9zaGVAbWVsbGFub3guY29tPg0KPiA+IEFja2Vk
LWJ5OiBKaXJpIFBpcmtvIDxqaXJpQG1lbGxhbm94LmNvbT4NCj4gDQo+IEkgcmVhbGx5IGRpc2xp
a2UgZm9yd2FyZCBkZWNsYXJhdGlvbnMgYW5kIGFsbW9zdCBhbGwgb2YgdGhlIHRpbWUgdGhleQ0K
PiBhcmUNCj4gdW5uZWNlc3NhcnkuDQo+IA0KDQpIaSBEYXZlLCBhIHF1ZXN0aW9uIGp1c3QgZm9y
IGVkdWNhdGlvbmFsIHB1cnBvc2VzLCBpIGFncmVlIHJlZ2FyZGluZw0KZnVuY3Rpb24gZm9yd2Fy
ZCBkZWNsYXJhdGlvbnMsIGJvdHRvbS11cCBvcmdhbml6aW5nIHNob3VsZCBhbHdheXMgYmUNCmZv
bGxvd2VkLiANCg0KQnV0IGhvdyBhYm91dCB0eXBlIGZvcndhcmQgZGVjbGFyYXRpb24gPyBmb3Ig
aGlkaW5nIHN0cnVjdCBkZXRhaWxzIGluDQpzcGVjaWZjIGMgZmlsZS4uIGlzIGl0IGEgYmFkIHBy
YWN0aWNlID8NCg0KSSB1c2UgdGhpcyB0cmljayBhIGxvdCBpbiBtbHg1LCBmb3IgZGV0YWlsIGhp
ZGluZyBhbmQgbW9kdWxlIHNlcGFyYXRpb24NCi4uIA0KDQo+IENvdWxkIHlvdSBwbGVhc2UganVz
dCByZWFycmFuZ2UgdGhlIGNvZGUgYXMgbmVlZGVkIGFuZCByZXN1Ym1pdD8NCj4gDQo+IFRoYW5r
IHlvdS4NCg==
