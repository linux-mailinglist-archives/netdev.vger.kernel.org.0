Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3660586CAC
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 16:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbiHAOPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 10:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbiHAOPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 10:15:45 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0FAB4B6;
        Mon,  1 Aug 2022 07:15:44 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2719kp1J007593;
        Mon, 1 Aug 2022 07:15:39 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hn20q7bcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Aug 2022 07:15:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgJEVTaSDFEnwzx6IDKE+DCrrBgF+VhEy+KU0kQUSVImClS+tHtazhRtAmOzsaViGTSX/svW6j3fFlNPmfzkYb9ngVqx9ozFqXaSvIed5mB3NnpRsygwhSm6Meuy7xOl3iS4Ge2iG2GPMnwlA2gN8h6paYYuFTbZEz4eIXSSODGnvx/fujdmSarqhG7wIHbu2FlfYxs8uPME3hX/69o6u9q6TgjDKCIsEwQZKuKSKB1k1/lzqMm7IOG+84ZmosAhINksyLuNOOEsDXUOceBbGseSIwJEw9R9zXZusr3J6Dn+8z2vPemzeHG4GbfM9ZVzMYEPaSuNOgPLetd305u2LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cPmk+F/s2S475PG/V+mbWxMt8nRpgDdIkD+OHhnkNfM=;
 b=b0AUufta9pqlUQWloWU4o6MLabOhdT0Nidm60kkgDCHBSAevlVx5DVYPHj+nXIInWQJa5B7OZaai3gIPUZOLMOyKjGFgXXl7EHMCCIEVp14oTdKOsE4+kFV9aKfIt9d3UHbip3mn7bPXstPcuuIe4OdYqqN9NSxKgoeSjZOzX2zzPatvjIVz/BUdYrknAtDd52jWK8NXeM8UhqdSQwQ+TzuRaN7+Wcc/x45t9XZxOZT6UVfNrKkg57a37vT9Cy13r9Cjks8b6uioDnYMtjsUeULCY4RHp8Z54Ivy6/5hxETQHcajUbnpt4COBAMUFl2QPtzH642Tj5gqOXAnta2jvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cPmk+F/s2S475PG/V+mbWxMt8nRpgDdIkD+OHhnkNfM=;
 b=Q0ZEWb59qDntJAs1iUaJtZT5eDRRJZ14TwHfxV3E9jLhvPL/SBWWKdZ7aq3AauGoVexDKpOZDvjlvOa0bpW/3GjI6/3rUycYzAIHtKxQaOpnU0QT3UfyYGk05lt9loJ4CYLR66Mjwm+RHXKT6ZtInHAPRykamd5T3FBCnpgCLEU=
Received: from DM6PR18MB3212.namprd18.prod.outlook.com (2603:10b6:5:14a::15)
 by MWHPR18MB1343.namprd18.prod.outlook.com (2603:10b6:300:ca::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Mon, 1 Aug
 2022 14:15:36 +0000
Received: from DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::adf6:d89d:1ebf:d956]) by DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::adf6:d89d:1ebf:d956%4]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 14:15:36 +0000
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     Naveen Mamindlapalli <naveenm@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Subject: RE: [net PATCH v2] octeontx2-pf: Fix NIX_AF_TL3_TL2X_LINKX_CFG
 register configuration
Thread-Topic: [net PATCH v2] octeontx2-pf: Fix NIX_AF_TL3_TL2X_LINKX_CFG
 register configuration
Thread-Index: AQHYpaOhgeUqDdtqLk2504SKJns00q2aFrXA
Date:   Mon, 1 Aug 2022 14:15:35 +0000
Message-ID: <DM6PR18MB321255ED74C5684CB2B37748A29A9@DM6PR18MB3212.namprd18.prod.outlook.com>
References: <20220801123831.9370-1-naveenm@marvell.com>
In-Reply-To: <20220801123831.9370-1-naveenm@marvell.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0cbe51e-5a05-4f4d-50bb-08da73c84da8
x-ms-traffictypediagnostic: MWHPR18MB1343:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j52zEvkHfcNl0tY0huLk49RxMJvSwzIo2nPzN+TOovE8JYObbf+Xw8IN+2VT9h6htHOgtCY1mE5cveK3mF4TJ8qReNbFXziGQAm2lVV0OErXPIM7D8U9aiXpPPnrb8b0iWypQ20KZwPP9OQE313IvYhSPc12/WoYpjO451beAAMzghtI4x+GeNTOGhrUX69ELAhmkl6pYq0Tp5lqwh6ES5ap2Rscz/FjOGMKthpcOFGFjEBLQKtVVoAazxJoJ4J7DqYzBuD+xBhXhWNADrlPPro1xODRcNr6w2eopM0P5c97IdmIm6rb//bPM61BQ18ahtOToQuqDuKp4ET/NziJmys0heu0a0f5zi4Ph4SXRO9SPzS7v4AEzEORppUj9suQnUJGIvo9pI08S2saXqK4h9FtOem5yMl2Q39yDOW9v9Y+w5vYoUPwYdTXjqXh15tJr7FhbNTeMsh1+ZtvbSKtteWMR3tcxfDT+/4oUEl9FXEcI+4QR6E0rhuFVbKo7XNhuKeYzmK2lx9WUlVF3FDY9HDFah0qYJ6vkRxB5rTpEQTAKgIaV3XG8I/Gn2p4+1z15mgbO1ikJEW537zDYnmcZj3pjP7ywMql/DUytWZhyPvVZgBUdxFlgpWVmiElsICIfwkBQg2F1KsZwiqilyEB28hOV8ed9+0J3h8o0oGXozabY0pVzNXv8jENLOS1Lg7MWIH9uVUxTO+WosF5KVlZBePGaA3RzeSME4cy3lpMtodJ+mRlmBiVdcoS9ydcr4C+tooD8bSpWmU+Y2U/iCip0cMDW25begiS1LvyVu/2Hwml8ZzflXxgu+niB9xQezYM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3212.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(478600001)(71200400001)(86362001)(110136005)(33656002)(41300700001)(6636002)(7696005)(6506007)(38070700005)(9686003)(26005)(83380400001)(53546011)(186003)(316002)(2906002)(55016003)(8936002)(5660300002)(52536014)(66476007)(64756008)(8676002)(66446008)(76116006)(66946007)(66556008)(122000001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NPbBOir5A+D0mFS9LpEKdlldXhj8l5U6FGFNjNdwb//vGNUNzHH88vsqYAPW?=
 =?us-ascii?Q?2Lzv7cliItK+cYhs81Gbol3f3wuKpyxSlJAK5cu0dsHpENbi+TQ6e6OYdx/i?=
 =?us-ascii?Q?4foCu+pO3PHB1akxQsLVuBphu14y4puPbzl65UK3DtR4krvjKOJ7pLL4PswW?=
 =?us-ascii?Q?D9EMMSBLY3VLE2V6MXKjvTrlJhyPPCDaDs9mw8cQfFeOLQ2tP6AjkEKQeJej?=
 =?us-ascii?Q?QTQOCdA/SZAn7cTeByFB++9ZeW76fF0HXmIINUeWt86FMCziWJy264J86ioM?=
 =?us-ascii?Q?tW39paZkCG26S0RM3NcvUoWHtTfKmUMcInYvwmVykALBQYDwZRxkIA8W7jut?=
 =?us-ascii?Q?UTVT/Ok9AxWc3DrQyP1mZqAxfIdCyPO0er9xUciJggOLFGCAbQwL4Takc4Xm?=
 =?us-ascii?Q?pKWxOu6+QYDH1BuT/gegWB0RFAyGvui3oL9hzgtx092lOl4JE+7HleAA26kb?=
 =?us-ascii?Q?0a1ztGCy9Qp/B10oNKbYFYrdgZTc4RLAwUsx24Af9pnOYuRJNyada8w+p7WP?=
 =?us-ascii?Q?nrngGkEjnX/oySJyvu6FN8MWBgcsbQm4em++J7VM5Ot5mPK1532ydYh+wCOz?=
 =?us-ascii?Q?llgXit5mNaSkTiCvjnWj4d37dW6RVJd4Tm5gJL9bhQPCdl4nkaH8Y3D0EfBI?=
 =?us-ascii?Q?l2vZGL4SqNu57upIRyPiliIKgz6AYHa1mV5NiTalyF2uEh9wEV5dHLdax7V6?=
 =?us-ascii?Q?CSQLV7JaOUsSW3OR0MgND37kx3eJ46xITlbMovBbnKleeOw9WDIpQaTu4y2r?=
 =?us-ascii?Q?MfcJwN404aPO7UIGGPvBFMXY2rTGbqPFg/xS9XUB+ok8jRNEaqPKe07IveJi?=
 =?us-ascii?Q?d+qkj45bvP+j86YWXoooNstZSDTGVDKxcB7l2V1Ioy9x/b2SyHKjPEr+IgK6?=
 =?us-ascii?Q?7MpL4sHfOKCbHk3G/RTGMUuMUaErJK9RfQteByvakFiZKGUYXWXRBLbmOToe?=
 =?us-ascii?Q?iZirOxB+rIbli03+X6XFXlXiqVhRx2Y8l+chG5vxnGadMdaVpnCTnWXDVTYY?=
 =?us-ascii?Q?eYig7zmSwBNtDfvhsA/6s5myeiEBGUpPiP45NlWYCErlQsEGRjZpNhhi4m86?=
 =?us-ascii?Q?TSRN7+pRsGEV/hqWadptFQNYV4fbRV10YVRjNy85G6Nq6LFtHl9Jb2CXYhOO?=
 =?us-ascii?Q?Wb6eFXMV/g8bTHC6u4ZorlRpI9/gXXt2C8ZQzv0qbpTOpMEXyGjkZhXUsJLf?=
 =?us-ascii?Q?sdFXE8dLoxK5IgYcGp8EWpF7YA32tMG9HayW0kHSHeYqPRQ0T2dwuPa2u5gW?=
 =?us-ascii?Q?c6aAwh2jloYtNbhxD4oUY+IZV3aceNr52IzDMNRJHCiZ8Ty7iCAm1UGts2u5?=
 =?us-ascii?Q?FGUE7D62QfqncMIR9ufFrvMVpWWnCziAbpYd/fFht0E3GD/FSn0jEnfjNed+?=
 =?us-ascii?Q?Hb517V2hete6kFnZ/gPK8BJSx2KMS6zadpVUW7oXCjO/TH+klpL5NoZSjln+?=
 =?us-ascii?Q?CjiFvJY6mb4iusSZU4uCIt+2GI3+9/rQeK6FWdPpDorrGwNxH+w8VXujQjmk?=
 =?us-ascii?Q?CX34jS8yeiif0usBS5o80fkFiE4SNobYgSuOGTFp0Yb8h7MwsJjAUDqtXEKZ?=
 =?us-ascii?Q?9VVOUbby8oBxyE5e498=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3212.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0cbe51e-5a05-4f4d-50bb-08da73c84da8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 14:15:35.9563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IALd2AHyO8kBiPW5ooub5UUsHAbrCAWnppEs7Zq3XXdD1hPJXd1fjcHU/bEBFGMMOQPvPH6H8mKuBbqyQUmDZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1343
X-Proofpoint-GUID: 83g3OeWT6rp7d0r8tp07ak1eNcWDfvwB
X-Proofpoint-ORIG-GUID: 83g3OeWT6rp7d0r8tp07ak1eNcWDfvwB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_07,2022-08-01_01,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

Please ignore this patch. Sent by mistake. I will send v3.

Thanks,
Naveen

> -----Original Message-----
> From: Naveen Mamindlapalli <naveenm@marvell.com>
> Sent: Monday, August 1, 2022 6:09 PM
> To: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Cc: Naveen Mamindlapalli <naveenm@marvell.com>
> Subject: [net PATCH v2] octeontx2-pf: Fix NIX_AF_TL3_TL2X_LINKX_CFG regis=
ter
> configuration
>=20
> For packets scheduled to RPM and LBK,
> NIX_AF_PSE_CHANNEL_LEVEL[BP_LEVEL]
> selects the TL3 or TL2 scheduling level as the one used for link/channel =
selection
> and backpressure. For each scheduling queue at the selected
> level: Setting NIX_AF_TL3_TL2(0..255)_LINK(0..12)_CFG[ENA] =3D 1 allows t=
he
> TL3/TL2 queue to schedule packets to a specified RPM or LBK link and chan=
nel.
>=20
> There is an issue in the code where NIX_AF_PSE_CHANNEL_LEVEL[BP_LEVEL]
> is set to TL3 where as the NIX_AF_TL3_TL2(0..255)_LINK(0..12)_CFG is
> configured for TL2 queue in some cases. As a result packets will not tran=
smit on
> that link/channel. This patch fixes the issue by configuring the
> NIX_AF_TL3_TL2(0..255)_LINK(0..12)_CFG register depending on the
> NIX_AF_PSE_CHANNEL_LEVEL[BP_LEVEL] value.
>=20
> Fixes: 5d9b976d4480 ("octeontx2-af: Support fixed transmit scheduler
> topology")
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> ---
> v2:
>   - Added more details about the fix in commit message.
>   - Added fixes Tag.
>=20
> ---
>  .../net/ethernet/marvell/octeontx2/nic/otx2_common.c  | 19
> ++++++++++++++-----  .../net/ethernet/marvell/octeontx2/nic/otx2_common.h
> |  1 +
>  2 files changed, 15 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index fb8db5888d2f..d686c7b6252f 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -632,6 +632,12 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lv=
l)
>  		req->num_regs++;
>  		req->reg[1] =3D NIX_AF_TL3X_SCHEDULE(schq);
>  		req->regval[1] =3D dwrr_val;
> +		if (lvl =3D=3D hw->txschq_link_cfg_lvl) {
> +			req->num_regs++;
> +			req->reg[2] =3D NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw-
> >tx_link);
> +			/* Enable this queue and backpressure */
> +			req->regval[2] =3D BIT_ULL(13) | BIT_ULL(12);
> +		}
>  	} else if (lvl =3D=3D NIX_TXSCH_LVL_TL2) {
>  		parent =3D  hw->txschq_list[NIX_TXSCH_LVL_TL1][0];
>  		req->reg[0] =3D NIX_AF_TL2X_PARENT(schq); @@ -641,11
> +647,12 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
>  		req->reg[1] =3D NIX_AF_TL2X_SCHEDULE(schq);
>  		req->regval[1] =3D TXSCH_TL1_DFLT_RR_PRIO << 24 | dwrr_val;
>=20
> -		req->num_regs++;
> -		req->reg[2] =3D NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw->tx_link);
> -		/* Enable this queue and backpressure */
> -		req->regval[2] =3D BIT_ULL(13) | BIT_ULL(12);
> -
> +		if (lvl =3D=3D hw->txschq_link_cfg_lvl) {
> +			req->num_regs++;
> +			req->reg[2] =3D NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw-
> >tx_link);
> +			/* Enable this queue and backpressure */
> +			req->regval[2] =3D BIT_ULL(13) | BIT_ULL(12);
> +		}
>  	} else if (lvl =3D=3D NIX_TXSCH_LVL_TL1) {
>  		/* Default config for TL1.
>  		 * For VF this is always ignored.
> @@ -1591,6 +1598,8 @@ void mbox_handler_nix_txsch_alloc(struct otx2_nic
> *pf,
>  		for (schq =3D 0; schq < rsp->schq[lvl]; schq++)
>  			pf->hw.txschq_list[lvl][schq] =3D
>  				rsp->schq_list[lvl][schq];
> +
> +	pf->hw.txschq_link_cfg_lvl =3D rsp->link_cfg_lvl;
>  }
>  EXPORT_SYMBOL(mbox_handler_nix_txsch_alloc);
>=20
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> index ce2766317c0b..f9c0d2f08e87 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> @@ -195,6 +195,7 @@ struct otx2_hw {
>  	u16			sqb_size;
>=20
>  	/* NIX */
> +	u8			txschq_link_cfg_lvl;
>  	u16
> 	txschq_list[NIX_TXSCH_LVL_CNT][MAX_TXSCHQ_PER_FUNC];
>  	u16			matchall_ipolicer;
>  	u32			dwrr_mtu;
> --
> 2.16.5

