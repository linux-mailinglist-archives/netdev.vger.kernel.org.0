Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB58838AF3D
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 14:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242269AbhETMyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 08:54:03 -0400
Received: from mail-am6eur05on2076.outbound.protection.outlook.com ([40.107.22.76]:30368
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239112AbhETMwt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 08:52:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDoMrkwYHpekivhmpzfGQcklOM0UtlFTgqDrxPppbn1bAiLlT+T7K2xsrC6dp3DsV10i+0KfCfrgCZ6iRQqHIQ1FAASAadgDWQpO9Ja7b2xS5crBU1TjjES7vO7xI71ZN6zWjHhgs2ga50gDtHkIQnGWzI8AKVVi7ZIh+xlfC9DJpVnxV03RBs70vknWb/7StU3AoZVMX/YOsuEdtJHJwUx3fWMN5Ob7KNmXI6zZDRXGN9rxDBtsQZP/kcfvt84PrKLy1il76EkGKnbmmXwc/6PUtyo0GEG/yd+Kx3ll4YkuvaLVNTafc5gV7HXoBNmKTg5hPkiNSY5UAfZT9zk19Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUd9gHWKY4KFonZjNaSln/L4ymtPZbQGc53YbgZOSFs=;
 b=FQfkuVkN+9GmGE0XJafM17JlsLgx5pxfH9/paJocafX8DHcw2f/o3A2UWnAKDGqAtcsb1tFq3EZQAKqJFKnls7HwEr3EN5v/e67goqQ29uXpZwWdHYhxwCICF9u0lfaMh8kiT6lVyiArsxXbQX4Qrj4EIUs7G6gy7wxSyh/jlTor2iy9WP1IHuXzF5VmWR1I0w56/Ac2YDm2ozDklODSepoRYu5AmVTR1nUNDQyaqxUE76rSuPdvtosBt0Z28gOzSptnIDFhQS8LjnhOP4To/ZlR/llx7KS9dLT6xvVuqVE+CR2yLrIJGsrsmXi7Y1NQEta8IYnPojkdlG6p2RYtQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUd9gHWKY4KFonZjNaSln/L4ymtPZbQGc53YbgZOSFs=;
 b=kGJCt2CY3wchzVRmTRFz4AjzKLnEM1QMhLVpZoJHoW2T0S+pQlWP1qEJ6hmY3ha/3hbbreRJsj8xy9TS4GXIhRHSmjM8YhyCEJiqkDfnROb8QDZL/mg34whFM8chsL719S7cKXdIq2Yt4C2wnNcedFfXvwvplgRTr3ey1LC1ezs=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6345.eurprd04.prod.outlook.com (2603:10a6:10:106::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Thu, 20 May
 2021 12:51:22 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4129.034; Thu, 20 May 2021
 12:51:22 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH net 0/2] net: fixes for stmmac
Date:   Thu, 20 May 2021 20:51:15 +0800
Message-Id: <20210520125117.1015-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR06CA0095.apcprd06.prod.outlook.com
 (2603:1096:3:14::21) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0095.apcprd06.prod.outlook.com (2603:1096:3:14::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.32 via Frontend Transport; Thu, 20 May 2021 12:51:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ccea174-e77c-48d7-6f8a-08d91b8df89b
X-MS-TrafficTypeDiagnostic: DB8PR04MB6345:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB63451C9964F067A62CA799D8E62A9@DB8PR04MB6345.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w+skr8sDJ0vrsHCuo0rZHLa+W6+mfNp22UiqwwYaSBzLsS0Gy/uHiPceqATjuesgQg9j+7bXIeHNWZXYLQBreFJUeDA/HXpaA6lJtGHHoekgJNQDgFMko9QL91sYERbV+bVmNUSKpTsYouPQjlPAXJHNJKhTx6EKJ6z6M4PhKVEnU9jD6J4iYNP2ley16zM8+uJfa6ACDCYU+Ije1eVWBIzA4/oNWNjnPxGXxy7Cns/OMiUvevIs9SiM6CUG0UBm6yz1EdlsAwt47vYXxm70I4jTz5f/u/xNc/M+cF0FtBz+9z6W5gHFx4E8dP2jEdg122x+lyR1Sb3QCYFJycUbgaRvOOco8IPQufGqXWIlv0Thuxomc0yN8eq8Fqbt+anL2rg4mnofX5P4hBeAIiWvrNmrK98U9V6YGcomg9h/WeWcRN5nGytkyGxkr76kZt1O/Ta3IHrV+hnHS1ol1kRMsAyM70EKy2J7AbjK4AAbw0UVFsD9nqLwn6SH95TvnNAgY88ci+LwWmBBdy51R3jDY2tGDD1Jfr7FQVWz8Z3pMMqu/idmB6ENgshKEdgclnF5f2TEImgGjF9hPmXnXTE5yfnm72rKe7thiwQXyt5WgjsYzl6ijor8OfFNqu5LwiGQdNZMtyzj+7zr2GemnI5Z3Jg+bJanERN7dKyIjyEIOPMWloHT6QTkwUbUjjvYGu1m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(8936002)(38100700002)(38350700002)(6512007)(956004)(36756003)(52116002)(4326008)(8676002)(7416002)(1076003)(6506007)(5660300002)(86362001)(316002)(26005)(83380400001)(478600001)(2616005)(66946007)(6666004)(66476007)(4744005)(66556008)(6486002)(2906002)(186003)(16526019)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8jjNhzL+ACmp8ng7G+BGRimCddpOKFy6iT4MZUE7H5tmoDwFx6qAq8Km7OAT?=
 =?us-ascii?Q?UMAGzKrYeQ9P6lNHObSYHoJxgLnUnWzz1KY3cI0gDXRqCYKMGd3kkZ1k9Qyf?=
 =?us-ascii?Q?3m9E+tAVPG5Ds5zJBsddeWICKPzxYfRnT5ooCbTm2yQ0iOPKUN6GJfsXWRXG?=
 =?us-ascii?Q?ho3fp1BfeCe0VEuj4qHC91WPmplVLSiZ5fehQmUovc2QEoYKjM+GoeZ21TeD?=
 =?us-ascii?Q?BiM0C5sAp8U76UD4zGx5i29mVa6+gLZck/BIjH/gE3ArgG8iMGSAuUzK8t50?=
 =?us-ascii?Q?8sp6WAeCvCvXxUeqzHrgytaIspeh2vdAqdeTeNG2eZhlnH6wGgiRSed2Ym4O?=
 =?us-ascii?Q?U5/mihl+syUB9nDEsEdzXVNDoEzpsl3Z79Mmd2pVUUdeiKiVszrPQ9hPRVzh?=
 =?us-ascii?Q?8R8s87KCUc0UMxj0S6+gs1CK6WLMoKmdCWvUye35VipOHOd8EQXiilGlpmd3?=
 =?us-ascii?Q?WeAmPZRQ3R0PDGW0fM9U9pGDo4pqEEdadaiWkYGHpIQiyiBHMwamRChq6LiA?=
 =?us-ascii?Q?nOCupjkyueQrhWEET0CZRoxW79T+jNthx4m0oQPMsXSwnR6UFV3jzJ+6ASV2?=
 =?us-ascii?Q?ceL0SMmPbTxAp9z1/0dRpgY2TUV7+t48tfMEFDPiOH5c5tlHJwCKKgRpcvfZ?=
 =?us-ascii?Q?j+22hZ7ggPlL5gDtaeFYrku5u+WIFYnNDcnYStGETTbL9ZO/gZ/zDS87jryr?=
 =?us-ascii?Q?xmty5Wf24Cc+1WyluoeZv2mnAhdY7tYgwtstZp0UpQHnQdCT0nfCoWU+vUIt?=
 =?us-ascii?Q?pScvrBPP8lCoMNhrV++SA5I3XooLi+td0+z5WZ/+vYJWQ4YyZp43NSr23y0o?=
 =?us-ascii?Q?kT+lws2mQTsCVGa/alX+hDy02q/6d0sNmvVe9TedL0zt5mNvSlNG9i/3ZCDl?=
 =?us-ascii?Q?W+Sks61E7EjiWUVgllCGxPPet8L0kh0rTq9quHUueyEn4bWuHegKfMrCkHmr?=
 =?us-ascii?Q?eS7KnDCrafcMQuFqpfPXTkb5nlqiKYVe+uP9eky03C5699IybK0bm/5eZm5o?=
 =?us-ascii?Q?pZh42sDNSRf5Q51e/OnB13Wvq4UuT4Lel2adtNe8N9TNRY3yV+aMrPPXR5AC?=
 =?us-ascii?Q?GUOzZ/Ct91Mfxao9YXpFxkFZtXVoObSlvLIVLIq2QrJ9XSUjvw5vhgsEjEsQ?=
 =?us-ascii?Q?NqOv7K5SJZX0DmmxBck9H5+Z6QErUwhZMqCZgwmXsMzIomfgwmtl3wIaNLYg?=
 =?us-ascii?Q?If1UNCu2b1jQuBOTgDl9R002ud0hLbvOUtQ9Ze+UbRIMYmzkoBqBRpgARLbZ?=
 =?us-ascii?Q?2L18z6JHzTWU9SwGYxZ20HbSam2CaHl/ifv3+x5sQ+OK3xENS7SdZpxT+TJd?=
 =?us-ascii?Q?0rTmmBEUYvwdlQ2NJi+t6gk6?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ccea174-e77c-48d7-6f8a-08d91b8df89b
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 12:51:22.8425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ih1D8OYZ0yQBZXcRew6n2QJD0tVGD1hE/a+k6MkTECTOq+TxDCkUORGyJhRaNBGgJkhvkbtd6bIefkEyWt5gCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6345
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two clock fixes for stmmac driver.

Joakim Zhang (2):
  net: stmmac: correct clocks enabled in stmmac_vlan_rx_kill_vid()
  net: stmmac: fix system hang if change mac address after interface
    ifdown

 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 23 +++++++++++++------
 1 file changed, 16 insertions(+), 7 deletions(-)

-- 
2.17.1

