Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88A36BAD7D
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 11:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbjCOKUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 06:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbjCOKUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 06:20:31 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E867D57F;
        Wed, 15 Mar 2023 03:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678875606; x=1710411606;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qcljRFB6wDxNqc9lNRx5npEanbDfcy0btHbSb5vVztg=;
  b=XImAW4TA7KL5+eU5LMMVrygk12UeK+K0sO6+memXMoOOlUKqzDfh13jY
   QMDwKAODztX3hRfotAb6K6C7fFah8nNXmPfI4AVPMp1HIfXR77D6m+bht
   SGZGF2T72VcnwwevXCJ49Xrofk5VV1seRt49NEtqvjTErYg80dVttoR06
   xhVSZl3CJwzZwVzJQNilLr2kGebWBT6XD1H3nm7L7e++WaLM1UwlWBayb
   DAUGs3KHyR2ohkghYJHfOKSVVUnZkN1us2ZdZla8R1QFs8AGPhh5idaii
   ZbT+0mNcvp73bNNCXCRdNarmi2s+yBTnKi1yjxdP2C+DW5BTWx69MQJcp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="335150896"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="335150896"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 03:18:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="822730638"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="822730638"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 15 Mar 2023 03:18:40 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 03:18:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 03:18:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 03:18:40 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 03:18:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G95AASrpTlhC1oDuO0IhLrLkQ+cBlNpCGvRYJnTisGMgMq+CSzan4Ze+pwZOHAdtA5bOdxC+f45Pkb/2Hvnu+oEtSZQ3Q/gI8lABqz1SRjBoIV8qXQxEeiViIHVh5y7n4z70G17iPnbzoFq6wO77kFV8cDIlFFpdF+ZnBXjEJMM84QTmsGgJqc3r2Z9Ab+KE+lsCHEyAq7AEevUkNi0ZOpa6XjI1NnjGETe2b+8E4SZnndlOchOVXqNo8X+pRoqWgK2IhWJ9WksOE1Vv8NcrH3hCM79VH4OSRezuyePbriRIVLzvEsO1smWvxq6mBUACgScZp6RMOt1xM3e1gvYFvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hL19weJRdWRyMgFOfvBs9zTBjJeNT/NDdUZos5kxsI0=;
 b=ie5PgCGpn/AK2a/pwDu5R5tVz6PHEFZqPYNMMjoPPEj+aRohe1mWn0CAe9V5PQPRsq8MhWab6CVGs7Bkhj8Z0kwwiRKVFOJQAh8Lw/uV/rA0STiW+yssCXDbL0GjGZH1dUkcNMB562z54etIfvWREQleHM/fWVbmFC2xzMHSIeNz3zJNM38Wqn5N+4EGnDqVCbbJ5td1x1E1SmrUIt6gf8HmbfM7seNe+8XomRS2V+Ar99AJA1U29zklkFfMZr0rAnk22E6dyGJ0sSBWAZ9ucIqok3brCfHPvA6fjo9RVD7tNPTcwNyLgBAISIsKcgOPAHME6UwWVtk1kNRoUTJZGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7587.namprd11.prod.outlook.com (2603:10b6:510:26d::17)
 by SJ0PR11MB6693.namprd11.prod.outlook.com (2603:10b6:a03:44b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Wed, 15 Mar
 2023 10:18:38 +0000
Received: from PH0PR11MB7587.namprd11.prod.outlook.com
 ([fe80::a9d7:2083:ea9f:7b0c]) by PH0PR11MB7587.namprd11.prod.outlook.com
 ([fe80::a9d7:2083:ea9f:7b0c%8]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 10:18:37 +0000
From:   "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
To:     "Raczynski, Piotr" <piotr.raczynski@intel.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Lai, Peter Jun Ann" <peter.jun.ann.lai@intel.com>
Subject: RE: [PATCH net 2/2] net: stmmac: move fixed-link support fixup code
Thread-Topic: [PATCH net 2/2] net: stmmac: move fixed-link support fixup code
Thread-Index: AQHZVlOZRKoa99f9J0u3oQrqM15py677m60Q
Date:   Wed, 15 Mar 2023 10:18:36 +0000
Message-ID: <PH0PR11MB7587C279640CA9C90CC54C489DBF9@PH0PR11MB7587.namprd11.prod.outlook.com>
References: <20230313080135.2952774-1-michael.wei.hong.sit@intel.com>
 <20230313080135.2952774-3-michael.wei.hong.sit@intel.com>
 <ZBA3+LqAaWXDZCKZ@nimitz>
In-Reply-To: <ZBA3+LqAaWXDZCKZ@nimitz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB7587:EE_|SJ0PR11MB6693:EE_
x-ms-office365-filtering-correlation-id: 0c0bd60b-73a2-44cf-af4a-08db253ea3cf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H8beQWeqFX1A5aVffoPy91HRSX1EprvKlAX8HhU4OLJbkzr1QlfVOJlVAZMkMfM5S4U/CN2LOZfvV19LLSd+tCnJrr9SNLsRZESez+4AHPHxhlhL177xa04W/QpWR7VI1CrFnhCuPROcjZNrVVtdU9cgfaQj/dymCzU095ZJTT0NdF+PFSe7jhxkRRCNXxYs7iY5zRNRGtRZDUTJFMGKSaF4L0dzJ0iRPnvWhkjcC+ZzVSTwtAOnKuTjoZQA/cK+NdJ9IkCBNVNJV/sf4hGD7tBNIcLeemSbhTuj1T1t92uHHTRHzw23BmFG3foeGPBaGsCgLB33zPRnfV8xy1moepl7iK1OpG94UGrJL1kXLrzMyRCPNbt698PBcPPV4oI7Gc2ehDT7GJmgw2hDgTzCOo3+EuhLg6UIIxYAp2/WQ+SBwU/ZkEzo7sJmIaoJ9BoVugRa/jvL5/t8l2+cMO7TCzwXlTOB2SWabp0xCS9L+1VZegFCnKr8hLTRdexeZJ8gNWvZt/hFHE4GTrT9nOG5mUfOBu0S7Ny5gaV94nONd/90oYP3YoRa8JlFvlWvLST6N9v+8oEVJVCCkfODIYvJhV4kkG91x6b1TBkYCqZyR04Ull6W27KQfGgN+AQisNfFn2AiRgHYqrwQOVcGunC0/nlWSa8M73RyjijosfOKj6Na8TNdA8KL80mmMWmTgnqCwOtmWsH/5p3xYK2V7+kuIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199018)(478600001)(83380400001)(71200400001)(122000001)(82960400001)(2906002)(52536014)(6862004)(8936002)(33656002)(7416002)(5660300002)(86362001)(38070700005)(7696005)(38100700002)(66446008)(66556008)(8676002)(6636002)(316002)(41300700001)(4326008)(55016003)(26005)(186003)(107886003)(54906003)(6506007)(53546011)(9686003)(66946007)(64756008)(66476007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u2e2kQfSD3HVVEdaiBEjwaZWga3Ag0btJSsXmCt1qkeA4vD21F1NCfolaJEQ?=
 =?us-ascii?Q?Yoz/elOwJs7DdIu00WVIrMMFkiEQuvoP0+fAh/D/cmbDSls1C+UMMyh1jPDV?=
 =?us-ascii?Q?qLYRwPxnZmOohGeS4D6LM55b8MLE6aDVF9d7WF/CvJTvRlSyarSEtAkY9Qgz?=
 =?us-ascii?Q?CQ6DDwm4YYCWrb5sgs5Z204I3FYuErHODQuij29uIAR7wE2hm+PGp28S0xhv?=
 =?us-ascii?Q?NYN7KnhHDZqQfZDwMMsSFGARO0ewSrb1zdDUcEC0WZlvTjBL/GKftme8qSOP?=
 =?us-ascii?Q?f5wFU3qkdqmIXHvAj7yNs3nDXDSlJdKOM+KonhvkGzYan0H6gI8rLJzZGItf?=
 =?us-ascii?Q?0MOP5RWo/lBe5kpYrE3bG0Ve2qlXsrhKEeiP/UgGcKiPuMzi9P8cuLnCaD2J?=
 =?us-ascii?Q?SCxCB5mO27iikzUUjlPG8ottZMj+jKjRV/ZocavmD7yt1E3JD8gC/rXRr9lF?=
 =?us-ascii?Q?HBlSTlKqxDbUZihydf61x9+luOx37zUfcvTA2mg2xzRBuw62kJPIreW11AfT?=
 =?us-ascii?Q?1sZzT7TbB22Ar4aphcGrs8pY2P7NzGua+ayMNAbLy/4QJVFftz94pQiRkqma?=
 =?us-ascii?Q?yuGI9NVW0/FLSucHlrRZQTkTIeG1eZcSqPPKGZc/TZokpoW3J+DPH+3FUIKG?=
 =?us-ascii?Q?4IrZdvJcjMNSh7Xxn1nZv+YqrsPQYG3t+IELI75ltoMM+gdveeoGHRJvH6hV?=
 =?us-ascii?Q?ywIBD7/3HQD2310k9vj96O7z/RdzubF6PDAs4FCGCy6axjBQ8HY+SosjOt71?=
 =?us-ascii?Q?+1kgifFmX4l4hSKwvwefFLcUwnpeF49uZ81JZbdkSrDQ65xfYlZ7BFEsHA9G?=
 =?us-ascii?Q?trlUn47Z7/Rnz7TMe4elw4ljYNDtjKwlGMRd76sd0Pgi+pZBZjwHfe87HAcB?=
 =?us-ascii?Q?DG23gO1sjn3OOYrw9veV0z+VVxDKGkzyv6QKRLMc3Qu6mAbwlrOSyuyfVuPX?=
 =?us-ascii?Q?cdLLIYKkfCCAK07pj8N8Rbw2W9KF5AHN/V/4f1VOdptJwiSuO+Ay4IhbzTIN?=
 =?us-ascii?Q?I6sRl7tJ2fXTUwOQtpR5OxCs4nebtosh5xFMuwSL6bzcV4LNEvOIHX/SHaRx?=
 =?us-ascii?Q?vq+8bn6KAmR6tCPBsV4BDS6eFu5sAVAedTkGbXwmeCy34j+3JQyXZH0yQ0tU?=
 =?us-ascii?Q?Qd0IKWBV7re+SuWX/Q5LYTjFSja8A1QAvwXev2USkQQAOnfsWegw87XWFTAj?=
 =?us-ascii?Q?VUO/lbW7LT0pF3VAL4L05tq9TpAylvePq6fbXiAt1HwrUub+v836s+qHv/qt?=
 =?us-ascii?Q?qKfIBlIzS+Axbf2buiwHoLSwS6xpEfZvrkFAaPTtHDfcW7kLaSZhL7tPdLAu?=
 =?us-ascii?Q?eB+Hy322p/zyjc6KW+eRLXV/8zQ9ZGnGvEQ/ki2E4Y21Ga95Q4tO+QM/w6/l?=
 =?us-ascii?Q?wzUl3zHK0wpq87qNXTRQoYpD3Ywa2JiBrvkuu1Uqrc9a6ei1TRIbv0tyxPJ/?=
 =?us-ascii?Q?KIBELhzdKy8AGUdUNaFIHVxDxk368heN9qfYRu58kLf1kCkkVHKJEuhIXaDl?=
 =?us-ascii?Q?GjqVZkK3ovSAsH8KdUgspt0zYnmHrRsiDmrGT+TEUGxmsdi5Zzgbv1+rgZqv?=
 =?us-ascii?Q?nGeARgUNrFKVNjQerQhXKhR2/uRGgJC+LI9nKT6aiyzg3zzQH3GayO6bYFsc?=
 =?us-ascii?Q?7g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c0bd60b-73a2-44cf-af4a-08db253ea3cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 10:18:36.9087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jzDxOqMwRiyoKnGG+0WSJBpypz/Xu7YUizSHFdW+X26dhJPjLp3+ApbNK07AgG9xyxd8YCyoOjoDim3Hrewa40UeLVm8i9sY7S5AvWcAiWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6693
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Raczynski, Piotr <piotr.raczynski@intel.com>
> Sent: Tuesday, March 14, 2023 5:02 PM
> To: Sit, Michael Wei Hong <michael.wei.hong.sit@intel.com>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre
> Torgue <alexandre.torgue@foss.st.com>; Jose Abreu
> <joabreu@synopsys.com>; David S . Miller <davem@davemloft.net>;
> Eric Dumazet <edumazet@google.com>; Jakub Kicinski
> <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Maxime
> Coquelin <mcoquelin.stm32@gmail.com>; Ong, Boon Leong
> <boon.leong.ong@intel.com>; netdev@vger.kernel.org; linux-
> stm32@st-md-mailman.stormreply.com; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Looi,
> Hong Aun <hong.aun.looi@intel.com>; Voon, Weifeng
> <weifeng.voon@intel.com>; Lai, Peter Jun Ann
> <peter.jun.ann.lai@intel.com>
> Subject: Re: [PATCH net 2/2] net: stmmac: move fixed-link support
> fixup code
>=20
> On Mon, Mar 13, 2023 at 04:01:35PM +0800, Michael Sit Wei Hong
> wrote:
> > xpcs_an_inband value is updated in the speed_mode_2500
> function which
> > turns on the xpcs_an_inband mode.
> >
> > Moving the fixed-link fixup code to right before phylink setup to
> > ensure no more fixup will affect the fixed-link mode configurations.
> >
> > Fixes: 72edaf39fc65 ("stmmac: intel: add phy-mode and fixed-link
> ACPI
> > _DSD setting support")
> > Signed-off-by: Michael Sit Wei Hong
> <michael.wei.hong.sit@intel.com>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 11 ---------
> --
> > drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 15
> +++++++++++++++
> >  2 files changed, 15 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> > b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> > index 7deb1f817dac..d02db2b529b9 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> > @@ -592,17 +592,6 @@ static int
> intel_mgbe_common_data(struct pci_dev *pdev,
> >  		plat->mdio_bus_data->xpcs_an_inband =3D true;
> >  	}
> >
> > -	/* For fixed-link setup, we clear xpcs_an_inband */
> > -	if (fwnode) {
> > -		struct fwnode_handle *fixed_node;
> > -
> > -		fixed_node =3D
> fwnode_get_named_child_node(fwnode, "fixed-link");
> > -		if (fixed_node)
> > -			plat->mdio_bus_data->xpcs_an_inband =3D
> false;
> > -
> > -		fwnode_handle_put(fixed_node);
> > -	}
> > -
> >  	/* Ensure mdio bus scan skips intel serdes and pcs-xpcs */
> >  	plat->mdio_bus_data->phy_mask =3D 1 <<
> INTEL_MGBE_ADHOC_ADDR;
> >  	plat->mdio_bus_data->phy_mask |=3D 1 <<
> INTEL_MGBE_XPCS_ADDR; diff
> > --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index 398adcd68ee8..5a9abafba490 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -7064,6 +7064,7 @@ int stmmac_dvr_probe(struct device
> *device,
> >  		     struct stmmac_resources *res)
> >  {
> >  	struct net_device *ndev =3D NULL;
> > +	struct fwnode_handle *fwnode;
> >  	struct stmmac_priv *priv;
> >  	u32 rxq;
> >  	int i, ret =3D 0;
> > @@ -7306,6 +7307,20 @@ int stmmac_dvr_probe(struct device
> *device,
> >  			goto error_xpcs_setup;
> >  	}
> >
> > +	/* For fixed-link setup, we clear xpcs_an_inband */
> > +	if (!fwnode)
> > +		fwnode =3D dev_fwnode(priv->device);
> > +
> > +	if (fwnode) {
> > +		struct fwnode_handle *fixed_node;
> > +
> > +		fixed_node =3D
> fwnode_get_named_child_node(fwnode, "fixed-link");
> > +		if (fixed_node)
> > +			priv->plat->mdio_bus_data-
> >xpcs_an_inband =3D false;
> > +
> > +		fwnode_handle_put(fixed_node);
> > +	}
> > +
>=20
> Now you're doing similar checks here and inside stmmac_init_phy.
> Maybe you could combined this to some function?
>=20
> Piotr
In stmmac_dvr_probe, the check for fixed-link  is to fixup the xpcs_an_inba=
nd
data. Whereas in stmmac_init_phy, we store the fixed_node info to
determine if we need to setup the PHY handle manually in the later code,
and will run phylink_fwnode_phy_connect which uses the fwnode variable.
The NULL check on fwnode is to ensure the functions that uses the fwnode
does not access NULL pointers. It might be difficult to combine it into a
function due to the way fixed_node is used.
>=20
> >  	ret =3D stmmac_phy_setup(priv);
> >  	if (ret) {
> >  		netdev_err(ndev, "failed to setup phy (%d)\n", ret);
> > --
> > 2.34.1
> >
