Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD076A742B
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 22:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfICUEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 16:04:32 -0400
Received: from mail-eopbgr130049.outbound.protection.outlook.com ([40.107.13.49]:2855
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725953AbfICUEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 16:04:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IdogCBTbAJ3FF5Zp4K9qvk1nRZqv3ThY/QEUF2ni4UQjSmhKFmW9TnwHK4duyb1+pnkhcgvUX+Bdl+TE9bJLIyBoRQ2aerrgyIELYkxHzJcyg2apDssAMVqMm+2X+X/IupR6Ype40IPwbODh4PFl5SrlR/qcL5iBycvHC2N3FJ7W8RvQjvAl/WiEwu/mBsmM0lhsxn2gLcj2W1LhFGw4X1Ii0dvvB0VWKFNuy+9PIFiXV6c0zpT8OwAiwJBDolY8r2B+igEXOqilhXomo/wi6FepL57Bf0CKW1kbUZpIs9dwV2Cfr7pDIuddcO784nKZsSmhB1HMux2rxkea/OCPTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkakwtzyPiKmC6PpByQPzJYjSLqix//OupwbgyfZALc=;
 b=ehR5Uphrb/Sj1z4LoC+E8qKX2Na36K/N2m5FXcSdS9b5bcuIrAB4ByR2vhsLyfR4MSSOlw70M070jmh95bk2EBdDRxr4YAu5O7CiZOaSi3ag1+Suq3eCpT8vPFQPefUvsAXZ5VhwhtO+ZB3k0fPeGBRIjKaTMr/zFK4ud4k466hci52zpZNsPzXcy6Kx3cdu7nPc8mgcmYWpFP+eJ8ssT60+cM3m4SSu43itw4vOxuL+FUV+olkWHAFzNdw4B7vzhZ2OmMQA7u7SB4NTsJTByvZUrbn+LkkfVzMKo3ZkpHLozjlzIqVmyt1Sxc/d2hlPMLOztf4GVhgAyINUj+W/Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkakwtzyPiKmC6PpByQPzJYjSLqix//OupwbgyfZALc=;
 b=MQqdWoykGGOVePoaEBvfET3V7mBuOnLKDcFSVe2K1wC/8YyqF3X6PbaYKmWmnOqSlyhByiqIaKSKBAks1t3Crvv8iwFdU1+ANAVZWBhIf7qTQNZAcx0CnImBeHbDeYdv2dYET7mGlhtJoolCOG4VYcTQ7f9syA/nGboEuJCR/6s=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2706.eurprd05.prod.outlook.com (10.172.221.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.21; Tue, 3 Sep 2019 20:04:24 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Tue, 3 Sep 2019
 20:04:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next V2 00/18] Mellanox, mlx5 software managed
 steering
Thread-Topic: [pull request][net-next V2 00/18] Mellanox, mlx5 software
 managed steering
Thread-Index: AQHVYpLIUmduP4Bh1ES5JkPxIECHVg==
Date:   Tue, 3 Sep 2019 20:04:24 +0000
Message-ID: <20190903200409.14406-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0049.namprd02.prod.outlook.com
 (2603:10b6:a03:54::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e9bca40-c44f-4be2-ec18-08d730a9ea9f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2706;
x-ms-traffictypediagnostic: AM4PR0501MB2706:|AM4PR0501MB2706:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB270626CCCF1265040823CE26BEB90@AM4PR0501MB2706.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(199004)(189003)(2906002)(102836004)(256004)(26005)(50226002)(186003)(66446008)(386003)(6506007)(64756008)(66556008)(14444005)(66476007)(71190400001)(66946007)(2616005)(476003)(71200400001)(5660300002)(8936002)(66066001)(81166006)(81156014)(30864003)(478600001)(54906003)(6916009)(8676002)(486006)(36756003)(3846002)(7736002)(53936002)(6436002)(305945005)(14454004)(6116002)(52116002)(6512007)(86362001)(316002)(99286004)(1076003)(6486002)(4326008)(107886003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2706;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2oI2AzNCeFQtluS3WxFtyosKMVqSz+v7bH1ra5ja1v9V4pKUzZrijTY013ml0YlrZu1nZnJOrPoI7z5ZbpeNlMt4eQqiBQyvsjpgDxsUN730R4awNl7k/JLhmE1+uYDAZ4VXYQl7purCQbRuL/jNhU54Jj0Yhzy+S5zXezlVvACpC88C6zTYgdi4JznZ6joNpPDprW8Ewer1CMaoft3elAEM1fYzm/ANBN03b3IdGRPZ8uWWpJE0fXNsQmhuOUhOmoRR+S4oNftUuUktl67Xk8b+OzdgWRbO9MeONs+kvU8zP2TXNVonCDq0G/a8g5JnlHkAU2psG8XcSwjXIrFAcxtXu9mitp2JY/TEd8Zesc9KHpHKlNKuC1FXG54uYLWVoqhIzn9eoiiE8GbIwaym8ia+SLlktj11M/jwr1jnx3g=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e9bca40-c44f-4be2-ec18-08d730a9ea9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 20:04:24.5867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jdO+j8RSw5Q6aG5RAbvlhfKoz4gH8oVnvM1VuFFuXnh3m/kcTa8hynamEtoVN9Cy/ywtii8pwC+aM1ESfNDKLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2706
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series adds the support for software (driver managed) flow steering.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Please note that the series starts with a merge of mlx5-next branch,
to resolve and avoid dependency with rdma tree.

v2:
 - Improve return values transformation of the first patch.

Thanks,
Saeed.

---
The following changes since commit a06ebb8d953b4100236f3057be51d67640e06323=
:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git=
/mellanox/linux (2019-09-02 00:16:05 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2019-09-01-v2

for you to fetch changes up to e890acd5ff18a0144967d0289869fe5f0415d399:

  net/mlx5: Add devlink flow_steering_mode parameter (2019-09-03 12:54:24 -=
0700)

----------------------------------------------------------------
mlx5-updates-2019-09-01  (Software steering support)

Abstract:
--------
Mellanox ConnetX devices supports packet matching, packet modification and
redirection. These functionalities are also referred to as flow-steering.
To configure a steering rule, the rule is written to the device owned
memory, this memory is accessed and cached by the device when processing
a packet.
Steering rules are constructed from multiple steering entries (STE).

Rules are configured using the Firmware command interface. The Firmware
processes the given driver command and translates them to STEs, then
writes them to the device memory in the current steering tables.
This process is slow due to the architecture of the command interface and
the processing complexity of each rule.

The highlight of this patchset is to cut the middle man (The firmware) and
do steering rules programming into device directly from the driver, with
no firmware intervention whatsoever.

Motivation:
-----------
Software (driver managed) steering allows for high rule insertion rates
compared to the FW steering described above, this is achieved by using
internal RDMA writes to the device owned memory instead of the slow
command interface to program steering rules.

Software (driver managed) steering, doesn't depend on new FW
for new steering functionality, new implementations can be done in the
driver skipping the FW layer.

Performance:
------------
The insertion rate on a single core using the new approach allows
programming ~300K rules per sec. (Done via direct raw test to the new mlx5
sw steering layer, without any kernel layer involved).

Test: TC L2 rules
33K/s with Software steering (this patchset).
5K/s  with FW and current driver.
This will improve OVS based solution performance.

Architecture and implementation details:
----------------------------------------
Software steering will be dynamically selected via devlink device
parameter. Example:
$ devlink dev param show pci/0000:06:00.0 name flow_steering_mode
          pci/0000:06:00.0:
          name flow_steering_mode type driver-specific
          values:
             cmode runtime value smfs

mlx5 software steering module a.k.a (DR - Direct Rule) is implemented
and contained in mlx5/core/steering directory and controlled by
MLX5_SW_STEERING kconfig flag.

mlx5 core steering layer (fs_core) already provides a shim layer for
implementing different steering mechanisms, software steering will
leverage that as seen at the end of this series.

When Software Steering for a specific steering domain
(NIC/RDMA/Vport/ESwitch, etc ..) is supported, it will cause rules
targeting this domain to be created using  SW steering instead of FW.

The implementation includes:
Domain - The steering domain is the object that all other object resides
    in. It holds the memory allocator, send engine, locks and other shared
    data needed by lower objects such as table, matcher, rule, action.
    Each domain can contain multiple tables. Domain is equivalent to
    namespaces e.g (NIC/RDMA/Vport/ESwitch, etc ..) as implemented
    currently in mlx5_core fs_core (flow steering core).

Table - Table objects are used for holding multiple matchers, each table
    has a level used to prevent processing loops. Packets are being
    directed to this table once it is set as the root table, this is done
    by fs_core using a FW command. A packet is being processed inside the
    table matcher by matcher until a successful hit, otherwise the packet
    will perform the default action.

Matcher - Matchers objects are used to specify the fields mask for
    matching when processing a packet. A matcher belongs to a table, each
    matcher can hold multiple rules, each rule with different matching
    values corresponding to the matcher mask. Each matcher has a priority
    used for rule processing order inside the table.

Action - Action objects are created to specify different steering actions
    such as count, reformat (encapsulate, decapsulate, ...), modify
    header, forward to table and many other actions. When creating a rule
    a sequence of actions can be provided to be executed on a successful
    match.

Rule - Rule objects are used to specify a specific match on packets as
    well as the actions that should be executed. A rule belongs to a
    matcher.

STE - This layer is used to hold the specific STE format for the device
    and to convert the requested rule to STEs. Each rule is constructed of
    an STE chain, Multiple rules construct a steering graph. Each node in
    the graph is a hash table containing multiple STEs. The index of each
    STE in the hash table is being calculated using a CRC32 hash function.

Memory pool - Used for managing and caching device owned memory for rule
    insertion. The memory is being allocated using DM (device memory) API.

Communication with device - layer for standard RDMA operation using  RC QP
    to configure the device steering.

Command utility - This module holds all of the FW commands that are
    required for SW steering to function.

Patch planning and files:
-------------------------
1) First patch, adds the support to Add flow steering actions to fs_cmd
shim layer.

2) Next 12 patch will add a file per each Software steering
functionality/module as described above. (See patches with title: DR, *)

3) Add CONFIG_MLX5_SW_STEERING for software steering support and enable
build with the new files

4) Next two patches will add the support for software steering in mlx5
steering shim layer
net/mlx5: Add API to set the namespace steering mode
net/mlx5: Add direct rule fs_cmd implementation

5) Last two patches will add the new devlink parameter to select mlx5
steering mode, will be valid only for switchdev mode for now.
Two modes are supported:
    1. DMFS - Device managed flow steering
    2. SMFS - Software/Driver managed flow steering.

    In the DMFS mode, the HW steering entities are created through the
    FW. In the SMFS mode this entities are created though the driver
    directly.

    The driver will use the devlink steering mode only if the steering
    domain supports it, for now SMFS will manages only the switchdev
    eswitch steering domain.

    User command examples:
    - Set SMFS flow steering mode::

        $ devlink dev param set pci/0000:06:00.0 name flow_steering_mode va=
lue "smfs" cmode runtime

    - Read device flow steering mode::

        $ devlink dev param show pci/0000:06:00.0 name flow_steering_mode
          pci/0000:06:00.0:
          name flow_steering_mode type driver-specific
          values:
             cmode runtime value smfs

----------------------------------------------------------------
Alex Vesker (13):
      net/mlx5: DR, Add the internal direct rule types definitions
      net/mlx5: DR, Add direct rule command utilities
      net/mlx5: DR, ICM pool memory allocator
      net/mlx5: DR, Expose an internal API to issue RDMA operations
      net/mlx5: DR, Add Steering entry (STE) utilities
      net/mlx5: DR, Expose steering domain functionality
      net/mlx5: DR, Expose steering table functionality
      net/mlx5: DR, Expose steering matcher functionality
      net/mlx5: DR, Expose steering action functionality
      net/mlx5: DR, Expose steering rule functionality
      net/mlx5: DR, Add required FW steering functionality
      net/mlx5: DR, Expose APIs for direct rule managing
      net/mlx5: DR, Add CONFIG_MLX5_SW_STEERING for software steering suppo=
rt

Maor Gottlieb (5):
      net/mlx5: Add flow steering actions to fs_cmd shim layer
      net/mlx5: Add direct rule fs_cmd implementation
      net/mlx5: Add API to set the namespace steering mode
      net/mlx5: Add support to use SMFS in switchdev mode
      net/mlx5: Add devlink flow_steering_mode parameter

 .../networking/device_drivers/mellanox/mlx5.rst    |   33 +
 drivers/infiniband/hw/mlx5/flow.c                  |   21 +-
 drivers/infiniband/hw/mlx5/main.c                  |    7 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |    5 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |    7 +
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    7 +
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  112 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |   27 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   46 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |    7 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   87 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |  116 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h   |   25 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  160 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   39 +-
 .../ethernet/mellanox/mlx5/core/steering/Makefile  |    2 +
 .../mellanox/mlx5/core/steering/dr_action.c        | 1588 ++++++++++++++
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |  480 ++++
 .../mellanox/mlx5/core/steering/dr_crc32.c         |   98 +
 .../mellanox/mlx5/core/steering/dr_domain.c        |  395 ++++
 .../ethernet/mellanox/mlx5/core/steering/dr_fw.c   |   93 +
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      |  570 +++++
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  770 +++++++
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c | 1243 +++++++++++
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |  976 +++++++++
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  | 2308 ++++++++++++++++=
++++
 .../mellanox/mlx5/core/steering/dr_table.c         |  294 +++
 .../mellanox/mlx5/core/steering/dr_types.h         | 1060 +++++++++
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  600 +++++
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.h   |   60 +
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h      |  604 +++++
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |  212 ++
 include/linux/mlx5/fs.h                            |   33 +-
 34 files changed, 11967 insertions(+), 120 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/Makefi=
le
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_act=
ion.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd=
.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_crc=
32.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dom=
ain.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.=
c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm=
_pool.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_mat=
cher.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rul=
e.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_sen=
d.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste=
.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_tab=
le.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_typ=
es.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.=
c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.=
h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_i=
fc_dr.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr=
.h
