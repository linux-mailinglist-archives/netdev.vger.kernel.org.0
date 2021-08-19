Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037243F1E58
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhHSQuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:50:54 -0400
Received: from mail-eopbgr60041.outbound.protection.outlook.com ([40.107.6.41]:55457
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229451AbhHSQuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 12:50:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FCShyYlnFb/Gkqm+/Tr+ZVUA7OEpXBjkxUmFfV3xW1TDhXN4UJgHen85f2hshy9PG9Q2efZsMInSrGg7JTp2CH5L5VkofZVzC8+n3sR5hPH7ZgO6sqk8zOvXQ3jcl4SJrkKoJsEV/Z3ufHbAwBDoT19Z8GXSxvKs+rdVSws+CbVyPtpyeTK6wr1fAAYfSc5SXFrUOTCtfcR8zOPJG7CoHYCBCeR7Z/iTd9zXky50iR+XdcjKDIDGRQeBHkidXM66LUvUhch41dJDu+F6FKG1ktBO36llzXDD3rixjtNDlUdxLXgfWm4/kuuB81CFWklG+s8UDAJ36UGpxXtic3B/qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTsC3HOpR6aXrc5fDi+cJyiq8fwRnN7cbfJ7WAcZWoU=;
 b=dI2ZUS09dHCNq/c7WVC0GwMxXtZHI4Mip6owybnBkC+7oAek07EZrX5UWWQZADVavN6qkmz2Hn/GzHXfR92NUcsQ/2p9xLPdoGMMdc8pI7jFUIVkNuQbPYF7pzQjxpu8vz2lGaAVOuJcOGde1acqyyhpZPp5XV0eQmQQvOtALVG0PqXkZQldvh8uC8DXBfRorF/XY0F9QHaiNokMbdWhBi4AUD7jNaUGkjkWqEKWW+G3eLGZirL6KbNd8gwD3VyFBLhN79dH9LwpU/wmPZ3vOTYr6o0jaabbktvBZ2RwI3udvrsB22IVEqTUa5ZAvW9OmR7zulnSeUUX4Gm6D1qUwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTsC3HOpR6aXrc5fDi+cJyiq8fwRnN7cbfJ7WAcZWoU=;
 b=Tw6k0l151g1WMpHs0nHjdJEbW5rs3jmL4F68wi9f2dQBG4NrxUQnOrJQw78qnyKJDzOjhWPhAjFBygVTRxJ4r1ilNfofVGHBb4tRdE2KoLmZFZ5Mr/vdNruYthIVZ9g1HBk0GZ5nhXtxfrq1a+b+5l0k9Qx8EB48elpmSK1udC8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5133.eurprd04.prod.outlook.com (2603:10a6:803:5a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.24; Thu, 19 Aug
 2021 16:50:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 16:50:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 0/2] Ocelot phylink fixes
Date:   Thu, 19 Aug 2021 19:49:56 +0300
Message-Id: <20210819164958.2244855-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0009.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR02CA0009.eurprd02.prod.outlook.com (2603:10a6:208:3e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 16:50:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85826cef-baf7-4579-00b9-08d963316990
X-MS-TrafficTypeDiagnostic: VI1PR04MB5133:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB513314E2396680082D369C27E0C09@VI1PR04MB5133.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T8h1HbmYuHqg2qjeOHh2W08EdKXb3VmvzAFFURYz0W7rzfIGrNJyWlxBV6VXVWWe62LcZkm+KGskSRq9xXT/NUX3H+KcqweUt3OkEdyQlLi99AN50XH/We7lJ2LyD3mjdJpPyqsj+VX4HY4ErlJ6yNFOtltfi6uvuNBCijYxQA0O80aCKi7dIn3MMxz/zbsSN/VidgAlOFno5MFRY/7vgoEeRXEi5BA2gKxRJwWQas6F4d1JR+rra/il6WzvBvnAi1gobkQT+cqNcYsx0qv4T9UE1wYO+sheVqycjTwnguW+MIaTH3rv3jURmMYr8TUWCVjaMQ1TBFwYMKi2i/OjRuLDvE2QbrcOXNkp9ll+ljs1a8MhN0S7/fhaF85DRwps/zCPDulsse4gf2hmUbDzoT8hPxVnpbfLnIdtCadp4ZzA4Nyp7KjQp0yK+KKiUb828HtyYC2Z/yX70vfhfRIxpSFsOQdlt8usuTGwXjWt39IQ58ZQ7nz/hsb3bDws3Se9HERhSmVubY9T/4t/LaI7gOEhF9MWBsPjqUknAXECJwVpayCFFrhhgcIsujs4y94JMjGdCbtheZmavuXIepqCGZZxCBPYkMMSAx6+7G5gKuqEUqVNlZm30OHi9J8wyVDvqT5W71JSMmU/M1qpx/YFNHrDDsomUiX2qwZkFmBoE9JHQtby3c/q8RvD/68vE4il
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(83380400001)(316002)(8676002)(54906003)(5660300002)(2616005)(956004)(4326008)(86362001)(110136005)(66476007)(6506007)(6512007)(2906002)(6666004)(52116002)(44832011)(66946007)(4744005)(6486002)(1076003)(36756003)(186003)(26005)(38350700002)(38100700002)(66556008)(478600001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r1lE0i+kGaPUHJ9EL2coKbdnVM9smoXaW0W7iKF94Tc9QVDtT8xzyfxsi4a1?=
 =?us-ascii?Q?SKHW7UDWVhg+mR6a6Zhg5TsvhNNhI3B8kJKDH7y3vvsqBOSpHm7CRPZ9/Jk8?=
 =?us-ascii?Q?giEw8YX95mKFi9CyuFfMCO8G9att+lIOsR7+USgaN2YhYxs0oCsQxVrq4Zrs?=
 =?us-ascii?Q?QpfzT0VF1kF1yjUra1iJEPaiVpHOZQB/egshSIANMPIU045V7Ys9gmTLnVBn?=
 =?us-ascii?Q?YLt/9JHp48tlA2yoOT7pvj8/hEBxyjtLdN9EgdZakT/qtSPf0uZnlpA8gEoU?=
 =?us-ascii?Q?ifYTJ0KnW/tFhPMrH3FsAKuW58b3kvlbEwv+2J3YLpTeay6RsaCZHqzMWKrT?=
 =?us-ascii?Q?KrciCnzwAhUiHTxsmHTekYo0LEqMLguoih8/ZgWDuYSGeN6Ne1HClB1EikGZ?=
 =?us-ascii?Q?oCh94bC4Iz/aDrvHVtHd2p5Qc1Oq03ftOp7pb0sqDaXw0IJ3OE4r5xgehAH9?=
 =?us-ascii?Q?Z5jTaEZr9QonOccWZVP+7N8dngLRHTGu/xmp2NM3892qoCoYoXEGhibtDCTC?=
 =?us-ascii?Q?3sUMegDjCekVsZBA2VpkEqOKpQC5ZvD/m81AaXuxjPKDLbQwCDVzBQqWDOCj?=
 =?us-ascii?Q?kqQM66ONczSZWMaGOEuLsunWYiLziNT4+RDQcqaYwoETNXAEwUgZKr7D2Gve?=
 =?us-ascii?Q?RzYbpUQdcPo545Oh5cqN2JGL8h0losWO5t6pICvS22PBaRh7KJ3kOBYwMBiK?=
 =?us-ascii?Q?EWweDvRM/i6FQHxCfG6z9Jch3AdSkJL7rG+HvQxtefquwmi1xMlsv4fNZ+vL?=
 =?us-ascii?Q?eSnAo1Gn5Ljl8hsC7HjVgrJmWfWgswkNGqYw666zpnobwkDXKQYOj+U6Gdry?=
 =?us-ascii?Q?ZwPtVi+/AsJgiyugAK9ENSWkQvSuQ0UfZ7sCGzfVfkWM3OdNmNZ1sE3PO0if?=
 =?us-ascii?Q?qz8IQy0/MbrAfV67NQeFE/lCTNRUoqhbsDE5IPFXLjR/pFUlamt+tnIZbTM0?=
 =?us-ascii?Q?/Wbo0++dwjagAp0W2xay8JmQYqc5QhYXQCSkb7kswJejdHJAXwfl145jFT/6?=
 =?us-ascii?Q?1f3wFwzFItp+M4rcLCNC/QOdsS2xKm8/Cwn4bvAlbiKY7wonMlZlFgWu+t48?=
 =?us-ascii?Q?yk9CPaF4+uccxKm+qUCoTSZIW6J6L70M8FAzpLH6AD5h94B1qk3F4/u6MTKm?=
 =?us-ascii?Q?9CO6kKU+8y3jCtFs4gs14fq7dm8lyrTqPYTeTm4DrXu1lk/ibqSXlzGs8ISm?=
 =?us-ascii?Q?PfrN398q5CAp9GV1Kqx/Wuvsp3BKdazI2w7v4cid2/pQMBsPgK3rY3ZdBiaA?=
 =?us-ascii?Q?DfO1SjbRuGibNyOWthY+ARv+ZqPIqUnXhozwpI7xCO3swq6b/8Wt+m07iYFQ?=
 =?us-ascii?Q?aeqjn9jmTAKQ/nKct/fXeIm+?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85826cef-baf7-4579-00b9-08d963316990
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 16:50:12.7257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WzrCYj6e6AnQWeTBRBwL96f99RVIunNFBhnflme19ZJSd5+XRNIWf8D0HfaRly/OOyWKHK1e+QoTRv9ag5mv+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series addresses a regression reported by Horatiu which introduced
by the ocelot conversion to phylink: there are broken device trees in
the wild, and the driver fails to probe the entire switch when a port
fails to probe, which it previously did not do.

Continue probing even when some ports fail to initialize properly.

Horatiu Vultur (1):
  net: mscc: ocelot: be able to reuse a devlink_port after teardown

Vladimir Oltean (1):
  net: mscc: ocelot: allow probing to continue with ports that fail to
    register

 drivers/net/ethernet/mscc/ocelot_net.c     | 1 +
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

-- 
2.25.1

