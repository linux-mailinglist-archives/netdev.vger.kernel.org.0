Return-Path: <netdev+bounces-11891-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 592CD735046
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:31:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14EE9281098
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2663D2F9;
	Mon, 19 Jun 2023 09:28:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD36FBE71
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:28:26 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4662113
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687166905; x=1718702905;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=M2EU83c7FYA1452lzCXz9CAcC6lqvimGRnHV4y+chwc=;
  b=RF6xXl36lScaFBBylFf0aCWlUfzodJueULLRFnodbH4ufZzMeuC0sHEr
   vjp/9O4WQWvcYPToN3Nktj7nOi76gtqIT7Kr/BxdHZMCkMBUeIm+byBg/
   4Z88QkuKvA1R/+lMfOMbGQTGxn4eD2Oqn83m65lnogMLL/Yn0aClwuC4C
   DJxLgk5RoiWDICi/K6XOLULjm/CAY4nVhTXe+UUapeT4lLDTpxNqgUmEB
   ZcKAp15ZI6sb7Lj/3T48Bvnp17+51m734tucTFTM06H5gk4FLTGL3L1xX
   FtAME0dXauH32BLkmrzR5BLKPK/0WcVTdInHEjekokOxl3G7jgrNcHFou
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="339925628"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="339925628"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 02:28:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="663923958"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="663923958"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 19 Jun 2023 02:28:24 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 02:28:23 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 02:28:23 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 02:28:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8UJLXDWHz/jack4+jxKX3oyQac3R2/KZxHf0ccvpeSR9tHm0q+WGjiHTyT9BXAkk1Q6NgXrLOvdjlTPVc9ZYuj3qy8g4r8fkKXsPMR6qvX60HAn/XqixzjhySezEc70aPHQro7sOY2GEDYarQVPLQlNPBrydA0XGSIHAsTT2mjmVucDdpYfZwU4LS7ayjdIvxWSeuwh4CO897QER+gRdDeuB9ZdWE/qPd4vtZUWp4q1TGCi4tmBRQ9d+q6NZIC4XmM3nzj6Ci+DkQIO2l5ASLROPqPZhcAC9pnvXeSRNNuj1oKGCkIhJuoKsw3MDsdHTXcbj16z5D+sN3cWSacU6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n83Hm3KudvX0R/69kY/qmjHXoXBsey2fFVymIJkU+lA=;
 b=oYv2AalMLGxInRWrRScCIYB6Md0zbD9y78KWZPHcopedg4f9rSf0t/qjS1GxUI+qk5ReLRDH1Fxi0w5C4tWgUEtjcbuMbFYlpnx8flJtQrC72pdpANd5I/3V9H43N5ORGugbweq5eHE+v7uaooRpYBmbHsUgjvxs9BS2h/yEQklm9UJIlim/kHCxkFb8L9k7pOBRLWVmoc6KSWhtU3rLNGo6P/K0PSkOtbNhapT+Fbhb6FvFFpIOvVvTXykY7Pp7ibClTA+gZdy5PL0kyTNRlGMB5PpKeZ7dDRCUA8bObyfHglN9ZrYpcN7H32FRcVW99WeXUmRTCVyLuL4E1l6b/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 by MN0PR11MB6256.namprd11.prod.outlook.com (2603:10b6:208:3c3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 09:28:21 +0000
Received: from PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f]) by PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f%4]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 09:28:21 +0000
From: "Buvaneswaran, Sujai" <sujai.buvaneswaran@intel.com>
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v5 11/12] ice: implement static
 version of ageing
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v5 11/12] ice: implement
 static version of ageing
Thread-Index: AQHZneAl/18sr6DTjU6MsF7nYPZpYq+R5PaA
Date: Mon, 19 Jun 2023 09:28:21 +0000
Message-ID: <PH0PR11MB50139B3410D3EC72A8467847965FA@PH0PR11MB5013.namprd11.prod.outlook.com>
References: <20230613101330.87734-1-wojciech.drewek@intel.com>
 <20230613101330.87734-12-wojciech.drewek@intel.com>
In-Reply-To: <20230613101330.87734-12-wojciech.drewek@intel.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5013:EE_|MN0PR11MB6256:EE_
x-ms-office365-filtering-correlation-id: 436d1e89-46e3-4256-43ff-08db70a78608
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gCGVf+sPaBz4LDbojJ/4M3TUbZ+o42LFm1kpPdYk18I/aBL9tzFxpPwBdWS2zTZuWCmx57SDAOggyjzvJHHH2341uRV5geK2p1/ll898UCryXtK3uqGAlpH19sc5rEQU24AzKzIZwWq7EwC6R5OaczKQ62cbdSv8dZcfTTkeNG2FeaOUYEg1Mo8LpD3k/z4zQ06JFNljoq26O2heB1EUvKUJAKpdzwMFTH+UGcMTaxQfgRc12k9qfhcw7paaA7tWh8Tev4Hdscub6cMIAPXH16rOzulnPTpEq92uSWboPT47JBrjW76bJJKR7OAqCHx1ydC62wIL63ZDQ6yZI4qQJMFV1cyxPUUkmlLNaWMuj6A+r7B6xQhSdgNDCjtMzok3+A2IsyXVwE9n8bW/I0kl4yePxLzWKMOT0JHVq+pG7qk7yM6avNumlbX29dBZOAsgTPsmpwfeNyTfas//brStKEiLNhz/3mVGCUdQfcbYlAprP9uBilaeYK8KYywkeahFd6RP9tSGBqBN0eC71I6bvIseBg9k3xBpY2pJmF13JqSnk8vvLXU0FdK6gKLeRMilP2vRKqIsiM5+ez0rb0y9+6vHs1gfN43yFaTZog7c3a/tZbjZBZEXYGztbuDEAgj5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5013.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(346002)(366004)(39860400002)(396003)(451199021)(52536014)(33656002)(86362001)(41300700001)(8676002)(8936002)(38070700005)(5660300002)(66446008)(64756008)(66556008)(66476007)(66946007)(316002)(82960400001)(38100700002)(122000001)(83380400001)(186003)(9686003)(26005)(6506007)(53546011)(71200400001)(76116006)(4326008)(478600001)(54906003)(110136005)(4744005)(2906002)(55016003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MjY8dSdPJIQPk6CpGGQ4/LJCNIzZaQKdtfOw+euRJwnWQWtMVUTc9Z8KKG6p?=
 =?us-ascii?Q?9dNmKOHhwnFevcaKdq96+CVbnKHRtVwAc1U2QO1S5pXGuBGqT1NoAM/hab+U?=
 =?us-ascii?Q?bxvGtFmv7J5K4M4nl03NGWus4wdbVBoNfAYI42Q4p+WLS1YH202An3/l+8Wm?=
 =?us-ascii?Q?PxrUoYXycGmbld8Lkx/KhAf0QBpnCn0iy+4YV3Qa7MN8m3i0+yErJ3PYKabd?=
 =?us-ascii?Q?PdM7kWEtXOhAyqMNPr0pg6Y6XqqoZdAQ8TzmM2NOFNAHZp+RmVmb43oWsYnA?=
 =?us-ascii?Q?QevW9pBddX5B28rbeydarXvxx6LlSpYe3U5lUkbJ2YOml2xjxt4niP1OjaVg?=
 =?us-ascii?Q?y2c3ShZ9xPHBV5g5EA7JCwNu/fWRArhV1gG0nxTWHdnhw2j2bJS14q5Iqc/V?=
 =?us-ascii?Q?KIk6IboC63Sm0Qs+lbt6FCrdboYZrvAnoQ2HzUA4x7fVMWUG1cE78KILDnzy?=
 =?us-ascii?Q?IIfUm3D+xrUx9lEUe/1W2A7ynZQgevKdeH5a4LRSCFj94LOrOCaAsCV+L+1q?=
 =?us-ascii?Q?8s/cPCfO4z8GSMSNWqDp1kUeDj5o+mgu4mgU/c4mri+iIc/Pn1DPopk6ylPY?=
 =?us-ascii?Q?OP5q4Zw7R2Z8yiWMLpmSzdYabI/9kWBg37PY8X9XejK1Ib5UdytlXOyJB8v4?=
 =?us-ascii?Q?tcDdFtUiR4ECXWLGr5N4GAkmHf0t3M7jQw5RnVJ89a7l9wVk1BjFgnlwQ3hM?=
 =?us-ascii?Q?ccs46CTBoPwInvWrmM+eJBNYEhQrch4cObksWoWK30ElOIRG2SLZkGK7nxHM?=
 =?us-ascii?Q?br9NHh0c+RiJJ1NND6NzjQHthEIRWTDoE7Yz2RNtoLt9W8tk7GhYI7DNBKFz?=
 =?us-ascii?Q?DZ99gytHDSZW8VaPSaL5ObFDvnQjOXGnlhYBVIZu/YJ8K13alGrUDGOyIlbg?=
 =?us-ascii?Q?w3M39TAUlCUc82W5bicuSdBYHB8wdgLK2Qc5N7uwyVVopF2aDmQhXLqGcdTA?=
 =?us-ascii?Q?EGBcnFgGy9lEwKiS32i8BM4/25TGjR9JC0z3//myQSlXR8MOuKIWVCZefzrh?=
 =?us-ascii?Q?r/E1OYd+f9YUH8D8/2To144cO2Ll2OaLC6rIAOzFDi+evdUw4WUxzdtt26Ww?=
 =?us-ascii?Q?qGjO70puDc7TfvhCMcv0R7uU0Kd+NTMB9eN1gm3A0l2r8kfXs++U2/hIKg6X?=
 =?us-ascii?Q?MGvDOxl/21zk1+sM04oEM7kpYrllhUd5WnbkToqaDz56zxRrurZpUX8EcoZd?=
 =?us-ascii?Q?xLoNWlZHjmLGHGn4Mi1rYwjDr2rklnbCcQKIgqZibnCwjnHuGphWfWryVdcJ?=
 =?us-ascii?Q?ChHTNxtATgcMxXHBJQ6HcJTUyHUk/yS0ZbURvDyibA1v2/kMxI2DDcgNOIBb?=
 =?us-ascii?Q?hC1szRqaR3z/QOslUJNr/tOT5q93+2JM4OexEp8ymyJInukdep/gO+IXXmj/?=
 =?us-ascii?Q?JhYpohs5jk48cdq8atHryB0iOjCWu2zcrtGUfkT3v6txOVU9G5umlIPo459+?=
 =?us-ascii?Q?0GL18Z9JANkJtuINK8+IglomfwwC1eoJhKq8cUKOcoclO6QTA1dYbfwu0YRq?=
 =?us-ascii?Q?a6LwkXcwB6og9W7u2Dedzo29rHMQSVtUdx4fMggGGc1cgbpwcZYodEPkNPe7?=
 =?us-ascii?Q?3C33QjYAqUFIeSUYbYdfmfmUAfNRzYcw2CT43svi8hkLALI/Y88j0AFzc5VQ?=
 =?us-ascii?Q?nA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 436d1e89-46e3-4256-43ff-08db70a78608
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 09:28:21.3371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pJJO4DfElaSXoLjMa0OiTcs7UdVlGZTYur8Ilg82a+ZPrVHFVmKRpEAqISUfK9DyIO5aX56nzW/J3OJ2lttnL95D7TEJnh9KwE77/hc3h8k=
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
> Subject: [Intel-wired-lan] [PATCH iwl-next v5 11/12] ice: implement stati=
c
> version of ageing
>=20
> From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>=20
> Remove fdb entries always when ageing time expired.
>=20
> Allow user to set ageing time using port object attribute.
>=20
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v2: use msecs_to_jiffies upon definition of
>     ICE_ESW_BRIDGE_UPDATE_INTERVAL
> ---
>  .../net/ethernet/intel/ice/ice_eswitch_br.c   | 48 +++++++++++++++++++
>  .../net/ethernet/intel/ice/ice_eswitch_br.h   | 10 ++++
>  2 files changed, 58 insertions(+)
>=20
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>

