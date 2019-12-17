Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A58123187
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbfLQQPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:15:46 -0500
Received: from mail-dm6nam12on2071.outbound.protection.outlook.com ([40.107.243.71]:6540
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728959AbfLQQPq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTpJKJ5kzI+DEwLrlOHtXew5NG1tCkkGgHbsBeRHU0PDSuC1bXiOh1y2B79+GZD5hYOTXJ2m80gFxJxkGOXXJOHvkTHmHYqQjtlt+Dtmh7TCb7WkHBDopxgSrqBl4405pc2Hyf0UrAhfPTFok6EYKw+zQDJFh05FwvKGNyyD1n7XF40zoWCe0psXFrHQnpsHgeFomqSp/OVQ4nyPRksA2+1EHyYTrhLNlRRYfEXKs5ydkONj0F2SMzWXvQtL+9KRa/SYceiaQNd1IXZ40QB9nwl60VBhPyfKZ3xZyVuDu/xiafLyiT0yZIe74ZsgMvrnbelD3znhUf0AmMPfCqTZFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eufy3zFzbX1vAfWm/2yW+tV5AIgispF9pG/MHD3WeCY=;
 b=obpte9sksxVL8PyWi+96Ds2VTJtZ3WE9lPnNTmO2pYpuoqkDSLDWJVM8GTrnsRUnSDH8Oo3lLUBd7ol+dJaKFidVnaQ6LqY433Gqw3Vq0xaI6vC77kqgZnnOD/+i7P4xZNmURbMG1OOgYahko8OW7tAmrrOYIWyWYZtJPEXKVc2ECOtyppJETjXPdsch4XZv73tC7vSUdoAYTse5ipfzC0gZP9i4L5mrfXV8g6hwxa1x86mxBmJSHW3KT6mRzg8zoeX6iIHXuJjmLXdFuJNsHQ6IvY9kFoAlvqjjG6bas8gIrlmsfPae9uumYa2QzbJc2/zeMp8D9XYQzPv1iplmqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eufy3zFzbX1vAfWm/2yW+tV5AIgispF9pG/MHD3WeCY=;
 b=ebzYkDlcnf49ZLbKLUEWVe2NfqUXRmsyQoBYRlT4D1QNJNH7fGWSP6EwGhGfK90KlG/gmZ++ASrIscvXFNqCNtlG4RWwIJXldkPnUb1Go0Ire5Ee2+xFAru5yTigOaUDvXUsm8qRA+okuMfvMvsGESFeAELFlzXmevTVKp1+h1M=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4477.namprd11.prod.outlook.com (52.135.36.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Tue, 17 Dec 2019 16:15:42 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:42 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 34/55] staging: wfx: drop unnecessary wvif->powersave_mode
Thread-Topic: [PATCH v2 34/55] staging: wfx: drop unnecessary
 wvif->powersave_mode
Thread-Index: AQHVtPUqxAmwZ667vkKtQS/hW9fDrg==
Date:   Tue, 17 Dec 2019 16:15:15 +0000
Message-ID: <20191217161318.31402-35-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9917fdf6-7661-43e3-604c-08d7830c4d02
x-ms-traffictypediagnostic: MN2PR11MB4477:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4477FAD1E41DC7119F73393A93500@MN2PR11MB4477.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(1076003)(66574012)(186003)(107886003)(8676002)(6506007)(86362001)(478600001)(85182001)(5660300002)(81156014)(26005)(4326008)(6486002)(8936002)(316002)(110136005)(54906003)(64756008)(66446008)(66946007)(2616005)(66556008)(66476007)(85202003)(36756003)(6512007)(2906002)(52116002)(6666004)(71200400001)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4477;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cTRlm+8G7iPKwnVrZkuevw4O/HrlLX4B2PiujFe+5kfy0XkwXGGReLJLSLzDhWiQAIXhMQbSlw7NmKWwbAafhB1JsmSJktOqY1CIgEyFv8hNRNTyVJNmVVGvE/IF33Y+LlKsuIVSbANXleqVRuI83n5K3sbVfE9WUEaJmYnb96t5VMo6pZ8Ou9qzITwvcWl+uksKNZmPNcD/FqAIS76zxpGmBbVDCNPNAdgFA4uV97lex1hTc5L405ML0U61/G5eMRHlAbE4e9pgowGNn6jYDOK98dtBkJl9aplhVwmees/nLrFJ8QVodrshQV3Ipejisu01Mzu83lg0omsXjGxgHpmKXgQpOmLUFo/pnr908QsmD+7ddyY7kXlm+Bc6XpPSH5JPmHlprMLup/aiQNtyHouK4r71Xdezl2dqtaoxDpK1rlTydkD4i4YBJggZW2fs
Content-Type: text/plain; charset="utf-8"
Content-ID: <65266D1356439E4590E55DD1E0AE537C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9917fdf6-7661-43e3-604c-08d7830c4d02
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:15.2551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PpdKwURKeYetdX13dMc7Rh0i90wMKuBTYgOAeuynI2RGAj9x6Tbx0vtVhc+a4cdnxymwCHW5XIzpBtDSymytNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4477
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKUG93
ZXIgc2F2ZSBzdGF0dXMgaXMgYWxyZWFkeSBhdmFpbGFibGUgaW4gYnNzX2NvbmYuIFNvIHRoZXJl
IGlzIG5vCnJlYXNvbiB0byBrZWVwIGluZm9ybWF0aW9uIGR1cGxpY2F0ZWQgaW4gd3ZpZi0+cG93
ZXJzYXZlX21vZGUuCgpJbiBhZGQsIHR5cGUgb2Ygd3ZpZi0+cG93ZXJzYXZlX21vZGUgaXMgbG93
IGxldmVsIHN0cnVjdCBtYWRlIHRvCmNvbW11bmljYXRlIHdpdGggZGV2aWNlLiBXZSB3b3VsZCBs
aWtlIHRvIGxpbWl0IHVzYWdlIG9mIHRoaXMga2luZCBvZgpzdHJ1Y3QgaW4gdXBwZXIgbGF5ZXJz
IG9mIHRoZSBkcml2ZXIuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21l
LnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyB8IDMx
ICsrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvd2Z4
LmggfCAgMSAtCiAyIGZpbGVzIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDE5IGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDkxZmE0ZDhhYTM3ZC4uYzU3MTM1Zjc3NTcyIDEwMDY0NAot
LS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMKQEAgLTMyOCwxMiArMzI4LDIzIEBAIHZvaWQgd2Z4X2NvbmZpZ3VyZV9maWx0ZXIoc3Ry
dWN0IGllZWU4MDIxMV9odyAqaHcsCiAKIHN0YXRpYyBpbnQgd2Z4X3VwZGF0ZV9wbShzdHJ1Y3Qg
d2Z4X3ZpZiAqd3ZpZikKIHsKLQlzdHJ1Y3QgaGlmX3JlcV9zZXRfcG1fbW9kZSBwbSA9IHd2aWYt
PnBvd2Vyc2F2ZV9tb2RlOworCXN0cnVjdCBpZWVlODAyMTFfY29uZiAqY29uZiA9ICZ3dmlmLT53
ZGV2LT5ody0+Y29uZjsKKwlzdHJ1Y3QgaGlmX3JlcV9zZXRfcG1fbW9kZSBwbTsKIAl1MTYgdWFw
c2RfZmxhZ3M7CiAKIAlpZiAod3ZpZi0+c3RhdGUgIT0gV0ZYX1NUQVRFX1NUQSB8fCAhd3ZpZi0+
YnNzX3BhcmFtcy5haWQpCiAJCXJldHVybiAwOwogCisJbWVtc2V0KCZwbSwgMCwgc2l6ZW9mKHBt
KSk7CisJaWYgKGNvbmYtPmZsYWdzICYgSUVFRTgwMjExX0NPTkZfUFMpIHsKKwkJcG0ucG1fbW9k
ZS5lbnRlcl9wc20gPSAxOworCQkvLyBGaXJtd2FyZSBkb2VzIG5vdCBzdXBwb3J0IG1vcmUgdGhh
biAxMjhtcworCQlwbS5mYXN0X3BzbV9pZGxlX3BlcmlvZCA9CisJCQltaW4oY29uZi0+ZHluYW1p
Y19wc190aW1lb3V0ICogMiwgMjU1KTsKKwkJaWYgKHBtLmZhc3RfcHNtX2lkbGVfcGVyaW9kKQor
CQkJcG0ucG1fbW9kZS5mYXN0X3BzbSA9IDE7CisJfQorCiAJbWVtY3B5KCZ1YXBzZF9mbGFncywg
Jnd2aWYtPnVhcHNkX2luZm8sIHNpemVvZih1YXBzZF9mbGFncykpOwogCiAJaWYgKHVhcHNkX2Zs
YWdzICE9IDApCkBAIC0xNDMyLDI0ICsxNDQzLDggQEAgaW50IHdmeF9jb25maWcoc3RydWN0IGll
ZWU4MDIxMV9odyAqaHcsIHUzMiBjaGFuZ2VkKQogCiAJaWYgKGNoYW5nZWQgJiBJRUVFODAyMTFf
Q09ORl9DSEFOR0VfUFMpIHsKIAkJd3ZpZiA9IE5VTEw7Ci0JCXdoaWxlICgod3ZpZiA9IHd2aWZf
aXRlcmF0ZSh3ZGV2LCB3dmlmKSkgIT0gTlVMTCkgewotCQkJbWVtc2V0KCZ3dmlmLT5wb3dlcnNh
dmVfbW9kZSwgMCwKLQkJCSAgICAgICBzaXplb2Yod3ZpZi0+cG93ZXJzYXZlX21vZGUpKTsKLQkJ
CWlmIChjb25mLT5mbGFncyAmIElFRUU4MDIxMV9DT05GX1BTKSB7Ci0JCQkJd3ZpZi0+cG93ZXJz
YXZlX21vZGUucG1fbW9kZS5lbnRlcl9wc20gPSAxOwotCQkJCWlmIChjb25mLT5keW5hbWljX3Bz
X3RpbWVvdXQgPiAwKSB7Ci0JCQkJCXd2aWYtPnBvd2Vyc2F2ZV9tb2RlLnBtX21vZGUuZmFzdF9w
c20gPSAxOwotCQkJCQkvKgotCQkJCQkgKiBGaXJtd2FyZSBkb2VzIG5vdCBzdXBwb3J0IG1vcmUg
dGhhbgotCQkJCQkgKiAxMjhtcwotCQkJCQkgKi8KLQkJCQkJd3ZpZi0+cG93ZXJzYXZlX21vZGUu
ZmFzdF9wc21faWRsZV9wZXJpb2QgPQotCQkJCQkJbWluKGNvbmYtPmR5bmFtaWNfcHNfdGltZW91
dCAqCi0JCQkJCQkgICAgMiwgMjU1KTsKLQkJCQl9Ci0JCQl9CisJCXdoaWxlICgod3ZpZiA9IHd2
aWZfaXRlcmF0ZSh3ZGV2LCB3dmlmKSkgIT0gTlVMTCkKIAkJCXdmeF91cGRhdGVfcG0od3ZpZik7
Ci0JCX0KIAkJd3ZpZiA9IHdkZXZfdG9fd3ZpZih3ZGV2LCAwKTsKIAl9CiAKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCmlu
ZGV4IDc4MWE4YzhiYTk4Mi4uYzgyZDI5NzY0ZDY2IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3dmeC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKQEAgLTEyNSw3ICsx
MjUsNiBAQCBzdHJ1Y3Qgd2Z4X3ZpZiB7CiAKIAlzdHJ1Y3Qgd2Z4X3NjYW4JCXNjYW47CiAKLQlz
dHJ1Y3QgaGlmX3JlcV9zZXRfcG1fbW9kZSBwb3dlcnNhdmVfbW9kZTsKIAlzdHJ1Y3QgY29tcGxl
dGlvbglzZXRfcG1fbW9kZV9jb21wbGV0ZTsKIAogCXN0cnVjdCBsaXN0X2hlYWQJZXZlbnRfcXVl
dWU7Ci0tIAoyLjI0LjAKCg==
