Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15FFC13C08F
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730433AbgAOMM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:12:29 -0500
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:24056
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730333AbgAOMMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maiQPnj8yj2QSp9V9tKr2W3oKeYHNkSIUehuc+gtK3Bexg3ZBNg1Z/jysQgRPCBK5RYlyeSyHvkGeJp3LnjOU/86HEC/UEIGtRaTTQLxRa3G/SEHW/tNWtrfUvP6dWi3oZM7aeiypVTLl7j1uJjWFc4vvhEJDxDEGfl0AIN8mH8EGH4OGk18XgLK7GlYT/mawGlU4l4qF8ZkiDjfPKgQ/eWegsHKotfY8X91Rz5tvyEF1dCT6q7pMV59vNtky53Tg7xbClWj68oC3OAKekMA71Jj42PllGbTDNjrZwvSHAgO5kTYcNtjzV89gG224jTwEmb/EDakijaWMUzSH1fQaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhyMULnLyFgVEzsPUl6Rl1r3Lscd2QfGWEPYIvSlA+g=;
 b=XwYsIhgabY+K6o7BNDpmT589a/tDnizlI9uAr3egR3dT53FcEM/Jsyetph6lpAudXRrLUNXdLxN0r3qC2/6bGBVIZW4NnTepq5y8Rkc+SpDUde+M3qi06ZqHEnhZeVmkMXkbuNFpTqP5GKgN1d2/xwxuk774jy14qzLPZKlYzZlJJtqzgJXQgnQ7hD5on717ZdI0BJzcBLcS5ll9tGoNOIZr+cl3wVmFdAr9CSaW2r4BPFB5yFr5ZzmkrF6C9mM5YFRS8UPK/Mi7lrdvliHPDovqnwi7m+R6+wNZuGybQwygn8n0XH6n9M/4UsDkRVUEaYDI/x/iZmtNP+QHdCdtIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhyMULnLyFgVEzsPUl6Rl1r3Lscd2QfGWEPYIvSlA+g=;
 b=YAVm2oPOf3NQotj4oCQYyYcq9aBwRNzFXyJ6PJwp1mrP3qiCceiSdUD1Bw9qPQDolngWl+kQNHsXBPswRPWiwfXVfuhxilg1cvqxsRwwuKpVIvF8S5DglT1Qn/x4LQxK1apGP4xp+xTpc4NIwZSPZeI3faYqIQvp0MTt+WOPvj4=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:12:12 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:12 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:11 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 03/65] staging: wfx: add missing PROBE_RESP_OFFLOAD feature
Thread-Topic: [PATCH 03/65] staging: wfx: add missing PROBE_RESP_OFFLOAD
 feature
Thread-Index: AQHVy50EOMdl8bHC6UeIiK4r/bQsGA==
Date:   Wed, 15 Jan 2020 12:12:12 +0000
Message-ID: <20200115121041.10863-4-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 37d9ab94-62a2-4751-d769-08d799b426ee
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934C4FA772776CBC4DAB6B893370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(1076003)(66556008)(64756008)(66446008)(4744005)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hb25g0w7scN0g2pfUlpzSJqCOSS3x9szvEQVylRgQVl3zh1YxAt/tpnqi2NTVuO7nyNT82cs/RRuqaec5bjgMnOlmA+dWnJNacuqhE2wH+x9dFasTcZoN4QFnc+rCvBFe5Va5AT3ZzBm9qzWA9BXH56s+XKi9pqmLW6V+lUHwgedN2f6Z6ATtgd4yGJ7fb02ol8jPgN1oYaKXWWky3Uixklj7wdNEqX+4vZ41/v1souFPIzRIZWDQAxpNjEbVok2MImvWwjPovqAObOfGQrDGfX/XIBjkdtqjf4Q/txaKN0qQMs4vV5VoQz7ZZeejDjC6xsvNXgSNqPPGrNwtJaXiCjAf/ko6sic3HnOyDCXYjHXyemrlZbzRCcHm8DnCdtDa7bwPx0MR+n6FXwK6pRlxnjLO+1IHYE9r33vZNJZVf0AatjjolOHlH8uzoHodxBs
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F1F1AB686CF3143BE98CFBC0EF95498@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37d9ab94-62a2-4751-d769-08d799b426ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:12.4543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PkSXwRrj0sEgiOnnfqaFSTA4XOxkXdlYynxHy6lok6l7YNjyu+cReQDMlPlPujZVeJpXRkX5fa5yOQfhCHhE5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU29t
ZSB1c2Vyc3BhY2UgdG9vbHMgKGhvc3RhcGQpIHJlbHkgb24gcHJvYmVfcmVzcF9vZmZsb2FkIGZp
ZWxkcyBmb3IKY2VydGFpbiBmZWF0dXJlcy4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWls
bGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L21haW4uYyB8IDUgKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykKCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
bWFpbi5jCmluZGV4IDQ1Yzk5MzliN2U2Mi4uMTkwNDg5MGMwM2ZlIDEwMDY0NAotLS0gYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L21haW4uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwpA
QCAtMjk4LDYgKzI5OCwxMSBAQCBzdHJ1Y3Qgd2Z4X2RldiAqd2Z4X2luaXRfY29tbW9uKHN0cnVj
dCBkZXZpY2UgKmRldiwKIAlody0+d2lwaHktPmludGVyZmFjZV9tb2RlcyA9IEJJVChOTDgwMjEx
X0lGVFlQRV9TVEFUSU9OKSB8CiAJCQkJICAgICBCSVQoTkw4MDIxMV9JRlRZUEVfQURIT0MpIHwK
IAkJCQkgICAgIEJJVChOTDgwMjExX0lGVFlQRV9BUCk7CisJaHctPndpcGh5LT5wcm9iZV9yZXNw
X29mZmxvYWQgPSBOTDgwMjExX1BST0JFX1JFU1BfT0ZGTE9BRF9TVVBQT1JUX1dQUyB8CisJCQkJ
CU5MODAyMTFfUFJPQkVfUkVTUF9PRkZMT0FEX1NVUFBPUlRfV1BTMiB8CisJCQkJCU5MODAyMTFf
UFJPQkVfUkVTUF9PRkZMT0FEX1NVUFBPUlRfUDJQIHwKKwkJCQkJTkw4MDIxMV9QUk9CRV9SRVNQ
X09GRkxPQURfU1VQUE9SVF84MDIxMVU7CisJaHctPndpcGh5LT5mbGFncyB8PSBXSVBIWV9GTEFH
X0FQX1BST0JFX1JFU1BfT0ZGTE9BRDsKIAlody0+d2lwaHktPmZsYWdzIHw9IFdJUEhZX0ZMQUdf
QVBfVUFQU0Q7CiAJaHctPndpcGh5LT5mbGFncyAmPSB+V0lQSFlfRkxBR19QU19PTl9CWV9ERUZB
VUxUOwogCWh3LT53aXBoeS0+bWF4X2FwX2Fzc29jX3N0YSA9IFdGWF9NQVhfU1RBX0lOX0FQX01P
REU7Ci0tIAoyLjI1LjAKCg==
