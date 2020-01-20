Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6BB61433E1
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 23:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgATWXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 17:23:30 -0500
Received: from mail-dm6nam10on2104.outbound.protection.outlook.com ([40.107.93.104]:43073
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728709AbgATWX0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 17:23:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFH7JGx66lyIiIneNix9xOsm6zAKb7py0cbppdLwQBJ0WQFoJEHfoJTZxMkjtqi1MolElviyYO1WgaVTYCoWhwe+GxPHUxo3BX98AhUUXTgW/VxrR/ygQ1yK4chgXmElBOwhdDG2vJuAkezlPgOjNkL4Ol8ZebkxwlBdExy+KJMpPk7cwEKWWkIJ0aSmxsnC/Im9BhHXbnXZi6gto8tdve5bTU+8m5qYaxG7IIlU3C0h5eXlccihtuX/GEhU/Bu6HtHWY8BLaOfE7gzKoUO8ryB05GkpnrvbIS29D1h9jOMJG45cBG8WcMMjKRIyCTokvg0vpH7xO5XFjlfRc1nULA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PN6Y/7K5HRgHikv9alqsgK3mwWIvn4eIxNtX8w7Iflw=;
 b=Zz7+66yYJo0sH39qrwIUWUTuvhE/1ViD+dPxMJBPFAmVqIAZ3xFq76+HWf8C7toCisDWEpgAfpTIKx0uPYPyrCV14fXnVfX8//qmgOn/3bNBZwpcnXtcbVS/+6qS7ag71iH3qyxRlBrRMzQX7Wl2z/E1AriFUVcnDdMjurzxu+DgwPGEPNzJDxGQaB1051Dsn8jOzIJKi/5ob+VfrZZk2EJWV+xmRjxRViaboMz+pGuykoLCroGYGh9Tc5QfVDorBtYosP8bn5NBED2kPY8JCSyx7ZtCeD103l5uw/o069PhwiAzQxWmF85NcfMh6uT2H0s7fx1bs/ij+OvkF4/IOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PN6Y/7K5HRgHikv9alqsgK3mwWIvn4eIxNtX8w7Iflw=;
 b=J+PJbRGr3iXkT7dwelGdlu9LQfUexXNpXea1DnMvDtK8yfwKGud4QHPCMne2Hi5/oIlgjAMZtPs2R87ecTO7G/Ia1YPmi2yY7S8AYRVTTFd1vURHRgZILbp2qaDJYRs/nosmvPpvjWMmPJMYpkz2DY9G7VVCg6CYpUp6Mp6wmvA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB1094.namprd21.prod.outlook.com (52.132.130.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.3; Mon, 20 Jan 2020 22:23:08 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::b084:4e21:c292:6bb2]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::b084:4e21:c292:6bb2%9]) with mapi id 15.20.2644.024; Mon, 20 Jan 2020
 22:23:08 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2,net-next, 2/2] hv_netvsc: Update document for XDP support
Date:   Mon, 20 Jan 2020 14:22:37 -0800
Message-Id: <1579558957-62496-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579558957-62496-1-git-send-email-haiyangz@microsoft.com>
References: <1579558957-62496-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR15CA0043.namprd15.prod.outlook.com
 (2603:10b6:300:ad::29) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR15CA0043.namprd15.prod.outlook.com (2603:10b6:300:ad::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Mon, 20 Jan 2020 22:23:07 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9f13ac95-4528-4f5e-905c-08d79df75373
X-MS-TrafficTypeDiagnostic: DM5PR2101MB1094:|DM5PR2101MB1094:|DM5PR2101MB1094:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB10947DD4DFC63F7D0BD8C228AC320@DM5PR2101MB1094.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0288CD37D9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(189003)(199004)(66556008)(66946007)(66476007)(52116002)(6486002)(478600001)(2616005)(6666004)(4326008)(8936002)(10290500003)(36756003)(26005)(6506007)(316002)(6512007)(16526019)(2906002)(186003)(8676002)(956004)(81166006)(81156014)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB1094;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OSKoKMDEzfYXklK/RGTNlS+WWjPs1Dm7yhUeusVzu5QPWIXveCr56lw49HQ4idOZhDPSt6xtc1hw+9+2FiLzSoYjJTWeSd/kl1mXUK5jcekuZ6BsXlRi6N5YImEMKsJqqZ8YUgZWowlbhH5EBWsfPRJhU6QZFWKRbKnRjuefriMztpaWmz3kT7rere8SkHJLGUxtkZERgiZbKhJRtgTi1JtrZSgeTH8D0MaJ0NbJ+ziGO0IYYLzc898jkD1BU6ZCAD78YdtoQ1XndmLqdjIa4vmWB7MKAnZ6evT1eXCVAeclGqlL+DIibcp7WUMkUM1AqSGG/IJu9WVE8FPo/O0RdjROX+CLeORZFpkRsQzNxG12uOPAHIKRgHpY2FaGdBt6W3hYLhsgFzgcr3okz/FH9lcxyKx2CwW8kAx3llLXVd1ru6ovO3Y12OgY9HB+MsIG
X-MS-Exchange-AntiSpam-MessageData: DUYK0lmj04ceMnXik/66GOcZVVNkXLRu3vO1/czHkLeF3iGRnu7IhcKaVaUnB61yxR0avi5Mx6SE4FXRSV3AG3RVhwWCa9/WkrnQ/VBXeSEHphgcxD7MhTANT7TQ584sC2fb98WXkmk+FJN73KGg7g==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f13ac95-4528-4f5e-905c-08d79df75373
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2020 22:23:08.0039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lPH9r7gZkWJlVThJJvHGBrOA7c24CEzyt77sXQyTVR3AyvSPTu0DKAjSMo/QjdGMKWHDQWcuJFxTPYlS8dIHvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB1094
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

