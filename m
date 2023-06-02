Return-Path: <netdev+bounces-7364-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF9FC71FE55
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 11:51:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F25DD1C20B79
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AFD71800A;
	Fri,  2 Jun 2023 09:51:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8847E5687
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 09:51:50 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2054.outbound.protection.outlook.com [40.107.7.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0706DE7;
	Fri,  2 Jun 2023 02:51:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4jnyOCxwqAtRkjoQAZA2CIggbVwj3e1D23St4ZocUndV7TTLwGiDiI8MFr6tmQ69OEeror8sEBB8U+6eCfIcefUaQhAOZGHj0IKDc6zJFFAq5yJRHN2MX0vafwK1wCyVU0CjgbKynvKGmoxkxSRfndvb8cgLI0FZhzACYZTZ2daKs88+V3cOb3bRpYvOV6qze8XWakEM20a6XKbnfBZhtzxQJzdxntOPEjx26CDACvBOtLeB107ogZeQnKJhagmxfvYFeiQ+W+flzqFh+HcjlWP+lTm2RbcfX3BgHDsZEb53q6Q0PHrxO5RoTIWx0K/tx/ZYe6PpWZ4z6KqoEwf4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TKhTXBSWj1+2z2+Ytz8n5Rm8K4LL3xmXYNO2nUklac4=;
 b=GPK4cnoJ0AjAFUn9KWyN93C5hvVtIErYmWjTAfiXFw3i7tig65SLpen9HFi9rr31fIhxQRA1l4S/snGD8mRq5GxgQ6HjLwan9X2pHbY8YPrv4hAqzkMLZvInkwPw9Ld0OLhTycrc1ccPJbgO5QaGbmcJpBR29McvZBKD7wkLhJ0Y5BA+0XJWc6eMEfqStplY7wQR7QZLk45uZnPuVF1VIVpedI0T1OkLTVmhYU6LpWz8px/Xal3kuCOGSc60lsIJEyP3dDSB5noTOSzC6cot/V7TYswqlFgFXHVSuHgkNkpsCs9vfUkcKAfxCYwK+htCBb6FXxmMUp1zSOA3RIc2QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TKhTXBSWj1+2z2+Ytz8n5Rm8K4LL3xmXYNO2nUklac4=;
 b=d8LyYEQeAmRusfER5VcX9KovqWAdbEPcULU+ygCHFlOFIYTj/OkxnWRDszuXJeBXo46XOA3M0narKpF7j61IuTlC3BVZJHYe8I8RHsLph8k1q6QHMhjp8kzRPkHnlSYxCiGMpN+PupsDgjveMT5s79eD8X5gC0P0ATNPE9NhT7Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by AS8PR04MB8165.eurprd04.prod.outlook.com (2603:10a6:20b:3fd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Fri, 2 Jun
 2023 09:51:46 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2%4]) with mapi id 15.20.6433.018; Fri, 2 Jun 2023
 09:51:46 +0000
From: wei.fang@nxp.com
To: claudiu.manoil@nxp.com,
	vladimir.oltean@nxp.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.or,
	pabeni@redhat.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] net: enetc: correct the statistics of rx bytes
Date: Fri,  2 Jun 2023 17:46:57 +0800
Message-Id: <20230602094659.965523-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::19) To AM5PR04MB3139.eurprd04.prod.outlook.com
 (2603:10a6:206:8::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3139:EE_|AS8PR04MB8165:EE_
X-MS-Office365-Filtering-Correlation-Id: fea91477-94d9-4cbf-f00c-08db634efa17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+wflu5jM7te/mrSv99QpvX9WceoGhP77XiFtx/mJraeDU59EYIjUi4MRrgBeHPNDjBtyvO7xRn+Uj6tlOCCldvzn3QEsNxm+mc97asJxqep4GUpkXjNOIA5LgCrF11MfBJaW44cOBk7yKZSfqlZtuYgxpJLzkE43QQMJj+86P8p/d8z48PjI8FeCn5kMx5XFrkWyiDS1eOI2/qPTxXKO77/I8O9puiKILg4BVRxwspAVVPS/lWg88Db0C6JNQ98RNRIgoCAfZbTmiFHU0Id1wdk8BWHSD4oBfJTdxIJnJdU6vGT/0tjuQ0CCE193MzmcVYH6I/QETVDhNAvCJ6x6LyIRlqMN+orH0KNiKB5diE/Et6vk9gUMiZb3qCy2fztKpkBMaLgFLZeZqMkbqV+kzL8ZnE0F2nmU6FJM+d1RHC5Dj4g2gCYUZWEx8HzPIelf9kowbfrkC3mVlmywamw3zhrU1gQXXf7KsE9KvPw3cjrP2lTIL0/4hFQrEc01MQbqBJOszf3q2AF9vfc+fRM78T2LpRoM6Okgof9eEExaZjd6uTcrsw3FGEJdVkuxoxL3TF36cp/0RU+Odscgz8TK+O6gO+4+yktZPc8zYDk0V7FmtFPLCosyg4DCAYmteoMN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(451199021)(9686003)(1076003)(6512007)(26005)(6506007)(83380400001)(186003)(38100700002)(38350700002)(41300700001)(6486002)(6666004)(52116002)(2616005)(4326008)(478600001)(66946007)(66476007)(921005)(66556008)(316002)(5660300002)(7416002)(8936002)(8676002)(86362001)(2906002)(4744005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V1/8rVEG10JLiBJi9oW072msCOabIRtz4CNxQNY8XCTp7prTS3yjdTdwkDj/?=
 =?us-ascii?Q?DY9w7Pet0Byz7AQNWCO/Vs2pRDhpR9/49qithhOOLdsbibDjHX9wGHHR7Pcg?=
 =?us-ascii?Q?KGvcUfdvuoHu77O+AhN3/JcCv7Ute2o0/Ad7U+1DwM/S8FIC1bDubVcR0IpB?=
 =?us-ascii?Q?i8ds0McboWpAjh+DEkfUJLQupNafbEtDkAEXaQdwjZXj+1APfzGCwC2q3KMC?=
 =?us-ascii?Q?wvrGwGf7n6oQSY5jYZVqlGFExoOeqbO9bvA9+/KwTy2lB4JKu29m0VceKbFF?=
 =?us-ascii?Q?v5V3mLqXxG+336aCbr+glkHbTMxFIAa6UG527zBZMqvSuKdqLpiGW+cHc96P?=
 =?us-ascii?Q?4mE8cip6xYTrtHXNOr4D7gNl9oonZUPj6XzQU8EwizLPHWwEradqw6oyjoWV?=
 =?us-ascii?Q?I8YEYIV44BVkMMqChYtsX25zufeAJ8+lY+06Wn5n6IhrefrCHiqjKZfZeAaM?=
 =?us-ascii?Q?YUYDOhjzbk2+so2/oPnjR1QG003ZK00WtwfbxGv8izfIUem+QremIyDnUNC6?=
 =?us-ascii?Q?Bz8kaR3NlpM7fD+laprMruW8nrw1h06kJcWPk1v5QT6D6paZBLdZIP39YRDM?=
 =?us-ascii?Q?4xnn8wZRE1vPxg07SJq5tFhl7S7tKlGBUohC91E5VmvnaHYlb2bVS/jQi4uB?=
 =?us-ascii?Q?jEsAlbkifIo2kpuKr/vsRKIHghpniJZEKx/CmabeSqMgYAi8yO9CAeM3Omn2?=
 =?us-ascii?Q?HGAAFXRh2nUDC7X5ZtRoqQZipELjB7HOtgWppdc1HirPtF+ZO361JRZVVuVM?=
 =?us-ascii?Q?bGnloEDvM85wp3sCEiUuSUfm0AG1joy+CIFIhhnz3JyvQch0uSzxX49ZBc/X?=
 =?us-ascii?Q?gpf1e2UAo2/4g7p01gdDued3pfrUE6Ye+fgxnJ3ilBgrlUS2rCZl19/Y1foK?=
 =?us-ascii?Q?II+GNkqkzyeX6LwOj1Z7zeapi2gtZB8SXDy5Zq5w3jIQ9WiufrTEM3NNpPM4?=
 =?us-ascii?Q?4Vlv6JctYYHG4XuMxLSE/gtTBtL61tGiEsN/7z/UNF2U01EbmoxlK/RyLaBB?=
 =?us-ascii?Q?FUgk2DPh4GMniW5akMpf2k4vCr3DTVVXy5IxDj/eFyUPBH9zANn1CtAVriyM?=
 =?us-ascii?Q?dqai8tM6JSsrXeH5z88rM3QgiCsP1RGfO4rbbTb1Mk77mpHU3xgFxq0Fa9Cg?=
 =?us-ascii?Q?m8VJmm/GxpUGIez70SFIvmbP/aJ2R+JTQP5sUuwq4LrEOXj2Bu+XspChvdpF?=
 =?us-ascii?Q?8pNUdZrkBFDjsU8isCZxIvmt4CPWJUP27Apu0V6Zd8ygcf1zfV2xXaimZNoc?=
 =?us-ascii?Q?RGE/EtXMRZA1280hphw3sgcEI0W3orMm97BJCfm6Fbe6oTEk6qoZSz/4ra5M?=
 =?us-ascii?Q?36/1ddXs5NTeuEa85cLj8iD8oHP9lXbUnPEeiDqTrAmwudsKF9XGTNLJBuTN?=
 =?us-ascii?Q?h7JoLeWUHZK285QccIKmPmdq+VYTUArTPCo6yYbJ+ga5uYgWiWf8Ei52/Qv1?=
 =?us-ascii?Q?KmVjNzIFGhCBX+T0XRbAyQEmvs3UarVnWaN5ND5Phf6PXy7FRnA+pvUojwVg?=
 =?us-ascii?Q?oFM8R4A0SyiGmPPIucaTjsRHC9KeQEhw8iliDqckvOByrqz8tc2bZIAu4slO?=
 =?us-ascii?Q?e59egiSP6xAfV1OvHro1klHjJrbzuZFqyvVpMqdC?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fea91477-94d9-4cbf-f00c-08db634efa17
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 09:51:46.0922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YrtMB5ibvDb7IOEkE5xdWP90/56RGD6tFP90legkXO4vjEeeOBeKmrP0Bme2oDuyMjaHlxasbrHd9M6MjfCMNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8165
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Wei Fang <wei.fang@nxp.com>

The purpose of this patch set is to fix the issue of rx bytes
statistics. The first patch corrects the rx bytes statistics
of normal kernel protocol stack path, and the second patch is
used to correct the rx bytes statistics of XDP.

Wei Fang (2):
  net: enetc: correct the statistics of rx bytes
  net: enetc: correct rx_bytes statistics of XDP

 drivers/net/ethernet/freescale/enetc/enetc.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

-- 
2.25.1


