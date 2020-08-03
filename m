Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC8723A118
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 10:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgHCIdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 04:33:24 -0400
Received: from mail-am6eur05on2061.outbound.protection.outlook.com ([40.107.22.61]:37912
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725831AbgHCIdY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 04:33:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Am9O4fNWhxtAhKHY6pVUm4UlU7azjUNlbrPAYM4lscQAsYNWEAjR1U85DUGbXn1dEYfFCELGRYop4M0qNQmoQFDmPchsUhz6STwVnqR3I+yed6Kbs/R1EqKa4oPwIyMjvAbFuMKQhGiLCmfJkzcdF7A8S59PZlw3j4WNK7x6mWsducFbc0LpYmBxCta+2Sgxkq8u9nxiIv96/kuUX48cHjgVtYTjQjc8kw82oBxID8a93FdszfX+qaWVu2nu1fM9aXqE7de540ZABL+O3NyENppWzw2SfREv9Z4QidFQMLJOdkL90vfC4vyXTZWzQ0U+wDjEkNMMUH08dx/rJhLoOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fw1MCfzZhXDNApshyODrv4AhfJfACQzIQP4ZWvFfBHU=;
 b=Df/9uk4bqjViJfdcT0rhq0hM2RjNfKneZ6W7aRXOlrpBMNZ099p4XMmS2780uYzzAdHFp6wjesEkittZbcaUKhsJ2bZz9yrcp/ZvbBtB67CIlIge9lriVS1qPwBnOuyXlaj2j0eE1BQmKWmrRuRt8NdpL+NljByQWioWIkeQuLzzgc9folOE9DlTQdESpOcBSfeC5t/BzlrGFD+Ic3Ilj8Q2PYAvL+eI6LBqrq5hhHfxvS+oHaOwKF0wGv+6NW45738jOp7+Ls1+Jk0vfDhjitxNPlkmvrza3RGrl7YGgCetcve49qi2eJfrvKBIbZuAevHQ9YWwpZz1fxNCyiU3iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fw1MCfzZhXDNApshyODrv4AhfJfACQzIQP4ZWvFfBHU=;
 b=evefR7iQB9zVVDO3dKJO4qVhuk9RV5zUt5CzxOnQ/RbLF/ZZloUis3cUempxEAUUZL0VTQ8BNve7BsmzaBLruDYC9bGWnqIPlzG6ESzTIs9ngRGIr8XeQS4zquLB56mvRKt/3RpoBRqTd5ZUsWO8WSvtCeWVvEvoN/AzkCHWltU=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR04MB5077.eurprd04.prod.outlook.com (2603:10a6:20b:a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Mon, 3 Aug
 2020 08:33:19 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f5cb:bc18:1991:c31f]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f5cb:bc18:1991:c31f%2]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 08:33:19 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Vikas Singh <vikas.singh@puresoftware.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        kuldip dwivedi <kuldip.dwivedi@puresoftware.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Vikas Singh <vikas.singh@nxp.com>
Subject: RE: [PATCH 2/2] net: phy: Associate device node with fixed PHY
Thread-Topic: [PATCH 2/2] net: phy: Associate device node with fixed PHY
Thread-Index: AQHWZNiOdpikt9xf+EiwD7SyrSwWH6kc9FCAgAGkTICAAzz5gIAA15EAgABZCQCAAFwWgIACs+Vw
Date:   Mon, 3 Aug 2020 08:33:19 +0000
Message-ID: <AM6PR04MB3976BB0CAB0B4270FF932F62EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <1595938400-13279-1-git-send-email-vikas.singh@puresoftware.com>
 <1595938400-13279-3-git-send-email-vikas.singh@puresoftware.com>
 <20200728130001.GB1712415@lunn.ch>
 <CADvVLtXVVfU3-U8DYPtDnvGoEK2TOXhpuE=1vz6nnXaFBA8pNA@mail.gmail.com>
 <20200731153119.GJ1712415@lunn.ch>
 <CADvVLtUrZDGqwEPO_ApCWK1dELkUEjrH47s1CbYEYOH9XgZMRg@mail.gmail.com>
 <20200801094132.GH1551@shell.armlinux.org.uk>
 <20200801151107.GK1712415@lunn.ch>
In-Reply-To: <20200801151107.GK1712415@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [82.76.227.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6b1b5774-ce84-4e60-248f-08d83787e075
x-ms-traffictypediagnostic: AM6PR04MB5077:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB5077B0035C10CCAA4A043DC6AD4D0@AM6PR04MB5077.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Czb23vYg8JVq2mq8L2AnIapG3kazKNRkiEBHFbk5U5gVJ9e3/wWZaCJdXww+3wpqaah25RN1yU8DQDqAsfncSn+WaE+WX/jsnjJuIOur+h0Q7Upv23Y1iBKch/3U1e+YchvS554V2zLOefFQ0O4dvlgd+6w1SIcLjl4pk5Z+zBMWRju3xPsgWbrLF7+XbhffkzyHlBxDWOcvNm7xieeRe8qei9OnLHTx+QOUB9uc9wZt+iTJeJNlEKPSps4HBw29iVdshEmVc+b4By/IW7wsbc92Ed4yn2UWOUv1gZPB9ZDrh0nd1z08hLH71Z0eP7JJ8hSrqs2NSgFtJj2nXCwOKvwoJVKCdLSzHz1VCng9U7sYQdm8qBMe8jfV4zDV1YPUiQd1XJtpmABRw63U+UGmDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(86362001)(26005)(54906003)(110136005)(71200400001)(33656002)(186003)(9686003)(55016002)(316002)(966005)(5660300002)(4326008)(8936002)(76116006)(8676002)(478600001)(2906002)(7696005)(52536014)(66946007)(83380400001)(66446008)(64756008)(66556008)(66476007)(6506007)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: RmwLMcwjf+i/WUJrnc2Vpq4HIGrz5yDH+74ZgOYmXYDVHjlyOERjIeG3rHZNVYFKEu+i/gopOp0y059Hu1q87452gfLRVJu5YHZxlqfOomDhfhpwRK/mNqjqs/yUvaVC2VjNq7ts7TMbOK0TZ+OdmEQejARfNcRbfIjSOXfFcxCI+gunNZHrBxuplTKd/M5JYoUy8RrWZkK+XUlX8i4lRKubuOBwCran6OEtrvFFlBTjhFTYftwO/7IxiQ7+ok97GBx4Vr/asz9L9/V4aEksW8K+H8Z1P6sxqHXJIKSOKwmGGuwrxdFq1+R3y3x8AegqIfSwc/n8shR72RTtB1WAJbC1N5c+6ENU15gH7qkWPNpJeNSxA6WquL0S/t3eofDHMLY4uLBUzJNvlns31BbFtWhhge7oGeVS/VL6cmhKbHWVJegb1lKxMFKRtph3CAtYL8+l+zdwNMdeDNzU1zgCMgqLtzu3+mmyizKeNT7leu/p76+Qy0s4eqOABaRMZYazjKh9FLdeABIpo70W0PhMSr4VszF6q8J4QkTk5NGr7npI09pMzdJ/Vma5D/Wv/TRtYMyK8YewHnX6UuPwWqb1F1Yn4i25JryvMEUAk9Xf6FmTDTHovHVOnZXiWI4jVvALOfO06RVrlGo8QL6bZ3JOdw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1b5774-ce84-4e60-248f-08d83787e075
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2020 08:33:19.7611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I8WNKjl8U2i1BcKCjt9qN3zGJtOJZ+xlgY4OpDkV2xitOOAVtPnSc6xwoT/Mle9Dbc5qyHFRNULO2rUjN4M90g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Andrew Lunn
> Sent: 01 August 2020 18:11
> To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Cc: Vikas Singh <vikas.singh@puresoftware.com>; f.fainelli@gmail.com;
> hkallweit1@gmail.com; netdev@vger.kernel.org; Calvin Johnson (OSS)
> <calvin.johnson@oss.nxp.com>; kuldip dwivedi
> <kuldip.dwivedi@puresoftware.com>; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>; Vikas Singh <vikas.singh@nxp.com>
> Subject: Re: [PATCH 2/2] net: phy: Associate device node with fixed PHY
>=20
> On Sat, Aug 01, 2020 at 10:41:32AM +0100, Russell King - ARM Linux admin
> wrote:
> > On Sat, Aug 01, 2020 at 09:52:52AM +0530, Vikas Singh wrote:
> > > Hi Andrew,
> > >
> > > Please refer to the "fman" node under
> > > linux/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> > > I have two 10G ethernet interfaces out of which one is of fixed-link.
> >
> > Please do not top post.
> >
> > How does XGMII (which is a 10G only interface) work at 1G speed?  Is
> > what is in DT itself a hack because fixed-phy doesn't support 10G
> > modes?
>=20
> My gut feeling is there is some hack going on here, which is why i'm
> being persistent at trying to understand what is actually going on
> here.

Hi Andrew,

That platform used 1G fixed link there since there was no support for
10G fixed link at the time. PHYlib could have tolerated 10G speed there
With a one-liner. I understand that PHYLink is working to describe this
Better, but it was not there at that time. Adding the dependency on
PHYLink was not desirable as most of the users for the DPAA 1 platforms
were targeting kernels before the PHYLink introduction (and last I've
looked, it's still under development, with unstable APIs so we'll
take a look at this later, when it settles).

> So Vikas, as Russell pointed out, fixed-link is limited to 1G. It
> seems odd you are running a 10G link at 1G. It is also unclear what
> you have on the other end of that fixed link? Is it an SFP and you are
> afraid of the work needed to get phylink working with ACPI? Is it an
> Ethernet switch, and you are afraid of the work needed to get DSA
> working with ACPI?
>=20
> Looking at
> https://www.nxp.com/docs/en/quick-reference-guide/LS1046AQRS.pdf
>=20
> I see a XFI/2-5G SGMII port connected to a PHY, which i guess is
>=20
>        ethernet@f0000 { /* 10GEC1 */
>                 phy-handle =3D <&aqr106_phy>;
>                 phy-connection-type =3D "xgmii";
>         };
>=20
> and
>                 aqr106_phy: ethernet-phy@0 {
>                         compatible =3D "ethernet-phy-ieee802.3-c45";
>                         interrupts =3D <0 131 4>;
>                         reg =3D <0x0>;
>                 };
>=20
> Which leaves an XFI interface connected to a retimer and then to an
> SFP cage? Is this where you are using fixed-link?
>=20
> 	Andrew
