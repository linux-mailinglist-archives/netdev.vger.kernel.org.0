Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76A62121090
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfLPREH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:04:07 -0500
Received: from mail-eopbgr700081.outbound.protection.outlook.com ([40.107.70.81]:14720
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727211AbfLPREG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:04:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XpTFeevrN5ySwWMsCGAuzBBql8IT6ZnEINHpz5kx18vAv2osqq1Rynh5kqTuXpCIeDie4IuxVlOdsiw6rRjLmbbXzsdXf1TCmuhVUMDENpppQ4IM7FyNTMz9TiLDeodvxV59Gu8ZXsPaL8zpGyiVsOpG8v1vAYQhAdvcbObjuNx4BwhdKVVvpYArctS/2SfTA3KMVZiHoVJ95XrLmCgPyBvNCPpQ4b9gDWtmsvG+uGRfsAbyttNxAnikvL9idTUqQ4FZkLWWRLnUmXFtIxNztxpEhgT8r6otBziPycypJNxZIYpli5OJlozgOD5WTguTQFM8js6BJoHXD+vB8VJbUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PG4JylPEKHbtwI4r/H/xKWYuJKm52EAz/DJjLZ8muGo=;
 b=K/7jGUZWf7dzUuUbFdoRhi4bdIZ1KjtNegG22VnmtDwQdKufgh6vNMDlnMV3CbIaRM0ZBUL3BTweWmg+6XAWH5kU/p0sxEsMRqa2r/LFWU4v8cSL/NexFzXXXzZWz8nhJ4ripVcLQPdugM3aVtTzFPoHmcDCHRO1yLCS9D7D6UILbWFjtrtdgr+F4KJaYav4u+WDqF7q7m2TWHII/ar+U7c9W6lDCx4uq4ETHDhwK0u3HCFRgRSvu5HbwXm2aqTIX1gHCOC/Pge67xw/NTrW7cCBxf8+VWmoP5Sul/ugwdOJOtJTwUp8DLK7QYiHB+quA87m715PcGQyKta38uTQZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PG4JylPEKHbtwI4r/H/xKWYuJKm52EAz/DJjLZ8muGo=;
 b=lqRrZ/2AJGSjkhIW3krpneQEvdjuoGwqs0/2ryy7AdJJQY+QrTg6NFvq+OqcQzU5wM34P23U/rriku4X7Kg/JgXr8hK2AO8+UiQkRaQZsD6browPNbcSM9zvZnKlBUX0ahDdTn/UQHKdLpek+TDDJy0CbHeD+aLmSLF3LA8+fek=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4351.namprd11.prod.outlook.com (52.135.39.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Mon, 16 Dec 2019 17:03:54 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:03:54 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 26/55] staging: wfx: improve API of
 hif_req_join->infrastructure_bss_mode
Thread-Topic: [PATCH 26/55] staging: wfx: improve API of
 hif_req_join->infrastructure_bss_mode
Thread-Index: AQHVtDLH08tuX/G5fkWRLIXlp65cuA==
Date:   Mon, 16 Dec 2019 17:03:47 +0000
Message-ID: <20191216170302.29543-27-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: ceae76b7-e727-4e44-e846-08d78249eeab
x-ms-traffictypediagnostic: MN2PR11MB4351:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB43510E849449010238F027C393510@MN2PR11MB4351.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(396003)(39860400002)(199004)(189003)(66556008)(66446008)(64756008)(66476007)(76116006)(85202003)(91956017)(66946007)(54906003)(107886003)(4326008)(478600001)(110136005)(71200400001)(6512007)(81156014)(8676002)(81166006)(186003)(36756003)(2906002)(85182001)(6666004)(1076003)(316002)(6506007)(5660300002)(86362001)(26005)(2616005)(6486002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4351;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FlnQ+UnDqp4qbU2sCkzzuoj63KWEBFlreBonepgAyuYVXQqkfE7FnDCHmlg6SBFU44nYM5je9aTOjJM9xh2DLppTRwd08DeoaHgPWHI11y2pyjrZrcZjkOLco7S4QBJFTIK8CudJbCCLyfm12I/gZvTP4z1rhf3RQJuACIVBrDonMDoIKLjEp8LyiShwaOBEZOY2fc5DyrjryxExJyQgEJD4oGMDVoOD6EOCpgC3r8fm5Vmh3KrL6DPL3bNQtu6X9BwBrEF6ggl1ItwdmNZqNEbVzvat3vSR1Pjdu7LbeWUJGYEvSI6lM6/UPctIZ/jNTV4J9gqMWu/Dga8ZTbhvXPLeauhWxpkMY+xbfl+/w4rXbArcVmj6s8D8ut7Q/qmetIpjfof4glf6jINPYLhU0Nw8HaYKogUoTzY5JAbHPOWdWRSAqKzwnaszekM7Tdu/
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D5AAB569C52E144BB653DF5A6434DED@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceae76b7-e727-4e44-e846-08d78249eeab
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:47.1623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XNCw2JdVbzHiboqYBOQaom6vVAodEpblLsePM4tiWax5lNjzThbuI/NzcsQSpBUaX8Dur1W6jpRE0c9Tj95/GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpJ
biBmYWN0ICJtb2RlIiBpcyBhIGJvb2xlYW4gdGhhdCBpbmRpY2F0ZXMgaWYgSUJTUyBtb2RlIGlz
IHVzZWQuIFRoaXMNCnBhdGNoIGZpeGVzIHRoZSBuYW1lIGFuZCB1c2VzIGEgbW9yZSBhZGFwdGVk
IG1lbW9yeSByZXByZXNlbnRhdGlvbi4NCg0KU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxs
ZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KLS0tDQogZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfYXBpX2NtZC5oIHwgOCArKy0tLS0tLQ0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMg
ICAgICAgICB8IDIgKy0NCiAyIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgNyBkZWxl
dGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQu
aCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaA0KaW5kZXggNGNlM2JiNTFjZjA0
Li5lODQ4YmQzMDczYTIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlf
Y21kLmgNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaA0KQEAgLTM3Nywx
MSArMzc3LDYgQEAgc3RydWN0IGhpZl9jbmZfZWRjYV9xdWV1ZV9wYXJhbXMgew0KIAl1MzIgICBz
dGF0dXM7DQogfSBfX3BhY2tlZDsNCiANCi1lbnVtIGhpZl9hcF9tb2RlIHsNCi0JSElGX01PREVf
SUJTUyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID0gMHgwLA0KLQlISUZfTU9ERV9CU1Mg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPSAweDENCi19Ow0KLQ0KIGVudW0gaGlmX3By
ZWFtYmxlIHsNCiAJSElGX1BSRUFNQkxFX0xPTkcgICAgICAgICAgICAgICAgICAgICAgICAgID0g
MHgwLA0KIAlISUZfUFJFQU1CTEVfU0hPUlQgICAgICAgICAgICAgICAgICAgICAgICAgPSAweDEs
DQpAQCAtMzk2LDcgKzM5MSw4IEBAIHN0cnVjdCBoaWZfam9pbl9mbGFncyB7DQogfSBfX3BhY2tl
ZDsNCiANCiBzdHJ1Y3QgaGlmX3JlcV9qb2luIHsNCi0JdTggICAgbW9kZTsNCisJdTggICAgaW5m
cmFzdHJ1Y3R1cmVfYnNzX21vZGU6MTsNCisJdTggICAgcmVzZXJ2ZWQxOjc7DQogCXU4ICAgIGJh
bmQ7DQogCXUxNiAgIGNoYW5uZWxfbnVtYmVyOw0KIAl1OCAgICBic3NpZFtFVEhfQUxFTl07DQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmMNCmluZGV4IGI0YmI1YjY1M2U2NC4uMjNlYzdhNGE5MjZiIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYw0KKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEu
Yw0KQEAgLTY1MSw3ICs2NTEsNyBAQCBzdGF0aWMgdm9pZCB3ZnhfZG9fam9pbihzdHJ1Y3Qgd2Z4
X3ZpZiAqd3ZpZikNCiAJc3RydWN0IGllZWU4MDIxMV9ic3NfY29uZiAqY29uZiA9ICZ3dmlmLT52
aWYtPmJzc19jb25mOw0KIAlzdHJ1Y3QgY2ZnODAyMTFfYnNzICpic3MgPSBOVUxMOw0KIAlzdHJ1
Y3QgaGlmX3JlcV9qb2luIGpvaW4gPSB7DQotCQkubW9kZSA9IGNvbmYtPmlic3Nfam9pbmVkID8g
SElGX01PREVfSUJTUyA6IEhJRl9NT0RFX0JTUywNCisJCS5pbmZyYXN0cnVjdHVyZV9ic3NfbW9k
ZSA9ICFjb25mLT5pYnNzX2pvaW5lZCwNCiAJCS5wcmVhbWJsZV90eXBlID0gY29uZi0+dXNlX3No
b3J0X3ByZWFtYmxlID8gSElGX1BSRUFNQkxFX1NIT1JUIDogSElGX1BSRUFNQkxFX0xPTkcsDQog
CQkucHJvYmVfZm9yX2pvaW4gPSAxLA0KIAkJLmF0aW1fd2luZG93ID0gMCwNCi0tIA0KMi4yMC4x
DQo=
