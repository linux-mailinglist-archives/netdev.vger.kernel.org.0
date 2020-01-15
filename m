Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C076613BF99
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731673AbgAOMOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:14:31 -0500
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:28929
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730768AbgAOMOa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:14:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fOWwIz/yItcWai/D+jqCjDW5Lyq3GUnRTCc4bYv8CdBL56OT0Gjasmjt6iScVLosc7lw1KJXVKyR11rc2nbxgOFuvjJHpfcikFQ8j0o8H/pOLLay8b046AgZpo0M7UwYm681hbWGfz77t4MhaTRHQZIimpnHUvyzuRCng+ImjUQhmoeZpaofTFaUasuv+AQ3lxmPNWb7PxuVxr5ynEdIFV0YoNSlg6NWcOfLFLxy278bbEBG+FJYLJiqaJRd19RdgCyrH1OE/YPh+i33/vg6xm21DE3PpfQAgqWX0cHwo4o/1Y/HhBg0HJ5QhWZRa0K/fGRtRxBO2w3O+erBPTxjNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NV6i8iFSi16VOyb/8DY1eR4/NhyYerJyThLKXln0oV0=;
 b=XPD7eGgGJB8SnYnyWjnpE8bnLBOVfH2V64n0iQMBjHBBLS3sC06HPXbrzvRhJ1TaB68ZQifLyBigU0ae54RhBzhPdA9lu7CQAPQMGrZU/BEFnOfbxf2L0JjfZRd0FMf66hSL+nJgKXh/YZM5upYZrUj/WTL1Annowh8wnAh8IhsOqWYEXWWjIsqPQJaQtyCdy+sj0S7cPupht+8tb0utH0uln4Pq3jZzBsVdiZngtD9MCh6lPkrCJcAJ7E0Q761XeKlj7BoiLC0FtwYpjiMrY3LGbuFjJOoDRbFTzq3diHbn4zyjxlxHEdrmb95HSPEFt/BOW9jhxNEMZv0wkvUDqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NV6i8iFSi16VOyb/8DY1eR4/NhyYerJyThLKXln0oV0=;
 b=Md8ezmzLb3VrPsDPer2OczEMomSCJTd09QasSMk85RyIXwOkYSKQl7TyVpZA88W4Act7/6q/HvAYPE9CxKNuoqgxVC5ARuKUFTa6D5FUg65eAhc24mm59K396+qTYe/5tH2zDDTaVAAbfdkmXHSxyTugYnV6JSlogv4DATzAk+s=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:13:37 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:37 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:26 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 59/65] staging: wfx: ensure that packet_id is unique
Thread-Topic: [PATCH 59/65] staging: wfx: ensure that packet_id is unique
Thread-Index: AQHVy50xnP1XCgggU0yByloZoEVwtg==
Date:   Wed, 15 Jan 2020 12:13:27 +0000
Message-ID: <20200115121041.10863-60-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 719e2ba5-2756-4a2e-19e0-08d799b453e3
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB39348B212C753ED02D3FF58D93370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SkDaqEicunoEpjBJodALyj6uvC17gLYAt+/y/m3RT3Y3LxVWhobDneKusaNrlTot0LF8AYbfKxwGdysk29D9G/3ufqM59izY7FfClM81/b2PyrYDc4f63yGIaMcIEuS8r1x0F3Lo7k58kRr6OnEQXE6VtzQkCchq8XznnzfPs7Sv+GFYLb+oJ8hWjbGhBsUoBEw6TAefpDl5PYHA2/5we/p/YnRdcIH7gzJ8FZASHZpE9tjJab8hInXRKxOLAcA302T+yM9LsgyeQqFiBwBhouTq12uMwHeHrjbMj6STupzlWPMkbUa6nRe8LPAfejJt/EX9lOqnjTlfHrI5FKHqG+0vtH1iRq0XRi7iEDtmhUQ3esBmv+w3Pwjmc/iN/Oxsjm/tz2HtkSW5gTDMRAUk23+MXsJfJJLumwmONSRFNxWiCEePbVC1XZAJuPqTQQcq
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E2E1E9D06C44042AC13A8C067BEC5E5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 719e2ba5-2756-4a2e-19e0-08d799b453e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:27.8818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tKa55qBrvxqBf5/Jbu9FTy4yVDqv96VrhNZUhs7scy/PhUjRIjsPux0eUkaX5MKCF+GuxDdR9tS6F7wKNQ76ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
Y3VycmVudCBjb2RlLCBwYWNrZXRfaWQgaXMgZGVyaXZhdGVkIGZyb20gbWFjODAyLjExIHBhY2tl
dCBzZXF1ZW5jZQpudW1iZXIsIGJ1dCB0aGlzIG51bWJlciBpcyBvbmx5IHVuaXF1ZSBmb3IgYSBz
dGF0aW9uLiBJdCBpcyBub3QKc3VmZmljaWVudC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBv
dWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L2RhdGFfdHguYyB8IDggKysrKysrLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggICAg
IHwgMSArCiAyIGZpbGVzIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyBiL2RyaXZlcnMvc3Rh
Z2luZy93ZngvZGF0YV90eC5jCmluZGV4IGMzMjk5NDU1MzYzMy4uMjBmNDc0MDczNGYyIDEwMDY0
NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYworKysgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2RhdGFfdHguYwpAQCAtNDY5LDggKzQ2OSwxMiBAQCBzdGF0aWMgaW50IHdmeF90eF9p
bm5lcihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IGllZWU4MDIxMV9zdGEgKnN0YSwKIAog
CS8vIEZpbGwgdHggcmVxdWVzdAogCXJlcSA9IChzdHJ1Y3QgaGlmX3JlcV90eCAqKWhpZl9tc2ct
PmJvZHk7Ci0JcmVxLT5wYWNrZXRfaWQgPSBxdWV1ZV9pZCA8PCAxNiB8Ci0JCQkgSUVFRTgwMjEx
X1NFUV9UT19TTihsZTE2X3RvX2NwdShoZHItPnNlcV9jdHJsKSk7CisJLy8gcGFja2V0X2lkIGp1
c3QgbmVlZCB0byBiZSB1bmlxdWUgb24gZGV2aWNlLiAzMmJpdHMgYXJlIG1vcmUgdGhhbgorCS8v
IG5lY2Vzc2FyeSBmb3IgdGhhdCB0YXNrLCBzbyB3ZSB0YWUgYWR2YW50YWdlIG9mIGl0IHRvIGFk
ZCBzb21lIGV4dHJhCisJLy8gZGF0YSBmb3IgZGVidWcuCisJcmVxLT5wYWNrZXRfaWQgPSBxdWV1
ZV9pZCA8PCAyOCB8CisJCQkgSUVFRTgwMjExX1NFUV9UT19TTihsZTE2X3RvX2NwdShoZHItPnNl
cV9jdHJsKSkgPDwgMTYgfAorCQkJIChhdG9taWNfYWRkX3JldHVybigxLCAmd3ZpZi0+d2Rldi0+
cGFja2V0X2lkKSAmIDB4RkZGRik7CiAJcmVxLT5kYXRhX2ZsYWdzLmZjX29mZnNldCA9IG9mZnNl
dDsKIAlpZiAodHhfaW5mby0+ZmxhZ3MgJiBJRUVFODAyMTFfVFhfQ1RMX1NFTkRfQUZURVJfRFRJ
TSkKIAkJcmVxLT5kYXRhX2ZsYWdzLmFmdGVyX2R0aW0gPSAxOwpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC93ZnguaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKaW5kZXggNWQ2
MTk0NmUzM2UwLi44Yjg1YmIxYWJiOWMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
d2Z4LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaApAQCAtNTQsNiArNTQsNyBAQCBz
dHJ1Y3Qgd2Z4X2RldiB7CiAJaW50CQkJdHhfYnVyc3RfaWR4OwogCWF0b21pY190CQl0eF9sb2Nr
OwogCisJYXRvbWljX3QJCXBhY2tldF9pZDsKIAl1MzIJCQlrZXlfbWFwOwogCXN0cnVjdCBoaWZf
cmVxX2FkZF9rZXkJa2V5c1tNQVhfS0VZX0VOVFJJRVNdOwogCi0tIAoyLjI1LjAKCg==
