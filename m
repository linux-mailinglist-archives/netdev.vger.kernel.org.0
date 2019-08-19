Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B247294E23
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 21:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbfHSTa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 15:30:29 -0400
Received: from mail-eopbgr810131.outbound.protection.outlook.com ([40.107.81.131]:42528
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728404AbfHSTa3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 15:30:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Orc5IT4TcmVJu0iJzSyFbpC5kybQ/+/jSKjGEqs4auZvPQnlUFOJQ0ak0C7zlrQQnUIkpfbWoJoeO+wuP8nayJ4gXGdmKaa2Q8X8bnmwfWvxpFGCL3ePKX/nn/h7DYkhMxA8zq5t7QyXazprhZwfbqb/2SCDWNkR10eEVTQx5Fr6zs89Gof40zRV41HcqO0iZVJW/PiY/fsbeKf8UI2Lq5V+VfShXi1wOcl/SAmuyTVSGdo+UtqQeJPLkzFJ7TVidTBBvbfSU7JuupClVd5LGY/OOXTNbV810dJY5XPcKiufO5u1ZXuT1lkPN7gR5fvBTmE0vqsAmWEIn1BvotjgtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHDPFtQPArFAgS8lhbeIv4YrwaW+gNbD03Sy3SYMnwA=;
 b=CnkpFQN2/UIxyNwuo4kiBN5+2inWuauO6XAwsLxEvohtlg6cY7Q/KGrgAxgM6J0zIP+RRNerCcx/pbzwHsTtMtWatLa0TDtjkpQCIVCR80gb08vkTzU2WncPQMLr9cy9Uex7K6TuE0rYQiFy+JdqFbXOcHbmcDALPKtmoWpJtqWI3LfecPI7ZobtkBVI+WoNqzChDmbR87SxA74lAxi58j41fyxrhScG/4O3zRWeWsHRu7S2/qny3UasxtTWYlN/9LDuiHBspjRohX57axFsXoaFsFNceBjwUk0CGiL3hvo3uSyW4C4Pvr94LBJX27+As61gaLSLuoti01FBzWLRHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHDPFtQPArFAgS8lhbeIv4YrwaW+gNbD03Sy3SYMnwA=;
 b=e6i8vDfoaXeprxJIGifq2kg0hPdrrYs1vYS5OEzGRw1nHjo/laPpNzQUC2tgCh3sra6n36qXtIvmUwgJ1humiz9OHDMIcB0kabMacU5mwIcwEQNZS8TRbMm27MRT9o0x6XTU2zTn0rx888cZMwfIxEMOWpsK/u4rd23qabhBgcE=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1145.namprd21.prod.outlook.com (20.179.50.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.11; Mon, 19 Aug 2019 19:30:25 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726%9]) with mapi id 15.20.2178.006; Mon, 19 Aug 2019
 19:30:25 +0000
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
Subject: [PATCH net-next,v2 0/6] Add software backchannel and mlx5e HV VHCA
 stats
Thread-Topic: [PATCH net-next,v2 0/6] Add software backchannel and mlx5e HV
 VHCA stats
Thread-Index: AQHVVsSMIIWgPx20+EmFaWJFA2ozCQ==
Date:   Mon, 19 Aug 2019 19:30:25 +0000
Message-ID: <1566242976-108801-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0059.namprd12.prod.outlook.com
 (2603:10b6:300:103::21) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 223de19d-8011-455f-4369-08d724dbaf3b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1145;
x-ms-traffictypediagnostic: DM6PR21MB1145:|DM6PR21MB1145:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB1145364E24D817AC5F5B7F60ACA80@DM6PR21MB1145.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(199004)(189003)(52116002)(99286004)(110136005)(14444005)(2201001)(386003)(186003)(6506007)(476003)(71190400001)(10090500001)(22452003)(6116002)(7846003)(6512007)(6392003)(71200400001)(256004)(53936002)(81156014)(8676002)(81166006)(6436002)(4326008)(102836004)(305945005)(4720700003)(26005)(7416002)(7736002)(36756003)(6486002)(486006)(66066001)(3846002)(54906003)(66446008)(66946007)(66556008)(25786009)(14454004)(2501003)(50226002)(8936002)(64756008)(2906002)(5660300002)(2616005)(66476007)(478600001)(10290500003)(316002)(42413003)(921003)(32563001)(142933001)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1145;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kICRrbuBiop0uT3WpD5xS/4W2UY5KjDN4tfNnPOQhq/ZdGb4zkO93/1fdEDOMuRfH/vMCbQUKHauPlH0h6nKJ8aMX36jXB49qBUYEO6CNxHv+vT2X1x1Uv2v47z6iEe1U4YBGc32D3uEBFgIPL+oC0pOEIOkC+zYDUEKUUDbcFnHt+j30dUBVl8PD/HMjXsp4mM3znVMAixko9Dpol3OUeM0/wAtaDIsxHevx+pVWFL2roEqkDOvuwmHVovQ7Z3X4uIXR2waedEK6aKOpd3Rv2VzGdfdYvlkJH8lu5D9es4WyRQmO4Y9qsNui7gA8sXnaeJ0T61Us75OMij1VQ8NxfMm/bRrrP/N3ava9cHaRUT2ghcGzx4LbZZ9k3J81wOEffYmYK1mmYrm6DXbGgs5MlXF3cElEB7nzcG+bCzjPqU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 223de19d-8011-455f-4369-08d724dbaf3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 19:30:25.4507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7x4bOqZI0uQ0+R7FBH7crFExSiQinq/2YmT1kxBW3FD74qJ871nS5rXW1fVyL4kQrK8HCEEWQDAI4JVRGHGZAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1145
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

Haiyang Zhang (5):
  PCI: hv: Add a Hyper-V PCI interface driver for software backchannel
    interface
  net/mlx5: Add wrappers for HyperV PCIe operations
  net/mlx5: Add HV VHCA infrastructure
  net/mlx5: Add HV VHCA control agent
  net/mlx5e: Add mlx5e HV VHCA stats agent

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
 drivers/pci/controller/pci-hyperv-intf.c           |  70 ++++
 drivers/pci/controller/pci-hyperv.c                | 308 +++++++++++++++++
 include/linux/hyperv.h                             |  29 ++
 include/linux/mlx5/driver.h                        |   2 +
 18 files changed, 1192 insertions(+)
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

