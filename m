Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3516C6736EC
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbjASLcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbjASLcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:32:12 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2049.outbound.protection.outlook.com [40.107.95.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED2875A14
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:31:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4ZOSFv6znSssjEHzmUHm9gfOpLXEz9264QEtcaZhhKCwszU6zM839xNQmw858tORhV6P7O+B0lFKhh4wWgOskryxMGWvVmO+xuh02qbmecqw8OTaA0JCnWC/giP+cn/Hn6kC5hDgWeQit4GqVtOpPqTtzU6ie0kPYJVDFV9ya3PVI2vfOEAP/6mdpoiaDVpGtThi5bSNeMkkXGdf+ec4Fv00oTll43pOP8afwc5R1WTz/4bE8WtbPpY8enUXW7bMhTX5FSY214f0ByWnssg3kXRb7rXDZaMo/lrKHnFvxgZiQgL552y3yqCvCgSNl0eg24O/LItaJg34q10eV9hDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghyeOib7sEwremA4v/k1h6cv75Mcp0tChZqULQX2gDs=;
 b=fUk8dyQnhcrli34zS3zTx6f9mbSMRjPSQz7dkzaKsjhXkGh3lL4hTgrHM2gNX0wlWJ0Z8NtwagWRQSnUMLN7K437f3fj262Gj/VrDKHXuUqMl6+BVuMQDzdIe4v+qc0wUInZ67KdjPQQH2Zx2dsvHLaC2EVi14CZHfTMkltKNxPDG7bVNdiXS1pqxlRmpqab+IUJpeDI6Z7/Mu0hoIuESwdawrv733KkdiNgmdgz9Onxw4hvY4ucw4u28Y3sQdPgZXnjPam6DuRvYEVTT52bZ7ydpUTwXmERbRrJ8TUaa27lDWatu4zZGITSjF72hQhBZ/1PWikqSHcgrfWTXJ7/Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghyeOib7sEwremA4v/k1h6cv75Mcp0tChZqULQX2gDs=;
 b=pOehhEasFfLqGYGXJZ2c8ylPFphsDT2kIGGuhpRo6FKDUzaE4MbkO6BlN5T+B5Yah8ELJMG3bb6E3RNMG8aohfdjqjLmFwVbT4IJ7uN/dfRDRxIrvKub35GMGwPY1up2r2cZYl+SQHpI3ESFgt+4yig1cC6/P/OSsSU2Csf8cHE=
Received: from MW2PR16CA0042.namprd16.prod.outlook.com (2603:10b6:907:1::19)
 by MW5PR12MB5683.namprd12.prod.outlook.com (2603:10b6:303:1a0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 11:31:51 +0000
Received: from CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::c5) by MW2PR16CA0042.outlook.office365.com
 (2603:10b6:907:1::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25 via Frontend
 Transport; Thu, 19 Jan 2023 11:31:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT047.mail.protection.outlook.com (10.13.174.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 11:31:51 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 05:31:50 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 05:31:50 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Thu, 19 Jan 2023 05:31:48 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm@gmail.com>,
        <ecree.xilinx@gmail.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: [PATCH net-next 0/7] sfc: devlink support for ef100
Date:   Thu, 19 Jan 2023 11:31:33 +0000
Message-ID: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT047:EE_|MW5PR12MB5683:EE_
X-MS-Office365-Filtering-Correlation-Id: 97d3a3cf-597b-4e99-9a2f-08dafa10c27e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ECGad3wiTT1+vNqs/tTQrr27dVTsqTc7ObCXEh9+YeI1XLm72e48ME91SuI5HX2kad+BCSb9GfGTCztderEY7cRjKxOO9KBXYXb/zoja3pxgpjUhZuQS3YxzlqX1hy3/Yx6+Tb+PUwLQmiahPk97AXX5NnsDurbaztoteSK19um5cnB+skrakAuFtJC/gIS/DgPGb6iT32tlEeKMhjfI6N5jcd63by/NY69nP5kXGj9VZpybAEw3obtakSVn4GjkDHPjAkdUSQEGvluDfAjDJ7TTjZzExyXdZX0dQsMe1I/EhUaUg2SVtSGCHkFGe4ifKbIlt7cS+it297ulsqkmoDRE3OFeILCOCjYuCS4pCIKb9pffBripP+cDzLmNYJv38Tc/XcCRqnkksN/GmrBtBuge0DZQG86aSHK32sHWBJWWeVObYovTxRR2zC85+IrHgGTCKOW2P7s42UeLj7lPhYFwiW7YXKMLWFl7D4u1Uk+441vClU0mEeMQTonfMjU33gWqgMmxVFWylRxpL9hAdMO4vTBVEluoNZ7CnGvOOnCNvkcdH1ulWpvv1zy0eHweRhA28r7tdNsnd27cMq9abCWeRQ3dx+aOhD7KNjDgOjYZjfAAmqn7hLFWHGv/hzCC1RvNjKMTRmzjvYN2l4cbsdvsNVE8IowSdsX9R20D2Rp81Cm2K4+5q2SN6eO2FyJsKUHv31mDPY4L3X+39ieAPWMgBZhBJo2dE3O7dYa54K8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(81166007)(36860700001)(82740400003)(316002)(70586007)(86362001)(5660300002)(8936002)(2906002)(70206006)(40480700001)(26005)(41300700001)(8676002)(82310400005)(2876002)(40460700003)(2616005)(83380400001)(336012)(1076003)(186003)(47076005)(426003)(110136005)(54906003)(6666004)(6636002)(356005)(4326008)(36756003)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 11:31:51.4281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97d3a3cf-597b-4e99-9a2f-08dafa10c27e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5683
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

This patchset adds devlink port support for ef100 allowing setting VFs
mac addresses through the VF representors netdevs.

Basic devlink support is first introduced for info command. Then changes
for enumerating MAE ports which will be used for devlik port creation
when netdevs are register.

Adding support for devlink port_function_hw_addr_get requires changes in
the ef100 driver for getting the mac address based on a client handle.
This allows to obtain VFs mac address during netdev initialization as
well what is included in patch 5.

Such client handle is used in patches 6 and 7 for getting and setting
devlink ports addresses.

Alejandro Lucero (7):
  sfc: add devlink support for ef100
  sfc: enumerate mports in ef100
  sfc: add mport lookup based on driver's mport data
  sfc: add devlink port support for ef100
  sfc: obtain device mac address based on firmware handle for ef100
  sfc: add support for port_function_hw_addr_get devlink in ef100
  sfc: add support for devlink port_function_hw_addr_set in ef100

 drivers/net/ethernet/sfc/Kconfig        |   1 +
 drivers/net/ethernet/sfc/Makefile       |   3 +-
 drivers/net/ethernet/sfc/ef100_netdev.c |  20 +-
 drivers/net/ethernet/sfc/ef100_nic.c    |  96 +++-
 drivers/net/ethernet/sfc/ef100_nic.h    |   7 +
 drivers/net/ethernet/sfc/ef100_rep.c    |  58 ++-
 drivers/net/ethernet/sfc/ef100_rep.h    |   9 +
 drivers/net/ethernet/sfc/efx_devlink.c  | 629 ++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h  |  27 +
 drivers/net/ethernet/sfc/mae.c          | 212 +++++++-
 drivers/net/ethernet/sfc/mae.h          |  39 ++
 drivers/net/ethernet/sfc/mcdi.c         |  72 +++
 drivers/net/ethernet/sfc/mcdi.h         |  10 +
 drivers/net/ethernet/sfc/net_driver.h   |   7 +
 14 files changed, 1162 insertions(+), 28 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.c
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.h

-- 
2.17.1

