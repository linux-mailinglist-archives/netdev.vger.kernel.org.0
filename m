Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 416139FD53
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 10:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfH1Ikh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 04:40:37 -0400
Received: from mail-eopbgr50085.outbound.protection.outlook.com ([40.107.5.85]:9026
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726259AbfH1Ikh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 04:40:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LHYDU/bz3vKo99k1VOm/SlSpedJKWh3GvNNr6QSoxS94NXiFC3vevNoIbbn67X3IEeltg3vj4dOCHGUBz6F81RmLo+KGgDk2qbSB9zzjxsH1CNH8o7XRQVx7blDAWRgUU1CrgUEoLCjLQ9OcJ/DpRchJyoD3xICtoU6+s4xsvJrAfx2Lu+JftRuqURa2zEaPxECa0Q5kNX1/fRmI5trnIeija6cwSJ68+KwK48FR5qMEtfCPeIsDeI7vKpJ9fahUMFGC0IdUNqydJ6vu/uRuy0fwUIF9AK6OwvSVH0s03PA2NUbnlXRVyFVVCUcsvrOZ2h8SQeqxn4AANZWJOlpxLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+GSmbb8R7pDzKlXzn0OVRvwONO7XOtbLXklGufvl30=;
 b=SFkgmKi13n8XcohYIlU4SufXX4zL6FZiEoD1YSIfjuHk+wIkIgbbm6W/sb48rBFMaV5IsZUTq+iTAaaceF5JFK3HhyDWFZxlvnadI5N+I6fyNYmQCQgkxN//f4a6JTJbSeyFh92P+JSvSTuteoibxOX5MEzWNZlMInIDgZoBSlLsGdoh0X1WgOiMgGy4VNdnfXROBYdhu22wyns71YSiJWdt/x6yL3VMiUV95inMdFrVJz1saYzFzMBJyQ32EmYtl69F3K502xeVYY3Y78RBm3DEVRM3MXnpWdpmgO8rtkdDTHSYZdIGrL+/owottlqIkMebsE+J2SzBPn8IelZXbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+GSmbb8R7pDzKlXzn0OVRvwONO7XOtbLXklGufvl30=;
 b=n8L9QbfVNjp1a6GwpxY1A/iKZzUy4KbL5XlnCDoGBDwftWXRm1gXQ9+E5HX5Yuw1gx1tvnNie/zlgXt6nwRvCa1JBsZ0mY1rNfUOLM9X3ufj/XZVD5Gb8cb6hhZK4GDECL/h2IE4+92fsepmZb61lFYi7jX66ZU7Un8jF99tvDw=
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com (20.176.215.215) by
 AM0PR04MB4402.eurprd04.prod.outlook.com (52.135.148.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Wed, 28 Aug 2019 08:40:30 +0000
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::7c59:27fe:bf98:9ca1]) by AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::7c59:27fe:bf98:9ca1%3]) with mapi id 15.20.2199.021; Wed, 28 Aug 2019
 08:40:30 +0000
From:   Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: RE: [PATCH net-next v2 3/3] dpaa2-eth: Add pause frame support
Thread-Topic: [PATCH net-next v2 3/3] dpaa2-eth: Add pause frame support
Thread-Index: AQHVXOHwEnzATQvhVUKWTCVk21Za6KcPoo4AgACY1LA=
Date:   Wed, 28 Aug 2019 08:40:29 +0000
Message-ID: <AM0PR04MB499496AC09FD7BE58AE7B9C394A30@AM0PR04MB4994.eurprd04.prod.outlook.com>
References: <1566915351-32075-1-git-send-email-ruxandra.radulescu@nxp.com>
 <1566915351-32075-3-git-send-email-ruxandra.radulescu@nxp.com>
 <20190827232132.GD26248@lunn.ch>
In-Reply-To: <20190827232132.GD26248@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ruxandra.radulescu@nxp.com; 
x-originating-ip: [82.144.34.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c840d8b1-d49c-4d70-2fec-08d72b936203
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB4402;
x-ms-traffictypediagnostic: AM0PR04MB4402:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB44020B39C3F660A053AB13DE94A30@AM0PR04MB4402.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(13464003)(199004)(189003)(71200400001)(66066001)(6916009)(186003)(3846002)(6116002)(6246003)(316002)(26005)(33656002)(9686003)(4326008)(7696005)(53936002)(25786009)(6506007)(53546011)(11346002)(76176011)(99286004)(486006)(476003)(446003)(6436002)(55016002)(76116006)(256004)(86362001)(66556008)(305945005)(64756008)(66446008)(66476007)(81166006)(7736002)(71190400001)(54906003)(52536014)(8676002)(102836004)(74316002)(66946007)(14444005)(229853002)(14454004)(81156014)(478600001)(5660300002)(2906002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4402;H:AM0PR04MB4994.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8Kz4m5DnOUJEn6zQ2fvEh99tO0MWYpeU3bL1FFiBuMt3xcths9B+FWuhCDluPZdASjnlhM9TDTdir2I2MJ8eL7kk85sAUu/DyHz0Pp6Q8bo9mXZDQH9ybUFWbt1esi4X3MbIkb7nMtCaFsWjh8zYyaUsNuJwOP5t7OtS+r7Z7byDSchohUmhr6tUIogMFhRapNGAX6pbh/qkpFfg1YnVHwiuxHhN79DvN1asCBRDS1oy1CxccGw03eHnVpTTlTf6aQsEaRkXQPIzUQ4aw5vmsGB5yNuav1+c/ygfzSUOOOphTnGIJkUHAMuA2QeTcDHDa7AYK7bYu2bShbIbVdz1qwDde76P/mEQ4E1uIrxcFUao3CVGD618IqahlnIizSHA3Psn/VSqzGNC28jUwOG+0O6vUNnifweVOc5LOkwp47Q=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c840d8b1-d49c-4d70-2fec-08d72b936203
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 08:40:29.9618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HrLbpibZYr9g+nMTZaZaF7TOw0nZVNXsIAWIei28MYPpi7QgYf197qN1tc04mhYhYJ5ylcIG91Mfu20JJDqbcgffLKBrPoNpqzI4hORFp18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4402
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, August 28, 2019 2:22 AM
> To: Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; Ioana Ciornei
> <ioana.ciornei@nxp.com>
> Subject: Re: [PATCH net-next v2 3/3] dpaa2-eth: Add pause frame support
>=20
> On Tue, Aug 27, 2019 at 05:15:51PM +0300, Ioana Radulescu wrote:
> > Starting with firmware version MC10.18.0, we have support for
> > L2 flow control. Asymmetrical configuration (Rx or Tx only) is
> > supported, but not pause frame autonegotioation.
>=20
> > +static int set_pause(struct dpaa2_eth_priv *priv)
> > +{
> > +	struct device *dev =3D priv->net_dev->dev.parent;
> > +	struct dpni_link_cfg link_cfg =3D {0};
> > +	int err;
> > +
> > +	/* Get the default link options so we don't override other flags */
> > +	err =3D dpni_get_link_cfg(priv->mc_io, 0, priv->mc_token, &link_cfg);
> > +	if (err) {
> > +		dev_err(dev, "dpni_get_link_cfg() failed\n");
> > +		return err;
> > +	}
> > +
> > +	link_cfg.options |=3D DPNI_LINK_OPT_PAUSE;
> > +	link_cfg.options &=3D ~DPNI_LINK_OPT_ASYM_PAUSE;
> > +	err =3D dpni_set_link_cfg(priv->mc_io, 0, priv->mc_token, &link_cfg);
> > +	if (err) {
> > +		dev_err(dev, "dpni_set_link_cfg() failed\n");
> > +		return err;
> > +	}
> > +
> > +	priv->link_state.options =3D link_cfg.options;
> > +
> > +	return 0;
> > +}
> > +
> >  /* Configure the DPNI object this interface is associated with */
> >  static int setup_dpni(struct fsl_mc_device *ls_dev)
> >  {
> > @@ -2500,6 +2562,13 @@ static int setup_dpni(struct fsl_mc_device
> *ls_dev)
> >
> >  	set_enqueue_mode(priv);
> >
> > +	/* Enable pause frame support */
> > +	if (dpaa2_eth_has_pause_support(priv)) {
> > +		err =3D set_pause(priv);
> > +		if (err)
> > +			goto close;
>=20
> Hi Ioana
>=20
> So by default you have the MAC do pause, not asym pause?  Generally,
> any MAC that can do asym pause does asym pause.

Clearing the ASYM_PAUSE flag only means we tell the firmware we want
both Rx and Tx pause to be enabled in the beginning. User can still set
an asymmetric config (i.e. only Rx pause or only Tx pause to be enabled)
if needed.

The truth table is like this:

PAUSE | ASYM_PAUSE | Rx pause | Tx pause
----------------------------------------
  0   |     0      | disabled | disabled
  0   |     1      | disabled | enabled
  1   |     0      | enabled  | enabled
  1   |     1      | enabled  | disabled

Thanks,
Ioana
