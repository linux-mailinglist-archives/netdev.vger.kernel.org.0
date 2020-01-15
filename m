Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03BF213C06C
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732487AbgAOMSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:18:32 -0500
Received: from mail-bn7nam10on2047.outbound.protection.outlook.com ([40.107.92.47]:27390
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730667AbgAOMMo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LbjcVHYr7ws+4mhmKNFYK48MT0k3pJf1smHl1f1TIV58mwDDV3pa3m6vKghsrtg5Cy0Ck9Zn4mPJbsORpjv79X2TNj5iaplWybBfuOOSXPZ49R4r8HAKgr1DmYc+5jCM0WLUfVB4odsPUVNYa71hBH/kUxw/jAjw4e4djnwfGieOliDUXBYrO/UBO+PFm/vhoTKw6MoRQkID+ONu5JNIlerA8erW9Fe+Cu/2RDS5ykZdt/0cwdbhPGlj/GgU0eHAaMdxVGgqKZEx89KVJKGpdN7rgvm9JL5BxxxiMXBN8LYfQ0ddAUAiFEqOJvQA9lPK0h/7cjYDizYIt6tP7VN1lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyDWq4MM5XzguJy/1tVdbLRwVPRpywmE0qbRXL02dkc=;
 b=kDA5UTSxUXKYadMhHd+XB+nevKSmUtYbuqVdBpu0Cui63jmbko3NeERgvr3MzsABoJwP3RzbI/f3Xl6CLdI93yL2R5WaWEuWiv2LkCQLpE4NkpRJ4qFqEepbFb8bG9Nc0+1/JKJ3GPIg6SWsEhiVzxWgQdxq6lS0XlXcqy63Uuxn82e+OG/CUsJTeD/TNN4SFgw6eeyV9Z8NyRhBI+ZEVP2VKCiUDz3I5GDqsFWsWG6E82rHn3m9NQ+u8YapROUsPlIkjpdorZQu6h/6BlKbMJb7jdooRL8TVm2nMxJDAPPCSwVdrKPEKBf6tuaf0gUMSwSXd9rwZeeTgfzfQ9zMjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyDWq4MM5XzguJy/1tVdbLRwVPRpywmE0qbRXL02dkc=;
 b=FmOPBYxkfjZMLtuTGwtEx/uVVVBkIlDYm2T09vZlpPz2v5SvjVd2Zn4FXfbL6sewaXYSzwMg5XUsKgiq0X9zvc7bTpBT+ILS4XB8VeQe32cO4NBB+TapCTD+76HdRqxqLlBx6NMS5ugAeknaQmVCIBh2zDJwLmeuhPkG0ZhpLHQ=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:12:40 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:40 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:38 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 23/65] staging: wfx: drop wvif->enable_beacon
Thread-Topic: [PATCH 23/65] staging: wfx: drop wvif->enable_beacon
Thread-Index: AQHVy50UuRVBqeQDKEKkOLFm7Uu3iw==
Date:   Wed, 15 Jan 2020 12:12:39 +0000
Message-ID: <20200115121041.10863-24-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: b0a2e61d-31f2-465f-373e-08d799b43758
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4096A4ADB07F4AF3B2DE92C493370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lwy1ep467sgeo32ZaPmGZu4ZxXrgQu1Kt6gQTqRiYtqJSyNnpmrId365NgwPlKIpjhzNRdbNgurYlcKTu2Of7S1xcaBsoQBryAT1sm9CH/IUbSknMxWZqC1oAv1l0qAO+zkUqUYs80Pynvg3dCTxo25qcxhK8wem8w3PZM/gwvTXR4nA9cEmrhcT5h7TwxYCJP8HyJQ+rN02Sb1EQRnlHVWDN/xGyi93nXTZGsZvEAKQeyrZM0ItSguilW/iWYtBcSdZ+btaHlLYdHRbJMwMGBJ0gnPDdNTnJ4MLC72OmIvEq1CCU9xEQ+0FyzR7+/S5IOcqijHhYrRWMBZ2C7dzj1TuywI0nEHmjLiBcsxMYW/3JMQ+R0LYN5sD47xpouHoj/GMRFmaS6zcizSMIJCHYFZYu/Q3qU+Wn6IWdBZd4LRQcMUnRLfUGLQKsp9nvBOU
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD798B01038C5143ADB1F84286420F2D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0a2e61d-31f2-465f-373e-08d799b43758
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:39.9584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fp9Rp6WTtWb1koJoPUuRQbewjQ2ttWpplPrVOxJHy0SxLU8/Ze0N3qANSjHh+UKsrpJoXYLEFDbVrF/bZMu29w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
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
