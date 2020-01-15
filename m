Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F34F613C468
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgAONzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:55:32 -0500
Received: from mail-eopbgr770071.outbound.protection.outlook.com ([40.107.77.71]:65358
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729904AbgAONza (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C38VzlOKhFNd8jyt8iw7NuhAJRQSjqH38MIVMw43ASGyvCJyLle9oQXkOyqQhbQ/Y6DO/PlFd206r7ID02nhzo7f1n3px1lMLUXqhVTR89LUsj4fOvEDYdEaiCxTVBuL1Rxz1zT/Yl0LINwJSmiqYeoNSd9ddts9sxN2I+QoT7R8Nj4wG6rRkmVnnWj6CVMw6cjHEFbhdDIbyg9o1z3wCk5GyBwLskGQdZX0c0sSyaYKhE8KZ8Hsa/7bcbtL9gGz1tczZsxZHFyFyo9WwbKT0o9vvd/08lpQD3ElWWFuZeU9xpzG6kiSA087puA7LnODvIbNRCEkPWoL46I0IPMOfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyYeovap0+RlWylFVGyolLwgpnfFNImokIBu+J3RC7k=;
 b=fnMiOWDYMveP/Q5wqz+MWW8QHo+4PX7rSKuac5B27poKhXuHQB0vAxkNP+JAaZzQj52Ddaf7qN0m1YjNdzey8dsdFI2J0MTemV3T822skvSA9wcseIRu2I/7b2IlyWbbymVT1k9MmI2LAvZ02RQieIFsc4WDMzWBRrW7yeRDV48uOJgV7qaJzJzMqBiahP0ZoZeyebQHEEwdMNeahsE3a1cc9GE1m51vcKVhz4rO9JuiJNJn3rtsOEmLE4lg16E5QJgO/pkwxypYzg3klWrKsqqeubRfNYTEn4tV8tpV+cS3+Gdhc1ZumP9GX6/PgCMvSbmo7ET3XVALcl+vfr0tHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyYeovap0+RlWylFVGyolLwgpnfFNImokIBu+J3RC7k=;
 b=n5iKOJDHmz8LazOlDjn537B/0YatT1VdwS732/lB0DYHiV3ixT163Eqy08VuJzFzXFzjIf2VMcveigI25kTPq3De1CG8q6mOKN11lulJlt/eZTwGinEcZhNMAp6XCtaEZZYhghyKv4qTn8y6NbE6P1A27/UyoYGQZsWMTLH41w8=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:55:21 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:21 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:59 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 40/65] staging: wfx: update power-save per interface
Thread-Topic: [PATCH v2 40/65] staging: wfx: update power-save per interface
Thread-Index: AQHVy6th6CaT+imqO0iWc63tAvCjAQ==
Date:   Wed, 15 Jan 2020 13:55:01 +0000
Message-ID: <20200115135338.14374-41-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 78287c4a-df6f-4556-4d73-08d799c283b9
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB36613BABF3C2F4470208F72993370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(6666004)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002)(60793003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MclBadxvLEATDKFruzYpNMqqRCawH4vsm5At8gFt+9RNaA3zOwOa1a3w8cs7jBYDHOj1dQVcv2rmOVVEaB1l4mlNjvYJsOM7H5kRROMnUfWVr0cB4Dy0t+XGyQnYCHk5g6rF9/DK+X6vTVGeKtrOg51pSnsinJGQkhMDwqN32NdPC+zPyUilvp4KfuaB+7m8EBG2QbpbIoARxXwlbGNHNer9vWNIEWetfG1YQRuOPtSWyI/trsvtjLLoYYddmzqAp3jSJQ3/CbcaqqQwfQnBjV2gqi9Wt3cn9GUOfMbYQ+oMP1zsSFkrFGBJ+ediXkNkVod7KV8B6+QTeYfx+RLRq9H4RtYv315gh2NFAv7dkSzEgQw6dWfX4LO/fdp//K4cIX8VGO9TcqLkNt0U1Fj9JCuzPzrIP48o7R3lIstqDwglas7+you1n3n6TpF8k0QSpnFPHLMsYObYGQdXsqe4rBmMY3+iAmOmgElY3e9lZSQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1167DF9AE01DA5469E64705091BB8E84@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78287c4a-df6f-4556-4d73-08d799c283b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:55:01.0587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dr9WBh12L3G2QDK415wBHEYvZD+kdlOsK5z3+OS0VWC3b8M5JlNRWURym/YnnTWMsKR+cdv9IYBgzqle6nwKEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
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
