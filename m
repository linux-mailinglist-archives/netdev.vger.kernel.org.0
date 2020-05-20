Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7771DADA7
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 10:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgETIhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 04:37:04 -0400
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:39376
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726510AbgETIhD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 04:37:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hav2+aPNjJTQ2U6dskNlfkHCk6zGra4u+tfCxQ/15bN88wMLgYigtvNrGOOkfHst2OVWI3mT01gcCW/X4gqPpMUP+EZI9cjUuPVJD0mNxpLavmkkh0rCI/23wzqRPEnAegMn9BDzTyfpl55h4ybbhkFy6KzYnrw2Qy/w0oNCaFv97N0GrOjqEL2RhvsdYp6OmjBTVs7wrLQ6vn8K3gO6oW61wcKdCCKm2KCZepp8WG14czH0n1evgzqpCJ3+GeCCOQ0o2xZMmhx3rEB5SokBcyN0wSV7Uo6BwCw0YTeeLTK0GsgE4aM48kVGz4kF+RdFa+VNcmIUKXWQAUmhHI3qTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxokVu4twRqXrYCKThQ+RqrqctBehylA0pxb3egdUVg=;
 b=aFzY66eYyt/hLxERmH7M91MMMvAiZsqjZvJDR+kJR/BlwbP29sA3fcDuaJG3OoerjrtIbD+w6rXXjyieCEkSd7zHDKKzSuIVHeYETt0jn6LOg7H+bHfG+gU0phsYxw/oHCX8za+oiHYAWuqqVFnmnSPpmg0vEuqWaxmQ2NLpkGu/vp1BzkHPDuzTPq6R2IuYkwXJLMtGodCtE3+63hJ8w5lKVDV9LrGjQcjaOfAbvO3osIleIgSFyNSLr3TtVV99n9qZtpPZDJSwEipwL8FRkx0skyI1sG9yzZSX+AC9UfnOuPJDznAVXUCGJq5EG2vClWr8Zop0lX4/MAv0mFE4JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxokVu4twRqXrYCKThQ+RqrqctBehylA0pxb3egdUVg=;
 b=hX5panUD0gjOFRVV3JFYusEMKzKcK+ss9MsAqhq4lh5ZZjAuvmC3Lc2HNxHI2vQsyY1H3GHkFhtB0MaxIXWOM7JFb6hNPwJuP2ImKEPATuakoe1+FyX35a4eLbd5I/ugbkCI+OtNRkTeRsmp2W3OTNvmH1l7nsTeFcNsyluGlmE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3926.eurprd04.prod.outlook.com
 (2603:10a6:209:23::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Wed, 20 May
 2020 08:36:57 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3000.034; Wed, 20 May 2020
 08:36:57 +0000
From:   fugang.duan@nxp.com
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, martin.fuzzey@flowbird.group,
        robh+dt@kernel.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, fugang.duan@nxp.com
Subject: [PATCH net 3/4] ARM: dts: imx6: update fec gpr property to match new format
Date:   Wed, 20 May 2020 16:31:55 +0800
Message-Id: <1589963516-26703-4-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
References: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0233.apcprd06.prod.outlook.com
 (2603:1096:4:ac::17) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR06CA0233.apcprd06.prod.outlook.com (2603:1096:4:ac::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.23 via Frontend Transport; Wed, 20 May 2020 08:36:54 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 141b615b-1d63-447a-e2cf-08d7fc98f4ac
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3926:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3926AC96460ED834CD3D1C6DFFB60@AM6PR0402MB3926.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-Forefront-PRVS: 04097B7F7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8rarYzvVqt0X+jpxzVLoiXCl4rjlwKbki5Ulfa/3dZw80HxXOdZ4rsw41tIWSrbEAYsUrxtF22U941qQ8Ej0rIIHKRZ6n60+86zYmeocolZDOwroRJbXdfqU8pL7vWii0cHe/lQdVF+sBgtfJq0WwrpDDfKHOtyRnJqM+ay33Q71aoCu9yMfHfEuBV51l+kWcw5v5RDa6lmg71Hg4HX1gXlP0Zo0SWnyTTfyhy9HvF2qmAds0Q2XClXuNVY3Z1wLjeGgjyGDBU7BAZrsOS9/zeecn0WvxI16657nuoW5GFVn/LK8DG4u/YiAJzVwa8hQ7yU3jT8ClypTfnJWsL74wyvaDMuFcanY8il0v8ClBgMk8QLgSrPj7zWU8ODGyLQvto+FZXgbPNWXm7JkJrS8ZAsVG4bNJm3J2uZR7I/feC3nXG0UqWmEu40SYp1Jqkww
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(6916009)(8936002)(66476007)(8676002)(66946007)(86362001)(66556008)(316002)(2616005)(16526019)(478600001)(186003)(36756003)(26005)(15650500001)(4326008)(956004)(6512007)(6486002)(9686003)(52116002)(6506007)(2906002)(5660300002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: d2pu68NjlYix6p3RJ4BWl9PU6DMNoL1HCn6hl9SuRQcAEWWZIMMqvLAHYINBeLUnP6DfmvTxOmozO3LxAEKJyfXxx5zuJtE8W7cNZ3t7R4QNHFkk/O+3DZ9lW20MBCjIT9wGn2/ViGNqPUvBe3IMWYK8S1STpzkFPMgx/lJMWHN3ZmcG9ZaoGlX3qXDXHF7dFA1LF2WZUxiLiYri6Gnqht97xMo3/AeA5p2Mx1BIWw3I4oXU8mFZ0VWjE5HW9XfFkQ1wtjPIz8+6/Z/WrGhfHJpXrVrVBbaGWIp8+Lyv/EBWb/PUDlvo4PbfVStjEkVP/X4BMX/i56Mqsk+Qj1Q/e6gPsvSMdwkvWGTFKqu+iIXIJV2NteoRZXbWLmoOtY2PEy1HuvdECC1PHfjpp5NC6Kwu7vqfvKm09HfPNqOvbjbhYU+TDaCXwCjFzDXvGsAnSMokFoIu2tBOmzJoyvax4OTvZaHi3m+VHeAw+Aac8W6tlck15oWZC04TQJqvnTLI
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 141b615b-1d63-447a-e2cf-08d7fc98f4ac
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2020 08:36:57.0901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fc1LMmYKrr3AEG8sG1mJGln0318LfE6oTc3+enLEkVZoThnUz5GMNv6di0qWXwVvSJSgN0pRUNwzH3pIWhoPLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3926
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

Update the gpr property to define gpr register offset and
bit in DT.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 arch/arm/boot/dts/imx6qdl.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 98da446..a4a68b7 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1045,7 +1045,7 @@
 					 <&clks IMX6QDL_CLK_ENET>,
 					 <&clks IMX6QDL_CLK_ENET_REF>;
 				clock-names = "ipg", "ahb", "ptp";
-				gpr = <&gpr>;
+				gpr = <&gpr 0x34 27>;
 				status = "disabled";
 			};
 
-- 
2.7.4

