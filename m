Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 741728DDAD
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 21:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbfHNTIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 15:08:09 -0400
Received: from mail-eopbgr800097.outbound.protection.outlook.com ([40.107.80.97]:62623
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727791AbfHNTIJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 15:08:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ixu731RzVMU4ND7N+AVMV5VhSOSkZbsTjGOQBaDE7nfu6ESpHVWSr43nLZ8RYeNGqkrv/X/WejlV4i41p3llW3gX7tWpm3HYx3ghTLRPh8Z22QO8h88CuATMrowKvC9LsJ675Kvk6lfD2OAEsa8lAshXtpaJtB9tI9oFHxYMuRGvyfmy6GHuyQZb3ejFLuPFW8urzJTeOpmZKh1JgaJUhwOqH9yCe3A/j1Yi0940CiuaJVtpXijpn0GhA76fVJFtsfxCwSL5xWrhYYEntIhrFC2+hWZSSizF/J/cqyogbSB2uISoHUhSjtBCfGr2Er/P1w+AQCRmtH8F0fPVdaEVmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WR3/yWX7FPocv3nclTz25ZN1IC0791bB1Dmkvwgp7I=;
 b=i8XEXbz/4p/5nSGxTr8wxztUtGZM5UHCFW69AkHH4epD+f6R1ECm5cxJT4WMjjWB+uFHXvRl3VstJlpl11+GvLsrtsKXPDZi4rGJtk0p1VKFKL421JUchv5sqG+v/NrUIEZH5KyyOAgIPSRCBQCLAUv/FpwGnL3Q05AVmKZmm1Cn2Li70ey2nnRaezbtQiF6m/8iF0cIvkMeZR2krWkqEhVeYEtw8rFBYvJZPefkklWSvC/mbUfFaLwjSvZYK+qmhJntxfayByEsiVPBzIyDTwNu9udfns8xhqBn2E6OSf4WmCVrLWfA8FsbsuA2t865Lt4O7W+kfF9UJSKebPcFqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WR3/yWX7FPocv3nclTz25ZN1IC0791bB1Dmkvwgp7I=;
 b=otnUrmnC1Lf0RfEiRdX2n3T//0m4KOLczphTZUtixp4Jvs5rv/aWmHlZU685UnIP5P6j82BIgd2uJ9OSnMViLuWOp0wIb8Ml5rRnBOtfNnEGO/2+8pZnfMVgV5En2Vpf3MPwbnxdignfaHp3mY4xNGY/kW1HsLzUm5u+G+h31SA=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1338.namprd21.prod.outlook.com (20.179.53.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.6; Wed, 14 Aug 2019 19:08:05 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726%9]) with mapi id 15.20.2178.006; Wed, 14 Aug 2019
 19:08:05 +0000
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
Subject: [PATCH net-next, 0/6] Add software backchannel and mlx5e HV VHCA
 stats
Thread-Topic: [PATCH net-next, 0/6] Add software backchannel and mlx5e HV VHCA
 stats
Thread-Index: AQHVUtOZxyqSz03GxUOml3zKLzY/rw==
Date:   Wed, 14 Aug 2019 19:08:04 +0000
Message-ID: <1565809632-39138-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0107.namprd05.prod.outlook.com
 (2603:10b6:104:1::33) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32347e59-1a7e-4db6-d4f0-08d720eabc0b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1338;
x-ms-traffictypediagnostic: DM6PR21MB1338:|DM6PR21MB1338:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB133814587CAFD822BAA13E2DACAD0@DM6PR21MB1338.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(189003)(199004)(6486002)(110136005)(6392003)(54906003)(4326008)(10090500001)(26005)(14454004)(256004)(2906002)(53936002)(6116002)(66066001)(6436002)(3846002)(6512007)(7416002)(66476007)(66446008)(66556008)(2201001)(64756008)(66946007)(8936002)(22452003)(71200400001)(14444005)(7736002)(71190400001)(50226002)(102836004)(5660300002)(81166006)(4720700003)(316002)(478600001)(305945005)(7846003)(186003)(99286004)(2501003)(36756003)(81156014)(8676002)(25786009)(476003)(52116002)(6506007)(2616005)(486006)(10290500003)(386003)(42413003)(32563001)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1338;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: P3hwTet9b/NDDuFLhQ7mwR9/tKtXwQW3M/hQYDOV1tKGoGvlLlCtPORDSz+t92HALIpLVp0MzXtDlN+Ua2sM1xL5cGSzFBNG7NgAB0HmDJ8wemiD49M9zJpPDkhg8I1knzuamYp37Y0QRmj6x6nZIWCI4a6J7ADlbzSs/DOTNg7FLBYpejIL6hbHQVEduRy5Us/lIp12zsZuMgCv25Ni0B7rwSvmCyW2oixjhMhjbGI50nzVKc9uKbG/Nh5tjmrfi7/rIuqwO5e+OM+/Zk6YNtD/qZpkdX4TFQNKlhznXQsEceOUw+i8PRqGaaoIHAtF4KToaS0TXg8n1IJXLbSv8HbkrOa4YxciblYHJPloTMrFYT9UEmz2Nn5+XdHT0H6UTAP73xSG3sToEjE6JzXA14FVvXhHQgUwOvKsMMpWwlc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32347e59-1a7e-4db6-d4f0-08d720eabc0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 19:08:05.4967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AotVQXkOu1CUXm+BDvFvc2+5+udzxkIVIfNJQ8bwL0v+FgVI5LWfsxpPgqjUp/sM1mRCvFIed4NZ7g1Tg/ewhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1338
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds paravirtual backchannel in software in pci_hyperv,
which is required by the mlx5e driver HV VHCA stats agent.=20

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
  PCI: hv: Add a Hyper-V PCI mini driver for software backchannel
    interface

 MAINTAINERS                                        |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  13 +
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c | 162 +++++++++
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.h |  25 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/hv.c   |  64 ++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/hv.h   |  22 ++
 .../net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c  | 365 +++++++++++++++++=
++++
 .../net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h  | 104 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   7 +
 drivers/pci/Kconfig                                |   1 +
 drivers/pci/controller/Kconfig                     |   7 +
 drivers/pci/controller/Makefile                    |   1 +
 drivers/pci/controller/pci-hyperv-mini.c           |  70 ++++
 drivers/pci/controller/pci-hyperv.c                | 308 +++++++++++++++++
 include/linux/hyperv.h                             |  29 ++
 include/linux/mlx5/driver.h                        |   2 +
 18 files changed, 1186 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stat=
s.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stat=
s.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/hv.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/hv.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
 create mode 100644 drivers/pci/controller/pci-hyperv-mini.c

--=20
1.8.3.1

