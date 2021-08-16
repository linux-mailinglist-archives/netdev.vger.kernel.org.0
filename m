Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113823ED0AF
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 10:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbhHPI5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 04:57:12 -0400
Received: from mga12.intel.com ([192.55.52.136]:47613 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234999AbhHPI5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 04:57:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="195407506"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="195407506"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 01:56:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="504822924"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 16 Aug 2021 01:56:38 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 16 Aug 2021 01:56:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 16 Aug 2021 01:56:38 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 16 Aug 2021 01:56:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhImXyIUzaiJ4zOk6T68qGUbpclU+6ZwWYHKOzMy9G2oelQYHcY5yRD7Jy8c2LW1ra/kiqUBxY1OgU8MMnWs5sMAncFxBFo3VFpQsG8l/24/n/vFq4Ksp+lkWFR130CBlcIoOKkaAWXnpcQPahG/zUm/55fitzywZ4yvzIf5gsQdr6qiVRMtlDg4Zux1cld7nzMMprE3XH+G7UV5Jxd1oqcbdpZYXR9jdHmhQL5oac6zUY2CylJlK1TP10DJYxnkYpGSGlBSMp34G9l4KPRdXX/1XIRTFUXo+g+37ClVvCg71wvPVDRv0TtKkybkLJMSy6cPTpS7ZW1Fs1W56tOC0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jD8gOuAOWSz3bFL4JJJY4WirQAgCYJAmzSOFlzdgXI4=;
 b=USZGWT4NdI6Er6dMzNjtjhrTD95pYkoKN4vxBkgkJczARYO8gCwM214skrr5wKjSOj+Wzwi+uwnP38a5gSlAnLDRicq067M4yDcUz8Ll2rxXwrXZWRS6P2EmcqMblnxI92Jwo30WJ/9ygncU1BMYSguZdp9h40v5kiyPRqwotQAEy2vJH+OrOUyArKlwNhaGFqjU7KHuTvN77Ab4hFRHLX9Ms7M4+3A9dXlFZh/w0CtQnJ/Nk7IGY4mZqsXYaSUW2D6ZPb9Xhmnb1o5iQ2N8pdoXmzPXYF0YYNiZjbOpWho/FtndDvKifZkabu7Wk/LTcPMS3AsqUcz5XkMB7+xD/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jD8gOuAOWSz3bFL4JJJY4WirQAgCYJAmzSOFlzdgXI4=;
 b=b6eIZZ5D3yg8nusTHjoj7LE8HmwJbMGu22N7Xx5eNV1eG14dEj8Zulj7jvklh68L4IGF+3rYMSLd3OTrKEshrgMTmLf2dlStyOgZImxCgntHGv9AQdsKA+sn837gnq95RdvQaCVuFtuhzgPZE3xxxeWWeWpcNobN7f2NIuk7ZDw=
Received: from PH0PR11MB4950.namprd11.prod.outlook.com (2603:10b6:510:33::20)
 by PH0PR11MB5160.namprd11.prod.outlook.com (2603:10b6:510:3e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Mon, 16 Aug
 2021 08:56:36 +0000
Received: from PH0PR11MB4950.namprd11.prod.outlook.com
 ([fe80::784e:e2d4:5303:3e0a]) by PH0PR11MB4950.namprd11.prod.outlook.com
 ([fe80::784e:e2d4:5303:3e0a%9]) with mapi id 15.20.4308.026; Mon, 16 Aug 2021
 08:56:36 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Thread-Topic: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Thread-Index: AQHXkCCVH1orffAF2Euk1FyXsMmop6tzQucAgAAKnYCAAB0pgIACCFZwgAAXTQCAABQhQIAAHfaAgAAGzYCAAAsMAIAAATnQ
Date:   Mon, 16 Aug 2021 08:56:36 +0000
Message-ID: <PH0PR11MB49509E7A82947DCB6BB48203D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
References: <20210813084536.182381-1-yoong.siang.song@intel.com>
 <20210814172656.GA22278@shell.armlinux.org.uk> <YRgFxzIB3v8wS4tF@lunn.ch>
 <20210814194916.GB22278@shell.armlinux.org.uk>
 <PH0PR11MB4950652B4D07C189508767F1D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <YRnmRp92j7Qpir7N@lunn.ch>
 <PH0PR11MB4950F854C789F610ECD88E6ED8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <20210816071419.GF22278@shell.armlinux.org.uk>
 <PH0PR11MB495065FCAFD90520684810F7D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <20210816081812.GH22278@shell.armlinux.org.uk>
In-Reply-To: <20210816081812.GH22278@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aca36a9d-d977-4f8b-b495-08d96093c125
x-ms-traffictypediagnostic: PH0PR11MB5160:
x-microsoft-antispam-prvs: <PH0PR11MB51603ECFBCCA1055CEA9E511D8FD9@PH0PR11MB5160.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wTVg5P6pGbBSzeoNHLI6Xjk/sHI+Q3MhT9dWomDzcaC/CGBuPHAIDdGKhEdiUJVlfdID7238qdORT7zQmgnBrkFvSqlR8nPoVEbzhrYV+QPYY24MRurylEGU2IcU4e19z6ecWEoHGSfYKriggfwczQ6My+jF9DmzX/dsQVgXTB4i5ARUJySNMYgO3tVibyyjchLqH7mO5M/TNy4FuKqezcUafefuKcmikSlHPLPkuYkj9oI67ZkTaHBUQalbCUs2uouA6QzbWBMnOeywveUn+xeKhySoJ5N0JdMDWtEiS9TtSrfvouNAUoP23gnsDXkgCyVIZeaZl52VwG1txe13/Dok2VFslsU0VczmC/ljAEg8YcGKEp1GCfaYB3mc1B3qTQ4C0GPRlVF5eGDFx89oTkZBVIZaDXz1bP77lY1pEfmbqPF9adoGRtkuUGcYpHB4k6IB+8wH8ms1nxlerlGoHpbW60aVIUGKviowdIz1S+OQMMX6JFrEbyVOP0WQFMG8vSarvAoDj1p1C2rz/c9wfGxKQvl6CQUJM25GLsYUxtMnLPPPjQtTDuFRTWvqCwab6G2kPGMpA0pcxxELHaDiCCLXnztyRu2TUY+ADkpAXv534hrggocfnicNRkHeodm6NCNnEeH3zCQhi6BzYzyzqMlgj1gQyb5j+fnXLHzxdwNeUu9t06Fr5HSBj05jykBvHkhc5YmzBWJcHV3ujuzPH8HD3nHkpoGUtl51IKtIAGU4nTKpRcAJZ/GspUfCnsDTspKngV7fekaurNu67X95PblFmb6sZgIjKnaUCR9GYyc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4950.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(376002)(136003)(346002)(71200400001)(9686003)(6916009)(54906003)(4326008)(8676002)(55016002)(52536014)(478600001)(316002)(966005)(55236004)(6506007)(38070700005)(7696005)(2906002)(66476007)(86362001)(83380400001)(26005)(66556008)(66446008)(38100700002)(33656002)(64756008)(186003)(76116006)(66946007)(122000001)(5660300002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?tELL2iK1XkyKNffk7/vJhZW+inqSIHXU91nPHye896nXELN9YFE/RCuRn2?=
 =?iso-8859-1?Q?IRWTKh1hCM68b9bZ0SwgNVL8dK+YgLJML1k3pdwjN7iiZM61ctgnrtQUOd?=
 =?iso-8859-1?Q?5LYbCmXWejx5Go0KwpZFqd7Pl2rzq5cVBp0GZa0GpPrlw1yQ8IWqbeGAIn?=
 =?iso-8859-1?Q?WjAfC8yEoeUvA4bmWGx2XYXEshLc7Me37qWjgnln89AMTLH4lWgSqZ357q?=
 =?iso-8859-1?Q?ITwsUS422HkVi+qvm22KyI/5RLjGG/x3IAekWA3ppDrJ1LSg6O8Wi4X8vA?=
 =?iso-8859-1?Q?05OkAjZJK0JtwhC7N4EgenzWqNk+g9EoHGILcgK0c8oHe+Wccmqx+D8kj1?=
 =?iso-8859-1?Q?cQ4tbWSMMQKg2HskXyjiA0Ep/UIEBx59zOVoquxmqt4B6c5VTCIT2VGYhA?=
 =?iso-8859-1?Q?6cEgF9b6LAI0fvLDpibRS5MY9N4WME6+rNnt1nLwrowENN93JwM0fl080Q?=
 =?iso-8859-1?Q?tLgF42fogo5m2GV4edZ58lXssZHABOhyg5e6KAgfRWaStJCja/0jTvU+hS?=
 =?iso-8859-1?Q?DCEVfHBIpOpqyy2j5tp1aqd75Upe1Tbeei1IkNeFqxUSIOHsoHJzfNU3V0?=
 =?iso-8859-1?Q?w8v4SsxyvzjOF8dXi90ArCOW54rOJZgMJw6YcgB0u9dewtb1i0XgmCeMMu?=
 =?iso-8859-1?Q?Y/+Fmxi7m6UNHEf7Wt6lSYYz8ue2TnrksPsIL3QIxj9zwoSlFIU6M0S191?=
 =?iso-8859-1?Q?9FO3HptLm5c4rtsrIowkpA1dtGPREK4s55LeWB5yfSTTeObm8SFw9QFYyR?=
 =?iso-8859-1?Q?97h+pssqicDAcNqtMDbEPTpXzUwMAihH4H7bbBvpLdyaRLntlNiNioDib+?=
 =?iso-8859-1?Q?R6tXqbyCZWbNLDoNlKi1QYzW7/luPJ8IJDYNSeyIhFZMk0LNmqtCBvr7Vo?=
 =?iso-8859-1?Q?6UO2gEithjCZZpcec12PZBUFXVy9cLcG9KX6rk3srNtTEczZIU4tpUQ2De?=
 =?iso-8859-1?Q?zPSY8sUh23G+rM6GEEYDjEXCs4rUULeBV0lcfLBiEyqygQIcFaebsKMZEj?=
 =?iso-8859-1?Q?RCPiL5gA8cRjOmVwMg5hHFPKXCsuyNlWMMmQshM0lFfvLyG28V/ybdDUzM?=
 =?iso-8859-1?Q?fu9FD+hCwsVMgpbvGF++Iie7DH6BqwE3KIefws50t7RC11KfLTaOHkjCZX?=
 =?iso-8859-1?Q?cNiYD3ryPPZW05p90Zwp9W50ybHtoHpMXpnj0HQUY5LrI3O3eHdUEo6VHk?=
 =?iso-8859-1?Q?uboRF8h5PFLBubCQTTVOUzMMITv7+TLEaGRyICDMSgMB2HXoiXp53mld2K?=
 =?iso-8859-1?Q?wFvmXG1Mx+1jJCHi2j6JQWLN2mIy+a3+CkhoMY9pB1AbpI2EGUwcQgJHSm?=
 =?iso-8859-1?Q?0v4A6DmAjoWvTH72el+M7o7E+Mk1CgTS/h78wjzW9IFfuQ3voie6ckDwby?=
 =?iso-8859-1?Q?exKNsoyvrG?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4950.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aca36a9d-d977-4f8b-b495-08d96093c125
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 08:56:36.5334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XWLRR0e/9F8Jxfep4lbiS+Ag5rJnwAM15cAHZaAGxqKtFqGqcnPh10/6iyQYeMv8bL4nfMRVRh5dUilBP9oGvGjhIRwiSxzRTGPCJdOmcjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5160
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Aug 16, 2021 at 08:03:59AM +0000, Song, Yoong Siang wrote:
> > Thanks for your explanation. I understand your concern better now.
> >
> > In the case of WoL hasn't been enabled through a set_wol call, the PHY
> > will be suspended, so we no need worry the link change interrupt will
> > create an undesired WoL event.
> >
> > In the case of set_wol is called to disable WAKE_PHY event, we can
> > keep the link change interrupt enable, so that it won't affect the
> > interrupt support.
>=20
> I think you're missing the point. In your get_wol method for this
> PHY:
>=20
> +       ret =3D phy_read_mmd(phydev, MDIO_MMD_PCS,
> MV_PCS_INTR_ENABLE);
> +       if (ret < 0)
> +               return;
> +
> +       if (ret & MV_PCS_INTR_ENABLE_LSC)
> +               wol->wolopts |=3D WAKE_PHY;
>=20
> If the link change interrupt is enabled because we want to use interrupt
> support, the above code has the effect of reporting to userspace that WoL=
 is
> enabled, even when nothing has requested WoL to be enabled.
>=20
> This also has the effect of preventing the PHY being suspended (see
> phy_suspend()) and in effect means that WoL is enabled, even though
> set_wol() was not called.
>=20
Yes, you are right. I missed the effect of get_wol.
Is it needed in future to implement link change interrupt in phy driver?
Cause I dint see much phy driver implement link change interrupt.
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
