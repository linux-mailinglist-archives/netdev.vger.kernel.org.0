Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597F857EB16
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 03:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236868AbiGWBZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 21:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237168AbiGWBZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 21:25:00 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00052.outbound.protection.outlook.com [40.107.0.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C16ABB5CA
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 18:24:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e7Be0H81U010fiiIzhSa+ZTQRKW/CHNIJSyE3hu/YCGYELSTvZ7GJ+s+HtkkIsQ4O/pSIY9sMMzxLAcWXCbWkW6mtSPAM1AWZN/IIxEYhcM2epCYy4h9lgOwnXKTxAU3jWCTkoc6H210JwqHk14c6cCPA+ii7KI+pQwAinm4/FtdJFUfK+HS+3JtfgeDs6hMV11MMN/BI3uKn0KNYc/gYfy8YH48NqPlUDkPiaKARoyJzGNyHHOSx2QUdrBwlLQzAe4SCalKMU79vf5wRBpanpzsZWBre5N2b3mMc0I5z6yVacZi6kBqynzAudgpMMUEM/EBelJ+jUjQXlQOvGUdIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4xQs/1btnFBVVE8R9T1go5x/XimQb31lpmkK6V5R0U=;
 b=k3pePm9PRvi38rTyu3uVQtunF6onL+Zv6YmClrtU2GmpQwcgddsbQEpUmlM84w/Ssi4VxoJWtxBvNAlyVavm5bKB5s06iyGcy5AX88hUz5lFbZzI7iq9WNe3QDaQTc3d0ceH9YGIhelsdut69x2wb0n161W9Z3v5wvvgzcWcSm/OWk46M2hTAtmiUxE3b34qBYjjs0MJsQbUxz0xCp7XRFg5hIJ2NDx/UJKz+gFCYLSfVjxwk/4+xbWwWItxouDLus/TqL0ZYBIJpn+V+fvuHa5HAspIjQUWT7GFphNHu6GWi1h488a04oTJdp8Qu+fHn6puksTvaofXFJXrYeGBNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4xQs/1btnFBVVE8R9T1go5x/XimQb31lpmkK6V5R0U=;
 b=SklwylZJYGKc0vwi2iYryqu0Q4TQ2be4Ymp4syX8a7tHmKd7ET72ZcWiDRfaDFJYoPlaXVk4FtWpjIFq6lW+AX4NlOfr5gxoUNPHSPvSw5k7vs2CTR6QaC4XtuBRjQxW5NYopZ+csnQaQDnY5RPEkg/DxpLVvORy+ktjR423XTg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBAPR04MB7208.eurprd04.prod.outlook.com (2603:10a6:10:1a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Sat, 23 Jul
 2022 01:24:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5458.019; Sat, 23 Jul 2022
 01:24:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net] net: dsa: fix reference counting for LAG FDBs
Date:   Sat, 23 Jul 2022 04:24:11 +0300
Message-Id: <20220723012411.1125066-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0125.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3b880f8-c9a3-4646-3606-08da6c4a124e
X-MS-TrafficTypeDiagnostic: DBAPR04MB7208:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XJZWJ8VxkQDAKjA3B0qDQxVug9wXq0zJ+XkTZdeEyWKZMbo7XqyR0X93wQ3hq3NoQo/phiZEOGd4aJAaVNCI4VqdzesSbj2QWcXP7ql3o+NSlysv2qZ2KStEkm3Fua/uALakfCEYyhgHqE+j8Fm3qN1uO+5EViHsJ6BuXmSw9FHEgoj4rHVuKVi7HbnZpMkyrdAEl37mxUHk+Lm++esWd3TU9X+hQ2n1oVfqBNlr2GCvZcCLALBmLX79cX0B8sSg3TfBHYQcictq/QTNzqh9PX7MW9Wvm1DysZjVVTeUJl4qJt2ceVma221wr+E6HYTtbXxv2arKqqmK+rSziM5oLiVQlRt2Fk1pAjb6UNJ+Nxinpl6PXO1d2ZuKUAddbIVzp76SSlo/FCO6vCS9uvTLxA6+BZuSf3mg76cSbxIZ3h6cM5/9W4DSmzgtVEIbCC71/hyKYb/YY9TtBFhQ2FRo84ueaF3XYFfPempR0bbuTjpn9yxk2/9LNL2LB9mtyrGbDRCX/dLUUO/hx6N646CxQVleV5L4Gl7ObIrd2vNUjar9i82EqwiZA9b7n8pyGs0D+et7zfc1Uuosj8GggBveCixr9Zq/b0PqE+o1etv5mJikUcLHTLwczcvavmKDff+vbwB+1Cdn8muAoiclegYFohR6f2ZJmrPPFq8g1JI8f7jy5fiKcFqF3E+KyT7zHarAW4nMlpt4tBfSMYdx2yDXZxkh+ZykxnsEMlzgBR2bUxzQMfwEW8+U8BEPEAiUq7oBc2OlNzNTmUh27blGqXBLyvhVmFyLZVbsNgUWSWwGP1I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(83380400001)(186003)(2616005)(1076003)(66946007)(38350700002)(66556008)(66476007)(38100700002)(4326008)(8676002)(44832011)(8936002)(5660300002)(316002)(6506007)(6666004)(41300700001)(6512007)(52116002)(26005)(54906003)(2906002)(6916009)(6486002)(478600001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HuBMpiI/DYxjgxLMapdkUCdEQVxvV7UxX1jeo7ClF18PO1U2Zy8vESFXwaBy?=
 =?us-ascii?Q?KtBNcsTTKjE2wxacGiCNmdWaDK1VBAzbgbaM8Vm1bvUR2aMDiImILaQIwCB4?=
 =?us-ascii?Q?bh4C7aKmGUMGmcKImWPfqsHekzsD00BpSRr992U2mZr+cyB2gMngiQiB4JOz?=
 =?us-ascii?Q?Z2LQHM6AKzfdjjmihXraTV7OXn/zCCjtdrutZ/Vy+/EzDR0mg6u3/gdA3qvE?=
 =?us-ascii?Q?1M8ef9mHCM654zTcy6SrEKV2bddONvJUXbuhakFcfatrp2+K7GAfIT2Ke60t?=
 =?us-ascii?Q?Fl9X/0JMhJlYrwqWKpO4I4Q4l5PS6tNloWFn/0OMsJXUXRJqPs5XNlRtPRcd?=
 =?us-ascii?Q?7/G9FOF8Ayg3tcSgIjUZr7EF6iKQ/m/0igp2yLfMphgKo1HSRJyloeSfiRtU?=
 =?us-ascii?Q?ZuZ6RN7or5JW3wyWpWoikmq3YMf08E6OZO7Z11go/xtohRUGHwSqdkAMWCwL?=
 =?us-ascii?Q?KBA1GX+TPOKRZZez26A7s2vCHW5Ai4TkgETe9NJ4qSMLNU9V8ZE6X8OEPXKd?=
 =?us-ascii?Q?i877bIWzzbdwji+AiaJCn1mZ533Ap49pj4gHSfn8TpAt+mk2XX288+JfoaYl?=
 =?us-ascii?Q?8cKXLxaWEZfheCnp6vtBsFI3LDX+f21ETEP7PRbepUpSgPy7s3sEX3HxVu/F?=
 =?us-ascii?Q?S+5wumCoHYh7FH81IJLNYbBFULzMFmmsnNuE2baJbq6pRrpZhrmX7TVBXu4U?=
 =?us-ascii?Q?K8LW7J87Bp4jYG4tw1mNm/zRYQiFKU1wvyL9d21Dzym6H8BgIYnxHVJcb9de?=
 =?us-ascii?Q?rYX3BbyeX5Fjcn4fGVi+oJwBxdzeJQWqz155OnrmRJT/BajBcQU5q08rDZd7?=
 =?us-ascii?Q?TwCir0H2prch6XTn1LjTN9WTuOImSHF7SnEzYNZBn1etWOjCvCMU4RDirSTm?=
 =?us-ascii?Q?zIXb2BrgukY8pi9WW/e1ETm+TUIW1vuXixLef+yVzKato/Sw9H5yAS8u0TAm?=
 =?us-ascii?Q?J02ahTkHArA2HTqbCXB9qEpsPXgq3pAQmuCctAPPNb8ukaYwNT8SNEDHgKAw?=
 =?us-ascii?Q?CQoRalSeZIjEHaWqSX8oqG5b5kExEanpfhANOfO8WASp63zSXoxnYrs30EQ/?=
 =?us-ascii?Q?QfmGodRQt0CfAty9oWm0D97m3R/MSDJrMUZ/8ZzxDv7k9NSHv14Yd+558MqA?=
 =?us-ascii?Q?lKH3DRXtio08f2/TrkRevcC4+Bs1V0DzeI20htWaLFsMIJ4OHQrvp3hLtT7P?=
 =?us-ascii?Q?FFSrLodFG4gc9LLJ2jnQztBK1i/QyCyzNKenUcVZS4MSSopMgnRI3DtYkPnQ?=
 =?us-ascii?Q?EkGCekqdT+toD+9LXXsez5/W3afU38E7Nl6sev4Gwpz7Syw2wVXT9JqgiCNb?=
 =?us-ascii?Q?ipz11rJWqZV4co4qJsMP7NDdiihGBMUC6rSmRhUKDQ/9Y+iJmleVcLiMpUUJ?=
 =?us-ascii?Q?zOHfk8FM7LJE8z8ZX5o9OkUe6joVMRsA6SpoM89Csvimugg88lXYhZGzcQPp?=
 =?us-ascii?Q?OHc3iBEc8qce6bU3JBd0bNEx6UybnrWAbEBIwf6To9HcKOOPkLMaJcS5qN7m?=
 =?us-ascii?Q?ec4KAdVGdSR1vKGX9vMr5ZxIJHNB8l20ckNNQ0VHaSBBySvvidf21p0j3VXv?=
 =?us-ascii?Q?LFGffbdjqksIi2eL7qt7HYlkam6auEaqCIY7KHCid5BbxnOFkHxla+emmSRq?=
 =?us-ascii?Q?HA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3b880f8-c9a3-4646-3606-08da6c4a124e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2022 01:24:22.2622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y3k4N8M8U6L5unPg7jUCbU4fY3yIz/Vb3sN0VoQqwoiZXC7Dx4/QPRR/15BlliU3eCGaikKnewk/gqwWDXVfQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7208
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to an invalid conflict resolution on my side while working on 2
different series (LAG FDBs and FDB isolation), dsa_switch_do_lag_fdb_add()
does not store the database associated with a dsa_mac_addr structure.

So after adding an FDB entry associated with a LAG, dsa_mac_addr_find()
fails to find it while deleting it, because &a->db is zeroized memory
for all stored FDB entries of lag->fdbs, and dsa_switch_do_lag_fdb_del()
returns -ENOENT rather than deleting the entry.

Fixes: c26933639b54 ("net: dsa: request drivers to perform FDB isolation")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/switch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 2b56218fc57c..4dfd68cf61c5 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -344,6 +344,7 @@ static int dsa_switch_do_lag_fdb_add(struct dsa_switch *ds, struct dsa_lag *lag,
 
 	ether_addr_copy(a->addr, addr);
 	a->vid = vid;
+	a->db = db;
 	refcount_set(&a->refcount, 1);
 	list_add_tail(&a->list, &lag->fdbs);
 
-- 
2.34.1

