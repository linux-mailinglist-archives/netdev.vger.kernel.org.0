Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC571231D2
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbfLQQRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:17:50 -0500
Received: from mail-bn8nam11on2041.outbound.protection.outlook.com ([40.107.236.41]:6164
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729026AbfLQQPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJNKjo8XtLM1Y3d2NxLd1GUvKr75bruHvRtQaDw/rHO0WjdkzQboX/1w8amjX9VVtLnqjVN5CMsRkYNxyuVsZ68rpwxIyvE8m1gRbPegijAd+rm6y4mn8niNviL8vjhIvtskslvfpWjatWhWqKbFGNWGW6+/T1DMYSM+ZFnGTn+bqYJzsXAqVBWZ/iw+xbkumRrbjm/EtzzAx8KQIUo3CFkkFA90QiJ7Lc8onTZCOaXVR3Llth00fpwIBInd/wwGFQEbOTkifiaedOe7e0MZikiwM0pteZINa9NSOb1VWLeR8oGh3cJcv3oAWidOKo+gX5/b0aZ8Ig4bdZ0TajZckg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78O391xvezVfVShOvr/3rZg1ZEK/46UR+LHZdfYcB/k=;
 b=crWZO6iAfT6RqqmPbjqfx4Ce+WGlI16Ox5UUlKnICBOfftMiniU3DELNSK/zzxJmPW31qGUgtY8Q8p5Hk09huYhzldJUkVLb5j6pmKaIiWt4NWwd+ZYdUTWmahz5vPkPcQ6uNsKyRblfUBlb+XD7ckjw+kWAALwZ2hHtMtuiG8NZbkdkv9m58s0DfhvsxvQERF32aPOzq4RD7+Yja6P5xBeEPZzU7/A/iXHTJYKWFPlKA7RkCnPUzijW3zfvHZRwHKWL5nhSlw+GevFqTnaUTSBN2kCLxHsmAzoI1j3b4Waq+gwRgLw8l+c+VPTSpopRmDyOxOHc1Q+D+A4lPCozlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78O391xvezVfVShOvr/3rZg1ZEK/46UR+LHZdfYcB/k=;
 b=ivxTa0FQxERuu4sd1q1cLVZNHNijGaHuegUjP3UoEEbZIxWyT0TcRBcCQXTDqmYYXPjhAlGD7EpfFRWAEY9X6QmZjsZBoVsGR3D8iuKqCggnWegXJaoHWhfz7bqofDnNpON2MJw2vu3bJq88CNnc2bH2utoeKZg+64aZjEMdd+U=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4208.namprd11.prod.outlook.com (52.135.36.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 16:15:45 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:45 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 41/55] staging: wfx: drop struct wfx_edca_params
Thread-Topic: [PATCH v2 41/55] staging: wfx: drop struct wfx_edca_params
Thread-Index: AQHVtPUwWk98GQmzz0KLSnhUUoS1sQ==
Date:   Tue, 17 Dec 2019 16:15:24 +0000
Message-ID: <20191217161318.31402-42-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: e3bd905e-8e42-4130-cce2-08d7830c5273
x-ms-traffictypediagnostic: MN2PR11MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4208EE367C30C93B6EC3A62793500@MN2PR11MB4208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(5660300002)(316002)(6506007)(85182001)(478600001)(71200400001)(2906002)(36756003)(186003)(26005)(81166006)(54906003)(1076003)(110136005)(66574012)(4326008)(8676002)(86362001)(6486002)(6666004)(52116002)(6512007)(64756008)(85202003)(66946007)(66476007)(66446008)(66556008)(8936002)(107886003)(2616005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4208;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: twcIQ2aNkEgCH5ECsCruoMffLR5NgJqlhImVa7+5P9z74eCbBgRvCLhuB2n3sZ6D52Dtt3Ff0dgr+WS3kk1+NVZKEgx5rENiVshqry89Jcl+qvlpO0CFY70jAe7+d6FuMOuhKhcrEA1xoUjr9zRXtPuJR9aptIyW7xqy8DYKP1tXSsMdhyrHIGwpyNEStccKj/lqzZJE1cNd5AI/ttdA5qBfJVb4kegw+13YLNkv0Lh2p5i6eiD5IjUC4EE3/YTUBI0T4fI7RcVieaXqxdYjTE4T3sSHRuL5enKeuVqJQke4gpXSo7tmKBVs9OfXW0Zr8S7KMsgzMQSN/q3rrKCbdP1mMK73ziRPscsAPKR99oRiR1NCM/YnxF6Oab3omGO9ZWtb0YsjoYcTg1c1DSL+VlLQ6sBHj/x+CAJqRXt1zbpWPw27p0VuKA0+qVNY324h
Content-Type: text/plain; charset="utf-8"
Content-ID: <775F3C3EFA365240BDD3943E1FB4745D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3bd905e-8e42-4130-cce2-08d7830c5273
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:24.3910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xD5FiOFuvaTSSgxvzPYyI5RXNnhsmdIgL/V2N17oILzLu0Oh+lA1nfgERXrECKvTtCJStaH8GXMftqGROsafUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW50
ZXJtZWRpYXRlIHN0cnVjdHVyZSB3ZnhfZWRjYV9wYXJhbXMgZG9lcyBub3QgaGVscC4gVGhpcyBw
YXRjaApyZWxvY2F0ZXMgaXRzIG1lbWJlcnMgZGlyZWN0bHkgaW4gc3RydWN0IHdmeF92aWYuCgpT
aWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5j
b20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jIHwgIDQgKystLQogZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYyAgIHwgMTggKysrKysrKysrLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L3N0YS5oICAgfCAgNiAtLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggICB8
ICAzICsrLQogNCBmaWxlcyBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCAxOCBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3F1ZXVlLmMKaW5kZXggNjgwZmVkMzFjZWZiLi4xNjIxNmFmZTZjZmMgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYworKysgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3F1ZXVlLmMKQEAgLTQ1Miw3ICs0NTIsNyBAQCBzdGF0aWMgaW50IHdmeF9nZXRfcHJpb19x
dWV1ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAlmb3IgKGkgPSAwOyBpIDwgSUVFRTgwMjExX05V
TV9BQ1M7ICsraSkgewogCQlpbnQgcXVldWVkOwogCi0JCWVkY2EgPSAmd3ZpZi0+ZWRjYS5wYXJh
bXNbaV07CisJCWVkY2EgPSAmd3ZpZi0+ZWRjYV9wYXJhbXNbaV07CiAJCXF1ZXVlZCA9IHdmeF90
eF9xdWV1ZV9nZXRfbnVtX3F1ZXVlZCgmd3ZpZi0+d2Rldi0+dHhfcXVldWVbaV0sCiAJCQkJdHhf
YWxsb3dlZF9tYXNrKTsKIAkJaWYgKCFxdWV1ZWQpCkBAIC01OTUsNyArNTk1LDcgQEAgc3RydWN0
IGhpZl9tc2cgKndmeF90eF9xdWV1ZXNfZ2V0KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogCQl3dmlm
LT5wc3BvbGxfbWFzayAmPSB+QklUKHR4X3ByaXYtPnJhd19saW5rX2lkKTsKIAogCQkvKiBhbGxv
dyBidXJzdGluZyBpZiB0eG9wIGlzIHNldCAqLwotCQlpZiAod3ZpZi0+ZWRjYS5wYXJhbXNbcXVl
dWVfbnVtXS50eF9vcF9saW1pdCkKKwkJaWYgKHd2aWYtPmVkY2FfcGFyYW1zW3F1ZXVlX251bV0u
dHhfb3BfbGltaXQpCiAJCQlidXJzdCA9IChpbnQpd2Z4X3R4X3F1ZXVlX2dldF9udW1fcXVldWVk
KHF1ZXVlLCB0eF9hbGxvd2VkX21hc2spICsgMTsKIAkJZWxzZQogCQkJYnVyc3QgPSAxOwpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMKaW5kZXggYjQwMDdhZmNkMGM2Li5kNTJmNjE4MDYyYTYgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAt
Mjk5LDcgKzI5OSw3IEBAIHN0YXRpYyBpbnQgd2Z4X3VwZGF0ZV9wbShzdHJ1Y3Qgd2Z4X3ZpZiAq
d3ZpZikKIAkJcmV0dXJuIDA7CiAJaWYgKCFwcykKIAkJcHNfdGltZW91dCA9IDA7Ci0JaWYgKHd2
aWYtPmVkY2EudWFwc2RfbWFzaykKKwlpZiAod3ZpZi0+dWFwc2RfbWFzaykKIAkJcHNfdGltZW91
dCA9IDA7CiAKIAkvLyBLZXJuZWwgZGlzYWJsZSBQb3dlclNhdmUgd2hlbiBtdWx0aXBsZSB2aWZz
IGFyZSBpbiB1c2UuIEluIGNvbnRyYXJ5LApAQCAtMzI3LDggKzMyNyw4IEBAIGludCB3ZnhfY29u
Zl90eChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwK
IAlXQVJOX09OKHF1ZXVlID49IGh3LT5xdWV1ZXMpOwogCiAJbXV0ZXhfbG9jaygmd2Rldi0+Y29u
Zl9tdXRleCk7Ci0JYXNzaWduX2JpdChxdWV1ZSwgJnd2aWYtPmVkY2EudWFwc2RfbWFzaywgcGFy
YW1zLT51YXBzZCk7Ci0JZWRjYSA9ICZ3dmlmLT5lZGNhLnBhcmFtc1txdWV1ZV07CisJYXNzaWdu
X2JpdChxdWV1ZSwgJnd2aWYtPnVhcHNkX21hc2ssIHBhcmFtcy0+dWFwc2QpOworCWVkY2EgPSAm
d3ZpZi0+ZWRjYV9wYXJhbXNbcXVldWVdOwogCWVkY2EtPmFpZnNuID0gcGFyYW1zLT5haWZzOwog
CWVkY2EtPmN3X21pbiA9IHBhcmFtcy0+Y3dfbWluOwogCWVkY2EtPmN3X21heCA9IHBhcmFtcy0+
Y3dfbWF4OwpAQCAtMzM3LDcgKzMzNyw3IEBAIGludCB3ZnhfY29uZl90eChzdHJ1Y3QgaWVlZTgw
MjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAloaWZfc2V0X2VkY2FfcXVl
dWVfcGFyYW1zKHd2aWYsIGVkY2EpOwogCiAJaWYgKHd2aWYtPnZpZi0+dHlwZSA9PSBOTDgwMjEx
X0lGVFlQRV9TVEFUSU9OKSB7Ci0JCWhpZl9zZXRfdWFwc2RfaW5mbyh3dmlmLCB3dmlmLT5lZGNh
LnVhcHNkX21hc2spOworCQloaWZfc2V0X3VhcHNkX2luZm8od3ZpZiwgd3ZpZi0+dWFwc2RfbWFz
ayk7CiAJCWlmICh3dmlmLT5zZXRic3NwYXJhbXNfZG9uZSAmJiB3dmlmLT5zdGF0ZSA9PSBXRlhf
U1RBVEVfU1RBKQogCQkJd2Z4X3VwZGF0ZV9wbSh3dmlmKTsKIAl9CkBAIC0xNDI2LDcgKzE0MjYs
NyBAQCBpbnQgd2Z4X2FkZF9pbnRlcmZhY2Uoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVj
dCBpZWVlODAyMTFfdmlmICp2aWYpCiAJCX0sCiAJfTsKIAotCUJVSUxEX0JVR19PTihBUlJBWV9T
SVpFKGRlZmF1bHRfZWRjYV9wYXJhbXMpICE9IEFSUkFZX1NJWkUod3ZpZi0+ZWRjYS5wYXJhbXMp
KTsKKwlCVUlMRF9CVUdfT04oQVJSQVlfU0laRShkZWZhdWx0X2VkY2FfcGFyYW1zKSAhPSBBUlJB
WV9TSVpFKHd2aWYtPmVkY2FfcGFyYW1zKSk7CiAJaWYgKHdmeF9hcGlfb2xkZXJfdGhhbih3ZGV2
LCAyLCAwKSkgewogCQlkZWZhdWx0X2VkY2FfcGFyYW1zW0lFRUU4MDIxMV9BQ19CRV0ucXVldWVf
aWQgPSBISUZfUVVFVUVfSURfQkFDS0dST1VORDsKIAkJZGVmYXVsdF9lZGNhX3BhcmFtc1tJRUVF
ODAyMTFfQUNfQktdLnF1ZXVlX2lkID0gSElGX1FVRVVFX0lEX0JFU1RFRkZPUlQ7CkBAIC0xNTAy
LDEyICsxNTAyLDEyIEBAIGludCB3ZnhfYWRkX2ludGVyZmFjZShzdHJ1Y3QgaWVlZTgwMjExX2h3
ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikKIAogCWhpZl9zZXRfbWFjYWRkcih3dmlm
LCB2aWYtPmFkZHIpOwogCWZvciAoaSA9IDA7IGkgPCBJRUVFODAyMTFfTlVNX0FDUzsgaSsrKSB7
Ci0JCW1lbWNweSgmd3ZpZi0+ZWRjYS5wYXJhbXNbaV0sICZkZWZhdWx0X2VkY2FfcGFyYW1zW2ld
LAorCQltZW1jcHkoJnd2aWYtPmVkY2FfcGFyYW1zW2ldLCAmZGVmYXVsdF9lZGNhX3BhcmFtc1tp
XSwKIAkJICAgICAgIHNpemVvZihkZWZhdWx0X2VkY2FfcGFyYW1zW2ldKSk7Ci0JCWhpZl9zZXRf
ZWRjYV9xdWV1ZV9wYXJhbXMod3ZpZiwgJnd2aWYtPmVkY2EucGFyYW1zW2ldKTsKKwkJaGlmX3Nl
dF9lZGNhX3F1ZXVlX3BhcmFtcyh3dmlmLCAmd3ZpZi0+ZWRjYV9wYXJhbXNbaV0pOwogCX0KLQl3
dmlmLT5lZGNhLnVhcHNkX21hc2sgPSAwOwotCWhpZl9zZXRfdWFwc2RfaW5mbyh3dmlmLCB3dmlm
LT5lZGNhLnVhcHNkX21hc2spOworCXd2aWYtPnVhcHNkX21hc2sgPSAwOworCWhpZl9zZXRfdWFw
c2RfaW5mbyh3dmlmLCB3dmlmLT51YXBzZF9tYXNrKTsKIAogCXdmeF90eF9wb2xpY3lfaW5pdCh3
dmlmKTsKIAl3dmlmID0gTlVMTDsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oCmluZGV4IDc0NzU1ZjZmYTAzMC4uOTU5NWUx
ZmM2MGRiIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oCisrKyBiL2RyaXZl
cnMvc3RhZ2luZy93Zngvc3RhLmgKQEAgLTM0LDEyICszNCw2IEBAIHN0cnVjdCB3ZnhfaGlmX2V2
ZW50IHsKIAlzdHJ1Y3QgaGlmX2luZF9ldmVudCBldnQ7CiB9OwogCi1zdHJ1Y3Qgd2Z4X2VkY2Ff
cGFyYW1zIHsKLQkvKiBOT1RFOiBpbmRleCBpcyBhIGxpbnV4IHF1ZXVlIGlkLiAqLwotCXN0cnVj
dCBoaWZfcmVxX2VkY2FfcXVldWVfcGFyYW1zIHBhcmFtc1tJRUVFODAyMTFfTlVNX0FDU107Ci0J
dW5zaWduZWQgbG9uZyB1YXBzZF9tYXNrOwotfTsKLQogc3RydWN0IHdmeF9ncnBfYWRkcl90YWJs
ZSB7CiAJYm9vbCBlbmFibGU7CiAJaW50IG51bV9hZGRyZXNzZXM7CmRpZmYgLS1naXQgYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaAppbmRleCBm
ZjI5MTYzNDM2YjYuLjVhMmY4YWYxN2ViNyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dm
eC93ZnguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCkBAIC0xMTMsNyArMTEzLDgg
QEAgc3RydWN0IHdmeF92aWYgewogCWludAkJCWNxbV9yc3NpX3Rob2xkOwogCWJvb2wJCQlzZXRi
c3NwYXJhbXNfZG9uZTsKIAlzdHJ1Y3Qgd2Z4X2h0X2luZm8JaHRfaW5mbzsKLQlzdHJ1Y3Qgd2Z4
X2VkY2FfcGFyYW1zCWVkY2E7CisJdW5zaWduZWQgbG9uZwkJdWFwc2RfbWFzazsKKwlzdHJ1Y3Qg
aGlmX3JlcV9lZGNhX3F1ZXVlX3BhcmFtcyBlZGNhX3BhcmFtc1tJRUVFODAyMTFfTlVNX0FDU107
CiAJc3RydWN0IGhpZl9yZXFfc2V0X2Jzc19wYXJhbXMgYnNzX3BhcmFtczsKIAlzdHJ1Y3Qgd29y
a19zdHJ1Y3QJYnNzX3BhcmFtc193b3JrOwogCXN0cnVjdCB3b3JrX3N0cnVjdAlzZXRfY3RzX3dv
cms7Ci0tIAoyLjI0LjAKCg==
