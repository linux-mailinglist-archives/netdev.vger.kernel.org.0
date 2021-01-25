Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D692E303446
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbhAZFVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:21:36 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10662 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728519AbhAYPyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 10:54:33 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600ee97a0003>; Mon, 25 Jan 2021 07:53:30 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 15:53:29 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 15:53:28 +0000
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 15:53:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1EWfi/QtQsJZniQC59FMoI+o8GsSq5T0bhyriSNrgw6HUgPREaBGZBxTPR6V3eopSVmPOsGS+B0X3gspGHEYfjeJB2HFJPx8B2hcfpwF9oJfSkCH/e4RWqItLR6rv9A/Ovsec85zqkRm1HtyOgpwFP+o+Qg3j6QM1QwNs9HF+U5LNlT3KIApGSVgG2Iby3cqOiqBYIidKxlkxWhUdvGpK6EJZtwuBvQv8bgIgdqwLKjBoPdWQ+nrBewmgtieW/S/jTm2CERj4inPZjQrX72KbkEnN958iAO1dDXzhB57iOXdEZwOdzmn6PxNczEFykf0nJKXPODASd+MoTOZilZig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qL0r1+cr1F+5a259b/vsNv2XJ4VBKchPOM8LWUmUbU=;
 b=i3A6k8ra6qW26niOUkgCIcAwls5VQxpulGJs2+If13imi69gbZb0Ffc4bYEmtdbChV3KxiQo/Xq4PbUkVng3Vnh6VQGQqhadIrteyjcdjwoxtOVcUPeDBqzT0rhycTZiBvI9aHUeNPE4TBwqIg9nbaWx8bpUbaIaBODESiSmmHB2EJ/6OadSP2AfW6GyC0ECbajXytnPcMIJGmjQ0NFfL7d/Otv10mqbAQyxzqFZlfyFNIB3kLw2z2CjxUwuhqbRVQgSq3xfcObRlic/PMEnHnvQ02ODm0X30ZHHc4kgYMoOyNVRUcaK1PjbCKAFzuk6W8V0EgeWPS7eYuSrtDHgZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM5PR1201MB0220.namprd12.prod.outlook.com (2603:10b6:4:4e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Mon, 25 Jan
 2021 15:53:24 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::4103:b38b:a27c:c7e8]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::4103:b38b:a27c:c7e8%7]) with mapi id 15.20.3784.019; Mon, 25 Jan 2021
 15:53:24 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>, mlxsw <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: RE: [PATCH net-next v3 1/7] ethtool: Extend link modes settings uAPI
 with lanes
Thread-Topic: [PATCH net-next v3 1/7] ethtool: Extend link modes settings uAPI
 with lanes
Thread-Index: AQHW7w/k9y6sUOLEbk6cSTfGh0CjPKozA8CAgAN3oJA=
Date:   Mon, 25 Jan 2021 15:53:24 +0000
Message-ID: <DM6PR12MB4516C3011B5D158930444203D8BD9@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20210120093713.4000363-1-danieller@nvidia.com>
        <20210120093713.4000363-2-danieller@nvidia.com>
 <20210121194451.3fe8c8bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210121194451.3fe8c8bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [93.173.23.32]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c9f96f8-bf0e-4d7a-45b0-08d8c14958ea
x-ms-traffictypediagnostic: DM5PR1201MB0220:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1201MB022085AD0F9CC93F7BD8D446D8BD9@DM5PR1201MB0220.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5ZPSgzbEBseMGEiJCGqGs7KWpe33/xh4cloUMtplq4pgQUvfSqE1FrrQ/S5qjiKwuFjV1/RQjETqRzb8rBeAv3QhskO34b9W97YCYSlkc9i2inQjWikBBTyYilHIn6A9fvJeqZyH5Y1a5BjxkkrlPKTOljXGu519TkEOs+SKUQaeoP54sO+5TFwTWG+EGlFxgYQyXemjjdf3Cvyd2je021IVwU8JpeJT48mUzURFLJBoNP3hWttPdBecOzWHINMMSFLl85YtpxWcIr0c8K1n19NI5yL4vpqo4vsOpUPD2AmZUi+yIB/eZAVmshSmi+dF47UamXWmlsGDJgk4EEfl/uAmElGSrt9DFxuBPE5eENDm4mEoWdrdHZVv7nqFbEhtvc8EU3BT71iWEzbY4IH2XQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(346002)(366004)(136003)(52536014)(26005)(66556008)(64756008)(5660300002)(66446008)(76116006)(66476007)(66946007)(186003)(6916009)(53546011)(6506007)(71200400001)(316002)(7696005)(55016002)(8936002)(8676002)(86362001)(54906003)(478600001)(9686003)(33656002)(107886003)(4326008)(2906002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?DHyE3GdwV2ElWy/UEYziIvNaJUgzO7mvFIB6T0ak44w56JLW1IjenNLyrDo8?=
 =?us-ascii?Q?dn55EbndZ+pkIwYP7ZzzMdp7MMbLnOEDLekdri61lDdgYLPdGmwsCGXGqXFp?=
 =?us-ascii?Q?Ay+rTz1HEpERUhWihh59BYKD5S/Q2HJ1xZD72QVND4kU4T/0v2jzcV4Bb7GT?=
 =?us-ascii?Q?YLw3oiocCOvA6/ZiAqByzQ/5MeTUEf+gxq64jM0MMhDw6zSUQej/NLjfuLih?=
 =?us-ascii?Q?zn0hpx8myLd7N8/MMvpCWkSNB2KBLs7k1ZevzPYNKGmwqNo0BSDNkgIiV06I?=
 =?us-ascii?Q?sdhfR52XPmF8n+UkhMUv0vOISIEf2KAglWUPufksXSTOIGRsSqijBAy6B0eL?=
 =?us-ascii?Q?Wd1j51JsK587BY6irBwrnqJrsI4+s3Ri+resyu16HdMeArwBagUzuGGdFmra?=
 =?us-ascii?Q?tR76Ls8Mlg/CCRNS1a9bV4B0EETKggjqmGLD20+E2JloXEYHl2ekvvyYn04D?=
 =?us-ascii?Q?w0bH2/8VXFzZUNDCGzFKZvKyywjicwlYUsXbofk4W1wxSTc6cmu2gkWBb+1t?=
 =?us-ascii?Q?nGbjC1yebQ/Tff5eHw6Fpx5+GiRz4gTrvL37CfFNq/OXgZ628LRiobBXj02k?=
 =?us-ascii?Q?k9iv8FOrTjlzVzo14hWFhNGkkr3iRvPBJ1wZILtTbXJTdTEeJe1K4nQNNbN7?=
 =?us-ascii?Q?yOM8Fu5ZwiGS/6g1La7Jq0MTbP+ZQfb96QqcflBJ7q4in/9i0vNrNNPHCS+e?=
 =?us-ascii?Q?jCVSb6EtwM991dsOWw3s9xmQwy7TMl96BNQwWLelxd1YkbYP6MAnLDyoGP/C?=
 =?us-ascii?Q?OQfQVjE/DCSugz+KRGJ6wwJOxvEDJJQ5vb+BLcoV7SLdzcQZ9swxB3wJZJ48?=
 =?us-ascii?Q?tBR+s6YnyQojYY7g8skisoXNXOOX57nTSoVLs56zxZ+HOpjDTX/ChU9RUMNv?=
 =?us-ascii?Q?EQsvjG8z6pVZtg27InIIZ/H1qlYrY+FHYk9s34ZxVozVlCDqIrOFEtSaMP1B?=
 =?us-ascii?Q?IoiYvERQaHEWT6Lex5gM89cIuptwR6FGUXnnrCy28C14erF+4I5sNOhIXlFJ?=
 =?us-ascii?Q?z7JZDc2hlbFUHzAMqAsHQSEbrbJrifVrgY1sZRgIQeWLvApk+HF7TCgCXTSB?=
 =?us-ascii?Q?oSI01dms?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c9f96f8-bf0e-4d7a-45b0-08d8c14958ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 15:53:24.0391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K4WWdWTPQt5nsdZpC9mrIInME+6j+lxugDDMK+efdL+WAGv5BV5miPNXc+gawESlD0qKpnJGT4rxQszQFyN/Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0220
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611590010; bh=+qL0r1+cr1F+5a259b/vsNv2XJ4VBKchPOM8LWUmUbU=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=I+XcjEFfLU19GSikSqhf6toYCc+mjKhcOI/l7IyJ0LjRO2XyyowC5P2xg209EHNwT
         rShm1VcMngyvsVskBD4ZL9V3j7ctCku0cm0FDKdITRImsYjrhAgCkMdd3KaHrMbrzm
         gTMQEO0nW0SjvzPZHjtRg5UYrXsc7B0FSzw3kpRfbbW1AlSqMBixVAC4BEmJLLBreM
         2JVbKi3CmZlTMNqeh4/sFAj2yc6phEUeW5fM3VjKIbyxmWTvr4sQllKwHSxDpi2EXc
         u87s/jgWhxQLnsNHCSpatLUNtU56ECVB6I1LYK81JgK+p+spiy9wn63D7gykj+UCQ3
         gurQSVY9Gy6HQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, January 22, 2021 5:45 AM
> To: Danielle Ratson <danieller@nvidia.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; Jiri Pirko <jiri@nvidia.=
com>; andrew@lunn.ch; f.fainelli@gmail.com;
> mkubecek@suse.cz; mlxsw <mlxsw@nvidia.com>; Ido Schimmel <idosch@nvidia.c=
om>
> Subject: Re: [PATCH net-next v3 1/7] ethtool: Extend link modes settings =
uAPI with lanes
>=20
> On Wed, 20 Jan 2021 11:37:07 +0200 Danielle Ratson wrote:
> > Currently, when auto negotiation is on, the user can advertise all the
> > linkmodes which correspond to a specific speed, but does not have a
> > similar selector for the number of lanes. This is significant when a
> > specific speed can be achieved using different number of lanes.  For
> > example, 2x50 or 4x25.
> >
> > Add 'ETHTOOL_A_LINKMODES_LANES' attribute and expand 'struct
> > ethtool_link_settings' with lanes field in order to implement a new
> > lanes-selector that will enable the user to advertise a specific
> > number of lanes as well.
> >
> > When auto negotiation is off, lanes parameter can be forced only if
> > the driver supports it. Add a capability bit in 'struct ethtool_ops'
> > that allows ethtool know if the driver can handle the lanes parameter
> > when auto negotiation is off, so if it does not, an error message will
> > be returned when trying to set lanes.
>=20
> > Signed-off-by: Danielle Ratson <danieller@nvidia.com>
>=20
> > diff --git a/include/uapi/linux/ethtool.h
> > b/include/uapi/linux/ethtool.h index cde753bb2093..80edae2c24f7 100644
> > --- a/include/uapi/linux/ethtool.h
> > +++ b/include/uapi/linux/ethtool.h
> > @@ -1738,6 +1738,8 @@ static inline int ethtool_validate_speed(__u32 sp=
eed)
> >  	return speed <=3D INT_MAX || speed =3D=3D (__u32)SPEED_UNKNOWN;  }
> >
> > +#define ETHTOOL_LANES_UNKNOWN		0
>=20
> I already complained about these unnecessary uAPI constants, did you repl=
y to that and I missed it?

I guess I missed it, sorry, will fix.

>=20
> Don't report the nlattr if it's unknown, we have netlink now, those const=
ants are from times when we returned structures and all
> fields had to have a value.
>=20
> >  /* Duplex, half or full. */
> >  #define DUPLEX_HALF		0x00
> >  #define DUPLEX_FULL		0x01
> > diff --git a/include/uapi/linux/ethtool_netlink.h
> > b/include/uapi/linux/ethtool_netlink.h
> > index e2bf36e6964b..a286635ac9b8 100644
> > --- a/include/uapi/linux/ethtool_netlink.h
> > +++ b/include/uapi/linux/ethtool_netlink.h
> > @@ -227,6 +227,7 @@ enum {
> >  	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
> >  	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
> >  	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
> > +	ETHTOOL_A_LINKMODES_LANES,		/* u32 */
> >
> >  	/* add new constants above here */
> >  	__ETHTOOL_A_LINKMODES_CNT,
> > diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c index
> > c5bcb9abc8b9..fb7d73250864 100644
> > --- a/net/ethtool/linkmodes.c
> > +++ b/net/ethtool/linkmodes.c
> > @@ -152,12 +152,14 @@ const struct ethnl_request_ops
> > ethnl_linkmodes_request_ops =3D {
> >
> >  struct link_mode_info {
> >  	int				speed;
> > +	u32				lanes;
>=20
> This is not uapi, we can make it u8 now, save a few (hundred?) bytes of m=
emory and bump it to u16 later.
>=20
> >  	u8				duplex;
> >  };
>=20
> > @@ -353,10 +358,39 @@ static int ethnl_update_linkmodes(struct
> > genl_info *info, struct nlattr **tb,
> >
> >  	*mod =3D false;
> >  	req_speed =3D tb[ETHTOOL_A_LINKMODES_SPEED];
> > +	req_lanes =3D tb[ETHTOOL_A_LINKMODES_LANES];
> >  	req_duplex =3D tb[ETHTOOL_A_LINKMODES_DUPLEX];
> >
> >  	ethnl_update_u8(&lsettings->autoneg, tb[ETHTOOL_A_LINKMODES_AUTONEG],
> >  			mod);
> > +
> > +	if (req_lanes) {
> > +		u32 lanes_cfg =3D nla_get_u32(tb[ETHTOOL_A_LINKMODES_LANES]);
>=20
> req_lanes =3D=3D tb[ETHTOOL_A_LINKMODES_LANES], right?=20

Yes, but req_lanes is a bool and doesn't fit to nla_get_u32. Do you want me=
 to change the req_lanes type and name?

>
> Please use req_lanes variable where possible.
>=20
> > +
> > +		if (!is_power_of_2(lanes_cfg)) {
> > +			NL_SET_ERR_MSG_ATTR(info->extack,
> > +					    tb[ETHTOOL_A_LINKMODES_LANES],
> > +					    "lanes value is invalid");
> > +			return -EINVAL;
> > +		}
> > +
> > +		/* If autoneg is off and lanes parameter is not supported by the
> > +		 * driver, return an error.
> > +		 */
> > +		if (!lsettings->autoneg &&
> > +		    !dev->ethtool_ops->cap_link_lanes_supported) {
> > +			NL_SET_ERR_MSG_ATTR(info->extack,
> > +					    tb[ETHTOOL_A_LINKMODES_LANES],
> > +					    "lanes configuration not supported by device");
> > +			return -EOPNOTSUPP;
> > +		}
>=20
> This validation does not depend on the current settings at all, it's just=
 input validation, it can be done before rtnl_lock is taken (in a
> new function).
>=20
> You can move ethnl_validate_master_slave_cfg() to that function as well (=
as a cleanup before this patch).

Do you mean to move the ethnl_validate_master_slave_cfg() if from that func=
tion? Doesn't it depend on the current settings, as opposed to the supporte=
d lanes param that you wanted me to move as well?
Not sure I understand the second part of the request...

>=20
> > +	} else if (!lsettings->autoneg) {
> > +		/* If autoneg is off and lanes parameter is not passed from user,
> > +		 * set the lanes parameter to UNKNOWN.
> > +		 */
> > +		ksettings->lanes =3D ETHTOOL_LANES_UNKNOWN;
> > +	}
> > +
> >  	ret =3D ethnl_update_bitset(ksettings->link_modes.advertising,
> >  				  __ETHTOOL_LINK_MODE_MASK_NBITS,
> >  				  tb[ETHTOOL_A_LINKMODES_OURS], link_mode_names,
