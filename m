Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749CB489592
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 10:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243238AbiAJJrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 04:47:55 -0500
Received: from mga06.intel.com ([134.134.136.31]:42737 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243218AbiAJJrv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 04:47:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641808071; x=1673344071;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ONZDw5gYw73mKdgskr68gF6wpQr+EK3UtbyW5HaEvl8=;
  b=lJAeD566ulTv3n8/cZ9TJczqrmyDyTnDI346Al32RLgI0VK90J5T6T4B
   NNYGcmOKveNiqQi9qKcdfmm0xp/QOi6qGr6Qv0eGRjxfwe2BjPF10kFce
   dAJf3gQ+8QLRILhV46N0mX0ClwWtefpfPR6VCRp5mTQjaqc3wh2qr96pz
   ftuBHmPOdGZPBNhDBR3w4UztgKLIwl1PhnL+QJDLwzsjGDic6HViG2uH2
   QVH3JtEAnb9Ik5b0P4FkwoiyWioGWiIHR9qSoDR8z+C7GvO9vMhhMYMWT
   mjafUs9Fik9f7/YYqR97uzKt6SXECPp7MqwxE6RU8KM1CmIJzzzLcyVQc
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="303933516"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="303933516"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 01:47:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="472020085"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga003.jf.intel.com with ESMTP; 10 Jan 2022 01:47:49 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 01:47:48 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 01:47:48 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 10 Jan 2022 01:47:48 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 10 Jan 2022 01:47:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZtZT7ll2xt7G7jI+7TS6tB7wvffbPqjV3YZDfZvqAwBgCMTnyGeT9LdGrCAD/AagrMtFQLVf1VA3G2aeArloLyBWiLxgPsCLK1DEuah+LlKWHm1Ca9dzyjBTyRUGm7cMaypNjNJp44V+p7JCl49qhDXD4NHvUq2vLybFpdlBXWW+KFOAYk/ETAcFZcHwfKoqvVUnw4EKXgmbIJocevV2yxnB8yIP8SX8v/DgUnHVyfv6zZ7ivWSExPcCp/GVt5h8oq8VO+VcHd05kCOHywsUDVFa23lItUSpIE737XnRetsNvgxAtJg1Z+YFYgykTcqX+GA0S3bglf5Ut56xbIfkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ONZDw5gYw73mKdgskr68gF6wpQr+EK3UtbyW5HaEvl8=;
 b=FU7skT8URRY1UrO0cITCvkhKqs29VwB6Lxy2I/BkawqoKuIpfY4SK6SOst+o42Z7KxHSSwnfBJkL8vBHBf3PGGYlhWjdCR0LB7SWug3RKTDAFTSIj68UOH2BNHsu7ow1hlQTady8vXUe1Yi2Wqo9JMcOT9fYm/8byE+ggrqgPM9nFgaAXLLd5BEPcJJvU9bsPIs9r/UxVsZnSe7KqUUaflJ4KSZbhMhEKF4X9ol3sjqKogUZDzP37Ki6rPQRHk6bHxfXP3OldNA1QOnFDJ6tF4X9RFJyoNVMkh79Af++kMbcZsWPI2eaT3J86YrymxBSfcGhxI5yQeaXOfLB17kh2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by MWHPR11MB1680.namprd11.prod.outlook.com (2603:10b6:301:d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Mon, 10 Jan
 2022 09:47:47 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::116:4172:f06e:e2b]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::116:4172:f06e:e2b%9]) with mapi id 15.20.4867.012; Mon, 10 Jan 2022
 09:47:47 +0000
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
Subject: RE: [PATCH net 0/1] net: phy: marvell: add Marvell specific PHY
 loopback
Thread-Topic: [PATCH net 0/1] net: phy: marvell: add Marvell specific PHY
 loopback
Thread-Index: AQHYBepll68QReUIcU6ohDS5xpc8kqxb/vyAgAACWGA=
Date:   Mon, 10 Jan 2022 09:47:46 +0000
Message-ID: <CO1PR11MB47717AA3A28FE34B32264048D5509@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220110062117.17540-1-mohammad.athari.ismail@intel.com>
 <Ydv94whrTNPiqX4p@shell.armlinux.org.uk>
In-Reply-To: <Ydv94whrTNPiqX4p@shell.armlinux.org.uk>
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
x-ms-office365-filtering-correlation-id: efa10c19-a91c-455c-5fe4-08d9d41e41fb
x-ms-traffictypediagnostic: MWHPR11MB1680:EE_
x-microsoft-antispam-prvs: <MWHPR11MB168039A01B0C7DF9795ABE41D5509@MWHPR11MB1680.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ca1p/f+/Fp3rsq3Ztnpks9KUrULN8ZdefIGAUE9pVC8b1q6bBeexXdP/n0EtSFRlwAfXuTh/H8s3VGGLynYUe5mipAgQmhpcVP+zozwFzZM88noj3wTn69eZ+CD3YU2VZ+DfsWcku0rwfoBS5VhOMcVnKZ0SV3GCoes347f8M9lOdMG/sfUhEeePF0ZTl/S2g62f3zfW6i7x1KTepF0WgL00JmaNmtvp2Ti+6f3rqt5Iny4TCOAdjPL1NAZ0k41phHt8otu8lbFgnZiSp7NAdGMCUWTFhGpKbvO9wfDWS52CmK8zi3XOkKQ5nAQafhjxWvRh9eha7T73cJq3tjxrsfBg5qu/s+MS6r95N0kQrjtdqXVHwrcQdluCgzle3j+fNaBwo3fUvAqLSdwRsjiSPuif18IYmmcZeRiCmgevG/cH/ScqxCy5+foGw+yRBUT08+fDLlOf7WCOeSt/lt/q4s09QNjHkgQ5oH2XEEQcofQA70UtR5NjiQ+MzXgdE4N1C/qaTZ3DFptR64Mikm0YqPPlevZnfM8Zx+FH3JuXIXJd+wkuSDORVdV1MNDkZY1mmvme0Xkk/MCfnit+rOzYxql5Jn2sPJ7WM6GCVErt00ptC60iN2/SGh/uTqw8o/Z1PYN12Zk5WW7fDfO78k5R1M2f/uwpAOFqyCgQWFgrqD8X+hRwkIUTImtHRiUSjeHTiHs72Q1/ADOvow9cBJYHOjIXWKImTSxvqk4QALJwYb9jsESv24EUa7fhkW6lLDAnFO4VYTiZV9EZreds10YGU9cAk3uYv4frIVUEKxq0A4g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(6506007)(8936002)(55236004)(7696005)(83380400001)(26005)(8676002)(966005)(54906003)(4326008)(38100700002)(122000001)(38070700005)(508600001)(9686003)(2906002)(5660300002)(55016003)(71200400001)(33656002)(82960400001)(76116006)(64756008)(66446008)(86362001)(66556008)(6916009)(66946007)(66476007)(316002)(52536014)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1bk2T5zpepMIuF9/p5b5huvkC1WM6aF9dnlV0uz7RRNXaLWqEfyXhuiOj0gz?=
 =?us-ascii?Q?dcs0wyrutbBOTCyb2n63QyYDJ7lJy5MeuCrTjOKpvnfhXQ48lfV7ECHyr0tm?=
 =?us-ascii?Q?ubh61+ocWEx33Yg1F4uQQ1Y5AsDhwJNBYVzAcPxqfvQxbLf7KXBL8Y5yPgAb?=
 =?us-ascii?Q?BGibks/yZDkICt99hckygCTYr+bZ4BbsZlq9eLzV3n24tkHz9siPR+6fRN0Z?=
 =?us-ascii?Q?IY8GM9vyLdmyfC4wxW1pM/iPLgmTX7z1r7SysDanAqXIBybkgebiPei1gfK0?=
 =?us-ascii?Q?VMkYYp5MAtelP4Q1chlugD+wWBCwM4SbbCk++vyvdjpXq118OaMuahdYK4X7?=
 =?us-ascii?Q?tvA2dQOXLcVsFJGw4bVRvXDM0wb1ghoVLV+EZIpaW3KeSr4859V6vyAOsBA6?=
 =?us-ascii?Q?rNwwcx0auHwRNoBWFkwI/iVZrW2iL25hc93ikjpq0fvQdjIR/IglhMW1rKK0?=
 =?us-ascii?Q?UPVPTyOXp7pezeiMCyUSmHgUHULsAx32ZI/ozyrSuV3fzbdB2aM4ZJE+xqlZ?=
 =?us-ascii?Q?RIqud24J90130m1Jkn7+vRfkh0h87zTTdvrbhmf2Y4+QQR3FNeM07l9VbydP?=
 =?us-ascii?Q?HfxlLtU6vZdZCSTXvwHk/7mb9QA9+UHK1mfN1Mx4T7Heo9JFZM/1XSL2w0l+?=
 =?us-ascii?Q?xmbheNXduBmOSby9folZsXH/eVqjFNwOVBabJCmlWSq8uQl/HUaWKj8EybXk?=
 =?us-ascii?Q?uJ2Yu/7xoEif/MxKR0WBqNXh8eDJlQwjj/CrpZBVoPwXiflOxKeFTZ6ItmfV?=
 =?us-ascii?Q?6kTYUHt4MfjYpg+zyFPdx0Wn3tq96pUQYf+zV/b8CIXAFiqpiJV90l8mwy0D?=
 =?us-ascii?Q?bjbdOv+SLC5ZJ28KQw/6OLn2t0oReHg8oSxNTaKDrxjgaOcn2QVMNWPLwjxk?=
 =?us-ascii?Q?VVLlbKp6k7xpDiRgDdSyX5lxb0G2b8eErivS0tSdg+ZQC/QgzNosGZvGrHFT?=
 =?us-ascii?Q?hnoQWkAFqoGDZn2cG3PokC5vkzRCvCo4I7b3+sUh6/K7Gd7Xmu5HvNFk1Hz3?=
 =?us-ascii?Q?TBfl8XhP3HZBmBAyYODJYC1Uila7lbINO3JeM8oIG+Q1vfhzL9IivesgUKXj?=
 =?us-ascii?Q?O1oPvaif3EFBK87GT4s1CLsYc8Yttg8hvoOlhqKG8vP7kdgu/AMARgy9MWHU?=
 =?us-ascii?Q?5w09q3uT+gevSz2cD61MiYsWPu61031xzzvebTXhmYUr4aPUvyQiJBbnAxYB?=
 =?us-ascii?Q?eHzyk/zRF+7gzFkWV8WmkN7BY0WOru2tgIqjoV35nKQtS4YOqftBzA5vFP2x?=
 =?us-ascii?Q?7v/Ah/j59K0rNnYSslEKEtIrjPFyj1FPHiznJrmnXdU7cJY8ySKBwqNk+glA?=
 =?us-ascii?Q?97soNob/8qvzOHvwNFdzHCVeJ7o3EIHwKem5zt7M/vU0pP78eFUVyIXnvI4V?=
 =?us-ascii?Q?Gki250yVc5ZDOSCKKAqngeNaz3OY35HdHolAUhZZae8T307Y7IXmbnpeNOB0?=
 =?us-ascii?Q?MegwnqJsO3I3IP/qL33dNdLHYRqR0/VBozmqoFCkGcFMhDPPkxtCbF+pTAr+?=
 =?us-ascii?Q?XmZ17aItrrHSaRhfLwp8oPiINQ3iRtog5s058HnxMIRZi7Q3H9rjNqBoAWVV?=
 =?us-ascii?Q?Goqj4K1VzgSa0s1o9G9or9qZ/UhhUKXZoyWyGyagN43uhO5WKl+aVoM1yp/B?=
 =?us-ascii?Q?tsV0VSTzOERSWO/yLpQAc7/GseBVgP9AA9vyLDlHQ14p+H7XuBkMNCyYka8f?=
 =?us-ascii?Q?FGL0euSq/DLFLShPJxofhIhtYLYMpQ6+m40rZ0KFh1tSUixEaHa0ztaFCPCb?=
 =?us-ascii?Q?Fsj7HJUVDQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efa10c19-a91c-455c-5fe4-08d9d41e41fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 09:47:46.9332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EUi7v4kWBPEA3DDa4fRGe+M5+ezktij/KxsqXaf6vbqeP+HslGiRtiVRlsOGvxZooosZEdGbyZWHCL/4jXIq/0GWOlkGpnLCb5kDjwsV6hTBHK13F0fQg0enCejwrMZ7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1680
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: Monday, January 10, 2022 5:36 PM
> To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> Cc: Andrew Lunn <andrew@lunn.ch>; David S . Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Oleksij
> Rempel <linux@rempel-privat.de>; Heiner Kallweit
> <hkallweit1@gmail.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH net 0/1] net: phy: marvell: add Marvell specific PHY
> loopback
>=20
> On Mon, Jan 10, 2022 at 02:21:16PM +0800, Mohammad Athari Bin Ismail
> wrote:
> > This patch to implement Marvell PHY specific loopback callback function=
.
> > Verified working on Marvell 88E1510 at 1Gbps speed only. For 100Mbps
> > and 10Mbps, found that the PHY loopback not able to function properly.
> > Possible due to limitation in Marvell 88E1510 PHY.
>=20
> This is valuable information that should be in the commit message for the
> patch.

Sure. I will add this information in commit message for next version patch.

-Athari-

>=20
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
