Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9DC1210B2
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfLPRFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:05:37 -0500
Received: from mail-eopbgr700045.outbound.protection.outlook.com ([40.107.70.45]:49121
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726931AbfLPRDv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:03:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JdtwqTRVAGqS1WlKfIodAykAmA8iRsDQxBRIL/AqERb09oGAtu+uqho0nTKUqCnMONHu4GirtKQoy22i65jJoGvZ6nqlvqKlCpWrgatRIcT0LCcAgTJTrpXvK/9RTg0FDZHE9ftXEzcEIek3Cbr1CssPdxAd6u2v2J5+34AtEZ0EHEIo/19BnkS1M+CX5BF/SkS63Ii+dLyftXRsWpneAkbv1tVc8GNDxfP0WHWoqK+I3+o/SQ9vwVAemgujjlZ76GgeN+bWYq6cI7k24++egLDvzbRVNgs+/V0z6cqNNaLmcrhumjGVNMR1ZMPdMRh1RUIY/fMtAehq1sy5Ci1UIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZm021/OuiiRkuw5MI4dTjoQN3+jOzXvYS77AFtcuFc=;
 b=Bk2QwlFMQ46MlQdB5N3vvkOf/GJp+s86+ROg7YSIquxZlsa6xTDcBNC8gnv7O27L9tqhv5OV6PBMVLCwF/f/5dnK0H9u+tEbg8WKWzRCDxBG2ffUSI0bppB5g9Kjz3Cg97gwO7j6c7AS0ZWXyXjR7jt6gqGr1wfbC3+gFHKCjEYb5Pz/r2HEbh5rEo54tJfQBkYDf3T46r5BBu5go49WYEJwBCCK9JmORgzTM6OCCtj+Sjo2Vp7sXayWVHdoPlCxoHcnfm/NQ1a3J3j2L560hG89UNDSCv0GwIHTyDof3IlzMua9h4x+kEYHobrv1ye42TozeBKtn6XcAwLLN6I0uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZm021/OuiiRkuw5MI4dTjoQN3+jOzXvYS77AFtcuFc=;
 b=ZULMbHuYNtVHCAd2McSmtz7VL3WAKAL5GI0y64E//DRvUe8cZbbzdbwmuJvCvcfvojAJSfO58GJwuAhjid3CIyDtD2CMJGXwOY5T5i4oLbkwnjwyu+Dd64F/hzKr4l6FsE/vTniVCwZN1mJhFE1USHh7Ft+5Qx5mmnO954l8Gmc=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4351.namprd11.prod.outlook.com (52.135.39.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Mon, 16 Dec 2019 17:03:47 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:03:47 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 12/55] staging: wfx: don't print useless error messages
Thread-Topic: [PATCH 12/55] staging: wfx: don't print useless error messages
Thread-Index: AQHVtDLDWbe5jwhX3Euocgmb2a3bIg==
Date:   Mon, 16 Dec 2019 17:03:40 +0000
Message-ID: <20191216170302.29543-13-Jerome.Pouiller@silabs.com>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 259754d3-3195-4395-4081-08d78249eabd
x-ms-traffictypediagnostic: MN2PR11MB4351:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4351B6AC2CA78D90F01DD25993510@MN2PR11MB4351.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(396003)(39860400002)(199004)(189003)(66556008)(66446008)(64756008)(66476007)(76116006)(85202003)(91956017)(66946007)(54906003)(107886003)(4326008)(478600001)(110136005)(71200400001)(6512007)(81156014)(8676002)(81166006)(186003)(36756003)(2906002)(85182001)(6666004)(66574012)(15650500001)(1076003)(316002)(6506007)(5660300002)(86362001)(26005)(2616005)(6486002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4351;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3rPcC2kLStzUws27as1SwYD9VMS0e7+h8bjkIv86fbR8xFQoVVKGJSNHmVzM0Cf7eN6s4sW7UKuAGmDcfAjH6KswqMx6qbQQ3vwaV9g0CULpNdGGIqZZWZNUC8Vuk5M2dcbHzB4FOR09ZyNx5LLD+wB9FpCfIvCXva7sSOB5J6MI/HBnRqpfKVXqpBvYNYn6eJ8JcLfprRW+ZVRoTLl8+M5fy+RhN4j0FOOtStX7v/ZVlX8cmBm6Ng96PFLrc2JxCfNFyl+s5cIAWYQcbXftFXMfC/pjnbkShvHcGHTdWZCbTumhihvxuqNkw9RSPdIwoMsLNxA0ii1eIQddE+5carlH6da2u6i6uV6hTo8O2vSmoWwTPjN5/3W1kAqMLArAz2JH8wt+JK7oqt/kyyEGU1EhUwCHI7MjtfLgDatcJhDBcPVJOxmNZ4fFMAjf3uUf
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0E5116976064D44B4BDAF4D04CE17C9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 259754d3-3195-4395-4081-08d78249eabd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:40.0204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SQWAY13n7PDhTOovxizbOaJ4SGHq1aXoHHzIIjAOryuLQNpTRW4dHnfB40jyHPC+xHC2XwVQXE5mH0lWy3Gf4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpE
dXJpbmcgY2hpcCBwcm9iaW5nLCBpZiBlcnJvciBkb2VzIG5vdCBjb21lIGZyb20gc2VjdXJlIGJv
b3QgKGZvcg0KZXhlbXBsZSB3aGVuIGZpcm13YXJlIGhhcyBiZWVuIGZvdW5kKSwgb3RoZXJzIGVy
cm9ycyBwcm9iYWJseSBhcHBlYXJzLg0KDQpJdCBpcyBub3QgbmVjZXNzYXJ5IHRvIHNheSB0byB1
c2VyIHRoYXQgdGhlIGVycm9yIGRvZXMgbm90IGNvbWUgZnJvbQ0Kc2VjdXJlIGJvb3QuIFNvLCBk
cm9wIHRoZSBtZXNzYWdlIHNheWluZyAibm8gZXJyb3IgcmVwb3J0ZWQgYnkgc2VjdXJlDQpib290
Ii4NCg0KQlRXLCB3ZSB0YWtlIHRoZSBvcHBvcnR1bml0eSB0byBzaW1wbGlmeSBwcmludF9ib290
X3N0YXR1cygpLg0KDQpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBv
dWlsbGVyQHNpbGFicy5jb20+DQotLS0NCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uYyB8IDI2
ICsrKysrKysrKystLS0tLS0tLS0tLS0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlv
bnMoKyksIDE2IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9md2lvLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uYw0KaW5kZXggZGJmOGJkYTcxZmY3
Li40N2U2MjdiZjBmOGUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uYw0K
KysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9md2lvLmMNCkBAIC02MSw3ICs2MSw3IEBADQogI2Rl
ZmluZSBEQ0FfVElNRU9VVCAgNTAgLy8gbWlsbGlzZWNvbmRzDQogI2RlZmluZSBXQUtFVVBfVElN
RU9VVCAyMDAgLy8gbWlsbGlzZWNvbmRzDQogDQotc3RhdGljIGNvbnN0IGNoYXIgKiBjb25zdCBm
d2lvX2Vycm9yX3N0cmluZ3NbXSA9IHsNCitzdGF0aWMgY29uc3QgY2hhciAqIGNvbnN0IGZ3aW9f
ZXJyb3JzW10gPSB7DQogCVtFUlJfSU5WQUxJRF9TRUNfVFlQRV0gPSAiSW52YWxpZCBzZWN0aW9u
IHR5cGUgb3Igd3JvbmcgZW5jcnlwdGlvbiIsDQogCVtFUlJfU0lHX1ZFUklGX0ZBSUxFRF0gPSAi
U2lnbmF0dXJlIHZlcmlmaWNhdGlvbiBmYWlsZWQiLA0KIAlbRVJSX0FFU19DVFJMX0tFWV0gPSAi
QUVTIGNvbnRyb2wga2V5IG5vdCBpbml0aWFsaXplZCIsDQpAQCAtMjIwLDIyICsyMjAsMTYgQEAg
c3RhdGljIGludCB1cGxvYWRfZmlybXdhcmUoc3RydWN0IHdmeF9kZXYgKndkZXYsIGNvbnN0IHU4
ICpkYXRhLCBzaXplX3QgbGVuKQ0KIA0KIHN0YXRpYyB2b2lkIHByaW50X2Jvb3Rfc3RhdHVzKHN0
cnVjdCB3ZnhfZGV2ICp3ZGV2KQ0KIHsNCi0JdTMyIHZhbDMyOw0KKwl1MzIgcmVnOw0KIA0KLQlz
cmFtX3JlZ19yZWFkKHdkZXYsIFdGWF9TVEFUVVNfSU5GTywgJnZhbDMyKTsNCi0JaWYgKHZhbDMy
ID09IDB4MTIzNDU2NzgpIHsNCi0JCWRldl9pbmZvKHdkZXYtPmRldiwgIm5vIGVycm9yIHJlcG9y
dGVkIGJ5IHNlY3VyZSBib290XG4iKTsNCi0JfSBlbHNlIHsNCi0JCXNyYW1fcmVnX3JlYWQod2Rl
diwgV0ZYX0VSUl9JTkZPLCAmdmFsMzIpOw0KLQkJaWYgKHZhbDMyIDwgQVJSQVlfU0laRShmd2lv
X2Vycm9yX3N0cmluZ3MpICYmDQotCQkgICAgZndpb19lcnJvcl9zdHJpbmdzW3ZhbDMyXSkNCi0J
CQlkZXZfaW5mbyh3ZGV2LT5kZXYsICJzZWN1cmUgYm9vdCBlcnJvcjogJXNcbiIsDQotCQkJCSBm
d2lvX2Vycm9yX3N0cmluZ3NbdmFsMzJdKTsNCi0JCWVsc2UNCi0JCQlkZXZfaW5mbyh3ZGV2LT5k
ZXYsDQotCQkJCSAic2VjdXJlIGJvb3QgZXJyb3I6IFVua25vd24gKDB4JTAyeClcbiIsDQotCQkJ
CSB2YWwzMik7DQotCX0NCisJc3JhbV9yZWdfcmVhZCh3ZGV2LCBXRlhfU1RBVFVTX0lORk8sICZy
ZWcpOw0KKwlpZiAocmVnID09IDB4MTIzNDU2NzgpDQorCQlyZXR1cm47DQorCXNyYW1fcmVnX3Jl
YWQod2RldiwgV0ZYX0VSUl9JTkZPLCAmcmVnKTsNCisJaWYgKHJlZyA8IEFSUkFZX1NJWkUoZndp
b19lcnJvcnMpICYmIGZ3aW9fZXJyb3JzW3JlZ10pDQorCQlkZXZfaW5mbyh3ZGV2LT5kZXYsICJz
ZWN1cmUgYm9vdDogJXNcbiIsIGZ3aW9fZXJyb3JzW3JlZ10pOw0KKwllbHNlDQorCQlkZXZfaW5m
byh3ZGV2LT5kZXYsICJzZWN1cmUgYm9vdDogRXJyb3IgJSMwMnhcbiIsIHJlZyk7DQogfQ0KIA0K
IHN0YXRpYyBpbnQgbG9hZF9maXJtd2FyZV9zZWN1cmUoc3RydWN0IHdmeF9kZXYgKndkZXYpDQot
LSANCjIuMjAuMQ0K
