Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415315203A1
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239659AbiEIRed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239648AbiEIReb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:34:31 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2040.outbound.protection.outlook.com [40.107.21.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26139266F16;
        Mon,  9 May 2022 10:30:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jNrcvtMlVpjo4vl2l3fJiyZE0zmKw4Xo05Y9vS12ozz7C+7nQSLcVu5BtD1U0e67kDIXtww4DTPmYkaYq81tW0Ya+OS5qgQNyD94KA+YFc2PubiWJw6UkQBnlKGHLu3xQ8pW7ZY0tNreD4yjTTOgjBM+gpNdbqUI8SGoc2eWcr+DAsN1EcenHSKM7u/OqRc+EDoNX3NGplz6TwVBIEONekZQfS8K4+MtE0woTp9OIpMqo2tb7utJZEhDhG3QaHzbSCiizdUcxrqQOo/oQfOs1n6lIuHhWgSKgbBeYnFKCs1ObxlsC2HXoh+vKxH2mWn0e8IhhhbCdnzbEG1am0VESQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XxbH5mLbabYVt6CGW/9g+MMC+7WgIpe1gcnbHlKuPDM=;
 b=R+lISLRDj7k/o8HVTRDLDww2jYFXFh4z4PCH4WApWzID7FEXwBtnyAfzzt5sxUteLE+omS57fxuZc8hbYa1a0wzm4RaKDLN+uRE6bhgqFFzavsZagtfaAKqDmNJLfuGbtdNvmfERntDf0skTyhqHbmOy4k9eU7l5arRwFyY/RKiCim57du0BvBtTQpEKbfW05vJn+1Mns07NRbtCLoIrtAl7dqG8QtRy8ddEZB5ehwlv+XPXxZK7F1hGDnhlpmYi3DuDXu9vwmysJqCfaSfj1G3m3YLOMcn4XNboC96cRvppKUW0bdeWvx17EpCgQzkNW/b7I64/w6yC1DsvkJ9Dyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxbH5mLbabYVt6CGW/9g+MMC+7WgIpe1gcnbHlKuPDM=;
 b=FtQdWIWk99qq03UMxqTh0DIOifeLsYF+Oflfi+kOs0TdgIUGTJ4OYLaFXmUujeO+ZmY1dKgXa/SP4wGh5+8e40gXHRZgInVC3tSphl8BXzK67qSRYg3RN8TxTB3vNpxWsRfcOs9i+rGOgiZPD9BFFJzrgNEH3CKnXJTL+mOxDPw=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM6PR04MB5557.eurprd04.prod.outlook.com (2603:10a6:20b:96::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Mon, 9 May
 2022 17:30:30 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Mon, 9 May 2022
 17:30:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [RFC v8 net-next 15/16] net: dsa: felix: add phylink_get_caps
 capability
Thread-Topic: [RFC v8 net-next 15/16] net: dsa: felix: add phylink_get_caps
 capability
Thread-Index: AQHYYwz+Nv3GsOP+t02gQrIoyWAlJK0WWrEAgADnkAD//4yZgA==
Date:   Mon, 9 May 2022 17:30:30 +0000
Message-ID: <20220509173029.xkwajrngvejkyjzs@skbuf>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-16-colin.foster@in-advantage.com>
 <20220509103444.bg6g6wt6mxohi2vm@skbuf>
 <20220510002332.GF895@COLIN-DESKTOP1.localdomain>
In-Reply-To: <20220510002332.GF895@COLIN-DESKTOP1.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30bb1d09-c799-4545-a64b-08da31e19d8d
x-ms-traffictypediagnostic: AM6PR04MB5557:EE_
x-microsoft-antispam-prvs: <AM6PR04MB5557101DA821AD04B91CFB2BE0C69@AM6PR04MB5557.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /nYOSMxxxntbLPHiIhA/+TMAULgGsIXqYg30QbeNaZs+cw9u/R2IZQXqh2AiICTH+lsJOApgJ6kucukgSzvp8qooHS4FXDZnYqTgcGAPoPEGJVZ0XEmd8lD67jfgtG2Uj13uqpV7KnZ6R0d2MC7BvG+40cCxo0b5D6nHKdXqavcpI2KZ3DgV8xR6zu5x013MjBIkcV5/fa0+QVk3zfpm57cJF1xwGI4xJDCYIQdbUn1gpgoTKKQAgnnojTA/SE+oD318NEmmIn3/YVoUk/hEXpRoLtnvtrJh1N1zHwf3U+jwUmZb1ZmIivuzJgmdmFlhtkyK9MaCQFnCQd9dsFG+VUMbkbmdfIg3diC27eNErQgex7ADcdsQOwXzfUnltgbHVT/JS5wNsD8zzSL0FL6wQXEodPJiiks5b8Iff2GkbuMwzmxVuiAyS1SayqiMwmqCSefHGAsljEtVfuUF4V3Rj0MdNBtSILkvpC/QrA6CpjiiZlH62s/JzQNXdpC+av6D5J2iDkc1XAERHwYPXKptHLXC5Q7+ig3m9Y39Qk/rfvw1HTDZHkNt85Z6c1LjpyRtouNEED87139OfBb/JEfRE8GYPO1taTJmiPGECPw+DSdYwE7kBfZb5tIHSr6Jo/sgiZQFPsfPBKfOpxro/YuQi8l3TfsKMsq4Q1BmkKdklqQevCvh8vd7L4oumeAD9SpHgSqE+hCN8z1XPnAjERCUuexXJrl5p+zvxXbmhD8BO9Z8Aiou4O3qa5RD9DthBOnC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(66446008)(66476007)(316002)(4326008)(64756008)(8676002)(7416002)(54906003)(6916009)(66556008)(83380400001)(76116006)(66946007)(44832011)(1076003)(38070700005)(186003)(38100700002)(71200400001)(33716001)(6486002)(6506007)(8936002)(122000001)(86362001)(26005)(3716004)(5660300002)(9686003)(2906002)(6512007)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hNhuW+ClqeNGOnVhiy8w1VRECIkq1ct7P+alt1s9EruINt4N0FlnXZ51DP57?=
 =?us-ascii?Q?rkRcOUzOsAo8G+uEBb5pOlUvG0Sas1hGXXX0fsE8bVkDE2dmkdbJi78cDPy0?=
 =?us-ascii?Q?45QuURVeGUDIuxQ6QFcFb5gSD/bFeFs+G2y/9iOU5TI6W6ouq9RdM2lpFamN?=
 =?us-ascii?Q?o7ly5Z4GVF6ebE4WC7Zl7UYyD3B5XLeHgi7QaC5HJ+W0mfZu5lZj5P8eH58d?=
 =?us-ascii?Q?GPegU+8lHg+R8yFbfkZfNfY4WlMh7IgkMwwgAq9cdr6sH0LO9Mwm1GPjIRPM?=
 =?us-ascii?Q?mBTY0BIIBC5k6tuD49VEOfM1nOPasreZkz1+dbEZYX0Kk6ctZgTRlVIMX+aK?=
 =?us-ascii?Q?rzpkd81EDj02QGAKXymGoeW6nl0bCE5Js/U3OcQJyFJoPVwXXH4IWXjzZwNh?=
 =?us-ascii?Q?vCPh833xKZ2I9KjG6uMxx4tqQG/H17oSpCk9qn2zaKqV1wQujWsljB2k6sR3?=
 =?us-ascii?Q?7fb2H3urcSPEhwxmyCmoh7WWi9hzKRJL5lLG/kK3kz9eo+DaeOucO/HZ+xfo?=
 =?us-ascii?Q?XX5vmUg2T0P8oP7mawWCQ1tdY3H+lYGrUb/5cg65SmbIy32A4jrFJ5EuYD8E?=
 =?us-ascii?Q?O7ydYHfdEDYptx8+JnsOMN36QZrTKSJ1sHb8PzYuwWC/0EmspRjM9ElGpNjD?=
 =?us-ascii?Q?AtcsvXq60vSY5csXNqdaW8j6dveNUkEKiqja3JFdETSViKoYR5HTrjHqILLb?=
 =?us-ascii?Q?tYCo7WHDMCZ8PNPZHxvqM+QJhjBV5o+b5TYxQH5T9ILOeyARqVw+SdtR5Kla?=
 =?us-ascii?Q?Gv9mZFKPjOqyLC6E9NzEK9oJ/pLYLTzWvQlF6/K6N/xIu4pDM5yDb+Fk7okv?=
 =?us-ascii?Q?f9Bzx+oFbXvwOv4ZidHgdf15b7LxOXzILr4ES3M4oi1w7IHDhqyrjVD48sw6?=
 =?us-ascii?Q?a+FMHde7RfocsGTgyK2nx0kpm4uO0LyzMY4kdfWtzary4KNbydgtp7U6JKvf?=
 =?us-ascii?Q?wu3kKWDVZpqt054bq01WssIGdJLulSWZ3RnjvSQFuj4UY4TJdxTu4CIyYn1s?=
 =?us-ascii?Q?Ku/sHyIW8aOkm9INA3MGGrTg5NpLxXNVmRS4XyZANTlmOuX729H+eOkb3Bg9?=
 =?us-ascii?Q?jze36hnT8L9UQrKCA75VQzHnlk4RwETN2L7ymVP6YntD1tc//SqC3/IaUv3r?=
 =?us-ascii?Q?107cF+C+JJT13vKYN+GZe8syQHAL0IDBGl0Gm5EOtkyuLm91qW/DEw7xhyUk?=
 =?us-ascii?Q?k3x3+qLoNN4b4Q7oX6uo9lVaUy4WRGVwyGkqLyG5u7Z5alLKdCxUVATcKdO0?=
 =?us-ascii?Q?MWc3CpyWy1zVoSYW+hQEUrdPh5pOz+9o7B9kBteEc5coyv9x68wuQvb5yyUm?=
 =?us-ascii?Q?cSLhgkMpKEf+8HDEhkFwBZqDnGuqJb6rPLaQArjq3Yt8jZTu22E0+AEt4Cce?=
 =?us-ascii?Q?BqWPhI0EbueYqKTO6EZ1xh7ZVolFpn8oCUV2P7z47OWmiqcpbxnelKGUMczT?=
 =?us-ascii?Q?7n0Kt2dn0wadAPx/fxlfAMJfn/sFK3GjnVObhBBuETeiDBfHK6oCSjOxPRLl?=
 =?us-ascii?Q?/aO+CmBNNU+Ps0smmME5DUmb4LiaPYBPdHYRcbCQnQGe1o6ywArmbZKL3gWn?=
 =?us-ascii?Q?ckFfequeZDmy+zdsID4fTf87UZ5/bFnUmUtokEbSQiXFpWiLX0nK/hwJzBT8?=
 =?us-ascii?Q?23NBYnL59wLh0387e+GcSi4KbKXhkDV8K3KkvlhxqLYSlN+j2phkGZU//0T+?=
 =?us-ascii?Q?PIq0eWSBlUVa3tNUwiV3iHJhslJ2MM3eiDy28cQQjVhdkKeIJzKdXvjYsmkF?=
 =?us-ascii?Q?hs6vvEp6eZvCAB2wWW1gtGJoc0n7dRw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11461626CD131F489C1A9F9AD20DDF69@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30bb1d09-c799-4545-a64b-08da31e19d8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 17:30:30.6742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fosOIqm5XNg6L2PamcCzG+/OMIbHXfU8rejiAvFnrH/1Aq1cHrjMoSvZ+N3+obSpJZlh5NWdSIv+A22ScyIWeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5557
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 05:23:32PM -0700, Colin Foster wrote:
> > > @@ -982,15 +982,23 @@ static void felix_phylink_get_caps(struct dsa_s=
witch *ds, int port,
> > >  				   struct phylink_config *config)
> > >  {
> > >  	struct ocelot *ocelot =3D ds->priv;
> > > +	struct felix *felix;
> > > =20
> > > -	/* This driver does not make use of the speed, duplex, pause or the
> > > -	 * advertisement in its mac_config, so it is safe to mark this driv=
er
> > > -	 * as non-legacy.
> > > -	 */
> > > -	config->legacy_pre_march2020 =3D false;
> > > +	felix =3D ocelot_to_felix(ocelot);
> > > +
> > > +	if (felix->info->phylink_get_caps) {
> > > +		felix->info->phylink_get_caps(ocelot, port, config);
> > > +	} else {
> > > =20
> > > -	__set_bit(ocelot->ports[port]->phy_mode,
> > > -		  config->supported_interfaces);
> > > +		/* This driver does not make use of the speed, duplex, pause or
> > > +		 * the advertisement in its mac_config, so it is safe to mark
> > > +		 * this driver as non-legacy.
> > > +		 */
> > > +		config->legacy_pre_march2020 =3D false;
> >=20
> > I don't think you mean to set legacy_pre_march2020 to true only
> > felix->info->phylink_get_caps is absent, do you?
> >=20
> > Also, I'm thinking maybe we could provide an implementation of this
> > function for all switches, not just for vsc7512.
>=20
> I had assumed these last two patches might spark more discussion, which
> is why I kept them separate (specifically the last patch).
>=20
> With this, are you simply suggesting to take everything that is
> currently in felix_phylink_get_caps and doing it in the felix / seville
> implementations? This is because the default condition is no longer the
> "only" condition. Sounds easy enough.

No, not everything, just the way in which config->supported_interfaces
is populated. We have different PCS implementations, so it's likely that
the procedures to retrieve the valid SERDES protocols (when changing
them will be supported) are different.

But in fact I seriously doubt that the current way in which supported_inter=
faces
gets populated is limiting you from doing anything right now, precisely
because you don't have any code that supports changing the phy-mode.

Also, it's unlikely (I'd say impossible) for one driver to be
unconverted to the post-March-2020 requirements and the other not to be.
The simple reason is that they share the same mac_config implementation.
So it's perfectly ok to keep "config->legacy_pre_march2020 =3D false"
right where it is.

So I'd say it's up to you, but I'd drop this patch right now.=
