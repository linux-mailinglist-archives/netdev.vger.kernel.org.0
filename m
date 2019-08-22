Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20FB298AAD
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 07:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731240AbfHVFFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 01:05:17 -0400
Received: from mail-eopbgr690126.outbound.protection.outlook.com ([40.107.69.126]:17030
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731213AbfHVFFQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 01:05:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6ExtydRpZj2tyEN57/jbhF6tlGu4rNOtd9CLMRFuiH16oi3t+X25SbGSyyQZtP3JPIXoo4ake+wur5a2/KBq2RUwJIx0DiX8LEaud/wRHJc5T3m5J+1RD07V4/54VmuqyX3XMYOqWcqTrEOInY9lLgEvh+D9Eqt/yGpoMRd2W2oP9dApaNaw20JK+48qYkxwPePS2rq/qeaWEAuMrY9yGeLgYk3S4HFt+6lp4tbi9EWbY7FY34raoLe6tKFJgUYcaa2gDC4X2W41mo/30/Q/d+R1D8l3p2IrZWuhwyzhjQvGD7Z6QuJhef3TnTckDM3MBHuNqalAUvLYc1GZail8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVCTIn/vIAL8X0AnqhNTUetCFjIrt8CHNu1YYIjhKRI=;
 b=B885Jcsu9LgpjQLW0d9UjaYPnP52Zm6N35iJ4rNx5DOMIk292a+n0G97ydCaszDmGPEWjzqz/3/ZfEQAhBujosXwN76bCUzDDuBByp+JE47O3MgpKDrrtVPwqno+mac25iY7VTQ/GX6O/+JoS1MnJd3UNTYyzEMjr6u/WFuS2lIuxUyI2oJ6ilGDPe0d1i3O61uKnqCKyj9tDuW9Qp0c7DltQvjva30ev4RuwdUrPop348mWIJZ1F3RGKMtTdA0qdbXelZzkH5EPhgEzuHnT0CmkIvHBDpj4KqSlIuk5RI8iFVqY4I2qRT/8Xqxk9ixszv8Rduz2PUFLNspoVEnObA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVCTIn/vIAL8X0AnqhNTUetCFjIrt8CHNu1YYIjhKRI=;
 b=bOTTPu1GI10sfwpIVSgZyHg/ZeXHrN95tQdWon6q4NMS9/qDOuIkxVE3M0v0la/HBanoKoTnK84E3mvp3hKx+y++6yKiQaDePjBcp0/nd58WXH2lCn8l2eufd08mDeDDM8W5zZm4+QLxAjMEuaLyFEI79HU9LGsoed67Zp9pppk=
Received: from MN2PR21MB1248.namprd21.prod.outlook.com (20.179.20.225) by
 MN2PR21MB1247.namprd21.prod.outlook.com (20.179.20.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.7; Thu, 22 Aug 2019 05:05:10 +0000
Received: from MN2PR21MB1248.namprd21.prod.outlook.com
 ([fe80::147a:ea1f:326d:832e]) by MN2PR21MB1248.namprd21.prod.outlook.com
 ([fe80::147a:ea1f:326d:832e%3]) with mapi id 15.20.2199.011; Thu, 22 Aug 2019
 05:05:10 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "eranbe@mellanox.com" <eranbe@mellanox.com>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next,v4, 0/6] Add software backchannel and mlx5e HV VHCA
 stats
Thread-Topic: [PATCH net-next,v4, 0/6] Add software backchannel and mlx5e HV
 VHCA stats
Thread-Index: AQHVWKcsgqAQEbW8Yk2+H637twGJJA==
Date:   Thu, 22 Aug 2019 05:05:10 +0000
Message-ID: <1566450236-36757-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0039.namprd14.prod.outlook.com
 (2603:10b6:300:12b::25) To MN2PR21MB1248.namprd21.prod.outlook.com
 (2603:10b6:208:3b::33)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eebbeca8-2afb-4ac5-79c5-08d726be4e97
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600158)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR21MB1247;
x-ms-traffictypediagnostic: MN2PR21MB1247:|MN2PR21MB1247:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB12474F0051FF36F61DA3BCCBACA50@MN2PR21MB1247.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(189003)(199004)(2501003)(66556008)(54906003)(7416002)(6506007)(53936002)(6512007)(2906002)(4326008)(10290500003)(22452003)(316002)(6436002)(110136005)(66066001)(6486002)(25786009)(386003)(10090500001)(7846003)(6392003)(2616005)(4720700003)(14454004)(52116002)(476003)(26005)(305945005)(102836004)(7736002)(14444005)(186003)(478600001)(486006)(2201001)(71200400001)(71190400001)(99286004)(36756003)(81166006)(81156014)(6116002)(3846002)(66446008)(50226002)(8936002)(66476007)(8676002)(64756008)(66946007)(5660300002)(256004)(42413003)(921003)(32563001)(142933001)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1247;H:MN2PR21MB1248.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: diwGDaA3iswgRt0yHuT/wQMxobfqobwagq+czpaTyI+l4KRWFUWZFTPBWceBiEY/kxK3j3LNSaN0lJmA2fyhs5XOtz1Pg9dUbYVKJXhnjkNurcT6z0jYqb51R8W14fs9NdjR+qK2Rbw7kgOdeVJJKz6e6vwZvvh1ZEpbM1P/TeS328lFnt+Ambtd3TmYogV8fghgjzPqy027VAyhWoArKXfml7H5mLutqqLu2jo1ynp9ZekUk2GQe5LMeAYtwOZ06VPeMS2QYBSSKdegyV/YzwDcyLpJEAluCy+LpNgro9G9P+hA10fFJgSbHtLWta0jeDQlizKK7bh61jSxV9BcCtASv5MDtPnIV7kjU2IkjYHskU5v57dskFrlb+YS23NgQkRrZej/17xR/KWuAELKDQf/0ewYCI0+LGmtlU4OHWs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eebbeca8-2afb-4ac5-79c5-08d726be4e97
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 05:05:10.6272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iQYNmiIharqE+Flj95Dhq7A/zObRduURA67TNQ+yBbA4o98lXdNhud2vvHil1q/e3UByXHHY6Qld6DPPPmGxrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1247
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds paravirtual backchannel in software in pci_hyperv,
which is required by the mlx5e driver HV VHCA stats agent.

The stats agent is responsible on running a periodic rx/tx packets/bytes
stats update.

Dexuan Cui (1):
  PCI: hv: Add a paravirtual backchannel in software

Eran Ben Elisha (4):
  net/mlx5: Add wrappers for HyperV PCIe operations
  net/mlx5: Add HV VHCA infrastructure
  net/mlx5: Add HV VHCA control agent
  net/mlx5e: Add mlx5e HV VHCA stats agent

Haiyang Zhang (1):
  PCI: hv: Add a Hyper-V PCI interface driver for software backchannel
    interface

 MAINTAINERS                                        |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  13 +
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c | 162 +++++++++
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.h |  25 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/hv.c   |  64 ++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/hv.h   |  22 ++
 .../net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c  | 371 +++++++++++++++++=
++++
 .../net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h  | 104 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   7 +
 drivers/pci/Kconfig                                |   1 +
 drivers/pci/controller/Kconfig                     |   7 +
 drivers/pci/controller/Makefile                    |   1 +
 drivers/pci/controller/pci-hyperv-intf.c           |  67 ++++
 drivers/pci/controller/pci-hyperv.c                | 308 +++++++++++++++++
 include/linux/hyperv.h                             |  29 ++
 include/linux/mlx5/driver.h                        |   2 +
 18 files changed, 1189 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stat=
s.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stat=
s.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/hv.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/hv.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
 create mode 100644 drivers/pci/controller/pci-hyperv-intf.c

--=20
1.8.3.1

