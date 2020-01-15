Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2323113C3DB
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729669AbgAONzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:55:10 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:14113
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729454AbgAONyx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWaU8t6ajWs6DoLDgPKMzUmezM9wEJQEpDgNs9bFFnygh8HllDXi9mEPIgCmqmznULVgPXuZUiom9R3dqlWqR7CKzvzNCY9hC4lJMZ04VznTH9v802nAiPNj6VvfMIYW+KeM4DR8cEWogKVg4xSD5Owd5jD9fZWTlvzhnCYaW0nJJ9eHUN7I085v8Qm+eT40V0aNzje6mYf8mqUxTwjSzHZkF93IoO6bTaiFbzC9WXN9UkvLkpH+AQE2uTUrH1ajGhraM1c1M810AM4btCuNS/uFRavKpV88DnSQwBrmlb1Rl1Nsiw4t4MZWNbWOzU6gJfRUTCtCjLFRg92xMHB1uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyDWq4MM5XzguJy/1tVdbLRwVPRpywmE0qbRXL02dkc=;
 b=ARtnkVKBfuwuTwPHQOVCoyJoSnyxjlx2uXhSbINhaVqPlfXnjaaeteqYqsv6fqMa/PIcq2qjp1roTBv2XJruqw+78BwZgpE7MAxN3/sD0SmtlPlRccf+WLGWDZB51oAh9r/RRP/DytzxcS1d9nU0x7rsxSU/4c4VLk2K96Htb45hjGy0xXnWiSPWQ0RLuQgT2rUtvjr6VJZQSZ2OBnyeArVYI2hiQtBvxq+hlZHecVqIusQAVHBPr62O1mySEIxIzRKER5YtdmSQg+R2EEmVtHh2dENSR/9q/JnrRzRVD+1MDvPzQGe6iIrAcndVgisYneERHTiH6I0OVmyUeFqpIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyDWq4MM5XzguJy/1tVdbLRwVPRpywmE0qbRXL02dkc=;
 b=GJ5MUSC9XkoC6+gI/NvMS4PfwelfsOa/HdHyVhLWgk26YMO4IuqidiR31r+aTCJoNIUmtphYh7e71DkmLI2XJ7Rdj+LdbPASr7G2yNSDU/4WNdAcJ9VQeO9Mpx7eMND6Ew5L65q51OVQgNESJd3zZOGNyVR1admencJna/HevC8=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:54:35 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:35 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:34 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 23/65] staging: wfx: drop wvif->enable_beacon
Thread-Topic: [PATCH v2 23/65] staging: wfx: drop wvif->enable_beacon
Thread-Index: AQHVy6tSdqNtMI+VWU2E6BePxFJK9A==
Date:   Wed, 15 Jan 2020 13:54:35 +0000
Message-ID: <20200115135338.14374-24-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 763448bf-6b70-4469-52a0-08d799c27499
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4094C2860800A8FC18EFDEE493370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: utl1x1BmQnzaef8E0Ds10B8azPilKyaT5DMenu3djZzRiGoy9LStCEhmx6McYVIRfsn4lsHnXDVsSlWzd+AeI4pyUwnnec25lzg0Co52yOhES29w/5ScRgVuWhH3YNorIcgOypomW1H1owT9ro9HsE5NIZZQUgRvHYAOpnSmhnni5lWmUjW3YHsg3V3uWIHApifCMwy2gSahUek9737L0vuCDD/PxVDI3QWXdbPJh7qUBTl7TryQIpvjqcqUE/AQNRdE7tav5tyUCmqXJw7otcyb25qI5A9UsYQwiqJ46qIYX9CMSDjNrTEYX0ML8bvm3ln7FJwa888fHeIUZZ3BMuICJyJqi9wJfcBvlbH3JP07lydMFtH+WFjP1k3Tc0f/mSRQq4ONo5/cEdOcrfgKtcq8sN2SFAnUK66ofC+plFw4BH8puHqmBUVyoGprQ0B7
Content-Type: text/plain; charset="utf-8"
Content-ID: <40970C195AAC7448A6EFB445B3DE8B5D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 763448bf-6b70-4469-52a0-08d799c27499
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:35.7193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m/wA9fbplffK1Nf5gVsiEuuA4QeuIix/F0RRd24uClF/J8CNC+Gad2aOkgegZURTm158eH+eVKUvDKdTaojKpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
c2VlbXMgdGhhdCBjdXJyZW50IGNvZGUgdHJ5IHRvIHNhdmUgY2FsbHMgdG8gaGlmX2JlYWNvbl90
cmFuc21pdCgpIGJ5CmtlZXBpbmcgYSBjb3B5IG9mIHRoZSBwcmV2aW91cyB2YWx1ZSBvZiBic3Nf
Y29uZi0+ZW5hYmxlX2JlYWNvbi4KSG93ZXZlciwgaGlmX2JlYWNvbl90cmFuc21pdCgpIGRvZXMg
bm90IGNvc3Qgc28gbXVjaCBhbmQgbWFjODAyMTEKYWxyZWFkeSB0YWtlIGNhcmUgdG8gbm90IHNl
bmQgdXNlbGVzcyBldmVudHMuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVy
b21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyB8
IDkgKystLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oIHwgMSAtCiAyIGZpbGVzIGNo
YW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCAz
NzY0NTE0MzNlOWUuLmRlZGU2MzIzYmIxNyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC04NDMsMTIgKzg0Myw4
IEBAIHZvaWQgd2Z4X2Jzc19pbmZvX2NoYW5nZWQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsCiAJ
fQogCiAJaWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9CRUFDT05fRU5BQkxFRCAmJgotCSAgICB3
dmlmLT5zdGF0ZSAhPSBXRlhfU1RBVEVfSUJTUykgewotCQlpZiAod3ZpZi0+ZW5hYmxlX2JlYWNv
biAhPSBpbmZvLT5lbmFibGVfYmVhY29uKSB7Ci0JCQloaWZfYmVhY29uX3RyYW5zbWl0KHd2aWYs
IGluZm8tPmVuYWJsZV9iZWFjb24pOwotCQkJd3ZpZi0+ZW5hYmxlX2JlYWNvbiA9IGluZm8tPmVu
YWJsZV9iZWFjb247Ci0JCX0KLQl9CisJICAgIHd2aWYtPnN0YXRlICE9IFdGWF9TVEFURV9JQlNT
KQorCQloaWZfYmVhY29uX3RyYW5zbWl0KHd2aWYsIGluZm8tPmVuYWJsZV9iZWFjb24pOwogCiAJ
aWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9CRUFDT05fSU5GTykKIAkJaGlmX3NldF9iZWFjb25f
d2FrZXVwX3BlcmlvZCh3dmlmLCBpbmZvLT5kdGltX3BlcmlvZCwKQEAgLTEyOTksNyArMTI5NSw2
IEBAIHZvaWQgd2Z4X3JlbW92ZV9pbnRlcmZhY2Uoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsCiAJ
CX0KIAkJbWVtc2V0KHd2aWYtPmxpbmtfaWRfZGIsIDAsIHNpemVvZih3dmlmLT5saW5rX2lkX2Ri
KSk7CiAJCXd2aWYtPnN0YV9hc2xlZXBfbWFzayA9IDA7Ci0JCXd2aWYtPmVuYWJsZV9iZWFjb24g
PSBmYWxzZTsKIAkJd3ZpZi0+bWNhc3RfdHggPSBmYWxzZTsKIAkJd3ZpZi0+YWlkMF9iaXRfc2V0
ID0gZmFsc2U7CiAJCXd2aWYtPm1jYXN0X2J1ZmZlcmVkID0gZmFsc2U7CmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaAppbmRl
eCBiZDRiNTVlMDdjNzMuLjg0Y2IzYTgzZTVkOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5n
L3dmeC93ZnguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCkBAIC05OSw3ICs5OSw2
IEBAIHN0cnVjdCB3ZnhfdmlmIHsKIAlzdHJ1Y3Qgd29ya19zdHJ1Y3QJc2V0X3RpbV93b3JrOwog
CiAJaW50CQkJYmVhY29uX2ludDsKLQlib29sCQkJZW5hYmxlX2JlYWNvbjsKIAlib29sCQkJZmls
dGVyX2Jzc2lkOwogCWJvb2wJCQlmd2RfcHJvYmVfcmVxOwogCWJvb2wJCQlkaXNhYmxlX2JlYWNv
bl9maWx0ZXI7Ci0tIAoyLjI1LjAKCg==
