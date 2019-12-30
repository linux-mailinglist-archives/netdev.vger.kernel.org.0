Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE47612D458
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 21:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfL3UOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 15:14:37 -0500
Received: from mail-eopbgr680093.outbound.protection.outlook.com ([40.107.68.93]:56482
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727667AbfL3UOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 15:14:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UfJrSOQ+NK12XCnAVOSe23FDceNxkphjVgvd6IbCtPd0cxFWw97+wMDraux6t/YAm4ib7Z0mUL/SyJ1+qJkvSdTAbc1vtkDkAQ2BY5QiIWEfvaXzL/cedRiY2UV5Bv/6GmWdJAlqCt0y8W7IB64Tsb8XVz2AeKebtyq2xPpF8k3Ovy0nbPeEHQqVqtHmib0u3Qv3zjHByn/wDLwIvlH8fwewrBmv/FsXkMMC1TJKO1XXU2aBjSK2BVBnGQPRI6gWIwYw2peBwTuQYeJChdTloeftLcWkKBFV/JFiHPfEaOubxi52P8gwrFDF+Q0OUDmn6KaT3koPN4Ler1muHavukQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FE+TeZ8HsTtCfcVx3oCCeYc6rM2U7eATcut/H80QDiY=;
 b=gSLE4eVeUanjQoBaSkpJzu0wvj03UFKoVmN9a/LsD7c+4frb0SN+4WBFVHcyz/+B1+Dz3hBsiDPsD1kQvjTzveXPPZDwHS7jUyo5HIi+9Cto8l2ra+v33pCH5dcvWdkHcd0YzJxXqKWY6rGqgBlXG0LeY8JmlVn6mYjPd43hcaInROOaJBIU0KlRa9EhtvjkClxJVIrTEQWt7cGgpf0hLpfHyFI81pu4vYditVnObmw5lXtA/7+epj/s+6sM9br/KXmr8+unrpgLtwrivJPTUArUByzllOsekzU0V5r3x8xGl7kQRtoj/soHvlcmaH3pKxnA1yHVwebq3VqfWU+zPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FE+TeZ8HsTtCfcVx3oCCeYc6rM2U7eATcut/H80QDiY=;
 b=E3jpiXBtgru6nvmlRI2eLsI5V2sdb9kq2mqlfj5f/zKuexUqO9y6RNblXwqPJHWWrNEkPACtM48deLpnj4rTzfFRpyb8ZwOMQuoV5SP0FmPH6qT70IHc6KC4bkwRmTl3j6s6seCSSQCLXQtTGtliU+FWraawQz2Ha6hX6wBH6Yw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB0936.namprd21.prod.outlook.com (52.132.131.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.8; Mon, 30 Dec 2019 20:14:22 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91%9]) with mapi id 15.20.2623.000; Mon, 30 Dec 2019
 20:14:22 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2,net-next, 2/3] Drivers: hv: vmbus: Add dev_num to sysfs
Date:   Mon, 30 Dec 2019 12:13:33 -0800
Message-Id: <1577736814-21112-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1577736814-21112-1-git-send-email-haiyangz@microsoft.com>
References: <1577736814-21112-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: CO2PR07CA0066.namprd07.prod.outlook.com (2603:10b6:100::34)
 To DM5PR2101MB0901.namprd21.prod.outlook.com (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by CO2PR07CA0066.namprd07.prod.outlook.com (2603:10b6:100::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Mon, 30 Dec 2019 20:14:21 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: be930b0a-f093-4054-ff23-08d78d64dbcb
X-MS-TrafficTypeDiagnostic: DM5PR2101MB0936:|DM5PR2101MB0936:|DM5PR2101MB0936:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB0936D0C194AED319EE4A2FA3AC270@DM5PR2101MB0936.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0267E514F9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(136003)(396003)(376002)(366004)(189003)(199004)(5660300002)(52116002)(6506007)(66556008)(186003)(2616005)(956004)(6666004)(16526019)(26005)(66946007)(66476007)(478600001)(2906002)(10290500003)(8936002)(36756003)(316002)(6512007)(8676002)(6486002)(4326008)(81166006)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB0936;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GHsioYAEtr8HV+tT4jKpcBOiQlj0dUcwXQFnbPEpi1nfkOPBFqvAIBLXs58m/Z8kkbvg+oIn8pr4nE/GCgXPy3MFavrJwQdlTr5rACXW53fG39RdaieD5fZK8E9ihBz4JQb3PrF8ly1xscT+sN0FOOWrnrjvZo8GCyxyFpwCfi68Q5+RuZ+daSbfRQ/AP/ZftJp1Bm2XowfH9B1BL8PEz+zcrGKgqX+KijXma96EhYiNb14WYGSCbzxlDt5lKp37Zd0ScZ5H95zIV3pXYhGMcnjf1ECu5TSZj1IjksfVQQQOydMHhdcfjleLUYKB1gFfKVTm4329Z8iDcmR9wAYQVegNPjaIa2FecRZHLthUGeYitH9OS56euk9kca2gW7DuyzIN7RPLjWNDbUK5YBNEPBwYvqZQPt5csLekB9yqpnIg6YKwnRJglj4mU6/rnJUy
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be930b0a-f093-4054-ff23-08d78d64dbcb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2019 20:14:22.1279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lFksIEhvzvt9aznRAdN1G8jQRrkIh+uRaRu+PnRtFxMtkmz0FB592HbI4eELTy08AAzGcRgnhsimpM0n+F78Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0936
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's a number based on the vmbus device offer sequence.
Useful for device naming when using Async probing.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 Documentation/ABI/stable/sysfs-bus-vmbus |  8 ++++++++
 drivers/hv/vmbus_drv.c                   | 13 +++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-bus-vmbus b/Documentation/ABI/stable/sysfs-bus-vmbus
index 8e8d167..a42225d 100644
--- a/Documentation/ABI/stable/sysfs-bus-vmbus
+++ b/Documentation/ABI/stable/sysfs-bus-vmbus
@@ -49,6 +49,14 @@ Contact:	Stephen Hemminger <sthemmin@microsoft.com>
 Description:	This NUMA node to which the VMBUS device is
 		attached, or -1 if the node is unknown.
 
+What:           /sys/bus/vmbus/devices/<UUID>/dev_num
+Date:		Dec 2019
+KernelVersion:	5.5
+Contact:	Haiyang Zhang <haiyangz@microsoft.com>
+Description:	A number based on the vmbus device offer sequence.
+		Useful for device naming when using Async probing.
+Users:		Debugging tools and userspace drivers
+
 What:		/sys/bus/vmbus/devices/<UUID>/channels/<N>
 Date:		September. 2017
 KernelVersion:	4.14
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 4ef5a66..fe7aefa 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -214,6 +214,18 @@ static ssize_t numa_node_show(struct device *dev,
 static DEVICE_ATTR_RO(numa_node);
 #endif
 
+static ssize_t dev_num_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct hv_device *hv_dev = device_to_hv_device(dev);
+
+	if (!hv_dev->channel)
+		return -ENODEV;
+
+	return sprintf(buf, "%d\n", hv_dev->channel->dev_num);
+}
+static DEVICE_ATTR_RO(dev_num);
+
 static ssize_t server_monitor_pending_show(struct device *dev,
 					   struct device_attribute *dev_attr,
 					   char *buf)
@@ -598,6 +610,7 @@ static ssize_t driver_override_show(struct device *dev,
 #ifdef CONFIG_NUMA
 	&dev_attr_numa_node.attr,
 #endif
+	&dev_attr_dev_num.attr,
 	&dev_attr_server_monitor_pending.attr,
 	&dev_attr_client_monitor_pending.attr,
 	&dev_attr_server_monitor_latency.attr,
-- 
1.8.3.1

