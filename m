Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEE957AA99
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 01:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235114AbiGSXua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 19:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbiGSXu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 19:50:28 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2078.outbound.protection.outlook.com [40.107.20.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8473D45981;
        Tue, 19 Jul 2022 16:50:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XW6LuT/gS92rx9toYcpmwAfy71NvEmQtuETLrlC6V8qSDy6+3rOgRF96X3JB+kD9lI39Q7a3tQ2UQ4AJ0Ybdql4joi4ZzYjFkcCELdXXjgSbALBZ6A66t46V04tahEYJTlG9pa3VeM28dymqOoqh2/T+H58B6Sh2mAwz/+NMIlIFfz5G+MCE0fAMlsSl3ZsW5Y0GqDr4iRAGn16NEiYRNa83p4Pvwub9efF06PTv0WzChB39uMQxmxnLVy59hFBt2vnz5GzUpWxeHi+SBWoDMII7S8+R2NBF+EAwhhlhjpiGZInOQ9qY2HkW3LZhvTQP94cdWWHxpT94ywjQuR3J8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fg7FcY8f9NgNKCZJVAYR1TR0Tcabg5CNBnbS0U2aw6o=;
 b=OkPRI069MCBoWBYh4evgdQNHvI3vOtyjT7u3qQaZCuqK+M2PieSQ1L/azwdxW+jX6Xyg3yXPQmI2xHTXGmMSoIwkDjhF6d/8I8pK/6DCQOPKBzNmuDyroQ6e7Mlc9Ye7Vcfu2ujhA8L9x2ueimVMxZQ26fro0UOj43XRhshRzyR0CkSVYVuU1zjR2g76leOeN3n0yd81pqCjM7agn9SzMh6kS6k9C8e1dQPZRHXUNjv9rdAn8n6aD3FBIzqJFBGnU8huXP8v2JknjVLYhkgHs64nrEfbkMyOLv0vnofbV9SDDMvTLBrGRXE0bN3rEW8wjLUyBM28QENWicCLRg2qOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fg7FcY8f9NgNKCZJVAYR1TR0Tcabg5CNBnbS0U2aw6o=;
 b=adm33wrSd0cdyOHuj59aI4s4luoBONTUBNEPnlb1ZGWBaBR4S9kwlRETNk9Bkwh1azqL9X/7hHlAPq9845my288wAOY6VgGaXZUQqtiKnrLxNCwJbqgf2jqrCD5mvA9NMxWsySCbg2E2vuH57AQFjTXmltC/yXxWfq+2/b8S4+tJaWjHpuiXe5aZmErekZUX5HRyqQAEntc2UxKrF+INJMPXlewM2pU06mmIFuhLiLlPJCDy9A2PTp7Avl9ss4b6Y8UCTO71McP5TyVQcBH7UobSYdE/xYBtiqvVWC3Mcm5VTkGQaiwjB965Mn8hDIc1qKY+7J3K9dnwkmVtIHYq+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4811.eurprd03.prod.outlook.com (2603:10a6:10:30::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 23:50:24 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 23:50:24 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Bhadram Varka <vbhadram@nvidia.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 00/11] net: phy: Add support for rate adaptation
Date:   Tue, 19 Jul 2022 19:49:50 -0400
Message-Id: <20220719235002.1944800-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0227.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e233c17-c0b1-49fb-f991-08da69e172a4
X-MS-TrafficTypeDiagnostic: DB7PR03MB4811:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gaDngFpu9xVSWYztqWxF2wcoUOGr+HFm3vGH8WY1lbY8zx6dJic/wZ6sWqkrp7ETMkGCRelnGWcogdMWZ8D8ZFMpG8l8aS4EwB6idnHBAwzU1u4b5hWuRgNhHJzACInmQ2t/ldlG0tBhjMxJ+JAOeCc+12JSzhu8uhPiEAQrqh/X4FDp7ORNjV7UYkDClMgIk309xIk5IAsFF+ZeMALOhG1FB61tYPLxN4iz1yMug/oMSkQZ1v1ue4xwZRvVSLUu3Z/z/HbFl8pRaNEmAkjOyoakg7Y1KfDicYV+hTio7qfD6tTYAH18dcvhen6RxFBRz5qvr1QZHRVKIvS24HlNnAn+bwEwy5jNkOQ1pWAt5b6CdGoxDTvt0RthoshiYznCdfs03qlZNT1BmazLtKAyisZS/9a5q5XCth/KJdI1KPaK30Ia1e1vokRpZomuR5pTa+yU0rBQCZ7AdXjce+xQirBhh4PA5NDPg0a5j2tx2rmEpTb7HvNu4ausS7xlRNhHe0jzzqlWRYSb6K87R/hvMovpHm2czIMONjAaPdjGg3YzueGGcFfiZAAInwbWx0h0yPN82NcvipYDaCnwSiML0Zw2z10uzH11UbATWI++OViVbWNLLQ2zbXQaO2s97/6Uv5Tt0+XsSa25+0YvCvvByqAguiM2hW0T1ZtLhNbONfYHO52OjrypepBEJdEHmkM+nbf8t1nAgFrM9uB7+LYUFR6wE8SXCxqzswHLLQRLD/T/4Ry5WliQaJmN+neb62WYxYe/XpWWwEdZEo0KgTN7puN7KiVkRlW+MqrxbzaQMgXTbIHmGsO0NLoibhozlBYNiSDWLkFlzdJg/PYyuA82Zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(39850400004)(396003)(376002)(346002)(54906003)(2906002)(1076003)(83380400001)(186003)(66476007)(66946007)(966005)(8676002)(6666004)(4326008)(110136005)(36756003)(66556008)(52116002)(26005)(6512007)(6506007)(2616005)(38350700002)(478600001)(86362001)(41300700001)(44832011)(5660300002)(316002)(7416002)(8936002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NfNwkst3JPu/wcaYThYoFo8oU4tvq41Q7VdLoOaOpWcpoB5uPuerfvdYJuye?=
 =?us-ascii?Q?xs2C85HPz6yo4voHqtnEGQ+GnTtc2otXeE7TZIN4tU+yhuAiseSu204MnqDu?=
 =?us-ascii?Q?ySitsReGvC+3GzK+Jt+2JQ5lVTfuViSCFRSycF4Uc8YpiOQlmPPUxdKS+95M?=
 =?us-ascii?Q?Acy6Acbz/cmaUzxLbhLU8ZyTNfiBZFHEeop39UNzn0Rq62u5L0kZx8BcYx2m?=
 =?us-ascii?Q?lUC/hrOFr7vg5FqaTnIXOegq14hTgY3K+fvE155xhgIT1xzAhJs6bzzSB91B?=
 =?us-ascii?Q?mYHriF+THZDPcvtcexrvKpqbcDLeidt8de5S+rBUWRYPNsb0DMNjVAqTaxRH?=
 =?us-ascii?Q?tXDCXVnWcTOFGiCb/Alls2Gqna62TrPXOlBf2Dnd6XK7mYk5OapUP8zejGN8?=
 =?us-ascii?Q?ft99K97sRIAhT4oKZsYmoLlZsrZfnj1Vyhc/nzZIboFUlz0CtkHk3+4F3KJy?=
 =?us-ascii?Q?R2eJF6M6OCFPVgkJbgHRwa7PaCQqq4CkzHH/tDp812hStucXAyrKrmJ3eKfH?=
 =?us-ascii?Q?HFnWceOla4j7tEUGrgzZVOGdD2mEjWD/868w7ZGkpGaq8r2FamSZM3/gG/Av?=
 =?us-ascii?Q?E67pU0xfU1be44Z8y3CdarYnS2do3fRT26owu1I69/IMSyKAsNIqFkhDfZAX?=
 =?us-ascii?Q?bCN7pocz4vEHapGkTXMw+ETQf5HmfzMYKocCgHDpFJy2fVIcccByXoRnAI66?=
 =?us-ascii?Q?0gxAD3i/gYOJNOhtLaIoMOQMsW2W7aYLz3uVSnwEwPKwE96yVYk7ZgyDTeBD?=
 =?us-ascii?Q?Zf0BmJ1GFKVMliGPwDiYMs10EWYvrcQRcLz6BTB4Ey6Ar7LYUVf8GX8iS88/?=
 =?us-ascii?Q?LMkLmfWcLWKn+UvylERNZoasPQWuKcYIFnrZS58xi9r8zOdVFnTYLHQ1J2Xg?=
 =?us-ascii?Q?Zui/1W8uggpZWzwYZU9k+ZZ2gZXa895Tu+jQ9KrUCnuVrjVuuY05SyHQxmMk?=
 =?us-ascii?Q?K3wDZURJTDjl4/A8quyV8LBagvw1tbJFz0xaV6gsRWxteDGdz4THZRrSgspJ?=
 =?us-ascii?Q?60WRKHPo6GeB5jiARApzYrj1xfmBPJzuPww/AqznguOmA8UvDCYhQLgw6OC3?=
 =?us-ascii?Q?Fk4tNieEz1hkcqz0gmX+K+le2XxdSVGUrc9xNX7347fboDm8TF+aPPnZKAYC?=
 =?us-ascii?Q?kuXSwuBxSM/HpA/M+/so8v2F+iNFr7g47ORWWcO+5iXFjJN1BRdk3b6Wc596?=
 =?us-ascii?Q?JdQIoh6g1qy5vs6IC2syxENbwrmyfh/sutXxB8iy5SXlCZ6WYldvoEr+wIRl?=
 =?us-ascii?Q?uwogrrdgGcLHIzjSrGb12H5FknocnOtMRgqWolw6GjzZ4U5/e/dK1k6ub9+k?=
 =?us-ascii?Q?4WZbPe2K4iwGFEMDLd0oYTy2Hyi1Ad2tZqO+98uFml97ddQqebMQV7UHfywL?=
 =?us-ascii?Q?+S5W71rEm+kMksHicWG/edChsTMKwIfuuUQlPqECGWWMHD6cLFMrK0JSKGdl?=
 =?us-ascii?Q?GdSd72XGT+9cgoK2qEb3DrpALIuh+hs75XQZ2e7k4JcQs3j/hk6A+HaT0Jis?=
 =?us-ascii?Q?EoMspkqk8NqCganowO/fup2czdNxIzjf+1M1OhG6JHsY3fQnKerXOBqbE/fO?=
 =?us-ascii?Q?kzlUelIK60kO+pi2VBl0edYWsfWQrqe+gbUDWazR9mzrEgM9jB7WdKeSCdyI?=
 =?us-ascii?Q?TA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e233c17-c0b1-49fb-f991-08da69e172a4
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 23:50:24.0193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qA5Dno1HBqxVgupKi9ceVkK1vAlSbhiCBY7uUgzfZp/jqRkejKb7UJUzi1ychNexeDG0Ygsq3kNRc0Xgy16/kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4811
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for phy rate adaptation: when a phy adapts between
differing phy interface and link speeds. It was originally submitted as
part of [1], which is considered "v1" of this series.

We need support for rate adaptation for two reasons. First, the phy
consumer needs to know if the phy will perform rate adaptation in order to
program the correct advertising. An unaware consumer will only program
support for link modes at the phy interface mode's native speed. This will
cause autonegotiation to fail if the link partner only advertises support
for lower speed link modes.

Second, to reduce packet loss it may be desirable to throttle packet
throughput. In past discussions [2-4], this behavior has been
controversial. It is the opinion of several developers that it is the
responsibility of the system integrator or end user to set the link
settings appropriately for rate adaptation. In particular, it was argued
that it is difficult to determine whether a particular phy has rate
adaptation enabled, and it is simpler to keep such determinations out of
the kernel. Another criticism is that packet loss may happen anyway, such
as if a faster link is used with a switch or repeater that does not support
pause frames.

I believe that our current approach is limiting, especially when
considering that rate adaptation (in two forms) has made it into IEEE
standards. In general, When we have appropriate information we should set
sensible defaults. To consider use a contrasting example, we enable pause
frames by default for switches which autonegotiate for them. When it's the
phy itself generating these frames, we don't even have to autonegotiate to
know that we should enable pause frames.

Our current approach also encourages workarounds, such as commit
73a21fa817f0 ("dpaa_eth: support all modes with rate adapting PHYs").
These workarounds are fine for phylib drivers, but phylink drivers cannot
use this approach (since there is no direct access to the phy). Note that
even when we determine (e.g.) the pause settings based on whether rate
adaptation is enabled, they can still be overridden by userspace (using
ethtool). It might be prudent to allow disabling of rate adaptation
generally in ethtool as well.

[1] https://lore.kernel.org/netdev/20220715215954.1449214-1-sean.anderson@seco.com/T/#t
[2] https://lore.kernel.org/netdev/1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com/
[3] https://lore.kernel.org/netdev/1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com/
[4] https://lore.kernel.org/netdev/20200116181933.32765-1-olteanv@gmail.com/

Changes in v2:
- Use int/defines instead of enum to allow for use in ioctls/netlink
- Add locking to phy_get_rate_adaptation
- Add (read-only) ethtool support for rate adaptation
- Move part of commit message to cover letter, as it gives a good
  overview of the whole series, and allows this patch to focus more on
  the specifics.
- Support keeping track of link duplex
- Rewrite commit message for clarity
- Expand documentation of (link_)?(speed|duplex)
- Fix handling of speed/duplex gotten from MAC drivers
- Use the phy's rate adaptation setting to determine whether to use its
  link speed/duplex or the MAC's speed/duplex with MLO_AN_INBAND.
- Always use the rate adaptation setting to determine the interface
  speed/duplex (instead of sometimes using the interface mode).
- Determine the interface speed and max mac speed directly instead of
  guessing based on the caps.
- Add comments clarifying the register defines
- Reorder variables in aqr107_read_rate

Sean Anderson (11):
  net: dpaa: Fix <1G ethernet on LS1046ARDB
  net: phy: Add 1000BASE-KX interface mode
  net: phylink: Export phylink_caps_to_linkmodes
  net: phylink: Generate caps and convert to linkmodes separately
  net: phy: Add support for rate adaptation
  net: phylink: Support differing link/interface speed/duplex
  net: phylink: Adjust link settings based on rate adaptation
  net: phylink: Adjust advertisement based on rate adaptation
  [RFC] net: phylink: Add support for CRS-based rate adaptation
  net: phy: aquantia: Add some additional phy interfaces
  net: phy: aquantia: Add support for rate adaptation

 Documentation/networking/ethtool-netlink.rst  |   2 +
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |   6 +-
 drivers/net/phy/aquantia_main.c               |  68 +++-
 drivers/net/phy/phy-core.c                    |  15 +
 drivers/net/phy/phy.c                         |  28 ++
 drivers/net/phy/phylink.c                     | 340 +++++++++++++++---
 include/linux/phy.h                           |  26 +-
 include/linux/phylink.h                       |  23 +-
 include/uapi/linux/ethtool.h                  |  18 +-
 include/uapi/linux/ethtool_netlink.h          |   1 +
 net/ethtool/ioctl.c                           |   1 +
 net/ethtool/linkmodes.c                       |   5 +
 12 files changed, 470 insertions(+), 63 deletions(-)

-- 
2.35.1.1320.gc452695387.dirty

