Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2549F4C9E09
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 07:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236778AbiCBG4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 01:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbiCBG4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 01:56:12 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED15AB16D5
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 22:55:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUBVazZbUOLz849UsZzh4U1RqL98bNKbY50VM/zP3UhfSPPppNRIsRazg7gU8p43IImwNHH9XimLyNlF/BK5kRXYZs3kzetXaITwKr5IpnGM7+WAHqqD8yKerq02tplCL/N/NcPe822ex3L3D13tRCgEMgDAwS2JRucT0Sc3HUrgqvh+5RLu5wtALH/aOg9a8xaz+qZ4Becfj8YyzzSdR3kjsqX3LlKSKku35r8K4oWg9gnJ/naYm9unSHfL9VoNShq8EJQcTjnsajhJAthhEwTHEzEE2mL7Zxtkr78LvabMu9RoyvGgHgI1aWnIGtRASxKO3UrIWoa3STsqwMM8ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PFJe/PimfD35wDidVBMkgRIHJDtZ1v7DniB9KINf0y8=;
 b=B4KgKHW+6HXGPO9CfYAqhBP/WL33a33EnEcvnI7h15DVMNZlqQ/Ztvf7ff/bmpoDPIErKaXGn334H7i+1N9bDU2i+j7MxNCgxCpXz1jDX6tENcyWRbD9qEJ4sy5WKW3nGCXQ+a1aQYYM1bCKHUfg/4i7HHSYkil5iD3+PI2U1w7N5DlNtJsTbagVoRGrrgRPJAuSNAHQLDln9z47UM+e9Q1aOzlDXAiX0Pn4PyMKGLXnacwaIANU9frVTIQ37StxoTAgBuYNC0ZHhcO3pYKJxQIvd1x0IIyHk4NpU8085zxEqbRvtT+rqpfooY0f3l1PlqbQbN6QKIvzpH6a4LRgXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFJe/PimfD35wDidVBMkgRIHJDtZ1v7DniB9KINf0y8=;
 b=c3/HcI6MFQsytIR+/fSUNcWACzOfJDbH+MvKWpzSVStdMOLCO8/0cS76T2KGkyUAgA/D7sF/yqeGbdXdxbQUXwiws4niSbpaM56I8xMaTPDx1A5VOmDv4kW0EmQYuCPB571CfNVl905s/ZCKyPxyOyy/7g3shV3b2erT5w/YOj6TPvOZAjmp/JcAliK+MzjthntS+7vPUtV2E23QewKrLOGxcrYit2fgJu0grSXlhkd2VQawZ37J0qgs1JP1QT+0bjTmlBP352UERX4fNjGVIf/AhOfh4M9kCoeFRJz0qbCUU0YzFQp75EWxumSR80tdQgbAabfUML/sKTG2Rygz4A==
Received: from DS7PR06CA0025.namprd06.prod.outlook.com (2603:10b6:8:54::31) by
 DM5PR12MB2535.namprd12.prod.outlook.com (2603:10b6:4:b5::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.24; Wed, 2 Mar 2022 06:55:27 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::f6) by DS7PR06CA0025.outlook.office365.com
 (2603:10b6:8:54::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Wed, 2 Mar 2022 06:55:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Wed, 2 Mar 2022 06:55:27 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 2 Mar
 2022 06:55:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 1 Mar 2022
 22:55:25 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 1 Mar
 2022 22:55:23 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
CC:     <jasowang@redhat.com>, <mst@redhat.com>, <lulu@redhat.com>,
        <si-wei.liu@oracle.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>
Subject: [PATCH v4 0/4] vdpa tool enhancements
Date:   Wed, 2 Mar 2022 08:54:40 +0200
Message-ID: <20220302065444.138615-1-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c145044a-3d88-4a9d-c528-08d9fc19a213
X-MS-TrafficTypeDiagnostic: DM5PR12MB2535:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB2535C9716A63016770D514BBAB039@DM5PR12MB2535.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hUwrsV0vI8ccCtndyBNlzmHX1HyH4FqJlCAMdGSnqqoNsVKTM2jHQRg3ACL0G0nwOaVHgg11K+E5/kVBXjjzu4hHapNzvUhVxzuJQ6mb+u5gC3hkS6XtdpSFYTT7pEx4zcsh0/gunAHSC4F4kh/zCqY7KutEgMsixViRN25+UBYqDNmoMtcc0Xxvc/eVfcUbwifJZShSjXF+x6+wmfwCRpKFRLDFWlhNALOeICaIO1bdmJGzdHQoCAyBEyVt1IMeLmzKxh7dicJueDpb/O26tleBDc7R3WbCEHbTgCjJO3hZLe3YiFbdvGOUIKfUdDRlNZ+KXjxJ1N3DAstLbllpe5AEKzrAa5nZM2geC/uPnTA5Ic1ZlqQOrfXVv22AN4K2djJ0OzKehed6VRuUduc42V0q/k4DFcQhbIB3TgQMO3C5sbd4nlIU9PrmtpWDyfnsVekvrsB+D3t9/3ijaPH1DsNyI2nUt6AGFUyPQABUUPZ8SAkA7BtjI2n9Tm552QTLC1e/vYMoHSYuBEOsF8LgKWg+1eMTDmf0WV5WxJMWRbkwrf8YtZk/dSler9NkeR732HzpBWw+haUrj4HQCYy7v68kaIiVGto/Fi3zb7CNUeWQ4JkOU8Q1Mg2fLJXjIsUBRptJFIZGJvGF/5VP4oWSAglLSYF5Fepizsag3lm7KNTCVkxQNgAt22dz3fICuXTtXjQOwKrPDo5ES3+CrKgi3g==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(5660300002)(7696005)(2906002)(4326008)(356005)(8676002)(70586007)(70206006)(36756003)(4744005)(8936002)(81166007)(40460700003)(36860700001)(26005)(316002)(107886003)(82310400004)(508600001)(110136005)(54906003)(186003)(47076005)(6666004)(86362001)(2616005)(336012)(1076003)(426003)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 06:55:27.1972
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c145044a-3d88-4a9d-c528-08d9fc19a213
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2535
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

this is a resend of v3 which omitted you and netdev from the recepient
list. I added a few "acked-by" and called it v4.

The following four patch series enhances vdpa to show negotiated
features for a vdpa device, max features for a management device and
allows to configure max number of virtqueue pairs.

v3->v4:
Resend the patches with added "Acked-by" to the right mailing list.

Eli Cohen (4):
  vdpa: Remove unsupported command line option
  vdpa: Allow for printing negotiated features of a device
  vdpa: Support for configuring max VQ pairs for a device
  vdpa: Support reading device features

 vdpa/include/uapi/linux/vdpa.h |   4 +
 vdpa/vdpa.c                    | 151 +++++++++++++++++++++++++++++++--
 2 files changed, 148 insertions(+), 7 deletions(-)

-- 
2.35.1

