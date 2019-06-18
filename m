Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8361049E21
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 12:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbfFRKTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 06:19:40 -0400
Received: from mail-eopbgr10062.outbound.protection.outlook.com ([40.107.1.62]:15294
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725934AbfFRKTk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 06:19:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHHgmcHeV+yHP/i5GVfIh5VN4UeNC8IKsoOqzdkrN+8=;
 b=nnS9NKUevDHU0+eSUrgJnmlHSMsJt4ywLADshNRcHyV9ARnuBpvmIBN2DaUaeBHGQ/jXlsq6aKQ2fAeo4HBlBE9InF44XfiawsTBHrKIIJqON9/AZtZ750Y81Oi+q8n6HBMIYqaqV3JFGsfZVrE0Sw1acA2ayDdpC4Wo2RoycvM=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.186.14) by
 AM4PR05MB3138.eurprd05.prod.outlook.com (10.171.186.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Tue, 18 Jun 2019 10:19:31 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6%6]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 10:19:31 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
Subject: Re: [PATCH mlx5-next 11/15] RDMA/mlx5: Add vport metadata matching
 for IB representors
Thread-Topic: [PATCH mlx5-next 11/15] RDMA/mlx5: Add vport metadata matching
 for IB representors
Thread-Index: AQHVJUIm1iT82BVB3kyl3BqmLAQTwaahNBoA
Date:   Tue, 18 Jun 2019 10:19:31 +0000
Message-ID: <20190618101928.GE4690@mtr-leonro.mtl.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-12-saeedm@mellanox.com>
In-Reply-To: <20190617192247.25107-12-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0021.eurprd09.prod.outlook.com
 (2603:10a6:101:16::33) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:3::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ab55ec3-80ae-48e8-2b29-08d6f3d673c4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3138;
x-ms-traffictypediagnostic: AM4PR05MB3138:
x-microsoft-antispam-prvs: <AM4PR05MB31389357FA1B92911E5CEB88B0EA0@AM4PR05MB3138.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(366004)(376002)(346002)(136003)(396003)(39860400002)(189003)(199004)(305945005)(6636002)(6116002)(6246003)(1076003)(386003)(53936002)(76176011)(26005)(316002)(478600001)(107886003)(52116002)(486006)(68736007)(99286004)(6486002)(446003)(11346002)(54906003)(102836004)(6436002)(229853002)(6506007)(256004)(81156014)(6862004)(14454004)(81166006)(71190400001)(71200400001)(86362001)(8676002)(2906002)(9686003)(476003)(450100002)(6512007)(25786009)(66476007)(5660300002)(66446008)(66946007)(66556008)(64756008)(7736002)(33656002)(66066001)(8936002)(73956011)(3846002)(4326008)(186003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3138;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: S44Q3BzbU9eTx6PZn29vWbbt4bm3ZFTvJ4DGe3MfrwMSh7y8XvI5NyKRl+A+kkYt/6gpHl65/rXUTfcmWPEN1o3JT3o3mxjKMQ3npkhOLm/bEDww0Hen6SKSTQcIcjACfpj0+j1ZjfBzDhBxajzgPPIm6Oy7JItQbGxtU3dJZotfZ7JhC24JDwDNvgF7HwFdXk2GrTO4q+GZqIoiHReDa4wyW03SIKgnRmodF1eUMdaTTEY77SkUpQhdQxA8MmvmUfY1nVbOKniTYNUpZo8kq00GB3Tkt5qg5VjUBmefndDaD7BQGGaZVLdkqnVjEL138/V/kg11SAypIJZ9pGLzxKYXrcwOnblzvDJzDnMMviRAJwqdvQWQ9xIL87MR+X8PpcwamsovlsXNxR6ozp95STeG53TodjiRqgIG3y3chew=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E77D49567320B841AFDC4B9A6D11C371@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ab55ec3-80ae-48e8-2b29-08d6f3d673c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 10:19:31.3229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonro@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 07:23:30PM +0000, Saeed Mahameed wrote:
> From: Jianbo Liu <jianbol@mellanox.com>
>
> If vport metadata matching is enabled in eswitch, the rule created
> must be changed to match on the metadata, instead of source port.
>
> Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
> Reviewed-by: Roi Dayan <roid@mellanox.com>
> Reviewed-by: Mark Bloch <markb@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/ib_rep.c | 11 +++++++
>  drivers/infiniband/hw/mlx5/ib_rep.h | 16 ++++++++++
>  drivers/infiniband/hw/mlx5/main.c   | 45 +++++++++++++++++++++++------
>  3 files changed, 63 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/=
mlx5/ib_rep.c
> index 22e651cb5534..d4ed611de35d 100644
> --- a/drivers/infiniband/hw/mlx5/ib_rep.c
> +++ b/drivers/infiniband/hw/mlx5/ib_rep.c
> @@ -131,6 +131,17 @@ struct mlx5_eswitch_rep *mlx5_ib_vport_rep(struct ml=
x5_eswitch *esw, int vport)
>  	return mlx5_eswitch_vport_rep(esw, vport);
>  }
>
> +u32 mlx5_ib_eswitch_vport_match_metadata_enabled(struct mlx5_eswitch *es=
w)
> +{
> +	return mlx5_eswitch_vport_match_metadata_enabled(esw);
> +}
> +
> +u32 mlx5_ib_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch *es=
w,
> +						 u16 vport)
> +{
> +	return mlx5_eswitch_get_vport_metadata_for_match(esw, vport);
> +}

1. There is no need to introduce one line functions, call to that code dire=
ctly.
2. It should be bool and not u32.

Thanks
