Return-Path: <netdev+bounces-11887-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C34A735026
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:30:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3720B281058
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC90CC2E4;
	Mon, 19 Jun 2023 09:26:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92F0BE60
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:26:13 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F0130E7
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687166755; x=1718702755;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=H0u5zkwE1U1QT2CmqG0s8sC/vPNzZ8YAxPsiDbs5RQM=;
  b=MCXY0dwH86j56VPu8zad8sZdw7oDuAeJ6N7jpaiXpVkPB36t0XUhVPOo
   URZaa0jEKRpUEGfwoeIXh+vsAvT7uE5/gp6yr0nbf5dZgzPtrrYKboKOs
   nI9cASSvniau5NEJf6PKX4Yp0i4shCr1ZETWurAdBNe8w5kTbPH68ec1M
   sNT0mwLyHtbEzi2QzFAGd26z5Wq7WMMI8L7QTiS3yID9EN9aN5JXeKR5D
   nVeMpbRUWHfWdyBxsXA5LHBvH7zLt5106d1ShK4zdoM4ntg0yU894sYWB
   oq7U4s3RQFxKstS9t9SYryfdYJD2zfqs9R5JVK2Zn2KQrGQ1h/A5te1zT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="339924936"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="339924936"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 02:25:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="803558441"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="803558441"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Jun 2023 02:25:45 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 02:25:44 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 02:25:44 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 02:25:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dAt4AEaxZ9wL45gi/Z7YEtMlOv1QagQDZPWB2OUzJc0LAgVBLSCaPCIfAwjC8W5gP60wyoYhq8AHyzJatH6bHrZhLDN3DZLiEm62bWbDbl+SaiELM9UMjKnt9MeGRmbjrxpnaV9DC+NPvYDv8prRKAtFbKqvlkCoZ0DNnlpUZQz4r4YHsBoPOwr+6GvG6Y4zHhfAeEe4RIgJjS14C+6RasQ/EbpIhj6m2nAFTRhJVlfWO8wj6aKoOpJGiOpBKRA7Ds0hTEn4rNnU+xhbloNx6tfDfqrnilrznexzaPWSZutZaJWlQucqCamDk/RpoOuZ8ZQhbDh2e9x3T0BqEX+kQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vYKzaKhEhVbUL0FAHRDR2Avijki5jkf6ZuNSXNoLF9Q=;
 b=ngcbP+CBy6BnNapTC21XT8ZQRGbRwYIYPtqJidN0qsGBtFJ5HHTi9kyrXerKaxxuU8pyny0uOJUd2ucGw5fEiMlZroQwtsMeeanm3kePk0hSGSHquF7Gm+FRdFyytCHcLMez1NvP9QDy3UouH/hgIdQ6V/mIXTt7V2pvDAHvkjGxK0tzoZwicy9k+0r7XJ+KW6A0GQZePQxdASQw0yQvuPyhwtu67Al0mjkiyFK2Cm/N42fuUKLwPAKDW5grXdA2l85+jLBR+zWiZXeGu4pW7bekSFP7cmpEVAbio+jzWTWxCmOTNM54C9IT8vGFcSLsd024lhm6xkq7ids0wo/j1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 by PH7PR11MB7478.namprd11.prod.outlook.com (2603:10b6:510:269::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Mon, 19 Jun
 2023 09:25:43 +0000
Received: from PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f]) by PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f%4]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 09:25:42 +0000
From: "Buvaneswaran, Sujai" <sujai.buvaneswaran@intel.com>
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v5 04/12] ice: Disable vlan
 pruning for uplink VSI
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v5 04/12] ice: Disable vlan
 pruning for uplink VSI
Thread-Index: AQHZneAQEMjWc8LK3E6US9d5evYEUK+R5D5w
Date: Mon, 19 Jun 2023 09:25:42 +0000
Message-ID: <PH0PR11MB501359CF3B25328DD2FBCD89965FA@PH0PR11MB5013.namprd11.prod.outlook.com>
References: <20230613101330.87734-1-wojciech.drewek@intel.com>
 <20230613101330.87734-5-wojciech.drewek@intel.com>
In-Reply-To: <20230613101330.87734-5-wojciech.drewek@intel.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5013:EE_|PH7PR11MB7478:EE_
x-ms-office365-filtering-correlation-id: 4fc7d624-1cfb-45fb-3983-08db70a72791
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xDcGNXBxt/Xf/LnLBFslbv1UjICOI7adfpJy7oC1IYnpF5hEiUU/R7IfJpnfXyM6oRzxPCO8SnhoZ6zQxqweB7B656Wb7zHR6Ry3t7h3icJhkAQLMT2mpK8Hxd1ZQGOCgopwq81bRn4qwm6cYBGBravqY/PhzaATmMebTPTY+iZWl1nd6EQ9GCDPIt+PlGRtjozEc9mmnq46tjfwEKZhqk7L1p8xg3cKbKtDIbMTOWFHrHTZzntH9ixZPHAhzzO8fTUfDmVrZSd23El5J4rpyz+9JrcnhfGTy0aRZDoPUNglM+brRRzJ0isqj2EwatK4L6wDHKoJM55jdh5l1xt5flHL2kZq3GJICTQc1rsaA+W++VVhjQTs/vIrcF9Z+m4LSCs5sZMxKYFELO96L0gu9eK/INgOdzOPwrwTkiGt4aifsvc/bb8xu2nmNORuFX/el1PTqOSUlUZsOIp40NXc/SCinmw+eg0Uri/NQuYb78VCuGyzNpeanGPKXqN8pGEQnFR8LX6oZW2iZF7XbKgFKt6ztmV/UCsma9t8ptrdi/08umN3AttL9LmMjj9iLXWsKgnTjt5FL6CiMCgxXpXcY6+7qyqBEgbRqrgdFT6UpWE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5013.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(136003)(376002)(396003)(451199021)(53546011)(66946007)(8936002)(8676002)(64756008)(66556008)(76116006)(66446008)(66476007)(38070700005)(26005)(186003)(9686003)(6506007)(82960400001)(83380400001)(41300700001)(38100700002)(5660300002)(4326008)(316002)(52536014)(54906003)(7696005)(55016003)(478600001)(2906002)(4744005)(33656002)(122000001)(71200400001)(86362001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?axvz0/q3Uprc7WtnzVeGVgHhJr07gJ83VimxlJF7dBJ6cmINxXAt/PRYipzs?=
 =?us-ascii?Q?HS/jGbHGBaapRGM2VRCmNpd+kN1CpUFq/l0AxnR8Tzdsp7C6lqGQ8wYOM8go?=
 =?us-ascii?Q?c32lvgtq3P2YU58YWT5L8l5tI7nKcSMUZF9xfQCkzvrM1iY0wemb1jW89bwP?=
 =?us-ascii?Q?d3bwP/XdnPt0Ckv84EldbAV2usyLUTurK0zwv7ZKsQVs2S39emULYuvaZ0cv?=
 =?us-ascii?Q?+lk+vgNpaHfzpOmjBuSx8T8pJgdp67NPH1j/wscanbxlCD+tgTAKWs/Penmv?=
 =?us-ascii?Q?5yqi79/3e5p88qU5R9e74fuiSOtS6zEie/NIa8Ceuk76e8N+GgMeHQjSHVuz?=
 =?us-ascii?Q?aAhyFEc3EHAAgoK0AO3i6HrhRQ5gjoIqU6sh39/3iwXgTdVQK7K5eLgKVUKc?=
 =?us-ascii?Q?VqEEoGHUP2Xoo5s7V5x8MWjTKFhHdXq9lFU58ZCi6U7UBhUakk9/fAgvklRB?=
 =?us-ascii?Q?4HSSfob3B/RsniUafETYG1OinY9rU3Gc5Nrt/O2+50B5KnELf8NS+ZPi+IcS?=
 =?us-ascii?Q?7JC0nnMC17I0zGSMRQFguvpVOtJISiMmFyak9R/THRvFjVuyRigzTEmpLG7z?=
 =?us-ascii?Q?fSpDBEg3HkuyehDuSXa9AtnRga5lTPGc0+C37f5Gz7tncmijI9sFIMrTALpU?=
 =?us-ascii?Q?ZPSUTBb51a3vD0E388+fyXEi+Aq1UMLR5RAmHYjmqYtRieHNe5/cS4zhqQlJ?=
 =?us-ascii?Q?OHQW6HRqv6YgQebuMyg4Bh8D34TLtTLtA4RQonszTt7TFX9ctmCh+h0d9+US?=
 =?us-ascii?Q?WL1y7xahe3joYggY//wZMfhk2PPSUDDkqOGES2/4BRBsNoONCwl/4n0Oe8Pd?=
 =?us-ascii?Q?20XpvGPKsCEc1RMkT3PNHAUIPqmLANBPFcQjeMwC/jw8msM0ygBpe1RRR9XH?=
 =?us-ascii?Q?GmFhj7/uxciDgaT1RNgHKH7hWR2nvFXjbLrQgxRtj0PgsCzXYQQwW7j45Zxp?=
 =?us-ascii?Q?OVyVe0tYb4iFUmfGGRXj8JHxuEW1WjEJTpn0y+XJqFxgInvhuDW3rE7GoAWa?=
 =?us-ascii?Q?mFiBNEos8sC8COLGNYCuY0p6Y3WnfYr6Oxhd1s3TfWp+DpOu0hEZqc8WRbDz?=
 =?us-ascii?Q?UNDHD/y0OPDw8lRu7A4aDmLrXK9+eYSWhmhd5F4UFfEVyrDFqwFxcJU75UzH?=
 =?us-ascii?Q?IGtFVI1wup+oN7VPpCddhuSMx4hSQ24/1exPY5pDslllEeHzabGTk5ggvoAd?=
 =?us-ascii?Q?Ta3hw865emm9umGCcueeQJ/lSkZRaI+4DynQ7O8LXxdMflne7SdUdcS+gleJ?=
 =?us-ascii?Q?iOe7B1kNbaOPp6VYY5HAbpZULImUa7FpWvGM7og8pyO0Nfm/DtsC1ub/9X4m?=
 =?us-ascii?Q?9ltF+UNzWkD+qW1w+BnIZXh82C8ydb9GjQ30AF6r5zlJtFIhw33+kl78f1UB?=
 =?us-ascii?Q?UUa1Atwvghy8zMNu9uuPzKImfmVJlvNgFGFAkP+QiPAhdUZKBMC5Q1DgLESj?=
 =?us-ascii?Q?zdUj0mVKlelnoyYZ5ku923rYzsuIWJmeC1XT2UEjZ67aZy6bl5JkULCcNyEa?=
 =?us-ascii?Q?KvhPJJz/QJmf082tlETr3UOZSiwaWXi/o0SZavOrfcb7HP9MZOREFKnDo6rJ?=
 =?us-ascii?Q?ji5IhCNJr9+Sw0SJz3xsX+sJ5KBnNa8OnMvsxM9mu+XHHuJgnl9a/86kRiMe?=
 =?us-ascii?Q?AA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fc7d624-1cfb-45fb-3983-08db70a72791
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 09:25:42.8522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J7YEZ6lW/10ogxN8RWTvyDgFYhPvu/36lEiizb7Xy2RCDp8lCtCEzsB8MNjCTXr3XwHX4nkWdheBjkXd88JgEnOxPn/h7ebXJb8671WoVMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7478
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
> Subject: [Intel-wired-lan] [PATCH iwl-next v5 04/12] ice: Disable vlan pr=
uning
> for uplink VSI
>=20
> In switchdev mode, uplink VSI is configured to be default VSI which means=
 it
> will receive all unmatched packets.
> In order to receive vlan packets we need to disable vlan pruning as well.=
 This
> is done by dis_rx_filtering vlan op.
>=20
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_eswitch.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>

