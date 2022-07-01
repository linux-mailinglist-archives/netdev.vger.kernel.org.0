Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E09563A04
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 21:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbiGAT1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 15:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232378AbiGAT0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 15:26:36 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2118.outbound.protection.outlook.com [40.107.100.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9CE43382;
        Fri,  1 Jul 2022 12:26:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqvvOrkuJ/m2FJoIl1GEW1uX2I29BxCbAwqcPGPWCybRNfgS6nC9KaU0A/tKNHvKBA3qeOlKWa471zAvEbNQR/A0PaqDp5cpch8zAv/NaIS4FW/l5h9pkeblcsi83DVyWN/R4tol0T7uzCNq1+61EqstRbw8AGh+Hybb/t5D0BPhu+izsQ+90ofEEAUv+1l/GfnAT7fuMNSJppsUqs3a3F72LhOv+zntS0OrBAvviRedZag2mCxsOLpAMNR8A+xHPi9aNmYQ/hVIHw0JuFlqd5uOmyFYHL3G3QznR8RcMqKzrvdTwaGc9Ndh8qc3vNSLvWCN7nxR+CniesFAH/gZmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdpu+ko3VfPuNkeVreHLdBfmtcqZDB3EUVhdCP9JkOI=;
 b=h9WLYq4UafeTPYUmc9SA/XZAW1JJhD9N9tN0Ubslw29qRRkbcmvUFUNxNO67n3u426nQXdGKbHTLcVWhSyPebXTdNkbaf40t3wnM5YUeHcQKki1csMRaHU+FhYahF8zmhPRT+ieOUL0dJdlLFDZisp21T6fwb9AHyMBq0Mxzf7tkZ7jmwR5mSGtzI4vdFYEgw/h4TA2dsCU1w28rV9xvN739FlnebANUbJtQv024r20D8VeIZUC3dnDs+9O0omLQ9h8Qa6MFcUeVZKxg9JeRp+X8UHMAbl80duX6ppnDVYbbdAQDbiCwNpGXMJyIkggKGESJmipDyI6aXcwjiRUkhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdpu+ko3VfPuNkeVreHLdBfmtcqZDB3EUVhdCP9JkOI=;
 b=gMRtP/OAMWpYYRBW41gPO2vETqPNsb18CRf1TRXI/1soXjIBTZGIZw3/TJsZbUAAg+XSG7ZbgOrRjthGrOTsQ66l3KtftQ4V2/oEOREUsW7/or1oVMr86D3/CyhEE0dDGxWu+l0Twh2MHMgW70ME6oUagqwxKy9RF8Cbla9Py8U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR1001MB2230.namprd10.prod.outlook.com
 (2603:10b6:910:46::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 1 Jul
 2022 19:26:23 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Fri, 1 Jul 2022
 19:26:23 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com
Subject: [PATCH v12 net-next 7/9] resource: add define macro for register address resources
Date:   Fri,  1 Jul 2022 12:26:07 -0700
Message-Id: <20220701192609.3970317-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220701192609.3970317-1-colin.foster@in-advantage.com>
References: <20220701192609.3970317-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1601CA0006.namprd16.prod.outlook.com
 (2603:10b6:300:da::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3db6acf0-e729-4475-3311-08da5b9795a6
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2230:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 69//nZ3cGUhCeMqaQiEHisvLQxBLN3GMPgunEWBrwAVjVZzjN3ZW38RnxYK/JKsQ4Is+8JnziX3EYAY/XOWheUIttkGwigt+DTmWbzkrwS1G6W4RxdkK8HQdBvcYyXV39pmFjsPF2wT1sKgfHpZ4Kl3t1H8E5K979nUF5VKACn/3SBNLzsUoUuCAE9T5yz16X28JRvVStsOcK4GSDK5zQGlQPm833e63lkL0x9bnBybRm8ZsSw8XHuhhRA8ut57i8WsxdcI/b08ko54MVTsdPKpjv2SwB/CzKASHBMHbJAMUNYVvr7jGLsOUI8hajsIc9hKU09SAocQv7tJSr3+Qa8elxxMeJYV85ddNYQyzOfTcEldAQvRrsXmTMFmAYjCLPDtZ/SyDskHPfcel++p2fsRIEGzIIHchyvf7Xm/aCvuoLSMbCiEmp+r+ww45hPXLCnflUmveAtZOTYn6i1XTH5vO7yHghxukBvTtpBpvJxTCcqR+TwQx1HkHQfgKIjVq8d6KNZp2tL5vD06ikJaqM//hpFjHJB41uZbSPd+v5Dx3FJYgrI5Zt1XTcZss/8/KLIEuotPAIIyVE10Si6VEjUJLS4g6KmFafZvZlWdiXj8XulCLjNuiyRiXdU0ngL7n9M8vduUm07z4BVKufj9fwvYsIy+quETzb7zFPweihc3MQ0PBEQKhrlDHToKki8zqqgYSts7X9XV3uatvCaN0JZTuxjkonOcd2GOouiYab/s2eDSeTqMeScKdd0tInAApnHMIcOi/MrF0rqY+MC4k6M9tkrEbZjOEUpSXN4GFDVB9zOPa/wEfVHDi7H+moZvs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(39830400003)(376002)(136003)(396003)(66476007)(38350700002)(186003)(8676002)(8936002)(4326008)(86362001)(66946007)(1076003)(5660300002)(6666004)(38100700002)(4744005)(107886003)(66556008)(7416002)(41300700001)(478600001)(316002)(36756003)(52116002)(44832011)(2906002)(6512007)(2616005)(6506007)(6486002)(26005)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wXnvhxU/iwbTw5GLvHI3bvynrRfKsjMEIZwToGuX6F2jlb6fAsJ5kOZ7ccqS?=
 =?us-ascii?Q?XzCPfIGGNa4yxrlb3ZosoUl1za31Ty6WQH+wujqTMtmZUqwUqvO67MZoVCKw?=
 =?us-ascii?Q?wGiqo/ksWh53idKxHmp80pysu0feUn1mipvWFxmPySAKrPjezXWP2lzFgCbG?=
 =?us-ascii?Q?IhboIDiHGEP4qhjRZ/6oY3Mtq03ksw1wHqf25EYQLVqElteXCSCAvBg2a6ds?=
 =?us-ascii?Q?FneocyUUmoh9/RqicSkCQpx6YWZY5sRoS6LsnOD4s7C96B3h3/eKMXvTWkXD?=
 =?us-ascii?Q?4KKzQiqce8u8eiD7E11jsfV32LC7jL1QJRQdItot0WtGoYYoeQFYZm+Wjaxz?=
 =?us-ascii?Q?HLz3/OIHA03bVfktMQW5HqO/RQowQakl5zF+PYsPbzB/xbDQVdeJEn+16BQL?=
 =?us-ascii?Q?NQIlLv2Ju1pjCLIOrjUiT1zjKnPyCBO3r56be6QqMw0w9/B0tKBALTspR2tQ?=
 =?us-ascii?Q?jm7eS7RICOyaBYjwhY1WhC6fRe8OIGH4dUX543c7Q+/UHM5BzH8HDwGMZ2Mx?=
 =?us-ascii?Q?A3ZHpovJX0CChHiwzpJZa+DIleJ09vR6mlgxIXFLurkFnSJ+4wGFDtttdi6C?=
 =?us-ascii?Q?a6JYY0KMTgg/rCEdf1n/iJ5Ii01XNONNuewB1lwFcu5ek128YAqhbEjpGNf7?=
 =?us-ascii?Q?DPAeUa6Zu6il+mvkkEB3l4P53mReYM8jV7MjYy3jpfZK/PidLFH/ktbNChht?=
 =?us-ascii?Q?I7S3gGDYjxPeEOKX9bcSk5s9WZmZ1l4CCaQjyv0KBx85P5sjeeOv7fN4MoRa?=
 =?us-ascii?Q?f/hbsJIv+EpvkvdM8kf+mjGwjlehdTmju01JbhU1FftZlqWJt5RfZBZAa2rA?=
 =?us-ascii?Q?nkZ0o6k8ndoeABeQ2Bzyw7tqtDlHKdGqKmXY7A4bH1lm6i1PNxTXGk/V3OA7?=
 =?us-ascii?Q?51ptCUoZy2HByMzj6/LAawtqlG5fyKHFj/8qQNBibRxrEv7dCJssZ7UMU78w?=
 =?us-ascii?Q?jta0TQ1p9jFOoEDy/5Ts/MrjwvfKLJYiQulK55rsBSvOyj2wEdnu4bSepUqE?=
 =?us-ascii?Q?PRnZhJGBViDtkBKWLtMbC9mDnLBganOzBwE0VFBXNoVLQjfnknwOb1hhPlHW?=
 =?us-ascii?Q?Es573zAmdR8b7q3e3sT7EzKvxNVXF/x0iZO0YGOR+oFVZMFZQr4LPF1TUukx?=
 =?us-ascii?Q?XPlsKJuzk0htt1Zp3QLKk30MC/bkkxVXE3WfjKsqHJ7k2zUK2YakB2f6DDvg?=
 =?us-ascii?Q?W1uY9ZEYk7Z9P+amLte/P+tnTuZvPlbqbn4MSjl2BLc4yZ1qTcaFinPSJ8/0?=
 =?us-ascii?Q?60oJ0E5CzoQpxPcAWPUHOtzO9N56rHfv5gUkOr4mtPbvew4QSuv9q1NKhSwj?=
 =?us-ascii?Q?m1gIIryltPsdregE/bGObvoG+wlD2L6gHm30tlfGiR+Y3KLlbb7/LYHpakeK?=
 =?us-ascii?Q?Qzp6lb70uWttpvx3b8kRTtbfyP1qnYR7U8QlQQK9o5gy0xfURKwkSHBAaavp?=
 =?us-ascii?Q?VKJf2VP78fhAShITC+Ib3YG14KDyErWKJuqXRqE0AWdZwRWQTBV4WkJiATdB?=
 =?us-ascii?Q?0nSwEopVejR93a7aGKCyP0zvFuusBW3NxBzEx9KzWmZ2J+Yarz9blGUiEMYD?=
 =?us-ascii?Q?GbKzfStSw8wjF4ecX/xrfzMqccQY6foSZjqpo8j/W6oirgaIDftdpLzHxKrs?=
 =?us-ascii?Q?Hg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3db6acf0-e729-4475-3311-08da5b9795a6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 19:26:23.7264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hVPrHiSiJM8tJfH73vZDDR0TLUdWmMTPIiGDUvQOTYZPJKD9yaQxvV2rmkd4YdG4wBA3OItimGIDivLD8k0hphF6fX3QT2QVeR9LZ7xfuZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2230
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DEFINE_RES_ macros have been created for the commonly used resource types,
but not IORESOURCE_REG. Add the macro so it can be used in a similar manner
to all other resource types.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 include/linux/ioport.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index ec5f71f7135b..b0d09b6f2ecf 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -171,6 +171,11 @@ enum {
 #define DEFINE_RES_MEM(_start, _size)					\
 	DEFINE_RES_MEM_NAMED((_start), (_size), NULL)
 
+#define DEFINE_RES_REG_NAMED(_start, _size, _name)			\
+	DEFINE_RES_NAMED((_start), (_size), (_name), IORESOURCE_REG)
+#define DEFINE_RES_REG(_start, _size)					\
+	DEFINE_RES_REG_NAMED((_start), (_size), NULL)
+
 #define DEFINE_RES_IRQ_NAMED(_irq, _name)				\
 	DEFINE_RES_NAMED((_irq), 1, (_name), IORESOURCE_IRQ)
 #define DEFINE_RES_IRQ(_irq)						\
-- 
2.25.1

