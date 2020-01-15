Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4259313C047
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731596AbgAOMSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:18:09 -0500
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:24056
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730407AbgAOMMq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQq7Q9LehLQW3Thb+uWUut9Z7aA2oXVtng8hS8rLOKI4FyJJVtpdGU6nQWfw+DT0wU1bf2iBymqJe+0ymBxI0SDGaW77EHjNVp9TC5eYnh6e8EkeSWkaxQZPQzKPJc/5uI+dC0+NtxXg61ODbgx6ZM68eis1AeiPIZcU9lXBum0ShUtM9wgapYvypV8T3rLPWuKCcVpiaIvb/c3zyReKTzlTIfo4bEDM19VmMbWOZb5FA6AoxlCKBddEGVdQuZ5GAW95Da6XBBBzBBK1g6BYL2/30a6Le3hmdZYz48hzfh2uRrWdozq5k6LxfZqXwlcQadk9xje6N4hIW/tB/kxqHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9v8lmwrZH/RnjmTRFxIndgVQtr5M/Rb020b3Yufs6f8=;
 b=QNeKUj5HmSjuc65LXVLgIzp7SYKmShV2WI+GxlYSJoJOYGhIPXrLAHVKbT0HUN+uW7GAGKLpBjFD6R8CvLXhxEwMtwa+AvEbNsEGcZJSliMAcPDV0vOkYwK9UGdJLP5gvnhbpnBabcJyiIfMg+79CjP2elf0bOq7Edx/TVOuj5kN4Et6/Roqjdp06prlnemfFIefA9fS21ufoG1CU559km9wq+c7+wZ/91u4lCKta+iMQ38tT8FNijZJgxAkshWm39XGc9tifW1HJUeqK/7QW8WIJSUp+Vg5H6YLnY8sotMchFE9bg8dESk+DeglTy29CX2Ovro5uhvHy+OcakgEuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9v8lmwrZH/RnjmTRFxIndgVQtr5M/Rb020b3Yufs6f8=;
 b=FynQyQ2wB78C+inSL7uxxhi4yJHt3KwmZ+f2Tq/rpRHA4lDU2Kps78OQVAKjwI9jx4N6AhHA8jegV4Y4bujb5MDKAXblYf0fc4Oloj/CNbiPvUbdm0OzDqmoL9K9l5uFl/IPf9amR7OoGsrXefWnjJPvGI4SA7fnHvCDWZuF3qQ=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:12:34 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:34 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:33 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 19/65] staging: wfx: fix __wfx_flush() when drop == false
Thread-Topic: [PATCH 19/65] staging: wfx: fix __wfx_flush() when drop == false
Thread-Index: AQHVy50ROBMg+v6CA0G5VLJRshsWqg==
Date:   Wed, 15 Jan 2020 12:12:34 +0000
Message-ID: <20200115121041.10863-20-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 7fd5b2cd-36b5-41b5-d03a-08d799b4342f
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB39343E993DC897624B3389FC93370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QTKzTObCJ3EziBd/aRPvpBy91zeCyy4/Tnwn1hy/2nlPkNOqoWnxVzughdiA0+A9a1LrJncMPiGtz9qIh1VH9NDsiOWYuPQfLSPcIpsl+6hts/g4w1WGOs4WtF1o6DeoaAp3Fk6ItQpY3ufSFWDtrWS0nbzMX1fs1ucr3Ez+GBrphGKK+Q742dDlPby4U/QlsgUlAJTzWFjVitYlPOgQV5D182jxAuGaE5qqwrHVHTZS3LJcKpt0xH+FR3rSGjwX7pFG2Iai1uGR+WJlD06SopNg7LR5tcPAiO5BUi7wtK19RMVFlyc0gDnbb7k2Rmu+kPB2E8w9iKhcuJijDKNiy4Wz6Jx1+Fzi+1sK+vAU4sEkQdXybPUkWFPKU188S+3NVx2vm9/2dPCUJPOW5V0rigEn+HvM1Q5aBkxr/euV4KYcjBBjXIcTW7KYhSk/lkeQ
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B443518F7D18A40B3FD716F3E52EC9A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fd5b2cd-36b5-41b5-d03a-08d799b4342f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:34.6585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5leVy8NqAAfjL6mK14t/iRLQEiyBLtp4gNwGjTTPUBycbHm55ZGEfzsWajxDVwFA1aVpIchgfjWtCbXEd+T6VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3R4X3F1ZXVlc19jbGVhcigpIG9ubHkgY2xlYXIgbm90IHlldCBzZW50IHJlcXVlc3RzLiBTbywg
aXQgYWx3YXlzCm5lY2Vzc2FyeSB0byB3YWl0IGZvciB0eF9xdWV1ZV9zdGF0cy53YWl0X2xpbmtf
aWRfZW1wdHkgd2hhdGV2ZXIgdGhlCnZhbHVlIG9mICJkcm9wIiBhcmd1bWVudC4KCkluIGFkZCwg
aXQgaXMgbm90IG5lY2Vzc2FyeSB0byByZXR1cm4gd2l0aCB0eCBxdWV1ZSBsb2NrZWQgc2luY2Ug
YWxsCmNhbGxzIHRvIF9fd2Z4X2ZsdXNoKCkgdW5sb2NrIHRoZSB0eCBxdWV1ZSBqdXN0IGFmdGVy
IHRoZSBjYWxsIHRvCl9fd2Z4X3R4X2ZsdXNoKCkuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQ
b3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9xdWV1ZS5jIHwgIDIgLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICB8IDQyICsr
KysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTEg
aW5zZXJ0aW9ucygrKSwgMzMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9xdWV1ZS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCmluZGV4IGFiZmJh
ZDdjOWY3NS4uOTJiYjlhNzk0ZjMwIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1
ZXVlLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCkBAIC0zMSw4ICszMSw2IEBA
IHZvaWQgd2Z4X3R4X2ZsdXNoKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogewogCWludCByZXQ7CiAK
LQlXQVJOKCFhdG9taWNfcmVhZCgmd2Rldi0+dHhfbG9jayksICJ0eF9sb2NrIGlzIG5vdCBsb2Nr
ZWQiKTsKLQogCS8vIERvIG5vdCB3YWl0IGZvciBhbnkgcmVwbHkgaWYgY2hpcCBpcyBmcm96ZW4K
IAlpZiAod2Rldi0+Y2hpcF9mcm96ZW4pCiAJCXJldHVybjsKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDBjNzM2
OTFhYjczNi4uM2Q2NjVlZWY4YmE3IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTM0Myw0MiArMzQzLDI1IEBA
IGludCB3Znhfc2V0X3J0c190aHJlc2hvbGQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHUzMiB2
YWx1ZSkKIAlyZXR1cm4gMDsKIH0KIAotLyogSWYgc3VjY2Vzc2Z1bCwgTE9DS1MgdGhlIFRYIHF1
ZXVlISAqLwogc3RhdGljIGludCBfX3dmeF9mbHVzaChzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgYm9v
bCBkcm9wKQogewotCWludCByZXQ7Ci0KIAlmb3IgKDs7KSB7Ci0JCWlmIChkcm9wKSB7CisJCWlm
IChkcm9wKQogCQkJd2Z4X3R4X3F1ZXVlc19jbGVhcih3ZGV2KTsKLQkJfSBlbHNlIHsKLQkJCXJl
dCA9IHdhaXRfZXZlbnRfdGltZW91dCgKLQkJCQl3ZGV2LT50eF9xdWV1ZV9zdGF0cy53YWl0X2xp
bmtfaWRfZW1wdHksCi0JCQkJd2Z4X3R4X3F1ZXVlc19pc19lbXB0eSh3ZGV2KSwKLQkJCQkyICog
SFopOwotCQl9Ci0KLQkJaWYgKCFkcm9wICYmIHJldCA8PSAwKSB7Ci0JCQlyZXQgPSAtRVRJTUVE
T1VUOwotCQkJYnJlYWs7Ci0JCX0KLQkJcmV0ID0gMDsKLQotCQl3ZnhfdHhfbG9ja19mbHVzaCh3
ZGV2KTsKLQkJaWYgKCF3ZnhfdHhfcXVldWVzX2lzX2VtcHR5KHdkZXYpKSB7Ci0JCQkvKiBIaWdo
bHkgdW5saWtlbHk6IFdTTSByZXF1ZXVlZCBmcmFtZXMuICovCi0JCQl3ZnhfdHhfdW5sb2NrKHdk
ZXYpOwotCQkJY29udGludWU7Ci0JCX0KLQkJYnJlYWs7CisJCWlmICh3YWl0X2V2ZW50X3RpbWVv
dXQod2Rldi0+dHhfcXVldWVfc3RhdHMud2FpdF9saW5rX2lkX2VtcHR5LAorCQkJCSAgICAgICB3
ZnhfdHhfcXVldWVzX2lzX2VtcHR5KHdkZXYpLAorCQkJCSAgICAgICAyICogSFopIDw9IDApCisJ
CQlyZXR1cm4gLUVUSU1FRE9VVDsKKwkJd2Z4X3R4X2ZsdXNoKHdkZXYpOworCQlpZiAod2Z4X3R4
X3F1ZXVlc19pc19lbXB0eSh3ZGV2KSkKKwkJCXJldHVybiAwOworCQlkZXZfd2Fybih3ZGV2LT5k
ZXYsICJmcmFtZXMgcXVldWVkIHdoaWxlIGZsdXNoaW5nIHR4IHF1ZXVlcyIpOwogCX0KLQlyZXR1
cm4gcmV0OwogfQogCiB2b2lkIHdmeF9mbHVzaChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3Ry
dWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAkJICB1MzIgcXVldWVzLCBib29sIGRyb3ApCiB7Ci0J
c3RydWN0IHdmeF9kZXYgKndkZXYgPSBody0+cHJpdjsKIAlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZjsK
IAogCWlmICh2aWYpIHsKQEAgLTM4OSwxMCArMzcyLDggQEAgdm9pZCB3ZnhfZmx1c2goc3RydWN0
IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCiAJCSAgICAhd3Zp
Zi0+ZW5hYmxlX2JlYWNvbikKIAkJCWRyb3AgPSB0cnVlOwogCX0KLQogCS8vIEZJWE1FOiBvbmx5
IGZsdXNoIHJlcXVlc3RlZCB2aWYKLQlpZiAoIV9fd2Z4X2ZsdXNoKHdkZXYsIGRyb3ApKQotCQl3
ZnhfdHhfdW5sb2NrKHdkZXYpOworCV9fd2Z4X2ZsdXNoKGh3LT5wcml2LCBkcm9wKTsKIH0KIAog
LyogV1NNIGNhbGxiYWNrcyAqLwpAQCAtMTA0Niw4ICsxMDI3LDcgQEAgc3RhdGljIGludCB3Znhf
c2V0X3RpbV9pbXBsKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBib29sIGFpZDBfYml0X3NldCkKIAlz
a2IgPSBpZWVlODAyMTFfYmVhY29uX2dldF90aW0od3ZpZi0+d2Rldi0+aHcsIHd2aWYtPnZpZiwK
IAkJCQkgICAgICAgJnRpbV9vZmZzZXQsICZ0aW1fbGVuZ3RoKTsKIAlpZiAoIXNrYikgewotCQlp
ZiAoIV9fd2Z4X2ZsdXNoKHd2aWYtPndkZXYsIHRydWUpKQotCQkJd2Z4X3R4X3VubG9jayh3dmlm
LT53ZGV2KTsKKwkJX193ZnhfZmx1c2god3ZpZi0+d2RldiwgdHJ1ZSk7CiAJCXJldHVybiAtRU5P
RU5UOwogCX0KIAl0aW1fcHRyID0gc2tiLT5kYXRhICsgdGltX29mZnNldDsKLS0gCjIuMjUuMAoK
