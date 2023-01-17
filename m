Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C8666E260
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbjAQPhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233878AbjAQPgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:36:50 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABB64EF6
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:36:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbuZIVoVdfk8xvNvsjOYZEUUeKGFlonxHYXo1S4MVHDmbottjSMlC89PRHsliMg06yXxftN4F6CtwlNyi+peImsHuqNIUBSnN90UxqOIX/MQCemw2mKvZP3kX/i3GD0DNaYvvj0R2YPPgpBT87pWtoqh+yr2ZzPkyyHvE85qWeYKz/i3V0dHbNOi2yIInRnyPO+gmfa+Fd4wDGsq4c/tbYZZOIKtoyYdsysrwlPdOiiJJhAccHPX41CsANv9VDQbmWSFdq787fVL4NgdGeJ/MV5N9FmNv40/4UR/Fl2RpjwjL0T8RRo+MNq9w+ftJRTDHMxq4LmWk70u9k2vxh6zKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OTFuomx3H2g4ycx2lE6SHoYw1M4tBAYQPMZm5nb8Z+I=;
 b=UKOa8e6CjP9sH0gnW3cm1jvYWsJDC9OmPKWj8z5VXMSkKJaV+7byai9ErMKtWqx765uVmw6hKxMLEzm2PrN9jAF6wpf+1D+9mL4LSwvOZGyWD60t2ZGvlBesT9atySlPTKj4p6DyS1lmutVGJoNhfP9+Y2GGE1YbIg5NmcipGKMhxqb3uy4ZfwVPSv4HqCt2ZAgpwx8FABNafQthp19vRd1LZochqyxVGS+ZTRRH7KrQ4rKUOBl57G1ZK0kBM/tW94VjSvFyzbua0CVM4huf/AGr++fdrJzVJLFVxheBMsUh72zkIIYsuvI4GDyIuQtuHTMRhq0nljupIieQ0aCpWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTFuomx3H2g4ycx2lE6SHoYw1M4tBAYQPMZm5nb8Z+I=;
 b=pqrM6pGX2zVBbLWWtZthahd43QJiBsZMy9wJFEaBIpU9kNlXW9bLlpy2L0uHJo1gyH1fwqq3lAMQx1MROqjhw+q2l+5ygXk+7l1ICbsiMpbNFS807uf07bqA/A2YZcGVQDLEssLOWxic/bitotk5BfedDyW8GDPRB6x5vKuGsHx03KvljAnLkYOJrKWKJQUGcT76eMAwHTK9trRpqZ4+9xq83OQuSWLGqIl9+pxzdMZN2DzrTHAFOs3HfSBPb5jtiB4AJxZ4DQjQIYXdGlnrd/JZx+aT43OvF+5bdRLEGoPQRha4F12TCpQmd/2j3lCYnE2Ral3pj/Zt3rzMGjP6Zg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH8PR12MB6889.namprd12.prod.outlook.com (2603:10b6:510:1c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 15:36:29 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:36:29 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v9 04/25] Documentation: document netlink ULP_DDP_GET/SET messages
Date:   Tue, 17 Jan 2023 17:35:14 +0200
Message-Id: <20230117153535.1945554-5-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0069.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::22) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH8PR12MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: 673b9c38-243a-4133-6725-08daf8a099f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jTYB3VnXSjv3FQxVsssYNQ5py0L0cCZhmxvE9PpAcEwyEh9MZB30VM1iVkF89o5jB7X42yX+W4mg+WYRcpBe/yTsss8slLSFh00AUP68lLWZRbThT5b23e5MIm0mIf3aSgEV12947vBgRnxXqPfmAbpYUXA+ZjClVcR27W54pxRLF7GdfpiNtKcjGmnPK5g+t6qyBavlgJWFU7JTjlGLz0k/dCkwPtIGTrhO+BOOGyPEm19GvI2ruQln3CKSzA7L+lEMCp/zJu75v3nbRljtXBmXx9l7BfCZfHO/JQXg8ilpg/jviT1zheP8GmNMxFaJfFxYLz1/5nRHg+IoU3RtXAZD0OcrOkhhHuBYEA+74ja9K9HJiOKe41NycIG4g1HZaaNlGoMsCn0AHIEMCkCC97f19QJXA6vfok/pi6E749ZTN7SYS7oIQvKSSoVQ2lsAm0EbelMOdC3hEgsB3TWpZ2lBJDhCbe+HZ3UhW3Y2AW/1dRDLuyQ/SJ1JMcSxvX/VS8Bo9C/VJjYsdiMPGHcrS2PzAnvze5hqp+EG6+KaOGYdNjys22V89Ncr3SSYOvuH8m3bfiXUzSCxEbN9CDOOjYEkLWa/r1pyks1/SX32gyzQfk5Bf1Ci262w1aUcNqJroNMEYVnQZZIZ4/k+xOrwCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199015)(2906002)(66946007)(26005)(4326008)(36756003)(8676002)(66476007)(66556008)(41300700001)(186003)(6512007)(1076003)(6666004)(107886003)(6506007)(2616005)(83380400001)(86362001)(316002)(38100700002)(6486002)(478600001)(8936002)(5660300002)(15650500001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Su20aG6K5tmJ1AmJ6ZryX3ISSSccjsFGnM0TCJKiJ5IRv62vzY3wXeIbeWaG?=
 =?us-ascii?Q?q3IyN4T6yDgf9tOVTUQDAuC85l3mbu6YiqrO1tyn3rgJe5jqhSRTNqEE1jC6?=
 =?us-ascii?Q?0kThHpG5aadB+92egYxmbiJitTMRLmQZ6TVHlDS0W9JRBdcipHS2Tkp9bR31?=
 =?us-ascii?Q?56gj+3iYeSFcs63+0Fi2iIAHtdcsEbV+eGUrHnB80Zl1qDmA9X95bT6qaDY5?=
 =?us-ascii?Q?/gkGXTKyo7+GbKxvgb7b+ngD2zbIPhPgXNJydDK2zKSnvOZF3YEYyF7rdIrM?=
 =?us-ascii?Q?p4k6IhhkmzNYDcqssP9ws6faiM6dXlhkqNa0ZnJ9OYxYDQykAqljeWINFasQ?=
 =?us-ascii?Q?IZb1qd5p07mLnlATbrelYDMgy6V9/ZNyjMZhzwwcNLMXKmA9LhdfiT4fYXq9?=
 =?us-ascii?Q?cURrMBMS0zpk6EfMHR+dGMC2UJ/axNA7pbp0wCbo4UO59DU6JKKcFRkBu0Mv?=
 =?us-ascii?Q?IVsfT70X5sS8Wvnw8tpO0ikjH65Zbn63BRxg4DMAt5UjsUf516bs+4khqvzu?=
 =?us-ascii?Q?8p1pOhKtkTpfecJDNrG5SSYY9c4BL4wLCDOilOfFjRKsrU50Hhknuwkm0Lh7?=
 =?us-ascii?Q?MuQYl9vMqalKIqImclIi1PpmwanfzQpj2fbGk//gKxeogE6qx767ELVKt50S?=
 =?us-ascii?Q?9PPhSw6buiyjA8pWKr3WJh28SkgwWQAN4td6ieJzacad1Iov/xgms5VV38yc?=
 =?us-ascii?Q?BYnr0u8ubYnn6+5QGdw1cUj+J4r8Udg7f3+56XNPZUVoZFA0bCccokPuZrhI?=
 =?us-ascii?Q?gDBkjGzTRznHlnJP7QQIyVx8mmrPyg6zJwPREa6CmaxqBKgpSm9btarj90C0?=
 =?us-ascii?Q?1bh9T/2HfK7810qEM9wdz826B5wvJN7NG4WwdL1TGSOxjmEQDqrA5yZtEyRR?=
 =?us-ascii?Q?lKDBjPe4wF+C1MS+ZuMbh17q7k9KtVwJi0JIlN7m9GqUZTlkZkf3nmSF6d3p?=
 =?us-ascii?Q?nRTlatsKB9TDlXYc8Lotv8YE+Zbchlua38kt2DgeGY4UcN3uz9ZL29sfYPp9?=
 =?us-ascii?Q?3786mB6p62cvmyfKuGWsG1AKCXuPX/2Qx3KhzKQyesoFZd1MLaq6O85Bog20?=
 =?us-ascii?Q?KOYZGvfD4k9n4dV+/+d+LleB5HJ2+9Rt0FYqMalr8op3Ij6CKFZ76GIrCADZ?=
 =?us-ascii?Q?IVDgpduobvdyWegVmrNGVXiGOWJ4aYRbdP4JilnCCg2h5H6T9Y4Zr4lxLYP4?=
 =?us-ascii?Q?7lhU0a1AO4IcLYh0sp8RM1MhA3L715rQmQFGNjArDtqlswLrgvsWO6pff1QR?=
 =?us-ascii?Q?Ly7Hkxy9Vt/O7cLS16CozVAYpO1rWijgaffeePvfN8C0vr1x1085pyIhF4Uo?=
 =?us-ascii?Q?6qKgUKTBAtGajeA4C7HHAmdeJIC5s6Fh5UxQQ7uTABz1ccWQSO0w6TG1xcgQ?=
 =?us-ascii?Q?EJDKvtqxQfyVotqbYIDDl9quTkCbwdPNgPnz/4L3CXCVHyB/qtAfya2qyZmR?=
 =?us-ascii?Q?dXRL0+fMYz2MWF2oDMytqjKCuLaYEIN4EijjF/kBIutMmv/Ay3YdHLm9d9Kw?=
 =?us-ascii?Q?VYLDSRcimx+HLOEu7i5xcxf0AbZ9IOPW7I9jjSIn6uZhxMraZF99s57/yAbb?=
 =?us-ascii?Q?6wXS5pVCVJQWlZogqKW5PGkiX69hzSW11M5CSD1A?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 673b9c38-243a-4133-6725-08daf8a099f5
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:36:28.9204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dulY3SI9kNS12R/8Rl6DXW2cVJbZ6Uaf/GPO2xk3/cChouk024i21ddUlqa6CaXWVmlPx7kIbwNVsLs4Pc0KzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6889
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add detailed documentation about:
- ETHTOOL_MSG_ULP_DDP_GET and ETHTOOL_MSG_ULP_DDP_SET netlink messages
- ETH_SS_ULP_DDP_CAPS and ETH_SS_ULP_DDP_STATS stringsets

ETHTOOL_MSG_ULP_DDP_GET/SET messages are used to configure ULP DDP
capabilities and retrieve ULP DDP statistics.

Both statistics and capabilities names can be retrieved dynamically
from the kernel via string sets (no need to hardcode them and keep
them in sync in ethtool).

Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst | 106 +++++++++++++++++++
 Documentation/networking/statistics.rst      |   1 +
 2 files changed, 107 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index d345f5df248e..594803fccace 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -223,6 +223,8 @@ Userspace to kernel:
   ``ETHTOOL_MSG_PSE_SET``               set PSE parameters
   ``ETHTOOL_MSG_PSE_GET``               get PSE parameters
   ``ETHTOOL_MSG_RSS_GET``               get RSS settings
+  ``ETHTOOL_MSG_ULP_DDP_GET``           get ULP DDP capabilities and stats
+  ``ETHTOOL_MSG_ULP_DDP_SET``           set ULP DDP capabilities
   ===================================== =================================
 
 Kernel to userspace:
@@ -265,6 +267,8 @@ Kernel to userspace:
   ``ETHTOOL_MSG_MODULE_GET_REPLY``         transceiver module parameters
   ``ETHTOOL_MSG_PSE_GET_REPLY``            PSE parameters
   ``ETHTOOL_MSG_RSS_GET_REPLY``            RSS settings
+  ``ETHTOOL_MSG_ULP_DDP_GET_REPLY``        ULP DDP capabilities and stats
+  ``ETHTOOL_MSG_ULP_DDP_SET_REPLY``        optional reply to ULP_DDP_SET
   ======================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1868,6 +1872,108 @@ When set, the ``ETHTOOL_A_PLCA_STATUS`` attribute indicates whether the node is
 detecting the presence of the BEACON on the network. This flag is
 corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.2 aPLCAStatus.
 
+ULP_DDP_GET
+===========
+
+Get ULP DDP capabilities for the interface and optional driver-defined stats.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_ULP_DDP_HEADER``          nested  request header
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_ULP_DDP_HEADER``          nested  reply header
+  ``ETHTOOL_A_ULP_DDP_HW``              bitset  dev->ulp_ddp_caps.hw
+  ``ETHTOOL_A_ULP_DDP_ACTIVE``          bitset  dev->ulp_ddp_caps.active
+  ``ETHTOOL_A_ULP_DDP_STATS``           nested  ULP DDP statistics
+  ====================================  ======  ==========================
+
+
+* If ``ETHTOOL_FLAG_COMPACT_BITSETS`` was set in
+  ``ETHTOOL_A_HEADER_FLAG``, the bitsets of the reply are in compact
+  form. In that form, the names for the individual bits can be retried
+  via the ``ETH_SS_ULP_DDP_CAPS`` string set.
+* ``ETHTOOL_A_ULP_DDP_STATS`` contains statistics which
+  are only reported if ``ETHTOOL_FLAG_STATS`` was set in
+  ``ETHTOOL_A_HEADER_FLAGS``.
+
+Similar to the bitsets, statistics can be reported in a verbose or
+compact form. This is controlled by the same header flag
+``ETHTOOL_FLAG_STATS``).
+
+Verbose statistics contents:
+
+ +-----------------------------------------------+--------+---------------------------------+
+ | ``ETHTOOL_A_ULP_DDP_STATS_COUNT``             | u32    | number of statistics            |
+ +-----------------------------------------------+--------+---------------------------------+
+ | ``ETHTOOL_A_ULP_DDP_STATS_MAP``               | nested | nest containing a list of stats |
+ +-+---------------------------------------------+--------+---------------------------------+
+ | | ``ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM``        | nested | nest containing one statistic   |
+ +-+-+-------------------------------------------+--------+---------------------------------+
+ | | | ``ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_NAME`` | string | statistic name                  |
+ +-+-+-------------------------------------------+--------+---------------------------------+
+ | | | ``ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_VAL``  | u64    | statistic value                 |
+ +-+-+-------------------------------------------+--------+---------------------------------+
+
+Compact statistics content:
+
+ +-----------------------------------------------+--------+-----------------------+
+ | ``ETHTOOL_A_ULP_DDP_STATS_COUNT``             | u32    | number of statistics  |
+ +-----------------------------------------------+--------+-----------------------+
+ | ``ETHTOOL_A_ULP_DDP_STATS_COMPACT_VALUES``    | u64[]  | stats values          |
+ +-----------------------------------------------+--------+-----------------------+
+
+In compact form, ``ETHTOOL_A_ULP_DDP_STATS_COMPACT_VALUES`` contains
+an array of unsigned 64 bits integer of *count* elements, as a binary
+blob.
+
+The names of each statistics are global. They can be retried via the
+``ETH_SS_ULP_DDP_STATS`` string set.
+
+ULP_DDP_SET
+===========
+
+Request to set ULP DDP capabilities for the interface.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_ULP_DDP_HEADER``          nested  request header
+  ``ETHTOOL_A_ULP_DDP_WANTED``          bitset  requested capabilities
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_ULP_DDP_HEADER``          nested  reply header
+  ``ETHTOOL_A_ULP_DDP_WANTED``          bitset  diff wanted vs. results
+  ``ETHTOOL_A_ULP_DDP_ACTIVE``          bitset  diff old vs. new active
+  ====================================  ======  ==========================
+
+Request contains only one bitset which can be either value/mask pair
+(request to change specific capabilities and leave the rest) or only a
+value (request to set the complete capabilities provided literally).
+
+Requests are subject to sanity checks by drivers so an optional kernel
+reply (can be suppressed by ``ETHTOOL_FLAG_OMIT_REPLY`` flag in
+request header) informs client about the actual
+results.
+
+* ``ETHTOOL_A_ULP_DDP_WANTED`` reports the difference between client
+  request and actual result: mask consists of bits which differ between
+  requested capability and result (dev->ulp_ddp_caps.active after the
+  operation), value consists of values of these bits in the request
+  (i.e. negated values from resulting capabilities).
+* ``ETHTOOL_A_ULP_DDP_ACTIVE`` reports the difference between old and
+  new dev->ulp_ddp_caps.active: mask consists of bits which have
+  changed, values are their values in new dev->ulp_ddp_caps.active
+  (after the operation).
+
+
 Request translation
 ===================
 
diff --git a/Documentation/networking/statistics.rst b/Documentation/networking/statistics.rst
index c9aeb70dafa2..518bf0cbeffc 100644
--- a/Documentation/networking/statistics.rst
+++ b/Documentation/networking/statistics.rst
@@ -171,6 +171,7 @@ statistics are supported in the following commands:
 
   - `ETHTOOL_MSG_PAUSE_GET`
   - `ETHTOOL_MSG_FEC_GET`
+  - `ETHTOOL_MSG_ULP_DDP_GET`
 
 debugfs
 -------
-- 
2.31.1

