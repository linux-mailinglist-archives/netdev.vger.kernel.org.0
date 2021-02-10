Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6449316614
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhBJMIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:08:50 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6024 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhBJMGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:06:55 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6023cc370000>; Wed, 10 Feb 2021 04:06:15 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 12:06:13 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 12:06:11 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 10 Feb 2021 12:06:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a9BVwsKXibuKtuKI6xHqHZ2dI3vd7IfX09AAQHlLbe1fM+d5vM4L2O2lh8byjTB10Z1TAd66LWLCNEOoA7i28wDfC6hxXg6zXGtL9bEsCs64ocpT5XYMnhnd4cRGHOY09AnnDDtxQxGOspnA9BW2nts6CgCmr8n2nPIqv3qZWjO2BYZoWH/bE6KWA/ycoqqYTbjQP7EHtlFceIZ6vVOG7zDr9LCVTP2Oq3vxcn4HC46Q9VEm04q+M5Ei7Kcrs4dg2QqhQykDy999q/VXBGaX7I8ofZ9FCiCcFsnuG/458TUSw4PzWo81AvW5UORJf6mzUngghS9Pq9fwYn/Il4mJCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZI1Xp8GnQXVxzJRBKPxaaypszr5Wgep3J38vkntSr8s=;
 b=EsoF2ne771XRVJWrYNbjEN+HmnPuqYdP0gv8WKR2IMwJSrVLta8gpco0aymJEbMDKtLJicQ+1ud+RYMHc3PhWcgWHjfdGEhz9jGoDxTMQsGNM3eiplJkozFBLuXzuRcfSE6AAqOjaOGN33qjiBF/ChJESKRx8I6iVs/y4iBW9pQiUuCEQ2+13f6QW/wqMyc9Utn9nI+P2bdhOqnskT/l8FiFrM8s1XcIXfpMKZXGFL5AhJ41LwaFIF52gUKVitTCnzVGskpPR2zR74OckG+YR8dlkygG+DR4oB830vFEknrQUjblUECrmKPZ0Yw/MXzwsG+2uYqEo+HqECQDS4/leQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM5PR12MB1644.namprd12.prod.outlook.com (2603:10b6:4:f::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.20; Wed, 10 Feb 2021 12:06:04 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::4103:b38b:a27c:c7e8]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::4103:b38b:a27c:c7e8%6]) with mapi id 15.20.3846.026; Wed, 10 Feb 2021
 12:06:04 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>, mlxsw <mlxsw@nvidia.com>
Subject: RE: [PATCH ethtool v2 1/5] ethtool: Extend ethtool link modes
 settings uAPI with lanes
Thread-Topic: [PATCH ethtool v2 1/5] ethtool: Extend ethtool link modes
 settings uAPI with lanes
Thread-Index: AQHW+ZDNTwOZJQpW+0W09cES2RUmuapQQ6sAgAES94A=
Date:   Wed, 10 Feb 2021 12:06:04 +0000
Message-ID: <DM6PR12MB4516B1725F9B19B7975F8373D88D9@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20210202182513.325864-1-danieller@nvidia.com>
 <20210202182513.325864-2-danieller@nvidia.com>
 <20210209194020.a7yjjd6hxj33l6ld@lion.mk-sys.cz>
In-Reply-To: <20210209194020.a7yjjd6hxj33l6ld@lion.mk-sys.cz>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a36a5b9b-7217-4390-49d1-08d8cdbc3dca
x-ms-traffictypediagnostic: DM5PR12MB1644:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB1644AEB6C4D62455F45D10BAD88D9@DM5PR12MB1644.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N4bkvG+iDWSW7yEbuYxW3PHbFc/jts9c2Y/BkQaiP9CH6p5fXENgz9oJqnJwggLNpiaPas6/jLgCuLIngEf6e7BKuz6f3IBirUA4uslbk9ME/oHxWMuK4f30EuClu0UgxSCXNkz/kaK66rUC81/sCKjUB2qcRXtBEsS6EKDiOL+7iTxTG7N7+USUn4umXIGiS3x0nVohMsHNv0cjVqnwfyStNrFPb8orfMmhaQoewLpyID+TUr9pGMvWK5aHlNb+nsUKVRrbJ29SGZvwPy81Vy+resUPRkipl+T7gHraLrv90sModxzzHOraiywk+6CMCLYueQhbGX0ZjX8X1hMphHjott8MeEFvNCu2Z79b13ANSr/NZqbt8m5Xx2EOk1/uiI+cP+KHMEbcwEN1wl/LGNog79JDZzAJ1vQ+O0Yv+7nUKVPVrLPgfNpbEJeij+gupfVSjSI6DbMpEveQyUz9cpeTp8qjQiazorvIVDRMPlO+OamkHWqAxDp/b9vCKuXf1e3ZZ+0TVwfJqV4Z1epPyo0LoNHNl5M2ygj3KQZ/gR7dYnsgIKxQUvp2YrSooUCKJajvNo0UUdDvS4S7Jwi8O+tzZ+GGQMPP/undQ8YY7nE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39850400004)(136003)(376002)(346002)(4326008)(9686003)(8936002)(7696005)(55016002)(66446008)(64756008)(186003)(2906002)(86362001)(66556008)(66946007)(33656002)(76116006)(66476007)(316002)(107886003)(54906003)(6916009)(71200400001)(5660300002)(478600001)(26005)(83380400001)(8676002)(53546011)(6506007)(966005)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?LaBTBGm5uDoJB0gJruoSUABduYWRetjJ+S4YcjBU2RXzrIhELnLP8Qypo6qf?=
 =?us-ascii?Q?61TnWarkmtIO1X4hJAbY3vtZ0DLN9DeOo7UPsDRGDuZ75setd6q3w4dXFChr?=
 =?us-ascii?Q?tkFGLNoEI6WAXKWNOq4/jgV/o+sfKE54uCdd5MLqWjR0apwPJYNbwgEA42MI?=
 =?us-ascii?Q?OziV9OgRkLQsiufeSmtHh3UhreNnzxtjFcM5bjlU1dPumexrNh3LxwPzQ2Nx?=
 =?us-ascii?Q?mzfA18koyYaDnBT2qnLLWeq3j/e6a2zvvsp0nksHMDp4fANjWY72o5W4uCSI?=
 =?us-ascii?Q?AlbxokXf5VU8tVblhC4+Sm7gSTU5GSMh890xaQah4c0UjOwoNPpMUhVNCCE0?=
 =?us-ascii?Q?vVyFGNDc+HF4zrr8gyIKjV00Ab9l6thOdRlgb0akMFfrb0wrbmdSOrL8FhhQ?=
 =?us-ascii?Q?zCq1M505Y+vJSbDUirWw371H3KBiLo1HMbI4+weirwbOa6Ncvu/vbnwHlZ0c?=
 =?us-ascii?Q?dg71p/qvvpVUQgzKE5pIMls+CAnyrLKONYOm/iHqAS3Vw0Y0k8jqYWGLPZU9?=
 =?us-ascii?Q?rtKCc2F67nVmTWj0iVsdKbvbL4QaF+pmy4rqCNdHKjl/UufwGAUHKg4BvY0J?=
 =?us-ascii?Q?m8KJEPfwK+5/B+5bdbsvidd8CAl6VxnEBOrISPswhsawi488OE8XsbJlgvtL?=
 =?us-ascii?Q?dP4kfyRcLMuOKRmltBY5JxN2ENsyjjesInV+uMdVJormzwASUikB8YbFFcMW?=
 =?us-ascii?Q?Mq4SPOUBylH880Rh+Cma6ftCJ2sb8bAleg+b/rBil/jlKPJ/BJ0CC95j1TgZ?=
 =?us-ascii?Q?6DStmi5TZ7NLw6dVuhoNYpc/q6Fl+TkXNTzkaHPnYpftUU18zGlYhXw932Un?=
 =?us-ascii?Q?3/KjSibqGTxYH3L4akq9yd6skHRtQnaBRAKxD7c9XQBsQi4m9w+prlM3LYl0?=
 =?us-ascii?Q?vc2r1j/5CDzo7TETY5nje6oobxMsDcTDkP/oIigYDAjArR9Ny5VF+9oJ1IGB?=
 =?us-ascii?Q?nNEZRiS02FcUN+j4gTqDJ4o1HBxNSJaydfhKZ48uJ4P8wTE9yh4jOooo03et?=
 =?us-ascii?Q?lKFjSUlS4OlJMZ3jPYxmUeOA5pVEWAZBWdZaDBcRKLxItQpivr6tW1YrNyoN?=
 =?us-ascii?Q?KAhUFlhuDik17Z+MvLMwQF/VKRSSqUxdEM0zDoIazR2sPr2mjxKoEJA6uk8d?=
 =?us-ascii?Q?TVGsSDU6/Nm3DSI14oXKC8Peplso5+5HGW3tMrSVey9LmUt3RuqlkqgOtGZC?=
 =?us-ascii?Q?I7J2Ja0Fxg9BsjPwv4lyrf9b43kaQsrseevD1mtyp9S8ednQQEkk07gpiVEw?=
 =?us-ascii?Q?dFjf6NNCfFerM3VOEbR4PzTCR8IklJCUnht0M6f8AvByyrUyqyqy3fESGu+c?=
 =?us-ascii?Q?yibsf+aRgkOTwTZ5rhgoo/PJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a36a5b9b-7217-4390-49d1-08d8cdbc3dca
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 12:06:04.2379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V1Gbjhn9jFqMuMy0Vj5K7rFMVrT5KXaOJAjRCGhdjDefPkyn/N20vIm0T7bULTEpHqXYPP0s/khUq9t/Lb/cwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1644
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612958775; bh=ZI1Xp8GnQXVxzJRBKPxaaypszr5Wgep3J38vkntSr8s=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-header:x-ms-oob-tlc-oobclassifiers:
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
        b=B3BZJHDIX1llm5dvmyxRZ4EBZGOC416s4n6uqL1WP6wQtn3fUUSfhgjLxXF7dOwcy
         oj3+BtgvLdn1zACZYP+LfewOxBQdHPH8nk0eSfiz1IO47pEy6uyAKdzxcoF8b0Aa5r
         Ub/S392tDExgy78r0NBfHpBpsQahydPQHry2lO+DKhLJ9cLV/PZTy5CgdpRQn6JYGa
         7gPjt4AMpsKThx1m/zGv4qlpQQJ+pO/cxGcNGL7fjprI7M1vssnzF6RLzxVYJfn1+z
         s6Ydz0+fqhTDEc/ZhidTnqT+Ab2fjVgqldN72nDA5jYzZHPV3Sl4aSC6mTY8wAPy+/
         wl7G3iFy8AYAA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michal Kubecek <mkubecek@suse.cz>
> Sent: Tuesday, February 9, 2021 9:40 PM
> To: Danielle Ratson <danieller@nvidia.com>
> Cc: netdev@vger.kernel.org; f.fainelli@gmail.com; kuba@kernel.org; andrew=
@lunn.ch; mlxsw <mlxsw@nvidia.com>
> Subject: Re: [PATCH ethtool v2 1/5] ethtool: Extend ethtool link modes se=
ttings uAPI with lanes
>=20
> On Tue, Feb 02, 2021 at 08:25:09PM +0200, Danielle Ratson wrote:
> > Add ETHTOOL_A_LINKMODES_LANES, expand ethtool_link_settings with lanes
> > attribute and define valid lanes in order to support a new
> > lanes-selector.
> >
> > Signed-off-by: Danielle Ratson <danieller@nvidia.com>
> > ---
>=20
> When updating the UAPI header copies, please do it in a separate commit w=
hich updates the whole uapi/ subdirectory to the state of
> a specific kernel commit. You can use the script at
>=20
>   https://www.kernel.org/pub/software/network/ethtool/ethtool-import-uapi
>=20
> It expects the LINUX_GIT environment variable to point to your local git =
repository with kernel tree and takes one argument
> identifying the commit you want to import the uapi headers from (commit i=
d, tag or branch name can be used). In your case, net-next
> would be the most likely choice.
>=20
> Michal

Should I use the commit in net-next that I added it uapi headers, or genera=
lly the last commit of net-next?

Thanks,
Danielle

>=20
> > Notes:
> >     v2:
> >     	* Update headers after changes in upstream patches.
> >
> >  netlink/desc-ethtool.c       | 1 +
> >  uapi/linux/ethtool_netlink.h | 1 +
> >  2 files changed, 2 insertions(+)
> >
> > diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c index
> > 96291b9..fe5d7ba 100644
> > --- a/netlink/desc-ethtool.c
> > +++ b/netlink/desc-ethtool.c
> > @@ -87,6 +87,7 @@ static const struct pretty_nla_desc __linkmodes_desc[=
] =3D {
> >  	NLATTR_DESC_U8(ETHTOOL_A_LINKMODES_DUPLEX),
> >  	NLATTR_DESC_U8(ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG),
> >  	NLATTR_DESC_U8(ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE),
> > +	NLATTR_DESC_U32(ETHTOOL_A_LINKMODES_LANES),
> >  };
> >
> >  static const struct pretty_nla_desc __linkstate_desc[] =3D { diff --gi=
t
> > a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h index
> > c022883..0cd6906 100644
> > --- a/uapi/linux/ethtool_netlink.h
> > +++ b/uapi/linux/ethtool_netlink.h
> > @@ -227,6 +227,7 @@ enum {
> >  	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
> >  	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
> >  	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
> > +	ETHTOOL_A_LINKMODES_LANES,		/* u32 */
> >
> >  	/* add new constants above here */
> >  	__ETHTOOL_A_LINKMODES_CNT,
> > --
> > 2.26.2
> >
