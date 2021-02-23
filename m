Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1808E322902
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 11:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhBWKs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 05:48:57 -0500
Received: from mail-eopbgr60077.outbound.protection.outlook.com ([40.107.6.77]:46106
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231410AbhBWKsy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 05:48:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKP7KpXZ6z3jnhDm/vMXvEB4AyJjaCvg4XvvhUeMeoQUFuLpL1vhUUJFAwDR5zzOlF/U2/EadRPVuBA2j8oShJDk/rhjHPmRWyyyeH8F4Uv8ZtT3XUG5ZRmTwpwICl9VJfRwoN7UTpzxWSuv6a09HSZk4BU3IxnGkZCgpcjDedogQD97Ogwk/XvaF50dXiwC6F+ZvFukggZq/EeyHkVpe4gVIdaLvLmIlAQCG8BELrWQgNmWIt+wxQMPhCYosNLUKc6AlIeAGU5nxI9NOe7YtU7d64p2iw8XBHID/GF7CX5y8QUauknGMDzpNCBYIXjGQJlF1WQp4eEVw8023Z3jhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEojPiR+UPx2pT6Odzndp6liK7AAALlRgQSON0vhL/4=;
 b=EqhGr+M4OTllFtN8a7GvhgJ4JraFHCcu0UeKRGvlo7N/xW8niVrGl/8sQzm+xpYZuViCc9Ff7Ow/GRe2pEb2CVZfxiVHXPtCsCx6il8APRGxmHYa4K4YJqQOv9V+Kh0Q/D4Q5qdAjoGiNlULABPZvkONpde4FdyeiJkQxn1KbMb8wz19hz+qq9vovq+DN2rOeU1zvG8lcxq9oA9h90EDV2nmjKN1I7lwcIGfBUtrrRbb741k9BlbMcot0Ifjq9c8UVfvvR16AKPGp3xVXYG+zu9nghQgLkBX+oUppF2VsbYOGjimM2nyfr14bDVdmDC1GIrwMLvwCTZHziKIiEITNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEojPiR+UPx2pT6Odzndp6liK7AAALlRgQSON0vhL/4=;
 b=cN9pWVc5wPIb0cJ+ZxLw1G49K2uTxK24sNEbmgFzi5uGqkrkPGvAYG9KY2SO7TROuRS0k5h6txURP+V3MRGqmjsDx6y5PKV/oBATnppYpUnh0KTQ7LT6cqGuuBIRUWRyddHRbuePXjbBqstiW916n0nrnigNoFPVBg6nx5p4p7I=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2728.eurprd04.prod.outlook.com (2603:10a6:4:97::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Tue, 23 Feb
 2021 10:48:07 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Tue, 23 Feb 2021
 10:48:06 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
Date:   Tue, 23 Feb 2021 18:48:15 +0800
Message-Id: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: MA1PR01CA0162.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::32) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by MA1PR01CA0162.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 23 Feb 2021 10:48:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 84802dc6-4c69-4526-8319-08d8d7e880bb
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2728:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB2728D788DE4EC7C602761689E6809@DB6PR0402MB2728.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G6QeCBqHQNA0qLTGBl/siFGMzF9pqIUtYz3MN59qKJ+NY6SL35/ovHTVMAOFFDHkP54TJTort1F9Gs2WwaI/M9zjbJMZgmnqv7tGoAgnI3B34Z8qEo+7tFRTyW7DsxB6+e4YZTqLrmCRcNGS2wZWHV8oHa/qDCoR/zSNuE8LMi066xn4ewo7VJ/54xBfoLq8/HjZGq2APiazgx7iGQ5BP3S8GzMbKppXcpS8v2+RaQ03e7pULHDckLH4RrWodyFeR2GfJPiGOVW12F23FfqttFmP+3FR54waYwneqPCSxycpa6nsu6ARzY/98bnYsutu6ffq6ccb/hpphblmDJBFlMnNyhMJbbaNFZvFr+hl71Ba/rUGIGbPONBGPHwtiYX+Hovr8Usdj8YJ6tXF325iIAA7alSpDfP49HJWTQdK9itytYBBHIRXWuRf95VNmn5+BZJvroTj99KrnRy4ujY15l7VcKTXFWCZodr/Pk4iJ+kl9IBgstZB3l4oowvM62NHUdJIoblH4EvCQCWvR3rWTtO0E+mruyVqqUPfc8LmY58Ka6n4IcP0bXbgYkGQk1iKv9Hj55xBSq6vkeV1+MwCmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(83380400001)(2906002)(52116002)(478600001)(186003)(16526019)(956004)(6506007)(26005)(66476007)(1076003)(66556008)(69590400012)(4744005)(4326008)(66946007)(8676002)(6666004)(6512007)(2616005)(8936002)(5660300002)(6486002)(36756003)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2d4RWv8xo9aq0MyjbgZcwOyOju18S669r+Yn8p1rHnH3FDH+cXAPyydcBWXKJUQag5+CKv36En6D5VBYxEvAhOsos296dgguZZgDBx5F9DZkDq/Osav+lA3X+492jRn+enmJNjRsVoFWBct4N2HbO2NWshQQDnc4MNbBr72raBTnAkzu4TJKjXVbg+D66g6yxY1aUD0Arnep219ty8iwiSsnhQIdh3pyQSyQAeikbGeJJNyKyB3YpJ14qs3U1KgSpMPyhTfiMvqqXZ6WO0cR+Z5PbKXC0ZDrAZSez3S6IJ9d4VkAhzhystXjdKAgsdzceSw/++jq7z3WvzSfj8JKrYHIqj8IonualJQ791yRPSrLm4FZE5+oH9lqqbrXx2cUIIYMS3fzRjx1VP6KFCb1WJPgUjG+37qeZUAXGLe3k0/4cQJ9MmkRWiE4yC3VxSELEPuYR6giQBBXirR62WzJj1LT038Sf8BjDQvAfa98LEeYFmBbfm9TbYqDrCeMN6iCggqx1A+YlCzyzvzOXK8K+briYNVdxLB9rB7BZcEXWKdrMAr4phSPwrt/oupFY3sR71FYFFIu9tpoOUYuZamHkvlFyTsMyodJIo7tvro5y50aN+KCYJBkputKuUAYu2sTIF0KEDnw47eweRPAp//uGZOPQGnvKSUta22e3puPpPMvPbTIdW5gPHKHJO8luggd6cq8YwLH7E4nwMFuD56ZPGXu4fTzYcsheA0RHpMyR+NuUd8jWL/2x0GeE7z9t+fx
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84802dc6-4c69-4526-8319-08d8d7e880bb
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 10:48:06.8178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: COTCHwiqhQIsrcsjl9V2J5760JsvahCtiZGZVRhpo1BjLaQGVG8qa32eCduin/2+xif6kGnKuOWPee9pbXts9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2728
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In stmmac driver, clocks are all enabled after device probed, this leads
to more power consumption. This patch set tries to implement clocks
management, and takes i.MX platform as a example.

Joakim Zhang (3):
  net: stmmac: add clocks management for gmac driver
  net: stmmac: add platform level clocks management
  net: stmmac: add platform level clocks management for i.MX

 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 60 +++++++++-------
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 70 ++++++++++++++++---
 include/linux/stmmac.h                        |  1 +
 3 files changed, 98 insertions(+), 33 deletions(-)

-- 
2.17.1

