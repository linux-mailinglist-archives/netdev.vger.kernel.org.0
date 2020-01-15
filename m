Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 853C813C3F0
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbgAONze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:55:34 -0500
Received: from mail-dm6nam11on2065.outbound.protection.outlook.com ([40.107.223.65]:2785
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729927AbgAONzc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3Yoc5pYT6InGC8+HDB7Cp7UuEtaOoJt1AetRTV1SBAiLgVocV2BKdj1TwBFfStio68Lx6NthZuYrgQOFSfcvpIXnxiormLz9ezYO2tyxgahhSaIr+HFscvUchX9LV1L4tbJ7CtgHc0ytJd8h7bJSZ9eEraVyHxKDEB61XcUNu5v2t4PrCwTtlgOBGUCqkZDMdbfvn8e4CgRKX5BlZ38wBctj3rLSk9R1nC5+2tMDXKazwxuAR3efgZSxc43AgNLVK2U90s+9f+ap06nkCrv1gJJQivryuxf3fs0iA1e87TB00BtdbUSP+iJJj94em9mUmcz02953oK6pzJSIAvR5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGqfP+Bn6ViYrv+vCujkkmwbpYVEsmfRDXGsJC6g80s=;
 b=c05CqRLN2k1FnTeZJL1oPeG03RkMw/3HmfZYADIOMcdacPP3a1SARt6qdTx5kPGYP2fqemAhD3uHjHoayGw1PlqVyT3ZsMgCAUgVKEs4mBzfEVuGp2HkpXhacQwZwMU0kNWnNJdUX7BNgPFA+MZHkCv0ZOvR75RJDK9vnNUQlU2kMVGn1ZOofd/xhdgVkBMllb6NpvMjOkYggiHNW/LO9q/d1+mIC4iaxY/h+KlWMn4ZjNL3mPqV124uWKIV4umwz5BHU+hrf9JsXl6pIQzyLTDayntxcU1cHmmiG44HuQxfnHLDef9KKL3Lx9bv3AKdp5TWIYyxeaGBPV92HJjxrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGqfP+Bn6ViYrv+vCujkkmwbpYVEsmfRDXGsJC6g80s=;
 b=ceFBbE+jmg+qWScvb68pYdvdnTE8t3zzEAuMf9f+aNv8mVXDIXm8sZwjtKkAV/GTJJF3YRLySWSixPouHUMqnQ/mz+yRfW+vKF7ILiFWB0QYD06RzDhvuwmbrDa9zyMoDYxwrrAVzKKs5PDc7pu9EMyMcOrEB9NeAqpCaAVMQzE=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:55:22 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:22 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:55:01 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 41/65] staging: wfx: with multiple vifs, force PS only if
 channels differs
Thread-Topic: [PATCH v2 41/65] staging: wfx: with multiple vifs, force PS only
 if channels differs
Thread-Index: AQHVy6ti+r1iY3KgB0++XuI2+pquWg==
Date:   Wed, 15 Jan 2020 13:55:02 +0000
Message-ID: <20200115135338.14374-42-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 81e087c7-7c53-4262-ec38-08d799c28489
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4094011D695D79C94DB14E6A93370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(66574012)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bmjK5uaSF0tQDyleD7Y2y6T5PNClk5QvpN8mJSxC7yGYi2zVxy//AOmZnl2Xg9nHwKEdHhQwjxRKOU+RGsdIHzhktHOD1HhOXC0+X1Dg0hST2BwnkLyaF20t80ezqSsXisP5JNa3438g9v4dmTc54OLn1iM0Eul/zHYwaDi+inqz0oo8ULV7IPLgTeXVdaD/NOkK+P5qLNpNGCnjOk4eEsnaNq4jSwxFiXlgIldAJEx4vBx8T2pgETRJUzshfw4xr+PLg41WdSlzhG5s8I00N/P7DQQ+DnrR/+dir4SAH+NZJcSA64JgIqbduqnTes1bOq/m5iAfDHOfHQl/zGrLYFVuQPB2VGkJUlr6MhAPkIRMFgfIkrEPAdrHCuyU7fbBKiY4WUi9visSA4hNBoSAMT/7yuZSB2yTz9gVNkCO+T8XyFe9M4ZRCVPxy3ivU5V5
Content-Type: text/plain; charset="utf-8"
Content-ID: <69434A7882C2A0458D0B884283FA08DB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81e087c7-7c53-4262-ec38-08d799c28489
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:55:02.4440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kNK5plBj4Gzq8P6ar64rOsrT5/QUaynbPLecE8kaPEQJZVq9FDzyoeBPdsYPGmL6wAZmVr9eA7I5LU/5x9LNfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
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
