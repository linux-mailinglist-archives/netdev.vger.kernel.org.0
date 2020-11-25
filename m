Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453342C445C
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 16:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731584AbgKYPru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 10:47:50 -0500
Received: from mail-eopbgr80057.outbound.protection.outlook.com ([40.107.8.57]:11003
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730522AbgKYPrt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 10:47:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Td4LBbuNb26wlC+zGlwCECJtziucZ5UwQ6jNPAotrkyzkG2qgLyPyjq35dfIXax8TLcDQHXvd1szZujFVSPCQOlJyaDW+l1qF9ub3ntzVFoLHTRBDeeFg0Y5obXoqPeKePxPmCRns9Y8e3u3XwZklldQF7PIMWxnVhlqdUglnlyvqlFr7VlaRB+xXKpQOWnGbcKjzLeAIU0I7HMK8JCSZkvBzFrJb99h1lRpvt/ES0Df/u+++wRm1DkQb5EJZas6mKSNnOJx3CisebOeKc5VZba5e/AbWXdmt8x7hKqrMUJpgYG2VCF7ZST2dGSobHTct7d/c6Lzw1asrnl/hk9LBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EDbNb6Vb+OWw7VShiPqfZSZ25dYM4DfRl0RZV4NubNw=;
 b=Y0ivX4A/A6aAMfBQaYCoX89Cf0h6tZY72O9CrFxgsENZwvdmjmp81MzLYYplbbVj7Yul0grMhSm30Shdr486k9OIYCvUj0s91hu7gm62IfH+Jje7M4zsPWEz66ANJr1MzexVaCj5BjFtiEk2/plPNr3nMpFxWVbxhi9f6jghka4OJ2xG5iiPF/n9kRV4PbXiQw2QywDQOVZOrTj4dh7ZBzq9WzN1JCY94aMsYsjyIemTNQf2tn3OC9fRkB3of0W2ODhCckppvPxmlf83Mnm0swB/87Nq6IP+YfDXPfPjwWwpNXIncwmRxuEdpVSUJY+/yqj4HRbu3t3Bvk9hfzV1GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EDbNb6Vb+OWw7VShiPqfZSZ25dYM4DfRl0RZV4NubNw=;
 b=B5p//aXXhZaHdZjENzrhSnDZK+yG+v6OW5g38NECFbMy0sVOPCSuaEX1ZxB86wZxr8zCo2y82J0Vfbtszw7YBWfQLvis4jvfvV2dU9dsnafMiHOhnb7GL+q9a8gkl96lg/XAVkbLpctaew8ivFL911UbnHmPeKUIXO+DAvmwpYE=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR0402MB3453.eurprd04.prod.outlook.com (2603:10a6:803:6::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.30; Wed, 25 Nov
 2020 15:47:45 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6%3]) with mapi id 15.20.3589.024; Wed, 25 Nov 2020
 15:47:44 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v4 3/7] dpaa_eth: limit the possible MTU range
 when XDP is enabled
Thread-Topic: [PATCH net-next v4 3/7] dpaa_eth: limit the possible MTU range
 when XDP is enabled
Thread-Index: AQHWwb81RSiLCuFrIkavmuj+QXmZ4anXp8MAgAFXdiA=
Date:   Wed, 25 Nov 2020 15:47:44 +0000
Message-ID: <VI1PR04MB58073DF4C65E3DB47192869BF2FA0@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1606150838.git.camelia.groza@nxp.com>
 <654d6300001825e542341bc052c31433b48b1913.1606150838.git.camelia.groza@nxp.com>
 <20201124191136.GB12808@ranger.igk.intel.com>
In-Reply-To: <20201124191136.GB12808@ranger.igk.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c0f19004-340d-405a-6c86-08d891597321
x-ms-traffictypediagnostic: VI1PR0402MB3453:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3453940781D00DA44C945BFAF2FA0@VI1PR0402MB3453.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M8BbtnoJlJKpLHsRIRwhiMeOKebv/1igcjsJ9tJa3Hrwi8wNS/grsxduUExyLct4g7sh/gVaE2yUR+O37KQ14Lv01gKUIO8SpceH17IISXlmxy8eDdw8RN/PrUVs14hPAY9gCqnDWrX9LHtSqIxh0NDN+FOwEL06OfC+CCR4cFtptGeuyDL053ovrf894UDQ/dH0D6zzNzpdvbgqS6VGjQVJBo2+EMAJpLoyUlXwqQv/TVNefmFv7NrQzGCu/7s2ryUjAmaYXW6D0QizGRVsdmbNqyHxBvB9bsXDrt81WnJYCyukfotOHqBY7RLxwPvexEZscBRez+7WeLaTiYYdsQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(64756008)(9686003)(66946007)(52536014)(66556008)(186003)(55016002)(71200400001)(26005)(6506007)(66446008)(76116006)(8676002)(478600001)(5660300002)(8936002)(83380400001)(7696005)(316002)(66476007)(86362001)(2906002)(54906003)(53546011)(6916009)(33656002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?tIvRjm6KIcPFlMbveV4RYCeN8xW1rjSKsqSi3oWcOAksvteTFkNUQMxUGWBf?=
 =?us-ascii?Q?MINx4tEt/qgSm4GcrotQY65GhWpprH+qnswh19qdwNmRha5mQmhbVpzTJwKi?=
 =?us-ascii?Q?xWDXXQ6TOdimJgaT9dgn2+1/ewaazSk3Kxpa2KfmfKXz0hFCCUkrAouciZD6?=
 =?us-ascii?Q?721xk81FHwTXFtIhB6dkUCruhf79bCprFiJdsUgQmzzNmkLoXft4G4IEVQxy?=
 =?us-ascii?Q?rEVWwQnHRHZ9x7a0hyG8ticRIJOiRiMEFUQMmu8Am28NGP9aWp5rb6j8Qvww?=
 =?us-ascii?Q?oxGeMMp5qdno92mH0JGXnGWnQkxTtUp1fuDMFJqw9zKwk9XFnv+HKK7eGUC0?=
 =?us-ascii?Q?sE+Xl16mvyINOiNtV7cC4LUGOoFUP4xluu2y5rkh9RusO49xgdijl7MWg8nk?=
 =?us-ascii?Q?dbtE/r2HMFXkVnrBobLnMVtOdHb5Ye7Zxp4Nyv8/iOja2Y+RSBmoMEZSNlAu?=
 =?us-ascii?Q?Sk2MEzIOdsLWiUuqbPq9uqcwYMiqU+qreh00+4zaJFT4xxcLXYwrlxxgL2JG?=
 =?us-ascii?Q?enbBnaFA6UszadMNExZ4lrR+0L6TreLWTvMgWNIZpfYRSmmm46QAw/+EltFd?=
 =?us-ascii?Q?mJKQhtQhkOzGcl7br/+iOtl3gq4K8rUYx1euP1xsZuf3I2FveFlZ/HjYhAtI?=
 =?us-ascii?Q?5N7n+4bk/coT5lTg7bGP+yGNXwda1J1LuxcD7tuVjjbbjm0JdeXtKTV2mhFG?=
 =?us-ascii?Q?V8ssLFXT+04P9U6CKNHE9ZuX9rLvMv2yhVaxIKMjDRbXJwRo9OL1ShijB3kt?=
 =?us-ascii?Q?tiJ703ZNqT7+6GzHlMhtuRIIFs8SOr/qGQOOlyMcAW06Xk7AfYyFWAf68miU?=
 =?us-ascii?Q?1lH5LjIoA9ptOkNhoF5pmyebaUMHU7woiRPnj45B626qCGCpAR+yYcGsQfV5?=
 =?us-ascii?Q?FvoPbWQAGCgL5aHpTgn+E5uhiGlAKaQy/keXU9dLhVgFpFt2tPLLXJMACjrL?=
 =?us-ascii?Q?SYOhphZhZ8JaKaMqHpcuc35PqpVftUmCRGpf0nTWveQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0f19004-340d-405a-6c86-08d891597321
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2020 15:47:44.1403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ylDUfO7hq2e29lssh4xeUSXItl6xnOg1NU2A9yQpQZUUFesIEpnENDi2pHDAOqgG8ZZKsx1ucrdwXhPx2wWYjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3453
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Tuesday, November 24, 2020 21:12
> To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Cc: kuba@kernel.org; brouer@redhat.com; saeed@kernel.org;
> davem@davemloft.net; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next v4 3/7] dpaa_eth: limit the possible MTU ran=
ge
> when XDP is enabled
>=20
> On Mon, Nov 23, 2020 at 07:36:21PM +0200, Camelia Groza wrote:
> > Implement the ndo_change_mtu callback to prevent users from setting an
> > MTU that would permit processing of S/G frames. The maximum MTU size
> > is dependent on the buffer size.
> >
> > Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> > ---
> >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 40
> ++++++++++++++++++++------
> >  1 file changed, 31 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > index 8acce62..ee076f4 100644
> > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > @@ -2756,23 +2756,44 @@ static int dpaa_eth_stop(struct net_device
> *net_dev)
> >  	return err;
> >  }
> >
> > +static bool xdp_validate_mtu(struct dpaa_priv *priv, int mtu)
> > +{
> > +	int max_contig_data =3D priv->dpaa_bp->size - priv->rx_headroom;
> > +
> > +	/* We do not support S/G fragments when XDP is enabled.
> > +	 * Limit the MTU in relation to the buffer size.
> > +	 */
> > +	if (mtu + VLAN_ETH_HLEN + ETH_FCS_LEN > max_contig_data) {
>=20
> Do you support VLAN double tagging? We normally take into acount to two
> vlan
> headers in these checks.
>=20
> Other than that:
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

No, we only account for one.

> > +		dev_warn(priv->net_dev->dev.parent,
> > +			 "The maximum MTU for XDP is %d\n",
> > +			 max_contig_data - VLAN_ETH_HLEN -
> ETH_FCS_LEN);
> > +		return false;
> > +	}
> > +
> > +	return true;
> > +}
> > +
> > +static int dpaa_change_mtu(struct net_device *net_dev, int new_mtu)
> > +{
> > +	struct dpaa_priv *priv =3D netdev_priv(net_dev);
> > +
> > +	if (priv->xdp_prog && !xdp_validate_mtu(priv, new_mtu))
> > +		return -EINVAL;
> > +
> > +	net_dev->mtu =3D new_mtu;
> > +	return 0;
> > +}
> > +
> >  static int dpaa_setup_xdp(struct net_device *net_dev, struct bpf_prog
> *prog)
> >  {
> >  	struct dpaa_priv *priv =3D netdev_priv(net_dev);
> >  	struct bpf_prog *old_prog;
> > -	int err, max_contig_data;
> > +	int err;
> >  	bool up;
> >
> > -	max_contig_data =3D priv->dpaa_bp->size - priv->rx_headroom;
> > -
> >  	/* S/G fragments are not supported in XDP-mode */
> > -	if (prog &&
> > -	    (net_dev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN >
> max_contig_data)) {
> > -		dev_warn(net_dev->dev.parent,
> > -			 "The maximum MTU for XDP is %d\n",
> > -			 max_contig_data - VLAN_ETH_HLEN -
> ETH_FCS_LEN);
> > +	if (prog && !xdp_validate_mtu(priv, net_dev->mtu))
> >  		return -EINVAL;
> > -	}
> >
> >  	up =3D netif_running(net_dev);
> >
> > @@ -2870,6 +2891,7 @@ static int dpaa_ioctl(struct net_device *net_dev,
> struct ifreq *rq, int cmd)
> >  	.ndo_set_rx_mode =3D dpaa_set_rx_mode,
> >  	.ndo_do_ioctl =3D dpaa_ioctl,
> >  	.ndo_setup_tc =3D dpaa_setup_tc,
> > +	.ndo_change_mtu =3D dpaa_change_mtu,
> >  	.ndo_bpf =3D dpaa_xdp,
> >  };
> >
> > --
> > 1.9.1
> >
