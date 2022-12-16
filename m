Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB9D64F061
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 18:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbiLPR35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 12:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiLPR34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 12:29:56 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2067.outbound.protection.outlook.com [40.107.21.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145841C925;
        Fri, 16 Dec 2022 09:29:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSUV9gjeX0VlW8X4r/W7MpnQyv6X2hbbXxjDwB8/iAVNqpz9THMWj0bNtuKPmcmqYit8WT1PdI7okcgCr9OOwwF8HZbvPMmU09swSlb9R1O+hXxqknJck2PeG+IOtBz3v1aaYua/0L9y7/nkgzbn4Se/TV+amSmXbytdwb8RP88j1K3fHdXaAYcPxncn/ODeu8MKJtsVumhg5KSTowrjeRP94GmU4PhqFC+5IuON2vFOelFAbAe2Dh1B5FgmgOFJqwuIs6VzzdqMgSzH+rIgdKzi+uoZly0tQNH1oLXpuuKbYtBGM0PMdTc1lUlz2OQMn5+pF+KaqqeoL/VP4JPBnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S+xhH8Moa8hkHRlRXK23ziVEnHtlvyI9ZQTiHvf1LfI=;
 b=n2ycGpscAQWPadFUc/4dgx+mtC0a5igXF7E2x5w3byOFJZNbN5KYF94ULliByS9//cE/WkijWzqtb3trTsl4/ZqthQXnyhSDyYS01dTwwQFRIpxC3rPqErt9TC1JsW+iuYB7+YtH4qey2AKPBykH1Wyk+UJQq4ROe+3idwBwBWYi6uwcmT3au/yD35Gtrphi6GH8Tr8sN+lQ/SkGwcy4OQk8AYV6zN4QaXeMOtS7ttU8fIszyE5pjDJ0GvrXH8jGkmhImZTIOLIB+PfNwSSTprhCDl6po9m6Y19tipoR1SXHSK8lI9UN/WKLKD971ie6UY2/inxOvWYMhLakuMDFvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+xhH8Moa8hkHRlRXK23ziVEnHtlvyI9ZQTiHvf1LfI=;
 b=mwGmVoZrvYtxKHzNYoXxYE/ZtR0boSkaw1DG13EHtkyuDQ7LkMBmT5HE+kh0LmUwwtnvGkivq6k0bG1WfzeAkdaThYNu5IsRUYmBYjeREnyUse4fDjAxjMF+B4LwlW4znl6oong1Xnq6HWDXmwN5btWSoM+N3TWL4ZBTVamuvq/YLMEL+LOXev8GQaupdV756Ur3delqgYuOWjtxaB98gboTF8N1KQ5+vS9kr0CrvERFy/MG6ExudpJPb+QR0SoP/YPNSUXzK6Stkpc9VSgAXx7KLDS1WLoCmrqpOuo8N/cssnSDzd5RvnflCCOmU83KUou9zzgXkpl9giavgSqpKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AS8PR03MB7317.eurprd03.prod.outlook.com (2603:10a6:20b:2e2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.21; Fri, 16 Dec
 2022 17:29:48 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%6]) with mapi id 15.20.5880.019; Fri, 16 Dec 2022
 17:29:48 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-kernel@vger.kernel.org,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net v2] powerpc: dts: t208x: Disable 10G on MAC1 and MAC2
Date:   Fri, 16 Dec 2022 12:29:37 -0500
Message-Id: <20221216172937.2960054-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0280.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::15) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AS8PR03MB7317:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cd14318-ffc2-4e26-af39-08dadf8b21ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m67gAIMq4bBWtyH8F2/OW40L9xTeMSpLgL9JbE0U6LUGWETDkldJNBlNkbAAMrWdlR0gJOUG8qC1kTmITcXcRzqYb6IyhgKkzlZ7kg4KsizXp+ZCkpdIssztFU/HqBUqPQ9Xtw0PzyV6vCpfRSTNwErwCFIYxogzD2raX8KqUASxrqivzXoAgZzT5C6JPIdKyRiin8nMkR4nbgB6iZlsNUpSJNPj4GiiDKc0/e3cXZKnpGp4zaU/8A5V0Xhap9xJD836584kJoSQbSi0I3lEHqYtXJQX3i0KFBb+DHiFQ0Gyi6GF+Bv6IntTrbk3wxbvvglYtkQjYIe1d4MHEN4Cp+A1DWxKXKnTrzewfjsTaixVaHDvH5S7GQOrCH53BqVXz9tX4jfXK7CvTduz4mbPajDL3vToL4PSn45k0f47ZIOCMoS9ErKXCbETuSqjhwAla7Ptv9CimJRFOiNCwEXu6KxXTAwqG5EaJCY3mPP6GSEcdEgUgyCQjzz8z6RetBjzUzUximuV3o6rH1Qzy8+cqzSiicxSz6nhdOXeYBAhMhrbibxHIJkwsqX/zeYic9bScwUOeQzWr/B8gMxv1LaFTIvsI1qWUpcwBAQg1+akfEfPdHhNwsPVIeFX/iWZndJruPaDweK/nmxgyBpOHrmTRK4n94N1HSkxJoQfIiQdTpacYNNa3Ek4yt9ati7EmGus9FK2P9qK+5pQN8f3TyEvMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(376002)(136003)(366004)(39850400004)(451199015)(2906002)(5660300002)(36756003)(6512007)(4326008)(52116002)(6506007)(6666004)(8676002)(107886003)(41300700001)(316002)(26005)(66476007)(6486002)(66946007)(66556008)(186003)(54906003)(478600001)(83380400001)(2616005)(38100700002)(86362001)(38350700002)(1076003)(7416002)(8936002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qzsj9LW/FKzVBRu3EJOeVGqDOCaEfZfXfcujqeYk77gJLR/oxexj1sLEhzeJ?=
 =?us-ascii?Q?buvfgQ31fVj8v+AZPO8oK60/jr/4NyOF+MmB4lmxw8991YfP3/igmXMTJ9DY?=
 =?us-ascii?Q?hhri3ktOLS9IYx24EQN79n3MpyoBYf/16Wr7QA939YR/LyWJ8yb4lMLi9QPX?=
 =?us-ascii?Q?SHVTeA/ilbrZjncoH8TXMpExputjy786oKY45GoYHVtdgR8PrAsXU93npjJG?=
 =?us-ascii?Q?jlyQBLxbnaxkL+g7hC/rnLvm61SPh9ZN+eEWuaNmzrrf3z5dne9CaQUK5syC?=
 =?us-ascii?Q?CAQ5H2MMa8VHBGpFPllotk8TttjyjgwF3NIcS23Qm+s43YJRe6D5DAt34Ib6?=
 =?us-ascii?Q?q/53AjQBA9sgib3aTWN+p2gF1i1sm9t7CkRTsJDW3ky0fQNfIRdhg6EDIvxg?=
 =?us-ascii?Q?fTcbeXDAgRNPn4EZNcqOh5PGiQoKKQkuBgWMRlhi3WOynolObknD68sPuTU2?=
 =?us-ascii?Q?b23R/Ye3USbSFp+xoxdypXLZo0i78fOQqAy4Uy1uHm28XIxOLe1g54U1DgVS?=
 =?us-ascii?Q?srhJOQ6IMp4FHg1UbYLDO8knM0qzTo+z/t61cgLy9N4RS6dwlPpDlRi45dpi?=
 =?us-ascii?Q?h2Ccn1Yt4brlPm5uL2JzEqQ6VUu61b9Ir1lyyt46HQ6z4RwS1tj15Engi4Q8?=
 =?us-ascii?Q?Kr7VdcyHoapsEkuSkXf8djpY7JRonkgh6n/N2let9jxo0cCsWFm4/zNDLuBK?=
 =?us-ascii?Q?cUuv12ZnU3PIXaAr4uO9WJYTLrjafMeVm/Lp0lk/6sKA/aopMG7o429ZOc4G?=
 =?us-ascii?Q?2rW2CVR/0FQRCCrIDM21UV4andUOrZ10ZjP/joPgtkORew69kWGkC9Q116jY?=
 =?us-ascii?Q?pGR+umPmjEknVk6lvcZs/K1X5s+P8zCpYDOA5LCKHm4Ph5nC88JIr5d0GCp0?=
 =?us-ascii?Q?69kelw3wJ/GvITnFMgkLceSYCRUa6YyDVxoGV2AxgEkGFntjxT3h+3HvddOL?=
 =?us-ascii?Q?LuJ9zycOHk16YyQWholZapIQepGymZdTztcnffPssOuhVhH8Vn3gWf+Ohfok?=
 =?us-ascii?Q?Nop9ZeR8v2zXeBPlwBld0AelTrrDgri+XreGAB3Iidoyq9AcSGp2HBN1I3rS?=
 =?us-ascii?Q?7RFYBw95SnO1NQeB3u1Bg0Vc2mQuVfv/gtr6bejBXVic41yQsxrOoA4QATXg?=
 =?us-ascii?Q?+01LsfPUjpg9FrkgjxpJQ1H3OnmCmK6XMN8ZUTQXzsQCpIVkWf0AQmGd5/Ax?=
 =?us-ascii?Q?IMYIWTCdfyb+JrP+73p0npBS/wEzSs624HLSylp+rJdZgnvxpRpzKC5YZ/vw?=
 =?us-ascii?Q?VLku7di3spNWlNV5i8sFgR5m/5KB6xGi6XATbXprW51yGM8sJnvfedrXK2Uh?=
 =?us-ascii?Q?yjWQjNODyaSk8hHZKtv4gbKbYuOTex4BsaH26rzDqtFXGwVQefdiaLEb3Lxg?=
 =?us-ascii?Q?J+ZOpyXJsvLtX2s2fC4+a2MmYTh+Jo8U61m3COjEGmOdB6zjgRFB7sbmjHaf?=
 =?us-ascii?Q?neSqoEiFYlRF2uL/Ssgco0fmx824cE9Il7RkTl7rd03Zd+UqOupMX4qL1W0o?=
 =?us-ascii?Q?TiODBZrlJMs6GtlAuQO5dnlmygYX3Nof+d56KMQhucmVnAEQGdYUIAN8HPG5?=
 =?us-ascii?Q?ZOd9oBp2NokDwRkfkt6jY+92d/pZExXGIRhEm9EU4YyO0vHr4rvRpTShmVzv?=
 =?us-ascii?Q?Ig=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cd14318-ffc2-4e26-af39-08dadf8b21ac
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 17:29:48.6946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j+ygVAzzCUkB+JpB00F0aUw8CkUd9/RHNwauWU4+GxACOPUkn6EyGJnTwpAu8CtKqreZRciCGLHb3WNp7cajHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7317
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There aren't enough resources to run these ports at 10G speeds. Disable
10G for these ports, reverting to the previous speed.

Fixes: 36926a7d70c2 ("powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G")
Reported-by: Camelia Alexandra Groza <camelia.groza@nxp.com>
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- Remove the 10g properties, instead of removing the MAC dtsis.

 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
index 74e17e134387..27714dc2f04a 100644
--- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
@@ -659,3 +659,19 @@ L2_1: l2-cache-controller@c20000 {
 		interrupts = <16 2 1 9>;
 	};
 };
+
+&fman0_rx_0x08 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_tx_0x28 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_rx_0x09 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_tx_0x29 {
+	/delete-property/ fsl,fman-10g-port;
+};
-- 
2.35.1.1320.gc452695387.dirty

