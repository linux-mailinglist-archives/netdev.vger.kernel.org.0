Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9E113BF45
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730355AbgAOMMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:12:23 -0500
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:24056
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730223AbgAOMMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PtruGSfjv42AqzdAHASlKYiKq5AHSlYpnV8dQmvC/o9APZR0/GB6eZSzp5e+2AcdCZYZ4k1gMpUCqYxbBpk5HEMTsrlM+bh2x8mvRumxaaO7M0v6EjQfcmR9CUlekO2L+kgtAiiVynIY4/xBue4yNA7ejb4GhIiHGFH6U/Xg1w5tlKwPsuVSoPXpCTiSgc6YGGHw2qaRIPzj/DX/4VNZGBrM1eQWZ/93pexlRzY0dreQ53lFWUiCM14eXbJuS3n3yags26LecuRcJFZJm6ZtnT61Jb3dsaawB6+kYHz+KbevsNDgQjnUJtviPb4pXW2wmsqwZvGN9FLSsyvZ6hFNyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OEZlc4WIt+v7EkS55ULjmBTrlz1CZWTH8qKnG2sxQBQ=;
 b=AEMvSCS14cDC+8pXca6HaCMev4Km0uKECoKr1H4VZr8ARy4+DL1u39Dow4Y5kzsrNQDY3jk2vkrGbj2/I81XXNzdJ9j1I+r67WqDqdlp80aLGx0JF9otUFHRNLS4qhr2XGcyG8uGRXIV/kgyfMGtfB+tQnhp+9k4ZRi7/qvOcV1AQ/dPDXZx6polofhdrdhDTGwJaVZto16BdY8zn55dT7dx3nH+c21s9MrfpmEFhW/oTCIK1J58MBgPH2ay4q75OkOLxdpGUoEdhj4GbchgdvttnCeYbpW7DQKG5vpHrgnsgpFIiHmxXgoSdrH4MQsb61WIz2nGAGLu/ohCb1WYLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OEZlc4WIt+v7EkS55ULjmBTrlz1CZWTH8qKnG2sxQBQ=;
 b=Mabv1q/Nt/O/R+/1l96Uw/k+hOaR4Wq1wyx1wXeYlas78cgBjh1hIfIqYAVCFcd+kJms2ChgJrcX2i1KQMUgKvX4anSnweJFA/I/ezHGxq9m/kidk018gaZ1ei4ISUBnkXAYg0EpZ5maG1XdZBn3kWE3K/FWXXw9Ey3s5v3l7OI=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:12:11 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:11 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:09 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 02/65] staging: wfx: make hif_scan() usage clearer
Thread-Topic: [PATCH 02/65] staging: wfx: make hif_scan() usage clearer
Thread-Index: AQHVy50D4G/F8PmOR0KgBWJuNgXxng==
Date:   Wed, 15 Jan 2020 12:12:10 +0000
Message-ID: <20200115121041.10863-3-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: f9ae32e4-65ad-4071-7aa7-08d799b42612
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB39348B7CB7BFEDC30BEA339B93370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(6666004)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ayTQRX5yAfpSbj9rH3zsLcsIFMvnWvB7SOjtul/QYYR+9U21+q4HkXSaBZy/bgVPiVXEtqxu91gKbNoZ5rZMGDIBi3/EhSII5sFcr8Za9juLj5OfwxO1fyRcLvrbfKh3jxUAL0+Bnf0qsjRDLuYijkeptsIlBPZhSuWNYL5JtjtvfkYLI4wakIq0Y9eCeUeags7zoGvTYbx1n/neAFyy4BIlodeSodr5HIqAlQPU3CwP33ZRyedGwiblZWQuGGL/DsJBI8KtioDCHnXr7bWGTIA27jQ+pfb+b2Jla1btZi10Zcw3Vg43p+Fc1Je2izJZTiZmV50OZhvtUp7hDvz1kV1zwR08hBK3Z4791B0QtteTe17B1iXVawtM86wQKS8PYNwgQeCvm7pZKPbj9e9UopH1dIpxfYa6BKUWabVDz8V5E5e0VICjlqqvWc1AHoek
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D4424CE028897479C69643F6489D1E2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9ae32e4-65ad-4071-7aa7-08d799b42612
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:11.0211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ip8KT6ZaCCRbR6Voqa9FZ/W4JL9D1VbPdGkpkz3Q+BqDEUPhrcqYR8hmRoJclGLONoRsYeK+mFQ+7Wdhgk67lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKaGlm
X3NjYW4oKSByZXR1cm4gbWF4IG51bWJlciBvZiBqaWZmaWVzIHRvIHdhaXQgYmVmb3JlIHRoZSBj
b21wbGV0aW9uCmluZGljYXRpb24uIEhvd2V2ZXIsIGlmIHRoaXMgdmFsdWUgaXMgbmVnYXRpdmUs
IGFuIGVycm9yIGhhcyBvY2N1cnJlZC4KClJld29yZCB0aGUgY29kZSB0byByZWZsZWN0IHRoYXQg
YmVoYXZpb3IuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWls
bGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgfCA3ICsrKy0t
LS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3NjYW4uYwppbmRleCAyNDA2MWQwOWM0MDQuLjliMzY3NGIzMjI2YSAxMDA2NDQKLS0tIGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMK
QEAgLTU2LDEwICs1Niw5IEBAIHN0YXRpYyBpbnQgc2VuZF9zY2FuX3JlcShzdHJ1Y3Qgd2Z4X3Zp
ZiAqd3ZpZiwKIAl3ZnhfdHhfbG9ja19mbHVzaCh3dmlmLT53ZGV2KTsKIAl3dmlmLT5zY2FuX2Fi
b3J0ID0gZmFsc2U7CiAJcmVpbml0X2NvbXBsZXRpb24oJnd2aWYtPnNjYW5fY29tcGxldGUpOwot
CXJldCA9IGhpZl9zY2FuKHd2aWYsIHJlcSwgc3RhcnRfaWR4LCBpIC0gc3RhcnRfaWR4KTsKLQlp
ZiAocmV0IDwgMCkKLQkJcmV0dXJuIHJldDsKLQl0aW1lb3V0ID0gcmV0OworCXRpbWVvdXQgPSBo
aWZfc2Nhbih3dmlmLCByZXEsIHN0YXJ0X2lkeCwgaSAtIHN0YXJ0X2lkeCk7CisJaWYgKHRpbWVv
dXQgPCAwKQorCQlyZXR1cm4gdGltZW91dDsKIAlyZXQgPSB3YWl0X2Zvcl9jb21wbGV0aW9uX3Rp
bWVvdXQoJnd2aWYtPnNjYW5fY29tcGxldGUsIHRpbWVvdXQpOwogCWlmIChyZXEtPmNoYW5uZWxz
W3N0YXJ0X2lkeF0tPm1heF9wb3dlciAhPSB3dmlmLT53ZGV2LT5vdXRwdXRfcG93ZXIpCiAJCWhp
Zl9zZXRfb3V0cHV0X3Bvd2VyKHd2aWYsIHd2aWYtPndkZXYtPm91dHB1dF9wb3dlciAqIDEwKTsK
LS0gCjIuMjUuMAoK
