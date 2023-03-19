Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49096BFF83
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 07:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjCSGBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 02:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjCSGBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 02:01:33 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2101.outbound.protection.outlook.com [40.107.13.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A67422132
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 23:01:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AtEhC22BHwm6BtBAWxsM7letnL4j3fZE18MyouVJvOYWEY23i7oUEXnqQypU5H98NG7AEBiQV7DIDq2pOdO87UnO9tFNspguDPqsnpJo42Fy5iQgabR9b5J67cbxgEC8SsuK0mv8zwsSQU6eVgI8hIrDOUbWPKf5e2Bdz3eoon0nYlhWoRqLNHJ6fP+kz2lHS3MJzgL1Qf9ui02gvYD/BjkgUXRI+zBTGQdkZ10fCoQLxfNz0YJPD4Zs9QGLPFZGc2or21Pccjoc+ynNdEzMi+Lr8SB923+qRzvn3DzxEADpliTQlUdlKx2HTT4dr/mWR5ejLEWURY4acG9aWtnYfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M268r/HFfHXITuYMGHMPyh3YU59Sx9eHm+UHyn/Tvwk=;
 b=Ams9CGaDJlbmupVn/jCEEO5rFooq9lRtte/3ryzxtMe4DW+OEoSM4cM6ct/wa/LIMRKxQZyYtzFD3YWgbWgDsCtM5qeppV9GSV343Z5o/btwzwrU2wy+ErUSSjY8HVA3Y1bHt3NI2zYJEUBTRAwll1pIA201K923+0xtpcLNoDbKw8dj34RCOIPODUscaeG1mSyAQdy33f5V+buavZY5rdvDWJ7qGKR3MAGWw2X7i1uglI4AD8HeL/gVvoGIlFzChxM//j/Z040cXRHOVz+Y92L8O2OGUgQoys/C7r/AYYvNfltKBhShmpJn8Z9R7/Zh4c0XhrgJ4Y+v4NaDkpb5yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M268r/HFfHXITuYMGHMPyh3YU59Sx9eHm+UHyn/Tvwk=;
 b=MXLiNR8FavtDl8bHsHXg5hZEV4Kj5fHYXNJZz2ZVaqa4E7sHcRsjKuwItGJqxRchDkuTIpKrlzALUwD1hPEZ6fcPf1EJkUqL0/u282AMjT7fQCkJ2dv7Re84o+gZG3qjCKK0KR9/yVM6aO9a5wKeR9Yew5XJsWUBQoB4St8is10=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by DB4PR05MB10392.eurprd05.prod.outlook.com (2603:10a6:10:3cf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.36; Sun, 19 Mar
 2023 06:01:19 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%9]) with mapi id 15.20.6178.037; Sun, 19 Mar 2023
 06:01:19 +0000
Date:   Sun, 19 Mar 2023 07:01:15 +0100
From:   Sven Auhagen <Sven.Auhagen@voleatech.de>
To:     netdev@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, kuba@kernel.org,
        davem@davemloft.net, maxime.chevallier@bootlin.com
Subject: [PATCH v2 3/3] net: mvpp2: parser fix PPPoE
Message-ID: <20230319060115.ivxaoosfhqqprfjj@Svens-MacBookPro.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR0P281CA0130.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::17) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|DB4PR05MB10392:EE_
X-MS-Office365-Filtering-Correlation-Id: 549463b9-6e2d-407b-e1bd-08db283f5be7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HSkzBc3ITdm/ntauezTslL41WYdiOg3Sq1+w8mUd9cQioiuUAOL+AXnwAbTocZpkIEWsm2LKoMhV9PqJtQVP1LU+okwBMaWWDksp067lM7d5gJDKGyQkHeI5XSdqCr1uIp+qSouC3F/ocw7ZGbRruWA1iXB41GhQbzUCRKBhOWxd2ZH+nrVj1yFtj5KBsKJTQ5HpnFI4bBPhO+AnpCuVNp9+kPXgBHLjbhqSe4McazDkMf8dEHdCAjq6+zwUxoFnLkevVoYb176MJ4bTuzudt9iWdSRMj9WzuekkqNje29De2NKxfJ8GgpD960rq1hWLYKSuzl18+Iuu/q+q1i4zqfLd7xEuVc65TwIpIdqgf1LBU9TH23xXNRKmsCfj7dY4xetWI6Tz205FaMv3Ux7McwL6jfrL/y9n8PzQzWeOvMEt3U5YuycLdzUZCYelS+4yHArxp5x+hQ+1mcXuECsLTxh+9+1P7SWprEwNpwEgwf0jJXF1gexMRAhPxsf9YN/mUbwGTmxc7BZVtQ3Vc4aFuziuWCO2xlCnctPkl8QMPZujsbE9d0sLCFpYk5LGsB3zHfP0WYaFqJ6BDUwjlA2Oe9XJdSMAh94p3vvXn/haoZFisvqGLeS1L5qdUicL4RWAJ4qddmMl7F7MwMjJ96+RpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(136003)(366004)(396003)(376002)(346002)(451199018)(86362001)(316002)(2906002)(8936002)(41300700001)(5660300002)(4326008)(66476007)(8676002)(66556008)(478600001)(6916009)(66946007)(38100700002)(3716004)(83380400001)(6666004)(9686003)(6506007)(26005)(6486002)(186003)(6512007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RmOuZFfgIYi5v6r10Y3+uBpWmC/s5a7PZQ6q7MbWOrK1hsHQcgnVShwtZ3GJ?=
 =?us-ascii?Q?ZpHXHuCbo902M0fdxQh1KsAR6dc3tAWQEBbh+02myh1SLegs5j9JZw41y1Me?=
 =?us-ascii?Q?0z06vC7wpC3osXE4tVqMiDjbaWta2TVdfYgG9+83aFwXNeRQssJUTuT+itPu?=
 =?us-ascii?Q?Veb9lTZY2Vhq0rv/Q2F6zDlCEDK3PCWqA61B2Ib7HaM0HMkNJHEvT0/Y8Xwm?=
 =?us-ascii?Q?mX6tOsCsl8zXS3eomdejwtU8j0pABw6wIy3KM8itpn8kyaUPfoVh9P/flScS?=
 =?us-ascii?Q?JX4KCuzTyAfouIqixT4zvr7yCMNe14O6R90p9AK86z/amb+8iYOuxOeI+hY2?=
 =?us-ascii?Q?Coo3UmvKBEdpQNSvynLuV7I08UlFn4hZhjxSbWTk5ZdCaAjCUO3GG9KvONXS?=
 =?us-ascii?Q?adFZNiU8BIvnY6IF7AHQG1yDhkAPmMOSK4blu6+u8scknozM76jMuHkeQYiZ?=
 =?us-ascii?Q?he0Oj3XXpgZjbavMDUlzlHg0ka/ZMcpRooCRjLIEQl0Zy3fVD+kDaKGOgvMT?=
 =?us-ascii?Q?vrOERXD2EQb4ibH2ksylxjsXxEE4vq502J862nyJ0rMsI4KK/8piZ8614eK0?=
 =?us-ascii?Q?upNIvIXgxFusI+xeDufsipybfCkRxl3dYM1DBPES1a1mz/8PrDhKkS3ZPpG+?=
 =?us-ascii?Q?QQq16sr+Yl8WwRiy51NWwWy3Ng76WNDg2BblegkG5y3HcbWJ2cf3T7xgoiDB?=
 =?us-ascii?Q?kAuass6qgBYcktKmSxbZgIN1gRC8PwZ2Kipw8qqNlrEB1ZYjOlhsRfCrEu0a?=
 =?us-ascii?Q?ivZ7waH6ogeUByosltS3/EJT4Z08gYAp1au7ZOGQm/9Wgten0N9k2rYJHMne?=
 =?us-ascii?Q?ubihv6xrOoJmtGPPku3gWQqM7qJYqK0ZYBSzAm3evgO4caW6q9k7qA2izdG3?=
 =?us-ascii?Q?aLZ2uJNllZ1J9ioZrwDMIjAGMxjEB0j4JE1MdhOcs94FM0K9NVhLObipdoc5?=
 =?us-ascii?Q?kdR41rGxZJtV+NOYbXkIN+sreL2ujZlH7Gfn0xMPoKBk5kPPl9cAD+WyeEJr?=
 =?us-ascii?Q?I8l8mSvhSbcIb2T1PYPcadBqENppmx6/yDbX7J8gS2QkJ4MlGFp8jbzW9XsG?=
 =?us-ascii?Q?QjXtlPJURtw4lH5nPgEd2xZ5zwFLiq0UYdN01+dAQeb8+crJ77TOC1EBwLQH?=
 =?us-ascii?Q?bviQ4IRSiigvnVyY4lQaLMQXZ+lcK+fu2tRSDLj1QvNj60bPyPLet/pdjyoG?=
 =?us-ascii?Q?4f59aDGh65rL3/C1g/u2W9yQByUWQVbzP51yI88AeKdVcWeeOcvZFbwGO6fX?=
 =?us-ascii?Q?0dvm3tZfcT8xGtVn+5WyTr9NXFS+bQvosLkkt+XgsFWasoV0bl55k4NLcLwZ?=
 =?us-ascii?Q?DdeyKlRAsdR9f2bHmIw1EUP3orRHAEk10n9jqKWnYV1H7SvEH/P6xh66t5Hk?=
 =?us-ascii?Q?mXBbTb9xV7oGqnifRNnbNvDCS5MVni9tukpsCWeWZWpa8zOmBlbkwdHNTGst?=
 =?us-ascii?Q?IC4OhQdQKAHGfIxn8EdThZNJJL6cILEwXov/CWRA+2jihDrcX1tK4McF44HR?=
 =?us-ascii?Q?+DBf/XqZPZszu+I5/Z/zX5Nx/DKQu1FE/yGwkNtnHfMkLRspkQhvTIM/YOif?=
 =?us-ascii?Q?ms8r7nunvM868xPk760xKpOIiUsJ02pIbe4tSGHq6j7xt+PrRsFg7azfjvda?=
 =?us-ascii?Q?FA=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 549463b9-6e2d-407b-e1bd-08db283f5be7
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2023 06:01:19.5133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YbIyRFvZMB2kFQW0kREKmSZ6GhJHi6dZ+Wq72l6HBhS7mSgRAkg45R4Ki8gV/rlXO1yTBvCj5H1rXNCPOqEUduyjDGzmqIQYNlUPnipFJZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR05MB10392
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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

Change from v1:
	* Added the fixes tag

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
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

