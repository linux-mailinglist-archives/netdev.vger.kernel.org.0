Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A8651B78C
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 07:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243723AbiEEFr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 01:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243693AbiEEFrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 01:47:49 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2097.outbound.protection.outlook.com [40.107.236.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2277134BB2
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 22:44:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7xRLfd1LGlEgDC430b4ka/0jNXi5wPfi4/+aY7u8R6/sp709TQ0+UBJvwAi0PtLT6ZJFH4WMc28AKJiAkcbSRohqMqY+VRjmfdsxc2vX5y60CKbIOJDXQ4McF/HRNzXHK+ljxA/Bl8+ZdCxxXX/bE8/aldfEIaOhSd7zUz4k7P/dXnq5dl7t/sRZ6QTmJUtpxLFYK3TIpuzcMGu9hxab/9CVsmLLP9bHRlUfIryEKZgKtlX8A+q/sV3tzo/xNzqYTmtASgol1iAxuvXocx0tC1qSZaHpOcr7cnx3dSOyeNaQ7ZPpYG/RVMRWzHaD4veOHljf3xWAMe5yGnGyXnTgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=siOM29ypfPHIxFuUR3hXWDwoCr0vH2bYgGErb4wtaOk=;
 b=NRlt/HXwk+O9Zd3N3xTw0/QD+meunn05L7MbN6zuWxsaSe6t/wkXbxsHRIOLsbtP+AFUriKyqlhQmM2X35uNF/BpmjrVSBlp6e2cp09iJszHxN1mVOK8S3v3wOehp2zf17A+wZMxXrOoeFo9TEpdC+gtZOpl3gNauLK9O90ynQ1Smz0EE/nnOYRsuugqODzhTHkaIR02qWkUe9V6ZrYZAC/QCWsBOsV9PoJFJPBYy6bgb0dLq07N6FGxSrlpy0hcZrxLO4iQZa1CWqH48lTfYp/PHhfbPP9R44y2+uWCynPZ1tSdhjvsStHVV2gt6WP+XaHhxnNxTYQhbawsZs5Uww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=siOM29ypfPHIxFuUR3hXWDwoCr0vH2bYgGErb4wtaOk=;
 b=wfMszr/rnZLbouH0I4LCPNrtw/alu1bVjHY120u+cjYCZoOXI+IRLREvz7JrkgRFnNjjohusDQ7hpNPXS+jWoiNIEATW4sqvhEfLXBHSofDrine5wF7D104WowBg0RINctGON6USrjounXWNvWJ/HJIZVfAdhO36RWY8EVyU5CA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR13MB1257.namprd13.prod.outlook.com (2603:10b6:3:27::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.16; Thu, 5 May
 2022 05:44:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5227.006; Thu, 5 May 2022
 05:44:04 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 0/9] nfp: flower: decap neighbour table rework
Date:   Thu,  5 May 2022 14:43:39 +0900
Message-Id: <20220505054348.269511-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0082.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a33f2e30-ae92-4234-325c-08da2e5a4365
X-MS-TrafficTypeDiagnostic: DM5PR13MB1257:EE_
X-Microsoft-Antispam-PRVS: <DM5PR13MB1257EACA5A9218413E6E5D95E8C29@DM5PR13MB1257.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5GqStkoDJOX1rJKzooPr2kBvj0JNKyhr3SNU61oNcRtlbHte9wvsz2FVT2DHOcQSk0wZBbxwfuP5lv0weOXbERsgtXZBi1N4Lq5NGMw2fYcZ32vdtXTmz7j9X6J7xybbS37ForycWomc1tWJwczl+fSNkHF4jyLyIERS2wwRMtxfU9mtEmzYC26qx10l5SqQqAAlJoK/nDI1yN7IhMWZIGhyrVZFSU6Ww8K+90VH4/5+L2YFBFaXkzPu+n4EduMdE7cKBrRy8Jj9jAPTA59Tw7YtaqcqA9IZuJCY5SHPZN+FX1pCBZdbtOm6DmF7te0ZsD4KgHo2n3COpnDnCtIlKfN6RNElO1rRdFIvCqH7tn2/fKnEZY8lOevWg7CcdP6dwZYLKIg+YxACPvLa/K/Ov2ue3qV6jkJtMgkM6CKJMlKObv6A9OWBAxllk5/NiyrKJG0JRQPiVTFnCxHzCnz10a5PiBJyodKQkGTXwzpxOqcykDyRydPV5iZ0G+cLKd0knNhKBdQoNVE9TQtm6ueeptpvfuofrFbXID22qoC5y/MDR40Z+ziuKV4S1Uu7+lxAnSWGi4CG7KaKE0tphnW3pqHU1Lt3KY4F+8B41SwM3YNJE5ldRjVsQkiKSuvd5tAwzyGCLXrEISgwRMwaaumNgpZYHtXxx+g4aK1kKxGmvT+DWFIHv4xqiRX6CwLuGSrC2cQtmanEpHP68UITFWUUXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(346002)(376002)(136003)(396003)(39830400003)(66556008)(66946007)(6506007)(8676002)(4326008)(5660300002)(52116002)(1076003)(186003)(6486002)(36756003)(2616005)(316002)(110136005)(83380400001)(107886003)(66476007)(6512007)(8936002)(38100700002)(38350700002)(86362001)(508600001)(26005)(6666004)(44832011)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0O8R9Kx+bP8AzbYjsxG6oGcZhrbxnMhFqxftOtDD9/yJ3gXXkmR1FEISVyXa?=
 =?us-ascii?Q?TPvMObVBeF+Ipg6SCsVAGYkxRkqZZL5kEZTgNWj0TIyc/suQSXGUyVeSf7DZ?=
 =?us-ascii?Q?blNhH1F1e5jFnjJ5dsQvQmGmOEAZjmdrBH34jmmfweQnDTc5TPVXxHCmE+V4?=
 =?us-ascii?Q?5/R24QJMqC2rqc6U4W9ylSknqeRg4rSJeP8NdKB5RIy4USR+qgQ9X+qfe+TG?=
 =?us-ascii?Q?9KPZL6cL3gMwtsRIdDhgG9V1hVZ9Qdwqb0qXjusf5XWZcjoA/oe83OVbblfj?=
 =?us-ascii?Q?G3iVwdjuntQzN9quPbbS0BOK4siTKXfnS7PYtm7N4s/dqmfST6CThEpEGfot?=
 =?us-ascii?Q?aEVANMDwRUvBPg8uRXm7OuXHWtr2ZWeQRZj9NRpzTPPW52/IPpCvfsbX9hRO?=
 =?us-ascii?Q?a8lV3Lf8v2zvydUUTHgeBmDGPO0xpPCndOM6QSNYeRduIIracbcvr7eoY4df?=
 =?us-ascii?Q?7FBWJZG5Z77VFOWHAxTVauHeJW7UobiPCnhrkHAx20nEXsDxxFTZ9VrVL0+n?=
 =?us-ascii?Q?Zw4jvIbvx2ld/wCJMYb98P3dknv8WfEpF0+W556hOOHdY0cBtfVoof2oCUo8?=
 =?us-ascii?Q?B7mM3HMC5oB1MDhnlKrI7z25BLRITqmLXQo+ZkUcnrJtNp3ihQjCTIjwprOT?=
 =?us-ascii?Q?LExNQ+7mtQniJwvR6FRx8V+qLCOBOue8fKw/g9DCjP6KOcEpcAqv31iSD7kc?=
 =?us-ascii?Q?h2boMiC1Vg+4PxUnR9St4QJAB9aSsA0lSX0YYNgEbE+t46XElVbKtzrfk9DS?=
 =?us-ascii?Q?k7V7jyxNbiaL0C0ao2DEQRXNPSXsZJAmiFj3X4DZVlZD3mjiYRVC6IiAodfx?=
 =?us-ascii?Q?wnZXiZH8yDWr7Jz6X+Th5wbyxQwYJSsz+JGzGJBr+2wZjL6J3C9t3P6He6Hc?=
 =?us-ascii?Q?AP2OVemLDgo0IlkhmqzeRCzOphuuZH7XFBZeQKhvLLHqWkOTQ/Fe5HmYjQYW?=
 =?us-ascii?Q?Jk3oMBH/41lEDL/NuQDxmlaTiLKFimIipuW3jDE6iWnXg1Q0XadS8XOqyjoL?=
 =?us-ascii?Q?VGr65a7Z/QFP7HFIHaWVmfWvPjn0fQWuhWYtMa21bt0ZZzPwLNiwijzD5hFg?=
 =?us-ascii?Q?wKo8UxWIWsewje64kcj6SctNqZXXrv9F3hGTNka9sYxgVlLf/hIc+AgKL7u0?=
 =?us-ascii?Q?0AH1gjCZZ0bH7eGLq09jgnEFUuoZ10Rl9oh/O4RjUA/RHP4kmfxscUYYfkIh?=
 =?us-ascii?Q?kKLTveiqF05uYgD5VtOTVji2y98ssprNJeuksSrKDmPplOPZTn5s4a45vEka?=
 =?us-ascii?Q?Xn3VEVjk9T2LckHIq6bvwumJbwFnUsHFqIYcKq4FGCaXY5oJpm+V5yt1olKa?=
 =?us-ascii?Q?h/DujA6BFM4SCkZyyKosiGAslnhGdlvDNNyuQ6QMp4oTYCLVZPLhS0L8HpOu?=
 =?us-ascii?Q?wL6Ezg7QSm4tMGrNeOiVMdNhp9BnP/75n5WeEdH9zi16RtAf8i2MKqnjrw+Y?=
 =?us-ascii?Q?YNxMbagkmuHKUun9LlRbo6QYACbfHk3Fn7MQzmiMPQOmt3Ij4jk6A536CCz8?=
 =?us-ascii?Q?9SBK7YXWHW2Pa4FXbKWd1Of9MU8Jdc0QeK/MJVq1IMuHhEBhRuBlZjxps+fz?=
 =?us-ascii?Q?tlIzlz4VQ8syvsNMxS4YfwmHtu5U8u2VIPoE9vwkJdJ/Q6Iu9aSgrOONElQc?=
 =?us-ascii?Q?DQQmTz+zpj2muZChM/106gxWs5NtlQlH4mPNKXxdCrpFOeFscPtBQZDvVKYW?=
 =?us-ascii?Q?p5ATWOJuqNuYZVacKzGBjs6GzMe9too+TkeP4jPtGLZRzI6Gz3Y70QCjCCs0?=
 =?us-ascii?Q?1qL9Ss5PCXo6yMoPz09bvK3dnCgYryo=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a33f2e30-ae92-4234-325c-08da2e5a4365
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 05:44:04.0561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iocIZVYTK5rqIda6fPm7yBI+rPTrd2BFWNgfwdJGq9YbGSibznZbVcrvse7rQrhC8LLEmJPGFCws0hg6icl67gFTQ96EGnaW1YfCsrEyUt0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1257
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Louis Peens says:

This patch series reworks the way in which flow rules that outputs to
OVS internal ports gets handled by the nfp driver.

Previously this made use of a small pre_tun_table, but this only used
destination MAC addresses, and made the implicit assumption that there is
only a single source MAC":"destination MAC" mapping per tunnel. In
hindsight this seems to be a pretty obvious oversight, but this was hidden
in plain sight for quite some time.

This series changes the implementation to make use of the same Neighbour
table for decap that is in use for the tunnel encap solution. It stores
any new Neighbour updates in this table. Previously this path was only
triggered for encapsulation candidates, and the entries were send and
forget, not saved on the host as it is after this series. It also keeps
track of any flow rule that outputs to OVS internal ports (and some
other criteria not worth mentioning here), very similar to how it was
done previously, except now these flows are kept track of in a list.

When a new Neighbour entry gets added this list gets iterated for
potential matches, in which case the table gets updated with a reference
to the flow, and the Neighbour entry on the card gets updated with the
relevant host_ctx. The same happens when a new qualifying flow gets
added - the Neighbour table gets iterated for applicable matches, and
once again the firmware gets updated with the host_ctx when any matches
are found.

Since this also requires a firmware change we add a new capability bit,
and keep the old behaviour in case of older firmware without this bit
set.

This series starts by doing some preparation, then adding the new list
and table entries. Next the functionality to link/unlink these entries
are added, and finally this new functionality is enabled by adding the
DECAP_V2 bit to the driver feature list.


Louis Peens (9):
  nfp: flower: add infrastructure for pre_tun rework
  nfp: flower: add/remove predt_list entries
  nfp: flower: enforce more strict pre_tun checks
  nfp: flower: fixup ipv6/ipv4 route lookup for neigh events
  nfp: flower: update nfp_tun_neigh structs
  nfp: flower: rework tunnel neighbour configuration
  nfp: flower: link pre_tun flow rules with neigh entries
  nfp: flower: remove unused neighbour cache
  nfp: flower: enable decap_v2 bit

 .../ethernet/netronome/nfp/flower/action.c    |   3 +-
 .../net/ethernet/netronome/nfp/flower/main.h  | 110 +++-
 .../ethernet/netronome/nfp/flower/metadata.c  |  19 +-
 .../ethernet/netronome/nfp/flower/offload.c   |  86 ++-
 .../netronome/nfp/flower/tunnel_conf.c        | 502 +++++++++---------
 5 files changed, 453 insertions(+), 267 deletions(-)

-- 
2.30.2

