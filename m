Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EB0424D67
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 08:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbhJGGtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 02:49:18 -0400
Received: from mail-eopbgr70041.outbound.protection.outlook.com ([40.107.7.41]:14916
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231279AbhJGGtR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 02:49:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+2N4a5HOVuz07glkuDvZmYYfGLknlfq9KjGuhkvSvwJFhwu74o3sGdv5w6plJr8mcnlehdeV36xbFSD/Brc9XwyRNk7yxTXcvZlJuwQ+dRITRvqYME6VMfcIPjmXwb1TLM5dnsK6Wzc26psZ4+GQwi2FQqOFE1gsiD0eoSie3kTOC52VxZDFg0OCWQPhg5LrRHK081jEATL5tbm8iNu1FFJjQ9VjwrdaDHSQSbT04Mc6Rlj41/bsqepQUeaiEjwQs7PwqwUy0/ZTtHHCTBCG1RfArPKvaKLsUiUn7BQGR4fxnLzAsct7Ar8/Rw9E4emc4jUlXx7C55OPuWw63CmbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YdYu2hxPgzIEUp5qWiye6GUdYPSth4yUjnzuNCgtywQ=;
 b=oU/YuW+sTq3XffIaH4YuxrDQ9+zsnGOvKUMq6lPfOsMNpgtw6L32UgG1qg262dklzDJTPrguneEeZUUPX8imc4fc3e2JGWXtKlT237A9tJdb8lyP35hK7p8eDXAcPywiGtlfKjKmjNZRPjazcysVmMYjoSP6jpw0/+X7lg6KxN2dYD1+kFWJS5HlN9bObNozz2mW3/CkRoWimiTKn/KgUpNF5Iev8eRpIIaBMoCmmJJrCobGf8aOXm+2VjSmBTzV/OVhPk2ooOPmqJJwpGJoY+0DNSKeQMbruPt9ARKfPbXCQBUimSXoxzbCsm/L/lgB9eFreFK+FJfbvYnOH9G/Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YdYu2hxPgzIEUp5qWiye6GUdYPSth4yUjnzuNCgtywQ=;
 b=JNqk87sxFaX865GRY50LdmUrJPRkZNM17ysYFjMd/wYELbyqZmxYxmJXAsZyjNfRWUlKLwFrhVV5YJDa9s9XgIkQPlWYhp+Vo2IxmrLRC1anIy3KKXBR5pf+bQ/DiIJN/me+d3G7xeUMlawr6lr8tu3KJpQXgU0B6vQiBLQPDBs=
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB7043.eurprd04.prod.outlook.com
 (2603:10a6:208:19b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Thu, 7 Oct
 2021 06:47:22 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 06:47:21 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 1/2] net: enetc: declare NETIF_F_IP_CSUM and do
 it in software
Thread-Topic: [PATCH net-next 1/2] net: enetc: declare NETIF_F_IP_CSUM and do
 it in software
Thread-Index: AQHXuu663/E+UlNFGk+PhpftRTMd8KvGrXcAgABrBQA=
Date:   Thu, 7 Oct 2021 06:47:21 +0000
Message-ID: <20211007064720.envusypxkazx6gz2@skbuf>
References: <20211006201308.2492890-1-ioana.ciornei@nxp.com>
 <20211006201308.2492890-2-ioana.ciornei@nxp.com>
 <20211006172418.0293de02@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211006172418.0293de02@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af45016b-92b3-4a51-b7c5-08d9895e5076
x-ms-traffictypediagnostic: AM0PR04MB7043:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB7043970DA5B9E83EC79F93E5E0B19@AM0PR04MB7043.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3I8l2UADlVDxtfJdDhjOcoomhVqJ2BjO/pX/7O3zb5jCmFduRvFfClTmUbs0RPu3Z59rYQS5gy5UtPZ1V3XgdL8j0yh2+fjLajqyeAlKhJvzjI9hw7BQb9HhQnYatF8GL4+c415e3fxmae3eZkdqUWTwtDydMbMkFl0QnoRJfA6dOofkLaxOxidp9IoTmAln+BiFfjWANh8Ap0BnSIDIx8eGwrwuIUOKLmtryg7roPSmbslVsxX3gUejVzpAYFzQOP80IRWj5y8oVmGetLVQ8KvOGDDSZrE6OeENybsl60CpucLMe6xxOQVH/PT4sIpBCuWcZ6sExoqe5prE4DTvqYhf4+eLRInOsw1f5usoowHh5LBKH0mIhDDEHMJBZ8PLY9akBjsrIgZS4MZ4ql8zVdm2ZetHvDXXFS8C5iJG19GVZX5O0brYCnKCCZQBcGHIlL44TGn804LdOmMt+Z7afLmVlbTdSwTHR3TGSTgINPCHUurBY53ysLO8DPGp12G/MxDqQSq+gAH313hkqRSjPuobVPEnqJoSLELyRhpyvsgoEbKumGVL9Vqdhja+HLKh9MUSCSQxIpTlE0fqibCTdf+vqm1jH3H68lzR/v2yXPWBg16sbbozCEJgfsZktWgjn98be8wexmZzETYAQxK6BtWrJtPGd0O/aOebImdLYzVzAE2vESkMoGv5pTxrjPDU61kiUr2gGVOvYoBJ/x7+eA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(6512007)(9686003)(66556008)(91956017)(5660300002)(76116006)(66446008)(64756008)(6506007)(71200400001)(66476007)(66946007)(26005)(316002)(54906003)(1076003)(186003)(86362001)(6486002)(38070700005)(6916009)(38100700002)(33716001)(44832011)(4326008)(8676002)(83380400001)(508600001)(2906002)(8936002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tfkC+212CRh8CBAAT6AKHvP0+WURi/Uiw6tlCr5iBS93tCw/1tn9mYxtoH9F?=
 =?us-ascii?Q?hUCjIKCbi2LyV1ffpNBDD36qjyGs+T/Z2+TZiGrH6gJpa3m3wa5wie+cYkGG?=
 =?us-ascii?Q?W9MNduxnnirfW8rZ6ew7HXUDQ4kXhpO/+eybKzGaW0KchUwvuOLTOj4V0H40?=
 =?us-ascii?Q?DY7H7a0+K6llUTmj9Rwb55TCHLXpCGHxbi0GCrqcGi4vRI5Ggi7bAO9eNt8s?=
 =?us-ascii?Q?BuRydN7APmltNx30Np5REbkECIfzBqndlP7BdIgvA3s7OBdG7+lN6QjbZtkt?=
 =?us-ascii?Q?xj6TNJkl0pYL9VPruWwi2VD93YFED1jkqG7t2kNh80VjWq48dyc6be4a4Jmr?=
 =?us-ascii?Q?HMZh/V2fkngpXBXOYYI6wpxp71EwFuSMIlNaDnM7ST7hG2uKnKRHTrXNGFqA?=
 =?us-ascii?Q?wi/hXmH+E3h1NdglxXRqbR1lzQ07mp+2eCbadhgNpGqxJE7aPzTcCUZW72OU?=
 =?us-ascii?Q?F6fvyX5JcUXHaac/fWxKq6S4TMP3JrdIpe24waCWi/fEYyHm+A8Q4Icvio3j?=
 =?us-ascii?Q?d1UGtxvODcaTvVrtnFtZUjWK2g5VDeGywxpdQc7IyKWpuDBFHIQeDmDBmm4m?=
 =?us-ascii?Q?uRvpIUix8geJcUADEsyrLle1Grx3flcZFrVcS+63nMTgxMgSvSHhFzn5agIM?=
 =?us-ascii?Q?QFMFKjdDjPsSzDX2XiJvOK2yjoIyxOSMBO2Tk2fcNpG8bNHdRpXY8D5+asqt?=
 =?us-ascii?Q?jB0YZIhAIdPCsX4VkA8Zdc1nxbOunR/Y6XN6EQwBqw0uWwDyPm4pwEbynGru?=
 =?us-ascii?Q?45S2puArmgNycJm7nz/KxGa8tMmfRvIW1dcAoDKejL9bGJu00SeN7muI9fZ4?=
 =?us-ascii?Q?EGqXEPHeCnKtFku0f+zkZUVZFf6f9B1vJHZMOCavYd6WpaH8yyBh2SygiOYN?=
 =?us-ascii?Q?Stu59uYdhQVYHqcbEtiyqNYrDTaWu9C8TuSYCSMW0+J23JLn0zYA9mV47Z27?=
 =?us-ascii?Q?G2msfkoBCSaRqx0xv5SaaOEj5TDBBZH+4+ED2gBSxqytoFBJNOev1n/qCsGG?=
 =?us-ascii?Q?/jyR5KTettGFAeVZS/+GKY5hkI2AlgTa1uxvGU4x++2xkpYC0pCYpj/e5Vd/?=
 =?us-ascii?Q?nQNfrNtf6HyEGKv9phOHtX04d/DWhL9oPeE+wh3lkSMyB3YmRMsbZ2Ny09PB?=
 =?us-ascii?Q?ULS39OmH1ucjkXo0S768AJ1FH8oc/xTS4kLWadEsdbYv2c5qIBZ2wHnT64mH?=
 =?us-ascii?Q?lhK2rMRebfXv8JNAnPaV80+t8fqeeE80le3eVdoA8Y1j/+GmaZ6ZPyRPkbSX?=
 =?us-ascii?Q?pIzX3pZqYr9ZquZaqmmFPrd4KGhzmSxcQUD3pHltp+e3PAIhDRTdk+Dl9K8P?=
 =?us-ascii?Q?9V5JxB2sW6368RMqdBqYzx3g?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C1F4041A62D3BC4EAB11C520C48FBCEC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af45016b-92b3-4a51-b7c5-08d9895e5076
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 06:47:21.8175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WlY+fzWscIU2gKes2AKLDytMqLd3OQX6qgPRxpkR0rmX16G67LmxD+ZmhiR6B0vuMjEE92zFDnWGbp/i12auYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7043
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 05:24:18PM -0700, Jakub Kicinski wrote:
> On Wed,  6 Oct 2021 23:13:07 +0300 Ioana Ciornei wrote:
> > This is just a preparation patch for software TSO in the enetc driver.
> > Unfortunately, ENETC does not support Tx checksum offload which would
> > normally render TSO, even software, impossible.
> >=20
> > Declare NETIF_F_IP_CSUM as part of the feature set and do it at driver
> > level using skb_csum_hwoffload_help() so that we can move forward and
> > also add support for TSO in the next patch.
> >=20
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>=20
> Did you choose NETIF_F_IP_CSUM intentionally?
> It'll only support IPv4, and since you always fall back to SW
> I'd think NETIF_F_HW_CSUM makes more sense.

Somewhat intentionally, yes.

If I would use NETIF_F_HW_CSUM, as I understand it, the GSO path, added
in the next patch, would have to compute the checksum not only for IPv6
but also for any other protocols other than UDP and TCP (which currently
it supports).
I just didn't look into that at the moment.

>=20
> > diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net=
/ethernet/freescale/enetc/enetc.c
> > index 3cbfa8b4e265..a92bfd660f22 100644
> > --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> > +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> > @@ -319,7 +319,7 @@ static netdev_tx_t enetc_start_xmit(struct sk_buff =
*skb,
> >  {
> >  	struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
> >  	struct enetc_bdr *tx_ring;
> > -	int count;
> > +	int count, err;
> > =20
> >  	/* Queue one-step Sync packet if already locked */
> >  	if (skb->cb[0] & ENETC_F_TX_ONESTEP_SYNC_TSTAMP) {
> > @@ -342,6 +342,12 @@ static netdev_tx_t enetc_start_xmit(struct sk_buff=
 *skb,
> >  		return NETDEV_TX_BUSY;
> >  	}
> > =20
> > +	if (skb->ip_summed =3D=3D CHECKSUM_PARTIAL) {
> > +		err =3D skb_csum_hwoffload_help(skb, 0);
> > +		if (err)
> > +			goto drop_packet_err;
> > +	}
>=20
> Any reason no to call skb_checksum_help() directly?

No, no reason. Will change.

Ioana=
