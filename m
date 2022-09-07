Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361975B0102
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 11:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiIGJ5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 05:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiIGJ5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 05:57:38 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2077.outbound.protection.outlook.com [40.107.20.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C59AE9C0;
        Wed,  7 Sep 2022 02:57:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kuBsvHZxV6of0iwALOP5nebfhAYRofXqu7wfWUErxV3zSJC/UOZJGh9yLHspnKdmg5kwRPe5VARbgT5Wk3ENquqJOY8Y3mJMSCrNjKpo+kK5j9pxl2SmlLdeZ/x+1EiTaslNt5d4+PmGX4ZGoa8RM6dzgNqHFQPuTH/n/CqvOE8JtpZLTd/MvQEPaiGUgW9EMklSMbEmbF5LuivOMgybUjDK5fe3EcZMy5j8suRBI8ew/Izm5lDXF1zLmdpaMg7lMdGuYL+I195TsoT7WhahapPmCHorhqHgj3myFEy2IvtuBW2Ja7+naswDZ+t0d1VdoCEcwFqPuScUmsYlsqZsVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AQ8/54uj3mCa9IlPmAg4TX5G/GCobW8V8T97UpeQkBM=;
 b=Nfoo7IvqPZrmLb3mmJb2evaFTtAyGRSHYZqCvdScYKEhwnOTL2tvq/uq0QM35dI+5556/XG7ZCo37QxUIKyUjceLtDaJwrULwTDna9HBcVfK+NTAp0hRd6ArA/d8T4EM3lb2HBUFWdJOIy88b40amvWP8aaW0voBVyZSRDKKBOhFqaa8Xk+W4fO49h39F0wBcGEJ/+4ICErjcGfqUfM/XeGrxgLB3bmEFLEKZ41MNkSnzLt58n+ezkP2Ii/j8Mup6tmdmPYrHZyJiQXk7cFCUUZTMpKOKvVmTgXuEckYJORM8rBra28viKXJfEmcak//g+PqwLQibtXeaFS85YIynw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQ8/54uj3mCa9IlPmAg4TX5G/GCobW8V8T97UpeQkBM=;
 b=WK3K3xv/22dfOjlWaSiIwAgFQ2uQKdHRFzQoGSe91/CSVt50sqPm+G9LyerTjKg/OlnqttgEVr6SNJGyCutHZ8lpKU1B2PlZEg5PuHfXFh48MjqqJJr+HQybvVfIr8PiXQtGK5cfghPzu+n4/+wJOZ8ywFsdK9lvJso92ZH7ACI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AS8PR04MB7688.eurprd04.prod.outlook.com (2603:10a6:20b:29d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 7 Sep
 2022 09:57:21 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::4ba:5b1c:4830:113d]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::4ba:5b1c:4830:113d%6]) with mapi id 15.20.5612.012; Wed, 7 Sep 2022
 09:57:20 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] dt-bindings: net: fec: add fsl,s32v234-fec to compatible property
Date:   Wed,  7 Sep 2022 17:56:48 +0800
Message-Id: <20220907095649.3101484-2-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220907095649.3101484-1-wei.fang@nxp.com>
References: <20220907095649.3101484-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0017.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::10) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR04MB8106:EE_|AS8PR04MB7688:EE_
X-MS-Office365-Filtering-Correlation-Id: b74f1b59-1ec8-4f2c-b22a-08da90b75aef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FcGKaGMREXZKcPP/jk+O7eYjsTHNOUZcaXctlIUl3NjmeiYGZYQ/LIIO2Yksp4dIjsy4TaGmaCEl9HEnPwsy99OyHXcMGkq0xQREheZoc3llotcpT6zHGVVhugmFUSKbC0nyVZ7L+ozBbd8BDlBNjONAg/LkZyGarfDP/aTk7A6GbImHd67DQoIh4Y5rn8WbQmiGBGc9F64wobS37O2x4gMYCggpCcOXTZzOPqa0DChHxxuNyG97s3kPMaiVYnHFwiZG8CpptlUHl1Fqi1JgdfmzuRkNmadA8mhtZx98PP99pmovVDzYK1EnxqbV25Q0P5+OvoMrM1L/mnrFnJp7UQBYN/UwBEzmydmD6ySI4r5/e94uWrj0OLypMCHRYKBdLtGlBhTXrObo1KI0VUZOELeMaXYLWZs7MimKk742HKWkwy2TbGOx51/0d2OuFE/zU6Eh/UQOt3mlMwhziGHjoBmday20Nn5xx0YPS2B5hyLJNfqfdJxTdTyh2oKUAkV9JXULmH54zhhQoG/axxixBN0JXknPzBNoePKGLNf6k6BdjjCYkd/CajPew3GjMK4K4SBGI7wF4zwtwZ/zk7cPJbTuo5b8wd2XHBOo5BSySaHXz5jrwPo9Q/3ym3LmK5CP/Nd84Wp1FazdPsDICavXGQDysj+2VNxc5GJYqSAUQDJV3N70hH+PIcznLm/3Zg2GZDHYMniWUphWjpZqfl6IUgZZ9XU8CL2Z4TQVDgs6vCkU7BFAWFXZytSs7oDqVwTPLEqoi1xMbq5QXRhSBDAzog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(5660300002)(4744005)(8936002)(2906002)(36756003)(38350700002)(38100700002)(66946007)(8676002)(66476007)(66556008)(52116002)(6506007)(86362001)(478600001)(1076003)(186003)(2616005)(316002)(9686003)(6486002)(41300700001)(6666004)(26005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kNf7kbHP17LJjy27kzps6aq3Rzi82UQ60gmg/sPjZlmcksN8z7FHH/0s9eij?=
 =?us-ascii?Q?vujrxGOoMyYaWhxFNazILGSplSNhZlMtj0lEDA5xxgJ8Ss67hMqmfOQPLbZG?=
 =?us-ascii?Q?ynLT1EonkBwOnBctM76cYjEraDdbkjZnHPumROf7q+xjfiTmRilafCakkbel?=
 =?us-ascii?Q?YwMZ7uwA9Qwq81zSZ6JJFxsR/cDLkeeJ8oGfvNXkuFkaojSm7E3nbyQBfE9+?=
 =?us-ascii?Q?Eq/3fXlz8kXvj1FmsSF4/dXWS32ODfywMWfWb4ioGnBR5D66bSXPWMBkGilB?=
 =?us-ascii?Q?dNMx0MFXjmrgxS6XFFZ2ddAg9trF7jwPh6lt5PcWBEx5eahQx7Ky+vOlLboN?=
 =?us-ascii?Q?wptWQd4VVmvLACvruwo240bjlux5IqgjNAhwnn3x2rV9sfucihF7Mq6PGvy8?=
 =?us-ascii?Q?er2TOWr9JoB+gkxtFlx9sDZKYgX98lQ4R1A2E0tEsx4baxZOWMZj670QuTov?=
 =?us-ascii?Q?qQrFRoZ5cQ/U8pWndlJLRs5rWxbjzx99sLtu0lKyOqq2Q6QwP/g7HXanTfDw?=
 =?us-ascii?Q?ELAmR1K5X9fMom5cHZ7dFjKiRy5EK//4XjCbe+Fd7j41liJFspXynrMVfgoJ?=
 =?us-ascii?Q?frtRpLSXD8CXa4x9DvwxEepeuzMIW4o5ALxdZQP3P0JVi2MwCf+KVJl6UpQf?=
 =?us-ascii?Q?Fh5Q8plGNF4QICbCxmHQyAZNbqR96UCgiJVVBY5Kjv+g0Ky4ODYDxsMN8/a1?=
 =?us-ascii?Q?mFsyshVz4Hoo+egk/cPmt3nsaGzRPClKiaTbOtDob6z4U5jnMNHAtO8Gt+nX?=
 =?us-ascii?Q?b5InLJ10tjKErehhM7IbmFm7m7XIxPCQWASA1+vYwOYIftIPSIPDHzeWhztz?=
 =?us-ascii?Q?bKTLU1a/qSCsH6KdhvwJIt9wR7eK+9sVMpM3mAcTMFmaNl5vyk3y276cTiOq?=
 =?us-ascii?Q?cCrNdWUORpvId6OhL8w0zqMy4wunE50JJx+40K9mBrnXz2Pd9LRu5cD4UTz5?=
 =?us-ascii?Q?Q6TwkCL4BWyyvT0SoU4jP2FFiSyWKM+lJn2JlVx88gJi390wbaeuw5708LUx?=
 =?us-ascii?Q?MiN/8rPlEkLNMB34wqYowcaPC/8Sh/GeKU+VLAtN6RQQlO7l1LBAuNW81AMi?=
 =?us-ascii?Q?FA/1YyspGtOxWmEXVZr2YGUvcNlztj6uUESzB6wJdUwHhAcnCO2CQmeeA1jG?=
 =?us-ascii?Q?2UCIHu6q0H10iw81GTQhrsVEKhFci0oj+JfOi1lLU6iTWCqz7tSF9IuIfHmO?=
 =?us-ascii?Q?x8VC/X7QYKYub6Q50fNcTEodbjexuD97rNT7xlKo78DsPFPpD14KswnYOe6Y?=
 =?us-ascii?Q?IRhOViiBh2m9fFgGJNWxqkCKj2AH3v/jXJiOoQhFE5Jx27RWyafZhUQ69nzv?=
 =?us-ascii?Q?LLM0TrTPJ6PffDnnwpfbFCEbV7LTS8AY4EJ7iLbVM0PuZxtsMspWQaW0FReR?=
 =?us-ascii?Q?jOzF7rNYKan/YtXt2GBSfI++LZxHlrldLYwFd1zQd4dK1UXbg1yaC2ZRvy8w?=
 =?us-ascii?Q?EWkx3S2xTPDWtP+gzw7ym5VLpcIbn6OT3wPM46vx+JHBtIAB+CJztPRgvIEp?=
 =?us-ascii?Q?pMqWo6lhEqK1eRWFihpbeyyw3YG9FfMcsfhj9BqnmK+2sVxcLUtZXdFVZ4hK?=
 =?us-ascii?Q?Ri1QWZAjuwUWCnXtrsLJrifYjwCLtBnTDgMmDvDL?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74f1b59-1ec8-4f2c-b22a-08da90b75aef
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 09:57:20.8543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C7TV6/4GiizKu6ubyVdVQLDsHyPruwV6dDXLskcgQTUusaKY/JZIkA/yyVq+5OZe/3H8mzCMAZrq82+A4/aQLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7688
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

Add fsl,s32v234-fec to compatible property to support s32v234 platform.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index 5cfb661be124..e0f376f7e274 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -21,6 +21,7 @@ properties:
           - fsl,imx28-fec
           - fsl,imx6q-fec
           - fsl,mvf600-fec
+          - fsl,s32v234-fec
       - items:
           - enum:
               - fsl,imx53-fec
-- 
2.25.1

