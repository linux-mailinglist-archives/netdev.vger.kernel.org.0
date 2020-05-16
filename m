Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCD91D5F87
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 10:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgEPIHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 04:07:22 -0400
Received: from mail-db8eur05on2040.outbound.protection.outlook.com ([40.107.20.40]:14657
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725934AbgEPIHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 May 2020 04:07:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T68JLgLU2SNnZYhdcNNMwttdN8r43D3k7y3QzJgvbXbSFoVGnyqLSs2w/l6NP8M0Bd+XAEbsQ8T8K0JxCbmotRZGzSP+6pjcx3+uZWP4KSuThiMdkpZqWrumg/xZaUwG/l4w/psoImLg8DHCDbX6K2fFtK3JVuA6FuSKrBi6OrvbQemAYd9PVNHo/7er9TqtC6T3jqKpprIWIrRpO9FCGxTX/xRvitksjb/sObDvqqM9U5ol9s1SqLZjKK6yyRWkKFShJBk0g7UmP3aCliWghI01rur3g0wJGPM8ozCqZoZjHFJnHwx3RoubQgW7qIllnazllDMb9FNl+ggLaDFAjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w2Zfiq9y1ZmgTDRkLxGRCY2qmeZ6TZCm8oyFMmNeFps=;
 b=HrNBV22Ay9hOP/HNs2oFPrYlDfBHSrK02Oqol2HybtmQ4oKJVn8L/sdYD2zZjNzQmzI/wCfyQ2FpkbHBWu2fbJW/yOZWGXEa1nxt5sxBQXbVgjvaSV+M5aa/9KVlXoFrwYEy8fU4zhsEt7+StHhx4H4X9qspBOfXYZlQBhiGThaynU9N0GJVTsjiwObIGfpxiN9BLYy/2dp21cfsDwflDAPJegpBEPSLXJAG/RwQmUwHdjdc+GlXFWtY0SSgNdwl770b2MGKEkOnobIVrrLd8HTDL5PSgLfQRbptNJpEckLuRu8rFzWDnoj78VmHk3Lb6SYAg9YgNEnhXzrYH3/NvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w2Zfiq9y1ZmgTDRkLxGRCY2qmeZ6TZCm8oyFMmNeFps=;
 b=F2CbDLgvTzIfarxoUB7lVTFZUxvl7dnDsLplqYyOsE4Y8Rlx5W/PBQk1bbKzm1XiMltUgUeBtwSebT/74dm8lywDdYigWiZc9d/kDGJMb8CkDWGNi13eMMvjLRSfPii59JJCP80VYdCBVXg+8SELGPnH9kvztvcK6tgFyyV+8lU=
Received: from VI1PR04MB4366.eurprd04.prod.outlook.com (2603:10a6:803:3d::27)
 by VI1PR04MB3038.eurprd04.prod.outlook.com (2603:10a6:802:d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Sat, 16 May
 2020 08:07:17 +0000
Received: from VI1PR04MB4366.eurprd04.prod.outlook.com
 ([fe80::8102:b59d:36b:4d09]) by VI1PR04MB4366.eurprd04.prod.outlook.com
 ([fe80::8102:b59d:36b:4d09%7]) with mapi id 15.20.3000.022; Sat, 16 May 2020
 08:07:16 +0000
From:   Ganapathi Bhat <ganapathi.bhat@nxp.com>
To:     =?utf-8?B?UGFsaSBSb2jDoXI=?= <pali@kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Cathy Luo <cluo@marvell.com>,
        Avinash Patil <patila@marvell.com>,
        =?utf-8?B?TWFyZWsgQmVow7pu?= <marek.behun@nic.cz>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] mwifiex: Fix memory corruption in dump_station
Thread-Topic: [EXT] [PATCH] mwifiex: Fix memory corruption in dump_station
Thread-Index: AQHWKo7iqpnB4bBvFkC5wQNPqqS7mqiqXI/A
Date:   Sat, 16 May 2020 08:07:16 +0000
Message-ID: <VI1PR04MB43668507151CCB7810F5EEEF8FBA0@VI1PR04MB4366.eurprd04.prod.outlook.com>
References: <20200515075924.13841-1-pali@kernel.org>
In-Reply-To: <20200515075924.13841-1-pali@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [103.54.18.180]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1f77ae66-0994-4dd7-561e-08d7f9702648
x-ms-traffictypediagnostic: VI1PR04MB3038:
x-microsoft-antispam-prvs: <VI1PR04MB3038FD8D40635710AE17F06F8FBA0@VI1PR04MB3038.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 040513D301
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NlWIJJBJQgB5APd8d1vyR3qZTpLj61ld21nEEP/UGhq5YtqPFpWilxgCL/h5TBGMT/p0JKDEMpXiZz0FocvvKd160S23bFnhW/lSfBI7kXGuxb0yPU7WGo2rjNRa884iHxTrKe0AzVQgpkyaIU/TlcI4ZIw0wsKE0BOz/Yb0ObeXGkPCyFZpqjDY2EuR0Isp1msGy5xrkjfM2mSuVbDRHf1VlfIIs7X2lZAtfiXCLyvb1Yop522El7EHV2gIS0c12GNOz8YThL3Mo2izjJPQPXfMAe/xW1WGpG+z7P+D2aZTLUZOSXHyi1t40p/jZMI12CM1Olcjt3bx8iNBX+twNvoBMGvhNnumLJ+cDS3iIe3ICW5vDGdkE+iRVJaQzQXJiEk9aCKwFy1k8P5zKtQoJasnEKtJ6m+C/QHTgU2L6a8GD8fyHZ8yMkNvP+EiBdqE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4366.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(71200400001)(55016002)(8936002)(86362001)(44832011)(52536014)(4326008)(8676002)(76116006)(66476007)(66556008)(64756008)(66446008)(66946007)(9686003)(478600001)(2906002)(7416002)(5660300002)(186003)(4744005)(316002)(6506007)(26005)(110136005)(54906003)(7696005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: FDyaayofI9reXEjIIoMQoXpD198mzVt/1zRXledkFfNZBWKBJMN+ZGiRZn+6/SzGPbrsSyn9LxICRfI9w7CjOgUf4sAkACIneXU5iEq4EgUx5C+/TFTiKV3RHbWzo+0SXwvQ7zPtYVM5cD9sU3jJA4ctsVMkvjmb7qWf1fnNWgg8wKlTusTGRcNUYl5A5lG8iaTj9FLGygXmynLY+zB4u8ZboHWmi3bVTG2TuEk7yLPYXxFKFfAC55D5QGNedVR2qqacEJU4BULPi45kUc9h91h5ihWpJVJIGnPPdzK/Tee1jznuCvoNWlfs0iCVdw195ETFvjROi8UoqDsZjGDKjiEEYZkpXVXRxCzz+47aXPv8EiKuwZDDTfZTZGxzjRNpSt/uiq7TYRqO3Gz9R9cSP1Ucj1Q0niF3oBc0lLOPs2HUpks6j+oibBt4dxzLoVr26q+3PL4Nhz31phxWRWCdU6ggu+BGLbH2tPAZaV+icPk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f77ae66-0994-4dd7-561e-08d7f9702648
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2020 08:07:16.7664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TLeO4rjCceYKe/OM+FGWX5xtTF4/GRTjX6KYnq8j57ypgMUEF/XVjX85z3uLPShSzkjqxTTcoj3Q12LQU+mOag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGFsaSwNCg0KPiBUaGUgbXdpZmlleF9jZmc4MDIxMV9kdW1wX3N0YXRpb24oKSB1c2VzIHN0
YXRpYyB2YXJpYWJsZSBmb3IgaXRlcmF0aW5nIG92ZXINCj4gYSBsaW5rZWQgbGlzdCBvZiBhbGwg
YXNzb2NpYXRlZCBzdGF0aW9ucyAod2hlbiB0aGUgZHJpdmVyIGlzIGluIFVBUCByb2xlKS4gVGhp
cyBoYXMNCj4gYSByYWNlIGNvbmRpdGlvbiBpZiAuZHVtcF9zdGF0aW9uIGlzIGNhbGxlZCBpbiBw
YXJhbGxlbCBmb3IgbXVsdGlwbGUgaW50ZXJmYWNlcy4NCj4gVGhpcyBjb3JydXB0aW9uIGNhbiBi
ZSB0cmlnZ2VyZWQgYnkgcmVnaXN0ZXJpbmcgbXVsdGlwbGUgU1NJRHMgYW5kIGNhbGxpbmcsIGlu
DQo+IHBhcmFsbGVsIGZvciBtdWx0aXBsZSBpbnRlcmZhY2VzDQo+ICAgICBpdyBkZXYgPGlmYWNl
PiBzdGF0aW9uIGR1bXANCg0KVGhhbmtzIGZvciB0aGlzIGNoYW5nZS4NCiANCkFja2VkLWJ5OiBH
YW5hcGF0aGkgQmhhdCA8Z2FuYXBhdGhpLmJoYXRAbnhwLmNvbT4NCg0KUmVnYXJkcywNCkdhbmFw
YXRoaQ0K
