Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2A91B564C
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 09:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgDWHoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 03:44:17 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12114 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726271AbgDWHoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 03:44:16 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03N7eKsW008653;
        Thu, 23 Apr 2020 00:44:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=LbVWv8YI8whdZWqf1CmSSvuqlu0jwfwlAzFxWYUGBYs=;
 b=EpqZFbuZjA/ajxjnVUt5uF2RQrroPExbrPHYmBMJdWJbEEJfweu3sNmZj1ElC5SH+N1W
 4FhdOHCT/OAR6T+CahmWcolxV1jwBOauZ6R148/US+SuEGwAfJ2yM8RoqX9hreiZjUtM
 we8JbboZH2IOCg6DdKV39F9L0L408hUscwbU4J/J4mHRLBCCAhL78XOeTGnaQPs/OXI0
 iXFxLhSqleKvhKtlRIfQotfBdQUTOwcNYDd3CQ3W8Q77aRLN/beHeqDrrkz7Pe5QS3nd
 YkSeGDdw75P8wqoO39jmtxHateIbbFHZ/AZGfLr6/DSSQzzqUvZS3a7Ij0aj2ixlX118 xw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 30jd016ceg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 Apr 2020 00:44:08 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Apr
 2020 00:44:06 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Apr
 2020 00:44:05 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 23 Apr 2020 00:44:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PFyqEQwHzaHMnAilgMuzDCiptLoSUANzIqHB/wxCwZ7C1GOT/1BXPJBFxORXqUpxxN7Ycjxb2GbEwMVWhXeaFabTU4IUliTuPca8sT5FizT6k/UWj3f/dV6UT1JcJPXVR+Ru0tuID2+wKXkVSQO9YSNLjenB/RZyolxcsoJhNR15Beta/ybW5qW6uQB8ek34lVdUC37qYyNb8NE5BEvKNFjI50VsPRs0f8CQ8EX4ap86w+8Ceuc4X4NB4cAfBTl4DeIh1rf66ckI5JMH0DwJWW88ZHJbSr0HP4YAS2K/SR3ebcPS2JsA/W1WF6UsziOILQQ7FwgaC1RcwtFx+4qcaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbVWv8YI8whdZWqf1CmSSvuqlu0jwfwlAzFxWYUGBYs=;
 b=MVG+EX6PMJ9Ew5ZYJYH7T8B4HFkCUN04ci2IBjnuiuEjNJg1vh2h6/3cfq4mEiO7OqwxqAoSPr+hyGWcZXRThHDIocpUkaN3m/IChq30Nda23cUqkvtUvktb4YQ/MOCza4H6hC8opVt4cJzemwLIs6si4JdkNLpC12namfneFh/b/r1zyNv23cZBXv+ALUQfV7Xt+YEAP8vC7rl1a74FooU0ZSG4jQfwAAjE+rSpYuH6pCo4+s7JnWvhECRL8MdXtF0BHJVYMhqM+mhbkE8jvK2AqooXdfLqO3pHOZCYnjs9teLmhaWKaS3Ua/WDKEjlX7YHQ0OW1+VXuPZ8tAKMrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbVWv8YI8whdZWqf1CmSSvuqlu0jwfwlAzFxWYUGBYs=;
 b=k7DZRuOCMimyonJHJscmDFeZBjogi8SdBGEnDW61f/WmTAA3/nMlTcHyy8fdLTHF5hH2GYBJcGF3545hWN0Wdmom5hGKpiCHcKPqeCystAaA6wiIr5VkEWtWMWGGVcSpZoArl1lhTq5EZTppk++AM1R2pySpqiJN8aKyrAtXPJI=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (2603:10b6:208:163::15)
 by MN2PR18MB2366.namprd18.prod.outlook.com (2603:10b6:208:105::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Thu, 23 Apr
 2020 07:44:02 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::71dc:797b:941a:9032]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::71dc:797b:941a:9032%3]) with mapi id 15.20.2937.012; Thu, 23 Apr 2020
 07:44:02 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Zou Wei <zou_wei@huawei.com>, Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH -next] qed: Make ll2_cbs static
Thread-Topic: [EXT] [PATCH -next] qed: Make ll2_cbs static
Thread-Index: AQHWGT/gNMC0p00KAUeahMVFzzJqUqiGU0mg
Date:   Thu, 23 Apr 2020 07:44:02 +0000
Message-ID: <MN2PR18MB318279E835EF6483CE55304DA1D30@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <1587626860-97801-1-git-send-email-zou_wei@huawei.com>
In-Reply-To: <1587626860-97801-1-git-send-email-zou_wei@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.199.69.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ad42ec5-217d-42e6-7417-08d7e75a17cb
x-ms-traffictypediagnostic: MN2PR18MB2366:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB2366DA2268EAC1B22AEB6E0EA1D30@MN2PR18MB2366.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:605;
x-forefront-prvs: 03827AF76E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB3182.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(396003)(366004)(136003)(39860400002)(346002)(71200400001)(86362001)(6506007)(7696005)(2906002)(55016002)(66446008)(478600001)(64756008)(26005)(76116006)(66556008)(66946007)(33656002)(186003)(5660300002)(66476007)(316002)(81156014)(8676002)(8936002)(9686003)(4326008)(110136005)(54906003)(52536014);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mHI4Ggitp8C1j96sKJfmTViSFLtECJwlzcrnDHg71jP9NYWkxprR3my+x31rUuknt1cBRxRZAIYNiAuZWcCOiZBkKs3esQDFYVoUVcG15OTgogiGttHzhQYgUn/YBaXrlDHwotlPKSHhuLLzU00olus7t/gxP0Ta5lzLH7Jos8B/uAUxSnvm1sFMIY7xurzVBpp2XYCd0hixGuTCHq/vXATBgitWFpiOXUyU4KL65++wliOYnWi1XbwFBBehYesPqgcMwc5FOZI1c+bGP29Fs2AW0pCbtzYA6bqbw6mjr7SwbfKUGiPZm/98fRNQmuCpktCtli/r6qInPLphh/2baNsLQfQdxyma8U7YbY2vLlBrR+8qyQiNTKJGnxZf89JhzSG2yA8rhTgE1j3d1ZgOarTHkvaKc9CuK8dN6yoDEIPiP9QWCiG06Pir8Mm60l7z
x-ms-exchange-antispam-messagedata: vuYX6iIXBHN0FOPmRFPXvWjORBXqh+bp2qfwYJYbMYy2LWOylnnrIqOsSKxwl++gJrzbx+TomfsvBnFO5OEHWZuO5RCq5+jHLPMzcsR02dvrH/Ue2DZXtUEQ/46IDVY8gqwKlRCy7EIT4wt9hkp9mg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ad42ec5-217d-42e6-7417-08d7e75a17cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2020 07:44:02.7687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qx4VFkkgrX+ekdtqMEC+LSwN/3s6ZP/RnOKtv3sGE90JSQKFfwT+ebpGwVzWEBOWWdDlYNv0FPRpBJIq7ibz3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2366
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-23_06:2020-04-22,2020-04-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Zou Wei <zou_wei@huawei.com>
> Sent: Thursday, April 23, 2020 10:28 AM
>=20
> ----------------------------------------------------------------------
> Fix the following sparse warning:
>=20
> drivers/net/ethernet/qlogic/qed/qed_ll2.c:2334:20: warning: symbol 'll2_c=
bs'
> was not declared. Should it be static?
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_ll2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> index 037e597..4afd857 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> @@ -2331,7 +2331,7 @@ static void qed_ll2_register_cb_ops(struct qed_dev
> *cdev,
>  	cdev->ll2->cb_cookie =3D cookie;
>  }
>=20
> -struct qed_ll2_cbs ll2_cbs =3D {
> +static struct qed_ll2_cbs ll2_cbs =3D {
>  	.rx_comp_cb =3D &qed_ll2b_complete_rx_packet,
>  	.rx_release_cb =3D &qed_ll2b_release_rx_packet,
>  	.tx_comp_cb =3D &qed_ll2b_complete_tx_packet,
> --
> 2.6.2

Thanks,=A0

Acked-by: Michal Kalderon=A0<michal.kalderon@marvell.com>


