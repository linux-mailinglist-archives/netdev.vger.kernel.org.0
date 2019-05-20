Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B411822A66
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 05:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbfETDZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 23:25:51 -0400
Received: from mail-eopbgr140072.outbound.protection.outlook.com ([40.107.14.72]:45896
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726014AbfETDZv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 May 2019 23:25:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5a04ww42klEVPu7XYt2J5twDiXBZiE5QRxS1J7a/MQ=;
 b=ESFJroydoSbPDStFExshrPJ4JBrKKlf0nV+b7PRmADLBY+TJqp5UudQ+OUI79R6QukywTrAXj1Pe8uds4C7w5bbLtA6YuVaZ4kPU6dNKm5SRGZwCLInOeDk5S6lgGAUSC6kb+k6TClx1QiFBRPuy3WhAi6eCoRoVoIBMdw+EqJs=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2366.eurprd04.prod.outlook.com (10.169.134.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Mon, 20 May 2019 03:25:45 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986%3]) with mapi id 15.20.1900.020; Mon, 20 May 2019
 03:25:45 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] enetc: add hardware timestamping support
Thread-Topic: [PATCH 1/3] enetc: add hardware timestamping support
Thread-Index: AQHVC/xYQ2w4Gq0RdEuPdLhmipvA1KZzXh8A
Date:   Mon, 20 May 2019 03:25:45 +0000
Message-ID: <VI1PR0401MB22377C6B1B8C35F133E86DB4F8060@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <20190516100028.48256-1-yangbo.lu@nxp.com>
 <20190516100028.48256-2-yangbo.lu@nxp.com>
 <20190516143251.akbt3ns6ue2jrhl5@localhost>
 <VI1PR04MB4880B9B346D29E0EFC715D28960A0@VI1PR04MB4880.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB4880B9B346D29E0EFC715D28960A0@VI1PR04MB4880.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0791374d-a918-40ba-62a0-08d6dcd2d8d6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2366;
x-ms-traffictypediagnostic: VI1PR0401MB2366:
x-microsoft-antispam-prvs: <VI1PR0401MB2366CDAE4B7F22EA6BBFCB04F8060@VI1PR0401MB2366.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 004395A01C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(376002)(366004)(346002)(396003)(52314003)(13464003)(199004)(189003)(486006)(66946007)(76116006)(66476007)(66556008)(256004)(68736007)(446003)(11346002)(476003)(8676002)(81156014)(81166006)(8936002)(52536014)(66446008)(73956011)(14444005)(64756008)(71190400001)(71200400001)(5660300002)(186003)(110136005)(102836004)(6506007)(6436002)(53546011)(33656002)(26005)(99286004)(54906003)(76176011)(7696005)(229853002)(316002)(55016002)(478600001)(66066001)(14454004)(7736002)(305945005)(74316002)(53936002)(6246003)(25786009)(3846002)(6116002)(9686003)(4326008)(86362001)(2906002)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2366;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ci6XAUG2OaWnwCzIv9y55P5+/auSPPuWyxRjywbb2zhgZAbA4/Eo4PycaQo4zBxB81XuHPAPzuKUKdl6MZaoozplSP6Yh1ZLMSz0m8QHwPm70PgrlsQWk1KRTnSx1RghhdS+WAqMiJ2h+A40tsdh8vKrk3DvJEgv/cUW9amLcCplVEXR57Dug4oy2AEvIAasV2+pA3QMgwNEafmY2S++0DU/gNRoF+5TStGY2BfGSLAjU4lzch+w66RJx7CwGv6BVpgWqzIg1Y8bzL+Iyxce8s+MMT0Ggqtypv7iQ6Bbd/Y32nQhTbNGEpvfuhXkI93orLO/ZD2kpu+UBYWquBboKohkoX+J7OvHAwxEVam4PBvV9ZrQmPsUYNewhTwj4bF8ZvvRj6/6ZP1xo8R18veVqejLLAl6hYBh/QNz/fu4t6Q=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0791374d-a918-40ba-62a0-08d6dcd2d8d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2019 03:25:45.7504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2366
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> -----Original Message-----
> From: Claudiu Manoil
> Sent: Thursday, May 16, 2019 11:31 PM
> To: Richard Cochran <richardcochran@gmail.com>; Y.b. Lu
> <yangbo.lu@nxp.com>
> Cc: netdev@vger.kernel.org; David Miller <davem@davemloft.net>; Shawn
> Guo <shawnguo@kernel.org>; Rob Herring <robh+dt@kernel.org>;
> devicetree@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org
> Subject: RE: [PATCH 1/3] enetc: add hardware timestamping support
>=20
>=20
> >-----Original Message-----
> >From: Richard Cochran <richardcochran@gmail.com>
> >Sent: Thursday, May 16, 2019 5:33 PM
> >To: Y.b. Lu <yangbo.lu@nxp.com>
> >Cc: netdev@vger.kernel.org; David Miller <davem@davemloft.net>; Claudiu
> >Manoil <claudiu.manoil@nxp.com>; Shawn Guo <shawnguo@kernel.org>;
> Rob
> >Herring <robh+dt@kernel.org>; devicetree@vger.kernel.org; linux-arm-
> >kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> >Subject: Re: [PATCH 1/3] enetc: add hardware timestamping support
> >
> >On Thu, May 16, 2019 at 09:59:08AM +0000, Y.b. Lu wrote:
> >
> [...]
> >
> >>  static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int
> >> napi_budget)  {
> >>  	struct net_device *ndev =3D tx_ring->ndev;
> >> +	struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
> >>  	int tx_frm_cnt =3D 0, tx_byte_cnt =3D 0;
> >>  	struct enetc_tx_swbd *tx_swbd;
> >> +	union enetc_tx_bd *txbd;
> >> +	bool do_tstamp;
> >>  	int i, bds_to_clean;
> >> +	u64 tstamp =3D 0;
> >
> >Please keep in reverse Christmas tree order as much as possible:
>=20
> For the xmass tree part, Yangbo, better move the priv and txbd declaratio=
ns
> inside the scope of the if() {} block where they are actually used, i.e.:
>=20
> 		if (unlikely(tx_swbd->check_wb)) {
> 			struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
> 			union enetc_tx_bd *txbd;
> 			[...]
> 		}
>=20

[Y.b. Lu] Will do that.

> >
> >	union enetc_tx_bd *txbd;
> >	int i, bds_to_clean;
> >	bool do_tstamp;
> >	u64 tstamp =3D 0;
> >
> >>  	i =3D tx_ring->next_to_clean;
> >>  	tx_swbd =3D &tx_ring->tx_swbd[i];
> >>  	bds_to_clean =3D enetc_bd_ready_count(tx_ring, i);
> >>
> >> +	do_tstamp =3D false;
> >> +
> >>  	while (bds_to_clean && tx_frm_cnt < ENETC_DEFAULT_TX_WORK) {
> >>  		bool is_eof =3D !!tx_swbd->skb;
> >>
> >> +		if (unlikely(tx_swbd->check_wb)) {
> >> +			txbd =3D ENETC_TXBD(*tx_ring, i);
> >> +
> >> +			if (!(txbd->flags & ENETC_TXBD_FLAGS_W))
> >> +				goto no_wb;
> >> +
> >> +			if (tx_swbd->do_tstamp) {
> >> +				enetc_get_tx_tstamp(&priv->si->hw, txbd,
> >> +						    &tstamp);
> >> +				do_tstamp =3D true;
> >> +			}
> >> +		}
> >> +no_wb:
> >
> >This goto seems strange and unnecessary.  How about this instead?
> >
> >			if (txbd->flags & ENETC_TXBD_FLAGS_W &&
> >			    tx_swbd->do_tstamp) {
> >				enetc_get_tx_tstamp(&priv->si->hw, txbd, &tstamp);
> >				do_tstamp =3D true;
> >			}
> >
>=20
> Absolutely, somehow I missed this.  I guess the intention was to be able =
to
> support multiple
> if() blocks for the writeback case (W flag set) but the code is much bett=
er off
> without the goto.

[Y.b. Lu] Will use this to support current single tstamp writeback case.

>=20
> >>  		enetc_unmap_tx_buff(tx_ring, tx_swbd);
> >>  		if (is_eof) {
> >> +			if (unlikely(do_tstamp)) {
> >> +				enetc_tstamp_tx(tx_swbd->skb, tstamp);
> >> +				do_tstamp =3D false;
> >> +			}
> >>  			napi_consume_skb(tx_swbd->skb, napi_budget);
> >>  			tx_swbd->skb =3D NULL;
> >>  		}
> >> @@ -167,6 +169,11 @@ struct enetc_cls_rule {
> >>
> >>  #define ENETC_MAX_BDR_INT	2 /* fixed to max # of available cpus */
> >>
> >> +enum enetc_hw_features {
> >
> >This is a poor choice of name.  It sounds like it describes HW
> >capabilities, but you use it to track whether a feature is requested at
> >run time.
> >
> >> +	ENETC_F_RX_TSTAMP	=3D BIT(0),
> >> +	ENETC_F_TX_TSTAMP	=3D BIT(1),
> >> +};
> >> +
> >>  struct enetc_ndev_priv {
> >>  	struct net_device *ndev;
> >>  	struct device *dev; /* dma-mapping device */ @@ -178,6 +185,7 @@
> >> struct enetc_ndev_priv {
> >>  	u16 rx_bd_count, tx_bd_count;
> >>
> >>  	u16 msg_enable;
> >> +	int hw_features;
> >
> >This is also poorly named.  How about "tstamp_request" instead?
> >
>=20
> This ndev_priv variable was intended to gather flags for all the active h=
/w
> related features, i.e. keeping count of what h/w offloads are enabled for=
 the
> current device (at least for those that don't have already a netdev_featu=
res_t
> flag).
> I wouldn't waste an int for 2 timestamp flags, I'd rather have a more gen=
eric
> name.
> Maybe active_offloads then?
>=20
> Anyway, the name can be changed later too, when other offloads will be
> added.

[Y.b. Lu] How about using active_offloads, and add TODO comments in enum en=
etc_active_offloads?

>=20
> Thanks,
> Claudiu
