Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DE056BD8A
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 18:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238777AbiGHPO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 11:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235427AbiGHPO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 11:14:26 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2058.outbound.protection.outlook.com [40.92.98.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B634230F43
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 08:14:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ay4+J4Ix+Hq3Qn0oQhlk5lU8S2QS8zhJ0M+jy9Fn+5wfNEj0TKr6I/AitW6eGACUBX8cq16KQHAZ5hJNHwIrdvZ5w2dQ/ybJpnpeTbwHklRXYM5da9WtGiQcmYjF3kApNSObWXhHYw3WUHtn7uUCyCpD78/egwx7p0imw6uIo1yGE0LuHtOeZ5sBpI9rSYhWebLtP3tcJYuyKK+1UhC7+/mXF8TBLzN2BRhQmyhk3uaKa9RRtrC7Dy1+xn9Hxq4G8VtKCrMF/jT64oGOAiMBYDCX1ytibftALvK5zy4E8NupVzDCGLRk2KF4nzEX3JEMEn1mOGeatUoR14za1DRVcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4cWT1EpbkxoIAMvHnYXkszgq4P7lE+3hRAVfG3CQrgA=;
 b=EHi6WhRnm6tqmBo4sXBmmQbIlNUl+aVoIp/9M12SIkJqclgu4gwTM59B0BVEA+64+pPoEryOKqOF9SWw4n0ia9cSCZqH/90lEsEBNMIooSTMXC+MBzACv9e2o5CJ8Rh+gTd5FbP5mtyaIvhHvoTHt21XYMn4veI3Qp+Lh01LJkXMDbOQzx8mCjA+4F72x+6cNiw8+9KNIL8YZoxKd7ceH5ZQ/AIcuZ4hKr6eDvNs4iPr7jMOx1GKFntExVE6z8TheWfx0S9crXQ/iItNykiX1i28QfzPkhAl+K6StEcy6lwCwpet8P30AsoiivJtUXNRImoCq2jVb1PwkcvJjRgQag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4cWT1EpbkxoIAMvHnYXkszgq4P7lE+3hRAVfG3CQrgA=;
 b=ARBBoDPUjHw3x/FpJSR58et6ZJ6aSF5eTu4rXhsSU00SCgQnWDGjug3MgUyxmbvIjww7+d9schTAF0kBLfMcrEDjdYWfSTD72un78v/MokEHAOnfGyux+wuYjkrW0Nwf6DobS49KHmkURc9Wcjgajn5XU4UHrxz9lwe3Kz+U+oLHitqz6LnCk0p9vXc4CtWc65CiGDNa2CrY0XuKTR8OMNedDKL+YFib7f+uHqHDHsUl/Mfl0TB+S/yVtPPIZGADcrsDetw1sURv+wo+MhHkpkaWKCHIvM3lkYux4pCcWKmHpvJWbLsIs1sX0gbdXaIIgbEjfXnEXA41LVG3+R8oBA==
Received: from OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:11a::9)
 by OS0P286MB0644.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:cf::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Fri, 8 Jul
 2022 15:14:22 +0000
Received: from OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM
 ([fe80::79c7:e656:3e13:428f]) by OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM
 ([fe80::79c7:e656:3e13:428f%9]) with mapi id 15.20.5417.020; Fri, 8 Jul 2022
 15:14:22 +0000
From:   gfree.wind@outlook.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     gfree.wind@outlook.com, Gao Feng <gfree.wind@gmail.com>
Subject: [PATCH net] pktgen: Fix the inaccurate bps calculation
Date:   Fri,  8 Jul 2022 23:14:01 +0800
Message-ID: <OSZP286MB14047FAFB44F13D76137DFFA95829@OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [uRQ5tcZcuthCedAm5xT/6RqsFC78u4vG]
X-ClientProxiedBy: SG2PR06CA0249.apcprd06.prod.outlook.com
 (2603:1096:4:ac::33) To OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:11a::9)
X-Microsoft-Original-Message-ID: <20220708151401.3518-1-gfree.wind@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c3e5200-6238-4239-b952-08da60f4895b
X-MS-Exchange-SLBlob-MailProps: CjO2us0gQYBUny+C40yt4siy/VhkNGNCppB3AnXKl+VM0cJ5MHsgdu36NijncRtCBVM6UxNwVn3vmDPI+NStWFjKoftaQmoDc6YvOiyGAMGxH10pLxpm6HxFdjuPF5rYQwDW8O9kKgFnmHZf7yrEAMVuhr7a8zo+1PwTpie+drIR24uLLxXykHboX+Htkx3qSyFFIBuiAgQJ7gE9rzO/CwIHwnKXpNEdnGtLWRnciMGZhPi3HxT+ANpJ2Q5Swrb2U/fltC9NtYxZFXaG1AqGNs31D0rdTHyXhs8SgyF7vN72N40ytlPdehvawHdK6ed01rVnfadS2uW7SDcBiC+eow2HyUWjC/6BqwxXDZioIV4CMFiUyKg24q1MoKKxRNqLRR5qCpRPVgRT6L9pLH7gwvjNJf1BD6EOWfLttiUd8nO1TjMitJcW2YL3hFioqs0tIagNEuasUJASW+p5lLJVV2ECJl0izeAF8w4rxFBvbWEXnJ4h1moeGoHnV5Cepay4WeV4SiM/vc3jd61g/0fVOxLZdnhPyyCBtHi9BPjNf3CeP+2LO3w1J/jmi5bZcSqIrAgYpgfwHVx5hmBVwcClM5Ue0cm657DjzWpYWJqXiGvfw3wG9ZL0uJxcZejq3iUMOm1zJRohzdAYnvd0Rsd1G6c3j1BzRsDsmhQBASGlp2lQrSaCe3AAXFJ0nZub0Ueh
X-MS-TrafficTypeDiagnostic: OS0P286MB0644:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MwbucXSETwssrN+vJ5tq5oCG8zuYgOSzGQZwPgwqI76gVG+olmYeeIHndeSnIFbIq6u10ouOLwX0WozSB8SDMZAbC7nuc/xI3+vKKoIOiUAIxEM7BYF6vgKv1L3FHlvg37kfqsiWdmHQoztwwK8PwwgyyykGS6VT4ffYCrRGRaF7rDJFrB/Nmdcla1foCKhlrC7p3rn6fFHMcAjP4iYQqRWwOsC3xBvk0ex2p246mmc9pzLHGfimZlqVdMFt3H7Z7lbwVEznNkZX5nqBZPytFrus2yWm1WRCHhnLVeW522xLyaXW8rApyYVsUYOsUdPMAHMn0TuFb12jboYEI47OcYRwKwkwe/hMnNZPjCF2M9g4vgNZbeh952VCPwxBnFE4HJkERCn5zgr9+IMg1s+s151mYMWBxmW/z83qZpFBDGGlyJ/XGfNiOOL1Hj3P/ciH9tIJ6Sxw8QobXCRByVA5l2ZKbN1YmvX8c4arf1UfA6HER5qxxCINII7UrgfnUmew9jyBBrdiJXz2vQ5ovP6dVJEkhMSKG5Jn7tIcY+cLDyp6gb1267fnkoP5lQrDb9vSnNqRwR0lp16QPo9mJrttOnQD0/PtPMWnB3eEaUlku2Dzj2BfRNqHttL4f1ymvIuolN1zoptXmFVbCYiM1Ks1M1wb8dmQlt94p4XiuUsW9whzZnuWmqKXYNL58Kwv3OHeGYQDYrFQsKgV/UduG7oeWw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U8AVNfzy+OGI6EP7Lo96LFA+flWnBgnzR2iiKuC8/0F+IxXV08kZPJaaqUyQ?=
 =?us-ascii?Q?RZt/yhYdaQ/A7eIYnRz+Y6LLN0tCdIJ/eTh76y5CdJZFEWo7VtdaeRrcssXT?=
 =?us-ascii?Q?C2xy8ju6Zkq+aHc+pikH5MAD2bBug9VK2zLWq043dWeVGmisD9jC3YXH1kkp?=
 =?us-ascii?Q?dO65v4ZfxY5ltzuabrOix9SBHxOSfADBrGlaAICZJTiAxgA5sloY0y47Pp4k?=
 =?us-ascii?Q?TMhpueB6hT0a9xcJN6Ht4dTnjWk6UIpaRCmB1v14S7JmB1+utmdkZ7KlJ6TA?=
 =?us-ascii?Q?D3LBmrH0Wa8riXAOryrLl7UHPfd3UvHov4KV4K+uHufE5nFC3stjB7Z8Fxoa?=
 =?us-ascii?Q?VRXjNElqmqO6JMHc2qYDFUE/c/sErYr6c/fF2BqndCleynRas9pAqnKuB/XX?=
 =?us-ascii?Q?e7uJEuCkFQYaO7yNlcXcJZTzcNd9EzbXn+4fismr7GEjYhKhwIokFz7GGuM6?=
 =?us-ascii?Q?Jx93Pnl9JLwoUjkndolaHCra6kNNyNNjfN4wzUvwjx0Rmzfud6QlA5dVERFa?=
 =?us-ascii?Q?dVVyQ6Qiessfl4/H3WTs4RRExvhmP6AAJntYiOUPVu+WFJ9zXFoZsKU3lblw?=
 =?us-ascii?Q?01rOoQ2lvdHwz5lAdfpUTVAApYEzMkz6AFA9Ik4aea5TyQ2S6/N2lo/VY4N2?=
 =?us-ascii?Q?giG+2j/bmL9O7ZbnhELQrATYzzCVjy9D5/OF95mGoZgG6ATyRBOh/uocRo8B?=
 =?us-ascii?Q?BYPmB4cKasXMNTNf+Woxlnydo9NprfGtajoagN+Uh6qJHB7q0oxZrTNDP+JH?=
 =?us-ascii?Q?UOKCKtAtsF4xBi8tLV6azpWtJTR8dTFxWJJc5BD2gKDgcRaVq+rsNfxyJl8r?=
 =?us-ascii?Q?aXI+7HcM05W1VHde6QT6s0jP+pTLGVvbZXV3TrNNByblM37nSwTG4WZzd3q7?=
 =?us-ascii?Q?BdlZISucP+0yXqiyA2gM+n2yCI0UguoKwYfm6wfQTmTYql8Ov38JRxaLcA4G?=
 =?us-ascii?Q?mSSwjqSYU86gsANkfSbebM4pFPRxLSTubCkpYw7OpK2sTEwaU0PILkvP1qD2?=
 =?us-ascii?Q?pO5E8XOP23h/KnkEo9lota/LZSuDZbIsLmPtgBOdFpTSNqlida6OdKM6FaMK?=
 =?us-ascii?Q?kTj8ur4sS0RsVgD3NgH5mHiDLTNf5bFMRSlOMO5ipBOqRg0Nl8mdFhjaYvdr?=
 =?us-ascii?Q?UaBfNFTOdOCPShNcYLAwqWpBcalUijiun2yrMF2bSAA757DmeWFzO/bFIhEl?=
 =?us-ascii?Q?MFjwNvApF7Z23N8eEU0QiaMs52sVqZOrmBD9pP3GzMMOk7YZD+sf8k8FON4D?=
 =?us-ascii?Q?q1QcyWZ/cnXIfIOZagCvuuyCnqAQ2WLhvVHAIIBeyQ=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c3e5200-6238-4239-b952-08da60f4895b
X-MS-Exchange-CrossTenant-AuthSource: OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 15:14:22.2247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0P286MB0644
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gao Feng <gfree.wind@gmail.com>

The prior codes use 1000000 as divisor to convert to the Mbps. But it isn't
accurate, because the NIC uses 1024*1024 from bps to Mbps. The result of
the codes is 1.05 times as the real value, even it may cause the result is
more than the nic's physical rate.

Signed-off-by: Gao Feng <gfree.wind@gmail.com>
---
 net/core/pktgen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 84b62cd7bc57..e5cd3da63035 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3305,7 +3305,7 @@ static void show_results(struct pktgen_dev *pkt_dev, int nr_frags)
 	}
 
 	mbps = bps;
-	do_div(mbps, 1000000);
+	do_div(mbps, 1024 * 1024);
 	p += sprintf(p, "  %llupps %lluMb/sec (%llubps) errors: %llu",
 		     (unsigned long long)pps,
 		     (unsigned long long)mbps,
-- 
2.20.1

