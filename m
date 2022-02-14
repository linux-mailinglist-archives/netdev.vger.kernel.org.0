Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C814B3EFA
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 02:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbiBNBpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 20:45:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiBNBpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 20:45:23 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27836527F9
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 17:45:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBs60IU6GusuZKKUcCUY51qZXANamrm/oZTN9J8ug0SJSUqhRe+iZaPvDxZEcGB+sC+gjdV4fQ3XwC6mxHAx8lnBd83fnYZm83/FUnubqVT2BeAdyY81Em6IYECPlWz10lNRhqFbE4EdwwmzKZ8ctBjv6TS6n2V5j9Brqhd/LGLfBJPGm4aYzKBMN6gGBgu/IG+3RdooOuGwiwmJ2EqM6s8gblYhXJdSnKK6ssdndHt1V4P8PUsBNTxlLAF65Uv/uCBLEpPduecsMZfpVX53rAXBKISOxEXyVFKrp5947UdA7FCLlvjAhy8ONTONcN2J8jx60CKsbekKswx4QD0uJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6XJ7eSDQ7G28L1X7Drdo7efAVRiIdwk6icsEjJYYRE=;
 b=MFkt4G3Cj7PW37DS7BePi2UueB5371Fn4o7lJ975ePQXN6wdSDev0tFLPDfOGBrHBKDRdn6R+YO/zWRxK7vMnr1uf+0mg7Z6obCkZbMvBPVOMvKhrtr4wWzApgtj4k7sU4NI5kSeKc7a3ZNiHYplruLNtEmDoByAU/95IKZe3YMauKi0+wJZug43QDPUmVQNd7gecFbfporbACO/bwfFqyMRPS60Px2IUn3WL7Nrw9Ek5Y4pg5YyAWuGOwM4PD1uvJdxe1F34I/HH/mvJxjrvlgo+6ha2KPzc2fT9CtanNyqgLvDqyi3NF8S0zBktHd6XUlum8G39K4N32t3BcPxhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6XJ7eSDQ7G28L1X7Drdo7efAVRiIdwk6icsEjJYYRE=;
 b=rB5tG6DTDRO6pUJ20olpbsROh90zZ3SyPD+YcCv1nwmIm4Ana5Npj/v4vOAK5ogwzsxQsA52Qra4ywvZ70Izq2BvLVfcvhd1a9dWhL7IcH0PqPQ671bbgQaDm9NhjdC2XpsWdxfkaQKl4sdPcLojEV1p3E9yp/xXds1y6/vQCHK0uPw3ZpaWdsWXZwXGp2AshStubPTbRPeWHRpkiQGsFvawKYugLhjAVfCBv1Ru464+rtw1gdT+wGpD5MiVqDo8r24jduLDuvXgkOySEIMJu6w8HPKpWgeCGGnaOvTzPV5FVNSqt1mYQJ/HzjrGqC4JURKRCKbAtV9jGS7dh62spw==
Received: from BN0PR04CA0129.namprd04.prod.outlook.com (2603:10b6:408:ed::14)
 by SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Mon, 14 Feb
 2022 01:45:15 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::3e) by BN0PR04CA0129.outlook.office365.com
 (2603:10b6:408:ed::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15 via Frontend
 Transport; Mon, 14 Feb 2022 01:45:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 01:45:14 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Feb
 2022 01:45:14 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 13 Feb 2022
 17:45:13 -0800
Received: from d3.nvidia.com (10.127.8.11) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Sun, 13 Feb
 2022 17:45:13 -0800
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH iproute2 0/2] bridge vlan/link fixes
Date:   Mon, 14 Feb 2022 10:44:44 +0900
Message-ID: <20220214014446.22097-1-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1ae56a5-7140-4599-7b1c-08d9ef5ba5c7
X-MS-TrafficTypeDiagnostic: SA0PR12MB4432:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB44323AB3938D261EB9929183B0339@SA0PR12MB4432.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /WtO9UUfd8W6Kwl0ix8HDu6CD7TazuX6pRqMsEFMF4Ixim28nOzWF7KUvmQEkFBd3bwcVoHXJAlK67cmil2px9HpEup1omu9rkeLGk18Pkl+s50s/J3w4cwGlZkSFTWxM8NXtRlGRy/oGIyjpc1dCcpF/LDHXtYW33IQfWpsKTJtSPikcaBhJIDPaocAn30jpN9piCO+0uoRYxIl2exT5GQIwilSWkAEY11lB0fEos6Q4gfFcApbSrUJoE8R5VUQBGL9w3W9eNxeKyboc51mbh5NLMjSb2nDrHECW1p3McKPIeZnVHbBaHBywNggKMHX1JLU++yidAl8WMEOxJATmEN5atidRKGykzCgJIdOf5MvcxHpwtRAN5EQh3RV1ly7gljmfOlINW5QELMAFKt3+iPr0T/qNE16Ig6EwSA8/rl43z9DAWPoiObq2gXNXuGuihT89AKm2z3agOfqR5IvclB/rc6/LFMwPsoN1wBo6kDg8ikeY94l5f4Sqp64uQ6+A4rbt3fi8WccSiQ/7X2OoTfeqblpBF51ASQkRCEVluXi2V5HM8CBRWW4W+cMYAwDDwRJerRZWEUeJNeULRZvSD9LkIdG2/HCR4v8vSMI4VQdkSrh8zAxueXiaeQ19EoYX+uLT1VVMEWi8a6RvmIR5F0MRAyWMb0225xdhkVGYr5ngREqKjl0EM/+xtvoqVW4dRvXVsbnlC8OVkhkRsNv8w==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(5660300002)(8936002)(426003)(336012)(186003)(86362001)(26005)(83380400001)(82310400004)(508600001)(7696005)(6666004)(1076003)(36756003)(558084003)(316002)(356005)(70586007)(70206006)(2616005)(81166007)(6916009)(2906002)(36860700001)(8676002)(4326008)(47076005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 01:45:14.9043
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1ae56a5-7140-4599-7b1c-08d9ef5ba5c7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Benjamin Poirier (2):
  bridge: Fix error string typo
  bridge: Remove vlan listing from `bridge link`

 bridge/link.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

-- 
2.34.1

