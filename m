Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F4B1EBA69
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 13:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgFBLbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 07:31:45 -0400
Received: from mail-eopbgr50082.outbound.protection.outlook.com ([40.107.5.82]:16448
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725900AbgFBLbo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 07:31:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a3sB1CW1eLBW+zeI7EpcoSKPhuFrKAWo0VWJoTKNg4XKfV9c1pvZ1qcMInPMyrwSGp2Y4jBWJy22Gn3VMNJj241x3k8MX2wfDE1B5DIVAp+f5F4uRoaHaoPOQwKpuPax7U46y9aAhkSbtLt2nBqDc34aCcqWrYC+KxcZ+/sU3N/ix154NEb8PSf2lITvMq7Y3qa4oyU/W86z2gmqpJm7NRMrZuCLoGRBp/6fWcQeZwnRt+wGNTbQfmnacl8jIjlNds/zbq4yg7PY99Aqe1c+f17XigydhYiYNPQ7SggP859PGRrpKZUutSVPg9gRv1S3cZooibgL7tJPMreq73f7YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tROyH7m2CJHJ3QKnVshCOY+bTV57H1oXZK3fHWZ86XY=;
 b=AQSjYoJeiohRiniKuIjw/IdcL+jw8SZCA7YVASXshgswvPgGkeP+qjc+yC7eRWMNHkY3BrzZB9YF1GaRFdTGbHtj5GTmZK55vQ9CcckSr/FMHkLuMkGsfuZgPv8knfJPfbwQ+scXUFRWJlo96iaxsIjBEQosICM7a2p0697FbLgotCvB1mC7mt4t1nTDKHTiJflIn813InIYOCtyHxIMardiO+NzJgenNtAETEOeC5xgHOOamqJY14mZZsUG/yleV6F/e/NA2pyN6pux2mplz+9CIQqX8OKjz7JEU5sguZXCz2zPuqVK3Z7jj5Ijj/I8hYWvFu7yRvG1d8ClkyHpLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tROyH7m2CJHJ3QKnVshCOY+bTV57H1oXZK3fHWZ86XY=;
 b=DDWqVGhnvESAiXNLK0x5aEqfeBy2HUkShwI9Bq8jJyKJxPo+018lsNN0A+Jm/LHuODTKfe7Kln85fc4g2Qxg7fQesmQOBrEOcntHbPgWT6xykj7+vYx+NsX7012yJYueQoYdFWFqvjSw8cas45PuQTPc5XbHe08HJOJnzxgdeBM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB4129.eurprd05.prod.outlook.com (2603:10a6:208:64::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Tue, 2 Jun
 2020 11:31:40 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182%6]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 11:31:40 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, michael.chan@broadcom.com, kuba@kernel.org,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, mlxsw@mellanox.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [RFC PATCH net-next 0/8] Expose devlink port attributes
Date:   Tue,  2 Jun 2020 14:31:11 +0300
Message-Id: <20200602113119.36665-1-danieller@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::24) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21 via Frontend Transport; Tue, 2 Jun 2020 11:31:37 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 470c75b2-ea40-41e1-6b46-08d806e88460
X-MS-TrafficTypeDiagnostic: AM0PR05MB4129:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB41299D05F61271CD94FD055BD58B0@AM0PR05MB4129.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wo1FgWU0mEmpfJ3JuA19EpCk+Jrz32Nk2I7dmBPuKPPV8sxVjwGm1cnwxFwk9CXpR7/ezXhoU/rfd4fScNoCOpy9mMQht9/YHPtyVqikS/zivs31Y5LXDO/CLnbxYwRWWEYFS/m3ajp0S3jBsgwCj00yXT6E/a2A1hdwYg23jGPX568XXZWabvVjqS7mQcHj+tAnvr0VY6Q0N5OT6FmKd0s1E6wnCVVMCGorZHUrjsqbD4NALlBPpuCmVe3plC2XQRMv4ttEwvhapDy3eNU4OVBb4B+/AROZvwQaLg7JCS7UQbyhW4LA8rX/2r41EwMdVsT7lX8SZ2b1FaLDXCPhmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(4326008)(7416002)(6506007)(478600001)(6916009)(52116002)(6486002)(2906002)(36756003)(5660300002)(316002)(6666004)(1076003)(26005)(86362001)(83380400001)(66946007)(66556008)(66476007)(16526019)(186003)(107886003)(8936002)(6512007)(2616005)(956004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VRdcbNzEwqbe0Rjxe2jJEevMJkw7bSGQrv2B++9agIQFkdXfm2kJCVAa+PJlkDFpdTkCb3npy8TUcaSvLrr0r9cFexUymHhcrkny2iB0LkgdhWdWnvZWcWI0aNT5HqncwOJzVjbAt4Ds+G+IhbB/TNoA3aahYanPy7HqQwWFq2qcbdiDuy7LluqO0eWM86ngRaa0eJetNovACCieVoJT4BKD3BPp4nwzjoWtP6c+3UdwrhUpCyLxrNRmBlW0VRjN0gpN0yRhLxanA60f62rk7HnDFyUv4yuNY2NOQyL7o5CJ9GtNoVY2gr0SRKxM7/s9TMbkhcPW4lbnhckVjya9QSH5u6UbgGeRu2GtikLd5w2y4KnnGRw9HIuH7Fi8cDNTqt0eEi1ia255/IBu1Y9avUKurPzez1A3pvYAavgUEl+Ju/ooMPzQaDOvGLrTroGOKuC/5aKDR7mXHrs1RomleCh2ZZ9nPkiEe9NWCSYwR8wykD7gml1tfM65OA1BIjND
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 470c75b2-ea40-41e1-6b46-08d806e88460
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 11:31:40.3651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PRlQCXzVnU1OPaihSEPw4aimVZJgdTX1QuhWnYtcWQkJ4jlB0uN6Xrs12A2EvX8ALNqprn/zDzjzDacFFCbtHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, user has no way of knowing if a port can be split and into
how many ports.

Among other things, it is currently impossible to write generic tests
for port split.

In order to be able to expose the information regarding the split
capability to user space, set the required attributes and pass them to
netlink.

Patch 1: Move set attribute from devlink_port_attrs to devlink_port.
Patch 2: Move switch_port attribute from devlink_port_attrs to devlink_port
Patch 3: Replace devlink_port_attrs_set parameters with a struct.
Patch 4: Set and initialize lanes attribute in the driver.
Patch 5: Add lanes attribute to devlink port and pass to netlink.
Patch 6: Set and initialize splittable attribute in the driver.
Patch 7: Add splittable attribute to devlink port and pass them to netlink.
Patch 8: Add a split port test.


Danielle Ratson (8):
  devlink: Move set attribute of devlink_port_attrs to devlink_port
  devlink: Move switch_port attribute of devlink_port_attrs to
    devlink_port
  devlink: Replace devlink_port_attrs_set parameters with a struct
  mlxsw: Set number of port lanes attribute in driver
  devlink: Add a new devlink port lanes attribute and pass to netlink
  mlxsw: Set port split ability attribute in driver
  devlink: Add a new devlink port split ability attribute and pass to
    netlink
  selftests: net: Add port split test

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  13 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  |   6 +-
 .../ethernet/mellanox/mlx5/core/en/devlink.c  |  19 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  20 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  18 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |   4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   6 +-
 .../net/ethernet/mellanox/mlxsw/switchib.c    |   2 +-
 .../net/ethernet/mellanox/mlxsw/switchx2.c    |   2 +-
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  12 +-
 .../ethernet/pensando/ionic/ionic_devlink.c   |   5 +-
 drivers/net/netdevsim/dev.c                   |  14 +-
 include/net/devlink.h                         |  20 +-
 include/uapi/linux/devlink.h                  |   3 +
 net/core/devlink.c                            |  86 +++---
 net/dsa/dsa2.c                                |  17 +-
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/devlink_port_split.py       | 259 ++++++++++++++++++
 19 files changed, 399 insertions(+), 112 deletions(-)
 create mode 100755 tools/testing/selftests/net/devlink_port_split.py

-- 
2.20.1

