Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 238EB13BF73
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731586AbgAOMNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:13:39 -0500
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:33252
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731359AbgAOMNf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+iZ1MI26p4qjhTv1/zcjmE2mz+aqLiukqIROtqj8B92PRRVM6JW+Mriogr1wh/MV8Lq1Rj2mmeURKfYOxtenLiV+xJPHWcEWFRZoKwdDjzW6o6qTJlffAE8sbyaC01z/CwizA+Pb4XgE7GIXWTyMcIrNiRjC8L5I58yaG3GAggjg/ZBuGxHF59RcLRXvvt3CttE8XuuRQzV2zlMgNDCTkpk/VTT5fIGJrsrrsQ/uQW2eGsi3AiuA0vwsY0W5C2TDXLuXgYLW5srw0IIESCUHPi+q4rN3uYIf/p4FI5NfpXGcyG0w8uRT9/04wAt2vJ0qMHpDr/TXi5rnFdIbExD1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGqfP+Bn6ViYrv+vCujkkmwbpYVEsmfRDXGsJC6g80s=;
 b=jhQNvJ+96i44rxygzyKYXtcEPaQYFOuyvQT2+ThDBwZY3a3CO2wy72iFmMjD2SUKSw7Iy1KDFEIwdkICHxe/cPNqGBxyAJzTPa1xbT1f0TnWLhtlAbXiPGzZWkw3mT+Bicl3VrXx/iGWtnbE3NffzNktiWqkI8God1f9OL1w5LylxTHvwFE4IVdQTdxH+e0n4Itfsyc6YyyVbiwH1P3H+Ecpq0YfSMA/ybeL8qQurXWV4ZIJgTueacJ2ZJqsljGseWpSYoOE+BRVFkgau3F1NiW+woFvmJAdXqS23rSXf7ZMvgwr462kIY1FcnbFvqGm2oTAdh9Lp1cyV7C+cnZ7Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGqfP+Bn6ViYrv+vCujkkmwbpYVEsmfRDXGsJC6g80s=;
 b=d1mjQDjHMYXW7pseOcQ+a7GRwJht/toJs/c6kAVkm5zRJ6JZdD/ICJOAELxIoCgNheDYBxp1IJVhzp2tpsZu3MB2OSPWCHAld7/05RR6cHnIHaBbTZf9XK7mMHfc/OCNwTj/jjI1KJtjs/swR8GITFrQ0LBe8BuMI6LnKUWMOko=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:13:26 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:26 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:02 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 41/65] staging: wfx: with multiple vifs, force PS only if
 channels differs
Thread-Topic: [PATCH 41/65] staging: wfx: with multiple vifs, force PS only if
 channels differs
Thread-Index: AQHVy50jNHs/r+2QPUSLTwTNLpC5mA==
Date:   Wed, 15 Jan 2020 12:13:03 +0000
Message-ID: <20200115121041.10863-42-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 8f87840e-eda5-4757-a2be-08d799b44574
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB39345A9619493FB54E5BC51793370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DDakmXH9HhhdCt4K6Y0uD57zaegbJdSUnmCu8IgGIjYIqloSyJO1mOrB93LhdIOcZ9U2S50gy3vilq+aQG6oPodlroTCM/k/N/MCkGUqkT0l05bM8JdPHRbaITOnVDbgoSQL2J1dSfC0TgmX2fMc0xUjwxd8LOowqrhUNxJCXmvbjKfNxUg0wfejWnm/kxEmjLpQl0k7hnP4vfj70WsaDxvV5/qQT+I/ph5ERYcgSiG8B748gK6dh0bBgoK4PvqdI/AzWS8ZoYgKv67V/O9sThtg3/zFjRa7zzzlSfkSwVmlAGqT3y2zVr077OcRrgGLVOouzQpH37x5FLeZFLBY8EYF+vE/x26BjRFs+iTH3ycOssJQXYe+rf3PTNlqEuyFMct7DNbgAVMtyB2cQP9Qw7Z/E3JKAbqhJPg8ssc2mDB/r8JXfmndeEEbwXEvlbep
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E7C9B63822EC1499DA40A00A13065EB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f87840e-eda5-4757-a2be-08d799b44574
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:03.6438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wDx2GrZZ7d3dhVFnhU2xCKciA6P/K8brO5Gtdgi3tpzZqqjBU2BiILCIKNRZRnlmf91MsaZZTYg4maMZCvRYrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biBtdWx0aXBsZSB2aWYgYXJlIGluIHVzZSAodGhlIG9ubHkgc3VwcG9ydGVkIGNvbmZpZ3VyYXRp
b24gaXMgb25lCnN0YXRpb24gYW5kIG9uZSBBUCksIHRoZSBkcml2ZXIgZm9yY2UgcG93ZXIgc2F2
ZSBmbGFnIG9uIHN0YXRpb24uClRoaXMgYmVoYXZpb3IgYWxsb3dzIHRoZSBzdGF0aW9uIHRvIGxl
YXZlIHRoZSBzdGF0aW9uIGNoYW5uZWwgYW5kIG1ha2UKaXRzIGJ1c2luZXNzIG9uIEFQIGNoYW5u
ZWwuCgpIb3dldmVyLCB0aGlzIGhhcyBhIGJpZyBpbXBhY3Qgb24gc3RhdGlvbiBwZXJmb3JtYW5j
ZXMgKGVzcGVjaWFsbHkgc2luY2UKb25seSBsZWdhY3kgUFMgaXMgc3VwcG9ydGVkKS4KCldoZW4g
Ym90aCB2aWZzIHVzZSB0aGUgc2FtZSBjaGFubmVsLCBpdCBpcyBub3QgbmVjZXNzYXJ5IHRvIGtl
ZXAgdGhpcwpyZXN0cmljdGlvbi4gVGhpcyBncmVhdGx5IGltcHJvdmUgc3RhdGlvbiBwZXJmb3Jt
YW5jZXMuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVy
QHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyB8IDE0ICsrKysrKysr
KystLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9zdGEuYwppbmRleCA5NDY4M2ExNDQwYzguLmJmMjg1Mzg5YzMwMyAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
CkBAIC0yNTEsNiArMjUxLDcgQEAgc3RhdGljIGludCB3ZnhfdXBkYXRlX3BtKHN0cnVjdCB3Znhf
dmlmICp3dmlmKQogCXN0cnVjdCBpZWVlODAyMTFfY29uZiAqY29uZiA9ICZ3dmlmLT53ZGV2LT5o
dy0+Y29uZjsKIAlib29sIHBzID0gY29uZi0+ZmxhZ3MgJiBJRUVFODAyMTFfQ09ORl9QUzsKIAlp
bnQgcHNfdGltZW91dCA9IGNvbmYtPmR5bmFtaWNfcHNfdGltZW91dDsKKwlzdHJ1Y3QgaWVlZTgw
MjExX2NoYW5uZWwgKmNoYW4wID0gTlVMTCwgKmNoYW4xID0gTlVMTDsKIAogCVdBUk5fT04oY29u
Zi0+ZHluYW1pY19wc190aW1lb3V0IDwgMCk7CiAJaWYgKHd2aWYtPnN0YXRlICE9IFdGWF9TVEFU
RV9TVEEgfHwgIXd2aWYtPmJzc19wYXJhbXMuYWlkKQpAQCAtMjYwLDEwICsyNjEsMTUgQEAgc3Rh
dGljIGludCB3ZnhfdXBkYXRlX3BtKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogCWlmICh3dmlmLT51
YXBzZF9tYXNrKQogCQlwc190aW1lb3V0ID0gMDsKIAotCS8vIEtlcm5lbCBkaXNhYmxlIFBvd2Vy
U2F2ZSB3aGVuIG11bHRpcGxlIHZpZnMgYXJlIGluIHVzZS4gSW4gY29udHJhcnksCi0JLy8gaXQg
aXMgYWJzb2x1dGx5IG5lY2Vzc2FyeSB0byBlbmFibGUgUG93ZXJTYXZlIGZvciBXRjIwMAotCS8v
IEZJWE1FOiBvbmx5IGlmIGNoYW5uZWwgdmlmMCAhPSBjaGFubmVsIHZpZjEKLQlpZiAod3ZpZl9j
b3VudCh3dmlmLT53ZGV2KSA+IDEpIHsKKwkvLyBLZXJuZWwgZGlzYWJsZSBwb3dlcnNhdmUgd2hl
biBhbiBBUCBpcyBpbiB1c2UuIEluIGNvbnRyYXJ5LCBpdCBpcworCS8vIGFic29sdXRlbHkgbmVj
ZXNzYXJ5IHRvIGVuYWJsZSBsZWdhY3kgcG93ZXJzYXZlIGZvciBXRjIwMCBpZiBjaGFubmVscwor
CS8vIGFyZSBkaWZmZXJlbnRzLgorCWlmICh3ZGV2X3RvX3d2aWYod3ZpZi0+d2RldiwgMCkpCisJ
CWNoYW4wID0gd2Rldl90b193dmlmKHd2aWYtPndkZXYsIDApLT52aWYtPmJzc19jb25mLmNoYW5k
ZWYuY2hhbjsKKwlpZiAod2Rldl90b193dmlmKHd2aWYtPndkZXYsIDEpKQorCQljaGFuMSA9IHdk
ZXZfdG9fd3ZpZih3dmlmLT53ZGV2LCAxKS0+dmlmLT5ic3NfY29uZi5jaGFuZGVmLmNoYW47CisJ
aWYgKGNoYW4wICYmIGNoYW4xICYmIGNoYW4wLT5od192YWx1ZSAhPSBjaGFuMS0+aHdfdmFsdWUg
JiYKKwkgICAgd3ZpZi0+dmlmLT50eXBlICE9IE5MODAyMTFfSUZUWVBFX0FQKSB7CiAJCXBzID0g
dHJ1ZTsKIAkJcHNfdGltZW91dCA9IDA7CiAJfQotLSAKMi4yNS4wCgo=
