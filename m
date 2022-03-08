Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0AC4D1328
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 10:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345291AbiCHJQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 04:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345292AbiCHJQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 04:16:45 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10065.outbound.protection.outlook.com [40.107.1.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25A340A3C
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 01:15:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AHlTET1Dycu+6d06zUj7u2DwaPf1nH8nmY/SrZ+a2UxSNQpDLiGuxBrYaO0AukNqI1cu4up7B+2vdX7A/HL9qIWBP2BmXC7i5VWBWESmfbx36EFXzW0ENobCj8REDsL67XpFoKYFXZ2hBNSslyzU7gfq448JqG/5kOgOUH1VrmwLKMCNzcDdglo3DAXMFs5yJjNcoeh60KPbn0wLEe9GKdyfRfOqhB0JNwhsfr+DjLfzYAOb2Z6D8dBiBlY1oXp/Q7HF6FmDUBLRvvl50C01JMF7degRAkmwm/zbyG9KT9LWQmXKl0M5EIshj/DRg3ASPLmu8v4MntU61dqRHdV5Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H1/hEWI7KKRInzUgx6eSNbwMMZaDZnaHxNJ8m0hmCKo=;
 b=kBB7wfBkq+MPKateaTV8vN4LkPtaA1UCByJKmCVdzwo93HWQWQpAtNdFMBenD7OnLg85gaHKe+5v1JysR0tJMV86r/SiYXWYNetB5l7Whv/cv2/9Ka0bfH607g0D57wbkyheTtwQ66J0zucscmyvfU3cD7H3bIcdnnpHnuix+sxFP/hsZXOTLqoeqTTM2Y6+Vqvg1JYteQn+6932w1G+G4jLMWiwMS1xE4jDsFEVGPqBY49XyyZkpKC0XhH5iKr+s6Mp2dv19vwX8ZE6QspkCwWhWTLeiown1niqwl7RTcQVDzjA7xTbY0WxUL3Hyy4XdF5l1TBzSYiDICP8Z4Q+yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1/hEWI7KKRInzUgx6eSNbwMMZaDZnaHxNJ8m0hmCKo=;
 b=E7YpP9yH44wWt9euPoJOWaBw3fDw7rCNTz6WhBLUO3bb/U9+TfMFh6xnTdXbMD3vIogZa/UUGd0FYsdtEFPJdLcAwT3tXJMymJncDjKdoCNN1R1ULmw9EDFhlUWW3kZaKGxP+OftpFtbwUJmOdBIuUwfVypUZ4WgwTPjZCMGN/M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6461.eurprd04.prod.outlook.com (2603:10a6:803:120::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 09:15:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 09:15:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 5/6] net: dsa: felix: actually disable flooding towards NPI port
Date:   Tue,  8 Mar 2022 11:15:14 +0200
Message-Id: <20220308091515.4134313-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308091515.4134313-1-vladimir.oltean@nxp.com>
References: <20220308091515.4134313-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0347.eurprd06.prod.outlook.com
 (2603:10a6:20b:466::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d67f7a7-628b-4b27-dbcc-08da00e4333c
X-MS-TrafficTypeDiagnostic: VE1PR04MB6461:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB6461E1054097A9EBB6CBC0FEE0099@VE1PR04MB6461.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vK0m9gk65sh5/VaNjlQuxjECPuEAz4tswYOdfndIuOAucsOfsvzm7025qJsfRZybgcssOzkFjr31NFs0ZNwipzeqR6RL7diI3wBa2ENBQtXCOABRRjERDtwuUJd1AmDzYMTEJYFk8JB5uOg4b44NkOTHfG3OFEJaRNdCpIqzqAqvqg8U7B4QK3O/r30N/i6RgPWpjQTemKOnByY9JsMPndrYo20UgLwr6y5QvXRDu1LUJ6ixmSKAD+zbdPcxw5ba2R1Q1zTaY5q3isyg8rDGQHH5ifnI8BNkfMW4HaYaqw6+QOAcmjbo3TYYaGS2awAVdOY8Ybu6h9Swx06w9QHQRzB7grzFe2ze0LbOMhT/w6ABWA/l7GAEyHZcNngIkmyV1NdPW1GNXwdaFgNDvu9SwIaYi9eUWnnQaTi3JB3IrGQrr/5eTAcSQmlJqfCFoPxo7CmAWtlkP4yGV+Ml7y0hVm1TdzPE/Z/+uNV9h6hgR/leffC+QZJZ35RxsAy33b9HiSrK2ck54f3BxgxcN2bjreSmSG0UTPV5dfbrCarmT7MDpSTt7G7+puNynzcqPZROvx/xPUIhaw1aeQ9X4BVFYGep+3oUMAXRAJV2+IoFWX+rffFi9DhY+QVO+Co3R48z/sfgnpvLnJ6JEHg5ipHnIm8PYLzyBKbK1DFcvFPKwkRilo5Yap9+qjHrjXOO2PuiOgGTQdNAcWzBhc0j54uHdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(186003)(26005)(508600001)(2616005)(316002)(83380400001)(54906003)(6916009)(6512007)(86362001)(66556008)(66476007)(44832011)(66946007)(52116002)(6506007)(8676002)(4326008)(36756003)(2906002)(5660300002)(38100700002)(6666004)(38350700002)(6486002)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hGtba3dFJukf5Mmgm8DtzIVxr285iraYDtSNE+b5NwokvS7t2d5Nc4vEAjUF?=
 =?us-ascii?Q?YxXrTIxnyoPx6wB7cmwP2HcDV0XOMkFqinrB5CtSRWAFxslMMJunw/MSSJIX?=
 =?us-ascii?Q?486UI2Bmn5lehbg+Il833RDOPvEDtjh33ZqWJ/SeghfXsd1aTfCOPkOCIXJ4?=
 =?us-ascii?Q?HCmSqj8Sbs/9ocYKuFQN4sJKaaL6Cy5rkkcqj9Q9iRhgXxtK+rKpWxoLtFNq?=
 =?us-ascii?Q?sCb1TGJ0tqrvCZGv6t7E74qSNhhesytSsgt3h+mwsWpxyRQpWJfG5y93qQXG?=
 =?us-ascii?Q?2mB9yY1E4CMgBHDMDHM/7a2EVhQMj/REI+HoP/l93I+U9x1NNSc+OA0X0T1B?=
 =?us-ascii?Q?aEsKzqY6Nwg1jWoe4InzFKxo8kSCDugNxeNsRCw0/t1FVd2i6uiee2w5yOUG?=
 =?us-ascii?Q?WDsUhEknl7pNQa1flyKN6XpP2o/W2ik/O9cjWJsPdEMtmMPlBRKeyhjlKiqV?=
 =?us-ascii?Q?cKulxX3uwafbbva8b4UzgUKEdppqNBYRfnQyEP3LoZfZq5ZyKwOTRd5bvjOp?=
 =?us-ascii?Q?cSaztFB2sq6ZwoE/r4GZoN1L4cf37zOFQK5EVtUT8X9jzY71YTVv/7Qc5lkt?=
 =?us-ascii?Q?JGevzeEFNLfbQi0W08mGEWCOBGsxyVCHJ57nuZ5jnNBvSgUoQmrvQJqaci3e?=
 =?us-ascii?Q?504AEz2x/i5mFR53CoU3AsIMLBtLmddLI9tAceM4QaVKNONlRQmdHPcbA7ng?=
 =?us-ascii?Q?vAPW2H93V5PkyUTL85uxAjVcNUU9SxR0NL/Llf7OP35nUSMTHFec86HmmTrb?=
 =?us-ascii?Q?4uXdyVOOz4Rmm79LGnZ6mJ4KDd5KmRb5nm+IdQ4J2wxPdogR0UOcK4t25WKb?=
 =?us-ascii?Q?njk63WdUu/hg2vLC2rwSQqiXjQ3wLLKSz0RmrSfm2X50melnEq/mLvbrULYS?=
 =?us-ascii?Q?bzYFtQam+jtgvMuWq5/p7/YUNW2lR9ZTAhqPV4FIZDVVdVr3WX6ji/0/hysS?=
 =?us-ascii?Q?KIboYPElqHQaJZopMZaHnpEZ56gj3d7XCBXow7/+i17bpZt0RmBCGaIpYQjL?=
 =?us-ascii?Q?L9NQCTMTOjTNTFBaFhHLqcwHUnJ/T6b4NRl01z8CVjn7NVbkwJbMxTGw0FdV?=
 =?us-ascii?Q?AH9hFToYsYr+4mQGOducpDT/H5BUHcwmH/fkdUIBHnZDbYKhbOO2SPC+pGAK?=
 =?us-ascii?Q?ZkNmhMgTeB//QdlGOJYvX78gdkZgQ4JqSz+0aLszeRBYfJdWZSTcG2Tb5jIA?=
 =?us-ascii?Q?iXhA5X3UTf314Jb16YvhblyHA3WKg2BPqSnB94xtwsEe/4BYNJby75KlRJUJ?=
 =?us-ascii?Q?QPOxWj3sr6lHyPVzcX72Y62T0VzdgQT96tWoQVKE2H6ZSbQGE0ZPXSt1+EAL?=
 =?us-ascii?Q?aS+nv6idB2mAYJXe410DJd+PQ5oUfO0NELRRY8mQOslbqWdRHc+0IzEy7W7K?=
 =?us-ascii?Q?t6XdojFaWwI4AONHO07HoyaExC1VkjfkEJnmbgrE5jX/tzHfdzvK02GdgLkL?=
 =?us-ascii?Q?xUsq5slGrmHEmUSVJX6Vw+myUlwqyBcZzgovBMNL3bRU8Kd2LeArHZzF3b4Y?=
 =?us-ascii?Q?lILGFTgYWxDnrg1dMT8cf3EEz7OXb2srpuKuMpWGwMm7xbW6h/+/C9xQ5E19?=
 =?us-ascii?Q?MOhaU3U+uBI3uYezCF9PW9uGKj2s2Ay7C4e4x4rXlZO7SicbqZsyUsILfZJg?=
 =?us-ascii?Q?xkZZdCse1z/JQkTCmkuNogk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d67f7a7-628b-4b27-dbcc-08da00e4333c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 09:15:34.0703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OF7VevzZ76PRl69Uwrbgu2g+4qQzZgXiPeuLrHRmhDH3zWwXVv4pUw38VV+yHybvwSTCMGyjVBQK2sj009JINQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6461
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The two blamed commits were written/tested individually but not
together.

When put together, commit 90897569beb1 ("net: dsa: felix: start off with
flooding disabled on the CPU port"), which deletes a reinitialization of
PGID_UC/PGID_MC/PGID_BC, is no longer sufficient to ensure that these
port masks don't contain the CPU port module.

This is because commit b903a6bd2e19 ("net: dsa: felix: migrate flood
settings from NPI to tag_8021q CPU port") overwrites the hardware
default settings towards the CPU port module with the settings that used
to be present on the NPI port treated as a regular port. There, flooding
is enabled, so flooding would get enabled on the CPU port module too.

Adding conditional logic somewhere within felix_setup_tag_npi() to
configure either the default no-flood policy or the flood policy
inherited from the tag_8021q CPU port from a previous call to
dsa_port_manage_cpu_flood() is getting complicated. So just let the
migration logic do its thing during initial setup (which will
temporarily turn on flooding), then turn flooding off for the NPI port
after felix_set_tag_protocol() finishes. Here we are in felix_setup(),
so the DSA slave interfaces are not yet created, and this doesn't affect
traffic in any way.

Fixes: 90897569beb1 ("net: dsa: felix: start off with flooding disabled on the CPU port")
Fixes: b903a6bd2e19 ("net: dsa: felix: migrate flood settings from NPI to tag_8021q CPU port")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 2c58031e209c..e475186b70c7 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1343,6 +1343,7 @@ static int felix_setup(struct dsa_switch *ds)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
+	unsigned long cpu_flood;
 	struct dsa_port *dp;
 	int err;
 
@@ -1381,6 +1382,14 @@ static int felix_setup(struct dsa_switch *ds)
 		 * there's no real point in checking for errors.
 		 */
 		felix_set_tag_protocol(ds, dp->index, felix->tag_proto);
+
+		/* Start off with flooding disabled towards the NPI port
+		 * (actually CPU port module).
+		 */
+		cpu_flood = ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports));
+		ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_UC);
+		ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_MC);
+
 		break;
 	}
 
-- 
2.25.1

