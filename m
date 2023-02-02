Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4960768894D
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 22:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbjBBVz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 16:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjBBVz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 16:55:58 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2059.outbound.protection.outlook.com [40.107.96.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA43A589A1
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 13:55:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHfBnnLMFdCDR8mhKUT/79qVvh/BNBKYEQUJw+CNBzQRBsqxTwZK5vd4jm/Vwjkn04ZcIbxYJxy3XUagjOLfUQuWVW8J/6KBiHhcyv6q9M2suTAg4gdLltvkPHEuDGYV22LV/yi5mseIKDxO9vhHpFcok2PDYjZzj0sDJKNvI1ym7P5uoDfILhqQ58U/tR+a6kY/gO/ofDZMV2J1duztwDBqDdqLpEBDQnQepMR2c1aE0QpiXRCYUGzf270uDJdQi5VWmb4p9yNkLUJeECIy7DBRsU1kblqhDSCnMnoEcCAl0gl78mUZ7hTJ5h4Qbd6JguW058UAJ9b9C5ERz/1Ddw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pDfX1YB9qjpyUMrAVNpg/vo8pdmJ50XHWMrP0RAYNwI=;
 b=TcB7gZ7Z0rNKJTtFmBQNsvn/nItFFZ73q5CbII0Jnimc7OBsT40pGk+dU31IUXHRKQu4O5nPyNaseZdSnVt7pX/pKsqMLmIa60nGtpz88viZrs9RPE2rgucOF2feIma9cyIqk4jGj9bYEv+0I7/eR5dORYHIJp2ZC8jK4MH7jgI5R11ySp9d1zcQ28jGby53dySq1USlsQwXGTCW7AWgBjlTwKV6LliWLSBkn1RzdPEyKL48C3TpvfbfxRaJZNEnENJQf3sUhvpKvFypNZHslCL8pCCNJubKZAdY7M1xcWDDRm3itHi2DGfkQHe/GqMQhBTgf8RJjU3yyKCrTh19Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pDfX1YB9qjpyUMrAVNpg/vo8pdmJ50XHWMrP0RAYNwI=;
 b=anqbgNhLfGepgClh49AwYeYf806ldS15j5Tlim0T2428GUvx8XB3NAWOkZPksLntst9cb/dalPgPYw6Fxx4pbZ/qp3vLqNhM3tKbmWNRlcHe1GooPw8XKRmLanUnnd6X1z3BEi8DyTRMZkLhRpZlj5SJUixQ0qsUZoOCYZw1vq0=
Received: from MW4PR04CA0121.namprd04.prod.outlook.com (2603:10b6:303:84::6)
 by DM6PR12MB4073.namprd12.prod.outlook.com (2603:10b6:5:217::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 21:55:55 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::ff) by MW4PR04CA0121.outlook.office365.com
 (2603:10b6:303:84::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 21:55:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.28 via Frontend Transport; Thu, 2 Feb 2023 21:55:54 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 15:55:52 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net 0/3] ionic: code maintenance
Date:   Thu, 2 Feb 2023 13:55:34 -0800
Message-ID: <20230202215537.69756-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT053:EE_|DM6PR12MB4073:EE_
X-MS-Office365-Filtering-Correlation-Id: 933298e5-57e0-49e0-04b8-08db05684227
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0XbLrWtkTlLfQrBu505ANIRxSH3xX+RCXj0Nyzwhaz+nqHHULbphbzgjCJ8ogP37XUa2a9DF4KWdS5D5DCdUWAYe52NFp5IC3wRfqLuLVqTqR+ZG7mVl60dSAHP+QksugetBAbL4eVvpy7O6viMideIepYWncbCIFb1gQHYiB68WJqLVFjmdWOuarzqvFf3kA7Hdp9oWcSZ6q7Txu+uYsO4i1NXz4jhUEoSCsQN4qxcUOca8BwOA7u4BGFAjdz/51U4kfHQtBFXQWK0Dbn+v0vjDM4Xua8M92jgIQG5zgXrzMFQpXpYwN0UusX6scCa+ago28r09kzjqUzDFBXxV3toaJ85Iacv1E82VwRIyZ5sc5oXPSK8mZ2fqoELLnC+UCDT/AJO7wDLnwht1Qeb4hKYC/Psu4basEfYWMecARGrbOdsmRw7FbYso/iPLJBPRuWs4CSXM/NM0f9RYdg/hGCQdNNDYJbpN70V6NPoujxWqk6dSnLEFekTeatqwpqs3/Udi+hxTaznaLdPazDxfw5Blklo6ASaN9dWHT8yAXcODVVyW9FLAcaGy67Jfef+MPG24GaD4NwRjT+zqjgawyz1/dj3iKyV9GRmgeSdwPK+kHDmfPhkczxtgJ/oeu7zoydmJrG/F+hVdsMZ8Kty11D4N68sBEWPgrMwUG1enDlSL9CW7Nt8pKomBCryPWHxKjFTW+ZZxMR3ooSD07ZNiI2ZHQ3gZ5wLVY1tI+Ko7dVw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199018)(40470700004)(46966006)(36840700001)(110136005)(1076003)(36756003)(40460700003)(478600001)(40480700001)(2906002)(44832011)(4744005)(54906003)(5660300002)(6666004)(86362001)(316002)(36860700001)(336012)(70586007)(83380400001)(4326008)(70206006)(47076005)(186003)(81166007)(26005)(356005)(426003)(16526019)(41300700001)(8936002)(82310400005)(2616005)(82740400003)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 21:55:54.6085
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 933298e5-57e0-49e0-04b8-08db05684227
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4073
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a few fixes for a hardware bug, a couple of sw bugs,
and a little code cleanup.

v2: dropped 3 patches which will be resubmitted for net-next
    added Leon's Reviewed-by where applicable
    Fixed Allen's Author and SoB addresses

Allen Hubbe (1):
  ionic: missed doorbell workaround

Neel Patel (1):
  ionic: clean interrupt before enabling queue to avoid credit race

Shannon Nelson (1):
  ionic: clear up notifyq alloc commentary

 .../net/ethernet/pensando/ionic/ionic_dev.c   |  9 +-
 .../net/ethernet/pensando/ionic/ionic_dev.h   | 12 +++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 68 +++++++++++++--
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  2 +
 .../net/ethernet/pensando/ionic/ionic_main.c  | 29 +++++++
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 87 ++++++++++++++++++-
 6 files changed, 195 insertions(+), 12 deletions(-)

-- 
2.17.1

