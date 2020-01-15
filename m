Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6641D13BF60
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731054AbgAOMNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:13:16 -0500
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:24056
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730816AbgAOMMt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hRsfeqAyFwXr/kOu+Erxv42FynlcnzK7oQMsd3f7h6cN1dhRDY/GgrmsKgdHDL+LEbTJ+cthwHknG+Q+lgz6+o8i+mTxr5LgftuW0p29LeKXd+IXmaKxQki4SVBWBXEjzIyGgO45bQ4ww9sbHO8+rvBvpIlGeaYbi+PRODQ9JlwkUiW48yhtFxaRXq6X7/DOiESilCARUjlNSoHjTn5hAS1I4vsoPeebH92bk/2wewYVLxqNmdLHlwsA4pN8rUE4jOoj0/edKb8o/euF7jF1RoeLOGyWcdRVGSF9Tai0pzUqtQP4dWrzggZpxxoj9BWwcbzCLC5JCgYx9M5VvY0CIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlidXQn8i1jas5J/LLCgvEICvbLWAL1DhgHsKcUtOo4=;
 b=QAbk+OajiAIWg2qlsAtBOOh9OGv3Y6O/W1ia3dA4seuZPyGG8j34LYbh448EBus19CIw1eEtRQT5i2EFS9HV5WaeXgAb+mUXNviYTY0AiP+kscF9sguDZ8mNT2bNBTeJGVdqUEOowDcbVH7hW4Q/929mxoF275jeqoJseG4zKRqfGkmwm6qCO4SqvXfhZ4AzWfK5B6F9yDJmEpAexQTY32qBTbf/dnZRsRlk4E8m6T8nsy9iMQah6JcRkfICCMCDHDEs4LIqRnxd0Ff/fyQ0Y+G5q0jiD//4HzAyj1vSX1AI9pG62RSJGBxAvPrLi8RprnCBRjrTGw4ABBPNECn55Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlidXQn8i1jas5J/LLCgvEICvbLWAL1DhgHsKcUtOo4=;
 b=Txa3x4fIvoFGa+DiIidxYvCObB4cDucp21jZDSaXOaP8RrrZBKqH9r3aWQKebpjVuNLlwM56HCousIZ44KTb93u5/Vt9SRcaHJ+xHWQckZIsT2nrUKKdJcMKKaG+6di45eg04x92eWN+jUp+sm4ngCfjQ+Nrq4RdRIq/D4IZgHU=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:12:37 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:37 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:36 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 21/65] staging: wfx: simplify update of DTIM period
Thread-Topic: [PATCH 21/65] staging: wfx: simplify update of DTIM period
Thread-Index: AQHVy50T30mp2MFZCEm6jRoRXY90lw==
Date:   Wed, 15 Jan 2020 12:12:37 +0000
Message-ID: <20200115121041.10863-22-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 81393438-d28c-4be2-840a-08d799b435bf
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934EF6B980ACEFAA97E475493370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003)(15650500001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i7f/c6Vtj3gAL5gwGmRKM+Lk/eypVya7Viq1rNoiQRzH3IiVZ/GcrNaLSMGMM1Bn7PWQiPHVXp03RLQBarSDFNwtCg/3vBMOMkmlieGVGOJKZmSDLoamuYrDeFZnW4bg7kqJPLdRHCoDgvLL7Ev8jBW5wnB8svGgdCGlGNW0N2a8yLKkODp7mXoGTJmoirmUDxb8UXrt6tKZ7vfXIqRfxwglN126U6NK3LoLT1woKwB00yFl5bCZ3dp8s3aqmePBo4sNvuCXFtCvROch3ZiL05aH8ijJjRuplhMIfAqRAl8an2Xs5woAYCatC2WSvS24z/eIV5N6Fo3k7JZZew7G3knO5tVq0LfooJ5wRl/47PUIeJIu08j2ySljPIWz6E5SUBXVb0I3moScEjJGSNuR4hySbNzG58LU5AL89MvbWWXJ6ajzMC2ISW5WxkRAxAHj
Content-Type: text/plain; charset="utf-8"
Content-ID: <CEC01AFFE7E905498AB0A775FEE05124@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81393438-d28c-4be2-840a-08d799b435bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:37.2820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eNuj48AimowsHTDEMv2fZG8qZ9eEO99jpqLEOaG3zTWg/IiQH/fZKTxbUTILfrzoOYg2vECGopXv63MDEzuyvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ3Vy
cmVudCBjb2RlIHBhcnNlIHRoZSBUSU0gYW5kIHJldHJpZXZlIHRoZSBEVElNIHBlcmlvZC4gSXQg
aXMgZmFyCmVhc2llciB0byByZWx5IG9uIGJzc19pbmZvX2NoYW5nZWQoKSBmb3IgdGhpcyBqb2Iu
CgpJdCBpcyBubyBtb3JlIG5lY2Vzc2FyeSB0byBydW4gdGFzayBhc3luY2hyb25vdXNseS4gU28K
c2V0X2JlYWNvbl93YWtldXBfcGVyaW9kX3dvcmsgaXMgbm93IHVzZWxlc3MuCgpTaWduZWQtb2Zm
LWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQog
ZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmMgfCAxNCAtLS0tLS0tLS0tLS0tLQogZHJpdmVy
cy9zdGFnaW5nL3dmeC9zdGEuYyAgICAgfCAxOSArKysrKystLS0tLS0tLS0tLS0tCiBkcml2ZXJz
L3N0YWdpbmcvd2Z4L3dmeC5oICAgICB8ICAyIC0tCiAzIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0
aW9ucygrKSwgMjkgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9kYXRhX3J4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfcnguYwppbmRleCBkNDYwYzBm
ZmNhMWYuLjBhYjcxYzkxMWY4NCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRh
X3J4LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmMKQEAgLTE3MywyMCArMTcz
LDYgQEAgdm9pZCB3ZnhfcnhfY2Ioc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJICAgICFhcmctPnN0
YXR1cyAmJiB3dmlmLT52aWYgJiYKIAkgICAgZXRoZXJfYWRkcl9lcXVhbChpZWVlODAyMTFfZ2V0
X1NBKGZyYW1lKSwKIAkJCSAgICAgd3ZpZi0+dmlmLT5ic3NfY29uZi5ic3NpZCkpIHsKLQkJY29u
c3QgdTggKnRpbV9pZTsKLQkJdTggKmllcyA9IG1nbXQtPnUuYmVhY29uLnZhcmlhYmxlOwotCQlz
aXplX3QgaWVzX2xlbiA9IHNrYi0+bGVuIC0gKGllcyAtIHNrYi0+ZGF0YSk7Ci0KLQkJdGltX2ll
ID0gY2ZnODAyMTFfZmluZF9pZShXTEFOX0VJRF9USU0sIGllcywgaWVzX2xlbik7Ci0JCWlmICh0
aW1faWUpIHsKLQkJCXN0cnVjdCBpZWVlODAyMTFfdGltX2llICp0aW0gPSAoc3RydWN0IGllZWU4
MDIxMV90aW1faWUgKikmdGltX2llWzJdOwotCi0JCQlpZiAod3ZpZi0+ZHRpbV9wZXJpb2QgIT0g
dGltLT5kdGltX3BlcmlvZCkgewotCQkJCXd2aWYtPmR0aW1fcGVyaW9kID0gdGltLT5kdGltX3Bl
cmlvZDsKLQkJCQlzY2hlZHVsZV93b3JrKCZ3dmlmLT5zZXRfYmVhY29uX3dha2V1cF9wZXJpb2Rf
d29yayk7Ci0JCQl9Ci0JCX0KLQogCQkvKiBEaXNhYmxlIGJlYWNvbiBmaWx0ZXIgb25jZSB3ZSdy
ZSBhc3NvY2lhdGVkLi4uICovCiAJCWlmICh3dmlmLT5kaXNhYmxlX2JlYWNvbl9maWx0ZXIgJiYK
IAkJICAgICh3dmlmLT52aWYtPmJzc19jb25mLmFzc29jIHx8CmRpZmYgLS1naXQgYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCBhZTAx
ZjdiZTBkZGIuLjFhZjk5Yjc5MzBmNCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9z
dGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC00NDYsMTUgKzQ0Niw2IEBA
IHN0YXRpYyB2b2lkIHdmeF9ic3NfcGFyYW1zX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3Jr
KQogCW11dGV4X3VubG9jaygmd3ZpZi0+d2Rldi0+Y29uZl9tdXRleCk7CiB9CiAKLXN0YXRpYyB2
b2lkIHdmeF9zZXRfYmVhY29uX3dha2V1cF9wZXJpb2Rfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3Qg
KndvcmspCi17Ci0Jc3RydWN0IHdmeF92aWYgKnd2aWYgPSBjb250YWluZXJfb2Yod29yaywgc3Ry
dWN0IHdmeF92aWYsCi0JCQkJCSAgICBzZXRfYmVhY29uX3dha2V1cF9wZXJpb2Rfd29yayk7Ci0K
LQloaWZfc2V0X2JlYWNvbl93YWtldXBfcGVyaW9kKHd2aWYsIHd2aWYtPmR0aW1fcGVyaW9kLAot
CQkJCSAgICAgd3ZpZi0+ZHRpbV9wZXJpb2QpOwotfQotCiBzdGF0aWMgdm9pZCB3ZnhfZG9fdW5q
b2luKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogewogCW11dGV4X2xvY2soJnd2aWYtPndkZXYtPmNv
bmZfbXV0ZXgpOwpAQCAtNDY2LDcgKzQ1Nyw2IEBAIHN0YXRpYyB2b2lkIHdmeF9kb191bmpvaW4o
c3RydWN0IHdmeF92aWYgKnd2aWYpCiAJCWdvdG8gZG9uZTsKIAogCWNhbmNlbF93b3JrX3N5bmMo
Jnd2aWYtPnVwZGF0ZV9maWx0ZXJpbmdfd29yayk7Ci0JY2FuY2VsX3dvcmtfc3luYygmd3ZpZi0+
c2V0X2JlYWNvbl93YWtldXBfcGVyaW9kX3dvcmspOwogCXd2aWYtPnN0YXRlID0gV0ZYX1NUQVRF
X1BBU1NJVkU7CiAKIAkvKiBVbmpvaW4gaXMgYSByZXNldC4gKi8KQEAgLTgyMyw3ICs4MTMsOCBA
QCBzdGF0aWMgdm9pZCB3Znhfam9pbl9maW5hbGl6ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAkJ
aGlmX2tlZXBfYWxpdmVfcGVyaW9kKHd2aWYsIDMwIC8qIHNlYyAqLyk7CiAJCWhpZl9zZXRfYnNz
X3BhcmFtcyh3dmlmLCAmd3ZpZi0+YnNzX3BhcmFtcyk7CiAJCXd2aWYtPnNldGJzc3BhcmFtc19k
b25lID0gdHJ1ZTsKLQkJd2Z4X3NldF9iZWFjb25fd2FrZXVwX3BlcmlvZF93b3JrKCZ3dmlmLT5z
ZXRfYmVhY29uX3dha2V1cF9wZXJpb2Rfd29yayk7CisJCWhpZl9zZXRfYmVhY29uX3dha2V1cF9w
ZXJpb2Qod3ZpZiwgaW5mby0+ZHRpbV9wZXJpb2QsCisJCQkJCSAgICAgaW5mby0+ZHRpbV9wZXJp
b2QpOwogCQl3ZnhfdXBkYXRlX3BtKHd2aWYpOwogCX0KIH0KQEAgLTg3Miw2ICs4NjMsMTAgQEAg
dm9pZCB3ZnhfYnNzX2luZm9fY2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAkJfQog
CX0KIAorCWlmIChjaGFuZ2VkICYgQlNTX0NIQU5HRURfQkVBQ09OX0lORk8pCisJCWhpZl9zZXRf
YmVhY29uX3dha2V1cF9wZXJpb2Qod3ZpZiwgaW5mby0+ZHRpbV9wZXJpb2QsCisJCQkJCSAgICAg
aW5mby0+ZHRpbV9wZXJpb2QpOworCiAJLyogYXNzb2MvZGlzYXNzb2MsIG9yIG1heWJlIEFJRCBj
aGFuZ2VkICovCiAJaWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9BU1NPQykgewogCQl3ZnhfdHhf
bG9ja19mbHVzaCh3ZGV2KTsKQEAgLTEyNjAsOCArMTI1NSw2IEBAIGludCB3ZnhfYWRkX2ludGVy
ZmFjZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikK
IAogCWluaXRfY29tcGxldGlvbigmd3ZpZi0+c2V0X3BtX21vZGVfY29tcGxldGUpOwogCWNvbXBs
ZXRlKCZ3dmlmLT5zZXRfcG1fbW9kZV9jb21wbGV0ZSk7Ci0JSU5JVF9XT1JLKCZ3dmlmLT5zZXRf
YmVhY29uX3dha2V1cF9wZXJpb2Rfd29yaywKLQkJICB3Znhfc2V0X2JlYWNvbl93YWtldXBfcGVy
aW9kX3dvcmspOwogCUlOSVRfV09SSygmd3ZpZi0+dXBkYXRlX2ZpbHRlcmluZ193b3JrLCB3Znhf
dXBkYXRlX2ZpbHRlcmluZ193b3JrKTsKIAlJTklUX1dPUksoJnd2aWYtPmJzc19wYXJhbXNfd29y
aywgd2Z4X2Jzc19wYXJhbXNfd29yayk7CiAJSU5JVF9XT1JLKCZ3dmlmLT5zZXRfY3RzX3dvcmss
IHdmeF9zZXRfY3RzX3dvcmspOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC93Zngu
aCBiL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKaW5kZXggMTU1ZGJlNTcwNGM5Li5kMjAxY2Nl
ZWMxYWIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKKysrIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC93ZnguaApAQCAtMTAxLDggKzEwMSw2IEBAIHN0cnVjdCB3ZnhfdmlmIHsK
IAlpbnQJCQlkdGltX3BlcmlvZDsKIAlpbnQJCQliZWFjb25faW50OwogCWJvb2wJCQllbmFibGVf
YmVhY29uOwotCXN0cnVjdCB3b3JrX3N0cnVjdAlzZXRfYmVhY29uX3dha2V1cF9wZXJpb2Rfd29y
azsKLQogCWJvb2wJCQlmaWx0ZXJfYnNzaWQ7CiAJYm9vbAkJCWZ3ZF9wcm9iZV9yZXE7CiAJYm9v
bAkJCWRpc2FibGVfYmVhY29uX2ZpbHRlcjsKLS0gCjIuMjUuMAoK
