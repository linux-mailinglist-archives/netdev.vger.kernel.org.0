Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B082F28BBFE
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 17:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390043AbgJLPdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 11:33:50 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:5519 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390039AbgJLPdu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 11:33:50 -0400
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f84775d0000>; Mon, 12 Oct 2020 23:33:49 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Oct
 2020 15:33:48 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 12 Oct 2020 15:33:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMBJNU7shbzRaJs5ehIf6yM4eEsTl91M5sayagE7yVU0otS8qG1NFVrRLO2vJ4l+WTQKDNc1+r76uuoUZZVWasgNUCPw1VIc5tgXdJmBxIV9zI7xm1Snm9GcF02FiiOSVtv07+QjVSqFpL1LQeWl/k1clq/ms2iYmgx5mrI7FhZl7XOyV2ekZS8Z4TeOJPwZKzAgY8Uiec8lJ1yiv+ZY68sTvQVmhG8Tl1on9r2eDgLDRkLkDuxqlS+9JsYBRNV6a2mH3msT3UgYuBCwW51TzxAd8jQXxXvuSbU+c0VGTqZ/PlC43z6U/Wsy0dCPy2+wb+bZ9SGEa2k2xd4PTy770g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ed2AUnjX6geeyc1K5FKetVknnYBs1JCkV7jq+eoCaGE=;
 b=m9HHB9sOqGSAh+ZOMdHXjIiiTaLnH0a7pH90NiIaI6K9CRJfS2XuLQnvpmaM7d1QSPoN32ClTELLMxW9POlsWgSWurrVf7lk5adQz01NyByPRZEc0buqtUzLqk14t6e6riPAxj+xFB0jwnDvlPOi3bfq8rWVt9f1bHqiqnniGO1wKRvnAWLg+I1SIQyePWntnr1y7YrqGQ6p17NMVuuFJqKnjJlGUfsFENOmHf15RjzZh0/FZ0j01AQQuK5LdQHJx7XWUt9c/JhPZU1sB7pMBCqzCw+MVMh6zVpXrDkA0AlTfz430KNAyY2Y8njPpeLY53SwPldGQ9j6Mc6KWZfFaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (2603:10b6:5:1c4::14)
 by DM5PR12MB1868.namprd12.prod.outlook.com (2603:10b6:3:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.28; Mon, 12 Oct
 2020 15:33:45 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::7538:53df:80a:24e8]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::7538:53df:80a:24e8%2]) with mapi id 15.20.3455.030; Mon, 12 Oct 2020
 15:33:45 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>, mlxsw <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: RE: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Thread-Topic: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Thread-Index: AQHWnxvjfEscixWoTUGw9NLDRcgaq6mTAB+AgAEV0YA=
Date:   Mon, 12 Oct 2020 15:33:45 +0000
Message-ID: <DM6PR12MB3865B2FBA17BABBC747190D8D8070@DM6PR12MB3865.namprd12.prod.outlook.com>
References: <20201010154119.3537085-1-idosch@idosch.org>
        <20201010154119.3537085-2-idosch@idosch.org>
 <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c8c92c59-a2c7-4159-6fa0-08d86ec43520
x-ms-traffictypediagnostic: DM5PR12MB1868:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB1868B9D429455CFFA7D26584D8070@DM5PR12MB1868.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uRlca7H375kiKQaXRHl8Baa+1HfccMKFVLLeQrCCLhbGCgBlztaqTFFAGFF7TSrVVaE08ZuqChKGKUZ775B97XaFnbm9PHQOXFFWPiXIVgeH8gI2xiToYTz+OU/iqQlIXXHhPomHeC7eTRIGFbsHIU74ddsNacIb3T/z/HoxYGvfXfP3LNhfhxRLAY9kyND5GZ4lT7OEYTpJ3XJCDIcI4CTbb7/k8b27FqTUUdU+pKNzSxwRiPN8Ws+3s4ndgk6BXzHBZxDDe10NrIYxn43w2rp/KhRLCap3RhL/Cn/m2d5mtPtxXmkwohx1AmzvqgXW6i3W/QrZol1mEHvSm0bjhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3865.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(52536014)(2906002)(71200400001)(316002)(76116006)(4326008)(83380400001)(86362001)(54906003)(110136005)(66946007)(66476007)(66446008)(64756008)(66556008)(8936002)(33656002)(55016002)(478600001)(8676002)(7696005)(186003)(9686003)(26005)(5660300002)(53546011)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: l0qyBciKBLGQWHuRTJtwsS7P6wo998xZx20Q9pcNnLwiOxb6+QQjzwxC+yvdhOzjCHg5jHm3iCbYx9fcaqZ5VZiicK1oauh13ZMH7XP8xo5eeW1GqAqlXJS063ftBpIcFRKR6VXLRuZRQhlUn6Xmohwrl5BZkJnzk6qTxzqZMR2ehKz6UtK7ieAQz2huS2IFflXr3qp4SEfiC4p/qz28LtdbmtHGUT5vKWskYtQzU3uZbBqKQ4d+cmlotzQq3001quc2Te9sWyauKHrPGtF9ycEBQ22McxodJJN0YPDZKQjld4Q+qRD4DsGfbtrY3GrHsUMwKs8JOJwHU6GCudirnBuE4yKQ3tI+4b7oRlMudDlRynhi+n4ewy1lQIQ17Jx+u54y26TJYMvG0ymgX2oiZmA6fZKnktGOfye943nw2jgzGsk1qP6W5uyBcRp9Ka1vgERdyXIAHX1Z1Hv1yZ5H05i5+o3VXrlyzvuT/PvdMGN1F+oV7pr1sSd9UBSDWTzylxDEBXYdQP6pg5nZxT4tU6XYeUqoB4MnzZsAflhMBPjrCvPKXoKmLFncBJlAdukNq5vOMaIdpT3REn+04yTBAy2IIOxmveyn3SRz1nsnAVVK7pEl0ZYd72SaRxNScn7nsK09YJNhtv0ta12UEvUyqQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3865.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8c92c59-a2c7-4159-6fa0-08d86ec43520
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2020 15:33:45.6279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0f+Y+/DsGDfo6jrOnY5KMGAhm7h/tKUa2huX/PFrHORQLcQL4jKYQN75QB1m7EX+tWGhAiQIGkvWd4JKR8af7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1868
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602516829; bh=ed2AUnjX6geeyc1K5FKetVknnYBs1JCkV7jq+eoCaGE=;
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
        b=LgB5nLG6v2XU/vKTEb65wtvUc5pl/bfH9nw8INftt9aHDIuDyNtJzTL7TOgwSIWvS
         xApy++mAl0YWO8g1nizWJBQRSZq+yeCVFnO+T/cCWoTyWXeO36w3gGeI4YRRqbTyPT
         XDoFgS6rSBRTkjUHARYi7+cM5PTjs4K/U3KnY00KyvkmlL/9gbNsQ38CN0zV2aBfbp
         PRounQt0gnmsc/JVu15wkj3LH/A4rvUJ2vya/paxHL93L7kev5udF2fP+umKCQF1bq
         CkvJkkJdHkFb8pJ6ek5bGbOEhJDkiVYSTIgPCT07YKmHfi9DIvNzzFJUQL+wi+kpNb
         +pwFscvEEnloQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, October 12, 2020 1:38 AM
> To: Ido Schimmel <idosch@idosch.org>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; Jiri Pirko
> <jiri@nvidia.com>; Danielle Ratson <danieller@nvidia.com>;
> andrew@lunn.ch; f.fainelli@gmail.com; mkubecek@suse.cz; mlxsw
> <mlxsw@nvidia.com>; Ido Schimmel <idosch@nvidia.com>;
> johannes@sipsolutions.net
> Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAP=
I
> with lanes
>=20
> On Sat, 10 Oct 2020 18:41:14 +0300 Ido Schimmel wrote:
> > From: Danielle Ratson <danieller@nvidia.com>
> >
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
> What's the use for this in practical terms? Isn't the lane count basicall=
y
> implied by the module that gets plugged in?

The use is to enable the user to decide how to achieve a certain speed.=20
For example, if he wants to get 100G and the port has 4 lanes, the speed ca=
n be achieved it using both 2 lanes of 50G and 4 lanes of 25G, as a port wi=
th 4 lanes width can work in 2 lanes mode with double speed each.
So, by specifying "lanes 2" he will achieve 100G using 2 lanes of 50G.
=20
>=20
> > +/* Lanes, 1, 2, 4 or 8. */
> > +#define ETHTOOL_LANES_1			1
> > +#define ETHTOOL_LANES_2			2
> > +#define ETHTOOL_LANES_4			4
> > +#define ETHTOOL_LANES_8			8
>=20
> Not an extremely useful set of defines, not sure Michal would agree.
>=20
> > +#define ETHTOOL_LANES_UNKNOWN		0
>=20
> >  struct link_mode_info {
> >  	int				speed;
> > +	int				lanes;
>=20
> why signed?

I have aligned it to the speed.

>=20
> >  	u8				duplex;
> >  };
>=20
> > @@ -274,16 +277,17 @@ const struct nla_policy
> ethnl_linkmodes_set_policy[] =3D {
> >  	[ETHTOOL_A_LINKMODES_SPEED]		=3D { .type =3D NLA_U32 },
> >  	[ETHTOOL_A_LINKMODES_DUPLEX]		=3D { .type =3D NLA_U8 },
> >  	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]	=3D { .type =3D
> NLA_U8 },
> > +	[ETHTOOL_A_LINKMODES_LANES]		=3D { .type =3D NLA_U32 },
>=20
> NLA_POLICY_VALIDATE_FN(), not sure why the types for this
> validation_type are limited.. Johannes, just an abundance of caution?
>=20
> > +	} else if (!lsettings->autoneg) {
> > +		/* If autoneg is off and lanes parameter is not passed from
> user,
> > +		 * set the lanes parameter to UNKNOWN.
> > +		 */
> > +		ksettings->lanes =3D ETHTOOL_LANES_UNKNOWN;
>=20
> you assume UNKNOWN is zero by doing !lanes in auto_linkmodes - that's
> inconsistent.

I didn't do !lanes... maybe you mean !req_lanes which is different paramete=
r that specifies if the lanes parameter was passed from user space.

>=20
> > +	}
> > +
> >  	ret =3D ethnl_update_bitset(ksettings->link_modes.advertising,
> >  				  __ETHTOOL_LINK_MODE_MASK_NBITS,
> >  				  tb[ETHTOOL_A_LINKMODES_OURS],
> link_mode_names,

