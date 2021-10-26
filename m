Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8520843B3FF
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235526AbhJZOab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:30:31 -0400
Received: from mail-eopbgr50050.outbound.protection.outlook.com ([40.107.5.50]:8192
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233064AbhJZOaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:30:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3taoqSwo3sVaL2C3l7ofhGfboZc7tWGb/VuPOtAcyEh5j+ge3G1Ph4I8vsvabpP8obcRXxlfY9BS3vB6+8/sR+/Xxf2DYZi59MruCcvaGwig2GRNl6YOBoSfs2OO9NVrq8fPlAYeCI7csMbmQFDS07nrYWN7+ddYCVA1lTkDSG74W9uBoWWfxAmmtiWLVX0Jso61N1X3E43JYK7/7bv3HIaqmEnQ6LGx33BO4p0jmIeq6altC6p33ZJ/ws1T/SKP6pYiZsJ9VWbpkJl/qXl/K3wYesS0OYEb8uvXMLNsT8zOJNme/U7JMKZZyA25HuuB4gRai/v0v1DFCaeyREiLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7KADJJp9OBSOAshWplBQBiSp6g9ormk6+zpOUMvICM=;
 b=MkjqJTQruAfcwVAb7SPlENIbsrl0kAKsCQGyWQ0ChkaQLK7lsgvNuHQzwWpVDpVllkVbTmbEK8JuJUGaGtaf6gOIM+2kRhWiJGYzWsZB+HGPC3ECD/zDP9i7A8///miU4cCgMxZRXQdyRn4wjI6C2ORVH4GF6lsEp5NTXndBlYDyKgZzIPDlnrTnXkEYRWfv2ggdT2bKRrYoM7obyQ2vEaFGaA8uFnJkC+EGp5nM6ehBKEg0Am3H7vvm9u2+vkoEmcWgxjUCcH3s9EmsWqgNUO95AT3FJlErqAfGUg7xCJ5J87CXtPGCDuKfhW/1p1Popy6lbOid4TMkRKcjkgUIxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7KADJJp9OBSOAshWplBQBiSp6g9ormk6+zpOUMvICM=;
 b=p2Aro5I8911U02099LLP8F4xw8TKJwAsraThgPJf7z5lkxnlsmKBcwZOItRh0+DJ15mLRBcuaxpI3FB4FmGSZLN70rRDsNw6AE08LTd2t0ae2ss3oR8A2yF/Op98R7CoTfmr7nrtaWwM6GBTqOLNbkQNS7gu5DHJ5N41FTCvtE8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6016.eurprd04.prod.outlook.com (2603:10a6:803:d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 14:28:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 14:28:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 0/8] Bridge FDB refactoring
Date:   Tue, 26 Oct 2021 17:27:35 +0300
Message-Id: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0113.eurprd07.prod.outlook.com
 (2603:10a6:207:7::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0113.eurprd07.prod.outlook.com (2603:10a6:207:7::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.10 via Frontend Transport; Tue, 26 Oct 2021 14:28:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 418a8785-afd2-4b7a-2d28-08d9988cd1f5
X-MS-TrafficTypeDiagnostic: VI1PR04MB6016:
X-Microsoft-Antispam-PRVS: <VI1PR04MB601625CA805C6D4F48660824E0849@VI1PR04MB6016.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bqknXsFVuaEKrxAE+fk4SF7DwFJNmjRodxUE7K+m359RwrSIw7hZXo3Nj7kJxy7oMcNJQ2QcXy1RfSIbkw4DUmjCrb4Ry5sctD0BbYtAJjJJljdnOdq35+Cz4IUTc2qygkhF33R9e4RkNd80IhyQtC5q5F1kM6VZZXlUtNitc73yeZekZJ50Wio6tapsLiqWDKUkEOZGlYFjS1u6q/GCSkhgu//Of1WEtJERdK4xNGLkM9yFsfScR7bNh+ykNmsItee+7H7T+EkRYglZqxLKT+xoNbnBe5hFwuJw6BfETmW2K/N0l1isf96f4jXWQtb6+q7LgOgnCBRv/4bduqVj2j44+3Qp+IQVNr2MRYMFtNb2YN+PVJ4cv+ZHSh300uQMaRFiPJesd0x18NzE3VcAA98ggv1uNzQtlwGTtHzlrBZmZaqa21PH2V+n6Zzgfxdhr3xC6p9mU9IO1FUc5TQLeboNM9/+sgpKyaM6t1CjMvx+5kiP0fojD6Z7CnbMi2gBLuc97HTK4/Z5HckZ0Hy2Qz6Q9QMu3UgL504ELHOpH+CxplRNV+dOyjaT+MV/ptuyfRTJZaa+UcbSlZsG4Aw3ESvRptKWSgivGhPuutdl0Sp2960uhY9vbVjtDCRxIeNylBA6ORv4lvMs9bSoIDDu4v4Wc/NYXb/NJDm4xZmQhntvZ+0UaJg83d2UdcaY1TWG1NAAt6oLujxO0kZ0dMPEhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(52116002)(44832011)(66476007)(26005)(38100700002)(54906003)(8676002)(86362001)(5660300002)(2616005)(38350700002)(7416002)(6486002)(6506007)(6666004)(66556008)(316002)(6512007)(956004)(6916009)(36756003)(83380400001)(66946007)(2906002)(186003)(8936002)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pwEshRfbd3FUR9o4BB3QMO2OzHxjfbMJbHfhpUcTTH3gNiTCdDtyw0rBwQbE?=
 =?us-ascii?Q?L6342S8sGtcPxD9UtUvfeHt7JH6N+yX1MnAL4Hwp6A4KCmHAbeGEqt/gAQmx?=
 =?us-ascii?Q?/hZagd7eDVR/VX/JWKUxUSCSIjACz8wDrTzcuq3tjjJ91mcNxfAD0J0ShxCF?=
 =?us-ascii?Q?vrt7VSSi0J/4F/3ZsXFQtcpmTpZ+50rDShHhz0U8sPfyfUFH4CuINKWBDM9m?=
 =?us-ascii?Q?EBoo1ro3BS7teEN3iu1kieQwSmxGubIlDEOpk+rAGdesCcP27l4E38uczjWP?=
 =?us-ascii?Q?rbqDi6qkPhIysNO9ggc3kAeylkS25CEFS+oEtuU03LS70uC/qX3HRUfivD/d?=
 =?us-ascii?Q?At39g4uBqoOkJsjPRZ6x2FQmMUsgAzgsZhhq9bRSTJsSFuIR7PiT8JeFjf30?=
 =?us-ascii?Q?HBDQHVXtrOPt2OLmXLf0VnGp6H2xy30HIW5xg8nAoW83+uC/SU4r+yXLlLNM?=
 =?us-ascii?Q?GITYi0cu72AbmiJ3HxsmjjJSodRtDfGl6HI470WStj8NtKbta9chCILtXH3z?=
 =?us-ascii?Q?CR4sxquT6baFPGVIIw22UZ1r+QT2rNeFWyj2mIaJIji6xT5kMWD7YLpwN6a9?=
 =?us-ascii?Q?TKW63eivZXnK3bSXNCVPpwdY39Lo5eHB4IBz/w0Nb37U1AXnWshHCl32wXoY?=
 =?us-ascii?Q?9zAh1dXJ9mPeMN8ZI/U+3C6m02OOl0ERBBjsir7Wa4GWVSw+RHeh98BT+h52?=
 =?us-ascii?Q?j2kHPx8ZcGrEcai3QP7c2Zc1nQAARHBF5BqA6pQYQiY230R4t2hnW6ADqkfR?=
 =?us-ascii?Q?6MNzvfSs7zSJbdV6q826FLma0Px8MQ5JrgNSijDg5FdWnJHY3u4PPU4zqEO/?=
 =?us-ascii?Q?KOkdDpEYX02FO/goxozLRh0LW6nL0BeDwfMqt+BC2PhF0KTjs8dqMlewLudR?=
 =?us-ascii?Q?w0Ph6wkKADilOUb0ZEcMmxdS6KiQxI65zxx2jKVphpjgCxwX0rOXbTAbn3U3?=
 =?us-ascii?Q?4M4u+IK3AEpRUr/RIoDgR1O48s6KnIAakrbBGY9Zz9ZjcxDjwmYXNrSI/3EG?=
 =?us-ascii?Q?TxehdhiTXMaR5Det49ZIw1P9NpFcmVg+L2461NHHjs7l60fJLEkuFPglSP/I?=
 =?us-ascii?Q?1NTUzDLET3IaoFBZ+UdsCC3e4b/NQ+KRa1blIABNhp7fUMTk/glnd4aY1wMc?=
 =?us-ascii?Q?AvqYmj/7OBu5DFkD0s0moG+pFPZRKJTNFS04e1iQHI415j6TT/84EPJ8TvhG?=
 =?us-ascii?Q?x0WHTlkKzwVQe/3Hi7o0fmYGff2bppk5lVG8iIT+h25UHNNEYfraThKrJhyr?=
 =?us-ascii?Q?WmGWds7FDcTLTpkBQhWE07eNwddW+200BrxNeak5X/VWxAAQt7J03yRPHCej?=
 =?us-ascii?Q?QhmTHnk0rpujluuHI22QPeejT6mRe0SaIYO5zG5hms+3cGnr+J1oKPScqRXR?=
 =?us-ascii?Q?WYzIjohNV7ZsHJDWTlNe3tMFAGVyccb7DFcy1VHkebS3A6Q55wGwIGpkbGMm?=
 =?us-ascii?Q?3tWpOE8HYQPRKLQ5FvqvpwixIy8ljt3/IC3eYWqAUBM2alPnoE6v8QtmUBa2?=
 =?us-ascii?Q?DJ11DQSOAxakDoR73lprOgDIZqOcC2538mOsjQupsF9ksoE2rvQPBVwVFklx?=
 =?us-ascii?Q?wSpcdx78D9PcVPszpiXRimvzb53DPou6R88wHG5ib3OtyMCPBWgqmXjs66Tt?=
 =?us-ascii?Q?Js1ryxvBQTWbnY+7qn7jijk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 418a8785-afd2-4b7a-2d28-08d9988cd1f5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 14:28:03.6994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cImdvj17hH/lXwgL9HEs2xtJCenYc2oAtDpIMPgSnzuYiJ7LwNrUyIUZfILyO3osxPEM7HLrWXN2QXlDECqRHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6016
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series refactors the br_fdb.c, br_switchdev.c and switchdev.c files
to offer the same level of functionality with a bit less code, and to
clarify the purpose of some functions.

No functional change intended.

Vladimir Oltean (8):
  net: bridge: remove fdb_notify forward declaration
  net: bridge: remove fdb_insert forward declaration
  net: bridge: rename fdb_insert to fdb_add_local
  net: bridge: rename br_fdb_insert to br_fdb_add_local
  net: bridge: reduce indentation level in fdb_create
  net: bridge: move br_fdb_replay inside br_switchdev.c
  net: bridge: create a common function for populating switchdev FDB
    entries
  net: switchdev: merge switchdev_handle_fdb_{add,del}_to_device

 include/net/switchdev.h   |  48 +----
 net/bridge/br_fdb.c       | 433 +++++++++++++++++---------------------
 net/bridge/br_if.c        |   2 +-
 net/bridge/br_private.h   |   6 +-
 net/bridge/br_switchdev.c |  79 ++++++-
 net/bridge/br_vlan.c      |   5 +-
 net/dsa/slave.c           |  41 +---
 net/switchdev/switchdev.c | 156 +++-----------
 8 files changed, 305 insertions(+), 465 deletions(-)

-- 
2.25.1

