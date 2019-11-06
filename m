Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F75F1A09
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 16:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbfKFPcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 10:32:05 -0500
Received: from mail-eopbgr20126.outbound.protection.outlook.com ([40.107.2.126]:44006
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726926AbfKFPcF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 10:32:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iibKXDcZeXz4qmrVqM3eeExQ+bev9YKT2NjAUuCV9YdhlHqc+EaUIhNOoIoYrYf85C6UrH2GaVWB7bBn6iv5Z8bfCtkpDBw1drX/EaFwgNDkOyPFnaofdT5KrP5CqGywmVfEZ+py4zkmtbDPnAbYzh6Iz6GVYiBzeGuXhQ/aDieVXhliZxBpWvZPib+yN/l2Mut4OE/OIOMj6UISilUizjXsbJKo6SpxQ5/ZWHhDdjzQHv6PXYiPU5eEgx8XTE0mWzfJXkvIb6hMtO4FGH9PpXf1CiaKgVt1UFLsoR4lObgCl8TDU2KwFObIkSjwnxlKWOjqW2j5rTW6hjGNKUBTqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUxUPpnZurWogiaQOaPlWG3QUlcqfEe+ea1w7Zv1lQs=;
 b=BbpALXKtFcgxuVGCC8PQupZI8luokLwMa+6GhDOHVzcNICN/8sGsUJIszmVGmy/yyy2bXVwsohf+Y8nLpSd3Dr8ma6sLwbbgDI2E7RuQOH3jsSGcVqW8Lri5brw5YSuaWv6HHFr49rZzWnKJKUpE+FlRLzsT4U9JQ22PJEVSAkFdVo1pqTPeYJ5vnWRywUN3banf5EXgaEDE3M0vERaBwMr3zPtpdncHYCwJLtwplGTR/LYLw7eLy27LJMfDcLYVN19hxSx6OcLKhptr+L0z0Imz09M8xPrRP+mvv370iM8nfboYFfHzKZyjFAsIPCfEru2PdQ1c7bQ8iw0CTNW0Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUxUPpnZurWogiaQOaPlWG3QUlcqfEe+ea1w7Zv1lQs=;
 b=ISgZLQ3VVp25eLmdjKZdpW3epWyLQCQ1PrsAB3009yhvvgZG31TXRj6/r6tWKClRxtqwVVJy/FCA5EvfUcZHDenIvfgJvGst6J7oBP+FXZF2XLQ7vyyNpzUQqFhuKEDaz81K6fw4Kw47PevjFlgsjc74iS4w6Yk2raWji64mVz0=
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com (20.177.203.20) by
 VI1PR07MB4031.eurprd07.prod.outlook.com (52.134.23.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.16; Wed, 6 Nov 2019 15:32:01 +0000
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::ec3b:5048:b5f7:2826]) by VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::ec3b:5048:b5f7:2826%5]) with mapi id 15.20.2430.020; Wed, 6 Nov 2019
 15:32:01 +0000
From:   "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>,
        "David S . Miller " <davem@davemloft.net>
Subject: [PATCH] net: ethernet: octeon_mgmt: Account for second possible VLAN
 header
Thread-Topic: [PATCH] net: ethernet: octeon_mgmt: Account for second possible
 VLAN header
Thread-Index: AQHVlLdVEVn31S00D0CIbK0C4jwKfg==
Date:   Wed, 6 Nov 2019 15:32:01 +0000
Message-ID: <20191106153125.118789-1-alexander.sverdlin@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.228.32.181]
x-mailer: git-send-email 2.23.0
x-clientproxiedby: HE1P192CA0024.EURP192.PROD.OUTLOOK.COM (2603:10a6:3:fe::34)
 To VI1PR07MB5040.eurprd07.prod.outlook.com (2603:10a6:803:9c::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f3f194e0-4bb6-4586-6f5a-08d762ce780e
x-ms-traffictypediagnostic: VI1PR07MB4031:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR07MB403147B5CB1BE91DBB46B35088790@VI1PR07MB4031.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(366004)(39860400002)(136003)(376002)(346002)(396003)(189003)(199004)(1730700003)(66066001)(50226002)(5640700003)(8936002)(99286004)(256004)(102836004)(52116002)(6916009)(14454004)(14444005)(478600001)(71190400001)(15650500001)(6506007)(26005)(81156014)(7736002)(305945005)(8676002)(81166006)(386003)(86362001)(316002)(2351001)(186003)(6486002)(6116002)(5660300002)(3846002)(66476007)(66946007)(66556008)(6512007)(4744005)(2616005)(71200400001)(66446008)(64756008)(2501003)(486006)(25786009)(36756003)(1076003)(2906002)(6436002)(4326008)(476003)(54906003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB4031;H:VI1PR07MB5040.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1+6Ajk8L6DOpyuhEQ7cOgCilZoH03JtIaiZohH/0D6JKX4Ass8JBL1KrBokooiEivkU1hiUEhoZHuZNjsVxakPAecxEhhrUpukzlNh7V0r5LQUPoPDe7hfM6tufJH/LEBqvUAOp9BQ+k9rxQ3o962N38hBx/7nnvQ5S79OvFgrKBrBEGljU8D7GBre37t268gM9jcLmxiFEcTF7YtIGjDI6d2/FgnFw999VhOn3BIBh5COQML7/B/5K/1mHYiENmGS/6YPQVJbPzRG4N6qtoQpQAPf5UTFqEaf/Vrj2A7f0V5WE9W1uwyQa09+5ID67iXTrSQbSqbVfCJAGeV0uUS9UWs5SOsJA8zHf5TTkHRnX5xSOqdWHmVsgYEvogTQAsQRiQic2coPx8+i1DYTp2ykGg8OgnUkbdEQZAXldm+XTNiyzDkCYab5ndUlcq994K
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3f194e0-4bb6-4586-6f5a-08d762ce780e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 15:32:01.5740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QcMOgszfR9vJS4woNWN1Cn/h95VPIZvATdtAyXDdDt7ba8kCymtCVzZ4e4ysrrt4eppghBHfFa3WBV01MM1KCwiJx/cXFXIXwAA3qXxhw1U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB4031
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

Octeon's input ring-buffer entry has 14 bits-wide size field, so to account
for second possible VLAN header max_mtu must be further reduced.

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net=
/ethernet/cavium/octeon/octeon_mgmt.c
index 0e5de88..cdd7e5d 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -1499,7 +1499,7 @@ static int octeon_mgmt_probe(struct platform_device *=
pdev)
 	netdev->ethtool_ops =3D &octeon_mgmt_ethtool_ops;
=20
 	netdev->min_mtu =3D 64 - OCTEON_MGMT_RX_HEADROOM;
-	netdev->max_mtu =3D 16383 - OCTEON_MGMT_RX_HEADROOM;
+	netdev->max_mtu =3D 16383 - OCTEON_MGMT_RX_HEADROOM - VLAN_HLEN;
=20
 	mac =3D of_get_mac_address(pdev->dev.of_node);
=20
--=20
2.4.6

