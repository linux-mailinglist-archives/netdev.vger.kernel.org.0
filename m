Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF2F580BC9
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbiGZGpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiGZGpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:45:05 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30056.outbound.protection.outlook.com [40.107.3.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CB81B7B8;
        Mon, 25 Jul 2022 23:45:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MpZHbxYkKaPWKkhieoDK0Ox9vcf1TmiICYhwsUu/nLr7QeG4vgQaTQoHcL9mBjU8wNNywLPW4qnDhIQHboQIOyFA4JU94hM9FXFKa+uDaL5/C1MBzBwCXy8NH94u8b1gtYxC0MX5dj8SNeB368uoqPTvURokEGFUAKZx0Smw1sOma98qrr/cdC/eYntgBRoE409YrDy/iTQ2SzL0+CpwSALiRIm5EyhuXm9jYZL8KK2PNK4u5UaIkaRZrZleEKJizHI4pg3j1IRXTLA0CxaFiqjdhkAnI0IrUxN3zYwmaqrmadSO2kZU9h1gzLUjUSk7p3o0w950mMomeI7KaYUjvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tCxQA+CugozcN7CeARfSMZtKEfCuo5uByE+83uPujJ0=;
 b=hP3ev7jwKE0jIpv6opwlvHaCirJzTde8ETrPern+KyQwnE0fddvJh7+a/azScNPapRnxyE5PG6+BLQcvEFES/pVHXCqbORLe4I+yVAnmMzQmi5U4riX61ynONUCjVl8X55a2gCzxu26hzdJPuyauX+9Ua2mbt4xJaZ/qk6CUcDKei0Who4LIuQKuzoHs5W7XF8YJk2CX4bekOC2OVexdg2T384ALNiWaTtsGfK5xXjoIZgH9MojkrV87ktVKbEErwsOxwvUO92e10eQX3VGoUyFNhzT0uY07OKqhqCz+UzPU+nyjrJ5Q9d2BXKXgd44WGyO49isW11SPwq3ds+EFhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCxQA+CugozcN7CeARfSMZtKEfCuo5uByE+83uPujJ0=;
 b=oKF1GVPjuaV5mkFdfYID6YNjEcQDsXr5nvbzIR/TjdkzmvKh8WQwk3YmwxdZr8O7XwNTLKfYPqURis8V+q+63Su7Wag9WAr19sIRNvfO91AzDBCUA6jLHeAWIJjQv4F0OMSZCwcHLN02oLYmyCyE3uh2EiS94BcILKWv3aokyyA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by PR3PR04MB7210.eurprd04.prod.outlook.com (2603:10a6:102:8f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Tue, 26 Jul
 2022 06:45:00 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::3848:9db:ca98:e5c1]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::3848:9db:ca98:e5c1%8]) with mapi id 15.20.5458.024; Tue, 26 Jul 2022
 06:45:00 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: [PATCH V4 0/3] Add the fec node on i.MX8ULP platform
Date:   Wed, 27 Jul 2022 00:38:50 +1000
Message-Id: <20220726143853.23709-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0003.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::20) To AM9PR04MB9003.eurprd04.prod.outlook.com
 (2603:10a6:20b:40a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27b14a8a-ad1a-4465-a53c-08da6ed25c2d
X-MS-TrafficTypeDiagnostic: PR3PR04MB7210:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mtrw5XI0DfSx0iSk8v2HHXzRbmckIGey9TdYVQbZ8Ni+g5hJ+B7+GKSzdIbGsWMdUZ/lu3m3SAe+kxlZbFB+hfAhJtGEjEAfoNgyuGak7h22/xvqy5lj6ma3zvQwRqaSrvhbDnKAJCehAyC8A0DTgReC539N6iXnCH6yoUzbW1TLBoWZrozC8eSNY60H0bxcwcstK31OkC1J4RXNS45kHggN6hyyXUE/ObGo4/9Qgm7b/jbmm8HmqpUhRrjcHq04LnWJExaUBOkjbf3CEKjWqmwKgSNkCVyDsBoaHlUT+0p3n2FPI88iiC0yRnaUWYosQQzL4V910hsYUE2AI0GXLObxUvfipMcUh0EImIWLk2g1mhVuTsE3z+RTz2Q9H3tZWYGPiin4CZTFxIDqlea7dB9ep03xXdneq9bKyLJuTpGIpP7c+tv/AoJdUnSSYZExyjux9t7xwTdugtQHM4L8X9Xt8mDgrijxWOQXS9sN63etM7kEe3tOtlDxt5T0ei6emRX83yJQvdZLGb8aTlT9q7vF6iteR/VP4+hH33rRiJhwki9v/yjRH5qiUSsk4yXH28vLKM7bY8TYok4d7xmJCw6eAg8GBJKd47Wa/KVuIP/KBtKkJMB3iUUbrkwYm3PI67jdhj3kc24CvTXKXKgmFoOlLSdhn0Aobxn1OS5kbG+yEMCszItvdF0zXyLSPBS4Thp9k8Zzxzax/p2Fz6wuKN91EWStfj3p2O0PAGPJAsufZkKSJIdUqUFoRCb4FkyctLdI1KUFnJHDX33jaqCDgUG+S5mvOys3NNHGSvl65a8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(186003)(2616005)(1076003)(4326008)(66946007)(8676002)(66556008)(66476007)(6512007)(9686003)(36756003)(6666004)(41300700001)(6506007)(26005)(2906002)(52116002)(86362001)(38350700002)(6486002)(38100700002)(5660300002)(7416002)(4744005)(316002)(478600001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aENWIDbnh95/wXHgA+I8aJsxr9ZRwMF0O8Td+A85zvwrsoTWroq8kT94DW0R?=
 =?us-ascii?Q?v5YgVn8thI3l4jRRAwo/3Iopjn/ov50UrxUO7qeC8fqunj71u39Lfcq0AeC4?=
 =?us-ascii?Q?joGmqeNzAhqkStCcYlG2yMH0gbfomXiRlrMwtLOQjoHMseVeGY26k28MGSoP?=
 =?us-ascii?Q?mytqdbm9pOAXVSkcawyyVxenxpS0GXhszW+EIekqCq0xXvOL9+veAEMaMH4X?=
 =?us-ascii?Q?UivvQfXmIuKmiv0MrQHI6oQi7V5eYSNi3VmwSEooVPbqhy1HkFdfs3+HmKL4?=
 =?us-ascii?Q?sc+JHPX0GlSqpg/iBjeb+XKZtVbhULOJuiWUZ7r+2H+NCbQhrLQkfyIp+nvc?=
 =?us-ascii?Q?Of729f66g6FXP5txHMYHqMv6sstkzeeGfWjNWwwJ3arckrY7ISARQUDcdJ3l?=
 =?us-ascii?Q?OFCRBMqgEKsFBXLonWCADspbI2AkvdyHL45ItVOqrUdoCwR4A+0cec7ULA32?=
 =?us-ascii?Q?Z/kkbfNjmp70p8ehAc45S1abN2MKkIceNqNrlnS6iMUhUUkfo0/tZumvvRoV?=
 =?us-ascii?Q?hq1cIhAWCdSWvFKxiJGgqf/OaStHTWbNk2HxCibxX1gfX85Bbmiu3G+Brdt7?=
 =?us-ascii?Q?saTyS/1Wqx2K1oa8RKZfy5+RAPbKkq9rvaOeCK5oeWn7diAOBmN1bgb7YVGY?=
 =?us-ascii?Q?ANa9kLn4jKf3wlIaKqXoeibXACSjHoWCA2hjvNc5m01m2t379xdQyT6Ljh0F?=
 =?us-ascii?Q?O/aUomsljDjN7I55AFvH92HdouS+giem2ZPfIs5G40mg5mI8BFDbGWut6YQn?=
 =?us-ascii?Q?M63wsiC4pp0HdgYWzD3cvF2uvRAQrCCEPVSdb5Kqt9rEyQyT0WBoBJkRcCAl?=
 =?us-ascii?Q?CuqpSqrNCJ8IPpl/BNC1lDnEf6rLFWwrbwuxAAGabaZRF5IiN4OaQtd51L4D?=
 =?us-ascii?Q?t99W2KkIoo7iz9ZmdwQ+dfI4/BuA5UMJvJnVoNND7wyyxtcLU5vcB1XaV/OO?=
 =?us-ascii?Q?XhLSS/jwybdo+VTtu7jUo7iqlFQsNJSDbLY9yrODGhLMSv58nQt/FOZ4nleJ?=
 =?us-ascii?Q?q1Gpy3oKCwD9zUgqX5UkTN11V4jBXfAWCXSr9c/m3+q1wacfUsOpv653wifk?=
 =?us-ascii?Q?ImLDglsUKUNWzet/0lo+KHyRXnoqCjMCa0Mf18iEFjQ1Iw6gG4Pfr6jsWFm2?=
 =?us-ascii?Q?KO+7yn9+Os4u5RmWUxdloX7aLVKOYXjKMvgyBlJo70dntF1Zy33rtZHsvWdM?=
 =?us-ascii?Q?ub7QBU8zimJN5xs4h8udB4XjyfegbvpllSqJy/b0ODPohhl+HsT0qzBXaBGz?=
 =?us-ascii?Q?KNXe4cmzLJAKZ/OvWjVXWdAxPHIUW4/bFf1lo5GSviOiue9J83tPRo3ZdRh9?=
 =?us-ascii?Q?N2f7Xx8XzjpOIM/K8MwisHEWhpHnW3rxaJs/MCLdZspF3CeAoz8tgtnNOX/u?=
 =?us-ascii?Q?N9hYmSWLIw1UOxaL5Kb8duV6F3aTp4MbHwg1GRsQrhlP/Vj0csku3zB1eCiF?=
 =?us-ascii?Q?/wpkCe9eKo6I2uHnuY525p0hVMeFNOavSM4Ius2ThZ+S2R0SG/U3gdoKFm/X?=
 =?us-ascii?Q?V8BsnCERjftpWxJIE3NGJWCsMfHM6ra7RZYFY+YQzW7s+jPDNus0SK532ZY+?=
 =?us-ascii?Q?sQwY3daCW9PX8qYk/kawdnHqVL1hk76/V9JToDPJ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27b14a8a-ad1a-4465-a53c-08da6ed25c2d
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 06:45:00.8309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: neacLf2EKqDJDlO2gsZsNQQ8Mn+PqhuGQZ5aoq0dpcescV+KIPl7JmJGuZRjWSpk87Fo8OuHBHQKPkIiJvCGGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7210
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

Add the fec node on i.MX8ULP platfroms.
And enable the fec support on i.MX8ULP EVK boards.

Wei Fang (3):
  dt-bindings: net: fsl,fec: Add i.MX8ULP FEC items
  arm64: dts: imx8ulp: Add the fec support
  arm64: dts: imx8ulp-evk: Add the fec support

 .../devicetree/bindings/net/fsl,fec.yaml      |  5 ++
 arch/arm64/boot/dts/freescale/imx8ulp-evk.dts | 57 +++++++++++++++++++
 arch/arm64/boot/dts/freescale/imx8ulp.dtsi    | 11 ++++
 3 files changed, 73 insertions(+)

-- 
2.25.1

