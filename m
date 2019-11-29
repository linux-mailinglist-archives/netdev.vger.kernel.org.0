Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6999410D183
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 07:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfK2Gkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 01:40:32 -0500
Received: from mail-eopbgr140072.outbound.protection.outlook.com ([40.107.14.72]:46343
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726167AbfK2Gkc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Nov 2019 01:40:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDowuePTE+btKftCPn0XwDg4qDTILw6e1Ovdg1b8EGLhAa3ZhVyJGQkBx8n0yDl6dsTnQfgheLFVVepZ119zqZc+Fh2A215Oal8AnzLfCAhimD9gsZsUK7h2Jmz9CCUlNllIHIp4FvZ6dQ/FWFu4h1FAUi3lSYr5iGMz/l1ddgkFXBt8JgNCyBWnZ+NN367rDIwRC/M5NyJh2RvMNTAtGijKibUUjomDH28UCByHVVS3Okj7ocFuOqPGkt0cgZtkqnT1cU2rBQu5pMnxl/k3c+dw5VPXh9iH90JmoNPgm0IhXLxKJm5wd4zwa8hJHK23h3zRVrID+/z5CJLCLlAP0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCUydzmr3zPewKIAQzB1fwY1XHA5u/ZnHLWwm5GXQ8E=;
 b=XR6WYWn5kq1XSR6x/7uSgfz/nYlBIJgqGKWwfUVvN8VK1iioEb4hxhX/L797CpNnfLvIikATgdwihsw/G//6f3g/fqOtKbC139fje34/THG9Cw7Rlxk8KcrIOOyRwQF4V3TSWQb66cMuNMQg5/mhhxbcVkM3wuzEooH0N3jsN1y9r49WJGzGn5RAcTrp01+hJFolcV6j7cCkLa9XwOJnLDLBApqVqshbsiO5kXiag1PU9enn00QEMHz2nDQa+sUcRqN1i6NxoXRPQdVzNRHdGuqHZDLmD+/QgnDLdsVQEIl5WthyvUwJ8/gPmes8G28zArjdzMgA2Cbg1WtgtXP7yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCUydzmr3zPewKIAQzB1fwY1XHA5u/ZnHLWwm5GXQ8E=;
 b=U8VMhIX0pgRgKl8zv31dcMy7+g3ep4UnlY/ZWnIWP4z4/W94A+UdATqb0rhs0dS6OhMEvBXgbRVkl1M2xP6TNDHjbeERz5uIzLenOqbR1QG4OqCkXANvZfIT43416KL8d0PAdTETE+xjEMDqdTcyQGuARtUijS8XNckHUB0BoI8=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3838.eurprd04.prod.outlook.com (52.134.16.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Fri, 29 Nov 2019 06:40:28 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::30e0:6638:e97c:e625]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::30e0:6638:e97c:e625%7]) with mapi id 15.20.2495.014; Fri, 29 Nov 2019
 06:40:28 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andy Duan <fugang.duan@nxp.com>
Subject: [PATCH net,stable 1/1] net: fec: match the dev_id between probe and
 remove
Thread-Topic: [PATCH net,stable 1/1] net: fec: match the dev_id between probe
 and remove
Thread-Index: AQHVpn/jrt25MiDjN0mpVyW3r4862g==
Date:   Fri, 29 Nov 2019 06:40:28 +0000
Message-ID: <1575009408-30362-1-git-send-email-fugang.duan@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.7.4
x-clientproxiedby: SGXP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::28)
 To VI1PR0402MB3600.eurprd04.prod.outlook.com (2603:10a6:803:7::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fee2511c-9c54-4d19-f708-08d7749705e4
x-ms-traffictypediagnostic: VI1PR0402MB3838:|VI1PR0402MB3838:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB38381F4B45B6320A10ECD015FF460@VI1PR0402MB3838.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0236114672
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(199004)(189003)(4326008)(54906003)(71190400001)(6512007)(5640700003)(6436002)(6486002)(186003)(316002)(71200400001)(102836004)(66066001)(2906002)(26005)(2616005)(36756003)(50226002)(52116002)(25786009)(6506007)(386003)(8936002)(6916009)(2351001)(81166006)(8676002)(256004)(1730700003)(81156014)(86362001)(2501003)(3846002)(6116002)(66556008)(66476007)(99286004)(66446008)(66946007)(478600001)(5660300002)(64756008)(14454004)(7736002)(305945005)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3838;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 80b+YgsRH26Ot28jhHwE7MbsY57iz+HO7EmR6QqPL+ENgg/mW+mCOQsSwSTTdsJ/0wBs0heO7ZG391AfmTmyKtA7txHZ3suUnVDXmny4ze1U7l6mEKsAUi19a9FCtazpvN1DJjM90mSRF7dKVXfFbFv5ZggSn//RI+l0vyTg8mZscZCnFJTL36Wgmwc9LhPId23+HAFNwZrWItJeHYBzzvOC89GuenLF2W5lbBQqvTsPekxWOnvEttkY4tNuTyFuXaiclvQAb/9kNuRcJQKUkTRkBYGhlxKLtJ0vTxDedBec3RWegVSk7rJXvsKLaV1m5arkM2rDIh9ab2ddP018ObprMdhMgtL3qwv5rwGtjjqnU44pq0hTOv7dHUCVuu+SZw+yMxpKecUgy8ocm0gSPXxOMVC5n05n4ccD9/BZ2uB0/o409/uAF3iHiPNaLVO3
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fee2511c-9c54-4d19-f708-08d7749705e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2019 06:40:28.6038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A16g4tp/sEepxG6wR8gj1GqZZx1bxpa4EF0kDAAa1dZYreGDseLVk1G5BIzlV2Xfm4GetQmc/ULYtfQ0lNGJvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3838
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test device bind/unbind on i.MX8QM platform:
echo 5b040000.ethernet > /sys/bus/platform/drivers/fec/unbind
echo 5b040000.ethernet > /sys/bus/platform/drivers/fec/bind

error log:
pps pps0: new PPS source ptp0 /sys/bus/platform/drivers/fec/bind
fec: probe of 5b040000.ethernet failed with error -2

It should decrease the dev_id when device is unbinded. So let
the fec_dev_id as global variable and let the count match in
.probe() and .remvoe().

Reported-by: shivani.patel <shivani.patel@volansystech.com>
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethern=
et/freescale/fec_main.c
index 05c1899..348fd8a 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -243,6 +243,7 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
 	(addr < txq->tso_hdrs_dma + txq->bd.ring_size * TSO_HEADER_SIZE))
=20
 static int mii_cnt;
+static int fec_dev_id;
=20
 static struct bufdesc *fec_enet_get_nextdesc(struct bufdesc *bdp,
 					     struct bufdesc_prop *bd)
@@ -3397,7 +3398,6 @@ fec_probe(struct platform_device *pdev)
 	struct net_device *ndev;
 	int i, irq, ret =3D 0;
 	const struct of_device_id *of_id;
-	static int dev_id;
 	struct device_node *np =3D pdev->dev.of_node, *phy_node;
 	int num_tx_qs;
 	int num_rx_qs;
@@ -3442,7 +3442,7 @@ fec_probe(struct platform_device *pdev)
 	}
=20
 	fep->pdev =3D pdev;
-	fep->dev_id =3D dev_id++;
+	fep->dev_id =3D fec_dev_id++;
=20
 	platform_set_drvdata(pdev, ndev);
=20
@@ -3623,7 +3623,7 @@ fec_probe(struct platform_device *pdev)
 		of_phy_deregister_fixed_link(np);
 	of_node_put(phy_node);
 failed_phy:
-	dev_id--;
+	fec_dev_id--;
 failed_ioremap:
 	free_netdev(ndev);
=20
@@ -3653,6 +3653,7 @@ fec_drv_remove(struct platform_device *pdev)
 		of_phy_deregister_fixed_link(np);
 	of_node_put(fep->phy_node);
 	free_netdev(ndev);
+	fec_dev_id--;
=20
 	clk_disable_unprepare(fep->clk_ahb);
 	clk_disable_unprepare(fep->clk_ipg);
--=20
2.7.4

