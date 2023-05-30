Return-Path: <netdev+bounces-6224-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4630B715461
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 06:05:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F21EA28104D
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 04:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF0C81C29;
	Tue, 30 May 2023 04:05:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDA01C08
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 04:05:55 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E151994
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 21:05:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P4RRUBAv+a368BlSc/qFu+m7EnkDgpZDwGvXOdmuT8YUqq59Mc2jZT1y5PuY1KAvfn12JfQzeptrb81miKJ1rrkjIbeNqyhlZkG1EQisv0rq6oPgyyQRy5PjbExQfeqwFY0/9YSv8WGDkGSWqMUXPvvsZvhUVxuugI8Gr+itupwGhtbz3VS6HFEgtLXrVqZrRvNyNNNBGADJplX9crWmV2wI8TXvw5epFoBC7ORm53w3XaQfMdrV3a3/RjpiY479bV/lTgdCkgOETcb1/RfMD8yMG4JwVfGzNWVvqWkjU+IN/J8LWH15cjC4jZu2KsEqnR+KYF78ymw/wjSdESc1Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wSrH4KbSAhAJVmVYxe4zloIxYjCxpv0nlMeOBbAUdAo=;
 b=GpHDqc2r6bySiRWsoSnApN5cPaPbU2Gb7jCt8rBvkqAcTwuzPWKupcaEbcPujqI5SNBoKZI8j/ztALTwBuExLDbIx8iCLdsfBVJ9+po030ruiQxzS8t6ML29hFW+s5SEir7KPDhxZ940I5EV5xLvn9dx4maWy4U0tqDFGeXM90VCoeJjUuwmnsEJEZFXAjmUfn+sKjF0OVONy6uCePhqPrE3UqgMLoi+OxoCRw+aBCSG85eXu7AHsJs/DA+rWbocWLXGvFMdfMbA6+GXLvVdttcWKhvAvP5SRJIcHNY1dGCJaco1N7mfllsz7cv84iyzilaYCyhoSLF1/Em/r4stHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wSrH4KbSAhAJVmVYxe4zloIxYjCxpv0nlMeOBbAUdAo=;
 b=HGhHko+d3RwR0o4m2Vs6E6glzJLC0q/EUE9XJBTCOIRjj0wWImpKW1zehzlOqZDBsxkPUeoHbAtRj0MNV8iVFmJobNdR0hzNsyRtC71kMGyLwv3YfPf0ZiKgMJeWNlz8ZtuTQk23wHf5HZqWOVTDjWKAMWK72Wa8I7Jb+I8f4axnYIVFzy3oB4Wlx7ZihHFPJv1UfsS/hGMRRnA8X4Nbva0wY8I/pF+Sxi2+pPmgolCiuReeg6Hcqx8qOD5IDzM8DXQRpkMD1AnxMXvommbEZlPVUl3URMgEum0CTG2xgjLQQEAy4xPb/OPAowKIIdNyKjeYFG6kWPI5pi5dFBZqnQ==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DM4PR12MB6062.namprd12.prod.outlook.com (2603:10b6:8:b2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.22; Tue, 30 May 2023 04:05:51 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::824c:2f44:2922:fd76]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::824c:2f44:2922:fd76%5]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 04:05:51 +0000
From: Parav Pandit <parav@nvidia.com>
To: Andrea Claudi <aclaudi@redhat.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
CC: "stephen@networkplumber.org" <stephen@networkplumber.org>,
	"dsahern@gmail.com" <dsahern@gmail.com>
Subject: RE: [PATCH iproute2] vdpa: propagate error from cmd_dev_vstats_show()
Thread-Topic: [PATCH iproute2] vdpa: propagate error from
 cmd_dev_vstats_show()
Thread-Index: AQHZknZm85wbHSW/JECIMva3pLFHNK9yMvqw
Date: Tue, 30 May 2023 04:05:51 +0000
Message-ID:
 <PH0PR12MB548115D8A19BDD18B196AAA4DC4B9@PH0PR12MB5481.namprd12.prod.outlook.com>
References:
 <5290b224a23e36b22e179ca83f2ce377f6d8dd1c.1685396319.git.aclaudi@redhat.com>
In-Reply-To:
 <5290b224a23e36b22e179ca83f2ce377f6d8dd1c.1685396319.git.aclaudi@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|DM4PR12MB6062:EE_
x-ms-office365-filtering-correlation-id: 72936283-b2aa-432e-6c2d-08db60c32881
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 G14zirwDtrsh19VqxePNt3K++oW4Dp4PVfp7OJA0k7yo1uJ/98imFgRal1gEx+NWpX6PFJt/8SooJHfYWuZuE6LP5oQqOjkJslyHntr6NZkVeCM5RDB6+/YZgNFUn3Jgb7TQoWxp8Nz/Dtgq65gRIpkrJ5QovDxlCbieFD4EkZZN+5mS2Juf2lCFz9GqP26+Wp3Gk0FdOFSFbIOomB00lXulK/M0qnmmUPN/MrAarcpBd3okvyQJtvPP5SJKhMKVbF3CZwf7P3AflsKxF4XiEQdfkID2pImPsVR7umSWXy9TV+wdhtR/GK3fJHgvS4rLRuA8i5HfdHT9YoJ9PzBov432BXc6nLza7Jsed7c8zvdLDULAvGDUfnQVkrfP8oq+SctskumxBPENMPJdNrs08SVGxhf7IellfKKv7CUOZFeLj6DDFPtddCXxX+9Umh3xgbo67WfnTdQjjia8CpM/Gmpq5Fn7FYas/kIzUfgWqCoqYcM/G7M2QwYpTm0QJhnxeWK0vs+rT/IEIvcQRxYpCRHVNCOikp5IvXE494fVBRWZvj4v47yxvosUchXn+ZjVR+/Hro5GXQozGEFXAGo1AXRwvOwc/0lSHOV9U3zZdxpECiYjc2JcMzOIeUwmgFMS
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(451199021)(38100700002)(186003)(41300700001)(83380400001)(9686003)(6506007)(26005)(7696005)(478600001)(71200400001)(110136005)(54906003)(66556008)(66946007)(66476007)(76116006)(4326008)(64756008)(66446008)(55016003)(122000001)(316002)(52536014)(33656002)(8936002)(8676002)(4744005)(86362001)(38070700005)(2906002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Y+HnkjaQumF06jdqS2HXEw1GbxdwYXvByFIC02Wjw1MR27ULSFJnqqJH+Q1V?=
 =?us-ascii?Q?s15hb4EcCxClBJjVLr0bog9+f2tO9qDXSTdbTrA/Gklno5rd69L1ZTvC2PC2?=
 =?us-ascii?Q?Q7clgfV5ZjdMtXFxU7fkHaY5fvfG9cnqVBHNXz2dO1mZ5REp1yu7GdHKfspo?=
 =?us-ascii?Q?w8uCDRsjINt1TKTXUBvZRonOS3TXrRGaIVOHz0K6k9slBZEOgKP9J1E8PuL2?=
 =?us-ascii?Q?Q8aNrXl66wMOABxPHr18T04/LnznfvEyixF8xAfOUJeYghAW17dZKCbMyOTL?=
 =?us-ascii?Q?EUSUpjQ1gw02xs3t2DHdkzidtkOWts2KHqmBW4fB5yGRWZouRbGBUiQkm6T2?=
 =?us-ascii?Q?0ACGEBm1nqWSUuxI4U1tPw3jwz2n+Hhnhw2oQ03Z+CsVkPGa5KvG2fjwihDE?=
 =?us-ascii?Q?ipuN8TghTxI/z2ZM1tMlPrKiBwpSe4tw7qVMT7qASuIuoZgEX0mVOPL4nOJE?=
 =?us-ascii?Q?rnPP9BSURxZD0vdPEU2BtgvXa6UlW+SVB1cRw9q4s+dHSInFtxulM2Kn/yU6?=
 =?us-ascii?Q?YDXnbkfAcbSlCHq8Rn8wDdQasjzG7Sa6BFo0xTfIoAAOP26l+1Zy/ocsoOMX?=
 =?us-ascii?Q?cL9gWBEJZQU17wgPqkLt+m601qen0/o2eiIvQOKpb+w6vZzv2Ie/ehKdLvmR?=
 =?us-ascii?Q?AHPBUzQyBtEl1KUH/nA4Sl4jMUDzONXpULsSv2wEMQRNJpTCwqgKpe5eJeSM?=
 =?us-ascii?Q?MhUBolVYFgl2MNBE6S0ZFvaYizHIaPIHhSncPBz61U8ZhHXXM94+rqatBkDv?=
 =?us-ascii?Q?NTrhpIVJL+VUk52sR2ysD9Vqpv1Q8Ks9vE2H/WgeWsONfLB/epCY+yRJtFwW?=
 =?us-ascii?Q?s4jtfYgnvkHFZUmVvRos4A59no1bx9FqRhL91QwIr0RL5Nl8FnWwEaozzlHC?=
 =?us-ascii?Q?NdGKp0lzPuQKUqzixZvzzTMM58lGSZR1unkDIMhHKcinElwslksmqFm+CA2o?=
 =?us-ascii?Q?5elv6eSoIZ0t+Wk2skybebfxTOf+wAnsUe0HH1AQE+vHOCFEnt1KQ17Synl3?=
 =?us-ascii?Q?Qznq0VBxVCseY4mEaEL/2Y6CZmsVlur0DexkKqq3A0R2zOLobZMbbW8KWXiO?=
 =?us-ascii?Q?OGtUOL2UhdjJ9B13TBbWm42UhJpNn29U1H0azibDDsv6/TuK5HqvVP443drE?=
 =?us-ascii?Q?pHYL2ayVtRq2nFefMzrFead9x2Dpo+69tG4zb4FawBJKq8fsF7PVccKbehFT?=
 =?us-ascii?Q?hvJwqI3R6uxNYp8awdi/JIjFzJAb31yJekY8OtSfi4UzmMI5j9/3P2G8RYSH?=
 =?us-ascii?Q?pwveaTJmeSAWNS3YfYdyhSVlJdr5/MyPYX/LG//knjFcfgPWOxjKMoGXMRIu?=
 =?us-ascii?Q?omldyGZtR2u5qlzxpwgUL+qMMWpzoZsjCTW2GRlPIjOXkbXexRF6FtlD7+hv?=
 =?us-ascii?Q?e6aNZ22EjHzfPNHU+VkwxtbWdHaHcE6gw6kgaVjR6lvWA7/s5zifMFNbBl0S?=
 =?us-ascii?Q?1kiLZToto58QFoF//zFIkB32Qn6WCEz2x2HbIcPWeCs5jk/V9nZwyNoQOMEL?=
 =?us-ascii?Q?5MNYf+TT+Mv/K20x5fDgssIyQGlTKd9iH/NdDHy5mA5xz3mIqa4R+/w72eoF?=
 =?us-ascii?Q?1kG0fTJQWw6l7+Q0hDw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72936283-b2aa-432e-6c2d-08db60c32881
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 04:05:51.7348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HuW+wCixT75WmYTIUwVYwuTQOrbUksrDRksDMQ6w87PgJLlFg+XZmwEI1FiCsji2cEx8GFY1Xo+TOl7DD+dJzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6062
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> From: Andrea Claudi <aclaudi@redhat.com>
> Sent: Monday, May 29, 2023 5:42 PM
>=20
> Error potentially returned from mnlu_gen_socket_sndrcv() are propagated f=
or
> each and every invocation in vdpa. Let's do the same here.
>=20
> Fixes: 6f97e9c9337b ("vdpa: Add support for reading vdpa device statistic=
s")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  vdpa/vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index 27647d73..8bbe452c 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -986,7 +986,7 @@ static int cmd_dev_vstats_show(struct vdpa *vdpa, int
> argc, char **argv)
>  	pr_out_section_start(vdpa, "vstats");
>  	err =3D mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh,
> cmd_dev_vstats_show_cb, vdpa);
>  	pr_out_section_end(vdpa);
> -	return 0;
> +	return err;
>  }
>=20
>  static int cmd_dev_vstats(struct vdpa *vdpa, int argc, char **argv)
> --
> 2.40.1

Reviewed-by: Parav Pandit <parav@nvidia.com>


