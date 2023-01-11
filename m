Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E7866603F
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbjAKQSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbjAKQRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:17:43 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2080.outbound.protection.outlook.com [40.107.247.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDC422C;
        Wed, 11 Jan 2023 08:17:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTGAMjRSbReUQUWzhG884sC+TlgXI9FB2uoqsTGKGMwAXE/awvfV1Q3J/N1B71dgSMVCM4uTfoISs+vJG7Ge0EInBjezN5Y38tpzfX4lUkDDHkCcUUhhxYuVPpIYW59P388RECMTesweafsbg3ePuj6T9zJZldjHo+KvJ886Y2FJ72cUgnZCRte+OQJEY+qQ6XbfTWgcGbXNxJ6cGDRR3ZirH0NAJn3G3mfhlyaG9EC2FW3V26lS3hb58TUWfVCSruWACJQBfMW3OJrW0KZQUKiZBYXw9ZXfoX+obYXsr6uPF3bQWTFulnbHOTjt/DAvZ05YspeZRoZ6JPmkJotmpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cnt1GnRC1O1VQddtx48dYukW1sO5DRswUmys6wy7AhI=;
 b=mC7wmgdCy/40Js7n/1jGiECcUWiBlH6kjGwq9IZVgOIcicX5z3C2tk4Op7Jc/i2uTAcdG/z47W119E9C1le0/CRV7kRMvsFH4lO0cnYFBsXEW+0bOm82weLyqgot5qmfI1mXuyUrrmuPC2U1AEvF8FR1mFc013f61+42Tmr3XkPTJanRY9gfW2LY0WPvYssdiv5wbg3Q2k7ISEKi2fZyBS8nN921du1c29igM9+EhAOHlFKON5VvPjUrS482cGjoz5tS2p3a+GMgKCewhiMt2LmJAKCb/c+9zPhGTk/3gxjXReni8MTxI4lgQJc0HWAVOH8yw5iNoTQiqEWTjQa6fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cnt1GnRC1O1VQddtx48dYukW1sO5DRswUmys6wy7AhI=;
 b=rxSy5FUwGXKiqcPmTuFOiMXsWfKyEvPZjIXuBquybofMej0FvDdLTCMWaXD/LUmyd9hz0+cpgcSqXz0h9CAVb7xnsC+ts5DgleDpGrJ3fyKb9d5gwB6OQsMZTtL/DzFgrAxainIM8ncjmLZkwnPregQsMjmnj2e3rSQThUYi4uo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8462.eurprd04.prod.outlook.com (2603:10a6:10:2cd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 16:17:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 16:17:24 +0000
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
Subject: [PATCH v2 net-next 05/12] docs: ethtool: document ETHTOOL_A_STATS_SRC and ETHTOOL_A_PAUSE_STATS_SRC
Date:   Wed, 11 Jan 2023 18:16:59 +0200
Message-Id: <20230111161706.1465242-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8462:EE_
X-MS-Office365-Filtering-Correlation-Id: 18130050-9d84-472b-110e-08daf3ef52c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hNeustVFZ8w2mEl0JOxoCl2+hImk5BqdcowsuyuPCib213+uV9LmqQaPDEjxyYzy2ja5wzUnsSenEqnH8drqYNzQRI7k94svFby/Uit1/6jbJfIhWH0x1E1ANuq1Mwb3eftRcGhR7t/451xAEIYHMIVl8y1oagY3LbmEw4Er8VNZE+6Hn2u23VHm6LjDHet3ymy2gwR6y8LEwOcbvpnE68Xt38dVEtZiOi5Ce0C6kcFZl2TspXqJyM97J1D1VF5L6T/jdM7co02QN+yLUwVwtqXiS2aJItEhmlztf/pl1hJ3eNsX/o4APWPORXcQr1STd/vJ92jfDQVCkgkubRsGeQaYVW/Qjac+/viXuaPfqamMGiAzMwZXodfIQrFVlSjak+G8H1Ut3scr6vjn0ruvCLsIok24j6jfa1zzCo7jIj2qx3Wcttu7++XELHqnf5SrZeTpzhHzTt2Cv9+DjUTIXN939XHAqrU5bJ/cEP9TC0IVmcRsKsXOCrbZQFcWJ06J+eXTmkTFiaPhbuAq1klti1Y4vd7SbsGGUqFK5h/541GIvKeAExBY894s2772uhQz5N84qsy6brBXjkMxD+oeVQf0J12/cNsT8/fhz+BE9XfQltbK6lRsLlwROhg3OT8dnQKhI9ssWtDtsaObqbCWPaYvvlfJ74gHnqbppK55TSG6Tt2LSelFTx/r8qjYUey8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(36756003)(26005)(186003)(8936002)(6666004)(6512007)(6486002)(6506007)(1076003)(2616005)(66946007)(5660300002)(66476007)(66556008)(52116002)(7416002)(6916009)(316002)(4326008)(19627235002)(86362001)(41300700001)(38100700002)(38350700002)(478600001)(54906003)(8676002)(83380400001)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RuDgozuwyDZns+uCSkQdJnZcFx+xrKN/LAp7nJa664cGl8bAgdk2n1OH/Oov?=
 =?us-ascii?Q?Bwav9gfpovqYu6gqATlF8s9PWwcCGrtHghdWEMGX5FflLgotkYNXqILs0HW5?=
 =?us-ascii?Q?AV2qkIQ8wLt8nt57bK0M5iWozgEdcUzhsS5UOGdVYLKQh1JA3SGx8MnRiaRF?=
 =?us-ascii?Q?brcISxXbeeALxvq0aU//Fa/2UKe6Pk/tBtKhO/zoZQPZZMNB90AvVdhLxO+p?=
 =?us-ascii?Q?CngXeT9RSO1pFeS/O/3xxmsSnNa1tmhWlko8DKHUF4matnR/yJ9WbcL6d21G?=
 =?us-ascii?Q?sh2fZkithJlcZHurhOeeqk/2AMmu+xTkPebx9/U4vE7GE/IPRkQO6+rvtjrM?=
 =?us-ascii?Q?RqqvE5fthcscFaZJhw+HRG3nsjefJ7MTbOdkAum/OmNuzt2o4W5f1P7ZeNRv?=
 =?us-ascii?Q?4yht9bluQ83PTjXiX8soJgnGY6PNhaK5thlvWENd7bioikeSqza/BozdXj09?=
 =?us-ascii?Q?9wvYfxSzIIH5z0JffzXjyJEGBQ5Irux1Gslidy3HW8/WtZMRpps9aUVFNBCW?=
 =?us-ascii?Q?j70Nx4nfuEb66Bsk87empuUBqmRJvm6NFnB380WivVbbqUbE4v351GMHa4U0?=
 =?us-ascii?Q?F0ZKoK9HoTSC+CIFz3uG6c/kp+7wr9s4Oj+m67fFMumLeppxHOMx6pLUs3FP?=
 =?us-ascii?Q?OiTZkbEQVjw10Z5PkfXwgAPEFvFAlpyjmAq0lr2WDLkqTVYjXMdeYv7Ib2U8?=
 =?us-ascii?Q?5C1sGENA7FaHQPKiz/slnOZzUM+A8YkllukESW2eco8uSi3j7iZsgbBzII+i?=
 =?us-ascii?Q?fCR+6puNonqx0s95E0J0zRZUkqNjjPyN5KacndPL2Hl1dHzPCGjXTMI43nAo?=
 =?us-ascii?Q?O1QiZoPeRZSBumT9Mnz3T/IbeahRZ5VplKRFWDHfo1BZJea0VqNMF8HM8Spd?=
 =?us-ascii?Q?OuiUH60gxK8FMl2oc5/Qb6JEbj4hBcXXELA7FWpOUwDND6FPo/EAUOAeQNUz?=
 =?us-ascii?Q?vbeBJ9Ba3sU0JdShynHqKULyE1vtVqbpYN3JU+18bjxApn807VMmlx4tBiwH?=
 =?us-ascii?Q?WdGY6GavEJNsZLTfTyDxsYF0j+T2BGayjpTvyjLEpv5BiC/AmelNuhfrmLsC?=
 =?us-ascii?Q?w5i1Ynnb4pgfd61wJPYoM7dPXZv1FWBWuEzY29TCuN1Aeol765QZyHtoDcvJ?=
 =?us-ascii?Q?l7N89aTGdKGXPeUeb3z6Qcr7DmkStL/AjKD4d15lbmEQWwQ94JIQ8HKJChvT?=
 =?us-ascii?Q?q2c9B5H0xBGdC3RKPKflpilorwNTiRl2n0828wNoNqhZ9OVDV4dzhbDZ9Nz7?=
 =?us-ascii?Q?CK8qOq5ajnhvGQhoikSayj9nAG6WOhdfdWblRSTw4l/OcN/YoBR44Ounwet4?=
 =?us-ascii?Q?giXGK5+7nwIomH1HUxfkhxNYKhNQVqa8/T0XWlW4f3JLy0YCPp1sZ6wrPmky?=
 =?us-ascii?Q?m/c7IXFthgm3+ZsVB+TT5nHKX8rbQ5GPfPibXjgUAGyMWQY9IhJ2LLMMAPwg?=
 =?us-ascii?Q?/r4+KGLkuZf1cn94127gN7EbLyPDnH1Ol1clJ+secG/TBJHIY/1X69vNa8+M?=
 =?us-ascii?Q?T6QfXqoyokkapgMaDM4iJI8BSDFF/jOsIAOsKENtn6Pngpvd+5RHrG+yfBXv?=
 =?us-ascii?Q?43AKKFg/kOq1P0TAXkZLqR5bELJ4e5reO8ZU7OKeg7HAINO++CUaPWTw3BKj?=
 =?us-ascii?Q?uw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18130050-9d84-472b-110e-08daf3ef52c9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 16:17:23.9551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1i7ACDhV3aNYq5sxGEO7u6XnnNKnlYFig7f2MxZYrXyZWlUSC6VcyjatLn/MtGYzbsEzYUcxCf6vHeR/EoFnBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8462
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two new netlink attributes were added to PAUSE_GET and STATS_GET and
their replies. Document them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 Documentation/networking/ethtool-netlink.rst | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 490c2280ce4f..3805e57f9888 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1075,8 +1075,17 @@ Request contents:
 
   =====================================  ======  ==========================
   ``ETHTOOL_A_PAUSE_HEADER``             nested  request header
+  ``ETHTOOL_A_PAUSE_STATS_SRC``          u32     source of statistics
   =====================================  ======  ==========================
 
+``ETHTOOL_A_STATS_SRC`` is optional. It takes values from:
+
+.. kernel-doc:: include/uapi/linux/ethtool.h
+    :identifiers: ethtool_stats_src
+
+If absent from the request, stats will be provided with
+``ETHTOOL_A_STATS_SRC_AGGREGATE`` in the response.
+
 Kernel response contents:
 
   =====================================  ======  ==========================
@@ -1491,6 +1500,7 @@ Request contents:
 
   =======================================  ======  ==========================
   ``ETHTOOL_A_STATS_HEADER``               nested  request header
+  ``ETHTOOL_A_STATS_SRC``                  u32     source of statistics
   ``ETHTOOL_A_STATS_GROUPS``               bitset  requested groups of stats
   =======================================  ======  ==========================
 
@@ -1499,6 +1509,8 @@ Kernel response contents:
  +-----------------------------------+--------+--------------------------------+
  | ``ETHTOOL_A_STATS_HEADER``        | nested | reply header                   |
  +-----------------------------------+--------+--------------------------------+
+ | ``ETHTOOL_A_STATS_SRC``           | u32    | source of statistics           |
+ +-----------------------------------+--------+--------------------------------+
  | ``ETHTOOL_A_STATS_GRP``           | nested | one or more group of stats     |
  +-+---------------------------------+--------+--------------------------------+
  | | ``ETHTOOL_A_STATS_GRP_ID``      | u32    | group ID - ``ETHTOOL_STATS_*`` |
@@ -1560,6 +1572,14 @@ Low and high bounds are inclusive, for example:
  etherStatsPkts512to1023Octets 512  1023
  ============================= ==== ====
 
+``ETHTOOL_A_STATS_SRC`` is optional. It takes values from:
+
+.. kernel-doc:: include/uapi/linux/ethtool.h
+    :identifiers: ethtool_stats_src
+
+If absent from the request, stats will be provided with
+``ETHTOOL_A_STATS_SRC_AGGREGATE`` in the response.
+
 PHC_VCLOCKS_GET
 ===============
 
-- 
2.34.1

