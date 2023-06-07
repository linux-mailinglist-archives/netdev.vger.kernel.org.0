Return-Path: <netdev+bounces-8698-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 286C87253D0
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:02:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7C2F280AAA
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEC56468D;
	Wed,  7 Jun 2023 06:02:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF7763A
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 06:02:39 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8259D83
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 23:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686117758; x=1717653758;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h88RApguWmvOwOkjnFa3ATPkqwBzIsJ67WDeGp7rGEY=;
  b=IQZ9v5oEKKqUV+yFOwJiS+rd6VRuv2sMRePLVIQuG5Z4cjqSCNNzbpgp
   7jWc6J2MEwPYTUICwZiQUvMEZ8W0VpX9ZjClm2rVXrOXauhn3LJ/lf5dp
   nJIK+R2fsAJw/Dih/kMd1gYKHnHyLAYD7wAmh+6xF9IGcb7ZbKzyznX+X
   rUpSlI9yympfaluVDJwnXTG+oRozELsuCx+97XYgdFlAHpXjzusJkX+Mc
   PWAMXn57WdaEUX0Ma+kMfaanOvhVMsPRFD5ZUHTSn77oiMI9KkAVQkq8N
   pTHNKJ4vjoAfarHsO9LHSM9AxuSOu4R6FuUU62ZqGW7GO1L8nOW+nELNA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="355748196"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="355748196"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 23:02:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="774381637"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="774381637"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jun 2023 23:02:34 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 23:02:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 23:02:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 23:02:34 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 23:02:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h40MfTEJqtk1/vHmYNARiaA5eA02BMfftpGZQVVqpnj8ZD6Bz1+qHsSYnuBFpNQ9IKhyvh/YUi/FNvcGiretiy1L3ausJ2nL6elcS6D863JOwCZ5w6IYB8x5PGuTIo1nciTFWU6UGaZ+i0PqgifKJH/K/3kyUpae0nkIK6WrsHsAZ31j3I94XUK8Urw6J8yJpXWDCOmeAGMyDh4j+ntjQ2UxUBEC04agS0ce/2M5Hs3TxGWCvPBH10/gRNdUkiJ6xYg/Wbhmg1DFBNeeppRhwP/xUjaxsYdoz77ldK/ZQvnFj4L0THEb/JBiZJ+4ArAN5s7Et3AyGx5RhA4KyH6TQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e6GwmEO7u2+pQ/5BP/Xl8xdBLNSR3k2M4xbeCYmp4SI=;
 b=Fbig3n+y36yjrthdEvFwFr+dgONqPr0GNXM2535j+pxoRPJctL4BBueAXmER/1QAsf/6KiVU7xD9udGyI1cCKLdfG4PZwDuFwqWT9hWmU+J0cA15JnOtuxW5awKNOvawiZdG+X8AlaE86SOYuR3vNbmRxECIHz++ovqyf3IQ434PVMnVC0m+JaKfc8Y4NPcjpXIZYTt8QI1oca0Trvopu/JB1mkGrwL7pET7xchV9fRwbOnMAvr6el0Q8JwI6jq5QvSh719u1unxoz/qm/8LC0Jr/6cX/xPDz9hJbMWeztmOHleKIHwBg2OwWxzckfW6KRT5DjLWZ8+QVu65BsgseQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 by MN2PR11MB4678.namprd11.prod.outlook.com (2603:10b6:208:264::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 06:02:30 +0000
Received: from PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f]) by PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 06:02:30 +0000
From: "Buvaneswaran, Sujai" <sujai.buvaneswaran@intel.com>
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v4 05/13] ice: Unset src prune
 on uplink VSI
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v4 05/13] ice: Unset src prune
 on uplink VSI
Thread-Index: AQHZjjqfcXU3zZEjbEmzfXFc8uBG6a9+7r4g
Date: Wed, 7 Jun 2023 06:02:30 +0000
Message-ID: <PH0PR11MB50130F5D687F4A2B8912547C9653A@PH0PR11MB5013.namprd11.prod.outlook.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
 <20230524122121.15012-6-wojciech.drewek@intel.com>
In-Reply-To: <20230524122121.15012-6-wojciech.drewek@intel.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5013:EE_|MN2PR11MB4678:EE_
x-ms-office365-filtering-correlation-id: 5494a5a1-873b-40c1-26da-08db671cc747
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 50V7Y0MZ5puw8F3RkA71HzAMcoPnyWb4j2lZYIavF5wwhPiPPuRfIQqKEMou/Aga2HlCOUjlR3e2Xlm33rLrEFcji+QB97E+axQA5rOdQI4e/JAcUIUjs2OE2L0aF13cK6lIpph/T01HBM+CupoL8RSaSBtM7RjDvYnS/3dV9ofrRfG+qJbX+syq3j/fYpeq0JlGXd99aZWkuFJUxlOtW+6mjCd9sBKbE0fpkk5BgIv2U4ga5qICBxCt9SDeL9LFmfr2fpLgpSo0gAhsvrXr6Qb9joks1lnlghais7VO0xMqrlU8SArHVoous3x36L6qzYXlSZY4NRBQ/0rIMJAid2HoP49VekyPGU68ou89JYjSgTidVjYO0yzT3WtaQFTA44MVUfm3B4Gs7pjmEJH6aszFiTV/ftG/BtV3h8ZuSDTk4m3xnFZzO4q4gnAz0BOOrTXvArql8wRrl9JIwMiIyuoRRwNnfH+Jsrj0K8/ziW8UJNZ6VyfuVhptaL9uD6bQYhNmT/fLJF/os/xBfjyER9dgNBOdSSrYwtzRUpHfdDZShGTKr7EPWv91FwwvZHs3PpbsjYbUhG3qq3PjKFrQlxsWBMgfInCrPIQ5abrEWwA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5013.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(366004)(376002)(39860400002)(136003)(451199021)(110136005)(2906002)(54906003)(38070700005)(71200400001)(478600001)(33656002)(86362001)(52536014)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(82960400001)(55016003)(316002)(66556008)(4326008)(64756008)(122000001)(66476007)(66946007)(76116006)(83380400001)(66446008)(6506007)(26005)(53546011)(9686003)(186003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DGw71k79aJWigp2qmVZR9qieSS1myJMwkBHacFLptZT0pj6qUK6qTQ052GqH?=
 =?us-ascii?Q?+YBks5aDF+y84KBS324x+ow6mjTy7o9/cLhm5g53EFXd9byDsx5ItOYa1eYO?=
 =?us-ascii?Q?sPO/a3Yy7WEBJBamKh+r5B9Ods2EqS2TVX65yL7cn+di/5gtz6ThrCIu4AG+?=
 =?us-ascii?Q?n+1E1CwSH4jtH4Yx43TxEaueLCeuI74PZVSFo46V7UzUqUGSBkBCELD2Okc+?=
 =?us-ascii?Q?/PODuR5zKe9kXKeHVjy7J1b8LU5t4GnuC6yRdK0KDVf5Spw3j1BJpoDgIWuo?=
 =?us-ascii?Q?o7XwCmyokT733rDDEfV2gWag3IxJL2K3LqRt5CHYHNdR+4Y4Xlo31C6gbmgR?=
 =?us-ascii?Q?1ax3GC/IHuNJ00jOKZsd0qVVvgd4lP8bFF6u1B37T2lybeOe0rH275pC55sv?=
 =?us-ascii?Q?pgO+pZarDw7HDcFeXsrTGqf9VfFnJCY9unkfGQGle4Lluhn414LMz5vws/Dj?=
 =?us-ascii?Q?UcAHdDupW/mfAITf2W1YQ5UFEgdJ2H80j/6Rs7S5BV9LomV2ko535CWY3lLr?=
 =?us-ascii?Q?Mi3/H1kuWvvFktuwmWYjt0otWQKZS2EyS5xH411j+qN2c3dXo6ZgUoakuI4L?=
 =?us-ascii?Q?OjK0Bz/IostJvFWPX3bUhogDtuEJtv5IUASOFwffFeZt5zTKuR7woGnbzN6J?=
 =?us-ascii?Q?Jod6My+WGpgtYz+CR7NMn/EY9ZmJ58J7jAEjkjtuyxM/bVtSuL09FSOks4II?=
 =?us-ascii?Q?iA4wXtAu/znZjPQSXg9SbievBd+TBKNluxSj//wWXOR1C3POklfCfu1hT693?=
 =?us-ascii?Q?xPvX/DWwwraRaN2y8ZEFiiGwRoHQl0Uo+ZbTmq8Zr4jLQkti0awJMKfccHxj?=
 =?us-ascii?Q?RlewLYcbWFOuKUb5ULcU461v0fB/jKOTPKInTWaBbNKGyC011EeetlwBuQzQ?=
 =?us-ascii?Q?J78KoEwTj2TLt8knudK2JzKCprDWEDK0bZMxJQTwmT4KvtuICtzjD6Mk8Ti6?=
 =?us-ascii?Q?4/rso+i48EbnEgp2GpypBZYngI9huyIiw8AD3Srltrp3mVzgHuHU7zFqpnI9?=
 =?us-ascii?Q?GkszMfigd3oHxHwJzhkWE3wReEjCER45GWp5eKcEFVaHak7zbOB0zyc4BtQP?=
 =?us-ascii?Q?qOSSopyObk3jhMQcB1HRs/siZc4/yP+wMxjeeWqhnJa8ebwKt/n/IgHbxw7a?=
 =?us-ascii?Q?qsgzblM/8W0+VI0mIADze34gTiIbhat40wkjYvcpaeANWWM0I0mR5+wwgp8B?=
 =?us-ascii?Q?SDc1aHpIb7xOXjBioxfHxRqKhu8Lis5IyYLUm2prkgFd/84sQfCHAsBHEBz7?=
 =?us-ascii?Q?wMRLfa3bNlL/x4kjfH6bbJWm8bU60/p28jEAYPnHzhdkxHP26j4IqAdyo8Uk?=
 =?us-ascii?Q?0tQEI0NqG5xSZJY1hBuhfpm60SWGmPx5w0COzlARwvZ1ivCgPQxfOa+e8xEi?=
 =?us-ascii?Q?EJEKOBGy1lVlUlbFsr9DvqPmsKa5H+MULq9BGTUWo3qZXc4NYlu3nUuuyONX?=
 =?us-ascii?Q?o4OBio/M5J+zikb6VgdnGYXwcDxyziELJ16jfPzzD5wiXgREB6Lg5txGPixN?=
 =?us-ascii?Q?TVeVeDXUkcOWXtrh7hqUGXDrJCLCBqn0vw0SxqdCp3N/gOFoYbtR1hu8MXmy?=
 =?us-ascii?Q?wFIF5uj5VPUdrwC1KMUQ6Kgjft+g4+2JNpu8i6xysINFk+Ha6xKY8krKUUoh?=
 =?us-ascii?Q?Ew=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5494a5a1-873b-40c1-26da-08db671cc747
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 06:02:30.2615
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vlbX20X8qA7uepu7SUvi0T1pLbC5ttFq7pyu2b5+OEr59rhZifD4hEMlwuIc4ZFqwqJdt2ZZ1e90aInCmaW/O1GUAdK1jyDUBEuVxOc/gag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4678
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Wojciech Drewek
> Sent: Wednesday, May 24, 2023 5:51 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: pmenzel@molgen.mpg.de; netdev@vger.kernel.org;
> simon.horman@corigine.com; dan.carpenter@linaro.org
> Subject: [Intel-wired-lan] [PATCH iwl-next v4 05/13] ice: Unset src prune=
 on
> uplink VSI
>=20
> In switchdev mode uplink VSI is supposed to receive all packets that were=
 not
> matched by existing filters. If ICE_AQ_VSI_SW_FLAG_LOCAL_LB bit is unset
> and we have a filter associated with uplink VSI which matches on dst mac
> equal to MAC1, then packets with src mac equal to MAC1 will be pruned
> from reaching uplink VSI.
>=20
> Fix this by updating uplink VSI with ICE_AQ_VSI_SW_FLAG_LOCAL_LB bit set
> when configuring switchdev mode.
>=20
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v2: fix @ctx declaration in ice_vsi_update_local_lb
> ---
>  drivers/net/ethernet/intel/ice/ice_eswitch.c |  6 +++++
>  drivers/net/ethernet/intel/ice/ice_lib.c     | 25 ++++++++++++++++++++
>  drivers/net/ethernet/intel/ice/ice_lib.h     |  1 +
>  3 files changed, 32 insertions(+)
>=20
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>

