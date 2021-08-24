Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BC73F5D3C
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 13:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236834AbhHXLmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 07:42:17 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:43248
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236676AbhHXLmH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 07:42:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tqhv8fVZG/7cFEzNmhGEyaRtimefYz5WITH+DDyqwus8Ak3LHmineMc0+7BgOeJSE79SkjGaRO29W/kT2qQtRj6lmK3Xys8rTS5YKx5lO3dTPlxdDm5Oq2y7XaN5K4QxhVO1Poatl0lHe9eM9kM2Am1NZa/GvCbJ9V/RhZTjBiukudg36CYxVKwEBW737/X71kfa1N50/OQo4AadxwmFX5LF/v2fzUjFSZAmK4VORDyBHxPPinjBxNHhg8GkdtLALEY35ZaR+Hv2SwrvbE/lXa6cHLu4EoZUoaZhqyjJRhshRO15G8NLgtHV2nNXF7PSJqoAG1qWZijTQQgbriPoDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gqm5Y2Dq0NDjNGf/qANFCCNYWpWuCRB8ITMXJyJXH3s=;
 b=B0sxDoQtjmk2VSRvPZgxa/QXYMoMaK5yL2Rb8UkiVpNNk9Ixz91an/V0d24DhORfyidBPoest8uHypjfbzdfzwR48pIwEJZTpVKd3hte9+jWzYrwhq1IV5Csf/CTS5x1tsxSVL20pIJHwB/ocnE0/eUT3LuAtBv/wdU1QMtrygA8IvMxhvTGbNS20LmgwG+EJ5D8g+wRuUnM7y+tSdlr/Np9FORGXCKLhiLBQU9zRzAU2neRKk0mbreObxnV8cVssJ9Nr+h0q6WSJ/uSIiDGg/m9w62RROhi0SlxVJWzEjI3QvEIcSake3RAKqI5KLbKmXwoCoCMGPp4UK08WfJ3Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gqm5Y2Dq0NDjNGf/qANFCCNYWpWuCRB8ITMXJyJXH3s=;
 b=Vx2zaMdwZJFrPrp4io5LjQZOu9nOBGh+prZem68Tkt53PkIhDrwF3AS/AIZKeUgAP6gLESU1NcUHT4kNoQCFM2c8uf8kBPaFixzq45IZ+mqk1y13f0QMUxTLEkLE/W7lCGlMDJP3IGrKFz9O8XkLZLv/7TpQ3+GGzK3dV43k0SU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 11:41:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 11:41:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [RFC PATCH net-next 2/8] net: dsa: sja1105: serialize access to the dynamic config interface
Date:   Tue, 24 Aug 2021 14:40:43 +0300
Message-Id: <20210824114049.3814660-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824114049.3814660-1-vladimir.oltean@nxp.com>
References: <20210824114049.3814660-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Tue, 24 Aug 2021 11:41:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42d02875-b1e9-455b-7afc-08d966f415ba
X-MS-TrafficTypeDiagnostic: VI1PR04MB5696:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5696D91A89F23823F1EA02ECE0C59@VI1PR04MB5696.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w/5atDwUVh9M+nBMp6CtGYnbQmPGh3HvxwDXci6IVxlSzmVGtveiavYRH+gMg8fZ8rKpfhJkDr0E6gnSDPE1FOj+MyeXbBuyLkuUZIHt1Zo9PGb2HW7DuHosCMEUHmfpBgPqQbBm/y3b+wjYUkwFtTLMZtR3l3imLwOA+0jHaY3glSonZqdyfIJA3IbgijjA2jEuocC1JeCdcseaDzZNg92Hbw0zxH6VuhBQ3qQY6m+hmmYm/y/bhI6CRgYv68GePcCTsCgpa+AmSReLJWtSYWFJJpx7gG6Zbd7iMX/bUmvZSAb55JZ41hsWgVlIrZlHEXmlDzf2w4XJOnSx000wKc38WOIfL/UhZgLNU4K6ai5rJh/UolT7ZIYlgkdxP2k6XNCAHAJzQbQ7lp7u1egICQASayhQutB/7D3joNcIjRpBQy5lpc1dPrQqHlrB+ncqcAvC5m8pIZu9NeIz+N8DlwvW19UK1v1Ht7YqMEw3uFkec5pWUygwoX98xSl812zUvrj5DAmzY5LxPlQcYDsj1GRlCPYptkZM6B9mwJQrLSTq0mVunItPGfiYUW+IyyP9Ue2vUj82efTc2BkiW+EN4sXG+gktEneDoPtBZn9EGKrgtY8UJfpLRO8PsJMjel6YCXeLKIUP3uow3dJkUFnFlD0x25GcvtRihL6cgUpDfBA2MFRxz8Kachm7Hok4SmxAY8VAUxGNoGrcETRIX/NOYNtjENHYai/JlY5AcOGvvcU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39850400004)(376002)(52116002)(4326008)(478600001)(5660300002)(6916009)(66476007)(66556008)(26005)(83380400001)(1076003)(36756003)(66946007)(6486002)(6666004)(6512007)(7416002)(6506007)(186003)(8676002)(8936002)(2616005)(86362001)(44832011)(38100700002)(38350700002)(956004)(2906002)(54906003)(316002)(290074003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yhKl0mfF/qWIsh2/CK7f6UGUqIuC4/W/YRbbPiq41IDRBlZEXQnft8OZSDch?=
 =?us-ascii?Q?TO123jQ8hIllp3GxPyO5kaPBpdh3meFJIjk8dB2+aqr0G9ChAhUhup99BJQX?=
 =?us-ascii?Q?H+aHIA5ZsK0YvRZqxJwx69MT6syN34Wfm11GR1p1NY9nIj9RRVa0qJan/r5h?=
 =?us-ascii?Q?74ssTqqzar6GNfdvdJnGircy4hYjednhXRhCaB1//lStrg1WFTVEeFcQvA+y?=
 =?us-ascii?Q?R3NHuPUrcmVarvwd0LbscT4qislD2qm6vc5hkbWEKPgW8u0lfOlNBGapr4on?=
 =?us-ascii?Q?28QN2WfnozZ/+rjyyz9L8TDm/dJvY0Ha91DRdONukjC01y5CCgOqQ+CsFZcS?=
 =?us-ascii?Q?zQit68/bQvRYHC4eAHP+Ust1rqIu+vC1bl4aZg09JwBBnHoCZKaXMzzU4oeK?=
 =?us-ascii?Q?QGaeSHOaXSsOGUdZeRlV1AXDpPR6El2iVpH7tJ1DsjVLV2ASucKsMR+auSgf?=
 =?us-ascii?Q?5KlJy5XgxNF7cpFRcqj/olYXEiP88XV5JHk5Ko5PUPENkAm6EhuhmdrLO8dN?=
 =?us-ascii?Q?3PcpzCBtbYKS20DqfUAQWVis48p1q47CFu8Y2Y0g1MTXKCLq2hjFHSY9mlU4?=
 =?us-ascii?Q?6lPHeAAmQ5oRj25K8lFXAqnzou4PhPiYX/PgNze5dnr16F6V90j3WJLiBD1B?=
 =?us-ascii?Q?zyrtQ7C1SzklX+/8IHLikCdzX06ezTuhftJzjLRz5cdn1GlsdOpSPbni/bCB?=
 =?us-ascii?Q?52tuSi2prbGP6VQ8b8lKG7OCN4r+KRViOp+M4c/6oSxqZa/iOaGbe6iVJhJW?=
 =?us-ascii?Q?ioUY5PnFep6uKZVCpEFTkGZW7Ejm28h8UhWFzeywFw8afdWHDDM/Mu5E5cnt?=
 =?us-ascii?Q?qJv2xCWgh5yESOZyCthjPU+tarI9meqaN5HWcdWPuYhhsZlr8HuiSiri3FBz?=
 =?us-ascii?Q?tFAv0Hm6kMLDPPjc9zoCPz1cWFgLAfqQW87hJ5vpz4uYgCqgzJ2I15gWmVpX?=
 =?us-ascii?Q?+fp7zunvL1ny+3H8uR5WG7Jfq3AY25H/hKEONBKbwTc8AJl5aPtPax3a9ZvE?=
 =?us-ascii?Q?hIHZpMf29VY5ct2yCAZZk4CI/wrLjVDr4LWLFoh21DKWs67enccL2KaEb7Fk?=
 =?us-ascii?Q?z+aLwfnDlvDS2jE/rmkCvXDmd6mind6mK4rg5sqz5I+ekeCCY8Ih8bV9iG3i?=
 =?us-ascii?Q?7KftC5YyK3y1JU+Etv83RLH/r5DlZfb5IRXQlCMYiNspqNFsHNLilxTCiuex?=
 =?us-ascii?Q?N4797ZRki6qaU/5ODBNIyRsOGCBwqHSdeLnTmKYotFaAqJjVob30UPIGlu1l?=
 =?us-ascii?Q?aNwxzGx1ho6qUM6VUC4kPDlu2+OPQ9+wMooQJD2vA+HuF3cIhmFcsvCM6moO?=
 =?us-ascii?Q?Wwv//J+fortn9ii7OaoCcWIa?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42d02875-b1e9-455b-7afc-08d966f415ba
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 11:41:17.3691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yX0j5l/8PBmWTQoGu1jRTG9Jwdl5cVwuvVpMwwuQathjgabjfKG0h26mDDg60kK4oHsDlBrvEWtund1OITeNyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5696
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sja1105 hardware seems as concurrent as can be, but when we create a
background script that adds/removes a rain of FDB entries without the
rtnl_mutex taken, then in parallel we do another operation like run
'bridge fdb show', we can notice these errors popping up:

sja1105 spi2.0: port 2 failed to read back entry for 00:01:02:03:00:40 vid 0: -ENOENT
sja1105 spi2.0: port 2 failed to add 00:01:02:03:00:40 vid 0 to fdb: -2
sja1105 spi2.0: port 2 failed to read back entry for 00:01:02:03:00:46 vid 0: -ENOENT
sja1105 spi2.0: port 2 failed to add 00:01:02:03:00:46 vid 0 to fdb: -2

Luckily what is going on does not require a major rework in the driver.
The sja1105_dynamic_config_read() function sends multiple SPI buffers to
the peripheral until the operation completes. We should not do anything
until the hardware clears the VALID bit.

But since there is no locking (i.e. right now we are implicitly
serialized by the rtnl_mutex, but if we remove that), it might be
possible that the process which performs the dynamic config read is
preempted and another one performs a dynamic config write.

What will happen in that case is that sja1105_dynamic_config_read(),
when it resumes, expects to see VALIDENT set for the entry it reads
back. But it won't.

This can be corrected by introducing a mutex for serializing SPI
accesses to the dynamic config interface which should be atomic with
respect to each other.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h                |  2 ++
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c | 12 ++++++++++--
 drivers/net/dsa/sja1105/sja1105_main.c           |  1 +
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 2e899c9f036d..78624851d1f8 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -248,6 +248,8 @@ struct sja1105_private {
 	 * the switch doesn't confuse them with one another.
 	 */
 	struct mutex mgmt_lock;
+	/* Serializes access to the dynamic config interface */
+	struct mutex dynamic_config_lock;
 	struct devlink_region **regions;
 	struct sja1105_cbs_entry *cbs;
 	struct mii_bus *mdio_base_t1;
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 32ec34f181de..7729d3f8b7f5 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -1283,12 +1283,16 @@ int sja1105_dynamic_config_read(struct sja1105_private *priv,
 		ops->entry_packing(packed_buf, entry, PACK);
 
 	/* Send SPI write operation: read config table entry */
+	mutex_lock(&priv->dynamic_config_lock);
 	rc = sja1105_xfer_buf(priv, SPI_WRITE, ops->addr, packed_buf,
 			      ops->packed_size);
-	if (rc < 0)
+	if (rc < 0) {
+		mutex_unlock(&priv->dynamic_config_lock);
 		return rc;
+	}
 
 	rc = sja1105_dynamic_config_wait_complete(priv, &cmd, ops);
+	mutex_unlock(&priv->dynamic_config_lock);
 	if (rc < 0)
 		return rc;
 
@@ -1349,12 +1353,16 @@ int sja1105_dynamic_config_write(struct sja1105_private *priv,
 		ops->entry_packing(packed_buf, entry, PACK);
 
 	/* Send SPI write operation: read config table entry */
+	mutex_lock(&priv->dynamic_config_lock);
 	rc = sja1105_xfer_buf(priv, SPI_WRITE, ops->addr, packed_buf,
 			      ops->packed_size);
-	if (rc < 0)
+	if (rc < 0) {
+		mutex_unlock(&priv->dynamic_config_lock);
 		return rc;
+	}
 
 	rc = sja1105_dynamic_config_wait_complete(priv, &cmd, ops);
+	mutex_unlock(&priv->dynamic_config_lock);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 05ba65042b5f..dbfbb949a485 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3285,6 +3285,7 @@ static int sja1105_probe(struct spi_device *spi)
 	priv->ds = ds;
 
 	mutex_init(&priv->ptp_data.lock);
+	mutex_init(&priv->dynamic_config_lock);
 	mutex_init(&priv->mgmt_lock);
 
 	rc = sja1105_parse_dt(priv);
-- 
2.25.1

