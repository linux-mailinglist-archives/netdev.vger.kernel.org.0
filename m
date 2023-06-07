Return-Path: <netdev+bounces-8702-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E547B725406
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:23:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50A681C20B8C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF2EF53AA;
	Wed,  7 Jun 2023 06:23:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9D063A
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 06:23:34 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0371AA
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 23:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686119012; x=1717655012;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qDSVZAs5s2RBILBa8pK+b5UNx4oSVvZ2i8C8baHekRU=;
  b=NJEemSP2mAVL1ee0LQsYqKmk7dhna2Ots4Tx+PDhPZjGUeg/VZTMBxmp
   S2kKqzxWM4BSQjO5tm9Dh1FGTonJG/owLnEl8SBFQU3N0Ip6QxsuZS7Gr
   dXEf3FbTavnor8oH1O9Fk7yFp1OHiLM+6B4Bv6mUG6I9sgdL3Rz1hu/Vt
   r22QdJmiiGGkogZK4JFt33zd06c02zmocx9XsvlrSjnbUUyk/1gT32vbO
   AGoBQmMVCou0WqFd92B+6oNqvr2pb599gMOxW08A/CNSORLv6ewQQkbjj
   gWQI9oedqbhmJbwexuHPPZfG3sXjhIwgDPG1rKljeJJuf872wf3M5b8me
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="337260233"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="337260233"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 23:23:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="833530672"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="833530672"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 06 Jun 2023 23:23:24 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 23:23:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 23:23:23 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 23:23:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 23:23:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDt5+v8oPVLy4l9WamI5/3YtbQ5usiFSCf9oZ2tKgaUJ0SaZJ6PpZNQAcovHmBtHl6u7SuGi6o+cAlc18bVdfwIOCLLMBmEltCoCLIbeOgjkKbV7GJ4ZT5PFqzcr7Pik7+xOYfULsBkcMEhKYY3KakfDK454sku07N95eQP54Xz2TffTSLeUo8hmu+bIaBsjXX1M48cfQtptjGMHvx/8vDJoj0T/ovQenXFuZSZUGPngKJGQlwbQRqSKGCkUQiPODcLEgLomqNJgoGW0hzWvLWjU5XIZ2fXbIlO64hgTUDjfz8J7oND6LV12vfxlhX7aOEIlLhwd8wZ68fE7/2wE8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k/FugpwPmEI/1fnEXPqxpd2vCVlxBt/XwYu3rcTOepY=;
 b=Qw2j7ZvZkXyNJ334aFFWlpbqVsqEXA7/cV8vu3eQ0R1JUMK+9CZmNaMQF+NeYQxE/cePSug2K+8PIb3uHXcX76mOTOcE5T5zupdjJ5xZhMBkmpeH0fZJyC3BP0u9VVpYbugRfkFVV25SwB10fp4Upi2J2KC2ynuy9cVbgf0mLaa1pEwovT620wZrzZAJC65zDD86hoctuBL+xve9Ozgm5En+3SLGCy3LVhDG4NgDyqptg/VujGtqm0V36kn4dRuoB20jKw9X6TIrSpF0LshPhZEd0ade/y6TrCCvIpvgX5Nzg2NhD6/ENBq9Myf9l9efYRkhNRryZb2IFSRiltHsYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 by PH7PR11MB6452.namprd11.prod.outlook.com (2603:10b6:510:1f3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 06:23:21 +0000
Received: from PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f]) by PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 06:23:21 +0000
From: "Buvaneswaran, Sujai" <sujai.buvaneswaran@intel.com>
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v4 09/13] ice: Accept LAG
 netdevs in bridge offloads
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v4 09/13] ice: Accept LAG
 netdevs in bridge offloads
Thread-Index: AQHZjjqkreJj5gJoZUyuO3NkArZXra9+9I5Q
Date: Wed, 7 Jun 2023 06:23:21 +0000
Message-ID: <PH0PR11MB50134D0954A985268FBAB2F49653A@PH0PR11MB5013.namprd11.prod.outlook.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
 <20230524122121.15012-10-wojciech.drewek@intel.com>
In-Reply-To: <20230524122121.15012-10-wojciech.drewek@intel.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5013:EE_|PH7PR11MB6452:EE_
x-ms-office365-filtering-correlation-id: d124cdce-2151-41ab-7d46-08db671fb117
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iW4IsamY0wS1EgAdflqdzR1BjfjEyhL3WM23goDiPW6keMu8SsvUa28SyNjPi/py0oCO5wWXrgOa49is7baT0BTcWqfibfa4Gf2qgAUabZAD1Kv4lW+LPydIgqBZfZdkVTnZlnIb3PaMEK7KEjupidleGWEiY9+HdyA5VjURwvVyC2S1Im8IulgMMHYUz6bNOAmZb+mPMT4RlFqcQyEmxFL/b218bA5hEeTB1Cy40g5FynLBMqyXEwKEpY+cyfrxgpCk02nn4KzOqvR1/+lXvMmsLl7TXtDwDkoulTwv2U6CwEJ+YCLvLbkC3Rthvu+ZIC0AdfQ4qiz+hcxmHvTxS+257PpEs/OCNhHo8qfFYeidAlBwOxRUK22vgDLfGP9agdfzPRL47Hwt6rnOPJYDwefxebpmkUEmTIhaMKG4QSIEfuDL4Xl6rHHiwJ9LWNl39reOde8EE7XO1m8ItFAwoupgB8bM4D1Coh8aL1SbBx2lg0pEMXq7Rsn90AHlBn/60IE1Yknr/smL4y1Paaxgs55A62lUKGEq26qSkAjLvW/SBz5+5Y0Op+s+yzs29WY6mk1+Jp0MtOS5OOJQoBP8z5fAFrYh6pw8YUY9Wmkqv9EwJnUrwW92I/Tfi9Slb4NG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5013.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(366004)(346002)(376002)(39860400002)(451199021)(478600001)(4744005)(2906002)(82960400001)(7696005)(33656002)(71200400001)(83380400001)(38070700005)(9686003)(86362001)(53546011)(122000001)(6506007)(38100700002)(26005)(186003)(5660300002)(316002)(110136005)(55016003)(8676002)(76116006)(66946007)(8936002)(66556008)(66446008)(4326008)(66476007)(64756008)(52536014)(54906003)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qUzesQHfiPMMBOzRTMqivdAa5V8fkf1L8ETsnycDKWcz0oU1n+cJ6SoSCLFk?=
 =?us-ascii?Q?KMNh3JLgK7hy9FUxZZw7z0obOTzkO4voOyjoEjqBs6E7UO8A3nbmRDxX03ap?=
 =?us-ascii?Q?cX3rSzPzwgVfnPoNobVOO/0dBzK5wgIP5LwXDUuACx1begJ8jXRrePnkPMvU?=
 =?us-ascii?Q?BFv1na+Fg424cuTzWnATWPTKFIIAqvfHVYJfzl+J2L7DCX1s0/XP80tMVBou?=
 =?us-ascii?Q?obkWcde9YCJRYo9NWQcpCHhcUKurk9TY1c4ysuCoCw/dlsf0uKY2FGpVM826?=
 =?us-ascii?Q?4njRlNr5JCQXcZjA5HdzdYdF5ly75EhR97S4TVbQZCELpsc9ZsD6Bhu98y+9?=
 =?us-ascii?Q?HQq9sDIWOkMWL//RPTw9E9Cx64gHmx//Jvrf74XN9ve0SNw0Vt3nP8CMe/xv?=
 =?us-ascii?Q?FO7COVV0GxgVGy9Myd4aGfBQjanxe/TvWerxfgv9b0vz2/Nr5n8k4C0TY6g4?=
 =?us-ascii?Q?C+qHm/8bBhx7Y6by/I3B+2c9G6+C/EHvZIA15xL7Bek3NmqYh3feeni5P9dN?=
 =?us-ascii?Q?ZJnL4uaq67lQ2cIlZ2a8YBK9BPDHkEA4yt4TOqmnkcp/riXkZFaeDFyeDota?=
 =?us-ascii?Q?aXa39FveSrVl/kATcrzKCfb3FxVELBlPzusprBdaFULt3L402td7lrchq6in?=
 =?us-ascii?Q?tz/+0MBycxjuFb2XfbefEtFdIylRI1lB/IK5TBqn1XoA9X71A8Jp7ogv4WF/?=
 =?us-ascii?Q?hH6rsykuW1wmnUmR7hevU6RnTDcdjVaCLVrWZdkrEtK0qN12Hc9ZId1z4dSn?=
 =?us-ascii?Q?8QpNLIbXl04XFkrhTBNT3JYefABgTneuvDZqRHg6gal8E4c3RnDh2gRMymvh?=
 =?us-ascii?Q?O3Z6duVcEQsxAtiYiuBItyxmak2jduIrnt9vNDeXyCRVeZio/lvyjl2IhHNo?=
 =?us-ascii?Q?9+d8bDxmwiw899yjybymhKi1R5iGh2KzSR3iZqvL+s7I04wA78YnB4WChoMk?=
 =?us-ascii?Q?q2HTwilQtmei0feLJeNhdJoe1buby4UFMBRbEoq7tSMayb4jTxNEFPn8GKx3?=
 =?us-ascii?Q?EJZn7aQ2UkfX1Vm+zU0gLK8I0ELww0TAePjIMqPGy07V91KONRQl0cRbbmJx?=
 =?us-ascii?Q?ZqGU/OdDyitxf81IWcHEGAJLbBB338X4OfzGweIlNmgz+Ayu3xpeffRH/O3C?=
 =?us-ascii?Q?Pa3YWVXxmNeUYNxspRkrP8XAPEB8mc96U+i7qIBPJnWYEt75AnYBV0vObXSv?=
 =?us-ascii?Q?9AJQbxgNThidW0r+l/LVZYM8icUdu3T1IeMWq2Tg0dsJ1MUIpvIdP+o5OGjn?=
 =?us-ascii?Q?DSIHVb/j+r+Dg6tB+HwPdKdK9PV1+tsma4Kdue0pNeLDZNl6134m3EUqBgQ+?=
 =?us-ascii?Q?QF3vLHyQFbyuJsPpVtj01jNSqaQyfBpLGzHk1W30pUcS7XtrJ3C0SCCUxLWz?=
 =?us-ascii?Q?T38qi1/vbVhtNHEF1z5VWyCL5oOC4tkOFnWEDEzeHXTcRZaYJHiFVx3aWZId?=
 =?us-ascii?Q?IIETfLZe3Ky7CKiVqEwODXlGt4hLZ+D6cQWE04r9e24w+Y9lSwuMoq1rgt8E?=
 =?us-ascii?Q?+K0xBedp2Z6vvNjL7PVzWIM3Epgs//usVHkPiwaCHLgU6cWutefxdNwimiux?=
 =?us-ascii?Q?YLsu4A+DPn5QMLzX4KCDGppCPtKxRTiJMM1bQE9ta/K2ZEZon5YtbBshS4X0?=
 =?us-ascii?Q?bQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d124cdce-2151-41ab-7d46-08db671fb117
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 06:23:21.5212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dN2PQPqSZkKrCQnmpouvrdy6lWJszWT4U4EumSo/dkVnCNoW0CceF05yMRcqdSKvbAo0unf9YuJKh1L9+ENTZcdC2rAq6M3JXDqPk023guM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6452
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
> Subject: [Intel-wired-lan] [PATCH iwl-next v4 09/13] ice: Accept LAG netd=
evs
> in bridge offloads
>=20
> Allow LAG interfaces to be used in bridge offload using netif_is_lag_mast=
er.
> In this case, search for ice netdev in the list of LAG's lower devices.
>=20
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v2: braces added in ice_eswitch_br_get_uplnik_from_lag,
>     use else in ice_eswitch_br_netdev_to_port and
>     ice_eswitch_br_port_link
> ---
>  .../net/ethernet/intel/ice/ice_eswitch_br.c   | 47 +++++++++++++++++--
>  1 file changed, 42 insertions(+), 5 deletions(-)
>=20
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>

