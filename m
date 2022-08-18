Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920F2598548
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245642AbiHROGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245684AbiHROFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:05:42 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2078.outbound.protection.outlook.com [40.107.21.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F0F65823;
        Thu, 18 Aug 2022 07:05:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSjpkRMcOFXNRIJ1n9BNTFcdXUYmn85MdmhylIhxStDo6c2nq5icJpQYRihqook8/jhVrdojJZ5wJ1Svk2YN1tXCnCKrYgUmhj7zOkK43dMps7IjL5xL6l1LKmSCWYvxRK1/Id4pEG0qcyWGhSkPp3Yo55wVAVZ41kuv3R7Btc+OKui5LxUP8I6jfJEyXmN3mEeoic7+c2unHf1EFeD+56HvwjdRUY/SbjIO5td6vetlCHxD8/Hd9x8d7k0ROllo6WWvue+aEJeRjI2uw9sxbU5TfxaNQcIPK6A9czSnlx1Vw0qodfUp7Q3QZWrv3S47I/XBfTOevpIeihJIpQpEaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ulNuW8vkcrljlKAOiEAeSz0Y17wCm8qXdmzGL0FGU20=;
 b=Za8VyqToQ+Begm55o4vzSty6L9Rt+NeWZrIt37w16mRVySIX2CyOSeeUL4cc9bnypPWNTtVGqd6cq1D1CDrIJdrjKk5N51EHwlWMazdXcgY2VUo2y1Z87wJD4Feh6Vtf6weQbhj6kCFvqnYSgTLfzGxuNhGfuHfo5WtMRqi31gzx/vjocwTkUq+2jFN4azPWwTZN71pUi1J7C6ZeaplH7h6zyUXtzp77ZLpnsiRCJBYKg2lL9AqgiXEQrOQy3F63Y4wyDkmUJeNtXtUHoytkTNn2Xe1PxaEy7zeyUEXkyWuBYxmIuWpNtJ5X3SAhhDNuF3uifabRLr9UC2qB5wmhcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ulNuW8vkcrljlKAOiEAeSz0Y17wCm8qXdmzGL0FGU20=;
 b=sWWjixRxQsUMe0L799lfNef0+Lk1EPlgrQiGCPT45WApkJSPnn11IXyViscJOomvFAN0gluYebni3eAxlMZOWAppbLdGRKUZTn4gu8InX5bqn8HG1b1LvXNekmlxIchDvnngDrz6LrZ3Vrdkva8QMd+r4o0Ktq0OtM4jX+pt7M0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB3PR0402MB3883.eurprd04.prod.outlook.com (2603:10a6:8:e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 14:05:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 14:05:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     devicetree@vger.kernel.org
Cc:     netdev@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH devicetree 2/3] arm64: dts: ls1028a: mark enetc port 3 as a DSA master too
Date:   Thu, 18 Aug 2022 17:05:18 +0300
Message-Id: <20220818140519.2767771-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818140519.2767771-1-vladimir.oltean@nxp.com>
References: <20220818140519.2767771-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0023.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e81666e-4d15-4af2-44ef-08da8122bac6
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3883:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZUcqdC//xUZIU9BJ3CELkya8CjQn/6P3zxeVeWAtAtf9t6+3Z2QTiK30hjRHOySLY1g0ZrJbbUjj0a4RzhWaWnp/iritqU2O7tkfwq52HeDnjOIBPzMQg7aZlQIxH31Rv0NvbGguPYmEhMprTW8r6O5740ynNaDoE5sV9lBghEoECP7xAWZm+dBs/iTTHcKYyqohQhoFYKD+ryhn9ZKF4rwcoPscu8CI/jaDfHG3fCbGkdltSg1j3gq2BXRRg682qtJPhtERzt8MwDPeUfo0KlfRmazMOysQWC5B+XKBhBu0WZRbMUli+NVuoAnKIgUQAZn9kMYDxqSZN7Pu4ncti+gUUPUSXINwazJ0Wq6WGKVmg0OxWJ7L87Pii8hPOZRrVnSeBu996p2GhNNw4tn3yaNmcgV6+B9xuHe+RcdNXjwk58HgwEEgKlUHkEihE95uXzICQLKTXEGTMCXsops7eiONebFguFxd40yWiLBhONNF8GVW+vDylRmFeNUOGTq30UD+amfcR2qdCA9grSxK4e3ubrkAA1I64GHfUyKTiQl35qT/pV7aEmc2bKNdMkf+iHcIn3OtFk870vSyjGOINmZx2cxb6uhiKIgXPtN2/LY0C83DBlY/nsa3/UEzeflVqpoxN8z4vhFdqrCvB4M2t3sgxAhn7s/e7oqM20zjW7VW0zcPhmHJp6bu1qycD42M/ayG4rytAX2ZcyfYbXmePHDC2f+cSv+/cMj8U9bUIuA1jeeOftEmb4Otr6IMirWAwcXaV3cjnbSpfDqcg7f11w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(66476007)(66946007)(4744005)(5660300002)(44832011)(8936002)(4326008)(8676002)(6916009)(54906003)(86362001)(316002)(38100700002)(38350700002)(66556008)(2906002)(36756003)(478600001)(6666004)(6486002)(41300700001)(83380400001)(26005)(52116002)(6512007)(6506007)(1076003)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9qQmC1T4jB5/diWcQbVu41Q1/vznI2FhdLksHQ73OCHnSS4Y/ZdZg84q7MSG?=
 =?us-ascii?Q?ERd4zPsQzFXXUy3OVaWBjUYNDj8CnhGMrlwyY+wRyyOB1Mt1ApY6KuTEogh4?=
 =?us-ascii?Q?Hd2NPPJnUU+QarPPIcIUyj1ht8rJ8k0TLnoTzXuaUkEpG5UfVXoVnN8eDbhk?=
 =?us-ascii?Q?LK4pHL3CH38p/O1E9neSJ2QywD02I/VvwkujWW7wxgTOuFMOKQUoe18bUqcV?=
 =?us-ascii?Q?KNEbLV69+WtgZWqMql/irSu3vmJkfKa+XdQ8k1p0t3W/dUxn8GDx6m8+BZwm?=
 =?us-ascii?Q?YlDBWQpV6Yh0Btu92Vx2nDl5wbRBxWyJC1C4ewWCybPl7COsliRQeFUNkElS?=
 =?us-ascii?Q?Hp9v1TY6YqKxr2scL0gzdKdbYuN8Le3SLdaDGHMIFH0QU8NcEXwH2u1s6T7h?=
 =?us-ascii?Q?PMZV9Cw5dIBFdVPfjAkjbimoQULRohRI7h8eX+ula3kBRhkLyczDECex6aFS?=
 =?us-ascii?Q?H8lsmUMH24c3dC5ePlXqLlE8iRMrvPqBKjqieZEK0SDUcP//W5AlcxgrZs2Y?=
 =?us-ascii?Q?JWm49kVBDVZFfbbHWyotw8D6crJwFy/lmLgVMDH/7X4NdT9ommhEMeucndQA?=
 =?us-ascii?Q?+Oi4fXLtW2QKl2Qt539GDQcN+mu3/QausDbNdmDuINDqbbFQ6TB7BWzSx96C?=
 =?us-ascii?Q?wfZHIHKNF2z8Rlf8x/DjbRxkCHatT9SKJBg5ZdU3knTG+1ke8YXq0bpX+2X5?=
 =?us-ascii?Q?7fkcL2P4VgH8qQ7NR83J9c7+lQH7x2h8tby0MQG0sYDIEj388y51m8+YmjSp?=
 =?us-ascii?Q?+ByH0VUWIp+ERXCAoOAsKMTuXAzy3FHupzGRTsfPj+ySgc3gy1CuScc1/HAt?=
 =?us-ascii?Q?jlLiDcFWt9kKXkoNKpbUM0G+JqREPbdTonEoc/EhmAWvkRGe3qNY8YIUCH09?=
 =?us-ascii?Q?mJPq+8GpgoKN9QNzSbtsalLme3aHh8j9qnqY/Ka5dnQSAtgN34CKIQNlizRi?=
 =?us-ascii?Q?wJIIdfVh+0Hk2/kdoxmSKr8OJIULP4xF4lSi4vK6YYML2tBFB2WxcM4SeLdq?=
 =?us-ascii?Q?gEwz4Wsxn8P3/Y/PHjKgXifEJIF3VGx36J0z6HNsGFLQ6LPU66iwAM+Dh9TD?=
 =?us-ascii?Q?0htsSbPxyygGbE8SqDOKcHRCPpeN+64Scu1MbYTX15Ei6+rOz5cmNGXUB14O?=
 =?us-ascii?Q?U92Mhw5UuKL3V7YtW/BUgJL6Av5/rHgQJsw4RB6O34Y9RWx2En07FB7sKxTc?=
 =?us-ascii?Q?ns5b8P/wOIVvJcOSFblOKeicGMIftTAAM/IS6sdXcznx3VRyV2uattb6Qzpe?=
 =?us-ascii?Q?o3g0VXbgDxxZhwX04o7jX6ktaQJHeD92io5Ypl544cP9DItCo6QUuuz6Jjn9?=
 =?us-ascii?Q?st5uGyByeE+NSCEPRiNH8B6YTQ5xZ74HcC/nZaf/Uk6xjAIuY8ULLkxw8m53?=
 =?us-ascii?Q?JERjVr5GCpaZmheeM2tzhIOJHg0lhx4zl9t201AGpAIRzkQ0Xf4/X312nRI5?=
 =?us-ascii?Q?UeQv3QDv3O9gP9nd7kH7c4Hb5DxckqZFW9vpNUsSFE1KPNYKk/EJ8l9VHa43?=
 =?us-ascii?Q?V7P/jS38VmfefElGBoycRO0czq+SDMhxKSDH/vN7rreKFOZbWTCiYWZAxQJh?=
 =?us-ascii?Q?UnphXRHgYxiKekk+Saquq1aQZgrQJrIRzYHWQMqnhk0/PCwA1IsnhQCU38jY?=
 =?us-ascii?Q?Qg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e81666e-4d15-4af2-44ef-08da8122bac6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 14:05:39.0179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v9P7+7NPiB5eT1abvG1xAm+GowqyfbcoUgHYCw2M71ADManK6fP3KZMGpnFVQpisg4cGYp1DualZHUULth2cSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3883
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LS1028A switch has 2 internal links to the ENETC controller.

With DSA's ability to support multiple CPU ports, we should mark both
ENETC ports as DSA masters.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 3da105119d82..455778936899 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -1170,6 +1170,7 @@ mscc_felix_port5: port@5 {
 						reg = <5>;
 						phy-mode = "internal";
 						status = "disabled";
+						ethernet = <&enetc_port3>;
 
 						fixed-link {
 							speed = <1000>;
-- 
2.34.1

