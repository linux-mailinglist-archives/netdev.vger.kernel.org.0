Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6D97CDFA2
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 12:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfJGKuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 06:50:22 -0400
Received: from mail-eopbgr150083.outbound.protection.outlook.com ([40.107.15.83]:37348
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727395AbfJGKuW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 06:50:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TULV3v5hSxrYb9VlOdsvvbfKqW0jJqQsOD0lh/35puWbY4bF0ww2Z//Hs4s/jXmxx1YKmAfbE3ShLczkMDoiqKrmd/475JB21qnuR0NvTUKYR2WCgTCEf2oAnTxHqO30wzOVi7Dj7aIwMJOCQ4WxcZWAMbnrAYs8u5Fmg6PdumG6MVirLQtq211kQSEY40PMfYDftfU3tnHHdx8sCJ/wsje6T+ov8X2tSMOjqRZVm21CL0aptdZqM8odxqb20mBWcShmWkTvweaxGvG2n/Ll4Df2cA4xOPL+e/O3XClztTN7TxUhZuE5boxywqwK0aRUS/8M+K1pr0TIHqHe/7JtdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhtWdcUOLRV62N/fXtayCeWEIKC84uhR0+fk1vFRDZ8=;
 b=Jpwlpi418MIUPZac3jHwC9LSOH6F7ZUyvIH75amb2QU7KPG31QL1538bklAP7Dyl28+BfQ7VSLDKCFwbLf1u5A077Pwdx4jOSBmtZRPwpqiogX6XDiB+UQumssuSZpTq33BgDPugIEKHYD9ZgIXKhFu8TcIPRnJqaHhY1kX4TfAmlNQy6FvtzpRfn6VyLdOKU7+PmH+xrz8agrydqc+9tQseUKkPiU1nPbH22RDmEORSXS8EyV2Xz0QM4UoZR4DMrzfhX9/gsW2THMzG12ZcwyNLoAaGivja2dKvy6LjKwoQvf3cOiU+na2TjBvN0xn0Hc/9XcAA1YNT34hFTM+how==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhtWdcUOLRV62N/fXtayCeWEIKC84uhR0+fk1vFRDZ8=;
 b=AS5EnoivLTSfbKMiCXj6BaJlZ+56KMu6bP1/bjzvCiEzzqkAvZYrQF3ZACsMztuJkSP+SqSKkOCU4OxQtUNryPuv8BnX4GMqvp84ikUwNa+D35oJy3SBI0r/493T9XHU6sJVrfxaSwlNmsFwX7vmWoqz411x0GedXukTeYj0m+k=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3678.eurprd04.prod.outlook.com (52.134.12.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Mon, 7 Oct 2019 10:49:40 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::9136:9090:5b7c:433d]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::9136:9090:5b7c:433d%9]) with mapi id 15.20.2327.025; Mon, 7 Oct 2019
 10:49:40 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: RE: [PATCH 3/3] dpaa2-eth: Avoid unbounded while loops
Thread-Topic: [PATCH 3/3] dpaa2-eth: Avoid unbounded while loops
Thread-Index: AQHVepU0WPmDXj1tREGmAIvBWqE3SqdKyxIAgAQ4/EA=
Date:   Mon, 7 Oct 2019 10:49:39 +0000
Message-ID: <VI1PR0402MB28009F24026451524BFD7235E09B0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1570180893-9538-1-git-send-email-ioana.ciornei@nxp.com>
 <1570180893-9538-4-git-send-email-ioana.ciornei@nxp.com>
 <20191004181828.GB9935@lunn.ch>
In-Reply-To: <20191004181828.GB9935@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 144227d5-45f9-432c-cfbc-08d74b140ddc
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR0402MB3678:|VI1PR0402MB3678:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB36781464F6A9CAA1C14CE102E09B0@VI1PR0402MB3678.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01834E39B7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(396003)(39860400002)(346002)(189003)(199004)(8676002)(229853002)(33656002)(6436002)(8936002)(6116002)(6916009)(478600001)(3846002)(55016002)(9686003)(14454004)(76176011)(81166006)(66446008)(64756008)(66556008)(99286004)(81156014)(54906003)(25786009)(316002)(7696005)(2906002)(256004)(6246003)(66476007)(66946007)(76116006)(66066001)(186003)(4326008)(71200400001)(102836004)(71190400001)(7736002)(52536014)(86362001)(305945005)(26005)(74316002)(446003)(476003)(486006)(11346002)(44832011)(5660300002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3678;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 20U5MRj/QJ8hSSF27igz6/W4cGQGYVPQ/XYjl5AlM48DpQSwgByNkQXt5oBtSgbsX+OWCRsEddvj9EarPevW7RioYHhdtEopEyKONk4QaRkVY7Px1nQPfwM4Xlzo4+TlPRPugkzvyeMKPDu8SQ6OReH7aN+ElmmIyFWYQ2WbgpqdAEeCoIpVquHC2sCO2Bqfj2SQQybicZBK/lHR7Xq834UtVfGg3VkhRDXQOANJN2P21UnEoRXIRxd/TJsVqC44bz83jy64Q0FIx9PX7vC6x7gGS03VqQaMQZQexT3bgfJYwofAzVTGJhsJD4eLHScUls9BA7z0NLR7A0Xz+eRDxBQHAy+vsf5fE8EfnYAgWRfCVQVKOGJMcSRWJ/PljzUzgogn2Ub5JJjz1h5wtEm+7XxFsxuettpckrGKGD6pYx4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 144227d5-45f9-432c-cfbc-08d74b140ddc
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2019 10:49:39.8809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: buq/vdtb7qkUcZF4ZplEtMrWNZrqyqcxt4bCggIdDft6BytOVxuXVcNnkaldOq8Hbi3ltWUKL9rQHkv909JpwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3678
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH 3/3] dpaa2-eth: Avoid unbounded while loops
>=20
> On Fri, Oct 04, 2019 at 12:21:33PM +0300, Ioana Ciornei wrote:
> > From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> >
> > Throughout the driver there are several places where we wait
> > indefinitely for DPIO portal commands to be executed, while the portal
> > returns a busy response code.
> >
> > Even though in theory we are guaranteed the portals become available
> > eventually, in practice the QBMan hardware module may become
> > unresponsive in various corner cases.
> >
> > Make sure we can never get stuck in an infinite while loop by adding a
> > retry counter for all portal commands.
> >
> > Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> >  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 30
> > ++++++++++++++++++++----
> > drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h |  8 +++++++
> >  2 files changed, 33 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > index 2c5072fa9aa0..29702756734c 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > @@ -221,6 +221,7 @@ static void xdp_release_buf(struct dpaa2_eth_priv
> *priv,
> >  			    struct dpaa2_eth_channel *ch,
> >  			    dma_addr_t addr)
> >  {
> > +	int retries =3D 0;
> >  	int err;
> >
> >  	ch->xdp.drop_bufs[ch->xdp.drop_cnt++] =3D addr; @@ -229,8 +230,11
> @@
> > static void xdp_release_buf(struct dpaa2_eth_priv *priv,
> >
> >  	while ((err =3D dpaa2_io_service_release(ch->dpio, priv->bpid,
> >  					       ch->xdp.drop_bufs,
> > -					       ch->xdp.drop_cnt)) =3D=3D -EBUSY)
> > +					       ch->xdp.drop_cnt)) =3D=3D -EBUSY) {
> > +		if (retries++ >=3D DPAA2_ETH_SWP_BUSY_RETRIES)
> > +			break;
> >  		cpu_relax();
> > +	}
> >
> >  	if (err) {
> >  		free_bufs(priv, ch->xdp.drop_bufs, ch->xdp.drop_cnt); @@ -
> 458,7
> > +462,7 @@ static int consume_frames(struct dpaa2_eth_channel *ch,
> >  	struct dpaa2_eth_fq *fq =3D NULL;
> >  	struct dpaa2_dq *dq;
> >  	const struct dpaa2_fd *fd;
> > -	int cleaned =3D 0;
> > +	int cleaned =3D 0, retries =3D 0;
> >  	int is_last;
> >
> >  	do {
> > @@ -469,6 +473,11 @@ static int consume_frames(struct dpaa2_eth_channel
> *ch,
> >  			 * the store until we get some sort of valid response
> >  			 * token (either a valid frame or an "empty dequeue")
> >  			 */
> > +			if (retries++ >=3D DPAA2_ETH_SWP_BUSY_RETRIES) {
> > +				netdev_err_once(priv->net_dev,
> > +						"Unable to read a valid
> dequeue response\n");
> > +				return 0;
> > +			}
> >  			continue;
>=20
> Hi Ioana
>=20
> It seems a bit odd that here you could return -ETIMEDOUT, but you print a=
n
> error, and return 0. But in the two cases above in void functions, you do=
n't print
> anything.
>=20
> Please at least return -ETIMEDOUT when you can.

Hi Andrew,

That's a good point. I'll send out a v2 fixing this.

Thanks,
Ioana

>=20
>        Andrew
