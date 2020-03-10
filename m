Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0857180411
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 17:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgCJQ4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 12:56:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41510 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726998AbgCJQ4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 12:56:25 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AGrvsO016244;
        Tue, 10 Mar 2020 09:56:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=4FqdoVDAWXWzT2kf7OHyUAIhfefw+sexNQl+l4OmRrc=;
 b=aiD4RqdIDfsuWy1dS9HdqmBXOOhPPvznP07LCX/jMr4khbC4HkYsBvaAy3/lTUxnDQep
 FiBR429FvcnsxjZfgQDAp2s48Fwxi+MlHAaJZiPkxhr2+mefcxVAZtbsDvgUUxurnI1A
 Lkg/CgP4r5T88do9K3+Fcyvnm2sraZgahaT0upZyIYrVJN6AVSK7qLDcQy1FtRiSkmR2
 ZIji1CRF1ah38EZIeViFVtZSoIBky0auklNF0pm7ICjGjOD3XdENMN4yUzkM7y+8+DCL
 0A0QJHC1Dl9HLdV2AEneRgHuhGuTZtm/SEjZ7xEcu0dYsFsmoR+4i8tXAoj54QJ7tUJg hQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2yp04fmmv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 09:56:04 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Mar
 2020 09:56:02 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Mar
 2020 09:56:01 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.56) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 10 Mar 2020 09:56:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCjo5cJW+XVyKxkX6MKnGDUXIzWeC/aVeK3jDdXzjA1e0hpBXZVNtcTCnRHQVolCTVRSRTzblIRn26Y4vnOPha5tPho3kEejYWvkXPRx4mCDHQn2A8xZdo6u2N4CgBr1ctKDpqYOkjaDAVEOKC5eOrgdLypyIjIbx++C5A8UMo0N5RnZ1zFuGSBk6E+1fqXrNKIOkosPwFIPWC+Myd77OJm5AW9Luv5UM9Jh99JhfUqc/KW6Zg73TvljvuljkFAWLezBWYTkCRHd6alI9h86mEbRI/sTSRPZEZa449sx7VHG2BDHxHmDY1HAAAYQMGwjNebeJaBCaCeg6Mef/YthSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FqdoVDAWXWzT2kf7OHyUAIhfefw+sexNQl+l4OmRrc=;
 b=AzK8szNPQOIu+TeAn7xPfFYLNY3089udZ6bk8ePZ5qG1NvknrQMcuc6x8Y6Ql7RqNlEGVe94EvPsRzU2+6VFN/eKBj6jyu94+SqSP97o+3s3WEHQnTOCn1RN4+33e8J3970KU3VA+3/8PtAzEbm80GEEl7jUy4lqQm74VNsY6WZVNkDdbrYGoxcW1MF0FJf65x5V/7WKK/I+Op9UDJz/esLnty+wM96ImZo/cdIL41gid4cC5VYJoYXBY5p/1yz6xyG+265SGH1Ty8W+FVLFCZ6Q9MtIJU+0DrFuXtU/kIaDNmEyOaxkwbH9ak9Ks/D9qfmnoq8GNRv6WXRuNXyvLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FqdoVDAWXWzT2kf7OHyUAIhfefw+sexNQl+l4OmRrc=;
 b=B0S7ZM9aSnBgBwwUJuL0oHW0K+cHUJICz5kvCpLDFVvmtvtoeNRCRO22KFCpvwbB6vAnwL6cXqKzhtqtIr6ZIL02xPq0nEFG4hb4DR8nEBjtu2tHljXEj7KFLmr5lujx/H8TAlz7ZRHjFAOl2EBgqhYZoUCRRln2hIqgtnZi1ss=
Received: from BN8PR18MB2418.namprd18.prod.outlook.com (2603:10b6:408:9d::14)
 by BN8PR18MB2772.namprd18.prod.outlook.com (2603:10b6:408:76::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16; Tue, 10 Mar
 2020 16:55:59 +0000
Received: from BN8PR18MB2418.namprd18.prod.outlook.com
 ([fe80::dd22:2e6d:b536:8aab]) by BN8PR18MB2418.namprd18.prod.outlook.com
 ([fe80::dd22:2e6d:b536:8aab%3]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 16:55:59 +0000
From:   Derek Chickles <dchickles@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "akiyano@amazon.com" <akiyano@amazon.com>,
        "netanel@amazon.com" <netanel@amazon.com>,
        "gtzalik@amazon.com" <gtzalik@amazon.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Rasesh Mody <rmody@marvell.com>,
        GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "opendmb@gmail.com" <opendmb@gmail.com>,
        "siva.kallam@broadcom.com" <siva.kallam@broadcom.com>,
        "prashant@broadcom.com" <prashant@broadcom.com>,
        "mchan@broadcom.com" <mchan@broadcom.com>,
        Satananda Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "tariqt@mellanox.com" <tariqt@mellanox.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "leedom@chelsio.com" <leedom@chelsio.com>,
        "ulli.kroll@googlemail.com" <ulli.kroll@googlemail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: RE: [PATCH net-next 09/15] net: liquidio: reject unsupported
 coalescing params
Thread-Topic: [PATCH net-next 09/15] net: liquidio: reject unsupported
 coalescing params
Thread-Index: AdX2/KOUS03+DnwpRHSb/e+Hto1QPA==
Date:   Tue, 10 Mar 2020 16:55:58 +0000
Message-ID: <BN8PR18MB24183949419791FFC339B608ACFF0@BN8PR18MB2418.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.233.58.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 543acb3c-d8aa-4e78-4676-08d7c513e873
x-ms-traffictypediagnostic: BN8PR18MB2772:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR18MB2772A30019E20073B1B6A1C9ACFF0@BN8PR18MB2772.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 033857D0BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(189003)(199004)(7416002)(7696005)(54906003)(316002)(186003)(26005)(110136005)(6506007)(53546011)(8936002)(52536014)(9686003)(55016002)(33656002)(8676002)(86362001)(71200400001)(66446008)(64756008)(66556008)(2906002)(81166006)(5660300002)(4326008)(66946007)(76116006)(66476007)(81156014)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR18MB2772;H:BN8PR18MB2418.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z7H7j7RJvwJBVvT03t2vNBKN6BCm5oGhDbrYsywq4aWSwCnAxWxvZpVgs7MH2T2EkjRcCaLanCxp1RDNG6lH4Y+1SH9C9XhwY7mq8Qf0Xgg92BEhDlZrMogBvHJAUYMHCkFpoQjr3UD+6Mv7e3zCEPLBaWJpQpqc6LAJynxR2yVgC+uJ3kR1R+rcu2p8YtD2J41uDhQbXfIj34ztQxG0RBi6zniNdubXjZ/qxcaK6dSKXEGRhBjW08XkFwSasRQrNs8jWluu9InLVuzeg01WoizOscB6mVLPwJLvkzRQwAsHU/Wc6VYpYnRJsFOEWhX4vudlwxtYpMmtfsgvNVCWY9wMtQsfMoikAOXkOm6XVnfqid2aRv05+fqyjJPEthcECsANPSdHFUhzRO4KjrUNMzrC+GfcXVJWV6JMREOhSsrEinqc8FLDOHUxfErFzx7F
x-ms-exchange-antispam-messagedata: NRnc9McCdvg0/b0fMrawvPhBjepI6qz3C3FwUjqYRwbH9kSXJ1TiEd+GMiLr1BOQEvzBp2DpEwqOMtfp7DWp4fdN53CoO/kakvIklyeBo8TD8Af1qg/IaTItvh3GfFWwXhxlhdPEjKpBhzdG+KM0dA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 543acb3c-d8aa-4e78-4676-08d7c513e873
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2020 16:55:58.8845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eqVqdOh2PwCVmnZ4IWGG1OgPBjssu5SvEzH0LDeRqUdHg8VDlIjhYB1IZdLkbOnpDbZvUX62jngsCyvWgY4mwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR18MB2772
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_11:2020-03-10,2020-03-10 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, March 9, 2020 7:15 PM
> Subject: [EXT] [PATCH net-next 09/15] net: liquidio: reject unsupported
> coalescing params
>=20
> ----------------------------------------------------------------------
> Set ethtool_ops->supported_coalesce_params to let the core reject
> unsupported coalescing parameters.
>=20
> This driver did not previously reject unsupported parameters.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/cavium/liquidio/lio_ethtool.c | 11 +++++++++++
>  include/linux/ethtool.h                            |  5 +++++
>  2 files changed, 16 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
> b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
> index 2b27e3aad9db..16eebfc52109 100644
> --- a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
> +++ b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
> @@ -3097,7 +3097,17 @@ static int lio_set_fecparam(struct net_device
> *netdev,
>  	return 0;
>  }
>=20
> +#define LIO_ETHTOOL_COALESCE	(ETHTOOL_COALESCE_RX_USECS |
> 		\
> +				 ETHTOOL_COALESCE_MAX_FRAMES |
> 	\
> +				 ETHTOOL_COALESCE_USE_ADAPTIVE |	\
> +				 ETHTOOL_COALESCE_RX_MAX_FRAMES_LOW
> |	\
> +				 ETHTOOL_COALESCE_TX_MAX_FRAMES_LOW
> |	\
> +				 ETHTOOL_COALESCE_RX_MAX_FRAMES_HIGH
> |	\
> +				 ETHTOOL_COALESCE_TX_MAX_FRAMES_HIGH
> |	\
> +				 ETHTOOL_COALESCE_PKT_RATE_RX_USECS)
> +
>  static const struct ethtool_ops lio_ethtool_ops =3D {
> +	.supported_coalesce_params =3D LIO_ETHTOOL_COALESCE,
>  	.get_link_ksettings	=3D lio_get_link_ksettings,
>  	.set_link_ksettings	=3D lio_set_link_ksettings,
>  	.get_fecparam		=3D lio_get_fecparam,
> @@ -3128,6 +3138,7 @@ static const struct ethtool_ops lio_ethtool_ops =3D=
 {  };
>=20
>  static const struct ethtool_ops lio_vf_ethtool_ops =3D {
> +	.supported_coalesce_params =3D LIO_ETHTOOL_COALESCE,
>  	.get_link_ksettings	=3D lio_get_link_ksettings,
>  	.get_link		=3D ethtool_op_get_link,
>  	.get_drvinfo		=3D lio_get_vf_drvinfo,
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h index
> e464c946bca4..9efeebde3514 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -211,6 +211,11 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32
> *legacy_u32,
>  	 ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ)
>  #define ETHTOOL_COALESCE_USE_ADAPTIVE
> 	\
>  	(ETHTOOL_COALESCE_USE_ADAPTIVE_RX |
> ETHTOOL_COALESCE_USE_ADAPTIVE_TX)
> +#define ETHTOOL_COALESCE_PKT_RATE_RX_USECS
> 	\
> +	(ETHTOOL_COALESCE_USE_ADAPTIVE_RX |
> 	\
> +	 ETHTOOL_COALESCE_RX_USECS_LOW |
> ETHTOOL_COALESCE_RX_USECS_HIGH | \
> +	 ETHTOOL_COALESCE_PKT_RATE_LOW |
> ETHTOOL_COALESCE_PKT_RATE_HIGH | \
> +	 ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL)
>=20
>  /**
>   * struct ethtool_ops - optional netdev operations
> --
> 2.24.1

Acked-by: Derek Chickles <dchickles@marvell.com>
