Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6E3C6CADD
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 10:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfGRIWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 04:22:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11028 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726485AbfGRIWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 04:22:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6I8KN3e006176;
        Thu, 18 Jul 2019 01:22:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=a+PwnezaleAxE2uWxlZVitSKd/ocaie5kgGNkOzq5rs=;
 b=vrseGPrAZ8sj+1407LjitHX9EDISlR/r1TVTcIhberyVMjoisNVTOHWID/ZEDRStACDj
 qB/KGqjKwYSm8ZmFS+ouyg1nv8E2uWbKwCuBXYos/0lmHufcpP3ttbnHkGdYirYd/A+6
 XMxom1k0aHNExaNP2jNTsuGg+upp3ItXga9n4UpzZx5hJ8BLf6jFD8BPOSahDRxU1L/6
 Rd/kHrQ855PnPxvLCUvJFsDsR2M637dHL7qP17TC1yrjy2eFVZK7smd96g9WPSyVHs3g
 uGKDLMkWQjMPwci4nrnd4anISZ23Ug/POXVPO4lQidu7TLUnSA7gEuNUotlmpx9eVkRn 1g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ts0a2b6cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Jul 2019 01:22:03 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 18 Jul
 2019 01:22:02 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (104.47.42.54) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 18 Jul 2019 01:22:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=njU0Pyv4Gzg49IsJiNtFQGTC/JMha9iFCJ//9770suWi1/WHzpF91NsSMKIX9mp0NdxSDH1fT4nvAwaZmRTbrdBHu3G/iGPtKMsWRzWStcvv1cCNCkskgUf1tDztkJQ2C4CKlN4MF7kLJxQ7XFicEhNOokCKGVZ1Qt3/t0LN3V8lPlVR+Bwkl71263in2oxyo5TbxeCtmuwx/UGWfSi/9SdNeI66B5+wEh2mdx9FX55N5uvwOn28QtpEG/np2lTpABcGWzuxzgORx16DXhJDXjrhz2efa2FWfuiTHM3M4vFOcaGNjva/8uPfWOHE3SAz1zjvCJrTqHXJ+fwMfZ+rQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+PwnezaleAxE2uWxlZVitSKd/ocaie5kgGNkOzq5rs=;
 b=cAh0gmYfm6qLr1Jw+iIPF5duultdelemRGa7dD0spN6h392pMmagGt/XCATnI3EXJxPDkm0aHftJoN9OsFfNd43HyrJZJkWmsN3nK3uSSBsn7UKg3ABrg9uHZdBGU2c/CsOmBXXczCbO1No1N5bTPjg4G4pZazXfDuHNKc5mhnQ8iMoQ4BjjCVGh3t0+eY/9oX0BbVGbgqEkOf63hIXP8Da6/vfWYs1MuJL93LIMig5LP0NQDcnI7EDArOP1KykvDE4UMfWDZ28feawf7nJgaZzhWlWhHxh6Mcm8SjsBlCZ5Dib3ZuQCuvgwSd6rFKSa9gT1HlHcf7Qwhke3WcjEAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=marvell.com;dmarc=pass action=none
 header.from=marvell.com;dkim=pass header.d=marvell.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+PwnezaleAxE2uWxlZVitSKd/ocaie5kgGNkOzq5rs=;
 b=Ci2a0n+QHSQUg++Gwh5II+I3MBPoFBX/q6GoF1P9MyWtI0Zj7y6RvTBNBQ9kCwzeXhFmvPZ5RwgDYByYdtN8ZGR+2gxTzjGATnrcAmIiYDWN6eoTaax5erUl+6KUmMh1jQ5o1cX50EoUmh1hycP6f4miJdhzkGinB6IInYe4WU8=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB3088.namprd18.prod.outlook.com (20.179.21.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Thu, 18 Jul 2019 08:22:00 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e%6]) with mapi id 15.20.2073.012; Thu, 18 Jul 2019
 08:22:00 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Frederick Lawler <fred@fredlawl.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>
Subject: RE: [EXT] [PATCH] qed: Prefer pcie_capability_read_word()
Thread-Topic: [EXT] [PATCH] qed: Prefer pcie_capability_read_word()
Thread-Index: AQHVPQ3bPVlPVOMx/UeraHCSBcT9J6bQCYVQ
Date:   Thu, 18 Jul 2019 08:22:00 +0000
Message-ID: <MN2PR18MB31827E4CEAA1FDE1C395332FA1C80@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20190718020745.8867-1-fred@fredlawl.com>
 <20190718020745.8867-7-fred@fredlawl.com>
In-Reply-To: <20190718020745.8867-7-fred@fredlawl.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.199.69.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 547e6cab-5482-44ea-ab54-08d70b5901ab
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3088;
x-ms-traffictypediagnostic: MN2PR18MB3088:
x-microsoft-antispam-prvs: <MN2PR18MB3088E24F6957ECC3C7BC86E4A1C80@MN2PR18MB3088.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39850400004)(366004)(346002)(396003)(376002)(189003)(199004)(2906002)(33656002)(81156014)(76116006)(7696005)(81166006)(102836004)(8676002)(54906003)(8936002)(6116002)(66476007)(66946007)(6636002)(71200400001)(71190400001)(53936002)(6246003)(229853002)(478600001)(14454004)(76176011)(55016002)(256004)(6436002)(316002)(9686003)(52536014)(68736007)(64756008)(4326008)(25786009)(6506007)(3846002)(99286004)(86362001)(74316002)(5660300002)(476003)(66066001)(7736002)(110136005)(186003)(486006)(26005)(305945005)(66556008)(446003)(11346002)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3088;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4GGynZQhnes3Qma20xhXknyMCGFKOpa9wNk6hLYFmgD0eMLTNiQH4vGv5LMstbi6zWbcOdHflVdQUOxSxo9kyUB9ty6A0eNZpWwja1qNMxVIXJy03lh1dWkau1HODCtJGZ8Hg5QbiyR0VHM/MTWU1oB/gy8+oORU3gr2s9pvg4Qm26cBmMTifuzdkA9+33t1VwiIcqb4pLmMfeLDwKvbQzXt732KRBaRK10Ik6HH27TzSPzemnbnIXy5sPDgEbW/Er2Mi5ZIrVYRdUeaELbeiezEzuNyxD1oI9Zpq7T/i0TPivB2oVQymJtXfr/YwCXS1UUB6wQ7bn9UjtNlB4pJROwfSeg2xB4t4kkcJAsrQVBoLk8ogmCWxwCXdEa5C/PkVXwhrRHTPozAn1kdq4+rP2xTpcD0j0bARwr0HOsT060=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 547e6cab-5482-44ea-ab54-08d70b5901ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 08:22:00.3067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mkalderon@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3088
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-18_04:2019-07-18,2019-07-18 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Frederick Lawler <fred@fredlawl.com>
> Sent: Thursday, July 18, 2019 5:08 AM
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Commit 8c0d3a02c130 ("PCI: Add accessors for PCI Express Capability") add=
ed
> accessors for the PCI Express Capability so that drivers didn't need to b=
e
> aware of differences between v1 and v2 of the PCI Express Capability.
>=20
> Replace pci_read_config_word() and pci_write_config_word() calls with
> pcie_capability_read_word() and pcie_capability_write_word().
>=20
> Signed-off-by: Frederick Lawler <fred@fredlawl.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_rdma.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> index 7873d6dfd91f..8d8a920c3195 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> @@ -530,9 +530,8 @@ static void qed_rdma_init_devinfo(struct qed_hwfn
> *p_hwfn,
>  	SET_FIELD(dev->dev_caps,
> QED_RDMA_DEV_CAP_LOCAL_INV_FENCE, 1);
>=20
>  	/* Check atomic operations support in PCI configuration space. */
> -	pci_read_config_dword(cdev->pdev,
> -			      cdev->pdev->pcie_cap + PCI_EXP_DEVCTL2,
> -			      &pci_status_control);
> +	pcie_capability_read_dword(cdev->pdev, PCI_EXP_DEVCTL2,
> +				   &pci_status_control);
>=20
>  	if (pci_status_control & PCI_EXP_DEVCTL2_LTR_EN)
>  		SET_FIELD(dev->dev_caps,
> QED_RDMA_DEV_CAP_ATOMIC_OP, 1);
> --
> 2.17.1

Thanks,=A0

Acked-by: Michal Kalderon=A0<michal.kalderon@marvell.com>


