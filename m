Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42CBB4CCC0D
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 04:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbiCDDCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 22:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiCDDCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 22:02:52 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2096.outbound.protection.outlook.com [40.92.99.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B353417EDAA
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 19:02:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iqFbTjBa9go6WAfktIMQlxlflTjBd/lpIT4xVNEW47EGFtMSYmXPOcHJhpKjlq60dHzg+AIMqCTvKscpdZyZmqysDvPygl55cWfer0zgimNszgetDQvgVs5MRIVI43P4Scza6wwW7pkdcDIvKGhRSy+Tux24VAO5MvCK8uXtD9ulCFxaKcosi9DsFHqpRlDLnYplYOdVANpLL3ebGsz8R+zBJw2aX6tLYNio3k/m4kTQKzlr25WMtgLkZlzj38FeYXf5AiFl69kkehwxOucMPeGEfTNjPTrpeqZ7lUSASRy5IYw+AQA5hvWeA3s0Vy1/+kSR0OtbvCwGCEbQFuKZzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d6BZZOnL9pbwBPpV/fkKxvb9UYNOqUenJBfv+NBDh4A=;
 b=VBZ9QSZoFa6Rn69YTPK1qNCwP08LLCGhA8JMuNFkh5mnbNJK7rKAQ3a/P5Wzmigkr9jWqjwae6umgNZu11zR6iRdv2mpqhGfu31XbbmMMUsC6PgmGoYE8rkbsZWclF3fLAa3MFYw2oGlG0a/ezU4lyYjsbgg7P2Hs3mairbJQXz5QK+iJCALrAAW2jeBftZ1CvRigzhdtKHxz0EtwhIU0meC15X7mFwF2YVJM13DnAFh+f5n4/P8mdJ8jIzmu4/6BQPXVMmfrxGgXPQFXBvJ9ZD7agbvCKTb9vVVWA88WOBOCnC+QG9VAswnfRHNykpwEcG2CiMLoQX6/qjk6i7trQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d6BZZOnL9pbwBPpV/fkKxvb9UYNOqUenJBfv+NBDh4A=;
 b=igeAnfIsykszKcLJabCiEdtcWnokuAdEg9NvKdgeFeGBfCdWdGirRmF65M3DvaClTcvRrNAUWXXjNij7vQQb+d1UOXAjOxdGWx4d43Jt+V5yEd4mrSZrnuVuFyGCRcBjmfiQEWFzqEMRlZNj7ZKxM2a7o6vQxkmYxR0O9Dyr+yYtp2bCdKY9xIOUkwklxUHlxsnJRPUmZ0aB6dH4jJmwEt3Z5cwslHoTQSd0AsomKMRS4wBJEtzWBBX7kBM2QQd8oqbXHMY6Swy//pOmnTc9TkBtxwA+65xC4TqeX9B2JQF13w+yE/cVijS1oTn6T1G7dWa2hOpqWzF745BfydzjWw==
Received: from OSAPR01MB7567.jpnprd01.prod.outlook.com (2603:1096:604:147::9)
 by TYAPR01MB4767.jpnprd01.prod.outlook.com (2603:1096:404:12b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 03:02:02 +0000
Received: from OSAPR01MB7567.jpnprd01.prod.outlook.com
 ([fe80::ed12:bc41:7a3b:ea5d]) by OSAPR01MB7567.jpnprd01.prod.outlook.com
 ([fe80::ed12:bc41:7a3b:ea5d%6]) with mapi id 15.20.5038.016; Fri, 4 Mar 2022
 03:02:02 +0000
From:   Shangyan Zhou <sy.zhou@hotmail.com>
To:     netdev@vger.kernel.org
Cc:     leon@kernel.org, Shangyan Zhou <sy.zhou@hotmail.com>
Subject: [PATCH v2] rdma: Fix res_print_uint()
Date:   Fri,  4 Mar 2022 11:00:28 +0800
Message-ID: <OSAPR01MB75677A8532242F986A967C9DE3059@OSAPR01MB7567.jpnprd01.prod.outlook.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <TYCPR01MB7578E54F06AEFE50785B771CE3039@TYCPR01MB7578.jpnprd01.prod.outlook.com>
References: <TYCPR01MB7578E54F06AEFE50785B771CE3039@TYCPR01MB7578.jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [ICISLI4upG/idpjmUpR9eZ0pBg3VxM0f]
X-ClientProxiedBy: HK2PR06CA0017.apcprd06.prod.outlook.com
 (2603:1096:202:2e::29) To OSAPR01MB7567.jpnprd01.prod.outlook.com
 (2603:1096:604:147::9)
X-Microsoft-Original-Message-ID: <20220304030028.3085-1-sy.zhou@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18732f47-2c4f-454c-7e00-08d9fd8b5b22
X-MS-Exchange-SLBlob-MailProps: Zv/SX2iM+5X072ERk0DazaL2GeqJ4Zfku4ndChFT9ZCec7ZLOOMq3hChUGAla9MggTtmvNfW45/KcLEU1sfd127/VlEWcsth5NpJX4bvNHauNG4deFM8XQyRaLMNqHqERZFp6Et/hoyDZRTAiYVbfQ2SBp+b14DDPjQpFYXMgnRGPhtMUb8AS495HGSwW2Tar/qCTHqgw429GsMgbtYqd9FRjU6gDIBj2w8DQoL8Y3n+2x+E2W5dcIn6MoxpjkCrWrsOLZmBWSiJRmiStFORU7Ksat1cFxjg9IonDkvJFnxzjKSmXuK6bfhnZ2iaN/+L/xWNL+IcNj61en2kQ/02zonNjwukR/FY5tV6UcuVLpDYOns+JESzeScvvIaIv0tljo/BZ+keZ81MQZdFVjhvW2kXMH6OyyOKD2YQ+fBGhjdwRuFxLqcgcsADv9akVq8hMIvTn5LEHoSu1BhYydRnRbVURPtIlCc5NMIVRNdhVmaelrKVb1xD9KIyi5+yK/O2tijmX0t7hCEPRwJj2WYMPYS9CxymP2yheEEANW0arclic6fffQSux4euft9xSbkTxvMjGvAcYqQ0dvUBBvXSCkN64Wdrzx6kpnfaQ7jrxHh+rpVVSEU4++esnOtOK1rGbzo2hvx24iIAeQlyYN4QZ6D+RnPI9eKDSWpMNrAK0/4Xhf3mslJ3/Uyb4b4R29jLkFppPtsy9JU=
X-MS-TrafficTypeDiagnostic: TYAPR01MB4767:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lWB+eHXe/REfyhmVHy61IJXmEDbbHBMq/mMX4w03m8MNvDQ1EvcGzxDwDVHqyJUtbRJqTZsACFPIW4OCODq4IWHv5CQ0MXfI43cShCirQjxENqT29y6r/T89vt1Be9Br7L9TlLUYfKSfBatF3Ai4qBBPEDt4hmm4QbZY2bYShYL6m6JPYF+yyvJ2yfdpu9n8fkeQSt1mhPV3n4r1OvJUeDhVGWJL3jMmL4/0864+wVxSd2fx0IkrTR0cU/RL+u6n4yV35XJ/hbKC4TIxCKzRb0ms8dh0aieXqinPXi2wgifMex4t3OAWfecUF4mRALnDqp3ckm8nXptOK23FcP9TFWF9FrEjx+Hej1ExlMD9uSN2ekvGNtZUt3BfbG+4sMf5i+zAeFs+UbhH9AieYVCRJXtGZOfIZ5gFdt9SfFI4z3abc+N2ZIJjtbDe9UQnXdbUpNsXWh9CqdaftVbWlxbVgAAirITnmJh691iWCrHsjxtO94QJSyKHBgwOs17WrLp/yEIzVJv4d+JF0lTBfoQSCJGFozx2vBCKaA4S29nzPrPI1QflX3fNwM0W+MDoeO4qBiVO6K/RwxeMeax8NFddoQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hClKq+9jM0n5mp+UzU2vbfSZFjBICwRC4Oo01lBgZnzh/3PzTYQ/mwzTSVzK?=
 =?us-ascii?Q?QRyd6/62GbuH2kdnN51AyqLi/mEMepnFeapUpq/dqfyLbp7LybKZtu89EG9S?=
 =?us-ascii?Q?iWTrCywD+/gxSF4U5Ka/UDiTouG0Tl/F7IOlPtcPmjAoHr4kyko0vYgncJvu?=
 =?us-ascii?Q?jal+RJXCJyFcQ8H8ocCUiLEDRBo4rneC8oVXhepsYQhocGzb0th7DUNZ+aT/?=
 =?us-ascii?Q?eOG6A/JrOVM/eQDOOz1nc96IwxiBbuurKso45y6Kgr+AKO+cHj1qskNSExdJ?=
 =?us-ascii?Q?Q8+hwqhnDyB823/YK/QYudRYqxIra0Yro+LUhf1IuYEhj5mY1g89ECreDc2K?=
 =?us-ascii?Q?yZ2iFffqi8MY0NkQr8X4phe6Ym6gXTt1oRCHnSkYIdvFmxhKu+M4NsMv5FRY?=
 =?us-ascii?Q?c5xG/Jgkx+fCksUHo+0VbmMy/Q7FTfjSLSZuv57LgLFmCaCqDRiT1hzHcaV9?=
 =?us-ascii?Q?O+JZB5Ze3W0H00WivFrK+Pgl2bMD5HwZn/wsZREhbddG6OmZcYjQqp5wpaBi?=
 =?us-ascii?Q?l65ukhsSrHpRmdFV2jC92rsitdKTOUYRqUVbO974AGc0iSpn0X3f50HE4n9a?=
 =?us-ascii?Q?bN+jU0v88oBiElAgzYnDryBslu3ObHwN4H3SHgvGU0RkCk+2bCQ8cs9s6KOQ?=
 =?us-ascii?Q?Y+93KYUU9eOoFNh3MgJUBjkMx8JV5CSJfnHbPrLECO7hXlLRFn+i7tdA45fQ?=
 =?us-ascii?Q?rU80ewRfcPp6An7UoVnWldfkOfrI37MFLbeukHqGyA9U+33nI3m33sPG+RtN?=
 =?us-ascii?Q?p5vGrKPk5gB+fRcBC6qu156Gt8WiZaFsnILkxMa0IsKl06SvoLfsMug8IZFA?=
 =?us-ascii?Q?vpNOr/5eesbvrWUHZfn0MzxkMwzlyZ/OePIf6BSr6JHFfvC27zSnt1I4jeRM?=
 =?us-ascii?Q?FTAk6gHL8xPBYFj2o6mcGZnkk2RHf2xaYwjrD2hhSR+eCdo02yyUiF/PC/4/?=
 =?us-ascii?Q?XzDMk0w+eb/57ua4yX3x0w=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-9cf38.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 18732f47-2c4f-454c-7e00-08d9fd8b5b22
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB7567.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 03:02:02.3716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4767
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print unsigned int64 should use print_color_u64() and fmt string should be "%" PRIu64.

Signed-off-by: Shangyan Zhou <sy.zhou@hotmail.com>
---
 rdma/res.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rdma/res.c b/rdma/res.c
index 21fef9bd..1af61aa6 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -214,7 +214,7 @@ void res_print_uint(struct rd *rd, const char *name, uint64_t val,
 	if (!nlattr)
 		return;
 	print_color_uint(PRINT_ANY, COLOR_NONE, name, name, val);
-	print_color_uint(PRINT_FP, COLOR_NONE, NULL, " %d ", val);
+	print_color_u64(PRINT_FP, COLOR_NONE, NULL, " %" PRIu64 " ", val);
 }
 
 RES_FUNC(res_no_args,	RDMA_NLDEV_CMD_RES_GET,	NULL, true, 0);
-- 
2.20.1

