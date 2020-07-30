Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADDE23389E
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 20:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730374AbgG3S7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 14:59:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45344 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726544AbgG3S7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 14:59:07 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06UItvbu017883;
        Thu, 30 Jul 2020 11:58:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=f/85mI330xncUSXZnB7iX8Sz11ZYFFvvDD93fwD6Be8=;
 b=NL0F+HNNge3z4djmjvRgDdAx3bDpheuQDKDVM84YFmuvy9LYEfXpNjSJWGm92/cKptGr
 Zynh7FyVvGzXKiA+juM5bre0Bl4ZaxxZG76+nykA4Ou++p4cQAjEMlsDqLnumTH4GBzn
 rvVlBFKma/qFHm7D5S5h5+7qr/Betc5ci4g5nqbNyWVBddWDMvtqOFuCHEkRXPq32S8b
 opiPaWbQHYMSPSVTILqW2w45zc42z2dw9IoEvJnV/itgs4fAfXl73VV/PhrZvS9qiYWx
 N8hsAuoTQgOJiXhO3hqYKV6UtI1jXLckbKyYiCy3skB1wHB4zbivu+NtgynzgPvx5mZ5 HA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 32gj3r7dyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 Jul 2020 11:58:59 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Jul
 2020 11:58:58 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.57) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 30 Jul 2020 11:58:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zd8ueEpGx9jaT2VKp/9LwfISrHuKq9sV4Bx1X66bV+lrJAsG4CiWUPuXU9oWI3bpqVmxERF7rDhd/B8fUU1UksvqhY0MvJ3vQRf5wfqJA2V+US26xyutHnjlCm0YFY2vVsfZLeRFuATW4LLcn9Gclys2Jw4uOkBNXXc9Hbk9xcZNersTmAcqf1qZX34f2BpVoEfBEk2lDlDSXjANoRPB/Ih2jJuU6ljpZERUpxMQLinTC1zvEkCImt6sd13hi4l0QNbU696DKKiB68vUmo1JtpzUIkrynfOEGvwVnyrk0kVQd+FeEMxVvluth9FI2TOxw552oLSMWHQMnane5oKxxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/85mI330xncUSXZnB7iX8Sz11ZYFFvvDD93fwD6Be8=;
 b=SXeX9B+ym6H4rNP9eqaAS6MW2OYyy5bNnwOAxOztTRzxytncx6oTlD5w416kk2EGrfCN6LGNBw/lhQD/TPgoNclGoo9qtPItPvHxkZtv0K4I95yu6shIwEUXt8+97reTJDivErtAXkvM65OtpRTrW11R0AoTQSk2ftO8B3sjwfVIdv05Ma8nQu9J2UKJ4Nh4QUECv6lZ1oqfACpsRI7Oa9QCv2VjAeO+yg6IvIaqjuecE/qbr7KfLAAv1hJRryy36qhfrePYhf8XoaBmj8Wmuk9TonbUo3e4Xaz9agKy80fIcXQ+xg57uEwd2845CSU6tFZhn6fB7cFfo3qgLYCiZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/85mI330xncUSXZnB7iX8Sz11ZYFFvvDD93fwD6Be8=;
 b=W0i8GZniylwnMmmGNMUAewGTZb6Mt+7v3L/cXTXrtzW/tCO+xcjQkvaxiCo6NbxRHu18fDscN2hGI9np87Dj5cqg5UcgGUEBeA+38DK/4HhtXmpbACFGxseeFt2ZylMIyBicMJ381g6IIymElWbD+CrMT6vcMGWvawjHR+T6RBc=
Received: from BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28)
 by BY5PR18MB3204.namprd18.prod.outlook.com (2603:10b6:a03:1a9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18; Thu, 30 Jul
 2020 18:58:57 +0000
Received: from BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::bd3d:c142:5f78:975]) by BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::bd3d:c142:5f78:975%7]) with mapi id 15.20.3216.033; Thu, 30 Jul 2020
 18:58:57 +0000
From:   Derek Chickles <dchickles@marvell.com>
To:     Wang Hai <wanghai38@huawei.com>,
        "joe@perches.com" <joe@perches.com>,
        Satananda Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] liquidio: Replace vmalloc with kmalloc in
 octeon_register_dispatch_fn()
Thread-Topic: [PATCH net-next] liquidio: Replace vmalloc with kmalloc in
 octeon_register_dispatch_fn()
Thread-Index: AdZmo3PCgV7e1b5pSqaLCt95dKIAfw==
Date:   Thu, 30 Jul 2020 18:58:57 +0000
Message-ID: <BYAPR18MB2423C7A710232C87229FF90BAC710@BYAPR18MB2423.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2601:646:8d01:7c70:75c5:f7c5:1663:bfbd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93a4778e-fec1-4e4d-780b-08d834ba9d05
x-ms-traffictypediagnostic: BY5PR18MB3204:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB32040BF22DB02763A0F63FF1AC710@BY5PR18MB3204.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +PVwu2bzhaPyZqmyMvSDXPHOx4Pgi6qbmnGA4qh0+r082aDdocY/DTUUF7RFR845IJTU14Fm05JEjxsyN7WE297feH8a+aafyhBgNANqkTNJ2QbXObhnlHC0qGWQXrZ+zRnQrWyQ8aPD6XZCIIjAcPy2+EYzsNUStT57HVD14vtTQNweql06PvITzcNRvoStsFiQQm23tGW0PJcxrupJiWlKa3QsD67vNjBu5DH62+HvtKrBz98r+FgYY4xB8ibYRbhVYENz588IvPop8qqoLaIUH/Qm4vGEyGOkLtN+RqsZ6ujIb9IvFPtykVi17ZMPOLU+6ldwXpyqwldBBoqHoA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2423.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(316002)(86362001)(83380400001)(55016002)(9686003)(4326008)(8936002)(71200400001)(110136005)(54906003)(53546011)(6506007)(478600001)(5660300002)(33656002)(2906002)(66476007)(7696005)(186003)(64756008)(66446008)(8676002)(66556008)(66946007)(76116006)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: YUp3V0eeraAqBpvw/5dE22JccLye8svPtGkdgd1QRuNsfuEojdHigL2ezsSSPuJf2lu6UsL5nca+p0UUKR61o9HgBWAsu3Dt3yD3L6vAA5HI1tLJMMGxX46/jKpuk+iBD25H8A1LHfx9cfMjV4jztlC85LJ6DSsrBANlEnFgJtIOnoBRopwgh5Za1Z5wa7WT9Mbii7OCd6gmNeB6Nwj7Gn0NzLuyLjDhJkwgi9c2U+CAu64Fzq262JVxU59/pRBZfyO8gylGYL51aKw+BydK0s2e2ryZR+z4smy5Ig6TkPR1c1OzLvMXkDAjx1RUIe2l8ORSDQRNfSDOguB9vKcdkYRPQHyWvTy5nuUO57itHI57Z9XQc79pFDBaUpnd31JaPq3MTh9v71pcPSGb97OGAoDezLbYbESpG1FkgBG+8yWw6obsJzFj/uR5IoPoxx4o6e2O8VpY5YShMNtXqFWTLkDmAoBPMwJHssDp78rvYnEYGzemhn287f1CDDey8K2CHuT4rvDpvGAEJiXZAMRIPNof2I5J74aZooBwE27Tjt6E1VdkpwNvGpbh7S522cSfK0pJEkvDJMsh7yiaTmLvjnn69Bvz/Z5qkUuYi6V3oR0CB2uRGvwRfbfKdfIqk6I4CiLMhjrqNSdK57Oev5zY+N7ZnFuxuEWyXJDYAEAkDRb8f396vylvI0xhEXxkwrdvLC5Ui4/ycEpAjqg8VFhxig==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2423.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93a4778e-fec1-4e4d-780b-08d834ba9d05
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 18:58:57.4378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yh7iQ6xxscf9U22SwiWC1S76QpxuFQd7XC/5eXudQSudO+jqRvBM8TAcO1/4a485q07pRyChxOSX3ePhucvFvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3204
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_14:2020-07-30,2020-07-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Wang Hai <wanghai38@huawei.com>
> Sent: Wednesday, July 29, 2020 11:12 PM
> To: joe@perches.com; Derek Chickles <dchickles@marvell.com>; Satananda
> Burla <sburla@marvell.com>; Felix Manlunas <fmanlunas@marvell.com>;
> davem@davemloft.net; kuba@kernel.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [EXT] [PATCH net-next] liquidio: Replace vmalloc with kmalloc in
> octeon_register_dispatch_fn()
>=20
> The size of struct octeon_dispatch is too small, it is better to use kmal=
loc
> instead of vmalloc.
>=20
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  drivers/net/ethernet/cavium/liquidio/octeon_device.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_device.c
> b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
> index 934115d18488..ac32facaa427 100644
> --- a/drivers/net/ethernet/cavium/liquidio/octeon_device.c
> +++ b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
> @@ -1056,7 +1056,7 @@ void octeon_delete_dispatch_list(struct
> octeon_device *oct)
>=20
>  	list_for_each_safe(temp, tmp2, &freelist) {
>  		list_del(temp);
> -		vfree(temp);
> +		kfree(temp);
>  	}
>  }
>=20
> @@ -1152,13 +1152,10 @@ octeon_register_dispatch_fn(struct
> octeon_device *oct,
>=20
>  		dev_dbg(&oct->pci_dev->dev,
>  			"Adding opcode to dispatch list linked list\n");
> -		dispatch =3D (struct octeon_dispatch *)
> -			   vmalloc(sizeof(struct octeon_dispatch));
> -		if (!dispatch) {
> -			dev_err(&oct->pci_dev->dev,
> -				"No memory to add dispatch function\n");
> +		dispatch =3D kmalloc(sizeof(*dispatch), GFP_KERNEL);
> +		if (!dispatch)
>  			return 1;
> -		}
> +
>  		dispatch->opcode =3D combined_opcode;
>  		dispatch->dispatch_fn =3D fn;
>  		dispatch->arg =3D fn_arg;
> --
> 2.17.1

Looks good.

Reviewed-by: Derek Chickles <dchickles@marvell.com>
