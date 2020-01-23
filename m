Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 693E6147368
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 22:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbgAWVxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 16:53:45 -0500
Received: from mail-dm6nam11on2105.outbound.protection.outlook.com ([40.107.223.105]:50401
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728911AbgAWVxo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 16:53:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2N5AhgsFXmWSW+HiZAt7RP9p+advkbOrY6gEx+qbsP1hnw7d47PDfjoCUWC66qqkMNeEfDfi2ZdAs+SusSiSKDj1aPN7ymKKrEj0E6s4tmTV41vFXVQ+52kqCAuvjunxyxJ/y0UIqnrIkrnwvwGR2JWdSLUgBCfliM4IyvVkf2cr/Ww2Bja/Ur/ykwgNYhRRidwSYt8V/RLHK2S4CH0Iy2OG2HvH+UEOtAWOJXV1WmPpE3afSsmoIEEnEeMhoNDr46lN7ul4YSZM/UCttX4mB/PV+OjgofXLOArfBMxI1vrYZhk83Xhk5qfdh3vCWJm2v4Eq2EN6q6V5OqzKMxmVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PN6Y/7K5HRgHikv9alqsgK3mwWIvn4eIxNtX8w7Iflw=;
 b=G3J9fh80acV0yHxG3iQLHe94nMUHc77x03aOLhsnTMwRHqKQVbd+liOljkG0wd9+XQPqnb8L9tLEMtmvGbDTxZjhGGUnSooUFwDwczKAW98agmly6AvW2nWHrVx67wCBEN70IjdDgXTwWEBojIr91zT6xlpUn9arILHPL1AyyQdrnAJECQVVyspoMgtYXl4pqiFouUnJrokPO9zUHkcU0j6kAsm5Sxs9smwMZ8Jw9vS8IZbKITTrYztnl8zG7kZImouXN/NnsZ8pYGdQIB93/d1INTpxNSmadCRaEeTqAmbULaPfi2qcLH/TouxiqMVif1OPRL8yRP8BNdw3gM75Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PN6Y/7K5HRgHikv9alqsgK3mwWIvn4eIxNtX8w7Iflw=;
 b=Dnf5rJxCiJoJN9A6uIG5EmxKhgrzI1/yGt1LVzcvR4+SiD0J8fhM88svTAL/SPe0+XoBeqFGqaRSbieycC+QHwHYNdxQhbheTtTHVGmDc/8UGFIC/QMFgL/EDVZ+T4wJLe5kCbLN+MG3nTBNtlBr+CeE0W11U/lSbLp45zDdaW0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB0869.namprd21.prod.outlook.com (10.167.110.162) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.10; Thu, 23 Jan 2020 21:53:43 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::b51c:186a:8630:127e]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::b51c:186a:8630:127e%9]) with mapi id 15.20.2686.008; Thu, 23 Jan 2020
 21:53:43 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V4,net-next, 2/2] hv_netvsc: Update document for XDP support
Date:   Thu, 23 Jan 2020 13:52:35 -0800
Message-Id: <1579816355-6933-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579816355-6933-1-git-send-email-haiyangz@microsoft.com>
References: <1579816355-6933-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR15CA0039.namprd15.prod.outlook.com
 (2603:10b6:300:ad::25) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR15CA0039.namprd15.prod.outlook.com (2603:10b6:300:ad::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Thu, 23 Jan 2020 21:53:42 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5c0689b3-5a97-49fe-ffb2-08d7a04eb6c0
X-MS-TrafficTypeDiagnostic: DM5PR2101MB0869:|DM5PR2101MB0869:|DM5PR2101MB0869:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB0869F8486EA49CAB3DBD8C50AC0F0@DM5PR2101MB0869.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 029174C036
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(346002)(366004)(39860400002)(376002)(189003)(199004)(26005)(16526019)(186003)(81166006)(478600001)(81156014)(6486002)(6506007)(5660300002)(6666004)(4326008)(10290500003)(956004)(8936002)(2906002)(36756003)(52116002)(6512007)(8676002)(66476007)(66946007)(66556008)(2616005)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB0869;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aCu8CO02gIXDvEH1y8DpHeZHRPvSojoVo8ADexo+5+xpP94+rm6VrnZCiSMc3FawopsEnGxnT6RMb1t6kU1FfYOaXaXEXFwHugKlvZceyz4inZFGXr4dzRYUwcpprwiX2dxA1qru4Tku9wtTNLvEP5VoND6LqQAYAOWFauALTjD7KuejC4132zTMFrORdxQW2xl78Le0bXZxh+4P7qYbONR6rq57xZUUbxvrZIOL/QtRc/XjgV7LbhE0qWRQdoP/K6+ndKAoxIsOSuo7I5AFk1jSi4dxT/CoNba/bi+Z2tpxvEg0WnBPCcQuC0qPHgK0w0giPIns9XarL5mBfg66oK1TKbKr9/hKC1jP11UHBMhcROgu5fS+ehiwkMa9QILUXWoRJtk550ceutGeV1he0KXEaVkWDUYOncDh+hOb6r4+Fs2H9GAVa/H0SCnlE5pe
X-MS-Exchange-AntiSpam-MessageData: LtWdnnzbw5244sjBvhTxFOI0etYStCGRYOyzFXlTwr13pnrXFLRYZGaBHNSB863dnLRq4xSfL7/12+Lxyb3NtgbSVHwdihAqC5uLd5utrN5rRk/lj5jB98E6M00gt8XYw2XOR0U+DwcsPEvozoNzOg==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c0689b3-5a97-49fe-ffb2-08d7a04eb6c0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2020 21:53:43.1878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: URltcD0zENuRl0vzvz8IVdsR44GxRd3K2yGZ7nQ1bVlehO+DgE/OrFYvytUMWJwV9cMo8b09r91br8CL6nfsrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0869
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

