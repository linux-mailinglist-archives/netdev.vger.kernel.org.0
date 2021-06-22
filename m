Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D743AFBB3
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 06:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhFVEYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 00:24:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:20795 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229452AbhFVEYF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 00:24:05 -0400
IronPort-SDR: 0DyqS2hXizgUqzp2IEZsvPhAoiZXtSOOpipOV02q9xZuN7OJcSUvsI8btOKR9BgWBJEUJQZfAm
 ZSI6rKIZTzyA==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="203968651"
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="203968651"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 21:21:49 -0700
IronPort-SDR: 5L1aFHAQYnZDpuY2H+6sQsWryowCu6s1dwDqb0J9Q221QgLpcwbwWAatV7M9oowsnwJPKS4hqR
 B/85UIYNn42Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="473641613"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga004.fm.intel.com with ESMTP; 21 Jun 2021 21:21:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 21 Jun 2021 21:21:49 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 21 Jun 2021 21:21:49 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 21 Jun 2021 21:21:49 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Mon, 21 Jun 2021 21:21:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e40fkEpZ0AiMML35wNmd3wl+b7BwWIHk3WqVLG4zv3psfEt/WDwQugDEQ6etxYOLYq5GBXO/SDi7o3FoIMS6y9C+kJLVlR/sAm0imS+mawsW4h1JeJjKli7n0hAm3W+PagWL/mPJWiuRXI+zXy1hozyWhOc3dTIS+qCyKm0TCxJrdn40fL7HcsXSlk81Gi5JYuyfXwOXBrJEIb+XMxYfil9g0Py7eKzsK7QrLy/g2BoNW0LORrM1XVonDuKlRr5l5hcyUMBPKrve5ffvt6KWXZcsyeQU0M1CfqOiAjv6SRFSZbgaBbPZRi3mYyXCgbgB91meRv0jPqC2fuTAC3/a1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ce/nLAa2sDsVamaJBf+p71GjMC5hKTHlWb9OjtYBHEE=;
 b=NN776564ht4Jv8xNgGbq4lsnxI7ver4Uusz+RlA4ESih2RElYKe0tKh/keAjDc0TG1VHXmsEh6e4ZPNEGQ6fvJ3TzFTcFFy8f9ayc5dwyBRWm/dWRFQtUdzgf4WQhfD3BgdO7xmgTaN/8HC5VccH2FCwyCHMHgbmFjaNa+xRwuaKRXu5lsyAL3vt+c8GOr+kmpn/rUqQpEVd0Jg3j1EOWMTpDBYrBJwMz236PQCcxlqDpJ2g+gr+VwItGvpd3FK8txQNWkG/ZlEKyyqtZvSnrLICKbdKRII6cCYlziWfnCbrZLSJCjBngHjhBjuUcf59tksPZSR7fBT32Rlp+yG4hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ce/nLAa2sDsVamaJBf+p71GjMC5hKTHlWb9OjtYBHEE=;
 b=muILZxd77ySAnsZobVUAEtGW8I5olBxnQNcNgvgF85Z3a9Wy3xQtxA61VpvPMXAlwUUInTnVKvFV4/P1gAW82Y7YUu/z0IKmQ8a63mVkgUOVSAQejc7nqVn9DVLjVFT5bRAgJ9JnqMorusFGh+uIKfgZOxzjJnRrY7+ubcW50iE=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by MWHPR1101MB2240.namprd11.prod.outlook.com (2603:10b6:301:52::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Tue, 22 Jun
 2021 04:21:47 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::44f:69d:f997:336b]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::44f:69d:f997:336b%8]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 04:21:47 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "hmehrtens@maxlinear.com" <hmehrtens@maxlinear.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tmohren@maxlinear.com" <tmohren@maxlinear.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "lxu@maxlinear.com" <lxu@maxlinear.com>
Subject: Re: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Index: AddnHT0S/UjkHrW6R2mJRf1bIOcoyA==
Date:   Tue, 22 Jun 2021 04:21:47 +0000
Message-ID: <CO1PR11MB477189838CFCDB952D4B064BD5099@CO1PR11MB4771.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e391314-f6bd-4818-899d-08d935354055
x-ms-traffictypediagnostic: MWHPR1101MB2240:
x-microsoft-antispam-prvs: <MWHPR1101MB22406DD9A7D7813075308CCAD5099@MWHPR1101MB2240.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: llZ+NxwGI7INdqmzMY/l9b04DPXML/j5L/rKwhNUKyUCyuoEIQBy8sx43SbNgfzjRd6I4qD4NwQM67EWTZKaHWvHIXrTTH1J+pfCW011mrfSbHSrIyCfD2McI3J7HrWK5cOwt49HXYfcTgyY13TiCSUqbUVxG4Aavi93culGFuViL7bB/oHYWm85oaHdihiavqZ1kkSAfd0/8JzSEMbCkCdUeSKx43APoW606IU1hNw9xk5935FQCxPzHIJMOkfVaBQdVbeq0usFbj1Tb6moSDFW/jyoLNJM1BY+JdCS4USnDaHSFxz7FIImdQcHDwW+MVPK5VRQSEcfgSmopwLuDryhIuy0HxhWeKOv7GzS7SYL9FpF75GWNahM0eteruuh0iMH8pW8Q5b8ebAuNUf0aNNNYsapBg9O6YWQ/VgK4WXpaEFBTcfviBbJf71ImLWnmvicLyyyWA2Ovu0enW7U8SUn9lOPyoV1zfCkvXcx2cCzKcyua+liwrfygWprS2T4aBcs29ePAtw3vuUDmR3sPUoRJlf6ZQxtNdwxnJ0HtCHTQkiXsXZJmGab0Fs2y4j2ztN02+39kvngd7EkNZ7jmzzyw3JcAbjiU8IGJACh15SSpBU762X7pdOS3bJQR2dEX1SQTV5KSSA2g9gO0h+KDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(346002)(39860400002)(38100700002)(86362001)(122000001)(83380400001)(53546011)(2906002)(33656002)(6506007)(921005)(110136005)(7696005)(66446008)(66556008)(66946007)(76116006)(64756008)(7416002)(186003)(8936002)(9686003)(55016002)(478600001)(5660300002)(8676002)(316002)(66476007)(52536014)(26005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wpkt9afkGDdTNY19NgNHWM0Zw3GoNfg3+1q3pN28wv72nwqCSjsjkBwDb4oF?=
 =?us-ascii?Q?2oH7GvyDb2catjubCYlh/7uzhFVRPhfB/3C7haWX9MrYyOb/LzwxbmqN5+W0?=
 =?us-ascii?Q?UfaZ0nDWexgExW/hcRmChuPwtwp8rKrhd43VQ6H3ZJErgskrX9LjXYQSZ9O4?=
 =?us-ascii?Q?e5dBxnDmGtgg3DHfGaf0vbPqdNn5Pf0XwcD0+VFOolxASYl2gqv+LtyX/BkZ?=
 =?us-ascii?Q?frcNoxu27czbKiQQAtb8c3DDjefyqZkqgb8AR8tsfnlHdpLAuom4fYCIoYI2?=
 =?us-ascii?Q?BZx/g78tB96IJMCZYQrYuue5K+ge7HUed4tA1NAUBvawNp8kO4weuyhx5SPk?=
 =?us-ascii?Q?pCzDM2lKdk5Y842KuzEUD+5mGWuxbb7Rx1s1531UaXTYc7w1f94dmtdxWH7H?=
 =?us-ascii?Q?k56DEOGy6s1bNu+uxQtcxLrHpD5gVt5xSHGZx/QfKep+nkpPwy4miyG67DK9?=
 =?us-ascii?Q?yzYOiW8cJr+7Mn/aQ1AW/9+KTpRSAubxf/c9aS/YRYCAnmYarIir5e1dIMqC?=
 =?us-ascii?Q?QSN7e4f+foY8J843g1/QMhNVoGQl8lVrkTJ85GA9Oi1oJQU0NbJV+js1TxzF?=
 =?us-ascii?Q?pu6MOoLn8vOUV3kM4+O3yJfLINFxUVwX16JOh/Urc4mJW6ILmPTjlI5Z1DoT?=
 =?us-ascii?Q?y3oCP/yBU7sNPUbyHd3BJsA3VndZ6FmOwTM8KxAXYqWNbM7A3hQYMesdLqmF?=
 =?us-ascii?Q?VZbsOFJ5cTmeFLbJaW+Wup4S+lv4EFBHeOoBYr+VhVZjdtGFo5vRsNvIKFns?=
 =?us-ascii?Q?rPaLX5SO/OI/PtExoxRTDnRuOy1lGrGRYLv+jU84YLL2MMvGpm0FHCWcpEhD?=
 =?us-ascii?Q?H8PIRY6+TM21zoH1ewgG5PU/7FSHLoWyalUe39+R9goDazcDsDR8TMgj26Lv?=
 =?us-ascii?Q?k9cnnI4efwhvhxhFHAESpPQR97YuJssBN2GOG/oWGVSjmWQzxRu6zIzTyXja?=
 =?us-ascii?Q?kAvCfDMJw47iCdMDUNcnFtCK+wfiibt/JDoYZSqyLHaK3Idy+ZsyapK836Vc?=
 =?us-ascii?Q?Oxycy8TljkeU/1q5aeEX09+N7O1STWnk4WHvksJbNxOknYjUOW1d3QcSJcdd?=
 =?us-ascii?Q?5zx8Q0LpSwAPm4VkgnnGjbfFldYfn+AbnD/y4O65f1HcySxYk0SwWVkSX305?=
 =?us-ascii?Q?EDmNNTi2Yvy7AsWpl++LAE/kCbnthNJtRAOHg61wGP1BHNGDzD6NgXY4tdxR?=
 =?us-ascii?Q?NJVqz1aSNRPR31Bbn86BU71h7byoK/TttqGzVWPy5rMCflsZAkzyxibaKCjX?=
 =?us-ascii?Q?UC9EOSpcYW4r7WDToSGpxiyin0VwwMk7hQsXAbyG6CGpmyAkdjquCO7Myvgs?=
 =?us-ascii?Q?bGh0P995Dkbb+A7xqSBVM4e6?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e391314-f6bd-4818-899d-08d935354055
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2021 04:21:47.7685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ygr8ZGiCmEkngQihNGh3EKys9sd7SZM1vwDJuRCDUh5YDcYlkjs7bxUYex3FzgM+4owAz3zF9MuGN/5Rfn7XBtXELYWzew5tIyr2PLbmNfFaps2YlngNBhiok6bg1fMo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2240
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> Sent: Tuesday, June 22, 2021 12:15 PM
> To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> Subject:
>=20
> > Net-next:
> >
> > int genphy_loopback(struct phy_device *phydev, bool enable) {
> >      if (enable) {
> >          u16 val, ctl =3D BMCR_LOOPBACK;
> >          int ret;
> >
> >          if (phydev->speed =3D=3D SPEED_1000)
> >              ctl |=3D BMCR_SPEED1000;
> >          else if (phydev->speed =3D=3D SPEED_100)
> >              ctl |=3D BMCR_SPEED100;
> >
> >          if (phydev->duplex =3D=3D DUPLEX_FULL)
> >              ctl |=3D BMCR_FULLDPLX;
> >
> >          phy_modify(phydev, MII_BMCR, ~0, ctl);
> >
> >          ret =3D phy_read_poll_timeout(phydev, MII_BMSR, val,
> >                          val & BMSR_LSTATUS,
> >                      5000, 500000, true);
> >          if (ret)
> >              return ret;
> >      } else {
> >          phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, 0);
> >
> >          phy_config_aneg(phydev);
> >      }
> >
> >      return 0;
> > }
> >
> > v5.12.11:
> >
> > int genphy_loopback(struct phy_device *phydev, bool enable) {
> >      return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
> >                enable ? BMCR_LOOPBACK : 0); }
> >
> >
> > Not sure whether anyone else reported similar issue.
>=20
> The commit message says:
>=20
>     net: phy: genphy_loopback: add link speed configuration
>=20
>     In case of loopback, in most cases we need to disable autoneg support
>     and force some speed configuration. Otherwise, depending on currently
>     active auto negotiated link speed, the loopback may or may not work.
>=20
> > Should I use phy_modify to set the LOOPBACK bit only in my driver
> > implementation as force speed with loopback enable does not work in
> > our device?
>=20
> So you appear to have the exact opposite problem, you need to use auto-
> neg, with yourself, in order to have link. So there are two
> solutions:
>=20
> 1) As you say, implement it in your driver
>=20
> 2) Add a second generic implementation, which enables autoneg, if it is n=
ot
> enabled, sets the loopback bit, and waits for the link to come up.
>=20
> Does your PHY driver error out when asked to do a forced mode? It probabl=
y
> should, if your silicon does not support that part of C22.
>=20
> 	 Andrew

Hi Andrew,

We also observe same issue on Marvell88E1510 PHY (C22 supported PHY) as wel=
l. It works with v5.12.11's genphy_loopback() but not net-next's.

Regards,
Athari

