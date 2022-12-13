Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C307664B290
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 10:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbiLMJnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 04:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiLMJni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 04:43:38 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2041.outbound.protection.outlook.com [40.107.7.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6696DF59E;
        Tue, 13 Dec 2022 01:43:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSJITdyNxA/DfQy+qeCA/B4B6EQJF8IX7pSQ3tQK7Bd3v+Q89lH28EvPPZ7P4bqZV5HLw1f1WgSqoi7BrJe4MxzWAsdZH8naTv6F5mP8NygOfvoMhk0YqjcGfMwdU7n5RPtC3oDegkLX65fDhwCRWjKMTbj4HCTAP0v2rT2P7G9NIzF16QYPd+4Jd0wce2NQvIt9t5oZU7OEcUY2ukZgxWlE4TZhSSDqSYDwVg8x45HyPCaj3NunIIAVSqJrP9G8feC4bCmvwm9Coe0arx75/qey85q10qyMkayjwQCfsR3OurVH7HTYKdv4m1t/h4cKOUo3JanjRgk6ERmWjZhHcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rJjhAOB12wONSCQ369N8LT+10Qv47ht9OXns4e1TftY=;
 b=KSxT5q4GLkt28eLSUF84cRmVH4UcqSGdo8S2Vh/8vD9JtL/NRA4zUVDncKtUwvV0zMjTScTqSCU6FmGg9jXh7TrJBD7RqaihYK5z+Ngz/UIPjMH3OJI2iuo2VOTrQxmEZSKe5W8HEh3KP3iOl7AgDozdDgLrhYqgTtg6589o49ueXGrYi1isyoO8LsdRDoDT4TS8NmO4OgYbngl05KOAEOK6m53XUHbf/3tXA9n5Q9xbrQ1FZe4dg9prPRNltgVEiIKxRhVIFPw3nkDJuWAB1rUfmIt95TeD8s8IjQWEDyeU1PpfPONbtHMc774I8HZbtP63y7JwoTC0Yoc/KHtxBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJjhAOB12wONSCQ369N8LT+10Qv47ht9OXns4e1TftY=;
 b=f8h3PxTS67H2jpHG8y2K24TPC8d4wHzwxwqqSDdzH9OwPYKuaSDqA7DGCLjOe4qoPdsZWUIj/lk1q98fdY5MkrBzBNextEpHlrWi4/P4hO6Luq8GnSqVULhA5tQCToszEzYoamezOQgXzJkU9maMwFbFcWoW/vOgMuXqa451GBs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB7PR04MB4010.eurprd04.prod.outlook.com (2603:10a6:5:21::30) by
 AM9PR04MB8570.eurprd04.prod.outlook.com (2603:10a6:20b:435::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Tue, 13 Dec
 2022 09:43:34 +0000
Received: from DB7PR04MB4010.eurprd04.prod.outlook.com
 ([fe80::7479:76ef:8e5:da0b]) by DB7PR04MB4010.eurprd04.prod.outlook.com
 ([fe80::7479:76ef:8e5:da0b%7]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 09:43:34 +0000
From:   haibo.chen@nxp.com
To:     wg@grandegger.com, mkl@pengutronix.de
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-imx@nxp.com, haibo.chen@nxp.com
Subject: [PATCH] can: flexcan: avoid unbalanced pm_runtime_enable warning
Date:   Tue, 13 Dec 2022 17:43:51 +0800
Message-Id: <20221213094351.3023858-1-haibo.chen@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0011.apcprd04.prod.outlook.com
 (2603:1096:4:197::10) To DB7PR04MB4010.eurprd04.prod.outlook.com
 (2603:10a6:5:21::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR04MB4010:EE_|AM9PR04MB8570:EE_
X-MS-Office365-Filtering-Correlation-Id: c528a398-280a-4319-2a29-08dadcee8094
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: crCgoOivS4U/z6drn2Z+OXaH2ijGHAwlqyN2mXA9uAGBESM05/ZQoQE1IvsZ3k7y18Lm176z67okgJqxX7TVrmR7xWKXGIOBivKj5DPjHJbiY2EtELw5z1Sio+NcddmAwar+78zTpNrM0BpGvyQqiWwJwZrJ8HhS7cAkkYNuJnq97OdWEGIH17yX8TtsG3IsqqNmZ1yXJYCgEA2s5w9ekwmSHB9/pWkTZIs2xomlsUUAHJyt2L6jX5ccMlUyzV/eOLTUE7Mt9B6lIwLM99lYPnjP2XBnqvseZ05HHLCTf8g2o8fjTTNsKl2EqOwt0x4phtV9Og06/OGAfVNeGShxJCuUXw3pMf+dSvlM/wvq0F0ByB0m3XhQEqi5E6XUfVwD7N3qUofXEUyM3+5s3XtbHBfZSn5kKMlColjX1yVMuWwGoc7AQRyg+DTyjwWofhxaUMINf1n7iw4V0WnsuV7MbIzLD8rpyrbjN9sDJl57ANMGpEoRZe1wv2kaoXP08kai6KOzGVcQ7aMfXtI3Y7BTvbSJLBn0KoZixie4LDLoTtfg5Z9OQWY9xqpBF7tUbKFX7O40oU0bUppj5TROZXrRvw8Ckot9giHVCXvOUWZ2zHEjRFwrPQHR1P+2pCZTyIVkVJEbqM5hfjjvf17v8L4NqqI9te8xShebFAQPliPPfgQWs0y49NHHqL3iAcB3pw8XHEJhbx9REWu3jjtpXSgKbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4010.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(451199015)(8936002)(2906002)(316002)(5660300002)(8676002)(4326008)(66556008)(66946007)(41300700001)(36756003)(66476007)(52116002)(186003)(6506007)(1076003)(478600001)(6486002)(6512007)(9686003)(26005)(2616005)(38100700002)(86362001)(83380400001)(38350700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o8hTfMCpdLn+8VJekt2tCHbpOcCDwW20lXO2XFm+EkRESg0Fnaf9bzfb5WEv?=
 =?us-ascii?Q?IiQeIg/JMp3Qj42Db3pL3Mv7+GoABVAdMyssc5dM511JwN4fo4FzsY4Z+scZ?=
 =?us-ascii?Q?PaNK+KW+UA5zkROAfPy0GAzK+BhHHBVFGbHjdtOvANd/REQj2Yfim7DzLmUT?=
 =?us-ascii?Q?tfxI8M12rH9AGyqB9WppglyCmrCsB1Yv9/hFe4AbAxfHN3OwHPfo2t+aFxUK?=
 =?us-ascii?Q?9k46ulLuVR1PCFgMUeVDaqTPgGFU8rv8GMV9UKUsN8HkrYe6jbN6xvfhNt94?=
 =?us-ascii?Q?mgj94WEsVzCdAxOR7+uszugcgZTAr1VBenuaVK6lXllO1l2eCuq44+MOOj9/?=
 =?us-ascii?Q?TiJoV39W7t7hUAefNKM889ZZf6TJM0xkHBk4p3OdDAXHVG0TYeOJlDAx++W/?=
 =?us-ascii?Q?ohZ0wjoerzlSb/TVD3t86ZNS8PHfp2gNQ5NNmPXBVEFlNdyE8rt6C9+S6yFY?=
 =?us-ascii?Q?KQL2pWes89m+HK7SnjbT7g9tCPo6JngcMJFpnfaVK5l8UrHOQrw2kI3FqCZK?=
 =?us-ascii?Q?+tJInqkoR1axs3Am1Cw9rcxMqDC0DT7LQ/aVQ1gZcuJVOkecDc2b2aJ8oKe3?=
 =?us-ascii?Q?iB0DtmELg1ll3yZLJbAYed2MPgbTihCBS2NS0iW36ezBgFS0ImYJWs7BGqKg?=
 =?us-ascii?Q?QW4mAQlBaOcoiO3qj832OP437O/UpRdDNkuvN1f9k58LvAoE/Br5w1xZUfm7?=
 =?us-ascii?Q?bDG/YbkQSui7cj2FRszCrfMptV3zDyeUgFGByC0QYz5LlBvzlBNAU02vSpe4?=
 =?us-ascii?Q?GikoJv4M91WEZtpm6qRQLuDUnRC5H+L5BbyHO4Ov+EiiiWew0CU+GYycPp9G?=
 =?us-ascii?Q?Y9rtHBqiBnv8nV6svwXsjUmEVdz79QBn8e0oYaiokX1TDernMSNALGbjBDrc?=
 =?us-ascii?Q?jirhziEhcVxMpn2bNva0tp7oN0YMjc6Cb3m5tqw2VvqHxvHbE2c/HJ270V4J?=
 =?us-ascii?Q?Lz799a9PnT+IIp0HmMHLYNa62CHfndt4Q4UcDuOgbTHq2T7GAsUil0Txdzwa?=
 =?us-ascii?Q?D59QJKTKn+J01rugXVo/uq5qsbkg5kJssIeb6FSlz8QcHHJ9frBXlmQExZ3m?=
 =?us-ascii?Q?NP9UocOafdt2iqprzh8Cg9wc4K3REbwREKmi5v0O8FfktfcLPEAErkpXxzVh?=
 =?us-ascii?Q?l8TkBpKDfPa3oTebQpcTjb/mSIke/8Y55IanoSPwSH0xswtk5+fn9RT0KzwZ?=
 =?us-ascii?Q?WU7fhtzYnL8X0zn0zjbMx6cbNUACab0KLlRk8hQ7BoSTu1oWsjEgdjeQb8Hf?=
 =?us-ascii?Q?z3yYWEsZ9MIwgcG5lbJpVUqJUpSF3GPAIeQLKSNEJIqA2bgDHbiks3lq2o0V?=
 =?us-ascii?Q?WX2tnzfzT3YIeqGy0dhNU41iA8stDCdEe+1ESaCBhEOhAwnEwSPvD2LZqeel?=
 =?us-ascii?Q?ufBsp1RGvbEYYotOIFo+WEH0ExD9M5h08j2nCrrBytN2qvyb6JUvGuU0hMZ1?=
 =?us-ascii?Q?oJUuxWabZNkxYfK2NO2RFUis1Z4Q6osn66t4ZWeDB3W4wBW1yTMhawywVFbp?=
 =?us-ascii?Q?WxgkZHorsbVgYW2D0d/JhjJjE3d+/QcL5vrAeewm0yqqk7dhLQE7ySGRoS+i?=
 =?us-ascii?Q?uSAsejglZo7FkV8DvKZdfCJ2FkMhUqHmUrOQtoXs?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c528a398-280a-4319-2a29-08dadcee8094
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4010.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 09:43:34.7304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DVaus62MIlk1v+t9vFKKOtBOPc1GHn+1P5cvQEx0CRNp2W/K71bZJQ4k0oyN9kURrH18pySsA9TfG9adbsEWSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8570
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

When do suspend/resume, meet the following warning message:
[   30.028336] flexcan 425b0000.can: Unbalanced pm_runtime_enable!

Balance the pm_runtime_force_suspend() and pm_runtime_force_resume().

Fixes: 8cb53b485f18 ("can: flexcan: add auto stop mode for IMX93 to support wakeup")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
---
 drivers/net/can/flexcan/flexcan-core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/flexcan/flexcan-core.c b/drivers/net/can/flexcan/flexcan-core.c
index 0aeff34e5ae1..6d638c93977b 100644
--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -2349,9 +2349,15 @@ static int __maybe_unused flexcan_noirq_resume(struct device *device)
 	if (netif_running(dev)) {
 		int err;
 
-		err = pm_runtime_force_resume(device);
-		if (err)
-			return err;
+		/* For the wakeup in auto stop mode, no need to gate on the
+		 * clock here, hardware will do this automatically.
+		 */
+		if (!(device_may_wakeup(device) &&
+		      priv->devtype_data.quirks & FLEXCAN_QUIRK_AUTO_STOP_MODE)) {
+			err = pm_runtime_force_resume(device);
+			if (err)
+				return err;
+		}
 
 		if (device_may_wakeup(device))
 			flexcan_enable_wakeup_irq(priv, false);
-- 
2.34.1

