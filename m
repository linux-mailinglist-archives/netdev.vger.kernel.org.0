Return-Path: <netdev+bounces-11965-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9DF873575A
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:52:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D05181C2037C
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9575C10954;
	Mon, 19 Jun 2023 12:52:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825CD10952
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 12:52:06 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2084.outbound.protection.outlook.com [40.107.96.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDCF139
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 05:51:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0vH+QtpW3YZ4gFaA7OY/kOd1Ul9oUIA/3xFpkfh43W6nwTTR8whO/3r3Ehxjc0ULMHLUbFIkpQn2uaVWpGIlil4kknEp+KfIJJogEBNIBXIoVsKjfCXWqvIl5uFU1LwInGVzxJz/4dm109jFJztO9InNMst0l3H7vgIssTabayWbrdAFgRv0rxjKb7hKBRRe2hqiyRFJEHmVkvx4+8dmkxDB1iDEhF8CoCAH2GAy75gr9yzkbInzmxC9Q8/8xVdIHj16poLQjEBtFj/XJN0JGJbIq/y/bZh8lHfyyPbntOpoFweAcrr3ks9VKTnpJZrlWgz/CgsxhMlDg0hZNSgzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3ItEmMUNNSjmvnxMp5s6ceU/AGtYblCSuugUvWT28c=;
 b=F5dLTK/9Ri4DqVuFU0o2sXgxsLlFLORhMXmSHMNdz5xsJEjmx5h30sEeUD+bWQvRPFDwDQ2Wzw1YIhGSkrVPXT4bQhlp+x3GW0QGzLIWOTSkr5KleXj0NOTps2q3ALJRUd6cT6880ClOv/hAlndCgSCi56wsfWC0rhzNDO84V9otf8frqEHsEw99l6yoYMMu52s2iRV/CXGgZjdljLGrUd48cT7qQncohtEsjEiEOd4TIaAhFdQRQ3S536+QLx6ddCkI9x+7pXVaRE1Ke6QhnV2gGFiOdqbHLHhH0wogByfJziDHrZQay586vNIgAGOpBowtcpSA7nDprjTSLG4UIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3ItEmMUNNSjmvnxMp5s6ceU/AGtYblCSuugUvWT28c=;
 b=G5Zs9hkNmX3lDhebRVJOOwoTMli9OTtVidClnopz+JDIHcroGymxqTDq9OuqIyDMGc6PzOCUCPJihsBor36FDF/12eKdwyFp9D+EnOnhjtQ/Uk2ny9qLBGdn7/HE3W/zVQ4/fUHwpVcUocqZaOOIRn11Lc7CcB6fgiA9p/UcKJEYXJc0VCW0XNn8moadAYhGO++f9QRdJkV7fmYh5ndiDz/vvHKFteVsDAKBEJaYVheBNbjBxn5lHoQL60VfoWmLOlm5045JayuWOH9biG34wkvuoD6Zrxffs/s/ppajojIU0AFvOdse9Q0JB42Sh8nX2tfcVM5aOP/74Axw0i5mHQ==
Received: from DM6PR05CA0039.namprd05.prod.outlook.com (2603:10b6:5:335::8) by
 MN2PR12MB4335.namprd12.prod.outlook.com (2603:10b6:208:1d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 12:50:55 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::f) by DM6PR05CA0039.outlook.office365.com
 (2603:10b6:5:335::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
 Transport; Mon, 19 Jun 2023 12:50:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37 via Frontend Transport; Mon, 19 Jun 2023 12:50:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 19 Jun 2023
 05:50:43 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 19 Jun 2023 05:50:41 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <jiri@resnulli.us>, <petrm@nvidia.com>, Ido Schimmel
	<idosch@nvidia.com>
Subject: [RFC PATCH net-next 1/2] devlink: Hold a reference on parent device
Date: Mon, 19 Jun 2023 15:50:14 +0300
Message-ID: <20230619125015.1541143-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230619125015.1541143-1-idosch@nvidia.com>
References: <20230619125015.1541143-1-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT020:EE_|MN2PR12MB4335:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ae507eb-8b79-401c-0109-08db70c3d2df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+zByShGtfovh87+vj9hig9ZEYFdDZ1LLgw71vqd22DBEjrRbh4EvJc1npBJMl1Vbpzw2Y2lMKZjJx8brugYzsDhZ8QRhT9/IlDIZzKmFrJOSoMClgzuxKe9hXiwtk2nmMnkAbTwXPH6dn448EblTPe/DDxRQvkPdnfj9kFQtIQ0k6duwvdxNzbCKa0IFUwQltgTodeSxGiiPpj7IerhL6C0epJN8jnPIcX31YsN1JdF70OQGc41vKV5vzaBWHi+N6a5rmzagx0P0r/gcPNmBN+2te0kbuZAW0CHJ/Cu/U4H8wLpBIzNeoIeyaPz1d44u643fPe/epASBuWbxk19XewBG4SLlNScVxWRSxrx93vRkY/d8X7UZYWyE+3QWGZ0G0eI26RREnN1U18JTye6Zz2BPkAlK2RUmhg/CNSgMFGfrqqyhr1XaNr8wScB25US++Z2ykSBzqqO0Ljn3gFMBozNuFNMMy21qDwS8YYkgWDIAeaATX/SCqU8Gzj+cr60Nr0yWLh6KKGbttH0Ma1VelZP7lShaH6mYcVVtTqn5vyO9zelxQgZ/Ab1e5PYP6Xg1sC4jFIrv2cDPf4/aXpsVrkyiuClJOYHT8d2dx/wWlQ9xjN3TFnjJxD7utNi0pHQFLiyyQfbM5HYni7wWmvYl8ukPdnB9TyeWs4eb/GTGwBJoGpQcfZdiH9mcCdpcnch6dcL4AHGohdAgAkzS7TMIl9ejlMxYr2+/eqjMCo8VlRA8kxsXfs7C8JYT4ZkhyHI/
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(39860400002)(396003)(376002)(451199021)(40470700004)(46966006)(36840700001)(186003)(16526019)(107886003)(40460700003)(26005)(1076003)(82740400003)(36860700001)(2616005)(40480700001)(47076005)(7636003)(356005)(336012)(426003)(83380400001)(82310400005)(478600001)(45080400002)(4326008)(41300700001)(6916009)(70206006)(70586007)(8676002)(36756003)(316002)(8936002)(54906003)(86362001)(2906002)(6666004)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 12:50:56.0414
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ae507eb-8b79-401c-0109-08db70c3d2df
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4335
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Each devlink instance is associated with a parent device and a pointer
to this device is stored in the devlink structure, but devlink does not
hold a reference on this device.

This is going to be a problem in the next patch where - among other
things - devlink will acquire the device lock during netns dismantle,
before the reload operation. Since netns dismantle is performed
asynchronously and since a reference is not held on the parent device,
it will be possible to hit a use-after-free.

Prepare for the upcoming change by holding a reference on the parent
device.

Unfortunately, with this patch and this reproducer [1], the following
crash can be observed [2]. The last reference is released from the
device asynchronously - after an RCU grace period - when the netdevsim
module is no longer present. This causes device_release() to invoke a
release callback that is no longer present: nsim_bus_dev_release().

It's not clear to me if I'm doing something wrong in devlink (I don't
think so), if it's a bug in netdevsim or alternatively a bug in core
driver code that allows the bus module to go away before all the devices
that were connected to it are released.

The problem can be solved by devlink holding a reference on the backing
module (i.e., dev->driver->owner) or by each netdevsim device holding a
reference on the netdevsim module. However, this will prevent the
removal of the module when devices are present, something that is
possible today.

[1]
#!/bin/bash

for i in $(seq 1 1000); do
        echo "$i"
        insmod drivers/net/netdevsim/netdevsim.ko
        echo "10 0" > /sys/bus/netdevsim/new_device
        rmmod netdevsim
done

[2]
BUG: unable to handle page fault for address: ffffffffc0490910
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 12e040067 P4D 12e040067 PUD 12e042067 PMD 100a38067 PTE 0
Oops: 0010 [#1] PREEMPT SMP
CPU: 0 PID: 138 Comm: kworker/0:2 Not tainted 6.4.0-rc5-custom-g42e05937ca59 #299
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc37 04/01/2014
Workqueue: events devlink_release
RIP: 0010:0xffffffffc0490910
Code: Unable to access opcode bytes at 0xffffffffc04908e6.
RSP: 0018:ffffb487802f3e40 EFLAGS: 00010282
RAX: ffffffffc0490910 RBX: ffff92e6c0057800 RCX: 0001020304050608
RDX: 0000000000000001 RSI: ffffffff92b7d763 RDI: ffff92e6c0057800
RBP: ffff92e6c1ef0a00 R08: ffff92e6c0055158 R09: ffff92e6c2be9134
R10: 0000000000000018 R11: fefefefefefefeff R12: ffffffff934c3e80
R13: ffff92e6c2a1a740 R14: 0000000000000000 R15: ffff92e7f7c30b05
FS:  0000000000000000(0000) GS:ffff92e7f7c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffc04908e6 CR3: 0000000101f1a004 CR4: 0000000000170ef0
Call Trace:
 <TASK>
 ? __die+0x23/0x70
 ? page_fault_oops+0x181/0x470
 ? exc_page_fault+0xa6/0x140
 ? asm_exc_page_fault+0x26/0x30
 ? device_release+0x23/0x90
 ? device_release+0x34/0x90
 ? kobject_put+0x7d/0x1b0
 ? devlink_release+0x16/0x30
 ? process_one_work+0x1e0/0x3d0
 ? worker_thread+0x4e/0x3b0
 ? rescuer_thread+0x3a0/0x3a0
 ? kthread+0xe5/0x120
 ? kthread_complete_and_exit+0x20/0x20
 ? ret_from_fork+0x1f/0x30
 </TASK>
Modules linked in: [last unloaded: netdevsim]

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/devlink/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index c23ebabadc52..b191112f57af 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2016 Jiri Pirko <jiri@mellanox.com>
  */
 
+#include <linux/device.h>
 #include <net/genetlink.h>
 
 #include "devl_internal.h"
@@ -91,6 +92,7 @@ static void devlink_release(struct work_struct *work)
 
 	mutex_destroy(&devlink->lock);
 	lockdep_unregister_key(&devlink->lock_key);
+	put_device(devlink->dev);
 	kfree(devlink);
 }
 
@@ -204,6 +206,7 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	if (ret < 0)
 		goto err_xa_alloc;
 
+	get_device(dev);
 	devlink->dev = dev;
 	devlink->ops = ops;
 	xa_init_flags(&devlink->ports, XA_FLAGS_ALLOC);
-- 
2.40.1


