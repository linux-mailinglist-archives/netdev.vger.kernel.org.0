Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9976EACCD
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbjDUOZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbjDUOZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:25:53 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B51119B2
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:25:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBzciMK25b6F0fG4DhEsZDjXdmPa+8k11DZ3EYji1dwWnrqsyY6HCKEDfSBzKGBgjw6mT1MSNjBImVD7Uwl+9R387eYmKnZ74gSHZLLsPURECv0UNHxRK/z4o9/xXLiJ95VILNZFw2HQBODKxxK9W8N56pprleMqCQXHaDANRJn/M383MEnNUOr2BHd7VXiaSGHvj79RqrisIEoFopNMiKIlOxgtiX5mrz9mymx5JRPJRAItQyWP/NeklmRvYLWgqT7H1ptwMDRnNIAXOKWKs545rYlqegxw28P8MsSMrMlFam9YjwIJaOBgrC7IZdkw8CmrU2qseCJ3l7rzXcPPrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KgKTmdqaYS1zNMw9b7RMjvvKcVyCIoC7J3gVbu7Bu2c=;
 b=NFuPBjPPahB+3xl8OBhHAy4/4hhOVlGhcMh6koZinQYAIideAk+NzDendh0gXseys7V8siGhVO0uJlKAR6rFOb5zW5XJOxHnYoA0albDakaAU2bc0NE7GqrZcsfGFtUxPK1leGl+H1VTe9PwQbBFzUm1+Spd8UoNj45PVuhFPaG5KPWKYdvMsFAcT2yjgItsIrxno15/eS7zWUVwFV4FSAQj+xO2IhcdHoKkZgApgSmcoyTImL4pJhVFfiaH51qnG1WHWE9J7pSZKZT7wnN1rogjYZ8maUs+CfAgBAis28ZXbyOGCaKo3A1BiA0ywGUsvzOdgCCtcGEZXlpPfuOC8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KgKTmdqaYS1zNMw9b7RMjvvKcVyCIoC7J3gVbu7Bu2c=;
 b=N2py9yKMwJp4077ZhUY4ALQ3AeXKcALtcTrJH2cc36Bhr4iLG1CmJCZozHfC2vA8N+6CKGykYutxWDLDQ0qoFEACmkXSmDnTsdVoauabRBwW/1+/bT/GgEt/4TTvkIHtII7gpVwTdpLYCANj1n9L57oRdeXL6co0vBVKYa+ZDn795Lsz5BBSm97hz4Gh5e5wH6S6+ILEaNe9xceIfv81CyPkbIqT/PEPIyxzwXGlgL94bzh86TEzuXh7VZa6I2sKKr07jJLEtNMnekjSC9/2ihsbqpU1rvdGUG4BB/EAsC0nCrfk3zml6VvgUGShQaVRAFijBoZ0mXytpF7HWoAzMg==
Received: from BN9PR03CA0865.namprd03.prod.outlook.com (2603:10b6:408:13d::30)
 by SJ0PR12MB6966.namprd12.prod.outlook.com (2603:10b6:a03:449::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Fri, 21 Apr
 2023 14:25:48 +0000
Received: from BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::4) by BN9PR03CA0865.outlook.office365.com
 (2603:10b6:408:13d::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.25 via Frontend
 Transport; Fri, 21 Apr 2023 14:25:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT014.mail.protection.outlook.com (10.13.177.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.27 via Frontend Transport; Fri, 21 Apr 2023 14:25:47 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 21 Apr 2023
 07:25:44 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 21 Apr 2023 07:25:43 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Fri, 21 Apr 2023 07:25:41 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH iproute2-next V2 0/3] devlink: Add port function attributes
Date:   Fri, 21 Apr 2023 17:25:03 +0300
Message-ID: <20230421142506.1063114-1-dchumak@nvidia.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT014:EE_|SJ0PR12MB6966:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d25078d-f67a-41e6-f722-08db42744ce6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /yuOmgI8w1ClnF7vBj3MzMmzhd4RDsh5Ml2+fyvoODj31I13qrisvkMiAbdDO+Q4FdZjXw+pWreYwRwGZywEwpnwFBZHb+uEXy7XVdFH3zte26R5vy9fU7AZVnO0dLtokGSxQcdCf+uqhyz3mDjkIYmsODf6wZpFw0aTASJFBmhMcNy+D1/6CWCpxO5y2/AxUJMEljLm3UOc4nfGnczbHKYcnT9VsHj9TPIAE7BHmJTUV8zsNFCJVW8dDE6iHD5CRTayIN6kksa1j3TLqSoLdbn5sJgsmOLzgaynOzeC2kMzvcRGWpIxdYprfFwgXhNXckdxy3LsVHnE7Vsoz2spdcHr9ufY3Dg5Q4NS0RWZTPOJ1z/qf7kEu9H11954KxXa8IOgc/Cwn14rmANLxmW7FV2VQqWsG/JVg7bR/XzxQ5wMWYVcsTpncXV2iZQwYnSIH+J47HxzY8Q26aw2fhUqCrBEQNP99618EUM5P9UtTAESs65rIoPMeZHwa6o86Z5VZavkFy+Y2y+GJ7gLmaIJN+uzs4MhCul0xvimBWO1uqA+bkAnyOw8JBDv87X20AY/y72ZwCcgiInYMi3iUTNElG/xE4/JHgCCwpLlVh13CahBCUP3qIt1jfSeLMNfKcZhF4xIuXNyiulC2h+h8EiGyMWUPk6HbH8i3ECAVXfM1QToStoaowlG456kWccshxniM8lCEg49UUIN2YqXnbb+JxH5MWdlbnnb29FaexUgHtG8v9sQp51WbdRu9k1iejpm8ejuz38XM5RK+/MS3Gdt9AZyP3zcQQehNY155QPAXqc=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199021)(40470700004)(36840700001)(46966006)(2616005)(82310400005)(82740400003)(7636003)(26005)(40460700003)(1076003)(356005)(70206006)(478600001)(70586007)(4326008)(36756003)(316002)(86362001)(41300700001)(6666004)(54906003)(7696005)(110136005)(47076005)(426003)(83380400001)(36860700001)(40480700001)(336012)(107886003)(8676002)(2906002)(8936002)(5660300002)(186003)(4744005)(34020700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 14:25:47.5026
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d25078d-f67a-41e6-f722-08db42744ce6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6966
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please, see kernel series of the same subject for the overview of these
changes.

---
v1 -> v2:
 - updated cover letter, no other changes in devlink user-space patches

Dima Chumak (3):
  Update kernel headers
  devlink: Support setting port function ipsec_crypto cap
  devlink: Support setting port function ipsec_packet cap

 devlink/devlink.c            | 34 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/devlink.h |  4 ++++
 man/man8/devlink-port.8      | 26 ++++++++++++++++++++++++++
 3 files changed, 64 insertions(+)

-- 
2.40.0

