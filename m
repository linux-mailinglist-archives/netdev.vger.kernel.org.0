Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751596251D8
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 04:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbiKKDna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 22:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiKKDn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 22:43:26 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E6730F;
        Thu, 10 Nov 2022 19:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668138205; x=1699674205;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MhG/3l8FvBJB+fQjVbZK/HH5McsQQhseumMQYdEBJ+w=;
  b=gdtgLOp2L4/YX4i6me25ivm3YHfm6Mx8yhzcZ+zyIiZ7lYQDsMpk0Ig/
   wMVeolQEHLXt3MGF0N7054pUAFnzd17dDfpGivAqy3nTYqNyTSkeqUPyQ
   SmWhZ90AOuegzoNBP4VDCRmi0MBa1tMNjWEPKr2jg+Pzz3LYDICGJ/XnH
   r+5gxQG3tzc/OeeObOT4gyEpykw4SA+AV5NLob06SwBmvEegG4wamfbnA
   8pnrQsRIbI/XIsOT4sET1aWDfimImOVFu1tQ9U8mYGKh0XATe+HCfgHkI
   YkivVz7406dKdUIn9D+6TB5vBMzMhFfbQaPk04QyPj01mtc+xpSr+b0v+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="294869667"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="294869667"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 19:43:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="743135028"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="743135028"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 10 Nov 2022 19:43:24 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 19:43:23 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 19:43:23 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 19:43:23 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 19:43:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/exG/Qom05uWSzgf/D6wlr1yh+qc5e1W9tovQYxzzhciJELi10lkCfqhnAi4/di80A3UeWRkbA3ZpFJUce7zxtZpHAJ2t/i/x1f2op+Fc6jQXUYiM3OBuH2feijyRNucLDyP3O4782p8HLrbswfe0KPUhSmFE0y9Xf3p7luIhKxZKFJukUQg0jp42bquGQNy/4hA4nQ3i2FFowpWZxCrw+rpk5SnTnXZ73D4Kh+F3aNLgdCqre3Bh0rZaYZ17O6MzUqIB4yzIpSxGEAnN4oDlarZuS4XMZP0FNkgpJooWo2u3OnQkZ3ubzP2U8blz2hINAUvzSfkZVc3k0L1fWdhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qtB/yXe40z4SkFcTEYMumfgkbo31xyZNFVfzaGYI28w=;
 b=g8cx7CGuP1vp1pa60AXOduwsZFwfuHFboN7LwLgZlPzUIaj2zhWa9l5MR5+0OMhgUktxpU1OyYqyNZxR4/i1KbQfnmR2ulFQbOQfGGLGeTSEYhL5W2laQIbE1CZNZBz/Tm6dfPIA88B3Z28AGB0I2H9dwx92tiRw+5SIqoaJ2DJ46QxlRjNTHTyu+3M4qAomxZSmXFQqsGgb1LserQ0nNATzSUjd2cDS2oNhsE0YAe0MZ5irYLQwNxSUvRNZeJwq6COHmZa1Z+y2PzP1l4kq/pVQRitJmS1bX8S304CbEaSL3DH0Xzgu8i9grQzd2Z9aiIYXY3o29pYMhcC9bNJIdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4348.namprd11.prod.outlook.com (2603:10b6:5:1db::18)
 by PH8PR11MB7070.namprd11.prod.outlook.com (2603:10b6:510:216::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 03:43:21 +0000
Received: from DM6PR11MB4348.namprd11.prod.outlook.com
 ([fe80::7c3c:eff3:9f4a:358]) by DM6PR11MB4348.namprd11.prod.outlook.com
 ([fe80::7c3c:eff3:9f4a:358%4]) with mapi id 15.20.5791.027; Fri, 11 Nov 2022
 03:43:21 +0000
From:   "Jamaluddin, Aminuddin" <aminuddin.jamaluddin@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>
Subject: RE: [PATCH net-next v2] net: phy: marvell: add sleep time after
 enabling the loopback bit
Thread-Topic: [PATCH net-next v2] net: phy: marvell: add sleep time after
 enabling the loopback bit
Thread-Index: AQHY80Xv5uvGNid//E6fpHCVkDBna643dVYAgAGjLcA=
Date:   Fri, 11 Nov 2022 03:43:21 +0000
Message-ID: <DM6PR11MB4348089897797A395837038081009@DM6PR11MB4348.namprd11.prod.outlook.com>
References: <20221108074005.28229-1-aminuddin.jamaluddin@intel.com>
 <20221109184132.1e0cd0dd@kernel.org>
In-Reply-To: <20221109184132.1e0cd0dd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4348:EE_|PH8PR11MB7070:EE_
x-ms-office365-filtering-correlation-id: a07c8969-bccd-461f-f0dc-08dac396e0da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IC5eKwtFwqFXc+UhDqxT4C1X20GhDHWMmspMFOl0VvgeU2hS18BiomOOhgeXhS9kpWcKEAFoJnbeuNkfl6GZtQHycWM2ARjeGkptYJPwdjl7jEVZ9uBw9qq4gQJXdYZGrcIigqwkq/5QFCPlC99Ciu8sOQFH5UoYMKaoL8NDMlOPK1Dhfo+d8w75LR7dt14YB+vo8F7QLiQpNkQraNW/3I1X3cel2rQEvQIFCHpjVsX/cEeB+H4QuOGJQgH4nUkQVde+upNBOkPU3My0dGcum4OwrILAeoF7TXoKbG0P9+QZXyHkVrtcxtzFTYzHx/1JkvqbmG1tmrbVv8xdKZ12njVSh27nxdwxiBwip4neXg6SqMrOkUQkBi5bHjGN2KQwNkv439xrD9sZYCp3vmflAzPSzaFsKFXJZ7Fti/jG9DyvVLDgVYst08ghMkou5Bn0Yjdzspoc/duL2CZY4ssqDolNC/bWKPu6g2dVfA+VSPK3LqAPzN2zVc1b9K834G8463WmtXqK+NNJePDi55HAPL2TtuSZGBmLRMdHZVEzM8I3UI2TAjwX9UAvROtRkFqbTZr3uJ+qtFRztqTTbFHs76Z3WFNfSY+d6rPrEJhOayPVUJFlQ0TEAp0rzG+g+2sVnvaiGHZIGcgqyYe42FXetXpgDsL8v5tjNqenWxXq8ARKqoaE8Eg9EMXyBIz520FS3n/372abkmVbcBdudTiYF2TL8QpBUcvyUviAgH8L4gLuHi2jnWuAnJFNQ1V6gC39hCNOuRcGSHymd1+h/ObwQ6qSIW6rsVeOB9EA2rtjLm4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4348.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(39860400002)(136003)(346002)(396003)(451199015)(55016003)(53546011)(478600001)(83380400001)(7696005)(33656002)(6506007)(316002)(2906002)(966005)(86362001)(76116006)(41300700001)(107886003)(9686003)(66946007)(8676002)(66476007)(66556008)(26005)(66446008)(54906003)(64756008)(6916009)(122000001)(82960400001)(71200400001)(38100700002)(4326008)(5660300002)(52536014)(38070700005)(7416002)(186003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XIH28Jk/O301Cv8FL4E/Qa6Ank/qpygWqL1OH80Lf97PC+n+NsUifCay7k5u?=
 =?us-ascii?Q?TuuBR+bWaPujd86PPuS75rc58VqSjc4CeUBU4KvMTzyVnrBmdppihhw5xAym?=
 =?us-ascii?Q?lqgbkVaI6QE3+T08QF5si7d6EV/r4Y8ivw4q0jXn8K0GxpGnD4jKR8rFec1V?=
 =?us-ascii?Q?2VxsqdOISV/tycUWOgVs4SCUFaMpBpxP9DJOUSsp0R0nWaCVjeLSduhsN72S?=
 =?us-ascii?Q?WbwBy3BiIuz+NMaUTMvg7gQPeI2sT6DP1Pg6qj7aQEWVNqw68S/TchkgO6E1?=
 =?us-ascii?Q?5zwUVuitoqflw1le0PJCmUktweMUpksChLNgsgAUVl4NzZ7eiCH34szvhV/3?=
 =?us-ascii?Q?wERZOmp8BAsQYOhw/vxNEoZx3Zmbea5bMVEzLjl0mK4d3PTQjee4+16Y5XJA?=
 =?us-ascii?Q?8aObxvGl563NWXEtlH+ehMOixnfOzxFVR+kGP//ORvy1exYAn7gInAh7mdlI?=
 =?us-ascii?Q?rX1TLcCBI9kM5lkrqRF5l39HTXf9capXIPIvXGvATpRblGsMry/Vmi6xa/Rh?=
 =?us-ascii?Q?UDdX6ZL5EcAVyZO+eoa7gwh6O92loAmYlg9ciBB8R6Ew628Lpr1T9jt4TdVE?=
 =?us-ascii?Q?Rf4VNcNkjnp8KtNR2laAF+2DOd7U//Tg7XvvHk54qflqWCBaK51LWIufI/U0?=
 =?us-ascii?Q?+KFAfCwYFFPyQnuNzNdq+ngMFtjR/d6XC2Rm8DbdFBVAMdtnSaKsGqAEV4Bo?=
 =?us-ascii?Q?0S078LMGewDQbym2fP+WvV9eMypNHcv5CfwV7ttjvwoxBA+YquFsPwxCiLMk?=
 =?us-ascii?Q?7pT+Wr3x0ddTqpBvZCKkVAZb731cI93pFr2Rv9au9ettEaMmIe/GVOU6W6PH?=
 =?us-ascii?Q?+csK1ZhpfOwSVFAMdc4KMmnERKIK9JB2BIAUGOVm3pZE0n8M6d29AowMp429?=
 =?us-ascii?Q?2bJKG/9ynQ8DPGEDSd/hc9FHNKOLCtMT+oBkIzU94lydd1IlPT0maEWdoG4V?=
 =?us-ascii?Q?6zKE6vAtlSBk0NlQ1sns3RFpeM+bQehizvcOCCcEAYGX60clT723Wc8pN4i0?=
 =?us-ascii?Q?0BBTlTzJFUzFVPptYHovgaaDhNMqegbsnIHsN2lDLf+RnMDxqOFO9l//8vW4?=
 =?us-ascii?Q?ljCOhdAf+1VHNTIzS7Xvm9cM4V+es/z9Ln5azEB+NgCnZHdg8W/id5NEmdPf?=
 =?us-ascii?Q?h51Vv7pC4MhuzwzZ0FGjukhu9Tcz1dcFcu1wFvYXrOPqnZZGkL1t+GXl7mpm?=
 =?us-ascii?Q?cFVVXVZZctDp++k6AR7AVZqoSBv85pV3mYdU0jto4aVA2plAoZUEiS0uSvJ3?=
 =?us-ascii?Q?owNC+XiO23u/VCK3ybFJax3mOsA5X4UJ7RCgGgrwh4tzqvG2PDeDcGiANNHg?=
 =?us-ascii?Q?Y15yREkGLJXFI15pQ5UCqchhi5kBKUFve95x+xdCn8mFDLWyNFyPvWSGrYJx?=
 =?us-ascii?Q?uh1Xl/OVkREHITKk/Yv8wHvw2SGds3JFolOc9ON6ML14VxoJAqklElEXuHY0?=
 =?us-ascii?Q?J0wybZNjmXRb0y9lwIPWKkSWBBo1UsIC0LGx0yfXdmRFyDRUywE08gLc0/fz?=
 =?us-ascii?Q?AYrdkHRm8K9h1Igule/nAEBktH6uWo3OKm5L89Sl3CxlQFMkUmPtN8clbut2?=
 =?us-ascii?Q?iyASiX/jtxfj1FYXmGkDM1KPISbCzsU2KlNHMfHqDOMnTb03En8SCDpEbyNX?=
 =?us-ascii?Q?7Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4348.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a07c8969-bccd-461f-f0dc-08dac396e0da
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 03:43:21.1145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LfFR+R0hmH/xsVRlwTR16VDUCjL7bXmzwuB4Y66iZRTiUVEHdk/MYTnIRa7Mzr8KOkg42CVfGVpd2aSwojWO/CnXIH8DpjzyTxA0IUcuAAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7070
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, 10 November, 2022 10:42 AM
> To: Jamaluddin, Aminuddin <aminuddin.jamaluddin@intel.com>
> Cc: Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit
> <hkallweit1@gmail.com>; Russell King <linux@armlinux.org.uk>; David S .
> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> Paolo Abeni <pabeni@redhat.com>; Ismail, Mohammad Athari
> <mohammad.athari.ismail@intel.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; stable@vger.kernel.org; Tan, Tee Min
> <tee.min.tan@intel.com>; Zulkifli, Muhammad Husaini
> <muhammad.husaini.zulkifli@intel.com>; Looi, Hong Aun
> <hong.aun.looi@intel.com>
> Subject: Re: [PATCH net-next v2] net: phy: marvell: add sleep time after
> enabling the loopback bit
>=20
> On Tue,  8 Nov 2022 15:40:05 +0800 Aminuddin Jamaluddin wrote:
> > Subject: [PATCH net-next v2] net: phy: marvell: add sleep time after
> > enabling the loopback bit
>=20
> Looks like v1 was tagged for net, why switch to net-next?
> It's either a fix or not, we don't do gray scales in netdev.
>=20
> > Sleep time is added to ensure the phy to be ready after loopback bit
> > was set. This to prevent the phy loopback test from failing.
> >
> > ---
> > V1:
> >
> https://patchwork.kernel.org/project/netdevbpf/patch/20220825082238.11
> > 056-1-aminuddin.jamaluddin@intel.com/
> > ---
>=20
> git am will cut off at the first --- it finds, so the v1 link and all the=
 tags below
> we'll be lost when the patch is applied. Please move this section after t=
he
> tags.
>=20

Ok noted will correct this with V3

> > Fixes: 020a45aff119 ("net: phy: marvell: add Marvell specific PHY
> > loopback")
> > Cc: <stable@vger.kernel.org> # 5.15.x
> > Signed-off-by: Muhammad Husaini Zulkifli
> > <muhammad.husaini.zulkifli@intel.com>
> > Signed-off-by: Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>

Amin
