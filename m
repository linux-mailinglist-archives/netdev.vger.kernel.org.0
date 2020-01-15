Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E98B513C415
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbgAON4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:56:12 -0500
Received: from mail-eopbgr770088.outbound.protection.outlook.com ([40.107.77.88]:50046
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726483AbgAON4F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:56:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FK+PfV0fTdSSt5GLk5Xq5a2V562wFUsJRE4ksywBJgjeWVX/gpRDwY0GX6+GRxbM/+oBIvS/RREAClNBO+LYXvyiuGBbVpkvsvtgQ8Luzwsqla8vsgpEmFl4lnaQ/WGeZafJCdAMQtTkmSo74zJJoOkUejEzKYgIryBSF1YGSsDd/z1TlcH7HzT9Yzzhlw4sYaJNl1HtSEY74+qlCJwP94XXpVz//uWL9QeZh5KK9oq18K9ENqC1uHQ1O+wPwOgDGLHBjVsxklsPpSHTx8sKITFQ0kcXk3RQmCxKEtXj1LYQJUSSKx1Vx3wozQnUaPVvVG4tmfhqCVXQQ4kIFJAt+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=luKP9pYxXrpl3mvhVrHrZpccjgG6OVYJbBR4szwSZPY=;
 b=VXC6v1C8MUJcPH9VMPLRLOeGDH9i7MvxzWF47CAwnqYSHuPeTQL+RUVu9sRVHmpJkUGBQO3VHhtvEPsj/qfKJg0cA83wp+EnjlwWZh1uF6CJ73UmRk3DEJPybR7jwJBhxYo7XcEQh1eEIM4qpDReztZWLTsRUBJSjtzg4j6Fx+IuDyxYEWrBbJGg3+XdYBBdSmq3cX5YeOTWay03Rnk01No9jOsr0DBzUFJ+NN1G7dEpvRYRelM39Hk2pJWVtLBpWFG4rNOB5LaKEtJfCrjHdcFbA1vRMEUPtsdi4sqeonvsOQC8tMfnaR0IQlrI/Q4SniEO3O8W8EEtuwazZtHHXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=luKP9pYxXrpl3mvhVrHrZpccjgG6OVYJbBR4szwSZPY=;
 b=FyUDkgn2TMWKss8U2jAKuJk24hXB3y2h2mGvnCFgpNIikKC0XCNMCpt4d2VryUAXzypGW6dXjS4gaPu9kCaVG8fhS7XTFJxvKgpnY70OMoOICpJGLCjRcX0B0bv8kuTzMTY6agqg/LoG2KpCXcl0nYmqEga4DS6+mo7uXjCD2HI=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:56:03 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:56:03 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:55:29 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 60/65] staging: wfx: remove unused do_probe
Thread-Topic: [PATCH v2 60/65] staging: wfx: remove unused do_probe
Thread-Index: AQHVy6ty7Ppps4SXe0+96o2pePTplg==
Date:   Wed, 15 Jan 2020 13:55:30 +0000
Message-ID: <20200115135338.14374-61-Jerome.Pouiller@silabs.com>
References: <20200115135338.14374-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115135338.14374-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20)
 To MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fa00058-2186-418e-b5d9-08d799c2952d
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3661C921645EF18A1522FE4B93370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:457;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(4744005)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(6666004)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N+LVLaDWTVM8cx9F9tNbvQlCyZDYWNwSLpazfhwCPdomULGQGVMeQfNxLTNPkUXbV/5PzFgnoggEdoVr+cwcc4koZ3uSf4m4goAbyDCTqCAjhOY+VnnonIQu7ZVDYJ5dR48ENr27y7Fm5vD1H0UPFTceTleCQfwHFzk1pu6gg/eX5ZFd16NxgoGXzoIEfgn6f5iNZ6Z5lEINIvRv0nihv8K6BYlvz+2SaYfC+lPGhdZUYSam27ItgGjh0CkvXuuYL3B90YZ47i86knf+I8g5slJdZIMch0x0VNN7Fm5sFw04oJBqzzzs1LJyMAffjoanZYcEFzFGAyyMyVHomOKG8Hjt9rPpMfcV5dS5wP5nQMGQv/nmVaxxNws2W2ActWMsRiBTU9dPwn3UZIeoobIZPG9fY95nZey4pDy0qgNj/dnVVkRgmXVWea5zE1FGYl03
Content-Type: text/plain; charset="utf-8"
Content-ID: <94964944C8DCBB48B103D2A5A58D0E3A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fa00058-2186-418e-b5d9-08d799c2952d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:55:30.4858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yEtPq4oO3Bi19KapvXhW3hjaN+lcsdW4DgrPp0lQ8Y8ZlJ6c0+VYt6wID+Nry8cqh125TpV3yq++TvfVLZMW+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGlkZW50aWZpZXIgZG9fcHJvYmUgaXMgdW51c2VkIHNpbmNlICJzdGFnaW5nOiB3Zng6IHJlbW92
ZSB3b3JrYXJvdW5kCnRvIHNlbmQgcHJvYmUgcmVxdWVzdHMiCgpTaWduZWQtb2ZmLWJ5OiBKw6ly
w7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9z
dGFnaW5nL3dmeC9xdWV1ZS5jIHwgMSAtCiAxIGZpbGUgY2hhbmdlZCwgMSBkZWxldGlvbigtKQoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyBiL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvcXVldWUuYwppbmRleCBlYzExYTYzYTJmZjkuLmM4N2Q2NGZiYjg4ZiAxMDA2NDQKLS0t
IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
cXVldWUuYwpAQCAtMzY1LDcgKzM2NSw2IEBAIHN0YXRpYyBib29sIGhpZl9oYW5kbGVfdHhfZGF0
YShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IHNrX2J1ZmYgKnNrYiwKIAlzdHJ1Y3QgaWVl
ZTgwMjExX2hkciAqZnJhbWUgPSAoc3RydWN0IGllZWU4MDIxMV9oZHIgKikgKHJlcS0+ZnJhbWUg
KyByZXEtPmRhdGFfZmxhZ3MuZmNfb2Zmc2V0KTsKIAogCWVudW0gewotCQlkb19wcm9iZSwKIAkJ
ZG9fZHJvcCwKIAkJZG9fd2VwLAogCQlkb190eCwKLS0gCjIuMjUuMAoK
