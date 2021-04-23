Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD5B369688
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243190AbhDWQAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:00:35 -0400
Received: from mail-vi1eur05on2101.outbound.protection.outlook.com ([40.107.21.101]:55911
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231754AbhDWQAd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 12:00:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqxehlFHgu7ZrOxyJLCzUX7xug06eN42ZG4oijAeGZzT3v1/Ke5qQqI7HhZ55lyGGgTA6DgXUAJpAa4D1dMaWN//L9PbU7pNg86VB1vr6pf9wplH//e+p4NCdeuy1pTr/WR9WCVadz+4yTAhS1EhtztywyqhZqj7IWL0KMXwFqqvS0ykqH0txiy3+wRuMXlxbcE3g68juL9HMeVW9//h7X1TUUuVbeZ6g8ske2CBdRrtGZnoH0OMNLN4+eGQBYIKbrxUu/6LofXoamZvF9Br2h9L6S+3I9scqZO3qje5Uz72eh5I20eV+Ro3dHxRcVEWyXRshGnXYVuR+iH42qcCrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0CNNQeVrXccAg/0Wo1VicGHOiKPdxA8Osyr0YPkX6M=;
 b=XZWJ0iXFCqJRWn3uIsLi+8rLNnA0+OpOQT26vJRxP+IMqupT0ki84gpCwdjMFZoe63rAjz/NLpTxzM5DlGYRxrlLOVVeOA+9cry3ROnRz9mYuejBd+m1HHDBnbnqM+SiRwAbKkQghlMmoaTUXH702kiBlDbLaqpdfNV7TufxYtwC5ARevrMvlE9xrm/Sh3fgTO4+nyexW0X4FjiazBwndjfEoEqxGrVwTOpp56tVjCmCqjcIxRNkFCDCzUDkL+rCcdaOzsrLHVmndZFVURzKDC9TBn1GntMyb2e3EUc9bjCS0Y3VxAKHUsTy/sJO3TKUiKwhdLlXGZznbdLiRF5hsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0CNNQeVrXccAg/0Wo1VicGHOiKPdxA8Osyr0YPkX6M=;
 b=ZG2RZ8bfjwv7UkgrnCzOHFCwSxT/gaR8F4E9MWNARdsZ0zjuprDyP2mQxfhdki13oiYg4RoFQjGhiE6VU5tjtFl7T0v2zT69zajuh5bUrW02SoImKBjNpge1/NTZUR8HFI0lv5i0fLTIMClj8A3+pnrntSfS5hijwXWBopCCEJM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0187.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:cb::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.23; Fri, 23 Apr 2021 15:59:55 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c%7]) with mapi id 15.20.4065.023; Fri, 23 Apr 2021
 15:59:55 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next 0/3] Marvell Prestera Switchdev initial updates for
Date:   Fri, 23 Apr 2021 18:59:30 +0300
Message-Id: <20210423155933.29787-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0147.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::32) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0147.eurprd04.prod.outlook.com (2603:10a6:20b:127::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 15:59:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7288ffd8-4c08-48ef-68c3-08d90670d60a
X-MS-TrafficTypeDiagnostic: HE1P190MB0187:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB018705AD5836C70CF9A9194295459@HE1P190MB0187.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SIdojLlJIEfwO/Wfbi+424QyV79lR57IXKbcEAUCgsOkOz07whesUfETAvmNW55WFCPpD2GYdMN+q5qxIC/TJ+cEsWtSjSJWxRSGMWuNg8UA8YM9uH5S2+S6M9g0GOQEUC4YKfHxAjej57KHA36gXJCJLWY+6U38TUh8ZS+po37tdn70u8t6hS3YRt6E5kLDKXHqhMqnCNL3Qxx8gJQi+WHfEXzy3meaMISoGzb9JPBhGxBt5fOtY7iq6aGzG4qeYmdX0SStTJNihgCisRlMeToovRNJC+SZTLZnADfw1fyo+oOT70YfhgZW5+WNzfxDaZoJtrc923c25ApfFKNKy5VqZsdF9lfsAdfnW5EzI/uQNEVMmT5BWJVNaT5JhPLswOwRoWh9CLYQEO4koS2ou7SuhRWuesjXuvdLnc/WDKXWNmUnlgzNs3DGIxSJRfzjxCWYOkU+h8UFmZyzhIhsGGux75uddjXFAM22HHktT50NQXiDdTXrrauiAmsJmrgaDzpATAneS3B/+sir6ApmvEM3wZZnyLii9vzHBLmDkdk4R9276GgA6UPuohzwEJ3PAMQksYBVL80cQxUurUnMvyrm046xdKk49uT2tJR8LQsbAtQBJ2LCEzYRtAQONpcsOf7vd5l5hGmSzsFNu6czgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(136003)(396003)(376002)(346002)(366004)(86362001)(66556008)(66476007)(6666004)(5660300002)(4326008)(66946007)(186003)(2906002)(316002)(36756003)(1076003)(6512007)(478600001)(54906003)(2616005)(4744005)(110136005)(6506007)(26005)(8676002)(16526019)(8936002)(956004)(6486002)(83380400001)(52116002)(44832011)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?BemcApzViP2pPhpBSAZSmDLGXz4sE5Nt1fmg0sJmGa21XlIN7f7rBtsjHCEv?=
 =?us-ascii?Q?IAQPxCuUM8pDmizMAEdG29W31YqBN+FEQph0mOLA5t1dEc/FgLEtaf3bY5pL?=
 =?us-ascii?Q?0trIodalOonlKnd0BdZ+0j5KIsRA388AhdY2yhT2nHo5IE6ZJdSbOhJY3w6U?=
 =?us-ascii?Q?YdNpLAGgWtsM2Dr3Cz77Lia8vE0snBuYaAKxDisvJJpgseQPC7uLaDbl/14F?=
 =?us-ascii?Q?ZgKOmgwGA3SHf3uadtfcqw6LgtxzAaDXaPMlfF51XKf2Hml98uvT+XLqX4kc?=
 =?us-ascii?Q?7T+CfDEmr0knCyizc0gRrj4sRmZqM1lCjnJwmSJt5IMq3fXtUWKg7r+IMb6v?=
 =?us-ascii?Q?DjNeKi8qctPybn0eo1lAFD8VpwaCw2k4vBJjGIu/sxhxfPHWy8snrWVnsxJ9?=
 =?us-ascii?Q?Q38+3eUfGs23tA9IGANQJaCGoby9cAMPCdtJ2UdBYEKve6X4NRWOt2G7bPyM?=
 =?us-ascii?Q?iafGLqxE/ehoBfa1fEAnHXhgChMMs4Su8pQsM5VneDnvwEHCmF0wbDXxHqPn?=
 =?us-ascii?Q?YzwqK79jMZetOf+9aRB4hA0sGmPab9Vu2l6/AQSb0CyZ171oVi2E5PyrNBOn?=
 =?us-ascii?Q?ECQRMtjUl+sBTgvvQgQgF8oUM3+CkdVeGv5ieWAgDnBJHixbzjCzvDOZmm63?=
 =?us-ascii?Q?dFqke9HTQVWCGLVgqlS8nh8ReS5wzzWZWZ225Qx80wnLXkcbwiv7ynA82f/v?=
 =?us-ascii?Q?uQzAb4a6TdYE4XIPQFFrez1opnPxw6UHjgKZ+Kw+YWn4d+mZY8hUqAR9f6a4?=
 =?us-ascii?Q?mIqhzIAvgDdr/DBumJdd2w+QSXfJ72QytPY/4dRo5wEftbmxnHhsnkHvnHAv?=
 =?us-ascii?Q?bNdF6QRUZs/KqkFYCJ//CT9YWFLhiXtpvrAjJIr7G/aaFMLmrxndaJHNxczx?=
 =?us-ascii?Q?PRLL7GFibcBAIjk/FUz3UUeggs/YdUotZatfK1auXww7Au+Onybefi0Y174V?=
 =?us-ascii?Q?TKvPdwA1AFXsX+4FEP9/xzWd4fER6EjqvY7ShicYlAt5hzda22p7oUGlqUxf?=
 =?us-ascii?Q?uKvb/T3oO+pMnsd7yb5I8KhcfDw3BeoVzvwWICk3IVw+N7/CvwS4IiZrgos/?=
 =?us-ascii?Q?2ddOtPZ64CyZM4BfPlqxoByyLVb3rliVKnLK67s24hPmm1X4IzmhRrT3Aord?=
 =?us-ascii?Q?1V15/YAq3lPCJm46AuPgWmGPHwCRQR3ffxoPpACApU3vcVeJLhKv0NX3XfJj?=
 =?us-ascii?Q?y/IXLo9iH69WhwCrapPhul6s4ebQWBK6vCaM+5RuN8flhQowxbDFPUEfj+gN?=
 =?us-ascii?Q?LoKKvr/TYtPNzE8pr6SsBpy7zfSBR5nBpKJBdtT1/bxnrP7rp0DP5eWJZxFN?=
 =?us-ascii?Q?1BBGtko/sTMGVvbWcaR3P1K+?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 7288ffd8-4c08-48ef-68c3-08d90670d60a
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 15:59:55.0613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lwihyeKmcqWyRHEupWDnBfmpuiimAtpOpwUomlBnGgpyxtl+FM0gUpqRVHjZhgSrQ4RKPO1u6oWzlJyK/Uxn48s0qUjzRD6vWJ2/WX6EFaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0187
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

This series adds minimal support for firmware version 3.0 which
has such changes like:

    - initial routing support

    - LAG support

    - events interrupt handling changes

Changes just make able to work with new firmware version but
supported features in driver will be added later.

New firmware version was recently merged into linux-firmware tree.

Vadym Kochan (3):
  net: marvell: prestera: bump supported firmware version to 3.0
  net: marvell: prestera: disable events interrupt while handling
  net: marvell: prestera: align flood setting according to latest
    firmware version

 .../ethernet/marvell/prestera/prestera_hw.c   | 37 ++++++++++++--
 .../ethernet/marvell/prestera/prestera_hw.h   |  3 +-
 .../ethernet/marvell/prestera/prestera_pci.c  | 21 +++++++-
 .../marvell/prestera/prestera_switchdev.c     | 50 +++++++++++++++----
 4 files changed, 96 insertions(+), 15 deletions(-)

-- 
2.17.1

