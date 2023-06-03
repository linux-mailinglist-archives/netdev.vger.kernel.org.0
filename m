Return-Path: <netdev+bounces-7618-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 38427720DF1
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 07:27:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79D361C2125B
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 05:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD923C35;
	Sat,  3 Jun 2023 05:27:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE59D1FD5
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 05:27:23 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2073.outbound.protection.outlook.com [40.107.100.73])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE19DE52;
	Fri,  2 Jun 2023 22:27:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKG7Zp4HTJeVYh6W+GcDm8/YHR7Q1CEKZX0/U3/SZfHUjfJHL5JfbxPXdU0b5wDFRQfShURkq2Z/LGmZv3cWnGe1ZVvv3X7B4raA9cufwJxw87Xy2yL5mZnjCcEg6BHKvn+RKzCEcP8mtQP4rzLIfMVFuoBAJl3fpYd+y0ULb5IwhXKScS+tuoZE9oy9Qn9uOYPAHTuF8rE9lJ8dCJhzQjgqzjokTfNUFrcficAz9miR9H5OvdljJQMzFKHMdkSo/66kFFfqHKyKs4MFqZQyws/y4//7TkIoX8NTmt8TEouUBBSbfKcXvtWrRcc6hhtj2qhB17SGRnK6waFUa3ktlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RLzObFHL9ChXrpWhQFZ+I8MZhNS752/Bis50vYBajvY=;
 b=lKIIFT2Cuhp1JZDx9cRdWzEsZvJYqRQ7Dvu79v/rfBn4rFeuOwkFrCaGILxF/nxY4m/qwllThvbWadDEU5REvk9RVJomkBX+1fOwCDjxoI2+HjunYpTsXgfF0VoHuTm1CklnYqas32fLvyNwRNOKX2QS5Y7SVG9qFf2HTYv3QVHAgTWl6u4UCj1/T1AKTz/Oeu+cu29YU/0cNb4ExCsZsLakWrojBxznADHyS6hSfrKSTDVSBhPpAK1Y/sB8Mwt6BmYdesFCYCtIO/MNSHEuX5M+otXdEnVU2YQD5Yc7AeSGBJ7AQ2ugIl9KCB0XL7TxQEn2XfLfZNFndDZVaPybsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ooma.com; dmarc=pass action=none header.from=ooma.com;
 dkim=pass header.d=ooma.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ooma.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RLzObFHL9ChXrpWhQFZ+I8MZhNS752/Bis50vYBajvY=;
 b=U83Y84dlYlcLnewLro33lqsEBIlZcK7O2UfvT2oOvR+laYOw/k0NGoXZyR0OFpuEohN5wQ3v1TSKGUfBEYS4+VLXjmlJ1+CL9DTte3VutaWXV/y2SZnJpz+4jOQtjPMAjz6m1T21pNK1sBxQvkB5xreyaq7+pDQjUeSJebTe33Y=
Received: from BYAPR14MB2918.namprd14.prod.outlook.com (2603:10b6:a03:153::10)
 by DS0PR14MB6785.namprd14.prod.outlook.com (2603:10b6:8:f2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.27; Sat, 3 Jun
 2023 05:27:17 +0000
Received: from BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::6e6d:b407:35b1:c64]) by BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::6e6d:b407:35b1:c64%3]) with mapi id 15.20.6455.028; Sat, 3 Jun 2023
 05:27:17 +0000
From: Michal Smulski <michal.smulski@ooma.com>
To: Ioana Ciornei <ioana.ciornei@nxp.com>, "Russell King (Oracle)"
	<linux@armlinux.org.uk>
CC: "andrew@lunn.ch" <andrew@lunn.ch>, "f.fainelli@gmail.com"
	<f.fainelli@gmail.com>, "olteanv@gmail.com" <olteanv@gmail.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "kabel@kernel.org" <kabel@kernel.org>
Subject: RE: [PATCH net-next v6 1/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Thread-Topic: [PATCH net-next v6 1/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Thread-Index: AQHZlOeZhHXye15LEk+eN0zupHuzTK93ULkAgAAQDwCAABzTAIAAFnYAgAD13YA=
Date: Sat, 3 Jun 2023 05:27:16 +0000
Message-ID:
 <BYAPR14MB291875B10554EDB665ACEBFAE34FA@BYAPR14MB2918.namprd14.prod.outlook.com>
References: <20230602001705.2747-1-msmulski2@gmail.com>
 <20230602001705.2747-2-msmulski2@gmail.com>
 <ZHnEzPadBBbfwj18@shell.armlinux.org.uk>
 <20230602112804.32ffi7mpk5xfzvq4@LXL00007.wbi.nxp.com>
 <ZHnqcvP8hv19RBr8@shell.armlinux.org.uk>
 <20230602143138.aaq22cmwinrrhtrv@LXL00007.wbi.nxp.com>
In-Reply-To: <20230602143138.aaq22cmwinrrhtrv@LXL00007.wbi.nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ooma.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR14MB2918:EE_|DS0PR14MB6785:EE_
x-ms-office365-filtering-correlation-id: 8bae13ee-0ebc-4829-3d8d-08db63f331ef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 0NjmYGlMd6au8+EikPRC82BvsAlTCgn13G5tJVYtNop4qodrdFgYicnkvF5qUbJFh0UKlNQdIyILIOiIF6FlEpXERJovlR+hashA0/5GxawPm+c5BdmMwc3TSDwnFbPJpfLLbm6yJoNBizFHVAYC2TlyIob5eDxpuo8+2kqPtQwERso90z9IUZrPdXNTF4b0cdkI0XCRUKbjRMIQKs349hDLjPfxhdVrlhMrYs5yGBG0lJtRAXtHqNFeA5JapE8uCJdviyvVK4tqGIvQufJTX6YNNJNPuborVBW3XHnW63Q3NeZ1HyZkz/yqiRVYLLGSd+jm5FySk446jZafH8WkkLs9eWcgbneNQOWEW9xh6uYz6DObOrgYz2NViIIVFaB6btz6j4TqQkcs9DAAYLVWZSVeRT34QnyHq/5u3Vu6gjMF8ZQgAbT1RWKdARTe8FO71F+KEkLItJBmcpdJ9DufU99SjzkvtLl7AepeZBdRxOdkBPO6ntmk1q200H2PUzG4e/krel4wUIMAmnq9e/COjheNsx2vfuYCfXqNyaAq/Zfz+W8ou+9VlNfLCy67HazDJuZGc+irTrQonGBvmcZtZZC1K1LmshPWPUO0znV3+nJIg/XbSYIuH3vHR8nDgYhmtAQv2wngsz8eowyJ903Ypw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR14MB2918.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(366004)(376002)(39850400004)(451199021)(38100700002)(4326008)(66476007)(66946007)(76116006)(64756008)(66446008)(66556008)(316002)(71200400001)(478600001)(33656002)(55016003)(86362001)(7696005)(83380400001)(19627235002)(9686003)(53546011)(6506007)(110136005)(54906003)(186003)(122000001)(26005)(38070700005)(7416002)(52536014)(44832011)(5660300002)(8676002)(8936002)(2906002)(41300700001)(138113003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?buKYbdRZwE1Fh+cXWr9L5MgW0KkamdOw9OnVeR6aJza7ETdG1bhXZqxmlUdP?=
 =?us-ascii?Q?grkZLidfE0qc92HFpXnUXZhLQ/fqR4+rZrPse/lytuKAuswEpIG1QtlPp0gX?=
 =?us-ascii?Q?sxbhK1HegVGil29ViiA596kW3oAyRPQoTMKxcxbbC0AsCJ9+BE3fRDXuv8zi?=
 =?us-ascii?Q?Fk3Om/4n3rVxpglgqXx/2ygQIuTQQ472bh5QidhnPx3oGjaHNntwSO9Sfbjr?=
 =?us-ascii?Q?Zof2ERDsPeblPE8zUaJj12SIPIUr1ad06AtTHJOTOVrwf6JQWYM62aeA1vW8?=
 =?us-ascii?Q?g2sTN7jRIaM23fBa1lpFHcy7qsPefuvtnSWt1+okhClvD8RC8XF1gINrbxN+?=
 =?us-ascii?Q?BpCnDnl/8/k9I2MOJ6+Jb7w80tbJdf3ojkeLXjG7V+P8JQ3H13rI3GxuiNxJ?=
 =?us-ascii?Q?JidVIXBniGI8tmXKCO40Oq8BCmAA6QFYiHGW+vNMEZ/9hN4MRw6YeHD7VY/1?=
 =?us-ascii?Q?cHXgn2Ccb9E2m91da5LWLuADCmV3yfISiB7L4S8XCVDk9spYf/EV+xts5ox0?=
 =?us-ascii?Q?LNhx3IbHIeHWWiyDBpEbMgJ0q9UhPhjzu2A0aCxPlOF1IcjJmtXbsnj+XIWI?=
 =?us-ascii?Q?BQJAwzt+BkN73knzvsdOAAj+tFXSxJoiE4kqJW82C7SCRpFBRjp/adH3ZrU3?=
 =?us-ascii?Q?2tp/cZjE7+kOewFITjcJz07BtG+YEVjvpebFYpBdfLzceJAI5io8CF2EQU/j?=
 =?us-ascii?Q?NEdGajnl0oBnuepr2dwbnxwDddoPHV67tvRLmN+SJYvAo3mo1GHFJ/5uLMh1?=
 =?us-ascii?Q?bjMtqpd1ZOzV2AXOxgxzKPcMVgK0qp4syqMt5pUTvPuj2v7EXidZ2y/Yn+uH?=
 =?us-ascii?Q?UGwT/OrbB7HYyX3UNwcNAVYloLaOalZ9L68gSbSFycSdLtxR4tiXWFFL0hdK?=
 =?us-ascii?Q?cSWLjZX5CfpFhrj5AlnCgiTx2kNYWJdJ1psdjovyam1Jhfs5WT81PA/vucgn?=
 =?us-ascii?Q?c/7KOCp+MXY0qD+TNBw3DUblKLEs3NEilBR9bHybFvC705qk4mrkDx82IeyX?=
 =?us-ascii?Q?pJ8j/AeqRdbgCc9ljxyaKTWKgdiY6vemVsF4BKb4XE8KEAqSqJX0G4IG+0fC?=
 =?us-ascii?Q?2ihdVDqHY7F1n4gPer9ooXy37/hbSJAiPKGCT90CD7VecpLH0QqTo92GFyoh?=
 =?us-ascii?Q?gZ+ig6UWdz1WS34pxYsNZfSSCGR44CnhP1lpdVozKlBsTu+WkkIepUyuL3c/?=
 =?us-ascii?Q?Gye7BJ3t/JcVrf+4c/t0omW+s1ti8xU5Y+Kwed93WXd6QY49dp8vhAzLyLnU?=
 =?us-ascii?Q?Us0I3wn73elJSeZ1tm2F89ub+crVs9soZ9NCrUFzO/UIAX0nnbsMWZOtv11e?=
 =?us-ascii?Q?XV0NsyephkGhfl9gxB8BW3Yy68fOBEaEN2v4u8NfxPQXuZHXkzRfdqhVWbIT?=
 =?us-ascii?Q?9RXKHRPmj/X2014GXlZYp3cpRRfeVzD+rrNQhw6aISrJ4kshGFaXEGUd9pVC?=
 =?us-ascii?Q?R26BrSbItecQKOmgdtQB7wH7IFeDPZCCuoMKV1DQo2sBJM0Dxj3qCIZalW9D?=
 =?us-ascii?Q?4Ax42/j0MVBHtiT2wyOmoZfPQOUwznMcKsTEuelX8zIEvLkTJa4JlBxtEFUt?=
 =?us-ascii?Q?KiTiXb0WKCuw6BiKVdA/82IU613kXJWX12GLBcIC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ooma.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR14MB2918.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bae13ee-0ebc-4829-3d8d-08db63f331ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2023 05:27:16.8621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2d44ad66-e31e-435e-aaf4-fc407c81e93b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +c3eLUgPreJiQUrDJCg02ubHM29udoQtUqvMbDCQ4bfA0I1WmuAKi6/bBn2Sx5j4QIOwG9J5waXFSGupvsx2xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR14MB6785
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

I spent some time today poking around pcs-lynx driver in hopes of using it =
to learn more about the Marvell switch.

1. lynx_pcs_get_state_usxgmii() is the function that the pcs-lynx driver is=
 using to poll the status and to get LPA word. After I trigger auto-negotia=
tion and it completes MII_LPA=3D0xd601. Therefore, the proposed change to p=
hylink_decode_usxgmii_word() below would work fine with Marvell switch.
2. lynx_pcs_config_usxgmii() is where the driver sets its MII_ADVERTISE bit=
s. However, I noted that Marvell switch achieves link status (10G) and obta=
ins MII_LPA (reg=3Dlp_status) from LX2162a BEFORE this function is executed=
 (I traced this with printk() but I am fairly sure this is true given that =
I trigger DPMAC13 up manually). So, it seems that default settings on LX216=
2a allow for getting link (on Marvell switch). I was trying to force LX2162=
 to advertise speed lower then 10G to see how and when Marvell switch would=
 respond but I was not able to figure this out. Please let me know if you a=
re aware of an easy way to do disable default settings and force LX2162 to =
wait until lynx_pcs_config_usxgmii() is called to set link speed/duplex mod=
e?

Thank you,
Michal=20

-----Original Message-----
From: Ioana Ciornei <ioana.ciornei@nxp.com>=20
Sent: Friday, June 2, 2023 7:32 AM
To: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: msmulski2@gmail.com; andrew@lunn.ch; f.fainelli@gmail.com; olteanv@gmai=
l.com; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@re=
dhat.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; simon.horma=
n@corigine.com; kabel@kernel.org; Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v6 1/1] net: dsa: mv88e6xxx: implement USXGMII=
 mode for mv88e6393x

CAUTION: This email is originated from outside of the organization. Do not =
click links or open attachments unless you recognize the sender and know th=
e content is safe.


On Fri, Jun 02, 2023 at 02:11:14PM +0100, Russell King (Oracle) wrote:
> On Fri, Jun 02, 2023 at 02:28:04PM +0300, Ioana Ciornei wrote:
> > On Fri, Jun 02, 2023 at 11:30:36AM +0100, Russell King (Oracle) wrote:
> > > On Thu, Jun 01, 2023 at 05:17:04PM -0700, msmulski2@gmail.com wrote:
> > > > +/* USXGMII registers for Marvell switch 88e639x are=20
> > > > +undocumented and this function is based
> > > > + * on some educated guesses. It appears that there are no=20
> > > > +status bits related to
> > > > + * autonegotiation complete or flow control.
> > > > + */
> > > > +static int mv88e639x_serdes_pcs_get_state_usxgmii(struct mv88e6xxx=
_chip *chip,
> > > > +                                                 int port, int lan=
e,
> > > > +                                                 struct=20
> > > > +phylink_link_state *state) {
> > > > +       u16 status, lp_status;
> > > > +       int err;
> > > > +
> > > > +       err =3D mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> > > > +                                   MV88E6390_USXGMII_PHY_STATUS, &=
status);
> > > > +       if (err) {
> > > > +               dev_err(chip->dev, "can't read Serdes USXGMII PHY s=
tatus: %d\n", err);
> > > > +               return err;
> > > > +       }
> > > > +       dev_dbg(chip->dev, "USXGMII PHY status: 0x%x\n",=20
> > > > + status);
> > > > +
> > > > +       state->link =3D !!(status & MDIO_USXGMII_LINK);
> > > > +
> > > > +       if (state->link) {
> > > > +               err =3D mv88e6390_serdes_read(chip, lane, MDIO_MMD_=
PHYXS,
> > > > +                                          =20
> > > > + MV88E6390_USXGMII_LP_STATUS, &lp_status);
> > >
> > > What's the difference between these two registers? Specifically,=20
> > > what I'm asking is why the USXGMII partner status seems to be=20
> > > split between two separate registers.
> > >
> > > Note that I think phylink_decode_usxgmii_word() is probably=20
> > > missing a check for MDIO_USXGMII_LINK, based on how Cisco SGMII=20
> > > works (and USXGMII is pretty similar.)
> > >
> > > MDIO_USXGMII_LINK indicates whether the attached PHY has link on=20
> > > the media side or not. It's entirely possible for the USXGMII link=20
> > > to be up (thus allowing us to receive the "LPA" from the PHY) but=20
> > > for the PHY to be reporting to us that it has no media side link.
> > >
> > > So, I think phylink_decode_usxgmii_word() at least needs at the=20
> > > beginning this added:
> > >
> > >   if (!(lpa & MDIO_USXGMII_LINK)) {
> > >           state->link =3D false;
> > >           return;
> > >   }
> > >
> > > The only user of this has been the Lynx PCS, so I'll add Ioana to=20
> > > this email as well to see whether there's any objection from Lynx=20
> > > PCS users to adding it.
> > >
> >
> > I just tested this snippet on a LX2160ARDB that has USXGMII on two=20
> > of its lanes which go to Aquantia AQR113C PHYs.
> >
> > The lpa read is 0x5601 and, with the patch, the interface does not=20
> > link up. I am not sure what is happening, if it's this PHY in=20
> > particular that does not properly set MDIO_USXGMII_LINK.
>
> Thanks for testing. I wonder if the USXGMII control word that the PHY=20
> transmits can be read from one of its registers?
>

I had a look into the AQR gen4 datasheet and the only thing that I could fi=
nd is the "PCS USX0 Auto-Neg Control Register" which has the following
field:

        USX0 Auto-Negotiation Message code [7:0]
        Configure the message opcode for USXGMII Auto-Negotiation.

It sounded promising but it's not making any sense to me because it's just =
8 bits long.

> If the PHY is correctly setting the link bit, but it's not appearing=20
> in the Lynx PCS registers as set, that would be weird, and suggest the=20
> PCS is handling that itself. Does the Lynx link status bit change=20
> according to the media link status, while the AN complete bit stays=20
> set?
>

No, the Lynx link status bit is 1 even though the media side is no longer c=
onnected, for example. Here I just removed the cable, the link on the PHY i=
s down but the PCS link is up.

[  133.011696] fsl_dpaa2_eth dpni.2 endpmac3: Link is Down [  133.555343] p=
hylink_decode_usxgmii_word 3331: lpa 0x5601 [  133.560672] mdio_bus 0x00000=
00008c0f000:00: mode=3Dusxgmii/10Gbps/Full link=3D1 an_complete=3D1 [  134.=
579348] phylink_decode_usxgmii_word 3331: lpa 0x5601


Ioana

