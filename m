Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1484D9BF1
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 14:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348598AbiCONP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 09:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348590AbiCONPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 09:15:25 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350323BBF4
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 06:14:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AoDofJsTthLp3UlIyDUb+WEaM2PvZb1MzFDDbPzQxjGRDHU5T2xRrZJ8Gu+8R8Ws3XavfIV2fsGrMabHBOvx9+F+K0MxRqezGtfm7wdL9pnHQ5syFXBLghEj8E7byL45ZJsVwH5kjT8bq+hEZVA+dqgpJxaRVkvGNIWKOKL4D11S36x/sy0wBaupIHW05BZdTVNMHInCjUJdAzrQAixnKwlCTp0njmfZcU7gzI0NQQrpDrEqZ/sts5FjqiT9BwIxRos87h2Dclhmj034ArpklMWou9epUqgQ7JIzQ6BQmXE2RYeJz/qNGfoEjjaAHgV9rrAyTmSR8pc6NxpgmYDtyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=93KnFeSK91NRaSdzc6w4s6nFNanMDWu4ipJJdm3vSDw=;
 b=kd5ScCXHiENw0XCHxQpeQAyEiFzq1S1tooG0kTAplxmN50aupT8u64c7h6O3yJfhVWw5FuiKKV2t570/s2A/Y/FpyKDg+S01TCx/JDK+nvkt1o0kROfoKTGuk75mvSurhOs1LarlzcVoAwSYTIvKl6A7KrCtULcDBYH709A8zxl9r4d96JJcd4TntT1rdGULN7e+9OyD/gHZySgJr+Mx7igIixeB80TSV98vb5KBmq6NWm9zPttbSTXQQ+Z9yzRwkfNhH+ZwXFYQnivRPsQIuHLHmvgpNkKqoXaKOMcV8+dDoGtNopnAYxq7oM6BoxqpvqUqYAcLRL6VuW1nBDuZQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93KnFeSK91NRaSdzc6w4s6nFNanMDWu4ipJJdm3vSDw=;
 b=eMg3yv27rTysvP+eYFy6EGbBOptNcOgyEsnzfI8fwr0c57Q71eIe6fTj+9JJV8OxUutR+3uqtvOh+QXYHiIP5WxPdKgBDlqqaMZJTT90vqODxAFXwb6aLQXjzBHU2DoaRcS5F9bHonm9V9ckcf1efNLwcu2PNgTvI4mfWyEPCpRMWVAGkzClIlJ19ivaGDCUh6e976BjCY9+4Q5yC07FEmWz48WRFo4sPABOjr1uKTrq+kkSZnQZLccyantcd1hMzJ+lBjlZr78csBFmZVDgwvtyvZgSxz0fUtFLYnppdUaQIlOJNoCb44oZ6pPoygV8886JyyTvUwrJ28GPB0cSfA==
Received: from CO2PR05CA0007.namprd05.prod.outlook.com (2603:10b6:102:2::17)
 by CY4PR12MB1208.namprd12.prod.outlook.com (2603:10b6:903:3d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Tue, 15 Mar
 2022 13:14:10 +0000
Received: from CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:2:cafe::9d) by CO2PR05CA0007.outlook.office365.com
 (2603:10b6:102:2::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.13 via Frontend
 Transport; Tue, 15 Mar 2022 13:14:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT006.mail.protection.outlook.com (10.13.174.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Tue, 15 Mar 2022 13:14:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar
 2022 13:14:09 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 15 Mar
 2022 06:14:08 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Tue, 15 Mar
 2022 06:14:06 -0700
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>
Subject: [PATCH] vdpa: Update man page with added support to configure max vq pair
Date:   Tue, 15 Mar 2022 15:13:58 +0200
Message-ID: <20220315131358.7210-1-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0753183b-b5ca-49f2-10bf-08da0685b1b5
X-MS-TrafficTypeDiagnostic: CY4PR12MB1208:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB12083A129A4457723B1C32C6AB109@CY4PR12MB1208.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6HWQ2Kauyh5QM01n67cJV6Avc9Qc5fziLzHbR3QXEVX57kq+V0BR5PU6Dt14pIO0XmzabzybShZ3bLd3VHTgjanALs8O5wGdwY98+qp41aOgsZMtBFDJ3m+M1IE+Awy1ZoQbI02X+669m4bXtdzRWTToZWupjoQrzq0COBfgVw/9twEmDTSFmobEsH3PvKhpUJyFMI3N55pCdTYpvVrXf6d4E2r24K/ckEPj5ZwgFvx2GnT8EuumN0+dIWhS1AKpZ1p930Mu3DKo9ShvE34YWnax7whRuXPfNlf59LT2KByNtljOslm1TNifVVPB20zXCAg3kBWBKENqn9NSkBoGHLqgklyRa3pz+i+e6nu4FPOLzY36EHiaEiMWEtWYkfa3feacev9x/gOExO55KFmFNi9lamtcBY0pOrnUntN50XhPgqECJlvm0lkv7HVYRZjY9tiFhyYwFJC6r2UoJFTPOu77jx2gBYQ9XnglXuROpJn+ObSeGbhjiqGYPgV2puIheX2VnmySGNbq+BeMupzBHwN7hAR+4jmbLGDg8J43tb3FYVoqoC7xz4sddbpuDZc5h5Tew2onaFCgRRarDuc26Ub/VNjiQn2fYc+7EFTbWFyDY2MW/gtSrPFgmotxzAEp8LNVw6q8tdJt0KNRViQ4UIHenrfk79Rc1dcOiBB9sa0zBWmEZdGWWL1pL7j1TZAPunn3geNqqdJt66O8/JfTZA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(70586007)(336012)(2906002)(426003)(5660300002)(508600001)(8936002)(70206006)(36756003)(15650500001)(47076005)(7696005)(36860700001)(8676002)(2616005)(316002)(186003)(83380400001)(26005)(40460700003)(54906003)(86362001)(6666004)(107886003)(82310400004)(356005)(4326008)(81166007)(110136005)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 13:14:10.7103
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0753183b-b5ca-49f2-10bf-08da0685b1b5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1208
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update man page to include information how to configure the max
virtqueue pairs for a vdpa device when creating one.

Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 man/man8/vdpa-dev.8 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/man/man8/vdpa-dev.8 b/man/man8/vdpa-dev.8
index aa21ae3acbd8..432867c65182 100644
--- a/man/man8/vdpa-dev.8
+++ b/man/man8/vdpa-dev.8
@@ -33,6 +33,7 @@ vdpa-dev \- vdpa device configuration
 .I MGMTDEV
 .RI "[ mac " MACADDR " ]"
 .RI "[ mtu " MTU " ]"
+.RI "[ max_vqp " MAX_VQ_PAIRS " ]"
 
 .ti -8
 .B vdpa dev del
@@ -119,6 +120,11 @@ vdpa dev add name foo mgmtdev vdpa_sim_net mac 00:11:22:33:44:55 mtu 9000
 Add the vdpa device named foo on the management device vdpa_sim_net with mac address of 00:11:22:33:44:55 and mtu of 9000 bytes.
 .RE
 .PP
+vdpa dev add name foo mgmtdev auxiliary/mlx5_core.sf.1 mac 00:11:22:33:44:55 max_vqp 8
+.RS 4
+Add the vdpa device named foo on the management device auxiliary/mlx5_core.sf.1 with mac address of 00:11:22:33:44:55 and max 8 virtqueue pairs
+.RE
+.PP
 vdpa dev del foo
 .RS 4
 Delete the vdpa device named foo which was previously created.
-- 
2.35.1

