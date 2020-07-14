Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341DE21E56C
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 03:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgGNB73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 21:59:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8742 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726602AbgGNB72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 21:59:28 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06E1v0Zb016608;
        Mon, 13 Jul 2020 18:59:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=A5ZUKJ/Pa1qBn+36xoP/47IbMTwcz7tbWXPk6GEyxkU=;
 b=jZ9fukEPwvzwybdPEmIkKanGl4TAa+LbyazfzemEPJZGawCuqyRT3cnJOdhFQ70l6VHa
 mu5UorQx+Ep670HVSRmR8JELAYf2PZEWjSjTlLEj2eTDBirCyECPJrd5dfRnZXgp9mHK
 7WMgurICoK4SfHNcuxMykmaSRtDfdhNq7VCO/DLiqLI1bGrZtK4a5dIbm9/03gR4l66s
 7uJpxZ6CHOiVps9EtCummm5OXBo8B9NuZim063ppmyGeaOInFwYo/8OXOjwBJFHYSTf0
 V+jQttMqybjBZ+fNtLPJqpP++LuHDGlWX1hEnAk8wPXQxrpz3mMteoQt9Qe8kQENFIV5 Zw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 327asna77d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Jul 2020 18:59:17 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Jul
 2020 18:59:16 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.50) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 13 Jul 2020 18:59:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XkfYQYZBCB+Zwp2FU0KTMxJ/oYa/I1XGgwE3QZ3cR76w53otz+1hO8mX4/yQfpDjbH+PoFcVE+YxL+jOiB6OUAmJ3zD3eebCAvNsHa9wEjGr4TOxLRlee7ULGxFzQ8Pj0qGieIe38kvM0EqRBHRV29XkTa+CLnfcWo2v3DbmX7czvl2rk/qNKFigdmTcDVqKxeVwLbYcCIxQytlkM9t0Dx40WrMTpnIAcuPj97MWQLq+otlphjVuXm5mlObUrjUaI/3nhpxZavnI9hHaNdowcDDxIBuOaTILsUZhSpm6RVw9orDkcvgVpKTFVxAWeSud28MNPmhfBTu14J1thuqUww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5ZUKJ/Pa1qBn+36xoP/47IbMTwcz7tbWXPk6GEyxkU=;
 b=le0l/AIE7BBDVO1GCESzpwT8bJRgmvFbcSIvjx8O5ZlbJiTPuaC/xxMJEE0gyrz4vCUfJsRHn1myYMD8qTx+L348pZZWYw53jJ3a8fhWJHA/6TYLDX/a+3CYeGvWGXJ83Jhw4ioc5HnMOE3eFQpsJnBr2I/TVQJOML2DQT5gXxIZ1bjLNFa4joZmkPfDnDefBX4VGmLp+48zeTHFRsCSSZefBJS3ze59auWNfv0ssyG1bTNY50Um2zJy09I5AZGl70lgymGY9G/cC5T+jX3cmyxmM72hj6hMHKlWG0lpaFC6lnoRFzLsUWVE3BSroCv74ojk6dCo5BxQ8UUn91GVHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5ZUKJ/Pa1qBn+36xoP/47IbMTwcz7tbWXPk6GEyxkU=;
 b=MbYjfb3etwcbswBimxUkBG8jbFfHEuxgv69NZRW9+/+urdHvFsu1o2HG63mkYp3zucnGdEPOxZNhki5vVwgtnyx4D5wisX26GWJo5d9RZPf3NXogrSwlEWPDKoqzjYkOnhlvxo+BEgEjjPaoRQmjchKOWJAx7bmgmaaj+5w8M58=
Received: from BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28)
 by BYAPR18MB2934.namprd18.prod.outlook.com (2603:10b6:a03:101::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Tue, 14 Jul
 2020 01:59:15 +0000
Received: from BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::bd3d:c142:5f78:975]) by BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::bd3d:c142:5f78:975%7]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 01:59:15 +0000
From:   Derek Chickles <dchickles@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "ajit.khaparde@broadcom.com" <ajit.khaparde@broadcom.com>,
        "sriharsha.basavapatna@broadcom.com" 
        <sriharsha.basavapatna@broadcom.com>,
        "somnath.kotur@broadcom.com" <somnath.kotur@broadcom.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "benve@cisco.com" <benve@cisco.com>,
        "_govind@gmx.com" <_govind@gmx.com>,
        Satananda Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>
Subject: RE: [PATCH net-next 08/12] liquidio: convert to new udp_tunnel_nic
 infra
Thread-Topic: [PATCH net-next 08/12] liquidio: convert to new udp_tunnel_nic
 infra
Thread-Index: AdZZgfEdN/mU6LnTTGeU111DHOb3Sg==
Date:   Tue, 14 Jul 2020 01:59:15 +0000
Message-ID: <BYAPR18MB242321AB3ECD038555C71348AC610@BYAPR18MB2423.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2601:646:8d01:7c70:1:5e4d:2d34:f424]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aade202b-1a4c-4239-a894-08d827998316
x-ms-traffictypediagnostic: BYAPR18MB2934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2934E29987DB5BEF9ED08EE5AC610@BYAPR18MB2934.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0XW0m1q6Cc2uH1TS45pRSidtXxWbRFGRKh/musun9G07+55PEtj1ZYrUK3R68jhd6cXWSZwwFHJiogznzcpWFpX+x70tRJey+tZHXkvDFLi2Fdgw0vhapWtIW9LDHPtpg0DK+AWGy+qkdD7QKnrRDWdvaB2qF8mVy5KYOvVboEKNWcGTVXqn2wHwk4eXxoyx0ArtWMMUzMamqT02NNVca1MhemA1lJ8X+130t1TxBbzvo5T+FGxPNBrzBP8GRX7JActxNLfrnYg6lJzy7OSWyyiRYvTXGRerbjgWegfHzHOWDHb96eR36vozqBc7jlOpoYVj5SwfyYLL1llsDnKFOpkxjURpoFx5EYFHAhbgfOOKEGGZoGG7dBe9rOXDu7Hp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2423.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(53546011)(186003)(7696005)(107886003)(6506007)(76116006)(83380400001)(66446008)(66476007)(66946007)(86362001)(2906002)(4326008)(64756008)(66556008)(71200400001)(5660300002)(110136005)(9686003)(52536014)(316002)(55016002)(8936002)(54906003)(33656002)(7416002)(8676002)(478600001)(518174003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: xVC8aDA0jR0hw4eW0UwgiMyxFx8PmyKMGzTAZ1EZnzkebKmQo2pk124cuUU/nKvqp6QTwfmfNNfgLVcIj+CJ5JLpDMqVDvSyGWn5xQOa+1XKyA+QQYXK9i73WtzQamVzLPX/otvApDqKePepyC6vSCUKVcbRk/aFi18QhWqgBkvlszkGuoknAhT5mkMM1m56K7A19IwtaFZA680Pp6EUEhjtOOc3r8kRtta6My7WUUZiEz961DAhR1/g3/wdV6Z2RRdtcRkYSS6WtGjz9XalkaGDa2ifLVFfhh82BOS6DvDMZsEO7kQmretvhkMotVRyUluUyOVqbxPlm8W+cRYgayJMhnkTw4wno0fTLlfvHEhs7QnuAoLMm2wKzfSfFHf4MgGLpEzM+QmFJXEZZ4F4PbNsxtMhbfnErXom3rGnM36PcA5uavkWtWHomFOMgOx3QThqw2XtxzNJBMkMNjGZlShZ8BR24lWrMh/gTY//nQsDYiT2QjkIlfLFchr3Xj5YPNIhj9kgTihYR6aXdfSPlJ6EjkUTMWv5INNDVhxZMmU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2423.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aade202b-1a4c-4239-a894-08d827998316
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2020 01:59:15.2896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qLNLH32funhknmY0RpF0kQ2P6NeopwhACbHtgGnJ7LyVsYIeOeLkZAlClNzYt3HaEo2+YU1FpYBrmQ10c/y6Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2934
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_17:2020-07-13,2020-07-13 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, July 13, 2020 5:31 PM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; oss-drivers@netronome.com;
> simon.horman@netronome.com; ajit.khaparde@broadcom.com;
> sriharsha.basavapatna@broadcom.com; somnath.kotur@broadcom.com;
> thomas.lendacky@amd.com; Ariel Elior <aelior@marvell.com>; Sudarsana
> Reddy Kalluru <skalluru@marvell.com>; vishal@chelsio.com;
> benve@cisco.com; _govind@gmx.com; Derek Chickles
> <dchickles@marvell.com>; Satananda Burla <sburla@marvell.com>; Felix
> Manlunas <fmanlunas@marvell.com>; jeffrey.t.kirsher@intel.com;
> anthony.l.nguyen@intel.com; GR-everest-linux-l2 <GR-everest-linux-
> l2@marvell.com>; Shahed Shaikh <shshaikh@marvell.com>; Manish Chopra
> <manishc@marvell.com>; GR-Linux-NIC-Dev <GR-Linux-NIC-
> Dev@marvell.com>; Jakub Kicinski <kuba@kernel.org>
> Subject: [EXT] [PATCH net-next 08/12] liquidio: convert to new
> udp_tunnel_nic infra
>=20
> This driver is just a super thin FW interface. Assume it wants 256 ports =
at
> most. Not much we can do here.

It actually supports 1024. Can you change this patch accordingly? Same goes=
 for lio_vf_main.c.

Thanks,
Derek




>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  .../net/ethernet/cavium/liquidio/lio_main.c   | 59 +++++++++++--------
>  1 file changed, 33 insertions(+), 26 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c
> b/drivers/net/ethernet/cavium/liquidio/lio_main.c
> index 19689d72bc4e..dc620cb78fd5 100644
> --- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
> +++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
> @@ -2670,6 +2670,35 @@ static int liquidio_vxlan_port_command(struct
> net_device *netdev, int command,
>  	return ret;
>  }
>=20
> +static int liquidio_udp_tunnel_set_port(struct net_device *netdev,
> +					unsigned int table, unsigned int entry,
> +					struct udp_tunnel_info *ti)
> +{
> +	return liquidio_vxlan_port_command(netdev,
> +
> OCTNET_CMD_VXLAN_PORT_CONFIG,
> +					   htons(ti->port),
> +					   OCTNET_CMD_VXLAN_PORT_ADD);
> +}
> +
> +static int liquidio_udp_tunnel_unset_port(struct net_device *netdev,
> +					  unsigned int table,
> +					  unsigned int entry,
> +					  struct udp_tunnel_info *ti)
> +{
> +	return liquidio_vxlan_port_command(netdev,
> +
> OCTNET_CMD_VXLAN_PORT_CONFIG,
> +					   htons(ti->port),
> +					   OCTNET_CMD_VXLAN_PORT_DEL);
> +}
> +
> +static const struct udp_tunnel_nic_info liquidio_udp_tunnels =3D {
> +	.set_port	=3D liquidio_udp_tunnel_set_port,
> +	.unset_port	=3D liquidio_udp_tunnel_unset_port,
> +	.tables		=3D {
> +		{ .n_entries =3D 256, .tunnel_types =3D
> UDP_TUNNEL_TYPE_VXLAN, },
> +	},
> +};

