Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C8C5183EF
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 14:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbiECMMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235097AbiECML4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:11:56 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50073.outbound.protection.outlook.com [40.107.5.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6027837A32
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 05:08:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nViYNCSQYE9dI8rEMiGpO5KmIRLdQ5Lhfz6CB2kzlrWwe9AHvq6GAeSYrD+UwuD55uVyZivFz4PRgUmdSJMlpt4grR5mGbPZeYTFwh8juhmH8E90xEVYG24r/kR3UCzjtX4F0ktlZrdRvgF/EpkHjolUjIuVQkCKM2lLkU3qGlxEHHwbGaPFy9SuXFR8cgP2gC3wn1lyCGp5ADS9BcBYLll8yUC+9RMueZ9XPVUeHDpbdIVWSUfk512b6Ioxj+xEN/AM3LzmBWxHYVciQ1QGV+xcjVNT+FqaJIR/GICzjum3YSUzLXaMqVnXGPTUawV+na0xYxpFB2ChC6RuaFeJyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ESGEf13eUGOqRBhKFNZmvXY6lzqDvtizXR6KQJvmsE4=;
 b=b89RtNzg+ukjFTBya46fHTAdnBxGbwMKIC6evFCHgRdeOX5qj6BRr2kb7+K4Gnob2l2Cy1tbBdL3LnPcmPpY67uUQZZ2iaaGoN77OVwNO+BwW8wdpjFDBPdbK66z5QPoNd4c/LoXJFaYJhoxu9aA2x0WcmurDcxuKxRtynGvruarDUptgkzmogvyV47cTMxBEJeS2qq3ZB6BxSE3pghsPj1iHqkGWnw5UJ3XP0CB++VQAx8Pii3yTWhWjX7NnbpUe1YprN54aCuNEfa4oZkLRiwgrHbRWd7jl1g08A29z4Z8xh1QZI7zUYozWfv3Fkb6FHv3VNlzM7KU92UKNZdNHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESGEf13eUGOqRBhKFNZmvXY6lzqDvtizXR6KQJvmsE4=;
 b=J2bSRjHKnWXBxveDf4O7BRWohs1mk8/whPfJCvx0sfrJdr8mCwmPRyoPod4sAh0A7g0ARLzVgxLjRviJX00CettPIR6iVMcC29tIzy3JBaGpQ6gHtiy1nA9oK9bdMCA9Defi3fUSKB+TXpf91aHkw+oTPqC3WsaJG5QOX5uhv6w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB6PR0402MB2743.eurprd04.prod.outlook.com (2603:10a6:4:95::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Tue, 3 May
 2022 12:08:22 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 12:08:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 1/3] net: mscc: ocelot: offload tc action "ok" using an empty action vector
Date:   Tue,  3 May 2022 15:08:02 +0300
Message-Id: <20220503120804.840463-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503120804.840463-1-vladimir.oltean@nxp.com>
References: <20220503120804.840463-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0080.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::33) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 542fb28d-71b8-4a2b-5949-08da2cfd9e75
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2743:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0402MB2743F3BF61360F55C2EA465AE0C09@DB6PR0402MB2743.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fcWKrQ+KQnFrv683ZyQxNd74wOsKs7Y48E4EOmUNAgbn2QQahJaS9/9DuVkxxmxkmYXdiYRK2+OgVVFSyqqPOkaERb0FQdlbRl8oABS4Jg0gVlu9OQMHducvqxZN+UgJ1LZBCAawmxgr91gXL3HlYrlHBhPxHGlZDcKF6bVJEiW/IqyWENOHlhHDQ3bu1En8SDJ/hsRZ1pFdRfLPJxcEi9e6nbVu/VhfteV5D1DEaibfKlvVQ1uO41Cw12Pm8QeZ5mMgo+JfKew/xf7V34Tv8fQnh+ywR6IppzsSpLhLSEVEM87gRE3zo07aw0c+zQzkjucedFW/5EgPZ1xlittkhTpCJLlo+oxomNGz9qZQlDjiQL+jhXRvXL+G3jbyxx9m56YgFAybn5rt3SPuF5WKsaXSz5n/KFUBJm8ssREgx3e7SOT8Wk4t3VwkXRWWn80ScogRMGqZ50nhj89m+wvyB+hYhcbA8A2aJ4uxekBJd5cpQTnJBdgr3UW5O+SevNlxVpusujU9xTNWwJ4y9RRoQ/pCEuh6ccmq8X5vN/f5znbbaO4rYMVoTfzvx9gSyih0Zw/jzzlDvkcfIKrnX1xqwsQ7t9lDLQ1UxpiM8tryEUQik5cS9VU7pzGGdNrD8FO6ArSWi4g7TGxB/hqFqAhcS/XwF0cInv1jAKLAsjSaGwHiqeG2fmqdPmAnxpbqxl9tlfEPqTQG6Uf5NoIi6k22NA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(4326008)(36756003)(52116002)(6506007)(66476007)(8676002)(66946007)(66556008)(2906002)(83380400001)(186003)(1076003)(6512007)(26005)(2616005)(44832011)(86362001)(316002)(38350700002)(38100700002)(8936002)(54906003)(7416002)(6486002)(508600001)(6916009)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S3J6Es3VDVFypx6IPi0GkNCnz+uGyE0Ir49RLsoPyQaw9Sm0yotrFS9noLy7?=
 =?us-ascii?Q?VqFOorfTKdOmO04IPerwfTk50PApVVjY/iZGVdmhxA52iXbPchFpHbpTCASC?=
 =?us-ascii?Q?AlVlRA+fSr80/+djynKPt7ifQFScma6h3+Dz2Asu3W/shRMF3VGoyy59ALpB?=
 =?us-ascii?Q?Gs8EQs2sJnn1PklHhDRyZ4GsZiBMk230ewN5JC2VjwJTeFshQlvNvMMjTe0m?=
 =?us-ascii?Q?AIc/+WvOPCWeuNDlS/wEFRTS94aY/WjpPSe0EbtXkko2pMUK0JLIW/tAZipi?=
 =?us-ascii?Q?fd1q7SEJI20UenwgJ7gSunF2lTHJpBYftsMxyQ/yMnXh8CSlXb30UTXbRLho?=
 =?us-ascii?Q?UMn1owgKsXjFDk+FgGJ4rG0cmppkJlzZziRUQHmQgJ1tTu+cqyyvCg6ZfNzR?=
 =?us-ascii?Q?Gngb93v6ES7sd6ZM65qhBfDqHGhcYIKT+OlRHqAdU4meLRbetqaLpoA8XQH8?=
 =?us-ascii?Q?mvPt+I9Hr37KFgzk/43xTukDlIPDQC2iJ57L2VymaUwQFTFKVE2sgQqwOw7A?=
 =?us-ascii?Q?fUfkhvumQVN6Q6yxAY+tMtx77OL2ymixM7DW1pO1p20I2skq4x6uIvGNz9we?=
 =?us-ascii?Q?dK8vTjMG+hQNt8hJP8ggPqybKVwyru4VOtE0FREuax7WFysCkMUpqAbvxGf3?=
 =?us-ascii?Q?P+Hgk2IE9Jx4OD9pMmkFEvU6vgyuXr4aW8nti8euSrcsnTmGNpxSveMI+KCO?=
 =?us-ascii?Q?kOdx6KDZPfGPsMNEmmaVmtTkaKLiwbfKgufs0nqJCg9cgY3WAtqJc1suLjnW?=
 =?us-ascii?Q?VzVR++7lCBxEwrsOh7t1OYRmfVI1Yyzt2wCXXJRfwbuPhx2t45MJvdXXXqu3?=
 =?us-ascii?Q?ROMpH44ea8nPoTFqN0OZV7dYkUdB7299pYSpzntvefIGgyPOzcRRph8qzRcF?=
 =?us-ascii?Q?dODH2jGBcMHMmzFvv+AUpbNLaNv9VqyFVH4vLJIRJKfrqE9nAfbXpEZBF7dK?=
 =?us-ascii?Q?bY2Dc2E6YzDSI10t/O2dtgnC+lrVT6O0uddJMczmk8D9lFO5IWSxgvbUr1bN?=
 =?us-ascii?Q?d97m32mihzYEpSmOGhMq8TQthcGkn1s1b131s1fvF/RK9HglML/dG5z6fLMi?=
 =?us-ascii?Q?uS2yd0oxhZpPlrvJ5qDS17zspjBiLOSFmPIDiOfG39nSz22N26dJ8KgJJ7V/?=
 =?us-ascii?Q?fF5OvJtaI5+4JaJ4koWokTT13P2S0q8f1aWVFDTNNqb5oqUF8CobZ8LHXgAi?=
 =?us-ascii?Q?lbI7AJhW2IqxdZZ2EUcUdk0JoazWMVU38JSoYTAR5QEh8BmuWCVQqt/JUjFy?=
 =?us-ascii?Q?8LQIom/fmcEPJK9oVwDntqNK7tgQcffat+2NBAOni83g08AgDSYwZTgqVbuS?=
 =?us-ascii?Q?VXn2UqeJBq42YeCKv2ovRi9xHBLP/mL1ylV15BMJVJM4hHXKS2P5UIhWnVZ1?=
 =?us-ascii?Q?BDT0E5Gs29LguPHo+3gpnrGlA5KivR8VTsCaHvUdFm0TDNcnpzlIYGD6R8Fb?=
 =?us-ascii?Q?S4JVlxbxH0OS0nLZc56L0z3Fw8o7nYI2T3bDbkfA+8WeRbP9/c5+qlXO1EzG?=
 =?us-ascii?Q?v4U71DhfHJSnJnAe6plcFVKTWVNgUSSe+d2IibOLb/reYxIg+F1o+TOtVM1v?=
 =?us-ascii?Q?NBatzl/hwWSE1kbXydI8gKM0HLqVUcCmlWeJQMSogq42WXv/czKLuUkDHrGt?=
 =?us-ascii?Q?fWatEGvO5wnHYrN5AIaPbiyBcRCp+/8xm6vwCbm3IH2zedDBSwdrutwhB4l/?=
 =?us-ascii?Q?6bIgJ0ByW2hVJDV2fwvz84ae4vLDGLDdWwK8hz17X+uxQm+gQvoIJ1Fa22mY?=
 =?us-ascii?Q?q0XrFW43wBmx1FhAlIyd21Rd4JGrgxQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 542fb28d-71b8-4a2b-5949-08da2cfd9e75
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 12:08:22.5216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dR6xfYjFN8E7itnVTTJfglOa+MtGEV62XeRFWvwshcumlrknblfhcEezJqrWUjPBXFfOjb3hrxWvQVbxInlzcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2743
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "ok" tc action is useful when placed in front of a more generic
filter to exclude some more specific rules from matching it.

The ocelot switches can offload this tc action by creating an empty
action vector (no _ENA fields set to 1). This makes sense for all of
VCAP IS1, IS2 and ES0 (but not for PSFP).

Add support for this action. Note that this makes the
gact_drop_and_ok_test() selftest pass, where "action ok" is used in
front of an "action drop" rule, both offloaded to VCAP IS2.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index e598308ef09d..293860ba59db 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -279,6 +279,22 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 			filter->action.pol_ix = OCELOT_POLICER_DISCARD;
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
+		case FLOW_ACTION_ACCEPT:
+			if (filter->block_id != VCAP_ES0 &&
+			    filter->block_id != VCAP_IS1 &&
+			    filter->block_id != VCAP_IS2) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Accept action can only be offloaded to VCAP chains");
+				return -EOPNOTSUPP;
+			}
+			if (filter->block_id != VCAP_ES0 &&
+			    filter->goto_target != -1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Last action must be GOTO");
+				return -EOPNOTSUPP;
+			}
+			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+			break;
 		case FLOW_ACTION_TRAP:
 			if (filter->block_id != VCAP_IS2 ||
 			    filter->lookup != 0) {
-- 
2.25.1

