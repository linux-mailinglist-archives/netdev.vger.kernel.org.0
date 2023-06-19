Return-Path: <netdev+bounces-11896-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38C90735058
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:33:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68A3B1C20A1A
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57BADC150;
	Mon, 19 Jun 2023 09:30:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400C5C123
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:30:31 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27B8D3
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687167022; x=1718703022;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TNaEwKdQJiUYjG1neNmktezAwUqyzXLJDL4c4yAQjGM=;
  b=G6MV9bVEhtV1I2Pb8Ymo/727nTpd+XpzOyJpmdZjD2ZCwuxabaE7dpE+
   59JTvu8cE3d0N+jzgF+0tia3DlsbLvhb/p/2h4UdF6Eec+pzOo0IvaB+r
   qdMTeNDSGlWBk0kkDPD5tbKrww7wrE06z40aTVpgt/oIbv/4JE1ebU2Kk
   Cfj6p2kEVLgt8EGuioCjn8pyrIXfWWki0hKxOmT3ZufRwFnhqaT7wdvtw
   JDRTGJ0LAOGZXiHZVpksBWpmZAoqm06oacJiJ6O0omw1ewcZrw2a7lUT2
   8E8yxLNc9i+1mEnUJBr8ljNTT5/2HZw/ePNO/usc7Z6apo9hs41rH2K/7
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="339926243"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="339926243"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 02:30:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="826534720"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="826534720"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 19 Jun 2023 02:30:22 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 02:30:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 02:30:21 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 02:30:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FHd9DYMoRpfH4/gkxS286zEa9AoWQ/DFtSvW+th9ha+ZJP+IaJhJWO+tW2SafXoM9kS2djIkejBtRWEDa7p7JchFe7pvsEAad8pmDX/4gFsRvYEyRIlCyva7NmmuKgAemGxxH0WoS1CVGaVwL73a21r5bpOzTWd6vLG8N4hwvpY3Ry82t9ahrt5dIAz48s0EVpg81D+oZ2uikIHoJSlt70iI0lZtM/2Ks/4QPkHSZM3IOpLpP7asx+pOXQ9gdIx559lJzqNBQTTq9CTFDYwsci+t4aarod+vezqmp+gkw1vcPkGePzFoea7poXHNGx5E+4dp15VcbwTnf/TH/nEB6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qC4v41vgyqb9vrfXMZvIXTMGdfxbjNOlF7umKXgk7Uc=;
 b=YK7UGotmTGeuLMexVlKwuSu3ZcE0VML00QTTI6MXCGqOHCOoOVrzh8BdVMSldMZhLIf/J0k1Ky3dzbQWzYca86b73soKLanUC2yQgSknCGX3s3jp5QpXpxk15k+M3IrZyEQbvtAcyZl4HmSMhtQDzbUeZFUuB3yfODwmyo/Db0fowZbjGGH7D2Rr5+XW/stQ+pre7/gYTBXYExKjOaUiXa0tHdvUehS8qrbnk3tUoJiJp+DHp6WCfrMZCvVSDWVNJ/y6E3kxX+n0mkc820X4HQUMMZQgQQ1Yn6HfKskpVz1NkAkjs1SQ1ON2XZDFTJ0NWjLqyRbGfQuvGfpEnqWKgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 by MN0PR11MB6256.namprd11.prod.outlook.com (2603:10b6:208:3c3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 09:30:19 +0000
Received: from PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f]) by PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f%4]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 09:30:19 +0000
From: "Buvaneswaran, Sujai" <sujai.buvaneswaran@intel.com>
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v5 10/12] ice: implement bridge
 port vlan
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v5 10/12] ice: implement
 bridge port vlan
Thread-Index: AQHZneAxJw+by7IPl02amwwMMsSMxK+R5X3g
Date: Mon, 19 Jun 2023 09:30:19 +0000
Message-ID: <PH0PR11MB50130A8128A4CE33CA808EA2965FA@PH0PR11MB5013.namprd11.prod.outlook.com>
References: <20230613101330.87734-1-wojciech.drewek@intel.com>
 <20230613101330.87734-11-wojciech.drewek@intel.com>
In-Reply-To: <20230613101330.87734-11-wojciech.drewek@intel.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5013:EE_|MN0PR11MB6256:EE_
x-ms-office365-filtering-correlation-id: 45bba3a6-4aea-4dea-2f08-08db70a7cc85
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1Em8jHZRdgP3EzjUXzGW6TnPGvMm2SqXbAeHO95XXGJRnbEqw6bbzCQgwngQv1eNO1lmzYAt2HQqbXMPUEo6jcvPcu+jfgSbzeL0t7kSFTyd5mDFXCetvH76hPsDiTszZ+NW4eJStEICcZio31X05Cc1uzaYbD6d5p1tNP4jUSI7dJPdZfChZ/TzXHbLqHli2ddixCrGKFuw3RQ22T6CK0POxJQHNlKnUeOxl5cJ3OE/UU01rQm1Tr667Ely5em3ZfeECsrgHJ2sTngvQ5fZdjJZtUiFMEX6OmaTaQ85p/0ByXZzVCE3bh2suk1Y+vDxHiTXbcRE5cpUU/LhihtJg4Ru7lPi3p0XK1iBP2xVudyXVHcq5pKAtbF2YoH+qzklybDvSyWRJ25cGZ0owERFBtglzgXxstEcTWPgJcZsPxYe2ig+PP8qJPvDvMZcqeA8EspyPddoH7paZAhzZk72z2w1OmPe6IGM17AjpKerKVWd2hzeOc6dagxjGmzU2rBfK/S0WBWKFSzMDY6ieAonuPJEy4QbFPFsH2IW7DvGPuH8MgFpX0mdT/xlbDiiRSBQ//oL7mkdnBDlClsYw9JDEQeIu8lw8SxXqMX6HEdap9J0vlrG0Oq3OXAhXGshuloH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5013.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(346002)(366004)(39860400002)(396003)(451199021)(52536014)(33656002)(86362001)(41300700001)(8676002)(8936002)(38070700005)(5660300002)(66446008)(64756008)(66556008)(66476007)(66946007)(316002)(82960400001)(38100700002)(122000001)(83380400001)(186003)(9686003)(26005)(6506007)(53546011)(71200400001)(76116006)(4326008)(478600001)(54906003)(110136005)(2906002)(55016003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kaPgUv9I5h6Y2JVYBo97knSLwn6EtMyfkml2Kjg8k0sUnW1kzCMwGdoaQI6u?=
 =?us-ascii?Q?2mROHx4qmDvrbMxOQAupFFfq0cvMTo0/rvh59xklf82CDiSrpIMCuLGyMgjW?=
 =?us-ascii?Q?ObrrGnkJIP5V9cQDQ+Zc8+UeR+yU/LFUL6BS47cyKBa1H9I0+GKYHAlQC9OU?=
 =?us-ascii?Q?XlscwkUQWqrWMwRofdD46BZnstr/DCTZwLLeAqtV7QUNICv4hHFvgrGULheO?=
 =?us-ascii?Q?KrD6kPJ+eJcUg6fWsUcoW6r5M+MVD3sWEYAUwbkfH8nUf1GMlAbnf2fEgfRM?=
 =?us-ascii?Q?qla5GIIh0bav34DwQOGMZ2lUI/U31pHDac85F0nM7Mm4U7YdDlrByIHBnYvH?=
 =?us-ascii?Q?nAIYglXn2LFPIYdnmZ5Q0DMW8iyfEiWN86xlAP0RC2n/d6lce03y6xDsL+TP?=
 =?us-ascii?Q?RtuD+cAyzoz4wsgvNMCCWA2MHIZNbMd0WZp+Akgk0ZXGYV5464B0BF2wFH9E?=
 =?us-ascii?Q?Q9S2jmLekbTr7ZImLqpjzZA1imcF3I8v6pc4BrouJUWknWvnSbMWVA+u4Sxj?=
 =?us-ascii?Q?qhJmqS/BcpUXNxZmfbtJ91dL2+JEy+nfEwy1ZwFeXaSoApS+R5qsT009TX/q?=
 =?us-ascii?Q?Y9zHM9WsXIZeLgTlRfQpDfdbiCGwJhPx/cljVnpPtJnc91e1BRsJ+d/ar+6s?=
 =?us-ascii?Q?7VM+zDrWIM8TJVTNbmoVLrPUujP5NHTOaO9LqVzsuetEGExC2b/OuJXUJ4q4?=
 =?us-ascii?Q?VjIHeSWj+XsEnZaz+E0eZ+GNhNR+PlrPOABHpdMVXu75yQc1uziRQwSfPhFY?=
 =?us-ascii?Q?/0xgIXa72kgVve0LrC+ylZnbgD/zeL+4DgRsvWqdlJw2YUFCvX2iMtQeU8c1?=
 =?us-ascii?Q?IAcET3XJH0qYu0U414/ilLg4zQ8gkhuIu2kPzShizxXq5OXubsY1hprtvQP0?=
 =?us-ascii?Q?U+Uwy3oVYaeFIlKpEt0Oex1tUdWjMN8iQ2wQjfaYWmM7UbfL3vsSIEyWsEQa?=
 =?us-ascii?Q?3PL6oFVCQpldFL72+IRH6qMlyQMH5hVHNRgmfg2mqmfLUYrHR3r/3o5toSSv?=
 =?us-ascii?Q?vCP4sRibUimAQMwm5+wX8TJdnIthkZN/lVWyPt/Sq37MCrQ5cqTE2lidnrVT?=
 =?us-ascii?Q?9/lnI8gUn//0NoiwvdOWlONYQ1oc0eLOeOehf5RkluiI8fIf4zSJgAbr/cVz?=
 =?us-ascii?Q?E3lqPm78K2YB7rPjnkYYJIZgnyKR8sn3JYZpBOfpgKG2BYSDGQ4gSy2JoKtu?=
 =?us-ascii?Q?PbZ7quhRiKVoPafZ7VAzeBr8CHkN6CVYJVKBeipI0YyDCQ80IjwKMi4ONSBC?=
 =?us-ascii?Q?m/R9YKLSZYhAqo9gNut/4raFn6RoItXJP4fXFYAe6as1ON89prlUqzhNbMoJ?=
 =?us-ascii?Q?G+exwJRNfJer22OaM/yctYSqihUUAchfgDQH0LNjsaYrcwdgOKq8oJm29LaM?=
 =?us-ascii?Q?on7s3HyeQ6Z4MUCu6jwj0n5l6NZJTy+z/0bJXd7njdrINfdkAzxm49teO8xt?=
 =?us-ascii?Q?bWp91DOLTiNqczyeQqdMZ6XVSmYvOkqLZ9c+0d20mLMe+LnPajBZbdiE3Gbk?=
 =?us-ascii?Q?1xaW72kq8b8O64nHBrpHlIAWJ1T7E69rCNnZDwm8BbPMR446uqJnKw7jIpVR?=
 =?us-ascii?Q?eEIUqiJexMFq+Z22ISJWqiYwic7+jpCFq0GXwMyRb2D/dUDaoR2ncoMJZhfm?=
 =?us-ascii?Q?mw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5013.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45bba3a6-4aea-4dea-2f08-08db70a7cc85
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 09:30:19.6038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mzzu9fVYy29Fnp5tVxDTuBArhes7Uh2i1gQNVllE2aeU9MC1El0HnsbeNYBHDtYq4hbRkCqtvYb5Z5Aa9pqWCpoPan2O2nJdCVquk4KyLsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6256
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Wojciech Drewek
> Sent: Tuesday, June 13, 2023 3:43 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: pmenzel@molgen.mpg.de; netdev@vger.kernel.org;
> simon.horman@corigine.com; dan.carpenter@linaro.org
> Subject: [Intel-wired-lan] [PATCH iwl-next v5 10/12] ice: implement bridg=
e
> port vlan
>=20
> From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>=20
> Port VLAN in this case means push and pop VLAN action on specific vid.
> There are a few limitation in hardware:
> - push and pop can't be used separately
> - if port VLAN is used there can't be any trunk VLANs, because pop
>   action is done on all traffic received by VSI in port VLAN mode
> - port VLAN mode on uplink port isn't supported
>=20
> Reflect these limitations in code using dev_info to inform the user about
> unsupported configuration.
>=20
> In bridge mode there is a need to configure port vlan without resetting V=
Fs.
> To do that implement ice_port_vlan_on/off() functions. They are only
> configuring correct vlan_ops to allow setting port vlan.
>=20
> We also need to clear port vlan without resetting the VF which is not
> supported right now. Change it by implementing clear_port_vlan ops.
> As previous VLAN configuration isn't always the same, store current confi=
g
> while creating port vlan and restore it in clear function.
>=20
> Configuration steps:
> - configure switchdev with bridge
> - #bridge vlan add dev eth0 vid 120 pvid untagged
> - #bridge vlan add dev eth1 vid 120 pvid untagged
> - ping from VF0 to VF1
>=20
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v2: minor code style changes, optimize port vlan ops initialization
>     in ice_port_vlan_on and ice_port_vlan_off, replace WARN_ON
>     with WARN_ON_ONCE
> v3: fix traffic typo in the commit message
> v4: fix mem leak in ice_eswitch_br_vlan_create
> v5: create mocks for ice_vf_vsi_{enable|disable}_port_vlan in
>     the !PCI_IOV case
> ---
>  drivers/net/ethernet/intel/ice/ice.h          |   1 +
>  .../net/ethernet/intel/ice/ice_eswitch_br.c   |  90 ++++++++-
>  .../net/ethernet/intel/ice/ice_eswitch_br.h   |   1 +
>  .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.c  | 186 ++++++++++--------
>  .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.h  |   4 +
>  .../net/ethernet/intel/ice/ice_vsi_vlan_lib.c |  84 +++++++-
>  .../net/ethernet/intel/ice/ice_vsi_vlan_lib.h |   8 +
>  .../net/ethernet/intel/ice/ice_vsi_vlan_ops.h |   1 +
>  8 files changed, 285 insertions(+), 90 deletions(-)
>=20
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>

