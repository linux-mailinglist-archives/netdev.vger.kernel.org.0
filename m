Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEE63332CA
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 02:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhCJBdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 20:33:55 -0500
Received: from mga18.intel.com ([134.134.136.126]:8380 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231228AbhCJBd1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 20:33:27 -0500
IronPort-SDR: PJxnt0d/xgpRkOg9hAWkDp9iApduLfJXMtqNCnEc0Y3sKaWs42vN0/mngI6jdcEMw97lqHHtru
 ImCJDYtRo6Xg==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="175960397"
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="175960397"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 17:33:26 -0800
IronPort-SDR: i74eeeaowqa0pjg+ms0kOd4yH/P0cDNA0oZlyGHrz1ZfKIvs1xZhri9XxepUmxwB+eFMY4mAbH
 +hgiIes1Wc9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="409970338"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 09 Mar 2021 17:33:26 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 17:33:26 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 17:33:26 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 9 Mar 2021 17:33:26 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 9 Mar 2021 17:33:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeZG+6bYpEQElY21LEcX90ylhOHmEG5fHRY+VSGMrxYFZMBX3KYmGNEHK+xyGTibH0CtXPT3ZKNc6Qg/p1nXzgmZESXgY7+7rf3dQq649jKZGkQDmrXhwC2VzEEhc91JAEEToNi+S2FNdGIhx3SlyyplOOF4aBQSNOgI4hPtMvLENarwmiZbE1pk2Na08E0j3l1ZXcFexC9Kf1AcSc1dk08sq016BxPbjnKqDSDMssGU5eyuox2F6NXAqN5JRs1z2C8woAQkqK3Caj0dldA4D+9t6Ef3Ar+mjIhIg0BbpTP+HTA3QQMHUMdk61SqUtX0yKSh1krApv2S9VqqdTjGYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6fq1DP0/aP81P6eKI7NHfAA467Rn5UBD+zTYimajbg=;
 b=mlmzuABxBSgS6jZ3Cfu4o0tqNyOVu0yH4XseYuAXQS0J6qyCrolRD9eqpiY1KhpNQdvLE9HiLR+GRGRxI4RSYC8DfGb/iVTJAybDOB6P9wLpLmGChSB3Qba7w5eIVTfHCg3yZvmSY+mnmNsLBy2ETVYaqDNlZZ1ZGS8RLIgPIwbWh83pCPNcfh5rY7uEpKSexy1Wo6rXLIr9y+oRf7niR9Kb9Dy6fCPzl5n3LCxDf4gy82wB5Fl/PThm0WQRi50rvlOD8z/bBsku69si5v/OuL2dDHg++qWAxRxONa6LZC2Bdi5lCbUi3QSpWZZuaWQvMh69IMVSOZcaSbA2AEmY7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6fq1DP0/aP81P6eKI7NHfAA467Rn5UBD+zTYimajbg=;
 b=p/0R3T1fbt2JzamnXLPBvmiBETzTbF6V7KKl8k2XSk3ELPpMXzLn+J4iK1VVV1rJXnAQi8q8sCNiUggipi++r76bvj+NXLNT4O2Rywux4zZYWuhtU8um/tO56tbmhwRgLEWZY6AENErrSceYpcNz2ARTMjSFKdvmTEdDbgzpuAw=
Received: from BYAPR11MB3095.namprd11.prod.outlook.com (2603:10b6:a03:91::26)
 by SJ0PR11MB5150.namprd11.prod.outlook.com (2603:10b6:a03:2d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.27; Wed, 10 Mar
 2021 01:33:24 +0000
Received: from BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6]) by BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6%4]) with mapi id 15.20.3890.035; Wed, 10 Mar 2021
 01:33:24 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        Gage Eads <gage.eads@intel.com>
Subject: RE: [PATCH v10 03/20] dlb: add resource and device initialization
Thread-Topic: [PATCH v10 03/20] dlb: add resource and device initialization
Thread-Index: AQHW/9Zy7KjbIQK+akiyxmbe63Blnqp7jDwAgAD/eNA=
Date:   Wed, 10 Mar 2021 01:33:24 +0000
Message-ID: <BYAPR11MB3095C06792321F64E98394FCD9919@BYAPR11MB3095.namprd11.prod.outlook.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <20210210175423.1873-4-mike.ximing.chen@intel.com>
 <YEc+uL3SSf/T+EuG@kroah.com>
In-Reply-To: <YEc+uL3SSf/T+EuG@kroah.com>
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
x-ms-office365-filtering-correlation-id: c629cbca-45d1-4479-bac0-08d8e3647f65
x-ms-traffictypediagnostic: SJ0PR11MB5150:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB5150A47E9215E9B2D72551D5D9919@SJ0PR11MB5150.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SI7ecbqL4HXmORvJViYsR2RLHejTBeMvQaElH4k6Ad2p0LbM0FVhpYZ8XO01HlaHm8TFiYgS9H61dh92Z4q3Cm+g9crd9PFvXO9Ecm0YXmXQA/+pOUkiVdajUoV1fHErWtSDmp3GwvTB7Y6QfA+nLwOVRw3lqDU7krIIiSlLPA0BRhpYWMn+xhluZ6XOQWk/y+simJAxjeBiQ+xDzSUU5QLrLBguuiWY07IXJdTxOIJk+xV/3/WtYB7kiIJR3yh4n01CMKwzJIbtbapZorw1iO15qy+eYym6/zYRecWOxgLdyNqgQWiSI3xPv07mr3WNkskEol+vwyoQ+6i2r+nyHZLXLzTUCy/zzYFlANEb5uOt9hZo9D5bqjPnPnbkCkgIgzvBBxeCwGFGZ5WOSize2TNs7NeINiDh1erwijLiMvV9Aj1DKjwEkVKH8147Ysc2RZKC+3/SW2TVUVVRajDM6EDwA7VEYX09jdY/1EhL04vf2Yec4AxHZgmf8a1eNIXmZYj7s0LVZn+T5Wiq4F/D/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(376002)(346002)(86362001)(76116006)(52536014)(83380400001)(64756008)(5660300002)(55016002)(66446008)(186003)(478600001)(26005)(8676002)(316002)(9686003)(33656002)(2906002)(66556008)(6916009)(66476007)(66946007)(4326008)(54906003)(8936002)(71200400001)(7696005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?MASRNI1rtf3WJXkhWjW6Tm+j1s1zd52ZTPgUaNdJGQWuc3rGS2nqbBFhng6X?=
 =?us-ascii?Q?40CEY2EPvFPwNI6HolEwhCYLQQhx9W3xEoDdiDABuS58AaCtA70A/eMcpGZH?=
 =?us-ascii?Q?yG3D1+qZAjYUkr8W0ibDjCHZO/cq4bfRB5TQTYOrky0gZY4r6Iowtq+C37ns?=
 =?us-ascii?Q?dKeUs1gRemhlEHDA5tykF+1FHbgDBaadCwUGF67L7pDPgMfiUdaynrKaGeyO?=
 =?us-ascii?Q?6gIA+dAVHovIGkTW+BMvj/JqwIFoB0CuFunc71A5IussIRAfjKtHscJdq4dx?=
 =?us-ascii?Q?g2CDeaVsXFMTtvQm1psNw8uaxdXxIIgLX/+EIM/A7CxRYXS/dPcLxaUYLI11?=
 =?us-ascii?Q?yK6HyLTDaq+hhYQqJaXES1eccBagviau9KbffuyMgFkIpiwDIQyCJDYHrf+J?=
 =?us-ascii?Q?agp1g7lTSlY61LWwUeHb7uqMk+EK5TehxeaLc4obhzY3zkUANmeba5P3Wnwi?=
 =?us-ascii?Q?IxrIgo/AIt8PumqsJ/0Rbjr4VjvSnUq6E/pxJfg37ePnPFEGlg7A4jOcs36E?=
 =?us-ascii?Q?XdqqcWTmBn/B8WSG441ope7bKw4kGZhojrhtYEZs3QDcYI5Ny7CFwUbN+o8W?=
 =?us-ascii?Q?v+etjRUSa1nxuogsVa/udrkjjI36MzAIHsUMeEfuouof2zYLbqpsVljI1F+N?=
 =?us-ascii?Q?kGe5old7smPMIBpRoAcPfe9ArY3f/QsSL+U3z39SfBotokZ3MSLR3M97jTrP?=
 =?us-ascii?Q?6qng8FxxS8bU+o4xgXrsAR8hvbrk0VTuwsoG2zwdXzHbqNcHxvrJOGhW3+XE?=
 =?us-ascii?Q?cwxvIjS72kpMfFTruFtBypq7eOVbnlTuhgwfcbIzN8yUIGME/wMw8qk6Q0TT?=
 =?us-ascii?Q?mLeOpC+NJltulsoOfHv+fkpeVWKGIxAQRr52nxKaGhWuMIN86yhsuiFJgvXQ?=
 =?us-ascii?Q?UmX3fNOgRaTBhrTiSoYLiSOdCVAsPs5MUOHllwC0Txc81Ux4x73+QeGw75jr?=
 =?us-ascii?Q?xF0zQGrGd897pZICmFNxTz2Jft/JebDxwZkSozN5XzXXJUzmpxXPCxFZZRFj?=
 =?us-ascii?Q?M+HFNEiNr/X5NNqMkY3IlC6u9crUXbSjVzN3AQHpfhwVIw6cgWZ+y3NcyBOL?=
 =?us-ascii?Q?Tgi2Bm/AzTqS7wBPjkAFKF6/XTqd4Ej4cXOpYvSFFtMGu6T+TahBp/iyznNu?=
 =?us-ascii?Q?PLUHKkCRBC0EsYo4CQB6E0flK0pb8beM2UDZ/06Gy84B7Xn2j9zRFAgyJvFb?=
 =?us-ascii?Q?IH0033URP7MEaBULn2nF6I5DwHMv+tyKQ+24PFKl17T7iJt6MeAzR9wR3TST?=
 =?us-ascii?Q?foIXXBj9Q51G9mx0SFoI4kSnTSULUMaIxMCEGax82E0gB16oIEpmOJStyTpC?=
 =?us-ascii?Q?LHhTLtavvNbsTbZv7gkv2WO+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c629cbca-45d1-4479-bac0-08d8e3647f65
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2021 01:33:24.5413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 96ElFcSBDGYOciNxxNDXOY5ruyDKGTNka1+Ne5oda9utMGXZEGrsmeKf/fG0dGBMckJsq6eNHPP6ipT/Wscj3b6YEoIizcFB8RLG2XSA6z8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5150
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> On Wed, Feb 10, 2021 at 11:54:06AM -0600, Mike Ximing Chen wrote:
> > +
> > +#include "dlb_bitmap.h"
> > +
> > +#define BITS_SET(x, val, mask)	(x =3D ((x) & ~(mask))     \
> > +				 | (((val) << (mask##_LOC)) & (mask)))
> > +#define BITS_GET(x, mask)       (((x) & (mask)) >> (mask##_LOC))
>=20
> Why not use the built-in kernel functions for this?  Why are you
> creating your own?
>
FIELD_GET(_mask, _val) and FIELD_PREP(_mask, _val) in include/linux/bitfiel=
d.h
are similar to our BITS_GET() and BITS_SET().  However in our case, mask##_=
LOC
is a known constant defined in dlb_regs.h,  so we don't need to use=20
_buildin_ffs(mask) to calculate the location of mask as FIELD_GET() and FIE=
LD_PREP()
do.  We can still use FIELD_GET and FIELD_PREP, but our macros are a little=
 more=20
efficient. Would it be OK to keep them?
=20
>=20
>=20
> > -static void
> > -dlb_pf_unmap_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev)
> > +static void dlb_pf_unmap_pci_bar_space(struct dlb *dlb, struct pci_dev=
 *pdev)
>=20
> Why reformat code here, and not do it right the first time around?
>=20
Sorry,  this should not happen. Will fix it.

> > +/*******************************/
> > +/****** Driver management ******/
> > +/*******************************/
> > +
> > +static int dlb_pf_init_driver_state(struct dlb *dlb)
> > +{
> > +	mutex_init(&dlb->resource_mutex);
> > +
> > +	return 0;
>=20
> If this can not fail, why is this not just void?

Sure, will change it void.

>=20
> > diff --git a/drivers/misc/dlb/dlb_resource.h b/drivers/misc/dlb/dlb_res=
ource.h
> > new file mode 100644
> > index 000000000000..2229813d9c45
> > --- /dev/null
> > +++ b/drivers/misc/dlb/dlb_resource.h
>=20
> Why do you have lots of little .h files and not just one simple .h file
> for the driver?  That makes it much easier to maintain over time, right?
>=20
I combined a couple of header files in this version.  dlb_regs.h is pretty =
big (3640 lines), and is
generated by SW. I will merge other .h files into one.

Thanks
Mike=20
