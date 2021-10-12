Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3ECE429FA8
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 10:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbhJLIX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 04:23:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18838 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234484AbhJLIX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 04:23:28 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C4UVNH023989;
        Tue, 12 Oct 2021 01:21:24 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bn3d58xtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 01:21:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4ZF/p+0Lwp/Rrxpc4Aa9CzVwq8O1DWqiJMd14Xer9IDZ5Lb8PkNFjzcPS5+oOXyhgx9gSKSGDbWQdoMMqTac7pN766Z+MJExPAcUdnXkRJzOZ/2i6qwqTO7hzPPuZslxMhSPur1xgiwE/BSAg4OYJiVlonAvDMs4FB0x4ps9E0asmF9EkpA58wh4Uitw9pup7ZrtVVtUbnVz69K/78h5akTrgbmshcL7ojJ3191O87UuVnpX1W/Vqu/uOeLjnKjB0RVjdjOuU01QQpIfdIcynEdsx7GkQHa82Hfb6ToaYMxVSaApHS4TN6xL9T3lwX8LZCYILgkIq6RgZr4mjPVNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GkwZddSrb0olsRwQaXYw7p/DATh/hPe2m2TnjAfZ/G0=;
 b=l4/v2qZMhPKaSJS4VFu6phY8qLeQTQdCbsgQ2mhwVgTQXEmDAnq5Jif/gWSJNR/FOqhNXIr1XxzU4HR0y7swkrk+VnkEEX21JnRAjteTFuP5e/pov5LuskcdASwauNTBnQ5R/pw1bp2PoLVrZrxr5z6rVcJF7YzlCZFMITftvkDLsWeE0wryltiWSSYMftfAJ/yHRoDdXL4nq2K+Qtj2fq8qhJP14VXQ6lfOz+DLTzFCdXxI8QkGntc/7D/KApGiPBC2Fv7lqne9FUczQVtrbhQrNG9zGoLmydP6o5Kgt6ZgF4D04hM98E8zIwnFE59yfhs0CnPw2mDPToAtIY833A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkwZddSrb0olsRwQaXYw7p/DATh/hPe2m2TnjAfZ/G0=;
 b=WBVPNeE0/r3u1kZUqPvlWinYhyCdoB0OSIn99Qy0Ao/2qD2VkkbcNcRsnSzL4RODSLcYk+Inrwo1QCp4kYJWphwOfB22onKBU6uVMdkeGzsuJHNiaFqBUmraku2h0RCa7iH7KJNmtPlc2Sg0BbevB+rAI/I3Nd8HWio54Ph20q8=
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13)
 by BYAPR18MB2696.namprd18.prod.outlook.com (2603:10b6:a03:10b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 08:21:21 +0000
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::fddb:40f4:506d:f608]) by SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::fddb:40f4:506d:f608%8]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 08:21:21 +0000
From:   Shai Malin <smalin@marvell.com>
To:     =?iso-8859-7?Q?J=E5an_Sacren?= <sakiwit@gmail.com>
CC:     GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>
Subject: RE: [PATCH net-next] net: qed_debug: fix check of false (grc_param <
 0) expression
Thread-Topic: [PATCH net-next] net: qed_debug: fix check of false (grc_param <
 0) expression
Thread-Index: Ade/Qf3iinx7ji0tRHii4SgfTwX1xQ==
Date:   Tue, 12 Oct 2021 08:21:21 +0000
Message-ID: <SJ0PR18MB38820AF4EDE62387B8925168CCB69@SJ0PR18MB3882.namprd18.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ef921f4f-da1b-409f-a5e4-08d98d594614
x-ms-traffictypediagnostic: BYAPR18MB2696:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2696609E243158C3934FD50FCCB69@BYAPR18MB2696.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:170;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T7FIqSAnEUJ66pi10RuPEwtHDzOxMLMItqe6hZ+Y84YDQfFqqPgtQHYSmEoK3ISUzn9+hPZRfgZt09hpBszBUnPXGF8R/uVrIX5xN39Y0E7CiXHjc292MRIyq2Tx8zsX6u8EJ713GV2XEYzBMHN4PO3Bg2yBud6oMu1XLFCcDtb2PVYZYaz3OZyP7hWIlhMz/TdEVAlmSh7TCqfhxyzL3SIe4y9JKIqCQR1r7qLqdKNiSIkNlVKJ0l1qb7aakEAAB9WbVYEcsgbFtpBxhQ5rS09JxfyI7Zyf+V/cE3rmt+X1Z0WAvlQswoAlvXugQrBSDLqHPVQ5VecBpUECK95AlbNS2bx2/6oT+VkrDiyDx+jigrpmXsfogIEPkvw6ES7q0811XgdTFMUFW96WrpU1ihSvw9rfOAyIEkLNxdw1FjI3Fm47BjJTj3TnaX+Xkq802AQgHKIWkNoROPLN9Zq0vYdwCRfOrwdvDz/0UBp5xIc6jYeJt3Fj5AIdfiDlXPZHhY1NYk+3zOpWppPZNrEprTKbyd6uUe18SqHc1F3j682JQHnRnsfvr/krTn0lFxhn9rFXL54daxhvhxMPataqIC8La3/hpkN0KSvWUCDi53v3Jh3TpSNk+MQniL+hM5jznRL/kDK0a4WO6vsimNZjzcUB8X4Up7RTMLfhKGhnrnGUVwKV+YYHWij/imqKf595fvL16fcOBc4yOu2hMAzfoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3882.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(33656002)(66574015)(83380400001)(7696005)(6506007)(8936002)(86362001)(9686003)(5660300002)(316002)(53546011)(122000001)(54906003)(2906002)(186003)(55016002)(71200400001)(8676002)(66946007)(508600001)(66446008)(38100700002)(66556008)(4326008)(64756008)(76116006)(6916009)(66476007)(38070700005)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-7?Q?LzCjlDkV/+JwmIEhUzJnZ1tJwsg0ia8hnK5dmgw5wrvv5zh2XeweadsnxX?=
 =?iso-8859-7?Q?c5s+VfUW2ogOoc/Teuk9f4nZ8vzO6IDOZpFM8g5D5PdIc+RA4ul3lWOuWN?=
 =?iso-8859-7?Q?cytAkOdGgwJIGBFD573uGZ6Dj1p4F09bq0gGgiwCKkqvbpG9YgiSmbM8Nz?=
 =?iso-8859-7?Q?tizDvF4TFE4CMNoQA30ZuEpZds6e17ZBlMHspyfD/b35dM4v2Vuf9U37ij?=
 =?iso-8859-7?Q?1W9hNJUg5rQroYUxAvEqSp8Ms0qX86Hl/oPfsIxMUwA+zxWPxCa6e/g2d4?=
 =?iso-8859-7?Q?r1xCPh7bW81kZPwLn21OUgaFeR9RwI4s4S3AY8Z8zYEUO2w0Es0+kT/5d6?=
 =?iso-8859-7?Q?fEBHTSYBYCdStlZEiTGKE9mELe8uSdgI+kVSsDOSL026l6gzKRm+MZxLPU?=
 =?iso-8859-7?Q?vwYO9Zj8A6ZC3W4fXm2ahShTthc0+MG7rNdYcZcG0EBI210/FCW1Z7B5Ef?=
 =?iso-8859-7?Q?7oT7T7agtmianNkmR3Ymk5NRZus687ithGT+0fRdDFDcqt/31VE51u9rEB?=
 =?iso-8859-7?Q?9FY7I7UAjcVJ8S7OG2Okzn266BW6oz6e0FvGDexaB9m85v+CGVJPV/9iXf?=
 =?iso-8859-7?Q?e/c21JFaFrRFxK3RFHIW/Bc/FzOD75aG0wKTitTrT9VrJ3emoF8wR0a9RA?=
 =?iso-8859-7?Q?q5MMcE9YVKQFQpRzKqcZl9A4iaD1weEwnaw1UTWrBaaQWOFBHJsIsAgcxy?=
 =?iso-8859-7?Q?2Odhbp/DKnuZFzIszwnekvZ0EO2J5OyADjjsIXKe9y8n65ZPDmbC19lh53?=
 =?iso-8859-7?Q?cdkxBRu0DULix5ZlWfN7+V87nkCdJ96NhzVyQIuoKC0np+3ISLi/p6TEqc?=
 =?iso-8859-7?Q?wBDzG5EngGADluOlwu4zQZthbRlrFAzMSteU4yOaCF9nwU30IBfXgxDO+Z?=
 =?iso-8859-7?Q?Kd/ITj3hUtUNM//x3o06OwCwgDjqbeOxtgG4P6KTCefOUjZYw0Mn0l/73J?=
 =?iso-8859-7?Q?/EiQBHXrL8p9gKdHU2owXr9AZF8kgrgqTBexDJB+RyqtdbmjQ+W07xaa+K?=
 =?iso-8859-7?Q?BPmicmTjPOa0zx6WoEv3/Ri+eeb3zc7j0+VCXCCnsGo6mNdTCG2GLMpnA4?=
 =?iso-8859-7?Q?qBulZS9IU/5vG2H20d+Py+1LKrbMHHhThCbQKMoq1nLPyYWpku87ByyQAP?=
 =?iso-8859-7?Q?6FQ6JWX7K49R8v7c+9MzW1OLUH1Z/ubvp8/sWXiNKgeIf5T3Fznp87qpFG?=
 =?iso-8859-7?Q?x1P1Bg15KNCQkNESaxU9RIGgsLdh4Ibq7YMYvvd7OsjrpAT89xiAlb3Y+h?=
 =?iso-8859-7?Q?7DmSIGu/EcGi1J5EFMMdLpxUcTsqWcCTH+8d0O+ZcInGxCVXL0gJ0x3NT2?=
 =?iso-8859-7?Q?g6qMw9xMpyOfuwEnfwe2HNhdEX6ockHBr4hSbbWgFKnSJueUVp5+Tf0TNq?=
 =?iso-8859-7?Q?xVgJMaXMQfHMOJ5vXXNaoNAdB0g3ecRsc6vEEN+t4TAnVH+Vu9WSc=3D?=
Content-Type: text/plain; charset="iso-8859-7"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3882.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef921f4f-da1b-409f-a5e4-08d98d594614
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 08:21:21.5456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ACosPrNq0bLDZCaMJIrv6/XrvS6iQgLp+kG/dfcMZa5YJ3fG0g/CUXQXOmnKlcGXzIozPrHKYdcvmjitUzC4Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2696
X-Proofpoint-ORIG-GUID: qpnE3S0ATdvavI_zzgvgEDWjOpMfqyJr
X-Proofpoint-GUID: qpnE3S0ATdvavI_zzgvgEDWjOpMfqyJr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_02,2021-10-11_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 at 10:47 AM  J=E5an Sacren wrote:
> The type of enum dbg_grc_params has the enumerator list starting from 0.
> When grc_param is declared by enum dbg_grc_params, (grc_param < 0) is
> always false.  We should remove the check of this expression.
>=20
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_debug.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c
> b/drivers/net/ethernet/qlogic/qed/qed_debug.c
> index f6198b9a1b02..e3edca187ddf 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
> @@ -5256,7 +5256,7 @@ enum dbg_status qed_dbg_grc_config(struct
> qed_hwfn *p_hwfn,
>  	 */
>  	qed_dbg_grc_init_params(p_hwfn);
>=20
> -	if (grc_param >=3D MAX_DBG_GRC_PARAMS || grc_param < 0)
> +	if (grc_param >=3D MAX_DBG_GRC_PARAMS)
>  		return DBG_STATUS_INVALID_ARGS;
>  	if (val < s_grc_param_defs[grc_param].min ||
>  	    val > s_grc_param_defs[grc_param].max)

Thanks.

Acked-by: Shai Malin <smalin@marvell.com>
