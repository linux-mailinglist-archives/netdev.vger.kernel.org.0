Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E7240DC66
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 16:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238204AbhIPOJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 10:09:04 -0400
Received: from mail-eopbgr80053.outbound.protection.outlook.com ([40.107.8.53]:22937
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238088AbhIPOJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 10:09:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OeseQ4BaO8rOjbFR/2dsubYpbMaCHIIzwWXZt6Pux0pFPutLr+rn0Plhg4gx1fJsxhk16SsXcSP5AKhr95m0q1mHzlEIqY4pa8nEFOT08XIk0Q59CIf7i6A6c4l8oXqgPCCt3QRMww+mqorfeATZpZWMZvACANfLLpXpMOn8wooio5JGdX3cimJXkxZcdTdcdiPu6DyWvOgGv98elC9DDd5adI6Qn95XBcvPhssWlGH0Xaz15EMy2CiONlLaAXBx16vGBI4CP0MKSGvcadlNLAqtQj39diqVmCcxMXFp8gLehcTfI1KDjaXIqhMxqkGukox70EP7Pc3KvEIKDR44fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=QHNSyQrhDl+a+GNsppf57ffsrB09XA29JWSAban2qL8=;
 b=igCLsAs+74TVCBE5h2CWcevdN82iEhOIpFr0RGVjnQ5mpTj735ZiNrxhex7odJrkNNJXajIwMtWaN7DT14X5R8aJwskAB44xjpcAlzdzWL3YmVRSqK1jGwzrsxH+tdQpvfNUQZTDifyDh0AgvUPqVxdzxSTx1UsoI4u4rxjEKsE9dQeDbSCAIWihj7X2Dhx3wie62QnZXVuKyxyTPiDF9gi4Uo0jSZoKyX0c3vZhOWYnFuJk+zVWF5OpLcF64KqV254oijFhtjFuF7JDVlw9xnEwQHNazk3rQCkoKSWLJq9YclUz8bUmcLtlDF5p50svKCliEWB6q7OG1QnqJcaCkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QHNSyQrhDl+a+GNsppf57ffsrB09XA29JWSAban2qL8=;
 b=PLAWT/dMVmcgKi3MpmcEt8OnivBhDo/sbgfuT0f2d+1sYQP2sVvd9y9R6FNcICbh4ULH/0hD8o+GIUAFmUiQ6jKGswpQd6cUmvnWCyuluJxoaPSRQLb/MuZiLG7VvjxF58XFZA4/9unC1WPGCIS3pkviS3zwel/m+53Ce1db5Vo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3966.eurprd04.prod.outlook.com (2603:10a6:803:4e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 14:07:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Thu, 16 Sep 2021
 14:07:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [RFC PATCH v2 net-next 0/5] Let phylink manage in-band AN for the
 PHY
Thread-Topic: [RFC PATCH v2 net-next 0/5] Let phylink manage in-band AN for
 the PHY
Thread-Index: AQHXnbcfxLtpmnYEMEO8mC1+XCvPQauMXriAgAABt4CAGlwzAIAAC9QAgAAA64CAAAL1AIAAAKcA
Date:   Thu, 16 Sep 2021 14:07:40 +0000
Message-ID: <20210916140740.7fsw2mk32chxhjwd@skbuf>
References: <20210830155250.4029923-1-vladimir.oltean@nxp.com>
 <20210830183015.GY22278@shell.armlinux.org.uk>
 <20210830183623.kxtbohzy4sfdbpsl@skbuf>
 <20210916130908.zubzqs6i6i7kbbol@skbuf>
 <f65348840296deb814f4a39f5146c29d@walle.cc>
 <20210916135445.euovk2aelndgtvid@skbuf>
 <c5e4b74c3f7988bedbd74270021b4fb4@walle.cc>
In-Reply-To: <c5e4b74c3f7988bedbd74270021b4fb4@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4bd047b8-41d6-4153-d827-08d9791b58da
x-ms-traffictypediagnostic: VI1PR04MB3966:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB396601856181F1170B57D8AFE0DC9@VI1PR04MB3966.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AVygV6nHzhluNsN50D2ZMr08fV1jH8Hq5i0gZa7i/Bec8GAAjznTxw8aaytHcPO43bAwtab3I6hi1oa1yWWUmAuKlCRz47QaLEPtnAgO249x34qWb/aOSedIKYl619zwupIWn72kpIb6TvLi1zWL5SfMLVDSw7vF6MCsUAmSCi00zZlKDWjIVrRsMq29Szv+6p5RGdWV60Q5nlrtdnboBV+MvBTC0mWa+Yci4Kt086HK2IADnj/+UAPpgeG2fln3AQD8HCmlBSJvjLFK5LycYqivKEXkoO9a2u4hjP4U92y1MRmScjs+6LuTOu0zr0Z1qd4jXPp2/XFDPKhuPl1jIRKvkRbUYYCGqg9JdTrPjS1yAVdQc663XGMFxd0n6vCKDRCjhCv8k1GUeQN760+cEXhQI+MhjFF1JVxIzEF5Nl1dWXp6QLD/cOFdcJRyXdaRYIYSR5+spRt5G7OlKts4yj7OXLT1ONtfQSHGcTb/UYsRUOWPYj8DDt89oGSH0WAPClmr6veMsozpOqEVMEOgf6YCLdfcHLq9g4IYbZsTxFnDDWOZ0NxiPX5YV+RylhFVapzaXxxG/mbqbffntYXxKmQsmsjzgR+mJA81EijoAGd0rN9s7hd04SDI/4NQOekHxo/tn7ZhxzGf71Q335B678uiYJ+Fsxu7q1ei6MJDcIVSiMD5WcMARte/Mpx0nFuQ/4hRSkiudcySTzbz/gmeOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(71200400001)(7416002)(2906002)(316002)(1076003)(26005)(66476007)(66556008)(66946007)(4326008)(8676002)(508600001)(64756008)(6506007)(122000001)(33716001)(6486002)(54906003)(186003)(86362001)(6512007)(5660300002)(9686003)(83380400001)(38100700002)(6916009)(91956017)(76116006)(38070700005)(66446008)(8936002)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9yba86pyNbgSVn0TQ8EEekCLnPwwqS4GXI6XmMtEtWWsrQIep3NJzQKnhSlt?=
 =?us-ascii?Q?V64FT+XP1zr/hm01bE7Qz9PqzujqF/GKwRNdz3BFfaLufXDo7+WggI9OvE44?=
 =?us-ascii?Q?O6nKvm/4LA+B4WLr0UX+UQeAipV5FoiEUnFlnEdYJPEFicO77yGtFvtnvwP7?=
 =?us-ascii?Q?IUFrbJVml5Zja/TP83GzXRflirp3AkADfPFqLDpJE7WmwqQa99U4AO2drZn3?=
 =?us-ascii?Q?gWa+5spvgpb/QrLHhRfxS1GaDd5jfiDY7sSeYSN0TYW3wNtgRaoDZZmtGMeR?=
 =?us-ascii?Q?RSzHZL7CGct2HnfW+PKM0NRk3L/mXQsC4NozWw4LLDKRCEsRFwIFa9RYBCan?=
 =?us-ascii?Q?7mMN0TpBtO+91qbUt7XhWxtoZ1d4h2vmGuSjwdWVwGPRopOCuqzWxOI9B/HI?=
 =?us-ascii?Q?sbKxzrtm76zDTfuxHwRHyL4sj70NDNJ4w2MHTp2oeHYlgKVNcFmMyoppV/ZK?=
 =?us-ascii?Q?YW68AyZITjaJgkvCrStvkqzEPI+OT5IX/RZ/3e9mVVotwFrhkuY49T0T+jmy?=
 =?us-ascii?Q?+b8bwKQr6YzjIqplHkbZY38da8izw4p84tEmAgc+MRjz4ofpBncgae+Ib9op?=
 =?us-ascii?Q?TC8//mnwtceQYx86eKmqubfRydHYntULUk5e2EaZmBUWXSfMO5R6KGgUSQNO?=
 =?us-ascii?Q?5eXX2RxbJ7cwQzGPLpf2cInzw4xHzeBZZIeJCodAua3iIZqj4kaNRUNtWQsf?=
 =?us-ascii?Q?GCgqp3pO0TXt67UVITkQGIchZgjoN1hT4YRS6Q3RrzHtRBHSj/MLvhD1beu2?=
 =?us-ascii?Q?xakR4Z6IeGuEm+glMMAlEW5edrVKw8DBm4mC5VGZGQZvZrT0ncTX6yVt6Fm/?=
 =?us-ascii?Q?R3TTTjWNg5kY3JXg0DzF/zpmh3nFRNg96ybQMfD7auvyOVGnN1p++2UgeBNm?=
 =?us-ascii?Q?OCRtPjUrl1JyU24S/4OWVf4EWNknMSHqnDRUxEIRK9y2+JiduOzMPt38Nqqh?=
 =?us-ascii?Q?/ztGn96dK1VYDCjPSQ20bWYIBNHdbyC/JqH9SnyRWmr61Fms5oNDXCsFNdeg?=
 =?us-ascii?Q?+2tXZxgQG9KVPPxKDupq/F9GsVY1Kdg3vH+xcgxHClF9rZwj1p5fjvG7d5eh?=
 =?us-ascii?Q?fKhRAO8/7uzytgO5zbMnG3g7KG0npnO2zQ2LqDd2fAgQXyGuAQ2RKzflW1xq?=
 =?us-ascii?Q?3Gun8xutPwMurCfBQVjqik4kz61+mv9lEZuwhKVyhpykcv8kNC4AVq0rQn5H?=
 =?us-ascii?Q?9g9W1NV90ygF8fGQhankXm5coGk2GYPugjpSzBm3QNGkl6+CzmcIxasfjTEe?=
 =?us-ascii?Q?wRMhy9s56QY7taQVDb6TwO3L/y2YoomI8qLvUN0MKftLtXktclS16/C5WleX?=
 =?us-ascii?Q?EryPNNenJ+KfRkgLrxoYe4TaYOI4mR8D4swRQWNpFGTeRQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1623BD352C374048A10B40C880AD41DA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bd047b8-41d6-4153-d827-08d9791b58da
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2021 14:07:40.9701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9izNRkUrvJw9cEKS/PoiHG9v7d4MLgtk08HDyBbJtEO68DSZneyH60ca4UWA6pObd7IXXCng0XMtnGegRS486g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3966
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 04:05:20PM +0200, Michael Walle wrote:
> Am 2021-09-16 15:54, schrieb Vladimir Oltean:
> > On Thu, Sep 16, 2021 at 03:51:28PM +0200, Michael Walle wrote:
> > > Am 2021-09-16 15:09, schrieb Vladimir Oltean:
> > > > On Mon, Aug 30, 2021 at 09:36:23PM +0300, Vladimir Oltean wrote:
> > > > > On Mon, Aug 30, 2021 at 07:30:15PM +0100, Russell King (Oracle) w=
rote:
> > > > > > Can we postpone this after this merge window please, so I've go=
t time
> > > > > > to properly review this. Thanks.
> > > > >
> > > > > Please review at your discretion, I've no intention to post a v3 =
right
> > > > > now, and to the best of my knowledge, RFC's are not even consider=
ed
> > > > > for
> > > > > direct inclusion in the git tree.
> > > >
> > > > Hello Russell, can you please review these patches if possible? I
> > > > would like to repost them soon.
> > >=20
> > > I planned to test this on my board with the AR8031 (and add support
> > > there),
> > > but it seems I won't find time before my vacation, unfortunately.
> >=20
> > Oh, but there isn't any "support" to be added I though, your conclusion
> > last time seemed to be that it only supported in-band autoneg ON?
> > I was going to add a patch to implement .validate_inband_aneg for the
> > at803x driver to mark that fact too, I just didn't do it in the RFC.
> > That should also fix the ENETC ports on the LS1028A-RDB which were
> > migrated to phylink while they didn't have the 'managed =3D
> > "in-band-status"'
> > OF property, and enable new kernels to still work with the old DT blob.
> > Or were you thinking of something else?
>=20
> No, but I won't find time to test it within the next.. uhm, 30minutes
> until I call it a day ;)

Ok, if that is all, I can make sure on the NXP LS1028A-RDB that the
Atheros PHYs are always presented to phylink drivers as MLO_AN_INBAND,
never MLO_AN_PHY, and make sure that the enetc driver works in that
configuration regardless of device tree description.=
