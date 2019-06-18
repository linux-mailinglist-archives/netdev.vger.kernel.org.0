Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F19DC49E52
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 12:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbfFRKfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 06:35:43 -0400
Received: from mail-eopbgr10066.outbound.protection.outlook.com ([40.107.1.66]:60262
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725934AbfFRKfn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 06:35:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64fLS++ivFglkMgwYXaNmy0T5eXhuufbzPIRE8fgvu0=;
 b=K4KtA1TTQIu8tr5Oe1zM8qNRs5ADCErN08IGMux23xklLo2pTb45Emn+oufHqz+0OQbQJBfeaD2sYBi2kGyCeBVDTyig7bkHvBObo+fIxy4GUtwGI7Qcs6+McjzPplzlUif7k0oktpSuDnAPEQULBovbXKDa/mEIKQCBnO8sqJU=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.186.14) by
 AM4PR05MB3442.eurprd05.prod.outlook.com (10.170.126.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Tue, 18 Jun 2019 10:35:38 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6%6]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 10:35:38 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
Subject: Re: [PATCH mlx5-next 12/15] net/mlx5: E-Switch, Enable vport metadata
 matching if firmware supports it
Thread-Topic: [PATCH mlx5-next 12/15] net/mlx5: E-Switch, Enable vport
 metadata matching if firmware supports it
Thread-Index: AQHVJUIn+9aajRroKU+C8HKi5D94m6ahNZmAgAADAoA=
Date:   Tue, 18 Jun 2019 10:35:38 +0000
Message-ID: <20190618103535.GF4690@mtr-leonro.mtl.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-13-saeedm@mellanox.com>
 <AM0PR05MB4866AA7738F3DE1D3CF47FFBD1EA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
In-Reply-To: <AM0PR05MB4866AA7738F3DE1D3CF47FFBD1EA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR06CA0018.eurprd06.prod.outlook.com
 (2603:10a6:206:2::31) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:3::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ebc31f3-5713-45b8-83aa-08d6f3d8b3ef
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3442;
x-ms-traffictypediagnostic: AM4PR05MB3442:
x-microsoft-antispam-prvs: <AM4PR05MB344248EC7C78F26696215BEEB0EA0@AM4PR05MB3442.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(39860400002)(376002)(396003)(136003)(189003)(199004)(13464003)(76176011)(316002)(6116002)(53936002)(52116002)(6512007)(3846002)(256004)(6436002)(99286004)(2906002)(9686003)(53546011)(1076003)(6506007)(6246003)(107886003)(386003)(64756008)(6636002)(66476007)(66556008)(86362001)(71190400001)(73956011)(305945005)(7736002)(66946007)(5660300002)(68736007)(186003)(446003)(66066001)(8936002)(25786009)(81156014)(81166006)(4326008)(71200400001)(6862004)(66446008)(6486002)(102836004)(26005)(54906003)(450100002)(33656002)(11346002)(229853002)(8676002)(476003)(486006)(14454004)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3442;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HMJp0XccOIMcBHSlPTzs6d2vhK2WpR2wqCrbJmAgR4nFtOJ/exPQHv6/lpI89SagNN2x/yqL76+e6V6qG8wInSh95nX1blpqzlhetBT2nEdo85dTzySN+DD7wu35PrsBRL6R8/ffmEUi4UR3NiwH4veddAMaOy7pe5KV735XTFpnthk95QYij922e5awrxAruaI7d7UV3tmd0L7eW0MTE5fZXuBY1dNfb4gupLsh4RLr8sb0LQH9ymkgB6mV+FH4UImbOmbghMrgsXyA+AIw12Qsjn1+XJ1f4c64n12VLAilodeO2bYMw5C+4/ynq9mw+mKVBWlJlG/6+UNw7rWfET/tYasqeKRgvhwGKFEiQJd7bY3SLj+7loFoBlmJCBFl3DqOOzDzeBGLkCOp3fArPcN7p6ywT9dFZH46U75tnT0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <953718B094FA504982271FD642327A5D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ebc31f3-5713-45b8-83aa-08d6f3d8b3ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 10:35:38.0975
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

On Tue, Jun 18, 2019 at 10:24:49AM +0000, Parav Pandit wrote:
>
>
> > -----Original Message-----
> > From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> > owner@vger.kernel.org> On Behalf Of Saeed Mahameed
> > Sent: Tuesday, June 18, 2019 12:54 AM
> > To: Saeed Mahameed <saeedm@mellanox.com>; Leon Romanovsky
> > <leonro@mellanox.com>
> > Cc: netdev@vger.kernel.org; linux-rdma@vger.kernel.org; Jianbo Liu
> > <jianbol@mellanox.com>; Roi Dayan <roid@mellanox.com>; Mark Bloch
> > <markb@mellanox.com>
> > Subject: [PATCH mlx5-next 12/15] net/mlx5: E-Switch, Enable vport metad=
ata
> > matching if firmware supports it
> >
> > From: Jianbo Liu <jianbol@mellanox.com>
> >
> > As the ingress ACL rules save vhca id and vport number to packet's meta=
data
> > REG_C_0, and the metadata matching for the rules in both fast path and =
slow
> > path are all added, enable this feature if supported.
> >
> > Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
> > Reviewed-by: Roi Dayan <roid@mellanox.com>
> > Reviewed-by: Mark Bloch <markb@mellanox.com>
> > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > ---
> >  .../ethernet/mellanox/mlx5/core/eswitch_offloads.c  | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> > index 363517e29d4c..5124219a31de 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> > @@ -1906,12 +1906,25 @@ static int
> > esw_vport_ingress_common_config(struct mlx5_eswitch *esw,
> >  	return err;
> >  }
> >
> > +static int esw_check_vport_match_metadata_supported(struct mlx5_eswitc=
h
> > +*esw) {
> > +	return (MLX5_CAP_ESW_FLOWTABLE(esw->dev,
> > fdb_to_vport_reg_c_id) &
> > +		MLX5_FDB_TO_VPORT_REG_C_0) &&
> > +	       MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source) &&
> > +	       MLX5_CAP_ESW(esw->dev, esw_uplink_ingress_acl) &&
> > +	       !mlx5_core_is_ecpf_esw_manager(esw->dev) &&
> > +	       !mlx5_ecpf_vport_exists(esw->dev);
> > +}
> > +
> struct mlx5_eswitch* should be const.
> return type should be bool.

It is also completely indigestible and should be break into peaces to
make it readable.

Thanks

