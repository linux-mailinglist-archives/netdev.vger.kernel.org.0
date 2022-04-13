Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247CF4FF4C4
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbiDMKh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbiDMKhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:37:24 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60087.outbound.protection.outlook.com [40.107.6.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8E5BCAC;
        Wed, 13 Apr 2022 03:35:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XjZIQAoP0de8Y939zjYCqFDXr327HtDnVIKfk09sH2I2mmxK73msLG/W4p0HCTEvmImJq/lfJgu4l06S4dioHw1PSb7qM4b8BaxP37eUiz9xIBa2qjh5I46J2HzoDlPXQTPdLvEVWhsRa2mj7PSeYEUuB4veoR+qvTOY85vekJN4ViplV9ZdZJKqn+i6nrrIuVt3LYhAmQurPHfJCSn7oD+L0edE+MpPaiPh6wh3bseEpQ9P9k/ZIKbpX+kfq+/9nsLc2jfDy2Mp7AMoGuND8uxtTxurkNU4svhoCde83eZLPMnLVntQ8lOVNVV8poyA11YN1Gd9SjMqiKovBQUgvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UFIvjei3+WXVj5wVMRe75IQcU98XLz98k1Smu/qVSxE=;
 b=agMVDQ1MRt9/orU55xn0na0wG6f/hzQNKiJsax6gB1+DQws5QmdPawMSh/pH6g8f4jVqoOvbYOw5T8iNHMFyFr0XlXaIy5+TTTUeLO0u2k1VcMVylpta0IYIbYb9nyttTEnegiG6ftT9OFQFXFgB6+F7tJwcx7ti7/8dtt3EEVKCqi11f6hteJUDM8QHmTkWIEVqmPA+HtGtheSDPrGGLpfhiRpPePu1r0DvJl/QK7P11RkMubqE0uBjzpPOxHBL9AGBvV4XAneALXvcK1rU33eDxdiU7ZFLuXW8JmGckvDS5hFTCimznYhpgePIe57PHKviApr6Fb42SobrnmnG6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFIvjei3+WXVj5wVMRe75IQcU98XLz98k1Smu/qVSxE=;
 b=YFqt9sSFrz/o5+izS48T+uTkJ0FjoriAZ9XnXwMG9PXV/F9sIy2kZaWV5yBFd25/rxJNqXKTQYct9I4qDom/j1drtMvqz/1ImNjbKmLbE8J1jqcZBP88O6Lw6rFILpqb2eRA0+om6QZPCYiTTJjbxbx0B82YUUt1ROZP4n2ZVGg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AS8PR04MB8691.eurprd04.prod.outlook.com (2603:10a6:20b:42a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 13 Apr
 2022 10:34:49 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 10:34:49 +0000
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
Subject: [PATCH v6 09/13] dt-bindings: mmc: imx-esdhc: Add i.MX8DXL compatible string
Date:   Wed, 13 Apr 2022 13:33:52 +0300
Message-Id: <20220413103356.3433637-10-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 189b414d-12cc-4356-bff3-08da1d393cca
X-MS-TrafficTypeDiagnostic: AS8PR04MB8691:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB86910C78E76EF52293D5CC05F6EC9@AS8PR04MB8691.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qt+1BA7t/qxceGGeDdfRajcup1XcDJhCeL4fSew97A1IXyZn7tCB2N/cwEyNeSdIt3T8CUpJOJf3E4+RfofjviKF/R9uqt1MpfiJYNGVxfSNAKTqQVllhaXZFQFli2Tf4aIubgapADPglQdk1pmeFAL/lDfO3/JMVSxX4sApSbMiGoFTTjOVGb4LvqpHiZKfGw6W3n03lSXZjnJk2BRd6DUh5dGqwgenAla5G46O8G0V3bfcKl43UykfgbJ3tqB6DIHb5+Kz+H+pC5IqU2glEzCH+v8818uPTDEawevmQMnWD8Pxgqnt/B/h5Ylyj4RhyPIJwKjCjEndrR0cQ6KmTMPr60k6qxS8mPSnqPH8fohGivgwIhZV0GaJnU8+fnmqKg+xGsTPNQk3zEDenJiIM4PlKnQDxYa3yX30Wm/5cl1tS46DwJaOqs1fOybJ02quf7T/22CpHYVKQpQwEO4ZI2d+U9Unw1ab7ncy9eGrLNBpvU+veDUaWWlA9df/aFAokqoItH1Z8vf6X3teFmxYksbI8yw3NM0YNrjIowVIxWbI9fYZbQII2wUeyWSBp6lkwp+cJDxUncnScnyc65FsQ/p86K8wfoL7zqt/doSMXzXR77rDm0hZ8FwIBbPrP2PbA21/4/h8bQXG/+e1S+c74xqAgWGFwsIEjJDnTqRInysCH1MSAyHrkNkypWkldn2cDwoHFSl+MJRFfSqj21juHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(38100700002)(4326008)(66476007)(66946007)(66556008)(316002)(54906003)(110136005)(508600001)(1076003)(8676002)(26005)(186003)(2616005)(52116002)(6512007)(6506007)(6666004)(86362001)(2906002)(4744005)(44832011)(7416002)(5660300002)(36756003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x6UCAM6diBmXjFyxGU2CZp0crD75Iu0R8oHwgvc8qblnTNzZ/lScewjVvr+t?=
 =?us-ascii?Q?kKjwB8pA2ky7QHnAyBTRKJJ2Kgb8+owxd2x7TP+9jzpv520OzjvfsQW/aBN+?=
 =?us-ascii?Q?9r/MBwyz5By1WGd95XWg6nmVAyvqd0uHKyu00A0iZxcYdaQb1omZtpM/Hjg9?=
 =?us-ascii?Q?IWsmzHKu8m+Hq5afWLbxt0ZxfciZVF9IAZJzKHHfQu8iIOazMlQlDIG4QNx9?=
 =?us-ascii?Q?7TgSUjvlcb77UAPTUUV6TN0B3z0hpAzZcGK76+a4696dlkHgFqYWhNxwyrVS?=
 =?us-ascii?Q?Blmf4omNm46Z3tZf9UzuV2nQ62wsEk5QTewdsru6VqLTF5wWYraMrR/YBVzO?=
 =?us-ascii?Q?KfHJ42cDZ1JnQyOKX9oFIpRkiRDpGpxG6u4afQq0CLr/AV8pMSaEiXEq68BI?=
 =?us-ascii?Q?XfLOj6Cbyhu0sI8q07wZOb06zzMY8t/PyX+ZY4AONputi7iWtPpIfEPkP3mT?=
 =?us-ascii?Q?h0nwZpeu2fWBv66we/5DdEwXEweQzSg8eR4fIGPa2/4mdszeBgEefRQOIB+a?=
 =?us-ascii?Q?RLaPdeFHZNGkfYAokSImCRFsacMEPv6hE4/j62J+45hrYfBFgU7SvO0E33Zf?=
 =?us-ascii?Q?Hd166h7LFDa7Na9omsJc5SCJrS45M0hDGpdviJ9eUoENneFu4pkhni6pcc4R?=
 =?us-ascii?Q?ti/NM6v/8HrChmizfymgAorUQ113wCP6Eh/rMB6obU+38YM7I/I11Pa3L4Lc?=
 =?us-ascii?Q?8LtLHSf4XsHq/unIFqc3Kc0SdrhEswM74ZMeWnF5qp1VG86vNqp7z2y/smNZ?=
 =?us-ascii?Q?E/m8FapB1VgKFWEw1pWYzcUGZNmSEZ8Ou0I4SllSXfl3Hv3TFNtUATh7wzLK?=
 =?us-ascii?Q?lZSWJJtPJu1T8bnRVIJsxCIfGr1nM91h9W/ODg7h/6N0XS+VTGdoVmqewDpa?=
 =?us-ascii?Q?PB7EDz+Fd4DEPQHhrkilEfJgwBxFcxIZqTeWiqYAEONBIYRkDnbXCJQSgxWA?=
 =?us-ascii?Q?zDnTMeet7VnDnNHkOWrUcPu21bYrdLM4nGW58l02uzYMyNaEgx+LGLg91sOh?=
 =?us-ascii?Q?g+M1Ii9c0jajT+oUIA6XsKUGu3UFI2AXDi7v7S+zhiOEDanGgfwVGbxtqnlK?=
 =?us-ascii?Q?K1MnqFrptc+0dpPC8b89eIlJgYMjqo6ndpx+SHCLtftSAyThV3Z6BHPLykwi?=
 =?us-ascii?Q?bzMic9yNwuXNB3k/zez/lQ2a+vdKUuje7vdE3q4P5yz2Fh1Hgy+erygaVIbr?=
 =?us-ascii?Q?rivRmd6t0YlVenApXCFawN6+RJunEXSFv/uj2GdBt9WOJMOdsyM+o3fkc8cW?=
 =?us-ascii?Q?0GQLYH525vL5RjkfRkIJoz2lXKRWPxixqQTzDggScXztfHFb77lrPGZq4Xa0?=
 =?us-ascii?Q?aERcp0gjBf5mPMk73+gHu2Q8xvFrF1z5x6aFkdImTFeOq3VWXLQ3sE8u538k?=
 =?us-ascii?Q?ZVZAqSadsmLE2jMM7fzc3Bw/+tvawFJoUdLlyhN1dddTTME/ezwhXYwNzzk0?=
 =?us-ascii?Q?Ey6fCYap1FOvD8/eONt28jv+9cy9f7lJmcyJsvp/BsRYl+15gZYLwU9TkPEj?=
 =?us-ascii?Q?FhQ7DHQTUd/UJnRDrxorrHMZkJQJ/ImPkstZWUFuWDqfc4mEhwQsnb3YN4WQ?=
 =?us-ascii?Q?DlpsN/sbwckzy+uesbmVkH9Q0JJp4ImUHwik54iv/hk+BXrKeZk4jOJDv6bz?=
 =?us-ascii?Q?YPVKLR71dWEHyrooGeT4Wq1d1AFAHUwBpTk28Pu/c7acfuOKjXc3ojCL2ORX?=
 =?us-ascii?Q?3DE/pXTIgZqhmgxOgtfzgRLfI1sOHfiJewjtqVGVFfYjGKy3S1JDpak09Hp/?=
 =?us-ascii?Q?AyAbs6+EVA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 189b414d-12cc-4356-bff3-08da1d393cca
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 10:34:49.8326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z91NEhX85vCKlvassDoieJBwQM4Ofj2V2Gn2uWy4qvxRnNaFiyHhW3NSe8SPNLW9YsTndl8PXgki+AOD8JijNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8691
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add i.MX8DXL compatible string. It also needs "fsl,imx8qm-fec" compatible.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml
index 7dbbcae9485c..f2e3b1e0206f 100644
--- a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml
+++ b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml
@@ -38,6 +38,7 @@ properties:
           - nxp,s32g2-usdhc
       - items:
           - enum:
+              - fsl,imx8dxl-usdhc
               - fsl,imx8mm-usdhc
               - fsl,imx8mn-usdhc
               - fsl,imx8mp-usdhc
-- 
2.34.1

