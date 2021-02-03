Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B9830E049
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 17:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhBCQ5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 11:57:13 -0500
Received: from mail-vi1eur05on2093.outbound.protection.outlook.com ([40.107.21.93]:27264
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231220AbhBCQ4l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 11:56:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CzqZzn5XvEYNaHWC5Vogc5qK/oXfUOgMS186tPrT2GI3VWgne3LFKYnaRqJSmH0lfohe0prekgNlHiJUuxrQIwnRpLMeIWgqLMPgk3R7q+5x0RWGDyUpBGde9fN4KZoKij5oUCkNZIxgDhGaICXpiWBUI/q/nwz+HPEvN6BGhf+9yH6M1iyRY050gGP0D6ZGxrbAjsfrI3eYQp8PZq8Ukmm9seGzSUPxxaXE70hwM377pcIn2PDlwKbthwdjbHiaV83jxZWZ+PlXiHJtoowo/VsW0Jaah52nQcVx8YnlKLJOXm/AKltCKqz7FPod8oNeYqyLVbrrb6iSqpp3XaPN9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRLTpYRoz1xDZ/9yQwJolHQXB0MB1q4cHJ6Ci9fML7k=;
 b=Z18rgLE8ygfNh0QZgxioWHAfWmwA7MAXKZf3pN7PT8cB+OgSptp3hTnUz/HnLUkx62oZUkFWFIdj+VxO6ShccAG7NfmZgBqcGraAZNulUhltD7pYn16Dg6Z3Of0kF82VAYbW1nlcYmMY30m45PgK7fs/rv7KrNM2xXuIVMaMMYnF9jYYDJdPO1WVdbv2moHOu86gMvl43/ZFGuH3sd3LbA6dyVRhNfYI7UG1jmfwnkaOIf+me5ScdlTlF9TQWJ33sUowThOSFyMtQKiJKynxSrcESTZFCYixE/FP6r8/6CA0XQR/QdCAO8IMbjed4L5uDPlpoXFncFMHO14xoncf/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRLTpYRoz1xDZ/9yQwJolHQXB0MB1q4cHJ6Ci9fML7k=;
 b=Cvw/n//QQsDuaHgbBskdomRzlf69w2P9oUIAKJPXHRZ0Dt7vRCkoyC3BnbPXyiPYKC4hEqc17GUHWJJ2rZMzeEaBDIYBi0r0M7LrYJfKjEiosmskSnQvh/tA5HaA1KvwghKzfD1gnwIHpwBTxQJNpVzmh5PuZFkhJ6rrnE5VtOo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0361.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5b::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.17; Wed, 3 Feb 2021 16:55:52 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f%5]) with mapi id 15.20.3805.023; Wed, 3 Feb 2021
 16:55:52 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        netdev@vger.kernel.org
Cc:     Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/7] Marvell Prestera Switchdev misc updates
Date:   Wed,  3 Feb 2021 18:54:51 +0200
Message-Id: <20210203165458.28717-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0145.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::30) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0145.eurprd04.prod.outlook.com (2603:10a6:20b:127::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 16:55:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2000cdde-d3bb-4d50-7d23-08d8c8649097
X-MS-TrafficTypeDiagnostic: HE1P190MB0361:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB03610C85A97774508DCC58A095B49@HE1P190MB0361.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zEH1eqbzqfck67O+PuFK14kJgj0acmtiK0q9knl/HfpXyhJP7piuv0ZSOj5eJ7qLUH6MXsdh0aT30Dn6tOa3EemyD41Vrs8eJIvP8M4FBE5JaDq7EYeCsDc4dIOTtzcRHBrx/qAHGlqtKR4QRAkvVEyvdQd4Ch5HmN4G+6dwFDoQ2z4qdB81fy+y+XE9CcKm2HxIKLy/sMu+Ak7xXiQLVe7HmKd+LtTNkgK0ib3jC7tab0Ul5u/Q7BE1ZjqDCee+nXPSZuHXw1+GiZyw+8hNbQfVjlQsbQqDG9dpW+YvXa8uTHtughpVajPdvtbwuPecR8CFK4ZhXIW2rC0PkrNAduFF+BrOS+F06QR+b1pcvVHlaXpmk12x2n5bZ1ElgldqIyo+tUxRFGo3XDIz1qi/8SECN3VmUlGldnOfTripS/5uAJXjloeopa3UVtlYUdl9yKitoaiO8KmAcM6L5wLoaXUFr8+SUBRgr31tb8MKV8rI8b6DRhQrinGOcFtLIdsrrpDIuSfWrb8o1FSReuz+lzM69VwK3C6dX1xtTkuztm2qQfHidf1cbXA9i6r0G/RjPRUbNn2ZR26KeRyD5LatH+8oHDC8mmba/gQKKQqMv+w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(39830400003)(396003)(136003)(26005)(54906003)(110136005)(83380400001)(86362001)(52116002)(16526019)(44832011)(36756003)(6512007)(6486002)(956004)(6506007)(186003)(1076003)(2616005)(66556008)(2906002)(4326008)(8936002)(5660300002)(66476007)(478600001)(66946007)(316002)(966005)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YtIU9tDl7ev2jQraBp90ILb244S0V+Ye6DFcmnMAS/FYBYrZ93qDtuojGhl/?=
 =?us-ascii?Q?66IUb/vrHdBXvODgc/2qQi3pUWIjJohd8DBmZ1PDOMezFgWQZrDoJGyYnh3+?=
 =?us-ascii?Q?TfKaTjCpuLSNBY9a11Wr9VejOOZe+1sW+4cuZ4RJ1ByQ031LSmcU/eM4Y1lA?=
 =?us-ascii?Q?P7fX0GsQRmEitNQzH0XgvgzTxKbFuusNdhr3mRrxgnNJP7IQErPbWyXwlhn6?=
 =?us-ascii?Q?nort9BQ6oZGtNKxiLkPgMBtw5gPLQNKSl5kugiBQGMhbbAF43ZXe8m4cTs+x?=
 =?us-ascii?Q?pDrLDE2QORfucX82tC5Fu38MNJubw2H2TTaqSdryNhcW1I1eQC9CkAw4MaeU?=
 =?us-ascii?Q?JiYGQBQyh/0qf/0Q6mS2Ty3a2/Y0l0IEX641dWpFs04QhwA6kEIN9iZM4CRF?=
 =?us-ascii?Q?VkVKKUmfGlIqbyexVkTXpC+jNp7m+P8SqpQKTeqq2lsJcl0IFx3q6XZYP/P5?=
 =?us-ascii?Q?u6Dd/zFpbvL04edgtLwC/C06EOtQhtPyQg9Go4p7DJp/dAxovQWAObyJCCmf?=
 =?us-ascii?Q?BEg4lMVzSY5ZRjtt8Kwan/WStKFCLynnqUtC4FwnjiSPwnNjr8UihbdaYKcC?=
 =?us-ascii?Q?/+FjFXvxfqEqTp+FhITrHb9pnMxFMCRJep/lum33WuWKVfnXNJcfkvaE0QgZ?=
 =?us-ascii?Q?bwur1Qt9b4RVl3xUJAMmwg+x0BqJPquM9d+D3JoY7pN9I9XT+Im6DPpugtRS?=
 =?us-ascii?Q?YXXQCFx5xeAHEB5T9evQPYN970cWqdGgUriDzXF52G3LDlPL1oKhyQLZe16w?=
 =?us-ascii?Q?fl5i8Td05VXX572oybzgDNSmmd9KQxyQqCJIoF3fW1WmeQrfLFH8ZsBHFUE8?=
 =?us-ascii?Q?gdlglLp9jXYvh+wMF2CbTshqNiGPV+vFheKiIaqdRosCUFH1tDxh9aGtdKGD?=
 =?us-ascii?Q?e8PppZQQcbaKJbqxE9+W8td+5aTOYTeO83H4wesXhe7GALMZgYvyqUqgRAxU?=
 =?us-ascii?Q?tmYuKbMjrCpdGXzPEw5G7bBvJfR3Gvqkn+HYGmrK6nQj+19wHT2Pst4f09Gy?=
 =?us-ascii?Q?cbAUuVVRGM6HWYtUn8VuHA2/u7z3H/3qRvA29Da/E4NHkYI7/CPZsVj6NNpR?=
 =?us-ascii?Q?eT6sLXcqGfgFTPjYdCGBCTzSSU1OPELJEMEwNnY8jazJZl1UHJKLn6wQDqgN?=
 =?us-ascii?Q?Qlo5obKCbhz1B8NQsdSAWSvlSYmNlK/jawJpChg4nfAoG4E8k/iDwbi6qCbX?=
 =?us-ascii?Q?EN4mNs/IjTvSg8E/DyTt/D56a/VQBFjsfaq5pwpYugu+8D1R/xkaHM1bZXDG?=
 =?us-ascii?Q?hrG457WZC5qhKTlATk4rdBJ0u0w3CHzUVQCIu0xHC3baludhFgdUayRpoRKv?=
 =?us-ascii?Q?gcSa4hl6+rI5ULGN2W9I9aOp?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 2000cdde-d3bb-4d50-7d23-08d8c8649097
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 16:55:52.5744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZBVs/YXh4xO0DZeOTub84QatCwDyX+vRaQxWbJ3rB8TtVvXwVG83unrfeCuAPAXqKHpEVA/xVejRx4/y3neWnst4qhdlDGlEywAVLfZdzUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0361
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for new firmware version 2.5 (pull request
was recently send to linux-firmware):

    https://lore.kernel.org/linux-firmware/20210203141748.GA18116@plvision.eu/T/#u

Add support of LAG offloading and AC3X 98DX3265 device.

Serhiy Boiko (1):
  net: marvell: prestera: add LAG support

Vadym Kochan (6):
  net: marvell: prestera: bump supported firmware version to 2.5
  net: marvell: prestera: disable events interrupt while handling
  net: marvell: prestera: add support for AC3X 98DX3265 device
  net: marvell: prestera: move netdev topology validation to
    prestera_main
  net: marvell: prestera: align flood setting according to latest
    firmware version
  net: marvell: prestera: fix port event handling on init

 .../net/ethernet/marvell/prestera/prestera.h  |  30 +-
 .../ethernet/marvell/prestera/prestera_hw.c   | 217 +++++++++++++-
 .../ethernet/marvell/prestera/prestera_hw.h   |  17 +-
 .../ethernet/marvell/prestera/prestera_main.c | 275 +++++++++++++++++-
 .../ethernet/marvell/prestera/prestera_pci.c  |  22 +-
 .../marvell/prestera/prestera_switchdev.c     | 175 +++++++----
 .../marvell/prestera/prestera_switchdev.h     |   4 +-
 7 files changed, 657 insertions(+), 83 deletions(-)

-- 
2.17.1

