Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690912CB7F2
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 10:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388004AbgLBJAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 04:00:35 -0500
Received: from mail-eopbgr40057.outbound.protection.outlook.com ([40.107.4.57]:12974
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387831AbgLBJAe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 04:00:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRK21KtxV31zGV1OdbPufwJpj+nRjTlOyS+Fcr4VM5tdvtplQNenBmuOC/Gd4t/3Bdvfynqd+0cu1K1eQTVG8OIw0p6/4HfSUNcAuwB5jyPzZVWaTX0UlEOE26wGfsmqlh6Uw4LDNPi/A5d8rVzRJ4eX+HxgMaDukYvCx4u+RpjBRtwqcFJ1p3IxzWafG7uc9PbBHHvUHEetohruZ+wZkZnUMcCVWkKO4MzHfBiouQ87sK8iRX7Q50AiDqrrmj4JkG8gnja9LzPUkCQpG5iZntl3xvU6H4nMtKIcaYHYJDZPI5SYYNs/UAzKO3t+RX5Ol7ML8UzjjvLMovfJw93eBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5od667ObrDQCT9dIfIeaI2wy0517Y9vzzDQQBrJSVVo=;
 b=XX68VLxapDA4p0vtgw7c2WXzQA8bfkjJbZJ45wpZi8xRIlQzOt9RUlj9BoSqwWttLpngny9ki/hYee7IT6YVk2FXcV6/AoAq63DunRZqfP/EyvTERgv4DCvuH5RIVlpdLfEp9nYU5I++jveSvcKAIzOMoevvgdIy0W/7SZzekUUzWjRntMMex8tsSCHqiTvTPNrnO75zovCrXsnLjPyis2IvChoxRtDQ/yESCc9OQu+xRYq02okyqbbT8O5eBRFsdlXEKotZYNAGaweZhCXFklA750XyXexNKTyE7pNuyZ3H5OEDMb2N0RU8JLBVuXOA94lmjJ+mISS5bXy34QiHXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5od667ObrDQCT9dIfIeaI2wy0517Y9vzzDQQBrJSVVo=;
 b=FbRs2ZDGJ7fEyUwNSr7A1poDsE8LOv872/27dvA6Mlmz03Fvkn7sQZwuytBAq4Jj2S1RiyXlYmjWemn9hCZWMgIEeTeET1e5rOcLK1fWyuxSRZN73SvobimMbIwOtXKgdSzskNwa1po47qzCML3CG+esJJR0E6VKxjcORRrTsy0=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7432.eurprd04.prod.outlook.com (2603:10a6:10:1a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Wed, 2 Dec
 2020 08:59:46 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.017; Wed, 2 Dec 2020
 08:59:46 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH 0/4] patch for stmmac
Date:   Wed,  2 Dec 2020 16:59:44 +0800
Message-Id: <20201202085949.3279-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR04CA0132.apcprd04.prod.outlook.com
 (2603:1096:3:16::16) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR04CA0132.apcprd04.prod.outlook.com (2603:1096:3:16::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Wed, 2 Dec 2020 08:59:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7960a97b-a839-4574-0439-08d896a09de8
X-MS-TrafficTypeDiagnostic: DBAPR04MB7432:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB74324551852D041CCA48B6FEE6F30@DBAPR04MB7432.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VsViutgCoo57gBuwTlUkp7UAz9jNusUi0HYz0eMe0io2qfHY2xyDQ4kwqSoePLtfTFI3IKKS/zZYvmR11e+1B5HHgvyrmL7cLHqZScr/iq1ZFHjUMikCofFVgT5VE1unkSbYdoJxUdL3JRc7F/M7moPi80J/9K0TSA1BgY7WtdOgb0R0kM1B4OpJ8zSKFSLCUuEaKE91PITuxwhZ5m5/9jq+Fs7xtr60vof+zzcgPcsmXFMyUOMiZ95eXYlhGqTk/SAmEBTmV2GXs08tlyqocA9iWMVJ8jIXCZRLhmrSDL1+m+j6Y5Gd0ZSb1eCRVA+3cy/6Jwum8fvlEFMp2mofbzTqmJrumtAivRQ7UnJ+wqKjJgFqCHtoNC5t2ygfdy14
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(396003)(39860400002)(346002)(8936002)(4744005)(16526019)(186003)(8676002)(26005)(6506007)(5660300002)(36756003)(83380400001)(52116002)(478600001)(316002)(86362001)(69590400008)(1076003)(956004)(6512007)(66946007)(4326008)(66556008)(66476007)(2616005)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?756BWRGbpNExzx4obOBdehjOMUaVuqHRu0mDcnSMNGkgchVIk+j5Qy3lg9rL?=
 =?us-ascii?Q?dlOZ/1RRMlgpuUBhq5/OEnkGoSrgE04xKEWyS05TCdNYZ5kW04d3/aaZIe3C?=
 =?us-ascii?Q?ARZC/wf8CFdkgyEmkFs6jCR/Ks6BWusWd61WPf/0ZrQrrq9OnnA2dTHTlz4R?=
 =?us-ascii?Q?X6L+5D443AMraLVkEmxW51cB/YVZ2N9R5Z/petBUyYdsNp7GopCo3Ub0h2NH?=
 =?us-ascii?Q?n98Y3o53xbutzBDh5LUVHZ1lUAh60uEIIgEFYiwSKianfv1VN66mgyNoesAl?=
 =?us-ascii?Q?yDL5l5+G/rDzrxs1thT+6pttmPVQIQ5jyj0wkteJRot5p0s+T5CRSnYpWTR4?=
 =?us-ascii?Q?YEDtQb4fpQ9QO9ZEahHfOf7mGW8bwr4gt5G5FIM3a83u7zENQX/Wj5KlpxJu?=
 =?us-ascii?Q?wQBz/biOJxJHSrJ8jmEMamENm9fJ7O22k1KxpsXmhhbeqAg6miK64FlJGtgG?=
 =?us-ascii?Q?U2ibdxKyL6tM+vFvIngMRcM7CuJjE4me0GwVgY08fIZfsiNQ3xp8jdnl3jKi?=
 =?us-ascii?Q?Pow2RDvoa9ck9rcbxit1X4SdrbqwBr2DaNxMnB1dkbdApf/4l2xC/ZK3IYNg?=
 =?us-ascii?Q?ibyMq43/dybYLX05xjOJoPyDm3sOVETQ0uVpw3UwmLhj0mt2bcNrmywQY+Ut?=
 =?us-ascii?Q?qyuAe1o3l0HzeRPwLAml8vjwEsnCaC0dVPOAd3WXRGyUlFiXprFex04gbxHM?=
 =?us-ascii?Q?tA3lV34Akinynkgi890pN+tvMw4ULE7tEm1EwlHnHmFOiAnN0w1VPsXVXFKc?=
 =?us-ascii?Q?IJDalnXqwZMq2+HmkiAd9e2mvCOpNeXb09hUVxdXAtJHLVgSK+tmZ2iFeayG?=
 =?us-ascii?Q?r1VUXENQCd9c4BiUK1D+f2J2sf4tvrJcGAc0SslIFO2QkK1E3FsdOVDPwhPm?=
 =?us-ascii?Q?3hDNMmDfuKIIUnU4gTVlLkZersgvBSZvFkAGOhLLkJl3pPhUAR/nODeVtxGj?=
 =?us-ascii?Q?cnghp10zi3GyPJ32gRBsjZM7DOTqhjZtkUEejJGt2UdhO36HdGRcllDp7guT?=
 =?us-ascii?Q?sKIG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7960a97b-a839-4574-0439-08d896a09de8
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2020 08:59:46.4671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oaTh2CWQHIYKFCmkh83VYcdQHr6yx3za06VWc04vkCLhQwE2m/wIIJoUZUj1TMjdkcyUX2oGF54l+LcsWrTKTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7432
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A patch set for stmmac, fix some driver issues.

Fugang Duan (4):
  net: stmmac: dwmac4_lib: increase the timeout for dma reset
  net: stmmac: start phylink instance before stmmac_hw_setup()
  net: ethernet: stmmac: free tx skb buffer in stmmac_resume()
  net: ethernet: stmmac: delete the eee_ctrl_timer after napi disabled

 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 43 ++++++++++++++-----
 2 files changed, 33 insertions(+), 12 deletions(-)

-- 
2.17.1

