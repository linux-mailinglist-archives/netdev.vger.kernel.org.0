Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F9125ED50
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 10:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgIFIBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 04:01:52 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24948 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725497AbgIFIBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 04:01:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08681Efv028901;
        Sun, 6 Sep 2020 01:01:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=Ab/d7iJvPtN8H90kPBonNoge89MCyF6bgQ7cPctED64=;
 b=cFBOlCHxZwnLz38yiqoe9SGKZOSwk9/bH7/InFGnHqFq+C3G6gMFiOH3k9EShIhYvFl4
 6EgAO+hed+A5OkYeppg2/D6j/is1+szcuvAPSxvZk2+70Ud5GdMnBr8y+SQTRufv56wo
 ZEHN+IRfGB7FjLmuCTs2Sjn5yEbCuT1DG2ItDEj3iyozi9PamgV1Vj+z0b1xsydoOojL
 hmbMmRGkrS3ykfH40qC1Ixr4rDjMZyU/7pcCESIWeCOwB0n8r6BiWlv0ViJnnfmlu/XS
 69trZOMleduQXsoYL41Hzv8YRHG2oOrQwK5uZvAJUHCRpS+y9ftyWFgmRhW8ux6Efn3D RA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 33ccvqtpu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 06 Sep 2020 01:01:43 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 6 Sep
 2020 01:01:41 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 6 Sep 2020 01:01:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJ1l1Qzbcn9Ho6YsICw8P3oT8tLBRJpsTMPxazKa2aB51Yiy/W/k4U/nMwWBMBuM+c3tZ9gEWx/cgZ5NTNKcBffqPjtBmMAMILOPsQ6PjG9rw/2z7WsDNUXI6yOMFQgV+lTt345qDWr4paG95k9sNhtdjcXOQHmZGxePTgOkSpY7tNEBFxw2THbXPqQwhr2pwxPIJBnlF6x2GKkyIVmX6mp8kRIjWQcDWao6gT6g09sZCKJrgaAEHO6vGFqgRVxtlilaw1akz5Lp906Qam6VOEDHAOau08dZrGEbQJ/wmuUzZXr0SwXaGvJT9hOeL4WUmTUOEs+6/WV9rWV1sGcC7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ab/d7iJvPtN8H90kPBonNoge89MCyF6bgQ7cPctED64=;
 b=gN+ltj9VH9Zf5cYFbnxuz2Ugg2NdfHpWr8QDiR73AjB5Wc/ShqwLbECv1fAWJXwHisddLeeDtkCd0+eBNE/n2I8FhkURiSeXfnbI0qybUtQg86fGzyvJV1dlNyoJYw2pXomq+YQekeZ9QAIocx8VrIf5T3r4CcCLp4wieV+chbgFlRIq1RWgnZkh/02+2W4xvGsZcTT7Z2WIp6o2Q1OWI429UqNmu2nhMwQTYgizLG9BS6rR8EXogCBcrnfgYWirjkPq4ACJnR2wt4jXM8S1AXAmxdwhfTcPsdeVVpkPZlibYmCB2LGwW/Va03MTJHk6PtzdCmh7X+xcVtb10mYwug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ab/d7iJvPtN8H90kPBonNoge89MCyF6bgQ7cPctED64=;
 b=kpaV9WH3HgE6oaqsEMAdL+q+yEj9cfwF0euCSl3OVgEV0UUronXn4HbmfLWuyQza5KGm8OpAMlmqBhTfaJtR4hi13b1PlRj0Pms58k4P91N+BKW3mVgZ2o6U5D1zssghauQuGq8ntpYixqvo3ehWJh8+YFjM3jTM/Guc05T/rRo=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (2603:10b6:208:163::15)
 by BL0PR18MB2290.namprd18.prod.outlook.com (2603:10b6:207:48::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Sun, 6 Sep
 2020 08:01:40 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::b0d9:d41f:16e6:afca]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::b0d9:d41f:16e6:afca%3]) with mapi id 15.20.3348.019; Sun, 6 Sep 2020
 08:01:39 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, Ariel Elior <aelior@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH v2 16/17] RDMA/qedr: Remove fbo and zbva from the MR
Thread-Topic: [EXT] [PATCH v2 16/17] RDMA/qedr: Remove fbo and zbva from the
 MR
Thread-Index: AQHWgwyoE0uW8IKJkkOwZ287dYlXr6lbQbBA
Date:   Sun, 6 Sep 2020 08:01:39 +0000
Message-ID: <MN2PR18MB31825797F7D24C63406F92D0A12B0@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <0-v2-270386b7e60b+28f4-umem_1_jgg@nvidia.com>
 <16-v2-270386b7e60b+28f4-umem_1_jgg@nvidia.com>
In-Reply-To: <16-v2-270386b7e60b+28f4-umem_1_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [46.116.57.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b82a17e-cfa6-4652-a040-08d8523b1611
x-ms-traffictypediagnostic: BL0PR18MB2290:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR18MB22900F5B3B47B9DB509D5D34A12B0@BL0PR18MB2290.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:469;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AX9TdAhrYwjDYpQwXJMsWtZP6ONyxctcPxPfJjm2jziY7S0ZknxvZ8FnLvOtgvM61VS6cUQfInkkGF+3gQM87Y3fuXej9KJexk8IvcwKbqAjhOqZp6qav4kFQFb+IpXs2y9l+Rfxkmg26o0aqgf/sg/ZGfJ3qBzjKcbVedcQKSrf7C4Vo8KG/5NF7uPRa0oIZy7tUdtxFzmLIwYZp8CamLhmitVcYjWFVlqI3vTvMqO4fkcWkguWHq7VcyTkJFdOaAqxmeb963saKT/Al9XMhJrLwICbVWK5jOTnIKMrqYzFn1hzex+5X9amBdz18PgT0DE/kKxE0/mb57HeNKzT9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB3182.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39850400004)(9686003)(7696005)(6506007)(186003)(26005)(110136005)(86362001)(5660300002)(64756008)(66556008)(66476007)(71200400001)(2906002)(76116006)(66946007)(52536014)(66446008)(316002)(33656002)(55016002)(8936002)(478600001)(83380400001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: R7ad88FEe2zTaL/vxHl7yj7O4jCUU0ZeNjgzkGc7Pslm6V6QVza627rQbbeTCo2dOKlN2Oxo2/y4KUlyF8Jr7ERtHAegDbkW51roY0w0l4flvfmt9sfcwYlGkLHV/SachyEXY2gxX+XVK0hXlfLhRXa48cSWNFVZve5EIkPBTqxNOu0ubWDLNa43WuHQtyx3k9tfm6QMTjzD5ZpH/Js4zEsr91XnXFsoMARWuQe8GX1dSep8Ev8Tci8Pwi/fU1TPOWBUQTRApIJCpTvlHYrKDr3aKF4C5NNkJv9uaSAjXHdZbN2+u4NHYJhcRJuAn1HQvOF6dUysUWFXFc2bQf7a50AGIu5wRbce8GrV3pwV4wHsw5DVlDnPP0VaPMjEbxUb4cUZsh6wnZC5qyrYzDuVZ1H2YTEP/MZ2E+CDkSB0M0j6nDoa1XftvNgh/XSHK8TyZmRAXlvoo6f6M4Y+EPt4oG/z5juVtoA1OwrzIjKxu+9Hicixxn13Y8RlTqXbtFLoRe+qCY9r+/qQSMZFOn4dUCG0ftvfqfcnZ8qhkel8AjeKYj3dk4gDqCMG1hpnB3mjyMLdb71iF1WBz5V7lW7uLqsVuQZ4f6qMLfAbKllStVFyN1bwizVIk2zxFXPKcDV73k8PV04EzcZs6LUGKOngkQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR18MB3182.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b82a17e-cfa6-4652-a040-08d8523b1611
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2020 08:01:39.9257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QYvjQNJum4INPqv6AWwfo3tXC2FqswCl2Uq3/Qcr6YEqbH5sTJ0zQlcMLB7MUrnuDebs6xH34QUMtB4Ih+LYhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2290
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-06_07:2020-09-04,2020-09-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, September 5, 2020 1:42 AM
> zbva is always false, so fbo is never read.
>=20
> A 'zero-based-virtual-address' is simply IOVA =3D=3D 0, and the driver al=
ready
> supports this.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/infiniband/hw/qedr/verbs.c         |  4 ----
>  drivers/net/ethernet/qlogic/qed/qed_rdma.c | 12 ++----------
>  include/linux/qed/qed_rdma_if.h            |  2 --
>  3 files changed, 2 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/qedr/verbs.c
> b/drivers/infiniband/hw/qedr/verbs.c
> index 278b48443aedba..cca69b4ed354ea 100644
> --- a/drivers/infiniband/hw/qedr/verbs.c
> +++ b/drivers/infiniband/hw/qedr/verbs.c
> @@ -2878,10 +2878,8 @@ struct ib_mr *qedr_reg_user_mr(struct ib_pd
> *ibpd, u64 start, u64 len,
>  	mr->hw_mr.pbl_two_level =3D mr->info.pbl_info.two_layered;
>  	mr->hw_mr.pbl_page_size_log =3D ilog2(mr->info.pbl_info.pbl_size);
>  	mr->hw_mr.page_size_log =3D PAGE_SHIFT;
> -	mr->hw_mr.fbo =3D ib_umem_offset(mr->umem);
>  	mr->hw_mr.length =3D len;
>  	mr->hw_mr.vaddr =3D usr_addr;
> -	mr->hw_mr.zbva =3D false;
>  	mr->hw_mr.phy_mr =3D false;
>  	mr->hw_mr.dma_mr =3D false;
>=20
> @@ -2974,10 +2972,8 @@ static struct qedr_mr *__qedr_alloc_mr(struct
> ib_pd *ibpd,
>  	mr->hw_mr.pbl_ptr =3D 0;
>  	mr->hw_mr.pbl_two_level =3D mr->info.pbl_info.two_layered;
>  	mr->hw_mr.pbl_page_size_log =3D ilog2(mr->info.pbl_info.pbl_size);
> -	mr->hw_mr.fbo =3D 0;
>  	mr->hw_mr.length =3D 0;
>  	mr->hw_mr.vaddr =3D 0;
> -	mr->hw_mr.zbva =3D false;
>  	mr->hw_mr.phy_mr =3D true;
>  	mr->hw_mr.dma_mr =3D false;
>=20
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> index a4bcde522cdf9d..baa4c36608ea91 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> @@ -1520,7 +1520,7 @@ qed_rdma_register_tid(void *rdma_cxt,
>  		  params->pbl_two_level);
>=20
>  	SET_FIELD(flags,
> RDMA_REGISTER_TID_RAMROD_DATA_ZERO_BASED,
> -		  params->zbva);
> +		  false);
>=20
>  	SET_FIELD(flags, RDMA_REGISTER_TID_RAMROD_DATA_PHY_MR,
> params->phy_mr);
>=20
> @@ -1582,15 +1582,7 @@ qed_rdma_register_tid(void *rdma_cxt,
>  	p_ramrod->pd =3D cpu_to_le16(params->pd);
>  	p_ramrod->length_hi =3D (u8)(params->length >> 32);
>  	p_ramrod->length_lo =3D DMA_LO_LE(params->length);
> -	if (params->zbva) {
> -		/* Lower 32 bits of the registered MR address.
> -		 * In case of zero based MR, will hold FBO
> -		 */
> -		p_ramrod->va.hi =3D 0;
> -		p_ramrod->va.lo =3D cpu_to_le32(params->fbo);
> -	} else {
> -		DMA_REGPAIR_LE(p_ramrod->va, params->vaddr);
> -	}
> +	DMA_REGPAIR_LE(p_ramrod->va, params->vaddr);
>  	DMA_REGPAIR_LE(p_ramrod->pbl_base, params->pbl_ptr);
>=20
>  	/* DIF */
> diff --git a/include/linux/qed/qed_rdma_if.h
> b/include/linux/qed/qed_rdma_if.h index f464d85e88a410..aeb242cefebfa8
> 100644
> --- a/include/linux/qed/qed_rdma_if.h
> +++ b/include/linux/qed/qed_rdma_if.h
> @@ -242,10 +242,8 @@ struct qed_rdma_register_tid_in_params {
>  	bool pbl_two_level;
>  	u8 pbl_page_size_log;
>  	u8 page_size_log;
> -	u32 fbo;
>  	u64 length;
>  	u64 vaddr;
> -	bool zbva;
>  	bool phy_mr;
>  	bool dma_mr;
>=20
> --
> 2.28.0

Thanks,=A0

Acked-by: Michal Kalderon=A0<michal.kalderon@marvell.com>


