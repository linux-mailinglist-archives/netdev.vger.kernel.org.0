Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78426234078
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731795AbgGaHsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:48:38 -0400
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:17294
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731738AbgGaHsh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 03:48:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TMg6t9qjcH5EC3gU9ZFg8azk6+jrAs+KqlmYPGcyhaS3XGrxFQlkmdYdmz5cuNl0qlmUrnQk01ew8SNhHaBz3D8LgsA9gZ+9IZBa0MvdFkbElyLvpPrOmFfOMl4md1K237L112gxUoHIMUbSy1Muvj0RxTdqhLqPcHE08DYE5iAxfMcpcP9yx1SekpyJvFKOM6G1YP75mOot5oIVPPbQO303/7scNGYXnwLR1NTfgwbHN8UjapeW1ziLdc+VH8AV61KfTwwxaHHOSPArhavLC1GwBMRp3kbtsaMqhxBhvnpiCpLOXOHRYphQMqlW4WNxq/76ezdwl2Jcmv3iCcFlDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXj41I+kmhEnQ3DTOTzgfkE0ubI+vrYEo+gJ+M87KKg=;
 b=OJuls1kmN4u4KxiiRKMaAG4iq2clVOuebDaz5Ua7OfEC/TkhTwZxf+VqlcMIS4T2l1242DV8XrU+qNhJjKkv09CS+Xuuf3J9Hupj6X8b+MfTSC57YXLkGzKIc0VpBDWDIFDySKvE3sXkJk652mImoK//96pvo2AZsplNGaib8s+Ctbh/UKo6sGchO3G7+NMCJqdxnngDQQgCTQB93vDEeGOofNbTeAwSZnrvOy1tds4eDSljj4UD8o6Wv3ulyQ/OPfo7Tdhcocal6CyQ59s/wcWCn15g6G6BeHkAK02eaY6E/dr+3Wb87DbBDsCrBG9el14VuPLN3dyLJBhpNMmHYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXj41I+kmhEnQ3DTOTzgfkE0ubI+vrYEo+gJ+M87KKg=;
 b=OUGn9+lOu3usjVPoJ9XyPEOb6xVhKjPs6UjHwKQsUWRLo7Nr53MADm4opiLZ+Sh6Csk0wUqSRd+uOFQA1biu37C0GrxbDBXY1lo+xz+fkFzs1BAm8oQ/OfyzBQYzpHsg3RA/cZQOjSZxm7fJ/bYHrOqKE59aPMBkk8DIldxJLF4=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR04MB5080.eurprd04.prod.outlook.com (2603:10a6:20b:2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Fri, 31 Jul
 2020 07:48:34 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f5cb:bc18:1991:c31f]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f5cb:bc18:1991:c31f%2]) with mapi id 15.20.3239.020; Fri, 31 Jul 2020
 07:48:34 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Florinel Iordache <florinel.iordache@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 4/5] fsl/fman: check dereferencing null pointer
Thread-Topic: [PATCH net 4/5] fsl/fman: check dereferencing null pointer
Thread-Index: AQHWZwZeOzBzxxS0S0aifMgnGj4ms6khT8LA
Date:   Fri, 31 Jul 2020 07:48:34 +0000
Message-ID: <AM6PR04MB397680E5084359739F2FC08EEC4E0@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <1596177969-27645-1-git-send-email-florinel.iordache@nxp.com>
 <1596177969-27645-5-git-send-email-florinel.iordache@nxp.com>
In-Reply-To: <1596177969-27645-5-git-send-email-florinel.iordache@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.76.227.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ce190a7f-285f-480c-d21e-08d8352620a2
x-ms-traffictypediagnostic: AM6PR04MB5080:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB50804514DE2A99D1DF47F6E1EC4E0@AM6PR04MB5080.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JDzaa6yVKfqlHbXtZIpW3Yh6q7kKvyhryEpBFzqPxZKRM76MZm6vBfrlTPUdz7Cod4J5yncyWxs58jm94bsBAJkCPO/1Tw5LIEL0Hoi2T7ah6/+uBO2aHtk3tcnIDItfyI86I8bM/Lp+z3dscRxRgjiNSqsDluPrg0lwXzEHxXixh31OeYBvgcbA+Q5JXUmEGnSlbGwZBKksANgsC5Myyd702ABw27yQOCrMAjK4p+HxC9EoGKzCeVl/ebdpNUNXi1m4c8Zoc3vf08K4o3+6PoZR7+mvnXjGWl7EbvQLJmluWvdSWzFes/+Sgr2RwGxfqAroXjxRoX99hD/Kl2oLqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(7696005)(66946007)(8676002)(316002)(186003)(76116006)(26005)(52536014)(66446008)(478600001)(6506007)(53546011)(66476007)(110136005)(64756008)(71200400001)(66556008)(4326008)(8936002)(55016002)(9686003)(5660300002)(2906002)(83380400001)(33656002)(44832011)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: YkywNaQwSpu3pF38lsrk/9o2JTXaZCpMcGSMprudV2vlP88Vi1pQ3t1WC1+Xii1JElGO2gkhZ/U+ihNP3e+gPGRrEIAwjXFirqe4MFmIpf8ofKRsH/Yr/7lVBvhkSzamtHlWjmBTEc1BszRg21VUA4ceeze74VSz1trFPF5qHkSwXVuc3MUkLISuuWWicMnLdmS6ahhBnw1Aw+LUKwh1cT1mxrlAXTw9TurwjelJths/O0AAwVPUs+vl+FDUZNKvfKXCgKdyXMFwb0bZwm0vuTqZ6/Mi11Mad4hIuoE85kcjM6RG2oFOc8DIShBdCrIYAd/cnRAasgSXpiswnUqbhJ8LiAKZAAG9QAhXhN4d06eJHZdKsjPtRkk3mZRQz9cwFRmLhvyAMrurtjY9HvP6rh/k8M3EQ4GCV65B6VPn/Trr8pQVuubdLSrfICeCdC57JBBLyRaqFoPrL0Y4IQAHOl3WqxDnW48RUqioc2hjZ8c=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce190a7f-285f-480c-d21e-08d8352620a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2020 07:48:34.4746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TQ8PUiomkzl/1zrnuUINiPEyYi2AGHYgi5dgQ9f6fV9cppVpKUEo6iMP6YNG6bA0uLZQsrXDtlqRXCJhW/eU5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Florinel Iordache <florinel.iordache@nxp.com>
> Sent: 31 July 2020 09:46
> To: Madalin Bucur <madalin.bucur@nxp.com>; davem@davemloft.net;
> kuba@kernel.org; netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Florinel Iordache
> <florinel.iordache@nxp.com>
> Subject: [PATCH net 4/5] fsl/fman: check dereferencing null pointer
>=20
> Add a safe check to avoid dereferencing null pointer
>=20
> Fixes: 57ba4c9b ("fsl/fman: Add FMan MAC support")
>=20
> Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fman/fman_dtsec.c | 4 ++--
>  drivers/net/ethernet/freescale/fman/fman_memac.c | 3 ++-
>  drivers/net/ethernet/freescale/fman/fman_tgec.c  | 2 +-
>  3 files changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
> b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
> index 004c266..bce3c93 100644
> --- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
> +++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
> @@ -1200,7 +1200,7 @@ int dtsec_del_hash_mac_address(struct fman_mac
> *dtsec, enet_addr_t *eth_addr)
>  		list_for_each(pos,
>  			      &dtsec->multicast_addr_hash->lsts[bucket]) {
>  			hash_entry =3D ETH_HASH_ENTRY_OBJ(pos);
> -			if (hash_entry->addr =3D=3D addr) {
> +			if (hash_entry && hash_entry->addr =3D=3D addr) {
>  				list_del_init(&hash_entry->node);
>  				kfree(hash_entry);
>  				break;
> @@ -1213,7 +1213,7 @@ int dtsec_del_hash_mac_address(struct fman_mac
> *dtsec, enet_addr_t *eth_addr)
>  		list_for_each(pos,
>  			      &dtsec->unicast_addr_hash->lsts[bucket]) {
>  			hash_entry =3D ETH_HASH_ENTRY_OBJ(pos);
> -			if (hash_entry->addr =3D=3D addr) {
> +			if (hash_entry && hash_entry->addr =3D=3D addr) {
>  				list_del_init(&hash_entry->node);
>  				kfree(hash_entry);
>  				break;
> diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c
> b/drivers/net/ethernet/freescale/fman/fman_memac.c
> index bb02b37..52ee982 100644
> --- a/drivers/net/ethernet/freescale/fman/fman_memac.c
> +++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
> @@ -852,6 +852,7 @@ int memac_set_tx_pause_frames(struct fman_mac *memac,
> u8 priority,
>=20
>  	tmp =3D ioread32be(&regs->command_config);
>  	tmp &=3D ~CMD_CFG_PFC_MODE;
> +	priority =3D 0;

This line seems to be added by mistake.

>=20
>  	iowrite32be(tmp, &regs->command_config);
>=20
> @@ -981,7 +982,7 @@ int memac_del_hash_mac_address(struct fman_mac *memac=
,
> enet_addr_t *eth_addr)
>=20
>  	list_for_each(pos, &memac->multicast_addr_hash->lsts[hash]) {
>  		hash_entry =3D ETH_HASH_ENTRY_OBJ(pos);
> -		if (hash_entry->addr =3D=3D addr) {
> +		if (hash_entry && hash_entry->addr =3D=3D addr) {
>  			list_del_init(&hash_entry->node);
>  			kfree(hash_entry);
>  			break;
> diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c
> b/drivers/net/ethernet/freescale/fman/fman_tgec.c
> index 8c7eb87..41946b1 100644
> --- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
> +++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
> @@ -626,7 +626,7 @@ int tgec_del_hash_mac_address(struct fman_mac *tgec,
> enet_addr_t *eth_addr)
>=20
>  	list_for_each(pos, &tgec->multicast_addr_hash->lsts[hash]) {
>  		hash_entry =3D ETH_HASH_ENTRY_OBJ(pos);
> -		if (hash_entry->addr =3D=3D addr) {
> +		if (hash_entry && hash_entry->addr =3D=3D addr) {
>  			list_del_init(&hash_entry->node);
>  			kfree(hash_entry);
>  			break;
> --
> 1.9.1

