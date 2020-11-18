Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965692B8450
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbgKRTBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:01:12 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23156 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726634AbgKRTBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 14:01:11 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AIItMpe004403;
        Wed, 18 Nov 2020 11:01:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=v6DbP+tA/T8lIfQBTNU76VxL8dqObicCcAXOJoW7daI=;
 b=b+IRUWfgbcxQjCEw8SP0y3XguQf2pMDln/S4+C8GiIiwsRJhAqqOAPiihiOxRGZE83px
 xAhqGPtm4Rdfc+sahuoe/M7561HKAFOnxy6jcyfa1Np11HS+wF7hY8x71iEb3txKr9F5
 Y2Ll/C7N9Q8zEwIUiC30+IqnA+WybM5jIPFfYKD7GcZBiDnGOJZ+ill1DRGs3Fm49W6M
 sJQDzyPhBQp8dKQcfZeY2tLIeNAcGOrq+Zy0XJYJkkaKHtdkl9gkw7ef0a/ziGbbt5Fv
 ppvzQszL63mH/ZzYPPGPAZBp4rMGV1A/98N70ndkcrgkH0znJywiJbtkmf8CFW23T33e vQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 34w7ncrm2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 11:01:02 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Nov
 2020 11:01:00 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Nov
 2020 11:01:01 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 18 Nov 2020 11:01:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ETwO6BI+x7ORPSQsGownpq5SG4nHwJ0Q6wLAD/ni1+r4BJAvQvAkMMmQ1JK5xbK/nlRS+n0vRH70LFrsktLU2/79pulLjBGA8ZDzbP7f53+0/ubmbyJ+c88rfJBYL+vGFjB0+odfoRuBIsMVHRsLwtSFlkowecaR8caz5QE32X5jLFMefnTCc5qgByJWmogZCdxiMVtGlpk0wPukxUrXfy02gBkH6zeFIVH1d1s05jUPFu35Emc+zsJWbHNW58RJxv7TTDh2aZyihOttMJhI+TTNJY5nb9I37z+hsg/OHRNa3i5NXQtyqAs/1NwwAWQj4dH/oFOrQOhCI2xJc3tFTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6DbP+tA/T8lIfQBTNU76VxL8dqObicCcAXOJoW7daI=;
 b=J0s8zuGPhmXjtERmmUW6Cj4TeC2COYHAKZOXaLbL6BW6WdFC1U77ETO/YxWEuN9XuuWz+QpxPIkSeBpncS7P317iSncBXXQqDW4XIriQive/77ksx5SatpxHDJm//EPE9MWSohzB8WnfSG8Ug94QOOYk9b3Y5WOEg9QUF8aeFGOBCCL2Py2Libxcnw4/fT/d/YhWWBukr+m8f4qnxH0mjUT8UzszsTLFAl9L4twTBycfpc+jp/CnrVwTESw/Ghj9ZdkYwCUqHLatbB8DllBKtrfro1UYEDe9539t+V/A+/cMNT87Z7PC8U4WtyvlzHdCJJasO1WVYs9tef01uf0v7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6DbP+tA/T8lIfQBTNU76VxL8dqObicCcAXOJoW7daI=;
 b=JOZ+G+KH4rHAYWxPdTvutDN47Y8H7f8M1Mh/1JK5Ag7ac21RyRIRId3iQpJnEPIkUCx1IL5T+xzBgA0Rlte8018BoKuyKLVsktRh8AEDkwtK2aCjB6fSHLcpN16wuAdOrmWBI/yN5JZMKf+WooOQQvMT0LlEpQEUW013NmSL/84=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1405.namprd18.prod.outlook.com (2603:10b6:320:26::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Wed, 18 Nov
 2020 19:00:59 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%6]) with mapi id 15.20.3564.025; Wed, 18 Nov 2020
 19:00:59 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Stefan Chulski <stefanc@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [PATCH] net: mvpp2: divide fifo for dts-active ports only
Thread-Topic: [PATCH] net: mvpp2: divide fifo for dts-active ports only
Thread-Index: AQHWvdd7b7hGe3lyr0+AVyQcEIp8ZanOPlqw
Date:   Wed, 18 Nov 2020 19:00:59 +0000
Message-ID: <CO6PR18MB38736FA3A7C79A59CC311441B0E10@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1605723656-1276-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1605723656-1276-1-git-send-email-stefanc@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [80.230.11.109]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 397a482e-1dd4-4202-4259-08d88bf4496c
x-ms-traffictypediagnostic: MWHPR18MB1405:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB1405B2A8EB410B31466B8F97B0E10@MWHPR18MB1405.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NROHCC1wt7R+TLgwt31fEU6xKYYPwSn2ujag1O9WroNYLx+HwR+RfponhKSbM7TERS77MswMEXSIMZ8wmiLlHN4AW8jPmhWxe9e4/ck9E1LBr2be46K/ZXSHynPKrh1KYcJEEEQTIzazn1VwzHEJnDMXpXPW4gxsyJzFaefQ8u4eOz5+kCBmYbsS/IGydH2yB4aoyWHqYyO/s+R77XShVwgrl2+KdASAS3ff5P1LYZF3t2fhG8ma2+0XriQkTyeMtI/74LNwjJqjUsxO1VdfoI+4V/+Z29zJKpt6bilpQmJuZS77y03xMnjQR9bwiHaxBbYcBTgi9yOkj6JcmDQolA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(53546011)(54906003)(6506007)(110136005)(33656002)(8936002)(7696005)(83380400001)(76116006)(64756008)(8676002)(66446008)(26005)(316002)(186003)(66946007)(66476007)(66556008)(478600001)(52536014)(71200400001)(5660300002)(4326008)(2906002)(86362001)(9686003)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: N4opU7Ud9FQ12BL76XAzp+kUGWs0C/MAvPB3e5aiEPcSN2xKlMX5ytIOxCjEUhb4SjYFu7W7WGpyhkCAZAsJgUdN2ifJAAjshRTxQUdVCd032PCRBpWXFte7oMX874NFL380wXVF+OxGpqQfTVLMbdGCw/hkwsVGeouX6wRDWOvdGbo+065xKZf1o9sh/OELwMsLwmFMVI9gnKh1oUui7HzgcUDWlOIBjk2inRiIWoW2PYJJq0FB8DU6S5wQz8N7IZbjE40znBhwpc1Se0u711EFP9BgdnzQPanrDeCtdhWEVAKmz1Dfk3luNDVt21oZPUN7xux0ZgsqyQpJSI7tRdbJkjWp8uwuuBAD0sViOQGNDctPP5eq57vK1ofdlMXu0e3COlFjKgPnbkAqrGd5IHbpPQO4D72xhHEU/ZfjSfwzLvBmCsyTA8QBU+wyCvcOyV0UMC9iQC3cUrA2cVo+CwGoxq9jaANwZtW12skq7OLRV+osmYAf+KjaaYQO4IWgC3esn65gQi5nzYYhWrK6JTDK55koH6jh4UJ7XfengmgOab/zRp2h1LQKE1XApcd7+r9RlOkPg4dV6+dq+OHWCJO+Yh2XDHaq9ajaTFB00TmaYDRtrxr9W2l0JIt5uH84HcCMxjV2YOmtFCM1CYwL6m6QvyBMJcIDMYM5OIwwBHBVD1EF2idG4JvNDuIcHggxK+mn9QvTNI53X9xA9greQhzPsx6NSx7sB4wE3qFl66/RTTAT2C5JZSWbYp2Ct16pl2rkeXbvwaKHwW8pefByPsS6N7lwIxL9j6F+u7vufDPUQTMnqhIEvyHib7wWgKITfCrC5YxLTDpX/qMgSwWxbo2M5YALwUTQMmADw5bzheKeJECwcrPSM4Kd8Ny9G1RoUfZbi59nTTwdpTRGx/uEQw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 397a482e-1dd4-4202-4259-08d88bf4496c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2020 19:00:59.1693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W0moQvySQohtrDP2mBDW15m1rf4ukqFgJzw1svn8oEi9nJjvuKYhZOzI4kKSfg/GPRlaqeXO3xVcFjf211qamg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1405
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_06:2020-11-17,2020-11-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: stefanc@marvell.com <stefanc@marvell.com>
> Sent: Wednesday, November 18, 2020 8:21 PM
> To: netdev@vger.kernel.org
> Cc: thomas.petazzoni@bootlin.com; davem@davemloft.net; Nadav Haklai
> <nadavh@marvell.com>; Yan Markman <ymarkman@marvell.com>; linux-
> kernel@vger.kernel.org; Stefan Chulski <stefanc@marvell.com>
> Subject: [PATCH] net: mvpp2: divide fifo for dts-active ports only
>=20
> From: Stefan Chulski <stefanc@marvell.com>
>=20
> Tx/Rx FIFO is a HW resource limited by total size, but shared by all port=
s of
> same CP110 and impacting port-performance.
> Do not divide the FIFO for ports which are not enabled in DTS, so active =
ports
> could have more FIFO.
>=20
> The active port mapping should be done in probe before FIFO-init.
>=20
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  23 +++--
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 129
> +++++++++++++++++-------
>  2 files changed, 108 insertions(+), 44 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> index 8347758..6bd7e40 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> @@ -695,6 +695,9 @@
>  /* Maximum number of supported ports */
>  #define MVPP2_MAX_PORTS			4
>=20
> +/* Loopback port index */
> +#define MVPP2_LOOPBACK_PORT_INDEX	3
> +
>  /* Maximum number of TXQs used by single port */
>  #define MVPP2_MAX_TXQ			8
>=20
> @@ -729,22 +732,21 @@
>  #define MVPP2_TX_DESC_ALIGN		(MVPP2_DESC_ALIGNED_SIZE
> - 1)
>=20
>  /* RX FIFO constants */
> +#define MVPP2_RX_FIFO_PORT_DATA_SIZE_44KB	0xb000
>  #define MVPP2_RX_FIFO_PORT_DATA_SIZE_32KB	0x8000
>  #define MVPP2_RX_FIFO_PORT_DATA_SIZE_8KB	0x2000
>  #define MVPP2_RX_FIFO_PORT_DATA_SIZE_4KB	0x1000
> -#define MVPP2_RX_FIFO_PORT_ATTR_SIZE_32KB	0x200
> -#define MVPP2_RX_FIFO_PORT_ATTR_SIZE_8KB	0x80
> +#define MVPP2_RX_FIFO_PORT_ATTR_SIZE(data_size)	((data_size) >> 6)
>  #define MVPP2_RX_FIFO_PORT_ATTR_SIZE_4KB	0x40
>  #define MVPP2_RX_FIFO_PORT_MIN_PKT		0x80
>=20
>  /* TX FIFO constants */
> -#define MVPP22_TX_FIFO_DATA_SIZE_10KB		0xa
> -#define MVPP22_TX_FIFO_DATA_SIZE_3KB		0x3
> -#define MVPP2_TX_FIFO_THRESHOLD_MIN		256
> -#define MVPP2_TX_FIFO_THRESHOLD_10KB	\
> -	(MVPP22_TX_FIFO_DATA_SIZE_10KB * 1024 -
> MVPP2_TX_FIFO_THRESHOLD_MIN)
> -#define MVPP2_TX_FIFO_THRESHOLD_3KB	\
> -	(MVPP22_TX_FIFO_DATA_SIZE_3KB * 1024 -
> MVPP2_TX_FIFO_THRESHOLD_MIN)
> +#define MVPP22_TX_FIFO_DATA_SIZE_16KB		16
> +#define MVPP22_TX_FIFO_DATA_SIZE_10KB		10
> +#define MVPP22_TX_FIFO_DATA_SIZE_3KB		3
> +#define MVPP2_TX_FIFO_THRESHOLD_MIN		256 /* Bytes */
> +#define MVPP2_TX_FIFO_THRESHOLD(kb)	\
> +		((kb) * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
>=20
>  /* RX buffer constants */
>  #define MVPP2_SKB_SHINFO_SIZE \
> @@ -946,6 +948,9 @@ struct mvpp2 {
>  	/* List of pointers to port structures */
>  	int port_count;
>  	struct mvpp2_port *port_list[MVPP2_MAX_PORTS];
> +	/* Map of enabled ports */
> +	unsigned long port_map;
> +
>  	struct mvpp2_tai *tai;
>=20
>  	/* Number of Tx threads used */
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index f6616c8..9ff5f57 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -6601,32 +6601,56 @@ static void mvpp2_rx_fifo_init(struct mvpp2 *priv=
)
>  	mvpp2_write(priv, MVPP2_RX_FIFO_INIT_REG, 0x1);  }
>=20
> -static void mvpp22_rx_fifo_init(struct mvpp2 *priv)
> +static void mvpp22_rx_fifo_set_hw(struct mvpp2 *priv, int port, int
> +data_size)
>  {
> -	int port;
> +	int attr_size =3D MVPP2_RX_FIFO_PORT_ATTR_SIZE(data_size);
>=20
> -	/* The FIFO size parameters are set depending on the maximum speed
> a
> -	 * given port can handle:
> -	 * - Port 0: 10Gbps
> -	 * - Port 1: 2.5Gbps
> -	 * - Ports 2 and 3: 1Gbps
> -	 */
> +	mvpp2_write(priv, MVPP2_RX_DATA_FIFO_SIZE_REG(port), data_size);
> +	mvpp2_write(priv, MVPP2_RX_ATTR_FIFO_SIZE_REG(port), attr_size); }
>=20
> -	mvpp2_write(priv, MVPP2_RX_DATA_FIFO_SIZE_REG(0),
> -		    MVPP2_RX_FIFO_PORT_DATA_SIZE_32KB);
> -	mvpp2_write(priv, MVPP2_RX_ATTR_FIFO_SIZE_REG(0),
> -		    MVPP2_RX_FIFO_PORT_ATTR_SIZE_32KB);
> +/* Initialize TX FIFO's: the total FIFO size is 48kB on PPv2.2.
> + * 4kB fixed space must be assigned for the loopback port.
> + * Redistribute remaining avialable 44kB space among all active ports.
> + * Guarantee minimum 32kB for 10G port and 8kB for port 1, capable of
> +2.5G
> + * SGMII link.
> + */
> +static void mvpp22_rx_fifo_init(struct mvpp2 *priv) {
> +	int port, size;
> +	unsigned long port_map;
> +	int remaining_ports_count;
> +	int size_remainder;
> +
> +	/* The loopback requires fixed 4kB of the FIFO space assignment. */
> +	mvpp22_rx_fifo_set_hw(priv, MVPP2_LOOPBACK_PORT_INDEX,
> +			      MVPP2_RX_FIFO_PORT_DATA_SIZE_4KB);
> +	port_map =3D priv->port_map & ~BIT(MVPP2_LOOPBACK_PORT_INDEX);
> +
> +	/* Set RX FIFO size to 0 for inactive ports. */
> +	for_each_clear_bit(port, &port_map,
> MVPP2_LOOPBACK_PORT_INDEX)
> +		mvpp22_rx_fifo_set_hw(priv, port, 0);
> +
> +	/* Assign remaining RX FIFO space among all active ports. */
> +	size_remainder =3D MVPP2_RX_FIFO_PORT_DATA_SIZE_44KB;
> +	remaining_ports_count =3D hweight_long(port_map);
> +
> +	for_each_set_bit(port, &port_map, MVPP2_LOOPBACK_PORT_INDEX) {
> +		if (remaining_ports_count =3D=3D 1)
> +			size =3D size_remainder;
> +		else if (port =3D=3D 0)
> +			size =3D max(size_remainder / remaining_ports_count,
> +				   MVPP2_RX_FIFO_PORT_DATA_SIZE_32KB);
> +		else if (port =3D=3D 1)
> +			size =3D max(size_remainder / remaining_ports_count,
> +				   MVPP2_RX_FIFO_PORT_DATA_SIZE_8KB);
> +		else
> +			size =3D size_remainder / remaining_ports_count;
>=20
> -	mvpp2_write(priv, MVPP2_RX_DATA_FIFO_SIZE_REG(1),
> -		    MVPP2_RX_FIFO_PORT_DATA_SIZE_8KB);
> -	mvpp2_write(priv, MVPP2_RX_ATTR_FIFO_SIZE_REG(1),
> -		    MVPP2_RX_FIFO_PORT_ATTR_SIZE_8KB);
> +		size_remainder -=3D size;
> +		remaining_ports_count--;
>=20
> -	for (port =3D 2; port < MVPP2_MAX_PORTS; port++) {
> -		mvpp2_write(priv, MVPP2_RX_DATA_FIFO_SIZE_REG(port),
> -			    MVPP2_RX_FIFO_PORT_DATA_SIZE_4KB);
> -		mvpp2_write(priv, MVPP2_RX_ATTR_FIFO_SIZE_REG(port),
> -			    MVPP2_RX_FIFO_PORT_ATTR_SIZE_4KB);
> +		mvpp22_rx_fifo_set_hw(priv, port, size);
>  	}
>=20
>  	mvpp2_write(priv, MVPP2_RX_MIN_PKT_SIZE_REG, @@ -6634,24
> +6658,53 @@ static void mvpp22_rx_fifo_init(struct mvpp2 *priv)
>  	mvpp2_write(priv, MVPP2_RX_FIFO_INIT_REG, 0x1);  }
>=20
> -/* Initialize Tx FIFO's: the total FIFO size is 19kB on PPv2.2 and 10G
> - * interfaces must have a Tx FIFO size of 10kB. As only port 0 can do 10=
G,
> - * configure its Tx FIFO size to 10kB and the others ports Tx FIFO size =
to 3kB.
> +static void mvpp22_tx_fifo_set_hw(struct mvpp2 *priv, int port, int
> +size) {
> +	int threshold =3D MVPP2_TX_FIFO_THRESHOLD(size);
> +
> +	mvpp2_write(priv, MVPP22_TX_FIFO_SIZE_REG(port), size);
> +	mvpp2_write(priv, MVPP22_TX_FIFO_THRESH_REG(port), threshold); }
> +
> +/* Initialize TX FIFO's: the total FIFO size is 19kB on PPv2.2.
> + * 3kB fixed space must be assigned for the loopback port.
> + * Redistribute remaining avialable 16kB space among all active ports.
> + * The 10G interface should use 10kB (which is maximum possible size
> + * per single port).
>   */
>  static void mvpp22_tx_fifo_init(struct mvpp2 *priv)  {
> -	int port, size, thrs;
> -
> -	for (port =3D 0; port < MVPP2_MAX_PORTS; port++) {
> -		if (port =3D=3D 0) {
> +	int port, size;
> +	unsigned long port_map;
> +	int remaining_ports_count;
> +	int size_remainder;
> +
> +	/* The loopback requires fixed 3kB of the FIFO space assignment. */
> +	mvpp22_tx_fifo_set_hw(priv, MVPP2_LOOPBACK_PORT_INDEX,
> +			      MVPP22_TX_FIFO_DATA_SIZE_3KB);
> +	port_map =3D priv->port_map & ~BIT(MVPP2_LOOPBACK_PORT_INDEX);
> +
> +	/* Set TX FIFO size to 0 for inactive ports. */
> +	for_each_clear_bit(port, &port_map,
> MVPP2_LOOPBACK_PORT_INDEX)
> +		mvpp22_tx_fifo_set_hw(priv, port, 0);
> +
> +	/* Assign remaining TX FIFO space among all active ports. */
> +	size_remainder =3D MVPP22_TX_FIFO_DATA_SIZE_16KB;
> +	remaining_ports_count =3D hweight_long(port_map);
> +
> +	for_each_set_bit(port, &port_map, MVPP2_LOOPBACK_PORT_INDEX) {
> +		if (remaining_ports_count =3D=3D 1)
> +			size =3D min(size_remainder,
> +				   MVPP22_TX_FIFO_DATA_SIZE_10KB);
> +		else if (port =3D=3D 0)
>  			size =3D MVPP22_TX_FIFO_DATA_SIZE_10KB;
> -			thrs =3D MVPP2_TX_FIFO_THRESHOLD_10KB;
> -		} else {
> -			size =3D MVPP22_TX_FIFO_DATA_SIZE_3KB;
> -			thrs =3D MVPP2_TX_FIFO_THRESHOLD_3KB;
> -		}
> -		mvpp2_write(priv, MVPP22_TX_FIFO_SIZE_REG(port), size);
> -		mvpp2_write(priv, MVPP22_TX_FIFO_THRESH_REG(port),
> thrs);
> +		else
> +			size =3D size_remainder / remaining_ports_count;
> +
> +		size_remainder -=3D size;
> +		remaining_ports_count--;
> +
> +		mvpp22_tx_fifo_set_hw(priv, port, size);
>  	}
>  }
>=20
> @@ -6952,6 +7005,12 @@ static int mvpp2_probe(struct platform_device
> *pdev)
>  			goto err_axi_clk;
>  	}
>=20
> +	/* Map DTS-active ports. Should be done before FIFO mvpp2_init */
> +	fwnode_for_each_available_child_node(fwnode, port_fwnode) {
> +		if (!fwnode_property_read_u32(port_fwnode, "port-id", &i))
> +			priv->port_map |=3D BIT(i);
> +	}
> +
>  	/* Initialize network controller */
>  	err =3D mvpp2_init(pdev, priv);
>  	if (err < 0) {
> --
> 1.9.1


Jakub Kicinski added to CC
