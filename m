Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5636D510923
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 21:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354226AbiDZTg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 15:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344071AbiDZTg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 15:36:27 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2102.outbound.protection.outlook.com [40.107.113.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EE61A0B3C;
        Tue, 26 Apr 2022 12:33:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=goNG3eWdCP38x9xWREnafnWXhVkdhTc7oM2cvB7VvJksQ/Vp/0iulUYGfSte8SJX+R4qgwe9XAgqoNLsmEgj7gmy7/kDFJLGwbBhgMsVLD9YuVuLxFG2LKpxnRKgGVGSm2BAQq/i6cHOTqlZA7LRf/cxm3yFNjfrG4uXBY045YW+hcXCjWOe8DHT1OR/t6OQzIX6YFgMFtOUG/7E4XUOQ6Q2kvu3HgXZLyvP/7TibagPkSDRe8pyeg8QSgpcjW3D57y7s4Nfb8tmUP31HZvpjXK7vEbmz2uP8wbBziZKga9dFRF3gK8BjVp3VetTt3ubFRz5UoqH4MBYc5qTGBAwbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TvBaYEsh8ZhxyX3AhrmYg1CxLrZsnAhbVJx9PzFKR48=;
 b=kLywC2Wy/qjPw/uAFJ1NOrZkLvHj7SQyjYALMSgK7MYw5c4VpgtoaAg4ddf/Sfm3tYu/UYq3WMUxwU8TUUdunkLQokt5Vogtd+im/f7uBdKGUjkE8/N2lbbwXHXY4I5XqSjhtnoAYqmFyl+gH85sZSRpabmrNnBV3+dtiuv/B3cSLmIWOCX5AvTCpWcxqBx4fIxX8ENXU01HMORFwjs+8uMzySLoHJ8OfkPy25tz8rJ4Wb8IeE3aBZNFTsp0fTSe/lpDDNdFkJaHz8121wkfJB0ftT49GvHch8Luy+U12npp6PRsVMM1EqbRsmyvaRJb1nKFOuAl+jyCdsnNCgNf0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TvBaYEsh8ZhxyX3AhrmYg1CxLrZsnAhbVJx9PzFKR48=;
 b=ArrMlyik5JYh6nUjmaKZLUQe/GS7DAzvnqk4XH2vxaeuyEI7dsCIX2f50sePWeS6s324QF1Q54yldas59wAhX28qMKkyzdIwFREnT4bsdYTFWLDmj5P0DO3xX2wDgBGKcunu9IlVBk57g9T731izSp8Gg8kl+o7wn/JHDiCQ5jg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by TYAPR01MB6475.jpnprd01.prod.outlook.com (2603:1096:400:a2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Tue, 26 Apr
 2022 19:33:17 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663%8]) with mapi id 15.20.5186.023; Tue, 26 Apr 2022
 19:33:17 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     richardcochran@gmail.com, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net 2/2] ptp: ptp_clockmatrix: return -EBUSY if phase pull-in is in progress
Date:   Tue, 26 Apr 2022 15:32:54 -0400
Message-Id: <1651001574-32457-2-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1651001574-32457-1-git-send-email-min.li.xe@renesas.com>
References: <1651001574-32457-1-git-send-email-min.li.xe@renesas.com>
Content-Type: text/plain
X-ClientProxiedBy: BN8PR04CA0044.namprd04.prod.outlook.com
 (2603:10b6:408:d4::18) To OS3PR01MB6593.jpnprd01.prod.outlook.com
 (2603:1096:604:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf6d953c-3a44-49d7-043c-08da27bb9cb0
X-MS-TrafficTypeDiagnostic: TYAPR01MB6475:EE_
X-Microsoft-Antispam-PRVS: <TYAPR01MB6475D7E11E3C67893E95FCEBBAFB9@TYAPR01MB6475.jpnprd01.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T3aBPA80m1NuQYbkjWFrFK8JF1sHI4EB7baqCE0UiGGxlqYTZ83BCbSfwU8voqgaLASGr0rJIJeoWv2/kZyzrjEJzHxO4vPuL1ViVdFtLpAnFVy126n8nOhWfRQPdrwWBCnT2ZtWN4TtwWhjwNYdTb2jJvmQ3n7GoOFSpvGnFj6RH/kTM4+8RLVIBjtFhdQgpkVU7NPDjGDigNBWOvAj8o35n4u4kfBZlL68JHf3ay5WgTd+7mMfAP1ktFvv6vHS18hzWzt4D5mU6apZHtny/FQ4EGFneZp27xttiHQ+KpBmGyz8tpxanhwKqt7bgiusVh/D9AfJR8fIOxFUNZyknPIs1pb5faafsWHDX6xUCQvvWpz7XtIdkL+z62flPpWgb/4+suXphCyW5+B+/JXs+oy8qAjby1vBjqMlMeBPJb9M/nEFlPRjcWM6p9JCzWpgrat/JpkkKiBjbvIOcPrPN76SxQv94X2zNV7jKz0TElt/mncn74RUBvJ+9TrwcXNWUa3mdbvhlsx5jFBE4He/nzzK7wRjNI8KnjfN6rIkpJXWtC5kmPkkWPtaUqWacXLJaTPfkuIYCHdz8R1T7ZU/giFN/noiaHG2IGRMyt0KBS/ApIkJheg1yplMV7N4/8QSXlaaBmN9DUv0Uauv+oiMwlHk/ERakzDBVbgZ/7Zrzck+fU4eXPA5OBQHT2EmkumBwY9m+9gu7uSYdSIsdmYKoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(8936002)(36756003)(83380400001)(5660300002)(26005)(4326008)(66476007)(186003)(8676002)(2906002)(107886003)(2616005)(38350700002)(52116002)(86362001)(508600001)(38100700002)(6486002)(316002)(66556008)(66946007)(6666004)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vi14cMr3BzCoyndOahln+9w9Gq9NDiLzLaR+JlVkEH4vSmEXyYE99KHjvlqm?=
 =?us-ascii?Q?2N6vZtMh2rxgZzGQlK9yDx29re5z4KabLMk4ESEiyvsfPkv2XObTUnTQAAXJ?=
 =?us-ascii?Q?wzfWcOBTy3zqVDcw4bymobi60+y7l6LTzSlcEK+j19zD7k/p9jVcVfh1KIJI?=
 =?us-ascii?Q?5YfsBHjhf6aEZmRa3L5KNi2wNb4P8+XHih1lyvjqVHVWMg+Y5bHPSPgoq1OI?=
 =?us-ascii?Q?XZ5AZg3hggySX2XNDo23iTWny5qNNCT0iR+SP+axjQDc+P/EAkdMLUeQOhrK?=
 =?us-ascii?Q?C9SsPJOfShOyNbObhuV1dWMktKAuhdxb9q2Sul9DAt84bJu3hzGPUCMRCRG8?=
 =?us-ascii?Q?3ABb7uZCIvnWiQHPU4OPGtBzGhwGz3tywa5DZr/D9y/6FHk83vDPrWjRDyFq?=
 =?us-ascii?Q?iWY7w7XFjBmGgryU9uvSwbL0MU0Tk/p8O1AKqfPfgtjc9jig+/MFjm2DKcQ7?=
 =?us-ascii?Q?6wl+f5KjTFgCxVY6QqVpk922GpqcYp1id+PsHFBpxG654YBXA5RUsqJqsDiu?=
 =?us-ascii?Q?/GjRZ8lv66RDBOQ2FlYKfXE6mQQxOyZVv2x7Dt+dMCthmPqsEpQt9gusJ1a+?=
 =?us-ascii?Q?xEHjIt1AtPgTiMbxVK4WLY89s7IVLn4PL5b2xV4PXJm3wx1Y3xMlTZEcNNnV?=
 =?us-ascii?Q?YCePCG05/eGQn6SsTjeEmsfTW3evntIOK+KRcuCn3Qq7UOroIkImS7uTbwmi?=
 =?us-ascii?Q?XXLacDp5Sak/5eDLs5PZ1RsEoHJ7LJG2Vbzpy4yquZxaAO7GmTABqLQidY4Z?=
 =?us-ascii?Q?Swe3KScVPdDnm14XmHnlUFll3naao4WrhVdCht4jkB3myW4yKA4yBJuUCZaT?=
 =?us-ascii?Q?bn9hXdumOmQhCUIsvIapLBppijTvUT5SuLQbGJMwSA3kb0MV6M49IBPsDld1?=
 =?us-ascii?Q?44MesMsw5kv2mPPi/UbVi1PPkp199aDQc2jal+O6GS/ATjMAoWm+llx7gtXv?=
 =?us-ascii?Q?5bQXE1qoB2WWNdMPoa4jXr/BcVVi+Jsr98tsxJp2UDN0eKdjTTPb23R7b+b+?=
 =?us-ascii?Q?XDjEvtG2/TAVcEDhghBU7xoJfYhlvwzOq0I0F/UV0UhGWZTMxbpE7VSxayvV?=
 =?us-ascii?Q?cgWV+JGpzWMu7wMkA0MG7RAf7vo9ZpbpchG37AQlaAJCQkaUAz3AxxEUn8VE?=
 =?us-ascii?Q?o5IAFvDpGr8zyTdq+o3UqKyV1yaSVLSCwZqyKv3YkT6xXHOvg/9u2nMTIr6Y?=
 =?us-ascii?Q?SiN+qMR0DRBZRBLrO9gazyr3Dx4u+Ce5XnBUvIIan05IRfwfvdoR2BT7W3XY?=
 =?us-ascii?Q?RmclORAvU+E9vjWCBvg7WwIxnoghiW2lxsbP7R4Rmwo4H2WjakLk8vrfjuzT?=
 =?us-ascii?Q?Y57EQaDkDx47yuw1GBed3csTUlk0O21BeAGUjN2jtBJR9ZQHEyRAIglNAXCk?=
 =?us-ascii?Q?F+2rJ5x2GcQr9NaxsMHoCQSZU1bTnQ089UhTQUB2OMQNnAXH2YIOisFkx2o1?=
 =?us-ascii?Q?2asQsgWbem2FDPPqhrVVnc73/y1YyGX5n3fdM8Qzncu7uvBIp8K2X/eWsW5j?=
 =?us-ascii?Q?q3KbowZqfztCC2/s/cU8S/UgI3j8D79VOekNyx2qKJXbytDa98jYXSF7Jsjg?=
 =?us-ascii?Q?zUhBnC0oIqz27A9WcVInlK2C36k5l7EM5IPeWNje1J5NMGvEKyDZkKPw/ebL?=
 =?us-ascii?Q?GJ8QRpG7WZ1i3kQcw5nyNf+gIpDNt9jF/1ryQptn0RWksxySSoQXdBQnzC7L?=
 =?us-ascii?Q?vTkDlhwR3Lp1ghNXNms/vl68gxE6V506wrYYg0UpkU6S4YIHFWtuJuwy5Nag?=
 =?us-ascii?Q?UtZjcOxMVx1LHAfhLY8KIfcTvljlPbk=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf6d953c-3a44-49d7-043c-08da27bb9cb0
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 19:33:16.9995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vtlu/xuETKlNImON371VpXEtK04JRF0Z/jxbOztzh/oqZpjV5umAiOWzQVtXrUnVCzogm+JRnDcBOlmf1DjNhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB6475
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also removes PEROUT_ENABLE_OUTPUT_MASK

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 32 ++------------------------------
 drivers/ptp/ptp_clockmatrix.h |  2 --
 2 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 0e8e698..7f324fd 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -1363,43 +1363,15 @@ static int idtcm_output_enable(struct idtcm_channel *channel,
 	return idtcm_write(idtcm, (u16)base, OUT_CTRL_1, &val, sizeof(val));
 }
 
-static int idtcm_output_mask_enable(struct idtcm_channel *channel,
-				    bool enable)
-{
-	u16 mask;
-	int err;
-	u8 outn;
-
-	mask = channel->output_mask;
-	outn = 0;
-
-	while (mask) {
-		if (mask & 0x1) {
-			err = idtcm_output_enable(channel, enable, outn);
-			if (err)
-				return err;
-		}
-
-		mask >>= 0x1;
-		outn++;
-	}
-
-	return 0;
-}
-
 static int idtcm_perout_enable(struct idtcm_channel *channel,
 			       struct ptp_perout_request *perout,
 			       bool enable)
 {
 	struct idtcm *idtcm = channel->idtcm;
-	unsigned int flags = perout->flags;
 	struct timespec64 ts = {0, 0};
 	int err;
 
-	if (flags == PEROUT_ENABLE_OUTPUT_MASK)
-		err = idtcm_output_mask_enable(channel, enable);
-	else
-		err = idtcm_output_enable(channel, enable, perout->index);
+	err = idtcm_output_enable(channel, enable, perout->index);
 
 	if (err) {
 		dev_err(idtcm->dev, "Unable to set output enable");
@@ -1903,7 +1875,7 @@ static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	int err;
 
 	if (channel->phase_pull_in == true)
-		return 0;
+		return -EBUSY;
 
 	mutex_lock(idtcm->lock);
 
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index 4379650..bf1e49409 100644
--- a/drivers/ptp/ptp_clockmatrix.h
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -54,8 +54,6 @@
 #define LOCK_TIMEOUT_MS			(2000)
 #define LOCK_POLL_INTERVAL_MS		(10)
 
-#define PEROUT_ENABLE_OUTPUT_MASK	(0xdeadbeef)
-
 #define IDTCM_MAX_WRITE_COUNT		(512)
 
 #define PHASE_PULL_IN_MAX_PPB		(144000)
-- 
2.7.4

