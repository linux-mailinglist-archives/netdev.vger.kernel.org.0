Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71FB513BFD9
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731342AbgAOMNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:13:33 -0500
Received: from mail-bn7nam10on2048.outbound.protection.outlook.com ([40.107.92.48]:31808
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731305AbgAOMNc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgP5abDShITF00TM0zuLjMJWvu+jM6q7jeJ2xx0TFQIdqxW4JBDIRAYItOj7sGlus7szZa2wB6nq/xbGNoq+gNsAZoMVVOjeKZIndtek64wzmbeJZSZg0+FUs1OYZhvxRC5QgKPNJiw4ED3H0vHnLetc69gTOLSlbcxQJJijA3FvWN0TWTO/sRzlvOw2eekEn2LIceC8VvxtihX4KaKh4oLYVNP+7uml89cn/GF6mLQ8HOuYPiRz91Q0teEyAst60W0OsYig2BZv/cCLwJ2YRvHCFoTZt82rhJrtTLSPEA9gVUBTRCgDN3frYnlvA8Br0sW6zR2+9tu4HiIX8/Dtwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wE4NZayrc5/OqYjwEoTG0wWNVVdW3mn+wI1Dx4BnsqA=;
 b=W04jmEGQUq/owXfuuFa63PzmhjmnONj4q7sMkrl/pQJ31E+s0Xtg0JmcZzzkFoFNf9vb8vV8atrTiepk7exVdILi5oeum2s/B9YNY+o5Kn0Wi+5DkJQnS1xpa2eeH8iJwPebNkVxB8KitFtfjpgRk0/eTAWS5A5tNLW3xsBeq5eyY8GqvAEEQ40jyu/xtq50VvFxzuipDwW/mZ4Zpd2Lvbv7F9vcCa5ltuAPVkP/682B58bFcO4olsM5siD4jZ63DnPI1HymnklmFLlT1NfDfkHCdbTxgNmC95hgqhZ2cTVN1NnBMUbAam2TYU2nPGbmL1t7VFSukAoT5piJjeA1HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wE4NZayrc5/OqYjwEoTG0wWNVVdW3mn+wI1Dx4BnsqA=;
 b=eFYQT/RcF7a83/fFzUwYHgRO6ZV0Rjlt8dp9s2eV1yemN51GVVdrXoeWcE/IHsJ1xJx1D3L94UF+Mr+Gc/1VpNR67iCMmKLbpUOP3t+A6sOfm82GtI/eM1W45nTKmyvV3hEBY4pBd8tQaZiH/cGqKHt87370xHaYuUwDWMa1Z/Y=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:13:22 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:22 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:54 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 35/65] staging: wfx: simplify hif_set_mac_addr_condition()
Thread-Topic: [PATCH 35/65] staging: wfx: simplify
 hif_set_mac_addr_condition()
Thread-Index: AQHVy50ecNC0Ux3kl0yNLHwNJCt/cw==
Date:   Wed, 15 Jan 2020 12:12:55 +0000
Message-ID: <20200115121041.10863-36-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: b45e65fd-aab2-4968-6cfb-08d799b440c8
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB40966A6503B38735FC25BDF693370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(66574012)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lLJvPx+0OP2dcn/bsZveMeMwxI8IHZKOicVNq5pCoN5crRgY63F7ZIFpxP0x7GuE/3NDUHPjzpnprnMb9QVnKHsdsVwx8L3EgkkPIJkF74pFyCMgtW/PyeeM+BuDgcKt3AUjD1+1q07X/I6spx/CCqj2EsOgboFDADUTZkCPdp8dySVjTAczfGry1vAJ0z5249es/peV8nlcMu+Z+mLOREK+aKDMnFRH1dP4/tvO6R9beydAAGobTISYgNkezQmmT4O2g4NHqK9Vuk+nw6bYaSH6/syooQfEQGVR/Hk3/BLGbTOKDxwLpGsWrZurgJTOo3WZE6FPWjQHEezmHrsp+YZh5NfJU+P4eaS7AmR4aRIuIH+DAQFSo/7Gop8oWlV/0ukK6nhjBzYaXGxzgVRnjWkr+j8+65OKHBYrFJ5EOSyYs5KRVXVe2JzCg39ePOqF
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E5D283AD3451D4CB9861EA4FB41B356@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b45e65fd-aab2-4968-6cfb-08d799b440c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:55.7943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vKSNuksgCUsuANcOsIUfjvWjeGpu5qwg8EXnD5HAuvUI3qbiWp7UtAtxNfKDb+mOeoTrpLix245ohVCp1kqliA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdHVyZSBoaWZfbWliX21hY19hZGRyX2RhdGFfZnJhbWVfY29uZGl0aW9uIGNvbWUgZnJv
bSBoYXJkd2FyZQpBUEkuIEl0IGlzIG5vdCBpbnRlbmRlZCB0byBiZSBtYW5pcHVsYXRlZCBpbiB1
cHBlciBsYXllcnMgb2YgdGhlIGRyaXZlci4KCkluIGFkZCwgY3VycmVudCBjb2RlIGZvciBoaWZf
c2V0X21hY19hZGRyX2NvbmRpdGlvbigpIGlzIHRvbyBkdW1iLiBJdApzaG91bGQgcGFjayBkYXRh
IHdpdGggaGFyZHdhcmUgcmVwcmVzZW50YXRpb24gaW5zdGVhZCBvZiBsZWF2aW5nIGFsbAp3b3Jr
IHRvIHRoZSBjYWxsZXIuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21l
LnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWli
LmggfCAxMCArKysrKysrKy0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgICAgICB8ICA5
ICstLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmgKaW5kZXggZWUyMmM3MTY5ZmFiLi45MDQ3NGIx
YzVlYzMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oCisrKyBi
L2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oCkBAIC0yMzksMTEgKzIzOSwxNyBAQCBz
dGF0aWMgaW5saW5lIGludCBoaWZfc2V0X3R4X3JhdGVfcmV0cnlfcG9saWN5KHN0cnVjdCB3Znhf
dmlmICp3dmlmLAogfQogCiBzdGF0aWMgaW5saW5lIGludCBoaWZfc2V0X21hY19hZGRyX2NvbmRp
dGlvbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKLQkJCQkJICAgICBzdHJ1Y3QgaGlmX21pYl9tYWNf
YWRkcl9kYXRhX2ZyYW1lX2NvbmRpdGlvbiAqYXJnKQorCQkJCQkgICAgIGludCBpZHgsIGNvbnN0
IHU4ICptYWNfYWRkcikKIHsKKwlzdHJ1Y3QgaGlmX21pYl9tYWNfYWRkcl9kYXRhX2ZyYW1lX2Nv
bmRpdGlvbiB2YWwgPSB7CisJCS5jb25kaXRpb25faWR4ID0gaWR4LAorCQkuYWRkcmVzc190eXBl
ID0gSElGX01BQ19BRERSX0ExLAorCX07CisKKwlldGhlcl9hZGRyX2NvcHkodmFsLm1hY19hZGRy
ZXNzLCBtYWNfYWRkcik7CiAJcmV0dXJuIGhpZl93cml0ZV9taWIod3ZpZi0+d2Rldiwgd3ZpZi0+
aWQsCiAJCQkgICAgIEhJRl9NSUJfSURfTUFDX0FERFJfREFUQUZSQU1FX0NPTkRJVElPTiwKLQkJ
CSAgICAgYXJnLCBzaXplb2YoKmFyZykpOworCQkJICAgICAmdmFsLCBzaXplb2YodmFsKSk7CiB9
CiAKIHN0YXRpYyBpbmxpbmUgaW50IGhpZl9zZXRfdWNfbWNfYmNfY29uZGl0aW9uKHN0cnVjdCB3
ZnhfdmlmICp3dmlmLApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggNTg4MDk0NDg2YTdhLi5iNzRlMGNlNDEwNjkg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYwpAQCAtMTE4LDcgKzExOCw2IEBAIHN0YXRpYyBpbnQgd2Z4X3NldF9tY2Fz
dF9maWx0ZXIoc3RydWN0IHdmeF92aWYgKnd2aWYsCiB7CiAJaW50IGksIHJldDsKIAlzdHJ1Y3Qg
aGlmX21pYl9jb25maWdfZGF0YV9maWx0ZXIgY29uZmlnID0geyB9OwotCXN0cnVjdCBoaWZfbWli
X21hY19hZGRyX2RhdGFfZnJhbWVfY29uZGl0aW9uIGZpbHRlcl9hZGRyX3ZhbCA9IHsgfTsKIAog
CS8vIFRlbXBvcmFyeSB3b3JrYXJvdW5kIGZvciBmaWx0ZXJzCiAJcmV0dXJuIGhpZl9zZXRfZGF0
YV9maWx0ZXJpbmcod3ZpZiwgZmFsc2UsIHRydWUpOwpAQCAtMTI2LDE0ICsxMjUsOCBAQCBzdGF0
aWMgaW50IHdmeF9zZXRfbWNhc3RfZmlsdGVyKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCWlmICgh
ZnAtPmVuYWJsZSkKIAkJcmV0dXJuIGhpZl9zZXRfZGF0YV9maWx0ZXJpbmcod3ZpZiwgZmFsc2Us
IHRydWUpOwogCi0JLy8gQTEgQWRkcmVzcyBtYXRjaCBvbiBsaXN0CiAJZm9yIChpID0gMDsgaSA8
IGZwLT5udW1fYWRkcmVzc2VzOyBpKyspIHsKLQkJZmlsdGVyX2FkZHJfdmFsLmNvbmRpdGlvbl9p
ZHggPSBpOwotCQlmaWx0ZXJfYWRkcl92YWwuYWRkcmVzc190eXBlID0gSElGX01BQ19BRERSX0Ex
OwotCQlldGhlcl9hZGRyX2NvcHkoZmlsdGVyX2FkZHJfdmFsLm1hY19hZGRyZXNzLAotCQkJCWZw
LT5hZGRyZXNzX2xpc3RbaV0pOwotCQlyZXQgPSBoaWZfc2V0X21hY19hZGRyX2NvbmRpdGlvbih3
dmlmLAotCQkJCQkJICZmaWx0ZXJfYWRkcl92YWwpOworCQlyZXQgPSBoaWZfc2V0X21hY19hZGRy
X2NvbmRpdGlvbih3dmlmLCBpLCBmcC0+YWRkcmVzc19saXN0W2ldKTsKIAkJaWYgKHJldCkKIAkJ
CXJldHVybiByZXQ7CiAJCWNvbmZpZy5tYWNfY29uZCB8PSAxIDw8IGk7Ci0tIAoyLjI1LjAKCg==
