Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D37E61231A6
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbfLQQQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:16:09 -0500
Received: from mail-dm6nam12on2072.outbound.protection.outlook.com ([40.107.243.72]:33729
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728755AbfLQQQH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:16:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iE2K/Doea4h75gGb+iAwpe9qRLMUQIsiFXTLQLGODM6ayqiLLw+8jXnF1oFiKAB//P58XoYsmxh0bfxLKON85U7siONU6X6zjSbY/B5sTqag3v/BVr/zbynewpi1BdRD20ywmRx6KeR1hu1B1J6SuGm2RQF7dPbI2jMzlkI+H2PwU0KmfuRejsoPgh02jmrMcu2+1bsvHrByJGNhPtxepsLlQ4Ol4B2hzho3XjGkSX8XOAWn6wIvqpz0qq5g27CQxkzAGGTFrSBtpLj5rp75OPCf31xhDCSaI4Db1UbPQgl4FdVC05SaIpj3bEOG4lTSfdJZUZJCnlh8A1u4DlgrEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ee/z6m/vvrRSmvj8M3TfLohn1Xv4JRcuME8cta91xHM=;
 b=X2Axt3+Aub1+11QtO1uOuE1v1rMBSd+54GVYfgKvTBDVEOCP9nlhG+VA8XZAP+gz1fbmwzj6sxcPPZQgYZ02LyKfJYO5To7mHASmY7hXUsExJYVUhOV07gcx8T0Ezps+I7pd6Hnc5Cz+ijmtC3EeoRDM7abj38apLVsu7OhxwROppGD1PseXlFi6dWW49we6Yjp01L1pXCfs052tZdPWkJMQ/Wd9XcLEvPYAOZ0ciyvzB275phr0b8SAat0qW/mNxiJKXBxZK5/+rKy16rv8HpI3LnGR+2Fd1Yc5ryFFCrFtf1VZK5KmI39SVTeS6whE3qCgTbHLcXOn2aMbxvJMgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ee/z6m/vvrRSmvj8M3TfLohn1Xv4JRcuME8cta91xHM=;
 b=gtWPbKiZs9Pq6YAOOQXcUD6J5fmgVJrsECw4dRr0yqK09vDi8hcXHHd1HdKz4mqrSFixzs56rVMEuLUuEWLeIoQamzwL/+BPteK2cj9mRMBj4HAr3vc51WHJqdfKzJK8Tj2TCoAmBi/nlWBKvjQagdr+68DUhsKTlxgTJ1ee3fQ=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4477.namprd11.prod.outlook.com (52.135.36.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Tue, 17 Dec 2019 16:15:59 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:59 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 49/55] staging: wfx: simplify hif_set_template_frame()
 usage
Thread-Topic: [PATCH v2 49/55] staging: wfx: simplify hif_set_template_frame()
 usage
Thread-Index: AQHVtPU27t+6bG2zg0qyvxNTFnYGUg==
Date:   Tue, 17 Dec 2019 16:15:34 +0000
Message-ID: <20191217161318.31402-50-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 2f2b8e61-5884-43b3-3a35-08d7830c589c
x-ms-traffictypediagnostic: MN2PR11MB4477:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB44779DD1A27FC95BBFA532D393500@MN2PR11MB4477.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(1076003)(66574012)(186003)(107886003)(8676002)(6506007)(86362001)(478600001)(85182001)(5660300002)(81156014)(26005)(4326008)(6486002)(8936002)(316002)(110136005)(54906003)(64756008)(66446008)(66946007)(2616005)(66556008)(66476007)(85202003)(36756003)(6512007)(2906002)(52116002)(6666004)(71200400001)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4477;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ImqAzruPbCt+dfDZNxioIW2C8Hj8Lz4pI+xJiX9ZzDhGoDl8CCTHBUBrtoOtfYpB2W33aNyl/9yWVkoaJH+RA8SUYmNOr5TuDXRHUuhuP0cnUlpEJmhF6afVgFxyn1i6sj0R+CKpW7jqs4EhysAVlOC9JfDSYjy3Q5Ur7d2myuYnuhm9nRUbMjGii38ODxr0nSWJym2B1EuCQkd3+aWsRor1DR4aVKu4V/eJf6mkisTtBicwW9vSerdwfQJs7Fs3SscwlX7S4AvNerA0ttbSa0JwUXToRDYe5haQ1OzO6eUjZfzxh804iDEM5szUmf7ZDYO+r0461itj1yR+hBw2nl9HAjYyfCiC3Yfg5ksKodsBIO2Yi0L/AG6xOtYZrmVp2zcGjhgredq7DeBw9mVbfkYujKb3fPYntUEBnTjd68nMu7ro+STeQHR/wVi9JySj
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C80F7D799C1AA4DAB6C0C60FBE369CA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f2b8e61-5884-43b3-3a35-08d7830c589c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:34.7273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jx5tLeJMajjxLebmima1Vd8ZAvq+7fsUHnajcEWy31vCf3vccPGRuqxj5Z+0V4cNFxJyAkA9QN9BSnqLKVxFZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4477
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdHVyZSBoaWZfbWliX3RlbXBsYXRlX2ZyYW1lIGNvbWUgZnJvbSBoYXJkd2FyZSBBUEku
IEl0IGlzIG5vdAppbnRlbmRlZCB0byBiZSBtYW5pcHVsYXRlZCBpbiB1cHBlciBsYXllcnMgb2Yg
dGhlIGRyaXZlci4KCkluIGFkZCwgdGhlIGN1cnJlbnQgY29kZSBmb3IgaGlmX3NldF90ZW1wbGF0
ZV9mcmFtZSgpIGlzIGR1bWIuIEFsbCB0aGUKZGlmZmljdWx0IHRhc2sgaXMgbGVmdCB0byB0aGUg
Y2FsbGVyLiBTbywgdGhlcmUgaXMgY29kZSB0byBmYWN0b3JpemUKaGVyZS4KClNpZ25lZC1vZmYt
Ynk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaCB8IDExICsrKysrKysrKystCiBkcml2ZXJz
L3N0YWdpbmcvd2Z4L3NjYW4uYyAgICAgICB8ICA3ICstLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmMgICAgICAgIHwgMjkgKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIDMgZmls
ZXMgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwgMjkgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl90eF9taWIuaAppbmRleCBkNzc3NjVmNzVmMTAuLmIxZWVkYTJhM2FiMyAxMDA2NDQKLS0t
IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmgKKysrIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfdHhfbWliLmgKQEAgLTEzMCw4ICsxMzAsMTcgQEAgc3RhdGljIGlubGluZSBpbnQg
aGlmX3NldF9vcGVyYXRpb25hbF9tb2RlKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAogfQogCiBzdGF0
aWMgaW5saW5lIGludCBoaWZfc2V0X3RlbXBsYXRlX2ZyYW1lKHN0cnVjdCB3ZnhfdmlmICp3dmlm
LAotCQkJCQkgc3RydWN0IGhpZl9taWJfdGVtcGxhdGVfZnJhbWUgKmFyZykKKwkJCQkJIHN0cnVj
dCBza19idWZmICpza2IsCisJCQkJCSB1OCBmcmFtZV90eXBlLCBpbnQgaW5pdF9yYXRlKQogewor
CXN0cnVjdCBoaWZfbWliX3RlbXBsYXRlX2ZyYW1lICphcmc7CisKKwlza2JfcHVzaChza2IsIDQp
OworCWFyZyA9IChzdHJ1Y3QgaGlmX21pYl90ZW1wbGF0ZV9mcmFtZSAqKXNrYi0+ZGF0YTsKKwlz
a2JfcHVsbChza2IsIDQpOworCWFyZy0+aW5pdF9yYXRlID0gaW5pdF9yYXRlOworCWFyZy0+ZnJh
bWVfdHlwZSA9IGZyYW1lX3R5cGU7CisJYXJnLT5mcmFtZV9sZW5ndGggPSBjcHVfdG9fbGUxNihz
a2ItPmxlbik7CiAJcmV0dXJuIGhpZl93cml0ZV9taWIod3ZpZi0+d2Rldiwgd3ZpZi0+aWQsIEhJ
Rl9NSUJfSURfVEVNUExBVEVfRlJBTUUsCiAJCQkgICAgIGFyZywgc2l6ZW9mKCphcmcpKTsKIH0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9zY2FuLmMKaW5kZXggOGIxODRlZmFkMGNmLi5jODJjMDRmZjVkMDYgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nh
bi5jCkBAIC01Miw3ICs1Miw2IEBAIHN0YXRpYyBpbnQgd2Z4X3NjYW5fc3RhcnQoc3RydWN0IHdm
eF92aWYgKnd2aWYsCiBzdGF0aWMgaW50IHVwZGF0ZV9wcm9iZV90bXBsKHN0cnVjdCB3Znhfdmlm
ICp3dmlmLAogCQkJICAgICBzdHJ1Y3QgY2ZnODAyMTFfc2Nhbl9yZXF1ZXN0ICpyZXEpCiB7Ci0J
c3RydWN0IGhpZl9taWJfdGVtcGxhdGVfZnJhbWUgKnRtcGw7CiAJc3RydWN0IHNrX2J1ZmYgKnNr
YjsKIAogCXNrYiA9IGllZWU4MDIxMV9wcm9iZXJlcV9nZXQod3ZpZi0+d2Rldi0+aHcsIHd2aWYt
PnZpZi0+YWRkciwKQEAgLTYxLDExICs2MCw3IEBAIHN0YXRpYyBpbnQgdXBkYXRlX3Byb2JlX3Rt
cGwoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCXJldHVybiAtRU5PTUVNOwogCiAJc2tiX3B1dF9k
YXRhKHNrYiwgcmVxLT5pZSwgcmVxLT5pZV9sZW4pOwotCXNrYl9wdXNoKHNrYiwgNCk7Ci0JdG1w
bCA9IChzdHJ1Y3QgaGlmX21pYl90ZW1wbGF0ZV9mcmFtZSAqKXNrYi0+ZGF0YTsKLQl0bXBsLT5m
cmFtZV90eXBlID0gSElGX1RNUExUX1BSQlJFUTsKLQl0bXBsLT5mcmFtZV9sZW5ndGggPSBjcHVf
dG9fbGUxNihza2ItPmxlbiAtIDQpOwotCWhpZl9zZXRfdGVtcGxhdGVfZnJhbWUod3ZpZiwgdG1w
bCk7CisJaGlmX3NldF90ZW1wbGF0ZV9mcmFtZSh3dmlmLCBza2IsIEhJRl9UTVBMVF9QUkJSRVEs
IDApOwogCWRldl9rZnJlZV9za2Ioc2tiKTsKIAlyZXR1cm4gMDsKIH0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4
IDE5Y2ExMzU0M2EyNS4uYmEzZTgxZmQ0NzdiIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTgzMSwzMiArODMx
LDIwIEBAIHN0YXRpYyBpbnQgd2Z4X3VwZGF0ZV9iZWFjb25pbmcoc3RydWN0IHdmeF92aWYgKnd2
aWYpCiAKIHN0YXRpYyBpbnQgd2Z4X3VwbG9hZF9iZWFjb24oc3RydWN0IHdmeF92aWYgKnd2aWYp
CiB7Ci0JaW50IHJldCA9IDA7Ci0Jc3RydWN0IHNrX2J1ZmYgKnNrYiA9IE5VTEw7CisJc3RydWN0
IHNrX2J1ZmYgKnNrYjsKIAlzdHJ1Y3QgaWVlZTgwMjExX21nbXQgKm1nbXQ7Ci0Jc3RydWN0IGhp
Zl9taWJfdGVtcGxhdGVfZnJhbWUgKnA7CiAKIAlpZiAod3ZpZi0+dmlmLT50eXBlID09IE5MODAy
MTFfSUZUWVBFX1NUQVRJT04gfHwKIAkgICAgd3ZpZi0+dmlmLT50eXBlID09IE5MODAyMTFfSUZU
WVBFX01PTklUT1IgfHwKIAkgICAgd3ZpZi0+dmlmLT50eXBlID09IE5MODAyMTFfSUZUWVBFX1VO
U1BFQ0lGSUVEKQotCQlnb3RvIGRvbmU7CisJCXJldHVybiAwOwogCiAJc2tiID0gaWVlZTgwMjEx
X2JlYWNvbl9nZXQod3ZpZi0+d2Rldi0+aHcsIHd2aWYtPnZpZik7Ci0KIAlpZiAoIXNrYikKIAkJ
cmV0dXJuIC1FTk9NRU07CisJaGlmX3NldF90ZW1wbGF0ZV9mcmFtZSh3dmlmLCBza2IsIEhJRl9U
TVBMVF9CQ04sCisJCQkgICAgICAgQVBJX1JBVEVfSU5ERVhfQl8xTUJQUyk7CiAKLQlwID0gKHN0
cnVjdCBoaWZfbWliX3RlbXBsYXRlX2ZyYW1lICopIHNrYl9wdXNoKHNrYiwgNCk7Ci0JcC0+ZnJh
bWVfdHlwZSA9IEhJRl9UTVBMVF9CQ047Ci0JcC0+aW5pdF9yYXRlID0gQVBJX1JBVEVfSU5ERVhf
Ql8xTUJQUzsgLyogMU1icHMgRFNTUyAqLwotCXAtPmZyYW1lX2xlbmd0aCA9IGNwdV90b19sZTE2
KHNrYi0+bGVuIC0gNCk7Ci0KLQlyZXQgPSBoaWZfc2V0X3RlbXBsYXRlX2ZyYW1lKHd2aWYsIHAp
OwotCi0Jc2tiX3B1bGwoc2tiLCA0KTsKLQotCWlmIChyZXQpCi0JCWdvdG8gZG9uZTsKIAkvKiBU
T0RPOiBEaXN0aWxsIHByb2JlIHJlc3A7IHJlbW92ZSBUSU0gYW5kIGFueSBvdGhlciBiZWFjb24t
c3BlY2lmaWMKIAkgKiBJRXMKIAkgKi8KQEAgLTg2NCwxNCArODUyLDExIEBAIHN0YXRpYyBpbnQg
d2Z4X3VwbG9hZF9iZWFjb24oc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJbWdtdC0+ZnJhbWVfY29u
dHJvbCA9CiAJCWNwdV90b19sZTE2KElFRUU4MDIxMV9GVFlQRV9NR01UIHwgSUVFRTgwMjExX1NU
WVBFX1BST0JFX1JFU1ApOwogCi0JcC0+ZnJhbWVfdHlwZSA9IEhJRl9UTVBMVF9QUkJSRVM7Ci0K
LQlyZXQgPSBoaWZfc2V0X3RlbXBsYXRlX2ZyYW1lKHd2aWYsIHApOworCWhpZl9zZXRfdGVtcGxh
dGVfZnJhbWUod3ZpZiwgc2tiLCBISUZfVE1QTFRfUFJCUkVTLAorCQkJICAgICAgIEFQSV9SQVRF
X0lOREVYX0JfMU1CUFMpOwogCXdmeF9md2RfcHJvYmVfcmVxKHd2aWYsIGZhbHNlKTsKLQotZG9u
ZToKIAlkZXZfa2ZyZWVfc2tiKHNrYik7Ci0JcmV0dXJuIHJldDsKKwlyZXR1cm4gMDsKIH0KIAog
c3RhdGljIGludCB3ZnhfaXNfaHQoY29uc3Qgc3RydWN0IHdmeF9odF9pbmZvICpodF9pbmZvKQot
LSAKMi4yNC4wCgo=
