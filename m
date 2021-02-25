Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95E57324C66
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 10:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236031AbhBYJFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 04:05:52 -0500
Received: from mail-db8eur05on2079.outbound.protection.outlook.com ([40.107.20.79]:47776
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234499AbhBYJCT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 04:02:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQaABaRYdi9nP+2A6xpaRQL8cGloKocoLsll705NmzMcmR2zVLvPzjOCgg90FXuwQcEUBhXBBJcViZAS/FUoLgw+aaVIAnnnk9kqTumaudqCvGd1kD/J0/pOx/KY3ABEKMVpbW05DNhK0NefhYJ8mIyMGShDZ++eBfOIVd+nmj8XYgCfWmK9tYXR/MMzmPoGHQdJ842s16YZXCbKfmIuJmXuen1/2TXXRIzlByNqG+/zRAk6GGoLmiWG7bhGVetnlVqyOqf3HRyQVOgYgnjs3zDZVFB/xhKjS3EWQgh57WS/PYY29RCazUnlZRcdpcjkzYXbdcPehsGGCwMmeFsvCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcuJlHWtx33jc4tUZrzgwCJUDwWzpQdEkEpIg+0YVUY=;
 b=VNaxRsc3j2pcD+ZCpRsdnlRvF9J4E1cdg5hC3B/Faay+eNyaDQ5nZ3RX0Te4moRN654YEVib1yHGmuzayJ/wMW/fYDClvahVI1fpk7EsoKAX49BqIC21/hq4Kis1rSv8OHWBUdjqcCuuJD0UFTgmIyy5/ZscF3gmuyDzdB1iRH9Rtt/3urvW/ZA3ThaVh25Gt4p81s6rXznmHHyWbZtQkICfZp/Ki5PrK2E1CYAH/M/Awb/62Rq+hdznZvZ3ko/MC4peEJmEP9NWmRgBj0CinmkL4CW32GVaa/GjwUwT0EurGB3zo9cLaICMxH9NdPsU4Tb9ZniY5Y4UfGv9f3auHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcuJlHWtx33jc4tUZrzgwCJUDwWzpQdEkEpIg+0YVUY=;
 b=qRgtJIMAO3ma/RodZwnuojaCnL7SE+JbD36JFgZg7VhVai39ifYmPLo00Uh+0oOG7EnexjsL4xbWcKQFWBDHLZbEywf5K35hPvXjPbQTDExmdcuGZ7XXwJstdQ1gVV0JM6lN1zUt4LQnHMhEOywt2Z9qP16khrb8WFAK9NFEqVo=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7770.eurprd04.prod.outlook.com (2603:10a6:10:1ed::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Thu, 25 Feb
 2021 09:01:28 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Thu, 25 Feb 2021
 09:01:28 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V5 net 0/5] ethernet: fixes for stmmac driver
Date:   Thu, 25 Feb 2021 17:01:09 +0800
Message-Id: <20210225090114.17562-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: MA1PR0101CA0036.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::22) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by MA1PR0101CA0036.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 09:01:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c2edf2e3-a4e6-43ae-1ef5-08d8d96befc2
X-MS-TrafficTypeDiagnostic: DBBPR04MB7770:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB77700FF76BAB33D935082F62E69E9@DBBPR04MB7770.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3b/EhjMImKEvixyi1RTKe+75/jcAdSMVE8sMZrKQwzSC8SdS6Be7iwj+NqysZZjTwniOkfJ5pzKYzMp0c82Wjm7TY29rDTQ1SKAd4mDj05vTYTri6LlqI8tCzKLnlMluWJoT3oRZ8P8/NH37G/J6evIMOs8l+vu/YsPI+bdz+T5jPLFrjisEhClNW1+kR3mQUzXMNxNN6FYMmMZ+i0/QzuPntkVdExa9zfQOrX4vgZfCwSoip+C0QK5DtpK+hYBcPSqWHFyuDIDauZKejBaB+WiIwZhH3VsjkxYBR5zmFDHh8UR6lPDvC5p8OT66JlpZbI+ZfxL7kNmvIN42xbixQQ0N1IOxVt10f6nDrd5BqFLLi6ebY5NvwuQ67SVnG8E0F+3vZSAM72z1lxMWH4twttoFh/RCGdufebiq6kqK6RBpCQJv419LlIlKAQSx0fGPvIMGk/CTDrRlyAlYXl8GY6QmNPnGq8DcLGtoC+V0ERrqS/ARFTfbdkhbSYryCbDgdLDmDZy/q9l8awbpRd/zKeFWgRmTi2MrFW4ZPfoV2/EAV8F1ItxDa+FbwwJTYSTnKkgrq8XgWcjNgwu1CoEczA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(316002)(8676002)(6512007)(186003)(16526019)(2906002)(6666004)(83380400001)(6486002)(478600001)(8936002)(69590400012)(4326008)(2616005)(6506007)(66556008)(86362001)(1076003)(956004)(26005)(66476007)(5660300002)(36756003)(52116002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GIp4JBCs7aqoskXQXuj1VpWiGKbnIbE5O+5aT+g6YqyPBBE7wduv/6ASW2bf?=
 =?us-ascii?Q?m/2cwsNkfbkNvwmLrHVD/QO9aSttYo8eOXGy8JRrsJoOuwM6tWquG1kgELfU?=
 =?us-ascii?Q?5Gpb/4/Y/maFL2jEMk+qmbB4fiCP8YOzl4g8P45G/cz2oZ88w/kdmRyenUXU?=
 =?us-ascii?Q?bwL+cUGDsDkug5D/59phMKR1E2XCPXqnGucrGHsHaIJ6yvvVRqmg1r2OR+D0?=
 =?us-ascii?Q?mE+AGNJ42mxn5BRrfrIvOjA9cPG+UHGvmu3qTAjpeJ7qhN3vHo49NGi2vDcC?=
 =?us-ascii?Q?7jnXzyhRti+IlMYXzAoH1HrR0Dc7hD9Iizq7xTyTRbBI9ihE8E3JN9LP43lw?=
 =?us-ascii?Q?4Qz3IDP6H85rzbOr0aIsenT+JEn9rhagXpl5ADxPjPlwLKvA5K3kgWJ7XWFF?=
 =?us-ascii?Q?5TG5TkZweZSl+H0YzP92UNLKaToXZjaNg9w6VTKlAtmyuyntdbWy6pol7qPv?=
 =?us-ascii?Q?Tq2lYSHDzfZJwX8VbfuQxznDk24akMgcAZry+70HeHbJwfCNTeU981XJuLxh?=
 =?us-ascii?Q?NvALCDky72giBbAbZMkupqo1OXx4DQ4fP5zOfh+nf7/omSOaI2puq67WtzJa?=
 =?us-ascii?Q?mrRTV0ctdNyihrT6oqDcV/tmxZ2LY90is1BbaUrqfVMd5RE0M6COxHzs6mgk?=
 =?us-ascii?Q?7RrK3MKjjqGdlSgG4xY8suRgjU1O5TjUDCxUsWC3DEhNhWm498zDFQUwfJD4?=
 =?us-ascii?Q?iJ4bSW2KL0k7L6sFMomCYODQM7qLDz8kcdNplVY6nnD6e8pcGClYJus9EnZF?=
 =?us-ascii?Q?E9GufIhnsDQSzNZGkiHINLJOYoCFICQvzo6tkf//mXld9dqMJt0hs24LOf62?=
 =?us-ascii?Q?hkTX+nQGjNReE4Qzf8DN8rEFccF8R2lZqw5acWdPGQunxCCi9Wrm1bR+ZNx4?=
 =?us-ascii?Q?bwp/HYlEqnCBH7uBsn+VtfMWfW+Eib/wFV0YRK8ordC9Rg5z3KJUqKcuCWpL?=
 =?us-ascii?Q?x/AGd3tPlUUT2mjL2gzt032Y2+F+0bw4sYPkx8pZ6WB7b1B0bmz5LVv5mURS?=
 =?us-ascii?Q?CTq7NllEMQcWNk7yDhO+qbM4DNGOZzCtKZPsrq0EZLqw2IcAP1SM/xjJcMSf?=
 =?us-ascii?Q?U1fm8p6fh8icjNf/SBrEG8/Pp0dyZkZxfQpQs382a/qZDcEAiFleYbfHakX1?=
 =?us-ascii?Q?xndkvHPKE7CVPVXWcIv/7jNOmWbWPc0eUivUZG49zTBmznl9ZxG0QURVSLxo?=
 =?us-ascii?Q?SfcquJX+HGIn738oflwS+4wlHPJQoCVX48EKgz8dITY+/UIb+2uClTY0U6+p?=
 =?us-ascii?Q?hkbyWdXtqSKYd3m7U1n5lP2qVY1YpyL491Gk02NFMnJSmoEjy1HnVfYVp3md?=
 =?us-ascii?Q?w2nLmQQjDHcFO/2Ne8a/ORf6?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2edf2e3-a4e6-43ae-1ef5-08d8d96befc2
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 09:01:28.2798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GOjCwWrAe4LiayG2AlXFhmd2fwf+7H9J7mzrcIGz8+y1BoAaJPLMl2wiV9fDnl9LwAhIOMJ1w5XnLb9+M82Lww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7770
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes for stmmac driver.

---
ChangeLogs:
V1->V2:
	* subject prefix: ethernet: stmmac: -> net: stmmac:
	* use dma_addr_t instead of unsigned int for physical address
	* use cpu_to_le32()
V2->V3:
	* fix the build issue pointed out by kbuild bot.
	* add error handling for stmmac_reinit_rx_buffers() function.
V3->V4:
	* remove patch (net: stmmac: remove redundant null check for ptp clock),
	  reviewer thinks it should target net-next.
V4->V5:
	* use %pad format to print dma_addr_t.
	* extend dwmac4_display_ring() to support all descriptor types.
	* while() -> do-while()

Joakim Zhang (5):
  net: stmmac: stop each tx channel independently
  net: stmmac: fix watchdog timeout during suspend/resume stress test
  net: stmmac: fix dma physical address of descriptor when display ring
  net: stmmac: fix wrongly set buffer2 valid when sph unsupport
  net: stmmac: re-init rx buffers when mac resume back

 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  59 +++++--
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |   4 -
 .../ethernet/stmicro/stmmac/dwxgmac2_descs.c  |   2 +-
 .../net/ethernet/stmicro/stmmac/enh_desc.c    |   9 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |   5 +-
 .../net/ethernet/stmicro/stmmac/norm_desc.c   |   9 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 151 +++++++++++++++---
 7 files changed, 194 insertions(+), 45 deletions(-)

-- 
2.17.1

