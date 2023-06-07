Return-Path: <netdev+bounces-8699-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CF837253D3
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:04:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B3021C20C7C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6035D4694;
	Wed,  7 Jun 2023 06:04:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE8C1385
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 06:04:06 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5021D83
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 23:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686117844; x=1717653844;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YiF5FO9GFj1+cPcjvGQ8Bt3XYcgUoe0k0WZ0HqE/7/Q=;
  b=dbvJc1KJgms58tiOnx5yvrT9ul/XziXWzrwGjW1o/vk/OR1Ku3op7q+s
   Bh0RDCJlACWKn6TJPGjyAG9k1a3dgNcgPllbJDJd9/vRgjK5c5UsUp4vv
   bdD//yLniTWKfPY9zoV0emU50TLJMfoFvyTyBG0zTJGVr12lLTxOO60FS
   MJB6B/WPjVnyiepublnzLT+dHnYz/LNK7ghv7OVYNKsZsAK3M2iHt8Ebm
   CMYrakSmVI3goyhd/ABIybWpWFtVAr6sN7IDjfz8icXtwURZ7PRgK6edQ
   GklTKRE/fEa82TLmm1uxsi6gLUzH+WwieCU/LelGQBosvLPgVEgp3Yccj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="341549879"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="341549879"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 23:04:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="686799772"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="686799772"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 06 Jun 2023 23:04:03 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 23:04:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 23:04:03 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 23:04:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JflBh7wvttBv8/bFrmJt7cpHY8xagunkNbwCSKtsxMHROvk1BVCxsQ02MPYpYTYOOHNf77XiX7C36sqdWJK1Es8o4zE8IgPCuDogwhx7OHge9t8BOLHZUBvnPv7eWil0fcZmPY/pfC0zvlc4rwtDOA7iW8H4EC/bzsYS68fS1NNu0CkdR9bttYXykdeyMgpYI7ol83oYR/FpbeAcyTa3oAEQVRR3rV8W22TPi5k5D8EhQKNyRZ+ElUY+aP2SqUdwVckdAB2ZJPD/oRfMv/iTwaJBMbiZHAuFSRh8Ml91WpjP29tUW+XhrRyD1AjiJbIWyJF4FAFQL3hNZg4THk3HBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDeIdJlo6aV0w+UbzwUPmKBGN1kuUhiqZK+hlasrFQs=;
 b=gxp9xqZ8qOiE6FCuC10tFO+evYVDXloVYzLb/wTBloMrVAu6G71nAarWBuVBKxbMpJgsQVZ+C9D7CQjj1iSXpt0TZ0iPRFK2n0Rg4WtmcDn26sj2J2TASRE7QbIhIpFEVN2W0XXAWJgWz0c87we/W1VEQaVOdijQo02sPVGBAsOvxCl1C3gXDuKfj53M0TZsjSg69aan7FcZtcLRuF2ErNeHANqvA1eV9HN8135+aW2mB4x1nMt4rphFibMuI4TEkqVkOqMV4348Bo7TbBu5PC8R8gyLgkRucHtKcaw0e4LV04H8lb5NFoYOUqIR3sf0psIpL995Zwl3YdD0rZRKsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 by SN7PR11MB6946.namprd11.prod.outlook.com (2603:10b6:806:2a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 06:03:54 +0000
Received: from PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f]) by PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 06:03:54 +0000
From: "Buvaneswaran, Sujai" <sujai.buvaneswaran@intel.com>
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v4 06/13] ice: Implement basic
 eswitch bridge setup
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v4 06/13] ice: Implement basic
 eswitch bridge setup
Thread-Index: AQHZjjqnNCBU0QizWUqPXWyNGwikDK9+7w0A
Date: Wed, 7 Jun 2023 06:03:53 +0000
Message-ID: <PH0PR11MB5013314B6B561E5FD04D85619653A@PH0PR11MB5013.namprd11.prod.outlook.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
 <20230524122121.15012-7-wojciech.drewek@intel.com>
In-Reply-To: <20230524122121.15012-7-wojciech.drewek@intel.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5013:EE_|SN7PR11MB6946:EE_
x-ms-office365-filtering-correlation-id: 9dbacf10-b129-4cd0-6763-08db671cf913
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZuHgeB6pebWhyDqAGBEsVwJk8sR4K2us/eP0cEQpU43Vm/cT4NMgTwgUu8XVluXexoaPSPwO0wcnKgSCon8818VdsvYMFlzhK+3OxXFmwc02KckdIRrtkAITYACD7Fex9g9kUzXzzbfQk/OZO1byc2VMv+mhYBat2JVzDXSpvGknuYKhWtF6FK8oDL8HkN9sulh5oh1CB55TK0cO+j4fu+dyLq721kpnn8WZctQxRaUGmv+53Nf+JUAnqyGVHLrsJtQobpFzs6JGmWADCMo2mjQsZHeZ9UwWjijb/tJWWg0iwME3pwdqxeFasdGyJ3N4a/gOhcA0Zbe+GHEC+kE6rZwZws2Ho6iYSaWNEYXhjxRlK237Du9F3qMGE0aUxXiE4GsAQtangSbh9W5jNGAL52zzCyJdUbHr7mx1d13kVg3jC0nLH2hifmXo30PXO7RKloRJAm3rVqN+iYSy9UP1YFD8p1af1o6Pq0UfuYk8ghuA9uEprfqDDEeUiAcCVkq2zc407efdMKh7UvrSTHf4xsySa7HaGsBCxYMVeVoxPZndpbojqP1PkLQmQogaiW9sWovEVRqwDAgKXy0/luZUOyGnLyzEN9CTpB8r457df8LD/CHP3s7HFXVIwi8LAS01
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5013.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(376002)(39860400002)(396003)(451199021)(83380400001)(122000001)(4326008)(110136005)(82960400001)(54906003)(66446008)(64756008)(66946007)(76116006)(66476007)(38100700002)(71200400001)(7696005)(478600001)(66556008)(186003)(2906002)(8676002)(38070700005)(52536014)(8936002)(41300700001)(33656002)(5660300002)(316002)(55016003)(86362001)(9686003)(26005)(6506007)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mvLqHbkC7hZHntM1DSNWs/M5HSPfgpmQIla+P2tm5cf4X9enGHl9eOxmQvkS?=
 =?us-ascii?Q?ev7xQlqRJQYwoMX9oKRGDZzmfjnK8Y/Ta0Bg7c9a2DhP2uX2YfCKvoCLgPeT?=
 =?us-ascii?Q?qhH3CehN7Ipp7M57kvyjPw+cvbrgHjd9xZzvPVzOsimXf6gNbICbjqoeJFNQ?=
 =?us-ascii?Q?4ZyZmIpkMTn3lPDAur3P8XLUuH6Oej9kXWb+AEPyK7HsUC6umq+IyW0N4hXR?=
 =?us-ascii?Q?GfUVTQMGikMNLNOZ1EX5Vwe0qXBC0YPmOugik2kAc7NeeMo39wSrr0QnFHFo?=
 =?us-ascii?Q?EScaWpNwP5gpBBkNrn9AtaIBQgzB1GVj4N/dtoHPxQSaIRV1Kp1Zb7buVKRG?=
 =?us-ascii?Q?0udoJ4ZW8hpA35ntkia4wZ8n84dul2f6AYRtkeJ0k36X+G5Cvsqkj81hJ/fw?=
 =?us-ascii?Q?wh9am1Iz9YL99d4OaZK7AIstxaQl62iXSbF9eUqP1niYv3tHgsxtePouydJs?=
 =?us-ascii?Q?mEjN1eidw18O4gqlQdQ4F1rJTGsw2Ct7HmgwjQkocOCq6jId3Jnepa7ieZh+?=
 =?us-ascii?Q?tIHq2VXCkcT+i+W0Dy457vbmq/Y6uTppdQOPWyjoKEo73uBCW9KwHGEI26b8?=
 =?us-ascii?Q?vhurSs9v+SLw8i2WtaD4AaXEpkIQq79TVLbDhqsiL5/LpOkcx5fsuu7H0zH0?=
 =?us-ascii?Q?L/V0RdJlzFd/Mk88D3er6UWVUkQNmDiqh/GaEMKXkbu8+s1XXrmpHfWM3rt7?=
 =?us-ascii?Q?BMy3d4TlW9jgEZPG1q0iaAYDXQtDIHcEbgAMK5mPAYhOXL0wkwL0a3/0fare?=
 =?us-ascii?Q?G/EIwdXMrmtLNFrj2CiXJU7vSx6v/F+/hhDBvFcdoeywQw6UhilmlhmvsaQy?=
 =?us-ascii?Q?+PCgFE3IoIslQwjC6qMiQ9cZAAfELWs3wyhSHBH+nXxzJuYac5+RBgtCmj7F?=
 =?us-ascii?Q?KZrHfFT2HSCZzDOC7WljGM6NqqkPx+M0rYM07/jqe0k7+KoHmFloEUN8BjnA?=
 =?us-ascii?Q?tlMa339hAPri63DENyGjv44YAfAX077/w3dydBtrpNjyYWKCVi0pyHKoZ80r?=
 =?us-ascii?Q?WeJ+wAOvxvsVB2A47S7vAIvgEDcncG7HPar8s5CAtjIpkAprA0SfAzDEkY4c?=
 =?us-ascii?Q?LunqTBhIjWxUkry1WmpGLkq7sdVbh6NC/AwsqsoKqZF2rZIeffFxxYHdhO7g?=
 =?us-ascii?Q?1DUzuU4XsM/Qe5n1jKvCu6NiaMlNcnCGhleStZuRjZAN+Ov2jZ3s7Y/gU6kQ?=
 =?us-ascii?Q?9v1Jfnbei2NXYOWXK4jZ4baOy+RfjL3T511UFqBOekejTPmHiNzKWvO1BKa9?=
 =?us-ascii?Q?WLhqpjoV3nAg5xEENh2dPCCeq2PmTrk4PKNwjhJRpC9uq00xZPZG1Z9vltk4?=
 =?us-ascii?Q?KO2JTM09sxGksmfo3KR6NmmwIlolHkZ2qzf2AoNGyHbLUw8h2K6GAHLf3IWH?=
 =?us-ascii?Q?FwX/2ZTGTaw5z795HZDz1Jle11aNJ5MWuBgsvM6ZO0SLDI6U7adX+VPVSiEa?=
 =?us-ascii?Q?1lDJ9bPi85/jWWpdBGM+hclQZG2p/D07f1TgnqZaCZzFhmQuJU7zuhrAsLev?=
 =?us-ascii?Q?cMgKc/bofvvX0oiDeyNUvqs8gx6J+axqpsL62wsp2O3E9bbdv2MaNN1iH1MP?=
 =?us-ascii?Q?Dnz3WEfDm5drRmq74tMFG+v9A/KkSbT5cU9yEeU+xUSFuR/HdXFCHJJsJde9?=
 =?us-ascii?Q?DA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dbacf10-b129-4cd0-6763-08db671cf913
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 06:03:53.8222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g8KxONePdS+0hf1g6GP9xo2nDf4zmTlbMruj+8uVJihF25OXnooNwi5QGFVSVWN2W4mcb8G5jVlhrtz7So9IY15ABjDT9QY0pTI5UCNPV1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6946
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Wojciech Drewek
> Sent: Wednesday, May 24, 2023 5:51 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: pmenzel@molgen.mpg.de; netdev@vger.kernel.org;
> simon.horman@corigine.com; dan.carpenter@linaro.org
> Subject: [Intel-wired-lan] [PATCH iwl-next v4 06/13] ice: Implement basic
> eswitch bridge setup
>=20
> With this patch, ice driver is able to track if the port representors or =
uplink
> port were added to the linux bridge in switchdev mode. Listen for
> NETDEV_CHANGEUPPER events in order to detect this. ice_esw_br data
> structure reflects the linux bridge and stores all the ports of the bridg=
e
> (ice_esw_br_port) in xarray, it's created when the first port is added to=
 the
> bridge and freed once the last port is removed. Note that only one bridge=
 is
> supported per eswitch.
>=20
> Bridge port (ice_esw_br_port) can be either a VF port representor port or
> uplink port (ice_esw_br_port_type). In both cases bridge port holds a
> reference to the VSI, VF's VSI in case of the PR and uplink VSI in case o=
f the
> uplink. VSI's index is used as an index to the xarray in which ports are =
stored.
>=20
> Add a check which prevents configuring switchdev mode if uplink is alread=
y
> added to any bridge. This is needed because we need to listen for
> NETDEV_CHANGEUPPER events to record if the uplink was added to the
> bridge. Netdevice notifier is registered after eswitch mode is changed to=
p
> switchdev.
>=20
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v2: fix structure holes, wrapping improvements
> v4: fix potential Null pointer dereference in
>     ice_eswitch_br_port_unlink
> ---
>  drivers/net/ethernet/intel/ice/Makefile       |   2 +-
>  drivers/net/ethernet/intel/ice/ice.h          |   4 +-
>  drivers/net/ethernet/intel/ice/ice_eswitch.c  |  23 +-
>  .../net/ethernet/intel/ice/ice_eswitch_br.c   | 384 ++++++++++++++++++
>  .../net/ethernet/intel/ice/ice_eswitch_br.h   |  42 ++
>  drivers/net/ethernet/intel/ice/ice_main.c     |   2 +-
>  drivers/net/ethernet/intel/ice/ice_repr.c     |   2 +-
>  drivers/net/ethernet/intel/ice/ice_repr.h     |   3 +-
>  8 files changed, 453 insertions(+), 9 deletions(-)  create mode 100644
> drivers/net/ethernet/intel/ice/ice_eswitch_br.c
>  create mode 100644 drivers/net/ethernet/intel/ice/ice_eswitch_br.h
>=20
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>

