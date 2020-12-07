Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDB72D0E6F
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 11:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgLGKwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 05:52:19 -0500
Received: from mail-db8eur05on2057.outbound.protection.outlook.com ([40.107.20.57]:27758
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726110AbgLGKwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 05:52:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQzhSG7XOVUF2g09HnaaIgxryM0+k7MNbbGj8U7QwXf07JXHakLkms+HvHKt4W+6d9dSwd5Ya3b3+yKjQxmCiYRa29MK3lmrqF2EA01x9oTwtKcEEufW4YDlH7TVo5dzewq/bHR/a9nueiq24ICK4cyjuVfCnHX1FB6qsassLWEaMYCWV/9hdvaqQhJc93huiSZrEVvu1jAqA4JtpBHzL87ANHfEI4jsr+A/mW/VmR9dukG8YIpGJdRl39oGVwWq2wWRGa2BsWMSeZDdLNuLS54d8MNpd+2Tvl0dHGPcfrZjjmZcb5C/H9wWkY6lhlibV6IyBirXquEyN8Eb0hDNGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=doo9onTCRdhwmmIEJi/JZMBI1U0fOz2FSVIUUVCg3lM=;
 b=jV3jZ7uUJhugc8+TbKYvL312AUV25j4HplDml7/VVb2f1oI6wn7PgoEJWVFhr8uLL3jOIWDhpEDLiB0bntd+4aKf5iZSkNA6T8+UijJHIpE3R+4D4780Q1Q9d4RcTegUaZzUxyzCMsmVrjUSY4zP96v0Et3Y5uvALUjPIZhJBXKFSXiKnHeFlxGvkZkAxbdx/nVHyvNthK0Xyn5tN1h9sITzGYtWg4UCB6l6QmOMwnDdOxbLxIthgapX8eO6SLeoLadxNx6XMcCZrVd2/UVCdaGFXCuKE7esVTB/BblA9jde3ae6YQoo4Le8ai0c/hPMs1Z9hXW9UaqOsA6F8pxCEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=doo9onTCRdhwmmIEJi/JZMBI1U0fOz2FSVIUUVCg3lM=;
 b=KtpLB8KvLPzsXiht7G7ham+beGj5umkh7AfvPhalzeysYqLnMGUfehh+xxCN9zuz0DeCNlR31zQ1T6m8IwqMYBqKyPJT9r90c0eNwysN4MliyiFuGL2SFJIXZ5yAbz6Y90wMq1VgxAUGbOmT70aVx8yO0nX1wEIq79TwJRtJryk=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2328.eurprd04.prod.outlook.com (2603:10a6:4:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Mon, 7 Dec
 2020 10:51:27 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 10:51:27 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V3 0/5] patches for stmmac
Date:   Mon,  7 Dec 2020 18:51:36 +0800
Message-Id: <20201207105141.12550-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Mon, 7 Dec 2020 10:51:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b1d200de-6815-439a-57a6-08d89a9e0c30
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2328:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB23281A76F0824CA0D08462BAE6CE0@DB6PR0401MB2328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5/LwxktCNUkEj4yZDWRss+clMxHO/eapNP9nSxAC9xO6wjonqWTM83XMypz7ds8GYbY+SVq0LONJRltrIp0CXHiCs0iKClj1WT22lEaPcsshXIGTC1A0ZFcgksOGeYBkgKY1rSccEPxpjPw7SsuJ6vKvXq+a9UbcuS2Xec5YveU+X7DCMGLe4Ze5bKrtB9vsCHQvO9gJkho5SrAnuONl59AXJM0olXZr/H33upCrFzKU/uKyeQUrmTzmqXBQZznlIpXSfXmpWuMjd3zH4sbjBH5K09gZEfDiViBzf4jbl1wtzbKkiw3zPMQHPhBWvV+Ex/vh6c9jtvx1yQNygMml+KyaqPZyIjONAm15p0WnFTiSeiwu2OunXhLRD7nx3gmY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(66556008)(66476007)(6486002)(186003)(956004)(16526019)(6506007)(8936002)(1076003)(86362001)(26005)(4326008)(8676002)(66946007)(316002)(83380400001)(2906002)(52116002)(478600001)(69590400008)(5660300002)(6512007)(4744005)(6666004)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rvJgBQmTUTRN6MFLifl1jI5PJEUBPd7AQC43VJKNSDHcp98nh3hg9xGHGqze?=
 =?us-ascii?Q?B/bSOHwtynU3hy+kCiAZNRejwZzxh7tfHLVLvVwmYJRy5OxbOeEDE9nQsT4U?=
 =?us-ascii?Q?WfO5dflcMk3xRoFKCAVUTnFbMHb6XahXvumK9nIJpaF2KqVHzmDwa7p22FUf?=
 =?us-ascii?Q?OVqSK5+kpKeGR/+BVrNf80frYaOVcB6UJY4xG7ubP2KzPKpWHSfl69BTjlJj?=
 =?us-ascii?Q?mq8X4IhLcpnVejD4ej3fQEL63e0w9z43mV0ghz7CSCo/f0li9ShmRVmQeFbB?=
 =?us-ascii?Q?E05rO2J86OYB8WgakwvCipQ8L7BjomvWVp0h2qOwWhy9BmO4fBi/y789G5kQ?=
 =?us-ascii?Q?RR8xFzidlXWJbdLNw+xX1IXbJAyUDx00CnSUDXEzIQCpKlwWEwYFKJAM/oDR?=
 =?us-ascii?Q?gYclheVPj6cw7iy9aagqo+l1PkMruQHpt+R+2tcophjrIrUWMccKZsfNvBpR?=
 =?us-ascii?Q?z5Xy8OuGFP9eOMpotDqEzk8KzlT7vXBcSaOYfuk77MBmkMmCYghE88Lje8TO?=
 =?us-ascii?Q?PKHIVjvekrbPYVoJXQ6hnX2ODqiisRPTvo2YiBkv2OuYfBaqcduKMEcw4bic?=
 =?us-ascii?Q?qCRuspVSQN9gTLP/rLhdHOrR5a+1uXgKR0b/vf2kypZU2bZ6F1Fm/6FKbLlw?=
 =?us-ascii?Q?ppAiwJeWxxVsY6RcGHzyGK9p7pbuDhDV7rGpTyR5ZtwGeG2vBYFsgU/YK2rr?=
 =?us-ascii?Q?zMwRC6vnlmCwPukK76f4DVgeR1WcO/RAhnOY7DrKMiasO3rs7IOsueeqpHwW?=
 =?us-ascii?Q?1xidnVxJ7HECX9w/+N6tee6StTUaxxRTACELPDUjf2wGVaL0FIOHTbQdKdft?=
 =?us-ascii?Q?XulL836YLPsfYHNiS6Zu5IcI6zrslskIgYvI802A0mOYAMY97nbWx/V6mIMJ?=
 =?us-ascii?Q?PsHGvxF7Onj5Pl+w3lUATQgB05Vqsy5kanJ95bftxmxy9ZjKDo3i9/K9x1h4?=
 =?us-ascii?Q?PWP8e6j0uOe5bJeUo0kREgSep17grUYYCn2noGM0Op1V+yHvM3YzDPH9qIgq?=
 =?us-ascii?Q?xuxO?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1d200de-6815-439a-57a6-08d89a9e0c30
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 10:51:27.6255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u1hHtSZpZY/9BzCchfzgEUVgwNyh7HyzeHGKnlH+xZmrzlT2Y/sNAKIk+0XV1DV7l23LjgW9oIcbnCslpUlynQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A patch set for stmmac, fix some driver issues.

ChangeLogs:
V1->V2:
	* add Fixes tag.
	* add patch 5/5 into this patch set.

V2->V3:
	* rebase to latest net tree where fixes go.

Fugang Duan (5):
  net: stmmac: increase the timeout for dma reset
  net: stmmac: start phylink instance before stmmac_hw_setup()
  net: stmmac: free tx skb buffer in stmmac_resume()
  net: stmmac: delete the eee_ctrl_timer after napi disabled
  net: stmmac: overwrite the dma_cap.addr64 according to HW design

 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   |  9 +---
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 51 +++++++++++++++----
 include/linux/stmmac.h                        |  1 +
 4 files changed, 43 insertions(+), 20 deletions(-)

-- 
2.17.1

