Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751126BFF81
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 07:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjCSGA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 02:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCSGA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 02:00:57 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2109.outbound.protection.outlook.com [40.107.13.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F03A22034
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 23:00:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OTmczPs7FApMDh0Bhk3ec0/1YumOXKay4gc8bK8zNL0JHk3t3WhURKNnEI5jmUal3PmocPsuHtrUMsOrnECeqP7TH+B37Y/x1W9wpZ5r6adNvvIzC+iNQKY3WkvuDDcj7dzTCeKjMZUKD8ZKrI/qwIsgusWZsh869jme8PK02UkKUHO+UBuoJeQPLGWC9Lr15P0CV1j7nb2RwBlmLGqCPe42TLgLrke6AlOlUckr7DS24hiCBpzsC3ONPV3pa3AP4FlVKvzdcSnhlw2Z9+4iviAZZC1FIP9WRvzAGKt1DjwghSN+v/Y7DoXDlN1776D6caQ7sGmJ9JBLHpSAipMolw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4uOsGv6hhmH+RtGSsQUBb7N4UfUvJ/egTT6pIvLXncE=;
 b=XH39DzYeHr2VvBCrgP+q8Muk8uPHSgzZGycLZyM2kwb43mpKABPpOUfonZ2bVkE/pnwtPojrHqyd23HYXhhKbkCP44Dgg8NknqODBk36FOkWMedncBgpiVJxKytVURxkFFg3vlyfBGPRntuZjyJ0ucXIdsvaWPDc0YkpHHuwqtpyVX0gWUQfpbsL500s2XoKzxoo3Bc8Zcb3Hi/wtiVVz7tLhcmhPrMN0DmRf9UfB13VwrEiD9AdtS0E4TbJiYNCHgbRE4d7eGlSoE4pmnH1j2dLp6sW5sP42R8xhMl5z3nEzY+SBxogCItlRD/tSU7cKPO+iYL42YR/x6gqZNBPqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4uOsGv6hhmH+RtGSsQUBb7N4UfUvJ/egTT6pIvLXncE=;
 b=f8HVm83vXO7gmfrddqT3+T6AhDQ8mrtnQQNYkzNCEY4/UM4rMWTqK8PTFYt11+mjk9ftB6GymP3DeX32EyhO/Id33jLkUAELJkSb02WD5QbExiEOqUfbnSIXAIbipJb/Yn3K/PexzQCJCuE3m5UuWb6VhWZuJTJI3r1hfMhE2KE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by DB4PR05MB10392.eurprd05.prod.outlook.com (2603:10a6:10:3cf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.36; Sun, 19 Mar
 2023 06:00:51 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%9]) with mapi id 15.20.6178.037; Sun, 19 Mar 2023
 06:00:45 +0000
Date:   Sun, 19 Mar 2023 07:00:38 +0100
From:   Sven Auhagen <Sven.Auhagen@voleatech.de>
To:     netdev@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, kuba@kernel.org,
        davem@davemloft.net, maxime.chevallier@bootlin.com
Subject: [PATCH v2 1/3] net: mvpp2: classifier flow fix fragmentation flags
Message-ID: <20230319060038.t2s7abqs4umelcr4@Svens-MacBookPro.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR3P281CA0061.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::9) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|DB4PR05MB10392:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ba4c34a-731b-4ed3-4258-08db283f47d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uHYEo+dqeq/qO7jOky7b1RGgBuZZK1w5oKKJvw0T/YxMQrThlLP0QEEdUhBlY9363XTi8R3k7bX1rvVm0vd6kTy+krCpg/xGPk8izm+7+bVVdMHI+WDLb45LC2ZBoCTTrTeVjTAPCWypTwFTPGWI8qkDvtEnETgC1UGbQascf8XnuLi+akY1G7J282H8xUrJYNnOtr6ET8GeBJZKLS1/9v2y/tSxt1iaMILi/yjlXn0rf5jYEQgS4PMas23bLEbQIr54EMqB16luU882xiOuh8uBFn6AxaLpSUPbEuuihRGwfUh0Qzlgt9pkm5LLlvNeMs2Mif6kg3VBVXQVnPEZFZ63fI0pRSZAmEf+jX9SnrKbSQmIcwT3kI/DaGz1enScu6PN0sbu179R+RvCSLZ2N4cmvhaNiMK3XLegpgL99homnuWBh0gbOnSmFaI2x4+5Tl7mf+EdvAnepalNTVNM1XPjIoOG5D3R5ztLdwRR30cK4Q8KpUyotInmO2JlPUXjpTRDCbAgBQ+nabmTN1GrUSn/uVJq2CFTeZ23GReh/R3j+d+0pwcTigt6bhK++R8UUhP8V40b9uaOhGmLYeJHHnJPY5T/gtnxSfk/3YgB72RNvnoP/lipq74fKYPuYmi8MOexxAMRJA9jCEQ2DVKyYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(136003)(366004)(396003)(376002)(346002)(451199018)(86362001)(316002)(2906002)(8936002)(41300700001)(5660300002)(4326008)(66476007)(8676002)(66556008)(478600001)(6916009)(66946007)(38100700002)(6666004)(9686003)(6506007)(26005)(6486002)(186003)(6512007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/CyEuQhRfRv+krgHiOsZmal4B962kd9Rwk6K9VXZ1+YCCNAgZjo9djLuguhw?=
 =?us-ascii?Q?P3LvwUtWnnGeIXvtkz3FikaKgKerBkMwZ+178+vZbJ/G922SUzM7w4O72LeT?=
 =?us-ascii?Q?mNuip1rRq5TfiU6185szvHCd/eiIABoKP36fwuEXlFqJAK8/F7hv5qUnzpYY?=
 =?us-ascii?Q?92iyrOPiAri700rok3N31aMJbIz7VsQCVt6Jz9Jx6cNzKLVEYlQ7J3J+VLir?=
 =?us-ascii?Q?w+JiG4BKVFdx+VNvxOJGalBIdPQoErp6sjkdyQcwhyq/o/MnEATrcGMBDROT?=
 =?us-ascii?Q?QrqsZGj+LI+n3FYLYjp+gtsk3w8IUIvx5+ArmjuoMPCDUKpMKDoLs3jJnZR0?=
 =?us-ascii?Q?YLz7DULS+pqRso0iQWp0ceI2FvgaP0o3ZMp+AK8+gaIbD3uIopVejnxZI50R?=
 =?us-ascii?Q?jiCVpkjkrrnYzH9j586QmL420mIWAf/USbfgLQEHSwS3Lxksat/j1vnHnvLK?=
 =?us-ascii?Q?gMPwkOOwZKHRT9GOHzVmkLAKoNx+eTtl2MCJuw7WHmpaSBmdxxUWgdFMT8KW?=
 =?us-ascii?Q?Nm/azSIw/Fkn4LxMbbcy8zYAaNwXwyGAzaQrUBOHctZVtA2d82GMyZ+rq+X6?=
 =?us-ascii?Q?mSZZaGIa2H+o+U7mFHbq0dtxIXmSk1JhndtTcci5ZPWKa1OTmikc0h3Q2f1T?=
 =?us-ascii?Q?gU2FEHwMFGJUqb9VdFWEz6kG9TMtyliNaZqyuQ0SRRyOqBHWUMImhpIcLvJ3?=
 =?us-ascii?Q?MSJcYqWYGuWHICsuz66GpSX73bxRNCf8lHrqvoW0W/hl5FO14N7lUtS5rOL0?=
 =?us-ascii?Q?w9nWBpmR6+w/pywCZTa8TltHsSga5IEDHb1Z0cg9rmHBIPbWoNdjlI9nkM7e?=
 =?us-ascii?Q?hL7X6eA740peOAcMnJ25xQhUq3//zuW5FgZShc6bJG2ynAm/iDt7U2d+14XQ?=
 =?us-ascii?Q?r+8spnI03MbAYoZz2N7YQPaDLuSiDrUU0/R44FizMQpSBYDupOQFo9wjrjoY?=
 =?us-ascii?Q?kZdT3x8t7ki351I4f/Ec0gMv0N6z96c5zKGBIijLHtQoG82cxvelTbJtdI9X?=
 =?us-ascii?Q?C80pCGib1oQGWqTP/t3lI0rrLt4k7nQ7atIJ2UBZW8d+X0DGllKB7+fRTaqa?=
 =?us-ascii?Q?qp6fNzhq3UCcleQyO9Lg1d9F599OPW6r0IDZD4E2PLwOr/gy/kkYnzgwJxNk?=
 =?us-ascii?Q?0uhuO9MO4uiyhgM21q4u0teKSBTK7gV2LVI5GSjuCzCeIVYQJHRC8OPx49//?=
 =?us-ascii?Q?sbaQeW8IlOwyZF15Q6fDweqO11Dv9gCsxj0rSwKfAyzb2mxnM5805/xPF0OA?=
 =?us-ascii?Q?OEHALXnKEOCdKInhm6u6gI7kqjNgQLceqJ5sIVGN57jjJPlFUjoYmwlAyfMW?=
 =?us-ascii?Q?sh0jwyxitYtJ1QwaaSSm2ozvfnlWnhbXvSwgEwYw5WFPwtQWWPSbR5jnckbX?=
 =?us-ascii?Q?wmcjAXuX5Y4OGDvkRfgw+az1pgQkHSIpaXyEVP01c1vJFNQxYpGnP0WUsI2Y?=
 =?us-ascii?Q?uPQN2xsPkMwmDWwqs7SH4VKsPpX7hcZg/nMOUu+Yrn4pL8hVAOoYDMfr2oge?=
 =?us-ascii?Q?lXFROVdTAQ4NG+Gcr5+HfO6horxseZplB5NFX6rCx8K7JuzKpi4B6/4dsPo+?=
 =?us-ascii?Q?w17z88rjFshHnXTT7f8wr0ggn8CqrLpuGF9gQCYsg4jFCY3mUyt3J9YY0lQS?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ba4c34a-731b-4ed3-4258-08db283f47d8
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2023 06:00:45.7868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EgufmvDbJP/OoZorks7RLttTVJ6iPAtlMWCsw6Vk3ptIP/oGrlFOdmyHT1a8/hRRBuhDgWisdcojPuozr6HtU5UihUqMtfuQtBzoFBCiRcY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR05MB10392
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,UPPERCASE_50_75 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing IP Fragmentation Flag.

Change from v1:
	* Added the fixes tag
	* Drop the MVPP22_CLS_HEK_TAGGED change from the patch

Fixes: f9358e12a0af ("net: mvpp2: split ingress traffic into multiple flows")
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 41d935d1aaf6..40aeaa7bd739 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -62,35 +62,38 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
-		       MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OPT |
-		       MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OTHER |
-		       MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	/* TCP over IPv4 flows, fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	/* UDP over IPv4 flows, Not fragmented, no vlan tag */
@@ -132,35 +135,38 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
-		       MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OPT |
-		       MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OTHER |
-		       MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	/* UDP over IPv4 flows, fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	/* TCP over IPv6 flows, not fragmented, no vlan tag */
-- 
2.33.1

