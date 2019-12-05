Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48AE211440D
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 16:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbfLEPvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 10:51:16 -0500
Received: from mail-eopbgr40074.outbound.protection.outlook.com ([40.107.4.74]:63710
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726028AbfLEPvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 10:51:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPQrDLF+ky7q1Gbp34UTfDy+6+NdbA4zULZjZSxZG+EEL7+J472FXfhiFH2gpO9KrLbRSJHVHRA5v2HQXGtUR0hIc3TqpBOQ2SPeony3+EOkIjYb35YS9PM0gE5X4wZOIjwWs+/PbqVCkqROi1nowLjaSRuwm78My0qF0A62YNCQobDr0HtUjAfIn0KSuWurOHfS+F6MKEijvsLLhShZua9Q71R/K3YnbXEv6RbjVtU7hFS/3Yqc1GKoB4rBKUSubiyyglgrqHnap+XHrR3Ya0oFzmSWMP97uyGiWzb5eA7rhreKCoi6lsS470Lai5fvdzhoOSrlV/ypi2JWNHlBOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5CAbgoCJG24d4hiUsC8MIzEGwR5LXcRnty/R9MPx4/Q=;
 b=LlXzZ9WnSJCpWUzE6yIKo4UhjSfJuj/2J3tgGnolcFDeU6OCE6AzXbt/FZZoSrETSEEPHaAdZg5PBSZqC8D0p3taIK5e2OjOGOmZHqSYSqYJJcqF0l5ZeYfyGOaXB7YUIMvEI9r5fMqIzl6RHldKABkdVlqr4k1thXJ8UE1PptJthonKdnKeQ5vMN165uORvj1mHtQhFqImo52xywaZaguwiXAQ0W75nACEKhKZIc4AUQjV23LjOGYlE3HZSD9dn1QmiOrToiyTJwpVvLWJs3czP+WT1sodgJq+r6bGcYfMCfJzpnvO83OkOSQXt2Rl0Nv6z+/TP7c+c0jLxTp9PgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5CAbgoCJG24d4hiUsC8MIzEGwR5LXcRnty/R9MPx4/Q=;
 b=F/jiw1RPuBXcMKhM2KoIvZ04dZMQUOpntYbqTD6zlQSO58iJNbqobElFerECwygG9HY7VPDYNshGoQr9/t0yxJnKeVsioiSc26wBuxHtF+OoHLJ8eTuvHhUJCudNdMJmE3sgsBWIaMvGVFlmDvl776cm22QLZlmzhUJgCMpQzww=
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com (20.178.119.159) by
 AM0PR05MB4851.eurprd05.prod.outlook.com (20.176.214.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Thu, 5 Dec 2019 15:51:11 +0000
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::dca5:7e63:8242:685e]) by AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::dca5:7e63:8242:685e%7]) with mapi id 15.20.2516.013; Thu, 5 Dec 2019
 15:51:11 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf 0/4] Fix concurrency issues between XSK wakeup and control
 path using RCU
Thread-Topic: [PATCH bpf 0/4] Fix concurrency issues between XSK wakeup and
 control path using RCU
Thread-Index: AQHVq4PQ1sBcYCUWVkK5Ac3BLPjO3g==
Date:   Thu, 5 Dec 2019 15:51:11 +0000
Message-ID: <20191205155028.28854-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0044.eurprd06.prod.outlook.com
 (2603:10a6:208:aa::21) To AM0PR05MB5875.eurprd05.prod.outlook.com
 (2603:10a6:208:12d::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [94.188.199.18]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8a9fa294-290b-4847-9f20-08d7799af346
x-ms-traffictypediagnostic: AM0PR05MB4851:|AM0PR05MB4851:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4851C003B948E889250F382CD15C0@AM0PR05MB4851.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(396003)(136003)(346002)(366004)(189003)(199004)(6506007)(50226002)(6512007)(316002)(2906002)(81156014)(8936002)(102836004)(99286004)(8676002)(4326008)(86362001)(305945005)(25786009)(64756008)(2616005)(186003)(7416002)(54906003)(71190400001)(36756003)(478600001)(52116002)(14454004)(81166006)(5660300002)(14444005)(66476007)(71200400001)(66946007)(6486002)(66556008)(107886003)(1076003)(110136005)(66446008)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4851;H:AM0PR05MB5875.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0Nr1BjLZK1APFBHSrwHn66d5X5d4FnSWqR/HqDTrBdmfHLQG2OcH18/4rQ1zIoBLELS7wCffPTPPl23MfuKvPFMJoxwasmBBgRSuGb6XBjX5sVWeG80FngWkUI8Sai22vnaCvfUMddQlFl6bfyhFIqxoZp8xshR0cY2yUdOZrSwwi6+/Hno/gyrUxMx+Y5u+yh+mXVlCGvNObKr7ieaXUtLLLDD9JPpcnVe183BdIeozenwVcLwuGhMttmkRvfgAnUQFriR6xsVyEMTNwehb1SaoJadv0hwaiZU0IsCClZSUFX9qu71AYYUQKmrYDWjnLpCkhuVRstZy0WlDA2XHK3bmSsy/ukIa1QO2NOGsH1cUOwScm2d5SH04RnFfTqIBzrQXs7/7zLoJel/6viFR/CAfVm/TlZLRfM9aubgDNbWgZalaEt+BJ/NaQesYg8Bu
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a9fa294-290b-4847-9f20-08d7799af346
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 15:51:11.1359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LQwnaYHkk0tRRoa8wT9riqXHTHzriGGqgMmGH3/b/L8VT3uKIxtxjPBHGHVrm8UvHAjAs2R3uE64q75g4hxOUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4851
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series addresses the issue described in the commit message of the
first patch: lack of synchronization between XSK wakeup and destroying
the resources used by XSK wakeup. The idea is similar to
napi_synchronize. The series contains fixes for the drivers that
implement XSK. I haven't tested the changes to Intel's drivers, so,
Intel guys, please review them.

Maxim Mikityanskiy (4):
  xsk: Add rcu_read_lock around the XSK wakeup
  net/mlx5e: Fix concurrency issues between config flow and XSK
  net/i40e: Fix concurrency issues between config flow and XSK
  net/ixgbe: Fix concurrency issues between config flow and XSK

 drivers/net/ethernet/intel/i40e/i40e_main.c   |  7 ++++--
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  4 ++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  6 ++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  |  8 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  | 22 ++++++++-----------
 .../mellanox/mlx5/core/en/xsk/setup.c         |  1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 19 +---------------
 net/xdp/xsk.c                                 |  8 +++++--
 10 files changed, 39 insertions(+), 40 deletions(-)

--=20
2.20.1

