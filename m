Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FDC673E2C
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 17:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjASQFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 11:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbjASQEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 11:04:54 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2053.outbound.protection.outlook.com [40.107.20.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1217082999
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 08:04:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+6arlC8oGIWt0JuhV4P1gc/BW/vq/vwdc4xDaq7IxfAHh4hN01cMpKiRtLpSVteDjxgUtuzp467pBroPB7Zh83tdOX1fErDq6wvyY8VgZgu6WDfM8o9Y20g6q5odpYenZLhVOtCzLYvNnF5MxkNIP6IGLG7z0OZ4ffxWernEDFxTa2b5kVfrVArvB/rH499l0dVFQwXPhyRr5D9OyZrRnAJdNsPh7eJzfYvTaRRaON0YCGx/m/KItLUsVEXitapB/LIp2irKRjJkJ6l7J8nZl4Lzylvls7Rsd4WzFV8EkKtIqkEIiU/wdV/cVKeKsc17bdIqYl+GegH5ReuhBDM/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KZLIGKOYpEmyeF2XYDXzVs9/L7VcqGk6/INFQ6FpyMQ=;
 b=kNulV1l2jsX5x46UgJhA3YBcRBxdnwJgP/EhXF3fC6lAs+Ii6S9eScTVRa/WhYEDKThTSKXDSSbr4iJbcDxWuz/yTKYhbAi72mQh7r6w0qPVi+OWY6dS8oAuHPf7YC99633fOeBIeUd6rR9M+HKGE2SJuA4QsmNmZVVSHjp8tVID762FjjpigGriajgOm7ASGRpqn2Iuv5GAu2Nl+FtsAOxOfQUOmQFeKYS/fqMk+1FTMlFmK644/5Xj9k9+6pcDUSvi0+W5+q5Av/te9jIAP3WQdTmdEiL86k8Tqqhe8Ne7m9lGzlMDo8GSqqrgMCZ2RoPTwaLNpd7k91MJQ1gc4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZLIGKOYpEmyeF2XYDXzVs9/L7VcqGk6/INFQ6FpyMQ=;
 b=Zp8n4NtSmJivmTqPjULDE/IXJyJp7fmmOxARvO8NNAAYXysHPnQQ5NHCiV4fQC8Zg5DsJ7xogjLbYvCddgJzUsoc15AL3Wi7rvcYfFYTo4uSB9BQuwSyUucbIVsNIW5byEkHBSh+DqdisXM4c9Kj7JbpdzcO9g2qMCzSClE3UKk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB8036.eurprd04.prod.outlook.com (2603:10a6:20b:242::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 16:04:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 16:04:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH net-next 6/6] net: enetc: stop auto-configuring the port pMAC
Date:   Thu, 19 Jan 2023 18:04:31 +0200
Message-Id: <20230119160431.295833-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230119160431.295833-1-vladimir.oltean@nxp.com>
References: <20230119160431.295833-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0130.eurprd04.prod.outlook.com
 (2603:10a6:208:55::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB8036:EE_
X-MS-Office365-Filtering-Correlation-Id: d5d3c90c-64bb-44d2-f79e-08dafa36e39f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BA9252Tplkovk6ZU8gHQnA2OXuZivpaP2iYKTQUYxKj2LTS25dZAAsJzWOJiRisB4tGnIWPgjw0MSV0RVQ7PaBQVvTTgDx9X2vYD8XzzR/OJcXDKgECvVs5IWFL3MbuEMsELPPSGIcVTG9aK0ZTOSP3iCosODR7cSDBYiJxv9xZpp2Ko6aFvR+wJU+LA2pDXXC++OWHChXj7xKWjIiX8WRg0m1OQN4N8gEbbz3Cgr4bQEkCscwoOtshEkqlbANAf8EkEzSjknL8saHuNAXscYbbHxsmuqlPA04nR+teIdsmkgHLpmQkks5YiDRAoCoeuN6xua7QKr63jlHlcxQebb2urYx6OAX26BJj+dTVEaxVVBo7ApxHoZyibYUsW+MdjVs/uPmXpUdXuvbd5gIvEnFABxjhCYTw1bi1+sburvLPkPSH9V9B3iDPmpZ4npNsva9hUISd1U62pvJnOnPzPSnXh7ObwnrBF9f/tzh8ZyQzCjEYP0QjO/qOLVKG/yZuSpMR4WFyfXOfb1GXiM5OF/tuh551MIg03aZY2woYC8gdZPXv7ENHkg/YyHWk0YIiXuwvMpbQVDPV+YQYBZcUri0D3M77rHrDtHdwtkEL5rF17wkthpEPdyyRCfnLYNT5c0IjV4i+uZ2EZ8Zh4gcXxlZfEBXeaCuxN+vosO4uiGpscUO6YvprlTqWoanIlOmx5nlXgom6Z+tXgLTaYdTVAyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199015)(2906002)(41300700001)(83380400001)(6916009)(8676002)(66946007)(66476007)(66556008)(4326008)(36756003)(44832011)(2616005)(8936002)(316002)(5660300002)(54906003)(1076003)(6666004)(38100700002)(186003)(26005)(38350700002)(6506007)(52116002)(86362001)(478600001)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4ehBpeJT3HAUMmjZA9El1UFd4r8uhcMQDnRl6sKuRLAVY/ovXVFdo2mspWe0?=
 =?us-ascii?Q?41RqfJvAuAbqtG766VgNzy8pbT1aofWbRxKq+9d6D7RPO60hfANC4y1RkjGh?=
 =?us-ascii?Q?jNO4Vvva0zivCBrP6KgBxCFsrKWN3mi8LM7ih1sXFHxqLYdnGqTTT+yn4Obm?=
 =?us-ascii?Q?zYNdo67dQy4Eg2n3xd5SGSwc1cfGhWfsJwch78G3ccm3sXlEm9cm6ASdn5Mx?=
 =?us-ascii?Q?wv5Ebu7QAvx1LTgkuD8LypGqnYo2RYpSSxioFfAA2AQNIMZTmsYsGoQRct/3?=
 =?us-ascii?Q?Mu8+5xtfKrpF5tLxdCI3uf2Y7xzeHzbNtYW8cppEPGkRH1ZeYb53a3364tO0?=
 =?us-ascii?Q?agnuXZqg2znRxauE/qEKsXZGMHIpvaAJf0OVXaWZruuOlVAvsl3/ywdABbVQ?=
 =?us-ascii?Q?B2qTGHVNmCPl51HsFpi8S1GPhP57FsggPlPpv6tsKB224pULPmwERqAsN7hD?=
 =?us-ascii?Q?GvCsVlKgkCWCW4yFN250T6KfVk30Fxn869L2IssJOI9u56XSF2BgvjU9Si3Z?=
 =?us-ascii?Q?XKTL3mTATB7JXjdM4ynXPndoGG5BnLg/vBNK3aFnu4taBx01gkaz9QJAVAlo?=
 =?us-ascii?Q?4Vjz1pgWkJL0OpUqpRbMwEmvGKCgDPAwUmwkylCFRkXcZ/9i6JhGw1yvDORq?=
 =?us-ascii?Q?KOnqvuW0oAPPlHDdX/wWkkpAPeha/7SnyyhpRB3V++hLbaSr5FWHmNEb4EYG?=
 =?us-ascii?Q?Qp+Gk8heHzNx8uLdBbV1vdpi8+JUV0aCM0OgxGrU7aQLzi+PBngTMfhkMBzJ?=
 =?us-ascii?Q?kzd77CJMFcm/NI4UgA/MYuZXGdEw2dmUzvXpBdZC2iEIvRMZ3ijbSsBh9NM1?=
 =?us-ascii?Q?rzApqFkZKvr/RyJ0iCJDtTRck8JXq2SRDn6G9NB7dOATLXC+wn11CJ7xcs6J?=
 =?us-ascii?Q?AVV+hnWLUltp2hxVPl8ppvrDvI6kBNZrLLtB6N/tdbwUhQTn/ElJ4UY1NzsM?=
 =?us-ascii?Q?XtHDFBLFBLCXdwu4ltv1vknsO0LhOFdDIXH+6TVHAA8fyxCki3RZkQfouu55?=
 =?us-ascii?Q?C6puqRSko6SWXARz8VlwWHJw91YJRZp+C8koxPNJ9wpG+zADaZpnAFnScT3d?=
 =?us-ascii?Q?Y/K3W3YaToS4WiwaJ1R76P2o9GHcxmTA2attinHjga7wH1q5pySoOU6dlkVk?=
 =?us-ascii?Q?ckv2XfPs/2P6tfr/d7clxqsWXge+NwgMbu08cNr2jVGlce9BSqEPCMlrlQui?=
 =?us-ascii?Q?bQw/dU5mOHMelVJlqg+wzmb9Dvn3J+f+fM7MsYporuwo7RWA1mId7Z5AJZkY?=
 =?us-ascii?Q?BK278uSgqSb11mURsA2h75CDLwhdIWneoOF0aFn0LEFtoBn9x8TxxCcVIPua?=
 =?us-ascii?Q?UMETxJ4TqNv7670Sa0fxs1erxcQUW8DC6T9/52wOG8wCYzB8RkYMLRGC3nOS?=
 =?us-ascii?Q?Cdojkn7l7atr9U74Ud0Ind6i1uYL69WNHd3eb+EMkRltiJNeH9PTa1uuLlRs?=
 =?us-ascii?Q?6eae7Zv0PlmfwvtjPwRyuQl517FvPSPL5x+1BJTonYq/eLLRcJAiDSjxK021?=
 =?us-ascii?Q?ft4SKRnaaxAEwz0TflFDLqanRXAHHwuJcuei2xWUN3ENyBGl5Jg7No5YIAbn?=
 =?us-ascii?Q?qGkJBw1KmHfF5d+sxNmg5l1p96lmI21A4fONLUTYfY3ogKmaaRb+F852/VtC?=
 =?us-ascii?Q?NQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d3c90c-64bb-44d2-f79e-08dafa36e39f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 16:04:48.3092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: emFW+udifje+VIMyTDx1idZEBXXQ0FY10di5QNKIQzNCPOdSWzQXnpuHHUugeX0Uf+7wZ/FxR/amnp2jtZeyZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB8036
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pMAC (ENETC_PFPMR_PMACE) is probably unconditionally enabled in the
enetc driver to allow RX of preemptible packets and not see them as
error frames. I don't know why TX preemption (ENETC_MMCSR_ME) is enabled
though. With no way to say which traffic classes are preemptible (all
are express by default), no preemptible frames would be transmitted
anyway.

Lastly, it may have been believed that the register write lock-step mode
(now deleted) needed the pMAC to be enabled at all times. I don't know
if that's true. However, I've checked that driver writes to PM1
registers do propagate through to the ENETC IP even when the pMAC is
disabled.

With such incomplete support for frame preemption, it's best to just
remove whatever exists right now and come with something more coherent
later.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 70d6b13b3299..7facc7d5261e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -583,24 +583,11 @@ static void enetc_mac_enable(struct enetc_si *si, bool en)
 	enetc_port_mac_wr(si, ENETC_PM0_CMD_CFG, val);
 }
 
-static void enetc_configure_port_pmac(struct enetc_hw *hw)
-{
-	u32 temp;
-
-	temp = enetc_port_rd(hw, ENETC_PFPMR);
-	enetc_port_wr(hw, ENETC_PFPMR, temp | ENETC_PFPMR_PMACE);
-
-	temp = enetc_port_rd(hw, ENETC_MMCSR);
-	enetc_port_wr(hw, ENETC_MMCSR, temp | ENETC_MMCSR_ME);
-}
-
 static void enetc_configure_port(struct enetc_pf *pf)
 {
 	u8 hash_key[ENETC_RSSHASH_KEY_SIZE];
 	struct enetc_hw *hw = &pf->si->hw;
 
-	enetc_configure_port_pmac(hw);
-
 	enetc_configure_port_mac(pf->si);
 
 	enetc_port_si_configure(pf->si);
-- 
2.34.1

