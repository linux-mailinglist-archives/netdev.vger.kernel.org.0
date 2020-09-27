Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D501279F79
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 10:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbgI0IH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 04:07:57 -0400
Received: from mail-eopbgr10049.outbound.protection.outlook.com ([40.107.1.49]:61957
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729125AbgI0IH4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 04:07:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwW5HrPbZv1yYW8/cMZ7DdXXU8q3Kxn5AXL4oNExyTDjE92ruX4gFnnF830nntT6QHkexEZ4gYDrrlHjzJHyINDpU6huR31V+YKAyeiiT6WW33pvDOzaOAapyYdWnwYN37jF/KWA8AluzwIE8qjdzFlqRmHfHxPe6sO3PLUy3cNmPRV7lrgZwNX7BbmgvZZvFmr7yutj6A3Ec7JvoZmpTMzRSYij1QyKwrYK92KKu1Tvtu20XNji+lO1PX4xjK1rg7bkwSi7rwR5SxgwtpNM3MelHCicZF0xiMQ96PPocGRPF0oChUZhxXtPO3XuyzfzEPkokxSgRv8Z2870wq9xig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5fHVk91+9KbhV2sHMbXYEe+rOkR1t2kZ7g2Ui7xbF54=;
 b=oVZYSw+iUr8xpBOKfdvwzngCOnMo/S25zSTGJRopqJe02XMMtuWHyu49G5My8vhFogRPf5EVyzmZ7BwZGzWJYHw3+Sc4jo7iRQ8veRyALpoYRWeQSsxNHEugMTsfGr2s7wK4kxBgs0kBGHZaESXggSVf72edN590f84Nq5rc/6NWmeHH9QqOofA/SubRLeagiA62DU1j1p76iqRwXimF+2VtnIFZtvz5c29WzD5bVODr/TyLl9JA438AMK516vEcf7yqYM3+gdvKCrjwEqlA/VWwr34341pTL+hb8Fvze/kmobv8jQP6+xWwCiKvPmlCal7iN8BrunZML7HdRVkSOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5fHVk91+9KbhV2sHMbXYEe+rOkR1t2kZ7g2Ui7xbF54=;
 b=JDnNherlUUxu+MUMd8ijEQJkRy748cP1HpY+wlZv6M2hCqwbGeHh6h7YyiqJ0jKhB+bCHOzEjx7Jl49YYBWNHZ2GdIUdJpK/K1wqgSySV49fouXtR0M9WCrXuHgppO1lJXLd5XynJHDZd6jj7SHvpSE2hOLUDIe5gspLfMlU+l8=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4953.eurprd04.prod.outlook.com (2603:10a6:10:13::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Sun, 27 Sep
 2020 08:07:53 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.028; Sun, 27 Sep 2020
 08:07:53 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [PATCH V2 0/3] patch set for flexcan
Date:   Mon, 28 Sep 2020 00:07:58 +0800
Message-Id: <20200927160801.28569-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0401CA0012.apcprd04.prod.outlook.com
 (2603:1096:3:1::22) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0401CA0012.apcprd04.prod.outlook.com (2603:1096:3:1::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Sun, 27 Sep 2020 08:07:51 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c9022a5c-5867-48ec-584b-08d862bc6ef5
X-MS-TrafficTypeDiagnostic: DB7PR04MB4953:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB495333AD615222378D407218E6340@DB7PR04MB4953.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FYYF9VkfyvhSDgsDXLjQKIftQyYislogOCL5SZ6NQ0IHjaFPSQOQ4bfjxQqk+w1UtdvDrem4EnJub576NtfsUKzkc10tVIgutJ+KF3VeziAeF14ozostpcJ9sLugjtSlX9584nwBbV7a4vJ6qo/IVtKMcFi23xJlztLj5sUMQwjSTmFtH5vRfCFoR7PlIR+YfFGhTmmzCTeLnRnOafyGCtbZzLeBkPFFrrGyGWR/deVM1096Qge/y5oImnu9ZH62OqnOHKqrro0sVkQrrnRRT+swTxuqzD71K9kSnjwriDUP/cB4WWSsSPWyiGVnuP9nhJkOebmUWiPjl3H1/+c4WQoPAR2S3rE4GFAa/d0w+YAoYR3/NCZyE8Hka6CZ6hwrY0Y5Zt7DoNuBkMvVc8ZLyaBOuN4S2ykh+70Pq+GNJE3YfKWJlqdwh4GE/xh4YSay
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39850400004)(366004)(396003)(4326008)(2616005)(2906002)(69590400008)(66556008)(66946007)(66476007)(5660300002)(16526019)(36756003)(186003)(26005)(6512007)(4744005)(86362001)(6506007)(8676002)(6486002)(478600001)(8936002)(52116002)(1076003)(316002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4bc8sSbFyiVhFYGetxUyLtmCncqk3GZJAuEPKwITGGOU8tXMTPpPVhl+L7pBwhWoXpuQwHg8ks6gNi0J1nbiyv53kCRFUXvJAr7Qe+govjV8Vz8oKfzRXBK0zgG6Y/jBscBESCVfvGZrygF1X5MtNeYqtFbW1fkCho8KMQkrf94rp1jK2RncrowWYd1hsafeqLMudKrzmV0CPYJGpszu2D/NPFiX+LelJbVewz6J95W2vpvWZIqKaRR5WTfTMDtNQpCdCuKH9OKlESd6fl4LVYVcUZKAXjZzFSYxmngQMb+aBTbYKxQwHD5reJBWJ8/AbspgXI7OUO4PoLbOJPbVXcg8uSJg7TwvIDM5UAwdR4+G+M4+EWKw3ZqXjQtjMEZZ97oliLyb4z7pwHMuoGRVFU1JszQ92wsgP2t3SPjCwtABjPpU+SUUHDWSKxLU3sf7EgEG2hvoh7z3n7nNEHV/tp0cXrzYwol/9/hXi72/vnvFBY70cLVrR9kyrd93OyHRoIx5oOPaV9l6uE+VUvTCmyPyZS6g+p7u8EF69tIFakKQ0wbipnuhcVLAah7dpGkDefNtJ+Z3L7u0Zv87cN3VOKiHcBpfyPgcYHq/uXeM8iAbXkLqk+ONtpgbsr2/Pbf5JtxAY1aybMxLcllX4UL3jg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9022a5c-5867-48ec-584b-08d862bc6ef5
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2020 08:07:53.0669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mWIhDZFtcrs+C4A6m5JlhMtoRBQNOUpMk0lkEEndxWuKb0ARz3NvNTBav4i1lF6YdZ19VtXYaCDNdUC/keuJ+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4953
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

can: flexcan: initialize all flexcan memory for ECC function
can: flexcan: add flexcan driver for i.MX8MP
These two patches add i.MX8MP driver support.

can: flexcan: disable runtime PM if register flexcandev failed
Resend this patch as a small driver improvement.

Joakim Zhang (3):
  can: flexcan: initialize all flexcan memory for ECC function
  can: flexcan: add flexcan driver for i.MX8MP
  can: flexcan: disable runtime PM if register flexcandev failed

 drivers/net/can/flexcan.c | 78 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

-- 
2.17.1

