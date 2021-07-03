Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F3A3BAA12
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 21:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhGCTEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 15:04:15 -0400
Received: from mail-dm6nam10on2055.outbound.protection.outlook.com ([40.107.93.55]:61549
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229473AbhGCTEO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Jul 2021 15:04:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFlO0rAwPRYrtWDApeks942KNCNH+Qc1vuWBJz6NdSbK3mpL6dYHrETWh4MLhJppKrTGzhPgw9/lryFW2bL0E/8lEULPuspzygu4kbvEWEhiBmpv7x8fWQdtHEGk7v+KVwrBL9dEy7uISutcYBKwQUBvCSLmwyKPHXk7ovWlGxrcCHYTGGMKP5FU2o5ZDAevZvsbWMkrlT133MvnKJ+W9Psw0YEQihsdQknAOSRHoL87zUEMW8rtNY82I9TvfIoJlfOmvO8S54o9zfGI4EVKGRDujBM69/L2q8Jw8HPRVbP6uzxw3ZJ/qYVNam+Dpe2IOzY/EHIEBD5mX1Q0eXT2kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9bexkCkwDzJxe/vr7URy5176oFKMopujhBO0pY0VkuM=;
 b=FDgx+56MjwRQ0Y7MJEMccYeVeIkB3auxfmPYQJ/+uRWiwa4+aTR//Dn0i+Jg54y5D1S/FXyVjWDbaymGveFb0gob08TDiwdWsrIf39mgJVFPvaM4Ean531UKuROu8h7/CmL6EVy6Q18LmlsKeD6lwwd/j3QqIgLkZKvdtKd+oz00d4Z11WnxHTFtzr55llBYaOGVldyAXtrjH4ySa4ymA+5NWpK6KL0pxm/vNkzBUzVB7JQjNXTHfBxJZi5tTSIhQPtm70eTYEeqZM3r50DpYGJ8NCWvBO5uCGGVVIcI7IQ83XSbI+1nq4EkRemcucuqe824kq3aHxjmVkE5QwWGow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9bexkCkwDzJxe/vr7URy5176oFKMopujhBO0pY0VkuM=;
 b=pXJmE5vWpZckZR5qF6zgKBNZRL1t66MXRrgMw7IlwP5EN8Nn6/lPSoXy2oP3uXn3rBYlKTvwjz4R9DjTvGpIolTuHAkiUWwkYbtnClXG7mg7+Yj0lyF6ga+1ogz6zuukq1cJ5gl6Po9+cEh8kHEZLCWmjdMYOkXQcBaUMB12cjo=
Received: from DM5PR21CA0058.namprd21.prod.outlook.com (2603:10b6:3:129::20)
 by BYAPR02MB5927.namprd02.prod.outlook.com (2603:10b6:a03:121::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.25; Sat, 3 Jul
 2021 19:01:38 +0000
Received: from DM3NAM02FT028.eop-nam02.prod.protection.outlook.com
 (2603:10b6:3:129:cafe::dc) by DM5PR21CA0058.outlook.office365.com
 (2603:10b6:3:129::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.2 via Frontend
 Transport; Sat, 3 Jul 2021 19:01:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT028.mail.protection.outlook.com (10.13.4.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4287.22 via Frontend Transport; Sat, 3 Jul 2021 19:01:38 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 3 Jul 2021 12:01:36 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Sat, 3 Jul 2021 12:01:36 -0700
Envelope-to: jasowang@redhat.com,
 mst@redhat.com,
 kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Received: from [10.177.4.102] (port=54200 helo=xndengvm004102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <gautam.dawar@xilinx.com>)
        id 1lzktU-0000ed-B4; Sat, 03 Jul 2021 12:01:36 -0700
From:   <gautam.dawar@xilinx.com>
CC:     <martinh@xilinx.com>, <hanand@xilinx.com>, <gdawar@xilinx.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] vhost-vdpa: log warning message if vhost_vdpa_remove gets blocked
Date:   Sun, 4 Jul 2021 00:31:20 +0530
Message-ID: <20210703190121.9468-1-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20210606132909.177640-1-gdawar.xilinx@gmail.com>
References: <20210606132909.177640-1-gdawar.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41de0e88-39e3-4130-efb0-08d93e54fcb6
X-MS-TrafficTypeDiagnostic: BYAPR02MB5927:
X-Microsoft-Antispam-PRVS: <BYAPR02MB59279ED80F969B53E99998A5B11E9@BYAPR02MB5927.namprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f9QSucgGRaYPbkjpKMCKbIu7eR6ELNNniwk7rw8iIeeJz3zlufrsQgZeBXM/UMC/+EvcmcgCClQ1eCXuF+r6Vg0o3DKgny+qqNVmvImFyF6c2BwJ5O5bXeeXwHQaFkiHH+n1UKzWzjTEm+sNfm8xHVRg4/ICWl1Udt+zN21OL+0+3lb7LcdEV6i3DnGqaaMo4Tc40noM9V10HnFrfQ+PHL3xUquUgl54pnM4wNvhr7VBD9AU/SD1dgA/WaYecvHM30/VBXv+cOKWSeuFRrcEm1z31f470smY6MiKF05ucYAdli7bnwkzaHvYqPrwTPmj/uYc2C1u8E3EX5JoqDd5WHYVFPXxdGIs/+e78gMT91QaFCNuRIZQFLTkVaQsaionoS1+xXpEAjZJSoRP8Kl5EHNOCQ6qsjNoUfHoFTVS/tdb7pZ50rVaXm88WfnoGiGl+S3mSGTHrG2L+5Asew+PYyS1zDwf6ofKase2+Z0hYdxy50tEfAQuRuyz67QlIGCoZM9V/vP391QauoybwajjOc7FJ0lbdEcuBmJwKcX+mdwtv2U7XDdOzQOoKkYdMB6lH45Ti3rfToUsdmiXlI/aqarZBkEtTbwcCGrlXgjlut3si9FQqHbHiwMTXTJ27dyvzTCHqwFZoFIeEmHeCKbo0ci3IZEGSfNcoe2GGz4W52/jeXJYSzw4wOhYab5nfQ/COm5P/1Anaqghwa2fapz9ym7ajm1N7fXkPZOA/XebeeQ1OF6zFX6pMS7JzHTXL9CT
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(376002)(39850400004)(136003)(396003)(346002)(36840700001)(46966006)(109986005)(2906002)(82740400003)(4326008)(356005)(5660300002)(316002)(8936002)(54906003)(1076003)(36906005)(6666004)(7636003)(83380400001)(186003)(36860700001)(70586007)(7696005)(36756003)(26005)(9786002)(70206006)(2876002)(8676002)(2616005)(426003)(47076005)(82310400003)(15650500001)(336012)(478600001)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2021 19:01:38.6758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41de0e88-39e3-4130-efb0-08d93e54fcb6
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT028.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5927
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gautam Dawar <gdawar@xilinx.com>

If some module invokes vdpa_device_unregister (usually in the module
unload function) when the userspace app (eg. QEMU) which had opened
the vhost-vdpa character device is still running, vhost_vdpa_remove()
function will block indefinitely in call to wait_for_completion().

This causes the vdpa_device_unregister caller to hang and with a
usual side-effect of rmmod command not returning when this call
is in the module_exit function.

This patch converts the wait_for_completion call to its timeout based
counterpart (wait_for_completion_timeout) and also adds a warning
message to alert the user/administrator about this hang situation.

To eventually fix this problem, a mechanism will be required to let
vhost-vdpa module inform the userspace of this situation and
userspace will close the descriptor of vhost-vdpa char device.
This will enable vhost-vdpa to continue with graceful clean-up.

Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index bfa4c6ef554e..e4b7d26649d8 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1091,7 +1091,11 @@ static void vhost_vdpa_remove(struct vdpa_device *vdpa)
 		opened = atomic_cmpxchg(&v->opened, 0, 1);
 		if (!opened)
 			break;
-		wait_for_completion(&v->completion);
+		wait_for_completion_timeout(&v->completion,
+					    msecs_to_jiffies(1000));
+		dev_warn_once(&v->dev,
+			      "%s waiting for /dev/%s to be closed\n",
+			      __func__, dev_name(&v->dev));
 	} while (1);
 
 	put_device(&v->dev);
-- 
2.30.1

