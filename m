Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C3741530A
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 23:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbhIVVuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 17:50:06 -0400
Received: from mail-eopbgr50076.outbound.protection.outlook.com ([40.107.5.76]:16768
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238066AbhIVVuA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 17:50:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXEW04KQgrTG0ub0hHZu3Afh7KAmG6oBD4eTy5mLRUX/h8r/FQQz4/3bGVg+vB73lGp7mrnq9Z7ngiSLvMjqiqx9PEI4hbLqggI+6NpOyGCQgRTtmd7iBWVi/ncA5xdS47uRB5dwcqaib1fmVvpM8CBLEbzb49bEOgORtIvXS+USGGqW2wEy5nsDYACsEsaUznk8CmyRUhT//tZA+DO/3t1bCrCJLvfjWnD0PuOPB93GPlVYXt2SYQoJejVNUuQ9LZSt5g/G+qs7MZFtNO/IJEFHz1AAbs2XquTko85jorr74URnBwpcS8kPixIr8tAk5XZQJOh8ufnMX60JMlKQTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=E86/3OJvsmikEuvgD0OCYcrYhMb0fNGuumG1+mIg0vg=;
 b=IqAnncSorLewyEwYhqJt17XxdSYrjhKDUGjtzUL8XPwAgMv9Cd+iva1zSlRjKW+xQjEn47ACRKGNorxE8e/Ef/upF9jmkxP2s7tagigfedCFcjAgwaYX5LWdOV08e6LBVWrthEqO1lUCiK+Rn8JKNtaHB08WoQ0ccajMNZHi9eMciehz9hx8rNddaYsAlPdO/LIY/QyTpY9nAnhsyfX42aQWpSBodjyUmnQXicJV39WhFNTqRG0RuZhhayAxbPydUjzjIH1MlTfUM/IPiU8eOx5FO1FFVlkCdabw2tRaMs1dKuucU9LJRN6DcYjYg5dmlfDwEFJNmuZ9Gs+F5mpLjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E86/3OJvsmikEuvgD0OCYcrYhMb0fNGuumG1+mIg0vg=;
 b=KfmeyDwL0/SSGNQ4ayJ8fWCWJGHJXfWFgOmcJ5oBNWodyxs70LrwGf8cgyfybzbjIXYAFzV3TbxvQRf3geupbnHu4vSrzGjcG2dFiAmriZVM1q1HWYOCg6thMRzVJW84WGKtQ0fmmlrmaJ2eMb0EzgPIZQlzXATbvm3evalHTKc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Wed, 22 Sep
 2021 21:48:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 21:48:28 +0000
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
Thread-Index: AQHXr93LG5LHnXhXOUKrZr2QV4Zp96uwkB2AgAACgACAAATNgA==
Date:   Wed, 22 Sep 2021 21:48:28 +0000
Message-ID: <20210922214827.wczsgk3yw3vjsv5w@skbuf>
References: <20210922181446.2677089-1-vladimir.oltean@nxp.com>
 <20210922181446.2677089-3-vladimir.oltean@nxp.com>
 <YUuei7Qnb6okURPE@shell.armlinux.org.uk>
 <20210922213116.7wlvnjfeqjltiecs@skbuf>
In-Reply-To: <20210922213116.7wlvnjfeqjltiecs@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d6f607e-ca42-4426-7799-08d97e12b646
x-ms-traffictypediagnostic: VI1PR0401MB2687:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB2687E9A481919DB1D6CA19F2E0A29@VI1PR0401MB2687.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:381;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UJwHVTQV/wkX36EEwMct16aZprtyaV5ObH9lS8op7jb+9wCl66tDU7sajvjh65i40v9+0brzKaTiTvUu/WShGkLmmNQJkkZPPG3LVkra7vexPrKGIzd4kYowy82YLtqoFikrGdir4krElkx10VpODUEXI7eZu4+Xn8N7Ypn9JsEdGmuAWrmfQcsNYaNm3Ieb4Kze76+P8Py/CmBIXut92jzXk8TcV1I7mkt5lhnAWD7UrSJyvtsJzHATiRZ3mGGpWlTXqnBz845Aj+CY2NE+PAXfTaBxLS6gf4sN2q/srzpYX5y4QIQmy9FZdjetrTdm5rgawjKvT3MkiuX+qdV0F3KwrKHUle5b42y+G8LUuTdSyznExjfs/RNBfv86BOR6xTZyCh4otARs/zE0JFjPQdEeSnl1y0lhPAnGki+Aw+6ZwnS7Rk3zUjk06c98xMQ5xOMVM1tWAFWVb1dDtVZk0ybUvudOl5HbdIkqLkZeyXadl/wbLi4Lf0hHp5QV+bHKGoNXRYs04kNgdjRVqfKEMd5GgEKOG7dY/bTdevNYeVpk0pevYS96cY11UV94SQOq5ypPDbSjHdJuTxl3qEBzivs72ouuTjK4E65DvAvXTZgO/cLUBxjl971WGONSRYMSo5GiEMTVsW65IHYiu+e38ymm0fop54qbH0gerEbdVJDZpShDzfqncM1tCLACB3repc12QMP9ENa2vRFg+Zn7cPsEBKXjTRyesQuH1uy29DU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(66446008)(38070700005)(33716001)(38100700002)(66946007)(186003)(4326008)(91956017)(66476007)(316002)(5660300002)(66556008)(71200400001)(6916009)(508600001)(6506007)(54906003)(86362001)(9686003)(6512007)(2906002)(26005)(8676002)(44832011)(83380400001)(7416002)(64756008)(122000001)(8936002)(6486002)(76116006)(1076003)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?d8SPR5Bm7cqcHqQ0td+PrYydbgIWWecwCdpjraql5lRCdrF0pIy+m8y9DvaI?=
 =?us-ascii?Q?SmCCIA3+PMqtLWzee0RiTVmPdsRbfGGXcmjqbdbyiVDu/XPq75o7xcx9rm1Z?=
 =?us-ascii?Q?DmjlNIhzxcunaKPhjZqDMLVwNFIKLwhPY043rFz8zgHY86XsarBwcIW/D58E?=
 =?us-ascii?Q?zTHPpGDOrNhyq62VnFM+KhnKhLE3KBLGq/4T6lFRMnddGF3pofqWoN4ipwA/?=
 =?us-ascii?Q?XqaLPq4xklc1an3Bf1uka+Wur5fJ0cONaZuAyvFfPkToo2vU09IZsnjQapSG?=
 =?us-ascii?Q?MeeiuFAn5KXJpcagi/mV3sXBiq4ZODWQ2PmbXBNdENMJIWPOcNQkJN9CGH4b?=
 =?us-ascii?Q?+mFbNhpI0PD1hrBkBP/KaHithGUTVtnEiI+qw5muF7lPdRHB1Kgz3zt3w6Ug?=
 =?us-ascii?Q?+FzzqO9QiS7+5uI/9S+drxPoeO3lMBJ0PoK6qvvCSG3oJDdlG8upEVxDV3gi?=
 =?us-ascii?Q?IiwdfagMPX+CwjHzuerWYxASMy9NmuygfEqY06UMOl2JneyioKF4SUA9z97q?=
 =?us-ascii?Q?OSgkAClK/rDUwquTIW+FDd0Xt3lZ8w7lo5HtI3jzsoM8+D/tY7h5Semw36AN?=
 =?us-ascii?Q?Ctt/XvAsp3OAksejQQlLWHzC3P8wG7/5ZMcm6/F81yimJ2oQGS2MhlAxirKT?=
 =?us-ascii?Q?AUVfdoBJ38Os0BtGp5TsYnHlI6LrXZje7ixnKZW078JLelGge2ktJegRO4uQ?=
 =?us-ascii?Q?pjtI0lNaJiIxFezvppQn40aMu80Uv/YvdJoi9yCU68VPkDqQ/KAL5RWqz4QL?=
 =?us-ascii?Q?SvzB6phB8VrlUZ3pCk+u1Lw9ksWQcp2/zsXtAWRCi7/XV5aomle0PavAhnrm?=
 =?us-ascii?Q?8N1w+pK40NcAr3wnY7KsDb1fdn9O7cujB21CuspoBSIQLb4o7lijx1T6O3Cr?=
 =?us-ascii?Q?bsjfP1frG4RuQsRrKl2gSwLK4TMZ5xOEOWSfcq40/p7AFMLJGUQ9mRGxYLFG?=
 =?us-ascii?Q?Okh9HH69F3sJXeLthrI846rFOrSoyZju9/9BHe+DtgTIxpf+m4WloqPx227K?=
 =?us-ascii?Q?EkrVVtmnZvcwzwCYKnc4MIO1E3IfEgiItd1VY/ELN9H/W0i3SKDZBUfUZMwu?=
 =?us-ascii?Q?C4p/c4NDKAh07LQ/7+j/rppCngOCiPqnmIspBJG7ZQLljIQESpIsvRDY4ofu?=
 =?us-ascii?Q?9350nFMX2OvA5XdFjlIyMmT3G76XithwlbuverBgTUqMpizFPar+C+M7ynWz?=
 =?us-ascii?Q?Kd4WmLAwMgN+vSIlZMubNyHV/1MxBbjoXmf0KFzYRg5zK7UAqxzCF6SUNuiO?=
 =?us-ascii?Q?Gmk9sfLCHl1SVqCh4287Trw2ahVWHuWOpUSRqCEx2QTArbOkk5DpvnioCeSy?=
 =?us-ascii?Q?+uUwZNJQFcfu9MtzEViAnoIGnB0Zv9VpzrV/7RZcqmZTqQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <75399568CFB19047A1CF9069EDB61BA7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d6f607e-ca42-4426-7799-08d97e12b646
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 21:48:28.0319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vr9SB25e4KSNEokKW/Mzq1VR5tGF1rBmdd6usD+0GIfxcAautSiR+iHpjrIoNYx6TZsmwPBM0Sz7a+qYBk6KTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 12:31:16AM +0300, Vladimir Oltean wrote:
> On Wed, Sep 22, 2021 at 10:22:19PM +0100, Russell King (Oracle) wrote:
> > On Wed, Sep 22, 2021 at 09:14:42PM +0300, Vladimir Oltean wrote:
> > > +static unsigned int phylink_fixup_inband_aneg(struct phylink *pl,
> > > +					      struct phy_device *phy,
> > > +					      unsigned int mode)
> > > +{
> > > +	int ret;
> > > +
> > > +	ret =3D phy_validate_inband_aneg(phy, pl->link_interface);
> > > +	if (ret =3D=3D PHY_INBAND_ANEG_UNKNOWN) {
> > > +		phylink_dbg(pl,
> > > +			    "PHY driver does not report in-band autoneg capability, assum=
ing %s\n",
> > > +			    phylink_autoneg_inband(mode) ? "true" : "false");
> > > +
> > > +		return mode;
> > > +	}
> > > +
> > > +	if (phylink_autoneg_inband(mode) && !(ret & PHY_INBAND_ANEG_ON)) {
> > > +		phylink_err(pl,
> > > +			    "Requested in-band autoneg but driver does not support this, =
disabling it.\n");
> >=20
> > If we add support to the BCM84881 driver to work with
> > phy_validate_inband_aneg(), then this will always return
> > PHY_INBAND_ANEG_OFF and never PHY_INBAND_ANEG_ON. Consequently,
> > this will always produce this "error". It is not an error in the
> > SFP case, but it is if firmware is misconfigured.
> >=20
> > So, this needs better handling - we should not be issuing an error-
> > level kernel message for something that is "normal".
>=20
> Is this better?
>=20
> 		phylink_printk(phy_on_sfp(phy) ? KERN_DEBUG : KERN_ERR, pl,
> 			       "Requested in-band autoneg but driver does not support this, di=
sabling it.\n");

Ah, not sure whether that was a trick question or not, but
phylink_fixup_inband_aneg function does not get called for the SFP code
path, I even noted this in the commit message but forgot:

|   So if the 3 code paths:
|   - phylink_sfp_config
|   - phylink_connect_phy
|   - phylink_fwnode_phy_connect
|
|   do more or less the same thing (adapt pl->cur_link_an_mode based on the
|   capability reported by the PHY), the intention is different. With SFP
|   modules this behavior is absolutely to be expected, and pl->cfg_link_an=
_mode
|   only denotes the initial operating mode. On the other hand, when the PH=
Y
|   is on-board, the initial link AN mode should ideally also be the final
|   one. So the implementations for the three are different.

That's why phy_validate_inband_aneg is called twice, once in
phylink_sfp_config and once for the on-board case.=
