Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828BA3F2FF4
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241230AbhHTPrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:47:06 -0400
Received: from mail-dm6nam10on2078.outbound.protection.outlook.com ([40.107.93.78]:7122
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241245AbhHTPrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 11:47:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ewp8BWBkLI7ACyIHTI3TypGQ29PqcNlKbAR0kB/bKXQV4CwFycSYi5/+jfvD6+2IeI0Qd9gr3eXh1U4ql4gBeAk6kEiGcOZ5n2RnmOcIynt1W7GiJ/az3JQgzMuqvz+FKG9OQKAQ6HiCLm+ZZR0GdYiZmjQa8lqcLrxld/ECecERLWLPgy6aPviz72/AQ7yoeya7aOUE2wAyiZhm+VYi47qd0JQG663VV/5sOq1HI6rmXBnxF2K2e/UN6u7P9xwxxemIa4BNGra3VbcludNHzNEdohYK19JxV0UonacGM+GwAm4Fz3QE+ByfJzKKtClvnEDHohdhwP2Exh5Xc6ebYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1VFQaTVeAjAfLvW9Kq7ixDbcnUlFCG+dBP4Tp71OLzg=;
 b=Q01LAEqKjcasxjH8xMQHq3xr56aCexSW1RnmZ1Z2WptyJ8baqif/ZrfrVHSyiFbeqkaCvJntc/6OKcu3N3A+2+/Ekc53qO/a+3LzjScoWRCSjCV4Jt9z+/mmJnJ1I+PEwPCpbNXUHLeLC1OYSRXklsJE/hkOhF68twmpYEQbHJz3VK8PiWa/gBjAmIpMFO5QneWFAvIDii6afQo7WY/pBscYH0ZQGfOTS2fKGSEG4v5uBIlhMLt2jhRVaodfkZsNu6GbaqolrWUVJpiAUSWqK+fQHZoSRiX8x67PfAFeg+ngF8ke2bLYpUO21qXMv2sVAqEaQ/ApilNUle4L5iKsTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=ti.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=quarantine sp=none pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1VFQaTVeAjAfLvW9Kq7ixDbcnUlFCG+dBP4Tp71OLzg=;
 b=ELKpdEF8tQTUCMofY0x9DsPbA9Uxfti5YR72/JBq4eigw7vuv9Vrgbwkz2Zn264OMJMPkcLyLC3zO27OUpDbABOiig0V/dfOEhzv4D8ozk4Mtm9JQ321loM65Bj13aPPEgTh4sPqrL8dsGJg6o5EGoNFslck0xzHOvaFXNpI/aVxjpyoojkoxgRexE09MI/IllFmRzXhYvAXs1Pg7O1kZtNMckqbBSu+OxbOg98Mea/UP2GMSeogvcgfPLzWYHIFV1C+4OfMnUnTHMIj1umj+l4/k4AhZwIMcIKLfEaa008DRNFx+ve9bVKsuYaVQO/QEkRvAmBPV4iPPn8w00zwpw==
Received: from BN6PR13CA0063.namprd13.prod.outlook.com (2603:10b6:404:11::25)
 by CH2PR12MB4908.namprd12.prod.outlook.com (2603:10b6:610:6b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Fri, 20 Aug
 2021 15:46:24 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:11:cafe::65) by BN6PR13CA0063.outlook.office365.com
 (2603:10b6:404:11::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend
 Transport; Fri, 20 Aug 2021 15:46:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; ti.com; dkim=none (message not signed)
 header.d=none;ti.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 15:46:24 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 20 Aug
 2021 08:46:23 -0700
Received: from reg-r-vrt-018-180.nvidia.com (172.20.187.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 20 Aug 2021 15:46:14 +0000
References: <20210820115746.3701811-1-vladimir.oltean@nxp.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        "Nikolay Aleksandrov" <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "Ido Schimmel" <idosch@nvidia.com>, <UNGLinuxDriver@microchip.com>,
        "Grygorii Strashko" <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        "DENG Qingfang" <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Hauke Mehrtens" <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "Sean Wang" <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        "Vignesh Raghavendra" <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 0/7] Make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
 blocking
In-Reply-To: <20210820115746.3701811-1-vladimir.oltean@nxp.com>
Date:   Fri, 20 Aug 2021 18:46:11 +0300
Message-ID: <ygnhzgtcnmpo.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1232214-50fa-458d-52d3-08d963f1aa5a
X-MS-TrafficTypeDiagnostic: CH2PR12MB4908:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4908AE9FB1362EA8877C8828A0C19@CH2PR12MB4908.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8vhrpoQiEzqgmQdmOr/FPYfGsjULOglsjHbR/s+UYC2JYLYwgKZm+e4/Kc8SXvwhC+M0mj9HO1jFvTN3d7AjZMtE0UUNdBX4BFkfF1vNgob1bfos9+ddHvRJnO1CtCDsV4MI13ib/jEl5cfria5QL1GhuTbU/ovo10eslal+QWxHXPhkXYYcXlpfCR+692QYsRnlq5Y46plvTWSDU1f6hefDOSLJR3DDRoWhZarGM857hvRU3hlxBSoAeZuwFNmzseHbp6XP2/+b+rwvFcHmf/pHnjHTtinEJZ3VwmrrI2UpO4t2X91v2fVJ/uKRAy208L2n3+Ew981f3S/AmgaNrqnwnluvGQrKgOh0WeG/IBjtHSf2o52GRtjDR3WZwkVPWRItAJPBv27M8u24oYXkoJJsYkVLphNxckzA7S3c6/zW3f018lolGkWsp1GE85gbXu+2SQWSansY85j9TMhORerbJ16pUBitUqYJ1CTx3dQpv0tjqjlNdYyv24c6PaAGxiI/Onq5nnUNbdPJ29d8jLwPa6xFwdnTat5mOLqhuC/Mi4QNSFCa4Hd0X243QqjGXmw3l3bwtVpd4kDuwyhHuK4GJFehWSIs+3NHSzxfdzEip1dinnHVYk4uW4FjJix7YC9jPksp+GiPKiEtfO4xK67CMID16OLYGPqQjAQatLiQxFsPR9p0wCgN93NFVPjMSbzirnJ6NByh894LGI95X0jKtz3NjhxqzcfNwywu3sXEPPTjNlL1W9TqzkqThirBO/1AjWa0zKgsb6tCAnIe9qpIECh6Y0ij6dQRenENo+pAYN4bLXw30jZHjY5+/30e
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(346002)(36840700001)(46966006)(186003)(7416002)(2906002)(356005)(83380400001)(4326008)(70586007)(7636003)(966005)(6916009)(66574015)(70206006)(54906003)(316002)(8676002)(26005)(82740400003)(6666004)(5660300002)(36860700001)(36756003)(2616005)(82310400003)(426003)(86362001)(8936002)(336012)(7696005)(16526019)(478600001)(47076005)(7406005)(4226004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 15:46:24.3971
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1232214-50fa-458d-52d3-08d963f1aa5a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4908
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 20 Aug 2021 at 14:57, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> Problem statement:
>
> Any time a driver needs to create a private association between a bridge
> upper interface and use that association within its
> SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handler, we have an issue with FDB
> entries deleted by the bridge when the port leaves. The issue is that
> all switchdev drivers schedule a work item to have sleepable context,
> and that work item can be actually scheduled after the port has left the
> bridge, which means the association might have already been broken by
> the time the scheduled FDB work item attempts to use it.
>
> The solution is to modify switchdev to use its embedded SWITCHDEV_F_DEFER
> mechanism to make the FDB notifiers emitted from the fastpath be
> scheduled in sleepable context. All drivers are converted to handle
> SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE from their blocking notifier block
> handler (or register a blocking switchdev notifier handler if they
> didn't have one). This solves the aforementioned problem because the
> bridge waits for the switchdev deferred work items to finish before a
> port leaves (del_nbp calls switchdev_deferred_process), whereas a work
> item privately scheduled by the driver will obviously not be waited upon
> by the bridge, leading to the possibility of having the race.
>
> This is a dependency for the "DSA FDB isolation" posted here. It was
> split out of that series hence the numbering starts directly at v2.
>
> https://patchwork.kernel.org/project/netdevbpf/cover/20210818120150.892647-1-vladimir.oltean@nxp.com/
>
> Changes in v3:
> - make "addr" part of switchdev_fdb_notifier_info to avoid dangling
>   pointers not watched by RCU
> - mlx5 correction
> - build fixes in the S/390 qeth driver
>
> Vladimir Oltean (7):
>   net: bridge: move br_fdb_replay inside br_switchdev.c
>   net: switchdev: keep the MAC address by value in struct
>     switchdev_notifier_fdb_info
>   net: switchdev: move SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE to the blocking
>     notifier chain
>   net: bridge: switchdev: make br_fdb_replay offer sleepable context to
>     consumers
>   net: switchdev: drop the atomic notifier block from
>     switchdev_bridge_port_{,un}offload
>   net: switchdev: don't assume RCU context in
>     switchdev_handle_fdb_{add,del}_to_device
>   net: dsa: handle SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE synchronously
>
>  .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  75 ++++------
>  .../marvell/prestera/prestera_switchdev.c     | 104 ++++++-------
>  .../mellanox/mlx5/core/en/rep/bridge.c        |  65 +++++++--
>  .../ethernet/mellanox/mlx5/core/esw/bridge.c  |   2 +-
>  .../ethernet/mellanox/mlxsw/spectrum_router.c |   4 +-
>  .../mellanox/mlxsw/spectrum_switchdev.c       |  62 ++++++--
>  .../microchip/sparx5/sparx5_mactable.c        |   2 +-
>  .../microchip/sparx5/sparx5_switchdev.c       |  72 ++++-----
>  drivers/net/ethernet/mscc/ocelot_net.c        |   3 -
>  drivers/net/ethernet/rocker/rocker_main.c     |  67 ++++-----
>  drivers/net/ethernet/rocker/rocker_ofdpa.c    |   6 +-
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   4 +-
>  drivers/net/ethernet/ti/am65-cpsw-switchdev.c |  54 +++----
>  drivers/net/ethernet/ti/cpsw_new.c            |   4 +-
>  drivers/net/ethernet/ti/cpsw_switchdev.c      |  57 ++++----
>  drivers/s390/net/qeth_l2_main.c               |  26 ++--
>  include/net/switchdev.h                       |  33 ++++-
>  net/bridge/br.c                               |   5 +-
>  net/bridge/br_fdb.c                           |  54 -------
>  net/bridge/br_private.h                       |   6 -
>  net/bridge/br_switchdev.c                     | 128 +++++++++++++---
>  net/dsa/dsa.c                                 |  15 --
>  net/dsa/dsa_priv.h                            |  15 --
>  net/dsa/port.c                                |   3 -
>  net/dsa/slave.c                               | 138 ++++++------------
>  net/switchdev/switchdev.c                     |  61 +++++++-
>  26 files changed, 550 insertions(+), 515 deletions(-)

For mlx5 parts:

Reviewed-and-tested-by: Vlad Buslov <vladbu@nvidia.com>

