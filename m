Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36E048CE96
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 23:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbiALWzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 17:55:54 -0500
Received: from mga12.intel.com ([192.55.52.136]:62411 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234670AbiALWzv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 17:55:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642028151; x=1673564151;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0yuWlAUkRzHoSTAziHjPis8qDhb61eB+HtVZSeBAn2w=;
  b=naShmNah0OKVh//Rwbmqv5qcCrf5fI0bIrfQihhIqUTizsz6yFcorbzi
   6LlJWu6v8umw5lgbMM4tdC9EoX0XKZ5PEagPL0q/w+jSNvbChri8F7LP8
   aAUfLDzv1wLwt7sUiZPFHn2eLG6+Wm6+Z2cEuZwIFt8TqlyLsHAhqYLPX
   q7V30yUXogNZnaKEmdtebNNctXFaHgsnc7zmNSad0P+1byRnWInCzGHw1
   igMB6cEL8nWmwhfpkg04dvlbiSg/pvioiz3UzTR5ZwUai/+1of6grf4oy
   bEmXbxZvr1q4O00jM+a6qyXFJeh73p7SuzbNxRI9KH02HkPFxNoRC/Y6M
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="223854376"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="223854376"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 14:55:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="623634680"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga004.jf.intel.com with ESMTP; 12 Jan 2022 14:55:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 12 Jan 2022 14:55:35 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 12 Jan 2022 14:55:35 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 12 Jan 2022 14:55:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XckB6BSg2IZw/cN7bJfuVjUQ2y96recyzw8JptGzo06CtuIFa6dBwbcSghW2mLAUMTk8F0gdsUygCtoC/+OVLoMSV3x0d8LXdl2VQBhyMffV8a+eFnMxAG3a4XLvy8oQ52G1cMvoHAKit5jNdxOrwVPsX4+oG5sRdOJpTRPHPXZBoB9jcVqb6854aB0pRBhse6tNY+2XML5wwGodeSbfnj+wuuPR6o6jHtAvdpBJUvBY/oRAnL1/lrhIYmIwfPkzyhS9ahdHTPK5bBAOYS+OePyieCg/uMD5dEbj1CjN4+D/gzzGVkU9vM9GO0wygntdYQdV0tLb+bwcO0pZGli+Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=klEACL5klxjOZc4oCo0cArzCSqQMYBY7oiKlif2UXns=;
 b=JY5mbtxFovRWLOiENaFBb+xBEgKMfrOs4yhAgQTGVwu7picjlhl8fplOy760XyKbuosrhXoF3TxYC9KKJ82djkRhMAIhRExVjRW48zHug6Sg1Nkl1c+U2wnVcLGliL4xUq+haEMXgfZPlHVl/EKwlvGnw8AP52sf8WavoX0uvsSG1K+9kb1F6axElpv9o9Zl6tHHHFUar95olJ630ftWtmD1Ea8+NW/1bpua9ODTcpDlHRh+CmJ1GM9GNftITQDkoLxjKTK2Wdc0DAB6z81djawjpGcgjuFab0Wbk8j1/UWckLdmRSpXCYskqel6jaikOMlLvjX1zR0DjTeXt03AkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by DM6PR11MB4092.namprd11.prod.outlook.com (2603:10b6:5:192::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Wed, 12 Jan
 2022 22:55:28 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::4843:15c6:62c1:d088]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::4843:15c6:62c1:d088%3]) with mapi id 15.20.4888.011; Wed, 12 Jan 2022
 22:55:27 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net v2] net: phy: marvell: add Marvell specific PHY
 loopback
Thread-Topic: [PATCH net v2] net: phy: marvell: add Marvell specific PHY
 loopback
Thread-Index: AQHYB5efdv1tXs/AiUepicn/jvMmF6xfXQeAgACh7IA=
Date:   Wed, 12 Jan 2022 22:55:27 +0000
Message-ID: <CO1PR11MB477101305A603B6BC7083360D5529@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220112093344.27894-1-mohammad.athari.ismail@intel.com>
 <Yd7T1e/R9jGWMK2B@shell.armlinux.org.uk>
In-Reply-To: <Yd7T1e/R9jGWMK2B@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ad56442-c6e9-4955-0c2c-08d9d61ea07f
x-ms-traffictypediagnostic: DM6PR11MB4092:EE_
x-microsoft-antispam-prvs: <DM6PR11MB4092B3DD2DA056C25C1BFE13D5529@DM6PR11MB4092.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5IMxOzyHPGzZeCpTItOiWqn7rJFsh5nN8ESICZi8uIyntemIinTSIapjk7BGDbl0gkB2nhs+eddOaac+cZN2xsf2RFi4eMDZNzg0fcM6lELQ+QamWTPMaZOTXouKqFtk5csInq9xc3miJ0sCAg56jmqnAMP80CWzFj5tg14aG2wa4C+debzjwRNbiNIDXKpiwy9zdjYkhFn0nmMtv64R0TybUDN+Fe32ewU3LrUBZ19lzx2rmhys01+mCv4lCLYbyMyZkigGi2CWbe8MvONEtO1v4ZmHHtjVxYgg4ZOWRf7OkNCDtOre54z8IHZ0Qbfy3TyM4rqwqal5M7b7gsmLi4/fctduvAkNWl4dmgMcmZD08RUc65782B8KJWFl+lNBEEgUy4SugK5aXPb7jmteThm7YufzjP39EPtje45E/2bb5EqQXJVEj02eqdEEdmPbDRo157it4yfbDChveNo0ZNQAxymYGNoFrgeiWzxPuDm857vuCWLV5Nc0y2BqTczEvsdnzlCXe7LFyTb+3Eg8Tt1rkz+BMgjkJg6Qzhj7FG+cxP9KUyPKa83idNXmirhDjfiYuntxopZ2Ooo+nHfn80yY5BHeyVSyzK/mTXKSAI81hgCw+QdICx0XecoeafVxxOYkxls1AXebGQ2M2yUhit+P0SHHqcxPE5rQUCWGz3/v7fKTXpZThi7jtniNX8aeK2nTzJWGUuMtsZbIFBHbM8C/uWGHBcK+yI3oJgO7apSkcvxTQWIMjHgGxgV4CUFxKCoX+VTYB4MxXeEB9LhT3BvyeRaEqnztXL5Py/1mn7M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(83380400001)(54906003)(5660300002)(8936002)(316002)(186003)(26005)(966005)(82960400001)(508600001)(8676002)(52536014)(2906002)(86362001)(38070700005)(76116006)(33656002)(7696005)(66946007)(53546011)(38100700002)(9686003)(122000001)(71200400001)(55016003)(55236004)(66476007)(66556008)(4326008)(6506007)(64756008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zeMyxcJbm+a96R0NCDxj05JSxeXdRTUhQaH2srC1kWg88BjWRk3pbE7ogpl6?=
 =?us-ascii?Q?G4WCVlUkeZCO/nDDQK/Xz2FX2eaaF+VtfEEuvqlxuKCihG7CRch8GuUhalDR?=
 =?us-ascii?Q?OTmWVmRnTK4I8HqDo1P4WB3dEBt3LV1rqCPMj8nYyfhvBmxdJECQQywfsxCf?=
 =?us-ascii?Q?FKX3JxvxKZvrHBfv3TLvn1/GLeghsmA/oRz3OJagfc5OCUfStm+hbA7ybm19?=
 =?us-ascii?Q?jNo5sbTsxb8TzF2bP8A9DcsfC+1dI7jYDzWfGFC4wWlXC58Pg3hASdXHRui2?=
 =?us-ascii?Q?0McFIXWrGzu5Vky+qJF87WhsiI3sAloVUK7ldiMWP18hJL3kDmptIT4x+UIp?=
 =?us-ascii?Q?2P6vwI3vv86ObS9gN+Jisxzi1j7jgmtCcpA4B0Zryf7sNm8U+mGujoJSKcEa?=
 =?us-ascii?Q?beNM+fJj/fVGKJXg3EXfa0tSThnjPmMY8VyqbM1FZhdMa8OfaAJ+tzwSvKLX?=
 =?us-ascii?Q?EJ8QG4Rrd8GmcxEIjTTZUDqdFXMboiWCDxfxtpbebkqumbxElehVeFBJ4V1q?=
 =?us-ascii?Q?/KjuL6QpAxIUyaCJDcfe6shpgjfT9fwVfci2ecgiHdQSsW1hN6JZ80Dd5VET?=
 =?us-ascii?Q?XIzCzoaJS3IMBXWH4NKFxk7u8oidURqsYnHPBSHXN1G3inYpy2kxAKn7xk2T?=
 =?us-ascii?Q?S3Ymjk2SzcbDYRVbfE0X/TCsP2GpfIj6AeiL2qccQTV9rpMQqBrLsZm/HDXq?=
 =?us-ascii?Q?LOYnrtoQWv2vNuG6BHyf0ZTCWe55Qk74wz9fsWSgwXcb30MxnL041bu9R+sx?=
 =?us-ascii?Q?eoB0tatRjlRrfvk+XGO2q/GT3Uw1Fa70JqMcgMYFKFLzaJDfcu5XCdae7r2p?=
 =?us-ascii?Q?TErCo0lgSwxk1pDbwk3E4dIyWW9KZFw3vQnyaJi4jOHjocgAPj4/S5Xps8wu?=
 =?us-ascii?Q?xPhtJdw+M8R7v/5QC+0ksT92q985il9+8FJy7eu6heZxSsWniDoTlXcKdzMx?=
 =?us-ascii?Q?+LsGKvaIGRomPpKFIsTy8J2kKoXjgxepR03vHHXXWnr0cw7uw3emIEg0dHBs?=
 =?us-ascii?Q?kpbSbrw0n+JBTtCStfsPQiFWHLK7KpvJ63Axysn6uY24cXZ515CoLUxFxq43?=
 =?us-ascii?Q?pxXyXExBb4PHQJPlWXAlIHV83PjEy/glt+0jixJ72YUqruFH/iV5B1iBDh2o?=
 =?us-ascii?Q?1HL/eDmmsxCPAOgrAylUlF3u2Z4CAsZwfXxJ6Jv+9G2aJl852E3mCTuQazYM?=
 =?us-ascii?Q?Y3+3drKQX+44nBOuuW5YzK0N4ZIVtt21cB973uppCQ/EfP2U/b+ujSni4r61?=
 =?us-ascii?Q?7VQbqyZVgS3LvZ/yxMJBvmgrXUti4YqLeKnMx0himMOCzTuiZYV+Ya+mp6/W?=
 =?us-ascii?Q?kzvJo5WOeFNCW422b9SVHQ2fpWeGygpdo6q63yxWzBVOO0SjEAwjBQDcgJuB?=
 =?us-ascii?Q?ZOdrlC/Q7KmcbA5lwcdlbymEtZ1FaSQrgrR6O4VAlamgAlrf+9uMrKscLXdJ?=
 =?us-ascii?Q?tUyQIXCNiO3Ljz6dF5tHE4p6cJ8rP4TyxCziYs/50NlC0fcZNlpCFnKP/Jh/?=
 =?us-ascii?Q?xGjPu5vSJdyaC18+x5KpTK5fr4UoYuVj+We6TqvSvvMigMU2dIRQIaXdpeAO?=
 =?us-ascii?Q?4dKlK9pOzSRponSDo9teN56esC5SOwObnB8pYS8QgoSC2edmNG7bfmM4qYVj?=
 =?us-ascii?Q?chaCaotuxF9oK7Ysdb/yZltfS22/D7TEFYGGkdImjgFhmTcf6NDkap05LKcF?=
 =?us-ascii?Q?rGAHlUUNRVeis9Lsdqr8wRyRdfuPQaIL6v/C9Vyx9a22i+RDzdG7/rDP5Opu?=
 =?us-ascii?Q?IAwrdU2iTQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ad56442-c6e9-4955-0c2c-08d9d61ea07f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 22:55:27.8585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: seic0EkxVtwaVBY/fD5Rl7fIOmL52x24rPLPYfRRSlPYLgNkvtCRxcXl8xBT/N5vf0nPbo73HFLucFyN5+EhOkifgDWOd3rRD9AQxZosZ2TKuSluO+B1jaGA7nSMZ3jL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4092
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: Wednesday, January 12, 2022 9:13 PM
> To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> Cc: Andrew Lunn <andrew@lunn.ch>; David S . Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Oleksij
> Rempel <linux@rempel-privat.de>; Heiner Kallweit
> <hkallweit1@gmail.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH net v2] net: phy: marvell: add Marvell specific PHY
> loopback
>=20
> On Wed, Jan 12, 2022 at 05:33:44PM +0800, Mohammad Athari Bin Ismail
> wrote:
> > +static int marvell_loopback(struct phy_device *phydev, bool enable) {
> > +	if (enable) {
> > +		u16 bmcr_ctl =3D 0, mscr2_ctl =3D 0;
> > +
> > +		if (phydev->speed =3D=3D SPEED_1000)
> > +			bmcr_ctl =3D BMCR_SPEED1000;
> > +		else if (phydev->speed =3D=3D SPEED_100)
> > +			bmcr_ctl =3D BMCR_SPEED100;
> > +
> > +		if (phydev->duplex =3D=3D DUPLEX_FULL)
> > +			bmcr_ctl |=3D BMCR_FULLDPLX;
> > +
> > +		phy_modify(phydev, MII_BMCR, ~0, bmcr_ctl);
>=20
> Is there any point in doing a read-modify-write here if you're just setti=
ng all
> bits in the register? Wouldn't phy_write() be more appropriate? What abou=
t
> error handing?

Yes, you're right. phy_write() is more suitable. And will add error handlin=
g as well.
Will include them in v3 patch.

>=20
> > +
> > +		if (phydev->speed =3D=3D SPEED_1000)
> > +			mscr2_ctl =3D BMCR_SPEED1000;
> > +		else if (phydev->speed =3D=3D SPEED_100)
> > +			mscr2_ctl =3D BMCR_SPEED100;
> > +
> > +		phy_modify_paged(phydev, MII_MARVELL_MSCR_PAGE,
> > +				 MII_88E1510_MSCR_2, BMCR_SPEED1000 |
> > +				 BMCR_SPEED100, mscr2_ctl);
> > +

I believe this also need error handling.

> > +		/* Need soft reset to have speed configuration takes effect
> */
> > +		genphy_soft_reset(phydev);

Ditto.

> > +
> > +		/* FIXME: Based on trial and error test, it seem 1G need to
> have
> > +		 * delay between soft reset and loopback enablement.
> > +		 */
> > +		if (phydev->speed =3D=3D SPEED_1000)
> > +			msleep(1000);
> > +
> > +		return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
> > +				  BMCR_LOOPBACK);
> > +	} else {
> > +		phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, 0);
>=20
> Error handling?

Will add it in v3 patch.

-Athari-


>=20
> Thanks.
>=20
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
