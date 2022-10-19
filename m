Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8A7604F8A
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiJSSVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiJSSVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:21:48 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2087.outbound.protection.outlook.com [40.107.100.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94511BE430
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 11:21:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jr2NsOUwP1kHbDCmoj0+uLb1wKz0P6XFvb7SCkalO9ZY+NEllvPlLHAeHt31fyxzv0im4Q5qsi4v79ixEJY/MluK+fGS2T13CxWxgvi+VRnHYdHFeyqmBB/1cR8Z/YSK4sjV+W0pyQbIof1s0xYN0laLOdM2mzNo6K9y6TE1czPcyMTdjZPw9bdXj0ZMI/RlpbH2RNcUnbPcaKLmRDiggxDyxuhfYVNnWvk/iIFab+7CRS3kRQLL1CQO0cvxTPkXCemko2AsnPYqYM2yxVw4ocTco2kejlZtHpbLju5FG013IBPRBYKv/s0ErtKmXPBKp++NoJcdqYF487yM2GIuRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1wMqZZj1Vcb0xXWjbsjKAlUdg7GeRATJu0ACrVWu2mw=;
 b=cB0lGOTqD9AP7YIDYh6i/X8B72hfurA3I/dwUACMQ6f7U/fVfdFM2ZBh7x92dMS/R5h24uct4uJPQ12b6xXZydTfXonOy95unNmOCRWmyYDMLRdq6qUDAuvd5wI3kYThzvO7vS0j5p2mzhDZOzvCKBsjm1nSuVI9pqkUrnYBpNzjbnf/ah1kfCpJU5m+Ldrai3FGkbQs7QIOPbic2uw/bK+u5GrGPLmHBqt3q+z8FsmrxiKN1tdbe4r9lNrU231SSceQPYBNqBdGk0a0E3a9eQ2+ldDRwMVktxqgPvT6/6ucpno5KiWLSyHNbnhLecT6IPlj/SNt4dnYaYf9oNEeag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wMqZZj1Vcb0xXWjbsjKAlUdg7GeRATJu0ACrVWu2mw=;
 b=m3GjJKcVagYXlBMqOHXStKC5GDNnQuuKVytyLEZ3f6cY0aYppVbZSFbldcARowcQD1JFP9m1aa8WSY1eFWfUo9UnNL5hmCw1D2Tq4wZi7IgnrqO12yMvZTl8riazgxPZz6x8cEhK0PizJwa+s6rCbcp9AxfK3Tcm0kOBx7BNV9I=
Received: from MW4PR03CA0077.namprd03.prod.outlook.com (2603:10b6:303:b6::22)
 by DM4PR12MB6399.namprd12.prod.outlook.com (2603:10b6:8:b7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Wed, 19 Oct
 2022 18:21:43 +0000
Received: from CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::d0) by MW4PR03CA0077.outlook.office365.com
 (2603:10b6:303:b6::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34 via Frontend
 Transport; Wed, 19 Oct 2022 18:21:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT082.mail.protection.outlook.com (10.13.175.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Wed, 19 Oct 2022 18:21:43 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 19 Oct
 2022 13:21:36 -0500
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <thomas.lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>
CC:     <netdev@vger.kernel.org>, <rajesh1.kumar@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH v2 net 0/5] amd-xgbe: Miscellaneous fixes
Date:   Wed, 19 Oct 2022 23:50:16 +0530
Message-ID: <20221019182021.2334783-1-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT082:EE_|DM4PR12MB6399:EE_
X-MS-Office365-Filtering-Correlation-Id: d772f3a7-7d2b-4966-f576-08dab1fec656
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G3W/itvKpPO3ulm7tRYYkAIJw8vhv5WWKF3JWFmxY/u0jhJStRrjwkhLBqxK94L2ws0adHdljqPKbhE+m4uulqXxczZsbeVAUex+sl+heWspjitwYQWSOHJTeIcJFsod0kjzJPy373raODp/RosEPL9iykh5Yx3dj3y+HZSeulbqhAJ9QiC1WWoHRg1YXk6IADHebPg8QF6BSzWInkSwuiZ/GOtS0cnm58OeWaQHhCqJGgTX4jrzS0GoR6o+0yK9oLc9n5W6Jw0t6yCsVsDxrMnZDTDUGly1hpMqUl9J99K4CzcFs/u8X7/pVJ4uwA6oEsohl7hcxkBxf0IHZA/Ghl/+ROfMarEOw/4VgaVg6xqauAAIV6s5WJ3KwyOT9pa5gHvpagvizB58KvfqloIXULVxCBQZVJHFYNcPiLS+xMSh38UJYQriJz9XkMlLha5WPSvV9Ed2w0jKkfFv0BHjHoY92lFKkts6GePFcAC53WrFa2Gn8AnPmxPw4W3I8fcFenKiAuQLwKNopTXT/9CjK+YkcUwbjetXcx3jGTSGDDQY7mAHCZOh1HaIeNlVX2DNS7JNSinB6SqDCAXuelxZitYKtELdDpNz4SVqCWjqtqD02AsH4GuuI2IQFtHgauuU7q+A8tzp3n7wMMe+SrrByrXV9+GzU3HKK1grFzWHcAq/doAvNSU/EV2LP7PVhO3k+n/BHP/ZCA5K0j8HEbuHkFBldJqqP7ZMdwVY+/3/WmehGr2zValrnEuvnNSGxnwWc/Bh4EzHDMshBWER0XSRK3lpsF+ZmDdQvzCF0TG49g4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(346002)(451199015)(40470700004)(46966006)(36840700001)(83380400001)(81166007)(47076005)(336012)(40460700003)(86362001)(36860700001)(426003)(356005)(5660300002)(8936002)(82740400003)(110136005)(70206006)(70586007)(41300700001)(7696005)(82310400005)(2906002)(16526019)(186003)(6636002)(40480700001)(8676002)(316002)(54906003)(6666004)(4326008)(1076003)(26005)(2616005)(478600001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 18:21:43.2181
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d772f3a7-7d2b-4966-f576-08dab1fec656
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6399
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(1) Fix the rrc for Yellow carp devices. CDR workaround path
    is disabled for YC devices, receiver reset cycle is not
    needed in such cases.

(2) Add enumerations for mailbox command and sub-commands.
    Instead of using hard-coded values, use enums.

(3) Enable PLL_CTL for fixed PHY modes only. Driver does not
    implement SW RRCM for Autoneg Off configuration, hence PLL
    is needed for fixed PHY modes only.

(4) Fix the SFP compliance codes check for DAC cables. Some of
    the passive cables have non-zero data at offset 6 in
    SFP EEPROM data. So, fix the sfp compliance codes check.

(5) Add a quirk for Molex passive cables to extend the rate
    ceiling to 0x78.

Raju Rangoju (5):
  amd-xgbe: Yellow carp devices do not need rrc
  amd-xgbe: use enums for mailbox cmd and sub_cmds
  amd-xgbe: enable PLL_CTL for fixed PHY modes only
  amd-xgbe: fix the SFP compliance codes check for DAC cables
  amd-xgbe: add the bit rate quirk for Molex cables

 drivers/net/ethernet/amd/xgbe/xgbe-pci.c    |  5 ++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 58 +++++++++++++--------
 drivers/net/ethernet/amd/xgbe/xgbe.h        | 26 +++++++++
 3 files changed, 68 insertions(+), 21 deletions(-)

-- 
2.25.1

