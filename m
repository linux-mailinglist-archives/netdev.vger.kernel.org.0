Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8831654FE
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 03:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbgBTCZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 21:25:43 -0500
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:32566
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727125AbgBTCZn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 21:25:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h00H98qp+zAriacPfHA9K3vsjTZtYmfFfhtnKS8UuWh8YiXB0Y4B17EgPxmvnpBUM+4uPiSPvNMynYTBbWkHLtmh5Z2J7KvvJxcS+ggBhFWYl7tNuI34aPbI1ZFbT6tGahj6iUA4Vy0pYOaqvPtsU9xGl3ETRhlSVK8cKw/edINBU0LkEl3PwLRlsuuzTmkdIpr7mRYECmYsRsSdAzDfas5oxgumW01yzoQ4nciXEW9iLXpGDGW9nOOhZ96GNF8l+edHv4gi0YeR2xHn7Dw3tzDqVPre9Oko3YYlOXZZ3Oc2ATlxH7PFefALIHXupJYodsG5vDgrrkJxyRmBXKSGLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ha2cqlw2r7RyepSbVV1Iip0TWLyy4hfV4PUlURM6LC0=;
 b=cc2Fisa9spKP/g3Zv0mSGqFNJCPSyYrw1tNK/J0DHozFjZ3pWfM8v/2FZ1W33ibT3CxYgj6Plzn3xczxpo5C4Q19U+S2nTs9TX59t9I3wJ+Ccma0tkx/UTl1JVobzE/RTshDcohdGRXMSg091gHQbuAz7QQo3cYJGsR7RjDNHgb8kDaYgo43R5A62Y2l4Vyz1KqtUGQVMChQ9/YgDIm9MlkpqSs8ImF0HtvoVsgkb4pMq2XDd0VYd0uiT8elAvImQ3WJZ9hzZ+bulfyKTTdtnhFh3s0+LoVWuPL5PyLfy5RFRGhsY40hXnUvAbxuIKIGpWi+U+TkS0vHZmR6/Lo4bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ha2cqlw2r7RyepSbVV1Iip0TWLyy4hfV4PUlURM6LC0=;
 b=i6adSciLaHWWUq41JaAMM/7WbH8KdB7R7mK7FfczisTBy6oUx3y+g6pqmcd6B7F76GRSzZhp6kYOa/v27Bm4UYcXaCItinxDg2qhUHqWH1fZ09+xAPuoFpYhuFBVPFYpUAkNnO9IZwtPdotVVBeXlC8tF9q/Pb9rzhcymVkHj0w=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4173.eurprd05.prod.outlook.com (52.134.122.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.31; Thu, 20 Feb 2020 02:25:37 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Thu, 20 Feb 2020
 02:25:37 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR20CA0022.namprd20.prod.outlook.com (2603:10b6:a03:1f4::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Thu, 20 Feb 2020 02:25:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 0/7] mlxfw: Improve error reporting and FW reactivate
 support
Thread-Topic: [PATCH net-next 0/7] mlxfw: Improve error reporting and FW
 reactivate support
Thread-Index: AQHV55UIzbzNmXZ6s0C10xuZIUi2DQ==
Date:   Thu, 20 Feb 2020 02:25:36 +0000
Message-ID: <20200220022502.38262-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR20CA0022.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::35) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1ff604fe-8c6c-4876-acb0-08d7b5ac2b20
x-ms-traffictypediagnostic: VI1PR05MB4173:|VI1PR05MB4173:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB417323957C9CFC44AEF0BCA4BE130@VI1PR05MB4173.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(199004)(189003)(54906003)(5660300002)(2906002)(26005)(478600001)(71200400001)(6486002)(6512007)(16526019)(110136005)(52116002)(316002)(186003)(86362001)(6506007)(4326008)(956004)(2616005)(1076003)(107886003)(64756008)(81156014)(81166006)(66946007)(66556008)(8936002)(66476007)(8676002)(36756003)(66446008)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4173;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FfZohdQ0ZtHUwM0IERh5q/LNCFTBORsfjPbI23R9QN8rXru+iYyQgBbnasqd35RO+BjHDK9FRw42J+pX4EBCFa6csZdaoFAUHEemNe7CYmIAqQnodXwn6mgHfUqkmJxYcTuyt9X/w88BKkv51Lr6G502HVCeJ04r5Sg1MGwWY3mP5tdssY0jyUvKtHWNzSP/IEglbR9D4JpuvV464/aMo22o7wh8bIEbuB31XuouS/ymvDmeBypgmSPD1nATCFy81UFR1cx2LoUzLzjv9XMEbc1qZNzovhvb63x1gRN92/M/jRmj7Msp3kDv8UNPa5P/3bWF29nT/JeiMjzBKMTX0LMABeXzyMNTIR7dbtXVPG/TrvYMmHQsgNvn8s4FdhZG+3H5HXj+Jz3nXKFsxqVQtpvunlbTtXBYa8tbfUg1gSrAysxCgPb9Krj9QFuechZPtp/Pcird7K9pMHifmlxGC2CMipVy77xpNuyDi5sxYmtOMBRySSaTyzaPXfiAc+qN2axLMtgr7M772F1MUI6QDUAWZqaCJwj9qiY2rJ21YFY=
x-ms-exchange-antispam-messagedata: 1px4Fj+7usq2UaRXqmeYYv3SNjRPNldaYRs8/7Yp15UH59roa42Nd8QfkDejh7a6asNj+9EZGdFoVNjuHJ0ZGrpNMxas2ELBZzUAKPghQ7FwU+XCGWLCyMG417NAokTV0rHPNVDUrkr2SnzgOf25lA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ff604fe-8c6c-4876-acb0-08d7b5ac2b20
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 02:25:36.9192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ye1uPPtdyi8MZoDEo7iNPHY4ls/gVvY+J7OudOVXrIIA3pQeyDdvcJ81Ovu+TK5u8EMiTX33fFKK5rcoJEyWpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4173
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset improves mlxfw error reporting to netlink and to
kernel log.

From Eran and me.

1) patch #1, Make mlxfw/mlxsw fw flash devlink status notify generic,
   and enable it for mlx5.

2) patches #2..#5 are improving mlxfw flash error messages by
reporting detailed mlxfw FSM error messages to netlink and kernel log.

3) patches #6,7 From Eran: Add FW reactivate flow to  mlxfw and mlx5

Thanks,
Saeed.

Eran Ben Elisha (2):
  net/mlxfw: Add reactivate flow support to FSM burn flow
  net/mlx5: Add fsm_reactivate callback support

Saeed Mahameed (5):
  net/mlxfw: Generic mlx FW flash status notify
  net/mlxfw: Improve FSM err message reporting and return codes
  net/mlxfw: More error messages coverage
  net/mlxfw: Convert pr_* to dev_* in mlxfw_fsm.c
  net/mlxfw: Use MLXFW_ERR_MSG macro for error reporting

 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |  40 +++
 drivers/net/ethernet/mellanox/mlxfw/Kconfig   |   1 +
 drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   |  50 ++-
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 296 ++++++++++++++----
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  17 +-
 5 files changed, 308 insertions(+), 96 deletions(-)

--=20
2.24.1

