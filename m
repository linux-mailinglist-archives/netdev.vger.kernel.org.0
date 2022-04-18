Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1ED4504CCA
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbiDRGqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236568AbiDRGqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:46:18 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2080.outbound.protection.outlook.com [40.107.101.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6DF13DF7
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 23:43:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SiZv3B2KMg/bTrukm1MpkRIHCtWsH3nbIjSRMgLihWff+R/OP9SPbEl76KcKfBlJDjHKXQP70gFoIA7unX07jVIz9Mu1BWFFja6X5JVXSB4K0q/BViB+fUJ3+7IB16fB2v9d7h+GIicqXQbLhFv5yPx5F9AjRTIlhNRiysyNeNaVlp12pAFQL9PaseVMPGvBDOjHPOws6qM1lCXuHHUhOpHb8doRSxwGoJQp0NGcYe2iKqQq07R8etfBJHuBJL6ndPDVVYiJ0rB6pJ7K5nIwR55WQl2v2ZWC2BBzmNhZKf3gBuHbhdZUAXrN2keynqlx171wEdNpto5e9LCB/sVKKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CF0z3stqiJ+WwBag92buzBYHEdFVbXPd9qoDiVqe9G8=;
 b=dt05TUOuNhKdIbkDAcoeGOB8ve5rI2YXfylR0BAmW3ZEITGhZweo2uG2DoBFIA/o0yiNmMiWfptfSHHNQefmc/p3eQ+Kxg9/V/wZEWnYhlTmP0dKmAh3OaRR69keyofgFGhEwjSScJM/DMrK+JqGGesPDM7HMnv+s53vIuVlZiyZKLqDN5eVmRR4l3Ub0K/SEHwhB6s+XZF8egCHO8cm5G2gyvt4SUz8vIa7pFNu3LexQowXcemagVA56Bi1DoWz+E85CD+IyVCT/rhxIj79IvUHCvKF905vOjNF/PM5++BcME8OKTjVTcVy1TFTc/+XV8p/+/dHdiDFW4LruMSjHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CF0z3stqiJ+WwBag92buzBYHEdFVbXPd9qoDiVqe9G8=;
 b=o/GCxcwcNDJ5g4W7R9vBk/Si6tmXXW0NNCZlM10fFuRJ3kZo3uhX4psis9DX6V9v9MC1ma6Fou4GtMXHIZ1dv+LSHVjfbSdfC1S9JNoS6PrkQtBz2MGA9j8b6nrTffVYXjUop2E/C7Vv65/7CRXHnK/Ku9db00cBJ2FBzcxNST9TCaAjsfd6G80AgcVNp14sSUihnsAgf097bOyMqEXEHsTYzxzeYBEK/OB0z0Qkc0+sDJgeoaPqfoNhkM/zzbWBbfdS6bX9Z5y9Ryj1eVFnbNwGL/XRTgtbv2CF49TJAEayOx60BDtC4l1yPEoOoDMYatrrYTo18m9ewMJUN1VYQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by PH0PR12MB5420.namprd12.prod.outlook.com (2603:10b6:510:e8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:43:37 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:43:37 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/17] devlink: implement line card provisioning
Date:   Mon, 18 Apr 2022 09:42:26 +0300
Message-Id: <20220418064241.2925668-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
References: <20220418064241.2925668-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0062.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::13) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2765ce6-fd71-4669-8f88-08da2106c411
X-MS-TrafficTypeDiagnostic: PH0PR12MB5420:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB54209F8F910ACF09C42A272BB2F39@PH0PR12MB5420.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y9SuFvpEE8ykpUnHLNYcbQtGvkrzvo/ZjVaJqqjArpHF260C5BpOcWrpF9irBZ4QaKPyRnNUGqMi4mwBnthVXXSbfEz7E3EYKZqj2/SKoxbbG48QfMI2LDUvSbpKxatEB6L/MG/QD43G5UzyVG8vssrL3Dn6X5YP1oUxHhXMxtanyZUqvEgTGcyAQCTGtDxSLjTBn0yUZ72zKpEGG/5OD6F7lf0ACZuGgFjXPExM9QUolqv+pJa+qWXis4UedbZnHRr3x3Dovo+HMzMPtUTg8I/iDFt54vhfOk7xu67Cl1ASA1hSAHWFeGtd3P4sQhn4BEOsofK8TFoln9Jq6UhNp4i9fSu/eAEzHZXQrtldx9N2qRnBYQjtK6rRzKsYY2bCBKkW6UJcnOwrRVUvy7Wd4EfL1oDa0SX5dheXYUB9AHtwSNYLajaDlGsGkLhXclnIyuSAfp58pRQAd0pReKLCRxq/xGyX757roxfyDSjaMFlCr40bRGEBV3wQBa3gXmbnk8hZ4+cqhHEHMITXpkfRZ/ppF4El0ZzyCVtx3n1q75tJFm61v1wpwIm5FUt3yHrfGM9N1coBDBnZhL2JHhmw7QICZ04BJMV77Bnsll5bY20q4m9lt3q4JBr/TPsx4XlGKJ8Hp5VLzXPdvSwoLUpPCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6486002)(508600001)(1076003)(2906002)(6512007)(6506007)(86362001)(6666004)(36756003)(186003)(26005)(83380400001)(66946007)(38100700002)(5660300002)(66556008)(66476007)(107886003)(2616005)(30864003)(4326008)(8676002)(6916009)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8zOP1kCMHDStchZKmBT17XLr+A8uOx/X2kgJdPmuT4S1JR5JpLvO8eiTG2zk?=
 =?us-ascii?Q?Z3jAiVCK3ljslkOglSh45qJo3LufGc3YJ91fMsl5tl1MCr5MTJDltMzVutqf?=
 =?us-ascii?Q?bxrN3QuW8kxB0QpGSrxTzC6WrpclnZcrQEaTi2sG3tarW4Kwkx7Mc40bsoTz?=
 =?us-ascii?Q?vo4hHuT5X3mn6SWWRZbuRZenEzvw1Q5/+D6YonTle3G8n1eYX7Ae+GZxPRPp?=
 =?us-ascii?Q?R2dIuRjxPDlJ5Kdokk/Gd7IgFSWtGTEEnyJdNxK4zZwmkTBdXxE0DLJlseHw?=
 =?us-ascii?Q?F3oqYhjnRdSw/R5J6ZnICn/RNpueKUPE+KI6Fwb9LswAOxHvdJBvGYFQYwN6?=
 =?us-ascii?Q?ODUOjfh5gzymZbRG8r2rb1lPAfIsauUONn5OqtG7aUNtr7W+9tqMcnvw1OUc?=
 =?us-ascii?Q?KC08MYTO3HVARFrA3KlvDF1t167Sa83qNma1krI/R37RY2vGahMNMAo363dE?=
 =?us-ascii?Q?iDY5Bn126oxZc0Gn2DnKLsDqz75N2u6hklCKQ4hwntavp6abrw+1nujTmu60?=
 =?us-ascii?Q?qo+h3lqRuH+w9JUjxFbs0Jtqn9nXluxoEEttbFxeY1MlvCxf3ij5mbJ2SidU?=
 =?us-ascii?Q?qUjRSKeBCQL50a088nTdggQENv2pNns+UgoYrNRzdq9IuJ8NX0TLTp6GLW0f?=
 =?us-ascii?Q?4vhk0KxbqNGv8MDb4f1oQaXet48opuxLxQXq6GzHv8bWVTOetvN8FNpyaJLT?=
 =?us-ascii?Q?EvGZ3doP9GINZD75B5JccPKHodrYU+bGiHOwDe82aU5rXKYH6Cn5bydAXZTE?=
 =?us-ascii?Q?j0g9W2mknUbh4iDFdupm1q3osPI/AnEGFGkrqazMqWav/F9xkdQWgZxMdS+w?=
 =?us-ascii?Q?PIHcrKFlYw5qHpJVT98TTPozwRg4+4qS3q51yDUswdcxx6Z3A0a1ZRmPj1qz?=
 =?us-ascii?Q?d+s//PYOzEq5eiPFixyk36V4BTRz1cKAcoK7ze1aXyuS3nIkLd17AHEUaStA?=
 =?us-ascii?Q?aUY3P+koNClvntIRj8S3MIG0KygDe1cYVQskk2Zgrk9evFQZsiEo0Fwe5cik?=
 =?us-ascii?Q?uEmfqS0EIdcm4zqLXhn5oJpcszWegNW+GVuVdBPvwXu0i7Otbp5pvjm0UZpL?=
 =?us-ascii?Q?plWQlND8o3JqTwjvgVEuIQW9yWhzOzG0Vp/M8Ot67B97Kr5Rl87JB83v7NiA?=
 =?us-ascii?Q?QPGBSSYsJXl2VGapQv5wxoPrDL0+xpw+IOXSqABXC8EiIaWB8g9fOvcENMp3?=
 =?us-ascii?Q?g9cdkiBqJNqwDlc4XiH4E2oS7xnDTf22BPSrc9es0Jqy0j9/WfNV+ueLvZ33?=
 =?us-ascii?Q?G5vNGQTUylv1u0RrqG9FEv39jj7vtiF+FB5UMJm1PRdcjaG/SGUfs7YTFY+P?=
 =?us-ascii?Q?BbPBYFIFRK1battZ5zBamz6hN+3dhBZmwasLpfcSrRAQkjonqnEHfPuNvWDx?=
 =?us-ascii?Q?MqUEMglP+H52wjR35tOshiTtoXVegPwtSHvi+39OC3rOxFq4xuOPih8zIgR2?=
 =?us-ascii?Q?N8HnTIP2ntNq7mrbwWvt0Pi8xM3kkWTlnaqCugc+/U1klQ1vRhz9fbOfUTZt?=
 =?us-ascii?Q?XbQx2rQgeM9ohpH51MHZvtNsPilArILszt5QYLgLsa2KeAHyFTtQ/eKnKdN2?=
 =?us-ascii?Q?kYfhJHrCHrm2F2uax/SFEst54ItYmndzefyW357Tv3d4HDYFHl9GPpELaKR5?=
 =?us-ascii?Q?gCsua+OFnk5rTbIreAHGQqOcDf0IXj/tnPI1gd2XObSpaHyvQ2wEapFryoLB?=
 =?us-ascii?Q?nRtXnqOXOYGuRlEQKNRhKNbbWec4/a2+xFnrqmRl1BwTrEQ0moxOSeVF1hrH?=
 =?us-ascii?Q?TgEeCLI6UQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2765ce6-fd71-4669-8f88-08da2106c411
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:43:37.2310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Watw1Ug22GfPS8qNjlkfQ3h2uH7An6JZMxX2aaWA2XPJYsy/zYa5pLUj84NNiTienvJ6QS6CS8l4bocdLZ43SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5420
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

In order to be able to configure all needed stuff on a port/netdevice
of a line card without the line card being present, introduce line card
provisioning. Basically by setting a type, provisioning process will
start and driver is supposed to create a placeholder for instances
(ports/netdevices) for a line card type.

Allow the user to query the supported line card types over line card
get command. Then implement two netlink command SET to allow user to
set/unset the card type.

On the driver API side, add provision/unprovision ops and supported
types array to be advertised. Upon provision op call, the driver should
take care of creating the instances for the particular line card type.
Introduce provision_set/clear() functions to be called by the driver
once the provisioning/unprovisioning is done on its side. These helpers
are not to be called directly due to the async nature of provisioning.

Example:
$ devlink port # No ports are listed
$ devlink lc
pci/0000:01:00.0:
  lc 1 state unprovisioned
    supported_types:
       16x100G
  lc 2 state unprovisioned
    supported_types:
       16x100G
  lc 3 state unprovisioned
    supported_types:
       16x100G
  lc 4 state unprovisioned
    supported_types:
       16x100G
  lc 5 state unprovisioned
    supported_types:
       16x100G
  lc 6 state unprovisioned
    supported_types:
       16x100G
  lc 7 state unprovisioned
    supported_types:
       16x100G
  lc 8 state unprovisioned
    supported_types:
       16x100G

$ devlink lc set pci/0000:01:00.0 lc 8 type 16x100G
$ devlink lc show pci/0000:01:00.0 lc 8
pci/0000:01:00.0:
  lc 8 state active type 16x100G
    supported_types:
       16x100G
$ devlink port
pci/0000:01:00.0/0: type notset flavour cpu port 0 splittable false
pci/0000:01:00.0/53: type eth netdev enp1s0nl8p1 flavour physical lc 8 port 1 splittable true lanes 4
pci/0000:01:00.0/54: type eth netdev enp1s0nl8p2 flavour physical lc 8 port 2 splittable true lanes 4
pci/0000:01:00.0/55: type eth netdev enp1s0nl8p3 flavour physical lc 8 port 3 splittable true lanes 4
pci/0000:01:00.0/56: type eth netdev enp1s0nl8p4 flavour physical lc 8 port 4 splittable true lanes 4
pci/0000:01:00.0/57: type eth netdev enp1s0nl8p5 flavour physical lc 8 port 5 splittable true lanes 4
pci/0000:01:00.0/58: type eth netdev enp1s0nl8p6 flavour physical lc 8 port 6 splittable true lanes 4
pci/0000:01:00.0/59: type eth netdev enp1s0nl8p7 flavour physical lc 8 port 7 splittable true lanes 4
pci/0000:01:00.0/60: type eth netdev enp1s0nl8p8 flavour physical lc 8 port 8 splittable true lanes 4
pci/0000:01:00.0/61: type eth netdev enp1s0nl8p9 flavour physical lc 8 port 9 splittable true lanes 4
pci/0000:01:00.0/62: type eth netdev enp1s0nl8p10 flavour physical lc 8 port 10 splittable true lanes 4
pci/0000:01:00.0/63: type eth netdev enp1s0nl8p11 flavour physical lc 8 port 11 splittable true lanes 4
pci/0000:01:00.0/64: type eth netdev enp1s0nl8p12 flavour physical lc 8 port 12 splittable true lanes 4
pci/0000:01:00.0/125: type eth netdev enp1s0nl8p13 flavour physical lc 8 port 13 splittable true lanes 4
pci/0000:01:00.0/126: type eth netdev enp1s0nl8p14 flavour physical lc 8 port 14 splittable true lanes 4
pci/0000:01:00.0/127: type eth netdev enp1s0nl8p15 flavour physical lc 8 port 15 splittable true lanes 4
pci/0000:01:00.0/128: type eth netdev enp1s0nl8p16 flavour physical lc 8 port 16 splittable true lanes 4

$ devlink lc set pci/0000:01:00.0 lc 8 notype

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../networking/devlink/devlink-linecard.rst   | 121 +++++++
 Documentation/networking/devlink/index.rst    |   1 +
 include/net/devlink.h                         |  43 ++-
 include/uapi/linux/devlink.h                  |  15 +
 net/core/devlink.c                            | 322 +++++++++++++++++-
 5 files changed, 497 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/networking/devlink/devlink-linecard.rst

diff --git a/Documentation/networking/devlink/devlink-linecard.rst b/Documentation/networking/devlink/devlink-linecard.rst
new file mode 100644
index 000000000000..63ccd17f40ac
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-linecard.rst
@@ -0,0 +1,121 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================
+Devlink Line card
+=================
+
+Background
+==========
+
+The ``devlink-linecard`` mechanism is targeted for manipulation of
+line cards that serve as a detachable PHY modules for modular switch
+system. Following operations are provided:
+
+  * Get a list of supported line card types.
+  * Provision of a slot with specific line card type.
+  * Get and monitor of line card state and its change.
+
+Line card according to the type may contain one or more gearboxes
+to mux the lanes with certain speed to multiple ports with lanes
+of different speed. Line card ensures N:M mapping between
+the switch ASIC modules and physical front panel ports.
+
+Overview
+========
+
+Each line card devlink object is created by device driver,
+according to the physical line card slots available on the device.
+
+Similar to splitter cable, where the device might have no way
+of detection of the splitter cable geometry, the device
+might not have a way to detect line card type. For that devices,
+concept of provisioning is introduced. It allows the user to:
+
+  * Provision a line card slot with certain line card type
+
+    - Device driver would instruct the ASIC to prepare all
+      resources accordingly. The device driver would
+      create all instances, namely devlink port and netdevices
+      that reside on the line card, according to the line card type
+  * Manipulate of line card entities even without line card
+    being physically connected or powered-up
+  * Setup splitter cable on line card ports
+
+    - As on the ordinary ports, user may provision a splitter
+      cable of a certain type, without the need to
+      be physically connected to the port
+  * Configure devlink ports and netdevices
+
+Netdevice carrier is decided as follows:
+
+  * Line card is not inserted or powered-down
+
+    - The carrier is always down
+  * Line card is inserted and powered up
+
+    - The carrier is decided as for ordinary port netdevice
+
+Line card state
+===============
+
+The ``devlink-linecard`` mechanism supports the following line card states:
+
+  * ``unprovisioned``: Line card is not provisioned on the slot.
+  * ``unprovisioning``: Line card slot is currently being unprovisioned.
+  * ``provisioning``: Line card slot is currently in a process of being provisioned
+    with a line card type.
+  * ``provisioning_failed``: Provisioning was not successful.
+  * ``provisioned``: Line card slot is provisioned with a type.
+
+The following diagram provides a general overview of ``devlink-linecard``
+state transitions::
+
+                                          +-------------------------+
+                                          |                         |
+       +---------------------------------->      unprovisioned      |
+       |                                  |                         |
+       |                                  +--------|-------^--------+
+       |                                           |       |
+       |                                           |       |
+       |                                  +--------v-------|--------+
+       |                                  |                         |
+       |                                  |       provisioning      |
+       |                                  |                         |
+       |                                  +------------|------------+
+       |                                               |
+       |                 +-----------------------------+
+       |                 |                             |
+       |    +------------v------------+   +------------v------------+
+       |    |                         |   |                         |
+       +-----   provisioning_failed   |   |       provisioned       |
+       |    |                         |   |                         |
+       |    +------------^------------+   +------------|------------+
+       |                 |                             |
+       |                 |                             |
+       |                 |                +------------v------------+
+       |                 |                |                         |
+       |                 |                |     unprovisioning      |
+       |                 |                |                         |
+       |                 |                +------------|------------+
+       |                 |                             |
+       |                 +-----------------------------+
+       |                                               |
+       +-----------------------------------------------+
+
+
+Example usage
+=============
+
+.. code:: shell
+
+    $ devlink lc show [ DEV [ lc LC_INDEX ] ]
+    $ devlink lc set DEV lc LC_INDEX [ { type LC_TYPE | notype } ]
+
+    # Show current line card configuration and status for all slots:
+    $ devlink lc
+
+    # Set slot 8 to be provisioned with type "16x100G":
+    $ devlink lc set pci/0000:01:00.0 lc 8 type 16x100G
+
+    # Set slot 8 to be unprovisioned:
+    $ devlink lc set pci/0000:01:00.0 lc 8 notype
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index c17cdb079611..850715512293 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -39,6 +39,7 @@ general.
    devlink-resource
    devlink-reload
    devlink-trap
+   devlink-linecard
 
 Driver-specific documentation
 -----------------------------
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 7aabdfb3bc6a..3e49d4ff498c 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -149,6 +149,40 @@ struct devlink_port_new_attrs {
 	   sfnum_valid:1;
 };
 
+/**
+ * struct devlink_linecard_ops - Linecard operations
+ * @provision: callback to provision the linecard slot with certain
+ *	       type of linecard. As a result of this operation,
+ *	       driver is expected to eventually (could be after
+ *	       the function call returns) call one of:
+ *	       devlink_linecard_provision_set()
+ *	       devlink_linecard_provision_fail()
+ * @unprovision: callback to unprovision the linecard slot. As a result
+ *		 of this operation, driver is expected to eventually
+ *		 (could be after the function call returns) call
+ *	         devlink_linecard_provision_clear()
+ *	         devlink_linecard_provision_fail()
+ * @same_provision: callback to ask the driver if linecard is already
+ *                  provisioned in the same way user asks this linecard to be
+ *                  provisioned.
+ * @types_count: callback to get number of supported types
+ * @types_get: callback to get next type in list
+ */
+struct devlink_linecard_ops {
+	int (*provision)(struct devlink_linecard *linecard, void *priv,
+			 const char *type, const void *type_priv,
+			 struct netlink_ext_ack *extack);
+	int (*unprovision)(struct devlink_linecard *linecard, void *priv,
+			   struct netlink_ext_ack *extack);
+	bool (*same_provision)(struct devlink_linecard *linecard, void *priv,
+			       const char *type, const void *type_priv);
+	unsigned int (*types_count)(struct devlink_linecard *linecard,
+				    void *priv);
+	void (*types_get)(struct devlink_linecard *linecard,
+			  void *priv, unsigned int index, const char **type,
+			  const void **type_priv);
+};
+
 struct devlink_sb_pool_info {
 	enum devlink_sb_pool_type pool_type;
 	u32 size;
@@ -1537,9 +1571,14 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
 int devlink_rate_leaf_create(struct devlink_port *port, void *priv);
 void devlink_rate_leaf_destroy(struct devlink_port *devlink_port);
 void devlink_rate_nodes_destroy(struct devlink *devlink);
-struct devlink_linecard *devlink_linecard_create(struct devlink *devlink,
-						 unsigned int linecard_index);
+struct devlink_linecard *
+devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
+			const struct devlink_linecard_ops *ops, void *priv);
 void devlink_linecard_destroy(struct devlink_linecard *linecard);
+void devlink_linecard_provision_set(struct devlink_linecard *linecard,
+				    const char *type);
+void devlink_linecard_provision_clear(struct devlink_linecard *linecard);
+void devlink_linecard_provision_fail(struct devlink_linecard *linecard);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 59c33ed2d3e7..de91e4a0d476 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -343,6 +343,18 @@ enum devlink_reload_limit {
 
 #define DEVLINK_RELOAD_LIMITS_VALID_MASK (_BITUL(__DEVLINK_RELOAD_LIMIT_MAX) - 1)
 
+enum devlink_linecard_state {
+	DEVLINK_LINECARD_STATE_UNSPEC,
+	DEVLINK_LINECARD_STATE_UNPROVISIONED,
+	DEVLINK_LINECARD_STATE_UNPROVISIONING,
+	DEVLINK_LINECARD_STATE_PROVISIONING,
+	DEVLINK_LINECARD_STATE_PROVISIONING_FAILED,
+	DEVLINK_LINECARD_STATE_PROVISIONED,
+
+	__DEVLINK_LINECARD_STATE_MAX,
+	DEVLINK_LINECARD_STATE_MAX = __DEVLINK_LINECARD_STATE_MAX - 1
+};
+
 enum devlink_attr {
 	/* don't change the order or add anything between, this is ABI! */
 	DEVLINK_ATTR_UNSPEC,
@@ -559,6 +571,9 @@ enum devlink_attr {
 	DEVLINK_ATTR_REGION_MAX_SNAPSHOTS,	/* u32 */
 
 	DEVLINK_ATTR_LINECARD_INDEX,		/* u32 */
+	DEVLINK_ATTR_LINECARD_STATE,		/* u8 */
+	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
+	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4cdacd74b82a..b7c3a82fbd4b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -72,11 +72,21 @@ struct devlink {
 	char priv[] __aligned(NETDEV_ALIGN);
 };
 
+struct devlink_linecard_ops;
+struct devlink_linecard_type;
+
 struct devlink_linecard {
 	struct list_head list;
 	struct devlink *devlink;
 	unsigned int index;
 	refcount_t refcount;
+	const struct devlink_linecard_ops *ops;
+	void *priv;
+	enum devlink_linecard_state state;
+	struct mutex state_lock; /* Protects state */
+	const char *type;
+	struct devlink_linecard_type *types;
+	unsigned int types_count;
 };
 
 /**
@@ -452,8 +462,10 @@ devlink_linecard_get_from_info(struct devlink *devlink, struct genl_info *info)
 
 static void devlink_linecard_put(struct devlink_linecard *linecard)
 {
-	if (refcount_dec_and_test(&linecard->refcount))
+	if (refcount_dec_and_test(&linecard->refcount)) {
+		mutex_destroy(&linecard->state_lock);
 		kfree(linecard);
+	}
 }
 
 struct devlink_sb {
@@ -2037,6 +2049,11 @@ static int devlink_nl_cmd_rate_del_doit(struct sk_buff *skb,
 	return err;
 }
 
+struct devlink_linecard_type {
+	const char *type;
+	const void *priv;
+};
+
 static int devlink_nl_linecard_fill(struct sk_buff *msg,
 				    struct devlink *devlink,
 				    struct devlink_linecard *linecard,
@@ -2044,7 +2061,10 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
 				    u32 seq, int flags,
 				    struct netlink_ext_ack *extack)
 {
+	struct devlink_linecard_type *linecard_type;
+	struct nlattr *attr;
 	void *hdr;
+	int i;
 
 	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
 	if (!hdr)
@@ -2054,6 +2074,27 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
 		goto nla_put_failure;
 	if (nla_put_u32(msg, DEVLINK_ATTR_LINECARD_INDEX, linecard->index))
 		goto nla_put_failure;
+	if (nla_put_u8(msg, DEVLINK_ATTR_LINECARD_STATE, linecard->state))
+		goto nla_put_failure;
+	if (linecard->type &&
+	    nla_put_string(msg, DEVLINK_ATTR_LINECARD_TYPE, linecard->type))
+		goto nla_put_failure;
+
+	if (linecard->types_count) {
+		attr = nla_nest_start(msg,
+				      DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES);
+		if (!attr)
+			goto nla_put_failure;
+		for (i = 0; i < linecard->types_count; i++) {
+			linecard_type = &linecard->types[i];
+			if (nla_put_string(msg, DEVLINK_ATTR_LINECARD_TYPE,
+					   linecard_type->type)) {
+				nla_nest_cancel(msg, attr);
+				goto nla_put_failure;
+			}
+		}
+		nla_nest_end(msg, attr);
+	}
 
 	genlmsg_end(msg, hdr);
 	return 0;
@@ -2103,10 +2144,12 @@ static int devlink_nl_cmd_linecard_get_doit(struct sk_buff *skb,
 	if (!msg)
 		return -ENOMEM;
 
+	mutex_lock(&linecard->state_lock);
 	err = devlink_nl_linecard_fill(msg, devlink, linecard,
 				       DEVLINK_CMD_LINECARD_NEW,
 				       info->snd_portid, info->snd_seq, 0,
 				       info->extack);
+	mutex_unlock(&linecard->state_lock);
 	if (err) {
 		nlmsg_free(msg);
 		return err;
@@ -2139,12 +2182,14 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 				idx++;
 				continue;
 			}
+			mutex_lock(&linecard->state_lock);
 			err = devlink_nl_linecard_fill(msg, devlink, linecard,
 						       DEVLINK_CMD_LINECARD_NEW,
 						       NETLINK_CB(cb->skb).portid,
 						       cb->nlh->nlmsg_seq,
 						       NLM_F_MULTI,
 						       cb->extack);
+			mutex_unlock(&linecard->state_lock);
 			if (err) {
 				mutex_unlock(&devlink->linecards_lock);
 				devlink_put(devlink);
@@ -2163,6 +2208,163 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 	return msg->len;
 }
 
+static struct devlink_linecard_type *
+devlink_linecard_type_lookup(struct devlink_linecard *linecard,
+			     const char *type)
+{
+	struct devlink_linecard_type *linecard_type;
+	int i;
+
+	for (i = 0; i < linecard->types_count; i++) {
+		linecard_type = &linecard->types[i];
+		if (!strcmp(type, linecard_type->type))
+			return linecard_type;
+	}
+	return NULL;
+}
+
+static int devlink_linecard_type_set(struct devlink_linecard *linecard,
+				     const char *type,
+				     struct netlink_ext_ack *extack)
+{
+	const struct devlink_linecard_ops *ops = linecard->ops;
+	struct devlink_linecard_type *linecard_type;
+	int err;
+
+	mutex_lock(&linecard->state_lock);
+	if (linecard->state == DEVLINK_LINECARD_STATE_PROVISIONING) {
+		NL_SET_ERR_MSG_MOD(extack, "Line card is currently being provisioned");
+		err = -EBUSY;
+		goto out;
+	}
+	if (linecard->state == DEVLINK_LINECARD_STATE_UNPROVISIONING) {
+		NL_SET_ERR_MSG_MOD(extack, "Line card is currently being unprovisioned");
+		err = -EBUSY;
+		goto out;
+	}
+
+	linecard_type = devlink_linecard_type_lookup(linecard, type);
+	if (!linecard_type) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported line card type provided");
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (linecard->state != DEVLINK_LINECARD_STATE_UNPROVISIONED &&
+	    linecard->state != DEVLINK_LINECARD_STATE_PROVISIONING_FAILED) {
+		NL_SET_ERR_MSG_MOD(extack, "Line card already provisioned");
+		err = -EBUSY;
+		/* Check if the line card is provisioned in the same
+		 * way the user asks. In case it is, make the operation
+		 * to return success.
+		 */
+		if (ops->same_provision &&
+		    ops->same_provision(linecard, linecard->priv,
+					linecard_type->type,
+					linecard_type->priv))
+			err = 0;
+		goto out;
+	}
+
+	linecard->state = DEVLINK_LINECARD_STATE_PROVISIONING;
+	linecard->type = linecard_type->type;
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+	mutex_unlock(&linecard->state_lock);
+	err = ops->provision(linecard, linecard->priv, linecard_type->type,
+			     linecard_type->priv, extack);
+	if (err) {
+		/* Provisioning failed. Assume the linecard is unprovisioned
+		 * for future operations.
+		 */
+		mutex_lock(&linecard->state_lock);
+		linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
+		linecard->type = NULL;
+		devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+		mutex_unlock(&linecard->state_lock);
+	}
+	return err;
+
+out:
+	mutex_unlock(&linecard->state_lock);
+	return err;
+}
+
+static int devlink_linecard_type_unset(struct devlink_linecard *linecard,
+				       struct netlink_ext_ack *extack)
+{
+	int err;
+
+	mutex_lock(&linecard->state_lock);
+	if (linecard->state == DEVLINK_LINECARD_STATE_PROVISIONING) {
+		NL_SET_ERR_MSG_MOD(extack, "Line card is currently being provisioned");
+		err = -EBUSY;
+		goto out;
+	}
+	if (linecard->state == DEVLINK_LINECARD_STATE_UNPROVISIONING) {
+		NL_SET_ERR_MSG_MOD(extack, "Line card is currently being unprovisioned");
+		err = -EBUSY;
+		goto out;
+	}
+	if (linecard->state == DEVLINK_LINECARD_STATE_PROVISIONING_FAILED) {
+		linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
+		linecard->type = NULL;
+		devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+		err = 0;
+		goto out;
+	}
+
+	if (linecard->state == DEVLINK_LINECARD_STATE_UNPROVISIONED) {
+		NL_SET_ERR_MSG_MOD(extack, "Line card is not provisioned");
+		err = 0;
+		goto out;
+	}
+	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONING;
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+	mutex_unlock(&linecard->state_lock);
+	err = linecard->ops->unprovision(linecard, linecard->priv,
+					 extack);
+	if (err) {
+		/* Unprovisioning failed. Assume the linecard is unprovisioned
+		 * for future operations.
+		 */
+		mutex_lock(&linecard->state_lock);
+		linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
+		linecard->type = NULL;
+		devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+		mutex_unlock(&linecard->state_lock);
+	}
+	return err;
+
+out:
+	mutex_unlock(&linecard->state_lock);
+	return err;
+}
+
+static int devlink_nl_cmd_linecard_set_doit(struct sk_buff *skb,
+					    struct genl_info *info)
+{
+	struct devlink_linecard *linecard = info->user_ptr[1];
+	struct netlink_ext_ack *extack = info->extack;
+	int err;
+
+	if (info->attrs[DEVLINK_ATTR_LINECARD_TYPE]) {
+		const char *type;
+
+		type = nla_data(info->attrs[DEVLINK_ATTR_LINECARD_TYPE]);
+		if (strcmp(type, "")) {
+			err = devlink_linecard_type_set(linecard, type, extack);
+			if (err)
+				return err;
+		} else {
+			err = devlink_linecard_type_unset(linecard, extack);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
 static int devlink_nl_sb_fill(struct sk_buff *msg, struct devlink *devlink,
 			      struct devlink_sb *devlink_sb,
 			      enum devlink_command cmd, u32 portid,
@@ -8789,6 +8991,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_RATE_NODE_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
@@ -8871,6 +9074,12 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.internal_flags = DEVLINK_NL_FLAG_NEED_LINECARD,
 		/* can be retrieved by unprivileged users */
 	},
+	{
+		.cmd = DEVLINK_CMD_LINECARD_SET,
+		.doit = devlink_nl_cmd_linecard_set_doit,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_LINECARD,
+	},
 	{
 		.cmd = DEVLINK_CMD_SB_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -9962,19 +10171,56 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 	return 0;
 }
 
+static int devlink_linecard_types_init(struct devlink_linecard *linecard)
+{
+	struct devlink_linecard_type *linecard_type;
+	unsigned int count;
+	int i;
+
+	count = linecard->ops->types_count(linecard, linecard->priv);
+	linecard->types = kmalloc_array(count, sizeof(*linecard_type),
+					GFP_KERNEL);
+	if (!linecard->types)
+		return -ENOMEM;
+	linecard->types_count = count;
+
+	for (i = 0; i < count; i++) {
+		linecard_type = &linecard->types[i];
+		linecard->ops->types_get(linecard, linecard->priv, i,
+					 &linecard_type->type,
+					 &linecard_type->priv);
+	}
+	return 0;
+}
+
+static void devlink_linecard_types_fini(struct devlink_linecard *linecard)
+{
+	kfree(linecard->types);
+}
+
 /**
  *	devlink_linecard_create - Create devlink linecard
  *
  *	@devlink: devlink
  *	@linecard_index: driver-specific numerical identifier of the linecard
+ *	@ops: linecards ops
+ *	@priv: user priv pointer
  *
  *	Create devlink linecard instance with provided linecard index.
  *	Caller can use any indexing, even hw-related one.
+ *
+ *	Return: Line card structure or an ERR_PTR() encoded error code.
  */
-struct devlink_linecard *devlink_linecard_create(struct devlink *devlink,
-						 unsigned int linecard_index)
+struct devlink_linecard *
+devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
+			const struct devlink_linecard_ops *ops, void *priv)
 {
 	struct devlink_linecard *linecard;
+	int err;
+
+	if (WARN_ON(!ops || !ops->provision || !ops->unprovision ||
+		    !ops->types_count || !ops->types_get))
+		return ERR_PTR(-EINVAL);
 
 	mutex_lock(&devlink->linecards_lock);
 	if (devlink_linecard_index_exists(devlink, linecard_index)) {
@@ -9990,6 +10236,19 @@ struct devlink_linecard *devlink_linecard_create(struct devlink *devlink,
 
 	linecard->devlink = devlink;
 	linecard->index = linecard_index;
+	linecard->ops = ops;
+	linecard->priv = priv;
+	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
+	mutex_init(&linecard->state_lock);
+
+	err = devlink_linecard_types_init(linecard);
+	if (err) {
+		mutex_destroy(&linecard->state_lock);
+		kfree(linecard);
+		mutex_unlock(&devlink->linecards_lock);
+		return ERR_PTR(err);
+	}
+
 	list_add_tail(&linecard->list, &devlink->linecard_list);
 	refcount_set(&linecard->refcount, 1);
 	mutex_unlock(&devlink->linecards_lock);
@@ -10010,11 +10269,68 @@ void devlink_linecard_destroy(struct devlink_linecard *linecard)
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_DEL);
 	mutex_lock(&devlink->linecards_lock);
 	list_del(&linecard->list);
+	devlink_linecard_types_fini(linecard);
 	mutex_unlock(&devlink->linecards_lock);
 	devlink_linecard_put(linecard);
 }
 EXPORT_SYMBOL_GPL(devlink_linecard_destroy);
 
+/**
+ *	devlink_linecard_provision_set - Set provisioning on linecard
+ *
+ *	@linecard: devlink linecard
+ *	@type: linecard type
+ *
+ *	This is either called directly from the provision() op call or
+ *	as a result of the provision() op call asynchronously.
+ */
+void devlink_linecard_provision_set(struct devlink_linecard *linecard,
+				    const char *type)
+{
+	mutex_lock(&linecard->state_lock);
+	WARN_ON(linecard->type && strcmp(linecard->type, type));
+	linecard->state = DEVLINK_LINECARD_STATE_PROVISIONED;
+	linecard->type = type;
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+	mutex_unlock(&linecard->state_lock);
+}
+EXPORT_SYMBOL_GPL(devlink_linecard_provision_set);
+
+/**
+ *	devlink_linecard_provision_clear - Clear provisioning on linecard
+ *
+ *	@linecard: devlink linecard
+ *
+ *	This is either called directly from the unprovision() op call or
+ *	as a result of the unprovision() op call asynchronously.
+ */
+void devlink_linecard_provision_clear(struct devlink_linecard *linecard)
+{
+	mutex_lock(&linecard->state_lock);
+	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
+	linecard->type = NULL;
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+	mutex_unlock(&linecard->state_lock);
+}
+EXPORT_SYMBOL_GPL(devlink_linecard_provision_clear);
+
+/**
+ *	devlink_linecard_provision_fail - Fail provisioning on linecard
+ *
+ *	@linecard: devlink linecard
+ *
+ *	This is either called directly from the provision() op call or
+ *	as a result of the provision() op call asynchronously.
+ */
+void devlink_linecard_provision_fail(struct devlink_linecard *linecard)
+{
+	mutex_lock(&linecard->state_lock);
+	linecard->state = DEVLINK_LINECARD_STATE_PROVISIONING_FAILED;
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+	mutex_unlock(&linecard->state_lock);
+}
+EXPORT_SYMBOL_GPL(devlink_linecard_provision_fail);
+
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
-- 
2.33.1

