Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C83E5BD202
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 20:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441553AbfIXSqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 14:46:01 -0400
Received: from mail-eopbgr60117.outbound.protection.outlook.com ([40.107.6.117]:14870
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390679AbfIXSqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 14:46:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVOzZjJF6IQTodoAlnZfrAifUmBhdpDD+6vnm6K+KlApg8Qk0RcW8VwbtCbtXGQVqHvUxeOHS4XseVlZFKwuQEn7PujgaoS9IK8r2zcMhLpitp0udWxaYyduQey5AWkONdXozVDAnv4dT9314a2vuyz3Saf4gae5zguXzSL78e0m3J2RIwtX0iclJ16X/6GXEiXorGZTeZ52iNf8iWQHMIY1CzO4tGPjP5et2utL0zVU1Gsqt9heiLOb/HeJ4spNdt47VHFpjliknxe6ik8yibRZ8J7AwOWZpV/Xv59HpZYSgqPupRhktU71Ew2G8dOXyOgK2puVhZ5JmuAQXuXZvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ad98l8G/9SnCp974tTvhTEUH74vKm/7Hw1Rie/IGOJU=;
 b=Z99dFht2zowT7HpyBtXZCBqJ6DMnbA51ockyX83MBjF4wGNKrVSmyp6PAw5gH0NNaCe30S16ElGATKzw4mDCugjvPQ56GRnrerZ+mXa4r8YwZLC08qyMKTP42Cq1Nc1JQ/LIWOnUPudtu+AUhlJR42Vaa06+quFsj35Zt3UxFvlOGw4fl/eUI9W72xf8LGITx96Q6DDDY1nV/iBz0c0kVjqtDY09ANPMBXbHwqZOFYfhjXI0XnE9xaLZcbIFO0yT3NX9vRD6K8McCC9Zqj7BgMqWyIGHoRqKo5jxSMjGzy2NX7xhCbA/ERhLMflxGzTaiXi3OwlWCisGd6zcrWgsMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ad98l8G/9SnCp974tTvhTEUH74vKm/7Hw1Rie/IGOJU=;
 b=Ia+i/+bjX/tm9svmk+DOaGQaDn9Pv2/a6bhCu6fUhRFm9TfkjHm1PdSZBHNnLkoChNk6oorce8WNC/Bk/z6Q+/65/gMWhNxb3hcSrw3Oq5YeHMuuHH0TkzgReGbNhBZvjp0k/5mLoC3tdgTKJ99onNSxO4I5eR765DBpYAnsGg4=
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com (10.173.82.19) by
 VI1PR0701MB2238.eurprd07.prod.outlook.com (10.169.137.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Tue, 24 Sep 2019 18:45:56 +0000
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1]) by VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1%8]) with mapi id 15.20.2305.013; Tue, 24 Sep 2019
 18:45:56 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] can: ti_hecc: keep MIM and MD set
Thread-Topic: [PATCH 4/7] can: ti_hecc: keep MIM and MD set
Thread-Index: AQHVcwhMqThAVfH050CEsrtMbg7ETw==
Date:   Tue, 24 Sep 2019 18:45:56 +0000
Message-ID: <20190924184437.10607-5-jhofstee@victronenergy.com>
References: <20190924184437.10607-1-jhofstee@victronenergy.com>
In-Reply-To: <20190924184437.10607-1-jhofstee@victronenergy.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:1c01:3bc5:4e00:c415:8ca2:43df:451e]
x-clientproxiedby: AM0PR01CA0138.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::43) To VI1PR0701MB2623.eurprd07.prod.outlook.com
 (2603:10a6:801:b::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 806f6255-e55a-4aa5-a3ed-08d7411f6f2b
x-ms-traffictypediagnostic: VI1PR0701MB2238:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0701MB22381BEFE7F4EC175BD9E50CC0840@VI1PR0701MB2238.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(396003)(366004)(39850400004)(136003)(189003)(199004)(7736002)(2351001)(6916009)(71200400001)(186003)(81166006)(386003)(99286004)(52116002)(6506007)(81156014)(102836004)(76176011)(4326008)(71190400001)(46003)(6116002)(5640700003)(6512007)(36756003)(2906002)(305945005)(11346002)(446003)(8936002)(25786009)(14444005)(256004)(6436002)(5660300002)(86362001)(8676002)(476003)(14454004)(50226002)(2501003)(54906003)(2616005)(1076003)(6486002)(66476007)(316002)(486006)(66946007)(64756008)(66556008)(66446008)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0701MB2238;H:VI1PR0701MB2623.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mMh4wP6f6BwVfAvycTM/Yr5Fn7/+ao9nZO1Y1cF0doelR+8Ay73Hto0Uvj81S8noZFmSraLwEIkMTT//tQU0Afe7mLkX3slEEpvNVw6vgHEzTFi+knxrLT63Wlv2vhScKYB8omPCr6EK7NM2gYDY5uXdllETJtq7HqN4M5keG1Zfh/HJm7AG/LVrKzhZimmU9yUOBPFDr9o+juE/AlqdHl/wkkOUPlEeFYXRrjNCVvfzA8K/puhGgITQ3fhD1F+Klp1GIT55aVXH/xW3z7E+mB/FEA2zeFKIgDH9FRQLpqv16TsG5H4ak+8coAq3P00r4eVST5tuWydZXYpN//0dO5WJZvuTsyXcQI7wUVr9x4Tn+WtQiFWpOz8B8+ds6z81iKXKdi50RcNwnV3Y4kfSNUiwgqq8Zwgp7nL+iwAIyAo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 806f6255-e55a-4aa5-a3ed-08d7411f6f2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 18:45:56.3276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GHlf2hWWifeP+WVTdSc5is94/14eQjNe2oHsujz7fKtmiKAwhw738ciLgKaMNm9Ptgt6ykH40k3Q4pS91Z9fTFimHKnzyI0z4Ug/7AHUqdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2238
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The HECC_CANMIM is set in the xmit path and cleared in the interrupt.
Since this is done with a read, modify, write action the register might
end up with some more MIM enabled then intended, since it is not
protected. That doesn't matter at all, since the tx interrupt disables
the mailbox with HECC_CANME (while holding a spinlock). So lets just
always keep MIM set.

While at it, since the mailbox direction never changes, don't set it
every time a message is send, ti_hecc_reset already sets them to tx.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
---
 drivers/net/can/ti_hecc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index b82c011ddbec..35c82289f2a3 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -382,6 +382,9 @@ static void ti_hecc_start(struct net_device *ndev)
 		hecc_set_bit(priv, HECC_CANMIM, mbx_mask);
 	}
=20
+	/* Enable tx interrupts */
+	hecc_set_bit(priv, HECC_CANMIM, BIT(HECC_MAX_TX_MBOX) - 1);
+
 	/* Prevent message over-write & Enable interrupts */
 	hecc_write(priv, HECC_CANOPC, HECC_SET_REG);
 	if (priv->use_hecc1int) {
@@ -511,8 +514,6 @@ static netdev_tx_t ti_hecc_xmit(struct sk_buff *skb, st=
ruct net_device *ndev)
 	hecc_set_bit(priv, HECC_CANME, mbx_mask);
 	spin_unlock_irqrestore(&priv->mbx_lock, flags);
=20
-	hecc_clear_bit(priv, HECC_CANMD, mbx_mask);
-	hecc_set_bit(priv, HECC_CANMIM, mbx_mask);
 	hecc_write(priv, HECC_CANTRS, mbx_mask);
=20
 	return NETDEV_TX_OK;
@@ -675,7 +676,6 @@ static irqreturn_t ti_hecc_interrupt(int irq, void *dev=
_id)
 			mbx_mask =3D BIT(mbxno);
 			if (!(mbx_mask & hecc_read(priv, HECC_CANTA)))
 				break;
-			hecc_clear_bit(priv, HECC_CANMIM, mbx_mask);
 			hecc_write(priv, HECC_CANTA, mbx_mask);
 			spin_lock_irqsave(&priv->mbx_lock, flags);
 			hecc_clear_bit(priv, HECC_CANME, mbx_mask);
--=20
2.17.1

