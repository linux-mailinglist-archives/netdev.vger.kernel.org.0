Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6781C3ECE1C
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 07:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhHPFkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 01:40:52 -0400
Received: from mga17.intel.com ([192.55.52.151]:31917 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhHPFkv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 01:40:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="196067005"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="196067005"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2021 22:40:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="440975370"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga002.jf.intel.com with ESMTP; 15 Aug 2021 22:40:19 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Sun, 15 Aug 2021 22:40:19 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Sun, 15 Aug 2021 22:40:19 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Sun, 15 Aug 2021 22:40:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYoigG0aOxeR09DuQRwc3JwsYBrqgdYtKOeVnzCb8MXEC/U9zoGnW29RcR9exEHdo3hJHmhfm7Edu3mOuusSuBB7zPDR80rcOWTR3psBrYc2sE85SU8iF/vDy8lIt6zYs3hE0pkUw1dRecuzXOL1SNjgzXWq8OvK+AdeZ7cC4FGNrwqSuFE7MIpTwhon6PT4mBfq8BNGh1NiDOmCoKk9EWk5gN4F1LC1EiJqyG9aNCsYlpYEHdk7QZLhZKQZ+T9XqFQ1XHbgK+sK6ozU7DN1qj0UCdFi0sMWRviaDtXerbY42dAvQzdrw/8sFby1fKdOY8/DWfZ/ZExMbLj1QISlYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MLu5uMuIFsinH5i4v250MkmTl0+RXpnbtglsglLBwh4=;
 b=VJyalyiO3dt0M7Dv7j3v0quEeEwPM+cpRcT02aIXiIEqb6KCkIcGkCoPVaI+me9S3fWd5idE+cH41BcCLAKPhqY35QOmIe7lR4e9yEB8P5oVXFjqWkAp3np/1ZvRjSDb41qzJ3CWpDe6tS7ptNF3FsH9GU/QDe6cOdnHtX6Jwo2AIwG30Xf/QGtd/C/FHXC2CLoT0FI4j3KFurnfIfa+6aUsKt6+T34Or4y2F0m1HYcjsX4TYJKy7+2CjhwOy5GkhsWuaHasBwOVeAKcTE4b0hExq2v7pZc6XwrAtnWvAvAj3HH1t1vHCS2wl2X6pTZ8cwN6BGHH4r9yi8sI1qnZMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MLu5uMuIFsinH5i4v250MkmTl0+RXpnbtglsglLBwh4=;
 b=sKh4hw0dlZl3HGYG8L9E5Jvk8jGgEUkNoY+qsVIryKwfn3EWKWJhA1NTNYwROx1SOYFxY6LoDDBcIkrYBqjrQDpISvFLCc+SXR4iwNEcTc/IPwBByiRb3m0c0xqMV0IehTGSMXOCcAyiYLKC+apf6LezOe2sb/eCOgEQ1FufZGY=
Received: from PH0PR11MB4950.namprd11.prod.outlook.com (2603:10b6:510:33::20)
 by PH0PR11MB4901.namprd11.prod.outlook.com (2603:10b6:510:3a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Mon, 16 Aug
 2021 05:40:18 +0000
Received: from PH0PR11MB4950.namprd11.prod.outlook.com
 ([fe80::784e:e2d4:5303:3e0a]) by PH0PR11MB4950.namprd11.prod.outlook.com
 ([fe80::784e:e2d4:5303:3e0a%9]) with mapi id 15.20.4308.026; Mon, 16 Aug 2021
 05:40:18 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Russell King <linux@armlinux.org.uk>,
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
Thread-Index: AQHXkCCVH1orffAF2Euk1FyXsMmop6tzQucAgAAKnYCAAB0pgIACCFZwgAAXTQCAABQhQA==
Date:   Mon, 16 Aug 2021 05:40:18 +0000
Message-ID: <PH0PR11MB4950F854C789F610ECD88E6ED8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
References: <20210813084536.182381-1-yoong.siang.song@intel.com>
 <20210814172656.GA22278@shell.armlinux.org.uk> <YRgFxzIB3v8wS4tF@lunn.ch>
 <20210814194916.GB22278@shell.armlinux.org.uk>
 <PH0PR11MB4950652B4D07C189508767F1D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <YRnmRp92j7Qpir7N@lunn.ch>
In-Reply-To: <YRnmRp92j7Qpir7N@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1014d9af-bfa5-4840-8c59-08d96078549c
x-ms-traffictypediagnostic: PH0PR11MB4901:
x-microsoft-antispam-prvs: <PH0PR11MB49015FB1DA36BDFCB4A76C20D8FD9@PH0PR11MB4901.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /HVm6+Ya3q62Z0LaysmH+0yW2OB3Llc1EsrJ7MCRkN387y0cIgPy03QX+vRyhsD5ioxpHdN0g5RKd+gzrREJ17hABzoKBJhpaxIuTKfMlfoVUMfF9EKEeozQacwHnSXoVJBKR/e7iRW1/839MVdHOS7auMkXwgRb4djA3sEruAN5YlZpGpF4qf7RycDuMbP7RmrCQkVIQtgjuTDik6NtPh6sQHuzql6wDLAFqN0EPV8brmNFl71HE7E0f8M78RUPPLoxxaGbTTCD0lcK4ZijM2QYqiA/6w3tFPP1wkxT2epwiJe3F0PJ+/glp/LmaD5vxMm7nKzR7iTauvV0kpiZlplxojXnqSZCB+OxET6u617DCz7HG5lBhu0+km62KYgCb0pKWGXwwttq7GT2acJgUz0riTzFA5mI2qpOEB8DktlH9U/ekNr2ECi/uAnesjAU9oA/Ed3TVVQpTlkrcYUJOD+w6dlSkzeuFS9OMBb2YTesFNmxNq50x6+9tXcxGtuJzkdGz7jIWAaoGo02fHKKTYLX5siM4FfXuueUOMPu/UltyaQfrTsRdWyXRBJJ8y0pe1nBj/kN+Alept1rk7/YxVASpJIYRyIgysdQ/d3jb0F7xYpK1gE/OOxwErhkpO6hlOc8Hs6ad9YSnVlO/ZpHZi7FDLDlnanWKJPhoVC/iuk4XnoaFc0Mz1Iv+5VoRgAJVfJ6w6/2+fOkQSrf/XutrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4950.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(8936002)(7696005)(66946007)(2906002)(55236004)(52536014)(54906003)(86362001)(55016002)(8676002)(76116006)(38070700005)(6506007)(38100700002)(478600001)(122000001)(64756008)(66556008)(9686003)(33656002)(66476007)(186003)(66446008)(26005)(4326008)(5660300002)(6916009)(316002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?NrfmDUW2L7dHDtMfji9YGge5lLCliVSa8R0cpvc/tN/Yf184z6KASn5bVc?=
 =?iso-8859-1?Q?06ilFcgzjscoIhwUIH3FyN9szdOx7cGSRwrdk/4khzN9sDfeTcbZLuiPzh?=
 =?iso-8859-1?Q?FQRf67o1EUUMEEKgUl7hcHAQtq254SphyjIQsmUYB+lnxEdnaasZgxzu8V?=
 =?iso-8859-1?Q?08XmqGxV05KrUMAszvrps+DEzJbCpKnjcOLh7oAAdvIMGz8bcQn5xCBm72?=
 =?iso-8859-1?Q?9rMNhIahnZWRdFobspkAtRMHNO8eXFpFR8aKCHgzNjbwA//vX/frCmWAXk?=
 =?iso-8859-1?Q?HmUhdxrjkM+WjCocOJHwVixyn3+LLFjgGMDkRJLtCpQ97lwmPVAyntWXoF?=
 =?iso-8859-1?Q?iOQAKaSbRarWYsP2KPpbWnlBFrh9EGIEgGMPe5qG3q/69a/hTXHSRlKd8i?=
 =?iso-8859-1?Q?n2eV2+eXR1Q3FX/QNO5F7GMzLEpgvtyhjXglUFn2taqJ7nczN6bP3myGrr?=
 =?iso-8859-1?Q?6uHPXMDCzt2LyuEO7kePEYW2ZgbGJBm3T3RfLM1CWRXrwhSDbBsxsCFR3r?=
 =?iso-8859-1?Q?DpUNbD9rHvJGUxpHLrAyaOA0Djt7h+BV+MQ00MQSefdmIQkupoJItFYRTO?=
 =?iso-8859-1?Q?gT5ILTESLjtEq4OUbkHyUClXGSG5QSbDLVf6d8Y5x90klRlIDH0DwoEDOB?=
 =?iso-8859-1?Q?TjDxwGtsDAJ3vMbBGXv9x9fey3jf675EyDTm25a0uc8I8BKlynipfzwRWs?=
 =?iso-8859-1?Q?iujuoPUvImACdGjJdPUB6G8kQtJKt92+T0Z8f7ILpwNrqBMw6er77WCSKD?=
 =?iso-8859-1?Q?RiUUGJHEwtkBJNjYAcW0ZUCNbGbbC+jOWB0XaNnMDx0RWfxTXJ4hyStnJv?=
 =?iso-8859-1?Q?4ZyyL8E8dFd5WYo40YeBdO/aApY6NBuqrfymmkFdEEs8ZImI5s8t4oqMtg?=
 =?iso-8859-1?Q?MdBrG4caCGwteMabU9Ks0b0iS0j4tBg9b+fqJZ2gHQEzD50Qn0Oe/sGbjy?=
 =?iso-8859-1?Q?myxVsR5XvtpEsuEN0Xtmhrmpy8MY/a7pyQpPJMyACiM7l493znrrbsCzdw?=
 =?iso-8859-1?Q?e8bEOXrHFlNHhenNCzlBBqikFjKbq++e+2DQ9S0+eRWtNdC/P9lVn4+WDV?=
 =?iso-8859-1?Q?eU5ovA3B3DtlDOHipJDy4/vUlL1fDxt3Um1O7NoB+6FbDCBBH/n5wh7tTz?=
 =?iso-8859-1?Q?jRSMpXb2AWDlkrEGmGk/JNCrqQrOe4wLHTjZqVbd0zbgD0Jpq4J8/tNIFx?=
 =?iso-8859-1?Q?3oSrQ6QFxQM/GHEio5VC0/Z95hF7OUaIFbXIrCsYQOs1G66lQc8g6XDZ0M?=
 =?iso-8859-1?Q?LMNuz+raN9wBElj/JX6pyWZJuM1v7bEZsszIIk4t2awqucrytpk3oLiP10?=
 =?iso-8859-1?Q?tfmfENg3l1ZlbEgtaxkCJZyw28mZ11WTVj5475xbdpmX3CcDJF7zwCfwli?=
 =?iso-8859-1?Q?qz8CvWnj6l?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4950.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1014d9af-bfa5-4840-8c59-08d96078549c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 05:40:18.0229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r/a3F1M5PFmYzxg7A3bQPB2ywK7Zs7eD/OdjIxsf81EQCeji8og+m9kguJSZVJ5OnCIQaNK4nlqciHHFsANMtngTMT7RipRWo3geRVQ9nvU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4901
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Aug 16, 2021 at 03:52:06AM +0000, Song, Yoong Siang wrote:
> > > > Agreed. If the interrupt register is being used, i think we need
> > > > this patchset to add proper interrupt support. Can you recommend a
> > > > board they can buy off the shelf with the interrupt wired up? Or
> > > > maybe Intel can find a hardware engineer to add a patch wire to
> > > > link the interrupt output to a SoC pin that can do interrupts.
> > >
> > > The only board I'm aware of with the 88x3310 interrupt wired is the
> > > Macchiatobin double-shot. :)
> > >
> > > I forget why I didn't implement interrupt support though - I
> > > probably need to revisit that. Sure enough, looking at the code I
> > > was tinkering with, adding interrupt support would certainly conflict=
 with
> this patch.
> >
> > Hi Russell,
> >
> > For EHL board, both WoL interrupt and link change interrupt are the sam=
e
> pin.
> > Based on your knowledge, is this common across other platforms?
>=20
> Other PHYs? Yes. WoL is just another interrupt, and any interrupt can wak=
e
> the system, so longer as the interrupt controller can actually wake the
> system.
>=20
> > Can we take set wol function as one of the ways to control the
> > interrupts?
>=20
> WOl does not control the interrupt, it is an interrupt source. And you ne=
ed to
> service it as an interrupt. So long as your PMC is also an interrupt cont=
roller,
> it should all work.
>=20
> 	  Andrew

Sorry, I should not use the word "control". Actually what I am trying to sa=
id was
"can we take set_wol() as one of the ways to enable/disable link change int=
errupt?".
PMC is not an interrupt controller. I guess the confusion here is due to I =
am
using polling mode. Let me ask the question differently.

What is the conflict that will happen when interrupt support is added?=20
I can help to add config_intr() and handle_interrupt() callback support
If they will help to solve the conflict.

Regards
Siang
