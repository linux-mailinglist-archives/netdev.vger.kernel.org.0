Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A33D1F0C2B
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 17:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgFGPAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 11:00:11 -0400
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:48904
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726528AbgFGPAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 11:00:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AbrNYNAYSN34ytYPjzX1Sh4cVh1i7y9yUHTZM9UFtf84q3EK+aibo2J3959yBnrkR/bqdJ1fcQaWeS8roFYF2Wn4hLrPbv9fHn/6cXHANLzplSL+eJRQvRH8ihWKOXmMft36B3MI4ADWhglMjS3UW47CUHkRPUnInQhERkfqDe0xxgxGkWrSdXsiB4n8hSRM7eR7GcrkTTGw1IJxSij8yGdeqYPIl25mIq6O6+AVckRxbLgf8uS54IBgbf0/vtMyAcC9LJu3aIAWVN//h2LFvjhmBlaPBqEmXdg3RHJeZdzm45DKRgDoIOOVEhS1hXFgPjMxyMfRpUS6v/KGbxFIuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4H3ZYKBD0d8wSPg3602TbYTzd2fx+MyhEmZNwptvcF0=;
 b=Pq+vxI32ODa0Na+SKXJPx6RwD8quVkOwNXh7ohYneH2IarLUlTVjvEmjKLt4axq16yiqQsyYsfQIsMq1XNq/wtAgRkUEEWYmSQPJlhndthtJfy20qp7nS5FF6taIiFC7bWiBhVRaaVRsIh/TGeRy/uL8AkZYnORiciXAsN5Oq3UD/iOoXxFsuQsJhuLpfqoxsT+9cfcZfsDEo7T40NZ44ATKTGKN6034Z72ujurU3uHlIDLOixLs6SwsqdNUklcrlqV/U6YEdJ4ra+0qNv704s9HTjno8xtrGo5omfZ6SCwwfy8UPmDAulogEzcYhcKIUJ+Ih2ZAZgyoWiIp2xEdQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4H3ZYKBD0d8wSPg3602TbYTzd2fx+MyhEmZNwptvcF0=;
 b=NRypGVuT5+WL1Uk9a9Q6dswAl9FTaYg8XRvvVHM2Uq+x8V9DH6Ssm1BwGrlGOOFNHMRziRrgIZBeJIXdd3GGU+KQ3JuYckx7pUBAKgm4iPDWNXtrObFepL9Apfxo4qqcB7Ywl22Um1JPekAwfwbFGpu7J6imdOURyKHNFuY/e3Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR0502MB4003.eurprd05.prod.outlook.com
 (2603:10a6:208:2::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.23; Sun, 7 Jun
 2020 15:00:05 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b%7]) with mapi id 15.20.3066.023; Sun, 7 Jun 2020
 15:00:05 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com, amitc@mellanox.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [RFC PATCH net-next 00/10] Add extended state
Date:   Sun,  7 Jun 2020 17:59:35 +0300
Message-Id: <20200607145945.30559-1-amitc@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::25) To AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Sun, 7 Jun 2020 15:00:03 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b30a47bb-2987-4403-fca6-08d80af3767a
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4003:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB40035F250984EF19CA155D49D7840@AM0PR0502MB4003.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 04270EF89C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gW3RjIla2duUG6hmSylELTC2O6rgHUwNmW51bnqtDMNrZ14dioM2PRyGm/Z+SbKqpvZRUOq9jU2RbCq2t54KOJ+yEZbpmnpJ4MEol7G4gQuBeX1f5Tjzic4k7owvbprrHHROg+VL32atKo5cx+eAIbolCF4TE0xbizOwx0TNWLLMu2TWE+yCnlB53x396pqq48xUAbpI0eoYYng3ZL3wpm0lne9+zSa8IfwTYLz1AyyJ+vMZlNdlSKB6+R71jucGQ4Nwa17V32SjhaQaYi+X0RCsbjB0Ufxi2AFbWBq1ykjrTu7+oEJCdNCIJ3A57P+6X/Qpy0ftebwUdjF5x9380A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(66476007)(66946007)(66556008)(1076003)(186003)(8936002)(16526019)(26005)(52116002)(478600001)(6506007)(36756003)(2906002)(6666004)(7416002)(5660300002)(8676002)(4326008)(83380400001)(6486002)(316002)(86362001)(6916009)(2616005)(956004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XaVXTVBnwVv4dzgwqMfkqcWVeClQsqtmMClljLKhv63X3BCPzbIUiZyHw9WuBIxe8Z8T9ZPnRww2Ib76EGyXaIxu6LK4Vs5VbR0FlZUmRhkdor8En1CGv9snX/RBDArA8uLqu/YGiN6oT4J1Kym0Yynllgm1K+2s8Ys2uKVVlhvVwPF8cXRZ9qwwYnnK8NOdz9Pu3KPQx0CGn2bMR9dJabMdpS9jf/Om0+E99fxvNp+At5kugQDUJ+DfhnGpDRbJC4dmPYMrg0/Pw7HL/gTEBVjVOtLH7glR49EYoZn8eiiRyMAfXq4Atzg6ORbEoIocwSc7++Hjq3LWDlMiXaLgI7h8qAy5wvMF+ADxcE8JfOMY9/H+f2To9LPNVC2hrmHYdwhRdX690A6r4SHiBYt54s1aLBU8/jK5nk6IzNYNnC9VrysMY4GQrpywmg/uyrliLK4orqKusjEk1SQaxN7zUppd50p/PuQAeu8R+JA5v9U=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b30a47bb-2987-4403-fca6-08d80af3767a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2020 15:00:05.6735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y2HrzcMKhN68ByauLRWJ6NjZ6ZbGhss5ex2Y2BITizoicgQSlhMSl92FMZJGSitc9VWFKzlbhE0vJG0LxYSDWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4003
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, drivers can only tell whether the link is up/down,
but no additional information is given.

This patch set provides an infrastructure that allows drivers to expose
to the user more information in addition to the link state.

This information can save users time which will not be wasted
trying to understand why the link is not up for example.

Expand the existing LINKSTATE_GET command with attributes for extended
state.

From userspace, user can see the extended state like:
$ ethtool ethX
...
Link detected: no (No cable)

In addition, when drivers have another information about the general
extended state, it can be passed also using substate field.

From userspace:
$ ethtool ethX
...
Link detected: no (Autoneg failure, No partner detected)

In the future the infrastructure can be used for example by PHY drivers to
report whether a downshift to a lower speed occurred, something like:
$ ethtool ethX
...
Link detected: yes (downshifted)

Patches #1-#3 Move mlxsw ethtool code to separate file
Patches #4-#5 Add infrastructure in ethtool
Patches #6-#7 Add support of extended state in mlxsw driver
Patches #8-#10 Add tests cases

Amit Cohen (10):
  mlxsw: spectrum_dcb: Rename mlxsw_sp_port_headroom_set()
  mlxsw: Move ethtool_ops to spectrum_ethtool.c
  mlxsw: spectrum_ethtool: Move mlxsw_sp_port_type_speed_ops structs
  ethtool: Add link extended state
  Documentation: networking: ethtool-netlink: Add link extended state
  mlxsw: reg: Port Diagnostics Database Register
  mlxsw: spectrum_ethtool: Add link extended state
  selftests: forwarding: ethtool: Move different_speeds_get() to
    ethtool_lib
  selftests: forwarding: forwarding.config.sample: Add port with no
    cable connected
  selftests: forwarding: Add tests for ethtool extended state

 Documentation/networking/ethtool-netlink.rst  |   56 +-
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |    3 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   51 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 1540 +---------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   45 +
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    |    6 +-
 .../mellanox/mlxsw/spectrum_ethtool.c         | 1641 +++++++++++++++++
 include/linux/ethtool.h                       |   22 +
 include/uapi/linux/ethtool.h                  |   70 +
 include/uapi/linux/ethtool_netlink.h          |    2 +
 net/ethtool/linkstate.c                       |   40 +
 .../selftests/net/forwarding/ethtool.sh       |   17 -
 .../net/forwarding/ethtool_extended_state.sh  |  103 ++
 .../selftests/net/forwarding/ethtool_lib.sh   |   17 +
 .../net/forwarding/forwarding.config.sample   |    3 +
 15 files changed, 2057 insertions(+), 1559 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool_extended_state.sh

-- 
2.20.1

