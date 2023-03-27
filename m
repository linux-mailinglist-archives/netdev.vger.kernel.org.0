Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2066CA211
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 13:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbjC0LGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 07:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjC0LGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 07:06:18 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2087.outbound.protection.outlook.com [40.107.243.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A024207;
        Mon, 27 Mar 2023 04:06:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mte0KA7sRqnUfO3nicaw6aHsRIU8cuCiHDUWxswZi/OF6lPA1YNxKfLvHx+ob6IFfisUnFpKNwCBzzm2XTfoLj+WvC5UJG7Vk5dmiqvBZ2DulBtv6mA5Qxhy0iI0zm4M5O55Hy+M6hjOg0FxBffsoFgj/OwRMDYenvoUfKBIaLBRDrT6e+uwqyHIydF4lklapYZ3ASpgaZK2Dg7SnO/dMSZRjDxEMLPVtoUi/Kiq/QNNk90FWZJ8FF0MHrr8w+DtwvputUgGp+5yzQyOFPk4PjekT5nqPlkK5D1AotPc/Z/pkS2iOZYW6shCjBsfjujP4/GfUN5uQuZpeOjmZ4QZvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UL2cpmjnZhOw8J/La3QeHCLsUyESMwjJMJxT3ugCkj0=;
 b=A1BwFQDFt2P3E1y+s2dF+LXL1lBx0CLL7JL+eqBhPSlwrzegFtSUmm34vKNDq/mcHD58P2fLn5cBiTqu/UPC2WGPPomo6kDUp2iBIp3Q8W45EpYNGimJTlf/CHFcyVezNtYkJnO574mSytxLT9klCP62/O86pdC6+ktNZegr/LhzAgWBIFI1iDsj7v2JOrsONidc6p1S9Bf4Bi7Zi2fll3nyKBWaWiEUViL1YRxqp3q1YcLKf6Hf9f4u5zEKPmly9Nw8fsep/xsgEOIe2iyr/cljiI1tnmKOWQ7WfU58X7bGArfEoicC7CfxQ8D+tk7Dr05ULn8jxS9HR98VMk4e7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UL2cpmjnZhOw8J/La3QeHCLsUyESMwjJMJxT3ugCkj0=;
 b=QrOCVFuUmVHI7j38vriSU3w2MjCO0g7MDAF8AjWQsNEzIqt/pIFFr9SSSS2TnyHegORsz3AA0c/DIzQWhwKzXQouFC9utpbjBxEj3D8b9dPjsDnckknV2jcPmmGLOJGHO+G+QfTe1Ad1BOT1DetIXmsyC2NlmkWMdwCdkdfqYus=
Received: from BN8PR07CA0022.namprd07.prod.outlook.com (2603:10b6:408:ac::35)
 by SJ0PR12MB8165.namprd12.prod.outlook.com (2603:10b6:a03:4e4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 11:06:13 +0000
Received: from BN8NAM11FT106.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::81) by BN8PR07CA0022.outlook.office365.com
 (2603:10b6:408:ac::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.42 via Frontend
 Transport; Mon, 27 Mar 2023 11:06:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT106.mail.protection.outlook.com (10.13.177.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Mon, 27 Mar 2023 11:06:12 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 06:06:12 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 06:06:11 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Mon, 27 Mar 2023 06:06:08 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@amd.com>
Subject: [PATCH net-next v3 0/3] Macb PTP minor updates
Date:   Mon, 27 Mar 2023 16:36:04 +0530
Message-ID: <20230327110607.21964-1-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT106:EE_|SJ0PR12MB8165:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e34424f-ac4e-4fa6-aa4d-08db2eb34712
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FC4zqERGUkyzFYbEtZ8vOp36+XzZkdMRFv+1AOhWzSeN0/1kQIRdW7Sg3foa+m8+Dh4QKxyfgeRBU08r5RxAK/w6uo5QjC8CQKISaudrugkCBPAmYeuYDlSQ/hxLUzeHn0sr0F/j4oc7U4wcjJHlr41Ad/H1A7BvIV8uveLfjNKgkxVufyksZU5YixntU5/snzwn5hCxO10KCLwgf74JmMdBdrvuVZSV82jspMZ1trs7X//BFJxCnpP4Pcm+IxH3fZJVMUL1QQXDQwyoT2+2s+gQVWvvWwYSFaiyiAV4jK2Y8UM+WMY6vecG5CQtu+AKpctZPryXgXJp5XsOFhMFuLvwgk5nXe8N4n5xsPOKevPt+nOflJQmYf1Gbs5XCQhEtg9RZvuIz6ajSmSZwfyd4CNpVd3dFPP9JabCR11eBIDhrXlhIfUExaiMvCEzSeJxb97LhWHoyyCNivOI+WEVnWMIw87+wc84VG3w3cmgpjGj397bUDiljSCZlDRSmZQSRzBKuZaxVLh1ZvOLf10PH4W/f2B2PAdhKk3cg9Rg8opUtLFsXxdAssc2oFQgPo/TvyXUxexpI7hO7pohQGqMensLs8zzuxVkTFYOGAI4YPOuPF3rIo+H1Y2BwjoTTZqCm5/dXx0hMabspMIS6bTZPZVaye+UncM7D6LIvuUx/RdTUV26uYqWCUyXaX7b7nzpCltFi36S4D+ZzUhibnxAM0wfOflxTwP03PPB6NVrozc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199021)(40470700004)(46966006)(36840700001)(356005)(40480700001)(36756003)(40460700003)(86362001)(82310400005)(70586007)(70206006)(8676002)(186003)(316002)(336012)(8936002)(4744005)(7416002)(5660300002)(2616005)(41300700001)(6666004)(478600001)(54906003)(26005)(110136005)(1076003)(4326008)(36860700001)(15650500001)(426003)(47076005)(44832011)(81166007)(2906002)(82740400003)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 11:06:12.4799
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e34424f-ac4e-4fa6-aa4d-08db2eb34712
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT106.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8165
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Enable PTP unicast
- Optimize HW timestamp reading

v3:
Add patch to move CONFIG_MACB_USE_HWTSTAMP check into gem_has_ptp

v2:
- Handle unicast setting with one register R/W operation
- Update HW timestamp logic to remove sec_rollover variable
- Removed Richard Cochran's ACK as patch 2/2 changed

Harini Katakam (3):
  net: macb: Update gem PTP support check
  net: macb: Enable PTP unicast
  net: macb: Optimize reading HW timestamp

 drivers/net/ethernet/cadence/macb.h      |  6 +++++-
 drivers/net/ethernet/cadence/macb_main.c | 15 +++++++++++----
 drivers/net/ethernet/cadence/macb_ptp.c  |  4 ++--
 3 files changed, 18 insertions(+), 7 deletions(-)

-- 
2.17.1

