Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84CE3A6747
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbhFNNDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:03:42 -0400
Received: from mail-eopbgr50111.outbound.protection.outlook.com ([40.107.5.111]:61697
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232685AbhFNNDk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 09:03:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TbRA1og/ihJgjMAscTO9e/W3QNeibomZSQ2NsgD4wSdMKNNOb/nBHDCudEEqgHlouJGS+PVASLzjuseSCr8ERS8wyD5+Y0S4db0pCKUhDANk96/d9l6DmfJ3Cof+QeVL07vZdELymu3AiWTLouy3fyzpz1JwNR5r9rg3SY1flu4t+xs2YmX0xDruCcRx42BMerum9Fyn/vbJ27AWo5H7vfHY+Ny05S0++R3ojm2J9omNZ2vJv877ZRY5RqLClb3KlrhJ5PN4Dh7PcyTVt7VZj6GHJIUxKjRdVpMcduXwy1L6HpjwY3zrgv79WumI9RlM70Nfab38OgOJZLq18h44yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WlSjSTguo3+MEuOSRVgMqwZBz/GuEBWZbhzCTTnvlpw=;
 b=DOy18gVJNkjKuHIO/jo1KZJxgMBHirC6LBq0GltNitTGuRCHHxZWciIbwwxP4QtxGAk07elGiW31s1QVAMNFxmet13Ni8R3NZOyA27ymzpvnGORKvvCjKA0hY1v7OpUDJ2+1WbRNBH/H3GRnBUB9jQEsHEr2bEKCZzGP6ef1D8ilhVyafvGugpU6wl/nys4Hq3xTh1mU1eoDls0RwGtWQyxFd31J3NTbLEhLpiFD6lL2v4OMyoZjxqSJmz2wY+SvPyPnEvUTkUj1l4HQxZjh6Y4ONHYDjk3QHDH0tiUs1WUAiROTuN0kG21LeM1Wb/I1z7XbF8YQUWmqJpq6IAYx1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WlSjSTguo3+MEuOSRVgMqwZBz/GuEBWZbhzCTTnvlpw=;
 b=Rs1On4CJ81N9vvmXg9dhpEuCUBBDm0JCuSi5MuDdXc8Mzv8VpQhYztbb2ajnNjuJJrGPQA8XBPhhG8rhDDtsSbeL0Dja3YTtydP994eOgHsZoiX9jvlOYOWg0kJngX26Y6wh18jr5qaAxoOQcWLZqS4o/LBNjw03pIMGIcEoHLU=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1396.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3b6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Mon, 14 Jun
 2021 13:01:35 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 13:01:35 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadym Kochan <vadym.kochan@plvision.eu>, andrew@lunn.ch,
        nikolay@nvidia.com, idosch@idosch.org
Subject: [PATCH net-next v2 0/7] Marvell Prestera driver implementation of devlink functionality.
Date:   Mon, 14 Jun 2021 16:01:11 +0300
Message-Id: <20210614130118.20395-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR06CA0140.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::45) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0140.eurprd06.prod.outlook.com (2603:10a6:208:ab::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 13:01:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 002dc202-b7f0-43e6-ad55-08d92f348a02
X-MS-TrafficTypeDiagnostic: AM9P190MB1396:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB1396E50005BBA7A60D09A7A3E4319@AM9P190MB1396.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ngmkr60krsabnqTJCFuJsUilkWOHRrl7pQDAKG5xk/CLsO+yT/FaOHC31P1VS1qwndIz7lNSfUGd8x1kAnM63qzf0eDhqht4wJ+uw0gVcC3QUf9tpzoEWIyWqitDlcZtkTqm8xBH1sujiPfWcxjq9j8c7pRSYiid1ZAf6cFaLdwoZo0b0UV/213FIo3muHCZVz9y+rOtibFGWF6Ixwu+a4vq9F4r4Li0OHhmfs4hPyXkIjQhU4j93wDKla1L3QEwVeiYLnYrzseV9dedz2un5V2Xv8TG1/dn2OSZa0uA0z1J33+kosj00iMywH94J0gM7Uloz6akueWovUMTzxg+R119YPnvlYfK5Hg6xF5Iu8pASrdQhpe0Dhk6hPmLUXAdejEWxmRkHBwkwvd/3q+7BGaaNxkQYJ7kY62PBi+qQBR9oVd/iP8i8+Q5qafcMKF617AGf0V+4mZ6CK+OdKwVqLs1ulMvxS443ck5uNMRzRPkFr1IXrHdvXBK5llOvI/eYQSjrCTiPlifO/rJ0DbkQKnfg0SdpYE2WJ9Ma2+eAEivOd2MoXlsPhmzE0gEzSzEqr0W2qndf7mROTe+KvDgoESgzr3WdmZeNKfCkDjys9L8MLIzppeipBmqWVGYXJODrPFzbwXzetDfiAvW6hbWLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(136003)(39830400003)(346002)(6486002)(66556008)(16526019)(186003)(83380400001)(66946007)(956004)(66476007)(2616005)(316002)(86362001)(26005)(8936002)(4326008)(8676002)(478600001)(2906002)(44832011)(38350700002)(36756003)(6512007)(5660300002)(52116002)(6666004)(6506007)(1076003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A8s04hmywCGXPaX3oVHmS8ul9HuP7vd4r+6a8LQAbUpVjX8ZRRt5D3glFjtD?=
 =?us-ascii?Q?PKXYl/jPl3bYQkl9PZPqMacCJeWM4mAUWNtlAVw/lonkaNYgyd3kRbOVtmJY?=
 =?us-ascii?Q?EXi851fVoHIJ1U+ty8ekCeI9wGx5N5cZFUsLGdRpmnI0jN/dQ3jxETuK6yqt?=
 =?us-ascii?Q?UWdti6yEXU26BRuryN0pLJAZ8JNOkQzk4Y2VvJVL9VbnC4i4HcBt3/ANG0CP?=
 =?us-ascii?Q?MlJqe+WeIPlEtsvVKuyTP5ckRo9duAN8SQZrZtrEZDmTwC8CozBmYJfdsO/q?=
 =?us-ascii?Q?lI4sAsUgB4Mm7OEonavHjbztIiNAWkNNoCUfLvgf0c22iLrvwZvyC436CctD?=
 =?us-ascii?Q?PsNPaaWuW4MefQxC3mECjbtU6ej0d/3wvEit3sYmkPEIkTkRYqZIxVqM5Bbn?=
 =?us-ascii?Q?rUq5T5jfOjkc/J+9795jhltB9i2LQGqbM2hnVQS8U1NTNtkIU1ouBnZm25Bl?=
 =?us-ascii?Q?aYs/niB+mvBKuyQKiaOvXBO6GIWEWyozInHZKwhLCu310/r13MMlA/g3p4fC?=
 =?us-ascii?Q?ub89gHyPYQBKfO6lsTybug64b4gdZJYOIqRMAKHE275Y23I+JSxxQ54TTscb?=
 =?us-ascii?Q?l5z1ok/HTgqsNdPHxZmpeck8s3toLSTKl+4PHm9/Enca6gvQ5TVxT0czKhVk?=
 =?us-ascii?Q?3yuQlOcatm4c51U04DCStlSu3F9yA3pnPCqzEfYRgTX0/1QAxtfWDg0xriro?=
 =?us-ascii?Q?e49bcP68vIRLRu45+PGwDeAgfJwL4Ff1BIehnKzRfhR6dDPqHktuECrJ8KY6?=
 =?us-ascii?Q?/2DnUIiy5oraDZABJ6x9z5aaH4rW8F+HfImsetKqQtnxCQNf9KbHkjPiuRvt?=
 =?us-ascii?Q?D0q1E0BD52IVfra93bxSLIWn0+hrwSAwCHM0NKFfEg5o0YcyG0BsUZ0nXBBU?=
 =?us-ascii?Q?IFpuz+Yuk93U85vf9H58Su2Yc4y+RJXK3WvRywjMHNBAtyZUJU+hEga+/fGu?=
 =?us-ascii?Q?l7aoc0IkcStkX3YkeZtgFStUIYs+wbi/tRx+dc4EHWQiaozriFJAVh4HAP7q?=
 =?us-ascii?Q?t776klKPeaEakSz5UODSxSz+DTJu/Qqtoo/U86zyoCtnE/q5rALzBbFhPIpd?=
 =?us-ascii?Q?NsBJIZCD2RIkudtXAIb/LFQtmvuqCYrlgY5J84AU4xY+Ot85f/8fqDQN03oy?=
 =?us-ascii?Q?2uBJ819zUB5Q3zpZLCLnj4KwQQscgIyvjB+jUEzPYrJiJXMzqA6SKMpEYs3w?=
 =?us-ascii?Q?D3P8klJ3cY+cXa9ja9a/YnJ9qVhQaSTUgiiDBEuVxFjXygAZzre19mIx1Sz9?=
 =?us-ascii?Q?B/z3yyscYdHOms2RnQtDz3FFlI4dH8WX9+THHKmFkL+4/qSgI3Kd59wmjuvR?=
 =?us-ascii?Q?AwJju2QoOY5zI8BOGSkzzjWH?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 002dc202-b7f0-43e6-ad55-08d92f348a02
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 13:01:35.4780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9YAI1DE3BGR2H2t2PGW1vsNPJdRSWlg2GTMyGGEtqqKxcKSAyikdGslY5WbFrxaiQzMl3L4rClLSVn4XrpgWPv10Q56MsojRs2JUFKFO6Ho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1396
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series implement Prestera Switchdev driver devlink traps,
that are registered within the driver, as well as extend current devlink
functionality by adding new hard drop statistics counter, that could be
retrieved on-demand: the counter shows number of packets that have been
dropped by the underlying device and haven't been passed to the devlink
subsystem.

The core prestera-devlink functionality is implemented in the prestera_devlink.c.

The patch series also extends the existing devlink kernel API:
 - devlink: add trap_drop_counter_get callback for driver to register - make it possible
   to keep track of how many packets have been dropped (hard) by the switch device, before
   the packets even made it to the devlink subsystem (e.g. dropped due to RXDMA buffer
   overflow).

The core features that extend current functionality of prestera Switchdev driver:
 - add logic for driver traps and drops registration (also traps with DROP action).
 - add documentation for prestera driver traps and drops group.


PATCH v2:
 1) Rebase whole series on top of latest mater;
 2) Remove storm control-related patches, as they're out of devlink
    scope;

Oleksandr Mazur (7):
  net: core: devlink: add dropped stats traps field
  testing: selftests: net: forwarding: add devlink-required
    functionality to test (hard) dropped stats field
  drivers: net: netdevsim: add devlink trap_drop_counter_get
    implementation
  testing: selftests: drivers: net: netdevsim: devlink: add test case
    for hard drop statistics
  net: marvell: prestera: devlink: add traps/groups implementation
  net: marvell: prestera: devlink: add traps with DROP action
  documentation: networking: devlink: add prestera switched driver
    Documentation

 Documentation/networking/devlink/prestera.rst | 141 +++++
 .../net/ethernet/marvell/prestera/prestera.h  |   2 +
 .../marvell/prestera/prestera_devlink.c       | 530 +++++++++++++++++-
 .../marvell/prestera/prestera_devlink.h       |   3 +
 .../ethernet/marvell/prestera/prestera_dsa.c  |   3 +
 .../ethernet/marvell/prestera/prestera_dsa.h  |   1 +
 .../ethernet/marvell/prestera/prestera_hw.c   |  35 ++
 .../ethernet/marvell/prestera/prestera_hw.h   |  11 +
 .../ethernet/marvell/prestera/prestera_rxtx.c |   7 +-
 drivers/net/netdevsim/dev.c                   |  22 +
 drivers/net/netdevsim/netdevsim.h             |   1 +
 include/net/devlink.h                         |  10 +
 net/core/devlink.c                            |  53 +-
 .../drivers/net/netdevsim/devlink_trap.sh     |  10 +
 .../selftests/net/forwarding/devlink_lib.sh   |  26 +
 15 files changed, 848 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/networking/devlink/prestera.rst

-- 
2.17.1

