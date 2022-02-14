Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F424B558B
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 17:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356082AbiBNQEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 11:04:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345126AbiBNQEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 11:04:30 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2052.outbound.protection.outlook.com [40.107.20.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4E449F97
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 08:04:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gn2/7Z3W9Gw4vEh87mRgH3COEuf2jZEnjSEqH/i9tFvp89k5J7KSII9adQrnruU/LxHVqc2/I3KDn4zW88d86tQFXxRv1gfMNlUXrVT6uWro6WQf767aEveAOlr29Kmph06pBG4S+7AB86mkTh7/L6TRrbESB8nS4kWvwuq1J+uvkj9LeHnPvGdGmq+rxSNcTI4iTE3jIU86lU+juIjn/SRQLL1RsH/JtuOjZWuvWP9vkJtcwZaq/pz6TWXGp6niJ6UMo8/BjK3moYf549DoUkVua6i0+Q3Othi2SX3CY9oGBwWjKei2cHmU+giFZRR2UqXxNBKXSPsCBIv5JNfyuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Y/Wjlq/UwyHW2n6TXnlQqMwr4cvn3pJ3345FZqd85Y=;
 b=QXfKrPbGFgzAsLntGoy2o4zp3qqPKTE8NEv0NOLgDGMVKAxtOwIFIeN7cpQmgxlJFZjKdIHt4POB4C4M6kiT6RatHa+cKsv+JMd7NNmY/s31VWMJKbj7FiZ0CbI8ivB1gSEeo/XO0kMIj+oPpXd2MI6wI8iVf88eyvi19xOYKD9iIucd2PBqJjFWv1rOZc2UyMfpg48iDHl9uBNSDbpXYA28IhYQq5G3Q//YnWXAhYxx7cvKzIp4IYY03kW2zhiIxc26a0GRcfUEEuyVU5SMOUkueqhzaUCKSs0zhHMzdpeQ5vTRm1X2IOU3hM4PkxqiyEaQ1yZ51oDGmZpf0UP5hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Y/Wjlq/UwyHW2n6TXnlQqMwr4cvn3pJ3345FZqd85Y=;
 b=Ht9lmj0tm7T1aN5ep0A04ROb5gzSdqqhakqBCkQN53zAaoFvzbqnIvcWQ6+nHvftyzP+JSZZilrh/d9hG/ix1skbysWsexn1DrIPedBcYW5x96uWtoVdsEE102tgOJK3KXJM0437uoaJs9Td9qIlA8Fh65vY5XQ3Top280mzJpg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com (2603:10a6:803:e0::10)
 by AM7PR04MB6981.eurprd04.prod.outlook.com (2603:10a6:20b:103::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 16:04:18 +0000
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::c1c5:68b4:ab53:d366]) by VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::c1c5:68b4:ab53:d366%5]) with mapi id 15.20.4975.018; Mon, 14 Feb 2022
 16:04:18 +0000
From:   Radu Bulie <radu-andrei.bulie@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com, yangbo.lu@nxp.com,
        Radu Bulie <radu-andrei.bulie@nxp.com>
Subject: [PATCH net-next 0/2] Provide direct access to 1588 one step register
Date:   Mon, 14 Feb 2022 18:03:46 +0200
Message-Id: <20220214160348.25124-1-radu-andrei.bulie@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM3PR04CA0148.eurprd04.prod.outlook.com (2603:10a6:207::32)
 To VI1PR04MB5903.eurprd04.prod.outlook.com (2603:10a6:803:e0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5de8aeee-7b17-4a04-21f4-08d9efd3a7e4
X-MS-TrafficTypeDiagnostic: AM7PR04MB6981:EE_
X-Microsoft-Antispam-PRVS: <AM7PR04MB69810E14DF315E80606E8B93B0339@AM7PR04MB6981.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7m+xldfeqcn2B7S6CDrz+pUX3cqqM7cYPiZ3agBkh0kL/QyhVqH3OWIomwalkxvlcPnMzx2O7MIYqjdgaKNMTWwTk19/vJe5XrseFvzqVUnD3ITlsbIn4ZGuVUBfwFXaIm3V7h2srXQfNw7MbWlsi0Nv2zLmk0IIxpuhV0jz6DcEMbR7ItT8q7RMm+aR/jWpf6E0AmkhcpTqnwOQyCI6RLlRM+hOUVS48Wm9eQVALXe/olBB9TrYFtA05XmaY/tykQbCIlQnbngaM4S3SrnQjOOEulyvRsvBhQc9jCPC+cfjkYo9Qe1AjOMmWU3RxisEqfuryCEWSjlcyuare+5UEHZcGiqu69aynQtnF1LkI//MEGeHta9OzcOTA5eY5SAx2B7N0ebrgRqVWpcCRlAJY/CncVHh6UGFymJEq6DLUTwGWTZOT1Dea824f8flZ1ekDva9bWIsLWPfyGH1d0I17QhUM4TQkoKjkd1ToNLRje4VinaE8u1V+QIK613IL9jA0GNoIWh61rmKWRUOvKLbozq/lDpPjfB/8YWVrjwnoSQ0qUwqQpLt2xK3uc8jptfy5DqL9xzeSrEKhLBZV82EEMHs/hrJsFfOHDrTltyRvMp75moYY/6YzfBG0M9pdaTnWIZlKmvKgj1+K6ESyTh0ga4FBfYb1DJNQY95yaY8Z+q3CaUKDTZSgaxZtbmCjb6U1EjFJYz8rhgACk9PUHEDXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5903.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66556008)(66476007)(38100700002)(6512007)(6666004)(5660300002)(8676002)(8936002)(6506007)(52116002)(4326008)(83380400001)(38350700002)(2616005)(186003)(26005)(508600001)(86362001)(36756003)(2906002)(1076003)(316002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+Da52C4B/9+jhHfIY+Do/SjiRkJ4NPEhSP7XKNlqlV2bgAsI63SoSJ2MxvL7?=
 =?us-ascii?Q?o1EF8qwFMTKFWOFz5lixdyZ6Bh7x4OrykHp6l5NW5kQUn+Zcy8AAiJaKZQ/e?=
 =?us-ascii?Q?wxhExSIOyoNQezyXI7XlKquIKVZ2z2kq4/nhyaZ15YELiE/lv5VRCKgOnrQe?=
 =?us-ascii?Q?2ae01R2dILCSu6m3KU/uyK2+2D93WknRazgWf2Mtux3v1tyu4hkSA2hbxWLL?=
 =?us-ascii?Q?5WB1PbNLiJb3Lf1FzU0tMJHWe7W9zgi45zIi5PkDMCfUf6H1xNErKtoZSVBD?=
 =?us-ascii?Q?pjrgPbCOnFNENjACG2qDUJRAsA3IOp7ahyRfo/O50SaYbpyK2B3t2cdfYzCe?=
 =?us-ascii?Q?f1y1YFJfuqNDGsRvq42g1wNDN6U01cr3WH/O50h0/YtaBFf0ot2/0GpElJMr?=
 =?us-ascii?Q?6s+PJhWgexQ5fgSvlJuayYSO+yCBj1mlbsXgCHHbpL97HcGiJ3FmZmgff4ni?=
 =?us-ascii?Q?Yx4qFcpFf4K2Vf1aAiJvv8OWFEGsvjfisgMjZmbaqmbltwnu44lP5zaYl21U?=
 =?us-ascii?Q?RFKPaE+CJ66thrkKC5UNoRqZYpsLscEsSBd7jGvOVSNJjwspk4UIsSmJIyO4?=
 =?us-ascii?Q?rUbEXy3mem6pFJ36hmcmqtSRy3V9T+wl+p+d0zbK3/d4NXLliPgQCUYJzkIu?=
 =?us-ascii?Q?NE7YGzN0crhwHh75FowvTgqvwOxPPbmrr7mrBqoS/ypcv83gcpqUkXGqG/ZI?=
 =?us-ascii?Q?yhH6Gj6qvSIcBl8ZtwZWok/k/0tBgTtSJKPoIpRxJBu8rGRTIVsCph7Xf5Z+?=
 =?us-ascii?Q?rRK/CPsXoBg1WJhVXIxcrs5Y72/ulQKDRMeBDw2bzu+b07JhhJ4kkJz530iv?=
 =?us-ascii?Q?cMnJ8hmKPjHKNkUJYW45PkSAgRcrY7lYH29qC9urUddMQgeiHiZiIZxHlWYI?=
 =?us-ascii?Q?x3+l0lAZm6J5X0dN9CYt+zqGec0WQPtBHl73yImeVBg44fIHqnHRjJ/ZR/ru?=
 =?us-ascii?Q?Gg6beoCTw0G84+SRv2AK68jmreuiLVe0kGYR7x+go8QOIKYqMS6V9CHcXdHo?=
 =?us-ascii?Q?SStUV/ZbuHm5hgAGXUg0b4Tth7ZgO5e6JtskTVR9sCRkQbNB8rsqL3UY4PMQ?=
 =?us-ascii?Q?jOMSh6J083rJsHJ+dpemzbiAQPiF4JD9PH6TZejrnHgNktghbV/DPZAwX3ui?=
 =?us-ascii?Q?3WjkWfD3YDcpzY7GHoleKeGcH3ixAL8bmRGXedBDvzTi24tTejaBl9ExSBaX?=
 =?us-ascii?Q?7BE79vSTH0MCGqEvFbySd6yeI0gcysSA9Qw/4Z0qQr/dmtspFHyHdap81IuL?=
 =?us-ascii?Q?eIdCJzpE55ZP6JOhyGu4bQDNx5iablkm4ttGg7MscxTnoVLBtDcL//IzK07e?=
 =?us-ascii?Q?DR+qeEd2ndvXXW2HLP7teTI+M2qp3ZxilID2dYHFihpp4u6aGAZ7sxMWs3KX?=
 =?us-ascii?Q?a3YPsjmteUUGz9e89OwvC8EcRfpbp6JlmdXp0Vyyvblostg1UDVKbUOgmrrI?=
 =?us-ascii?Q?E2u2sD/i8P2Ws1MMtKKb4BzhvtNd3IyAiR4zhLQJvwzXvFca5zyrJUR049lN?=
 =?us-ascii?Q?nZbDxi93U7DMAROxuAOatFgHUf+4UJ5C9XOUYlhdA2IwQPkzCT4140/Nnka+?=
 =?us-ascii?Q?APwpk/0jAw0m4llvvAkwErGV2iNKQXUoR48pqksDBP0n2HaFo0H7y9JebMEK?=
 =?us-ascii?Q?KeRHgUOICBLLYM+jd5wJIvh5RV0yB+oXdnAwuLee6uJr0Rr8hX6BPChqqtfO?=
 =?us-ascii?Q?oYkqbw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5de8aeee-7b17-4a04-21f4-08d9efd3a7e4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5903.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 16:04:18.5707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QfT4bX+G2WgUYGt+Ygk30zUE++pz1hy7PsynV8l2sS3FjPcEaAd8QgFoSlcdp8JPM2fFMJywu3QPTKQXdTtTQX84aefRqda6ClXPsNLsxdM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6981
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DPAA2 MAC supports 1588 one step timestamping.
If this option is enabled then for each transmitted PTP event packet,
the 1588 SINGLE_STEP register is accessed to modify the following fields:

-offset of the correction field inside the PTP packet
-UDP checksum update bit,  in case the PTP event packet has
 UDP encapsulation

These values can change any time, because there may be multiple
PTP clients connected, that receive various 1588 frame types:
- L2 only frame
- UDP / Ipv4
- UDP / Ipv6
- other

The current implementation uses dpni_set_single_step_cfg to update the
SINLGE_STEP register.
Using an MC command  on the Tx datapath for each transmitted 1588 message
introduces high delays, leading to low throughput and consequently to a
small number of supported PTP clients. Besides these, the nanosecond
correction field from the PTP packet will contain the high delay from the
driver which together with the originTimestamp will render timestamp
values that are unacceptable in a GM clock implementation.

This patch series replaces the dpni_set_single_step_cfg function call from
the Tx datapath for 1588 messages (when one step timestamping is enabled) 
with a callback that either implements direct access to the SINGLE_STEP
register, eliminating the overhead caused by the MC command that will need
to be dispatched by the MC firmware through the MC command portal
interface or falls back to the dpni_set_single_step_cfg in case the MC
version does not have support for returning the single step register
base address.

In other words all the delay introduced by dpni_set_single_step_cfg
function will be eliminated (if MC version has support for returning the
base address of the single step register), improving the egress driver
performance for PTP packets when single step timestamping is enabled.

The first patch adds a new attribute that contains the base address of
the SINGLE_STEP register. It will be used to directly update the register
on the Tx datapath.

The second patch updates the driver such that the SINGLE_STEP
register is either accessed directly if MC version >= 10.32 or is
accessed through dpni_set_single_step_cfg command when 1588 messages
are transmitted.

Radu Bulie (2):
  dpaa2-eth: Update dpni_get_single_step_cfg command
  dpaa2-eth: Provide direct access to 1588 one step register

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 96 +++++++++++++++++--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 12 ++-
 .../net/ethernet/freescale/dpaa2/dpni-cmd.h   |  6 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.c   |  2 +
 drivers/net/ethernet/freescale/dpaa2/dpni.h   |  6 ++
 5 files changed, 110 insertions(+), 12 deletions(-)

-- 
2.17.1

