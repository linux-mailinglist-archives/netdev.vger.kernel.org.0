Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9ACC13C41E
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbgAON4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:56:23 -0500
Received: from mail-dm6nam11on2065.outbound.protection.outlook.com ([40.107.223.65]:2785
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730082AbgAONzj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDSrvV46B2DG/3WOWAmJZpMd3b/50BHAM9eZnnBebFErJl9ksq0xQF0pN2y4rzSLm4rd3RiSFCiIUWf/EMEv5H9JANuOzIQf1mkkCFgY97rsdNajx2WX67skelmKJQJVf1p/Rj4mjG7M4GMiI9r2gMcuXpy3FLeQUjxm1TbzkLaprKhvQ1Mj4VQWeuzJsDOmsxbndHEDWwV/aHUrZNu4xcr6rkv39lKcK4LRbcfVqmtL3Mc1GQg8/M4tRTR+6b8U4i05fhEVbY2fJ9pscRxwN0kUeEEDlIRfpFh0GlHSZe1iloSHl2KY+4sfluM4nmwb08Dt47U0ah5V541DJFj6dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaRMw1XepUHJ3QujRDv8HV1rg+avvSmDFcrzfrWX7TE=;
 b=Edfjvd3T0iMYeOJeIlslYAk56RrOzxRhb3GUi1NGOHOFYc3SRiuCBTnJ2yifVQS0d2LPh73G5pMlT0afGzeJZA4yyEsO3klRxMOhSzrFQfoVKJ3lXUzL6HziOz85BQ0O5iYXZj5jZCuvw3vhNkUKETGkfMWT7nkX+/nrkxaj/UWgktQ6FpSS6OQd8/shDbw9tKk+YHapLDLqkFuQ2E/pWdEWi7wKdiZgXmSScowSd8ZMBljCDowIX78eIPobVqQ1sUE4BSwMb77ca2fGZLHnb+KEzW3waNpf/NmLlO3YDGF8lmJBtuWLhWQwZ/U9F+W4LziNKuQ/5ET30TqdiR2HDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaRMw1XepUHJ3QujRDv8HV1rg+avvSmDFcrzfrWX7TE=;
 b=KjF5t156j/XvMNZJQIJH7HYuogYeekg9V5DbE1EtE8U4LKR5uVNkJWG0zNZGHlfle+PDfz1JHdc4s6YUgDRuz5cNuXJ+Ciw3Mqgx7gQDLFn27DT9LEhM/d8/Kv8XLhj7/RMThNJDkKIvz+gNuiuXR0Uc1SnqTBZ4wWCEhOeN1RE=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:55:27 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:27 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:55:15 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 51/65] staging: wfx: check that no tx is pending before
 release sta
Thread-Topic: [PATCH v2 51/65] staging: wfx: check that no tx is pending
 before release sta
Thread-Index: AQHVy6tqBTTAEb2p9UK8zcHT9dvU1g==
Date:   Wed, 15 Jan 2020 13:55:16 +0000
Message-ID: <20200115135338.14374-52-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: db1f29d8-3d7c-4205-4ed5-08d799c28cfb
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB409425C1681B2E892AAE8B1C93370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(4744005)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ka1BEQqgtk2lbReYtRgA7FCeO7ntDzUbSvrfECMnk9Yei3PPab35vRbU4+esVI7AbTLQWb3sePtDhi78c0UTdhcz3h4bxsdHca88xjDpB8x243MtXwm3eJ5SVykZWnJm5GXdXig5hT9UgHrjh9+0dwuAHAPBToSlMt4TOYuIFVZjd5JDW9z4/odnb4a460fMdWqDTD2sNlfSTSlvDUBQI/I5xaIcudWX0PlXh4pOQBEhxLOXhbwIXxhqhifLEi4G/cW7v9sWL894GKz/6FDii2lYYL0py+yR3hMlEWdFmLBKvDq4Ca5DVBh7RJEZv0nC7NuNjYHn5GbwNaLgfm8WSDetUAerm2Q79L9CVK7L3kH7sgSjm6pjWe02O53x9sVjQiBY1VLXT7CSWuDfx+MFzYgqw4iMZhFZCWuUu6yHVWm5zp6G9S8+rSeEzpZ2GJoY
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA1FB74096B5BD428B8B7E249D24E1D0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db1f29d8-3d7c-4205-4ed5-08d799c28cfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:55:16.6998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d41LGUUP2NxkfZ+K1CsLsq32CNwwzhYCFTitSPEBYkbc8Rxiia2W6qzoJySWOH43gGIonE4K0cMJ4mDIg38BQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSnVz
dCBmb3Igc2FuaXR5LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5w
b3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCAzICsr
KwogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDc1YzFl
MmFlY2MyMy4uMzM5NTUyNzhkOWQzIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTYwMiw3ICs2MDIsMTAgQEAg
aW50IHdmeF9zdGFfcmVtb3ZlKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgw
MjExX3ZpZiAqdmlmLAogewogCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gKHN0cnVjdCB3Znhfdmlm
ICopIHZpZi0+ZHJ2X3ByaXY7CiAJc3RydWN0IHdmeF9zdGFfcHJpdiAqc3RhX3ByaXYgPSAoc3Ry
dWN0IHdmeF9zdGFfcHJpdiAqKSAmc3RhLT5kcnZfcHJpdjsKKwlpbnQgaTsKIAorCWZvciAoaSA9
IDA7IGkgPCBXRlhfTUFYX1RJRDsgaSsrKQorCQlXQVJOKHN0YV9wcml2LT5idWZmZXJlZFtpXSwg
InJlbGVhc2Ugc3RhdGlvbiB3aGlsZSBUeCBpcyBpbiBwcm9ncmVzcyIpOwogCS8vIEZJWE1FOiBz
ZWUgbm90ZSBpbiB3Znhfc3RhX2FkZCgpCiAJaWYgKHZpZi0+dHlwZSA9PSBOTDgwMjExX0lGVFlQ
RV9TVEFUSU9OKQogCQlyZXR1cm4gMDsKLS0gCjIuMjUuMAoK
