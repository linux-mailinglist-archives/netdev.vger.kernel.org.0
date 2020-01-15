Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9183613C083
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731004AbgAOMTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:19:19 -0500
Received: from mail-bn7nam10on2050.outbound.protection.outlook.com ([40.107.92.50]:24527
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730333AbgAOMMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXbKK+SLJIeEGPMneT37MTlMQbRvWs219TwJoGUqleLzRc8avhoqkKnSp1lwXtDgaAH95YCnnS5ek1P1qxXIC8oUz4BQtxNiT6ThQTjoYAKQjn/HaDS0oJKiOwgumD0SQJF1/TrtjCbD7zFUnYy0DwRmCVjKrECEPBotoS7W92u3IlsPn/Wh3NNweT/6kR3jtFjP73oiMwS/WqPlQYO16CAkiB3j1hTM8PTl3GaO8JpNL99bTeec5ORnmJPfoJ4RDB0tr2DeltLGU+xVvAImGIKURqvZVSFflOPzLxepJwwr60O77QEbnzLEGZEypB9LB5cTn2yP3ahljS9pWoi3uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXjwnQ3yvU8lyBSO2Sod3uaseaRMamnlynrVm+tTnXQ=;
 b=eo55ObKd7EBMnYy5EJcQVbo89noUAlJiWomVGMhlrD+7oEGrAzuvZKJqzY9Tel/jEjITmUn3tv2d+GeMBJr5mud3KkzFzX9lmLn1RmFAPG2FeTQ+jmWGtR6onzEXH3pHB/iuY7QExWGCo9RMyA9wRjhOG9cZeyHUnoU1w6jVjb23nNL85W30EfpTb6NLfo2KFvLnPOwu7dUiK3Bb0kAW6TSYciBUfumxO2b1fWrh4e0iN5rhavWCFtiunf3lCpaSOw4vyR1U5jj25axZZUAEQUKHIxibSlq54aw6R0dEHa6zZ+3r9on21luGafa85ByOHnCmY6xRg8/rEcLCTp7asQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXjwnQ3yvU8lyBSO2Sod3uaseaRMamnlynrVm+tTnXQ=;
 b=ESGgX2RjWwzekhAetFpuTsq99f4bS7qrqcBRsjbtsFn8RbL51+8d9J4Relw12Bmdf20F5bDlREM1CPuSNVl+8MMrxeazQ9ZKe9JCkFwsP/m3dsiezSvvwl4de4oYBxZScuMFgObDPAuaPLr3OnnCPDyU3PnieJH0If8lEAtMd18=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:12:24 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:24 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:23 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 12/65] staging: wfx: retrieve greenfield mode from sta->ht_cap
 and bss_conf
Thread-Topic: [PATCH 12/65] staging: wfx: retrieve greenfield mode from
 sta->ht_cap and bss_conf
Thread-Index: AQHVy50LTsPXvOgDXUODFi8ErFW3kw==
Date:   Wed, 15 Jan 2020 12:12:24 +0000
Message-ID: <20200115121041.10863-13-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 2a608148-22f8-4b2c-a044-08d799b42e3e
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4096D53517E6ED66E3D846CF93370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:341;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H6O127am20eMXytAkEyhlTQvlQ7c9Mn8rIFEg8Q8EIwTEMwKw/1ruMHEeODggYOUlrYwAqJ0W9jvfJeKdeuYV3AFYWihX1i2BDgKEwXBBRraL3ULxPxFiN8cJzGHrfRSR0pMYXIQ3ia4cv6olwIAKQHKSAEi4KBWT4GmFHfFyTEHetYjBayt2hkg8IwHtn0SgcDcyH0uLpJUEqXaChlVbdrLSFhNQKgNMEGXJVjnFVEOuIGkRyDGqJaIr3HBdY/DRgovjBo29pMP2ePM2DYsmmRfYneThF366Di8WaCYJOFOqJrzNcdX+JgMrwwc06+attQn6o+pOff/nG9TCWf4mLclYizoulbK+fhvLXsMs2Mchaim3QbhHBOrWmoVMjWI6OYkfTajejPZr0eXYLB7Rc+oQiQLGpjOeUoBToSDkhY+hrO3JqRrx3vJiR3oX1wn
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0E841B2DE3EBB47AEC5EE3252BD40B6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a608148-22f8-4b2c-a044-08d799b42e3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:24.7012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1L/cqEYuU+TOp5KfdHPL85ikjpasdRTWOYbE1ZYePU55HfTYHAf3AlMzJcA9NbnrGDBgmhe0hXSshxpC1ZPwGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd3Zp
Zi0+aHRfaW5mbyBjb250YWlucyB1c2VsZXNzIGNvcGllcyBvZiBzdGEtPmh0X2NhcCBhbmQKYnNz
X2NvbmYtPmh0X29wZXJhdGlvbl9tb2RlLiBQcmVmZXIgdG8gcmV0cmlldmUgaW5mb3JtYXRpb24g
ZnJvbSB0aGUKb3JpZ2luYWwgc3RydWN0cyBpbnN0ZWFkIG9mIHJlbHkgb24gd3ZpZi0+aHRfaW5m
by4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2ls
YWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIHwgMTggKysrKysrLS0tLS0t
LS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9zdGEuYwppbmRleCBmMTNhNWI0MTczNWMuLmZjZDlmZTY2ZTQxNyAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
CkBAIC04MTcsMTQgKzgxNyw2IEBAIHN0YXRpYyBpbnQgd2Z4X2lzX2h0KGNvbnN0IHN0cnVjdCB3
ZnhfaHRfaW5mbyAqaHRfaW5mbykKIAlyZXR1cm4gaHRfaW5mby0+Y2hhbm5lbF90eXBlICE9IE5M
ODAyMTFfQ0hBTl9OT19IVDsKIH0KIAotc3RhdGljIGludCB3ZnhfaHRfZ3JlZW5maWVsZChjb25z
dCBzdHJ1Y3Qgd2Z4X2h0X2luZm8gKmh0X2luZm8pCi17Ci0JcmV0dXJuIHdmeF9pc19odChodF9p
bmZvKSAmJgotCQkoaHRfaW5mby0+aHRfY2FwLmNhcCAmIElFRUU4MDIxMV9IVF9DQVBfR1JOX0ZM
RCkgJiYKLQkJIShodF9pbmZvLT5vcGVyYXRpb25fbW9kZSAmCi0JCSAgSUVFRTgwMjExX0hUX09Q
X01PREVfTk9OX0dGX1NUQV9QUlNOVCk7Ci19Ci0KIHN0YXRpYyB2b2lkIHdmeF9qb2luX2ZpbmFs
aXplKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCQkJICAgICAgc3RydWN0IGllZWU4MDIxMV9ic3Nf
Y29uZiAqaW5mbykKIHsKQEAgLTg0OSw5ICs4NDEsOCBAQCBzdGF0aWMgdm9pZCB3Znhfam9pbl9m
aW5hbGl6ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAl9CiAJcmN1X3JlYWRfdW5sb2NrKCk7CiAK
LQkvKiBOb24gR3JlZW5maWVsZCBzdGF0aW9ucyBwcmVzZW50ICovCi0JaWYgKHd2aWYtPmh0X2lu
Zm8ub3BlcmF0aW9uX21vZGUgJgotCSAgICBJRUVFODAyMTFfSFRfT1BfTU9ERV9OT05fR0ZfU1RB
X1BSU05UKQorCWlmIChzdGEgJiYKKwkgICAgaW5mby0+aHRfb3BlcmF0aW9uX21vZGUgJiBJRUVF
ODAyMTFfSFRfT1BfTU9ERV9OT05fR0ZfU1RBX1BSU05UKQogCQloaWZfZHVhbF9jdHNfcHJvdGVj
dGlvbih3dmlmLCB0cnVlKTsKIAllbHNlCiAJCWhpZl9kdWFsX2N0c19wcm90ZWN0aW9uKHd2aWYs
IGZhbHNlKTsKQEAgLTg2Miw3ICs4NTMsMTAgQEAgc3RhdGljIHZvaWQgd2Z4X2pvaW5fZmluYWxp
emUoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJYXNzb2NpYXRpb25fbW9kZS5zcGFjaW5nID0gMTsK
IAlhc3NvY2lhdGlvbl9tb2RlLnNob3J0X3ByZWFtYmxlID0gaW5mby0+dXNlX3Nob3J0X3ByZWFt
YmxlOwogCWFzc29jaWF0aW9uX21vZGUuYmFzaWNfcmF0ZV9zZXQgPSBjcHVfdG9fbGUzMih3Znhf
cmF0ZV9tYXNrX3RvX2h3KHd2aWYtPndkZXYsIGluZm8tPmJhc2ljX3JhdGVzKSk7Ci0JYXNzb2Np
YXRpb25fbW9kZS5ncmVlbmZpZWxkID0gd2Z4X2h0X2dyZWVuZmllbGQoJnd2aWYtPmh0X2luZm8p
OworCWlmIChzdGEgJiYgc3RhLT5odF9jYXAuaHRfc3VwcG9ydGVkICYmCisJICAgICEoaW5mby0+
aHRfb3BlcmF0aW9uX21vZGUgJiBJRUVFODAyMTFfSFRfT1BfTU9ERV9OT05fR0ZfU1RBX1BSU05U
KSkKKwkJYXNzb2NpYXRpb25fbW9kZS5ncmVlbmZpZWxkID0KKwkJCSEhKHN0YS0+aHRfY2FwLmNh
cCAmIElFRUU4MDIxMV9IVF9DQVBfR1JOX0ZMRCk7CiAJaWYgKHN0YSAmJiBzdGEtPmh0X2NhcC5o
dF9zdXBwb3J0ZWQpCiAJCWFzc29jaWF0aW9uX21vZGUubXBkdV9zdGFydF9zcGFjaW5nID0gc3Rh
LT5odF9jYXAuYW1wZHVfZGVuc2l0eTsKIAotLSAKMi4yNS4wCgo=
