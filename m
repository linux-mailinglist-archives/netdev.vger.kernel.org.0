Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D990913C067
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731898AbgAOMSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:18:16 -0500
Received: from mail-bn7nam10on2047.outbound.protection.outlook.com ([40.107.92.47]:27390
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730742AbgAOMMq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JINZpR9ppCncbJyVhCZOf0bG6WJfl4nmllmCmxC/TrWEQ28N4ERjG302pyC/tuMQZijh3sgTIsChM08S5f/D7uqq0kImxHf/8Pl3b9R7wpsOt4GZzmRjM7eiCBSYzoipwRkXKWWU3KFXY8F1hmRYscwpGBFarwOUbWNhiBs/orzgZ0MYZIaKxYtAc5OyRQPDxkHRYSVZMMqdx0mEQspEI8TwuaXxKpQ7oSxvkDRE7MVaCc/zBlechuG9Gj0IwT7d401tGq5SFAwoqpbvW9f716c7QvDz4sUXRwdDH1qIkJOoTXTFB0FmpRzk5zGZXm1z56c7tUge7829HHPuuH9aDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRYmR3/mjgpAV7ya5W2JQ6zVOdZn/cH6Vo2ZfQhWaqo=;
 b=H39Y5mHq5zWbeiCJsdS7QAouBxYL2kkzD6BAKaEdDGLhdtbn8m/7Z2SS6TEOt+agIZyoWAWrjzIi15eDh+0MBlEHZMg8lLA269DDMEodGkFV4p2ng865beO+PCpbe/0oyY+EsvtVxUAkL53Wn7wmfCrOtP6B8MIzPUkgNUV5cUBsCGCTb8y5fsc02o6oand2gcf0fVxHS7/5k10kfUdpaBTt0pkyWUyEU0Y8vqAUXDbkdT4BFiWGn/XEsk4hVgmxin72ieNL+OfulLTCg4gYdVu5LRvbzSdQ5bv8JmnYW+vM+Na+AviviCDUf0TEivxlji/ObO0wVKsXOcvbAV1K+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRYmR3/mjgpAV7ya5W2JQ6zVOdZn/cH6Vo2ZfQhWaqo=;
 b=Kte1Yz6TJSatDu+ln9wzzQXwgdGnes4EyckHCK19zlM6oWx0mPZaYLQ8aYrVRYXKRqf2U+fw6jMxmhQFAuCLCnIuCLHx0oIZ/1pC4nVWU02GWHUipcj0OYLkvk984ut+EL9AGA21o/dSaoiCFCyJNnltQ1sLVO2THu4PW1EjYto=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:12:41 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:41 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:40 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 24/65] staging: wfx: drop wvif->cqm_rssi_thold
Thread-Topic: [PATCH 24/65] staging: wfx: drop wvif->cqm_rssi_thold
Thread-Index: AQHVy50ViJN/SnAErkqSJEtdc+UaCQ==
Date:   Wed, 15 Jan 2020 12:12:41 +0000
Message-ID: <20200115121041.10863-25-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: be41f336-d626-41a8-1366-08d799b4381f
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB409691D6177A802199CD7A2F93370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tLxRswoRUYfzArLvjewZPVKw1DvucsNhCvkgIs1b4zGSvrYYIWgr62I+ao/oTgiV+vxvCoKceqHzfZyYS0eams+oacVUEVV3fHkwqz7AGTR/eWzUQd86lEFt9hTVFG9+JU6QOtQeTGgCyE054thmjqbIheB1X7Sx9IMDIKbp/HE61dTaVEKNFGz/kLygCBuDbOaPHxj8baYwzIpC2dMxIooHU1QEXr75Wjl3wy3vvXoToDALtfaSljoZccz1T8F1IvdZF8JO4k9iFvFKuJ4P5VDrBVT80R3pz/it8fOeSd4Le0MTz4z2bEi1rEQODMRJRYjQJaC5lRE2Ye/6ee+ncoAb1xovBD2Rd35BrG1N94i2ueXSc3KPClvxrqACXc9aJPNlhOJZmxdXqH1IDH0Hexz2JslG2fFf/VSBB/KduGiEqbjoTdWokcLr7MYs1bBi
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC6DBF2320473F49AC4BE95DD4422B60@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be41f336-d626-41a8-1366-08d799b4381f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:41.2607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +c2sKhI7KO3r8A8erfz7CK0GaodpfDtxt5a13IVNluYNF9RrUlGlCK4XjYzN1YH0tfLJa2nFryYX/fHSNvg39g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ3Vy
cmVudCBjb2RlIGtlZXBzIGEgY29weSBvZiBic3NfY29uZi0+Y3FtX3Jzc2lfdGhvbGQgaW4gd2Z4
X3ZpZi4gVGhlcmUKaXMgbm8gc2FuZSByZWFzb24gZm9yIHRoYXQuCgpTaWduZWQtb2ZmLWJ5OiBK
w6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVy
cy9zdGFnaW5nL3dmeC9zdGEuYyB8IDYgKystLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5o
IHwgMSAtCiAyIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9zdGEuYwppbmRleCBkZWRlNjMyM2JiMTcuLjAyMWRhYTlmN2EzMyAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
CkBAIC0zNzcsNyArMzc3LDcgQEAgc3RhdGljIHZvaWQgd2Z4X2V2ZW50X3JlcG9ydF9yc3NpKHN0
cnVjdCB3ZnhfdmlmICp3dmlmLCB1OCByYXdfcmNwaV9yc3NpKQogCWludCBjcW1fZXZ0OwogCiAJ
cmNwaV9yc3NpID0gcmF3X3JjcGlfcnNzaSAvIDIgLSAxMTA7Ci0JaWYgKHJjcGlfcnNzaSA8PSB3
dmlmLT5jcW1fcnNzaV90aG9sZCkKKwlpZiAocmNwaV9yc3NpIDw9IHd2aWYtPnZpZi0+YnNzX2Nv
bmYuY3FtX3Jzc2lfdGhvbGQpCiAJCWNxbV9ldnQgPSBOTDgwMjExX0NRTV9SU1NJX1RIUkVTSE9M
RF9FVkVOVF9MT1c7CiAJZWxzZQogCQljcW1fZXZ0ID0gTkw4MDIxMV9DUU1fUlNTSV9USFJFU0hP
TERfRVZFTlRfSElHSDsKQEAgLTkyMiwxMSArOTIyLDkgQEAgdm9pZCB3ZnhfYnNzX2luZm9fY2hh
bmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAlpZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VE
X0FTU09DIHx8IGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9FUlBfU0xPVCkKIAkJaGlmX3Nsb3RfdGlt
ZSh3dmlmLCBpbmZvLT51c2Vfc2hvcnRfc2xvdCA/IDkgOiAyMCk7CiAKLQlpZiAoY2hhbmdlZCAm
IEJTU19DSEFOR0VEX0FTU09DIHx8IGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9DUU0pIHsKLQkJd3Zp
Zi0+Y3FtX3Jzc2lfdGhvbGQgPSBpbmZvLT5jcW1fcnNzaV90aG9sZDsKKwlpZiAoY2hhbmdlZCAm
IEJTU19DSEFOR0VEX0FTU09DIHx8IGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9DUU0pCiAJCWhpZl9z
ZXRfcmNwaV9yc3NpX3RocmVzaG9sZCh3dmlmLCBpbmZvLT5jcW1fcnNzaV90aG9sZCwKIAkJCQkJ
ICAgIGluZm8tPmNxbV9yc3NpX2h5c3QpOwotCX0KIAogCWlmIChjaGFuZ2VkICYgQlNTX0NIQU5H
RURfVFhQT1dFUikKIAkJaGlmX3NldF9vdXRwdXRfcG93ZXIod3ZpZiwgaW5mby0+dHhwb3dlcik7
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC93ZnguaAppbmRleCA4NGNiM2E4M2U1ZDkuLjFiNDg3ZDk2ZWNhMiAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5o
CkBAIC0xMDUsNyArMTA1LDYgQEAgc3RydWN0IHdmeF92aWYgewogCXN0cnVjdCB3b3JrX3N0cnVj
dAl1cGRhdGVfZmlsdGVyaW5nX3dvcms7CiAKIAl1MzIJCQllcnBfaW5mbzsKLQlpbnQJCQljcW1f
cnNzaV90aG9sZDsKIAlib29sCQkJc2V0YnNzcGFyYW1zX2RvbmU7CiAJdW5zaWduZWQgbG9uZwkJ
dWFwc2RfbWFzazsKIAlzdHJ1Y3QgaWVlZTgwMjExX3R4X3F1ZXVlX3BhcmFtcyBlZGNhX3BhcmFt
c1tJRUVFODAyMTFfTlVNX0FDU107Ci0tIAoyLjI1LjAKCg==
