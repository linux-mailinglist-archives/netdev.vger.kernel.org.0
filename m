Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14BD16E600D
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbjDRLkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjDRLkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:40:12 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2052.outbound.protection.outlook.com [40.107.15.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA7C9D
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:40:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/i/yEup9wI7N5Bdio7ev/GnK0QwzpBdTU00aY2g8KNZbFo59i0Rp2G4poIbJgxqbGpubiculVDO/w5FGVBMa4NAs3zILamI+jIcf58OeNuDSA2G8FHYLoM9t+4/XNPovXIsACaFtkjExNL0NExl4ga65gj9TSNKxoPzr7JKG9NDi4XKl2moLe7m26NDO1N5N6XKxUPb8asidBeQvkD9S2tb3nmjDOREkeYzV74/qjawMPxCvd6o9CsZM68gXrCxuJeLeJH+lnLKRw4s976TW8D9jzI3jpYR66eEXCPyJBuuZyBF/GPAOtZJipMbURlUi1CyDdLckxTcLqt09e1Vgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9XFeGrQ89YMVtlvv3dTZJfT6spL7hRK0/Z640Vjz03M=;
 b=mHenODVqJN9sCfYLoqphodVZN1yCFRAS3EIqgZOfg5l/AquJ6M87D3IzOGe/oE960z9dRIokGecDnpRPSCRduo5hU8Z0lMg8fQbKVKnG4HYhi7uz/OTrZqIBiEerzj8umsUtuQnLy0nTo7CzdM3GAnnBpiYFtQSs8vSlcR+nsA4OtkCkISCwUCa48k3wjkwGKPavpLGT4lS7Yc22Gvfx3w+dXrkVBjJdV3gAp5MEJiLxV0vCNDLJHa6UdfMpjVggF5ZpRi8pp1UZ6Zh2kSjKPmIw9GIZVanuu9utUYmfwnuBJa6jBIb1Vqqb0YhNJJYkXBVhbSu16SQ2c2uXnadLDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9XFeGrQ89YMVtlvv3dTZJfT6spL7hRK0/Z640Vjz03M=;
 b=L0uARk9mlR9dzsThuf9zlp5/ZoaMt6jnnmmiL1MZLxFL9SPj0Ms+u3xk58b+YxI4dDffFebFlG9cQxI4rKohyAhanFjDSt81KWT1VIuRIMu4t1vTlkeze63jBkFRYQqtDjlvF9piIHVLeL3JCWWp5vX9aHwoec7C/p6xjOm8gME=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PA4PR04MB7824.eurprd04.prod.outlook.com (2603:10a6:102:cd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 11:40:07 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:40:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 02/10] tc/taprio: add a size table to the examples from the man page
Date:   Tue, 18 Apr 2023 14:39:45 +0300
Message-Id: <20230418113953.818831-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418113953.818831-1-vladimir.oltean@nxp.com>
References: <20230418113953.818831-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0003.eurprd05.prod.outlook.com
 (2603:10a6:800:92::13) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PA4PR04MB7824:EE_
X-MS-Office365-Filtering-Correlation-Id: eebe68ca-544e-4828-6ff8-08db4001a89a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7lESQ2YrmyY8QNPmHwiK2oPwNHaIxw/dzvA2XjDoyysGMqYZyJElPRke1I8br+nTqThR1oCpyu8pfJgoDwCHoeOx/4j5INoL3fEEaP6zopVRLMWHeGbWFdW4rf03Ef2zrjPGMTQ1AGOAUXiNqSeTJZf/6pnvX/wHr/IarUe5LTzATO+8LZpvuxJSZ4Ds8lvQsmvIu8krRK2JUKp3f3A87yHL6TDi0jhzJcSPkmwuxIjh/2AVk4Ud9G8My8R+Vro0FCEAo2qWKL8IPxesFnCxnm3WbNQBSkDKk/V1QDWenJQDZeTVr6BMn67PfUoB3LP98JARj/lhtuNxYS1ufMLmnpypew7dW39FX+/dPYnxTc47wahoa4+kObu8DDWE9VR+UqPh5E7rV+g0chBRMyqKca96Q6rv/zLLD0mSzFKVHZNB33DxwrvlKzE2pqbZHICvlnU6v9An3tHkKCbZ0MEe3/FcKFY+ifbrLrtkiKopOHrSx7S62XAemwsYJ/hNr4azZXolFhQZUZ+x/dkH8RmH5KugdJR3t+wPApJ5jKbfGr72qIIqZ91WelEn7/TLW71B0ihORWSgW6EvWTvUNzmjVMbksAIJc9+BFjthcYrbMevXM2RKL/piDpkyIWYnHzO6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199021)(6916009)(4326008)(316002)(54906003)(66946007)(66556008)(66476007)(186003)(6506007)(6512007)(1076003)(26005)(38350700002)(38100700002)(2616005)(83380400001)(5660300002)(41300700001)(8676002)(478600001)(52116002)(6486002)(6666004)(8936002)(36756003)(86362001)(2906002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/2XX3go3F73OC8Hjnw6A9fCj3ILquBFe7x9EDfC8B1cf+JrXs+a88QqCXNZK?=
 =?us-ascii?Q?NiBoe8Z9Xfqv0Di/YV9hJbC4XtXwNbBVg2y1RVWCl7Xk6ixqAkXWi5nGj74E?=
 =?us-ascii?Q?oZDVG/GrbPXTXAf8INNdCSZkHzDdwUwmuuvR18DJg9/IVDPjwK1N3ZwadPL+?=
 =?us-ascii?Q?8i3vhEsHvCV+kvbPhsbAQW9jaRvhol7W9wU/IWUY61LJsD66L4VrTkBGQeFy?=
 =?us-ascii?Q?eycX7rknXzRkyPkJsHcE6fDgzKiY8iqVDQTsZJUrUuqkYNPRb3uIbsuv/r+L?=
 =?us-ascii?Q?QH1xH0lu2CCxTu55E5kQQy1DvHFkREjWscLyr+Q8wryuXEF47/TZQW76mR2x?=
 =?us-ascii?Q?ON6RA/0DIf5sVVEOlnjtGqGDScnmndZXPmVBRz6LECzMkDF9AFc2Q8NPSyd4?=
 =?us-ascii?Q?s4PZYwGUMl0mai0oA996oZAwTxqZGNNeJgNruWog5aGUD4GkIVXM8XW93w+h?=
 =?us-ascii?Q?FljgijesC7l+cOPZ81agvzag/lIUWzVVnOHbUP2rzkhwZtAFrwShjaPx/YG9?=
 =?us-ascii?Q?TGUIDs1RAYjPXfo1bbYyYijjEb42+dfKk+fOexD3/NM000ZMFK5SmmotjTRt?=
 =?us-ascii?Q?Xkbgiswg0aQBa2j9awAFa/sxGO/ndXtDbcpiZOLifbwfcMgFIYiJmm9kC379?=
 =?us-ascii?Q?raJfUCcx3wSe/lydqeiLOXKhfqBlwcvRkHMBX2DlBlzVqvggJGhXJrbbp1wX?=
 =?us-ascii?Q?KnWJy2mTv0h5FTtPzD0A+WITTBA834b7OXT4XylhjTEp+Ut3Nir35v/zBuRr?=
 =?us-ascii?Q?Ohn9jbzHWFRO0dhLlZlu3sEtL8RPcRAk/AW328BJc//sukhKxFys+hMdUlnd?=
 =?us-ascii?Q?54bDs/fopcH/naiHmYLSeS4fO3a0WrZBosp2kHCBCI4xgUOM5fSertQAFm3S?=
 =?us-ascii?Q?T5yIYh1IGdIRH5cQiCPB1Zi4N77crA4zMVr3fuFv2UTV5Zmjc1j62oiLIOTF?=
 =?us-ascii?Q?Jy4IRWaxnhqkh3hXWmmawlt03c5wqwlFQgCC9oeK2q8R+3VD8UBstyPSN2P/?=
 =?us-ascii?Q?6yftFYDJNOLWC6CgS2pCnEOX2BheiZmgpLT0vOnYLLUe9rddTwYzld6+saNM?=
 =?us-ascii?Q?92NPLxv+DjLqoDSUTbpoZlPme5W37kP9U7WJWyUNADy91I2XpifUPjwoJFAS?=
 =?us-ascii?Q?KAY6hSx5xybPXQXCU//kKGVykA4ni/tgKys8GPjuMU7JF4xA6czuyGFpA/dt?=
 =?us-ascii?Q?BXIGFCdDM3mm2UxMG47o+QMGnpV7CUbTxZd977hQFuTQnIWJkTPtm6jEi2En?=
 =?us-ascii?Q?hMzW79WCrayu65VMSBz+dyZXudAE+FC3/bYjKEoOHWPSUPQ75QQUt2CmBPJe?=
 =?us-ascii?Q?ei390Y6qh02ROTj5NePBmpOPv0MVdgkIzm/UEsLShpPZ/2hFJiANLlLetx3p?=
 =?us-ascii?Q?Ee08RSNccwJsNAGJXoPk/2r6kbtF/zsjzXeMDbIMv0AE6O5syOD35EvSjeb0?=
 =?us-ascii?Q?qrXMv9sxLR1vI8xQ5PpR1MPg556Z9AbhOMx++5s7l/YRJsA3h0VLtaA1c5lg?=
 =?us-ascii?Q?CWPhzEvi3dWEW4WSw1MTKIIDWNd74XFaE/eanmj62ZM3CIlfUEc0JPW2SHEU?=
 =?us-ascii?Q?tDCgl6m8q8t41Fzr7Zxk+e4qqUDqgdVs8gmJE8uPKODdZdVk1KtuBp9iNCU7?=
 =?us-ascii?Q?OA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eebe68ca-544e-4828-6ff8-08db4001a89a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:40:07.2323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZND6x9Mvl3sdlHNV8B+rGFH2/l3cXbGdhM/kYjbCMYrYlJLCedue4gsr1YSJBwDmCa97JOl+gzIXjlAnBlLldQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7824
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since kernel commit a3d91b2c6f6b ("net/sched: taprio: warn about missing
size table"), the kernel emits a warning netlink extack if the user
doesn't specify a stab. We want the user be aware of the fact that the
L1 overhead is determined by taprio exactly based on the overhead of the
stab, so we want to encourage users to add a size table to the Qdisc.
Teach them how.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 man/man8/tc-taprio.8 | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/man/man8/tc-taprio.8 b/man/man8/tc-taprio.8
index 9adee7fd8dde..c3ccefea9c8a 100644
--- a/man/man8/tc-taprio.8
+++ b/man/man8/tc-taprio.8
@@ -177,7 +177,7 @@ reference CLOCK_TAI. The schedule is composed of three entries each of
 300us duration.
 
 .EX
-# tc qdisc replace dev eth0 parent root handle 100 taprio \\
+# tc qdisc replace dev eth0 parent root handle 100 stab overhead 24 taprio \\
               num_tc 3 \\
               map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \\
               queues 1@0 1@1 2@2 \\
@@ -193,7 +193,7 @@ Following is an example to enable the txtime offload mode in taprio. See
 for more information about configuring the ETF qdisc.
 
 .EX
-# tc qdisc replace dev eth0 parent root handle 100 taprio \\
+# tc qdisc replace dev eth0 parent root handle 100 stab overhead 24 taprio \\
               num_tc 3 \\
               map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \\
               queues 1@0 1@0 1@0 \\
@@ -222,10 +222,11 @@ NIC's current PTP time. In addition, the MTU for traffic class 5 is limited to
 200 octets, so that the interference this creates upon traffic class 7 during
 the time window when their gates are both open is bounded. The interference is
 determined by the transmit time of the max SDU, plus the L2 header length, plus
-the L1 overhead.
+the L1 overhead (determined from the size table specified using
+.BR tc-stab(8)).
 
 .EX
-# tc qdisc add dev eth0 parent root taprio \\
+# tc qdisc add dev eth0 parent root stab overhead 24 taprio \\
               num_tc 8 \\
               map 0 1 2 3 4 5 6 7 \\
               queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \\
@@ -237,5 +238,8 @@ the L1 overhead.
               flags 0x2
 .EE
 
+.SH SEE ALSO
+.BR tc-stab(8)
+
 .SH AUTHORS
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
-- 
2.34.1

