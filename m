Return-Path: <netdev+bounces-690-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E34C06F90B4
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 10:58:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C99411C21AB6
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 08:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17F341851;
	Sat,  6 May 2023 08:57:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04618156EB
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 08:57:56 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7026D86BE
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 01:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683363461; x=1714899461;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3sbi0eAi0gQ09FFkHo1xDfJJ518n8uVglG5zcobbpU4=;
  b=MnyVg0d/lllYfuoZ4VJor7CcDwbasaPJHlSyC9aK58h95crTLsWRiV+D
   /BH0g467WEVmZHj9gh95fI/ZLsiP035A0m94PQ9qWa+6xDCYNnR7tZq2C
   +bW9uAWUU0XDj6TrFz6cElGpGkcv9l2CVT/q2p7eBx71MCi9J9N6dubNd
   BMk3ixocsKw+uqhwpairGENV7nVE1H77w5hj4GkazP+3WvHXtj2s18feL
   15ZXXPJQNY+KjiI5X7zFE7TMMbeAZ6P8TJ2rh1qszfHqSMNeton4x5QCd
   FUAqLS+3odsU9oryuKwMbZ3d2VnlCfgxdcRS2FxEx4UCmlScZk6ToXTvn
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="377445123"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="377445123"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2023 01:57:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="944214614"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="944214614"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 06 May 2023 01:57:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 6 May 2023 01:57:18 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 6 May 2023 01:57:18 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 6 May 2023 01:57:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FExa5gawANRfgeREEi0HDihO97/oYEx8IZjc65nPxAjFufQ3ElWd/g1UtTU3RTuoVxVHKH5hRz7v74T0y7NfKXyGBFKuPwD9LSvTcoK4JCkKH2seez9UpZCYNQyvLyfHEBk6KL9tRpNcY7W1/VIJq7T5yBvyBcZtb/SSbpe96YqnusToO7ZJo+BjI6aCGgN76tAcef6gxeR/vELCH2hK1nGHEJ0PFPVv0oQq1zxDnUx4I69ImMwpnbveAwnmL860f+Vyy5VMjF6bLod9Tz7wyhcJkrRuPjL8GPwHvO73h8eHjvXrqg6vUvmfIFxGMWgYNbnt2W95tcsu1y/v6S0Kyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MZcjDStAKRL4G1f8T16BnJGD71ftHQFKVcVbe/j5CnI=;
 b=E5WX6WZ/J8FWpj6McLRVFThRf1oqho9MgJ21d80bJuHMv1ySCthB6ZwVN7FJisTBantCcFayIMS4InslmoyfbfkyTbnuubnUol5pwamESroqMPN+bPnITtONAYGg/H9KUe7uBJX4VuqtdzkOc3Z7RkZIWvF7F+WptFT7mw5Yt6OWp5xQ5sbqBCIAfqr1D2tb6+YG9cao+NCVpsbVgymfhKYuMgRtpi1eqT0SEEwdPpl9V5im7PrSpR9POrXR8unA7jqpcQWdUe4n0Ezj2QVvF0AvLsMEKQmmKi5T3cRLvb/h/nstRGpxvTOXoN7n/hYnfQNYwDI+1+UfH+uv7kLQVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by DS0PR11MB7632.namprd11.prod.outlook.com (2603:10b6:8:14f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Sat, 6 May
 2023 08:57:15 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.029; Sat, 6 May 2023
 08:57:15 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: lkp <lkp@intel.com>, "edumazet@google.com" <edumazet@google.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>
CC: "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
	"oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>, "Brandeburg,
 Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh"
	<suresh.srinivas@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>, "You,
 Lizhen" <lizhen.you@intel.com>, "eric.dumazet@gmail.com"
	<eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 2/2] net: Add sysctl_reclaim_threshold
Thread-Topic: [PATCH 2/2] net: Add sysctl_reclaim_threshold
Thread-Index: AQHZf9Nvy10ziUezSEi5MxYtTo52SK9M4tgAgAAOSIA=
Date: Sat, 6 May 2023 08:57:13 +0000
Message-ID: <CH3PR11MB73452A7E39E98D78433DC58CFC739@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230506042958.15051-3-cathy.zhang@intel.com>
 <202305061521.bAXb1ha9-lkp@intel.com>
In-Reply-To: <202305061521.bAXb1ha9-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|DS0PR11MB7632:EE_
x-ms-office365-filtering-correlation-id: 4f2e7e19-26f6-4a0d-af4b-08db4e0fe2da
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2ZjumqFvsunqf43RYPzWP8x10CF1QuleQLsR/PebiwaXBQ+3dlw3NoidYhPlpFOybXvrHz7tVoe4MIKiiC/0WnmiJDo2eVkKDBjWq8kxBndscG5sFnmepiobd+8c4ZYDSnuFUyr2pRMbs5cyT0nXxbRIatNMJQ7zA8IZWjbEok35KFEZyBkApxms9TW75ha/BI5ZOWX7UZ0kdrHF61Dv7+MZOvyWNQeAipArLTWWUEQ5i5bXaP5WCLTFt8cD4enB/1sm8pnW6xWShgwSowcONES9AG2ZTUiuPWc3+MhAe5kiQZLxR0XLz8/gh1qq/rq8E0a5Jm5eI+ANTuhwsWEru5/pj4em+jmhmwn+sWFiJ/dRkXjXQH/OCKGX7tzqgYKGFHPEP+oXE8yLmgrmbiUTvPrCtGiD0Bxj1R9NM/cU3XwFVJN6iclno6+5iecap9VsbaeGkWg05oTdsEWMe4imLCgcpHMbocHy4Fb2R6HDP7Boy+B48qts6Y71K9l8agIhYvJE3xZi8jOdd7ZAyiVxcPM6XLWCqSNDm2trez293ayNDx1fFLnJBWAshFi5VMMT0sWIZLwQd6rH+o4W19Gb5RkWQ/GDTjaGoWvujuXpgrJQERDViyce2XzxlRLaBDMD3khIz19oFeLHGDv1genL9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199021)(316002)(33656002)(41300700001)(2906002)(186003)(71200400001)(53546011)(86362001)(110136005)(6506007)(7696005)(66446008)(64756008)(83380400001)(9686003)(76116006)(66476007)(66946007)(66556008)(4326008)(38070700005)(54906003)(55016003)(122000001)(82960400001)(52536014)(8676002)(5660300002)(478600001)(966005)(38100700002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u1IrXxQ0Rcjx5EIlMwaRxZdcexgTKqnvXWaWjiMArcye2ohoBC1YwQm6mGRV?=
 =?us-ascii?Q?/wX9USTJ2VUhzRjUhACsiA/IuJHrgCAKzRN7MPsl0TAwwYCpVTMo+HbIb75y?=
 =?us-ascii?Q?xxzzSus1olRh16aoJHR4oxoCG6U7kEcUj7AdUcXFud3blz+mvLbbRDJ5zB1C?=
 =?us-ascii?Q?nTBXpsR595VdDe/T9Zq45QHtoZoAkGSY3QBBcjtQknt7t2OhCe7CzJkcY5K3?=
 =?us-ascii?Q?98D0clp8KQPqcU3DGOno99N8n+NeaAPl92bLgemQo9XJX/DnJ4HEXEVHl4+t?=
 =?us-ascii?Q?+0ZR07CzgUieFC6y+yVkobTp3Jk4UgTSWVlmuAfOLDIFfHZzm6X4f2rQRGlR?=
 =?us-ascii?Q?2+uGL1G5ecZ+OKLzjhu1NGNFrh4ff2mbeFxXGsB76bjUMQ0Oi+uWI1OglEiJ?=
 =?us-ascii?Q?85OMx5FQ2ThYoHZY/DueHnWx5lwvt/tZFVPD0RWceFC1+knhu9REkCdLLQR+?=
 =?us-ascii?Q?xQM1WHq/jLjR2Pgwmee8FkuBGRDmXH+yd4wjX4w0cULiTioSe7GpIsBamymy?=
 =?us-ascii?Q?8vkNEAzFYo8umdLRlfpWYXVBSuAj4IH1KdiPBECyFBw3qZJVRURsTbscbL+0?=
 =?us-ascii?Q?sV8pmNnuAdDikGwLvJ/diWwXJsv44+Ndle+x7YApK4aXSiYtZAnZDpYZo+21?=
 =?us-ascii?Q?ovnjCKGKh2RrcPkua2MJe4+FZShxoY1QTQFDCpieYBoKSb4wkZBFf2lI+Uy/?=
 =?us-ascii?Q?ufg/7ksEsvvM7a62k0O9eS5RGvJU/NOqlmbMWHB7IHAmG30MhU8f1cnrZ/qK?=
 =?us-ascii?Q?bZBIQemNAbn3GcfoB+P555k9/1NL94S/cB73+P3xMaEdCVcLDcoXTjVqGYhA?=
 =?us-ascii?Q?8yBU+hWHtMt5dlQjBUggjQXKuBo+FJt97h4+jPyFWCwp29UqaYlIIxcMfNo1?=
 =?us-ascii?Q?kN0Tznxn0wQa/hcW0idVkgI81D6UgheZvP217k7s0206ipvNzcBVd9G6lFEx?=
 =?us-ascii?Q?jzO+8d4yyb1hLGa2OPTa9krB5chp553gDcosCQ8Wjb4eiQwV5zxQQg5BRs95?=
 =?us-ascii?Q?bVB15aD35KcevI1KNOpmQ4sTAlb77sWmMOLxcl203BBW04Hwan/tPJsulZXs?=
 =?us-ascii?Q?vqohO/K/90j0c59Hud20+yovCBduwVyzkjXvsvK3q50U6YCRYmhptoBATW5o?=
 =?us-ascii?Q?ZagwJFDz8Wv3J6VcvI6ZLW4y/X4Bve5LZvnSrz5elCbIAoWayReRX4Bx2SW6?=
 =?us-ascii?Q?Qu4BH6nqzRcWWsT9A8yCtApSe1bsZuDV2fm/lZqQQj/ffl0vgEuQiraJtBhb?=
 =?us-ascii?Q?qgCkFPCMBJaa51TFsqSlaY80b/3lHU2yU7TA1Ozni6KVPLbDa2E7mo83zZEt?=
 =?us-ascii?Q?E7aNCGGMUTAyQ4n4sesRN0VQjGCVdeabCaxOYIyPb0JUU+X8C7IbD+jcbzds?=
 =?us-ascii?Q?BBLcw34FVJn3ETV6C4Ciw9bKVVCF9e4PLc+BUHQ/tdqs2DPEzZAfneC3AtUo?=
 =?us-ascii?Q?rpTpAJ80W1FjV6/Hmd/fpiN1J/k9oHWXp6/h2/hd+wti0geDwUgQzY30uDsf?=
 =?us-ascii?Q?0Ur/NIY5vmN+vp6tHLHpi4B6tvANcp8mdkZZgTXvv8DZE95IbaszHEQ4f1j8?=
 =?us-ascii?Q?6fhLA20F4nuz9pu402Y=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB7345.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f2e7e19-26f6-4a0d-af4b-08db4e0fe2da
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2023 08:57:14.0204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IUunj7TH2HYJIDsvTHmmBuLCtVhQreApIZoa8fisImGcGkScVn9vNmjr2BcO2yYD0W6suC5mBOUfIhQsajoVRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7632
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Yep, the patch is wrongly applied to tip git, sorry for that! Let me rebase=
 it to net git and re-send then.

> -----Original Message-----
> From: lkp <lkp@intel.com>
> Sent: Saturday, May 6, 2023 4:04 PM
> To: Zhang, Cathy <cathy.zhang@intel.com>; edumazet@google.com;
> davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com
> Cc: llvm@lists.linux.dev; oe-kbuild-all@lists.linux.dev; Brandeburg, Jess=
e
> <jesse.brandeburg@intel.com>; Srinivas, Suresh
> <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> Lizhen <lizhen.you@intel.com>; Zhang, Cathy <cathy.zhang@intel.com>;
> eric.dumazet@gmail.com; netdev@vger.kernel.org
> Subject: Re: [PATCH 2/2] net: Add sysctl_reclaim_threshold
>=20
> Hi Cathy,
>=20
> kernel test robot noticed the following build errors:
>=20
> [auto build test ERROR on net-next/main] [also build test ERROR on net/ma=
in
> horms-ipvs/master linus/master v6.3 next-20230505] [If your patch is
> applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>=20
> url:    https://github.com/intel-lab-lkp/linux/commits/Cathy-Zhang/net-Ke=
ep-
> sk-sk_forward_alloc-as-a-proper-size/20230506-123121
> base:   net-next/main
> patch link:    https://lore.kernel.org/r/20230506042958.15051-3-
> cathy.zhang%40intel.com
> patch subject: [PATCH 2/2] net: Add sysctl_reclaim_threshold
> config: mips-randconfig-r033-20230430 (https://download.01.org/0day-
> ci/archive/20230506/202305061521.bAXb1ha9-lkp@intel.com/config)
> compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project
> b0fb98227c90adf2536c9ad644a74d5e92961111)
> reproduce (this is a W=3D1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-
> tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install mips cross compiling tool for clang build
>         # apt-get install binutils-mips-linux-gnu
>         # https://github.com/intel-lab-
> lkp/linux/commit/24beb0b9f6d299a34b853699e5bcaa28a74cad5f
>         git remote add linux-review https://github.com/intel-lab-lkp/linu=
x
>         git fetch --no-tags linux-review Cathy-Zhang/net-Keep-sk-
> sk_forward_alloc-as-a-proper-size/20230506-123121
>         git checkout 24beb0b9f6d299a34b853699e5bcaa28a74cad5f
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross
> W=3D1 O=3Dbuild_dir ARCH=3Dmips olddefconfig
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross
> W=3D1 O=3Dbuild_dir ARCH=3Dmips SHELL=3D/bin/bash
>=20
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Link:
> | https://lore.kernel.org/oe-kbuild-all/202305061521.bAXb1ha9-lkp@intel.
> | com/
>=20
> All errors (new ones prefixed by >>):
>=20
> >> ld.lld: error: undefined symbol: sysctl_reclaim_threshold
>    >>> referenced by sock.c
>    >>>               net/core/sock.o:(sock_rfree) in archive vmlinux.a
>    >>> referenced by sock.c
>    >>>               net/core/sock.o:(sock_rfree) in archive vmlinux.a
>    >>> referenced by filter.c
>    >>>               net/core/filter.o:(bpf_msg_pop_data) in archive vmli=
nux.a
>    >>> referenced 15 more times
>=20
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests

