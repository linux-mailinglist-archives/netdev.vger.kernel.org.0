Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22C20145AC9
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 18:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgAVRZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 12:25:39 -0500
Received: from mail-dm6nam10on2102.outbound.protection.outlook.com ([40.107.93.102]:12737
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725883AbgAVRZj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 12:25:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uu1x1Sr7UzTrZMTQtmG3ZuZIIdYG71BAdN96Hx9riTXlbkLOVOmPFYsPRA9KEcCVeeUaCTKQD0RZWsLUtBqs8GeRpNz/NZ7ONxfKnwBBsGa3Wu7Amo3E/Edd53HaRqNCgnfuY4SmDvcoHQ1/PSEzHyBxSw3tEhVomaUMdIbQSqHkf5CieRi6OeD8/3FtlxwM9aMISjP7WTAwQy8pL5SxVmSVaKUAuQGJpKXp/zZQ7RoSK4q2rgZmDzvzo+jaObOzW1b3Ap2JOWEj16jAmXybshgqi5E4Fz9SJbBfh2y5d7xQVxHGWxzkWNVJpj8/km7WyHEkeLFTe2Vw0sEubp6jjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PN6Y/7K5HRgHikv9alqsgK3mwWIvn4eIxNtX8w7Iflw=;
 b=GJUh76wcT98JKtvTh644Epa7GstjVqVBpyH+nqnmIZbIkpup7n8m10YfF77heGceUPJ1Oa5uI25M4Pio4We/f/719Q2wBahMGf9H7fwHrHBCDwSIiDfcZfQGbu/xcyxeEhMUucX5VjM8SlSZFMYyBU9L88muB+UCfMaxBVzgKYAx62uadp/fdFh48JOFsPySfDmqyhgBcuYgFpbip1AH1ZI1vK/gYxAMXCJM06ohpeZp2qiT/XhpbdchMnpqTbcFKkWf73V/nkiYKVkeuo0tQddl1CCphWYqTboF+3Z22dXLwptFUsyXVX8dfw+eLnC9RIS4HWN6HmvW1mA0g16ohA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PN6Y/7K5HRgHikv9alqsgK3mwWIvn4eIxNtX8w7Iflw=;
 b=KgLFvqHU8oyYMRGK4L79lztxMmxtN9YKE2MQIj6hSHBGmJNHviG4+KbCuQefMy+OA/D86IHzKm7HoIqVRBS/yA9nGbqtyRkVDuzAY7JU6oyNcWEHLvYtijwu1H24ZGRyN7OQhXmrmRJRliZJEM6tozg8owwpLQ/PHklDYpPjjAQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB0918.namprd21.prod.outlook.com (52.132.132.163) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.3; Wed, 22 Jan 2020 17:25:00 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::b51c:186a:8630:127e]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::b51c:186a:8630:127e%9]) with mapi id 15.20.2686.008; Wed, 22 Jan 2020
 17:25:00 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3,net-next, 2/2] hv_netvsc: Update document for XDP support
Date:   Wed, 22 Jan 2020 09:23:34 -0800
Message-Id: <1579713814-36061-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579713814-36061-1-git-send-email-haiyangz@microsoft.com>
References: <1579713814-36061-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR12CA0039.namprd12.prod.outlook.com
 (2603:10b6:301:2::25) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR12CA0039.namprd12.prod.outlook.com (2603:10b6:301:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 22 Jan 2020 17:24:59 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3f5e9f13-43f7-455b-0832-08d79f6001fc
X-MS-TrafficTypeDiagnostic: DM5PR2101MB0918:|DM5PR2101MB0918:|DM5PR2101MB0918:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB09180E9FAF977AE63C97289DAC0C0@DM5PR2101MB0918.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 029097202E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(199004)(189003)(16526019)(186003)(316002)(6486002)(52116002)(4326008)(26005)(81156014)(6506007)(81166006)(8676002)(6512007)(8936002)(36756003)(2906002)(66946007)(66476007)(478600001)(5660300002)(66556008)(2616005)(956004)(10290500003)(6666004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB0918;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MaDEAj8Hb9VDcLaGP+qUSMn8fc1b5u/p6r8rxWQLkPVif1dc2l14ECRMMmlr+ub14qdnmCJni8InDsoFIywmxfwV5uUpwRkqASc1D66nXnpzKxFWtYQyq0mTl8RE1iieV+yVyLd+11AIGqJoxfFss1qzyJ1ulzZ2ykcV1qSRcsbQp6R/V6enymRttKrx+J78opjlraxWeiabObFaghwFbLl/CYYaJh5DuRSpwj0bbGbKnrRKur07WPPMaXGfu64ZAkCXYlBmFUAfzbKXjuvBZ3BGsZ7en8jnXs2mc7cWYt8UBTkNz6I968RvkbDsAPppcVM0qPqvSwmdCUkZOROf8A/WG6DXHf6bzg7eiesGzopZoiycx+xBjBdsRXq52R9aXqgh8bg0QpMZq+7MrBATXo4SbyZM//yQmO1CHskXgI+M5Bg2s2s9WMRmqtqhE16X
X-MS-Exchange-AntiSpam-MessageData: KKPOeoHEN72nuH6mP7AaSusIyf7Q/W6grNgsJX86hZMK2cc6uYsTKfUCuinqGhxXdbzxaFW3jmi7HGEEH2bpvqv2ySIszGDh7NejjgQmBQ6/D4s5vaczcxhA0XAZBs62ndHt4aDhz42X4wpvNZWTFw==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f5e9f13-43f7-455b-0832-08d79f6001fc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2020 17:25:00.2091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iNMPl6lCU28DVUlP5j08ekQ/zbWXLC7Zdl/6KAIACSXclfxsLaKqglgr6cg13ejP/pmKyHwiGLVk2tlOKGEC2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0918
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added the new section in the document regarding XDP support
by hv_netvsc driver.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 .../networking/device_drivers/microsoft/netvsc.txt  | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/networking/device_drivers/microsoft/netvsc.txt b/Documentation/networking/device_drivers/microsoft/netvsc.txt
index 3bfa635..cd63556 100644
--- a/Documentation/networking/device_drivers/microsoft/netvsc.txt
+++ b/Documentation/networking/device_drivers/microsoft/netvsc.txt
@@ -82,3 +82,24 @@ Features
   contain one or more packets. The send buffer is an optimization, the driver
   will use slower method to handle very large packets or if the send buffer
   area is exhausted.
+
+  XDP support
+  -----------
+  XDP (eXpress Data Path) is a feature that runs eBPF bytecode at the early
+  stage when packets arrive at a NIC card. The goal is to increase performance
+  for packet processing, reducing the overhead of SKB allocation and other
+  upper network layers.
+
+  hv_netvsc supports XDP in native mode, and transparently sets the XDP
+  program on the associated VF NIC as well.
+
+  Setting / unsetting XDP program on synthetic NIC (netvsc) propagates to
+  VF NIC automatically. Setting / unsetting XDP program on VF NIC directly
+  is not recommended, also not propagated to synthetic NIC, and may be
+  overwritten by setting of synthetic NIC.
+
+  XDP program cannot run with LRO (RSC) enabled, so you need to disable LRO
+  before running XDP:
+	ethtool -K eth0 lro off
+
+  XDP_REDIRECT action is not yet supported.
-- 
1.8.3.1

