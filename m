Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE5D5770EF
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbiGPSyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbiGPSyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:54:47 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130083.outbound.protection.outlook.com [40.107.13.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D33220CB
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 11:54:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSiptt9LQdxAAZcyES3puSb5DLThA8O2S/WAlyjIuVTgox0Z3L9wUGWdlc+jULP6cfJfEAWqjygwNakxjXxSG6hni88L7MvfU/emXtFR8lXYCdLcnoMS3HgqprPgE4SXdjqX65/gTkgHdluB86C8EbYr5kY82RCm2Zm/uO8k5SAUbmnKaR2tp0q8e56XbPxYFioyGAffFXhXTh7XSoM0gkbNJ845UljxivoMBpsO/jO2NUMrA1OwZq4KiMGaiv4AAPdiOT7opuTDkQ+FA1sAAxB8SJuOHZ8BCT6XfctM5AFgIiRXpMbMkGsAum9H50K/lrgmJcsvtifqJ/eHXYbg8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mu5TevEb9y7wYsYEMc8hDee88GYTr1oNvE9vaudnZqI=;
 b=RjibXjzvJay6zl09rXhlONxpYK6NmIKnnDuVFsRyo5rU+6MDmnV0M9mTLWpt18+bUmJMiszJ5iPZiwRd6BRJW0HO+jGN6TQcAGfwqtSP6w8JEN3QUQXfJDPcRhTBPla0gO/9Txy5h2RGzbwJABeb7dOD1KwyIVCFy+8gvGD1DOE/q/xihOG6cEQUpeUnTvKzI3XQuikJzt3RQifwUK5UXSS/CVKb9t+7Bey/1DnGU5BCQDXpAozu1oZPlDxAYh5m/YBGwrJ88cfRnz3r8szV8TKU2jBt5vnnRgR9Bm+CsLgq+eYEm7ilew3w7J64PNgOE7HQqsKhzVXwBflUbeYHzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mu5TevEb9y7wYsYEMc8hDee88GYTr1oNvE9vaudnZqI=;
 b=QP15o2TWBXU7LOaMGFC0Zqt00hpcFFaEcU38deXAL1CRPeLDAjHH25RBeVimnkwFn+B3BX9xY1wk6JgtW9kf0pB+5S7Vsers/sCULkTkqBF4DBUii7Yii9cvYqU7HIRHUbm2VZNogjKRJ8WJJcMBIansjb//EOf6mGZFIwVbglA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB5311.eurprd04.prod.outlook.com (2603:10a6:803:60::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 18:54:35 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd%6]) with mapi id 15.20.5438.020; Sat, 16 Jul 2022
 18:54:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net 13/15] docs: net: dsa: re-explain what port_fdb_dump actually does
Date:   Sat, 16 Jul 2022 21:53:42 +0300
Message-Id: <20220716185344.1212091-14-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: d0ff5358-5c27-4983-0b1b-08da675c9452
X-MS-TrafficTypeDiagnostic: VI1PR04MB5311:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wI+O+KuzaK5aOA2Xy2co6yUPla2h8QX5fziA7LDNvFck4KtwxAprpTIi7jo/zRHOmu5s3niqdsvTBiMqL+KwDEMpFVIojOX0BazvM/T3Ui2UsiVD7p2yMXMORD1b/vXy87hpEDffoe836XKgL35oVg3WIPvr6v4uNO1CeWEvlQHqD72QqI3ZI4Y6JYEduGZtzj2mq6Cu0PbO5imyIpwMBYYP5KxmDTrmN4Q6E15RafnlmxgHZDNivxffyPtg1oY0UAtN2oG5xthrQEANXz5hSLrP6zzJjSHXEKUWcrZLB3n7V72Opfx8vyCwG/2wCTT1IrNPnRQo1UBC5ONz/WMK9Pj25r7tYU9bFvxPr7LBeTK541emLvlHUf6xOO1l6uUL7RMC4lMDO4feiJlAA1EBohkp7vgI3LAYmWnm88mMujHF3dzpFogzsF3BQsQeNL/DXAs+EA6Mzd49dfOoDyRX+/JOOrtYsKT8w3wYcvqsKMCmibxW0bMnwfZ3cKDQwFZJzP5JjHK5eccUHysuFCbHK4BMb0HFDCbA6ymizahBsGVYgRacF1wqyrwaFfFv7uN4n0SN0JscTfZcvYJr2AQ/CTXzLW1eTsfN3YAevidRdKm2dK6J+WdKNbKqHS0MNhjnZSG38IXhk01nbuNd1gisrvYMpaufKaRNPd/hjEqVAC6bxSWuvd9t2MbEiJFltvoInEgWvj1375Ts8D59/xx2khirn5Sy+aMzQxUsmPil69zxaHedSLimWaq3OWx1JJV7eoiAMgCoV2IhiVOex7ZNdIHSZJXeqvps/NHSf3wwfhpZ3tmklyaKtA7V2syOHySt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(26005)(6506007)(6666004)(41300700001)(6512007)(52116002)(6486002)(478600001)(5660300002)(44832011)(8936002)(86362001)(2906002)(54906003)(316002)(6916009)(36756003)(66946007)(4326008)(8676002)(83380400001)(38350700002)(66476007)(1076003)(2616005)(66556008)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KudTIfPvFX4JL0CXs+IoUuWjRcMOOQ7tuAfI05ekGAUcXSqnzCAb81IXkZ3Z?=
 =?us-ascii?Q?MlmN/6Vw4atmEJkK4cyR17jk48DIL5snjaPMdqbvjchfm2HFQo1Im1d+q8Sv?=
 =?us-ascii?Q?y6rB2nlRqcmod1W1d0LJ6IU59daya9t6U2Ap685lXczMKObq56cC3DJhM7aJ?=
 =?us-ascii?Q?9bggA4wpMXVjydUVRqHKpQ/5bFoQP1o3uJr9O5fD712tpe8xxqZaK8LZbtbL?=
 =?us-ascii?Q?mvhE5mmNwk4051+e9izwC2qAgsfz87zclT+idAu5mz6+nZpOJY2FJ2xrbJUr?=
 =?us-ascii?Q?BApxm8g5H63YTGjp1Bln6KUad6RGt/dTxf47jQxoXytg61CzgQQATRrqjore?=
 =?us-ascii?Q?/YXye7PVKmqGKrKrBNyW0GGzCOrDEUrOVQJd4EsZR2WY6V+EICFCa2id2vKw?=
 =?us-ascii?Q?XG67hbfZMUNLjSRq2CErjFYNUavrOzX5MKBHVA4aAq2oLTN4QLp+0M7eAYrZ?=
 =?us-ascii?Q?v3yfe8Od0/y9BERozx3Tw8ZQvdlRyDc4ygyPgF4k4rWsNw4TCa0qz2yo1Hnc?=
 =?us-ascii?Q?db8q+fVX2KvLI/WXA55xwv86sxR7GjSuaetCKpf/zVZc46m2SkJ/Mfkb4Fk3?=
 =?us-ascii?Q?+Lk3eqqAR1p3BgUIHd5wgHv2Esqe6xtg+RXYa0wFDbaFYmXWgHOlRLoQrR+x?=
 =?us-ascii?Q?cvIueiK8m3YM1y3jUpkq4wll55hC9QHnbidkvtgKkaLZjW9BgUnSlksb5W6N?=
 =?us-ascii?Q?csWuzkCGl5pb7fseMpt6rmc6HZh7BisUZ+X2tgPkRNj+Y4TP2xUOXSy0bVqu?=
 =?us-ascii?Q?OrIfuCSD0HXvjafQbPTjM5rI34YEqGN6nD/DpKn7zyibL2hEoiZQxDBzOczb?=
 =?us-ascii?Q?YPzgPQbsMayJ8/szJHWhRvEaYU5t3ngFLTHQYN3h1jBzuLNXtfG+6Dr+xldL?=
 =?us-ascii?Q?ee/gp7xi3IsRN6KBb3DoOblf3gqUKLEVw4jKCuET4f/LDOMEeZgBCdnMsmbb?=
 =?us-ascii?Q?Jw0g3dTvjrcaUAmmNrsnuMOsXA/iYN8fiz3bXxILAofA9oPheiAR/vULxfOF?=
 =?us-ascii?Q?P9DOsCMxVnRq1eq9/2t2mKrGsHfazARnus3NQRiMd82pih2Ej1s2v7O95AjI?=
 =?us-ascii?Q?ilrVkg/fPG5Yk72nq8uInv/eleuFce0or0J/cnLrIK5dEN5/UOHIJadNVuFR?=
 =?us-ascii?Q?DjctzkP2VNtlAehjX97U2nTLK1D9J9N1vpfRHNSWAbzHiL4IurKZ2NZS/ZCr?=
 =?us-ascii?Q?AkX5boO+r/exUxeVZ7ljMrRgivUuL7knJaABLotG6W5c7uNC5fDVxxzPpNg9?=
 =?us-ascii?Q?5yK0NwuA/vR88dCKWiH9eJJQQFsoKqJAQdiMueisiflEcSL3JQ5CeKpeki86?=
 =?us-ascii?Q?el1CisuLslD9O4AT0XC9In7TV8RZ9Gggaa/BvH3yPY92tXLJCWOFHQ/mQPxu?=
 =?us-ascii?Q?BdYjzSLRh0toqzl0ePALnUBDhrrHgTuzlgWBPlRp0dUomPbUjjUbeB28jluC?=
 =?us-ascii?Q?af1lxE0qNbAXVK1Z4vkGisf/iyKuIWZsWTjkA14OBY9LMcgqRIuv29o5HJ5Q?=
 =?us-ascii?Q?UxXgdvz9CcWz48i1soNf3ehLqt7tOdowzz4rq3u0iu76L5Cyb2mncN04RRWh?=
 =?us-ascii?Q?pF7QM0ofbsKI8hBwWHvJdzHy/Pa8TxZCSMbdI4YMVmr41oaRZVrWsYxpFbq8?=
 =?us-ascii?Q?FQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0ff5358-5c27-4983-0b1b-08da675c9452
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 18:54:16.0183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mniVilVaC31mpLHFBjoPeTFNoxp9taSrdCrnjFYZn3TjKxh8nzrA+bolBc4uC3mMQl2Fu68oJ3R073ndcrjkoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5311
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switchdev has changed radically from its initial implementation, and the
currently provided definition is incorrect and very confusing.

Rewrite it in light of what it actually does.

Fixes: 2bedde1abbef ("net: dsa: Move FDB dump implementation inside DSA")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index c8bd246d4010..330a76c2fab6 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -970,9 +970,12 @@ Bridge VLAN filtering
   the specified MAC address from the specified VLAN ID if it was mapped into
   this port forwarding database
 
-- ``port_fdb_dump``: bridge layer function invoked with a switchdev callback
-  function that the driver has to call for each MAC address known to be behind
-  the given port. A switchdev object is used to carry the VID and FDB info.
+- ``port_fdb_dump``: bridge bypass function invoked by ``ndo_fdb_dump`` on the
+  physical DSA port interfaces. Since DSA does not attempt to keep in sync its
+  hardware FDB entries with the software bridge, this method is implemented as
+  a means to view the entries visible on user ports in the hardware database.
+  The entries reported by this function have the ``self`` flag in the output of
+  the ``bridge fdb show`` command.
 
 - ``port_mdb_add``: bridge layer function invoked when the bridge wants to install
   a multicast database entry. If the operation is not supported, this function
-- 
2.34.1

