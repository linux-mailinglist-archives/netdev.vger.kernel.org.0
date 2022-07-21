Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C9657C406
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 08:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbiGUGBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 02:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiGUGBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 02:01:17 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2044.outbound.protection.outlook.com [40.107.100.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FE824F1D
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 23:01:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWJjCInvUWeCOdtvj/OVRCm+BHHUSka003VmSemYnyMlVK2AHRqEkl7CmerA/z6RhR9nC+CYBkfoUX0AAWKeQwn4IfTHAfLy0cWROpeajDN8UILmtfq05xdf+x+UPjZ7S5FNjuTl0iyYMjy0UqpAfqsVhoNWKZ/Ud9jlrKmyIWVGPn6yJAoBZ7M5hXTMmn1ckneL1Sp/XyoPWhpgNrCRtpn5aVIjHkL8YHyrp1fTm8yeG7s8Np8c+uAe3fANBeIoGWV1DjoUQPAwnuDcE5+jnoZshRtDfiiDy2BW1mEXVYs6nRjCuZ88EiCaVN6SfZ76R+qjlarAy859tf7xcV8U1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hoUDM1QwYRmKBhClZqnc/dhU4gXOYxGJL687/Se+XIQ=;
 b=H/bLYchV2Tse+zoVpx42nTHE+7eqwOpUcWn1WIiUvE0Y6wRm1zCalP3g6gNiRMFWFiLsiotmYTeHAPRlsOzhvWG0ZDZWWvD95syjjZmf6kaLzL6rLT6ccQkiF5B76IYq40s+Ns9wt38k6p6sv/EuBZ0tEPWpj2tPzxlLjaO1GHGlBxweSmw4eL4BGcpKSWih9NqTSDeQuBKm9mxM5zfD2GLVAw3VmJVwpgGY8w75e9a8/9ocS+/Qy064NpWDFEjmx9WXOGDIYXaQQ+3ry3NFuTegjOoMRxomiQ69eKZu4+D9GjfWUlmhCApaXrMjbJriyWRURY2hgQ4STphmAowbwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hoUDM1QwYRmKBhClZqnc/dhU4gXOYxGJL687/Se+XIQ=;
 b=AUAJbaM5tgihp3IC4JygvzECNlh44ohEwoElG/tI+1wypJbH4Y7EvgJB7+I1ksJw/eCJw0xN1k7yfnQ6wMZDJF9H/xr6BIya4mHA3n5a9UGhO9uPX7AC4/cKIVknPjGzoG02lzolUlGlfegT6B3qI1AIVH6BfyemkCEsmyZyukDFUXV/Fn9e9noHVmw0D9aLslxP93/6rsJeto0HTOMLjuG4iLja1fxN8svBjTyg8+UTMNhmAdcw6qyo5XA2O+IzOHXInSWT4ysMwIe2K8zXHoRLSq3a5Eb6+h3dluvKrJ75j7bjlauI+Tj+KOP0Mqav+7QGuTs+GoB9LNCbAbB8mg==
Received: from MW4PR03CA0235.namprd03.prod.outlook.com (2603:10b6:303:b9::30)
 by CY4PR1201MB2550.namprd12.prod.outlook.com (2603:10b6:903:ce::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Thu, 21 Jul
 2022 06:01:13 +0000
Received: from CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::d6) by MW4PR03CA0235.outlook.office365.com
 (2603:10b6:303:b9::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.22 via Frontend
 Transport; Thu, 21 Jul 2022 06:01:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT024.mail.protection.outlook.com (10.13.174.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Thu, 21 Jul 2022 06:01:13 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 21 Jul 2022 06:00:16 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 20 Jul 2022 23:00:16 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 20 Jul 2022 23:00:13 -0700
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>
CC:     <si-wei.liu@oracle.com>, <mst@redhat.com>, <eperezma@redhat.com>,
        "Eli Cohen" <elic@nvidia.com>
Subject: [PATCH] vdpa: Update man page to include vdpa statistics
Date:   Thu, 21 Jul 2022 09:00:07 +0300
Message-ID: <20220721060007.32250-1-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73011b29-0148-4945-b8a2-08da6ade6afd
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2550:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zd/B13RHrwXafrjuruALSTzvLfCKZcHa5JXQ3NOpv0ohPzU5Iy51pbPAhTEQcD81kVn/EwCQKdTALH3kEksv7Vte2eFW/VWARzVcbAO2kkuQfivvDRay3vzn8bxu7YfFWbqHJqN40+8hi27hpUl09nb83yIP+MT8GUaQUalYfZiaMTxv1C0ncPe8n7HM3WCyfcqIMnWWvVvk0S0pmW2Aj5QCiO5LKRc5VRqUOnZiv9rULDVOZW3kV7SS1B4LXIZeC2s3BxI7sUvK+4yBR23g2sjwCrj5qXHjIC3SLwGRtfGSHUmrSxpQsubu3DstUM3W9Tqm7GiM3fVCBIFx6LAdhjcdWpBjgbBh5stYoJr2W3FZ/WFEsmx/EXJUesTb4LRy1OKza0rDJsr9AC39OwI4T+DyjDUlo6VhmL+CCH/LuklOWI28ysmqWZ40VZO6GKoFpDKNu8uuxH+8/MBS6iSMEvuw9StlXVpUUMxRVQLJ4X+/mWqf7VU7iZSzmlRuqv94CwZzLndpnf52dRtFPw1aZEz2FTVj23MBwSn3sTY2IRqoC9mqy06sXiooNWX1ArSjMcxdjqZYa2GOnANCv5XVC/zGwR9NjRFiRGjZ4vTAcOOCBXd910F54RlUo6EHW+JZtCUsxOXyhkYJPKF3MgMB9MOmPAu8z1/7PEYa5UhkpYy3FbOEMdjobnJcutU2sxyjpRWnU5Eb8wbfNILFqoRIP0HIxQRIFsN6ZpP2gcEoj+R9dg3rqsIrv5zrM/Bw8G/euXxi7c6xXRj7vSN5l5LUlJ49n6JazEGs8WofENenLsVeBROUvdMh1OD9Ws7f1+iCPjrmPq9Im4soptuvXi/ikQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(136003)(376002)(40470700004)(46966006)(36840700001)(4326008)(86362001)(8936002)(8676002)(47076005)(70206006)(5660300002)(316002)(70586007)(7696005)(356005)(40460700003)(15650500001)(36756003)(54906003)(426003)(26005)(41300700001)(1076003)(107886003)(186003)(82740400003)(2616005)(6666004)(110136005)(478600001)(81166007)(36860700001)(336012)(40480700001)(2906002)(82310400005)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 06:01:13.5549
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73011b29-0148-4945-b8a2-08da6ade6afd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2550
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the man page to include vdpa statistics information inroduce in
6f97e9c9337b ("vdpa: Add support for reading vdpa device statistics")

Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 man/man8/vdpa-dev.8 | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/man/man8/vdpa-dev.8 b/man/man8/vdpa-dev.8
index 432867c65182..9faf38387e53 100644
--- a/man/man8/vdpa-dev.8
+++ b/man/man8/vdpa-dev.8
@@ -43,6 +43,13 @@ vdpa-dev \- vdpa device configuration
 .B vdpa dev config show
 .RI "[ " DEV " ]"
 
+.ti -8
+.B vdpa dev vstats show
+.I DEV
+.B qidx
+.I QUEUE_INDEX
+
+
 .SH "DESCRIPTION"
 .SS vdpa dev show - display vdpa device attributes
 
@@ -93,6 +100,16 @@ Format is:
 .in +2
 VDPA_DEVICE_NAME
 
+.SS vdpa dev vstats show - shows vendor specific statistics for the given device and virtqueue index. The information is presented as name-value pairs where name is the name of the field and value is a numeric value for it.
+
+.TP
+.BI "DEV"
+- specifies the vdpa device to query
+
+.TP
+.BI qidx " QUEUE_INDEX"
+- specifies the virtqueue index to query
+
 .SH "EXAMPLES"
 .PP
 vdpa dev show
@@ -134,6 +151,11 @@ vdpa dev config show foo
 .RS 4
 Shows the vdpa device configuration of device named foo.
 .RE
+.PP
+vdpa dev vstats show vdpa0 qidx 1
+.RS 4
+Shows vendor specific statistics information for vdpa device vdpa0 and virtqueue index 1
+.RE
 
 .SH SEE ALSO
 .BR vdpa (8),
-- 
2.35.1

