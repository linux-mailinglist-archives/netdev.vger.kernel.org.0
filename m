Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1911A5F689A
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 15:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiJFNzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 09:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiJFNzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 09:55:54 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2608B2E6
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 06:55:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jn8NKDThKpLx/aCqDr4dU8ouUKdHf/Y+UN+CKFhyj93eAADF+DjQO0oUaojUfcemg5olpQCFLp7p05Hj8Ah544Whv1KHCjwvxRhrrdIzzs/0p8og0sZXkAgXALzOkfnMC50Tt4KNf5UXEIHoJlFoS52UisNZivkOBeG5idYow42Cxw6oE/GZiUDbESYGS9j1+z97Jct9VNUmKfbbyjOc1/UyRl7sX/bfnQT27pcsxvxiWSCSSEVgx8U13ENeTC9na70ol/FLaI13zpQyuprkwDq3o9KrPhCYVciRQqtYfcl7X3Re5FIaqkqqtr3OjyOsb9xrJ8Cc4WYhFiU6r8304w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XIS1+NLdBlxVk1CMTYwfDvql7+h2i0a9egffmxfm8TM=;
 b=avN5T16tbdmC/mpV7gvlRuVbaFy00eheWazeuk1FxciVqmSyfkIqxAe6TbyWEnVNVMcmdsGttNgdErTD3YRLcMUrKtUK2H26ziLkXzWNyZBUJCB57HQ4f1mOIVo4PZaVpg2dkGg32X3VLC2izxY8gfqfDORMf3riFfrcrLTzJlgb/Keqmv2Eq/1sNDCrz0CQqjRC/eceD5WCvE5VoLGmdJ6VZAd2gO9ClqN5NiGEQ+Imfktso45g0Q92VlT4m6WouYdudBc95sZgC6EnCj9i82Xm2lOTwovRDyLGvhOe4ujwLZq+2tDKAGbwNwy3ogU4fVdZIFBggW/KqyFqjHaD0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XIS1+NLdBlxVk1CMTYwfDvql7+h2i0a9egffmxfm8TM=;
 b=daq8LxhRB6LDvZfzmNpZk1F8ZLg8L5oagugcTd+U/nf8uyz8ycbsG3dbroYG93dJafgMb9fx0qB/HOTz6xPb5TRDzuFC5dxMIuYwU/ae/wHjwoURRJf2oQIAwiuNnsjaWmUe5ewioKIufm4sNRpERXYWNp9F/5mYL37+SgprwlY=
Received: from BN8PR03CA0012.namprd03.prod.outlook.com (2603:10b6:408:94::25)
 by MN0PR12MB6030.namprd12.prod.outlook.com (2603:10b6:208:3ce::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Thu, 6 Oct
 2022 13:55:51 +0000
Received: from BL02EPF0000C402.namprd05.prod.outlook.com
 (2603:10b6:408:94:cafe::c3) by BN8PR03CA0012.outlook.office365.com
 (2603:10b6:408:94::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.26 via Frontend
 Transport; Thu, 6 Oct 2022 13:55:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0000C402.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5676.12 via Frontend Transport; Thu, 6 Oct 2022 13:55:50 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 6 Oct
 2022 08:55:48 -0500
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <rrangoju@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH net 0/3] amd-xgbe: Miscellaneous fixes
Date:   Thu, 6 Oct 2022 19:24:37 +0530
Message-ID: <20221006135440.3680563-1-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000C402:EE_|MN0PR12MB6030:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b901935-851d-4a46-4057-08daa7a27aa2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CeOxVH7orcfg3xBf0cLh+jxSgSoFo3KDauUDgxZpkxzWb1T2K0BwNvhODsh8cvYaWHseJwd8MV4gOsSBCKoslkcQWeCz+u8aETzEOWPIz0g65pLGuTPOp4inTO9pc2prlSpVxy9DU1SlYCpEbFyrd3nr3DEgfuzX7X+lMh+YxpK17yRFdQhAwSV5QwlYUYV48DC/vXuFdK9Dsknc0p1qL52TbTASNFsOBktslvjTSGpgqyiyaGmt0r7jGGn9PHJl0IpJAP4tLdaRHWbPuHkw30Y+vH6WOljb/yo7les/dvQ5O+mSnMIJOK3I329kI7Vg3TMlZEy9nmFrQV0OHSSJ2WHYyfiyZ/wJHC54FYlhdiB6W7LPVX9ZCMJ2mtb7koIGXgFaIV6F/eMUOgMaqkmLJC9d+HyNXL/lclj697qcQw4Lx6Crly28ssZhGJRWXeeX5pYmrVIHCmFZp4OjmtFy8kR/SibKMufgOV8wxQW88FQ0bQ3+FBhloESzZbnXLtEGF8fggT/dbHXvKh8Z+bzxn2dGpFdBa0bb3MA+b9HskTUfwpHWf83tSIkKCY5ulbnlDMcIzG3B8OyYOLJoWambiAk7KPR8/8sznaAs75wK5iocQCKL3jj+X3WAd0kS6dXTmHheGLQ/hoprBP50GQqA1C5BYkbZltkBTShy4JEMuEEFcBKGU5N1qg3CH95bb1og9vNe48QsD29yDFV1oHBRyH9jc/rVcaRwTYViNsazy8X+quopx/pYbcIu0qV0CsgQcD/QPbgT5CCp7wvGdDOAFDW1hAM8htoGnUlsFvIPLF4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199015)(36840700001)(40470700004)(46966006)(356005)(426003)(336012)(1076003)(2616005)(36860700001)(186003)(16526019)(82740400003)(47076005)(81166007)(478600001)(7696005)(6666004)(26005)(70586007)(4326008)(8676002)(70206006)(5660300002)(4744005)(316002)(8936002)(86362001)(41300700001)(110136005)(2906002)(83380400001)(36756003)(54906003)(40480700001)(40460700003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 13:55:50.9559
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b901935-851d-4a46-4057-08daa7a27aa2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000C402.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6030
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are some of the fixes for XGBE:

(1) Fix the rrc for Yellow carp devices. CDR workaround path
    is disabled for YC devices, receiver reset cycle is not
    needed in such cases.

(2) Enable PLL_CTL for fixed PHY modes only. Driver does not
    implement SW RRCM for Autoneg Off configuration, hence PLL
    is needed for fixed PHY modes only.

(3) Fix the SFP compliance codes check for DAC cables. Some of
    the passive cables have non-zero data at offset 3 and 6 in
    SFP EEPROM data. So, fix the sfp compliance codes check.

Raju Rangoju (3):
  amd-xgbe: Yellow carp devices do not need rrc
  amd-xgbe: enable PLL_CTL for fixed PHY modes only
  amd-xgbe: fix the SFP compliance codes check for DAC cables

 drivers/net/ethernet/amd/xgbe/xgbe-pci.c    |  5 ++++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 33 ++++++++++++---------
 drivers/net/ethernet/amd/xgbe/xgbe.h        | 11 +++++++
 3 files changed, 35 insertions(+), 14 deletions(-)

-- 
2.25.1

