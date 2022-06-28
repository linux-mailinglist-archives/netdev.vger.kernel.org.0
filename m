Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4207955F129
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiF1WPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbiF1WO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:14:57 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80079.outbound.protection.outlook.com [40.107.8.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35C739177;
        Tue, 28 Jun 2022 15:14:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eomz4SRN0EF2aAIKc/lYFJ8MYAh/iRo4kOeSEu+D/nSxOvWFlf4X6anicsoUKW5rG6rxT9O//+1Pw2jnwQjM0G2QGniSAh6XWKioGE8ty/bNzYZYiCcU35yn8yP7P6GNtlouckzeIKLV8tTG+WFwxvHAMq5Hc01mNxOI6QLZktQeN8+OeSpOjqwCwr0Q2is4aas6JTKjSha6hCs3W2cihJZAwoAJ4C4eh49A/Fm/DjY2IdOGrx7owUMg28WcQBOkoy8PQ7BgB9d5HqQtpABR0sgwemwubu6FyxXAoXU33NEODi/oFJhjALquwV1Krcm/5ID39x9T6UTIDN5OyKhPMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9L6FnTqvCduyYhxu+YFwE1dDeiGhnmXGiGrEHy0sXGs=;
 b=OL15lotRnVZGQlB48q+xtVP7DuZgYXt3iVqQTtE9/XkP+Pap/QRZ48GMp0VMd2KsS2Q/9yHmY/AaXJWpLPuZjSRw5Z+FjF97vR8D9VL1rwtg/uHbBxeIX/Y6wKB24Uz3wayjjGwLWsGBc9V8mdWFJQ04RyTZn6PtanW+zJOcx+8tgIb1fYrFGUz9uP+8nbWIOF5/z0C/xUrjhITalZu/P3PWcNQb/xZU/NBCDnjS9RH5wm1hC39wVlPgUU7r25WvbOaY+zfB0Ahch+U4ktlCzckZEIvMlpaUwtKNLmora8ElkNkBkSaAI67jje7QZjA52pv6f8sGpRNP5SgYmGiDIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9L6FnTqvCduyYhxu+YFwE1dDeiGhnmXGiGrEHy0sXGs=;
 b=qqFhGzu0weOs5ScbDS1iqBXNwSwmDEM690T2s3BcKYOc4QIbNsjgwB+MyLD26WQWdeqoYmzSiFLrcGJkSsZnLx7kqSFw6m4D7KK7MHiu+7L1Ahx+zRvqXhQbbUUA9idIbps/O/Jcv2egaZohHMDz2tEmjWHi7gJCVZ/BRuNzYPKwN7JoaEa7w/BhloZnxkiNJptmp1cZ9mWUoQnWeMB4CSaJIKrM+ThFUEzNeHJIyCqk3Qv4xFilI+gHCxBwy0PErkTNiFHbPdsCEdU81HVgakaNc7OleVmhg+pHYJFjc0eoK3MTJcCADatgCLOvX0DjBuPbFmnXkq7srE46+RwvwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7399.eurprd03.prod.outlook.com (2603:10a6:20b:2e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:33 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:32 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next v2 08/35] net: fman: dtsec: Always gracefully stop/start
Date:   Tue, 28 Jun 2022 18:13:37 -0400
Message-Id: <20220628221404.1444200-9-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f7cd0ad-36b6-4d63-bc03-08da59539413
X-MS-TrafficTypeDiagnostic: AS8PR03MB7399:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MtoPzsPGOVcsU8flnADO2AjSg+RLG0mhqdP0xrad+PaaUxeGoz1c0hgFpOQenPduabX6Eenok6aTfOcb3Ko4VzF8X+KD6bGgGn4PsnWyQPj9WT4ijSPEzrmGvcRzZg9Q2Mq5rWqyvuXMTemVy9rBHMhZvrXIvOzzamBFkxSb2RxMpPfvZkAw4zvGbTll6RBnhMUA+SJ8S2mjMdqy/ujSG5knYjSB115VkoL0eKdnLRij3NTuOUiM+NgXm0E+fywOhI5z+OvqXfkLzQ37+t+FOLaNr3mN688GnmjwUf5WJbszjk+/CzBTaZg2zw/M3CXLmE6If6hEbX+qmFX7bt3oOL0krCIOkjOgHhPpUJuZcQ9koVD6j4Sws9N16TZtDU6PT+1TnI05HQO9UoNE7Y+QXDTRUBti7yOM0+fK3D4Bh2+YewxWkIZ1c8MRl3VsFePOhWckbt3owxh0w1Tcu5ArEA9/V8/99djldmGLy+e+bVcXpf2nq3cUYHyWN2v2W4OvYs4ItKFwPRrdZzFpJjhOiORN7OydhSiJSnAyQyoKGlt9l53Kp4eqOpySmDYuZYxX0KIIfiYMHQCX+Fk3v/yUA/6XJ6Ru2CQY1n1W6KmfnJvOgtp54krGqWRIdfXDCTM2ozgaLoG7aans8NzdmPwaVBAiDdPVPiLdp9yUjzK0F7bBMvSwxpEhIhtAcIjAFUfRxegYOECEc8lZK1r0HyemeMmRbpXfsZzttGWWcn0LGZBo9uUPe9gKGjimqmKB3ihJVfaG+Owkwnt+T6EqyeuKqbmH+hg2OyeGHV24h6W7w9c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39850400004)(346002)(366004)(38100700002)(5660300002)(7416002)(44832011)(6512007)(186003)(38350700002)(1076003)(83380400001)(86362001)(2906002)(66476007)(8936002)(6486002)(4326008)(41300700001)(8676002)(26005)(52116002)(36756003)(478600001)(66946007)(2616005)(6506007)(316002)(54906003)(66556008)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?plk3ml949s9AR893IeE7w90N5vvhsIA7i1k37/bINw56GB0vqKmz8QkSQKSR?=
 =?us-ascii?Q?j3SKt+AOt1aIwRr2guVHEugt9SADCzJEy/1Rai8tdN4ul8D8/bGlA8etl+Xs?=
 =?us-ascii?Q?5C3x8MmuLKLIbVAAgMiXFPlO+Hc9t+lRYg+lpFjsjBFv9mhvdwUD7/lRpQ+V?=
 =?us-ascii?Q?Qk3g/O/k1w7Jxk7zUlBnT34Ha4/ZX7L7jQKhvOXktZ1405rzJr+Ed2vOgg/4?=
 =?us-ascii?Q?1lRXgtbRXZ0OymszsRNwuck6ySd9IwvTElzrv8tRTFwS4h54v3e6A0e5HhDa?=
 =?us-ascii?Q?7JZ+sdgoi7sAYLLCJ6XJUTtcI7Nsk9P0lEsp8ASl8q/eQZtUtGCOlX7vqfSu?=
 =?us-ascii?Q?XUTaLxnGHEM/zptrZXFSG8iAASBEqfWEHNkE0IJdmirDjqJgPcbCfsXWfMDI?=
 =?us-ascii?Q?c3ojcL3Qwdfry0ay3bX+7mnqSrWl75dupV/39cQB+OXoXgOiE3uxf7lki4Oh?=
 =?us-ascii?Q?j+LEpW4Zlxb1btld821eEUnCm7XPxh/S7DVF8dhylHrV/Y1Zz5wsV/Bejpxg?=
 =?us-ascii?Q?n7oLHpZXm/Qgbqq0PJOvhE+60pExlRzjLy32o9Q3jgH5khTfdu2WGvDOA0yy?=
 =?us-ascii?Q?+k4bRXWFPpGkMUGCI4kpbou5rvjPCxf4qMGoFM1zdakzGswq90MgyD2+QkSu?=
 =?us-ascii?Q?ygcNSNemEb8cSjsI1BtTAqakSFXc5egy7ZlW1HGHpBeqzuo/bgibUs7k9Jz1?=
 =?us-ascii?Q?XOF4sM0UAuz/1CGHP6Bz07phrqosNi1Qg8JJ0JjnoMN5A4USuFIX6AgIhako?=
 =?us-ascii?Q?BEPO3WO/afOwEIh34PyABQv9OgtNWKFqDqzr/bD/Nj5DuOBmibqpbj3ATppL?=
 =?us-ascii?Q?4tjKRbQmWaI6FQeSmvGVBcMOhFon3SYqjGSSIzMAKUGnZP50xAJA3zpmIvjW?=
 =?us-ascii?Q?+dJHLXerWo1BD8SJQRXeHiT9pPTYbLqD2Gl8fKg/pj3jnSvYBA5xS1qnbQRW?=
 =?us-ascii?Q?yAayfPI5f8rYn4xNhgtqdsCPhh2MXQfNuhlDDt2QvkR124grfgXJcKRaMnqc?=
 =?us-ascii?Q?VgrPsdFej4pdssY/ZtLbH7UiI+mGHtPVKg5U0YXT3yb7XgzxleWzJXBwoNcW?=
 =?us-ascii?Q?2jfQBDbo0wXJGt5QgC8QO2CXCpjLY8LdRVWh7OnTOxjCzNXgV26klI9CFfLa?=
 =?us-ascii?Q?SaxNpmusvXZKrPuCxpxnj8fK3u7uUVC8XThgfLVDvRnO/wxm2AQ0PSavqGBD?=
 =?us-ascii?Q?VBCv8/lGVl6tlijf1eR4BPCj2LLq6SSA04wEddAfnJJ2COHZzjRbQdzCduVo?=
 =?us-ascii?Q?W0C/3BkSNeAxmEnUuDM48gcdmpqKkBndUr+kCaKa+PyFVwYeT3hlCPqrwk3k?=
 =?us-ascii?Q?TirqgZFRp19B2upRVXjQOx49puo2jIh6GrspO3wDZq6HHbMGpb6NPmtbJWb6?=
 =?us-ascii?Q?40M5gkP9U4DwtEj5oBNYyFNvKimaOT9U2GZVTLbPhA/tMzGVxljJGk0ld3Mr?=
 =?us-ascii?Q?DH1acznh124e+PS3gLZ8V1PZ9SNu1yPTOtAa09nRNSMdHYgPFlKUEgHffKRk?=
 =?us-ascii?Q?UQtDawMi301zfKU0OuRFfcSy3Sy4cMy8xxxQ/VaJGbHkAjcmx9IB8BbdcYPx?=
 =?us-ascii?Q?FQKLcjStEDmZfbnV8P6cKx7f+oLtMQz7+pQr6iokV/yCUHkRvoFy1F0twIkT?=
 =?us-ascii?Q?xA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f7cd0ad-36b6-4d63-bc03-08da59539413
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:32.9075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PNegErLT+jTB70XpYKNw3wIXCPZV7DbeutTHnk64Ebtk9s4JHVNLkiYKqQZlC16fKritlznzAw4kGKe/lxSn/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7399
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two ways that GRS can be set: graceful_stop and dtsec_isr. It
is cleared by graceful_start. If it is already set before calling
graceful_stop, then that means that dtsec_isr set it. In that case, we
will not set GRS nor will we clear it (which seems like a bug?). For GTS
the logic is similar, except that there is no one else messing with this
bit (so we will always set and clear it). Simplify the logic by always
setting/clearing GRS/GTS. This is less racy that the previous behavior,
and ensures that we always end up clearing the bits. This can of course
clear GRS while dtsec_isr is waiting, but because we have already done
our own waiting it should be fine.

This is the last user of enum comm_mode, so remove it.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
Tested-by: Camelia Groza <camelia.groza@nxp.com>
---
Changes since previous series:
- Fix unused variable warning in dtsec_modify_mac_address

(no changes since v1)

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 94 ++++++-------------
 .../net/ethernet/freescale/fman/fman_mac.h    | 10 --
 2 files changed, 30 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 167843941fa4..7f4f3d797a8d 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -833,49 +833,41 @@ int dtsec_cfg_pad_and_crc(struct fman_mac *dtsec, bool new_val)
 	return 0;
 }
 
-static void graceful_start(struct fman_mac *dtsec, enum comm_mode mode)
+static void graceful_start(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 
-	if (mode & COMM_MODE_TX)
-		iowrite32be(ioread32be(&regs->tctrl) &
-				~TCTRL_GTS, &regs->tctrl);
-	if (mode & COMM_MODE_RX)
-		iowrite32be(ioread32be(&regs->rctrl) &
-				~RCTRL_GRS, &regs->rctrl);
+	iowrite32be(ioread32be(&regs->tctrl) & ~TCTRL_GTS, &regs->tctrl);
+	iowrite32be(ioread32be(&regs->rctrl) & ~RCTRL_GRS, &regs->rctrl);
 }
 
-static void graceful_stop(struct fman_mac *dtsec, enum comm_mode mode)
+static void graceful_stop(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
 
 	/* Graceful stop - Assert the graceful Rx stop bit */
-	if (mode & COMM_MODE_RX) {
-		tmp = ioread32be(&regs->rctrl) | RCTRL_GRS;
-		iowrite32be(tmp, &regs->rctrl);
+	tmp = ioread32be(&regs->rctrl) | RCTRL_GRS;
+	iowrite32be(tmp, &regs->rctrl);
 
-		if (dtsec->fm_rev_info.major == 2) {
-			/* Workaround for dTSEC Errata A002 */
-			usleep_range(100, 200);
-		} else {
-			/* Workaround for dTSEC Errata A004839 */
-			usleep_range(10, 50);
-		}
+	if (dtsec->fm_rev_info.major == 2) {
+		/* Workaround for dTSEC Errata A002 */
+		usleep_range(100, 200);
+	} else {
+		/* Workaround for dTSEC Errata A004839 */
+		usleep_range(10, 50);
 	}
 
 	/* Graceful stop - Assert the graceful Tx stop bit */
-	if (mode & COMM_MODE_TX) {
-		if (dtsec->fm_rev_info.major == 2) {
-			/* dTSEC Errata A004: Do not use TCTRL[GTS]=1 */
-			pr_debug("GTS not supported due to DTSEC_A004 Errata.\n");
-		} else {
-			tmp = ioread32be(&regs->tctrl) | TCTRL_GTS;
-			iowrite32be(tmp, &regs->tctrl);
+	if (dtsec->fm_rev_info.major == 2) {
+		/* dTSEC Errata A004: Do not use TCTRL[GTS]=1 */
+		pr_debug("GTS not supported due to DTSEC_A004 Errata.\n");
+	} else {
+		tmp = ioread32be(&regs->tctrl) | TCTRL_GTS;
+		iowrite32be(tmp, &regs->tctrl);
 
-			/* Workaround for dTSEC Errata A0012, A0014 */
-			usleep_range(10, 50);
-		}
+		/* Workaround for dTSEC Errata A0012, A0014 */
+		usleep_range(10, 50);
 	}
 }
 
@@ -893,7 +885,7 @@ int dtsec_enable(struct fman_mac *dtsec)
 	iowrite32be(tmp, &regs->maccfg1);
 
 	/* Graceful start - clear the graceful Rx/Tx stop bit */
-	graceful_start(dtsec, COMM_MODE_RX_AND_TX);
+	graceful_start(dtsec);
 
 	return 0;
 }
@@ -907,7 +899,7 @@ int dtsec_disable(struct fman_mac *dtsec)
 		return -EINVAL;
 
 	/* Graceful stop - Assert the graceful Rx/Tx stop bit */
-	graceful_stop(dtsec, COMM_MODE_RX_AND_TX);
+	graceful_stop(dtsec);
 
 	tmp = ioread32be(&regs->maccfg1);
 	tmp &= ~(MACCFG1_RX_EN | MACCFG1_TX_EN);
@@ -921,18 +913,12 @@ int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
 			      u16 pause_time, u16 __maybe_unused thresh_time)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
-	enum comm_mode mode = COMM_MODE_NONE;
 	u32 ptv = 0;
 
 	if (!is_init_done(dtsec->dtsec_drv_param))
 		return -EINVAL;
 
-	if ((ioread32be(&regs->rctrl) & RCTRL_GRS) == 0)
-		mode |= COMM_MODE_RX;
-	if ((ioread32be(&regs->tctrl) & TCTRL_GTS) == 0)
-		mode |= COMM_MODE_TX;
-
-	graceful_stop(dtsec, mode);
+	graceful_stop(dtsec);
 
 	if (pause_time) {
 		/* FM_BAD_TX_TS_IN_B_2_B_ERRATA_DTSEC_A003 Errata workaround */
@@ -954,7 +940,7 @@ int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
 		iowrite32be(ioread32be(&regs->maccfg1) & ~MACCFG1_TX_FLOW,
 			    &regs->maccfg1);
 
-	graceful_start(dtsec, mode);
+	graceful_start(dtsec);
 
 	return 0;
 }
@@ -962,18 +948,12 @@ int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
 int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
-	enum comm_mode mode = COMM_MODE_NONE;
 	u32 tmp;
 
 	if (!is_init_done(dtsec->dtsec_drv_param))
 		return -EINVAL;
 
-	if ((ioread32be(&regs->rctrl) & RCTRL_GRS) == 0)
-		mode |= COMM_MODE_RX;
-	if ((ioread32be(&regs->tctrl) & TCTRL_GTS) == 0)
-		mode |= COMM_MODE_TX;
-
-	graceful_stop(dtsec, mode);
+	graceful_stop(dtsec);
 
 	tmp = ioread32be(&regs->maccfg1);
 	if (en)
@@ -982,25 +962,17 @@ int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en)
 		tmp &= ~MACCFG1_RX_FLOW;
 	iowrite32be(tmp, &regs->maccfg1);
 
-	graceful_start(dtsec, mode);
+	graceful_start(dtsec);
 
 	return 0;
 }
 
 int dtsec_modify_mac_address(struct fman_mac *dtsec, const enet_addr_t *enet_addr)
 {
-	struct dtsec_regs __iomem *regs = dtsec->regs;
-	enum comm_mode mode = COMM_MODE_NONE;
-
 	if (!is_init_done(dtsec->dtsec_drv_param))
 		return -EINVAL;
 
-	if ((ioread32be(&regs->rctrl) & RCTRL_GRS) == 0)
-		mode |= COMM_MODE_RX;
-	if ((ioread32be(&regs->tctrl) & TCTRL_GTS) == 0)
-		mode |= COMM_MODE_TX;
-
-	graceful_stop(dtsec, mode);
+	graceful_stop(dtsec);
 
 	/* Initialize MAC Station Address registers (1 & 2)
 	 * Station address have to be swapped (big endian to little endian
@@ -1008,7 +980,7 @@ int dtsec_modify_mac_address(struct fman_mac *dtsec, const enet_addr_t *enet_add
 	dtsec->addr = ENET_ADDR_TO_UINT64(*enet_addr);
 	set_mac_address(dtsec->regs, (const u8 *)(*enet_addr));
 
-	graceful_start(dtsec, mode);
+	graceful_start(dtsec);
 
 	return 0;
 }
@@ -1226,18 +1198,12 @@ int dtsec_set_promiscuous(struct fman_mac *dtsec, bool new_val)
 int dtsec_adjust_link(struct fman_mac *dtsec, u16 speed)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
-	enum comm_mode mode = COMM_MODE_NONE;
 	u32 tmp;
 
 	if (!is_init_done(dtsec->dtsec_drv_param))
 		return -EINVAL;
 
-	if ((ioread32be(&regs->rctrl) & RCTRL_GRS) == 0)
-		mode |= COMM_MODE_RX;
-	if ((ioread32be(&regs->tctrl) & TCTRL_GTS) == 0)
-		mode |= COMM_MODE_TX;
-
-	graceful_stop(dtsec, mode);
+	graceful_stop(dtsec);
 
 	tmp = ioread32be(&regs->maccfg2);
 
@@ -1258,7 +1224,7 @@ int dtsec_adjust_link(struct fman_mac *dtsec, u16 speed)
 		tmp &= ~DTSEC_ECNTRL_R100M;
 	iowrite32be(tmp, &regs->ecntrl);
 
-	graceful_start(dtsec, mode);
+	graceful_start(dtsec);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/freescale/fman/fman_mac.h b/drivers/net/ethernet/freescale/fman/fman_mac.h
index 19f327efdaff..418d1de85702 100644
--- a/drivers/net/ethernet/freescale/fman/fman_mac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_mac.h
@@ -75,16 +75,6 @@ typedef u8 enet_addr_t[ETH_ALEN];
 #define ETH_HASH_ENTRY_OBJ(ptr)	\
 	hlist_entry_safe(ptr, struct eth_hash_entry, node)
 
-/* Enumeration (bit flags) of communication modes (Transmit,
- * receive or both).
- */
-enum comm_mode {
-	COMM_MODE_NONE = 0,	/* No transmit/receive communication */
-	COMM_MODE_RX = 1,	/* Only receive communication */
-	COMM_MODE_TX = 2,	/* Only transmit communication */
-	COMM_MODE_RX_AND_TX = 3	/* Both transmit and receive communication */
-};
-
 /* FM MAC Exceptions */
 enum fman_mac_exceptions {
 	FM_MAC_EX_10G_MDIO_SCAN_EVENT = 0
-- 
2.35.1.1320.gc452695387.dirty

