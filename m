Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF82A13C4A0
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgAOOAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 09:00:41 -0500
Received: from mail-eopbgr770053.outbound.protection.outlook.com ([40.107.77.53]:11386
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726132AbgAONym (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRuhShjzGuV4l2skNR+vit9pEt7go7EwCaFvYLqI3PlFBDq3GuJ3IEj+SpdGJEPQ194m6OU77Ljaxz+8YBuIjSQxwotoFqj7S8rnWphpD7XY/o5VLlBogO2beNfxxbOPQm3RqOafpZlUv+7D/4OXzZM2ZO79cqv0Shus+Z4G3HU9VI5/JMacGAl4t4Q54z9JaMneTI9QZsAgG6Sa8TbypbvWx62323UNFAENLCCK32tU8pioATVR092hyw8KMEXIDyybr8Lmp5Mea5KTynpKgdHQHfvIWxZTkz13+9k42iWXSniKow26d7iFkcUGVF56WJRhqcIUOSJa3onq4E0UIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/9iTfaxfTcnYc8YPZNodlKI4v6m4/uHAT4ZHAmep34=;
 b=l8KnYRhHoEINtDxTxS4s4leilkKg+jQ+zQWAV3mEWnz41JI4dT+Q0KlVEEY4zWnb2NRdnjQ9HEiPEGJ+kYj74EIRVkerCqL11UrmTk+Pp2+9wzf49ZJM+X8NZ8oH6W3+dqCKk4boeIUiiVYRFShDoe6TBFMOMGG5VtyxIluzXSOOLG7T+chqIpJiyKL2jOUN1BSNNtghIFwIxBvn+bHJj4qZQPZJTs7fJmqF7dyjlJjJqww2C5uaZ4+D00+UTaJXkepzBrNLEkGWgoVnwQkv2c4J/AmtbegqmZVi2evTNkuceWv/jUjguhUN75zyYwpvFhcYedKC+etPxAfpEPaAwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/9iTfaxfTcnYc8YPZNodlKI4v6m4/uHAT4ZHAmep34=;
 b=jF7tDAKC0bsguqPsi919mlHTJeDIKcNsHIsqtlFmt/jh1GnQkNTd4Z1KWNEb2sEzkEeqlsF39PuQbGpyC0UugJG7beEcG+O1aeseXhhXw7v/9FTiWRjRPIp8lATtOs4wL0UAbjDaVUVl7/d3zstqfQvy2z//3H68YndRPjaEilI=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:54:40 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:40 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:38 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 26/65] staging: wfx: drop wfx_set_cts_work()
Thread-Topic: [PATCH v2 26/65] staging: wfx: drop wfx_set_cts_work()
Thread-Index: AQHVy6tUTg5IqBvFKESYPQtt70E1yQ==
Date:   Wed, 15 Jan 2020 13:54:40 +0000
Message-ID: <20200115135338.14374-27-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 46639f6a-b058-4946-ca81-08d799c27751
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB366120B09C5DDFA599B555A393370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(6666004)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RoURsDxRWARwqckaOOGyb6mCESuYkopmKNhWGghRwGbMRtxqSDwWOokR28UNAaLxLTJkL2nQ9BxQK091S3KMxXRCNQU5H0cPi0w6WW63FTlUW0CzYpd1SePUsrCVJiWVmGSi3YnB6muUeP31wbMZmtaY7b6oHnaP8neVpxKpTk+3jRIIwdmk+HopJaMrnwx08oXTUPvfwT02lk/8/hFD7/GxHEdXUviydvg+F8SWWhJpDfcHN5RSLymiQzTna10qXVDmpbZ54UlKON6gABe2hF6wHJymVS3CMBzfXMyNYlL0NuHyoovJ1RujIca+5Vm/Jb2bqkKzie6e0S2hW+ZweMh3twWHvuapfJh3OhV/lfLHQ8DeimIDvDhsEtGR5LvqVoDqZIig4ab0OGpLgc/O5YJ7rGsw7NWXKW+9yCGzHlk2/Jzmszu/Ao4yl4D5CE59
Content-Type: text/plain; charset="utf-8"
Content-ID: <475A454766500A4897CF2E02F0327F8B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46639f6a-b058-4946-ca81-08d799c27751
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:40.2507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9m+jBKcitpKGITBAl26qKk08MSoVTfpvw2ytoijqdlYUAo4BGstcFK0murrIIw3vb0cxfJNteZwF5sCMphdcgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X2Jzc19pbmZvX2NoYW5nZWQoKSBpcyBub3QgY2FsbGVkIGZyb20gYXRvbWljIGNvbnRleHRzLiBT
bywgaXQgaXMgbm90Cm5lY2Vzc2FyeSB0byByYWlzZSBhbiBhc3luY2hyb25vdXMgd29yayB0byBj
aGFuZ2UgRVJQLiBUaHVzCndmeF9zZXRfY3RzX3dvcmsoKSBiZWNvbWUgdXNlbGVzcy4KClNpZ25l
ZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4K
LS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIHwgNDAgKysrKysrKysrLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oIHwgIDIgLS0KIDIg
ZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAzMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEu
YwppbmRleCA3YWJlMjcyZGRjMGQuLmUwMmViYzM5ZWQ0MSAxMDA2NDQKLS0tIGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC02NzEs
MjQgKzY3MSw2IEBAIGludCB3Znhfc3RhX3JlbW92ZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywg
c3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAlyZXR1cm4gMDsKIH0KIAotc3RhdGljIHZvaWQg
d2Z4X3NldF9jdHNfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCi17Ci0Jc3RydWN0IHdm
eF92aWYgKnd2aWYgPSBjb250YWluZXJfb2Yod29yaywgc3RydWN0IHdmeF92aWYsIHNldF9jdHNf
d29yayk7Ci0JdTggZXJwX2llWzNdID0geyBXTEFOX0VJRF9FUlBfSU5GTywgMSwgMCB9OwotCXN0
cnVjdCBoaWZfaWVfZmxhZ3MgdGFyZ2V0X2ZyYW1lID0gewotCQkuYmVhY29uID0gMSwKLQl9Owot
Ci0JbXV0ZXhfbG9jaygmd3ZpZi0+d2Rldi0+Y29uZl9tdXRleCk7Ci0JZXJwX2llWzJdID0gd3Zp
Zi0+ZXJwX2luZm87Ci0JbXV0ZXhfdW5sb2NrKCZ3dmlmLT53ZGV2LT5jb25mX211dGV4KTsKLQot
CWhpZl9lcnBfdXNlX3Byb3RlY3Rpb24od3ZpZiwgZXJwX2llWzJdICYgV0xBTl9FUlBfVVNFX1BS
T1RFQ1RJT04pOwotCi0JaWYgKHd2aWYtPnZpZi0+dHlwZSAhPSBOTDgwMjExX0lGVFlQRV9TVEFU
SU9OKQotCQloaWZfdXBkYXRlX2llKHd2aWYsICZ0YXJnZXRfZnJhbWUsIGVycF9pZSwgc2l6ZW9m
KGVycF9pZSkpOwotfQotCiBzdGF0aWMgaW50IHdmeF9zdGFydF9hcChzdHJ1Y3Qgd2Z4X3ZpZiAq
d3ZpZikKIHsKIAlpbnQgcmV0OwpAQCAtODk2LDI0ICs4NzgsMjEgQEAgdm9pZCB3ZnhfYnNzX2lu
Zm9fY2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAkJfQogCX0KIAotCS8qIEVSUCBQ
cm90ZWN0aW9uICovCiAJaWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9BU1NPQyB8fAogCSAgICBj
aGFuZ2VkICYgQlNTX0NIQU5HRURfRVJQX0NUU19QUk9UIHx8CiAJICAgIGNoYW5nZWQgJiBCU1Nf
Q0hBTkdFRF9FUlBfUFJFQU1CTEUpIHsKLQkJdTMyIHByZXZfZXJwX2luZm8gPSB3dmlmLT5lcnBf
aW5mbzsKKwkJc3RydWN0IGhpZl9pZV9mbGFncyB0YXJnZXRfZnJhbWUgPSB7CisJCQkuYmVhY29u
ID0gMSwKKwkJfTsKKwkJdTggZXJwX2llWzNdID0geyBXTEFOX0VJRF9FUlBfSU5GTywgMSwgMCB9
OwogCisJCWhpZl9lcnBfdXNlX3Byb3RlY3Rpb24od3ZpZiwgaW5mby0+dXNlX2N0c19wcm90KTsK
IAkJaWYgKGluZm8tPnVzZV9jdHNfcHJvdCkKLQkJCXd2aWYtPmVycF9pbmZvIHw9IFdMQU5fRVJQ
X1VTRV9QUk9URUNUSU9OOwotCQllbHNlIGlmICghKHByZXZfZXJwX2luZm8gJiBXTEFOX0VSUF9O
T05fRVJQX1BSRVNFTlQpKQotCQkJd3ZpZi0+ZXJwX2luZm8gJj0gfldMQU5fRVJQX1VTRV9QUk9U
RUNUSU9OOwotCisJCQllcnBfaWVbMl0gfD0gV0xBTl9FUlBfVVNFX1BST1RFQ1RJT047CiAJCWlm
IChpbmZvLT51c2Vfc2hvcnRfcHJlYW1ibGUpCi0JCQl3dmlmLT5lcnBfaW5mbyB8PSBXTEFOX0VS
UF9CQVJLRVJfUFJFQU1CTEU7Ci0JCWVsc2UKLQkJCXd2aWYtPmVycF9pbmZvICY9IH5XTEFOX0VS
UF9CQVJLRVJfUFJFQU1CTEU7Ci0KLQkJaWYgKHByZXZfZXJwX2luZm8gIT0gd3ZpZi0+ZXJwX2lu
Zm8pCi0JCQlzY2hlZHVsZV93b3JrKCZ3dmlmLT5zZXRfY3RzX3dvcmspOworCQkJZXJwX2llWzJd
IHw9IFdMQU5fRVJQX0JBUktFUl9QUkVBTUJMRTsKKwkJaWYgKHd2aWYtPnZpZi0+dHlwZSAhPSBO
TDgwMjExX0lGVFlQRV9TVEFUSU9OKQorCQkJaGlmX3VwZGF0ZV9pZSh3dmlmLCAmdGFyZ2V0X2Zy
YW1lLCBlcnBfaWUsIHNpemVvZihlcnBfaWUpKTsKIAl9CiAKIAlpZiAoY2hhbmdlZCAmIEJTU19D
SEFOR0VEX0FTU09DIHx8IGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9FUlBfU0xPVCkKQEAgLTEyMzcs
NyArMTIxNiw2IEBAIGludCB3ZnhfYWRkX2ludGVyZmFjZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpo
dywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikKIAljb21wbGV0ZSgmd3ZpZi0+c2V0X3BtX21v
ZGVfY29tcGxldGUpOwogCUlOSVRfV09SSygmd3ZpZi0+dXBkYXRlX2ZpbHRlcmluZ193b3JrLCB3
ZnhfdXBkYXRlX2ZpbHRlcmluZ193b3JrKTsKIAlJTklUX1dPUksoJnd2aWYtPmJzc19wYXJhbXNf
d29yaywgd2Z4X2Jzc19wYXJhbXNfd29yayk7Ci0JSU5JVF9XT1JLKCZ3dmlmLT5zZXRfY3RzX3dv
cmssIHdmeF9zZXRfY3RzX3dvcmspOwogCUlOSVRfV09SSygmd3ZpZi0+dW5qb2luX3dvcmssIHdm
eF91bmpvaW5fd29yayk7CiAJSU5JVF9XT1JLKCZ3dmlmLT50eF9wb2xpY3lfdXBsb2FkX3dvcmss
IHdmeF90eF9wb2xpY3lfdXBsb2FkX3dvcmspOwogCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3dmeC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaAppbmRleCA1ZTFhNzYzZWI0
YjUuLmY1NmE5MWVhMDgyZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaAor
KysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCkBAIC0xMDQsMTIgKzEwNCwxMCBAQCBzdHJ1
Y3Qgd2Z4X3ZpZiB7CiAJYm9vbAkJCWRpc2FibGVfYmVhY29uX2ZpbHRlcjsKIAlzdHJ1Y3Qgd29y
a19zdHJ1Y3QJdXBkYXRlX2ZpbHRlcmluZ193b3JrOwogCi0JdTMyCQkJZXJwX2luZm87CiAJdW5z
aWduZWQgbG9uZwkJdWFwc2RfbWFzazsKIAlzdHJ1Y3QgaWVlZTgwMjExX3R4X3F1ZXVlX3BhcmFt
cyBlZGNhX3BhcmFtc1tJRUVFODAyMTFfTlVNX0FDU107CiAJc3RydWN0IGhpZl9yZXFfc2V0X2Jz
c19wYXJhbXMgYnNzX3BhcmFtczsKIAlzdHJ1Y3Qgd29ya19zdHJ1Y3QJYnNzX3BhcmFtc193b3Jr
OwotCXN0cnVjdCB3b3JrX3N0cnVjdAlzZXRfY3RzX3dvcms7CiAKIAlpbnQJCQlqb2luX2NvbXBs
ZXRlX3N0YXR1czsKIAlzdHJ1Y3Qgd29ya19zdHJ1Y3QJdW5qb2luX3dvcms7Ci0tIAoyLjI1LjAK
Cg==
