Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE02482DEB
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 05:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiACE72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 23:59:28 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63798 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229677AbiACE71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 23:59:27 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 202MqVlH009945;
        Sun, 2 Jan 2022 20:58:47 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3daqbrjqb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 02 Jan 2022 20:58:47 -0800
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2034wkQF020703;
        Sun, 2 Jan 2022 20:58:46 -0800
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3daqbrjqaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 02 Jan 2022 20:58:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Krlm7ycpaDw2QXIbrlYq2+pJ+QTQefP49mYsr6qldls8dn7GXLzOsBVhKaO6WaEY99T2yiL2khBYipzrvtI/juOFsMjfAc6qqyv1gmkvLtsFGkM3v8wLymWQOKz0sZixe1eC++yEzQDEZyQrNUMHTIaYoSf9sknxkioQTSuhv10kRuKvKDXZAGpEjg51Z3yf/5zgfo4bUCU4/4z4+Ce8zQV+21pi6xSOqwt55budeWR3SiKQZVjv3m1xN0DOAiFK5Y+chWyoZrCjePSGRqZpP/GxOTLvvfrBDfQhfGyLAmONJM+0ake4Wal+lJxHf4kS+hBMcN16i5mdBvjyS+OU+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bu1uIiO5ckzWvWLC2ZQuy8PeU619/3WkHEb4fZSK+8c=;
 b=edMdV2XjVAJ3vQbLJu9ogHPtVfcgHT++rssTFOdypZv6c0Mh+1a3WmEfzoy6mu4q7lS0QG6UfOVvS4S9JQmSeDgtfxe4D1HD+W6pDQKJ2CAZfhzh0LXkqzZu3CyXiZiECoBNzMMeTRi7IlmvxYRshVIcK1dIJO+dFxsZqt29zQ/ZpZXeAvtDvTEVwdgFEZ5K/i8c9Jn33RqMSUkl2zRNTSTypjIWkv3zv5LEZrpL5piN7df9qcrWnrR9IAgKnVCZWmC0OpUvMMZxFIqv83ztdKemLbjCitWhGkt4NbDURe1kKZIy7/cGqaNw22naRilWRb2pHrzQl/5fJA0Y7Thghw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bu1uIiO5ckzWvWLC2ZQuy8PeU619/3WkHEb4fZSK+8c=;
 b=mpLY8zZJXY1iSg1PHUO83gNHLTbp4OToY/t09c3qm1QrcxMf35hEuCy9c8CQ8wRmZO9igMil+nxjj8BFYavONDAJjD2Wm+yLSWJKWkvRNY5uGoBgzqNCtW0IQZgxfayKizPWohUOGyZXYEJE8272ta/HZObL4Eun429laUKoIAQ=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM6PR18MB3036.namprd18.prod.outlook.com (2603:10b6:5:18d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Mon, 3 Jan
 2022 04:58:42 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::bdc7:54c4:7093:290c]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::bdc7:54c4:7093:290c%5]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 04:58:41 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH] scsi: qedf: potential dereference of null pointer
Thread-Topic: [EXT] [PATCH] scsi: qedf: potential dereference of null pointer
Thread-Index: AQHX8mXGRWO7SF21CECbm2a/GitlN6xQ15PQ
Date:   Mon, 3 Jan 2022 04:58:41 +0000
Message-ID: <DM6PR18MB30344528373170A95E67B50CD2499@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20211216101449.375953-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20211216101449.375953-1-jiasheng@iscas.ac.cn>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d4b14d3-a1f2-49e5-d742-08d9ce75b69d
x-ms-traffictypediagnostic: DM6PR18MB3036:EE_
x-microsoft-antispam-prvs: <DM6PR18MB3036C6E3D179D3269EC8488CD2499@DM6PR18MB3036.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T3rSUnc9R3qQXlmrkJp5+c5NsTaDfMuEzCmCJw0P1awGJjGtGpouK4M6UFSuU9eIvWIBtEEVBWZec620pu5tL5gPUDUCkubE0zh+ZcVfcn8jBcW051Q3o+5dyPiQzEsU4Ho2ffhAkT/anICDyarTNkEPOObQek6CDc0dcQ0tQYiStvwNkIy+oGo1ZvI9/kx1hGilKENXDz0/yTNA5EW33WtSTkx/XYjqiWTvSHCPzu2TFMZ3GFE5WbKB1VaYFv9djQyoKNYqVtEjEWDnkYSYA3q2ePnT1TpGnOOOtHWpdm4xVyvQGI2CoTRXbFDhE8j/Y8m+XqfAFGMhGbJZ41KjBBPnHIkORy9zFrAQv0KPCkud+5TC9ffeLMbu/wmbaDg3GCvgX6nye2VrzbNhKgbKPaYtaIQAFb+vdwSvnApCkzJd93sZaxp/gV+MI1iP0zYnLxQ6aF5l5oMBJrrC2SfZrtAxrp6qGSL5IqdAe+2UXN6VADKFtyu6e3eOp2vURtQre0Wy4SEsXcmJasam9kH2D7UXmF5jRQVRUOi7pQ6aT/xvCEed0JwYRMRSabPYq944pm+A7rjLL3oVsbwuQIXOgd3uxjssr+xdHr1Pbu7Hr+OT8ZHuwAMFmjyV9CP4nQgZvxZ76OZ30bAbaIjGgbXFriNDBCI8+Z0eLMvW6BZpjVDvyb37sFQq1bw6oFm4yXt5I0LKMsGqO2BWdI9EjbklKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(26005)(66476007)(64756008)(8676002)(316002)(66556008)(76116006)(66446008)(55236004)(508600001)(186003)(5660300002)(52536014)(110136005)(66946007)(54906003)(53546011)(6506007)(38100700002)(2906002)(7696005)(71200400001)(122000001)(33656002)(9686003)(86362001)(4326008)(38070700005)(55016003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?V4M6Zo9l8ax/lRKm1hHI9XYZT0fBaWmG74ZV/jB6orrCzJ//F5cYat9BVSEY?=
 =?us-ascii?Q?BOZFPOPygDzZdymQOVT/MY8RD+xsuVVBmn6vIlrVnCB0/zgpHkv3XvEd8d0U?=
 =?us-ascii?Q?jdr6ktN+/5sYpFwtGczuMwjYajSLuvNHzR30F3K512kaMYkuYBIM+v7NuUyk?=
 =?us-ascii?Q?olr1svGYyJOBZj6hw2/Lf5xNzlO3kqn6FEYnc+1fpMh2QsTsKxp2ZwVbARv9?=
 =?us-ascii?Q?5GVYfLJlQlTLd1SrMNnXn4tB+BGbboHPYwm02EBtUV9IdQN2alRJOFwjmyg2?=
 =?us-ascii?Q?wTSBylsSzBejBRpDBH9HzXnz0eVKIQ6FaUeNEaYZi2ZtlVhKBEfgVUz4SkvT?=
 =?us-ascii?Q?Ogou90xyL0Ce73lCX3ENr1HNqxj8XdVjt9SRZt8bSLHA9ycfFytFwl/si2zg?=
 =?us-ascii?Q?rvn4fUqLp/OmHMhcBcNYxD+BLdcH7D4PI9demfVNzWAJmV4zVMKokgaek4GF?=
 =?us-ascii?Q?Q9kL11OsQvykLcfC45lbT/7BzFblWbsDeFh0NLGzAxzGvrOd2527zPfTVyx8?=
 =?us-ascii?Q?59MqEF6ieZtWcrTezDQVyxe1GMhqEoMcBUWPqhcQSV8ffMDhcP/u6P1DLXNC?=
 =?us-ascii?Q?tmgWTrSY6dCUV8viAQEjqrxxYgEcTSmyB803PaT18HFxGa4a1fzJlVVpezbb?=
 =?us-ascii?Q?fN6I0VUgkT8NGRYDrCj7SGWhUiMHs9HKd+V3OoSzzyPGX2QsV/E48aM6ZhFB?=
 =?us-ascii?Q?OLTXVACtGZwJh8N/wp2O8qXkDdB0h7PTR6OmpZkVuPwdZKPRkGq9XEWK61iD?=
 =?us-ascii?Q?I+FUgvrBrnRx2o7+G/eJC+k39rcbM3JzxXJTZB+c0WYzd9r6YvBa9s8ijT6C?=
 =?us-ascii?Q?heTiFzRTjVJSaD/sxHyG6PgVt0hBOzRhHBOAXzavr4RGLHgH53fea094+1Ge?=
 =?us-ascii?Q?OAi79eYE/51EE+qZXWQZxXFRkSw7doHzcUQRrSclsmEgnGsC/pSnigCzAbPT?=
 =?us-ascii?Q?hS1RcUNTQi3he0SeNErR9v+rn0OQKQNm/tlemFXt1KODswoEAA+eAEpekOzB?=
 =?us-ascii?Q?716s2a14mKeQpI7VG3IuEInSO/nvUpW5m8Tpq36xoPSm2JEkf6lw37vbR1ff?=
 =?us-ascii?Q?YXTFy937bXZ0CiyJyw9DAZu8zTk4lfma1yPsWJlMmfQLLo5WP80MsTmp3kV2?=
 =?us-ascii?Q?VQYiDmBWG/R7bin8xV1UxXPz6tTNhv+D57mtAQkExWoe10gVhC0GdDDgH3iG?=
 =?us-ascii?Q?ZFjHwmfQiogtBSeNx/MG53dYjehvYvpD4jPggdGO7L8aY3J2Of/Wle6LWomw?=
 =?us-ascii?Q?+czB2bugNHU42ZIk8kCgruswMNS9qzcxEyEm6gnxoP1VPD8Jct+N4t7TMwFa?=
 =?us-ascii?Q?F6l/M5H69yZwmu7ZsC8OEim1k82D1efoQhzKmXYdGyaa2dZW5g/C4TqoFriP?=
 =?us-ascii?Q?3nwiCcXKYk06rohEwcpzSuvUvm2C6nMbf5M79CyjkzXs1u8p7OiTCGblgc2P?=
 =?us-ascii?Q?Y1iYEHB+TPicFlSKMO7u+Tbf/qMf7gjgSxR8bxT5RFz4Mny5vpFRBmvh9aQ/?=
 =?us-ascii?Q?FfWmZ3QpflFg6j2vuQ3Vs+mh8H/l5bTYbtQunRegqRxwfCPKhmPvEwnaaIur?=
 =?us-ascii?Q?oqdQg09cXOF2KP6xP8Ae/bnZTG1QAx+aImi7De9dJbO42vljRpP1llzzXwZw?=
 =?us-ascii?Q?VAZhBq+HhUXyFIeuz4bFMBY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d4b14d3-a1f2-49e5-d742-08d9ce75b69d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 04:58:41.8991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wg/SD1iUqGLF7SNou4Z4eYjw4zBnd1b+GgITc9gT6k2puJec+ESJEsigjjhE0Z5r5n/12Sycw6Ghx68hu9wZ+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3036
X-Proofpoint-GUID: kqnictLs6-e-M-X4IbVOYhc60RwhowMR
X-Proofpoint-ORIG-GUID: hRF2YRBtNKQlWR-vqdMjWC-rVmnk9eNW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-03_01,2022-01-01_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiasheng Jiang,

> -----Original Message-----
> From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Sent: Thursday, December 16, 2021 3:45 PM
> To: Saurav Kashyap <skashyap@marvell.com>; Javed Hasan
> <jhasan@marvell.com>; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>; jejb@linux.ibm.com; martin.petersen@oracle.com;
> linux@armlinux.org.uk
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org; Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Subject: [EXT] [PATCH] scsi: qedf: potential dereference of null pointer
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> The return value of dma_alloc_coherent() needs to be checked.
> To avoid use of null pointer in case of the failure of alloc.
>=20
> Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver
> framework.")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  drivers/scsi/qedf/qedf_main.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.=
c
> index b92570a7c309..309e205a8e70 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -1415,6 +1415,8 @@ static void qedf_upload_connection(struct qedf_ctx
> *qedf,
>  	 */
>  	term_params =3D dma_alloc_coherent(&qedf->pdev->dev,
> QEDF_TERM_BUFF_SIZE,
>  		&term_params_dma, GFP_KERNEL);
> +	if (!term_params)
> +		return;

<SK> Adding message about failure before returning will help in debugging.

Thanks,
~Saurav
>=20
>  	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_CONN, "Uploading
> connection "
>  		   "port_id=3D%06x.\n", fcport->rdata->ids.port_id);
> --
> 2.25.1

