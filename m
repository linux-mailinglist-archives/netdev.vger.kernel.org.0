Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7125A2B5194
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 20:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbgKPTs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 14:48:59 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40094 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730181AbgKPTs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 14:48:58 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGJQsWH007480;
        Mon, 16 Nov 2020 11:48:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=3WTP8C2AMSk2Xq/uodawgrOwf+5/HLYrlO/lQcNdWuI=;
 b=MI6M6aRXUA/HxEvg/SrvMDnisYNNAx0jsWKl07n54a5BysGAWhEhLGXMDCbkrZwJAtAI
 0wtpOq4p/5SkoHP4Smmin/9ie03w3gCPWISznXRhBLhkIhqhJZWDSN1GwXqvayd3Ad1d
 6Iyyo0pgAcd32+kzUY6uqPuDcQNmFhgc7PIUWDGU/tUqG+QZdbqppFZkQ4wChJ0yj2PM
 4cSDWzca27SALw9/s9myL1GRwTELrXlYiyxHXAyEeTcWgTNdC5PZ5+c23BapXGq/26ZH
 Q5d65nCksuwBFKfxSf7HTq/piFaPFbyh6slgRiaQWqBfWUnz2qGcSkQHrej81Oc2dtZJ VA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 34tdftxq0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 11:48:49 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 16 Nov
 2020 11:48:47 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.57) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 16 Nov 2020 11:48:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpM5IcXFmfPM0kSEjIw6rqjLvfpeiI5fXPXQWZF/v46PsVlXJgtPND9sm53NeFLbHhqkkp/xY52IGf3IQyH/MJJf0XlJOjhM5pQtATbJeG7D4t483Wlt7VaBvXpTwQ1fxxktOeENGGKUcztuZ/dFQCR4jprt7UiY5OiI20rVMRFQ/pYWR8QiRsjzKhZTpZ7+RqJenYd4eN0v8MxenItLDMCKfXb4F5PygNH/+Thdwlnk1lxzpJZkR7+qLEEVxofSSEPkwSE9QDi+tHlG0oeBmv8XEfeRfd+MpS73B4SvWp3sqKY/640iXWNLG2LitUjIQLcHh/SNWbLBB6d5fuSJCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3WTP8C2AMSk2Xq/uodawgrOwf+5/HLYrlO/lQcNdWuI=;
 b=byblkjYkYoS68sfsSG2gJmTkSsfxOdqdRT3yKlv+zdPjfS5LAiP5VioX5+w54SXFGLWK01ZhrnzJqVnSoO0DRV+WqovqdQS5MCpYOtKKZtB8msigd9ny3zXV/KEiFRe/3iTmIwFY5MydqX2R8nLMhX9d6aNb1uuxzFkqrNYvrWXF3MvAHb28+XuFfGFzMdgWo3XPCMO1SNz05HnH9owmRUH0LXOd52/nSukAoixTD/8OtD9t7u5NU2jhIVc6V39VDvZEL02uRc5trayypFcnb8LJ+d0TFQI4420DrFLX1TQq3u32lDCyJ0r3zvZj6uyUH1yepidQVw2zp2W6HMsEDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3WTP8C2AMSk2Xq/uodawgrOwf+5/HLYrlO/lQcNdWuI=;
 b=TK1fejwumassI6It0aCGGSEFXa6sGa8thBmfs8I+LAFbnV0mo5+IaX11qUocwIv7fuXt6owF6gmEWlOCFAqcpyDsgRT3QgRNuk6k//jh8T8hKhFTTyewV4TEvVvHV35SEvST8AXGvZEV89KGcrwF6v5rhGJ2qGxOhJTROJ3aiHc=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (2603:10b6:208:163::15)
 by MN2PR18MB3575.namprd18.prod.outlook.com (2603:10b6:208:26f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Mon, 16 Nov
 2020 19:48:41 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::ec13:dcaa:6533:c2fa]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::ec13:dcaa:6533:c2fa%4]) with mapi id 15.20.3564.028; Mon, 16 Nov 2020
 19:48:41 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Michal.Kalderon@cavium.com" <Michal.Kalderon@cavium.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH net] qed: fix error return code in
 qed_iwarp_ll2_start()
Thread-Topic: [EXT] [PATCH net] qed: fix error return code in
 qed_iwarp_ll2_start()
Thread-Index: AQHWvBkzDchIUpfrckW+tkNp0UefRqnLKq1Q
Date:   Mon, 16 Nov 2020 19:48:41 +0000
Message-ID: <MN2PR18MB31826BF70A73AA243121013FA1E30@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <1605532033-27373-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1605532033-27373-1-git-send-email-zhangchangzhong@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [46.116.48.102]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68ad80ef-2df3-4b22-886b-08d88a689e94
x-ms-traffictypediagnostic: MN2PR18MB3575:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3575C1763ABC137CE5B58E73A1E30@MN2PR18MB3575.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YvVlK7tJquaG334EaV7pexVlfSki8C4rslccVSjNZunMh1SjZ1hA7uMsQtPksgft8z82caUF7/MHxMlX1veTpHjwaDWDDOTjwY1WUHy0QcCi3cmqyWL+5VPG4E50tsYEXUtqSwMbM8moLatE7XOnw9L2AiXiKRb63CZMbLUeKzxDhMURja3rqXGLATy+6Wey7Q93a/gl7HcbzD3DkUAlrtIOG/aquh+SO8kkYbdzrdMvuQ/Erq4k5MGo/xNC/hu2+jdOk+46t4ltLhwzvKm6eKKIvnYmuUZOSElq9FhrXIfjsxGIlgd0R4dvwyW5XbAQX86kqPGi/JClyltDfvYSug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB3182.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(86362001)(6506007)(54906003)(66446008)(64756008)(8676002)(110136005)(316002)(66946007)(66556008)(4326008)(66476007)(55016002)(76116006)(33656002)(52536014)(7696005)(8936002)(2906002)(26005)(186003)(478600001)(71200400001)(9686003)(5660300002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: eGOjX/OVafr7Zo8J/H0fUT41/nfnata/Usxu/LaapDzgWo2Qi5Jg0P/sL065XfjMaeemkxBzQZRx9UusnrFoS5Nxni9Bd5+hqmZb4QkEPkr6eWKQ+frkjunhx8woC91R8QpPGsyG/6edDZbhDGtsdzU2IxC/EiTA7/hffZUo0kzPJelylH3mC08aEnuJxeekBSAvBqx2hq0uEcziEeJK4QK51r4QZQj+IKY0Z8OXD2Flk0KMdKOngEwXAR4ogt8q+PLyubq8Q+nD5L8c+rGMu4OBHPRhLG/GiAUzs2balQpJn8PlfahM0C4K2UurL83COamKf92UEww+9hR00nEc6zpihB1/bBKLqqyASGDf7qgXHsqnbEQY3rpOuO/+ZrNdOxXcIZXDIYL4nGFEzg8tQJD1UWhfQPQ5jVcLYNwSwhIqxhudRU1KjskKI/5sZomPWgLUdN5K4F1BVHdIiBAzyxgo12iLvO9b6mn28aO5iZBuUSh0aSIyZdgQkSFMmvmK/It2OAqv0+F1eE/diA+imWer0nyQhoxxZ3b7+F536B7D3hpx/r3myERrp4Rc2/9on7o+hlWs0FPkXKzwMRQX+WkPNgytEQOwAdZCjLC67ZftaNCtlV5XTqj78BZfCVPfL94Y6Xka1eXHpLnjIbCKoXYr2O+HvBK53DoxMQzrh9tcMp3E+fDzI4uXnwnwVooHuRJ71xcFh7qA5YchxUQVJKxR7lxsGzN7T7igtq5MTmolH2Om5mL+owWKIHIHM2c9vq2Edb/dMAAjR8T3nGkAMiyXkbLwNWGMhsdUqil6G9VwUE8eyZ6OtqhcXR6wQTHIqVaZdbsGRrE3mp6kF6XgAMr8bT9ATZtiKeDkdJhdNR6Bidvs1wLhJIvgVn3ekscIWsBXbLcPTWw/5p5Z/qkNUw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR18MB3182.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68ad80ef-2df3-4b22-886b-08d88a689e94
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2020 19:48:41.2632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: StXLEAdLxq8DbvYYbDv7LR4EPYeu7zUcrrTEEf569TQ9e9LJujkiD9nfxtRV9BJXQstGUWFVVmBrvvYFK5lZaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3575
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_09:2020-11-13,2020-11-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Zhang Changzhong <zhangchangzhong@huawei.com>
> Sent: Monday, November 16, 2020 3:07 PM
>=20
> ----------------------------------------------------------------------
> Fix to return a negative error code from the error handling case instead =
of 0,
> as done elsewhere in this function.
>=20
> Fixes: 469981b17a4f ("qed: Add unaligned and packed packet processing")
> Fixes: fcb39f6c10b2 ("qed: Add mpa buffer descriptors for storing and
> processing mpa fpdus")
> Fixes: 1e28eaad07ea ("qed: Add iWARP support for fpdu spanned over more
> than two tcp packets")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> index 512cbef..a998611 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> @@ -2754,14 +2754,18 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
>  	iwarp_info->partial_fpdus =3D kcalloc((u16)p_hwfn->p_rdma_info-
> >num_qps,
>  					    sizeof(*iwarp_info->partial_fpdus),
>  					    GFP_KERNEL);
> -	if (!iwarp_info->partial_fpdus)
> +	if (!iwarp_info->partial_fpdus) {
> +		rc =3D -ENOMEM;
>  		goto err;
> +	}
>=20
>  	iwarp_info->max_num_partial_fpdus =3D (u16)p_hwfn->p_rdma_info-
> >num_qps;
>=20
>  	iwarp_info->mpa_intermediate_buf =3D kzalloc(buff_size,
> GFP_KERNEL);
> -	if (!iwarp_info->mpa_intermediate_buf)
> +	if (!iwarp_info->mpa_intermediate_buf) {
> +		rc =3D -ENOMEM;
>  		goto err;
> +	}
>=20
>  	/* The mpa_bufs array serves for pending RX packets received on
> the
>  	 * mpa ll2 that don't have place on the tx ring and require later @@ -
> 2771,8 +2775,10 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
>  	iwarp_info->mpa_bufs =3D kcalloc(data.input.rx_num_desc,
>  				       sizeof(*iwarp_info->mpa_bufs),
>  				       GFP_KERNEL);
> -	if (!iwarp_info->mpa_bufs)
> +	if (!iwarp_info->mpa_bufs) {
> +		rc =3D -ENOMEM;
>  		goto err;
> +	}
>=20
>  	INIT_LIST_HEAD(&iwarp_info->mpa_buf_pending_list);
>  	INIT_LIST_HEAD(&iwarp_info->mpa_buf_list);
> --
> 2.9.5

Thanks,=A0

Acked-by: Michal Kalderon=A0<michal.kalderon@marvell.com>


