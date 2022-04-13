Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16FE04FF4CD
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiDMKh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234979AbiDMKhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:37:22 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10066.outbound.protection.outlook.com [40.107.1.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2133D5716B;
        Wed, 13 Apr 2022 03:35:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YRnzYPvFh2htr8SBzMv3kb1Ni9POO8ZM0WaZadpwHniJ8oXQJaNhoJRvfLZTs0HvNVGpO+Y+YZjS40oJSysO19qHBZvcWthRfPMEbwrONOxotwq04t9XtJCDoFzPq6mGV6TS9xGJ781UM6HfVDzhI5YX5z4rViym9yqOQrh8OLzzuWySsqqKPrerZ1dXFZvR34UzIbeIbe4VHCEeWEPL39a/udDA6RM9PuDZc1Rw6lpZ9ESBufLRn+ZFlKeiYz3Uszq54bVfPUK7R9KhZqrekQJj/v6bRyu1Cj6vwx03nPHoEvbX2bbPeqXIrUu41AV3HWkHsxj8sHzV8JRco13Kfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M2FvJGVbyiZM+vJQ/yWemRlagzN2oKlpzw3/MXUr23A=;
 b=M+irO2pwRZ5jI6L/OqCW0wxYE9ppOmQTAeKgy758aA4vt5WRcLcw4W1mDADSIhIP2bM+mquMkkFkT/00eGa1UwJ6FVVG6FeLSQVvbbzOF6+CKtnb4sfX16/WRcJF41R6Df8ZnRc3TdnS9C9ENISKBmGR68s46wm4wD+tho39X2FvRkg5B18oyRvgjriT9ejEH/c2PyrmqA5L9FTVvIa9syWwgOHn7QPxfq/LP+fnAkU1xukAzXDxGBvy7GZG9irWGvZvRMJpCH6TXcTLYQLkD4XfeJP+lfHA6Jkssi70u+qiHqkwKVnH2KYzsGHk78hc0vQT0mVVeXTxA9mSOdK+EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M2FvJGVbyiZM+vJQ/yWemRlagzN2oKlpzw3/MXUr23A=;
 b=Eq0eM7wkgV3YXYPCx5CfAnZyiSvQRlYyMgJvTLYNTFdn0duHR5eXM/GIkfM7M5RCQ2/KswrEYwWj3tmVyptdvT3+REYjIP/elma8RhonzbOm3J8BmkFr0q+/pa2Pr9+cXEGLyCqBUY2JlfMiWdAaiqz3B3qYS1bMmhuIt2yy6tg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM0PR04MB4082.eurprd04.prod.outlook.com (2603:10a6:208:59::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 13 Apr
 2022 10:34:54 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 10:34:54 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6 12/13] dt-bindings: usb: ci-hdrc-usb2: Add i.MX8DXL compatible string
Date:   Wed, 13 Apr 2022 13:33:55 +0300
Message-Id: <20220413103356.3433637-13-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220413103356.3433637-1-abel.vesa@nxp.com>
References: <20220413103356.3433637-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR04CA0047.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::24) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76c61ae0-4595-42fc-a9de-08da1d393f49
X-MS-TrafficTypeDiagnostic: AM0PR04MB4082:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB408298C2AAADA5FED52CCD09F6EC9@AM0PR04MB4082.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cJWeD4zbJeQL/qDdxI5ltcTCNqGsOymU+kEhSHg6/ngv0zlQlnVq7RSoiCRiJHS03LrXps5juGGYSmzeSB+SnRvrlPzdNmol2DK6hclM5CHk/3zueCqSNGhpPYWLKffQWthBYMCEnJu4EZyKhsBZPjQnP9915nWNOL8JlR9wqUHwbFEpA8XIjs9YYbkssizv04fhClKcdYRmRdoAWpJ+mua2hzenNMFzMaJMpc/wzb26KGw/6plAEsiVzt6tzTry0Jbh+NPWOoTl3Gmfob2dB/FtdtaWZAAiY62kiHQB9Svz76KlGDsyNvd8zy820x6fbOXudGUrIgXy5qPjn0bWYjIqt0DeAxaP4fbpB1g8UJgESCq9gnNGdbBjzJZ9WM0LXm+PqF9NF62FtNGA2MiXTDcU1z5UXdj2Y4pMMvrzQfb9+6ApQidyntsDj1KlPrES0aW88jdbfa6yhY9BGrhCbd2q+IBsMD4XcqouSVwPip+kKcTOsvLx/4RHiT49LLVxosh1oTcU5+0JOc+lyQnkEE5qHyRsqxEXNB9R4LvXHatz/mmkjbO1jE8F7i7TuALNblC2wF1f3+j+ynMO6tXCsVmhEm1XFHgZDDmhMYZaHxIVgQS8jKfx+3O+psfupNfucLqYioQC/7NPO3AwkFSw0JzugMSEKPJEO0dKRGCsR9b3n2ZiUwgpBNOUUOIgQNE3pl+PjIIdhNogfT/lTuWETw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(110136005)(38100700002)(54906003)(38350700002)(4326008)(1076003)(2616005)(2906002)(44832011)(186003)(4744005)(26005)(316002)(86362001)(66476007)(8676002)(66556008)(7416002)(52116002)(6506007)(8936002)(6512007)(36756003)(6486002)(5660300002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8hNwtjZS8F749FDB/nmKvM0TIt9dHwGYlqJXdKLuwNZbzZ/xU/Vh0WMpQzeY?=
 =?us-ascii?Q?EkBW9WqxvMmsRkBwAATiZX+bXx8I9pZkGhuPLFPRDtfpD5aaNeOamYH/OUZo?=
 =?us-ascii?Q?bsXucXdz2xAE7GDi7vcoHFFpFXZ0CHd3X/EKAkX+A6W0EVa9tXPdtltp/7kV?=
 =?us-ascii?Q?kM6KGtfpaQyHkjYxWI1KOHFNtkoDyDTS4bzMZlBSCQYhXgL4omDjUAgYOPNC?=
 =?us-ascii?Q?nPFzyMGphZJx8LIYQRvFlh22u4hPefkx6xrxONVlzJiNyNjHMobU7MURHfFA?=
 =?us-ascii?Q?yjuJI2akCNQALjtAcOdkq0SuxkSPhZoatpawIVOKz5mvLzwiTagAE3XN8y0j?=
 =?us-ascii?Q?TOzM5foU97PaTNryMB98hTLd/piZqa3mppL3iigSuuDcm7Uh/KXDMa/cd6dm?=
 =?us-ascii?Q?uhsUnuyvRTxVbmJ6SRmRtS0hNjBecYub7Odldt3+o25yOmWeALrXoZumNDsw?=
 =?us-ascii?Q?PMOueS4ym2L+8ZDCdyhuA2ZIPZUWPJVa4fggbt8r8ZCo1UNnvAtEOk+rFvak?=
 =?us-ascii?Q?0U9FxV4uAMIN/zkLryzIHNDOj9sFovzKTCnUZxyDPnc2mt4VPHpfOJWs9eYy?=
 =?us-ascii?Q?Z/4WHqJg+B9yWfBuUt8s59veFLwXAahzaYKt3AN+12tMSBdqrIoEflvI+YAR?=
 =?us-ascii?Q?CIjATMDRFHcFD8ww7bKs2QOEHEVdYr/b1MEfUQ3uhomSaxUQ5i4GjhVQeGi7?=
 =?us-ascii?Q?hUwZsJdqeommdnKQxuqdYY0RcoZAONscfoq10azjiDlAxo72gPACqBIsEP+8?=
 =?us-ascii?Q?ECCVcucQRu/IcKR5oAeBANVriDcZw9e+YadH1kZJuv9qgmDibPxHL2b+mAQb?=
 =?us-ascii?Q?ItKrMFxaAqe9SzYiivAthuBwSZAW3RBCwuk3Qh1nvqY/nXF2Lq8IiRvWJNNw?=
 =?us-ascii?Q?91kf5FCiJ8azAlLcBLmyJPfBfdK1cK+prH24+3JYDsAvT4T8g8gPN3Ep36MY?=
 =?us-ascii?Q?lUGNNxItOPP8NtZi2cRDysquiIOB+jFNuaSNdWAhJg+U8hUsE1VCWzrQZLRM?=
 =?us-ascii?Q?qvabIK7x82BhhW2IX8kM38N/ACL5b2Q/hXWfqEbKYNzthslIMBq7kRBlfxdT?=
 =?us-ascii?Q?HpWKtaCgEE44xURdvgPCmEsJvxWDl7xV0aBh2ET3+iI0nAdF2UOsUwA/26e4?=
 =?us-ascii?Q?82r+KXTJe1it5XM+rxaEaFyX32KleCdzWdHyGANKLWgla4C8cnBd0CtKMZLt?=
 =?us-ascii?Q?F8PXe8znkxyPMxEReR58HvxnEpV2esxiqZWesyOBUGgS338QlMNU+UvfpHs/?=
 =?us-ascii?Q?CANBbHW3PR5N5YpvBhNYzoKX0SVPKOevYthnV+Y7oJFa7YKijQU8VuiMnXdg?=
 =?us-ascii?Q?gnnfN5eZ7B0c9NeOi/pXnxdSBhz0ZaHMF1KcpRIV81rInlpSmN1hVEpEXQCD?=
 =?us-ascii?Q?xJrCw1p5l2NwmOk2JrpwudE3F02HydOMb8MapDcxKmlCBZNU9sc2eKTUDqLA?=
 =?us-ascii?Q?qIoe4U7vpgCSP7ZyzYx0KHCQ8WBNZCD72h0tkDgLPpGQECNwSDs8Fp0H7P3l?=
 =?us-ascii?Q?gVIHp0uu3g6yGS/YO1XQUAZzivd4DIVZUAh+W0DJlg0SFwMrF76qXpgk89Sn?=
 =?us-ascii?Q?4E6hnUqI/V8UkwcrKqpSougm9ZltcAkfLEjyblz3UEBD/YOmeiixjvMLOBmk?=
 =?us-ascii?Q?80G5tublKs3F4DVesAq0AvOdmMHw+N8zYvPFmiVkoYDf1km+p6hCpsGYXr/d?=
 =?us-ascii?Q?m4AgMLD0hKrXzJSoiJwdcbMbvtunh3XKtfiCWWMtjJuHLW6DT7CTVyrtOkWc?=
 =?us-ascii?Q?T7cUxhyFJQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c61ae0-4595-42fc-a9de-08da1d393f49
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 10:34:54.0198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: usiiNt4SYk+DA2XDgp/QMX154Cnv9eLE60U925eCiHGAf5ZiwJeCVq1pk1gZ2s/bJOT4g/qq5+rZ73pVKsyJ+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4082
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add i.MX8DXL compatible string to ci-hdrc-usb2 bindings
documentation.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
index a5c5db6a0b2d..c650efc47e92 100644
--- a/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
+++ b/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
@@ -11,6 +11,7 @@ Required properties:
 	"fsl,imx6ul-usb"
 	"fsl,imx7d-usb"
 	"fsl,imx7ulp-usb"
+	"fsl,imx8dxl-usb"
 	"lsi,zevio-usb"
 	"qcom,ci-hdrc"
 	"chipidea,usb2"
-- 
2.34.1

