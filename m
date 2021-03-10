Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042E23348E2
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 21:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhCJU0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 15:26:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:2296 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhCJU0E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 15:26:04 -0500
IronPort-SDR: wSKRFNwOXTSKygmgyA/zD6Qo8i0s7/VtasopNQwmA2NaLUgaNyxfAaTOmFhPez6MBYU2CTV+1l
 LKuseBAJ1IWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="175662257"
X-IronPort-AV: E=Sophos;i="5.81,238,1610438400"; 
   d="scan'208";a="175662257"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 12:26:04 -0800
IronPort-SDR: ohOuDcvMevdKw/fXbD00UJBJ6Vd5ofHW+nOesMtQBPeRhqnR8phhn2eoaL+5BtCftJlDkYgaql
 dw5gTxS7ca9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,238,1610438400"; 
   d="scan'208";a="409232908"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 10 Mar 2021 12:26:04 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 10 Mar 2021 12:26:04 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 10 Mar 2021 12:26:03 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 10 Mar 2021 12:26:03 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.54) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 10 Mar 2021 12:26:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FoN5qx7u3ntwLyHqp/2asRzD0fYBPHMuiLtG16rIqRR10tm4XHHRBSMAbeYEWAnqOQRIuhvI7carOq6U4EwGFd6e3AENlAv7phwHo/sPpBvcJoF7QTLN23DdgofYN5WGR3JAOsVmhXclJShKJF4wHiCJxsZ4nnyUIQnLtLqmEUaI4ayrI+FafiUGSqUXrI+4hI1w9aBPzXDRH9hngHY6bbIjmgM33muUDwRCZjTPoL7D/VZa05jQ/n4RHJJsaDPccilmDKZ0R89UbZT+g0zIw74VUtJg/rOMrHg4OwgY9+F11XrMRRbj08XMx7pLs2AKn8JC5M/u7I0yG4Pf+bIjlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DxFJI8XqFgJieuustgmbxZmJo1pAIjjxYi8+WyAGzo=;
 b=BGTRRyEHcjyCzYzTdkdK6m/VxJwaOYJhskYfiyWYJBrO54iVhTbWKDcF111W0lJDyUk5ke4j1xsSbW1rd2q6QQ++dYQan0CO/3zghIeMmH/OTeM9QTcCbIAwHg8zNvHCUweFZ9ZZ4UbKoWlIpsgGpPw9fjNzzHXnQNHhJZ3YedihAgls+yk5uZnjf0yTcuftbXg6Qwo8gagCFOrYyqRm2CFmk8/u/Ey75fWb5ha2TTbUkV0ebPMRNTdninA1V7v0mb9lNkc/Di1ty6ClCVIwhZPRxhMoT6GDay7DZgZ+9NyKMiL3Szrok+Wmz4WFe9hhOk7hAX6epROL4OJKs/Mvfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DxFJI8XqFgJieuustgmbxZmJo1pAIjjxYi8+WyAGzo=;
 b=t5RiGkJLIrKcohk5AhT7vnoG8UzGlxx+ho+FWPh2+n6EIhBPDEf6JiejsPF1n8HvepGbdeJ+OyZ8/8LV1r1AWaDeyHdXvige1CpCq1k9kMYe7HNcmYV5gYDuQP6XmdbiqMeRw92sT8DhR30CjTQJ0sKXCgUPn73fV2Cg5OVDyHY=
Received: from BYAPR11MB3095.namprd11.prod.outlook.com (2603:10b6:a03:91::26)
 by SJ0PR11MB5072.namprd11.prod.outlook.com (2603:10b6:a03:2db::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.27; Wed, 10 Mar
 2021 20:26:02 +0000
Received: from BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6]) by BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6%4]) with mapi id 15.20.3890.035; Wed, 10 Mar 2021
 20:26:02 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>
Subject: RE: [PATCH v10 03/20] dlb: add resource and device initialization
Thread-Topic: [PATCH v10 03/20] dlb: add resource and device initialization
Thread-Index: AQHW/9Zy7KjbIQK+akiyxmbe63Blnqp7jDwAgAD/eNCAAH8aAIAAx16g
Date:   Wed, 10 Mar 2021 20:26:02 +0000
Message-ID: <BYAPR11MB30959EDCE4CAED3834982CD2D9919@BYAPR11MB3095.namprd11.prod.outlook.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <20210210175423.1873-4-mike.ximing.chen@intel.com>
 <YEc+uL3SSf/T+EuG@kroah.com>
 <BYAPR11MB3095C06792321F64E98394FCD9919@BYAPR11MB3095.namprd11.prod.outlook.com>
 <YEh/pKVV36r2rbAr@kroah.com>
In-Reply-To: <YEh/pKVV36r2rbAr@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [69.141.163.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a21d088-31d3-4ee0-7dda-08d8e402b949
x-ms-traffictypediagnostic: SJ0PR11MB5072:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB5072510C5871221097F35F70D9919@SJ0PR11MB5072.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t+IAIEFwsx10a7g/X/WvaDspqkQ/4xVHj3xdHfeTYy8JwT5Ky8qYJUQpULLOPWuIXvYAPTwbdd1fD2cNbLG3LVY+1Kz2KH9AzLVYECNEbO5q+42azqISZOGIABoe3f+/Jiu3jjCfPGvPANNRjsafGvVfwuaBnbFWBS3ntRIevOuY3T25P6HGKEEsUXwAt4Ocq/o8gsthxVEO1njUPafDrFH7RhoUmO9d9YX2rYHPSezZEDCzVkTum+EhHdg0D8U1bjEKCEwSxIb49WQFlOrIfj+tYcAQJdVFgvMMXy0UOAFttWBsAUAFsZP64DC4PoHAVF7Gi0EtGRpXqNCtBZsIwV6wCWR50dXEWfXpGTDhWaMVqyApn0ruHMpJwRyFaRgfkLzH13/hT2fYOfJxQDIDtqP3ek3vK4gwKiZ1woeiwdE/+pfGcxFY9SzyrtzY+ABHSv/m0ecziW19zgcIaMr71+GxpY8ntoB/QqOSfDKwivKj9vuRF9d25zxbm4NyNfFECEtvrwkrY6YW62OmIZrmZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39860400002)(366004)(346002)(396003)(7696005)(66556008)(66446008)(52536014)(64756008)(54906003)(186003)(53546011)(316002)(8676002)(5660300002)(71200400001)(8936002)(55016002)(66946007)(478600001)(6916009)(26005)(83380400001)(33656002)(6506007)(4326008)(66476007)(2906002)(76116006)(86362001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?fW6OY/2If0Tg85Ffs4cBT7TFhjo6pfi4LoBUcDkGDCV+OTTG5TSlhZxQkOTz?=
 =?us-ascii?Q?pg0WoADeWoGeJLRSQEpFdn3A6YV2gWt0oMo/5kqwhXA1JHDsQe5gx4sTKTew?=
 =?us-ascii?Q?c4VEA2ESuef/hA+afEFtWIxSjp+4cGLPHRt/NQkUWBFKxlGpx+nNmf9jF0w3?=
 =?us-ascii?Q?VHIWeWLw+dCu7URo7Dt4oWbEfCkpgRnZ+2SwsG2fa/0gaGpkqkdSw2zIMJZ+?=
 =?us-ascii?Q?1goAiDMEcDbFftsiHiN6WlGoGTwA88MyjjkeFrDje/5u5ZIy8opa70Lnz0Hq?=
 =?us-ascii?Q?H8mhq6vtD33or0vU1uJP86H3I7sra+OHGv8+fNI1MUowWV3Q6S81pJ4YDxtf?=
 =?us-ascii?Q?GuBzIPmBSIRL0bqrdy0Zi/x3fNe7Q+hgHTdopwz+N8wVeB/nVXwGEJU7jlQU?=
 =?us-ascii?Q?X7wk4n6bJ0T/73extvYoamaDjG4Ys17wbnHutaC9x03++kBZQPgzbztfgSTU?=
 =?us-ascii?Q?mhs/qLegoUfC6nNPogyDq2cv/5ffnmfdzpgKd+veq0L7Ga45yO7Qg+j7I+EZ?=
 =?us-ascii?Q?xDn2g9EVV9dk8lamtWuCdtX8ii+Gl19BjO6onE7byHFhkjIA44tX1c+L0XNH?=
 =?us-ascii?Q?fsSdW2YOrc3hPGl93yzlGKxjsn6xbNhkjxpGsq8gl/oZbBcLmO4xw/PHNusW?=
 =?us-ascii?Q?2mte2WznM483TjxIoegpXu1mqUYeJThz0gm3Op+yj/IhQw2ebrYEPf3fWxoG?=
 =?us-ascii?Q?KeLgYChx5D2DY9mO/uNkO6ig2JbxDnwqZ8CFL7FM9/aQizoF5H1SEGx1S7Qi?=
 =?us-ascii?Q?Q9QqQtmpqo0pKqmwP3pEnRYla54gmNAmiVcSlP9pxiJINigsUUSfFqim00N8?=
 =?us-ascii?Q?yvpbF6QkbGWlGzybDakGuwFGm3KS0SZ5oW3F0vtKV3WpMn4goUKtj7fKO1fQ?=
 =?us-ascii?Q?wVvnLWaSBDVmN7GWWbNBFOA/GwUGDqfsosWnPwxtU3Z7PM3uQEiGDa3vn0Oc?=
 =?us-ascii?Q?Vc08uUFPTroes0+sld+YFGDoON2WQpYqHlm8MTGnjQGWGu6RmyA6b7kUcUFX?=
 =?us-ascii?Q?RQbpNmwSPCa8ay4iz3oQ87QEzD4eKuKh5NafeiGtkBETH6GMt79wEvqDiX4k?=
 =?us-ascii?Q?9TJQ5IbU+D7xkLJLWeS+ZayYy9BI9DfqA6TndOCVXHE5DweXKKoLVsWUImXV?=
 =?us-ascii?Q?803//ZEvjQ4V0lWVpRUX/SoOu29c/ScHr+Y28U8RXoJD4M3jYVoPphkyvqFH?=
 =?us-ascii?Q?EtuK1XszNgD5UcoDEa/y7AtIoEnHhHjh1y8hc4HGAYWhTKiGYas8jX+a2Xhv?=
 =?us-ascii?Q?0jjlyQi9+iONFOYxdSZvda4WybXPd5wHiAA9JFxv2XLuJpb0r9qAMonKDuUJ?=
 =?us-ascii?Q?rxClQ/bDorxJer1fWQaeGkcK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a21d088-31d3-4ee0-7dda-08d8e402b949
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2021 20:26:02.1544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /DimFQXlg9FmSG208+kjrl5LnAclIERlz1GRxHTlyT5gw1o5ZY/LT3EieKJjdu1MhRXmOedHx5mojhvV/HHH9f0/sfuk327+02MQhZOo3Wo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5072
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Wednesday, March 10, 2021 3:13 AM
> To: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org;
> arnd@arndb.de; Williams, Dan J <dan.j.williams@intel.com>; pierre-
> louis.bossart@linux.intel.com; Gage Eads <gage.eads@intel.com>
> Subject: Re: [PATCH v10 03/20] dlb: add resource and device initializatio=
n
>=20
> On Wed, Mar 10, 2021 at 01:33:24AM +0000, Chen, Mike Ximing wrote:
> >
> > > -----Original Message-----
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > >
> > > On Wed, Feb 10, 2021 at 11:54:06AM -0600, Mike Ximing Chen wrote:
> > > > +
> > > > +#include "dlb_bitmap.h"
> > > > +
> > > > +#define BITS_SET(x, val, mask)	(x =3D ((x) & ~(mask))     \
> > > > +				 | (((val) << (mask##_LOC)) & (mask)))
> > > > +#define BITS_GET(x, mask)       (((x) & (mask)) >> (mask##_LOC))
> > >
> > > Why not use the built-in kernel functions for this?  Why are you
> > > creating your own?
> > >
> > FIELD_GET(_mask, _val) and FIELD_PREP(_mask, _val) in include/linux/bit=
field.h
> > are similar to our BITS_GET() and BITS_SET().  However in our case, mas=
k##_LOC
> > is a known constant defined in dlb_regs.h,  so we don't need to use
> > _buildin_ffs(mask) to calculate the location of mask as FIELD_GET() and
> FIELD_PREP()
> > do.  We can still use FIELD_GET and FIELD_PREP, but our macros are a li=
ttle more
> > efficient. Would it be OK to keep them?
>=20
> No, please use the kernel-wide proper functions, there's no need for
> single tiny driver to be "special" in this regard.  If somehow the
> in-kernel functions are not sufficient, it's always better to fix them
> up than to go your own way here.
>=20

OK. I will use FIELD_GET() and FIELD_PREP() macros in the next revision.

Thanks
Mike
