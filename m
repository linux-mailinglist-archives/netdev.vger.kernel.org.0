Return-Path: <netdev+bounces-7443-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3AFD7204FD
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:57:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1178F281944
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20DDC18B13;
	Fri,  2 Jun 2023 14:56:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B18C10796
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 14:56:58 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAEE1B7;
	Fri,  2 Jun 2023 07:56:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhlTV3Z5OAuJggO4LUyHkgDiMzv68gGVYCdV/hEOzaLDGFMz/FVh6qAWT5L4xBQl/xWWt0gdJSkZn3rZqas3/l/+a/ESzj7MSz453VpAYYLN/3A7SVYTR+rMzi/td8ALoQ5pXnpVNtoWcmBNCt8eBN0Seb8+vrHaag0q1NBeLizV1FxO730lR773nqSO8hTjvn1Dz04Pv2LpBjxh/Ywq1EJt4LLEBxYT9QPqJYM+XmRnarzqHCem+fUNj/uBBra3C6zPUxyFX14LrItyOQVo3RrHU7+6ro17G9TwVmfA1aj2Mwbhll959Ddi9qM+acJH24SK0u/hb0pH7lCKc2dekA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ekiua7qi7oEkHl1pSdkpR5scigVWffY7M/HMGRhXNEA=;
 b=Fap7tPG/O+v3ht8e57FG9aWWgZAlh1rffIrnj/tSdbYpOBXIwhxlkq9+QeM/bFPU/cRXsbb6ofixPknH/343jbDkao7SubPPmFPTe8KpONgVKKd+69m47bR2cz9ckto8Ji0PNyY4a/OYdYF1du510pFIeXRsZNZe9gSYWzoJ3A1gOo+0jjI8F9cxV1Pm11G8HwZGvA4ykZ7+rdIDYI4TuXTgZGWlFD4WNj6NvjggtEC+QQkKQoxS2h+sZt4qsaSFCAKvhXXpwP6JZtZkmR5ruH2Iv07V1u4rVop0mmr67rRldYwqD5oK0PW83g/rY1Uk7LrZ21429ivu0s8NYdWB/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ekiua7qi7oEkHl1pSdkpR5scigVWffY7M/HMGRhXNEA=;
 b=gZKY7ux/IYagYxDZr+PQTCVS+9CDP/vhP/iMMTzMcbumkbmM2pcjz32ImOpVN/aEITap++TZ7KjrngtHqGLD77vHxnQ5WKCy7mmUWfnUfzfwhC2QmE/6cbLV6wuLDFyPy5KJ5vrsxLPXxk5l9DNlwRBhWMLogNSuGKLkMuStINTDfMPoWADgkYzmwBZOLJfTdQ3sxuyKnbyMeRtwXn+kTamBA3P+53irLByASv9mArkRF9Wirxi5hahtiBddUWWZoWD0EvoZFu/LQqOWn82+XdJYG+pLJPU8aQGMXfvUdMTbhy0XqkLYZI229XzH56WieD3H1JLn4VQ4STLBVrYqpQ==
Received: from DM6PR12MB5534.namprd12.prod.outlook.com (2603:10b6:5:20b::9) by
 MN0PR12MB6102.namprd12.prod.outlook.com (2603:10b6:208:3ca::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.26; Fri, 2 Jun 2023 14:56:50 +0000
Received: from DM6PR12MB5534.namprd12.prod.outlook.com
 ([fe80::f206:2bbf:7006:2fb3]) by DM6PR12MB5534.namprd12.prod.outlook.com
 ([fe80::f206:2bbf:7006:2fb3%4]) with mapi id 15.20.6455.024; Fri, 2 Jun 2023
 14:56:49 +0000
From: David Thompson <davthompson@nvidia.com>
To: Jiasheng Jiang <jiasheng@iscas.ac.cn>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>, "mkl@pengutronix.de" <mkl@pengutronix.de>,
	Liming Sun <limings@nvidia.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mlxbf_gige: Add missing check for platform_get_irq
Thread-Topic: [PATCH] mlxbf_gige: Add missing check for platform_get_irq
Thread-Index: AQHZlFEGLh+roIfUHEuJJeLaBTGvMa93mzUA
Date: Fri, 2 Jun 2023 14:56:49 +0000
Message-ID:
 <DM6PR12MB55342319E09EB4D03773C2C5C74EA@DM6PR12MB5534.namprd12.prod.outlook.com>
References: <20230601061908.1076-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20230601061908.1076-1-jiasheng@iscas.ac.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5534:EE_|MN0PR12MB6102:EE_
x-ms-office365-filtering-correlation-id: 3ebc441d-8760-44ef-6dee-08db63799832
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 TWJMxueBgJX7vCwJbqdszmwKyjV687ZySJ5MgeBgz3qiB5lctB2+9FLJSSVz5KPam/GGEy8cWcCkVsa5Qzd6lK1pzPMGVH589mHXrFCHKNl9dXZk/NCZnW4H7LjT/4FazENkV7+jrvmXT3KG1HS3ExEC18O5lqP7ajc76sD5NLdKnhkkYb586L1ZdrXLtJ9OiIM3LVoT7lQFk+mMmSI1wWfHnc2JOEnEwtW179D0UFzR7GcMengnBepCdpvffba885mhRY9a4ICLP8Ayb1eHrtDMA0f3KQBuuSHmHqMAK8QXUZ8Ll5EJWALdpSIrjON1UXkEEUwqzVNuDBdgrS3CB3Y9dNs4/y284GXjtRLN/JWWNCu9vmFmflmh7GmIpY3uDb9Zna2GN9vZ1r0UvhCF7WmaY4sCp2yLj7+ELFDgGSFZEOt3pLcD7L0tSqLaAB7ud/aCWjahA2ABDzWbKk/whDPT0A1a5E8UzRaAstMZBP8t4KBHZuN85B8+03GRiKTWeA7jBL6XbelhBx1TJDS9G5tsY+C+4vYuq0xgbPjbCid1Y2xcmHo0yfxvZFdXouRtCAhV0chWHGMggvAGKXRzneOkMR4aaz3RuTdzoMtOMuKd0sSxkSW2yC38YEweUuj/
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5534.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(451199021)(86362001)(38070700005)(5660300002)(52536014)(8676002)(8936002)(2906002)(6636002)(38100700002)(316002)(122000001)(4326008)(66556008)(66946007)(64756008)(66446008)(66476007)(76116006)(110136005)(54906003)(41300700001)(33656002)(478600001)(71200400001)(6506007)(9686003)(53546011)(7696005)(55016003)(83380400001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?R1hLj62Is7xhC5qlkj9M7fIBV5VCV0KGNEDz4QJBZQQGeptsOrDsB+5emUj0?=
 =?us-ascii?Q?uG0e7+y3952XgxWM//2qyC2A7jCrH3UkvSrNJu0BNOH9QtIqyZJTGhE+dQRH?=
 =?us-ascii?Q?uiZJo+c9ll8WA/WAkgCU3Ugfz4t5s0gkm1QJJnkeQb5t9Jy9F3HPgI7bpaia?=
 =?us-ascii?Q?RupAUiWSLxrQHnzZW7QbQfH2srBb3CHAOGyhi/dQGu+pgaqQgroapYW5jQGR?=
 =?us-ascii?Q?Ko3JJUB20MmDa5hlEYKFmY1yKkEkS2gjgu+bF+55P/dgAgQPfMYMryAMUsnV?=
 =?us-ascii?Q?bZ2qt/iTRAkAIITWP1DlS+bMufW0CV1tcoEvA5IRGz1kD74l/efCaH0y6KU7?=
 =?us-ascii?Q?yNUbxIGqgNEYJckUvorPUb6+kA2QhZs7MZogmQsJOGlLUo0sHvmwLONY4U5S?=
 =?us-ascii?Q?75baOA658GiOr/N32JKWVS7Oe4RcsTs6h74xrEtFdp3EmM4S4UAQI8QIZX+q?=
 =?us-ascii?Q?Wv91VhhORcwVWczax3/yWNDiUlOFUxYEVTK96l3GJEDr/HvSbudh7zJvX/2F?=
 =?us-ascii?Q?cTapJPaCYCtS5DiLg9rRyGRrXYp23htN631DxKWXNe2z1ZFJclpQunZjwC83?=
 =?us-ascii?Q?72qs0OWSKbkYy5xafzuCvntvdzD3Mr6mKr35beSucK6rwKvpfYwhdwN7game?=
 =?us-ascii?Q?Ctr3Uiud/otnRujFhLw2DALFwLllrr9cD/Y4JVJok69yf+2AzbCN0a2veLrP?=
 =?us-ascii?Q?IgHN+6BLCXbQpUv3dqQwQJlqYoqDg6g39WfLYXLKjdGccF5o3MjMh9tfuv81?=
 =?us-ascii?Q?DowFGE5sjq1eeLxdF3i7zy0vBgxhtq8Ul04z9l1dxf0Lm/8Xf4oofjX1TSCK?=
 =?us-ascii?Q?78XQcQmJEBFYWQOSVaVuffCEXHl17S+dnF4HCBGN7BoxCBCrY0Y+hdxRxG8z?=
 =?us-ascii?Q?P/yk8OWzsLTNKmPPUofBIt+msXhIPnU3n9dFB3H2yJANbHjUYm70wh6le0gM?=
 =?us-ascii?Q?j9UANQA3x1UJ11bOye/pOleenjlzL4gIFJDdpNmdtvKy7gMMEcN5b9Qg6rk2?=
 =?us-ascii?Q?qfSm2FJEKiUexnRxL1Id6a+CEMSoVFoh7FnzhXcYSA0ta8o4j8H9mZy/7I9J?=
 =?us-ascii?Q?jOnUCKl85G4ick1WZdZRBFPwmZAz5aj5SRlqtxEFEBG/WebnxtcOZErdg7+R?=
 =?us-ascii?Q?/xQH+fXpnqU47Rba4PsEWOJTSnGzl8e99fmM+ey2jPLpX8hOOAsocSol6SBH?=
 =?us-ascii?Q?OShNehxqsUYBhPTiQ9qNwISAC4Jh2E371dZh022WJSz2uCr4jhBkVTNatNb6?=
 =?us-ascii?Q?Gsx3Kk2bKQ1eZ8DMT13iR59FtL63h1W73bjH7ngnUWYx/bQvHhfrvFT6Sj6+?=
 =?us-ascii?Q?/UV4pS4aKskzRUVbH0en0df5iBq/CFQTS2pFZPfqpPPHYJkfBHuddz2sjpHi?=
 =?us-ascii?Q?ydJAUN01RCpJvKFZnE2igoirKyQ00MdUbrX1YG5koSWSwQ6gEt7ry/uzjzUX?=
 =?us-ascii?Q?VYWfl9KM/NPj88MK1/9Ah7jqXV8rp1NQyntoRPS5k/6LKdPPoopM+A8toJ4/?=
 =?us-ascii?Q?jyD8LNn5R/KeVp/fRb4gXTmb49iCHsD8PTCgdx+g7xUmr6UlWrnPhzpf//Mv?=
 =?us-ascii?Q?VMNaj2FHtJLRMrS92MSiATaSBV8Wzve4bZdN+pBMnkjm63iyA87Rj4pcW5TU?=
 =?us-ascii?Q?XU2pG5DyaRgqC5o7+NXmDz7agKwOVzDBQdesftWnfJdS?=
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
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5534.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ebc441d-8760-44ef-6dee-08db63799832
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2023 14:56:49.8197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TGdR1KCmT2+kAdULQ3HeUHUo8cR5DTXSDfQSEABEss/irzWq1Wp/rT/qSNStDPFbiC0IRiiatNMVYHImjyGr/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6102
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Sent: Thursday, June 1, 2023 2:19 AM
> To: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; David Thompson <davthompson@nvidia.com>; Asmaa
> Mnebhi <asmaa@nvidia.com>; mkl@pengutronix.de; Liming Sun
> <limings@nvidia.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jiasheng Jiang
> <jiasheng@iscas.ac.cn>
> Subject: [PATCH] mlxbf_gige: Add missing check for platform_get_irq
>=20
> Add the check for the return value of the platform_get_irq and return err=
or if it
> fails.
>=20
> Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> index 694de9513b9f..a38e1c68874f 100644
> --- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> +++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> @@ -427,6 +427,10 @@ static int mlxbf_gige_probe(struct platform_device
> *pdev)
>  	priv->error_irq =3D platform_get_irq(pdev,
> MLXBF_GIGE_ERROR_INTR_IDX);
>  	priv->rx_irq =3D platform_get_irq(pdev,
> MLXBF_GIGE_RECEIVE_PKT_INTR_IDX);
>  	priv->llu_plu_irq =3D platform_get_irq(pdev,
> MLXBF_GIGE_LLU_PLU_INTR_IDX);
> +	if (priv->error_irq < 0 || priv->rx_irq < 0 || priv->llu_plu_irq < 0) {
> +		err =3D -ENODEV;
> +		goto out;
> +	}
>=20

It is preferred to maintain the error code from "platform_get_irq" and retu=
rn
that instead of -ENODEV.  Please review the API for "platform_get_irq" :

/**
 * platform_get_irq - get an IRQ for a device
 * @dev: platform device
 * @num: IRQ number index
 *
 * Gets an IRQ for a platform device and prints an error message if finding=
 the
 * IRQ fails. Device drivers should check the return value for errors so as=
 to
 * not pass a negative integer value to the request_irq() APIs.
 *
 * For example::
 *
 *              int irq =3D platform_get_irq(pdev, 0);
 *              if (irq < 0)
 *                      return irq;
 *
 * Return: non-zero IRQ number on success, negative error number on failure=
.
 */

So, the code could look something like this, for each of 3 IRQs:
=09
	priv->error_irq =3D platform_get_irq(...)
	if (priv->error_irq < 0) {
		err =3D priv->error_irq;
		goto out;
	}

Just a thought.

Thanks,
- Dave

>  	phy_irq =3D acpi_dev_gpio_irq_get_by(ACPI_COMPANION(&pdev->dev),
> "phy-gpios", 0);
>  	if (phy_irq < 0) {
> --
> 2.25.1


