Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20CB612DC04
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 23:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfLaWOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 17:14:48 -0500
Received: from mail-bn7nam10on2098.outbound.protection.outlook.com ([40.107.92.98]:4448
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727054AbfLaWOr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 17:14:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U52XCLztCJYcovZ67ugReSw8ze0Dy4rPPWMMx8DNUVo3yxbHgezCSDX1a+nM5bAelaW7T6ySvc5De7IdC/5zec/F0rv8j7ItJYRCc+2Li7nq2DlTeD4UVXNwkBLFaUfoblvvMsQzd64XhyBDYtGpy1Wk3Tn4tu930G1sAHaGuJksvV3oXDzMnk0jr6d6JCZEZHlSkAWMYukVAoi/mdnl7YAatkv+BfJ2oxTLbu9elS5v/X51YqdGCdSgNcBz7PEmgbHyc1q7WEZiw1k4DbZigp7Vf8cJlTdCkhyL9ircmiN56FXbgjQGz2Ud5hE1mjFO8Hi4aB3voYBVq4rr/kesjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y4Qmud1xUpyEh01NeLjwMyDNWhn4sUktq62mMZ21DYY=;
 b=JFQS7zskp0ztoE4mjB7zJWtpG2LD1mFhXcAlJtlIEeLvUXO8tXm0vtD1WB/L0cJNPE131bcNttsLTRBWlGWFy26TKVKgQSiFb8TWjfW2TDdeDcKYkf0kMI3bGJdyeeFm8fJYi3ctH7GV5jblPB3GanPaiRleDYT0+yUY0hJ2MPjRAD8wl2U+F5bFOBNjSX2vyoKFDbjvSg2Fog6YuKYL1IVK5j3DFSZkNDT3DOR4bfVSFXTIRynkhm+KMYPOCnLeabP9Rj8sh3D95uS8LOJlvUC0On18dF6IhWMt/ljU0/S90AZp8MAwMnWExUt0g0mUaAcLAvROVa9uiR5Ou1xYXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y4Qmud1xUpyEh01NeLjwMyDNWhn4sUktq62mMZ21DYY=;
 b=dML1GNkzFQfvqMFoMXqLm9LRWP5osf/tGNYOsrexRdv0zTZm3PcUWRDf5XpBeXKT+VWRSovOtU9WZRWuvWA+FP7yWkiqkjD3bnmlr1uTrSqEcGWwbgY80unb3wOZ66v6/+5MCB097/nejFdrGg4uS0uKm1HXN+J4g2uusG0M4hA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB1014.namprd21.prod.outlook.com (52.132.133.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.6; Tue, 31 Dec 2019 22:14:42 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91%9]) with mapi id 15.20.2623.000; Tue, 31 Dec 2019
 22:14:42 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3,net-next, 3/3] hv_netvsc: Set probe_type to PROBE_DEFAULT_STRATEGY
Date:   Tue, 31 Dec 2019 14:13:34 -0800
Message-Id: <1577830414-119508-4-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1577830414-119508-1-git-send-email-haiyangz@microsoft.com>
References: <1577830414-119508-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR17CA0086.namprd17.prod.outlook.com
 (2603:10b6:300:c2::24) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR17CA0086.namprd17.prod.outlook.com (2603:10b6:300:c2::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.10 via Frontend Transport; Tue, 31 Dec 2019 22:14:41 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a5d459ce-f006-4b36-0bea-08d78e3ed5bc
X-MS-TrafficTypeDiagnostic: DM5PR2101MB1014:|DM5PR2101MB1014:|DM5PR2101MB1014:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB1014A6F36600F66549898D9FAC260@DM5PR2101MB1014.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0268246AE7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(39860400002)(376002)(136003)(199004)(189003)(6512007)(4326008)(36756003)(6486002)(66556008)(66476007)(4744005)(66946007)(10290500003)(6666004)(8676002)(16526019)(5660300002)(186003)(956004)(6506007)(8936002)(26005)(2906002)(2616005)(81156014)(478600001)(81166006)(52116002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB1014;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W2ySnvgvk6hyNCTCESDRIVdYZSEbVQs0ERANM7lUwcAwv8ZHFL4+TKMusEN9SHgrLGN43F6zHHxIIlMI9whKwJAQsIc9C5yVpQqy80lGNnf9Vai6HtfIqNxQfnvW9N5YXA+VTcP93x4NZYCcQRk1rZbFT/D2XdH4A/z2vNINS31iXsdzj9xB0pXMgzhf24qpVxm7EDgO2mmfoDuqB3pETDLD3AHtmgalBZcAEiK6a1Wlt2key3MmeP+rQtiNzp4HrX8AKiJUcuEKngbRa+O/SP57+c9wcTgPY3xp5Ngc5MODPNOZpY6A3OPMgRvs93GvdYxZFsqG8u7WXKmxiQUINfBbImJIHOBP0hBt/kW7NDv3bVaTWxrGQxYXWOesatVyzKr/nkHpm6j23015UHbI3LBAUox6q+kDKdL83B0xFYfiF92QdWEX2F1JVocJrEW5
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d459ce-f006-4b36-0bea-08d78e3ed5bc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2019 22:14:42.2840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XOmR9jlHK4AQhRF2bIVIJC5eq5eLGg2WvQOvFU8LEdJyK7QmmG+WBAxrBRETVSuK21REM0+Rsy1KDMlQiO6pRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB1014
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dev_num field in VMBus channel structure is assigned to the first
available number when the channel is offered.

Udev or other user programs can use this value from sysfs to set proper
device names.

Set probe_type to PROBE_DEFAULT_STRATEGY, so the user has an option to
enable Async probing when needed.

Sync probing mode is still the default.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index f3f9eb8..4a2f294 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2496,7 +2496,7 @@ static int netvsc_resume(struct hv_device *dev)
 	.suspend = netvsc_suspend,
 	.resume = netvsc_resume,
 	.driver = {
-		.probe_type = PROBE_FORCE_SYNCHRONOUS,
+		.probe_type = PROBE_DEFAULT_STRATEGY,
 	},
 };
 
-- 
1.8.3.1

