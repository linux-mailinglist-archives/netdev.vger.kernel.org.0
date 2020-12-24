Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D822A2E25FB
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 11:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgLXKrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 05:47:32 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45520 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726186AbgLXKrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 05:47:31 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BOAj3Rm032495;
        Thu, 24 Dec 2020 02:46:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=GtLv6TusbvO5LDFWBLiQGu1GraHpPqeFVp5E/UwO68g=;
 b=CiRKspSTNsKZXfnyFSSejRlJYh4LTL2Dcq2kWUeUHUX13gD9p91L1AI4bbHExSj1REl0
 1HpDJDA6TAfVu7Uf4tkKfYOmkMeeKvebJv1AviJ67WhdjCcNTBObTXgzOoe7IuaKs7+P
 yHJnBNTf18P6duDXjH++MW0hDX5N6epn1WyY3wfyHkaqYmt2uguw7VtmGR3yEQ1QXmsU
 LZlPEvBAXGFjJLhrx5ksQQ7ytjQDEAZAupC/Q3CRqRCFNoW+wVsHJNBykG310zwQlNy5
 SNIzybaJPqFBZhdGZ349KyhXyHq/5Lm8OOxDy9lBdVyVy/3gTW1Pc77pxnS1Y8N4LZgc sw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 35k0ebgjq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 24 Dec 2020 02:46:49 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 24 Dec
 2020 02:46:48 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 24 Dec 2020 02:46:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQDba2dujOrciz3g2G9YGpW8BVKVqypmpHg7PDCbLBQcXDjfCfQJ1Z7X994QRggYOd/bQEDXe28rYqmBs62ijHD0EYffYP1RZUeGVVbDJyxZY7h42KxYJjxr8mhoQn+6oopDNMLezm0OOtGHckPaMvNmbCgsoOpErn/hfEgoSyMTJO4YJ7Yjzuk6nQKeLIAo2PedX+5HU/rqHdacwYoByzOMweWYdvDOTD9stjolpbc6f763onMjv2/2o5Zbi1jJAlud6jbYget3Kz0K2hj3DfmU+nXZl2EfovejsuvLmPl2OZIadv+GqpThhAZW5pFCZ/JcoMvsugRRD0fyMWGc1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GtLv6TusbvO5LDFWBLiQGu1GraHpPqeFVp5E/UwO68g=;
 b=LKhUdvyDW3/o+dSAq4CnSYp/cj8Ribj2r5IZwWEEDJymGTufzmeKRSooRdl3WLl+x8c01HP0V7B1rUyedlN32D06GsfwabZf4Cglmm+pFfkx5Rrlsa/QxzSzEWhagIcdUDsHrHG1oIuSf1JYZjBhWw+QSADHFV+dlZP3PQSVNEOmx/QsgGKx2BculcxGvocvYp14ZMt/KVqf/E5pps02D5tyhhGJbxXI1gfgx2JwborRZjQANO5/Ii3XG0qTEsBHVfnC+7d3GfM5N4E2ugjyYhCV1Mk78Rcv3a5K1O3JtiLmQN2aNeaRKAcDh/QCDu/rrCNWFtn7n//7/j6R7u1qww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GtLv6TusbvO5LDFWBLiQGu1GraHpPqeFVp5E/UwO68g=;
 b=Tt7fRPwN2AzLyZ9QtA1hh6sGBYopGSBAELAPj7ZPVrrYUPe40QLQIbnn5m5QvBSBmbdMfE2xRxecvHDZVuRX8JMZpB36KHDqnOvNhXrtrwqeQCofD1LkgiIsLfquBP9/bu6ty55KuTdfP0cihklr9RnBCF26vA7L2sS+UHqxMJc=
Received: from DM6PR18MB3388.namprd18.prod.outlook.com (2603:10b6:5:1cc::13)
 by DM5PR1801MB1900.namprd18.prod.outlook.com (2603:10b6:4:63::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.28; Thu, 24 Dec
 2020 10:46:47 +0000
Received: from DM6PR18MB3388.namprd18.prod.outlook.com
 ([fe80::1858:4cd6:3415:70a1]) by DM6PR18MB3388.namprd18.prod.outlook.com
 ([fe80::1858:4cd6:3415:70a1%5]) with mapi id 15.20.3676.033; Thu, 24 Dec 2020
 10:46:47 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "Sudarsana Reddy Kalluru" <skalluru@marvell.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH net 1/1] qede: fix offload for IPIP tunnel packets
Thread-Topic: [PATCH net 1/1] qede: fix offload for IPIP tunnel packets
Thread-Index: AQHW16nkvyK75euxski7nCUl8pb7fqoGEkaA
Date:   Thu, 24 Dec 2020 10:46:47 +0000
Message-ID: <DM6PR18MB33885269B2564DE156996AF4ABDD0@DM6PR18MB3388.namprd18.prod.outlook.com>
References: <20201221145530.7771-1-manishc@marvell.com>
In-Reply-To: <20201221145530.7771-1-manishc@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2405:205:1181:c1f1:780c:ccd1:393c:ce9f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69b15c6e-c7dc-45e9-409c-08d8a7f93691
x-ms-traffictypediagnostic: DM5PR1801MB1900:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1801MB1900DE58EFB428E5E8328AD4ABDD1@DM5PR1801MB1900.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A8PQlLku1Gxcs+2q/hWBY+tmVDn50W/4VNLA3O3EN1Ds/OeO697oCS+6eaGXA8jMTZ93WosLYZDgKS2nfhA7NJysgx0/mY6Qt6ssWx4qZfELcilCWnWAE4MlCs/WtlbXBi7eyP+xkEuFRqGRna4Gk5zFXu2aA3wc15unFBE86b0YJVuTFiXDGYep/gt+VQb/HE+oKUSh/ql6Nm6zLtZQpQ4fpy0ACVJEmGlSGow/rNf222U1cUycA3meTv3ixSBq85Ubeq6/LU4hnaU/oO3roEY53OQadbCinEaJrtyXHQVfb2xC2CUyQvvA6JnEtIo2pynFPfogurJw6dlaB2REbetewBpwhzS2ZmCLzQ8GbrxDU1moNOQ4jlh3rLE6u6xqIWdqxsWZSZpcVPrcMakfwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3388.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(366004)(346002)(66476007)(4326008)(66556008)(64756008)(8676002)(66446008)(33656002)(8936002)(186003)(6506007)(5660300002)(53546011)(7696005)(55016002)(9686003)(54906003)(6916009)(52536014)(316002)(2906002)(86362001)(83380400001)(71200400001)(478600001)(76116006)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?zwyGIa/iB+kxQbnuZHMmCAXXJfA0Xs7zbZhzdmnKzHPa7SFDq1WgiTiGtQUV?=
 =?us-ascii?Q?TRExvd72QU6nbP1KiIHEpm3ry2Xq3NiyFB4wGLLeS6xNiV0DI5LMqAEqW7El?=
 =?us-ascii?Q?NP7zbtUlrGPTbx5HV1+fbk0MEeG5YPParJ8UiJX472ZPQ2O9tanjCE98ZRat?=
 =?us-ascii?Q?b4+fu2tSRBfndGaf3NGhVu6Z7oGRZdWGTxRA0XztG8SPN3eMUWsu1Q3xYkBG?=
 =?us-ascii?Q?yLg2fsO1GODsW7N9oeldfvMaqm8MmhglV/os+NI/8sJAPchWorBrl/smP2Fe?=
 =?us-ascii?Q?Jybf+C/XSiwCwUoWLaFmQWqJKNUbzr1K98Vf+k2peZGXfqmLZABCws2PLEmR?=
 =?us-ascii?Q?iT9kDQ2OgmYNQZt6MjtZYhLsDU7GtA4GzrtswJ2qEwG7l4C5b0dn9FNLAQKB?=
 =?us-ascii?Q?UfJWbqzs32M/5iWp/mZQlWo9iqbYB0ZAzjxBxjc6SGHigFTNbZpZUgboWuqK?=
 =?us-ascii?Q?NbV8LdxMaicakUa40QGVKPTjuxdg9lCWC9kxhB5+d2zouI1Y3tx6hQIEGtc8?=
 =?us-ascii?Q?k5gD1/5SjmJmHHoNx9BItoUGndggl1001MQ8txWW4SD1sy2o6TXfanxy5kDm?=
 =?us-ascii?Q?anziiiHcRe6BBCm0lnzuzRFQ7NyV8YerGT9GVJWyOFp7xuba0+moyx2ZeEXN?=
 =?us-ascii?Q?2Zwgs5CZdThkGT/spc311y3s0Reue2zyHCyfBPOEyJ++fGzLQ4iFoz/lsVxT?=
 =?us-ascii?Q?bhTUaztPwoTDvtpTOm3YofhayND/pWC+d5QFnoIhS2XZ25TNFOVbE2kGTxZC?=
 =?us-ascii?Q?S0xgBGRGDL3G/D0DpZRWqZ/uWRe8Crip1uKUYDSzcG9EaRtJbeTJZyzGnsGL?=
 =?us-ascii?Q?WGlbGdMOmWFxE9I3bakm91sMifyVHyqgPaL4PGrjHelduSbc8MOwYRmsghze?=
 =?us-ascii?Q?zHGIFsyEZvngaNi+IVkULM5G9gbnRXyLN0+1RRosz2a4rFslg5m/KtDU5NWp?=
 =?us-ascii?Q?S8tg8FfFGwp0xTbesqo3NG8bO/BRnkIPUQgEDVuGfMRKXVrpbZ7RmQ4++3q8?=
 =?us-ascii?Q?U/fdWGMjhiESvEpGy56RN87ejIfpe0qdVDwPh6145Tfdbrk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3388.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69b15c6e-c7dc-45e9-409c-08d8a7f93691
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2020 10:46:47.5770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SRmsnTxxmCSkF2xQqBjin5piieg6NHQpgn/IiWhexO7ezeONqQjj5ZpXDwvMi9sP9ZsoUnfdjIvCWa1U/1PyrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1801MB1900
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-24_06:2020-12-24,2020-12-24 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Manish Chopra <manishc@marvell.com>
> Sent: Monday, December 21, 2020 8:26 PM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; Ariel Elior <aelior@marvell.com>; Igor Russki=
kh
> <irusskikh@marvell.com>; Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Subject: [PATCH net 1/1] qede: fix offload for IPIP tunnel packets
>=20
> IPIP tunnels packets are unknown to device, hence these packets are
> incorrectly parsed and caused the packet corruption, so disable offlods f=
or
> such packets at run time.
>=20
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> Signed-off-by: Sudarsana Kalluru <skalluru@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/qede/qede_fp.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c
> b/drivers/net/ethernet/qlogic/qede/qede_fp.c
> index a2494bf..ca0ee29 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
> +++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
> @@ -1799,6 +1799,11 @@ netdev_features_t qede_features_check(struct
> sk_buff *skb,
>  			      ntohs(udp_hdr(skb)->dest) !=3D gnv_port))
>  				return features & ~(NETIF_F_CSUM_MASK |
>  						    NETIF_F_GSO_MASK);
> +		} else if (l4_proto =3D=3D IPPROTO_IPIP) {
> +			/* IPIP tunnels are unknown to the device or at least
> unsupported natively,
> +			 * offloads for them can't be done trivially, so disable
> them for such skb.
> +			 */
> +			return features & ~(NETIF_F_CSUM_MASK |
> NETIF_F_GSO_MASK);
>  		}
>  	}
>=20
> --
> 1.8.3.1

Hello Jakub,  can you please queue up for stable releases (specifically for=
 long term linux 5.4)?

Thanks,
Manish

