Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724D647A939
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 13:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhLTMJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 07:09:16 -0500
Received: from mail-am6eur05on2074.outbound.protection.outlook.com ([40.107.22.74]:43712
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232250AbhLTMJP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 07:09:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/V6JQNprpBaOi56CRB5F9zfB+EkSnOcGl43haBYyKqQ77hLmcAPASC9/v9hMd/NlsdZdLSxrEkOwxraoHoOBl3YFkfzw837AfPuBzNxPjH0tearbZCKsbShjZj3hZloj/XEkzj0cYV4w9Tzq8QghhUSuqgY8nSFCNxihCtG+Tpj4ZXgn4hstc7xJiJ/FQ+P9J8Q9pCj1lZ08Gh6gpWYic5Kb8S8DGpe8PBkHpjAm2oQN6GumNb0fROLgNr7q0Y7Fl0TYAHUGaSBpmL2qjtBRfauBYTB3uWslfcOYYxmLh9zIPMrPEa2OdhdyVTcAgibSS8sJzbCl3Oj1r5yquTOxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xiKs4RbiP5F3ZJi95EuDmpral1G8vZjBHAv7Lci9Z4A=;
 b=HUXszB5/xTp9i2GdncRJGbLzEyiMZ37nDsVy2rGZV2Dt+HyOja7/kinNFdAtxQbXEFUuF1aP1wfUdTBTNcPwndHNaRrfymSq79QrJy8f3k15JyezPnkaNWE+m2GcR3qets0pzBMKRBE9XNDzsQ2N3pEo0cHWsSyn9pqUkUogQ2CGpPu7RLIdW3TV6Ue2Eq3uB5B3haD3MUYJT0XnyJLv5mw4fsPzTNX5++2LZ6FKOSDZ93K/cWUd2Njx6vjKmv+xQDNQnechCAMI0oTxJy34kVPkhbao7F+8oADZ7WKLVjZlA0WYUJN9bj1MsJw03E6xnEHxbDzuuVtDbabY/da/1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xiKs4RbiP5F3ZJi95EuDmpral1G8vZjBHAv7Lci9Z4A=;
 b=WQgNNZxIc+Up0qEb2JvzL1Bq+Ga2sG/9DfeJUXWFgeIog5VxrIhXVbgolwYVEPBgeQZgqmPeRJQfidl2Ie3SmsXJm8gRhjzof82Onjf1DUI15pCR/Kn8WPbmIux9po/kWgs7/e9o012ve4dGHrlj64Bf09DRAC4qqKwRg0bGZJo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AM9PR04MB8825.eurprd04.prod.outlook.com (2603:10a6:20b:408::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Mon, 20 Dec
 2021 12:09:10 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce%7]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 12:09:10 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     christian.herber@nxp.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH 3/3] phy: nxp-c45-tja11xx: read the tx timestamp without lock
Date:   Mon, 20 Dec 2021 14:08:59 +0200
Message-Id: <20211220120859.140453-3-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220120859.140453-1-radu-nicolae.pirea@oss.nxp.com>
References: <20211220120859.140453-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0069.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::37) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5dc467e4-69f5-42a1-a15e-08d9c3b1877b
X-MS-TrafficTypeDiagnostic: AM9PR04MB8825:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AM9PR04MB8825B7A45E075142FDBDDC969F7B9@AM9PR04MB8825.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dGEvT+RWhiqxeEO/noCgOq0/uuv4yMILxmkgUTKKiqMwhbkxgptkV4ZGFjOJr2B6u/nWEtA7pw/ylAxExBS9KMnnL4TWouOlUyNwQfzoH5QTa9PfeJvNsRpzgfaDOKpM9nXAea499+5eFZkUV3tWc4sfN2lNKoAxDkBxCwHBOGNzzuZdPPLsSE9LshT8/Ix+bblulT8CG2OWE2Gm3DG1LvLjFDEQFWihFFg1isWdVzpB+xt+jqZyoJm5fxkKxH/p+czm89mjPPKfZ3gHov0Lg8644L8iQMUDOH+V2PNDn9v8b8t98vRYvQcBJ2K1X69NsOhyVajb+ujgxQ04nD196tE4J4mYBkm7Y4y3gIOi3s6Yb7CKF6+lNXZPoSJVjWVLosOrQtxFuue5mFpp7ip5n1GxgzDQAwFjDRfRu4SnVJS0YBmnpqpSN456jJDymy60BgZyqwulW6HXNKMlNoqrkrftVtJBJVAJ7u80Fkgldyi7+RfxYvKKuHU1tu7U3FX8tKajCoSjPEnmFm/YxB3m51Zy4XrlYWaajui4a7JENxgGAlb/QHQ5sb4p5H8esPoKlmpmIXs33F3Emb1EFqpC78kTREK/cp69iOFymAEGeMPuN6pMJpT5P3gYonMKKutH0Z9Pr3gF6jXaQWw6kndlZIryIc57TJ0elVLNaMhvPdMgN6titSN5gsAK+HAwNOjfJWPfY7JLeaOxAH/qHWzEIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(6506007)(6666004)(4744005)(26005)(5660300002)(52116002)(186003)(2616005)(8676002)(6512007)(2906002)(8936002)(86362001)(316002)(38100700002)(38350700002)(4326008)(6486002)(66946007)(508600001)(83380400001)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HyTCyKcWHJzIjIpO/0VGplD2C5vHAY5raxCb3MiACJI897c30Wr0FxtoxNnk?=
 =?us-ascii?Q?1cCF49w1AHR1YA265ZMq5l/uvddRK0+1G3syS8Uk/XwAEm1wVBr/x9Xx1yMd?=
 =?us-ascii?Q?SQfPyxuiFNnbQSSldLE6f3yFUcCuj3TPS8Q0EufHd+7FF6xKauS3Acf7yuS9?=
 =?us-ascii?Q?3kP+Ezx7EpRu0AkT72l2cqyFfJwnLut537cp/e8pdPwuoPkWOo5K9nUKq4Sk?=
 =?us-ascii?Q?CFaVpBhqwlPoqowODqK3td3V/DbAREaIFpbNOCkFeHOmUW4gwgL2dgUFscAD?=
 =?us-ascii?Q?aMJjRtFsBmZTMSROo1iBfL5umom9Mvpzc2wc8AGfnyAewxfjz8pBuWOMD93L?=
 =?us-ascii?Q?0XJBP+iCBYgKdnhR+190SBtzhtkfyHucTFZsMKIDTTxMBSKyJs6geiJ5ebTi?=
 =?us-ascii?Q?HRXNFvv9Zi4YDBBa4j7ej5pcnLx/ulcgPBsHIOC23w49o1wIotcUT+WRGtpS?=
 =?us-ascii?Q?ruKD+rMZ6TU90B+fy2iQeE5e+bLSdVEsCK4boupOdyU1g12G6hugczIAV8ms?=
 =?us-ascii?Q?aQ2qmu5DbLKah4uJyJMsqfwMNx1jJ3H8OkmKfOp2ZzxtafhfjvatRR/ey71P?=
 =?us-ascii?Q?h9Y//ukxJWWbVVvWNlG2lTkXPwwyiEV9DBQNJniR2XQ7sYg5RHVHQN1qF6Jg?=
 =?us-ascii?Q?sTFUMMmJSTlwoJTUCO6y1x1GUvFRDvHJMoSu1Q6tAlUeGAp/Mn3PuLua04t+?=
 =?us-ascii?Q?2XMy8xiWZ9AHq7b41FDmLE9awLGMa6/S5USL42luLqd6Xtd9I6DvgGFlwQeD?=
 =?us-ascii?Q?j5D1oLnnWrybMV3FdtZbphXy/EHgYa1szkVZRbDS6MIfWakCraVwjBLgEl+z?=
 =?us-ascii?Q?DsMhsOt/7iIeePmyHcg39Cr3LNFXh9+6K+jlXtGh6pZErTmn+hqSD3PIqU3S?=
 =?us-ascii?Q?OER8drwc/JbRYKOrkETOC7B8H2KQjuNGvBDGn3feXIZaeT/+2FGaLOVxKNPg?=
 =?us-ascii?Q?A/PTGdXQVCdZE0zL8KnTraoLnmSkXRb68fHUmC0Hoqyy6awV2xAij9rqlciR?=
 =?us-ascii?Q?rdlKhKGquoF6vAZhNBWSM0pa8/kVG//J1FLxmoJjxYs/X3h+kllnaDneuSq5?=
 =?us-ascii?Q?aasWVg7knPhrOb0Vyx1f7OQ4POdke7AZdLG1N7a8ip/qNRxENOvL9UBK2z4u?=
 =?us-ascii?Q?rLm4rGsN43a6qy7jBWGKlhzLMszef+dsClQ5OVKTM1lMzwpgQZpO8zcyt+EX?=
 =?us-ascii?Q?xfsOWEDzxwPtcFk4re2LkYFEu5Nl6zkyW9SIj6E9Z8sb32pw6MjlDwHdQLsa?=
 =?us-ascii?Q?ciShL9SmTq9Jf1g6QvC/N9fiHd6pONcdH8GkpU9LEJpAYQsn7l4cbIvy9UvF?=
 =?us-ascii?Q?O56MEGYIM2EUV4BZ0TnsHX1lO9PWQRO4LF2mzWA2A9gErQ2q1WsblDh+Ew63?=
 =?us-ascii?Q?QrLdb1yzN+LJhe4pQ7oPEu+LmP2w1SCj241KJEsM6TucQ2E6r3oEUvCA/ceE?=
 =?us-ascii?Q?rGXHcOmFlWLBRixumNKQ/iB/clYlcpUqual/tXfOMIiygedSV4b/X5XcXVvl?=
 =?us-ascii?Q?iAcufn7bTyPfZkrt3x23gsnFYdID/q3kdKwFzaHoBZNV0QzywzBoN8jq7AGI?=
 =?us-ascii?Q?r4wz/hWNPjZTlt2bKy7mXthryJN/IELDGfLhlfTUYguUfnOh8XjTphcBIaPG?=
 =?us-ascii?Q?9En6xjkvjWvZzeeh76s6iZQ83yndN/kgmpLQWX4yB++MJLC4uSoZJAzTZ2Kp?=
 =?us-ascii?Q?W9j8+g=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dc467e4-69f5-42a1-a15e-08d9c3b1877b
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 12:09:10.0723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WJqTNnKPP8WsC3bF78gVtHCZmSY0g5KkWu6EjMYxJjc/uESWYo7iMxeRDTRRH4UYepphp1cRuLHvAONTEPcnJrXYdTYJ+bC+J4cvmth6KbU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8825
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tx timestamps are read from only one place in interrupt or polling
mode. Locking the mutex is useless.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 74de66c90f24..5bd8c166d726 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -381,7 +381,6 @@ static bool nxp_c45_get_hwtxts(struct nxp_c45_phy *priv,
 	bool valid;
 	u16 reg;
 
-	mutex_lock(&priv->ptp_lock);
 	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EGR_RING_CTRL,
 		      RING_DONE);
 	reg = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EGR_RING_DATA_0);
@@ -401,8 +400,6 @@ static bool nxp_c45_get_hwtxts(struct nxp_c45_phy *priv,
 	hwts->sec |= (reg & RING_DATA_3_SEC_1_0) >> 14;
 
 nxp_c45_get_hwtxts_out:
-	mutex_unlock(&priv->ptp_lock);
-
 	return valid;
 }
 
-- 
2.34.1

