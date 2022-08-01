Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3FE758680C
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 13:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiHALZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 07:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiHALZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 07:25:07 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE462D1F9
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 04:25:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hip0cYxcMN46hFt6fyK6T4L8xGPVzrGvY0n2UxE1Qyf4O23ITqSyArxUUpn6s769UPi/Uo/02JVOJ+kjuCKTVhW9qs3MRzcWJ7vQ8O+8pfejlAp4GDoEKeU9T+xOSsgvEiDTtHYs7u06J1aV7tjYg0ZOgtKsRqRVYmmSIxz/mb4t4bw1YGzN97Pqe8ZhARv5Nrv1YjAedBjY4gUks5GNOtE3JPHhrUMxLw82dHI7Jzo4Unsq3Q9FY03Cm0j68npspjcDxEZ1m+sdb8RJaV4PxRhky/drEjr17ePDhMtZ6ErVg7cJMZm1Ex3LDenJWx23ssD1AaxeDOJ/DWINKZFfGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VBnBStQax9S+wNwnjased5OxhV4yNKVM8NIYvK1/MRo=;
 b=RLpxMARHnb1TcX7XiAcnRpg2USqbEBU3Y4X2DiwVOYPxYHPEHBAGTaCCGwphNaaZqWroNtumUVPyUEWEYrT/kknqG1WKrK5PyKtPgBJSE58sr2f+ym0229Dfng5y8CjyHNQBXwIw39EAneNM2wGSyx7Xfql8dkNN6Mu6RpyvfqKf77XYhOLFRXXfXoLq2JkGiMXr08lJPxJ4Y8u25mT0bgsySTg98yfXwsBsuyyS3R2wVlxwjnlPPlPmF5p35NFpqoi3+eIRk6g1eukiGxFJDkfSARrwC1nrVX7EpJVmPa4jgBqwEU8M8M8F1yDrayfvUDJCsVv0EU0D2FIEfR9HBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBnBStQax9S+wNwnjased5OxhV4yNKVM8NIYvK1/MRo=;
 b=lNaMgnWKYSOmgd4IZTp4V5xj650VASQfHuwIoJm7qBQkWKDsynh2ng0CWC2MjxhEbDAqCQ+7RsKpUMzBlp+Os526VNfqaP8QQgPKM/ZGig7dcQWLxrVDi93fn6Ys0ctQZf4bEVGlkVxMvaosI43FIpZcG72I1LEmv6oQ7YeBI5UULl/6TqobhGS3lSnxn0znF+rBGMaWfAk84dvSUSbaya8pJG5PxCWsQ6IfkI9UT2MLlUUhVnjPrgLBtLBethNZ6gfrAaCaFT3r2qyO28b/gSh6EdiSRTFATiQH0FxaaSQVwD7HuvWvHvGwPyvLEJpHGjbmKTq3m2DGEA4Kv7fZhw==
Received: from DM6PR11CA0062.namprd11.prod.outlook.com (2603:10b6:5:14c::39)
 by PH7PR12MB6786.namprd12.prod.outlook.com (2603:10b6:510:1ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 1 Aug
 2022 11:25:04 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::29) by DM6PR11CA0062.outlook.office365.com
 (2603:10b6:5:14c::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24 via Frontend
 Transport; Mon, 1 Aug 2022 11:25:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Mon, 1 Aug 2022 11:25:04 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 1 Aug 2022 11:25:03 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 1 Aug 2022 04:25:02 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Mon, 1 Aug 2022 04:24:59 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next] net/tls: Remove redundant workqueue flush before destroy
Date:   Mon, 1 Aug 2022 14:24:44 +0300
Message-ID: <20220801112444.26175-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 412f48f6-5e25-44c9-476e-08da73b07afe
X-MS-TrafficTypeDiagnostic: PH7PR12MB6786:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pSj9IMdq5+TECXTvEYyqtNVoDJ3MwdGXsb3rmcD3NvgxpUo9AmKTfJrDPGaix6sUOE1iRPkCyHwEx9HjW22DjfyEAlKASzxLI4f+cZ7XQg6o+PovsiPmBJZJhjCqXeeAqJQZJb+lSBSUeNiCH+Ji1w6IfyEDryy1rYf7t/NIesG/lrUHwf390cfH+YwUgkWzkk7ATDXi5123JXjfKHh4saP0OeUUQ6ebACXSKapbCrf+4KswHVovthzNWBo1HE7gVZZN9YADcHl+02r8PYosemI/0r2wBVNYjDOzdgusrgkoyopdPJQ59Zz+niGCyq/5oID8VYmbncyYsKf1wZ1cc0+jb3YnPR2phdtZDNV98WBBgJTifrdvThKAVuUe7leIVwr05SntjYiDSD1OjLR0I4E/XNHmcOaZcr2pryroOxahyEdFMUZg1UGXKnbAUJ+t0LsXChACW2Tf3UadNdoasgsjzEpCMkR/oiQtoJPREMI9NunYZ8oOcGHpu4vgUAXlg5DSRab3y0CuaW5V/GowbbHLNg2N9cnD0fyV4rdJsqGFrTcdV87JJsbklg1Z5KmC9x0O6OlmR3K/RaV6JRiuWlosNYznUoKgbFJb7fUiTydSchY6btXCo0uchxOBmCHgpRL4an8RIWKCjNCy5CXouYmmoGtVf3e08lCT8VO/l+lxvZaOWgKwE8XeIgrxPSbU8WYNBx0HlFNijwusPx5/k16OAq/6QXi+RdUJKTKu5XF17OWVe43XoBwt/5n9ObGRXtzAc/28c+ri6piAmLmIIxOvkL/Qp7rU3CC7qVSDtbRZLT8jI/7O4atvftQH5cbwZE3vo0BvyaEKM1E2pQPgYg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(136003)(39860400002)(346002)(46966006)(36840700001)(40470700004)(36756003)(8936002)(4326008)(316002)(107886003)(86362001)(82740400003)(5660300002)(1076003)(82310400005)(54906003)(356005)(26005)(70206006)(2616005)(36860700001)(8676002)(81166007)(6666004)(186003)(40460700003)(7696005)(40480700001)(41300700001)(70586007)(83380400001)(4744005)(110136005)(426003)(336012)(47076005)(478600001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 11:25:04.0175
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 412f48f6-5e25-44c9-476e-08da73b07afe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6786
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

destroy_workqueue() safely destroys the workqueue after draining it.
No need for the explicit call to flush_workqueue(). Remove it.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/tls/tls_device.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 18c7e5c6d228..e3e6cf75aa03 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1449,7 +1449,6 @@ int __init tls_device_init(void)
 void __exit tls_device_cleanup(void)
 {
 	unregister_netdevice_notifier(&tls_dev_notifier);
-	flush_workqueue(destruct_wq);
 	destroy_workqueue(destruct_wq);
 	clean_acked_data_flush();
 }
-- 
2.21.3

