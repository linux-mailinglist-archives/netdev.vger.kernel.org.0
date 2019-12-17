Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D947123207
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbfLQQTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:19:31 -0500
Received: from mail-bn8nam11on2073.outbound.protection.outlook.com ([40.107.236.73]:39265
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728695AbfLQQPJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXFvK7l2FwGD2f80+usBtIGhYnahJWQ47r54yCvtlPedq+qd5+zycJVvxTXjzoDplLG3/hFtZkNscC2gaCpfSQYEheLef9N06qY5GcSFLgRiin0D05rrDP9feqzflRYfyDGwuGgYFOmYGthXU2JaeanIT8rIlOSHY5c6I/m7lxP7hdr4TdB5df1Y8xp4lpEWwRJjC/tinbNl+cwbLuZVD/3Gic+rOBhQG2pUbPqjR3luywV06Hw1jVtoPUr3QZWjL96CAaPj1TD0t/swdeFFACokLJ+B0JojWE8D/SsRRuwjh06pG1M58fTbf6CjC9gAvc9EcGkGqHwRLPcWqlozEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVfERpOAMaOcy/XnkyLUQlU1LwX2b+Jc9frQPgMyf1k=;
 b=QR9cssSb/fYU47/VEViFv4xg0m9Kmg2GXVQgH4AH/lP0IK9uQFXC35PhLTWnxsdWXBVdWF0wqHD5aUlx9bfe9xqA/Rb9NBW9De0Yd6iRM6935nS5xVjUuzRhJiIlhfhOsfuy0LMlpaIcQi+sbKEOGb8T99rxuck2w+U5MiD5kk+PZcBbcGIYpn4CmJWaXUzi7mylRfHXR82S3vl5gpsWiXzog52VU+0RqtRAOjW5rmDFP4rVu7M6arrhef04xNj5kkJ/wmiQIxqk4ba0pQgGy52ATg/LNXF+CgbJapNV9mPq0qEggK6KP8CP77togaJodSZ4kTHRAMladRwzasT+Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVfERpOAMaOcy/XnkyLUQlU1LwX2b+Jc9frQPgMyf1k=;
 b=Yg6v0p7HaoD2P78mfBrE+JlXibCJs3ixIfYHntZcnu7MZ7WgiADNOYFLTOi6ulGsGwU0ABYx4VLI5MBvyX/g85Gw/Bffoho0TRJ4AbOTuO01Ojk4b/vYnuYu2kq5ih4RSBTNswIEcW2Jw0dnCPNjz+eGqGUFR7ud0sEAoWqhHQ0=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4208.namprd11.prod.outlook.com (52.135.36.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 16:15:02 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:02 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 24/55] staging: wfx: fix typo in "num_i_es"
Thread-Topic: [PATCH v2 24/55] staging: wfx: fix typo in "num_i_es"
Thread-Index: AQHVtPUiOHoYnMTN1kWa4u/suVmmWw==
Date:   Tue, 17 Dec 2019 16:15:01 +0000
Message-ID: <20191217161318.31402-25-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 142340f8-cfca-4c84-06a3-08d7830c451c
x-ms-traffictypediagnostic: MN2PR11MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4208C5E36FB6A000FDE80B8793500@MN2PR11MB4208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:328;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(5660300002)(316002)(6506007)(85182001)(478600001)(71200400001)(2906002)(36756003)(186003)(26005)(81166006)(54906003)(1076003)(110136005)(66574012)(4326008)(8676002)(86362001)(6486002)(52116002)(6512007)(64756008)(85202003)(66946007)(66476007)(66446008)(66556008)(8936002)(107886003)(2616005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4208;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aJIedjl3q+ZvtjwuULhDmjSzLUvqlm1ymNSOEaA8pyC+Z/UxT/6GatLJhf4xGB23U5GCSZfQEH3jUQzFVqWtH9k3mZ8aAbAjBGiunc+VsoRp52n3waUOkFakWNX7RfR6KAQVkwE4gCbKEWavtc2Ii+OhuiZXIzTP0IGCO9v0sjeB1ycdqZjvbTzIItYOTON2r4u2R1N2hu8CBj5ok6oXrc2f3+FnUhwKivsrFcHqgCttvxKs8rQTtW1yKHnkgVlwSPCb6JQcBPqlUYyQw8iakwxMwJFz1PVUXg8EjdOnx5kfeg8rL/aKdFPGx6wiRdKyOqqmNNBb9cZH9CX6+ch9xcUIRc9NiPKVFO2abjSGfWG6L5nOwjJS8Pqqwj4qk1rsOJeJte4jNLq4ZBaQ7TS10zb064Kip/YDP6NDvVruc4eu8zYDodjguh2cL6hwQ5iX
Content-Type: text/plain; charset="utf-8"
Content-ID: <49EB48B41716304DBAA5DE74A0B28B1D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 142340f8-cfca-4c84-06a3-08d7830c451c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:02.0004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DS4KesVjshD1+li43W7tudl09+bJYZXRg7DcT7e7Gk5pXovGcYaBRPutpnfivolhJFAjueHYMjOaJD7x3XfH4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHNjcmlwdCB0aGF0IGhhcyBpbXBvcnRlZCBBUEkgaGVhZGVyIGhhcyBtYWRlIGEgbWlzdGFrZSAi
bnVtX2lfZXMiLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3Vp
bGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaCB8
IDIgKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgICAgICB8IDIgKy0KIDIgZmlsZXMg
Y2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlm
X2FwaV9jbWQuaAppbmRleCA5MGJhNmU5YjgyZWEuLjNlNzdmYmUzZDVmZiAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX2FwaV9jbWQuaApAQCAtMTM3LDcgKzEzNyw3IEBAIHN0cnVjdCBoaWZfaWVfdGx2IHsK
IAogc3RydWN0IGhpZl9yZXFfdXBkYXRlX2llIHsKIAlzdHJ1Y3QgaGlmX2llX2ZsYWdzIGllX2Zs
YWdzOwotCXUxNiAgIG51bV9pX2VzOworCXUxNiAgIG51bV9pZXM7CiAJc3RydWN0IGhpZl9pZV90
bHYgaWVbXTsKIH0gX19wYWNrZWQ7CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCmluZGV4IDJmNzRhYmNhMmI2
MC4uNmZiOThkZGJjMGUyIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5j
CisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKQEAgLTQyOSw3ICs0MjksNyBAQCBp
bnQgaGlmX3VwZGF0ZV9pZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgY29uc3Qgc3RydWN0IGhpZl9p
ZV9mbGFncyAqdGFyZ2V0X2ZyYW1lLAogCXN0cnVjdCBoaWZfcmVxX3VwZGF0ZV9pZSAqYm9keSA9
IHdmeF9hbGxvY19oaWYoYnVmX2xlbiwgJmhpZik7CiAKIAltZW1jcHkoJmJvZHktPmllX2ZsYWdz
LCB0YXJnZXRfZnJhbWUsIHNpemVvZihzdHJ1Y3QgaGlmX2llX2ZsYWdzKSk7Ci0JYm9keS0+bnVt
X2lfZXMgPSBjcHVfdG9fbGUxNigxKTsKKwlib2R5LT5udW1faWVzID0gY3B1X3RvX2xlMTYoMSk7
CiAJbWVtY3B5KGJvZHktPmllLCBpZXMsIGllc19sZW4pOwogCXdmeF9maWxsX2hlYWRlcihoaWYs
IHd2aWYtPmlkLCBISUZfUkVRX0lEX1VQREFURV9JRSwgYnVmX2xlbik7CiAJcmV0ID0gd2Z4X2Nt
ZF9zZW5kKHd2aWYtPndkZXYsIGhpZiwgTlVMTCwgMCwgZmFsc2UpOwotLSAKMi4yNC4wCgo=
