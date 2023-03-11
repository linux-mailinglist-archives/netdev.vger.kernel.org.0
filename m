Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40666B5938
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 08:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjCKHKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 02:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjCKHKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 02:10:42 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2119.outbound.protection.outlook.com [40.107.20.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4543E1269AA
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 23:10:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S73OgGnOdzkmY5FyxgmHYj4e8WxpSkRQSvmf27PRGGDxbhYD0VLANIS4XW40dLCcdmqCzYn+YHXmAZgFW9GU2s/BHU7FtGo9irr/1y88wNv+q7L6u8eA85T5bEhLnv6CsKN4KVsqLVjNjGzf6DNlZmNGyZNbLrOzDwjXZEVVN0ebkke2GXPladDTk/jR6qjiR8dD7uFAC9+MgYBOHs3bSTNwSk6+kQI2EVFedkEKjLJtC2G83cj31sUabBvWiRuoRcoJQcCF6t1XoI4NIh0r2CWsBs22VaxO7FwnwUktlv43LABrVraDpZEFxHT5sxsFZjsOSi0YvtiougHi/LxZyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Ehd6ZXEyHTz3N0WzKdaMBnJkoINEgYrt/yvvpp5Vfw=;
 b=YteAZ5018Qlg/gy63SY8VhmBW9uzmekQXrhkyKyfT+cJqRdbIK+q6u6wWClgBzUuzlQ0RorDhZBxRcFCzJ01cuIVGpAu9MjijHHN5dG79X36TMJaefbR/4weSuNrtzNQlOW+a1qWX2drSmx7/bIhx6345GCCaFu3NmhlylrCNCfotmSvaNZlyXDDYVrtUEb3uJp130i1BJElP+ATSriuaCeDTMo4JNuVuf/yBHvidGrz/fMOCqAi/jhi9g+vg/Wc3GkJxO5uSrvZAcjBQVPQCNhUHQX4c0BPOtapUK8N9mM+PFH0lw1kWjvmXO60cV1OFHyCLJFO3vyUITmtykSP8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ehd6ZXEyHTz3N0WzKdaMBnJkoINEgYrt/yvvpp5Vfw=;
 b=TSuJhYYQJ+obXVOx5oqCmrOI8kQwBmFVrvHiNVHt5vRiYPB3YgPaWKFdMUpLzp5z+9cg9bJM0RScXFChzc52a5gqQenvyhJFYmdHjl0vGP771bhHhZnGFcpJACCplrQUFWyUViOp53eJUFv9JLeFgho00ses8KsJ2B/qeuE19ws=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by PAXPR05MB9410.eurprd05.prod.outlook.com (2603:10a6:102:2c1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.22; Sat, 11 Mar
 2023 07:10:28 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%9]) with mapi id 15.20.6178.022; Sat, 11 Mar 2023
 07:10:28 +0000
Date:   Sat, 11 Mar 2023 08:10:24 +0100
From:   Sven Auhagen <Sven.Auhagen@voleatech.de>
To:     netdev@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, kuba@kernel.org,
        davem@davemloft.net, maxime.chevallier@bootlin.com
Subject: [PATCH 3/3] net: mvpp2: parser fix PPPoE
Message-ID: <20230311071024.irbtnpzvihm37hna@Svens-MacBookPro.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR0P281CA0051.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::12) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|PAXPR05MB9410:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d3df1d8-8ded-44bc-68d2-08db21ffb185
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IxOqE/Mhu8TINmR1QEIf9oN67PeONY5Uas0dF2clEpoww3vHbLJ4Eo6dmHqZx9qQnqN+B6l6tLZEv9/XeLUxKnyVGDwAZag3eZzKzmHX+atG9zrT+vPjvCzhbMKDJlXhYfgKJr7GckMERkk4DoH5FAhP0CzoOCvFkHVRZCDEBDTUeENt3mpijWDCukDO0Cr5MyxDwhkRXfLfV+OzmjDaiS+QEU3rkt/FmdS+IpXXE6vR2ENWArYp/k3LEBbiGdMVgKx8KCiS3x5wS4AQDvnnUuGHYKIJGAGSff9uaozB3tZt8PWrAKF5mABJ0hnS8OyPkh+0P8EFdNBnJg67E3MMCOFzWr8w9N9t/ehUj7g7CZ3QsGJXt+Zqb5KPF5d5ZAkhvH3eILUelnanRbsG/HwFbsPLiwLo7/hIW6dC6VmybbTmWFtpeb2pQxg3hOvkO4bn7o45FO0VM/bi1UxbESVYo/vIrenn+R0bHf/W/UmLRydLUiqk7dvvbglaVVg4QDCZp4Qon0McUDuo43jvbHZ6b3k2tl3a1w5QyzwqpR+57njDgRdyXYG5hvZcS1joVugAXWVQLQJ9Fz2o0+thTos6md4a3crgSQDMRot6UL2kJLo6CdkM68l8JCobj5HLpcbfwaffKgUM1v1pft/krBvN6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(39840400004)(136003)(376002)(346002)(451199018)(86362001)(38100700002)(2906002)(41300700001)(8936002)(5660300002)(6512007)(6506007)(1076003)(9686003)(186003)(26005)(83380400001)(6666004)(316002)(66946007)(66556008)(66476007)(8676002)(6916009)(6486002)(478600001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ij5KEa9CksWC7qEpryhg4ONcc8eOKrEB+KOqEq3JwFirO5oZlIFHWBndJpZW?=
 =?us-ascii?Q?VOCJCZbK9fdMibO7eOlgr7m/RLetrgltXVry6vjRypFf/uV7U1NOGP/PuNV7?=
 =?us-ascii?Q?TWktFaoXM0cXEV6jky9D06wa54LOazFss9xfSdPupa5fArQG4CvAim20MtGf?=
 =?us-ascii?Q?g3rRuHAzvLiN2iKUzF40gcIhFNS9EzJYhnhmq6Nc81HpnnQMdAWjEbFkF1x9?=
 =?us-ascii?Q?E9AfjeEgPEKToD68qRub89GC19TnpgFhKq/TbzIutGMpc1W5gV8z8Utn2dTI?=
 =?us-ascii?Q?nLGJ2XQXs2v5Xdc3L3ObuRfTJbvwUsXXBLO17BxcYg24wnFK9vjuB/xV9kaX?=
 =?us-ascii?Q?RLn/9kVYdSnzicGGkvBiBYp2o90Ms+/IglyHgxyI+QUxL2ak3LMpN0AL1Xan?=
 =?us-ascii?Q?K/BfC5SyeNOAemokCfsFx1SSZnTA5y/RVoyUTe8aZk1DfSGy3GW3LzU5H+GF?=
 =?us-ascii?Q?RKboRwaZDAwMy07dpu/In3AUYyaH3nULOWvkwrush16l97T0eoBsI8Mb9q3u?=
 =?us-ascii?Q?wAje2bB+CnmkiFaPyny+xCu0bS2rMdku4lPNGmQeCTsguIEaUSDSOMiXsPXM?=
 =?us-ascii?Q?i9dzCgnSbk7X9S/EmgouwBo5aXVtqN4+OZkqosV3hJa+4s16jZ7xDHiInHs2?=
 =?us-ascii?Q?sGxegNr3GcmoC6PK+V2kPErrs3VyeYlQEKAElNbYeD2i7cFL+C/w+r7aRHzq?=
 =?us-ascii?Q?NsxyfsfdCzoSExD77YELlpMlsBavUwxUUmKZas7wkMaUQXGzEBtzl0trADnh?=
 =?us-ascii?Q?dj1ry7AO0Q80i83ABjzQ5I31iuDsAA2r/uDw0rdpEFMikPFXXBEWPeWmDtEd?=
 =?us-ascii?Q?M7Q1Z3gtdn77ONtqNiCdUvVecLshS0Q2k3nWmWP23hkqyM0lYEbLoQAlP75J?=
 =?us-ascii?Q?+/S18MITgt5pqJYf0vg3wmzEqLjVoBuKMnBnTZ1248PIOwiFwsDTwYjTIhd2?=
 =?us-ascii?Q?oDFtLTtMEIU+u4WyqJjOK8Ibi59jWUjf1L+OKEY+u8HPj9B1ZXjvFz9uP0eJ?=
 =?us-ascii?Q?y+8kocG4QZXM5oqp483AEExRS5zWRnN0+v+mZWiItjtGCOvJ4KkBLNkT4Rx3?=
 =?us-ascii?Q?o7neQaxQiO0Mxs47Nf4awbZUnIjTZquqDfOK7KjQlWl1iGm+QniPCtQVuEgH?=
 =?us-ascii?Q?KkCMmfzgzLz5UhzQUIjBJqBUNOijj8IQ1DCyYTrNHJHDcAKchlcUflqZ13NI?=
 =?us-ascii?Q?/9Whn+xvBCEGJPXrKkLsPnW1uUp+oug3zO32Ul6yG1R/TH5DT3GKTBGimlGa?=
 =?us-ascii?Q?65kZrpe6P1uSz76xk+eBxALURWgzL09M9YkVTEhHsGb1bWb8AAsx1CoWQg4F?=
 =?us-ascii?Q?j66lK5LvTA+IyxP2vv7qkVLfHW48CMKRVJcZYhPwPE/StknvULKhJh8QxbSD?=
 =?us-ascii?Q?wb5ZJ06FhZyKzpA0GDEahi/+on/hi0zs7d7/AeDQB8b3YGEmPPgwmEdOYF6v?=
 =?us-ascii?Q?rMpBnVw1IWqXhk7QRF3klYH4MknyxbmkEc3J4/U3UONFTuAaJv+yNGbaGJz8?=
 =?us-ascii?Q?q7JeTXL2O1po/gmEltZOtgw0BFIjKZtB1UmouP2CFJAZJKuGQY7d3/YkzjqV?=
 =?us-ascii?Q?WmxuSlDgh7/plFFGpS17rs0zlrHdu7a1fhhREW4GNv8gaqCLiuUFWVO+ChJW?=
 =?us-ascii?Q?ig=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d3df1d8-8ded-44bc-68d2-08db21ffb185
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2023 07:10:28.2681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ynqTUNInasmCPHrD060T+S+xd/X2CQufdDP0nmH0Y3k1fsa2/D1fDcxCIiRbsDdINVAaqJw3HKh1ykEHKOpOOd4Qgjwsr8yQwR4hyjXiEBg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR05MB9410
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In PPPoE add all IPv4 header option length to the parser
and adjust the L3 and L4 offset accordingly.
Currently the L4 match does not work with PPPoE and
all packets are matched as L3 IP4 OPT.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index ed8be396428b..9af22f497a40 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -1607,59 +1607,45 @@ static int mvpp2_prs_vlan_init(struct platform_device *pdev, struct mvpp2 *priv)
 static int mvpp2_prs_pppoe_init(struct mvpp2 *priv)
 {
 	struct mvpp2_prs_entry pe;
-	int tid;
-
-	/* IPv4 over PPPoE with options */
-	tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
-					MVPP2_PE_LAST_FREE_TID);
-	if (tid < 0)
-		return tid;
-
-	memset(&pe, 0, sizeof(pe));
-	mvpp2_prs_tcam_lu_set(&pe, MVPP2_PRS_LU_PPPOE);
-	pe.index = tid;
-
-	mvpp2_prs_match_etype(&pe, 0, PPP_IP);
-
-	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_IP4);
-	mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_IP4_OPT,
-				 MVPP2_PRS_RI_L3_PROTO_MASK);
-	/* goto ipv4 dest-address (skip eth_type + IP-header-size - 4) */
-	mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN +
-				 sizeof(struct iphdr) - 4,
-				 MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
-	/* Set L3 offset */
-	mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L3,
-				  MVPP2_ETH_TYPE_LEN,
-				  MVPP2_PRS_SRAM_OP_SEL_UDF_ADD);
-
-	/* Update shadow table and hw entry */
-	mvpp2_prs_shadow_set(priv, pe.index, MVPP2_PRS_LU_PPPOE);
-	mvpp2_prs_hw_write(priv, &pe);
+	int tid, ihl;
 
-	/* IPv4 over PPPoE without options */
-	tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
-					MVPP2_PE_LAST_FREE_TID);
-	if (tid < 0)
-		return tid;
+	/* IPv4 over PPPoE with header length >= 5 */
+	for (ihl = MVPP2_PRS_IPV4_IHL_MIN; ihl <= MVPP2_PRS_IPV4_IHL_MAX; ihl++) {
+		tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
+						MVPP2_PE_LAST_FREE_TID);
+		if (tid < 0)
+			return tid;
 
-	pe.index = tid;
+		memset(&pe, 0, sizeof(pe));
+		mvpp2_prs_tcam_lu_set(&pe, MVPP2_PRS_LU_PPPOE);
+		pe.index = tid;
 
-	mvpp2_prs_tcam_data_byte_set(&pe, MVPP2_ETH_TYPE_LEN,
-				     MVPP2_PRS_IPV4_HEAD |
-				     MVPP2_PRS_IPV4_IHL_MIN,
-				     MVPP2_PRS_IPV4_HEAD_MASK |
-				     MVPP2_PRS_IPV4_IHL_MASK);
+		mvpp2_prs_match_etype(&pe, 0, PPP_IP);
+		mvpp2_prs_tcam_data_byte_set(&pe, MVPP2_ETH_TYPE_LEN,
+					     MVPP2_PRS_IPV4_HEAD | ihl,
+					     MVPP2_PRS_IPV4_HEAD_MASK |
+					     MVPP2_PRS_IPV4_IHL_MASK);
 
-	/* Clear ri before updating */
-	pe.sram[MVPP2_PRS_SRAM_RI_WORD] = 0x0;
-	pe.sram[MVPP2_PRS_SRAM_RI_CTRL_WORD] = 0x0;
-	mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_IP4,
-				 MVPP2_PRS_RI_L3_PROTO_MASK);
+		mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_IP4);
+		mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_IP4,
+					 MVPP2_PRS_RI_L3_PROTO_MASK);
+		/* goto ipv4 dst-address (skip eth_type + IP-header-size - 4) */
+		mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN +
+					 sizeof(struct iphdr) - 4,
+					 MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
+		/* Set L3 offset */
+		mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L3,
+					  MVPP2_ETH_TYPE_LEN,
+					  MVPP2_PRS_SRAM_OP_SEL_UDF_ADD);
+		/* Set L4 offset */
+		mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L4,
+					  MVPP2_ETH_TYPE_LEN + (ihl * 4),
+					  MVPP2_PRS_SRAM_OP_SEL_UDF_ADD);
 
-	/* Update shadow table and hw entry */
-	mvpp2_prs_shadow_set(priv, pe.index, MVPP2_PRS_LU_PPPOE);
-	mvpp2_prs_hw_write(priv, &pe);
+		/* Update shadow table and hw entry */
+		mvpp2_prs_shadow_set(priv, pe.index, MVPP2_PRS_LU_PPPOE);
+		mvpp2_prs_hw_write(priv, &pe);
+	}
 
 	/* IPv6 over PPPoE */
 	tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
-- 
2.33.1

