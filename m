Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B62F33E1F8
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhCPXRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:17:02 -0400
Received: from mail-dm6nam10on2086.outbound.protection.outlook.com ([40.107.93.86]:27233
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229490AbhCPXQm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:16:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kumAPeqrGCg4pAw9i7qDKPdQt76Er5Wzl5eRrPZZcPXr51Imxl6I+0Ghhq6uIeaIgyODXl+AsP/t1hokXwC9a8jUYIARzWGWspCfJKZOqWt6poOV0646rpxLHGqHn4FPfInoPcngW97B/ffJRPGj0nNcDOnFVfxPnwCTkKL+9CC0CqLqQbB2MMX56RTODDvxOuk2pjmbtNP0CnQSYinW/G3HkI4ZinFLIu40douglLgzBLEgEwWgn7Jq+UGqoGJTU6t30DG0RFL8+yM2hqZu5AnsCEqUCPgrvKRa0khRStQfqCR2fRVRRzPBfOv0kk4vIN4vOJKI5gUlTw6fWgIBmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ag9/o2lpWC8ImNXPAnGL60Ym2y4yitNfNn/hWgmShH0=;
 b=HFTFJqGlPbV4qmY3hT/qR9pEzJo7xvSJe/FMreIOQ5dwjykuIZtXVoy63krRmcrT27TI7jTWXu0N0XzQlYFf2sek8PrBZoRWLadAr4aKIWi3caLT5dpJ/4CDPYPwZSJz1bXuGdFbRszPKYdAAcgvWRKKrhWWwb3RpdVyf1jkvaOdz7A0tgo8cWWDK9cpgCtlHdjmQqkGxahe9ZuoqHVBmLTHfn3mL8CRJjFqfwhqD9fdQj3nRbeSYSJ1mHRi82aYr0jioPOvJIvbk8jZULDdKcT8XRmCenL482kQlPT3wJz89LuezB3andGyfrilstCSlEC5BgJM6e5vo6bDid8xhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ag9/o2lpWC8ImNXPAnGL60Ym2y4yitNfNn/hWgmShH0=;
 b=sbeYhdvBfnYWiVX2OA1UUW+swarWMytY71eudnsH82RzWPF0mcCKXgPYNGMlcirnCoXXxmCOaDoA5h+xTB3VcwDvPo7KXano47KWoBV/qVSSNLGZoYztCAaaoVyujgoVEgVnVUxBYuKEB1U64RorjC/cWKvELk4csoXYZjwOXu4uPmaQhaEGJuti6BWHWsNDwXn/xKKgRp3Zh5zR2Ros/SS98X5Fom+v3H2us2dVWHC2GkOkAv1rz0/amBid9wiCnEP1GZK4NKLS0S0AVeG93G8keOauYkLhJ2YZUJcO7c6XE8J0K8AJNlN57Jnf+bNwHsYnWn8CbUkT8Bppn2R/Uw==
Received: from MN2PR12MB2975.namprd12.prod.outlook.com (2603:10b6:208:ce::14)
 by MN2PR12MB3135.namprd12.prod.outlook.com (2603:10b6:208:c4::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Tue, 16 Mar
 2021 23:16:40 +0000
Received: from MN2PR12MB2975.namprd12.prod.outlook.com
 ([fe80::2de7:6756:b3ff:2d67]) by MN2PR12MB2975.namprd12.prod.outlook.com
 ([fe80::2de7:6756:b3ff:2d67%5]) with mapi id 15.20.3955.018; Tue, 16 Mar 2021
 23:16:40 +0000
From:   David Thompson <davthompson@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Liming Sun <limings@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: RE: [PATCH net-next v4] Add Mellanox BlueField Gigabit Ethernet
 driver
Thread-Topic: [PATCH net-next v4] Add Mellanox BlueField Gigabit Ethernet
 driver
Thread-Index: AQHXFatuzchVdMpJhE6oZ9hIKfPRqap/mpAAgAeuclA=
Date:   Tue, 16 Mar 2021 23:16:40 +0000
Message-ID: <MN2PR12MB2975A7F6D302CD59CE307FD1C76B9@MN2PR12MB2975.namprd12.prod.outlook.com>
References: <1615380399-31970-1-git-send-email-davthompson@nvidia.com>
 <YErKXAhto42RU+xn@lunn.ch>
In-Reply-To: <YErKXAhto42RU+xn@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.62.225.91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2510e589-1bb7-4d50-6524-08d8e8d18e40
x-ms-traffictypediagnostic: MN2PR12MB3135:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB3135C0B94D7EA9D13935618EC76B9@MN2PR12MB3135.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cqqtotTyTaQGkAkg22STX3tETXJlcdYdlFFsUE6KDeAz4E6+Z2kEEZmtgYhetjmtWpokEyk33wkp5Bn5FepPH+BUZWIrz5STGdmWIB1Fo/beIdyB6nlmLAY0P764fag3Kl3rdr7AJRv6z8C0h4JHNPtk0oovBkX1skWzckIxvjBTHWNZpkpyIUUGWdWNqknyDO+86bTHASQjJa9Gpx6lIYbAlmsimrivibGGvgTLqTtVr3l6L/8bUvDCxZ9JZHBh4vN3exTMM6jLGumTwNrcMLMagbMQKbrFUysOtGuKtdKf9K6UdTcFhL4uvzNOj3cUUfOq/wyVBZ4vjkTQpyPxAX4yOSgMkkPbL2mUNte8TxTPTHr36WbrPb8qwigE3ib9fmgEnVq01tVxJyfmGowEJr7AZyTEhIQftiXSl1ND3loI31xxauYJwDviz3mUBPsDfqDEIFCwowBjvUx1882dtNqYwhpKN+XF/rcy81JXvkVYjUd0WqNxA42pSQ7UUt39r6RNSaX+YibANwb/fV7SvRkvAysGcxs2UClxp2HqvoPJYLQb2wQYl8/mnE2x1ja7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB2975.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(66476007)(66446008)(66556008)(83380400001)(52536014)(4326008)(53546011)(7696005)(71200400001)(2906002)(6916009)(76116006)(5660300002)(66946007)(107886003)(478600001)(33656002)(186003)(6506007)(64756008)(8676002)(9686003)(86362001)(54906003)(55016002)(8936002)(316002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?2YtVd+fKHoJLcbZAf5AcFyKKL2cPchImbEAKj3cKjRtRW3/Q3JbVgOW0geDD?=
 =?us-ascii?Q?ty+q9400fj0llu8g29UOl87vUrW5kWs+IW7H3vxZIJwElbOLo60J5rH6iGAq?=
 =?us-ascii?Q?ahFL0tV3xbi9QxUBZyyUhCuEgoaS9MQ68+yMNMWbz1xMSIsBTh5tkG3ki1rn?=
 =?us-ascii?Q?kgygAlQcZrPUCODP5z8sHwylZ5DPax4BDRNyP7lsNxXzjNeX8egriT66vKzP?=
 =?us-ascii?Q?HL1CcQNqUrNbraXVFYSw78uWcV4+PMSo4gqGiK4BT4XFmx5v5vRO/H+OilE1?=
 =?us-ascii?Q?BPCV70zStTnu0jlQQUwcJAPl04+Te04+IO+gLjhqsGHmkWfPRqPqDgjUfXSj?=
 =?us-ascii?Q?x3xqxXWq5KOUCPfivx8qTATElx0T9IdRu+tBB87v1+yeMpwXbJG8ZCs5eIna?=
 =?us-ascii?Q?5AuALJ+AOvc+GlaKPKdRQqCnt2HYtsYDnT3puQvlqR1mZ6eahw80E4L4nLWa?=
 =?us-ascii?Q?XNXLx+4JysQvX9b1bqHIbHcfNxy42Pww9tKQN2/XbyALJET1cZ298xwhc5rC?=
 =?us-ascii?Q?HsCJwQiONrzeIJT86Bmdy7pEFuvyvCI68EbBTBTiVuWJXPl4c19xwOVXeKmG?=
 =?us-ascii?Q?nDJAY01tYUX5H6JjzRmNsRtgRUN/vi+OzUsFJyFOQaUpC8NovNyGsd0amKP9?=
 =?us-ascii?Q?zkKO8aCXSgvzeIc64EEAirOHpk3EM9PXdqyEwam/TDo15JNLH9IgqbZHJccr?=
 =?us-ascii?Q?cOho+zd9UHby2DPk45AhLmhZdK6N9RIK4uAlXV1i5+oDBobJxzY+EDoRMuA/?=
 =?us-ascii?Q?UpmVLxAfFpSeeZCPZ8OmVCgVf3qO5tqMFCB4OAy5JogQZ/EYlyXgTPBVdGMt?=
 =?us-ascii?Q?tFiHkT2Gh17Tr+9jb9MiMyWD6qZtLYg9sFduHsR5Dw+knQ7EMKqzNVKk1esE?=
 =?us-ascii?Q?eCEfCSdsJjJgyGlobTIhi2fTFEKt0wInBNYn3prLZvu9uyvBIDih4fyXCvof?=
 =?us-ascii?Q?NBb2+CwSMPD4xfyR+tNbEpz3mW0iudfkNS1vG6ESRgpi68nuD5XAyOjIhxto?=
 =?us-ascii?Q?BI56Q4XOJv5Q9WWivCmwg+iL1hOhDQ1uuo/9ogL2McDtrRIFvPRyGbL9ayzK?=
 =?us-ascii?Q?J7bH4WBQgfGfdgT7KTuQVwHyf97zmO1RIEluVLWahb6NUSMSaRVuhEt3ijCO?=
 =?us-ascii?Q?W+SOnS5w8XfUZoso+UU4/pOQcaFqyjr88RSYSb0JYJkQsWmkcxxssBFcSdeL?=
 =?us-ascii?Q?3mSizi8wfi6PLMKhmKRYbmusPmju2QGZmfq5XVie1JGu7t60W44RFFpROFnx?=
 =?us-ascii?Q?iPaefwL1GsQ2UQbW+ME3dkl9aljSTZPTA/pmo3SCOno0pMN2jO802HF34pCw?=
 =?us-ascii?Q?x5AdPsDmrVrufS86bdFk1Frg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB2975.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2510e589-1bb7-4d50-6524-08d8e8d18e40
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 23:16:40.3999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jl8LKDJFwwezYELo6BbBKx41yRvIxoPqfDOKKLjbvsxqbtDDZa+uCq986O6pkUgWTFnEB2YUF9R573lWb45/6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3135
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Thursday, March 11, 2021 8:57 PM
> To: David Thompson <davthompson@nvidia.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org; Liming
> Sun <limings@nvidia.com>; Asmaa Mnebhi <asmaa@nvidia.com>
> Subject: Re: [PATCH net-next v4] Add Mellanox BlueField Gigabit Ethernet =
driver
>=20
> > +static void mlxbf_gige_get_pauseparam(struct net_device *netdev,
> > +				      struct ethtool_pauseparam *pause) {
> > +	struct mlxbf_gige *priv =3D netdev_priv(netdev);
> > +
> > +	pause->autoneg =3D priv->aneg_pause;
> > +	pause->rx_pause =3D priv->tx_pause;
> > +	pause->tx_pause =3D priv->rx_pause;
> > +}
>=20
> > +static int mlxbf_gige_probe(struct platform_device *pdev) {
> > +	err =3D phy_connect_direct(netdev, phydev,
> > +				 mlxbf_gige_adjust_link,
> > +				 PHY_INTERFACE_MODE_GMII);
> > +	if (err) {
> > +		dev_err(&pdev->dev, "Could not attach to PHY\n");
> > +		mlxbf_gige_mdio_remove(priv);
> > +		return err;
> > +	}
> > +
> > +	/* MAC only supports 1000T full duplex mode */
> > +	phy_remove_link_mode(phydev,
> ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
> > +	phy_remove_link_mode(phydev,
> ETHTOOL_LINK_MODE_100baseT_Full_BIT);
> > +	phy_remove_link_mode(phydev,
> ETHTOOL_LINK_MODE_100baseT_Half_BIT);
> > +	phy_remove_link_mode(phydev,
> ETHTOOL_LINK_MODE_10baseT_Full_BIT);
> > +	phy_remove_link_mode(phydev,
> ETHTOOL_LINK_MODE_10baseT_Half_BIT);
> > +
> > +	/* MAC supports symmetric flow control */
> > +	phy_support_sym_pause(phydev);
> > +
> > +	/* Enable pause */
> > +	priv->rx_pause =3D phydev->pause;
> > +	priv->tx_pause =3D phydev->pause;
> > +	priv->aneg_pause =3D AUTONEG_ENABLE;
>=20
> Hi David
>=20
> I'm pretty sure mlxbf_gige_get_pauseparam() is broken.
>=20
> This is the only code which sets priv->rx_pause, etc. And this is before =
the PHY
> has had time to do anything. auto-neg has not completed so you have no id=
ea
> what has been negotiated for pause.
> mlxbf_gige_adjust_link() should be adjusting priv->??_pause once the link=
 has
> been established.
>=20
>      Andrew

Yes, good point Andrew.  I will modify mlxbf_gige_adjust_link() to set the
private pause parameters after the "link up" event.

- Dave
