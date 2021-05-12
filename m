Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF21F37C09D
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhELOuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:50:05 -0400
Received: from mail-bn7nam10on2068.outbound.protection.outlook.com ([40.107.92.68]:9277
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231294AbhELOuC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:50:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YOGWWaYkAM+IKOio0AClNX8Nek845aR/NfE1SmgzuFuh9/d9UP/SNaQveX4ziT5KCMZ0Fc82XN0UqMIrh0dOJ+fL9H5seQCd7VPl4uXXSa0ycKgN3NpvXRJOZ4XumqGv6MCbfIiISBvU2Jp/r9zuzNrY0gNb/pqiiUyRoC958qIvw9lqLsGPU6FtjKrQFluxhUQscFiG7p8AvVx15JkKrBD+jIhlsR8f+d1dlHk96tnF85WTU3NM/8qWy619AOkyvEHova4PHvERt930AnKtICpmMsQTYinxwin30OhJ6glWXSm7q00SjZXD3Qe9B3KRZA7F6kZtPZ/N8Vq6HmWbAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DX0m4iRN8YLlTcqFY2I+aSP7jhSookz5vFxw/iLNVLU=;
 b=fZHn4JR9hOM3hdOVXym1VTF9c9Y9Os5LLlXhF9nKjCVQKGnTv5VR5fxVoAqYh/grFk4h/OSGl8DtNTvsOUgdcS8Y2kiSRBRFFsQ3WcI0O6kqVP2ICs9Eon5Ij/3qydkCc94K5HqGY7TZCJWT0AWumoUDtC1H2EdrhSG9AkwL7E7m9YAFaCtSjjlQAe5zsa3wi9AVjLZkXCe4+bwFq4vuMoeYnqi9XsK5EXWWYpI5p4cObqgxOaJ5T1+MPpsrI61SJGNZE6AuhWNU3inim0d1RNpQ+FDZ98+FSCRf5xA9rc1DRLoDV4tVclLrzf1zHE/DgOX3g35ARK30pnytbbDmWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DX0m4iRN8YLlTcqFY2I+aSP7jhSookz5vFxw/iLNVLU=;
 b=sFeERzlhgIq1WA0exJe09+7xGI4dXx+oj97PTleFYTpIiNIi8KfDtAgqLcvrfNCDJS8VOdEY7r+82RD4TbUFXI9A+gFLXMpYEW3w7zpZuWQkJhkemCN4R86zp1Jn8WfO9Fz+1U9FbVTdK/s1VtF2A/BauLIfFGkfooABC/Qk80d3jBshaTnwOkjMrDGtgf5u53oxFqS/vYq/rqHVjLPzquZPfEojXG+ubqnqJgnGo5qDDAJyKIZRJSo7zsL946u1qE+tsY3Kz3pqnX93Tga6eIDARAhG44/WX2M5Iyt1zC1Y7/EL31vGCOpkqWRFisy+jZAOndCD+iwzlSDk9+FwKw==
Received: from BN9PR03CA0378.namprd03.prod.outlook.com (2603:10b6:408:f7::23)
 by SN6PR12MB2829.namprd12.prod.outlook.com (2603:10b6:805:e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Wed, 12 May
 2021 14:48:52 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::f1) by BN9PR03CA0378.outlook.office365.com
 (2603:10b6:408:f7::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Wed, 12 May 2021 14:48:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 14:48:52 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 14:48:51 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 14:48:48 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v2 00/18] devlink: rate objects API
Date:   Wed, 12 May 2021 17:48:29 +0300
Message-ID: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d35420c9-605d-48a0-6a89-08d915550f4a
X-MS-TrafficTypeDiagnostic: SN6PR12MB2829:
X-Microsoft-Antispam-PRVS: <SN6PR12MB28290D1C22FAF536746BBA0FCB529@SN6PR12MB2829.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6R6X3gw1ZuBiJKVzEGZ+hq/G513g2tHMMPGz9yjbAbWbZLNZNQE+46tw1nyrd23eWE8pf1MpFuAn8IM7OsSPw4VXb2mvTEroLvPh7vY5CC/yeb8E2PIw2HnHXkV4ynXt9tDeMZyizh0EqJVXkpKHnrReiOP6xfinA3Zq2P7oVR+WjpZKd//toVrW35wQZgt7PQsiiA00tX3qYazeFt9rmBMr3tZieBxH098YkfQQBbID7iqghVZatTm6WJ1RxYqmB0Tk5w1y8sJayrnRAYXAuH04qNzevI+6JL1xj5SvBUrLOCEzIiClEaDZwXxjMN0jthsiTsgelye+g6JgZGTv7AZpy+DmcrTg5YOAM/i6QBLSdFc+bwpCtpS7uCjEik4TXjaXI7ZNx1tsHHA6O1IkP222d/v3SOyMGmvEisSwwwOrHPcAoLvGWwKM2W47h6jBQ7hlbko/rsrv7EApmTQxT0xUR/ONArWK7Rhjods9NDu94N63Wj0iBMuQZJWFHIMoubC2E1mkAeJmTFPrLtZKMTS3IEFMneoIjDwNCpQqA4yIVZ4Gve8sAicxGjwvbMtAF5vzCn8JuoaPcUgbRYH4m0vo2Z9z/0SXPno2peSWvdpuZxS+35ItrR7y3CcmKsEzgcT1JltslgHgDtQelOCdY/uHQb1zlJ6vNo3Al5IOJ+M=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(46966006)(36840700001)(5660300002)(7636003)(478600001)(54906003)(356005)(47076005)(316002)(2876002)(36906005)(7696005)(36860700001)(8676002)(26005)(70586007)(107886003)(2906002)(82310400003)(8936002)(186003)(82740400003)(6916009)(70206006)(426003)(6666004)(336012)(86362001)(4326008)(2616005)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:48:52.0585
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d35420c9-605d-48a0-6a89-08d915550f4a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2829
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Currently kernel provides a way to change tx rate of single VF in
switchdev mode via tc-police action. When lots of VFs are configured
management of theirs rates becomes non-trivial task and some grouping
mechanism is required. Implementing such grouping in tc-police will bring
flow related limitations and unwanted complications, like:
- tc-police is a policer and there is a user request for a traffic
  shaper, so shared tc-police action is not suitable;
- flows requires net device to be placed on, means "groups" wouldn't
  have net device instance itself. Taking into the account previous
  point was reviewed a sollution, when representor have a policer and
  the driver use a shaper if qdisc contains group of VFs - such approach
  ugly, compilated and misleading;
- TC is ingress only, while configuring "other" side of the wire looks
  more like a "real" picture where shaping is outside of the steering
  world, similar to "ip link" command;
- etc.

According to that devlink is the most appropriate place.

This series introduces devlink API for managing tx rate of single devlink
port or of a group by invoking callbacks (see below) of corresponding
driver. Also devlink port or a group can be added to the parent group,
where driver responsible to handle rates of a group elements. To achieve
all of that new rate object is added. It can be one of the two types:
- leaf - represents a single devlink port; created/destroyed by the
  driver and bound to the devlink port. As example, some driver may
  create leaf rate object for every devlink port associated with VF.
  Since leaf have 1to1 mapping to it's devlink port, in user space it is
  referred as pci/<bus_addr>/<port_index>;
- node - represents a group of rate objects; created/deleted by request
  from the userspace; initially empty (no rate objects added). In
  userspace it is referred as pci/<bus_addr>/<node_name>, where node name
  can be any, except decimal number, to avoid collisions with leafs.

devlink_ops extended with following callbacks:
- rate_{leaf|node}_tx_{share|max}_set
- rate_node_{new|del}
- rate_{leaf|node}_parent_set

KAPI provides:
- creation/destruction of the leaf rate object associated with devlink
  port
- storing/retrieving driver specific data in rate object

UAPI provides:
- dumping all or single rate objects
- setting tx_{share|max} of rate object of any type
- creating/deleting node rate object
- setting/unsetting parent of any rate object

Added devlink rate object support for netdevsim driver

Issues/open questions:
- Does user need DEVLINK_CMD_RATE_DEL_ALL_CHILD command to clean all
  children of particular parent node? For example:
  $ devlink port function rate flush netdevsim/netdevsim10/group
- priv pointer passed to the callbacks is a source of bugs; in leaf case
  driver can embed rate object into internal structure and use
  container_of() on it; in node case it cannot be done since nodes are
  created from userspace

v1->v2:
- fixed kernel-doc for devlink_rate_leaf_{create|destroy}()
- s/func/function/ for all devlink port command occurences

Dmytro Linkin (18):
  netdevsim: Add max_vfs to bus_dev
  netdevsim: Disable VFs on nsim_dev_reload_destroy() call
  netdevsim: Implement port types and indexing
  netdevsim: Implement VFs
  netdevsim: Implement legacy/switchdev mode for VFs
  devlink: Introduce rate object
  netdevsim: Register devlink rate leaf objects per VF
  selftest: netdevsim: Add devlink rate test
  devlink: Allow setting tx rate for devlink rate leaf objects
  netdevsim: Implement devlink rate leafs tx rate support
  selftest: netdevsim: Add devlink port shared/max tx rate test
  devlink: Introduce rate nodes
  netdevsim: Implement support for devlink rate nodes
  selftest: netdevsim: Add devlink rate nodes test
  devlink: Allow setting parent node of rate objects
  netdevsim: Allow setting parent node of rate objects
  selftest: netdevsim: Add devlink rate grouping test
  Documentation: devlink rate objects

 Documentation/networking/devlink/devlink-port.rst  |  35 ++
 Documentation/networking/devlink/netdevsim.rst     |  26 +
 drivers/net/netdevsim/bus.c                        | 131 ++++-
 drivers/net/netdevsim/dev.c                        | 394 ++++++++++++-
 drivers/net/netdevsim/netdev.c                     |  95 +++-
 drivers/net/netdevsim/netdevsim.h                  |  48 ++
 include/net/devlink.h                              |  47 ++
 include/uapi/linux/devlink.h                       |  17 +
 net/core/devlink.c                                 | 620 ++++++++++++++++++++-
 .../selftests/drivers/net/netdevsim/devlink.sh     | 167 +++++-
 10 files changed, 1522 insertions(+), 58 deletions(-)

-- 
1.8.3.1

