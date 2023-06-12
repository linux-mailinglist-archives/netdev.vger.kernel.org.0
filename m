Return-Path: <netdev+bounces-10187-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71AA072CBE8
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 18:56:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C1471C20A83
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B961619BB1;
	Mon, 12 Jun 2023 16:56:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33BD17AB8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 16:56:23 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B88B1B8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686588982; x=1718124982;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S/HBfDReZ3Uhol0ZvQnE2tGiyXnKcgNmjvJIuAVIDb0=;
  b=iGQOF3oNAv6i8EAJIEi0olCkdqFVczPOZfx4rJ8q+NZzsQUsylRdYWXJ
   6LsKJBJXxQeFY6La5IWDP7l3lkb0PFtxZgaBOLBmzjhy0cpXG6UXaH6+G
   03/DmsGSJL9neMOo54llieFLi5M3LSwThACAwsJLAA9QFtuJlH2sGKrtQ
   QRkcdW+Cf7mkwncKVSvsZDDjS+z0WIUhnAEEKywglVHLRQRxsvV2O19d0
   kMe8idBhcU26O3gzihYCiKonsN2ZfRkKAXc3yxVDRXzXSvHnqYAgLwMfh
   Fy3c9axbSThnw6QtkLYR6qNN62CTFQjnb+jTcJ+r6ac8CIHjKyQcEomQm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="361466284"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="361466284"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 09:56:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="776464918"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="776464918"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 12 Jun 2023 09:56:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 09:56:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 09:56:20 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 09:56:20 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 09:56:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eja+c6L8Nxjw0PMisj+KkCXKiM684+wiSoSPkuUuKSiDgopAFCfTX52LKtxMAf2TCjCNE9ZB0WyvBdJ3kEa4DRJmniIn1hitOzIWZJ0Ud3D9Lw38y+wFqLRCYuHVvZoxKyMFMfIjqJzpjzUU0c3lubcOJD0y1c9OgBB7KgaAghV2T5+qcmXv0T+VZCAdBv8s4ot5OJuPMqFa2LTm8af1nY1ED+qCUblrQsB31SkOBFf11jRF7mrJx0aTcKJIKaJ7OivE8sewyf0+aUH03+S5fWDsWO0IF2muKr5XXT+Q+5qXkp4HFkQHJNVbXsdRGbCSYC4wxPdyEXAHA/Azb5FDgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hnis66yyB0CkNfbf7XxIh+1ofJLmE1LqO5F8GY4iwlw=;
 b=AFYfcWKlDDNMVQq/45U2dC5NrcV6NxroLRTpraBFpI2Rt+HZswnim71RrDeDHCJEIxjTG7IJg6HnCM15lDDegKlIDHwYDcj3z3PhysXg5m549BtxL8P5TLRaT5PzKW82hXdbZHtSoEzEdabtTa8AhuZXWkJ2EVS+zFffe0JvNSDONX/KTYOuBEONMjiJD0RVoyu6nHhKWWiuO5PgeRIAhUa9mQth4OrXZpPsG/sNXSwPvejwLNl3pStpu3wFfNhnh6rXSDr8/LP3ZUMyVbUEz+jZADf3RGbTvBx12tWWJX4ks1IijwO3nQZ55jKWLUfm04ZYQcF/t4EbJcGn8tEGeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW4PR11MB5872.namprd11.prod.outlook.com (2603:10b6:303:169::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 16:56:17 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::4e5a:e4d6:5676:b0ab]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::4e5a:e4d6:5676:b0ab%5]) with mapi id 15.20.6455.039; Mon, 12 Jun 2023
 16:56:17 +0000
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: Jakub Kicinski <kuba@kernel.org>, "davem@davemloft.net"
	<davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "edumazet@google.com"
	<edumazet@google.com>, "pabeni@redhat.com" <pabeni@redhat.com>, "Kubalewski,
 Arkadiusz" <arkadiusz.kubalewski@intel.com>
Subject: RE: [PATCH net-next 2/2] tools: ynl-gen: inherit policy in multi-attr
Thread-Topic: [PATCH net-next 2/2] tools: ynl-gen: inherit policy in
 multi-attr
Thread-Index: AQHZnUcXb1jU5JCNEkuq5U/pMpZzt6+HYunw
Date: Mon, 12 Jun 2023 16:56:17 +0000
Message-ID: <CO1PR11MB50898B43A85AFA3ABB99E365D654A@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20230612155920.1787579-1-kuba@kernel.org>
 <20230612155920.1787579-3-kuba@kernel.org>
In-Reply-To: <20230612155920.1787579-3-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|MW4PR11MB5872:EE_
x-ms-office365-filtering-correlation-id: a7157418-edd4-4938-05f8-08db6b65f05a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XQFe8YLR1zRSr19v/xxOvkJdqp2hNE3tjQ5QrthsiAskr6Jsgot3VYb19wEPsy5gXxoaKYXWQlFhjdXjmot6FBGarn4DWGb0GnCNTO35MV3Rgoxrs3D8fPMrc4e5b3z6Jj7BvvBdt35eaLsF92g4prYyeFxJMc9u3fZffhsznRDjzyMPb3mBLNvEkvb1ebOvWvojv7pfedZGqU64WNZgRovnCTXdNJTsqnpK/WySNWhE4lmRsyg+bVl3kqMfq6N7yLcinjVHg96Gn922sVRaZCzUifLZXveOj7e/IoIi2GqvuQqY8ZD7ApW9mepIhWeO0oW3dWjY5ps2B4qiO3D2PNTf/Nk9VEWONIiHNABr4gVkXY3IDg7CKh5vBrj+44463qFNQw/IRPm7IQ7HC0Xi+QAcJPXCLgWwRdWqWi/IKSSrDIPi4WjvY3uQgdYbA2i+MUTGBaxSyJ4fI7qWbmYx0+BYYtrNfZCqzVgKdfNd23xI2hnZMixdDDS3h5Ud9eBXbMxwTipEtx3VC3pafg15MU9Y/IoWx3CGDvoHfupZAlZ6o3jyLVwXuPsH4C1W1aHDTYjrjnBV9+ZaaKbi77YHzoTC+xVlqK6uZdZ3TzJSvZ9lI6EGPv4PqaCkjy7RUmEJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199021)(316002)(7696005)(41300700001)(83380400001)(53546011)(38070700005)(9686003)(26005)(6506007)(186003)(107886003)(2906002)(86362001)(33656002)(122000001)(82960400001)(38100700002)(55016003)(8676002)(52536014)(5660300002)(8936002)(76116006)(66476007)(66946007)(66556008)(478600001)(54906003)(110136005)(4326008)(71200400001)(64756008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mQmlrfaQeqFezz5C81fTiRkadhwZ5vVXZdqWAfNAKSvzM2s/L1SXjxx7oYT+?=
 =?us-ascii?Q?g8gbgXXEAjcFQoh6JiJ+TzkvuMLG9WnlR9bMmKyK3c5uPJKn191tGG1WEprm?=
 =?us-ascii?Q?UTljE1frl1wwFxcb7+Bh3b/NARDs49gJTBj//3wm1GU0KSnZOjVo42lfgqJK?=
 =?us-ascii?Q?XT1VHVIq02UYduMGGXvnfPIphkgT3hqMuvATHlwwT6kGIaDmtIY+KFtP9Jk8?=
 =?us-ascii?Q?1leYcFvgZ/5Ir0aaRb/TjMRmNH/8rJ8wLZYrnyezKvRTlmeuL+fch2MJFqE6?=
 =?us-ascii?Q?uAOg47cKZ9TmMTZZ8lLmuimlZdkI2awJB5rIk1MIFDXhBw5dyGFVGjbo85mj?=
 =?us-ascii?Q?+MzUUuF8fxOzNslul+V9BXU3DVs2OK6J4AHNN9ciXkBkD5SotP4DCAvSNnxS?=
 =?us-ascii?Q?e7xi1DcDjtB9nGkNRopB+H2uy2tjh5cXarKCKPu92hvJOKsJFH5jIXrBGW4n?=
 =?us-ascii?Q?QtbjTE9ENGQ2ztQbxDz/DUkbaFll8NOmUr2gi3nKL0FvQvGl5Swej4yVXSsr?=
 =?us-ascii?Q?zE3RRRGnnUQpIqamlLn4Jvana8Qb/Z8tAFB9CrNrnFVwwp+xaqKBsCG7p3Q8?=
 =?us-ascii?Q?+8x9n89ggJ157cDRdJhnFkfyLhJ5efN3Hmmk8R213Pm2IBGGYgXbbYNqnZ06?=
 =?us-ascii?Q?+HyBU2d2HxDbwefJC4oXNtlFwJiZ7dhXZ+oV80nT4bL6yoxdgFXgPC8zO4XS?=
 =?us-ascii?Q?ysjtJg61yjkO9aPcg2Jl64VZr9Jod/wcUJr2kZWQYAsNuxdSY4rjov4fwIfH?=
 =?us-ascii?Q?tRc9oDmPDTWjRmv7PaG1kPE5AE+sWez7k0n/yOOBwwhvcEtsR1CLXcce0trV?=
 =?us-ascii?Q?wNkhgKkCrNeUzzYwBXksIZZvh9WWqcj/NzLS2/9yw4lISxLir9y2dXQIhnle?=
 =?us-ascii?Q?/BMnKWVMoCOTLh2VOYL78pm6t/D5T620DyvSvvkEwPfBORzTg+OrcdE2hhFX?=
 =?us-ascii?Q?NSuvQVzSq3K9KDX0rp8Ja14wuE6Y7BnmclXipULZ6n36BZTngGyjs94z/5fD?=
 =?us-ascii?Q?vjLgbUVso6kg3AQFf/uedWcrtCsn+TV/25pOwdBdnNCqHTmwowizXSjWMGz6?=
 =?us-ascii?Q?quI/E086ShvygV4XwIRsh/fSm2aIQmr+PFS34dDFH/sM0+8OTP1RLO7rH34k?=
 =?us-ascii?Q?cGSObVekxaayVnx0EGTr+IWurRNeRmcRYAZvrJhsVBUi+CV4rvvlELI+ZvTv?=
 =?us-ascii?Q?x2hoNMJK5O/3PQBnQwYFXczTxD75sWA04ZY+OQ6CER1pcND1yPnXCfh4k9MP?=
 =?us-ascii?Q?1a9dljTLvLCXP9UlSHh6UHP6C8zFoTc1HutlWxORolKB0HYvXx2YyFts67cU?=
 =?us-ascii?Q?Pv9wlFzwAzShAC9lxDv4yGDx7yvE/pQYYOJ6doV5Z7t0GwpZOrpBDVtU5e/D?=
 =?us-ascii?Q?SFjRQlXQ7YZmjG093ij6VRXjn2gdgq5B18CHAIIpvXStgasGeYUeS+QsfV0w?=
 =?us-ascii?Q?DARFpubjreXIzr0nxQbYvv5uZqGl4O5QHe66d/9K6+7AJxmnPJ9f9NnUHAqh?=
 =?us-ascii?Q?AHH4ph3UzzjG3PSfuhmaAxdwEqgdwUjd6MGpcdj0aduXmEPU2yhvwQ5b6wLW?=
 =?us-ascii?Q?ZYaDFzuAXHvAa/QtCvaKdOhvUT0hev3DAgQWc0gu?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7157418-edd4-4938-05f8-08db6b65f05a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 16:56:17.0996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rosl4h0Fk7ux6v0jDfm3e0S+zh+ZP2U8nV1spFA9pVckt3m5BT8pDRSEQgXjC7+0rCr+Xgn6CXA2mO7KGcpyOk6X/PQh3Uk/z6uqsmjTFBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5872
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, June 12, 2023 8:59 AM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; edumazet@google.com; pabeni@redhat.com;
> Kubalewski, Arkadiusz <arkadiusz.kubalewski@intel.com>; Jakub Kicinski
> <kuba@kernel.org>
> Subject: [PATCH net-next 2/2] tools: ynl-gen: inherit policy in multi-att=
r
>=20
> Instead of reimplementing policies in MutliAttr for every
> underlying type forward the calls to the base type.
> This will be needed for DPLL which uses a multi-attr nest,
> and currently gets an invalid NLA_NEST policy generated.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jacob Keller <Jacob.e.keller@intel.com>

> ---
>  tools/net/ynl/ynl-gen-c.py | 42 ++++++++++++++++++++++----------------
>  1 file changed, 24 insertions(+), 18 deletions(-)
>=20
> diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
> index 54777d529f5e..71c5e79e877f 100755
> --- a/tools/net/ynl/ynl-gen-c.py
> +++ b/tools/net/ynl/ynl-gen-c.py
> @@ -462,6 +462,11 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr,
> SpecOperation, SpecEnumSet, S
>=20
>=20
>  class TypeMultiAttr(Type):
> +    def __init__(self, family, attr_set, attr, value, base_type):
> +        super().__init__(family, attr_set, attr, value)
> +
> +        self.base_type =3D base_type
> +
>      def is_multi_val(self):
>          return True
>=20
> @@ -497,13 +502,11 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr,
> SpecOperation, SpecEnumSet, S
>          else:
>              raise Exception(f"Free of MultiAttr sub-type {self.attr['typ=
e']} not
> supported yet")
>=20
> +    def _attr_policy(self, policy):
> +        return self.base_type._attr_policy(policy)
> +
>      def _attr_typol(self):
> -        if 'type' not in self.attr or self.attr['type'] =3D=3D 'nest':
> -            return f'.type =3D YNL_PT_NEST, .nest =3D &{self.nested_rend=
er_name}_nest, '
> -        elif self.attr['type'] in scalars:
> -            return f".type =3D YNL_PT_U{self.attr['type'][1:]}, "
> -        else:
> -            raise Exception(f"Sub-type {self.attr['type']} not supported=
 yet")
> +        return self.base_type._attr_typol()
>=20
>      def _attr_get(self, ri, var):
>          return f'n_{self.c_name}++;', None, None
> @@ -717,29 +720,32 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr,
> SpecOperation, SpecEnumSet, S
>              self.c_name =3D ''
>=20
>      def new_attr(self, elem, value):
> -        if 'multi-attr' in elem and elem['multi-attr']:
> -            return TypeMultiAttr(self.family, self, elem, value)
> -        elif elem['type'] in scalars:
> -            return TypeScalar(self.family, self, elem, value)
> +        if elem['type'] in scalars:
> +            t =3D TypeScalar(self.family, self, elem, value)
>          elif elem['type'] =3D=3D 'unused':
> -            return TypeUnused(self.family, self, elem, value)
> +            t =3D TypeUnused(self.family, self, elem, value)
>          elif elem['type'] =3D=3D 'pad':
> -            return TypePad(self.family, self, elem, value)
> +            t =3D TypePad(self.family, self, elem, value)
>          elif elem['type'] =3D=3D 'flag':
> -            return TypeFlag(self.family, self, elem, value)
> +            t =3D TypeFlag(self.family, self, elem, value)
>          elif elem['type'] =3D=3D 'string':
> -            return TypeString(self.family, self, elem, value)
> +            t =3D TypeString(self.family, self, elem, value)
>          elif elem['type'] =3D=3D 'binary':
> -            return TypeBinary(self.family, self, elem, value)
> +            t =3D TypeBinary(self.family, self, elem, value)
>          elif elem['type'] =3D=3D 'nest':
> -            return TypeNest(self.family, self, elem, value)
> +            t =3D TypeNest(self.family, self, elem, value)
>          elif elem['type'] =3D=3D 'array-nest':
> -            return TypeArrayNest(self.family, self, elem, value)
> +            t =3D TypeArrayNest(self.family, self, elem, value)
>          elif elem['type'] =3D=3D 'nest-type-value':
> -            return TypeNestTypeValue(self.family, self, elem, value)
> +            t =3D TypeNestTypeValue(self.family, self, elem, value)
>          else:
>              raise Exception(f"No typed class for type {elem['type']}")
>=20
> +        if 'multi-attr' in elem and elem['multi-attr']:
> +            t =3D TypeMultiAttr(self.family, self, elem, value, t)
> +
> +        return t
> +
>=20
>  class Operation(SpecOperation):
>      def __init__(self, family, yaml, req_value, rsp_value):
> --
> 2.40.1
>=20


