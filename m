Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F865520D2
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbiFTP1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbiFTP1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:27:32 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6647F95
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:27:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bF6nbbNhpKYqlN9qWjuTgnXp/ZkaDamAWkfDWQTz5nN8aM/NO0toelJcjJ/Ym894uN93BU18Z1IeRVUApZQCxdb0OrIYYvUKRGlNdICmGgphxEpDd8hJ648gOpxmr1eEbC9sw6biVxPc6LKHdWyPjmqxtTRSk7rVRogUrsNitM7fiVxDF+CR4+BW/qGFVUAKcte1jaQmAyuM25okIDvZhVVuIvr8t+Qefapgaoip7kbPvMoQKrY/HYaqvsDtEEwNstEMqFg3PVE8+AMS6T1aK6ynfI6xFMldnAcULdBp73PnwXUaTq2FN42INp79iP0Mek63dEfFuo2r74Ijfl9vbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0IphAYvlELTdMZHK1JzRCBkvFjRp3uUAMFWs4PyskU=;
 b=EEdnJO/AaU8IVVGR/ZKixiGhXzG2EqqTEE814MEcN6a70JkVX/67Asmak52q1YDijYybOXe2BF84fmFdvFuR2AvhJpwCeLgpOBCwUJe0lZoNem3N7KbHcijNVRBsa1ndWwKjHahkvF1ucCBwvgA6QOvZnDQl4RRCuGiXksHoyfCiMUGL1U5yo7e27D0fqdqpQvBJIXH9IiNHRkScMUc/WIHXTi1sgTgx8PwihDWZ7if+IX54RKVuWfXMghOojqcV9yRZEhM7Z7ZbMX2nGehu2U5+gGXtsnKiOXi9O0DhO/jwSvrKHEj51cIAvBId4pOB08JrX0GRW6sv18eoyEcofA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0IphAYvlELTdMZHK1JzRCBkvFjRp3uUAMFWs4PyskU=;
 b=Pdwo7KT210C/pFhLWrabJgpbCi5nWd1DIQ/kgLk/Etl51BbyKvOP7e4+zbasjTYagM1HaZPycjQedOYaP/ySU7QSU0AwXB4JePNiis42SEFYWD8oQJyDouGQmucv4S4Oxo1CbgZe33UiztUEdGZyyt0y+W2BOnB6cWLW3hvcf7+dMpcDWe8MZtuSPAwRGdzmdK6rFhwQZ5ZSPdYY4YY5J/qFr+kp/WbQaxE0r7uqiDdcT0BTqVuzikCf0jbXBCBCHqFimGiAZT0lhDfeY06NuvHPEq2k2IFxYRhyQUn42YS8l+FWEtgxjQTcbR6djDhwsc8SzoOwEicAWAJurjAFNA==
Received: from MWHPR14CA0037.namprd14.prod.outlook.com (2603:10b6:300:12b::23)
 by BL0PR12MB5505.namprd12.prod.outlook.com (2603:10b6:208:1ce::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Mon, 20 Jun
 2022 15:27:30 +0000
Received: from CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12b:cafe::db) by MWHPR14CA0037.outlook.office365.com
 (2603:10b6:300:12b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 15:27:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT063.mail.protection.outlook.com (10.13.175.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 15:27:29 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 20 Jun 2022 15:27:28 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 20 Jun 2022 08:27:28 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 20 Jun 2022 08:27:26 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH net-next 0/5] devlink rate police limiter
Date:   Mon, 20 Jun 2022 18:26:42 +0300
Message-ID: <20220620152647.2498927-1-dchumak@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55056a0a-d42b-4d83-758d-08da52d1634c
X-MS-TrafficTypeDiagnostic: BL0PR12MB5505:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB5505C929D51806EE0B654CF5D5B09@BL0PR12MB5505.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TwKQGFgU2cn5YeANSKgtFkQGQ65j0HoTck5ts/BgPIwtH4twvK8eS0mCODV7CukCUtkOwXbpUPJPyJTf0cTC8LjQQkdNlEemi5+gvcNYhvNeoBZtZfnMoSVY+friQBeam1UpR6Lk1EDc561LHCEvHQbZc1+1yQfmWO+6+z3dEahJRNjkhnbktJ6+GOQJ5nJXJS+8Q4yaw0zJUHW8uSdFnh/rRjXLbJyXJYp3eaYrl/GIDCcZ97DzUgh/Z+seR18YIIdCi+oZHjSo4JkIJRf20105Pl3mbwCEGN6qj4Y0e4KGG91HwocILGBd4XYQCVo3INUnc63wd5+8xLoeY+uDVmA2sM1x6IBjGJqybfTuxJWaIXdl6U4AP8HkI0MC8+cI22bJry+lrLVM+T4R+nPWW4/V+qr1r6M9yNAbJal5a3gkZ7FR65jfYd4Fk7t6ZgApIleLxQ9lab0NvFkIgfQRH7uesmJR0gA++dQZS7vJWM21V5VW0BF+KhNbeOmgg4/BueV31CtkrvrNR0+q+v+LD3mSmdB0dO4VzIUcO25pHA5NqoPUlr4A2oGatw8tfv2wba7rRmqY/dXWZAiBFMqbkDQemjU7GAHTfLf2DHqNGLme/j+99uMApweYiAWxMUnIWCtrXjolproi80Ifle0IULIc1OBKMyPrLKeUbTvPkyONoGwN+MV9G4GhUfpdCyUaqEc5KSC9NU9wZRTLXf1q+7BsB6ZEbgPAbZU6GzKNC5smPzPY4J9TskhkPNd98sJm
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(136003)(346002)(40470700004)(46966006)(36840700001)(186003)(83380400001)(107886003)(26005)(41300700001)(1076003)(336012)(47076005)(426003)(40480700001)(2616005)(36756003)(82310400005)(6666004)(36860700001)(2906002)(7696005)(81166007)(478600001)(86362001)(6916009)(54906003)(82740400003)(356005)(5660300002)(8936002)(4326008)(70586007)(8676002)(40460700003)(70206006)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 15:27:29.2850
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55056a0a-d42b-4d83-758d-08da52d1634c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5505
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, kernel provides a way to limit tx rate of a VF via devlink
rate function of a port. The underlying mechanism is a shaper applied to
all traffic passing through the target VF or a group of VFs. By its
essence, a shaper naturally works with outbound traffic, and in
practice, it's rarely seen to be implemented for inbound traffic.
Nevertheless, there is a user request to have a mechanism for limiting
inbound traffic as well. It is usually done by using some form of
traffic policing, dropping excess packets over the configured limit that
set by a user. Thus, introducing another limiting mechanism to the port
function can help close this gap.

This series introduces devlink attrs, along with their ops, to manage
rate policing of a single port as well as a port group. It is based on
the existing notion of leaf and node rate objects, and extends their
attributes to support both RX and TX limiting, for a number of packets
per second and/or a number of bytes per second. Additionally, there is a
second set of parameters for specifying the size of buffering performed,
called "burst", that controls the allowed level of spikes in traffic
before it starts getting dropped.

A new sub-type of a devlink_rate object is introduced, called
"limit_type". It can be either "shaping", the default, or "police".
A single leaf or a node object can be switched from one limit type to
another, but it cannot do both types of rate limiting simultaneously.
A node and a leaf object that have parent-child relationship must have
the same limit type. In other words, it's only possible to group rate
objects of the same limit type as their group's limit_type.

devlink_ops extended with following callbacks:
- rate_{leaf|node}_tx_{burst|pkts|pkts_burst}_set
- rate_{leaf|node}_rx_{max|burst|pkts|pkts_burst}_set

UAPI provides:
- setting tx_{burst|pkts|pkts_burst} and rx_{max|burst|pkts|pkts_burst}
  of a rate object

Added devlink_rate police attrs support for netdevsim driver.

Issues/open questions:
- Current implementation requires a user to set both "rate" and "burst"
  parameters explicitly, in order to activate police rate limiting. For
  example, "rx_max 200Mbit rx_burst 16mb". Is it necessary to
  automagically deduce "burst" value when it's omitted by the user?
  For example when user only sets "rx_max 200Mbit".
- If answer is positive to the first question, at which level it's
  better to be done, at user-space iproute2, at kernel devlink core or
  at vendor driver that implements devlink_ops for police attrs?

CLI examples:

  $ devlink port function rate show
  netdevsim/netdevsim10/128: type leaf limit_type unset
  netdevsim/netdevsim10/129: type leaf limit_type unset
  netdevsim/netdevsim10/130: type leaf limit_type unset

  # Set police rate limiting of inbound traffic
  $ devlink port function rate set netdevsim/netdevsim10/128 \
            limit_type police rx_max 100mbit rx_burst 10mbit
  $ devlink port function rate show
  netdevsim/netdevsim10/128: type leaf limit_type police rx_max 100Mbit rx_burst 10485Kbit

  # Set shaping rate limiting of outbound traffic (default limit_type)
  $ devlink port function rate set netdevsim/netdevsim10/129 tx_max 200mbit
  $ devlink port function rate show
  netdevsim/netdevsim10/129: type leaf limit_type shaping tx_max 200Mbit

  # Attempt to set police attr with the default shaping limit_type
  $ devlink port function rate set netdevsim/netdevsim10/129 rx_max 400mbit
  Unsupported option "rx_max" for limit_type "shaping"

  # Set police rate attr for a port that already has active shaping
  $ devlink port function rate set netdevsim/netdevsim10/129 limit_type police rx_max 400mbit
  Error: devlink: Cannot change limit_type of the rate leaf object, reset current rate attributes first.
  kernel answers: Device or resource busy

  # Create a rate group
  $ devlink port function rate add netdevsim/netdevsim10/g1 \
            limit_type police rx_max 1Gbit
  $ devlink port function rate show
  netdevsim/netdevsim10/g1: type node limit_type police rx_max 1Gbit

  # Add port to the group
  $ devlink port function rate set netdevsim/netdevsim10/128 parent g1
  $ devlink port function rate show
  netdevsim/netdevsim10/g1: type node limit_type police rx_max 1Gbit
  netdevsim/netdevsim10/128: type leaf limit_type police rx_max 100Mbit rx_burst 10485Kbit parent g1
  netdevsim/netdevsim10/129: type leaf limit_type shaping tx_max 200Mbit
  netdevsim/netdevsim10/130: type leaf limit_type unset

  # Try to add a port with a non-matching limit_type to the group
  $ devlink port function rate set netdevsim/netdevsim10/129 parent g1
  Error: devlink: Parent and object should be of the same limit_type.
  kernel answers: Invalid argument

  # Adding a port with "unset" limit_type to a group inherits the
  # group's limit_type
  $ devlink port function rate set netdevsim/netdevsim10/130 parent g1
  $ devlink port function rate show
  netdevsim/netdevsim10/130: type leaf limit_type police parent g1

  # Set all police parameters
  $ devlink port func rate set netdevsim/netdevsim10/130 \
            limit_type police tx_max 10GBps tx_burst 1gb \
                              rx_max 25GBps rx_burst 2gb \
                              tx_pkts 10000 tx_pkts_burst 1gb \
                              rx_pkts 20000 rx_pkts_burst 2gb

Dima Chumak (5):
  devlink: Introduce limit_type attr for rate objects
  devlink: Introduce police rate limit type
  netdevsim: Support devlink rate limit_type police
  selftest: netdevsim: Add devlink rate police sub-test
  Documentation: devlink rate objects limit_type

 .../networking/devlink/devlink-port.rst       |  44 ++-
 .../networking/devlink/netdevsim.rst          |   3 +-
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c |  28 +-
 drivers/net/netdevsim/dev.c                   | 211 ++++++++++-
 drivers/net/netdevsim/netdevsim.h             |  11 +-
 include/net/devlink.h                         |  52 ++-
 include/uapi/linux/devlink.h                  |  15 +
 net/core/devlink.c                            | 336 ++++++++++++++++--
 .../drivers/net/netdevsim/devlink.sh          | 215 ++++++++++-
 9 files changed, 853 insertions(+), 62 deletions(-)

-- 
2.36.1

