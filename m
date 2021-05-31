Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCB139597F
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 13:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhEaLOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 07:14:20 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30276 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231344AbhEaLOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 07:14:17 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14VB9x5v012713;
        Mon, 31 May 2021 04:12:33 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0a-0016f401.pphosted.com with ESMTP id 38vjqj1see-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 04:12:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a9bscks/T+nKpJpFFS1RqKglkGQGixegIYxOC+q3wIHx3BE4hg5AWbSzat6G1DROosEMuUZlDMeQ6SeaLpUSWcM8zb0vb3+a36Aeo5ctwM/CG3yl3+qmB07a0MR1R3lU47yYmM6aB6RpwqUnNIDJU+yOoJaflYFYBwP+Ac6+N9BFVLNUGsr3jriVHJ/VVuJp+Phvr4g8voh40gYgMf11xxXtGQNYlyp0iSlPl5f9sLujoabGesvp420ya82ywWDzdEIWUAARj94g5gs+5bIOuCXDHKtePkZ/OBqiMVYSmEWFDe3dZeW0FJx+xTrchfzGVw1dR5jIlpZy32NdGPzaVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8EdCwcTzaI2MqR5e4xG0KryKm8eiNxCPDnyCsbLfVU=;
 b=Lo63BZIfcu15IsOSloNOGm67tNe7usVW5/i/z1XNwWWKSSm1fvSA+IFZzEEswbD143Ezq6w07pC9VKZlCRHF3pVfW3TM7pEM/cpx0iyc5npsqZ/vgQrbWdRzZ6lcljrVzRzEy4bVFSCC3JMsaWnu57lFPfgc2/n21z+42ZY1I774KwY77uqBjCp+9TBti0VQCkC+2wd0XMlYtCF8Z9uMNVaL+RVMABmSFNQl8MLJz1zUIBUDIF/gfQ0bWWEFvFzTC0ELwIolfVJaRSrgeM89DQhh9PaAMEr9BxqeeYsJUtgS/uLgz/H7Tx1LYMfRpR6TuME8Zur84A5b7T1W5CiK7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8EdCwcTzaI2MqR5e4xG0KryKm8eiNxCPDnyCsbLfVU=;
 b=QHEbUwymwkrhzaBTH0JsMCbJ2wsV5xSZ2EZYJ+cAjWHNE20nlSX8EOc+YTD0xySjbz9ZpnNXckWmK6h+YeUA5b8xFnULUl6H0M34Xy7gZaUbsM8n1hmQGmWJZWBl0roOL7gAKdjy4LStOl85cjVenAVxEVuYHHYvEpOJE0x4JSw=
Received: from PH0PR18MB4039.namprd18.prod.outlook.com (2603:10b6:510:2d::6)
 by PH0PR18MB4007.namprd18.prod.outlook.com (2603:10b6:510:2c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Mon, 31 May
 2021 11:12:31 +0000
Received: from PH0PR18MB4039.namprd18.prod.outlook.com
 ([fe80::10ad:7f4c:f888:b700]) by PH0PR18MB4039.namprd18.prod.outlook.com
 ([fe80::10ad:7f4c:f888:b700%4]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 11:12:31 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
Subject: RE: [EXT] [PATCH] bnx2x: Remove the repeated declaration
Thread-Topic: [EXT] [PATCH] bnx2x: Remove the repeated declaration
Thread-Index: AQHXVfcVoecU8h9ZXE2cTE85ZfiKnar9QswA
Date:   Mon, 31 May 2021 11:12:31 +0000
Message-ID: <PH0PR18MB40399D3B99EB8CDC0EF2273ED33F9@PH0PR18MB4039.namprd18.prod.outlook.com>
References: <1622449756-2627-1-git-send-email-zhangshaokun@hisilicon.com>
In-Reply-To: <1622449756-2627-1-git-send-email-zhangshaokun@hisilicon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: hisilicon.com; dkim=none (message not signed)
 header.d=none;hisilicon.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [49.37.150.229]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71fa37d9-bef4-4830-2cf8-08d92424fbe9
x-ms-traffictypediagnostic: PH0PR18MB4007:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR18MB4007686009E843DE96AC6ACCD33F9@PH0PR18MB4007.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:862;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ncJP8+HD1InE0QPRBMtSImMgsO6Wx2M5UgPc+rN+L9q9luKjTmXJbrEmU7lUwTFhdnibeWvQOHGBQoX08YgnRiDo4L1KdC1BtNGw7ZqWkGJJvmNnFFmxoKdAGyk8Zev25z6vLX7jZT/1RDBDSE8OuRFKmBgK+uJEnqzlW/ZFRAwhlr8Z1eHL5Aej2+sPFcaj9V/RkJMxcH/FMr8XZjDbNBh3Gt2nw6owfgBQGFMnPeDN+BhdEGRsalgDbJMNV8GngWkUMQLhYkVcUxCJXK7PEIpFjH3PONnHTqGuK8TzA0oZdCmy5TBd/fif4DMi6KCwJ7VdBxvHJtkwmRvOomVxz1mhJSn7JqsXCckwqG3oDhTUgGe69TUuugxw+HosecIYhUyOiy7ou81znuWhMK+5DiyY8yFLKPjd+78LCOk6Z1CyAFhM9H8XeDzrFdjV+rzQ3+sLg9/7Q6GBBOB40AVXYl1lWuYVwGO8ly22PfhIgIOlqEgm3PpVBx7ZDpXp3wczIAuLUz1Wwyi314fHssEwXFHGyWMvuLmEJePLsxrj0dgRvQcgVp1ips4XbljRgJMe98z5k55R7RcLs5gD7rfY49pf8VZR999S3cAol10lOQ4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4039.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(76116006)(53546011)(52536014)(8936002)(122000001)(8676002)(26005)(66476007)(6506007)(66556008)(64756008)(316002)(107886003)(66446008)(66946007)(38100700002)(54906003)(9686003)(478600001)(110136005)(5660300002)(86362001)(55016002)(2906002)(4326008)(71200400001)(186003)(7696005)(33656002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?BKWpF3eIYkew8VQ5NWtXdcyJ2TgIQTQbiCDG+eDwl/2CJqfnl3DFTIhsSWsW?=
 =?us-ascii?Q?2i1xduUYVhv0shEiUrXNXYOP/FuTYwrxNgrBYm5mj1N0UxBV290X/sHDX9ut?=
 =?us-ascii?Q?csgWaNvGEgKhSZF7paN2gSFi1kGPbGE9yL94KVhZUk89Lmkmae9edpUhEnBS?=
 =?us-ascii?Q?MeMdOE8nXuG24dl9VQ9LQvy/Ro6hcSV56JH2MHXzOuyhhLVKdVggFtDYSWPK?=
 =?us-ascii?Q?7urQtoJqJXlreFUKJulelUzM9IFid7SW1jN4GHXMAdjpNveiAyXYN72Y6eVd?=
 =?us-ascii?Q?DS5eRbMgOly4iNyWOfK5JATzGWSviNqWZS65JVgWzE38avVF3br/8BnKVpF9?=
 =?us-ascii?Q?YEGMqWC08QQAK+beirs9SX984ICRlfAvlX87mcbgea/q90F2kicvPyHCxmFN?=
 =?us-ascii?Q?qFj9/09InWep74O7nztKqHt5J6W9WgNOhWlwGK5M824/KziNBLU5aNgsLRRK?=
 =?us-ascii?Q?4CeMs6pZsj56LVQWL8XU5D79pSoGYo041w573XxUffZDhkjIclUxktAsvJap?=
 =?us-ascii?Q?zFY/yIhSBIgegbYwQ9w5GZS7oQf0o03w62aynHGH+S04QPHbGuOQO3Bn2yRX?=
 =?us-ascii?Q?QuBZHTVm5r5L0JmmNkeduh9SmH4jU7wi0ClZ4odCkgVeBhwunDlSz/348GX1?=
 =?us-ascii?Q?LnxCWpSL1wksZVnCcYP+V0s1xeVqMMqVaZBA8QvUF9oI8MoHZy8yEp4sWzM7?=
 =?us-ascii?Q?ZX2qGfXeHkqQDGvwxjLY/LDV7L3z34JLjDz60xmlKEFkN6REJ6P8xL+Bw6GQ?=
 =?us-ascii?Q?3mAtp8hVY6pOCCpHUWDKbrXd/vVWIuItMbSUCEkPITbVEr6RHBxT1wM0lDBu?=
 =?us-ascii?Q?Ob6ln5XSTfSn3d8J+YwkDNlMvBxWJLZZTEvHqxPO9NrR8IBviM/Q78gf0LDp?=
 =?us-ascii?Q?bc1IdZwAlFxcGLF2rpBDI4KEnNvO2KbidKqfGBTtwPutwgWPFd/AXlkll+qo?=
 =?us-ascii?Q?b5qLBN+KDrylapJ+5oxpF9jV/c3GDJMVDsXPskmKWs1wtAt86LKfUvaCZ2Sm?=
 =?us-ascii?Q?wMGwFcPZP4t7yAxuLyYvpUfDJBJVxO8uYid5kWmKAluSINp4tuxKek/KBAal?=
 =?us-ascii?Q?VZZTtGHAB4NTU39IQ2JNrrGJDEJC331ghw9kfxmxDNV8fLcGKHDE5QZOWbtj?=
 =?us-ascii?Q?lpvjQ+lC0MRu/RvmNiw+IsylfNRBEEgZk7Z+URM+ujBBtS97nh5Y5D0bSa+9?=
 =?us-ascii?Q?2u0sraVXNLLuBDHnbYvsXfoWZGD5cp2BuuC7e7I/jWHFycQFsVcS9Q1mJDiU?=
 =?us-ascii?Q?DohXfqzMvT2hL9zQkTlDzjXGdomNAC7Vpa3cLeku1bEvq1sJKgCOrXuVIhET?=
 =?us-ascii?Q?KlgtKbawY1aftewrpKAbrP16?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4039.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71fa37d9-bef4-4830-2cf8-08d92424fbe9
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2021 11:12:31.2106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7JF5Csi0/GXus5LwSpDj4gsfVznbqm1Vdn51GgNAwfqQIlyWDnXIfBhgAEX0+jXCpOTHfJCTrjWHkfBqf4zk3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4007
X-Proofpoint-GUID: g87gAQTyvbek34WXSo4lUdbCvaeg3ZWz
X-Proofpoint-ORIG-GUID: g87gAQTyvbek34WXSo4lUdbCvaeg3ZWz
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_08:2021-05-31,2021-05-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Shaokun Zhang <zhangshaokun@hisilicon.com>
> Sent: Monday, May 31, 2021 1:59 PM
> To: netdev@vger.kernel.org
> Cc: Shaokun Zhang <zhangshaokun@hisilicon.com>; Ariel Elior
> <aelior@marvell.com>; Sudarsana Reddy Kalluru <skalluru@marvell.com>;
> GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
> Subject: [EXT] [PATCH] bnx2x: Remove the repeated declaration
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Function 'bnx2x_vfpf_release' is declared twice, so remove the repeated
> declaration.
>=20
> Cc: Ariel Elior <aelior@marvell.com>
> Cc: Sudarsana Kalluru <skalluru@marvell.com>
> Cc: GR-everest-linux-l2@marvell.com
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
> index 3a716c015415..966d5722c5e2 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
> @@ -504,7 +504,6 @@ enum sample_bulletin_result
> bnx2x_sample_bulletin(struct bnx2x *bp);
>  /* VF side vfpf channel functions */
>  int bnx2x_vfpf_acquire(struct bnx2x *bp, u8 tx_count, u8 rx_count);  int
> bnx2x_vfpf_release(struct bnx2x *bp); -int bnx2x_vfpf_release(struct bnx2=
x
> *bp);  int bnx2x_vfpf_init(struct bnx2x *bp);  void bnx2x_vfpf_close_vf(s=
truct
> bnx2x *bp);  int bnx2x_vfpf_setup_q(struct bnx2x *bp, struct bnx2x_fastpa=
th
> *fp,
> --
> 2.7.4

Acked-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
