Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69ADF504CC9
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiDRGqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiDRGqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:46:06 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2066.outbound.protection.outlook.com [40.107.101.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D88213DEA
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 23:43:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUyIprgFfkw1pPT7Ocjffks6wqt0+r+l5sdZyVZSIAn6sdjyzjeK9AIqUsK4e1x0mrZyjgHzUfh5UTcGS8TBz9SD3l/CLg7Kk7qlroDfTN8UtAwvnuMtDkq0/Qt6aBjlXsDnUohzs5TDldgcAHzQKkOxul8sOwnpsbuBgnu/Claq6Z39wnkBS6vBoiyM0v3b1TO1KmoUDbMr83/gK8tTH83Jonq2BZocOwyf5E37MToFhCTjk/w22L47QVSBBzn0e8mn5heIZHLG/W8xd4RUS4vw++6YE7kUQTtmQmU8KpbwS1qE5+oXVr+2Lj/CLMEM3xYcH/wu8E/22NjkDohehQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v/EwIwL+tV3DPJuxLnYY8Sx4l7gwA6uWUqGplDedS0g=;
 b=gghSDvheWDeVv7+t7/t4vmmfKOHUHOmXwwyMRxgAdloC4HjKW0zQolQvMU02t9CrU3OQk1hjYajCSL+Zf9gHASGG+u5Zf2Ec5BxbmSb3ObgkzN6MUZydbzpF+SPz5rk66rd+2/Pad70FAdMavwDmEYk+GJa5+Ixs9L1SX2NMz9OoksbwyYVqqqlV6JixxefTqBAgZS9tJBH7ieVC+l71lZSiaisk0BdBM4JKis7XV5W5a2OzMBj0+KcrDTh/EqaJPx40LWqG6TprGPCp+NE0YYggij97JBcUXiOFNzQuPqNPiHMed5WAKix+HgpjlCNgLu+2a7AbX6wRcTrg6VJJZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/EwIwL+tV3DPJuxLnYY8Sx4l7gwA6uWUqGplDedS0g=;
 b=sbSVbkmo0SwfxBG1tBfp4WOKwcKjHtt8oZQNMtEWrGve7U4YeLeNH73I05o6NpfC0OptrJRy4Q1OzpfbxG9wovX7TQZwG89KmEL6WEQRH9giLbmHZWrujSDZvQlBHw2gDSSri2B9o4E8vLBTE6a3erodBMuAfzCKBLTdchEyHRPC2zIKizKRK0s/epeX2/zBMKNgutjVA9xEQZRZAd3ku7usVh5jEVrfAAbngCTEfiKyeAPXlRN657+grzMj6Vf631hLrfT4g5gCgR2nJ9GUKpDn1JwwaOn9ysu2JcdLukImjoadllHFjVvaPPob7m3yPnInjWrbGjamlzBRP9hU3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by PH0PR12MB5420.namprd12.prod.outlook.com (2603:10b6:510:e8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:43:26 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:43:26 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/17] Introduce line card support for modular switch
Date:   Mon, 18 Apr 2022 09:42:24 +0300
Message-Id: <20220418064241.2925668-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0138.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::30) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a554f8be-7f85-42af-653e-08da2106bd63
X-MS-TrafficTypeDiagnostic: PH0PR12MB5420:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB5420B42AB0C94DDD671AE5CCB2F39@PH0PR12MB5420.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A62nVzAsHehGBlbo8MVc03Zpr9PgOTQ82fBi56+htwo+LzNaTkP9e9tfYhB7MIpj2O/U22cu5I0QVAUh88LQQWSzpqzdg+GAvLWkh66WH5yf+7AyGreV2q8faRYSzTxYl8JFV7d8p9to81fX/sqOrdsIiPxMvNIdWuqB6TJa/hnFfuCNo46NHd7755lklGKfFWIHnrc1n5Kax3BTpsDvvwxFyKbgsGL5v1KN7UZkmnUgkGFNp2TU3JZXA3rgfR9/hrr0j+fJPUVdylANUcDaV+5onq0aO7fyL6/ic+ky7+w0dSpil+L79t4wCe9F51lzDJEtWGRjkaoDbqP2hWV6pGjPGmw6elJIAzDz1/LIZIr5aqkrmvyn8Znq9+5+m6On52wQptSZ4gOFChVe8PPgL2qidQZVdaSokhD1cuZod7ypKTdLZwLnoa1O/hWvl8rvo/1auXlKTgruIFFHMPZHAKjF+Maocg5brnWrLsRWbnww/FxuRl9uqEXMMSxz8BN1+uTIfssYOYL/M3PkT/PfGAiSfv7aovJhIQSUEfhrFdyazj8qVl5UWFoplLqz/Y/k64Q5gl3GIIqRASE6GHuiaOg77lT7eikDnaNw7kUxdh01vquAcwGvj0UOOP0KSso25HfL8lCz8WUz7D7nyVYdgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6486002)(508600001)(1076003)(2906002)(6512007)(6506007)(86362001)(36756003)(186003)(26005)(83380400001)(66946007)(38100700002)(5660300002)(66556008)(66476007)(107886003)(2616005)(4326008)(8676002)(6916009)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gXR9I56kzK2OeLYxKUAUbvb7Xij9GTaibjxIN7wbUKY5+ulIMAhkWfE+5IKT?=
 =?us-ascii?Q?WGD3FR0aEUM34slqWb1ZEcgrTe8rXtTMn9H08ePdK3/0GQU8f63EDjuK7Zge?=
 =?us-ascii?Q?Jsiqtx61ngOtgxmwVAhXPbANj5gjhlja4YReRv5S0Y+TPNPnqK60JBNXBzJg?=
 =?us-ascii?Q?1khusdVvf1UziEq2KXpZMPmfCtYZ7LK/eVCBMSq24wxDxF7/Tb9cdmTnMD5d?=
 =?us-ascii?Q?cu//NiYys615Le+TD8Mr+NxyySn+WWUrdPO3bsPb/sZY+PMsvN+ujY7RvpJm?=
 =?us-ascii?Q?DV5aPFQehkqzYQa605aKh5kZ9nFozgn4m7NggVIq24FWe6O5EEkv4M0FGi9K?=
 =?us-ascii?Q?RgsLYVEDoFhBOEMfy7LotpnnIT3M609Lzir0toeC0hrt2OsCgcOi+Z42NQIu?=
 =?us-ascii?Q?Q03tFZHY8OZqPcE/qZZSQV7dRGTYPrapVM2lUNlainx8Z0uYakbqRib7Usv7?=
 =?us-ascii?Q?vBkhAteFg2yUXq8Cc2vkSEuG+1X+F1TvoCZds75Xp/snxzopE1VXo0yzIvad?=
 =?us-ascii?Q?GVKt1rRLtHt5P6hLYNQOgDeShfpIxIWIwtdneFl04WUQn0Q33ahYozplvAge?=
 =?us-ascii?Q?bD7dCU98RrdU5i9HOMwJ9dkdelYRSfDahWWKraLMgt4tlHbH1o9nz+tO/wKg?=
 =?us-ascii?Q?3Mago2JP1l1fD3RV60znG9focgtM824YwkdWYa12P7xTQ/nRJh2qRskU2cNN?=
 =?us-ascii?Q?k/WfM71ihcpuDY8yXkFu8nHTJNznK3zXeMRr5FiCqek7CxWxbiQujw+yFNS7?=
 =?us-ascii?Q?H/j6PL7fnHbJJN4+XH/2Tzm+HhYNmLK1b3uwKqojeqVF0rY85e6I3d4Pi+g7?=
 =?us-ascii?Q?M2RHlxmnrGB6k1Tbd5/hP2tmM1SfsEELQFrddKhB+SD2oApxPqAT42aWGkNX?=
 =?us-ascii?Q?5Oh9TCuotFIt6ZvFhgGB4PzNt82bvJ4IvxIDKhT+5oPHZFY/7knaH5+jOSqe?=
 =?us-ascii?Q?Txh2xOcFUhji8eFzgEAUoS9l87RyRMhuB1+HWmQHH+Bq1HFQwwKAXq/UvSm/?=
 =?us-ascii?Q?/e2L3L/jHqgACDkuLE2vYKhKQtUYlNu7PauD8ckPMMgIfK4GjP5iLgXoGo7Q?=
 =?us-ascii?Q?We3y6yjyWOkOKH6+ulv5XreiqvWJWcE1/rtl7UZmdANDYlOplJiHN613j6TS?=
 =?us-ascii?Q?6pto+nk15dBxCRs/bPBKiKUU25A0tMO86zni4HX0nu1m126TZqkHwHCI4ch5?=
 =?us-ascii?Q?jCpX8ew/HssJVQE8FOhhKGJcfYLMAVRjYQzMNmuLm5/QYQ8DZoQhfdBCwuwx?=
 =?us-ascii?Q?Pc1JM5PeE4OhQVS7vS6bUjIiDF8k/oMJbgJ8+0nIBzkdQfEU1GDOEDHmDco4?=
 =?us-ascii?Q?o7RuE6vb/2H2G2UJFwuA1TjOB7FzJelNBo9P0mpJV4ZJU5+qxOyXj+E17aXz?=
 =?us-ascii?Q?hW9ZK+cYq45wwko7TINryt6b++oFZQ7cykzBDqLudosde5+ZogLWOPRZAv7N?=
 =?us-ascii?Q?HUEr2X/FlxHVxXAHrYYeP1s468A9Xj1QhCdy/5rkRxZrWEc7prL2sJijFDSH?=
 =?us-ascii?Q?kqiYJnRBeXYbdK09sImZtaINwEU8kTbZr+XXWEUtjieZa/gs/Dzg//2ArOz9?=
 =?us-ascii?Q?BeEAxGr96fxYRPebaZO1M/RNUH3xgQOG9iYSwOyijgSM2CiRV473gFj7RzQJ?=
 =?us-ascii?Q?4z7FZL1cgtioU6rzpb/bZn2eiPecGjkT2w0hVeSOdVw3YSgxOlfz9ZxOU3Me?=
 =?us-ascii?Q?tG1yVeAqnC/8351SqOx99XPG6px4V/PQTjCYMj0+NA9KQtinLMJzPdiHlPoE?=
 =?us-ascii?Q?qkDxwruu2g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a554f8be-7f85-42af-653e-08da2106bd63
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:43:26.0399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hTeTLb45H8CbiDsoleaR1d71dw/licA7cCgR5T9IZkxpPez1DvtQqwYdOfx6uIjDfg7uEO8rCVoK0no1rIBgUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5420
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri says:

This patchset introduces support for modular switch systems and also
introduces mlxsw support for NVIDIA Mellanox SN4800 modular switch.
It contains 8 slots to accommodate line cards - replaceable PHY modules
which may contain gearboxes.
Currently supported line card:
16X 100GbE (QSFP28)
Other line cards that are going to be supported:
8X 200GbE (QSFP56)
4X 400GbE (QSFP-DD)
There may be other types of line cards added in the future.

To be consistent with the port split configuration (splitter cabels),
the line card entities are treated in the similar way. The nature of
a line card is not "a pluggable device", but "a pluggable PHY module".

A concept of "provisioning" is introduced. The user may "provision"
certain slot with a line card type. Driver then creates all instances
(devlink ports, netdevices, etc) related to this line card type. It does
not matter if the line card is plugged-in at the time. User is able to
configure netdevices, devlink ports, setup port splitters, etc. From the
perspective of the switch ASIC, all is present and can be configured.

The carrier of netdevices stays down if the line card is not plugged-in.
Once the line card is inserted and activated, the carrier of
the related netdevices is then reflecting the physical line state,
same as for an ordinary fixed port.

Once user does not want to use the line card related instances
anymore, he can "unprovision" the slot. Driver then removes the
instances.

Patches 1-4 are extending devlink driver API and UAPI in order to
register, show, dump, provision and activate the line card.
Patches 5-17 are implementing the introduced API in mlxsw.
The last patch adds a selftest for mlxsw line cards.

Example:
$ devlink port # No ports are listed
$ devlink lc
pci/0000:01:00.0:
  lc 1 state unprovisioned
    supported_types:
       16x100G
  lc 2 state unprovisioned
    supported_types:
       16x100G
  lc 3 state unprovisioned
    supported_types:
       16x100G
  lc 4 state unprovisioned
    supported_types:
       16x100G
  lc 5 state unprovisioned
    supported_types:
       16x100G
  lc 6 state unprovisioned
    supported_types:
       16x100G
  lc 7 state unprovisioned
    supported_types:
       16x100G
  lc 8 state unprovisioned
    supported_types:
       16x100G

Note that driver exposes list supported line card types. Currently
there is only one: "16x100G".

To provision the slot #8:

$ devlink lc set pci/0000:01:00.0 lc 8 type 16x100G
$ devlink lc show pci/0000:01:00.0 lc 8
pci/0000:01:00.0:
  lc 8 state active type 16x100G
    supported_types:
       16x100G
$ devlink port
pci/0000:01:00.0/0: type notset flavour cpu port 0 splittable false
pci/0000:01:00.0/53: type eth netdev enp1s0nl8p1 flavour physical lc 8 port 1 splittable true lanes 4
pci/0000:01:00.0/54: type eth netdev enp1s0nl8p2 flavour physical lc 8 port 2 splittable true lanes 4
pci/0000:01:00.0/55: type eth netdev enp1s0nl8p3 flavour physical lc 8 port 3 splittable true lanes 4
pci/0000:01:00.0/56: type eth netdev enp1s0nl8p4 flavour physical lc 8 port 4 splittable true lanes 4
pci/0000:01:00.0/57: type eth netdev enp1s0nl8p5 flavour physical lc 8 port 5 splittable true lanes 4
pci/0000:01:00.0/58: type eth netdev enp1s0nl8p6 flavour physical lc 8 port 6 splittable true lanes 4
pci/0000:01:00.0/59: type eth netdev enp1s0nl8p7 flavour physical lc 8 port 7 splittable true lanes 4
pci/0000:01:00.0/60: type eth netdev enp1s0nl8p8 flavour physical lc 8 port 8 splittable true lanes 4
pci/0000:01:00.0/61: type eth netdev enp1s0nl8p9 flavour physical lc 8 port 9 splittable true lanes 4
pci/0000:01:00.0/62: type eth netdev enp1s0nl8p10 flavour physical lc 8 port 10 splittable true lanes 4
pci/0000:01:00.0/63: type eth netdev enp1s0nl8p11 flavour physical lc 8 port 11 splittable true lanes 4
pci/0000:01:00.0/64: type eth netdev enp1s0nl8p12 flavour physical lc 8 port 12 splittable true lanes 4
pci/0000:01:00.0/125: type eth netdev enp1s0nl8p13 flavour physical lc 8 port 13 splittable true lanes 4
pci/0000:01:00.0/126: type eth netdev enp1s0nl8p14 flavour physical lc 8 port 14 splittable true lanes 4
pci/0000:01:00.0/127: type eth netdev enp1s0nl8p15 flavour physical lc 8 port 15 splittable true lanes 4
pci/0000:01:00.0/128: type eth netdev enp1s0nl8p16 flavour physical lc 8 port 16 splittable true lanes 4

To uprovision the slot #8:

$ devlink lc set pci/0000:01:00.0 lc 8 notype

Jiri Pirko (17):
  devlink: add support to create line card and expose to user
  devlink: implement line card provisioning
  devlink: implement line card active state
  devlink: add port to line card relationship set
  mlxsw: spectrum: Allow lane to start from non-zero index
  mlxsw: spectrum: Allocate port mapping array of structs instead of
    pointers
  mlxsw: reg: Add Ports Mapping Event Configuration Register
  mlxsw: Narrow the critical section of devl_lock during ports
    creation/removal
  mlxsw: spectrum: Introduce port mapping change event processing
  mlxsw: reg: Add Management DownStream Device Query Register
  mlxsw: reg: Add Management DownStream Device Control Register
  mlxsw: reg: Add Management Binary Code Transfer Register
  mlxsw: core_linecards: Add line card objects and implement
    provisioning
  mlxsw: core_linecards: Implement line card activation process
  mlxsw: core: Extend driver ops by remove selected ports op
  mlxsw: spectrum: Add port to linecard mapping
  selftests: mlxsw: Introduce devlink line card
    provision/unprovision/activation tests

 .../networking/devlink/devlink-linecard.rst   |  122 ++
 Documentation/networking/devlink/index.rst    |    1 +
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |    3 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |   56 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   62 +-
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 1005 +++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |   15 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  376 ++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  283 ++++-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   10 +-
 .../mellanox/mlxsw/spectrum_ethtool.c         |   37 +-
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |    6 +
 include/net/devlink.h                         |   48 +
 include/uapi/linux/devlink.h                  |   23 +
 net/core/devlink.c                            |  653 ++++++++++-
 .../drivers/net/mlxsw/devlink_linecard.sh     |  280 +++++
 16 files changed, 2896 insertions(+), 84 deletions(-)
 create mode 100644 Documentation/networking/devlink/devlink-linecard.rst
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh

-- 
2.33.1

