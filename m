Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41513BE04E
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 02:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhGGAjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 20:39:31 -0400
Received: from mga07.intel.com ([134.134.136.100]:32919 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhGGAjb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 20:39:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10037"; a="273063365"
X-IronPort-AV: E=Sophos;i="5.83,330,1616482800"; 
   d="scan'208";a="273063365"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2021 17:36:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,330,1616482800"; 
   d="scan'208";a="457261667"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 06 Jul 2021 17:36:32 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 6 Jul 2021 17:36:32 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 6 Jul 2021 17:36:31 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 6 Jul 2021 17:36:31 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 6 Jul 2021 17:36:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKD5ARQu6Xqu0D31tCAG9tAI+YQr9NY5BWdM8SPwo0sqhi4K7rq/tFJjnGnJryHNRuonoRRdzq4E4kN8QZXkyHz5HuI72cx9jmP42gxOH2gAvLzZI1oUwHZ7XcRyrkzJ/8oqSJmzGqs8w499y4Z2HJ8ARUCAF/xg5vOZIdEW2A3EIOBwKdA0rQyOxp16yii3xgnrshLoYxJBz9FNvceK6P2RqVNU9dYONaYde7DuF0WoXK36hqiITjhrXDrxPhf5g5bb/tF9qY1/PPbobOqycDjQYhzhs0O+CKA6/TNRhJ4wMLJ0pTa3m+LtjYxc1r39k3arE7ibocqmKqJygPzm8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQkQx2NU1DHt90yUXoMUU4PheFeNdjgGGs/SN38mz5o=;
 b=Q+IF76J2U9BKQNIwfCa8CwzlP4FXvjgOyqrpmigXfCI2eMYY9xcYNqgZY4ntQ/w4NWWLNxwG6uVNdMfEcMPDSrFvLVqbJTRLap/EGmhf+HtRIx2BhuJMaPM1orc6zYmIgjW0o4MhGFIGfGAxDR4Zv3UrFgW1GunclAkg6zYoPAeupnq/zZYOe8/s8/lQoT3PnTauw1eBE7qOKpcJfTuLpdAGfzB+ExFVpMVQu9/Hjaeo1VpeRp1vVVTHP8bvy/EJK3SKyqM7ueCq6dGPoWex/bK6996gk7Da+gVSCdI+R2AGShKotsbQBWCVKyqtqWDKuC9pj/zut60F3f6vBvaG+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQkQx2NU1DHt90yUXoMUU4PheFeNdjgGGs/SN38mz5o=;
 b=nLGjfywll2cvVXYGsDRk4oKnseNYwYbrK3xh2AZK1UoGkw/sqxGtKSVR0dBmKzQUQqYqrA2LoPF17VTwxJ8pEwnswvRadgPvOBfBWgihGv1aRMSPyVmh69Nzdbq1g84W4csvsuIqWcIxI/YJohvAhokTmyftu/win9BuFs+dLuU=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by MWHPR1101MB2143.namprd11.prod.outlook.com (2603:10b6:301:4f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23; Wed, 7 Jul
 2021 00:36:30 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::cd48:e076:4def:2290]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::cd48:e076:4def:2290%5]) with mapi id 15.20.4287.033; Wed, 7 Jul 2021
 00:36:30 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Ling, Pei Lee" <pei.lee.ling@intel.com>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>
Subject: RE: [PATCH net] net: phy: skip disabling interrupt when WOL is
 enabled in shutdown
Thread-Topic: [PATCH net] net: phy: skip disabling interrupt when WOL is
 enabled in shutdown
Thread-Index: AQHXckWstMlfSA9QTkGVkYpePnnwK6s17SOAgAC7sPA=
Date:   Wed, 7 Jul 2021 00:36:30 +0000
Message-ID: <CO1PR11MB4771EF640CBB88E9D96693FFD51A9@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20210706090209.1897027-1-pei.lee.ling@intel.com>
 <YORXMSmvqwYg7QA9@lunn.ch>
In-Reply-To: <YORXMSmvqwYg7QA9@lunn.ch>
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
x-ms-office365-filtering-correlation-id: 341dbfb9-5f68-4f42-51b5-08d940df439c
x-ms-traffictypediagnostic: MWHPR1101MB2143:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2143BC269F6D2EBE047DD4E4D51A9@MWHPR1101MB2143.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AzUV4dXkSkXsU8TCGKa/JXSPwf8ZOX7j3NZKqjWaF8YAfkKdZ+7fR3/kGY8TImxDAO7KfWlshbZmQGw2NcixaluY/ESSvZFdJv6JkgVlnfCteP9zHhZvOp4dfLyDYrGu7ej0sUbX03iQWbJOQBGa3m2ywSkqhqf8c2kzhagf1FKyEEW+RRfLj147lhYsqrO/Ap5XVhLtU1K8SGoBdZcixDMdSwDX9szVf2uFnVpIj6nfV5j/fxRX0/y9LyDD7o+HiXVuwakpQ7jho+zoVTa0uhjCvXDNaqdOcP0cKxCWpgpCWMbxurPo7iH4JUUnesxXNzYuqUu29p39KgjkQl3qJ68wvgGXUNBB0l58Jf3Wlj6GF6Nt+BcrL91h6cXd27XrDcQsg3lJygy2BbWC5f5M7x8v+2BxHQFTcUPP3QuLhEh33cxJATJ7YM5DW4dYoicsKL+IjeXiscBLsU1R/ZNplBFL4G50uek8Y8woWUiGGg54bpxVxbJHIaQxLwACa8VBS0z5ySXHWeFJoM6pRXinjpN2ugsz6h0kvTu7b6AeFZFYgyRopd+bbMa8gBb9qxFRziNBJPJ3i0xB9SLz7vseyfphcMFWhOd165alGUiVxMRTrbvRvduxQ/gllIIdhQ2kTi+wUr2bCRqcA/tp6c1PQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(396003)(376002)(39860400002)(8676002)(4326008)(6636002)(316002)(7696005)(71200400001)(86362001)(8936002)(83380400001)(110136005)(54906003)(66946007)(122000001)(26005)(9686003)(66556008)(55236004)(66476007)(76116006)(53546011)(186003)(478600001)(52536014)(5660300002)(64756008)(33656002)(66446008)(6506007)(55016002)(2906002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+awXbbZBQDO5wp0e1HNxNYBbL+GcNukL2tAO9OND0AGzvbtpABZjuc+VUMOo?=
 =?us-ascii?Q?4ZDqLOgY4LxrcWPjAwMyoKaim0WuvNZeXTf7RlGPiBu9qmANlkHWOkeH1HBd?=
 =?us-ascii?Q?u0gAc4Ej+z16gNirPnR79biOT2roWwa+ixFx7CtnpWrVp/lxaWDgWd+r+Uvs?=
 =?us-ascii?Q?9H4SYjCSEQKJF+C3/K9SbdPhMcM4vUPsD6FKnPrfc3QZST4rW6pnjdv65Q9T?=
 =?us-ascii?Q?eBTWuwRHqhzsyaOd+seQI0JbYyBqXTj5cihszM51jMFpkyHgZEdXkz1PHHUE?=
 =?us-ascii?Q?nDZBPcmgsAE9xnbyF8LXcVu5U1vHSQBN6Z6Q0qQDzEYDL4F4uH2qS0c5rEDN?=
 =?us-ascii?Q?FIbXF6i6OnhhhrOBI4Bjy1wH/+Z5T9JJyO7UK8DD+4GepRhw36IYmjs1nER2?=
 =?us-ascii?Q?jMP/2Tx61lAzWRwYecTRA/yePtgbTmNWdYRw+h6LQCwcgBEA/6Y/+F1tv1O7?=
 =?us-ascii?Q?WeRKyzIzRNgz9GpeHvZcYVLBqOYmEiejaLZDxev7m98aWuOgrzTvDKY/aI7g?=
 =?us-ascii?Q?xVOZFJMnA7OtLYS9CdwW1mpPqiNje1pM2u5ltHpvHtt9CtthYZsWaAhAAKTw?=
 =?us-ascii?Q?ttp43Mz108xtjVVMwKwX0omkkAKR7pVriZgDuYtY9Pv4hSi2hXrP72oYd+TL?=
 =?us-ascii?Q?qHn+M7Ev6J/QLxJN5bNB0ZpQM8HgSrNEu12O85ZG4XdQLdxCOTqOKEo7zhRV?=
 =?us-ascii?Q?fWQgOP2RHpPuWf15jInvmcDIFvHo6d+3Z2empNWSQWnhOiv44O1CZNnDgvd7?=
 =?us-ascii?Q?MbjzOKdk9swl47HJPLylXn1s3aynlYpnUlG7itJR2ZYFiagSNzpPH4HhlqqK?=
 =?us-ascii?Q?TCJpFo04opOx3owTtuWlglT16/8gNkCfu72G0yan1clFDNyJypzVc6/kJKHs?=
 =?us-ascii?Q?jGvg8A0xySREq18LcII+KxPD75tDL5loI30YuHu0HPwP61/aaQZwhDRmfHmR?=
 =?us-ascii?Q?EdKE8BX3bl7RXRPPRLdW9l5noYtnHQJyNB9m/eCB1dRBmeIPYTjiC+f8LYeF?=
 =?us-ascii?Q?JjiNXSsrDcRLCWrqfYlJNt1cQausyQzliV8TkN64feJ7g3s8c5+ra0ku00qN?=
 =?us-ascii?Q?NDBttndPNWqYKOQrF4H/NAGWflt9aC9fDpkxi7FNy2pgRnZw8UGcJdolJUN+?=
 =?us-ascii?Q?m5sFQkBicvgUDpG9yLNsDAI2FhXj2lV6kz+eJPS0CoOLmXgf6hOi6DHMzYj4?=
 =?us-ascii?Q?LfTzC0+61eYPcBsYh0rmKBC+PssMq7TPtw5+/OlydfoPz1rP7JD1Ak+jSUG3?=
 =?us-ascii?Q?frMivI8IY+UaxOf8dt2/91pqOGNJQB5r0lIvKWvVoC1BaUnTettlvlm7dksq?=
 =?us-ascii?Q?Z5u6brG+nMxwqr3/OMWR+iTy?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 341dbfb9-5f68-4f42-51b5-08d940df439c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2021 00:36:30.4982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 57LUs96ODrYJ7FbOaTHjCyl6cywveU/rI6F03qXn5fqTyowase+uBx0bthtHfAuup4byBo3jHW933E/dAlb4T/UgpOAqzckXnd7Lw+clULgpn6OR3IVB5q3ypu4ibN+1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2143
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, July 6, 2021 9:14 PM
> To: Ling, Pei Lee <pei.lee.ling@intel.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>; Russell King
> <linux@armlinux.org.uk>; davem@davemloft.net; Jakub Kicinski
> <kuba@kernel.org>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Voon, Weifeng
> <weifeng.voon@intel.com>; vee.khee.wong@linux.intel.com; Wong, Vee Khee
> <vee.khee.wong@intel.com>; Ismail, Mohammad Athari
> <mohammad.athari.ismail@intel.com>
> Subject: Re: [PATCH net] net: phy: skip disabling interrupt when WOL is e=
nabled
> in shutdown
>=20
> On Tue, Jul 06, 2021 at 05:02:09PM +0800, Ling Pei Lee wrote:
> > From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> >
> > PHY WOL requires WOL interrupt event to trigger the WOL signal in
> > order to wake up the system. Hence, the PHY driver should not disable
> > the interrupt during shutdown if PHY WOL is enabled.
>=20
> If the device is being used to wake the system up, why is it being shutdo=
wn?
>=20

Hi Andrew,

When the platform goes to S5 state (ex: shutdown -h now), regardless PHY WO=
L is enabled or not, phy_shutdown() is called. So, for the platform that su=
pport WOL from S5, we need to make sure the PHY still can trigger WOL event=
. Disabling the interrupt through phy_disable_interrupts() in phy_shutdown(=
) will disable WOL interrupt as well and cause the PHY WOL not able to trig=
ger.

-Athari-

> 	Andrew
