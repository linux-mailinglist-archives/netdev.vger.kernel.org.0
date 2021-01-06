Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309702EBE3B
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbhAFNH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:07:29 -0500
Received: from mail-eopbgr50089.outbound.protection.outlook.com ([40.107.5.89]:24773
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726442AbhAFNH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 08:07:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hPsxMobOWeQB6p+ZmTGnCV/Yi3AJjGlBv+C+9SY1M1jgeGnCGeUVoC+//AYgRm8DhHzkasVW5Qux7iTyTEz6XfLfUBjlVhiQrt8ZCTfJj2fCQmjI3S9q3d2s12ZfuU+FjluXKYrAt8Z48/A3upl8nEVW213yCNYjF6BxiM6gS/kJIf9/2uf7cY8sR02Bl6THMn+kEvY69x/v50HMzVfXWdfhspQMu0xk1GrJMkS9vAdfE5zOkMeRmjnJ3R2Q5kdsJ0jW4iEbeF+fcpFqRjakt6HwspqGFy5HnKURsm4QeEUkPbUpRyG4+aAIX2wXrIXWxnCbPrB2zvOg5hDkge5tLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43qY31xE+h9qCudJ6kRro8U+GVyxsslpdy27BtwZ4AQ=;
 b=T0mCwBZ+us1yxd3dt719/prO1v+j23eXHz+nvF6z0Rg/L/BkBWn1S0WsWzRBD1w3+F1+NW2BR54KCFfvTE9qWHVhwKqKj0SiB95X/fB3Tm/SRn8L2Pkn9GZ699DvgLizDQ90cNxdF6yPuzsYmgAhsXyqyVBQcF87oywL83WdfPWWI2UPFB2NyT6ceUXBexSW1sXwebn5Eq9CXyeoAratzqWFFsZ53cAQgp/oYDpdlSZ6p8/rfOYDcxT5oUVr6jVYzVrkSsz9Qs9EpClsSBg3U5n5gDDNoKNivGLpKd5N1R06r6iPF+2s4GQ6iV6kD81QF8DSzyjXffTo2fEciTXzsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43qY31xE+h9qCudJ6kRro8U+GVyxsslpdy27BtwZ4AQ=;
 b=HGrlai/tpO1LJdG/OfH6JQj5zQFWkWYSEDIcDPxKO+GBg8EGcKSn6/irR65lnqgk7qzI34W9Ov/Cw8MUyM1TAVT8jmnJ7IgR1pNcBBE8AVJTyZ8nYaBO77lk1cO8CYPolYSVSbcb073hPPjEjdY/K8nsEcEb4ouvewYnKJ35vjA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB4308.eurprd05.prod.outlook.com (2603:10a6:208:62::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Wed, 6 Jan
 2021 13:06:39 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec%5]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 13:06:38 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next repost v2 0/7] Support setting lanes via ethtool
Date:   Wed,  6 Jan 2021 15:06:15 +0200
Message-Id: <20210106130622.2110387-1-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR0102CA0100.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::41) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by VI1PR0102CA0100.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 13:06:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f63a4df5-2876-4a8c-5d15-08d8b243e764
X-MS-TrafficTypeDiagnostic: AM0PR05MB4308:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB4308D0A706B833BD01F83957D5D00@AM0PR05MB4308.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:418;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ifsYKOSGWL/xculB/ABJM/t/SJ53e1QbQ36yxiukL1//XHLM/3OqqLlHpfKX/gH5Hq5Q4z9pAvJEffCSQ8M4ppyHDGW3QCOmBdHHY8CKtN16zclAdq1q4rzlGzA0gAv6Yy9xncBwlo20xZvmsLvQrypVwp+cWpg2NTHmcmYGgC3kpfQ2oLnZwplf1I2seLccsVj4/a1K/+jNO8V8bcw2PzkTvz7hggjlZ2d+H+APE8gC6aBPJd6cS0ROcSjf4T/bHcdNZFZL6PVHWOPLx7hldRk2qf8FQ9bEDLL88A0gx95A2g8t/nl2uQD3GRPfLWy05fN5FykfMmQWeUR4AHdKuImAoxhZJQvP39Hl+4W7uimNmfNDZC9oaUdqszkgA0pHkLLH/4NcvaLbEcQSA4MtcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(1076003)(186003)(478600001)(7416002)(26005)(6506007)(16526019)(83380400001)(6486002)(4326008)(52116002)(6512007)(2616005)(2906002)(316002)(6666004)(8676002)(8936002)(956004)(66476007)(66556008)(36756003)(86362001)(5660300002)(6916009)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RLRcGullzgTEmlrZVEdZJtDfekhHJl8GM9XBfr/Y4Bbr6ANdfCoUZZHJvarJ?=
 =?us-ascii?Q?L3hHUD23KvLGjGM3peKkw/qvEcEyDvfllUhj5rS7lIkgP/7btRqM52DeFA2b?=
 =?us-ascii?Q?I/SYEjp5D/bZxDnq4xxz0jR7Df8tjuBsL+PFwzs9YAfvwnN3Nj/IK0vuHOCI?=
 =?us-ascii?Q?MRFbtVxqLWKZDJI4YfXv1i7vhSYpUhOTjDT6O17y1IyTcHJDdn9BswG//t2c?=
 =?us-ascii?Q?1PxVI+PdJaPfq/1H+imNby7jCKPL21RrhplqQQcXAP+8VCF5HU2cd2H1a60u?=
 =?us-ascii?Q?4iqNQ5c8HUT9CPPSKYK3krwA4w1X34KbP1n/RPz/QZcfXBLArLHbsElEbhqd?=
 =?us-ascii?Q?fwVXhgGB/HPHBJZSmlWEcCHkC2Yr7tHgU12j66jcEKDIU7I+MnhiLnWxYX43?=
 =?us-ascii?Q?WRcXMWYx+aEV6zapqn2Xy3rrDzt9D420aX/JBqDXwVsrMsBUMbsq62rOCGe+?=
 =?us-ascii?Q?7QFFnFcpsKpL4c8xqaUp+N33dC1bYP7AvAuLkL24rqJIU+a1utN3lV08B2oK?=
 =?us-ascii?Q?ltTckBq3F33EkTq7CRs4UX7y+oRR93bTPuSIx1I2fYk2UUXP+1ElIsZZR9Hb?=
 =?us-ascii?Q?QgWEoR8zo/vCsq/D0IeS4FQnNdPk7NusZB2mk1kUVDuZCWHZNddwP+T9GIhF?=
 =?us-ascii?Q?GsZ59C1A64ZBMDQCKrhPS2cbUASQr8/KthXEo3fNtvbIPhOjoaKcN+MqZn+K?=
 =?us-ascii?Q?fEy7YE4NNUEiZrI+oC7sH56mCBtqLknVmpxIaTxQJMLquwHd319wBTwPUx1E?=
 =?us-ascii?Q?8lBC/CK6FNgsinQmu3kVnLGYXrF8TM+deLSCOqVWPIoNOsdejXGuaa+imyWy?=
 =?us-ascii?Q?ROOX69js6vAKYOFDkbinVDDlT8q6ElP3GEH38UNQDGxMxz4i4lm+6VsaXHZE?=
 =?us-ascii?Q?VkjO2qb/adVkqHP3pvlPN8uQHfy+Pys5t9Fw2SYdKEMj1K50vR+/isTf9XmF?=
 =?us-ascii?Q?mY8ZNg8LPTIEuIWiXOq0e8rZQ/81rwwpGmzL2hYd2exRhXajOrjmg6fU7Zh+?=
 =?us-ascii?Q?dkrr?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 13:06:38.6533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: f63a4df5-2876-4a8c-5d15-08d8b243e764
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQyYjlW2hcl8/AmwmYyHJTVnZbItpWoKnjtcystxl2CHsxqN6i8bNCOLzyzUtoIg1O/e0XW76zzwJnRa1Fsj5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4308
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Some speeds can be achieved with different number of lanes. For example,
100Gbps can be achieved using two lanes of 50Gbps or four lanes of
25Gbps. This patch set adds a new selector that allows ethtool to
advertise link modes according to their number of lanes and also force a
specific number of lanes when autonegotiation is off.

Advertising all link modes with a speed of 100Gbps that use two lanes:

$ ethtool -s swp1 speed 100000 lanes 2 autoneg on

Forcing a speed of 100Gbps using four lanes:

$ ethtool -s swp1 speed 100000 lanes 4 autoneg off

Patch set overview:

Patch #1 allows user space to configure the desired number of lanes.

Patch #2-#3 adjusts ethtool to dump to user space the number of lanes
currently in use.

Patches #4-#6 add support for lanes configuration in mlxsw.

Patch #7 adds a selftest.

v2:
	* Patch #1: Remove ETHTOOL_LANES defines and simply use a number
	  instead.
	* Patches #2,#6: Pass link mode from driver to ethtool instead
	* of the parameters themselves.
	* Patch #5: Add an actual width field for spectrum-2 link modes
	  in order to set the suitable link mode when lanes parameter is
	  passed.
	* Patch #6: Changed lanes to be unsigned in
	  'struct link_mode_info'.
	* Patch #7: Remove the test for recieving max_width when lanes
	* is not set by user. When not setting lanes, we don't promise
	  anything regarding what number of lanes will be chosen.

Danielle Ratson (7):
  ethtool: Extend link modes settings uAPI with lanes
  ethtool: Get link mode in use instead of speed and duplex parameters
  ethtool: Expose the number of lanes in use
  mlxsw: ethtool: Remove max lanes filtering
  mlxsw: ethtool: Add support for setting lanes when autoneg is off
  mlxsw: ethtool: Pass link mode in use to ethtool
  net: selftests: Add lanes setting test

 Documentation/networking/ethtool-netlink.rst  |  12 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  13 +-
 .../mellanox/mlxsw/spectrum_ethtool.c         | 168 +++++----
 include/linux/ethtool.h                       |   5 +
 include/uapi/linux/ethtool.h                  |   4 +
 include/uapi/linux/ethtool_netlink.h          |   1 +
 net/ethtool/linkmodes.c                       | 321 +++++++++++-------
 net/ethtool/netlink.h                         |   2 +-
 .../selftests/net/forwarding/ethtool_lanes.sh | 186 ++++++++++
 .../selftests/net/forwarding/ethtool_lib.sh   |  34 ++
 tools/testing/selftests/net/forwarding/lib.sh |  28 ++
 11 files changed, 570 insertions(+), 204 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool_lanes.sh

-- 
2.26.2

