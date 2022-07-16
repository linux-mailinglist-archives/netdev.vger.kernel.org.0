Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE875770E4
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbiGPSyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbiGPSyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:54:03 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2081.outbound.protection.outlook.com [40.107.20.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5863712D3A
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 11:54:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ii9B+wGMvxxaPI5cuYyYaISkg83gCqJCq746dVF3gSJeXOdbbEilvMy/3CFnrp9JbhXwiAGu+MEEvQpYnj8040hqLDakUQPuhT6gV3+qzhiE5Fih9KgWBBqe343mLc881W/juC3aDzmRc7I7vtVxfFy2QSDFbIDpvpFuv1dWV1XPiTu0CBhx9YR5xqHlqk5APFakyWb2qolp+kuXCfLZjKncq4YW+jA428y/alpDP8V0g5+sufkzhzBdE6rsmEWTYUUpjYeedE3ZpWjIFVagvqv3h8VMRxTUuMkUSqcvtYfEGE1bAdtKmtg5Z66nooeyoKGmPY10gH315zWvFfaeIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3O8B3vSE7PSEcN2+USrPPpwYEncHvxEOuGSDkzOUTLs=;
 b=Etlr6m+TxEL77a8WH6cd8zTVihgmR8nO6X4Koq9om7LDDDwPvY8+gOE6lFdavqmz8D419GqZuv4LVxqf4TRdDl1n9vlDggwSe+/kwrn/nT3AweRfLza9udZa4gafo2LpWkkZDTlEJkyDHVL+FWCnMSxwzaf9NyBGNNDY0ZjCFHECgfiRCdw3UFPtRJ3zNtpbdKl8ihEdEdwyNyNOnjqd7pJcPRnTHoNvR08w1NBZj8Lvh+6lDzYID7fztQK4RSHUzMiEW7GfCvQzVq4EuJuuCh8AnFt6G2I2eQPwWdh4yf52y1dgQUPeiXLcQnSCwIxWJKMSJZ2ZK2EYS84Al8l/Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3O8B3vSE7PSEcN2+USrPPpwYEncHvxEOuGSDkzOUTLs=;
 b=g18lsDnC97CJj2JRUrHJ+KPybioK8/OY+V/ZcEOBzcmVYwek5k5dQk2sjQ3nTUPd2PPBWwBI1WawnA5Ez6T/1Tybc99vNsqoLwzZJsVlAXfTh272mh4BozC2Ek4SA3vwdyIlwEy03Nq5FgEKCwvvpNysa2yHViuZlWayiMvMTQ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB5261.eurprd04.prod.outlook.com (2603:10a6:803:5a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 18:53:58 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd%6]) with mapi id 15.20.5438.020; Sat, 16 Jul 2022
 18:53:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net 01/15] docs: net: dsa: update probing documentation
Date:   Sat, 16 Jul 2022 21:53:30 +0300
Message-Id: <20220716185344.1212091-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0101.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::42) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fce0c60-db9c-43a2-7136-08da675c897d
X-MS-TrafficTypeDiagnostic: VI1PR04MB5261:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y274sczNkCXA9Vt1ulAsJJa7I8O55FDdYKZIGWRrmbJCR4Yv2qnsUq/594rlh7wVKzwmymWVZjg0HZmE4hDC+RoKJLkgbzkBly8Gr4ap0S+/ERf3sxXozr6oBGsG4DcUUUXebQxp0w5lUXH6brChkosqrb59flsrzoq5cq6X/jCORSBdbKo34T3ISPeWxlu3R5DgRaA9IlwzLz9IPr4dDvuB/OQedgu4mk6Z0KM+NsZNySLhm/90zCxoVj68RRQF4M/4rG6EPmH6x3ZIk4RnNx2qbYTpaAJvgpZ6LIblkiRmJbEqRAZ13cEoXvamu7BTcL4AQsIcjyjT7gWdHe27RsSNH2z40JQcKJmzuEYyPvdGhyfwkdt4n26kIYhy0+MmxWWUId7DbE4Ph+XTL8+U/53JMPpLXlItPsFVjhfxCbjMwwxu1mTRXnYzZL2wnXPQttfm4QndqgU9fiYaPeGo8d4m9/nNWqom49qPWYLoaU1KKUGCmn/RpBHKmqSJ0kAmIjKFjSElb7afOpGkXB99Wyo7VvRIgUdFT0zQWHwZT5JU2sCLCnxuj9/+EplmnD0rIaDlr0UMA1epbRiSrXSClVQgT39/xCpeVBjsbJE3O9uF9+VirDLJrtVs72Nq9r/+EazbyTSN9kB2Wn4hXXor2lTNa5X8ILLJLydYcbDG9xSsl/fq1qi/Qnf9OT9ulwC2Q/ky0Ynm8zzGMuYrUJvSrt9KTekE0OF6hy9xjMLOz9QjXVUuYZAoMWR4IWllNsKrAFQLyobok83DVNY5uFSDiBgVec1B+aFSycmgs7IbQv0kOlCSsAEgeEqNllo22ERL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(83380400001)(2616005)(6506007)(52116002)(6512007)(26005)(86362001)(1076003)(38350700002)(38100700002)(186003)(15650500001)(44832011)(2906002)(8936002)(36756003)(5660300002)(6666004)(6916009)(54906003)(4326008)(8676002)(41300700001)(6486002)(478600001)(66476007)(66946007)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AslTOdtVAMzr48hJ+eIC08NAMvLSVaxflQgqNsbe6hI5S83qGMh7sC94Xr6P?=
 =?us-ascii?Q?fqvSMmVPC/vgbpChU3YN/FUZTKH+a/0rB3ZgVgdD6DWT4PxklDAFkO1KwBuQ?=
 =?us-ascii?Q?dPBTnMtN4NbI0rwO4gCupuaAAAfIsjRDFQm54iO5OKzZAVvCCvNKwlgOViPv?=
 =?us-ascii?Q?bv1BbKwEMidIeeat4At/6OCgnEIqWep18bqLlszUwxy4PpSTOv1/kAXjXvFI?=
 =?us-ascii?Q?a/vg6dayPZXpB3ddskQ9Ey0WX0J4J99YlYcoTIIwqmi6vL2x/VDjN9hIxqkO?=
 =?us-ascii?Q?C3LuZf1n73Nc93rAbNOYxsDEplNtMz2yTpeGEoy5Bs4wWNIy5YegI5JfPz4h?=
 =?us-ascii?Q?vKWxp0y5cRoMOqT6Sc0PAk2RJ4L+cMYRhW98Hx0frDxLGpuxuLxHFWXMFKVY?=
 =?us-ascii?Q?ngYh3Pm+w0Ql+6wBsjTsyxZ9Uk2hLe824K3OlncwLihRsSG1zhqhI8APOy5e?=
 =?us-ascii?Q?K3i/eUiYC0Iu7HKRU0wJ9w/RZGzLuo//BYfV7QbvhVssy3IvDvbp36of44g7?=
 =?us-ascii?Q?vnxs31zuBm5rWOAY7MUUhilv/URP4ZInKdXH/ai8SynT1UYDMoI0Z3cf5Xuz?=
 =?us-ascii?Q?hrUzHUJ73LuXSpo+Ju8gLpOeyLaC6uXsDdDJPE1luAia2rc9ovQBFmAub9S4?=
 =?us-ascii?Q?78sBhqKxqGwmvW+lKdSc1ai8dF9UFL7Xo2/NC8YFliga4wZO4AQdrp1IXH/l?=
 =?us-ascii?Q?tkCD2u8yfQIinqP7AWAL1di/kpriso/jTi2o23xG3GKjwglI42gk6Ak1B9p2?=
 =?us-ascii?Q?XoZWECNH6HZjsefbdvJwRfWtiInx942som44PytTo31mWu255oCXdPZp9351?=
 =?us-ascii?Q?eInf2YoeV5F0NAGkZ8ShBsCAJGpRW8+Zf5pxvfI2Vo4umjqrE7kRGijy7Db0?=
 =?us-ascii?Q?Q6iGCyMaP9BuPEgfJ+xSnQZJNdeO84wCo6jG3IiOTNyx5wd00nqbjOrUI9Xv?=
 =?us-ascii?Q?QSYVHJI3G9+Xsj9xXOqu0wU7uXrQPUorFU7vCDgMAJvCXO0njmD6oF4j2Xgz?=
 =?us-ascii?Q?vzJRwIGcFCIrIoGjmvYrxgTy5EiMv0S25NdcSMcgcKwlE0dwetB54Le2+Sok?=
 =?us-ascii?Q?cJEd2yZYnMfsF9koFO0TNCO7iH6y5bplBSL2aWEB44akhqLl33kkSZEQg1uK?=
 =?us-ascii?Q?vv88bWtE5jT2HGQroAeOWqy1Oy6zeNesAwW/6O/bZG5ockEG+pAplb1WQHko?=
 =?us-ascii?Q?mlbysvlKh5tX20YDV543bKAm3Ko9hqUm8EyUGtIrLt+llTi3em31N9f/6yWy?=
 =?us-ascii?Q?3MzNjZSg74HGJglxe2J33fECFRXlCibbVafbkUOz2YRVTHe9iZExsZZd3e7H?=
 =?us-ascii?Q?EgQxucb+v7IsEhY5ydpSSQUOOZpNadj2MVoR/UsuxSCnF7WqG1REJ5kFXW+4?=
 =?us-ascii?Q?Ce3ZbSQJz0CuTGgXGOWgR7agQrBEKocqsWcg4TFH0Jrga+1cQy55xciatiS2?=
 =?us-ascii?Q?ZqTplO6PaVY0qseArRiH2aN/Af0wxC0JWuaN2HRYjNnJLgNU7Ft+60e7zV5n?=
 =?us-ascii?Q?0gV7puhMKmi4gBXLL9HxOfpF5RQ2f6Fngez3XIA5LuetJXcc2As1zYv75Tbi?=
 =?us-ascii?Q?Ub7pgKdzaiGfTCSLt5jWD7rtpgP0bcZN37QnkoMTAA/JdFISiDow61bTyl4w?=
 =?us-ascii?Q?uA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fce0c60-db9c-43a2-7136-08da675c897d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 18:53:57.2072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FSqeJogh1YLrVxgXakVq6QkAgPx+YrIYkCxrlnxVtdmhWAq4hck+A/48CH5gDtHdiNXIJJ50EyN9C7StqmtqJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5261
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the blamed commit we don't have register_switch_driver() and
unregister_switch_driver() anymore. Additionally, the expected
dsa_register_switch() and dsa_unregister_switch() calls aren't
documented.

Update the probing section with the details of how things are currently
done.

Fixes: 93e86b3bc842 ("net: dsa: Remove legacy probing support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 76 ++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 11 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index ed7fa76e7a40..8691a84c7e85 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -503,14 +503,74 @@ per-port PHY specific details: interface connection, MDIO bus location, etc.
 Driver development
 ==================
 
-DSA switch drivers need to implement a dsa_switch_ops structure which will
+DSA switch drivers need to implement a ``dsa_switch_ops`` structure which will
 contain the various members described below.
 
-``register_switch_driver()`` registers this dsa_switch_ops in its internal list
-of drivers to probe for. ``unregister_switch_driver()`` does the exact opposite.
+Probing, registration and device lifetime
+-----------------------------------------
 
-Unless requested differently by setting the priv_size member accordingly, DSA
-does not allocate any driver private context space.
+DSA switches are regular ``device`` structures on buses (be they platform, SPI,
+I2C, MDIO or otherwise). The DSA framework is not involved in their probing
+with the device core.
+
+Switch registration from the perspective of a driver means passing a valid
+``struct dsa_switch`` pointer to ``dsa_register_switch()``, usually from the
+switch driver's probing function. The following members must be valid in the
+provided structure:
+
+- ``ds->dev``: will be used to parse the switch's OF node or platform data.
+
+- ``ds->num_ports``: will be used to create the port list for this switch, and
+  to validate the port indices provided in the OF node.
+
+- ``ds->ops``: a pointer to the ``dsa_switch_ops`` structure holding the DSA
+  method implementations.
+
+- ``ds->priv``: backpointer to a driver-private data structure which can be
+  retrieved in all further DSA method callbacks.
+
+In addition, the following flags in the ``dsa_switch`` structure may optionally
+be configured to obtain driver-specific behavior from the DSA core. Their
+behavior when set is documented through comments in ``include/net/dsa.h``.
+
+- ``ds->vlan_filtering_is_global``
+
+- ``ds->needs_standalone_vlan_filtering``
+
+- ``ds->configure_vlan_while_not_filtering``
+
+- ``ds->untag_bridge_pvid``
+
+- ``ds->assisted_learning_on_cpu_port``
+
+- ``ds->mtu_enforcement_ingress``
+
+- ``ds->fdb_isolation``
+
+Internally, DSA keeps an array of switch trees (group of switches) global to
+the kernel, and attaches a ``dsa_switch`` structure to a tree on registration.
+The tree ID to which the switch is attached is determined by the first u32
+number of the ``dsa,member`` property of the switch's OF node (0 if missing).
+The switch ID within the tree is determined by the second u32 number of the
+same OF property (0 if missing). Registering multiple switches with the same
+switch ID and tree ID is illegal and will cause an error. Using platform data,
+a single switch and a single switch tree is permitted.
+
+In case of a tree with multiple switches, probing takes place asymmetrically.
+The first N-1 callers of ``dsa_register_switch()`` only add their ports to the
+port list of the tree (``dst->ports``), each port having a backpointer to its
+associated switch (``dp->ds``). Then, these switches exit their
+``dsa_register_switch()`` call early, because ``dsa_tree_setup_routing_table()``
+has determined that the tree is not yet complete (not all ports referenced by
+DSA links are present in the tree's port list). The tree becomes complete when
+the last switch calls ``dsa_register_switch()``, and this triggers the effective
+continuation of initialization (including the call to ``ds->ops->setup()``) for
+all switches within that tree, all as part of the calling context of the last
+switch's probe function.
+
+The opposite of registration takes place when calling ``dsa_unregister_switch()``,
+which removes a switch's ports from the port list of the tree. The entire tree
+is torn down when the first switch unregisters.
 
 Switch configuration
 --------------------
@@ -518,12 +578,6 @@ Switch configuration
 - ``tag_protocol``: this is to indicate what kind of tagging protocol is supported,
   should be a valid value from the ``dsa_tag_protocol`` enum
 
-- ``probe``: probe routine which will be invoked by the DSA platform device upon
-  registration to test for the presence/absence of a switch device. For MDIO
-  devices, it is recommended to issue a read towards internal registers using
-  the switch pseudo-PHY and return whether this is a supported device. For other
-  buses, return a non-NULL string
-
 - ``setup``: setup function for the switch, this function is responsible for setting
   up the ``dsa_switch_ops`` private structure with all it needs: register maps,
   interrupts, mutexes, locks, etc. This function is also expected to properly
-- 
2.34.1

