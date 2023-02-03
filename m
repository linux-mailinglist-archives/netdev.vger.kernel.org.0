Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7336899AB
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbjBCN2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbjBCN1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:27:52 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2070.outbound.protection.outlook.com [40.107.101.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4B895D2D
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:27:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sassqy6BAVd3t+oc3EoxRDJUsetuFPNQcUi0eEyWrUG+UcxhtOmpe2h1eq069WAE9xlZVF3UzsPjqydVphuzubzCeKhchqyjEITugLbXVG6Y2yT/BNA03QuSLUs3BRpDOvvGne27KwW3BR9tm/NYPpEtCvtkN9tvxufJIq0tSj7w6sXeNPicVapFRNYrSTi+aOmIyC+iX/Czp7CvzDjen0oC/k5kw/T1GaCzyPEFZnCjpqpJ4J1b85HMuONoqwrUJVCXG6+F5Cnzppbaz33fSpaw1Y4R7qcPNs0Y1Z4QeWrWla3T6zaDgW0fDlTqVt7wWqqr3Q5aKR91E4FFeCwEWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rD4XJY90UfXokc+MvVFaAmKoINQuVQA3I8EhIryF778=;
 b=WvGXNmfnwSj8ZDeIFPHDwqEEMLKr861L4jnOOce30lYmwOaR1oSy9K8oob06lLRf/sm41iDhFep528vgkxA7hr3SDIH7pr0zllrIFg+LlWxxUS8k6hrc/ZM0DtOoeJL64v3xiesmiI04oA43bdGCmibrVrhBaApBZL7uOYnILI0DiBrvlh7JDZBzRyzlI51fTgfupA/ESPoR30EpWH86Fd+3x4mcKvTWb/MrOLxzW3706RpednVnoRxElsEzbCQcl6CbigUs7KK43lZcJtVDTTjGA2AgI1MoJuKUnznn1bjVH6PV4q831UIngMSyweJL5Ig2I42G3bQROpfJogK25g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rD4XJY90UfXokc+MvVFaAmKoINQuVQA3I8EhIryF778=;
 b=RTWpzHL4Mcs2oWjKLxBipcmufU8ZjAjcBFn09DMwjZlkPC4Y8WicchHJe1rlB/FhbajxEGh892qNRVEgErrg8bqOdIbmnkZIRUTkkicdSsrOQHnIt6lpqa+xCJSNYLe70XvvlqCt3cFh+90a4CnQXezc8Qt2ez4NVypT9DX4zBCb7L8WdZeP8UqFKXKYDgixG0rrvYQjvp/+Vak6dhJ8BjlgogELMKF5oK2ciANs9QtpW0nwLnoDwVswj6t+kYPANFRTCvYnIyeeKj40vbL68plF0YRxTuGxGPQjpNDgNdUaFRFUXLe2b5ETwooauhN9Boml6p4xnAFoiO2MbtvdlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by IA1PR12MB6577.namprd12.prod.outlook.com (2603:10b6:208:3a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Fri, 3 Feb
 2023 13:27:44 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 13:27:43 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v11 04/25] Documentation: document netlink ULP_DDP_GET/SET messages
Date:   Fri,  3 Feb 2023 15:26:44 +0200
Message-Id: <20230203132705.627232-5-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0105.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::20) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|IA1PR12MB6577:EE_
X-MS-Office365-Filtering-Correlation-Id: d214b4b5-8226-44ce-d1ea-08db05ea6e6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8o5WHXI2xgu0CEcnLKI1swhFVgtR44zLUtEWL/5jvvULdtx/AEwTTcwiAfv65JmLnsDnWxZyVFpTYdWrL54B2Qk3a/JOC3hOESgIE7NvPgSY4Wlc/EGeFtvQA1sBsGc1/cKCg1co9Ja/vgDV7c96LyGD98PiLxezYoYZR+CwatffBE/hbuxhtu2LFlSCH4BdbxXwQyQON2OPC9/nXwDChKVVZJpV2RsTCzQodniyUY3vkzivYhGjnRTHgegGw+hkM5XyccHeCpt+WR+y4ZvasIoxhk7xZmUnRgLOA2UEYP5gy+9TeWlgEVwia9/lfDAvLD0qmDb1DOrf1HwTCWhZFvKZc0FEuKi0S6jknteVN3SpKAtxJLCdThb4aMxlLLtdv6rbQul8lKDkw41H+ireBFzkNtW37BPTqDP4TSjexZwDHPkfnMGdjTS30q3u5wp96sqRSGqWAhS55zFzKlCKOYwOszgg4gtj2Jz8Sx1dZ8jvaD03Y9y0ZBQl6Du/WYEDi/bdMwgHHo4qmrI9dqLNuoDonXAGu5KtB0olnBBVn7VIFj5kb2FVT47pJNBekRz6Q2/wURDYr2bqnAxU62FP5syDtaPsEkGkrHa+zotGCBLQ4vQfz6Vi7JzodbV0UtxQdTye+l+uBTkMhWkY59chcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199018)(2906002)(15650500001)(36756003)(83380400001)(2616005)(316002)(107886003)(6486002)(186003)(478600001)(8936002)(8676002)(66556008)(66946007)(6506007)(66476007)(6512007)(26005)(5660300002)(41300700001)(7416002)(1076003)(86362001)(4326008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u/dbFfvA+o/6h+ymM5MTeHaGNIdnDYI6bVqxLpyD+nt5XrBu8+dOpQ/ROT+E?=
 =?us-ascii?Q?xp0tWxNQSJD6S4Duxx+xIDDarVlI1pi/AJl/oCB5hAfU5Oh9dnD2LyAM2fXy?=
 =?us-ascii?Q?x2PKwMrxZMLbEXr7fADKOtqCghggnN+ZWe+CuOODHObHrbwparXfzenHURbf?=
 =?us-ascii?Q?lXJPLnMBQ9K4uu/vGtDVDpCHG/Yz120PYru73XUWZf0Y7vNxjzJf7/pRsfEh?=
 =?us-ascii?Q?WDj3++RQnGF1mUyB0zib9Bclqe0pkRYk9n7qDoKqr8yFAcTvX4qlNFTk2epq?=
 =?us-ascii?Q?bpjor/boLt3B+JzdywvwsTF59xNHeHzrsn6CmzOOBdQO+CuHVVkLNXuC+IwD?=
 =?us-ascii?Q?i9vXnxi30Z3fGvoC0bsbj+UVFeaDKPcx84KeXbv7pNT3mrzxnedwD93zub7M?=
 =?us-ascii?Q?ts2JVkpjCvcxFwEyDYytNFQYW41aLZd0iP1Zoqo6j1sb2eMh/b5eh05oEG+o?=
 =?us-ascii?Q?OjnMIGXxKjDd1cddYwiGIo6i2y5NpZGOCi6cerQkuDpcoxQaJFsKceezQ66Z?=
 =?us-ascii?Q?ehe0amJDQseperEWah5X9C2Sh75vDCgXctb9YBQMPA6OBqDNQrn50/P/1v/K?=
 =?us-ascii?Q?jWfNXHdqCnejZPMahJbidFS4qNdOpM7nXcameDC2dpy0PO56U3PkuAjPriUY?=
 =?us-ascii?Q?twHUjC80j1A9a5HSHxnZ09rDmtuYByGLe8huly6Ptwa7mbYaEx3qouL5D2UL?=
 =?us-ascii?Q?FzWq8o0UBIsmHPxlfykAO98We8lrU1TkiApVlm/XyX7dKHU+q6L+L8UnmdcS?=
 =?us-ascii?Q?6ud3pKeE7+AJZYdLHe2nTDDNdabHg/i7bqnP3dhnI5TZ74Ij007swbvYVF2r?=
 =?us-ascii?Q?nZ+3Vvw2xfFNoW/lg5vVtxqWEJmwVkcaQIoY8Pf7GLqwtaH5ttPnMer7qvjv?=
 =?us-ascii?Q?o/hucSUgCDb3kLzMmYvh99aDC2CMcmGyypZqjogER4wP77szoOzhgEYEIs0l?=
 =?us-ascii?Q?W0l2F9Rhpxv0Un3/UsaKFuO7h3HQ/YqjL/YiKI5y5PeyX0jyfZAAEehFR/NP?=
 =?us-ascii?Q?BndzpjFEY+hdGPTdfAsQv00j+uGSw8Z7b6zVPoGKGoFpaWWg9J4xSVtgeu60?=
 =?us-ascii?Q?Nv2Kl/g4LECny6sSwDJ0KcxgLYSaAS397q7+qC59bAl9gNr/NrJF9aAQhCst?=
 =?us-ascii?Q?yH+BVKKIjlQWQYEWusCyj05GpV1EkrRPNex9JD0GARhhqnPVtmlcwLrdfPAR?=
 =?us-ascii?Q?ZLxhWEpfDDFcSHyHqPTgaAy6VJQ+fAv9KSUP/37WiGsXLumNBA5zkZ8/F5u9?=
 =?us-ascii?Q?aPElc0Ippj+GTm8tjLZcOI2GYGHuYQwH/W9oM8TSOlQKg7TTklr6vIsvUyXY?=
 =?us-ascii?Q?H1jJfTlq6DrmbiQnMWLgQnpUnrsvwP+7Z9xU/aRI+8N3X51F2ZMXEogWatM1?=
 =?us-ascii?Q?UGbuofB7bxp1GeZ+fJOHxY/+Th4cfsjwnOGwL0VjyGfAzdIDRhCLISWxX5S6?=
 =?us-ascii?Q?l1v2fCr/QdDXgf5pGvEY3z/fQ8laOMkltTT4Qjz3inapK4TUNQbPaGQ9PYiW?=
 =?us-ascii?Q?d2WWFkjIpS5VUA28U2Rtx4HOIq6ReCe9TQgm7VgDKNP5N9nC9jVlOdL3jCNw?=
 =?us-ascii?Q?b5adHoQs1JRsUMb0sy6CpnlvMHOW9fnpiP9/ef3G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d214b4b5-8226-44ce-d1ea-08db05ea6e6c
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:27:43.7574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9nN0xUoNjWjcLWp042SUn6SJcWLVi1YjevfNJ+4vnT8WI0Rzsx4/eib3EtgxVBiPjj9KquOz/aajBcNQHfCdsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6577
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
 Documentation/netlink/specs/ethtool.yaml     | 102 +++++++++++++++++++
 Documentation/networking/ethtool-netlink.rst |  92 +++++++++++++++++
 Documentation/networking/statistics.rst      |   1 +
 3 files changed, 195 insertions(+)

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index 82f4e6f8ddd3..8932cf310f1a 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -236,6 +236,67 @@ attribute-sets:
         name: stats
         type: nest
         nested-attributes: mm-stat
+  -
+    name: ulp-ddp-stat
+    attributes:
+      -
+        name: pad
+        value: 1
+        type: pad
+      -
+        name: rx-nvmeotcp-sk-add
+        type: u64
+      -
+        name: rx-nvmeotcp-sk-add-fail
+        type: u64
+      -
+        name: rx-nvmeotcp-sk-del
+        type: u64
+      -
+        name: rx-nvmeotcp-ddp-setup
+        type: u64
+      -
+        name: rx-nvmeotcp-ddp-setup-fail
+        type: u64
+      -
+        name: rx-nvmeotcp-ddp-teardown
+        type: u64
+      -
+        name: rx-nvmeotcp-ddp-drop
+        type: u64
+      -
+        name: rx-nvmeotcp-ddp-resync
+        type: u64
+      -
+        name: rx-nvmeotcp-ddp-packets
+        type: u64
+      -
+        name: rx-nvmeotcp-ddp-bytes
+        type: u64
+  -
+    name: ulp-ddp
+    attributes:
+      -
+        name: header
+        value: 1
+        type: nest
+        nested-attributes: header
+      -
+        name: hw
+        type: nest
+        nested-attributes: bitset
+      -
+        name: active
+        type: nest
+        nested-attributes: bitset
+      -
+        name: wanted
+        type: nest
+        nested-attributes: bitset
+      -
+        name: stats
+        type: nest
+        nested-attributes: ulp-ddp-stat
 
 operations:
   enum-model: directional
@@ -390,3 +451,44 @@ operations:
       name: mm-ntf
       doc: Notification for change in MAC Merge configuration.
       notify: mm-get
+    -
+      name: ulp-ddp-get
+      doc: Get ULP DDP capabilities and stats
+
+      attribute-set: ulp-ddp
+
+      do: &ulp-ddp-get-op
+        request:
+          value: 44
+          attributes:
+            - header
+        reply:
+          value: 44
+          attributes:
+            - header
+            - hw
+            - active
+            - stats
+      dump: *ulp-ddp-get-op
+    -
+      name: ulp-ddp-set
+      doc: Set ULP DDP capabilities
+
+      attribute-set: ulp-ddp
+
+      do:
+        request:
+          value: 45
+          attributes:
+            - header
+            - wanted
+        reply:
+          value: 45
+          attributes:
+            - header
+            - hw
+            - active
+    -
+      name: ulp-ddp-ntf
+      doc: Notification for change in ULP DDP capabilities
+      notify: ulp-ddp-get
diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index d144e890961d..8390230ca5b5 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -225,6 +225,8 @@ Userspace to kernel:
   ``ETHTOOL_MSG_RSS_GET``               get RSS settings
   ``ETHTOOL_MSG_MM_GET``                get MAC merge layer state
   ``ETHTOOL_MSG_MM_SET``                set MAC merge layer parameters
+  ``ETHTOOL_MSG_ULP_DDP_GET``           get ULP DDP capabilities and stats
+  ``ETHTOOL_MSG_ULP_DDP_SET``           set ULP DDP capabilities
   ===================================== =================================
 
 Kernel to userspace:
@@ -268,6 +270,9 @@ Kernel to userspace:
   ``ETHTOOL_MSG_PSE_GET_REPLY``            PSE parameters
   ``ETHTOOL_MSG_RSS_GET_REPLY``            RSS settings
   ``ETHTOOL_MSG_MM_GET_REPLY``             MAC merge layer status
+  ``ETHTOOL_MSG_ULP_DDP_GET_REPLY``        ULP DDP capabilities and stats
+  ``ETHTOOL_MSG_ULP_DDP_SET_REPLY``        optional reply to ULP_DDP_SET
+  ``ETHTOOL_MSG_ULP_DDP_NTF``              ULP DDP capabilities notification
   ======================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1973,6 +1978,93 @@ The attributes are propagated to the driver through the following structure:
 .. kernel-doc:: include/linux/ethtool.h
     :identifiers: ethtool_mm_cfg
 
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
+  form. In that form, the names for the individual bits can be retrieved
+  via the ``ETH_SS_ULP_DDP_CAPS`` string set.
+* ``ETHTOOL_A_ULP_DDP_STATS`` contains statistics which
+  are only reported if ``ETHTOOL_FLAG_STATS`` was set in
+  ``ETHTOOL_A_HEADER_FLAGS``.
+
+ULP DDP statistics content:
+
+  =====================================================  ===  ===============
+  ``ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_SK_ADD``         u64  sockets successfully prepared for offloading
+  ``ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_SK_ADD_FAIL``    u64  sockets that failed to be prepared for offloading
+  ``ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_SK_DEL``         u64  sockets where offloading has been removed
+  ``ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_DDP_SETUP``      u64  PDUs successfully prepared for Direct Data Placement
+  ``ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_DDP_SETUP_FAIL`` u64  PDUs that failed DDP preparation
+  ``ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_DDP_TEARDOWN``   u64  PDUs done with DDP
+  ``ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_DROP``           u64  PDUs dropped
+  ``ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_RESYNC``         u64  resync
+  ``ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_PACKETS``        u64  offloaded PDUs
+  ``ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_BYTES``          u64  offloaded bytes
+  =====================================================  ===  ===============
+
+The names of each statistics are global. They can be retrieved via the
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
index 551b3cc29a41..9997c5e8d34e 100644
--- a/Documentation/networking/statistics.rst
+++ b/Documentation/networking/statistics.rst
@@ -172,6 +172,7 @@ statistics are supported in the following commands:
   - `ETHTOOL_MSG_PAUSE_GET`
   - `ETHTOOL_MSG_FEC_GET`
   - `ETHTOOL_MSG_MM_GET`
+  - `ETHTOOL_MSG_ULP_DDP_GET`
 
 debugfs
 -------
-- 
2.31.1

