Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285B223B47F
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 07:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgHDFgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 01:36:53 -0400
Received: from mail-db8eur05on2085.outbound.protection.outlook.com ([40.107.20.85]:10497
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727035AbgHDFgw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 01:36:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZW86ABEcng4fjrgYBQGiIEwrZ7vd51JWTwUYdljfxWyqLS1rJy/bnqL9qJmRb7woTpHj4XNWS/NtMPozHB/u9TcvpM/3VxUmIM6dYgZoorBoCq0amo8+O9YJyQF+Khl9f9DzvIb42hCiLSWpxCgBO4v/ZnHfsPmLUD4pug6UR6C0ybPTntuIrao+XGC3mHMVgUOsvRdrLMwLprCY1lnnqb7VI1+Bx0HX2YG/N2p4/QAtyGskd3vh363E/AJ17+nmzKaBd1fhAl2rDpJgEeOlPbY8P0d6gLBBImuAkAtkVpi0pPK/4hc2YDv4Qq8UI+HNF4vUWMdqFom4So2MdUuog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5EEo4EvXDaKQ6Vwjo0IOZXqR7ykh+10nCAfvKUkSXNM=;
 b=ZZD2PCi8gnakMaj90q/rtfwU8l7A1PWifnKQsEycfQt+qoBXj/je82lDbUoLPoSLAF3riaKCn2UTk72mz4PLARFCr+OTqPPsyIgpn+8fVcLqCyC8iQgQxM//Lw1xKl5CJ7p6e2l8mhMuX6WkCsHcNO/BGY6RcMi6QEtr6qfvBO837SgYDQK0Nxc690nykKSfkl5cACWv/zyxSbGxEm/CGzOZNGe9pKpRIzZcbgwLRo6nck7oW5be9qMXRLKrb1oDkQi2llNdwb03AR6qVhnkC0Hs+HboinTJbn/e5x+jzj/wdTB+z+0pQVx8MJnOVEtj4HKPhDuuG+MOSkQEUeOcHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5EEo4EvXDaKQ6Vwjo0IOZXqR7ykh+10nCAfvKUkSXNM=;
 b=ETuEB2GRKlMbsRI1dq/ATgDYv6myhxIeWbVC/2NsEghF+kUJ2pmSAGQwpGGuyLvFif/wfdARmasFXdgAlJWM6xmeoCq1C45juhVQe81qnqxGKPX2HrmDjKZcQzDud/iCvOKm9tNbIsihvNcosZUPAECLl0vjYySrSu2Z33Ek+xw=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM5PR0401MB2449.eurprd04.prod.outlook.com (2603:10a6:203:35::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Tue, 4 Aug
 2020 05:36:46 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f5cb:bc18:1991:c31f]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f5cb:bc18:1991:c31f%2]) with mapi id 15.20.3239.022; Tue, 4 Aug 2020
 05:36:46 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vikas Singh <vikas.singh@puresoftware.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        kuldip dwivedi <kuldip.dwivedi@puresoftware.com>,
        Vikas Singh <vikas.singh@nxp.com>
Subject: RE: [PATCH 2/2] net: phy: Associate device node with fixed PHY
Thread-Topic: [PATCH 2/2] net: phy: Associate device node with fixed PHY
Thread-Index: AQHWZNiOdpikt9xf+EiwD7SyrSwWH6kc9FCAgAGkTICAAzz5gIAA15EAgABZCQCAAFwWgIACs+VwgAALHACAACsYYIAAKZGAgAAIOOCAACVxAIAAAcyQ
Date:   Tue, 4 Aug 2020 05:36:46 +0000
Message-ID: <AM6PR04MB3976E8465600C4FAC9B90EDEEC4A0@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <CADvVLtXVVfU3-U8DYPtDnvGoEK2TOXhpuE=1vz6nnXaFBA8pNA@mail.gmail.com>
 <20200731153119.GJ1712415@lunn.ch>
 <CADvVLtUrZDGqwEPO_ApCWK1dELkUEjrH47s1CbYEYOH9XgZMRg@mail.gmail.com>
 <20200801094132.GH1551@shell.armlinux.org.uk>
 <20200801151107.GK1712415@lunn.ch>
 <AM6PR04MB3976BB0CAB0B4270FF932F62EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20200803090716.GL1551@shell.armlinux.org.uk>
 <AM6PR04MB3976284AEC94129D26300485EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20200803141017.GM1551@shell.armlinux.org.uk>
 <AM6PR04MB3976E2DFF6EAC273B7B1BEABEC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20200803165342.GP1551@shell.armlinux.org.uk>
In-Reply-To: <20200803165342.GP1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [82.76.227.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fe2d5971-fd18-4dee-b526-08d8383860e7
x-ms-traffictypediagnostic: AM5PR0401MB2449:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM5PR0401MB2449CC8AD69F30098E957DE5AD4A0@AM5PR0401MB2449.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K+PDgSiMD13JQjgwZTAwF6E0vkf5iLFW0AM+7E4G0esu/XY2gLbdjKSe7UnN0JJHeIcarGmcSxDIuf3QQUFAvASiHa+94xTCQUCb+6PVnQ2kqAqQvfxd1J8ZL9y79459h7Yv2rN+oJHkH2luT5b8d0ies7FqHMRzHVvSdMNcopdpVChUOjKnyQbiIi9PqqHQ7vEGsV7F2G+eXhsDeJob6QSnD+qCKe+1WzC9TkwbVcjbjIn4K44mlDGLDFtxNsMpjSCG/fqFkYixFxMmg1G8sRSLMxEDg2jk/IE7/N5oYFur48xdmjZbf2n+rax4M7gXbrypuUVXN/psNgc2+Iz0i5kaOqjsWxc/XpJpGL7z17N/cSs2YihUeGAdrw6xuPFaqHREN7EUpA/Ja0ERgxAD9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(478600001)(52536014)(86362001)(33656002)(2906002)(966005)(83380400001)(9686003)(5660300002)(55016002)(64756008)(4326008)(8936002)(54906003)(76116006)(66476007)(6506007)(53546011)(66946007)(71200400001)(8676002)(26005)(186003)(316002)(66446008)(7696005)(66556008)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: E5Ez6mwnBwCS13uW/OyzqBPvAHPULLN6mHvcTgW+F+o0TYiKwn2k0Fiu8h2XfEOXk8CiY0TuIVU7SbW4Bhhs95n/kIqDhOQBMBdmUI9tzGIVWrplfmEm+vGAXgFDDfvMapQUOr4KR/wfTmbYzHf9m/z4yGcpiGlU+sPuLpBGXyhzZpKTvDcVn4dH8W5ZVrN1sVlytXKJzO0IwkWPGFkdY81l+6jsV2OXQ/fIHEl7vkvo4bCpB6Khn5oIVPArF0bD6Lvl1UwnTl3wgRkPSHQn9zpXGIpMRb8S7CT6eGiWNce8T4T1dd2+idWj720lR3ds/Xf/ZaHf7Dr5e9pVtGpas87oPxnyC5+iVOH5t/1hKuVbyizmH8lJnUoB7fvUnpvL2cRSlIW1zU1iHhXSSQq4WPsExetRjjkNZyx1WVcctLP9L0suJJQ7GztP97xo++zuGBeB9VRM5UHwfon1LUYLNW3zVfgh5TqcMVzMo1isCp/No1XrTYeHD+mnIx4o/6yRpLVbchYbJSOfNg8vkB8TrHFCaAEpj8mHYKxnVdOHgyDclB1a9vuw4PFz9KM7SXVZMwouI6C6R2xdsLkZbudSA5uqYq/9cT/tmBQj0SfdOgYYUhIbXSDCz2FCehb5BKOB364xZW+jnLtQcdtm0oskyg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe2d5971-fd18-4dee-b526-08d8383860e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2020 05:36:46.6258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LLK4zzQufpeP+UYYXkvJ70oWpd8T7aqBJGgS0oA7YuaZVImuDY7TES0TGpCLZ+ykQiH1ZQvfRxZCEcmP684J2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2449
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Sent: 03 August 2020 19:54
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Cc: Andrew Lunn <andrew@lunn.ch>; Vikas Singh
> <vikas.singh@puresoftware.com>; f.fainelli@gmail.com; hkallweit1@gmail.co=
m;
> netdev@vger.kernel.org; Calvin Johnson (OSS) <calvin.johnson@oss.nxp.com>=
;
> kuldip dwivedi <kuldip.dwivedi@puresoftware.com>; Vikas Singh
> <vikas.singh@nxp.com>
> Subject: Re: [PATCH 2/2] net: phy: Associate device node with fixed PHY
>=20
> On Mon, Aug 03, 2020 at 02:47:41PM +0000, Madalin Bucur (OSS) wrote:
> > > -----Original Message-----
> > > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > Sent: 03 August 2020 17:10
> > > To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> > > Cc: Andrew Lunn <andrew@lunn.ch>; Vikas Singh
> > > <vikas.singh@puresoftware.com>; f.fainelli@gmail.com;
> hkallweit1@gmail.com;
> > > netdev@vger.kernel.org; Calvin Johnson (OSS)
> <calvin.johnson@oss.nxp.com>;
> > > kuldip dwivedi <kuldip.dwivedi@puresoftware.com>; Vikas Singh
> > > <vikas.singh@nxp.com>
> > > Subject: Re: [PATCH 2/2] net: phy: Associate device node with fixed
> PHY
> > >
> > > On Mon, Aug 03, 2020 at 11:45:55AM +0000, Madalin Bucur (OSS) wrote:
> > > > > -----Original Message-----
> > > > > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > > > Sent: 03 August 2020 12:07
> > > > > To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> > > > > Cc: Andrew Lunn <andrew@lunn.ch>; Vikas Singh
> > > > > <vikas.singh@puresoftware.com>; f.fainelli@gmail.com;
> > > hkallweit1@gmail.com;
> > > > > netdev@vger.kernel.org; Calvin Johnson (OSS)
> > > <calvin.johnson@oss.nxp.com>;
> > > > > kuldip dwivedi <kuldip.dwivedi@puresoftware.com>; Vikas Singh
> > > > > <vikas.singh@nxp.com>
> > > > > Subject: Re: [PATCH 2/2] net: phy: Associate device node with
> fixed
> > > PHY
> > > > >
> > > > > On Mon, Aug 03, 2020 at 08:33:19AM +0000, Madalin Bucur (OSS)
> wrote:
> > > > > > > -----Original Message-----
> > > > > > > From: netdev-owner@vger.kernel.org <netdev-
> owner@vger.kernel.org>
> > > On
> > > > > > > Behalf Of Andrew Lunn
> > > > > > > Sent: 01 August 2020 18:11
> > > > > > > To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > > > > > Cc: Vikas Singh <vikas.singh@puresoftware.com>;
> > > f.fainelli@gmail.com;
> > > > > > > hkallweit1@gmail.com; netdev@vger.kernel.org; Calvin Johnson
> (OSS)
> > > > > > > <calvin.johnson@oss.nxp.com>; kuldip dwivedi
> > > > > > > <kuldip.dwivedi@puresoftware.com>; Madalin Bucur (OSS)
> > > > > > > <madalin.bucur@oss.nxp.com>; Vikas Singh <vikas.singh@nxp.com=
>
> > > > > > > Subject: Re: [PATCH 2/2] net: phy: Associate device node with
> > > fixed
> > > > > PHY
> > > > > > >
> > > > > > > On Sat, Aug 01, 2020 at 10:41:32AM +0100, Russell King - ARM
> Linux
> > > > > admin
> > > > > > > wrote:
> > > > > > > > On Sat, Aug 01, 2020 at 09:52:52AM +0530, Vikas Singh wrote=
:
> > > > > > > > > Hi Andrew,
> > > > > > > > >
> > > > > > > > > Please refer to the "fman" node under
> > > > > > > > > linux/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> > > > > > > > > I have two 10G ethernet interfaces out of which one is of
> > > fixed-
> > > > > link.
> > > > > > > >
> > > > > > > > Please do not top post.
> > > > > > > >
> > > > > > > > How does XGMII (which is a 10G only interface) work at 1G
> speed?
> > > Is
> > > > > > > > what is in DT itself a hack because fixed-phy doesn't
> support
> > > 10G
> > > > > > > > modes?
> > > > > > >
> > > > > > > My gut feeling is there is some hack going on here, which is
> why
> > > i'm
> > > > > > > being persistent at trying to understand what is actually
> going on
> > > > > > > here.
> > > > > >
> > > > > > Hi Andrew,
> > > > > >
> > > > > > That platform used 1G fixed link there since there was no
> support
> > > for
> > > > > > 10G fixed link at the time. PHYlib could have tolerated 10G
> speed
> > > there
> > > > > > With a one-liner.
> > > > >
> > > > > That statement is false.  It is not a "one liner".  fixed-phy
> exposes
> > > > > the settings to userspace as a Clause 22 PHY register set, and th=
e
> > > > > Clause 22 register set does not support 10G.  So, a "one liner"
> would
> > > > > just be yet another hack.  Adding Clause 45 PHY emulation support
> > > > > would be a huge task.
> > > > >
> > > > > > I understand that PHYLink is working to describe this
> > > > > > Better, but it was not there at that time. Adding the dependenc=
y
> on
> > > > > > PHYLink was not desirable as most of the users for the DPAA 1
> > > platforms
> > > > > > were targeting kernels before the PHYLink introduction (and las=
t
> > > I've
> > > > > > looked, it's still under development, with unstable APIs so
> we'll
> > > > > > take a look at this later, when it settles).
> > > > >
> > > > > I think you need to read Documentation/process/stable-api-
> nonsense.rst
> > > > > particularly the section "Stable Kernel Source Interfaces".
> > > > >
> > > > > phylink is going to be under development for quite some time to
> come
> > > > > as requirements evolve.  For example, when support for QSFP
> interfaces
> > > > > is eventually worked out, I suspect there will need to be some
> further
> > > > > changes to the driver interface.  This is completely normal.
> > > > >
> > > > > Now, as to the stability of the phylink API to drivers, it has in
> fact
> > > > > been very stable - it has only changed over the course of this
> year to
> > > > > support split PCS, a necessary step for DPAA2 and a few others.
> It
> > > has
> > > > > been around in mainline for two years, and has been around much
> longer
> > > > > than that, and during that time it has been in mainline, the MAC
> > > facing
> > > > > interface has not changed until recently.
> > > > >
> > > > > So, I find your claim to be quite unreasonable.
> > > >
> > > > I see you agree that there were and there will be many changes for =
a
> > > while,
> > > > It's not a complaint, I know hot it works, it's just a decision
> based on
> > > > required effort vs features offered vs user requirements. Lately
> it's
> > > been
> > > > time consuming to try to fix things in this area.
> > >
> > > No, it hasn't been time consuming.  The only API changes as far as
> > > drivers are concerned have been:
> > >
> > > 1. the change to the mac_link_up() prototype to move the setup of the
> > >    final link parameters out of mac_config() - and almost all of the
> > >    updates to users were done by me.
> > >
> > > 2. the addition of split PCS support, introducing new interfaces, has
> > >    had minimal impact on those drivers that updated in step (1).
> > >
> > > There have been no other changes as far as users are concerned.
> > >
> > > Some of the difficulty with (1) has been that users of phylink
> appeared
> > > initially with no proper review, and consequently they got quite a lo=
t
> > > wrong.  The most common error has been using state->speed, state-
> >duplex
> > > in mac_config() methods irrespective of the AN mode, which has
> _always_
> > > since before phylink was merged into mainline, been totally unreliabl=
e.
> > >
> > > That leads me on to the other visible "changes" for users are
> concerned,
> > > which may be interpreted as interface changes, but are not; they have
> > > all been clarifications to the documentation, to strengthen things
> such
> > > as "do not use state->speed and state->duplex in mac_config() for
> > > various specific AN modes".  Nothing has actually changed with any of
> > > those clarifications.
> > >
> > > For example, if in in-band mode, and mac_config() uses state->speed
> > > and state->duplex, then it doesn't matter which version of phylink
> > > you're using, if someone issues ethtool -s ethN ..., then state->spee=
d
> > > and state->duplex will be their respective UNKNOWN values, and if
> you're
> > > using these in that situation, you will mis-program the MAC.
> > >
> > > Again, that is not something that has changed.  Ever.  But the
> > > documentation has because people just don't seem to get it, and I
> seemed
> > > to be constantly repeating myself in review after review on the same
> > > points.
> > >
> > > So, your assertion that the phylink API is not stable is false.  It
> > > has been remarkably stable over the two years that it has been around=
.
> > > It is only natural that as the technology that a piece of code
> supports
> > > evolves, so the code evolves with it.  That is exactly what has
> happened
> > > this year with the two changes I mention above.
> > >
> > > Now, if you've found it time consuming to "fix things" (unspecified
> what
> > > "things" are) then I assert that what has needed to be fixed are
> things
> > > that NXP have got wrong.  Such as the rtnl cockups.  Such as abusing
> > > state->speed and state->duplex.  None of that is because the interfac=
e
> > > is unstable - they are down to buggy implementation on NXPs part.
> > >
> > > Essentially, what I'm saying is that your attempt to paint phylink as
> > > being painful on the basis of interface changes is totally and utterl=
y
> > > wrong and is just an excuse to justify abusing the fixed-link code an=
d
> > > specifying things that are clearly incorrect via DT.
> >
> > Thank you for the distilled phylink history, it may be easier to
> comprehend
> > with these details. I was not referring to phylink, but PHY related
> issues
> > on the DPAA 1 platforms.
>=20
> Sigh.  No, you were referring to phylink.  This is what you said:
>=20
> > I understand that PHYLink is working to describe this
> > Better, but it was not there at that time. Adding the dependency on
> > PHYLink was not desirable as most of the users for the DPAA 1 platforms
> > were targeting kernels before the PHYLink introduction (and last I've
> > looked, it's still under development, with unstable APIs so we'll
> > take a look at this later, when it settles).
>=20
> This discussion stems from your misconception and incorrect statements
> concerning phylink, which I am correcting in this discussion.
>=20
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

"Lately it's been time consuming to try to fix things in this area."

area !=3D phylink

Otherwise, yes, I may have some misconceptions in regards to phylink, not
having paid the time to understand the details.

Madalin
