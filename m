Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C001113BFD5
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730898AbgAOMQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:16:56 -0500
Received: from mail-bn7nam10on2085.outbound.protection.outlook.com ([40.107.92.85]:6101
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731304AbgAOMNd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDyTyk9vLjtwuwpQx/+LwZr88OZM/k6SCZdAAbbwx1vYvMgV2bg2XupcmTO+83Zaef+qMDISNheviOkYwV+YFY67/oMcdBcl8kJffSeJ1uZ2NlfLrSrkymEc6wbVXYqEwtLhJDBt/z6zSwWPfqXUFZ1euf8ie6pay31nPx3sEFKD6SPJZK7PLHI21zkVSw/zecL20yOchU9ojoPiiskYGUCx0i5JgRHkjpL+/+6rugkX+ZueCGe0Xj9nY2oYOLVwcyFeHpot4OZXHlJFtnlQVNgR+SspgJ1gWEovn6avwcbF0V0OHAWHakv2qrH11vzIkDPn7/g04RrgbAmOTmah2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyYeovap0+RlWylFVGyolLwgpnfFNImokIBu+J3RC7k=;
 b=Bk/B59DBpUor6oocZpujrWBw2YWavj2rDBAs6aU62pcs3ceNQotl0Y6Y5W6ExATF4XIv9AxrnQQE909vLUB4/Tk6C+AuYQW5rP5n0OFzGLqWIr49A6y1dt9qHbzYo0xpcHyS1OOy9Ud4JHTb+KFeTxEafOsunImejx2AuoxByhDYPfTv48fg2Zt8IteEBMXfNNnvGCwZAcG51X7VqWtUdYP+jMoP9uBhgzL/LixxmiTlDCDnwkqlvUSYfEiuIbH63qZd8AYOxKNZ2j5RNIwN+GruIQuINeMcCgHWOyBnb5LHwvGKVisRobGLmguHfar7AgKzkuZTWLATem2rWtZtmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyYeovap0+RlWylFVGyolLwgpnfFNImokIBu+J3RC7k=;
 b=hWoeHkwdYAw84Bw+5zlJoIvxUJXLdR4q9ljd6fGwNb5zLfjnTP+EFTgT24f5whhAcFX/rCEA5MPGh1NtssAZNKYWIyBbFuuJ3hoCmuY58A5N5+Zfqsp0bYKiX1JInmwqSkFwf4uJhMkuHQd7S4tP6itZUdaUcsXAMFUy+43CRWo=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:13:26 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:26 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:01 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 40/65] staging: wfx: update power-save per interface
Thread-Topic: [PATCH 40/65] staging: wfx: update power-save per interface
Thread-Index: AQHVy50i9glpmyHt302vrCTD6a5IRw==
Date:   Wed, 15 Jan 2020 12:13:02 +0000
Message-ID: <20200115121041.10863-41-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: efa3bf8a-eace-4c16-2ee7-08d799b444ab
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB39343ED30C2AC372D7B35D5193370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003)(60793003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qdWwfoOnhVUL9FL1CxB2ekQ5KH+pCMHajdNIk287eptjvPegaqxlF2Z/oJu7QAXchj7XZBwqB/tGD5FSvhZfwaDS50tf9gs8c0Epvv2HEnnmeCM4SJSCJnUAimng5DTkv8nuHHI6LADRz2if4sTuGY46benDJKD9oUny8U8wkJCeRqCaoY0e5hHk6sr0lvVQVbDZW2Cpllcp6ZH9TL13ovptEeXRBNmSYicQYXAf0oqFagzQeIj1YTjpvIm800GqJ6+A3N2qsC5FePfaGR8B0iqRON/wABk3Lc3uoTcSNau10J9G1FjFaWEXdmjyukc80YWxPckOtHMROEBycIseD6KYsv840ulcoQMPBlrjsIqIU/KvYi68Tuz3TRY3df8QxReiMST+Oj0Kwhdpx7G4IWfVzxwsUfYGnFu0QrGxa8Q8YCC3zjib0C+MV7EEMluD4vwmVFDxXDwLPAxyvEG14pIAQJkyhqXb6WbHb9IAwYw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C799CD8486500429F58F7BABF31182D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efa3bf8a-eace-4c16-2ee7-08d799b444ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:02.3215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6MqGMlVk8U4dvW/+2A2FRQuQz+3B1pP47Ew3oYMPoA/l07hytr64/xNo1wcHnN1V8Z3gauiT7zturvt15kmn0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKbWFj
ODAyMTEgYW5kIHRoZSBkZXZpY2UgYXJlIGJvdGggYWJsZSB0byBjb250cm9sIHBvd2VyLXNhdmUg
cGVyIHZpZi4KQnV0LCB0aGUgY3VycmVudCBjb2RlIHJldHJpZXZlIHBvd2VyLXNhdmUgZnJvbSB3
ZnhfY29uZmlnKCkuIFNvLCBpdCBkb2VzCm5vdCBhbGxvdyB0byBzZXR1cCBwb3dlci1zYXZlIGlu
ZGVwZW5kZW50bHkgZm9yIGVhY2ggdmlmLiBEcml2ZXIganVzdApoYXMgdG8gcmVseSBvbiB3Znhf
YnNzX2luZm9fY2hhbmdlZCgpIGluc3RlYWQgb2Ygd2Z4X2NvbmZpZygpLgoKd2Z4X2NvbmZpZygp
IGhhcyBub3RoaW5nIHRvIGRvIGFueW1vcmUsIGJ1dCB3ZSBrZWVwIGl0IHNpbmNlIGl0IGlzCm1h
bmRhdG9yeSBmb3IgbWFjODAyMTEuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8
amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9tYWlu
LmMgfCAgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyAgfCAxNyArKysrKy0tLS0tLS0t
LS0tLQogMiBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDEzIGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9tYWluLmMKaW5kZXggMTkwNDg5MGMwM2ZlLi44NGFkYWQ2NGZjMzAgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFp
bi5jCkBAIC0xMzEsNyArMTMxLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfb3Bz
IHdmeF9vcHMgPSB7CiAJLnN0b3AJCQk9IHdmeF9zdG9wLAogCS5hZGRfaW50ZXJmYWNlCQk9IHdm
eF9hZGRfaW50ZXJmYWNlLAogCS5yZW1vdmVfaW50ZXJmYWNlCT0gd2Z4X3JlbW92ZV9pbnRlcmZh
Y2UsCi0JLmNvbmZpZwkJCT0gd2Z4X2NvbmZpZywKKwkuY29uZmlnICAgICAgICAgICAgICAgICA9
IHdmeF9jb25maWcsCiAJLnR4CQkJPSB3ZnhfdHgsCiAJLmNvbmZfdHgJCT0gd2Z4X2NvbmZfdHgs
CiAJLmh3X3NjYW4JCT0gd2Z4X2h3X3NjYW4sCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCAwYzMxNTBhOTRjN2Mu
Ljk0NjgzYTE0NDBjOCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC04MjYsNiArODI2LDEwIEBAIHZvaWQgd2Z4
X2Jzc19pbmZvX2NoYW5nZWQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsCiAKIAlpZiAoY2hhbmdl
ZCAmIEJTU19DSEFOR0VEX1RYUE9XRVIpCiAJCWhpZl9zZXRfb3V0cHV0X3Bvd2VyKHd2aWYsIGlu
Zm8tPnR4cG93ZXIpOworCisJaWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9QUykKKwkJd2Z4X3Vw
ZGF0ZV9wbSh3dmlmKTsKKwogCW11dGV4X3VubG9jaygmd2Rldi0+Y29uZl9tdXRleCk7CiAKIAlp
ZiAoZG9fam9pbikKQEAgLTEwNTgsMTggKzEwNjIsNyBAQCB2b2lkIHdmeF91bmFzc2lnbl92aWZf
Y2hhbmN0eChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAogaW50IHdmeF9jb25maWcoc3RydWN0
IGllZWU4MDIxMV9odyAqaHcsIHUzMiBjaGFuZ2VkKQogewotCWludCByZXQgPSAwOwotCXN0cnVj
dCB3ZnhfZGV2ICp3ZGV2ID0gaHctPnByaXY7Ci0Jc3RydWN0IHdmeF92aWYgKnd2aWY7Ci0KLQlp
ZiAoY2hhbmdlZCAmIElFRUU4MDIxMV9DT05GX0NIQU5HRV9QUykgewotCQltdXRleF9sb2NrKCZ3
ZGV2LT5jb25mX211dGV4KTsKLQkJd3ZpZiA9IE5VTEw7Ci0JCXdoaWxlICgod3ZpZiA9IHd2aWZf
aXRlcmF0ZSh3ZGV2LCB3dmlmKSkgIT0gTlVMTCkKLQkJCXJldCA9IHdmeF91cGRhdGVfcG0od3Zp
Zik7Ci0JCW11dGV4X3VubG9jaygmd2Rldi0+Y29uZl9tdXRleCk7Ci0JfQotCXJldHVybiByZXQ7
CisJcmV0dXJuIDA7CiB9CiAKIGludCB3ZnhfYWRkX2ludGVyZmFjZShzdHJ1Y3QgaWVlZTgwMjEx
X2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikKLS0gCjIuMjUuMAoK
