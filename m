Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CE44F9DEA
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 22:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237560AbiDHUHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 16:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbiDHUHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 16:07:02 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140057.outbound.protection.outlook.com [40.107.14.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD61D129868
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 13:04:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oKFksWfqbUS6X1VGK31Bt3SGxAUBfo/CPXdtqqhujx6R6jhyKFw2hZspTUQ7oiHXdBkk9fthUunw7ji+qZ7diVL6mwTD30sYGNWiKhEL1WRPperi/yi9IUwyjH//SJkiCpX78GiJ719INn7fVB2DQAyYPihQd/5M3cFBHgDe8VtaOCwI7u2LH0XwgeVgdVUE1J9zPcOU0g0U5MCPI3LVP+dFnHp6DYSONrw6gvbjARzYSDmYEmFFyrgx7yTbn7dgcMcPRqy2M0+eZVqgFPZZcYixHLgtSn2YPnuDn+/uXNV0Xgcfme4N6FI/hZ1aK//MEeD4k/GUrGAII2mMLteI1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c7gde3E+qVps5V7NE3n5NgGLv4irmuOltNjy8rsELbM=;
 b=FwpQ2XJyTKE03NIUI18dOn80jsWDtOAHT7gPMkVlwReIwXmkGoZTvd9q7nSsyVrb4XyZxu/ye+Yuj0vIFUeECg1QNYAy1ERJW23Mhem2871GR980/wFSElhNXqY+0IgXHuenTqOdN7B8QFsOEaZ6EBqdcM3BF0/2sTOGivfnECL9R5LoV1DA+dJcSTLqjE1fqtzCr0h1wGO/GWwr7vKLdEI4o83X6iAjJ9/TO1TtzgWwb9voWIm5x20O5U2lJ65g/EtHweYE/UVpmYLY/bvdHwkKWx1q69zY8eDiM6QTH5UTsmoriYjAX4tOHeRDV43y4nj36b1JdFvjhwWiql4eNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7gde3E+qVps5V7NE3n5NgGLv4irmuOltNjy8rsELbM=;
 b=Ivdlam8tpfkNdVHLGqC5O65EEWBcjzvBaFTtiTz63+/09+nTFEi5IE/Yg11CjN48eYl21FNuPx5YHUO5mEeRdxMA+Y9g5ZJaPuNJvf8OyVu12UY320X6j2To+OBi4DC4Whl2zdhonB3LTgsroULb2nfqcTDxs9jdZjXcpPM7Yoo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7803.eurprd04.prod.outlook.com (2603:10a6:10:1e5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25; Fri, 8 Apr
 2022 20:04:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Fri, 8 Apr 2022
 20:04:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next 0/6] Disable host flooding for DSA ports under a bridge
Date:   Fri,  8 Apr 2022 23:03:31 +0300
Message-Id: <20220408200337.718067-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74675006-f260-446b-dce0-08da199b0c28
X-MS-TrafficTypeDiagnostic: DBBPR04MB7803:EE_
X-Microsoft-Antispam-PRVS: <DBBPR04MB780357C53EC6B7908648CF10E0E99@DBBPR04MB7803.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MvUnbmDRqhij0WMTiT5ktmnPJxw/Dnb9M5SD0MT1YRB6O5r1yG5WKJ98dVuSfUUAvy703uR3uRCIu15fDsGuCS9sjhldWp+8jPy5vSpyggwnAvmFxJFsDLV5w7eLInJyfIIR41FEHCDeU8+SvHuBfR3MZ/5mgegT5EqY9tG0GuwNznRm7lek18M6Ld99VxG6pkzMVXXS2WQq8We0fqsUV3n4ESLNlcD3cok0isHK44aiPjWu66DUYrCX/eWhP0IlkmGq68lkDpps3KkPTHBWLogaOHOTXCbv7SgYaZG13i4kzoYobB3Q9UAWW0RXodGh8x+lXoCkK6IjmKICzNcNRRUXONoG1jKFfr3bH9bZXD07XPXCyifaAwn/KXTO0/LOfEZx0ji08QFLNgKnRU3JS9wKTH8gr9NjZbm9osVbJYvCvqtcG9dOHTerZdPiV7y+WSdSKzTqa+HJl0d5iX2Z8xvJGYSP2tVc/qAJ5CJWe6rBpoHgqwJpwwDj8Vln7wb0n31/g6K1Cvk8f97W+USDLx/zsniJNdZFlMqjlnuM2+TRNa2RAZe5jf1yRfZsfhSzALYtRCAO+I0E8OqyOMu+FCn9q81T8Mk5g6XUn1gund01SR23VPglmjHR5NM/lZ+bWPyM9pJ5p1ztxf9ti7p2mH3uSUIZd7U+edG/px/wpju1EGhqb97fZRkwZ6zb0W0s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(508600001)(38350700002)(316002)(6486002)(83380400001)(6512007)(1076003)(36756003)(8936002)(2616005)(6916009)(8676002)(66946007)(7416002)(2906002)(66556008)(52116002)(66476007)(86362001)(5660300002)(4326008)(54906003)(6506007)(26005)(186003)(6666004)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IMiLPxM+D916Mc/LigpzdiVgLswKG5x1PO23z+HcyfMxg1H4cDbkXzTVPgWi?=
 =?us-ascii?Q?8zt+HilRrQ/o1wQpV/sfVXwkbSW4TlRWO0MjG2rQtHSC2BJ8vyLXPx0rxmXi?=
 =?us-ascii?Q?VW4suve4GLiih2H7WWhJv2ritLHbNtt4uikHxrqkedPRXobo0JBLgrBGusDi?=
 =?us-ascii?Q?jF3q02X9rOg7abYtmkXvQnqGAK39w3Nan2DUAK6L/Q6gHoZ3x4SqZ23yBro4?=
 =?us-ascii?Q?2aEYBcQgqU545n4eEUJK36duf540UHZMYwlAn3CYPemrc2l47H6Fi2jZRJ8S?=
 =?us-ascii?Q?ok8wAUv7Sf7t286qHbNljeAQkpQu+NZZriYzwmXgI+IUnZdw9fuXLEjYccmO?=
 =?us-ascii?Q?F9EKoyh6zE9xdl1ljG6idkgqgc3bDMBumQmBnlxpQKuBTqZ7Y36I9jB/RsKW?=
 =?us-ascii?Q?H+5AEwxCX2PKhG1+v09mDBL5LDDXDv0k+jUp+JyqA3NqUQNQ0i4CYpHSQzo6?=
 =?us-ascii?Q?mGx3gzcRo5aWRlXjAQQ8xEUDeMWO5/UukPAaR3SQwKJjItIq1wMg0JC+0hAK?=
 =?us-ascii?Q?E/179Hw44x9ohSs0OEcwtRCVBLz0eUAa+Cz6gmftWCVssNKZS0vVtHY8yQlx?=
 =?us-ascii?Q?VIE8uuZ4h0AeS7mDgS4UIPTs808JHi8gLf93KiRAbZkivxTxRhT82/d+/nOO?=
 =?us-ascii?Q?2FV/Wt7+mwYE4Xu1kU4eBVEKRUn4xSx4TwV1x6p0nE/SFr418c7UNP+c0QlL?=
 =?us-ascii?Q?/+eHxgnGiEcF0DDZC3dBfBiKxuIODka3axAANNL/2iZH5f0NDEgmPZK58n8N?=
 =?us-ascii?Q?Z9sKa7d4jQF3/LfqZ9o3z1Rtvbmbapa0WflV8O3NjNijHnSdWXbyYacO5hpS?=
 =?us-ascii?Q?YOy4nXCBTHai/ULVwGtCh2KlkQraycxwow6LGTyd3LnR5N23nWPBJnoaz0Y4?=
 =?us-ascii?Q?pfjAKwt7KS4nnnRuGNMJOpoiUmwPKdCEKfpL5EWWpI7CSue77tFPtGx37uhj?=
 =?us-ascii?Q?9Ipuf+mAT2bD4Gxv07eJZ2XyjKFkRuijs7Vp5YkgsLa+SxeLCL5iWbLCCKRl?=
 =?us-ascii?Q?+nNnxZwu3XNsJx1M15Carbdleqzr/Lr8e/ZWYmP6sqE5pW6UCvhP/RJWTLzN?=
 =?us-ascii?Q?wex6D68rTMwEta2OR3Bz1qUrcx1DuVKW9AfupCNiaJxOOhIbMiHPTz9OJCse?=
 =?us-ascii?Q?2V1md3nCF1DLS8BkZCzL2hALVnZYAVSN9PcC08chA4bhjvrKk5DaPcuF8a1M?=
 =?us-ascii?Q?yM0DJLSw24ZZfn1g1yG/xoPmAMeSai9gWGJGZ9vJr1eSSueHLwvC7VQw+ORN?=
 =?us-ascii?Q?xYwEWFJwtGjj7aa+/YO6AXBVoGoCehGCozUv1yNag02pNQ2JtLnMRD21jYNL?=
 =?us-ascii?Q?dRRa8+NpwqRSQsGlA6maVhEF4DQ7rEN0aIUKtdcXAbUTjY04lKVSkeQ2+W3h?=
 =?us-ascii?Q?8ZVsgKXV1kMvpwhseTsPtMVkhhoEBlVij23f+8dpUh0h0aE0DeAlCKJ8HCHr?=
 =?us-ascii?Q?3OIcSKmSoqYmwlQVs2eadl++MaK322eXvfwjnl8XAN+2snIpFOVgWTaVEPXR?=
 =?us-ascii?Q?nQTIcqkdyu/YCZuzmZcCvShtSFqIQQcx0dartJE7Jb0XZ4RzPZzsaXCk27/U?=
 =?us-ascii?Q?VT6hL9FG1xFEtRyPRYuvMEE86TkM2nMYWFtz/KA9KV5M2S8R1S7bnyY34hLF?=
 =?us-ascii?Q?bii2WwuC3E6YSe03qE0xrEYUFJYRuP3qKK4+AMYuEwGBm+r5tTGC4XuuOBj+?=
 =?us-ascii?Q?QfQGkb7NTgkJ7bZ4IZfIS0U3FJFgT7/Og5zQr3zYjeLZuGUUfvfpZJcpuZvY?=
 =?us-ascii?Q?KiZTfFSL/HJm+QkTJUrWujFiBJhbrco=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74675006-f260-446b-dce0-08da199b0c28
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 20:04:54.5819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TdEZ/EyL46+1R0lbQLPDT9gzkLqUAEfrut1y5tT77WPtDT2znbwurp+UtqK+sL8ckqzY9Sh8I4vcHZd+Txo0Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7803
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For this patch series to make more sense, it should be reviewed from the
last patch to the first. Changes were made in the order that they were
just to preserve patch-with-patch functionality.

A little while ago, some DSA switch drivers gained support for
IFF_UNICAST_FLT, a mechanism through which they are notified of the
MAC addresses required for local standalone termination.
A bit longer ago, DSA also gained support for offloading BR_FDB_LOCAL
bridge FDB entries, which are the MAC addresses required for local
termination when under a bridge.

So we have come one step closer to removing the CPU from the list of
destinations for packets with unknown MAC DA. What remains is to check
whether any software L2 forwarding is enabled, and that is accomplished
by monitoring the neighbor bridge ports that DSA switches have.

With these changes, DSA drivers that fulfill the requirements for
dsa_switch_supports_uc_filtering() and dsa_switch_supports_mc_filtering()
will keep flooding towards the CPU disabled for as long as no port is
promiscuous. The bridge won't attempt to make its ports promiscuous
anymore either if said ports are offloaded by switchdev (this series
changes that behavior). Instead, DSA will fall back by its own will to
promiscuous mode on bridge ports when the bridge itself becomes
promiscuous, or a foreign interface is detected under the same bridge.

Vladimir Oltean (6):
  net: refactor all NETDEV_CHANGE notifier calls to a single function
  net: emit NETDEV_CHANGE for changes to IFF_PROMISC | IFF_ALLMULTI
  net: dsa: walk through all changeupper notifier functions
  net: dsa: track whether bridges have foreign interfaces in them
  net: dsa: monitor changes to bridge promiscuity
  net: bridge: avoid uselessly making offloaded ports promiscuous

 include/net/dsa.h  |   4 +-
 net/bridge/br_if.c |  63 +++++++++++--------
 net/core/dev.c     |  34 +++++-----
 net/dsa/dsa_priv.h |   2 +
 net/dsa/port.c     |  12 ++++
 net/dsa/slave.c    | 150 ++++++++++++++++++++++++++++++++++++++++++---
 6 files changed, 215 insertions(+), 50 deletions(-)

-- 
2.25.1

