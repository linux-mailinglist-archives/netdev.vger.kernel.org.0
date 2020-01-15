Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD7F13BF4F
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730722AbgAOMMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:12:44 -0500
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:24056
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730407AbgAOMMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xw1T0HiQfGYPJ0UOUZHp46Yhq8QtNXvUNV+6tpTxgKIvG5XaOFs9v6cvrNBFVhX5/LTm26JRKeK3gbKxVMYU4Vh6rXpfkVRTKrzrlX8eo5OJyJ/yDwdY+UJ8sIIduvU4zypqptxtIv9s9/+IdNon3eFM1LD3XCAxOVo66qCIrVlA70aWZWadKz42QkAbwsXdAk06HuHcs0WsLB4Lqd1e7LV5MZv7TFZAcqgiaUlJ67fiZmJ6AaEIWOhaO7MNb27HY3C56syHaM0GammuRtfHeMwH9hpQXust8rEp9pxLXEZq79MSW1D0h0OZLD1N3Lth95Fgur4G4Xuv30+FuEUZPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JtJ2THuxCUky/HiJ4NGgOwKReUaawaehfR0nk8oPx4=;
 b=J3wxdf1RiHtVEV7wOzGjO0AW7bUf36rRjYj973jLAzqQUC74J45Qd5ozyeGOxVy9WjYHr1FzyuhmktToz70nVwnxbtRupMN5VHCjRxyxqVj628NMfvBvYSjOhF89h+Pfr8q+sqzJatps3B6xS5RwRlFwyujK7XsYAptM5ZV+b7VaMdS5bTLr8abqv7HnLMWrRtEar3jCopRQIVjHMExAunz99wob51/99TJhmNGffo+a/K9eVhCtwlN0EcEuPmtjHT7QNiegGyyH+n+yTtQHrL1qR9+KY6/yPe+kXQwawhIRqH59wJAkIpOKtQk/DUcYHYFKS97AURX/iWAkvOEuqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JtJ2THuxCUky/HiJ4NGgOwKReUaawaehfR0nk8oPx4=;
 b=OoQqwSqyzzcjcaj1gpOZ4Xam6oDjzDVSuRd0QqR7lNKTHkrv8UPQcl5+5Ua3wg6eQW+1uvjI72nTCpR7Gw2q80J6tVbYzmNsp3qCAmqAKqNvfNnPE/vq3fYt5hdB/q4mC8WlI//L91BI3abOBrdLUDodDi2lBKXDDPqQ3xx4Brk=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:12:30 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:30 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:29 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 16/65] staging: wfx: rename wfx_upload_beacon()
Thread-Topic: [PATCH 16/65] staging: wfx: rename wfx_upload_beacon()
Thread-Index: AQHVy50PpJG7UY/aIUKTSlWUlo6u3w==
Date:   Wed, 15 Jan 2020 12:12:30 +0000
Message-ID: <20200115121041.10863-17-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: d308cfb6-fb06-4a8f-822c-08d799b431cd
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934497DD24603A15C8CA00B93370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(6666004)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EsqIws3pe/dzwK9AEElHLSS+954zpeYXabz8fdWpm2aeG9iWftcQ9YqjKn2y7OkfwftNIZ7AbF4nGwJR/uH3vT7KC7p4qYRa9aDZaihC7cLJndS5Jo5pOGstj2oecjupmrQHMFl53UO+D6WPO5bgxhQFsRWKvyhLoz79ik4zHcab+z4RAGcYL6+Jcf9QhAINKiXmKuj+caK8oxyfmbB2r+SgdtGWfncPrVNU4z73G+ejCicUIEYxzxzrRUPigFIz3rQUnSU9NTvp9xPXXyDhIDO0kqXLiUK2pkdpM4p5VCq4JkQMbvfm8Vxg2OK+sACihcLw+KQlWWPCTR92ZUBc0sVX2tJpas7rhbAmHkpJGVH9OwheXLIdx9wKzZ3mLyIAOXattz0nkAyFPqioJ5J+ykqg35tN6AtguIdGwlVI8eFZGnB2bxatLRIUZl+EQ0q+
Content-Type: text/plain; charset="utf-8"
Content-ID: <7AB41A9B60CBFF43A7E2AFE1C4A0CAB7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d308cfb6-fb06-4a8f-822c-08d799b431cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:30.6748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CM7ejtR+vjnN+tT3VwpqDPRw2LsXewybbCvt1Qo6YUwE48CepMq+kIRtklomo5JRQrWhY0TaErqxDHXrAL5oug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
ZmFjdCwgd2Z4X3VwbG9hZF9iZWFjb24oKSB1cGxvYWRzIGJlYWNvbiBhbmQgcHJvYmUgcmVzcG9u
c2UuIFNvLApyZW5hbWUgaXQgaW4gd2Z4X3VwbG9hZF9hcF90ZW1wbGF0ZXMoKS4KClRoZSBjYWxs
IHRvIHdmeF9md2RfcHJvYmVfcmVxKCkgaGFzIG5vdGhpbmcgdG8gZG8gd2l0aCB0ZW1wbGF0ZQp1
cGxvYWRpbmcsIHNvIHJlbG9jYXRlIGl0LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxs
ZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMgfCA2ICsrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCA0NTFkMDEwOGExYjAuLmZkZGU3YWI5MjMwMiAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jCkBAIC03ODAsNyArNzgwLDcgQEAgc3RhdGljIGludCB3ZnhfdXBkYXRlX2JlYWNv
bmluZyhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAlyZXR1cm4gMDsKIH0KIAotc3RhdGljIGludCB3
ZnhfdXBsb2FkX2JlYWNvbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKK3N0YXRpYyBpbnQgd2Z4X3Vw
bG9hZF9hcF90ZW1wbGF0ZXMoc3RydWN0IHdmeF92aWYgKnd2aWYpCiB7CiAJc3RydWN0IHNrX2J1
ZmYgKnNrYjsKIAlzdHJ1Y3QgaWVlZTgwMjExX21nbXQgKm1nbXQ7CkBAIC04MDUsNyArODA1LDYg
QEAgc3RhdGljIGludCB3ZnhfdXBsb2FkX2JlYWNvbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAog
CWhpZl9zZXRfdGVtcGxhdGVfZnJhbWUod3ZpZiwgc2tiLCBISUZfVE1QTFRfUFJCUkVTLAogCQkJ
ICAgICAgIEFQSV9SQVRFX0lOREVYX0JfMU1CUFMpOwotCXdmeF9md2RfcHJvYmVfcmVxKHd2aWYs
IGZhbHNlKTsKIAlkZXZfa2ZyZWVfc2tiKHNrYik7CiAJcmV0dXJuIDA7CiB9CkBAIC05MDAsNyAr
ODk5LDggQEAgdm9pZCB3ZnhfYnNzX2luZm9fY2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpo
dywKIAkgICAgY2hhbmdlZCAmIEJTU19DSEFOR0VEX0lCU1MpIHsKIAkJd3ZpZi0+YmVhY29uX2lu
dCA9IGluZm8tPmJlYWNvbl9pbnQ7CiAJCXdmeF91cGRhdGVfYmVhY29uaW5nKHd2aWYpOwotCQl3
ZnhfdXBsb2FkX2JlYWNvbih3dmlmKTsKKwkJd2Z4X3VwbG9hZF9hcF90ZW1wbGF0ZXMod3ZpZik7
CisJCXdmeF9md2RfcHJvYmVfcmVxKHd2aWYsIGZhbHNlKTsKIAl9CiAKIAlpZiAoY2hhbmdlZCAm
IEJTU19DSEFOR0VEX0JFQUNPTl9FTkFCTEVEICYmCi0tIAoyLjI1LjAKCg==
