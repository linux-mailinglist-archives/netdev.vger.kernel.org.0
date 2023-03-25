Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852846C8F81
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 17:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjCYQlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 12:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbjCYQlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 12:41:14 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2114.outbound.protection.outlook.com [40.107.7.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D00EF88
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 09:41:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/A28/z3ZxRkhlyUK0i94wJgkU79A7p4Z33TFUWxj0I8o6/j4cZAsN8j1G2VThiOcCikifUmadXXqMeSkIs8nOCZqubqBJV5zNTWhtozmx1Jn87YN3CvUmowF72ooouz5Lr9oqDgtkgW5jJFmFujHrWk3FpLNprHVfVgtjuaOxmOASxBsqo4WIRs/MDYkJdOSkCoCqGYqc5FQGRpa4Js85PldFTK8qiiTGVxft4+CBD8DPdmi8jNoRlsC4voFBCKDkKBn0KrsHUEZ3MpYWoxoJNwLKgUpSiIhb0lRRW3swzQBFTTffYn2k24W5kd6AYDArcFZ3EDkiispyWuno9xrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=whvOGkgIV2Fy6P5/bGQ2x1EGCRfs9EbsIUVFihqyrqM=;
 b=e2MCIG5+TuhHSw2+olmQE8Wf2ILQ1fT5mBPYcpuDLkukhtfTlJKwVQlEYPCYhKi49iH+S8OI4QXwHxA9vIa5cyp/kjjA+q4bhguB5YFmUBkbDfjp24ZqOgjFXB0qnf4mC0TvGmmXBDquf0dtUl7vGFWVm6s9FDtBSgTvN1K1hlDJdmMwJ3AGahfI7wxipzQJ4KlG58+lVwTajZi2NkDg2e989eP0WBJIVTcr7aUUJQP/Ti0oYS5w4HIkddTlF2igzqaUmNSLqNyJPBW6thQD6amhSwnX2u4KDXpG3gwZ7KGOGCWgWxVYa7klD0orEZHetkxh1DRpa9xj7n4tAEjGCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whvOGkgIV2Fy6P5/bGQ2x1EGCRfs9EbsIUVFihqyrqM=;
 b=XgvKrfHVeoJ7Nbzs5fgvLWerJVJVuJ4odK5U0T7rTAdEglZmppBladjJ0CS2pB3XSHuHEhpVBvjNkdsPhqv17SfszCsQ6dRawME9cHnFa6uNCoO+OxIhTb8fLltR/Gwl5iQIcqotzz9q7Pg8tByEAeAblFO0Qq/l+mVvIDjVDdo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by DB9PR05MB9413.eurprd05.prod.outlook.com (2603:10a6:10:363::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Sat, 25 Mar
 2023 16:41:09 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%7]) with mapi id 15.20.6178.041; Sat, 25 Mar 2023
 16:41:09 +0000
Date:   Sat, 25 Mar 2023 17:41:05 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     netdev@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, kuba@kernel.org,
        davem@davemloft.net, maxime.chevallier@bootlin.com,
        pabeni@redhat.com
Subject: [PATCH v3 3/3] net: mvpp2: parser fix PPPoE
Message-ID: <20230325164105.uehseyxftzbdbppr@Svens-MacBookPro.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::28) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|DB9PR05MB9413:EE_
X-MS-Office365-Filtering-Correlation-Id: e7a395c0-ee0e-4110-168e-08db2d4fbc7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HHFAqgoODblI9t4K5ikEoYRA+RO4jSDiBCwQJIQs73DLYQmRdbOyRuSMmvgyo5ZaNHV9QAq43TSWMmO7GyZHGbnSrxb/LIM9NDgCCUldMKAnXlRk2eVlVW48mNfjr++YMNIloMlNsOVKLd8JZwldBMFJJneFS0B5/8p+L9xGgrV794C4ITseCkHeJGWB/YDQ3/Q8y2zn0mCcWEiv5FPMczClTXoiiOgPcSrSMLskQrkmrBQb9N37BtO4niUL6YeaUlFdHuhtTFVlUTgwKLp3oj4FzoP+W83qgUQjCkvCcnbRr3ZfKKPH2I+TLYwBPzWn+x4qWZNPYQyPtadA3bpnMNw/k9A8HmsQcJ42h7o+0g8Q6G1nF1zcpRU936ehGRxYMBGRI1iWF7gj6cIbXe2JEoUxm/K6duH7wHWBKfmFlP9O/LkWvBynG+45Lq+X9FERv48QXeMaoRf9BQmN8vEsE+fbrTOvuX3R/bDmWWL6Ao9L0BLcHQO+Acjw3BpG2gVDZqfMQ42uQ6EM4JJvb592Dj/UQJCKemroY3rC56pkpNMtbol2fWnZTbAHLSJsPC39
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(136003)(376002)(39840400004)(451199021)(6512007)(41300700001)(3716004)(83380400001)(186003)(86362001)(316002)(478600001)(66946007)(8936002)(8676002)(4326008)(6486002)(38100700002)(66476007)(6916009)(5660300002)(66556008)(1076003)(26005)(2906002)(44832011)(6666004)(6506007)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BoUBiuH+Y0bVyGvjdmiXpP2JFLj4T4PyskMNIHtU3e1dQlDFd5/5rO6GZzbw?=
 =?us-ascii?Q?xnXx02T1hgCCAdxd+900vcq5cdEI0vT16O/Hpg4OoYZBxj8mRXWcHrO46NRm?=
 =?us-ascii?Q?8nKw3UcRIXdBiD29D02X/fgIr/NwOO41T4SaLr3erWDxcaQXomWb14oBd5q9?=
 =?us-ascii?Q?Srb4ErfAqyp4OzH4XbEbso0S4SEEL+NYv4eXp9hEQ7FQT4eAgAlgqRXarmEF?=
 =?us-ascii?Q?c74RxDJ71TOpAQaEWVkEo0YIkpATvcw495Abd3iVkGox8dzYnRM6pict1yvU?=
 =?us-ascii?Q?QFlryE8BlIyS4QoLx7Z6N5jLs563v0McgDAjpvMyfqjhcl9wtUHbFJnOQNJd?=
 =?us-ascii?Q?SMfUYithppbbd6UVtFH3VJSgrTMCBGBTeQNIegN20nPkBLu81U74RWX2H55H?=
 =?us-ascii?Q?VcfRaZsE2k5hC/yAHyvWgFcK1VDf4KV8LzH13vAFLqtXndQj7Y1RDaG+VjoT?=
 =?us-ascii?Q?0u0OTKvTtYBNfJ3d25P+fFiGKTZnxTqU7igOM8Y8I6KDgdzr8YVumFTz4PVM?=
 =?us-ascii?Q?a6SZkmIODzpaBsMbkYqhEDvnhAwk+KUGG2+FI1GC0IIYr/3lYutUl7QmwOCz?=
 =?us-ascii?Q?73J2Vuu7L63ElgW5gp7GyFdy0/AlgmgYGOStR03MV8yYI0S43ufzyIe0gQqT?=
 =?us-ascii?Q?wsqVywwOGNYL2EfKQ9v92jfJ0TqkE8D8zbci1MbA/EnXBB7ez0wgxX2WSK1F?=
 =?us-ascii?Q?OAS9LUbElYdVGkCE6vBY8lZxrhjjzbBAhk03V00yoY6EQxZpTElKcG3VBZQg?=
 =?us-ascii?Q?xqlRS+ragVWtMINJ3Ql6vctz3RC8cHX1RcGT780GxOEhCAcGbD13dJMcnJJb?=
 =?us-ascii?Q?ZePhk+u/Ny+Q6kXyri9JrFzS6rpoH4yAvqwL17Gl/9ZJmde5gEBvfgqx3t5k?=
 =?us-ascii?Q?DhnqVtW4YrmZvS2dE/gmzsgarVAD5hY8k6ck/nOYLtuFC97ue94zE6ycJjdG?=
 =?us-ascii?Q?OgpI38Bz8KkL3qHkYpb4SqzbVhfcrHkUgAhK+UvVCqlxV9cJqUR0n7u/RpsF?=
 =?us-ascii?Q?xTfiL+ODRd2eJbN3CWUXtvDeZjDgJ/bWTzsoU6Er1fim5YjAh7EmpDk5jmKn?=
 =?us-ascii?Q?Jlp8Tlj4ZJY5cOZJR3z3rgZf9zDqtsEjc9qOCRhB+oplDaVGEET9AYoXoKTW?=
 =?us-ascii?Q?GzCySHBZL4gF9BYDW8uPyipezNVSZXqm51/8X/mS1+X+hbIHTPUrDYKY2dzJ?=
 =?us-ascii?Q?5RjEeUkGE3q9pzaVdZOng6w1cQJvfi+fiH8UT1zq3PdJcfwFuJAP5zUS80SK?=
 =?us-ascii?Q?DtVMtdSAI+HkNZiDSKOVcir3PHqLafPgzAbtMQoLxehrMSd9urZZJkKJXrX+?=
 =?us-ascii?Q?SBPTmI0dyLzMqhMUq6z3eCXPENtktinNpMA+wy+ZiNzdVfFa4xUOHARFf5/B?=
 =?us-ascii?Q?LSGXm8o/bAvrPkjY5IPD1tDj4RVPmQktzxzgYQ/zGQeCCtb2jwxSbmJSQOix?=
 =?us-ascii?Q?sv0taYmfRpTiAqEbopKRAlrqP5QXZJzCPsoJv29RQ54G0jrkxtD6z2wED8oS?=
 =?us-ascii?Q?+BmMmqLEU0748EnUGdJH9RhyMtSSAByhHRhNoTSrTFcbpB8wPoCXqa/K7iuj?=
 =?us-ascii?Q?NBrVaXEHdWMWoLFnRSWv0j95UItS8I+/K1wJQAtTnRtzIPKLBjzlhCM0Clxi?=
 =?us-ascii?Q?sA=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: e7a395c0-ee0e-4110-168e-08db2d4fbc7c
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 16:41:09.1910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GEW2c+hhjkhTmkQWFP2lzXVUBxMizGtYQkLXqG/z9/XuUO53zrasUcwaeEuUUed/JQob0k6JvNgzyMo3DTATzX1vsTTb86W3A0Fb7DK5U/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR05MB9413
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In PPPoE add all IPv4 header option length to the parser
and adjust the L3 and L4 offset accordingly.
Currently the L4 match does not work with PPPoE and
all packets are matched as L3 IP4 OPT.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---

Change from v2:
	* Formal fixes

Change from v1:
	* Added the fixes tag

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

