Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863AD3BF7E7
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 12:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhGHKF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 06:05:29 -0400
Received: from mga04.intel.com ([192.55.52.120]:61203 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231324AbhGHKF2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 06:05:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="207654909"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="207654909"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 03:02:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="410855562"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 08 Jul 2021 03:02:46 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 8 Jul 2021 03:02:46 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 8 Jul 2021 03:02:46 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 8 Jul 2021 03:02:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/DbyNN3oSqCHpEOQY+CoZmHIUBj1BeUR8kosAA0nsMTMjoQjhN5qsIXRe2EQibBfwf6hjy9HnowtY6NHqCmZpv7Q4SpnvnVBM+NKY9u9ifAnNgYx+oDtMD+5SIc4Yexr7BfmZvVBReZt//Oy6490IG04awObqG4rbwOd2gD4W7zVNqggCgCdXkxeXUv2jDfTWah7/St4wl6H3wtZksKw/9c34+XQEZ2P4YltMHhQLw1+tTRZPzFWLhlxWuU0i4+MIrqydcjAH/4DdTig6vklfDWdgCrJ14FEWuKQ0t4rNrXsB1oYuQNcfO29b6b6kTqbQUaurnBpUHhr43KAm6xoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLIENqxLiUJT/FqnP3bC67JyEm8C9/ZPXb9rL+Ax/FA=;
 b=ea6l4Xvsg5k2gcRA8Sl+SwKPOZgEluYOE6BZU4t/K2+L8B+Hv3UKS6CxRleEZvC71SDs4GLlD07UlI4BA8rC5vOGm3F8kqaTVOmssLDo3CHDiilphsG2rM7nf6Zqi9TYfl8HmNgpCgShfG7kO1dsQGIHW8t4r7yRns2IMEyiRCXfCYh5ILrqrvnns544T9/urDF/Eaz+iCYDm2H79WyC/UnSfzRTK394kbhxCEZ9hHHiZk6wtD4eVcjxIMVNLQ0XoRarEdNSX0X5LKuvdaUuuy8OxsRxLDxrDYOzjOxQoRS7AESqTlwwE/GZkkfyUUelZrqDw76Q8PzhJNVkzBGkaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLIENqxLiUJT/FqnP3bC67JyEm8C9/ZPXb9rL+Ax/FA=;
 b=At50V4neUpE7K40lEqBFBi9KBQUD3KXultLEDJbpLt2GBxaYflH5s2jXzx3xusJlTMBi/Dz2LxYt9W2k3jXL5jQicTS74eMPsm2ta0Lbp/tjK8Kx3xFizh+2agvc6vjaYnBnxZ2XrUdXEVwLN5jfpERaDnMz70jkv5SuaH5JKLc=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by MWHPR11MB1856.namprd11.prod.outlook.com (2603:10b6:300:10f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Thu, 8 Jul
 2021 10:02:42 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::cd48:e076:4def:2290]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::cd48:e076:4def:2290%5]) with mapi id 15.20.4308.021; Thu, 8 Jul 2021
 10:02:42 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL option
 still enabled
Thread-Topic: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL
 option still enabled
Thread-Index: AQHXc5JVSuHoO6yBxk2FsVeJf8muoas4SJuAgACEr2A=
Date:   Thu, 8 Jul 2021 10:02:42 +0000
Message-ID: <CO1PR11MB4771D3BB3D8722BF3454AD4AD5199@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20210708004253.6863-1-mohammad.athari.ismail@intel.com>
 <YOZTmfvVTj9eo+to@lunn.ch>
In-Reply-To: <YOZTmfvVTj9eo+to@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f06638a-8259-4f17-288a-08d941f786ee
x-ms-traffictypediagnostic: MWHPR11MB1856:
x-microsoft-antispam-prvs: <MWHPR11MB1856DB7EF32C3FCE4DF428E4D5199@MWHPR11MB1856.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TUVuM1HMWKNtIt4Fh7Qum34eIqBNmaEcaY5JaUMWWtxK7aAMhH/BI7fmzMmd4vdPDPF28GDJM0H5Pam4gdGvwy/52Ysq+RBHkFI1QRsDheaZGGrxu2iANh9TD/nAoPtCn3jXLSfHeCzcGR5DeCYJaFOYrXH66vOrFHWjNyprKv6NOC5hvzf0wXK/xYUDklWa6f22N5LdElB632xCY9kT7RfSPn4AOMyvrsidCsXmiSxjfxQzpRMKbCYKMO+gvaalrSbxNfnSbmMm0UiwMDyAyJjZyXsy59K3Mt+aZEWwnBxXE+Y8S05v7WfhB0+K5WNZt1b05qiSzfYLc2FLG/isHfy8NSwp+ntMkziVn54vCsabo3kQaOqfW0fHuf+pu/U4CCZ1VRq0v3npj+xhDiO+XFxnCfBqAL53UALIffoV88l/NHu1eP1zaJyVrPtXf54hdbMzoDYlxIfXao3s79ZsERQPKY+XYQz7+DqbBdXtAEAsuKNdthK3uPAihoToMAOHTBTFmQtFMCk3E23v7vhg0VbKkC/Ow/DZT67Gmk/SObQQutKDAC5mV5SznHPBsBGWV44YNrPAz+evrFu94GzCcSmg1xIiImJsGvUaeVK0EyuDSpelyrAQeKfkzPVQ98sng0vNx6RIVygV+SmXZ4HEQQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(396003)(346002)(7696005)(38100700002)(5660300002)(122000001)(8936002)(33656002)(66946007)(55016002)(52536014)(186003)(26005)(8676002)(66476007)(76116006)(9686003)(6506007)(53546011)(64756008)(6916009)(2906002)(66446008)(55236004)(316002)(71200400001)(54906003)(86362001)(83380400001)(66556008)(4326008)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?YEW+Gvwc94VYYcqxjLpzWTWLsuO1MCq1VrYKibQ9d76yr9fgUgOILfdVo9?=
 =?iso-8859-1?Q?aEjqn/9mw8q19k28HhH8OuIkL+0c5NnuezNUJADCEIC4aJbka/ncgJS6Oo?=
 =?iso-8859-1?Q?XuQ8yAw7XiiiLaL6WyPWiSnKUZ2T626ni2F03fUHAWGyKeEALeQy6elxbO?=
 =?iso-8859-1?Q?EuS8l2HSfhbmdOnhLi3T6GgmNFW1hDeVUZeJR9FBnVt50ej0seYkOc32KF?=
 =?iso-8859-1?Q?0PIBM0BIWVhGQd5BDHvV/2OB04WpzW4Ua1aETz/f3vW6BvdF3nOYl1zRhR?=
 =?iso-8859-1?Q?wHHE4UJMECFCgXU4KWpFlagF0BmoZL71sCy/2oFvZlWCVJDa0Pzp6Leh20?=
 =?iso-8859-1?Q?tXTJvNpgBJ22ZZ7NzmwbYUUdcrVSQSiveT/EraKOmXSkm7kNWqlfBMmqm1?=
 =?iso-8859-1?Q?rbnqAcw/Kde75xEXnAJ0z1c1zUNBJgnZQ+UXM7m/kJ0MwGOCbsCSZvRFvC?=
 =?iso-8859-1?Q?UEsIcpxi2g2iJcJwkj/G77XOSnV0on0c3e/MqzZZIu1NkKeGs44AIzo4DJ?=
 =?iso-8859-1?Q?KjMyBRmZem7ACHcYudA11XRDuNKftk6/Z74zjyxATLn4Mg6Mm+azauPx/X?=
 =?iso-8859-1?Q?AcpY7GhPvTv+IY5aPEOWR+/x4VkwhNawRMkuTXRyRifv2YW7BVFkBypEro?=
 =?iso-8859-1?Q?zdZRg+7vYTOjG8ni7LvgmOWgjwvo1rXiC2VCwPVNaIlRSjHhhQ1et4Rzyf?=
 =?iso-8859-1?Q?y7uD+/Fz84bYaVjreymjRn+MPqsZjSO2DrHM+xdreoQPOY05KZjThuyFkc?=
 =?iso-8859-1?Q?FKD22UpZ+zAUpJk9mlrBWHfmP9g0GBWrSB53PJ95dgqkAG0ygli3tHZ9Th?=
 =?iso-8859-1?Q?fqlLQELXI3vjwTAv/STgZiugg5j+6r9NcenheudZ/XpujbHdk0ncclShsa?=
 =?iso-8859-1?Q?Bzimr1yVIKywTPbNIMpE4HcnDGNeyF0vt0qLo3zMrvhe2JEGrT6rgwMaFW?=
 =?iso-8859-1?Q?ywVw4GxEz9SKl9QNBl0avm9YGdYsLSycjvQkNj3lHgZ00AOXARxqYkNood?=
 =?iso-8859-1?Q?yDVkBiW6pSeojSIkmQkjp70geFXsMJWcAHqRd+pY/MOFsswIrm4KHEvSVW?=
 =?iso-8859-1?Q?awoGf7cW2U8kDtUsJ/eATy2DRztIL6cgszh6i8r2DKUGhqb5dzZLT/TOTz?=
 =?iso-8859-1?Q?AHoOW8Y4oYxcVV7c59LtuuisghaZdSOnL14gkoIkpVOOzyfkAXVLEo+paf?=
 =?iso-8859-1?Q?YjElvrA7yyp4lVJjlHavfGNz7iWbi00kxxmjO1pfaKEvkAlDw1W49ZoS4F?=
 =?iso-8859-1?Q?nEkukb1nQKK9xNxTIzP+2a8jusKvmf1cQdpYutjQlYrhCJt7yDDzDwIk/Q?=
 =?iso-8859-1?Q?9c/qOCSzYj6LUbjKTasiVjwBXNkMLbazovH59RlFDbpuYQ6mmNj9esE5yk?=
 =?iso-8859-1?Q?fX/Rai07Jd?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f06638a-8259-4f17-288a-08d941f786ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2021 10:02:42.4575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SHSDJeua4X+YbYumGbgwhoa2grpeBPLrWV9bdQPemQGsByUNpbJ4DGQlObEBHwW/m0Tetmwn1SBFA8BaKkbon/eAJuN/vFFfjwKTDJ4fJthDBfl6WZiT9eonvOt+h9Cn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1856
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Thursday, July 8, 2021 9:24 AM
> To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>; David S . Miller
> <davem@davemloft.net>; Russell King <linux@armlinux.org.uk>; Jakub Kicins=
ki
> <kuba@kernel.org>; Florian Fainelli <f.fainelli@gmail.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL
> option still enabled
>=20
> On Thu, Jul 08, 2021 at 08:42:53AM +0800, mohammad.athari.ismail@intel.co=
m
> wrote:
> > From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> >
> > When the PHY wakes up from suspend through WOL event, there is a need
> > to reconfigure the WOL if the WOL option still enabled. The main
> > operation is to clear the WOL event status. So that, subsequent WOL
> > event can be triggered properly.
> >
> > This fix is needed especially for the PHY that operates in PHY_POLL
> > mode where there is no handler (such as interrupt handler) available
> > to clear the WOL event status.
>=20
> I still think this architecture is wrong.
>=20
> The interrupt pin is wired to the PMIC. Can the PMIC be modelled as an in=
terrupt
> controller? That would allow the interrupt to be handled as normal, and w=
ould
> mean you don't need polling, and you don't need this hack.

Hi Andrew,

In our platform, the PHY interrupt pin is not connected to Host CPU. So, th=
e CPU couldn`t service the PHY interrupt.=A0 The PHY interrupt pin is conne=
cted to a power management controller (PMC) as a HW wake up signal. The PMC=
 itself couldn't act as interrupt controller to service the PHY interrupt.

During WOL event, the WOL signal is sent to PMC through the PHY interrupt p=
in to wake up the PMC. Then, the PMC will wake up the Host CPU and the whol=
e system.

Therefore, for our platform, PHY_POLL mode is chosen in PHY driver.

-Athari-

>=20
> 	Andrew
