Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A13483B36
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 05:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbiADEF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 23:05:56 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12668 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230044AbiADEF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 23:05:56 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 203HmQRs029309;
        Mon, 3 Jan 2022 20:05:19 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dbw5wd5s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 20:05:18 -0800
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2043rwtm014985;
        Mon, 3 Jan 2022 20:05:18 -0800
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dbw5wd5s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 20:05:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m3JimW+hTRqUbDYBhS6JVKH14PpW9XSHPGGWKQP1E+mjtVRdnlICNzl4yNpfBRWUS9pYK4sk34cEpl1ubFK/AlQq98EEctXzGcFRoOzaU4z4hYz22jp0xFviCJOwXn3gZFUviypiGtY9fLGTNUTcf0MUbAjpL0JMQYniwfdeynqszUH/BW5J5Nhsf92C4B4PVK702+sPsgpaLsw1RqTFQqSssKR05RhFM0z5svMc4gCMrnmVXgiT3N+lycqMV0viL7Z5mjbado787lgcenQ4hb/AS2yTabQfIjrVN3HKfGCamtcgPSNDzPW2NAcRCFbDQ7a7RVBiZ21UvCDZ/nHa+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lrg/lUlIZNChuYlrtyIwvK4+Zg8xvPlPTSSboOSNqA4=;
 b=Hderuieh4/TYotvp2cCQsvxWWruwZddoirCAM0Jxsoy/YXHjSk3bb7TpECcXAyRReuqhT/2kpUtaBNFCMVrNiMu/RDR+hh2cixeTmQ+sZ8cBsQuxRfl7wYja5KRyF6V92azasWk0I5hfTE2eWlXRIbGj0JXDHQt6p1HfZv2YQeV8Tu1V1C1tbxG1L5EUZC780qpffEf2jnZQBkP6o08NPIFkh8uTv9Xiw9/jj+AQiDcL7Q+tsmxCO4LZR58gQ0LJumrYnTGMUsxtDDpYVRqmHTANbusIAwAIsDQFf/QT4hEruDY7cspnU1qk44Q+6haqgU9yf1vetPrmCaczGVciKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lrg/lUlIZNChuYlrtyIwvK4+Zg8xvPlPTSSboOSNqA4=;
 b=j8luWPa71qcUKku+57uW5+ulVYZrzaWz7C0XSS4e5igiG71j2cHUHmPeZMgjG3wEQz7nAzfAlN0JQTz5/Dcaeo0lBWYPKSSj2i1t1oT/IQth4ROItChbUBqjnK77Y8GySM1300vqu02uuv6C6Xxi/1iAZEVDvmx59+7+GfgeMzc=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM6PR18MB3258.namprd18.prod.outlook.com (2603:10b6:5:1cd::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Tue, 4 Jan
 2022 04:05:15 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::bdc7:54c4:7093:290c]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::bdc7:54c4:7093:290c%5]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 04:05:15 +0000
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
Thread-Index: AQHX8mXGRWO7SF21CECbm2a/GitlN6xSW43w
Date:   Tue, 4 Jan 2022 04:05:15 +0000
Message-ID: <DM6PR18MB3034EC46365E384336A44E53D24A9@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20211216101449.375953-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20211216101449.375953-1-jiasheng@iscas.ac.cn>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98d75292-15b8-4b6c-8cd0-08d9cf3769c1
x-ms-traffictypediagnostic: DM6PR18MB3258:EE_
x-microsoft-antispam-prvs: <DM6PR18MB32585E5206B2851CA223B9D9D24A9@DM6PR18MB3258.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K7NAK1QU2/QXP3FgzwqVV5PecYIy7fv8wM3A8/r01iH0Er6wjOnjc5q2aiKsmXdiR/fRbbJECqjJyeLCtSL1tFa+Kav6Ukl6z5tPXVt+eq2mQqYseCZcB7oApiier8aVuO9G+5Wjn2p/DvnXo3CdehuReR3PJ/9S7aSdPp5yxj5nNTuKEac9GbxnkcYwwhwe7mFzZJls/aneCSZXEKfppsWJDSAZuV5PaOVOjI3abRYlWftypaoLg34Uz+GFpZk1ylJOys6FnFt76gGq2i7UIR9fKyAoHR0MfG+pdrLk3p54JUU8QBbn68MsZ0FDDGVnaqv1GNZFBcGFLSo/peq0mH2gM1fxPOUU7tjMGfByr7yYFjEb22B/HGH06oqTo7/Zc9V9knpEYIavlICiHv9Mv1Oe1JPyF+5elfq6RcB91u/hApVv01A3Mmi4j8W4o8Yb5FI0fZCsLNZ4OJAr2mzQU5eSMBudQndH08W+5NtfMS+68RBCuVg4RatRCNHQKOP8kZtBL5bGrhvy+NR6Yv2/iribSIAb4xYwj4Vn9Pwz9gHzdjWy1PbGclF7jXyVbvqqoErxR33EvFrAnKngbjsY+/eYkOa5Fkf3qK2Fs/h6J4PolxLk6NX1bj1vEMAz1uH6yZsA4sbectrN2q1AHLwQnbIE7F2xWo2OxGhDdErSKOZ0g5X1naaet+zFId8CG+vkTnrOSAlj2D/MJCsoL2MReA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(55236004)(8676002)(5660300002)(53546011)(8936002)(33656002)(66446008)(86362001)(508600001)(38070700005)(110136005)(9686003)(2906002)(54906003)(64756008)(122000001)(83380400001)(7696005)(38100700002)(66946007)(186003)(66556008)(55016003)(71200400001)(66476007)(76116006)(4326008)(316002)(52536014)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+fYHLEZ4QWT/Btjh5+5AhUJ3laPk0GF1tDFmtnUDNhy5KEOHN/RvPZFxdmch?=
 =?us-ascii?Q?TWMJ5aIJCwKz8LXeRaRh8fOn5BwDx0n9izuZZ09PKo5yYubosnqCL12tVB73?=
 =?us-ascii?Q?5186Dlb/PA9ob8ntNYqokkoi54GXzRqRu2tTVF6BazRtyDTaDG4IHcVGP06+?=
 =?us-ascii?Q?Eu0t+0yrsjhzFXfWbQqlAFEgLilPORA7D8AAWLc9i7aYExRKjGRAYcxpPaWM?=
 =?us-ascii?Q?oNEfL7+ghKgZCtfhmjyk/s5Ki2GVENsYZ2vWxMNj1Z7GcYY7wP02XLTia9lg?=
 =?us-ascii?Q?2tNcZXg2dcqOAkiGPRii6KGl1Yha83G00jseR/i3r7feXyEgOGL2jZkuFfaz?=
 =?us-ascii?Q?BHbXLtjBzOoLBbXIaCX850zj3EZpYfzsTJEErX9sUo9JyhXNQkNP8ZbHMIJh?=
 =?us-ascii?Q?Z7iaUKpv82yeigp5CR8VHIafhdJW8ZhwPgzQaEKL6PSb8GteBOZ29e8cV9/t?=
 =?us-ascii?Q?OTfnSunXMBaTZ0Cg3AzrrkICIv143hrRzovKnre0KK9hPYQn8KRD6W/4+gK3?=
 =?us-ascii?Q?YmN+FNsAz2gErg2O2JfgL8P2PnCOOUvSOrevYE+SdMhgk5lwDcRwtDbaASsU?=
 =?us-ascii?Q?2S/nkBIizlPEIhMIDLcmYQuUNJPpLPlC215E9429fx1qXZxU/bc4lxck48Al?=
 =?us-ascii?Q?OJ+phI0WYS2Id4tn/fJ+DvYxl2ZIDboMJdf51lD1YKg/vdGw0LymxNoBEvB2?=
 =?us-ascii?Q?NcXiMa6Hm5yXvPpWMAHf21OeeSvNlu/x4s+HO2rAYumqrwxuRmoUXSzG1qT0?=
 =?us-ascii?Q?uHXHP+d6Txjcjdu4TJYnArA+RqVbzNlRqk9JCbrnVF6Bc3kg5Rznim8Fjt4w?=
 =?us-ascii?Q?j8LCutTZRE33nGRt028GvTdbkUC3xTe8a+c6HC+JhoM00jmJiXqfJBy+vSzw?=
 =?us-ascii?Q?lf060oFhlKac2o8vGXK1OMv8jvhYfyb6yRsHL3NOR6uEvHuHWLSo2A9AZde6?=
 =?us-ascii?Q?uvv4bU9jKp935Ft/PngMIs2Cg5k5fKl7OSOCednKQ8Qx9FsgtHehiuJuxR6Y?=
 =?us-ascii?Q?c96Ltor20csG3Y6ar70ch/IfRFyRu1xdrOIdjSk1xibhZeVxXof17Ay7oZ3R?=
 =?us-ascii?Q?FedYCIJjfyQWU6QppiTXm/hck8lHEH0JqCYb2FiH3GjlOy4Ho2qVFzfvdyW0?=
 =?us-ascii?Q?ujsccaWKO/OWoWXvigB1i7rjUCjI9LXSgrrD4dL5c46afMikiScvIwUzPXGQ?=
 =?us-ascii?Q?g4ZKQtV5wPRFv4EScj/yegke4ZF0KNq+QgXd+oPsrfUWPrYTm/nDfoEjnfiG?=
 =?us-ascii?Q?DxUDiCLncNPyNqywza822mjvipWdfRDmWMPzPUaM9dgzaPW3kQexzOxG8/d2?=
 =?us-ascii?Q?amOSwfx4Za3092hhLLeCym/vEPKC39unzHbV7EaJHJ5xQo69ptsZI/Cp6+Fc?=
 =?us-ascii?Q?Or20GbgubMHnpKMX87T9UoVtpRPUhMQzlME402Aiirroy1jLvVfqaAq3/R4z?=
 =?us-ascii?Q?rlhDBtB5AnN7BJd41OOyQ3n2Fi8nFp0+L2ryJLSjPmkaAdwujuLnT3t2P10O?=
 =?us-ascii?Q?8h15eFVT7VYkqZzzUj+M7pzSrQARPB3OquTJ8esdQyLAVxK+JBecz3OWPRkI?=
 =?us-ascii?Q?an0ljnRkFK71dzGCTrNXu3CX7jLrRu8KT1/zx5RgETiUmBr3wYmm4obwXARU?=
 =?us-ascii?Q?e+2CC9/iI/2Pe3gSIce9fAY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98d75292-15b8-4b6c-8cd0-08d9cf3769c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2022 04:05:15.3141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SwdD8Ctpx4SSemc1/ayb7v7/5jsFAubFvAqwzU0XwDGf8EtUt4sQjvbrReqjCrR1l3FF9r6MDvK/H+w6yM5kKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3258
X-Proofpoint-ORIG-GUID: dTYy4ZwNZLk_fMT_CpY2BNCl4ha30sGm
X-Proofpoint-GUID: GrYGXNqBIAvssZXSmq2JkT_w3wwgzlhk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-04_02,2022-01-01_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI Jiasheng Jiang,

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
>=20
>  	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_CONN, "Uploading
> connection "
>  		   "port_id=3D%06x.\n", fcport->rdata->ids.port_id);
> --

Acked-by: Saurav Kashyap <skashyap@marvell.com>

Thanks,
~Saurav
> 2.25.1

