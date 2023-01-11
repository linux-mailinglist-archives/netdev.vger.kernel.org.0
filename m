Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0B0665F41
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 16:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbjAKPhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 10:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbjAKPhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 10:37:02 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2075.outbound.protection.outlook.com [40.107.8.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C978E19C2C
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 07:37:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bE7EfZI88eDezY+pgGiYixozzdOZxlNnvMu05bjpXtkxQ24LO1hE/KEYAP3qSRWIhTWDIw/yjl599jlUWsNW7al8tvYja9m8nJs2KkH6xkhpydWWpEhGq/LB5KfJq1bcIRDxVWGsMZQ7scc2xb8+sYFL+GTjxW6PW1ST5jRYncfZ7wiX3smElFXYCAfBeiIXTMEC/XhFbInhHGRLzSD27ISQpHMmgVXdTxhiKGEk4KwOJMB5iYjjl17gwoAYXhu22Pvzv2fevLStIGWh1ex284nhC5msH7Duy0eBWfyE+/xXzBpS/y773MA48jYDktaTWVjsapd4wH/w0LvSVFE3AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AekLAKrl9J57NY7uc0QdErekD74BFKp7GR4CtO/oJrg=;
 b=PazNzWy12McDs4Hw/7riAAvH44NPI+MyEKCx5k9mY9XFRVAQRjHoxBdiOp+jRNkfUt0+DCQUawCUcQqggOfPh3dCr7JYBye9wuzLDd63+3Tul8JSDBNaKckKq8H3TFtE35VKTH8WNsIl2Up5GXnY2YAgZ++soYNckj14nlcUjkiFNGdpm4xuaWjtLsOruUGT+t2v4xtuMrXAxHxbR8i2Yjq0BIRR2jo7RhjqG6OqH5xAgj4UcWNXuaBiCnI5gEM+9ZGDnphl+K+jsdLCV7ULnw+mNkOrLYrSFnuMqcaD+sXgykc5x83//Pu6fvUoN9B+mjgrzwtv+mNVcnDnTOSmpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AekLAKrl9J57NY7uc0QdErekD74BFKp7GR4CtO/oJrg=;
 b=oEZJqacbbqdCmCXn3DNjMmTQ3ZQxSNgfZ2OUm/HCiSv/89F7O9KzdV/ROofTyD34Qykn4qiOTKapwVN2NmxAt5q6+8jKB91qpeZ3eHu1uDHkSbh2e0UBrLd4xJYfm2IdbXS7NdLbenvXVckJpHrtIccFa1eZEUOPvYct6CR695M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7219.eurprd04.prod.outlook.com (2603:10a6:20b:1d3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 15:36:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 15:36:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH ethtool 5/5] ethtool.8: update documentation with MAC Merge related bits
Date:   Wed, 11 Jan 2023 17:36:38 +0200
Message-Id: <20230111153638.1454687-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111153638.1454687-1-vladimir.oltean@nxp.com>
References: <20230111153638.1454687-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:78::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7219:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c7673ab-12e8-453d-2645-08daf3e9ac3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JuCbUkNZzyU3KLqapeWfwO1AqFYbLt7fVUh8Bwx71DIARWY5vAJWnJmJ+/GgsVkQHHreFol5G0eHzuwmiEUj1yuBUhqC+nXxlfK4xXd7THkwDd7mqiMh3WlUf1YjQ8lxYqvewFlWjpWAkWUP4PkF03Kr6RaaxG1eQd1P6PmvTrZZjEIUbwnTbSZy4dTu0vCp2o49p4NkXR8CJhnj3JjWiGgpXpt2+iBkewucAWunmCIep8PQq5wG6Ulbqbjt9zSTUcv4soVYJZvYrfDRUJPycN/dVC6fN/WGM8p3vHaQbdAOWIANcO2nGQYTB/n4MtkzEBqsxpFrLoYfM3eeNGH5xa374g9h8IeJmb0besMDpXzb5SJOvQuGxgYi0b//p7nhA5E309vg9ysEHdv7JqzW6WzzGoBJ73V5qGrQHyy2j1wlfWYfzO1wB2JPn7m5maJ1n1kPSCmwHgF2M8BhKwqwLdX9qLVA92VrxdOCW43dFxmMiYKOSzzEqBRtz4IgfgIe0Rv0WcWC6x/1FTgLTXSTMx07Ue5PlampOchH2mDiD5RMHkfC8OobVHKuPnQuIu8PRguMrGYKZLpTBauzg6vTSmf9YtzooXRpS5AMJd8VKfBze4q+SsG8K2w4r7N+nJU+OO6J2GSBfOxiy5r+wb/VZUlj2zKClGEtnW4ZcdAecdoKDVmMiWDZxq7O5nFNn7xW1A/3k70mPbqtJGWCm3hpKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199015)(8936002)(2906002)(5660300002)(41300700001)(44832011)(52116002)(4326008)(316002)(66556008)(8676002)(6916009)(66476007)(66946007)(15650500001)(54906003)(26005)(6512007)(1076003)(38100700002)(2616005)(86362001)(38350700002)(186003)(83380400001)(36756003)(6506007)(6666004)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?etkQI//hA35cU94+1tRgzA7737QYcXUlnG8os0kkyZMfe30mZVPOZmvAWjSV?=
 =?us-ascii?Q?uKEPtj8bPu6yHf/1M/cFHcZAjAK0F58EHmDkm4TRPn8a732lWrygMdCcahRc?=
 =?us-ascii?Q?jFvfo9dsq5cq5k+aAKQMnBRy0oQlUEZSMr07R4OAiC9mjrtBdRFDaQi83a5v?=
 =?us-ascii?Q?2Dl4UH9eQpf0sNQoHWXscrm4JOn5MRnsp4Jhx+8oNWQQvYQVjp7GAowFm0pY?=
 =?us-ascii?Q?foANcG8mgbJji/ySyDs8ulcf+3Kg1DbY7LrQDMO52J3XGyoE75JFSCR4Puxq?=
 =?us-ascii?Q?JKJl8P5ypkmKmAnrz0D8T0WJFrQZhQ6p9PiyyP2upz3jjeBCaZS+ZjoKhkma?=
 =?us-ascii?Q?mKD1dmE29UgW/IE1dwJrwgY0BCuOdUSAODZ0Q+uYmuqlb+uJEDPe7bN/4Zly?=
 =?us-ascii?Q?+p3Can5t5E2oxVmeTS4QC59XN2cRxDn6FMKxkDxx6RJ+SbQOVCdrOVsgBmZm?=
 =?us-ascii?Q?h0FYknce9INWjHVnvmYgocI9Gf9ci+wJhKv50jPSbjwujMtxM4Fe6GLsMHqn?=
 =?us-ascii?Q?VVwiW17TkaPd+s2Xlsgi8DeJ556NS9fAb1hBqEAIJ7NANxijGGPDEmsV3syN?=
 =?us-ascii?Q?qbSYJHqfe5CGVGeLfehsiSt9pEQkaVF4cIxLfwBkHIEXmAlHdi7i6vW00FSh?=
 =?us-ascii?Q?4mcN0A8vnG6SAtB3IyZv7A9dZM32XuPcx0vZtvKmfE5SMaN/sAJxWm3U+zV/?=
 =?us-ascii?Q?L8OQWP+xbdcGFOARfH9gqGpNLRPuoxKNoMyLp+7GJ8F6s5gIiglqD6eLCJT2?=
 =?us-ascii?Q?LIaRkDSPJESy/wLQvLjd+IMPGhRbQRqrHBqLXrERv3DLyFBHSxDGFODs4LCT?=
 =?us-ascii?Q?ujrfLagx5l82CEROAzsL3w4KbYARrv/zCXRz0cHl3Ar3bfFYMWOJ1nJVQ/Xw?=
 =?us-ascii?Q?wfD/WGYT7tLRjdx/LFWb0VbyQC8QwZDB80iiJex2C0uhl5a6bDzDrtuNtH/2?=
 =?us-ascii?Q?vSaBK5ezXZQBTetTIWXWEY8fppDAuVN0pE+oQzvkR68bquS/Ri5DR4nzSo+D?=
 =?us-ascii?Q?xb8FLQdmCB11Av7kzJZaef2bWml8xQIacpRPClz1BbhXaPh5C0gPfsBQy7zh?=
 =?us-ascii?Q?LFkKw5HF68spRxVmMwaABuq3xMfqJ2voNEGJy7ya/2UwPbSFOF/Q1C7+qnBe?=
 =?us-ascii?Q?7Ychiu2MvP0seHOY3DGZ/uYIX49ZmQQTzOBJcwGxyY3paeyX527lwySalKaz?=
 =?us-ascii?Q?eWynPVcFQ92psoVFL+xamrNH00CcqauT5rykhc3HJjrEKwDei2gxSCqSZwmv?=
 =?us-ascii?Q?aoTC3DIVMfFgeKsog3Gh4G9XpMyxhYnURGo/mOVR4xm/bycwB6t3VkqnTN3a?=
 =?us-ascii?Q?ZCAFtvu/uSI++jrKjqHNhv0gzi7YMRVgEmKWUxElk8TB1kbLvcqSNwhwh6lv?=
 =?us-ascii?Q?pwga3g9IMPPouoZzavtddAfvV8418QII2j659pMH2/cY1czUC/5LGn1req1R?=
 =?us-ascii?Q?7rZ61nm7DGP4dBIYr+iXGhWqiApAtm6JG2a0v4y6W76urodGbDsGJ6/w9WnM?=
 =?us-ascii?Q?EHvEETAfjz3l6fq7T3pthrEQ5FTBRawNQbgxM11Lb6VrrTclp193/ncJwj9V?=
 =?us-ascii?Q?7MPneyeiDRrDnqnD62jNGhF99jndD9gpUkr9LyMInmqTNQjqEZ//8WVNuNGK?=
 =?us-ascii?Q?gg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c7673ab-12e8-453d-2645-08daf3e9ac3a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 15:36:57.0486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +SCrXx78U3REX+jHJgcaLMTYgCmHevU19XEppHNL39mNqrWWMtyiAfuxC6gjIPTEmli5YGkTxn/vndfDTz9bkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7219
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the man page with the new --src argument for --show-pause, as
well as with the new --show-mm and --set-mm commands.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 ethtool.8.in | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index e13229bc7b99..f032d8c56088 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -490,6 +490,22 @@ ethtool \- query or control network driver and hardware settings
 .I devname
 .RB [ power\-mode\-policy
 .BR high | auto ]
+.HP
+.B ethtool \-\-show\-mm
+.I devname
+.HP
+.B ethtool \-\-set\-mm
+.I devname
+.RB [ verify\-enabled
+.BR on | off ]
+.RB [ verify\-time
+.BR N ]
+.RB [ tx\-enabled
+.BR on | off ]
+.RB [ pmac\-enabled
+.BR on | off ]
+.RB [ add\-frag\-size
+.BR N ]
 .
 .\" Adjust lines (i.e. full justification) and hyphenate.
 .ad
@@ -533,6 +549,15 @@ displaying relevant device statistics for selected get commands.
 .TP
 .B \-a \-\-show\-pause
 Queries the specified Ethernet device for pause parameter information.
+.RS 4
+.TP
+.A3 \fB\-\-src \fBaggregate\fP \fBemac\fP \fBpmac\fP
+If the MAC Merge layer is supported, request a particular source of device
+statistics (eMAC or pMAC, or their aggregate). Only valid if ethtool was
+invoked with the
+.B \-I \-\-include\-statistics
+argument.
+.RE
 .TP
 .B \-A \-\-pause
 Changes the pause parameters of the specified Ethernet device.
@@ -698,6 +723,10 @@ naming of NIC- and driver-specific statistics across vendors.
 .TP
 .B \fB\-\-groups [\fBeth\-phy\fP] [\fBeth\-mac\fP] [\fBeth\-ctrl\fP] [\fBrmon\fP]
 Request groups of standard device statistics.
+.TP
+.A3 \fB\-\-src \fBaggregate\fP \fBemac\fP \fBpmac\fP
+If the MAC Merge layer is supported, request a particular source of device
+statistics (eMAC or pMAC, or their aggregate).
 .RE
 .TP
 .B \-\-phy\-statistics
@@ -1511,6 +1540,34 @@ administratively up and to low power mode when the last port using it is put
 administratively down. The power mode policy can be set before a module is
 plugged-in.
 .RE
+.TP
+.B \-\-show\-mm
+Show the MAC Merge layer state. The ethtool argument
+.B \-I \-\-include\-statistics
+can be used with this command, and MAC Merge layer statistics counters will
+also be retrieved.
+.RE
+.TP
+.B \-\-set\-mm
+Set the MAC Merge layer parameters.
+.RS 4
+.TP
+.A2 verify-enabled \ on off
+Enable or disable the verification state machine.
+.TP
+.B verify-time \ N
+Set the interval in ms between verification attempts.
+.TP
+.A2 tx-enabled \ on off
+Administatively enable transmission for the pMAC.
+.TP
+.A2 pmac-enabled \ on off
+Enable reception for the pMAC.
+.TP
+.B add-frag-size \ N
+Set the minimum size of transmitted non-final fragments which can be received
+by the link partner.
+.RE
 .SH BUGS
 Not supported (in part or whole) on all network drivers.
 .SH AUTHOR
-- 
2.34.1

