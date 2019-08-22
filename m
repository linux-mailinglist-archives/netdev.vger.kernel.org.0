Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5F89A2C2
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404891AbfHVW0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:26:23 -0400
Received: from mail-eopbgr710118.outbound.protection.outlook.com ([40.107.71.118]:25952
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393854AbfHVW0W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 18:26:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGPtN2YXcnmGzsDhKFVC9GJH7O+s5SL2yST6kRhDzpP1arCvxUL7yxCv6a9L7w7B5i2KqmjtdZUQ93FRaD6KWiCnI1YFgsF2jKQzO51VR8QnqwepRRPYl1nkrKejVswUbAKz2ZbN4rlZBGmPDwNFbRXmQ/bRSfXq4TifxmQTPOsYjj/O4iuvOLHTRqMcSQY8nHCXNOHoNg05xAGzCh460+vhXKocCObR7LEuemg9S15/ANR/Xs3WQaSJue3LAI4o1vbi1t9sEVskjtfdDXdyr1KEjixBJ+PuBp5HMGRpqUiXag3QnLWdfGUDApuZ7AsK8UrIUIO46zhTl5CvW57Zeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CvmaUZmpK//d9FhySkQ9m/J1uDOhkqtE5C6qAiI35ck=;
 b=kw3HzYt76L0gFyLvgQitxeyyEtrlWjP3qVGZOVCvVDkHPI8SDO8u99jEPJh3z0mn8L4LFnQjAqtDDwAfVmkBUg5ob0o+Kj+x4p+pO9oQPNQLuAahyMH3WTcCBHAPZPDMNy087TNPFWxGpoIwwh2/bSduj+T53FDusH9UbseGzwA58Vo7iY8rO4k9mqxnse3C29fwgBGy+oU2Mu/kUzje+ppWTc+15KgxtY0UYM13pk8IRjW4mJm0AG7ddADy+03MWmf3nZ6ByTNSamDiylrAMZk9CafsdceZtU6OiPsL/4GM6ta7oHjch5HIr6Qhe4BKdkLR21mT4jKLOzU/ecIcKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CvmaUZmpK//d9FhySkQ9m/J1uDOhkqtE5C6qAiI35ck=;
 b=OlntB3LWPoa0jhxIcsLF6obtcKZMqEa1KGzz0Q9JofOmxr4odPptFKoE8X6oBgrmcu55UGerer1ei5stVV8YTBAJdKRx95lBitPeeci2xve6SEtHjlX/cdfZoCXVlo33Cj2Jg+vJ6vYr2Vbf/ktmYvP1J/cmDrDIWzqwy4Ar3pA=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1449.namprd21.prod.outlook.com (20.180.23.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.3; Thu, 22 Aug 2019 22:26:19 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::d44f:19d0:c437:5785]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::d44f:19d0:c437:5785%7]) with mapi id 15.20.2220.009; Thu, 22 Aug 2019
 22:26:19 +0000
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
Subject: [PATCH net-next,v5, 0/6] Add software backchannel and mlx5e HV VHCA
 stats
Thread-Topic: [PATCH net-next,v5, 0/6] Add software backchannel and mlx5e HV
 VHCA stats
Thread-Index: AQHVWTieJNg4lNlPokigzqQxpEz7DQ==
Date:   Thu, 22 Aug 2019 22:26:18 +0000
Message-ID: <1566512708-13785-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0092.namprd19.prod.outlook.com
 (2603:10b6:320:1f::30) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2c8e2a8-842d-47d3-23eb-08d7274fc0a0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1449;
x-ms-traffictypediagnostic: DM6PR21MB1449:|DM6PR21MB1449:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB14496DBC8A5C65CD05B79C6FACA50@DM6PR21MB1449.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(186003)(71200400001)(2201001)(52116002)(305945005)(8676002)(5660300002)(102836004)(81156014)(6436002)(6506007)(36756003)(386003)(7846003)(99286004)(8936002)(10090500001)(53936002)(81166006)(2501003)(66066001)(478600001)(4720700003)(6486002)(7736002)(26005)(2906002)(25786009)(2616005)(256004)(14454004)(10290500003)(486006)(54906003)(110136005)(14444005)(3846002)(6116002)(6392003)(66446008)(64756008)(66556008)(66476007)(66946007)(50226002)(7416002)(71190400001)(316002)(4326008)(22452003)(6512007)(476003)(42413003)(921003)(142933001)(32563001)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1449;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aJF0d+NK0LACCjXruke5SjMl7JxCIiBF+8Wg3a4hbjVW0q+3JjPkvw65xtwgjnZmj0t1FJ1j1ZFj7YIaXqu/V34whzkDiuiVsNkx6dgH+irSRiQsSXnTy3u3depgmqTe+Juabbl9tnrXf010+KKMHU1Uf40xDFctUsREen6s8+/woyPw2PfiuD2VOGM0y5g2CUwdGnnY1nhNtWZGXwgozhMKlz4Ud3VRmnhkLLYlN/YlEYs0rvSWizyjN9JrcUbbuIKzzMHhx9JEVwX1sllj0hhol5oCVEfUMlY9rMMG1sa273m5fAKS5TfDNlbVqk6f8ToFeLzp7KjKENjrXrkwVvkFAcpuGixNIgda1fE+/2kxmv8AoBasES5ZWl1wYFX7fZRApcH3L3M7eJ8zcnZA9POfrmEQtNP6QbKYJH7sqg0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2c8e2a8-842d-47d3-23eb-08d7274fc0a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 22:26:19.0271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: baBQlF2AN8zwaQEdBeBQt6V4pNCrI6QVRMRz7bDB33qh/ySz9q1xKaWEaCPQ7FBZKHuOgydD/+Xbkqc9YWd2qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1449
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
  PCI: hv: Add a Hyper-V PCI interface driver for software backchannel inte=
rface

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

