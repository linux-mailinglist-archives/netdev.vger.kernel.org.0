Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79A161A4B7
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 23:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbfEJVqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 17:46:39 -0400
Received: from mail-eopbgr750132.outbound.protection.outlook.com ([40.107.75.132]:30426
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728286AbfEJVqi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 17:46:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=impinj.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Get2beWjn+aU8qZx/fRGQtvU2z5gK/ZkXRx5u5kF5HI=;
 b=BHvgLVw/8zgV4MfKnXVEKaPHlKHww9ojWTEthvU6NE7U3LeOJ1w//2JX9CYERf/4UpAWmc6OmhjgDc5zDBWPe5PPGUPueUWTQRejQAAu/YPgFzg0kwfZ54JDrwJfsU8UAzP5+9zyEjrmCxkEmMqis4/j4/R3iidqIPxjEJysv0c=
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com (10.167.236.38) by
 MWHPR0601MB3612.namprd06.prod.outlook.com (10.167.236.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.20; Fri, 10 May 2019 21:46:21 +0000
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::b496:85ab:4cb0:5876]) by MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::b496:85ab:4cb0:5876%2]) with mapi id 15.20.1878.022; Fri, 10 May 2019
 21:46:21 +0000
From:   Trent Piepho <tpiepho@impinj.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Trent Piepho <tpiepho@impinj.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 4/5] net: phy: dp83867: Disable tx/rx delay when not
 configured
Thread-Topic: [PATCH 4/5] net: phy: dp83867: Disable tx/rx delay when not
 configured
Thread-Index: AQHVB3nJzyMtDMfr/E+ATF4/fU++zA==
Date:   Fri, 10 May 2019 21:46:13 +0000
Message-ID: <20190510214550.18657-4-tpiepho@impinj.com>
References: <20190510214550.18657-1-tpiepho@impinj.com>
In-Reply-To: <20190510214550.18657-1-tpiepho@impinj.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:a03:74::21) To MWHPR0601MB3708.namprd06.prod.outlook.com
 (2603:10b6:301:7c::38)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tpiepho@impinj.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.14.5
x-originating-ip: [216.207.205.253]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71e00057-f3c0-4671-05b9-08d6d590eb9e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0601MB3612;
x-ms-traffictypediagnostic: MWHPR0601MB3612:
x-microsoft-antispam-prvs: <MWHPR0601MB361258E744755E651AEBD061D30C0@MWHPR0601MB3612.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0033AAD26D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(376002)(39840400004)(136003)(189003)(199004)(316002)(3846002)(6116002)(86362001)(8676002)(81166006)(99286004)(66066001)(81156014)(478600001)(102836004)(25786009)(73956011)(76176011)(476003)(2616005)(68736007)(11346002)(66946007)(66476007)(66556008)(66446008)(64756008)(14454004)(50226002)(6506007)(446003)(486006)(8936002)(26005)(386003)(6666004)(186003)(4326008)(52116002)(256004)(14444005)(36756003)(305945005)(2906002)(1076003)(110136005)(6436002)(6486002)(6512007)(54906003)(71190400001)(2501003)(5660300002)(71200400001)(53936002)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR0601MB3612;H:MWHPR0601MB3708.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: impinj.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8wHeFSBsdO7oVR7INcpUN+xGSH2hRbvKl7ctP1Y71QxJGHOO9+WLOM1TvxCa1P07m26MhLWiImLDT6+ERZF9CfSdi6r6kCMqxXdj/TlFHp7nqOLwQmmU98QBtRXicYWswFzrf73Gw76z4Oi2RrurrkRKblFKgOFaKYw9mWAi9XAG+Bzb/qFOMLiNgFDCvSrY0mnwL6V332Yi4B/cj2fU12klZV2XvTo2YlsxlkXsu50DJkTklXM+n3TyHfUjMzjJBQc6fopvDcqIZKZE7lqqQ1S5XGmiePldiWjM+ODpu29cLJ2+ULfqu7XmbkSbHuDzUWFakqUpIq3iEu7VUG5ERmooMcFW2AlodhVnW6SpKbCexRqH3X9BMo7mnybuv8ek4awgtXn0XcEM76HTUbP6acPprSabxxp5q41eS7zvwxU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: impinj.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71e00057-f3c0-4671-05b9-08d6d590eb9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2019 21:46:13.0707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6de70f0f-7357-4529-a415-d8cbb7e93e5e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0601MB3612
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIGNvZGUgd2FzIGFzc3VtaW5nIHRoZSByZXNldCBkZWZhdWx0IG9mIHRoZSBkZWxheSBjb250
cm9sIHJlZ2lzdGVyCndhcyB0byBoYXZlIGRlbGF5IGRpc2FibGVkLiAgVGhpcyBpcyB3aGF0IHRo
ZSBkYXRhc2hlZXQgc2hvd3MgYXMgdGhlCnJlZ2lzdGVyJ3MgaW5pdGlhbCB2YWx1ZS4gIEhvd2V2
ZXIsIHRoYXQncyBub3QgYWN0dWFsbHkgdHJ1ZTogdGhlCmRlZmF1bHQgaXMgY29udHJvbGxlZCBi
eSB0aGUgUEhZJ3MgcGluIHN0cmFwcGluZy4KCklmIHRoZSBpbnRlcmZhY2UgbW9kZSBpcyBzZWxl
Y3RlZCBhcyBSWCBvciBUWCBkZWxheSBvbmx5LCBpbnN1cmUgdGhlCm90aGVyIGRpcmVjdGlvbidz
IGRlbGF5IGlzIGRpc2FibGVkLgoKSWYgdGhlIGludGVyZmFjZSBtb2RlIGlzIGp1c3QgInJnbWlp
Iiwgd2l0aCBuZWl0aGVyIFRYIG9yIFJYIGludGVybmFsCmRlbGF5LCBvbmUgbWlnaHQgZXhwZWN0
IHRoYXQgdGhlIGRyaXZlciBzaG91bGQgZGlzYWJsZSBib3RoIGRlbGF5cy4gIEJ1dAp0aGlzIGlz
IG5vdCB3aGF0IHRoZSBkcml2ZXIgZG9lcy4gIEl0IGxlYXZlcyB0aGUgc2V0dGluZyBhdCB0aGUg
UEhZJ3MKc3RyYXBwaW5nJ3MgZGVmYXVsdC4gIEFuZCB0aGF0IGRlZmF1bHQsIGZvciBubyBwaW5z
IHdpdGggc3RyYXBwaW5nCnJlc2lzdG9ycywgaXMgdG8gaGF2ZSBkZWxheSBlbmFibGVkIGFuZCAy
LjAwIG5zLgoKUmF0aGVyIHRoYW4gY2hhbmdlIHRoaXMgYmVoYXZpb3IsIEkndmUga2VwdCBpdCB0
aGUgc2FtZSBhbmQgZG9jdW1lbnRlZAppdC4gIE5vIGRlbGF5IHdpbGwgbW9zdCBsaWtlbHkgbm90
IHdvcmsgYW5kIHdpbGwgYnJlYWsgZXRoZXJuZXQgb24gYW55CmJvYXJkIHVzaW5nICJyZ21paSIg
bW9kZS4KCkNjOiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+CkNjOiBGbG9yaWFuIEZhaW5l
bGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT4KQ2M6IEhlaW5lciBLYWxsd2VpdCA8aGthbGx3ZWl0
MUBnbWFpbC5jb20+ClNpZ25lZC1vZmYtYnk6IFRyZW50IFBpZXBobyA8dHBpZXBob0BpbXBpbmou
Y29tPgotLS0KIGRyaXZlcnMvbmV0L3BoeS9kcDgzODY3LmMgfCA2ICsrKysrKwogMSBmaWxlIGNo
YW5nZWQsIDYgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9kcDgz
ODY3LmMgYi9kcml2ZXJzL25ldC9waHkvZHA4Mzg2Ny5jCmluZGV4IDQyMDcyOWNkNjAyNS4uYTQ2
Y2M5NDI3ZmIzIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC9waHkvZHA4Mzg2Ny5jCisrKyBiL2Ry
aXZlcnMvbmV0L3BoeS9kcDgzODY3LmMKQEAgLTI1NiwxMCArMjU2LDE2IEBAIHN0YXRpYyBpbnQg
ZHA4Mzg2N19jb25maWdfaW5pdChzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQogCQkJcmV0dXJu
IHJldDsKIAl9CiAKKwkvKiBJZiByZ21paSBtb2RlIHdpdGggbm8gaW50ZXJuYWwgZGVsYXkgaXMg
c2VsZWN0ZWQsIHdlIGRvIE5PVCB1c2UKKwkgKiBhbGlnbmVkIG1vZGUgYXMgb25lIG1pZ2h0IGV4
cGVjdC4gIEluc3RlYWQgd2UgdXNlIHRoZSBQSFkncyBkZWZhdWx0CisJICogYmFzZWQgb24gcGlu
IHN0cmFwcGluZy4gIEFuZCB0aGUgIm1vZGUgMCIgZGVmYXVsdCBpcyB0byAqdXNlKgorCSAqIGlu
dGVybmFsIGRlbGF5IHdpdGggYSB2YWx1ZSBvZiA3ICgyLjAwIG5zKS4KKwkgKi8KIAlpZiAoKHBo
eWRldi0+aW50ZXJmYWNlID49IFBIWV9JTlRFUkZBQ0VfTU9ERV9SR01JSV9JRCkgJiYKIAkgICAg
KHBoeWRldi0+aW50ZXJmYWNlIDw9IFBIWV9JTlRFUkZBQ0VfTU9ERV9SR01JSV9SWElEKSkgewog
CQl2YWwgPSBwaHlfcmVhZF9tbWQocGh5ZGV2LCBEUDgzODY3X0RFVkFERFIsIERQODM4NjdfUkdN
SUlDVEwpOwogCisJCXZhbCAmPSB+KERQODM4NjdfUkdNSUlfVFhfQ0xLX0RFTEFZX0VOIHwgRFA4
Mzg2N19SR01JSV9SWF9DTEtfREVMQVlfRU4pOwogCQlpZiAocGh5ZGV2LT5pbnRlcmZhY2UgPT0g
UEhZX0lOVEVSRkFDRV9NT0RFX1JHTUlJX0lEKQogCQkJdmFsIHw9IChEUDgzODY3X1JHTUlJX1RY
X0NMS19ERUxBWV9FTiB8IERQODM4NjdfUkdNSUlfUlhfQ0xLX0RFTEFZX0VOKTsKIAotLSAKMi4x
NC41Cgo=
