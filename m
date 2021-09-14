Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05CC240B2C6
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 17:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbhINPQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 11:16:47 -0400
Received: from mail-eopbgr10041.outbound.protection.outlook.com ([40.107.1.41]:32351
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233765AbhINPQq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 11:16:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1BVgqud1II5z7YVgqGRyJq2UNTpVPn3ZiQbmJkT5y8BCZn1Hbh2OHW1QLFkrhD7QdkPf/nb17w1zYGLF4qOH4tsCCNH3MAwy+xlZy+84ooEsgIs4dQijlG6BJvLEaHfNq1XHG7Bdukel2bMUbkKgJbcVx8FsQyDnDR2kU/ZfPe82n2BfO8P09IcSuU0RQMl1Dm5TvQ3ZQgIvuq1QX/HLvt8hZ2DAHh8dB0Cy997aV/IKGXpJy79LHzcWAt63RRHeVmx+Gi1g+dnGIc++WXC53OQqvwxOSmLt48U7sL4Ynq+cDAiJC5a1u3mrUYkYtdznTR2jtSkBafHYvzSSsiHJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=MQwuVtFLcaRXbOsMy29EvsVPvBC/qQRo9Ea2ghZX8gY=;
 b=db6iofqN7FGWhSVML5BnvSay57XZzMXsZPUtGrmBz5kzZrf/STk8P+/Wb+k8OsTU6lnA83FQAcrG5WUv2Q9FeJSOtoegT+fANUvXLHUwZz2RFXziP2GNV5YU5/G2vQGIgbSfCtjrBOUfUmDZy8/fcV2CAF+9IcoPhZPR/uP5sSl6yrDqEoG6uOHFogF0BZ/LVKUDuwGD35q/rll/qpNSQ5Rf7xgNYvSI+v8HZk73XSwVTTGURiBll6IXWly/B1XjrJzUAi1SnkqFaPeEGyDqWIrlY1UavejMeFYEnKrGP7w/xozHGQAVYP5rB5YQqxJgl9vdrgrh0Uip1PpSd/4Hew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQwuVtFLcaRXbOsMy29EvsVPvBC/qQRo9Ea2ghZX8gY=;
 b=ovO0RjaaUyVangZ6ZyyYRYo7GNNukcccyC2d11/Fh+wyHI+TEzeF2UU2BPC1l/9B4ePqqdzxlj3B51CTZpyzdHWZym7/A9F2JLgSkXZiXA1pysM93kQpeRd9m4ohDGemeTpPQGhTF8FC8yA2UeIUsfd4GS8oQPyHWmQ/77qnCOg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5341.eurprd04.prod.outlook.com (2603:10a6:803:3d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Tue, 14 Sep
 2021 15:15:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 15:15:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net] Revert "net: phy: Uniform PHY driver access"
Thread-Topic: [RFC PATCH net] Revert "net: phy: Uniform PHY driver access"
Thread-Index: AQHXqAxVhGZiRJqQ+0q4p0VsyQZ526ug3z6AgAAN1YCAAWLygIABIbqAgAApG4CAAAu8gA==
Date:   Tue, 14 Sep 2021 15:15:26 +0000
Message-ID: <20210914151525.gg2ifaqqxrmytaxm@skbuf>
References: <20210912192805.1394305-1-vladimir.oltean@nxp.com>
 <CANr-f5wCpcPM+FbeW+x-JmZt0-WmE=b5Ys1Pa_G7p8v3nLyCcQ@mail.gmail.com>
 <20210912213855.kxoyfqdyxktax6d3@skbuf> <YT+dL1R/DTVBWQ7D@lunn.ch>
 <20210914120617.iaqaukal3riridew@skbuf> <YUCytc0+ChhcdOo+@lunn.ch>
In-Reply-To: <YUCytc0+ChhcdOo+@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87aae961-c76a-485d-28c0-08d977927b55
x-ms-traffictypediagnostic: VI1PR04MB5341:
x-microsoft-antispam-prvs: <VI1PR04MB5341E9DDBDA2FFA94E190BAAE0DA9@VI1PR04MB5341.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yqnnBy1zGA5ZNmNRw35wkQ4Thxk8J9OlyqX5Q+VrWg9fkKzBflwV4NU35nGzAlLRHn0iRw4aTCNEMQJmPhjiN/5vhDOk00gWDKZslrt/ERsLHmEPDgVyqD8L5KsZRPNMZrA1Dgas34RcYTIqWx8Ok9rDEZfVVa9dTE31ZdyRDwvwy47M3EHDntMIdr+4fET/cr5l7TJCo4mLkyeCeMe9MN8kLSKW8USXG6p00cwwfyYLKIFF/sXnKCEIDlI6/QfN2HFwk48dn//AslXrdVsyapgBTT/QdOAFRjWkwvvjUQWasVE9zfPUfpjYAu8GrAHTCZHG1xn9wtd8AztGqWse/pKWt/B6j9cC9dTIgps9y3ZUelpalp3s/v5DEAl5lHLU3/ake+zGW0Hno8fnIdBkEVhXJ0i/CDRSER8T2f9YRxPAm7MLGu4XhQa6N7OShnUo7hFJgNMFRDgZQZSYS4VqHkYetlOftxYpLBTajSRR5l9mG1X28WL/UEKXnW/dmUt13uaOl7bNxonpzaXKZdqyE3V6zXkrk+ET59c2L6U76B9Ec6hYHCmoZ74q/FfozgtMB0MFravCJwlFMPed/fyZ7qWjUBelVJHAyURD15/0ww306gkWqCDMr/e7GyyYPTQ+59FcGl1mxqByvtECfV3jagowfNJaJb48CEyZ7TIz732Uz+3x95nBvWb59C2RJuBo+NCWlzNAwpD8lAhPLgubMcccftODu99j2iSfTx78XVtmY6BD0Ow9FAGtTLemSfLVWqryEzJO/gb59ep08/fZ3GDf03FgeM70uFIojl+zEvY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(396003)(376002)(39860400002)(346002)(136003)(91956017)(44832011)(4326008)(38070700005)(66556008)(8676002)(1076003)(2906002)(64756008)(26005)(83380400001)(66946007)(478600001)(5660300002)(316002)(9686003)(122000001)(33716001)(966005)(186003)(6916009)(38100700002)(6486002)(8936002)(66446008)(54906003)(76116006)(6512007)(66476007)(86362001)(71200400001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lo5doqEZhNGHNet0nfmCNsALdgGmIhF67HR14UoCSqiJDENF3dntYcWXeK3n?=
 =?us-ascii?Q?yX0VGDfNombTz9dUHH2gKaa1iLyNzStgife8uU/uKJ74DhjKCXNPJrhkbN+O?=
 =?us-ascii?Q?0pVjZum8Q7WGJz6mDl7I9R+kw1qSg94eX8sm+0PJuO7ZQOlyPg8Pb5L7qgjo?=
 =?us-ascii?Q?ckRuvXRq36rc9qFRdKOTHSMDgLm7BtVC6ei4wwHgM7MThGemKNa4xkt5Nizl?=
 =?us-ascii?Q?o3TSu1sM0JTznfkGEYUBAWuLCB4TSNn/V1kWajU1L2pVbII8BPmbdSjs2pg5?=
 =?us-ascii?Q?5oIhJ8kjl2yh2bjLfTRFOylruDAy3HWxeyJlgmCyn29QA4KzeifcrvEoB4hl?=
 =?us-ascii?Q?bHkOJMj9uJrZi5+9ArJEuPT9zltS+VVtk+OdZbALg+8Ef4fCETPo0Nt/A/kA?=
 =?us-ascii?Q?LAQdDvZK51B8ebbQZKMGlFNOOcVAx3xNpSVY8f6LQvCggOd7W/SMSx0N76jc?=
 =?us-ascii?Q?foREwH2PIHUHs1nArhByXw6EJDRS5dWdPSDn1RogIejVc4NXYnXxhKC5kv07?=
 =?us-ascii?Q?XaDXBWEYR6B2mazp1pxwQzXbMpIOSTNRlR9/O3xXapVMtQPgDAxnTZGBNA7x?=
 =?us-ascii?Q?9pnPW3c4+gFoa9+drZHs9PQZKmBDA0xT01TklILmJyfkFFE41+qbB5hZKUEH?=
 =?us-ascii?Q?KpXAslqJbbpnhMxs5dvE6jMeUdCGXuk097lOPclzEcfDul9v+CoxbWOzFqVF?=
 =?us-ascii?Q?x25WdlPGrDqkQoKHkjOsUnYgeJ+STYS2fmYLEXCzrMkOSQpgyfMu7W2aN7N5?=
 =?us-ascii?Q?sqUiUEn6wIwrfjG40iQdP1EFOBerJmaJmiIXEwr3pqR8oR2JlhRSWP/85ZfQ?=
 =?us-ascii?Q?6oJOxh1dSEJHmkVg639Jvh7shH1z0pP4NJq9/6zrB/z1NUtce3l34r8xkzAh?=
 =?us-ascii?Q?ywOKLnFwoPJBlJtFJdby3qwhRCKlGapja6m6zznkcxmAxPZ4s/DARYV0YCMy?=
 =?us-ascii?Q?QLvCx2I8Bf6GUlmMgYj7gsEQ3sjK9YBrZ/0JMuS7lcsFL7kIRBSTZEXAmfnK?=
 =?us-ascii?Q?OL6BkpgZeLYzXIEdjpHeUvelhZx+lF6HVvw80vjJpbEJBhEZwXHAeNKrhD49?=
 =?us-ascii?Q?bsr+Ze+GVaON7c3qVBgoSa9B1TtYhuYhQkGlZ0IA1Bw34GEJ+PCifzGBbr+X?=
 =?us-ascii?Q?1YaM80PSsRX/vK62ASs+RgJeGjTxEHXu8mAtugVosH3PR+AxRUQay3HYc1Ke?=
 =?us-ascii?Q?DtBUBAjdPbpttxXwnsOMVehnzYxKmSLcoT+aE2h9P+DJbUrPC35Xgsa83zAK?=
 =?us-ascii?Q?JBpeJCjqMUmPmYzibZ6JTbN5fM9B/wM/m40S1ka6K5k0Jlv8SBvj13Sz9viu?=
 =?us-ascii?Q?pOOm+WyC3FAAwZWndzNfBMY5?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E4468B7AA16BAC4EAAF39CA80FD14FBB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87aae961-c76a-485d-28c0-08d977927b55
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 15:15:26.6375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UfgJFOYzribEhRgQXojD3knCF2oDmziUdexGCJGg6I2c7KewgglATozhvvymSsz+TPsmIdarnExiDR/fe6yU0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 04:33:25PM +0200, Andrew Lunn wrote:
> On Tue, Sep 14, 2021 at 12:06:18PM +0000, Vladimir Oltean wrote:
> > On Mon, Sep 13, 2021 at 08:49:19PM +0200, Andrew Lunn wrote:
> > > > I am not sure why "to_phy_driver" needs cleanup. Au contraire, I th=
ink
> > > > the PHY library's usage of struct phy_device :: drv is what is stra=
nge
> > > > and potentially buggy, it is the only subsystem I know of that keep=
s its
> > > > own driver pointer rather than looking at struct device :: driver.
> > >
> > > There is one odd driver in the mix. Take a look at xilinx_gmii2rgmii.=
c.
> > >
> > > It probably could be done a better way, but that is what we have.
> >
> > Interesting, to say the least. Also, is there any connection between
> > that and the revert I'm proposing?
>
> If i remember correctly, Gerhard Engleder is actually using this, and
> ran into a problem because the wrong driver structure was used.
>
> > So compared to other vendors, where the RGMII gasket is part of the MAC
> > device, with Xilinx Zynq it is accessible via MDIO?
>
> Yes. Its control plane sits on the MDIO bus. Unfortunately, it does
> not have any ID registers, so it does not directly appear as a PHY. So
> it does interesting things it put itself in the control path to the
> real PHY.
>
> > It looks like it is said that this GMII2RGMII converter can be placed i=
n
> > front of any GMII MAC. Nice that there are zero in-tree users of
> > "xlnx,gmii-to-rgmii-1.0" so that I could figure out exactly how that
> > plays out in practice.
>
> If you look back at the thread for that patch, i think Gerhard posted
> a DT fragment he is using. Hopefully it will get submitted as a full
> board description at some point.
>
> > Note that the usage of priv->phy_dev, priv->phy_drv, priv->conv_phy_drv
> > beats me. Why is "phy_dev" kept inside "priv" even though it is accesse=
d
> > only inside xgmiitorgmii_probe? Why does xgmiitorgmii_configure() need =
to
> > be called from xgmiitorgmii_read_status() which in turn hooks into the
> > attached PHY driver's phy_read_status()? Why does xgmiitorgmii_configur=
e
> > not get exported and called from an .adjust_link method or the phylink
> > equivalent, like any other MAC-side hardware linked with the PHY librar=
y
> > in the kernel?
>
> I was never happy with this driver. It got submitted before i went on
> vacation, i had a few rounds trying to get the submitter to refactor
> it and was mostly ignored. I left on vacation with lots of open review
> points, and when i got back it had been merged. And the original
> submitters never responded to my requests for improvements.

Sorry, this is a rabbit hole I really don't want to go into. Allowing it
to override PHY driver functions in order to 'automagically' configure
itself when the PHY driver does stuff is probably where the bad decision
was, everything from there is just the resulting fallout.

Why don't all MAC drivers just hook themselves into the PHY driver's
->read_status method and configure themselves from there?! Why do we
even need adjust_link, phylink, any of that? It's just a small
pointer/driver override, the PHY library supports it.

I have dug up this discussion where your stance seemed to be that
"you want the MAC phy-handle to point to the gmii_to_rgmii 'PHY'"
https://lore.kernel.org/netdev/20190309161912.GD9000@lunn.ch/#t

I am not really sure if that particular reply went towards making this
driver's design any saner than it is. As explained by Harini Katakam in
his reply to you, the GMII2RGMII converter is not a PHY, and should
therefore not be treated like one. It is an RGMII gasket for the MAC.
Treating it as a satellite device of the MAC, which happens by chance to
sit on an MDIO bus, but having otherwise nothing to do with the PHY
library, sounds like a more normal approach (please note that it is
quite likely I am oversimplifying some things since I just learned about
this).=
