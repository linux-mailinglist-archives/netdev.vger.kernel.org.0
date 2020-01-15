Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA5613C01C
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731151AbgAOMNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:13:25 -0500
Received: from mail-bn7nam10on2047.outbound.protection.outlook.com ([40.107.92.47]:27390
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730843AbgAOMMt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X9bTpbzRcSkJOwKjRAW7u58cqaX4QC+cLw2UrA7/r7kCSZIoewOx0PruvjK/GPYfH96KLNwDVd2gVPORueLeOm4kbfvNP7oAV6Ly3BRaBdFeStzznoTSjp8XjjjQk1gDbg0UmuIuc+Bf8y0i3FjKxKlR/1GBhlJHRZninoL9kKbdmYCglaLzQC3xCuiUOyrK2h1++8ZB0njKRXmaFJ3+VnaCH2aoNBGwIBk8g6C7Eyitc3pBffPwJX4NPkY98ulFpC/Y0obUyIs6/gAwqaaBbtVtxSmDkk2uiBSQ6d1OJ7M5YD0+n+ZlJHkYvfs/xMyZjGspLfM6o4oVLtxrKFdtYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvHPtKXlsvQwnf5lOZyIuOjtMJUoc4RQcmbJFZUNCiI=;
 b=a4zEUW9yonr6m9d1gksT2rPQzcZo4Ml3KwpPpagH0MPXBmBjmPShu9yK1SjQ1X3sPtxS7Wg/naAAkxmS6FLjqx9yBgGonMaTx2f++9gT+KvovziG1faX9XlDo9oNSJJAgMru0ZK2M2wIv+TPG00K7i6iq6qb0ZhekH1lUTduZ5Bso4HDe6aXRzTVdVLbdtN2VPN+sqqqa4m81sKjfPFZpNNZwuZpUPy/xB2Iie0JMSWaO36KGdv5vOWfYldlOTTOy1GXcDwP5hCJqhOfiRJcRUg2HWukkHOrfI5MUzv3ewpEVA9D1hd0r8FiNvx3IwN7GjAk82AmF7OYDKFatioNfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvHPtKXlsvQwnf5lOZyIuOjtMJUoc4RQcmbJFZUNCiI=;
 b=GPuGcuA/Jq7Y0ydO991eFqz0hhtE8X0mzdOWH9B4L6yJ39+MyG7KC6xWAlkauzL1p5u8QqVMyMZb/gq2MAjWJWjFWtaWosTn0MHtm9srLQC84JHGzke3O2iSs5eCT3D25XIaYiuGB5zn6uS+0AojrQAPy6b8iy1ta4H50hyzMFg=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:12:45 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:45 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:44 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 27/65] staging: wfx: SSID should be provided to hif_start()
 even if hidden
Thread-Topic: [PATCH 27/65] staging: wfx: SSID should be provided to
 hif_start() even if hidden
Thread-Index: AQHVy50YjeNNjquSUk2pE0qCTN+9EQ==
Date:   Wed, 15 Jan 2020 12:12:45 +0000
Message-ID: <20200115121041.10863-28-Jerome.Pouiller@silabs.com>
References: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0009.eurprd09.prod.outlook.com
 (2603:10a6:101:16::21) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bdb0882c-3d32-450a-abb6-08d799b43a7a
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4096F012235781617E5E229E93370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(4744005)(1076003)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lf5/5CKDTB49xdvsgXo6lim722nmlwBQg9maoQ+IFFSfetY2pRF0xsogqYoWmz0rpPw6dRJAhU7N000FJkus/xMGysKte5oiVhUA9vePL8oTCPJ7FMOZulSZckbMD0ybsC1SyPMgMnK1RG1LurMjp2zCAS854VNelmmerwyA3MLDFJPRwkDirMToBP1vLs3qE2xIJ4uWn0cUvKX6vMkRSQhtD2NZr4AfIqKb7aaTz9SnDS1Gmnb8Gz4tFTGWkEQUvfDO61aU6NhlHEjVzU3OAYv/enjn8UE9ut74xRoqqytTtHC0qHo/EKMoNuWnn8MKGs2F2NvPvDpGXkZVIXXm4oTrY6aGmPtrKnhnmd4muTxa1B9ufvL8nDyKsA3bun3x6X2DiM8Unvcn20eBLRxFsl4OvG3N9//Rz2OGNU3OFLQHIWBtKJNRhncYjpxVIbKf
Content-Type: text/plain; charset="utf-8"
Content-ID: <08CF7DD9E031CE48B2A501D84D602C51@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdb0882c-3d32-450a-abb6-08d799b43a7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:45.2184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DTJ8DoAzVrP9+CgYlT8lEs2o5tihZE6N/xLDAwvgBoXI31v2L2z92vmGvLE+SGUXGUbqV7LRnGVK924+Y8V4rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU1NJ
RCBpcyBoaWRkZW4gaW4gYmVhY29uIGJ1dCBmaXJtd2FyZSBoYXMgdG8ga25vdyB0byB3aGljaCBw
cm9iZQpyZXF1ZXN0cyBpdCBoYXMgdG8gYW5zd2VyLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUg
UG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3R4LmMgfCA2ICsrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygr
KSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90
eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYwppbmRleCAyZDU0MTYwMWUyMjQuLjhk
ZjZlNDNmZTc0MiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYworKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCkBAIC00MjIsMTAgKzQyMiw4IEBAIGludCBo
aWZfc3RhcnQoc3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfYnNz
X2NvbmYgKmNvbmYsCiAJYm9keS0+YmVhY29uX2ludGVydmFsID0gY3B1X3RvX2xlMzIoY29uZi0+
YmVhY29uX2ludCk7CiAJYm9keS0+YmFzaWNfcmF0ZV9zZXQgPQogCQljcHVfdG9fbGUzMih3Znhf
cmF0ZV9tYXNrX3RvX2h3KHd2aWYtPndkZXYsIGNvbmYtPmJhc2ljX3JhdGVzKSk7Ci0JaWYgKCFj
b25mLT5oaWRkZW5fc3NpZCkgewotCQlib2R5LT5zc2lkX2xlbmd0aCA9IGNvbmYtPnNzaWRfbGVu
OwotCQltZW1jcHkoYm9keS0+c3NpZCwgY29uZi0+c3NpZCwgY29uZi0+c3NpZF9sZW4pOwotCX0K
Kwlib2R5LT5zc2lkX2xlbmd0aCA9IGNvbmYtPnNzaWRfbGVuOworCW1lbWNweShib2R5LT5zc2lk
LCBjb25mLT5zc2lkLCBjb25mLT5zc2lkX2xlbik7CiAJd2Z4X2ZpbGxfaGVhZGVyKGhpZiwgd3Zp
Zi0+aWQsIEhJRl9SRVFfSURfU1RBUlQsIHNpemVvZigqYm9keSkpOwogCXJldCA9IHdmeF9jbWRf
c2VuZCh3dmlmLT53ZGV2LCBoaWYsIE5VTEwsIDAsIGZhbHNlKTsKIAlrZnJlZShoaWYpOwotLSAK
Mi4yNS4wCgo=
