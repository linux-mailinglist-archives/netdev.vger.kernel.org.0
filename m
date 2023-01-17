Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1F4670E17
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjAQXwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjAQXvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:51:53 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2078.outbound.protection.outlook.com [40.107.14.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13FC4F36A
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 15:03:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSvJ9RK9JLvAspPb6NYSG1tKgAKDh9D3q6Q95lddurt59QjqIIL0DP0ENfeqsJ7AUDX+cLlgl3wLD1EfVHx2WcsnP4PT+yxtYNYF/g4AqiO7Ctk0GDJC57kNs/SKJ+QC13u980eyCEV6+dSdfnRPOP+umrTuSiDljFwN29GjCiZGNpNff6E5rfvSQJ0Riv8dU/wRk0n6sC5OhtOCiChHWbNbh2v19J9nPfX6Pn6avsXkd9C2ckBZ1xweowidIlvrJB2fMAGugCc3wYrrsvfOOB+cRSDv6rr5khCMBW1VDGt9GAhRXUjoVsn4hn1Yglr67qfB9J+H6tw9Dbst74+4Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+OCiyOm+YJiHy9t57cBHdczPfI35hnd/FyyuDV8crjo=;
 b=Mlyvjyb/W7tE5eyn7sF4+IwzHO/AGI+cvMUhStjQemfgb+wfQHxtdQF7Pe/G1OgeQoam1YCYloCLljo0OuXnTSAIytcWECRDiWFbJEHPWqigv9I0FmfzjBLXEoW7WpjS9I8/m9dDObqVCrThrdt3hT9whjChu0RfuVhc2TQCNF+lw9zeMptOK1QHmKU2/qiiWvfxb6yKT3VP2vdAEhcweBJlMS8bbeNmv5jbBDlhUv7UbGeKtnGUOrLXL0aG4v89v4iM5O0FxYHrdr30Sfca1cWFFksf7NrFJJqZRbJcmeDPFJaL/MeY0GbL8bTGftsLS6VM7Zzx8+WVEOHXrGMUPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+OCiyOm+YJiHy9t57cBHdczPfI35hnd/FyyuDV8crjo=;
 b=FrPVVYDkA+GAc7nDhdRzXOL+3Zn9gVkyNc8NV9kVMxihqGm7EtUDyfbzosBKVhG8XfnIBwwUoe2pQ0cbzmplse1bXcmkglG5GhBcYFD8NURhXhtNHRzSTwajmcaxiyIWJOV97KDO6IU8CCNUhxf1IifmMJmnM8Ft9h7ymHKjhCU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6808.eurprd04.prod.outlook.com (2603:10a6:20b:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 23:03:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 23:03:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 01/12] net: enetc: set next_to_clean/next_to_use just from enetc_setup_txbdr()
Date:   Wed, 18 Jan 2023 01:02:23 +0200
Message-Id: <20230117230234.2950873-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
References: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB6808:EE_
X-MS-Office365-Filtering-Correlation-Id: c2d6f95e-2b4c-4696-e75d-08daf8deff96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MVmzMohn11/uR24UyrwRw7rbzwjWjRazWHDN6j3Ce1xtjAHvZpgOevupjs8vw92jYNziAh9/1sCIWKE80Hy2xeK/mxgUaUoLWg/TNt4MeKB8scjUNh7LPwjoI/A+D+cWm3iYspdaQYqQuOCEMc9eN+KxSuYZ8/MfKFctIz9JWpQdIx/Bzv8jtZtB80VjihtR4FaRuaZc1y7cyi9PKTuRaxM/6N2bHXWWCzzyzQk/qwZ3aj19HD494EWcgPukxk3Gt9bETKXPnFvIZ1FNzv/+3gEaUlQ4MvH1p9XhRGO+4LTqJyTHKiu0StIR1/TRar7MsfehBRc7Jk4OfrJmAsTClXMOh81VPamWd8m5vLkvfmRHgf7ZhCH1VA9/Y2Efq+68eeSBns0p03UujitmtLcRwnlf91GjxYkbfNA7BLcajnFlGwPy0PJoJleVp7qe3U2/tiSyokpRxjzmziGoj6waCFwUMqx0wgztOwVMmkRF7lXIH0u/0oJXqPfzrRFB3PpCsUTY+JuG/kFZuuLWC+WJKr1MgBnPwtk+LNTQogextUYETZqq5EUmyxB8fU8PlkW6bBX8/FiPK8h0v85Zq/fLxqkGRP53hDv1ipz/Tn3t5MmrPBTLNBdWoK10b8gPSDeJbRue8lltUBrMfH6847H411kS56oKoTwDJ59I9Fo2evheuQYJ2aefdx+VCrbGAQCjhe2LY1cOmN+Es1pEG46ZeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199015)(86362001)(36756003)(38350700002)(6512007)(8936002)(44832011)(41300700001)(5660300002)(66556008)(66476007)(8676002)(66946007)(6916009)(316002)(4326008)(2906002)(2616005)(52116002)(83380400001)(38100700002)(186003)(478600001)(26005)(6666004)(6506007)(1076003)(6486002)(54906003)(66899015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1Q2d2aMBFO9Q9MI4+d00KxDnO8Oo+9Kfu/my0fTsTmv42rCy9EuHKAnT6xWa?=
 =?us-ascii?Q?PAAMn87TkUkNKN3vAztNFida/ljVCSi7r0XcDESQ+2DanhWV6vmGaqvh+tYv?=
 =?us-ascii?Q?nucRdXzUJK5MzHebNay7ZmoYLcJGhFtw+GVgHBQdR9sI1WjNQXkP+ARQGGtr?=
 =?us-ascii?Q?C6YB65mUW5+eWsstznS3BTaGTA0g6hiN4D2PwVXbCII3Lsyx/6j537CFvhTU?=
 =?us-ascii?Q?EzNr6sGyKS2W1FVMjtcmvygU2FyOBTgN0xEtd4pUfJB4woSYmGTpB36xE9A1?=
 =?us-ascii?Q?kWELgVEcQAnNYq4R5tYgBvDlJD3+p0QOgLRp26YhWsbxgUQmZm5ixqPDPjPq?=
 =?us-ascii?Q?bCfnLBLYDyXXqqDYtV1r6fKpTN1+AsHaWIn/y+SpLAPGOsQdMKId4DamfIZ+?=
 =?us-ascii?Q?3SYz/d6/AT5eprYuNFA1JtRznuGo94kOFaN3aYoFVON/NTnrb+H6uEhVrvMZ?=
 =?us-ascii?Q?48gCmq5Lt9Nsbm7RUOQMohuJhedDsuRQTuChzOlhSDXvCrUpEcCzASWAnwsZ?=
 =?us-ascii?Q?sFIU6sM7NyJVGr7OPQUtvPY61OtojcwVnpNFuZEJTnw6Oc29taDlFgaP/9Am?=
 =?us-ascii?Q?cyRhZMMkM5pJCnSLswz6U2nJhAPD5Pm4KasZq+W0LMQiqzEDEEKUxZ+JBXG1?=
 =?us-ascii?Q?8Ye1xnQ1dbRw48aglYAvArKlxI5tAbqLHwObNWcuZvltjDpnFNAQcJLk+7Wy?=
 =?us-ascii?Q?Bm+4ea7LreFz9I2VpDW5jslkDExAWb4vMGC9caUNsDyS52yR34FZUaAoNSWE?=
 =?us-ascii?Q?A9IQH6jInsHl8ut1JpS9tyGy1JqXOC3Nius7Iu85RST9hvjJnWkK8D1+Tnx/?=
 =?us-ascii?Q?mjDQqWhu8tKa7ogLE+7uOqjOxDsnR39WXJFsB+YbOIbcr9ZZPbR8ESrPfHLl?=
 =?us-ascii?Q?VOiX6QFIFF4gSuI+hvQPnnYWvkrRj0fKZHsO3MpobPSiLXJSFNhZYSS/BIr0?=
 =?us-ascii?Q?93l9aD1VDZwfCD2MqjqcvTA2yzwnurcs8+ByhUydLLP7QPR4Q9KtB1nl4+yt?=
 =?us-ascii?Q?ox8aGbYDSOxE3s7J2ivQQD0f0OAqQ0At/VaR1FIlL4gHH4bpZdKG0GFzrm3b?=
 =?us-ascii?Q?0MwhJpY5tEKrPtiba8Glh/fvfvL/Xw+OhcV/UwDOdTi6a6m/CctIrkXscAal?=
 =?us-ascii?Q?v9DnmLrclgFq4VS5Ap5+oElG9SqkkK3qUg6Jy/WDF7f+Ok5YfV+2jak7fdiB?=
 =?us-ascii?Q?+uwvEdavtuC3Yk/RsDGgk+lUj+FJo0gLL72ktGplbUsBfUsH4ZFsfMPh7189?=
 =?us-ascii?Q?O0YLMG7bK3sAaoITJjTiuWxGvEToAWqQFYtIlz9oAajqpIQWd/sJVc+KQyey?=
 =?us-ascii?Q?igmnHnnZvGnDTABw5WnzFqCVFUZo/DbHWWIdUw2A/9VTBo/ZiLJ07mlKumJx?=
 =?us-ascii?Q?hC7Sv2KeODzrNffrWIP7gau2YPdRYjtd/lTv1XOt1p1EQ7M+fza4fM0YYgIu?=
 =?us-ascii?Q?dGFd05gtsuQecIx66Oesxx5AePlV2rIHQ5Vqk4L5EIVr/A30H3xl++WaoF/6?=
 =?us-ascii?Q?WyiW2jqIvfpECQHp19vgLPNKQkWYwk2UjakgJVlQ7tJN6hqvQzy3ZIvZ46YS?=
 =?us-ascii?Q?gunbN1VeT81eSvvVWz19tYcyzBpEJtGxThATMafTHUWdTNDC7VoLZCNsL3dY?=
 =?us-ascii?Q?Zg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2d6f95e-2b4c-4696-e75d-08daf8deff96
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 23:03:09.6165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X9Uo3g7V2iegvyzGBONROS0/4CthVUZTjeETx+0EKEIkq+2i2Jciv3iKP/+HWjzPn+jUZolLI6oZIoJ8pglpDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6808
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

enetc_alloc_txbdr() deals with allocating resources necessary for a TX
ring to work (the array of software BDs and the array of TSO headers).

The next_to_clean and next_to_use pointers are overwritten with proper
values which are read from hardware here:

enetc_open
-> enetc_alloc_tx_resources
   -> enetc_alloc_txbdr
      -> set to zero
-> enetc_setup_bdrs
   -> enetc_setup_txbdr
      -> read from hardware

So their initialization with zeroes is pointless and confusing.
Delete it.

Consequently, since enetc_setup_txbdr() has no opposite cleanup
function, also delete the resetting of these indices from
enetc_free_tx_ring().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 5ad0b259e623..911686df16e4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1753,9 +1753,6 @@ static int enetc_alloc_txbdr(struct enetc_bdr *txr)
 		goto err_alloc_tso;
 	}
 
-	txr->next_to_clean = 0;
-	txr->next_to_use = 0;
-
 	return 0;
 
 err_alloc_tso:
@@ -1897,9 +1894,6 @@ static void enetc_free_tx_ring(struct enetc_bdr *tx_ring)
 
 		enetc_free_tx_frame(tx_ring, tx_swbd);
 	}
-
-	tx_ring->next_to_clean = 0;
-	tx_ring->next_to_use = 0;
 }
 
 static void enetc_free_rx_ring(struct enetc_bdr *rx_ring)
-- 
2.34.1

