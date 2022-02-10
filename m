Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460434B0ECC
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242241AbiBJNb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:31:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238351AbiBJNbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:31:25 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2068.outbound.protection.outlook.com [40.107.100.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1711DBA9
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:31:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ng9YMnG3drq8+4YeeWy3nN5Ff5z/zaksPxQaFyefHnn/8lx9bim9GyM3ZZ1GB/59KpSdxtzDVbYcRWULMtKaQdm1W4PaElcHQI5gB8ZBv65fJYBZN9uyKp3frhYod3ZEA09wjVTIkktHRJZXaGkwh4eV5c0oBgXFZVXE5b8aT+r5FfrM1vI5VPS1yuwn7MnQf19jld0msN1qBYVgwMBab9JMV1lGdji5CiZnp8B2srs21McrbwNEURlT3fnAFPkvV0wk0fACXL8hRbCUSlZlsLb8ptPfBKK1ayP9gxUIcAIgIJaxqkxrMcJ/+FTLrMqwVdFUsljrzO2SM0uG+yVW1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ope8Jv7OVZTbP9lmy+Kv1NuR6X30olwFS8cRthVwU80=;
 b=bBgiFXRXkNs5XCvli1PIzd8uWThceZ8xhjH9jviT19V5mKDqrImFHgiRf6Z6eedUZ0BX/6QlxbMXYJyvJFgH04IjfDrd8rl+tYPsOoU/h0K/UeS7AYiYgn0BO+GXKMLuenfbKZvf+etgqdeCR6gsYW3wXg0aXtwo4Q5VsDGm9F7RzLZ5LwNQ5Z43LPN27LlohDrfOcZXpF4SGvw4Y5wqeU5KNVBU/bbyvkVNeps1DJg/CbJOmhS+i2jIuYy5/VTRJXb4lZlopbr3tpL1WMQlfit3ovoxlwgmSDEfRv7yuZGlh2oZ2NiLXc//kPDvVpwZkuYdB/kU2f1rgnJsW+xVnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ope8Jv7OVZTbP9lmy+Kv1NuR6X30olwFS8cRthVwU80=;
 b=sl8d874GwLC7y2MkBh0ZbrFxWoAJWlrWmTyDVHpKqqZI9gnDxp09ITCCeJjzqcK1FXOZTA2UzBRsWnrIPH9vWCekd8X93fSltLinPSYa4egKkmF0zlHnaX22Gx4OWbcMG9hSYT9bKtzEoyJVwMhJ3vlIP0MWie+LinGvG32JwtsYd81eRyVRzoS/GHA84cGKGO/jiHJU7mltG7YGmuqds93bOLrKlpTEUlT1yAeikHiesaBKalRgcXSKvrZ0XmpqzRE7jSLNLu5Lc2yoryxEFQYNt3U4CT6+6JQt9HOSMHJ0l4t3mQLEL9bBdgLrOEdu/4e6bAGPxfQbgf4SqnJgbg==
Received: from BN0PR04CA0016.namprd04.prod.outlook.com (2603:10b6:408:ee::21)
 by BYAPR12MB3381.namprd12.prod.outlook.com (2603:10b6:a03:df::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 13:31:22 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::c1) by BN0PR04CA0016.outlook.office365.com
 (2603:10b6:408:ee::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Thu, 10 Feb 2022 13:31:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 13:31:22 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 13:31:21 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 10 Feb 2022
 05:31:21 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 10 Feb
 2022 05:31:19 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>
CC:     <jasowang@redhat.com>, <lulu@redhat.com>, <si-wei.liu@oracle.com>,
        "Eli Cohen" <elic@nvidia.com>
Subject: [PATCH v1 0/4] vdpa tool enhancements
Date:   Thu, 10 Feb 2022 15:31:11 +0200
Message-ID: <20220210133115.115967-1-elic@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f9fa6cf-e219-4ca8-1106-08d9ec99a10b
X-MS-TrafficTypeDiagnostic: BYAPR12MB3381:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB338155F684D196635BFA1A75AB2F9@BYAPR12MB3381.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vG61kpytXjBlv4sfxuuL/jkHZv3XAgoy1qwGM9QtHIZM2FEGGKPvs+jpeMEiLnI9fcVaVr9snfOVq5hMLZwU5twReOr9v39lXmKNkmAOgAF219gEXfQFTPDPzpXl7KSAHTSjcGxJqTvl7qQi7Xf70498FuP5BGF+QDm+2DPWt3y4fC+EkygpA2vYRjOGXq1y6wBGU0AY7EZ3kOsSbK5/xLKJ/EVt40GVVeeqrg/geYIbJBNUbxLF8FZkMSyaEjmraL24tCqy73gRq73SGkVbXE6vc8jIZfHpP3PgiTzpEkgzlvanAoizrGAfEacHbz4pbI0OcOrqe25aXhGuAePwCsKR1jOfuMVM504eY/g9VAcNVeHSfjIjZ2j7Y10jfELzCAR74ajl20u6sVTblxTqF+cNqKHetQrrgDqA5lE1iXnjQFFAiKlo0ZT0Pj9E6Ty980tI2U13EoJnCC7pIDNzKDAfUmIIZhX384ufrtI7273mnHKJNBe68RQ0BhKhQFZbQL5R5S40Ear2Q5slGwl5ybwF8WqlQgzdj8OAo5i3QOsVH03RsA23QCwcmUt7JD5qrAM9zz+ijv6lVOGTo4DeyleObDJrU2zsP1TKxOlUWLGHcdta4eWMAqvDL951rd4tlgdYwXzmClWLna2p9E+MEobAQVE4P7vCfjuesAyRupuCYNNcwiOF1CGzwSiZKRum3di44x9myssP1Se8kSVJhA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(81166007)(40460700003)(47076005)(107886003)(4326008)(70206006)(70586007)(8936002)(356005)(2906002)(83380400001)(508600001)(4744005)(8676002)(6666004)(7696005)(2616005)(5660300002)(36860700001)(336012)(426003)(1076003)(110136005)(316002)(186003)(82310400004)(54906003)(26005)(36756003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 13:31:22.3925
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f9fa6cf-e219-4ca8-1106-08d9ec99a10b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3381
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following four patch series enhances vdpa to show negotiated
features for a vdpa device, max features for a management device and
allows to configure max number of virtqueue pairs.

v0 -> v1:
1. Split patches to present added functionality in separate patches.
2. Remove patch 0002 and add required definitions from uapi linux
headers.
3. Print bit numbers for non net devices.

Eli Cohen (4):
  vdpa: Remove unsupported command line option
  vdpa: Allow for printing negotiated features of a device
  vdpa: Support for configuring max VQ pairs for a device
  vdpa: Support reading device features

 vdpa/include/uapi/linux/vdpa.h |   4 +
 vdpa/vdpa.c                    | 164 +++++++++++++++++++++++++++++++--
 2 files changed, 162 insertions(+), 6 deletions(-)

-- 
2.34.1

