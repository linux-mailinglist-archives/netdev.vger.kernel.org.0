Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C53159888B
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344639AbiHRQSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344555AbiHRQRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:17:32 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70070.outbound.protection.outlook.com [40.107.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2A8BD0B7;
        Thu, 18 Aug 2022 09:17:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDooIjSj52pOUK64EMMr/xmQjjsFCSdIqrFN/HRZtINF0WOVVhpG9VRFV26RoZJz7m76/mAPsC1eJ1dCdcYAwYX9fnsH+w5Cob2u4OoT+nzClWUaMfNKzk7tslgpgAtUn8/urnEdeeO0zc+cUTDKfVnlane3F+esSm4gAoKyJ3VjsKaKCfM3fGVps17OAIcEjCiREdA3avHYuvz3qSreZ++NXxfP+daywlRgX/P31FzHYQ/oRCfruakEUgX29j5/KXvARevvZNL2ElkXDTkFeUYMHJKAMdC2tVoYZoTJkTyy3IfArXceWdmf7wqpnMY2SqHnx9i+gHqrg6yp4n4FGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nzEMv80+yImB4Wmb71Po/tzw2y5X2yRQVMwQIIkbHMU=;
 b=VL6Be2cM8StG83NgWH/KQKgIJQm2BTcMDv+yuzaT3oWIA2Iqhp4Db/9+izReburxXVXCI6dtvf0X7D8YdFV6T/22SpIGNxiaQoQO3ynqoiDJSOi+6BqmSLT8ruSofN7NT67Y51fAxH5GKrKRZV/oW2LsfgWSZmpMcXFgubapX5nhlEvQcOp//au1082GsQwdC5NE/GtXBJ8U5qFoAIaVuYddsGQuGIx+mAjpYtCw7jbvakWIFxeydCAK6TJPJv2cm5yrWy9IK8zhySbIlLPqeWu49VBpJvLvBor1g3oTVuxYWgL6SMzrzM72kFqUNKYRceIMObgRiwiFDPEfksOTAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzEMv80+yImB4Wmb71Po/tzw2y5X2yRQVMwQIIkbHMU=;
 b=PoCcA2VMh6BDFOCZUKksaj4nlEjbov+lRkS6gT7Qs+z3i1EIthOaPurlsZBPi8qjidiwqoaswNbrZheJ5kBBGSX9O/ZwHlValqqfgdk8BU5gxpJ77+XUFAA4mRye5MDoXwQKc/kJjkiFNYV6E0UbPdYTFbnYg9hrE4y7YtboozzeXfjopFNpPdl8gJ5wVq3GpwqsvNucnKnfWw3Ct2JAbpIv8tdWb2sCho5JHBNMRKy9GSOLOHzU5YZMWOvVazT1X0xJ1C9FhWeRsbqR/5F9iFLrzRxnQtgs8tiW0HRXZ2IlCamAAE0arT3JGKam61sun+ncB5X1+VpnI1ta3Dk9Ag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB3PR0302MB3211.eurprd03.prod.outlook.com (2603:10a6:8:11::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:17:22 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:21 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RESEND PATCH net-next v4 10/25] net: fman: Export/rename some common functions
Date:   Thu, 18 Aug 2022 12:16:34 -0400
Message-Id: <20220818161649.2058728-11-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818161649.2058728-1-sean.anderson@seco.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:208:e8::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5eaffb4-951f-4c69-d441-08da81352147
X-MS-TrafficTypeDiagnostic: DB3PR0302MB3211:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OMsZd6EBaSVC5zBwVlB26SGEgGeBHfHsUHY30yNXqWq/fhbY/T/YzTqMbjpLzIL/435YCnBIDBGfni0ZEcZQ39mjLjUTLB3fRUcd0DiGQxmqnzkaYA6AKlU4ZaFOFq7VYF+2/ihJ4jK9xunfFzM5/A9othrhUITqWtaZRn/Q3JEXOxJ3+E3nXQezKy+VeRsBiAESoRblR2F6AIuQen0Lzfo6oIiD/c009JAKisEWQsua2RsejaLQsiMsQchvLGayQy3dL63PwNLN16zjTqU0tTJFI1Pz87Zv3Ea/bqm6JQ8dA2IGP0S4vqMQPhWgQOnIAZ5DDExLcJ+LyieNkQY0Aai4vq4yn/XPP9/Q0vhWZTnOEguCi/WMG6u4bYzPA6TC5aiat3GrLZTsKH3qIqTcW5dVydRADMIdOJScoe5xL+dbos7uCZOdo2HaK8k61vC3zTtjxZqb06F0MMz/nQNv4TUYxnSgjLF3dgTWpGu28RTYIPBz1Wqdw7Unu1jd2lqD8AoXOTE+sZjEnNzIk4L0z30LfSDb85tWzc3fpefiHSnJcjG/CDWu8zk9ZanWXumQ+Fei9XpgT71nryMn/i1y5XNXR6v7h2WPf/srD03/fd8flqCrY4q7h6wPHBpIuD7M+3lIZKCUA/ZfN/jDocaYYA2FC1Lw7IA+YqK9NGFaBwB2eCNowRKnnjks/LnyKMYe7Ac+O/FZAP3eMte5CGefq4jBiL3D7+/az8OjjQ+bOniAi4Jip0WWlS5k37qgUll7+2pZ7kjnMMjL8regGs4Ijg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39840400004)(136003)(366004)(376002)(2616005)(38350700002)(8936002)(38100700002)(4326008)(6512007)(26005)(6506007)(52116002)(6666004)(2906002)(8676002)(36756003)(66556008)(1076003)(66946007)(66476007)(54906003)(110136005)(44832011)(478600001)(86362001)(41300700001)(6486002)(316002)(107886003)(83380400001)(186003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8OcBlCBfRg+MkGzISe+76dCfTVBo0fNfiYrIaAMay3h2XjJu+axRNopCek5L?=
 =?us-ascii?Q?6DTm834JHdlS7p8fCrBCe/Ua7Cs5k6CGWJnmb1leWmxr2xcNu7LfDwdwtcp2?=
 =?us-ascii?Q?fWDN05hbIAzDv8EvLnqehSlODh1zIJ/gkuGRU1fZ1LgaFF8w12kyZIVLGJgb?=
 =?us-ascii?Q?8aQglBy5r/l50thhf1x4N2+gdNbpQ6G9/Ec/l9IbapG+SJFi2xPZR/BdAlNT?=
 =?us-ascii?Q?iI3+lB1HileMU3RwCk0EihXwoS+PAjlZ5a9kddXjrGn1E/+GmoKnC9jO7HUL?=
 =?us-ascii?Q?MgBxzbPVPhSlESVfv4PDCcitDkuPn0AMcLXw4lc21eOjHgsnBapLlpXBd3kZ?=
 =?us-ascii?Q?MYmEYEyVMpKGX1INECBPFxSUg4LuCs3KaxpX1dVhzQZZyIn/uwnWvm5Tq2sM?=
 =?us-ascii?Q?2ddENExmpsdnDsuyaHYzfQKJyqxrc9TJcW3//NsUpdOyif4q8AcJt12eRv77?=
 =?us-ascii?Q?IOvTraCx/0mpCdbdTkvNYx+o6/OeG0xVb/ZxGu6q2RT6CRBC3r67FDf/RXCM?=
 =?us-ascii?Q?/DUklj72zwuxN1n5h7jGhJLU4L4IyeihvAyJd6VgOIHfuZzjZFyXqFbsrqWR?=
 =?us-ascii?Q?BaIKQmHyopntFEETnTqy3iIINBByvvA7B5Zcpx4lTv8cIklqMtpHxGNB2dW0?=
 =?us-ascii?Q?9xkqYhP053NJoN4DbdKLZs3zArqd8xv4y5VMy72bBmPIdEL/ija0D/AHwr5y?=
 =?us-ascii?Q?6ttFxH16HdSrr1W+LEvrutovGhUjWcI2MGnmCXp7fT2qYFzHT0e0KNhjqIud?=
 =?us-ascii?Q?UEoIAAe8Wwlz3mggqUCqIFG4EwWXY00GzfnWLkFhuAK4ow/C6ukh6M7HVKtw?=
 =?us-ascii?Q?XCyh8o2mXXKAsTzSbr0m2KVWwWEKq6isX7hh7/0UqApfQs0k8KfHBVinElS0?=
 =?us-ascii?Q?KOLDBt/pQJrPyjSY/6tccPd/dlQINodmE9XSoP/51TQH2fWXVEWR8pmUuElu?=
 =?us-ascii?Q?XjrK1mVQYmUPdKYBCOtmE0dxEKG/Ln461JL6Ju4Tdob9XV4bz6oLhjLmedKa?=
 =?us-ascii?Q?8B0JWiKP//BhX7JFo43Mpn06SnRmusSUA5tGQzxJjsF0TgkL6wEYWeiIoW9r?=
 =?us-ascii?Q?HBOsLJqiNBDW/EXUfjFKcrlinBSX2J2oAhd6hMcmFmmWtZQeEQSuoBtwNz83?=
 =?us-ascii?Q?PegQpTyNhAEea6OO3kIgPGJci2JmK2TV4o0GhbeS7tvC+RuZx0nKcBvwjZje?=
 =?us-ascii?Q?rroM7mSm4aN0a5WlYFQ1NuU76IFaxRC9KcxGRCMNKRdApmm/l0Odue94U3SV?=
 =?us-ascii?Q?2N4RWBETrORJbRsYnck1z0johzdZpIp7rTdMy30gjBnHL7Q/H+IfWNWDmyEo?=
 =?us-ascii?Q?s3zVzBwpasvsYyh+9f9x80KXf3+lqcA0Rtjs0R0rDv2xZZPHX+Xdvj4u7ODR?=
 =?us-ascii?Q?ed9wBcksqTZPe0RwL/Qc41ApgmqdRdqVYlSVVcTIUB//Ro3NMlzLc1g0zS1w?=
 =?us-ascii?Q?aw3T/0S004R6p5Cg+SIrxWgiKtMfdcybL1FmaTeMl5Be0WUqKDduWrRhWA7P?=
 =?us-ascii?Q?f2x+yDICgeBtwzgGbyoaLgX5rtnHgDHShiRRpfZurB5WuTt3Uj6bMqXLV4xf?=
 =?us-ascii?Q?xRsgX2npvT9HsT2vmX1m/O8wy1RXJogTpm3Pt+QnJQmKL63RWhPO0jJ8od09?=
 =?us-ascii?Q?uw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5eaffb4-951f-4c69-d441-08da81352147
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:21.9045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XehLkDVpu3hekUn8bAOvPzJTcixOVAy7DKo291m28zUqxH4NESXPuk5CJwVnZfXK/qqUO9zpnrykb95T6MMzrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0302MB3211
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for moving each of the initialization functions to their
own file, export some common functions so they can be re-used. This adds
an fman prefix to set_multi to make it a bit less genericly-named.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/fman/mac.c | 12 ++++++------
 drivers/net/ethernet/freescale/fman/mac.h |  3 +++
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index af5e5d98e23e..0ac8df87308a 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -58,8 +58,8 @@ static void mac_exception(void *handle, enum fman_mac_exceptions ex)
 		__func__, ex);
 }
 
-static int set_fman_mac_params(struct mac_device *mac_dev,
-			       struct fman_mac_params *params)
+int set_fman_mac_params(struct mac_device *mac_dev,
+			struct fman_mac_params *params)
 {
 	struct mac_priv_s *priv = mac_dev->priv;
 
@@ -82,7 +82,7 @@ static int set_fman_mac_params(struct mac_device *mac_dev,
 	return 0;
 }
 
-static int set_multi(struct net_device *net_dev, struct mac_device *mac_dev)
+int fman_set_multi(struct net_device *net_dev, struct mac_device *mac_dev)
 {
 	struct mac_priv_s	*priv;
 	struct mac_address	*old_addr, *tmp;
@@ -275,7 +275,7 @@ static int tgec_initialization(struct mac_device *mac_dev,
 	mac_dev->set_exception		= tgec_set_exception;
 	mac_dev->set_allmulti		= tgec_set_allmulti;
 	mac_dev->set_tstamp		= tgec_set_tstamp;
-	mac_dev->set_multi		= set_multi;
+	mac_dev->set_multi		= fman_set_multi;
 	mac_dev->adjust_link            = adjust_link_void;
 	mac_dev->enable			= tgec_enable;
 	mac_dev->disable		= tgec_disable;
@@ -335,7 +335,7 @@ static int dtsec_initialization(struct mac_device *mac_dev,
 	mac_dev->set_exception		= dtsec_set_exception;
 	mac_dev->set_allmulti		= dtsec_set_allmulti;
 	mac_dev->set_tstamp		= dtsec_set_tstamp;
-	mac_dev->set_multi		= set_multi;
+	mac_dev->set_multi		= fman_set_multi;
 	mac_dev->adjust_link            = adjust_link_dtsec;
 	mac_dev->enable			= dtsec_enable;
 	mac_dev->disable		= dtsec_disable;
@@ -402,7 +402,7 @@ static int memac_initialization(struct mac_device *mac_dev,
 	mac_dev->set_exception		= memac_set_exception;
 	mac_dev->set_allmulti		= memac_set_allmulti;
 	mac_dev->set_tstamp		= memac_set_tstamp;
-	mac_dev->set_multi		= set_multi;
+	mac_dev->set_multi		= fman_set_multi;
 	mac_dev->adjust_link            = adjust_link_memac;
 	mac_dev->enable			= memac_enable;
 	mac_dev->disable		= memac_disable;
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index 05dbb8b5a704..da410a7d00c9 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -71,5 +71,8 @@ int fman_set_mac_active_pause(struct mac_device *mac_dev, bool rx, bool tx);
 
 void fman_get_pause_cfg(struct mac_device *mac_dev, bool *rx_pause,
 			bool *tx_pause);
+int set_fman_mac_params(struct mac_device *mac_dev,
+			struct fman_mac_params *params);
+int fman_set_multi(struct net_device *net_dev, struct mac_device *mac_dev);
 
 #endif	/* __MAC_H */
-- 
2.35.1.1320.gc452695387.dirty

