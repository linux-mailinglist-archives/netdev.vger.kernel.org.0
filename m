Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B892C2E0B15
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 14:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgLVNqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 08:46:37 -0500
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:47333
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726903AbgLVNqf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 08:46:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZFqi19qNoD7Wq+u8eGc3e+0OiqMJ+D9lpM9e7WTM+HAy+w2asYNFtn6cEM6W2OSo3ZqCm06sH4NFOOiirrqrOKgJGFSnI2W+PELYn4rvhMxGwQQNt7hSSV2cYIqXQNkCrwmB+pchMglCS4tY/IonWPkK63+nR74kUpsyEj+uYiYiLatlTaKNdo7X6+z4vZDkotSVu9vL/ESKR3ug5LDBUasK6r3NHRLEyO/Rpfskor83GQJfptqyR45HAmLUe52E7B4Zust23AWDEnF5vJUOeCLSYxJha9OxJNvrAVav7dejAa2JDTYYXPTTvlytqpOUyvwVfhn1OXbGG69YLSJDKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihX3OPKSo+AHL9ZIEd4ghwxdI8iXJQZpHM4sDqbdSDY=;
 b=liYqQF/cVPi5J4+3K+kpZSo+3jIdlqmeiqP32u4d3Eq2Xx3beHqzAkW4IaxBmaQxw7AyftA7rEhfO0JKtiDihq5FSQHOeJssZf1C+ddeLCVzvxehsMfJj/Fase6bFKu99PO6JykZS47/J/teJOUVDELbtWLJuVNM9qOQ7AnAKrA2ZoW9yvKT01lWZVd7P6VZZt+FOf9G0PsT8MUegbsFJxpQ+97DmhknlOD81dgg5ATkeCNNEzO430QvKH2aBydUNZ8JDm4h2YflkFUD1VDvTRFvF3DY5G5TSzoZZ9z5W1eAE4WsZYAfKVQnVFC/c6udp8VymVKux7b2Po/V/48XhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihX3OPKSo+AHL9ZIEd4ghwxdI8iXJQZpHM4sDqbdSDY=;
 b=W0mYwiuwo0302/te8B3mgTRfUKeBM2yUxy6WvbVXK9Q2JyrHaybEe7ECpVtQkr1Cr1keLcQl0CjO/6KqSAXoi9NDCGpUi37eYqbgrA9o0oOXGNFahAUY5K3cI6LqlfvYxWJec7RBMpZTjXjnXiDna9rZ6ZCFa+AjEZ+iAtMq1r4=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 13:45:00 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 13:45:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 08/15] net: mscc: ocelot: better error handling in ocelot_xtr_irq_handler
Date:   Tue, 22 Dec 2020 15:44:32 +0200
Message-Id: <20201222134439.2478449-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
References: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0169.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::23) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0169.eurprd08.prod.outlook.com (2603:10a6:800:d1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29 via Frontend Transport; Tue, 22 Dec 2020 13:45:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ff4f118e-dcad-447f-46f2-08d8a67fc75f
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7408602F7BF0ADAED0A00938E0DF0@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Oe/nd85wDQwbS4hOBzZXFArW6wxFGyVI7+5p+MqwegZ3kfuCs7Luh7SywSXcdolYuJaK9y35g+qGV5JiB+GofkaPP25/YY8OCqDpVPHggbK+90YHicNtZsbXheSSH/rY2VRweYucuVW9auolEWkziFNzy5QRHOQk/jnVYajasI3LUmIiqBMpj4YW0v4MJ8oTt3eUG6BtcQtibT25GKDS9evUkPhjDUxFjL5nfCbqujmCJuYLsjjHNaIO1MScQLWQuQEfjZ9ncV97AK41ULr3Nig3uqKwd8A8931vMxOSLRMLAr2U9oBZqkOvj2Q5kmCxarPKZ8yDTvB8zFbjoqhC5gGc1EZqgyazZxElUQuRLMus3cxftAtpWKT9atKm4zxbE+oGiU+7qb83uiJVJ/XEOCUM9voDsrVK5ggcsXnPtPqyfwPEssRI2T4gn/GSXNnXHgDmZfiA2PCp5icZ0aIqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(69590400010)(8676002)(956004)(186003)(4326008)(36756003)(2616005)(6512007)(498600001)(16526019)(44832011)(2906002)(83380400001)(8936002)(110136005)(54906003)(26005)(6666004)(66476007)(5660300002)(6486002)(86362001)(6506007)(66946007)(1076003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mjnq50gqolBJGXvpomLyqq6R8ie643KBUvi8TDYzijYoqO8q1iZ73zz0AhJs?=
 =?us-ascii?Q?4LEswGeDw0PJsYtWE6Dsxjs7gWuxV44xRaORcuCfT1KKt616qd/e5XHO8KSc?=
 =?us-ascii?Q?BCpWigW2yb3XtJPeMWJbXT7+UJKpM2bcFghmX5kd8wvrySlQxR0ngBYv/KTp?=
 =?us-ascii?Q?b/kz4p8+FPMIwx0F2XCv+v6Scjc9RX3facuxsAJpw6fmGY8BSBfAnuPrYdfP?=
 =?us-ascii?Q?7ZSSWABqA6R1vhiFv/J3u5WW45tvyWFZsFPGz6yoc3rUD7mEnN8dMPbg7XDV?=
 =?us-ascii?Q?ukETkWQQx2L+/qRJnJ1elwprJDkjxlfKDdRSyw/biXhydmjksVrCE3G3Z13W?=
 =?us-ascii?Q?8TD1vjewxU9TRn11H6qhGCtxAJNFO/6KUETGGyhXCnaGi1NqxOul/XAGbrkR?=
 =?us-ascii?Q?tNomGvdF3URLjrY9yGCAgwFiXCBibAviYY+EnbnTylQ6v9umHFrFIIbpLYgm?=
 =?us-ascii?Q?gxOX52tK6xQgcGlwWcwDvXkBTy92sBgApBBPT5oRugqFp2lG0QBwxsA7MWb+?=
 =?us-ascii?Q?CbVEyZwAwXZMrDznICJM+5HMfCe5tbwa2xJPFZGawgie5k0DlC+kiSJTyFqS?=
 =?us-ascii?Q?N3kzp5Py/KG/6taCzFb8861xJavmiqvNpr59b7yRH2sSvzBCA70iq32ZYje1?=
 =?us-ascii?Q?T2SbXIylVOgTJnn7jZL5O6k9gsjLSyvtttjASURqZClb+Nk7pXqqqgIjHhkT?=
 =?us-ascii?Q?2aIuX46iAsB1SXLhmWY+cQ070pTXDK1JNGxArCl0HCrWCq4lN+pI1JkaeLD0?=
 =?us-ascii?Q?oyrWNc0dfsdFeD2zWAk6wXqEhKi/KXjmvOinArALIaDYk5d/spfOFJYzHrkK?=
 =?us-ascii?Q?oifjDKrpRW6rFdKscUIU7ZaRexZFKOm4swY6/jgreyAk1PXjslhNJfzteeLw?=
 =?us-ascii?Q?FAl00o0rVxj9hzY1XN/IxTCvzRuZCSLs1ZDlsdjUluCKTFKxo9pU7wpspnQV?=
 =?us-ascii?Q?oruIkH0KxGcXUUZh6Dw2iCNdP8YS9s7gm5sTKjvBxwm18hhcG5pJpEcHEjQK?=
 =?us-ascii?Q?uggn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 13:45:00.6913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: ff4f118e-dcad-447f-46f2-08d8a67fc75f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0lW/8fQNwendWXb4EEWrRJUNC3x0XUuAM/sURbcEHcE2qJa81lIIp+PwX1aWj7K5i2NQGZxnpBwf4KHY8stXHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot_rx_frame_word() function can return a negative error code,
however this isn't being checked for consistently.

Also, some constructs can be simplified by using "goto" instead of
repeated "break" statements.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 52ebc69a52cc..ea66b372d63b 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -620,12 +620,9 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		for (i = 0; i < OCELOT_TAG_LEN / 4; i++) {
 			err = ocelot_rx_frame_word(ocelot, grp, true, &ifh[i]);
 			if (err != 4)
-				break;
+				goto out;
 		}
 
-		if (err != 4)
-			break;
-
 		/* At this point the IFH was read correctly, so it is safe to
 		 * presume that there is no error. The err needs to be reset
 		 * otherwise a frame could come in CPU queue between the while
@@ -646,7 +643,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		if (unlikely(!skb)) {
 			netdev_err(dev, "Unable to allocate sk_buff\n");
 			err = -ENOMEM;
-			break;
+			goto out;
 		}
 		buf_len = info.len - ETH_FCS_LEN;
 		buf = (u32 *)skb_put(skb, buf_len);
@@ -654,12 +651,21 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		len = 0;
 		do {
 			sz = ocelot_rx_frame_word(ocelot, grp, false, &val);
+			if (sz < 0) {
+				err = sz;
+				goto out;
+			}
 			*buf++ = val;
 			len += sz;
 		} while (len < buf_len);
 
 		/* Read the FCS */
 		sz = ocelot_rx_frame_word(ocelot, grp, false, &val);
+		if (sz < 0) {
+			err = sz;
+			goto out;
+		}
+
 		/* Update the statistics if part of the FCS was read before */
 		len -= ETH_FCS_LEN - sz;
 
@@ -668,11 +674,6 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 			*buf = val;
 		}
 
-		if (sz < 0) {
-			err = sz;
-			break;
-		}
-
 		if (ocelot->ptp) {
 			ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
 
@@ -702,6 +703,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		dev->stats.rx_packets++;
 	}
 
+out:
 	if (err < 0) {
 		ocelot_write(ocelot, QS_XTR_FLUSH, BIT(grp));
 		ocelot_write(ocelot, QS_XTR_FLUSH, 0);
-- 
2.25.1

