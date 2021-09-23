Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B07415B95
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 11:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240321AbhIWJ7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 05:59:52 -0400
Received: from mail-db8eur05on2071.outbound.protection.outlook.com ([40.107.20.71]:58496
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240253AbhIWJ7v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 05:59:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hjmaO0Ic6wf9L7BoaLyzbEmm6szo5/U/4NGm4zE1rrI4VO8Pb7GdVU2FRaZH4xXttMfJKXmIRYzhjg1sLm9LDeeTaCYL8b3kt8fHgymK2ln7i3zS8ejnGGl1Q8czzNGkset/ntEbLWqMsvB9Cqvw3q3YNw0QVkjau/GgxF4qg/NDe0nWvecOhcsrRXKQV+gKpgfKxv3OesblflWBl+FT/n5jggYLbbkn8CH4hGLgKaJ/pzJ1wibhpHW8RwrqIYdDAARBMWArGP/wVUfrzOfrM5Qa6dGmw1Q0uZDSzt4PBHAo+1CxbVJER/iIQj2CRLCkSAVCqNly04IV1g602i1Cow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9qd99C2akCy2MOCzEGwE02gBumPH50MTw+xDi5B2lRM=;
 b=U5aShOB37OgDFJ9xVESwFTq8gvs2ZaiRLsuOs/2lVV7cOpwAzoVYoIfWq49KOSAhei4uAfxGBD7Nkjb7CwcwmWrPs8SDzzcFSzbtKxwHL1ZyPP5f1Aapi/FrWbqHcmnG1alb5rGGHF9ynhhVPTKjV8ekQ7p4BYINJi8OJOjC6tLlUcTfriE3Uo3zEPyoWrYDx0t3ZbIQs1uxamvfm4SLtg7TGALxBSlvScinW8j6iXXWEjjII8OOneOum3+HFTlusKpLugM0b60jrGtJGSj5Qeff+6aePUE5DP9Vs5TJ/csH+7LswCkArXCUcWgx6O2Y7R/yOiVDI5GCQU/ov8ma9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qd99C2akCy2MOCzEGwE02gBumPH50MTw+xDi5B2lRM=;
 b=FsedByDmEMh+O21p6XL2EZycCL9BFx6Fi7qRr0INHUIi5HzZRfX+T1TgBdN1VGG2VBIkF9vniU10CsubPKfjVCagOwvB4DBMYx0MnQPvbSX43a/MLffknHm52bo590cEfDfGF07B1N4v+yfLScM9R66oqLChkpoW+JEw0Utsh3s=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3840.eurprd04.prod.outlook.com (2603:10a6:803:22::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.15; Thu, 23 Sep
 2021 09:58:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.021; Thu, 23 Sep 2021
 09:58:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: Re: [RFC PATCH v3 net-next 2/6] net: phylink: introduce a generic
 method for querying PHY in-band autoneg capability
Thread-Topic: [RFC PATCH v3 net-next 2/6] net: phylink: introduce a generic
 method for querying PHY in-band autoneg capability
Thread-Index: AQHXr93LG5LHnXhXOUKrZr2QV4Zp96uwkB2AgAACgACAAATNgIAAFO8AgAANLoCAAI4pgIAAG6SA
Date:   Thu, 23 Sep 2021 09:58:18 +0000
Message-ID: <20210923095817.7s74g2fqkzqn6wgn@skbuf>
References: <20210922181446.2677089-1-vladimir.oltean@nxp.com>
 <20210922181446.2677089-3-vladimir.oltean@nxp.com>
 <YUuei7Qnb6okURPE@shell.armlinux.org.uk>
 <20210922213116.7wlvnjfeqjltiecs@skbuf>
 <20210922214827.wczsgk3yw3vjsv5w@skbuf>
 <YUu2OlXElk5GR/3N@shell.armlinux.org.uk>
 <20210922235033.hoz4rbx2eid6snyc@skbuf>
 <YUw4iTLblfpOrdwm@shell.armlinux.org.uk>
In-Reply-To: <YUw4iTLblfpOrdwm@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 756eb126-7ac5-40fe-1026-08d97e78ab23
x-ms-traffictypediagnostic: VI1PR0402MB3840:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB384058468464A5BB4CF9BB01E0A39@VI1PR0402MB3840.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l+TI9Ja1VuxzARsx9cWkZV1bNKOjAXIx/+XXb7eUcTWkgpCrsHIJ3ngP48qxMHd91m2X2fYnyiLiktpMnpt28Wb2y96gMpQBKgdJWkmBcB/2hIJMl9LlNLNv7f2rQz3jHhkcoqfOYMddbswLlcpHNCTpVgyKjuHphqk7ueIdtpUMHAunHn8CHBWwlVy/Q1cnBhcAlrFKbir5IsYiniCwoCAhwvGiaxJMb/tz/IkBFfVLM5Q3bD5BRlyM0+EdYPiP2y3rRTQcpQ61nXFTpKL+I95vhoWL3o3n4dJzM4Peo9LA7x/P4xuH+KlO9wgC49kiqPHGldixsbxD0FiU1/6TF5yLFEu+tD/JdkpOPzVufnn06n4xrkBZ8G+z+ITqmJolclNsK+gLa2bWVeKrFa5pPlD40AQ+G9MtS90V5u9XJzr3dg3c+fZYb3JLahAvX+bV79HCTYmC0pxwSU0WdhM52hFP2oC+mdxbp+ecwfWNta7xAGaTLDYgDxcHcz2SwhlvucMK4xU2UkPMftPbk+Ask72SQjqP157BlaL7ShMuxqkFYSF/0Sh19s/8tR4ZvFtTR+6GWF3OFxI1wBwm8fS1kw9TtrA2nllGXsqg9momDeL6pAeaetlhg4og6ZaCjCRASoZBhpnm0rGS7USLmcmakXs3ZsQfGb73v6rFYSUtQacsYB6cx0ZbnDN9+45f5ZNIcsZLPvsg9yZo8IV25qY3LfmImsVRrFmP30nfewgmbkg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(91956017)(8676002)(76116006)(44832011)(33716001)(7416002)(316002)(5660300002)(6916009)(64756008)(8936002)(66476007)(54906003)(66556008)(6486002)(4326008)(66946007)(38070700005)(38100700002)(71200400001)(66446008)(9686003)(83380400001)(26005)(122000001)(2906002)(1076003)(508600001)(186003)(6506007)(6512007)(86362001)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Wj8W4qIRyJbVK2Mzl6i0loY/YfOHTTTn3cpQ10+8XvWw53nIn6iVYF3+Srds?=
 =?us-ascii?Q?NaYIw+Ge0G5RkAZdy/gk3CJOrsHOzKxLbbaFBRi01M4llr84BNztHi/r5TBB?=
 =?us-ascii?Q?FCJO94XoGmqf4OESwx9PNZh5Y6hT6I4XlRaHJqzM2SUgfgl8J0Wu9d/4zX1R?=
 =?us-ascii?Q?akHMk08xgOoxFAJO5sd6PwmWc6qHV1A3rRz15ZmBp+0R2n/6sDlY635e/vkb?=
 =?us-ascii?Q?Gd8jYhE+/TkcCaecQaUZ1jpIS0LZMYQvs4Gg5cINKDyXQ3aiTrU2SJHqjJ9D?=
 =?us-ascii?Q?PAczXwDmy5Klxb4OmOylABKEAX8xgSCxd3/k0u+KlPbKdBxcg4sTCHAfzD5i?=
 =?us-ascii?Q?hDFcUK6P5N9WqDov5MOPqvyIAJNTwTuv3rFMkNhdONh3EAaBfsLTStbSXi4Q?=
 =?us-ascii?Q?w/W7dJgyR7R4NpBuLHw6TzEGgUCvr8K4yRFLXicYAf+xwDQb92C0uEHvLUjE?=
 =?us-ascii?Q?NS+L4209YNqv77h6gNjcuAgutjjEaGK1NTjmh/2qg5cCGz2FFzFwfvpEI7bt?=
 =?us-ascii?Q?kH5dre7CMKWwXpPJ3tneJBBFRxUeFmlpixH0p+U/zUxL38dDsUJJg6yBPRCc?=
 =?us-ascii?Q?+XMTiecmQq09zUWZHdC53pWnVF2vgEc8YUGLtHgEeugJBqVBFh7QLVP8n++/?=
 =?us-ascii?Q?kKLqY/rppD8/NIRtiyMwFXX5HO7nBHv5jB1EW7Ux1TnMPiOjS8MaqA7+3Jud?=
 =?us-ascii?Q?gC2p/oOn62QxHePZblHqQOft80/H0qDt3ka/KbrS6rcq+sa+2YDsz5doiOeu?=
 =?us-ascii?Q?MPiXmv1u3tTZ9x4S25dHKuJkoWV5VvfDwuldnGWwBkBe1uQnyuTwoi2YwE/7?=
 =?us-ascii?Q?EChya/ANfLiJV+YnifXudK27BZ+7ExuGNtpeh8vZfQQ//TVC16mSZ9hZI8Be?=
 =?us-ascii?Q?GOD3FI9c3EBPcLQcae4XrI7X5agoq2opJVk0bGw3xS7cu0/jjdjOUqw3R986?=
 =?us-ascii?Q?A3yA+rrKYg2yEjUulzAyK/Ve2kVf7rfB8s2e9iLCPDv0vQPoJyLgnkz4vOJl?=
 =?us-ascii?Q?+fF3VtPbaQzxamCg2NryHKVT/d2I0R9Y3hj3A1c2XISntR1EfWbhQtWL6Dja?=
 =?us-ascii?Q?1c2wqZPtACfke/AxB5IrJmy2NIwzSfvNGfaE66ZcF0C8X+DCxfkyyl3G3x/b?=
 =?us-ascii?Q?UVr1ERnhz4LxkwbwEFBg6ZOfwz2+unLkzPiLnv5I3SXLjqlOpHOJQYBYYLiQ?=
 =?us-ascii?Q?uUnnVKbHjuM0rxP0ET9bgX84BBpdGqMr6mHU8GniLsIFMxWS4u1jwaaBCoP0?=
 =?us-ascii?Q?rS69cbGuG2lhefJZGFk0/8jQP2SwkbUYw1f1VTfFyI9uHHiLb2iWNAHnAsTW?=
 =?us-ascii?Q?Y5bNeO8riXh0QV/pH9iU+A8WcnMRv2T88FSScomixuwv3A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A8A5812F648DB44EB680A66A4F8AB891@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 756eb126-7ac5-40fe-1026-08d97e78ab23
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 09:58:18.0283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BPg4A/G130qsZByFsyZh4hu/1YDpSZ3PueIi1HgjbAGynCRA1GpcPJgjIQCoT2D0MF9X9oUZjD/S0tltidDbzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3840
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 09:19:21AM +0100, Russell King (Oracle) wrote:
> On Wed, Sep 22, 2021 at 11:50:34PM +0000, Vladimir Oltean wrote:
> > On Thu, Sep 23, 2021 at 12:03:22AM +0100, Russell King (Oracle) wrote:
> > > On Wed, Sep 22, 2021 at 09:48:28PM +0000, Vladimir Oltean wrote:
> > > > On Thu, Sep 23, 2021 at 12:31:16AM +0300, Vladimir Oltean wrote:
> > > > > On Wed, Sep 22, 2021 at 10:22:19PM +0100, Russell King (Oracle) w=
rote:
> > > > > > On Wed, Sep 22, 2021 at 09:14:42PM +0300, Vladimir Oltean wrote=
:
> > > > > > > +static unsigned int phylink_fixup_inband_aneg(struct phylink=
 *pl,
> > > > > > > +					      struct phy_device *phy,
> > > > > > > +					      unsigned int mode)
> > > > > > > +{
> > > > > > > +	int ret;
> > > > > > > +
> > > > > > > +	ret =3D phy_validate_inband_aneg(phy, pl->link_interface);
> > > > > > > +	if (ret =3D=3D PHY_INBAND_ANEG_UNKNOWN) {
> > > > > > > +		phylink_dbg(pl,
> > > > > > > +			    "PHY driver does not report in-band autoneg capabilit=
y, assuming %s\n",
> > > > > > > +			    phylink_autoneg_inband(mode) ? "true" : "false");
> > > > > > > +
> > > > > > > +		return mode;
> > > > > > > +	}
> > > > > > > +
> > > > > > > +	if (phylink_autoneg_inband(mode) && !(ret & PHY_INBAND_ANEG=
_ON)) {
> > > > > > > +		phylink_err(pl,
> > > > > > > +			    "Requested in-band autoneg but driver does not suppor=
t this, disabling it.\n");
> > > > > >
> > > > > > If we add support to the BCM84881 driver to work with
> > > > > > phy_validate_inband_aneg(), then this will always return
> > > > > > PHY_INBAND_ANEG_OFF and never PHY_INBAND_ANEG_ON. Consequently,
> > > > > > this will always produce this "error". It is not an error in th=
e
> > > > > > SFP case, but it is if firmware is misconfigured.
> > > > > >
> > > > > > So, this needs better handling - we should not be issuing an er=
ror-
> > > > > > level kernel message for something that is "normal".
> > > > >
> > > > > Is this better?
> > > > >
> > > > > 		phylink_printk(phy_on_sfp(phy) ? KERN_DEBUG : KERN_ERR, pl,
> > > > > 			       "Requested in-band autoneg but driver does not support =
this, disabling it.\n");
> > > >
> > > > Ah, not sure whether that was a trick question or not, but
> > > > phylink_fixup_inband_aneg function does not get called for the SFP =
code
> > > > path, I even noted this in the commit message but forgot:
> > >
> > > No it wasn't a trick question. I thought you were calling
> > > phylink_fixup_inband_aneg() from phylink_sfp_config(), but I see now
> > > that you don't. That's what happens when you try and rush to review.
> >
> > How did I "rush to review" exactly? I waited for 24 days since the v2
> > for even a single review comment, with even a ping in between, before
> > resending the series largely unaltered, just with an extra patch append=
ed.
>
> FFS. Are you intentionally trying to misinterpret everything I say?
> Who here is doing a review? You or me?
>
> "That's what happens when you try and rush to review." is a form of
> speech - clearly the "you" is not aimed at you Vladimir, but me.
> Let's put this a different way.
>
> I am blaming myself for rushing to review this last night.
>
> Is that more clear for you?

Apologies for misinterpreting, even though that was still the only
interpretation I could give that would make logical sense. Why would you
rush to review an RFC in the middle of the night if it wasn't me who was
rushing you, and pinging earlier? And why mention it in the first place?

Anyway... I will keep posting this as an RFC until you feel that all
corner cases are covered reasonably enough, including in-band autoneg
handling in MAC drivers. So there is no risk of it getting applied,
there is no need to rush to review.=
