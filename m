Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBE35385AD
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 09:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbfFGHsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 03:48:02 -0400
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:6083
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727600AbfFGHsB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 03:48:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4emmIdrF2TKch01w7n7ahLyuw2SHxJYd/8A2gkF4PE=;
 b=OZIiREcnenpSzWX1cf4arB64KsHSvEqIu3CZxuhnw1G7ci3xq5sWmcwtfMstl4++WG3nqB6ecmGHu+tJDYg5yOqr3yNrItDFmMqGId0ylY/XMRrXtjyytPt5B1uEy1MWQe9EpmgqnD2lK0cI4Rsr9aoLhMt7O2V8MR+1QjZPHQo=
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com (20.177.40.15) by
 AM0PR04MB5187.eurprd04.prod.outlook.com (20.177.40.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Fri, 7 Jun 2019 07:47:57 +0000
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::5cc8:5731:41ba:1709]) by AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::5cc8:5731:41ba:1709%7]) with mapi id 15.20.1965.011; Fri, 7 Jun 2019
 07:47:57 +0000
From:   Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: RE: [PATCH net-next v2 2/3] dpaa2-eth: Support multiple traffic
 classes on Tx
Thread-Topic: [PATCH net-next v2 2/3] dpaa2-eth: Support multiple traffic
 classes on Tx
Thread-Index: AQHVHETmSdeY62UMKEO8gRxpdOxSk6aO632AgADkf3A=
Date:   Fri, 7 Jun 2019 07:47:57 +0000
Message-ID: <AM0PR04MB4994174563D3826C2561BFFF94100@AM0PR04MB4994.eurprd04.prod.outlook.com>
References: <1559811029-28002-1-git-send-email-ruxandra.radulescu@nxp.com>
        <1559811029-28002-3-git-send-email-ruxandra.radulescu@nxp.com>
 <20190606.110233.2117483278297401420.davem@davemloft.net>
In-Reply-To: <20190606.110233.2117483278297401420.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ruxandra.radulescu@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96ffd825-47b1-4f67-d8b3-08d6eb1c7518
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB5187;
x-ms-traffictypediagnostic: AM0PR04MB5187:
x-microsoft-antispam-prvs: <AM0PR04MB51878B1B5DCA6AB8038510A094100@AM0PR04MB5187.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(346002)(366004)(136003)(39860400002)(189003)(199004)(22813001)(13464003)(8936002)(316002)(8676002)(6916009)(7696005)(99286004)(186003)(6246003)(478600001)(102836004)(26005)(73956011)(14454004)(476003)(486006)(11346002)(53546011)(446003)(54906003)(71200400001)(81166006)(71190400001)(76116006)(81156014)(66946007)(64756008)(66476007)(66556008)(256004)(52536014)(5660300002)(25786009)(6506007)(66446008)(66066001)(4326008)(33656002)(229853002)(68736007)(86362001)(305945005)(6116002)(3846002)(2906002)(55016002)(74316002)(9686003)(7736002)(6436002)(53936002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5187;H:AM0PR04MB4994.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LGqIhGAgQt7m7vRu9GUNr62U7C/av2YGetEx6Sg2YnNk6pqXJbaHT97gpZ1KNeEMd4EVj6k4sf4K3vfAe1CLIGPVAqChSFyAoA03QIzedc74+RF1MzCf3RhZzz0RnpXEMB4fJSrXvajiBHs7ZFju1/aznwRl/4zqQpuo2IvqON1ewr1TYQxSomkG2+R06M6BJIkFBXx857P2UEBnjmqY9n15zJvrYETVWm3rgRgxOPjV01ZDDitW1LPcdqi2Xl/NVcOdeSUYj5WDkJByERFe6eKvsbL2QamIWpSQTsvGnx2ZqJ4G6UK/e4kZ7gL74jVVN6kRlnWXhlyw2k8ZCO0wOzwVpPkxgOoORvNs2rsDrdHAU+KK73VbiRupspNnYL2AEjTa85RknaPgruENJchNRviFPk0MuxV2PH5nOKzgVrY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96ffd825-47b1-4f67-d8b3-08d6eb1c7518
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 07:47:57.4488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ruxandra.radulescu@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5187
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Thursday, June 6, 2019 9:03 PM
> To: Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
> Cc: netdev@vger.kernel.org; Ioana Ciornei <ioana.ciornei@nxp.com>
> Subject: Re: [PATCH net-next v2 2/3] dpaa2-eth: Support multiple traffic
> classes on Tx
>=20
> From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> Date: Thu,  6 Jun 2019 11:50:28 +0300
>=20
> > DPNI objects can have multiple traffic classes, as reflected by
> > the num_tc attribute. Until now we ignored its value and only
> > used traffic class 0.
> >
> > This patch adds support for multiple Tx traffic classes; the skb
> > priority information received from the stack is used to select the
> > hardware Tx queue on which to enqueue the frame.
> >
> > Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> > ---
> > v2: Extra processing on the fast path happens only when TC is used
> >
> >  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 47
> ++++++++++++++++--------
> >  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h |  9 ++++-
> >  2 files changed, 40 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > index a12fc45..98de092 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > @@ -757,6 +757,7 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff
> *skb, struct net_device *net_dev)
> >  	u16 queue_mapping;
> >  	unsigned int needed_headroom;
> >  	u32 fd_len;
> > +	u8 prio =3D 0;
> >  	int err, i;
> >
> >  	percpu_stats =3D this_cpu_ptr(priv->percpu_stats);
> > @@ -814,6 +815,18 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff
> *skb, struct net_device *net_dev)
> >  	 * a queue affined to the same core that processed the Rx frame
> >  	 */
> >  	queue_mapping =3D skb_get_queue_mapping(skb);
> > +
> > +	if (net_dev->num_tc) {
> > +		prio =3D netdev_txq_to_tc(net_dev, queue_mapping);
> > +		/* Hardware interprets priority level 0 as being the highest,
> > +		 * so we need to do a reverse mapping to the netdev tc index
> > +		 */
> > +		prio =3D net_dev->num_tc - prio - 1;
> > +		/* We have only one FQ array entry for all Tx hardware
> queues
> > +		 * with the same flow id (but different priority levels)
> > +		 */
> > +		queue_mapping %=3D dpaa2_eth_queue_count(priv);
>=20
> This doesn't make any sense.
>=20
> queue_mapping came from skb_get_queue_mapping().
>=20
> The core limits the queue mapping value to whatever you told the
> generic networking layer was the maximum number of queues.
>=20
> And you set that to dpaa2_eth_queue_count():
>=20
> 	/* Set actual number of queues in the net device */
> 	num_queues =3D dpaa2_eth_queue_count(priv);
> 	err =3D netif_set_real_num_tx_queues(net_dev, num_queues);
>=20
> Therfore the modulus cannot be needed.

True, at this point it's not needed yet. This patch adds code in
preparation for patch 3/3, which does modify the maximum
number of queues on the device when multiple TCs are configured
via mqprio.

I can move it to the next patch where it's use is more clear.

Thanks,
Ioana
