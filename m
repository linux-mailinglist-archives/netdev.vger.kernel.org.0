Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E55213C3A0
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgAONyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:54:09 -0500
Received: from mail-eopbgr770082.outbound.protection.outlook.com ([40.107.77.82]:27461
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726132AbgAONyJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0f4cSzm19oURsQOtRnjX2i5XzVuCukAX9+TYE7peJXPbbrcUnKbZWd/f02ALB/Hi1gZeExbmhVgIHTSNUaLv0st4slSmsoKgnkF2PU/KGFTAHns3UjSt+VH7fVh1PKVSmjyY+9YlHvgLF1Ankg9//hUTY9/Tclv6U99msJUoySGt6P5vWF7WjZvxK05eRMH4uSiDE8pB1KgVRAWeATiWyCJVOgxaKWbt4rjxbaIYDMjGuwfvomqj5/4AUM0pkYe0Xbe8JSPETIkDkZlvjFWB5DGPNpctlK1eZtR2X+LTs1cfmGBstYnYw891xt7y4e6u57/icV0il1HxwdDccRKMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhyMULnLyFgVEzsPUl6Rl1r3Lscd2QfGWEPYIvSlA+g=;
 b=FGk1wiGNkZ3eI1LUNkp72K+PNMHs2376u/RyGCHyJuruILMT75ek385fZzpRspq+cb4gtUx77TKX9xUgF9AXig9lIy+O64kpcn9PDRZ4seDEIKiQ9yKLlDR6BGZLSS7t35hWbTeZ/29a5VfrC0PWkPELlz3BYW2nL51d1bRDdF4htY9s4sUh1jja1VE8oYd85yNwF7/FrvIUUTa99Y11s69sUMxi8qoqSQtJUS+veQX4FRXTZFroItuABBiGCpEFktjJJym09znkTX1w7QR3VCmV4nLEHpNvrXZYhYxpNtfBqE+5VvqmF2Tb0Os0Qs1oVRahzAMJru+AmE1qRpOxJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhyMULnLyFgVEzsPUl6Rl1r3Lscd2QfGWEPYIvSlA+g=;
 b=UxE4EG07J5ig+QjNw/4MTUsQuJK9hc6PdppYktZr4sZOuaoQcaIUgMhkg4X9ki0ca8WYKZVw58NT3vlqG/kct7uHDSFfRq0Iuor2lkp0OeLpJACfd0aQs/ZkWz1sBU0CMpL0/XAw0QAdz0WQFzmBmHHDWpB6lpF6KJ3dLzbR830=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:54:06 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:06 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:05 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 03/65] staging: wfx: add missing PROBE_RESP_OFFLOAD feature
Thread-Topic: [PATCH v2 03/65] staging: wfx: add missing PROBE_RESP_OFFLOAD
 feature
Thread-Index: AQHVy6tA3SfwYFXK4kmhsb6mA+rAlQ==
Date:   Wed, 15 Jan 2020 13:54:06 +0000
Message-ID: <20200115135338.14374-4-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 8066f9e4-f710-42a9-f6f3-08d799c26327
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB366146C98AD32C20C619F94C93370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(4744005)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VfDmIJBsw++PsbxXGm5dzn0NVJ8mGnpU3uhY8luMy94HJ+2B1Xfur6G7tNG/pYCrkNB/KagXccoEQc2gI2FIFWuHl/o3yHilA8yyboUDhhCBC2tdc9qrwXdMsL7FBD0Z4/u4FW71VUvk++qM70iyyAip1X8Q1lz8aGcgLBNUK1gsg0ryg/EFOcCywRPatA4PEEHC4CfYz7hNurMD4hw8dHKujJ9JYuE3pe3jZd8NVj7ulMrvB3nmyJUsE/prOtrqspnlj5rS4xdTCWTjIZCTxDkpjVbs0zzixIKEiSYYm9zrQi2uV99UeCVZiUOTq6AieX7Ydxqv/kE+T0j/OSDFlMmG2M8GGYifo2/6pMDbq6gyJTKcYSSKMOXwWBNikTz0JQm8zRqOuUireqV0UwMjvhkvsYMmz8weoyWyxteA/qPtsXCqPIi2IW8jJqweqXDE
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA38D32E75211B45AA6AF6AFB2893B98@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8066f9e4-f710-42a9-f6f3-08d799c26327
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:06.4242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TsN+mCGvN4fPUHQkTKikWbpdpb81FjC2jSoX5v915utx3EqAiFzYMwkP1IwGzlksqK5FTfuSPgLzSUQjpn0MaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
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
