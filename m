Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28771B00CD
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 06:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgDTElQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 00:41:16 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52248 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725710AbgDTElP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 00:41:15 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03K4elv4009928;
        Sun, 19 Apr 2020 21:41:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=KspSXWazjBWS+ffW0KXkn3N4rTARZBcpIS+KMtesCYM=;
 b=ll4ZP5QeHLAR9SHm+PX3z4BgWVJMEXiv395MoNNnc9qjfztICY2ZKrdMcj6ngZCNPRyW
 9GbazK3MmtVyoQ5EIWfyU3JxmvlhhcC6TQW3T9BZA6DxQHKVSqRBVMy3/XtqN8uBqEvT
 ueHKqyI6QARf97pIqCazq0wN6dFEMK1ZMHh44olpfLclPDCWfVCXDSd462PtYsyIqmY+
 FdnoRIKR2uId0c3jDFrX6XxJUw8druauL4W1NaOc8oQrQiMdDItzhuloyhWD0DqtlNh9
 MEsqKXJ2smxEmt2fj6pd1fPzNyjR8i3Bq6qx40tH9saHZSV9g3xYQ3XRNBdoBu2rLKGP Ag== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 30g12nn9yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 19 Apr 2020 21:41:07 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 19 Apr
 2020 21:41:05 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 19 Apr 2020 21:41:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mnKYpeT6e7wn4M1yTIiH4KHHv0KIAU+jRdYd0YCJ9XRO/274Z6QHUV8AcyihPpsGf3p0gkSgvDfDALTHxZ0PjtIya+xrQf6hGBIperLKincIhzQv1vTqycUHGQ9jzZvqcgp1qcSFLnZksU1XvhtGN/Q1I4AUrn2lej+991vmup3pavTo6DYFa1J82HM0FWCNihH4JboTo/4xUevTAFkRgSNDd4yaEZKcPltm9UqfzRkWqCzle7D1Qj+ZbljmuaZdMw4LSD2jkp3BnBtWP3jBQJUvIFi1S51z3rYSvWs3kU/z3pz6TcyhhVw3cDAXGuLdXMBR6AO2pG/cxCrlq1UsIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KspSXWazjBWS+ffW0KXkn3N4rTARZBcpIS+KMtesCYM=;
 b=nCc13I4YWr2HqMrW+EZyrrs3qceETC7l4BeN+mKBT2N7LKLmCbNimrveBEn040Ivyk04GCKOk8S0ctJ0LebCyYCFXevZNPb/VRckDVH3DSXU9wjtIBpkhIm/BYo8S1E5D0hw8VhJzXCT+DNQj0hOjFoCDPHZ1gvhiER+DEjT9YsOFaQAmwN2jL9Cp9F5HPN4xTmOKibKtlid51dQjtwxtZSP/8li+nG/HAg/8Kx8aApgKx+iUrWmUu2qtbd94Fm1j9iakwaTyykBkXtLH1YsOagoX6ybZPNFOYt+ljTaDYDbtJyM4V3YQUCbtnXW5EKFjApWSCD4RKMp4a4yNs2yQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KspSXWazjBWS+ffW0KXkn3N4rTARZBcpIS+KMtesCYM=;
 b=kfl5+szz+KKZ4o0eedYDbwQDr0HUCkJyOpUFzONAyBO/Q4qEcWMXVPrOKfquqK2MNWjx0UsYw3v2BPFUB37GL7gzU+CWvj9GcOR866M05Gyp+ZCOafOwytCzSjCGqf07PL9fAGvAGM+fF8u4ATnsPFk1qWeAGAvQARUj2HUBHfk=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (2603:10b6:208:163::15)
 by MN2PR18MB2494.namprd18.prod.outlook.com (2603:10b6:208:102::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 04:41:02 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::71dc:797b:941a:9032]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::71dc:797b:941a:9032%3]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 04:41:02 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Jason Yan <yanaijie@huawei.com>, Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] qed: use true,false for bool variables
Thread-Topic: [EXT] [PATCH] qed: use true,false for bool variables
Thread-Index: AQHWFshMdBvpX8m6sE6ahXBKJnXf6qiBbhow
Date:   Mon, 20 Apr 2020 04:41:02 +0000
Message-ID: <MN2PR18MB31825BA5D9769293119AB240A1D40@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20200420042720.18815-1-yanaijie@huawei.com>
In-Reply-To: <20200420042720.18815-1-yanaijie@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [109.64.70.43]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 627470f7-4e3b-4557-1fd7-08d7e4e507aa
x-ms-traffictypediagnostic: MN2PR18MB2494:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB24948D8E7B713042C1FD1B6CA1D40@MN2PR18MB2494.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 03793408BA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB3182.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(39850400004)(376002)(396003)(366004)(55016002)(9686003)(33656002)(110136005)(7696005)(26005)(316002)(2906002)(6506007)(81156014)(8676002)(66446008)(64756008)(8936002)(66476007)(66946007)(186003)(5660300002)(86362001)(478600001)(52536014)(76116006)(71200400001)(66556008)(142933001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K4wYwhiYLubXY71GiG75HL5gTAHArEyFErVcHXHqWTPmXPDiEjUkHfmLnwpdXY2R68da5mNV5/f+9vmzt3M6+8xRu3UQ5aOEC6pNCueRnTGnCyrQn0qZyiso+2fAtz1E7DQ/XZpW6fAdF2CMr7xDJa2zjI7PSGbXI7IxS+j5SrcOSd/oWrUZoptmJg1TZFG5jMQkiFn4oghE/9OT8vuJ68YzZft42crbvACVLX7uPiCfnzApvSXWKnp3mE4JapltEuNbNgC9V3KWED2LttaoCsux6f6EFFI7bC2M7FnatHYPKsIPiZGzp4l7fVwp7GIBuHt3kVtvL798ksgmAl60wZrGk8w2ysRs1cIIaDmH1fq5sXP8YWX/XlE6fP5elN6yBYQ3SM41VCmdiCuzvkGFTeFWM/RYSDYEZtrzpHvGQIF+magBxDPdshvrIcEcHbnEcwpnzNyXYXdINI2OHiHTs/enodOe9E0sbBMffWcAlUHpBHXoJuAm/bE7P7WObV9k
x-ms-exchange-antispam-messagedata: LBXi5ewW04VgnTPNcGmwZGHE1Kcfc/AMJBFWidOd7ZsmtYYpwXwlZk++KzmUt9KvNFKs4GfO14k72Go7PZY58/EAjPmenlG9vk75f5UjIRuGTGApc6UwojpSotSN44C/ABLuXgeIiJOFORCFSxQIyQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 627470f7-4e3b-4557-1fd7-08d7e4e507aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2020 04:41:02.2708
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B580cYzH87OwukS83kW4LwXr5/e1kaHL3wbJkb8ez1q3SEqq6P4ZM5hTkmCCYQTzTlzx6EB1PaDoGGvd/QUXHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2494
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_01:2020-04-17,2020-04-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Yan <yanaijie@huawei.com>
> Sent: Monday, April 20, 2020 7:27 AM
>=20
> ----------------------------------------------------------------------
> Fix the following coccicheck warning:
>=20
> drivers/net/ethernet/qlogic/qed/qed_dev.c:4395:2-34: WARNING:
> Assignment of 0/1 to bool variable
> drivers/net/ethernet/qlogic/qed/qed_dev.c:1975:2-34: WARNING:
> Assignment of 0/1 to bool variable
>=20
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_dev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c
> b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> index 38a65b984e47..7119a18af19e 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> @@ -1972,7 +1972,7 @@ static int qed_init_qm_sanity(struct qed_hwfn
> *p_hwfn)
>  		return 0;
>=20
>  	if (QED_IS_ROCE_PERSONALITY(p_hwfn)) {
> -		p_hwfn->hw_info.multi_tc_roce_en =3D 0;
> +		p_hwfn->hw_info.multi_tc_roce_en =3D false;
>  		DP_NOTICE(p_hwfn,
>  			  "multi-tc roce was disabled to reduce requested
> amount of pqs\n");
>  		if (qed_init_qm_get_num_pqs(p_hwfn) <=3D
> RESC_NUM(p_hwfn, QED_PQ)) @@ -4392,7 +4392,7 @@
> qed_get_hw_info(struct qed_hwfn *p_hwfn,
>  	}
>=20
>  	if (QED_IS_ROCE_PERSONALITY(p_hwfn))
> -		p_hwfn->hw_info.multi_tc_roce_en =3D 1;
> +		p_hwfn->hw_info.multi_tc_roce_en =3D true;
>=20
>  	p_hwfn->hw_info.num_hw_tc =3D NUM_PHYS_TCS_4PORT_K2;
>  	p_hwfn->hw_info.num_active_tc =3D 1;
> --
> 2.21.1

Thanks,=A0

Acked-by: Michal Kalderon=A0<michal.kalderon@marvell.com>


