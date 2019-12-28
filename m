Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3681212BFB0
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 00:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfL1Xqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 18:46:55 -0500
Received: from mail-dm6nam10on2115.outbound.protection.outlook.com ([40.107.93.115]:44128
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbfL1Xqy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Dec 2019 18:46:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IK+EX0Q6mIwQITHl6qsH6e7Y2AdA2bplaaIJVax+AX75BuJz7J7/0Z0oxObQmK5j87gz2i2aZoctuKBydrjx7YXcYYmmGGNg8fY6tXM3DjbFo0cfg8BVCDgf26/TVLLWQRF+b9+NM+BY1jJUiJ1o1iqvPWfazF1OnjTtT2itpTZli2c1TDih7q/S6b92CsBGKv3+6x8eHYNTsC1WL6wdgoUsoTprAv2ZQATQvGR57/MvUAi0kG4zhowDQtgHGPErXCHJOKI+ucMByimOH6YKnaaEcC8fih2/rjNrcBRBKg6O7zyMWoxUMr3YhXwUOtyFiTMh4Et7qCcj173yCEM9nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CH9XhAmj/M19pR1mX9L2wRkkzfErzVmgW9+4CIZn2tE=;
 b=LQQpwzL2XJ/EWdRymhz2aufpWXbG0iP6lZYu3KhlkbyrVoGWcHFt1uERF3KjqzaZwwBpIZssG3PaDUNlgDRfMaMeV/2xkl6zXdDkpn14CqQrg2h6eObMcaQEzOVHPEjerx5ey+SZkgL/CbR9Nyd/ohomZy07+DOpZrtQiQjNu+ChTf8lMISsu/H+unLfvmqU19DBpbVo+Y/G8oLl3bzkm8lVvToh5wcQ0t1dU9aNG+iv6nEiyfI/0eDEf0eDS1kfshHnmync5Ip7wXXG5iuaf0kHP6qhFXkOZne/GXMnVhuUXUUmCm7CXoN3da50SNWxWXaxbfX++UeBaL2HroNoJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CH9XhAmj/M19pR1mX9L2wRkkzfErzVmgW9+4CIZn2tE=;
 b=c9BPzEhRKafXm43DHKtgRhUFCGsGcAnhmKjmiIcHypbbc3SQA/3Gq2RKwMKbjpvbZkDxnF3Un3yxx94I8YRua3XXTlYyXdw+lu29DFS0qq0xD4es8RdlI3EjZ0MdCs45jb8zBaQfeC8wmnQf3KlQ12Y0PUgIeRbg+iKcHP2uCEY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB0727.namprd21.prod.outlook.com (10.167.110.39) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.1; Sat, 28 Dec 2019 23:46:52 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91%9]) with mapi id 15.20.2623.000; Sat, 28 Dec 2019
 23:46:51 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next, 0/3] Add vmbus dev_num and enable netvsc async probing
Date:   Sat, 28 Dec 2019 15:46:30 -0800
Message-Id: <1577576793-113222-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR1201CA0022.namprd12.prod.outlook.com
 (2603:10b6:301:4a::32) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR1201CA0022.namprd12.prod.outlook.com (2603:10b6:301:4a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Sat, 28 Dec 2019 23:46:50 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dc3f0869-66a4-46f5-5319-08d78bf03627
X-MS-TrafficTypeDiagnostic: DM5PR2101MB0727:|DM5PR2101MB0727:|DM5PR2101MB0727:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB07278A7A1379C663200C0ED0AC250@DM5PR2101MB0727.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-Forefront-PRVS: 02652BD10A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(136003)(396003)(366004)(376002)(199004)(189003)(6666004)(478600001)(81156014)(10290500003)(6506007)(8936002)(4326008)(2616005)(36756003)(316002)(81166006)(52116002)(26005)(956004)(8676002)(2906002)(4744005)(5660300002)(66556008)(186003)(66476007)(66946007)(16526019)(6512007)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB0727;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j2Ovl+UU6k2nCV9oU14/KznEnpnl4t7BwqDtYq7GqWZ08u1/g7eaTocNZky94FEzXE9MoIYbEXD/q1LwT6itopZXKHyO4wd1K0IDGrU0TrO3y7wy0luRtxoK4txl4c+xnOQst9D6yK4VrY2bf9uDdmeIobMPcP09u/4d86aC2GrekqiWY8PwPRKNj+4NNcY9m0D07s2uGjkv0oH7cHRo/QiuzPPs2QMvjd2TIf/dO1dAIKlKlRWWnnyhSBSbFMhWZAkclCg1VWJ/6DkmovatDadZzznCpa4oo5YAn/Q7BaEK+mbgrsZvDeeLV51EDyw1ElMI5wtC+LqW/zD7Xn/4X1X4sOlA5npB23ZkW+k0ZfGvb9raeTo+w3FZEgQ0DNHYgyCUhS+dwF+AwErGFqdLPYyDZR8nubtOvshIGb2JsHzOnLxNr4Y69cCea3ttpZow
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc3f0869-66a4-46f5-5319-08d78bf03627
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Dec 2019 23:46:51.6191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 529gLGuMJcN4ItidXwvtjFmQnI61J8RSwyEcjRUXa2Cj0AUC85qEmM3SJu/190N7qccIM4gVNG+i+Ut7Ylo8dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0727
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dev_num for vmbus device based on channel offer sequence.
Use this number for nic naming, and enable async probing.

Haiyang Zhang (3):
  Drivers: hv: vmbus: Add a dev_num variable based on channel offer sequence
  Drivers: hv: vmbus: Add dev_num to sysfs
  hv_netvsc: Name NICs based on vmbus offer sequence and use async probe

 Documentation/ABI/stable/sysfs-bus-vmbus |  8 +++++++
 drivers/hv/channel_mgmt.c                | 40 ++++++++++++++++++++++++++++++--
 drivers/hv/vmbus_drv.c                   | 13 +++++++++++
 drivers/net/hyperv/netvsc_drv.c          | 18 +++++++++++---
 include/linux/hyperv.h                   |  6 +++++
 5 files changed, 80 insertions(+), 5 deletions(-)

-- 
1.8.3.1

