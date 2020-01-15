Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4DF13C430
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbgAON4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:56:48 -0500
Received: from mail-eopbgr770085.outbound.protection.outlook.com ([40.107.77.85]:39089
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730364AbgAON4o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:56:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNm1BBELvuNsVLdXyoA2aXFSVBDnRpZmT5ui+UEEsZTCeDe1PdCvFRcOktH+5iNlYsCk3Wy/kFqUczNTcYl4KBYXLkzLCxHQFW7osnLK0/MW2IDFmCbdiuTpCx8h8yueP0s5ICqoq1+GaYvY3D/VSYi59dKsFbxZpxIndOw6lJw+H+y313btoGaG+rG2maMU+VGCnUtCHNMF9kNhAhKoM0vHcDtbRq0gaTGTCV11twgWgY3YvcQBcNEfwic+Rn79v13Nr9bqtNDmBu2w7K1WEzdqA6tt+JhTNtNu8uE/rEzCL54RQOPJ+GS1mwyX8rP1mvNqC9TwgQbS6FZs2jj3tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ro9I2rSIp0iul/hKKxPII0gO0+PaKdaAxCdGr0ktzNc=;
 b=dHh97vpsjApJ3e070TGVuAIarzks6NFpFzFNXDcpnMpw3uvhH+TqYOaYHmVAeRO8EvpU//8bqw6mAUSuDW4EE3S57iGOUXDCIaysIPbgb5YIKargLt5c0WXJ9ihSLk2ShgJmeTPLWrvwLogVNYomY5ehWFyKocqff0ftBI0rNPA1mqSvsm/cDmslpb2cFipslJLfrMLIPEizLeQAWciHIbMilRJxLS6DxtjLSeToS0L5DxMZGyWOWwnBuhv4K0diNnIJSU7cFz1Ebd9PQIYWkZFgCDYBp6Wask04loUKUrfJ/AgfHVTYaXyj6Viptls31CEM0GySk4A0/2g9k7P86g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ro9I2rSIp0iul/hKKxPII0gO0+PaKdaAxCdGr0ktzNc=;
 b=Z09up+tMnLty2rxdXcN80lJQr4shv5s3tP2UeVj75FwFVM9OaQ/RdzOMZRKCDQmAlq2Sk3HShhv/Ud4L7PSMc8/LShW0/ezer5Rdouh0mpVp8+9P/fa0FR8hdnHl5c16ymahtCvx8hFpT6ZMNi+rf2a2LsfX+7H2XjJzdFqiWF4=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:56:04 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:56:04 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:55:34 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 63/65] staging: wfx: simplify wfx_tx_queue_get_num_queued()
Thread-Topic: [PATCH v2 63/65] staging: wfx: simplify
 wfx_tx_queue_get_num_queued()
Thread-Index: AQHVy6t1PPmnEE1x50GLb9uE8oi/Yg==
Date:   Wed, 15 Jan 2020 13:55:35 +0000
Message-ID: <20200115135338.14374-64-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 307eabdb-5377-470b-1438-08d799c2985a
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB366115B458AD21512A6FE67593370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ljB7x66vmeW27kItOGJAseYpfeJk7XiV9tT317bKvBCLkIm9/LRf7gg81Au88pdNj/PBmbtrSaweh35/vInNIUM5FAnnyHfhqC7bAnuB/02FgsA8f7TEn+XJA3Z8Hk+ZnGOrgCHsEYyslCbKjv5ibLTnJIQOwLjZHBxgv0UhaN+p81Mid4lG5gkePt5U3KatUPtrY08wV5hd76QYnlIDj0kbprE9U0y6htfuhFX+BqgFoudiIwf5HY9e4xzxUIVIkyxywIahAZoOy2YG9PIsXdmN45jPX+6lO6h0apSpa34K7LSRMFzKBTB6OcFFpBaIavZDz0+J6WgXHqx50hVuBrRRiRmgktBog9hurXF8HWpYqJJ05CbMNDMt5nRYtDHpd9ncmlWThZPsZ+s8+Ro5Nkk4+jcTSXkMfTO7RYDULdEewNo2FiObmCBCH++b9ovA
Content-Type: text/plain; charset="utf-8"
Content-ID: <D77767DDD5D74845A897AC2CC97059FF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 307eabdb-5377-470b-1438-08d799c2985a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:55:35.6848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EyCR1W6kuKpqcgsgGLYX82BQRgEIRlLeQXus+EWEZ0nFHDkFiDKaSXOjrFxev0/h/9VRfFxbjrEef7yc1XZk5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3R4X3F1ZXVlX2dldF9udW1fcXVldWVkKCkgY2FuIHRha2UgYWR2YW50YWdlIG9mIEJJVCgpIGlu
c3RlYWQgb2YKbWFpbnRhaW5pbmcgb25lIHZhcmlhYmxlIGZvciBhIGNvdW50ZXIgYW5kIGFub3Ro
ZXIgZm9yIGEgbWFzay4KCkluIGFkZCwgd2Z4X3R4X3F1ZXVlX2dldF9udW1fcXVldWVkKCkgaGFz
IG5vIHJlYWwgcmVhc29uIHRvIHJldHVybiBhCnNpemVfdCBpbnN0ZWFkIG9mIGFuIGludC4KClNp
Z25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNv
bT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMgfCAxNCArKysrKy0tLS0tLS0tLQog
ZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oIHwgIDIgKy0KIDIgZmlsZXMgY2hhbmdlZCwgNiBp
bnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3F1ZXVlLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKaW5kZXggMDI0NDk3
ZWIxOWFjLi4wYmNjNjFmZWVlMWQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVl
dWUuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKQEAgLTE3NSwxMSArMTc1LDkg
QEAgdm9pZCB3ZnhfdHhfcXVldWVzX2RlaW5pdChzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIAl3Znhf
dHhfcXVldWVzX2NsZWFyKHdkZXYpOwogfQogCi1zaXplX3Qgd2Z4X3R4X3F1ZXVlX2dldF9udW1f
cXVldWVkKHN0cnVjdCB3ZnhfcXVldWUgKnF1ZXVlLAotCQkJCSAgIHUzMiBsaW5rX2lkX21hcCkK
K2ludCB3ZnhfdHhfcXVldWVfZ2V0X251bV9xdWV1ZWQoc3RydWN0IHdmeF9xdWV1ZSAqcXVldWUs
IHUzMiBsaW5rX2lkX21hcCkKIHsKLQlzaXplX3QgcmV0OwotCWludCBpLCBiaXQ7CisJaW50IHJl
dCwgaTsKIAogCWlmICghbGlua19pZF9tYXApCiAJCXJldHVybiAwOwpAQCAtMTg5LDExICsxODcs
OSBAQCBzaXplX3Qgd2Z4X3R4X3F1ZXVlX2dldF9udW1fcXVldWVkKHN0cnVjdCB3ZnhfcXVldWUg
KnF1ZXVlLAogCQlyZXQgPSBza2JfcXVldWVfbGVuKCZxdWV1ZS0+cXVldWUpOwogCX0gZWxzZSB7
CiAJCXJldCA9IDA7Ci0JCWZvciAoaSA9IDAsIGJpdCA9IDE7IGkgPCBBUlJBWV9TSVpFKHF1ZXVl
LT5saW5rX21hcF9jYWNoZSk7Ci0JCSAgICAgKytpLCBiaXQgPDw9IDEpIHsKLQkJCWlmIChsaW5r
X2lkX21hcCAmIGJpdCkKKwkJZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUocXVldWUtPmxpbmtf
bWFwX2NhY2hlKTsgaSsrKQorCQkJaWYgKGxpbmtfaWRfbWFwICYgQklUKGkpKQogCQkJCXJldCAr
PSBxdWV1ZS0+bGlua19tYXBfY2FjaGVbaV07Ci0JCX0KIAl9CiAJc3Bpbl91bmxvY2tfYmgoJnF1
ZXVlLT5xdWV1ZS5sb2NrKTsKIAlyZXR1cm4gcmV0OwpAQCAtNTU1LDcgKzU1MSw3IEBAIHN0cnVj
dCBoaWZfbXNnICp3ZnhfdHhfcXVldWVzX2dldChzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIAogCQkv
KiBhbGxvdyBidXJzdGluZyBpZiB0eG9wIGlzIHNldCAqLwogCQlpZiAod3ZpZi0+ZWRjYV9wYXJh
bXNbcXVldWVfbnVtXS50eG9wKQotCQkJYnVyc3QgPSAoaW50KXdmeF90eF9xdWV1ZV9nZXRfbnVt
X3F1ZXVlZChxdWV1ZSwgdHhfYWxsb3dlZF9tYXNrKSArIDE7CisJCQlidXJzdCA9IHdmeF90eF9x
dWV1ZV9nZXRfbnVtX3F1ZXVlZChxdWV1ZSwgdHhfYWxsb3dlZF9tYXNrKSArIDE7CiAJCWVsc2UK
IAkJCWJ1cnN0ID0gMTsKIApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5o
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oCmluZGV4IDA5NmFlODYxMzVjYy4uOTBiYjA2
MGQxMjA0IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmgKKysrIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oCkBAIC01MSw3ICs1MSw3IEBAIHN0cnVjdCBoaWZfbXNn
ICp3ZnhfdHhfcXVldWVzX2dldF9hZnRlcl9kdGltKHN0cnVjdCB3ZnhfdmlmICp3dmlmKTsKIAog
dm9pZCB3ZnhfdHhfcXVldWVfcHV0KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBzdHJ1Y3Qgd2Z4X3F1
ZXVlICpxdWV1ZSwKIAkJICAgICAgc3RydWN0IHNrX2J1ZmYgKnNrYik7Ci1zaXplX3Qgd2Z4X3R4
X3F1ZXVlX2dldF9udW1fcXVldWVkKHN0cnVjdCB3ZnhfcXVldWUgKnF1ZXVlLCB1MzIgbGlua19p
ZF9tYXApOworaW50IHdmeF90eF9xdWV1ZV9nZXRfbnVtX3F1ZXVlZChzdHJ1Y3Qgd2Z4X3F1ZXVl
ICpxdWV1ZSwgdTMyIGxpbmtfaWRfbWFwKTsKIAogc3RydWN0IHNrX2J1ZmYgKndmeF9wZW5kaW5n
X2dldChzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgdTMyIHBhY2tldF9pZCk7CiBpbnQgd2Z4X3BlbmRp
bmdfcmVtb3ZlKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKTsKLS0g
CjIuMjUuMAoK
