Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C9A13C3D2
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729636AbgAONy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:54:58 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:14113
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729583AbgAONyz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N28QJzf+P0Qv+nvXTRRfi22KVBxjfeMN4uSLmXCrvFFzMPfPFmZDMiBxZ3JnsJwdU6EqG6ToCOhANKvGV/1A/lhBQZqmcF9SrqwyV0SboDTOHqahkHTRR2evZJhU5ZfkuvFCUGUnpS788TDsph50xCtRfIFvrPdg3KyVkNRPHASR6q7mPjqCSHIbZJpo5S8CxfWJG7PPL5EtBsO196jUJmm9KYdJeZYAv3orvyANCujOWWDky91dL7I111UDteD6T1q42YBG5CobdxO0uMWlyRw5wZekX3OEVY37uKELOPF2DQ89m3a/sE1jiD+GXhuN+4dDPyuGJL5pjmSVltEpow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRYmR3/mjgpAV7ya5W2JQ6zVOdZn/cH6Vo2ZfQhWaqo=;
 b=I1qGVbHo0Na2mYjyUUiHXWQAGsMzGZm5coyCTF5q7htOILTnbEbhQUSCUvPfogluTRJPIl6TtBvIcwXZetTly+nNeL5UqtIdeZsRdgyMqrHJ4t38G6GSZaL6RNseqMOkmAudEOf6K/czsFb2/dufoA0AXpM11stwDuY74F93m8r0EIN+9KBArVq03PfvMNhukG4/82MCimjBOnx3hHgWlrTsCLbye+Zu2m16va8QukF5amCUMTTuA+gh28Uv74CngEQEKfQhbQXQYQdFDRNeP+JVWv+/n8D/bCp+ybjOm/I8JM5hZieJFBFYaa9vAjFs5sXJ3We8LTcakY0L/svzMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRYmR3/mjgpAV7ya5W2JQ6zVOdZn/cH6Vo2ZfQhWaqo=;
 b=jJlg8Lci+PFgJfa/J8iwT/vNalN7W51tr/PdVhkUe62WyYpcKJ/lpQ3R/9vfD97D95InFwABiq/G0uLBwcb1d5IqEd6iArqyyNI4/j0jN6LZpqRXV6zoaR53gyeHYKpu931Zb3Tuli8nbTLYAPDodfsuz5X6CKceo17Prk2ihjg=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:54:37 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:37 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:35 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 24/65] staging: wfx: drop wvif->cqm_rssi_thold
Thread-Topic: [PATCH v2 24/65] staging: wfx: drop wvif->cqm_rssi_thold
Thread-Index: AQHVy6tTgbo9+hrC5kW72Xxr3M2syA==
Date:   Wed, 15 Jan 2020 13:54:37 +0000
Message-ID: <20200115135338.14374-25-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 7292ad40-48f4-4b2f-2d88-08d799c27572
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB40945B7066EC33C13624038593370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 45g0Z8zTeopUN+L9piLRVPfVm2XXDuyb4uauxMDpRCx2A34fz+QXou7tcNyaV9h1yHnelgQG0jSe7ijE08MbSWL96qsNQmiRVaIlW/Vqc6zMkXBtVH4RU+MRd5FtyNJk1Q4dbx3CjxQI54L3aal+bZ641c3FzjyQxHN9qG0pgDdHUZk6bvmzCyJFyW0+rxnvhmAtrsyAB7GXcacNSyVv0BPWv1CwVe0dbtKSrDCmplrlsjJApIpvOJNV3NGde0qnrrSMt4y30wSLXFk5+FcGhivZPnCqk7xXb4faWHLKyE+qR8t5CJO61ftHp/WJCkV8TPLeqjCrzS2ZgNKQvDmT0YUAZquq7hpYIMZ4Z2ya5hTHOQ4ptRzWXa0JUmn7CKpfN1MYn/Cxdvo020REnwD7R3ir6Tskq8W2wvfUmwr/feD3etb016NFE+gei6FmgkHw
Content-Type: text/plain; charset="utf-8"
Content-ID: <676375BBA52E874880D40A9DF2E07B29@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7292ad40-48f4-4b2f-2d88-08d799c27572
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:37.1125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UKpU6B+ziYtnS5//YNUp+iMb495YNyhc1ni6cR9+pg+KhfyOUFhqAN499jFmyG/JzbsNXCFG/wH3Bv8qnNybSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
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
