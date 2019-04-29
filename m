Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A79C1EA4C
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbfD2SlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:41:23 -0400
Received: from mail-eopbgr50053.outbound.protection.outlook.com ([40.107.5.53]:34114
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729056AbfD2SlW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 14:41:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bE/3asS9+AdvQXnCYwwJMqIsAE65g1Y9QYXg2cl1ZX8=;
 b=pidzHfOQwkVrNX3391YQGTz2av3HfJiLe9uttnzupg8YpDBYyjOhXlFrBoR4qaui1+QxhoFD7zk9N5jnydW6btb7Fygp9VYhWRDe1C+HAN3X/fmvk0qOfNpSuGN2rySGr4XFKy/NcyNWy+flxtsUAnek7D4MoLEquFRRUXZC/jg=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.186.14) by
 AM4PR05MB3122.eurprd05.prod.outlook.com (10.171.186.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.13; Mon, 29 Apr 2019 18:41:19 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::edfd:88b8:1f9e:d5b1]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::edfd:88b8:1f9e:d5b1%7]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 18:41:19 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: Re: [PATCH V2 mlx5-next 09/11] net/mlx5: Eswitch, enable RoCE
 loopback traffic
Thread-Topic: [PATCH V2 mlx5-next 09/11] net/mlx5: Eswitch, enable RoCE
 loopback traffic
Thread-Index: AQHU/rdb4borx1pOqEq+F174SSAZRKZTeNIA
Date:   Mon, 29 Apr 2019 18:41:19 +0000
Message-ID: <20190429184116.GB6705@mtr-leonro.mtl.com>
References: <20190429181326.6262-1-saeedm@mellanox.com>
 <20190429181326.6262-10-saeedm@mellanox.com>
In-Reply-To: <20190429181326.6262-10-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR10CA0099.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::40) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:3::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [77.138.135.184]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7770c744-5d12-469b-5e6b-08d6ccd24511
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3122;
x-ms-traffictypediagnostic: AM4PR05MB3122:
x-microsoft-antispam-prvs: <AM4PR05MB31220B557111A6886BEDF92FB0390@AM4PR05MB3122.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(366004)(346002)(39860400002)(376002)(199004)(189003)(76176011)(229853002)(305945005)(2906002)(6636002)(53936002)(86362001)(8936002)(99286004)(8676002)(102836004)(6506007)(386003)(33656002)(186003)(26005)(52116002)(316002)(81156014)(81166006)(54906003)(478600001)(11346002)(9686003)(6512007)(7736002)(6116002)(3846002)(97736004)(446003)(486006)(5660300002)(6862004)(1076003)(6486002)(107886003)(66946007)(66066001)(256004)(450100002)(66556008)(66476007)(25786009)(66446008)(64756008)(14454004)(6436002)(73956011)(71200400001)(71190400001)(4326008)(14444005)(68736007)(476003)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3122;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VqzGuk4lKBk1V/vEaKCY1takR1DfQ77jvFXtsBVFonmW9rodS0Xub7LapLA9Ssw6L0uc5mIGX+ne10T7TCywJmLJHRFuKT070Yk+kfgmfTVUV/X7xakOc4y6sCIW509hp1cpTdefDYxNK1h1amsJWDtkE8i8GnqkL1vMpXrOBmBUUfUO4tuyn+b519P8x7eyGKZ/D4tVTHhpgjpkeT7foU2UnPFoC9hXk/5EKmmnt+m8VVPuK4Xx+QiEtoC+yW2e0BZsP7N4uize6pV0D5uAYkE01qzhms2pg/wLJ++pMBcM39eB2qgWIA2vEqc6PwcZ8kBySNSaAPRNt9nLozGsGryO1hYkMrqI/Qyz1CoygSTZS2nrCjuS3aIcB/ZAuISCtBfIvpGLLrSuGW4ypp6L2U74kCPAVLqIrW/38OT5fcY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8BDDE47243465F42B6415193B86D22C1@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7770c744-5d12-469b-5e6b-08d6ccd24511
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 18:41:19.6446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 06:14:16PM +0000, Saeed Mahameed wrote:
> From: Maor Gottlieb <maorg@mellanox.com>
>
> When in switchdev mode, we would like to treat loopback RoCE
> traffic (on eswitch manager) as RDMA and not as regular
> Ethernet traffic
> In order to enable it we add flow steering rule that forward RoCE
> loopback traffic to the HW RoCE filter (by adding allow rule).
> In addition we add RoCE address in GID index 0, which will be
> set in the RoCE loopback packet.
>
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> Reviewed-by: Mark Bloch <markb@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
>  .../mellanox/mlx5/core/eswitch_offloads.c     |   4 +
>  .../net/ethernet/mellanox/mlx5/core/rdma.c    | 182 ++++++++++++++++++
>  .../net/ethernet/mellanox/mlx5/core/rdma.h    |  20 ++
>  include/linux/mlx5/driver.h                   |   7 +
>  5 files changed, 214 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/rdma.c
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/rdma.h
>

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>
