Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2036296E35
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 02:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfHUAXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 20:23:23 -0400
Received: from mail-eopbgr700131.outbound.protection.outlook.com ([40.107.70.131]:53792
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726141AbfHUAXX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 20:23:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVG3UgpSPKLuLu9sN1Zpth6ihcHTlFoicUqjslL4hWXXi/R3SdHrF3265Ow/f+1zoljO2VLZKiCTJgmBisBI+1S3r+LwCJZe6DbRIAAcuzn8pbwbXjYYtUdNFAL42dGAU6B6HSqGBn5WJNlQNKaEz7gLZLXZrFCfde3ROYeQMHXtVZn9sXaioseiyhKOXMrd0u+p18/t9I2oQj6CoCpPz0dqUcFMaTXg8E/QLgjlBF8FYi8K4uF0x1+NQChI0V1EC9dJTb1XFZhAHeqDt/M3qBKlxoxg6y4HJVzqUX2yR1fo4gOllHH5OKuWK4BAoG9YqbRRlMG5NM6R3cG3ibLGow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVCTIn/vIAL8X0AnqhNTUetCFjIrt8CHNu1YYIjhKRI=;
 b=TIVXxRP4Gq3U5qgRKpNX9fMLPdYnW1ifWYurM3JCUN+tVgeGeMg7+CrDUB2zun69psc4SNk2qp0sOIs559HYdDK+2vRoRJ7IJfUkCA4esHJyDxd6wZk9p6IWNk4UBrIgKXl4J4m7UJ2WjhuSsfilEfMJjCkXy4emixKnzePcu6CU0ZxESKVRqny3Xogoneh1lOapXhrRzSR6wi4QyKemmEdxTa7LynObZjE5yW4z4QXWtRbxzyZGRLzoM0KuKX79Zr+S5G0Ad1ywpIGVs6bl6UkanPhz1FZ6dhjOIwnSbVuGhqEQPNs6rmmj+xeDtK7/b3yz4JKDHwKd2oX6pXkslQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVCTIn/vIAL8X0AnqhNTUetCFjIrt8CHNu1YYIjhKRI=;
 b=U6Wuex8Li/cOGRvrxoFCDl4rtGAn1Cl/KXNna8NsUB+qvLFuM8w6iAvyDP9/mCnYVpyFB8j1+a3kbgWkPZ8Xk733T/RT/uw2iho66b0IEYoenbDMaWSb7YYTmHn/bU3W0U5zoGBEzX7dksKjm7SqK18sILerFgshaOmKVtgI/b4=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1292.namprd21.prod.outlook.com (20.179.52.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.2; Wed, 21 Aug 2019 00:23:20 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726%9]) with mapi id 15.20.2178.006; Wed, 21 Aug 2019
 00:23:20 +0000
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
Subject: [PATCH net-next,v3, 0/6] Add software backchannel and mlx5e HV VHCA
 stats
Thread-Topic: [PATCH net-next,v3, 0/6] Add software backchannel and mlx5e HV
 VHCA stats
Thread-Index: AQHVV7aiDgd7yolKIEul0PfWUyB6vg==
Date:   Wed, 21 Aug 2019 00:23:19 +0000
Message-ID: <1566346948-69497-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0034.namprd02.prod.outlook.com
 (2603:10b6:301:60::23) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 098fdac5-6f20-4b79-d585-08d725cdc4ca
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600158)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1292;
x-ms-traffictypediagnostic: DM6PR21MB1292:|DM6PR21MB1292:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB12927817EDA624EB6960A809ACAA0@DM6PR21MB1292.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(199004)(189003)(305945005)(66446008)(64756008)(22452003)(66556008)(478600001)(66476007)(256004)(99286004)(2201001)(186003)(316002)(66946007)(14444005)(6512007)(26005)(8936002)(36756003)(66066001)(10290500003)(2501003)(7736002)(7416002)(7846003)(6436002)(6392003)(54906003)(5660300002)(14454004)(53936002)(71200400001)(6486002)(25786009)(2616005)(476003)(386003)(81166006)(81156014)(110136005)(10090500001)(6506007)(71190400001)(8676002)(52116002)(4326008)(486006)(6116002)(3846002)(50226002)(2906002)(4720700003)(102836004)(42413003)(921003)(142933001)(32563001)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1292;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: atlA308xhmulqec/ULEnrVBb3vGOYl+hx9CDz3KnctjhGBhWLWEUKRRXTrOGuRUX/BAfMiZxCyeuGejE47LSeLbL3/zo/dfn11hpukOlZ5wHYfqjmkBtdoB8O4XZhlQjC0YZloDvLcvi1N41l2lgcBmlgaBXnzO2/5cop/hdv/H0be8Eb+6wUyiITn//+0JQgaXJrBZwkrS10SOj5Kjz1dj6Gm7jJdhKtM1xO3moN0j7/Lq76HZDYjT/duNRwy5Jq8hXkVFk0JlUnAJMgpaX3pNIckwLlPJfOV4jkbThMrNcB7uon9/zhyv049zzwtu8yQZ0RgNhnxgitG1B9+XEminMhxKJFEhL5HoPidg2iX1wTLav2Ch2s99+Mzd/gKyzpEJbXJLQZVmJM8g40W4PvlvJ6Jhbu03wogpg0P42xsM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 098fdac5-6f20-4b79-d585-08d725cdc4ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 00:23:19.9113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RJLFvo+LXs2x/XaGFeS4clbc5MgZlfIsWM4fXfPUoxP5eOr5yiELyMFpyXE2s/Tm4khrYN6XW77DbHIy0nJh8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1292
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

