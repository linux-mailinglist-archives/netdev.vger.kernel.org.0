Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CE059B569
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 18:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbiHUQUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 12:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiHUQUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 12:20:38 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2084.outbound.protection.outlook.com [40.107.100.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F0817AA0
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 09:20:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxOS9VoTzZaftK1EgTU1IqTdA+oCID8HV6T/eoHq9Yc3Py6n0jOSh90gyldqZIYxxglzcwk1/WwYYCXTq9ptlSu/Og3OVUjzmTtTQJg8HZYq4burhfrjhLmUQPBoG6vFgfvI0EASQpH1aN1RwIrzgORm262g4+iGgGCsMZBP1LqTt31yBsC3AySn+nbzUUQ0dwsc6WopT6SG1Ids5t6fnne3ANtL2kGhAtntrqS6+RElyQkn7zHSOo5sRj6YFteLTREnAzhjYSwhyuVdA/KTRtMdDYunxeQMKi2/W4TfsYgZInkP89Igiw3EB5tFteoBwGg3MDRtLl2jfvIvaKMVFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x61oyvBgIUaMoMIZouSZPbigBF7ehbq/3Nngvg8q0TI=;
 b=i4fQJh3Z4E59JM9d/dztpbdBt+Lj4gVZTJ/eBnoCqgX3NYcTdJzrsxZBu46ENKc2fH57hMNMeCAf/sAxfLlY7be/N+o7xXGxKn5GRuOzNTKBOD2CXB0u3oPFle6jHUgDAm8QzLQqUIQGJPu6ahUToO1/bJypNLS1NT2fG25NNpdEXQvrrrPjkHQFzT2sLAJf7tK0S86TRcJYFBKvezygYjJld72hCpmJeKzkCpCBFMuddvb5z6ePpmUQpHvGMgL6hP2ykWBSKoc24RVoXfj4seyc0BnUKf1hTnua7VtQhI42Eoe5j6hV1BpDxvGklArpR5sqEFi2H6211fUwv2guow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x61oyvBgIUaMoMIZouSZPbigBF7ehbq/3Nngvg8q0TI=;
 b=JxB0RkbTGy0/vuRAvOKGJoKCZ8yuyGuqeBdKvMiEPLu/+/s01SO6pPXtQEhA78N69HkXOpkNJAvLPKJ3kt1VMaMHT6uKvdZVHs7tMtPIg8ZzHmHCe4B6v2TJGcX7WitvTvjg9bVS32miKnRzGURh7OGbF2H/NqeQGTP07m3IbOiSdPypfdj8H/aE2pLHe42Djdop4Or8UqH7nkyQw+PJTsCuCFg4eTERJWqx7uif6BUGPwNK1UYpJ2pEV95HzBddomYjxCJIGlbu1Glh/JRKf2O6kv8AEn183UtaWRSOA7zGYqKjX+9Ah/Dl28IximI3r7mUd5aQt1a7w6+/ubg7mg==
Received: from DM5PR06CA0084.namprd06.prod.outlook.com (2603:10b6:3:4::22) by
 DM6PR12MB4546.namprd12.prod.outlook.com (2603:10b6:5:2ae::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.16; Sun, 21 Aug 2022 16:20:35 +0000
Received: from DM6NAM11FT092.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:4:cafe::92) by DM5PR06CA0084.outlook.office365.com
 (2603:10b6:3:4::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19 via Frontend
 Transport; Sun, 21 Aug 2022 16:20:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT092.mail.protection.outlook.com (10.13.173.44) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Sun, 21 Aug 2022 16:20:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sun, 21 Aug
 2022 16:20:34 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 21 Aug
 2022 09:20:31 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Vadim Pasternak <vadimp@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, <mlxsw@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 0/8] mlxsw: Introduce modular system support by minimal driver
Date:   Sun, 21 Aug 2022 18:20:10 +0200
Message-ID: <cover.1661093502.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e99c07d5-5409-496d-c269-08da839113b9
X-MS-TrafficTypeDiagnostic: DM6PR12MB4546:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vFlLmUXHOF1BIN2RvMZrqIQWu4ufuSfBYjL0vNAfsld44PmGjONbS5UnlXbN+aNEi8tLzFOID7byDzJQ3ZUHnnhi3LxOthiKT3Hqi+vOlMQmSgg8qIieTamDjE3zws8ajVt6ZK9RLYS5PxzhS38Biz0aWt0J6USLVoOpUX6OfKZBslBXrPM44BnV4NuUNZJWCjh5xXqkGwVi2Nht1xKucSZpizLEMNgtolw8uJEbZU6g3V0Xs4jrPvxenu5b0iNug619anPURUhGmghxAe/ydGV4Rtl+3PUmshiadDmKUv5/qEJSbAtFkm88D+eB7bAczDjdPSdp64NIwIiwXvrpH71fXMocPg/ZvQnqLZ/cl7WriEldR46MtcyoJBzDF6UoCrMrpOHPD5s55blHP9pPMDnuQ+pUqUPQcvNPUswfnsYI0qUbvC2CI+vnOel4H2Na70WgHIgpTE5AUa3+Qp49QvP7UdjvDxBxm09y0i7iHOYhjtrIrO8VQVTOBG27+Q0G/I8UgYVxhNgHG8iMitgueQt2TX2Do32YF2k5nrUXjB6NMN/hDjEzT6d713VeAHkoMq//cGtGwkwxeH6Z/l5c/5DoJRTyEycyuSYemmHt6VAleC7OcQh4quZT2eCHhZWEp5MJpiw8rxnvE+Sery8wwcPclV7loREb3y1kADtqUQOzeKOfFsES7z7forv/2Yg5KXojLpzkJbzA2kvHpAp4LwZhKZDQddOM8vnxjz8lg0KfoR0JYW36ECjEDtEyCcmIl8yU45V7mcOzGpCLD0jZw9QFjMAMmCK65+uQ8kU6AH/lSbkW1p+nPKkCniIpTAS2
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(39860400002)(376002)(46966006)(36840700001)(40470700004)(41300700001)(5660300002)(8936002)(316002)(40460700003)(4326008)(8676002)(478600001)(70206006)(70586007)(40480700001)(36860700001)(26005)(16526019)(47076005)(426003)(186003)(107886003)(2616005)(86362001)(336012)(83380400001)(81166007)(356005)(6666004)(82310400005)(82740400003)(2906002)(36756003)(110136005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2022 16:20:34.9377
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e99c07d5-5409-496d-c269-08da839113b9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT092.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4546
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vadim Pasternak writes:

This patchset adds line cards support in mlxsw_minimal, which is used
for monitoring purposes on BMC systems. The BMC is connected to the
ASIC over I2C bus, unlike the host CPU that is connected to the ASIC
via PCI bus.

The BMC system needs to be notified whenever line cards become active
or inactive, so that, for example, netdevs will be registered /
unregistered by mlxsw_minimal. However, traps cannot be generated
towards the BMC over the I2C bus. To overcome that, the I2C bus driver
(i.e., mlxsw_i2c) registers an handler for an IRQ that is fired upon
specific system wide changes, like line card activation and
deactivation.

The generated event is handled by mlxsw_core, which checks whether
anything changed in the state of available line cards. If a line card
becomes active or inactive, interested parties such as mlxsw_minimal
are notified via their registered line card event callback.

Patch set overview:

Patches #1 is preparations.

Patches #2-#3 extend mlxsw_core with an infrastructure to handle the
	previously mentioned system events.

Patch #4 extends the I2C bus driver to register an handler for the IRQ
	fired upon specific system wide changes.

Patches #5-#8 gradually add line cards support in mlxsw_minimal by
	dynamically registering / unregistering netdevs for ports found on
	line cards, whenever a line card becomes active / inactive.

Vadim Pasternak (8):
  mlxsw: core_linecards: Separate line card init and fini flow
  mlxsw: core: Add registration APIs for system event handler
  mlxsw: core_linecards: Register a system event handler
  mlxsw: i2c: Add support for system interrupt handling
  mlxsw: minimal: Extend APIs with slot index for modular system support
  mlxsw: minimal: Move ports allocation to separate routine
  mlxsw: minimal: Extend module to port mapping with slot index
  mlxsw: minimal: Extend to support line card dynamic operations

 drivers/net/ethernet/mellanox/mlxsw/core.c    |  68 ++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   8 +
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 100 +++--
 drivers/net/ethernet/mellanox/mlxsw/i2c.c     |  87 +++-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 381 ++++++++++++++----
 5 files changed, 552 insertions(+), 92 deletions(-)

-- 
2.35.3

