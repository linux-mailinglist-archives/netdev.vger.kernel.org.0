Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38AB949E5A
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 12:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbfFRKi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 06:38:29 -0400
Received: from mail-eopbgr20069.outbound.protection.outlook.com ([40.107.2.69]:18510
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725934AbfFRKi2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 06:38:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6S9B3Au/mbddwHie3n8mTAkRNiAObKSSA/j/eqTSBI=;
 b=ahFoqCHvDUccNIQyJuxlg2cZj766y8PaQnoZM7EH11J9e/r0DusMw4+zzh8GHbknxCnCYPNL/MKYvAFNQETYOEh2qnuPPptCgge5Uwtp4LUhSyrZ4xFZJUmyoNF8lSq5mmn+onsRQoKJt1Fy9R7WXtT0ngV7aqBITjoNoBv/PBY=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.186.14) by
 AM4PR05MB3442.eurprd05.prod.outlook.com (10.170.126.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Tue, 18 Jun 2019 10:38:25 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6%6]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 10:38:25 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: Re: [PATCH mlx5-next 15/15] RDMA/mlx5: Cleanup rep when doing unload
Thread-Topic: [PATCH mlx5-next 15/15] RDMA/mlx5: Cleanup rep when doing unload
Thread-Index: AQHVJUIrMRwe9wL2GkWFpdKbtDzNHKahOWOA
Date:   Tue, 18 Jun 2019 10:38:25 +0000
Message-ID: <20190618103823.GG4690@mtr-leonro.mtl.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-16-saeedm@mellanox.com>
In-Reply-To: <20190617192247.25107-16-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR06CA0019.eurprd06.prod.outlook.com
 (2603:10a6:20b:14::32) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:3::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed5610d6-f9f1-40db-9b90-08d6f3d91800
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3442;
x-ms-traffictypediagnostic: AM4PR05MB3442:
x-microsoft-antispam-prvs: <AM4PR05MB34424A9F2ED633D941A87474B0EA0@AM4PR05MB3442.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(39860400002)(366004)(346002)(199004)(189003)(66446008)(6486002)(71200400001)(4326008)(6862004)(54906003)(26005)(450100002)(102836004)(68736007)(186003)(446003)(25786009)(81166006)(81156014)(66066001)(8936002)(476003)(486006)(8676002)(478600001)(14454004)(229853002)(33656002)(11346002)(9686003)(256004)(2906002)(99286004)(6436002)(76176011)(3846002)(6116002)(316002)(6512007)(52116002)(53936002)(305945005)(71190400001)(86362001)(73956011)(5660300002)(7736002)(66946007)(107886003)(6246003)(6506007)(386003)(1076003)(6636002)(66476007)(66556008)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3442;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QAhG9hA+ge4cHflbO6VqR60M3vEnNk7N/C/at21C4v2P5lF00werxRToWb93nf4a18ygjfMm8kOMU3bWeoR+ermZbdvX5pVaBs54xFlt3oBeQ3OBc0gvcnxa0qBoi1IzWl80yB+goxqEonbGGJk76Avk2LE2zxpMOcBX1XRvtx3ZBIUtv0zXSiOIoCqTjunpdUs/PHNEDmC+rfDvJiZydUGVnJiA9j/PkzPLuQO5cKjvxsH2UtV1jyKiBUbpqRplpZNNuWEb4Ec6vpFwZAS09/ap+8ob+LvPNW37R4nu1Air5HrImLM+FbzaBo1bux4hrNiZ6357qJJO5djdv6B1los0Z46JzML8BomyYVGE7gkVkaPSRrpLEHMegKk69KsTgecFHFyKquv0oOPhpof1HAN1moka5uANyF2LUnXYOKQ=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <92BFC6D9B624BF4BA7520001F32A998D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5610d6-f9f1-40db-9b90-08d6f3d91800
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 10:38:25.8348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonro@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3442
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 07:23:39PM +0000, Saeed Mahameed wrote:
> From: Bodong Wang <bodong@mellanox.com>
>
> When an IB rep is loaded, netdev for the same vport is saved for later
> reference. However, it's not cleaned up when doing unload. For ECPF,
> kernel crashes when driver is referring to the already removed netdev.
>
> Following steps lead to a shown call trace:
> 1. Create n VFs from host PF
> 2. Distroy the VFs
> 3. Run "rdma link" from ARM
>
> Call trace:
>   mlx5_ib_get_netdev+0x9c/0xe8 [mlx5_ib]
>   mlx5_query_port_roce+0x268/0x558 [mlx5_ib]
>   mlx5_ib_rep_query_port+0x14/0x34 [mlx5_ib]
>   ib_query_port+0x9c/0xfc [ib_core]
>   fill_port_info+0x74/0x28c [ib_core]
>   nldev_port_get_doit+0x1a8/0x1e8 [ib_core]
>   rdma_nl_rcv_msg+0x16c/0x1c0 [ib_core]
>   rdma_nl_rcv+0xe8/0x144 [ib_core]
>   netlink_unicast+0x184/0x214
>   netlink_sendmsg+0x288/0x354
>   sock_sendmsg+0x18/0x2c
>   __sys_sendto+0xbc/0x138
>   __arm64_sys_sendto+0x28/0x34
>   el0_svc_common+0xb0/0x100
>   el0_svc_handler+0x6c/0x84
>   el0_svc+0x8/0xc
>
> Cleanup the rep and netdev reference when unloading IB rep.
>
> Fixes: 26628e2d58c9 ("RDMA/mlx5: Move to single device multiport ports in=
 switchdev mode")
> Signed-off-by: Bodong Wang <bodong@mellanox.com>
> Reviewed-by: Mark Bloch <markb@mellanox.com>
> Reviewed-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/ib_rep.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
