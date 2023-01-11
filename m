Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A091A665F3C
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 16:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbjAKPg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 10:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjAKPgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 10:36:55 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2075.outbound.protection.outlook.com [40.107.8.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6358D11463
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 07:36:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z84Il2QjAfY+TEtxovQEd+ijerWhmsDrUiUfnfty/BmBABuvmEUVY3ApxIU6JPja6Z0BTq6pzuMYcHJWN7X9v6mRYKbc2pGLkXoU0zy9AdB9Ci8wr0l/Cjf+Hp+NF0+/Wlx2y5zU+OHQsXgmSUU5CjzwUrKGp6YTsJ2HNaMkbomdfP4/sJ6eoqacxY7ACltHxZiKziO+WdY6wUflbH+/8LsDGPNauEnLI3pfnZU8/nIvhYmElHB6KgOPwEQqPsKBFWJDaw03MwnFwgc3M2gEwqxc3tk+rvPmE67CW78VuGiZuOKjBc25VDFyy+E3SbqDGXTFDCEUPkGSLpp8nFte+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iEQ92sKdjKF2JbH9mbiRE89l85SrATUavarthRAavHE=;
 b=lAB7pdOpI/bOjuEtWgL+i3tdAP2aFOaInt8KEd96RA5j6LhlrUMRYw9RycznzBqG/BFbZG52P6kSnb5XJCqgvOwwfD3qTfkordMptYV9U9g3ouqZhsw952/yeNjzwVDbnF2SHuVmxAugYyJgw3Wz8HjLm+jib4ltFJ9tyYBP7Z6BphgIfmXVj7Lpxcygi76ztPjplbtNiLIVFDMVJslCiR2ikvWcZP0O5oUL8H6FTPDtLDo3uQV1rZfCVhlA7gQDz95E81vP8Z+nZgRAnDssUIWSYBYQh8QtL/eWEj6M8G5EWmTOF8K+D/MU/ha72lOSF0rGFCW0MbHmRi+iTO8woA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEQ92sKdjKF2JbH9mbiRE89l85SrATUavarthRAavHE=;
 b=CaWJiYtBVC0RsmFUfH160fTKUitW3RLSAVWrTrxJ6aIWYj2P4LmZG/7IPuo4reyY2/xZvoPf3UDa7G2NNTQhPQoFlWrwqwUZbjvxG7lKiSgGdXccCHXFHP5EU336Uf6ZDcXOtGxjyqIqSpm+p2ptSvGH7dQ+9E77jStUp9jvowg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7219.eurprd04.prod.outlook.com (2603:10a6:20b:1d3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 15:36:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 15:36:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH ethtool 0/5] MAC Merge layer support
Date:   Wed, 11 Jan 2023 17:36:33 +0200
Message-Id: <20230111153638.1454687-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:78::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7219:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f539746-0644-498e-1400-08daf3e9a88a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aZQeqkvQfbgA6xuQYH2HzDmnAllVdFp1sxNSx8k5EUB6yAsiAV6s7vimqLDelFQlpaRNJujeWPiSaTscBc6EwV+SWOOdYdFsYu4e4K9Tc2p/tLe4aV0c2UZp4xSRy5Ecssp6PJwpE3/xQymqa3VpJqxA8f34crlIj08coR1i+nQewPvL0QhRJMybp8NZSaJ/AzIfZ8PWD8JmBaoNHLln4mfk1SAFk0lT0v5s1Gg+AIv9HxfMpedh5jgnqFp18ZuIFy9Lj1LfyZgdrLZUSbC173QcmCWFodO3hGZpYROiTdyj3HjU/7gq8FSYLE7Xlfct/G5LxaPAgHcp6JPliYN4RpbgGc5zOOFbaDLNE7CeDdR6jagSIaKkvfibuIlWhn+JOmsgZyeFVlESFxGiljGxPTaPUS+ER9sX8xiqhfR8WrdGL+RZ9dcAwK9Fdy1hbvFPpbz20g9CPVNGxzJBa+/GLkUAOtkyak4HO/qaYiOkvkRzdSJLUZeADxJC55Ejz2m+F/EsaVrWEV/kbe4Ri8MS8Cq/9sdjmEO6PIwBpvRWwrvWrzxtnW5eQzC3Jj+1crG1954UGknHLCgTkDO2sFQaXe25pdFJ8ult2GqU0PbtDPhb9FI8V3YeOp+ACwDKIL4iILL3QXIrJL9N1WnQZHVB+gQ7XrpAdX1WsbkUe5ey0NAcIkAtftiUj/rQQ/ihTUIr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199015)(8936002)(2906002)(5660300002)(41300700001)(44832011)(52116002)(4326008)(316002)(66556008)(8676002)(6916009)(66476007)(66946007)(54906003)(26005)(6512007)(1076003)(38100700002)(2616005)(86362001)(38350700002)(186003)(83380400001)(36756003)(6506007)(6666004)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p3MBIkDQxyEU1lcdbwCBHUbanHXBPf3oo3+SBsPyoLWjyAUpankYqj1AB14A?=
 =?us-ascii?Q?gW8jZjzy7BkmLs9RvAFDiAxybt8RWlx5rtHXLDN7X4gagCydHd+/XLTF7ReJ?=
 =?us-ascii?Q?+Q/IviCQ7+mrI0aR/kAyWsmoRgvUoamHW2IihfUqEXKQJ5Q97HW8IHzdJM5T?=
 =?us-ascii?Q?B2NdUwXduQkO63l/c2KIgWbstPurtVe1iXEaInnHcE6pjeCgOfdbiJxhLIip?=
 =?us-ascii?Q?Hwsm0BCU9EKXYfAvCXdpW6f2OqSlElJvlFuJCPe5bNLSqXXj3FambWWBT10d?=
 =?us-ascii?Q?B+0azdwwlsGZW1qp8o32shzPFqIS5DQ1IQXzriQj0ZOJjRurksQsKEQ+3+Gu?=
 =?us-ascii?Q?UlioLv+oDvy//bmWnX8EosAYrYdDjEN/5OdWrQdyCajBbmT5L53hMyBDpUd9?=
 =?us-ascii?Q?BuihzgbY0A269x74qIjmKZIjkFMtY5hktzxEYYOwWd0xOEpn+nuAQs4elT+W?=
 =?us-ascii?Q?vbauhU6OL7x5yti5oSYJDhBIUMxsq2uj3eKiVZLx9DQG6JR0VJq2+iWbx71s?=
 =?us-ascii?Q?wN5wtTM9GBXPSYeOnpf6AYdtMhCvSV7UsutVCSvkEX2tC0y630TgZTyGA6sh?=
 =?us-ascii?Q?hRRtHc39Z4IO3wLvVGLkx2d0xlvdfdpH1huDIrF9lDARZUoXAaJWGK/mhA+o?=
 =?us-ascii?Q?e3zAALe4GF1K21Bo1fQdyRy8LCaRzESQMFgynK4Ud04D7K0Zj1iWEaI6gTrU?=
 =?us-ascii?Q?6k/1128zPoIFTpn7f+To5GgzLaREc32hW2W6OTx3Ffsd/zQtF2jdQrOrVGnU?=
 =?us-ascii?Q?fn1Zyq0jV36UcU6BGu3sqIy+mi+e/OLVSc1iMkKpg0PUzMQw8E0lQk8sz+IJ?=
 =?us-ascii?Q?6sYi3wbNLge3TNYxo1iuVTDh40XtoaqUhCLyd4dHBmxwaAIkBq7X0uQYPchK?=
 =?us-ascii?Q?W+gQqK7+WAu6sjYml7iY2EzC7SE5rMjHlZitQD7EovGcJxceyiikatRmkz1G?=
 =?us-ascii?Q?7vV8Y1PFjpJ1LdR87cfJS9L0x6xihTopGM7iqPDOXn+etMQCNTyI8hgviqMW?=
 =?us-ascii?Q?pyU3nDbnLhIJRmqLnn0UajVwdpC7e9SnqQCgPsySqR4VH0oUAW6p0/0t1mX4?=
 =?us-ascii?Q?2AdrCmdVeRXlBB73O8LWPpY7uZYhfR/blTpuoW74HkYKmv19psMJkp8F79QQ?=
 =?us-ascii?Q?P1WxwSDFX/ZfBZRaXbnXbSLyjtmgLOAjCEolcp+M0l0H335fX3pRuTDgcC2M?=
 =?us-ascii?Q?SiU95HgTIY/Hkb7QRXIwdjtEgaXZoi2spA6t7dBQCF9+eqXosrU8Lniw7IfC?=
 =?us-ascii?Q?aYwKAQem/nsKm/Cpe33TsUA/Bf9uwkAejPMJXnAiRVOtBiAbFxaHroO7vxcS?=
 =?us-ascii?Q?Y62GUaOOHo0ugDqE9HWimNqpdT3RR+PFn9+L+zVJal3xpDXrgYG8w7sWFS61?=
 =?us-ascii?Q?N4w/BPT71ZzmaA6bpDVH+rwOY9adcuV6PPLd4AangcwIyExRRiaeS26m+bmT?=
 =?us-ascii?Q?Y5+TqiRkmER+dBKPm7ttKL2Eji7wbrFlRWl4Gy3b6+gPf+O1kK75uYf3QBUx?=
 =?us-ascii?Q?xJyNoxuXCO84bfwDMMITLAJa9k51+I41BiYFFBhrvlgrT7jbNBJzhmXeml4R?=
 =?us-ascii?Q?Qopy+uY2qc3VYNE4GtgIzHmA7/80i0ezNT6oZ+x6SkLxgmj6uwLGti+d5W9e?=
 =?us-ascii?Q?Og=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f539746-0644-498e-1400-08daf3e9a88a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 15:36:51.6740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2pDBYtrwEgAa/lC3jgbhsHaSjDlYV60pw4HBGgpIKrHkOmQIeYdCZ2zA/nS9KuYY+pSCcXWPwbFbPDa+0D9WGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7219
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the following 2 new commands:

$ ethtool [ --include-statistics ] --show-mm <eth>
$ ethtool --set-mm <eth> [ ... ]

as well as for:

$ ethtool --include-statistics --show-pause <eth> --src pmac|emac|aggregate
$ ethtool --include-statistics --show-pause <eth> --src pmac|emac|aggregate
$ ethtool -S <eth> --groups eth-mac eth-phy eth-ctrl rmon -- --src pmac

This depends on kernel-level support which will be posted soon.

Vladimir Oltean (5):
  uapi: add kernel headers for MAC merge layer
  netlink: add support for MAC Merge layer
  netlink: pass the source of statistics for pause stats
  netlink: pass the source of statistics for port stats
  ethtool.8: update documentation with MAC Merge related bits

 Makefile.am                  |   2 +-
 ethtool.8.in                 |  57 ++++++++
 ethtool.c                    |  14 ++
 json_print.c                 |   4 +-
 netlink/desc-ethtool.c       |  29 ++++
 netlink/extapi.h             |   4 +
 netlink/mm.c                 | 270 +++++++++++++++++++++++++++++++++++
 netlink/netlink.h            |  34 +++++
 netlink/parser.c             |   6 +-
 netlink/parser.h             |   4 +
 netlink/pause.c              |  33 ++++-
 netlink/stats.c              |  14 ++
 uapi/linux/ethtool.h         |  43 ++++++
 uapi/linux/ethtool_netlink.h |  50 +++++++
 14 files changed, 553 insertions(+), 11 deletions(-)
 create mode 100644 netlink/mm.c

-- 
2.34.1

