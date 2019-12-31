Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC1F12DC08
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 23:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfLaWOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 17:14:47 -0500
Received: from mail-bn7nam10on2098.outbound.protection.outlook.com ([40.107.92.98]:4448
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727071AbfLaWOq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 17:14:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SbuFjeK24gR8g41zeVjJc+6+sl6IicQC0yK/T6KKfTFhJX1Qg66F7h2mXyHlig0SURRSOy4Kv7pK5Io7N9VmNa/D1QtHrh0Mj18tfaMFRhwTWtS3o20GyXR4cF1s1iXvfYkum8Ljqy2aiONrO2G6MNADKj6AjQg7AVxKstsywByGMrD1ydQ3VlqJh5RDFCOCxe3aipTNNOQ7YUKNWCfqIapM6pCRlqzjLtpFctRUbM2ACfblMEGSSzk+bakYVoTUL0mjgQWZ/1Ce8V/gVLBaUwcX259X6hedsyzIUqpKGUXCbV942Uw+Rl/whLZOdsbxtUIp7X/MDBK34ILo8Jvshg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GZmCGQDnucZ8QKekn4KqUlusOYBATYRnV4eILtbI3o=;
 b=E+7TrPueuwt0fk2aa6VfY6KBw8KtQAYKHNXkdbCID+cDXkSJyM2FkSyddHOjWNilJXWrGOrPdnqQYXTAnUH1zeYTwx5f6AX9derk0SGijxUGnZRWJW+wtK3iDdXEo4TAFAw5ovPjavoNPpW0BttOHkL4xEKEpUX5z945MVuWjtguce+trJlSp0wYd1Li7Jsu9BwcvrASML7z8w8dX/L/ci2Z7UIKvaJ+Apb0T5cGKnoto27xPzreDQ4YR8oxOSjilf/YKAwrlZIBFLay5EGIdaYW/bTvppJMy6mkkytooSqnnAkPDjd5XaA8mqure1KjH9hGpr61ocIKWpTiwO9mjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GZmCGQDnucZ8QKekn4KqUlusOYBATYRnV4eILtbI3o=;
 b=B3RxiNRGqKaXAO9Xd6Bs0flt66dc6Z1Bl3Sz9PiHoJ/TKfkC/fqhXSA3avghYCKN220zAm7BAmw5eOGSLMEp4XCx+kCbjg6XRLC45MJYgmb/NC2yA/ouKxz6GjXLwmvhHVanio7pfLQnRrcaFjbBQcvUbN35m7xAj9aVGesw/j8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB1014.namprd21.prod.outlook.com (52.132.133.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.6; Tue, 31 Dec 2019 22:14:41 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91%9]) with mapi id 15.20.2623.000; Tue, 31 Dec 2019
 22:14:40 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3,net-next, 2/3] Drivers: hv: vmbus: Add dev_num to sysfs
Date:   Tue, 31 Dec 2019 14:13:33 -0800
Message-Id: <1577830414-119508-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1577830414-119508-1-git-send-email-haiyangz@microsoft.com>
References: <1577830414-119508-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR17CA0086.namprd17.prod.outlook.com
 (2603:10b6:300:c2::24) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR17CA0086.namprd17.prod.outlook.com (2603:10b6:300:c2::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.10 via Frontend Transport; Tue, 31 Dec 2019 22:14:39 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cddaa005-bf6e-4342-68c0-08d78e3ed4b0
X-MS-TrafficTypeDiagnostic: DM5PR2101MB1014:|DM5PR2101MB1014:|DM5PR2101MB1014:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB10144075EB7EF6A9ABBE4E42AC260@DM5PR2101MB1014.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0268246AE7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(39860400002)(376002)(136003)(199004)(189003)(6512007)(4326008)(36756003)(6486002)(66556008)(66476007)(66946007)(10290500003)(6666004)(8676002)(16526019)(5660300002)(186003)(956004)(6506007)(8936002)(26005)(2906002)(2616005)(81156014)(478600001)(81166006)(52116002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB1014;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IPVA+L9MUeOSoTUpp//WF0ZDQw8sxC2dewFA4h9hRwTg+HW0lU0M6fl72EiGMj0aGBqoo2h0ZQ9va3ojpD6yvY+XMApewqhpcQ3naf0hRhEsmKjWbN16JJNlcBJhV+UOwIXS0DzXYUeu81t4G37Yxm5G/Ojend+ZliYKYLnYK6XmH95zfVtW4cIxdGOed+a1q4EtMWh0JIFdCKrn2Czn6ipvArbhXjtdXf0KQGqz2eqrdIbD1EjpC5/CSVCar2jWVNXB/sv0+QOp6QpdhNGzKEJU9kE0KJaymGC552PFnIuyTTu+LSPxuHX8rNUYaUEEQyR227O4WjjMT78YWYE2N06mSRUMm6BEZz2LqzYqSzq0+mwXbzVI7lgluP2RM3pz5Ah4hMMUrz16gUOlWZ3s7hprqVVQ/k1Fq5oRyAKRQx7Q/Qq6zhIfr4thF9pA7imJ
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cddaa005-bf6e-4342-68c0-08d78e3ed4b0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2019 22:14:40.4841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iSqRgBzrem6F1ZMw44zxXpzpW541DHnGuAVXQm3Fbyu50+x5z8g9jI2NjK/f1LnpMACJoI5YKMxoHMx669iVCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB1014
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's a number based on the VMBus device offer sequence.
Useful for device naming when using Async probing.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
Changes
V3:
 Use "VMBus" instead of vmbus in text.
---
 Documentation/ABI/stable/sysfs-bus-vmbus |  8 ++++++++
 drivers/hv/vmbus_drv.c                   | 13 +++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-bus-vmbus b/Documentation/ABI/stable/sysfs-bus-vmbus
index 8e8d167..4c4dc86 100644
--- a/Documentation/ABI/stable/sysfs-bus-vmbus
+++ b/Documentation/ABI/stable/sysfs-bus-vmbus
@@ -49,6 +49,14 @@ Contact:	Stephen Hemminger <sthemmin@microsoft.com>
 Description:	This NUMA node to which the VMBUS device is
 		attached, or -1 if the node is unknown.
 
+What:           /sys/bus/vmbus/devices/<UUID>/dev_num
+Date:		Dec 2019
+KernelVersion:	5.5
+Contact:	Haiyang Zhang <haiyangz@microsoft.com>
+Description:	A number based on the VMBus device offer sequence.
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

