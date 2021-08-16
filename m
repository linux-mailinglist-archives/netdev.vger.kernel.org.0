Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281F83ED968
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 17:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbhHPPCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 11:02:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:15082 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231320AbhHPPCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 11:02:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="203076312"
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="203076312"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 08:02:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="572521307"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga004.jf.intel.com with ESMTP; 16 Aug 2021 08:02:07 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 16 Aug 2021 08:02:04 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 16 Aug 2021 08:02:04 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 16 Aug 2021 08:02:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGfyZH60L5hzWtnfyR31CTWBLWSoYFZBs6Y8nbcnVmYQE0gktrYuAiSvrtVPPL/XXDBMZcRwZ+M7HS44pLSBZ4tDw5xCQBchiEtqrng0U6ppC3uumPHxTSJFgXwZTIoH+GQIyLMuvGxFiVxGiJxmPmn3KixzPg5sZe4DN4Nb0E0E2iYv2p8VywA4cflIrdxFb4Nqgmkv+Lfx3LHxyF8/ifSglONIaIvPgkFShhErhx652P75WYiZAT/HsIEtYZyrkQIoFgBtgTcjPwjCu1HN3mhB2LVLXOTRL7oTGWVzK20HNKX3ECotFhWK73oGdgqKnmjvT1uzbNRrCAp674FOZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GqAx+CbfuZBzn1yTiHPRU1WfS6wox93YRma0F75Q7Y=;
 b=T+PH8ALbX7Uq8S9jZQ178ySSstSfkfVUhJTGvL4PekBlVHe8qnjyYmvLva19AYkWCJEhr2AoAFOv9l2fjO3w3xHKej3HiNNibnMilusEn14aU3HLltyYepWksakakme8amUTYHjFjAGSgkrYvV+4nkYmP28/3czggzKZsMZjC3aidJgFn9Xx9qHYX7mRvZgfEKJ45/p5tauezHBEg6SzhPtaW2S/4LpsSwtAoGjzypmFLWs4+7lH8XIPHDtiu5d3hG9dr8sfM2aop8za0d/n5fbOuvMq6v8k/KbrWAj75QmG78FAOPlJ1WKHOP8hoVluJpjSWKOzCrLfIW34HwzduQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GqAx+CbfuZBzn1yTiHPRU1WfS6wox93YRma0F75Q7Y=;
 b=tt+URhBgKCDaxDw9e1mPGf6Yhb6EaIRNs6ybNLJcu3yZ/kxEukfDE1OHjBUQUZs4z2bqVbeb1k6VTomJJ8MEk10HPiTWykiUHQ6ls6Cn/d+8oOJUHsMJQeIfngsisujbdDOj/Q/daoJkrhLe24F/wKeZCUVhJFZAhbBZq8BKZpA=
Received: from PH0PR11MB4950.namprd11.prod.outlook.com (2603:10b6:510:33::20)
 by PH0PR11MB4807.namprd11.prod.outlook.com (2603:10b6:510:3a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Mon, 16 Aug
 2021 15:02:04 +0000
Received: from PH0PR11MB4950.namprd11.prod.outlook.com
 ([fe80::784e:e2d4:5303:3e0a]) by PH0PR11MB4950.namprd11.prod.outlook.com
 ([fe80::784e:e2d4:5303:3e0a%9]) with mapi id 15.20.4308.026; Mon, 16 Aug 2021
 15:02:04 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>
CC:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Thread-Topic: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Thread-Index: AQHXkCCVH1orffAF2Euk1FyXsMmop6tzQucAgAAKnYCAAB0pgIACCFZwgAAXTQCAABQhQIAAHfaAgAAGzYCAAAsMAIAAATnQgAAZtYCAAFGJUA==
Date:   Mon, 16 Aug 2021 15:02:03 +0000
Message-ID: <PH0PR11MB49507764E1924DAB8B588D59D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
References: <20210813084536.182381-1-yoong.siang.song@intel.com>
        <20210814172656.GA22278@shell.armlinux.org.uk>  <YRgFxzIB3v8wS4tF@lunn.ch>
        <20210814194916.GB22278@shell.armlinux.org.uk>
        <PH0PR11MB4950652B4D07C189508767F1D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
        <YRnmRp92j7Qpir7N@lunn.ch>
        <PH0PR11MB4950F854C789F610ECD88E6ED8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
        <20210816071419.GF22278@shell.armlinux.org.uk>
        <PH0PR11MB495065FCAFD90520684810F7D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
        <20210816081812.GH22278@shell.armlinux.org.uk>
        <PH0PR11MB49509E7A82947DCB6BB48203D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <20210816115435.664d921b@dellmb>
In-Reply-To: <20210816115435.664d921b@dellmb>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d9fc220-a2dd-44d9-1ad5-08d960c6cee2
x-ms-traffictypediagnostic: PH0PR11MB4807:
x-microsoft-antispam-prvs: <PH0PR11MB4807B22E3CB20A77FE3BF06AD8FD9@PH0PR11MB4807.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ziRIVykppmzlV+0ripaj5ooyRu4GjSvMBv6d7B7yibfJKdfmunF1JqF+MJkAqjNzhuN7w3xf5lO3VPbslAFUw8K5Xq7Zt3EQwvdULKTXLZj8JWc17tMFxsMXMiZSeH16Utakb2GoiOe1AjbWyMq4dn8m/1CueXODU4V75cuSYtnk48ZBopobJV/Vm79pemV23MYvHGkEwDZKt65o3Ut/wJBv6J45bTb/TJELLarUsacXMrPl4v2z7H3K2hmHqPXCceOU1gJWSGSc89ZTpr5gcyg4hu8blEu0R9S6PJnWNpYsG9tylObtIS+fAOn9ismFDhEytCBtLVuJ0hhx5nGxMeMeyWbMYOz0xjfpY7t4iQlzM4jPkx13PivtmU3R1BSQijoC/V0sYgGXBSGf9sGZ8mX6NQqMr05O+t/p8FjgXyERaSqhCfGEHvba9ehqcG/l06F6mhXez3xSSJIoS5m/5zOCMS13UHSZgz4bJe6tj/FINHSC37kSjmMtZ8XnOPIrDnUGLhX6ze02uA1hdF+8AZCkvsFqob07FHpDjmup6y7CrqBV6TmLg/UkxtLOO5u07dh1XrFQr1Rxus2PYxm8wVFsGa03BqtEFqMP9/BMYNWxXgjM6/h5jpvoC4xXO08Dlj6bILkNqNIpL4sRT8qvBj4RXa0soK43jHvj2jILbyVUU2VpQi3D2NwtycgxEN4h+TTOMzjkN2bxD0morQVG5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4950.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(366004)(136003)(38070700005)(71200400001)(5660300002)(4744005)(55236004)(8936002)(8676002)(76116006)(66476007)(316002)(2906002)(478600001)(66446008)(9686003)(26005)(186003)(55016002)(7696005)(4326008)(52536014)(122000001)(6506007)(86362001)(33656002)(6916009)(66946007)(54906003)(38100700002)(64756008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?xlBRZadEL73kw6isUXQjWuO4OpU95R5RduMPZb6qrN9LOqaocnbFZAARFI?=
 =?iso-8859-1?Q?Al5oio/XkKJF3h5sUc9SHOBcttA/rbqsbi+bFsHl4rgI4m5KhhEittIkG5?=
 =?iso-8859-1?Q?NMpv3CQuVpFLlwPVMoUoU8ZSbZlBvqkvJfrnAZilJnzyV8dXk5zhx1t04C?=
 =?iso-8859-1?Q?9d53C61dv2Om2xwdL1jxwDMsY7LuW9+w2zO0zh580RN6+8hxpKFU8tdlVj?=
 =?iso-8859-1?Q?155F57+27sAmK/NW+8jZefh6EMQXnCnUQYK0jwRSCtxvbSGTnpvzbKR5+B?=
 =?iso-8859-1?Q?rVJ4iFfL2SvusxBtnFBr8QLnqGsjl19j5v2QAryaRCw6DtI+0A49PBxitT?=
 =?iso-8859-1?Q?dOKKudkBfKf+qgEcPDfGybyOkYEyBmJfl3FdFNM8keMHbs/kTDOZAdpirn?=
 =?iso-8859-1?Q?qgsOn/YHe2LO+fH/nFICEn0DbBMm5f6GgUWNpj9I4jMGrE7WrmNapy+259?=
 =?iso-8859-1?Q?3QM/3rAHOyuEn1lGDjecjwXMq7QWpdsMXRJ1oYE/eCTuAULPU67a/6Tt6I?=
 =?iso-8859-1?Q?vVcMenIPafZ/TNzMA1KdZU0b8Ql02zSl37OqngYSIxb7rrThQODo/CT2xC?=
 =?iso-8859-1?Q?yVYzknwXaJ6r3WZ+sjXyxKDAH9SyhsuZLiGbue1sQuIvChyDv0x1erg02N?=
 =?iso-8859-1?Q?v9t3ndB5LfcxcJV4MRDK58Xg4VUbKYfxzIHM8NS2MnZgwmhD6Nr5VS+PuB?=
 =?iso-8859-1?Q?+XZXQV2Zh3kBj3VDAuIkFeSDzztHVm+xO0mOXJPjNL4zWALyerGSRf7hZP?=
 =?iso-8859-1?Q?5ITyN2J2Z1E+s2rfHzd+eOiCa+4S1Lc+t7CNbr+rZTunZlyZj+IbbRqI39?=
 =?iso-8859-1?Q?rMq7IIGEHP3+mAdbuZYE6TELxH3xy257ivf67ZVrtLc2FBbjH+nmckg77D?=
 =?iso-8859-1?Q?E6s9Ae4O39zjINb4BIy4je9MKHkWtB3pOcrmNRzgyo8yS2/zTOwDRzw0ln?=
 =?iso-8859-1?Q?p3yTfA+m9gUIfhL6K10S8XWuPBMhxsdH+w99Rl14bvVxezVnI/jB8QeUdD?=
 =?iso-8859-1?Q?DY1Kn8Kx4vHye9vRAT4QbkA4N9UOFwYCuIcHmzpZocVzPar4AHZ/XU6ugo?=
 =?iso-8859-1?Q?7BB4bBXdac27PMvEWrlJqXc7gVqH9VfqCdIRZVFPudpD4ZSisCab0Zckcc?=
 =?iso-8859-1?Q?Wq+JtxhiugEmfZGUi4JEp8s121KSYyYHB5kqkQI7dmFTovWRLfTk9Pd1sV?=
 =?iso-8859-1?Q?YzKZuaDQ0kXDkn7l82+m5Pck95yg6b9/TnCLxZSEADzX4vUbB7J2hw/o9d?=
 =?iso-8859-1?Q?MPO+oycCW/4mv7lk/p6MO9TqMhcC0GNJG98TFjrgleixlcx8uWd0fGGX8i?=
 =?iso-8859-1?Q?wW9r5bmkZ93bSbQqXq2fyqv7mwC5Bi5zB4LMo4NQTaBpD7aLhT5rQdAjgq?=
 =?iso-8859-1?Q?EeoR3fwMbs?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4950.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d9fc220-a2dd-44d9-1ad5-08d960c6cee2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 15:02:03.8947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yJbja3Zrl6dWJRExz/WVk4FqvxZ+7Zg7ez1hPUYJEZot4uMzJfHQ5QDxQCHnBXjaBpwLKWPSQvXX4Gnkf5yxUExouA4cnrt5niLAqHTTRTE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4807
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Yes, you are right. I missed the effect of get_wol.
> > Is it needed in future to implement link change interrupt in phy
> > driver? Cause I dint see much phy driver implement link change
> > interrupt.
>=20
> If there is a board that has interrupt pin wired correctly from the PHY a=
nd the
> interrupt controller is safe to use (i.e. it is not a PCA953x which canno=
t
> handle interrupt storms correctly), then I think the PHY driver should us=
e the
> interrupt, instead of polling.
>=20
> Marek

Any suggestion to avoid the conflict of "WoL on link change" mentioned by R=
ussell?
Is it make sense to create a new member called wolopts under struct phy_dev=
ice
to track the WoL status and return the correct status in get_wol callback?

Regards
Siang=20
