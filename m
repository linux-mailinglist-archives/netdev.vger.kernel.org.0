Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7D442E95A
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 08:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbhJOGwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 02:52:44 -0400
Received: from mail-eopbgr1310105.outbound.protection.outlook.com ([40.107.131.105]:45670
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235736AbhJOGwo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 02:52:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYaxlDKBq8r+6b3CIVqfuiWfUTs0R6j4t+raLXtBKQHSBHIRW1dcWznt+SciL66N+ARaISBbjD8zkQMc8B4E/+b0C507rzt4PgrfOoBzo73M5OppNpXEYOSdaNCG80eBW1VanVEQRkNW/XaJsgJOf+LKP7fSlOMM1YxORs8LDA8564HrfsnlGYC9BzFkLpR1lMflDCuFeeBdhKzUzOnXs+JBKJolJcFzgGngPgs18Y36qyM5jAJtU0taHJB26QkjJRL47kZqBSKC5XR2k9EN6AWGypbOtRlqeXfMfSCf6XW3E0yBGanQgLJqsRoeNuGZJ2I79ZWJaTheUjj2FnUaOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fuQA6UBBiB7mS9UHJ1UsRYDRHO0MuFRyDgvVKjl36fc=;
 b=UdWEivGT0FxsWEMSOBxn7vmkpYpdd6uLzivKCLBaE3+VJ+AwetR2GOZohYJ6r3QihoRIsho7h3RzZLEiCWFsO3kyEBQ1XCslsxorXx97PW3cT6KwZaIaMXrF/T9c5d++0AkG6G+oxWD12e40vV9k1gGDWEa9skcKZcIX/wW7oYPtqbTz7mZjDLSdlhCt0EhKwVzGSKMpqZSnm5mzxxyPY+WrgsyuDckkZRWZNmfkSc9zUSNJ85say0p8OTthUH5X4NfYYhPzm1JsScIKj95OFsQIF9Gjnn91dWpS9qBdnWA+WvqJOZKj9pmAyBYcK34Ub69+jiwPUrVoKADO+CTqFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fuQA6UBBiB7mS9UHJ1UsRYDRHO0MuFRyDgvVKjl36fc=;
 b=GYW35ROdfTRbib5gk9DM7Zlp4GCStC/Az0HXzKe6b3kWID0eSajA0bwBZhEbumwvBLpjqk2WbsW7t5+2O/LYJ8NZF5DzN8cRM4UNvEUhpge9ivVgQgf9Uh0J7X+vg/WAxtfIO6xl7dihr721oUinBKjq2V1um3mmMcEI8qJzSbE=
Authentication-Results: grandegger.com; dkim=none (message not signed)
 header.d=none;grandegger.com; dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SL2PR06MB3003.apcprd06.prod.outlook.com (2603:1096:100:33::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 15 Oct
 2021 06:50:35 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 06:50:34 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Qing Wang <wangqing@vivo.com>
Subject: [PATCH] net: can: replace snprintf in show functions with sysfs_emit
Date:   Thu, 14 Oct 2021 23:50:24 -0700
Message-Id: <1634280624-4816-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HKAPR04CA0001.apcprd04.prod.outlook.com
 (2603:1096:203:d0::11) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
Received: from ubuntu.localdomain (218.213.202.189) by HKAPR04CA0001.apcprd04.prod.outlook.com (2603:1096:203:d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4587.25 via Frontend Transport; Fri, 15 Oct 2021 06:50:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 999f1236-87fe-4ead-527a-08d98fa816ae
X-MS-TrafficTypeDiagnostic: SL2PR06MB3003:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SL2PR06MB30032A2B37D7DF4F723F9316BDB99@SL2PR06MB3003.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lcLLHTJwVe3K6yaP36toMRx/HA09OmUh1Xg0S+9U0DgAwShkO/Pp+CbQOgj9F+FP4bVrv4q5MBLzMygMk/xE/XWh7VjrrVUix9ptDROBJKDSugqvHTwBQXgi19apMM5NbVer8sKotgqZ2wKex69WyfLNZG0NV3v5x5WGQ/wCy8TT6AyvD/2s7GEGveIUucah0Sni8rX9X/2Hn2i5td0u2B1rB8QE1xfwV6pFimSmJlyFYz9xc0roy3GptQlRcKGCPB1bpQKKyaPQWlodIB0BkeJT7iuopHuCal9mc8n2GvDyAiQuLTtvFKgOYYdVw4v0l0O5VeJxbO+pHgF0zX6B8f/kVKpE3PWD8ldKVz64T4XWIs/YsrOtntX/hKpXt6sqCVIvrYfuHWrRTCgrkaFBoenIuSfbRAwJdnAMQLuhrd6S1kUgaD6dSC0Hw8E7aNdHYUSEULkLq6i0FRjQ/VJFcZGqmt/4xnRKAkyjWosybnLbjMiFakiOYxPU6o2lpyMHtacaH7mRp7dvcR/yRMIRS6H8goT4TODrERncOu7FXh8K99u6/SEdt2DyiUK6K9GPuR5MRTTX/RyuP/DFLyHHsLtyydvHiU2w3YJrdXD44hPh1pr9QEwqtR+tqdWGbCVlalyN8aE2DLDmUUP9iLeqsqEpY6N+P84wcqYvBtxBqUn08ASSKQfE6jX3xt22wpgwIL2t7hWEZybyu5XUJZcSV1w2hzSbyFOzDmYH5dyqhLQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(5660300002)(8936002)(66476007)(83380400001)(316002)(2906002)(4326008)(36756003)(110136005)(7416002)(6666004)(66946007)(86362001)(186003)(956004)(2616005)(107886003)(26005)(6512007)(8676002)(508600001)(52116002)(38350700002)(6506007)(6486002)(921005)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?csRka1JEPUY5+SFZgl1V+48CMeMvbuLZILHPbcuutvxb+ux/f06A10VwkZuY?=
 =?us-ascii?Q?0xm7gSNxt1q3m0tUsVAUqlc5U8mJrdbia03ctVLi+N8QOFqNF6DkSAY1Q/gk?=
 =?us-ascii?Q?snW9K7M9ohV3+2gCHP+jw9KiBzaKSVBalplY1anW0XN8Gx1XmHDpQcXc3buB?=
 =?us-ascii?Q?cDsODWiP9JO105r1KguonNZ6S3Mqs9tHWuS/S1dBTq/TpjhzyfTCleEhJl2Z?=
 =?us-ascii?Q?p3yFrDeTC7+0ohHp4Duk+UOO26VazBHwcaC3V+1vbBMmnu4mtmRtoK+OAJQP?=
 =?us-ascii?Q?GlwemfUTSUg0EKHgOSM1qIR3tBW81U2rydZfgQbbcS1AjzFKCIA6rQa1CQ/1?=
 =?us-ascii?Q?U+u+QsWAw8/a++pLGFp2ugPlqr8BgocLCehkZ+z28uB72FIeJVPgCM6HnJv0?=
 =?us-ascii?Q?vIKK+U1fOB2WezEaUKD/gxdCLTMIC/nStf6DgV5HZq9w6Utr/kc9J+/Ob1Jr?=
 =?us-ascii?Q?qVy0UlFw8yhpBMOsaaWvdfVaVhd0Wexgi8vYarEe6AziUEbQ0/ZH0PM0t8xk?=
 =?us-ascii?Q?03dT087mnkylHN83iwKE4ng2wMt2zaDKXqnRXbkoO1/EghlaKMJdUamsyRAO?=
 =?us-ascii?Q?Qr7uQfx3OKAdF6nZK4pohhXI1cc7vH7cqG/Og9manCaF7FdDHkZa/ele+wlH?=
 =?us-ascii?Q?Gi1swJz+I1i68aX9UlKpCk3/ACByh18IQcwCdyLNK882MRSPYJ+Mp7SZ96n1?=
 =?us-ascii?Q?hAtgTf/EsXtG0iv6dmXF7bobXfhJNDuoPcpi+K07hwfHXYvKsrJBkoHrJkhQ?=
 =?us-ascii?Q?TTEwIMIrFxrWiolmX5WdqOXL8Pi1NFuSPlcN8s/fNez4UgnAAzhbVgQNMOw8?=
 =?us-ascii?Q?8JBT7q9R80H+gtqnYCmUSrAfDqFZ/6uljrgIEADJ88W78LDYICrQjt9iFCSx?=
 =?us-ascii?Q?ZDpBI08Egw9sB4w/I3YUSpEQb0TEiN0GFImSyTHr2YLfZFkr66TBHcnzFQ70?=
 =?us-ascii?Q?kEIZZmuGoB2TxkoAzcSF6aRsWs8v44VOR05RZwcZwLotVi325OX8bKA/Tq8R?=
 =?us-ascii?Q?ip55dpYxKmaorRGx6otluYEk9qcJH2+rkgA+dOcj2hz6rrCiozoEerKm0vU8?=
 =?us-ascii?Q?DYoFuvCFnA8mMJx5Tkqd5eiZSg4w4IMFVdwaeh+WT1CQTu9ugkBg/QsKgiIR?=
 =?us-ascii?Q?nT/fSm/nYtUZYPYVwOo2L5OmFq59mJn4ZUdcznT7v3uV09DPqFboD+6KwQ8r?=
 =?us-ascii?Q?aqWxRvwP0pukwxDRjHYS3nlnwxv4foVWGXDodY7nt3LOI2px/aPbnQRRHgw2?=
 =?us-ascii?Q?u4sCFrFb4dgBVi+854Nze3kaJ/bb6WOYDrlJftAA/Oi3C9IoLmc0K0GiD57M?=
 =?us-ascii?Q?AI0D0xpuUHq+PoylO078yYec?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 999f1236-87fe-4ead-527a-08d98fa816ae
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 06:50:34.8606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OfBC8oAywR+zMv28E5Q/dK/PnkuFWOIDDScIIxHuMfb+jukLB55h9Fiw/orISS2hGgC7+kNOOB4gACl12ct3pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2PR06MB3003
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

show() must not use snprintf() when formatting the value to be
returned to user space.

Fix the following coccicheck warning:
drivers/net/can/at91_can.c:1185: WARNING: use scnprintf or sprintf.
drivers/net/can/janz-ican3.c:1834: WARNING: use scnprintf or sprintf.

Use sysfs_emit instead of scnprintf or sprintf makes more sense.

Signed-off-by: Qing Wang <wangqing@vivo.com>
---
 drivers/net/can/at91_can.c   | 4 ++--
 drivers/net/can/janz-ican3.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 04d0bb3..e4e754e 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -1182,9 +1182,9 @@ static ssize_t at91_sysfs_show_mb0_id(struct device *dev,
 	struct at91_priv *priv = netdev_priv(to_net_dev(dev));
 
 	if (priv->mb0_id & CAN_EFF_FLAG)
-		return snprintf(buf, PAGE_SIZE, "0x%08x\n", priv->mb0_id);
+		return sysfs_emit(buf, "0x%08x\n", priv->mb0_id);
 	else
-		return snprintf(buf, PAGE_SIZE, "0x%03x\n", priv->mb0_id);
+		return sysfs_emit(buf, "0x%03x\n", priv->mb0_id);
 }
 
 static ssize_t at91_sysfs_set_mb0_id(struct device *dev,
diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 2a6c918..feedc13 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1831,7 +1831,7 @@ static ssize_t ican3_sysfs_show_term(struct device *dev,
 		return -ETIMEDOUT;
 	}
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", mod->termination_enabled);
+	return sysfs_emit(buf, "%u\n", mod->termination_enabled);
 }
 
 static ssize_t ican3_sysfs_set_term(struct device *dev,
-- 
2.7.4

