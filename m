Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D359D67387B
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjASM3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjASM2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:28:03 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2079.outbound.protection.outlook.com [40.107.14.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4D26923A;
        Thu, 19 Jan 2023 04:28:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rc22ycshFMhvoxwxpSEwUf2t0RRMMJYOTaNqHwmKoCfkAf4LZ3qCkohd7JNVfc59Pa9xQRPCiPUUg2qbqyLOm622+uoc5lVlzfwtLrUma7Vtjpl6NX2LhCi8lPQujJXkuVij4/CzGbDlRE87pf3xHXpPnJ0ut1D1CtAqJGQNnI3KFFFji+Kdgmm3yhpM6ZPkK8tlxjsjO2CzIbhBs6ATkXdVeuvpR5vmgBsTA6Prt9AgG/XIdDTNhl5F5xtS1HOgkKj+L7d9LXdCP4slrX+f6WpbSTTDN5SlxNqPQrczvEQJCrvXyMQwe3IQTM/f/TCCsSjhRLhIwXFYu8JxF+sgBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ezRlgl6x3LiQifZBXNjx6U4npuVgQCVw+Eq+mc5ovk=;
 b=hmynbfj065WiMruluB6nVHbXjLyibKefCGjQzybHZPlY27PF9yrF5DkVUNKMKagdQJ5RW+Vz/NEDODrVVayuD6IsNJX9Kwe5f+ZxSVueKrSl3paxouDGTuehCQ2OR3wxXwTGLx8QijY1Z1pRtUI9KJTEhebUvjOLdpMcvUFLWrT6Bqdhlc+dw2YabXbbjUuTBSCxQQ9Xj/XvxQBbSDxXrlfrdWJvzJh2EPtpfQeC/mcLNLl2w5rVtvcpYZpG6fGSIb/GGMzlsQ3bUUe8hvNN4M1wZlbBaIf+AMA6d1OjtBYPVoerunAs1NMKq15i6kuPv5LfHZse9RVwOjxWL+u8gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ezRlgl6x3LiQifZBXNjx6U4npuVgQCVw+Eq+mc5ovk=;
 b=Rl/JSHrntxSMdpuIYJyHwcmwGH1XcQS3Mp0TtUNghOXQg1bDpBdrYWxekWZNnIcdRn5y0XqNJGDLZ+yIFB2s/bJEBCNNiRHqsjBJqC/zn8kxeQeP8ERnFJyqME9X+TEbpFK94iH+vQSfQfUmhS+3in/dn8DZd7tkKKrffkEsnlc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9376.eurprd04.prod.outlook.com (2603:10a6:102:2b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 12:27:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 12:27:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v4 net-next 09/12] net: mscc: ocelot: allow ocelot_stat_layout elements with no name
Date:   Thu, 19 Jan 2023 14:27:01 +0200
Message-Id: <20230119122705.73054-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230119122705.73054-1-vladimir.oltean@nxp.com>
References: <20230119122705.73054-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9376:EE_
X-MS-Office365-Filtering-Correlation-Id: e6105401-86f8-4a5d-1878-08dafa1898bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zSFHQcNgwcOCJ0mPoPDE+vwnsFxnqiucuclxOjxTE77iMtTqLj6lbqcZ9uqZU0T+5PGCYutuYDzzAnzwjYogh8bmOqbTpf9368k2krCBx9nZD4hOlej2dGToIJAXRB9DdwoCAoigVi31oSYHj98n8c5UOdl/KldLh1T4DlQwjIS6fUQxJhmwbpMnWKhDg3Dye+uD/IwXpBNfUaNMV4Aj2hujQ02gjyopysb8lBOybL/praBFNhtVsJR1FZ5O5bQ7zEAvC1liRvBI4U96CCaCBMGGGJHrTZ/v9P+riyWWprUF90f8VbMQ2KXZjikP2o+sWB4c1+8vn2KS9eDHN4auVCQyrnjODJudVRON4IKQ4qh2x7q8tSvFxAwUpGVOr647Z/N/8BozE9djanTjkoPTf2xRnQNc6jRuMFhruBnrTNiEya8qk62UK6xAeV/YeRUwP0I116NGpK96l3wUivxvLw63ctx34vbMG2TfThndhm6fVWpjqvIcKvngUCe1QMi6R2lxHIoG8U0RAZiGsHDJ6RLBFJFRpnLQEWxxIux/f87C3sHPsMouwBdDI+Du0SkO3g8e8ci0CeLAY51CLjUV3ZfMzn/v5qDKuXX1pKVvfU1kePIgQ9J516Q2UoK+1iktNnRkUHy6dSA1R+FGGNTsHm32OdB8gxMPgaBT8WEffwTzou0AFAECQcHnYD83f54kT9w+z7WmiOJzSshf5DkoLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199015)(6506007)(66946007)(66476007)(44832011)(66556008)(7416002)(8936002)(5660300002)(2906002)(38350700002)(38100700002)(316002)(6666004)(54906003)(52116002)(86362001)(36756003)(4326008)(6486002)(478600001)(6916009)(41300700001)(8676002)(26005)(1076003)(6512007)(186003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?px9LiMhy9FgDNUWT8r91TRSSboiqmx5eyvs2S/VcmXlWE5rX6yccK5yxljWH?=
 =?us-ascii?Q?9RdjMs0VycHP6f6pMcxXMLFYMY6a5NP39tJPzGi82/e7isforgTmEA7R1g8e?=
 =?us-ascii?Q?2dJee3bTzsXhztAElnjvWd1YGDrdVdM0KNY2TwCox52fEFVHaqNXDEmpnAwh?=
 =?us-ascii?Q?PY/aPILXs6VZDv0JyhhXVZGpZpif5cvxpR+/RcLhqYtUie+EvpxMs+26CAnd?=
 =?us-ascii?Q?ANqZbyOeAGpneYJAdeYM4LMuJwt5ixQ8NuiOwHOdlLm926H/q+jyCm8+5ita?=
 =?us-ascii?Q?Zg7yYhGpVgY+O56+OlrrV+78xtpaAywzanz51tYNNpUgXSiEWpEDdVzmjFmI?=
 =?us-ascii?Q?dE04MNbfOEf3Co+CrYMHKoiMOQhgr727Obh0NS47AFhX+S4CN01SqNsGR6l3?=
 =?us-ascii?Q?ZAmoRfZEFEVqu0ElhNcvWBQ1FPNaRzsCL5Bnxnn7iO3ok9w7/s9VwedrGntL?=
 =?us-ascii?Q?qAbOG6rfO8MqelOx8xMNizZuxAqGKBhbWtk5A5VG5h8KHiWFM5A67RMmpkR5?=
 =?us-ascii?Q?c2VDKeUnDkW761e9vwf3/defos7RBxNLWTaisou+nTqRt+hvK8eEdIYJpZNB?=
 =?us-ascii?Q?Odprv7bdJJL5UE68EKzr3sapWeL1TaEBAyZyg2e6YOqYBmWy+AKBxcPNLVkb?=
 =?us-ascii?Q?7ztvGUqKhlyIPr/GDV/KPK46Ek2c/ZwXIoeaon2Z8nt2GvNioByiFKRrC1si?=
 =?us-ascii?Q?x0JDt8X1/Hh55ePhVYVKei8BYQr3VwoB1pIRQNGGFfxph37whZgeQf70i7ID?=
 =?us-ascii?Q?dvUYcaMR0rtbZiRVwRTfbajpiYIrE6sRdA96xKDZYg+5WwrTgsjKgjyiKJ+t?=
 =?us-ascii?Q?WQOeOnUInPnGG+vcG+SnX7KPzVEZQqJsgBS37VF9GtSJhQN0qLOwbIJuLhfh?=
 =?us-ascii?Q?CwaRBQHM3dwmselbl95PmMjDSlCMh30+ffBr8Lyh4KvOP40Qdl1TvOuqFJiM?=
 =?us-ascii?Q?9q+VfwZ5MyBpH9LQzevayqSgRmJpNzo/Q2kbf2sEPgDsC877x72xnOe/ULvY?=
 =?us-ascii?Q?DuIGIGWjK/c4NZ3WJESbpUQ3COf0EwUsQvETGwjB7DIEnLAyqo4+TW017egn?=
 =?us-ascii?Q?BDS51ENHTVwu+wBvrJfhd/TOnn+dSuwU4ajS0J1NueGW1/568Gp0C7VLE+kJ?=
 =?us-ascii?Q?dqbpb01XhbACXackGrYDZmuiA8PCYeRFCKlbMM8mNPpgEP85EjkZ/j9NDEcl?=
 =?us-ascii?Q?OceGhdG1WUY3Ymtere8GC4hIqTbaULNIOkIK7HnJmyEV2EJT9A34Wp9GPr9b?=
 =?us-ascii?Q?ZgnEZ68PAIP85levef8n6lOQ7qNLsdsKzGJlr++79L6XaFSmLrEe+OKZ/8FF?=
 =?us-ascii?Q?1yA6zEtClUPz6Tw5TNE+230cudrMT83Pm1hAwOL+I5VQRpR7CgDgTSv6ULBm?=
 =?us-ascii?Q?jSOKyyLRPWvuH72Q4M2x0wZ+5hLd/DTob8Feg4zsbeTP/9AwrOd9D/Yc0pFG?=
 =?us-ascii?Q?Y1FhqD4gsDteOfCP+rrHPpfqpaQ51+vsZyR08Q/A5YkOXqCI8Htx+uPr6FEC?=
 =?us-ascii?Q?YxskaTjEzPe5Wtw/xWNeYdxMGqp1101OTcaNTLeIjHwhTsL+S7EtO+OamGW9?=
 =?us-ascii?Q?Bcik4Rmi8Gu+kR2yOhteixlkxS+InMfedqQUN2PxuEHi/dmhXmFbIsV3Ntkt?=
 =?us-ascii?Q?cw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6105401-86f8-4a5d-1878-08dafa1898bc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 12:27:57.7938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zb22irZWNVWYN0wxhFBP8+pXg5dyIo8KRMaXjGvSUXF4DCAaZnyHebvNJdTM1byGt030VOEiRnk8V3mQp+cZvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9376
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will add support for pMAC counters and MAC merge layer counters,
which are only reported via the structured stats, and the current
ocelot_get_strings() stands in our way, because it expects that the
statistics should be placed in the data array at the same index as found
in the ocelot_stats_layout array.

That is not true. Statistics which don't have a name should not be
exported to the unstructured ethtool -S, so we need to have different
indices into the ocelot_stats_layout array (i) and into the data array
(data itself).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v4: none
v1->v2: patch is new (v1 was written for enetc)

 drivers/net/ethernet/mscc/ocelot_stats.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index 1478c3b21af1..01306172b7f7 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -315,8 +315,8 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 		if (ocelot_stats_layout[i].name[0] == '\0')
 			continue;
 
-		memcpy(data + i * ETH_GSTRING_LEN, ocelot_stats_layout[i].name,
-		       ETH_GSTRING_LEN);
+		memcpy(data, ocelot_stats_layout[i].name, ETH_GSTRING_LEN);
+		data += ETH_GSTRING_LEN;
 	}
 }
 EXPORT_SYMBOL(ocelot_get_strings);
-- 
2.34.1

