Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C48E1B00EC
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 07:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgDTFMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 01:12:03 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35808 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725710AbgDTFMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 01:12:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03K5BPDZ026140;
        Sun, 19 Apr 2020 22:11:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=Tzbd1D6ra7UcjlsDVBlFv2vsJBrgSNkjZ9HMsTrz4Ww=;
 b=ctodHb9Pq0o7Bpm+UCdXHwsMC5YfA1xH/VK88AyqHc6+wX7iaP9h8OuudcKgnSNmf38i
 iEiSca7BXGfbkh6kzESF9JW1mWZChN+2uij/CCifcm6PvgzIsYFy/QcE/UUXcWeV1xGg
 gNpzS+oaeFFqtYsAOvI++yk71yGAgtidDtOKUdxf4ZV6JcRw30oOTuOHOweoAx1UZKYR
 7HIpvtaZk93JOB8jH49tFU9bTbb529k+jA14KSlwv52+E0uPIR5ZeEGjjcbPkd5UauMp
 4XAR7a5jtnjFIjI+3+qQtrWD6LWtxII5/Z8J+5Ev+GQ9BOzQHNT1ogyZd1EOA74pcdSN 6Q== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 30fxwp5u1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 19 Apr 2020 22:11:58 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 19 Apr
 2020 22:11:57 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 19 Apr
 2020 22:11:56 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.52) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 19 Apr 2020 22:11:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOihqAtTujCq/1M11IjqERIPwYJHcXG5rbJt0liNITpkQG/WyWZILGqJJUExPEC+I1Iatbe1gUYbxLFf5Aqlsb8cTonGAX7ibbpSxeFrZwMah5W/Aj2Tk28XKIPkqQXVaDoJ2djYY7OemWgQEgyxtaSFNwVB2Q82oPcmuE6n0r7DSUaLsEPM1po2h+6sGWSzB9DiK/WgSlmems9Vk0pBNREsx9GHieCdPsfIQxA0V3pc03WJioj254a3+M5YdSiBgqARAFfR6yXXFdaYJWiW0WLSXYvhAPwkDqxYAUU16FDAirKty5I1117LVi7UZR7kmPcjB4uekQR+3NUM0jfHiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tzbd1D6ra7UcjlsDVBlFv2vsJBrgSNkjZ9HMsTrz4Ww=;
 b=fI4rdxBtW+wD7PU9WxbzGrIWcbMrQeyak84NoOwzbsgwOVego07n2v9tT4rZUN+4wFY9HfH4eVh/uthAotYxz/g16OOc6eeBhevbuitiswhzcPJZ/E5I5qsgq2ofBrQGRCPew6qD0oz0A1gwQ8VabgTCbvBu+IoSKaSq7aUzW4L7fNiLuXAaDq0JuGTD6luTyfyCHMIutvdkopFlVQSrxZCG14qayae668KhedENrrbu25Og/nVraF3MQ7GFtBoOZRJtBOrein2k7aSNG9Nw4V2uPuurBFq/XhOJWTcl1RXcqIvhp0saHCfDm/YuQEodN7R7Dk+Whi4h4nFd/JGZdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tzbd1D6ra7UcjlsDVBlFv2vsJBrgSNkjZ9HMsTrz4Ww=;
 b=OVNd/87Sb83euSSK/Qo4CfylZ2o1DS69NPgZoV0XTuHiWmZBpwpws4MwKjwGV9Dos37FEL4+Al5u8uAhKJKNvqDvsMYp+iVFvHjJXUUaWLR7pHe6zb+UtoovXAQdy0Sco0QkBZkMEABrC7QO4hb0AoD+pXxV6KuF4sOgq58cygA=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (2603:10b6:208:163::15)
 by MN2PR18MB2480.namprd18.prod.outlook.com (2603:10b6:208:100::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 05:11:55 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::71dc:797b:941a:9032]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::71dc:797b:941a:9032%3]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 05:11:55 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] net: qed: Remove unneeded cast from memory
 allocation
Thread-Topic: [EXT] [PATCH] net: qed: Remove unneeded cast from memory
 allocation
Thread-Index: AQHWFmwoeqWB1WncF0miF4Eo8ULEd6iBd3iQ
Date:   Mon, 20 Apr 2020 05:11:54 +0000
Message-ID: <MN2PR18MB318225752E61524F09CE1331A1D40@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20200419162917.23030-1-aishwaryarj100@gmail.com>
In-Reply-To: <20200419162917.23030-1-aishwaryarj100@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [109.64.70.43]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6fc88e6-6a7e-4417-a073-08d7e4e95802
x-ms-traffictypediagnostic: MN2PR18MB2480:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB2480E40A590FE42BA373D48AA1D40@MN2PR18MB2480.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1013;
x-forefront-prvs: 03793408BA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB3182.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(39850400004)(136003)(376002)(366004)(346002)(86362001)(26005)(71200400001)(55016002)(186003)(2906002)(6506007)(5660300002)(64756008)(478600001)(8936002)(9686003)(66556008)(110136005)(66946007)(52536014)(81156014)(33656002)(8676002)(76116006)(316002)(7696005)(66446008)(66476007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dp8RI4VAR5vN5thsc0QqrWvRsEIAMiW1dNz+4KuIZ6etHFbbMGEshT83vUpB647Ks4UC7ut9lzTFhB2BOLOvtchXK0xYaQOhYb/Tr1DFnY+Mwo5L3OSXMR/yqkSdKlZMzVg51zAQMZ6vPDuXbicjRVk41R5h5AR8U2vBZrtDJcqkqjKz2g7KP3q1MSkYsRqAFWevefw4MkPPvV2FGdR7CUD2/4eH1jBM+vDvroN9C89oD/yUI4RJ6LRN9oBquO7ySUWX0lAG7IWn0z7+PeSvCgt3aWAhgNpTAo5IiHKIj3z241AqLlYyumXPMFXORcAwxUDDVsWjpWpUPL9IYkPQCp5b0vPJmbltYeRtaeDlYqxgY4yVgev/OzsPp3p2QiPflVsx9TtridkjfBayrVhRQ+qHlcuhv69sivAPka2aw0Vvx7zrMBV2eylsgiLAwJZQ
x-ms-exchange-antispam-messagedata: DR5IarunLr05J2wb/pJddqjK+ynhEATrap9yMXl1ztlx1ri0KO7TU88/lqHjNu1PQKEan80uA93Y/cnT7v20S096lbQzX74A4yn2QESHPLrgQMyrYcP02xk6ngan04cVAlEUpUTQdedeNzjB8aTA/w==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f6fc88e6-6a7e-4417-a073-08d7e4e95802
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2020 05:11:55.0055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N4qL+EFE/Hg+UF4Y0x6dJxk0amQYHlaaBlFTH1U9pcftHaPy3ggNdCjdEM6BNYU1BSgxJGOpG9PcN5mWnXysIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2480
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_01:2020-04-17,2020-04-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>
> Sent: Sunday, April 19, 2020 7:29 PM
>=20
> ----------------------------------------------------------------------
> Remove casting the values returned by memory allocation function.
>=20
> Coccinelle emits WARNING: casting value returned by memory allocation
> function to struct pointer is useless.
>=20
> This issue was detected by using the Coccinelle.
>=20
> Signed-off-by: Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_roce.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c
> b/drivers/net/ethernet/qlogic/qed/qed_roce.c
> index 37e70562a964..475b89903f46 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
> @@ -736,9 +736,9 @@ static int qed_roce_sp_destroy_qp_responder(struct
> qed_hwfn *p_hwfn,
>=20
>  	p_ramrod =3D &p_ent->ramrod.roce_destroy_qp_resp;
>=20
> -	p_ramrod_res =3D (struct roce_destroy_qp_resp_output_params *)
> -	    dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
> sizeof(*p_ramrod_res),
> -			       &ramrod_res_phys, GFP_KERNEL);
> +	p_ramrod_res =3D dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
> +					  sizeof(*p_ramrod_res),
> +					  &ramrod_res_phys, GFP_KERNEL);
>=20
>  	if (!p_ramrod_res) {
>  		rc =3D -ENOMEM;
> @@ -872,10 +872,10 @@ int qed_roce_query_qp(struct qed_hwfn
> *p_hwfn,
>  	}
>=20
>  	/* Send a query responder ramrod to FW to get RQ-PSN and state */
> -	p_resp_ramrod_res =3D (struct roce_query_qp_resp_output_params
> *)
> -	    dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
> -			       sizeof(*p_resp_ramrod_res),
> -			       &resp_ramrod_res_phys, GFP_KERNEL);
> +	p_resp_ramrod_res =3D
> +		dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
> +				   sizeof(*p_resp_ramrod_res),
> +				   &resp_ramrod_res_phys, GFP_KERNEL);
>  	if (!p_resp_ramrod_res) {
>  		DP_NOTICE(p_hwfn,
>  			  "qed query qp failed: cannot allocate memory
> (ramrod)\n"); @@ -920,8 +920,7 @@ int qed_roce_query_qp(struct
> qed_hwfn *p_hwfn,
>  	}
>=20
>  	/* Send a query requester ramrod to FW to get SQ-PSN and state */
> -	p_req_ramrod_res =3D (struct roce_query_qp_req_output_params *)
> -			   dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
> +	p_req_ramrod_res =3D dma_alloc_coherent(&p_hwfn->cdev->pdev-
> >dev,
>  					      sizeof(*p_req_ramrod_res),
>  					      &req_ramrod_res_phys,
>  					      GFP_KERNEL);
> --
> 2.17.1

Thanks,=A0

Acked-by: Michal Kalderon=A0<michal.kalderon@marvell.com>


