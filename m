Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80194617B91
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 12:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiKCLd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 07:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbiKCLd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 07:33:57 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7643611C2F;
        Thu,  3 Nov 2022 04:33:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1C7wly9tgUdpOVbyF5cR9Mpd84hRw8KXsLhEmk188+l9IfSyelQfYSwVS9QEDWGUAU3ngVeKJA6PPy1Dp45z4hRhPY6Ea0lAdrMtQp4CCuiGx96hz/zrufHU6/T6fVrqkhyKIW5smtBB36KAK2ue50xuZ/d67y+ClLZQe6VbApdq0OOFNoa2xYMl7bV212DA4J5eBAfpMbdBCmIIXV5xRqV60+R+/jSw+Xsoj2kkyUorV42IwNH+ZmuouI6czmq2g/E5XocFl1SUloeLdbIZ0tlwB89CZuqXDcyIXnaPbkgR9+XP+uZA1dScxzk8tQkyJqJDwaB3VdxO/2qDXdeHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TmGPq27nIqvofHPTvL+83XYtI35esfOCUecRif8Lnqs=;
 b=KNJnAQsL5ZYiEaZyUoMHoCr8Fg9fUD8Rjji/oDUPFF5gWy6h+2cU5Jf6CT3Rpcd6s4VtfhBw/rYLSCIwDrttL7Pw9LBifWCuTu6oRZTh4bq548Z8BHh6PHa8dbNrGpQ1NiDbpaDqGa+yWgp3x1Xc8O+Zwkz7sp7CCRxR4k7odkXMjRLeK42EicfOvkPz0SPrHT9kFMIwPlB4fAzxBijknHM0xLAXI9D+5Ich9cyaYNLE2Yr7OkYFX52jXEqeCXiu1GO8tzMTTvlaLAxhSXhXokXv4dn3HlMtdPw7GlEqE8iOQiQEKfmtgbV4wH1awyDhLv019NO+AJHnpQXyTXWBbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmGPq27nIqvofHPTvL+83XYtI35esfOCUecRif8Lnqs=;
 b=4Arok4TpFe1iPWha2zPcE9fOQFi+/j64rhFqW1N93CELVYq8Eba/dEpA1O86faNrZQQZ+EQ4C9sj6ETVsxvT6wd9Bg/msv09y8k+x9Dd7VaYJjouJU1efBF8GhllgknR+xipytpmP0xDcMZrt5pfIdvJvgYn9MHCz7v+xNJjMR0=
Received: from BN9P220CA0020.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::25)
 by MN2PR12MB4269.namprd12.prod.outlook.com (2603:10b6:208:1d4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 11:33:53 +0000
Received: from BN8NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::f2) by BN9P220CA0020.outlook.office365.com
 (2603:10b6:408:13e::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22 via Frontend
 Transport; Thu, 3 Nov 2022 11:33:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT114.mail.protection.outlook.com (10.13.177.46) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Thu, 3 Nov 2022 11:33:52 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 06:33:52 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 06:33:51 -0500
Received: from xhdpranavis40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.31 via Frontend
 Transport; Thu, 3 Nov 2022 06:33:49 -0500
From:   Pranavi Somisetty <pranavi.somisetty@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <git@amd.com>, <pranavi.somisetty@amd.com>,
        <harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>,
        <michal.simek@amd.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH net-next 0/2] Add support for Frame preemption (IEEE
Date:   Thu, 3 Nov 2022 05:33:46 -0600
Message-ID: <20221103113348.17378-1-pranavi.somisetty@amd.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT114:EE_|MN2PR12MB4269:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e51c164-d2fb-4770-0f66-08dabd8f4905
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lKMHcY1sN4TwajwMgAumqplmYQbXkexUVMb61jgOfSY4+c8XIaeJNYr/2sj/qITFRLYDiDN9dBnND9qNdCnQSTIw9pM1sksc3/g8DUZlC3YpF9gdrKC7zVsu6ju5avN9qX/xaQIiNuEqGFlKoSSP5EnWH/QqeD5mImt4VRgYe5Q4i97JB2VI2kzZHMpxzkK3RyPzxdiDcypVR6XgkOSgVqLyvH9gUxd/St1zBv75s3ImheiBPm2rWh11ygQDIT18c6VjB7f2LgsNG90qjrudtuq94QSQskJ3GdVc/OOgtGf8biBT4Jja/A3VD0+X79XxAJjfGAUDiggFJe94W0sg/PViDAYkW5kCkE/EugZDnjr+n/OVA6imPSbLQgC7Acd78/CvAb3l9YFE8mMXm+9nJHDLIIsgVNZxvs6RkWsD0uY5EJ3ZWcstT8hJ/3qXms6vZwusBvbM2Wt5XZFWpo12Q704PnxFhjm+RFI3vUXZdiWUIqTm/ilRBC81EaRUPsuQ/WXrViQPyRv3bc7pVDtcI2PmM0nn2EqK0wubj0561fkfXlhaA7o8QUE+a1qeRNia+XN2AI1xWcFA8YnyqkKxxIDph4jAC/s6E93qZdYr4kcJgcxTrXkOh0rUhTuxytTF+m0HHu3lBDD0BIWjBvWY04gRvSSjPGlDEu2vR4G/qBa9rYCr7VfwTpHuvhpJ+JGKmBmRHMvDx2GXlUoxLMSL5kAwgqxI+RQxJq2bI2fX3lEYRqpt+Ls1+wUjUvdEMQ23Hkx626hYb6zIdJEe9zudGujcZ0Vu6ClfU0pJzKKew6RY6JfbCSZHiCvO0fHmwDbm
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(39860400002)(376002)(396003)(451199015)(46966006)(36840700001)(40470700004)(8676002)(4326008)(70206006)(36756003)(2906002)(70586007)(426003)(83380400001)(40480700001)(47076005)(6666004)(54906003)(316002)(82310400005)(86362001)(110136005)(356005)(36860700001)(40460700003)(81166007)(82740400003)(478600001)(26005)(2616005)(4744005)(41300700001)(8936002)(5660300002)(186003)(1076003)(336012)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 11:33:52.8919
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e51c164-d2fb-4770-0f66-08dabd8f4905
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4269
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frame Preemption is one of the core standards of TSN. It enables
low latency trasmission of time-critical frames by allowing them to
interrupt the transmission of other non time-critical traffic. Frame
preemption is only active when the link partner is also capable of it.
This negotiation is done using LLDP as specified by the standard. Open
source lldp utilities and other applications, can make use of
the ioctls and the header being here, to query preemption capabilities
and configure various parameters.

Pranavi Somisetty (2):
  include: uapi: Add new ioctl definitions to support Frame Preemption
  include: uapi: Add Frame preemption parameters

 include/uapi/linux/preemption_8023br.h | 30 ++++++++++++++++++++++++++
 include/uapi/linux/sockios.h           |  6 ++++++
 net/core/dev_ioctl.c                   |  6 +++++-
 3 files changed, 41 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/preemption_8023br.h

-- 
2.36.1

